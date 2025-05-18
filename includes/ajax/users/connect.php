<?php

/**
 * ajax -> users -> connect
 * 
 * @package delus
 * @author Dmitry Olegovich Sorokin - @sorydima , @sorydev , @durovshater Handles.
 */

// fetch bootstrap
require('../../../bootstrap.php');

// check AJAX Request
is_ajax();

// user access
user_access(true, true, true);

// check demo account
if ($user->_data['user_demo']) {
  modal("ERROR", __("Demo Restriction"), __("You can't do this with demo account"));
}

try {

  // connect user
  $_POST['uid'] = ($_POST['uid'] == '0') ? null : $_POST['uid'];
  $user->connect($_POST['do'], $_POST['id'], $_POST['uid']);

  // return & exit
  return_json();
} catch (Exception $e) {
  modal("ERROR", __("Error"), $e->getMessage());
}
