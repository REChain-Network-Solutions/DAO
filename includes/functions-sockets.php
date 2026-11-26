<?php

/**
 * functions -> sockets
 * 
 * @package Sngine
 * @author Zamblek
 */

/* ------------------------------- */
/* Socket.io */
/* ------------------------------- */

/**
 * socket_certificate_test
 * 
 * @return bool
 */
function socket_certificate_test()
{
  global $system;
  $certificate_path = $system['chat_socket_ssl_crt'] ?? null;
  $key_path = $system['chat_socket_ssl_key'] ?? null;
  if (!$certificate_path || !$key_path) {
    throw new Exception(__("Certificate or key path is not configured"));
  }
  if (!file_exists($certificate_path)) {
    throw new Exception(sprintf(__("Certificate file not found: %s"), $certificate_path));
  }
  if (!file_exists($key_path)) {
    throw new Exception(sprintf(__("Key file not found: %s"), $key_path));
  }
  if (!is_readable($certificate_path)) {
    throw new Exception(sprintf(__("Certificate file not readable: %s"), $certificate_path));
  }
  if (!is_readable($key_path)) {
    throw new Exception(sprintf(__("Key file not readable: %s"), $key_path));
  }
  return true;
}


/**
 * socket_io_action
 * 
 * @param string $action
 * @return string
 */
function socket_io_action($action)
{
  global $system;
  if ($system['chat_socket_server'] == 'nodejs') {
    $bin_path = $system['nodejs_bin_path'] ?: 'node';
    $script_path = __DIR__ . '/../sockets/node/socket.js';
  } else {
    $bin_path = $system['php_bin_path'] ?: 'php';
    $script_path = __DIR__ . '/../sockets/php/socket.php';
  }
  $bin_path = escapeshellarg($bin_path);
  $script_path = escapeshellarg($script_path);
  switch ($action) {
    case 'status':
      $response = shell_exec("$bin_path $script_path status 2>&1");
      break;
    case 'start':
      $response = shell_exec("$bin_path $script_path start -d 2>&1");
      break;
    case 'stop':
      $response = shell_exec("$bin_path $script_path stop 2>&1");
      break;
    case 'restart':
      /* restart only if running */
      $response = shell_exec("$bin_path $script_path status 2>&1");
      if (stripos((string) $response, 'not run') === false) {
        shell_exec("$bin_path $script_path stop 2>&1");
        $response = shell_exec("$bin_path $script_path start -d 2>&1");
      }
      break;
  }
  return $response;
}


/**
 * get_all_sockets_user_ids
 * 
 * @param object $io
 * @return array
 */
function get_all_sockets_user_ids($io)
{
  return array_unique(array_column($io->sockets->sockets, 'userId')) ?? [];
}


/**
 * get_all_sockets_by_user_id
 * 
 * @param object $io
 * @param int $user_id
 * @return array
 */
function get_all_sockets_by_user_id($io, $user_id)
{
  $sockets = [];
  foreach ($io->sockets->sockets as $socketId => $socket) {
    if (isset($socket->userId) && $socket->userId == $user_id) {
      $sockets[$socketId] = $socket;
    }
  }
  return $sockets;
}


/**
 * handle_typing_change
 * 
 * @param object $io
 * @param string $room
 * @param object $socket
 * @param object $user
 * @param boolean $is_typing
 * @param boolean $as_page
 * @return void
 */
function handle_typing_change($io, $room, $socket, $user, $is_typing, $as_page = false)
{
  $conversation_id = str_replace('conversation_', '', $room);
  $user_display_name = html_entity_decode(($GLOBALS['system']['show_usernames_enabled']) ? $user->_data['user_name'] : $user->_data['user_firstname'],    ENT_QUOTES);
  if ($as_page) {
    /* page inbox -> type as the page */
    $page_id = $user->check_page_conversation_access($conversation_id);
    $page = ($page_id) ? $user->get_chat_page($page_id) : false;
    if (!$page) {
      return;
    }
    $user_display_name = html_entity_decode($page['page_title'], ENT_QUOTES);
  }
  init_room_typing_list($room);
  if ($is_typing) {
    add_typing_user($room, $socket->userId, $user_display_name);
  } else {
    remove_typing_user($room, $socket->userId);
  }
  /* broadcast typing list to other users in the room */
  $room_clients = $io->sockets->in($room)->sockets;
  foreach ($room_clients as $client) {
    if (!isset($client->userId)) continue;
    $other_typing_users = array_diff_key($GLOBALS['room_typing_list'][$room], [$client->userId => null]);
    $typing_name_list = implode(', ', $other_typing_users);
    $client->emit('event_server_typing', [
      'conversation_id' => $conversation_id,
      'typing_name_list' => $typing_name_list
    ]);
  }
  print("💬 [Emit] User {username: {$socket->username}, user_id: {$socket->userId}} Room: $room - Typing: " . ($is_typing ? 'true' : 'false') . "\n");
  /* cleanup empty room typing list */
  cleanup_empty_room_typing_list($room);
  /* update typing status */
  $user->update_conversation_typing_status($conversation_id, $is_typing, $as_page);
}


/**
 * init_room_typing_list
 * 
 * @param string $room
 * @return void
 */
function init_room_typing_list($room)
{
  if (!isset($GLOBALS['room_typing_list'][$room])) {
    $GLOBALS['room_typing_list'][$room] = [];
  }
}


/**
 * add_typing_user
 * 
 * @param string $room
 * @param int $user_id
 * @param string $user_display_name
 * @return void
 */
function add_typing_user($room, $user_id, $user_display_name)
{
  if (!isset($GLOBALS['room_typing_list'][$room][$user_id])) {
    $GLOBALS['room_typing_list'][$room][$user_id] = $user_display_name;
  }
}


/**
 * remove_typing_user
 * 
 * @param string $room
 * @param int $user_id
 * @return void
 */
function remove_typing_user($room, $user_id)
{
  if (isset($GLOBALS['room_typing_list'][$room][$user_id])) {
    unset($GLOBALS['room_typing_list'][$room][$user_id]);
  }
}


/**
 * cleanup_empty_room_typing_list
 * 
 * @param string $room
 * @return void
 */
function cleanup_empty_room_typing_list($room)
{
  if (empty($GLOBALS['room_typing_list'][$room])) {
    unset($GLOBALS['room_typing_list'][$room]);
  }
}


/**
 * cleanup_user_typing_list
 * 
 * @param object $socket
 * @return array
 */
function cleanup_user_typing_list($socket)
{
  $affected_rooms = [];
  /* get only conversation rooms */
  $conversation_rooms = array_filter($socket->rooms, function ($room) {
    return strpos($room, 'conversation_') === 0;
  });
  /* filter only the typing rooms that match conversation rooms */
  $typing_rooms = array_intersect_key($GLOBALS['room_typing_list'], array_flip($conversation_rooms));
  /* get all rooms that the user is typing in */
  foreach ($typing_rooms as $room => &$typing_users) {
    if (isset($typing_users[$socket->userId])) {
      $affected_rooms[] = $room;
    }
  }
  return $affected_rooms;
}
