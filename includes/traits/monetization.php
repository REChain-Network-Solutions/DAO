<?php

/**
 * trait -> monetization
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich - Handles - @sorydima @sorydev @durovshater @DmitrySoro90935 @tanechfund - also check https://dmitry.rechain.network for more information!
 */

trait MonetizationTrait
{

  /* ------------------------------- */
  /* Monetization */
  /* ------------------------------- */

  /**
   * get_monetization_plans
   * 
   * @param integer $node_id
   * @param string $node_type
   * @return array
   */
  public function get_monetization_plans($node_id = null, $node_type = "profile")
  {
    global $db;
    $monetization_plans = [];
    $node_id = (isset($node_id)) ? $node_id : $this->_data['user_id'];
    $get_monetization_plans = $db->query(sprintf("SELECT * FROM monetization_plans WHERE node_id = %s AND node_type = %s ORDER BY plan_order", secure($node_id, 'int'), secure($node_type)));
    if ($get_monetization_plans->num_rows > 0) {
      while ($monetization_plan = $get_monetization_plans->fetch_assoc()) {
        $monetization_plans[] = $monetization_plan;
      }
    }
    return $monetization_plans;
  }


  /**
   * get_monetization_plans_count
   * 
   * @param integer $node_id
   * @param string $node_type
   * @return integer
   */
  public function get_monetization_plans_count($node_id = null, $node_type = "profile")
  {
    global $db;
    $node_id = (isset($node_id)) ? $node_id : $this->_data['user_id'];
    $get_monetization_plans = $db->query(sprintf("SELECT COUNT(*) as count FROM monetization_plans WHERE node_id = %s AND node_type = %s", secure($node_id, 'int'), secure($node_type)));
    if ($get_monetization_plans->num_rows > 0) {
      return $get_monetization_plans->fetch_assoc()['count'];
    }
    return 0;
  }


  /**
   * get_monetization_plan
   * 
   * @param integer $plan_id
   * @param boolean $override_authorization
   * @return array|false
   */
  public function get_monetization_plan($plan_id, $override_authorization = false)
  {
    global $db;
    /* get plan */
    $get_monetization_plan = $db->query(sprintf("SELECT * FROM monetization_plans WHERE plan_id = %s", secure($plan_id, 'int')));
    if ($get_monetization_plan->num_rows == 0) {
      return false;
    }
    $monetization_plan = $get_monetization_plan->fetch_assoc();
    /* check if the viewer authorized */
    if (!$override_authorization) {
      if (!$this->_is_admin && !$this->_is_moderator) {
        switch ($monetization_plan['node_type']) {
          case 'profile':
            if ($monetization_plan['node_id'] != $this->_data['user_id']) {
              throw new AuthorizationException(__("You are not authorized to do this action"));
            }
            break;

          case 'page':
            if (!$this->check_page_adminship($this->_data['user_id'], $monetization_plan['node_id'])) {
              throw new AuthorizationException(__("You are not authorized to do this action"));
            }
            break;

          case 'group':
            if (!$this->check_group_adminship($this->_data['user_id'], $monetization_plan['node_id'])) {
              throw new AuthorizationException(__("You are not authorized to do this action"));
            }
            break;
        }
      }
    }
    return $monetization_plan;
  }


