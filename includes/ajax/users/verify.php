<?php

/**
 * ajax -> users -> verify
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich - Handles - @sorydima @sorydev @durovshater @DmitrySoro90935 @tanechfund - also check https://dmitry.rechain.network for more information!
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

  switch ($_GET['node']) {
    case 'user':
      // send verification request
      $user->send_verification_request($user->_data['user_id'], 'user', $_POST);
      break;

    case 'page':
      // send verification request
      $user->send_verification_request($_GET['node_id'], 'page', $_POST);
      break;

    default:
      _error(400);
      break;
  }

  // return & exit
  return_json(['callback' => 'window.location.reload();']);
} catch (Exception $e) {
  return_json(['error' => true, 'message' => $e->getMessage()]);
}
