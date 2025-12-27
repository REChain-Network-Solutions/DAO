<?php

/**
 * ajax -> chat -> call
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich
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

// valid inputs
if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
  _error(400);
}

try {

  // initialize the return array
  $return = [];

  switch ($_POST['do']) {
    case 'create_call':
      // create call
      $call = $user->create_call($_POST['type'], $_POST['id']);

      // return
      $return['call'] = $call;
      break;

    case 'check_calling_response':
      // check call response
      $call = $user->check_calling_response($_POST['id']);

      // return
      $return['call'] = $call;
      break;

    case 'cancel_call':
    case 'decline_call':
    case 'end_call':
      // (cancel|decline|end) call
      $call = $user->decline_call($_POST['id']);

      // return
      $return['call'] = $call;
      break;

    case 'answer_call':
      // answer call
      $call = $user->answer_call($_POST['id']);

      // return
      $return['call'] = $call;
      break;

    case 'update_call':
      // update call
      $user->update_call($_POST['id']);
      break;

    default:
      _error(400);
      break;
  }

  // return & exit
  return_json($return);
} catch (Exception $e) {
  modal("ERROR", __("Error"), $e->getMessage());
}
