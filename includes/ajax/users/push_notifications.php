<?php

/**
 * ajax -> users -> push notifications
 * 
 * @package Delus
 * @author Dmitry
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
      $db->query(sprintf("UPDATE users SET onesignal_user_id = %s WHERE user_id = %s", secure($_POST['id']), secure($user->_data['user_id'], 'int')));
      break;

    case 'update_android':
      $db->query(sprintf("UPDATE users SET onesignal_android_user_id = %s WHERE user_id = %s", secure($_POST['id']), secure($user->_data['user_id'], 'int')));
      break;

    case 'update_ios':
      $db->query(sprintf("UPDATE users SET onesignal_ios_user_id = %s WHERE user_id = %s", secure($_POST['id']), secure($user->_data['user_id'], 'int')));
      break;

    case 'delete':
      $db->query(sprintf("UPDATE users SET onesignal_user_id = '' WHERE user_id = %s", secure($user->_data['user_id'], 'int')));
      break;

    case 'delete_android':
      $db->query(sprintf("UPDATE users SET onesignal_android_user_id = '' WHERE user_id = %s", secure($user->_data['user_id'], 'int')));
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
