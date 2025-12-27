<?php

/**
 * ajax -> admin -> gifts
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich
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

// handle gifts
try {

  switch ($_GET['do']) {
    case 'add':
      /* valid inputs */
      if (is_empty($_POST['image'])) {
        throw new Exception(__("You must upload gift image"));
      }
      if ($system['gifts_points_enabled']) {
        if (is_empty($_POST['points']) || !is_numeric($_POST['points']) || $_POST['points'] <= 0) {
          throw new Exception(__("You must enter valid amount of points"));
        }
      }
      /* insert */
      if ($system['gifts_points_enabled']) {
        $db->query(sprintf("INSERT INTO gifts (image, points) VALUES (%s, %s)", secure($_POST['image']), secure($_POST['points'], 'int')));
      } else {
        $db->query(sprintf("INSERT INTO gifts (image) VALUES (%s)", secure($_POST['image'])));
      }
      /* remove pending uploads */
      remove_pending_uploads([$_POST['image']]);
      /* return */
      return_json(['callback' => 'window.location = "' . $system['system_url'] . '/' . $control_panel['url'] . '/gifts";']);
      break;

    case 'edit':
      /* valid inputs */
      if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
        _error(400);
      }
      if (is_empty($_POST['image'])) {
        throw new Exception(__("You must upload gift image"));
      }
      if ($system['gifts_points_enabled']) {
        if (is_empty($_POST['points']) || !is_numeric($_POST['points']) || $_POST['points'] <= 0) {
          throw new Exception(__("You must enter valid amount of points"));
        }
      }
      /* update */
      if ($system['gifts_points_enabled']) {
        $db->query(sprintf("UPDATE gifts SET image = %s, points = %s WHERE gift_id = %s", secure($_POST['image']), secure($_POST['points'], 'int'), secure($_GET['id'], 'int')));
      } else {
        $db->query(sprintf("UPDATE gifts SET image = %s WHERE gift_id = %s", secure($_POST['image']), secure($_GET['id'], 'int')));
      }
      /* remove pending uploads */
      remove_pending_uploads([$_POST['image']]);
      /* return */
      return_json(['success' => true, 'message' => __("gift info have been updated")]);
      break;

    default:
      _error(400);
      break;
  }
} catch (Exception $e) {
  return_json(['error' => true, 'message' => $e->getMessage()]);
}
