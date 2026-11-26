/**
 * live js
 * 
 * @package Sngine
 * @author Zamblek
 */

// initialize live global vars
var live_post_id;
var live_realtime_thread;
var live_realtime_process = false;
var live_streaming_process = false;
var live_timer_thread;
var live_stats_pending = false;
var live_room = null;
var live_broadcast_type = "camera";
var live_rtmp_room = null;

// initialize live tracks vars
var localTracks = {
  videoTrack: null,
  audioTrack: null
};
var localTrackState = {
  videoTrackEnabled: true,
  audioTrackEnabled: true
}


// livekit play local video track
function livekit_play_video(track) {
  $(track.attach()).addClass('size-full object-cover').appendTo($('#js_live-video').empty());
}


async function show_camera_preview() {
  if (live_provider == "livekit") {
    localTracks.audioTrack = await LivekitClient.createLocalAudioTrack();
    localTracks.videoTrack = await LivekitClient.createLocalVideoTrack({ resolution: LivekitClient.VideoPresets.h720.resolution });
    livekit_play_video(localTracks.videoTrack);
    return;
  }
  /* create local audio and video tracks */
  localTracks.audioTrack = await AgoraRTC.createMicrophoneAudioTrack();
  localTracks.videoTrack = await AgoraRTC.createCameraVideoTrack({
    encoderConfig: "720p_3" // set the desired video profile (https://api-ref.agora.io/en/video-sdk/web/4.x/globals.html#videoencoderconfigurationpreset)
  });
  /* play local video track */
  localTracks.videoTrack.play("js_live-video");
}


// join
async function join() {
  if (live_provider == "livekit") {
    /* init livekit room */
    live_room = new LivekitClient.Room({ dynacast: true });
    await live_room.connect(livekit_live_ws_url, livekit_live_token);
    /* create local audio and video tracks */
    if (!localTracks.audioTrack && !localTracks.videoTrack) {
      await show_camera_preview();
    }
    /* publish local tracks to room (simulcast) */
    await live_room.localParticipant.publishTrack(localTracks.audioTrack);
    await live_room.localParticipant.publishTrack(localTracks.videoTrack, { simulcast: true });
    return;
  }
  /* init agora client */
  await agora_client.setClientRole("host");
  await agora_client.join(agora_app_id, agora_channel_name, agora_token, agora_uid);
  /* create local audio and video tracks */
  if (!localTracks.audioTrack && !localTracks.videoTrack) {
    localTracks.audioTrack = await AgoraRTC.createMicrophoneAudioTrack();
    localTracks.videoTrack = await AgoraRTC.createCameraVideoTrack({
      encoderConfig: "720p_3" // set the desired video profile (https://api-ref.agora.io/en/video-sdk/web/4.x/globals.html#videoencoderconfigurationpreset)
    });
    /* play local video track */
    localTracks.videoTrack.play("js_live-video");
  }
  /* publish local tracks to channel */
  await agora_client.publish(Object.values(localTracks));
  /* enable dual stream */
  agora_client.enableDualStream();
  /* set low stream parameter */
  agora_client.setLowStreamParameter({
    width: 640,
    height: 480,
    framerate: 15,
    bitrate: 140
  });
}


// leave
async function leave() {
  for (trackName in localTracks) {
    var track = localTracks[trackName];
    if (track) {
      track.stop();
      if (typeof track.close === "function") track.close();
      localTracks[trackName] = undefined;
    }
  }
  if (live_provider == "livekit") {
    /* leave the room */
    if (live_room) {
      await live_room.disconnect();
      live_room = null;
    }
    return;
  }
  /* leave the channel */
  await agora_client.leave();
}


// mute_audio
async function mute_audio() {
  if (!localTracks.audioTrack) return;
  if (live_provider == "livekit") {
    await localTracks.audioTrack.mute();
  } else {
    await localTracks.audioTrack.setEnabled(false);
  }
  localTrackState.audioTrackEnabled = false;
}


// unmute_audio
async function unmute_audio() {
  if (!localTracks.audioTrack) return;
  if (live_provider == "livekit") {
    await localTracks.audioTrack.unmute();
  } else {
    await localTracks.audioTrack.setEnabled(true);
  }
  localTrackState.audioTrackEnabled = true;
}


// mute_video
async function mute_video() {
  if (!localTracks.videoTrack) return;
  if (live_provider == "livekit") {
    await localTracks.videoTrack.mute();
  } else {
    await localTracks.videoTrack.setEnabled(false);
  }
  localTrackState.videoTrackEnabled = false;
}


