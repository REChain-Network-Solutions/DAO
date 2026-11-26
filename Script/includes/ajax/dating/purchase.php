<?php

/**
 * ajax -> dating -> purchase
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

// dating enabled
if (!$user->_data['can_use_dating']) {
  modal("MESSAGE", __("Error"), __("This feature has been disabled by the admin"));
}

// check demo account
if ($user->_data['user_demo']) {
  modal("ERROR", __("Demo Restriction"), __("You can't do this with demo account"));
}

try {

  // initialize the return array
  $return = [];

  switch ($_GET['do']) {
    case 'store':
      /* assign variables */
      $smarty->assign('dating_balance', $user->get_dating_balance());
      $smarty->assign('dating_paid', $user->dating_paid_enabled());
      $smarty->assign('dating_upgrade', $system['packages_enabled'] && !$user->_data['user_subscribed']);
      /* return */
      $return['template'] = $smarty->fetch("ajax.dating.store.tpl");
      $return['callback'] = "modal_content(response.template, true);";
      break;

    case 'super_likes':
      // buy
      $user->dating_buy_super_likes();

      // return
      $return['callback'] = 'window.location.reload();';
      break;

    case 'boost':
      // boost
      $user->dating_boost();

      // return
      $return['callback'] = 'window.location.reload();';
      break;

    default:
      _error(400);
      break;
  }

  // return & exit
  return_json($return);
} catch (ValidationException $e) {
  modal("ERROR", __("Error"), $e->getMessage());
} catch (Exception $e) {
  modal("ERROR", __("Error"), $e->getMessage());
}
