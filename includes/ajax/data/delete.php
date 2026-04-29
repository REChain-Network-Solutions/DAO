<?php

/**
 * ajax -> data -> delete
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
  if ($_POST['handle'] == 'tinymce') {
    return_json(["error" => __("You can't do this with demo account")]);
  } else {
    modal("ERROR", __("Error"), __("You can't do this with demo account"));
  }
}

try {

  // initialize the return array
  $return = [];

  // delete uploaded file
  delete_uploads_file($_POST['src'], false);

  // return & exit
  return_json($return);

  // return
} catch (Exception $e) {
  modal("ERROR", __("Error"), $e->getMessage());
}
