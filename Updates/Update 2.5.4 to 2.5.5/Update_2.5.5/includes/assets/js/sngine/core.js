/**
 * core js
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich
 */

// initialize API URLs
var api = [];
/* core */
api['core/translator']  = ajax_path+"core/translator.php";
/* data */
api['data/load']  = ajax_path+"data/load.php";
api['data/search']  = ajax_path+"data/search.php";
/* payments */
api['payments/paypal']  = ajax_path+"payments/paypal.php";
api['payments/stripe']  = ajax_path+"payments/stripe.php";
/* ads */
api['ads/click']  = ajax_path+"ads/click.php";


// is_empty
function is_empty(value) {
    if (value.match(/\S/) == null) {
        return true;
    } else  {
        return false;
    }
}


// get_parameter_by_name
function get_parameter_by_name(name) {
    var url = window.location.href;
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
        results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, " "));
}


// initialize the plugins
function initialize() {
    // run bootstrap tooltip
    $('body').tooltip({
        selector: '[data-toggle="tooltip"], [data-tooltip=tooltip]'
    });
    // run autosize (expand textarea) plugin
    autosize($('.js_autosize'));
    // run moment plugin
    $(".js_moment").each(function(){
        var _this = $(this);
        var time_utc = _this.data('time');
        var locale = $('html').attr('lang') || 'en-us';
        var offset = moment().utcOffset();
        var time = moment(time_utc).add({minutes:offset}).locale(locale);
        _this.text(time.fromNow()).attr('title', time.format("dddd, MMMM D, YYYY h:m a"));
    });
    // run slimScroll plugin
    $('.js_scroller').each(function(){
        var _this = $(this);
        /* return if the plugin already running  */
        if(_this.parent('.slimScrollDiv').length > 0) {
            return;
        }
        /* run if not */
        _this.slimScroll({
            height: _this.attr('data-slimScroll-height') || '280px',
            start: _this.attr('data-slimScroll-start') || 'top',
            distance: '2px'
        })
    });
    // run readmore
    $('.js_readmore').each(function(){
        var _this = $(this);
        var height = _this.attr('data-height') || 110;
        /* return if the plugin already running  */
        if(_this.attr('data-readmore') !== undefined) {
            return;
        }
        /* run if not */
        _this.readmore({
            collapsedHeight: height,
            moreLink: '<a href="#">'+__["Read more"]+'</a>',
            lessLink: '<a href="#">'+__["Read less"]+'</a>'
        });
    });
    // run mediaelementplayer plugin
    $('video.js_mediaelementplayer, audio.js_mediaelementplayer').mediaelementplayer();
}


// modal
function modal() {
    if(arguments[0] == "#modal-login") {
        /* disable the backdrop (don't close modal when click outside) */
        if($('#modal').data('bs.modal')) {
            $('#modal').data('bs.modal').options = {backdrop: 'static', keyboard: false};
        } else {
            $('#modal').modal({backdrop: 'static', keyboard: false});
        }
    }
    /* check if the modal not visible, show it */
    if(!$('#modal').is(":visible")) $('#modal').modal('show');
    /* update the modal-content with the rendered template */
    $('.modal-content:last').html( render_template(arguments[0], arguments[1]) );
    /* initialize modal if the function defined (user logged in) */
    if(typeof initialize_modal === "function") {
        initialize_modal();
    }
}


// confirm
function confirm(title, message, callback) {
    modal('#modal-confirm', {'title': title, 'message': message});
    $("#modal-confirm-ok").click( function() {
        if(callback) callback();
    });
}


// render template
function render_template(selector, options) {
    var template = $(selector).html();
    Mustache.parse(template);
    var rendered_template = Mustache.render(template, options);
    return rendered_template;
}


