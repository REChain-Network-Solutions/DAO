/**
 * post js
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich - Handles - @sorydima @sorydev @durovshater @DmitrySoro90935 @tanechfund - also check https://dmitry.rechain.network for more information!
 */

// initialize API URLs
/* live */
api['live/reaction'] = ajax_path + "live/reaction.php";
/* posts */
api['comments/filter'] = ajax_path + "posts/filter.php?handle=comments";
api['posts/filter'] = ajax_path + "posts/filter.php?handle=posts";
api['posts/post'] = ajax_path + "posts/post.php";
api['posts/scraper'] = ajax_path + "posts/scraper.php";
api['posts/comment'] = ajax_path + "posts/comment.php";
api['posts/reaction'] = ajax_path + "posts/reaction.php";
api['posts/edit'] = ajax_path + "posts/edit.php";
api['posts/product'] = ajax_path + "posts/product.php";
api['posts/story'] = ajax_path + "posts/story.php";
/* albums */
api['albums/action'] = ajax_path + "albums/action.php";
/* forums */
api['forums/delete'] = ajax_path + "forums/delete.php";


// initialize voice recording global vars
var voice_recording_encoding = voice_notes_encoding;
var voice_recording_limit = voice_notes_durtaion;
var voice_recording_process = false;
var voice_recording_timer;
var voice_recording_object;
var voice_recording_stream;


// initialize live post global vars
if (live_enabled) {
  var agora_client = AgoraRTC.createClient({ mode: 'live', codec: 'vp8' });
  if (system_debugging_mode == true) {
    AgoraRTC.setLogLevel(0);
  } else {
    AgoraRTC.setLogLevel(4);
  }
  var live_post_realtime_thread;
  var live_post_realtime_process = false;
  var live_post_streaming_process = false;
}


// publisher tab
function publisher_tab(publisher, tab) {
  /* toggle active class */
  publisher.find('.js_publisher-tab[data-tab="' + tab + '"]').toggleClass('active');
  /* toggle conflicted tabs */
  switch (tab) {
    case "scraper":
      /* toggle conflicted tabs */
      publisher.find('.js_publisher-tab[data-tab="offer"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="job"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="live"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="photos"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="album"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="colored"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="voice_notes"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="gif"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="product"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="funding"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="blog"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="poll"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="reel"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="video"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="audio"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="file"]').toggleClass('disabled');
      break;

    case "photos":
      /* toggle conflicted tabs */
      if (!publisher.find('.js_publisher-tab[data-tab="album"]').hasClass('active')) {
        publisher.find('.js_publisher-tab[data-tab="offer"]').toggleClass('disabled');
        publisher.find('.js_publisher-tab[data-tab="job"]').toggleClass('disabled');
        publisher.find('.js_publisher-tab[data-tab="live"]').toggleClass('disabled');
        publisher.find('.js_publisher-tab[data-tab="colored"]').toggleClass('disabled');
        publisher.find('.js_publisher-tab[data-tab="voice_notes"]').toggleClass('disabled');
        publisher.find('.js_publisher-tab[data-tab="gif"]').toggleClass('disabled');
        publisher.find('.js_publisher-tab[data-tab="product"]').toggleClass('disabled');
        publisher.find('.js_publisher-tab[data-tab="funding"]').toggleClass('disabled');
        publisher.find('.js_publisher-tab[data-tab="blog"]').toggleClass('disabled');
        publisher.find('.js_publisher-tab[data-tab="poll"]').toggleClass('disabled');
        publisher.find('.js_publisher-tab[data-tab="reel"]').toggleClass('disabled');
      }
      break;

    case "album":
      /* toggle meta */
      publisher.find('.publisher-meta[data-meta="album"]').slideToggle('fast').find('input').trigger('focus');
      /* toggle conflicted tabs */
      if (!publisher.find('.js_publisher-tab[data-tab="photos"]').hasClass('active')) {
        publisher.find('.js_publisher-tab[data-tab="offer"]').toggleClass('disabled');
        publisher.find('.js_publisher-tab[data-tab="job"]').toggleClass('disabled');
        publisher.find('.js_publisher-tab[data-tab="live"]').toggleClass('disabled');
        publisher.find('.js_publisher-tab[data-tab="colored"]').toggleClass('disabled');
        publisher.find('.js_publisher-tab[data-tab="voice_notes"]').toggleClass('disabled');
        publisher.find('.js_publisher-tab[data-tab="gif"]').toggleClass('disabled');
        publisher.find('.js_publisher-tab[data-tab="product"]').toggleClass('disabled');
        publisher.find('.js_publisher-tab[data-tab="funding"]').toggleClass('disabled');
        publisher.find('.js_publisher-tab[data-tab="blog"]').toggleClass('disabled');
        publisher.find('.js_publisher-tab[data-tab="poll"]').toggleClass('disabled');
        publisher.find('.js_publisher-tab[data-tab="reel"]').toggleClass('disabled');
      }
      publisher.find('.js_publisher-tab[data-tab="video"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="audio"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="file"]').toggleClass('disabled');
      break;

    case "album_disable":
      publisher.find('.js_publisher-tab[data-tab="album"]').addClass('disabled');
      break;

    case "location":
      /* toggle meta */
      publisher.find('.publisher-meta[data-meta="location"]').slideToggle('fast').find('input').trigger('focus');
      break;

    case "colored":
      /* toggle meta */
      publisher.find('.publisher-meta[data-meta="colored"]').slideToggle('fast').find('input').trigger('focus');
      /* toggle conflicted tabs */
      publisher.find('.js_publisher-tab[data-tab="offer"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="job"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="live"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="photos"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="album"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="voice_notes"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="gif"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="product"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="funding"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="blog"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="poll"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="reel"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="video"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="audio"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="file"]').toggleClass('disabled');
      break;

    case "voice_notes":
      /* toggle meta */
      publisher.find('.publisher-meta[data-meta="voice_notes"]').slideToggle('fast');
      /* toggle conflicted tabs */
      publisher.find('.js_publisher-tab[data-tab="offer"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="job"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="live"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="photos"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="album"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="colored"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="gif"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="product"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="funding"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="blog"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="poll"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="reel"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="video"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="audio"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="file"]').toggleClass('disabled');
      break;

    case "gif":
      /* toggle meta */
      publisher.find('.publisher-meta[data-meta="gif"]').slideToggle('fast').find('input').trigger('focus');
      /* toggle conflicted tabs */
      publisher.find('.js_publisher-tab[data-tab="offer"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="job"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="live"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="photos"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="album"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="colored"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="voice_notes"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="product"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="funding"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="blog"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="poll"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="reel"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="video"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="audio"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="file"]').toggleClass('disabled');
      break;

    case "poll":
      /* toggle meta */
      publisher.find('.publisher-meta[data-meta="poll"]').slideToggle('fast');
      /* toggle textarea placeholder */
      if (publisher.find('.js_publisher-tab[data-tab="poll"]').hasClass('active')) {
        publisher.find('textarea').attr('placeholder', __['Ask something'] + "...").trigger('focus');
      } else {
        publisher.find('textarea').attr('placeholder', publisher.find('textarea').data('init-placeholder')).trigger('focus');
      }
      /* toggle conflicted tabs */
      publisher.find('.js_publisher-tab[data-tab="offer"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="job"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="live"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="photos"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="album"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="colored"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="voice_notes"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="gif"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="product"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="funding"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="blog"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="reel"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="video"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="audio"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="file"]').toggleClass('disabled');
      break;

    case "reel":
      /* toggle conflicted tabs */
      publisher.find('.js_publisher-tab[data-tab="offer"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="job"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="live"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="album"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="colored"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="voice_notes"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="gif"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="product"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="funding"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="blog"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="poll"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="video"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="audio"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="file"]').toggleClass('disabled');
      break;

    case "video":
      /* toggle conflicted tabs */
      publisher.find('.js_publisher-tab[data-tab="offer"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="job"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="live"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="album"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="colored"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="voice_notes"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="gif"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="product"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="funding"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="blog"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="poll"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="reel"]').toggleClass('disabled');
      break;

    case "audio":
      /* toggle conflicted tabs */
      publisher.find('.js_publisher-tab[data-tab="offer"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="job"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="live"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="album"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="colored"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="voice_notes"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="gif"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="product"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="funding"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="blog"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="poll"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="reel"]').toggleClass('disabled');
      break;

    case "file":
      /* toggle conflicted tabs */
      publisher.find('.js_publisher-tab[data-tab="offer"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="job"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="live"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="album"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="colored"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="voice_notes"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="gif"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="product"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="funding"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="blog"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="poll"]').toggleClass('disabled');
      publisher.find('.js_publisher-tab[data-tab="reel"]').toggleClass('disabled');
      break;

    case "anonymous":
      /* check if there is active tab already */
      if (publisher.find('.js_publisher-tab.active').length == 0) {
        /* toggle conflicted tabs */
        publisher.find('.js_publisher-tab[data-tab="offer"]').toggleClass('disabled');
        publisher.find('.js_publisher-tab[data-tab="job"]').toggleClass('disabled');
        publisher.find('.js_publisher-tab[data-tab="live"]').toggleClass('disabled');
        publisher.find('.js_publisher-tab[data-tab="album"]').toggleClass('disabled');
        publisher.find('.js_publisher-tab[data-tab="product"]').toggleClass('disabled');
        publisher.find('.js_publisher-tab[data-tab="funding"]').toggleClass('disabled');
        publisher.find('.js_publisher-tab[data-tab="blog"]').toggleClass('disabled');
      }
      break;
  }
}


// update media views
function update_media_views(media_type, media_id) {
  switch (media_type) {
    case "reel":
      var _do = "update_reel_views";
      break;

    case "video":
      var _do = "update_video_views";
      break;

    case "audio":
      var _do = "update_audio_views";
      break;
  }
  setTimeout(function () {
    $.post(api['posts/reaction'], { 'do': _do, 'id': media_id }, function (response) {
      if (response.callback) {
        eval(response.callback);
      } else {
        /* remove onplay */
        $("#" + media_type + "-" + media_id).removeAttr('onplay');
      }
    }, 'json');
  }, 5000);
}


// initialize scraper
function initialize_scraper() {
  $(".js_publisher-scraper").trigger('keyup');
  $('body').addClass('publisher-focus');
  $('.publisher-slider').slideDown();
  $('.publisher-emojis').fadeIn();
}


// run live stream
async function join(channel_name, token, uid) {
  /* init agora client */
  await agora_client.setClientRole("audience");
  /* add event listener to play remote tracks when remote user publishs */
  agora_client.on("user-published", handle_user_published);
  agora_client.on("user-unpublished", handle_user_unpublished);
  /* join the channel */
  await agora_client.join(agora_app_id, channel_name, token, uid);
}
async function subscribe(user, mediaType) {
  await agora_client.subscribe(user, mediaType);
  if (mediaType === 'video') {
    user.videoTrack.play('js_live-video');
  }
  if (mediaType === 'audio') {
    user.audioTrack.play();
  }
  /* hide live status */
  $('#js_live-status').html('').hide();
  /* handle live counter */
  $('#js_live-counter-status').html(__['Online']).removeClass("offline");
  $('#js_live-counter-number').html(1);
  /* update live post streaming process */
  live_post_streaming_process = true;
  /* set live post real-time thread */
  live_post_realtime_thread = setInterval(function () {
    /* check live realtime process */
    if (live_post_realtime_process) {
      return;
    }
    /* set live realtime process */
    var lightbox = $('.lightbox, .livebox');
    var live_post_id = lightbox.data('live-post-id');
    live_post_realtime_process = true;
    var last_comment_id = lightbox.find("ul.js_live-comments .comment:first").data('id') || 0;
    $.post(api['live/reaction'], { 'do': 'stats', 'post_id': live_post_id, 'last_comment_id': last_comment_id }, function (response) {
      /* update live count */
      $('#js_live-counter-number').html(response.live_count);
      /* update comments */
      if (response.comments) {
        lightbox.find('ul.js_live-comments').prepend(response.comments);
      }
      /* reset live realtime process */
      live_post_realtime_process = false;
    }, 'json');
  }, 5000);
  /* bind the beforeunload event */
  $(window).on('beforeunload', function (event) {
    end_live_audience();
    event.preventDefault();
  });
}
function handle_user_published(user, mediaType) {
  subscribe(user, mediaType);
}
function handle_user_unpublished(user) {
  /* show live status */
  if (user._video_muted_) {
    $('#js_live-status').html('<i class="fas fa-video-slash mr5"></i>' + __['Video Muted']).show();
    return;
  }
  if (user._audio_muted_) {
    $('#js_live-status').html('<i class="fas fa-microphone-slash mr5"></i>' + __['Audio Muted']).show();
    return;
  }
  $('#js_live-status').html('<i class="fas fa-exclamation-circle mr5"></i>' + __['Live Ended']).addClass("error").show();
  /* update live post streaming process */
  live_post_streaming_process = false;
  /* clear live post real-time thread */
  clearInterval(live_post_realtime_thread);
  /* handle live counter */
  $('#js_live-counter-status').html(__['Offline']).addClass("offline");
  $('#js_live-counter-number').html(0);
  /* unbind the beforeunload event */
  $(window).off('beforeunload');
}
function end_live_audience() {
  if (!live_post_streaming_process) {
    return;
  }
  /* update live post streaming process */
  live_post_streaming_process = false;
  /* update the server side */
  var lightbox = $('.lightbox, .livebox');
  var live_post_id = lightbox.data('live-post-id');
  $.post(api['live/reaction'], { 'do': 'leave', 'post_id': live_post_id }, 'json');
  /* clear live post real-time thread */
  clearInterval(live_post_realtime_thread);
  /* reset live realtime process */
  live_post_realtime_process = false;
  /* unbind the beforeunload event */
  $(window).off('beforeunload');
  window.location.reload();
};
function join_club_livestream() {
  /* initialize vars */
  var lightbox = $('.livebox');
  var live_post_id = lightbox.data('live-post-id');
  /* get live post */
  $.post(api['live/reaction'], { 'do': 'join', 'post_id': live_post_id }, async function (response) {
    /* check the response */
    if (response.callback) {
      eval(response.callback);
    } else {
      if (response.live_ended) {
        /* show live status */
        $('#js_live-status').html('<i class="fas fa-exclamation-circle mr5"></i>' + __['Live Ended']).addClass("error");
      } else {
        /* init agora client */
        await join(response.agora_channel_name, response.agora_audience_token, response.agora_audience_uid);
      }
    }
  }, 'json');
}