  /**
   * insert_monetization_plan
   * 
   * @param integer $node_id
   * @param string $node_type
   * @param string $title
   * @param float $price
   * @param integer $period_num
   * @param string $period
   * @param string $custom_description
   * @param integer $plan_order
   * @return array
   */
  public function insert_monetization_plan($node_id, $node_type, $title, $price, $period_num, $period, $custom_description, $plan_order)
  {
    global $db, $system;
    /* validate */
    if (!isset($node_id) || !is_numeric($node_id)) {
      throw new BadRequestException(__("Invalid node id"));
    }
    if (!isset($node_type) || !in_array($node_type, ['profile', 'page', 'group'])) {
      throw new BadRequestException(__("Invalid node type"));
    }
    /* generate billing plan id */
    $user_authorized = false;
    switch ($node_type) {
      case 'profile':
        $billing_plan_id = "CP" . "-" . "U" . $node_id . "-" . $price;
        if ($node_id == $this->_data['user_id']) {
          $user_authorized = true;
        }
        break;

      case 'page':
        $billing_plan_id = "CP" . "-" . "P" . $node_id . "-" . $price;
        if ($this->check_page_adminship($this->_data['user_id'], $node_id)) {
          $user_authorized = true;
        }
        break;

      case 'group':
        $billing_plan_id = "CP" . "-" . "G" . $node_id . "-" . $price;
        if ($this->check_group_adminship($this->_data['user_id'], $node_id)) {
          $user_authorized = true;
        }
        break;
    }
    /* check if the viewer is authorized */
    if (!$this->_is_admin && !$this->_is_moderator && !$user_authorized) {
      throw new AuthorizationException(__("You are not authorized to do this action"));
    }
    /* validate */
    if (!isset($title) || is_empty($title)) {
      throw new ValidationException(__("Please enter a title"));
    }
    if (!isset($price) || !is_numeric($price) || $price < 0) {
      throw new ValidationException(__("Please enter a valid price"));
    }
    if ($system['monetization_max_plan_price'] > 0 && $price > $system['monetization_max_plan_price']) {
      throw new ValidationException(__("The price must be less than or equal to") . " " . print_money($system['monetization_max_plan_price']));
    }
    /* check if the price = 0 */
    if ($price == 0) {
      /* check if the node has a free plan */
      if ($this->has_free_monetization_plan($node_id, $node_type) != false) {
        throw new ValidationException(__("You can't add more than one free plan"));
      }
    }
    if (!isset($period_num) || !is_numeric($period_num) || $period_num <= 0) {
      throw new ValidationException(__("Please enter a valid paid every value"));
    }
    if (!isset($period) || !in_array($period, ['minute', 'hour', 'day', 'week', 'month', 'year'])) {
      throw new ValidationException(__("Please enter a valid period"));
    }
    /* PayPal billing plan */
    $paypal_billing_plan = '';
    $paypal_recurring_enabled = $system['paypal_enabled'] && !is_empty($system['paypal_webhook']);
    if ($paypal_recurring_enabled && $price > 0 && !in_array($period, ['minute', 'hour'])) {
      /* create PayPal billing plan */
      $paypal_billing_plan = paypal_create_billing_plan($billing_plan_id, $billing_plan_id, $period_num, $period, $price);
    }
    /* Stripe billing plan */
    $stripe_billing_plan = '';
    $stripe_recurring_enabled = ($system['creditcard_enabled'] || $system['alipay_enabled']) && !is_empty($system['stripe_webhook']);
    if ($stripe_recurring_enabled && $price > 0 && !in_array($period, ['minute', 'hour'])) {
      /* create Stripe billing plan */
      $stripe_billing_plan = stripe_create_billing_plan($title, $custom_description, $period_num, $period, $price);
    }
    /* insert monetization plan */
    $db->query(sprintf("INSERT INTO monetization_plans (node_id, node_type, title, price, period_num, period, custom_description, plan_order, paypal_billing_plan, stripe_billing_plan) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)", secure($node_id, 'int'), secure($node_type), secure($title), secure($price, 'float'), secure($period_num), secure($period), secure($custom_description), secure($plan_order ?: '1'), secure($paypal_billing_plan), secure($stripe_billing_plan)));
    $monetization_plan_id = $db->insert_id;
    /* update monetization plans */
    $this->update_monetization_plans($node_id, $node_type);
    /* return inserted plan */
    return $this->get_monetization_plan($monetization_plan_id, true);
  }


