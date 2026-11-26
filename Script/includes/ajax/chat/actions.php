<?php

/**
 * ajax -> chat -> actions
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

try {

  // initialize the return array
  $return = [];

  switch ($_POST['do']) {
    case 'close':
      // valid inputs
      if (!isset($_POST['conversation_id']) || !is_numeric($_POST['conversation_id'])) {
        throw new BadRequestException(__("Invalid request"));
      }

      // unset from opened chat boxes
      if (($key = array_search($_POST['conversation_id'], $_SESSION['chat_boxes_opened'])) !== false) {
        unset($_SESSION['chat_boxes_opened'][$key]);
        /* reindex the array */
        $_SESSION['chat_boxes_opened'] = array_values($_SESSION['chat_boxes_opened']);
        /* remove typing status */
        $user->update_conversation_typing_status($_POST['conversation_id'], false);
      }
      break;

    case 'delete':
      // valid inputs
      if (!isset($_POST['conversation_id']) || !is_numeric($_POST['conversation_id'])) {
        throw new BadRequestException(__("Invalid request"));
      }

      // delete converstaion
      $user->delete_conversation($_POST['conversation_id']);

      // unset from opened chat boxes
      if (($key = array_search($_POST['conversation_id'], $_SESSION['chat_boxes_opened'])) !== false) {
        unset($_SESSION['chat_boxes_opened'][$key]);
        /* reindex the array */
        $_SESSION['chat_boxes_opened'] = array_values($_SESSION['chat_boxes_opened']);
      }
      break;

    case 'leave':
      // valid inputs
      if (!isset($_POST['conversation_id']) || !is_numeric($_POST['conversation_id'])) {
        throw new BadRequestException(__("Invalid request"));
      }

      // leave converstaion
      $user->leave_conversation($_POST['conversation_id']);

      // unset from opened chat boxes
      if (($key = array_search($_POST['conversation_id'], $_SESSION['chat_boxes_opened'])) !== false) {
        unset($_SESSION['chat_boxes_opened'][$key]);
        /* reindex the array */
        $_SESSION['chat_boxes_opened'] = array_values($_SESSION['chat_boxes_opened']);
      }
      break;

    case 'typing':
      // valid inputs
      if (!isset($_POST['conversation_id']) || !is_numeric($_POST['conversation_id'])) {
        throw new BadRequestException(__("Invalid request"));
      }

      // update typing status
      $user->update_conversation_typing_status($_POST['conversation_id'], $_POST['is_typing'], !empty($_POST['as_page']));
      break;

    case 'seen':
      // valid inputs
      if (!isset($_POST['ids']) || !is_array($_POST['ids'])) {
        throw new BadRequestException(__("Invalid request"));
      }

      // update seen status
      $user->update_conversation_seen_status((array)$_POST['ids'], !empty($_POST['as_page']));
      break;

    case 'color':
      // valid inputs
      if (!isset($_POST['conversation_id']) || !is_numeric($_POST['conversation_id'])) {
        throw new BadRequestException(__("Invalid request"));
      }

      // color converstaion
      $user->set_conversation_color($_POST['conversation_id'], $_POST['color']);
      break;

    case 'rename':
      // valid inputs
      if (!isset($_POST['conversation_id']) || !is_numeric($_POST['conversation_id'])) {
        throw new BadRequestException(__("Invalid request"));
      }

      // rename conversation
      $return['conversation_id'] = $_POST['conversation_id'];
      $return['conversation'] = $user->rename_conversation($_POST['conversation_id'], $_POST['name'] ?? '');
      break;

    case 'add':
      // valid inputs
      if (!isset($_POST['conversation_id']) || !is_numeric($_POST['conversation_id'])) {
        throw new BadRequestException(__("Invalid request"));
      }
      if (!isset($_POST['user_id']) || !is_numeric($_POST['user_id'])) {
        throw new BadRequestException(__("Invalid request"));
      }

      // add conversation user
      $return['conversation_id'] = $_POST['conversation_id'];
      $return['conversation'] = $user->add_conversation_user($_POST['conversation_id'], $_POST['user_id']);
      $return['added_user_id'] = $_POST['user_id'];
      break;

    case 'remove':
      // valid inputs
      if (!isset($_POST['conversation_id']) || !is_numeric($_POST['conversation_id'])) {
        throw new BadRequestException(__("Invalid request"));
      }
      if (!isset($_POST['user_id']) || !is_numeric($_POST['user_id'])) {
        throw new BadRequestException(__("Invalid request"));
      }

      // remove conversation user
      $return['conversation_id'] = $_POST['conversation_id'];
      $return['conversation'] = $user->remove_conversation_user($_POST['conversation_id'], $_POST['user_id']);
      $return['removed_user_id'] = $_POST['user_id'];
      break;

    case 'delete_message':
      if (!isset($_POST['message_id']) || !is_numeric($_POST['message_id'])) {
        throw new BadRequestException(__("Invalid request"));
      }
      $user->delete_conversation_message($_POST['message_id']);
      $return['message_id'] = $_POST['message_id'];
      break;

    case 'react_message':
      if (!isset($_POST['message_id']) || !is_numeric($_POST['message_id'])) {
        throw new BadRequestException(__("Invalid request"));
      }
      $user->react_message($_POST['message_id'], $_POST['reaction']);
      $return['message'] = $user->get_conversation_message_by_id($_POST['message_id']);
      break;

    case 'unreact_message':
      if (!isset($_POST['message_id']) || !is_numeric($_POST['message_id'])) {
        throw new BadRequestException(__("Invalid request"));
      }
      $user->unreact_message($_POST['message_id'], $_POST['reaction']);
      $return['message'] = $user->get_conversation_message_by_id($_POST['message_id']);
      break;

    case 'pin':
      if (!isset($_POST['message_id']) || !is_numeric($_POST['message_id'])) {
        throw new BadRequestException(__("Invalid request"));
      }
      $conversation = $user->pin_conversation_message($_POST['message_id'], !empty($_POST['as_page']));
      $return['conversation'] = $conversation;
      $smarty->assign('conversation', $conversation);
      $return['pin_html'] = $smarty->fetch("__chat_pin.tpl");
      break;

    case 'unpin':
      if (!isset($_POST['conversation_id']) || !is_numeric($_POST['conversation_id'])) {
        throw new BadRequestException(__("Invalid request"));
      }
      $conversation = $user->unpin_conversation_message($_POST['conversation_id'], !empty($_POST['as_page']));
      $return['conversation'] = $conversation;
      $smarty->assign('conversation', $conversation);
      $return['pin_html'] = $smarty->fetch("__chat_pin.tpl");
      break;

    default:
      throw new BadRequestException(__("Invalid request"));
      break;
  }

  // return & exit
  return_json($return);
} catch (Exception $e) {
  modal("ERROR", __("Error"), $e->getMessage());
}
