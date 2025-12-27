<?php

/**
 * ajax -> core -> activation email confirm
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich
 */

// fetch bootstrap
require('../../../bootstrap.php');

// check AJAX Request
is_ajax();

// check user logged in
if (!$user->_logged_in) {
  modal('LOGIN');
}

try {

  // activation email
  $user->activation_email($_POST['code']);

  // return
  return_json(['callback' => 'window.location.reload();']);
} catch (Exception $e) {
  return_json(['error' => true, 'message' => $e->getMessage()]);
}
