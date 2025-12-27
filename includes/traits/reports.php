<?php

/**
 * trait -> reports
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich
 */

trait ReportsTrait
{

  /* ------------------------------- */
  /* Reports */
  /* ------------------------------- */

  /**
   * report
   * 
   * @param integer $id
   * @param string $handle
   * @param integer $category
   * @param string $reason
   * @return void
   */
  public function report($id, $handle, $category, $reason)
  {
    global $db, $date;
    switch ($handle) {
      case 'user':
        /* check the user */
        $check = $db->query(sprintf("SELECT COUNT(*) as count FROM users WHERE user_id = %s", secure($id, 'int')));
        break;

      case 'page':
        /* check the page */
        $check = $db->query(sprintf("SELECT COUNT(*) as count FROM pages WHERE page_id = %s", secure($id, 'int')));
        break;

      case 'group':
        /* check the group */
        $check = $db->query(sprintf("SELECT COUNT(*) as count FROM `groups` WHERE group_id = %s", secure($id, 'int')));
        break;

      case 'event':
        /* check the event */
        $check = $db->query(sprintf("SELECT COUNT(*) as count FROM `events` WHERE event_id = %s", secure($id, 'int')));
        break;

      case 'post':
        /* check the post */
        $check = $db->query(sprintf("SELECT COUNT(*) as count FROM posts WHERE post_id = %s", secure($id, 'int')));
        break;

      case 'comment':
        /* check the comment */
        $check = $db->query(sprintf("SELECT COUNT(*) as count FROM posts_comments WHERE comment_id = %s", secure($id, 'int')));
        break;

      case 'message':
        /* check the message */
        $check = $db->query(sprintf("SELECT COUNT(*) as count FROM conversations_messages WHERE message_id = %s", secure($id, 'int')));
        break;

      case 'forum_thread':
        /* check the forum thread */
        $check = $db->query(sprintf("SELECT COUNT(*) as count FROM forums_threads WHERE thread_id = %s", secure($id, 'int')));
        break;

      case 'forum_reply':
        /* check the forum thread */
        $check = $db->query(sprintf("SELECT COUNT(*) as count FROM forums_replies WHERE reply_id = %s", secure($id, 'int')));
        break;

      case 'ads_campaign':
        /* check the ads campaign */
        $check = $db->query(sprintf("SELECT COUNT(*) as count FROM ads_campaigns WHERE campaign_id = %s", secure($id, 'int')));
        break;

      default:
        _error(403);
        break;
    }
    /* check node */
    if ($check->fetch_assoc()['count'] == 0) {
      _error(403);
    }
    /* check old reports */
    $check = $db->query(sprintf("SELECT COUNT(*) as count FROM reports WHERE user_id = %s AND node_id = %s AND node_type = %s", secure($this->_data['user_id'], 'int'), secure($id, 'int'), secure($handle)));
    if ($check->fetch_assoc()['count'] > 0) {
      throw new Exception(__("You have already reported this before!"));
    }
    /* validate category */
    if (is_empty($category)) {
      throw new Exception(__("You must select valid category for your report"));
    }
    $check = $db->query(sprintf("SELECT COUNT(*) as count FROM reports_categories WHERE category_id = %s", secure($category, 'int')));
    if ($check->fetch_assoc()['count'] == 0) {
      throw new Exception(__("You must select valid category for your report"));
    }
    /* report */
    $db->query(sprintf("INSERT INTO reports (user_id, node_id, node_type, category_id, reason, time) VALUES (%s, %s, %s, %s, %s, %s)", secure($this->_data['user_id'], 'int'), secure($id, 'int'), secure($handle), secure($category, 'int'), secure($reason), secure($date)));
    /* send notification to admins & moderators */
    $this->notify_system_admins("report", true);
  }
}
