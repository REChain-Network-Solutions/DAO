/**
 * site header js
 * 
 * @package Sngine
 * @author Zamblek
 */

// site live dropdowns
function site_live_dropdowns() {
  var selector = '.js_site-topbar-chrome .js_live-requests, .js_site-topbar-chrome .js_live-messages, .js_site-topbar-chrome .js_live-notifications';

  function bind(el) {
    if (el.dataset.siteLiveBound === '1') {
      return;
    }
    var HSDropdown = window.HSDropdown;
    if (!HSDropdown) {
      return;
    }
    var found = HSDropdown.getInstance(el, true);
    var instance = (found && found.element) ? found.element : found;
    if (!instance || typeof instance.on !== 'function') {
      return;
    }
    el.dataset.siteLiveBound = '1';
    instance.on('open', function () {
      if (window.jQuery) {
        window.jQuery(el).trigger('show.bs.dropdown');
      }
    });
  }

  function bind_all() {
    document.querySelectorAll(selector).forEach(bind);
  }

  if (document.readyState === 'complete') {
    bind_all();
  } else {
    window.addEventListener('load', bind_all);
  }
}


// site search palette
function site_search_palette() {
  var palette = document.getElementById('site-palette');
  var input = document.getElementById('site-palette-input');
  var results = document.getElementById('site-palette-results');
  if (!palette || !input || !results) {
    return;
  }
  var clear = palette.querySelector('.js_site-palette-clear');
  var chip = palette.querySelector('.js_site-palette-chip');
  var chip_remove = palette.querySelector('.js_site-palette-chip-remove');
  var chip_label = chip ? chip.querySelector('[data-chip-label]') : null;
  var placeholder_default = input.getAttribute('placeholder') || '';
  var trigger = document.getElementById('site-palette-trigger');
  var logged_in = palette.dataset.loggedIn === '1';
  var label_all = palette.dataset.labelAll || 'See All Results';
  var label_advanced = palette.dataset.labelAdvanced || 'Advanced Search';
  var label_search_for = palette.dataset.labelSearchFor || 'Search for';
  var label_recent = palette.dataset.labelRecent || 'Recent Searches';
  var label_empty = palette.dataset.labelEmpty || 'No results found';
  var label_settings = palette.dataset.labelSettings || 'Settings';
  var label_commands = palette.dataset.labelCommands || 'Commands';
  var label_remove = palette.dataset.labelRemove || 'Remove from recent';
  var label_clear_all = palette.dataset.labelClearAll || 'Clear All';
  var search_url = window.site_path + '/search/';
  var result_limit = 50;
  var timer = null;
  var request_id = 0;
  var rows = [];
  var active = -1;
  var settings_index = [];
  var settings_loading = null;
  var recents = [];
  var command = null;

  /* get recent searches */
  var recents_data = document.getElementById('site-palette-recents-data');
  if (recents_data) {
    recents_data.querySelectorAll('[data-log-id]').forEach(function (node) {
      recents.push({
        log_id: node.dataset.logId,
        label: node.dataset.label || '',
        url: node.dataset.url || '',
        picture: node.dataset.picture || ''
      });
    });
  }

  function plugin_instance(Ctor, selector) {
    if (!Ctor || typeof Ctor.getInstance !== 'function') {
      return null;
    }
    /* FlyonUI builds its instance collections on load; before that getInstance() throws */
    var found;
    try {
      found = Ctor.getInstance(selector, true);
    } catch (e) {
      return null;
    }
    return (found && found.element) ? found.element : found;
  }

  function overlay_instance() {
    return plugin_instance(window.HSOverlay, '#site-palette');
  }

  function is_open() {
    return palette.classList.contains('open');
  }

  function from_tpl(id) {
    var tpl = document.getElementById(id);
    return tpl ? tpl.content.firstElementChild.cloneNode(true) : null;
  }

  /* get hashtag */
  function hashtag_of(query) {
    var hashtags = query.match(/#(\w+)/i);
    return (hashtags !== null) ? hashtags[1] : '';
  }

  function query_url(query) {
    var hashtag = hashtag_of(query);
    return (hashtag) ? search_url + 'hashtag/' + hashtag : search_url + query;
  }

  function normalize(value) {
    return value.toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g, '');
  }

  function subsequence(haystack, needle) {
    var i = 0;
    var gaps = 0;
    var last = -1;
    for (var c = 0; c < needle.length; c++) {
      i = haystack.indexOf(needle[c], i);
      if (i === -1) {
        return 0;
      }
      if (last !== -1) {
        gaps += i - last - 1;
      }
      last = i;
      i++;
    }
    return Math.max(1, 200 - gaps);
  }

  function match(field, needle) {
    if (!field) {
      return 0;
    }
    if (field === needle) {
      return 1000;
    }
    if (field.indexOf(needle) === 0) {
      return 800;
    }
    if (field.indexOf(' ' + needle) !== -1) {
      return 600;
    }
    if (field.indexOf(needle) !== -1) {
      return 400;
    }
    return subsequence(field, needle);
  }

  function score_one(item, needle) {
    var best = match(normalize(item.label), needle);
    var pair = item.parent ? match(normalize(item.parent + ' ' + item.label), needle) : 0;
    var group = Math.floor(match(normalize(item.section || ''), needle) / 3);
    var help = item.help ? Math.floor(match(normalize(item.help), needle) / 4) : 0;
    return Math.max(best, pair, group, help);
  }

  function has_word(item, word) {
    return match(normalize(item.label), word) >= 400 ||
      (item.parent && match(normalize(item.parent + ' ' + item.label), word) >= 400) ||
      match(normalize(item.section || ''), word) >= 400 ||
      (item.help && match(normalize(item.help), word) >= 400);
  }

  function score(item, needle) {
    var words = needle.split(/\s+/).filter(Boolean);
    if (words.length < 2) {
      return score_one(item, needle);
    }
    var total = score_one(item, needle) * words.length;
    for (var i = 0; i < words.length; i++) {
      if (!has_word(item, words[i])) {
        return 0;
      }
      total += score_one(item, words[i]);
    }
    return total;
  }

  function commands() {
    if (!logged_in) {
      return [];
    }
    return [{
      label: label_settings,
      badge: '/settings',
      command: '/settings',
      url: window.site_path + '/settings',
      fill: '/settings',
      help: label_settings,
      section: label_commands
    }];
  }

  /* get settings index */
  function load_settings_index() {
    if (!logged_in) {
      return Promise.resolve();
    }
    if (settings_loading) {
      return settings_loading;
    }
    if (!window.fetch || !window.ajax_path) {
      return Promise.resolve();
    }
    settings_loading = fetch(window.ajax_path + 'users/settings_search_index.php', {
      credentials: 'same-origin',
      headers: { 'X-Requested-With': 'XMLHttpRequest' }
    })
      .then(function (response) {
        var type = response.headers.get('content-type') || '';
        if (!response.ok || type.indexOf('json') === -1) {
          throw new Error('settings index unavailable');
        }
        return response.json();
      })
      .then(function (data) {
        settings_index = (Array.isArray(data) ? data : []).map(function (field) {
          return {
            label: field.label,
            help: field.help,
            url: field.url,
            parent: field.page + (field.section ? ' › ' + field.section : ''),
            section: label_settings
          };
        });
      })
      .catch(function () {
        settings_index = [];
      });
    return settings_loading;
  }

  function bind_row(row, position) {
    row.classList.add('js_site-palette-item');
    row.setAttribute('role', 'option');
    row.setAttribute('aria-selected', 'false');
    row.id = 'site-palette-row-' + position;
    row.dataset.index = String(position);
    if (row.dataset.url === undefined) {
      row.dataset.url = row.getAttribute('href') || '';
    }
    rows.push(row);
    return row;
  }

  function build_heading(text, clearable) {
    var heading = from_tpl('site-palette-heading-tpl');
    if (!heading) {
      heading = document.createElement('div');
      heading.className = 'px-2.5 py-1.5 text-xs font-medium text-base-content/50';
      heading.textContent = text;
      return heading;
    }
    heading.querySelector('[data-title]').textContent = text;
    var button = heading.querySelector('[data-clear]');
    if (clearable && button) {
      button.hidden = false;
      button.classList.remove('hidden');
      button.textContent = label_clear_all;
    }
    return heading;
  }

  function build_item(item) {
    var row = from_tpl(item.picture ? 'site-palette-recent-tpl' : (item.search ? 'site-palette-search-tpl' : 'site-palette-item-tpl'));
    if (!row) {
      return null;
    }
    var link = row.classList.contains('js_site-palette-item') ? row : row.querySelector('.js_site-palette-item');
    link.href = item.url;
    link.dataset.url = item.url;
    if (item.recent) {
      link.dataset.recent = '1';
      link.dataset.logId = item.log_id;
    }
    if (item.fill) {
      link.dataset.fill = item.fill;
    }
    var label = row.querySelector('[data-label]');
    if (label) {
      label.textContent = item.label;
    }
    var picture = row.querySelector('[data-picture]');
    if (picture && item.picture) {
      picture.src = item.picture;
      picture.classList.remove('hidden');
    }
    var icon = row.querySelector('[data-icon]');
    if (icon && item.picture) {
      icon.remove();
    }
    var crumb = row.querySelector('[data-crumb]');
    if (crumb && item.parent) {
      crumb.textContent = item.parent;
      crumb.classList.remove('hidden');
    }
    var badge = row.querySelector('[data-badge]');
    if (badge && item.badge) {
      badge.textContent = item.badge;
      badge.classList.remove('hidden');
    }
    var remove = row.querySelector('.js_site-palette-remove');
    if (remove) {
      remove.dataset.logId = item.log_id || '';
      remove.setAttribute('aria-label', label_remove);
      remove.title = label_remove;
    }
    return row;
  }

  function append_group(title, items, removable) {
    if (!items.length) {
      return;
    }
    var group = document.createElement('div');
    group.appendChild(build_heading(title, removable));
    items.forEach(function (item) {
      var node = build_item(item);
      if (!node) {
        return;
      }
      var link = node.classList.contains('js_site-palette-item') ? node : node.querySelector('.js_site-palette-item');
      bind_row(link, rows.length);
      group.appendChild(node);
    });
    results.appendChild(group);
  }

  function append_html(html) {
    results.innerHTML = html;
    Array.from(results.querySelectorAll('.js_site-palette-item')).forEach(function (row) {
      bind_row(row, rows.length);
    });
  }

  function append_empty() {
    var empty = from_tpl('site-palette-empty-tpl');
    if (empty) {
      empty.textContent = label_empty;
      results.appendChild(empty);
    }
  }

  /* highlight row */
  function set_active(position) {
    if (active > -1 && rows[active]) {
      rows[active].classList.remove('dropdown-active', 'bg-base-content/5');
      rows[active].setAttribute('aria-selected', 'false');
    }
    active = position;
    if (active > -1 && rows[active]) {
      rows[active].classList.add('dropdown-active', 'bg-base-content/5');
      rows[active].setAttribute('aria-selected', 'true');
      rows[active].scrollIntoView({ block: 'nearest' });
      input.setAttribute('aria-activedescendant', rows[active].id);
    } else {
      input.removeAttribute('aria-activedescendant');
    }
  }

  function move(step) {
    if (!rows.length) {
      return;
    }
    set_active((active + step + rows.length) % rows.length);
  }

  function settings_query(query) {
    if (!logged_in || query.charAt(0) !== '/') {
      return null;
    }
    var rest = query.slice(1);
    var lower = rest.toLowerCase();
    if (lower === 'settings') {
      return '';
    }
    if (lower.indexOf('settings ') === 0) {
      return rest.slice(9);
    }
    return null;
  }

  /* set /settings chip */
  function set_command(id, rest) {
    var item = commands().filter(function (row) {
      return (row.command || row.fill) === '/' + id || row.fill === '/' + id;
    })[0];
    command = id;
    if (chip) {
      chip.hidden = false;
      chip.classList.remove('hidden');
    }
    if (chip_label) {
      chip_label.textContent = (item && item.badge) ? item.badge : '/' + id;
    }
    input.value = rest || '';
    input.setAttribute('placeholder', label_settings);
    render();
  }

  /* remove /settings chip */
  function clear_command() {
    command = null;
    if (chip) {
      chip.hidden = true;
      chip.classList.add('hidden');
    }
    input.setAttribute('placeholder', placeholder_default);
  }

  function take_typed_command(query) {
    var needle = settings_query(query);
    if (needle === null) {
      return false;
    }
    set_command('settings', needle);
    return true;
  }

  function matched_settings(needle) {
    if (!needle) {
      return settings_index.slice(0, result_limit);
    }
    var matches = settings_index.map(function (item, position) {
      return { item: item, score: score(item, needle), position: position };
    }).filter(function (row) {
      return row.score > 0;
    });
    matches.sort(function (a, b) {
      return b.score - a.score || a.position - b.position;
    });
    return matches.slice(0, result_limit).map(function (row) {
      return row.item;
    });
  }

  function matched_commands(query) {
    var needle = normalize(query);
    return commands().filter(function (item) {
      var command = normalize(item.command || item.badge || item.label);
      return !needle || match(command, needle) >= 400 || match(normalize(item.label), needle) >= 400 || match(command, needle.slice(1)) >= 400;
    });
  }

  /* render results */
  function render() {
    var query = input.value.trim();
    results.innerHTML = '';
    rows = [];
    active = -1;
    if (clear) {
      clear.hidden = !query && !command;
    }
    if (command === 'settings') {
      var settings = matched_settings(normalize(query));
      if (!settings.length) {
        append_empty();
      } else {
        append_group(label_settings, settings);
      }
    } else if (!query) {
      append_group(label_recent, recents.map(function (item) {
        return {
          label: item.label,
          url: item.url,
          picture: item.picture,
          log_id: item.log_id,
          recent: true
        };
      }), recents.length > 0);
      append_group(label_commands, commands());
      append_group(label_advanced, [{
        label: label_advanced,
        url: search_url,
        search: true
      }]);
    } else if (query.charAt(0) === '/') {
      var list = matched_commands(query);
      if (!list.length) {
        append_empty();
      } else {
        append_group(label_commands, list);
      }
    } else {
      return false;
    }
    results.scrollTop = 0;
    if (rows.length) {
      set_active(0);
    }
    return true;
  }

  /* get live results */
  function search(query) {
    var current = ++request_id;
    var hashtag = hashtag_of(query);
    if (hashtag) {
      results.innerHTML = '';
      rows = [];
      active = -1;
      append_group(label_search_for, [{
        label: label_search_for + ' #' + hashtag,
        url: query_url(query),
        search: true
      }]);
      if (rows.length) {
        set_active(0);
      }
      return;
    }
    $.post(api['data/search'], { 'query': query }, function (response) {
      if (current !== request_id) {
        return;
      }
      /* check the response */
      if (response.callback) {
        eval(response.callback);
      } else if (response.results) {
        results.innerHTML = '';
        rows = [];
        active = -1;
        append_html(response.results);
        if (rows.length) {
          set_active(0);
        }
      } else {
        results.innerHTML = '';
        rows = [];
        active = -1;
        append_group(label_all, [{
          label: label_all,
          url: query_url(query),
          search: true
        }]);
        if (rows.length) {
          set_active(0);
        }
      }
    }, 'json')
      .fail(function () {
        if (current !== request_id) {
          return;
        }
        results.innerHTML = '';
        rows = [];
        active = -1;
        append_group(label_all, [{
          label: label_all,
          url: query_url(query),
          search: true
        }]);
        if (rows.length) {
          set_active(0);
        }
      });
  }

  function go(row) {
    if (!row) {
      return;
    }
    if (row.dataset.fill) {
      set_command(row.dataset.fill.replace(/^\//, ''), '');
      input.focus();
      return;
    }
    window.location = row.getAttribute('href');
  }

  function close_palette() {
    var overlay = overlay_instance();
    if (overlay && typeof overlay.close === 'function') {
      overlay.close();
    } else {
      palette.classList.add('hidden');
      palette.classList.remove('open');
    }
    if (trigger) {
      trigger.focus();
    }
  }

  function open_palette() {
    var overlay = overlay_instance();
    if (overlay && typeof overlay.open === 'function') {
      overlay.open();
    } else {
      palette.classList.remove('hidden');
      palette.classList.add('open');
    }
  }

  /* delete recent search */
  function remove_recent(log_id) {
    recents = recents.filter(function (item) {
      return String(item.log_id) !== String(log_id);
    });
    if (typeof api !== 'undefined' && api['users/settings']) {
      $.get(api['users/settings'], { 'edit': 'delete_search_log', 'id': log_id });
    }
    var position = active;
    render();
    if (rows.length) {
      set_active(Math.min(position, rows.length - 1));
    }
    input.focus();
  }

  /* clear recent searches */
  function clear_recents() {
    recents = [];
    if (typeof api !== 'undefined' && api['users/settings']) {
      $.get(api['users/settings'], { 'edit': 'clear_search_log' });
    }
    render();
    input.focus();
  }

  function on_open() {
    input.value = '';
    clear_command();
    render();
    load_settings_index().then(function () {
      if (is_open() && (command === 'settings' || input.value.trim().charAt(0) === '/')) {
        render();
      }
    });
    input.focus();
  }

  /* handle input */
  input.addEventListener('input', function () {
    var query = input.value;
    clearTimeout(timer);
    if (!command && take_typed_command(query.trim())) {
      request_id++;
      return;
    }
    if (render()) {
      request_id++;
      return;
    }
    request_id++;
    timer = setTimeout(function () {
      search(query.trim());
    }, 250);
  });

  /* handle chip remove */
  if (chip_remove) {
    chip_remove.addEventListener('mousedown', function (e) {
      e.preventDefault();
    });
    chip_remove.addEventListener('click', function (e) {
      e.preventDefault();
      e.stopPropagation();
      input.value = '';
      clear_command();
      render();
      input.focus();
    });
  }

  /* handle clear */
  if (clear) {
    clear.addEventListener('click', function () {
      input.value = '';
      if (command) {
        clear_command();
      }
      render();
      input.focus();
    });
  }

  /* handle results */
  results.addEventListener('click', function (e) {
    var clear_all = e.target.closest('.js_site-palette-clear-all');
    if (clear_all) {
      e.preventDefault();
      e.stopPropagation();
      clear_recents();
      return;
    }
    var remove = e.target.closest('.js_site-palette-remove');
    if (remove) {
      e.preventDefault();
      e.stopPropagation();
      remove_recent(remove.dataset.logId);
      return;
    }
    var row = e.target.closest('.js_site-palette-item');
    if (row) {
      e.preventDefault();
      go(row);
    }
  });
  results.addEventListener('mousedown', function (e) {
    if (e.target.closest('.js_site-palette-remove') || e.target.closest('.js_site-palette-clear-all')) {
      e.preventDefault();
    }
  });
  results.addEventListener('mousemove', function (e) {
    var row = e.target.closest('.js_site-palette-item');
    if (row && rows[active] !== row) {
      set_active(Number(row.dataset.index));
    }
  });

  /* handle keys */
  palette.addEventListener('keydown', function (e) {
    if (e.key === 'ArrowDown') {
      e.preventDefault();
      move(1);
    } else if (e.key === 'ArrowUp') {
      e.preventDefault();
      move(-1);
    } else if (e.key === 'Home') {
      e.preventDefault();
      set_active(0);
    } else if (e.key === 'End') {
      e.preventDefault();
      set_active(rows.length - 1);
    } else if (e.key === 'Enter') {
      e.preventDefault();
      go(rows[active]);
    } else if ((e.key === 'Delete' || e.key === 'Backspace') && command && !input.value) {
      e.preventDefault();
      clear_command();
      render();
    } else if ((e.key === 'Delete' || e.key === 'Backspace') && rows[active] && rows[active].dataset.recent && !input.value) {
      e.preventDefault();
      remove_recent(rows[active].dataset.logId);
    } else if (e.key === 'Escape') {
      e.preventDefault();
      close_palette();
    }
  });

  /* handle ⌘K / Ctrl+K */
  document.addEventListener('keydown', function (e) {
    if (!(e.metaKey || e.ctrlKey) || e.altKey || !e.key || e.key.toLowerCase() !== 'k') {
      return;
    }
    e.preventDefault();
    if (is_open()) {
      close_palette();
    } else {
      open_palette();
      on_open();
    }
  });

  palette.addEventListener('open.overlay', on_open);
  document.querySelectorAll('[data-overlay="#site-palette"]').forEach(function (el) {
    el.addEventListener('click', on_open);
  });
  input.addEventListener('focus', function () {
    if (!command && !input.value.trim() && !rows.length) {
      render();
    }
  });

  function bind_overlay() {
    var overlay = overlay_instance();
    if (!overlay || overlay._sitePaletteBound) {
      return;
    }
    overlay._sitePaletteBound = true;
    if (typeof overlay.on === 'function') {
      overlay.on('open', on_open);
    }
  }

  bind_overlay();
  if (document.readyState !== 'complete') {
    window.addEventListener('load', bind_overlay);
  }
}


// settings goto
function site_settings_goto() {
  var id = new URLSearchParams(window.location.search).get('goto');
  if (!id) {
    return;
  }
  var field = document.getElementById(id);
  if (!field) {
    return;
  }
  /* scroll to the field */
  window.requestAnimationFrame(function () {
    var row = field.closest('section, .p-4, .w-full') || field;
    row.scrollIntoView({ behavior: 'smooth', block: 'center' });
    row.classList.add('bg-warning/30', 'transition-colors', 'duration-500', 'rounded-xl');
    setTimeout(function () {
      row.classList.remove('bg-warning/30');
    }, 2000);
  });
  /* remove goto from the url */
  var params = new URLSearchParams(window.location.search);
  params.delete('goto');
  var query = params.toString();
  window.history.replaceState(null, '', window.location.pathname + (query ? '?' + query : '') + window.location.hash);
}


// site bottom bar
function site_bottom_bar() {
  var bar = document.querySelector('.js_site-bottom-bar');
  if (!bar) {
    return;
  }
  var last = Math.max(window.scrollY, 0);
  window.addEventListener('scroll', function () {
    var current = Math.max(window.scrollY, 0);
    var delta = current - last;
    if (Math.abs(delta) < 8) {
      return;
    }
    last = current;
    /* keep the bar while one of its menus is open */
    if (bar.querySelector('.dropdown.open')) {
      return;
    }
    bar.dataset.hidden = (delta > 0 && current > 64) ? 'true' : 'false';
  }, { passive: true });
}


// init
site_live_dropdowns();
site_search_palette();
site_settings_goto();
site_bottom_bar();
