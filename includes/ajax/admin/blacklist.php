<?php

/**
 * ajax -> admin -> blacklist
 * 
 * @package Delus
 * @author Dmitry
 */

// fetch bootstrap
require('../../../bootstrap.php');

// check AJAX Request
is_ajax();

// check admin|moderator permission
if (!$user->_is_admin) {
  modal("MESSAGE", __("System Message"), __("You don't have the right permission to access this"));
}

// check demo account
if ($user->_data['user_demo']) {
  modal("ERROR", __("Demo Restriction"), __("You can't do this with demo account"));
}

// handle blacklist
try {

  switch ($_GET['do']) {
    case 'add':
      /* insert */
      $db->query(sprintf("INSERT INTO blacklist (node_type, node_value, created_time) VALUES (%s, %s, %s)", secure($_POST['node_type']), secure($_POST['node_value']), secure($date)));
      /* return */
      return_json(['callback' => 'window.location = "' . $system['system_url'] . '/' . $control_panel['url'] . '/blacklist";']);
      break;

    default:
      _error(400);
      break;
  }
} catch (Exception $e) {
  return_json(['error' => true, 'message' => $e->getMessage()]);
}
