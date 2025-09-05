/**
 * chat js
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich - Handles - @sorydima @sorydev @durovshater @DmitrySoro90935 @tanechfund - also check https://dmitry.rechain.network for more information!
 */

// initialize API URLs
/* chat */
api['chat/live'] = ajax_path+"chat/live.php";
api['chat/settings'] = ajax_path+"users/settings.php?edit=chat";
api['messages/post'] = ajax_path+"chat/post.php";
api['messages/get'] = ajax_path+"chat/get.messages.php";
api['conversation/check'] = ajax_path+"chat/check.conversation.php";
api['conversation/get'] = ajax_path+"chat/get.conversation.php";
api['conversation/reaction'] = ajax_path+"chat/reaction.php";


// reconstruct chat-widgets
function reconstruct_chat_widgets() {
    if($(window).width() < 970) {
        return;
    }
    $('.chat-widget').each(function(index) {
        $(this).attr('style', '');
        index += 1;
        offset = (index*210) + (index*10);
        if($(this).prevAll('.chat-box').length > 0) {
            offset += $(this).prevAll('.chat-box').length*50;
        }
        if($('html').attr('dir') == 'RTL') {
            $(this).css('left', offset);
        } else {
            $(this).css('right', offset);
        }
    });
}


// chat box
function chat_box(user_id, conversation_id, name, name_list, multiple, link) {
    /* open the #chat_key */
    var chat_key_value = 'chat_';
    chat_key_value += (conversation_id)? conversation_id : 'u_'+user_id;
    var chat_key = '#' + chat_key_value;
    var chat_box = $(chat_key);
    /* check if this #chat_key already exists */
    if(chat_box.length == 0) {
        /* get conversation messages */
        if(conversation_id == false) {
            var data = {'user_id': user_id};
            if($('.chat-box[data-uid="'+user_id+'"]').length > 0) {
                /* select the opened one */
                chat_box = $('.chat-box[data-uid="'+user_id+'"]');
                /* open chat-box with that chat_key that already exists if not opened */
                if(!chat_box.hasClass('opened')) {
                    chat_box.addClass('opened').find('.chat-widget-content').slideToggle(200);
                }
                return;
            } else {
                /* construct a new one */
                $('body').append(render_template('#chat-box', {'chat_key_value': chat_key_value, 'user_id': user_id, 'conversation_id': conversation_id, 'name': name, 'name_list': name_list, 'multiple': multiple, 'link': link}));
                chat_box = $(chat_key);
                chat_box.find('.chat-widget-content').show();
                chat_box.find('textarea').focus();
                /* initialize the plugins */
                initialize();
                /* reconstruct chat-widgets */
                reconstruct_chat_widgets();
            }
        } else {
            var data = {'conversation_id': conversation_id};
            /* construct a new one */
            $('body').append(render_template('#chat-box', {'chat_key_value': chat_key_value, 'user_id': user_id, 'conversation_id': conversation_id, 'name': name, 'name_list': name_list, 'multiple': multiple, 'link': link}));
            chat_box = $(chat_key);
            chat_box.find('.chat-widget-content').show();
            chat_box.find('textarea').focus();
            /* initialize the plugins */
            initialize();
            /* reconstruct chat-widgets */
            reconstruct_chat_widgets();
        }
        $.getJSON(api['messages/get'], data, function(response) {
            /* check the response */
            if(!response) return;
            if(response.callback) {
                eval(response.callback);
                /* remove the chat-box */
                chat_box.remove();
            } else {
                if(response.conversation_id) {
                    if($('#chat_'+response.conversation_id).length > 0) {
                        /* remove the new chat-box */
                        chat_box.remove();
                        /* select the opened one */
                        chat_box = $('#chat_'+response.conversation_id);
                        /* open chat-box with that chat_key that already exists if not opened */
                        if(!chat_box.hasClass('opened')) {
                            chat_box.addClass('opened').find('.chat-widget-content').slideToggle(200);
                        }
                        chat_box.find('textarea').focus();
                        return;
                    } else {
                        chat_box.attr("id", 'chat_'+response.conversation_id);
                        chat_box.attr("data-cid", response.conversation_id);
                    }
                    chat_box.find('.x-form-tools-colors').show();
                }
                if(response.user_online !== undefined && response.user_online) {
                    chat_box.find(".js_chat-box-status").removeClass("fa-user-secret").addClass("fa-circle");
                }
                if(response.messages) {
                    chat_box.find(".js_scroller:first").html(response.messages).slimScroll({scrollTo : chat_box.find(".js_scroller:first").prop("scrollHeight") + "px"});
                }
                if(response.color) {
                    chat_box.attr("data-color", response.color);
                    color_chat_box(chat_box, response.color);
                }
            }
        })
        .fail(function() {
            /* remove the chat-box */
            chat_box.remove();
            modal('#modal-message', {title: __['Error'], message: __['There is something that went wrong!']});
        });
    } else {
        /* open chat-box with that chat_key that already exists if not opened */
        if(!chat_box.hasClass('opened')) {
            chat_box.addClass('opened').find('.chat-widget-content').slideToggle(200);
        }
        chat_box.find('textarea').focus();
        /* reconstruct chat-widgets */
        reconstruct_chat_widgets();
    }
}


