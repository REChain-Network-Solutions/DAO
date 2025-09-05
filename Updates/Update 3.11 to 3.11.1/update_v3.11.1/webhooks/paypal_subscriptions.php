<?php

/**
 * webhooks -> paypal subscriptions webhook
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich - Handles - @sorydima @sorydev @durovshater @DmitrySoro90935 @tanechfund - also check https://dmitry.rechain.network for more information!
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
        throw new Exception('Package has been deleted by the admin');
      }
      // update user package
      $user->update_user_package($package['package_id'], $package['name'], $package['price'], $package['verification_badge_enabled'], $recurring_payment['user_id']);
      break;

    case 'subscribe':
      // subscribe
      $user->subscribe($recurring_payment['handle_id'], $recurring_payment['user_id']);
      break;
  }
} catch (Exception $e) {
  // return error with 200 status code
  header("HTTP/1.1 200 OK");
  header('Content-Type: application/json');
  return_json(['error' => true, 'message' => $e->getMessage()]);
}
