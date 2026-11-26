<?php

/**
 * trait -> reels
 * 
 * @package Sngine
 * @author Zamblek
 */

trait ReelsTrait
{

  /* ------------------------------- */
  /* Reels */
  /* ------------------------------- */

  /**
   * get_reels
   * 
   * @param integer $id
   * @param string $type
   * @param integer $offset
   * @param string $cursor
   * @return array
   */
  public function get_reels($id, $type = 'user', $offset = 0, $cursor = null)
  {
    global $db, $system;
    $reels = [];
    $schedule_query = ($system['posts_schedule_enabled']) ? " AND posts.time <= NOW()" : "";
    /* exclude processing reels */
    $schedule_query .= " AND posts.processing != '1'";
    /* pages after the first continue from a cursor (the last reel id) instead of an offset */
    $this->_cursor = null;
    $cursor = cursor_decode($cursor, ['int']);
    if ($cursor) {
      $schedule_query .= " AND " . cursor_where(['posts_reels.reel_id'], $cursor);
      $offset = 0;
    }
    switch ($type) {
      case 'user':
        /* get all user reels (except reels from groups or events) */
        $offset *= $system['min_results_even'];
        /* get the privacy the viewer can see */
        $privacy_query = " AND posts.privacy = 'public'";
        if ($this->_logged_in) {
          if ($this->_data['user_group'] < 3 || $id == $this->_data['user_id']) {
            $privacy_query = "";
          } elseif ($this->friendship_approved($id)) {
            $privacy_query = " AND posts.privacy IN ('public', 'friends')";
          }
        }
        $get_reels = $db->query(sprintf("SELECT posts_reels.*, posts.privacy FROM posts_reels INNER JOIN posts ON posts_reels.post_id = posts.post_id WHERE posts.user_id = %s AND posts.user_type = 'user' AND posts.in_group = '0' AND posts.in_event = '0' AND (posts.pre_approved = '1' OR posts.has_approved = '1')" . $privacy_query . $schedule_query . " ORDER BY posts_reels.reel_id DESC LIMIT %s, %s", secure($id, 'int'), secure($offset, 'int', false), secure($system['min_results_even'], 'int', false)));
        if ($get_reels->num_rows > 0) {
          while ($reel = $get_reels->fetch_assoc()) {
            $last_read_id = $reel['reel_id'];
            $reels[] = $reel;
          }
        }
        break;

      case 'page':
        $offset *= $system['min_results_even'];
        $get_reels = $db->query(sprintf("SELECT posts_reels.* FROM posts_reels INNER JOIN posts ON posts_reels.post_id = posts.post_id WHERE posts.user_id = %s AND posts.user_type = 'page' AND (posts.pre_approved = '1' OR posts.has_approved = '1')" . $schedule_query . " ORDER BY posts_reels.reel_id DESC LIMIT %s, %s", secure($id, 'int'), secure($offset, 'int', false), secure($system['min_results_even'], 'int', false)));
        if ($get_reels->num_rows > 0) {
          while ($reel = $get_reels->fetch_assoc()) {
            $last_read_id = $reel['reel_id'];
            $reels[] = $reel;
          }
        }
        break;

      case 'group':
        /* check if the viewer is group member (approved) */
        if ($this->check_group_membership($this->_data['user_id'], $id) != "approved") {
          return $reels;
        }
        $offset *= $system['min_results_even'];
        $get_reels = $db->query(sprintf("SELECT posts_reels.* FROM posts_reels INNER JOIN posts ON posts_reels.post_id = posts.post_id WHERE posts.group_id = %s AND posts.in_group = '1' AND posts.group_approved = '1' AND (posts.pre_approved = '1' OR posts.has_approved = '1')" . $schedule_query . " ORDER BY posts_reels.reel_id DESC LIMIT %s, %s", secure($id, 'int'), secure($offset, 'int', false), secure($system['min_results_even'], 'int', false)));
        if ($get_reels->num_rows > 0) {
          while ($reel = $get_reels->fetch_assoc()) {
            $last_read_id = $reel['reel_id'];
            $reels[] = $reel;
          }
        }
        break;

      case 'event':
        /* check if the viewer is event member (approved) */
        if (!$this->check_event_membership($this->_data['user_id'], $id)) {
          return $reels;
        }
        $offset *= $system['min_results_even'];
        $get_reels = $db->query(sprintf("SELECT posts_reels.* FROM posts_reels INNER JOIN posts ON posts_reels.post_id = posts.post_id WHERE posts.event_id = %s AND posts.in_event = '1' AND posts.event_approved = '1' AND (posts.pre_approved = '1' OR posts.has_approved = '1')" . $schedule_query . " ORDER BY posts_reels.reel_id DESC LIMIT %s, %s", secure($id, 'int'), secure($offset, 'int', false), secure($system['min_results_even'], 'int', false)));
        if ($get_reels->num_rows > 0) {
          while ($reel = $get_reels->fetch_assoc()) {
            $last_read_id = $reel['reel_id'];
            $reels[] = $reel;
          }
        }
        break;

      default:
        _error(400);
        break;
    }
    $this->_cursor = (isset($last_read_id)) ? cursor_encode([$last_read_id]) : null;
    return $reels;
  }