// unmute_video
async function unmute_video() {
  if (!localTracks.videoTrack) return;
  if (live_provider == "livekit") {
    await localTracks.videoTrack.unmute();
  } else {
    await localTracks.videoTrack.setEnabled(true);
  }
  localTrackState.videoTrackEnabled = true;
}


// share screen
async function share_screen() {
  if (!localTracks.videoTrack) return;
  if (live_provider == "livekit") {
    /* create screen video track */
    var screenTracks = await LivekitClient.createLocalScreenTracks({ audio: false });
    /* replace camera video track with screen video track */
    await live_room.localParticipant.unpublishTrack(localTracks.videoTrack);
    localTracks.videoTrack = screenTracks[0];
    livekit_play_video(localTracks.videoTrack);
    await live_room.localParticipant.publishTrack(localTracks.videoTrack, { simulcast: true });
    return;
  }
  /* unpublish camera video track */
  await agora_client.unpublish(localTracks.videoTrack);
  /* stop camera video track */
  localTracks.videoTrack.stop();
  /* create screen video track */
  localTracks.videoTrack = await AgoraRTC.createScreenVideoTrack();
  /* play screen video track */
  localTracks.videoTrack.play("js_live-video");
  /* publish screen video track */
  await agora_client.publish(localTracks.videoTrack);
}


// unshare screen
async function unshare_screen() {
  if (!localTracks.videoTrack) return;
  if (live_provider == "livekit") {
    /* replace screen video track with camera video track */
    await live_room.localParticipant.unpublishTrack(localTracks.videoTrack);
    localTracks.videoTrack = await LivekitClient.createLocalVideoTrack({ resolution: LivekitClient.VideoPresets.h720.resolution });
    livekit_play_video(localTracks.videoTrack);
    await live_room.localParticipant.publishTrack(localTracks.videoTrack, { simulcast: true });
    return;
  }
  /* unpublish screen video track */
  await agora_client.unpublish(localTracks.videoTrack);
  /* stop screen video track */
  localTracks.videoTrack.stop();
  /* create camera video track */
  localTracks.videoTrack = await AgoraRTC.createCameraVideoTrack();
  /* play camera video track */
  localTracks.videoTrack.play("js_live-video");
  /* publish camera video track */
  await agora_client.publish(localTracks.videoTrack);
}


// switch camera
async function switch_camera(deviceId) {
  if (!localTracks.videoTrack) return;
  if (live_provider == "livekit") {
    await localTracks.videoTrack.restartTrack({ deviceId: deviceId });
    return;
  }
  /* create new camera video track with the selected deviceId */
  const newVideoTrack = await AgoraRTC.createCameraVideoTrack({ cameraId: deviceId });
  /* replace the current video track with the new one */
  if (live_streaming_process) {
    await agora_client.unpublish(localTracks.videoTrack);
  }
  localTracks.videoTrack.stop();
  localTracks.videoTrack.close();
  localTracks.videoTrack = newVideoTrack;
  if (live_streaming_process) {
    await agora_client.publish(newVideoTrack);
  }
  newVideoTrack.play("js_live-video");
}

// get cameras
async function getCameras() {
  if (live_provider == "livekit") {
    return await LivekitClient.Room.getLocalDevices('videoinput');
  }
  // const devices = await navigator.mediaDevices.enumerateDevices();
  const devices = await AgoraRTC.getDevices();
  return devices.filter(device => device.kind === 'videoinput');
}


// stop camera preview
function stop_camera_preview() {
  for (trackName in localTracks) {
    var track = localTracks[trackName];
    if (track) {
      track.stop();
      if (typeof track.close === "function") track.close();
      localTracks[trackName] = undefined;
    }
  }
  $('#js_live-video').empty();
}


// leave the live channel (keep the camera preview)
async function leave_channel() {
  if (live_provider == "livekit") {
    if (live_room) {
      await live_room.disconnect(false);
      live_room = null;
    }
    return;
  }
  await agora_client.leave();
}


// handle stream controls (camera|rtmp)
function handle_stream_controls() {
  var rtmp = (live_broadcast_type == "rtmp");
  $('#camera-select-toggle').closest('.dropdown').toggleClass('hidden', rtmp);
  $('#mic-btn, #cam-btn, #screen-btn').toggleClass('hidden', rtmp);
}


