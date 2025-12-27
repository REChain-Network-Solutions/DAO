<?php

/**
 * trait -> logger
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich
 */

trait LoggerTrait
{

  /* ------------------------------- */
  /* Logger */
  /* ------------------------------- */

  /**
   * log_payment
   * 
   * @param int $user_id
   * @param float $amount
   * @param string $method
   * @param string $handle
   * @return void
   */
  public function log_payment($user_id, $amount, $method, $handle)
  {
    global $db, $date;
    $db->query(sprintf("INSERT INTO log_payments (user_id, amount, method, handle, time) VALUES (%s, %s, %s, %s, %s)", secure($user_id, 'int'), secure($amount, 'float'), secure($method), secure($handle), secure($date)));
  }

  /**
   * log_commission
   * 
   * @param int $user_id
   * @param float $amount
   * @param string $handle
   * @return void
   */
  public function log_commission($user_id, $amount, $handle)
  {
    global $db, $date;
    if ($amount > 0) {
      $db->query(sprintf("INSERT INTO log_commissions (user_id, amount, handle, time) VALUES (%s, %s, %s, %s)", secure($user_id, 'int'), secure($amount, 'float'), secure($handle), secure($date)));
    }
  }


  /**
   * log_commission
   * 
   * @return void
   */
  public function log_session()
  {
    global $db, $date;
    /* log the session */
    $session_type = 'W';
    if (isset($_SERVER['HTTP_USER_AGENT'])) {
      $user_agent = $_SERVER['HTTP_USER_AGENT'];
      if (strpos($user_agent, 'Android') !== false) {
        $session_type = 'A';
      }
      if (strpos($user_agent, 'iPhone') !== false || strpos($user_agent, 'iPad') !== false) {
        $session_type = 'I';
      }
    }
    $user_ip = get_user_ip();
    $user_browser = get_user_browser();
    $user_os = get_user_os();
    /* check if session cookie exists */
    if (!isset($_COOKIE[$this->_cookie_user_session])) {
      /* check if session already exists using IP and user_agent */
      $get_session = $db->query(sprintf("SELECT COUNT(*) AS count FROM log_sessions WHERE session_ip = %s AND session_user_agent = %s", secure($user_ip), secure($user_agent)));
      if ($get_session->fetch_assoc()['count'] == 0) {
        $db->query(sprintf("INSERT INTO log_sessions (session_date, session_type, session_ip, session_user_agent, user_browser, user_os) VALUES (%s, %s, %s, %s, %s, %s)", secure($date), secure($session_type), secure($user_ip), secure($user_agent), secure($user_browser), secure($user_os)));
      }
      /* set session cookie */
      set_cookie($this->_cookie_user_session, md5($user_ip . $user_agent));
    }
  }


  /**
   * log_subscriptions
   * 
   * @param integer $subscriber_id
   * @param string $plan_title
   * @param integer $node_id
   * @param string $node_type
   * @param float $price
   * @param float $commission
   * @return void
   */
  public function log_subscriptions($subscriber_id, $plan_title, $node_id, $node_type, $price, $commission)
  {
    global $db, $date;
    $db->query(sprintf("INSERT INTO log_subscriptions (subscriber_id, plan_title, node_id, node_type, price, commission, time) VALUES (%s, %s, %s, %s, %s, %s, %s)", secure($subscriber_id, 'int'), secure($plan_title), secure($node_id, 'int'), secure($node_type), secure($price, 'float'), secure($commission, 'float'), secure($date)));
  }
}