  /**
   * update_monetization_plan
   * 
   * @param integer $plan_id
   * @param string $title
   * @param float $price
   * @param integer $period_num
   * @param string $period
   * @param string $custom_description
   * @param integer $plan_order
   * @return array
   */
  public function update_monetization_plan($plan_id, $title, $price, $period_num, $period, $custom_description, $plan_order)
  {
    global $db, $system;
    /* get monetization plan */
    $monetization_plan = $this->get_monetization_plan($plan_id);
    if (!$monetization_plan) {
      throw new Exception(__("This monetization plan is not available"));
    }
    /* validate */
    if (!isset($title) || is_empty($title)) {
      throw new ValidationException(__("Please enter a title"));
    }
    if (!isset($price) || !is_numeric($price) || $price < 0) {
      throw new ValidationException(__("Please enter a valid price"));
    }
    if ($system['monetization_max_plan_price'] > 0 && $price > $system['monetization_max_plan_price']) {
      throw new ValidationException(__("The price must be less than or equal to") . " " . print_money($system['monetization_max_plan_price']));
    }
    /* check if the price = 0 */
    if ($price == 0) {
      /* check if the node has a free plan */
      $free_plan = $this->has_free_monetization_plan($monetization_plan['node_id'], $monetization_plan['node_type']);
      if (is_array($free_plan) && $free_plan['plan_id'] != $plan_id) {
        throw new ValidationException(__("You can't add more than one free plan"));
      }
    }
    if (!isset($period_num) || !is_numeric($period_num) || $period_num <= 0) {
      throw new ValidationException(__("Please enter a valid paid every value"));
    }
    if (!isset($period) || !in_array($period, ['minute', 'hour', 'day', 'week', 'month', 'year'])) {
      throw new ValidationException(__("Please enter a valid period"));
    }
    /* generate billing plan id */
    switch ($monetization_plan['node_type']) {
      case 'profile':
        $billing_plan_id = "CP" . "-" . "U" . $monetization_plan['node_id'] . "-" . $price;
        break;

      case 'page':
        $billing_plan_id = "CP" . "-" . "P" . $monetization_plan['node_id'] . "-" . $price;
        break;

      case 'group':
        $billing_plan_id = "CP" . "-" . "G" . $monetization_plan['node_id'] . "-" . $price;
        break;
    }
    /* PayPal billing plan */
    $paypal_billing_plan = $monetization_plan['paypal_billing_plan'];
    $paypal_recurring_enabled = $system['paypal_enabled'] && !is_empty($system['paypal_webhook']);
    if ($paypal_recurring_enabled && $price > 0 && !in_array($period, ['minute', 'hour'])) {
      /* check if PayPal billing plan is not created */
      if (is_empty($paypal_billing_plan)) {
        /* create PayPal billing plan */
        $paypal_billing_plan = paypal_create_billing_plan($billing_plan_id, $billing_plan_id, $period_num, $period, $price);
      } else {
        /* check if the (period || period_num || price) is edited */
        if ($monetization_plan['period'] != $period || $monetization_plan['period_num'] != $period_num || $monetization_plan['price'] != $price) {
          /* replace the plan */
          $paypal_billing_plan = paypal_replace_billing_plan($monetization_plan['paypal_billing_plan'], $billing_plan_id, $billing_plan_id, $period_num, $period, $price);
        }
      }
    } else {
      $paypal_billing_plan = '';
      if ($paypal_recurring_enabled && $monetization_plan['paypal_billing_plan']) {
        paypal_deactivate_billing_plan($monetization_plan['paypal_billing_plan']);
      }
    }
    /* Stripe billing plan */
    $stripe_billing_plan = $monetization_plan['stripe_billing_plan'];
    $stripe_recurring_enabled = ($system['creditcard_enabled'] || $system['alipay_enabled']) && !is_empty($system['stripe_webhook']);
    if ($stripe_recurring_enabled && $price > 0 && !in_array($period, ['minute', 'hour'])) {
      /* check if Stripe billing plan is not created */
      if (is_empty($stripe_billing_plan)) {
        /* create Stripe billing plan */
        $stripe_billing_plan = stripe_create_billing_plan($billing_plan_id, $billing_plan_id, $period_num, $period, $price);
      } else {
        /* check if the (period || period_num || price) is edited */
        if ($monetization_plan['period'] != $period || $monetization_plan['period_num'] != $period_num || $monetization_plan['price'] != $price) {
          /* replace the plan */
          $stripe_billing_plan = stripe_replace_billing_plan($monetization_plan['stripe_billing_plan'], $billing_plan_id, $billing_plan_id, $period_num, $period, $price);
        }
      }
    } else {
      $stripe_billing_plan = '';
      if ($stripe_recurring_enabled && $monetization_plan['stripe_billing_plan']) {
        stripe_deactivate_billing_plan($monetization_plan['stripe_billing_plan']);
      }
    }
    /* remove all users recurring payments */
    if ($paypal_billing_plan == '' && $stripe_billing_plan == '') {
      $db->query(sprintf("DELETE FROM users_recurring_payments WHERE handle = 'subscribe' AND handle_id = %s", secure($plan_id, 'int')));
    }
    /* update monetization plan */
    $db->query(sprintf("UPDATE monetization_plans SET title = %s, price = %s, period_num = %s, period = %s, custom_description = %s, plan_order = %s, paypal_billing_plan = %s, stripe_billing_plan = %s WHERE plan_id = %s", secure($title), secure($price, 'float'), secure($period_num), secure($period), secure($custom_description), secure($plan_order), secure($paypal_billing_plan), secure($stripe_billing_plan), secure($plan_id, 'int')));
    /* update monetization plans */
    $this->update_monetization_plans($monetization_plan['node_id'], $monetization_plan['node_type']);
    /* return updated plan */
    return $this->get_monetization_plan($plan_id, true);
  }


