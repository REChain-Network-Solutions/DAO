<?php

/**
 * ajax -> stories -> action
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

// check if stories enabled
if (!$system['stories_enabled']) {
  _error(404);
}

// valid inputs
if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
  _error(400);
}

try {

  // initialize the return array
  $return = [];

  switch ($_POST['do']) {
    case 'view':
      // view story
      $user->view_story($_POST['id']);
      break;

    case 'react':
      // react story
      if (!isset($_POST['reaction'])) {
        _error(400);
      }
      $user->react_story($_POST['id'], $_POST['reaction']);
      break;

    case 'unreact':
      // unreact story
      $user->unreact_story($_POST['id']);
      break;

    case 'repost':
      // check demo account
      if ($user->_data['user_demo']) {
        modal("ERROR", __("Demo Restriction"), __("You can't do this with demo account"));
      }
      // repost story
      $return['story_id'] = $user->repost_story($_POST['id']);
      break;

    case 'vote':
      // vote story
      if (!isset($_POST['option'])) {
        _error(400);
      }
      $return['poll'] = $user->vote_story($_POST['id'], $_POST['option']);
      break;

    case 'delete':
      // check demo account
      if ($user->_data['user_demo']) {
        modal("ERROR", __("Demo Restriction"), __("You can't do this with demo account"));
      }
      // delete story
      $user->delete_story($_POST['id']);
      break;

    default:
      _error(400);
      break;
  }

  // return & exit
  return_json($return);
} catch (ValidationException $e) {
  modal("MESSAGE", __("Error"), $e->getMessage());
} catch (Exception $e) {
  modal("ERROR", __("Error"), $e->getMessage());
}
