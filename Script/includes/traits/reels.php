<?php

/**
 * trait -> reels
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich - Handles - @sorydima @sorydev @durovshater @DmitrySoro90935 @tanechfund - also check https://dmitry.rechain.network for more information!
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
   * @return array
   */
  public function get_reels($id, $type = 'user', $offset = 0)
  {
    global $db, $system;
    $reels = [];
    switch ($type) {
      case 'user':
        /* get all user reels (except reels from groups or events) */
        $offset *= $system['min_results_even'];
        $get_reels = $db->query(sprintf("SELECT posts_reels.*, posts.privacy FROM posts_reels INNER JOIN posts ON posts_reels.post_id = posts.post_id WHERE posts.user_id = %s AND posts.user_type = 'user' AND posts.in_group = '0' AND posts.in_event = '0' AND (posts.pre_approved = '1' OR posts.has_approved = '1') ORDER BY posts_reels.reel_id DESC LIMIT %s, %s", secure($id, 'int'), secure($offset, 'int', false), secure($system['min_results_even'], 'int', false)));
        if ($get_reels->num_rows > 0) {
          while ($reel = $get_reels->fetch_assoc()) {
            if ($this->check_privacy($reel['privacy'], $id)) {
              $reels[] = $reel;
            }
          }
        }
        break;

      case 'page':
        $offset *= $system['min_results_even'];
        $get_reels = $db->query(sprintf("SELECT posts_reels.* FROM posts_reels INNER JOIN posts ON posts_reels.post_id = posts.post_id WHERE posts.user_id = %s AND posts.user_type = 'page' ORDER BY posts_reels.reel_id DESC LIMIT %s, %s", secure($id, 'int'), secure($offset, 'int', false), secure($system['min_results_even'], 'int', false)));
        if ($get_reels->num_rows > 0) {
          while ($reel = $get_reels->fetch_assoc()) {
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
        $get_reels = $db->query(sprintf("SELECT posts_reels.* FROM posts_reels INNER JOIN posts ON posts_reels.post_id = posts.post_id WHERE posts.group_id = %s AND posts.in_group = '1' ORDER BY posts_reels.reel_id DESC LIMIT %s, %s", secure($id, 'int'), secure($offset, 'int', false), secure($system['min_results_even'], 'int', false)));
        if ($get_reels->num_rows > 0) {
          while ($reel = $get_reels->fetch_assoc()) {
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
        $get_reels = $db->query(sprintf("SELECT posts_reels.* FROM posts_reels INNER JOIN posts ON posts_reels.post_id = posts.post_id WHERE posts.event_id = %s AND posts.in_event = '1' ORDER BY posts_reels.reel_id DESC LIMIT %s, %s", secure($id, 'int'), secure($offset, 'int', false), secure($system['min_results_even'], 'int', false)));
        if ($get_reels->num_rows > 0) {
          while ($reel = $get_reels->fetch_assoc()) {
            $reels[] = $reel;
          }
        }
        break;

      default:
        _error(400);
        break;
    }
    return $reels;
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
    global $db;
    switch ($node_type) {
      case 'user':
        $get_reels = $db->query(sprintf("SELECT COUNT(*) as count FROM posts_reels INNER JOIN posts ON posts_reels.post_id = posts.post_id WHERE posts.user_id = %s AND posts.user_type = 'user' AND posts.in_group = '0' AND posts.in_event = '0' AND (posts.pre_approved = '1' OR posts.has_approved = '1')", secure($node_id, 'int')));
        break;

      case 'page':
        $get_reels = $db->query(sprintf("SELECT COUNT(*) as count FROM posts_reels INNER JOIN posts ON posts_reels.post_id = posts.post_id WHERE posts.user_id = %s AND posts.user_type = 'page' AND (posts.pre_approved = '1' OR posts.has_approved = '1')", secure($node_id, 'int')));
        break;

      case 'group':
        $get_reels = $db->query(sprintf("SELECT COUNT(*) as count FROM posts_reels INNER JOIN posts ON posts_reels.post_id = posts.post_id WHERE posts.group_id = %s AND posts.in_group = '1' AND (posts.pre_approved = '1' OR posts.has_approved = '1')", secure($node_id, 'int')));
        break;

      case 'event':
        $get_reels = $db->query(sprintf("SELECT COUNT(*) as count FROM posts_reels INNER JOIN posts ON posts_reels.post_id = posts.post_id WHERE posts.event_id = %s AND posts.in_event = '1' AND (posts.pre_approved = '1' OR posts.has_approved = '1')", secure($node_id, 'int')));
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
