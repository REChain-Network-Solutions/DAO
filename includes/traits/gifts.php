<?php

/**
 * trait -> gifts
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich
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
    $get_gift = $db->query(sprintf("SELECT gifts.*, users.user_name, users.user_firstname, users.user_lastname FROM users_gifts INNER JOIN gifts ON users_gifts.gift_id = gifts.gift_id INNER JOIN users ON users_gifts.from_user_id = users.user_id WHERE users_gifts.id = %s AND users_gifts.to_user_id = %s", secure($gift_id, 'int'), secure($this->_data['user_id'], 'int')));
    if ($get_gift->num_rows == 0) {
      return false;
    }
    return $get_gift->fetch_assoc();
  }


  /**
   * get_gift_transactions
   * 
   * @param integer $offset
   * @return array
   */
  public function get_gift_transactions($user_id, $offset = 0)
  {
    global $system, $db;
    $transactions = [];
    $offset *= $system['max_results'];
    $get_transactions = $db->query(sprintf("SELECT users_gifts.*, gifts.*, users.user_name, users.user_firstname, users.user_lastname FROM users_gifts INNER JOIN gifts ON users_gifts.gift_id = gifts.gift_id INNER JOIN users ON users_gifts.from_user_id = users.user_id WHERE users_gifts.to_user_id = %s ORDER BY users_gifts.id DESC LIMIT %s, %s", secure($user_id, 'int'), secure($offset, 'int', false), secure($system['max_results'], 'int', false)));
    if ($get_transactions->num_rows > 0) {
      while ($transaction = $get_transactions->fetch_assoc()) {
        $transaction['image'] = $system['system_uploads'] . '/' . $transaction['image'];
        $transaction['user_picture'] = get_picture($transaction['user_picture'], $transaction['user_gender']);
        $transaction['user_fullname'] = ($system['show_usernames_enabled']) ? $transaction['user_name'] : $transaction['user_firstname'] . " " . $transaction['user_lastname'];
        $transactions[] = $transaction;
      }
    }
    return $transactions;
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
    /* get the gift */
    $get_gift = $db->query(sprintf("SELECT * FROM gifts WHERE gift_id = %s", secure($gift_id, 'int')));
    if ($get_gift->num_rows == 0) {
      throw new Exception(__("Invalid gift"));
    }
    $gift = $get_gift->fetch_assoc();
    /* check if the viewer allowed to send a gift to the target */
    $get_target_user = $db->query(sprintf("SELECT user_privacy_gifts FROM users WHERE user_id = %s", secure($user_id, 'int')));
    if ($get_target_user->num_rows == 0) {
      _error(400);
    }
    $target_user = $get_target_user->fetch_assoc();
    if ($target_user['user_privacy_gifts'] == "me" || ($target_user['user_privacy_gifts'] == "friends" && !$this->friendship_approved($user_id))) {
      throw new Exception(__("You can't send a gift to this user"));
    }
    /* check if the viewer has enough points to send the gift */
    if ($system['gifts_points_enabled']) {
      if ($this->_data['user_points'] < $gift['points']) {
        throw new Exception(__("You don't have enough points to send this gift"));
      }
      /* decrease the viewer points */
      $this->points_balance('delete', $this->_data['user_id'], 'gift', $gift_id, $gift['points']);
      /* increase the target user points */
      $this->points_balance('add', $user_id, 'gift', $gift_id, $gift['points']);
    }
    /* send the gift to the target user */
    $db->query(sprintf("INSERT INTO users_gifts (from_user_id, to_user_id, gift_id) VALUES (%s, %s, %s)", secure($this->_data['user_id'], 'int'),  secure($user_id, 'int'), secure($gift_id, 'int')));
    /* post new notification */
    $this->post_notification(['to_user_id' => $user_id, 'action' => 'gift', 'node_url' => $db->insert_id]);
  }
}
