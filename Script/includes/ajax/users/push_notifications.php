<?php

/**
 * ajax -> users -> push notifications
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

try {


  switch ($_POST['handle']) {
    case 'update':
      $user->update_session_onesignal_id($_POST['id']);
      break;

    case 'update_ios':
      $user->update_session_onesignal_id($_POST['id'], 'I');
      break;

    case 'update_android':
      $user->update_session_onesignal_id($_POST['id'], 'A');
      break;

    case 'delete':
      $user->delete_session_onesignal_id();
      break;

    default:
      _error(403);
      break;
  }

  // return
  return_json();
} catch (Exception $e) {
  modal("ERROR", __("Error"), $e->getMessage());
}
