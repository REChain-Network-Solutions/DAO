<?php

/**
 * sockets -> php -> socket
 * 
 * @package Sngine
 * @author Zamblek
 */

// define skip unusual login
define('SKIP_UNUSUAL_LOGIN_CHECK', true);

// fetch bootstrap
require('loader.php');

$GLOBALS['room_typing_list'] = [];

// init socket.io
if (!$system['chat_socket_proxied']) {
  $ssl_options = [
    'ssl' => [
      'local_cert'  => $system['chat_socket_ssl_crt'],
      'local_pk'    => $system['chat_socket_ssl_key'],
      'verify_peer' => ($system['chat_socket_ssl_verify_peer']) ? true : false,
      'allow_self_signed' => ($system['chat_socket_ssl_allow_self_signed']) ? true : false,
    ]
  ];
  $io = new PHPSocketIO\SocketIO($system['chat_socket_port'], $ssl_options);
} else {
  $io = new PHPSocketIO\SocketIO($system['chat_socket_port']);
}


// on connection
$io->on('connection', function ($socket) use ($io) {

  // log connection
  print("✅ Client Connected: " . $socket->id . "\n");

  // init new db connection
  try {
    global $db;
    $db = init_db_connection();
  } catch (Exception $e) {
    $socket->emit('event_server_error', ['message' => 'DB Connection Error']);
    print("❌ DB Connection Error: " . $e->getMessage() . "\n");
    return;
  }

  // handle handshake
  $jwt = $socket->handshake['query']['jwt'] ?? null;
  if (!$jwt) {
    $socket->emit('event_server_error', ['message' => '❌ Invalid Client JWT']);
    print("❌ Invalid Client JWT\n");
    return;
  }

  // get user data
  try {
    $user = new User($jwt);
  } catch (Exception $e) {
    $socket->emit('event_server_error', ['message' => $e->getMessage()]);
    print("❌ User Authentication Error: " . $e->getMessage() . "\n");
    return;
  }
  $socket->userId = $user->_data['user_id'];
  $socket->username = $user->_data['user_name'];
  print("👤 User {username: {$socket->username}, user_id: {$socket->userId}} Attached Socket: {$socket->id}\n");

  // join user own room
  $socket->join($socket->userId);
  print("🏠 User {username: {$socket->username}, user_id: {$socket->userId}} Joined Own Room\n");

  // [emit] welcome
  $socket->emit('event_server_welcome', ['message' => '👋 ' . $user->_data['user_name'] . '!']);

  // [emit] user online
  $online_friends_ids = array_intersect($user->get_friends_or_followings_ids(), get_all_sockets_user_ids($io));
  foreach ($online_friends_ids as $online_friend_id) {
    $friend_sockets = get_all_sockets_by_user_id($io, $online_friend_id);
    foreach ($friend_sockets as $friend_socket) {
      $friend_socket->emit('event_server_user_online', [
        'user_id'        => $user->_data['user_id'],
        'user_fullname'  => $user->_data['user_fullname'],
        'user_name'      => $user->_data['user_name'],
        'user_picture'   => $user->_data['user_picture'],
        'user_last_seen' => $user->_data['user_last_seen'],
        'user_is_online' => true,
      ]);
      print("🔄 [Emit] User {username: {$socket->username}, user_id: {$socket->userId}} 🟢 Online\n");
    }
  }

  // [listen] disconnect
  $socket->on('disconnect', function () use ($io, $socket, $user) {
    print("🛑 Client Disconnected: " . $socket->id . "\n");
    print("❌ User {username: {$socket->username}, user_id: {$socket->userId}} Detached Socket: {$socket->id}\n");
    /* broadcast to all online friends */
    $online_friends_ids = array_intersect($user->get_friends_or_followings_ids(), get_all_sockets_user_ids($io));
    foreach ($online_friends_ids as $online_friend_id) {
      $friend_sockets = get_all_sockets_by_user_id($io, $online_friend_id);
      foreach ($friend_sockets as $friend_socket) {
        $friend_socket->emit('event_server_user_offline', [
          'user_id'        => $user->_data['user_id'],
          'user_fullname'  => $user->_data['user_fullname'],
          'user_name'      => $user->_data['user_name'],
          'user_picture'   => $user->_data['user_picture'],
          'user_last_seen' => $user->_data['user_last_seen'],
          'user_is_online' => false,
        ]);
        print("🔄 [Emit] User {username: {$socket->username}, user_id: {$socket->userId}} 🔴 Offline\n");
      }
    }
    /* cleanup user typing list */
    $affected_rooms = cleanup_user_typing_list($socket);
    foreach ($affected_rooms as $room) {
      handle_typing_change($io, $room, $socket, $user, false, isset($socket->pageRooms[$room]));
    }
  });

  // [listen] ping
  $socket->on('event_client_ping', function () use ($io, $socket, $user) {
    // print("🔄 User {username: {$socket->username}, user_id: {$socket->userId}} 🏓 Pinged\n");
    /* broadcast to all online friends */
    $online_friends_ids = array_intersect($user->get_friends_or_followings_ids(), get_all_sockets_user_ids($io));
    foreach ($online_friends_ids as $online_friend_id) {
      $friend_sockets = get_all_sockets_by_user_id($io, $online_friend_id);
      foreach ($friend_sockets as $friend_socket) {
        $friend_socket->emit('event_server_user_online', [
          'user_id'        => $user->_data['user_id'],
          'user_fullname'  => $user->_data['user_fullname'],
          'user_name'      => $user->_data['user_name'],
          'user_picture'   => $user->_data['user_picture'],
          'user_last_seen' => $user->_data['user_last_seen'],
          'user_is_online' => true,
        ]);
        // print("🔄 [Emit] User {username: {$socket->username}, user_id: {$socket->userId}} 🟢 Online\n");
      }
    }
  });

  // [listen] chat toggle
  $socket->on('event_client_chat_toggle', function ($data) use ($io, $socket, $user) {
    /* broadcast to all user sockets */
    $socket->broadcast->to($socket->userId)->emit('event_server_chat_toggle', [
      'user_chat_enabled' => $data['user_chat_enabled']
    ]);
    print("🔄 [Emit] User {username: {$socket->username}, user_id: {$socket->userId}} Turned Active Status: " . ($data['user_chat_enabled'] == 0 ? 'OFF' : 'ON') . "\n");
    /* update user settings */
    try {
      $user->settings('chat', $data);
    } catch (Exception $e) {
      $socket->emit('event_server_error', ['message' => $e->getMessage(), 'modal' => true]);
      print("❌ Error: " . $e->getMessage() . "\n");
      return;
    }
  });

  // [listen] open thread
  $socket->on('event_client_open_thread', function ($data) use ($io, $socket, $user) {
    /* join the conversation room */
    $room = 'conversation_' . $data['conversation_id'];
    if (!empty($data['as_page'])) {
      /* page inbox */
      if (!$user->check_page_conversation_access($data['conversation_id'])) {
        return;
      }
      $page_rooms = $socket->pageRooms ?? [];
      $page_rooms[$room] = true;
      $socket->pageRooms = $page_rooms;
    }
    $socket->join($room);
    print("👋 {username: {$socket->username}, user_id: {$socket->userId}} Joined Thread: $room\n");
  });

  // [listen] open chat box
  $socket->on('event_client_open_chatbox', function ($data) use ($io, $socket, $user) {
    /* join the conversation room */
    $room = 'conversation_' . $data['conversation_id'];
    $socket->join($room);
    print("👋 {username: {$socket->username}, user_id: {$socket->userId}} Joined Room: $room\n");
    /* broadcast to all user sockets */
    $socket->broadcast->to($socket->userId)->emit('event_server_chatbox_opened', $data);
    print("🔄 [Emit] User {username: {$socket->username}, user_id: {$socket->userId}} Opened Chatbox Room: $room\n");
  });

  // [listen] close chat box
  $socket->on('event_client_close_chatbox', function ($data) use ($io, $socket, $user) {
    /* leave the conversation room */
    $room = 'conversation_' . $data['conversation_id'];
    $socket->leave($room);
    print("✌️ {username: {$socket->username}, user_id: {$socket->userId}} Left Room: $room\n");
    /* broadcast to all user sockets */
    $socket->broadcast->to($socket->userId)->emit('event_server_chatbox_closed', $data);
    print("🔄 [Emit] User {username: {$socket->username}, user_id: {$socket->userId}} Closed Chatbox Room: $room\n");
  });

  // [listen] delete conversation
  $socket->on('event_client_delete_conversation', function ($data) use ($io, $socket, $user) {
    /* leave the conversation room */
    $room = 'conversation_' . $data['conversation_id'];
    $socket->leave($room);
    print("✌️ {username: {$socket->username}, user_id: {$socket->userId}} Left Room: $room\n");
    /* broadcast to all user sockets */
    $socket->broadcast->to($room)->emit('event_server_delete_conversation', $data);
    print("🔄 [Emit] {username: {$socket->username}, user_id: {$socket->userId}} Deleted Conversation: $room\n");
    /* delete converstaion */
    try {
      $user->delete_conversation($data['conversation_id']);
    } catch (Exception $e) {
      $socket->emit('event_server_error', ['message' => $e->getMessage(), 'modal' => true]);
      print("❌ Error: " . $e->getMessage() . "\n");
      return;
    }
  });

  // [listen] leave conversation
  $socket->on('event_client_leave_conversation', function ($data) use ($io, $socket, $user) {
    /* leave the conversation room */
    $room = 'conversation_' . $data['conversation_id'];
    $socket->leave($room);
    print("✌️ {username: {$socket->username}, user_id: {$socket->userId}} Left Room: $room\n");
    /* broadcast to all user sockets */
    $socket->broadcast->to($room)->emit('event_server_leave_conversation', $data);
    print("🔄 [Emit] {username: {$socket->username}, user_id: {$socket->userId}} Left Conversation: $room\n");
    /* leave conversation */
    try {
      $user->leave_conversation($data['conversation_id']);
    } catch (Exception $e) {
      $socket->emit('event_server_error', ['message' => $e->getMessage(), 'modal' => true]);
      print("❌ Error: " . $e->getMessage() . "\n");
      return;
    }
  });

  // [listen] get conversation
  $socket->on('event_client_get_conversation', function ($data, $callback) use ($io, $socket, $user) {
    /* get conversation */
    try {
      $conversation = $user->get_conversation($data['conversation_id'], !empty($data['as_page']));
    } catch (Exception $e) {
      $socket->emit('event_server_error', ['message' => $e->getMessage(), 'modal' => true]);
      print("❌ Error: " . $e->getMessage() . "\n");
      return;
    }
    /* callback */
    $callback(json_encode($conversation));
  });

  // [listen] send message
  $socket->on('event_client_send_message', function ($data, $callback) use ($io, $socket, $user) {
    global $smarty;
    try {
      $conversation = $user->post_conversation_message($data, true);
      /* nothing to send (product already shared) */
      if (!$conversation) {
        if (is_callable($callback)) {
          $callback(json_encode(null));
        }
        return;
      }
      /* send message */
      print("✉️ User {username: {$socket->username}, user_id: {$socket->userId}} Sent Message To Conversation: " . $conversation['conversation_id'] . "\n");
    } catch (Exception $e) {
      $socket->emit('event_server_error', ['message' => $e->getMessage(), 'modal' => true]);
      print("❌ Error: " . $e->getMessage() . "\n");
      return;
    }
    /* prepare message */
    $message_id = $conversation['last_message']['message_id'];
    $smarty->assign('user', $user);
    $smarty->assign('conversation', $conversation);
    $smarty->assign('message', $conversation['last_message']);
    $smarty->assign('is_me', true);
    $last_message_for_me = $smarty->fetch("__feeds_message.tpl");
    $smarty->assign('is_me', false);
    $last_message_for_recipient = $smarty->fetch("__feeds_message.tpl");
    /* page conversation */
    if (!empty($conversation['page_id'])) {
      emit_page_message($io, $socket, $user, $conversation, $last_message_for_me, $last_message_for_recipient);
      /* callback */
      $conversation['last_message_html'] = $last_message_for_me;
      $callback(json_encode($conversation));
      return;
    }
    /* broadcast to all online recipients */
    $recipient_ids = array_column($conversation['recipients'], 'user_id');
    $online_recipient_ids = array_intersect($recipient_ids, get_all_sockets_user_ids($io));
    foreach ($online_recipient_ids as $recipient_id) {
      $recipientSockets = get_all_sockets_by_user_id($io, $recipient_id);
      if (empty($recipientSockets)) {
        continue;
      }
      foreach ($recipientSockets as $recipientSocket) {
        $recipientSocket->emit('event_server_message_received', [
          'conversation' => $conversation,
          'last_message' => $last_message_for_recipient,
          'is_me' => false,
        ]);
        print("🔄 [Emit] User {username: {$socket->username}, user_id: {$socket->userId}} Message Sent To: {$recipientSocket->username}\n");
      }
    }
    /* broadcast to all user sockets */
    $socket->broadcast->to($socket->userId)->emit('event_server_message_received', [
      'conversation' => $conversation,
      'last_message' => $last_message_for_me,
      'is_me' => true,
    ]);
    print("🔄 [Emit] User {username: {$socket->username}, user_id: {$socket->userId}} Message Sent To: {$socket->username}\n");
    /* callback */
    $conversation['last_message_html'] = $last_message_for_me;
    $callback(json_encode($conversation));
  });

  // [listen] send paid message
  $socket->on('event_client_send_paid_message', function ($data, $callback) use ($io, $socket, $user) {
    global $smarty;
    try {
      $conversation = $user->post_conversation_paid_message($data, true);
      /* send message */
      print("💰 User {username: {$socket->username}, user_id: {$socket->userId}} Sent Paid Message To Conversation: " . $conversation['conversation_id'] . "\n");
    } catch (ValidationException $e) {
      $callback(json_encode(['error' => true, 'message' => $e->getMessage()]));
      print("❌ Validation Error: " . $e->getMessage() . "\n");
      return;
    } catch (Exception $e) {
      $socket->emit('event_server_error', ['message' => $e->getMessage(), 'modal' => true]);
      print("❌ Error: " . $e->getMessage() . "\n");
      return;
    }
    /* prepare message */
    $message_id = $conversation['last_message']['message_id'];
    $smarty->assign('user', $user);
    $smarty->assign('conversation', $conversation);
    $smarty->assign('message', $conversation['last_message']);
    $smarty->assign('is_me', true);
    $last_message_for_me = $smarty->fetch("__feeds_message.tpl");
    /* broadcast to all online recipients */
    $recipient_ids = array_column($conversation['recipients'], 'user_id');
    $online_recipient_ids = array_intersect($recipient_ids, get_all_sockets_user_ids($io));
    foreach ($online_recipient_ids as $recipient_id) {
      $recipientSockets = get_all_sockets_by_user_id($io, $recipient_id);
      if (empty($recipientSockets)) {
        continue;
      }
      /* render the paid message gated for this specific recipient */
      $recipient_message = $user->get_conversation_message_by_id($message_id, $recipient_id);
      $smarty->assign('user', $user);
      $smarty->assign('conversation', $conversation);
      $smarty->assign('message', $recipient_message);
      $smarty->assign('is_me', false);
      $last_message_for_recipient = $smarty->fetch("__feeds_message.tpl");
      foreach ($recipientSockets as $recipientSocket) {
        $recipientSocket->emit('event_server_message_received', [
          'conversation' => $conversation,
          'last_message' => $last_message_for_recipient,
          'is_me' => false,
        ]);
        print("🔄 [Emit] User {username: {$socket->username}, user_id: {$socket->userId}} Paid Message Sent To: {$recipientSocket->username}\n");
      }
    }
    /* broadcast to all user sockets */
    $socket->broadcast->to($socket->userId)->emit('event_server_message_received', [
      'conversation' => $conversation,
      'last_message' => $last_message_for_me,
      'is_me' => true,
    ]);
    print("🔄 [Emit] User {username: {$socket->username}, user_id: {$socket->userId}} Paid Message Sent To: {$socket->username}\n");
    /* callback */
    $conversation['last_message_html'] = $last_message_for_me;
    $callback(json_encode($conversation));
  });

  // [listen] typing
  $socket->on('event_client_typing', function ($data) use ($io, $socket, $user) {
    handle_typing_change($io, 'conversation_' . $data['conversation_id'], $socket, $user, $data['is_typing'], !empty($data['as_page']));
  });

  // [listen] seen
  $socket->on('event_client_seen', function ($data) use ($io, $socket, $system, $user) {
    /* broadcast to all user sockets */
    $conversation_id = $data['ids'][0];
    $room = 'conversation_' . $conversation_id;
    $as_page = !empty($data['as_page']);
    if ($as_page) {
      /* page inbox */
      $page_id = $user->check_page_conversation_access($conversation_id);
      $page = ($page_id) ? $user->get_chat_page($page_id) : false;
      if ($page && $system['chat_seen_enabled']) {
        $socket->broadcast->to($room)->emit('event_server_seen', [
          'conversation_id' => $conversation_id,
          'seen_name_list' => $page['page_title'],
        ]);
      }
    } elseif (!$user->check_page_conversation_access($conversation_id)) {
      $socket->broadcast->to($room)->emit('event_server_seen', [
        'conversation_id' => $conversation_id,
        'seen_name_list' => ($system['show_usernames_enabled']) ? $user->_data['user_name'] : $user->_data['user_firstname'],
      ]);
    }
    print("👁️ [Emit] User {username: {$socket->username}, user_id: {$socket->userId}} Room: $room - Seen: true\n");
    /* update seen status */
    try {
      $user->update_conversation_seen_status((array)$data['ids'], $as_page);
    } catch (Exception $e) {
      $socket->emit('event_server_error', ['message' => $e->getMessage(), 'modal' => true]);
      print("❌ Error: " . $e->getMessage() . "\n");
      return;
    }
  });

  // [listen] react message
  $socket->on('event_client_react_message', function ($data, $callback) use ($io, $socket, $user) {
    try {
      if (($data['do'] ?? 'react') == 'unreact') {
        $user->unreact_message($data['message_id'], $data['reaction']);
      } else {
        $user->react_message($data['message_id'], $data['reaction']);
      }
      $message = $user->get_conversation_message_by_id($data['message_id']);
      $payload = [
        'conversation_id' => $message['conversation_id'],
        'message_id' => $message['message_id'],
        'user_id' => ($user->check_page_conversation_access($message['conversation_id'])) ? 0 : $user->_data['user_id'],
        'reactions' => $message['reactions'],
        'reactions_total_count' => $message['reactions_total_count'],
        'reactions_total_count_formatted' => $message['reactions_total_count_formatted'],
      ];
      emit_to_members($io, $user->get_conversation_members_ids($message['conversation_id']), 'event_server_message_reacted', $payload);
      $payload['i_react'] = $message['i_react'];
      $payload['i_reaction'] = $message['i_reaction'] ?? null;
      if (is_callable($callback)) {
        $callback(json_encode($payload));
      }
    } catch (Exception $e) {
      $socket->emit('event_server_error', ['message' => $e->getMessage(), 'modal' => true]);
      print("❌ Error: " . $e->getMessage() . "\n");
    }
  });

  // [listen] delete message
  $socket->on('event_client_delete_message', function ($data, $callback) use ($io, $socket, $user) {
    try {
      $message = $user->get_conversation_message_by_id($data['message_id']);
      if (!$message) {
        throw new AuthorizationException(__("You are not authorized to do this"));
      }
      $conversation_id = $message['conversation_id'];
      $member_ids = $user->get_conversation_members_ids($conversation_id);
      $user->delete_conversation_message($data['message_id']);
      $payload = [
        'conversation_id' => $conversation_id,
        'message_id' => $data['message_id'],
      ];
      emit_to_members($io, $member_ids, 'event_server_message_deleted', $payload);
      if (is_callable($callback)) {
        $callback(json_encode($payload));
      }
    } catch (Exception $e) {
      $socket->emit('event_server_error', ['message' => $e->getMessage(), 'modal' => true]);
      print("❌ Error: " . $e->getMessage() . "\n");
    }
  });

  // [listen] pin message
  $socket->on('event_client_pin_message', function ($data, $callback) use ($io, $socket, $user) {
    global $smarty;
    try {
      if (($data['do'] ?? 'pin') == 'unpin') {
        $conversation = $user->unpin_conversation_message($data['conversation_id'], !empty($data['as_page']));
      } else {
        $conversation = $user->pin_conversation_message($data['message_id'], !empty($data['as_page']));
      }
      $smarty->assign('conversation', $conversation);
      $payload = [
        'conversation_id' => $conversation['conversation_id'],
        'pinned_message' => $conversation['pinned_message'],
        'pin_html' => $smarty->fetch("__chat_pin.tpl"),
      ];
      emit_to_members($io, $user->get_conversation_members_ids($conversation['conversation_id']), 'event_server_message_pinned', $payload);
      if (is_callable($callback)) {
        $callback(json_encode($payload));
      }
    } catch (Exception $e) {
      $socket->emit('event_server_error', ['message' => $e->getMessage(), 'modal' => true]);
      print("❌ Error: " . $e->getMessage() . "\n");
    }
  });

  // [listen] color
  $socket->on('event_client_color', function ($data) use ($io, $socket, $user) {
    /* broadcast to all user sockets */
    $room = 'conversation_' . $data['conversation_id'];
    $socket->broadcast->to($room)->emit('event_server_color', [
      'conversation_id' => $data['conversation_id'],
      'color' => $data['color']
    ]);
    print("🎨 [Emit] User {username: {$socket->username}, user_id: {$socket->userId}} Room: $room - Color: " . $data['color'] . "\n");
    /* set conversation color */
    try {
      $user->set_conversation_color($data['conversation_id'], $data['color']);
    } catch (Exception $e) {
      $socket->emit('event_server_error', ['message' => $e->getMessage(), 'modal' => true]);
      print("❌ Error: " . $e->getMessage() . "\n");
      return;
    }
  });

  // [listen] rename conversation
  $socket->on('event_client_conversation_rename', function ($data, $callback) use ($io, $socket, $user) {
    try {
      $conversation = $user->rename_conversation($data['conversation_id'], $data['name'] ?? '');
      $payload = [
        'conversation_id' => $conversation['conversation_id'],
        'conversation' => $conversation,
      ];
      emit_conversation_updated($io, conversation_member_ids($conversation, $user->_data['user_id']), $payload);
      print("✏️ [Emit] {username: {$socket->username}, user_id: {$socket->userId}} Renamed Conversation: conversation_{$conversation['conversation_id']}\n");
      if (is_callable($callback)) {
        $callback(json_encode($payload));
      }
    } catch (Exception $e) {
      $socket->emit('event_server_error', ['message' => $e->getMessage(), 'modal' => true]);
      print("❌ Error: " . $e->getMessage() . "\n");
      return;
    }
  });

  // [listen] add conversation user
  $socket->on('event_client_conversation_add', function ($data, $callback) use ($io, $socket, $user) {
    try {
      $conversation = $user->add_conversation_user($data['conversation_id'], $data['user_id']);
      $payload = [
        'conversation_id' => $conversation['conversation_id'],
        'conversation' => $conversation,
        'added_user_id' => $data['user_id'],
      ];
      $member_ids = conversation_member_ids($conversation, $user->_data['user_id']);
      $member_ids[] = $data['user_id'];
      emit_conversation_updated($io, $member_ids, $payload);
      print("➕ [Emit] {username: {$socket->username}, user_id: {$socket->userId}} Added User {$data['user_id']} To Conversation: conversation_{$conversation['conversation_id']}\n");
      if (is_callable($callback)) {
        $callback(json_encode($payload));
      }
    } catch (Exception $e) {
      $socket->emit('event_server_error', ['message' => $e->getMessage(), 'modal' => true]);
      print("❌ Error: " . $e->getMessage() . "\n");
      return;
    }
  });

  // [listen] remove conversation user
  $socket->on('event_client_conversation_remove', function ($data, $callback) use ($io, $socket, $user) {
    try {
      $conversation = $user->get_conversation($data['conversation_id']);
      if (!$conversation) {
        throw new AuthorizationException(__("You are not authorized to do this"));
      }
      $member_ids = conversation_member_ids($conversation, $user->_data['user_id']);
      $member_ids[] = $data['user_id'];
      $updated = $user->remove_conversation_user($data['conversation_id'], $data['user_id']);
      $payload = [
        'conversation_id' => $data['conversation_id'],
        'conversation' => $updated ?: null,
        'removed_user_id' => $data['user_id'],
      ];
      emit_conversation_updated($io, $member_ids, $payload);
      print("➖ [Emit] {username: {$socket->username}, user_id: {$socket->userId}} Removed User {$data['user_id']} From Conversation: conversation_{$data['conversation_id']}\n");
      if (is_callable($callback)) {
        $callback(json_encode($payload));
      }
    } catch (Exception $e) {
      $socket->emit('event_server_error', ['message' => $e->getMessage(), 'modal' => true]);
      print("❌ Error: " . $e->getMessage() . "\n");
      return;
    }
  });

  // [listen] create call (caller)
  $socket->on('event_client_create_call', function ($data, $callback) use ($io, $socket, $user) {
    /* check if receiver is online */
    $receiver_sockets = get_all_sockets_by_user_id($io, $data['id']);
    if (!empty($receiver_sockets)) {
      /* create call */
      try {
        $call = $user->create_call($data['type'], $data['id']);
        print("📞 User {username: {$socket->username}, user_id: {$socket->userId}} Created Call: {$call['call_id']}\n");
      } catch (Exception $e) {
        $socket->emit('event_server_error', ['message' => $e->getMessage(), 'modal' => true]);
        print("❌ Error: " . $e->getMessage() . "\n");
        return;
      }
      /* broadcast to all receiver sockets */
      foreach ($receiver_sockets as $receiver_socket) {
        $receiver_socket->emit('event_server_call_received', $call);
      }
    } else {
      $call = "recipient_offline";
    }
    /* callback */
    $callback(json_encode($call));
  });

  // [listen] call canceled (caller)
  $socket->on('event_client_cancel_call', function ($data) use ($io, $socket, $user) {
    /* decline call */
    try {
      $call = $user->decline_call($data['id']);
      print("📞 User {username: {$socket->username}, user_id: {$socket->userId}} Canceled Call: {$call['call_id']}\n");
    } catch (Exception $e) {
      $socket->emit('event_server_error', ['message' => $e->getMessage(), 'modal' => true]);
      print("❌ Error: " . $e->getMessage() . "\n");
      return;
    }
    /* broadcast to all receiver sockets */
    $receiver_sockets = get_all_sockets_by_user_id($io, $call['to_user_id']);
    foreach ($receiver_sockets as $receiver_socket) {
      $receiver_socket->emit('event_server_call_canceled', $call);
    }
    emit_call_log($io, $user, $call);
  });

  // [listen] decline call (receiver)
  $socket->on('event_client_decline_call', function ($data) use ($io, $socket, $user) {
    /* decline call */
    try {
      $call = $user->decline_call($data['id']);
      print("📞 User {username: {$socket->username}, user_id: {$socket->userId}} Declined Call: {$call['call_id']}\n");
    } catch (Exception $e) {
      $socket->emit('event_server_error', ['message' => $e->getMessage(), 'modal' => true]);
      print("❌ Error: " . $e->getMessage() . "\n");
      return;
    }
    /* broadcast to all caller sockets */
    $caller_sockets = get_all_sockets_by_user_id($io, $call['from_user_id']);
    foreach ($caller_sockets as $caller_socket) {
      $caller_socket->emit('event_server_call_declined', $call);
    }
    /* stop ringing on the receiver's other sockets */
    foreach (get_all_sockets_by_user_id($io, $call['to_user_id']) as $receiver_socket) {
      if ($receiver_socket->id !== $socket->id) {
        $receiver_socket->emit('event_server_call_canceled', $call);
      }
    }
    emit_call_log($io, $user, $call);
  });

  // [listen] end call (caller|receiver)
  $socket->on('event_client_end_call', function ($data) use ($io, $socket, $user) {
    /* end call */
    try {
      $call = $user->decline_call($data['id']);
      print("📞 User {username: {$socket->username}, user_id: {$socket->userId}} Ended Call: {$call['call_id']}\n");
    } catch (Exception $e) {
      $socket->emit('event_server_error', ['message' => $e->getMessage(), 'modal' => true]);
      print("❌ Error: " . $e->getMessage() . "\n");
      return;
    }
    /* broadcast to all (caller|receiver) sockets */
    if ($call['from_user_id'] == $socket->userId) {
      /* receiver */
      $receiver_sockets = get_all_sockets_by_user_id($io, $call['to_user_id']);
      foreach ($receiver_sockets as $receiver_socket) {
        $receiver_socket->emit('event_server_call_ended', $call);
      }
    } else {
      /* caller */
      $caller_sockets = get_all_sockets_by_user_id($io, $call['from_user_id']);
      foreach ($caller_sockets as $caller_socket) {
        $caller_socket->emit('event_server_call_ended', $call);
      }
    }
    emit_call_log($io, $user, $call);
  });

  // [listen] answer call (receiver)
  $socket->on('event_client_answer_call', function ($data, $callback) use ($io, $socket, $user) {
    /* answer call */
    try {
      $call = $user->answer_call($data['id']);
      print("📞 User {username: {$socket->username}, user_id: {$socket->userId}} Answered Call: {$call['call_id']}\n");
    } catch (Exception $e) {
      $socket->emit('event_server_error', ['message' => $e->getMessage(), 'modal' => true]);
      print("❌ Error: " . $e->getMessage() . "\n");
      return;
    }
    /* broadcast to all caller sockets */
    $caller_sockets = get_all_sockets_by_user_id($io, $call['from_user_id']);
    foreach ($caller_sockets as $caller_socket) {
      $caller_socket->emit('event_server_call_answered', $call);
    }
    /* stop ringing on the receiver's other sockets */
    foreach (get_all_sockets_by_user_id($io, $call['to_user_id']) as $receiver_socket) {
      if ($receiver_socket->id !== $socket->id) {
        $receiver_socket->emit('event_server_call_canceled', $call);
      }
    }
    /* callback */
    $callback(json_encode($call));
  });

  // [listen] join live
  $socket->on('event_client_live_join', function ($data) use ($io, $socket, $user) {
    if (empty($data['post_id']) || !$user->check_live_post($data['post_id'])) {
      return;
    }
    $socket->join('live_' . (int) $data['post_id']);
    print("👋 {username: {$socket->username}, user_id: {$socket->userId}} Joined Live: {$data['post_id']}\n");
  });

  // [listen] leave live
  $socket->on('event_client_live_leave', function ($data) use ($io, $socket, $user) {
    if (empty($data['post_id'])) {
      return;
    }
    $socket->leave('live_' . (int) $data['post_id']);
  });

  // [listen] live comment
  $socket->on('event_client_live_comment', function ($data) use ($io, $socket, $user) {
    if (empty($data['post_id']) || empty($data['comment_id'])) {
      return;
    }
    $room = 'live_' . (int) $data['post_id'];
    if (!isset($socket->rooms[$room]) || !$user->check_live_comment($data['post_id'], $data['comment_id'])) {
      return;
    }
    $socket->broadcast->to($room)->emit('event_server_live_comment', ['post_id' => $data['post_id'], 'comment_id' => $data['comment_id']]);
    print("💬 User {username: {$socket->username}, user_id: {$socket->userId}} Commented on Live: {$data['post_id']}\n");
  });

  // [listen] live reaction
  $socket->on('event_client_live_reaction', function ($data) use ($io, $socket, $user) {
    if (empty($data['post_id'])) {
      return;
    }
    $room = 'live_' . (int) $data['post_id'];
    if (!isset($socket->rooms[$room]) || microtime(true) - ($socket->liveReactionAt ?? 0) < 1) {
      return;
    }
    $socket->liveReactionAt = microtime(true);
    $socket->broadcast->to($room)->emit('event_server_live_reaction', ['post_id' => $data['post_id']]);
  });

  // [listen] live moderation
  $socket->on('event_client_live_moderation', function ($data) use ($io, $socket, $user) {
    if (empty($data['post_id'])) {
      return;
    }
    $room = 'live_' . (int) $data['post_id'];
    if (!isset($socket->rooms[$room]) || microtime(true) - ($socket->liveModerationAt ?? 0) < 1) {
      return;
    }
    $socket->liveModerationAt = microtime(true);
    $socket->broadcast->to($room)->emit('event_server_live_moderation', ['post_id' => $data['post_id']]);
  });

  // [listen] update call (receiver)
  $socket->on('event_client_update_call', function ($data) use ($io, $socket, $user) {
    /* update call */
    try {
      $user->update_call($data['id']);
      print("📞 User {username: {$socket->username}, user_id: {$socket->userId}} Updated Call: {$call['call_id']}\n");
    } catch (Exception $e) {
      $socket->emit('event_server_error', ['message' => $e->getMessage(), 'modal' => true]);
      print("❌ Error: " . $e->getMessage() . "\n");
      return;
    }
  });
});


