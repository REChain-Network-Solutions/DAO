/**
 * stories js
 *
 * @package Sngine
 * @author Zamblek
 */

// initialize API URLs
api['stories/load'] = ajax_path + "stories/load.php";
api['stories/action'] = ajax_path + "stories/action.php";
api['stories/publish'] = ajax_path + "stories/publish.php";
api['stories/music'] = ajax_path + "stories/music.php";


// initialize stories
var stories = {
  viewer: null,
  users: [],
  user_index: 0,
  data: null,
  cache: {},
  index: 0,
  video: null,
  player: null,
  audio: null,
  ready: false,
  duration: 0,
  elapsed: 0,
  last_tick: 0,
  frame: null,
  blocks: {},
  muted: false,
  request: 0,
  token: 0,
  viewers_page: 0,
  status_timer: null
};


// stories strip refresh
function stories_strip_refresh() {
  $(window).trigger('resize');
}


// stories rtl
function stories_rtl() {
  return $('html').attr('dir') == 'rtl';
}


// stories item
function stories_item() {
  return (stories.data) ? stories.data.items[stories.index] : null;
}


// stories backgrounds
var stories_backgrounds = {
  'aurora': 'bg-linear-to-br from-indigo-500 via-purple-500 to-pink-500',
  'sunset': 'bg-linear-to-br from-orange-400 via-rose-500 to-fuchsia-600',
  'ocean': 'bg-linear-to-br from-cyan-400 via-sky-500 to-indigo-600',
  'forest': 'bg-linear-to-br from-emerald-400 via-teal-500 to-cyan-700',
  'candy': 'bg-linear-to-br from-pink-400 via-rose-400 to-amber-300',
  'grape': 'bg-linear-to-br from-fuchsia-600 via-purple-700 to-indigo-900',
  'peach': 'bg-linear-to-br from-amber-300 via-orange-400 to-rose-500',
  'midnight': 'bg-linear-to-br from-slate-700 via-slate-900 to-black'
};


// stories filters
var stories_filters = {
  'vivid': 'saturate(1.5) contrast(1.1)',
  'warm': 'sepia(0.3) saturate(1.3) brightness(1.05)',
  'cool': 'saturate(1.1) hue-rotate(15deg) brightness(1.05)',
  'mono': 'grayscale(1)',
  'noir': 'grayscale(1) contrast(1.35) brightness(0.9)',
  'fade': 'contrast(0.85) brightness(1.12) saturate(0.8)',
  'vintage': 'sepia(0.55) contrast(0.95) saturate(0.9)',
  'dramatic': 'contrast(1.4) saturate(1.2) brightness(0.92)'
};


// stories fonts
var stories_fonts = {
  'modern': { 'family': 'inherit', 'weight': 700, 'style': 'normal' },
  'classic': { 'family': '"Playfair Display", Georgia, serif', 'weight': 700, 'style': 'normal' },
  'signature': { 'family': '"Dancing Script", "Brush Script MT", cursive', 'weight': 700, 'style': 'normal' },
  'editorial': { 'family': '"Playfair Display", Georgia, serif', 'weight': 800, 'style': 'italic' },
  'typewriter': { 'family': '"Courier Prime", "Courier New", monospace', 'weight': 700, 'style': 'normal' },
  'neon': { 'family': '"Righteous", "Arial Rounded MT Bold", sans-serif', 'weight': 400, 'style': 'normal' }
};


// stories load fonts
function stories_load_fonts(mode) {
  if (mode == 'local' || $('#stories-fonts').length > 0) {
    return;
  }
  $('head').append('<link id="stories-fonts" rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Courier+Prime:wght@700&family=Dancing+Script:wght@700&family=Playfair+Display:ital,wght@0,700;1,800&family=Righteous&display=swap">');
}


