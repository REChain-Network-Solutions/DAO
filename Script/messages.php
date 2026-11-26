<?php

/**
 * messages
 * 
 * @package Sngine
 * @author Zamblek
 */

// fetch bootloader
require('bootloader.php');

// user access
user_access();

// page header
page_header(__("Messages"));

// check user chat privacy
if ($user->_data['user_privacy_chat'] == "me") {
  _error('CHAT_PERMISSION');
}

try {

  // get conversations
  $user->_data['conversations'] = $user->get_conversations()['data'];

  // check the view
  $view = (!isset($_GET['view'])) ? 'message' : 'new';

  // get view content
  if ($view == 'message') {

    if (!isset($_GET['cid'])) {
      $sub_view = 'all';
      if ($user->_data['conversations']) {
        $conversation = $user->check_mutual_conversation($user->_data['conversations'][0]['conversation_id']);
      }
    } else {
      $sub_view = 'conversation';
      /* check cid is valid */
      if (is_empty($_GET['cid']) || !is_numeric($_GET['cid'])) {
        _error(404);
      }
      $conversation = $user->check_mutual_conversation($_GET['cid']);
    }
    /* update the opened conversation as seen in the threads list */
    if ($conversation) {
      foreach ($user->_data['conversations'] as &$_conversation) {
        if ($_conversation['conversation_id'] == $conversation['conversation_id']) {
          $_conversation['seen'] = '1';
        }
      }
      unset($_conversation);
    }
    // assign variables
    $smarty->assign('sub_view', $sub_view);
    $smarty->assign('conversation', $conversation);
    $smarty->assign('conversation_profile', $user->get_conversation_profile($conversation));
  } elseif ($view == 'new') {

    /* get recipient page */
    if (isset($_GET['page_id']) && is_numeric($_GET['page_id'])) {
      $page_conversation_id = $user->get_page_conversation_id($_GET['page_id'], $user->_data['user_id']);
      if ($page_conversation_id) {
        redirect('/messages/' . $page_conversation_id);
      }
      $recipient_page = $user->get_chat_page($_GET['page_id']);
      if (!$recipient_page || !$system['pages_enabled'] || !$system['pages_messages_enabled'] || !$recipient_page['page_messages_enabled'] || $user->check_page_adminship($user->_data['user_id'], $recipient_page['page_id'])) {
        _error(404);
      }
      /* assign variables */
      $smarty->assign('recipient_page', $recipient_page);
    }

    /* get recipient */
    if (isset($_GET['uid'])) {
      $get_recipient = $db->query(sprintf("SELECT user_id, user_name, CONCAT(users.user_firstname,' ',users.user_lastname) as user_fullname FROM users WHERE user_id = %s", secure($_GET['uid'], 'int')));
      if ($get_recipient->num_rows > 0) {
        $recipient = $get_recipient->fetch_assoc();
        $recipient["user_fullname"] = ($system['show_usernames_enabled']) ? $recipient['user_name'] : $recipient['user_fullname'];
        /* assign variables */
        $smarty->assign('recipient', $recipient);
      }
    }
  }
  /* assign variables */
  $smarty->assign('view', $view);
} catch (Exception $e) {
  _error(__("Error"), $e->getMessage());
}

// page footer
page_footer('messages');
