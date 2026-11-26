/**
 * stories composer js
 *
 * @package Sngine
 * @author Zamblek
 */

// initialize composer
var composer = null;
var composer_colors = ['#ffffff', '#000000', '#9ca3af', '#ef4444', '#f97316', '#f59e0b', '#eab308', '#84cc16', '#22c55e', '#10b981', '#14b8a6', '#06b6d4', '#0ea5e9', '#3b82f6', '#6366f1', '#8b5cf6', '#a855f7', '#d946ef', '#ec4899'];
var composer_emojis = ['😀', '😂', '🥹', '😍', '🥰', '😘', '😎', '🤩', '🥳', '😇', '🤔', '😴', '😭', '😡', '🤯', '🥶', '😱', '🤗', '🙌', '👏', '👍', '🙏', '💪', '✌️', '🤝', '👀', '❤️', '🧡', '💛', '💚', '💙', '💜', '🖤', '💔', '💯', '🔥', '✨', '⭐', '🌈', '☀️', '🌙', '⚡', '🎉', '🎂', '🎁', '🎈', '🏆', '⚽', '🎵', '🎬', '📸', '✈️', '🏖️', '🌍', '🍕', '🍔', '☕', '🍰', '🌹', '🌸', '🐶', '🐱', '👑'];
var composer_brush_sizes = [4, 9, 16, 26];
var composer_blank = 'data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==';


// composer swatches
function composer_swatches(container, name, colors, selected) {
  container.empty();
  $.each(colors, function (index, color) {
    var swatch = $('<button type="button" class="size-8 shrink-0 rounded-full border-2 border-white/50 transition aria-pressed:scale-110 aria-pressed:border-white aria-pressed:ring-2 aria-pressed:ring-white/60"></button>');
    swatch.addClass(name).attr({ 'data-color': color, 'aria-pressed': (color == selected) ? 'true' : 'false', 'aria-label': color || 'none' });
    if (color) {
      swatch.css('background-color', color);
    } else {
      swatch.addClass('flex items-center justify-center bg-neutral-800').append('<span class="icon-[tabler--ban] size-4 text-white" aria-hidden="true"></span>');
    }
    container.append(swatch);
  });
}


// composer rows
function composer_rows() {
  if (!composer) {
    return;
  }
  composer.root.find('.js_composer-row').each(function () {
    var row = $(this);
    var strip = row.find('.js_composer-row-strip')[0];
    var nav = row.find('.js_composer-row-nav');
    nav.attr('data-scrollable', (strip.scrollWidth - strip.clientWidth > 1 || Math.abs(strip.scrollLeft) > 1) ? 'true' : 'false');
    var max = strip.scrollWidth - strip.clientWidth;
    var position = Math.abs(strip.scrollLeft);
    row.find('.js_composer-row-prev').prop('disabled', position <= 1);
    row.find('.js_composer-row-next').prop('disabled', position >= max - 1);
  });
}


// composer pressed
function composer_pressed(selector, attribute, value) {
  composer.root.find(selector).each(function () {
    $(this).attr('aria-pressed', (String($(this).attr(attribute) || '') == String(value)) ? 'true' : 'false');
  });
}


// composer open
function stories_composer_open(config) {
  if (composer) {
    return;
  }
  if (stories.viewer) {
    stories_close();
  }
  var root = $(render_template('#story-composer', {}));
  composer = {
    'root': root,
    'config': config,
    'type': '',
    'file': null,
    'url': null,
    'layers': [],
    'selected': -1,
    'editing': -1,
    'text': null,
    'background': 'aurora',
    'filter': '',
    'strokes': [],
    'brush': { 'tool': 'brush', 'color': '#ffffff', 'size': composer_brush_sizes[1] },
    'drag': null,
    'stroke': null,
    'mention_timer': null,
    'privacy': 'public',
    'video_muted': false,
    'music': null,
    'music_tab': 'trending',
    'music_timer': null,
    'music_request': 0,
    'music_loaded': false,
    'player': new Audio(),
    'busy': false
  };
  root.attr({ 'data-admin': (config.is_admin) ? 'true' : 'false', 'data-videos': (config.can_upload_videos) ? 'true' : 'false', 'data-music': (config.music) ? 'true' : 'false', 'data-library': (config.music_library) ? 'true' : 'false', 'data-friends': (config.friends_enabled) ? 'true' : 'false', 'data-text': (config.text) ? 'true' : 'false', 'data-polls': (config.polls) ? 'true' : 'false' });
  var privacy = 'public';
  try {
    privacy = localStorage.getItem('stories_privacy') || 'public';
  } catch (e) { }
  composer_set_privacy(($.inArray(privacy, ['public', 'friends', 'close_friends']) == -1) ? 'public' : privacy);
  $(composer.player).on('ended pause', function () {
    if (composer && composer.player.paused) {
      composer.root.find('.js_composer-music-play').attr('aria-pressed', 'false');
    }
  });
  $(composer.player).on('play pause ended', function () {
    if (composer) {
      composer_video_sound();
    }
  });
  root.find('.js_composer-file').attr('accept', 'image/png,image/jpeg,image/webp,image/gif' + ((config.can_upload_videos) ? ',video/*' : ''));
  /* emojis */
  var emojis = root.find('.js_composer-emojis');
  $.each(composer_emojis, function (index, emoji) {
    emojis.append($('<button type="button" class="js_composer-emoji flex aspect-square items-center justify-center rounded-xl text-3xl leading-none transition hover:bg-white/10 active:scale-90"></button>').text(emoji));
  });
  /* backgrounds */
  var backgrounds = root.find('.js_composer-backgrounds');
  $.each(stories_backgrounds, function (key, classes) {
    backgrounds.append($('<button type="button" class="js_composer-background size-11 shrink-0 rounded-full border-2 border-white/50 transition aria-pressed:scale-110 aria-pressed:border-white aria-pressed:ring-2 aria-pressed:ring-white/60"></button>').addClass(classes).attr({ 'data-background': key, 'aria-pressed': 'false', 'aria-label': key }));
  });
  /* brush */
  composer_swatches(root.find('.js_composer-brush-colors'), 'js_composer-brush-color', composer_colors, composer.brush.color);
  var sizes = root.find('.js_composer-brush-sizes');
  $.each(composer_brush_sizes, function (index, size) {
    sizes.append($('<button type="button" class="js_composer-brush-size flex size-10 items-center justify-center rounded-full transition aria-pressed:bg-white/20"><span class="block rounded-full bg-white"></span></button>').attr({ 'data-size': size, 'aria-pressed': (size == composer.brush.size) ? 'true' : 'false', 'aria-label': size }).find('span').css({ 'width': size, 'height': size }).end());
  });
  stories_load_fonts(root.attr('data-fonts'));
  $('body').addClass('overflow-hidden').append(root);
  root.find('.js_composer-row-strip').on('scroll', composer_rows);
  $(window).on('resize.composer', composer_rows);
}


