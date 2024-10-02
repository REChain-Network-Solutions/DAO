<?php

/**
 * ajax -> core -> forget password confirm
 * 
 * @package Delus
 * @author Dmitry
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

  // forget password confirm
  $user->forget_password_confirm($_POST['email'], $_POST['reset_key']);

  // return
  modal("#forget-password-reset", "{email: '" . $_POST['email'] . "', reset_key: '" . $_POST['reset_key'] . "'}");
} catch (Exception $e) {
  return_json(['error' => true, 'message' => $e->getMessage()]);
}
