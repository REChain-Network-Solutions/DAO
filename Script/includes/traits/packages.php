<?php

/**
 * trait -> packages
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich - Handles - @sorydima @sorydev @durovshater @DmitrySoro90935 @tanechfund - also check https://dmitry.rechain.network for more information!
 */

trait PackagesTrait
{

  /* ------------------------------- */
  /* Pro Packages */
  /* ------------------------------- */

  /**
   * get_packages
   * 
   * @return array
   */
  public function get_packages()
  {
    global $db;
    $packages = [];
    $get_packages = $db->query("SELECT * FROM packages LEFT JOIN permissions_groups ON packages.package_permissions_group_id = permissions_groups.permissions_group_id ORDER BY packages.package_order ASC");
    if ($get_packages->num_rows > 0) {
      while ($package = $get_packages->fetch_assoc()) {
        $package['icon'] = get_picture($package['icon'], 'package');
        $packages[] = $package;
      }
    }
    return $packages;
  }


  /**
   * get_package
   * 
   * @param integer $package_id
   * @return array|false
   */
  public function get_package($package_id)
  {
    global $db;
    $get_package = $db->query(sprintf('SELECT * FROM packages WHERE package_id = %s', secure($package_id, 'int')));
    if ($get_package->num_rows == 0) {
      return false;
    }
    $package = $get_package->fetch_assoc();
    return $package;
  }


  /**
   * check_user_package
   * 
   * @return void
   */
  public function check_user_package()
  {
    global $db;
    if ($this->_data['user_subscribed']) {
      /* get package */
      $package = $this->get_package($this->_data['user_package']);
      if ($package) {
        switch ($package['period']) {
          case 'day':
            $duration = 86400;
            break;

          case 'week':
            $duration = 604800;
            break;

          case 'month':
            $duration = 2629743;
            break;

          case 'year':
            $duration = 31556926;
            break;

          case 'life':
            return;
            break;
        }
        $time_left = time() - ($package['period_num'] * $duration);
        if (strtotime($this->_data['user_subscription_date']) > $time_left) {
          return;
        }
      }
      /* remove user package */
      $db->query(sprintf("UPDATE users SET user_subscribed = '0', user_package = null, user_subscription_date = null, user_boosted_posts = '0', user_boosted_pages = '0' WHERE user_id = %s", secure($this->_data['user_id'], 'int')));
      /* unboost posts */
      $db->query(sprintf("UPDATE posts SET boosted = '0' WHERE user_id = %s AND user_type = 'user'", secure($this->_data['user_id'], 'int')));
      /* unboost pages */
      $db->query(sprintf("UPDATE pages SET page_boosted = '0' WHERE page_admin = %s", secure($this->_data['user_id'], 'int')));
    }
  }


  /**
   * check_users_package
   * 
   * @return void
   */
  public function check_users_package()
  {
    global $db;
    $get_subscribed_users = $db->query("SELECT user_id, user_package, user_subscription_date FROM users WHERE user_subscribed = '1'");
    if ($get_subscribed_users->num_rows == 0) {
      return;
    }
    while ($subscribed_user = $get_subscribed_users->fetch_assoc()) {
      /* get package */
      $package = $this->get_package($subscribed_user['user_package']);
      if ($package) {
        switch ($package['period']) {
          case 'day':
            $duration = 86400;
            break;

          case 'week':
            $duration = 604800;
            break;

          case 'month':
            $duration = 2629743;
            break;

          case 'year':
            $duration = 31556926;
            break;

          case 'life':
            continue 2;
            break;
        }
        $time_left = time() - ($package['period_num'] * $duration);
        if (strtotime($subscribed_user['user_subscription_date']) > $time_left) {
          continue;
        }
      }
      /* remove user package */
      $db->query(sprintf("UPDATE users SET user_subscribed = '0', user_package = null, user_subscription_date = null, user_boosted_posts = '0', user_boosted_pages = '0' WHERE user_id = %s", secure($subscribed_user['user_id'], 'int')));
      /* unboost posts */
      $db->query(sprintf("UPDATE posts SET boosted = '0' WHERE boosted_by = %s AND boosted = '1'", secure($subscribed_user['user_id'], 'int')));
      /* unboost pages */
      $db->query(sprintf("UPDATE pages SET page_boosted = '0' WHERE page_admin = %s", secure($subscribed_user['user_id'], 'int')));
    }
  }