// composer destroy
function composer_destroy() {
  if (!composer) {
    return;
  }
  $(document).off('.composer');
  $(window).off('resize.composer');
  $(composer.player).off('play ended pause');
  composer.player.pause();
  clearTimeout(composer.music_timer);
  if (composer.url) {
    URL.revokeObjectURL(composer.url);
  }
  composer.root.remove();
  composer = null;
  if (!$('body').hasClass('lightbox-open')) {
    $('body').removeClass('overflow-hidden');
  }
}


// composer has content
function composer_has_content() {
  return composer.root.attr('data-step') == 'edit' && (composer.type != 'text' || composer.layers.length > 0 || composer.strokes.length > 0);
}


// composer leave
function composer_leave(callback) {
  if (composer.busy) {
    return;
  }
  if (!composer_has_content()) {
    callback();
    return;
  }
  confirm(__['Discard story?'], __['Your story will be lost if you leave now'], function () {
    modal_close();
    if (composer) {
      callback();
    }
  });
}


// composer reset
function composer_reset() {
  var root = composer.root;
  if (composer.url) {
    URL.revokeObjectURL(composer.url);
  }
  composer.type = '';
  composer.file = null;
  composer.url = null;
  composer.layers = [];
  composer.selected = -1;
  composer.editing = -1;
  composer.filter = '';
  composer.strokes = [];
  composer_set_music(null);
  root.find('.js_composer-media').empty().css('filter', '');
  root.find('.js_composer-ambient').addClass('hidden').attr('src', composer_blank);
  root.find('.js_composer-backdrop').attr('class', 'js_composer-backdrop absolute inset-0 -z-10');
  root.find('.js_composer-file').val('');
  root.find('.js_composer-ads').prop('checked', false);
  root.attr('data-ads', 'false');
  composer_draw_all();
  composer_render();
  root.attr({ 'data-step': 'start', 'data-type': '', 'data-panel': '', 'data-chrome': 'true' });
}


// composer panel
function composer_panel(name) {
  composer_select(-1);
  if (name != 'music' && composer.music) {
    composer_music_play();
  } else {
    composer.player.pause();
  }
  composer.root.attr({ 'data-panel': name, 'data-chrome': (name == '') ? 'true' : 'false' });
  composer_rows();
  if (name == 'music' && !composer.music_loaded) {
    composer.music_loaded = true;
    composer_music_load();
  }
  if (name == 'mention') {
    composer.root.find('.js_composer-mention-input').val('').trigger('focus');
    composer.root.find('.js_composer-mention-list').empty();
  } else if (name == 'link') {
    composer.root.find('.js_composer-link-input').val('').trigger('focus');
  }
}


// composer start
function composer_start(type) {
  var root = composer.root;
  composer.type = type;
  root.find('.js_composer-error').addClass('hidden');
  root.attr({ 'data-step': 'edit', 'data-type': type });
  if (type == 'text') {
    composer_set_background(composer.background);
    composer_edit_text(-1);
    return;
  }
  var media = root.find('.js_composer-media').empty();
  var previews = root.find('.js_composer-filter-preview').css('background-image', 'url("' + root.attr('data-filter-sample') + '")');
  if (type == 'photo') {
    media.append($('<img alt="" draggable="false">').attr('src', composer.url));
    root.find('.js_composer-ambient').removeClass('hidden').attr('src', composer.url);
    previews.css('background-image', 'url("' + composer.url + '")');
  } else {
    var video = $('<video loop playsinline></video>').attr('src', composer.url);
    /* use a frame of the video for the filters previews */
    video.on('timeupdate.preview', function () {
      if (this.currentTime < 0.3 || !this.videoWidth) {
        return;
      }
      video.off('timeupdate.preview');
      try {
        var canvas = document.createElement('canvas');
        var ratio = 160 / Math.min(this.videoWidth, this.videoHeight);
        canvas.width = Math.round(this.videoWidth * ratio);
        canvas.height = Math.round(this.videoHeight * ratio);
        canvas.getContext('2d').drawImage(this, 0, 0, canvas.width, canvas.height);
        previews.css('background-image', 'url("' + canvas.toDataURL('image/jpeg', 0.7) + '")');
      } catch (e) { }
    });
    composer.video_muted = false;
    media.append(video);
    composer_video_sound();
    var playing = video[0].play();
    if (playing && playing.catch) {
      playing.catch(function (error) {
        /* the browser needs a tap before it plays with sound */
        if (composer && error && error.name == 'NotAllowedError') {
          composer.video_muted = true;
          composer_video_sound();
          var retry = video[0].play();
          if (retry && retry.catch) {
            retry.catch(function () { });
          }
        }
      });
    }
    video.one('loadedmetadata', function () {
      var max = composer && composer.config.video_max;
      if (max > 0 && isFinite(this.duration) && this.duration > max + 0.5) {
        composer_reset();
        composer.root.find('.js_composer-error').text(__['Your video is too long, the maximum length in seconds is'] + ' ' + max).removeClass('hidden');
      }
    });
  }
  previews.each(function () {
    $(this).css('filter', stories_filters[$(this).closest('.js_composer-filter').attr('data-filter')] || '');
  });
  composer_pressed('.js_composer-filter', 'data-filter', '');
}


// composer set background
function composer_set_background(background) {
  composer.background = background;
  composer.root.find('.js_composer-backdrop').attr('class', 'js_composer-backdrop absolute inset-0 -z-10 ' + stories_backgrounds[background]);
  composer_pressed('.js_composer-background', 'data-background', background);
}


// composer add layer
function composer_add_layer(layer) {
  composer.layers.push($.extend({ 'x': 0.5, 'y': 0.42, 'scale': 1, 'rotation': 0 }, layer));
  composer_panel('');
  composer_render();
  composer_select(composer.layers.length - 1);
}