// stories layer element
function stories_layer_element(layer, context) {
  var element;
  var music = context && context.music;
  switch (layer.type) {
    case 'text':
      var font = stories_fonts[layer.font] || stories_fonts['modern'];
      element = $('<div class="w-max max-w-[86%] rounded-[0.35em] px-[0.5em] py-[0.2em] leading-snug break-words whitespace-pre-wrap" dir="auto"></div>');
      element.text(layer.text).data({ 'size-property': 'font-size', 'size-base': 5.2 }).css({
        'color': layer.color,
        'background-color': layer.background || 'transparent',
        'font-size': (5.2 * layer.scale) + 'cqw',
        'font-family': font.family,
        'font-weight': font.weight,
        'font-style': font.style,
        'text-align': layer.align,
        'text-shadow': (layer.font == 'neon') ? '0 0 0.12em currentColor, 0 0 0.45em currentColor' : ((layer.background) ? 'none' : '0 1px 3px rgb(0 0 0 / 0.5)')
      });
      break;

    case 'emoji':
      element = $('<div class="leading-none"></div>');
      element.text(layer.emoji).data({ 'size-property': 'font-size', 'size-base': 16 }).css('font-size', (16 * layer.scale) + 'cqw');
      break;

    case 'sticker':
      element = $('<div><img class="block h-auto w-full" alt="" draggable="false"></div>');
      element.data({ 'size-property': 'width', 'size-base': 30 }).css('width', (30 * layer.scale) + 'cqw').find('img').attr('src', layer.image);
      break;

    case 'mention':
      element = $('<a class="pointer-events-auto inline-flex items-center rounded-full bg-white/95 px-[0.75em] py-[0.35em] leading-none font-bold whitespace-nowrap text-neutral-900! shadow-lg"></a>');
      element.text('@' + layer.user_name).attr('href', site_path + '/' + layer.user_name).data({ 'size-property': 'font-size', 'size-base': 4.4 }).css('font-size', (4.4 * layer.scale) + 'cqw');
      break;

    case 'link':
      element = $('<a class="pointer-events-auto inline-flex max-w-[86%] items-center gap-[0.4em] rounded-full bg-white/95 px-[0.75em] py-[0.35em] leading-none font-bold text-sky-700! shadow-lg" target="_blank" rel="noopener nofollow"><span class="icon-[tabler--link] size-[1.1em] shrink-0" aria-hidden="true"></span><span class="truncate py-[0.1em]"></span></a>');
      element.attr('href', layer.url).data({ 'size-property': 'font-size', 'size-base': 4.4 }).css('font-size', (4.4 * layer.scale) + 'cqw').find('.truncate').text(layer.label).attr('title', layer.url);
      break;

    case 'music':
      if (!music) {
        return null;
      }
      var music_shapes = {
        'pill': '<a class="pointer-events-auto inline-flex max-w-[86%] items-center gap-[0.6em] rounded-full bg-black/55 py-[0.35em] ps-[0.35em] pe-[1em] leading-tight text-white! shadow-lg backdrop-blur-md"><img class="size-[2.4em] shrink-0 rounded-full bg-white/15 object-cover motion-safe:animate-[spin_8s_linear_infinite]" alt=""><span class="min-w-0"><span class="js_story-music-title block truncate font-bold"></span><span class="js_story-music-artist block truncate text-[0.8em] opacity-80"></span></span></a>',
        'card': '<a class="pointer-events-auto flex w-[13em] max-w-[86%] flex-col gap-[0.6em] rounded-[1.3em] bg-black/55 p-[0.7em] leading-tight text-white! shadow-xl backdrop-blur-md"><img class="aspect-square w-full rounded-[0.8em] bg-white/15 object-cover" alt=""><span class="min-w-0 px-[0.2em] pb-[0.2em]"><span class="js_story-music-title block truncate font-bold"></span><span class="js_story-music-artist block truncate text-[0.8em] opacity-80"></span></span></a>',
        'cover': '<a class="pointer-events-auto relative block w-[9em] max-w-[86%] rounded-[1.3em] bg-black/55 text-white! shadow-xl"><img class="aspect-square w-full rounded-[1.3em] bg-white/15 object-cover" alt=""><span class="absolute end-[0.5em] bottom-[0.5em] flex size-[1.9em] items-center justify-center rounded-full bg-black/60 backdrop-blur-md"><span class="icon-[tabler--music] size-[1.1em]" aria-hidden="true"></span></span><span class="js_story-music-title sr-only"></span><span class="js_story-music-artist sr-only"></span></a>',
        'text': '<a class="pointer-events-auto inline-flex max-w-[86%] items-center gap-[0.45em] leading-tight font-bold text-white! [text-shadow:0_1px_3px_rgb(0_0_0/0.6)]"><span class="icon-[tabler--music] size-[1.2em] shrink-0" aria-hidden="true"></span><span class="min-w-0 truncate"><span class="js_story-music-title"></span><span class="js_story-music-artist ms-[0.4em] font-medium opacity-85"></span></span><img class="hidden" alt=""></a>'
      };
      element = $(music_shapes[layer.style] || music_shapes['pill']).attr({ 'target': '_blank', 'rel': 'noopener nofollow' });
      element.data({ 'size-property': 'font-size', 'size-base': 3.6 }).css('font-size', (3.6 * layer.scale) + 'cqw');
      element.find('img').attr('src', music.cover || 'data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==');
      element.find('.js_story-music-title').text(music.title).attr('title', music.title);
      element.find('.js_story-music-artist').text(music.artist).attr('title', music.artist);
      if (music.url) {
        element.attr('href', music.url);
      }
      break;

    case 'poll':
      var poll = (context && context.poll) || { 'votes': [0, 0], 'voted': 0 };
      var total = poll.votes[0] + poll.votes[1];
      var results = !!(context && context.results);
      element = $('<div class="pointer-events-auto w-[17em] max-w-[92cqw] rounded-[1em] bg-white p-[0.9em] text-neutral-900 shadow-xl"><div class="js_story-poll-question mb-[0.7em] text-center leading-snug font-bold break-words" dir="auto"></div><div class="flex gap-[0.5em]"></div></div>');
      element.data({ 'size-property': 'font-size', 'size-base': 3.8 }).css('font-size', (3.8 * layer.scale) + 'cqw');
      element.find('.js_story-poll-question').text(layer.question).toggleClass('hidden', !layer.question);
      $.each(layer.options, function (index, option) {
        var percent = (total > 0) ? Math.round(poll.votes[index] / total * 100) : 0;
        var button = $('<button type="button" class="js_story-vote relative min-w-0 flex-1 overflow-hidden rounded-[0.7em] bg-neutral-100 px-[0.6em] py-[0.7em] font-bold aria-pressed:ring-2 aria-pressed:ring-primary"><span class="js_story-poll-bar absolute inset-y-0 start-0 bg-primary/25 transition-[width] duration-500"></span><span class="js_story-poll-option relative block truncate"></span><span class="js_story-poll-percent relative block text-[0.8em] opacity-70"></span></button>');
        button.attr({ 'data-option': index + 1, 'aria-pressed': (poll.voted == index + 1) ? 'true' : 'false' });
        button.find('.js_story-poll-option').text(option).attr('title', option);
        button.find('.js_story-poll-bar').css('width', (results) ? percent + '%' : '0%');
        button.find('.js_story-poll-percent').text((results) ? percent + '%' : '').toggleClass('hidden', !results);
        element.find('.flex').append(button);
      });
      break;

    default:
      return null;
  }
  return element.addClass('absolute -translate-x-1/2 -translate-y-1/2').css({
    'left': (layer.x * 100) + '%',
    'top': (layer.y * 100) + '%',
    'rotate': layer.rotation + 'deg'
  });
}


