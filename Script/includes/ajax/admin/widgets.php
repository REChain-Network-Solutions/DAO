<?php

/**
 * ajax -> admin -> widgets
 * 
 * @package Delus
 * @author Dmitry Sorokin - @sorydima & @sorydev Handles. 
 */

// fetch bootstrap
require('../../../bootstrap.php');

// check AJAX Request
is_ajax();

// check admin|moderator permission
if (!$user->_is_admin && ($user->_is_moderator && !$system['mods_customization_permission'])) {
  modal("MESSAGE", __("System Message"), __("You don't have the right permission to access this"));
}

// check demo account
if ($user->_data['user_demo']) {
  modal("ERROR", __("Demo Restriction"), __("You can't do this with demo account"));
}

// edit widgets
try {

  switch ($_GET['do']) {
    case 'edit':
      /* valid inputs */
      if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
        _error(400);
      }
      /* update */
      $db->query(sprintf("UPDATE widgets SET title = %s, place = %s, place_order = %s, code = %s, language_id = %s, target_audience = %s WHERE widget_id = %s", secure($_POST['title']), secure($_POST['place']), secure($_POST['place_order'], 'int'), secure($_POST['message']), secure($_POST['language_id'], 'int'), secure($_POST['target_audience']), secure($_GET['id'], 'int')));
      /* return */
      return_json(['success' => true, 'message' => __("Widget info have been updated")]);
      break;

    case 'add':
      /* insert */
      $db->query(sprintf("INSERT INTO widgets (title, place, place_order, code, language_id, target_audience) VALUES (%s, %s, %s, %s, %s, %s)", secure($_POST['title']), secure($_POST['place']), secure($_POST['place_order'], 'int'), secure($_POST['message']), secure($_POST['language_id'], 'int'), secure($_POST['target_audience'])));
      /* return */
      return_json(['callback' => 'window.location = "' . $system['system_url'] . '/' . $control_panel['url'] . '/widgets";']);
      break;

    default:
      _error(400);
      break;
  }
} catch (Exception $e) {
  return_json(['error' => true, 'message' => $e->getMessage()]);
}