// composer remove layer
function composer_remove_layer(index) {
  composer.layers.splice(index, 1);
  composer.selected = -1;
  composer_render();
}


// composer render
function composer_render() {
  var container = composer.root.find('.js_composer-layers').empty();
  $.each(composer.layers, function (index, layer) {
    if (index == composer.editing) {
      return;
    }
    var element = stories_layer_element(layer, { 'music': composer.music });
    if (element) {
      container.append(element.attr('data-index', index).addClass('js_composer-layer pointer-events-auto cursor-grab touch-none'));
    }
  });
  composer_select(composer.selected);
}


// composer select
function composer_select(index) {
  var layers = composer.root.find('.js_composer-layer');
  if (index >= 0 && index == composer.selected && layers.filter('[data-index="' + index + '"]').find('.js_composer-layer-handle').length > 0) {
    return;
  }
  composer.selected = index;
  layers.removeClass('outline-2 outline-offset-4 outline-white outline-dashed');
  layers.find('.js_composer-layer-delete, .js_composer-layer-handle').remove();
  if (index < 0) {
    return;
  }
  var element = layers.filter('[data-index="' + index + '"]');
  element.addClass('outline-2 outline-offset-4 outline-white outline-dashed');
  element.append('<button type="button" class="js_composer-layer-delete absolute -end-3.5 -top-3.5 flex size-7 items-center justify-center rounded-full bg-neutral-900 text-white ring-1 ring-white/40 [text-shadow:none]"><span class="icon-[tabler--x] size-4" aria-hidden="true"></span></button>');
  element.append('<span class="js_composer-layer-handle absolute -end-3.5 -bottom-3.5 flex size-7 cursor-nwse-resize items-center justify-center rounded-full bg-neutral-900 text-white ring-1 ring-white/40 [text-shadow:none]"><span class="icon-[tabler--arrows-diagonal] size-4" aria-hidden="true"></span></span>');
}


// composer update layer
function composer_update_layer(index) {
  var layer = composer.layers[index];
  var element = composer.root.find('.js_composer-layer[data-index="' + index + '"]');
  element.css({ 'left': (layer.x * 100) + '%', 'top': (layer.y * 100) + '%', 'rotate': layer.rotation + 'deg' });
  element.css(element.data('size-property'), (element.data('size-base') * layer.scale) + 'cqw');
}


// composer set privacy
function composer_set_privacy(privacy) {
  var root = composer.root;
  composer.privacy = privacy;
  composer_pressed('.js_composer-privacy', 'data-privacy', privacy);
  var options = root.find('.js_composer-privacy[data-privacy="' + privacy + '"]');
  var option = (composer.config.friends_enabled) ? options.first() : options.last();
  root.find('.js_composer-privacy-label').text(option.find('.js_composer-privacy-name').text());
  root.find('.js_composer-privacy-icon').attr('class', 'js_composer-privacy-icon size-4.5 shrink-0 ' + option.attr('data-icon'));
  try {
    localStorage.setItem('stories_privacy', privacy);
  } catch (e) { }
}


// composer video sound
function composer_video_sound() {
  var video = composer.root.find('.js_composer-media video')[0];
  composer.root.attr('data-muted', (composer.video_muted) ? 'true' : 'false');
  if (video) {
    video.muted = composer.video_muted || !!composer.music || !composer.player.paused;
  }
}


// composer set music
function composer_set_music(track) {
  var root = composer.root;
  composer.music = track;
  composer.player.pause();
  composer_video_sound();
  composer.layers = $.grep(composer.layers, function (layer) {
    return layer.type != 'music';
  });
  root.find('.js_composer-music-tool').attr('aria-pressed', (track) ? 'true' : 'false');
  var selected = root.find('.js_composer-music-selected').toggleClass('hidden', !track);
  if (track) {
    selected.find('img').attr('src', track.cover || composer_blank);
    selected.find('.js_composer-music-selected-title').text(track.title).attr('title', track.title);
    selected.find('.js_composer-music-selected-artist').text(track.artist).attr('title', track.artist);
    composer.layers.push({ 'type': 'music', 'x': 0.5, 'y': 0.3, 'scale': 1, 'rotation': 0 });
  }
  composer.selected = -1;
  composer_render();
}


// composer music play
function composer_music_play() {
  var player = composer.player;
  if ($(player).data('track') !== composer.music) {
    $(player).data('track', composer.music);
    player.src = composer.music.source;
    player.currentTime = 0;
  }
  player.loop = true;
  var promise = player.play();
  if (promise && promise.catch) {
    promise.catch(function () { });
  }
}


// composer music render
function composer_music_render(tracks) {
  var root = composer.root;
  var list = root.find('.js_composer-music-list').empty();
  root.find('.js_composer-music-loader').addClass('hidden');
  root.find('.js_composer-music-empty').toggleClass('hidden', tracks.length > 0);
  $.each(tracks, function (index, track) {
    var row = $('<div class="flex items-center gap-3 rounded-xl p-2 transition hover:bg-white/5"><button type="button" class="js_composer-music-play group/play flex size-10 shrink-0 items-center justify-center rounded-full bg-white/10 text-white transition hover:bg-white/20" aria-pressed="false"><span class="icon-[tabler--player-play-filled] size-4.5 group-aria-pressed/play:hidden" aria-hidden="true"></span><span class="icon-[tabler--player-pause-filled] hidden size-4.5 group-aria-pressed/play:block" aria-hidden="true"></span></button><button type="button" class="js_composer-music-pick flex min-w-0 flex-1 items-center gap-3 text-start"><img class="size-11 shrink-0 rounded-lg bg-white/10 object-cover" alt="" loading="lazy"><span class="min-w-0 flex-1"><span class="js_composer-music-title block truncate text-sm font-semibold text-white"></span><span class="js_composer-music-artist block truncate text-xs text-white/65"></span></span><span class="flex shrink-0 flex-col items-end gap-0.5"><span class="js_composer-music-provider rounded-full bg-white/10 px-2 py-0.5 text-[11px] font-medium text-white/70"></span><span class="js_composer-music-uses text-[11px] text-white/50"></span></span></button></div>');
    row.data('track', track);
    row.find('.js_composer-music-play').attr('aria-label', track.title);
    row.find('img').attr('src', track.cover || composer_blank);
    row.find('.js_composer-music-title').text(track.title).attr('title', track.title);
    row.find('.js_composer-music-artist').text(track.artist).attr('title', track.artist);
    row.find('.js_composer-music-provider').text((track.provider == 'itunes') ? 'iTunes' : __['Library']);
    row.find('.js_composer-music-uses').text((track.uses > 0) ? track.uses + ' ' + __['uses'] : '');
    list.append(row);
  });
}


