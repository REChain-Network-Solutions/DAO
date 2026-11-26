/**
 * chat js
 * 
 * @package Sngine
 * @author Zamblek
 */

// initialize API URLs
/* AJAX */
api['chat/live'] = ajax_path + 'chat/live.php';
api['chat/call'] = ajax_path + 'chat/call.php';
api['chat/post'] = ajax_path + 'chat/post.php';
api['chat/actions'] = ajax_path + 'chat/actions.php';
/* AJAX & Socket */
api['chat/messages'] = ajax_path + 'chat/messages.php';
api['chat/search'] = ajax_path + 'chat/search.php';
api['chat/conversation/check'] = ajax_path + 'chat/conversation.php?do=check';
api['chat/conversation/get'] = ajax_path + 'chat/conversation.php?do=get';
api['chat/conversation/group'] = ajax_path + 'chat/conversation.php?do=group';
api['chat/conversation/page_inbox'] = ajax_path + 'chat/conversation.php?do=page_inbox';


// initialize chat global vars
var chat_socket = null;
var chatbox_closing_process = false;
var chat_calling_process = false;
var chat_ringing_process = false;
var chat_incall_process = false;
var chat_ending_call_timeout = null;
var chat_call_timer = null;
var chat_call = null;
var conversation_get_xhr = null;


// init chat socket
function init_chat_socket() {

  // init AJAX chat system if chat socket is disabled
  if (!chat_socket_enabled) {
    setTimeout('chat_heartbeat()', 1000);
    return;
  }

  // init chat socket
  chat_socket = io(chat_socket_path, {
    path: '/socket.io',
    query: {
      jwt: getCookie('user_jwt')
    }
  });

  // init chatboxes from local storage
  if (chat_enabled && !is_messages_page()) {
    var chatboxes = localStorage.getItem(`chatboxes_${user_id}`);
    if (chatboxes) {
      chatboxes = JSON.parse(chatboxes);
      $.each(chatboxes, function (i, chatbox) {
        if (chatbox.picture && String(chatbox.picture).indexOf('/themes/undefined/') !== -1) {
          chatbox.picture = '';
        }
        chat_box(chatbox.user_id, chatbox.conversation_id, chatbox.name, chatbox.name_list, chatbox.multiple_recipients, chatbox.link, chatbox.picture, true, chatbox.page_id);
      });
    }
  }

  // [emit] ping
  setInterval(() => {
    chat_socket.emit('event_client_ping');
  }, min_chat_heartbeat);

  // [listen] connect
  chat_socket.on("connect", () => {
    dlog("✅ Connected to Chat Socket Server");
  });

  // [listen] error
  chat_socket.on('event_server_error', (data) => {
    dlog("🔴 Server Error:", data.message);
    chat_reset_pending();
    if (data.modal) {
      show_error_modal(data.message);
    }
  });

  // [listen] welcome
  chat_socket.on('event_server_welcome', (data) => {
    dlog("🔄 Welcome:", data.message);
    /* rejoin live room (if any) */
    if (typeof live_socket_post_id !== "undefined" && live_socket_post_id) {
      chat_socket.emit('event_client_live_join', { post_id: live_socket_post_id });
    }
  });

  // [listen] live reaction
  chat_socket.on('event_server_live_reaction', (data) => {
    if (typeof live_comments_refresh === "function") {
      live_comments_refresh();
    }
  });

  // [listen] live moderation
  chat_socket.on('event_server_live_moderation', (data) => {
    if (typeof live_comments_refresh === "function") {
      live_comments_refresh();
    }
  });

  // [listen] live comment
  chat_socket.on('event_server_live_comment', (data) => {
    dlog("💬 Live comment:", data.comment_id);
    if (typeof live_comments_refresh === "function") {
      live_comments_refresh();
    }
  });

  // [listen] chat toggle
  chat_socket.on('event_server_chat_toggle', (data) => {
    dlog("🔄 Chat toggle:", data);
    /* update chat toggle status */
    var new_status = data.user_chat_enabled == 0 ? "on" : "off";
    update_chat_toggle_status(new_status);
  });

  // [listen] user online
  chat_socket.on('event_server_user_online', (data) => {
    dlog("🟢 Online:", data);
    /* add to online contacts list */
    add_to_contacts_list(data, true);
    /* update chatbox status */
    $(`.chat-box[data-uid="${data.user_id}"]`).find('.js_chat-box-status').removeClass('offline');
  });

  // [listen] user offline
  chat_socket.on('event_server_user_offline', (data) => {
    dlog("🔴 Offline:", data);
    /* add to offline contacts list */
    add_to_contacts_list(data, false);
    /* update chatbox status */
    $(`.chat-box[data-uid="${data.user_id}"]`).find('.js_chat-box-status').addClass('offline');
  });

  // [listen] message received
  chat_socket.on('event_server_message_received', (data) => {
    dlog("💬 Received message:", data);
    if (is_messages_page()) {
      /* check if there is opened thread */
      if ($('.panel-messages').data('cid') !== undefined) {
        var converstaion_widget = $('.panel-messages[data-cid="' + data.conversation.conversation_id + '"]');
        if (converstaion_widget.length > 0) {
          /* [1] check for a new messages for this thread */
          if (data.last_message) {
            converstaion_widget.find(".js_scroller:first ul").append(data.last_message);
            flyonui_init();
            converstaion_widget.find(".js_scroller:first").scrollTop(converstaion_widget.find(".js_scroller:first")[0].scrollHeight);
            if (!data.is_me) {
              /* update this convertaion seen status (if enabled by the system) */
              if (chat_seen_enabled) {
                chat_socket.emit('event_client_seen', { ids: [data.conversation.conversation_id] });
              }
              if (chat_sound) {
                $("#chat-sound")[0].play();
              }
            }
          }
          color_chat_box(converstaion_widget, data.conversation['color']);
        }
      }
    } else {
      /* update chat boxes */
      var chat_box_widget = $("#chat_" + data.conversation.conversation_id);
      if (chat_box_widget.length > 0) {
        chat_box_widget.find(".js_scroller:first ul").append(data.last_message);
        flyonui_init();
        chat_box_widget.find(".js_scroller:first").scrollTop(chat_box_widget.find(".js_scroller:first")[0].scrollHeight);
        if (!data.is_me) {
          if (!chat_box_widget.hasClass("opened")) {
            /* update the new messages counter */
            var messages_count = parseInt(chat_box_widget.find(".js_chat-box-label").text()) || 0;
            messages_count++;
            chat_box_widget.addClass("new").find(".js_chat-box-label").text(messages_count);
          } else {
            /* update this convertaion seen status (if enabled by the system) */
            if (chat_seen_enabled) {
              chat_socket.emit('event_client_seen', { ids: [data.conversation.conversation_id] });
            }
          }
          if (chat_sound) {
            $("#chat-sound")[0].play();
          }
        }
        color_chat_box(chat_box_widget, data.conversation['color']);
      } else {
        if (data.is_me) {
          chat_box(data.conversation.user_id, data.conversation.conversation_id, data.conversation.name, data.conversation.name_list, data.conversation.multiple_recipients, data.conversation.link, data.conversation.picture, true, data.conversation.page_id);
        } else {
          chat_socket.emit('event_client_get_conversation', { conversation_id: data.conversation.conversation_id }, function (response) {
            var conversation = JSON.parse(response);
            chat_box(conversation.user_id, conversation.conversation_id, conversation.name, conversation.name_list, conversation.multiple_recipients, conversation.link, conversation.picture, true, conversation.page_id);
            /* update this convertaion seen status (if enabled by the system) */
            if (chat_seen_enabled) {
              chat_socket.emit('event_client_seen', { ids: [data.conversation.conversation_id] });
            }
          });
        }
        if (chat_sound) {
          $("#chat-sound")[0].play();
        }
      }
    }
  });

  // [listen] page message received
  chat_socket.on('event_server_page_message_received', (data) => {
    dlog("💬 Received page message:", data);
    var converstaion_widget = $(`.panel-messages[data-as-page][data-cid="${data.conversation.conversation_id}"]`);
    if (converstaion_widget.length > 0 && data.last_message) {
      converstaion_widget.find(".js_scroller:first ul").append(data.last_message);
      flyonui_init();
      converstaion_widget.find(".js_scroller:first").scrollTop(converstaion_widget.find(".js_scroller:first")[0].scrollHeight);
      if (!data.is_me) {
        /* update this convertaion seen status */
        chat_socket.emit('event_client_seen', { ids: [data.conversation.conversation_id], as_page: 1 });
      }
    }
    if (!data.is_me && chat_sound) {
      $("#chat-sound")[0].play();
    }
    refresh_page_inbox(data.conversation.page_id);
  });

  // [listen] typing
  chat_socket.on('event_server_typing', (data) => {
    dlog("💬 Typing:", data);
    var conversation_id = data.conversation_id;
    /* check if (chatbox|thread) is opened */
    var converstaion_widget = $(`#chat_${conversation_id}, .panel-messages[data-cid="${conversation_id}"]`);
    if (converstaion_widget.length > 0) {
      if (data.typing_name_list) {
        converstaion_widget.find('.js_chat-typing-users').text(html_decode(data.typing_name_list));
        converstaion_widget.find('.chat-typing').show();
      } else {
        converstaion_widget.find('.js_chat-typing-users').text('');
        converstaion_widget.find('.chat-typing').hide();
      }
    }
  });

  // [listen] seen
  chat_socket.on('event_server_seen', (data) => {
    dlog("👀 Seen:", data);
    var conversation_id = data.conversation_id;
    /* check if (chatbox|thread) is opened */
    var converstaion_widget = $(`#chat_${conversation_id}, .panel-messages[data-cid="${conversation_id}"]`);
    if (converstaion_widget.length > 0) {
      var last_message_box = converstaion_widget.find('.js_scroller:first li:last .conversation.right');
      if (last_message_box.length > 0) {
        var seen_box = last_message_box.find('.seen');
        if (seen_box.length === 0) {
          last_message_box.find('.conversation-meta').append(`<span class="seen inline-flex items-center gap-1 text-primary"><span class="icon-[tabler--checks] size-3.5" aria-hidden="true"></span>${__['Seen by']} <span class="js_seen-name-list">${htmlEntities(html_decode(data.seen_name_list))}</span></span>`);
          converstaion_widget.find('.js_scroller:first').scrollTop(converstaion_widget.find('.js_scroller:first')[0].scrollHeight);
        } else {
          var current_seen_list = seen_box.find('.js_seen-name-list');
          var existing_names = current_seen_list.text().split(',').map(s => s.trim());
          var new_names = html_decode(data.seen_name_list).split(',').map(s => s.trim());
          var combined = [...new Set([...existing_names, ...new_names])];
          current_seen_list.text(combined.join(', '));
        }
      }
    }
  });

  chat_socket.on('event_server_message_reacted', (data) => {
    chat_update_reactions(data.message_id, data.reactions, data.reactions_total_count, data.reactions_total_count_formatted);
  });

  chat_socket.on('event_server_message_deleted', (data) => {
    chat_remove_message(data.message_id);
  });

  chat_socket.on('event_server_message_pinned', (data) => {
    var widget = $(`#chat_${data.conversation_id}, .panel-messages[data-cid="${data.conversation_id}"]`);
    if (widget.length && data.pin_html) {
      chat_apply_pin_html(widget, data.pin_html);
    }
  });

  // [listen] color
  chat_socket.on('event_server_color', (data) => {
    dlog("🎨 Color:", data);
    var conversation_id = data.conversation_id;
    /* check if (chatbox|thread) is opened */
    var converstaion_widget = $(`#chat_${conversation_id}, .panel-messages[data-cid="${conversation_id}"]`);
    if (converstaion_widget.length > 0) {
      color_chat_box(converstaion_widget, data.color);
    }
  });

  // [listen] conversation updated
  chat_socket.on('event_server_conversation_updated', (data) => {
    dlog("👥 Conversation updated:", data);
    if (data.removed_user_id && String(data.removed_user_id) === String(user_id)) {
      leave_group_conversation_ui(data.conversation_id);
      return;
    }
    if (!data.conversation_id) {
      return;
    }
    chat_socket.emit('event_client_get_conversation', { conversation_id: data.conversation_id }, function (response) {
      var conversation = JSON.parse(response);
      if (!conversation) {
        leave_group_conversation_ui(data.conversation_id);
        return;
      }
      apply_conversation_update(conversation);
    });
  });

  // [listen] chat box opened (from other tabs)
  chat_socket.on('event_server_chatbox_opened', (data) => {
    dlog("📦 Chat box opened from another tab:", data.conversation_id);
    if (is_messages_page()) {
      return;
    }
    chat_box(data.user_id, data.conversation_id, data.name, data.name_list, data.multiple_recipients, data.link, data.picture, false, data.page_id);
  });

  // [listen] chat box closed (from other tabs)
  chat_socket.on('event_server_chatbox_closed', (data) => {
    dlog("📦 Chat box closed from another tab:", data.conversation_id);
    $("#chat_" + data.conversation_id).remove();
    /* remove from local storage */
    remove_chatbox_from_local_storage(data.conversation_id);
    /* reconstruct chat widgets */
    reconstruct_chat_widgets();
  });

  // [listen] call received (➡️ receiver)
  chat_socket.on('event_server_call_received', (data) => {
    dlog("📞 Call received:", data.call_id);
    /* update chat ringing process */
    chat_ringing_process = true;
    /* show the ringing modal */
    var is_video = (data.type == "video") ? true : false;
    var is_audio = (data.type == "audio") ? true : false;
    var size = (data.type == "video") ? "call" : "call-audio";
    modal('#chat-ringing', { type: data.type, is_video: is_video, is_audio: is_audio, id: data.call_id, name: data.caller_name, picture: data.caller_picture }, size);
    /* play ringing sound */
    $('#chat-ringing-sound')[0].play();
  });

  // [listen] call canceled (➡️ receiver)
  chat_socket.on('event_server_call_canceled', (data) => {
    dlog("📞 Call canceled:", data.call_id);
    /* update chat ringing process */
    chat_ringing_process = false;
    /* close the ringing modal (if exist) */
    if ($('#modal').hasClass('open') && $('#modal').find('.js_chat-call-answer').length > 0) {
      modal_close();
    }
    /* stop ringing sound */
    $('#chat-ringing-sound')[0].stop();
  });

  // [listen] call declined (➡️ caller)
  chat_socket.on('event_server_call_declined', (data) => {
    dlog("📞 Call declined:", data.call_id);
    handle_declined_call();
  });

  // [listen] call ended (➡️ caller|receiver)
  chat_socket.on('event_server_call_ended', (data) => {
    dlog("📞 Call ended:", data.call_id);
    /* update chat calling process */
    chat_calling_process = false;
    /* stop calling sound */
    $("#chat-calling-sound")[0].stop();
    /* end the active call */
    call_ended(__['Call ended']);
  });

  // [listen] call answered (➡️ caller)
  chat_socket.on('event_server_call_answered', (data) => {
    dlog("📞 Call answered:", data.call_id);
    handle_answered_call(data);
  });
}