// stories render layers
function stories_render_layers(container, layers, context) {
  container.empty();
  $.each(layers || [], function (index, layer) {
    var element = stories_layer_element(layer, context);
    if (element) {
      container.append(element.attr('data-index', index));
    }
  });
}


// stories context
function stories_context(item) {
  return { 'music': item.music, 'poll': item.poll, 'results': stories.data.is_me || item.poll.voted > 0 };
}


// stories block
function stories_block(reason, state) {
  if (state) {
    stories.blocks[reason] = true;
  } else {
    delete stories.blocks[reason];
  }
  stories_sync();
}


// stories running
function stories_running() {
  return stories.ready && $.isEmptyObject(stories.blocks);
}


// stories sync
function stories_sync() {
  if (!stories.viewer) {
    return;
  }
  stories.viewer.attr('data-paused', (stories.blocks['user']) ? 'true' : 'false');
  stories.viewer.attr('data-held', (stories.blocks['hold']) ? 'true' : 'false');
  stories.last_tick = performance.now();
  if (stories.audio) {
    if (stories_running()) {
      stories.audio.muted = stories.muted;
      var promise = stories.audio.play();
      if (promise && promise.catch) {
        promise.catch(function (error) {
          /* the browser needs a tap before it plays with sound */
          if (error && error.name == 'NotAllowedError') {
            stories_set_muted(true);
          }
        });
      }
    } else {
      stories.audio.pause();
    }
  }
  if (!stories.video) {
    return;
  }
  if (stories_running()) {
    stories_play_video();
  } else {
    stories.video.pause();
  }
}


// stories play video
function stories_play_video() {
  var video = stories.video;
  video.muted = stories.muted || !!stories.audio;
  var promise = video.play();
  if (promise && promise.catch) {
    promise.catch(function (error) {
      /* the browser needs a tap before it plays with sound */
      if (error && error.name == 'NotAllowedError' && !video.muted) {
        stories_set_muted(true);
        var retry = video.play();
        if (retry && retry.catch) {
          retry.catch(function () { });
        }
      }
    });
  }
}


// stories set muted
function stories_set_muted(muted) {
  stories.muted = muted;
  try {
    sessionStorage.setItem('stories_muted', (muted) ? '1' : '0');
  } catch (e) { }
  if (stories.viewer) {
    stories.viewer.attr('data-muted', (muted) ? 'true' : 'false');
  }
  if (stories.video) {
    stories.video.muted = muted || !!stories.audio;
  }
  if (stories.audio) {
    stories.audio.muted = muted;
  }
}


// stories tick
function stories_tick(now) {
  if (!stories.viewer) {
    return;
  }
  if (stories_running()) {
    if (stories.video) {
      stories.elapsed = stories.video.currentTime * 1000;
      if (isFinite(stories.video.duration) && stories.video.duration > 0) {
        stories.duration = stories.video.duration * 1000;
        if (stories.data.video_max > 0) {
          stories.duration = Math.min(stories.duration, stories.data.video_max * 1000);
        }
      }
    } else {
      stories.elapsed += now - stories.last_tick;
    }
    var ratio = (stories.duration) ? Math.min(1, stories.elapsed / stories.duration) : 0;
    stories.viewer.find('.js_story-bar').eq(stories.index).css('width', (ratio * 100) + '%');
    if (ratio >= 1 || (stories.video && stories.video.ended)) {
      stories.last_tick = now;
      stories_next();
      stories.frame = requestAnimationFrame(stories_tick);
      return;
    }
  }
  stories.last_tick = now;
  stories.frame = requestAnimationFrame(stories_tick);
}


// stories stop
function stories_stop() {
  stories.token++;
  stories.ready = false;
  if (stories.video) {
    stories.video.pause();
    stories.video.removeAttribute('src');
    stories.video.load();
    stories.video = null;
  }
  if (stories.audio) {
    stories.audio.pause();
    stories.audio = null;
  }
}


// stories status
function stories_status(message) {
  var status = stories.viewer.find('.js_story-status');
  status.text(message).attr('data-show', 'true');
  clearTimeout(stories.status_timer);
  stories.status_timer = setTimeout(function () {
    status.attr('data-show', 'false');
  }, 1800);
}