// color chat box
function color_chat_box(chat_widget, color) {
    chat_widget.data('color', color);
    chat_widget.find('.js_chat-color-me').each(function() {
        if($(this).hasClass("js_chat-colors-menu-toggle")) {
            $(this).css("color", color);
        } else {
            $(this).css("background-color", color);
        }
    });
}


// chat heartbeat
function chat_heartbeat() {
    /* check if chat disabled */
    if(!chat_enabled && window.location.pathname.indexOf("messages") == -1) return;
    /* prepare client opened chat boxes with its last messages */
    var chat_boxes_opened_client = {}; // we use "objects" because JS don't support user-indexed array ;)
    $.each($('.chat-box:not(.fresh)'), function(i,chat_box) {
        if(!$(chat_box).data('sending')) {
            chat_boxes_opened_client[$(chat_box).data('cid')] = $(chat_box).find('.conversation:last').attr('id'); // object = {"cid": "last_message", ....}
        }
    });
    /* check if messages page is opened & there is a loaded converstaion */
    if(window.location.pathname.indexOf("messages") != -1 && $('.panel-messages').data('cid') !== undefined) {
        /* add the current loaded converstion */
        var opened_thread = {};
        if(!$('.panel-messages').data('sending')) {
            opened_thread['conversation_id'] = $('.panel-messages').data('cid');
            opened_thread['last_message_id'] = $('.panel-messages').find('.conversation:last').attr('id');
        }
        /* prepare data */
        var data = {'chat_enabled': $('body').data('chat-enabled'), 'chat_boxes_opened_client': JSON.stringify(chat_boxes_opened_client), 'opened_thread': JSON.stringify(opened_thread)};
    } else {
        /* prepare data */
        var data = {'chat_enabled': $('body').data('chat-enabled'), 'chat_boxes_opened_client': JSON.stringify(chat_boxes_opened_client)};
    }
    /* post to the server and get updates */
    $.post(api['chat/live'], data, function(response) {
        if(response.callback) {
            eval(response.callback);
        } else {
            /* [1] [update] master chat widget (online users) */
            if(response.master) {
                $("body").attr("data-chat-enabled", response.master.chat_enabled);
                $(".js_chat-online-users").text(response.master.online_friends_count);
                $(".chat-sidebar-content").find(".js_scroller").html(response.master.sidebar);
                $('.chat-sidebar-filter').keyup();
            }
            /* [2] [get] closed chat boxes */
            if(response.chat_boxes_closed !== undefined) {
                $.each(response.chat_boxes_closed, function(i,conversation) {
                    $('.chat-box[data-cid="'+conversation+'"]').remove();
                });
                /* reconstruct chat-widgets */
                reconstruct_chat_widgets();
            }
            /* [3] [get] opened chat boxes */
            if(response.chat_boxes_opened) {
                $.each(response.chat_boxes_opened, function(i,conversation) {
                    chat_box(conversation.user_id, conversation.conversation_id, conversation.name, conversation.name_list, conversation.multiple_recipients);
                });
            }
            /* [4] [get] updated chat boxes */
            if(response.chat_boxes_updated) {
                $.each(response.chat_boxes_updated, function(i,conversation) {
                    var chat_box_widget = $("#chat_"+conversation['conversation_id']);
                    /* check single user's chat status (online|offline) */
                    if(!conversation['multiple_recipients']) {
                        /* update single user's chat status */
                        if(conversation['user_online']) {
                            $("#chat_"+conversation['conversation_id']).find(".js_chat-box-status").removeClass("fa-user-secret").addClass("fa-circle");
                        } else {
                            $("#chat_"+conversation['conversation_id']).find(".js_chat-box-status").removeClass("fa-circle").addClass("fa-user-secret");
                        }
                    }
                    /* append messages */
                    if(conversation['messages']) {
                        if(window.location.pathname.indexOf("messages") == -1 || $('.panel-messages[data-cid="'+conversation['conversation_id']+'"]').length == 0) {
                            var chat_box_widget = $("#chat_"+conversation['conversation_id']);
                            chat_box_widget.find(".js_scroller:first ul").append(conversation['messages']);
                            chat_box_widget.find(".js_scroller:first").slimScroll({scrollTo : chat_box_widget.find(".js_scroller:first").prop("scrollHeight") + "px"});
                            if(!conversation['is_me']) {
                                if(!chat_box_widget.hasClass("opened")) {
                                    chat_box_widget.addClass("new").find(".js_chat-box-label").text(conversation['messages_count']);
                                }
                                if(chat_sound) {
                                    $("#chat-sound")[0].play();
                                }
                            }
                        }
                    }
                    /* update chat widget color */
                    color_chat_box(chat_box_widget, conversation['color']);
                });
            }
            /* [5] [get] new chat boxes */
            if(response.chat_boxes_new) {
                $.each(response.chat_boxes_new, function(i,conversation) {
                    if(!(window.location.pathname.indexOf("messages") != -1 && $('.panel-messages[data-cid="'+conversation['conversation_id']+'"]').length > 0)) {
                        chat_box(conversation.user_id, conversation.conversation_id, conversation.name, conversation.name_list, conversation.multiple_recipients);
                        if(chat_sound) {
                            $("#chat-sound")[0].play();
                        }
                    }
                });
            }
            /* [6] [get] updated thread */
            if(response.thread_updated) {
                if(window.location.pathname.indexOf("messages") != -1) {
                    var converstaion_widget = $('.panel-messages[data-cid="'+response.thread_updated['conversation_id']+'"]');
                    if(converstaion_widget.length > 0) {
                        /* append messages */
                        converstaion_widget.find(".js_scroller:first ul").append(response.thread_updated['messages']);
                        converstaion_widget.find(".js_scroller:first").slimScroll({scrollTo : converstaion_widget.find(".js_scroller:first").prop("scrollHeight") + "px"});
                        /* update chat widget color */
                        color_chat_box(converstaion_widget, response.thread_updated.color);
                        /* play chat sound */
                        if(chat_sound) {
                            $("#chat-sound")[0].play();
                        }
                    }   
                }
            }
        }
        setTimeout('chat_heartbeat()',min_chat_heartbeat);
    }, 'json');
}


