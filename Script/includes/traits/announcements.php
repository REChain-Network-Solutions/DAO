<?php

/**
 * trait -> announcements
 * 
 * @package Sngine
 * @author Zamblek
 */

trait AnnouncementsTrait
{

  /* ------------------------------- */
  /* Announcements */
  /* ------------------------------- */

  /**
   * announcements
   * 
   * @param array $place
   * @return array
   */
  public function get_announcements()
  {
    global $db, $date;
    $announcements = [];
    /* announcements not ended yet (the same for everyone) */
    $active_announcements = widget_cache('announcements', 60, function () use ($db, $date) {
      return $db->query(sprintf('SELECT * FROM announcements WHERE end_date >= %s', secure($date)))->fetch_all(MYSQLI_ASSOC);
    });
    foreach ($active_announcements as $announcement) {
      if ($announcement['start_date'] > $date || $announcement['end_date'] < $date) {
        continue;
      }
      /* check if the user already hide the announcement */
      if ($this->_logged_in) {
        $check = $db->query(sprintf("SELECT COUNT(*) as count FROM announcements_users WHERE announcement_id = %s AND user_id = %s", secure($announcement['announcement_id'], 'int'), secure($this->_data['user_id'], 'int')));
        if ($check->fetch_assoc()['count'] > 0) {
          continue;
        }
      }
      $announcement['code'] = html_entity_decode($announcement['code'], ENT_QUOTES);
      $announcements[] = $announcement;
    }
    return $announcements;
  }


  /**
   * hide_announcement
   * 
   * @param integer $id
   * @return void
   */
  public function hide_announcement($id)
  {
    global $db, $system;
    /* check announcement */
    $check = $db->query(sprintf("SELECT COUNT(*) as count FROM announcements WHERE announcement_id = %s", secure($id, 'int')));
    if ($check->fetch_assoc()['count'] == 0) {
      _error(403);
    }
    /* hide announcement */
    $db->query(sprintf("INSERT INTO announcements_users (announcement_id, user_id) VALUES (%s, %s)", secure($id, 'int'), secure($this->_data['user_id'], 'int')));
  }
}
