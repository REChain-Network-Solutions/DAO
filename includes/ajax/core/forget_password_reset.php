<?php

/**
 * ajax -> core -> forget password reset
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich - Handles - @sorydima @sorydev @durovshater @DmitrySoro90935 @tanechfund - also check https://dmitry.rechain.network for more information!
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

  // forget password reset
  $user->forget_password_reset($_POST['email'], $_POST['reset_key'], $_POST['password'], $_POST['confirm']);

  // return
  modal("SUCCESS", __("Done"), __("Your password has been changed you can login now"));
} catch (Exception $e) {
  return_json(['error' => true, 'message' => $e->getMessage()]);
}
