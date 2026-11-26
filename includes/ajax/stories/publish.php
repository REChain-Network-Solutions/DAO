<?php

/**
 * ajax -> stories -> publish
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

// check demo account
if ($user->_data['user_demo']) {
  modal("ERROR", __("Demo Restriction"), __("You can't do this with demo account"));
}

// check if stories enabled
if (!$system['stories_enabled']) {
  modal("MESSAGE", __("Error"), __("This feature has been disabled by the admin"));
}

// check stories permission
if (!$user->_data['can_add_stories']) {
  if ($user->check_module_package_permission("stories_permission")) {
    return_json(["callback" => "window.location = '" . $system['system_url'] . "/packages?highlight=true';"]);
  } else {
    modal("MESSAGE", __("Error"), __("You don't have the permission to do this"));
  }
}

try {

  // initialize the return array
  $return = [];

  switch ($_REQUEST['do']) {
    case 'create':
      // open composer
      $return['callback'] = "stories_composer_open(" . json_encode([
        'is_admin' => (bool) $user->_is_admin,
        'can_upload_videos' => (bool) $user->_data['can_upload_videos'],
        'friends_enabled' => (bool) $system['friends_enabled'],
        'text' => (bool) $system['stories_text_enabled'],
        'polls' => (bool) $system['stories_polls_enabled'],
        'video_max' => (int) $system['stories_video_max_duration'],
        'music' => (bool) $system['stories_music_enabled'] && ($system['stories_music_itunes_enabled'] || $system['stories_music_library_enabled']),
        'music_itunes' => (bool) $system['stories_music_itunes_enabled'],
        'music_library' => (bool) $system['stories_music_library_enabled'],
        'music_country' => (preg_match('/^[a-z]{2}$/i', (string) $system['stories_music_itunes_country'])) ? strtoupper($system['stories_music_itunes_country']) : 'US',
      ]) . ");";
      break;

    case 'publish':
      // valid inputs
      if (!isset($_POST['story'])) {
        _error(400);
      }
      $story = json_decode($_POST['story'], true);
      if (!is_array($story)) {
        _error(400);
      }

      // post story
      $return['story_id'] = $user->post_story($story);
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
