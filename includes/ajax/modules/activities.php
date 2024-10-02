<?php

/**
 * ajax -> modules -> activities
 * 
 * @package Delus
 * @author Dmitry
 */

// fetch bootstrap
require('../../../bootstrap.php');

// check AJAX Request
is_ajax();

// user access
user_access(true);

// check demo account
if ($user->_data['user_demo']) {
  modal("ERROR", __("Demo Restriction"), __("You can't do this with demo account"));
}

// check if activities module is enabled
if (!$system['pages_activities_enabled']) {
  modal("MESSAGE", __("System Message"), __("The activities module has been disabled by the admin"));
}

try {

  // initialize the return array
  $return = [];

  switch ($_REQUEST['do']) {
    case 'add':
      // get page
      $spage = $user->get_page($_REQUEST['id']);
      if (!$spage) {
        _error(400);
      }
      /* assign variables */
      $smarty->assign('spage', $spage);

      // check permissions
      /* check if activities enabled */
      if (!$spage['page_activities_enabled']) {
        throw new Exception(__("This page has disabled activities"));
      }
      /* check user can publish activities */
      if (!($user->check_page_adminship($user->_data['user_id'], $spage['page_id']) || $user->get_page_activities_user_permission($spage['page_id']) == "editor")) {
        throw new Exception(__("You don't have the right permission to access this"));
      }

      // get activities categories
      $smarty->assign('categories', $user->get_categories("activities_categories"));

      // prepare publisher
      $return['publisher'] = $smarty->fetch("ajax.activity.publisher.tpl");
      $return['callback'] = "$('#modal').modal('show'); $('.modal-content:last').html(response.publisher);";
      break;

    case 'publish':
      // add activity
      $user->add_page_activity($_POST);

      // return
      $return['callback'] = "window.location.reload();";
      break;

    case 'edit':
      // get activity
      $activity = $user->get_page_activity($_REQUEST['id']);
      if (!$activity) {
        _error(400);
      }
      /* check user can edit this activity */
      if (!$activity['can_edit']) {
        throw new Exception(__("You don't have the right permission to access this"));
      }
      /* if completed */
      if ($activity['status'] == 'completed') {
        throw new Exception(__("You can't edit a completed activity"));
      }
      /* assign variables */
      $smarty->assign('activity', $activity);

      // get activities categories
      $smarty->assign('categories', $user->get_categories("activities_categories"));

      // prepare publisher
      $return['publisher'] = $smarty->fetch("ajax.activity.edit.tpl");
      $return['callback'] = "$('#modal').modal('show'); $('.modal-content:last').html(response.publisher);";
      break;

    case 'update':
      // update activity
      $user->update_page_activity($_POST);

      // return
      $return['callback'] = "window.location.reload();";
      break;

    case 'delete':
      // delete activity
      $user->delete_page_activity($_REQUEST['id']);
      break;

    case 'permission_request':
      // permission request
      $user->request_activities_permission($_REQUEST['id']);
      break;

    case 'permission_accept':
      // accept permission request
      $user->accept_activities_permission($_REQUEST['id'], $_REQUEST['permission']);
      break;

    case 'permission_decline':
      // decline permission request
      $user->decline_activities_permission($_REQUEST['id']);
      break;

    case 'permission_revoke':
      // revoke permission
      $user->revoke_activities_permission($_REQUEST['id']);
      break;

    default:
      _error(400);
      break;
  }

  // return & exit
  return_json($return);
} catch (ValidationException $e) {
  return_json(['error' => true, 'message' => $e->getMessage()]);
} catch (Exception $e) {
  modal("ERROR", __("Error"), $e->getMessage());
}
