<?php

/**
 * webhooks -> ccbill (ENS - Event Notification System, JSON format)
 *
 * @package Sngine
 * @author Zamblek
 */

// fetch bootstrap
require('../bootstrap.php');

try {

  // check if CCBill enabled
  if (!$system['ccbill_enabled']) {
    throw new Exception('CCBill payments are disabled');
  }

  // get the raw body
  $raw_body = file_get_contents('php://input');

  // log the webhook
  ccbill_log('info', 'Webhook received', [
    'ip' => $_SERVER['REMOTE_ADDR'] ?? '',
    'eventType' => $_GET['eventType'] ?? '',
    'eventGroup' => $_GET['eventGroupType'] ?? '',
    'GET' => $_GET,
    'raw_body' => $raw_body,
  ]);

  // parse the raw body
  $data = json_decode($raw_body, true);
  if (!is_array($data)) {
    throw new Exception('Failed to parse JSON body');
  }

  // get the webhook data
  $event_type = $_GET['eventType'] ?? $data['eventType'] ?? '';
  $event_group = $_GET['eventGroupType'] ?? $data['eventGroup'] ?? '';
  $client_accnum = $data['clientAccnum'] ?? $_GET['clientAccnum'] ?? '';
  $subscription_id = $data['subscriptionId'] ?? '';
  $billed_amount = $data['billedInitialPrice'] ?? $data['accountingInitialPrice'] ?? '';
  $failure_code = $data['failureCode'] ?? $data['declineCode'] ?? '';
  $failure_reason = $data['failureReason'] ?? $data['declineText'] ?? '';
  $x_payment_id = $data['X-X-payment-id'] ?? $data['X_X_payment_id'] ?? null;
  $x_user_id = $data['X-X-user-id'] ?? $data['X_X_user_id'] ?? null;
  $x_handle = $data['X-X-handle'] ?? $data['X_X_handle'] ?? null;
  $x_reference_id = $data['X-X-reference-id'] ?? $data['X_X_reference_id'] ?? null;

  // log the event parsed
  ccbill_log('info', 'Event parsed', [
    'eventType' => $event_type,
    'eventGroup' => $event_group,
    'clientAccnum' => $client_accnum,
    'subscriptionId' => $subscription_id,
    'X-payment-id' => $x_payment_id,
    'X-user-id' => $x_user_id,
    'X-handle' => $x_handle,
    'X-reference-id' => $x_reference_id,
    'all_keys' => array_keys($data),
  ]);

  // verify the request is from our CCBill account
  if ($client_accnum && (string)$client_accnum !== (string)$system['ccbill_account_number']) {
    throw new Exception('Account number mismatch — expected ' . $system['ccbill_account_number'] . ', received ' . $client_accnum);
  }

  // check if the event type is missing
  if (!$event_type) {
    throw new Exception('Missing eventType');
  }

  // process the event
  switch ($event_type) {
    case 'NewSaleSuccess':
      // check if the payment id or subscription id is missing
      if (!$x_payment_id || !$subscription_id) {
        throw new Exception('NewSaleSuccess missing required fields — X-payment-id: ' . $x_payment_id . ', subscriptionId: ' . $subscription_id);
      }

      // get the payment record
      $payment = ccbill_get_payment_by_id($x_payment_id);
      if (!$payment) {
        throw new Exception('Payment record not found — payment_id: ' . $x_payment_id);
      }

      // log the payment record
      ccbill_log('info', 'Payment record loaded', [
        'payment_id' => $payment['payment_id'],
        'user_id' => $payment['user_id'],
        'handle' => $payment['handle'],
        'amount' => $payment['amount'],
        'status' => $payment['payment_status'],
      ]);

      // check if the payment is already processed
      if ($payment['payment_status'] === 'paid') {
        ccbill_log('warn', 'NewSaleSuccess duplicate — already processed', ['payment_id' => $payment['payment_id']]);
        break;
      }

      // process the payment
      switch ($payment['handle']) {
        case 'packages':
          /* get the package */
          $package = $user->get_package($payment['reference_id']);
          if (!$package) {
            throw new Exception('Invalid package');
          }
          /* update user package */
          $user->update_user_package($package, $payment['user_id']);
          /* insert the recurring payment */
          $user->insert_recurring_payments('ccbill', 'packages', $payment['reference_id'], $subscription_id, $payment['user_id']);
          /* log payment */
          $price = (isset($package['discounted_price']) && $package['discounted_price'] > 0) ? $package['discounted_price'] : $package['price'];
          $user->log_payment($payment['user_id'], $price, 'ccbill', 'packages');
          break;

        case 'wallet':
          /* update the user wallet balance */
          $user->wallet_update_balance($payment['amount'], '+', $payment['user_id']);
          /* wallet transaction */
          $user->wallet_set_transaction($payment['user_id'], 'recharge', 0, $payment['amount'], 'in');
          /* log payment */
          $user->log_payment($payment['user_id'], $payment['amount'], 'ccbill', 'wallet');
          break;

        case 'donate':
          /* funding donation */
          $user->funding_donation($payment['reference_id'], $payment['amount'], $payment['user_id']);
          /* log payment */
          $user->log_payment($payment['user_id'], $payment['amount'], 'ccbill', 'donate');
          break;

        case 'subscribe':
          /* get monetization plan */
          $monetization_plan = $user->get_monetization_plan($payment['reference_id'], true);
          if (!$monetization_plan) {
            throw new Exception('Invalid monetization plan');
          }
          /* insert the recurring payment */
          $user->insert_recurring_payments('ccbill', 'subscribe', $payment['reference_id'], $subscription_id, $payment['user_id']);
          /* subscribe to node */
          $user->subscribe($payment['reference_id'], $payment['user_id']);
          /* log payment */
          $price = ($monetization_plan['discounted_price'] > 0) ? $monetization_plan['discounted_price'] : $monetization_plan['price'];
          $user->log_payment($payment['user_id'], $price, 'ccbill', 'subscribe');
          break;

        case 'paid_post':
          /* get the post */
          $post = $user->get_post($payment['reference_id'], false, true, true);
          if (!$post) {
            throw new Exception('Invalid post');
          }
          /* unlock the paid post */
          $user->unlock_paid_post($payment['reference_id'], $payment['user_id']);
          /* log payment */
          $price = (isset($post['post_price_discounted']) && $post['post_price_discounted'] > 0) ? $post['post_price_discounted'] : $post['post_price'];
          $user->log_payment($payment['user_id'], $price, 'ccbill', 'paid_post');
          break;

        case 'movies':
          /* get the movie */
          $movie = $user->get_movie($payment['reference_id']);
          if (!$movie) {
            throw new Exception('Invalid movie');
          }
          /* movie payment */
          $user->movie_payment($payment['reference_id'], $payment['user_id']);
          /* log payment */
          $user->log_payment($payment['user_id'], $movie['price'], 'ccbill', 'movies');
          break;

        case 'marketplace':
          /* get the orders collection */
          $orders_collection = $user->get_orders_collection($payment['reference_id']);
          if (!$orders_collection) {
            throw new Exception('Invalid orders collection');
          }
          /* mark the orders collection as paid */
          $user->mark_orders_collection_as_paid($payment['reference_id']);
          /* log payment */
          $user->log_payment($payment['user_id'], $orders_collection['total'], 'ccbill', 'marketplace');
          break;

        default:
          throw new Exception('Invalid payment handle: ' . $payment['handle']);
      }

      // update the payment status
      ccbill_update_payment_status($payment['payment_id'], 'paid');

      // notify the user
      $user->post_notification(['to_user_id' => $payment['user_id'], 'system_notification' => true, 'action' => 'ccbill_complete']);

      // log the event
      ccbill_log('info', 'NewSaleSuccess fulfilled', [
        'payment_id' => $payment['payment_id'],
        'user_id' => $payment['user_id'],
        'handle' => $payment['handle'],
        'subscription_id' => $subscription_id,
      ]);
      break;


    case 'NewSaleFailure':
      // check if the payment id is set
      if ($x_payment_id) {
        /* get the payment */
        $payment = ccbill_get_payment_by_id($x_payment_id);
        if (!$payment) {
          throw new Exception('Payment record not found — payment_id: ' . $x_payment_id);
        }
        /* check if the payment is pending */
        if ($payment['payment_status'] === 'pending') {
          /* update the payment status */
          ccbill_update_payment_status($payment['payment_id'], 'failed');
          /* notify the user */
          $user->post_notification(['to_user_id' => $payment['user_id'], 'system_notification' => true, 'action' => 'ccbill_failed']);
          /* log the event */
          ccbill_log('warn', 'NewSaleFailure — payment marked failed', [
            'payment_id' => $payment['payment_id'],
            'user_id' => $payment['user_id'],
            'handle' => $payment['handle'],
            'failureCode' => $failure_code,
            'failureReason' => $failure_reason,
          ]);
        }
      }
      break;


    case 'RenewalSuccess':
      // check if the subscription id is set
      $recurring_payment = $subscription_id ? $user->get_recurring_payment('ccbill', $subscription_id) : null;
      if (!$recurring_payment) {
        ccbill_log('warn', 'RenewalSuccess — no recurring record found', ['subscriptionId' => $subscription_id]);
        break;
      }

      // process the recurring payment
      switch ($recurring_payment['handle']) {
        case 'packages':
          /* get the package */
          $package = $user->get_package($recurring_payment['handle_id']);
          if (!$package) {
            throw new Exception('Package not found');
          }
          /* update the user package */
          $user->update_user_package($package, $recurring_payment['user_id']);
          /* log payment */
          $price = ($package['discounted_price'] > 0) ? $package['discounted_price'] : $package['price'];
          $user->log_payment($recurring_payment['user_id'], $price, 'ccbill', 'packages');
          break;

        case 'subscribe':
          /* get the monetization plan */
          $monetization_plan = $user->get_monetization_plan($recurring_payment['handle_id'], true);
          if (!$monetization_plan) {
            throw new Exception('Monetization plan not found');
          }
          /* subscribe to node */
          $user->subscribe($recurring_payment['handle_id'], $recurring_payment['user_id'], true);
          /* log payment */
          $price = ($monetization_plan['discounted_price'] > 0) ? $monetization_plan['discounted_price'] : $monetization_plan['price'];
          $user->log_payment($recurring_payment['user_id'], $price, 'ccbill', 'subscribe');
          break;
      }

      // log the event
      ccbill_log('info', 'RenewalSuccess processed', [
        'subscriptionId' => $subscription_id,
        'handle' => $recurring_payment['handle'],
        'user_id' => $recurring_payment['user_id'],
      ]);
      break;


    case 'RenewalFailure':
      // log the event
      ccbill_log('warn', 'RenewalFailure — rebill declined', [
        'subscriptionId' => $subscription_id,
        'failureCode' => $failure_code,
        'failureReason' => $failure_reason,
      ]);
      break;

    case 'Cancellation':
    case 'Expiration':
      // check if the subscription id is set
      $recurring_payment = $subscription_id ? $user->get_recurring_payment('ccbill', $subscription_id) : null;
      if (!$recurring_payment) {
        ccbill_log('warn', $event_type . ' — no recurring record found', ['subscriptionId' => $subscription_id]);
        break;
      }

      // process the recurring payment
      switch ($recurring_payment['handle']) {
        case 'packages':
          /* update the user package */
          $user->unsubscribe_user_package($recurring_payment['user_id']);
          break;

        case 'subscribe':
          /* delete the subscriber */
          $user->unsubscribe($recurring_payment['handle_id'], $recurring_payment['user_id']);
          break;
      }

      // log the event
      ccbill_log('info', $event_type . ' — access revoked', [
        'subscriptionId' => $subscription_id,
        'handle' => $recurring_payment['handle'],
        'user_id' => $recurring_payment['user_id'],
      ]);
      break;
  }

  // log the event
  ccbill_log('info', 'Webhook completed OK', ['eventType' => $event_type]);
} catch (Exception $e) {

  // log the exception
  ccbill_log('error', 'Exception: ' . $e->getMessage(), [
    'file' => $e->getFile(),
    'line' => $e->getLine(),
  ]);

  // return error with 200 status code
  header('HTTP/1.1 200 OK');
  header('Content-Type: application/json');
  return_json(['error' => true, 'message' => $e->getMessage()]);
}
