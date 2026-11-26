<?php

/**
 * ajax -> forums -> react
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

// valid inputs
if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
  _error(400);
}

try {

  // initialize the return array
  $return = [];

  switch ($_POST['do']) {
    case 'like':
      // like
      $return['likes'] = $user->like_forum_post($_POST['handle'], $_POST['id']);
      break;

    case 'unlike':
      // unlike
      $return['likes'] = $user->like_forum_post($_POST['handle'], $_POST['id'], false);
      break;

    default:
      _error(400);
      break;
  }

  // return & exit
  return_json($return);
} catch (Exception $e) {
  modal("MESSAGE", __("Error"), $e->getMessage());
}