$(function () {

  // run stories
  if ($("#stories").length > 0) {
    var stories = new Zuck('stories', {
      skin: 'Delus',
      avatars: false,
      list: false,
      backNative: true,
      previousTap: true,
      autoFullScreen: false,
      localStorage: true,
      stories: $("#stories").data("json"),
      rtl: (system_langauge_dir == "rtl") ? true : false,
      language: {
        unmute: __['Touch to unmute'],
        keyboardTip: __['Press space to see next'],
        visitLink: __['Visit link'],
        time: {
          ago: __['ago'],
          hour: __['hour'],
          hours: __['hours'],
          minute: __['minute'],
          minutes: __['minutes'],
          fromnow: __['from now'],
          seconds: __['seconds'],
          yesterday: __['yesterday'],
          tomorrow: __['tomorrow'],
          days: __['days']
        }
      }
    });
  };
  /* delete story */
  $('body').on('click', '.js_story-deleter', function () {
    var id = $(this).data('id');
    confirm(__['Delete'], __['Are you sure you want to delete this?'], function () {
      $.post(api['posts/story'], { 'do': 'delete' }, function (response) {
        /* check the response */
        if (response.callback) {
          eval(response.callback);
        } else {
          window.location.reload();
        }
      }, 'json')
        .fail(function () {
          modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
        });
    });
  });


  // run daytime messages
  if (current_page == "index" && daytime_msg_enabled && $('.publisher').length > 0) {
    var now = new Date();
    var hours = now.getHours();
    if (hours >= 0 && hours < 12) {
      $(render_template('#message-morning')).insertAfter('.publisher').fadeIn();
    } else if (hours >= 12 && hours < 18) {
      $(render_template('#message-afternoon')).insertAfter('.publisher').fadeIn();
    } else if (hours >= 18 || hours <= 24) {
      $(render_template('#message-evening')).insertAfter('.publisher').fadeIn();
    }
  }


  // run publisher
  /* publisher focus */
  $('body').on('click', function (e) {
    /* check if there is a publisher in the page */
    if ($(".publisher:not(.mini)").length > 0) {
      if ($(e.target).parents(".publisher:not(.mini)").length > 0 || $(e.target).parents(".js_publisher-attachment-image-remover").length > 0 || $(e.target).parents(".js_publisher-gif-remover").length > 0 || $(e.target).parents(".js_publisher-scraper-remover").length > 0) {
        $('body').addClass('publisher-focus');
        $('.publisher-slider').slideDown();
        $('.publisher-emojis').fadeIn();
        /* check if publisher colored tab activated */
        if ($('.js_publisher-tab[data-tab="colored"]').hasClass('activated')) {
          var publisher = $('.publisher');
          var publisher_message = publisher.find(".publisher-message");
          var publisher_textarea = publisher_message.find('textarea');
          /* check if publisher_message already colored */
          if (!publisher_message.hasClass("colored")) {
            var active_pattern = $(".colored-pattern-item.active");
            /* [1] add colored class */
            publisher_message.addClass("colored");
            /* [2] add pattern background-image */
            if (active_pattern.data("type") == "color") {
              publisher_message.css("backgroundImage", "linear-gradient(45deg, " + active_pattern.data('background-color-1') + ", " + active_pattern.data('background-color-2') + ")");
            } else {
              publisher_message.css("backgroundImage", "url(" + uploads_path + "/" + active_pattern.data('background-image') + ")");
            }
            /* [3] add pattern text-color */
            publisher_textarea.css("color", active_pattern.data('text-color'));
            autosize.update(publisher_textarea);
          }
        }
      } else {
        $('body').removeClass('publisher-focus');
        $('.publisher-slider').slideUp();
        $('.publisher-emojis').fadeOut();
        /* check if publisher colored tab activated */
        if ($('.js_publisher-tab[data-tab="colored"]').hasClass('activated')) {
          var publisher = $('.publisher');
          var publisher_message = publisher.find(".publisher-message");
          var publisher_textarea = publisher_message.find('textarea');
          /* [1] remove colored class */
          publisher_message.removeClass("colored");
          /* [2] remove pattern background-image */
          publisher_message.css("backgroundImage", "");
          /* [3] remove pattern text-color */
          publisher_textarea.css("color", "");
          autosize.update(publisher_textarea);
        }
      }
    }
  });
  /* publisher tabs */
  $('body').on('click', '.js_publisher-tab', function () {
    var _this = $(this);
    var publisher = _this.parents('.publisher');
    var tab = _this.data('tab');
    if (_this.hasClass('link') && _this.hasClass('disabled')) {
      return false;
    }
    /* check if already activated or disabled */
    if (_this.hasClass('activated') || _this.hasClass('disabled')) {
      return;
    }
    /* check if the current scraping process */
    if (tab != "location" && publisher.data('scraping')) {
      return;
    }
    /* handle publisher tab */
    if (!_this.hasClass('attach') && !_this.hasClass('link')) {
      publisher_tab(publisher, tab);
    }
  });
  /* publisher scraper */
  var typing_timer;
  $('body').on('keyup paste input propertychange', '.js_publisher-scraper', function () {
    var _this = $(this);
    var publisher = _this.parents('.publisher');
    var loader = publisher.find('.publisher-loader');
    var button = publisher.find('.js_publisher');
    clearTimeout(typing_timer);
    if (_this.val()) {
      typing_timer = setTimeout(function () {
        /* check if the current process */
        if (publisher.data('photos') || publisher.data('scraping') || publisher.data('video') || publisher.data('audio') || publisher.data('file')) {
          return;
        }
        /* check if there is any active publisher tab than location */
        if (publisher.find('.js_publisher-tab.active[data-tab!="location"]').length > 0) {
          return;
        }
        var raw_query = _this.val().match(/((?:https?:|www\.)[^\s]+)/gi);
        if (raw_query === null || raw_query.length == 0) {
          return;
        }
        var query = raw_query[0];
        /* show the loader */
        loader.show();
        /* disable submit button */
        button_status(button, "loading");
        /* handle publisher tab */
        publisher_tab(publisher, "scraper");
        /* scrabe the link */
        $.post(api['posts/scraper'], { 'query': query }, function (response) {
          /* hide the loader */
          loader.hide();
          /* enable submit button */
          button_status(button, "reset");
          if (response.callback) {
            eval(response.callback);
          } else if (response.link) {
            /* add the link to publisher data */
            publisher.data('scraping', response.link);
            /* hide photos uploader */
            $('.js_publisher-photos').hide();
            /* get the template */
            if (response.link['source_type'] == "photo") {
              /* photo */
              var template = render_template('#scraper-photo', { 'url': response.link['source_url'], 'provider': response.link['source_provider'] });
            } else if (response.link['source_type'] == "link") {
              /* link */
              var template = render_template('#scraper-link', { 'thumbnail': response.link['source_thumbnail'], 'host': response.link['source_host'], 'url': response.link['source_url'], 'title': response.link['source_title'], 'text': response.link['source_text'] });
            } else {
              /* media */
              if (["YouTube", "Vimeo", "Twitch", "Rumble.com", "Banned.Video", "Brighteon", "Odysee", "Gab TV"].includes(response.link['source_provider'])) {
                var template = render_template('#scraper-player', { 'url': response.link['source_url'], 'title': response.link['source_title'], 'text': response.link['source_text'], 'html': response.link['source_html'], 'provider': response.link['source_provider'] });
              } else if (response.link['source_provider'] == "Facebook") {
                var template = render_template('#scraper-facebook', { 'url': response.link['source_url'], 'title': response.link['source_title'], 'text': response.link['source_text'], 'html': response.link['source_html'], 'provider': response.link['source_provider'] });
              } else {
                var template = render_template('#scraper-media', { 'url': response.link['source_url'], 'title': response.link['source_title'], 'text': response.link['source_text'], 'html': response.link['source_html'], 'provider': response.link['source_provider'] });
              }

            }
            /* show the publisher scraper */
            publisher.find('.publisher-scraper').html(template).fadeIn();
            /* reset facebook iframes */
            rebuild_facebook_iframes();
          }
        }, 'json');
      }, 500);
    }
  });
  /* publisher scraper remover */
  $('body').on('click', '.js_publisher-scraper-remover', function () {
    var publisher = $(this).parents('.publisher');
    /* remove the link from publisher data */
    publisher.removeData('scraping');
    /* hide the publisher scraper */
    publisher.find('.publisher-scraper').html('').fadeOut();
    /* handle publisher tab */
    publisher_tab(publisher, "scraper");
  });
  /* publisher album */
  $('body').on('keyup', '.publisher-meta[data-meta="album"] input', function () {
    if ($(this).val() == '') {
      $('.js_publisher-tab[data-tab="album"]').removeClass('activated');
    } else {
      $('.js_publisher-tab[data-tab="album"]').addClass('activated');
    }
  });
  /* publisher feelings */
  $('body').on('click', '.js_publisher-feelings', function () {
    $(this).toggleClass('active');
    $('.publisher-meta[data-meta="feelings"]').slideToggle('fast');
    /* show feelings menu */
    $('#feelings-menu:hidden').slideDown('fast');
  });
  $('body').on('keyup', '.publisher-meta[data-meta="feelings"] input', function () {
    if ($(this).val() == '') {
      $('.js_publisher-feelings').removeClass('activated');
    } else {
      $('.js_publisher-feelings').addClass('activated');
    }
  });
  $('body').on('click', '#feelings-menu-toggle', function () {
    /* show feelings menu */
    $('#feelings-menu').slideToggle('fast');
    /* hide feelings types */
    $('#feelings-types:visible').hide();
    /* update feelings menu toggle */
    $(this).removeClass('active').text($(this).data("init-text"));
    /* hide feelings data */
    $('#feelings-data').hide();
    /* update/show feelings data input */
    $('#feelings-data input').show().attr('placeholder', $(this).data('init-text')).removeData('action').val('');
    /* update feelings data span */
    $('#feelings-data span').html('').hide();
    /* update publisher feelings */
    $('.js_publisher-feelings').removeClass('activated');
  });
  $('body').on('click', '.js_feelings-add', function () {
    /* hide feelings menu */
    $('#feelings-menu').hide();
    /* update feelings menu toggle */
    $('#feelings-menu-toggle').addClass('active').text($(this).find('.data').text());
    /* show feelings data */
    $('#feelings-data').show();
    if ($(this).data('action') == "Feeling") {
      /* update/hide feelings data input */
      $('#feelings-data input').hide().attr('placeholder', $(this).data('placeholder')).data('action', $(this).data('action'));
      /* update feelings data span */
      $('#feelings-data span').html($(this).data('placeholder')).show();
      /* show feelings types */
      $('#feelings-types').slideToggle('fast');
    } else {
      /* update/show feelings data input */
      $('#feelings-data input').show().attr('placeholder', $(this).data('placeholder')).data('action', $(this).data('action')).val('').trigger('focus');
      /* update feelings data span */
      $('#feelings-data span').html('').hide();
      /* update publisher feelings */
      $('.js_publisher-feelings').removeClass('activated');
    }
  });
  $('body').on('click', '.js_feelings-type', function () {
    /* hide feelings types */
    $('#feelings-types').hide();
    /* update/hide feelings data input */
    $('#feelings-data input').hide().val($(this).data("type"));
    /* update feelings data span */
    $('#feelings-data span').html('<i class="twa twa-lg twa-' + $(this).data("icon") + '"></i>' + $(this).find('.data').text());
    /* update publisher feelings */
    $('.js_publisher-feelings').addClass('activated');
  });
  /* publisher location */
  $('body').on('keyup', '.publisher-meta[data-meta="location"] input', function () {
    if ($(this).val() == '') {
      $('.js_publisher-tab[data-tab="location"]').removeClass('activated');
    } else {
      $('.js_publisher-tab[data-tab="location"]').addClass('activated');
    }
  });
  /* publisher patterns */
  $('body').on('click', '.js_publisher-pattern', function () {
    var _this = $(this);
    var publisher = _this.parents('.publisher');
    var publisher_message = publisher.find(".publisher-message");
    var publisher_textarea = publisher_message.find('textarea');
    /* deactivate any active previous pattern */
    $(".colored-pattern-item.active").not(this).removeClass("active");
    _this.toggleClass("active");
    if (_this.hasClass("active")) {
      /* [1] add colored class */
      publisher_message.addClass("colored");
      /* [2] add pattern background-image */
      if (_this.data("type") == "color") {
        publisher_message.css("backgroundImage", "linear-gradient(45deg, " + _this.data('background-color-1') + ", " + _this.data('background-color-2') + ")");
      } else {
        publisher_message.css("backgroundImage", "url(" + uploads_path + "/" + _this.data('background-image') + ")");
      }
      /* [3] add pattern text-color */
      publisher_textarea.css("color", _this.data('text-color'));
      autosize.update(publisher_textarea);
      /* [4] activate the publisher colored tab */
      $('.js_publisher-tab[data-tab="colored"]').addClass('activated');
      /* [5] add pattern to the publisher */
      publisher.data("colored_pattern", _this.data("id"));
    } else {
      /* [1] remove colored class */
      publisher_message.removeClass("colored");
      /* [2] remove pattern background-image */
      publisher_message.css("backgroundImage", "");
      /* [3] remove pattern text-color */
      publisher_textarea.css("color", "");
      autosize.update(publisher_textarea);
      /* [4] dectivate the publisher colored tab */
      $('.js_publisher-tab[data-tab="colored"]').removeClass('activated');
      /* [5] remove pattern from the publisher */
      publisher.removeData("colored_pattern");
    }
  });
  /* publisher gif search */
  $('body').on('keyup', '.js_publisher-gif-search', function () {
    var _this = $(this);
    var query = _this.val();
    if (!is_empty(query)) {
      /* check if results dropdown-menu already exist */
      if (_this.next('.dropdown-menu').length == 0) {
        /* construct a new one */
        _this.after('<div class="dropdown-menu gif-search"></div>');
      }
      /* add the loader */
      _this.next('.dropdown-menu').show().html('<div class="loader loader_small ptb10"></div>');
      /* get results */
      $.get('https://api.giphy.com/v1/gifs/search?', { q: query, api_key: giphy_key, limit: 20 }, function (response) {
        if (response.meta.status == 200 && response.data.length > 0) {
          _this.next('.dropdown-menu').show().html("<div class='js_scroller' data-slimScroll-height='180'><div>");
          for (var i = 0; i < response.data.length; i++) {
            _this.next('.dropdown-menu').find('.js_scroller').append($('<div class="item"><img class="js_publisher-gif-add" src="' + response.data[i].images.fixed_height_small.url + '" data-gif="' + response.data[i].images.fixed_height.url + '" autoplay loop></div>'));
          }
        } else {
          _this.next('.dropdown-menu').show().html('<div class="ptb5 plr10">' + __['No result found'] + '</div>');
        }
      }, 'json');
    } else {
      /* check if results dropdown-menu already exist */
      if (_this.next('.dropdown-menu').length > 0) {
        _this.next('.dropdown-menu').hide();
      }
    }
  });
  /* show previous results dropdown-menu when the input is clicked */
  $('body').on('click focus', '.js_publisher-gif-search', function () {
    var query = $(this).val();
    if (!is_empty(query)) {
      $(this).next('.dropdown-menu').show();
    }
  });
  /* hide the results dropdown-menu when clicked outside the input */
  $('body').on('click', function (e) {
    if (!$(e.target).is(".js_publisher-gif-search")) {
      $('.js_publisher-gif-search').next('.dropdown-menu').hide();
    }
  });
  /* publisher gif add */
  $('body').on('click', '.js_publisher-gif-add', function () {
    var _this = $(this);
    var publisher = _this.parents('.publisher');
    var link = {};
    link['source_html'] = 'null';
    link['source_provider'] = 'giphy';
    link['source_text'] = 'null';
    link['source_title'] = _this.data('gif');
    link['source_type'] = 'photo';
    link['source_url'] = _this.data('gif');
    /* add the link to publisher data */
    publisher.data('scraping', link);
    var template = render_template('#pubisher-gif', { 'src': link['source_url'] });
    /* show the publisher scraper */
    publisher.find('.publisher-scraper').html(template).fadeIn();
    $('.js_publisher-tab[data-tab="gif"]').addClass('activated');
  });
  /* publisher gif remover */
  $('body').on('click', '.js_publisher-gif-remover', function () {
    var publisher = $(this).parents('.publisher');
    /* remove the link from publisher data */
    publisher.removeData('scraping');
    /* hide the publisher scraper */
    publisher.find('.publisher-scraper').html('').fadeOut();
    /* handle publisher tab */
    publisher_tab(publisher, "gif");
    publisher.find('.js_publisher-tab[data-tab="gif"]').removeClass('activated');
    publisher.find('.js_publisher-gif-search').val('');
  });
  /* publisher poll */
  $('body').on('keyup', '.publisher-meta[data-meta="poll"] input', function () {
    var $emptyFields = $('.publisher-meta[data-meta="poll"] input').filter(function () {
      return $.trim(this.value) === "";
    });
    if ($emptyFields.length == $('.publisher-meta[data-meta="poll"] input').length) {
      $('.js_publisher-tab[data-tab="poll"]').removeClass('activated');
    } else {
      $('.js_publisher-tab[data-tab="poll"]').addClass('activated');
    }
  });
  $('body').on('focus', '.publisher-meta[data-meta="poll"] input:last', function () {
    $(render_template('#poll-option')).insertAfter($(this).parent()).fadeIn();
  });
  /* publisher attachment image remover */
  $('body').on('click', '.js_publisher-attachment-image-remover, .js_publisher-mini-attachment-image-remover', function () {
    var mini = ($(this).hasClass('js_publisher-mini-attachment-image-remover')) ? true : false;
    var item = $(this).parents('li.item');
    var src = item.data('src');
    var publisher = (!mini) ? $(this).parents('.publisher') : $(this).parents('.publisher-mini');
    var has_hidden_input = (publisher.find('.js_hidden-input-photos').length > 0) ? true : false;
    var files = publisher.data('photos');
    delete files[src];
    if (Object.keys(files).length > 0) {
      publisher.data('photos', files);
      /* remove photos data from hidden input if exists */
      if (has_hidden_input) {
        publisher.find('.js_hidden-input-photos').val(JSON.stringify(files));
      }
    } else {
      publisher.removeData('photos');
      /* remove photos data from hidden input if exists */
      if (has_hidden_input) {
        publisher.find('.js_hidden-input-photos').val('');
      }
      if (!mini) {
        publisher.find('.js_attachments-photos').hide();
        /* handle publisher tab */
        publisher_tab(publisher, "photos");
        publisher.find('.js_publisher-tab[data-tab="photos"]').removeClass('activated');
      }
    }
    /* remove the attachment item */
    item.remove();
    /* remove the attachment from server */
    $.post(api['data/delete'], { 'src': src });
  });
  /* publisher mini attachment video remover */
  $('body').on('click', '.js_publisher-mini-attachment-video-remover', function () {
    var item = $(this).parents('li.item');
    var src = item.data('src');
    /* remove the attachment from publisher data */
    var publisher = $(this).parents('.publisher-mini');
    var files = publisher.data('video');
    delete files[src];
    if (Object.keys(files).length > 0) {
      publisher.data('video', files);
    } else {
      publisher.removeData('video');
    }
    /* remove the attachment item */
    item.remove();
    /* remove the attachment from server */
    $.post(api['data/delete'], { 'src': src });
  });
  /* publisher attachment file remover (reel|video|audio|file) */
  $('body').on('click', '.js_publisher-attachment-file-remover', function () {
    var _this = $(this);
    var type = _this.data("type");
    var publisher = _this.parents('.publisher');
    var src = publisher.data(type);
    src = src['source'];
    if (src === undefined) return;
    /* remove the uploads from publisher data */
    publisher.removeData(type);
    publisher.find('.publisher-meta[data-meta="' + type + '"]').hide();
    if (type == "reel") {
      /* remove the thumbnail */
      var attachments_reel_thumbnail = publisher.find('.publisher-reel-custom-thumbnail');
      attachments_reel_thumbnail.find('.x-image').removeAttr("style");
      attachments_reel_thumbnail.find('input.js_x-image-input').val("");
      attachments_reel_thumbnail.hide();
      /* uncheck adult toggle */
      publisher.find('.js_publisher-adult-toggle').prop('disabled', false);
      publisher.find("#adult-toggle-wrapper").removeClass("disabled");
      /* uncheck tips toggle */
      publisher.find('.js_publisher-tips-toggle').prop('disabled', false);
      publisher.find("#tips-toggle-wrapper").removeClass("disabled");
      /* uncheck subscribers toggle */
      publisher.find('.js_publisher-subscribers-toggle').prop('disabled', false);
      publisher.find("#subscribers-toggle-wrapper").removeClass("disabled");
      /* uncheck paid toggle */
      publisher.find('.js_publisher-paid-toggle').prop('disabled', false);
      publisher.find("#paid-toggle-wrapper").removeClass("disabled");
    } else if (type == "video") {
      /* remove the thumbnail */
      var attachments_video_thumbnail = publisher.find('.publisher-video-custom-thumbnail');
      attachments_video_thumbnail.find('.x-image').removeAttr("style");
      attachments_video_thumbnail.find('input.js_x-image-input').val("");
      attachments_video_thumbnail.hide();
    }
    publisher_tab(publisher, type);
    publisher.find('.js_publisher-tab[data-tab="' + type + '"]').removeClass('activated');
    /* remove the attachment from server */
    $.post(api['data/delete'], { 'src': src });
  });
  /* publish new post */
  $('body').on('click', '.js_publisher', function () {
    var _this = $(this);
    /* get posts stream */
    var posts_stream = $('.js_posts_stream');
    /* get publisher */
    var publisher = _this.parents('.publisher');
    /* get handle */
    var handle = publisher.data('handle');
    /* get (user|page|group|event) id */
    var id = publisher.data('id');
    /* get text */
    var textarea = publisher.find('textarea');
    /* get link */
    var link = publisher.data('scraping');
    /* get photos */
    var attachments_photos = publisher.find('.js_attachments-photos');
    var photos = publisher.data('photos');
    /* get album */
    var album_meta = publisher.find('.publisher-meta[data-meta="album"]');
    var album = album_meta.find('input');
    /* get feeling */
    var feeling_meta = publisher.find('.publisher-meta[data-meta="feelings"]');
    var feeling = feeling_meta.find('input');
    /* get location */
    var location_meta = publisher.find('.publisher-meta[data-meta="location"]');
    var location = location_meta.find('input');
    /* get colored pattern */
    var colored_pattern_meta = publisher.find('.publisher-meta[data-meta="colored"]');
    /* get voice note */
    var attachments_voice_notes = publisher.find('.publisher-meta[data-meta="voice_notes"]');
    var voice_notes = publisher.data('voice_notes');
    /* get gif */
    var gif_meta = publisher.find('.publisher-meta[data-meta="gif"]');
    var gif = gif_meta.find('input');
    /* get poll options */
    var poll_options = [];
    publisher.find('.publisher-meta[data-meta="poll"] input').each(function (index) {
      if ($(this).val() != "") {
        poll_options[index] = $(this).val();
      }
    });
    poll_options = (poll_options.length > 0) ? poll_options : undefined;
    /* get reel */
    var attachments_reel = publisher.find('.js_attachments-reel');
    var attachments_reel_meta = publisher.find('.publisher-meta[data-meta="reel"]');
    var reel = publisher.data('reel');
    var attachments_reel_thumbnail = publisher.find('.publisher-reel-custom-thumbnail');
    var reel_thumbnail = attachments_reel_thumbnail.find('input.js_x-image-input').val();
    /* get video */
    var attachments_video = publisher.find('.js_attachments-video');
    var attachments_video_meta = publisher.find('.publisher-meta[data-meta="video"]');
    var video = publisher.data('video');
    var attachments_video_thumbnail = publisher.find('.publisher-video-custom-thumbnail');
    var video_thumbnail = attachments_video_thumbnail.find('input.js_x-image-input').val();
    var video_category = attachments_video_meta.find('select').val();
    /* get audio */
    var attachments_audio = publisher.find('.js_attachments-audio');
    var attachments_audio_meta = publisher.find('.publisher-meta[data-meta="audio"]');
    var audio = publisher.data('audio');
    /* get file */
    var attachments_file = publisher.find('.js_attachments-file');
    var attachments_file_meta = publisher.find('.publisher-meta[data-meta="file"]');
    var file = publisher.data('file');
    /* get privacy */
    var privacy = publisher.find('.btn-group').data('value');
    /* get schedule */
    var is_schedule = publisher.find('.js_publisher-schedule-toggle').is(":checked");
    var local_schedule_date = publisher.find('.js_publisher-schedule-date').val() || '';
    local_schedule_date = (local_schedule_date) ? new Date(local_schedule_date.replace(' ', 'T') + ':00') : '';
    var schedule_date = (local_schedule_date) ? local_schedule_date.toISOString().slice(0, 19).replace('T', ' ') : '';
    /* get anonymous */
    var is_anonymous = publisher.find('.js_publisher-anonymous-toggle').is(":checked");
    /* get adult content */
    var for_adult = publisher.find('.js_publisher-adult-toggle').is(":checked");
    /* get tips enabled */
    var tips_enabled = publisher.find('.js_publisher-tips-toggle').is(":checked");
    /* get subscribers only */
    var for_subscriptions = publisher.find('.js_publisher-subscribers-toggle').is(":checked");
    var subscriptions_image_wrapper = publisher.find("#subscriptions-image-wrapper")
    var subscriptions_image_input = subscriptions_image_wrapper.find('input.js_x-image-input');
    /* get paid post */
    var is_paid = publisher.find('.js_publisher-paid-toggle').is(":checked");
    var paid_locked_wrapper = publisher.find("#paid-lock-toggle-wrapper");
    var is_paid_locked = publisher.find('.js_publisher-paid-lock-toggle').is(":checked");
    var paid_price_wrapper = publisher.find("#paid-price-wrapper");
    var paid_price_input = paid_price_wrapper.find('input');
    var paid_text_wrapper = publisher.find("#paid-text-wrapper")
    var paid_text_input = paid_text_wrapper.find('textarea');
    var paid_image_wrapper = publisher.find("#paid-image-wrapper")
    var paid_image_input = paid_image_wrapper.find('input.js_x-image-input');
    /* get post_as_page from hidden input if exists */
    var post_as_page = publisher.find('input[name="post_as_page"]').val();
    /* get the error element */
    var error = publisher.find('.alert.alert-danger');
    /* return if no data to post */
    if (is_empty(textarea.val()) && link === undefined && photos === undefined && feeling.val() == "" && location.val() == "" && voice_notes === undefined && poll_options === undefined && reel === undefined && video === undefined && audio === undefined && file === undefined) {
      return;
    }
    /* button loading */
    button_status(_this, "loading");
    posts_stream.data('loading', true);
    $.post(api['posts/post'], { 'handle': handle, 'id': id, 'message': textarea.val(), 'link': JSON.stringify(link), 'photos': JSON.stringify(photos), 'album': album.val(), 'feeling_action': feeling.data('action'), 'feeling_value': feeling.val(), 'location': location.val(), 'colored_pattern': publisher.data('colored_pattern'), 'voice_notes': JSON.stringify(voice_notes), 'poll_options': JSON.stringify(poll_options), 'reel': JSON.stringify(reel), 'reel_thumbnail': reel_thumbnail, 'video': JSON.stringify(video), 'video_thumbnail': video_thumbnail, 'video_category': video_category, 'audio': JSON.stringify(audio), 'file': JSON.stringify(file), 'privacy': privacy, 'is_anonymous': is_anonymous, 'is_schedule': is_schedule, 'schedule_date': schedule_date, 'for_adult': for_adult, 'tips_enabled': tips_enabled, 'for_subscriptions': for_subscriptions, 'subscriptions_image': subscriptions_image_input.val(), 'is_paid': is_paid, 'is_paid_locked': is_paid_locked, 'post_price': paid_price_input.val(), 'paid_text': paid_text_input.val(), 'paid_image': paid_image_input.val(), 'post_as_page': post_as_page }, function (response) {
      if (response.callback) {
        /* button reset */
        button_status(_this, "reset");
        eval(response.callback);
      } else {
        /* check if publisher modal mode -> redirect to post page */
        if (publisher.data('modal-mode') && !response.approval && !response.processing) {
          window.location.href = site_path + "/posts/" + response.post_id;
        }
        /* button reset */
        button_status(_this, "reset");
        /* remove the error */
        error.hide();
        /* prepare publisher */
        /* remove (active|activated|disabled) from all tabs */
        publisher.find('.js_publisher-tab').removeClass('active activated disabled');
        textarea.val('').removeAttr('style');
        textarea.attr('placeholder', textarea.data('init-placeholder'));
        /* hide & empty album */
        album.val('');
        album_meta.hide();
        /* hide & empty feelings */
        feeling_meta.hide();
        $("#feelings-menu-toggle").removeClass('active').text($("#feelings-menu-toggle").data("init-text"));
        $('#feelings-data').hide();
        $('#feelings-data input').show().attr('placeholder', $("#feelings-menu-toggle").data('init-text')).removeData('action').val('');
        $('#feelings-data span').html('');
        $('.js_publisher-feelings').removeClass('activated active');
        /* hide & empty location */
        location.val('');
        location_meta.hide();
        /* hide & empty colored patterns */
        publisher.removeData("colored_pattern");
        publisher.find(".publisher-message").removeAttr('style').removeClass("colored");
        publisher.find(".colored-pattern-item.active").removeClass("active");
        colored_pattern_meta.hide();
        /* hide & empty voice notes */
        attachments_voice_notes.hide();
        attachments_voice_notes.find(".js_voice-success-message").hide();
        attachments_voice_notes.find('.js_voice-start').show();
        publisher.removeData('voice_notes');
        /* hide & empty gif */
        gif.val('');
        gif_meta.hide();
        /* hide & remove poll meta */
        $('.publisher-meta[data-meta="poll"]').hide().find('input').val('');
        /* hide & empty attachments */
        /* ** photos ** */
        attachments_photos.hide();
        attachments_photos.find('li.item').remove();
        publisher.removeData('photos');
        /* ** reel ** */
        attachments_reel.hide();
        attachments_reel_meta.hide();
        publisher.removeData('reel');
        /* ** video ** */
        attachments_video.hide();
        attachments_video_meta.hide();
        publisher.removeData('video');
        /* ** audio ** */
        attachments_audio.hide();
        attachments_audio_meta.hide();
        publisher.removeData('audio');
        /* ** file ** */
        attachments_file.hide();
        attachments_file_meta.hide();
        publisher.removeData('file');
        /* hide & empty reel custom thumbnail */
        attachments_reel_thumbnail.find('.x-image').removeAttr("style");
        attachments_reel_thumbnail.find('input.js_x-image-input').val("");
        attachments_reel_thumbnail.hide();
        /* hide & empty video custom thumbnail */
        attachments_video_thumbnail.find('.x-image').removeAttr("style");
        attachments_video_thumbnail.find('input.js_x-image-input').val("");
        attachments_video_thumbnail.hide();
        /* hide & empty scraper */
        $('.publisher-scraper').hide().html('');
        publisher.removeData('scraping');
        /* uncheck schedule toggle */
        publisher.find('.js_publisher-schedule-toggle').prop('checked', false);
        publisher.find('.js_publisher-schedule-date').val('');
        publisher.find("#schedule-toggle-wrapper").hide();
        /* uncheck anonymous toggle */
        publisher.find('.js_publisher-anonymous-toggle').prop('checked', false);
        /* uncheck adult toggle */
        publisher.find('.js_publisher-adult-toggle').prop('checked', false);
        /* uncheck tips toggle */
        publisher.find('.js_publisher-tips-toggle').prop('checked', false);
        /* uncheck subscribers toggle */
        publisher.find('.js_publisher-subscribers-toggle').prop('checked', false);
        publisher.find('.js_publisher-subscribers-toggle').prop('disabled', false);
        publisher.find("#subscribers-toggle-wrapper").removeClass("disabled");
        /* reset subscriptions image */
        subscriptions_image_wrapper.hide();
        subscriptions_image_wrapper.find('.x-image').removeAttr("style");
        subscriptions_image_wrapper.find('.js_x-image-remover').hide();
        subscriptions_image_input.val('');
        /* uncheck paid toggle */
        publisher.find('.js_publisher-paid-toggle').prop('checked', false);
        publisher.find('.js_publisher-paid-toggle').prop('disabled', false);
        publisher.find("#paid-toggle-wrapper").removeClass("disabled");
        /* reset paid lock toggle */
        paid_locked_wrapper.toggleClass('x-hidden');
        publisher.find('.js_publisher-paid-lock-toggle').prop('checked', false);
        /* reset paid price */
        paid_price_wrapper.hide();
        paid_price_input.val('');
        paid_text_wrapper.hide();
        paid_text_input.val('');
        /* reset paid image */
        paid_image_wrapper.hide();
        paid_image_wrapper.find('.x-image').removeAttr("style");
        paid_image_wrapper.find('.js_x-image-remover').hide();
        paid_image_input.val('');
        /* reset privacy */
        publisher.find('.btn-group').show();
        publisher.find('.js_publisher-privacy-public').hide();
        /* collapse the publisher */
        $('body').removeClass('publisher-focus');
        publisher.find('.publisher-slider').slideUp();
        publisher.find('.publisher-emojis').fadeOut();
        /* release the loading status */
        posts_stream.removeData('loading');
        if (response.approval) {
          modal('#modal-success', { title: __['Under Review'], message: __['Your post is under review now, We will let you know when it is ready!'] });
        } else if (response.processing) {
          modal('#modal-success', { title: __['Processing'], message: __['Your video is being processed, We will let you know when it is ready!'] });
        } else {
          /* attache the new post */
          $('.js_posts_stream').find('ul:first').prepend(response.post);
          /* rerun photo grid */
          ui_rebuild();
          /* close the window if share plugin */
          if (current_page == "share") {
            window.close();
          }
        }
      }
    }, "json")
      .fail(function () {
        /* button reset */
        button_status(_this, "reset");
        modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
      });
  });
  /* publisher schedule toggle */
  $('body').on('click', '.js_publisher-schedule-toggle', function () {
    var _this = $(this);
    $("#schedule-toggle-wrapper").toggle();
  });
  /* publisher anonymous toggle */
  $('body').on('click', '.js_publisher-anonymous-toggle', function () {
    var _this = $(this);
    var publisher = _this.parents('.publisher');
    publisher_tab(publisher, "anonymous");
    publisher.find('.btn-group').toggle();
    publisher.find('.js_publisher-privacy-public').toggle();
  });
  /* publisher subscribers toggle */
  $('body').on('click', '.js_publisher-subscribers-toggle', function () {
    var _this = $(this);
    var publisher = _this.parents('.publisher');
    $("#paid-toggle-wrapper").toggleClass("disabled");
    $(".js_publisher-paid-toggle").prop("disabled", !$(".js_publisher-paid-toggle").prop("disabled"));
    $("#subscriptions-image-wrapper").toggle();
    publisher.find('.btn-group').toggle();
    publisher.find('.js_publisher-privacy-public').toggle();
  });
  /* publisher paid toggle */
  $('body').on('click', '.js_publisher-paid-toggle', function () {
    var _this = $(this);
    var publisher = _this.parents('.publisher');
    $("#subscribers-toggle-wrapper").toggleClass("disabled");
    $(".js_publisher-subscribers-toggle").prop("disabled", !$(".js_publisher-subscribers-toggle").prop("disabled"));
    $("#paid-lock-toggle-wrapper").toggleClass('x-hidden');
    $("#paid-price-wrapper").toggle();
    $("#paid-text-wrapper").toggle();
    $("#paid-image-wrapper").toggle();
    publisher.find('.btn-group').toggle();
    publisher.find('.js_publisher-privacy-public').toggle();
  });
  /* publish new story */
  $('body').on('click', '.js_publisher-story', function () {
    var _this = $(this);
    /* get publisher */
    var publisher = _this.parents('.publisher-mini');
    /* get is_ads */
    var is_ads = publisher.find('#is_ads').is(":checked")
    /* get text */
    var textarea = publisher.find('textarea');
    /* get photos */
    var photos = publisher.data('photos');
    /* get videos */
    var videos = publisher.data('video');
    /* return if no data to post */
    if (photos === undefined && videos === undefined) {
      return;
    }
    /* button loading */
    button_status(_this, "loading");
    $.post(api['posts/story'], { 'do': 'publish', 'is_ads': is_ads, 'message': textarea.val(), 'photos': JSON.stringify(photos), 'videos': JSON.stringify(videos) }, function (response) {
      if (response.callback) {
        /* button reset */
        button_status(_this, "reset");
        eval(response.callback);
      }
    }, "json")
      .fail(function () {
        /* button reset */
        button_status(_this, "reset");
        modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
      });
  });
  /* publish new product */
  $('body').on('click', '.js_publisher-product', function () {
    var _this = $(this);
    /* get publisher */
    var publisher = _this.parents('.publisher-mini');
    /* get product */
    var product = {};
    publisher.find('input, textarea, select').each(function (index) {
      product[$(this).attr('name')] = $(this).val();
    });
    if (!$.isEmptyObject(product)) {
      product['is_digital'] = (publisher.find('.js_publisher-digital').is(":checked")) ? 1 : 0;
      product['category'] = publisher.find('select[name="category"]').val();
      product['status'] = publisher.find('select[name="status"]').val();
    } else {
      return;
    }
    /* get text */
    var textarea = publisher.find('textarea');
    /* get photos */
    var photos = publisher.data('photos');
    /* button loading */
    button_status(_this, "loading");
    $.post(api['posts/product'], { 'do': 'publish', 'product': JSON.stringify(product), 'message': textarea.val(), 'photos': JSON.stringify(photos) }, function (response) {
      /* button reset */
      button_status(_this, "reset");
      if (response.error) {
        publisher.find('.alert.alert-danger').html(response.message).slideDown();
      } else if (response.callback) {
        eval(response.callback);
      }
    }, "json")
      .fail(function () {
        /* button reset */
        button_status(_this, "reset");
        modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
      });
  });
  /* publish new photos to album */
  $('body').on('click', '.js_publisher-album', function () {
    var _this = $(this);
    /* get publisher */
    var publisher = _this.parents('.publisher');
    /* get album id */
    var id = publisher.data('id');
    /* get text */
    var textarea = publisher.find('textarea');
    /* get photos */
    var photos = publisher.data('photos');
    /* get location */
    var location_meta = publisher.find('.publisher-meta[data-meta="location"]');
    var location = location_meta.find('input');
    /* get feeling */
    var feeling_meta = publisher.find('.publisher-meta[data-meta="feelings"]');
    var feeling = feeling_meta.find('input');
    /* get privacy */
    var privacy = publisher.find('.btn-group').data('value');
    /* return if no data to post */
    if (photos === undefined) {
      return;
    }
    /* button loading */
    button_status(_this, "loading");
    $.post(api['albums/action'], { 'do': 'add_photos', 'id': id, 'message': textarea.val(), 'photos': JSON.stringify(photos), 'feeling_action': feeling.data('action'), 'feeling_value': feeling.val(), 'location': location.val(), 'privacy': privacy }, function (response) {
      if (response.callback) {
        /* button reset */
        button_status(_this, "reset");
        eval(response.callback);
      }
    }, "json")
      .fail(function () {
        /* button reset */
        button_status(_this, "reset");
        modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
      });
  });
  /* publish new review */
  $('body').on('click', '.js_publisher-review', function () {
    var _this = $(this);
    var publisher = _this.parents('.publisher-mini');
    /* button loading */
    button_status(_this, "loading");
    $.post(api['modules/review'], { 'do': 'publish-review', 'id': publisher.data('id'), 'type': publisher.data('type'), 'rating': publisher.find('input[name="rating"]:checked').val(), 'review': publisher.find('textarea').val(), 'photos': JSON.stringify(publisher.data('photos')) }, function (response) {
      if (response.callback) {
        /* button reset */
        button_status(_this, "reset");
        eval(response.callback);
      }
    }, "json")
      .fail(function () {
        /* button reset */
        button_status(_this, "reset");
        modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
      });
  });


  // run voice notes
  /* shim for AudioContext|getUserMedia if it's not available */
  window.AudioContext = window.AudioContext || window.webkitAudioContext;
  navigator.getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia;
  /* start voice recording */
  $('body').on('click', '.js_voice-start', function () {
    /* check if there recording process */
    if (voice_recording_process) {
      return;
    }
    var _this = $(this);
    var _parent = _this.parents(".voice-recording-wrapper");
    var voice_start_button = _this;
    var voice_stop_button = _parent.find('.js_voice-stop');
    var voice_timer = _parent.find(".js_voice-timer");
    var voice_processing_message = _parent.find('.js_voice-processing-message');
    var voice_success_message = _parent.find('.js_voice-success-message');
    var handle = _parent.data("handle");
    var handle_type = "voice_notes";
    /* hide voice start button */
    voice_start_button.hide();
    /* show voice stop button */
    voice_stop_button.show();
    /* init recording timer */
    voice_recording_timer = new easytimer.Timer();
    voice_recording_timer.addEventListener('secondsUpdated', function (e) {
      voice_timer.html(voice_recording_timer.getTimeValues().toString(['minutes', 'seconds']));
    });
    voice_recording_timer.addEventListener('started', function (e) {
      voice_timer.html(voice_recording_timer.getTimeValues().toString(['minutes', 'seconds']));
    });
    voice_recording_timer.addEventListener('reset', function (e) {
      voice_timer.html(voice_recording_timer.getTimeValues().toString(['minutes', 'seconds']));
    });
    /* init stop recording */
    voice_stop_button[0].addEventListener('click', function () {
      /* stop recording ... */
      /* stop microphone access */
      voice_recording_stream.getAudioTracks()[0].stop();
      /* tell the recorder to stop the recording */
      voice_recording_object.finishRecording();
    });
    /* start recording ... */
    navigator.mediaDevices.getUserMedia({ audio: true, video: false }).then(function (stream) {
      /* create an audio context after getUserMedia is called */
      var audioContext = new AudioContext();
      /*  assign to voice_recording_stream for later use */
      voice_recording_stream = stream;
      /* Create the WebAudioRecorder object */
      voice_recording_object = new WebAudioRecorder(audioContext.createMediaStreamSource(stream),
        {
          workerDir: site_path + "/node_modules/web-audio-recorder-js/lib-minified/",
          encoding: voice_recording_encoding,
          numChannels: 2
        }
      );
      /* handle onComplete event */
      voice_recording_object.onComplete = function (recorder, blob) {
        /* hide voice stop button */
        voice_stop_button.hide();
        /* stop recording timer */
        voice_recording_timer.reset();
        voice_recording_timer.stop();
        /* update voice processing process */
        voice_recording_process = false;
        /* show voice processing message */
        voice_processing_message.show();
        /* upload the blob audio file */
        var formData = new FormData();
        formData.append('secret', secret);
        formData.append('type', 'audio');
        formData.append('handle', 'voice_notes');
        formData.append('multiple', 'false');
        formData.append('file', blob);
        formData.append('name', guid() + "." + voice_recording_encoding);
        formData.append('guid', guid());
        $.ajax({
          url: api['data/upload'],
          type: 'POST',
          data: formData,
          contentType: false,
          processData: false,
          success: function (response) {
            /* handle the response */
            if (response.callback) {
              if (handle == "publisher") {
                /* publisher */
                var publisher = _this.parents('.publisher');
                var publisher_button = publisher.find('.js_publisher-btn');
                /* enable publisher button */
                button_status(publisher_button, "reset");
              }
              eval(response.callback);
            } else {
              /* hide voice processing message */
              voice_processing_message.hide();
              /* show voice success message */
              voice_success_message.show();
              /* check the handle */
              if (handle == "publisher") {
                /* publisher */
                var publisher = _this.parents('.publisher');
                var publisher_button = publisher.find('.js_publisher-btn');
                /* add publisher-attachments */
                publisher.data(handle_type, { 'source': response.file });
                /* handle publisher tabs */
                publisher.find('.js_publisher-tab[data-tab="' + handle_type + '"]').addClass('activated');
                /* enable publisher button */
                button_status(publisher_button, "reset");
              } else if (handle == "comment") {
                /* comment */
                var comment = _this.parents('.comment');
                /* add the attachment to comment data */
                comment.data(handle_type, response.file);
                /* hide comment x-form-tools */
                comment.find('.x-form-tools-attach').hide();
                comment.find('.x-form-tools-voice').hide();
              } else if (handle == "chat") {
                /* chat */
                var chat_widget = _this.parents('.chat-widget, .panel-messages');
                /* add the attachment to chat widget data */
                chat_widget.data(handle_type, response.file);
                /* hide chat widget x-form-tools */
                chat_widget.find('.x-form-tools-attach').hide();
                chat_widget.find('.x-form-tools-voice').hide();
              }
            }
          },
          error: function () {
            modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
          }
        });
      };
      /* set recorder options */
      voice_recording_object.setOptions({
        timeLimit: voice_recording_limit,
        encodeAfterRecord: true,
        bufferSize: 1024
      });
      /* start the recording process */
      voice_recording_object.startRecording();
      /* start recording timer */
      voice_recording_timer.start();
      /* update voice recording process */
      voice_recording_process = true;
      /* check the handle */
      if (handle == "publisher") {
        var publisher = _this.parents('.publisher');
        var publisher_button = publisher.find('.js_publisher-btn');
        /* disable publisher button */
        button_status(publisher_button, "loading");
      } else if (handle == "comment") {
        var comment = _this.parents('.comment');
        /* hide comment x-form-tools */
        comment.find('.x-form-tools-attach').hide();
        comment.find('.x-form-tools-voice').hide();
      } else if (handle == "chat") {
        var chat_widget = _this.parents('.chat-widget, .panel-messages');
        /* hide chat widget x-form-tools */
        chat_widget.find('.x-form-tools-attach').hide();
        chat_widget.find('.x-form-tools-voice').hide();
      }
    }).catch(function (err) {
      modal('#modal-message', { title: __['Error'], message: err });
    });
  });
  /* remove voice record */
  $('body').on('click', '.js_voice-remove', function () {
    var _this = $(this);
    var _parent = _this.parents(".voice-recording-wrapper");
    var voice_start_button = _parent.find('.js_voice-start');
    var voice_success_message = _parent.find('.js_voice-success-message');
    var handle = _parent.data("handle");
    var handle_type = "voice_notes";
    /* hide voice success message */
    voice_success_message.hide();
    /* show voice start button */
    voice_start_button.show();
    /* check the handle */
    if (handle == "publisher") {
      /* publisher */
      var publisher = _this.parents('.publisher');
      /* remove the uploads from publisher data */
      publisher.removeData(handle_type);
      publisher_tab(publisher, handle_type);
      publisher.find('.js_publisher-tab[data-tab="' + handle_type + '"]').removeClass('activated');
    } else if (handle == "comment") {
      /* comment */
      var comment = _this.parents('.comment');
      /* remove the uploads from comment data */
      comment.removeData(handle_type);
      /* show comment x-form-tools */
      comment.find('.x-form-tools-attach').show();
      comment.find('.x-form-tools-voice').show();
    } else if (handle == "chat") {
      /* chat */
      var chat_widget = _this.parents('.chat-widget, .panel-messages');
      /* remove the uploads from chat data */
      chat_widget.removeData(handle_type);
      /* show chat widget x-form-tools */
      chat_widget.find('.x-form-tools-attach').show();
      chat_widget.find('.x-form-tools-voice').show();
    }
  });
  $('body').on('click', '.js_comment-voice-notes-toggle', function () {
    var comment = $(this).closest(".comment");
    comment.find('.comment-voice-notes').slideToggle();
  });
  $('body').on('click', '.js_chat-voice-notes-toggle', function () {
    var chat_widget = $(this).parents('.chat-widget, .panel-messages');
    chat_widget.find('.chat-voice-notes').slideToggle();
  });


  // run posts filter
  $('body').on('click', '.js_posts-filter .dropdown-item', function () {
    var posts_stream = $('.js_posts_stream');
    var posts_loader = $('.js_posts_loader');
    var data = {};
    data['get'] = posts_stream.data('get');
    data['filter'] = $(this).data('value');
    if (posts_stream.data('id') !== undefined) {
      data['id'] = posts_stream.data('id');
    }
    posts_stream.data('loading', true);
    posts_stream.data('filter', data['filter']);
    posts_stream.html('');
    posts_loader.show();
    /* get filtered posts */
    $.post(api['posts/filter'], data, function (response) {
      if (response.callback) {
        eval(response.callback);
      } else {
        if (response.posts) {
          posts_loader.hide();
          posts_stream.removeData('loading');
          posts_stream.html(response.posts);
          setTimeout(ui_rebuild(), 200);
        }
      }
    }, 'json');
  });


  // run posts stream
  $('body').on('click', '.js_lightbox-live', function () {
    /* initialize vars */
    var _this = $(this);
    var live_post_id = _this.parents('.post').data('id');

    /* load lightbox */
    var lightbox = $(render_template("#lightbox-live", { 'post_id': live_post_id }));
    $('body').addClass('lightbox-open').append(lightbox.fadeIn('fast'));

    /* get live post */
    $.post(api['live/reaction'], { 'do': 'join', 'post_id': live_post_id }, async function (response) {
      /* check the response */
      if (response.callback) {
        $('body').removeClass('lightbox-open');
        $('.lightbox').remove();
        eval(response.callback);
      } else {
        lightbox.find('.lightbox-post').replaceWith(response.lightbox);
        if (response.live_ended) {
          /* show live status */
          $('#js_live-status').html('<i class="fas fa-exclamation-circle mr5"></i>' + __['Live Ended']).addClass("error");
        } else {
          /* init agora client */
          await join(response.agora_channel_name, response.agora_audience_token, response.agora_audience_uid);
        }
      }
    }, 'json');
  });


  // run emoji
  /* toggle(close|open) emoji-menu */
  $('body').on('click', '.js_emoji-menu-toggle', function () {
    if ($(this).parent().find('.emoji-menu').length == 0) {
      $(this).after(render_template("#emoji-menu", { 'id': guid() }));
      initialize();
    }
    $(this).parent().find('.emoji-menu').toggle();
    $('.tab-emojis .js_scroller').each(function () {
      var emojisScrollEl = $(this);
      if (!emojisScrollEl.hasClass('lazy-load-initialized')) {
        emojisScrollEl.addClass('lazy-load-initialized').on('scroll', function () {
          setTimeout(function () {
            if (emojisScrollEl.scrollTop() + 250 > emojisScrollEl[0].scrollHeight) {
              $('.item[js-hidden]', emojisScrollEl).slice(0, 50).removeAttr('js-hidden').show();
            }
          }, 200);
        });
      }
    });
  });
  /* close emoji-menu when clicked outside */
  $('body').on('click', function (e) {
    if ($(e.target).hasClass('js_emoji-menu-toggle') || $(e.target).parents('.js_emoji-menu-toggle').length > 0 || $(e.target).hasClass('emoji-menu') || $(e.target).parents('.emoji-menu').length > 0) {
      return;
    }
    $('.emoji-menu').hide();
  });
  /* add an emoji */
  $('body').on('click', '.js_emoji', function () {
    var emoji = $(this).data('emoji');
    var textarea = $(this).parents('.x-form').find('textarea');
    var cursorPosition = textarea.prop('selectionStart');
    var textBeforeCursor = textarea.val().substring(0, cursorPosition);
    var textAfterCursor = textarea.val().substring(cursorPosition);
    /* check if we need a space before or after */
    var spaceBefore = textBeforeCursor.length > 0 && !textBeforeCursor.endsWith(' ') ? ' ' : '';
    var spaceAfter = textAfterCursor.length > 0 && !textAfterCursor.startsWith(' ') ? ' ' : '';
    /* insert the emoji with optional spaces */
    var emojiWithSpaces = spaceBefore + emoji + spaceAfter;
    textarea.val(textBeforeCursor + emojiWithSpaces + textAfterCursor);
    /* set the cursor position after the inserted emoji */
    var newCursorPosition = cursorPosition + emojiWithSpaces.length;
    textarea.prop('selectionStart', newCursorPosition);
    textarea.prop('selectionEnd', newCursorPosition);
    /* focus the textarea and hide the emoji menu */
    textarea.trigger('focus');
    $(this).parents('.emoji-menu').hide();
  });


  // handle post
  /* edit post */
  $('body').on('click', '.js_edit-post', function () {
    var post = $(this).parents('.post');
    if (post.find('.post-edit').length > 0) {
      return;
    }
    post.find('.post-replace').hide().after(render_template("#edit-post", { 'text': post.find('.post-text-plain').text() }));
    autosize(post.find('.post-edit textarea'));
  });
  /* unedit post */
  $('body').on('click', '.js_unedit-post', function () {
    var post = $(this).parents('.post');
    post.find('.post-edit').remove();
    post.find('.post-replace').show();
  });
  $('body').on('click', '.js_update-post', function () {
    var _this = $(this);
    var post = _this.parents('.post');
    var id = post.data('id');
    var textarea = post.find('textarea.js_update-post-textarea');
    var message = textarea.val();
    /* check if message is empty */
    if (is_empty(message)) {
      return;
    }
    /* button loading */
    button_status(_this, "loading");
    $.post(api['posts/edit'], { 'handle': 'post', 'id': id, 'message': message }, function (response) {
      /* button reset */
      button_status(_this, "reset");
      /* check if there is a callback */
      if (response.callback) {
        eval(response.callback);
      } else {
        post.find('.post-edit').remove();
        post.find('.post-replace').replaceWith(response.post).show();
      }
    }, 'json')
      .fail(function () {
        modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
      });
  });
  /* edit privacy */
  $('body').on('click', '.js_edit-privacy', function () {
    var _this = $(this);
    var post = _this.parents('.post');
    var id = post.data('id');
    var privacy = _this.data('value');
    $.post(api['posts/edit'], { 'handle': 'privacy', 'id': id, 'privacy': privacy }, function (response) {
      /* check if there is a callback */
      if (response.callback) {
        eval(response.callback);
      }
    }, 'json')
      .fail(function () {
        modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
      });
  });
  /* delete post */
  $('body').on('click', '.js_delete-post', function (e) {
    e.preventDefault();
    var post = $(this).parents('.post');
    var id = post.data('id');
    confirm(__['Delete Post'], __['Are you sure you want to delete this post?'], function () {
      post.hide();
      $.post(api['posts/reaction'], { 'do': 'delete_post', 'id': id }, function (response) {
        /* check the response */
        $('#modal').modal('hide');
        if (response.refresh && (current_page == "profile" || current_page == "page" || current_page == "group" || current_page == "event")) {
          window.location.reload();
        } else if (response.callback) {
          eval(response.callback);
        } else {
          if (current_page == "post") {
            window.location = site_path;
          }
        }
      }, 'json')
        .fail(function () {
          modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
        });
    });
  });
  /* approve post */
  $('body').on('click', '.js_approve-post', function (e) {
    e.preventDefault();
    var _this = $(this);
    var post = _this.parents('.post');
    var id = post.data('id');
    /* button loading */
    button_status(_this, "loading");
    $.post(api['posts/reaction'], { 'do': 'approve_post', 'id': id }, function (response) {
      /* button reset */
      button_status(_this, "reset");
      /* check the response */
      if (response.callback) {
        eval(response.callback);
      } else {
        post.hide();
      }
    }, 'json')
      .fail(function () {
        /* button reset */
        button_status(_this, "reset");
        modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
      });
  });
  /* delete blog */
  $('body').on('click', '.js_delete-blog', function (e) {
    e.preventDefault();
    var id = $(this).data('id');
    confirm(__['Delete Post'], __['Are you sure you want to delete this post?'], function () {
      $.post(api['posts/reaction'], { 'do': 'delete_post', 'id': id }, function (response) {
        /* check the response */
        $('#modal').modal('hide');
        if (response.callback) {
          eval(response.callback);
        }
        window.location = site_path + "/blogs";
      }, 'json')
        .fail(function () {
          modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
        });
    });
  });
  /* sold post */
  $('body').on('click', '.js_sold-post', function () {
    var _this = $(this);
    var post = _this.parents('.post');
    var id = post.data('id');
    $.post(api['posts/reaction'], { 'do': 'sold_post', 'id': id }, function (response) {
      /* check the response */
      if (response.callback) {
        eval(response.callback);
      } else {
        _this.removeClass('js_sold-post').addClass('js_unsold-post').find('span').text(__['Mark as Available']);
      }
    }, 'json')
      .fail(function () {
        modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
      });
  });
  /* unsold post */
  $('body').on('click', '.js_unsold-post', function () {
    var _this = $(this);
    var post = _this.parents('.post');
    var id = post.data('id');
    $.post(api['posts/reaction'], { 'do': 'unsold_post', 'id': id }, function (response) {
      /* check the response */
      if (response.callback) {
        eval(response.callback);
      } else {
        _this.removeClass('js_unsold-post').addClass('js_sold-post').find('span').text(__['Mark as Sold']);
      }
    }, 'json')
      .fail(function () {
        modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
      });
  });
  /* closed post */
  $('body').on('click', '.js_closed-post', function () {
    var _this = $(this);
    var post = _this.parents('.post');
    var id = post.data('id');
    $.post(api['posts/reaction'], { 'do': 'closed_post', 'id': id }, function (response) {
      /* check the response */
      if (response.callback) {
        eval(response.callback);
      } else {
        _this.removeClass('js_sold-post').addClass('js_unclosed-post').find('span').text(__['Mark as Available']);
      }
    }, 'json')
      .fail(function () {
        modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
      });
  });
  /* unclosed job */
  $('body').on('click', '.js_unclosed-post', function () {
    var _this = $(this);
    var post = _this.parents('.post');
    var id = post.data('id');
    $.post(api['posts/reaction'], { 'do': 'unclosed_post', 'id': id }, function (response) {
      /* check the response */
      if (response.callback) {
        eval(response.callback);
      } else {
        _this.removeClass('js_unsold-post').addClass('js_closed-post').find('span').text(__['Mark as Closed']);
      }
    }, 'json')
      .fail(function () {
        modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
      });
  });
  /* save post */
  $('body').on('click', '.js_save-post', function () {
    var _this = $(this);
    var post = _this.parents('.post');
    var id = post.data('id');
    $.post(api['posts/reaction'], { 'do': 'save_post', 'id': id }, function (response) {
      /* check the response */
      if (response.callback) {
        eval(response.callback);
      } else {
        _this.removeClass('js_save-post').addClass('js_unsave-post').find('span').text(__['Unsave Post']);
      }
    }, 'json')
      .fail(function () {
        modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
      });
  });
  /* unsave post */
  $('body').on('click', '.js_unsave-post', function () {
    var _this = $(this);
    var post = _this.parents('.post');
    var id = post.data('id');
    $.post(api['posts/reaction'], { 'do': 'unsave_post', 'id': id }, function (response) {
      /* check the response */
      if (response.callback) {
        eval(response.callback);
      } else {
        _this.removeClass('js_unsave-post').addClass('js_save-post').find('span').text(__['Save Post']);
      }
    }, 'json')
      .fail(function () {
        modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
      });
  });
  /* boost post */
  $('body').on('click', '.js_boost-post', function () {
    var _this = $(this);
    var post = _this.parents('.post');
    var id = post.data('id');
    $.post(api['posts/reaction'], { 'do': 'boost_post', 'id': id }, function (response) {
      /* check the response */
      if (response.callback) {
        eval(response.callback);
      } else {
        _this.removeClass('js_boost-post').addClass('js_unboost-post').find('span').text(__['Unboost Post']);
      }
    }, 'json')
      .fail(function () {
        modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
      });
  });
  /* unboost post */
  $('body').on('click', '.js_unboost-post', function () {
    var _this = $(this);
    var post = _this.parents('.post');
    var id = post.data('id');
    $.post(api['posts/reaction'], { 'do': 'unboost_post', 'id': id }, function (response) {
      /* check the response */
      if (response.callback) {
        eval(response.callback);
      } else {
        _this.removeClass('js_unboost-post').addClass('js_boost-post').find('span').text(__['Boost Post']);
      }
    }, 'json')
      .fail(function () {
        modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
      });
  });
  /* pin post */
  $('body').on('click', '.js_pin-post', function () {
    var _this = $(this);
    var post = _this.parents('.post');
    var id = post.data('id');
    $.post(api['posts/reaction'], { 'do': 'pin_post', 'id': id }, function (response) {
      /* check the response */
      if (response.callback) {
        eval(response.callback);
      } else {
        _this.removeClass('js_pin-post').addClass('js_unpin-post').find('span').text(__['Unpin Post']);
      }
    }, 'json')
      .fail(function () {
        modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
      });
  });
  /* unpin post */
  $('body').on('click', '.js_unpin-post', function () {
    var _this = $(this);
    var post = _this.parents('.post');
    var id = post.data('id');
    $.post(api['posts/reaction'], { 'do': 'unpin_post', 'id': id }, function (response) {
      /* check the response */
      if (response.callback) {
        eval(response.callback);
      } else {
        _this.removeClass('js_unpin-post').addClass('js_pin-post').find('span').text(__['Pin Post']);
      }
    }, 'json')
      .fail(function () {
        modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
      });
  });
  /* monetize post */
  $('body').on('click', '.js_monetize-post', function () {
    var _this = $(this);
    var post = _this.parents('.post');
    var id = post.data('id');
    $.post(api['posts/reaction'], { 'do': 'monetize_post', 'id': id }, function (response) {
      /* check the response */
      if (response.callback) {
        eval(response.callback);
      } else {
        _this.removeClass('js_monetize-post').addClass('js_unmonetize-post').find('span').text(__['For Everyone']);
      }
    }, "json")
      .fail(function () {
        modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });;
      });
  });
  /* unmonetize post */
  $('body').on('click', '.js_unmonetize-post', function () {
    var _this = $(this);
    var post = _this.parents('.post');
    var id = post.data('id');
    $.post(api['posts/reaction'], { 'do': 'unmonetize_post', 'id': id }, function (response) {
      /* check the response */
      if (response.callback) {
        eval(response.callback);
      } else {
        _this.removeClass('js_unmonetize-post').addClass('js_monetize-post').find('span').text(__['For Subscribers Only']);
      }
    }, "json")
      .fail(function () {
        modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });;
      });
  });
  /* hide post */
  $('body').on('click', '.js_hide-post', function () {
    var post = $(this).parents('.post');
    var id = post.data('id');
    $.post(api['posts/reaction'], { 'do': 'hide_post', 'id': id }, function (response) {
      /* check the response */
      if (response.callback) {
        eval(response.callback);
      } else {
        post.hide();
        post.after(render_template("#hidden-post", { 'id': id }));
      }
    }, 'json')
      .fail(function () {
        modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
      });
  });
  /* unhide post */
  $('body').on('click', '.js_unhide-post', function () {
    var post = $(this).parents('.post');
    var id = post.data('id');
    $.post(api['posts/reaction'], { 'do': 'unhide_post', 'id': id }, function (response) {
      /* check the response */
      if (response.callback) {
        eval(response.callback);
      } else {
        post.prev().show();
        post.remove();
      }
    }, 'json')
      .fail(function () {
        modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
      });
  });
  /* hide author */
  $('body').on('click', '.js_hide-author', function () {
    var post = $(this).parents('.post');
    var author_id = $(this).data('author-id');
    var author_name = $(this).data('author-name');
    var id = post.data('id');
    $.post(api['users/connect'], { 'do': 'unfollow', 'id': author_id }, function (response) {
      if (response.callback) {
        eval(response.callback);
      } else {
        post.hide();
        post.after(render_template("#hidden-author", { 'id': id, 'name': author_name, 'uid': author_id }));
      }
    }, "json")
      .fail(function () {
        modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
      });
  });
  /* unhide author */
  $('body').on('click', '.js_unhide-author', function () {
    var post = $(this).parents('.post');
    var author_id = $(this).data('author-id');
    var author_name = $(this).data('author-name');
    var id = post.data('id');
    $.post(api['users/connect'], { 'do': 'follow', 'id': author_id }, function (response) {
      if (response.callback) {
        eval(response.callback);
      } else {
        post.prev().show();
        post.remove();
      }
    }, "json")
      .fail(function () {
        modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
      });
  });
  /* disable comments */
  $('body').on('click', '.js_disable-post-comments', function () {
    var _this = $(this);
    var post = _this.parents('.post');
    var comment_form = post.find('.comment:last');
    var id = post.data('id');
    _this.removeClass('js_disable-post-comments').addClass('js_enable-post-comments').find('span').text(__['Turn on Commenting']);
    post.find('.js_comment, .js_reply, .js_reply-form').hide();
    post.find('.js_comment-form').hide();
    post.find('.js_comment-disabled-msg').show();
    $.post(api['posts/reaction'], { 'do': 'disable_comments', 'id': id }, function (response) {
      /* check the response */
      if (response.callback) {
        eval(response.callback);
      }
    }, 'json')
      .fail(function () {
        modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
      });
  });
  /* enable comments */
  $('body').on('click', '.js_enable-post-comments', function () {
    var _this = $(this);
    var post = _this.parents('.post');
    var comment_form = post.find('.comment:last');
    var id = post.data('id');
    _this.removeClass('js_enable-post-comments').addClass('js_disable-post-comments').find('span').text(__['Turn off Commenting']);
    post.find('.js_comment, .js_reply').show();
    post.find('.js_comment-form').show();
    post.find('.js_comment-disabled-msg').hide();
    $.post(api['posts/reaction'], { 'do': 'enable_comments', 'id': id }, function (response) {
      /* check the response */
      if (response.callback) {
        eval(response.callback);
      }
    }, 'json')
      .fail(function () {
        modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
      });
  });
  /* disallow post */
  $('body').on('click', '.js_disallow-post', function () {
    var _this = $(this);
    var post = $(this).parents('.post');
    var id = post.data('id');
    confirm(__['Hide from Timeline'], __['Are you sure you want to hide this post from your profile timeline? It may still appear in other places like newsfeed and search results'], function () {
      $.post(api['posts/reaction'], { 'do': 'disallow_post', 'id': id }, function (response) {
        /* check the response */
        $('#modal').modal('hide');
        /* check the response */
        if (response.callback) {
          eval(response.callback);
        } else {
          post.addClass('is_hidden');
          _this.removeClass('js_disallow-post').addClass('js_allow-post').find('span').text(__['Allow on Timeline']);
        }
      }, 'json')
        .fail(function () {
          modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
        });
    });
  });
  /* allow post */
  $('body').on('click', '.js_allow-post', function () {
    var _this = $(this);
    var post = _this.parents('.post');
    var id = post.data('id');
    $.post(api['posts/reaction'], { 'do': 'allow_post', 'id': id }, function (response) {
      /* check the response */
      if (response.callback) {
        eval(response.callback);
      } else {
        post.removeClass('is_hidden');
        _this.removeClass('js_allow-post').addClass('js_disallow-post').find('span').text(__['Hide from Timeline']);
      }
    }, 'json')
      .fail(function () {
        modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
      });
  });
  /* show shared post attachments */
  $('body').on('click', '.js_show-attachments', function () {
    $(this).next().toggle();
  });
  /* poll vote */
  $('body').on('click', '.js_poll-vote', function (event) {
    if ($(event.target).is('input[type="radio"]')) {
      return false;
    }
    var _this = $(this);
    var id = _this.data('id');
    var radio = _this.find('input[type="radio"]');
    var parent = _this.parents('.poll-options');
    var poll_votes = parent.data('poll-votes');
    var checked_id = parent.find('input[type="radio"]:checked').parents('.poll-option').data('id');
    if (checked_id === undefined) {
      var _do = "add_vote";
    } else if (checked_id == id) {
      var _do = "delete_vote";
    } else {
      var _do = "change_vote";
    }
    if (_do == "add_vote") {
      /* update poll votes */
      poll_votes = poll_votes + 1;
      parent.data('poll-votes', poll_votes);
      /* update all option */
      parent.find('.poll-option').each(function () {
        var option_votes = $(this).data('option-votes');
        /* update option votes */
        if ($(this).data('id') == id) {
          option_votes = option_votes + 1;
          $(this).data('option-votes', option_votes);
        }
        var width = (option_votes / poll_votes) * 100;
        $(this).find('.percentage-bg').width(width + '%');
        $(this).next('.poll-voters').find('.more').html(option_votes);
      });
      /* uncheck all inputs */
      parent.find('input[type="radio"]').removeAttr("checked").prop("checked", false);
      /* check the active radio */
      radio.attr("checked", "checked").prop("checked", true);

    } else if (_do == "delete_vote") {
      /* update poll votes */
      poll_votes = poll_votes - 1;
      parent.data('poll-votes', poll_votes);
      /* update all option */
      parent.find('.poll-option').each(function () {
        var option_votes = $(this).data('option-votes');
        /* update option votes */
        if ($(this).data('id') == id) {
          option_votes = option_votes - 1;
          $(this).data('option-votes', option_votes);
        }
        var width = (poll_votes == 0) ? 0 : (option_votes / poll_votes) * 100;
        $(this).find('.percentage-bg').width(width + '%');
        $(this).next('.poll-voters').find('.more').html(option_votes);
      });
      /* uncheck all inputs */
      parent.find('input[type="radio"]').removeAttr("checked").prop("checked", false);

    } else {
      /* update poll votes */
      poll_votes = poll_votes;
      /* update all option */
      parent.find('.poll-option').each(function () {
        var option_votes = $(this).data('option-votes');
        /* update option votes */
        if ($(this).data('id') == id) {
          option_votes = option_votes + 1;
          $(this).data('option-votes', option_votes);
        }
        if ($(this).data('id') == checked_id) {
          option_votes = option_votes - 1;
          $(this).data('option-votes', option_votes);
        }
        var width = (option_votes / poll_votes) * 100;
        $(this).find('.percentage-bg').width(width + '%');
        $(this).next('.poll-voters').find('.more').html(option_votes);
      });
      /* uncheck all inputs */
      parent.find('input[type="radio"]').removeAttr("checked").prop("checked", false);
      /* check the active radio */
      radio.attr("checked", "checked").prop("checked", true);
    }
    $.post(api['posts/reaction'], { 'do': _do, 'id': id, 'checked_id': checked_id }, function (response) {
      /* check the response */
      if (response.callback) {
        eval(response.callback);
      }
    }, 'json')
      .fail(function () {
        modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
      });
  });
  $('body').on('mouseup', '.js_poll-vote input', function (event) {
    event.stopPropagation();
    event.preventDefault();
    $(this).parents('.js_poll-vote').trigger('click');
    return false;
  });


  // handle comment
  /* comments toggle */
  $('body').on('click', '.js_comments-toggle', function () {
    $(this).parents('.post, .lightbox-post').find('.post-footer').toggle();
  });
  /* show comment form */
  $('body').on('click', '.js_comment', function () {
    var footer = $(this).parents('.post, .lightbox-post, .blog').find('.post-footer');
    footer.show();
    footer.find('.post-comments').show();
    footer.find('textarea.js_post-comment').trigger('focus');
  });
  /* comment attachment remover */
  $('body').on('click', '.js_comment-attachment-remover', function () {
    var comment = $(this).parents('.comment');
    var attachments = comment.find('.comment-attachments');
    var item = $(this).parents('li.item');
    /* remove the attachment from comment data */
    comment.removeData('photos');
    /* remove the attachment item */
    item.remove();
    /* hide attachments */
    attachments.hide();
    /* show comment form tools */
    comment.find('.x-form-tools-attach').show();
    comment.find('.x-form-tools-voice').show();
  });
  /* post comment */
  function _comment(element) {
    var _this = $(element);
    var comment = _this.parents('.comment');
    var stream = _this.parents('.post-comments').find('.js_comments');
    var handle = comment.data('handle');
    var id = comment.data('id');
    var textarea = comment.find('textarea.js_post-comment');
    var message = textarea.val();
    var attachments = comment.find('.comment-attachments');
    var attachments_voice_notes = comment.find('.comment-voice-notes');
    /* check if there is current (sending) process */
    if (comment.data('sending')) {
      return false;
    }
    /* check if there is filtering process */
    if (stream.data('filtering')) {
      return false;
    }
    /* get photo from comment data */
    var photo = comment.data('photos');
    /* get voice note from comment data */
    var voice_note = comment.data('voice_notes');
    /* check if message is empty */
    if (is_empty(message) && !photo && !voice_note) {
      return;
    }
    /* add currenet sending process */
    comment.data('sending', true);
    $.post(api['posts/comment'], { 'handle': handle, 'id': id, 'message': message, 'photo': JSON.stringify(photo), 'voice_note': JSON.stringify(voice_note) }, function (response) {
      /* check if there is a callback */
      if (response.callback) {
        eval(response.callback);
      } else {
        textarea.val('');
        textarea.attr('style', '');
        attachments.hide();
        attachments.find('li.item').remove();
        comment.removeData('photos');
        comment.find('.x-form-tools-attach').show();
        comment.removeData('voice_notes');
        comment.find('.x-form-tools-voice').show();
        attachments_voice_notes.hide();
        attachments_voice_notes.find(".js_voice-success-message").hide();
        attachments_voice_notes.find('.js_voice-start').show();
        if (!stream.hasClass("js_live-comments")) {
          stream.prepend(response.comment);
        }
        /* remove currenet sending process */
        comment.removeData('sending');
      }
    }, 'json')
      .fail(function () {
        modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
      });
  }
  $('body').on('keydown', 'textarea.js_post-comment', function (event) {
    if ($(window).width() >= 970 && (event.keyCode == 13 && event.shiftKey == 0)) {
      event.preventDefault();
      _comment(this);
    }
  });
  $('body').on('click', 'li.js_post-comment', function () {
    if ($(window).width() < 970) {
      _comment(this);
    }
  });
  /* replies toggle */
  $('body').on('click', '.js_replies-toggle', function () {
    $(this).parents('.comment').find('.comment-replies').show();
    $(this).remove();
  });
  /* show reply form */
  $('body').on('click', '.js_reply', function () {
    var comment = $(this).parents('.comment');
    var form = comment.find('.js_reply-form');
    var textarea = form.find('textarea:first');
    var username = $(this).data('username') || "";
    comment.find('.js_replies-toggle').remove();
    comment.find('.comment-replies').show();
    form.show();
    (username == "") ? textarea.val('') : textarea.val('[' + username + '] ');
    textarea.trigger('focus');
  });
  /* post reply */
  function _reply(element) {
    var _this = $(element);
    var comment = _this.parents('.comment');
    var stream = comment.find('.js_replies');
    var handle = 'comment';
    var id = comment.data('id');
    var textarea = comment.find('textarea.js_post-reply');
    var message = textarea.val();
    var attachments = comment.find('.comment-attachments');
    var attachments_voice_notes = comment.find('.comment-voice-notes');
    /* get photo from comment data */
    var photo = comment.data('photos');
    /* get voice note from comment data */
    var voice_note = comment.data('voice_notes');
    /* check if message is empty */
    if (is_empty(message) && !photo && !voice_note) {
      return;
    }
    $.post(api['posts/comment'], { 'handle': handle, 'id': id, 'message': message, 'photo': JSON.stringify(photo), 'voice_note': JSON.stringify(voice_note) }, function (response) {
      /* check if there is a callback */
      if (response.callback) {
        eval(response.callback);
      } else {
        textarea.val('');
        textarea.attr('style', '');
        attachments.hide();
        attachments.find('li.item').remove();
        comment.removeData('photos');
        comment.find('.x-form-tools-attach').show();
        comment.removeData('voice_notes');
        comment.find('.x-form-tools-voice').show();
        attachments_voice_notes.hide();
        attachments_voice_notes.find(".js_voice-success-message").hide();
        attachments_voice_notes.find('.js_voice-start').show();
        stream.append(response.comment);
      }
    }, 'json')
      .fail(function () {
        modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
      });
  }
  $('body').on('keydown', 'textarea.js_post-reply', function (event) {
    if ($(window).width() >= 970 && (event.keyCode == 13 && event.shiftKey == 0)) {
      event.preventDefault();
      _reply(this);
    }
  });
  $('body').on('click', 'li.js_post-reply', function () {
    if ($(window).width() < 970) {
      _reply(this);
    }
  });
  /* delete comment */
  $('body').on('click', '.js_delete-comment', function (e) {
    e.preventDefault();
    var comment = $(this).closest('.comment');
    var id = comment.data('id');
    confirm(__['Delete Comment'], __['Are you sure you want to delete this comment?'], function () {
      comment.hide();
      $.post(api['posts/reaction'], { 'do': 'delete_comment', 'id': id }, function (response) {
        /* check the response */
        if (response.callback) {
          eval(response.callback);
        } else {
          $('#modal').modal('hide');
        }
      }, 'json')
        .fail(function () {
          modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
        });
    });
  });
  /* edit comment */
  $('body').on('click', '.js_edit-comment', function (e) {
    e.preventDefault();
    var comment = $(this).closest('.comment');
    comment.find('.comment-data:first').hide().after(render_template("#edit-comment", { 'text': comment.find('.comment-text-plain:first').text() }));
    autosize(comment.find('.comment-edit textarea'));
  });
  /* unedit comment */
  $('body').on('click', '.js_unedit-comment', function () {
    var comment = $(this).closest('.comment');
    comment.find('.comment-edit').remove();
    comment.find('.comment-data').show();
  });
  /* update comment */
  $('body').on('click', '.js_update-comment', function (event) {
    var _this = $(this);
    var comment = _this.closest('.comment');
    var id = comment.data('id');
    var textarea = comment.find('textarea.js_update-comment-textarea');
    var message = textarea.val();
    var photo = comment.data('photos');
    /* check if message is empty */
    if (is_empty(message) && !photo) {
      return;
    }
    /* button loading */
    button_status(_this, "loading");
    $.post(api['posts/edit'], { 'handle': 'comment', 'id': id, 'message': message, 'photo': JSON.stringify(photo) }, function (response) {
      /* button reset */
      button_status(_this, "reset");
      /* check if there is a callback */
      if (response.callback) {
        eval(response.callback);
      } else {
        comment.find('.comment-edit:first').remove();
        comment.find('.comment-replace:first').html(response.comment);
        comment.find('.comment-data:first').show();
      }
    }, 'json')
      .fail(function () {
        modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
      });
  });


  // run comments filter
  $('body').on('click', '.js_comments-filter .dropdown-item', function () {
    var _this = $(this);
    var _parent = _this.parents('.post-comments');
    var comments_stream = _parent.find('.js_comments');
    var comments_loader = _parent.find('.js_comments-filter-loader');
    var comments_see_more = _parent.find('.js_see-more');
    var data = {};
    data['get'] = _this.data('value');
    data['id'] = _this.data('id');
    comments_see_more.data('get', data['get']);
    comments_see_more.removeData('offset');
    comments_stream.data('filtering', true);
    comments_stream.html('');
    comments_loader.show();
    comments_see_more.hide();
    /* get filtered comments */
    $.post(api['comments/filter'], data, function (response) {
      if (response.callback) {
        eval(response.callback);
      } else {
        comments_loader.hide();
        comments_see_more.show();
        comments_stream.removeData('filtering');
        comments_stream.html(response.comments);
      }
    }, 'json');
  });


  // handle reactions
  function _show_reactions(element) {
    var _this = $(element);
    var reactions = _this.find('.reactions-container');
    var is_reel = _this.parents('.reel-container').length;
    var offset = _this.offset();
    var reactions_height = ($(window).width() < 480) ? 144 : 48;
    var posY = (offset.top - $(window).scrollTop()) - reactions_height;
    var posX = offset.left - $(window).scrollLeft();
    if (is_reel || $('html').attr('dir') == "RTL") {
      var right = $(window).width() - posX - _this.width();
      reactions.css({ 'top': posY + 'px', 'right': right + 'px' });
    } else {
      reactions.css({ 'top': posY + 'px', 'left': posX + 'px' });
    }
    reactions.show();
  }
  function _hide_reactions(element) {
    var _this = $(element);
    var reactions = _this.find('.reactions-container:first');
    reactions.removeAttr('style').hide();
  }
  /* reactions toggle */
  $('body').on('mouseenter', '.reactions-wrapper', function () {
    if (current_page != 'reels' && !is_iPad() && $(window).width() >= 970) {
      /* desktop -> show the reactions */
      _show_reactions(this);
    }
  });
  $('body').on('mouseleave', '.reactions-wrapper', function () {
    if (current_page != 'reels' && !is_iPad() && $(window).width() >= 970) {
      /* desktop -> hide the reactions */
      _hide_reactions(this);
    }
  });
  $('body').on('click', '.reactions-wrapper', function () {
    if (current_page == 'reels' || is_iPad() || $(window).width() < 970) {
      /* mobile -> toggle the reactions */
      if ($(this).find('.reactions-container:first').is(":visible")) {
        /* hide the reactions */
        _hide_reactions(this);
      } else {
        /* hide any previous reactions */
        $('.reactions-container').removeAttr('style').hide();
        /* show the reactions */
        _show_reactions(this);
      }
    } else {
      /* desktop -> unreact */
      var _this = $(this);
      var old_reaction = _this.data('reaction');
      if (old_reaction) {
        if (_this.hasClass('js_unreact-post')) {
          var _undo = 'unreact_post';
          var handle = 'post';
          var _parent = _this.closest('.post, .lightbox-post, .blog');
        } else if (_this.hasClass('js_unreact-photo')) {
          var _undo = 'unreact_photo';
          var handle = 'photo';
          var _parent = _this.closest('.post, .lightbox-post');
        } else if (_this.hasClass('js_unreact-comment')) {
          var _undo = 'unreact_comment';
          var handle = 'comment';
          var _parent = _this.closest('.comment');
        }
        var id = _parent.data('id');
        var reactions_wrapper = _parent.find('.reactions-wrapper:first');
        /* remove unreact from reactions-wrapper */
        reactions_wrapper.removeClass('js_unreact-' + handle);
        /* remove reactions-wrapper data-reaction */
        reactions_wrapper.data('reaction', '');
        /* change reaction-btn-name */
        _parent.find('.reaction-btn-name:first').text(__['React']).removeAttr('style');
        /* change reaction-btn-icon */
        _parent.find('.reaction-btn-icon:first').html('<i class="far fa-smile fa-lg fa-fw"></i>');
        /* hide reactions-container */
        _parent.find('.reactions-container:visible').removeAttr('style').hide();
        /* AJAX */
        $.post(api['posts/reaction'], { 'do': _undo, 'reaction': old_reaction, 'id': id }, function (response) {
          /* check the response */
          if (response.callback) {
            eval(response.callback);
          }
        }, 'json')
          .fail(function () {
            modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
          });
      }
    }
  });
  /* close reactions when clicked outside */
  $('body').on('click', function (e) {
    if ($(e.target).hasClass('reactions-wrapper') || $(e.target).parents('.reactions-wrapper').length > 0) {
      return;
    }
    $('.reactions-container').removeAttr('style').hide();
  });
  /* close reactions when user scroll (vertical) */
  var prevTop = 0;
  $(window).on('scroll', function (e) {
    var currentTop = $(this).scrollTop();
    if (prevTop !== currentTop) {
      prevTop = currentTop;
      $('.reactions-container').removeAttr('style').hide();
    }
  });
  /* react post & photo & comment */
  $('body').on('click', '.js_react-post, .js_react-photo, .js_react-comment', function (e) {
    e.stopPropagation();
    var _this = $(this);
    var reaction = _this.data('reaction');
    var reaction_color = _this.data('reaction-color');
    var reaction_title = _this.data('title');
    var reaction_html = _this.html();
    if (_this.hasClass('js_react-post')) {
      var _do = 'react_post';
      var _undo = 'unreact_post';
      var handle = 'post';
      var _parent = _this.closest('.post, .lightbox-post, .blog, .reel-container');
    } else if (_this.hasClass('js_react-photo')) {
      var _do = 'react_photo';
      var _undo = 'unreact_photo';
      var handle = 'photo';
      var _parent = _this.closest('.post, .lightbox-post');
    } else if (_this.hasClass('js_react-comment')) {
      var _do = 'react_comment';
      var _undo = 'unreact_comment';
      var handle = 'comment';
      var _parent = _this.closest('.comment');
    }
    var id = _parent.data('id');
    var reactions_wrapper = _parent.find('.reactions-wrapper:first');
    var old_reaction = reactions_wrapper.data('reaction');
    /* check if user react or unreact */
    if (reactions_wrapper.hasClass('js_unreact-' + handle) && old_reaction == reaction) {
      /* [1] user unreact */
      /* remove unreact class from reactions-wrapper */
      reactions_wrapper.removeClass('js_unreact-' + handle);
      /* remove reactions-wrapper data-reaction */
      reactions_wrapper.data('reaction', '');
      /* change reaction-btn-name */
      _parent.find('.reaction-btn-name:first').text(__['React']).removeClass('blue red yellow orange');
      /* change reaction-btn-icon */
      _parent.find('.reaction-btn-icon:first').html('<i class="far fa-smile fa-lg fa-fw"></i>');
      /* hide reactions-container */
      _parent.find('.reactions-container:visible').removeAttr('style').hide();
      /* AJAX */
      $.post(api['posts/reaction'], { 'do': _undo, 'reaction': old_reaction, 'id': id }, function (response) {
        /* check the response */
        if (response.callback) {
          eval(response.callback);
        }
      }, 'json')
        .fail(function () {
          modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
        });
    } else {
      /* [2] user react */
      /* add unreact class to reactions wrapper */
      if (!reactions_wrapper.hasClass('js_unreact-' + handle)) {
        reactions_wrapper.addClass('js_unreact-' + handle);
      }
      /* change reactions-wrapper data-reaction */
      reactions_wrapper.data('reaction', reaction);
      /* change reaction-btn-name */
      _parent.find('.reaction-btn-name:first').text(reaction_title).removeAttr('style').css("color", reaction_color);
      /* change reaction-btn-icon */
      _parent.find('.reaction-btn-icon:first').html('<div class="inline-emoji no_animation">' + reaction_html + '</div>');
      /* hide reactions-container */
      _parent.find('.reactions-container:visible').removeAttr('style').hide();
      /* AJAX */
      $.post(api['posts/reaction'], { 'do': _do, 'reaction': reaction, 'id': id }, function (response) {
        /* check the response */
        if (response.callback) {
          eval(response.callback);
        }
      }, 'json')
        .fail(function () {
          modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
        });
    }
  });


  // handle translator
  $('body').on('click', '.js_translator', function () {
    /* check if translator is enabled */
    if (!post_translation_enabled) {
      return;
    }
    var _this = $(this);
    var post = _this.closest('.post, .lightbox-post, .post-media');
    var text = post.find('.post-text:first').text();
    var to_lang = $('html').data('lang').substring(0, 2);
    /* check text */
    if (is_empty(text)) {
      _this.removeClass('text-link js_translator').text(__['Translated']);
      return;
    }
    /* decide which translation service to use based on the available key */
    if (typeof google_translation_key !== 'undefined' && google_translation_key) {
      /* use Google translate */
      $.ajax({
        url: `https://translation.googleapis.com/language/translate/v2`,
        type: 'POST',
        data: {
          key: google_translation_key,
          q: text,
          target: to_lang
        },
        success: function (response) {
          /* check if the target language is the same as the detected language */
          if (response.data.translations[0].detectedSourceLanguage === to_lang) {
            _this.removeClass('text-link js_translator').text(__['Translated']);
            return;
          }
          _this.removeClass('text-link js_translator').text(__['Translated']);
          post.find('.post-text-translation:first').text(response.data.translations[0].translatedText).show().addClass("x-notifier");
          setTimeout(function () {
            post.find('.post-text-translation:first').removeClass("x-notifier");
          }, 2500);
        },
        error: function () {
          modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
        }
      });
    } else if (typeof yandex_key !== 'undefined' && yandex_key) {
      /* use Yandex translate */
      $.get('https://translate.yandex.net/api/v1.5/tr.json/detect', { 'key': yandex_key, 'text': text }, function (response) {
        /* check if the target language is the same as the detected language */
        if (to_lang === response.lang) {
          _this.removeClass('text-link js_translator').text(__['Translated']);
          return;
        }
        $.getJSON('https://translate.yandex.net/api/v1.5/tr.json/translate', { 'key': yandex_key, 'text': text, 'lang': to_lang }, function (response) {
          _this.removeClass('text-link js_translator').text(__['Translated']);
          post.find('.post-text-translation:first').text(response.text).show().addClass("x-notifier");
          setTimeout(function () {
            post.find('.post-text-translation:first').removeClass("x-notifier");
          }, 2500);
        }).fail(function () {
          modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
        });
      }).fail(function () {
        modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
      });
    } else {
      modal('#modal-message', { title: __['Error'], message: __['Translation service not available!'] });
    }
  });
  $('body').on('click', '.js_chat-translator', function () {
    /* check if translator is enabled */
    if (!chat_translation_enabled) {
      return;
    }
    var _this = $(this);
    var text = _this.find('.text:first').text();
    var to_lang = $('html').data('lang').substring(0, 2);
    /* check text */
    if (is_empty(text)) {
      _this.removeClass('js_chat-translator');
      _this.find('.translate').remove();
      return;
    }
    /* decide which translation service to use based on the available key */
    if (typeof google_translation_key !== 'undefined' && google_translation_key) {
      /* use Google translate */
      $.ajax({
        url: `https://translation.googleapis.com/language/translate/v2`,
        type: 'POST',
        data: {
          key: google_translation_key,
          q: text,
          target: to_lang
        },
        success: function (response) {
          /* check if the target language is the same as the detected language */
          if (response.data.translations[0].detectedSourceLanguage === to_lang) {
            _this.removeClass('js_chat-translator');
            _this.find('.translate').remove();
            return;
          }
          _this.removeClass('js_chat-translator');
          _this.find('.translate').remove();
          _this.find('.text:first').text(response.data.translations[0].translatedText).addClass("x-notifier");
          setTimeout(function () {
            _this.find('.text:first').removeClass("x-notifier");
          }, 2500);
        },
        error: function () {
          modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
        }
      });
    } else if (typeof yandex_key !== 'undefined' && yandex_key) {
      /* use Yandex translate */
      $.get('https://translate.yandex.net/api/v1.5/tr.json/detect', { 'key': yandex_key, 'text': text }, function (response) {
        /* check if the target language is the same as the detected language */
        if (to_lang === response.lang) {
          _this.removeClass('js_chat-translator');
          _this.find('.translate').remove();
          return;
        }
        $.getJSON('https://translate.yandex.net/api/v1.5/tr.json/translate', { 'key': yandex_key, 'text': text, 'lang': to_lang }, function (response) {
          _this.removeClass('js_chat-translator');
          _this.find('.translate').remove();
          _this.find('.text:first').text(response.text).addClass("x-notifier");
          setTimeout(function () {
            _this.find('.text:first').removeClass("x-notifier");
          }, 2500);
        }).fail(function () {
          modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
        });
      }).fail(function () {
        modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
      });
    } else {
      modal('#modal-message', { title: __['Error'], message: __['Translation service not available!'] });
    }
  });


  // handle album
  /* delete album */
  $('body').on('click', '.js_delete-album', function () {
    var id = $(this).data('id');
    confirm(__['Delete'], __['Are you sure you want to delete this?'], function () {
      $.post(api['albums/action'], { 'do': 'delete_album', 'id': id }, function (response) {
        /* check the response */
        if (response.callback) {
          eval(response.callback);
        }
      }, 'json')
        .fail(function () {
          modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
        });
    });
  });
  /* delete photo */
  $('body').on('click', '.js_delete-photo', function (e) {
    e.stopPropagation();
    e.preventDefault();
    var _this = $(this);
    var id = $(this).data('id');
    confirm(__['Delete'], __['Are you sure you want to delete this?'], function () {
      $.post(api['albums/action'], { 'do': 'delete_photo', 'id': id }, function (response) {
        /* check the response */
        if (response.callback) {
          eval(response.callback);
        } else {
          /* remove photo */
          _this.parents('.pg_photo').parent().fadeOut(300, function () { $(this).remove(); });
          /* hide the confimation */
          $('#modal').modal('hide');
        }
      }, 'json')
        .fail(function () {
          modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
        });
    });
  });
  /* pin photo */
  $('body').on('click', '.js_pin-photo', function (e) {
    e.stopPropagation();
    e.preventDefault();
    var _this = $(this);
    var id = $(this).data('id');
    $.post(api['albums/action'], { 'do': 'pin_photo', 'id': id }, function (response) {
      /* check the response */
      if (response.callback) {
        eval(response.callback);
      } else {
        _this.removeClass('js_pin-photo').addClass('js_unpin-photo pinned');
      }
    }, 'json')
      .fail(function () {
        modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
      });
  });
  /* unpin photo */
  $('body').on('click', '.js_unpin-photo', function (e) {
    e.stopPropagation();
    e.preventDefault();
    var _this = $(this);
    var id = $(this).data('id');
    $.post(api['albums/action'], { 'do': 'unpin_photo', 'id': id }, function (response) {
      /* check the response */
      if (response.callback) {
        eval(response.callback);
      } else {
        _this.removeClass('js_unpin-photo pinned').addClass('js_pin-photo');
      }
    }, 'json')
      .fail(function () {
        modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
      });
  });


  // handle announcment
  /* hide */
  $('body').on('click', '.js_announcment-remover', function () {
    var announcment = $(this).parent();
    var id = $(this).data('id');
    confirm(__['Delete'], __['Are you sure you want to delete this?'], function () {
      /* remove the announcment */
      announcment.fadeOut();
      $.post(api['posts/reaction'], { 'do': 'hide_announcement', 'id': id }, function (response) {
        /* check the response */
        if (response.callback) {
          eval(response.callback);
        }
      }, 'json')
        .fail(function () {
          modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
        });
      /* hide the confimation */
      $('#modal').modal('hide');
    });
  });


  // handle daytime messages
  /* hide */
  $('body').on('click', '.js_daytime-remover', function () {
    var daytime_message = $(this).parents('.card');
    confirm(__['Delete'], __['Are you sure you want to delete this?'], function () {
      /* remove the daytime message */
      daytime_message.fadeOut();
      $.post(api['posts/reaction'], { 'do': 'hide_daytime_message', 'id': '1' }, function (response) {
        /* check the response */
        if (response.callback) {
          eval(response.callback);
        }
      }, 'json')
        .fail(function () {
          modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
        });
      /* hide the confimation */
      $('#modal').modal('hide');
    });
  });


  // handle forums
  /* forum toggle */
  $('body').on('click', '.js_forum-toggle', function () {
    $(this).parents('.forum-category').next('.js_forum-toggle-wrapper').slideToggle();
  });
  /* delete forum [thread|reply] */
  $('body').on('click', '.js_delete-forum', function () {
    var id = $(this).data('id');
    var handle = $(this).data('handle');
    confirm(__['Delete'], __['Are you sure you want to delete this?'], function () {
      $.post(api['forums/delete'], { 'id': id, 'handle': handle }, function (response) {
        /* check the response */
        if (response.callback) {
          eval(response.callback);
        }
      }, 'json')
        .fail(function () {
          modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
        });
    });
  });


  // handle keyboard shortcuts
  highlighted_post = 0;
  $('body').on('keypress', function (key) {
    var target = key.target.tagName.toLowerCase();
    var key_value = parseInt(key.which, 10);
    if (highlighted_post >= 0) {
      /* (J) next post */
      if (key_value == 106 && target != 'input' && target != 'textarea') {
        var post = $('.js_posts_stream .post').eq(highlighted_post);
        if (post.length) {
          post.addClass('highlighted');
          $('html, body').animate({
            scrollTop: parseInt(post.offset().top - 41)
          }, 600);
          setTimeout(function () {
            post.removeClass('highlighted');
          }, 500);
        }
        highlighted_post++;

        /* (K) prev post */
      } else if (key_value == 107 && target != 'input' && target != 'textarea') {
        if (highlighted_post == 0) return;
        highlighted_post--;
        var post = $('.js_posts_stream .post').eq(highlighted_post);
        if (post.length) {
          post.addClass('highlighted');
          $('html, body').animate({
            scrollTop: parseInt(post.offset().top - 41)
          }, 600);
          setTimeout(function () {
            post.removeClass('highlighted');
          }, 500);
        }
      }
    }
  });

});