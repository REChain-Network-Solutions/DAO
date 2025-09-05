<?php

/**
 * ajax -> chat -> reaction ✅
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

      // delete converstaion ✅
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

      // leave converstaion ✅
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

      // update typing status ✅
      $user->update_conversation_typing_status($_POST['conversation_id'], $_POST['is_typing']);
      break;

    case 'seen':
      // valid inputs
      if (!isset($_POST['ids']) || !is_array($_POST['ids'])) {
        throw new BadRequestException(__("Invalid request"));
      }

      // update seen status ✅
      $user->update_conversation_seen_status((array)$_POST['ids']);
      break;

    case 'color':
      // valid inputs
      if (!isset($_POST['conversation_id']) || !is_numeric($_POST['conversation_id'])) {
        throw new BadRequestException(__("Invalid request"));
      }

      // color converstaion ✅
      $user->set_conversation_color($_POST['conversation_id'], $_POST['color']);
      break;

    default:
      throw new BadRequestException(__("Invalid request"));
      break;
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
