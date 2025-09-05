<?php

/**
 * trait -> payments
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich - Handles - @sorydima @sorydev @durovshater @DmitrySoro90935 @tanechfund - also check https://dmitry.rechain.network for more information!
 */

trait PaymentsTrait
{

  /* ------------------------------- */
  /* CoinPayments */
  /* ------------------------------- */

  /**
   * coinpayments
   * 
   * @param string $handle
   * @param string $price
   * @param integer $id
   * @return string
   */
  public function coinpayments($handle, $price, $id = null)
  {
    global $system;
    /* prepare */
    switch ($handle) {
      case 'packages':
        $product = __($system['system_title']) . " " . __('Pro Package');
        $description = __('Pay For') . " " . __($system['system_title']);
        $URL['success'] = $system['system_url'] . "/settings/coinpayments";
        $URL['cancel'] = $system['system_url'];
        $URL['ipn'] = $system['system_url'] . "/webhooks/coinpayments.php?handle=packages&package_id=$id";
        break;

      case 'wallet':
        $product = __($system['system_title']) . " " . __('Wallet');
        $description = __('Pay For') . " " . __($system['system_title']);
        $URL['success'] = $system['system_url'] . "/settings/coinpayments";
        $URL['cancel'] = $system['system_url'];
        $URL['ipn'] = $system['system_url'] . "/webhooks/coinpayments.php?handle=wallet";
        break;

      case 'donate':
        $product = __($system['system_title']) . " " . __('Funding Donation');
        $description = __('Pay For') . " " . __($system['system_title']);
        $URL['success'] = $system['system_url'] . "/settings/coinpayments";
        $URL['cancel'] = $system['system_url'];
        $URL['ipn'] = $system['system_url'] . "/webhooks/coinpayments.php?handle=donate&post_id=$id";
        break;

      case 'subscribe':
        $product = __($system['system_title']) . " " . __('Subscribe');
        $description = __('Pay For') . " " . __($system['system_title']);
        $URL['success'] = $system['system_url'] . "/settings/coinpayments";
        $URL['cancel'] = $system['system_url'];
        $URL['ipn'] = $system['system_url'] . "/webhooks/coinpayments.php?handle=subscribe&plan_id=$id";
        break;

      default:
        _error(400);
        break;
    }
    /* set new coinpayments transaction */
    $transaction_id = $this->set_coinpayments_transaction($price, $product);
    /* CoinPayments */
    $form = '';
    $form =  '<form action="https://www.coinpayments.net/index.php" method="post">';
    $form .= '<input type="hidden" name="cmd" value="_pay_simple">';
    $form .= '<input type="hidden" name="reset" value="1">';
    $form .= '<input type="hidden" name="merchant" value="' . $system['coinpayments_merchant_id'] . '">';
    $form .= '<input type="hidden" name="item_name" value="' . $product . '">';
    $form .= '<input type="hidden" name="item_desc" value="' . $description . '">';
    $form .= '<input type="hidden" name="currency" value="' . $system['system_currency'] . '">';
    $form .= '<input type="hidden" name="amountf" value="' . $price . '">';
    $form .= '<input type="hidden" name="want_shipping" value="0">';
    $form .= '<input type="hidden" name="success_url" value="' . $URL['success'] . '">';
    $form .= '<input type="hidden" name="cancel_url" value="' . $URL['cancel'] . '">';
    $form .= '<input type="hidden" name="ipn_url" value="' . $URL['ipn'] . '">';
    $form .= '<input type="hidden" name="custom" value="' . $transaction_id . '">';
    $form .= '<input type="image" src="https://www.coinpayments.net/images/pub/CP-main-medium.png" alt="Buy Now with CoinPayments.net">';
    $form .= '</form>';
    return $form;
  }


  /**
   * check_coinpayments_payment
   * 
   * @param integer $transaction_id
   * @return boolean
   */
  public function check_coinpayments_payment($transaction_id)
  {
    global $system;
    if (!isset($_POST['ipn_mode']) || !isset($_POST['merchant'])) {
      $this->update_coinpayments_transaction($transaction_id, "Error (400): Bad Reuqeust [Missing POST data from callback]", '-1');
    }
    switch ($_POST['ipn_mode']) {
      case 'httpauth':
        if ($_SERVER['PHP_AUTH_USER'] != $system['coinpayments_merchant_id'] || $_SERVER['PHP_AUTH_PW'] != $system['coinpayments_ipn_secret']) {
          $this->update_coinpayments_transaction($transaction_id, "Error (400): Bad Reuqeust [Unauthorized HTTP Request]", '-1');
        }
        break;

      case 'hmac':
        /* create the HMAC hash to compare to the recieved one, using the secret key */
        $hmac = hash_hmac("sha512", file_get_contents('php://input'), $system['coinpayments_ipn_secret']);
        if ($hmac != $_SERVER['HTTP_HMAC']) {
          $this->update_coinpayments_transaction($transaction_id, "Error (400): Bad Reuqeust [Unauthorized HMAC Request]", '-1');
        }
        break;

      default:
        $this->update_coinpayments_transaction($transaction_id, "Error (400): Bad Reuqeust [Invalid IPN Mode]", '-1');
        break;
    }
    /* check the request status */
    if ($_POST['merchant'] != $system['coinpayments_merchant_id']) {
      $this->update_coinpayments_transaction($transaction_id, "Error (400): Bad Reuqeust [Mismatching Merchant ID]", '-1');
      return false;
    }
    if (intval($_POST['status']) >= 100 || intval($_POST['status']) == 2) {
      /* the payment complete successfully */
      return true;
    } else {
      /* the payment is pending */
      $this->update_coinpayments_transaction($transaction_id, __("Your payment is pending"), '1');
    }
  }