  /**
   * delete_monetization_plan
   * 
   * @param integer $plan_id
   * @return void
   */
  public function delete_monetization_plan($plan_id)
  {
    global $db, $system;
    /* get monetization plan */
    $monetization_plan = $this->get_monetization_plan($plan_id);
    if (!$monetization_plan) {
      throw new Exception(__("This monetization plan is not available"));
    }
    /* delete all subscriptions to this plan */
    $db->query(sprintf("DELETE FROM subscribers WHERE plan_id = %s", secure($plan_id, 'int')));
    /* remove all users recurring payments */
    $db->query(sprintf("DELETE FROM users_recurring_payments WHERE handle = 'subscribe' AND handle_id = %s", secure($plan_id, 'int')));
    /* delete monetization plan */
    $db->query(sprintf("DELETE FROM monetization_plans WHERE plan_id = %s", secure($plan_id, 'int')));
    /* update monetization plans */
    $this->update_monetization_plans($monetization_plan['node_id'], $monetization_plan['node_type']);
    /* deactivate PayPal billing plan */
    if ($monetization_plan['paypal_billing_plan']) {
      paypal_deactivate_billing_plan($monetization_plan['paypal_billing_plan']);
    }
    /* deactivate Stripe billing plan */
    if ($monetization_plan['stripe_billing_plan']) {
      stripe_deactivate_billing_plan($monetization_plan['stripe_billing_plan']);
    }
  }


  /**
   * update_monetization_plans
   * 
   * @param integer $node_id
   * @param string $node_type
   * @return void
   */
  public function update_monetization_plans($node_id = null, $node_type = 'profile')
  {
    global $db;
    $node_id = (isset($node_id)) ? $node_id : $this->_data['user_id'];
    switch ($node_type) {
      case 'profile':
        $table = "users";
        $id_file = "user_id";
        $price_field = "user_monetization_min_price";
        $monetization_plans_field = "user_monetization_plans";
        break;

      case 'page':
        $table = "pages";
        $id_file = "page_id";
        $price_field = "page_monetization_min_price";
        $monetization_plans_field = "page_monetization_plans";
        break;

      case 'group':
        $table = "groups";
        $id_file = "group_id";
        $price_field = "group_monetization_min_price";
        $monetization_plans_field = "group_monetization_plans";
        break;
    }
    /* get min price */
    $min_price = $db->query(sprintf("SELECT MIN(price) as min_price FROM monetization_plans WHERE node_id = %s AND node_type = %s", secure($node_id, 'int'), secure($node_type)))->fetch_assoc()['min_price'];
    /* get monetization plans count */
    $monetization_plans_count = $this->get_monetization_plans_count($node_id, $node_type);
    /* update min price & monetization plans count */
    $db->query(sprintf("UPDATE `$table` SET $price_field = %s, $monetization_plans_field = %s WHERE $id_file = %s", secure($min_price, 'float'), secure($monetization_plans_count, 'int'),  secure($node_id, 'int')));
  }


  /**
   * has_free_monetization_plan
   * 
   * @param integer $node_id
   * @param string $node_type
   * @return boolean|array
   */
  public function has_free_monetization_plan($node_id, $node_type)
  {
    global $db;
    $get_monetization_plans = $db->query(sprintf("SELECT * FROM monetization_plans WHERE node_id = %s AND node_type = %s AND price = '0'", secure($node_id, 'int'), secure($node_type)));
    if ($get_monetization_plans->num_rows > 0) {
      return $get_monetization_plans->fetch_assoc();
    }
    return false;
  }


