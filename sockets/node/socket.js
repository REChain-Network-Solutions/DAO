/**
 * sockets -> nodejs -> socket
 *
 * @package Sngine
 * @author Zamblek
 */

const fs = require('fs');
const path = require('path');
const http = require('http');
const https = require('https');
const { spawn } = require('child_process');
const { Server } = require('socket.io');

const { loader } = require('./loader');
const { init_system } = require('./libs/core/system');
const User = require('./libs/class-user');
const { render_message, render_chat_pin } = require('./libs/templates/feeds_message');
const { ValidationException, AuthorizationException } = require('./libs/core/exceptions');
const { __ } = require('./libs/core/i18n');
const {
  print,
  get_all_sockets_user_ids,
  get_all_sockets_by_user_id,
  handle_typing_change,
  cleanup_user_typing_list,
} = require('./libs/functions');

const PID_FILE = path.join(__dirname, 'socket.pid');

/* array_intersect helper (kept string-safe for id comparisons) */
function array_intersect(a, b) {
  const setB = new Set(b.map(String));
  return a.filter((v) => setB.has(String(v)));
}

function conversation_member_ids(conversation, viewer_id) {
  const member_ids = (conversation.recipients || []).map((recipient) => recipient.user_id);
  member_ids.push(viewer_id);
  return member_ids;
}

function emit_to_members(io, member_ids, event, payload) {
  const unique_ids = [...new Set((member_ids || []).map((id) => Number(id)).filter(Boolean))];
  for (const member_id of unique_ids) {
    for (const member_socket of get_all_sockets_by_user_id(io, member_id)) {
      member_socket.emit(event, payload);
    }
  }
}

function emit_conversation_updated(io, member_ids, payload) {
  emit_to_members(io, member_ids, 'event_server_conversation_updated', payload);
}

async function emit_call_log(io, user, system, call) {
  if (!call.log_message_id) return;
  const message = await user.get_conversation_message_by_id(call.log_message_id);
  if (!message) return;
  const conversation = await user.get_conversation(message.conversation_id);
  for (const user_id of [call.from_user_id, call.to_user_id]) {
    const last_message = render_message({ message, is_me: user_id == call.from_user_id, conversation, user, system });
    for (const user_socket of get_all_sockets_by_user_id(io, user_id)) {
      user_socket.emit('event_server_message_received', { conversation, last_message, is_me: user_id == user._data.user_id });
    }
  }
}

async function emit_page_message(io, socket, user, system, conversation, last_message_for_me, last_message_for_recipient) {
  const page_admins_ids = (await user.get_page_admins_ids(conversation.page_id)).filter((id) => id != socket.data.userId);
  const page_conversation = {
    conversation_id: conversation.conversation_id,
    page_id: conversation.page_id,
  };
  if (conversation.as_page) {
    /* the page replied -> the customer */
    const customer_id = conversation.user_id;
    const customer_conversation = {
      conversation_id: conversation.conversation_id,
      page_id: conversation.page_id,
      color: conversation.color,
      pinned_message_id: conversation.pinned_message_id || null,
    };
    const customer_message = await user.get_conversation_message_by_id(conversation.last_message_id, customer_id);
    emit_to_members(io, [customer_id], 'event_server_message_received', {
      conversation: customer_conversation,
      last_message: render_message({ message: customer_message, is_me: false, conversation: customer_conversation, user, system }),
      is_me: false,
    });
    /* the other page admins */
    emit_to_members(io, page_admins_ids, 'event_server_page_message_received', {
      conversation: page_conversation,
      last_message: last_message_for_me,
      is_me: true,
    });
    socket.to(String(socket.data.userId)).emit('event_server_page_message_received', {
      conversation: page_conversation,
      last_message: last_message_for_me,
      is_me: true,
    });
    print(`🔄 [Emit] User {username: ${socket.data.username}, user_id: ${socket.data.userId}} Page Message Sent To: ${customer_id}`);
  } else {
    /* the customer messaged the page -> the page admins */
    emit_to_members(io, page_admins_ids, 'event_server_page_message_received', {
      conversation: page_conversation,
      last_message: last_message_for_recipient,
      is_me: false,
    });
    socket.to(String(socket.data.userId)).emit('event_server_message_received', {
      conversation,
      last_message: last_message_for_me,
      is_me: true,
    });
    print(`🔄 [Emit] User {username: ${socket.data.username}, user_id: ${socket.data.userId}} Message Sent To Page: ${conversation.page_id}`);
  }
}

