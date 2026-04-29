<?php

/**
 * trait -> mentions
 * 
 * @package Sngine
 * @author Zamblek
 */

trait MentionsTrait
{

  /* ------------------------------- */
  /* @Mentions */
  /* ------------------------------- */

  /**
   * decode_mentions
   * 
   * @param string $text
   * @param boolean $decode_html
   * @param boolean $plain_output
   * @return string
   */
  public function decode_mentions($text, $decode_html = false, $plain_output = false)
  {
    if (!$text) return $text;
    $pattern = ($decode_html)
      ? '/<span class="mention"[^>]*data-id="(\d+)"[^>]*>.*?<\/span>\s*<\/span>/i'
      : '/\[([a-z0-9._]+)\]/i';
    return preg_replace_callback($pattern, function ($matches) use ($decode_html, $plain_output) {
      return $this->get_mentions($matches, $decode_html, $plain_output);
    }, $text);
  }


  /**
   * get_mentions
   * 
   * @param array $matches
   * @param boolean $decode_html
   * @param boolean $plain_output
   * @return string
   */
  public function get_mentions($matches, $decode_html = false, $plain_output = false)
  {
    global $db, $system;
    if ($decode_html) {
      $get_user = $db->query(sprintf("SELECT user_id, user_name, user_firstname, user_lastname FROM users WHERE user_id = %s", secure($matches[1], 'int')));
    } else {
      $get_user = $db->query(sprintf("SELECT user_id, user_name, user_firstname, user_lastname FROM users WHERE user_name = %s", secure($matches[1])));
    }
    if ($get_user->num_rows > 0) {
      $user = $get_user->fetch_assoc();
      if ($plain_output) {
        $replacement = '[' . $user['user_name'] . ']';
      } else {
        $display_name = ($system['show_usernames_enabled']) ? $user['user_name'] : $user['user_firstname'] . " " . $user['user_lastname'];
        $replacement = popover($user['user_id'], $user['user_name'], $display_name);
      }
    } else {
      $replacement = $matches[0];
    }
    return $replacement;
  }


  /**
   * post_mentions
   * 
   * @param string $text
   * @param integer $node_url
   * @param string $node_type
   * @param string $notify_id
   * @param array $excluded_ids
   * @return void
   */
  public function post_mentions($text, $node_url, $node_type = 'post', $notify_id = '', $excluded_ids = [])
  {
    global $db;
    $where_query = "";
    if ($excluded_ids) {
      $excluded_list = $this->spread_ids($excluded_ids);
      $where_query = " user_id NOT IN ($excluded_list) AND ";
    }
    $done = [];
    if (preg_match_all('/\[([a-zA-Z0-9._]+)\]/', $text, $matches)) {
      foreach ($matches[1] as $username) {
        if ($this->_data['user_name'] != $username && !in_array($username, $done)) {
          $get_user = $db->query(sprintf("SELECT user_id FROM users WHERE " . $where_query . " user_name = %s", secure($username)));
          if ($get_user->num_rows > 0) {
            $_user = $get_user->fetch_assoc();
            $this->post_notification(['to_user_id' => $_user['user_id'], 'action' => 'mention', 'node_type' => $node_type, 'node_url' => $node_url, 'notify_id' => $notify_id]);
            $done[] = $username;
          }
        }
      }
    } else {
      if (preg_match_all('/<span class="mention"[^>]*data-id="(\d+)"[^>]*>.*?<\/span>.*?<\/span>/i', $text, $matches)) {
        foreach ($matches[1] as $user_id) {
          if ($this->_data['user_id'] != $user_id && !in_array($user_id, $done)) {
            $this->post_notification(['to_user_id' => $user_id, 'action' => 'mention', 'node_type' => $node_type, 'node_url' => $node_url, 'notify_id' => $notify_id]);
            $done[] = $user_id;
          }
        }
      }
    }
  }
}