  /**
   * subscribe
   * 
   * @param integer $plan_id
   * @param integer $user_id
   * @param boolean $resubscribe
   * @return string
   */
  public function subscribe($plan_id, $user_id = null, $resubscribe = false)
  {
    global $system, $db, $date;
    /* check monetization enabled */
    if (!$system['monetization_enabled']) {
      throw new Exception(__("The monetization system has been disabled by the admin"));
    }
    /* check user */
    $user_id = ($user_id) ? $user_id : $this->_data['user_id'];
    /* get monetization plan */
    $monetization_plan = $this->get_monetization_plan($plan_id, true);
    if (!$monetization_plan) {
      throw new Exception(__("This monetization plan is not available"));
    }
    /* get the node */
    switch ($monetization_plan['node_type']) {
      case 'profile':
        $node = $this->get_user($monetization_plan['node_id']);
        if (!$node) {
          _error(400);
        }
        $content_creator_id = $node['user_id'];
        $notification_action = 'subscribe_profile';
        $notification_title = $node['user_name'];
        $notification_url = $node['user_name'];
        $returned_link = "/" . $node['user_name'];
        break;

      case 'page':
        $node = $this->get_page($monetization_plan['node_id']);
        if (!$node) {
          _error(400);
        }
        $content_creator_id = $node['page_admin'];
        $notification_action = 'subscribe_page';
        $notification_title = $node['page_title'];
        $notification_url = $node['page_name'];
        $returned_link = "/pages/" . $node['page_name'];
        break;

      case 'group':
        $node = $this->get_group($monetization_plan['node_id']);
        if (!$node) {
          _error(400);
        }
        $content_creator_id = $node['group_admin'];
        $notification_action = 'subscribe_group';
        $notification_title = $node['group_title'];
        $notification_url = $node['group_name'];
        $returned_link = "/groups/" . $node['group_name'];
        break;

      default:
        _error(400);
        break;
    }
    /* check if the viewer is subscribed to this node */
    if ($this->is_subscribed($monetization_plan['node_id'], $monetization_plan['node_type'], $user_id)) {
      if ($resubscribe) {
        /* remove as subscriber */
        $db->query(sprintf("DELETE FROM subscribers WHERE user_id = %s AND node_id = %s AND node_type = %s AND plan_id = %s", secure($user_id, 'int'), secure($monetization_plan['node_id'], 'int'), secure($monetization_plan['node_type']), secure($plan_id)));
      } else {
        throw new Exception(__("Already subscribed to this") . " " . __($monetization_plan['node_type']));
      }
    }
    /* add as subscriber */
    $db->query(sprintf("INSERT INTO subscribers (user_id, node_id, node_type, plan_id, time) VALUES (%s, %s, %s, %s, %s)", secure($user_id, 'int'),  secure($monetization_plan['node_id'], 'int'), secure($monetization_plan['node_type']), secure($plan_id), secure($date)));
    /* prepare commission */
    $content_price = $monetization_plan['price'];
    $commission = ($system['monetization_commission']) ? $content_price * ($system['monetization_commission'] / 100) : 0;
    $content_price = $content_price - $commission;
    /* update content creator monetization balance */
    $db->query(sprintf("UPDATE users SET user_monetization_balance = user_monetization_balance + %s WHERE user_id = %s", secure($content_price, 'float'), secure($content_creator_id, 'int')));
    /* log commission */
    $this->log_commission($content_creator_id, $commission, 'subscribe');
    /* log subscriptions */
    $this->log_subscriptions($user_id, $monetization_plan['title'], $monetization_plan['node_id'], $monetization_plan['node_type'], $monetization_plan['price'], $commission);
    /* notify the content creator */
    $this->post_notification(['to_user_id' => $content_creator_id, 'from_user_id' => $user_id, 'action' => $notification_action, 'node_type' => $notification_title, 'node_url' => $notification_url]);
    /* affiliates system */
    if ($system['affiliate_payment_to'] == "seller") {
      /* get the seller referrer */
      $get_seller_referrer = $db->query(sprintf("SELECT user_referrer_id FROM users WHERE user_id = %s", secure($content_creator_id, 'int')));
      $seller_referrer_id =  $get_seller_referrer->fetch_assoc()['user_referrer_id'];
      $this->process_affiliates("packages", $content_creator_id, $seller_referrer_id, $monetization_plan['price']);
    } else {
      if ($user_id == $this->_data['user_id']) {
        $user_referrer_id = $this->_data['user_referrer_id'];
      } else {
        $get_user_referrer = $db->query(sprintf("SELECT user_referrer_id FROM users WHERE user_id = %s", secure($user_id, 'int')));
        $user_referrer_id =  $get_user_referrer->fetch_assoc()['user_referrer_id'];
      }
      $this->process_affiliates("packages", $user_id, $user_referrer_id, $monetization_plan['price']);
    }
    /* return */
    return $returned_link;
  }


