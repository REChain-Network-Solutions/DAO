/**
 * user js
 * 
 * @package Sngine
 * @author Zamblek
 */

// initialize API URLs
/* data */
api['data/live'] = ajax_path + "data/live.php";
api['data/dropdown'] = ajax_path + "data/dropdown.php";
api['data/upload'] = ajax_path + "data/upload.php";
api['data/delete'] = ajax_path + "data/delete.php";
api['data/reset'] = ajax_path + "data/reset.php";
/* users */
api['users/image_delete'] = ajax_path + "users/image_delete.php";
api['users/image_crop'] = ajax_path + "users/image_crop.php";
api['users/image_change'] = ajax_path + "users/image_change.php";
api['users/image_position'] = ajax_path + "users/image_position.php";
api['users/connect'] = ajax_path + "users/connect.php";
api['users/delete'] = ajax_path + "users/delete.php";
api['users/session'] = ajax_path + "users/session.php";
api['users/switch'] = ajax_path + "users/switch.php";
api['users/location'] = ajax_path + "users/location.php";
api['users/push_notifications'] = ajax_path + "users/push_notifications.php";
api['users/notifications'] = ajax_path + "users/notifications.php";
api['users/popover'] = ajax_path + "users/popover.php";
api['users/mentions'] = ajax_path + "users/mentions.php";
api['users/settings'] = ajax_path + "users/settings.php";
api['users/autocomplete'] = ajax_path + "users/autocomplete.php";
api['users/tagify'] = ajax_path + "users/tagify.php";
api['users/shopping'] = ajax_path + "users/shopping.php";
api['users/orders'] = ajax_path + "users/orders.php";
api['users/addresses'] = ajax_path + "users/addresses.php";
api['users/login_as'] = ajax_path + "users/login_as.php";
/* modules */
api['modules/review'] = ajax_path + "modules/review.php";
api['modules/delete'] = ajax_path + "modules/delete.php";
/* developers */
api['developers/app'] = ajax_path + "developers/app.php";


// init geocomplete
async function init_geocomplete() {
  if (!geolocation_enabled) {
    return;
  }
  var search, resolve;
  if (geolocation_provider == "openstreetmap") {
    var controller;
    search = async function (val) {
      if (controller) controller.abort();
      controller = new AbortController();
      var response = await fetch(geolocation_osm_url + "/api/?limit=5&q=" + encodeURIComponent(val), { signal: controller.signal });
      var data = await response.json();
      return (data.features || []).map(function (feature) {
        var properties = feature.properties || {};
        var parts = [properties.name, properties.street, properties.city, properties.state, properties.country].filter(function (part, index, list) {
          return part && list.indexOf(part) === index;
        });
        return { text: parts.join(", "), lat: feature.geometry.coordinates[1], lng: feature.geometry.coordinates[0] };
      });
    };
    resolve = async function (item) {
      return item;
    };
  } else {
    if (typeof google === "undefined" || !google.maps || typeof google.maps.importLibrary !== "function") {
      return;
    }
    const { AutocompleteSuggestion, AutocompleteSessionToken } = await google.maps.importLibrary("places");
    var sessionToken = new AutocompleteSessionToken();
    search = async function (val) {
      var response = await AutocompleteSuggestion.fetchAutocompleteSuggestions({
        input: val,
        sessionToken: sessionToken
      });
      return response.suggestions.map(function (suggestion) {
        return { text: suggestion.placePrediction.text.text, prediction: suggestion.placePrediction };
      });
    };
    resolve = async function (item) {
      var place = item.prediction.toPlace();
      await place.fetchFields({ fields: ["displayName", "formattedAddress", "location"] });
      sessionToken = new AutocompleteSessionToken();
      return {
        text: place.displayName || place.formattedAddress || item.text,
        lat: place.location ? place.location.lat() : "",
        lng: place.location ? place.location.lng() : ""
      };
    };
  }
  document.querySelectorAll(".js_geocomplete:not([data-geocomplete-init])").forEach(function (input) {
    input.setAttribute("data-geocomplete-init", "1");
    var debounceTimer;
    var dropdown = document.createElement("ul");
    dropdown.className = "fixed z-[100020] max-h-56 overflow-y-auto rounded-box border border-base-300 bg-base-100 p-1 shadow-md";
    function placeDropdown() {
      var rect = input.getBoundingClientRect();
      var below = window.innerHeight - rect.bottom;
      var above = below < Math.min(dropdown.scrollHeight, 224) + 8 && rect.top > below;
      dropdown.style.left = rect.left + "px";
      dropdown.style.width = rect.width + "px";
      dropdown.style.top = above ? "auto" : (rect.bottom + 4) + "px";
      dropdown.style.bottom = above ? (window.innerHeight - rect.top + 4) + "px" : "auto";
    }
    function openDropdown() {
      if (!dropdown.isConnected) {
        document.body.appendChild(dropdown);
        window.addEventListener("scroll", placeDropdown, true);
        window.addEventListener("resize", placeDropdown);
      }
      placeDropdown();
    }
    function closeDropdown() {
      dropdown.remove();
      dropdown.innerHTML = "";
      window.removeEventListener("scroll", placeDropdown, true);
      window.removeEventListener("resize", placeDropdown);
    }
    function setCoordinates(lat, lng) {
      var scope = input.closest(".publisher-meta, form");
      if (!scope) return;
      var latEl = scope.querySelector("[data-geo='lat']");
      var lngEl = scope.querySelector("[data-geo='lng']");
      if (latEl) latEl.value = lat;
      if (lngEl) lngEl.value = lng;
    }
    input.addEventListener("input", function () {
      clearTimeout(debounceTimer);
      setCoordinates("", "");
      var val = input.value.trim();
      if (!val) { closeDropdown(); return; }
      debounceTimer = setTimeout(async function () {
        try {
          var items = await search(val);
          dropdown.innerHTML = "";
          items.forEach(function (item) {
            var li = document.createElement("li");
            li.className = "cursor-pointer rounded-field px-3 py-2 text-sm hover:bg-base-200";
            li.textContent = item.text;
            li.addEventListener("mousedown", async function (e) {
              e.preventDefault();
              var place = await resolve(item);
              input.value = place.text;
              closeDropdown();
              setCoordinates(place.lat, place.lng);
            });
            dropdown.appendChild(li);
          });
          if (items.length) { openDropdown(); } else { closeDropdown(); }
        } catch (e) { closeDropdown(); }
      }, 300);
    });
    input.addEventListener("blur", function () {
      setTimeout(closeDropdown, 200);
    });
    input.addEventListener("keydown", function (e) {
      var active = dropdown.querySelector(".active");
      function setActive(el) {
        if (active) active.classList.remove("active", "bg-base-200");
        if (el) el.classList.add("active", "bg-base-200");
      }
      if (e.key === "ArrowDown") {
        e.preventDefault();
        if (active) { if (active.nextElementSibling) setActive(active.nextElementSibling); }
        else if (dropdown.firstChild) setActive(dropdown.firstChild);
      } else if (e.key === "ArrowUp") {
        e.preventDefault();
        if (active && active.previousElementSibling) setActive(active.previousElementSibling);
      } else if (e.key === "Enter" && active) {
        e.preventDefault();
        active.dispatchEvent(new MouseEvent("mousedown", { bubbles: true }));
      } else if (e.key === "Escape") {
        closeDropdown();
      }
    });
  });
}


// initialize the modal plugins
function initialize_modal() {
  // run scroll
  $('.js_scroller').each(function () {
    var _this = $(this);
    var ini_height = _this.attr('data-slimScroll-height') || '280px';
    var ini_start = _this.attr('data-slimScroll-start') || 'top';
    /* return if the scroll already running  */
    if (_this.parent().hasClass('custom-scrollbar')) {
      //return;
    }
    /* run if not */
    _this.parent().addClass('custom-scrollbar');
    _this.css({ "overflow-y": "auto", "height": ini_height });
    if (ini_start == "bottom") {
      _this.scrollTop(_this.height());
    }
  });
  // run geocomplete plugin
  init_geocomplete();
  // run tagify
  if ($(".js_tagify").length > 0) {
    $('.js_tagify').each(function () {
      if (!$(this).hasClass('tagify')) {
        new Tagify(this, {
          duplicates: false,
          addTagOnBlur: false
        });
      }
    });
  }
  tagify_ajax('.js_tagify-ajax');
  // run uploader 
  initialize_uploader();
}


// initialize uploader
// attachment uploads
var attachment_upload_queues = new Set();

function attachment_upload_busy(element) {
  var nodes = $(element).toArray();
  return Array.from(attachment_upload_queues).some(function (queue) {
    return nodes.some(function (node) { return node === queue.root[0] || $.contains(node, queue.root[0]); }) &&
      queue.items.some(function (item) { return item.state !== 'ready'; });
  });
}

function attachment_upload_lock(queue) {
  var form = queue.root.closest('.js_ajax-forms, .js_ajax-forms-html');
  var busy = attachment_upload_busy(form.length ? form : queue.root);
  var buttons = queue.root.find('.js_publisher-btn, .js_publisher, .js_publisher-product, .js_publisher-album, .js_publisher-review, .js_post-paid-message, .js_update-comment, button[type="submit"], button.js_post-comment, button.js_post-reply, button.js_post-message');
  buttons = buttons.add(buttons.find('button'));
  if (form.length) buttons = buttons.add(form.find('button[type="submit"]'));
  buttons.filter('li').toggleClass('pointer-events-none opacity-50', busy);
  buttons.each(function () {
    var button = $(this);
    if (busy) {
      if (button.data('upload-lock') === undefined) button.data('upload-lock', !!button.prop('disabled'));
      button.prop('disabled', true).attr('aria-disabled', 'true');
    } else if (button.data('upload-lock') !== undefined) {
      button.prop('disabled', button.data('upload-lock')).removeAttr('aria-disabled').removeData('upload-lock');
    }
  });
}

function attachment_upload_render(item) {
  var labels = { queued: 'Queued', validating: 'Checking', uploading: 'Uploading', finishing: 'Finishing', ready: 'Ready', failed: 'Failed' };
  var indeterminate = item.state === 'finishing' || item.state === 'validating' || item.unknownProgress;
  var progress = item.card.find('.js_upload-progress');
  var state = item.card.find('.js_upload-state');
  if (state.text() !== __[labels[item.state]]) state.text(__[labels[item.state]]);
  item.card.find('.js_upload-percent').text(Math.floor(item.progress) + '%').toggle(!indeterminate);
  item.card.find('.js_upload-spinner').toggle(!!indeterminate);
  item.card.find('.js_upload-error').text(item.error || '').toggle(item.state === 'failed');
  item.card.find('.js_upload-retry').toggle(item.state === 'failed');
  item.card.find('.js_upload-bar').css('width', item.progress + '%');
  progress.toggle(!indeterminate && item.state !== 'failed' && item.state !== 'ready');
  if (indeterminate) progress.removeAttr('aria-valuenow');
  else progress.attr('aria-valuenow', Math.floor(item.progress));
  item.card.attr('data-upload-state', item.state);
}

function attachment_upload_meta(root, type, enabled) {
  root.find('.publisher-meta[data-meta="' + type + '"]').toggle(enabled);
  if (type === 'video' || type === 'reel') {
    var thumbnail = root.find('.publisher-' + type + '-custom-thumbnail');
    thumbnail.toggle(enabled);
    if (!enabled) {
      x_image_reset(thumbnail.find('.x-image'));
    }
  }
  if (type === 'reel') {
    ['adult', 'tips', 'subscribers', 'paid'].forEach(function (name) {
      var toggle = root.find('.js_publisher-' + name + '-toggle');
      if (enabled) toggle.prop('checked', false);
      toggle.prop('disabled', enabled);
    });
    root.find('#adult-toggle-wrapper, #tips-toggle-wrapper, #subscribers-toggle-wrapper, #paid-toggle-wrapper').toggleClass('disabled', enabled);
    if (enabled) {
      root.find('#subscriptions-image-wrapper, #paid-price-wrapper, #paid-text-wrapper, #paid-image-wrapper').hide();
      root.find('#subscriptions-image-wrapper input, #paid-image-wrapper input, #paid-price-wrapper input, #paid-text-wrapper textarea').val('');
    }
  }
}

function attachment_upload_register(queue, item, remove) {
  if (!item.result) return;
  var root = queue.root;
  var source = typeof item.result === 'string' ? item.result : item.result.source;
  if (queue.handle === 'chat') {
    var key = item.type === 'video' ? 'videos' : item.type === 'file' ? 'files' : 'photos';
    var media = root.data(key) || {};
    if (remove) delete media[source];
    else media[source] = item.type === 'file'
      ? { source: source, name: item.file && item.file.name ? item.file.name : '', size: item.file && item.file.size ? item.file.size : 0 }
      : { source: source };
    if (Object.keys(media).length) root.data(key, media);
    else root.removeData(key);
  } else if (queue.handle === 'comment') {
    if (remove) root.removeData('photos');
    else root.data('photos', source);
  } else if (item.type === 'photos' || queue.handle === 'publisher-mini') {
    var files = root.data(item.type) || {};
    if (remove) delete files[source];
    else files[source] = item.result;
    if (Object.keys(files).length) root.data(item.type, files);
    else root.removeData(item.type);
    if (item.type === 'photos') root.find('.js_hidden-input-photos').val(Object.keys(files).length ? JSON.stringify(files) : '');
  } else {
    if (remove) root.removeData(item.type);
    else root.data(item.type, item.type === 'file'
      ? { source: source, name: item.file && item.file.name ? item.file.name : '', size: item.file && item.file.size ? item.file.size : 0 }
      : (item.type === 'video' && item.width && item.height) ? { source: source, width: item.width, height: item.height } : { source: source });
    attachment_upload_meta(root, item.type, !remove);
  }
}

function attachment_upload_refresh(queue) {
  if (queue.root.find('.js_publisher-photo-layout').length) publisher_photos_refresh(queue.root);
  if (queue.handle === 'comment') {
    queue.root.find('.x-form-tools-attach, .x-form-tools-voice').toggle(queue.items.length === 0);
  }
  if (queue.handle === 'chat') {
    queue.root.find('.x-form-tools-attach').toggle(queue.items.length < chat_max_media);
  }
  if (queue.handle === 'publisher') {
    ['photos', 'reel', 'video', 'audio', 'file'].forEach(function (type) {
      var hasItems = queue.items.some(function (item) { return item.type === type; });
      queue.root.find('.js_publisher-tab[data-tab="' + type + '"]').toggleClass('activated', hasItems || !!queue.root.data(type));
    });
    if (!queue.items.length && queue.tab) {
      publisher_tab(queue.root, queue.tab);
      queue.root.find('.js_publisher-tab[data-tab="album"]').toggleClass('disabled', queue.albumWasDisabled);
      queue.tab = null;
    }
  }
  attachment_upload_lock(queue);
  if (typeof publisher_edit_tabs === 'function') publisher_edit_tabs(queue.root);
}

function attachment_upload_release(item) {
  if (item.cancelValidation) item.cancelValidation();
  if (item.preview) {
    item.card.find('video, audio').each(function () { this.pause(); $(this).removeAttr('src'); this.load(); });
    URL.revokeObjectURL(item.preview);
    item.preview = null;
  }
}

function attachment_upload_remove(queue, item) {
  item.attempt++;
  queue.items = queue.items.filter(function (entry) { return entry !== item; });
  if (queue.active === item) queue.active = null;
  if (item.xhr) item.xhr.abort();
  attachment_upload_register(queue, item, true);
  if (item.result) {
    var source = typeof item.result === 'string' ? item.result : item.result.source;
    $.post(api['data/delete'], { src: source });
  }
  attachment_upload_release(item);
  item.card.remove();
  if (queue.handle !== 'publisher-mini' && !item.container.find('.js_upload-item, li.item').length) item.container.hide();
  attachment_upload_refresh(queue);
  attachment_upload_next(queue);
}

function attachment_upload_clear(element) {
  Array.from(attachment_upload_queues).forEach(function (queue) {
    if (!$(element).toArray().some(function (node) { return node === queue.root[0] || $.contains(node, queue.root[0]); })) return;
    queue.disposed = true;
    queue.items.forEach(function (item) {
      item.attempt++;
      if (item.xhr) item.xhr.abort();
      attachment_upload_register(queue, item, true);
      attachment_upload_release(item);
      item.card.remove();
    });
    queue.items = [];
    attachment_upload_lock(queue);
    queue.root.removeData('attachment-queue');
    attachment_upload_queues.delete(queue);
    if (queue.root.find('.js_publisher-photo-layout').length) publisher_photos_refresh(queue.root);
  });
}

function attachment_upload_cleanup() {
  attachment_upload_queues.forEach(function (queue) {
    var parked = $('#publisher-wapper').data('publisher-detached');
    var discarded = !queue.root[0].isConnected || (queue.items.length && queue.items.every(function (item) { return !item.card[0].isConnected; }));
    if (discarded && !(parked && $(parked).is(queue.root))) attachment_upload_clear(queue.root);
  });
}

function composer_gif_add(form, url) {
  form = $(form);
  var handle = form.data('handle');
  var root = form.closest(handle === 'comment' ? '.comment' : '.chat-widget, .panel-messages');
  var container = form.find('.comment-attachments, .chat-attachments').first();
  if (!root.length || !container.length || root.data('sending')) return;
  if (handle === 'comment') {
    attachment_upload_clear(root);
    container.find('li.item').remove();
    root.removeData('photos');
    form.find('.x-form-tools-attach').hide();
  }
  container.find('[data-gif-item]').remove();
  container.children('ul').first().append(render_template('#attachment-gif-item', { src: url }));
  container.show().find('li.js_loading').hide();
  root.data('gif', url);
  form.find('textarea').first().trigger('focus');
}

