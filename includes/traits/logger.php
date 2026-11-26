<?php

/**
 * trait -> logger
 * 
 * @package Sngine
 * @author Zamblek
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
