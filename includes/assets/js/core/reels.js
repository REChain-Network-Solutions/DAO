/**
 * reels js
 *
 * @package Sngine
 * @author Zamblek
 */

// initialize reels
var reels = {
  root: null,
  stream: null,
  panel: null,
  observer: null,
  pool: [],
  active: null,
  muted: true,
  blocked: false,
  paused: false,
  held: false,
  loading: false,
  exhausted: false,
  empty_loads: 0,
  seen: {},
  viewed: {},
  watched: 0,
  last_time: 0,
  comments_id: null
};


// reels sources
function reels_sources(slide) {
  var sources = [];
  $.each([240, 360, 480, 720, 1080], function (index, size) {
    var url = slide.attr('data-source-' + size);
    if (url) {
      sources.push({ 'size': size, 'url': url });
    }
  });
  return sources;
}


// reels pick source
function reels_pick_source(slide, below) {
  var sources = reels_sources(slide);
  if (sources.length == 0) {
    return { 'size': 0, 'url': (below) ? null : slide.attr('data-source') };
  }
  /* renditions are named after the short side */
  var frame = slide.find('.js_reel-frame');
  var target = (frame.width() || $(window).width()) * Math.min(window.devicePixelRatio || 1, 1.5);
  var limit = 1080;
  var connection = navigator.connection || {};
  if (connection.saveData || connection.effectiveType == '3g') {
    limit = 480;
  }
  if (connection.effectiveType == '2g' || connection.effectiveType == 'slow-2g') {
    limit = 360;
  }
  if (below) {
    limit = below - 1;
  }
  var picked = null;
  $.each(sources, function (index, source) {
    if (source.size > limit) {
      return;
    }
    if (!picked || picked.size < target) {
      picked = source;
    }
  });
  if (!picked) {
    return (below) ? { 'size': 0, 'url': null } : sources[0];
  }
  return picked;
}


// reels video
function reels_video(slide) {
  var found = null;
  if (slide && slide.length) {
    $.each(reels.pool, function (index, video) {
      if (video._slide === slide[0]) {
        found = video;
      }
    });
  }
  return found;
}


// reels release
function reels_release(video) {
  if (video._slide) {
    $(video._slide).removeAttr('data-playing data-paused data-fast').find('.js_reel-progress').css('width', '');
  }
  video._slide = null;
  video.pause();
  video.removeAttribute('src');
  video.load();
  $(video).detach();
}


// reels mount
function reels_mount(slide, keep, eager) {
  var video = reels_video(slide);
  if (video) {
    return video;
  }
  /* reuse a video that is not next to the active reel */
  $.each(reels.pool, function (index, item) {
    if (!video && (!item._slide || $.inArray(item._slide, keep) == -1)) {
      video = item;
    }
  });
  if (!video) {
    return null;
  }
  reels_release(video);
  var source = reels_pick_source(slide);
  video._slide = slide[0];
  video._size = source.size;
  video._retried = false;
  video.preload = (eager || !(navigator.connection && navigator.connection.saveData)) ? 'auto' : 'metadata';
  video.muted = reels.muted || reels.blocked;
  video.playbackRate = 1;
  video.src = source.url;
  slide.find('.js_reel-slot').append(video);
  return video;
}


// reels mount around
function reels_mount_around(slide) {
  var next = slide.next('.js_reel');
  var prev = slide.prev('.js_reel');
  var other = (prev.length) ? prev : next.next('.js_reel');
  var keep = [slide[0]];
  if (next.length) keep.push(next[0]);
  if (other.length) keep.push(other[0]);
  var video = reels_mount(slide, keep, true);
  if (next.length) reels_mount(next, keep, false);
  if (other.length) reels_mount(other, keep, false);
  return video;
}


