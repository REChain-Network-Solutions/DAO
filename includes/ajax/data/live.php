<?php

/**
 * ajax -> data -> live
 * 
 * @package Sngine
 * @author Zamblek
 */

// this request only reads the session
define('SESSION_READ_ONLY', true);

// fetch bootstrap
require('../../../bootstrap.php');

// check AJAX Request
is_ajax();

// check user logged in
if (!$user->_logged_in) {
  modal('LOGIN');
}

// valid inputs
/* if (last_request || last_message || last_notification) not set */
if (!isset($_POST['last_request']) || !isset($_POST['last_message']) || !isset($_POST['last_notification'])) {
  _error(400);
}
/* if (last_request || last_message || last_notification) not numeric */
if (!is_numeric($_POST['last_request']) || !is_numeric($_POST['last_message']) || !is_numeric($_POST['last_notification'])) {
  _error(400);
}

try {

  // initialize the return array
  $return = [];

  // [1] check current FE(user_id) == BE(user_id) (accounts switcher)
  if ($_POST['user_id'] != $user->_data['user_id']) {
    return_json(['callback' => 'window.location.reload();']);
  }

  // [2] check for new requests
  /* check if last friend reuqest deleted already */
  if ($system['friends_enabled']) {
    if ($_POST['last_request'] == $user->_data['user_live_requests_lastid']) {
      /* the page already shows the newest pending request */
    } elseif ($_POST['last_request'] != "0" && $user->check_last_friend_request($_POST['last_request'])) {
      /* return */
      $return['delete_last_request'] = true;
    } else {
      $requests = $user->get_friend_requests(0, $_POST['last_request']);
      if ($requests) {
        /* assign variables */
        $smarty->assign('requests', $requests);
        /* return */
        $return['requests_count'] = count($requests);
        $return['requests'] = $smarty->fetch("ajax.live.requests.tpl");
      }
    }
  }

  // [3] check for new messgaes
  if ($system['chat_enabled'] && $user->_data['user_privacy_chat'] != "me" && $_POST['last_message'] != $user->_data['user_live_messages_lastid']) {
    $conversations = $user->get_conversations()['data'];
    /* assign variables */
    $smarty->assign('conversations', $conversations);
    /* return */
    $return['conversations_count'] = $user->_data['user_live_messages_counter'];
    $return['conversations'] = $smarty->fetch("ajax.live.conversations.tpl");
  }

  // [4] check for new notifications (none newer than the page's newest one)
  $notifications = ($_POST['last_notification'] >= $user->_data['user_live_notifications_lastid']) ? [] : $user->get_notifications(0, $_POST['last_notification']);
  if ($notifications) {
    /* assign variables */
    $smarty->assign('notifications', $notifications);
    /* return */
    $return['notifications_json'] = $notifications;
    $return['notifications_count'] = count($notifications);
    $return['notifications'] = $smarty->fetch("ajax.live.notifications.tpl");
  }


  // [5] check for new posts
  if (isset($_POST['last_post'])) {
    $posts = $user->get_posts(['get' => $_POST['get'], 'filter' => $_POST['filter'], 'country' => $_POST['country'], 'id' => $_POST['id'], 'query' => $_POST['query'], 'last_post_id' => $_POST['last_post']]);
    if ($posts) {
      /* assign variables */
      $smarty->assign('posts', $posts);
      /* return */
      $return['posts'] = $smarty->fetch("ajax.posts.tpl");
      $return['posts_count'] = count($posts);
    }
  }

  // the newest ids the page now has (it sends them back with the next poll)
  $return['last_request_id'] = max((int) $user->_data['user_live_requests_lastid'], (int) max(array_column($requests ?? [], 'id') ?: [0]));
  $return['last_notification_id'] = max((int) $user->_data['user_live_notifications_lastid'], (int) max(array_column($notifications ?? [], 'notification_id') ?: [0]));
  $return['last_message_id'] = (int) $user->_data['user_live_messages_lastid'];

  // return & exit
  return_json($return);
} catch (Exception $e) {
  modal("ERROR", __("Error"), $e->getMessage());
}