// update chat toggle status
function update_chat_toggle_status(status) {
  if (status == 'on') {
    $('body').data('chat-enabled', 0).attr('data-chat-enabled', '0');
    $('.chat-sidebar').addClass('disabled');
    $('.js_chat-toggle').data('status', 'off');
    $('.js_chat-toggle-text').html(__['Turn On Active Status']);
  } else {
    $('body').data('chat-enabled', 1).attr('data-chat-enabled', 1);
    $('.chat-sidebar').removeClass('disabled');
    $('.js_chat-toggle').data('status', 'on');
    $('.js_chat-toggle-text').html(__['Turn Off Active Status']);
  }
}


// add to contacts list
function add_to_contacts_list(user, is_online) {
  var offline_list = $('.js_chat-contacts-offline');
  var online_list = $('.js_chat-contacts-online');
  /* render contact html */
  var contact_html = `
    <button type="button" class="js_chat-start mx-2 flex w-[calc(100%-1rem)] items-center rounded-xl py-1 transition-colors hover:bg-base-200"
         data-uid="${user.user_id}"
         data-name="${user.user_fullname}"
         data-link="${user.user_name}"
         data-picture="${user.user_picture}"
         title="${user.user_fullname}"
         aria-label="${user.user_fullname}">
      <span class="grid w-[3.7rem] shrink-0 place-items-center">
        <span class="relative inline-flex">
          <img class="size-10 rounded-full object-cover" src="${user.user_picture}" alt="">
          ${user.user_is_online ? '<span class="absolute bottom-0 end-0 size-3 rounded-full bg-success ring-2 ring-base-100 group-[.disabled]/chat:hidden"></span>' : ''}
        </span>
      </span>
      <span class="min-w-0 flex-1 overflow-hidden whitespace-nowrap pe-3 text-start opacity-0 transition-opacity duration-150 group-hover/chat:opacity-100 group-has-[:focus-visible]/chat:opacity-100 group-has-[.dropdown.open]/chat:opacity-100 group-hover/chat:delay-200 group-has-[:focus-visible]/chat:delay-200 group-has-[.dropdown.open]/chat:delay-200">
        <span class="block truncate text-sm font-medium">${user.user_fullname}</span>
        ${!user.user_is_online ? `<span class="js_moment block truncate text-xs text-base-content/50" data-time="${user.user_last_seen}">${user.user_last_seen}</span>` : ''}
      </span>
    </button>
  `;
  /* update in place if already online */
  var online_contact = online_list.find(`[data-uid="${user.user_id}"]`);
  if (is_online && online_contact.length > 0) {
    online_contact.replaceWith(contact_html);
    return;
  }
  /* remove from both lists if exists */
  offline_list.find(`[data-uid="${user.user_id}"]`).remove();
  online_contact.remove();
  /* add to top of online/offline list */
  if (is_online) {
    var online_header = online_list.find('.js_chat-online-header');
    if (online_header.length > 0) {
      online_header.after(contact_html);
    } else {
      online_list.prepend(contact_html);
    }
  } else {
    offline_list.prepend(contact_html);
  }
  /* remove extra contacts if total is more than 20 */
  var total = online_list.find('.js_chat-start').length + offline_list.find('.js_chat-start').length;
  if (total > 20) {
    var to_remove = total - 20;
    offline_list.find('.js_chat-start').slice(-to_remove).remove();
  }
  /* update the online contacts counter */
  update_chat_online_count();
  /* run moment on the new contact */
  run_moment(is_online ? online_list : offline_list);
}


// update chat online count
function update_chat_online_count() {
  var online_count = $('.js_chat-contacts-online').find('.js_chat-start').length;
  $('.js_chat-online-count').text(online_count);
  $('.js_chat-online-header').toggleClass('flex', online_count > 0).toggleClass('hidden', online_count == 0);
}


// reset pending chat actions
function chat_reset_pending() {
  $('.chat-widget, .panel-messages').removeData('sending');
  $('#modal, #modal-stacked, .chat-widget, .panel-messages').find('button:disabled, a:disabled').each(function () {
    if ($(this).data('html') !== undefined) {
      button_status($(this), 'reset');
    }
  });
}


// is messages page (the page inbox url also contains "messages")
function is_messages_page() {
  return is_page('messages') && $('.js_page-inbox').length == 0;
}


// html decode
function html_decode(value) {
  return $('<textarea/>').html(value || '').text();
}


// chat box
function chat_box(user_id, conversation_id, name, name_list, multiple, link, picture, emit_event = true, page_id = null) {
  if (is_messages_page() || is_mobile()) {
    return;
  }
  name = html_decode(name);
  name_list = html_decode(name_list);
  /* open the #chat_key */
  var chat_key_value = 'chat_';
  chat_key_value += (conversation_id) ? conversation_id : ((page_id) ? `p_${page_id}` : `u_${user_id}`);
  var chat_key = `#${chat_key_value}`;
  var chat_box = $(chat_key);
  /* check if this chat_box already exists OR any chatbox with the same (user_id|page_id) is opened */
  var chat_box_same = (page_id) ? $(`.chat-box[data-page-id="${page_id}"]`) : $(`.chat-box[data-uid="${user_id}"]`);
  if (chat_box.length == 0 && chat_box_same.length == 0) {
    var data = (conversation_id) ? { 'conversation_id': conversation_id } : ((page_id) ? { 'page_id': page_id } : { 'user_id': user_id });
    /* construct a new chat-box */
    $('body').append(render_template('#chat-box', { 'chat_key_value': chat_key_value, 'user_id': user_id, 'page_id': page_id, 'conversation_id': conversation_id, 'name': name.substring(0, 28), 'name_list': name_list, 'multiple': multiple, 'link': link, 'picture': picture }));
    chat_box = $(chat_key);
    chat_box.find('.chat-widget-content').show();
    chat_box.find('textarea').trigger('focus');
    /* initialize the plugins */
    initialize();
    flyonui_init();
    /* reconstruct chat-widgets */
    reconstruct_chat_widgets();
    /* get conversation messages */
    $.getJSON(api['chat/messages'], data, function (response) {
      /* check the response */
      if (!response) return;
      /* check if there is a callback */
      if (response.callback) {
        chat_box.remove();
        eval(response.callback);
        return;
      }
      /* handle response */
      if (response.conversation_id) {
        conversation_id = response.conversation_id;
        chat_box.attr('id', `chat_${conversation_id}`).attr('data-cid', conversation_id);
        chat_box.find('.x-form-tools-colors').removeClass('hidden');
      }
      if (response.messages) {
        chat_box.find('.js_scroller:first').html(response.messages).scrollTop(chat_box.find('.js_scroller:first')[0].scrollHeight);
        flyonui_init();
      }
      if (response.pin_html !== undefined) {
        chat_apply_pin_html(chat_box, response.pin_html);
      }
      if (response.color) {
        chat_box.attr('data-color', response.color);
        color_chat_box(chat_box, response.color);
      }
      if (response.chat_price) {
        chat_box.attr('data-chat-price', response.chat_price);
      }
      if (response.call_price) {
        chat_box.attr('data-call-price', response.call_price);
      }
      if (response.user_online !== undefined && response.user_online) {
        chat_box.find('.js_chat-box-status').removeClass('offline');
      }
      if (response.picture_left) {
        var group_avatar = chat_box.find('.js_chat-group-avatar').empty().removeClass('items-center justify-center');
        $('<span class="h-full w-1/2 bg-cover bg-center"></span>').css('background-image', 'url("' + response.picture_left + '")').appendTo(group_avatar);
        $('<span class="h-full w-1/2 border-s-2 border-base-100 bg-cover bg-center"></span>').css('background-image', 'url("' + response.picture_right + '")').appendTo(group_avatar);
      }
      if (response.picture) {
        picture = response.picture;
        chat_box.find('.chat-user-card .avatar img').attr('src', picture);
        chat_box.find('.js_chat-call-start').attr('data-picture', picture);
      }
    })
      .done(function () {
        if (conversation_id && chat_socket_enabled) {
          var chatbox = {
            user_id: user_id,
            page_id: page_id,
            conversation_id: conversation_id,
            name: name,
            name_list: name_list,
            multiple_recipients: multiple,
            link: link,
            picture: picture
          }
          if (emit_event) {
            chat_socket.emit('event_client_open_chatbox', chatbox);
          }
          add_chatbox_to_local_storage(chatbox);
        }
      })
      .fail(function () {
        /* remove the chat-box */
        chat_box.remove();
        show_error_modal();
      });
  } else {
    if (chat_box.length == 0) {
      chat_box = chat_box_same;
    }
    if (!chat_box.hasClass('opened')) {
      chat_box.addClass('opened').find('.chat-widget-content').slideToggle(200);
    }
    chat_box.find('textarea').trigger('focus');
  }
}


// add chatbox to local storage
function add_chatbox_to_local_storage(chatbox) {
  var chatboxes = localStorage.getItem(`chatboxes_${user_id}`);
  if (!chatboxes) {
    chatboxes = [];
  } else {
    chatboxes = JSON.parse(chatboxes);
    var existing = chatboxes.findIndex(cb => cb.conversation_id === chatbox.conversation_id);
    if (existing !== -1) {
      chatboxes[existing] = chatbox;
      localStorage.setItem(`chatboxes_${user_id}`, JSON.stringify(chatboxes));
      return;
    }
  }
  chatboxes.push(chatbox);
  localStorage.setItem(`chatboxes_${user_id}`, JSON.stringify(chatboxes));
}


// remove chatbox from local storage
function remove_chatbox_from_local_storage(conversation_id) {
  var chatboxes = localStorage.getItem(`chatboxes_${user_id}`);
  if (chatboxes) {
    chatboxes = JSON.parse(chatboxes);
    chatboxes = chatboxes.filter(function (chatbox) {
      return chatbox.conversation_id != conversation_id;
    });
    localStorage.setItem(`chatboxes_${user_id}`, JSON.stringify(chatboxes));
  }
}


// color chat box
function color_chat_box(chat_widget, color) {
  chat_widget.data('color', color);
  chat_widget.find('.js_chat-color-me').each(function () {
    if ($(this).hasClass('js_chat-colors-menu-toggle')) {
      $(this).css('color', color);
    } else if ($(this).hasClass('button')) {
      $(this).css({ '--button-bg': color, '--button-bg-hover': color, '--button-bg-pressed': color });
    } else {
      $(this).css('background-color', color);
    }
  });
}


// reconstruct chat-widgets
function reconstruct_chat_widgets() {
  if (is_mobile()) {
    return;
  }
  var widget_width = 330;
  var widget_gap = 10;
  var widget_start = 90;
  var widget_edge = 16;
  /* close the oldest chat-widget when there is no room */
  var widgets = $('.chat-widget');
  var max_widgets = Math.max(1, Math.floor((window.innerWidth - widget_start - widget_edge + widget_gap) / (widget_width + widget_gap)));
  if (widgets.length > max_widgets) {
    widgets.first().find('.js_chat-box-close').first().trigger('click');
    return;
  }
  widgets.each(function (index) {
    $(this).attr('style', '');
    var offset = widget_start + (index * (widget_width + widget_gap));
    if ($('html').attr('dir') == 'rtl') {
      $(this).css('left', offset);
    } else {
      $(this).css('right', offset);
    }
  });
}


// size messages page conversation scroller
function size_messages_scroller(pin_bottom) {
  if (!is_messages_page()) return;
  var host = document.querySelector('.js_conversation-container');
  var panel = host ? host.querySelector('.panel-messages') : null;
  var scroller = panel ? panel.querySelector('.chat-conversations') : null;
  if (!host || !panel || !scroller) return;
  var used = 0;
  Array.prototype.forEach.call(panel.children, function (child) {
    if (child !== scroller) used += child.offsetHeight;
  });
  var main = document.querySelector('main.site-content');
  var pad = (main ? (parseFloat(getComputedStyle(main).paddingBottom) || 0) : 0) + (parseFloat(getComputedStyle(document.body).paddingBottom) || 0);
  var visible = window.innerHeight - host.getBoundingClientRect().top - pad;
  var available = Math.floor(visible - used);
  if (available < 80) return;
  var from_bottom = scroller.scrollHeight - scroller.scrollTop;
  scroller.style.overflowY = 'auto';
  scroller.style.height = available + 'px';
  scroller.style.maxHeight = available + 'px';
  scroller.scrollTop = pin_bottom ? scroller.scrollHeight : Math.max(0, scroller.scrollHeight - from_bottom);
}


// chat message actions
function chat_widget_from(element) {
  return $(element).closest('.chat-widget, .panel-messages');
}

function chat_clear_reply(widget) {
  widget.removeData('reply-to').removeData('reply-preview');
  widget.find('.js_chat-reply-bar').addClass('hidden').removeClass('flex');
}

function chat_set_reply(widget, id, name, snippet) {
  widget.data('reply-to', id);
  widget.data('reply-preview', { id: id, name: name, snippet: snippet });
  widget.find('.js_chat-reply-name').text(name || '');
  widget.find('.js_chat-reply-snippet').text(snippet || '');
  widget.find('.js_chat-reply-bar').removeClass('hidden').addClass('flex');
  widget.find('textarea').trigger('focus');
}