// composer music load
function composer_music_load() {
  var root = composer.root;
  var current = composer;
  var request = ++composer.music_request;
  var query = root.find('.js_composer-music-input').val().trim();
  root.find('.js_composer-music-tabs').toggleClass('hidden', query != '');
  root.find('.js_composer-music-list').empty();
  root.find('.js_composer-music-empty').addClass('hidden');
  root.find('.js_composer-music-loader').removeClass('hidden');
  composer.player.pause();
  var requests = [];
  if (query == '' || composer.config.music_library) {
    requests.push(new Promise(function (resolve) {
      $.getJSON(api['stories/music'], { 'do': 'list', 'tab': composer.music_tab, 'query': query }, function (response) {
        resolve((response && Array.isArray(response.tracks)) ? response.tracks : []);
      }).fail(function () {
        resolve([]);
      });
    }));
  }
  if (query != '' && composer.config.music_itunes) {
    requests.push(fetch('https://itunes.apple.com/search?media=music&entity=song&limit=25&country=' + encodeURIComponent(composer.config.music_country) + '&term=' + encodeURIComponent(query), { 'credentials': 'omit' }).then(function (response) {
      return response.json();
    }).then(function (response) {
      return $.map(response.results || [], function (result) {
        if (!result.previewUrl || !result.trackId) {
          return null;
        }
        return { 'provider': 'itunes', 'id': result.trackId, 'title': result.trackName || '', 'artist': result.artistName || '', 'cover': result.artworkUrl100 || '', 'source': result.previewUrl, 'url': result.trackViewUrl || '', 'uses': 0 };
      });
    }).catch(function () {
      return [];
    }));
  }
  Promise.all(requests).then(function (results) {
    if (composer !== current || request != composer.music_request) {
      return;
    }
    composer_music_render([].concat.apply([], results));
  });
}


// composer text style
function composer_text_style() {
  var text = composer.text;
  var font = stories_fonts[text.font];
  composer.root.find('.js_composer-input').css({
    'color': text.color,
    'background-color': text.background || 'transparent',
    'font-size': (window.matchMedia('(pointer: coarse)').matches) ? 'max(16px, ' + (5.2 * text.scale) + 'cqw)' : (5.2 * text.scale) + 'cqw',
    'font-family': font.family,
    'font-weight': font.weight,
    'font-style': font.style,
    'text-align': text.align,
    'text-shadow': (text.font == 'neon') ? '0 0 0.12em currentColor, 0 0 0.45em currentColor' : 'none'
  });
  composer.root.find('.js_composer-size').val(text.scale);
  composer.root.find('.js_composer-align-icon').removeClass('icon-[tabler--align-center] icon-[tabler--align-left] icon-[tabler--align-right]').addClass((text.align == 'center') ? 'icon-[tabler--align-center]' : ((text.align == 'start') ? 'icon-[tabler--align-left]' : 'icon-[tabler--align-right]'));
  composer_pressed('.js_composer-font', 'data-font', text.font);
  composer_pressed('.js_composer-color', 'data-color', text.color);
  composer_pressed('.js_composer-highlight', 'data-color', text.background);
  composer_rows();
}


// composer edit text
function composer_edit_text(index) {
  var root = composer.root;
  var layer = (index >= 0) ? composer.layers[index] : null;
  composer.text = (layer) ? $.extend({}, layer) : { 'type': 'text', 'text': '', 'color': '#ffffff', 'background': '', 'font': 'modern', 'align': 'center', 'scale': 1, 'x': 0.5, 'y': 0.5, 'rotation': 0 };
  composer.editing = index;
  composer_swatches(root.find('.js_composer-colors'), 'js_composer-color', composer_colors, composer.text.color);
  composer_swatches(root.find('.js_composer-highlights'), 'js_composer-highlight', [''].concat(composer_colors), composer.text.background);
  root.find('.js_composer-editor').attr('data-option', '');
  composer_pressed('.js_composer-option', 'data-option', '-');
  composer_panel('text');
  composer_render();
  var input = root.find('.js_composer-input').text(composer.text.text);
  composer_text_style();
  input.trigger('focus');
  var selection = window.getSelection();
  selection.selectAllChildren(input[0]);
  selection.collapseToEnd();
}


// composer save text
function composer_save_text() {
  var index = composer.editing;
  var text = composer.root.find('.js_composer-input')[0].innerText.replace(/ /g, ' ').trim().substring(0, 500);
  composer.editing = -1;
  composer.text.text = text;
  if (index >= 0) {
    if (text == '') {
      composer.layers.splice(index, 1);
    } else {
      composer.layers[index] = composer.text;
    }
  } else if (text != '') {
    composer.layers.push(composer.text);
  }
  composer.text = null;
  composer.selected = -1;
  composer_panel('');
  composer_render();
}


// composer draw stroke
function composer_draw_stroke(context, stroke, from) {
  var canvas = context.canvas;
  context.globalCompositeOperation = (stroke.tool == 'eraser') ? 'destination-out' : 'source-over';
  context.strokeStyle = stroke.color;
  context.fillStyle = stroke.color;
  context.lineWidth = stroke.size * ((stroke.tool == 'eraser') ? 2 : 1);
  context.lineCap = 'round';
  context.lineJoin = 'round';
  var points = stroke.points;
  if (points.length == 1) {
    context.beginPath();
    context.arc(points[0][0] * canvas.width, points[0][1] * canvas.height, context.lineWidth / 2, 0, Math.PI * 2);
    context.fill();
    return;
  }
  context.beginPath();
  var start = Math.max(0, from || 0);
  context.moveTo(points[start][0] * canvas.width, points[start][1] * canvas.height);
  for (var i = start + 1; i < points.length; i++) {
    context.lineTo(points[i][0] * canvas.width, points[i][1] * canvas.height);
  }
  context.stroke();
}


// composer draw all
function composer_draw_all() {
  var canvas = composer.root.find('.js_composer-canvas')[0];
  var context = canvas.getContext('2d');
  context.globalCompositeOperation = 'source-over';
  context.clearRect(0, 0, canvas.width, canvas.height);
  $.each(composer.strokes, function (index, stroke) {
    composer_draw_stroke(context, stroke, 0);
  });
}