function composer_gif_clear(root) {
  root = $(root);
  root.removeData('gif');
  root.find('[data-gif-item]').each(function () {
    var form = $(this).closest('.js_composer');
    var container = $(this).closest('.attachments');
    $(this).remove();
    if (!container.find('li.item').length) container.hide();
    if (form.data('handle') === 'comment') form.find('.x-form-tools-attach').show();
  });
}

function attachment_upload_validate(item) {
  if (!item.file.size) return Promise.reject(new Error(__['This file is empty.']));
  if (item.handle !== 'publisher' || (item.type !== 'video' && item.type !== 'reel')) return Promise.resolve();
  var minimum = Number(item.type === 'reel' ? reels_minimum_duration : video_minimum_duration) || 0;
  var maximum = Number(item.type === 'reel' ? reels_maximum_duration : video_maximum_duration) || 0;
  var limited = !!(minimum || maximum);
  return new Promise(function (resolve, reject) {
    var video = document.createElement('video');
    var timer = setTimeout(function () { finish(limited ? new Error(__['Unable to read the video duration.']) : null); }, limited ? 15000 : 5000);
    function finish(error) {
      clearTimeout(timer);
      video.onloadedmetadata = video.onerror = null;
      video.removeAttribute('src');
      video.load();
      item.cancelValidation = null;
      if (error) reject(error);
      else resolve();
    }
    item.cancelValidation = function () { finish(new Error('cancelled')); };
    video.preload = 'metadata';
    video.onloadedmetadata = function () {
      item.width = video.videoWidth || 0;
      item.height = video.videoHeight || 0;
      if (!limited) return finish();
      if (!Number.isFinite(video.duration)) return finish(new Error(__['Unable to read the video duration.']));
      if (minimum && video.duration < minimum) return finish(new Error(__['Your video is too short, it must be at least'] + ' ' + minimum + ' ' + __['seconds']));
      if (maximum && video.duration > maximum) return finish(new Error(__['Your video is too long, it must be at most'] + ' ' + maximum + ' ' + __['seconds']));
      finish();
    };
    video.onerror = function () { finish(limited ? new Error(__['Unable to read the video duration.']) : null); };
    video.src = item.preview;
  });
}

function attachment_upload_next(queue) {
  if (queue.active || queue.disposed) return;
  var item = queue.items.find(function (entry) { return entry.state === 'queued'; });
  if (!item) return attachment_upload_lock(queue);
  queue.active = item;
  var attempt = ++item.attempt;
  item.guid = guid();
  item.state = 'validating';
  item.progress = 0;
  item.error = '';
  item.unknownProgress = false;
  attachment_upload_render(item);
  function current() { return !queue.disposed && item.attempt === attempt && queue.items.indexOf(item) !== -1; }
  function failed(message, callback) {
    if (!current()) return;
    item.state = 'failed';
    item.error = message || __['Upload failed. Please retry.'];
    item.xhr = null;
    item.unknownProgress = false;
    queue.active = null;
    attachment_upload_render(item);
    attachment_upload_lock(queue);
    if (callback) eval(callback);
    attachment_upload_next(queue);
  }
  var chunkSize = Math.max(1, Number(chunk_upload_size) * 1024 * 1024);
  var chunkIndex = 0;
  function uploadChunk() {
    if (!current()) return;
    var start = chunkIndex * chunkSize;
    var chunk = item.file.slice(start, Math.min(start + chunkSize, item.file.size));
    var totalChunks = Math.ceil(item.file.size / chunkSize);
    var data = new FormData();
    var fields = { secret: item.secret, type: item.type, handle: queue.handle, multiple: item.multiple ? 'true' : 'false', item_upload: 'true', name: item.file.name, guid: item.guid, chunkIndex: chunkIndex, totalChunks: totalChunks, fileIndex: 0, totalFiles: 1 };
    Object.keys(fields).forEach(function (key) { data.append(key, fields[key]); });
    data.append('file', chunk);
    if (item.target !== undefined) data.append('id', item.target);
    if (item.blur !== undefined) data.append('blur', item.blur);
    item.state = 'uploading';
    item.unknownProgress = false;
    attachment_upload_render(item);
    item.xhr = $.ajax({
      url: api['data/upload'], type: 'POST', data: data, dataType: 'json', processData: false, contentType: false,
      xhr: function () {
        var xhr = new XMLHttpRequest();
        xhr.upload.addEventListener('progress', function (event) {
          if (!current()) return;
          item.unknownProgress = !event.lengthComputable || !event.total;
          if (!item.unknownProgress) {
            var fraction = Math.min(1, Math.max(0, event.loaded / event.total));
            item.progress = Math.min(100, Math.max(item.progress, (start + chunk.size * fraction) / item.file.size * 100));
            if (fraction === 1 && chunkIndex === totalChunks - 1) item.state = 'finishing';
          }
          attachment_upload_render(item);
        });
        xhr.upload.addEventListener('load', function () {
          if (!current() || chunkIndex !== totalChunks - 1) return;
          item.state = 'finishing';
          item.unknownProgress = false;
          attachment_upload_render(item);
        });
        return xhr;
      },
      success: function (response) {
        if (!current()) return;
        if (!response || response.error || response.callback) return failed(response && response.message, response && response.callback);
        chunkIndex++;
        item.progress = Math.min(100, chunkIndex * chunkSize / item.file.size * 100);
        if (chunkIndex < totalChunks) return uploadChunk();
        var result = item.multiple ? response.files && response.files[0] : response.file;
        var source = result && (typeof result === 'string' ? result : result.source);
        if (typeof source !== 'string' || !source || /^(blob:|data:)/i.test(source)) return failed();
        item.result = result;
        if (item.previewFailed && item.type === 'photos') item.card.find('.js_upload-media img').attr('src', uploads_path + '/' + source);
        item.state = 'ready';
        item.progress = 100;
        item.unknownProgress = false;
        item.xhr = null;
        queue.active = null;
        attachment_upload_register(queue, item, false);
        attachment_upload_render(item);
        attachment_upload_refresh(queue);
        attachment_upload_next(queue);
      },
      error: function () { failed(); }
    });
  }
  attachment_upload_validate(item).then(function () { if (current()) uploadChunk(); }, function (error) { failed(error.message); });
}

function attachment_upload_add(form, options) {
  var selector = options.handle === 'publisher' ? '.publisher' : options.handle === 'publisher-mini' ? '.publisher-mini' : options.handle === 'comment' ? '.comment' : '.chat-widget, .panel-messages';
  var root = form.closest(selector);
  if (!root.length || root.data('scraping') || root.data('sending')) return;
  var input = form.find('input[type="file"]');
  var selectedFiles = Array.from(input[0].files);
  input.val('');
  if (!selectedFiles.length) return;
  var queue = root.data('attachment-queue');
  if (queue && queue.items.length && queue.items.every(function (item) { return !item.card[0].isConnected; })) {
    attachment_upload_clear(root);
    queue = null;
  }
  if (!queue) {
    queue = { root: root, handle: options.handle, items: [], active: null, tab: null, albumWasDisabled: root.find('.js_publisher-tab[data-tab="album"]').hasClass('disabled') };
    root.data('attachment-queue', queue);
    attachment_upload_queues.add(queue);
  }
  var single = !options.multiple || options.handle === 'comment';
  if (single && (queue.items.some(function (item) { return item.type === options.type; }) || root.data(options.type))) return;
  if (single) selectedFiles = selectedFiles.slice(0, 1);
  if (options.handle === 'chat') {
    var room = chat_max_media - queue.items.length;
    if (selectedFiles.length > room) {
      selectedFiles = selectedFiles.slice(0, Math.max(0, room));
      modal('#modal-message', { title: __['Error'], message: __['You can only attach up to'] + ' ' + chat_max_media + ' ' + __['photos, videos and files'] });
    }
    if (!selectedFiles.length) return;
  }
  var container;
  if (options.handle === 'publisher') container = root.find('.js_attachments-' + options.type);
  else if (options.handle === 'publisher-mini') container = root.find('.attachments[data-type="' + (options.type === 'video' ? 'videos' : options.type) + '"]');
  else container = root.find(options.handle === 'chat' ? '.chat-attachments' : '.comment-attachments').first();
  if (!container.length) return;
  container.show().find('li.js_loading').hide();
  var reorder = options.type === 'photos' && root.find('.js_publisher-photo-layout').length > 0;
  var list = container.children('ul').first();
  if (!list.length) list = $('<ul class="grid grid-cols-2 gap-2 sm:grid-cols-3"></ul>').appendTo(container);
  if (options.handle === 'publisher' && options.type !== 'photos') list.addClass('grid-cols-1! sm:grid-cols-1!');
  if (reorder) list.addClass('js_photo-order-list');
  if (options.handle === 'publisher' && !queue.items.length && !root.find('.js_publisher-tab.active').length) {
    queue.tab = options.type;
    publisher_tab(root, options.type);
  }
  if (options.handle === 'publisher' && options.type !== 'photos') publisher_tab(root, 'album_disable');
  selectedFiles.forEach(function (file) {
    var image = options.type === 'photos';
    var video = options.type === 'video' || options.type === 'reel';
    var units = ['B', 'KB', 'MB', 'GB'];
    var unit = Math.min(3, Math.floor(Math.log(Math.max(1, file.size)) / Math.log(1024)));
    var item = Object.assign({}, options, { id: guid(), file: file, attempt: 0, state: 'queued', progress: 0, container: container, preview: image || video ? URL.createObjectURL(file) : null });
    item.card = $(render_template('#attachment-upload-item', { id: item.id, name: file.name, size: (file.size / Math.pow(1024, unit)).toFixed(unit ? 1 : 0) + ' ' + units[unit], image: image, video: video, document: !image && !video, compact: options.handle === 'comment' || options.handle === 'chat', reorder: reorder, icon: image ? 'icon-[tabler--photo]' : video ? 'icon-[tabler--video]' : options.type === 'audio' ? 'icon-[tabler--music]' : 'icon-[tabler--file]' }));
    if (item.preview) {
      var media = image ? $('<img class="relative size-full object-cover" alt="" draggable="false">') : $('<video class="relative size-full object-contain" controls muted playsinline preload="metadata"></video>');
      media.on('load loadedmetadata', function () { $(this).show(); item.card.find('.js_upload-fallback').hide(); })
        .on('error', function () { item.previewFailed = true; $(this).hide(); item.card.find('.js_upload-fallback').show(); })
        .attr('src', item.preview).prependTo(item.card.find('.js_upload-media'));
    }
    item.card.on('click', '.js_upload-remove', function (event) { event.preventDefault(); event.stopPropagation(); attachment_upload_remove(queue, item); });
    item.card.on('click', '.js_upload-retry', function (event) {
      event.preventDefault(); event.stopPropagation();
      if (item.state !== 'failed') return;
      item.state = 'queued'; item.error = ''; item.progress = 0;
      attachment_upload_render(item); attachment_upload_lock(queue); attachment_upload_next(queue);
    });
    queue.items.push(item);
    list.append(item.card);
    attachment_upload_render(item);
  });
  attachment_upload_refresh(queue);
  attachment_upload_next(queue);
}


// x-image upload state
function x_image_state(tile, state, percent) {
  var loader = tile.find('.x-image-loader');
  var bar = loader.find('.js_x-image-bar');
  var status = loader.find('.js_x-image-status');
  var label = loader.find('.js_x-image-percent');
  if (state === 'idle') {
    loader.addClass('hidden');
    bar.css('width', '0%').removeClass('animate-pulse');
    status.text('');
    label.text('');
    return;
  }
  percent = Math.min(Math.round(percent), 100);
  /* uploaded, waiting for the server to process the file */
  var processing = percent >= 100;
  loader.removeClass('hidden');
  status.text(processing ? __['Processing...'] : __['Uploading']);
  label.text(processing ? '' : percent + '%');
  bar.css('width', percent + '%').toggleClass('animate-pulse', processing);
  loader.find('.js_x-image-progress').attr('aria-valuenow', percent);
}


// x-image reset
function x_image_reset(tile) {
  tile.css('background-image', '');
  tile.find('.js_x-uploader-input').val('').trigger('change');
  tile.find('.js_x-image-remover, .js_x-video-remover, .x-image-success').addClass('hidden');
  x_image_state(tile, 'idle');
}


function initialize_uploader() {
  $('.js_x-uploader').each(function (index) {
    /* return if the plugin already running  */
    if ($(this).parents('form.x-uploader').length > 0) {
      return;
    }
    var multiple = ($(this).data('multiple') !== undefined) ? true : false;
    if ($(this).data('type') == "reel" || $(this).data('type') == "video") {
      var accept = accpeted_video_extensions;
    } else if ($(this).data('type') == "audio") {
      var accept = accpeted_audio_extensions;
    } else if ($(this).data('type') == "file") {
      var accept = accpeted_file_extensions;
    } else {
      var accept = accpeted_image_extensions;
    }
    $(this).before(render_template("#x-uploader", { 'url': api['data/upload'], 'secret': secret, 'multiple': multiple, 'accept': accept }));
    $(this).prev().append($(this));
  });
}