function chat_reply_fields(widget) {
  var reply_to = widget.data('reply-to');
  return reply_to ? { reply_to: reply_to } : {};
}

function chat_clear_product(widget) {
  widget.removeData('product');
  widget.find('.js_chat-product-bar').addClass('hidden').removeClass('flex');
}

function chat_set_product(widget, product) {
  if (!widget.length || !product || !product.id) return;
  widget.data('product', product);
  widget.find('.js_chat-product-name').text(product.name || '').attr('title', product.name || '');
  widget.find('.js_chat-product-price').text(product.price || '');
  widget.find('.js_chat-product-image').attr('src', product.image || '').toggleClass('hidden', !product.image);
  widget.find('.js_chat-product-bar').removeClass('hidden').addClass('flex');
  widget.find('textarea').trigger('focus');
}

function chat_product_fields(widget) {
  var product = widget.data('product');
  return product ? { product_post_id: product.id } : {};
}

function chat_page_fields(widget) {
  return widget.data('as-page') ? { as_page: 1 } : {};
}


// refresh page inbox
function refresh_page_inbox(page_id) {
  var inbox = $(`.js_page-inbox[data-page-id="${page_id}"]`);
  if (inbox.length == 0) return;
  $.getJSON(api['chat/conversation/page_inbox'], { 'page_id': page_id, 'cid': $('.panel-messages[data-as-page]').data('cid') }, function (response) {
    if (!response || response.callback) return;
    var list = inbox.children('ul');
    if (list.length == 0) {
      inbox.html('<ul class="m-0 flex list-none flex-col gap-1 p-0"></ul>');
      list = inbox.children('ul');
    }
    list.html(response.inbox);
    run_moment(inbox);
    $('.js_page-inbox-counter').text(response.unseen_count).toggleClass('hidden', response.unseen_count == 0);
  });
}

function chat_apply_pin_html(widget, html) {
  var wrap = widget.find('.js_chat-pin-wrap');
  if (wrap.length) {
    wrap.replaceWith(html);
  } else {
    widget.find('.chat-conversations').first().before(html);
  }
  size_messages_scroller();
}

function chat_message_el(message_id) {
  return $(document.getElementById(String(message_id)));
}

function chat_remove_message(message_id) {
  var row = chat_message_el(message_id).closest('li');
  row.remove();
  $('.js_chat-pin-jump[data-id="' + message_id + '"]').closest('.js_chat-pin').remove();
}

function chat_update_reactions(message_id, reactions, total, formatted) {
  var conversation = chat_message_el(message_id);
  if (!conversation.length) return;
  var stats = conversation.find('.js_chat-reactions-stats');
  if (!total) {
    reactions_stats_update(stats, '', function () {
      stats.remove();
    });
    return;
  }
  var html = '<div class="reactions-stats flex cursor-pointer items-center">';
  var z = 10;
  $.each(reactions, function (type, count) {
    if (parseInt(count, 10) > 0) {
      html += '<div class="reactions-stats-item relative -ms-1 flex rounded-full bg-base-100 p-px ring-1 ring-base-100 first:ms-0" style="z-index:' + (z--) + ';"><div class="inline-emoji no_animation inline-flex size-4">' + $('.js_react-message[data-reaction="' + type + '"] img').first().closest('.emoji').prop('outerHTML') + '</div></div>';
    }
  });
  html += '<span class="ps-1 text-[11px] text-base-content/60">' + (formatted || total) + '</span></div>';
  if (!stats.length) {
    stats = $('<div class="js_chat-reactions-stats js_modal" data-url="posts/who_reacts.php?message_id=' + message_id + '"></div>');
    conversation.find('.conversation-body').children('.conversation-meta').before(stats);
  }
  reactions_stats_update(stats, html);
}


// group chat messages
function group_chat_messages(scroller) {
  var list = $(scroller).children('ul').last();
  if (list.length == 0) return;
  var locale = $('html').data('lang') || 'en-us';
  var from_bottom = scroller.scrollHeight - scroller.scrollTop;
  var previous = null;
  list.children('li.js_chat-date').remove();
  list.children('li').each(function () {
    var item = $(this);
    var time = moment.utc(item.find('.time:first').data('time'), ["YYYY-MM-DD HH:mm:ss", "YYYY-MM-DD H:mm:ss", moment.ISO_8601]).local();
    if (!time.isValid()) return;
    var sender = item.children('.conversation').hasClass('right') ? 'me' : item.data('uid');
    var same_day = !!(previous && previous.time.isSame(time, 'day'));
    var is_grouped = same_day && previous.sender == sender && time.diff(previous.time, 'minutes') < 5;
    item.toggleClass('chat-cont', is_grouped);
    if (previous) {
      previous.item.toggleClass('chat-more', is_grouped);
    }
    if (!same_day) {
      item.before(`<li class="js_chat-date divider my-1 text-xs! font-medium text-base-content/45" role="separator">${chat_date_label(time, locale)}</li>`);
    }
    previous = { item: item, time: time, sender: sender };
  });
  if (previous) {
    previous.item.removeClass('chat-more');
  }
  scroller.scrollTop = scroller.scrollHeight - from_bottom;
}


// chat date label
function chat_date_label(time, locale) {
  var days = Math.max(0, moment().startOf('day').diff(time.clone().startOf('day'), 'days'));
  if (days < 2 && window.Intl && Intl.RelativeTimeFormat) {
    try {
      var label = new Intl.RelativeTimeFormat(String(locale).replace('_', '-'), { numeric: 'auto' }).format(-days, 'day');
      return label.charAt(0).toUpperCase() + label.slice(1);
    } catch (e) { }
  }
  return time.clone().locale(locale).format((days < 7) ? 'dddd' : 'LL');
}


// init chat messages grouping
function init_chat_messages_grouping() {
  $('.chat-conversations').each(function () {
    group_chat_messages(this);
  });
  if (!window.MutationObserver) return;
  var is_message_node = function (node) {
    return node.nodeType == 1 && !$(node).hasClass('js_chat-date') && ($(node).is('ul, li') || $(node).find('.chat-conversations, .conversation').length > 0);
  };
  new MutationObserver(function (mutations) {
    var scrollers = new Set();
    mutations.forEach(function (mutation) {
      var nodes = Array.from(mutation.addedNodes).concat(Array.from(mutation.removedNodes));
      if (!nodes.some(is_message_node)) return;
      $(mutation.target).closest('.chat-conversations').each(function () {
        scrollers.add(this);
      });
      $(mutation.addedNodes).find('.chat-conversations').addBack('.chat-conversations').each(function () {
        scrollers.add(this);
      });
    });
    scrollers.forEach(group_chat_messages);
  }).observe(document.body, { childList: true, subtree: true });
}


// search chat threads
var chat_threads_search_xhr = null;
var chat_threads_search_timer = null;
var chat_threads_default_html = null;
function search_chat_threads() {
  var threads = $('.js_live-messages-alt');
  var scroller = threads.find('.js_scroller:first');
  if (scroller.length == 0) return;
  var query = ($('.js_chat-threads-search').val() || '').toString().trim();
  var filter = $('.js_chat-threads-filter[aria-pressed="true"]').data('filter') || 'all';
  if (chat_threads_search_xhr) {
    chat_threads_search_xhr.abort();
  }
  /* back to the default threads */
  if (query === '' && filter == 'all') {
    if (!threads.data('searching')) return;
    threads.removeData('searching');
    scroller.html(chat_threads_default_html);
    chat_threads_default_html = null;
    if (threads.data('stale')) {
      threads.removeData('stale');
      $.post(api['data/load'], { 'get': 'conversations', 'offset': 0 }, function (response) {
        if (!response.data || threads.data('searching')) return;
        scroller.find('ul:first').html(response.data);
        scroller.find('.js_see-more').removeData('offset').removeClass('done');
        run_moment(scroller);
        mark_active_chat_thread();
      }, 'json');
    }
    mark_active_chat_thread();
    return;
  }
  /* search */
  if (!threads.data('searching')) {
    chat_threads_default_html = scroller.html();
    threads.data('searching', true);
  }
  scroller.html('<div class="flex justify-center py-10"><span class="loading loading-spinner loading-sm"></span></div>');
  chat_threads_search_xhr = $.getJSON(api['chat/search'], { 'query': query, 'filter': filter, 'active_cid': $('.panel-messages').data('cid') || 0 }, function (response) {
    if (response.callback) {
      eval(response.callback);
      return;
    }
    scroller.html(response.html);
    run_moment(scroller);
  })
    .fail(function (jqXHR, textStatus) {
      if (textStatus === 'abort') return;
      show_error_modal();
    });
}


// mark active chat thread
function mark_active_chat_thread() {
  var active_cid = $('.panel-messages').data('cid');
  if (!active_cid) return;
  $('.js_live-messages-alt .js_chat-start[data-cid="' + active_cid + '"]').closest('li.feeds-item').addClass('is-active');
}


// open messages thread
function open_messages_thread(conversation_id, name, picture) {
  if (conversation_get_xhr) {
    conversation_get_xhr.abort();
  }
  $(".js_conversation-container").html(render_template('#conversation-loading', { 'name': name, 'picture': picture }));
  conversation_get_xhr = $.getJSON(api['chat/conversation/get'], { 'conversation_id': conversation_id }, function (response) {
    /* check if there is a callback */
    if (response.callback) {
      eval(response.callback);
      return;
    }
    /* handle response */
    $(".js_conversation-container").html(response.conversation_html);
    flyonui_init();
    /* update the thread as seen */
    $('.js_live-messages-alt .js_chat-start[data-cid="' + conversation_id + '"]').closest('li.feeds-item').removeClass('unread');
    $('.panel-messages').attr("data-color", response.conversation.color);
    color_chat_box($('.panel-messages'), response.conversation.color);
    requestAnimationFrame(function () {
      size_messages_scroller(true);
      setTimeout(function () {
        size_messages_scroller(true);
      }, 50);
    });
  })
    .done(function () {
      if (chat_socket_enabled) {
        chat_socket.emit('event_client_open_thread', { conversation_id: conversation_id });
        if (chat_seen_enabled) {
          chat_socket.emit('event_client_seen', { ids: [conversation_id] });
        }
      }
    })
    .fail(function (jqXHR, textStatus) {
      if (textStatus === 'abort') return;
      show_error_modal();
    });
}


