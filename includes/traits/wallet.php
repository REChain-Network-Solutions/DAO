<?php

/**
 * trait -> wallet
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich
 */

trait WalletTrait
{

  /* ------------------------------- */
  /* Wallet */
  /* ------------------------------- */

  /**
   * wallet_transfer
   * 
   * @param integer $user_id
   * @param integer $amount
   * @return void
   */
  public function wallet_transfer($user_id, $amount)
  {
    global $db, $system;
    /* check if wallet enabled */
    if (!$system['wallet_enabled']) {
      throw new Exception(__("The wallet system has been disabled by the admin"));
    }
    /* check if wallet transfer enabled */
    if (!$system['wallet_transfer_enabled']) {
      throw new Exception(__("The wallet transfer feature has been disabled by the admin"));
    }
    /* validate amount */
    if (is_empty($amount) || !is_numeric($amount) || $amount <= 0) {
      throw new Exception(__("You must enter valid amount of money"));
    }
    if ($system['wallet_max_transfer'] != 0 && $amount > $system['wallet_max_transfer']) {
      throw new Exception(__("You can't transfer more than") . " " . print_money($system['wallet_max_transfer']));
    }
    /* validate target user */
    if (is_empty($user_id) || !is_numeric($user_id)) {
      throw new Exception(__("You must search for a user to send money to"));
    }
    if ($this->_data['user_id'] == $user_id) {
      throw new Exception(__("You can't send money to yourself!"));
    }
    $check_user = $db->query(sprintf("SELECT COUNT(*) as count FROM users WHERE user_id = %s", secure($user_id, 'int')));
    if ($check_user->fetch_assoc()['count'] == 0) {
      throw new Exception(__("You can't send money to this user!"));
    }
    /* check viewer balance */
    if ($this->_data['user_wallet_balance'] < $amount) {
      throw new Exception(__("There is not enough credit in your wallet. Recharge your wallet to continue.") . " " . "<strong class='text-link' data-toggle='modal' data-url='#wallet-replenish'>" . __("Recharge Now") . "</strong>");
    }
    /* decrease viewer user wallet balance */
    $db->query(sprintf('UPDATE users SET user_wallet_balance = IF(user_wallet_balance-%1$s<=0,0,user_wallet_balance-%1$s) WHERE user_id = %2$s', secure($amount), secure($this->_data['user_id'], 'int')));
    /* log this transaction */
    $this->wallet_set_transaction($this->_data['user_id'], 'user', $user_id, $amount, 'out');
    /* increase target user wallet balance */
    $db->query(sprintf("UPDATE users SET user_wallet_balance = user_wallet_balance + %s WHERE user_id = %s", secure($amount), secure($user_id, 'int')));
    /* send notification (money sent) to the target user */
    $this->post_notification(['to_user_id' => $user_id, 'action' => 'money_sent', 'node_type' => $amount]);
    /* wallet transaction */
    $this->wallet_set_transaction($user_id, 'user', $this->_data['user_id'], $amount, 'in');
    $_SESSION['wallet_transfer_amount'] = $amount;
  }


