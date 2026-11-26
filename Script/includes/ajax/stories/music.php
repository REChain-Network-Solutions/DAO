<?php

/**
 * ajax -> stories -> music
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

// check if stories music enabled
if (!$system['stories_enabled'] || !$system['stories_music_enabled']) {
  _error(404);
}

try {

  // initialize the return array
  $return = [];

  switch ($_REQUEST['do']) {
    case 'list':
      // get tracks
      $tab = (isset($_GET['tab']) && $_GET['tab'] == 'library') ? 'library' : 'trending';
      $query = (isset($_GET['query'])) ? trim($_GET['query']) : '';
      $return['tracks'] = $user->get_stories_music($tab, $query);
      break;

    case 'refresh':
      // valid inputs
      if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
        _error(400);
      }
      // refresh track
      $return['track'] = $user->refresh_story_music($_POST['id']);
      break;

    default:
      _error(400);
      break;
  }

  // return & exit
  return_json($return);
} catch (Exception $e) {
  modal("ERROR", __("Error"), $e->getMessage());
}