/* ------------------------------- */
/* Server */
/* ------------------------------- */

async function run() {
  const { system } = await loader();

  /* refresh system options */
  setInterval(async () => {
    try {
      Object.assign(system, await init_system());
    } catch (e) {
      print('❌ System refresh error: ' + e.message);
    }
  }, 60000);

  /* init http(s) server */
  let server;
  if (system.chat_socket_proxied == 1) {
    server = http.createServer();
  } else {
    server = https.createServer({
      cert: fs.readFileSync(system.chat_socket_ssl_crt),
      key: fs.readFileSync(system.chat_socket_ssl_key),
    });
  }

  /* init socket.io */
  const io = new Server(server, {
    cors: { origin: '*', methods: ['GET', 'POST'] },
  });

  /* on connection */
  io.on('connection', async (socket) => {
    print('✅ Client Connected: ' + socket.id);

    /* handle handshake */
    const jwt = socket.handshake.query.jwt || null;
    if (!jwt) {
      socket.emit('event_server_error', { message: '❌ Invalid Client JWT' });
      print('❌ Invalid Client JWT');
      return;
    }

    /* get user data */
    let user;
    try {
      user = await User.authenticate(jwt, system);
    } catch (e) {
      socket.emit('event_server_error', { message: e.message });
      print('❌ User Authentication Error: ' + e.message);
      return;
    }
    socket.data.userId = user._data.user_id;
    socket.data.username = user._data.user_name;
    print(`👤 User {username: ${socket.data.username}, user_id: ${socket.data.userId}} Attached Socket: ${socket.id}`);

    /* join user own room */
    socket.join(String(socket.data.userId));
    print(`🏠 User {username: ${socket.data.username}, user_id: ${socket.data.userId}} Joined Own Room`);

    /* [emit] welcome */
    socket.emit('event_server_welcome', { message: '👋 ' + user._data.user_name + '!' });

    /* [emit] user online */
    const onlinePayload = (isOnline) => ({
      user_id: user._data.user_id,
      user_fullname: user._data.user_fullname,
      user_name: user._data.user_name,
      user_picture: user._data.user_picture,
      user_last_seen: user._data.user_last_seen,
      user_is_online: isOnline,
    });
    const broadcastPresence = (isOnline) => {
      const online_friends_ids = array_intersect(
        user.get_friends_or_followings_ids(),
        get_all_sockets_user_ids(io)
      );
      for (const friend_id of online_friends_ids) {
        for (const friend_socket of get_all_sockets_by_user_id(io, friend_id)) {
          friend_socket.emit(
            isOnline ? 'event_server_user_online' : 'event_server_user_offline',
            onlinePayload(isOnline)
          );
        }
      }
    };
    broadcastPresence(true);
    print(`🔄 [Emit] User {username: ${socket.data.username}, user_id: ${socket.data.userId}} 🟢 Online`);

    /* [listen] disconnect */
    socket.on('disconnect', async () => {
      print('🛑 Client Disconnected: ' + socket.id);
      print(`❌ User {username: ${socket.data.username}, user_id: ${socket.data.userId}} Detached Socket: ${socket.id}`);
      broadcastPresence(false);
      print(`🔄 [Emit] User {username: ${socket.data.username}, user_id: ${socket.data.userId}} 🔴 Offline`);
      /* cleanup user typing list */
      const affected_rooms = cleanup_user_typing_list(socket);
      for (const room of affected_rooms) {
        await handle_typing_change(io, room, socket, user, false, system, !!(socket.data.pageRooms && socket.data.pageRooms[room]));
      }
    });

    /* [listen] ping */
    socket.on('event_client_ping', () => {
      broadcastPresence(true);
    });

    /* [listen] chat toggle */
    socket.on('event_client_chat_toggle', async (data) => {
      socket.to(String(socket.data.userId)).emit('event_server_chat_toggle', {
        user_chat_enabled: data.user_chat_enabled,
      });
      print(`🔄 [Emit] User {username: ${socket.data.username}, user_id: ${socket.data.userId}} Turned Active Status: ${data.user_chat_enabled == 0 ? 'OFF' : 'ON'}`);
      try {
        await user.settings('chat', data);
      } catch (e) {
        socket.emit('event_server_error', { message: e.message, modal: true });
        print('❌ Error: ' + e.message);
      }
    });

    /* [listen] open thread */
    socket.on('event_client_open_thread', async (data) => {
      const room = 'conversation_' + data.conversation_id;
      if (data.as_page) {
        /* page inbox */
        if (!(await user.check_page_conversation_access(data.conversation_id))) return;
        socket.data.pageRooms = socket.data.pageRooms || {};
        socket.data.pageRooms[room] = true;
      }
      socket.join(room);
      print(`👋 {username: ${socket.data.username}, user_id: ${socket.data.userId}} Joined Thread: ${room}`);
    });

    /* [listen] open chat box */
    socket.on('event_client_open_chatbox', (data) => {
      const room = 'conversation_' + data.conversation_id;
      socket.join(room);
      print(`👋 {username: ${socket.data.username}, user_id: ${socket.data.userId}} Joined Room: ${room}`);
      socket.to(String(socket.data.userId)).emit('event_server_chatbox_opened', data);
      print(`🔄 [Emit] User {username: ${socket.data.username}, user_id: ${socket.data.userId}} Opened Chatbox Room: ${room}`);
    });

    /* [listen] close chat box */
    socket.on('event_client_close_chatbox', (data) => {
      const room = 'conversation_' + data.conversation_id;
      socket.leave(room);
      print(`✌️ {username: ${socket.data.username}, user_id: ${socket.data.userId}} Left Room: ${room}`);
      socket.to(String(socket.data.userId)).emit('event_server_chatbox_closed', data);
      print(`🔄 [Emit] User {username: ${socket.data.username}, user_id: ${socket.data.userId}} Closed Chatbox Room: ${room}`);
    });

    /* [listen] delete conversation */
    socket.on('event_client_delete_conversation', async (data) => {
      const room = 'conversation_' + data.conversation_id;
      socket.leave(room);
      print(`✌️ {username: ${socket.data.username}, user_id: ${socket.data.userId}} Left Room: ${room}`);
      socket.to(room).emit('event_server_delete_conversation', data);
      print(`🔄 [Emit] {username: ${socket.data.username}, user_id: ${socket.data.userId}} Deleted Conversation: ${room}`);
      try {
        await user.delete_conversation(data.conversation_id);
      } catch (e) {
        socket.emit('event_server_error', { message: e.message, modal: true });
        print('❌ Error: ' + e.message);
      }
    });

    /* [listen] leave conversation */
    socket.on('event_client_leave_conversation', async (data) => {
      const room = 'conversation_' + data.conversation_id;
      socket.leave(room);
      print(`✌️ {username: ${socket.data.username}, user_id: ${socket.data.userId}} Left Room: ${room}`);
      socket.to(room).emit('event_server_leave_conversation', data);
      print(`🔄 [Emit] {username: ${socket.data.username}, user_id: ${socket.data.userId}} Left Conversation: ${room}`);
      try {
        await user.leave_conversation(data.conversation_id);
      } catch (e) {
        socket.emit('event_server_error', { message: e.message, modal: true });
        print('❌ Error: ' + e.message);
      }
    });

    /* [listen] get conversation */
    socket.on('event_client_get_conversation', async (data, callback) => {
      try {
        const conversation = await user.get_conversation(data.conversation_id, !!data.as_page);
        if (typeof callback === 'function') callback(JSON.stringify(conversation));
      } catch (e) {
        socket.emit('event_server_error', { message: e.message, modal: true });
        print('❌ Error: ' + e.message);
      }
    });

    /* [listen] send message */
    socket.on('event_client_send_message', async (data, callback) => {
      let conversation;
      try {
        conversation = await user.post_conversation_message(data, true);
        /* nothing to send (product already shared) */
        if (!conversation) {
          if (typeof callback === 'function') callback(JSON.stringify(null));
          return;
        }
        print(`✉️ User {username: ${socket.data.username}, user_id: ${socket.data.userId}} Sent Message To Conversation: ${conversation.conversation_id}`);
      } catch (e) {
        socket.emit('event_server_error', { message: e.message, modal: true });
        print('❌ Error: ' + e.message);
        return;
      }
      /* render the last message HTML for both sides */
      const last_message_for_me = render_message({
        message: conversation.last_message,
        is_me: true,
        conversation,
        user,
        system,
      });
      const last_message_for_recipient = render_message({
        message: conversation.last_message,
        is_me: false,
        conversation,
        user,
        system,
      });
      /* page conversation */
      if (conversation.page_id) {
        await emit_page_message(io, socket, user, system, conversation, last_message_for_me, last_message_for_recipient);
        conversation.last_message_html = last_message_for_me;
        if (typeof callback === 'function') callback(JSON.stringify(conversation));
        return;
      }
      /* broadcast to all online recipients */
      const recipient_ids = conversation.recipients.map((r) => r.user_id);
      const online_recipient_ids = array_intersect(recipient_ids, get_all_sockets_user_ids(io));
      for (const recipient_id of online_recipient_ids) {
        const recipientSockets = get_all_sockets_by_user_id(io, recipient_id);
        if (!recipientSockets.length) continue;
        for (const recipientSocket of recipientSockets) {
          recipientSocket.emit('event_server_message_received', {
            conversation,
            last_message: last_message_for_recipient,
            is_me: false,
          });
          print(`🔄 [Emit] User {username: ${socket.data.username}, user_id: ${socket.data.userId}} Message Sent To: ${recipientSocket.data.username}`);
        }
      }
      /* broadcast to the sender's other sockets */
      socket.to(String(socket.data.userId)).emit('event_server_message_received', {
        conversation,
        last_message: last_message_for_me,
        is_me: true,
      });
      print(`🔄 [Emit] User {username: ${socket.data.username}, user_id: ${socket.data.userId}} Message Sent To: ${socket.data.username}`);
      conversation.last_message_html = last_message_for_me;
      if (typeof callback === 'function') callback(JSON.stringify(conversation));
    });

    /* [listen] send paid message */
    socket.on('event_client_send_paid_message', async (data, callback) => {
      let conversation;
      try {
        conversation = await user.post_conversation_paid_message(data, true);
        print(`💰 User {username: ${socket.data.username}, user_id: ${socket.data.userId}} Sent Paid Message To Conversation: ${conversation.conversation_id}`);
      } catch (e) {
        if (e instanceof ValidationException) {
          if (typeof callback === 'function') {
            callback(JSON.stringify({ error: true, message: e.message }));
          }
          print('❌ Validation Error: ' + e.message);
          return;
        }
        socket.emit('event_server_error', { message: e.message, modal: true });
        print('❌ Error: ' + e.message);
        return;
      }
      /* prepare message */
      const message_id = conversation.last_message.message_id;
      const last_message_for_me = render_message({
        message: conversation.last_message,
        is_me: true,
        conversation,
        user,
        system,
      });
      /* broadcast to all online recipients */
      const recipient_ids = conversation.recipients.map((r) => r.user_id);
      const online_recipient_ids = array_intersect(recipient_ids, get_all_sockets_user_ids(io));
      for (const recipient_id of online_recipient_ids) {
        const recipientSockets = get_all_sockets_by_user_id(io, recipient_id);
        if (!recipientSockets.length) continue;
        const recipient_message = await user.get_conversation_message_by_id(message_id, recipient_id);
        const viewer = await user.get_user(recipient_id);
        const vat_percentage = viewer ? await user.get_payment_vat_percentage(viewer) : null;
        const last_message_for_recipient = render_message({
          message: recipient_message,
          is_me: false,
          conversation,
          user,
          system,
          vat_percentage,
        });
        for (const recipientSocket of recipientSockets) {
          recipientSocket.emit('event_server_message_received', {
            conversation,
            last_message: last_message_for_recipient,
            is_me: false,
          });
          print(`🔄 [Emit] User {username: ${socket.data.username}, user_id: ${socket.data.userId}} Paid Message Sent To: ${recipientSocket.data.username}`);
        }
      }
      /* broadcast to all user sockets */
      socket.to(String(socket.data.userId)).emit('event_server_message_received', {
        conversation,
        last_message: last_message_for_me,
        is_me: true,
      });
      print(`🔄 [Emit] User {username: ${socket.data.username}, user_id: ${socket.data.userId}} Paid Message Sent To: ${socket.data.username}`);
      /* callback */
      conversation.last_message_html = last_message_for_me;
      if (typeof callback === 'function') callback(JSON.stringify(conversation));
    });

    /* [listen] typing */
    socket.on('event_client_typing', async (data) => {
      await handle_typing_change(io, 'conversation_' + data.conversation_id, socket, user, data.is_typing, system, !!data.as_page);
    });

    /* [listen] seen */
    socket.on('event_client_seen', async (data) => {
      const conversation_id = data.ids[0];
      const room = 'conversation_' + conversation_id;
      const as_page = !!data.as_page;
      if (as_page) {
        /* page inbox */
        const page_id = await user.check_page_conversation_access(conversation_id);
        const page = page_id ? await user.get_chat_page(page_id) : false;
        if (page && system.chat_seen_enabled == 1) {
          socket.to(room).emit('event_server_seen', {
            conversation_id,
            seen_name_list: page.page_title,
          });
        }
      } else if (!(await user.check_page_conversation_access(conversation_id))) {
        socket.to(room).emit('event_server_seen', {
          conversation_id,
          seen_name_list: (
            system.show_usernames_enabled == 1 ? user._data.user_name : user._data.user_firstname
          ),
        });
      }
      print(`👁️ [Emit] User {username: ${socket.data.username}, user_id: ${socket.data.userId}} Room: ${room} - Seen: true`);
      try {
        await user.update_conversation_seen_status(data.ids, as_page);
      } catch (e) {
        socket.emit('event_server_error', { message: e.message, modal: true });
        print('❌ Error: ' + e.message);
      }
    });

    /* [listen] react message */
    socket.on('event_client_react_message', async (data, callback) => {
      try {
        const updated = (data.do || 'react') == 'unreact'
          ? await user.unreact_message(data.message_id, data.reaction)
          : await user.react_message(data.message_id, data.reaction);
        const payload = {
          conversation_id: updated.conversation_id,
          message_id: updated.message_id,
          user_id: (await user.check_page_conversation_access(updated.conversation_id)) ? 0 : user._data.user_id,
          reactions: updated.reactions,
          reactions_total_count: updated.reactions_total_count,
          reactions_total_count_formatted: updated.reactions_total_count,
        };
        emit_to_members(io, await user.get_conversation_members_ids(updated.conversation_id), 'event_server_message_reacted', payload);
        payload.i_react = updated.i_react;
        payload.i_reaction = updated.i_reaction || null;
        if (typeof callback === 'function') callback(JSON.stringify(payload));
      } catch (e) {
        socket.emit('event_server_error', { message: e.message, modal: true });
        print('❌ Error: ' + e.message);
      }
    });

    /* [listen] delete message */
    socket.on('event_client_delete_message', async (data, callback) => {
      try {
        const message = await user.get_conversation_message_by_id(data.message_id);
        if (!message) {
          throw new AuthorizationException(__('You are not authorized to do this'));
        }
        const member_ids = await user.get_conversation_members_ids(message.conversation_id);
        await user.delete_conversation_message(data.message_id);
        const payload = {
          conversation_id: message.conversation_id,
          message_id: data.message_id,
        };
        emit_to_members(io, member_ids, 'event_server_message_deleted', payload);
        if (typeof callback === 'function') callback(JSON.stringify(payload));
      } catch (e) {
        socket.emit('event_server_error', { message: e.message, modal: true });
        print('❌ Error: ' + e.message);
      }
    });

    /* [listen] pin message */
    socket.on('event_client_pin_message', async (data, callback) => {
      try {
        const conversation = (data.do || 'pin') == 'unpin'
          ? await user.unpin_conversation_message(data.conversation_id, !!data.as_page)
          : await user.pin_conversation_message(data.message_id, !!data.as_page);
        const payload = {
          conversation_id: conversation.conversation_id,
          pinned_message: conversation.pinned_message,
          pin_html: render_chat_pin({ conversation, system }),
        };
        emit_to_members(io, await user.get_conversation_members_ids(conversation.conversation_id), 'event_server_message_pinned', payload);
        if (typeof callback === 'function') callback(JSON.stringify(payload));
      } catch (e) {
        socket.emit('event_server_error', { message: e.message, modal: true });
        print('❌ Error: ' + e.message);
      }
    });

    /* [listen] color */
    socket.on('event_client_color', async (data) => {
      const room = 'conversation_' + data.conversation_id;
      socket.to(room).emit('event_server_color', {
        conversation_id: data.conversation_id,
        color: data.color,
      });
      print(`🎨 [Emit] User {username: ${socket.data.username}, user_id: ${socket.data.userId}} Room: ${room} - Color: ${data.color}`);
      try {
        await user.set_conversation_color(data.conversation_id, data.color);
      } catch (e) {
        socket.emit('event_server_error', { message: e.message, modal: true });
        print('❌ Error: ' + e.message);
      }
    });

    /* [listen] rename conversation */
    socket.on('event_client_conversation_rename', async (data, callback) => {
      try {
        const conversation = await user.rename_conversation(data.conversation_id, data.name || '');
        const payload = {
          conversation_id: conversation.conversation_id,
          conversation,
        };
        emit_conversation_updated(io, conversation_member_ids(conversation, socket.data.userId), payload);
        print(`✏️ [Emit] {username: ${socket.data.username}, user_id: ${socket.data.userId}} Renamed Conversation: conversation_${conversation.conversation_id}`);
        if (typeof callback === 'function') callback(JSON.stringify(payload));
      } catch (e) {
        socket.emit('event_server_error', { message: e.message, modal: true });
        print('❌ Error: ' + e.message);
      }
    });

    /* [listen] add conversation user */
    socket.on('event_client_conversation_add', async (data, callback) => {
      try {
        const conversation = await user.add_conversation_user(data.conversation_id, data.user_id);
        const payload = {
          conversation_id: conversation.conversation_id,
          conversation,
          added_user_id: data.user_id,
        };
        const member_ids = conversation_member_ids(conversation, socket.data.userId);
        member_ids.push(data.user_id);
        emit_conversation_updated(io, member_ids, payload);
        print(`➕ [Emit] {username: ${socket.data.username}, user_id: ${socket.data.userId}} Added User ${data.user_id} To Conversation: conversation_${conversation.conversation_id}`);
        if (typeof callback === 'function') callback(JSON.stringify(payload));
      } catch (e) {
        socket.emit('event_server_error', { message: e.message, modal: true });
        print('❌ Error: ' + e.message);
      }
    });

    /* [listen] remove conversation user */
    socket.on('event_client_conversation_remove', async (data, callback) => {
      try {
        const conversation = await user.get_conversation(data.conversation_id);
        if (!conversation) {
          throw new AuthorizationException(__('You are not authorized to do this'));
        }
        const member_ids = conversation_member_ids(conversation, socket.data.userId);
        member_ids.push(data.user_id);
        const updated = await user.remove_conversation_user(data.conversation_id, data.user_id);
        const payload = {
          conversation_id: data.conversation_id,
          conversation: updated || null,
          removed_user_id: data.user_id,
        };
        emit_conversation_updated(io, member_ids, payload);
        print(`➖ [Emit] {username: ${socket.data.username}, user_id: ${socket.data.userId}} Removed User ${data.user_id} From Conversation: conversation_${data.conversation_id}`);
        if (typeof callback === 'function') callback(JSON.stringify(payload));
      } catch (e) {
        socket.emit('event_server_error', { message: e.message, modal: true });
        print('❌ Error: ' + e.message);
      }
    });

    /* [listen] create call (caller) */
    socket.on('event_client_create_call', async (data, callback) => {
      let call;
      const receiver_sockets = get_all_sockets_by_user_id(io, data.id);
      if (receiver_sockets.length > 0) {
        try {
          call = await user.create_call(data.type, data.id);
          print(`📞 User {username: ${socket.data.username}, user_id: ${socket.data.userId}} Created Call: ${call.call_id}`);
        } catch (e) {
          socket.emit('event_server_error', { message: e.message, modal: true });
          print('❌ Error: ' + e.message);
          return;
        }
        for (const receiver_socket of receiver_sockets) {
          receiver_socket.emit('event_server_call_received', call);
        }
      } else {
        call = 'recipient_offline';
      }
      if (typeof callback === 'function') callback(JSON.stringify(call));
    });

    /* [listen] call canceled (caller) */
    socket.on('event_client_cancel_call', async (data) => {
      let call;
      try {
        call = await user.decline_call(data.id);
        print(`📞 User {username: ${socket.data.username}, user_id: ${socket.data.userId}} Canceled Call: ${call.call_id}`);
      } catch (e) {
        socket.emit('event_server_error', { message: e.message, modal: true });
        print('❌ Error: ' + e.message);
        return;
      }
      for (const receiver_socket of get_all_sockets_by_user_id(io, call.to_user_id)) {
        receiver_socket.emit('event_server_call_canceled', call);
      }
      await emit_call_log(io, user, system, call);
    });

    /* [listen] decline call (receiver) */
    socket.on('event_client_decline_call', async (data) => {
      let call;
      try {
        call = await user.decline_call(data.id);
        print(`📞 User {username: ${socket.data.username}, user_id: ${socket.data.userId}} Declined Call: ${call.call_id}`);
      } catch (e) {
        socket.emit('event_server_error', { message: e.message, modal: true });
        print('❌ Error: ' + e.message);
        return;
      }
      for (const caller_socket of get_all_sockets_by_user_id(io, call.from_user_id)) {
        caller_socket.emit('event_server_call_declined', call);
      }
      for (const receiver_socket of get_all_sockets_by_user_id(io, call.to_user_id)) {
        if (receiver_socket.id !== socket.id) receiver_socket.emit('event_server_call_canceled', call);
      }
      await emit_call_log(io, user, system, call);
    });

    /* [listen] end call (caller|receiver) */
    socket.on('event_client_end_call', async (data) => {
      let call;
      try {
        call = await user.decline_call(data.id);
        print(`📞 User {username: ${socket.data.username}, user_id: ${socket.data.userId}} Ended Call: ${call.call_id}`);
      } catch (e) {
        socket.emit('event_server_error', { message: e.message, modal: true });
        print('❌ Error: ' + e.message);
        return;
      }
      const target_id = call.from_user_id == socket.data.userId ? call.to_user_id : call.from_user_id;
      for (const target_socket of get_all_sockets_by_user_id(io, target_id)) {
        target_socket.emit('event_server_call_ended', call);
      }
      await emit_call_log(io, user, system, call);
    });

    /* [listen] answer call (receiver) */
    socket.on('event_client_answer_call', async (data, callback) => {
      let call;
      try {
        call = await user.answer_call(data.id);
        print(`📞 User {username: ${socket.data.username}, user_id: ${socket.data.userId}} Answered Call: ${call.call_id}`);
      } catch (e) {
        socket.emit('event_server_error', { message: e.message, modal: true });
        print('❌ Error: ' + e.message);
        return;
      }
      for (const caller_socket of get_all_sockets_by_user_id(io, call.from_user_id)) {
        caller_socket.emit('event_server_call_answered', call);
      }
      for (const receiver_socket of get_all_sockets_by_user_id(io, call.to_user_id)) {
        if (receiver_socket.id !== socket.id) receiver_socket.emit('event_server_call_canceled', call);
      }
      if (typeof callback === 'function') callback(JSON.stringify(call));
    });

    /* [listen] join live */
    socket.on('event_client_live_join', async (data) => {
      if (!data || !(await user.check_live_post(data.post_id))) return;
      socket.join('live_' + parseInt(data.post_id, 10));
      print(`👋 {username: ${socket.data.username}, user_id: ${socket.data.userId}} Joined Live: ${data.post_id}`);
    });

    /* [listen] leave live */
    socket.on('event_client_live_leave', (data) => {
      if (!data) return;
      socket.leave('live_' + parseInt(data.post_id, 10));
    });

    /* [listen] live comment */
    socket.on('event_client_live_comment', async (data) => {
      if (!data) return;
      const room = 'live_' + parseInt(data.post_id, 10);
      if (!socket.rooms.has(room) || !(await user.check_live_comment(data.post_id, data.comment_id))) return;
      socket.to(room).emit('event_server_live_comment', { post_id: data.post_id, comment_id: data.comment_id });
      print(`💬 User {username: ${socket.data.username}, user_id: ${socket.data.userId}} Commented on Live: ${data.post_id}`);
    });

    /* [listen] live reaction */
    socket.on('event_client_live_reaction', async (data) => {
      if (!data) return;
      const room = 'live_' + parseInt(data.post_id, 10);
      if (!socket.rooms.has(room) || Date.now() - (socket.data.liveReactionAt || 0) < 1000) return;
      socket.data.liveReactionAt = Date.now();
      socket.to(room).emit('event_server_live_reaction', { post_id: data.post_id });
    });

    /* [listen] live moderation */
    socket.on('event_client_live_moderation', async (data) => {
      if (!data) return;
      const room = 'live_' + parseInt(data.post_id, 10);
      if (!socket.rooms.has(room) || Date.now() - (socket.data.liveModerationAt || 0) < 1000) return;
      socket.data.liveModerationAt = Date.now();
      socket.to(room).emit('event_server_live_moderation', { post_id: data.post_id });
    });

    /* [listen] update call (receiver) */
    socket.on('event_client_update_call', async (data) => {
      try {
        await user.update_call(data.id);
      } catch (e) {
        socket.emit('event_server_error', { message: e.message, modal: true });
        print('❌ Error: ' + e.message);
      }
    });
  });

  /* run */
  const port = parseInt(system.chat_socket_port, 10) || 3000;
  server.listen(port, () => {
    print(`🚀 Sngine NodeJS socket server listening on port ${port} (${system.chat_socket_proxied == 1 ? 'http/proxied' : 'https'})`);
  });
}

