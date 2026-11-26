<?php

/**
 * ajax -> stories -> audience
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
  modal("MESSAGE", __("Error"), __("This feature has been disabled by the admin"));
}

// valid inputs
if (!isset($_GET['type']) || !in_array($_GET['type'], ['close', 'hidden'])) {
  _error(400);
}

try {

  // initialize the return array
  $return = [];

  switch ($_GET['do']) {
    case 'manage':
      break;

    case 'add':
    case 'remove':
      // valid inputs
      if (!isset($_REQUEST['id']) || !is_numeric($_REQUEST['id'])) {
        _error(400);
      }
      if ($_GET['do'] == 'add') {
        $user->add_story_audience($_GET['type'], $_REQUEST['id']);
      } else {
        $user->remove_story_audience($_GET['type'], $_REQUEST['id']);
      }
      break;

    default:
      _error(400);
      break;
  }

  // prepare audience
  $smarty->assign('type', $_GET['type']);
  $smarty->assign('users', $user->get_story_audience($_GET['type']));
  $return['audience'] = $smarty->fetch("ajax.stories.audience.tpl");
  $return['callback'] = "modal_content(response.audience);";

  // return & exit
  return_json($return);
} catch (Exception $e) {
  modal("ERROR", __("Error"), $e->getMessage());
}