  /**
   * wallet_send_tip
   * 
   * @param integer $user_id
   * @param integer $amount
   * @return void
   */
  public function wallet_send_tip($user_id, $amount)
  {
    global $db, $system;
    /* check if wallet enabled */
    if (!$system['wallet_enabled']) {
      throw new Exception(__("The wallet system has been disabled by the admin"));
    }
    /* check if tips enabled */
    if (!$system['tips_enabled']) {
      throw new Exception(__("The tips system has been disabled by the admin"));
    }
    /* validate amount */
    if (is_empty($amount) || !is_numeric($amount) || $amount <= 0) {
      throw new Exception(__("You must enter valid amount of money"));
    }
    if ($amount < $system['tips_min_amount']) {
      throw new Exception(__("The amount is less the minimum amount allowed"));
    }
    if ($amount > $system['tips_max_amount']) {
      throw new Exception(__("The amount is more than the maximum amount allowed"));
    }
    /* validate target user */
    if (is_empty($user_id) || !is_numeric($user_id)) {
      throw new Exception(__("You can't send money to this user!"));
    }
    if ($this->_data['user_id'] == $user_id) {
      throw new Exception(__("You can't send money to yourself!"));
    }
    $check_user = $db->query(sprintf("SELECT COUNT(*) as count FROM users WHERE user_id = %s", secure($user_id, 'int')));
    if ($check_user->fetch_assoc()['count'] == 0) {
      throw new Exception(__("You can't send money to this user!"));
    }
    /* check if target user can receive tips */
    if (!$this->check_user_permission($user_id, 'tips_permission')) {
      throw new Exception(__("This user can't receive tips"));
    }
    /* check viewer balance */
    if ($this->_data['user_wallet_balance'] < $amount) {
      throw new Exception(__("There is not enough credit in your wallet. Recharge your wallet to continue.") . " " . "<strong class='text-link' data-toggle='modal' data-url='#wallet-replenish'>" . __("Recharge Now") . "</strong>");
    }
    /* decrease viewer user wallet balance */
    $db->query(sprintf('UPDATE users SET user_wallet_balance = IF(user_wallet_balance-%1$s<=0,0,user_wallet_balance-%1$s) WHERE user_id = %2$s', secure($amount), secure($this->_data['user_id'], 'int')));
    /* log this transaction */
    $this->wallet_set_transaction($this->_data['user_id'], 'tip', $user_id, $amount, 'out');
    /* increase target user wallet balance */
    $db->query(sprintf("UPDATE users SET user_wallet_balance = user_wallet_balance + %s WHERE user_id = %s", secure($amount), secure($user_id, 'int')));
    /* send notification (money sent) to the target user */
    $this->post_notification(['to_user_id' => $user_id, 'action' => 'tip_sent', 'node_type' => $amount]);
    /* wallet transaction */
    $this->wallet_set_transaction($user_id, 'tip', $this->_data['user_id'], $amount, 'in');
  }


  /**
   * wallet_withdraw_affiliates
   * 
   * @param integer $amount
   * @return void
   */
  public function wallet_withdraw_affiliates($amount)
  {
    global $db, $system;
    /* check if wallet enabled */
    if (!$system['wallet_enabled']) {
      throw new Exception(__("The wallet system has been disabled by the admin"));
    }
    /* check if affiliates enabled */
    if (!$system['affiliates_enabled'] || !$system['affiliates_money_transfer_enabled']) {
      throw new Exception(__("The affiliates system has been disabled by the admin"));
    }
    /* validate amount */
    if (is_empty($amount) || !is_numeric($amount) || $amount <= 0) {
      throw new Exception(__("You must enter valid amount of money"));
    }
    /* check viewer balance */
    if ($this->_data['user_affiliate_balance'] < $amount) {
      throw new Exception(__("The amount is larger than your current affiliates balance") . " " . print_money($this->_data['user_affiliate_balance']));
    }
    /* decrease viewer user affiliate balance */
    $db->query(sprintf('UPDATE users SET user_affiliate_balance = IF(user_affiliate_balance-%1$s=0,0,user_affiliate_balance-%1$s) WHERE user_id = %2$s', secure($amount), secure($this->_data['user_id'], 'int')));
    /* increase viewer user wallet balance */
    $db->query(sprintf("UPDATE users SET user_wallet_balance = user_wallet_balance + %s WHERE user_id = %s", secure($amount), secure($this->_data['user_id'], 'int')));
    /* wallet transaction */
    $this->wallet_set_transaction($this->_data['user_id'], 'withdraw_affiliates', 0, $amount, 'in');
    $_SESSION['wallet_withdraw_affiliates_amount'] = $amount;
  }