// browser notification
function browser_notification(icon, body, url, tag) {
  /* check if the browser supports notifications */
  if (!("Notification" in window)) {
    return;
  }
  /* check whether notification permissions have alredy been granted */
  if (Notification.permission !== "granted") {
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


// browser location
function update_location(position) {
  if (!position) {
    return false;
  }
  $.post(api['users/location'], { latitude: position.coords.latitude, longitude: position.coords.longitude });
}


// noty notification
function noty_notification(image, message, url) {
  let toast = $(render_template('#toast-notification', { 'image': image, 'message': message, 'url': url }));
  $('.toast-container').append(toast);
  setTimeout(function () {
    toast.remove();
  }, 5000);
}


// notification highlighter
function notification_highlighter() {
  try {
    var search_params = new URLSearchParams(window.location.search);
    var notify_id = search_params.get("notify_id");
  } catch (err) {
    var notify_id = get_parameter_by_name("notify_id");
  }
  if (notify_id) {
    var _elem = $('#' + notify_id);
    if (_elem.length > 0) {
      $('html, body').animate({
        scrollTop: _elem.offset().top
      }, 1000);
      _elem.find('.js_notifier-flasher:first').addClass("x-notifier");
      setTimeout(function () {
        _elem.find('.js_notifier-flasher:first').removeClass("x-notifier");
      }, '2500');
    }
  }
}


// live_last_value
function live_last_value(selector, attribute, item_attribute) {
  var dropdown = $(selector).first();
  var value = dropdown.attr('data-' + attribute);
  if (value === undefined) {
    value = dropdown.find(".js_scroller li:first").data(item_attribute);
  }
  return value || 0;
}


// data heartbeat
function data_heartbeat() {
  var data = {};
  data['user_id'] = user_id;
  data['last_request'] = live_last_value(".js_live-requests", 'last-id', 'id');
  data['last_message'] = live_last_value(".js_live-messages", 'last-message', 'last-message');
  data['last_notification'] = live_last_value(".js_live-notifications", 'last-id', 'id');
  /* newsfeed check */
  var posts_stream = $('.js_posts_stream');
  var posts_stream_staging = $('.js_posts_stream_staging');
  var posts_stream_staging_btn = $('.js_view-staging-posts');
  /* "popular" && "saved" & "scheduled" & "memories" excluded as not ordered by id */
  if (
    posts_stream.length > 0
    && !['popular', 'saved', 'scheduled', 'memories'].includes(posts_stream.data('get'))
    && (
      (['posts_profile', 'posts_page', 'posts_group', 'posts_event'].includes(posts_stream.data('get'))
        && posts_stream.data('query') === undefined)
      || !['posts_profile', 'posts_page', 'posts_group', 'posts_event'].includes(posts_stream.data('get'))
    )
    && posts_stream.data('loading') === undefined
  ) {
    /* use the highest post id as the stream is ordered by time not by id */
    var last_post = 0;
    posts_stream_staging.add(posts_stream).find("li .post:not([data-schedule])").each(function () {
      last_post = Math.max(last_post, parseInt($(this).data('id')) || 0);
    });
    data['last_post'] = last_post;
    data['get'] = posts_stream.data('get');
    data['filter'] = posts_stream.data('filter');
    data['category'] = posts_stream.data('category');
    data['country'] = posts_stream.data('country');
    data['id'] = posts_stream.data('id');
    data['query'] = posts_stream.data('query');
  }
  $.post(api['data/live'], data, function (response) {
    if (response.callback) {
      eval(response.callback);
    } else {
      /* remember the newest ids for the next check */
      if (response.last_request_id !== undefined) {
        $(".js_live-requests[data-last-id]").attr('data-last-id', response.last_request_id);
        $(".js_live-notifications[data-last-id]").attr('data-last-id', response.last_notification_id);
        $(".js_live-messages[data-last-message]").attr('data-last-message', response.last_message_id);
      }
      if (response.delete_last_request == true) {
        $(".js_live-requests").find(".js_scroller ul:first li:first").remove();
        var requests_counter = parseInt($(".js_live-requests").find("span.counter").text()) - 1;
        requests_counter = (requests_counter > 0) ? requests_counter : 0;
        $(".js_live-requests").find("span.counter").text(requests_counter);
        if (requests_counter == 0) {
          $(".js_live-requests").find("span.counter").hide();
        }
      } else {
        if (response.requests) {
          /* a list that was never opened loads in full when it opens */
          var requests_scroller = $(".js_live-requests").find(".js_scroller:not([data-lazy])");
          if (requests_scroller.find("ul").length > 0) {
            requests_scroller.find("ul:first").prepend(response.requests);
          } else {
            requests_scroller.html("<ul>" + response.requests + "</ul>");
          }
          var requests_counter = parseInt($(".js_live-requests").find("span.counter").text()) + response.requests_count;
          $(".js_live-requests").find("span.counter").text(requests_counter).show();
          if (notifications_sound) {
            $("#notification-sound")[0].play();
          }
        }
      }
      if (response.conversations) {
        $(".js_live-messages").find(".js_scroller").removeAttr('data-lazy').html("<ul>" + response.conversations + "</ul>");
        /* update live messages in messages page */
        if (is_page('messages')) {
          if ($(".js_live-messages-alt").data('searching')) {
            /* keep the search results, refresh the threads when the search is cleared */
            $(".js_live-messages-alt").data('stale', true);
          } else {
            if ($(".js_live-messages-alt").find(".js_scroller ul").length > 0) {
              $(".js_live-messages-alt").find(".js_scroller ul").html(response.conversations);
            } else {
              $(".js_live-messages-alt").find(".js_scroller").html('<ul class="m-0 flex list-none flex-col gap-1 p-0">' + response.conversations + '</ul>');
            }
            if (typeof mark_active_chat_thread === 'function') {
              mark_active_chat_thread();
            }
          }
        }
        if (response.conversations_count > 0) {
          $(".js_live-messages").find("span.counter").text(response.conversations_count).show();
          if (chat_sound && !chat_socket_enabled) {
            $("#chat-sound")[0].play();
          }
        } else {
          $(".js_live-messages").find("span.counter").text(response.conversations_count);
        }
      }
      if (response.notifications) {
        $.each(response.notifications_json, function (index, element) {
          /* send browser notifications */
          if (browser_notifications_enabled) {
            browser_notification(element.user_picture, element.full_message, element.url, element.notification_id);
          }
          /* send noty notifications */
          if (noty_notifications_enabled) {
            noty_notification(element.user_picture, element.full_message, element.url);
          }
        });
        /* a list that was never opened loads in full when it opens */
        var notifications_scroller = $(".js_live-notifications").find(".js_scroller:not([data-lazy])");
        if (notifications_scroller.find("ul").length > 0) {
          notifications_scroller.find("ul").prepend(response.notifications);
        } else {
          notifications_scroller.html("<ul>" + response.notifications + "</ul>");
        }
        var notifications = parseInt($(".js_live-notifications").find("span.counter").text()) + response.notifications_count;
        $(".js_live-notifications").find("span.counter").text(notifications).show();
        if (notifications_sound) {
          $("#notification-sound")[0].play();
        }
      }
      if (response.posts) {
        posts_stream_staging.prepend(response.posts)
        var posts_count = parseInt(posts_stream_staging_btn.find("span").text()) + response.posts_count;
        posts_stream_staging_btn.find("span").text(posts_count);
        posts_stream_staging_btn.fadeIn();
      }
      setTimeout('data_heartbeat();', min_data_heartbeat);
    }
  }, 'json');
}


// change profile picture 
function change_profile_picture(image_path) {
  $('.profile-avatar-wrapper img').attr("src", image_path);
  /* update crop image source */
  $('.js_init-crop-picture').data('image', image_path);
  init_picture_crop($('.js_init-crop-picture'));
  /* show crop & delete btns */
  $('.profile-avatar-crop, .profile-avatar-delete').removeClass('hidden').show();
}


// change cover picture 
function change_cover_picture(image_path) {
  var cover_image = $('.profile-cover-wrapper img');
  if (cover_image.length == 0) {
    $('.profile-cover-wrapper').prepend("<img class='js_position-cover-cropped' data-init-position='0px' src='" + image_path + "' />");
    $('.profile-cover-wrapper').prepend("<img class='js_position-cover-full hidden' src='" + image_path + "' />");
  } else {
    cover_image.attr('src', image_path);
    /* remove lightbox */
    cover_image.removeClass('js_lightbox').removeAttr('data-id').removeAttr('data-image').removeAttr('data-context');
  }
  /* show position & delete btns */
  $('.profile-cover-position, .profile-cover-delete').removeClass('hidden').show();
  /* init picture position */
  setTimeout(function () {
    init_picture_position();
  }, 1000);
}


// connection button
function connection_button(element, state) {
  var button = $(render_template('#connection-button-' + state, { 'uid': element.data('uid'), 'id': element.data('id'), 'privacy': element.data('privacy'), 'size': element.data('size') || 'sm' }).trim());
  element.replaceWith(button);
  /* keep the normal look until the pointer leaves */
  button.attr('data-fresh', '').one('mouseleave', function () {
    $(this).removeAttr('data-fresh');
  });
  return button;
}


// init picture crop
function init_picture_crop(node) {
  setTimeout(function () {
    $('#cropped-profile-picture').rcrop({
      minSize: [150, 150],
      preserveAspectRatio: true,
      grid: true
    });
  }, 200);
  modal('#crop-profile-picture', { 'image': node.data('image'), 'handle': node.data('handle'), 'id': node.data('id') });
}


// init picture position
function init_picture_position() {
  if (cover_crop_enabled) {
    var node = $('.js_init-position-picture');
    node.data('image', $('.js_position-cover-full').attr('src'));
    setTimeout(function () {
      $('#cropped-profile-cover').rcrop({
        minSize: [1296, 360],
        preserveAspectRatio: true,
        grid: true
      });
    }, 200);
    modal('#crop-profile-cover', { 'image': node.data('image'), 'handle': node.data('handle'), 'id': node.data('id') }, 'extra-large');
  } else {
    /* hide profile cover buttons */
    $('.profile-cover-change').hide();
    $('.profile-cover-position').hide();
    $('.profile-cover-delete').hide();
    $('.profile-buttons-wrapper').hide();
    /* hide cropped cover */
    $('.js_position-cover-cropped').hide();
    /* hide profile cover position buttons */
    $('.profile-cover-position-loader').show();
    $('.profile-cover-position-buttons').show();
    /* show full cover */
    $('.js_position-cover-full').show();
    /* drag the full cover vertically with init-position value */
    var wrapper = $('.profile-cover-wrapper');
    var image = $('.js_position-cover-full');
    var position = String($('.js_position-cover-cropped').data('init-position') || '').trim().toLowerCase();
    var drag = null;
    var set_position = function (top) {
      top = Math.min(0, Math.max(Math.min(0, wrapper.height() - image.height()), top));
      image.css('top', top + 'px');
      $('.js_position-picture-val').val(top + 'px');
    };
    var init_position = function () {
      var min = Math.min(0, wrapper.height() - image.height());
      if (position == 'middle') {
        set_position(min / 2);
      } else if (position == 'bottom') {
        set_position(min);
      } else {
        set_position(parseFloat(position) || 0);
      }
    };
    if (image[0].complete) {
      init_position();
    } else {
      image.one('load', init_position);
    }
    image.attr('draggable', 'false').off('.position')
      .on('pointerdown.position', function (e) {
        e.preventDefault();
        this.setPointerCapture(e.pointerId);
        drag = { y: e.clientY, top: parseFloat(image.css('top')) || 0 };
      })
      .on('pointermove.position', function (e) {
        if (drag) set_position(drag.top + e.clientY - drag.y);
      })
      .on('pointerup.position pointercancel.position', function () {
        drag = null;
      });
  }

}


// check video duration
function check_video_duration(file, min_duration, max_duration) {
  return new Promise((resolve, reject) => {
    if (!file) {
      resolve(false);
      return;
    }
    const video = document.createElement('video');
    video.preload = 'metadata';
    video.onloadedmetadata = function () {
      window.URL.revokeObjectURL(video.src);
      const duration = video.duration;
      video.remove();
      if (min_duration != 0 && duration < min_duration) {
        modal('#modal-error', { title: __['Error'], message: __['Your video is too short, it must be at least'] + ' ' + min_duration + ' ' + __['seconds'] });
        resolve(false);
        return;
      }
      if (max_duration != 0 && duration > max_duration) {
        modal('#modal-error', { title: __['Error'], message: __['Your video is too long, it must be at most'] + ' ' + max_duration + ' ' + __['seconds'] });
        resolve(false);
        return;
      }
      resolve(true);
    };
    video.onerror = function () {
      window.URL.revokeObjectURL(video.src);
      video.remove();
      resolve(false);
    };
    video.src = URL.createObjectURL(file);
  });
}


// tagify_ajax
function tagify_ajax(selector) {
  $(selector).each(function () {
    const element = this;
    const handle = $(element).data('handle');
    if (element.nodeName !== "TAGS" && !element.__tagify) {
      const tagify = new Tagify(element, {
        id: guid(),
        duplicates: false,
        addTagOnBlur: false,
        dropdown: {
          classname: 'z-[100001]! [--tagify-dd-color-primary:var(--color-primary)] [--tagify-dd-bg-color:var(--color-base-100)] [--tagify-dd-text-color:var(--color-base-content)]'
        }
      }).on("input", function (e) {
        const tagName = e.detail.value;
        $.post(api['users/tagify'], { query: tagName, handle: handle }, function (response) {
          /* check the response */
          if (response.callback) {
            eval(response.callback);
          } else {
            if (response.list !== undefined) {
              tagify.settings.whitelist = JSON.parse(response.list);
              tagify.dropdown.show.call(tagify, tagName);
            }
          }
        }, 'json')
          .fail(function () {
            show_error_modal();
          });
      });
    }
  });
}


// tinymce night mode
function tinymce_night_mode() {
  return (document.documentElement.getAttribute('data-theme') || '').endsWith('-dark');
}


// init tinymce editor
function init_tinymce_editor() {
  if ($(".js_wysiwyg").length > 0) {
    tinymce.remove('.js_wysiwyg');
    if (!tinymce_photos_enabled) {
      tinymce.init({
        promotion: false,
        skin: tinymce_night_mode() ? 'oxide-dark' : 'oxide',
        content_css: tinymce_night_mode() ? 'dark' : 'default',
        selector: '.js_wysiwyg',
        directionality: system_langauge_dir,
        language: system_langauge_code,
        language_url: site_path + '/node_modules/tinymce-i18n/langs6/' + system_langauge_code + '.js',
        branding: false,
        height: 300,
        relative_urls: false,
        convert_urls: true,
        remove_script_host: false,
        toolbar: 'insertfile undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | accordion | link image  uploadImages |  preview media fullpage | forecolor backcolor | ltr rtl',
        mobile: {
          menubar: true,
        },
        plugins:
          'lists advlist autolink link image charmap  preview anchor pagebreak ' +
          'searchreplace wordcount visualblocks visualchars code fullscreen insertdatetime media nonbreaking ' +
          'save table directionality accordion'
        ,
        sandbox_iframes: false,
      });
    } else {
      tinymce.init({
        promotion: false,
        skin: tinymce_night_mode() ? 'oxide-dark' : 'oxide',
        content_css: tinymce_night_mode() ? 'dark' : 'default',
        selector: '.js_wysiwyg',
        directionality: system_langauge_dir,
        language: system_langauge_code,
        language_url: site_path + '/node_modules/tinymce-i18n/langs6/' + system_langauge_code + '.js',
        branding: false,
        height: 300,
        relative_urls: false,
        convert_urls: true,
        remove_script_host: false,
        toolbar: 'insertfile undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | accordion | link image  uploadImages |  preview media fullpage | forecolor backcolor | ltr rtl',
        mobile: {
          menubar: true,
        },
        plugins:
          'lists advlist autolink link image charmap  preview anchor pagebreak ' +
          'searchreplace wordcount visualblocks visualchars code fullscreen insertdatetime media nonbreaking ' +
          'save table directionality accordion'
        ,
        sandbox_iframes: false,
        image_advtab: true,
        paste_data_images: true,
        images_upload_handler: (blobInfo, progress) => new Promise((resolve, reject) => {
          var xhr, formData;
          xhr = new XMLHttpRequest();
          xhr.withCredentials = true;
          xhr.open('POST', api['data/upload']);
          xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
          xhr.onload = function () {
            var json;
            if (xhr.status != 200) {
              reject(__['Upload failed. Please retry.']);
              return;
            }
            try {
              json = JSON.parse(xhr.responseText);
            } catch (e) {
              reject(__['Upload failed. Please retry.']);
              return;
            }
            if (!json || typeof json.error == 'string') {
              reject(json.error);
              return;
            }
            resolve(uploads_path + '/' + json.file);
          };
          formData = new FormData();
          formData.append('secret', secret);
          formData.append('type', 'photos');
          formData.append('handle', 'tinymce');
          formData.append('multiple', 'false');
          formData.append('blur', false);
          formData.append('file', blobInfo.blob(), blobInfo.filename());
          formData.append('name', blobInfo.filename());
          formData.append('guid', guid());
          xhr.send(formData);
        }),
      });
    }
  }
}


// init tinymce advanced editor
function init_tinymce_advanced_editor() {
  if ($(".js_wysiwyg-advanced").length > 0) {
    tinymce.remove('.js_wysiwyg-advanced');
    tinymce.init({
      promotion: false,
      skin: tinymce_night_mode() ? 'oxide-dark' : 'oxide',
      content_css: tinymce_night_mode() ? 'dark' : 'default',
      selector: '.js_wysiwyg-advanced',
      directionality: system_langauge_dir,
      language: system_langauge_code,
      language_url: site_path + '/node_modules/tinymce-i18n/langs6/' + system_langauge_code + '.js',
      branding: false,
      height: 300,
      relative_urls: false,
      convert_urls: true,
      remove_script_host: false,
      toolbar: 'insertfile undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | accordion | link image  uploadImages |  preview media fullpage | forecolor backcolor | ltr rtl',
      mobile: {
        menubar: true,
      },
      plugins:
        'lists advlist autolink link image charmap  preview anchor pagebreak ' +
        'searchreplace wordcount visualblocks visualchars code fullscreen insertdatetime media nonbreaking ' +
        'save table directionality accordion'
      ,
      sandbox_iframes: false,
      extended_valid_elements: "style[type|media],script[src|async|defer|type|charset],marquee[class|width|height|align|onmouseover|onmouseout|behavior|direction|scrollamount|scrolldelay]",
      valid_children: '+body[style]',
      valid_elements: '*[*]',
      image_advtab: true,
      paste_data_images: true,
      images_upload_handler: (blobInfo, progress) => new Promise((resolve, reject) => {
        var xhr, formData;
        xhr = new XMLHttpRequest();
        xhr.withCredentials = true;
        xhr.open('POST', api['data/upload']);
        xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
        xhr.onload = function () {
          var json;
          if (xhr.status != 200) {
            reject(__['Upload failed. Please retry.']);
            return;
          }
          try {
            json = JSON.parse(xhr.responseText);
          } catch (e) {
            reject(__['Upload failed. Please retry.']);
            return;
          }
          if (!json || typeof json.error == 'string') {
            reject(json.error);
            return;
          }
          resolve(uploads_path + '/' + json.file);
        };
        formData = new FormData();
        formData.append('secret', secret);
        formData.append('type', 'photos');
        formData.append('handle', 'tinymce');
        formData.append('multiple', 'false');
        formData.append('blur', false);
        formData.append('file', blobInfo.blob(), blobInfo.filename());
        formData.append('name', blobInfo.filename());
        formData.append('guid', guid());
        xhr.send(formData);
      }),
    });
  }
}


$(function () {

  // run upload cleanup
  var upload_cleanup_pending = false;
  new MutationObserver(function (mutations) {
    if (upload_cleanup_pending || !attachment_upload_queues.size || !mutations.some(function (mutation) { return mutation.removedNodes.length; })) return;
    upload_cleanup_pending = true;
    setTimeout(function () {
      upload_cleanup_pending = false;
      attachment_upload_cleanup();
    }, 0);
  }).observe(document.body, { childList: true, subtree: true });
  window.addEventListener('pagehide', function (event) {
    if (!event.persisted) attachment_upload_queues.forEach(function (queue) { attachment_upload_clear(queue.root); });
  });


  // run DataTable
  if ($(".js_dataTable").length > 0 && typeof HSDataTable === 'function') {
    var dataTableLanguage = {
      processing: __['Processing...'],
      search: __['Search:'],
      lengthMenu: __['Show _MENU_ entries'],
      info: __['Showing _START_ to _END_ of _TOTAL_ entries'],
      infoEmpty: __['Showing 0 to 0 of 0 entries'],
      infoFiltered: __['(filtered from _MAX_ total entries)'],
      infoPostFix: "",
      loadingRecords: __['Loading...'],
      zeroRecords: __['No matching records found'],
      emptyTable: __['No data available in table'],
      paginate: {
        first: __['First'],
        previous: __['Previous'],
        next: __['Next'],
        last: __['Last']
      },
      aria: {
        sortAscending: __[': activate to sort column ascending'],
        sortDescending: __[': activate to sort column descending']
      }
    };
    if (!window.$hsDataTableCollection) {
      window.$hsDataTableCollection = [];
    }
    $('.js_dataTable').each(function () {
      if (this.closest('[data-datatable]')) {
        return;
      }
      this.querySelectorAll('thead th[data-orderable="false"], thead td[data-orderable="false"]').forEach(function (th) {
        th.classList.add('--exclude-from-ordering');
      });
      var wrapper = document.createElement('div');
      wrapper.className = 'js-flyonui-datatable --prevent-on-load-init';
      wrapper.setAttribute('data-datatable', JSON.stringify({
        pageLength: 10,
        /* let the stylesheet size the columns, so a datatable and a plain table
           on the same page keep the same column widths */
        autoWidth: false,
        pagingOptions: {
          pageBtnClasses: 'heroui button button--ghost button--sm button--icon-only size-7.5 rounded-full'
        }
      }));
      wrapper.innerHTML =
        '<div class="js-flyonui-datatable-toolbar border-base-300 flex items-center justify-between gap-3 border-b px-5 py-3 max-md:flex-wrap">' +
        '<div class="input w-full md:w-auto md:max-w-60">' +
        '<span class="icon-[tabler--search] text-base-content/80 my-auto me-3 size-4 shrink-0"></span>' +
        '<input type="search" class="grow" data-datatable-search placeholder="' + __['Search'] + '">' +
        '</div>' +
        '<label class="flex items-center gap-2 text-sm text-base-content/80">' +
        '<span class="whitespace-nowrap">' + __['Show'] + '</span>' +
        '<select class="select" data-datatable-page-entities aria-label="' + __['Show _MENU_ entries'] + '">' +
        '<option value="10" selected>10</option>' +
        '<option value="25">25</option>' +
        '<option value="50">50</option>' +
        '<option value="100">100</option>' +
        '</select>' +
        '</label>' +
        '</div>' +
        '<div class="overflow-x-auto" data-datatable-table-host></div>' +
        '<div class="js-flyonui-datatable-footer border-base-300 flex items-center justify-between gap-3 border-t p-3 max-md:flex-wrap max-md:justify-center">' +
        '<div class="text-sm text-base-content/80" data-datatable-info>' +
        __['Displaying'] + ' (<span data-datatable-info-from></span>-<span data-datatable-info-to></span> ' + __['of'] + ' <span data-datatable-info-length></span>)' +
        '</div>' +
        '<div class="flex items-center space-x-1" data-datatable-paging>' +
        '<button type="button" class="heroui button button--ghost button--sm button--icon-only size-7.5 rounded-full" data-datatable-paging-prev>' +
        '<span class="icon-[tabler--chevrons-left] size-4.5 rtl:rotate-180"></span>' +
        '<span class="sr-only">' + __['Previous'] + '</span>' +
        '</button>' +
        '<div class="flex items-center space-x-1 [&>.active]:text-bg-soft-primary" data-datatable-paging-pages></div>' +
        '<button type="button" class="heroui button button--ghost button--sm button--icon-only size-7.5 rounded-full" data-datatable-paging-next>' +
        '<span class="sr-only">' + __['Next'] + '</span>' +
        '<span class="icon-[tabler--chevrons-right] size-4.5 rtl:rotate-180"></span>' +
        '</button>' +
        '</div>' +
        '</div>';
      this.parentNode.insertBefore(wrapper, this);
      wrapper.querySelector('[data-datatable-table-host]').appendChild(this);
      new HSDataTable(wrapper, { language: dataTableLanguage });
    });
  }


  // run Clipboard
  const clipboard_success = function (trigger) {
    const icon_default = trigger.querySelector('.js-clipboard-default');
    const icon_success = trigger.querySelector('.js-clipboard-success');
    const success_text = trigger.querySelector('.js-clipboard-success-text');
    if (!trigger._clipboard_text && success_text) {
      trigger._clipboard_text = success_text.textContent;
    }
    if (success_text && trigger.dataset.clipboardSuccessText) {
      success_text.textContent = trigger.dataset.clipboardSuccessText;
    }
    if (icon_default && icon_success) {
      icon_default.classList.add('hidden');
      icon_success.classList.remove('hidden');
    }
    clearTimeout(trigger._clipboard_timer);
    trigger._clipboard_timer = setTimeout(function () {
      if (success_text && trigger._clipboard_text) {
        success_text.textContent = trigger._clipboard_text;
      }
      if (icon_default && icon_success) {
        icon_success.classList.add('hidden');
        icon_default.classList.remove('hidden');
      }
    }, 2000);
  };
  $('body').on('click', '.js_clipboard', function () {
    const trigger = this;
    const target = trigger.dataset.clipboardTarget ? document.querySelector(trigger.dataset.clipboardTarget) : null;
    const text = trigger.dataset.clipboardText || (target ? (('value' in target) ? target.value : target.textContent) : '');
    if (!text) return;
    if (navigator.clipboard && window.isSecureContext) {
      navigator.clipboard.writeText(text).then(function () {
        clipboard_success(trigger);
      });
    } else {
      /* keep the textarea inside the modal so its focus trap allows the copy */
      const layer = $(trigger).closest('#modal, #modal-stacked');
      const input = $('<textarea class="fixed -top-96 opacity-0" readonly>').val(text).appendTo(layer.length ? layer : 'body').trigger('select');
      if (document.execCommand('copy')) clipboard_success(trigger);
      input.remove();
    }
  });


  // run tagify
  if ($(".js_tagify").length > 0) {
    $('.js_tagify').each(function () {
      if (!this.__tagify) {
        new Tagify(this, {
          duplicates: false,
          addTagOnBlur: false
        });
      }
    });
  }
  tagify_ajax('.js_tagify-ajax');


  // init geocomplete plugin
  if (geolocation_enabled) {
    init_geocomplete();
  }


  // init tinymce
  init_tinymce_editor();
  init_tinymce_advanced_editor();


  // init browser notifications
  if (browser_notifications_enabled) {
    if (("Notification" in window)) {
      if (Notification.permission !== "granted") {
        Notification.requestPermission();
      }
    }
  }


  // init browser location
  if (location_finder) {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(update_location);
    }
  }


  // run notification highlighter
  notification_highlighter();


  // run data heartbeat
  data_heartbeat();


  // job questions (create/edit job modals)
  $('body').on('click', '#modal .js_add-job-question', function () {
    var questions = $(this).closest('#modal').find('.job-question');
    var next = questions.filter('.hidden').first();
    if (!next.length) {
      return;
    }
    next.removeClass('hidden');
    if (questions.filter('.hidden').length === 0) {
      $(this).addClass('hidden');
    }
  });
  $('body').on('change', '#modal .js_question-type', function () {
    $(this).closest('.job-question').find('.js_question-choices').toggleClass('hidden', $(this).val() !== 'multiple_choice');
  });


  // run posts staging
  $('body').on('click', '.js_view-staging-posts', function () {
    var _this = $(this);
    $('.js_posts_stream_staging > li').detach().prependTo('.js_posts_stream > ul:first');
    $('.js_posts_stream_staging').html("");
    _this.find("span").text("0");
    _this.fadeOut();
    $('html, body').animate({
      scrollTop: $('.js_posts_stream').offset().top
    }, 200);
  });


  // run autocomplete
  /* focus the input */
  $('body').on('click', '.js_autocomplete', function () {
    var input = $(this).find('input').trigger('focus');
  });
  /* show and get the results if any */
  $('body').on('keyup', '.js_autocomplete input', function () {
    var _this = $(this);
    var query = _this.val();
    var parent = _this.parents('.js_autocomplete');
    /* check the query string */
    if (query != '') {
      /* check if results dropdown-menu not exist */
      if (_this.next('.dropdown-menu').length == 0) {
        /* construct a new one */
        var offset = _this.offset();
        var posX = offset.left - $(window).scrollLeft();
        if ($(window).width() - posX < 180) {
          _this.after('<div class="dropdown-menu auto-complete tl"></div>');
        } else {
          _this.after('<div class="dropdown-menu auto-complete"></div>');
        }
      }
      $.post(api['users/autocomplete'], { 'type': 'single', 'query': query }, function (response) {
        if (response.callback) {
          eval(response.callback);
        } else if (response.autocomplete) {
          _this.next('.dropdown-menu').show().html(response.autocomplete);
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
  $('body').on('click focus', '.js_autocomplete input', function () {
    /* only show again if the input & dropdown-menu are not empty */
    if ($(this).val() != '' && $(this).next('.dropdown-menu').find('li').length > 0) {
      $(this).next('.dropdown-menu').show();
    }
  });
  /* hide the results dropdown-menu when clicked outside the input */
  $('body').on('click', function (e) {
    if (!$(e.target).is(".js_autocomplete")) {
      $('.js_autocomplete .dropdown-menu').hide();
    }
  });
  /* add result */
  $('body').on('click', '.js_autocomplete-add', function () {
    var uid = $(this).data('uid');
    var name = $(this).data('name');
    var parent = $(this).parents('.js_autocomplete');
    parent.find('input').val(name).data('uid', uid);
    parent.find('input[type="hidden"]').val(uid);
  });


  // run autocomplete tags
  /* focus the input */
  $('body').on('click', '.js_autocomplete-tags', function () {
    var input = $(this).find('input').trigger('focus');
  });
  /* show and get the results if any */
  $('body').on('keyup', '.js_autocomplete-tags input', function () {
    var _this = $(this);
    var query = _this.val();
    var parent = _this.parents('.js_autocomplete-tags');
    /* change the width of typehead input */
    prev_length = _this.data('length') || 0;
    new_length = query.length;
    if (new_length > prev_length && _this.width() < 250) {
      _this.width(_this.width() + 6);
    } else if (new_length < prev_length) {
      _this.width(_this.width() - 6);
    }
    _this.data('length', query.length);
    /* check maximum number of tags */
    if (parent.find('ul.tags li').length > 9) {
      return;
    }
    /* check the query string */
    if (query != '') {
      /* check if results dropdown-menu not exist */
      if (_this.next('.dropdown-menu').length == 0) {
        /* construct a new one */
        var offset = _this.offset();
        var posX = offset.left - $(window).scrollLeft();
        if ($(window).width() - posX < 180) {
          _this.after('<div class="dropdown-menu auto-complete tl"></div>');
        } else {
          _this.after('<div class="dropdown-menu auto-complete"></div>');
        }
      }
      /* get skipped ids */
      var skipped_ids = [];
      var extra_skipped = parent.attr('data-skipped-ids');
      if (extra_skipped) {
        $.each(extra_skipped.split(','), function (i, id) {
          if (id) skipped_ids.push(id);
        });
      }
      $.each(parent.find('ul.tags li'), function (i, tag) {
        skipped_ids.push($(tag).data('uid'));
      });
      $.post(api['users/autocomplete'], { 'type': 'tags', 'query': query, 'skipped_ids': JSON.stringify(skipped_ids) }, function (response) {
        if (response.callback) {
          eval(response.callback);
        } else if (response.autocomplete) {
          _this.next('.dropdown-menu').show().html(response.autocomplete);
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
  $('body').on('click focus', '.js_autocomplete-tags input', function () {
    /* check maximum number of tags */
    if ($(this).parents('.js_autocomplete-tags').find('ul.tags li').length > 9) {
      return;
    }
    /* only show again if the input & dropdown-menu are not empty */
    if ($(this).val() != '' && $(this).next('.dropdown-menu').find('li').length > 0) {
      $(this).next('.dropdown-menu').show();
    }
  });
  /* hide the results dropdown-menu when clicked outside the input */
  $('body').on('click', function (e) {
    if (!$(e.target).is(".js_autocomplete-tags")) {
      $('.js_autocomplete-tags .dropdown-menu').hide();
    }
  });
  /* add a tag */
  $('body').on('click', '.js_tag-add', function () {
    var uid = $(this).data('uid');
    var name = $(this).data('name');
    var chat_price = $(this).data('chat-price') || 0;
    var call_price = $(this).data('call-price') || 0;
    var parent = $(this).parents('.js_autocomplete-tags');
    var tag = '<li data-uid="' + uid + '" data-chat-price="' + chat_price + '" data-call-price="' + call_price + '">' + name + '<button type="button" class="heroui button button--ghost [--button-fg:var(--accent)] button--sm button--icon-only rounded-full size-5 min-h-0 js_tag-remove" title="' + __['Remove'] + '" aria-label="' + __['Remove'] + '"><span class="icon-[tabler--x] size-3.5" aria-hidden="true"></span></button></li>'
    parent.find('.tags').append(tag);
    parent.find('input').val('').trigger('focus');
    /* check if there is chat-form next to js_autocomplete-tags */
    if (parent.siblings('.chat-form').length > 0) {
      if (parent.find('ul.tags li').length == 0) {
        if (!parent.siblings('.chat-form').hasClass('invisible')) {
          parent.siblings('.chat-form').addClass('invisible');
        }
      } else {
        parent.siblings('.chat-form').removeClass('invisible');
      }
    }
  });
  /* remove a tag */
  $('body').on('click', '.js_tag-remove', function () {
    var tag = $(this).parents('li');
    var parent = $(this).parents('.js_autocomplete-tags');
    tag.remove();
    /* check if there is chat-form next to js_autocomplete-tags */
    if (parent.siblings('.chat-form').length > 0) {
      if (parent.find('ul.tags li').length == 0) {
        if (!parent.siblings('.chat-form').hasClass('invisible')) {
          parent.siblings('.chat-form').addClass('invisible');
        }
      } else {
        parent.siblings('.chat-form').removeClass('invisible');
      }
    }
    return false;
  });


  // run @mentions
  var mentions = { input: null, items: [], index: 0, timer: null, xhr: null };
  var mentions_menu = $('<div class="fixed z-[100020] hidden max-h-72 w-72 overflow-y-auto rounded-box border border-base-300 bg-base-100 p-1.5 shadow-lg" role="listbox"></div>').appendTo('body');
  function mentions_close() {
    clearTimeout(mentions.timer);
    if (mentions.xhr) mentions.xhr.abort();
    mentions.input = null;
    mentions.items = [];
    mentions_menu.addClass('hidden').empty();
  }
  function mentions_highlight() {
    var item = mentions_menu.children().removeClass('bg-base-200').eq(mentions.index).addClass('bg-base-200');
    if (item.length) item[0].scrollIntoView({ block: 'nearest' });
  }
  function mentions_render() {
    mentions_menu.empty();
    mentions.items.forEach(function (item, index) {
      $(render_template('#publisher-mention-item', { avatar: item.img, value: item.label.trim() })).attr({ 'data-index': index, 'role': 'option' }).addClass('cursor-pointer').appendTo(mentions_menu);
    });
    mentions_highlight();
    /* position under the textarea (or above it if there is no room) */
    var rect = mentions.input.getBoundingClientRect();
    mentions_menu.removeClass('hidden');
    var width = mentions_menu.outerWidth();
    var height = mentions_menu.outerHeight();
    var top = (rect.bottom + height + 4 > window.innerHeight && rect.top > height + 4) ? rect.top - height - 4 : rect.bottom + 4;
    var left = ($('html').attr('dir') == 'rtl') ? rect.right - width : rect.left;
    left = Math.max(8, Math.min(left, window.innerWidth - width - 8));
    mentions_menu.css({ 'top': top + 'px', 'left': left + 'px' });
  }
  function mentions_term(input) {
    var match = input.value.substring(0, input.selectionStart).match(/(^|\s)@([\p{L}\p{N}_\-]{1,20})$/u);
    return match ? match[2] : null;
  }
  function mentions_select(index) {
    var item = mentions.items[index];
    var input = mentions.input;
    var term = input ? mentions_term(input) : null;
    if (!item || term === null) {
      mentions_close();
      return;
    }
    var before = input.value.substring(0, input.selectionStart - term.length - 1) + item.value + ' ';
    input.value = before + input.value.substring(input.selectionStart);
    input.setSelectionRange(before.length, before.length);
    mentions_close();
    input.focus();
    input.dispatchEvent(new Event('input', { bubbles: true }));
  }
  $('body').on('input', '.js_mentions', function () {
    var input = this;
    var term = mentions_term(input);
    clearTimeout(mentions.timer);
    if (mentions.xhr) mentions.xhr.abort();
    if (term === null) {
      mentions_close();
      return;
    }
    mentions.timer = setTimeout(function () {
      mentions.xhr = $.getJSON(api['users/mentions'], { 'term': term }, function (response) {
        if (!Array.isArray(response) || response.length == 0 || document.activeElement !== input) {
          mentions_close();
          return;
        }
        mentions.input = input;
        mentions.items = response;
        mentions.index = 0;
        mentions_render();
      });
    }, 200);
  });
  $('body').on('keydown', '.js_mentions', function (event) {
    if (mentions.input !== this || mentions_menu.hasClass('hidden')) {
      return;
    }
    switch (event.key) {
      case 'ArrowDown':
        mentions.index = (mentions.index + 1) % mentions.items.length;
        break;
      case 'ArrowUp':
        mentions.index = (mentions.index - 1 + mentions.items.length) % mentions.items.length;
        break;
      case 'Enter':
      case 'Tab':
        mentions_select(mentions.index);
        break;
      case 'Escape':
        mentions_close();
        break;
      default:
        return;
    }
    event.preventDefault();
    event.stopImmediatePropagation();
    mentions_highlight();
  });
  $('body').on('blur', '.js_mentions', mentions_close);
  mentions_menu.on('mousedown', '[data-index]', function (event) {
    /* keep the textarea focused */
    event.preventDefault();
    mentions_select($(this).data('index'));
  });
  $(window).on('resize', mentions_close);
  window.addEventListener('scroll', function (event) {
    if (!mentions_menu.hasClass('hidden') && !mentions_menu[0].contains(event.target)) mentions_close();
  }, true);


  // run user-popover
  $('body').on('mouseenter', '.js_user-popover', function () {
    /* do not run if window size < 768px */
    if ($(window).width() < 751) {
      return;
    }
    var _this = $(this);
    var uid = _this.data('uid');
    var type = _this.data('type') || 'user';
    var _timeout = setTimeout(function () {
      var offset = _this.offset();
      var posY = (offset.top - $(window).scrollTop()) + _this.height();
      var posX = offset.left - $(window).scrollLeft();
      if ($('html').attr('dir') == "rtl") {
        var available = posX + _this.width();
        if (available < 400) {
          $('body').append('<div class="user-popover-wrapper z-[100020]" style="position: fixed; top: ' + posY + 'px; left:' + posX + 'px"><div class="user-popover-content relative flex w-80 justify-center rounded-box border border-base-300 bg-base-100 p-5 shadow-lg"><div class="loading loading-spinner loading-sm"></div></div></div>');
        } else {
          var right = $(window).width() - available;
          $('body').append('<div class="user-popover-wrapper z-[100020]" style="position: fixed; top: ' + posY + 'px; right:' + right + 'px"><div class="user-popover-content relative flex w-80 justify-center rounded-box border border-base-300 bg-base-100 p-5 shadow-lg"><div class="loading loading-spinner loading-sm"></div></div></div>');
        }
      } else {
        var available = $(window).width() - posX;
        if (available < 400) {
          var right = available - _this.width();
          $('body').append('<div class="user-popover-wrapper z-[100020]" style="position: fixed; top: ' + posY + 'px; right:' + right + 'px"><div class="user-popover-content relative flex w-80 justify-center rounded-box border border-base-300 bg-base-100 p-5 shadow-lg"><div class="loading loading-spinner loading-sm"></div></div></div>');
        } else {
          $('body').append('<div class="user-popover-wrapper z-[100020]" style="position: fixed; top: ' + posY + 'px; left:' + posX + 'px"><div class="user-popover-content relative flex w-80 justify-center rounded-box border border-base-300 bg-base-100 p-5 shadow-lg"><div class="loading loading-spinner loading-sm"></div></div></div>');
        }
      }
      $.getJSON(api['users/popover'], { 'type': type, 'uid': uid }, function (response) {
        if (response.callback) {
          eval(response.callback);
        } else {
          if (response.popover) {
            $('.user-popover-wrapper').html(response.popover);
          }
        }
      });
    }, 1000);
    _this.data('timeout', _timeout);
  });
  $('body').on('mouseleave', '.js_user-popover', function (e) {
    var to = e.toElement || e.relatedTarget;
    if (!$(to).closest('.user-popover-wrapper').length) {
      clearTimeout($(this).data('timeout'));
      $('.user-popover-wrapper').remove();
    }
  });
  $('body').on('mouseleave', '.user-popover-wrapper', function () {
    $('.user-popover-wrapper').remove();
  });


  // composer gif remover
  $('body').on('click', '.js_gif-remove', function () {
    var form = $(this).closest('.js_composer');
    composer_gif_clear(form.closest(form.data('handle') === 'comment' ? '.comment' : '.chat-widget, .panel-messages'));
  });


  // run x-uploader
  /* initialize the uplodaer */
  initialize_uploader();
  $(document).ajaxComplete(function (event, xhr) {
    /* skipped for background polls that changed nothing (see core.js) */
    if (xhr.sngine_unchanged) {
      return;
    }
    initialize_uploader();
  });
  /* initialize uploading */
  $('body').on('change', '.x-uploader input[type="file"]', function (e) {
    $(this).parent('.x-uploader').trigger("submit");
  });
  /* uploading */
  $('body').on('submit', '.x-uploader', async function (e) {
    e.preventDefault();
    e.stopPropagation();
    /* get form */
    var _form = $(this);
    /* get secret */
    var secret = _form.find('input[name="secret"]').val();
    if (secret === undefined) {
      return false;
    }
    /* get uploader input */
    var uploader = $(this).find('input[type="file"]');
    /* get type */
    var type = $(this).find('.js_x-uploader').data('type') || "photos";
    /* get handle */
    var handle = $(this).find('.js_x-uploader').data('handle');
    if (handle === undefined) {
      return false;
    }
    /* get multiple */
    var multiple = ($(this).find('.js_x-uploader').data('multiple') !== undefined) ? true : false;
    /* get id */
    var id = $(this).find('.js_x-uploader').data('id');
    /* get blur */
    var blur = ($(this).find('.js_x-uploader').data('blur') !== undefined) ? true : false;
    /* get x-image tile */
    var x_tile = null;
    /* attachment queue */
    if (['publisher', 'publisher-mini', 'comment', 'chat'].includes(handle) && ['photos', 'video', 'reel', 'audio', 'file'].includes(type)) {
      attachment_upload_add(_form, { secret: secret, type: type, handle: handle, multiple: multiple, target: id, blur: blur });
      return false;
    }
    /* check type */
    if (type == "photos") {
      /* check handle */
      if (handle == "cover-user" || handle == "cover-page" || handle == "cover-group" || handle == "cover-event") {
        var loader = $('.profile-cover-change-loader');
        loader.show();
      } else if (handle == "picture-user" || handle == "picture-page" || handle == "picture-group") {
        var loader = $('.profile-avatar-change-loader');
        loader.show();
      } else if (handle == "publisher") {
        var publisher = $(this).parents('.publisher');
        var publisher_button = publisher.find('.js_publisher-btn');
        var files_num = uploader.get(0).files.length;
        /* check if there is current scraping process */
        if (publisher.data('scraping')) {
          return false;
        }
        /* check if there is already uploading process */
        if (!publisher.data('photos')) {
          publisher.data('photos', {});
        }
        var attachments = publisher.find('.js_attachments-photos');
        var loader = $('<ul></ul>').appendTo(attachments);
        attachments.show();
        for (var i = 0; i < files_num; ++i) {
          $('<li class="js_loading"><div class="progress x-progress"><div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div></div></li>').appendTo(loader).show();
        }
        /* handle publisher tab */
        if (jQuery.isEmptyObject(publisher.data('photos')) && jQuery.isEmptyObject(publisher.data('video')) && jQuery.isEmptyObject(publisher.data('audio')) && jQuery.isEmptyObject(publisher.data('file'))) {
          publisher_tab(publisher, type);
        }
        /* disable publisher button */
        button_status(publisher_button, "loading");
      } else if (handle == "publisher-mini") {
        var publisher = $(this).parents('.publisher-mini');
        var publisher_button = publisher.find('.js_publisher-btn');
        var files_num = uploader.get(0).files.length;
        /* check if there is already uploading process */
        if (!publisher.data('photos')) {
          publisher.data('photos', {});
        }
        var attachments = publisher.find('.attachments[data-type="photos"]');
        var loader = $('<ul></ul>').appendTo(attachments);
        for (var i = 0; i < files_num; ++i) {
          $('<li class="js_loading"><div class="progress x-progress"><div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div></div></li>').appendTo(loader).show();
        }
        /* disable publisher button */
        button_status(publisher_button, "loading");
      } else if (handle == "comment") {
        var comment = $(this).parents('.comment');
        /* check if there is already uploading process */
        if (comment.data('photos')) {
          return false;
        }
        var attachments = comment.find('.comment-attachments');
        var loader = attachments.find('li.js_loading');
        attachments.show();
        loader.show();
        /* hide comment x-form-tools */
        comment.find('.x-form-tools-attach').hide();
        comment.find('.x-form-tools-voice').hide();
      } else if (handle == "chat") {
        var chat_widget = $(this).parents('.chat-widget, .panel-messages');
        /* check if there is already uploading process */
        if (chat_widget.data('photo')) {
          return false;
        }
        var attachments = chat_widget.find('.chat-attachments');
        var loader = attachments.find('li.js_loading');
        attachments.show();
        loader.show();
        /* hide chat widget x-form-tools */
        chat_widget.find('.x-form-tools-attach').hide();
        chat_widget.find('.x-form-tools-voice').hide();
      } else if (handle == "x-image" || handle == "dating") {
        var parent = $(this).parents('.x-image');
        x_tile = parent;
        x_image_state(x_tile, 'uploading', 0);
      }
    } else if (type == "reel") {
      /* check handle */
      if (handle == "publisher") {
        /* check video duration */
        if (reels_minimum_duration != 0 || reels_maximum_duration != 0) {
          var valid_duration = await check_video_duration(uploader[0].files[0], reels_minimum_duration, reels_maximum_duration);
          if (!valid_duration) {
            return false;
          }
        }
        var publisher = $(this).parents('.publisher');
        var publisher_button = publisher.find('.js_publisher-btn');
        /* check if there is current scraping process */
        if (publisher.data('scraping')) {
          return false;
        }
        publisher.data(type, {});
        var attachments = publisher.find('.js_attachments-video');
        var loader = $('<ul></ul>').appendTo(attachments);
        attachments.show();
        $('<li class="js_loading"><div class="progress x-progress"><div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div></div></li>').appendTo(loader).show();
        /* handle publisher tab */
        if (jQuery.isEmptyObject(publisher.data('photos')) && jQuery.isEmptyObject(publisher.data('video')) && jQuery.isEmptyObject(publisher.data('audio')) && jQuery.isEmptyObject(publisher.data('file'))) {
          publisher_tab(publisher, type);
        }
        /* disable publisher album */
        publisher_tab(publisher, 'album_disable');
        /* disable publisher button */
        button_status(publisher_button, "loading");
      }
    } else if (type == "video") {
      /* check handle */
      if (handle == "publisher") {
        /* check video duration */
        if (video_minimum_duration != 0 || video_maximum_duration != 0) {
          var valid_duration = await check_video_duration(uploader[0].files[0], video_minimum_duration, video_maximum_duration);
          if (!valid_duration) {
            return false;
          }
        }
        var publisher = $(this).parents('.publisher');
        var publisher_button = publisher.find('.js_publisher-btn');
        /* check if there is current scraping process */
        if (publisher.data('scraping')) {
          return false;
        }
        publisher.data(type, {});
        var attachments = publisher.find('.js_attachments-video');
        var loader = $('<ul></ul>').appendTo(attachments);
        attachments.show();
        $('<li class="js_loading"><div class="progress x-progress"><div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div></div></li>').appendTo(loader).show();
        /* handle publisher tab */
        if (jQuery.isEmptyObject(publisher.data('photos')) && jQuery.isEmptyObject(publisher.data('video')) && jQuery.isEmptyObject(publisher.data('audio')) && jQuery.isEmptyObject(publisher.data('file'))) {
          publisher_tab(publisher, type);
        }
        /* disable publisher album */
        publisher_tab(publisher, 'album_disable');
        /* disable publisher button */
        button_status(publisher_button, "loading");
      } else if (handle == "publisher-mini") {
        var publisher = $(this).parents('.publisher-mini');
        var publisher_button = publisher.find('.js_publisher-btn');
        var files_num = uploader.get(0).files.length;
        /* check if there is already uploading process */
        if (!publisher.data(type)) {
          publisher.data(type, {});
        }
        var attachments = publisher.find('.attachments[data-type="videos"]');
        var loader = $('<ul></ul>').appendTo(attachments);
        var files_names = [];
        for (var i = 0; i < files_num; ++i) {
          files_names[i] = uploader.get(0).files[i].name;
          $('<li class="js_loading"><div class="progress x-progress"><div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div></div></li>').appendTo(loader).show();
        }
        /* disable publisher button */
        button_status(publisher_button, "loading");
      } else if (handle == "x-video") {
        var parent = $(this).parents('.x-image');
        x_tile = parent;
        x_image_state(x_tile, 'uploading', 0);
      }
    } else if (type == "audio" || type == "file") {
      /* check handle */
      if (handle == "publisher") {
        /* show upload loader */
        var publisher = $(this).parents('.publisher');
        var publisher_button = publisher.find('.js_publisher-btn');
        /* check if there is current scraping process */
        if (publisher.data('scraping')) {
          return false;
        }
        publisher.data(type, {});
        var attachments = publisher.find('.js_attachments-' + type);
        var loader = $('<ul></ul>').appendTo(attachments);
        attachments.show();
        $('<li class="js_loading"><div class="progress x-progress"><div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div></div></li>').appendTo(loader).show();
        /* handle publisher tab */
        if (jQuery.isEmptyObject(publisher.data('photos')) && jQuery.isEmptyObject(publisher.data('video')) && jQuery.isEmptyObject(publisher.data('audio')) && jQuery.isEmptyObject(publisher.data('file'))) {
          publisher_tab(publisher, type);
        }
        /* disable publisher album */
        publisher_tab(publisher, 'album_disable');
        /* disable publisher button */
        button_status(publisher_button, "loading");
      } else if (handle == "x-audio" || handle == "x-file") {
        var parent = $(this).parents('.x-image');
        x_tile = parent;
        x_image_state(x_tile, 'uploading', 0);
      }
    }
    /* handle success */
    function _handle_success(response) {
      /* enable uploader input */
      uploader.prop('disabled', false);
      /* hide upload loader */
      if (loader) loader.hide();
      if (x_tile) x_image_state(x_tile, 'idle');
      /* handle the response */
      if (response.callback) {
        _handle_error(false);
        eval(response.callback);
      } else {
        /* check type */
        if (type == "photos") {
          /* check the handle */
          if (handle == "cover-user" || handle == "cover-page" || handle == "cover-group" || handle == "cover-event") {
            /* update (user|page|group|event) cover */
            var image_path = uploads_path + '/' + response.file;
            change_cover_picture(image_path);
          } else if (handle == "picture-user" || handle == "picture-page" || handle == "picture-group") {
            /* update (user|page|group) picture */
            var image_path = uploads_path + '/' + response.file;
            change_profile_picture(image_path);
          } else if (handle == "publisher") {
            /* remove upload loader */
            if (loader) loader.remove();
            /* add the attachment to publisher data */
            var files = publisher.data('photos') || {};
            var photo_layout_enabled = publisher.find('.js_publisher-photo-layout').length > 0;
            if (!photo_layout_enabled && attachments.find('ul').length == 0) {
              attachments.append('<ul></ul>');
            }
            for (var i in response.files) {
              files[response.files[i]['source']] = response.files[i];
              /* add publisher-attachments */
              if (!photo_layout_enabled) {
                var image_path = uploads_path + '/' + response.files[i]['source'];
                attachments.find('ul').append(render_template("#uploader-attachments-image-item", { 'src': response.files[i]['source'], 'image_path': image_path }));
              }
            }
            publisher.data('photos', files);
            attachments.show();
            if (photo_layout_enabled) publisher_photos_refresh(publisher);
            /* handle publisher tabs */
            publisher.find('.js_publisher-tab[data-tab="' + type + '"]').addClass('activated');
            /* enable publisher button */
            button_status(publisher_button, "reset");
          } else if (handle == "publisher-mini") {
            /* remove upload loader */
            if (loader) loader.remove();
            /* add the attachment to publisher data */
            var files = publisher.data('photos');
            if (attachments.find('ul').length == 0) {
              attachments.append('<ul></ul>');
            }
            for (var i in response.files) {
              files[response.files[i]['source']] = response.files[i];
              /* add publisher-attachments */
              var image_path = uploads_path + '/' + response.files[i]['source'];
              attachments.find('ul').append(render_template("#uploader-attachments-image-item", { 'src': response.files[i]['source'], 'image_path': image_path, 'mini': true }));
            }
            publisher.data('photos', files);
            /* save photos data to hidden input "photos" if exists */
            if (publisher.find('.js_hidden-input-photos').length > 0) {
              var photos = publisher.find('.js_hidden-input-photos').val();
              if (photos != '') {
                photos = JSON.parse(photos);
                for (var i in response.files) {
                  photos[response.files[i]['source']] = response.files[i];
                }
                publisher.find('.js_hidden-input-photos').val(JSON.stringify(photos));
              } else {
                publisher.find('.js_hidden-input-photos').val(JSON.stringify(files));
              }
            }
            /* enable publisher button */
            button_status(publisher_button, "reset");
          } else if (handle == "comment") {
            /* add the attachment to comment data */
            comment.data('photos', response.file);
            /* hide comment x-form-tools */
            comment.find('.x-form-tools-attach').hide();
            comment.find('.x-form-tools-voice').hide();
            /* add comment-attachments */
            var image_path = uploads_path + '/' + response.file;
            attachments.find('ul').append(render_template("#comment-attachments-item", { 'src': response.file, 'image_path': image_path }));
          } else if (handle == "chat") {
            /* add the attachment to chat widget data */
            chat_widget.data('photo', response.file);
            /* hide chat widget x-form-tools */
            chat_widget.find('.x-form-tools-attach').hide();
            chat_widget.find('.x-form-tools-voice').hide();
            /* add chat-attachments */
            var image_path = uploads_path + '/' + response.file;
            attachments.find('ul').append(render_template("#chat-attachments-item", { 'src': response.file, 'image_path': image_path }));
          } else if (handle == "x-image") {
            /* update x-image picture */
            var image_path = uploads_path + '/' + response.file;
            parent.css("background-image", 'url(' + image_path + ')');
            /* add the image to input */
            parent.find('.js_x-uploader-input').val(response.file).trigger('change');
            /* show the remover */
            parent.find('.js_x-image-remover').removeClass('hidden');
          } else if (handle == "dating") {
            /* add the image to input */
            parent.find('.js_x-uploader-input').val(response.file).trigger('change');
          }
        } else if (type == "reel") {
          /* check the handle */
          if (handle == "publisher") {
            /* hide the attachment from publisher data */
            attachments.hide();
            /* remove upload loader */
            if (loader) loader.remove();
            /* show publisher meta */
            $('.publisher-meta[data-meta="' + type + '"]').show();
            $('.publisher-reel-custom-thumbnail').show();
            /* add the attachment to publisher data */
            var object = publisher.data(type);
            object['source'] = response.file;
            /* add publisher-attachments */
            publisher.data(type, object);
            /* handle publisher tabs */
            publisher.find('.js_publisher-tab[data-tab="' + type + '"]').addClass('activated');
            /* enable publisher button */
            button_status(publisher_button, "reset");
            /* get subscribers only */
            var subscriptions_image_wrapper = publisher.find("#subscriptions-image-wrapper")
            var subscriptions_image_input = subscriptions_image_wrapper.find('input.js_x-uploader-input');
            /* get paid post */
            var paid_price_wrapper = publisher.find("#paid-price-wrapper")
            var paid_price_input = paid_price_wrapper.find('input');
            var paid_text_wrapper = publisher.find("#paid-text-wrapper")
            var paid_text_input = paid_text_wrapper.find('textarea');
            var paid_image_wrapper = publisher.find("#paid-image-wrapper")
            var paid_image_input = paid_image_wrapper.find('input.js_x-uploader-input');
            /* uncheck adult toggle */
            publisher.find('.js_publisher-adult-toggle').prop('checked', false);
            publisher.find('.js_publisher-adult-toggle').prop('disabled', true);
            publisher.find("#adult-toggle-wrapper").addClass("disabled");
            /* uncheck tips toggle */
            publisher.find('.js_publisher-tips-toggle').prop('checked', false);
            publisher.find('.js_publisher-tips-toggle').prop('disabled', true);
            publisher.find("#tips-toggle-wrapper").addClass("disabled");
            /* uncheck subscribers toggle */
            publisher.find('.js_publisher-subscribers-toggle').prop('checked', false);
            publisher.find('.js_publisher-subscribers-toggle').prop('disabled', true);
            publisher.find("#subscribers-toggle-wrapper").addClass("disabled");
            /* reset subscriptions image */
            subscriptions_image_wrapper.hide();
            x_image_reset(subscriptions_image_wrapper.find('.x-image'));
            subscriptions_image_input.val('');
            /* uncheck paid toggle */
            publisher.find('.js_publisher-paid-toggle').prop('checked', false);
            publisher.find('.js_publisher-paid-toggle').prop('disabled', true);
            publisher.find("#paid-toggle-wrapper").addClass("disabled");
            /* reset paid price */
            paid_price_wrapper.hide();
            paid_price_input.val('');
            paid_text_wrapper.hide();
            paid_text_input.val('');
            /* reset paid image */
            paid_image_wrapper.hide();
            x_image_reset(paid_image_wrapper.find('.x-image'));
            paid_image_input.val('');
          }
        } else if (type == "video") {
          /* check the handle */
          if (handle == "publisher") {
            /* hide the attachment from publisher data */
            attachments.hide();
            /* remove upload loader */
            if (loader) loader.remove();
            /* show publisher meta */
            $('.publisher-meta[data-meta="' + type + '"]').show();
            $('.publisher-video-custom-thumbnail').show();
            /* add the attachment to publisher data */
            var object = publisher.data(type);
            object['source'] = response.file;
            /* add publisher-attachments */
            publisher.data(type, object);
            /* handle publisher tabs */
            publisher.find('.js_publisher-tab[data-tab="' + type + '"]').addClass('activated');
            /* enable publisher button */
            button_status(publisher_button, "reset");
          } else if (handle == "publisher-mini") {
            /* remove upload loader */
            if (loader) loader.remove();
            /* add the attachment to publisher data */
            var files = publisher.data(type);
            if (attachments.find('ul').length == 0) {
              attachments.append('<ul></ul>');
            }
            for (var i in response.files) {
              files[response.files[i]] = response.files[i];
              /* add publisher-attachments */
              attachments.find('ul').append(render_template("#uploader-attachments-video-item", { 'src': response.files[i], 'name': files_names[i] }));
            }
            publisher.data(type, files);
            /* enable publisher button */
            button_status(publisher_button, "reset");
          } else if (handle == "x-video") {
            /* update x-video */
            parent.find('.x-image-success').removeClass('hidden');
            /* add the image to input */
            parent.find('.js_x-uploader-input').val(response.file).trigger('change');
            /* show the remover */
            parent.find('.js_x-video-remover').removeClass('hidden');
          }
        } else if (type == "audio" || type == "file") {
          /* check the handle */
          if (handle == "publisher") {
            /* hide the attachment from publisher data */
            attachments.hide();
            /* remove upload loader */
            if (loader) loader.remove();
            /* show publisher meta */
            $('.publisher-meta[data-meta="' + type + '"]').show();
            /* add the attachment to publisher data */
            var object = publisher.data(type);
            object['source'] = response.file;
            /* add publisher-attachments */
            publisher.data(type, object);
            /* handle publisher tabs */
            publisher.find('.js_publisher-tab[data-tab="' + type + '"]').addClass('activated');
            /* enable publisher button */
            button_status(publisher_button, "reset");
          } else if (handle == "x-audio" || handle == "x-file") {
            /* update x-audio */
            parent.find('.x-image-success').removeClass('hidden');
            /* add the image to input */
            parent.find('.js_x-uploader-input').val(response.file);
            /* show the remover */
            parent.find('.js_x-image-remover').removeClass('hidden');
          }
        }
      }
    }
    /* handle error */
    function _handle_error(show_error_modal = true) {
      /* enable uploader input */
      uploader.prop('disabled', false);
      /* hide upload loader */
      if (loader) loader.hide();
      if (x_tile) x_image_state(x_tile, 'idle');
      /* check the handle */
      if (handle == "publisher") {
        /* hide the attachment from publisher */
        if ((type == "photos" && jQuery.isEmptyObject(publisher.data('photos'))) || type != "photos") {
          /* hide attachments */
          attachments.hide();
          /* remove the type object from publisher data */
          publisher.removeData(type);
          /* handle publisher tab */
          publisher_tab(publisher, type);
        }
        /* remove upload loader */
        if (loader) loader.remove();
        if (type == 'photos') publisher_photos_refresh(publisher);
        /* enable publisher button */
        button_status(publisher_button, "reset");
      } else if (handle == "publisher-mini") {
        /* enable publisher button */
        button_status(publisher_button, "reset");
      }
      if (show_error_modal) {
        show_error_modal();
      }
    }
    /* handle chunked upload */
    var chunkSize = chunk_upload_size * 1024 * 1024;
    var files = Array.from(uploader[0].files);
    var filesTotal = files.length;
    var fileGUIDs = Array.from(files).map(() => guid());
    var currentFileIndex = 0;
    var currentChunkIndex = 0;
    function uploadChunk(finished_files) {
      var file = files[currentFileIndex];
      var fileGUID = fileGUIDs[currentFileIndex];
      var totalChunks = Math.ceil(file.size / chunkSize);
      var start = currentChunkIndex * chunkSize;
      var end = Math.min(start + chunkSize, file.size);
      var chunk = file.slice(start, end);
      var finished_files = finished_files || [];
      var formData = new FormData();
      formData.append('secret', secret);
      formData.append('type', type);
      formData.append('handle', handle);
      formData.append('multiple', multiple);
      formData.append('file', chunk);
      formData.append('name', file.name);
      formData.append('guid', fileGUID);
      formData.append('chunkIndex', currentChunkIndex);
      formData.append('totalChunks', totalChunks);
      formData.append('fileIndex', currentFileIndex);
      formData.append('totalFiles', filesTotal);
      if (finished_files) {
        formData.append('finished_files', JSON.stringify(finished_files));
      }
      if (id !== undefined) {
        formData.append('id', id);
      }
      if (blur !== undefined) {
        formData.append('blur', blur);
      }
      $.ajax({
        url: api['data/upload'],
        type: 'POST',
        data: formData,
        processData: false,
        contentType: false,
        success: function (response) {
          if (response.callback) {
            _handle_error(false);
            eval(response.callback);
          } else {
            currentChunkIndex++;
            if (currentChunkIndex < totalChunks) {
              uploadChunk(response.finished_files);
            } else {
              currentChunkIndex = 0;
              currentFileIndex++;
              if (currentFileIndex < filesTotal) {
                uploadChunk(response.finished_files);
              } else {
                _handle_success(response);
              }
            }
          }
        },
        error: _handle_error,
        xhr: function () {
          var xhr = new XMLHttpRequest();
          xhr.upload.addEventListener('progress', function (e) {
            if (e.lengthComputable) {
              /* disable uploader input during uploading */
              uploader.prop('disabled', true);
              /* get progress percent */
              var percentComplete = (e.loaded + currentChunkIndex * chunkSize) / file.size * 100;
              /* add percent to loader progress bar */
              if (loader) loader.find('.progress-bar').css('width', percentComplete + '%').attr('aria-valuenow', percentComplete);
              if (x_tile) x_image_state(x_tile, 'uploading', percentComplete);
            }
          }, false);
          return xhr;
        }
      });
    }
    /* call upload chunk */
    uploadChunk();
    /* clear uploader input */
    uploader.val('');
    /* return false */
    return false;
  });
  /* handle profile (cover|picture) trigger */
  $('body').on('click', '.js_profile-image-trigger', function () {
    $('.profile-avatar-change input[type="file"]').trigger('click');
  });
  $('body').on('click', '.js_profile-cover-trigger', function () {
    $('.profile-cover-change input[type="file"]').trigger('click');
  });
  /* handle profile (cover|picture) remover */
  $('body').on('click', '.js_delete-cover, .js_delete-picture', function (e) {
    e.stopPropagation();
    var id = $(this).data('id');
    var handle = $(this).data('handle');
    var remove = ($(this).hasClass('js_delete-cover')) ? 'cover' : 'picture';
    if (remove == 'cover') {
      var wrapper = $('.profile-cover-wrapper');
      var _title = __['Delete Cover'];
      var _message = __['Are you sure you want to remove your cover photo?'];
    } else {
      var wrapper = $('.profile-avatar-wrapper');
      var _title = __['Delete Picture'];
      var _message = __['Are you sure you want to remove your profile picture?'];
    }
    confirm(_title, _message, function () {
      $.post(api['users/image_delete'], { 'handle': handle, 'id': id }, function (response) {
        /* check the response */
        if (response.callback) {
          eval(response.callback);
        } else {
          if (remove == 'cover') {
            /* hide delete btn  */
            wrapper.find('.profile-cover-delete').hide();
            /* hide position btn  */
            wrapper.find('.profile-cover-position').hide();
            /* remove (user|page|group) cover */
            wrapper.find('img').remove();
          } else {
            /* hide delete btn  */
            wrapper.find('.profile-avatar-delete').hide();
            /* hide crop btn  */
            wrapper.find('.profile-avatar-crop').hide();
            /* remove lightbox */
            wrapper.find('img').removeClass('js_lightbox').removeAttr('data-id').removeAttr('data-image').removeAttr('data-context');
            /* update (user|page|group) picture with default picture */
            wrapper.find('img').attr("src", response.file);
          }
          modal_close();
        }
      }, 'json')
        .fail(function () {
          show_error_modal();
        });
    });
  });
  /* handle x-image remover */
  $('body').on('click', '.js_x-image-remover', function () {
    var parent = $(this).parents('.x-image');
    var image = parent.find('.js_x-uploader-input').val();
    if (typeof publisher_edit_saved_upload === 'function' && publisher_edit_saved_upload(parent.closest('.publisher'), image)) {
      x_image_reset(parent);
      return;
    }
    confirm(__['Delete'], __['Are you sure you want to delete this?'], function () {
      /* reset the uploader */
      x_image_reset(parent);
      /* hide the confimation */
      modal_close();
      /* remove the file from the server */
      $.post(api['users/image_delete'], { 'handle': 'x-image', 'image': image }, function (response) {
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
  /* handle x-video remover */
  $('body').on('click', '.js_x-video-remover', function () {
    var parent = $(this).parents('.x-image');
    var src = parent.find('.js_x-uploader-input').val();
    confirm(__['Delete'], __['Are you sure you want to delete this?'], function () {
      /* reset the uploader */
      x_image_reset(parent);
      /* hide the confimation */
      modal_close();
      /* remove the file from the server */
      $.post(api['data/delete'], { 'src': src }, function (response) {
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


  // handle profile picture change
  $('body').on('click', '.js_profile-picture-change', function () {
    var id = $(this).data('id');
    var type = $(this).data('type');
    var image = $(this).data('image');
    /* init loading modal */
    modal('#modal-loading', {}, 'default');
    $.post(api['users/image_change'], { 'id': id, 'handle': 'avatar', 'type': type, 'image': image }, function (response) {
      /* check the response */
      if (response.callback) {
        eval(response.callback);
      } else {
        /* update (user|page|group) picture */
        var image_path = uploads_path + '/' + image;
        change_profile_picture(image_path);
      }
    }, 'json')
      .fail(function () {
        show_error_modal();
      });
  });


  // handle profile cover change
  $('body').on('click', '.js_profile-cover-change', function () {
    var id = $(this).data('id');
    var type = $(this).data('type');
    var image = $(this).data('image');
    /* init loading modal */
    modal('#modal-loading', {}, 'default');
    $.post(api['users/image_change'], { 'id': id, 'handle': 'cover', 'type': type, 'image': image }, function (response) {
      /* remove loading modal */
      modal_close();
      /* check the response */
      if (response.callback) {
        eval(response.callback);
      } else {
        /* update (user|page|group|event) cover */
        var image_path = uploads_path + '/' + image;
        change_cover_picture(image_path);
      }
    }, 'json')
      .fail(function () {
        show_error_modal();
      });
  });


  // handle picture crop
  /* init crop picture */
  $('body').on('click', '.js_init-crop-picture', function () {
    init_picture_crop($(this));
  });
  /* crop picture */
  $('body').on('click', '.js_crop-picture', function () {
    var id = $(this).data('id');
    var handle = $(this).data('handle');
    var values = $('#cropped-profile-picture').rcrop('getValues');
    $.post(api['users/image_crop'], { 'handle': handle, 'id': id, 'x': values.x, 'y': values.y, 'height': values.height, 'width': values.width }, function (response) {
      /* check the response */
      if (response.callback) {
        eval(response.callback);
      } else {
        modal_close();
        window.location.reload();
      }
    }, 'json')
      .fail(function () {
        show_error_modal();
      });
  });


  // handle picture position
  /* init position picture */
  $('body').on('click', '.js_init-position-picture', function () {
    init_picture_position();
  });
  /* save position picture */
  $('body').on('click', '.js_save-position-picture', function () {
    var handle = $('.js_init-position-picture').data('handle');
    var id = $('.js_init-position-picture').data('id');
    var position = $('.js_position-picture-val').val();
    $.post(api['users/image_position'], { 'handle': handle, 'id': id, 'position': position }, function (response) {
      /* check the response */
      if (response.callback) {
        eval(response.callback);
      } else {
        modal_close();
        window.location.reload();
      }
    }, 'json')
      .fail(function () {
        show_error_modal();
      });
  });
  /* cancel position picture */
  $('body').on('click', '.js_cancel-position-picture', function () {
    /* stop dragging cover image */
    $('.profile-cover-wrapper img').removeAttr("style").off('.position');
    /* show profile cover buttons */
    $('.profile-cover-change').show();
    $('.profile-cover-position').show();
    $('.profile-cover-delete').show();
    $('.profile-buttons-wrapper').show();
    /* show cropped cover */
    $('.js_position-cover-cropped').show();
    /* hide profile cover position buttons */
    $('.profile-cover-position-loader').hide();
    $('.profile-cover-position-buttons').hide();
  });
  /* crop picture */
  $('body').on('click', '.js_crop-cover', function () {
    var id = $(this).data('id');
    var handle = $(this).data('handle');
    var values = $('#cropped-profile-cover').rcrop('getValues');
    $.post(api['users/image_crop'], { 'type': 'cover', 'handle': handle, 'id': id, 'x': values.x, 'y': values.y, 'height': values.height, 'width': values.width }, function (response) {
      /* check the response */
      if (response.callback) {
        eval(response.callback);
      } else {
        modal_close();
        window.location.reload();
      }
    }, 'json')
      .fail(function () {
        show_error_modal();
      });
  });


  // handle recent searches
  $('body').on('click', '.js_clear-searches', function () {
    confirm(__['Delete'], __['Are you sure you want to delete this?'], function () {
      $.get(api['users/settings'], { 'edit': 'clear_search_log' }, function (response) {
        /* check the response */
        if (response.callback) {
          eval(response.callback);
        } else {
          window.location.reload();
        }
      }, 'json')
        .fail(function () {
          show_error_modal();
        });
    });
  });


  // handle data reseter
  $('body').on('show.bs.dropdown', '.js_live-requests, .js_live-messages, .js_live-notifications', function () {
    var _this = $(this);
    /* load the list the first time it opens */
    var scroller = _this.find(".js_scroller[data-lazy]");
    if (scroller.length > 0) {
      var data = { 'get': scroller.attr('data-lazy') };
      scroller.removeAttr('data-lazy');
      $.get(api['data/dropdown'], data, function (response) {
        if (response && response.html) {
          scroller.html($('<div>').html(response.html).find('.js_scroller').html());
        }
      }, 'json')
        .fail(function () {
          /* try again on the next open */
          scroller.attr('data-lazy', data['get']);
        });
    }
    var counter = parseInt(_this.find("span.counter").text()) || 0;
    if (counter > 0) {
      /* reset the client counter & hide it */
      _this.find("span.counter").text('0').hide();
      /* get the reset target */
      if (_this.hasClass('js_live-requests')) {
        var data = { 'reset': 'friend_requests' };
      } else if (_this.hasClass('js_live-messages')) {
        var data = { 'reset': 'messages' };
      } else if (_this.hasClass('js_live-notifications')) {
        var data = { 'reset': 'notifications' };
      }
      /* reset the server counter */
      $.post(api['data/reset'], data, function (response) {
        /* check the response */
        if (!response) return;
        /* check if there is a callback */
        if (response.callback) {
          eval(response.callback);
        }
      }, 'json')
        .fail(function () {
          show_error_modal();
        });
    }
  });


  // handle notifications
  /* notifications sound */
  $('body').on('click', '.js_notifications-sound-toggle', function () {
    notifications_sound = $(this).is(":checked");
    $.get(api['users/settings'], { 'edit': 'notifications_sound', 'notifications_sound': (notifications_sound) ? 1 : 0 }, function (response) {
      /* check the response */
      if (!response) return;
      /* check if there is a callback */
      if (response.callback) {
        eval(response.callback);
      }
    }, 'json')
      .fail(function () {
        show_error_modal();
      });
  });
  /* delete a notification */
  $('body').on('click', '.js_notification-deleter', function (e) {
    e.preventDefault();
    var _this = $(this);
    var id = _this.data('id');
    var notification = _this.parents('.feeds-action-item');
    confirm(__['Delete'], __['Are you sure you want to delete this?'], function () {
      $.post(api['users/notifications'], { 'handle': 'delete', 'id': id }, function (response) {
        /* check the response */
        if (response.callback) {
          eval(response.callback);
        } else {
          /* remove the notification */
          notification.slideUp();
          /* hide the confimation */
          modal_close();
        }
      }, 'json')
        .fail(function () {
          show_error_modal();
        });
    });
  });
  /* delete all notifications */
  $('body').on('click', '.js_delete-all-notifications', function () {
    confirm(__['Delete All'], __['Are you sure you want to do this?'], function () {
      $.post(api['users/notifications'], { 'handle': 'delete-all' }, function (response) {
        /* check the response */
        if (response.callback) {
          eval(response.callback);
        }
        /* reload the page */
        window.location.reload();
      }, 'json')
        .fail(function () {
          show_error_modal();
        });
    });
  });


  // handle connection
  /* friend request */
  $('body').on('click', '.js_friend-accept, .js_friend-decline', function () {
    var id = $(this).data('uid');
    var parent = $(this).parent();
    var accept = parent.find('.js_friend-accept');
    var decline = parent.find('.js_friend-decline');
    var _do = ($(this).hasClass('js_friend-accept')) ? 'friend-accept' : 'friend-decline';
    /* hide buttons & show loader */
    accept.hide();
    decline.hide();
    parent.append('<div class="loading loading-spinner loading-sm"></div>');
    /* post the request */
    $.post(api['users/connect'], { 'do': _do, 'id': id }, function (response) {
      if (response.callback) {
        parent.find('.loading-spinner').remove();
        accept.show();
        decline.show();
        eval(response.callback);
      } else {
        parent.find('.loading-spinner').remove();
        if (_do == 'friend-accept') {
          connection_button(accept.show(), 'friends');
        } else {
          accept.remove();
        }
        decline.remove();
      }
    }, "json")
      .fail(function () {
        parent.find('.loading-spinner').remove();
        accept.show();
        decline.show();
        show_error_modal();
      });
  });
  /* friend & unfriend */
  $('body').on('click', '.js_friend-add, .js_friend-cancel, .js_friend-remove', function () {
    var _this = $(this);
    var id = _this.data('uid');
    if (_this.hasClass('js_friend-add')) {
      var _do = 'friend-add';
    } else if (_this.hasClass('js_friend-cancel')) {
      var _do = 'friend-cancel';
    } else {
      var _do = 'friend-remove';
    }
    /* button loading */
    button_status(_this, "loading");
    /* post the request */
    $.post(api['users/connect'], { 'do': _do, 'id': id }, function (response) {
      /* button reset */
      button_status(_this, "reset");
      if (response.callback) {
        eval(response.callback);
      } else {
        connection_button(_this, (_do == 'friend-add') ? 'friend_sent' : 'friend_add');
      }
    }, "json")
      .fail(function () {
        /* button reset */
        button_status(_this, "reset");
        show_error_modal();
      });
  });
  /* follow & unfollow */
  $('body').on('click', '.js_follow, .js_unfollow', function () {
    var _this = $(this);
    var id = _this.data('uid');
    var _do = (_this.hasClass('js_follow')) ? 'follow' : 'unfollow';
    /* button loading */
    button_status(_this, "loading");
    /* post the request */
    $.post(api['users/connect'], { 'do': _do, 'id': id }, function (response) {
      /* button reset */
      button_status(_this, "reset");
      if (response.callback) {
        eval(response.callback);
      } else {
        connection_button(_this, (_do == 'follow') ? 'following' : 'follow');
      }
    }, "json")
      .fail(function () {
        /* button reset */
        button_status(_this, "reset");
        show_error_modal();
      });
  });
  /* favorite & unfavorite */
  $('body').on('click', '.js_friend-favorite, .js_friend-unfavorite', function () {
    var _this = $(this);
    var id = _this.data('uid');
    var _do = (_this.hasClass('js_friend-favorite')) ? 'favorite' : 'unfavorite';
    /* button loading */
    button_status(_this, "loading");
    /* post the request */
    $.post(api['users/connect'], { 'do': _do, 'id': id }, function (response) {
      /* button reset */
      button_status(_this, "reset");
      if (response.callback) {
        eval(response.callback);
      } else {
        if (_do == 'favorite') {
          _this.removeClass('js_friend-favorite').addClass('js_friend-unfavorite');
          _this.html('<span class="icon-[tabler--star-filled] size-4" aria-hidden="true"></span>');
        } else {
          _this.removeClass('js_friend-unfavorite').addClass('js_friend-favorite');
          _this.html('<span class="icon-[tabler--star] size-4" aria-hidden="true"></span>');
        }
      }
    }, "json")
      .fail(function () {
        /* button reset */
        button_status(_this, "reset");
        show_error_modal();
      });
  });
  /* block user */
  $('body').on('click', '.js_block-user', function () {
    var _this = $(this);
    var id = $(this).data('uid');
    confirm(__['Block User'], __['Are you sure you want to block this user?'], function () {
      /* button loading */
      button_status(_this, "loading");
      $.post(api['users/connect'], { 'do': 'block', 'id': id }, function (response) {
        /* button reset */
        button_status(_this, "reset");
        /* check the response */
        if (response.callback) {
          eval(response.callback);
        } else {
          window.location = site_path;
        }
      }, 'json')
        .fail(function () {
          /* button reset */
          button_status(_this, "reset");
          show_error_modal();
        });
    });
  });
  /* unblock user */
  $('body').on('click', '.js_unblock-user', function () {
    var _this = $(this);
    var id = $(this).data('uid');
    confirm(__['Unblock User'], __['Are you sure you want to unblock this user?'], function () {
      /* button loading */
      button_status(_this, "loading");
      $.post(api['users/connect'], { 'do': 'unblock', 'id': id }, function (response) {
        /* button reset */
        button_status(_this, "reset");
        /* check the response */
        if (response.callback) {
          eval(response.callback);
        } else {
          window.location.reload();
        }
      }, 'json')
        .fail(function () {
          /* button reset */
          button_status(_this, "reset");
          show_error_modal();
        });
    });
  });
  /* delete user */
  $('body').on('click', '.js_delete-user', function (e) {
    e.preventDefault();
    confirm(__['Delete'], __['Are you sure you want to delete your account?'], function () {
      $.post(api['users/delete'], { "password_check": $("#modal-password-check").val() }, function (response) {
        /* check the response */
        if (response.callback) {
          eval(response.callback);
        } else {
          window.location = site_path;
        }
      }, 'json')
        .fail(function () {
          show_error_modal();
        });
    }, true);
  });
  /* poke */
  $('body').on('click', '.js_poke', function () {
    var _this = $(this);
    var id = _this.data('id');
    var name = _this.data('name');
    /* post the request */
    $.post(api['users/connect'], { 'do': 'poke', 'id': id }, function (response) {
      /* remove poke */
      _this.remove();
      if (response.callback) {
        eval(response.callback);
      } else {
        modal('#modal-message', { title: __['Message'], message: __['You haved poked'] + " " + name });
      }
    }, "json")
      .fail(function () {
        show_error_modal();
      });
  });
  /* like & unlike page */
  $('body').on('click', '.js_like-page, .js_unlike-page', function () {
    var _this = $(this);
    var id = _this.data('id');
    var _do = (_this.hasClass('js_like-page')) ? 'page-like' : 'page-unlike';
    /* button loading */
    button_status(_this, "loading");
    /* post the request */
    $.post(api['users/connect'], { 'do': _do, 'id': id }, function (response) {
      /* button reset */
      button_status(_this, "reset");
      if (response.callback) {
        eval(response.callback);
      } else {
        connection_button(_this, (_do == 'page-like') ? 'page_liked' : 'page_like');
      }
    }, "json")
      .fail(function () {
        /* button reset */
        button_status(_this, "reset");
        show_error_modal();
      });
  });
  /* boost & unboost page */
  $('body').on('click', '.js_boost-page, .js_unboost-page', function () {
    var _this = $(this);
    var id = _this.data('id');
    var _do = (_this.hasClass('js_boost-page')) ? 'page-boost' : 'page-unboost';
    /* button loading */
    button_status(_this, "loading");
    /* post the request */
    $.post(api['users/connect'], { 'do': _do, 'id': id }, function (response) {
      /* button reset */
      button_status(_this, "reset");
      if (response.callback) {
        eval(response.callback);
      } else {
        if (_do == 'page-boost') {
          _this.removeClass('js_boost-page').addClass('js_unboost-page');
          _this.html('<span class="icon-[tabler--rocket] size-4" aria-hidden="true"></span>' + __['Unboost']);
        } else {
          _this.removeClass('js_unboost-page').addClass('js_boost-page');
          _this.html('<span class="icon-[tabler--rocket] size-4" aria-hidden="true"></span>' + __['Boost']);
        }
      }
    }, "json")
      .fail(function () {
        /* button reset */
        button_status(_this, "reset");
        show_error_modal();
      });
  });
  /* page admin addation & remove */
  $('body').on('click', '.js_page-admin-addation, .js_page-admin-remove', function () {
    var _this = $(this);
    var id = _this.data('id');
    var uid = _this.data('uid') || 0;
    var _do = (_this.hasClass('js_page-admin-addation')) ? 'page-admin-addation' : 'page-admin-remove';
    /* button loading */
    button_status(_this, "loading");
    /* post the request */
    $.post(api['users/connect'], { 'do': _do, 'id': id, 'uid': uid }, function (response) {
      /* button reset */
      button_status(_this, "reset");
      if (response.callback) {
        eval(response.callback);
      } else {
        connection_button(_this, (_do == 'page-admin-addation') ? 'page_admin_remove' : 'page_admin_add');
      }
    }, "json")
      .fail(function () {
        /* button reset */
        button_status(_this, "reset");
        show_error_modal();
      });
  });
  /* page member remove */
  $('body').on('click', '.js_page-member-remove', function () {
    var _this = $(this);
    var id = _this.data('id');
    var uid = _this.data('uid') || 0;
    /* button loading */
    button_status(_this, "loading");
    /* post the request */
    $.post(api['users/connect'], { 'do': 'page-member-remove', 'id': id, 'uid': uid }, function (response) {
      if (response.callback) {
        /* button reset */
        button_status(_this, "reset");
        eval(response.callback);
      } else {
        _this.closest('.feeds-item').slideUp();
      }
    }, "json")
      .fail(function () {
        /* button reset */
        button_status(_this, "reset");
        show_error_modal();
      });
  });
  /* group join & leave */
  $('body').on('click', '.js_join-group, .js_leave-group', function () {
    var _this = $(this);
    var id = _this.data('id');
    var privacy = _this.data('privacy');
    var _do = (_this.hasClass('js_join-group')) ? 'group-join' : 'group-leave';
    /* button loading */
    button_status(_this, "loading");
    /* post the request */
    $.post(api['users/connect'], { 'do': _do, 'id': id }, function (response) {
      /* button reset */
      button_status(_this, "reset");
      if (response.callback) {
        eval(response.callback);
      } else {
        if (_do == 'group-join') {
          connection_button(_this, (privacy == "public") ? 'group_joined' : 'group_pending');
        } else {
          connection_button(_this, 'group_join');
        }
      }
    }, "json")
      .fail(function () {
        /* button reset */
        button_status(_this, "reset");
        show_error_modal();
      });
  });
  /* group request (accept|decline) */
  $('body').on('click', '.js_group-request-accept, .js_group-request-decline', function () {
    var _this = $(this);
    var id = _this.data('id');
    var uid = _this.data('uid') || 0;
    var _do = (_this.hasClass('js_group-request-accept')) ? 'group-accept' : 'group-decline';
    /* button loading */
    button_status(_this, "loading");
    /* post the request */
    $.post(api['users/connect'], { 'do': _do, 'id': id, 'uid': uid }, function (response) {
      if (response.callback) {
        /* button reset */
        button_status(_this, "reset");
        eval(response.callback);
      } else {
        _this.closest('.feeds-item').slideUp();
      }
    }, "json")
      .fail(function () {
        /* button reset */
        button_status(_this, "reset");
        show_error_modal();
      });
  });
  /* boost & unboost group */
  $('body').on('click', '.js_boost-group, .js_unboost-group', function () {
    var _this = $(this);
    var id = _this.data('id');
    var _do = (_this.hasClass('js_boost-group')) ? 'group-boost' : 'group-unboost';
    /* button loading */
    button_status(_this, "loading");
    /* post the request */
    $.post(api['users/connect'], { 'do': _do, 'id': id }, function (response) {
      /* button reset */
      button_status(_this, "reset");
      if (response.callback) {
        eval(response.callback);
      } else {
        if (_do == 'group-boost') {
          _this.removeClass('js_boost-group').addClass('js_unboost-group');
          _this.html('<span class="icon-[tabler--rocket] size-4" aria-hidden="true"></span>' + __['Unboost']);
        } else {
          _this.removeClass('js_unboost-group').addClass('js_boost-group');
          _this.html('<span class="icon-[tabler--rocket] size-4" aria-hidden="true"></span>' + __['Boost']);
        }
      }
    }, "json")
      .fail(function () {
        /* button reset */
        button_status(_this, "reset");
        show_error_modal();
      });
  });
  /* group admin addation & remove */
  $('body').on('click', '.js_group-admin-addation, .js_group-admin-remove', function () {
    var _this = $(this);
    var id = _this.data('id');
    var uid = _this.data('uid') || 0;
    var _do = (_this.hasClass('js_group-admin-addation')) ? 'group-admin-addation' : 'group-admin-remove';
    /* button loading */
    button_status(_this, "loading");
    /* post the request */
    $.post(api['users/connect'], { 'do': _do, 'id': id, 'uid': uid }, function (response) {
      /* button reset */
      button_status(_this, "reset");
      if (response.callback) {
        eval(response.callback);
      } else {
        connection_button(_this, (_do == 'group-admin-addation') ? 'group_admin_remove' : 'group_admin_add');
      }
    }, "json")
      .fail(function () {
        /* button reset */
        button_status(_this, "reset");
        show_error_modal();
      });
  });
  /* group member remove */
  $('body').on('click', '.js_group-member-remove', function () {
    var _this = $(this);
    var id = _this.data('id');
    var uid = _this.data('uid') || 0;
    /* button loading */
    button_status(_this, "loading");
    /* post the request */
    $.post(api['users/connect'], { 'do': 'group-member-remove', 'id': id, 'uid': uid }, function (response) {
      if (response.callback) {
        /* button reset */
        button_status(_this, "reset");
        eval(response.callback);
      } else {
        _this.closest('.feeds-item').slideUp();
      }
    }, "json")
      .fail(function () {
        /* button reset */
        button_status(_this, "reset");
        show_error_modal();
      });
  });
  /* event go & ungo */
  $('body').on('click', '.js_go-event, .js_ungo-event', function () {
    var _this = $(this);
    var id = _this.data('id');
    var _do = (_this.hasClass('js_go-event')) ? 'event-go' : 'event-ungo';
    /* button loading */
    button_status(_this, "loading");
    /* post the request */
    $.post(api['users/connect'], { 'do': _do, 'id': id }, function (response) {
      /* button reset */
      button_status(_this, "reset");
      if (response.callback) {
        eval(response.callback);
      } else {
        connection_button(_this, (_do == 'event-go') ? 'event_going' : 'event_go');
      }
    }, "json")
      .fail(function () {
        /* button reset */
        button_status(_this, "reset");
        show_error_modal();
      });
  });
  /* event interest & uninterest */
  $('body').on('click', '.js_interest-event, .js_uninterest-event', function () {
    var _this = $(this);
    var id = _this.data('id');
    var _do = (_this.hasClass('js_interest-event')) ? 'event-interest' : 'event-uninterest';
    /* button loading */
    button_status(_this, "loading");
    /* post the request */
    $.post(api['users/connect'], { 'do': _do, 'id': id }, function (response) {
      /* button reset */
      button_status(_this, "reset");
      if (response.callback) {
        eval(response.callback);
      } else {
        connection_button(_this, (_do == 'event-interest') ? 'event_interested' : 'event_interest');
      }
    }, "json")
      .fail(function () {
        /* button reset */
        button_status(_this, "reset");
        show_error_modal();
      });
  });
  /* boost & unboost event */
  $('body').on('click', '.js_boost-event, .js_unboost-event', function () {
    var _this = $(this);
    var id = _this.data('id');
    var _do = (_this.hasClass('js_boost-event')) ? 'event-boost' : 'event-unboost';
    /* button loading */
    button_status(_this, "loading");
    /* post the request */
    $.post(api['users/connect'], { 'do': _do, 'id': id }, function (response) {
      /* button reset */
      button_status(_this, "reset");
      if (response.callback) {
        eval(response.callback);
      } else {
        if (_do == 'event-boost') {
          _this.removeClass('js_boost-event').addClass('js_unboost-event');
          _this.html('<span class="icon-[tabler--rocket] size-4" aria-hidden="true"></span>' + __['Unboost']);
        } else {
          _this.removeClass('js_unboost-event').addClass('js_boost-event');
          _this.html('<span class="icon-[tabler--rocket] size-4" aria-hidden="true"></span>' + __['Boost']);
        }
      }
    }, "json")
      .fail(function () {
        /* button reset */
        button_status(_this, "reset");
        show_error_modal();
      });
  });
  /* invite (page|group|event) */
  $('body').on('click', '.js_page-invite, .js_group-invite, .js_event-invite', function () {
    var _this = $(this);
    var id = _this.data('id');
    var uid = _this.data('uid') || 0;
    var _do = 'event-invite';
    if (_this.hasClass('js_page-invite')) {
      var _do = 'page-invite';
    } else if (_this.hasClass('js_group-invite')) {
      var _do = 'group-invite';
    } else {
      var _do = 'event-invite';
    }
    /* button loading */
    button_status(_this, "loading");
    /* post the request */
    $.post(api['users/connect'], { 'do': _do, 'id': id, 'uid': uid }, function (response) {
      if (response.callback) {
        /* button reset */
        button_status(_this, "reset");
        eval(response.callback);
      } else {
        _this.remove();
      }
    }, "json")
      .fail(function () {
        /* button reset */
        button_status(_this, "reset");
        show_error_modal();
      });
  });
  /* delete (page|group|event) */
  $('body').on('click', '.js_delete-page, .js_delete-group, .js_delete-event', function (e) {
    e.preventDefault();
    var id = $(this).data('id');
    if ($(this).hasClass('js_delete-page')) {
      var handle = 'page';
    } else if ($(this).hasClass('js_delete-group')) {
      var handle = 'group';
    } else if ($(this).hasClass('js_delete-event')) {
      var handle = 'event';
    }
    confirm(__['Delete'], __['Are you sure you want to delete this?'], function () {
      $.post(api['modules/delete'], { 'handle': handle, 'id': id }, function (response) {
        /* check the response */
        if (response.callback) {
          eval(response.callback);
        } else {
          window.location = site_path;
        }
      }, 'json')
        .fail(function () {
          show_error_modal();
        });
    });
  });


  // handle session
  /* delete a session */
  $('body').on('click', '.js_session-deleter', function () {
    var id = $(this).data('id');
    confirm(__['Delete'], __['Are you sure you want to delete this?'], function () {
      $.post(api['users/session'], { 'handle': 'session', 'id': id }, function (response) {
        /* check the response */
        if (response.callback) {
          eval(response.callback);
        } else {
          window.location.reload();
        }
      }, 'json')
        .fail(function () {
          show_error_modal();
        });
    });
  });
  /* delete all sessions */
  $('body').on('click', '.js_session-delete-all', function () {
    var id = $(this).data('id');
    confirm(__['Delete'], __['Are you sure you want to delete this?'], function () {
      $.post(api['users/session'], { 'handle': 'sessions' }, function (response) {
        /* check the response */
        if (response.callback) {
          eval(response.callback);
        } else {
          window.location.reload();
        }
      }, 'json')
        .fail(function () {
          show_error_modal();
        });
    });
  });


  // handle accounts swticher
  /* switch connected account */
  $('body').on('click', '.js_connected-account-switch', function () {

    var _this = $(this);
    var uid = _this.data('uid');
    /* check if this user is the current user */
    if (uid == user_id) {
      window.location.reload();
      return false;
    }
    /* init loading modal */
    modal('#modal-loading', {}, 'default');
    /* post the request */
    $.post(api['users/switch'], { 'do': 'switch', 'uid': uid }, function (response) {
      if (response.callback) {
        eval(response.callback);
      } else {
        window.location.reload();
      }
    }, "json")
      .fail(function () {
        show_error_modal();
      });
  });
  /* remove connected account */
  $('body').on('click', '.js_connected-account-remove', function () {
    var _this = $(this);
    var uid = _this.data('uid');
    /* button loading */
    button_status(_this, "loading");
    /* post the request */
    $.post(api['users/switch'], { 'do': 'remove', 'uid': uid }, function (response) {
      /* button reset */
      button_status(_this, "reset");
      if (response.callback) {
        eval(response.callback);
      } else {
        window.location.reload();
      }
    }, "json")
      .fail(function () {
        /* button reset */
        button_status(_this, "reset");
        show_error_modal();
      });
  });
  /* remove connected account */
  $('body').on('click', '.js_connected-account-revoke', function () {
    var _this = $(this);
    /* button loading */
    button_status(_this, "loading");
    /* post the request */
    $.post(api['users/switch'], { 'do': 'revoke' }, function (response) {
      /* button reset */
      button_status(_this, "reset");
      if (response.callback) {
        eval(response.callback);
      } else {
        window.location.reload();
      }
    }, "json")
      .fail(function () {
        /* button reset */
        button_status(_this, "reset");
        show_error_modal();
      });
  });


  // handle shopping
  /* add to cart */
  $('body').on('click', '.js_shopping-add-to-cart', function () {
    var _this = $(this);
    var id = _this.data('id');
    /* button loading */
    button_status(_this, "loading");
    /* post the request */
    $.post(api['users/shopping'], { 'do': 'add', 'id': id }, function (response) {
      /* button reset */
      button_status(_this, "reset");
      if (response.callback) {
        eval(response.callback);
      } else {
        /* go to shopping cart page */
        window.location = site_path + '/market/cart';
      }
    }, "json")
      .fail(function () {
        /* button reset */
        button_status(_this, "reset");
        show_error_modal();
      });
  });
  /* remove from cart */
  $('body').on('click', '.js_shopping-remove-from-cart', function () {
    var id = $(this).data('id');
    confirm(__['Delete'], __['Are you sure you want to delete this?'], function () {
      $.post(api['users/shopping'], { 'do': 'remove', 'id': id }, function (response) {
        /* check the response */
        if (response.callback) {
          eval(response.callback);
        } else {
          window.location.reload();
        }
      }, "json")
        .fail(function () {
          show_error_modal();
        });
    });
  });
  /* update cart */
  $('body').on('change', '.js_shopping-update-cart', function () {
    var _this = $(this);
    var id = _this.data('id');
    var quantity = _this.val();
    /* init loading modal */
    modal('#modal-loading', {}, 'default');
    /* post the request */
    $.post(api['users/shopping'], { 'do': 'update', 'id': id, 'quantity': quantity }, function (response) {
      /* check the response */
      if (response.callback) {
        eval(response.callback);
      } else {
        window.location.reload();
      }
    }, "json")
      .fail(function () {
        show_error_modal();
      });
  });
  /* checkout */
  $('body').on('click', '.js_shopping-checkout', function () {
    var _this = $(this);
    /* get shipping address */
    var shipping_address = $('.js_shipping-address:checked').val();
    /* check if a shipping address is selected */
    if (shipping_address == undefined) {
      $('#addresses-error').slideDown();
      return;
    }
    confirm_payment(function () {
      $.post(api['users/shopping'], { 'do': 'checkout', 'shipping_address': shipping_address }, function (response) {
        /* check the response */
        if (response.callback) {
          eval(response.callback);
        }
      }, "json")
        .fail(function () {
          show_error_modal();
        });
    });
  });
  /* html2canvas still rejects color-mix(); theme tokens also compute to oklch() */
  function invoice_color_fn_at(value, index) {
    var names = ['color-mix', 'oklch', 'oklab', 'lch', 'lab', 'color'];
    var i;
    for (i = 0; i < names.length; i++) {
      var name = names[i];
      if (value.substr(index, name.length + 1).toLowerCase() !== name + '(') {
        continue;
      }
      var prev = index > 0 ? value.charAt(index - 1) : '';
      if (prev && /[a-z-]/i.test(prev)) {
        continue;
      }
      return name;
    }
    return '';
  }
  function invoice_to_legacy_color(ctx, value) {
    var probe = '#010203';
    ctx.fillStyle = probe;
    try {
      ctx.fillStyle = value;
    } catch (e) {
      return '';
    }
    var resolved = ctx.fillStyle;
    if (!resolved || resolved === probe || /(?:oklch|oklab|color-mix|lch|lab|color)\(/i.test(resolved)) {
      return '';
    }
    return resolved;
  }
  function invoice_replace_modern_color(ctx, value) {
    var guard = 0;
    while (guard < 30 && /(?:oklch|oklab|color-mix|lch|lab|color)\(/i.test(value)) {
      guard++;
      var replaced = false;
      var i;
      for (i = 0; i < value.length; i++) {
        var name = invoice_color_fn_at(value, i);
        if (!name) {
          continue;
        }
        var open = i + name.length;
        var close = value.indexOf(')', open);
        if (close < 0) {
          return value;
        }
        if (value.slice(open + 1, close).indexOf('(') !== -1) {
          continue;
        }
        var resolved = invoice_to_legacy_color(ctx, value.slice(i, close + 1));
        if (!resolved) {
          return value;
        }
        value = value.slice(0, i) + resolved + value.slice(close + 1);
        replaced = true;
        break;
      }
      if (!replaced) {
        break;
      }
    }
    return value;
  }
  function invoice_flatten_colors(doc) {
    var canvas = doc.createElement('canvas');
    var ctx = canvas.getContext('2d');
    if (!ctx) {
      return;
    }
    var colorProps = ['color', 'backgroundColor', 'borderTopColor', 'borderRightColor', 'borderBottomColor', 'borderLeftColor', 'outlineColor', 'textDecorationColor', 'caretColor', 'columnRuleColor'];
    var complexProps = ['boxShadow', 'textShadow', 'backgroundImage'];
    var modern = /(?:oklch|oklab|color-mix|lch|lab|color)\(/i;
    var nodes = doc.querySelectorAll('*');
    var n, p, cs, current, next;
    for (n = 0; n < nodes.length; n++) {
      cs = doc.defaultView.getComputedStyle(nodes[n]);
      for (p = 0; p < colorProps.length; p++) {
        current = cs[colorProps[p]];
        if (!current || !modern.test(current)) {
          continue;
        }
        next = invoice_replace_modern_color(ctx, current);
        if (next && next !== current) {
          nodes[n].style[colorProps[p]] = next;
        }
      }
      for (p = 0; p < complexProps.length; p++) {
        current = cs[complexProps[p]];
        if (!current || current === 'none' || !modern.test(current)) {
          continue;
        }
        next = invoice_replace_modern_color(ctx, current);
        if (next && next !== current) {
          nodes[n].style[complexProps[p]] = next;
        }
      }
    }
  }
  /* download invoice */
  $('body').on('click', '.js_shopping-download-invoice', function () {
    var _this = $(this);
    var id = $(this).data('id');
    /* button loading */
    button_status(_this, "loading");
    /* post the request */
    $.getJSON(api['users/orders'], { 'do': 'invoice', 'id': id }, function (response) {
      /* button reset */
      button_status(_this, "reset");
      /* check the response */
      if (response.callback) {
        eval(response.callback);
      } else {
        $('body').append(response.invoice);
        var wrapper = document.getElementById('invoice-wrapper-' + id);
        var invoice = wrapper ? wrapper.querySelector('div') : null;
        var hash = invoice ? (invoice.id || '').replace(/^invoice-/, '') : id;
        if (!invoice || typeof html2pdf !== 'function') {
          if (wrapper) {
            wrapper.remove();
          }
          return;
        }
        html2pdf().from(invoice).set({
          margin: 0.5,
          filename: 'invoice-' + hash + '.pdf',
          html2canvas: {
            backgroundColor: '#ffffff',
            onclone: function (doc) {
              invoice_flatten_colors(doc);
            }
          },
          jsPDF: { unit: 'in', format: 'letter', orientation: 'portrait' }
        }).save().finally(function () {
          if (wrapper) {
            wrapper.remove();
          }
        });
      }
    }, "json")
      .fail(function () {
        /* button reset */
        button_status(_this, "reset");
        show_error_modal();
      });
  });
  /* delete address */
  $('body').on('click', '.js_address-deleter', function () {
    var id = $(this).data('id');
    confirm(__['Delete'], __['Are you sure you want to delete this?'], function () {
      $.getJSON(api['users/addresses'], { 'do': "delete", 'id': id }, function (response) {
        /* check the response */
        if (response.callback) {
          eval(response.callback);
        } else {
          window.location.reload();
        }
      });
    });
  });


  // handle adblocker detector
  if (adblock_detector) {
    $(window).on('load', function () {
      /* bait element */
      var bait = $('<ins class="adsbygoogle adsbox ad-banner ad-slot ad-unit ad-placement banner-ad text-ad textAd sponsored-ad pub_300x250 pub_728x90" data-ad-client="ca-pub-0000000000000000" aria-hidden="true">&nbsp;</ins>').css({ display: 'block', position: 'absolute', top: '-10000px', left: '-10000px', width: '1px', height: '1px' }).appendTo('body');
      $.get('https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js', function () {
        bait.remove();
      }).fail(function () {
        /* confirm the bait was hidden */
        setTimeout(function () {
          var bait_hidden = !document.body.contains(bait[0]) || bait[0].offsetHeight === 0 || bait.css('display') === 'none' || bait.css('visibility') === 'hidden';
          bait.remove();
          if (!bait_hidden) {
            return;
          }
          if ($(".adblock-warning-message").length > 0) {
            $(".adblock-warning-message").slideDown();
            return;
          }
          $(render_template("#adblock-detector")).appendTo('body').show();
        }, 1000);
      });
    });
  }


  // handle developers
  /* oauth app */
  $('body').on('click', '.js_developers-oauth-app', function () {
    var id = $(this).data('id');
    $.post(api['developers/app'], { 'do': 'oauth', 'id': id }, function (response) {
      /* check the response */
      if (response.callback) {
        eval(response.callback);
      } else {
        window.location = response.redirect_url
      }
    }, 'json')
      .fail(function () {
        show_error_modal();
      });
  });
  /* delete app */
  $('body').on('click', '.js_developers-delete-app', function () {
    var id = $(this).data('id');
    confirm(__['Delete'], __['Are you sure you want to delete this?'], function () {
      $.post(api['developers/app'], { 'do': 'delete', 'id': id }, function (response) {
        /* check the response */
        if (response.callback) {
          eval(response.callback);
        } else {
          window.location.reload();
        }
      }, 'json')
        .fail(function () {
          show_error_modal();
        });
    });
  });
  /* delete user app */
  $('body').on('click', '.js_delete-user-app', function () {
    var id = $(this).data('id');
    confirm(__['Delete'], __['Are you sure you want to delete this?'], function () {
      $.post(api['users/connect'], { 'do': 'delete-app', 'id': id }, function (response) {
        /* check the response */
        if (response.callback) {
          eval(response.callback);
        } else {
          window.location.reload();
        }
      }, 'json')
        .fail(function () {
          show_error_modal();
        });
    });
  });


  // handle login as
  $('body').on('click', '.js_login-as', function () {
    var id = $(this).data('id');
    var handle = $(this).data('handle');
    confirm(__['Login As'], (handle == "connect") ? __['Are you sure you want to login as this user?'] : __['Are you sure you want to switch back to your account?'], function () {
      $.post(api['users/login_as'], { 'handle': handle, 'id': id }, function (response) {
        /* check the response */
        if (response.callback) {
          eval(response.callback);
        } else {
          window.location = site_path;
        }
      }, 'json')
        .fail(function () {
          show_error_modal();
        });
    });
  });


  // handle games
  /* full screen game */
  $('body').on('click', '.js_game-fullscreen', function () {
    $('#game-area')[0].requestFullscreen();
  });


  // handle shortcuts
  var shortcuts_timer = null;
  function shortcuts_restore() {
    $('.js_shortcuts-staged input').each(function () {
      $('.js_shortcuts-list li[data-key="' + $(this).attr('data-key') + '"] .js_shortcut-state[value="' + this.value + '"]').prop('checked', true);
    });
  }
  /* stage the state */
  $('body').on('change', '.js_shortcut-state', function () {
    var key = $(this).closest('li').attr('data-key');
    var staged = $('.js_shortcuts-staged');
    var input = staged.find('input[data-key="' + key + '"]');
    if (!input.length) {
      input = $('<input type="hidden">').attr({ 'name': 'states[' + key + ']', 'data-key': key }).appendTo(staged);
    }
    input.val(this.value);
  });
  /* search */
  $('body').on('input', '.js_shortcuts-search', function () {
    var input = $(this);
    var list = input.closest('.js_shortcuts').find('.js_shortcuts-list');
    var query = input.val().trim();
    clearTimeout(shortcuts_timer);
    shortcuts_timer = setTimeout(function () {
      $.getJSON(ajax_path + 'users/shortcuts.php', { 'do': 'search', 'query': query }, function (response) {
        if (response.callback) {
          eval(response.callback);
          return;
        }
        if (input.val().trim() != query) {
          return;
        }
        list.html(response.html);
        shortcuts_restore();
      });
    }, 200);
  });
  /* load more */
  $(document).ajaxComplete(function (event, xhr, settings) {
    if (settings.url == api['data/load'] && $('.js_shortcuts-staged input').length > 0) {
      shortcuts_restore();
    }
  });


  // handle panic mode
  $('body').on('click', '#panic-mode-toggle', function () {
    /* toggle panic-mode-content */
    $('#panic-mode-content').toggle();
  });

});
