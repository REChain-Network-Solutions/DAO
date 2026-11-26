/**
 * admin layout js
 * 
 * @package Sngine
 * @author Zamblek
 */

// admin sidebar
function admin_sidebar() {
  var sidebar = document.getElementById('layout-toggle');
  var toggle = document.getElementById('admin-sidebar-toggle');
  var nav = document.getElementById('admin-nav');
  if (!sidebar || !toggle || !nav) {
    return;
  }
  var root = document.documentElement;
  var desktop = window.matchMedia('(min-width: 1024px)');
  var scroll_area = sidebar.querySelector('.js_admin-sidebar-scroll');
  if (!scroll_area) {
    return;
  }
  var flyout = null;
  var flyout_trigger = null;
  var tooltip = null;
  var items = Array.from(nav.children);
  var triggers = items.map(function (item) {
    return item.querySelector(':scope > a, :scope > button');
  }).filter(Boolean);
  var groups = triggers.filter(function (trigger) {
    return trigger.classList.contains('accordion-toggle');
  });
  var reopen = [];
  var current_link = nav.querySelector('a.menu-active');
  var current_group = current_link ? current_link.closest('.accordion-item') : nav.querySelector(':scope > .accordion-item.active');
  var scroll_request = 0;

  // collapsed rail (desktop only)
  function rail_mode() {
    return desktop.matches && root.dataset.adminSidebar === 'collapsed';
  }

  // align current section
  function reveal_current() {
    if (!scroll_area.clientHeight || (!desktop.matches && !sidebar.classList.contains('open'))) {
      return;
    }
    var target = current_group ? current_group.querySelector(':scope > .accordion-toggle') : current_link;
    if (!target || !target.getClientRects().length) {
      return;
    }
    var area = scroll_area.getBoundingClientRect();
    var rect = target.getBoundingClientRect();
    var top = area.top + scroll_area.clientTop;
    var offset = rect.top - top - 12;
    if (offset) {
      scroll_area.scrollTo({
        top: Math.max(0, Math.min(scroll_area.scrollTop + offset, scroll_area.scrollHeight - scroll_area.clientHeight)),
        behavior: window.matchMedia('(prefers-reduced-motion: reduce)').matches ? 'instant' : 'smooth'
      });
    }
  }

  // wait for sidebar layout
  function schedule_reveal() {
    var request = ++scroll_request;
    window.requestAnimationFrame(function () {
      window.requestAnimationFrame(function () {
        if (request !== scroll_request) {
          return;
        }
        var transitions = sidebar.getAnimations({ subtree: true }).filter(function (animation) {
          return ['width', 'height', 'transform', 'translate'].includes(animation.transitionProperty);
        });
        Promise.all(transitions.map(function (animation) {
          return animation.finished.catch(function () { });
        })).then(function () {
          window.requestAnimationFrame(function () {
            if (request === scroll_request) {
              reveal_current();
            }
          });
        });
      });
    });
  }

  // label for trigger
  function label_for(trigger) {
    var grow = trigger.querySelector('.grow');
    return (grow && grow.textContent.trim()) || trigger.getAttribute('aria-label') || '';
  }

  // set aria-label for triggers
  triggers.forEach(function (trigger) {
    trigger.setAttribute('aria-label', label_for(trigger));
    trigger.querySelectorAll('[class*="icon-"]').forEach(function (icon) {
      icon.setAttribute('aria-hidden', 'true');
    });
  });

  // hide tooltip
  function hide_tooltip() {
    if (!tooltip) {
      return;
    }
    var owner = document.getElementById(tooltip.dataset.owner);
    if (owner) {
      owner.removeAttribute('aria-describedby');
    }
    tooltip.remove();
    tooltip = null;
  }

  // position tooltip beside trigger
  function position_beside(element, trigger) {
    var rect = trigger.getBoundingClientRect();
    var side = sidebar.getBoundingClientRect();
    var rtl = root.dir.toLowerCase() === 'rtl';
    var width = element.offsetWidth;
    var left = rtl ? side.left - width - 8 : side.right + 8;
    element.style.left = Math.max(8, Math.min(left, window.innerWidth - width - 8)) + 'px';
    element.style.top = Math.max(8, Math.min(rect.top, window.innerHeight - element.offsetHeight - 8)) + 'px';
  }

  // show tooltip
  function show_tooltip(trigger) {
    hide_tooltip();
    if (!rail_mode() || flyout_trigger === trigger) {
      return;
    }
    tooltip = document.createElement('div');
    tooltip.id = 'admin-rail-tooltip';
    tooltip.className = 'admin-rail-tooltip';
    tooltip.setAttribute('role', 'tooltip');
    tooltip.textContent = label_for(trigger);
    if (!trigger.id) {
      trigger.id = 'admin-rail-item-' + triggers.indexOf(trigger);
    }
    tooltip.dataset.owner = trigger.id;
    trigger.setAttribute('aria-describedby', tooltip.id);
    document.body.appendChild(tooltip);
    position_beside(tooltip, trigger);
  }

  // close flyout
  function close_flyout(restore_focus) {
    if (!flyout) {
      return;
    }
    var trigger = flyout_trigger;
    flyout.remove();
    flyout = null;
    flyout_trigger = null;
    trigger.setAttribute('aria-expanded', 'false');
    trigger.setAttribute('aria-controls', trigger.parentElement.querySelector('.accordion-content').id);
    if (restore_focus) {
      trigger.focus();
    }
  }

  // open flyout
  function open_flyout(trigger, focus_first) {
    close_flyout();
    hide_tooltip();
    var content = trigger.parentElement.querySelector('.accordion-content > ul');
    if (!content) {
      return;
    }
    flyout_trigger = trigger;
    flyout = document.createElement('section');
    flyout.id = 'admin-rail-flyout';
    flyout.className = 'admin-rail-flyout';
    flyout.setAttribute('aria-label', label_for(trigger));
    var heading = document.createElement('div');
    heading.className = 'admin-rail-flyout-title';
    heading.textContent = label_for(trigger);
    var links = content.cloneNode(true);
    links.className = 'menu menu-sm w-full gap-1 p-2';
    links.querySelectorAll('[id]').forEach(function (node) {
      node.removeAttribute('id');
    });
    links.querySelectorAll('[hidden]').forEach(function (node) {
      node.hidden = false;
    });
    flyout.append(heading, links);
    document.body.appendChild(flyout);
    trigger.setAttribute('aria-controls', flyout.id);
    trigger.setAttribute('aria-expanded', 'true');
    position_beside(flyout, trigger);
    if (focus_first) {
      var first = flyout.querySelector('a');
      if (first) {
        first.focus();
      }
    }
  }

  // sync layout
  function sync_layout() {
    close_flyout();
    hide_tooltip();
    var collapsed = rail_mode();
    toggle.setAttribute('aria-expanded', String(!collapsed));
    toggle.setAttribute('aria-label', collapsed ? toggle.dataset.labelExpand : toggle.dataset.labelCollapse);
    toggle.title = toggle.getAttribute('aria-label');
    groups.forEach(function (trigger) {
      var content = trigger.parentElement.querySelector('.accordion-content');
      trigger.setAttribute('aria-controls', content.id);
      trigger.setAttribute('aria-expanded', String(!collapsed && trigger.parentElement.classList.contains('active')));
    });
  }

  /* get accordion instance */
  function accordion_of(item) {
    if (!window.HSAccordion) {
      return null;
    }
    var found = window.HSAccordion.getInstance(item, true);
    return (found && found.element) ? found.element : found;
  }

  /* collapse groups */
  function collapse_groups() {
    reopen = groups.filter(function (trigger) {
      return trigger.parentElement.classList.contains('active');
    }).map(function (trigger) {
      return trigger.parentElement;
    });
    reopen.forEach(function (item) {
      /* mark current section */
      item.classList.add('rail-current');
      var content = item.querySelector('.accordion-content');
      var trigger = item.querySelector(':scope > .accordion-toggle');
      /* hide content */
      item.classList.remove('active');
      if (trigger) {
        trigger.setAttribute('aria-expanded', 'false');
      }
      if (content) {
        content.style.display = 'none';
        content.style.height = '';
      }
    });
  }

  // reopen groups
  function expand_groups() {
    reopen.forEach(function (item) {
      item.classList.remove('rail-current');
      var accordion = accordion_of(item);
      if (accordion) {
        accordion.show();
      }
    });
    reopen = [];
  }

  // set collapsed
  function set_collapsed(collapsed) {
    if (collapsed) {
      collapse_groups();
    }
    root.dataset.adminSidebar = collapsed ? 'collapsed' : 'expanded';
    try {
      localStorage.setItem('sngine.admin.sidebar', root.dataset.adminSidebar);
    } catch (e) {
      /* storage unavailable */
    }
    if (!collapsed) {
      expand_groups();
    }
    sync_layout();
    schedule_reveal();
  }

  toggle.addEventListener('click', function () {
    set_collapsed(!rail_mode());
  });
  desktop.addEventListener('change', function () {
    sync_layout();
    schedule_reveal();
  });
  sidebar.addEventListener('open.overlay', function (e) {
    if (e.target === sidebar) {
      schedule_reveal();
    }
  });

  /* handle scroll */
  ['wheel', 'touchstart', 'pointerdown', 'keydown'].forEach(function (event) {
    scroll_area.addEventListener(event, function () {
      scroll_request++;
    }, { passive: true });
  });

  /* handle accordion in rail */
  nav.addEventListener('click', function (e) {
    var trigger = e.target.closest('.accordion-toggle');
    if (!rail_mode() || !groups.includes(trigger)) {
      return;
    }
    e.preventDefault();
    e.stopImmediatePropagation();
    if (flyout_trigger === trigger) {
      close_flyout();
    } else {
      open_flyout(trigger);
    }
  }, true);

  triggers.forEach(function (trigger) {
    trigger.addEventListener('mouseenter', function () {
      show_tooltip(trigger);
    });
    trigger.addEventListener('mouseleave', hide_tooltip);
    trigger.addEventListener('focus', function () {
      show_tooltip(trigger);
    });
    trigger.addEventListener('blur', hide_tooltip);
    trigger.addEventListener('keydown', function (e) {
      if (!rail_mode()) {
        return;
      }
      if ((e.key === 'ArrowDown' || e.key === 'ArrowUp') && groups.includes(trigger)) {
        e.preventDefault();
        e.stopImmediatePropagation();
        open_flyout(trigger, true);
      } else if (e.key === 'Tab' && !e.shiftKey && flyout_trigger === trigger) {
        e.preventDefault();
        var first = flyout.querySelector('a');
        if (first) {
          first.focus();
        }
      }
    });
  });

  // close flyout on pointerdown
  document.addEventListener('pointerdown', function (e) {
    if (flyout && !flyout.contains(e.target) && !flyout_trigger.contains(e.target)) {
      close_flyout();
    }
  });

  // close flyout on focusin
  document.addEventListener('focusin', function (e) {
    if (flyout && !flyout.contains(e.target) && !flyout_trigger.contains(e.target)) {
      close_flyout();
    }
  });

  // close flyout on click
  document.addEventListener('click', function (e) {
    if (e.target.closest('a')) {
      close_flyout();
    }
  });

  // close flyout on keydown
  document.addEventListener('keydown', function (e) {
    if (e.key === 'Escape') {
      close_flyout(true);
      hide_tooltip();
    }
    if (!flyout || !flyout.contains(e.target)) {
      return;
    }
    var links = Array.from(flyout.querySelectorAll('a'));
    var index = links.indexOf(document.activeElement);
    if (e.key === 'Tab' && e.shiftKey && index === 0) {
      e.preventDefault();
      flyout_trigger.focus();
    } else if (e.key === 'Tab' && !e.shiftKey && index === links.length - 1) {
      e.preventDefault();
      var next = triggers[triggers.indexOf(flyout_trigger) + 1] || toggle;
      close_flyout();
      next.focus();
    } else if (e.key === 'ArrowDown' || e.key === 'ArrowUp' || e.key === 'Home' || e.key === 'End') {
      e.preventDefault();
      var next_index = e.key === 'Home' ? 0 : e.key === 'End' ? links.length - 1 : (index + (e.key === 'ArrowDown' ? 1 : -1) + links.length) % links.length;
      if (links[next_index]) {
        links[next_index].focus();
      }
    }
  });

  // close flyout on resize
  window.addEventListener('resize', function () {
    close_flyout();
    hide_tooltip();
  });

  // close flyout on scroll
  scroll_area.addEventListener('scroll', function () {
    close_flyout();
    hide_tooltip();
  });
  sync_layout();
  if (document.readyState === 'complete') {
    schedule_reveal();
  } else {
    window.addEventListener('load', schedule_reveal, { once: true });
  }
}