  /**
   * get_reels_feed
   * 
   * @param array $args
   * @return array
   */
  public function get_reels_feed($args = [])
  {
    global $db, $system;
    /* initialize vars */
    $reels = [];
    $this->_cursor = null;
    /* validate arguments */
    $tab = (isset($args['tab']) && $args['tab'] == 'following' && $this->_logged_in) ? 'following' : 'for_you';
    $max_results = !isset($args['results']) ? 8 : $args['results'];
    $light = !empty($args['light']);
    $cursor = cursor_decode($args['cursor'] ?? null, ['int']);
    /* prepare query */
    $public_query = "(posts.privacy = 'public' AND ((posts.in_group = '0' AND posts.in_event = '0') OR (posts.in_group = '1' AND posts.group_approved = '1') OR (posts.in_event = '1' AND posts.event_approved = '1')))";
    if ($tab == 'following') {
      $where_query = "WHERE (" . $this->newsfeed_sources_clause('default') . ")";
    } elseif ($this->_logged_in) {
      $where_query = "WHERE ((" . $this->newsfeed_sources_clause('default') . ") OR " . $public_query . ")";
    } else {
      $where_query = "WHERE " . $public_query;
    }
    /* exclude viewer hidden posts from results */
    if ($this->_logged_in) {
      $where_query .= sprintf(" AND (posts.post_id NOT IN (SELECT post_id FROM posts_hidden WHERE user_id = %s))", secure($this->_data['user_id'], 'int'));
    }
    /* exclude banned users posts */
    $author_join = " LEFT JOIN users AS user_post_author ON posts.user_type = 'user' AND posts.user_id = user_post_author.user_id ";
    $where_query .= " AND (posts.user_type != 'user' OR IFNULL(user_post_author.user_banned, 0) = 0)";
    /* exclude processing posts */
    $where_query .= " AND (posts.processing != '1')";
    /* prepare approval system */
    if ($system['posts_approval_enabled']) {
      $where_query .= " AND (posts.pre_approved = '1' OR posts.has_approved = '1')";
    }
    /* posts scheduling system */
    if ($system['posts_schedule_enabled']) {
      $where_query .= " AND posts.time <= NOW()";
    }
    /* exclude the pinned reel */
    if (isset($args['exclude']) && is_numeric($args['exclude'])) {
      $where_query .= sprintf(" AND posts.post_id != %s", secure($args['exclude'], 'int'));
    }
    /* get reels (a page with only locked reels continues to the next one) */
    for ($round = 0; $round < 3 && !$reels; $round++) {
      $cursor_query = ($cursor) ? " AND " . cursor_where(['posts_reels.reel_id'], $cursor) : "";
      $get_reels = $db->query("SELECT posts_reels.* FROM posts_reels INNER JOIN posts ON posts_reels.post_id = posts.post_id " . $author_join . $where_query . $cursor_query . sprintf(" ORDER BY posts_reels.reel_id DESC LIMIT %s", secure($max_results, 'int', false)));
      if ($get_reels->num_rows == 0) {
        break;
      }
      $reels_rows = $get_reels->fetch_all(MYSQLI_ASSOC);
      $last_row = end($reels_rows);
      $cursor = [(string) $last_row['reel_id']];
      if ($light) {
        foreach ($reels_rows as $reel) {
          $reel['views_formatted'] = abbreviate_count($reel['views']);
          $reels[] = $reel;
        }
      } else {
        /* load the viewer's state for all posts at once */
        $previous_prefetch = $this->_posts_prefetch;
        $this->prefetch_posts(array_column($reels_rows, 'post_id'), false);
        try {
          foreach ($reels_rows as $reel) {
            $post = $this->get_post($reel['post_id'], false, true, true);
            if ($post && $post['reel'] && !$this->reel_locked($post)) {
              $reels[] = $post;
            }
          }
        } finally {
          $this->_posts_prefetch = $previous_prefetch;
        }
      }
    }
    /* randomize the page */
    if ($tab == 'for_you') {
      shuffle($reels);
    }
    /* the position after the last reel read (set last: loading the posts runs other lists) */
    $this->_cursor = ($cursor) ? cursor_encode($cursor) : null;
    return $reels;
  }