// stories open
function stories_open(users, user_id, story_id, highlight_id, archive_id) {
  if (stories.viewer) {
    stories_close();
  }
  stories.viewer = $(render_template('#story-viewer', {}));
  stories.blocks = {};
  stories.cache = {};
  stories.data = null;
  try {
    stories.muted = sessionStorage.getItem('stories_muted') == '1';
  } catch (e) {
    stories.muted = false;
  }
  stories.viewer.attr('data-muted', (stories.muted) ? 'true' : 'false');
  stories.player = new Audio();
  stories.player.loop = true;
  stories.player.preload = 'auto';
  $(stories.player).on('error', function () {
    var item = stories_item();
    if (!item || !item.music || stories.audio !== stories.player || item.music.refreshed || item.music.provider != 'itunes') {
      return;
    }
    item.music.refreshed = true;
    $.post(api['stories/music'], { 'do': 'refresh', 'id': item.music.music_id }, function (response) {
      if (response && response.track && stories_item() === item) {
        item.music.source = response.track.source;
        stories.player.src = item.music.source;
        stories_sync();
      }
    }, 'json');
  });
  stories_load_fonts(stories.viewer.attr('data-fonts'));
  $('body').addClass('overflow-hidden').append(stories.viewer);
  stories.last_tick = performance.now();
  stories.frame = requestAnimationFrame(stories_tick);
  if (story_id || highlight_id || archive_id) {
    stories.users = [];
    stories.user_index = 0;
    stories_load((archive_id) ? { 'do': 'archive', 'id': archive_id } : ((highlight_id) ? { 'do': 'highlight', 'id': highlight_id } : { 'do': 'story', 'id': story_id }), 1);
  } else {
    stories.users = users;
    stories.user_index = Math.max(0, $.inArray(user_id, users));
    stories_load({ 'do': 'user', 'id': users[stories.user_index] }, 1);
  }
}


// stories close
function stories_close() {
  if (!stories.viewer) {
    return;
  }
  stories.request++;
  stories_stop();
  if (stories.player) {
    $(stories.player).off('error');
    stories.player.removeAttribute('src');
    stories.player = null;
  }
  cancelAnimationFrame(stories.frame);
  clearTimeout(stories.status_timer);
  stories.viewer.remove();
  stories.viewer = null;
  stories.data = null;
  if (!$('body').hasClass('lightbox-open')) {
    $('body').removeClass('overflow-hidden');
  }
}


// stories load
function stories_load(params, direction) {
  stories_stop();
  var request = ++stories.request;
  var viewer = stories.viewer;
  viewer.attr({ 'data-loading': 'true', 'data-sheet': 'false' });
  delete stories.blocks['sheet'];
  var done = function (response) {
    if (request != stories.request || !stories.viewer) {
      return;
    }
    if (response.callback) {
      stories_close();
      eval(response.callback);
      return;
    }
    if (!response.items || response.items.length == 0) {
      /* nothing to show for this user */
      if (params['do'] == 'user') {
        delete stories.cache[params['id']];
        if (stories_step_user(direction)) {
          return;
        }
      }
      stories_close();
      return;
    }
    if (params['do'] == 'user') {
      stories.cache[response.user.id] = response;
    }
    stories.data = response;
    var start = 0;
    if (params['do'] != 'user') {
      stories.users = [response.user.id];
      stories.user_index = 0;
      start = response.start;
    } else {
      $.each(response.items, function (index, item) {
        if (!item.seen) {
          start = index;
          return false;
        }
      });
    }
    stories_render_user();
    stories_show(start);
  };
  if (params['do'] == 'user' && stories.cache[params['id']]) {
    done(stories.cache[params['id']]);
    return;
  }
  $.getJSON(api['stories/load'], params, done).fail(function () {
    if (request == stories.request) {
      stories_close();
      show_error_modal();
    }
  });
}


// stories step user
function stories_step_user(direction) {
  var index = stories.user_index + direction;
  if (index < 0 || index >= stories.users.length) {
    return false;
  }
  stories.user_index = index;
  stories_load({ 'do': 'user', 'id': stories.users[index] }, direction);
  return true;
}


// stories render user
function stories_render_user() {
  var viewer = stories.viewer;
  var data = stories.data;
  viewer.attr({
    'data-owner': (data.is_me) ? 'true' : 'false',
    'data-manage': (data.can_manage) ? 'true' : 'false',
    'data-reply': (data.can_reply) ? 'true' : 'false',
    'data-react': (data.can_react) ? 'true' : 'false',
    'data-highlightable': (data.can_highlight) ? 'true' : 'false',
    'data-repost': (data.can_repost) ? 'true' : 'false'
  });
  viewer.find('.js_story-user-picture').attr('src', data.user.picture);
  viewer.find('.js_story-user-name').text(data.user.fullname).attr('title', data.user.fullname);
  viewer.find('.js_story-user-link').attr('href', data.user.url);
  viewer.find('.js_story-reply input').val('');
  var progress = viewer.find('.js_story-progress').empty();
  $.each(data.items, function () {
    progress.append('<div class="h-0.5 flex-1 overflow-hidden rounded-full bg-white/35"><div class="js_story-bar h-full w-0 rounded-full bg-white"></div></div>');
  });
  viewer.find('.js_story-user-prev').prop('disabled', stories.user_index <= 0);
  viewer.find('.js_story-user-next').prop('disabled', stories.user_index >= stories.users.length - 1);
}


