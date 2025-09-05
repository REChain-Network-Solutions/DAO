<?php

/**
 * trait -> mentions
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich - Handles - @sorydima @sorydev @durovshater @DmitrySoro90935 @tanechfund - also check https://dmitry.rechain.network for more information!
 */

trait MentionsTrait
{

  /* ------------------------------- */
  /* @Mentions */
  /* ------------------------------- */

  /**
   * decode_mention
   * 
   * @param string $text
   * @return string
   */
  function decode_mention($text)
  {
    global $user;
    $text = ($text) ? preg_replace_callback('/\[([a-z0-9._]+)\]/i', [$this, 'get_mentions'], $text) : $text;
    return $text;
  }


  /**
   * get_mentions
   * 
   * @param array $matches
   * @return string
   */
  public function get_mentions($matches)
  {
    global $db, $system;
    $get_user = $db->query(sprintf("SELECT user_id, user_name, user_firstname, user_lastname FROM users WHERE user_name = %s", secure($matches[1])));
    if ($get_user->num_rows > 0) {
      $user = $get_user->fetch_assoc();
      $replacement = popover($user['user_id'], $user['user_name'], ($system['show_usernames_enabled']) ? $user['user_name'] : $user['user_firstname'] . " " . $user['user_lastname']);
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
    }
  }
}
