<?php

/**
 * trait -> hashtags
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich
 */

trait HashtagsTrait
{

  /* ------------------------------- */
  /* Hashtags */
  /* ------------------------------- */

  /**
   * get_trending_hashtags
   * 
   * @return array
   */
  public function get_trending_hashtags($user_id = null)
  {
    global $system, $db;
    $hashtags = [];
    $where_query = "";
    if ($user_id) {
      /* where hashtags_posts.post_id in (select post_id from posts where posts.user_id = $user_id and posts.user_type = 'user') */
      $where_query = " AND hashtags_posts.post_id IN (SELECT post_id FROM posts WHERE posts.user_id = " . secure($user_id, 'int') . " AND posts.user_type = 'user')";
    }
    $get_trending_hashtags = $db->query(sprintf("SELECT hashtags.hashtag, COUNT(hashtags_posts.id) AS frequency FROM hashtags INNER JOIN hashtags_posts ON hashtags.hashtag_id = hashtags_posts.hashtag_id WHERE hashtags_posts.created_at > DATE_SUB(CURDATE(), INTERVAL 1 %s) " . $where_query . "GROUP BY hashtags_posts.hashtag_id ORDER BY frequency DESC LIMIT %s", secure($system['trending_hashtags_interval'], "", false), secure($system['trending_hashtags_limit'], 'int', false)));
    if ($get_trending_hashtags->num_rows > 0) {
      while ($hashtag = $get_trending_hashtags->fetch_assoc()) {
        $hashtag['hashtag'] = html_entity_decode($hashtag['hashtag'], ENT_QUOTES);
        $hashtags[] = $hashtag;
      }
    }
    return $hashtags;
  }


  /**
   * decode_hashtags
   * 
   * @param string $text
   * @param boolean $trending_hashtags
   * @param integer $post_id
   * @return string
   */
  function decode_hashtags($text, $trending_hashtags, $post_id)
  {
    if ($text) {
      $pattern = '/(\s|^)((#|\x{ff03}){1}([0-9_\p{L}&;]*[_\p{L}&;][0-9_\p{L}&;]*))/u';
      $text = preg_replace_callback($pattern, function ($matches) use ($trending_hashtags, $post_id) {
        global $system, $db, $date;
        if ($trending_hashtags) {
          $get_hashtag = $db->query(sprintf("SELECT hashtag_id FROM hashtags WHERE hashtag = %s", secure($matches[4])));
          if ($get_hashtag->num_rows == 0) {
            /* insert the new hashtag */
            $db->query(sprintf("INSERT INTO hashtags (hashtag) VALUES (%s)", secure($matches[4])));
            $hashtag_id = $db->insert_id;
          } else {
            $hashtag_id = $get_hashtag->fetch_assoc()['hashtag_id'];
          }
          /* check if the combination of post_id and hashtag_id already exists */
          $check_hashtag = $db->query(sprintf("SELECT COUNT(*) FROM hashtags_posts WHERE post_id = %s AND hashtag_id = %s", secure($post_id, 'int'), secure($hashtag_id, 'int')));
          if ($check_hashtag->fetch_assoc()['COUNT(*)'] == 0) {
            /* connect hashtag with the post */
            $db->query(sprintf("INSERT INTO hashtags_posts (post_id, hashtag_id, created_at) VALUES (%s, %s, %s)", secure($post_id, 'int'), secure($hashtag_id, 'int'), secure($date)));
          }
        }
        return $matches[1] . '<a href="' . $system['system_url'] . '/search/hashtag/' . $matches[4] . '">' . $matches[2] . '</a>';
      }, $text);
    }
    return $text;
  }


  /**
   * delete_hashtags
   * 
   * @param integer $post_id
   * @return void
   */
  public function delete_hashtags($post_id)
  {
    global $db;
    /* unconnect hashtag with the post */
    $db->query(sprintf("DELETE FROM hashtags_posts WHERE post_id = %s", secure($post_id, 'int')));
  }
}
