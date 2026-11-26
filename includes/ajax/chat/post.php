<?php

/**
 * ajax -> chat -> post
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

  // post message
  switch ($_POST['handle']) {
    case 'paid':
      /* post conversation paid message */
      $conversation = $user->post_conversation_paid_message($_POST, true);

      /* prepare last message html */
      $smarty->assign('conversation', $conversation);
      $smarty->assign('message', $conversation['last_message']);
      $smarty->assign('is_me', true);
      $conversation['last_message_html'] = $smarty->fetch("__feeds_message.tpl");
      break;

    default:
      /* post conversation message */
      $conversation = $user->post_conversation_message($_POST, true);

      /* prepare last message html */
      if ($conversation) {
        $smarty->assign('conversation', $conversation);
        $smarty->assign('message', $conversation['last_message']);
        $smarty->assign('is_me', true);
        $conversation['last_message_html'] = $smarty->fetch("__feeds_message.tpl");
      }

      /* add conversation to opened chat boxes session if not (and not a chatbox conversation) */
      if (!$conversation['is_chatbox'] && empty($conversation['as_page']) && !in_array($conversation['conversation_id'], (array) $_SESSION['chat_boxes_opened'])) {
        $_SESSION['chat_boxes_opened'][] = $conversation['conversation_id'];
      }
      break;
  }

  // return & exit
  return_json($conversation);
} catch (ValidationException $e) {
  return_json(['error' => true, 'message' => $e->getMessage()]);
} catch (Exception $e) {
  modal("ERROR", __("Error"), $e->getMessage());
}
