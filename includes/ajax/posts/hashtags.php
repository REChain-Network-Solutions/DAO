<?php

/**
 * ajax -> data -> hashtags
 * 
 * @package Sngine
 * @author Zamblek
 */

// fetch bootstrap
require('../../../bootstrap.php');

// check AJAX Request
is_ajax();

// check user logged in
if (!$user->_logged_in) {
  modal('LOGIN');
}

// valid inputs
if (!isset($_GET['term'])) {
  _error(400);
}

try {

  // get hashtags
  $hashtags = $user->get_hashtags($_GET['term']);

  // return & exit
  return_json($hashtags);
} catch (Exception $e) {
  modal("ERROR", __("Error"), $e->getMessage());
}