  /**
   * wallet_withdraw_points
   * 
   * @param integer $amount
   * @return void
   */
  public function wallet_withdraw_points($amount)
  {
    global $db, $system;
    /* check if wallet enabled */
    if (!$system['wallet_enabled']) {
      throw new Exception(__("The wallet system has been disabled by the admin"));
    }
    /* check if points enabled */
    if (!$system['points_enabled']) {
      throw new Exception(__("The points system has been disabled by the admin"));
    }
    if ($system['points_per_currency'] == 0 || !$system['points_money_transfer_enabled']) {
      throw new Exception(__("Sorry, You can't withdraw points at the moment"));
    }
    /* validate amount */
    if (is_empty($amount) || !is_numeric($amount) || $amount <= 0) {
      throw new Exception(__("You must enter valid amount of money"));
    }
    /* check viewer balance */
    $points_balance = ((1 / $system['points_per_currency']) * $this->_data['user_points']);
    if ($points_balance < $amount) {
      throw new Exception(__("The amount is larger than your current points balance") . " " . print_money($points_balance));
    }
    /* decrease viewer user points balance */
    $balance = $this->_data['user_points'] - ($system['points_per_currency'] * $_POST['amount']);
    $db->query(sprintf("UPDATE users SET user_points = %s WHERE user_id = %s", secure($balance), secure($this->_data['user_id'], 'int')));
    /* increase viewer user wallet balance */
    $db->query(sprintf("UPDATE users SET user_wallet_balance = user_wallet_balance + %s WHERE user_id = %s", secure($amount), secure($this->_data['user_id'], 'int')));
    /* wallet transaction */
    $this->wallet_set_transaction($this->_data['user_id'], 'withdraw_points', 0, $amount, 'in');
    $_SESSION['wallet_withdraw_points_amount'] = $amount;
  }


  /**
   * wallet_withdraw_market
   * 
   * @param integer $amount
   * @return void
   */
  public function wallet_withdraw_market($amount)
  {
    global $db, $system;
    /* check if wallet enabled */
    if (!$system['wallet_enabled']) {
      throw new Exception(__("The wallet system has been disabled by the admin"));
    }
    /* check if market enabled */
    if (!$system['market_enabled'] || !$system['market_money_transfer_enabled']) {
      throw new Exception(__("The market module has been disabled by the admin"));
    }
    /* validate amount */
    if (is_empty($amount) || !is_numeric($amount) || $amount <= 0) {
      throw new Exception(__("You must enter valid amount of money"));
    }
    /* check viewer balance */
    if ($this->_data['user_market_balance'] < $amount) {
      throw new Exception(__("The amount is larger than your current market balance") . " " . print_money($this->_data['user_market_balance']));
    }
    /* decrease viewer user market balance */
    $db->query(sprintf('UPDATE users SET user_market_balance = IF(user_market_balance-%1$s=0,0,user_market_balance-%1$s) WHERE user_id = %2$s', secure($amount), secure($this->_data['user_id'], 'int')));
    /* increase viewer user wallet balance */
    $db->query(sprintf("UPDATE users SET user_wallet_balance = user_wallet_balance + %s WHERE user_id = %s", secure($amount), secure($this->_data['user_id'], 'int')));
    /* wallet transaction */
    $this->wallet_set_transaction($this->_data['user_id'], 'withdraw_market', 0, $amount, 'in');
    $_SESSION['wallet_withdraw_market_amount'] = $amount;
  }


  /**
   * wallet_withdraw_funding
   * 
   * @param integer $amount
   * @return void
   */
  public function wallet_withdraw_funding($amount)
  {
    global $db, $system;
    /* check if wallet enabled */
    if (!$system['wallet_enabled']) {
      throw new Exception(__("The wallet system has been disabled by the admin"));
    }
    /* check if funding enabled */
    if (!$system['funding_enabled'] || !$system['funding_money_transfer_enabled']) {
      throw new Exception(__("The funding module has been disabled by the admin"));
    }
    /* validate amount */
    if (is_empty($amount) || !is_numeric($amount) || $amount <= 0) {
      throw new Exception(__("You must enter valid amount of money"));
    }
    /* check viewer balance */
    if ($this->_data['user_funding_balance'] < $amount) {
      throw new Exception(__("The amount is larger than your current funding balance") . " " . print_money($this->_data['user_funding_balance']));
    }
    /* decrease viewer user funding balance */
    $db->query(sprintf('UPDATE users SET user_funding_balance = IF(user_funding_balance-%1$s=0,0,user_funding_balance-%1$s) WHERE user_id = %2$s', secure($amount), secure($this->_data['user_id'], 'int')));
    /* increase viewer user wallet balance */
    $db->query(sprintf("UPDATE users SET user_wallet_balance = user_wallet_balance + %s WHERE user_id = %s", secure($amount), secure($this->_data['user_id'], 'int')));
    /* wallet transaction */
    $this->wallet_set_transaction($this->_data['user_id'], 'withdraw_funding', 0, $amount, 'in');
    $_SESSION['wallet_withdraw_funding_amount'] = $amount;
  }