// chat heartbeat
function chat_heartbeat() {
  /* check if there is any closing process */
  if (chatbox_closing_process) {
    setTimeout('chat_heartbeat()', min_chat_heartbeat);
    return;
  }
  /* check if chat disabled and not in messages page */
  if (!chat_enabled && !is_messages_page() && $('.panel-messages[data-as-page]').length == 0) {
    return;
  }
  /* prepare client opened chat boxes with its last messages */
  var chat_boxes_opened_client = {}; // we use "objects" because JS don't support user-indexed array ;)
  $.each($('.chat-box:not(.fresh)'), function (i, chat_box) {
    if (!$(chat_box).data('sending')) {
      chat_boxes_opened_client[$(chat_box).data('cid')] = $(chat_box).find('.conversation:last').attr('id'); // object = {"cid": "last_message", ....}
    }
  });
  /* check if there is opened thread */
  if ($('.panel-messages').data('cid') !== undefined) {
    /* add the current loaded converstion */
    var opened_thread = {};
    if (!$('.panel-messages').data('sending')) {
      opened_thread['conversation_id'] = $('.panel-messages').data('cid');
      opened_thread['last_message_id'] = $('.panel-messages').find('.conversation:last').attr('id');
      if ($('.panel-messages').data('as-page')) {
        opened_thread['as_page'] = 1;
      }
    }
    /* prepare data */
    var data = { 'chat_enabled': $('body').data('chat-enabled'), 'chat_boxes_opened_client': JSON.stringify(chat_boxes_opened_client), 'opened_thread': JSON.stringify(opened_thread) };
  } else {
    /* prepare data */
    var data = { 'chat_enabled': $('body').data('chat-enabled'), 'chat_boxes_opened_client': JSON.stringify(chat_boxes_opened_client) };
  }
  /* post to the server and get updates */
  $.post(api['chat/live'], data, function (response) {
    /* check if there is a callback */
    if (response.callback) {
      eval(response.callback);
      return;
    }
    /* handle response */
    /* init updated seen conversations if any */
    var updated_seen_conversations = [];
    /* [1] [update] master chat sidebar (contacts list) */
    /* [2] [update] master chat sidebar (chat status) */
    if (response.master) {
      $('body').attr('data-chat-enabled', response.master.chat_enabled);
      /* replace the contacts only when they changed */
      var chat_sidebar = $('.chat-sidebar-content');
      if (chat_sidebar.data('sidebar-html') !== response.master.sidebar) {
        chat_sidebar.data('sidebar-html', response.master.sidebar);
        chat_sidebar.find('.js_scroller').html(response.master.sidebar);
        run_moment(chat_sidebar);
        $('.tooltip[class*="bs-tooltip"]').remove();
      }
    }
    /* [3] & [4] & [5] & [6] check if the user not in messages page */
    if (!is_messages_page()) {
      /* [3] [get] closed chat boxes */
      if (response.chat_boxes_closed !== undefined) {
        $.each(response.chat_boxes_closed, function (i, conversation) {
          $(`#chat_${conversation}`).remove();
        });
        /* reconstruct chat-widgets */
        reconstruct_chat_widgets();
      }
      /* [4] [get] opened chat boxes */
      if (response.chat_boxes_opened) {
        $.each(response.chat_boxes_opened, function (i, conversation) {
          chat_box(conversation.user_id, conversation.conversation_id, conversation.name, conversation.name_list, conversation.multiple_recipients, conversation.link, conversation.picture, true, conversation.page_id);
        });
      }
      /* [5] [get] updated chat boxes */
      if (response.chat_boxes_updated) {
        $.each(response.chat_boxes_updated, function (i, conversation) {
          var chat_box_widget = $(`#chat_${conversation['conversation_id']}`);
          /* [1] check for a new messages for this chat box */
          if (conversation['messages']) {
            chat_box_widget.find('.js_scroller:first ul').append(conversation['messages']);
            flyonui_init();
            chat_box_widget.find('.js_scroller:first').scrollTop(chat_box_widget.find('.js_scroller:first')[0].scrollHeight);
            if (!conversation['is_me']) {
              if (!chat_box_widget.hasClass('opened')) {
                /* update the new messages counter */
                chat_box_widget.addClass('new').find('.js_chat-box-label').text(conversation['messages_count']);
              } else {
                /* update this convertaion seen status (if enabled by the system) */
                if (chat_seen_enabled) {
                  updated_seen_conversations.push(conversation['conversation_id']);
                }
              }
              if (chat_sound) {
                $('#chat-sound')[0].play();
              }
            }
          }
          /* [2] check if any recipient typing */
          if (conversation['typing_name_list']) {
            chat_box_widget.find('.js_chat-typing-users').text(html_decode(conversation['typing_name_list']));
            chat_box_widget.find('.chat-typing').show();
          } else {
            chat_box_widget.find('.chat-typing').hide();
          }
          /* [3] check if any recipient seeing */
          if (conversation['seen_name_list']) {
            var last_message_box = chat_box_widget.find('.js_scroller:first li:last .conversation.right');
            if (last_message_box.length > 0) {
              if (last_message_box.find('.seen').length == 0) {
                /* add seen status */
                last_message_box.find('.conversation-meta').append(`<span class="seen inline-flex items-center gap-1 text-primary"><span class="icon-[tabler--checks] size-3.5" aria-hidden="true"></span>${__['Seen by']} <span class="js_seen-name-list">${htmlEntities(html_decode(conversation['seen_name_list']))}</span></span>`);
                chat_box_widget.find('.js_scroller:first').scrollTop(chat_box_widget.find('.js_scroller:first')[0].scrollHeight);
              } else {
                /* update seen status */
                last_message_box.find('.seen .js_seen-name-list').text(html_decode(conversation['seen_name_list']));
              }
            }
          }
          /* [4] check single user's chat status (online|offline) */
          if (!conversation['multiple_recipients']) {
            /* update single user's chat status */
            if (conversation['user_online']) {
              chat_box_widget.find('.js_chat-box-status').removeClass('offline');
            } else {
              chat_box_widget.find('.js_chat-box-status').addClass('offline');
            }
          }
          /* [5] update chat widget color */
          color_chat_box(chat_box_widget, conversation['color']);
        });
      }
      /* [6] [get] new chat boxes */
      if (response.chat_boxes_new) {
        $.each(response.chat_boxes_new, function (i, conversation) {
          chat_box(conversation.user_id, conversation.conversation_id, conversation.name, conversation.name_list, conversation.multiple_recipients, conversation.link, conversation.picture, true, conversation.page_id);
          if (chat_sound) {
            $('#chat-sound')[0].play();
          }
        });
      }
    }
    /* [7] [get] updated thread */
    if (response.thread_updated) {
      /* check if there is opened thread */
      if ($('.panel-messages').data('cid') !== undefined) {
        var converstaion_widget = $(`.panel-messages[data-cid="${response.thread_updated['conversation_id']}"]`);
        if (converstaion_widget.length > 0) {
          /* [1] check for a new messages for this thread */
          if (response.thread_updated['messages']) {
            converstaion_widget.find('.js_scroller:first ul').append(response.thread_updated['messages']);
            flyonui_init();
            converstaion_widget.find('.js_scroller:first').scrollTop(converstaion_widget.find('.js_scroller:first')[0].scrollHeight);
            if (!response.thread_updated['is_me']) {
              /* update this convertaion seen status (if enabled by the system) */
              if (converstaion_widget.data('as-page')) {
                $.post(api['chat/actions'], { 'do': 'seen', 'ids': [response.thread_updated['conversation_id']], 'as_page': 1 }, 'json');
              } else if (chat_seen_enabled) {
                updated_seen_conversations.push(response.thread_updated['conversation_id']);
              }
              if (chat_sound) {
                $('#chat-sound')[0].play();
              }
            }
          }
          /* [2] check if any recipient typing */
          if (response.thread_updated['typing_name_list']) {
            converstaion_widget.find('.js_chat-typing-users').text(html_decode(response.thread_updated['typing_name_list']));
            converstaion_widget.find('.chat-typing').show();
          } else {
            converstaion_widget.find('.chat-typing').hide();
          }
          /* [3] check if any recipient seeing */
          if (response.thread_updated['seen_name_list']) {
            var last_message_box = converstaion_widget.find('.js_scroller:first li:last .conversation.right');
            if (last_message_box.length > 0) {
              if (last_message_box.find('.seen').length == 0) {
                /* add seen status */
                last_message_box.find('.conversation-meta').append(`<span class="seen inline-flex items-center gap-1 text-primary"><span class="icon-[tabler--checks] size-3.5" aria-hidden="true"></span>${__['Seen by']} <span class="js_seen-name-list">${htmlEntities(html_decode(response.thread_updated['seen_name_list']))}</span></span>`);
                converstaion_widget.find('.js_scroller:first').scrollTop(converstaion_widget.find('.js_scroller:first')[0].scrollHeight);
              } else {
                /* update seen status */
                last_message_box.find('.seen .js_seen-name-list').text(html_decode(response.thread_updated['seen_name_list']));
              }
            }
          }
          /* [4] update chat widget color */
          color_chat_box(converstaion_widget, response.thread_updated['color']);
        }
      }
    }
    /* [8] [get] new calls (audio|video) */
    if (response.has_call == true) {
      if (chat_incall_process == false && chat_ringing_process == false) {
        /* update chat ringing process */
        chat_ringing_process = true;
        /* show the ringing modal */
        var type = response.call['is_video_call'] == 1 ? 'video' : 'audio';
        var is_audio = (type == 'audio') ? true : false;
        var is_video = (type == 'video') ? true : false;
        var size = (type == 'video') ? 'call' : 'call-audio';
        modal('#chat-ringing', { type: type, is_video: is_video, is_audio: is_audio, id: response.call['call_id'], name: response.call['caller_name'], picture: response.call['caller_picture'] }, size);
        /* play ringing sound */
        $('#chat-ringing-sound')[0].play();
      }
    } else {
      if (chat_incall_process == false && chat_ringing_process == true) {
        /* update chat ringing process */
        chat_ringing_process = false;
        /* close the ringing modal (if exist) */
        if ($('#modal').hasClass('open') && $('#modal').find('.js_chat-call-answer').length > 0) {
          modal_close();
        }
        /* stop ringing sound */
        $('#chat-ringing-sound')[0].stop();
      }
    }
    // update convertaion(s) seen status
    if (chat_seen_enabled && updated_seen_conversations.length > 0) {
      $.post(api['chat/actions'], { 'do': 'seen', 'ids': updated_seen_conversations }, function (response) {
        /* check if there is a callback */
        if (response.callback) {
          eval(response.callback);
          return;
        }
      }, 'json');
    }
    setTimeout('chat_heartbeat()', min_chat_heartbeat);
  }, 'json');
}


// create call
function create_call(type, user_id, name, picture) {
  /* show the calling modal */
  var is_video = (type == "video") ? true : false;
  var is_audio = (type == "audio") ? true : false;
  var size = (type == "video") ? "call" : "call-audio";
  modal('#chat-calling', { type: type, is_video: is_video, is_audio: is_audio, name: name, picture: picture }, size);
  if (chat_socket_enabled) {
    /* using socket */
    chat_socket.emit('event_client_create_call', { type: type, id: user_id }, function (response) {
      handle_create_call_response(JSON.parse(response));
    });
  } else {
    /* using ajax */
    $.post(api['chat/call'], { 'do': 'create_call', 'type': type, 'id': user_id }, function (response) {
      /* check if there is a callback */
      if (response.callback) {
        eval(response.callback);
        return;
      }
      handle_create_call_response(response.call);
    }, 'json')
      .fail(function () {
        show_error_modal();
      });
  }
}


// handle create call response
function handle_create_call_response(call) {
  /* handle response */
  switch (call) {
    case false:
      call_ui_failed(__['You can not connect to this user']);
      break;

    case "recipient_offline":
      call_ui_failed(__['is Offline']);
      break;

    case "recipient_busy":
      call_ui_failed(__['is Busy']);
      break;

    case "caller_busy":
      call_ui_failed(__['You have an active call already']);
      break;

    default:
      $(".js_chat-call-cancel").attr("data-id", call.call_id).data("id", call.call_id).prop("hidden", false);
      $('.js_chat-calling-message').html(__['Ringing'] + '<span class="loading loading-dots loading-xs ms-1 align-middle" aria-hidden="true"></span>');
      /* update chat calling process */
      chat_calling_process = true;
      /* play calling sound */
      $("#chat-calling-sound")[0].play();
      /* check calling response (after 2 seconds) */
      if (!chat_socket_enabled) {
        calling_response = setTimeout(function () {
          check_calling_response(call.call_id);
        }, 2000);
      }
      /* if there is no response end the call (after 42 seconds) */
      chat_ending_call_timeout = setTimeout(function () {
        chat_calling_process = false;
        call_ui_failed(__['No Answer']);
        $("#chat-calling-sound")[0].stop();
        /* end call */
        if (chat_socket_enabled) {
          chat_socket.emit('event_client_cancel_call', { id: call.call_id });
        } else {
          $.post(api['chat/call'], { 'do': 'cancel_call', 'id': call.call_id }, function (response) {
            /* check if there is a callback */
            if (response.callback) {
              eval(response.callback);
              return;
            }
          }, 'json')
            .fail(function () {
              show_error_modal();
            });
        }
      }, 42000);
      break;
  }
}


// check calling response
function check_calling_response(call_id) {
  /* check if there is chat calling process */
  if (chat_calling_process == false) {
    return;
  }
  $.post(api['chat/call'], { 'do': 'check_calling_response', 'id': call_id }, function (response) {
    /* check if there is a callback */
    if (response.callback) {
      eval(response.callback);
      return;
    }
    /* handle response */
    switch (response.call) {
      /* no answer */
      case "no_answer":
        /* check calling response (after 2 seconds) */
        setTimeout(function () {
          check_calling_response(call_id);
        }, 2000);
        break;

      /* declined */
      case "declined":
        handle_declined_call();
        break;

      /* answered */
      default:
        handle_answered_call(response.call);
        break;
    }
  }, 'json')
    .fail(function () {
      show_error_modal();
    });
}


// handle declined call
function handle_declined_call() {
  /* update chat calling process */
  chat_calling_process = false;
  /* update the call ui */
  call_ui_failed(__['Declined the call']);
  /* stop calling sound */
  $("#chat-calling-sound")[0].stop();
  /* remove the ending call callback timeout */
  clearTimeout(chat_ending_call_timeout);
}


// handle answered call
function handle_answered_call(call, is_caller = true) {
  var type = (call.is_video_call == '1') ? "video" : "audio";
  chat_incall_process = true;
  chat_call = { call_id: call['call_id'], is_video: (type == "video"), ended: false, mic: null, camera: null, leave: null };
  chat_incall_heartbeat(call['call_id']);
  if (is_caller) {
    var token = call['from_user_token'];
    chat_calling_process = false;
  } else {
    var token = call['to_user_token'];
    chat_ringing_process = false;
  }
  /* update the call ui */
  $('.js_call-actions, .js_call-pulse').prop('hidden', true);
  $('.js_call-controls').prop('hidden', false);
  $(".js_chat-call-end").attr("data-id", call['call_id']).data("id", call['call_id']);
  if (!document.fullscreenEnabled && !document.webkitFullscreenEnabled) {
    $('.js_call-fullscreen').prop('hidden', true);
  }
  /* update call timer */
  var call_start = Date.now();
  clearInterval(chat_call_timer);
  chat_call_timer = setInterval(function () {
    var timer = $('.js_call-timer, .js_chat-calling-message');
    if (!timer.length) {
      clearInterval(chat_call_timer);
      return;
    }
    timer.text(format_timer((Date.now() - call_start) / 1000, true));
  }, 1000);
  /* stop calling sound */
  if (is_caller) {
    $("#chat-calling-sound")[0].stop();
  } else {
    $("#chat-ringing-sound")[0].stop();
  }
  /* remove the ending call callback timeout */
  clearTimeout(chat_ending_call_timeout);
  if (audio_video_provider == "twilio") {
    /* init Twilio */
    init_Twilio(type, token, call['room']);
  } else if (audio_video_provider == "livekit") {
    /* init LiveKit */
    init_LiveKit(type, token, call['room']);
  } else if (audio_video_provider == "agora") {
    /* init Agora */
    init_Agora(type, token, call['room']);
  }
}


// chat incall heartbeat
function chat_incall_heartbeat(call_id) {
  if (chat_incall_process == false) return;
  setTimeout(function () {
    chat_incall_heartbeat(call_id);
  }, 10000);
  if (chat_socket_enabled) {
    chat_socket.emit('event_client_update_call', { id: call_id });
  } else {
    $.post(api['chat/call'], { 'do': 'update_call', 'id': call_id }, 'json');
  }
}


// call ui failed
function call_ui_failed(message) {
  $('.js_chat-call-cancel, .js_call-pulse').prop('hidden', true);
  $('.js_chat-call-close').prop('hidden', false);
  $('.js_chat-calling-message').html($('<span class="text-error"></span>').text(message));
}


// call ui remote video
function call_ui_remote_video(visible) {
  $('.video-call-stream').prop('hidden', !visible);
  $('.js_call-placeholder').toggleClass('opacity-0', visible);
  $('.js_call-topbar').toggleClass('opacity-0', !visible);
}


// call ui local video
function call_ui_local_video(enabled) {
  $('.video-call-stream-local').prop('hidden', !enabled);
  $('.js_call-local-off').prop('hidden', enabled);
}


