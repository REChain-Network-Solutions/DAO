/**
 * chat js
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich - Handles - @sorydima @sorydev @durovshater @DmitrySoro90935 @tanechfund - also check https://dmitry.rechain.network for more information!
 */

// initialize API URLs
/* AJAX */
api['chat/live'] = ajax_path + 'chat/live.php';
api['chat/call'] = ajax_path + 'chat/call.php';
api['chat/post'] = ajax_path + 'chat/post.php';
api['chat/reaction'] = ajax_path + 'chat/reaction.php';
/* AJAX & Socket */
api['chat/messages'] = ajax_path + 'chat/messages.php';
api['chat/conversation/check'] = ajax_path + 'chat/conversation.php?do=check';
api['chat/conversation/get'] = ajax_path + 'chat/conversation.php?do=get';


// initialize chat global vars
var chat_socket = null;
var chatbox_closing_process = false;
var chat_calling_process = false;
var chat_ringing_process = false;
var chat_incall_process = false;
var chat_ending_call_timeout = null;


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
  if (chat_enabled) {
    var chatboxes = localStorage.getItem(`chatboxes_${user_id}`);
    if (chatboxes) {
      chatboxes = JSON.parse(chatboxes);
      $.each(chatboxes, function (i, chatbox) {
        chat_box(chatbox.user_id, chatbox.conversation_id, chatbox.name, chatbox.name_list, chatbox.multiple_recipients, chatbox.link, chatbox.picture);
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
    if (data.modal) {
      show_error_modal(data.message);
    }
  });

  // [listen] welcome
  chat_socket.on('event_server_welcome', (data) => {
    dlog("🔄 Welcome:", data.message);
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
    if (is_page('messages')) {
      /* check if there is opened thread */
      if ($('.panel-messages').data('cid') !== undefined) {
        var converstaion_widget = $('.panel-messages[data-cid="' + data.conversation.conversation_id + '"]');
        if (converstaion_widget.length > 0) {
          /* [1] check for a new messages for this thread */
          if (data.last_message) {
            converstaion_widget.find(".js_scroller:first ul").append(data.last_message);
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
          chat_box(data.conversation.user_id, data.conversation.conversation_id, data.conversation.name, data.conversation.name_list, data.conversation.multiple_recipients, data.conversation.link, data.conversation.picture);
        } else {
          chat_socket.emit('event_client_get_conversation', { conversation_id: data.conversation.conversation_id }, function (response) {
            var conversation = JSON.parse(response);
            chat_box(conversation.user_id, conversation.conversation_id, conversation.name, conversation.name_list, conversation.multiple_recipients, conversation.link, conversation.picture);
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

  // [listen] typing
  chat_socket.on('event_server_typing', (data) => {
    dlog("💬 Typing:", data);
    var conversation_id = data.conversation_id;
    /* check if (chatbox|thread) is opened */
    var converstaion_widget = $(`#chat_${conversation_id}, .panel-messages[data-cid="${conversation_id}"]`);
    if (converstaion_widget.length > 0) {
      if (data.typing_name_list) {
        converstaion_widget.find('.js_chat-typing-users').text(data.typing_name_list);
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
          last_message_box.find('.time').after(`<div class='seen'>${__['Seen by']} <span class="js_seen-name-list">${data.seen_name_list}</span></div>`);
          converstaion_widget.find('.js_scroller:first').scrollTop(converstaion_widget.find('.js_scroller:first')[0].scrollHeight);
        } else {
          var current_seen_list = seen_box.find('.js_seen-name-list');
          var existing_names = current_seen_list.text().split(',').map(s => s.trim());
          var new_names = data.seen_name_list.split(',').map(s => s.trim());
          var combined = [...new Set([...existing_names, ...new_names])];
          current_seen_list.text(combined.join(', '));
        }
      }
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

  // [listen] chat box opened (from other tabs)
  chat_socket.on('event_server_chatbox_opened', (data) => {
    dlog("📦 Chat box opened from another tab:", data.conversation_id);
    chat_box(data.user_id, data.conversation_id, data.name, data.name_list, data.multiple_recipients, data.link, data.picture, false);
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
    var size = (data.type == "video") ? "large" : "default";
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
    if ($('#modal').hasClass('show') && $('#modal').find('.js_chat-call-answer').length > 0) {
      $('#modal').modal('hide');
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
  /* remove from both lists if exists */
  offline_list.find(`[data-uid="${user.user_id}"]`).remove();
  online_list.find(`[data-uid="${user.user_id}"]`).remove();
  /* render contact html */
  var contact_html = `
    <div class="chat-avatar-wrapper clickable js_chat-start"
         data-uid="${user.user_id}"
         data-name="${user.user_fullname}"
         data-link="${user.user_name}"
         data-picture="${user.user_picture}">
      <div class="chat-avatar">
        <img src="${user.user_picture}" alt="" />
        <i class="online-status fa fa-circle ${user.user_is_online ? 'online' : 'offline'}"></i>
      </div>
      ${!user.user_is_online ? `<div class="last-seen"><span class="js_moment" data-time="${user.user_last_seen}">${user.user_last_seen}</span></div>` : '<div class="pb10"></div>'}
    </div>
  `;
  /* add to top of online/offline list */
  if (is_online) {
    online_list.prepend(contact_html);
  } else {
    offline_list.prepend(contact_html);
  }
  /* remove extra contacts if total is more than 20 */
  var total = online_list.children().length + offline_list.children().length;
  if (total > 20) {
    var to_remove = total - 20;
    offline_list.children().slice(-to_remove).remove();
  }
}


// chat box
function chat_box(user_id, conversation_id, name, name_list, multiple, link, picture, emit_event = true) {
  /* open the #chat_key */
  var chat_key_value = 'chat_';
  chat_key_value += (conversation_id) ? conversation_id : `u_${user_id}`;
  var chat_key = `#${chat_key_value}`;
  var chat_box = $(chat_key);
  /* check if this chat_box already exists OR any chatbox with data-uid with the same user_id is opened */
  if (chat_box.length == 0 && $(`.chat-box[data-uid="${user_id}"]`).length == 0) {
    var data = (conversation_id) ? { 'conversation_id': conversation_id } : { 'user_id': user_id };
    /* construct a new chat-box */
    $('body').append(render_template('#chat-box', { 'chat_key_value': chat_key_value, 'user_id': user_id, 'conversation_id': conversation_id, 'name': name.substring(0, 28), 'name_list': name_list, 'multiple': multiple, 'link': link, 'picture': picture }));
    chat_box = $(chat_key);
    chat_box.find('.chat-widget-content').show();
    chat_box.find('textarea').trigger('focus');
    /* initialize the plugins */
    initialize();
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
        chat_box.find('.x-form-tools-colors').show();
      }
      if (response.messages) {
        chat_box.find('.js_scroller:first').html(response.messages).scrollTop(chat_box.find('.js_scroller:first')[0].scrollHeight);
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
    })
      .done(function () {
        if (conversation_id && chat_socket_enabled) {
          var chatbox = {
            user_id: user_id,
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
    if (!conversation_id) {
      chat_box = $(`.chat-box[data-uid="${user_id}"]`);
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
    if (chatboxes.some(cb => cb.conversation_id === chatbox.conversation_id)) {
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
  $('.chat-widget').each(function (index) {
    $(this).attr('style', '');
    index += 1;
    offset = (index * 80) + (index * 10);
    if ($(this).prevAll('.chat-box').length > 0) {
      offset += $(this).prevAll('.chat-box').length * 260;
    }
    if ($('html').attr('dir') == 'RTL') {
      $(this).css('left', offset);
    } else {
      $(this).css('right', offset);
    }
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
  if (!chat_enabled && !is_page('messages')) {
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
      $('.chat-sidebar-content').find('.js_scroller').html(response.master.sidebar);
      $('.tooltip').remove();
    }
    /* [3] & [4] & [5] & [6] check if the user not in messages page */
    if (!is_page('messages')) {
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
          chat_box(conversation.user_id, conversation.conversation_id, conversation.name, conversation.name_list, conversation.multiple_recipients, conversation.link, conversation.picture);
        });
      }
      /* [5] [get] updated chat boxes */
      if (response.chat_boxes_updated) {
        $.each(response.chat_boxes_updated, function (i, conversation) {
          var chat_box_widget = $(`#chat_${conversation['conversation_id']}`);
          /* [1] check for a new messages for this chat box */
          if (conversation['messages']) {
            chat_box_widget.find('.js_scroller:first ul').append(conversation['messages']);
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
            chat_box_widget.find('.js_chat-typing-users').text(conversation['typing_name_list']);
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
                last_message_box.find('.time').after(`<div class='seen'>${__['Seen by']} ${conversation['seen_name_list']}<div>`);
                chat_box_widget.find('.js_scroller:first').scrollTop(chat_box_widget.find('.js_scroller:first')[0].scrollHeight);
              } else {
                /* update seen status */
                last_message_box.find('.seen').replaceWith(`<div class='seen'>${__['Seen by']} ${conversation['seen_name_list']}<div>`);
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
          chat_box(conversation.user_id, conversation.conversation_id, conversation.name, conversation.name_list, conversation.multiple_recipients, conversation.link, conversation.picture);
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
            converstaion_widget.find('.js_scroller:first').scrollTop(converstaion_widget.find('.js_scroller:first')[0].scrollHeight);
            if (!response.thread_updated['is_me']) {
              /* update this convertaion seen status (if enabled by the system) */
              if (chat_seen_enabled) {
                updated_seen_conversations.push(response.thread_updated['conversation_id']);
              }
              if (chat_sound) {
                $('#chat-sound')[0].play();
              }
            }
          }
          /* [2] check if any recipient typing */
          if (response.thread_updated['typing_name_list']) {
            converstaion_widget.find('.js_chat-typing-users').text(response.thread_updated['typing_name_list']);
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
                last_message_box.find('.time').after(`<div class='seen'>${__['Seen by']} ${response.thread_updated['seen_name_list']}<div>`);
                converstaion_widget.find('.js_scroller:first').scrollTop(converstaion_widget.find('.js_scroller:first')[0].scrollHeight);
              } else {
                /* update seen status */
                last_message_box.find('.seen').replaceWith(`<div class='seen'>${__['Seen by']} ${response.thread_updated['seen_name_list']}<div>`);
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
        var size = (type == 'video') ? 'large' : 'default';
        modal('#chat-ringing', { type: type, is_video: is_video, is_audio: is_audio, id: response.call['call_id'], name: response.call['caller_name'], picture: response.call['caller_picture'] }, size);
        /* play ringing sound */
        $('#chat-ringing-sound')[0].play();
      }
    } else {
      if (chat_incall_process == false && chat_ringing_process == true) {
        /* update chat ringing process */
        chat_ringing_process = false;
        /* close the ringing modal (if exist) */
        if ($('#modal').hasClass('show') && $('#modal').find('.js_chat-call-answer').length > 0) {
          $('#modal').modal('hide');
        }
        /* stop ringing sound */
        $('#chat-ringing-sound')[0].stop();
      }
    }
    // update convertaion(s) seen status
    if (chat_seen_enabled && updated_seen_conversations.length > 0) {
      $.post(api['chat/reaction'], { 'do': 'seen', 'ids': updated_seen_conversations }, function (response) {
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
  var size = (type == "video") ? "large" : "default";
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
      $(".js_chat-call-close").show();
      $('.js_chat-calling-message').html(__['You can not connect to this user']);
      break;

    case "recipient_offline":
      $(".js_chat-call-close").show();
      $('.js_chat-calling-message').html("<span style='color: red'>" + __['is Offline'] + "</span>");
      break;

    case "recipient_busy":
      $(".js_chat-call-close").show();
      $('.js_chat-calling-message').html("<span style='color: red'>" + __['is Busy'] + "</span>");
      break;

    case "caller_busy":
      $(".js_chat-call-close").show();
      $('.js_chat-calling-message').html("<span style='color: red'>" + __['You have an active call already'] + "</span>");
      break;

    default:
      $(".js_chat-call-cancel").attr("data-id", call.call_id).data("id", call.call_id).show();
      $('.js_chat-calling-message').html(__['Ringing'] + '<span class="loading-dots"></span>');
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
        $(".js_chat-call-close").show();
        $(".js_chat-call-cancel").hide();
        $('.js_chat-calling-message').html("<span style='color: red'>" + __['No Answer'] + "</span>");
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
  /* show the modal close button */
  $(".js_chat-call-close").show();
  /* hide the call cancel button */
  $(".js_chat-call-cancel").hide();
  /* update calling message */
  $('.js_chat-calling-message').html(__['Declined the call']);
  /* stop calling sound */
  $("#chat-calling-sound")[0].stop();
  /* remove the ending call callback timeout */
  clearTimeout(chat_ending_call_timeout);
}


// handle answered call
function handle_answered_call(call, is_caller = true) {
  var type = (call.is_video_call) ? "video" : "audio";
  chat_incall_process = true;
  chat_incall_heartbeat(call['call_id']);
  if (is_caller) {
    var token = call['from_user_token'];
    chat_calling_process = false;
  } else {
    var token = call['to_user_token'];
    chat_ringing_process = false;
  }
  if (is_caller) {
    $(".js_chat-call-cancel").hide();
  } else {
    $(".js_chat-call-answer").hide();
    $(".js_chat-call-decline").hide();
  }
  $(".js_chat-call-end").attr("data-id", call['call_id']).data("id", call['call_id']).show();
  /* update calling message */
  var timer = new easytimer.Timer();
  timer.start();
  timer.addEventListener('secondsUpdated', function (e) {
    $('.js_chat-calling-message').html("<span style='color: red'>" + timer.getTimeValues().toString() + "</span>");
  });
  /* stop calling sound */
  if (is_caller) {
    $("#chat-calling-sound")[0].stop();
  } else {
    $("#chat-ringing-sound")[0].stop();
  }
  /* remove the ending call callback timeout */
  clearTimeout(chat_ending_call_timeout);
  if (audio_video_provider == "twilio") {
    /* init_Twilio */
    init_Twilio(type, token, call['room'], call['call_id']);
  } else if (audio_video_provider == "livekit") {
    /* init_LiveKit */
    init_LiveKit(type, token, call['room'], call['call_id']);
  } else if (audio_video_provider == "agora") {
    /* init_Agora */
    init_Agora(type, token, call['room'], call['call_id']);
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


// init Twilio
async function init_Twilio(type, token, room_name, call_id) {
  var is_video = (type == "video") ? { height: 720, frameRate: 24, width: 1280 } : false;

  const localTracks = await Twilio.Video.createLocalTracks({
    audio: true,
    video: is_video
  }).catch(() => alert('Sorry, WebRTC is not available in your browser'));

  const localVideoTrack = localTracks.find(track => track.kind === 'video');

  if (type == "video" && localVideoTrack) {
    const divLocal = document.createElement('div');
    const videoElement = localVideoTrack.attach();
    videoElement.setAttribute('playsinline', '');
    videoElement.setAttribute('webkit-playsinline', '');
    divLocal.appendChild(videoElement);
    $('.video-call-stream-local').html(divLocal).show();
  }

  const room = await Twilio.Video.connect(token, {
    name: room_name,
    tracks: localTracks
  });

  room.participants.forEach(participant => {
    participant.videoTracks.forEach(publication => {
      if (publication.track) {
        const videoElement = publication.track.attach();
        videoElement.setAttribute('playsinline', '');
        videoElement.setAttribute('webkit-playsinline', '');
        $('.video-call-stream')[0].appendChild(videoElement);
      }
    });
    participant.on('trackSubscribed', track => {
      const videoElement = track.attach();
      videoElement.setAttribute('playsinline', '');
      videoElement.setAttribute('webkit-playsinline', '');
      $('.video-call-stream')[0].appendChild(videoElement);
    });
  });

  room.on('participantConnected', participant => {
    participant.videoTracks.forEach(publication => {
      if (publication.isSubscribed) {
        const track = publication.track;
        const videoElement = track.attach();
        videoElement.setAttribute('playsinline', '');
        videoElement.setAttribute('webkit-playsinline', '');
        $('.video-call-stream')[0].appendChild(videoElement);
      }
    });
    participant.on('trackSubscribed', track => {
      const videoElement = track.attach();
      videoElement.setAttribute('playsinline', '');
      videoElement.setAttribute('webkit-playsinline', '');
      $('.video-call-stream')[0].appendChild(videoElement);
    });
  });

  room.on('participantDisconnected', participantDisconnected);
  room.once('disconnected', error => room.participants.forEach(participantDisconnected));

  $(document).on('click', '.js_chat-call-end', function () {
    room.disconnect();
  });

  function participantDisconnected(participant) {
    participant.tracks.forEach(publication => {
      if (publication.track) {
        publication.track.detach().forEach(element => element.remove());
      }
    });
    /* end the call */
    $.post(api['chat/call'], { 'do': 'decline_call', 'id': call_id }, 'json');
    alert(__['Connection has been lost']);
    /* reload the page */
    window.location.reload();
  }
}


// init LiveKit
async function init_LiveKit(type, token, room_name, call_id) {
  var is_video = (type === "video");

  const localTracks = await LivekitClient.createLocalTracks({
    audio: true,
    video: is_video
  }).catch(() => alert('Sorry, WebRTC is not available in your browser'));

  const localVideoTrack = localTracks.find(track => track.kind === 'video');

  if (is_video && localVideoTrack) {
    const divLocal = document.createElement('div');
    const videoElement = localVideoTrack.attach();
    videoElement.setAttribute('playsinline', '');
    videoElement.setAttribute('webkit-playsinline', '');
    divLocal.appendChild(videoElement);
    $('.video-call-stream-local').html(divLocal).show();
  }

  const room = new LivekitClient.Room({
    adaptiveStream: true,
    dynacast: true,
    videoCaptureDefaults: is_video ? { resolution: LivekitClient.VideoPresets.h720.resolution } : undefined,

  });
  room.prepareConnection(livekit_ws_url, token);
  room
    .on(LivekitClient.RoomEvent.TrackSubscribed, handleTrackSubscribed)
    .on(LivekitClient.RoomEvent.TrackUnsubscribed, handleTrackUnsubscribed)
    .on(LivekitClient.RoomEvent.Disconnected, handleDisconnect)
    .on(LivekitClient.RoomEvent.ParticipantDisconnected, handleParticipantDisconnected);
  await room.connect(livekit_ws_url, token);
  await room.localParticipant.enableCameraAndMicrophone();

  function handleTrackSubscribed(track) {
    if (track.kind === LivekitClient.Track.Kind.Video) {
      const div = document.createElement('div');
      div.appendChild(track.attach());
      $('.video-call-stream')[0].appendChild(div);
    } else if (track.kind === LivekitClient.Track.Kind.Audio) {
      track.attach();
    }
  }

  function handleTrackUnsubscribed(track) {
    if (track.kind === LivekitClient.Track.Kind.Video) {
      track.detach().forEach(element => element.remove());
    } else if (track.kind === LivekitClient.Track.Kind.Audio) {
      track.detach().forEach(element => element.remove());
    }
  }

  function handleDisconnect() {
    $.post(api['chat/call'], { 'do': 'decline_call', 'id': call_id }, 'json');
    alert(__['Connection has been lost']);
    window.location.reload();
  }

  function handleParticipantDisconnected(participant) {
    room.disconnect();
  }

  $(document).on('click', '.js_chat-call-end', function () {
    room.disconnect();
  });
}


// init Agora
async function init_Agora(type, token, room_name, call_id) {
  var is_video = (type === "video");

  const localTracks = await AgoraRTC.createMicrophoneAndCameraTracks({
    audio: true,
    video: is_video
  }).catch(() => alert('Sorry, WebRTC is not available in your browser'));

  const localVideoTrack = localTracks[1];

  if (is_video && localVideoTrack) {
    localVideoTrack.play($('.video-call-stream-local')[0]);
    $('.video-call-stream-local').show();
  }

  const client = AgoraRTC.createClient({ mode: 'rtc', codec: 'vp8' });
  await client.join(agora_call_app_id, room_name, token, user_id);
  await client.publish(localTracks);

  client.on('user-published', async (user, mediaType) => {
    await client.subscribe(user, mediaType);
    if (mediaType === 'video') {
      const remoteVideoTrack = user.videoTrack;
      $('.video-call-stream').css('height', '420px');
      remoteVideoTrack.play($('.video-call-stream')[0]);
    } else if (mediaType === 'audio') {
      user.audioTrack.play();
    }
  });

  client.on('user-left', (user) => {
    handleParticipantDisconnected(user);
  });

  function handleDisconnect() {
    $.post(api['chat/call'], { 'do': 'decline_call', 'id': call_id }, 'json');
    alert(__['Connection has been lost']);
    window.location.reload();
  }

  function handleParticipantDisconnected(user) {
    $('.video-call-stream div').each(function () {
      if (this.contains(user.videoTrack?.element)) {
        this.remove();
      }
    });
    handleDisconnect();
  }

  $(document).on('click', '.js_chat-call-end', function () {
    client.leave().then(() => {
      handleDisconnect();
    });
  });
}

$(function () {

  // init chat socket
  init_chat_socket();


  // init messages page
  if (is_page('messages') && $('.panel-messages').data('cid') !== undefined) {
    /* open thread */
    if (chat_socket_enabled) {
      chat_socket.emit('event_client_open_thread', { conversation_id: $('.panel-messages').data('cid') });
    }
    /* color panel messages (messages page) */
    color_chat_box($('.panel-messages'), $('.panel-messages').attr("data-color"));
    /* update scroll position */
    $('.panel-messages').find('.js_scroller:first').scrollTop($('.panel-messages').find('.js_scroller:first')[0].scrollHeight);
  }


  // turn chat (on|off)
  $('body').on('click', '.js_chat-toggle', function (e) {
    e.preventDefault;
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
  });


  // chat-box
  $('body').on('click', '.js_chat-new', function (e) {
    e.preventDefault();
    /* check if chat disabled */
    if (!chat_enabled) {
      return;
    }
    /* check if opened from mobile (anchor tag will be triggered) */
    if (is_mobile()) {
      return;
    }
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
  $('body').on('click', '.js_chat-start', function (e) {
    /* mandatory */
    var user_id = $(this).data('uid') || false;
    var conversation_id = $(this).data('cid') || false;
    /* optional */
    var name = $(this).data('name');
    var name_list = $(this).data('name-list') || name;
    var multiple = ($(this).data('multiple')) ? true : false;
    var link = $(this).data('link');
    var picture = $(this).data('picture');
    var chatbox_enabled = $(this).data('chat-box');
    /* check if the viewer in the messages page */
    if (is_page('messages')) {
      /* [A] user is in the messages page */
      e.preventDefault();
      if (!conversation_id) {
        /* [1] starting a new conversation */
        redirect_to_thread(user_id);
      } else {
        /* [2] loading existing conversation */
        $('.sg-offcanvas').removeClass('active');
        $('.sg-offcanvas').css('minHeight', 'unset');
        $(".js_conversation-container").html('<div class="loader loader_medium pr10"></div>');
        $.getJSON(api['chat/conversation/get'], { 'conversation_id': conversation_id }, function (response) {
          /* check if there is a callback */
          if (response.callback) {
            eval(response.callback);
            return;
          }
          /* handle response */
          $(".js_conversation-container").html(response.conversation_html);
          $('.panel-messages').attr("data-color", response.conversation.color);
          color_chat_box($('.panel-messages'), response.conversation.color);
        })
          .done(function () {
            if (chat_socket_enabled) {
              chat_socket.emit('event_client_open_thread', { conversation_id: conversation_id });
            }
          })
          .fail(function () {
            show_error_modal();
          });
      }
    } else {
      /* [B] user is not in the messages page */
      if (!chat_enabled || is_mobile()) {
        /* [1] chat disabled or mobile view */
        if (conversation_id) return; /* (return will allow default behave of anchor tag) */
        e.preventDefault();
        redirect_to_thread(user_id);
      } else {
        /* [2] chat enabled & desktop view */
        if (chatbox_enabled) return; /* (return will allow default behave of anchor tag) */
        e.preventDefault();
        chat_box(user_id, conversation_id, name, name_list, multiple, link, picture);
      }
    }
    /* redirect to thread */
    function redirect_to_thread(user_id) {
      $.getJSON(api['chat/conversation/check'], { 'uid': user_id }, function (response) {
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
      widget.find('.js_chat-box-label').text(0);
      /* update this convertaion seen status (if enabled by the system) */
      if (chat_seen_enabled && conversation_id) {
        if (chat_socket_enabled) {
          /* using socket */
          chat_socket.emit('event_client_seen', { ids: [conversation_id] });
        } else {
          /* using ajax */
          $.post(api['chat/reaction'], { 'do': 'seen', 'ids': [conversation_id] }, function (response) {
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
        $.post(api['chat/reaction'], { 'do': 'close', 'conversation_id': conversation_id }, function (response) {
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
    var widget = _this.parents('.chat-widget, .panel-messages');
    var textarea = widget.find('textarea.js_post-message');
    var message = textarea.val();
    var conversation_id = widget.data('cid');
    var attachments = widget.find('.chat-attachments');
    var attachments_voice_notes = widget.find('.chat-voice-notes');
    var chat_price = widget.data('chat-price') || 0;
    /* get photo from widget data */
    var photo = widget.data('photo');
    /* get voice note from widget data */
    var voice_note = widget.data('voice_notes');
    /* check if message is empty */
    if (is_empty(message) && !photo && !voice_note) {
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
      var data = { 'message': message, 'photo': JSON.stringify(photo), 'voice_note': JSON.stringify(voice_note), 'recipients': JSON.stringify(recipients) };
    } else {
      if (conversation_id === undefined) {
        /* post the message to -> a new conversation */
        /* get recipients */
        var recipients = [];
        recipients.push(widget.data('uid'));
        var data = { 'message': message, 'photo': JSON.stringify(photo), 'voice_note': JSON.stringify(voice_note), 'recipients': JSON.stringify(recipients) };
      } else {
        /* post the message to -> already existed conversation */
        var data = { 'message': message, 'photo': JSON.stringify(photo), 'voice_note': JSON.stringify(voice_note), 'conversation_id': conversation_id };
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
      if (widget.data('sending')) {
        return false;
      }
      /* add the message directly if widget not fresh & not sending photo & not sending voice note */
      if (!widget.hasClass('fresh') && photo === undefined && voice_note === undefined) {
        textarea.trigger('focus').val('').height(textarea.css('line-height'));
        var _guid = guid()
        widget.find(".js_scroller:first ul").append(render_template('#chat-message', { 'message': htmlEntities(message), 'id': _guid, 'time': moment.utc().format("YYYY-MM-DD H:mm:ss") }));
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
        eval(response.callback);
        return;
      }
      /* handle response */
      if (widget.hasClass('fresh')) {
        if (is_page('messages')) {
          /* in messages page */
          window.location.replace(site_path + '/messages/' + response.conversation_id);
        } else {
          widget.remove();
          chat_box(response.user_id, response.conversation_id, response.name, response.name_list, response.multiple_recipients, response.link, response.picture);
        }
      } else {
        if (conversation_id === undefined) {
          widget.attr("id", "chat_" + response.conversation_id);
          widget.attr("data-cid", response.conversation_id);
          widget.find('.x-form-tools-colors').show();
        }
        if (photo === undefined && voice_note === undefined) {
          widget.find(".js_scroller:first ul").find("#" + _guid).replaceWith(render_template('#chat-message', { 'message': response.message, 'image': response.image, 'voice_note': response.voice_note, 'id': response.last_message_id, 'time': moment.utc().format("YYYY-MM-DD H:mm:ss"), 'color': widget.data('color') }));
        } else {
          textarea.trigger('focus').val('').height(textarea.css('line-height'));
          widget.find(".js_scroller:first ul").append(render_template('#chat-message', { 'message': response.message, 'image': response.image, 'voice_note': response.voice_note, 'id': response.last_message_id, 'time': moment.utc().format("YYYY-MM-DD H:mm:ss"), 'color': widget.data('color') }));
          widget.find(".js_scroller:first .seen").remove(); // remove any seen status before
          widget.find(".js_scroller:first").scrollTop(widget.find(".js_scroller:first")[0].scrollHeight);
          /* handle attachments */
          attachments.hide();
          attachments.find('li.item').remove();
          widget.removeData('photo');
          widget.find('.x-form-tools-attach').show();
          widget.removeData('voice_notes');
          widget.find('.x-form-tools-voice').show();
          attachments_voice_notes.hide();
          attachments_voice_notes.find(".js_voice-success-message").hide();
          attachments_voice_notes.find('.js_voice-start').show();
        }
        /* remove currenet sending process */
        widget.removeData('sending');
        /* clear typing timer */
        clearTimeout(chat_typing_timer);
        /* update typing status */
        if (chat_socket_enabled) {
          chat_socket.emit('event_client_typing', { conversation_id: conversation_id, is_typing: false });
        } else {
          $.post(api['chat/reaction'], { 'do': 'typing', 'is_typing': false, 'conversation_id': conversation_id }, function (response) {
            if (response.callback) {
              eval(response.callback);
            }
          }, 'json');
        }
      }
      /* hide the confimation if it exists */
      if ($('#modal').hasClass('show')) {
        $('#modal').modal('hide');
      }
    }
  }
  $('body').on('keydown', 'textarea.js_post-message', function (event) {
    if (!is_mobile() && (event.originalEvent.key == 'Enter' && event.shiftKey == 0)) {
      event.preventDefault();
      _post_message(this);
    }
  });
  $('body').on('click', 'li.js_post-message', function (event) {
    if (is_mobile()) {
      _post_message(this);
    }
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
        chat_socket.emit('event_client_typing', { conversation_id: conversation_id, is_typing: is_typing });
      } else {
        /* using ajax */
        $.post(api['chat/reaction'], { 'do': 'typing', 'is_typing': is_typing, 'conversation_id': conversation_id }, function (response) {
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
    if ($(this).parent().find('.chat-colors-menu').length == 0) {
      $(this).after(render_template('#chat-colors-menu'));
    }
    $(this).parent().find('.chat-colors-menu').toggle();
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
      $.post(api['chat/reaction'], { 'do': 'color', 'conversation_id': conversation_id, 'color': color }, function (response) {
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
        $.post(api['chat/reaction'], { 'do': 'delete', 'conversation_id': conversation_id }, function (response) {
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
        $.post(api['chat/reaction'], { 'do': 'leave', 'conversation_id': conversation_id }, function (response) {
          /* redirect to messages page */
          window.location.replace(site_path + '/messages');
        }, 'json')
          .fail(function () {
            show_error_modal();
          });
      }
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
      window.location.href = site_path;
    } else {
      $.post(api['chat/call'], { 'do': 'end_call', 'id': id }, function (response) {
        /* check if there is a callback */
        if (response.callback) {
          eval(response.callback);
          return;
        }
        window.location.href = site_path;
      }, 'json')
        .fail(function () {
          show_error_modal();
        });
    }
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

});