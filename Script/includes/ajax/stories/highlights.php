<?php

/**
 * ajax -> stories -> highlights
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
if (!$system['stories_enabled'] || !$system['stories_highlights_enabled']) {
  modal("MESSAGE", __("Error"), __("This feature has been disabled by the admin"));
}

// valid inputs
if (!isset($_GET['story_id']) || !is_numeric($_GET['story_id'])) {
  _error(400);
}

try {

  // initialize the return array
  $return = [];

  switch ($_GET['do']) {
    case 'manage':
      $user->check_my_story($_GET['story_id']);
      break;

    case 'create':
      $user->create_stories_highlight($_POST['title'] ?? '', $_GET['story_id']);
      break;

    case 'toggle':
    case 'delete':
      // valid inputs
      if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
        _error(400);
      }
      if ($_GET['do'] == 'toggle') {
        $user->toggle_stories_highlight($_GET['id'], $_GET['story_id']);
      } else {
        $user->delete_stories_highlight($_GET['id']);
      }
      break;

    default:
      _error(400);
      break;
  }

  // prepare highlights
  $smarty->assign('story_id', $_GET['story_id']);
  $smarty->assign('highlights', $user->get_stories_highlights($user->_data['user_id'], $_GET['story_id']));
  $return['highlights'] = $smarty->fetch("ajax.stories.highlights.tpl");
  $return['callback'] = "modal_content(response.highlights);";

  // return & exit
  return_json($return);
} catch (ValidationException $e) {
  return_json(['error' => true, 'message' => $e->getMessage()]);
} catch (Exception $e) {
  modal("ERROR", __("Error"), $e->getMessage());
}
