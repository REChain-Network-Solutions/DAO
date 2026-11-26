<?php

/**
 * ajax -> admin -> forums
 * 
 * @package Sngine
 * @author Zamblek
 */

// fetch bootstrap
require('../../../bootstrap.php');

// check AJAX Request
is_ajax();

// check admin|moderator permission
admin_access('mods_forums_permission');

// check demo account
if ($user->_data['user_demo']) {
  modal("ERROR", __("Demo Restriction"), __("You can't do this with demo account"));
}

// handle forums
try {

  /* valid inputs */
  if (!is_empty($_POST['forum_color']) && !preg_match('/^#[0-9a-fA-F]{3,8}$/', $_POST['forum_color'])) {
    throw new Exception(__("Please enter a valid color"));
  }
  if (!is_empty($_POST['forum_icon']) && !preg_match('/^[a-z0-9-]+$/', $_POST['forum_icon'])) {
    _error(400);
  }

  switch ($_GET['do']) {
    case 'add_forum':
      /* insert */
      $db->query(sprintf("INSERT INTO forums (forum_name, forum_description, forum_color, forum_icon, forum_section, forum_order) VALUES (%s, %s, %s, %s, %s, %s)", secure($_POST['forum_name']), secure($_POST['forum_description']), secure($_POST['forum_color']), secure($_POST['forum_icon']), secure($_POST['forum_section'], 'int'), secure($_POST['forum_order'], 'int')));
      /* return */
      return_json(['callback' => 'window.location = "' . $system['system_url'] . '/' . $control_panel['url'] . '/forums";']);
      break;

    case 'edit_forum':
      /* valid inputs */
      if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
        _error(400);
      }
      if ($_GET['id'] == $_POST['forum_section']) {
        throw new Exception(__("You can not set the forum as a section to itself"));
      }
      /* update */
      $db->query(sprintf("UPDATE forums SET forum_name = %s, forum_description = %s, forum_color = %s, forum_icon = %s, forum_section = %s, forum_order = %s WHERE forum_id = %s", secure($_POST['forum_name']), secure($_POST['forum_description']), secure($_POST['forum_color']), secure($_POST['forum_icon']), secure($_POST['forum_section'], 'int'), secure($_POST['forum_order'], 'int'), secure($_GET['id'], 'int')));
      /* return */
      return_json(['success' => true, 'message' => __("Forum info have been updated")]);
      break;

    default:
      _error(400);
      break;
  }
} catch (Exception $e) {
  return_json(['error' => true, 'message' => $e->getMessage()]);
}
