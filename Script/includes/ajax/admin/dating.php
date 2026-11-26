<?php

/**
 * ajax -> admin -> dating
 * 
 * @package Sngine
 * @author Zamblek
 */

// fetch bootstrap
require('../../../bootstrap.php');

// check AJAX Request
is_ajax();

// check admin|moderator permission
if (in_array($_GET['do'], ['add_interest', 'edit_interest'])) {
  admin_access();
} else {
  admin_access('mods_dating_permission');
}

// check demo account
if ($user->_data['user_demo']) {
  modal("ERROR", __("Demo Restriction"), __("You can't do this with demo account"));
}

// handle dating
try {

  switch ($_GET['do']) {
    case 'add_interest':
    case 'edit_interest':
      /* valid inputs */
      if (is_empty($_POST['title'])) {
        throw new Exception(__("Please enter a valid title"));
      }
      if (!is_empty($_POST['interest_order']) && !is_numeric($_POST['interest_order'])) {
        throw new Exception(__("Please enter a valid order"));
      }
      if ($_GET['do'] == 'add_interest') {
        /* insert */
        $db->query(sprintf("INSERT INTO dating_interests (title, icon, interest_order) VALUES (%s, %s, %s)", secure($_POST['title']), secure($_POST['icon']), secure($_POST['interest_order'], 'int')));
        /* return */
        return_json(['callback' => 'window.location = "' . $system['system_url'] . '/' . $control_panel['url'] . '/dating/interests";']);
      }
      /* valid inputs */
      if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
        _error(400);
      }
      /* update */
      $db->query(sprintf("UPDATE dating_interests SET title = %s, icon = %s, interest_order = %s WHERE interest_id = %s", secure($_POST['title']), secure($_POST['icon']), secure($_POST['interest_order'], 'int'), secure($_GET['id'], 'int')));
      /* return */
      return_json(['success' => true, 'message' => __("Interest info have been updated")]);
      break;

    case 'edit_member':
      /* valid inputs */
      if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
        _error(400);
      }
      /* update */
      $user->update_dating_profile($_GET['id'], $_POST);
      /* return */
      return_json(['success' => true, 'message' => __("Dating profile have been updated")]);
      break;

    case 'suspend':
    case 'unsuspend':
    case 'pause':
    case 'resume':
      /* valid inputs */
      if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
        _error(400);
      }
      /* update */
      $status = ['suspend' => 'suspended', 'unsuspend' => 'paused', 'pause' => 'paused', 'resume' => 'active'][$_GET['do']];
      $db->query(sprintf("UPDATE dating_profiles SET status = %s WHERE user_id = %s", secure($status), secure($_GET['id'], 'int')));
      if ($status != 'active') {
        $db->query(sprintf("DELETE FROM dating_locations WHERE user_id = %s", secure($_GET['id'], 'int')));
        $db->query(sprintf("UPDATE dating_profiles SET latitude = NULL, longitude = NULL WHERE user_id = %s", secure($_GET['id'], 'int')));
      }
      /* return */
      return_json(['callback' => 'window.location.reload();']);
      break;

    case 'approve_photo':
      /* valid inputs */
      if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
        _error(400);
      }
      /* update */
      $db->query(sprintf("UPDATE dating_photos SET status = 'approved' WHERE photo_id = %s", secure($_GET['id'], 'int')));
      /* return */
      return_json(['callback' => 'window.location.reload();']);
      break;

    default:
      _error(400);
      break;
  }
} catch (Exception $e) {
  return_json(['error' => true, 'message' => $e->getMessage()]);
}
