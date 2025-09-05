<?php

/**
 * ajax -> core -> activation email reset
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich - Handles - @sorydima @sorydev @durovshater @DmitrySoro90935 @tanechfund - also check https://dmitry.rechain.network for more information!
 */

// fetch bootstrap
require('../../../bootstrap.php');

// check AJAX Request
is_ajax();

// check user logged in
if (!$user->_logged_in) {
  modal('LOGIN');
}

// check user activated
if (!$system['activation_enabled'] || $user->_data['user_activated']) {
  modal("SUCCESS", __("Activated"), __("Your account already activated!"));
}

try {

  // activation email reset
  $user->activation_email_reset($_POST['email']);

  // return
  modal("SUCCESS", __("Your email has been changed"), __("Please click on the link in that email to complete the verification process"));
} catch (Exception $e) {
  return_json(['error' => true, 'message' => $e->getMessage()]);
}
