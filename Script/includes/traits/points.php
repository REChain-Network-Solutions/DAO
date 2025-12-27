<?php

/**
 * trait -> points
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich
 */

trait PointsTrait
{

  /* ------------------------------- */
  /* Points System */
  /* ------------------------------- */

  /**
   * points_balance
   * 
   * @param string $type
   * @param integer $user_id
   * @param string $node_type
   * @param integer $node_id
   * @return void
   */
  public function points_balance($type, $user_id, $node_type, $node_id = null, $points = null)
  {
    global $db, $system;
    /* check if points enabled */
    if (!$system['points_enabled']) {
      return;
    }
    switch ($node_type) {
      case 'post':
        $points_per_node = $system['points_per_post'];
        break;

      case 'post_view':
        $points_per_node = $system['points_per_post_view'];
        break;

      case 'post_comment':
        $points_per_node = $system['points_per_post_comment'];
        break;

      case 'post_reaction':
        $points_per_node = $system['points_per_post_reaction'];
        break;

      case 'comment':
        $points_per_node = $system['points_per_comment'];
        break;

      case 'posts_reactions':
      case 'posts_photos_reactions':
      case 'posts_comments_reactions':
        $points_per_node = $system['points_per_reaction'];
        break;

      case 'follow':
        $points_per_node = $system['points_per_follow'];
        break;

      case 'referred':
        $points_per_node = $system['points_per_referred'];
        break;

      case 'gift':
        $points_per_node = $points;
        break;
    }
    switch ($type) {
      case 'add':
        /* check if points per node is greater than 0 */
        if ($points_per_node <= 0) {
          return;
        }
        /* check user daily limits */
        if ($this->get_remaining_points($user_id) == 0) {
          return;
        }
        /* add points */
        $db->query(sprintf("UPDATE users SET user_points = user_points + %s WHERE user_id = %s", secure($points_per_node, 'float'), secure($user_id, 'int')));
        /* update the node as earned */
        switch ($node_type) {
          case 'post':
            $db->query(sprintf("UPDATE posts SET points_earned = '1' WHERE post_id = %s", secure($node_id, 'int')));
            break;

          case 'comment':
            $db->query(sprintf("UPDATE posts_comments SET points_earned = '1' WHERE comment_id = %s", secure($node_id, 'int')));
            break;

          case 'posts_reactions':
            $db->query(sprintf("UPDATE posts_reactions SET points_earned = '1' WHERE id = %s", secure($node_id, 'int')));
            break;

          case 'posts_photos_reactions':
            $db->query(sprintf("UPDATE posts_photos_reactions SET points_earned = '1' WHERE id = %s", secure($node_id, 'int')));
            break;

          case 'posts_comments_reactions':
            $db->query(sprintf("UPDATE posts_comments_reactions SET points_earned = '1' WHERE id = %s", secure($node_id, 'int')));
            break;

          case 'follow':
            $db->query(sprintf("UPDATE followings SET points_earned = '1' WHERE following_id = %s AND user_id = %s", secure($user_id, 'int'), secure($node_id, 'int')));

          case 'referred':
            $db->query(sprintf("UPDATE users SET points_earned = '1' WHERE user_referrer_id = %s AND user_id = %s", secure($user_id, 'int'), secure($node_id, 'int')));
            break;
        }
        /* log the points */
        $db->query(sprintf("INSERT INTO log_points (user_id, node_id, node_type, points, time) VALUES (%s, %s, %s, %s, %s)", secure($user_id, 'int'), secure($node_id, 'int'), secure($node_type), secure($points_per_node, 'float'), secure(date('Y-m-d H:i:s'))));
        break;

      case 'delete':
        /* delete points */
        $db->query(sprintf('UPDATE users SET user_points = IF(user_points-%1$s<=0,0,user_points-%1$s) WHERE user_id = %2$s', secure($points_per_node, 'float'), secure($user_id, 'int')));
        /* log the points */
        $db->query(sprintf("INSERT INTO log_points (user_id, node_id, node_type, points, time, is_added) VALUES (%s, %s, %s, %s, %s, '0')", secure($user_id, 'int'), secure($node_id, 'int'), secure($node_type), secure($points_per_node, 'float'), secure(date('Y-m-d H:i:s'))));
        break;
    }
  }