// stories show
function stories_show(index) {
  stories_stop();
  var token = stories.token;
  var viewer = stories.viewer;
  var item = stories.data.items[index];
  stories.index = index;
  stories.elapsed = 0;
  viewer.attr({ 'data-loading': 'true', 'data-video': (item.type == 'video') ? 'true' : 'false', 'data-sound': (item.type == 'video' || item.music) ? 'true' : 'false' });
  /* music */
  var music_link = viewer.find('.js_story-music').toggleClass('hidden', !item.music).removeAttr('href');
  if (item.music) {
    var music_label = item.music.title + ((item.music.artist) ? ' · ' + item.music.artist : '');
    music_link.find('.truncate').text(music_label).attr('title', music_label);
    if (item.music.url) {
      music_link.attr('href', item.music.url);
    }
    stories.audio = stories.player;
    stories.audio.src = item.music.source;
  }
  /* progress */
  viewer.find('.js_story-bar').each(function (i) {
    $(this).css('width', (i < index) ? '100%' : '0%');
  });
  /* time */
  var time = moment(item.time, ["YYYY-MM-DD HH:mm:ss", "YYYY-MM-DD H:mm:ss", moment.ISO_8601]).add({ minutes: moment().utcOffset() }).locale($('html').data('lang') || 'en-us');
  viewer.find('.js_story-time').text(((stories.data.highlight) ? stories.data.highlight.title + ' · ' : '') + time.fromNow() + ((item.privacy == 'close_friends') ? ' · ' + __['Close Friends'] : ''));
  viewer.find('.js_story-highlight').data('url', 'stories/highlights.php?do=manage&story_id=' + item.id);
  viewer.find('.js_story-report').data('url', 'data/report.php?do=create&handle=story&id=' + item.id);
  /* counters */
  viewer.find('.js_story-views-count').text(item.views_count || 0);
  viewer.find('.js_story-reactions-count').text(item.reactions_count || 0);
  /* reaction */
  viewer.find('.js_story-react').each(function () {
    $(this).attr('aria-pressed', ($(this).data('reaction') == item.reaction) ? 'true' : 'false');
  });
  /* media */
  var media = viewer.find('.js_story-media').empty().css('filter', stories_filters[item.filter] || '');
  var layers = viewer.find('.js_story-layers').empty();
  var ambient = viewer.find('.js_story-ambient');
  viewer.find('.js_story-backdrop').attr('class', 'js_story-backdrop absolute inset-0 -z-10 ' + ((item.type == 'text') ? (stories_backgrounds[item.background] || stories_backgrounds['aurora']) : ''));
  viewer.find('.js_story-drawing').toggleClass('hidden', !item.drawing).attr('src', item.drawing || 'data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==');
  var ready = function (duration) {
    if (token != stories.token) {
      return;
    }
    viewer.attr('data-loading', 'false');
    stories_render_layers(layers, item.layers, stories_context(item));
    stories.duration = duration;
    stories.ready = true;
    stories_sync();
    stories_seen(item);
  };
  var failed = function () {
    if (token == stories.token) {
      stories_next();
    }
  };
  if (item.type == 'video') {
    var video = document.createElement('video');
    video.playsInline = true;
    video.preload = 'auto';
    video.muted = stories.muted;
    if (item.thumbnail) {
      video.poster = item.thumbnail;
      ambient.attr('src', item.thumbnail).removeClass('hidden');
    } else {
      ambient.addClass('hidden');
    }
    $(video).one('loadedmetadata', function () {
      ready((isFinite(video.duration) ? video.duration : 15) * 1000);
    }).on('waiting', function () {
      if (token == stories.token) viewer.attr('data-loading', 'true');
    }).on('playing', function () {
      if (token == stories.token) viewer.attr('data-loading', 'false');
    }).one('error', failed);
    stories.video = video;
    video.src = item.source;
    media.append(video);
  } else if (item.type == 'photo') {
    var image = new Image();
    image.alt = '';
    image.draggable = false;
    image.onload = function () {
      ready(item.duration * 1000);
    };
    image.onerror = failed;
    image.src = item.source;
    ambient.attr('src', item.source).removeClass('hidden');
    media.append(image);
  } else {
    ambient.addClass('hidden');
    ready(item.duration * 1000);
  }
}


// stories seen
function stories_seen(item) {
  if (stories.data.is_me || item.seen) {
    return;
  }
  item.seen = true;
  $.post(api['stories/action'], { 'do': 'view', 'id': item.id }, null, 'json');
  var unseen = $.grep(stories.data.items, function (story) {
    return !story.seen;
  });
  if (unseen.length == 0) {
    $('.js_stories [data-user-id="' + stories.data.user.id + '"], .js_story-ring[data-user-id="' + stories.data.user.id + '"]').attr('data-seen', 'true');
  }
}


// stories next
function stories_next() {
  if (!stories.data) {
    return;
  }
  if (stories.index < stories.data.items.length - 1) {
    stories_show(stories.index + 1);
  } else if (!stories_step_user(1)) {
    stories_close();
  }
}


// stories prev
function stories_prev() {
  if (!stories.data) {
    return;
  }
  if (stories.index > 0) {
    stories_show(stories.index - 1);
  } else if (!stories_step_user(-1)) {
    stories_show(0);
  }
}


// stories viewers
function stories_viewers(page) {
  var viewer = stories.viewer;
  var item = stories_item();
  var list = viewer.find('.js_story-sheet-list');
  var more = viewer.find('.js_story-sheet-more').parent();
  var loader = viewer.find('.js_story-sheet-loader');
  if (page == 0) {
    list.empty();
    viewer.find('.js_story-sheet-empty').addClass('hidden').removeClass('flex');
  }
  stories.viewers_page = page;
  more.addClass('hidden');
  loader.removeClass('hidden');
  $.getJSON(api['stories/load'], { 'do': 'viewers', 'id': item.id, 'offset': page }, function (response) {
    if (!stories.viewer || stories_item() !== item) {
      return;
    }
    loader.addClass('hidden');
    if (response.callback) {
      eval(response.callback);
      return;
    }
    item.views_count = response.views_count;
    item.reactions_count = response.reactions_count;
    viewer.find('.js_story-views-count').text(response.views_count);
    viewer.find('.js_story-reactions-count').text(response.reactions_count);
    viewer.find('.js_story-sheet-count').text(response.views_count);
    list.append(response.viewers);
    more.toggleClass('hidden', !response.more);
    if (page == 0 && response.count == 0) {
      viewer.find('.js_story-sheet-empty').removeClass('hidden').addClass('flex');
    }
  }).fail(function () {
    loader.addClass('hidden');
  });
}