// admin live dropdowns
function admin_live_dropdowns() {
  var selector = '.js_live-requests, .js_live-messages, .js_live-notifications';

  // bind dropdown
  function bind(el) {
    if (el.dataset.adminLiveBound === '1') {
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
    el.dataset.adminLiveBound = '1';
    instance.on('open', function () {
      if (window.jQuery) {
        window.jQuery(el).trigger('show.bs.dropdown');
      }
    });
  }

  // bind all dropdowns
  function bind_all() {
    document.querySelectorAll(selector).forEach(bind);
  }

  if (document.readyState === 'complete') {
    bind_all();
  } else {
    window.addEventListener('load', bind_all);
  }
}


// admin command palette
function admin_command_palette() {
  var palette = document.getElementById('admin-palette');
  var trigger = document.getElementById('admin-palette-trigger');
  var input = document.getElementById('admin-palette-input');
  var results = document.getElementById('admin-palette-results');
  var nav = document.getElementById('admin-nav');
  if (!palette || !input || !results || !nav) {
    return;
  }
  var clear = palette.querySelector('.js_admin-palette-clear');
  var storage_key = 'sngine.admin.palette.recent';
  var recent_limit = 5;
  var result_limit = 50;
  var label_recent = palette.dataset.labelRecent || 'Recent';
  var label_empty = palette.dataset.labelEmpty || 'No results found';
  var label_settings = palette.dataset.labelSettings || 'Settings';
  var label_remove = palette.dataset.labelRemove || 'Remove from recent';
  var label_clear_all = palette.dataset.labelClearAll || 'Clear All';
  var index = [];
  var settings_index = [];
  var settings_loading = null;
  var rows = [];
  var active = -1;

  // get label
  function label_of(el) {
    if (!el) {
      return '';
    }
    var grow = el.querySelector('.grow');
    return ((grow || el).textContent || '').trim();
  }

  // get icon
  function icon_of(el) {
    return el ? el.querySelector('[class*="icon-["]') : null;
  }

  // get badge
  function badge_of(el) {
    var badge = el.querySelector('.badge');
    return badge ? badge.textContent.trim() : '';
  }

  // add entry
  function entry(link, section, parent, icon) {
    index.push({
      label: label_of(link),
      url: link.getAttribute('href'),
      section: section,
      parent: parent,
      badge: badge_of(link),
      current: link.classList.contains('menu-active'),
      icon: icon
    });
  }

  /* build index */
  function build_index() {
    var section = '';
    index = [];
    Array.from(nav.children).forEach(function (item) {
      if (item.classList.contains('js_admin-nav-heading')) {
        section = item.textContent.trim();
        return;
      }
      var link = item.querySelector(':scope > a[href]');
      if (link) {
        entry(link, section, '', icon_of(link));
        return;
      }
      var toggle = item.querySelector(':scope > .accordion-toggle');
      if (!toggle) {
        return;
      }
      var parent = label_of(toggle);
      var icon = icon_of(toggle);
      item.querySelectorAll('.accordion-content a[href]').forEach(function (child) {
        entry(child, section, parent, icon);
      });
    });
    index = index.concat(settings_index);
  }

  /* get settings index */
  function load_settings_index() {
    if (settings_loading) {
      return settings_loading;
    }
    if (!window.fetch || !window.ajax_path) {
      return Promise.resolve();
    }
    settings_loading = fetch(window.ajax_path + 'admin/settings_search_index.php', {
      credentials: 'same-origin',
      headers: { 'X-Requested-With': 'XMLHttpRequest' }
    })
      .then(function (response) {
        var type = response.headers.get('content-type') || '';
        if (!response.ok || type.indexOf('json') === -1) {
          throw new Error('settings index unavailable (' + response.status + ' ' + type + ')');
        }
        return response.json();
      })
      .then(function (data) {
        settings_index = (Array.isArray(data) ? data : []).map(function (field) {
          return {
            label: field.label,
            help: field.help,
            url: field.url,
            section: label_settings,
            parent: field.page + (field.tab ? ' › ' + field.tab : ''),
            badge: '',
            current: false,
            icon: null,
            type: 'setting'
          };
        });
      })
      .catch(function (error) {
        settings_index = [];
        if (window.system_debugging_mode && window.console) {
          console.warn('admin palette:', error.message);
        }
      });
    return settings_loading;
  }

  // normalize
  function normalize(value) {
    return value.toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g, '');
  }

  // subsequence match
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

  // match field
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

  /* score one item */
  function score_one(item, needle) {
    var best = match(normalize(item.label), needle);
    var pair = item.parent ? match(normalize(item.parent + ' ' + item.label), needle) : 0;
    var group = Math.floor(match(normalize(item.section), needle) / 3);
    var help = item.help ? Math.floor(match(normalize(item.help), needle) / 4) : 0;
    return Math.max(best, pair, group, help);
  }

  /* check word */
  function has_word(item, word) {
    return match(normalize(item.label), word) >= 400 ||
      (item.parent && match(normalize(item.parent + ' ' + item.label), word) >= 400) ||
      match(normalize(item.section), word) >= 400 ||
      (item.help && match(normalize(item.help), word) >= 400);
  }

  /* score item */
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

  // build row
  function build_row(item, position) {
    var row = document.createElement('a');
    row.className = 'js_admin-palette-item admin-palette-item';
    row.href = item.url;
    row.setAttribute('role', 'option');
    row.setAttribute('aria-selected', 'false');
    row.id = 'admin-palette-row-' + position;
    row.dataset.index = String(position);
    row.dataset.url = item.url;
    if (item.icon) {
      var icon = item.icon.cloneNode(true);
      icon.classList.add('admin-palette-item-icon');
      icon.setAttribute('aria-hidden', 'true');
      row.appendChild(icon);
    } else if (item.type === 'setting') {
      var settings_icon = document.createElement('span');
      settings_icon.className = 'icon-[tabler--settings] size-4 admin-palette-item-icon';
      settings_icon.setAttribute('aria-hidden', 'true');
      row.appendChild(settings_icon);
    }
    var label = document.createElement('span');
    label.className = 'admin-palette-item-label';
    label.textContent = item.label;
    row.appendChild(label);
    if (item.parent) {
      var crumb = document.createElement('span');
      crumb.className = 'admin-palette-crumb';
      crumb.textContent = item.parent;
      row.appendChild(crumb);
    }
    if (item.badge) {
      var badge = document.createElement('span');
      badge.className = 'admin-palette-badge';
      badge.textContent = item.badge;
      row.appendChild(badge);
    }
    if (item.current) {
      row.classList.add('is-current');
    }
    return row;
  }

  // build heading
  function build_heading(text, clearable) {
    var heading = document.createElement('div');
    heading.className = 'admin-palette-heading';
    heading.setAttribute('role', 'presentation');
    if (!clearable) {
      heading.textContent = text;
      return heading;
    }
    heading.classList.add('admin-palette-heading-row');
    var title = document.createElement('span');
    title.textContent = text;
    var button = document.createElement('button');
    button.type = 'button';
    button.className = 'js_admin-palette-clear-recents admin-palette-clear-all';
    button.textContent = label_clear_all;
    heading.append(title, button);
    return heading;
  }

  // get recent items
  function recent_items() {
    var stored = [];
    try {
      stored = JSON.parse(localStorage.getItem(storage_key)) || [];
    } catch (e) {
      /* storage unavailable */
    }
    if (!Array.isArray(stored)) {
      return [];
    }
    return stored.map(function (url) {
      return index.filter(function (item) {
        return item.url === url;
      })[0];
    }).filter(Boolean).slice(0, recent_limit);
  }

  // remember recent
  function remember(url) {
    try {
      var stored = JSON.parse(localStorage.getItem(storage_key)) || [];
      if (!Array.isArray(stored)) {
        stored = [];
      }
      stored = stored.filter(function (value) {
        return value !== url;
      });
      stored.unshift(url);
      localStorage.setItem(storage_key, JSON.stringify(stored.slice(0, recent_limit)));
    } catch (e) {
      /* storage unavailable */
    }
  }

  // forget recent
  function forget(url) {
    try {
      var stored = JSON.parse(localStorage.getItem(storage_key)) || [];
      if (!Array.isArray(stored)) {
        return;
      }
      localStorage.setItem(storage_key, JSON.stringify(stored.filter(function (value) {
        return value !== url;
      })));
    } catch (e) {
      /* storage unavailable */
    }
  }

  // clear recents
  function forget_all() {
    try {
      localStorage.removeItem(storage_key);
    } catch (e) {
      /* storage unavailable */
    }
  }

  /* wrap removable row */
  function wrap_removable(row) {
    var wrapper = document.createElement('div');
    wrapper.className = 'admin-palette-row';
    var remove = document.createElement('button');
    remove.type = 'button';
    remove.className = 'js_admin-palette-remove admin-palette-remove';
    remove.tabIndex = -1;
    remove.setAttribute('aria-label', label_remove);
    remove.title = label_remove;
    remove.dataset.url = row.dataset.url;
    remove.innerHTML = '<span class="icon-[tabler--x] size-4" aria-hidden="true"></span>';
    wrapper.append(row, remove);
    return wrapper;
  }

  // append group
  function append_group(title, items, removable) {
    if (!items.length) {
      return;
    }
    var group = document.createElement('div');
    group.className = 'admin-palette-group';
    group.appendChild(build_heading(title, removable));
    items.forEach(function (item) {
      var row = build_row(item, rows.length);
      rows.push(row);
      if (removable) {
        row.dataset.recent = '1';
        group.appendChild(wrap_removable(row));
      } else {
        group.appendChild(row);
      }
    });
    results.appendChild(group);
  }

  /* delete recent */
  function remove_recent(row) {
    var position = Number(row.dataset.index);
    forget(row.dataset.url);
    render();
    if (rows.length) {
      set_active(Math.min(position, rows.length - 1));
    }
    input.focus();
  }

  // append sections
  function append_sections(items) {
    var seen = [];
    items.forEach(function (item) {
      if (seen.indexOf(item.section) === -1) {
        seen.push(item.section);
      }
    });
    seen.forEach(function (section) {
      append_group(section, items.filter(function (item) {
        return item.section === section;
      }));
    });
  }

  // empty state
  function append_empty() {
    var empty = document.createElement('p');
    empty.className = 'admin-palette-empty';
    empty.textContent = label_empty;
    results.appendChild(empty);
  }

  /* highlight row */
  function set_active(position) {
    if (active > -1 && rows[active]) {
      rows[active].classList.remove('is-active');
      rows[active].setAttribute('aria-selected', 'false');
    }
    active = position;
    if (active > -1 && rows[active]) {
      rows[active].classList.add('is-active');
      rows[active].setAttribute('aria-selected', 'true');
      rows[active].scrollIntoView({ block: 'nearest' });
      input.setAttribute('aria-activedescendant', rows[active].id);
    } else {
      input.removeAttribute('aria-activedescendant');
    }
  }

  /* render results */
  function render() {
    var query = input.value.trim();
    var needle = normalize(query);
    results.innerHTML = '';
    rows = [];
    active = -1;
    if (clear) {
      clear.hidden = !query;
    }
    if (!needle) {
      append_group(label_recent, recent_items(), true);
      append_sections(index);
    } else {
      var matches = index.map(function (item, position) {
        return { item: item, score: score(item, needle), position: position };
      }).filter(function (row) {
        return row.score > 0;
      });
      matches.sort(function (a, b) {
        return b.score - a.score || a.position - b.position;
      });
      var top = matches.slice(0, result_limit).map(function (row) {
        return row.item;
      });
      if (!top.length) {
        append_empty();
      } else {
        append_sections(top);
      }
    }
    results.scrollTop = 0;
    if (rows.length) {
      set_active(0);
    }
  }

  // move
  function move(step) {
    if (!rows.length) {
      return;
    }
    set_active((active + step + rows.length) % rows.length);
  }

  // go
  function go(row) {
    if (!row) {
      return;
    }
    remember(row.dataset.url);
    window.location = row.href;
  }

  // is open
  function is_open() {
    return !palette.classList.contains('hidden');
  }

  // open
  function open_palette() {
    if (window.HSOverlay) {
      window.HSOverlay.open(palette);
    } else {
      palette.classList.remove('hidden');
      palette.classList.add('open');
    }
    build_index();
    input.value = '';
    render();
    load_settings_index().then(function () {
      build_index();
      if (is_open()) {
        render();
      }
    });
    input.focus();
  }

  // close
  function close_palette() {
    if (window.HSOverlay) {
      window.HSOverlay.close(palette);
    } else {
      palette.classList.add('hidden');
      palette.classList.remove('open');
    }
    if (trigger) {
      trigger.focus();
    }
  }

  /* handle input */
  input.addEventListener('input', render);

  /* handle clear */
  if (clear) {
    clear.addEventListener('click', function () {
      input.value = '';
      render();
      input.focus();
    });
  }

  /* handle results */
  results.addEventListener('click', function (e) {
    var clear_recents = e.target.closest('.js_admin-palette-clear-recents');
    if (clear_recents) {
      e.preventDefault();
      e.stopPropagation();
      forget_all();
      render();
      input.focus();
      return;
    }
    var remove = e.target.closest('.js_admin-palette-remove');
    if (remove) {
      e.preventDefault();
      e.stopPropagation();
      remove_recent(remove.previousElementSibling);
      return;
    }
    var row = e.target.closest('.js_admin-palette-item');
    if (row) {
      e.preventDefault();
      go(row);
    }
  });

  /* handle remove */
  results.addEventListener('mousedown', function (e) {
    if (e.target.closest('.js_admin-palette-remove') || e.target.closest('.js_admin-palette-clear-recents')) {
      e.preventDefault();
    }
  });

  results.addEventListener('mousemove', function (e) {
    var row = e.target.closest('.js_admin-palette-item');
    if (row && rows[active] !== row) {
      set_active(Number(row.dataset.index));
    }
  });

  /* handle overlay click */
  palette.addEventListener('click', function (e) {
    if (!e.target.closest('.js_admin-palette-dialog')) {
      close_palette();
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
    } else if ((e.key === 'Delete' || e.key === 'Backspace') && rows[active] && rows[active].dataset.recent && !input.value) {
      e.preventDefault();
      remove_recent(rows[active]);
    } else if (e.key === 'Escape') {
      e.preventDefault();
      close_palette();
    }
  });

  /* handle ⌘K / Ctrl+K */
  document.addEventListener('keydown', function (e) {
    if (!(e.metaKey || e.ctrlKey) || e.altKey || e.key.toLowerCase() !== 'k') {
      return;
    }
    e.preventDefault();
    if (is_open()) {
      close_palette();
    } else {
      open_palette();
    }
  });

  /* handle trigger */
  if (trigger) {
    trigger.addEventListener('click', function () {
      build_index();
      input.value = '';
      render();
      load_settings_index().then(function () {
        build_index();
        if (is_open()) {
          render();
        }
      });
    });
    var platform = (navigator.userAgentData && navigator.userAgentData.platform) || navigator.platform || '';
    if (/mac|iphone|ipad|ipod/i.test(platform)) {
      trigger.querySelectorAll('.js_palette-mod').forEach(function (node) {
        node.textContent = '⌘';
      });
    }
  }

  build_index();
}


