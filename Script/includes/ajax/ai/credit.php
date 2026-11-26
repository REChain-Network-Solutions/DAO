<?php

/**
 * ajax -> ai -> credit
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

try {

  // initialize the return array
  $return = [];

  // validate handle
  if (!in_array($_POST['handle'], ['post', 'blog', 'image'])) {
    error(400);
  }

  // add credits
  if (!method_exists($user, 'wallet_ai_credits_payment')) {
    throw new Exception(__("You can't use this feature"));
  }
  $user->wallet_ai_credits_payment($_POST['amount']);

  // return & exit
  $return['template'] = $smarty->fetch("ajax.ai." . $_POST['handle'] . ".tpl");
  $return['callback'] = "modal_content(response.template);";
  return_json($return);
} catch (Exception $e) {
  return_json(['error' => true, 'message' => $e->getMessage()]);
}
