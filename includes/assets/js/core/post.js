/**
 * post js
 * 
 * @package Sngine
 * @author Zamblek
 */

// initialize API URLs
/* live */
api['live/reaction'] = ajax_path + "live/reaction.php";
/* posts */
api['comments/filter'] = ajax_path + "posts/filter.php?handle=comments";
api['posts/filter'] = ajax_path + "posts/filter.php?handle=posts";
api['posts/hashtags'] = ajax_path + "posts/hashtags.php";
api['posts/scraper'] = ajax_path + "posts/scraper.php";
api['posts/post'] = ajax_path + "posts/post.php";
api['posts/comment'] = ajax_path + "posts/comment.php";
api['posts/reaction'] = ajax_path + "posts/reaction.php";
api['chat/actions'] = ajax_path + "chat/actions.php";
api['posts/edit'] = ajax_path + "posts/edit.php";
api['posts/product'] = ajax_path + "posts/product.php";
/* ai */
api['ai/generate'] = ajax_path + "ai/generate.php";
/* albums */
api['albums/action'] = ajax_path + "albums/action.php";
/* forums */
api['forums/delete'] = ajax_path + "forums/delete.php";
api['forums/thread'] = ajax_path + "forums/thread.php";
api['forums/react'] = ajax_path + "forums/react.php";


// initialize voice recording global vars
var voice_recording_encoding = voice_notes_encoding;
var voice_recording_limit = voice_notes_durtaion;
var voice_recording_process = false;
var voice_recording_cancelled = false;
var voice_recording_timer;
var voice_recording_object;
var voice_recording_stream;


// initialize live post global vars
if (live_enabled) {
  var agora_client = null;
  var live_post_room = null;
  var live_post_realtime_thread;
  var live_post_realtime_process = false;
  var live_post_streaming_process = false;
  var live_post_audio_track = null;
  var live_post_stats_pending = false;
  var live_socket_post_id = null;
}


// quill publisher
function quill_publisher() {
  if (typeof Quill === "undefined" || $(".js_quill").length === 0) {
    return;
  }
  $('.js_quill').each(function () {
    var el = this;
    if ($(el).hasClass('ql-container')) {
      return;
    }
    var quill = new Quill(el, {
      theme: 'bubble',
      bounds: $(el).closest('.colored-text-wrapper').get(0) || document.body,
      placeholder: __['What is on your mind?'],
      modules: {
        toolbar: {
          container: [
            ['bold', 'italic', 'underline', 'strike'],
            ['blockquote'],
            [{ 'list': 'ordered' }, { 'list': 'bullet' }],
            [{ 'indent': '-1' }, { 'indent': '+1' }],
            [{ 'header': 1 }, { 'header': 2 }],
          ],
        },
        mention: {
          allowedChars: /^[a-zA-Z0-9_]*$|./u,
          mentionDenotationChars: ["@", "#"],
          positioningStrategy: 'fixed',
          mentionContainerClass: 'z-[100020] max-h-72 w-72 overflow-y-auto rounded-box border-[1px] border-base-300 bg-base-100 p-1.5 shadow-lg',
          mentionListClass: 'm-0 flex list-none flex-col gap-0.5 p-0',
          listItemClass: 'cursor-pointer rounded-lg [&.selected]:bg-base-200',
          source: function (searchTerm, renderList, mentionChar) {
            if (mentionChar === "@" && searchTerm.length > 0) {
              $.get(api['users/mentions'], { 'term': searchTerm }, function (response) {
                const values = response.map(user => ({
                  id: user.id,
                  avatar: user.img,
                  value: user.label.trim(),
                  username: user.value
                }));
                renderList(values, mentionChar);
              }, 'json');
            } else if (mentionChar === "#" && searchTerm.length > 0 && !searchTerm.includes(" ")) {
              $.get(api['posts/hashtags'], { 'term': searchTerm }, function (response) {
                const values = response.map(hashtag => ({
                  value: hashtag.hashtag
                }));
                renderList(values, mentionChar);
              }, 'json');
            }
          },
          renderItem: function (item, mentionChar) {
            var wrap = document.createElement('div');
            if (mentionChar === "@") {
              wrap.innerHTML = render_template('#publisher-mention-item', { avatar: item.avatar, value: item.value });
            } else if (mentionChar === "#") {
              wrap.innerHTML = render_template('#publisher-hashtag-item', { value: item.value });
            }
            return wrap.firstElementChild;
          },
        }
      }
    });
    /* apply the direction and alignment */
    quill.format('align', system_langauge_dir == "rtl" ? 'right' : 'left');
    quill.format('direction', system_langauge_dir == "rtl" ? 'rtl' : 'ltr');
    /* remove the html from the clipboard */
    quill.root.addEventListener('paste', (e) => {
      e.preventDefault();
      const text = e.clipboardData.getData('text/plain');
      if (text) {
        const range = quill.getSelection();
        quill.deleteText(range.index, range.length);
        quill.insertText(range.index, text, 'user');
        quill.setSelection(range.index + text.length);
      }
    }, true);
    /* remember the emoji insertion point */
    quill.on('selection-change', function (range) {
      if (range) quill.emojiSelection = range;
    });
    /* sync the quill with the publisher */
    quill.on('text-change', function () {
      var publisher = $(quill.root).closest('.publisher');
      publisher.find('textarea.js_publisher-scraper').val(quill.getText()).trigger('input');
      publisher.find('input.js_publisher-hidden-editor').val(quill.root.innerHTML);
    });
    $(el).data('quill', quill);
  });
}


// reset quill editor
function quill_editor_reset(quill) {
  if (typeof Quill === 'undefined' || !quill) {
    return;
  }
  quill.setText('');
  quill.blur();
}


// update quill editor
function update_quill_editor(quill, text) {
  if (typeof Quill === 'undefined' || !quill) {
    return;
  }
  quill.setText(text);
  quill.focus();
  quill.setSelection(quill.getLength(), 0);
}


// publisher photos
function publisher_photos_refresh(publisher, moved_source) {
  var panel = publisher.find('.js_publisher-photo-layout');
  if (!panel.length) {
    return;
  }
  var files = Object.assign({}, publisher.data('photos') || {});
  var queue = publisher.data('attachment-queue');
  if (queue) {
    queue.items.filter(function (item) { return item.type === 'photos'; }).forEach(function (item) {
      if (item.result) delete files[item.result.source];
      files[item.id] = { preview: item.preview, source: item.result && item.result.source, card: item.card };
    });
  }
  var sources = Object.keys(files);
  var order = (publisher.data('photo_order') || []).filter(function (source) {
    return Object.prototype.hasOwnProperty.call(files, source);
  });
  sources.forEach(function (source) {
    if (order.indexOf(source) === -1) order.push(source);
  });
  var layout = publisher.data('photo_layout') || 'classic';
  var attachments = publisher.find('.js_attachments-photos');
  var list = attachments.children('.js_photo-order-list');
  if (!sources.length) {
    publisher.removeData('photo_order').removeData('photo_layout');
    if (list.length && typeof Sortable === 'function' && Sortable.get(list[0])) Sortable.get(list[0]).destroy();
    list.remove();
    panel.hide().find('.js_photo-layout-preview').empty();
    return;
  }
  publisher.data('photo_order', order).data('photo_layout', layout);
  if (!list.length) {
    list = $('<ul class="js_photo-order-list"></ul>').appendTo(attachments);
  }
  list.children('li.item').each(function () {
    if (order.indexOf($(this).attr('data-src')) === -1) $(this).remove();
  });
  order.forEach(function (source, index) {
    var item = list.children('li.item').filter(function () {
      return $(this).attr('data-src') === source;
    });
    if (!item.length) {
      item = files[source].card || $(render_template('#publisher-photo-item', { src: source, image_path: uploads_path + '/' + source }));
    }
    var position = list.children('li.item').eq(index);
    if (position[0] !== item[0]) {
      if (position.length) item.insertBefore(position);
      else list.append(item);
    }
    item.find('.js_photo-position').text(index + 1);
    item.find('.js_photo-featured').toggle(index === 0);
    item.find('[data-direction="earlier"], [data-direction="first"]').prop('disabled', index === 0);
    item.find('[data-direction="later"]').prop('disabled', index === order.length - 1);
  });
  if (typeof Sortable === 'function' && !Sortable.get(list[0])) {
    list.addClass('[&>.sortable-ghost]:rounded-box [&>.sortable-ghost]:border-2 [&>.sortable-ghost]:border-dashed [&>.sortable-ghost]:border-primary [&>.sortable-ghost]:bg-primary/10 [&>.sortable-ghost>*]:invisible');
    Sortable.create(list[0], {
      draggable: 'li.item',
      handle: '.js_photo-drag',
      animation: 150,
      onUpdate: function (event) {
        publisher.data('photo_order', list.children('li.item').map(function () {
          return $(this).attr('data-src');
        }).get());
        publisher_photos_refresh(publisher, $(event.item).attr('data-src'));
      }
    });
  }
  panel.show();
  panel.find('.js_photo-layout-toolbar, .js_photo-layout-help').toggle(order.length > 1);
  var selected = panel.find('.js_photo-layout-option').filter(function () {
    var checked = $(this).data('layout') === layout;
    $(this).attr('aria-checked', checked ? 'true' : 'false').find('.js_photo-layout-check').toggleClass('invisible', !checked);
    return checked;
  });
  panel.find('.js_photo-layout-label').text(selected.find('.js_photo-layout-name').text());
  panel.find('.js_photo-layout-icon').attr('class', 'js_photo-layout-icon size-4 ' + selected.data('icon'));
  var preview = panel.find('.js_photo-layout-preview').empty();
  if (order.length === 1) {
    $('<img class="max-h-[42rem] w-full object-contain" alt="">').attr('src', files[order[0]].preview || uploads_path + '/' + files[order[0]].source).appendTo(preview);
  } else {
    var preset = panel.data('presets')[layout][Math.min(4, order.length)];
    var grid = $('<div>').addClass(preset.container).appendTo(preview);
    order.slice(0, preset.visible).forEach(function (source, index) {
      var tile = $('<div class="relative min-h-0 min-w-0 overflow-hidden"></div>').addClass(index === 0 ? preset.first : '').addClass(preset.tile || '').addClass(index % 2 === 1 ? preset.offset || '' : '').addClass(preset.mobile && index >= preset.mobile ? 'max-sm:hidden' : '').appendTo(grid);
      $('<img class="size-full object-cover" alt="">').attr('src', files[source].preview || uploads_path + '/' + files[source].source).appendTo(tile);
      if (index === preset.visible - 1 && order.length > preset.visible) {
        $('<span class="absolute inset-0 flex items-center justify-center bg-black/50 text-3xl font-semibold text-white"></span>').text('+' + (order.length - preset.visible)).appendTo(tile);
      }
      /* phones show fewer cards */
      if (preset.mobile && index === preset.mobile - 1 && order.length > preset.mobile) {
        $('<span class="absolute inset-0 flex items-center justify-center bg-black/50 text-3xl font-semibold text-white sm:hidden"></span>').text('+' + (order.length - preset.mobile)).appendTo(tile);
      }
    });
  }
  if (moved_source) {
    var status = panel.find('.js_photo-order-status');
    status.text(status.data('message').replace('%s', order.indexOf(moved_source) + 1));
  }
}


// published photo order
function publisher_photo_order(publisher) {
  var queue = publisher.data('attachment-queue');
  return (publisher.data('photo_order') || Object.keys(publisher.data('photos') || {})).map(function (id) {
    var item = queue && queue.items.find(function (entry) { return entry.id === id; });
    return item ? item.result && item.result.source : id;
  });
}


// publisher tabs
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
      /* toggle textarea + Quill placeholder */
      var poll_placeholder = publisher.find('.js_publisher-tab[data-tab="poll"]').hasClass('active') ? __['Ask something'] + "..." : publisher.find('textarea').data('init-placeholder');
      publisher.find('textarea').attr('placeholder', poll_placeholder).trigger('focus');
      var quill = publisher.find('.js_quill').data('quill');
      if (quill && quill.root) {
        quill.root.setAttribute('data-placeholder', poll_placeholder);
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
  publisher_edit_tabs(publisher);
}


// update attachment choices while editing
function publisher_edit_tabs(publisher) {
  var state = publisher.data('post-editor');
  if (!state || state.limited) return;
  var queue = publisher.data('attachment-queue');
  function has(kind) {
    return !!publisher.data(kind) || !!(queue && queue.items.some(function (item) { return item.type === kind; }));
  }
  var exclusive = null;
  if (publisher.data('scraping')) exclusive = publisher.data('scraping').source_provider === 'giphy' ? 'gif' : 'scraper';
  else if (has('reel')) exclusive = 'reel';
  else {
    ['poll', 'colored', 'voice_notes', 'gif', 'album'].some(function (kind) {
      if (publisher.find('.js_publisher-tab[data-tab="' + kind + '"]').hasClass('active') || (kind === 'album' && state.post_type === 'album') || (kind === 'voice_notes' && has(kind))) {
        exclusive = kind;
        return true;
      }
      return false;
    });
  }
  var media = ['photos', 'video', 'audio', 'file'].filter(has);
  ['photos', 'video', 'audio', 'file', 'reel', 'album', 'poll', 'colored', 'gif', 'voice_notes'].forEach(function (kind) {
    var allowed = exclusive ? kind === exclusive || (exclusive === 'album' && kind === 'photos') : !media.length || ['photos', 'video', 'audio', 'file'].includes(kind) || (kind === 'album' && media.every(function (type) { return type === 'photos'; }));
    var tab = publisher.find('.js_publisher-tab[data-tab="' + kind + '"]');
    tab.toggleClass('disabled', !allowed || (kind === 'poll' && state.poll_locked));
    if (['photos', 'video', 'audio', 'file', 'reel'].includes(kind)) tab.toggleClass('active activated', has(kind));
  });
}


