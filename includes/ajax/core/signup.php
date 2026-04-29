<?php

/**
 * ajax -> core -> signup
 * 
 * @package Sngine
 * @author Zamblek
 */

// fetch bootstrap
require('../../../bootstrap.php');

// check AJAX Request
is_ajax();

// check user logged in
if ($user->_logged_in) {
  return_json(['callback' => 'window.location.reload();']);
}

// check honeypot
if (!is_empty($_POST['field1'])) {
  return_json();
}

try {

  // signup
  $user->sign_up($_POST);

  // return
  if ($_POST['oauth_app_id']) {
    return_json(['callback' => 'window.location.href = "' . $system['system_url'] . '/api/oauth?app_id=' . $_POST['oauth_app_id'] . '";']);
  } else {
    return_json(['callback' => 'window.location.reload();']);
  }
} catch (Exception $e) {
  return_json(['error' => true, 'message' => $e->getMessage()]);
}