// rtmp status
function rtmp_status(status) {
  var status_html;
  switch (status) {
    case 'receiving':
      status_html = '<span class="icon-[tabler--circle-check] size-4 shrink-0 text-success"></span>' + __['Receiving your stream'];
      break;
    case 'ended':
      status_html = '<span class="icon-[tabler--info-circle] size-4 shrink-0"></span>' + __['Live ended, you can stop streaming from your streaming software now'];
      break;
    case 'error':
      status_html = '<span class="icon-[tabler--alert-circle] size-4 shrink-0 text-error"></span>' + __['Not able to connect, Try again later!'];
      break;
    default:
      status_html = '<span class="loading loading-spinner loading-xs shrink-0"></span>' + __['Waiting for your streaming software'];
      break;
  }
  $('#js_live-rtmp-status').html(status_html);
}


// rtmp connect (get the stream key & preview the stream)
function rtmp_connect(reset) {
  rtmp_status('waiting');
  $('#js_live-start').prop('disabled', true);
  rtmp_disconnect();
  $.post(api['live/reaction'], { 'do': (reset) ? 'rtmp_reset' : 'rtmp_prepare' }, async function (response) {
    if (response.callback) {
      rtmp_status('error');
      eval(response.callback);
      return;
    }
    if (live_broadcast_type != "rtmp") {
      return;
    }
    /* update the server url & stream key */
    $('#js_live-rtmp-url').val(response.rtmp.url).attr('title', response.rtmp.url);
    $('#js_live-rtmp-key').val(response.rtmp.stream_key);
    /* preview the stream */
    try {
      await load_livekit();
      live_rtmp_room = new LivekitClient.Room({ adaptiveStream: true });
      live_rtmp_room
        .on(LivekitClient.RoomEvent.TrackSubscribed, function (track, publication, participant) {
          if (!participant.identity.startsWith('host_rtmp_')) return;
          if (track.kind === LivekitClient.Track.Kind.Video) {
            $(track.attach()).prop('muted', true).addClass('size-full object-cover').appendTo($('#js_live-video').empty());
            rtmp_status('receiving');
            if (!live_streaming_process) {
              $('#js_live-start').prop('disabled', false);
            }
          }
        })
        .on(LivekitClient.RoomEvent.ParticipantDisconnected, function (participant) {
          if (!participant.identity.startsWith('host_rtmp_')) return;
          $('#js_live-video').empty();
          if (!live_streaming_process) {
            rtmp_status('waiting');
            $('#js_live-start').prop('disabled', true);
          }
        });
      await live_rtmp_room.connect(livekit_live_ws_url, response.rtmp.token);
    } catch (error) {
      rtmp_status('error');
    }
  }, 'json');
}


// rtmp disconnect
function rtmp_disconnect() {
  if (live_rtmp_room) {
    live_rtmp_room.disconnect();
    live_rtmp_room = null;
  }
  $('#js_live-video').empty();
}


