<?php

/**
 * ajax -> stories -> load
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
if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
  _error(400);
}

try {

  // initialize the return array
  $return = [];

  switch ($_GET['do']) {
    case 'user':
      // get user stories
      $return = $user->get_user_stories($_GET['id']);
      break;

    case 'story':
      // get story
      $story = $user->get_story($_GET['id']);
      if (!$story) {
        return_json(['items' => []]);
      }
      $return = $user->get_user_stories($story['user_id'], $story['story_id']);
      break;

    case 'archive':
      // get archived story
      $story = ($system['stories_archive_enabled']) ? $user->get_story($_GET['id']) : false;
      if (!$story || $story['user_id'] != $user->_data['user_id']) {
        return_json(['items' => []]);
      }
      $return = $user->get_user_stories($story['user_id'], $story['story_id'], null, true);
      break;

    case 'highlight':
      // get highlight
      $highlight = ($system['stories_highlights_enabled']) ? $user->get_stories_highlight($_GET['id']) : false;
      if (!$highlight) {
        return_json(['items' => []]);
      }
      $return = $user->get_user_stories($highlight['user_id'], null, $highlight);
      break;

    case 'viewers':
      // get story viewers
      $offset = (isset($_GET['offset']) && is_numeric($_GET['offset'])) ? (int) $_GET['offset'] : 0;
      $data = $user->get_story_viewers($_GET['id'], $offset);
      /* assign variables */
      $smarty->assign('viewers', $data['viewers']);
      /* return */
      $return['views_count'] = (int) $data['story']['views_count'];
      $return['reactions_count'] = (int) $data['story']['reactions_count'];
      $return['count'] = count($data['viewers']);
      $return['more'] = (count($data['viewers']) >= $system['max_results']);
      $return['viewers'] = $smarty->fetch("ajax.stories.viewers.tpl");
      break;

    default:
      _error(400);
      break;
  }

  // return & exit
  return_json($return);
} catch (NoDataException $e) {
  return_json(['items' => []]);
} catch (Exception $e) {
  modal("ERROR", __("Error"), $e->getMessage());
}