// settings goto
function admin_settings_goto() {
  var id = new URLSearchParams(window.location.search).get('goto');
  if (!id) {
    return;
  }
  var field = document.getElementById(id);
  if (!field) {
    return;
  }
  var panel = field.closest('.js_admin-settings-panel');
  var toggle = panel ? document.querySelector('[data-tab="#' + panel.id + '"]') : null;
  if (toggle) {
    /* open tab */
    var tablist = toggle.closest('[role="tablist"]');
    (tablist ? tablist.querySelectorAll('[data-tab]') : [toggle]).forEach(function (other) {
      if (other === toggle) {
        return;
      }
      other.classList.remove('active');
      if (other.hasAttribute('aria-selected')) {
        other.setAttribute('aria-selected', 'false');
      }
    });
    toggle.classList.add('active');
    if (toggle.hasAttribute('aria-selected')) {
      toggle.setAttribute('aria-selected', 'true');
    }
    Array.from(panel.parentElement.children).forEach(function (other) {
      if (other !== panel && other.classList.contains('js_admin-settings-panel')) {
        other.classList.add('hidden');
      }
    });
    panel.classList.remove('hidden');
  }
  /* scroll to the field */
  window.requestAnimationFrame(function () {
    var row = field.closest('.js_admin-setting-switch, .js_admin-setting-field') || field;
    row.scrollIntoView({ behavior: 'smooth', block: 'center' });
    row.classList.add('setting-highlight');
    setTimeout(function () {
      row.classList.remove('setting-highlight');
    }, 2000);
  });
  /* remove goto from the url */
  var params = new URLSearchParams(window.location.search);
  params.delete('goto');
  var query = params.toString();
  window.history.replaceState(null, '', window.location.pathname + (query ? '?' + query : '') + window.location.hash);
}