  /**
   * wallet_withdraw_monetization
   * 
   * @param integer $amount
   * @return void
   */
  public function wallet_withdraw_monetization($amount)
  {
    global $db, $system;
    /* check if wallet enabled */
    if (!$system['wallet_enabled']) {
      throw new Exception(__("The wallet system has been disabled by the admin"));
    }
    /* check if monetization enabled */
    if (!$system['monetization_enabled'] || !$system['monetization_money_transfer_enabled']) {
      throw new Exception(__("The monetization system has been disabled by the admin"));
    }
    /* validate amount */
    if (is_empty($amount) || !is_numeric($amount) || $amount <= 0) {
      throw new Exception(__("You must enter valid amount of money"));
    }
    /* check viewer balance */
    if ($this->_data['user_monetization_balance'] < $amount) {
      throw new Exception(__("The amount is larger than your current monetization balance") . " " . print_money($this->_data['user_monetization_balance']));
    }
    /* decrease viewer user monetization balance */
    $db->query(sprintf('UPDATE users SET user_monetization_balance = IF(user_monetization_balance-%1$s=0,0,user_monetization_balance-%1$s) WHERE user_id = %2$s', secure($amount), secure($this->_data['user_id'], 'int')));
    /* increase viewer user wallet balance */
    $db->query(sprintf("UPDATE users SET user_wallet_balance = user_wallet_balance + %s WHERE user_id = %s", secure($amount), secure($this->_data['user_id'], 'int')));
    /* wallet transaction */
    $this->wallet_set_transaction($this->_data['user_id'], 'withdraw_monetization', 0, $amount, 'in');
    $_SESSION['wallet_withdraw_monetization_amount'] = $amount;
  }


  /**
   * wallet_set_transaction
   * 
   * @param integer $user_id
   * @param string $node_type
   * @param integer $node_id
   * @param integer $amount
   * @param string $type
   * @return void
   */
  public function wallet_set_transaction($user_id, $node_type, $node_id, $amount, $type)
  {
    global $db, $system, $date;
    $db->query(sprintf("INSERT INTO wallet_transactions (user_id, node_type, node_id, amount, type, date) VALUES (%s, %s, %s, %s, %s, %s)", secure($user_id, 'int'), secure($node_type), secure($node_id, 'int'), secure($amount), secure($type), secure($date)));
  }


  /**
   * wallet_get_transactions
   * 
   * @return array
   */
  public function wallet_get_transactions()
  {
    global $db;
    $transactions = [];
    $get_transactions = $db->query(sprintf("SELECT wallet_transactions.*, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM wallet_transactions LEFT JOIN users ON (wallet_transactions.node_type='user' OR wallet_transactions.node_type='tip') AND wallet_transactions.node_id = users.user_id WHERE wallet_transactions.user_id = %s ORDER BY wallet_transactions.transaction_id DESC", secure($this->_data['user_id'], 'int')));
    if ($get_transactions->num_rows > 0) {
      while ($transaction = $get_transactions->fetch_assoc()) {
        if ($transaction['node_type'] == "user" || $transaction['node_type'] == "tip") {
          $transaction['user_picture'] = get_picture($transaction['user_picture'], $transaction['user_gender']);
        }
        $transactions[] = $transaction;
      }
    }
    return $transactions;
  }


  /**
   * wallet_get_payments
   * 
   * @return array
   */
  public function wallet_get_payments()
  {
    global $db;
    $payments = [];
    $get_payments = $db->query(sprintf("SELECT * FROM wallet_payments WHERE user_id = %s ORDER BY payment_id DESC", secure($this->_data['user_id'], 'int')));
    if ($get_payments->num_rows > 0) {
      while ($payment = $get_payments->fetch_assoc()) {
        $payments[] = $payment;
      }
    }
    return $payments;
  }


