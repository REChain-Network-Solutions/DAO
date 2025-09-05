<?php

/**
 * ajax -> data -> reset
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

// valid inputs
if (!isset($_POST['reset']) || !in_array($_POST['reset'], ['friend_requests', 'messages', 'notifications'])) {
  _error(400);
}

try {

  // reset real-time counters
  $user->reset_realtime_counters($_POST['reset']);

  // return & exist
  return_json();
} catch (Exception $e) {
  modal("ERROR", __("Error"), $e->getMessage());
}