// reels play
function reels_play(video, gesture) {
  if (!video) {
    return;
  }
  video.muted = reels.muted || reels.blocked;
  var promise = video.play();
  if (promise && promise.catch) {
    promise.then(function () {
      if (gesture) {
        video._blessed = true;
      }
    }).catch(function (error) {
      /* the browser needs a tap before it plays with sound */
      if (error && error.name == 'NotAllowedError' && !video.muted) {
        reels.blocked = true;
        reels.root.attr('data-muted', 'true');
        $('.js_reels-unmute').removeClass('hidden');
        $.each(reels.pool, function (index, item) {
          item.muted = true;
        });
        var retry = video.play();
        if (retry && retry.catch) {
          retry.catch(function () { });
        }
      }
    });
  }
}


// reels bless
function reels_bless() {
  if (reels.muted) {
    return;
  }
  /* a video started by a tap can play with sound later */
  var active = reels_video(reels.active);
  $.each(reels.pool, function (index, video) {
    if (video === active || video._blessed || !video.getAttribute('src')) {
      return;
    }
    video.muted = true;
    var promise = video.play();
    if (promise && promise.then) {
      promise.then(function () {
        video._blessed = true;
        if (video !== reels_video(reels.active)) {
          video.pause();
        }
      }).catch(function () { });
    }
  });
}


// reels set muted
function reels_set_muted(muted) {
  reels.muted = muted;
  reels.blocked = false;
  try {
    sessionStorage.setItem('reels_muted', (muted) ? '1' : '0');
  } catch (e) { }
  reels.root.attr('data-muted', (muted) ? 'true' : 'false');
  $('.js_reels-mute').attr('aria-label', (muted) ? __['Unmute'] : __['Mute']);
  $('.js_reels-unmute').addClass('hidden');
  $.each(reels.pool, function (index, video) {
    video.muted = muted;
  });
  reels_bless();
}


// reels toggle play
function reels_toggle_play() {
  var video = reels_video(reels.active);
  if (!video) {
    return;
  }
  if (video.paused) {
    reels.paused = false;
    reels.active.removeAttr('data-paused');
    reels_play(video, true);
  } else {
    reels.paused = true;
    reels.active.attr('data-paused', 'true');
    video.pause();
  }
}


// reels activate
function reels_activate(slide) {
  if (reels.active && reels.active[0] === slide[0]) {
    return;
  }
  var previous = reels.active;
  /* reset the previous reel */
  if (previous) {
    var previous_video = reels_video(previous);
    if (previous_video) {
      previous_video.pause();
      previous_video.playbackRate = 1;
    }
    previous.removeAttr('data-paused data-fast');
    previous.find('.js_readmore-toggle[aria-expanded="true"]').trigger('click');
  }
  reels.active = slide;
  reels.paused = false;
  reels.held = false;
  reels.watched = 0;
  reels.last_time = 0;
  /* keep the videos of the active reel and the ones next to it */
  var next = slide.next('.js_reel');
  var prev = slide.prev('.js_reel');
  var video = reels_mount_around(slide);
  /* play */
  if (video) {
    try {
      if (video.currentTime > 0) video.currentTime = 0;
    } catch (e) { }
    reels_play(video);
  }
  /* update the url */
  var url = site_path + '/reels/' + slide.data('id') + ((reels.root.data('tab') == 'following') ? '?tab=following' : '');
  window.history.replaceState(window.history.state, '', url);
  /* hide the reactions */
  $('.reactions-container:visible').removeAttr('style').hide();
  /* update the arrows */
  $('.js_reels-prev').prop('disabled', prev.length == 0);
  $('.js_reels-next').prop('disabled', next.length == 0);
  /* update the comments */
  if (!reels.panel.hasClass('hidden')) {
    if (window.matchMedia('(min-width: 1024px)').matches) {
      reels_comments(slide);
    } else {
      HSOverlay.close(reels.panel[0]);
    }
  }
  /* load more */
  if (slide.nextAll('.js_reel').length <= 3) {
    reels_load_more();
  }
}


// reels go
function reels_go(direction) {
  if (!reels.active) {
    return;
  }
  var target = (direction > 0) ? reels.active.next('.js_reel') : reels.active.prev('.js_reel');
  if (target.length == 0) {
    return;
  }
  var stream = reels.stream[0];
  var index = reels.stream.children('.js_reel').index(target);
  stream.scrollTo({ 'top': index * stream.clientHeight, 'behavior': 'smooth' });
}