  /**
   * wallet_package_payment
   * 
   * @param integer $package_id
   * @return void
   */
  public function wallet_package_payment($package_id)
  {
    global $db, $system;
    /* check if wallet enabled */
    if (!$system['wallet_enabled']) {
      throw new Exception(__("The wallet system has been disabled by the admin"));
    }
    /* check if packages enabled */
    if (!$system['packages_enabled'] || !$system['packages_wallet_payment_enabled']) {
      throw new Exception(__("The packages system has been disabled by the admin"));
    }
    /* check package */
    $package = $this->get_package($package_id);
    if (!$package) {
      _error(400);
    }
    /* check if user already subscribed to this package */
    if ($this->_data['user_subscribed'] && $this->_data['user_package'] == $package['package_id']) {
      modal("SUCCESS", __("Subscribed"), __("You already subscribed to this package, Please select different package"));
    }
    /* check viewer balance */
    if ($this->_data['user_wallet_balance'] < $package['price']) {
      modal("ERROR", __("Sorry"), __("There is not enough credit in your wallet. Recharge your wallet to continue.") . " " . "<strong class='text-link' data-toggle='modal' data-url='#wallet-replenish'>" . __("Recharge Now") . "</strong>");
    }
    /* decrease viewer user wallet balance */
    $db->query(sprintf('UPDATE users SET user_wallet_balance = IF(user_wallet_balance-%1$s<=0,0,user_wallet_balance-%1$s) WHERE user_id = %2$s', secure($package['price']), secure($this->_data['user_id'], 'int')));
    /* log this transaction */
    $this->wallet_set_transaction($this->_data['user_id'], 'package_payment', $package['package_id'], $package['price'], 'out');
    /* update user package */
    $this->update_user_package($package);
    $_SESSION['wallet_package_payment_amount'] = $package['price'];
  }


  /**
   * wallet_marketplace_payment
   * 
   * @param integer $orders_collection_id
   * @return void
   */
  public function wallet_marketplace_payment($orders_collection_id)
  {
    global $db, $system;
    /* check if wallet enabled */
    if (!$system['wallet_enabled']) {
      throw new Exception(__("The wallet system has been disabled by the admin"));
    }
    /* check if market enabled */
    if (!$system['market_enabled'] || !$system['market_wallet_payment_enabled']) {
      throw new Exception(__("The marketplace system has been disabled by the admin"));
    }
    // get orders collection
    $orders_collection = $this->get_orders_collection($orders_collection_id);
    if (!$orders_collection) {
      throw new Exception(__("This orders collection is not available"));
    }
    /* check if the orders collection is already paid */
    if ($orders_collection['paid']) {
      throw new Exception(__("This orders collection is already paid"));
    }
    /* check viewer balance */
    if ($this->_data['user_wallet_balance'] < $orders_collection['total']) {
      modal("ERROR", __("Sorry"), __("There is not enough credit in your wallet. Recharge your wallet to continue.") . " " . "<strong class='text-link' data-toggle='modal' data-url='#wallet-replenish'>" . __("Recharge Now") . "</strong>");
    }
    /* decrease viewer user wallet balance */
    $db->query(sprintf('UPDATE users SET user_wallet_balance = IF(user_wallet_balance-%1$s<=0,0,user_wallet_balance-%1$s) WHERE user_id = %2$s', secure($orders_collection['total']), secure($this->_data['user_id'], 'int')));
    /* log this transaction */
    $this->wallet_set_transaction($this->_data['user_id'], 'market_payment', $orders_collection['orders_collection_id'], $orders_collection['total'], 'out');
    /* mark orders collection as paid */
    $this->mark_orders_collection_as_paid($orders_collection_id);
    $_SESSION['wallet_marketplace_amount'] = $orders_collection['total'];
  }


