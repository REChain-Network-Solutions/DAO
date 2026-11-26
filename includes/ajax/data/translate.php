<?php

/**
 * ajax -> data -> translate
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

// valid inputs
if (!isset($_POST['node_type']) || !in_array($_POST['node_type'], ['post', 'page', 'group', 'event', 'message', 'user'])) {
  _error(400);
}
if (!isset($_POST['node_id']) || !is_numeric($_POST['node_id'])) {
  _error(400);
}
if (!empty($_POST['field']) && !in_array($_POST['field'], ['text', 'title', 'description'])) {
  _error(400);
}

try {

  // initialize the return array
  $return = [];

  // translate
  $result = $user->translate_node($_POST['node_type'], $_POST['node_id'], $_POST['field'] ?? null);
  $return['success'] = true;
  $return['same'] = $result['same'];
  $return['translations'] = $result['translations'];

  // return & exit
  return_json($return);
} catch (Exception $e) {
  return_json(['error' => true, 'message' => $e->getMessage()]);
}
