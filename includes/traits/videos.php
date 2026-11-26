<?php

/**
 * trait -> videos
 * 
 * @package Sngine
 * @author Zamblek
 */

trait VideosTrait
{

  /* ------------------------------- */
  /* Videos */
  /* ------------------------------- */

  /**
   * get_videos
   * 
   * @param integer $id
   * @param string $type
   * @param integer $offset
   * @return array
   */
  public function get_videos($id, $type = 'user', $offset = 0, $cursor = null)
  {
    global $db, $system;
    $videos = [];
    $schedule_query = ($system['posts_schedule_enabled']) ? " AND posts.time <= NOW()" : "";
    /* pages after the first continue from a cursor (the last video id) instead of an offset */
    $this->_cursor = null;
    $cursor = cursor_decode($cursor, ['int']);
    if ($cursor) {
      $schedule_query .= " AND " . cursor_where(['posts_videos.video_id'], $cursor);
      $offset = 0;
    }
    switch ($type) {
      case 'user':
        /* get all user videos (except videos from groups or events) */
        $offset *= $system['min_results_even'];
        $get_videos = $db->query(sprintf("SELECT posts_videos.*, posts_videos_categories.category_name, posts.privacy FROM posts_videos LEFT JOIN posts_videos_categories ON posts_videos.category_id = posts_videos_categories.category_id INNER JOIN posts ON posts_videos.post_id = posts.post_id WHERE posts.user_id = %s AND posts.user_type = 'user' AND posts.in_group = '0' AND posts.in_event = '0' AND (posts.pre_approved = '1' OR posts.has_approved = '1')" . $schedule_query . " ORDER BY posts_videos.video_id DESC LIMIT %s, %s", secure($id, 'int'), secure($offset, 'int', false), secure($system['min_results_even'], 'int', false)));
        if ($get_videos->num_rows > 0) {
          while ($video = $get_videos->fetch_assoc()) {
            $last_read_id = $video['video_id'];
            if ($this->check_privacy($video['privacy'], $id)) {
              $video['category_url'] = get_url_text($video['category_name']);
              $videos[] = $video;
            }
          }
        }
        break;

      case 'page':
        $offset *= $system['min_results_even'];
        $get_videos = $db->query(sprintf("SELECT posts_videos.*, posts_videos_categories.category_name FROM posts_videos LEFT JOIN posts_videos_categories ON posts_videos.category_id = posts_videos_categories.category_id INNER JOIN posts ON posts_videos.post_id = posts.post_id WHERE posts.user_id = %s AND posts.user_type = 'page'" . $schedule_query . " ORDER BY posts_videos.video_id DESC LIMIT %s, %s", secure($id, 'int'), secure($offset, 'int', false), secure($system['min_results_even'], 'int', false)));
        if ($get_videos->num_rows > 0) {
          while ($video = $get_videos->fetch_assoc()) {
            $last_read_id = $video['video_id'];
            $video['category_url'] = get_url_text($video['category_name']);
            $videos[] = $video;
          }
        }
        break;

      case 'group':
        /* check if the viewer is group member (approved) */
        if ($this->check_group_membership($this->_data['user_id'], $id) != "approved") {
          return $videos;
        }
        $offset *= $system['min_results_even'];
        $get_videos = $db->query(sprintf("SELECT posts_videos.*, posts_videos_categories.category_name FROM posts_videos LEFT JOIN posts_videos_categories ON posts_videos.category_id = posts_videos_categories.category_id INNER JOIN posts ON posts_videos.post_id = posts.post_id WHERE posts.group_id = %s AND posts.in_group = '1'" . $schedule_query . " ORDER BY posts_videos.video_id DESC LIMIT %s, %s", secure($id, 'int'), secure($offset, 'int', false), secure($system['min_results_even'], 'int', false)));
        if ($get_videos->num_rows > 0) {
          while ($video = $get_videos->fetch_assoc()) {
            $last_read_id = $video['video_id'];
            $video['category_url'] = get_url_text($video['category_name']);
            $videos[] = $video;
          }
        }
        break;

      case 'event':
        /* check if the viewer is event member (approved) */
        if (!$this->check_event_membership($this->_data['user_id'], $id)) {
          return $videos;
        }
        $offset *= $system['min_results_even'];
        $get_videos = $db->query(sprintf("SELECT posts_videos.*, posts_videos_categories.category_name FROM posts_videos LEFT JOIN posts_videos_categories ON posts_videos.category_id = posts_videos_categories.category_id INNER JOIN posts ON posts_videos.post_id = posts.post_id WHERE posts.event_id = %s AND posts.in_event = '1'" . $schedule_query . " ORDER BY posts_videos.video_id DESC LIMIT %s, %s", secure($id, 'int'), secure($offset, 'int', false), secure($system['min_results_even'], 'int', false)));
        if ($get_videos->num_rows > 0) {
          while ($video = $get_videos->fetch_assoc()) {
            $last_read_id = $video['video_id'];
            $video['category_url'] = get_url_text($video['category_name']);
            $videos[] = $video;
          }
        }
        break;
    }
    $this->_cursor = (isset($last_read_id)) ? cursor_encode([$last_read_id]) : null;
    return $videos;
  }


