<?php

/**
 * APIs -> modules -> chat -> router
 *
 * @package Sngine
 * @author Zamblek
 */

// get controller
require('modules/chat/controller.php');


# [post] actions [typing]
$app->post('/chat/actions/typing', function ($req, $res) {
  updateTypingStatus($req, $res);
});


# [post] actions [seen]
$app->post('/chat/actions/seen', function ($req, $res) {
  updateSeenStatus($req, $res);
});


// [post] actions [leave]
$app->post('/chat/actions/leave', function ($req, $res) {
  leaveConversation($req, $res);
});


// [post] actions [rename]
$app->post('/chat/actions/rename', function ($req, $res) {
  renameConversation($req, $res);
});


// [post] actions [add]
$app->post('/chat/actions/add', function ($req, $res) {
  addConversationUser($req, $res);
});


// [post] actions [remove]
$app->post('/chat/actions/remove', function ($req, $res) {
  removeConversationUser($req, $res);
});


// [post] actions [pin]
$app->post('/chat/actions/pin', function ($req, $res) {
  pinMessage($req, $res);
});


// [post] actions [unpin]
$app->post('/chat/actions/unpin', function ($req, $res) {
  unpinMessage($req, $res);
});


// [post] reactions [react]
$app->post('/chat/reactions/react', function ($req, $res) {
  reactMessage($req, $res);
});


# [get] reactions [who_reacts]
$app->get('/chat/reactions/who_reacts', function ($req, $res) {
  whoReacts($req, $res);
});


# [get] conversations
$app->get('/chat/conversations', function ($req, $res) {
  getConversations($req, $res);
});


# [get] page conversations
$app->get('/chat/page/conversations', function ($req, $res) {
  getPageConversations($req, $res);
});


# [get] conversation
$app->get('/chat/conversation', function ($req, $res) {
  getConversation($req, $res);
});


// [delete] conversation
$app->delete('/chat/conversation/[:id]', function ($req, $res) {
  deleteConversation($req, $res);
});


# [get] messages
$app->get('/chat/messages', function ($req, $res) {
  getMessages($req, $res);
});


# [post] message
$app->post('/chat/message', function ($req, $res) {
  postMessage($req, $res);
});


# [delete] message
$app->delete('/chat/message/[:id]', function ($req, $res) {
  deleteMessage($req, $res);
});


# [get] calls
$app->get('/chat/calls', function ($req, $res) {
  getCalls($req, $res);
});


# [get] contacts
$app->get('/chat/contacts', function ($req, $res) {
  getContacts($req, $res);
});
