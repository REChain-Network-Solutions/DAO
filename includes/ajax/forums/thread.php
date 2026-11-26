<?php

/**
 * ajax -> forums -> thread
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

try {

  // initialize the return array
  $return = [];
  $return['callback'] = 'window.location.replace(response.path);';

  switch ($_GET['do']) {
    case 'create':
      // valid inputs
      if (!isset($_POST['forum_id']) || !is_numeric($_POST['forum_id'])) {
        throw new Exception(__("You must select a forum for your thread"));
      }

      // create thread
      $thread_id = $user->post_forum_thread($_POST['forum_id'], $_POST['title'], $_POST['text']);

      // return
      $return['path'] = $system['system_url'] . '/forums/thread/' . $thread_id . '/' . get_url_text($_POST['title']);
      break;

    case 'edit':
      // valid inputs
      if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
        _error(400);
      }

      // edit thread
      $user->edit_forum_thread($_GET['id'], $_POST['title'], $_POST['text']);

      // return
      $return['path'] = $system['system_url'] . '/forums/thread/' . $_GET['id'] . '/' . get_url_text($_POST['title']);
      break;

    case 'pin':
    case 'unpin':
    case 'lock':
    case 'unlock':
      // valid inputs
      if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
        _error(400);
      }

      // update thread status
      $user->update_forum_thread_status($_GET['id'], $_GET['do']);

      // return
      $return['callback'] = 'window.location.reload();';
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
