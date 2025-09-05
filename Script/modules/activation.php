<?php

/**
 * modules -> activation
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich - Handles - @sorydima @sorydev @durovshater @DmitrySoro90935 @tanechfund - also check https://dmitry.rechain.network for more information!
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