/**
 * conversation_member_ids
 *
 * @param array $conversation
 * @param integer $viewer_id
 * @return array
 */
function conversation_member_ids($conversation, $viewer_id)
{
  $member_ids = array_column($conversation['recipients'] ?? [], 'user_id');
  $member_ids[] = $viewer_id;
  return $member_ids;
}


/**
 * emit_conversation_updated
 *
 * @param object $io
 * @param array $member_ids
 * @param array $payload
 * @return void
 */
function emit_to_members($io, $member_ids, $event, $payload)
{
  $member_ids = array_unique(array_filter(array_map('intval', (array)$member_ids)));
  foreach ($member_ids as $member_id) {
    $member_sockets = get_all_sockets_by_user_id($io, $member_id);
    foreach ($member_sockets as $member_socket) {
      $member_socket->emit($event, $payload);
    }
  }
}


function emit_conversation_updated($io, $member_ids, $payload)
{
  emit_to_members($io, $member_ids, 'event_server_conversation_updated', $payload);
}


/**
 * emit_page_message
 *
 * @param object $io
 * @param object $socket
 * @param object $user
 * @param array $conversation
 * @param string $last_message_for_me
 * @param string $last_message_for_recipient
 * @return void
 */
function emit_call_log($io, $user, $call)
{
  global $smarty;
  if (empty($call['log_message_id'])) {
    return;
  }
  $message = $user->get_conversation_message_by_id($call['log_message_id']);
  if (!$message) {
    return;
  }
  $conversation = $user->get_conversation($message['conversation_id']);
  $smarty->assign('user', $user);
  $smarty->assign('conversation', $conversation);
  $smarty->assign('message', $message);
  foreach ([$call['from_user_id'], $call['to_user_id']] as $user_id) {
    $smarty->assign('is_me', $user_id == $call['from_user_id']);
    $last_message = $smarty->fetch("__feeds_message.tpl");
    foreach (get_all_sockets_by_user_id($io, $user_id) as $user_socket) {
      $user_socket->emit('event_server_message_received', [
        'conversation' => $conversation,
        'last_message' => $last_message,
        'is_me' => ($user_id == $user->_data['user_id']),
      ]);
    }
  }
}