  /**
   * get_remaining_points
   * 
   * @param integer $user_id
   * @return integer
   */
  public function get_remaining_points($user_id)
  {
    global $db, $system;
    /* posts */
    $get_posts = $db->query(sprintf("SELECT COUNT(*) as count FROM posts WHERE points_earned = '1' AND posts.time >= DATE_SUB(NOW(),INTERVAL 1 DAY) AND user_id = %s AND user_type = 'user'", secure($user_id, 'int')));
    $total_posts_points = $get_posts->fetch_assoc()['count'] * $system['points_per_post'];
    /* comments */
    $get_comments = $db->query(sprintf("SELECT COUNT(*) as count FROM posts_comments WHERE points_earned = '1' AND posts_comments.time >= DATE_SUB(NOW(),INTERVAL 1 DAY) AND user_id = %s AND user_type = 'user'", secure($user_id, 'int')));
    $total_comments_points = $get_comments->fetch_assoc()['count'] * $system['points_per_comment'];
    /* reactions */
    $total_reactions_points = 0;
    $get_reactions_posts = $db->query(sprintf("SELECT COUNT(*) as count FROM posts_reactions WHERE points_earned = '1' AND posts_reactions.reaction_time >= DATE_SUB(NOW(),INTERVAL 1 DAY) AND user_id = %s", secure($user_id, 'int')));
    $total_reactions_points += $get_reactions_posts->fetch_assoc()['count'];
    $get_reactions_photos = $db->query(sprintf("SELECT COUNT(*) as count FROM posts_photos_reactions WHERE points_earned = '1' AND posts_photos_reactions.reaction_time >= DATE_SUB(NOW(),INTERVAL 1 DAY) AND user_id = %s", secure($user_id, 'int')));
    $total_reactions_points += $get_reactions_photos->fetch_assoc()['count'];
    $get_reactions_comments = $db->query(sprintf("SELECT COUNT(*) as count FROM posts_comments_reactions WHERE points_earned = '1' AND posts_comments_reactions.reaction_time >= DATE_SUB(NOW(),INTERVAL 1 DAY) AND user_id = %s", secure($user_id, 'int')));
    $total_reactions_points += $get_reactions_comments->fetch_assoc()['count'];
    $total_reactions_points *= $system['points_per_reaction'];
    /* followers */
    $get_followers = $db->query(sprintf("SELECT COUNT(*) as count FROM followings WHERE points_earned = '1' AND followings.time >= DATE_SUB(NOW(),INTERVAL 1 DAY) AND following_id = %s", secure($user_id, 'int')));
    $total_followers_points = $get_followers->fetch_assoc()['count'] * $system['points_per_follow'];
    /* affiliates */
    $get_affiliates = $db->query(sprintf("SELECT COUNT(*) as count FROM users WHERE points_earned = '1' AND user_registered >= DATE_SUB(NOW(),INTERVAL 1 DAY) AND user_referrer_id = %s", secure($user_id, 'int')));
    $total_affiliates_points = $get_affiliates->fetch_assoc()['count'] * $system['points_per_referred'];
    /* total daily points*/
    $total_daily_points = $total_posts_points + $total_comments_points + $total_reactions_points + $total_followers_points + $total_affiliates_points;
    /* total daily limit */
    $total_daily_limit = ($system['packages_enabled'] && $this->_data['user_subscribed']) ? $system['points_limit_pro'] : $system['points_limit_user'];
    /* return remaining points */
    $remaining_points = $total_daily_limit - $total_daily_points;
    return ($remaining_points > 0) ? $remaining_points : 0;
  }


  /**
   * reset_all_users_points
   * 
   * @return void
   */
  public function reset_all_users_points()
  {
    global $db;
    $db->query("UPDATE users SET user_points = '0'");
    /* clear posts */
    $db->query("UPDATE posts SET points_earned = '0'");
    /* clear posts comments */
    $db->query("UPDATE posts_comments SET points_earned = '0'");
    /* clear posts reactions */
    $db->query("UPDATE posts_reactions SET points_earned = '0'");
    /* clear photos reactions */
    $db->query("UPDATE posts_photos_reactions SET points_earned = '0'");
    /* clear comments reactions */
    $db->query("UPDATE posts_comments_reactions SET points_earned = '0'");
    /* clear followers */
    $db->query("UPDATE followings SET points_earned = '0'");
    /* clear affiliates */
    $db->query("UPDATE users SET points_earned = '0'");
  }


  public function get_points_transactions()
  {
    global $db, $system;
    $transactions = [];
    $get_transactions = $db->query(sprintf("SELECT * FROM log_points WHERE user_id = %s ORDER BY time DESC LIMIT 50", secure($this->_data['user_id'], 'int')));
    if ($get_transactions->num_rows > 0) {
      while ($transaction = $get_transactions->fetch_assoc()) {
        $transaction['node'] = $this->get_post($transaction['node_id']);
        $transactions[] = $transaction;
      }
    }
    return $transactions;
  }
}
