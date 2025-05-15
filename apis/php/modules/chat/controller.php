<?php

/**
 * APIs -> modules -> chat -> controller
 *
 * @package Delus
 * @author Dmitry Sorokin - @sorydima & @sorydev Handles. 
 */

// getConversations
function getConversations($req, $res)
{
  global $user;
  $return = $user->get_conversations($req->query['offset']);
  apiResponse($res, ['data' => $return['data'], 'has_more' => $return['has_more']]);
}

// getConversation
function getConversation($req, $res)
{
  global $user;
  $conversation = $user->check_mutual_conversation($req->query['conversation_id'], $req->query['user_id']);
  apiResponse($res, ['data' => $conversation]);
}

// postMessage
function postMessage($req, $res)
{
  global $user;
  $args = [];
  $args['conversation_id'] = $req->body['conversation_id'];
  $args['message'] = $req->body['message'];
  $args['photo'] = $req->body['photo'];
  $args['voice_note'] = $req->body['voice_note'];
  $args['recipients'] = $req->body['recipients'];
  $conversation = $user->post_conversation_message($args);
  apiResponse($res, ['data' => $conversation]);
}

// updateTypingStatus
function updateTypingStatus($req, $res)
{
  global $user;
  $user->update_conversation_typing_status($req->body['conversation_id'], $req->body['is_typing']);
  apiResponse($res);
}

// updateSeenStatus
function updateSeenStatus($req, $res)
{
  global $user;
  $user->update_conversation_seen_status($req->body['ids']);
  apiResponse($res);
}

// deleteConversation
function deleteConversation($req, $res)
{
  global $user;
  $user->delete_conversation($req->body['conversation_id']);
  apiResponse($res);
}

// leaveConversation
function leaveConversation($req, $res)
{
  global $user;
  $user->leave_conversation($req->body['conversation_id']);
  apiResponse($res);
}

// getMessages
function getMessages($req, $res)
{
  global $user;
  $return = [];
  $conversation = $user->get_conversation($req->query['conversation_id']);
  if ($conversation) {
    $response = $user->get_conversation_messages($req->query['conversation_id'], $req->query['offset'], $req->query['last_message_id']);
    if ($response['messages']) {
      $return['messages'] = $response['messages'];
      $return['has_more'] = $response['has_more'];
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
