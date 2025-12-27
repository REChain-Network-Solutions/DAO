<?php

/**
 * ajax -> payments -> shift4
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich
 */

// fetch bootstrap
require('../../../bootstrap.php');

// check AJAX Request
is_ajax();

// user access
user_access(true, true);

// check if Shift4 enabled
if (!$system['shift4_enabled']) {
  modal("MESSAGE", __("Error"), __("This feature has been disabled by the admin"));
}

try {

  switch ($_POST['do']) {
    case 'token':

      switch ($_POST['handle']) {
        case 'packages':
          // valid inputs
          if (!isset($_POST['package_id']) || !is_numeric($_POST['package_id'])) {
            _error(400);
          }

          // get package
          $package = $user->get_package($_POST['package_id']);
          if (!$package) {
            _error(400);
          }
          /* check if user already subscribed to this package */
          if ($user->_data['user_subscribed'] && $user->_data['user_package'] == $package['package_id']) {
            modal("SUCCESS", __("Subscribed"), __("You already subscribed to this package, Please select different package"));
          }

          // get shift4 token
          $token = shift4($package['price']);
          break;

        case 'wallet':
          // valid inputs
          if (!isset($_POST['price']) || !is_numeric($_POST['price'])) {
            _error(400);
          }

          // get shift4 token
          $token = shift4($_POST['price']);
          break;

        case 'donate':
          // valid inputs
          if (!isset($_POST['post_id']) || !is_numeric($_POST['post_id'])) {
            _error(400);
          }

          // get post
          $post = $user->get_post($_POST['post_id']);
          if (!$post) {
            _error(400);
          }

          // get shift4 token
          $token = shift4($_POST['price']);
          break;

        case 'subscribe':
          // valid inputs
          if (!isset($_POST['plan_id']) || !is_numeric($_POST['plan_id'])) {
            _error(400);
          }

          // get plan
          $monetization_plan = $user->get_monetization_plan($_POST['plan_id'], true);
          if (!$monetization_plan) {
            _error(400);
          }
          /* check if user already subscribed to this node */
          if ($user->is_subscribed($monetization_plan['node_id'], $monetization_plan['node_type'])) {
            modal("SUCCESS", __("Subscribed"), __("You already subscribed to this") . " " . __($_POST['node_type']));
          }

          // get shift4 token
          $token = shift4($monetization_plan['price']);
          break;

        case 'paid_post':
          // valid inputs
          if (!isset($_POST['post_id']) || !is_numeric($_POST['post_id'])) {
            _error(400);
          }

          // get post
          $post = $user->get_post($_POST['post_id'], false, false, true);
          if (!$post) {
            throw new Exception(__("This post is not available"));
          }
          if (!$post['needs_payment']) {
            throw new Exception(__("This post doesn't need payment"));
          }

          // get shift4 token
          $token = shift4($post['post_price']);
          break;

        case 'movies':
          // valid inputs
          if (!isset($_POST['movie_id']) || !is_numeric($_POST['movie_id'])) {
            _error(400);
          }

          // get movie
          $movie = $user->get_movie($_POST['movie_id']);
          /* check if user already paid to this movie */
          if ($movie['can_watch']) {
            modal("SUCCESS", __("Paid"), __("You already paid to this movie"));
          }

          // get shift4 token
          $token = shift4($movie['price']);
          break;

        case 'marketplace':
          // valid inputs
          if (!isset($_POST['orders_collection_id'])) {
            _error(400);
          }

          // get orders collection
          $orders_collection = $user->get_orders_collection($_POST['orders_collection_id']);
          /* check if order collection exists */
          if (!$orders_collection) {
            _error(400);
          }
          /* check if user already paid to this order collection */
          if ($orders_collection['paid']) {
            modal("SUCCESS", __("Paid"), __("You already paid to this order"));
          }

          // get shift4 token
          $token = shift4($orders_collection['total']);
          break;

        default:
          _error(400);
          break;
      }

      // return & exit
      return_json(['token' => $token]);
      break;

    case 'verifiy':

      switch ($_POST['handle']) {
        case 'packages':
          // valid inputs
          if (!isset($_POST['shift4']['charge']['id'])) {
            _error(400);
          }
          if (!isset($_POST['package_id']) || !is_numeric($_POST['package_id'])) {
            _error(400);
          }

          // check package
          $package = $user->get_package($_POST['package_id']);
          if (!$package) {
            _error(400);
          }

          // check payment
          $payment = shift4_check($_POST['shift4']['charge']['id']);
          if ($payment) {
            /* update user package */
            $user->update_user_package($package);
            /* log payment */
            $user->log_payment($user->_data['user_id'], $package['price'], 'shift4', 'packages');
          }

          // return
          return_json(['callback' => 'window.location.href = "' . $system['system_url'] . '/upgraded";']);
          break;

        case 'wallet':
          // valid inputs
          if (!isset($_POST['shift4']['charge']['id'])) {
            _error(400);
          }
          if (!isset($_POST['price']) || !is_numeric($_POST['price'])) {
            _error(400);
          }

          // check payment
          $payment = shift4_check($_POST['shift4']['charge']['id']);
          if ($payment) {
            $_SESSION['wallet_replenish_amount'] = $_POST['price'];
            /* update user wallet balance */
            $db->query(sprintf("UPDATE users SET user_wallet_balance = user_wallet_balance + %s WHERE user_id = %s", secure($_SESSION['wallet_replenish_amount']), secure($user->_data['user_id'], 'int')));
            /* wallet transaction */
            $user->wallet_set_transaction($user->_data['user_id'], 'recharge', 0, $_SESSION['wallet_replenish_amount'], 'in');
            /* log payment */
            $user->log_payment($user->_data['user_id'], $_SESSION['wallet_replenish_amount'], 'shift4', 'wallet');
          }

          // return
          return_json(['callback' => 'window.location.href = "' . $system['system_url'] . '/wallet?wallet_replenish_succeed";']);
          break;

        case 'donate':
          // valid inputs
          if (!isset($_POST['shift4']['charge']['id'])) {
            _error(400);
          }
          if (!isset($_POST['post_id']) || !is_numeric($_POST['post_id'])) {
            _error(400);
          }
          if (!isset($_POST['price']) || !is_numeric($_POST['price'])) {
            _error(400);
          }

          // check payment
          $payment = shift4_check($_POST['shift4']['charge']['id']);
          if ($payment) {
            $_SESSION['donation_amount'] = $_POST['price'];
            /* funding donation */
            $user->funding_donation($_POST['post_id'], $_SESSION['donation_amount']);
            /* log payment */
            $user->log_payment($user->_data['user_id'], $_SESSION['donation_amount'], 'shift4', 'donate');
          }

          // return
          return_json(['callback' => 'window.location.href = "' . $system['system_url'] . '/posts/' . $_POST['post_id'] . '";']);
          break;

        case 'subscribe':
          // valid inputs
          if (!isset($_POST['shift4']['charge']['id'])) {
            _error(400);
          }
          if (!isset($_POST['plan_id']) || !is_numeric($_POST['plan_id'])) {
            _error(400);
          }

          // get monetization plan
          $monetization_plan = $user->get_monetization_plan($_POST['plan_id'], true);
          if (!$monetization_plan) {
            _error(400);
          }

          // check payment
          $payment = shift4_check($_POST['shift4']['charge']['id']);
          if ($payment) {
            /* subscribe to node */
            $node_link = $user->subscribe($_POST['plan_id']);
            /* log payment */
            $user->log_payment($user->_data['user_id'], $monetization_plan['price'], 'shift4', 'subscribe');
          }

          // return
          return_json(['callback' => 'window.location.href = "' . $system['system_url'] . $node_link . '";']);
          break;

        case 'paid_post':
          // valid inputs
          if (!isset($_POST['shift4']['charge']['id'])) {
            _error(400);
          }
          if (!isset($_POST['post_id']) || !is_numeric($_POST['post_id'])) {
            _error(400);
          }

          // get post
          $post = $user->get_post($_POST['post_id'], false, false, true);
          if (!$post) {
            _error(400);
          }

          // check payment
          $payment = shift4_check($_POST['shift4']['charge']['id']);
          if ($payment) {
            /* unlock paid post */
            $post_link = $user->unlock_paid_post($_POST['post_id']);
            /* log payment */
            $user->log_payment($user->_data['user_id'], $post['post_price'], 'shift4', 'paid_post');
          }

          // return
          return_json(['callback' => 'window.location.href = "' . $system['system_url'] . $post_link . '";']);
          break;

        case 'movies':
          // valid inputs
          if (!isset($_POST['shift4']['charge']['id'])) {
            _error(400);
          }
          if (!isset($_POST['movie_id']) || !is_numeric($_POST['movie_id'])) {
            _error(400);
          }

          // get movie
          $movie = $user->get_movie($_POST['movie_id']);
          if (!$movie) {
            _error(400);
          }

          // check payment
          $payment = shift4_check($_POST['shift4']['charge']['id']);
          if ($payment) {
            /* movie payment */
            $movie_link = $user->movie_payment($_POST['movie_id']);
            /* log payment */
            $user->log_payment($user->_data['user_id'], $movie['price'], 'shift4', 'movies');
          }

          // return
          return_json(['callback' => 'window.location.href = "' . $system['system_url'] . $movie_link . '";']);
          break;

        case 'marketplace':
          // valid inputs
          if (!isset($_POST['shift4']['charge']['id'])) {
            _error(400);
          }
          if (!isset($_POST['orders_collection_id'])) {
            _error(400);
          }

          // get orders collection
          $orders_collection = $user->get_orders_collection($_POST['orders_collection_id']);
          if (!$orders_collection) {
            _error(400);
          }

          // check payment
          $payment = shift4_check($_POST['shift4']['charge']['id']);
          if ($payment) {
            /* mark order collection as paid */
            $user->mark_orders_collection_as_paid($_POST['orders_collection_id']);
            /* log payment */
            $user->log_payment($user->_data['user_id'], $orders_collection['total'], 'shift4', 'marketplace');
          }

          // return
          return_json(['callback' => 'window.location.href = "' . $system['system_url'] . '/market/orders/";']);
          break;

        default:
          _error(400);
          break;
      }
      break;

    default:
      _error(400);
      break;
  }
} catch (Exception $e) {
  modal("ERROR", __("Error"), $e->getMessage());
}