  /**
   * update_user_package
   * 
   * @param integer $package_id
   * @param string $package_name
   * @param string $package_price
   * @param boolean $package_verification
   * @param integer $user_id
   * @return void
   */
  public function update_user_package($package_id, $package_name, $package_price, $package_verification, $user_id = null)
  {
    global $system, $db, $date;
    /* check if pro packages enabled */
    if (!$system['packages_enabled']) {
      throw new Exception(__("The packages system has been disabled by the admin"));
    }
    /* check user */
    $user_id = ($user_id == null) ? $this->_data['user_id'] : $user_id;
    /* remove user old package */
    $db->query(sprintf("UPDATE users SET user_subscribed = '0', user_package = null, user_subscription_date = null, user_boosted_posts = '0', user_boosted_pages = '0' WHERE user_id = %s", secure($user_id, 'int')));
    /* update user package */
    $verification_statement = ($package_verification) ? " user_verified = '1', " : ""; /* to not affect already verified users */
    $free_trial = ($package_price == "0") ? " user_free_tried = '1', " : "";
    $db->query(sprintf("UPDATE users SET " . $verification_statement . $free_trial . " user_subscribed = '1', user_package = %s, user_subscription_date = %s, user_boosted_posts = '0', user_boosted_pages = '0' WHERE user_id = %s", secure($package_id, 'int'), secure($date), secure($user_id, 'int')));
    /* insert the payment */
    $db->query(sprintf("INSERT INTO packages_payments (payment_date, package_name, package_price, user_id) VALUES (%s, %s, %s, %s)", secure($date), secure($package_name), secure($package_price), secure($user_id, 'int')));
    /* affiliates system */
    if ($user_id == $this->_data['user_id']) {
      $user_referrer_id = $this->_data['user_referrer_id'];
    } else {
      $get_user_referrer = $db->query(sprintf("SELECT user_referrer_id FROM users WHERE user_id = %s", secure($user_id, 'int')));
      $user_referrer_id =  $get_user_referrer->fetch_assoc()['user_referrer_id'];
    }
    $this->process_affiliates("packages", $user_id, $user_referrer_id, $package_price);
  }


  /**
   * unsubscribe_user_package
   * 
   * @param integer $user_id
   * @return void
   */
  public function unsubscribe_user_package($user_id = null)
  {
    global $db;
    /* check user */
    $user_id = ($user_id == null) ? $this->_data['user_id'] : $user_id;
    /* remove user package */
    $db->query(sprintf("UPDATE users SET user_subscribed = '0', user_package = null, user_subscription_date = null, user_boosted_posts = '0', user_boosted_pages = '0' WHERE user_id = %s", secure($user_id, 'int')));
    /* get recurring payment */
    $get_recurring_payment = $db->query(sprintf("SELECT * FROM users_recurring_payments WHERE handle = 'packages' AND user_id = %s", secure($user_id, 'int')));
    if ($get_recurring_payment->num_rows > 0) {
      $recurring_payment = $get_recurring_payment->fetch_assoc();
      /* cancel the subscription */
      if ($recurring_payment['payment_gateway'] == "paypal") {
        paypal_cancel_subscription($recurring_payment['subscription_id']);
      }
      if ($recurring_payment['payment_gateway'] == "stripe") {
        stripe_cancel_subscription($recurring_payment['subscription_id']);
      }
      /* remove user recurring payment */
      $db->query(sprintf("DELETE FROM users_recurring_payments WHERE handle = 'packages' AND user_id = %s ", secure($user_id, 'int')));
    }
  }
}