// load more
function load_more(element) {
    if(element.hasClass('done') || element.hasClass('loading')) return;
    var _this = element;
    var loading = _this.find('.loader');
    var text = _this.find('span');
    var remove = _this.data('remove') || false;
    var stream = _this.parent().find('ul:first');
    /* prepare data object */
    var data = {};
    data['get'] = _this.data('get');
    if(_this.data('filter') !== undefined) {
        data['filter'] = _this.data('filter');
    }
    if(_this.data('type') !== undefined) {
        data['type'] = _this.data('type');
    }
    if(_this.data('uid') !== undefined) {
        data['uid'] = _this.data('uid');
    }
    if(_this.data('id') !== undefined) {
        data['id'] = _this.data('id');
    }
    data['offset'] = _this.data('offset') || 1; /* we start from iteration 1 because 0 already loaded */
    /* show loader & hide text */
    _this.addClass('loading');
    text.hide();
    loading.removeClass('x-hidden');
    /* get & load data */
    $.post(api['data/load'], data, function(response) {
        _this.removeClass('loading');
        text.show();
        loading.addClass('x-hidden');
        /* check the response */
        if(response.callback) {
            eval(response.callback);
        } else {
            if(response.data) {
                data['offset']++;
                if(response.append) {
                    stream.append(response.data);
                } else {
                    stream.prepend(response.data);
                }
                setTimeout(photo_grid(), 200);
                /* color chat box */
                if(data['get'] == "messages") {
                    chat_widget = _this.parents('.chat-widget, .panel-messages');
                    color_chat_box(chat_widget, chat_widget.data('color'));
                }
            } else {
                if(remove) {
                    _this.remove();
                } else {
                    _this.addClass('done');
                    text.text(__['There is no more data to show']);
                }
            }
        }
        _this.data('offset', data['offset']);
    }, 'json')
    .fail(function() {
        _this.removeClass('loading');
        text.show();
        loading.addClass('x-hidden');
        modal('#modal-message', {title: __['Error'], message: __['There is something that went wrong!']});
    });
}


// photo grid
function photo_grid() {
    /* main photo */
    $('.pg_2o3_in').each(function() {
        if($(this).parents('.pg_3x').length > 0) {
            var width = height = $(this).parents('.pg_3x').width() * 0.667;
        }
        if($(this).parents('.pg_4x').length > 0) {
            var width = height = $(this).parents('.pg_4x').width() * 0.749;
        }
        $(this).width(width);
        $(this).height(height);
    });
    /* side photos */
    $('.pg_1o3_in').each(function() {
        if($(this).parents('.pg_3x').length > 0) {
            var width = $(this).parents('.pg_3x').width() * 0.332;
            var height = ($(this).parent('.pg_1o3').prev().height() - 1) / 2;
        }
        if($(this).parents('.pg_4x').length > 0) {
            var width = $(this).parents('.pg_4x').width() * 0.25;
            var height = ($(this).parent('.pg_1o3').prev().height() - 2) / 3;
        }
        $(this).width(width);
        $(this).height(height);
    });
}


