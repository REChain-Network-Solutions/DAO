<?php

/**
 * trait -> packages
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich
 */

trait PackagesTrait
{

  /* ------------------------------- */
  /* Pro Packages */
  /* ------------------------------- */

  /**
   * get_packages
   * 
   * @param boolean $get_hidden
   * @return array
   */
  public function get_packages($get_hidden = false)
  {
    global $db;
    $packages = [];
    $hidden_statement = ($get_hidden) ? "" : "WHERE packages.package_hidden = '0'";
    $get_packages = $db->query("SELECT * FROM packages LEFT JOIN permissions_groups ON packages.package_permissions_group_id = permissions_groups.permissions_group_id " . $hidden_statement . " ORDER BY packages.package_order ASC");
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
      $db->query(sprintf("UPDATE users SET user_subscribed = '0', user_package = null, user_subscription_date = null, user_boosted_posts = '0', user_boosted_pages = '0', user_boosted_groups = '0', user_boosted_events = '0' WHERE user_id = %s", secure($this->_data['user_id'], 'int')));
      /* unboost posts */
      $db->query(sprintf("UPDATE posts SET boosted = '0' WHERE user_id = %s AND user_type = 'user'", secure($this->_data['user_id'], 'int')));
      /* unboost pages */
      $db->query(sprintf("UPDATE pages SET page_boosted = '0' WHERE page_admin = %s", secure($this->_data['user_id'], 'int')));
      /* unboost groups */
      $db->query(sprintf("UPDATE `groups` SET group_boosted = '0' WHERE group_admin = %s", secure($this->_data['user_id'], 'int')));
      /* unboost events */
      $db->query(sprintf("UPDATE `events` SET event_boosted = '0' WHERE event_admin = %s", secure($this->_data['user_id'], 'int')));
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
      $db->query(sprintf("UPDATE users SET user_subscribed = '0', user_package = null, user_subscription_date = null, user_boosted_posts = '0', user_boosted_pages = '0', user_boosted_groups = '0', user_boosted_events = '0' WHERE user_id = %s", secure($subscribed_user['user_id'], 'int')));
      /* unboost posts */
      $db->query(sprintf("UPDATE posts SET boosted = '0' WHERE boosted_by = %s AND boosted = '1'", secure($subscribed_user['user_id'], 'int')));
      /* unboost pages */
      $db->query(sprintf("UPDATE pages SET page_boosted = '0' WHERE page_admin = %s", secure($subscribed_user['user_id'], 'int')));
      /* unboost groups */
      $db->query(sprintf("UPDATE `groups` SET group_boosted = '0' WHERE group_admin = %s", secure($subscribed_user['user_id'], 'int')));
      /* unboost events */
      $db->query(sprintf("UPDATE `events` SET event_boosted = '0' WHERE event_admin = %s", secure($subscribed_user['user_id'], 'int')));
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
   * @param boolean $from_admin
   * @return void
   */
  public function update_user_package($package, $user_id = null, $from_admin = false)
  {
    global $system, $db, $date;
    /* check if pro packages enabled */
    if (!$system['packages_enabled']) {
      throw new Exception(__("The packages system has been disabled by the admin"));
    }
    /* check user */
    $user_id = ($user_id == null) ? $this->_data['user_id'] : $user_id;
    /* remove user old package */
    $db->query(sprintf(
      "UPDATE users SET 
        user_subscribed = '0', 
        user_package = null, 
        user_subscription_date = null, 
        user_boosted_posts = '0', 
        user_boosted_pages = '0', 
        user_boosted_groups = '0', 
        user_boosted_events = '0' 
      WHERE user_id = %s",
      secure($user_id, 'int')
    ));
    /* prepare verification statements */
    $verification_statement = ($package['verification_badge_enabled']) ? " user_verified = '1', " : "";
    /* prepare free trial statements */
    $free_trial_statement = ($package['price'] == "0") ? " user_free_tried = '1', " : "";
    /* prepare free points statements */
    $free_points_statement = "";
    if ($package['free_points'] > 0) {
      /* check if user has already received free points */
      $check_user_packages_points = $db->query(sprintf("SELECT * FROM users_packages_points WHERE user_id = %s AND package_id = %s", secure($user_id, 'int'), secure($package['package_id'], 'int')));
      if ($check_user_packages_points->num_rows == 0) {
        $free_points_statement = sprintf(" user_points = user_points + %s, ", secure($package['free_points'], 'int'));
        /* insert the free points */
        $db->query(sprintf("INSERT INTO users_packages_points (user_id, package_id) VALUES (%s, %s)", secure($user_id, 'int'), secure($package['package_id'], 'int')));
      }
    }
    /* update user package */
    $db->query(sprintf(
      "UPDATE users SET " .
        $verification_statement .
        $free_trial_statement .
        $free_points_statement .
        " user_subscribed = '1', 
        user_package = %s, 
        user_subscription_date = %s, 
        user_boosted_posts = '0', 
        user_boosted_pages = '0' 
      WHERE user_id = %s",
      secure($package['package_id'], 'int'),
      secure($date),
      secure($user_id, 'int')
    ));
    /* check if from admin panel */
    if (!$from_admin) {
      /* insert the payment */
      $db->query(sprintf("INSERT INTO packages_payments (payment_date, package_name, package_price, user_id) VALUES (%s, %s, %s, %s)", secure($date), secure($package['name']), secure($package['price']), secure($user_id, 'int')));
      /* affiliates system */
      if ($user_id == $this->_data['user_id']) {
        $user_referrer_id = $this->_data['user_referrer_id'];
      } else {
        $get_user_referrer = $db->query(sprintf("SELECT user_referrer_id FROM users WHERE user_id = %s", secure($user_id, 'int')));
        $user_referrer_id =  $get_user_referrer->fetch_assoc()['user_referrer_id'];
      }
      $this->process_affiliates("packages", $user_id, $user_referrer_id, $package['price']);
    }
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
    $db->query(sprintf("UPDATE users SET user_subscribed = '0', user_package = null, user_subscription_date = null, user_boosted_posts = '0', user_boosted_pages = '0', user_boosted_groups = '0', user_boosted_events = '0' WHERE user_id = %s", secure($user_id, 'int')));
    /* unboost posts */
    $db->query(sprintf("UPDATE posts SET boosted = '0' WHERE boosted_by = %s AND boosted = '1'", secure($user_id, 'int')));
    /* unboost pages */
    $db->query(sprintf("UPDATE pages SET page_boosted = '0' WHERE page_admin = %s", secure($user_id, 'int')));
    /* unboost groups */
    $db->query(sprintf("UPDATE `groups` SET group_boosted = '0' WHERE group_admin = %s", secure($user_id, 'int')));
    /* unboost events */
    $db->query(sprintf("UPDATE `events` SET event_boosted = '0' WHERE event_admin = %s", secure($user_id, 'int')));
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


  /**
   * get_packages_payments
   * 
   * @param array $args
   * @return array
   */
  public function get_packages_payments(array $args = [])
  {
    global $db;
    $packages_payments = [];
    $get_all = ($args['get_all'] == null) ? false : $args['get_all'];
    $offset = ($args['offset'] == null) ? 0 : $args['offset'];
    $limit = ($args['limit'] == null) ? 10 : $args['limit'];
    $user_id = ($args['user_id'] == null) ? $this->_data['user_id'] : $args['user_id'];
    $offset *= $limit;
    $limit_statement = ($get_all) ? "" : sprintf("LIMIT %s, %s", secure($offset, 'int', false), secure($limit, 'int', false));
    $get_packages_payments = $db->query(sprintf("SELECT * FROM packages_payments WHERE user_id = %s ORDER BY payment_id DESC " . $limit_statement, secure($user_id, 'int')));
    while ($package_payment = $get_packages_payments->fetch_assoc()) {
      $packages_payments[] = $package_payment;
    }
    return $packages_payments;
  }
}
