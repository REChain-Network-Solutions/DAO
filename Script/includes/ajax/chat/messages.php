<?php

/**
 * ajax -> chat -> get messages ✅
 * 
 * @package Delus
 * @author Dmitry Sorokin - @sorydima & @sorydev Handles. 
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
  $conversation = $user->check_mutual_conversation($_GET['conversation_id'], $_GET['user_id']);

  if ($conversation) {
    /* return [conversation_id: to set it as chat-box cid] */
    $return['conversation_id'] = $mutual_conversation_id;

    /* return [color] */
    $return['color'] = $conversation['color'];

    /* return [chat_price] */
    $return['chat_price'] = $conversation['chat_price'];

    /* return [call_price] */
    $return['call_price'] = $conversation['call_price'];

    /* return [messages] */
    $smarty->assign('conversation', $conversation);
    $return['messages'] = $smarty->fetch("ajax.chat.conversation.messages.tpl");

    /* add conversation to opened chat boxes session if not (and not a chatbox conversation) */
    if (!$conversation['node_id'] && !in_array($conversation['conversation_id'], $_SESSION['chat_boxes_opened'])) {
      $_SESSION['chat_boxes_opened'][] = $conversation['conversation_id'];
    }
  }

  // return & exit
  return_json($return);
} catch (BadRequestException $e) {
  _error(400);
} catch (AuthorizationException $e) {
  _error(403);
} catch (Exception $e) {
  modal("ERROR", __("Error"), $e->getMessage());
}
