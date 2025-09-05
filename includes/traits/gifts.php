<?php

/**
 * trait -> gifts
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich - Handles - @sorydima @sorydev @durovshater @DmitrySoro90935 @tanechfund - also check https://dmitry.rechain.network for more information!
 */

trait GiftsTrait
{

  /* ------------------------------- */
  /* Gifts */
  /* ------------------------------- */

  /**
   * get_gifts
   * 
   * @return array
   */
  public function get_gifts()
  {
    global $db;
    $gifts = [];
    $get_gifts = $db->query("SELECT * FROM gifts");
    if ($get_gifts->num_rows > 0) {
      while ($gift = $get_gifts->fetch_assoc()) {
        $gifts[] = $gift;
      }
    }
    return $gifts;
  }


  /**
   * get_gift
   * 
   * @return array
   */
  public function get_gift($gift_id)
  {
    global $db;
    $get_gift = $db->query(sprintf("SELECT gifts.image, users.user_name, users.user_firstname, users.user_lastname FROM users_gifts INNER JOIN gifts ON users_gifts.gift_id = gifts.gift_id INNER JOIN users ON users_gifts.from_user_id = users.user_id WHERE users_gifts.id = %s AND users_gifts.to_user_id = %s", secure($gift_id, 'int'), secure($this->_data['user_id'], 'int')));
    if ($get_gift->num_rows == 0) {
      return false;
    }
    return $get_gift->fetch_assoc();
  }


  /**
   * send_gift
   *
   * @param integer $user_id
   * @param integer $gift_id
   * 
   * @return void
   */
  public function send_gift($user_id, $gift_id)
  {
    global $db, $system;
    /* check if the viewer can send gifts */
    if (!$this->_data['can_send_gifts']) {
      throw new Exception(__("You don't have the right to send gifts"));
    }
    /* check if the viewer allowed to send a gift to the target */
    $get_target_user = $db->query(sprintf("SELECT user_privacy_gifts FROM users WHERE user_id = %s", secure($user_id, 'int')));
    if ($get_target_user->num_rows == 0) {
      _error(400);
    }
    $target_user = $get_target_user->fetch_assoc();
    if ($target_user['user_privacy_gifts'] == "me" || ($target_user['user_privacy_gifts'] == "friends" && !$this->friendship_approved($user_id))) {
      throw new Exception(__("You can't send a gift to this user"));
    }
    /* send the gift to the target user */
    $db->query(sprintf("INSERT INTO users_gifts (from_user_id, to_user_id, gift_id) VALUES (%s, %s, %s)", secure($this->_data['user_id'], 'int'),  secure($user_id, 'int'), secure($gift_id, 'int')));
    /* post new notification */
    $this->post_notification(['to_user_id' => $user_id, 'action' => 'gift', 'node_url' => $db->insert_id]);
  }
}