  /**
   * unsubscribe
   * 
   * @param integer $plan_id
   * @param integer $user_id
   * @return void
   */
  public function unsubscribe($plan_id, $user_id = null)
  {
    global $db;
    /* check user */
    $user_id = ($user_id) ? $user_id : $this->_data['user_id'];
    /* get monetization plan */
    $monetization_plan = $this->get_monetization_plan($plan_id, true);
    if (!$monetization_plan) {
      throw new Exception(__("This monetization plan is not available"));
    }
    /* get the node */
    switch ($monetization_plan['node_type']) {
      case 'profile':
        $node = $this->get_user($monetization_plan['node_id']);
        if (!$node) {
          _error(400);
        }
        break;

      case 'page':
        $node = $this->get_page($monetization_plan['node_id']);
        if (!$node) {
          _error(400);
        }
        break;

      case 'group':
        $node = $this->get_group($monetization_plan['node_id']);
        if (!$node) {
          _error(400);
        }
        break;

      default:
        _error(400);
        break;
    }
    /* check if the viewer is subscribed to this node */
    if (!$this->is_subscribed($monetization_plan['node_id'], $monetization_plan['node_type'], $user_id)) {
      throw new Exception(__("You are not subscribed to this") . " " . __($monetization_plan['node_type']));
    }
    /* remove as subscriber */
    $db->query(sprintf("DELETE FROM subscribers WHERE user_id = %s AND node_id = %s AND node_type = %s AND plan_id = %s", secure($user_id, 'int'), secure($monetization_plan['node_id'], 'int'), secure($monetization_plan['node_type']), secure($plan_id)));
    /* get recurring payment */
    $get_recurring_payment = $db->query(sprintf("SELECT * FROM users_recurring_payments WHERE handle = 'subscribe' AND handle_id = %s AND user_id = %s", secure($plan_id, 'int'), secure($user_id, 'int')));
    if ($get_recurring_payment->num_rows > 0) {
      $recurring_payment = $get_recurring_payment->fetch_assoc();
      /* cancel the subscription */
      if ($recurring_payment['payment_gateway'] == "paypal") {
        paypal_cancel_subscription($recurring_payment['subscription_id']);
      }
      if ($recurring_payment['payment_gateway'] == "stripe") {
        stripe_cancel_subscription($recurring_payment['subscription_id']);
      }
      /* remove user recurring payment (if any) */
      $db->query(sprintf("DELETE FROM users_recurring_payments WHERE handle = 'subscribe' AND handle_id = %s AND user_id = %s", secure($plan_id, 'int'), secure($user_id, 'int')));
    }
  }


  /**
   * is_subscribed
   * 
   * @param integer $node_id
   * @param string $node_type
   * @param integer $user_id
   * @return boolean
   */
  public function is_subscribed($node_id, $node_type = 'profile', $user_id = null)
  {
    global $db;
    /* check user */
    if (!$user_id) {
      if (!$this->_logged_in) return false;
      $user_id = $this->_data['user_id'];
    }
    /* check if the viewer is subscribed to this node */
    $get_subscribtion = $db->query(sprintf("SELECT * FROM subscribers WHERE node_type = %s AND node_id = %s AND user_id = %s", secure($node_type), secure($node_id, 'int'), secure($user_id, 'int')));
    if ($get_subscribtion->num_rows == 0) {
      return false;
    }
    /* check the subscribtion period */
    $subscribtion = $get_subscribtion->fetch_assoc();
    $monetization_plan = $this->get_monetization_plan($subscribtion['plan_id'], true);
    if (!$monetization_plan) {
      return false;
    }
    /* the subscribtion period is not expired */
    if ($subscribtion['time'] > date('Y-m-d H:i:s', strtotime('-' . $monetization_plan['period_num'] . ' ' . $monetization_plan['period']))) {
      return true;
    }
    /* the subscribtion period is expired */
    $db->query(sprintf("DELETE FROM subscribers WHERE node_type = %s AND node_id = %s AND user_id = %s", secure($node_type), secure($node_id, 'int'), secure($user_id, 'int')));
    return false;
  }


