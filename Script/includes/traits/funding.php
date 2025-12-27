<?php

/**
 * trait -> funding
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich
 */

trait FundingTrait
{

  /* ------------------------------- */
  /* Funding */
  /* ------------------------------- */

  /**
   * get_funding
   * 
   * @param array $args
   * @return array
   */
  public function get_funding($args = [])
  {
    global $db, $system;
    /* initialize arguments */
    $country = !isset($args['country']) ? null : $args['country'];
    $offset = !isset($args['offset']) ? 0 : $args['offset'];
    $results = !isset($args['results']) ? $system['funding_results'] : $args['results'];
    /* initialize vars */
    $posts = [];
    $offset *= $results;
    /* prepare country statement */
    if ($country && $system['newsfeed_location_filter_enabled'] && $country != "all") {
      $country_query .= sprintf(" AND ( (posts.user_type = 'user' AND user_post_author.user_country = %s) OR (posts.user_type = 'page' AND page_post_author.page_country = %s) )", secure($country, 'int'), secure($country, 'int'));
    }
    /* get posts */
    $get_posts = $db->query(sprintf("SELECT posts.post_id FROM posts INNER JOIN posts_funding ON posts.post_id = posts_funding.post_id INNER JOIN users ON posts.user_id = users.user_id and posts.user_type = 'user' LEFT JOIN users AS user_post_author ON posts.user_type = 'user' AND posts.user_id = user_post_author.user_id AND user_post_author.user_banned = '0' LEFT JOIN pages AS page_post_author ON posts.user_type = 'page' AND posts.user_id = page_post_author.page_id WHERE posts.post_type = 'funding' AND (posts.pre_approved = '1' OR posts.has_approved = '1') " . $country_query . " ORDER BY posts.post_id DESC LIMIT %s, %s", secure($offset, 'int', false), secure($results, 'int', false)));
    if ($get_posts->num_rows > 0) {
      while ($post = $get_posts->fetch_assoc()) {
        $post = $this->get_post($post['post_id']);
        if ($post) {
          $posts[] = $post;
        }
      }
    }
    return $posts;
  }


  /**
   * funding_donation
   * 
   * @param integer $post_id
   * @param integer $donation_amount
   * @param integer $donor_id
   * @return void
   */
  public function funding_donation($post_id, $donation_amount, $donor_id = null)
  {
    global $db, $system, $date;
    /* (check|get) post */
    $post = $this->get_post($post_id);
    if (!$post) {
      _error(400);
    }
    /* check doner */
    $donor_id = ($donor_id) ? $donor_id : $this->_data['user_id'];
    /* prepare commission */
    $commission = ($system['funding_commission']) ? $donation_amount * ($system['funding_commission'] / 100) : 0;
    $donation_amount = $donation_amount - $commission;
    /* update funding request */
    $db->query(sprintf("UPDATE posts_funding SET raised_amount = raised_amount + %s, total_donations = total_donations + 1 WHERE post_id = %s", secure($donation_amount), secure($post_id, 'int')));
    /* insert donor */
    $db->query(sprintf("INSERT INTO posts_funding_donors (user_id, post_id, donation_amount, donation_time) VALUES (%s, %s, %s, %s)", secure($donor_id, 'int'), secure($post_id, 'int'), secure($donation_amount), secure($date)));
    /* increase target user funding balance */
    $db->query(sprintf("UPDATE users SET user_funding_balance = user_funding_balance + %s WHERE user_id = %s", secure($donation_amount), secure($post['author_id'], 'int')));
    /* log commission */
    $this->log_commission($post['author_id'], $commission, 'donate');
    /* send notification to the post author */
    $this->post_notification(['to_user_id' => $post['author_id'], 'action' => 'funding_donation', 'node_type' => $donation_amount, 'node_url' => $post_id]);
  }
}