  /**
   * set_coinpayments_transaction
   * 
   * @param string $amount
   * @param string $product
   * @return integer
   */
  public function set_coinpayments_transaction($amount, $product)
  {
    global $db, $system, $date;
    $db->query(sprintf("INSERT INTO coinpayments_transactions (user_id, amount, product, created_at, last_update, status) VALUES (%s, %s, %s, %s, %s, '0')", secure($this->_data['user_id'], 'int'), secure($amount), secure($product), secure($date), secure($date)));
    return $db->insert_id;
  }


  /**
   * get_coinpayments_transaction
   * 
   * @param integer $transaction_id
   * @param string $transaction_txn_id
   * @return array
   */
  public function get_coinpayments_transaction($transaction_id, $transaction_txn_id)
  {
    global $db;
    $get_transaction = $db->query(sprintf("SELECT * FROM coinpayments_transactions WHERE transaction_id = %s", secure($transaction_id, 'int')));
    if ($get_transaction->num_rows == 0) {
      return false;
    }
    $transaction = $get_transaction->fetch_assoc();
    if (is_empty($transaction['transaction_txn_id'])) {
      $db->query(sprintf("UPDATE coinpayments_transactions SET transaction_txn_id = %s WHERE transaction_id = %s", secure($transaction_txn_id), secure($transaction_id, 'int')));
    }
    return $transaction;
  }


  /**
   * update_coinpayments_transaction
   * 
   * @param integer $transaction_id
   * @param string $status_message
   * @param integer $status
   * @return void
   */
  public function update_coinpayments_transaction($transaction_id, $status_message, $status = 0)
  {
    global $db, $date;
    $db->query(sprintf("UPDATE coinpayments_transactions SET status = %s, status_message = %s, last_update = %s WHERE transaction_id = %s", secure($status, 'int'), secure($status_message), secure($date), secure($transaction_id, 'int')));
    exit;
  }


  /**
   * get_coinpayments_transactions
   * 
   * @param boolean $get_all
   * @return array
   */
  public function get_coinpayments_transactions($get_all = false)
  {
    global $db;
    $transactions = [];
    if ($get_all) {
      $get_transactions = $db->query("SELECT coinpayments_transactions.*, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM coinpayments_transactions LEFT JOIN users ON coinpayments_transactions.user_id = users.user_id  ORDER BY coinpayments_transactions.created_at DESC, coinpayments_transactions.last_update DESC");
    } else {
      $get_transactions = $db->query(sprintf("SELECT * FROM coinpayments_transactions WHERE user_id = %s ORDER BY transaction_id DESC", secure($this->_data['user_id'], 'int')));
    }
    if ($get_transactions->num_rows > 0) {
      while ($transaction = $get_transactions->fetch_assoc()) {
        if ($get_all) {
          $transaction['user_picture'] = get_picture($transaction['user_picture'], $transaction['user_gender']);
        }
        $transactions[] = $transaction;
      }
    }
    return $transactions;
  }



  /* ------------------------------- */
  /* Recurring Payments */
  /* ------------------------------- */

  /**
   * insert_recurring_payments
   * 
   * @param string $payment_gateway
   * @param string $handle
   * @param integer $handle_id
   * @param string $subscription_id
   * @return void
   */
  public function insert_recurring_payments($payment_gateway, $handle, $handle_id, $subscription_id)
  {
    global $db, $date;
    /* check handle */
    if (!in_array($handle, ['packages', 'subscribe'])) {
      throw new Exception(__("Invalid handle"));
    }
    $db->query(sprintf("INSERT INTO users_recurring_payments (user_id, payment_gateway, handle, handle_id, subscription_id, time) VALUES (%s, %s, %s, %s, %s, %s)", secure($this->_data['user_id'], 'int'), secure($payment_gateway), secure($handle), secure($handle_id, 'int'), secure($subscription_id), secure($date)));
  }


  /**
   * get_recurring_payment
   * 
   * @param string $payment_gateway
   * @param string $subscription_id
   * @return array
   */
  public function get_recurring_payment($payment_gateway, $subscription_id)
  {
    global $db;
    $get_recurring_payment = $db->query(sprintf("SELECT * FROM users_recurring_payments WHERE payment_gateway = %s AND subscription_id = %s", secure($payment_gateway), secure($subscription_id)));
    if ($get_recurring_payment->num_rows == 0) {
      return false;
    }
    return $get_recurring_payment->fetch_assoc();
  }
}