  /**
   * wallet_monetization_payment
   * 
   * @param integer $plan_id
   * @return void
   */
  public function wallet_monetization_payment($plan_id)
  {
    global $db, $system;
    /* check if wallet enabled */
    if (!$system['wallet_enabled']) {
      throw new Exception(__("The wallet system has been disabled by the admin"));
    }
    /* check if monetization enabled */
    if (!$system['monetization_enabled'] || !$system['monetization_wallet_payment_enabled']) {
      throw new Exception(__("The monetization system has been disabled by the admin"));
    }
    // get monetization plan
    $monetization_plan = $this->get_monetization_plan($plan_id, true);
    if (!$monetization_plan) {
      throw new Exception(__("This monetization plan is not available"));
    }
    /* check if the viewer is subscribed to this node */
    if ($this->is_subscribed($monetization_plan['node_id'], $monetization_plan['node_type'])) {
      modal("SUCCESS", __("Subscribed"), __("You already subscribed to this") . " " . __($monetization_plan['node_type']));
    }
    /* check viewer balance */
    if ($this->_data['user_wallet_balance'] < $monetization_plan['price']) {
      modal("ERROR", __("Sorry"), __("There is not enough credit in your wallet. Recharge your wallet to continue.") . " " . "<strong class='text-link' data-toggle='modal' data-url='#wallet-replenish'>" . __("Recharge Now") . "</strong>");
    }
    /* decrease viewer user wallet balance */
    $db->query(sprintf('UPDATE users SET user_wallet_balance = IF(user_wallet_balance-%1$s<=0,0,user_wallet_balance-%1$s) WHERE user_id = %2$s', secure($monetization_plan['price'], 'float'), secure($this->_data['user_id'], 'int')));
    /* log this transaction */
    $this->wallet_set_transaction($this->_data['user_id'], 'subscribe_' . $monetization_plan['node_type'], $monetization_plan['node_id'], $monetization_plan['price'], 'out');
    /* subscribe to node */
    $this->subscribe($plan_id);
    $_SESSION['wallet_monetization_payment_amount'] = $monetization_plan['price'];
  }


  /**
   * wallet_paid_post
   * 
   * @param integer $post_id
   * @return void
   */
  public function wallet_paid_post($post_id)
  {
    global $db, $system;
    /* check if wallet enabled */
    if (!$system['wallet_enabled']) {
      throw new Exception(__("The wallet system has been disabled by the admin"));
    }
    /* check if monetization enabled */
    if (!$system['monetization_enabled'] || !$system['monetization_wallet_payment_enabled']) {
      throw new Exception(__("The monetization system has been disabled by the admin"));
    }
    // get post
    $post = $this->get_post($post_id, false, false, true);
    if (!$post) {
      throw new Exception(__("This post is not available"));
    }
    if (!$post['needs_payment']) {
      throw new Exception(__("This post doesn't need payment"));
    }
    /* check viewer balance */
    if ($this->_data['user_wallet_balance'] < $post['post_price']) {
      modal("ERROR", __("Sorry"), __("There is not enough credit in your wallet. Recharge your wallet to continue.") . " " . "<strong class='text-link' data-toggle='modal' data-url='#wallet-replenish'>" . __("Recharge Now") . "</strong>");
    }
    /* decrease viewer user wallet balance */
    $db->query(sprintf('UPDATE users SET user_wallet_balance = IF(user_wallet_balance-%1$s<=0,0,user_wallet_balance-%1$s) WHERE user_id = %2$s', secure($post['post_price'], 'float'), secure($this->_data['user_id'], 'int')));
    /* log this transaction */
    $this->wallet_set_transaction($this->_data['user_id'], 'paid_post', $post_id, $post['post_price'], 'out');
    /* unlock paid post */
    $this->unlock_paid_post($post_id);
    $_SESSION['wallet_paid_post_amount'] = $post['post_price'];
  }


