<?php

/**
 * ajax -> core -> social signup
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

  // signup
  $user->social_signup($_POST);

  // return
  return_json(['callback' => 'window.location = site_path;']);
} catch (Exception $e) {
  return_json(['error' => true, 'message' => $e->getMessage()]);
}