// load a saved post into the publisher
function publisher_edit_load(publisher, state) {
  publisher.data('post-editor', state).data('edit-loading', true);
  var quill = publisher.find('.js_quill').data('quill');
  if (quill) {
    quill.clipboard.dangerouslyPasteHTML(state.text || '', 'silent');
    quill.history.clear();
    publisher.find('.js_publisher-scraper').val(quill.getText());
    publisher.find('.js_publisher-hidden-editor').val(state.text || '');
    quill.on('text-change', function () { publisher.data('edit-text-changed', true); });
    if (state.poll_locked) quill.enable(false);
  }
  publisher.find('.js_publisher-tab.link, .js_publisher-tab[data-tab="rich_text"]').remove();
  publisher.find('.publisher-tools-tabs .dropdown-menu [role="separator"]').remove();
  publisher.find('.publisher-tools-tabs .dropdown').filter(function () { return !$(this).find('.js_publisher-tab').length; }).remove();
  publisher.find('.js_publisher-anonymous-toggle').closest('.form-table-row').hide();
  publisher.find('.js_publisher-privacy').val(state.privacy);
  publisher.find('.publisher-meta[data-meta="location"] input.js_geocomplete').val(state.location);
  publisher.find('.publisher-meta[data-meta="location"] [data-geo="lat"]').val(state.location_latitude);
  publisher.find('.publisher-meta[data-meta="location"] [data-geo="lng"]').val(state.location_longitude);
  if (state.location) publisher_tab(publisher, 'location');
  if (state.feeling_value) {
    publisher.find('.publisher-meta[data-meta="feelings"]').show();
    publisher.find('#feelings-menu, #feelings-types').hide();
    publisher.find('#feelings-menu-toggle').text(state.feeling_action).addClass('active');
    publisher.find('#feelings-data').show().find('input').data('action', state.feeling_action).val(state.feeling_value).show();
    publisher.find('#feelings-data span').hide();
    publisher.find('.js_publisher-feelings').addClass('active activated');
  }
  var toggles = {for_adult: 'adult', tips_enabled: 'tips', for_subscriptions: 'subscribers', is_paid: 'paid', is_paid_locked: 'paid-lock', is_collaborative: 'collaborative'};
  Object.keys(toggles).forEach(function (key) {
    if (state[key] == '1') publisher.find('.js_publisher-' + toggles[key] + '-toggle').trigger('click');
  });
  publisher.find('[name="paid_post_price"]').val(state.post_price);
  publisher.find('[name="paid_post_text"]').val(state.paid_text);
  publisher.find('[name="collaborative_percent"]').val(state.collaborative_percent);
  if (state.still_scheduled) {
    publisher.find('.js_publisher-schedule-toggle').trigger('click');
    var date = new Date(state.time.replace(' ', 'T') + 'Z');
    var local = new Date(date.getTime() - date.getTimezoneOffset() * 60000);
    publisher.find('.js_publisher-schedule-date').val(local.toISOString().slice(0, 16));
    publisher.data('edit-schedule', local.toISOString().slice(0, 16));
  }
  function image_value(selector, source) {
    if (!source) return;
    var tile = publisher.find(selector).find('.x-image');
    tile.find('.js_x-uploader-input').val(source);
    tile.css('background-image', 'url("' + uploads_path + '/' + source.replace(/["\\\n\r]/g, '') + '")');
    tile.find('.js_x-image-remover').removeClass('hidden');
  }
  image_value('#subscriptions-image-wrapper', state.subscriptions_image);
  image_value('#paid-image-wrapper', state.paid_image);
  if (!state.limited) {
    if (state.photos.length) {
      var photos = {};
      state.photos.forEach(function (photo) { photos[photo.source] = photo; });
      publisher.data('photos', photos).data('photo_order', state.photos.map(function (photo) { return photo.source; })).data('photo_layout', state.photo_layout || 'classic');
      publisher_tab(publisher, 'photos');
      publisher.find('.js_publisher-tab[data-tab="photos"]').addClass('activated');
      publisher_photos_refresh(publisher);
      publisher.find('.js_attachments-photos').show();
    }
    if (state.post_type == 'album') {
      publisher_tab(publisher, 'album');
      publisher.find('.publisher-meta[data-meta="album"] input').val(state.album).prop('readonly', true);
      publisher.find('.js_publisher-tab[data-tab="album"]').addClass('activated');
    }
    ['video', 'reel', 'audio', 'file'].forEach(function (kind) {
      if (!state[kind]) return;
      publisher.data(kind, state[kind]);
      publisher_tab(publisher, kind);
      publisher.find('.publisher-meta[data-meta="' + kind + '"]').show();
      publisher.find('.js_publisher-tab[data-tab="' + kind + '"]').addClass('activated');
      var preview = publisher.find('.js_attachments-' + kind).empty().show();
      if (kind == 'file') {
        $('<span class="block rounded-field bg-base-200 p-3 text-sm"></span>').text(state.file.name || state.file.source.split('/').pop()).appendTo(preview);
      } else {
        $('<' + (kind == 'audio' ? 'audio' : 'video') + ' class="w-full rounded-field" controls preload="metadata"></' + (kind == 'audio' ? 'audio' : 'video') + '>').attr('src', uploads_path + '/' + state[kind].source).appendTo(preview);
      }
      if (kind == 'video' || kind == 'reel') {
        publisher.find('.publisher-' + kind + '-custom-thumbnail').show();
        image_value('.publisher-' + kind + '-custom-thumbnail', state[kind].thumbnail);
      }
    });
    if (state.video) publisher.find('[name="video_category"]').val(state.video.category_id);
    var link = state.link || state.media;
    if (link) {
      link = Object.assign({}, link);
      if (state.link) link.source_type = 'link';
      publisher.data('scraping', link);
      publisher_tab(publisher, link.source_provider == 'giphy' ? 'gif' : 'scraper');
      var template = link.source_provider == 'giphy' ? '#pubisher-gif' : (link.source_type == 'photo' ? '#scraper-photo' : '#scraper-link');
      publisher.find('.publisher-scraper').html(render_template(template, {src: link.source_url, url: link.source_url, thumbnail: link.source_thumbnail, host: link.source_host || link.source_provider, title: link.source_title, text: link.source_text, provider: link.source_provider})).show();
    }
    if (Number(state.colored_pattern) > 0) {
      publisher_tab(publisher, 'colored');
      var pattern = publisher.find('.js_publisher-pattern').filter(function () { return $(this).data('id') == state.colored_pattern; });
      if (pattern.length) pattern.trigger('click');
      else publisher.data('colored_pattern', state.colored_pattern);
    }
    if (state.poll_options.length) {
      publisher_tab(publisher, 'poll');
      var rows = publisher.find('.publisher-meta[data-meta="poll"]').stop(true, true);
      var sample = rows.first().clone().removeAttr('style');
      state.poll_options.concat(state.poll_locked ? [] : [{text: ''}]).forEach(function (option) {
        var row = sample.clone();
        row.find('input').val(option.text).prop('readonly', !!state.poll_locked);
        row.insertBefore(rows.first()).show();
      });
      rows.remove();
      if (state.poll_locked) publisher.find('.js_publisher-tab[data-tab="poll"]').addClass('activated').prop('disabled', true);
    }
  } else {
    publisher.find('.js_publisher-tab').not('[data-tab="location"]').closest('.publisher-tools-tab').remove();
  }
  publisher.removeData('edit-loading');
  publisher_edit_tabs(publisher);
}

// preserve saved files until the edit is committed
function publisher_edit_saved_upload(publisher, source) {
  var state = publisher.data('post-editor');
  if (!state || !source) return false;
  if (state.photos.some(function (photo) { return photo.source === source; })) return true;
  if (state.paid_image === source || state.subscriptions_image === source) return true;
  return ['video', 'reel', 'audio', 'file'].some(function (kind) {
    return state[kind] && (state[kind].source === source || state[kind].thumbnail === source);
  });
}

// save the publisher edit
function publisher_edit_save(publisher, payload, button, error) {
  var state = publisher.data('post-editor');
  payload.handle = 'post_full';
  payload.id = state.post_id;
  payload.revision = state.revision;
  payload.is_anonymous = state.is_anonymous;
  payload.colored_pattern = publisher.data('colored_pattern') || '';
  payload.feeling_action = publisher.find('#feelings-data input').data('action') || '';
  var kept = Object.values(publisher.data('photos') || {}).map(function (photo) { return String(photo.photo_id || ''); });
  payload.removed_photos = JSON.stringify(state.limited ? [] : state.photos.filter(function (photo) { return kept.indexOf(String(photo.photo_id)) < 0; }).map(function (photo) { return photo.photo_id; }));
  payload.removed_media = JSON.stringify(state.limited ? [] : ['video', 'reel', 'audio', 'file'].filter(function (kind) {
    var value = publisher.data(kind);
    return state[kind] && (!value || String(value[kind + '_id'] || '') !== String(state[kind][kind + '_id']));
  }));
  if (!publisher.data('edit-text-changed') || state.poll_locked) payload.message = state.text || '';
  if (!payload.collaborative_percent) payload.collaborative_percent = '0';
  if (!payload.post_price) payload.post_price = '0';
  if (state.post_type == 'album') payload.album = state.album;
  var fields = {privacy: '.js_publisher-privacy', for_adult: '.js_publisher-adult-toggle', tips_enabled: '.js_publisher-tips-toggle', for_subscriptions: '.js_publisher-subscribers-toggle', is_paid: '.js_publisher-paid-toggle', is_paid_locked: '.js_publisher-paid-lock-toggle', post_price: '[name="paid_post_price"]', paid_text: '[name="paid_post_text"]', paid_image: '[name="paid_image"]', subscriptions_image: '[name="subscriptions_image"]', is_collaborative: '.js_publisher-collaborative-toggle', collaborative_percent: '[name="collaborative_percent"]'};
  Object.keys(fields).forEach(function (key) { if (!publisher.find(fields[key]).length) delete payload[key]; });
  if (!publisher.find('[name="collaborative_users"]').length) delete payload.collaborative_users;
  if (state.still_scheduled && payload.is_schedule && publisher.find('.js_publisher-schedule-date').val() === publisher.data('edit-schedule')) payload.schedule_date = state.time;
  if (!state.still_scheduled || !publisher.find('.js_publisher-schedule-toggle').length) {
    delete payload.is_schedule;
    delete payload.schedule_date;
  }
  if (state.limited) ['photos', 'photo_order', 'link', 'poll_options', 'video', 'reel', 'audio', 'voice_notes', 'file', 'album', 'colored_pattern'].forEach(function (key) { delete payload[key]; });
  error.hide();
  $.post(api['posts/edit'], payload, function (response) {
    if (response.error) {
      error.text(response.message).show();
      return;
    }
    if (response.callback) {
      error.text(__['Something went wrong!'] || 'Unable to save this post. Please try again.').show();
      return;
    }
    var cards = $('.post').not('.js_reel-menu').filter(function () { return String($(this).data('id')) === String(state.post_id); });
    if (response.post) {
      cards.each(function () {
        var old = $(this);
        var replacement = $('<div>').html(response.post).find('.post').first();
        var comments = old.find('.post-footer').first();
        if (comments.length) replacement.find('.post-footer').first().replaceWith(comments.detach());
        old.replaceWith(replacement);
      });
    } else if (response.processing || response.approval) {
      cards.remove();
    }
    attachment_upload_clear(publisher);
    modal_close_all(function () {
      if (response.approval) modal('#modal-success', {title: __['Under Review'], message: __['Your post is under review now, We will let you know when it is ready!']});
      else if (response.processing) modal('#modal-success', {title: __['Processing'], message: __['Your video is being processed, We will let you know when it is ready!']});
    });
    if (typeof initialize === 'function') initialize();
  }, 'json').fail(function () {
    error.text(__['Something went wrong!'] || 'Unable to save this post. Please try again.').show();
  }).always(function () {
    button_status(button, 'reset');
    publisher.removeData('edit-saving');
    $('.js_posts_stream').removeData('loading');
  });
}


// publisher reveal
function publisher_reveal(event, selector) {
  if (!event.originalEvent || !event.currentTarget.checked) return;
  var element = $(selector).filter(':visible').last()[0];
  if (element) element.scrollIntoView({ block: 'nearest', behavior: 'smooth' });
}


// close publisher modal
function close_publisher_modal(modal) {
  modal_close_all(function () {
    var wrapper = $('#publisher-wapper');
    var content = wrapper.data('publisher-detached');
    if (content) {
      wrapper.append(content);
      wrapper.removeData('publisher-detached');
    }
    $('body').removeClass('publisher-focus');
  });
}


// update media views
function update_media_views(media_type, media_id) {
  switch (media_type) {
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
  if ($(".publisher").length == 0 && $(".js_publisher-trigger").length > 0) {
    $(".js_publisher-trigger").first().trigger('click');
    return;
  }
  $(".js_publisher-scraper").trigger('keyup');
  $('body').addClass('publisher-focus');
  $('.publisher-slider').slideDown();
}


// giphy search
function giphy_search(query, offset, limit) {
  var params = { api_key: giphy_key, limit: limit, offset: offset, lang: system_langauge_code || 'en' };
  if (query) {
    params['q'] = query;
  }
  return $.get('https://api.giphy.com/v1/gifs/' + (query ? 'search' : 'trending'), params, null, 'json');
}


// load agora sdk (on demand)
function load_agora() {
  var sdk = (typeof AgoraRTC !== 'undefined') ? Promise.resolve() : load_script(agora_sdk_url);
  return sdk.then(function () {
    if (live_enabled && !agora_client) {
      agora_client = AgoraRTC.createClient({ mode: 'live', codec: 'vp8' });
      AgoraRTC.setLogLevel((system_debugging_mode == true) ? 0 : 4);
    }
  });
}
if (live_enabled && typeof AgoraRTC !== 'undefined') {
  load_agora();
}


// load livekit sdk (on demand)
function load_livekit() {
  return (typeof LivekitClient !== 'undefined') ? Promise.resolve() : load_script(livekit_sdk_url);
}


// run live stream
async function join(channel_name, token, uid, provider) {
  if (provider == "livekit") {
    await join_livekit(token);
    return;
  }
  /* init agora client */
  await load_agora();
  await agora_client.setClientRole("audience");
  /* add event listener to play remote tracks when remote user publishs */
  agora_client.on("user-published", handle_user_published);
  agora_client.on("user-unpublished", handle_user_unpublished);
  agora_client.on("connection-state-change", function (state, previous, reason) {
    if (reason == "UID_BANNED") live_audience_removed();
  });
  /* join the channel */
  await agora_client.join(agora_app_id, channel_name, token, uid);
}
async function subscribe(user, mediaType) {
  await agora_client.subscribe(user, mediaType);
  if (mediaType === 'video') {
    user.videoTrack.play('js_live-video');
  }
  if (mediaType === 'audio') {
    live_post_audio_track = user.audioTrack;
    live_post_audio_track.setVolume($('.js_live-sound').attr('aria-pressed') === 'true' ? 0 : 100);
    live_post_audio_track.play();
  }
  live_audience_started();
}
async function join_livekit(token) {
  /* init livekit room */
  await load_livekit();
  live_post_room = new LivekitClient.Room({ adaptiveStream: true });
  live_post_room
    .on(LivekitClient.RoomEvent.TrackSubscribed, function (track) {
      if (track.kind === LivekitClient.Track.Kind.Video) {
        $(track.attach()).addClass('size-full object-cover').appendTo($('#js_live-video').empty());
      }
      if (track.kind === LivekitClient.Track.Kind.Audio) {
        live_post_audio_track = track;
        live_post_audio_track.setVolume($('.js_live-sound').attr('aria-pressed') === 'true' ? 0 : 1);
        $(track.attach()).addClass('hidden').appendTo($('.js_live-stage').first());
      }
      live_audience_started();
    })
    .on(LivekitClient.RoomEvent.TrackMuted, function (publication, participant) {
      if (!participant.identity.startsWith('host_')) return;
      handle_user_unpublished({ _video_muted_: publication.kind === LivekitClient.Track.Kind.Video, _audio_muted_: publication.kind === LivekitClient.Track.Kind.Audio });
    })
    .on(LivekitClient.RoomEvent.TrackUnmuted, function (publication, participant) {
      if (!participant.identity.startsWith('host_')) return;
      $('#js_live-status').html('').hide();
    })
    .on(LivekitClient.RoomEvent.ParticipantDisconnected, function (participant) {
      if (!participant.identity.startsWith('host_')) return;
      handle_user_unpublished({});
    })
    .on(LivekitClient.RoomEvent.Disconnected, function (reason) {
      if (!live_post_streaming_process) return;
      if (reason === LivekitClient.DisconnectReason.PARTICIPANT_REMOVED) {
        live_audience_removed();
      } else {
        handle_user_unpublished({});
      }
    });
  /* join the room */
  await live_post_room.connect(livekit_live_ws_url, token);
}
function live_audience_started() {
  /* hide live status */
  $('#js_live-status').html('').hide();
  /* handle live buttons */
  $('.js_live-controls').prop('hidden', false);
  if (!document.fullscreenEnabled && !document.webkitFullscreenEnabled) {
    $('.js_live-fullscreen').prop('hidden', true);
  }
  /* check live post streaming process */
  if (live_post_streaming_process) {
    return;
  }
  /* handle live counter */
  $('#js_live-counter-status').html(__['Live']).parent().removeClass("offline");
  $('#js_live-counter-number').html(1);
  /* update live post streaming process */
  live_post_streaming_process = true;
  /* join live socket room */
  live_socket_join($('.lightbox, .livebox').data('live-post-id'));
  /* set live post real-time thread */
  live_post_realtime_thread = setInterval(live_audience_stats, 5000);
  /* bind the beforeunload event */
  $(window).on('beforeunload', function (event) {
    end_live_audience();
    event.preventDefault();
  });
}
function live_audience_stats() {
  /* check live realtime process */
  if (live_post_realtime_process) {
    live_post_stats_pending = true;
    return;
  }
  /* set live realtime process */
  var lightbox = $('.lightbox, .livebox');
  var live_post_id = lightbox.data('live-post-id');
  var stream = lightbox.find('ul.js_live-comments');
  live_post_realtime_process = true;
  var data = live_stats_data(stream, live_post_id);
  $.post(api['live/reaction'], data, function (response) {
    /* update live count */
    $('#js_live-counter-number').html(response.live_count);
    /* update comments */
    live_update_comments(stream, response, data);
    stream.prepend(live_new_comments(stream, response.comments));
    /* update restriction */
    if ((lightbox.data('live-restriction') || null) != (response.restriction || null)) {
      lightbox.data('live-restriction', response.restriction);
      lightbox.find('.js_comment-form').toggleClass('hidden', !!response.restriction);
    }
    if (response.restriction == 'kick' || response.restriction == 'ban') {
      live_audience_removed();
    }
    /* update reactions */
    live_fly_reactions(lightbox.find('.js_live-reactions'), response.reactions);
  }, 'json')
    .always(function () {
      /* reset live realtime process */
      live_post_realtime_process = false;
      if (live_post_stats_pending) {
        live_post_stats_pending = false;
        live_audience_stats();
      }
    });
}
function live_last_comment_id(stream) {
  var last_comment_id = 0;
  stream.children('li').children('.comment[data-id]').each(function () {
    last_comment_id = Math.max(last_comment_id, parseInt($(this).data('id'), 10) || 0);
  });
  return last_comment_id;
}
function live_new_comments(stream, comments) {
  if (!comments || !String(comments).trim()) {
    return $();
  }
  return $('<div>').html(comments).children('li').filter(function () {
    var id = $(this).find('.comment:first').data('id');
    return !id || !stream.find('#comment_' + id).length;
  });
}
function live_stats_data(stream, post_id) {
  var comments = {};
  stream.find('.comment[data-id]').map(function () {
    return parseInt($(this).data('id'), 10) || 0;
  }).get().sort(function (a, b) {
    return b - a;
  }).slice(0, 100).forEach(function (id) {
    comments[id] = stream.find('#comment_' + id).data('live-signature') || '';
  });
  return { 'do': 'stats', 'post_id': post_id, 'last_comment_id': live_last_comment_id(stream), 'last_reply_id': (typeof stream.data('last-reply-id') !== 'undefined') ? stream.data('last-reply-id') : -1, 'comments': JSON.stringify(comments) };
}
function live_update_comments(stream, response, data) {
  if (typeof response.last_reply_id !== 'undefined') {
    stream.data('last-reply-id', response.last_reply_id);
  }
  /* remove deleted comments */
  if (data && response.updates) {
    $.each(JSON.parse(data.comments), function (comment_id) {
      if (typeof response.updates[comment_id] === 'undefined') {
        stream.find('#comment_' + comment_id).closest('li').remove();
      }
    });
  }
  /* update reactions */
  $.each(response.updates || {}, function (comment_id, update) {
    var comment = stream.find('#comment_' + comment_id);
    comment.data('live-signature', update.signature);
    if (typeof update.stats !== 'undefined') {
      comment.find('.js_comment-reactions-stats:first').html(update.stats).toggleClass('hidden', is_empty(update.stats));
    }
  });
  /* add new replies */
  $.each(response.replies || {}, function (comment_id, replies) {
    var comment = stream.find('#comment_' + comment_id);
    var new_replies = live_new_comments(stream, replies);
    if (!comment.length || !new_replies.length) {
      return;
    }
    comment.find('.js_replies:first').append(new_replies);
    comment.find('.js_replies-toggle:first').remove();
    comment.find('.comment-replies:first').removeClass('hidden');
  });
}
function live_fly_reactions(layer, reactions) {
  if (!layer.length || !reactions) {
    return;
  }
  var previous = layer.data('reactions');
  layer.data('reactions', reactions);
  if (!previous || document.hidden || window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
    return;
  }
  $.each(reactions, function (reaction, count) {
    var added = Math.min(count - (previous[reaction] || 0), 10);
    for (var i = 0; i < added; i++) {
      setTimeout(function () {
        live_fly_reaction(layer, reaction);
      }, i * 200 + Math.random() * 150);
    }
  });
}
function live_fly_reaction(layer, reaction) {
  var image = layer.find('img[data-reaction="' + reaction + '"]');
  if (!image.length) {
    return;
  }
  var item = image.clone().removeAttr('hidden').addClass('absolute bottom-0 start-1/2 -ms-5 size-10 drop-shadow-lg')[0];
  var height = layer.height();
  var drift = (Math.random() - 0.5) * 70;
  layer.append(item);
  item.animate([
    { transform: 'translate(0, 0) scale(0.3)', opacity: 0 },
    { transform: 'translate(' + (drift * 0.4) + 'px, ' + (-height * 0.2) + 'px) scale(1)', opacity: 1, offset: 0.15 },
    { transform: 'translate(' + (-drift * 0.4) + 'px, ' + (-height * 0.6) + 'px) scale(1)', opacity: 0.9, offset: 0.6 },
    { transform: 'translate(' + drift + 'px, ' + (-height) + 'px) scale(0.8)', opacity: 0 }
  ], { duration: 2800 + Math.random() * 1200, easing: 'cubic-bezier(0.2, 0.6, 0.4, 1)' }).onfinish = function () {
    item.remove();
  };
}
function live_socket_notify(comment_id) {
  if (live_socket_post_id && comment_id && chat_socket_enabled && typeof chat_socket !== "undefined" && chat_socket) {
    chat_socket.emit('event_client_live_comment', { post_id: live_socket_post_id, comment_id: comment_id });
  }
}
function live_moderation_state(user_id, group, state) {
  $('.js_live-action[data-uid="' + user_id + '"][data-group="' + group + '"]').each(function () {
    $(this).text($(this).data(($(this).data('action') == state) ? 'on' : 'off'));
  });
}
function live_socket_moderation() {
  if (live_socket_post_id && chat_socket_enabled && typeof chat_socket !== "undefined" && chat_socket) {
    chat_socket.emit('event_client_live_moderation', { post_id: live_socket_post_id });
  }
}
function live_comments_refresh() {
  if (typeof live_host_stats === "function") {
    live_host_stats();
  } else if (live_post_streaming_process) {
    live_audience_stats();
  }
}
function live_socket_join(post_id) {
  live_socket_post_id = post_id;
  if (chat_socket_enabled && typeof chat_socket !== "undefined" && chat_socket) {
    chat_socket.emit('event_client_live_join', { post_id: post_id });
  }
}
function live_socket_leave() {
  if (live_socket_post_id && chat_socket_enabled && typeof chat_socket !== "undefined" && chat_socket) {
    chat_socket.emit('event_client_live_leave', { post_id: live_socket_post_id });
  }
  live_socket_post_id = null;
}
function handle_user_published(user, mediaType) {
  subscribe(user, mediaType);
}
function handle_user_unpublished(user) {
  /* show live status */
  if (user._video_muted_) {
    $('#js_live-status').html('<span class="icon-[tabler--video-off] size-5 shrink-0" aria-hidden="true"></span>' + __['Video Muted']).show();
    return;
  }
  if (user._audio_muted_) {
    $('#js_live-status').html('<span class="icon-[tabler--microphone-off] size-5 shrink-0" aria-hidden="true"></span>' + __['Audio Muted']).show();
    return;
  }
  $('#js_live-status').html('<span class="icon-[tabler--alert-circle] size-5 shrink-0" aria-hidden="true"></span>' + __['Live Ended']).addClass("error").show();
  /* update live post streaming process */
  live_post_streaming_process = false;
  /* clear live post real-time thread */
  clearInterval(live_post_realtime_thread);
  /* handle live buttons */
  $('.js_live-controls').prop('hidden', true);
  live_socket_leave();
  /* handle live counter */
  $('#js_live-counter-status').html(__['Offline']).parent().addClass("offline");
  $('#js_live-counter-number').html(0);
  /* unbind the beforeunload event */
  $(window).off('beforeunload');
}
function live_audience_removed() {
  if (!live_post_streaming_process) {
    return;
  }
  /* update live post streaming process */
  live_post_streaming_process = false;
  /* clear live post real-time thread */
  clearInterval(live_post_realtime_thread);
  live_socket_leave();
  /* leave the stream */
  if (live_post_room) {
    live_post_room.disconnect();
  } else if (agora_client) {
    agora_client.leave();
  }
  $('#js_live-video').empty();
  /* show live status */
  $('#js_live-status').html('<span class="icon-[tabler--alert-circle] size-5 shrink-0" aria-hidden="true"></span>' + __['You have been removed from this live']).addClass("error").show();
  /* handle live buttons */
  $('.js_live-controls').prop('hidden', true);
  $('.lightbox, .livebox').find('.js_comment-form').addClass('hidden');
  /* handle live counter */
  $('#js_live-counter-status').html(__['Offline']).parent().addClass("offline");
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
  live_socket_leave();
  if (live_post_room) {
    live_post_room.disconnect();
  }
  /* clear live post real-time thread */
  clearInterval(live_post_realtime_thread);
  /* reset live realtime process */
  live_post_realtime_process = false;
  /* unbind the beforeunload event */
  $(window).off('beforeunload');
  window.location.reload();
};


$(function () {

  // run daytime messages
  if (current_page == "index" && daytime_msg_enabled && $('#publisher-trigger').length > 0) {
    var now = new Date();
    var hours = now.getHours();
    if (hours >= 0 && hours < 12) {
      $(render_template('#message-morning')).insertAfter('#publisher-trigger').fadeIn();
    } else if (hours >= 12 && hours < 18) {
      $(render_template('#message-afternoon')).insertAfter('#publisher-trigger').fadeIn();
    } else if (hours >= 18 || hours <= 24) {
      $(render_template('#message-evening')).insertAfter('#publisher-trigger').fadeIn();
    }
  }


  // run publisher
  /* initialize quill publisher */
  quill_publisher();
  /* publisher focus */
  $('body').on('click', function (e) {
    /* check if there is a publisher in the page (the modal publisher stays expanded) */
    if ($(".publisher:not(.mini):not([data-modal-mode])").length > 0) {
      if ($(e.target).parents(".publisher:not(.mini)").length > 0 || $(e.target).parents(".js_publisher-attachment-image-remover").length > 0 || $(e.target).parents(".js_publisher-gif-remover").length > 0 || $(e.target).parents(".js_publisher-scraper-remover").length > 0 || $(e.target).parents(".js_publisher-extender").length > 0) {
        $('body').addClass('publisher-focus');
        $('.publisher-slider').slideDown();
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
            publisher_message.css("color", active_pattern.data('text-color'));
            publisher_textarea.css("color", active_pattern.data('text-color'));
            autosize.update(publisher_textarea);
          }
        }
      } else {
        $('body').removeClass('publisher-focus');
        $('.publisher-slider').slideUp();
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
          publisher_message.css("color", "");
          autosize.update(publisher_textarea);
        }
      }
    }
  });
  /* publisher close modal */
  $('body').on('click', '.js_close-publisher-modal', function (event) {
    close_publisher_modal($(this).closest('.modal'));
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
    if (publisher.data('edit-loading') || (publisher.data('post-editor') && (publisher.data('post-editor').limited || publisher.data('post-editor').poll_locked))) return;
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
    $('#feelings-data span').text($(this).data("emoji") + ' ' + $(this).find('.data').text());
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
      publisher_message.css("color", _this.data('text-color'));
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
      publisher_message.css("color", "");
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
        _this.after('<div class="dropdown-menu gif-search static! mt-0 max-h-72 w-full overflow-y-auto rounded-box border border-base-300 bg-base-100 p-0 text-sm opacity-100 shadow-none"></div>');
      }
      /* add the loader */
      _this.next('.dropdown-menu').show().html('<div class="flex justify-center py-6"><div class="loading loading-spinner loading-sm text-primary"></div></div>');
      /* get results */
      giphy_search(query, 0, 20).done(function (response) {
        if (response.meta.status == 200 && response.data.length > 0) {
          _this.next('.dropdown-menu').show().html("<div class='js_scroller grid grid-cols-2 gap-2 p-2 sm:grid-cols-3'></div>");
          for (var i = 0; i < response.data.length; i++) {
            _this.next('.dropdown-menu').find('.js_scroller').append($('<button type="button" class="item overflow-hidden rounded-lg bg-base-200"><img class="js_publisher-gif-add aspect-video size-full object-cover" src="' + response.data[i].images.fixed_height_small.url + '" data-gif="' + response.data[i].images.fixed_height.url + '" alt=""></button>'));
          }
        } else {
          _this.next('.dropdown-menu').show().html('<div class="px-4 py-6 text-center text-sm text-base-content/55">' + __['No result found'] + '</div>');
        }
      })
        .fail(function () {
          _this.next('.dropdown-menu').show().html('<div class="px-4 py-6 text-center text-sm text-base-content/55">' + __['No result found'] + '</div>');
        });
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
      return this.value.trim() === "";
    });
    if ($emptyFields.length == $('.publisher-meta[data-meta="poll"] input').length) {
      $('.js_publisher-tab[data-tab="poll"]').removeClass('activated');
    } else {
      $('.js_publisher-tab[data-tab="poll"]').addClass('activated');
    }
  });
  $('body').on('focus', '.publisher-meta[data-meta="poll"] input:last', function () {
    if ($(this).prop('readonly')) return;
    $(render_template('#poll-option')).insertAfter($(this).closest('.publisher-meta')).fadeIn();
  });
  /* publisher photo layout */
  $('body').on('click', '.js_photo-layout-option', function () {
    var publisher = $(this).closest('.publisher');
    publisher.data('photo_layout', $(this).data('layout'));
    publisher_photos_refresh(publisher);
  });
  $('body').on('click', '.js_photo-move', function () {
    var button = $(this);
    var publisher = button.closest('.publisher');
    var source = button.closest('li.item').attr('data-src');
    var order = (publisher.data('photo_order') || []).slice();
    var index = order.indexOf(source);
    if (index === -1) return;
    var direction = button.data('direction');
    var target = direction === 'first' ? 0 : index + (direction === 'earlier' ? -1 : 1);
    if (target < 0 || target >= order.length) return;
    order.splice(index, 1);
    order.splice(target, 0, source);
    publisher.data('photo_order', order);
    publisher_photos_refresh(publisher, source);
    if (button.prop('disabled')) {
      button.closest('li.item').find('.js_photo-move:not(:disabled)').first().trigger('focus');
    } else {
      button.trigger('focus');
    }
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
    if (!mini) publisher_photos_refresh(publisher);
    /* remove the attachment from server */
    if (!publisher_edit_saved_upload(publisher, src)) $.post(api['data/delete'], { 'src': src });
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
    var queue = publisher.data('attachment-queue');
    var upload = queue && queue.items.find(function (item) { return item.type === type; });
    if (upload) {
      attachment_upload_remove(queue, upload);
      return;
    }
    var src = publisher.data(type);
    if (!src) return;
    src = src['source'];
    if (src === undefined) return;
    /* remove the uploads from publisher data */
    publisher.removeData(type);
    publisher.find('.publisher-meta[data-meta="' + type + '"]').hide();
    if (type == "reel") {
      /* remove the thumbnail */
      var attachments_reel_thumbnail = publisher.find('.publisher-reel-custom-thumbnail');
      x_image_reset(attachments_reel_thumbnail.find('.x-image'));
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
      x_image_reset(attachments_video_thumbnail.find('.x-image'));
      attachments_video_thumbnail.hide();
    }
    publisher_tab(publisher, type);
    publisher.find('.js_publisher-tab[data-tab="' + type + '"]').removeClass('activated');
    /* remove the attachment from server */
    publisher.find('.js_attachments-' + type).empty().hide();
    if (!publisher_edit_saved_upload(publisher, src)) $.post(api['data/delete'], { 'src': src });
  });
  /* publish new post */
  $('body').on('click', '.js_publisher', function () {
    var _this = $(this);
    /* get posts stream */
    var posts_stream = $('.js_posts_stream');
    /* get publisher */
    var publisher = _this.parents('.publisher');
    if (attachment_upload_busy(publisher) || publisher.data('edit-saving') || publisher.find('.x-image-loader:not(.hidden):visible, .js_voice-processing-message:visible, .js_voice-stop:visible').length) return;
    /* get handle */
    var handle = publisher.data('handle');
    /* get (user|page|group|event) id */
    var id = publisher.data('id');
    /* get text */
    var textarea = publisher.find('textarea');
    /* get editor */
    var editor = publisher.find('.js_publisher-hidden-editor');
    /* get quill */
    var quill = publisher.find('.js_quill').first().data('quill');
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
    var reel_thumbnail = attachments_reel_thumbnail.find('input.js_x-uploader-input').val();
    /* get video */
    var attachments_video = publisher.find('.js_attachments-video');
    var attachments_video_meta = publisher.find('.publisher-meta[data-meta="video"]');
    var video = publisher.data('video');
    var attachments_video_thumbnail = publisher.find('.publisher-video-custom-thumbnail');
    var video_thumbnail = attachments_video_thumbnail.find('input.js_x-uploader-input').val();
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
    var privacy = publisher.find('.js_publisher-privacy').val();
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
    var subscriptions_image_input = subscriptions_image_wrapper.find('input.js_x-uploader-input');
    /* get paid post */
    var is_paid = publisher.find('.js_publisher-paid-toggle').is(":checked");
    var paid_locked_wrapper = publisher.find("#paid-lock-toggle-wrapper");
    var is_paid_locked = publisher.find('.js_publisher-paid-lock-toggle').is(":checked");
    var paid_price_wrapper = publisher.find("#paid-price-wrapper");
    var paid_price_input = paid_price_wrapper.find('input');
    var paid_text_wrapper = publisher.find("#paid-text-wrapper")
    var paid_text_input = paid_text_wrapper.find('textarea');
    var paid_image_wrapper = publisher.find("#paid-image-wrapper")
    var paid_image_input = paid_image_wrapper.find('input.js_x-uploader-input');
    /* get collaborative users */
    var is_collaborative = publisher.find('.js_publisher-collaborative-toggle').is(":checked");
    var collaborative_users_wrapper = publisher.find("#collaborative-users-wrapper");
    var collaborative_users_input = collaborative_users_wrapper.find('input.js_tagify-ajax');
    var collaborative_users = collaborative_users_input.val();
    var collaborative_percent_wrapper = publisher.find("#collaborative-percent-wrapper");
    var collaborative_percent_input = collaborative_percent_wrapper.find('input');
    /* get post_as_page from hidden input if exists */
    var post_as_page = publisher.find('input[name="post_as_page"]').val();
    /* get the error element */
    var error = publisher.find('.publisher-error, .alert.alert-error, .alert.alert-danger').first();
    /* return if no data to post */
    if (!publisher.data('post-editor') && is_empty(editor.val()) && link === undefined && photos === undefined && feeling.val() == "" && location.val() == "" && voice_notes === undefined && poll_options === undefined && reel === undefined && video === undefined && audio === undefined && file === undefined) {
      return;
    }
    /* button loading */
    button_status(_this, "loading");
    posts_stream.data('loading', true);
    var payload = {
      'handle': handle,
      'id': id,
      'message': editor.val(),
      'link': JSON.stringify(link),
      'photos': JSON.stringify(photos),
      'photo_layout': publisher.data('photo_layout') || 'classic',
      'photo_order': publisher.find('.js_publisher-photo-layout').length && photos ? JSON.stringify(publisher_photo_order(publisher)) : undefined,
      'album': album.val(),
      'feeling_action': feeling.data('action'),
      'feeling_value': feeling.val(),
      'location': location.val(),
      'latitude': location_meta.find('[data-geo="lat"]').val(),
      'longitude': location_meta.find('[data-geo="lng"]').val(),
      'colored_pattern': publisher.data('colored_pattern'),
      'voice_notes': JSON.stringify(voice_notes),
      'poll_options': JSON.stringify(poll_options),
      'reel': JSON.stringify(reel),
      'reel_thumbnail': reel_thumbnail,
      'video': JSON.stringify(video),
      'video_thumbnail': video_thumbnail,
      'video_category': video_category,
      'audio': JSON.stringify(audio),
      'file': JSON.stringify(file),
      'privacy': privacy,
      'is_anonymous': is_anonymous,
      'is_schedule': is_schedule,
      'schedule_date': schedule_date,
      'for_adult': for_adult,
      'tips_enabled': tips_enabled,
      'for_subscriptions': for_subscriptions,
      'subscriptions_image': subscriptions_image_input.val(),
      'is_paid': is_paid,
      'is_paid_locked': is_paid_locked,
      'post_price': paid_price_input.val(),
      'paid_text': paid_text_input.val(),
      'paid_image': paid_image_input.val(),
      'is_collaborative': is_collaborative,
      'collaborative_users': collaborative_users,
      'collaborative_percent': collaborative_percent_input.val(),
      'post_as_page': post_as_page
    };
    if (publisher.data('post-editor')) {
      publisher.data('edit-saving', true);
      publisher_edit_save(publisher, payload, _this, error);
      return;
    }
    $.post(api['posts/post'], payload, function (response) {
      if (response.callback) {
        /* button reset */
        button_status(_this, "reset");
        eval(response.callback);
      } else {
        /* check if publisher modal mode -> prepend to the matching posts stream or redirect to post page */
        var target_stream = posts_stream;
        if (publisher.data('modal-mode')) {
          var streams = { 'me': 'newsfeed', 'user': 'posts_profile', 'page': 'posts_page', 'group': 'posts_group', 'event': 'posts_event' };
          target_stream = posts_stream.filter(function () {
            if (handle == 'me' && $(this).data('get') == 'posts_profile') {
              return $(this).data('id') == user_id;
            }
            return $(this).data('get') == streams[handle] && (handle == 'me' || $(this).data('id') == id);
          }).first();
          if (target_stream.length == 0 && !response.approval && !response.processing) {
            window.location.href = site_path + "/posts/" + response.post_id;
            return;
          }
        }
        /* button reset */
        button_status(_this, "reset");
        /* remove the error */
        error.hide();
        /* prepare publisher */
        attachment_upload_clear(publisher);
        /* remove (active|activated|disabled) from all tabs */
        publisher.find('.js_publisher-tab').removeClass('active activated disabled');
        /* empty textarea */
        textarea.val('').removeAttr('style').hide();
        textarea.attr('placeholder', textarea.data('init-placeholder'));
        /* empty quill editor */
        quill_editor_reset(quill);
        if (quill && quill.root) {
          quill.root.setAttribute('data-placeholder', textarea.data('init-placeholder'));
        }
        editor.val('');
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
        publisher_photos_refresh(publisher);
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
        x_image_reset(attachments_reel_thumbnail.find('.x-image'));
        attachments_reel_thumbnail.hide();
        /* hide & empty video custom thumbnail */
        x_image_reset(attachments_video_thumbnail.find('.x-image'));
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
        x_image_reset(subscriptions_image_wrapper.find('.x-image'));
        subscriptions_image_input.val('');
        /* uncheck paid toggle */
        publisher.find('.js_publisher-paid-toggle').prop('checked', false);
        publisher.find('.js_publisher-paid-toggle').prop('disabled', false);
        publisher.find("#paid-toggle-wrapper").removeClass("disabled");
        /* reset paid lock toggle */
        paid_locked_wrapper.hide();
        publisher.find('.js_publisher-paid-lock-toggle').prop('checked', false);
        publisher.find('.js_publisher-paid-lock-toggle').prop('disabled', false);
        /* reset paid price */
        paid_price_wrapper.hide();
        paid_price_input.val('');
        paid_text_wrapper.hide();
        paid_text_input.val('');
        /* reset paid image */
        paid_image_wrapper.hide();
        x_image_reset(paid_image_wrapper.find('.x-image'));
        paid_image_input.val('');
        /* uncheck collaborative toggle */
        publisher.find('.js_publisher-collaborative-toggle').prop('checked', false);
        /* reset collaborative users */
        collaborative_users_wrapper.hide();
        collaborative_users_input.val('');
        /* reset collaborative percentage */
        collaborative_percent_wrapper.hide();
        collaborative_percent_input.val('');
        /* reset privacy */
        publisher.find('.js_publisher-privacy').show();
        publisher.find('.js_publisher-privacy-public').hide();
        /* collapse the publisher */
        $('body').removeClass('publisher-focus');
        if (!publisher.data('modal-mode')) {
          publisher.find('.publisher-slider').slideUp();
        }
        /* release the loading status */
        posts_stream.removeData('loading');
        if (response.approval) {
          modal('#modal-success', { title: __['Under Review'], message: __['Your post is under review now, We will let you know when it is ready!'] });
        } else if (response.processing) {
          modal('#modal-success', { title: __['Processing'], message: __['Your video is being processed, We will let you know when it is ready!'] });
        } else {
          /* attache the new post */
          target_stream.find('ul:first').prepend(response.post);
          /* close the publisher modal */
          if (publisher.data('modal-mode')) {
            close_publisher_modal();
          }
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
        show_error_modal();
      });
  });
  /* publisher schedule toggle */
  $('body').on('click', '.js_publisher-schedule-toggle', function (e) {
    $("#schedule-toggle-wrapper").toggle();
    publisher_reveal(e, '#schedule-toggle-wrapper');
  });
  /* publisher anonymous toggle */
  $('body').on('click', '.js_publisher-anonymous-toggle', function () {
    var publisher = $(this).parents('.publisher');
    publisher_tab(publisher, "anonymous");
    publisher.find('.js_publisher-privacy').toggle();
    publisher.find('.js_publisher-privacy-public').toggle();
  });
  /* publisher subscribers toggle */
  $('body').on('click', '.js_publisher-subscribers-toggle', function (e) {
    var publisher = $(this).parents('.publisher');
    $("#paid-toggle-wrapper").toggleClass("disabled");
    $(".js_publisher-paid-toggle").prop("disabled", !$(".js_publisher-paid-toggle").prop("disabled"));
    $("#collaborative-toggle-wrapper").toggleClass("disabled");
    $(".js_publisher-collaborative-toggle").prop("disabled", !$(".js_publisher-collaborative-toggle").prop("disabled"));
    $("#subscriptions-image-wrapper").toggle();
    publisher.find('.js_publisher-privacy').toggle();
    publisher.find('.js_publisher-privacy-public').toggle();
    publisher_reveal(e, '#subscriptions-image-wrapper');
  });
  /* publisher paid toggle */
  $('body').on('click', '.js_publisher-paid-toggle', function (e) {
    var publisher = $(this).parents('.publisher');
    $("#subscribers-toggle-wrapper").toggleClass("disabled");
    $(".js_publisher-subscribers-toggle").prop("disabled", !$(".js_publisher-subscribers-toggle").prop("disabled"));
    $("#paid-lock-toggle-wrapper").toggle();
    $("#paid-price-wrapper").toggle();
    $("#paid-text-wrapper").toggle();
    $("#paid-image-wrapper").toggle();
    publisher.find('.js_publisher-privacy').toggle();
    publisher.find('.js_publisher-privacy-public').toggle();
    publisher_reveal(e, '#paid-lock-toggle-wrapper, #paid-price-wrapper, #paid-text-wrapper, #paid-image-wrapper');
  });
  /* publisher collaborative toggle */
  $('body').on('click', '.js_publisher-collaborative-toggle', function (e) {
    var publisher = $(this).parents('.publisher');
    $("#anonymous-toggle-wrapper").toggleClass("disabled");
    $(".js_publisher-anonymous-toggle").prop("disabled", !$(".js_publisher-anonymous-toggle").prop("disabled"));
    $("#subscribers-toggle-wrapper").toggleClass("disabled");
    $(".js_publisher-subscribers-toggle").prop("disabled", !$(".js_publisher-subscribers-toggle").prop("disabled"));
    $("#collaborative-users-wrapper").toggle();
    $("#collaborative-percent-wrapper").toggle();
    publisher.find('.js_publisher-privacy').toggle();
    publisher.find('.js_publisher-privacy-public').toggle();
    publisher_reveal(e, '#collaborative-users-wrapper, #collaborative-percent-wrapper');
  });
  /* publish new product */
  $('body').on('click', '.js_publisher-product', function () {
    var _this = $(this);
    /* get publisher */
    var publisher = _this.parents('.publisher-mini');
    if (attachment_upload_busy(publisher)) return;
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
        show_error_modal();
      });
  });
  /* publish new photos to album */
  $('body').on('click', '.js_publisher-album', function () {
    var _this = $(this);
    /* get publisher */
    var publisher = _this.parents('.publisher');
    if (attachment_upload_busy(publisher)) return;
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
    var privacy = publisher.find('.js_publisher-privacy').val();
    /* return if no data to post */
    if (photos === undefined) {
      return;
    }
    /* button loading */
    button_status(_this, "loading");
    $.post(api['albums/action'], { 'do': 'add_photos', 'id': id, 'message': textarea.val(), 'photos': JSON.stringify(photos), 'feeling_action': feeling.data('action'), 'feeling_value': feeling.val(), 'location': location.val(), 'latitude': location_meta.find('[data-geo="lat"]').val(), 'longitude': location_meta.find('[data-geo="lng"]').val(), 'privacy': privacy }, function (response) {
      if (response.callback) {
        /* button reset */
        button_status(_this, "reset");
        eval(response.callback);
      }
    }, "json")
      .fail(function () {
        /* button reset */
        button_status(_this, "reset");
        show_error_modal();
      });
  });
  /* publish new review */
  $('body').on('click', '.js_publisher-review', function () {
    var _this = $(this);
    var publisher = _this.parents('.publisher-mini');
    if (attachment_upload_busy(publisher)) return;
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
        show_error_modal();
      });
  });


  // handle AI
  /* update AI credits cost */
  $('body').on('change keyup', '.js_ai-credits-amount', function () {
    var credits_amount = $(this).val();
    var node_cost = $(this).data('node-cost');
    if (credits_amount == 0) {
      $('.js_ai-credits-cost-text').hide();
      return;
    }
    var total_cost = (1 / parseFloat(ai_credit_cost)) * credits_amount;
    $('.js_ai-credits-cost').text(total_cost);
    $('.js_ai-credits-cost-text').show();
  });
  /* generate AI text */
  $('body').on('submit', '.js_ai-generate-text', function (e) {
    e.preventDefault();
    var form = $(this);
    var submit = form.find('button[type="submit"]:visible');
    var error = form.find('.alert.alert-danger');
    button_status(submit, "loading");
    /* get ajax response */
    $.post(api['ai/generate'], form.serialize(), function (response) {
      /* button reset */
      button_status(submit, "reset");
      /* handle response */
      if (response.success) {
        /* hide error */
        error.hide();
        /* update ai credits */
        $('.js_ai-credits-balance').text(response.ai_credits);
        /* update words balance */
        $('.js_ai-words-balance').text(response.words_balance);
        /* update generated title */
        form.find('.js_ai-generated-title').val(response.generated_title);
        /* update generated text */
        form.find('.js_ai-generated-text').val(response.generated_text);
        /* show generated text */
        form.attr('data-generated', 'true');
      } else if (response.error) {
        error.html(response.message).slideDown();
      } else if (response.callback) {
        eval(response.callback);
      }
    }, "json")
      .fail(function () {
        /* button reset */
        button_status(submit, "reset");
        /* handle error */
        error.html(__['There is something that went wrong!']).slideDown();
      });
  });
  /* use generated text */
  $('body').on('click', '.js_ai-use-generated-text', function () {
    var form = $(this).closest('form');
    var handle = $(this).data('handle');
    var generated_title = form.find('.js_ai-generated-title').val();
    var generated_text = form.find('.js_ai-generated-text').val();
    /* close modal */
    modal_close();
    /* check the handle */
    if (handle == 'post') {
      /* add generated text to publisher */
      update_quill_editor($('#publisher-box').find('.js_quill').first().data('quill'), generated_text);
    } else if (handle == 'blog') {
      /* add generated title to blog title */
      $('.js_blog-title').val(generated_title);
      /* add generated text to blog */
      tinymce.get('blog-editor').setContent(generated_text);
    }
  });
  /* generate AI image */
  $('body').on('submit', '.js_ai-generate-image', function (e) {
    e.preventDefault();
    var form = $(this);
    var submit = form.find('button[type="submit"]:visible');
    var error = form.find('.alert.alert-danger');
    button_status(submit, "loading");
    /* get ajax response */
    $.post(api['ai/generate'], form.serialize(), function (response) {
      /* button reset */
      button_status(submit, "reset");
      /* handle response */
      if (response.success) {
        /* hide error */
        error.hide();
        /* update ai credits */
        $('.js_ai-credits-balance').text(response.ai_credits);
        /* update images balance */
        $('.js_ai-images-balance').text(response.images_balance);
        /* update generated image */
        var imageSrc = 'data:image/png;base64,' + response.generated_image;
        form.find('.js_ai-generated-image').attr('src', imageSrc);
        /* show generated image */
        form.attr('data-generated', 'true');
      } else if (response.error) {
        error.html(response.message).slideDown();
      } else if (response.callback) {
        eval(response.callback);
      }
    }, "json")
      .fail(function () {
        /* button reset */
        button_status(submit, "reset");
        /* handle error */
        error.html(__['There is something that went wrong!']).slideDown();
      });
  });
  /* use generated image */
  $('body').on('click', '.js_ai-use-generated-image', function () {
    /* get base64 image */
    var imageSrc = $(this).closest('form').find('.js_ai-generated-image').attr('src');
    /* close modal */
    modal_close();
    if (!imageSrc) return;
    /* get form */
    var form = $('#publisher-box').find('.js_publisher-images-uploader').find('form');
    var input = form.find('input[type="file"]');
    /* convert base64 → File */
    var file = base64ToFile(imageSrc, 'ai-image.png');
    /* create DataTransfer */
    var dataTransfer = new DataTransfer();
    dataTransfer.items.add(file);
    /* assign files to input */
    input[0].files = dataTransfer.files;
    /* trigger upload */
    input.trigger('change');
  });


  // run voice notes
  /* shim for AudioContext|getUserMedia if it's not available */
  window.AudioContext = window.AudioContext || window.webkitAudioContext;
  navigator.getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia;
  /* reset composer voice state */
  function voice_composer_reset(wrapper) {
    wrapper.removeAttr('data-state');
    wrapper.find('.js_voice-timer').html('00:00');
  }
  /* start voice recording */
  $('body').on('click', '.js_voice-start', function () {
    /* check if there recording process */
    if (voice_recording_process) {
      return;
    }
    var _this = $(this);
    var _parent = _this.closest(".voice-recording-wrapper");
    var composer = _parent.hasClass('js_composer');
    var voice_start_button = _this;
    var voice_stop_button = _parent.find('.js_voice-stop');
    var voice_timer = _parent.find(".js_voice-timer");
    var voice_processing_message = _parent.find('.js_voice-processing-message');
    var voice_success_message = _parent.find('.js_voice-success-message');
    var handle = _parent.data("handle");
    var handle_type = "voice_notes";
    voice_recording_cancelled = false;
    if (composer) {
      /* switch the composer to recording */
      _parent.attr('data-state', 'recording');
    } else {
      /* hide voice start button */
      voice_start_button.hide();
      /* show voice stop button */
      voice_stop_button.show();
    }
    /* start recording ... */
    navigator.mediaDevices.getUserMedia({ audio: true, video: false }).then(function (stream) {
      /* check if the recording cancelled while waiting for the microphone */
      if (voice_recording_cancelled) {
        stream.getTracks().forEach(function (track) { track.stop(); });
        return;
      }
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
        /* stop microphone access */
        voice_recording_stream.getTracks().forEach(function (track) { track.stop(); });
        /* stop recording timer */
        clearInterval(voice_recording_timer);
        voice_timer.html(format_timer(0));
        /* update voice processing process */
        voice_recording_process = false;
        if (composer) {
          /* switch the composer to processing */
          _parent.attr('data-state', 'processing');
        } else {
          /* hide voice stop button */
          voice_stop_button.hide();
          /* show voice processing message */
          voice_processing_message.show();
        }
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
              if (composer) {
                voice_composer_reset(_parent);
              } else if (handle == "publisher") {
                /* publisher */
                var publisher = _this.parents('.publisher');
                var publisher_button = publisher.find('.js_publisher-btn');
                /* enable publisher button */
                button_status(publisher_button, "reset");
              }
              eval(response.callback);
            } else if (composer) {
              /* send the voice note directly */
              var root = (handle == "chat") ? _parent.closest('.chat-widget, .panel-messages') : _parent.closest('.comment');
              root.data(handle_type, response.file);
              voice_composer_reset(_parent);
              _parent.find('.js_composer-send').trigger('click');
              root.removeData(handle_type);
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
              }
            }
          },
          error: function () {
            if (composer) {
              voice_composer_reset(_parent);
            }
            show_error_modal();
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
      var voice_recording_start = Date.now();
      clearInterval(voice_recording_timer);
      voice_timer.html(format_timer(0));
      voice_recording_timer = setInterval(function () {
        voice_timer.html(format_timer((Date.now() - voice_recording_start) / 1000));
      }, 1000);
      /* update voice recording process */
      voice_recording_process = true;
      /* check the handle */
      if (handle == "publisher") {
        var publisher = _this.parents('.publisher');
        var publisher_button = publisher.find('.js_publisher-btn');
        /* disable publisher button */
        button_status(publisher_button, "loading");
      }
    }).catch(function (err) {
      if (composer) {
        voice_composer_reset(_parent);
      } else {
        voice_stop_button.hide();
        voice_start_button.show();
      }
      modal('#modal-message', { title: __['Error'], message: err });
    });
  });
  /* stop voice recording */
  $('body').on('click', '.js_voice-stop', function () {
    if (!voice_recording_process || !voice_recording_object.isRecording()) {
      return;
    }
    /* stop microphone access */
    voice_recording_stream.getTracks().forEach(function (track) { track.stop(); });
    /* tell the recorder to stop the recording */
    voice_recording_object.finishRecording();
  });
  /* cancel voice recording */
  $('body').on('click', '.js_voice-cancel', function () {
    voice_recording_cancelled = true;
    if (voice_recording_process) {
      /* stop microphone access */
      voice_recording_stream.getTracks().forEach(function (track) { track.stop(); });
      /* discard the recording */
      if (voice_recording_object.isRecording()) {
        voice_recording_object.cancelRecording();
      }
      clearInterval(voice_recording_timer);
      voice_recording_process = false;
    }
    voice_composer_reset($(this).closest('.voice-recording-wrapper'));
  });
  /* remove voice record */
  $('body').on('click', '.js_voice-remove', function () {
    var _this = $(this);
    var _parent = _this.parents(".voice-recording-wrapper");
    var voice_start_button = _parent.find('.js_voice-start');
    var voice_success_message = _parent.find('.js_voice-success-message');
    var handle_type = "voice_notes";
    /* hide voice success message */
    voice_success_message.hide();
    /* show voice start button */
    voice_start_button.show();
    /* remove the uploads from publisher data */
    var publisher = _this.parents('.publisher');
    publisher.removeData(handle_type);
    publisher_tab(publisher, handle_type);
    publisher.find('.js_publisher-tab[data-tab="' + handle_type + '"]').removeClass('activated');
  });


  // run posts filter
  $('body').on('change', '.js_posts-filter', function () {
    var posts_stream = $('.js_posts_stream');
    var posts_loader = $('.js_posts_loader');
    var data = {};
    data['get'] = posts_stream.data('get');
    data['filter'] = $(this).val();
    if (posts_stream.data('category') !== undefined) {
      data['category'] = posts_stream.data('category');
    }
    if (posts_stream.data('country') !== undefined) {
      data['country'] = posts_stream.data('country');
    }
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
        }
      }
    }, 'json');
  });
  $('body').on('change', '.js_newsfeed-nav', function () {
    window.location = $(this).val();
  });


  // run posts stream
  $('body').on('click', '.js_lightbox-live', function () {
    /* initialize vars */
    var _this = $(this);
    var live_post_id = _this.data('id') || _this.parents('.post').data('id');

    /* load lightbox */
    var lightbox = $(render_template("#lightbox-live", { 'post_id': live_post_id }));
    $('body').addClass('lightbox-open overflow-hidden').append(lightbox.fadeIn('fast'));

    /* get live post */
    $.post(api['live/reaction'], { 'do': 'join', 'post_id': live_post_id }, async function (response) {
      /* check the response */
      if (response.callback) {
        $('body').removeClass('lightbox-open overflow-hidden');
        $('.lightbox').remove();
        eval(response.callback);
      } else {
        lightbox.find('.lightbox-post').replaceWith(response.lightbox);
        if (response.live_ended) {
          /* show live status */
          $('#js_live-status').html('<span class="icon-[tabler--alert-circle] size-5 shrink-0" aria-hidden="true"></span>' + __['Live Ended']).addClass("error");
        } else {
          /* init agora client */
          await join(response.agora_channel_name, (response.live_provider == "livekit") ? response.livekit_token : response.agora_audience_token, response.agora_audience_uid, response.live_provider);
        }
      }
    }, 'json');
  });


  // run video lightbox
  $('body').on('click', '.js_lightbox-video', function (e) {
    if ($(e.target).closest('a').length) {
      return;
    }
    e.preventDefault();
    /* initialize vars */
    var post_id = $(this).data('id');
    /* load lightbox */
    var lightbox = $(render_template("#lightbox-video", {}));
    $('body').addClass('lightbox-open overflow-hidden').append(lightbox.fadeIn('fast'));
    /* get video post */
    $.post(api['posts/lightbox-video'], { 'post_id': post_id }, function (response) {
      /* check the response */
      if (response.callback) {
        $('body').removeClass('lightbox-open overflow-hidden');
        $('.lightbox').remove();
        eval(response.callback);
      } else {
        lightbox.find('.lightbox-post').replaceWith(response.lightbox);
        lightbox.find('.lightbox-video-stage').html(response.player);
        lightbox.find('a.lightbox-download').attr('href', response.download);
        initialize();
        var video = lightbox.find('video.js_video-plyr')[0];
        if (video && video.plyr) {
          video.plyr.play();
        }
      }
    }, 'json');
  });


  // live stream buttons
  $('body').on('click', '.js_live-sound', function () {
    var muted = $(this).attr('aria-pressed') !== 'true';
    $(this).attr('aria-pressed', muted);
    if (live_post_audio_track) {
      if (live_post_room) {
        live_post_room.startAudio();
        live_post_audio_track.setVolume(muted ? 0 : 1);
      } else {
        live_post_audio_track.setVolume(muted ? 0 : 100);
      }
    }
  });
  $('body').on('click', '.js_live-fullscreen', function () {
    var stage = $(this).closest('.js_live-stage')[0];
    if (document.fullscreenElement || document.webkitFullscreenElement) {
      (document.exitFullscreen || document.webkitExitFullscreen).call(document);
    } else {
      (stage.requestFullscreen || stage.webkitRequestFullscreen).call(stage);
    }
  });
  $(document).on('fullscreenchange webkitfullscreenchange', function () {
    $('.js_live-fullscreen').attr('aria-pressed', !!(document.fullscreenElement || document.webkitFullscreenElement));
  });


  // handle post
  /* edit post */
  $('body').on('click', '.js_edit-post', function () {
    $(this).removeClass('js_edit-post').addClass('js_modal').data('url', 'posts/publisher.php?do=edit&post_id=' + $(this).closest('.post').data('id')).data('size', 'publisher').data('static', true).trigger('click');
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
        show_error_modal();
      });
  });
  /* edit privacy */
  $('body').on('change', '.js_edit-privacy', function () {
    var _this = $(this);
    var post = _this.parents('.post');
    var id = post.data('id');
    var privacy = _this.val();
    $.post(api['posts/edit'], { 'handle': 'privacy', 'id': id, 'privacy': privacy }, function (response) {
      /* check if there is a callback */
      if (response.callback) {
        eval(response.callback);
      }
    }, 'json')
      .fail(function () {
        show_error_modal();
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
        modal_close();
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
          show_error_modal();
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
        show_error_modal();
      });
  });
  /* delete blog */
  $('body').on('click', '.js_delete-blog', function (e) {
    e.preventDefault();
    var id = $(this).data('id');
    confirm(__['Delete Post'], __['Are you sure you want to delete this post?'], function () {
      $.post(api['posts/reaction'], { 'do': 'delete_post', 'id': id }, function (response) {
        /* check the response */
        modal_close();
        if (response.callback) {
          eval(response.callback);
        }
        window.location = site_path + "/blogs";
      }, 'json')
        .fail(function () {
          show_error_modal();
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
        show_error_modal();
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
        show_error_modal();
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
        _this.removeClass('js_closed-post').addClass('js_unclosed-post').find('span').text(__['Mark as Available']);
      }
    }, 'json')
      .fail(function () {
        show_error_modal();
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
        _this.removeClass('js_unclosed-post').addClass('js_closed-post').find('span').text(__['Mark as Closed']);
      }
    }, 'json')
      .fail(function () {
        show_error_modal();
      });
  });
  /* save post */
  $('body').on('click', '.js_save-post', function () {
    var _this = $(this);
    var post = _this.parents('.post');
    var id = _this.data('id') || post.data('id');
    $.post(api['posts/reaction'], { 'do': 'save_post', 'id': id }, function (response) {
      /* check the response */
      if (response.callback) {
        eval(response.callback);
      } else {
        _this.removeClass('js_save-post').addClass('js_unsave-post').find('span').text(__['Unsave Post']);
      }
    }, 'json')
      .fail(function () {
        show_error_modal();
      });
  });
  /* unsave post */
  $('body').on('click', '.js_unsave-post', function () {
    var _this = $(this);
    var post = _this.parents('.post');
    var id = _this.data('id') || post.data('id');
    $.post(api['posts/reaction'], { 'do': 'unsave_post', 'id': id }, function (response) {
      /* check the response */
      if (response.callback) {
        eval(response.callback);
      } else {
        _this.removeClass('js_unsave-post').addClass('js_save-post').find('span').text(__['Save Post']);
      }
    }, 'json')
      .fail(function () {
        show_error_modal();
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
        show_error_modal();
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
        show_error_modal();
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
        show_error_modal();
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
        show_error_modal();
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
        show_error_modal();;
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
        show_error_modal();;
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
        show_error_modal();
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
        show_error_modal();
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
        show_error_modal();
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
        show_error_modal();
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
        show_error_modal();
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
        show_error_modal();
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
        modal_close();
        /* check the response */
        if (response.callback) {
          eval(response.callback);
        } else {
          post.addClass('is_hidden');
          _this.removeClass('js_disallow-post').addClass('js_allow-post').find('span').text(__['Allow on Timeline']);
        }
      }, 'json')
        .fail(function () {
          show_error_modal();
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
        show_error_modal();
      });
  });
  /* show shared post attachments */
  $('body').on('click', '.js_show-attachments', function () {
    $(this).next().toggle();
  });
  /* poll vote */
  $('body').on('click', '.js_poll-vote', function () {
    var _this = $(this);
    var parent = _this.closest('.poll-options');
    if (parent.data('voting')) {
      return;
    }
    var id = _this.data('id');
    var checked_id = parent.find('.poll-option[aria-pressed="true"]').data('id');
    var _do = checked_id === undefined ? 'add_vote' : (checked_id == id ? 'delete_vote' : 'change_vote');
    var polls = $('.poll-options').filter(function () {
      return $(this).data('poll-id') == parent.data('poll-id');
    });
    var restore_focus = _this.is(':focus');
    var vote_updated = false;
    /* lock voting */
    polls.data('voting', true).attr('aria-busy', 'true').find('button').prop('disabled', true);
    $.post(api['posts/reaction'], { 'do': _do, 'id': id, 'checked_id': checked_id }, function (response) {
      /* check the response */
      if (response.callback) {
        eval(response.callback);
        return;
      }
      if (response.template) {
        var results = $('<div>').html(response.template);
        var options = results.find('.poll-option');
        polls.each(function () {
          var poll = $(this);
          var current_options = poll.find('.poll-option');
          var matching_options = current_options.length === options.length && options.toArray().every(function (option, index) {
            return $(option).attr('data-id') === current_options.eq(index).attr('data-id');
          });
          if (!matching_options || poll.find('.poll-check').length !== options.length) {
            poll.html(response.template);
            return;
          }
          /* keep options in place for transitions */
          options.each(function (index) {
            var next = $(this);
            var current = current_options.eq(index);
            current.attr('class', next.attr('class')).attr('aria-pressed', next.attr('aria-pressed'))
              .attr('data-option-votes', next.attr('data-option-votes')).data('option-votes', next.data('option-votes'));
            ['.percentage-bg', '.poll-check', '.poll-label', '.poll-voters-space'].forEach(function (selector) {
              current.find(selector).attr('class', next.find(selector).attr('class'));
            });
            current.find('.percentage-bg')[0].style.width = next.find('.percentage-bg')[0].style.width;
            current.find('.poll-percentage').text(next.find('.poll-percentage').text());
            current.siblings('.poll-voters').remove();
            current.after(next.siblings('.poll-voters').clone());
          });
          poll.find('.poll-votes-count').text(results.find('.poll-votes-count').text());
        });
        polls.data('poll-votes', response.votes).attr('data-poll-votes', response.votes);
        vote_updated = true;
      }
    }, 'json')
      .fail(function () {
        show_error_modal();
      })
      .always(function () {
        polls.removeData('voting').removeAttr('aria-busy').find('button').prop('disabled', false);
        if (vote_updated && restore_focus) {
          parent.find('.poll-option').filter(function () {
            return $(this).data('id') == id;
          }).trigger('focus');
        }
      });
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
    var comment = _this.closest('.comment');
    if (attachment_upload_busy(comment)) return;
    var stream = _this.parents('.post-comments').find('.js_comments');
    var handle = comment.data('handle');
    var id = comment.data('id');
    var textarea = comment.find('textarea.js_post-comment');
    var message = textarea.val();
    var attachments = comment.find('.comment-attachments');
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
    /* get gif from comment data */
    var gif = comment.data('gif') || '';
    /* check if message is empty */
    if (is_empty(message) && !photo && !voice_note && !gif) {
      return;
    }
    /* add currenet sending process */
    comment.data('sending', true);
    $.post(api['posts/comment'], { 'handle': handle, 'id': id, 'message': message, 'photo': JSON.stringify(photo), 'voice_note': JSON.stringify(voice_note), 'gif': gif }, function (response) {
      /* remove currenet sending process */
      comment.removeData('sending');
      /* check if there is a callback */
      if (response.callback) {
        eval(response.callback);
      } else {
        textarea.val('');
        textarea.attr('style', '');
        attachments.hide();
        attachments.find('li.item').remove();
        attachment_upload_clear(comment);
        composer_gif_clear(comment);
        comment.removeData('photos');
        comment.find('.x-form-tools-attach').show();
        comment.removeData('voice_notes');
        if (!stream.hasClass("js_live-comments")) {
          stream.prepend(response.comment);
        } else {
          live_comments_refresh();
          live_socket_notify($('<div>').html(response.comment).find('.comment:first').data('id'));
        }
      }
    }, 'json')
      .fail(function () {
        comment.removeData('sending');
        show_error_modal();
      });
  }
  $('body').on('keydown', 'textarea.js_post-comment', function (event) {
    if (!is_mobile() && (event.originalEvent.key == 'Enter' && event.shiftKey == 0)) {
      event.preventDefault();
      _comment(this);
    }
  });
  $('body').on('click', 'button.js_post-comment', function () {
    _comment(this);
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
    var comment = _this.closest('.comment');
    if (attachment_upload_busy(comment)) return;
    var stream = comment.find('.js_replies');
    var handle = 'comment';
    var id = comment.data('id');
    var textarea = comment.find('textarea.js_post-reply');
    var message = textarea.val();
    var attachments = comment.find('.comment-attachments');
    /* get photo from comment data */
    var photo = comment.data('photos');
    /* get voice note from comment data */
    var voice_note = comment.data('voice_notes');
    /* get gif from comment data */
    var gif = comment.data('gif') || '';
    /* check if message is empty */
    if (is_empty(message) && !photo && !voice_note && !gif) {
      return;
    }
    $.post(api['posts/comment'], { 'handle': handle, 'id': id, 'message': message, 'photo': JSON.stringify(photo), 'voice_note': JSON.stringify(voice_note), 'gif': gif }, function (response) {
      /* check if there is a callback */
      if (response.callback) {
        eval(response.callback);
      } else {
        textarea.val('');
        textarea.attr('style', '');
        attachments.hide();
        attachments.find('li.item').remove();
        attachment_upload_clear(comment);
        composer_gif_clear(comment);
        comment.removeData('photos');
        comment.find('.x-form-tools-attach').show();
        comment.removeData('voice_notes');
        stream.append(response.comment);
        if (stream.closest('.js_live-comments').length) {
          live_socket_notify($('<div>').html(response.comment).find('.comment:first').data('id'));
        }
      }
    }, 'json')
      .fail(function () {
        show_error_modal();
      });
  }
  $('body').on('keydown', 'textarea.js_post-reply', function (event) {
    if (!is_mobile() && (event.originalEvent.key == 'Enter' && event.shiftKey == 0)) {
      event.preventDefault();
      _reply(this);
    }
  });
  $('body').on('click', 'button.js_post-reply', function () {
    _reply(this);
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
          modal_close();
          live_socket_moderation();
        }
      }, 'json')
        .fail(function () {
          show_error_modal();
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
    if (attachment_upload_busy(comment)) return;
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
        attachment_upload_clear(comment);
        comment.find('.comment-replace:first').html(response.comment);
        comment.find('.comment-data:first').show();
      }
    }, 'json')
      .fail(function () {
        show_error_modal();
      });
  });


  // run comments filter
  $('body').on('change', '.js_comments-filter', function () {
    var _this = $(this);
    var _parent = _this.parents('.post-comments');
    var comments_stream = _parent.find('.js_comments');
    var comments_loader = _parent.find('.js_comments-filter-loader');
    var comments_see_more = _parent.find('.js_see-more');
    var data = {};
    data['get'] = _this.val();
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
  /* update the reactions stats (posts & photos & comments) */
  function update_reactions_stats(parent, handle, response) {
    if (typeof response.template === 'undefined') {
      return;
    }
    if (handle == 'comment') {
      if (parent.closest('.js_live-comments').length) {
        live_socket_notify(parent.data('id'));
      }
      var stats = parent.find('.js_comment-reactions-stats:first');
      stats.removeClass('hidden');
      reactions_stats_update(stats, response.template, function () {
        stats.toggleClass('hidden', is_empty(response.template));
      });
    } else if (response.template) {
      reactions_stats_update(parent.find('.js_post-reactions-stats:first'), response.template);
    }
    if (handle == 'post' && typeof response.reactions_count !== 'undefined') {
      parent.find('.js_reel-reactions-count:first').text(response.reactions_count);
    }
    if (handle == 'post' && live_socket_post_id && parent.closest('[data-live-post-id]').length) {
      live_comments_refresh();
      if (chat_socket_enabled && typeof chat_socket !== "undefined" && chat_socket) {
        chat_socket.emit('event_client_live_reaction', { post_id: live_socket_post_id });
      }
    }
  }
  var reactions_hide_timer;
  function post_message_reaction(_do, id, reaction) {
    if (typeof chat_socket_enabled !== 'undefined' && chat_socket_enabled && chat_socket && chat_socket.connected) {
      chat_socket.emit('event_client_react_message', { do: (_do == 'unreact_message') ? 'unreact' : 'react', message_id: id, reaction: reaction }, function (response) {
        var data = JSON.parse(response);
        if (typeof chat_update_reactions === 'function') {
          chat_update_reactions(data.message_id, data.reactions, data.reactions_total_count, data.reactions_total_count_formatted);
        }
      });
    } else {
      $.post(api['chat/actions'], { 'do': _do, 'reaction': reaction, 'message_id': id }, function (response) {
        if (response.callback) {
          eval(response.callback);
        }
        if (response.message && typeof chat_update_reactions === 'function') {
          chat_update_reactions(id, response.message.reactions, response.message.reactions_total_count, response.message.reactions_total_count_formatted);
        }
      }, 'json').fail(function () {
        show_error_modal();
      });
    }
  }
  function _reaction_button(_parent, handle, reaction, source) {
    var name = _parent.find('.reaction-btn-name:first');
    var icon = _parent.find('.reaction-btn-icon:first');
    var in_reel = icon.closest('.reel-container').length > 0;
    var size = (handle == 'message') ? 'size-4' : 'size-5';
    var html;
    if (reaction) {
      name.text(reaction.title).removeAttr('style').css('color', reaction.color);
      html = '<div class="inline-emoji no_animation inline-flex ' + (in_reel ? 'size-6' : size) + '">' + reaction.html + '</div>';
    } else {
      name.text(__['React']).removeAttr('style');
      html = '<span class="icon-[tabler--mood-smile] ' + size + '" aria-hidden="true"></span>';
    }
    ui_animate(name[0], [{ opacity: 0, transform: 'translateY(40%)' }, { opacity: 1, transform: 'none' }], { duration: 260, easing: 'cubic-bezier(0.22, 1, 0.36, 1)' });
    reaction_icon_swap(icon, html, source);
  }
  function _show_reactions(element) {
    var _this = $(element);
    var reactions = _this.find('.reactions-container');
    var hiding = reactions[0] && reactions[0]._ui_hide;
    var was_visible = reactions.is(':visible') && !hiding;
    if (hiding) {
      hiding.onfinish = null;
      hiding.cancel();
      reactions[0]._ui_hide = null;
    }
    if (was_visible) return;
    var is_reel = _this.parents('.reel-container').length;
    var chat_widget = _this.closest('.chat-widget');
    var touch = current_page == 'reels' || is_iPad() || is_mobile();
    var edge = 8;
    /* measure from the containing block (lightbox, carousel, chat box) */
    reactions.css({ 'top': 0, 'left': 0, 'right': 'auto' }).show();
    var origin = reactions[0].getBoundingClientRect();
    var width = reactions[0].offsetWidth;
    var height = reactions[0].offsetHeight;
    var button = element.getBoundingClientRect();
    /* touch screens open the reactions right above the button */
    var top = (touch || is_reel) ? button.top - height - edge : button.top - 40;
    var below = false;
    if (top < edge) {
      top = button.bottom + edge;
      below = true;
    }
    /* chat boxes open the reactions away from the screen edge */
    var from_right = ($('html').attr('dir') == "rtl") ? !chat_widget.length : chat_widget.length > 0;
    from_right = from_right || (is_reel && $('html').attr('dir') != "rtl");
    var left = from_right ? button.right - width : button.left;
    /* keep the reactions inside the viewport */
    left = Math.max(edge, Math.min(left, window.innerWidth - edge - width));
    /* keep the reactions inside the chat box */
    if (chat_widget.length) {
      var box = chat_widget[0].getBoundingClientRect();
      left = Math.max(box.left + edge, Math.min(left, box.right - edge - width));
    }
    reactions.css({
      'top': (top - origin.top) + 'px',
      'left': (left - origin.left) + 'px',
      'transform-origin': (below ? 'top ' : 'bottom ') + (from_right ? 'right' : 'left')
    });
    ui_animate(reactions[0], [
      { opacity: 0, transform: 'translateY(8px) scale(0.6)' },
      { opacity: 1, transform: 'none' }
    ], { duration: 320, easing: ui_spring });
  }
  function _hide_reactions(element) {
    var _this = $(element);
    var reactions = _this.find('.reactions-container:first');
    if (reactions[0] && reactions[0]._ui_hide) return;
    var animation = ui_animate(reactions[0], [
      { opacity: 1, transform: 'none' },
      { opacity: 0, transform: 'translateY(4px) scale(0.85)' }
    ], { duration: 150, easing: 'cubic-bezier(0.4, 0, 1, 1)', fill: 'forwards' });
    if (!animation) {
      reactions.removeAttr('style').hide();
      return;
    }
    reactions[0]._ui_hide = animation;
    animation.onfinish = function () {
      reactions[0]._ui_hide = null;
      reactions.removeAttr('style').hide();
      animation.cancel();
    };
  }
  /* reactions toggle */
  $('body').on('mouseenter', '.reactions-wrapper, .reactions-container', function () {
    clearTimeout(reactions_hide_timer);
    if (current_page != 'reels' && !is_iPad() && !is_mobile()) {
      var wrapper = $(this).closest('.reactions-wrapper');
      if (wrapper.length) {
        _show_reactions(wrapper[0]);
      }
    }
  });
  $('body').on('mouseleave', '.reactions-wrapper, .reactions-container', function (e) {
    if (current_page != 'reels' && !is_iPad() && !is_mobile()) {
      if ($(e.relatedTarget).closest('.reactions-wrapper, .reactions-container').length) {
        return;
      }
      var wrapper = $(this).closest('.reactions-wrapper');
      reactions_hide_timer = setTimeout(function () {
        if (wrapper.length) {
          _hide_reactions(wrapper[0]);
        }
      }, 200);
    }
  });
  $('body').on('click', '.reactions-wrapper', function (e) {
    if ($(e.target).closest('.js_react-post, .js_react-photo, .js_react-comment, .js_react-message').length) {
      return;
    }
    if (current_page == 'reels' || is_iPad() || is_mobile()) {
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
          var _parent = _this.closest('.post, .lightbox-post, .blog, .reel-container');
        } else if (_this.hasClass('js_unreact-photo')) {
          var _undo = 'unreact_photo';
          var handle = 'photo';
          var _parent = _this.closest('.post, .lightbox-post');
        } else if (_this.hasClass('js_unreact-comment')) {
          var _undo = 'unreact_comment';
          var handle = 'comment';
          var _parent = _this.closest('.comment');
        } else if (_this.hasClass('js_unreact-message')) {
          var _undo = 'unreact_message';
          var handle = 'message';
          var _parent = _this.closest('.conversation');
        }
        var id = _parent.data('id') || _parent.attr('id');
        var reactions_wrapper = _parent.find('.reactions-wrapper:first');
        /* remove unreact from reactions-wrapper */
        reactions_wrapper.removeClass('js_unreact-' + handle);
        /* remove reactions-wrapper data-reaction */
        reactions_wrapper.data('reaction', '');
        /* change reaction-btn */
        _reaction_button(_parent, handle);
        /* hide reactions-container */
        _parent.find('.reactions-container:visible').removeAttr('style').hide();
        /* AJAX */
        if (handle == 'message') {
          post_message_reaction(_undo, id, old_reaction);
        } else {
          $.post(api['posts/reaction'], { 'do': _undo, 'reaction': old_reaction, 'id': id }, function (response) {
            /* check the response */
            if (response.callback) {
              eval(response.callback);
            }
            update_reactions_stats(_parent, handle, response);
          }, 'json')
            .fail(function () {
              show_error_modal();
            });
        }
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
  $('body').on('click', '.js_react-post, .js_react-photo, .js_react-comment, .js_react-message', function (e) {
    e.preventDefault();
    e.stopPropagation();
    e.stopImmediatePropagation();
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
    } else if (_this.hasClass('js_react-message')) {
      var _do = 'react_message';
      var _undo = 'unreact_message';
      var handle = 'message';
      var _parent = _this.closest('.conversation');
    }
    var id = _parent.data('id') || _parent.attr('id');
    var reactions_wrapper = _parent.find('.reactions-wrapper:first');
    var old_reaction = reactions_wrapper.data('reaction');
    /* check if user react or unreact */
    if (reactions_wrapper.hasClass('js_unreact-' + handle) && old_reaction == reaction) {
      /* [1] user unreact */
      /* remove unreact class from reactions-wrapper */
      reactions_wrapper.removeClass('js_unreact-' + handle);
      /* remove reactions-wrapper data-reaction */
      reactions_wrapper.data('reaction', '');
      /* change reaction-btn */
      _reaction_button(_parent, handle);
      /* hide reactions-container */
      _parent.find('.reactions-container:visible').removeAttr('style').hide();
      /* AJAX */
      if (handle == 'message') {
        post_message_reaction(_undo, id, old_reaction);
      } else {
        $.post(api['posts/reaction'], { 'do': _undo, 'reaction': old_reaction, 'id': id }, function (response) {
          /* check the response */
          if (response.callback) {
            eval(response.callback);
          }
          update_reactions_stats(_parent, handle, response);
        }, 'json')
          .fail(function () {
            show_error_modal();
          });
      }
    } else {
      /* [2] user react */
      /* add unreact class to reactions wrapper */
      if (!reactions_wrapper.hasClass('js_unreact-' + handle)) {
        reactions_wrapper.addClass('js_unreact-' + handle);
      }
      /* change reactions-wrapper data-reaction */
      reactions_wrapper.data('reaction', reaction);
      /* change reaction-btn */
      _reaction_button(_parent, handle, { title: reaction_title, color: reaction_color, html: reaction_html }, _this.find('img')[0]);
      /* hide reactions-container */
      _parent.find('.reactions-container:visible').removeAttr('style').hide();
      /* AJAX */
      if (handle == 'message') {
        post_message_reaction(_do, id, reaction);
      } else {
        $.post(api['posts/reaction'], { 'do': _do, 'reaction': reaction, 'id': id }, function (response) {
          /* check the response */
          if (response.callback) {
            eval(response.callback);
          }
          update_reactions_stats(_parent, handle, response);
        }, 'json')
          .fail(function () {
            show_error_modal();
          });
      }
    }
  });


  // handle blogs
  /* add reference */
  $('body').on('click', '.js_add-blog-reference', function () {
    var index = $('#blog-references-list .auto-connect-node').length + 1;
    $('#blog-references-list').append(render_template('#blog-reference', { index })).fadeIn();
  });
  /* schedule date (local -> utc) */
  $('body').on('change', '.js_blog-schedule-date', function () {
    var local_schedule_date = $(this).val();
    local_schedule_date = (local_schedule_date) ? new Date(local_schedule_date.replace(' ', 'T') + ':00') : '';
    $('.js_blog-schedule-utc').val((local_schedule_date) ? local_schedule_date.toISOString().slice(0, 19).replace('T', ' ') : '');
  });
  /* schedule date (utc -> local) */
  $('.js_blog-schedule-utc').each(function () {
    var schedule_date = $(this).val();
    if (!schedule_date) return;
    var date = new Date(schedule_date.replace(' ', 'T') + 'Z');
    var local = new Date(date.getTime() - date.getTimezoneOffset() * 60000);
    $('.js_blog-schedule-date').val(local.toISOString().slice(0, 16));
  });


  // handle translator
  /* request a translation (cached on the server) */
  function request_translation(data, onResult, onSame, onFail) {
    $.post(api['data/translate'], data, function (response) {
      if (response.callback) {
        if (onFail) onFail();
        eval(response.callback);
        return;
      }
      if (response.error) {
        if (onFail) onFail();
        modal('#modal-message', { title: __['Error'], message: response.message });
        return;
      }
      if (response.same) {
        onSame();
        return;
      }
      onResult(response.translations);
    }, 'json')
      .fail(function () {
        if (onFail) onFail();
        show_error_modal();
      });
  }
  $('body').on('click', '.js_translator', function () {
    /* check if translator is enabled */
    if (!post_translation_enabled) {
      return;
    }
    var _this = $(this);
    var is_toggle = _this.hasClass('js_translator-toggle');
    var is_description = _this.hasClass('js_translator-description');
    var container = _this.closest('.post-snippet, .post, .lightbox-post, .post-media, .js_translate-wrapper');
    var sourceSelector = _this.data('source') || '.post-text';
    var translationSelector = _this.data('translation') || '.post-text-translation';
    var $source = container.find(sourceSelector + ':first');
    var $translation = container.find(translationSelector + ':first');
    var node = { 'node_type': _this.data('node-type'), 'node_id': _this.data('node-id') };
    /* toggle between original and translated title */
    if (is_toggle && _this.data('translated-text')) {
      if (_this.data('showing-translated')) {
        $source.text(_this.data('original-text'));
        _this.data('showing-translated', false);
        _this.removeClass('active');
      } else {
        $source.text(_this.data('translated-text'));
        _this.data('showing-translated', true);
        _this.addClass('active');
      }
      return;
    }
    /* check if a request is running */
    if (_this.data('translating')) {
      return;
    }
    _this.data('translating', true);
    var reset = function () {
      _this.removeData('translating');
    };
    /* title toggle icons (page / group / event) */
    if (is_toggle) {
      var original_text = $source.text();
      request_translation($.extend({ 'field': 'title' }, node), function (translations) {
        reset();
        if (!translations.title) {
          return;
        }
        _this.data('original-text', original_text);
        _this.data('translated-text', translations.title);
        _this.data('showing-translated', true);
        $source.text(translations.title);
        _this.addClass('active');
      }, reset, reset);
      return;
    }
    /* about / bio description icons (page / group / event) */
    if (is_description) {
      request_translation($.extend({ 'field': 'description' }, node), function (translations) {
        reset();
        if (translations.description) {
          $translation.text(translations.description).hide().fadeIn(250);
        }
        _this.hide();
      }, function () {
        reset();
        _this.hide();
      }, reset);
      return;
    }
    /* post header "Translate" button: translates the body text and, for product-style
       posts (job / course / funding / offer), the post title in place too */
    var is_icon = _this.hasClass('js_translator-icon');
    var shimmer = 'animate-shimmer [animation-duration:2s] bg-[linear-gradient(90deg,var(--color-base-content)_0%,var(--color-base-content)_12%,var(--color-base-300)_25%,var(--color-base-content)_38%,var(--color-base-content)_62%,var(--color-base-300)_75%,var(--color-base-content)_88%,var(--color-base-content)_100%)] bg-size-[200%_100%] bg-clip-text text-transparent! [&_*]:text-transparent!';
    /* shimmer the text and disable the button while translating */
    if (is_icon) {
      _this.prop('disabled', true);
      $source.addClass(shimmer);
    }
    var mark_done = function () {
      reset();
      $source.removeClass(shimmer);
      if (is_icon) {
        _this.removeClass('js_translator').attr({ 'title': __['Translated'], 'aria-label': __['Translated'] });
        return;
      }
      _this.removeClass('text-primary cursor-pointer js_translator').text(__['Translated']);
    };
    var mark_failed = function () {
      reset();
      $source.removeClass(shimmer);
      _this.prop('disabled', false);
    };
    request_translation(node, function (translations) {
      mark_done();
      if (translations.title) {
        container.find('.js_post_title:first').text(translations.title);
      }
      if (translations.text) {
        $translation.text(translations.text).hide().fadeIn(250);
      }
    }, mark_done, mark_failed);
  });
  $('body').on('click', '.js_chat-translator', function () {
    /* check if translator is enabled */
    if (!chat_translation_enabled) {
      return;
    }
    var _this = $(this);
    var $text = _this.find('.text:first');
    var message_id = _this.closest('.conversation').attr('id');
    /* stop listening on this message */
    _this.removeClass('js_chat-translator');
    /* check text */
    if (is_empty($text.text()) || !message_id) {
      _this.find('.translate').remove();
      return;
    }
    request_translation({ 'node_type': 'message', 'node_id': message_id }, function (translations) {
      _this.find('.translate').remove();
      if (!translations.text) {
        return;
      }
      $text.text(translations.text).addClass("x-notifier");
      setTimeout(function () {
        $text.removeClass("x-notifier");
      }, 2500);
    }, function () {
      _this.find('.translate').remove();
    }, function () {
      _this.addClass('js_chat-translator');
    });
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
          show_error_modal();
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
          modal_close();
        }
      }, 'json')
        .fail(function () {
          show_error_modal();
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
        show_error_modal();
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
        show_error_modal();
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
          show_error_modal();
        });
      /* hide the confimation */
      modal_close();
    });
  });


  // handle daytime messages
  /* hide */
  $('body').on('click', '.js_daytime-remover', function () {
    var daytime_message = $(this).closest('.daytime_message');
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
          show_error_modal();
        });
      /* hide the confimation */
      modal_close();
    });
  });


  // handle forums
  /* update forum thread [pin|unpin|lock|unlock] */
  $('body').on('click', '.js_forum-thread-action', function () {
    var id = $(this).data('id');
    var _do = $(this).data('do');
    $.post(api['forums/thread'] + '?do=' + _do + '&id=' + id, function (response) {
      /* check the response */
      if (response.callback) {
        eval(response.callback);
      }
    }, 'json')
      .fail(function () {
        show_error_modal();
      });
  });
  /* like forum [thread|reply] */
  $('body').on('click', '.js_forum-like', function () {
    var _this = $(this);
    var _do = (_this.hasClass('text-primary')) ? 'unlike' : 'like';
    $.post(api['forums/react'], { 'do': _do, 'handle': _this.data('handle'), 'id': _this.data('id') }, function (response) {
      /* check the response */
      if (response.callback) {
        eval(response.callback);
      } else {
        _this.toggleClass('text-primary', _do == 'like');
        _this.attr('aria-pressed', _do == 'like');
        _this.find('.js_forum-likes').text(response.likes);
      }
    }, 'json')
      .fail(function () {
        show_error_modal();
      });
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
          show_error_modal();
        });
    });
  });
  /* reply to forum reply */
  $('body').on('click', '.js_forum-reply-to', function () {
    var quote = $('.js_forum-reply-quote');
    var id = $(this).data('id');
    if (id) {
      quote.find('.js_forum-reply-quote-picture').attr('src', $(this).data('picture'));
      quote.find('.js_forum-reply-quote-name').text($(this).data('name'));
      quote.find('.js_forum-reply-quote-text').text($(this).data('text'));
      quote.removeClass('hidden').addClass('flex');
      quote.prev('input').val(id);
    } else {
      quote.removeClass('flex').addClass('hidden');
      quote.prev('input').val('');
    }
  });
  $('body').on('click', '.js_forum-reply-cancel', function () {
    var quote = $('.js_forum-reply-quote');
    quote.removeClass('flex').addClass('hidden');
    quote.prev('input').val('');
  });
  /* forum thread scrubber */
  if ($('.js_forum-scrubber').length > 0) {
    var scrubber = $('.js_forum-scrubber');
    var scrubber_track = scrubber.find('.js_forum-scrubber-track');
    var scrubber_handle = scrubber.find('.js_forum-scrubber-handle');
    var scrubber_total = parseInt(scrubber.data('total'), 10);
    var scrubber_per_page = parseInt(scrubber.data('per-page'), 10);
    var scrubber_offset = 110;
    var scrubber_ord = 1;
    var scrubber_dragging = false;
    var scrubber_ticking = false;
    /* render the handle */
    var scrubber_render = function (ord) {
      ord = Math.min(Math.max(ord, 1), scrubber_total);
      scrubber_ord = ord;
      var range = scrubber_track.height() - scrubber_handle.outerHeight();
      var position = (scrubber_total > 1) ? (ord - 1) / (scrubber_total - 1) * range : 0;
      var index = (scrubber.data('sort') == 'newest' && ord > 1) ? scrubber_total - ord + 2 : ord;
      var post = $('.js_forum-post[data-ord="' + ord + '"]');
      var date = '';
      if (post.length > 0) {
        date = moment(post.data('time'), ["YYYY-MM-DD HH:mm:ss", "YYYY-MM-DD H:mm:ss", moment.ISO_8601]).add({ minutes: moment().utcOffset() }).locale($('html').data('lang') || 'en-us').format("MMMM YYYY");
      }
      scrubber_handle.css('top', position + 'px').attr('aria-valuenow', index);
      scrubber.find('.js_forum-scrubber-index').text(index);
      scrubber.find('.js_forum-scrubber-date').text(date);
    };
    /* get the ord from the pointer */
    var scrubber_pointer_ord = function (e) {
      var range = scrubber_track.height() - scrubber_handle.outerHeight();
      var position = e.clientY - scrubber_track[0].getBoundingClientRect().top - scrubber_handle.outerHeight() / 2;
      position = Math.min(Math.max(position, 0), range);
      return (range > 0) ? Math.round(position / range * (scrubber_total - 1)) + 1 : 1;
    };
    /* go to the post */
    var scrubber_go = function (ord) {
      var post = $('.js_forum-post[data-ord="' + ord + '"]').filter(':visible');
      if (post.length > 0) {
        window.scrollTo({ top: post.offset().top - scrubber_offset + 10, behavior: 'smooth' });
      } else {
        var page = Math.max(1, Math.ceil((ord - 1) / scrubber_per_page));
        window.location = scrubber.data('url') + '?sort=' + scrubber.data('sort') + '&page=' + page + '&post=' + ord;
      }
    };
    /* sync the handle with the scroll */
    var scrubber_sync = function () {
      scrubber_ticking = false;
      if (scrubber_dragging) return;
      var ord = null;
      $('.js_forum-post').filter(':visible').each(function () {
        if (ord === null || this.getBoundingClientRect().top <= window.innerHeight / 2) {
          ord = parseInt($(this).data('ord'), 10);
        }
      });
      if (ord !== null) {
        scrubber_render(ord);
      }
    };
    $(window).on('scroll resize', function () {
      if (!scrubber_ticking) {
        scrubber_ticking = true;
        window.requestAnimationFrame(scrubber_sync);
      }
    });
    /* drag the handle */
    scrubber_track.on('pointerdown', function (e) {
      e.preventDefault();
      scrubber_dragging = true;
      this.setPointerCapture(e.originalEvent.pointerId);
      scrubber_render(scrubber_pointer_ord(e));
    });
    scrubber_track.on('pointermove', function (e) {
      if (!scrubber_dragging) return;
      scrubber_render(scrubber_pointer_ord(e));
    });
    scrubber_track.on('pointerup pointercancel', function (e) {
      if (!scrubber_dragging) return;
      scrubber_dragging = false;
      if (e.type == 'pointerup') {
        scrubber_go(scrubber_ord);
      } else {
        scrubber_sync();
      }
    });
    /* move the handle with the keyboard */
    scrubber_handle.on('keydown', function (e) {
      if (e.key == 'ArrowUp' || e.key == 'ArrowDown') {
        e.preventDefault();
        scrubber_go(Math.min(Math.max(scrubber_ord + ((e.key == 'ArrowDown') ? 1 : -1), 1), scrubber_total));
      }
    });
    /* open the requested post */
    var scrubber_post = parseInt(new URLSearchParams(window.location.search).get('post'), 10);
    if (scrubber_post && !window.location.hash) {
      var scrubber_target = $('.js_forum-post[data-ord="' + scrubber_post + '"]').filter(':visible');
      if (scrubber_target.length > 0) {
        window.scrollTo({ top: scrubber_target.offset().top - scrubber_offset + 10 });
      }
    }
    scrubber_sync();
  }


  // handle keyboard shortcuts
  highlighted_post = 0;
  $('body').on('keypress', function (key) {
    var target = key.target.tagName.toLowerCase();
    var key_value = parseInt(key.which, 10);
    var $target = $(key.target);
    var is_editable = $target.is('[contenteditable="true"]') || $target.closest('.ql-editor').length > 0;
    if (highlighted_post >= 0) {
      /* (J) next post */
      if (key_value == 106 && target != 'input' && target != 'textarea' && !is_editable) {
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
      } else if (key_value == 107 && target != 'input' && target != 'textarea' && !is_editable) {
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
