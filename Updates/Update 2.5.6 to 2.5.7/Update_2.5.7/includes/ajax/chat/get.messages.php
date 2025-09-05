<?php
/**
 * ajax -> chat -> get messages
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich - Handles - @sorydima @sorydev @durovshater @DmitrySoro90935 @tanechfund - also check https://dmitry.rechain.network for more information!
 */

// fetch bootstrap
require('../../../bootstrap.php');

// check AJAX Request
is_ajax();

// check user logged in
if(!$user->_logged_in) {
    modal(LOGIN);
}

// valid inputs
/* if both (conversation_id & user_id) not set */
if(!isset($_GET['conversation_id']) && !isset($_GET['user_id'])) {
	_error(400);
}
/* if conversation_id set -> it must be numeric */
if(isset($_GET['conversation_id']) && !is_numeric($_GET['conversation_id'])) {
	_error(400);
}
/* if user_id not set -> it must be numeric */
if(isset($_GET['user_id']) && !is_numeric($_GET['user_id'])) {
	_error(400);
}


// get conversation messages
try {

	// initialize the return array
	$return = array();

	// initialize the conversation
	$conversation = array();

	/* check single user's chat status */
	if(isset($_GET['user_id'])) {
		$return['user_online'] = ($user->user_online($_GET['ids']))? true: false;
	}

	/* if conversation_id not set -> check if there is a mutual conversation */
	if(!isset($_GET['conversation_id'])) {
		$mutual_conversation = $user->get_mutual_conversation((array)$_GET['user_id']);
		if(!$mutual_conversation) {
			/* there is no mutual conversation -> return & exit */
			return_json($return);
		}
		/* set the conversation_id */
		$_GET['conversation_id'] = $mutual_conversation;
		/* return to set it as chat-box cid */
		$return['conversation_id'] = $mutual_conversation;
	}

	/* set conversation id */
	$conversation['conversation_id'] = $_GET['conversation_id'];

	/* get total number of messages */
	$conversation['total_messages'] = $user->get_conversation_total_messages($conversation['conversation_id']);

	/* get conversation color */
	$conversation['color'] = $user->get_conversation_color($conversation['conversation_id']);
	$return['color'] = $conversation['color'];

	/* get conversation messages */
	$conversation['messages'] = $user->get_conversation_messages($conversation['conversation_id']);
	
	/* assign variables */
	$smarty->assign('conversation', $conversation);
	
	/* return */
	$return['messages'] = $smarty->fetch("ajax.chat.conversation.messages.tpl");

	/* add conversation to opened chat boxes session if not */
	if(!in_array($conversation['conversation_id'], $_SESSION['chat_boxes_opened'])) {
		$_SESSION['chat_boxes_opened'][] = $conversation['conversation_id'];
	}

	// return & exit
	return_json($return);

} catch (Exception $e) {
	modal(ERROR, __("Error"), $e->getMessage());
}

?>