$(function() {

    // init plugins
    initialize();
    $(document).ajaxComplete(function() {
        initialize();
    });


    // init hash
    var _t = $('body').attr('data-hash-tok');
    var _p = $('body').attr('data-hash-pos');
    switch (_p) {
        case '1':
            var _l = 'Z';
            break;
        case '2':
            var _l = 'm';
            break;
        case '3':
            var _l = 'B';
            break;
        case '4':
            var _l = 'l';
            break;
        case '5':
            var _l = 'K';
            break;
    }
    if(_p != 6 && _t[_t[0]] != _l) {
        document.write("Your session hash has been broken, Please contact Delus's support!");
    }


    // init fastlink plugin
    FastClick.attach(document.body);


    // init offcanvas-sidebar
    $('[data-toggle=offcanvas]').click(function() {
        $('.offcanvas').toggleClass('active');
    });


    // run photo grid
    photo_grid();
    $(window).on("resize", function () {
        setTimeout(photo_grid(), 200);
    });


    // run bootstrap modal
    $('body').on('click', '[data-toggle="modal"]', function(e) {
        e.preventDefault();
        var url = $(this).data('url');
        var options = $(this).data('options');
        if (url.indexOf('#') == 0) {
            /* open already loaded modal with #id */
            modal(url, options);
        } else {
            /* get & load modal from url */
            $.getJSON(ajax_path+url, function(response) {
                /* check the response */
                if(!response) return;
                /* check if there is a callback */
                if(response.callback) {
                    eval(response.callback);
                }
            })
            .fail(function() {
                modal('#modal-message', {title: __['Error'], message: __['There is something that went wrong!']});
            });
        }
    });


    // bootsrap dropdown keep open (and for slimScrollBar)
    $('body').on('click', '.js_dropdown-keepopen, .slimScrollBar', function (e) {
        e.stopPropagation();
    });


    // run bootstrap btn-group
    $('body').on('click', '.btn-group a', function (e) {
        e.preventDefault();
        var parent = $(this).parents('.btn-group');
        /* change the value */
        parent.find('input[type="hidden"]').val($(this).data('value'));
        /* copy text to btn-group-text */
        parent.find('.btn-group-text').text($(this).text());
        /* copy icon to btn-group-icon */
        parent.find('.btn-group-icon').attr("class", $(this).find('i.fa').attr("class")).addClass('btn-group-icon');
        /* copy title to tooltip */
        parent.attr('data-original-title', $(this).data('title'));
        parent.attr('data-value', $(this).data('value'));
        parent.tooltip();
    });


    // run toggle-panel
    $('.js_toggle-panel').click(function(event){
        event.preventDefault;
        var parent = $(this).parents('.panel-body');
        parent.hide();
        parent.siblings().fadeIn();
        return false;
    });
    

    // run ajax-forms
    $('body').on('submit', '.js_ajax-forms', function(e) {
        e.preventDefault();
        var url =  $(this).data('url');
        var submit =  $(this).find('button[type="submit"]');
        var error =  $(this).find('.alert.alert-danger');
        var success =  $(this).find('.alert.alert-success');
        /* show any collapsed section if any */
        if( $(this).find('.js_hidden-section').length > 0 && ! $(this).find('.js_hidden-section').is(':visible')) {
             $(this).find('.js_hidden-section').slideDown();
            return false;
        }
        /* show loading */
        submit.data('text', submit.html());
        submit.prop('disabled', true);
        submit.html(__['Loading']);
        /* get ajax response */
        $.post(ajax_path+url, $(this).serialize(), function(response) {
            /* hide loading */
            submit.prop('disabled', false);
            submit.html(submit.data('text'));
            /* handle response */
            if(response.error) {
                if(success.is(":visible")) success.hide(); // hide previous alert
                error.html(response.message).slideDown();
            } else if(response.success) {
                if(error.is(":visible")) error.hide(); // hide previous alert
                success.html(response.message).slideDown();
            } else {
                eval(response.callback);
            }
        }, "json")
        .fail(function() {
            /* hide loading */
            submit.prop('disabled', false);
            submit.html(submit.data('text'));
            /* handle error */
            if(success.is(":visible")) success.hide(); // hide previous alert
            error.html(__['There is something that went wrong!']).slideDown();
        });
    });


    // run load-more
    /* load more data by click */
    $('body').on('click', '.js_see-more', function () {
        load_more($(this));
    });
    /* load more data by scroll */
    $('.js_see-more-infinite').bind('inview', function (event, visible) {
        if(visible == true) {
            load_more($(this));
        }
    });


    // run search
    /* show and get the search results */
    $('body').on('keyup', '#search-input', function() {
        var query = $(this).val();
        if(!is_empty(query)) {
            $('#search-history').hide();
            $('#search-results').show();
            var hashtags = query.match(/#(\w+)/ig);
            if(hashtags !== null && hashtags.length > 0) {
                var query = hashtags[0].replace("#", "");
                $('#search-results .dropdown-widget-header').hide();
                $('#search-results-all').hide();
                $('#search-results .dropdown-widget-body').html(render_template('#search-for', {'query': query, 'hashtag': true}));
            } else {
                $.post(api['data/search'], {'query': query}, function(response) {
                    if(response.callback) {
                        eval(response.callback);
                    } else if(response.results) {
                        $('#search-results .dropdown-widget-header').show();
                        $('#search-results-all').show();
                        $('#search-results .dropdown-widget-body').html(response.results);
                        $('#search-results-all').attr('href', site_path+'/search/'+query);
                    } else {
                        $('#search-results .dropdown-widget-header').hide();
                        $('#search-results-all').hide();
                        $('#search-results .dropdown-widget-body').html(render_template('#search-for', {'query': query}));
                    }
                }, 'json');
            }
        }
    });
    /* submit search form */
    $('body').on('keydown', '#search-input', function(event) {
        if(event.keyCode == 13) {
            event.preventDefault;
            var query = $(this).val();
            if(!is_empty(query)) {
                var hashtags = query.match(/#(\w+)/ig);
                if(hashtags !== null && hashtags.length > 0) {
                    var query = hashtags[0].replace("#", "");
                    window.location = site_path+'/search/hashtag/'+query
                } else {
                    window.location = site_path+'/search/'+query
                }
            }
            return false;
        }
    });
    /* show previous search (results|history) when the search-input is clicked */
    $('body').on('click', '#search-input', function() {
        if($(this).val() != '') {
            $('#search-results').show();
        } else {
            $('#search-history').show();
        }
    });
    /* hide the search (results|history) when clicked outside search-input */
    $('body').on('click', function(e) {
        if(!$(e.target).is("#search-input")) {
            $('#search-results, #search-history').hide();
        }
    });
    /* submit search form */
    $('body').on('submit', '.js_search-form', function(e) {
        e.preventDefault;
        var query = this.query.value;
        var handle = $(this).data('handle');
        if(!is_empty(query)) {
            if(handle !== undefined) {
                window.location = site_path+'/'+handle+'/search/'+query
            } else {
                var hashtags = query.match(/#(\w+)/ig);
                if(hashtags !== null && hashtags.length > 0) {
                    var query = hashtags[0].replace("#", "");
                    window.location = site_path+'/search/hashtag/'+query
                } else {
                    window.location = site_path+'/search/'+query
                }
            }
        }
        return false;
    });


    // run YouTube player
    $('body').on('click', '.youtube-player', function() {
        $(this).html('<iframe src="https://www.youtube.com/embed/'+$(this).data('id')+'?autoplay=1" frameborder="0" allowfullscreen="1"></iframe>');
    });


    // run payments
    $('body').on('click', '.js_payment-paypal', function () {
        var _this = $(this);
        var data = {};
        data['handle'] = _this.data('handle');
        if(data['handle'] == "packages") {
            data['package_id'] = _this.data('id');
        }
        if(data['handle'] == "wallet") {
            data['price'] = _this.data('price');
        }
        /* post the request */
        _this.button('loading');
        $.post(api['payments/paypal'], data , function(response) {
            _this.button('reset');
            /* check the response */
            if(!response) return;
            /* check if there is a callback */
            if(response.callback) {
                eval(response.callback);
            }
        }, "json")
        .fail(function() {
            _this.button('reset');
            modal('#modal-message', {title: __['Error'], message: __['There is something that went wrong!']});
        });
    });
    $('body').on('click', '.js_payment-stripe', function () {
        var _this = $(this);
        var method = _this.data('method');
        var data = {};
        data['handle'] = _this.data('handle');
        if(data['handle'] == "packages") {
            data['package_id'] = _this.data('id');
        }
        if(data['handle'] == "wallet") {
            data['price'] = _this.data('price');
        }
        _this.button('loading');
        var handler = StripeCheckout.configure({
            key: stripe_key,
            locale: 'english',
            image: _this.data('img') || '',
            token: function(token) {
                data['token'] = token.id;
                data['email'] = token.email;
                $.post(api['payments/stripe'], data , function(response) {
                    /* check the response */
                    if(!response) return;
                    /* check if there is a callback */
                    if(response.callback) {
                        eval(response.callback);
                    }
                }, "json")
                .fail(function() {
                    modal('#modal-message', {title: __['Error'], message: __['There is something that went wrong!']});
                });
            }
        });
        handler.open({
            name: site_title,
            description: _this.data('name') || '',
            amount: _this.data('price')*100,
            currency: currency,
            alipay: (method == "alipay")?true:false,
            opened: function () {
                _this.button('reset');
                $('#modal').modal('hide');
            }
        });
        $(window).on('popstate', function() {
           handler.close();
        });
    });


    // run ads campaigns
    $('body').on('click', '.js_ads-click-campaign', function () {
        var id = $(this).data('id');
        $.post(api['ads/click'], {'id': id} , function(response) {
            if(response.callback) {
                eval(response.callback);
            }
        }, "json")
        .fail(function() {
            modal('#modal-message', {title: __['Error'], message: __['There is something that went wrong!']});
        });
    });

});