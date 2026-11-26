<?php

/**
 * ajax -> chat -> get messages
 * 
 * @package Sngine
 * @author Zamblek
 */

// fetch bootstrap
require('../../../bootstrap.php');

// check AJAX Request
is_ajax();

// check user logged in
if (!$user->_logged_in) {
  modal('LOGIN');
}

try {

  // initialize the return array
  $return = [];

  // check single user's chat status
  if (isset($_GET['user_id'])) {
    $return['user_online'] = $user->user_online($_GET['user_id']);
  }

  // check mutual conversation
  $conversation = $user->check_mutual_conversation($_GET['conversation_id'], $_GET['user_id'], $_GET['page_id'] ?? null, !empty($_GET['as_page']));

  if ($conversation) {
    /* return [conversation_id: to set it as chat-box cid] */
    $return['conversation_id'] = $conversation['conversation_id'];

    /* return [color] */
    $return['color'] = $conversation['color'];

    /* return [chat_price] */
    $return['chat_price'] = $conversation['chat_price'];

    /* return [call_price] */
    $return['call_price'] = $conversation['call_price'];

    /* return [picture] so the chat-box header can replace a stale/broken socket URL */
    if (!empty($conversation['picture'])) {
      $return['picture'] = $conversation['picture'];
    }

    /* return [picture_left & picture_right] for multiple recipients */
    if (empty($conversation['picture']) && !empty($conversation['picture_left'])) {
      $return['picture_left'] = $conversation['picture_left'];
      $return['picture_right'] = $conversation['picture_right'];
    }

    /* return [messages] */
    $smarty->assign('conversation', $conversation);
    $return['messages'] = $smarty->fetch("ajax.chat.conversation.messages.tpl");
    $return['pin_html'] = $smarty->fetch("__chat_pin.tpl");

    /* add conversation to opened chat boxes session if not (and not a chatbox conversation) */
    if (!$conversation['is_chatbox'] && empty($conversation['as_page']) && !in_array($conversation['conversation_id'], (array) $_SESSION['chat_boxes_opened'])) {
      $_SESSION['chat_boxes_opened'][] = $conversation['conversation_id'];
    }
  }

  // return & exit
  return_json($return);
} catch (Exception $e) {
  modal("ERROR", __("Error"), $e->getMessage());
}
