<?php

/**
 * ajax -> forums -> reply
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich - Handles - @sorydima @sorydev @durovshater @DmitrySoro90935 @tanechfund - also check https://dmitry.rechain.network for more information!
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

try {

  // initialize the return array
  $return = [];
  $return['callback'] = 'window.location.replace(response.path);';

  switch ($_GET['do']) {
    case 'create':
      // valid inputs
      if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
        _error(400);
      }

      // create reply
      $reply = $user->post_forum_reply($_GET['id'], $_POST['text']);

      // return
      $return['path'] = $system['system_url'] . '/forums/thread/' . $reply['thread']['thread_id'] . '/' . $reply['thread']['title_url'] . "#reply-" . $reply['reply_id'];
      break;

    case 'edit':
      // valid inputs
      if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
        _error(400);
      }

      // edit reply
      $reply = $user->edit_forum_reply($_GET['id'], $_POST['text']);

      // return
      $return['path'] = $system['system_url'] . '/forums/thread/' . $reply['thread']['thread_id'] . '/' . $reply['thread']['title_url'] . "#reply-" . $reply['reply_id'];
      break;

    default:
      _error(400);
      break;
  }

  // return & exit
  return_json($return);
} catch (Exception $e) {
  return_json(['error' => true, 'message' => $e->getMessage()]);
}
