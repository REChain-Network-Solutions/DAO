<?php

/**
 * api
 * 
 * @package Delus
 * @author Dmitry Sorokin - @sorydima & @sorydev Handles. 
 */

// fetch bootstrap|bootloader
if ($_GET['do'] == "oauth") {
  require('bootloader.php');
} else {
  require('bootstrap.php');
}

try {

  // initialize the return array
  $return = [];

  switch ($_GET['do']) {
    case 'oauth':
      // user access
      user_access(false, false, false, $_GET['app_id']);

      // valid inputs
      if (!isset($_GET['app_id']) || is_empty($_GET['app_id'])) {
        _error(404);
      }

      // oauth app
      $user->oauth_app($_GET['app_id']);
      break;

    case 'authorize':
      // valid inputs
      if (!isset($_GET['app_id']) || is_empty($_GET['app_id'])) {
        return_json(['error' => true, 'message' => "Bad Request, invalid app_id"]);
      }
      if (!isset($_GET['app_secret']) || is_empty($_GET['app_secret'])) {
        return_json(['error' => true, 'message' => "Bad Request, invalid app_secret"]);
      }
      if (!isset($_GET['auth_key']) || is_empty($_GET['auth_key'])) {
        return_json(['error' => true, 'message' => "Bad Request, invalid auth_key"]);
      }

      // authorize app
      $access_token = $user->authorize_app($_GET['app_id'], $_GET['app_secret'], $_GET['auth_key']);
      return_json(['access_token' => $access_token]);
      break;

    case 'get_user_info':
      // valid inputs
      if (!isset($_GET['access_token']) || is_empty($_GET['access_token'])) {
        return_json(['error' => true, 'message' => "Bad Request, invalid access_token"]);
      }

      // access app
      $user_id = $user->access_app($_GET['access_token']);

      // get user
      $get_user = $db->query(sprintf("SELECT 
				user_id, 
				user_name, 
				user_email, 
				user_firstname, 
				user_lastname, 
				user_gender, 
				user_birthdate, 
				user_picture, 
				user_cover, 
				user_registered, 
				user_verified, 
				user_relationship, 
				user_biography,
				user_website
				FROM users WHERE user_id = %s", secure($user_id, 'int')));
      if ($get_user->num_rows > 0) {
        while ($_user = $get_user->fetch_assoc()) {
          $_user['profile_picture'] = get_picture($_user['user_picture'], $_user['user_gender']);
          $_user['profile_cover'] = $system['system_uploads'] . "/" . $_user['profile_cover'];
          $_user['user_gender'] = $user->get_gender($_user['user_gender']);
          $return['user_info'] = $_user;
        }
      }

      // return & exit
      return_json($return);
      break;

    default:
      return_json(['error' => true, 'message' => "Bad Request, invalid parameters"]);
      break;
  }
} catch (Exception $e) {
  if ($_GET['do'] == "oauth") {
    _error(__("Error"), $e->getMessage());
  } else {
    return_json(['error' => true, 'message' => $e->getMessage()]);
  }
}
