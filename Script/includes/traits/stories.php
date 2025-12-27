<?php

/**
 * trait -> stories
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich
 */

trait StoriesTrait
{

  /* ------------------------------- */
  /* Stories */
  /* ------------------------------- */

  /**
   * post_story
   * 
   * @param string $message
   * @param array $photos
   * @param array $videos
   * @param int $is_ads
   * @return void
   */
  public function post_story($message, $photos, $videos, $is_ads = 0)
  {
    global $db, $system, $date;
    /* check stories permission */
    if (!$this->_data['can_add_stories']) {
      throw new Exception(__("You don't have the permission to do this"));
    }
    /* check latest story */
    $get_last_story = $db->query(sprintf("SELECT story_id FROM stories WHERE time >= DATE_SUB(NOW(), INTERVAL 1 DAY) AND stories.user_id = %s", secure($this->_data['user_id'], 'int')));
    if ($get_last_story->num_rows > 0) {
      /* get story_id */
      $story_id = $get_last_story->fetch_assoc()['story_id'];
      /* update story time */
      $db->query(sprintf("UPDATE stories SET is_ads = %s, time = %s WHERE story_id = %s", secure($is_ads), secure($date), secure($story_id, 'int')));
    } else {
      /* insert new story */
      $db->query(sprintf("INSERT INTO stories (user_id, is_ads, time) VALUES (%s, %s, %s)", secure($this->_data['user_id'], 'int'), secure($is_ads), secure($date)));
      /* get story_id */
      $story_id = $db->insert_id;
    }
    /* prepare message */
    $message = strip_tags(html_entity_decode($message, ENT_QUOTES, 'UTF-8'));
    /* insert story media items */
    foreach ($photos as $photo) {
      $db->query(sprintf("INSERT INTO stories_media (story_id, source, text, time) VALUES (%s, %s, %s, %s)", secure($story_id, 'int'), secure($photo['source']), secure($message), secure($date)));
    }
    foreach ($videos as $video) {
      $db->query(sprintf("INSERT INTO stories_media (story_id, source, is_photo, text, time) VALUES (%s, %s, '0', %s, %s)", secure($story_id, 'int'), secure($video), secure($message), secure($date)));
    }
    /* remove pending uploads */
    remove_pending_uploads([...array_column($photos, 'source'), ...$videos]);
  }


  /**
   * get_stories
   * 
   * @return array
   */
  public function get_stories()
  {
    global $db, $system;
    $stories = [];
    /* stories source */
    $friends_followings_ids = ($system['friends_enabled']) ? $this->spread_ids($this->_data['friends_ids']) : $this->spread_ids($this->_data['followings_ids']);
    $source_query = ($system['newsfeed_source'] == "default") ? sprintf(" AND ( is_ads = '1' OR stories.user_id = %s OR stories.user_id IN (%s)) ", $this->_data['user_id'], $friends_followings_ids) : "";
    /* get stories */
    $get_stories = $db->query("SELECT stories.*, users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM stories INNER JOIN users ON stories.user_id = users.user_id WHERE time >= DATE_SUB(NOW(), INTERVAL 1 DAY) $source_query ORDER BY is_ads = '1' DESC, stories.story_id DESC");
    if ($get_stories->num_rows > 0) {
      while ($_story = $get_stories->fetch_assoc()) {
        $story['id'] = "user_" . $_story['story_id'];
        $story['photo'] = get_picture($_story['user_picture'], $_story['user_gender']);
        $story['name'] = ($system['show_usernames_enabled']) ? $_story['user_name'] : $_story['user_firstname'] . " " . $_story['user_lastname'];
        $story['lastUpdated'] = strtotime($_story['time']);
        $story['items'] = [];
        /* get story media items */
        $get_media_items = $db->query(sprintf("SELECT * FROM stories_media WHERE story_id = %s", secure($_story['story_id'], 'int')));
        while ($media_item = $get_media_items->fetch_assoc()) {
          $story_item['id'] = "media_" . $media_item['media_id'];
          $story_item['type'] = ($media_item['is_photo']) ? 'photo' : 'video';
          $story_item['src'] = $system['system_uploads'] . '/' . $media_item['source'];
          $story_item['preview'] = ($media_item['is_photo']) ? $system['system_uploads'] . '/' . $media_item['source'] : $story['photo'];
          $story_item['link'] = '.';
          $story_item['linkText'] = strip_tags(html_entity_decode($media_item['text'], ENT_QUOTES, 'UTF-8'));
          $story_item['time'] = strtotime($media_item['time']);
          $story_item['length'] = $system['stories_duration'];
          $story['items'][] = $story_item;
        }
        $stories[] = $story;
      }
    }
    return ["array" => $stories, "json" => json_encode($stories)];
  }


  /**
   * get_my_story
   * 
   * @return boolean
   */
  public function get_my_story()
  {
    global $db, $system;
    $get_my_story = $db->query(sprintf("SELECT COUNT(*) as count FROM stories WHERE time >= DATE_SUB(NOW(), INTERVAL 1 DAY) AND user_id = %s", secure($this->_data['user_id'], 'int')));
    if ($get_my_story->fetch_assoc()['count'] == 0) {
      return false;
    } else {
      return true;
    }
  }


  /**
   * delete_my_story
   * 
   * @param boolean $delete_media
   * @return void
   */
  public function delete_my_story($delete_media = false)
  {
    global $db;
    /* get story */
    $get_story = $db->query(sprintf("SELECT * FROM stories WHERE time >= DATE_SUB(NOW(), INTERVAL 1 DAY) AND user_id = %s", secure($this->_data['user_id'], 'int')));
    if ($get_story->num_rows > 0) {
      $story = $get_story->fetch_assoc();
      if ($delete_media) {
        /* get story media items */
        $get_media_items = $db->query(sprintf("SELECT * FROM stories_media WHERE story_id = %s", secure($story['story_id'], 'int')));
        if ($get_media_items->num_rows > 0) {
          while ($media_item = $get_media_items->fetch_assoc()) {
            /* delete media item from uploads folder */
            delete_uploads_file($media_item['source']);
          }
        }
      }
      /* delete story */
      $db->query(sprintf("DELETE FROM stories WHERE story_id = %s", secure($story['story_id'], 'int')));
      /* delete story media items */
      $db->query(sprintf("DELETE FROM stories_media WHERE story_id = %s", secure($story['story_id'], 'int')));
    }
  }
}