  /**
   * has_sneak_peak
   * 
   * @param integer $node_id
   * @param string $node_type
   * @return boolean
   */
  public function has_sneak_peak($node_id, $node_type = 'profile')
  {
    global $db;
    /* check if the viewer is sneak_peaked to this node */
    $get_sneak_peak = $db->query(sprintf("SELECT * FROM sneak_peaks WHERE node_type = %s AND node_id = %s AND user_id = %s", secure($node_type), secure($node_id, 'int'), secure($this->_data['user_id'], 'int')));
    if ($get_sneak_peak->num_rows == 0) {
      return false;
    }
    return true;
  }


  /**
   * sneak_peak
   * 
   * @param integer $node_id
   * @param string $node_type
   * @return void
   */
  public function sneak_peak($node_id, $node_type = 'profile')
  {
    global $db, $date;
    /* add sneak peak */
    $db->query(sprintf("INSERT INTO sneak_peaks (user_id, node_id, node_type, time) VALUES (%s, %s, %s, %s)", secure($this->_data['user_id'], 'int'), secure($node_id, 'int'), secure($node_type), secure($date)));
  }


  /**
   * unlock_paid_post
   * 
   * @param integer $post_id
   * @param integer $user_id
   * @return void
   */
  public function unlock_paid_post($post_id, $user_id = null)
  {
    global $system, $db, $date;
    /* check user */
    $user_id = ($user_id) ? $user_id : $this->_data['user_id'];
    /* get post */
    $post = $this->get_post($post_id, false, true, true);
    if (!$post) {
      throw new Exception(__("This post is not available"));
    }
    /* unlock the post */
    $db->query(sprintf("INSERT INTO posts_paid (post_id, user_id, time) VALUES (%s, %s, %s)", secure($post_id, 'int'), secure($user_id, 'int'), secure($date)));
    /* prepare commission */
    $content_price = $post['post_price'];
    $commission = ($system['monetization_commission']) ? $content_price * ($system['monetization_commission'] / 100) : 0;
    $content_price = $content_price - $commission;
    /* update content creator monetization balance */
    $db->query(sprintf("UPDATE users SET user_monetization_balance = user_monetization_balance + %s WHERE user_id = %s", secure($content_price, 'float'), secure($post['author_id'], 'int')));
    /* log commission */
    $this->log_commission($post['author_id'], $commission, 'paid_post');
    /* notify the content creator */
    $this->post_notification(['to_user_id' => $post['author_id'], 'from_user_id' => $user_id, 'action' => 'paid_post', 'node_url' => $post['post_id']]);
    /* affiliates system */
    if ($system['affiliate_payment_to'] == "seller") {
      /* get the seller referrer */
      $get_seller_referrer = $db->query(sprintf("SELECT user_referrer_id FROM users WHERE user_id = %s", secure($post['author_id'], 'int')));
      $seller_referrer_id =  $get_seller_referrer->fetch_assoc()['user_referrer_id'];
      $this->process_affiliates("packages", $post['author_id'], $seller_referrer_id, $post['post_price']);
    } else {
      if ($user_id == $this->_data['user_id']) {
        $user_referrer_id = $this->_data['user_referrer_id'];
      } else {
        $get_user_referrer = $db->query(sprintf("SELECT user_referrer_id FROM users WHERE user_id = %s", secure($user_id, 'int')));
        $user_referrer_id =  $get_user_referrer->fetch_assoc()['user_referrer_id'];
      }
      $this->process_affiliates("packages", $user_id, $user_referrer_id, $post['post_price']);
    }
    /* return */
    return "/posts/" . $post['post_id'];
  }


  /**
   * is_user_paid_for_post
   * 
   * @param integer $post_id
   * @param string $user_id
   * @return boolean
   */
  public function is_user_paid_for_post($post_id, $user_id = null)
  {
    global $db;
    $user_id = (isset($user_id)) ? $user_id : $this->_data['user_id'];
    $check = $db->query(sprintf("SELECT COUNT(*) as count FROM posts_paid WHERE post_id = %s AND user_id = %s", secure($post_id, 'int'), secure($user_id, 'int')));
    if ($check->fetch_assoc()['count'] > 0) {
      return true;
    }
    return false;
  }
}