// reels load more
function reels_load_more() {
  if (reels.loading || reels.exhausted) {
    return;
  }
  reels.loading = true;
  $('.js_reels-loader').removeClass('hidden');
  $.post(api['data/load'], { 'get': 'reels', 'offset': 1, 'filter': reels.root.data('tab'), 'cursor': reels.root.data('cursor'), 'id': reels.root.data('pinned') }, function (response) {
    reels.loading = false;
    $('.js_reels-loader').addClass('hidden');
    if (!response.data || !response.cursor) {
      reels.exhausted = true;
      return;
    }
    reels.root.data('cursor', response.cursor);
    var added = 0;
    $('<div>').html(response.data).children('.js_reel').each(function () {
      var id = $(this).data('id');
      if (reels.seen[id]) {
        return;
      }
      reels.seen[id] = true;
      reels.stream.append(this);
      reels.observer.observe(this);
      added++;
    });
    if (reels.active) {
      $('.js_reels-next').prop('disabled', reels.active.next('.js_reel').length == 0);
      /* mount the next reels */
      reels_mount_around(reels.active);
    }
    /* a page of reels already shown continues to the next one */
    if (added == 0 && reels.empty_loads < 3) {
      reels.empty_loads++;
      reels_load_more();
    } else {
      reels.empty_loads = 0;
    }
  }, 'json')
    .fail(function () {
      reels.loading = false;
      $('.js_reels-loader').addClass('hidden');
    });
}


// reels comments
function reels_comments(slide) {
  var id = slide.data('id');
  var body = reels.panel.find('.js_reels-comments-body');
  reels.comments_id = id;
  reels.panel.find('.js_reels-comments-count').text(slide.find('.js_reel-comments-count').text());
  body.html('<div class="py-10 text-center"><div class="loading loading-spinner loading-lg"></div></div>');
  $.post(ajax_path + 'posts/reel.php', { 'do': 'comments', 'post_id': id }, function (response) {
    if (reels.comments_id != id) {
      return;
    }
    if (response.callback) {
      body.html('');
      eval(response.callback);
    } else {
      body.html(response.comments);
      reels.panel.find('.js_reels-comments-count').text(response.count);
      slide.find('.js_reel-comments-count').text(response.count);
    }
  }, 'json')
    .fail(function () {
      body.html('');
    });
}


// reels like
function reels_like(slide) {
  var heart = slide.find('.js_reel-heart')[0];
  ui_animate(heart, [
    { opacity: 0, transform: 'scale(0.4)' },
    { opacity: 1, transform: 'scale(1.15)', offset: 0.3 },
    { opacity: 1, transform: 'scale(1)', offset: 0.7 },
    { opacity: 0, transform: 'scale(1.3)' }
  ], { duration: 800, easing: 'ease-out' });
  var wrapper = slide.find('.reactions-wrapper:first');
  if (wrapper.length == 0) {
    modal('#modal-login');
    return;
  }
  if (wrapper.hasClass('js_unreact-post')) {
    return;
  }
  var reaction = wrapper.find('.js_react-post[data-reaction="like"]:first');
  if (reaction.length == 0) {
    reaction = wrapper.find('.js_react-post:first');
  }
  reaction.trigger('click');
}


// reels remove
function reels_remove(slide) {
  var target = slide.next('.js_reel');
  if (target.length == 0) {
    target = slide.prev('.js_reel');
  }
  var video = reels_video(slide);
  if (video) {
    reels_release(video);
  }
  if (reels.active && reels.active[0] === slide[0]) {
    reels.active = null;
  }
  reels.observer.unobserve(slide[0]);
  slide.remove();
  if (target.length) {
    reels.stream[0].scrollTo({ 'top': reels.stream.children('.js_reel').index(target) * reels.stream[0].clientHeight });
    reels_activate(target);
  } else {
    window.location = site_path + '/reels';
  }
}


