<?php

/**
 * trait -> stories highlights
 * 
 * @package Sngine
 * @author Zamblek
 */

trait StoriesHighlightsTrait
{

  /* ------------------------------- */
  /* Stories Highlights */
  /* ------------------------------- */

  /**
   * get_stories_highlights
   * 
   * @param integer $user_id
   * @param integer $story_id
   * @return array
   */
  public function get_stories_highlights($user_id, $story_id = null)
  {
    global $db, $system;
    $highlights = [];
    $get_highlights = $db->query(sprintf(
      "SELECT stories_highlights.*, stories.type, stories.source, stories.thumbnail, stories.background
      FROM stories_highlights
      LEFT JOIN stories ON stories_highlights.cover_story_id = stories.story_id
      WHERE stories_highlights.user_id = %s
      ORDER BY stories_highlights.highlight_id DESC
      LIMIT 50",
      secure($user_id, 'int')
    ));
    while ($highlight = $get_highlights->fetch_assoc()) {
      $cover = ($highlight['type'] == 'photo') ? $highlight['source'] : $highlight['thumbnail'];
      $highlight['cover'] = ($cover) ? $system['system_uploads'] . '/' . $cover : '';
      $highlight['has_story'] = false;
      $highlights[$highlight['highlight_id']] = $highlight;
    }
    if ($story_id && $highlights) {
      $get_items = $db->query(sprintf("SELECT highlight_id FROM stories_highlights_items WHERE story_id = %s AND highlight_id IN (%s)", secure($story_id, 'int'), implode(',', array_keys($highlights))));
      while ($item = $get_items->fetch_assoc()) {
        $highlights[$item['highlight_id']]['has_story'] = true;
      }
    }
    return array_values($highlights);
  }


  /**
   * get_stories_highlight
   * 
   * @param integer $highlight_id
   * @return array|false
   */
  public function get_stories_highlight($highlight_id)
  {
    global $db;
    $get_highlight = $db->query(sprintf("SELECT * FROM stories_highlights WHERE highlight_id = %s", secure($highlight_id, 'int')));
    if ($get_highlight->num_rows == 0) {
      return false;
    }
    return $get_highlight->fetch_assoc();
  }


  /**
   * check_my_story
   * 
   * @param integer $story_id
   * @return array
   */
  public function check_my_story($story_id)
  {
    global $db;
    $get_story = $db->query(sprintf("SELECT * FROM stories WHERE story_id = %s AND user_id = %s", secure($story_id, 'int'), secure($this->_data['user_id'], 'int')));
    if ($get_story->num_rows == 0) {
      _error(403);
    }
    return $get_story->fetch_assoc();
  }


  /**
   * create_stories_highlight
   * 
   * @param string $title
   * @param integer $story_id
   * @return void
   */
  public function create_stories_highlight($title, $story_id)
  {
    global $db, $date;
    $this->check_my_story($story_id);
    $title = trim($title);
    if (is_empty($title) || mb_strlen($title) > 30) {
      throw new ValidationException(__("Please enter a valid title, up to 30 characters"));
    }
    $count = $db->query(sprintf("SELECT COUNT(*) as count FROM stories_highlights WHERE user_id = %s", secure($this->_data['user_id'], 'int')));
    if ($count->fetch_assoc()['count'] >= 50) {
      throw new ValidationException(__("You have reached the maximum number of highlights"));
    }
    $db->query(sprintf("INSERT INTO stories_highlights (user_id, title, time) VALUES (%s, %s, %s)", secure($this->_data['user_id'], 'int'), secure($title), secure($date)));
    $this->toggle_stories_highlight($db->insert_id, $story_id);
  }


  /**
   * toggle_stories_highlight
   * 
   * @param integer $highlight_id
   * @param integer $story_id
   * @return void
   */
  public function toggle_stories_highlight($highlight_id, $story_id)
  {
    global $db;
    $this->check_my_story($story_id);
    $highlight = $this->get_stories_highlight($highlight_id);
    if (!$highlight || $highlight['user_id'] != $this->_data['user_id']) {
      _error(403);
    }
    $check = $db->query(sprintf("SELECT COUNT(*) as count FROM stories_highlights_items WHERE highlight_id = %s AND story_id = %s", secure($highlight_id, 'int'), secure($story_id, 'int')));
    if ($check->fetch_assoc()['count'] > 0) {
      $db->query(sprintf("DELETE FROM stories_highlights_items WHERE highlight_id = %s AND story_id = %s", secure($highlight_id, 'int'), secure($story_id, 'int')));
    } else {
      $count = $db->query(sprintf("SELECT COUNT(*) as count FROM stories_highlights_items WHERE highlight_id = %s", secure($highlight_id, 'int')));
      if ($count->fetch_assoc()['count'] >= 100) {
        throw new ValidationException(__("This highlight is full"));
      }
      $db->query(sprintf("INSERT INTO stories_highlights_items (highlight_id, story_id) VALUES (%s, %s)", secure($highlight_id, 'int'), secure($story_id, 'int')));
    }
    $this->refresh_stories_highlight($highlight_id);
    $this->refresh_story_highlighted($story_id);
  }


  /**
   * delete_stories_highlight
   * 
   * @param integer $highlight_id
   * @return void
   */
  public function delete_stories_highlight($highlight_id)
  {
    global $db;
    $highlight = $this->get_stories_highlight($highlight_id);
    if (!$highlight || ($highlight['user_id'] != $this->_data['user_id'] && $this->_data['user_group'] >= 3)) {
      _error(403);
    }
    $get_items = $db->query(sprintf("SELECT story_id FROM stories_highlights_items WHERE highlight_id = %s", secure($highlight_id, 'int')));
    $stories_ids = array_column($get_items->fetch_all(MYSQLI_ASSOC), 'story_id');
    $db->query(sprintf("DELETE FROM stories_highlights_items WHERE highlight_id = %s", secure($highlight_id, 'int')));
    $db->query(sprintf("DELETE FROM stories_highlights WHERE highlight_id = %s", secure($highlight_id, 'int')));
    foreach ($stories_ids as $story_id) {
      $this->refresh_story_highlighted($story_id);
    }
  }


  /**
   * refresh_stories_highlight
   * 
   * @param integer $highlight_id
   * @return void
   */
  public function refresh_stories_highlight($highlight_id)
  {
    global $db;
    $get_cover = $db->query(sprintf("SELECT story_id FROM stories_highlights_items WHERE highlight_id = %s ORDER BY id ASC LIMIT 1", secure($highlight_id, 'int')));
    if ($get_cover->num_rows == 0) {
      $db->query(sprintf("DELETE FROM stories_highlights WHERE highlight_id = %s", secure($highlight_id, 'int')));
      return;
    }
    $db->query(sprintf("UPDATE stories_highlights SET cover_story_id = %s WHERE highlight_id = %s", secure($get_cover->fetch_assoc()['story_id'], 'int'), secure($highlight_id, 'int')));
  }


  /**
   * refresh_story_highlighted
   * 
   * @param integer $story_id
   * @return void
   */
  public function refresh_story_highlighted($story_id)
  {
    global $db;
    $check = $db->query(sprintf("SELECT COUNT(*) as count FROM stories_highlights_items WHERE story_id = %s", secure($story_id, 'int')));
    $db->query(sprintf("UPDATE stories SET highlighted = %s WHERE story_id = %s", secure(($check->fetch_assoc()['count'] > 0) ? '1' : '0'), secure($story_id, 'int')));
  }
}
