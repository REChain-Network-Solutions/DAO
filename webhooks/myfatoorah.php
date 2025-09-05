<?php

/**
 * webhooks -> myfatoorah
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich - Handles - @sorydima @sorydev @durovshater @DmitrySoro90935 @tanechfund - also check https://dmitry.rechain.network for more information!
 */

// fetch bootloader
require('../bootloader.php');

// user access (simple)
if (!$user->_logged_in) {
  user_login();
}

try {
  switch ($_GET['handle']) {
    case 'packages':
      // valid inputs
      if (!isset($_GET['paymentId'])) {
        _error(404);
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
      $payment = myfatoorah_check($_GET['paymentId']);
      if ($payment) {
        /* update user package */
        $user->update_user_package($package['package_id'], $package['name'], $package['price'], $package['verification_badge_enabled']);
        /* log payment */
        $user->log_payment($user->_data['user_id'], $package['price'], 'myfatoorah', 'packages');
        /* redirect */
        redirect("/upgraded");
      }
      break;

    case 'wallet':
      // valid inputs
      if (!isset($_GET['paymentId'])) {
        _error(404);
      }


      // check payment
      $payment = myfatoorah_check($_GET['paymentId']);
      if ($payment && isset($_SESSION['wallet_replenish_amount'])) {
        /* update user wallet balance */
        $db->query(sprintf("UPDATE users SET user_wallet_balance = user_wallet_balance + %s WHERE user_id = %s", secure($_SESSION['wallet_replenish_amount']), secure($user->_data['user_id'], 'int')));
        /* wallet transaction */
        $user->wallet_set_transaction($user->_data['user_id'], 'recharge', 0, $_SESSION['wallet_replenish_amount'], 'in');
        /* log payment */
        $user->log_payment($user->_data['user_id'], $_SESSION['wallet_replenish_amount'], 'myfatoorah', 'wallet');
        /* redirect */
        redirect("/wallet?wallet_replenish_succeed");
      }
      break;

    case 'donate':
      // valid inputs
      if (!isset($_GET['paymentId'])) {
        _error(404);
      }
      if (!isset($_GET['post_id']) || !is_numeric($_GET['post_id'])) {
        _error(404);
      }

      // check payment
      $payment = myfatoorah_check($_GET['paymentId']);
      if ($payment) {
        /* funding donation */
        $user->funding_donation($_GET['post_id'], $_SESSION['donation_amount']);
        /* log payment */
        $user->log_payment($user->_data['user_id'], $_SESSION['donation_amount'], 'myfatoorah', 'donate');
        /* redirect */
        redirect("/posts/" . $_GET['post_id']);
      }
      break;

    case 'subscribe':
      // valid inputs
      if (!isset($_GET['paymentId'])) {
        _error(404);
      }
      if (!isset($_GET['plan_id']) || !is_numeric($_GET['plan_id'])) {
        _error(404);
      }

      // get monetization plan
      $monetization_plan = $user->get_monetization_plan($_GET['plan_id'], true);
      if (!$monetization_plan) {
        _error(404);
      }

      // check payment
      $payment = myfatoorah_check($_GET['paymentId']);
      if ($payment) {
        /* subscribe to node */
        $node_link = $user->subscribe($_GET['plan_id']);
        /* log payment */
        $user->log_payment($user->_data['user_id'], $monetization_plan['price'], 'myfatoorah', 'subscribe');
        /* redirect */
        redirect($node_link);
      }
      break;

    case 'paid_post':
      // valid inputs
      if (!isset($_GET['paymentId'])) {
        _error(404);
      }
      if (!isset($_GET['post_id']) || !is_numeric($_GET['post_id'])) {
        _error(404);
      }

      // get paid post
      $post = $user->get_paid_post($_GET['post_id'], false, false, true);
      if (!$post) {
        _error(404);
      }

      // check payment
      $payment = myfatoorah_check($_GET['paymentId']);
      if ($payment) {
        /* unlock paid post */
        $post_link = $user->unlock_paid_post($_GET['post_id']);
        /* log payment */
        $user->log_payment($user->_data['user_id'], $post['paid_price'], 'myfatoorah', 'paid_post');
        /* redirect */
        redirect($post_link);
      }
      break;

    case 'movies':
      // valid inputs
      if (!isset($_GET['paymentId'])) {
        _error(404);
      }
      if (!isset($_GET['movie_id']) || !is_numeric($_GET['movie_id'])) {
        _error(404);
      }

      // get movie
      $movie = $user->get_movie($_GET['movie_id']);
      if (!$movie) {
        _error(404);
      }

      // check payment
      $payment = myfatoorah_check($_GET['paymentId']);
      if ($payment) {
        /* movie payment */
        $movie_link = $user->movie_payment($_GET['movie_id']);
        /* log payment */
        $user->log_payment($user->_data['user_id'], $movie['price'], 'myfatoorah', 'movies');
        /* redirect */
        redirect($movie_link);
      }
      break;

    case 'marketplace':
      // valid inputs
      if (!isset($_GET['paymentId'])) {
        _error(404);
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
      $payment = myfatoorah_check($_GET['paymentId']);
      if ($payment) {
        /* mark orders collection as paid */
        $user->mark_orders_collection_as_paid($_GET['orders_collection_id']);
        /* log payment */
        $user->log_payment($user->_data['user_id'], $orders_collection['total'], 'myfatoorah', 'marketplace');
        /* redirect */
        redirect("/market/orders");
      }
      break;

    default:
      _error(404);
      break;
  }
  redirect();
} catch (Exception $e) {
  _error('System Message', $e->getMessage());
}
