/**
 * user js
 * 
 * @package Sngine
 * @author Zamblek
 */

// initialize API URLs
api['data/live']  = ajax_path+"data/live.php";
api['data/upload']  = ajax_path+"data/upload.php";
api['data/reset']  = ajax_path+"data/reset.php";
api['data/report']  = ajax_path+"data/report.php";

api['users/image']  = ajax_path+"users/image.php";
api['users/connect']  = ajax_path+"users/connect.php";
api['users/verify']  = ajax_path+"users/verify.php";
api['users/delete']  = ajax_path+"users/delete.php";
api['users/session']  = ajax_path+"users/session.php";
api['users/popover']   = ajax_path+"users/popover.php";
api['users/mention']  = ajax_path+"users/mention.php";
api['users/settings']  = ajax_path+"users/settings.php";
api['users/autocomplete']  = ajax_path+"users/autocomplete.php";

api['pages_groups_events/delete']  = ajax_path+"pages_groups_events/delete.php";


// initialize the modal (plugins)
function initialize_modal() {
    // run bootstrap selectpicker plugin
    $('.selectpicker').selectpicker({
        style: 'btn-option'
    });
    // run datetimepicker plugin
    $('.js_datetimepicker').datetimepicker();
    // initialize uploader 
    initialize_uploader();
}


// initialize uploader
function initialize_uploader() {
    $('.js_x-uploader').each(function(index) {
        /* return if the plugin already running  */
        if($(this).parents('form.x-uploader').length > 0) {
            return;
        }
        var multiple = ($(this).data('multiple') !== undefined)? true : false;
        $(this).before(render_template("#x-uploader", {'url': api['data/upload'], 'secret': secret, 'multiple': multiple}));
        $(this).prev().append($(this));
    });
}


// browser notification
function browser_notification(icon, body, url, tag) {
    /* check if the browser supports notifications */
    if(!("Notification" in window)) {
        return;
    }
    /* check whether notification permissions have alredy been granted */
    if(Notification.permission !== "granted") {
        /* request permission */
        Notification.requestPermission();
    } else {
        /* send notification */
        var notification = new Notification(site_title, {
            icon: icon,
            body: body,
            tag: tag
        });
        notification.onclick = function () {
            window.open(url);
            notification.close();
        };
    }
}


// noty notification
function noty_notification(image, message, url) {
    new Noty({
        type: 'info',
        layout: 'bottomLeft',
        progressBar: 'true',
        closeWith: ['click', 'button'],
        timeout: "5000",
        text: render_template('#noty-notification', {'image': image, 'message': message}),
        callbacks: {
            onClick: function() {
                window.location.href = url;
            }
        }
    }).show();
}


// notification highlighter
function notification_highlighter() {
    try {
        var search_params = new URLSearchParams(window.location.search);
        var notify_id = search_params.get("notify_id");
    } catch(err) {
        var notify_id = getParameterByName("notify_id");
    }
    if(notify_id) {
        var _elem = $('#'+notify_id);
        if(_elem.length > 0) {
            $('html, body').animate({
                scrollTop: _elem.offset().top
            }, 1000);
            _elem.find('.js_notifier-flasher:first').addClass("x-notifier");
            setTimeout(function() {
                _elem.find('.js_notifier-flasher:first').removeClass("x-notifier");
                }, '2500');
        }
    }
}
function getParameterByName(name) {
    var url = window.location.href;
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
        results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, " "));
}


// progress bar
function progress_bar(timer) {
    $('body').prepend('<div id="ProgressBar"></div>');
    var bar = $('#ProgressBar');
    var smooth = 10;
    var unit = (smooth*100)/timer;
    var width = unit;
    var interval = setInterval(function() {
        if (width >= 100) {
            clearInterval(interval);
            bar.remove();
        } else {
            width = width + unit;
            bar.width(width + '%');
        }
    }, smooth);
}


// data heartbeat
function data_heartbeat() {
    var data = {};
    data['last_request'] = $(".js_live-requests").find(".js_scroller li:first").data('id') || 0;
    data['last_message'] = $(".js_live-messages").find(".js_scroller li:first").data('last-message') || 0;
    data['last_notification'] = $(".js_live-notifications").find(".js_scroller li:first").data('id') || 0;
    /* newsfeed check */
    var posts_stream =  $('.js_posts_stream');
    if(posts_stream.length > 0 && posts_stream.data('get') != 'saved' && posts_stream.data('loading') === undefined) {
        data['last_post'] = posts_stream.find("li:first .post").data('id') || 0;
        data['get'] = posts_stream.data('get');
        data['filter'] = posts_stream.data('filter');
        data['id'] = posts_stream.data('id');
    }
    $.post(api['data/live'], data, function(response) {
        if(response.callback) {
            eval(response.callback);
        } else {
            if(response.requests) {
                if($(".js_live-requests").find(".js_scroller ul").length > 1) {
                    $(".js_live-requests").find(".js_scroller ul:first").prepend(response.requests);
                } else {
                    $(".js_live-requests").find(".js_scroller p:first").replaceWith("<ul>"+response.requests+"</ul>");
                }
                var requests = parseInt($(".js_live-requests").find("span.label").text()) + response.requests_count;
                $(".js_live-requests").find("span.label").text(requests).removeClass("hidden");
                $("#notification_sound")[0].play();
            }
            if(response.conversations) {
                $(".js_live-messages").find(".js_scroller").html("<ul>"+response.conversations+"</ul>");
                /* update live messages in messages page */
                if(window.location.pathname.indexOf("messages") != -1) {
                    if($(".js_live-messages-alt").find(".js_scroller ul").length > 0) {
                        $(".js_live-messages-alt").find(".js_scroller ul").html(response.conversations);
                    } else {
                        $(".js_live-messages-alt").find(".js_scroller").html("<ul>"+response.conversations+"</ul>");
                    }
                }
                if(response.conversations_count > 0) {
                    $(".js_live-messages").find("span.label").text(response.conversations_count).removeClass("hidden");
                    $("#chat_sound")[0].play();
                } else {
                    $(".js_live-messages").find("span.label").text(response.conversations_count);
                }
            }
            if(response.notifications) {
                $.each(response.notifications_json, function(index, element) {
                    /* send browser notifications */
                    browser_notification(element.user_picture, element.full_message, element.url, element.notification_id);
                    /* send noty notifications */
                    noty_notification(element.user_picture, element.full_message, element.url);
                });
                if($(".js_live-notifications").find(".js_scroller ul").length > 0) {
                    $(".js_live-notifications").find(".js_scroller ul").prepend(response.notifications);
                } else {
                    $(".js_live-notifications").find(".js_scroller").html("<ul>"+response.notifications+"</ul>");
                }
                var notifications = parseInt($(".js_live-notifications").find("span.label").text()) + response.notifications_count;
                $(".js_live-notifications").find("span.label").text(notifications).removeClass("hidden");
                if(notifications_sound) {
                    $("#notification_sound")[0].play();    
                }
            }
            if(response.posts) {
                posts_stream.find('ul:first').prepend(response.posts);
                setTimeout(photo_grid(), 200);
            }
            setTimeout('data_heartbeat();',min_data_heartbeat);
        }
    }, 'json');
}