// composer upload
function composer_upload(file, type, handle, progress) {
  return new Promise(function (resolve, reject) {
    var chunk_size = Math.max(1, Number(chunk_upload_size) * 1024 * 1024);
    var total_chunks = Math.max(1, Math.ceil(file.size / chunk_size));
    var file_guid = guid();
    var chunk_index = 0;
    function upload_chunk() {
      var start = chunk_index * chunk_size;
      var chunk = file.slice(start, Math.min(start + chunk_size, file.size));
      var data = new FormData();
      var fields = { 'secret': secret, 'type': type, 'handle': handle, 'multiple': 'false', 'name': file.name, 'guid': file_guid, 'chunkIndex': chunk_index, 'totalChunks': total_chunks };
      $.each(fields, function (key, value) {
        data.append(key, value);
      });
      data.append('file', chunk);
      $.ajax({
        url: api['data/upload'], type: 'POST', data: data, dataType: 'json', processData: false, contentType: false,
        xhr: function () {
          var xhr = new XMLHttpRequest();
          xhr.upload.addEventListener('progress', function (event) {
            if (progress && event.lengthComputable && event.total) {
              progress(Math.min(1, (start + chunk.size * (event.loaded / event.total)) / file.size));
            }
          });
          return xhr;
        },
        success: function (response) {
          if (!response || response.error || response.callback) {
            reject({ 'message': (response && typeof response.message === 'string') ? response.message : ((response && typeof response.error === 'string') ? response.error : ''), 'callback': response && response.callback });
            return;
          }
          chunk_index++;
          if (chunk_index < total_chunks) {
            upload_chunk();
            return;
          }
          var source = (response.file && typeof response.file === 'object') ? response.file.source : response.file;
          if (typeof source !== 'string' || !source) {
            reject({});
            return;
          }
          resolve(source);
        },
        error: function () {
          reject({});
        }
      });
    }
    upload_chunk();
  });
}


// composer poster
function composer_poster() {
  return new Promise(function (resolve) {
    var video = composer.root.find('.js_composer-media video')[0];
    if (!video || video.readyState < 2 || !video.videoWidth) {
      resolve(null);
      return;
    }
    try {
      var canvas = document.createElement('canvas');
      var ratio = Math.min(1, 720 / video.videoWidth);
      canvas.width = Math.round(video.videoWidth * ratio);
      canvas.height = Math.round(video.videoHeight * ratio);
      canvas.getContext('2d').drawImage(video, 0, 0, canvas.width, canvas.height);
      canvas.toBlob(resolve, 'image/jpeg', 0.85);
    } catch (e) {
      resolve(null);
    }
  });
}


// composer busy
function composer_busy(state, message) {
  var video = composer.root.find('.js_composer-media video')[0];
  if (video && state) {
    video.pause();
  } else if (video) {
    var playing = video.play();
    if (playing && playing.catch) {
      playing.catch(function () { });
    }
  }
  composer.busy = state;
  composer.root.attr('data-busy', (state) ? 'true' : 'false');
  composer.root.find('.js_composer-progress').text(message || '');
}


// composer publish
function composer_publish() {
  if (composer.busy) {
    return;
  }
  if (composer.type == 'text' && composer.layers.length == 0 && composer.strokes.length == 0) {
    composer_edit_text(-1);
    return;
  }
  var current = composer;
  var story = {
    'type': composer.type,
    'background': composer.background,
    'filter': composer.filter,
    'privacy': composer.privacy,
    'is_ads': composer.root.find('.js_composer-ads').is(':checked'),
    'music': (composer.music) ? { 'provider': composer.music.provider, 'id': composer.music.id } : null,
    'layers': $.map(composer.layers, function (layer) {
      var item = $.extend({}, layer);
      delete item.image;
      return item;
    })
  };
  composer_select(-1);
  composer.player.pause();
  composer_busy(true, __['Uploading']);
  var chain = Promise.resolve();
  if (composer.type != 'text') {
    chain = chain.then(function () {
      return composer_upload(current.file, (current.type == 'photo') ? 'photos' : 'video', 'publisher-mini', function (fraction) {
        if (composer === current) {
          composer.root.find('.js_composer-progress').text(__['Uploading'] + ' ' + Math.round(fraction * 100) + '%');
        }
      });
    }).then(function (source) {
      story.source = source;
    });
  }
  if (composer.type == 'video') {
    chain = chain.then(composer_poster).then(function (blob) {
      return (blob) ? composer_upload(new File([blob], 'poster.jpg', { 'type': 'image/jpeg' }), 'photos', 'story') : '';
    }).then(function (source) {
      story.thumbnail = source;
    });
  }
  if (composer.strokes.length > 0) {
    chain = chain.then(function () {
      return new Promise(function (resolve) {
        current.root.find('.js_composer-canvas')[0].toBlob(resolve, 'image/png');
      });
    }).then(function (blob) {
      return composer_upload(new File([blob], 'drawing.png', { 'type': 'image/png' }), 'photos', 'story');
    }).then(function (source) {
      story.drawing = source;
    });
  }
  chain.then(function () {
    return new Promise(function (resolve, reject) {
      $.post(api['stories/publish'], { 'do': 'publish', 'story': JSON.stringify(story) }, resolve, 'json').fail(function () {
        reject({});
      });
    });
  }).then(function (response) {
    if (composer !== current) {
      return;
    }
    if (response.callback || response.error) {
      throw { 'message': response.message, 'callback': response.callback };
    }
    composer_destroy();
    if (current_page == 'index') {
      window.location.reload();
    } else {
      stories_open([], null, response.story_id);
    }
  }).catch(function (error) {
    if (composer !== current) {
      return;
    }
    composer_busy(false);
    if (error && error.callback) {
      eval(error.callback);
    } else {
      show_error_modal((error && error.message) ? error.message : undefined);
    }
  });
}