// end live
function end_live_host(unloading) {
  if (!live_streaming_process) {
    return;
  }
  /* update live streaming process */
  live_streaming_process = false;
  /* leave the live channel */
  var left = null;
  if (live_broadcast_type == "rtmp") {
    rtmp_disconnect();
    rtmp_status('ended');
  } else {
    left = leave();
  }
  /* update live status */
  show_live_status();
  $('#js_live-status').html('<span class="icon-[tabler--info-circle] size-5 shrink-0"></span>' + __['You are offline now']).addClass("info");
  hide_live_status();
  /* clear live real-time thread */
  clearInterval(live_realtime_thread);
  clearInterval(live_timer_thread);
  /* reset live realtime process */
  live_realtime_process = false;
  /* handle the live buttons */
  $('#js_live-start').removeClass('hidden').prop('disabled', (live_broadcast_type == "rtmp"));
  $('#js_live-options').removeClass('hidden');
  $('#js_live-setup').prop('disabled', false);
  /* reset the live settings */
  $('#js_live-title').val('').removeClass('is-invalid');
  $('#js_live-description').val('').trigger('input');
  $('#js_live-paid-price-input').val('');
  $('input[name="live_category"], input[name="live_privacy"]').each(function () {
    this.checked = this.defaultChecked;
  });
  $('#tips_enabled, #for_subscriptions, #is_paid').prop('checked', false).prop('disabled', false);
  $('#js_live-paid-price').addClass('hidden');
  $('#js_live-settings').slideDown(300);
  $('#js_live-end').addClass('hidden');
  /* handle stream buttons */
  $('#js_live-stream-buttons').prop('hidden', true);
  $('#mic-btn, #cam-btn, #screen-btn, #comments-btn').attr('aria-pressed', false).prop('disabled', true);
  $('#js_live-layout').removeAttr('data-comments');
  /* handle live counter */
  $('#js_live-counter-status').html(__['Offline']).parent().addClass("offline");
  $('#js_live-counter-number').html(0);
  /* handle live recording */
  $('#js_live-recording').addClass('hidden');
  /* update the server side */
  $.post(api['live/reaction'], { 'do': 'end', 'post_id': live_post_id }, 'json');
  live_socket_leave();
  /* update live_post_id */
  live_post_id = undefined;
  /* remove live comments */
  $('#live-comments').addClass('hidden').find('ul.js_scroller').html('').removeData('last-reply-id');
  $('#live-comments .js_comment-form').attr('data-id', '').data('id', '');
  /* handle button status */
  button_status($('#js_live-end'), "reset");
  if (unloading) {
    return;
  }
  if (live_broadcast_type == "rtmp") {
    /* reset the broadcast type */
    $('.js_live-type[value="camera"]').prop('checked', true).trigger('change');
  } else {
    /* restore the camera preview */
    $('#js_live-start').prop('disabled', true);
    left.then(show_camera_preview).then(function () {
      $('#js_live-start').prop('disabled', false);
      $('#js_live-stream-buttons').prop('hidden', false);
    }).catch(function () {
      show_live_status();
      $('#js_live-status').html('<span class="icon-[tabler--alert-circle] size-5 shrink-0"></span>' + __['Getting permissions failed']).addClass("error");
    });
  }
}


// live host stats
function live_host_stats() {
  if (!live_post_id) {
    return;
  }
  /* check live realtime process */
  if (live_realtime_process) {
    live_stats_pending = true;
    return;
  }
  /* set live realtime process */
  live_realtime_process = true;
  var stream = $('#live-comments').find('ul.js_scroller');
  var data = live_stats_data(stream, live_post_id);
  $.post(api['live/reaction'], data, function (response) {
    /* update live count */
    $('#js_live-counter-number').html(response.live_count);
    /* update comments */
    live_update_comments(stream, response, data);
    live_fly_reactions($('.js_live-reactions'), response.reactions);
    var comments = live_new_comments(stream, response.comments);
    if (comments.length) {
      stream.append(comments.get().reverse());
      stream.scrollTop(stream[0].scrollHeight);
    }
  }, 'json')
    .always(function () {
      /* reset live realtime process */
      live_realtime_process = false;
      if (live_stats_pending) {
        live_stats_pending = false;
        live_host_stats();
      }
    });
}


// show live status
function show_live_status() {
  $('#js_live-status').stop(true, true).removeAttr("style").removeClass("success error info");
}


// hide live status
function hide_live_status() {
  setTimeout(function () {
    $('#js_live-status').fadeOut();
  }, 2500);
}


// capture video thumbnail
function capture_video_thumbnail() {
  /* get video */
  var video = $("#js_live-video").find("video")[0];
  if (!video || !video.videoWidth) {
    return 'data:,';
  }
  /* set canvas */
  var canvas = document.createElement("canvas");
  canvas.width = video.videoWidth;
  canvas.height = video.videoHeight;
  canvas.getContext('2d').drawImage(video, 0, 0);
  /* return */
  return canvas.toDataURL('image/png');
}


