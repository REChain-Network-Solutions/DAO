<?php

/**
 * ajax -> dating -> profile
 * 
 * @package Sngine
 * @author Zamblek
 */

// fetch bootstrap
require('../../../bootstrap.php');

// check AJAX Request
is_ajax();

// user access
user_access(true);

// dating enabled
if (!$user->_data['can_use_dating']) {
  modal("MESSAGE", __("Error"), __("This feature has been disabled by the admin"));
}

// check demo account
if ($user->_data['user_demo']) {
  modal("ERROR", __("Demo Restriction"), __("You can't do this with demo account"));
}

try {

  // initialize the return array
  $return = [];

  switch ($_GET['do']) {
    case 'save':
      // save
      $joined = !$user->get_dating_profile();
      $user->save_dating_profile($_POST);

      // return
      if ($joined) {
        $return['callback'] = 'window.location = "' . $system['system_url'] . '/dating/profile";';
      } else {
        $return['success'] = true;
        $return['message'] = __("Your dating profile has been updated");
      }
      break;

    case 'status':
      // update
      $user->set_dating_status($_POST['status']);

      // return
      $return['callback'] = 'window.location.reload();';
      break;

    case 'delete':
      // delete
      $user->delete_dating_profile();

      // return
      $return['callback'] = 'window.location = "' . $system['system_url'] . '";';
      break;

    case 'photo_add':
      // add
      $photo = $user->add_dating_photo($_POST['source']);
      /* the first photo opens dating */
      if ($photo['status'] == 'approved' && count($user->get_dating_photos([$user->_data['user_id']])[$user->_data['user_id']] ?? []) == 1) {
        $return['callback'] = 'window.location = "' . $system['system_url'] . '/dating";';
      }
      break;

    case 'photo_delete':
      // valid inputs
      if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
        _error(400);
      }

      // delete
      $user->delete_dating_photo($_POST['id']);
      break;

    case 'photos_sort':
      // sort
      $user->sort_dating_photos($_POST['ids'] ?? []);
      break;

    default:
      _error(400);
      break;
  }

  // photos
  if (in_array($_GET['do'], ['photo_add', 'photo_delete'])) {
    /* assign variables */
    $smarty->assign('dating_photos', $user->get_dating_photos([$user->_data['user_id']], false)[$user->_data['user_id']] ?? []);
    /* return */
    $return['photos'] = $smarty->fetch("__dating_photos.tpl");
  }

  // return & exit
  return_json($return);
} catch (ValidationException $e) {
  return_json(['error' => true, 'message' => $e->getMessage()]);
} catch (Exception $e) {
  modal("ERROR", __("Error"), $e->getMessage());
}