  /**
   * wallet_donate
   * 
   * @param integer $post_id
   * @param float $amount
   * @return void
   */
  public function wallet_donate($post_id, $donation_amount)
  {
    global $db, $system, $date;
    /* check if wallet enabled */
    if (!$system['wallet_enabled']) {
      throw new Exception(__("The wallet system has been disabled by the admin"));
    }
    /* check if funding enabled */
    if (!$system['funding_enabled'] || !$system['funding_wallet_payment_enabled']) {
      throw new Exception(__("The funding system has been disabled by the admin"));
    }
    // get post
    $post = $this->get_post($post_id, false, false, true);
    if (!$post) {
      throw new Exception(__("This post is not available"));
    }
    /* prepare commission */
    $commission = ($system['funding_commission']) ? $donation_amount * ($system['funding_commission'] / 100) : 0;
    $donation_amount_net = $donation_amount - $commission;
    /* check viewer balance */
    if ($this->_data['user_wallet_balance'] < $donation_amount) {
      modal("ERROR", __("Sorry"), __("There is not enough credit in your wallet. Recharge your wallet to continue.") . " " . "<strong class='text-link' data-toggle='modal' data-url='#wallet-replenish'>" . __("Recharge Now") . "</strong>");
    }
    /* update funding request */
    $db->query(sprintf("UPDATE posts_funding SET raised_amount = raised_amount + %s, total_donations = total_donations + 1 WHERE post_id = %s", secure($donation_amount_net), secure($post_id, 'int')));
    /* insert donor */
    $db->query(sprintf("INSERT INTO posts_funding_donors (user_id, post_id, donation_amount, donation_time) VALUES (%s, %s, %s, %s)", secure($this->_data['user_id'], 'int'), secure($post_id, 'int'), secure($donation_amount_net), secure($date)));
    /* increase target user funding balance */
    $db->query(sprintf("UPDATE users SET user_funding_balance = user_funding_balance + %s WHERE user_id = %s", secure($donation_amount_net), secure($post['author_id'], 'int')));
    /* log commission */
    $this->log_commission($post['author_id'], $commission, 'donate');
    /* send notification to the post author */
    $this->post_notification(['to_user_id' => $post['author_id'], 'action' => 'funding_donation', 'node_type' => $donation_amount_net, 'node_url' => $post_id]);
    /* decrease viewer user wallet balance */
    $db->query(sprintf('UPDATE users SET user_wallet_balance = IF(user_wallet_balance-%1$s<=0,0,user_wallet_balance-%1$s) WHERE user_id = %2$s', secure($donation_amount, 'float'), secure($this->_data['user_id'], 'int')));
    /* log this transaction */
    $this->wallet_set_transaction($this->_data['user_id'], 'donate', $post_id, $donation_amount, 'out');
    $_SESSION['wallet_donate_amount'] = $donation_amount;
  }


  /**
   * wallet_chat_payment
   * 
   * @param float $chat_price
   * @param array $paid_recipients
   * @return void
   */
  public function wallet_chat_payment($chat_price, $paid_recipients)
  {
    global $db, $system;
    /* check if wallet enabled */
    if (!$system['wallet_enabled']) {
      throw new AuthorizationException(__("The wallet system has been disabled by the admin"));
    }
    /* check viewer balance */
    if ($this->_data['user_wallet_balance'] < $chat_price) {
      throw new ValidationException(__("This message will cost you") . " " . print_money($chat_price) . " " . __("and you have") . " " . print_money($this->_data['user_wallet_balance']) . " " . __("in your wallet, Recharge your wallet to continue"));
    }
    /* decrease viewer user wallet balance */
    $db->query(sprintf('UPDATE users SET user_wallet_balance = IF(user_wallet_balance-%1$s<=0,0,user_wallet_balance-%1$s) WHERE user_id = %2$s', secure($chat_price, 'float'), secure($this->_data['user_id'], 'int')));
    /* log this transaction */
    $this->wallet_set_transaction($this->_data['user_id'], 'paid_chat_message', null, $chat_price, 'out');
    /* loop through the paid recipients */
    foreach ($paid_recipients as $recipient) {
      /* prepare commission */
      $message_price = $recipient['user_monetization_chat_price'];
      $commission = ($system['monetization_commission']) ? $message_price * ($system['monetization_commission'] / 100) : 0;
      $message_price = $message_price - $commission;
      /* increase recipient monetization balance */
      $db->query(sprintf("UPDATE users SET user_monetization_balance = user_monetization_balance + %s WHERE user_id = %s", secure($message_price, 'float'), secure($recipient['user_id'], 'int')));
      /* log commission */
      $this->log_commission($recipient['user_id'], $commission, 'paid_message');
      /* notify the recipient */
      $this->post_notification(['to_user_id' => $recipient['user_id'], 'action' => 'chat_message_paid', 'node_type' => $message_price]);
    }
  }


