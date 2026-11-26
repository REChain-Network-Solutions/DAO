<?php

/**
 * APIs -> modules -> chat -> controller
 *
 * @package Sngine
 * @author Zamblek
 */

// updateSeenStatus
function updateSeenStatus($req, $res)
{
  global $user;
  $user->update_conversation_seen_status($req->body['ids'], !empty($req->body['as_page']));
  apiResponse($res);
}


// updateTypingStatus
function updateTypingStatus($req, $res)
{
  global $user;
  $user->update_conversation_typing_status($req->body['conversation_id'], $req->body['is_typing'], !empty($req->body['as_page']));
  apiResponse($res);
}


// leaveConversation
function leaveConversation($req, $res)
{
  global $user;
  $user->leave_conversation($req->body['conversation_id']);
  apiResponse($res);
}


// renameConversation
function renameConversation($req, $res)
{
  global $user;
  $conversation = $user->rename_conversation($req->body['conversation_id'], $req->body['name'] ?? '');
  apiResponse($res, ['data' => $conversation]);
}


// addConversationUser
function addConversationUser($req, $res)
{
  global $user;
  $conversation = $user->add_conversation_user($req->body['conversation_id'], $req->body['user_id']);
  apiResponse($res, ['data' => $conversation]);
}


// removeConversationUser
function removeConversationUser($req, $res)
{
  global $user;
  $conversation = $user->remove_conversation_user($req->body['conversation_id'], $req->body['user_id']);
  apiResponse($res, ['data' => $conversation]);
}


// reactMessage
function reactMessage($req, $res)
{
  global $user;
  if ($req->body['do'] == 'react') {
    $user->react_message($req->body['message_id'], $req->body['reaction']);
  } elseif ($req->body['do'] == 'unreact') {
    $user->unreact_message($req->body['message_id'], $req->body['reaction']);
  }
  apiResponse($res);
}


// whoReacts
function whoReacts($req, $res)
{
  global $user;
  $return = $user->who_reacts([
    'message_id' => $req->query['message_id'],
    'reaction_type' => $req->query['reaction_type'],
    'offset' => $req->query['offset']
  ]);
  apiResponse($res, ['data' => $return['data'], 'has_more' => $return['has_more']]);
}


// getConversations
function getConversations($req, $res)
{
  global $user;
  $return = $user->get_conversations($req->query['offset'], $req->query['cursor'] ?? null);
  apiResponse($res, ['data' => $return['data'], 'has_more' => $return['has_more'], 'cursor' => $return['cursor']]);
}


// getPageConversations
function getPageConversations($req, $res)
{
  global $user;
  $return = $user->get_page_conversations($req->query['page_id'], $req->query['offset'] ?? 0, $req->query['cursor'] ?? null);
  apiResponse($res, ['data' => $return['data'], 'has_more' => $return['has_more'], 'cursor' => $return['cursor'], 'unseen_count' => $user->get_page_unseen_conversations_count($req->query['page_id'])]);
}


// getConversation
function getConversation($req, $res)
{
  global $user;
  $conversation = $user->check_mutual_conversation($req->query['conversation_id'], $req->query['user_id'], $req->query['page_id'] ?? null, !empty($req->query['as_page']));
  apiResponse($res, ['data' => $conversation]);
}


// deleteConversation
function deleteConversation($req, $res)
{
  global $user;
  $user->delete_conversation($req->params['id']);
  apiResponse($res);
}


// getMessages
function getMessages($req, $res)
{
  global $user;
  $return = [];
  $as_page = !empty($req->query['as_page']);
  $conversation = $user->get_conversation($req->query['conversation_id'], $as_page);
  if ($conversation) {
    $response = $user->get_conversation_messages($req->query['conversation_id'], $req->query['offset'], $req->query['last_message_id'], $as_page, $req->query['cursor'] ?? null);
    if ($response['messages']) {
      $return['messages'] = $response['messages'];
      $return['has_more'] = $response['has_more'];
      $return['cursor'] = $response['cursor'];
    }
    if ($conversation['typing_name_list']) {
      $return['typing_name_list'] = $conversation['typing_name_list'];
    }
    if ($conversation['seen_name_list']) {
      $return['seen_name_list'] = $conversation['seen_name_list'];
    }
    $return['user_is_online'] = $conversation['user_is_online'];
    $return['user_last_seen'] = $conversation['user_last_seen'];
  }
  apiResponse($res, ['data' => $return]);
}


// postMessage
function postMessage($req, $res)
{
  global $user;
  $args = [];
  $args['conversation_id'] = $req->body['conversation_id'];
  $args['message'] = $req->body['message'];
  $args['photo'] = $req->body['photo'];
  $args['video'] = $req->body['video'];
  $args['photos'] = $req->body['photos'] ?? null;
  $args['videos'] = $req->body['videos'] ?? null;
  $args['files'] = $req->body['files'] ?? null;
  $args['voice_note'] = $req->body['voice_note'];
  $args['recipients'] = $req->body['recipients'];
  $args['reply_to'] = $req->body['reply_to'] ?? null;
  $args['page_id'] = $req->body['page_id'] ?? null;
  $args['as_page'] = $req->body['as_page'] ?? null;
  $conversation = $user->post_conversation_message($args);
  apiResponse($res, ['data' => $conversation]);
}


// pinMessage
function pinMessage($req, $res)
{
  global $user;
  $conversation = $user->pin_conversation_message($req->body['message_id'], !empty($req->body['as_page']));
  apiResponse($res, ['data' => $conversation]);
}


// unpinMessage
function unpinMessage($req, $res)
{
  global $user;
  $conversation = $user->unpin_conversation_message($req->body['conversation_id'], !empty($req->body['as_page']));
  apiResponse($res, ['data' => $conversation]);
}


// deleteMessage
function deleteMessage($req, $res)
{
  global $user;
  $user->delete_conversation_message($req->params['id']);
  apiResponse($res);
}


// getCalls
function getCalls($req, $res)
{
  global $user;
  $return = $user->get_calls_history($req->query['offset']);
  apiResponse($res, ['data' => $return['data'], 'has_more' => $return['has_more']]);
}


// getContacts
function getContacts($req, $res)
{
  global $user;
  $args = [];
  $args['query'] = $req->query['query'] ?? '';
  $args['offset'] = $req->query['offset'] ?? 0;
  $args['skipped_ids'] = isset($req->query['skipped_ids']) ? array_filter(json_decode($req->query['skipped_ids'], true), 'is_numeric') : [];
  $return = $user->get_contacts($args);
  apiResponse($res, ['data' => $return['data'], 'has_more' => $return['has_more']]);
}