// toggle all
function admin_toggle_all() {
  var buttons = Array.prototype.slice.call(document.querySelectorAll('.js_admin-toggle-all'));
  if (!buttons.length) {
    return;
  }

  function switches(button) {
    var root = (button.dataset.scope === 'form')
      ? button.closest('form')
      : button.closest('.admin-settings-section');
    if (!root) {
      return [];
    }
    return Array.prototype.slice.call(root.querySelectorAll('.js_admin-setting-switch:not([data-toggle-all="skip"]) input.switch[type="checkbox"]'));
  }

  function all_checked(boxes) {
    return boxes.length > 0 && boxes.every(function (box) {
      return box.checked;
    });
  }

  function sync(button) {
    var boxes = switches(button);
    var label = button.querySelector('.js_admin-toggle-all-label');
    button.disabled = !boxes.length;
    if (label) {
      label.textContent = (all_checked(boxes)) ? button.dataset.labelDisable : button.dataset.labelEnable;
    }
  }

  buttons.forEach(function (button) {
    sync(button);
    button.addEventListener('click', function () {
      var boxes = switches(button);
      var enable = !all_checked(boxes);
      boxes.forEach(function (box) {
        if (box.checked !== enable) {
          box.checked = enable;
          box.dispatchEvent(new Event('change', { bubbles: true }));
        }
      });
      buttons.forEach(sync);
    });
  });

  document.addEventListener('change', function (e) {
    if (e.target.matches('input.switch[type="checkbox"]')) {
      buttons.forEach(sync);
    }
  });
}


// init
admin_sidebar();
admin_live_dropdowns();
admin_command_palette();
admin_settings_goto();
admin_toggle_all();
