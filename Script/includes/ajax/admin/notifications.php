<?php

/**
 * ajax -> admin -> notifications
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich - Handles - @sorydima @sorydev @durovshater @DmitrySoro90935 @tanechfund - also check https://dmitry.rechain.network for more information!
 */

// fetch bootstrap
require('../../../bootstrap.php');

// check AJAX Request
is_ajax();

// check admin|moderator permission
if (!$user->_is_admin && ($user->_is_moderator && !$system['mods_reach_permission'])) {
  modal("MESSAGE", __("System Message"), __("You don't have the right permission to access this"));
}

// check demo account
if ($user->_data['user_demo']) {
  modal("ERROR", __("Demo Restriction"), __("You can't do this with demo account"));
}

// handle notifications
try {

  /* valid inputs */
  if (is_empty($_POST['url'])) {
    throw new Exception(__("You must enter the notification url"));
  }
  if (is_empty($_POST['message'])) {
    throw new Exception(__("You must enter the notification message"));
  }

  // [BACKGROUND PROCESS]
  /* return async */
  return_json_async(['success' => true, 'message' => __("Your request has been sent successfully and will be processed in the background")]);
  /* send notification */
  $user->post_mass_notification($_POST['url'], $_POST['message']);

  /* return */
  return_json(['success' => true, 'message' => __("Notification has been sent successfully")]);
} catch (Exception $e) {
  return_json(['error' => true, 'message' => $e->getMessage()]);
}