$(function () {

  // initialize reels
  reels.root = $('#reels');
  reels.stream = reels.root.find('.js_reels-stream');
  reels.panel = $('#reels-comments');
  if (reels.stream.length == 0) {
    return;
  }


  // run reels videos
  for (var i = 0; i < 3; i++) {
    var video = document.createElement('video');
    video.className = 'absolute inset-0 size-full object-contain';
    video.muted = true;
    video.loop = true;
    video.playsInline = true;
    video.setAttribute('muted', '');
    video.setAttribute('playsinline', '');
    video.setAttribute('webkit-playsinline', '');
    video.setAttribute('disablepictureinpicture', '');
    video.setAttribute('controlslist', 'nodownload noplaybackrate');
    reels.pool.push(video);
  }
  $(reels.pool).on('playing', function () {
    if (this._slide) {
      $(this._slide).attr('data-playing', 'true');
    }
  });
  $(reels.pool).on('timeupdate', function () {
    if (!reels.active || this._slide !== reels.active[0]) {
      return;
    }
    var time = this.currentTime;
    var duration = this.duration;
    /* count the view after the reel was really watched */
    var delta = (time - reels.last_time) / (this.playbackRate || 1);
    reels.last_time = time;
    if (delta > 0 && delta < 1.5) {
      reels.watched += delta;
    }
    var id = reels.active.data('id');
    var needed = (duration > 0 && isFinite(duration)) ? Math.min(3, duration / 2) : 3;
    if (!reels.viewed[id] && reels.watched >= needed) {
      reels.viewed[id] = true;
      $.post(ajax_path + 'posts/reel.php', { 'do': 'view', 'post_id': id });
    }
  });
  $(reels.pool).on('error', function () {
    var video = this;
    if (!video._slide || video._retried) {
      return;
    }
    /* try a smaller video once */
    var source = reels_pick_source($(video._slide), video._size || 100000);
    if (!source.url || source.url == video.getAttribute('src')) {
      source = { 'size': 0, 'url': $(video._slide).attr('data-source') };
    }
    if (!source.url || source.url == video.getAttribute('src')) {
      return;
    }
    video._retried = true;
    video._size = source.size;
    video.src = source.url;
    if (reels.active && video._slide === reels.active[0] && !reels.paused) {
      reels_play(video);
    }
  });


  // run reels progress
  function reels_progress() {
    var video = reels_video(reels.active);
    if (video && video.duration > 0 && isFinite(video.duration)) {
      reels.active.find('.js_reel-progress').css('width', (video.currentTime / video.duration * 100) + '%');
    }
    window.requestAnimationFrame(reels_progress);
  }
  window.requestAnimationFrame(reels_progress);


  // run reels muted
  try {
    reels.muted = sessionStorage.getItem('reels_muted') !== '0';
  } catch (e) { }
  reels.root.attr('data-muted', (reels.muted) ? 'true' : 'false');


  // run reels observer
  reels.stream.children('.js_reel').each(function () {
    reels.seen[$(this).data('id')] = true;
  });
  reels.observer = new IntersectionObserver(function (entries) {
    $.each(entries, function (index, entry) {
      if (entry.isIntersecting && entry.intersectionRatio >= 0.6) {
        reels_activate($(entry.target));
      }
    });
  }, { 'root': reels.stream[0], 'threshold': 0.6 });
  reels.stream.children('.js_reel').each(function () {
    reels.observer.observe(this);
  });


  // handle reels mute
  $('body').on('click', '.js_reels-mute', function () {
    reels_set_muted((reels.blocked) ? false : !reels.muted);
    var video = reels_video(reels.active);
    if (video && !reels.paused) {
      reels_play(video, true);
    }
  });
  $('body').on('click', '.js_reels-unmute', function () {
    reels_set_muted(false);
    reels.paused = false;
    if (reels.active) {
      reels.active.removeAttr('data-paused');
    }
    reels_play(reels_video(reels.active), true);
  });


  // handle reels gestures
  var press = null;
  var tap = null;
  var tap_timer = null;
  function press_cancel() {
    if (!press) {
      return;
    }
    clearTimeout(press.timer);
    if (reels.held) {
      reels.held = false;
      var video = reels_video(press.slide);
      if (video) {
        video.playbackRate = 1;
      }
      press.slide.removeAttr('data-fast');
    }
    press = null;
  }
  reels.stream.on('pointerdown', '.js_reel-surface', function (e) {
    var event = e.originalEvent;
    if (!event.isPrimary || event.button > 0) {
      return;
    }
    press_cancel();
    var slide = $(this).closest('.js_reel');
    press = { 'x': event.clientX, 'y': event.clientY, 'slide': slide };
    /* hold to play faster */
    press.timer = setTimeout(function () {
      var video = reels_video(slide);
      if (!press || !video || video.paused) {
        return;
      }
      reels.held = true;
      video.playbackRate = 2;
      slide.attr('data-fast', 'true');
    }, 350);
  });
  reels.stream.on('pointermove', '.js_reel-surface', function (e) {
    var event = e.originalEvent;
    if (press && (Math.abs(event.clientX - press.x) > 10 || Math.abs(event.clientY - press.y) > 10)) {
      press_cancel();
    }
  });
  reels.stream.on('pointercancel pointerleave', '.js_reel-surface', function () {
    press_cancel();
  });
  reels.stream.on('pointerup', '.js_reel-surface', function (e) {
    var event = e.originalEvent;
    if (!press) {
      return;
    }
    var slide = press.slide;
    var was_held = reels.held;
    press_cancel();
    if (was_held) {
      return;
    }
    /* the first tap gives the sound back */
    if (reels.blocked) {
      reels_set_muted(false);
      reels_play(reels_video(reels.active), true);
      return;
    }
    reels_bless();
    var now = Date.now();
    if (tap && now - tap.time < 280 && Math.abs(event.clientX - tap.x) < 30 && Math.abs(event.clientY - tap.y) < 30) {
      /* double tap */
      clearTimeout(tap_timer);
      tap = null;
      reels_like(slide);
    } else {
      tap = { 'time': now, 'x': event.clientX, 'y': event.clientY };
      clearTimeout(tap_timer);
      tap_timer = setTimeout(function () {
        tap = null;
        if (reels.active && reels.active[0] === slide[0]) {
          reels_toggle_play();
        }
      }, 280);
    }
  });
  reels.stream.on('contextmenu', '.js_reel-surface', function (e) {
    e.preventDefault();
  });


  // handle reels caption
  reels.stream.on('click', '.js_reel-caption .js_readmore', function (e) {
    if ($(e.target).closest('a').length || String(window.getSelection()) != '') {
      return;
    }
    $(this).next('.js_readmore-toggle-wrapper:not(.hidden)').find('.js_readmore-toggle').trigger('click');
  });


  // handle reels arrows
  $('body').on('click', '.js_reels-next', function () {
    reels_go(1);
  });
  $('body').on('click', '.js_reels-prev', function () {
    reels_go(-1);
  });


  // handle reels keyboard
  $(document).on('keydown', function (e) {
    if ($(e.target).is('input, textarea, select, [contenteditable]') || $('#modal.open, #modal-stacked.open, .lightbox').length) {
      return;
    }
    if (e.key == "ArrowDown" || e.key == "PageDown") {
      e.preventDefault();
      reels_go(1);
    } else if (e.key == "ArrowUp" || e.key == "PageUp") {
      e.preventDefault();
      reels_go(-1);
    } else if (e.key == " " && !$(e.target).is('button, a')) {
      e.preventDefault();
      reels_toggle_play();
    } else if (e.key == "m" || e.key == "M") {
      $('.js_reels-mute:first').trigger('click');
    }
  });


  // handle reels resize
  $(window).on('resize orientationchange', function () {
    if (!reels.active) {
      return;
    }
    var stream = reels.stream[0];
    stream.scrollTo({ 'top': reels.stream.children('.js_reel').index(reels.active) * stream.clientHeight });
  });


  // handle reels back
  $('body').on('click', '.js_reels-back', function (e) {
    if (document.referrer && document.referrer.indexOf(site_path) === 0 && window.history.length > 1) {
      e.preventDefault();
      window.history.back();
    }
  });


  // handle reels comments
  $('body').on('click', '.js_reel-comments', function () {
    var slide = $(this).closest('.js_reel');
    if (!reels.panel.hasClass('hidden') && reels.comments_id == slide.data('id')) {
      HSOverlay.close(reels.panel[0]);
      return;
    }
    HSOverlay.open(reels.panel[0]);
    reels_comments(slide);
  });


  // handle reels comments drag
  var drag = null;
  reels.panel.on('pointerdown', '.js_reels-comments-drag', function (e) {
    var event = e.originalEvent;
    if (!event.isPrimary || event.button > 0 || $(e.target).closest('button').length || window.matchMedia('(min-width: 1024px)').matches) {
      return;
    }
    drag = { 'y': event.clientY, 'time': Date.now(), 'moved': 0 };
    this.setPointerCapture(event.pointerId);
    reels.panel[0].style.transition = 'none';
  });
  reels.panel.on('pointermove', '.js_reels-comments-drag', function (e) {
    if (!drag) {
      return;
    }
    drag.moved = Math.max(0, e.originalEvent.clientY - drag.y);
    reels.panel[0].style.translate = '0 ' + drag.moved + 'px';
  });
  reels.panel.on('pointerup pointercancel', '.js_reels-comments-drag', function () {
    if (!drag) {
      return;
    }
    var panel = reels.panel[0];
    var close = drag.moved > 120 || (drag.moved > 40 && Date.now() - drag.time < 250);
    drag = null;
    panel.style.transition = '';
    if (close) {
      /* slide down from where the finger left it */
      panel.style.translate = '0 100%';
      HSOverlay.close(panel);
      setTimeout(function () {
        panel.style.translate = '';
      }, 350);
    } else {
      panel.style.translate = '';
    }
  });


  // handle reels pause
  $('body').on('open.overlay', '#modal', function () {
    var video = reels_video(reels.active);
    if (video) {
      video.pause();
    }
  });
  $('body').on('close.overlay', '#modal', function () {
    if (!reels.paused && document.visibilityState != 'hidden') {
      reels_play(reels_video(reels.active));
    }
  });
  $(document).on('visibilitychange', function () {
    var video = reels_video(reels.active);
    if (!video) {
      return;
    }
    if (document.visibilityState == 'hidden') {
      video.pause();
    } else if (!reels.paused && $('#modal.open').length == 0) {
      reels_play(video);
    }
  });
  $(window).on('pagehide', function () {
    $.each(reels.pool, function (index, video) {
      video.pause();
    });
  });


  // handle reels actions
  $(document).ajaxSuccess(function (event, xhr, settings, response) {
    if (typeof settings.data !== 'string' || !response || response.callback) {
      return;
    }
    var data = new URLSearchParams(settings.data);
    if (settings.url.indexOf('posts/reaction.php') != -1 && $.inArray(data.get('do'), ['delete_post', 'hide_post']) != -1) {
      /* remove the reel */
      var slide = reels.stream.children('.js_reel').filter(function () {
        return String($(this).data('id')) === String(data.get('id'));
      });
      if (slide.length) {
        reels_remove(slide);
      }
    } else if (settings.url.indexOf('posts/comment.php') != -1 && data.get('handle') == 'post' && response.comment) {
      /* update the comments counter */
      var counters = reels.panel.find('.js_reels-comments-count').add(reels.stream.children('.js_reel').filter(function () {
        return String($(this).data('id')) === String(data.get('id'));
      }).find('.js_reel-comments-count'));
      counters.each(function () {
        var count = $(this).text().trim();
        if (/^\d+$/.test(count)) {
          $(this).text(parseInt(count, 10) + 1);
        }
      });
    } else if (settings.url.indexOf('posts/edit.php') != -1 && response.post) {
      window.location.reload();
    }
  });

});
