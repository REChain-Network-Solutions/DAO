<?php

/**
 * ajax -> data -> dropdown
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

try {

  // get the viewer's header dropdown list (rendered with the header template, the page takes its list items)
  switch ($_GET['get'] ?? '') {
    case 'friend_requests':
      $user->_data['friend_requests'] = $user->get_friend_requests();
      $template = '_header.friend_requests.tpl';
      break;

    case 'messages':
      $user->_data['conversations'] = $user->get_conversations()['data'];
      $template = '_header.messages.tpl';
      break;

    case 'notifications':
      $user->_data['notifications'] = $user->get_notifications();
      $template = '_header.notifications.tpl';
      break;

    default:
      _error(400);
      break;
  }

  // return & exit
  return_json(['html' => $smarty->fetch($template)]);
} catch (Exception $e) {
  modal("ERROR", __("Error"), $e->getMessage());
}
