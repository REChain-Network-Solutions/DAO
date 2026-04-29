<?php

/**
 * ajax -> core -> social signup
 * 
 * @package Sngine
 * @author Zamblek
 */

// fetch bootstrap
require('../../../bootstrap.php');

// check AJAX Request
is_ajax();

// check user logged in
if ($user->_logged_in) {
  return_json(['callback' => 'window.location.reload();']);
}

try {

  // signup
  $user->social_signup($_POST);

  // return
  return_json(['callback' => 'window.location = site_path;']);
} catch (Exception $e) {
  return_json(['error' => true, 'message' => $e->getMessage()]);
}