  /**
   * get_videos_count
   * 
   * @param integer $node_id
   * @param string $node_type
   * @return integer
   */
  public function get_videos_count($node_id, $node_type)
  {
    global $db, $system;
    $schedule_query = ($system['posts_schedule_enabled']) ? " AND posts.time <= NOW()" : "";
    switch ($node_type) {
      case 'user':
        $get_videos = $db->query(sprintf("SELECT COUNT(*) as count FROM posts_videos INNER JOIN posts ON posts_videos.post_id = posts.post_id WHERE posts.user_id = %s AND posts.user_type = 'user' AND posts.in_group = '0' AND posts.in_event = '0' AND (posts.pre_approved = '1' OR posts.has_approved = '1')" . $schedule_query, secure($node_id, 'int')));
        break;

      case 'page':
        $get_videos = $db->query(sprintf("SELECT COUNT(*) as count FROM posts_videos INNER JOIN posts ON posts_videos.post_id = posts.post_id WHERE posts.user_id = %s AND posts.user_type = 'page' AND (posts.pre_approved = '1' OR posts.has_approved = '1')" . $schedule_query, secure($node_id, 'int')));
        break;

      case 'group':
        $get_videos = $db->query(sprintf("SELECT COUNT(*) as count FROM posts_videos INNER JOIN posts ON posts_videos.post_id = posts.post_id WHERE posts.group_id = %s AND posts.in_group = '1' AND (posts.pre_approved = '1' OR posts.has_approved = '1')" . $schedule_query, secure($node_id, 'int')));
        break;

      case 'event':
        $get_videos = $db->query(sprintf("SELECT COUNT(*) as count FROM posts_videos INNER JOIN posts ON posts_videos.post_id = posts.post_id WHERE posts.event_id = %s AND posts.in_event = '1' AND (posts.pre_approved = '1' OR posts.has_approved = '1')" . $schedule_query, secure($node_id, 'int')));
        break;

      default:
        _error(400);
        break;
    }
    if ($get_videos->num_rows > 0) {
      $count = $get_videos->fetch_assoc();
      return $count['count'];
    }
    return 0;
  }


  /**
   * update_video_size
   * 
   * @param integer $video_id
   * @param integer $width
   * @param integer $height
   * @return void
   */
  public function update_video_size($video_id, $width, $height)
  {
    global $db;
    if (!is_numeric($width) || !is_numeric($height) || $width < 1 || $height < 1) {
      return;
    }
    /* get video */
    $get_video = $db->query(sprintf("SELECT post_id FROM posts_videos WHERE video_id = %s AND width IS NULL", secure($video_id, 'int')));
    if ($get_video->num_rows == 0) {
      return;
    }
    /* check post */
    $post = $this->get_post($get_video->fetch_assoc()['post_id'], false);
    if (!$post || !$post['manage_post']) {
      return;
    }
    $db->query(sprintf("UPDATE posts_videos SET width = %s, height = %s WHERE video_id = %s AND width IS NULL", secure(min((int) $width, 65535), 'int'), secure(min((int) $height, 65535), 'int'), secure($video_id, 'int')));
  }
}