  /**
   * wallet_call_payment
   * 
   * @param float $call_price
   * @param int $from_user_id
   * @param int $to_user_id
   * @return void
   */
  public function wallet_call_payment($call_price, $from_user_id, $to_user_id)
  {
    global $db, $system;
    /* check if wallet enabled */
    if (!$system['wallet_enabled']) {
      throw new Exception(__("The wallet system has been disabled by the admin"));
    }
    /* check from_user_id balance */
    $from_user = $this->get_user($from_user_id);
    if ($from_user['user_wallet_balance'] < $call_price) {
      throw new Exception(__("This call will cost you") . " " . print_money($call_price) . " " . __("and you have") . " " . print_money($from_user['user_wallet_balance']) . " " . __("in your wallet, Recharge your wallet to continue") . " " . "<strong class='text-link' data-toggle='modal' data-url='#wallet-replenish'>" . __("Recharge Now") . "</strong>");
    }
    /* decrease from_user_id wallet balance */
    $db->query(sprintf('UPDATE users SET user_wallet_balance = IF(user_wallet_balance-%1$s<=0,0,user_wallet_balance-%1$s) WHERE user_id = %2$s', secure($call_price, 'float'), secure($from_user_id, 'int')));
    /* log this transaction */
    $this->wallet_set_transaction($from_user_id, 'paid_call', $to_user_id, $call_price, 'out');
    /* prepare commission */
    $commission = ($system['monetization_commission']) ? $call_price * ($system['monetization_commission'] / 100) : 0;
    $call_price = $call_price - $commission;
    /* increase to_user_id monetization balance */
    $db->query(sprintf("UPDATE users SET user_monetization_balance = user_monetization_balance + %s WHERE user_id = %s", secure($call_price, 'float'), secure($to_user_id, 'int')));
    /* log commission */
    $this->log_commission($to_user_id, $commission, 'paid_call');
  }


  /**
   * wallet_paid_module_payment
   * 
   * @param float $module
   * @return void
   */
  public function wallet_paid_module_payment($module)
  {
    global $db, $system;
    /* check if wallet enabled */
    if (!$system['wallet_enabled']) {
      throw new Exception(__("The wallet system has been disabled by the admin"));
    }
    /* check the module enabled */
    switch ($module) {
      case 'blogs':
        $module_price = $system['paid_blogs_cost'];
        $post_type = __('blog post');
        break;
      case 'products':
        $module_price = $system['paid_products_cost'];
        $post_type = __('product post');
        break;
      case 'funding':
        $module_price = $system['paid_funding_cost'];
        $post_type = __('funding post');
        break;
      case 'offers':
        $module_price = $system['paid_offers_cost'];
        $post_type = __('offer post');
        break;
      case 'jobs':
        $module_price = $system['paid_jobs_cost'];
        $post_type = __('job post');
        break;
      case 'courses':
        $module_price = $system['paid_courses_cost'];
        $post_type = __('course post');
        break;
      default:
        throw new Exception(__("Invalid module"));
    }
    /* check user wallet balance */
    if ($this->_data['user_wallet_balance'] < $module_price) {
      throw new Exception(__("This") . " " . $post_type . " " . __("will cost you") . " " . print_money($module_price) . " " . __("and you have") . " " . print_money($this->_data['user_wallet_balance']) . " " . __("in your wallet, Recharge your wallet to continue") . " " . "<strong class='text-link' data-toggle='modal' data-url='#wallet-replenish'>" . __("Recharge Now") . "</strong>");
    }
    /* decrease user wallet balance */
    $db->query(sprintf('UPDATE users SET user_wallet_balance = IF(user_wallet_balance-%1$s<=0,0,user_wallet_balance-%1$s) WHERE user_id = %2$s', secure($module_price, 'float'), secure($this->_data['user_id'], 'int')));
    /* log this transaction */
    $this->wallet_set_transaction($this->_data['user_id'], $module . '_module_payment', 0, $module_price, 'out');
  }


  /**
   * reset_all_users_wallets
   * 
   * @return void
   */
  public function reset_all_users_wallets()
  {
    global $db;
    $db->query("UPDATE users SET user_wallet_balance = '0'");
    /* truncate wallet payments */
    $db->query("TRUNCATE TABLE wallet_payments");
    /* truncate wallet transactions */
    $db->query("TRUNCATE TABLE wallet_transactions");
  }
}
