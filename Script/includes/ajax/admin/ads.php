<?php

/**
 * ajax -> admin -> ads
 * 
 * @package Sngine
 * @author Zamblek
 */

// fetch bootstrap
require('../../../bootstrap.php');

// check AJAX Request
is_ajax();

// check admin|moderator permission
admin_access('mods_ads_permission');

// check demo account
if ($user->_data['user_demo']) {
  modal("ERROR", __("Demo Restriction"), __("You can't do this with demo account"));
}

// refresh the compiled system cache
register_shutdown_function('system_cache_flush');

// handle ads
try {

  switch ($_REQUEST['do']) {
    case 'edit':
      /* valid inputs */
      if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
        _error(400);
      }
      /* valid inputs */
      $ads_pages_ids = ($_POST['place'] == "pages") ? secure($_POST['ads_pages_ids']) : 'null';
      $ads_groups_ids = ($_POST['place'] == "groups") ? secure($_POST['ads_groups_ids']) : 'null';
      /* update */
      $db->query(sprintf("UPDATE ads_system SET title = %s, place = %s, ads_pages_ids = %s, ads_groups_ids = %s, code = %s WHERE ads_id = %s", secure($_POST['title']), secure($_POST['place']), $ads_pages_ids, $ads_groups_ids, secure($_POST['message']), secure($_GET['id'], 'int')));
      /* return */
      return_json(['success' => true, 'message' => __("Ads info have been updated")]);
      break;

    case 'add':
      /* valid inputs */
      $ads_pages_ids = ($_POST['place'] == "pages") ? secure($_POST['ads_pages_ids']) : 'null';
      $ads_groups_ids = ($_POST['place'] == "groups") ? secure($_POST['ads_groups_ids']) : 'null';
      /* insert */
      $db->query(sprintf("INSERT INTO ads_system (title, place, ads_pages_ids, ads_groups_ids, code, time) VALUES (%s, %s, %s, %s, %s, %s)", secure($_POST['title']), secure($_POST['place']), $ads_pages_ids, $ads_groups_ids, secure($_POST['message']), secure($date)));
      /* return */
      return_json(['callback' => 'window.location = "' . $system['system_url'] . '/' . $control_panel['url'] . '/ads/system_ads";']);
      break;

    default:
      _error(400);
      break;
  }
} catch (Exception $e) {
  return_json(['error' => true, 'message' => $e->getMessage()]);
}