/* ------------------------------- */
/* Process management (start/stop/status) */
/* ------------------------------- */

function read_pid() {
  try {
    const pid = parseInt(fs.readFileSync(PID_FILE, 'utf8').trim(), 10);
    return Number.isInteger(pid) ? pid : null;
  } catch (e) {
    return null;
  }
}

function is_alive(pid) {
  if (!pid) return false;
  try {
    process.kill(pid, 0);
    return true;
  } catch (e) {
    return false;
  }
}

function start_daemon() {
  const pid = read_pid();
  if (is_alive(pid)) {
    console.log(`Sngine NodeJS socket server already running (PID ${pid})`);
    return;
  }
  // A detached process has no terminal, so its output must go somewhere.
  // By default discard it — run the server in the foreground (`start` without
  // -d) under a process manager (Docker, systemd, PM2) and let it own logging.
  // For bare-shell hosting, set SOCKET_LOG=/path/to/file to keep a plain log.
  const log_path = process.env.SOCKET_LOG || (process.platform === 'win32' ? 'NUL' : '/dev/null');
  const out = fs.openSync(log_path, 'a');
  const child = spawn(process.execPath, [__filename, 'start'], {
    detached: true,
    stdio: ['ignore', out, out],
    cwd: __dirname,
  });
  fs.writeFileSync(PID_FILE, String(child.pid));
  child.unref();
  console.log(`Sngine NodeJS socket server started (PID ${child.pid})`);
}

