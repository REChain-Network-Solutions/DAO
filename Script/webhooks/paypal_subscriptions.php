<?php

/**
 * webhooks -> paypal subscriptions webhook
 * 
 * @package Sngine
 * @author Zamblek
 */

// fetch bootloader
require('../bootloader.php');

try {

  // check if paypal is enabled
  if (!$system['paypal_enabled']) {
    throw new Exception(__("PayPal is not enabled"));
  }

  // get the webhook notification data
  $webhook_data = json_decode(file_get_contents('php://input'), true);

  // verify webhook signature
  if (!paypal_verify_webhook_signature(_getallheaders(), $webhook_data)) {
    throw new Exception('Invalid webhook signature');
  }

  // get the recurring payment details
  $recurring_payment = $user->get_recurring_payment('paypal', $webhook_data['resource']['billing_agreement_id']);
  if (!$recurring_payment) {
    throw new Exception('Invalid recurring payment');
  }

  // check payment
  switch ($recurring_payment['handle']) {
    case 'packages':
      // get package
      $package = $user->get_package($recurring_payment['handle_id']);
      if (!$package) {
        throw new Exception('Package has been deleted');
      }
      // update user package
      $user->update_user_package($package, $recurring_payment['user_id']);
      // log payment
      $price = (isset($package['discounted_price']) && $package['discounted_price'] > 0) ? $package['discounted_price'] : $package['price'];
      $user->log_payment($recurring_payment['user_id'], $price, 'paypal', 'packages');
      break;

    case 'subscribe':
      // get monetization plan
      $monetization_plan = $user->get_monetization_plan($recurring_payment['handle_id'], true);
      if (!$monetization_plan) {
        throw new Exception('Monetization plan has been deleted');
      }
      // subscribe
      $user->subscribe($recurring_payment['handle_id'], $recurring_payment['user_id'], true);
      // log payment
      $price = (isset($monetization_plan['discounted_price']) && $monetization_plan['discounted_price'] > 0) ? $monetization_plan['discounted_price'] : $monetization_plan['price'];
      $user->log_payment($recurring_payment['user_id'], $price, 'paypal', 'subscribe');
      break;
  }
} catch (Exception $e) {
  // return error with 200 status code
  header("HTTP/1.1 200 OK");
  header('Content-Type: application/json');
  return_json(['error' => true, 'message' => $e->getMessage()]);
}
