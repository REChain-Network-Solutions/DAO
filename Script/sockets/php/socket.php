<?php

/**
 * socket
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich
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
      handle_typing_change($io, $room, $socket, $user, false);
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
      $conversation = $user->get_conversation($data['conversation_id']);
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
      /* send message */
      print("✉️ User {username: {$socket->username}, user_id: {$socket->userId}} Sent Message To Conversation: " . $conversation['conversation_id'] . "\n");
    } catch (Exception $e) {
      $socket->emit('event_server_error', ['message' => $e->getMessage(), 'modal' => true]);
      print("❌ Error: " . $e->getMessage() . "\n");
      return;
    }
    /* prepare message */
    $smarty->assign('message', $conversation['last_message']);
    $smarty->assign('is_me', true);
    $last_message_for_me = $smarty->fetch("__feeds_message.tpl");
    $smarty->assign('is_me', false);
    $last_message_for_recipient = $smarty->fetch("__feeds_message.tpl");
    /* broadcast to all online recipients */
    $recipient_ids = array_column($conversation['recipients'], 'user_id');
    $online_recipient_ids = array_intersect($recipient_ids, get_all_sockets_user_ids($io));
    foreach ($online_recipient_ids as $recipient_id) {
      $recipientSockets = get_all_sockets_by_user_id($io, $recipient_id);
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
    $callback(json_encode($conversation));
  });

  // [listen] typing
  $socket->on('event_client_typing', function ($data) use ($io, $socket, $user) {
    handle_typing_change($io, 'conversation_' . $data['conversation_id'], $socket, $user, $data['is_typing']);
  });

  // [listen] seen
  $socket->on('event_client_seen', function ($data) use ($io, $socket, $system, $user) {
    /* broadcast to all user sockets */
    $conversation_id = $data['ids'][0];
    $room = 'conversation_' . $conversation_id;
    $socket->broadcast->to($room)->emit('event_server_seen', [
      'conversation_id' => $conversation_id,
      'seen_name_list' => html_entity_decode(($system['show_usernames_enabled']) ? $user->_data['user_name'] : $user->_data['user_firstname'], ENT_QUOTES),
    ]);
    print("👁️ [Emit] User {username: {$socket->username}, user_id: {$socket->userId}} Room: $room - Seen: true\n");
    /* update seen status */
    try {
      $user->update_conversation_seen_status((array)$data['ids']);
    } catch (Exception $e) {
      $socket->emit('event_server_error', ['message' => $e->getMessage(), 'modal' => true]);
      print("❌ Error: " . $e->getMessage() . "\n");
      return;
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
    /* callback */
    $callback(json_encode($call));
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


// run workerman
Workerman\Worker::runAll();
