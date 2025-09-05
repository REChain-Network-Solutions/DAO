<?php

/**
 * ajax -> core -> activation email resend
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

try {

  // activation email resend
  $user->activation_email_resend();

  // return
  modal("SUCCESS", __("Another email has been sent"), __("Please click on the link in that email message to complete the verification process"));
} catch (Exception $e) {
  modal("ERROR", __("Error"), $e->getMessage());
}