function stop_daemon() {
  const pid = read_pid();
  if (!is_alive(pid)) {
    console.log('Sngine NodeJS socket server is not running');
    try { fs.unlinkSync(PID_FILE); } catch (e) { }
    return;
  }
  try {
    process.kill(pid);
    /* wait for exit (release the port) */
    const deadline = Date.now() + 5000;
    while (is_alive(pid) && Date.now() < deadline) {
      Atomics.wait(new Int32Array(new SharedArrayBuffer(4)), 0, 0, 100);
    }
    console.log(`Sngine NodeJS socket server stopped (PID ${pid})`);
  } catch (e) {
    console.log('Failed to stop server: ' + e.message);
  }
  try { fs.unlinkSync(PID_FILE); } catch (e) { }
}

function status_daemon() {
  const pid = read_pid();
  if (is_alive(pid)) {
    console.log(`Sngine NodeJS socket server is running (PID ${pid})`);
  } else {
    console.log('Sngine NodeJS socket server is not running');
  }
}

/* ------------------------------- */
/* Entry */
/* ------------------------------- */

const args = process.argv.slice(2);
const command = args[0] || 'start';
const daemon = args.includes('-d');

switch (command) {
  case 'start':
    if (daemon) {
      start_daemon();
    } else {
      run().catch((e) => {
        console.log('❌ Fatal error: ' + e.message);
        process.exit(1);
      });
    }
    break;
  case 'stop':
    stop_daemon();
    break;
  case 'status':
    status_daemon();
    break;
  default:
    console.log('Usage: node socket.js [start [-d] | stop | status]');
    break;
}