// call remote track state
function call_remote_track_state(kind, enabled) {
  if (kind === 'video') {
    if (chat_call && chat_call.is_video) call_ui_remote_video(enabled);
  } else {
    $('.js_call-remote-muted').prop('hidden', enabled);
  }
}


// call attach local track (Twilio|LiveKit)
function call_attach_local(track) {
  if (!track) return;
  var element = track.attach();
  element.muted = true;
  element.setAttribute('playsinline', '');
  element.setAttribute('webkit-playsinline', '');
  $('.video-call-stream-local').empty().append(element);
  call_ui_local_video(true);
}


// call attach remote track (Twilio|LiveKit)
function call_attach_remote(track) {
  var element = track.attach();
  if (track.kind === 'video') {
    element.setAttribute('playsinline', '');
    element.setAttribute('webkit-playsinline', '');
    $('.video-call-stream').empty().append(element);
  } else {
    $('.js_call-audio').append(element);
  }
}


// call ended
function call_ended(message, delay = 2000) {
  if (!chat_call || chat_call.ended) return;
  chat_call.ended = true;
  chat_incall_process = false;
  clearInterval(chat_call_timer);
  if (chat_call.leave) chat_call.leave();
  if (document.fullscreenElement || document.webkitFullscreenElement) {
    (document.exitFullscreen || document.webkitExitFullscreen).call(document);
  }
  $('.js_call-controls').prop('hidden', true);
  $('.js_call-ended-message').text(message);
  $('.js_call-ended').prop('hidden', false);
  if (delay !== false) {
    setTimeout(function () {
      window.location.reload();
    }, delay);
  }
}


// call disconnected
function call_disconnected(message) {
  if (!chat_call || chat_call.ended) return;
  $.post(api['chat/call'], { 'do': 'decline_call', 'id': chat_call.call_id }, 'json');
  call_ended(message);
}


// call remote left
function call_remote_left() {
  call_disconnected(__['Call ended']);
}


// init Twilio
async function init_Twilio(type, token, room_name) {
  var is_video = (type == "video");
  var local_tracks;
  try {
    local_tracks = await Twilio.Video.createLocalTracks({
      audio: true,
      video: is_video ? { height: 720, frameRate: 24, width: 1280 } : false
    });
  } catch (error) {
    call_disconnected(__['Sorry, WebRTC is not available in your browser']);
    return;
  }
  var stop_local_tracks = function () {
    local_tracks.forEach(track => track.stop());
  };
  call_attach_local(local_tracks.find(track => track.kind === 'video'));
  var room;
  try {
    room = await Twilio.Video.connect(token, { name: room_name, tracks: local_tracks });
  } catch (error) {
    stop_local_tracks();
    call_disconnected(__['Not able to connect, Try again later!']);
    return;
  }
  if (!chat_call || chat_call.ended) {
    room.disconnect();
    stop_local_tracks();
    return;
  }
  chat_call.leave = function () {
    room.disconnect();
    stop_local_tracks();
  };
  chat_call.mic = function (enabled) {
    local_tracks.forEach(track => {
      if (track.kind === 'audio') enabled ? track.enable() : track.disable();
    });
  };
  chat_call.camera = function (enabled) {
    local_tracks.forEach(track => {
      if (track.kind === 'video') enabled ? track.enable() : track.disable();
    });
  };

  function track_subscribed(track) {
    call_attach_remote(track);
    call_remote_track_state(track.kind, track.isEnabled);
    track.on('disabled', () => call_remote_track_state(track.kind, false));
    track.on('enabled', () => call_remote_track_state(track.kind, true));
  }

  function participant_connected(participant) {
    participant.tracks.forEach(publication => {
      if (publication.track) track_subscribed(publication.track);
    });
    participant.on('trackSubscribed', track_subscribed);
    participant.on('trackUnsubscribed', track => track.detach().forEach(element => element.remove()));
  }

  room.participants.forEach(participant_connected);
  room.on('participantConnected', participant_connected);
  room.on('participantDisconnected', call_remote_left);
  room.on('disconnected', () => call_disconnected(__['Connection lost']));
}


// init LiveKit
async function init_LiveKit(type, token, room_name) {
  var is_video = (type === "video");
  var local_tracks;
  try {
    local_tracks = await LivekitClient.createLocalTracks({
      audio: true,
      video: is_video ? { resolution: LivekitClient.VideoPresets.h720.resolution } : false
    });
  } catch (error) {
    call_disconnected(__['Sorry, WebRTC is not available in your browser']);
    return;
  }
  call_attach_local(local_tracks.find(track => track.kind === LivekitClient.Track.Kind.Video));
  var room = new LivekitClient.Room({
    adaptiveStream: true,
    dynacast: true
  });
  chat_call.leave = function () {
    room.disconnect();
    local_tracks.forEach(track => track.stop());
  };
  chat_call.mic = function (enabled) {
    local_tracks.forEach(track => {
      if (track.kind === LivekitClient.Track.Kind.Audio) enabled ? track.unmute() : track.mute();
    });
  };
  chat_call.camera = function (enabled) {
    local_tracks.forEach(track => {
      if (track.kind === LivekitClient.Track.Kind.Video) enabled ? track.unmute() : track.mute();
    });
  };
  room
    .on(LivekitClient.RoomEvent.TrackSubscribed, (track, publication) => {
      call_attach_remote(track);
      call_remote_track_state(track.kind, !publication.isMuted);
    })
    .on(LivekitClient.RoomEvent.TrackUnsubscribed, track => track.detach().forEach(element => element.remove()))
    .on(LivekitClient.RoomEvent.TrackMuted, (publication, participant) => {
      if (participant !== room.localParticipant) call_remote_track_state(publication.kind, false);
    })
    .on(LivekitClient.RoomEvent.TrackUnmuted, (publication, participant) => {
      if (participant !== room.localParticipant) call_remote_track_state(publication.kind, true);
    })
    .on(LivekitClient.RoomEvent.ParticipantDisconnected, call_remote_left)
    .on(LivekitClient.RoomEvent.Disconnected, () => call_disconnected(__['Connection lost']));
  try {
    await room.connect(livekit_ws_url, token);
    for (const track of local_tracks) {
      await room.localParticipant.publishTrack(track);
    }
  } catch (error) {
    call_disconnected(__['Not able to connect, Try again later!']);
  }
}


// init Agora
async function init_Agora(type, token, room_name) {
  var is_video = (type === "video");
  await load_agora();
  var local_tracks;
  try {
    local_tracks = is_video ? await AgoraRTC.createMicrophoneAndCameraTracks() : [await AgoraRTC.createMicrophoneAudioTrack()];
  } catch (error) {
    call_disconnected(__['Sorry, WebRTC is not available in your browser']);
    return;
  }
  if (local_tracks[1]) {
    call_ui_local_video(true);
    local_tracks[1].play($('.video-call-stream-local')[0]);
  }
  var client = AgoraRTC.createClient({ mode: 'rtc', codec: 'vp8' });
  chat_call.leave = function () {
    local_tracks.forEach(track => track.close());
    client.leave();
  };
  chat_call.mic = function (enabled) {
    local_tracks[0].setMuted(!enabled);
  };
  chat_call.camera = function (enabled) {
    if (local_tracks[1]) local_tracks[1].setMuted(!enabled);
  };
  client.on('user-published', async (user, media_type) => {
    await client.subscribe(user, media_type);
    if (media_type === 'video') {
      call_remote_track_state('video', true);
      user.videoTrack.play($('.video-call-stream')[0], { fit: 'cover' });
    } else if (media_type === 'audio') {
      user.audioTrack.play();
      call_remote_track_state('audio', true);
    }
  });
  client.on('user-unpublished', (user, media_type) => call_remote_track_state(media_type, false));
  client.on('user-info-updated', (uid, message) => {
    var state = message.split('-');
    if (state[1] === 'audio' || state[1] === 'video') call_remote_track_state(state[1], state[0] === 'unmute');
  });
  client.on('user-left', call_remote_left);
  client.on('connection-state-change', state => {
    if (state === 'DISCONNECTED') call_disconnected(__['Connection lost']);
  });
  try {
    await client.join(agora_call_app_id, room_name, token, user_id);
    await client.publish(local_tracks);
  } catch (error) {
    call_disconnected(__['Not able to connect, Try again later!']);
  }
}


// leave_group_conversation_ui
function leave_group_conversation_ui(conversation_id) {
  modal_close();
  remove_chatbox_from_local_storage(conversation_id);
  $("#chat_" + conversation_id).remove();
  $('.js_chat-start[data-cid="' + conversation_id + '"]').closest('.feeds-item').remove();
  if ($('.panel-messages').data('cid') == conversation_id) {
    window.location.replace(site_path + '/messages');
  }
}


// apply_conversation_update
function apply_conversation_update(conversation) {
  if (!conversation || !conversation.conversation_id) {
    return;
  }
  var conversation_id = conversation.conversation_id;
  var name = html_decode(conversation.name);
  var name_list = html_decode(conversation.name_list);
  var widget = $(`.panel-messages[data-cid="${conversation_id}"]`);
  if (widget.length > 0) {
    var title = widget.find('.js_chat-title');
    title.attr('title', name);
    if (conversation.multiple_recipients) {
      title.html($('<span/>').attr('title', name_list).text(name));
    } else if (conversation.name_html) {
      title.html(conversation.name_html);
    } else {
      title.text(name);
    }
    var subtitle = widget.find('.js_chat-subtitle');
    if (conversation.multiple_recipients) {
      subtitle.attr('title', name_list).text(name_list);
    }
    widget.find('.js_chat-group-toggle').toggleClass('hidden', !conversation.multiple_recipients);
    widget.find('.js_chat-profile-toggle').toggleClass('hidden', !conversation.multiple_recipients && !conversation.user_id);
  }
  var profile_title = $('.js_chat-profile .js_chat-title');
  if (profile_title.length) {
    profile_title.attr('title', name).text(name);
  }
  var chat_box_widget = $("#chat_" + conversation_id);
  if (chat_box_widget.length > 0) {
    chat_box_widget.find('.js_chat-title').attr('title', name).text(name);
    chat_box_widget.find('.js_chat-subtitle').attr('title', name_list).text(name_list);
    if (name_list) {
      chat_box_widget.find('.chat-user-card').attr('title', name_list);
    }
  }
  var thread = $('.js_chat-start[data-cid="' + conversation_id + '"]');
  if (thread.length > 0) {
    thread.attr('data-name', name);
    thread.attr('data-name-list', name_list);
    thread.find('.name').attr('title', name).text(name);
    if (conversation.multiple_recipients) {
      thread.attr('data-multiple', 'true');
    } else {
      thread.removeAttr('data-multiple');
    }
  }
  refresh_chat_group_modal(conversation_id, conversation);
}


// refresh_chat_group_modal
function refresh_chat_group_modal(conversation_id, conversation) {
  var modal_group = $('#modal .js_chat-group');
  var profile = $('.js_chat-profile');
  var profile_open = profile.length > 0 && String($('.panel-messages').data('cid')) === String(conversation_id);
  if (!conversation || !conversation.multiple_recipients || conversation.node_id) {
    if (modal_group.length && String(modal_group.data('cid')) === String(conversation_id)) {
      modal_close();
    }
    if (profile_open) {
      $.getJSON(api['chat/conversation/get'], { 'conversation_id': conversation_id }, function (response) {
        if (response && response.conversation_html) {
          $('.js_conversation-container').html(response.conversation_html);
        }
      });
    }
    return;
  }
  if (modal_group.length && String(modal_group.data('cid')) === String(conversation_id)) {
    $.getJSON(api['chat/conversation/group'] + '&conversation_id=' + conversation_id, function (response) {
      if (response.callback) {
        eval(response.callback);
      }
    });
  }
  if (profile_open) {
    refresh_chat_group_profile(conversation_id);
  }
}


// refresh_chat_group_profile
function refresh_chat_group_profile(conversation_id) {
  $.getJSON(api['chat/conversation/get'], { 'conversation_id': conversation_id }, function (response) {
    if (!response || !response.conversation_html) {
      return;
    }
    var incoming = $('<div>').append(response.conversation_html);
    var new_profile = incoming.find('.js_chat-profile');
    var current = $('.js_chat-profile');
    if (!new_profile.length || !current.length) {
      return;
    }
    var was_closed = current.hasClass('is-closed');
    var was_open = current.hasClass('is-open');
    current.replaceWith(new_profile);
    var replaced = $('.js_chat-profile');
    if (was_closed) {
      replaced.addClass('is-closed');
    }
    if (was_open) {
      replaced.addClass('is-open');
    }
    run_moment(replaced);
  });
}


// handle_conversation_updated
function handle_conversation_updated(data) {
  if (!data) {
    return;
  }
  if (data.removed_user_id && String(data.removed_user_id) === String(user_id)) {
    leave_group_conversation_ui(data.conversation_id);
    return;
  }
  if (data.conversation) {
    apply_conversation_update(data.conversation);
    return;
  }
  if (data.conversation_id && chat_socket_enabled) {
    chat_socket.emit('event_client_get_conversation', { conversation_id: data.conversation_id }, function (response) {
      var conversation = JSON.parse(response);
      if (!conversation) {
        leave_group_conversation_ui(data.conversation_id);
        return;
      }
      apply_conversation_update(conversation);
    });
  }
}


// chat_group_action
function chat_group_action(do_action, payload, button, next) {
  if (button) {
    button_status(button, "loading");
  }
  var done = function (response) {
    if (button) {
      button_status(button, "reset");
    }
    if (next && !(response && response.callback)) {
      next();
      return;
    }
    if (do_action === 'remove') {
      modal_close();
    }
    if (response && response.callback) {
      eval(response.callback);
      return;
    }
    handle_conversation_updated(response);
  };
  if (chat_socket_enabled) {
    var event_name = 'event_client_conversation_' + do_action;
    chat_socket.emit(event_name, payload, function (response) {
      done(JSON.parse(response));
    });
  } else {
    payload.do = do_action;
    $.post(api['chat/actions'], payload, function (response) {
      done(response);
    }, 'json')
      .fail(function () {
        if (button) {
          button_status(button, "reset");
        }
        show_error_modal();
      });
  }
}


