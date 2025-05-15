<?php

/**
 * modules -> activation
 * 
 * @package Delus
 * @author Dmitry Sorokin - @sorydima & @sorydev Handles. 
 */

// fetch bootstrap
require('../bootstrap.php');

// user access (simple)
if (!$user->_logged_in) {
  user_login();
}

try {

  // activation email
  $user->activation_email($_GET['code']);
  redirect();
} catch (Exception $e) {
  _error(__("Error"), $e->getMessage());
}
