<?php

/**
 * webhooks -> mercadopago callback
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich - Handles - @sorydima @sorydev @durovshater @DmitrySoro90935 @tanechfund - also check https://dmitry.rechain.network for more information!
 */

// fetch bootloader
require('../bootloader.php');

try {

  // get Webhook Payload
  $input = file_get_contents("php://input");
  $data = json_decode($input, true);

  // check payload
  if (!$data || !isset($data['data']) || !isset($data['data']['id'])) {
    throw new Exception('Invalid payload');
  }

  // get full payment details
  $payment_id = $data['data']['id'];
  $payment_info = mercadopago_check($payment_id);
  if ($payment_info === false) {
    throw new Exception('Invalid payment');
  }

  // check payment status
  if ($payment_info['status'] !== 'approved') {
    throw new Exception('Payment not approved');
  }

  // check metadata exists
  if (!isset($payment_info['metadata']) || !is_array($payment_info['metadata'])) {
    throw new Exception('Missing metadata');
  }

  // extract details from metadata
  $metadata = $payment_info['metadata'];
  $handle = isset($metadata['handle']) ? $metadata['handle'] : null;
  $id = isset($metadata['id']) ? $metadata['id'] : null;
  $user_id = isset($metadata['user_id']) ? $metadata['user_id'] : null;
  $price = isset($metadata['price']) ? floatval($metadata['price']) : null;

  // validate metadata fields
  if (!$handle || !$id || !$user_id || !$price) {
    throw new Exception('Invalid metadata');
  }

  // process based on handle
  switch ($handle) {
    case 'packages':
      /* get package */
      $package = $user->get_package($id);
      if (!$package) {
        throw new Exception('Invalid package');
      }
      /* update user package */
      $user->update_user_package($package['package_id'], $package['name'], $package['price'], $package['verification_badge_enabled'], $user_id);
      /* set notification url */
      $notification_url = '/upgraded';
      break;
    case 'wallet':
      /* update user wallet balance */
      $db->query(sprintf("UPDATE users SET user_wallet_balance = user_wallet_balance + %s WHERE user_id = %s", secure($price), secure($user_id, 'int')));
      /* wallet transaction */
      $user->wallet_set_transaction($user_id, 'recharge', 0, $price, 'in');
      /* update session */
      $_SESSION['wallet_replenish_amount'] = $price;
      /* set notification url */
      $notification_url = '/wallet?wallet_replenish_succeed';
      break;
    case 'donate':
      /* funding donation */
      $user->funding_donation($id, $price);
      /* set notification url */
      $notification_url = '/posts/' . $id;
      break;
    case 'subscribe':
      /* get monetization plan */
      $monetization_plan = $user->get_monetization_plan($id, true);
      if (!$monetization_plan) {
        throw new Exception('Invalid monetization plan');
      }
      /* subscribe to node */
      $node_link = $user->subscribe($id, $user_id);
      /* set notification url */
      $notification_url = $node_link;
      break;
    case 'paid_post':
      /* get post */
      $post = $user->get_post($id, false, false, true);
      if (!$post) {
        throw new Exception('Invalid post');
      }
      /* unlock paid post */
      $post_link = $user->unlock_paid_post($id, $user_id);
      /* set notification url */
      $notification_url = $post_link;
      break;
    case 'movies':
      /* get movie */
      $movie = $user->get_movie($id);
      if (!$movie) {
        throw new Exception('Invalid movie');
      }
      /* movie payment */
      $movie_link = $user->movie_payment($id, $user_id);
      /* set notification url */
      $notification_url = $movie_link;
      break;
    case 'marketplace':
      /* get orders collection */
      $orders_collection = $user->get_orders_collection($id);
      /* check if order collection exists */
      if (!$orders_collection) {
        throw new Exception('Invalid orders collection');
      }
      /* mark orders collection as paid */
      $user->mark_orders_collection_as_paid($id);
      /* set notification url */
      $notification_url = '/marketplace/orders/';
      break;
    default:
      _error(404);
  }

  // log payment
  $user->log_payment($user_id, $price, 'mercadopago', $handle);

  // notify the user
  $user->post_notification(['to_user_id' => $user_id, 'system_notification' => true, 'action' => 'pending_payment_approved', 'node_url' => $notification_url]);
} catch (Exception $e) {
  // return error with 400 status code
  header("HTTP/1.1 400 Bad Request");
  header('Content-Type: application/json');
  return_json(['error' => true, 'message' => $e->getMessage()]);
}
