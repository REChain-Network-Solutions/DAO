<?php

/**
 * ajax -> chat -> post ✅
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

  // post message
  /* post conversation message */
  $conversation = $user->post_conversation_message($_POST, true);

  /* add conversation to opened chat boxes session if not (and not a chatbox conversation) */
  if (!$conversation['node_id'] && !in_array($conversation['conversation_id'], $_SESSION['chat_boxes_opened'])) {
    $_SESSION['chat_boxes_opened'][] = $conversation['conversation_id'];
  }

  // return & exit
  return_json($conversation);
} catch (BadRequestException $e) {
  _error(400);
} catch (AuthorizationException $e) {
  _error(403);
} catch (Exception $e) {
  modal("ERROR", __("Error"), $e->getMessage());
}
