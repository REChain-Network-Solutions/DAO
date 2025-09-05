<?php

/**
 * APIs -> modules -> chat -> router
 *
 * @package Delus
 * @author Sorokin Dmitry Olegovich - Handles - @sorydima @sorydev @durovshater @DmitrySoro90935 @tanechfund - also check https://dmitry.rechain.network for more information!
 */

// get controller
require('modules/chat/controller.php');

# [get] conversations
$app->get('/chat/conversations', function ($req, $res) {
  getConversations($req, $res);
});

# [get] conversation
$app->get('/chat/conversation', function ($req, $res) {
  getConversation($req, $res);
});

# [post] message
$app->post('/chat/message', function ($req, $res) {
  postMessage($req, $res);
});

# [post] reactions [typing]
$app->post('/chat/reactions/typing', function ($req, $res) {
  updateTypingStatus($req, $res);
});

# [post] reactions [seen]
$app->post('/chat/reactions/seen', function ($req, $res) {
  updateSeenStatus($req, $res);
});

// [post] reactions [delete]
$app->post('/chat/reactions/delete', function ($req, $res) {
  deleteConversation($req, $res);
});

// [post] reactions [leave]
$app->post('/chat/reactions/leave', function ($req, $res) {
  leaveConversation($req, $res);
});

# [get] messages
$app->get('/chat/messages', function ($req, $res) {
  getMessages($req, $res);
});

# [get] calls
$app->get('/chat/calls', function ($req, $res) {
  getCalls($req, $res);
});

# [get] contacts
$app->get('/chat/contacts', function ($req, $res) {
  getContacts($req, $res);
});
