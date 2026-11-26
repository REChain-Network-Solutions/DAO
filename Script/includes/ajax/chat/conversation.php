<?php

/**
 * ajax -> chat -> conversation
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

  switch ($_GET['do']) {
    case 'get':
      // get conversation
      $as_page = !empty($_GET['as_page']);
      $conversation = $user->check_mutual_conversation($_GET['conversation_id'], null, null, $as_page);
      if ($conversation) {
        /* assign variables */
        $smarty->assign('conversation', $conversation);
        $smarty->assign('conversation_profile', $user->get_conversation_profile($conversation));
        /* return */
        $return['conversation'] = $conversation;
        $return['conversation_html'] = $smarty->fetch("ajax.chat.conversation.tpl");
      }
      break;

    case 'check':
      // check mutual conversation (even deleted)
      if (isset($_GET['page_id'])) {
        $mutual_conversation = $user->get_page_conversation_id($_GET['page_id'], $user->_data['user_id']);
      } else {
        $mutual_conversation = $user->get_mutual_conversation_id((array)$_GET['uid'], true);
      }
      if ($mutual_conversation) {
        $return['conversation_id'] = $mutual_conversation;
      }
      break;

    case 'page_inbox':
      // valid inputs
      if (!isset($_GET['page_id']) || !is_numeric($_GET['page_id'])) {
        throw new BadRequestException(__("Invalid request"));
      }

      // get page conversations
      $conversations = $user->get_page_conversations($_GET['page_id']);
      /* assign variables */
      $smarty->assign('get', 'page_conversations');
      $smarty->assign('data', $conversations['data']);
      $smarty->assign('_active_cid', $_GET['cid'] ?? null);
      /* return */
      $return['inbox'] = $smarty->fetch("ajax.load_more.tpl");
      $return['unseen_count'] = $user->get_page_unseen_conversations_count($_GET['page_id']);
      break;

    case 'group':
      // valid inputs
      if (!isset($_GET['conversation_id']) || !is_numeric($_GET['conversation_id'])) {
        throw new BadRequestException(__("Invalid request"));
      }

      // get group conversation
      $conversation = $user->get_conversation($_GET['conversation_id']);
      if (!$conversation || $conversation['node_id'] || !$conversation['multiple_recipients']) {
        $return['callback'] = "modal_close();";
        break;
      }
      /* assign variables */
      $smarty->assign('conversation', $conversation);
      /* return */
      $return['template'] = $smarty->fetch("ajax.chat.group.tpl");
      $return['callback'] = "modal_content(response.template);";
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