$(function () {

  // close composer
  $('body').on('click', '.js_composer-close', function () {
    composer_leave(composer_destroy);
  });
  $('body').on('click', '.js_composer-back', function () {
    composer_leave(composer_reset);
  });


  // start composer
  $('body').on('click', '.js_composer-pick', function () {
    composer.root.find('.js_composer-file').trigger('click');
  });
  $('body').on('change', '.js_composer-file', function () {
    var file = this.files[0];
    if (!file) {
      return;
    }
    var type = (/^image\/(png|jpeg|webp|gif)$/.test(file.type)) ? 'photo' : ((/^video\//.test(file.type) && composer.config.can_upload_videos) ? 'video' : '');
    if (type == '') {
      $(this).val('');
      composer.root.find('.js_composer-error').text(__['The file type is not valid or not supported']).removeClass('hidden');
      return;
    }
    composer.file = file;
    composer.url = URL.createObjectURL(file);
    composer_start(type);
  });
  $('body').on('click', '.js_composer-text-story', function () {
    composer_start('text');
  });


  // composer sound
  $('body').on('click', '.js_composer-sound', function () {
    composer.video_muted = !composer.video_muted;
    composer_video_sound();
    var video = composer.root.find('.js_composer-media video')[0];
    if (video && video.paused) {
      var playing = video.play();
      if (playing && playing.catch) {
        playing.catch(function () { });
      }
    }
  });


  // composer tools
  $('body').on('click', '.js_composer-tool', function () {
    var tool = $(this).attr('data-tool');
    if (tool == 'text') {
      composer_edit_text(-1);
    } else {
      composer_panel(tool);
    }
  });
  $('body').on('click', '.js_composer-panel-close', function () {
    composer_panel('');
  });
  $('body').on('click', '.js_composer-post', function () {
    composer_publish();
  });


  // composer rows
  $('body').on('click', '.js_composer-row-prev, .js_composer-row-next', function () {
    var strip = $(this).closest('.js_composer-row').find('.js_composer-row-strip')[0];
    var direction = ($(this).hasClass('js_composer-row-next')) ? 1 : -1;
    if ($('html').attr('dir') == 'rtl') {
      direction = -direction;
    }
    strip.scrollBy({ 'left': Math.max(120, Math.round(strip.clientWidth * 0.8)) * direction, 'behavior': 'smooth' });
  });


  // composer text
  $('body').on('click', '.js_composer-text-done', function () {
    composer_save_text();
  });
  $('body').on('click', '.js_composer-option', function () {
    var editor = composer.root.find('.js_composer-editor');
    var option = $(this).attr('data-option');
    if (editor.attr('data-option') == option) {
      option = '';
    }
    editor.attr('data-option', option);
    composer_pressed('.js_composer-option', 'data-option', option || '-');
    composer_rows();
  });
  $('body').on('click', '.js_composer-align', function () {
    composer.text.align = (composer.text.align == 'center') ? 'start' : ((composer.text.align == 'start') ? 'end' : 'center');
    composer_text_style();
  });
  $('body').on('input', '.js_composer-size', function () {
    composer.text.scale = parseFloat($(this).val());
    composer_text_style();
  });
  $('body').on('click', '.js_composer-font', function () {
    composer.text.font = $(this).attr('data-font');
    composer_text_style();
  });
  $('body').on('click', '.js_composer-color', function () {
    composer.text.color = $(this).attr('data-color');
    composer_text_style();
  });
  $('body').on('click', '.js_composer-highlight', function () {
    composer.text.background = $(this).attr('data-color');
    composer_text_style();
  });


  // composer stickers
  $('body').on('click', '.js_composer-emoji', function () {
    composer_add_layer({ 'type': 'emoji', 'emoji': $(this).text() });
  });
  $('body').on('click', '.js_composer-sticker', function () {
    composer_add_layer({ 'type': 'sticker', 'id': $(this).attr('data-id'), 'image': $(this).attr('data-image') });
  });


  // composer mention
  $('body').on('input', '.js_composer-mention-input', function () {
    var term = $(this).val().trim().replace(/^@/, '');
    var list = composer.root.find('.js_composer-mention-list');
    clearTimeout(composer.mention_timer);
    if (term == '') {
      list.empty();
      return;
    }
    var current = composer;
    composer.mention_timer = setTimeout(function () {
      $.getJSON(api['users/mentions'], { 'term': term }, function (response) {
        if (composer !== current || !Array.isArray(response)) {
          return;
        }
        list.empty();
        $.each(response, function (index, item) {
          var row = $('<button type="button" class="js_composer-mention-item flex items-center gap-3 rounded-xl p-2 text-start transition hover:bg-white/10"><img class="size-10 shrink-0 rounded-full object-cover" alt=""><span class="min-w-0 truncate text-sm font-semibold text-white"></span></button>');
          row.attr('data-name', String(item.value || '').replace(/^\[|\]$/g, '')).find('img').attr('src', item.img);
          row.find('span').text(item.label).attr('title', item.label);
          list.append(row);
        });
      });
    }, 200);
  });
  $('body').on('click', '.js_composer-mention-item', function () {
    var user_name = $(this).attr('data-name');
    var exists = $.grep(composer.layers, function (layer) {
      return layer.type == 'mention' && layer.user_name == user_name;
    });
    if (exists.length > 0) {
      composer_panel('');
      return;
    }
    composer_add_layer({ 'type': 'mention', 'user_name': user_name });
  });


  // composer poll
  $('body').on('submit', '.js_composer-poll-form', function (e) {
    e.preventDefault();
    var options = $(this).find('.js_composer-poll-option').map(function () {
      return $(this).val().trim();
    }).get();
    if (options[0] == '' || options[1] == '') {
      return;
    }
    composer.layers = $.grep(composer.layers, function (layer) {
      return layer.type != 'poll';
    });
    composer_add_layer({ 'type': 'poll', 'question': $(this).find('.js_composer-poll-question').val().trim(), 'options': options, 'y': 0.6 });
  });


  // composer ads
  $('body').on('change', '.js_composer-ads', function () {
    composer.root.attr('data-ads', ($(this).is(':checked')) ? 'true' : 'false');
  });


  // composer privacy
  $('body').on('click', '.js_composer-privacy', function () {
    composer_set_privacy($(this).attr('data-privacy'));
    composer_panel('');
  });


  // composer music
  $('body').on('input', '.js_composer-music-input', function () {
    clearTimeout(composer.music_timer);
    composer.music_timer = setTimeout(function () {
      if (composer) {
        composer_music_load();
      }
    }, 350);
  });
  $('body').on('click', '.js_composer-music-tab', function () {
    composer.music_tab = $(this).attr('data-tab');
    composer_pressed('.js_composer-music-tab', 'data-tab', composer.music_tab);
    composer_music_load();
  });
  $('body').on('click', '.js_composer-music-play', function () {
    var button = $(this);
    var track = button.parent().data('track');
    var playing = button.attr('aria-pressed') == 'true';
    composer.player.pause();
    composer.root.find('.js_composer-music-play').attr('aria-pressed', 'false');
    if (playing) {
      return;
    }
    $(composer.player).data('track', track);
    composer.player.loop = false;
    composer.player.src = track.source;
    composer.player.currentTime = 0;
    var promise = composer.player.play();
    if (promise && promise.catch) {
      promise.catch(function () { });
    }
    button.attr('aria-pressed', 'true');
  });
  $('body').on('click', '.js_composer-music-pick', function () {
    composer_set_music($(this).parent().data('track'));
    composer_panel('');
  });
  $('body').on('click', '.js_composer-music-remove', function () {
    composer_set_music(null);
  });


  // composer link
  $('body').on('submit', '.js_composer-link-form', function (e) {
    e.preventDefault();
    var url = composer.root.find('.js_composer-link-input').val().trim();
    if (url == '') {
      return;
    }
    if (!/^https?:\/\//i.test(url)) {
      url = 'https://' + url;
    }
    var label;
    try {
      label = new URL(url).hostname.replace(/^www\./, '');
    } catch (error) {
      return;
    }
    composer.layers = $.grep(composer.layers, function (layer) {
      return layer.type != 'link';
    });
    composer_add_layer({ 'type': 'link', 'url': url, 'label': label, 'y': 0.7 });
  });


  // composer filters
  $('body').on('click', '.js_composer-filter', function () {
    composer.filter = $(this).attr('data-filter');
    composer.root.find('.js_composer-media').css('filter', stories_filters[composer.filter] || '');
    composer_pressed('.js_composer-filter', 'data-filter', composer.filter);
  });
  $('body').on('click', '.js_composer-background', function () {
    composer_set_background($(this).attr('data-background'));
  });


  // composer drawing
  $('body').on('click', '.js_composer-brush', function () {
    composer.brush.tool = $(this).attr('data-brush');
    composer_pressed('.js_composer-brush', 'data-brush', composer.brush.tool);
  });
  $('body').on('click', '.js_composer-brush-size', function () {
    composer.brush.size = parseInt($(this).attr('data-size'));
    composer_pressed('.js_composer-brush-size', 'data-size', composer.brush.size);
  });
  $('body').on('click', '.js_composer-brush-color', function () {
    composer.brush.color = $(this).attr('data-color');
    composer.brush.tool = 'brush';
    composer_pressed('.js_composer-brush-color', 'data-color', composer.brush.color);
    composer_pressed('.js_composer-brush', 'data-brush', 'brush');
  });
  $('body').on('click', '.js_composer-undo', function () {
    composer.strokes.pop();
    composer_draw_all();
  });
  $('body').on('click', '.js_composer-clear', function () {
    composer.strokes = [];
    composer_draw_all();
  });
  $('body').on('pointerdown', '.js_composer-canvas', function (e) {
    if (composer.root.attr('data-panel') != 'draw' || (e.button !== undefined && e.button > 0)) {
      return;
    }
    e.preventDefault();
    var rect = this.getBoundingClientRect();
    composer.stroke = { 'id': e.pointerId, 'rect': rect, 'data': { 'tool': composer.brush.tool, 'color': composer.brush.color, 'size': composer.brush.size, 'points': [[(e.clientX - rect.left) / rect.width, (e.clientY - rect.top) / rect.height]] } };
    composer.strokes.push(composer.stroke.data);
    composer_draw_stroke(this.getContext('2d'), composer.stroke.data, 0);
    try {
      this.setPointerCapture(e.pointerId);
    } catch (error) { }
  });
  $('body').on('pointermove', '.js_composer-canvas', function (e) {
    var stroke = composer && composer.stroke;
    if (!stroke || stroke.id != e.pointerId) {
      return;
    }
    var points = stroke.data.points;
    points.push([(e.clientX - stroke.rect.left) / stroke.rect.width, (e.clientY - stroke.rect.top) / stroke.rect.height]);
    if (stroke.data.tool == 'eraser' || points.length == 2) {
      composer_draw_all();
    } else {
      composer_draw_stroke(this.getContext('2d'), stroke.data, points.length - 2);
    }
  });
  $('body').on('pointerup pointercancel', '.js_composer-canvas', function (e) {
    if (composer && composer.stroke && composer.stroke.id == e.pointerId) {
      composer.stroke = null;
    }
  });


  // composer layers
  $('body').on('click', '.js_composer-layer', function (e) {
    e.preventDefault();
  });
  $('body').on('click', '.js_composer-layer-delete', function (e) {
    e.stopPropagation();
    composer_remove_layer(parseInt($(this).closest('.js_composer-layer').attr('data-index')));
  });
  $('body').on('pointerdown', '.js_composer-layers', function (e) {
    if (e.target === this) {
      composer_select(-1);
    }
  });
  $('body').on('pointerdown', '.js_composer-layer', function (e) {
    if ($(e.target).closest('.js_composer-layer-delete').length > 0 || (e.button !== undefined && e.button > 0)) {
      return;
    }
    e.preventDefault();
    var index = parseInt($(this).attr('data-index'));
    var layer = composer.layers[index];
    var drag = composer.drag;
    if (drag && drag.index == index) {
      /* second finger */
      drag.pointers[e.pointerId] = { 'x': e.clientX, 'y': e.clientY };
      var points = Object.values(drag.pointers);
      if (points.length == 2) {
        drag.mode = 'pinch';
        drag.distance = Math.hypot(points[1].x - points[0].x, points[1].y - points[0].y) || 1;
        drag.angle = Math.atan2(points[1].y - points[0].y, points[1].x - points[0].x);
        drag.scale = layer.scale;
        drag.rotation = layer.rotation;
      }
      return;
    }
    var rect = composer.root.find('.js_composer-frame')[0].getBoundingClientRect();
    var handle = $(e.target).closest('.js_composer-layer-handle').length > 0;
    var center_x = rect.left + layer.x * rect.width;
    var center_y = rect.top + layer.y * rect.height;
    composer_select(index);
    composer.drag = {
      'index': index,
      'mode': (handle) ? 'handle' : 'move',
      'rect': rect,
      'pointers': {},
      'start_x': e.clientX,
      'start_y': e.clientY,
      'layer_x': layer.x,
      'layer_y': layer.y,
      'scale': layer.scale,
      'rotation': layer.rotation,
      'distance': Math.hypot(e.clientX - center_x, e.clientY - center_y) || 1,
      'angle': Math.atan2(e.clientY - center_y, e.clientX - center_x),
      'moved': false,
      'time': Date.now()
    };
    composer.drag.pointers[e.pointerId] = { 'x': e.clientX, 'y': e.clientY };
    $(document).off('pointermove.composer pointerup.composer pointercancel.composer');
    $(document).on('pointermove.composer', function (event) {
      var drag = composer && composer.drag;
      if (!drag || !drag.pointers[event.pointerId]) {
        return;
      }
      var layer = composer.layers[drag.index];
      drag.pointers[event.pointerId] = { 'x': event.clientX, 'y': event.clientY };
      if (drag.mode == 'pinch') {
        var points = Object.values(drag.pointers);
        if (points.length < 2) {
          return;
        }
        layer.scale = Math.min(6, Math.max(0.2, drag.scale * (Math.hypot(points[1].x - points[0].x, points[1].y - points[0].y) / drag.distance)));
        layer.rotation = drag.rotation + (Math.atan2(points[1].y - points[0].y, points[1].x - points[0].x) - drag.angle) * 180 / Math.PI;
        drag.moved = true;
      } else if (drag.mode == 'handle') {
        var center_x = drag.rect.left + layer.x * drag.rect.width;
        var center_y = drag.rect.top + layer.y * drag.rect.height;
        layer.scale = Math.min(6, Math.max(0.2, drag.scale * (Math.hypot(event.clientX - center_x, event.clientY - center_y) / drag.distance)));
        layer.rotation = drag.rotation + (Math.atan2(event.clientY - center_y, event.clientX - center_x) - drag.angle) * 180 / Math.PI;
        if (Math.abs(layer.rotation % 360) < 4) {
          layer.rotation = 0;
        }
        drag.moved = true;
      } else {
        var delta_x = event.clientX - drag.start_x;
        var delta_y = event.clientY - drag.start_y;
        if (!drag.moved && Math.abs(delta_x) + Math.abs(delta_y) < 5) {
          return;
        }
        drag.moved = true;
        layer.x = Math.min(1, Math.max(0, drag.layer_x + delta_x / drag.rect.width));
        layer.y = Math.min(1, Math.max(0, drag.layer_y + delta_y / drag.rect.height));
        var snap_x = Math.abs(layer.x - 0.5) < 0.015;
        var snap_y = Math.abs(layer.y - 0.5) < 0.015;
        if (snap_x) layer.x = 0.5;
        if (snap_y) layer.y = 0.5;
        composer.root.find('.js_composer-guide-x').toggleClass('hidden', !snap_x);
        composer.root.find('.js_composer-guide-y').toggleClass('hidden', !snap_y);
        /* delete zone */
        composer.root.attr({ 'data-dragging': 'true', 'data-chrome': 'false' });
        var trash = composer.root.find('.js_composer-trash')[0].getBoundingClientRect();
        drag.trash = Math.hypot(event.clientX - (trash.left + trash.width / 2), event.clientY - (trash.top + trash.height / 2)) < 44;
        composer.root.find('.js_composer-trash').attr('data-active', (drag.trash) ? 'true' : 'false');
      }
      composer_update_layer(drag.index);
    });
    $(document).on('pointerup.composer pointercancel.composer', function (event) {
      var drag = composer && composer.drag;
      if (!drag || !drag.pointers[event.pointerId]) {
        return;
      }
      delete drag.pointers[event.pointerId];
      var remaining = Object.values(drag.pointers);
      if (remaining.length > 0) {
        /* back to one finger */
        var layer = composer.layers[drag.index];
        drag.mode = 'move';
        drag.start_x = remaining[0].x;
        drag.start_y = remaining[0].y;
        drag.layer_x = layer.x;
        drag.layer_y = layer.y;
        return;
      }
      $(document).off('pointermove.composer pointerup.composer pointercancel.composer');
      composer.drag = null;
      composer.root.find('.js_composer-guide-x, .js_composer-guide-y').addClass('hidden');
      composer.root.find('.js_composer-trash').attr('data-active', 'false');
      if (composer.root.attr('data-dragging') == 'true') {
        composer.root.attr({ 'data-dragging': 'false', 'data-chrome': 'true' });
      }
      if (drag.trash) {
        composer_remove_layer(drag.index);
      } else if (!drag.moved && drag.mode == 'move' && event.type == 'pointerup' && Date.now() - drag.time < 350 && composer.layers[drag.index].type == 'text') {
        composer_edit_text(drag.index);
      } else if (!drag.moved && drag.mode == 'move' && event.type == 'pointerup' && Date.now() - drag.time < 350 && composer.layers[drag.index].type == 'music') {
        /* next shape */
        var shapes = ['pill', 'card', 'cover', 'text'];
        var layer = composer.layers[drag.index];
        layer.style = shapes[($.inArray(layer.style || 'pill', shapes) + 1) % shapes.length];
        composer.selected = -1;
        composer_render();
        composer_select(drag.index);
      }
    });
  });
  $('body').on('wheel', '.js_composer-layer', function (e) {
    var index = parseInt($(this).attr('data-index'));
    if (index != composer.selected) {
      return;
    }
    var layer = composer.layers[index];
    layer.scale = Math.min(6, Math.max(0.2, layer.scale * ((e.originalEvent.deltaY < 0) ? 1.06 : 0.94)));
    composer_update_layer(index);
  });


  // composer keyboard
  $(document).on('keydown', function (e) {
    if (!composer || composer.busy || $('#modal.open, #modal-stacked.open').length > 0) {
      return;
    }
    var panel = composer.root.attr('data-panel');
    if (e.key == 'Escape') {
      if (panel == 'text') {
        composer_save_text();
      } else if (panel != '') {
        composer_panel('');
      } else {
        composer_leave(composer_destroy);
      }
      return;
    }
    if ($(e.target).is('input, textarea, [contenteditable]')) {
      return;
    }
    if ((e.key == 'Delete' || e.key == 'Backspace') && composer.selected >= 0) {
      e.preventDefault();
      composer_remove_layer(composer.selected);
    }
  });

});