$(function() {

    // initialize chat
    if(window.location.pathname.indexOf("messages") != -1 && $('.panel-messages').data('cid') !== undefined) {
        color_chat_box($('.panel-messages'), $('.panel-messages').attr("data-color"));
    }

    
    // start chat heartbeat
    setTimeout('chat_heartbeat()', 1000);


    // turn chat (on|off)
    $('body').on('click', '.js_chat-toggle', function (e) {
        e.preventDefault;
        var status = $(this).data('status');
        if(status == "on") {
            $('.chat-sidebar').addClass('disabled');
            $(this).data('status', "off");
            $(this).text(__['Turn On Chat']);
        } else {
            $(this).data('status', "on");
            $(this).text(__['Turn Off Chat']);
            $('.chat-sidebar').removeClass('disabled');
        }
        $.get(api['chat/settings'], {'privacy_chat': (status == "on")? 0 : 1}, function(response) {
            /* check the response */
            if(!response) return;
            /* check if there is a callback */
            if(response.callback) {
                eval(response.callback);
            }
        }, 'json')
        .fail(function() {
            modal('#modal-message', {title: __['Error'], message: __['There is something that went wrong!']});
        });
        return false;
    });
    

    // search chat contacts
    $('body').on('keyup', '.js_chat-search', function(event) {
        var search = $(this).val().toLowerCase();
        $('.chat-sidebar-content ul > li').each(function() {
            var item  = $(this).text().toLowerCase();
            (item.indexOf( search ) != -1) ? $(this).show() : $(this).hide();
        });
    });


    // chat-box
    $('body').on('click', '.js_chat-new', function(e) {
        if(!chat_enabled || $(window).width() < 970) { // Desktops (≥992px)
            /* system chat is disabled || mobile device */
            return;
        } else {
            e.preventDefault();
            /* open fresh chat-box */
            /* check if there is any fresh chat-box already exists */
            if($('.chat-box.fresh').length == 0) {
                /* construct a new one */
                $('body').append(render_template('#chat-box-new'));
                $('.chat-box.fresh').find('.chat-widget-content').show();
                /* initialize the main plugins */
                initialize();
                /* reconstruct chat-widgets */
                reconstruct_chat_widgets();
            } else {
                /* open fresh chat-box that already exists if not opened */
                if(!$('.chat-box.fresh').hasClass('opened')) {
                    $('.chat-box.fresh').addClass('opened');
                    $('.chat-box.fresh').find('.chat-widget-content').slideToggle(200);
                }
            }
        }
    });
    $('body').on('click', '.js_chat-start', function(e) {
        /* get data from (header conversation feeds || master online widget [desktop & mobile] ) */
        /* mandatory */
        var user_id = $(this).data('uid') || false;
        var conversation_id = $(this).data('cid') || false;
        /* optional */
        var name = $(this).data('name');
        var name_list = $(this).data('name-list') || name;
        var multiple = ($(this).data('multiple'))? true: false;
        var link = $(this).data('link');
        /* load previous conversation */
        /* check if the viewer in the messages page & open already conversation */
        if(window.location.pathname.indexOf("messages") != -1 && conversation_id) {
            e.preventDefault();
            $(".js_conversation-container").html('<div class="loader loader_medium pr10"></div>');
            $.getJSON(api['conversation/get'], {'conversation_id': conversation_id}, function(response) {
                /* check the response */
                if(response.callback) {
                    eval(response.callback);
                } else {
                    $(".js_conversation-container").html(response.conversation_html);
                    $('.panel-messages').attr("data-color", response.conversation.color);
                    color_chat_box($('.panel-messages'), response.conversation.color);
                }
            })
            .fail(function() {
                modal('#modal-message', {title: __['Error'], message: __['There is something that went wrong!']});
            });
        } else {
            /* check if chat disabled or opened from mobil */
            if(!chat_enabled || $(window).width() < 970) { // Desktops (≥992px)
                /* mobile view */
                if(conversation_id) {
                    /* conversation_id is set so return will allow anchor tag to be default */
                    return;
                } else {
                    e.preventDefault();
                    $.getJSON(api['conversation/check'], {'uid': user_id}, function(response) {
                        /* check the response */
                        if(!response) return;
                        if(response.callback) {
                            eval(response.callback);
                        } else {
                            if(response.conversation_id) {
                                window.location = site_path + "/messages/" + response.conversation_id;
                            } else {
                                window.location = site_path + "/messages/new?uid="+user_id;
                            }
                        }
                    })
                    .fail(function() {
                        modal('#modal-message', {title: __['Error'], message: __['There is something that went wrong!']});
                    });
                }
            } else {
                /* desktop view */
                e.preventDefault();
                /* load chat-box */
                chat_box(user_id, conversation_id, name, name_list, multiple, link);
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
        /* check if there is current (sending) process */
        if(widget.data('sending')) {
            return false;
        }
        /* get photo from widget data */
        var photo = widget.data('photo');
        /* check if message is empty */
        if(is_empty(message) && !photo) {
            return;
        }
        /* check if posting the message to (new || existed) conversation */
        if(widget.hasClass('fresh')) {
            /* post the message to -> a new conversation */
            /* check recipients */
            if(widget.find('.tags li').length == 0) {
                return;
            }
            /* get recipients */
            var recipients = [];
            $.each(widget.find('.tags li'), function(i,tag) {
                recipients.push($(tag).data('uid'));
            });
            var data = {'message': message, 'photo': JSON.stringify(photo), 'recipients': JSON.stringify(recipients)};
        } else {
            if(conversation_id === undefined) {
                /* post the message to -> a new conversation */
                /* get recipients */
                var recipients = [];
                recipients.push(widget.data('uid'));
                var data = {'message': message, 'photo': JSON.stringify(photo), 'recipients': JSON.stringify(recipients)};
            } else {
                /* post the message to -> already existed conversation */
                var data = {'message': message, 'photo': JSON.stringify(photo), 'conversation_id': conversation_id};
            }
        }
        /* add currenet sending process to widget data */
        widget.data('sending', true);
        $.post(api['messages/post'], data, function(response) {
            /* check the response */
            if(!response) return;
            /* check if there is a callback */
            if(response.callback) {
                eval(response.callback);
            } else {
                if(widget.hasClass('fresh')) {
                    if(window.location.pathname.indexOf("messages") != -1) {
                        /* in messages page */
                        window.location.replace(site_path+'/messages/'+response.conversation_id);
                    } else {
                        widget.remove();
                        chat_box(conversation.user_id, response.conversation_id, response.name, response.name_list, response.multiple_recipients, response.link);
                    }
                } else {
                    if(conversation_id === undefined) {
                        widget.attr("data-cid", response.conversation_id);
                        widget.find('.x-form-tools-colors').show();
                    }
                    textarea.focus().val('').height(textarea.css('line-height'));
                    widget.find(".js_scroller:first ul").append(render_template('#chat-message', {'message': response.message, 'image': response.image, 'id': response.last_message_id, 'time': moment.utc().format("YYYY-MM-DD H:mm:ss"), 'color': widget.data('color')}));
                    widget.find(".js_scroller:first").slimScroll({scrollTo : widget.find(".js_scroller:first").prop("scrollHeight") + "px"});
                    attachments.hide();
                    attachments.find('li.item').remove();
                    widget.removeData('photo')
                    widget.find('.x-form-tools-attach').show();
                    /* remove widget sending data */
                    widget.removeData('sending');
                }
            }
        }, 'json')
        .fail(function() {
            modal('#modal-message', {title: __['Error'], message: __['There is something that went wrong!']});
        });
    }
    $('body').on('keydown', 'textarea.js_post-message', function (event) {
        if($(window).width() >= 970 && (event.keyCode == 13 && event.shiftKey == 0)) {
            event.preventDefault();
            _post_message(this);
        }
    });
    $('body').on('click', 'li.js_post-message', function (event) {
        if($(window).width() < 970) {
            _post_message(this);
        }
    });
    /* chat attachment remover */
    $('body').on('click', '.js_chat-attachment-remover', function() {
        var widget = $(this).parents('.chat-widget, .panel-messages');
        var attachments = widget.find('.chat-attachments');
        var item = $(this).parents('li.item');
        /* remove the attachment from widget data */
        widget.removeData('photo')
        /* remove the attachment item */
        item.remove();
        /* hide attachments */
        attachments.hide();
        /* show widget form tools */
        widget.find('.x-form-tools-attach').show();
    });


    // toggle chat-widget
    $('body').on('click', '.chat-widget-head', function() {
        var widget = $(this).parents('.chat-widget');
        /* toggle 'opened' class */
        widget.toggleClass('opened');
        /* toggle widget content */
        widget.find('.chat-widget-content').slideToggle(200);
        /* scroll to latest message if has class new */
        if(widget.hasClass('new')) {
            widget.find(".js_scroller:first").slimScroll({scrollTo : widget.find(".js_scroller:first").prop("scrollHeight") + "px"});
            widget.removeClass('new');
        }
    });


    // close chat-widget
    $('body').on('click', '.js_chat-box-close', function() {
        var widget = $(this).parents('.chat-widget');
        widget.remove();
        /* reconstruct chat-widgets */
        reconstruct_chat_widgets();
        /* unset from session */
        if(widget.data('cid') !== undefined) {
            $.post(api['conversation/reaction'], {'do': 'close', 'conversation_id': widget.data('cid')}, function(response) {
                if(response.callback) {
                    eval(response.callback);
                }
            }, 'json')
            .fail(function() {
                modal('#modal-message', {title: __['Error'], message: __['There is something that went wrong!']});
            });
        }
    });


    // reconstruct chat widgets when resize window
    $(window).bind("resize", function() {
        reconstruct_chat_widgets();
    });


    // delete conversation
    $('body').on('click', '.js_delete-conversation', function() {
        confirm(__['Delete Conversation'], __['Are you sure you want to delete this conversation?'], function() {
            $.post(api['conversation/reaction'], {'do': 'delete', 'conversation_id': $('.panel-messages').data('cid')}, function(response) {
                if(response.callback) {
                    eval(response.callback);
                }
            }, 'json')
            .fail(function() {
                modal('#modal-message', {title: __['Error'], message: __['There is something that went wrong!']});
            });
        });
    });


    // run chat colors
    /* toggle(close|open) colors-menu */
    $('body').on('click', '.js_chat-colors-menu-toggle', function() {
        if($(this).parent().find('.chat-colors-menu').length == 0) {
            $(this).after(render_template("#chat-colors-menu"));
        }
        $(this).parent().find('.chat-colors-menu').toggle();
    });
    /* close chat-colors-menu when clicked outside */
    $('body').on('click', function(e) {
        if($(e.target).hasClass('js_chat-colors-menu-toggle') || $(e.target).parents('.js_chat-colors-menu-toggle').length > 0 || $(e.target).hasClass('chat-colors-menu') || $(e.target).parents('.chat-colors-menu').length > 0) {
           return;
       }
       $('.chat-colors-menu').hide();
    });
    /* change chat color */
    $('body').on('click', '.js_chat-color', function() {
        var chat_widget = $(this).parents('.chat-widget, .panel-messages');
        var conversation_id = chat_widget.data('cid');
        var color = $(this).data('color');
        color_chat_box(chat_widget, color);
        $('.chat-colors-menu').hide();
        $.post(api['conversation/reaction'], {'do': 'color', 'conversation_id': conversation_id, 'color': color}, function(response) {
            if(response.callback) {
                eval(response.callback);
            }
        }, 'json')
        .fail(function() {
            modal('#modal-message', {title: __['Error'], message: __['There is something that went wrong!']});
        });
    });


    // run audio call
    $('body').on('click', '.js_chat-voice-call', function() {
        modal('#chat-voice-calling');
        $("#voice-calling-sound")[0].play();
    });

});