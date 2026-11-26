<?php

/**
 * trait -> stories audience
 * 
 * @package Sngine
 * @author Zamblek
 */

trait StoriesAudienceTrait
{

  /* ------------------------------- */
  /* Stories Audience */
  /* ------------------------------- */

  /**
   * get_story_audience_flags
   * 
   * @param integer $author_id
   * @return array
   */
  public function get_story_audience_flags($author_id)
  {
    global $db;
    static $flags = [];
    $key = $author_id . ':' . $this->_data['user_id'];
    if (defined('SOCKET_SERVER') || !isset($flags[$key])) {
      $flags[$key] = ['close' => false, 'hidden' => false];
      $get_flags = $db->query(sprintf("SELECT type FROM stories_audience WHERE user_id = %s AND target_id = %s", secure($author_id, 'int'), secure($this->_data['user_id'], 'int')));
      while ($flag = $get_flags->fetch_assoc()) {
        $flags[$key][$flag['type']] = true;
      }
    }
    return $flags[$key];
  }


  /**
   * get_story_audience_authors
   * 
   * @param string $type
   * @return array
   */
  public function get_story_audience_authors($type)
  {
    global $db;
    $get_authors = $db->query(sprintf("SELECT user_id FROM stories_audience WHERE target_id = %s AND type = %s LIMIT 2000", secure($this->_data['user_id'], 'int'), secure($type)));
    return array_map('intval', array_column($get_authors->fetch_all(MYSQLI_ASSOC), 'user_id'));
  }


  /**
   * get_story_audience
   * 
   * @param string $type
   * @return array
   */
  public function get_story_audience($type)
  {
    global $db;
    $users = [];
    if (!in_array($type, ['close', 'hidden'])) {
      _error(400);
    }
    $get_users = $db->query(sprintf("SELECT users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, users.user_verified FROM stories_audience INNER JOIN users ON stories_audience.target_id = users.user_id WHERE stories_audience.user_id = %s AND stories_audience.type = %s ORDER BY stories_audience.id DESC LIMIT 500", secure($this->_data['user_id'], 'int'), secure($type)));
    while ($_user = $get_users->fetch_assoc()) {
      $_user['user_picture'] = get_picture($_user['user_picture'], $_user['user_gender']);
      $users[] = $_user;
    }
    return $users;
  }


  /**
   * add_story_audience
   * 
   * @param string $type
   * @param integer $target_id
   * @return void
   */
  public function add_story_audience($type, $target_id)
  {
    global $db;
    if (!in_array($type, ['close', 'hidden']) || $target_id == $this->_data['user_id'] || $this->blocked($target_id)) {
      _error(400);
    }
    $check = $db->query(sprintf("SELECT COUNT(*) as count FROM users WHERE user_id = %s", secure($target_id, 'int')));
    if ($check->fetch_assoc()['count'] == 0) {
      _error(400);
    }
    $count = $db->query(sprintf("SELECT COUNT(*) as count FROM stories_audience WHERE user_id = %s AND type = %s", secure($this->_data['user_id'], 'int'), secure($type)));
    if ($count->fetch_assoc()['count'] >= 500) {
      throw new Exception(__("You have reached the maximum number of people in this list"));
    }
    $db->query(sprintf("INSERT IGNORE INTO stories_audience (user_id, target_id, type) VALUES (%s, %s, %s)", secure($this->_data['user_id'], 'int'), secure($target_id, 'int'), secure($type)));
  }


  /**
   * remove_story_audience
   * 
   * @param string $type
   * @param integer $target_id
   * @return void
   */
  public function remove_story_audience($type, $target_id)
  {
    global $db;
    $db->query(sprintf("DELETE FROM stories_audience WHERE user_id = %s AND target_id = %s AND type = %s", secure($this->_data['user_id'], 'int'), secure($target_id, 'int'), secure($type)));
  }
}
