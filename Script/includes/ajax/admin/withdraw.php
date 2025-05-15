<?php

/**
 * ajax -> admin -> withdraw
 * 
 * @package Delus
 * @author Dmitry Sorokin - @sorydima & @sorydev Handles. 
 */

// fetch bootstrap
require('../../../bootstrap.php');

// check AJAX Request
is_ajax();

// check demo account
if ($user->_data['user_demo']) {
  modal("ERROR", __("Demo Restriction"), __("You can't do this with demo account"));
}

// valid inputs
if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
  _error(400);
}

// handle withdraw
try {

  switch ($_POST['type']) {
    case 'wallet':
      // check admin|moderator permission
      if (!$user->_is_admin && ($user->_is_moderator && !$system['mods_wallet_permission'])) {
        modal("MESSAGE", __("System Message"), __("You don't have the right permission to access this"));
      }

      // handle request
      /* get the request */
      $get_withdrawal_request = $db->query(sprintf("SELECT * FROM wallet_payments WHERE payment_id = %s", secure($_POST['id'], 'int')));
      if ($get_withdrawal_request->num_rows == 0) {
        _error(400);
      }
      $withdrawal_request = $get_withdrawal_request->fetch_assoc();
      switch ($_POST['handle']) {
        case 'approve':
          /* process automatic withdrawal */
          process_automatic_withdrawal($withdrawal_request['method'], $withdrawal_request['amount'], $withdrawal_request['method_value']);
          /* approve request */
          $db->query(sprintf("UPDATE wallet_payments SET status = '1' WHERE payment_id = %s", secure($_POST['id'], 'int')));
          /* send notification to request author */
          $user->post_notification(['to_user_id' => $withdrawal_request['user_id'], 'action' => 'wallet_withdrawal_approved']);
          break;

        case 'decline':
          /* decline request */
          $db->query(sprintf("UPDATE wallet_payments SET status = '-1' WHERE payment_id = %s", secure($_POST['id'], 'int')));
          /* update user balance */
          $db->query(sprintf("UPDATE users SET user_wallet_balance = user_wallet_balance + %s WHERE user_id = %s", secure($withdrawal_request['amount']), secure($withdrawal_request['user_id'], 'int')));
          /* send notification to request author */
          $user->post_notification(['to_user_id' => $withdrawal_request['user_id'], 'action' => 'wallet_withdrawal_declined']);
          break;

        default:
          _error(400);
          break;
      }
      break;

    case 'affiliates':
      // check admin|moderator permission
      if (!$user->_is_admin && ($user->_is_moderator && !$system['mods_affiliates_permission'])) {
        modal("MESSAGE", __("System Message"), __("You don't have the right permission to access this"));
      }

      // handle request
      /* get the request */
      $get_withdrawal_request = $db->query(sprintf("SELECT * FROM affiliates_payments WHERE payment_id = %s", secure($_POST['id'], 'int')));
      if ($get_withdrawal_request->num_rows == 0) {
        _error(400);
      }
      $withdrawal_request = $get_withdrawal_request->fetch_assoc();
      switch ($_POST['handle']) {
        case 'approve':
          /* process automatic withdrawal */
          process_automatic_withdrawal($withdrawal_request['method'], $withdrawal_request['amount'], $withdrawal_request['method_value']);
          /* approve request */
          $db->query(sprintf("UPDATE affiliates_payments SET status = '1' WHERE payment_id = %s", secure($_POST['id'], 'int')));
          /* send notification to request author */
          $user->post_notification(['to_user_id' => $withdrawal_request['user_id'], 'action' => 'affiliates_withdrawal_approved']);
          break;

        case 'decline':
          /* decline request */
          $db->query(sprintf("UPDATE affiliates_payments SET status = '-1' WHERE payment_id = %s", secure($_POST['id'], 'int')));
          /* update user balance */
          $db->query(sprintf("UPDATE users SET user_affiliate_balance = user_affiliate_balance + %s WHERE user_id = %s", secure($withdrawal_request['amount']), secure($withdrawal_request['user_id'], 'int')));
          /* send notification to request author */
          $user->post_notification(['to_user_id' => $withdrawal_request['user_id'], 'action' => 'affiliates_withdrawal_declined']);
          break;

        default:
          _error(400);
          break;
      }
      break;

    case 'points':
      // check admin|moderator permission
      if (!$user->_is_admin && ($user->_is_moderator && !$system['mods_points_permission'])) {
        modal("MESSAGE", __("System Message"), __("You don't have the right permission to access this"));
      }

      // handle request
      /* get the request */
      $get_withdrawal_request = $db->query(sprintf("SELECT points_payments.*, users.user_points FROM points_payments INNER JOIN users ON points_payments.user_id = users.user_id WHERE points_payments.payment_id = %s", secure($_POST['id'], 'int')));
      if ($get_withdrawal_request->num_rows == 0) {
        _error(400);
      }
      $withdrawal_request = $get_withdrawal_request->fetch_assoc();
      switch ($_POST['handle']) {
        case 'approve':
          /* process automatic withdrawal */
          process_automatic_withdrawal($withdrawal_request['method'], $withdrawal_request['amount'], $withdrawal_request['method_value']);
          /* approve request */
          $db->query(sprintf("UPDATE points_payments SET status = '1' WHERE payment_id = %s", secure($_POST['id'], 'int')));
          /* send notification to request author */
          $user->post_notification(['to_user_id' => $withdrawal_request['user_id'], 'action' => 'points_withdrawal_approved']);
          break;

        case 'decline':
          /* decline request */
          $db->query(sprintf("UPDATE points_payments SET status = '-1' WHERE payment_id = %s", secure($_POST['id'], 'int')));
          /* update user balance */
          $balance = $withdrawal_request['user_points'] + ($system['points_per_currency'] * $withdrawal_request['amount']);
          $db->query(sprintf("UPDATE users SET user_points = %s WHERE user_id = %s", secure($balance), secure($withdrawal_request['user_id'], 'int')));
          /* send notification to request author */
          $user->post_notification(['to_user_id' => $withdrawal_request['user_id'], 'action' => 'points_withdrawal_declined']);
          break;

        default:
          _error(400);
          break;
      }
      break;

    case 'market':
      // check admin|moderator permission
      if (!$user->_is_admin && ($user->_is_moderator && !$system['mods_marketplace_permission'])) {
        modal("MESSAGE", __("System Message"), __("You don't have the right permission to access this"));
      }

      // handle request
      /* get the request */
      $get_withdrawal_request = $db->query(sprintf("SELECT * FROM market_payments WHERE payment_id = %s", secure($_POST['id'], 'int')));
      if ($get_withdrawal_request->num_rows == 0) {
        _error(400);
      }
      $withdrawal_request = $get_withdrawal_request->fetch_assoc();
      switch ($_POST['handle']) {
        case 'approve':
          /* process automatic withdrawal */
          process_automatic_withdrawal($withdrawal_request['method'], $withdrawal_request['amount'], $withdrawal_request['method_value']);
          /* approve request */
          $db->query(sprintf("UPDATE market_payments SET status = '1' WHERE payment_id = %s", secure($_POST['id'], 'int')));
          /* send notification to request author */
          $user->post_notification(['to_user_id' => $withdrawal_request['user_id'], 'action' => 'market_withdrawal_approved']);
          break;

        case 'decline':
          /* decline request */
          $db->query(sprintf("UPDATE market_payments SET status = '-1' WHERE payment_id = %s", secure($_POST['id'], 'int')));
          /* update user balance */
          $db->query(sprintf("UPDATE users SET user_market_balance = user_market_balance + %s WHERE user_id = %s", secure($withdrawal_request['amount']), secure($withdrawal_request['user_id'], 'int')));
          /* send notification to request author */
          $user->post_notification(['to_user_id' => $withdrawal_request['user_id'], 'action' => 'market_withdrawal_declined']);
          break;

        default:
          _error(400);
          break;
      }
      break;

    case 'funding':
      // check admin|moderator permission
      if (!$user->_is_admin && ($user->_is_moderator && !$system['mods_funding_permission'])) {
        modal("MESSAGE", __("System Message"), __("You don't have the right permission to access this"));
      }

      // handle request
      /* get the request */
      $get_withdrawal_request = $db->query(sprintf("SELECT * FROM funding_payments WHERE payment_id = %s", secure($_POST['id'], 'int')));
      if ($get_withdrawal_request->num_rows == 0) {
        _error(400);
      }
      $withdrawal_request = $get_withdrawal_request->fetch_assoc();
      switch ($_POST['handle']) {
        case 'approve':
          /* process automatic withdrawal */
          process_automatic_withdrawal($withdrawal_request['method'], $withdrawal_request['amount'], $withdrawal_request['method_value']);
          /* approve request */
          $db->query(sprintf("UPDATE funding_payments SET status = '1' WHERE payment_id = %s", secure($_POST['id'], 'int')));
          /* send notification to request author */
          $user->post_notification(['to_user_id' => $withdrawal_request['user_id'], 'action' => 'funding_withdrawal_approved']);
          break;

        case 'decline':
          /* decline request */
          $db->query(sprintf("UPDATE funding_payments SET status = '-1' WHERE payment_id = %s", secure($_POST['id'], 'int')));
          /* update user balance */
          $db->query(sprintf("UPDATE users SET user_funding_balance = user_funding_balance + %s WHERE user_id = %s", secure($withdrawal_request['amount']), secure($withdrawal_request['user_id'], 'int')));
          /* send notification to request author */
          $user->post_notification(['to_user_id' => $withdrawal_request['user_id'], 'action' => 'funding_withdrawal_declined']);
          break;

        default:
          _error(400);
          break;
      }
      break;

    case 'monetization':
      // check admin|moderator permission
      if (!$user->_is_admin && ($user->_is_moderator && !$system['mods_monetization_permission'])) {
        modal("MESSAGE", __("System Message"), __("You don't have the right permission to access this"));
      }

      // handle request
      /* get the request */
      $get_withdrawal_request = $db->query(sprintf("SELECT * FROM monetization_payments WHERE payment_id = %s", secure($_POST['id'], 'int')));
      if ($get_withdrawal_request->num_rows == 0) {
        _error(400);
      }
      $withdrawal_request = $get_withdrawal_request->fetch_assoc();
      switch ($_POST['handle']) {
        case 'approve':
          /* process automatic withdrawal */
          process_automatic_withdrawal($withdrawal_request['method'], $withdrawal_request['amount'], $withdrawal_request['method_value']);
          /* approve request */
          $db->query(sprintf("UPDATE monetization_payments SET status = '1' WHERE payment_id = %s", secure($_POST['id'], 'int')));
          /* send notification to request author */
          $user->post_notification(['to_user_id' => $withdrawal_request['user_id'], 'action' => 'monetization_withdrawal_approved']);
          break;

        case 'decline':
          /* decline request */
          $db->query(sprintf("UPDATE monetization_payments SET status = '-1' WHERE payment_id = %s", secure($_POST['id'], 'int')));
          /* update user balance */
          $db->query(sprintf("UPDATE users SET user_monetization_balance = user_monetization_balance + %s WHERE user_id = %s", secure($withdrawal_request['amount']), secure($withdrawal_request['user_id'], 'int')));
          /* send notification to request author */
          $user->post_notification(['to_user_id' => $withdrawal_request['user_id'], 'action' => 'monetization_withdrawal_declined']);
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

  // return & exist
  return_json();
} catch (Exception $e) {
  modal("ERROR", __("Error"), $e->getMessage());
}
