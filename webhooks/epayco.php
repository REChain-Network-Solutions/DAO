<?php

/**
 * webhooks -> epayco
 *
 * @package Delus
 * @author Dmitry
 */

// fetch bootstrap
require('../bootstrap.php');

// user access
user_access(true, true);

// check if epayco enabled
if (!$system['epayco_enabled']) {
  modal("MESSAGE", __("Error"), __("This feature has been disabled by the admin"));
}

try {

  switch ($_GET['handle']) {
    case 'packages':
      // valid inputs
      if (!isset($_GET['ref_payco'])) {
        _error(404);
      }
      if ($_GET['ref_payco'] == "undefined") {
        redirect('/packages');
      }
      if (!isset($_GET['package_id']) || !is_numeric($_GET['package_id'])) {
        _error(404);
      }

      // get package
      $package = $user->get_package($_GET['package_id']);
      if (!$package) {
        _error(404);
      }

      // check payment
      $payment = epayco_check($_GET['ref_payco'], $package['price']);
      if ($payment) {
        /* update user package */
        $user->update_user_package($package['package_id'], $package['name'], $package['price'], $package['verification_badge_enabled']);
        /* log payment */
        $user->log_payment($user->_data['user_id'], $package['price'], 'epayco', 'packages');
        /* redirect */
        redirect('/upgraded');
      }
      break;

    case 'wallet':
      // valid inputs
      if (!isset($_GET['ref_payco'])) {
        _error(404);
      }
      if ($_GET['ref_payco'] == "undefined") {
        redirect('/wallet');
      }
      if (!isset($_GET['price']) || !is_numeric($_GET['price'])) {
        _error(404);
      }

      // check payment
      $payment = epayco_check($_GET['ref_payco'], $_GET['price']);
      if ($payment) {
        /* update user wallet balance */
        $_SESSION['wallet_replenish_amount'] = $_GET['price'];
        $db->query(sprintf("UPDATE users SET user_wallet_balance = user_wallet_balance + %s WHERE user_id = %s", secure($_SESSION['wallet_replenish_amount']), secure($user->_data['user_id'], 'int')));
        /* wallet transaction */
        $user->wallet_set_transaction($user->_data['user_id'], 'recharge', 0, $_SESSION['wallet_replenish_amount'], 'in');
        /* log payment */
        $user->log_payment($user->_data['user_id'], $_SESSION['wallet_replenish_amount'], 'epayco', 'wallet');
        /* redirect*/
        redirect('/wallet?wallet_replenish_succeed');
      }
      break;

    case 'donate':
      // valid inputs
      if (!isset($_GET['ref_payco'])) {
        _error(404);
      }
      if ($_GET['ref_payco'] == "undefined") {
        redirect('/posts/' . $_GET['post_id']);
      }
      if (!isset($_GET['post_id']) || !is_numeric($_GET['post_id'])) {
        _error(404);
      }
      if (!isset($_GET['price']) || !is_numeric($_GET['price'])) {
        _error(404);
      }

      // check payment
      $payment = epayco_check($_GET['ref_payco'], $_GET['price']);
      if ($payment) {
        /* funding donation */
        $user->funding_donation($_GET['post_id'], $_GET['price']);
        /* log payment */
        $user->log_payment($user->_data['user_id'], $_GET['price'], 'epayco', 'donate');
        /* redirect */
        redirect('/posts/' . $_GET['post_id']);
      }
      break;

    case 'subscribe':
      // valid inputs
      if (!isset($_GET['ref_payco'])) {
        _error(404);
      }
      if ($_GET['ref_payco'] == "undefined") {
        redirect('/');
      }

      // get monetization plan
      $monetization_plan = $user->get_monetization_plan($_GET['plan_id'], true);
      if (!$monetization_plan) {
        _error(404);
      }

      // check payment
      $payment = epayco_check($_GET['ref_payco'], $monetization_plan['price']);
      if ($payment) {
        /* subscribe to node */
        $node_link = $user->subscribe($_GET['plan_id']);
        /* log payment */
        $user->log_payment($user->_data['user_id'], $monetization_plan['price'], 'epayco', 'subscribe');
        /* redirect */
        redirect($node_link);
      }
      break;

    case 'paid_post':
      // valid inputs
      if (!isset($_GET['ref_payco'])) {
        _error(404);
      }
      if ($_GET['ref_payco'] == "undefined") {
        redirect('/');
      }

      // get post
      $post = $user->get_post($_GET['post_id'], false, false, true);
      if (!$post) {
        _error(404);
      }

      // check payment
      $payment = epayco_check($_GET['ref_payco'], $post['post_price']);
      if ($payment) {
        /* unlock paid post */
        $post_link = $user->unlock_paid_post($_GET['post_id']);
        /* log payment */
        $user->log_payment($user->_data['user_id'], $post['post_price'], 'epayco', 'paid_post');
        /* redirect */
        redirect($post_link);
      }
      break;

    case 'movies':
      // valid inputs
      if (!isset($_GET['ref_payco'])) {
        _error(404);
      }
      if ($_GET['ref_payco'] == "undefined") {
        redirect('/movies');
      }

      // get movie
      $movie = $user->get_movie($_GET['movie_id']);
      if (!$movie) {
        _error(404);
      }

      // check payment
      $payment = epayco_check($_GET['ref_payco'], $movie['price']);
      if ($payment) {
        /* movie payment */
        $movie_link = $user->movie_payment($movie['movie_id']);
        /* log payment */
        $user->log_payment($user->_data['user_id'], $movie['price'], 'epayco', 'movies');
        /* redirect */
        redirect($movie_link);
      }
      break;

    case 'marketplace':
      // valid inputs
      if (!isset($_GET['ref_payco'])) {
        _error(404);
      }
      if ($_GET['ref_payco'] == "undefined") {
        redirect('/market');
      }
      if (!isset($_GET['orders_collection_id'])) {
        _error(404);
      }

      // get orders collection
      $orders_collection = $user->get_orders_collection($_GET['orders_collection_id']);
      if (!$orders_collection) {
        _error(404);
      }

      // check payment
      $payment = epayco_check($_GET['ref_payco'], $orders_collection['total']);
      if ($payment) {
        /* mark orders collection as paid */
        $user->mark_orders_collection_as_paid($_GET['orders_collection_id']);
        /* log payment */
        $user->log_payment($user->_data['user_id'], $orders_collection['total'], 'epayco', 'marketplace');
        /* redirect */
        redirect("/market/orders/");
      }
      break;

    default:
      _error(404);
      break;
  }
} catch (Exception $e) {
  modal("ERROR", __("Error"), $e->getMessage());
}