function emit_page_message($io, $socket, $user, $conversation, $last_message_for_me, $last_message_for_recipient)
{
  global $smarty;
  $page_admins_ids = array_diff($user->get_page_admins_ids($conversation['page_id']), [$socket->userId]);
  $page_conversation = [
    'conversation_id' => $conversation['conversation_id'],
    'page_id' => $conversation['page_id'],
  ];
  if (!empty($conversation['as_page'])) {
    /* the page replied -> the customer */
    $customer_id = $conversation['user_id'];
    $customer_conversation = [
      'conversation_id' => $conversation['conversation_id'],
      'page_id' => $conversation['page_id'],
      'color' => $conversation['color'],
      'pinned_message_id' => $conversation['pinned_message_id'] ?? null,
    ];
    $smarty->assign('conversation', $customer_conversation);
    $smarty->assign('message', $user->get_conversation_message_by_id($conversation['last_message_id'], $customer_id));
    $smarty->assign('is_me', false);
    emit_to_members($io, [$customer_id], 'event_server_message_received', [
      'conversation' => $customer_conversation,
      'last_message' => $smarty->fetch("__feeds_message.tpl"),
      'is_me' => false,
    ]);
    /* the other page admins */
    emit_to_members($io, $page_admins_ids, 'event_server_page_message_received', [
      'conversation' => $page_conversation,
      'last_message' => $last_message_for_me,
      'is_me' => true,
    ]);
    $socket->broadcast->to($socket->userId)->emit('event_server_page_message_received', [
      'conversation' => $page_conversation,
      'last_message' => $last_message_for_me,
      'is_me' => true,
    ]);
    print("🔄 [Emit] User {username: {$socket->username}, user_id: {$socket->userId}} Page Message Sent To: {$customer_id}\n");
  } else {
    /* the customer messaged the page -> the page admins */
    emit_to_members($io, $page_admins_ids, 'event_server_page_message_received', [
      'conversation' => $page_conversation,
      'last_message' => $last_message_for_recipient,
      'is_me' => false,
    ]);
    $socket->broadcast->to($socket->userId)->emit('event_server_message_received', [
      'conversation' => $conversation,
      'last_message' => $last_message_for_me,
      'is_me' => true,
    ]);
    print("🔄 [Emit] User {username: {$socket->username}, user_id: {$socket->userId}} Message Sent To Page: {$conversation['page_id']}\n");
  }
}


// run workerman
Workerman\Worker::runAll();