$(function () {

  // get user camera and mic permission
  if (!(navigator.mediaDevices && navigator.mediaDevices.getUserMedia)) {
    /* update live status */
    $('#js_live-status').html('<span class="icon-[tabler--alert-circle] size-5 shrink-0"></span>' + __['Sorry, WebRTC is not available in your browser']).addClass("error");
  } else {
    /* request permissions */
    navigator.mediaDevices.getUserMedia({ video: true, audio: true })
      .then(async function (stream) {
        stream.getTracks().forEach(track => track.stop());
        /* update live status */
        $('#js_live-status').html('<span class="icon-[tabler--info-circle] size-5 shrink-0"></span>' + __['You are ready to Go Live now']).addClass("info");
        hide_live_status();
        if (live_broadcast_type == "rtmp") {
          return;
        }
        /* show camera preview */
        await show_camera_preview();
        /* handle the live buttons */
        $('#js_live-start').prop('disabled', false);
        $('#js_live-stream-buttons').prop('hidden', false);
      })
      .catch(function (error) {
        console.error('Permission denied or error occurred: ', error);
        /* update live status */
        $('#js_live-status').html('<span class="icon-[tabler--alert-circle] size-5 shrink-0"></span>' + __['Getting permissions failed']).addClass("error");
      });
  }


  // populate the camera options
  (async function populateCameras() {
    const cameras = await getCameras();
    const cameraSelectDropdown = $('#camera-select-menu');
    cameras.forEach(camera => {
      const cameraItem = $('<button type="button" class="dropdown-item js_camera-select" role="menuitem"><span class="icon-[tabler--camera] size-4 shrink-0"></span><span class="min-w-0 truncate"></span></button>');
      cameraItem.attr('data-device-id', camera.deviceId).attr('title', camera.label).find('.truncate').text(camera.label);
      cameraSelectDropdown.append($('<li></li>').append(cameraItem));
    });
  })();


  // start live stream
  $('body').on('click', '#js_live-start', async function () {
    var _this = $(this);
    /* check the title */
    if (!String($('#js_live-title').val()).trim()) {
      $('#js_live-title').addClass('is-invalid').trigger('focus');
      return;
    }
    var rtmp = (live_broadcast_type == "rtmp");
    /* handle button status */
    button_status($('#js_live-start'), "loading");
    /* update live status */
    show_live_status();
    $('#js_live-status').html(__['Going Live'] + '<span class="loading loading-spinner loading-sm shrink-0"></span>');
    try {
      if (!rtmp) {
        await join();
      }
      /* take video thumbnail */
      var video_thumbnail = capture_video_thumbnail();
      /* update the server side */
      /* get live tips value */
      $.post(api['live/reaction'], { 'do': 'start', 'channel_name': (live_provider == "livekit") ? livekit_live_room : agora_channel_name, 'video_thumbnail': video_thumbnail, 'node': _this.data('node'), 'node_id': _this.data('node-id'), 'title': $('#js_live-title').val(), 'description': $('#js_live-description').val(), 'category_id': $('input[name="live_category"]:checked').val(), 'broadcast_type': live_broadcast_type, 'privacy': $('input[name="live_privacy"]:checked').val(), 'tips_enabled': $('#tips_enabled').is(":checked"), 'for_subscriptions': $('#for_subscriptions').is(":checked"), 'is_paid': $('#is_paid').is(":checked"), 'post_price': $('#js_live-paid-price-input').val() }, function (response) {
        /* handle button status */
        button_status($('#js_live-start'), "reset");
        if (response.callback) {
          /* leave the live channel */
          if (!rtmp) {
            leave_channel();
          }
          hide_live_status();
          eval(response.callback);
        } else {
          /* update live_post_id */
          live_post_id = response.post_id;
          /* update live streaming process */
          live_streaming_process = true;
          /* update live status */
          $('#js_live-status').html('<span class="icon-[tabler--circle-check] size-5 shrink-0"></span>' + __['You are live now']).addClass("success");
          hide_live_status();
          /* handle the live buttons */
          $('#js_live-start').addClass('hidden');
          $('#js_live-options').addClass('hidden');
          $('#js_live-setup').prop('disabled', true);
          $('#js_live-settings').slideUp(300);
          $('#js_live-end').removeClass('hidden');
          /* handle the live comments */
          $('#live-comments .js_comment-form').attr('data-id', live_post_id).data('id', live_post_id);
          if ($('#comments-btn').attr('aria-pressed') !== 'true') {
            $('#live-comments').removeClass('hidden');
          }
          /* handle stream buttons */
          handle_stream_controls();
          $('#js_live-stream-buttons').prop('hidden', false);
          $('#mic-btn, #cam-btn, #screen-btn, #comments-btn').prop('disabled', false);
          /* handle live counter */
          $('#js_live-counter-status').html(__['Live']).parent().removeClass("offline");
          /* handle live timer */
          var live_start = Date.now();
          $('#js_live-timer').text(format_timer(0, true));
          clearInterval(live_timer_thread);
          live_timer_thread = setInterval(function () {
            $('#js_live-timer').text(format_timer((Date.now() - live_start) / 1000, true));
          }, 1000);
          /* handle live recording */
          $('#js_live-recording').removeClass('hidden');
          /* join live socket room */
          live_socket_join(live_post_id);
          /* set live real-time thread */
          live_realtime_thread = setInterval(live_host_stats, 5000);
        }
      }, 'json');
    } catch (error) {
      /* update live status */
      /* handle button status */
      button_status($('#js_live-start'), "reset");
      $('#js_live-status').html('<span class="icon-[tabler--alert-circle] size-5 shrink-0"></span>' + __['Not able to connect, Try again later!']).addClass("error");
    }
  });


  // live title
  $('body').on('input', '#js_live-title', function () {
    $(this).removeClass('is-invalid');
  });


  // live description counter
  $('body').on('input', '#js_live-description', function () {
    $('#js_live-description-counter').text($(this).val().length);
  });


  // broadcast type
  $('body').on('change', '.js_live-type', async function () {
    live_broadcast_type = $(this).val();
    handle_stream_controls();
    if (live_broadcast_type == "rtmp") {
      /* stop the camera & connect the streaming software */
      stop_camera_preview();
      $('#js_live-status').stop(true, true).hide();
      $('#js_live-stream-buttons').prop('hidden', true);
      $('#js_live-rtmp').removeClass('hidden').addClass('flex');
      rtmp_connect(false);
    } else {
      /* disconnect the streaming software & start the camera */
      rtmp_disconnect();
      $('#js_live-rtmp').removeClass('flex').addClass('hidden');
      $('#js_live-start').prop('disabled', true);
      try {
        await show_camera_preview();
        $('#js_live-start').prop('disabled', false);
        $('#js_live-stream-buttons').prop('hidden', false);
      } catch (error) {
        show_live_status();
        $('#js_live-status').html('<span class="icon-[tabler--alert-circle] size-5 shrink-0"></span>' + __['Getting permissions failed']).addClass("error");
      }
    }
  });


  // reset stream key
  $('body').on('click', '#js_live-rtmp-reset', function () {
    if (live_streaming_process) return;
    rtmp_connect(true);
  });


  // end live stream
  $('body').on('click', '#js_live-end', function () {
    /* handle button status */
    button_status($('#js_live-end'), "loading");
    end_live_host();
  });
  /* handle closing the window */
  $(window).on('beforeunload', function () {
    end_live_host(true);
    return true;
  });


  // mute mic
  $('body').on('click', '#mic-btn', function () {
    var muted = $(this).attr('aria-pressed') !== 'true';
    $(this).attr('aria-pressed', muted);
    if (muted) {
      mute_audio();
    } else {
      unmute_audio();
    }
  });


  // mute cam
  $('body').on('click', '#cam-btn', function () {
    var muted = $(this).attr('aria-pressed') !== 'true';
    $(this).attr('aria-pressed', muted);
    if (muted) {
      mute_video();
    } else {
      unmute_video();
    }
  });


  // share screen
  $('body').on('click', '#screen-btn', function () {
    var sharing = $(this).attr('aria-pressed') !== 'true';
    $(this).attr('aria-pressed', sharing);
    if (sharing) {
      share_screen();
    } else {
      unshare_screen();
    }
  });


  // mute comments
  $('body').on('click', '#comments-btn', function () {
    var muted = $(this).attr('aria-pressed') !== 'true';
    $(this).attr('aria-pressed', muted);
    $('#live-comments').toggleClass('hidden', muted);
    $('#js_live-layout').attr('data-comments', muted ? 'off' : null);
  });


  // switch camera
  $('body').on('click', '.js_camera-select', async function () {
    const deviceId = $(this).data('device-id');
    await switch_camera(deviceId);
  });


  // for_subscriptions
  $('body').on('change', '#for_subscriptions', function () {
    if ($(this).is(":checked")) {
      /* disale is_paid */
      $('#is_paid').prop('checked', false);
      $('#is_paid').prop('disabled', true);
    } else {
      /* enable is_paid */
      $('#is_paid').prop('disabled', false);
    }
  });


  // is_paid
  $('body').on('change', '#is_paid', function () {
    if ($(this).is(":checked")) {
      $('#js_live-paid-price').removeClass('hidden');
      /* disale for_subscriptions */
      $('#for_subscriptions').prop('checked', false);
      $('#for_subscriptions').prop('disabled', true);
    } else {
      $('#js_live-paid-price').addClass('hidden');
      /* enable for_subscriptions */
      $('#for_subscriptions').prop('disabled', false);
    }
  });

});