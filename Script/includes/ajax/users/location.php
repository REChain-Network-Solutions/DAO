<?php

/**
 * ajax -> users -> location
 * 
 * @package Sngine
 * @author Zamblek
 */

// this request only reads the session
define('SESSION_READ_ONLY', true);

// fetch bootstrap
require('../../../bootstrap.php');

// check AJAX Request
is_ajax();

// user access
user_access(true);

try {

  // update user location
  $user->update_location($_POST['latitude'] ?? null, $_POST['longitude'] ?? null);

  // return
  return_json();
} catch (Exception $e) {
  modal("ERROR", __("Error"), $e->getMessage());
}