$(function () {

  // open stories
  $('body').on('click', '.js_story-open', function (e) {
    e.preventDefault();
    var story_id = $(this).data('story-id');
    var highlight_id = $(this).data('highlight-id');
    var archive_id = $(this).data('archive-id');
    if (story_id || highlight_id || archive_id) {
      stories_open([], null, story_id, highlight_id, archive_id);
      return;
    }
    var users = [];
    $('.js_stories .js_story-open[data-user-id]').each(function () {
      var id = parseInt($(this).attr('data-user-id'));
      if ($.inArray(id, users) == -1) {
        users.push(id);
      }
    });
    var user_id = parseInt($(this).attr('data-user-id'));
    stories_open(($.inArray(user_id, users) == -1) ? [user_id] : users, user_id);
  });
  /* open the story from the url */
  var story_param = new URLSearchParams(window.location.search).get('story');
  if (story_param && /^\d+$/.test(story_param)) {
    var url = new URL(window.location.href);
    url.searchParams.delete('story');
    history.replaceState(history.state, '', url.pathname + url.search + url.hash);
    stories_open([], null, parseInt(story_param));
  }


  // stories thumbnails
  $('.js_story-thumb[data-layers]').each(function () {
    var thumb = $(this);
    var layers = [];
    try {
      layers = JSON.parse(thumb.attr('data-layers'));
    } catch (e) { }
    var fonts = $.grep(layers, function (layer) {
      return layer.type == 'text' && layer.font != 'modern';
    });
    if (fonts.length > 0) {
      stories_load_fonts(thumb.attr('data-fonts'));
    }
    var container = $('<span class="absolute inset-0 block"></span>').appendTo(thumb.removeAttr('data-layers'));
    stories_render_layers(container, layers, { 'results': false });
  });


  // stories strip
  function stories_strip() {
    $('.js_stories').each(function () {
      var strip = $(this).find('.js_stories-strip')[0];
      var max = strip.scrollWidth - strip.clientWidth;
      var position = Math.abs(strip.scrollLeft);
      $(this).find('.js_stories-prev').prop('disabled', position <= 1);
      $(this).find('.js_stories-next').prop('disabled', position >= max - 1);
    });
  }
  $('.js_stories-strip').on('scroll', stories_strip);
  $(window).on('resize', stories_strip);
  stories_strip();
  $('body').on('click', '.js_stories-prev, .js_stories-next', function () {
    var strip = $(this).closest('.js_stories').find('.js_stories-strip')[0];
    var direction = ($(this).hasClass('js_stories-next')) ? 1 : -1;
    if (stories_rtl()) {
      direction = -direction;
    }
    strip.scrollBy({ 'left': Math.max(160, Math.round(strip.clientWidth * 0.8)) * direction, 'behavior': 'smooth' });
  });


  // drag sheets
  var sheet_drag = null;
  $('body').on('pointerdown', '.js_sheet-grab', function (e) {
    var event = e.originalEvent;
    if (!event.isPrimary || event.button > 0) {
      return;
    }
    sheet_drag = { 'sheet': $(this).closest('.js_sheet')[0], 'y': event.clientY, 'time': Date.now(), 'moved': 0 };
    sheet_drag.sheet.style.transition = 'none';
    try {
      this.setPointerCapture(event.pointerId);
    } catch (error) { }
  });
  $('body').on('pointermove', '.js_sheet-grab', function (e) {
    if (!sheet_drag) {
      return;
    }
    sheet_drag.moved = Math.max(0, e.originalEvent.clientY - sheet_drag.y);
    sheet_drag.sheet.style.translate = '0 ' + sheet_drag.moved + 'px';
  });
  $('body').on('pointerup pointercancel', '.js_sheet-grab', function () {
    if (!sheet_drag) {
      return;
    }
    var sheet = sheet_drag.sheet;
    var close = sheet_drag.moved > 120 || (sheet_drag.moved > 40 && Date.now() - sheet_drag.time < 250);
    sheet_drag = null;
    sheet.style.transition = '';
    sheet.style.translate = '';
    if (close) {
      $(sheet).find('.js_composer-panel-close, .js_story-sheet-close').first().trigger('click');
    }
  });


  // create story
  $('body').on('click', '.js_story-create', function (e) {
    e.preventDefault();
    var _this = $(this);
    if (_this.data('loading')) {
      return;
    }
    _this.data('loading', true);
    load_script(stories_composer_script).then(function () {
      $.getJSON(api['stories/publish'], { 'do': 'create' }, function (response) {
        _this.removeData('loading');
        if (response.callback) {
          eval(response.callback);
        }
      }).fail(function () {
        _this.removeData('loading');
        show_error_modal();
      });
    }, function () {
      _this.removeData('loading');
      show_error_modal();
    });
  });


  // close stories
  $('body').on('click', '.js_story-close', function () {
    stories_close();
  });
  $('body').on('click', '.js_story-viewer', function (e) {
    if ($(e.target).is('.js_story-viewer')) {
      stories_close();
    }
  });


  // stories navigation
  $('body').on('click', '.js_story-user-prev', function () {
    stories_step_user(-1);
  });
  $('body').on('click', '.js_story-user-next', function () {
    stories_step_user(1);
  });
  $('body').on('click', '.js_story-toggle', function () {
    stories_block('user', !stories.blocks['user']);
  });
  $('body').on('click', '.js_story-mute', function () {
    stories_set_muted(!stories.muted);
    stories_sync();
  });


  // stories gestures
  var pointer = null;
  $('body').on('pointerdown', '.js_story-surface', function (e) {
    if (e.button !== undefined && e.button > 0) {
      return;
    }
    pointer = { 'id': e.pointerId, 'x': e.clientX, 'y': e.clientY, 'held': false };
    pointer.timer = setTimeout(function () {
      if (pointer) {
        pointer.held = true;
        stories_block('hold', true);
      }
    }, 220);
    try {
      this.setPointerCapture(e.pointerId);
    } catch (error) { }
  });
  $('body').on('pointerup pointercancel', '.js_story-surface', function (e) {
    if (!pointer || pointer.id != e.pointerId) {
      return;
    }
    var gesture = pointer;
    pointer = null;
    clearTimeout(gesture.timer);
    if (gesture.held) {
      stories_block('hold', false);
    }
    if (e.type == 'pointercancel' || !stories.data) {
      return;
    }
    var delta_x = e.clientX - gesture.x;
    var delta_y = e.clientY - gesture.y;
    var forward = (stories_rtl()) ? -1 : 1;
    if (delta_y > 80 && Math.abs(delta_y) > Math.abs(delta_x)) {
      stories_close();
    } else if (Math.abs(delta_x) > 60 && Math.abs(delta_x) > Math.abs(delta_y)) {
      stories_step_user((delta_x < 0) ? forward : -forward);
    } else if (!gesture.held && Math.abs(delta_x) < 10 && Math.abs(delta_y) < 10) {
      var rect = this.getBoundingClientRect();
      var ratio = (e.clientX - rect.left) / rect.width;
      if (stories_rtl()) {
        ratio = 1 - ratio;
      }
      if (ratio < 0.3) {
        stories_prev();
      } else {
        stories_next();
      }
    }
  });
  $('body').on('contextmenu', '.js_story-surface', function (e) {
    e.preventDefault();
  });
  $(document).on('keydown', function (e) {
    if (!stories.viewer || $('#modal.open, #modal-stacked.open').length > 0) {
      return;
    }
    if (e.key == 'Escape') {
      if (stories.blocks['sheet']) {
        stories.viewer.attr('data-sheet', 'false');
        stories_block('sheet', false);
      } else {
        stories_close();
      }
      return;
    }
    if ($(e.target).is('input, textarea, [contenteditable]')) {
      return;
    }
    var forward = (stories_rtl()) ? 'ArrowLeft' : 'ArrowRight';
    var backward = (stories_rtl()) ? 'ArrowRight' : 'ArrowLeft';
    if (e.key == forward) {
      stories_next();
    } else if (e.key == backward) {
      stories_prev();
    } else if (e.key == ' ') {
      e.preventDefault();
      stories_block('user', !stories.blocks['user']);
    }
  });


  // pause stories
  $(document).on('visibilitychange', function () {
    if (stories.viewer) {
      stories_block('hidden', document.visibilityState == 'hidden');
    }
  });
  $('body').on('open.overlay', '#modal', function () {
    if (stories.viewer) {
      stories_block('modal', true);
    }
  });
  $('body').on('close.overlay', '#modal', function () {
    if (stories.viewer) {
      stories_block('modal', false);
    }
  });


  // react story
  $('body').on('click', '.js_story-react', function () {
    var item = stories_item();
    if (!item) {
      return;
    }
    var reaction = $(this).data('reaction');
    var undo = (item.reaction == reaction);
    item.reaction = (undo) ? '' : reaction;
    stories.viewer.find('.js_story-react').each(function () {
      $(this).attr('aria-pressed', ($(this).data('reaction') == item.reaction) ? 'true' : 'false');
    });
    $.post(api['stories/action'], { 'do': (undo) ? 'unreact' : 'react', 'id': item.id, 'reaction': reaction }, function (response) {
      if (response && response.callback) {
        eval(response.callback);
      }
    }, 'json');
  });


  // vote story
  $('body').on('click', '.js_story-viewer .js_story-vote', function () {
    var item = stories_item();
    if (!item || stories.data.is_me) {
      return;
    }
    var option = parseInt($(this).attr('data-option'));
    $.post(api['stories/action'], { 'do': 'vote', 'id': item.id, 'option': option }, function (response) {
      if (response && response.callback) {
        eval(response.callback);
        return;
      }
      if (response && response.poll && stories_item() === item) {
        item.poll = response.poll;
        stories_render_layers(stories.viewer.find('.js_story-layers'), item.layers, stories_context(item));
      }
    }, 'json');
  });


  // repost story
  $('body').on('click', '.js_story-repost', function () {
    var item = stories_item();
    var button = $(this);
    if (!item || button.prop('disabled')) {
      return;
    }
    button.prop('disabled', true);
    $.post(api['stories/action'], { 'do': 'repost', 'id': item.id }, function (response) {
      button.prop('disabled', false);
      if (response && response.callback) {
        eval(response.callback);
        return;
      }
      if (stories.viewer) {
        stories_status(__['Story reposted']);
      }
    }, 'json')
      .fail(function () {
        button.prop('disabled', false);
        show_error_modal();
      });
  });

  // story highlights
  $('body').on('click', '.js_story-highlight-delete', function () {
    var url = $(this).attr('data-url');
    confirm(__['Delete'], __['Are you sure you want to delete this?'], function () {
      $.post(ajax_path + url, function (response) {
        modal_close(function () {
          if (response && response.callback) {
            eval(response.callback);
          }
        });
      }, 'json')
        .fail(function () {
          show_error_modal();
        });
    });
  });


  // story audience
  var audience_timer = null;
  $('body').on('input', '.js_story-audience-search', function () {
    var input = $(this);
    var results = input.closest('.js_story-audience').find('.js_story-audience-results');
    var term = input.val().trim().replace(/^@/, '');
    clearTimeout(audience_timer);
    if (term == '') {
      results.empty();
      return;
    }
    audience_timer = setTimeout(function () {
      $.getJSON(api['users/mentions'], { 'term': term }, function (response) {
        if (!Array.isArray(response) || input.val().trim().replace(/^@/, '') != term) {
          return;
        }
        results.empty();
        $.each(response, function (index, item) {
          var row = $('<button type="button" class="js_story-audience-add flex items-center gap-3 rounded-xl p-2 text-start transition hover:bg-base-200"><img class="size-9 shrink-0 rounded-full object-cover" alt=""><span class="min-w-0 flex-1 truncate text-sm font-semibold"></span><span class="icon-[tabler--plus] size-5 shrink-0 text-primary" aria-hidden="true"></span></button>');
          row.attr('data-id', item.id).find('img').attr('src', item.img);
          row.find('.truncate').text(item.label).attr('title', item.label);
          results.append(row);
        });
      });
    }, 200);
  });
  $('body').on('click', '.js_story-audience-add', function () {
    var type = $(this).closest('.js_story-audience').attr('data-type');
    $.post(ajax_path + 'stories/audience.php?do=add&type=' + type, { 'id': $(this).attr('data-id') }, function (response) {
      if (response && response.callback) {
        eval(response.callback);
      }
    }, 'json')
      .fail(function () {
        show_error_modal();
      });
  });


  // reply story
  $('body').on('focus', '.js_story-reply input', function () {
    stories_block('typing', true);
  });
  $('body').on('blur', '.js_story-reply input', function () {
    stories_block('typing', false);
  });
  $('body').on('submit', '.js_story-reply', function (e) {
    e.preventDefault();
    var item = stories_item();
    var input = $(this).find('input');
    var button = $(this).find('button');
    var message = input.val().trim();
    if (!item || message == '' || button.prop('disabled')) {
      return;
    }
    var data = { 'message': message, 'recipients': JSON.stringify([stories.data.user.id]), 'story_id': item.id };
    var timer = null;
    var done = function (response) {
      clearTimeout(timer);
      button.prop('disabled', false);
      if (!response || !stories.viewer) {
        return;
      }
      if (response.callback) {
        eval(response.callback);
        return;
      }
      input.val('').trigger('blur');
      stories_status(__['Reply sent']);
    };
    button.prop('disabled', true);
    if (typeof chat_socket !== 'undefined' && chat_socket_enabled && chat_socket) {
      /* using socket */
      timer = setTimeout(function () {
        button.prop('disabled', false);
      }, 8000);
      chat_socket.emit('event_client_send_message', data, function (response) {
        done(JSON.parse(response));
      });
    } else {
      /* using ajax */
      $.post(api['chat/post'], data, done, 'json').fail(function () {
        button.prop('disabled', false);
        show_error_modal();
      });
    }
  });


  // story viewers
  $('body').on('click', '.js_story-viewers-open', function () {
    stories.viewer.attr('data-sheet', 'true');
    stories_block('sheet', true);
    stories_viewers(0);
  });
  $('body').on('click', '.js_story-sheet-close, .js_story-sheet-backdrop', function () {
    stories.viewer.attr('data-sheet', 'false');
    stories_block('sheet', false);
  });
  $('body').on('click', '.js_story-sheet-more', function () {
    stories_viewers(stories.viewers_page + 1);
  });


  // delete story
  $('body').on('click', '.js_story-delete', function () {
    var item = stories_item();
    if (!item) {
      return;
    }
    var data = stories.data;
    confirm(__['Delete'], __['Are you sure you want to delete this?'], function () {
      $.post(api['stories/action'], { 'do': 'delete', 'id': item.id }, function (response) {
        if (response && response.callback) {
          eval(response.callback);
          return;
        }
        modal_close();
        $('.js_story-open[data-archive-id="' + item.id + '"]').remove();
        if (!stories.viewer || stories.data !== data) {
          return;
        }
        data.items = $.grep(data.items, function (story) {
          return story.id != item.id;
        });
        if (data.items.length == 0) {
          delete stories.cache[data.user.id];
          $('.js_stories [data-user-id="' + data.user.id + '"]').closest('.js_story-slide').addClass('hidden');
          stories_strip_refresh();
          if (!stories_step_user(1)) {
            stories_close();
          }
          return;
        }
        stories_render_user();
        stories_show(Math.min(stories.index, data.items.length - 1));
      }, 'json')
        .fail(function () {
          show_error_modal();
        });
    });
  });

});