// open_messenger_app
function open_messenger_app() {
  if (/Android|SngineAndroid/i.test(navigator.userAgent)) {
    window.location = messaging_app_android_link;
  } else if (/iPhone|iPad|iPod|SngineIOS/i.test(navigator.userAgent)) {
    window.location = messaging_app_ios_link;
  } else {
    window.location = site_path + "/messages";
  }
}

$(function () {

  // init chat socket
  init_chat_socket();


  // reconstruct chat-widgets on resize
  var chat_widgets_resize_timer = null;
  $(window).on('resize', function () {
    clearTimeout(chat_widgets_resize_timer);
    chat_widgets_resize_timer = setTimeout(reconstruct_chat_widgets, 150);
  });


  // init chat messages grouping
  init_chat_messages_grouping();


  // messages page history
  if (is_messages_page()) {
    window.history.replaceState({ chat_cid: $('.panel-messages').data('cid') || null }, '', window.location.href);
    window.addEventListener('popstate', function (event) {
      var conversation_id = (event.state && event.state.chat_cid) || null;
      if (!conversation_id) {
        window.location.reload();
        return;
      }
      var thread = $('.js_live-messages-alt .js_chat-start[data-cid="' + conversation_id + '"]');
      $('.js_live-messages-alt li.feeds-item').removeClass('is-active');
      thread.closest('li.feeds-item').addClass('is-active');
      $('.sg-offcanvas').removeClass('active').css('minHeight', 'unset');
      open_messages_thread(conversation_id, thread.data('name'), thread.data('picture'));
    });
  }


  // init messages page
  if (is_messages_page() && $('.panel-messages').data('cid') !== undefined) {
    /* open thread */
    if (chat_socket_enabled) {
      chat_socket.emit('event_client_open_thread', { conversation_id: $('.panel-messages').data('cid') });
      if (chat_seen_enabled) {
        chat_socket.emit('event_client_seen', { ids: [$('.panel-messages').data('cid')] });
      }
    }
    /* color panel messages (messages page) */
    color_chat_box($('.panel-messages'), $('.panel-messages').attr("data-color"));
    /* update scroll position */
    requestAnimationFrame(function () {
      size_messages_scroller(true);
    });
  }


  // init page inbox
  if ($('.panel-messages[data-as-page]').length > 0) {
    var page_inbox_thread = $('.panel-messages[data-as-page]');
    /* open thread */
    if (chat_socket_enabled) {
      chat_socket.emit('event_client_open_thread', { conversation_id: page_inbox_thread.data('cid'), as_page: 1 });
    }
    /* color panel messages */
    color_chat_box(page_inbox_thread, page_inbox_thread.attr("data-color"));
    /* update scroll position */
    requestAnimationFrame(function () {
      var scroller = page_inbox_thread.find('.js_scroller:first');
      scroller.scrollTop(scroller[0].scrollHeight);
    });
  }


  // turn chat (on|off)
  $('body').on('click', '.js_chat-toggle', function (e) {
    e.preventDefault();
    /* get status */
    var status = $(this).data('status');
    /* update the UI */
    update_chat_toggle_status(status);
    /* update the server */
    if (chat_socket_enabled) {
      /* using socket */
      chat_socket.emit('event_client_chat_toggle', { 'user_chat_enabled': (status == "on") ? 0 : 1 });
    } else {
      /* using ajax */
      $.get(api['users/settings'] + '?edit=chat', { 'user_chat_enabled': (status == "on") ? 0 : 1 }, function (response) {
        /* check the response */
        if (!response) return;
        /* check if there is a callback */
        if (response.callback) {
          eval(response.callback);
          return;
        }
      }, 'json')
        .fail(function () {
          show_error_modal();
        });
    }
    return false;
  });


  // reconstruct chat widgets when resize window
  $(window).on("resize", function () {
    reconstruct_chat_widgets();
    size_messages_scroller();
  });


  // chat-box
  $('body').on('click', '.js_chat-new', function (e) {
    /* check if chat disabled */
    if (!chat_enabled) {
      return;
    }
    /* check if opened from mobile (anchor tag will be triggered) */
    if (is_mobile()) {
      return;
    }
    e.preventDefault();
    /* open fresh chat-box */
    /* check if there is any fresh chat-box already exists */
    if ($('.chat-box.fresh').length > 0) {
      /* open fresh chat-box that already exists if not opened */
      if (!$('.chat-box.fresh').hasClass('opened')) {
        $('.chat-box.fresh').addClass('opened');
        $('.chat-box.fresh').find('.chat-widget-content').slideToggle(200);
      }
      return;
    }
    /* construct a new one */
    $('body').append(render_template('#chat-box-new'));
    $('.chat-box.fresh').find('.chat-widget-content').show();
    /* initialize the main plugins */
    initialize();
    /* reconstruct chat-widgets */
    reconstruct_chat_widgets();
  });


  // messages page threads search & filter
  $('body').on('input', '.js_chat-threads-search', function () {
    clearTimeout(chat_threads_search_timer);
    chat_threads_search_timer = setTimeout(search_chat_threads, 300);
  });
  $('body').on('click', '.js_chat-threads-filter', function () {
    $('.js_chat-threads-filter').attr('aria-pressed', 'false');
    $(this).attr('aria-pressed', 'true');
    clearTimeout(chat_threads_search_timer);
    search_chat_threads();
  });


  // messages page profile panel
  $('body').on('click', '.js_chat-profile-toggle', function () {
    var desktop = window.matchMedia('(min-width: 1280px)').matches;
    $('.js_chat-profile').toggleClass(desktop ? 'is-closed' : 'is-open');
  });
  $('body').on('click', '.js_chat-start', function (e) {
    /* mandatory */
    var user_id = $(this).data('uid') || false;
    var conversation_id = $(this).data('cid') || false;
    var page_id = $(this).data('page-id') || false;
    /* optional */
    var name = $(this).data('name');
    var name_list = $(this).data('name-list') || name;
    var multiple = ($(this).data('multiple')) ? true : false;
    var link = $(this).data('link');
    var picture = $(this).data('picture');
    var chatbox_enabled = $(this).data('chat-box');
    var product = ($(this).data('product-post-id')) ? { id: $(this).data('product-post-id'), name: $(this).data('product-name'), price: $(this).data('product-price'), image: $(this).data('product-image') } : false;
    /* check if the viewer in the messages page */
    if (is_messages_page()) {
      /* [A] user is in the messages page */
      e.preventDefault();
      if (!conversation_id) {
        /* [1] starting a new conversation */
        redirect_to_thread(user_id, page_id);
      } else {
        /* [2] loading existing conversation */
        $('.js_live-messages-alt li.feeds-item').removeClass('is-active');
        $(this).closest('li.feeds-item').addClass('is-active');
        $('.sg-offcanvas').removeClass('active');
        $('.sg-offcanvas').css('minHeight', 'unset');
        open_messages_thread(conversation_id, name, picture);
        var thread_url = site_path + '/messages/' + conversation_id;
        if (new URL(thread_url, window.location.href).pathname !== window.location.pathname) {
          window.history.pushState({ chat_cid: conversation_id }, '', thread_url);
        }
      }
    } else {
      /* [B] user is not in the messages page */
      /* check if chat is enabled or mobile view */
      if (!chat_enabled || is_mobile()) {
        /* [1] chat disabled or mobile view */
        if (conversation_id) return; /* (return will allow default behave of anchor tag) */
        e.preventDefault();
        /* keep the product for the messages page */
        if (product) {
          try { sessionStorage.setItem('chat_pending_product', JSON.stringify(product)); } catch (error) { }
        }
        redirect_to_thread(user_id, page_id);
      } else {
        /* [2] chat enabled & desktop view */
        if (chatbox_enabled) return; /* (return will allow default behave of anchor tag) */
        e.preventDefault();
        chat_box(user_id, conversation_id, name, name_list, multiple, link, picture, true, page_id);
        /* attach the product to the next message */
        if (product) {
          chat_set_product($('.chat-box[data-uid="' + user_id + '"]').first(), product);
        }
      }
    }
    /* redirect to thread */
    function redirect_to_thread(user_id, page_id) {
      var data = (page_id) ? { 'page_id': page_id } : { 'uid': user_id };
      $.getJSON(api['chat/conversation/check'], data, function (response) {
        /* check the response */
        if (!response) return;
        /* check if there is a callback */
        if (response.callback) {
          eval(response.callback);
          return;
        }
        /* handle response */
        if (response.conversation_id) {
          window.location = site_path + "/messages/" + response.conversation_id;
        } else if (page_id) {
          window.location = site_path + "/messages/new?page_id=" + page_id;
        } else {
          window.location = site_path + "/messages/new?uid=" + user_id;
        }
      })
        .fail(function () {
          show_error_modal();
        });
    }
  });


  // toggle chat-widget
  $('body').on('click', '.chat-widget-head', function (e) {
    /* check if user just starting video/audio call */
    if ($(e.target).hasClass('js_chat-call-start')) return;
    /* get widget */
    var widget = $(this).parents('.chat-widget');
    var conversation_id = widget.data('cid') || false;
    /* toggle 'opened' class */
    widget.toggleClass('opened');
    /* toggle widget content */
    widget.find('.chat-widget-content').slideToggle(200);
    /* scroll to latest message if has class new (new = there is new messages not seen) */
    if (widget.hasClass('new')) {
      widget.find(".js_scroller:first").scrollTop(widget.find(".js_scroller:first")[0].scrollHeight);
      widget.removeClass('new');
      /* update the new messages counter */
      widget.find('.js_chat-box-label').text('');
      /* update this convertaion seen status (if enabled by the system) */
      if (chat_seen_enabled && conversation_id) {
        if (chat_socket_enabled) {
          /* using socket */
          chat_socket.emit('event_client_seen', { ids: [conversation_id] });
        } else {
          /* using ajax */
          $.post(api['chat/actions'], { 'do': 'seen', 'ids': [conversation_id] }, function (response) {
            /* check if there is a callback */
            if (response.callback) {
              eval(response.callback);
              return;
            }
          }, 'json');
        }
      }
    }
  });


  // close chat-widget
  $('body').on('click', '.js_chat-box-close', function () {
    /* get widget */
    var widget = $(this).parents('.chat-widget');
    var conversation_id = widget.data('cid');
    /* remove widget */
    widget.remove();
    /* reconstruct chat-widgets */
    reconstruct_chat_widgets();
    /* update chatbox closing process */
    chatbox_closing_process = true;
    /* notify server about closed chat box */
    if (conversation_id !== undefined) {
      if (chat_socket_enabled) {
        /* using socket */
        chat_socket.emit('event_client_close_chatbox', { conversation_id: conversation_id });
        /* remove the chatbox from the local storage */
        remove_chatbox_from_local_storage(conversation_id);
        /* update chatbox closing process */
        chatbox_closing_process = false;
      } else {
        /* using ajax */
        $.post(api['chat/actions'], { 'do': 'close', 'conversation_id': conversation_id }, function (response) {
          /* check if there is a callback */
          if (response.callback) {
            eval(response.callback);
            return;
          }
          /* update chatbox closing process */
          chatbox_closing_process = false;
        }, 'json')
          .fail(function () {
            show_error_modal();
          });
      }
    }
  });


  // post message
  /* post message */
  function _post_message(element) {
    var _this = $(element);
    var widget = _this.closest('.chat-widget, .panel-messages');
    if (attachment_upload_busy(widget)) return;
    var textarea = widget.find('textarea.js_post-message');
    var message = textarea.val();
    var conversation_id = widget.data('cid');
    var attachments = widget.find('.chat-attachments');
    var chat_price = widget.data('chat-price') || 0;
    /* get photo from widget data */
    var photos = Object.values(widget.data('photos') || {});
    /* get videos from widget data */
    var videos = Object.values(widget.data('videos') || {});
    /* get files from widget data */
    var files = Object.values(widget.data('files') || {});
    /* get gif from widget data */
    var gif = widget.data('gif') || '';
    var has_product = widget.data('product') !== undefined;
    var has_media = photos.length > 0 || videos.length > 0 || files.length > 0 || gif !== '' || has_product;
    /* get voice note from widget data */
    var voice_note = widget.data('voice_notes');
    /* check if message is empty */
    if (is_empty(message) && !has_media && !voice_note) {
      return;
    }
    /* check if posting the message to (new || existed) conversation */
    if (widget.hasClass('fresh')) {
      /* post the message to -> a new conversation */
      /* check recipients */
      if (widget.find('.tags li').length == 0) {
        return;
      }
      /* get recipients */
      var recipients = [];
      $.each(widget.find('.tags li'), function (i, tag) {
        recipients.push($(tag).data('uid'));
        chat_price += $(tag).data('chat-price');
      });
      var data = Object.assign({ 'message': message, 'photos': JSON.stringify(photos), 'videos': JSON.stringify(videos), 'files': JSON.stringify(files), 'voice_note': JSON.stringify(voice_note), 'gif': gif, 'recipients': JSON.stringify(recipients) }, chat_reply_fields(widget), chat_product_fields(widget));
    } else {
      if (conversation_id === undefined && widget.data('page-id')) {
        /* post the message to -> a new page conversation */
        var data = Object.assign({ 'message': message, 'photos': JSON.stringify(photos), 'videos': JSON.stringify(videos), 'files': JSON.stringify(files), 'voice_note': JSON.stringify(voice_note), 'gif': gif, 'page_id': widget.data('page-id') }, chat_reply_fields(widget), chat_product_fields(widget));
      } else if (conversation_id === undefined) {
        /* post the message to -> a new conversation */
        /* get recipients */
        var recipients = [];
        recipients.push(widget.data('uid'));
        var data = Object.assign({ 'message': message, 'photos': JSON.stringify(photos), 'videos': JSON.stringify(videos), 'files': JSON.stringify(files), 'voice_note': JSON.stringify(voice_note), 'gif': gif, 'recipients': JSON.stringify(recipients) }, chat_reply_fields(widget), chat_product_fields(widget));
      } else {
        /* post the message to -> already existed conversation */
        var data = Object.assign({ 'message': message, 'photos': JSON.stringify(photos), 'videos': JSON.stringify(videos), 'files': JSON.stringify(files), 'voice_note': JSON.stringify(voice_note), 'gif': gif, 'conversation_id': conversation_id }, chat_reply_fields(widget), chat_product_fields(widget), chat_page_fields(widget));
      }
    }
    /* check if chat price > 0 */
    if (chat_price > 0) {
      confirm(__['Payment Confirmation'], __['This message will cost you'] + " " + chat_price + " (" + currency + ")", function () {
        handle_chat_message_request();
      });
    } else {
      handle_chat_message_request();
    }
    /* send message function */
    function handle_chat_message_request() {
      /* check if there is current (sending) process */
      if (widget.data('sending') || attachment_upload_busy(widget)) {
        return false;
      }
      /* add the message directly if widget not fresh & not sending photo & not sending voice note */
      if (!widget.hasClass('fresh') && !has_media && voice_note === undefined) {
        textarea.trigger('focus').val('').height(textarea.css('line-height'));
        var _guid = guid();
        var reply_preview = widget.data('reply-preview') || {};
        widget.find(".js_scroller:first ul").append(render_template('#chat-message', { 'message': htmlEntities(message), 'id': _guid, 'time': moment.utc().format("YYYY-MM-DD H:mm:ss"), 'copy': message, 'name': (typeof user_fullname !== 'undefined' ? user_fullname : ''), 'reply_id': reply_preview.id, 'reply_name': reply_preview.name, 'reply_snippet': reply_preview.snippet }));
        flyonui_init();
        widget.find(".js_scroller:first .seen").remove(); // remove any seen status before
        widget.find(".js_scroller:first").scrollTop(widget.find(".js_scroller:first")[0].scrollHeight);
      }
      /* add currenet sending process */
      widget.data('sending', true);
      /* process */
      if (chat_socket_enabled) {
        /* using socket */
        chat_socket.emit('event_client_send_message', data, function (response) {
          handle_chat_message_response(JSON.parse(response), _guid);
        });
      } else {
        /* using ajax */
        $.post(api['chat/post'], data, function (response) {
          handle_chat_message_response(response, _guid);
        }, 'json')
          .fail(function () {
            widget.removeData('sending');
            show_error_modal();
          });
      }
    }
    /* handle chat message response */
    function handle_chat_message_response(response, _guid) {
      /* check the response */
      if (!response) return;
      /* check if there is a callback */
      if (response.callback) {
        widget.removeData('sending');
        eval(response.callback);
        return;
      }
      attachment_upload_clear(widget);
      composer_gif_clear(widget);
      var reply_preview = widget.data('reply-preview') || {};
      chat_clear_reply(widget);
      chat_clear_product(widget);
      /* handle response */
      if (widget.hasClass('fresh') || (conversation_id === undefined && widget.data('page-id') && is_messages_page())) {
        if (is_messages_page()) {
          /* in messages page */
          window.location.replace(site_path + '/messages/' + response.conversation_id);
        } else {
          widget.remove();
          chat_box(response.user_id, response.conversation_id, response.name, response.name_list, response.multiple_recipients, response.link, response.picture, true, response.page_id);
        }
      } else {
        if (conversation_id === undefined) {
          widget.attr("id", "chat_" + response.conversation_id);
          widget.attr("data-cid", response.conversation_id);
          widget.find('.x-form-tools-colors').removeClass('hidden');
        }
        if (!has_media && voice_note === undefined) {
          if (response.last_message_html) {
            widget.find(".js_scroller:first ul").find("#" + _guid).replaceWith(response.last_message_html);
          } else {
            widget.find(".js_scroller:first ul").find("#" + _guid).replaceWith(render_template('#chat-message', { 'message': response.last_message.message, 'image': response.last_message.image, 'video': response.last_message.video, 'voice_note': response.last_message.voice_note, 'id': response.last_message_id, 'time': moment.utc().format("YYYY-MM-DD H:mm:ss"), 'color': widget.data('color'), 'copy': response.last_message.message_orginal_decoded || message, 'name': (typeof user_fullname !== 'undefined' ? user_fullname : ''), 'reply_id': reply_preview.id, 'reply_name': reply_preview.name, 'reply_snippet': reply_preview.snippet }));
          }
          flyonui_init();
        } else {
          textarea.trigger('focus').val('').height(textarea.css('line-height'));
          if (response.last_message_html) {
            widget.find(".js_scroller:first ul").append(response.last_message_html);
            flyonui_init();
            if (widget.data('color')) {
              color_chat_box(widget, widget.data('color'));
            }
          } else {
            widget.find(".js_scroller:first ul").append(render_template('#chat-message', { 'message': response.last_message.message, 'image': response.last_message.image, 'video': response.last_message.video, 'voice_note': response.last_message.voice_note, 'id': response.last_message_id, 'time': moment.utc().format("YYYY-MM-DD H:mm:ss"), 'color': widget.data('color'), 'copy': response.last_message.message_orginal_decoded || message, 'name': (typeof user_fullname !== 'undefined' ? user_fullname : ''), 'reply_id': reply_preview.id, 'reply_name': reply_preview.name, 'reply_snippet': reply_preview.snippet }));
            flyonui_init();
          }
          widget.find(".js_scroller:first .seen").remove(); // remove any seen status before
          widget.find(".js_scroller:first").scrollTop(widget.find(".js_scroller:first")[0].scrollHeight);
          /* handle attachments */
          attachments.hide();
          attachments.find('li.item').remove();
          widget.removeData('photos');
          widget.removeData('videos');
          widget.removeData('files');
          widget.find('.x-form-tools-attach').show();
          widget.removeData('voice_notes');
        }
        /* remove currenet sending process */
        widget.removeData('sending');
        /* clear typing timer */
        clearTimeout(chat_typing_timer);
        /* update typing status */
        if (chat_socket_enabled) {
          chat_socket.emit('event_client_typing', Object.assign({ conversation_id: response.conversation_id, is_typing: false }, chat_page_fields(widget)));
        } else {
          $.post(api['chat/actions'], Object.assign({ 'do': 'typing', 'is_typing': false, 'conversation_id': response.conversation_id }, chat_page_fields(widget)), function (response) {
            if (response.callback) {
              eval(response.callback);
            }
          }, 'json');
        }
        /* update page inbox */
        if (widget.data('as-page')) {
          refresh_page_inbox(widget.data('as-page'));
        }
      }
      /* hide the confimation if it exists */
      if ($('#modal').hasClass('open')) {
        modal_close();
      }
    }
  }
  $('body').on('keydown', 'textarea.js_post-message', function (event) {
    if (!is_mobile() && (event.originalEvent.key == 'Enter' && event.shiftKey == 0)) {
      event.preventDefault();
      _post_message(this);
    }
  });
  $('body').on('click', 'button.js_post-message', function (event) {
    _post_message(this);
  });
  /* chat attachment remover */
  $('body').on('click', '.js_chat-attachment-remover', function () {
    var widget = $(this).parents('.chat-widget, .panel-messages');
    var attachments = widget.find('.chat-attachments');
    var item = $(this).parents('li.item');
    var src = item.data('src');
    /* remove the attachment from widget data */
    widget.removeData('photo')
    /* remove the attachment item */
    item.remove();
    /* hide attachments */
    attachments.hide();
    /* show widget form tools */
    widget.find('.x-form-tools-attach').show();
    widget.find('.x-form-tools-voice').show();
    /* remove the attachment from server */
    $.post(api['data/delete'], { 'src': src });
  });


  // post paid message
  /* post paid message */
  function _post_paid_message(element) {
    var _this = $(element);
    /* get publisher */
    var publisher = _this.parents('.publisher');
    if (attachment_upload_busy(publisher)) return;
    /* get conversation id */
    var conversation_id = publisher.data('id');
    /* get widget by conversation id */
    var widget = $(`#chat_${conversation_id}, .panel-messages[data-cid="${conversation_id}"]`);
    /* get text */
    var textarea = publisher.find('textarea');
    /* get message */
    var message = textarea.val();
    /* get photos */
    var photos = publisher.data('photos');
    /* get video */
    var video = publisher.data('video');
    /* get audio */
    var audio = publisher.data('audio');
    /* get file */
    var file = publisher.data('file');
    /* get adult content */
    var for_adult = publisher.find('.js_publisher-adult-toggle').is(":checked");
    /* get paid post */
    var paid_price_wrapper = publisher.find("#paid-price-wrapper");
    var paid_price_input = paid_price_wrapper.find('input');
    var paid_text_wrapper = publisher.find("#paid-text-wrapper")
    var paid_text_input = paid_text_wrapper.find('textarea');
    var paid_image_wrapper = publisher.find("#paid-image-wrapper")
    var paid_image_input = paid_image_wrapper.find('input.js_x-uploader-input');
    /* get the error element */
    var error = publisher.find('.publisher-error, .alert.alert-error, .alert.alert-danger').first();
    /* return if no media to post (paid messages require media) */
    if (photos === undefined && video === undefined && audio === undefined && file === undefined) {
      return;
    }
    /* build data */
    var data = Object.assign({
      'handle': 'paid',
      'conversation_id': conversation_id,
      'message': message,
      'photos': JSON.stringify(photos),
      'video': JSON.stringify(video),
      'audio': JSON.stringify(audio),
      'file': JSON.stringify(file),
      'for_adult': for_adult,
      'message_price': paid_price_input.val(),
      'paid_text': paid_text_input.val(),
      'paid_image': paid_image_input.val()
    }, chat_reply_fields(widget));
    /* clear any previous error */
    error.slideUp();
    /* button loading */
    button_status(_this, "loading");
    handle_chat_paid_message_request();
    /* send paid message function */
    function handle_chat_paid_message_request() {
      /* check if there is current (sending) process */
      if (widget.data('sending') || attachment_upload_busy(publisher)) {
        return false;
      }
      /* add currenet sending process */
      widget.data('sending', true);
      /* process */
      if (chat_socket_enabled) {
        /* using socket */
        chat_socket.emit('event_client_send_paid_message', data, function (response) {
          handle_chat_paid_message_response(JSON.parse(response));
        });
      } else {
        /* using ajax */
        $.post(api['chat/post'], data, function (response) {
          handle_chat_paid_message_response(response);
        }, 'json')
          .fail(function () {
            /* button reset */
            button_status(_this, "reset");
            /* remove currenet sending process */
            widget.removeData('sending');
            show_error_modal();
          });
      }
    }
    /* handle chat paid message response */
    function handle_chat_paid_message_response(response) {
      /* button reset */
      button_status(_this, "reset");
      /* check the response */
      if (!response) {
        /* remove currenet sending process */
        widget.removeData('sending');
        return;
      }
      /* check for a validation error */
      if (response.error) {
        /* remove currenet sending process */
        widget.removeData('sending');
        /* show the error inside the publisher */
        error.html(response.message).slideDown();
        return;
      }
      /* check if there is a callback */
      if (response.callback) {
        /* remove currenet sending process */
        widget.removeData('sending');
        eval(response.callback);
        return;
      }
      /* handle response — append the server-rendered paid message (full media/price),
         falling back to the client template only if the HTML is missing */
      chat_clear_reply(widget);
      if (response.last_message_html) {
        widget.find(".js_scroller:first ul").append(response.last_message_html);
      } else {
        widget.find(".js_scroller:first ul").append(render_template('#chat-message', { 'message': response.last_message.message, 'image': response.last_message.image, 'video': response.last_message.video, 'voice_note': response.last_message.voice_note, 'id': response.last_message_id, 'time': moment.utc().format("YYYY-MM-DD H:mm:ss"), 'color': widget.data('color') }));
      }
      flyonui_init();
      widget.find(".js_scroller:first .seen").remove(); // remove any seen status before
      widget.find(".js_scroller:first").scrollTop(widget.find(".js_scroller:first")[0].scrollHeight);
      /* remove currenet sending process */
      widget.removeData('sending');
      /* clear typing timer */
      clearTimeout(chat_typing_timer);
      /* update typing status */
      if (chat_socket_enabled) {
        chat_socket.emit('event_client_typing', { conversation_id: response.conversation_id, is_typing: false });
      } else {
        $.post(api['chat/actions'], { 'do': 'typing', 'is_typing': false, 'conversation_id': response.conversation_id }, function (response) {
          if (response.callback) {
            eval(response.callback);
          }
        }, 'json');
      }
      attachment_upload_clear(publisher);
      /* close publisher modal */
      close_publisher_modal($('#modal'));
    }
  }
  $('body').on('click', '.js_post-paid-message', function () {
    _post_paid_message(this);
  });


  // chat typing status
  var chat_typing_timer;
  $('body').on('keyup paste change input propertychange', 'textarea.js_post-message', function () {
    if (!chat_typing_enabled) return;
    var _this = $(this);
    var widget = _this.parents('.chat-widget, .panel-messages');
    var conversation_id = widget.data('cid') || false;
    var is_typing = (_this.val()) ? true : false;
    if (!conversation_id || widget.data('sending')) return;
    clearTimeout(chat_typing_timer);
    chat_typing_timer = setTimeout(function () {
      if (chat_socket_enabled) {
        /* using socket */
        chat_socket.emit('event_client_typing', Object.assign({ conversation_id: conversation_id, is_typing: is_typing }, chat_page_fields(widget)));
      } else {
        /* using ajax */
        $.post(api['chat/actions'], Object.assign({ 'do': 'typing', 'is_typing': is_typing, 'conversation_id': conversation_id }, chat_page_fields(widget)), function (response) {
          /* check if there is a callback */
          if (response.callback) {
            eval(response.callback);
            return;
          }
        }, 'json');
      }
    }, 500);
  });


  // run chat colors
  /* toggle(close|open) colors-menu */
  $('body').on('click', '.js_chat-colors-menu-toggle', function () {
    var composer = $(this).closest('.x-form');
    if (composer.children('.chat-colors-menu').length == 0) {
      composer.append(render_template('#chat-colors-menu'));
    }
    composer.children('.chat-colors-menu').toggle();
  });
  /* close chat-colors-menu when clicked outside */
  $('body').on('click', function (e) {
    if ($(e.target).hasClass('js_chat-colors-menu-toggle') || $(e.target).parents('.js_chat-colors-menu-toggle').length > 0 || $(e.target).hasClass('chat-colors-menu') || $(e.target).parents('.chat-colors-menu').length > 0) {
      return;
    }
    $('.chat-colors-menu').hide();
  });
  /* change chat color */
  $('body').on('click', '.js_chat-color', function () {
    var color = $(this).data('color');
    var chat_widget = $(this).parents('.chat-widget, .panel-messages');
    var conversation_id = chat_widget.data('cid');
    color_chat_box(chat_widget, color);
    $('.chat-colors-menu').hide();
    if (chat_socket_enabled) {
      /* using socket */
      chat_socket.emit('event_client_color', { conversation_id: conversation_id, color: color });
    } else {
      /* using ajax */
      $.post(api['chat/actions'], { 'do': 'color', 'conversation_id': conversation_id, 'color': color }, function (response) {
        /* check if there is a callback */
        if (response.callback) {
          eval(response.callback);
          return;
        }
      }, 'json')
        .fail(function () {
          show_error_modal();
        });
    }
  });


  // run chat media
  /* show all media */
  $('body').on('click', '.js_chat-media-more', function (e) {
    e.preventDefault();
    e.stopPropagation();
    var media = $(this).closest('.js_chat-media');
    media.find('.js_chat-media-hidden').removeClass('hidden js_chat-media-hidden');
    media.find('.js_chat-media-more').remove();
  });


  // delete conversation
  $('body').on('click', '.js_delete-conversation', function () {
    confirm(__['Delete Conversation'], __['Are you sure you want to delete this conversation?'], function () {
      var conversation_id = $('.panel-messages').data('cid');
      if (chat_socket_enabled) {
        /* using socket */
        chat_socket.emit('event_client_delete_conversation', { conversation_id: conversation_id }, function () {
          /* remove from local storage */
          remove_chatbox_from_local_storage(conversation_id);
          /* redirect to messages page */
          window.location.replace(site_path + '/messages');
        });
      } else {
        /* using ajax */
        $.post(api['chat/actions'], { 'do': 'delete', 'conversation_id': conversation_id }, function (response) {
          if (response.callback) {
            eval(response.callback);
            return;
          }
          /* redirect to messages page */
          window.location.replace(site_path + '/messages');
        }, 'json')
          .fail(function () {
            show_error_modal();
          });
      }
    });
  });


  // leave conversation
  $('body').on('click', '.js_leave-conversation', function () {
    confirm(__['Delete Conversation'], __['Are you sure you want to delete this conversation?'], function () {
      var conversation_id = $('.panel-messages').data('cid');
      if (chat_socket_enabled) {
        /* using socket */
        chat_socket.emit('event_client_leave_conversation', { conversation_id: conversation_id }, function () {
          /* remove from local storage */
          remove_chatbox_from_local_storage(conversation_id);
          /* redirect to messages page */
          window.location.replace(site_path + '/messages');
        });
      } else {
        /* using ajax */
        $.post(api['chat/actions'], { 'do': 'leave', 'conversation_id': conversation_id }, function (response) {
          if (response.callback) {
            eval(response.callback);
            return;
          }
          /* redirect to messages page */
          window.location.replace(site_path + '/messages');
        }, 'json')
          .fail(function () {
            show_error_modal();
          });
      }
    });
  });


  // group conversation
  $('body').on('submit', '.js_chat-group-rename', function (e) {
    e.preventDefault();
    var conversation_id = $(this).closest('.js_chat-group').data('cid');
    chat_group_action('rename', { conversation_id: conversation_id, name: $(this).find('[name="name"]').val() }, $(this).find('button[type="submit"]'));
  });
  $('body').on('click', '.js_chat-group-clear', function () {
    var form = $(this).closest('.js_chat-group-rename');
    form.find('[name="name"]').val('');
    var conversation_id = $(this).closest('.js_chat-group').data('cid');
    chat_group_action('rename', { conversation_id: conversation_id, name: '' }, $(this));
  });
  $('body').on('click', '.js_chat-group-add-btn', function () {
    var modal_group = $(this).closest('.js_chat-group');
    var conversation_id = modal_group.data('cid');
    var user_ids = modal_group.find('.js_chat-group-add ul.tags li').map(function () {
      return $(this).data('uid');
    }).get();
    if (user_ids.length == 0) {
      return;
    }
    var button = $(this);
    var add_next = function () {
      var target_id = user_ids.shift();
      if (user_ids.length == 0) {
        chat_group_action('add', { conversation_id: conversation_id, user_id: target_id }, button);
        return;
      }
      chat_group_action('add', { conversation_id: conversation_id, user_id: target_id }, button, add_next);
    };
    add_next();
  });
  $('body').on('click', '.js_chat-group-remove', function () {
    var _this = $(this);
    var conversation_id = _this.data('cid') || $('#modal .js_chat-group').data('cid');
    var target_id = _this.data('uid');
    var is_leave = String(target_id) === String(user_id);
    confirm(is_leave ? __['Leave'] : __['Remove'], is_leave ? __['Are you sure you want to leave this conversation?'] : __['Are you sure you want to remove this person?'], function () {
      chat_group_action('remove', { conversation_id: conversation_id, user_id: target_id }, _this);
    });
  });


  // run calls (audio|video)
  /* start call */
  $('body').on('click', '.js_chat-call-start', function () {
    var _this = $(this);
    var type = _this.data("type");
    var user_id = _this.data('uid');
    var name = _this.data('name');
    var picture = _this.data('picture');
    var widget = _this.parents('.chat-widget, .panel-messages');
    var call_price = widget.data('call-price') || 0;
    /* check if call price > 0 */
    if (call_price > 0) {
      confirm(__['Payment Confirmation'], __['This call will cost you'] + " " + call_price + " (" + currency + ")", function () {
        create_call(type, user_id, name, picture);
      });
    } else {
      create_call(type, user_id, name, picture);
    }
  });
  /* cancel call (caller) */
  $('body').on('click', '.js_chat-call-cancel', function () {
    var id = $(this).data("id");
    /* update chat calling process */
    chat_calling_process = false;
    /* stop calling sound */
    $("#chat-calling-sound")[0].stop();
    /* remove the ending call callback timeout */
    clearTimeout(chat_ending_call_timeout);
    if (chat_socket_enabled) {
      /* using socket */
      chat_socket.emit('event_client_cancel_call', { id: id });
    } else {
      $.post(api['chat/call'], { 'do': 'cancel_call', 'id': id }, function (response) {
        /* check if there is a callback */
        if (response.callback) {
          eval(response.callback);
          return;
        }
      }, 'json')
        .fail(function () {
          show_error_modal();
        });
    }
  });
  /* decline call (receiver) */
  $('body').on('click', '.js_chat-call-decline', function () {
    var id = $(this).data("id");
    /* update chat ringing process */
    chat_ringing_process = false;
    /* stop ringing sound */
    $("#chat-ringing-sound")[0].stop();
    if (chat_socket_enabled) {
      /* using socket */
      chat_socket.emit('event_client_decline_call', { id: id });
    } else {
      $.post(api['chat/call'], { 'do': 'decline_call', 'id': id }, function (response) {
        /* check if there is a callback */
        if (response.callback) {
          eval(response.callback);
          return;
        }
      }, 'json')
        .fail(function () {
          show_error_modal();
        });
    }
  });
  /* end call (caller|receiver) */
  $('body').on('click', '.js_chat-call-end', function () {
    var id = $(this).data("id");
    if (chat_socket_enabled) {
      /* using socket */
      chat_socket.emit('event_client_end_call', { id: id });
      call_ended(__['Call ended'], 600);
    } else {
      call_ended(__['Call ended'], false);
      $.post(api['chat/call'], { 'do': 'end_call', 'id': id }, function (response) {
        /* check if there is a callback */
        if (response.callback) {
          eval(response.callback);
          return;
        }
        window.location.reload();
      }, 'json')
        .fail(function () {
          show_error_modal();
        });
    }
  });
  /* mute/unmute mic */
  $('body').on('click', '.js_call-mic', function () {
    if (!chat_call || !chat_call.mic) return;
    var muted = $(this).attr('aria-pressed') !== 'true';
    $(this).attr('aria-pressed', muted);
    chat_call.mic(!muted);
  });
  /* turn camera on/off */
  $('body').on('click', '.js_call-camera', function () {
    if (!chat_call || !chat_call.camera) return;
    var off = $(this).attr('aria-pressed') !== 'true';
    $(this).attr('aria-pressed', off);
    chat_call.camera(!off);
    call_ui_local_video(!off);
  });
  /* call full screen */
  $('body').on('click', '.js_call-fullscreen', function () {
    var stage = $(this).closest('.js_call-stage')[0];
    if (document.fullscreenElement || document.webkitFullscreenElement) {
      (document.exitFullscreen || document.webkitExitFullscreen).call(document);
    } else {
      (stage.requestFullscreen || stage.webkitRequestFullscreen).call(stage);
    }
  });
  $(document).on('fullscreenchange webkitfullscreenchange', function () {
    $('.js_call-fullscreen').attr('aria-pressed', !!(document.fullscreenElement || document.webkitFullscreenElement));
  });
  /* answer call (receiver) */
  $('body').on('click', '.js_chat-call-answer', function () {
    var type = $(this).data("type");
    var id = $(this).data("id");
    if (chat_socket_enabled) {
      /* using socket */
      chat_socket.emit('event_client_answer_call', { id: id }, function (response) {
        handle_answered_call(JSON.parse(response), false);
      });
    } else {
      /* using ajax */
      $.post(api['chat/call'], { 'do': 'answer_call', 'id': id }, function (response) {
        /* check if there is a callback */
        if (response.callback) {
          eval(response.callback);
          return;
        }
        handle_answered_call(response.call, false);
      }, 'json')
        .fail(function () {
          show_error_modal();
        });
    }
  });


  $('body').on('click', '.js_reply-message', function () {
    var _this = $(this);
    chat_set_reply(chat_widget_from(_this), _this.data('id'), _this.data('name'), _this.data('snippet'));
  });

  $('body').on('click', '.js_chat-reply-cancel', function () {
    chat_clear_reply(chat_widget_from(this));
  });

  $('body').on('click', '.js_chat-product-cancel', function () {
    chat_clear_product(chat_widget_from(this));
  });

  /* attach the product kept before opening the messages page */
  if (is_messages_page()) {
    try {
      var pending_product = JSON.parse(sessionStorage.getItem('chat_pending_product'));
      sessionStorage.removeItem('chat_pending_product');
      chat_set_product($('.panel-messages:first'), pending_product);
    } catch (error) { }
  }

  $('body').on('click', '.js_chat-reply-jump, .js_chat-pin-jump', function () {
    var scroller = $(this).closest('.chat-conversations');
    if (!scroller.length) {
      scroller = chat_widget_from(this).find('.chat-conversations').first();
    }
    var target = chat_message_el($(this).data('id'));
    if (target.length && scroller.length) {
      scroller.scrollTop(scroller.scrollTop() + target.offset().top - scroller.offset().top - 8);
    }
  });

  $('body').on('click', '.js_copy-message', function () {
    var text = $(this).closest('.conversation').attr('data-copy') || '';
    if (!text) return;
    if (navigator.clipboard && navigator.clipboard.writeText) {
      navigator.clipboard.writeText(text);
    } else {
      var input = $('<textarea>').val(text).appendTo('body').trigger('select');
      document.execCommand('copy');
      input.remove();
    }
  });

  $('body').on('click', '.js_delete-message', function () {
    var conversation = $(this).closest('.conversation');
    var message_id = conversation.attr('id');
    confirm(__['Delete'], __['Are you sure you want to delete this?'], function () {
      if (chat_socket_enabled) {
        chat_socket.emit('event_client_delete_message', { message_id: message_id }, function (response) {
          var data = JSON.parse(response);
          modal_close();
          chat_remove_message(data.message_id);
        });
      } else {
        $.post(api['chat/actions'], { 'do': 'delete_message', 'message_id': message_id }, function (response) {
          if (response.callback) {
            eval(response.callback);
            return;
          }
          modal_close();
          chat_remove_message(message_id);
        }, 'json').fail(function () {
          show_error_modal();
        });
      }
    });
  });

  $('body').on('click', '.js_pin-message', function () {
    var widget = chat_widget_from(this);
    var message_id = $(this).closest('.conversation').attr('id');
    if (chat_socket_enabled) {
      chat_socket.emit('event_client_pin_message', Object.assign({ do: 'pin', message_id: message_id }, chat_page_fields(widget)), function (response) {
        var data = JSON.parse(response);
        chat_apply_pin_html(widget, data.pin_html);
      });
    } else {
      $.post(api['chat/actions'], Object.assign({ 'do': 'pin', 'message_id': message_id }, chat_page_fields(widget)), function (response) {
        if (response.callback) {
          eval(response.callback);
          return;
        }
        chat_apply_pin_html(widget, response.pin_html);
      }, 'json').fail(function () {
        show_error_modal();
      });
    }
  });

  $('body').on('click', '.js_unpin-message', function () {
    var widget = chat_widget_from(this);
    var conversation_id = $(this).data('cid') || widget.data('cid');
    if (chat_socket_enabled) {
      chat_socket.emit('event_client_pin_message', Object.assign({ do: 'unpin', conversation_id: conversation_id }, chat_page_fields(widget)), function (response) {
        var data = JSON.parse(response);
        chat_apply_pin_html(widget, data.pin_html);
      });
    } else {
      $.post(api['chat/actions'], Object.assign({ 'do': 'unpin', 'conversation_id': conversation_id }, chat_page_fields(widget)), function (response) {
        if (response.callback) {
          eval(response.callback);
          return;
        }
        chat_apply_pin_html(widget, response.pin_html);
      }, 'json').fail(function () {
        show_error_modal();
      });
    }
  });

});