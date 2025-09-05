<?php

/**
 * webhooks -> paypal
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
  if ($_GET['status'] == 'success') {
    switch ($_GET['handle']) {
      case 'packages':
        // valid inputs
        if (isset($_GET['subscription_id'])) {
          $is_subscription = true;
        } elseif (isset($_GET['paymentId']) && isset($_GET['PayerID'])) {
          $is_subscription = false;
        } else {
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
        $payment = ($is_subscription) ? paypal_subscription_check($_GET['subscription_id']) : paypal_payment_check($_GET['paymentId'], $_GET['PayerID']);
        if ($payment) {
          /* update user package */
          $user->update_user_package($package['package_id'], $package['name'], $package['price'], $package['verification_badge_enabled']);
          /* check if the payment is recurring (note: webhook will log the payment) */
          if ($package['paypal_billing_plan']) {
            /* insert the recurring payments */
            $user->insert_recurring_payments('paypal', 'packages', $_GET['package_id'], $_GET['subscription_id']);
          } else {
            /* log payment */
            $user->log_payment($user->_data['user_id'], $package['price'], 'paypal', 'packages');
          }
          /* redirect */
          redirect("/upgraded");
        }
        break;

      case 'wallet':
        // valid inputs
        if (!isset($_GET['paymentId']) || !isset($_GET['PayerID'])) {
          _error(404);
        }

        // check payment
        $payment = paypal_payment_check($_GET['paymentId'], $_GET['PayerID']);
        if ($payment && isset($_SESSION['wallet_replenish_amount'])) {
          /* update user wallet balance */
          $db->query(sprintf("UPDATE users SET user_wallet_balance = user_wallet_balance + %s WHERE user_id = %s", secure($_SESSION['wallet_replenish_amount']), secure($user->_data['user_id'], 'int')));
          /* wallet transaction */
          $user->wallet_set_transaction($user->_data['user_id'], 'recharge', 0, $_SESSION['wallet_replenish_amount'], 'in');
          /* log payment */
          $user->log_payment($user->_data['user_id'], $_SESSION['wallet_replenish_amount'], 'paypal', 'wallet');
          /* redirect */
          redirect("/wallet?wallet_replenish_succeed");
        }
        break;

      case 'donate':
        // valid inputs
        if (!isset($_GET['paymentId']) || !isset($_GET['PayerID'])) {
          _error(404);
        }
        if (!isset($_GET['post_id']) || !is_numeric($_GET['post_id'])) {
          _error(404);
        }

        // check payment
        $payment = paypal_payment_check($_GET['paymentId'], $_GET['PayerID']);
        if ($payment) {
          /* funding donation */
          $user->funding_donation($_GET['post_id'], $_SESSION['donation_amount']);
          /* log payment */
          $user->log_payment($user->_data['user_id'], $_SESSION['donation_amount'], 'paypal', 'donate');
          /* redirect */
          redirect("/posts/" . $_GET['post_id']);
        }
        break;

      case 'subscribe':
        // valid inputs
        if (isset($_GET['subscription_id'])) {
          $is_subscription = true;
        } elseif (isset($_GET['paymentId']) && isset($_GET['PayerID'])) {
          $is_subscription = false;
        } else {
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
        $payment = ($is_subscription) ? paypal_subscription_check($_GET['subscription_id']) : paypal_payment_check($_GET['paymentId'], $_GET['PayerID']);
        if ($payment) {
          /* subscribe to node */
          $node_link = $user->subscribe($_GET['plan_id']);
          /* check if the payment is recurring */
          if ($monetization_plan['paypal_billing_plan']) {
            /* insert the recurring payments (note: webhook will log the payment) */
            $user->insert_recurring_payments('paypal', 'subscribe', $_GET['plan_id'], $_GET['subscription_id']);
          } else {
            /* log payment */
            $user->log_payment($user->_data['user_id'], $monetization_plan['price'], 'paypal', 'subscribe');
          }
          /* redirect */
          redirect($node_link);
        }
        break;

      case 'paid_post':
        // valid inputs
        if (!isset($_GET['paymentId']) || !isset($_GET['PayerID'])) {
          _error(404);
        }
        if (!isset($_GET['post_id']) || !is_numeric($_GET['post_id'])) {
          _error(404);
        }

        // get post
        $post = $user->get_post($_GET['post_id'], false, false, true);
        if (!$post) {
          _error(404);
        }

        // check payment
        $payment = paypal_payment_check($_GET['paymentId'], $_GET['PayerID']);
        if ($payment) {
          /* unlock paid post */
          $post_link = $user->unlock_paid_post($_GET['post_id']);
          /* log payment */
          $user->log_payment($user->_data['user_id'], $post['post_price'], 'paypal', 'paid_post');
          /* redirect */
          redirect($post_link);
        }
        break;

      case 'movies':
        // valid inputs
        if (!isset($_GET['paymentId']) || !isset($_GET['PayerID'])) {
          _error(404);
        }
        if (!isset($_GET['movie_id']) || !is_numeric($_GET['movie_id'])) {
          _error(404);
        }

        // get movie
        $movie = $user->get_movie($_GET['movie_id']);
        /* check if user already paid to this movie */
        if (!$movie) {
          _error(404);
        }

        // check payment
        $payment = paypal_payment_check($_GET['paymentId'], $_GET['PayerID']);
        if ($payment) {
          /* movie payment */
          $movie_link = $user->movie_payment($_GET['movie_id']);
          /* log payment */
          $user->log_payment($user->_data['user_id'], $movie['price'], 'paypal', 'movies');
          /* redirect */
          redirect($movie_link);
        }
        break;

      case 'marketplace':
        // valid inputs
        if (!isset($_GET['paymentId']) || !isset($_GET['PayerID'])) {
          _error(404);
        }
        if (!isset($_GET['orders_collection_id'])) {
          _error(404);
        }

        // get orders collection
        $orders_collection = $user->get_orders_collection($_GET['orders_collection_id']);
        /* check if order collection exists */
        if (!$orders_collection) {
          _error(404);
        }

        // get payment
        $payment = paypal_payment_check($_GET['paymentId'], $_GET['PayerID']);
        if ($payment) {
          /* mark orders collection as paid */
          $user->mark_orders_collection_as_paid($_GET['orders_collection_id']);
          /* log payment */
          $user->log_payment($user->_data['user_id'], $orders_collection['total'], 'paypal', 'marketplace');
          /* redirect */
          redirect("/market/orders");
        }
        break;

      default:
        _error(404);
        break;
    }
  }
  redirect();
} catch (Exception $e) {
  _error('System Message', $e->getMessage());
}
