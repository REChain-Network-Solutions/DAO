<?php

/**
 * ajax -> users -> push notifications
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