$(function() {

    // init geocomplete plugin
    if(geolocation_enabled) {
        $(".js_geocomplete").geocomplete();
    }


    // init datetimepicker plugin
    $('.js_datetimepicker').datetimepicker();
    

    // init bootstrap selectpicker plugin
    $('.selectpicker').selectpicker({
        style: 'btn-option'
    });


    // init tinymce
    tinymce.init({
        selector: '.js_wysiwyg',
        branding: false,
        height: 300,
        toolbar: 'insertfile undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image  uploadImages |  preview media fullpage | forecolor backcolor ',
        plugins: [
            'advlist autolink link image  lists charmap  preview hr anchor pagebreak spellchecker',
            'searchreplace wordcount visualblocks visualchars code fullscreen insertdatetime media nonbreaking',
            'save table contextmenu directionality template paste textcolor'
        ]
    });


    // init browser notifications
    if(("Notification" in window)) {
        if(Notification.permission !== "granted") {
            Notification.requestPermission();
        }
    }

    // run notification highlighter
    notification_highlighter();


    // run data heartbeat
    data_heartbeat();

    
    // run autocomplete
    /* focus the input */
    $('body').on('click', '.js_autocomplete', function() {
        var input = $(this).find('input').focus();
    });
    /* show and get the results if any */
    $('body').on('keyup', '.js_autocomplete input', function() {
        var _this = $(this);
        var query = _this.val();
        var parent = _this.parents('.js_autocomplete');
        /* change the width of typehead input */
        prev_length = _this.data('length') || 0;
        new_length = query.length;
        if(new_length > prev_length && _this.width() < 250) {
            _this.width(_this.width()+6);
        } else if(new_length < prev_length) {
            _this.width(_this.width()-6);
        }
        _this.data('length', query.length);
        /* check maximum number of tags */
        if(parent.find('ul.tags li').length > 9) {
            return;
        }
        /* check the query string */
        if(query != '') {
            /* check if results dropdown-menu not exist */
            if(_this.next('.dropdown-menu').length == 0) {
                /* construct a new one */
                var offset = _this.offset();
                var posX = offset.left - $(window).scrollLeft();
                if($(window).width() - posX < 180) {
                    _this.after('<div class="dropdown-menu auto-complete tl"></div>');
                } else {
                    _this.after('<div class="dropdown-menu auto-complete"></div>');
                }
            }
            /* get skipped ids */
            var skipped_ids = [];
            $.each(parent.find('ul.tags li'), function(i,tag) {
                skipped_ids.push($(tag).data('uid'));
            });
            $.post(api['users/autocomplete'], {'query': query, 'skipped_ids': JSON.stringify(skipped_ids)}, function(response) {
                if(response.callback) {
                    eval(response.callback);
                } else if(response.autocomplete) {
                    _this.next('.dropdown-menu').show().html(response.autocomplete);
                }
            }, 'json');
        } else {
            /* check if results dropdown-menu already exist */
            if(_this.next('.dropdown-menu').length > 0) {
                _this.next('.dropdown-menu').hide();
            }
        }
    });
    /* show previous results dropdown-menu when the input is clicked */
    $('body').on('click focus', '.js_autocomplete input', function() {
        /* check maximum number of tags */
        if($(this).parents('.js_autocomplete').find('ul.tags li').length > 9) {
            return;
        }
        /* only show again if the input & dropdown-menu are not empty */
        if($(this).val() != '' && $(this).next('.dropdown-menu').find('li').length > 0) {
            $(this).next('.dropdown-menu').show();
        }
    });
    /* hide the results dropdown-menu when clicked outside the input */
    $('body').on('click', function(e) {
        if(!$(e.target).is(".js_autocomplete")) {
            $('.js_autocomplete .dropdown-menu').hide();
        }
    });
    /* add a tag */
    $('body').on('click', '.js_tag-add', function() {
        var uid = $(this).data('uid');
        var name = $(this).data('name');
        var parent = $(this).parents('.js_autocomplete');
        var tag = '<li data-uid="'+uid+'">'+name+'<button type="button" class="close js_tag-remove" title="'+__["Remove"]+'"><span>&times;</span></button></li>'
        parent.find('.tags').append(tag);
        parent.find('input').val('').focus();
        /* check if there is chat-form next to js_autocomplete */
        if(parent.siblings('.chat-form').length > 0) {
            if(parent.find('ul.tags li').length == 0) {
                if(!parent.siblings('.chat-form').hasClass('x-visible')) {
                    parent.siblings('.chat-form').addClass('x-visible');
                }
            } else {
                parent.siblings('.chat-form').removeClass('x-visible');
            }
        }
    });
    /* remove a tag */
    $('body').on('click', '.js_tag-remove', function() {
        var tag = $(this).parents('li');
        var parent = $(this).parents('.js_autocomplete');
        tag.remove();
        /* check if there is chat-form next to js_autocomplete */
        if(parent.siblings('.chat-form').length > 0) {
            if(parent.find('ul.tags li').length == 0) {
                if(!parent.siblings('.chat-form').hasClass('x-visible')) {
                    parent.siblings('.chat-form').addClass('x-visible');
                }
            } else {
                parent.siblings('.chat-form').removeClass('x-visible');
            }
        }
        return false;
    });


    // run @mention
    $('body').on('keyup', '.js_mention', function() {
        var _this = $(this);
        //var raw_query = _this.val().match(/@(\w+)/ig);
        var raw_query = _this.val().match(/@([A-Za-z\u00AA\u00B5\u00BA\u00C0-\u00D6\u00D8-\u00F6\u00F8-\u02C1\u02C6-\u02D1\u02E0-\u02E4\u02EC\u02EE\u0370-\u0374\u0376\u0377\u037A-\u037D\u037F\u0386\u0388-\u038A\u038C\u038E-\u03A1\u03A3-\u03F5\u03F7-\u0481\u048A-\u052F\u0531-\u0556\u0559\u0561-\u0587\u05D0-\u05EA\u05F0-\u05F2\u0620-\u064A\u066E\u066F\u0671-\u06D3\u06D5\u06E5\u06E6\u06EE\u06EF\u06FA-\u06FC\u06FF\u0710\u0712-\u072F\u074D-\u07A5\u07B1\u07CA-\u07EA\u07F4\u07F5\u07FA\u0800-\u0815\u081A\u0824\u0828\u0840-\u0858\u08A0-\u08B4\u0904-\u0939\u093D\u0950\u0958-\u0961\u0971-\u0980\u0985-\u098C\u098F\u0990\u0993-\u09A8\u09AA-\u09B0\u09B2\u09B6-\u09B9\u09BD\u09CE\u09DC\u09DD\u09DF-\u09E1\u09F0\u09F1\u0A05-\u0A0A\u0A0F\u0A10\u0A13-\u0A28\u0A2A-\u0A30\u0A32\u0A33\u0A35\u0A36\u0A38\u0A39\u0A59-\u0A5C\u0A5E\u0A72-\u0A74\u0A85-\u0A8D\u0A8F-\u0A91\u0A93-\u0AA8\u0AAA-\u0AB0\u0AB2\u0AB3\u0AB5-\u0AB9\u0ABD\u0AD0\u0AE0\u0AE1\u0AF9\u0B05-\u0B0C\u0B0F\u0B10\u0B13-\u0B28\u0B2A-\u0B30\u0B32\u0B33\u0B35-\u0B39\u0B3D\u0B5C\u0B5D\u0B5F-\u0B61\u0B71\u0B83\u0B85-\u0B8A\u0B8E-\u0B90\u0B92-\u0B95\u0B99\u0B9A\u0B9C\u0B9E\u0B9F\u0BA3\u0BA4\u0BA8-\u0BAA\u0BAE-\u0BB9\u0BD0\u0C05-\u0C0C\u0C0E-\u0C10\u0C12-\u0C28\u0C2A-\u0C39\u0C3D\u0C58-\u0C5A\u0C60\u0C61\u0C85-\u0C8C\u0C8E-\u0C90\u0C92-\u0CA8\u0CAA-\u0CB3\u0CB5-\u0CB9\u0CBD\u0CDE\u0CE0\u0CE1\u0CF1\u0CF2\u0D05-\u0D0C\u0D0E-\u0D10\u0D12-\u0D3A\u0D3D\u0D4E\u0D5F-\u0D61\u0D7A-\u0D7F\u0D85-\u0D96\u0D9A-\u0DB1\u0DB3-\u0DBB\u0DBD\u0DC0-\u0DC6\u0E01-\u0E30\u0E32\u0E33\u0E40-\u0E46\u0E81\u0E82\u0E84\u0E87\u0E88\u0E8A\u0E8D\u0E94-\u0E97\u0E99-\u0E9F\u0EA1-\u0EA3\u0EA5\u0EA7\u0EAA\u0EAB\u0EAD-\u0EB0\u0EB2\u0EB3\u0EBD\u0EC0-\u0EC4\u0EC6\u0EDC-\u0EDF\u0F00\u0F40-\u0F47\u0F49-\u0F6C\u0F88-\u0F8C\u1000-\u102A\u103F\u1050-\u1055\u105A-\u105D\u1061\u1065\u1066\u106E-\u1070\u1075-\u1081\u108E\u10A0-\u10C5\u10C7\u10CD\u10D0-\u10FA\u10FC-\u1248\u124A-\u124D\u1250-\u1256\u1258\u125A-\u125D\u1260-\u1288\u128A-\u128D\u1290-\u12B0\u12B2-\u12B5\u12B8-\u12BE\u12C0\u12C2-\u12C5\u12C8-\u12D6\u12D8-\u1310\u1312-\u1315\u1318-\u135A\u1380-\u138F\u13A0-\u13F5\u13F8-\u13FD\u1401-\u166C\u166F-\u167F\u1681-\u169A\u16A0-\u16EA\u16F1-\u16F8\u1700-\u170C\u170E-\u1711\u1720-\u1731\u1740-\u1751\u1760-\u176C\u176E-\u1770\u1780-\u17B3\u17D7\u17DC\u1820-\u1877\u1880-\u18A8\u18AA\u18B0-\u18F5\u1900-\u191E\u1950-\u196D\u1970-\u1974\u1980-\u19AB\u19B0-\u19C9\u1A00-\u1A16\u1A20-\u1A54\u1AA7\u1B05-\u1B33\u1B45-\u1B4B\u1B83-\u1BA0\u1BAE\u1BAF\u1BBA-\u1BE5\u1C00-\u1C23\u1C4D-\u1C4F\u1C5A-\u1C7D\u1CE9-\u1CEC\u1CEE-\u1CF1\u1CF5\u1CF6\u1D00-\u1DBF\u1E00-\u1F15\u1F18-\u1F1D\u1F20-\u1F45\u1F48-\u1F4D\u1F50-\u1F57\u1F59\u1F5B\u1F5D\u1F5F-\u1F7D\u1F80-\u1FB4\u1FB6-\u1FBC\u1FBE\u1FC2-\u1FC4\u1FC6-\u1FCC\u1FD0-\u1FD3\u1FD6-\u1FDB\u1FE0-\u1FEC\u1FF2-\u1FF4\u1FF6-\u1FFC\u2071\u207F\u2090-\u209C\u2102\u2107\u210A-\u2113\u2115\u2119-\u211D\u2124\u2126\u2128\u212A-\u212D\u212F-\u2139\u213C-\u213F\u2145-\u2149\u214E\u2183\u2184\u2C00-\u2C2E\u2C30-\u2C5E\u2C60-\u2CE4\u2CEB-\u2CEE\u2CF2\u2CF3\u2D00-\u2D25\u2D27\u2D2D\u2D30-\u2D67\u2D6F\u2D80-\u2D96\u2DA0-\u2DA6\u2DA8-\u2DAE\u2DB0-\u2DB6\u2DB8-\u2DBE\u2DC0-\u2DC6\u2DC8-\u2DCE\u2DD0-\u2DD6\u2DD8-\u2DDE\u2E2F\u3005\u3006\u3031-\u3035\u303B\u303C\u3041-\u3096\u309D-\u309F\u30A1-\u30FA\u30FC-\u30FF\u3105-\u312D\u3131-\u318E\u31A0-\u31BA\u31F0-\u31FF\u3400-\u4DB5\u4E00-\u9FD5\uA000-\uA48C\uA4D0-\uA4FD\uA500-\uA60C\uA610-\uA61F\uA62A\uA62B\uA640-\uA66E\uA67F-\uA69D\uA6A0-\uA6E5\uA717-\uA71F\uA722-\uA788\uA78B-\uA7AD\uA7B0-\uA7B7\uA7F7-\uA801\uA803-\uA805\uA807-\uA80A\uA80C-\uA822\uA840-\uA873\uA882-\uA8B3\uA8F2-\uA8F7\uA8FB\uA8FD\uA90A-\uA925\uA930-\uA946\uA960-\uA97C\uA984-\uA9B2\uA9CF\uA9E0-\uA9E4\uA9E6-\uA9EF\uA9FA-\uA9FE\uAA00-\uAA28\uAA40-\uAA42\uAA44-\uAA4B\uAA60-\uAA76\uAA7A\uAA7E-\uAAAF\uAAB1\uAAB5\uAAB6\uAAB9-\uAABD\uAAC0\uAAC2\uAADB-\uAADD\uAAE0-\uAAEA\uAAF2-\uAAF4\uAB01-\uAB06\uAB09-\uAB0E\uAB11-\uAB16\uAB20-\uAB26\uAB28-\uAB2E\uAB30-\uAB5A\uAB5C-\uAB65\uAB70-\uABE2\uAC00-\uD7A3\uD7B0-\uD7C6\uD7CB-\uD7FB\uF900-\uFA6D\uFA70-\uFAD9\uFB00-\uFB06\uFB13-\uFB17\uFB1D\uFB1F-\uFB28\uFB2A-\uFB36\uFB38-\uFB3C\uFB3E\uFB40\uFB41\uFB43\uFB44\uFB46-\uFBB1\uFBD3-\uFD3D\uFD50-\uFD8F\uFD92-\uFDC7\uFDF0-\uFDFB\uFE70-\uFE74\uFE76-\uFEFC\uFF21-\uFF3A\uFF41-\uFF5A\uFF66-\uFFBE\uFFC2-\uFFC7\uFFCA-\uFFCF\uFFD2-\uFFD7\uFFDA-\uFFDC]+)/ig);
        if(raw_query !== null && raw_query.length > 0) {
            var query = raw_query[0].replace("@", "");
            /* check if results dropdown-menu already exist */
            if(_this.next('.dropdown-menu').length == 0) {
                /* construct a new one */
                var offset = _this.offset();
                var posX = offset.left - $(window).scrollLeft();
                if($(window).width() - posX < 180) {
                    _this.after('<div class="dropdown-menu auto-complete tl"><div class="loader loader_small ptb10"></div></div>');
                } else {
                    _this.after('<div class="dropdown-menu auto-complete"><div class="loader loader_small ptb10"></div></div>');
                }
            }
            $.post(api['users/mention'], {'query': query}, function(response) {
                if(response.callback) {
                    eval(response.callback);
                } else if(response.mention) {
                    _this.next('.dropdown-menu').show().html(response.mention);
                }
            }, 'json');
        } else {
            /* check if results dropdown-menu already exist */
            if(_this.next('.dropdown-menu').length > 0) {
                _this.next('.dropdown-menu').hide();
            }
        }
    });
    /* show previous results dropdown-menu when the input is clicked */
    $('body').on('click focus', '.js_mention', function() {
        var query = $(this).val().match(/@(\w+)/ig);
        if(query !== null && query.length > 0) {
            $(this).next('.dropdown-menu').show();
        }
    });
    /* hide the results dropdown-menu when clicked outside the input */
    $('body').on('click', function(e) {
        if(!$(e.target).is(".js_mention")) {
            $('.js_mention').next('.dropdown-menu').hide();
        }
    });
    /* add a mention */
    $('body').on('click', '.js_mention-add', function() {
        var textarea = $(this).parents('.dropdown-menu').prev('textarea.js_mention');
        var username = $(this).data('username');
        textarea.val(textarea.val().replace(/@([A-Za-z\u00AA\u00B5\u00BA\u00C0-\u00D6\u00D8-\u00F6\u00F8-\u02C1\u02C6-\u02D1\u02E0-\u02E4\u02EC\u02EE\u0370-\u0374\u0376\u0377\u037A-\u037D\u037F\u0386\u0388-\u038A\u038C\u038E-\u03A1\u03A3-\u03F5\u03F7-\u0481\u048A-\u052F\u0531-\u0556\u0559\u0561-\u0587\u05D0-\u05EA\u05F0-\u05F2\u0620-\u064A\u066E\u066F\u0671-\u06D3\u06D5\u06E5\u06E6\u06EE\u06EF\u06FA-\u06FC\u06FF\u0710\u0712-\u072F\u074D-\u07A5\u07B1\u07CA-\u07EA\u07F4\u07F5\u07FA\u0800-\u0815\u081A\u0824\u0828\u0840-\u0858\u08A0-\u08B4\u0904-\u0939\u093D\u0950\u0958-\u0961\u0971-\u0980\u0985-\u098C\u098F\u0990\u0993-\u09A8\u09AA-\u09B0\u09B2\u09B6-\u09B9\u09BD\u09CE\u09DC\u09DD\u09DF-\u09E1\u09F0\u09F1\u0A05-\u0A0A\u0A0F\u0A10\u0A13-\u0A28\u0A2A-\u0A30\u0A32\u0A33\u0A35\u0A36\u0A38\u0A39\u0A59-\u0A5C\u0A5E\u0A72-\u0A74\u0A85-\u0A8D\u0A8F-\u0A91\u0A93-\u0AA8\u0AAA-\u0AB0\u0AB2\u0AB3\u0AB5-\u0AB9\u0ABD\u0AD0\u0AE0\u0AE1\u0AF9\u0B05-\u0B0C\u0B0F\u0B10\u0B13-\u0B28\u0B2A-\u0B30\u0B32\u0B33\u0B35-\u0B39\u0B3D\u0B5C\u0B5D\u0B5F-\u0B61\u0B71\u0B83\u0B85-\u0B8A\u0B8E-\u0B90\u0B92-\u0B95\u0B99\u0B9A\u0B9C\u0B9E\u0B9F\u0BA3\u0BA4\u0BA8-\u0BAA\u0BAE-\u0BB9\u0BD0\u0C05-\u0C0C\u0C0E-\u0C10\u0C12-\u0C28\u0C2A-\u0C39\u0C3D\u0C58-\u0C5A\u0C60\u0C61\u0C85-\u0C8C\u0C8E-\u0C90\u0C92-\u0CA8\u0CAA-\u0CB3\u0CB5-\u0CB9\u0CBD\u0CDE\u0CE0\u0CE1\u0CF1\u0CF2\u0D05-\u0D0C\u0D0E-\u0D10\u0D12-\u0D3A\u0D3D\u0D4E\u0D5F-\u0D61\u0D7A-\u0D7F\u0D85-\u0D96\u0D9A-\u0DB1\u0DB3-\u0DBB\u0DBD\u0DC0-\u0DC6\u0E01-\u0E30\u0E32\u0E33\u0E40-\u0E46\u0E81\u0E82\u0E84\u0E87\u0E88\u0E8A\u0E8D\u0E94-\u0E97\u0E99-\u0E9F\u0EA1-\u0EA3\u0EA5\u0EA7\u0EAA\u0EAB\u0EAD-\u0EB0\u0EB2\u0EB3\u0EBD\u0EC0-\u0EC4\u0EC6\u0EDC-\u0EDF\u0F00\u0F40-\u0F47\u0F49-\u0F6C\u0F88-\u0F8C\u1000-\u102A\u103F\u1050-\u1055\u105A-\u105D\u1061\u1065\u1066\u106E-\u1070\u1075-\u1081\u108E\u10A0-\u10C5\u10C7\u10CD\u10D0-\u10FA\u10FC-\u1248\u124A-\u124D\u1250-\u1256\u1258\u125A-\u125D\u1260-\u1288\u128A-\u128D\u1290-\u12B0\u12B2-\u12B5\u12B8-\u12BE\u12C0\u12C2-\u12C5\u12C8-\u12D6\u12D8-\u1310\u1312-\u1315\u1318-\u135A\u1380-\u138F\u13A0-\u13F5\u13F8-\u13FD\u1401-\u166C\u166F-\u167F\u1681-\u169A\u16A0-\u16EA\u16F1-\u16F8\u1700-\u170C\u170E-\u1711\u1720-\u1731\u1740-\u1751\u1760-\u176C\u176E-\u1770\u1780-\u17B3\u17D7\u17DC\u1820-\u1877\u1880-\u18A8\u18AA\u18B0-\u18F5\u1900-\u191E\u1950-\u196D\u1970-\u1974\u1980-\u19AB\u19B0-\u19C9\u1A00-\u1A16\u1A20-\u1A54\u1AA7\u1B05-\u1B33\u1B45-\u1B4B\u1B83-\u1BA0\u1BAE\u1BAF\u1BBA-\u1BE5\u1C00-\u1C23\u1C4D-\u1C4F\u1C5A-\u1C7D\u1CE9-\u1CEC\u1CEE-\u1CF1\u1CF5\u1CF6\u1D00-\u1DBF\u1E00-\u1F15\u1F18-\u1F1D\u1F20-\u1F45\u1F48-\u1F4D\u1F50-\u1F57\u1F59\u1F5B\u1F5D\u1F5F-\u1F7D\u1F80-\u1FB4\u1FB6-\u1FBC\u1FBE\u1FC2-\u1FC4\u1FC6-\u1FCC\u1FD0-\u1FD3\u1FD6-\u1FDB\u1FE0-\u1FEC\u1FF2-\u1FF4\u1FF6-\u1FFC\u2071\u207F\u2090-\u209C\u2102\u2107\u210A-\u2113\u2115\u2119-\u211D\u2124\u2126\u2128\u212A-\u212D\u212F-\u2139\u213C-\u213F\u2145-\u2149\u214E\u2183\u2184\u2C00-\u2C2E\u2C30-\u2C5E\u2C60-\u2CE4\u2CEB-\u2CEE\u2CF2\u2CF3\u2D00-\u2D25\u2D27\u2D2D\u2D30-\u2D67\u2D6F\u2D80-\u2D96\u2DA0-\u2DA6\u2DA8-\u2DAE\u2DB0-\u2DB6\u2DB8-\u2DBE\u2DC0-\u2DC6\u2DC8-\u2DCE\u2DD0-\u2DD6\u2DD8-\u2DDE\u2E2F\u3005\u3006\u3031-\u3035\u303B\u303C\u3041-\u3096\u309D-\u309F\u30A1-\u30FA\u30FC-\u30FF\u3105-\u312D\u3131-\u318E\u31A0-\u31BA\u31F0-\u31FF\u3400-\u4DB5\u4E00-\u9FD5\uA000-\uA48C\uA4D0-\uA4FD\uA500-\uA60C\uA610-\uA61F\uA62A\uA62B\uA640-\uA66E\uA67F-\uA69D\uA6A0-\uA6E5\uA717-\uA71F\uA722-\uA788\uA78B-\uA7AD\uA7B0-\uA7B7\uA7F7-\uA801\uA803-\uA805\uA807-\uA80A\uA80C-\uA822\uA840-\uA873\uA882-\uA8B3\uA8F2-\uA8F7\uA8FB\uA8FD\uA90A-\uA925\uA930-\uA946\uA960-\uA97C\uA984-\uA9B2\uA9CF\uA9E0-\uA9E4\uA9E6-\uA9EF\uA9FA-\uA9FE\uAA00-\uAA28\uAA40-\uAA42\uAA44-\uAA4B\uAA60-\uAA76\uAA7A\uAA7E-\uAAAF\uAAB1\uAAB5\uAAB6\uAAB9-\uAABD\uAAC0\uAAC2\uAADB-\uAADD\uAAE0-\uAAEA\uAAF2-\uAAF4\uAB01-\uAB06\uAB09-\uAB0E\uAB11-\uAB16\uAB20-\uAB26\uAB28-\uAB2E\uAB30-\uAB5A\uAB5C-\uAB65\uAB70-\uABE2\uAC00-\uD7A3\uD7B0-\uD7C6\uD7CB-\uD7FB\uF900-\uFA6D\uFA70-\uFAD9\uFB00-\uFB06\uFB13-\uFB17\uFB1D\uFB1F-\uFB28\uFB2A-\uFB36\uFB38-\uFB3C\uFB3E\uFB40\uFB41\uFB43\uFB44\uFB46-\uFBB1\uFBD3-\uFD3D\uFD50-\uFD8F\uFD92-\uFDC7\uFDF0-\uFDFB\uFE70-\uFE74\uFE76-\uFEFC\uFF21-\uFF3A\uFF41-\uFF5A\uFF66-\uFFBE\uFFC2-\uFFC7\uFFCA-\uFFCF\uFFD2-\uFFD7\uFFDA-\uFFDC]+)/ig,"")+'['+username+'] ').focus();
    });


    // run user-popover
    $('body').on('mouseenter', '.js_user-popover', function() {
        /* do not run if window size < 768px */
        if($(window).width() < 751) {
            return;
        }
        var _this = $(this);
        var uid = _this.data('uid');
        var type = _this.data('type') || 'user';
        var _timeout = setTimeout(function() {
            var offset = _this.offset();
            var posY = (offset.top - $(window).scrollTop()) + _this.height();
            var posX = offset.left - $(window).scrollLeft();
            if($('html').attr('dir') == "RTL") {
                var available =  posX + _this.width();
                if(available < 400) {
                    $('body').append('<div class="user-popover-wrapper tl" style="position: fixed; top: '+posY+'px; left:'+posX+'px"><div class="user-popover-content ptb10 plr10"><div class="loader loader_small"></div></div></div>');
                } else {
                    var right = $(window).width() - available;
                    $('body').append('<div class="user-popover-wrapper tr" style="position: fixed; top: '+posY+'px; right:'+right+'px"><div class="user-popover-content ptb10 plr10"><div class="loader loader_small"></div></div></div>');
                }
            } else {
                var available = $(window).width() - posX;
                if(available < 400) {
                    var right = available - _this.width();
                    $('body').append('<div class="user-popover-wrapper tl" style="position: fixed; top: '+posY+'px; right:'+right+'px"><div class="user-popover-content ptb10 plr10"><div class="loader loader_small"></div></div></div>');
                } else {
                    $('body').append('<div class="user-popover-wrapper tr" style="position: fixed; top: '+posY+'px; left:'+posX+'px"><div class="user-popover-content ptb10 plr10"><div class="loader loader_small"></div></div></div>');
                }
            }
            $.getJSON(api['users/popover'], {'type': type, 'uid': uid} , function(response) {
                if(response.callback) {
                    eval(response.callback);
                } else {
                    if(response.popover) {
                        $('.user-popover-wrapper').html(response.popover);
                    }
                }
            });
        }, 1000);
        _this.data('timeout', _timeout);
    });
    $('body').on('mouseleave', '.js_user-popover', function(e) {
        var to = e.toElement || e.relatedTarget;
        if(!$(to).is(".user-popover-wrapper")) {
            clearTimeout($(this).data('timeout'));
            $('.user-popover-wrapper').remove();
        }
    });
    $('body').on('mouseleave', '.user-popover-wrapper', function() {
        $('.user-popover-wrapper').remove();
    });


    // run x-uploader
    /* initialize the uplodaer */
    initialize_uploader();
    $(document).ajaxComplete(function() {
        initialize_uploader();
    });
    /* stop propagation */
    $('body').on('click', '.x-uploader', function (e) {
        /* get type */
        var type = $(this).find('.js_x-uploader').data('type') || "photos";
        if(type == "photos") {
            e.stopPropagation();
        }
    });
    /* initialize uploading */
    $('body').on('change', '.x-uploader input[type="file"]', function() {
        $(this).parent('.x-uploader').submit();
    });
    /* uploading */
    $('body').on('submit', '.x-uploader', function(e) {
        e.preventDefault;
        /* initialize AJAX options */
        var options = {
            dataType: "json",
            uploadProgress: _handle_progress,
            success: _handle_success,
            error: _handle_error,
            resetForm: true
        };
        options['data'] = {};
        /* get uploader input */
        var uploader = $(this).find('input[type="file"]');
        /* get type */
        var type = $(this).find('.js_x-uploader').data('type') || "photos";
        options['data']['type'] = type;
        /* get handle */
        var handle = $(this).find('.js_x-uploader').data('handle');
        if(handle === undefined) {
            return false;
        }
        options['data']['handle'] = handle;
        /* get multiple */
        var multiple = ($(this).find('.js_x-uploader').data('multiple') !== undefined)? true : false;
        options['data']['multiple'] = multiple;
        /* get id */
        var id = $(this).find('.js_x-uploader').data('id');
        if(id !== undefined) {
            options['data']['id'] = id;
        }
        /* check type */
        if(type == "photos") {
            /* check handle */
            if(handle == "cover-user" || handle == "cover-page" || handle == "cover-group" || handle == "cover-event") {
                var loader = $('.profile-cover-change-loader');
                loader.show();

            } else if(handle == "picture-user" || handle == "picture-page" || handle == "picture-group") {
                var loader = $('.profile-avatar-change-loader');
                loader.show();

            } else if(handle == "publisher" || handle == "publisher-mini") {
                var publisher = (handle == "publisher")? $('.publisher') : $('.publisher.mini');
                var files_num = uploader.get(0).files.length;
                /* check if there is current (scrabing|video|audio|file) process */
                if(publisher.data('scrabing') || publisher.data('video') || publisher.data('audio') || publisher.data('file')) {
                    return false;
                }
                /* check if there is already uploading process */
                if(!publisher.data('photos')) {
                    publisher.data('photos', {});
                }
                var attachments = publisher.find('.publisher-attachments');
                var loader = $('<ul></ul>').appendTo(attachments);
                attachments.show();
                for (var i = 0; i < files_num; ++i) {
                    $('<li class="loading"><div class="loader loader_small"></div></li>').appendTo(loader).show();
                }

            } else if(handle == "comment") {
                var comment = $(this).parents('.comment');
                /* check if there is already uploading process */
                if(comment.data('photos')) {
                    return false;
                }
                var attachments = comment.find('.comment-attachments');
                var loader = attachments.find('li.loading');
                attachments.show();
                loader.show();

            } else if(handle == "chat") {
                var chat_widget = $(this).parents('.chat-widget, .panel-messages');
                /* check if there is already uploading process */
                if(chat_widget.data('photo')) {
                    return false;
                }
                var attachments = chat_widget.find('.chat-attachments');
                var loader = attachments.find('li.loading');
                attachments.show();
                loader.show();

            } else if(handle == "x-image") {
                var parent = $(this).parents('.x-image');
                var loader = parent.find('.loader');
                loader.show();
            }
        } else if (type == "video" || type == "audio" || type == "file") {
            /* check handle */
            if(handle == "publisher") {
                /* show upload loader */
                var publisher = $('.publisher');
                /* check if there is current (uploading|scrabing|video|audio) process */
                if(publisher.data('photos') || publisher.data('scrabing') || publisher.data('video')  || publisher.data('audio') || publisher.data('file')) {
                    return false;
                }
                publisher.data(type, {});
                var attachments = $('.publisher-attachments');
                var loader = $('<ul></ul>').appendTo(attachments);
                attachments.show();
                $('<li class="loading"><div class="loader loader_small"></div></li>').appendTo(loader).show();
            }
        }
            
        /* handle progress */
        function _handle_progress(e) {
            /* disable uploader input during uploading */
            uploader.prop('disabled', true);
        }
        /* handle success */
        function _handle_success(response) {
            /* enable uploader input */
            uploader.prop('disabled', false);
            /* hide upload loader */
            if(loader) loader.hide();
            /* handle the response */
            if(response.callback) {
                if(handle == "publisher" || handle == "publisher-mini") {
                    /* hide the attachment from publisher */
                    if( (type == "photos" && jQuery.isEmptyObject(publisher.data('photos'))) || type != "photos" ) {
                        attachments.hide();
                        /* remove the type object from publisher data */
                        publisher.removeData(type);
                    }
                    /* remove upload loader */
                    if(loader) loader.remove();
                }
                eval(response.callback);
            } else {
                /* check type */
                if(type == "photos") {
                    /* check the handle */
                    if(handle == "cover-user" || handle == "cover-page" || handle == "cover-group" || handle == "cover-event") {
                        /* update (user|page|group) cover */
                        var image_path = uploads_path+'/'+response.file;
                        $('.profile-cover-wrapper').css("background-image", 'url('+image_path+')').removeClass('no-cover');
                        /* show delete btn  */
                        $('.profile-cover-wrapper').find('.profile-cover-delete').show();
                        /* remove lightbox */
                        $('.profile-cover-wrapper').removeClass('js_lightbox').removeAttr('data-id').removeAttr('data-image').removeAttr('data-context');

                    } else if(handle == "picture-user" || handle == "picture-page" || handle == "picture-group") {
                        /* update (user|page|group) picture */
                        var image_path = uploads_path+'/'+response.file;
                        $('.profile-avatar-wrapper img').attr("src", image_path);

                    } else if(handle == "publisher" || handle == "publisher-mini") {
                        /* remove upload loader */
                        if(loader) loader.remove();
                        /* add the attachment to publisher data */
                        var files = publisher.data('photos');
                        for(var i in response.files) {
                            files[response.files[i]] = response.files[i];
                            /* add publisher-attachments */
                            var image_path = uploads_path+'/'+response.files[i];
                            attachments.find('ul').append(render_template("#publisher-attachments-item", {'src':response.files[i], 'image_path':image_path}));
                        }
                        publisher.data('photos', files);

                    } else if(handle == "comment") {
                        /* add the attachment to comment data */
                        comment.data('photos', response.file);
                        /* hide comment x-form-tools */
                        comment.find('.x-form-tools-attach').hide();
                        /* add comment-attachments */
                        var image_path = uploads_path+'/'+response.file;
                        attachments.find('ul').append(render_template("#comment-attachments-item", {'src':response.file, 'image_path':image_path}));

                    } else if(handle == "chat") {
                        /* add the attachment to chat widget data */
                        chat_widget.data('photo', response.file);
                        /* hide chat widget x-form-tools */
                        chat_widget.find('.x-form-tools-attach').hide();
                        /* add chat-attachments */
                        var image_path = uploads_path+'/'+response.file;
                        attachments.find('ul').append(render_template("#chat-attachments-item", {'src':response.file, 'image_path':image_path}));

                    } else if(handle == "x-image") {
                        /* update x-image picture */
                        var image_path = uploads_path+'/'+response.file;
                        parent.css("background-image", 'url('+image_path+')');
                        /* add the image to input */
                        parent.find('.js_x-image-input').val(response.file);
                        /* show the remover */
                        parent.find('button').show();
                    }
                } else if (type == "video" || type == "audio" || type == "file") {
                    /* hide the attachment from publisher data */
                    attachments.hide();
                    /* remove upload loader */
                    if(loader) loader.remove();
                    /* show publisher meta */
                    $('.publisher-meta[data-meta="'+type+'"]').show();
                    /* add the attachment to publisher data */
                    var object = publisher.data(type);
                    object['source'] = response.file;
                    /* add publisher-attachments */
                    publisher.data(type, object);
                }   
            }
        }
        /* handle error */
        function _handle_error() {
            /* enable uploader input */
            uploader.prop('disabled', false);
            /* hide upload loader */
            if(loader) loader.hide();
            /* check the handle */
            if(handle == "publisher") {
                /* hide the attachment from publisher */
                if( (type == "photos" && jQuery.isEmptyObject(publisher.data('photos'))) || type != "photos" ) {
                    attachments.hide();
                }
                /* remove upload loader */
                if(loader) loader.remove();
            }
            modal('#modal-message', {title: __['Error'], message: __['There is something that went wrong!']});
        }
        /* submit the form */
        $(this).ajaxSubmit(options);
        return false;
    });
    /* handle profile (cover|picture) remover */
    $('body').on('click', '.js_delete-cover, .js_delete-picture', function (e) {
        e.stopPropagation();
        var id = $(this).data('id');
        var handle = $(this).data('handle');
        var remove = ($(this).hasClass('js_delete-cover'))? 'cover' : 'picture';
        if(remove == 'cover') {
            var wrapper = $('.profile-cover-wrapper');
            var _title = __['Delete Cover'];
            var _message = __['Are you sure you want to remove your cover photo?'];
        } else {
            var wrapper = $('.profile-avatar-wrapper');
            var _title = __['Delete Picture'];
            var _message = __['Are you sure you want to remove your profile picture?'];
        }
        confirm(_title, _message, function() {
            $.post(api['users/image'], {'handle': handle, 'id': id}, function(response) {
                /* check the response */
                if(response.callback) {
                    eval(response.callback);
                } else {
                    if(remove == 'cover') {
                        /* hide delete btn  */
                        wrapper.find('.profile-cover-delete').hide();
                        /* remove lightbox */
                        wrapper.removeClass('js_lightbox').removeAttr('data-id').removeAttr('data-image').removeAttr('data-context');
                        /* remove (user|page|group) cover */
                        wrapper.removeAttr('style');
                    } else {
                        /* hide delete btn  */
                        wrapper.find('.profile-avatar-delete').hide();
                        /* remove lightbox */
                        wrapper.find('img').removeClass('js_lightbox').removeAttr('data-id').removeAttr('data-image').removeAttr('data-context');
                        /* update (user|page|group) picture with default picture */
                        wrapper.find('img').attr("src", response.file);
                    }
                    $('#modal').modal('hide');
                }
            }, 'json')
            .fail(function() {
                modal('#modal-message', {title: __['Error'], message: __['There is something that went wrong!']});
            });
        });
    });
    /* handle x-image remover */
    $('body').on('click', '.js_x-image-remover', function() {
        var _this = $(this);
        var parent = _this.parents('.x-image');
        confirm(__['Delete'], __['Are you sure you want to delete this?'], function() {
            /* remove x-image image */
            parent.attr('style', '');
            /* add the image to input */
            parent.find('.js_x-image-input').val('');
            /* hide the remover */
            _this.hide();
            /* hide the confimation */
            $('#modal').modal('hide');
        });
    });


    // handle recent searches
    $('body').on('click', '.js_clear-searches', function () {
        confirm(__['Delete'], __['Are you sure you want to delete this?'], function() {
            $.get(api['users/settings'], {'edit': 'clear_search_log'}, function(response) {
                /* check the response */
                if(response.callback) {
                    eval(response.callback);
                } else {
                    window.location.reload();
                }
            }, 'json')
            .fail(function() {
                modal('#modal-message', {title: __['Error'], message: __['There is something that went wrong!']});
            });
        });
    });

    
    // handle data reseter
    $('body').on('click', '.js_live-requests, .js_live-messages, .js_live-notifications', function () {
        var _this = $(this);
        var counter = parseInt(_this.find("span.label").text()) || 0;
        if(!$(this).hasClass('open') && counter > 0) {
            /* reset the client counter & hide it */
            _this.find("span.label").addClass('hidden').text('0');
            /* get the reset target */
            if(_this.hasClass('js_live-requests')) {
                var data = {'reset': 'friend_requests'};
            } else if (_this.hasClass('js_live-messages')) {
                var data = {'reset': 'messages'};
            } else if(_this.hasClass('js_live-notifications')) {
                var data = {'reset': 'notifications'};
            }
            /* reset the server counter */
            $.post(api['data/reset'], data, function(response) {
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
        }
    });


    // handle notifications sound
    $('body').on('click', '.js_notifications-sound-toggle', function () {
        notifications_sound = $(this).is(":checked");
        $.get(api['users/settings'], {'edit': 'notifications_sound', 'notifications_sound': (notifications_sound)? 1 : 0}, function(response) {
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
    });


    // handle connection
    /* friend request */
    $('body').on('click', '.js_friend-accept, .js_friend-decline', function () {
        var id = $(this).data('uid');
        var parent = $(this).parent();
        var accept = parent.find('.js_friend-accept');
        var decline = parent.find('.js_friend-decline');
        var _do = ($(this).hasClass('js_friend-accept'))? 'friend-accept' : 'friend-decline';
        /* hide buttons & show loader */
        accept.hide();
        decline.hide();
        parent.append('<div class="loader loader_medium pr10"></div>');
        /* post the request */
        $.post(api['users/connect'], {'do': _do, 'id': id} , function(response) {
            if(response.callback) {
                parent.find('.loader').remove();
                accept.show();
                decline.show();
                eval(response.callback);
            } else {
                parent.find('.loader').remove();
                accept.remove();
                decline.remove();
                if(_do == 'friend-accept') {
                    parent.append('<div class="btn btn-default btn-delete js_friend-remove" data-uid="'+id+'"><i class="fa fa-check"></i> '+__["Friends"]+'</div>');
                }
            }
        }, "json")
        .fail(function() {
            parent.find('.loader').remove();
            accept.show();
            decline.show();
            modal('#modal-message', {title: __['Error'], message: __['There is something that went wrong!']});
        });
    });
    /* friend & unfriend */
    $('body').on('click', '.js_friend-add, .js_friend-cancel, .js_friend-remove', function () {
        var _this = $(this);
        var id = _this.data('uid');
        if(_this.hasClass('js_friend-add')) {
            var _do = 'friend-add';
        } else if (_this.hasClass('js_friend-cancel')) {
            var _do = 'friend-cancel';
        } else {
            var _do = 'friend-remove';
        }
        /* hide button & show loader || loading state */
        if(_this.parents('.data-content').length > 0) {
            _this.hide();
            _this.after('<div class="loader loader_medium pr10"></div>');
        } else {
            _this.button('loading');
        }
        /* post the request */
        $.post(api['users/connect'], {'do': _do, 'id': id} , function(response) {
            if(response.callback) {
                _this.next('.loader').remove();
                _this.show();
                _this.button('reset');
                eval(response.callback);
            } else {
                _this.next('.loader').remove();
                if(_do == 'friend-add') {
                    _this.after('<div class="btn btn-default js_friend-cancel" data-uid="'+id+'"><i class="fa fa-user-plus"></i> '+__["Friend Request Sent"]+'</div>');
                } else {
                    _this.after('<div class="btn btn-success js_friend-add" data-uid="'+id+'"><i class="fa fa-user-plus"></i> '+__["Add Friend"]+'</div>');
                }
                _this.remove();
            }
        }, "json")
        .fail(function() {
            _this.next('.loader').remove();
            _this.show();
            _this.button('reset');
            modal('#modal-message', {title: __['Error'], message: __['There is something that went wrong!']});
        });
    });
    /* follow & unfollow */
    $('body').on('click', '.js_follow, .js_unfollow', function () {
        var _this = $(this);
        var id = _this.data('uid');
        var _do = (_this.hasClass('js_follow'))? 'follow' : 'unfollow';
        /* show loading */
        _this.button('loading');
        /* post the request */
        $.post(api['users/connect'], {'do': _do, 'id': id} , function(response) {
            if(response.callback) {
                _this.button('reset');
                eval(response.callback);
            } else {
                if(_do == 'follow') {
                    _this.replaceWith('<button type="button" class="btn btn-default js_unfollow" data-uid="'+id+'"><i class="fa fa-check"></i> '+__["Following"]+'</button>');
                } else {
                    _this.replaceWith('<button type="button" class="btn btn-default js_follow" data-uid="'+id+'"><i class="fa fa-rss"></i> '+__["Follow"]+'</button>');
                }
            }
        }, "json")
        .fail(function() {
            _this.button('reset');
            modal('#modal-message', {title: __['Error'], message: __['There is something that went wrong!']});
        });
    });
    /* block user */
    $('body').on('click', '.js_block-user', function (e) {
        e.preventDefault();
        var id = $(this).data('uid');
        confirm(__['Block User'], __['Are you sure you want to block this user?'], function() {
            $.post(api['users/connect'], {'do': 'block', 'id': id} , function(response) {
                /* check the response */
                if(response.callback) {
                    eval(response.callback);
                } else {
                    window.location = site_path;
                }
            }, 'json')
            .fail(function() {
                modal('#modal-message', {title: __['Error'], message: __['There is something that went wrong!']});
            });
        });
    });
    /* unblock user */
    $('body').on('click', '.js_unblock-user', function (e) {
        e.preventDefault();
        var id = $(this).data('uid');
        confirm(__['Unblock User'], __['Are you sure you want to unblock this user?'], function() {
            $.post(api['users/connect'], {'do': 'unblock', 'id': id} , function(response) {
                /* check the response */
                if(response.callback) {
                    eval(response.callback);
                } else {
                    window.location.reload();
                }
            }, 'json')
            .fail(function() {
                modal('#modal-message', {title: __['Error'], message: __['There is something that went wrong!']});
            });
        });
    });
    /* delete user */
    $('body').on('click', '.js_delete-user', function (e) {
        e.preventDefault();
        var id = $(this).data('uid');
        confirm(__['Delete'], __['Are you sure you want to delete your account?'], function() {
            $.post(api['users/delete'], {'do': 'block', 'id': id} , function(response) {
                /* check the response */
                if(response.callback) {
                    eval(response.callback);
                } else {
                    window.location = site_path;
                }
            }, 'json')
            .fail(function() {
                modal('#modal-message', {title: __['Error'], message: __['There is something that went wrong!']});
            });
        });
    });
    /* verify & unverify */
    $('body').on('click', '.js_verify, .js_unverify', function () {
        var _this = $(this);
        var _id = _this.data('id');
        var _html = "";
        var data = {};
        if(_id !== undefined) {
            data['id'] = _id;
            var html = "data-id='"+_id+"'";
        }
        if(_this.hasClass('js_verify')) {
            var _do = 'request';
        } else {
            var _do = 'cancel';
        }
        data['do'] = _do;
        /* loading state */
        _this.button('loading');
        /* post the request */
        $.post(api['users/verify'], data , function(response) {
            if(response.callback) {
                _this.button('reset');
                eval(response.callback);
            } else {
                if(_do == 'request') {
                    _this.after('<div class="btn btn-warning btn-delete js_unverify" '+html+'><i class="fa fa-clock-o mr5"></i>'+__["Pending"]+'</div>');
                } else {
                    _this.after('<div class="btn btn-success js_verify" '+html+'><i class="fa fa-check-circle mr5"></i>'+__["Verification Requset"]+'</div>');
                }
                _this.remove();
            }
        }, "json")
        .fail(function() {
            _this.button('reset');
            modal('#modal-message', {title: __['Error'], message: __['There is something that went wrong!']});
        });
    });
    /* like & unlike page */
    $('body').on('click', '.js_like-page, .js_unlike-page', function () {
        var _this = $(this);
        var id = _this.data('id');
        var _do = (_this.hasClass('js_like-page'))? 'page-like' : 'page-unlike';
        /* show loading */
        _this.button('loading');
        /* post the request */
        $.post(api['users/connect'], {'do': _do, 'id': id} , function(response) {
            if(response.callback) {
                _this.button('reset');
                eval(response.callback);
            } else {
                if(_do == 'page-like') {
                    _this.replaceWith('<button type="button" class="btn btn-default js_unlike-page" data-id="'+id+'"><i class="fa fa-thumbs-o-up"></i> '+__['Unlike']+'</button>');
                } else {
                    _this.replaceWith('<button type="button" class="btn btn-primary js_like-page" data-id="'+id+'"><i class="fa fa-thumbs-o-up"></i> '+__['Like']+'</button>');
                }
            }
        }, "json")
        .fail(function() {
            _this.button('reset');
            modal('#modal-message', {title: __['Error'], message: __['There is something that went wrong!']});
        });
    });
    /* boost & unboost page */
    $('body').on('click', '.js_boost-page, .js_unboost-page', function () {
        var _this = $(this);
        var id = _this.data('id');
        var _do = (_this.hasClass('js_boost-page'))? 'page-boost' : 'page-unboost';
        /* show loading */
        _this.button('loading');
        /* post the request */
        $.post(api['users/connect'], {'do': _do, 'id': id} , function(response) {
            if(response.callback) {
                _this.button('reset');
                eval(response.callback);
            } else {
                if(_do == 'page-boost') {
                    _this.replaceWith('<button type="button" class="btn btn-default js_unboost-page" data-id="'+id+'"><i class="fa fa-bolt"></i> '+__['Unboost']+'</button>');
                } else {
                    _this.replaceWith('<button type="button" class="btn btn-danger js_boost-page" data-id="'+id+'"><i class="fa fa-bolt"></i> '+__['Boost']+'</button>');
                }
            }
        }, "json")
        .fail(function() {
            _this.button('reset');
            modal('#modal-message', {title: __['Error'], message: __['There is something that went wrong!']});
        });
    });
    /* group join & leave */
    $('body').on('click', '.js_join-group, .js_leave-group', function () {
        var _this = $(this);
        var id = _this.data('id');
        var privacy = _this.data('privacy');
        var _do = (_this.hasClass('js_join-group'))? 'group-join' : 'group-leave';
        /* show loading */
        _this.button('loading');
        /* post the request */
        $.post(api['users/connect'], {'do': _do, 'id': id} , function(response) {
            if(response.callback) {
                _this.button('reset');
                eval(response.callback);
            } else {
                if(_this.hasClass('js_join-group')) {
                    if(privacy == "public") {
                        _this.replaceWith('<button type="button" class="btn btn-default btn-delete js_leave-group" data-id="'+id+'" data-privacy="'+privacy+'"><i class="fa fa-check"></i> '+__['Joined']+'</button>');
                    } else {
                        _this.replaceWith('<button type="button" class="btn btn-default btn-delete js_leave-group" data-id="'+id+'" data-privacy="'+privacy+'"><i class="fa fa-clock-o"></i> '+__['Pending']+'</button>');
                    }
                } else {
                    _this.replaceWith('<button type="button" class="btn btn-success js_join-group" data-id="'+id+'" data-privacy="'+privacy+'"><i class="fa fa-user-plus"></i> '+__['Join']+'</button>');
                }
            }
        }, "json")
        .fail(function() {
            _this.button('reset');
            modal('#modal-message', {title: __['Error'], message: __['There is something that went wrong!']});
        });
    });
    /* group request (accept|decline) */
    $('body').on('click', '.js_group-request-accept, .js_group-request-decline', function () {
        var _this = $(this);
        var id = _this.data('id');
        var uid = _this.data('uid') || 0;
        var _do = (_this.hasClass('js_group-request-accept'))? 'group-accept' : 'group-decline';
        /* show loading */
        _this.button('loading');
        /* post the request */
        $.post(api['users/connect'], {'do': _do, 'id': id, 'uid': uid} , function(response) {
            if(response.callback) {
                _this.button('reset');
                eval(response.callback);
            } else {
                _this.closest('.data-container').slideUp();
            }
        }, "json")
        .fail(function() {
            _this.button('reset');
            modal('#modal-message', {title: __['Error'], message: __['There is something that went wrong!']});
        });
    });
    /* event go & ungo */
    $('body').on('click', '.js_go-event, .js_ungo-event', function () {
        var _this = $(this);
        var id = _this.data('id');
        var _do = (_this.hasClass('js_go-event'))? 'event-go': 'event-ungo';
        /* show loading */
        _this.button('loading');
        /* post the request */
        $.post(api['users/connect'], {'do': _do, 'id': id} , function(response) {
            if(response.callback) {
                _this.button('reset');
                eval(response.callback);
            } else {
                if(_do == 'event-go') {
                    _this.replaceWith('<button type="button" class="btn btn-default js_ungo-event" data-id="'+id+'"><i class="fa fa-check"></i> '+__['Going']+'</button>');
                } else {
                    _this.replaceWith('<button type="button" class="btn btn-success js_go-event" data-id="'+id+'"><i class="fa fa-calendar-check-o"></i> '+__['Going']+'</button>');
                }
            }
        }, "json")
        .fail(function() {
            _this.button('reset');
            modal('#modal-message', {title: __['Error'], message: __['There is something that went wrong!']});
        });
    });
    /* event interest & uninterest */
    $('body').on('click', '.js_interest-event, .js_uninterest-event', function () {
        var _this = $(this);
        var id = _this.data('id');
        var _do = (_this.hasClass('js_interest-event'))? 'event-interest': 'event-uninterest';
        /* show loading */
        _this.button('loading');
        /* post the request */
        $.post(api['users/connect'], {'do': _do, 'id': id} , function(response) {
            if(response.callback) {
                _this.button('reset');
                eval(response.callback);
            } else {
                if(_do == 'event-interest') {
                    _this.replaceWith('<button type="button" class="btn btn-default js_uninterest-event" data-id="'+id+'"><i class="fa fa-check"></i> '+__['Interested']+'</button>');
                } else {
                    _this.replaceWith('<button type="button" class="btn btn-primary js_interest-event" data-id="'+id+'"><i class="fa fa-star"></i> '+__['Interested']+'</button>');
                }
            }
        }, "json")
        .fail(function() {
            _this.button('reset');
            modal('#modal-message', {title: __['Error'], message: __['There is something that went wrong!']});
        });
    });
    /* invite (page|group|event) */
    $('body').on('click', '.js_page-invite, .js_group-invite, .js_event-invite', function () {
        var _this = $(this);
        var id = _this.data('id');
        var uid = _this.data('uid') || 0;
        var _do = 'event-invite';
        if(_this.hasClass('js_page-invite')) {
            var _do = 'page-invite';
        } else if (_this.hasClass('js_group-invite')) {
            var _do = 'group-invite';
        } else {
            var _do = 'event-invite';
        }
        /* show loading */
        _this.button('loading');
        /* post the request */
        $.post(api['users/connect'], {'do': _do, 'id': id, 'uid': uid} , function(response) {
            if(response.callback) {
                _this.button('reset');
                eval(response.callback);
            } else {
                _this.remove();
            }
        }, "json")
        .fail(function() {
            _this.button('reset');
            modal('#modal-message', {title: __['Error'], message: __['There is something that went wrong!']});
        });
    });
    /* delete (page|group|event) */
    $('body').on('click', '.js_delete-page, .js_delete-group, .js_delete-event', function (e) {
        e.preventDefault();
        var id = $(this).data('id');
        if($(this).hasClass('js_delete-page')) {
            var handle = 'page';
        } else if($(this).hasClass('js_delete-group')) {
            var handle = 'group';
        } else if($(this).hasClass('js_delete-event')) {
            var handle = 'event';
        }
        confirm(__['Delete'], __['Are you sure you want to delete this?'], function() {
            $.post(api['pages_groups_events/delete'], {'handle': handle, 'id': id} , function(response) {
                /* check the response */
                if(response.callback) {
                    eval(response.callback);
                } else {
                    window.location = site_path;
                }
            }, 'json')
            .fail(function() {
                modal('#modal-message', {title: __['Error'], message: __['There is something that went wrong!']});
            });
        });
    });


    // handle reports
    $('body').on('click', '.js_report', function (e) {
        e.preventDefault;
        var id = $(this).data('id');
        var handle = $(this).data('handle');
        confirm(__['Report'], __['Are you sure you want to report this?'], function() {
            $.post(api['data/report'], {'handle': handle, 'id': id}, function(response) {
                /* check the response */
                if(response.callback) {
                    eval(response.callback);
                }
            }, 'json')
            .fail(function() {
                modal('#modal-message', {title: __['Error'], message: __['There is something that went wrong!']});
            });
        });
        return false;
    });
    

    // handle session
    $('body').on('click', '.js_session-deleter', function () {
        var id = $(this).data('id');
        confirm(__['Delete'], __['Are you sure you want to delete this?'], function() {
            $.post(api['users/session'], {'id': id}, function(response) {
                /* check the response */
                if(response.callback) {
                    eval(response.callback);
                } else {
                    window.location.reload();
                }
            }, 'json')
            .fail(function() {
                modal('#modal-message', {title: __['Error'], message: __['There is something that went wrong!']});
            });
        });
    });
    
});