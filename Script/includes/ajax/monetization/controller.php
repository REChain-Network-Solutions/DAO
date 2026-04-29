<?php

/**
 * ajax -> monetization -> controller
 * 
 * @package Sngine
 * @author Zamblek
 */

// fetch bootstrap
require('../../../bootstrap.php');

// check AJAX Request
is_ajax();

// user access
user_access(true);

// check demo account
if ($user->_data['user_demo']) {
  modal("ERROR", __("Demo Restriction"), __("You can't do this with demo account"));
}

// check if monetization is enabled
if ($_GET['do'] != "get_plans" && !$user->_data['can_monetize_content']) {
  modal("ERROR", __("Error"), __("This feature has been disabled by the admin"));
}

try {

  // initialize the return array
  $return = [];

  switch ($_GET['do']) {
    case 'get_plans':

      // valid inputs
      if (!isset($_GET['node_id']) || !is_numeric($_GET['node_id'])) {
        _error(400);
      }
      if (!isset($_GET['node_type']) || !in_array($_GET['node_type'], ['profile', 'page', 'group'])) {
        _error(400);
      }
      $smarty->assign('node_id', $_GET['node_id']);
      $smarty->assign('node_type', $_GET['node_type']);

      // get monetization plans
      $smarty->assign('monetization_plans', $user->get_monetization_plans($_GET['node_id'], $_GET['node_type']));

      // return
      $return['template'] = $smarty->fetch("ajax.monetization.plans.tpl");
      $return['callback'] = "$('#modal').modal('show'); $('.modal-content:last').html(response.template); initialize_modal();";
      break;

    case 'add_plan':

      // valid inputs
      if (!isset($_GET['node_id']) || !is_numeric($_GET['node_id'])) {
        _error(400);
      }
      if (!isset($_GET['node_type']) || !in_array($_GET['node_type'], ['profile', 'page', 'group'])) {
        _error(400);
      }
      $smarty->assign('node_id', $_GET['node_id']);
      $smarty->assign('node_type', $_GET['node_type']);

      // return
      $return['template'] = $smarty->fetch("ajax.monetization.add_plan.tpl");
      $return['callback'] = "$('#modal').modal('show'); $('.modal-content:last').html(response.template); initialize_modal();";
      break;

    case 'edit_plan':

      // get monetization plan
      $monetization_plan = $user->get_monetization_plan($_GET['id']);
      if (!$monetization_plan) {
        _error(400);
      }
      $smarty->assign('monetization_plan', $monetization_plan);

      // return
      $return['template'] = $smarty->fetch("ajax.monetization.edit_plan.tpl");
      $return['callback'] = "$('#modal').modal('show'); $('.modal-content:last').html(response.template); initialize_modal();";
      break;

    case 'insert_plan':

      // insert monetization plan
      $user->insert_monetization_plan($_POST['node_id'], $_POST['node_type'], $_POST['title'], $_POST['price'], $_POST['period_num'], $_POST['period'], $_POST['custom_description'], $_POST['plan_order']);

      // return
      $return['callback'] = 'window.location.reload();';
      break;

    case 'update_plan':

      // update monetization plan
      $user->update_monetization_plan($_POST['plan_id'], $_POST['title'], $_POST['price'], $_POST['period_num'], $_POST['period'], $_POST['custom_description'], $_POST['plan_order']);

      // return
      $return['callback'] = 'window.location.reload();';
      break;

    case 'delete_plan':

      // delete monetization plan
      $user->delete_monetization_plan($_GET['id']);
      break;

    case 'add_coupon':

      // valid inputs
      if (!isset($_GET['node_id']) || !is_numeric($_GET['node_id'])) {
        _error(400);
      }
      if (!isset($_GET['node_type']) || !in_array($_GET['node_type'], ['profile', 'page', 'group'])) {
        _error(400);
      }
      $smarty->assign('node_id', $_GET['node_id']);
      $smarty->assign('node_type', $_GET['node_type']);

      // return
      $return['template'] = $smarty->fetch("ajax.monetization.add_coupon.tpl");
      $return['callback'] = "$('#modal').modal('show'); $('.modal-content:last').html(response.template); initialize_modal();";
      break;

    case 'insert_coupon':

      // insert monetization coupon
      $user->insert_monetization_coupon($_POST['node_id'], $_POST['node_type'], $_POST['discount_percent'], $_POST['is_onetime']);

      // return
      $return['callback'] = 'window.location.reload();';
      break;

    case 'coupon_users':

      // get users who used this coupon
      $smarty->assign('users', $user->who_used_coupon($_GET['coupon_id']));
      $smarty->assign('coupon_id', $_GET['coupon_id']);

      // return
      $return['template'] = $smarty->fetch("ajax.who_used_coupon.tpl");
      $return['callback'] = "$('#modal').modal('show'); $('.modal-content:last').html(response.template);";
      break;

    case 'delete_coupon':

      // delete monetization coupon
      $user->delete_monetization_coupon($_GET['id']);
      break;

    case 'share_coupon':

      // get monetization coupon
      $coupon = $user->get_monetization_coupon($_GET['coupon_id']);
      if (!$coupon) {
        _error(400);
      }
      /* assign variables */
      $smarty->assign('coupon', $coupon);
      /* return */
      $return['template'] = $smarty->fetch("ajax.monetization.share_coupon.tpl");
      $return['callback'] = "$('#modal').modal('show'); $('.modal-content:last').html(response.template); initialize_modal();";
      break;

    default:
      _error(400);
      break;
  }

  // return & exit
  return_json($return);
} catch (ValidationException $e) {
  return_json(['error' => true, 'message' => $e->getMessage()]);
} catch (Exception $e) {
  modal("ERROR", __("Error"), $e->getMessage());
}
