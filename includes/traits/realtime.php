<?php

/**
 * trait -> realtime
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich
 */

trait RealTimeTrait
{

  /* ------------------------------- */
  /* Real-Time */
  /* ------------------------------- */

  /**
   * reset_realtime_counters
   * 
   * @param string $counter
   * @return void
   */
  public function reset_realtime_counters($counter)
  {
    global $db;
    switch ($counter) {
      case 'friend_requests':
        $db->query(sprintf("UPDATE users SET user_live_requests_counter = 0 WHERE user_id = %s", secure($this->_data['user_id'], 'int')));
        break;

      case 'messages':
        $db->query(sprintf("UPDATE users SET user_live_messages_counter = 0 WHERE user_id = %s", secure($this->_data['user_id'], 'int')));
        break;

      case 'calls':
        $db->query(sprintf("UPDATE users SET user_live_calls_counter = 0 WHERE user_id = %s", secure($this->_data['user_id'], 'int')));
        break;

      case 'notifications':
        $db->query(sprintf("UPDATE users SET user_live_notifications_counter = 0 WHERE user_id = %s", secure($this->_data['user_id'], 'int')));
        $db->query(sprintf("UPDATE notifications SET seen = '1' WHERE to_user_id = %s", secure($this->_data['user_id'], 'int')));
        break;
    }
  }
}