  /**
   * reel_locked
   * 
   * @param array $post
   * @return boolean
   */
  public function reel_locked($post)
  {
    return !$post['can_get_details'] || $post['needs_payment'] || $post['needs_subscription'] || $post['needs_pro_package'] || $post['needs_age_verification'];
  }


  /**
   * count_reel_view
   * 
   * @param array $post
   * @return void
   */
  public function count_reel_view($post)
  {
    $reel_id = $post['reel']['reel_id'];
    /* skip repeat views */
    $viewer = ($this->_logged_in) ? 'u' . $this->_data['user_id'] : 'g' . md5(get_user_ip());
    $counted = redis_run(function ($redis) use ($reel_id, $viewer) {
      return (bool) $redis->set(redis_key('reel_views:seen:' . $reel_id . ':' . $viewer), '1', 'EX', 86400, 'NX');
    }, null);
    if ($counted === null) {
      $seen = $_SESSION['reels_seen'] ?? [];
      $counted = !in_array($reel_id, $seen);
      if ($counted) {
        $seen[] = $reel_id;
        $_SESSION['reels_seen'] = array_slice($seen, -200);
      }
    }
    if ($counted) {
      $this->update_media_views('reel', $reel_id);
    }
  }


  /**
   * get_reels_count
   * 
   * @param integer $node_id
   * @param string $node_type
   * @return integer
   */
  public function get_reels_count($node_id, $node_type)
  {
    global $db, $system;
    $schedule_query = ($system['posts_schedule_enabled']) ? " AND posts.time <= NOW()" : "";
    /* exclude processing reels */
    $schedule_query .= " AND posts.processing != '1'";
    switch ($node_type) {
      case 'user':
        $get_reels = $db->query(sprintf("SELECT COUNT(*) as count FROM posts_reels INNER JOIN posts ON posts_reels.post_id = posts.post_id WHERE posts.user_id = %s AND posts.user_type = 'user' AND posts.in_group = '0' AND posts.in_event = '0' AND (posts.pre_approved = '1' OR posts.has_approved = '1')" . $schedule_query, secure($node_id, 'int')));
        break;

      case 'page':
        $get_reels = $db->query(sprintf("SELECT COUNT(*) as count FROM posts_reels INNER JOIN posts ON posts_reels.post_id = posts.post_id WHERE posts.user_id = %s AND posts.user_type = 'page' AND (posts.pre_approved = '1' OR posts.has_approved = '1')" . $schedule_query, secure($node_id, 'int')));
        break;

      case 'group':
        $get_reels = $db->query(sprintf("SELECT COUNT(*) as count FROM posts_reels INNER JOIN posts ON posts_reels.post_id = posts.post_id WHERE posts.group_id = %s AND posts.in_group = '1' AND posts.group_approved = '1' AND (posts.pre_approved = '1' OR posts.has_approved = '1')" . $schedule_query, secure($node_id, 'int')));
        break;

      case 'event':
        $get_reels = $db->query(sprintf("SELECT COUNT(*) as count FROM posts_reels INNER JOIN posts ON posts_reels.post_id = posts.post_id WHERE posts.event_id = %s AND posts.in_event = '1' AND posts.event_approved = '1' AND (posts.pre_approved = '1' OR posts.has_approved = '1')" . $schedule_query, secure($node_id, 'int')));
        break;

      default:
        _error(400);
        break;
    }
    if ($get_reels->num_rows > 0) {
      $count = $get_reels->fetch_assoc();
      return $count['count'];
    }
    return 0;
  }
}
