<?php

/**
 * ajax -> payments -> Authorize.net [Pre-Payment Integration]
 * 
 * @package Sngine
 * @author Zamblek
 */

// fetch bootstrap
require('../../../bootstrap.php');

// check AJAX Request
is_ajax();

// user access
user_access(true, true);

// check if Authorize enabled
if (!$system['authorize_net_enabled']) {
  modal("MESSAGE", __("Error"), __("This feature has been disabled by the admin"));
}

try {

  switch ($_POST['handle']) {
    case 'packages':
      // valid inputs
      if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
        _error(400);
      }

      // get package
      $package = $user->get_package($_POST['id']);
      if (!$package) {
        _error(400);
      }
      /* check if user already subscribed to this package */
      if ($user->_data['user_subscribed'] && $user->_data['user_package'] == $package['package_id']) {
        modal("SUCCESS", __("Subscribed"), __("You already subscribed to this package, Please select different package"));
      }

      // process
      $payment = authorize_net_check($package['price']);
      if ($payment) {
        /* update user package */
        $user->update_user_package($package);
        /* log payment */
        $user->log_payment($user->_data['user_id'], $package['price'], 'authorize', 'packages');
      } else {
        throw new Exception(__("Payment Declined: Please verify your information and try again, or try another payment method"));
      }

      // return
      return_json(['callback' => 'window.location.href = "' . $system['system_url'] . '/upgraded";']);
      break;

    case 'wallet':
      // valid inputs
      if (!isset($_POST['price']) || !is_numeric($_POST['price'])) {
        _error(400);
      }

      // process
      $payment = authorize_net_check($_POST['price']);
      if ($payment) {
        /* update user wallet balance */
        $_SESSION['wallet_replenish_amount'] = $_POST['price'];
        $db->query(sprintf("UPDATE users SET user_wallet_balance = user_wallet_balance + %s WHERE user_id = %s", secure($_SESSION['wallet_replenish_amount']), secure($user->_data['user_id'], 'int'))) or _error("SQL_ERROR_THROWEN");
        /* wallet transaction */
        $user->wallet_set_transaction($user->_data['user_id'], 'recharge', 0, $_SESSION['wallet_replenish_amount'], 'in');
        /* log payment */
        $user->log_payment($user->_data['user_id'], $_SESSION['wallet_replenish_amount'], 'authorize', 'wallet');
      } else {
        throw new Exception(__("Payment Declined: Please verify your information and try again, or try another payment method"));
      }

      // return
      return_json(['callback' => 'window.location.href = "' . $system['system_url'] . '/wallet?wallet_replenish_succeed";']);
      break;

    case 'donate':
      // valid inputs
      if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
        _error(400);
      }
      if (!isset($_POST['price']) || !is_numeric($_POST['price'])) {
        _error(400);
      }

      // get post
      $post = $user->get_post($_POST['id']);
      if (!$post) {
        _error(400);
      }

      // process
      $payment = authorize_net_check($_POST['price']);
      if ($payment) {
        /* funding donation */
        $user->funding_donation($_POST['id'], $_POST['price']);
        /* log payment */
        $user->log_payment($user->_data['user_id'], $_POST['price'], 'authorize', 'donate');
      } else {
        throw new Exception(__("Payment Declined: Please verify your information and try again, or try another payment method"));
      }

      // return
      return_json(['callback' => 'window.location.href = "' . $system['system_url'] . '/posts/' . $_POST['id'] . '";']);
      break;

    case 'subscribe':
      // valid inputs
      if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
        _error(400);
      }

      // get monetization plan
      $monetization_plan = $user->get_monetization_plan($_POST['id'], true);
      if (!$monetization_plan) {
        _error(400);
      }
      /* check if user already subscribed to this node */
      if ($user->is_subscribed($monetization_plan['node_id'], $monetization_plan['node_type'])) {
        modal("SUCCESS", __("Subscribed"), __("You already subscribed to this") . " " . __($monetization_plan['node_type']));
      }

      // check if discount is enabled
      if ($monetization_plan['discounted_price']) {
        $monetization_plan['price'] = $monetization_plan['discounted_price'];
      }
      // check if promo code is valid
      if ($_POST['promo_code']) {
        $coupon = $user->check_monetization_coupon($_POST['promo_code']);
        if ($coupon) {
          $monetization_plan['price'] = $monetization_plan['price'] * (1 - $coupon['discount_percent'] / 100);
        }
      }

      // process
      $payment = authorize_net_check($monetization_plan['price']);
      if ($payment) {
        /* subscribe to node */
        $node_link = $user->subscribe($_POST['id']);
        /* log payment */
        $user->log_payment($user->_data['user_id'], $monetization_plan['price'], 'authorize', 'subscribe');
        /* update coupon usage */
        $user->update_monetization_coupon($_POST['promo_code'], $user->_data['user_id']);
      } else {
        throw new Exception(__("Payment Declined: Please verify your information and try again, or try another payment method"));
      }

      // return
      return_json(['callback' => 'window.location.href = "' . $system['system_url'] . $node_link . '";']);
      break;

    case 'paid_post':
      // valid inputs
      if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
        _error(400);
      }

      // get post
      $post = $user->get_post($_POST['id'], false, false, true);
      if (!$post) {
        _error(400);
      }
      if (!$post['needs_payment']) {
        throw new Exception(__("This post doesn't need payment"));
      }

      // check if discount is enabled
      if ($post['post_price_discounted']) {
        $post['post_price'] = $post['post_price_discounted'];
      }
      // check if promo code is valid
      if ($_POST['promo_code']) {
        $coupon = $user->check_monetization_coupon($_POST['promo_code']);
        if ($coupon) {
          $post['post_price'] = $post['post_price'] * (1 - $coupon['discount_percent'] / 100);
        }
      }

      // process
      $payment = authorize_net_check($post['post_price']);
      if ($payment) {
        /* unlock paid post */
        $post_link = $user->unlock_paid_post($_POST['id']);
        /* log payment */
        $user->log_payment($user->_data['user_id'], $post['post_price'], 'authorize', 'paid_post');
        /* update coupon usage */
        $user->update_monetization_coupon($_POST['promo_code'], $user->_data['user_id']);
      } else {
        throw new Exception(__("Payment Declined: Please verify your information and try again, or try another payment method"));
      }

      // return
      return_json(['callback' => 'window.location.href = "' . $system['system_url'] . $node_link . '";']);
      break;

    case 'movies':
      // valid inputs
      if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
        _error(400);
      }

      // get movie
      $movie = $user->get_movie($_POST['id']);
      if (!$movie) {
        _error(400);
      }
      /* check if user already paid to this movie */
      if ($movie['can_watch']) {
        modal("SUCCESS", __("Paid"), __("You already paid to this movie"));
      }

      // process
      $payment = authorize_net_check($movie['price']);
      if ($payment) {
        /* movie payment */
        $movie_link = $user->movie_payment($movie['id']);
        /* log payment */
        $user->log_payment($user->_data['user_id'], $movie['price'], 'authorize', 'movies');
      } else {
        throw new Exception(__("Payment Declined: Please verify your information and try again, or try another payment method"));
      }

      // return
      return_json(['callback' => 'window.location.href = "' . $system['system_url'] . $movie_link . '";']);
      break;

    case 'marketplace':
      // valid inputs
      if (!isset($_POST['id'])) {
        _error(400);
      }

      // get orders collection
      $orders_collection = $user->get_orders_collection($_POST['id']);
      if (!$orders_collection) {
        _error(400);
      }
      /* check if user already paid to this order collection */
      if ($orders_collection['paid']) {
        modal("SUCCESS", __("Paid"), __("You already paid to this order"));
      }

      // process
      $payment = authorize_net_check($orders_collection['total']);
      if ($payment) {
        /* mark order collection as paid */
        $user->mark_orders_collection_as_paid($_POST['id']);
        /* log payment */
        $user->log_payment($user->_data['user_id'], $orders_collection['total'], 'authorize', 'marketplace');
      } else {
        throw new Exception(__("Payment Declined: Please verify your information and try again, or try another payment method"));
      }

      // return
      return_json(['callback' => 'window.location.href = "' . $system['system_url'] . '/market/orders/";']);
      break;

    default:
      _error(400);
      break;
  }
} catch (Exception $e) {
  return_json(['error' => true, 'message' => $e->getMessage()]);
}
