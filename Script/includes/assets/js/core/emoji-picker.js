/**
 * emoji picker js
 *
 * @package Sngine
 * @author Zamblek
 */

// initialize emoji picker
const catalogues = new Map();
const key = `sngine:emoji:${window.user_id || 'guest'}`;
let storage;
try { storage = window.localStorage; } catch { /* storage unavailable */ }
const preferences = readPreferences(storage, key);
let sequence = 0;
const translate = text => window.__?.[text] || text;


// replace selection
function replaceSelection(text, start, end, value) {
  return { text: text.slice(0, start) + value + text.slice(end), cursor: start + value.length };
}


// sticker insertion
function stickerInsertion(text, start, end, value) {
  const before = start > 0 && !/\s$/.test(text.slice(0, start)) ? ' ' : '';
  const after = end < text.length && !/^\s/.test(text.slice(end)) ? ' ' : '';
  return before + value + after;
}


// read preferences
function readPreferences(storage, key) {
  try {
    const value = JSON.parse(storage.getItem(key));
    return {
      recent: Array.isArray(value?.recent) ? [...new Set(value.recent.filter(item => typeof item === 'string'))].slice(0, 32) : [],
      tone: Number.isInteger(value?.tone) && value.tone >= 0 && value.tone <= 5 ? value.tone : 0
    };
  } catch {
    return { recent: [], tone: 0 };
  }
}


// remember emoji
function rememberEmoji(preferences, unicode, storage, key) {
  preferences.recent = [unicode, ...preferences.recent.filter(item => item !== unicode)].slice(0, 32);
  savePreferences(preferences, storage, key);
}


// save preferences
function savePreferences(preferences, storage, key) {
  try { storage.setItem(key, JSON.stringify(preferences)); } catch { /* storage unavailable */ }
}


// search emojis
function searchEmojis(entries, query, group = 'all') {
  const terms = query.normalize('NFKC').toLocaleLowerCase().trim().split(/\s+/).filter(Boolean);
  return entries.filter(entry => (group === 'all' || String(entry.g) === group) && terms.every(term =>
    [entry.u, entry.n, ...(entry.k || [])].join(' ').normalize('NFKC').toLocaleLowerCase().includes(term)
  ));
}


// locale candidates
function localeCandidates(locale, available) {
  const normalized = locale.toLowerCase().replace(/_/g, '-');
  return [...new Set([normalized, normalized.split('-')[0], 'en'])].filter(value => available.includes(value));
}


// load catalogue
async function loadCatalogue(manifest) {
  const locales = localeCandidates(window.system_langauge_code || 'en', Object.keys(manifest.locales));
  for (const locale of locales) {
    const url = `${window.site_path}/includes/assets/js/emoji-data/${manifest.locales[locale]}`;
    if (!catalogues.has(url)) {
      catalogues.set(url, fetch(url).then(response => {
        if (!response.ok) throw new Error('Emoji catalogue unavailable');
        return response.json();
      }).catch(error => { catalogues.delete(url); throw error; }));
    }
    try { return await catalogues.get(url); } catch { /* try the fallback locale */ }
  }
  throw new Error('Emoji catalogue unavailable');
}


// attach picker
export function attachPicker(trigger, selection, manifest) {
  const dropdown = trigger.closest('.dropdown');
  const menu = trigger.emojiMenu || dropdown.querySelector('.emoji-menu');
  if (!menu) return;
  trigger.emojiMenu = menu;
  trigger.dataset.emojiReady = 'true';
  const gifs = trigger.dataset.gifs === 'true' && !!window.giphy_key;
  menu.innerHTML = window.render_template('#emoji-menu', { id: ++sequence, gifs });
  menu.dir = window.system_langauge_dir || 'ltr';
  const search = menu.querySelector('[data-emoji-search]');
  const category = menu.querySelector('[data-emoji-category]');
  const tone = menu.querySelector('[data-emoji-tone]');
  const grid = menu.querySelector('[data-emoji-grid]');
  const status = menu.querySelector('[data-emoji-status]');
  const more = menu.querySelector('[data-emoji-more]');
  const retry = menu.querySelector('[data-emoji-retry]');
  const scroll = menu.querySelector('[data-emoji-scroll]');
  let catalogue;
  let results = [];
  let count = 0;
  let variants = new Map();

  /* insert */
  function insert(value, isSticker = false) {
    const target = trigger.emojiSelection || selection;
    if (isSticker) value = target.quill
      ? stickerInsertion(target.quill.getText(), target.range.index, target.range.index + target.range.length, value)
      : stickerInsertion(target.textarea?.value || '', target.start, target.end, value);
    if (target.quill) {
      const quill = target.quill;
      const range = target.range;
      const index = Math.min(range.index, Math.max(0, quill.getLength() - 1));
      const length = Math.min(range.length, Math.max(0, quill.getLength() - 1 - index));
      const Delta = window.Quill.import('delta');
      quill.history.cutoff();
      quill.updateContents(new Delta().retain(index).delete(length).insert(value, quill.getFormat(index, length)), 'user');
      quill.history.cutoff();
      quill.setSelection(index + value.length, 0, 'user');
      target.range = { index: index + value.length, length: 0 };
    } else if (target.textarea?.isConnected) {
      const field = target.textarea;
      const result = replaceSelection(field.value, target.start, target.end, value);
      field.value = result.text;
      field.focus();
      field.setSelectionRange(result.cursor, result.cursor);
      field.dispatchEvent(new Event('input', { bubbles: true }));
    } else return;
    if (!isSticker) rememberEmoji(preferences, value, storage, key);
    window.HSDropdown.close(dropdown);
  }

  /* append batch */
  function appendBatch() {
    const batch = document.createDocumentFragment();
    for (const entry of results.slice(count, count + 64)) {
      const variant = category.value === 'recent' ? entry : (entry.s || []).find(item =>
        Array.isArray(item.t) ? item.t.every(tone => tone === preferences.tone) : item.t === preferences.tone
      ) || entry;
      const button = document.createElement('button');
      button.type = 'button';
      button.className = 'heroui button button--ghost button--icon-only rounded-full size-8 min-h-0 p-0 text-2xl leading-none';
      button.dataset.emojiValue = variant.u;
      button.title = variant.n;
      button.setAttribute('aria-label', variant.n);
      button.textContent = variant.u;
      batch.append(button);
    }
    count = Math.min(count + 64, results.length);
    grid.append(batch);
    more.classList.toggle('hidden', count >= results.length);
  }

  /* refresh */
  function refresh() {
    if (!catalogue) return;
    const entries = category.value === 'recent'
      ? preferences.recent.map(value => variants.get(value)).filter(Boolean)
      : catalogue.entries;
    results = searchEmojis(entries, search.value, category.value === 'recent' ? 'all' : category.value);
    count = 0;
    grid.replaceChildren();
    scroll.scrollTop = 0;
    status.textContent = category.value === 'recent' && !search.value ? translate('No recently used emojis') : translate('No emojis found');
    status.classList.toggle('hidden', results.length > 0);
    appendBatch();
  }

  /* load */
  async function load() {
    status.textContent = translate('Loading emojis');
    status.classList.remove('hidden');
    retry.classList.add('hidden');
    try {
      catalogue = await loadCatalogue(manifest);
      for (const group of catalogue.groups) category.add(new Option(group.name, group.id));
      for (const entry of catalogue.entries) {
        variants.set(entry.u, entry);
        for (const variant of entry.s) variants.set(variant.u, { ...variant, g: entry.g, k: entry.k });
      }
      tone.value = String(preferences.tone);
      refresh();
    } catch {
      status.textContent = translate('Unable to load emojis. Please try again.');
      retry.classList.remove('hidden');
    }
  }

  search.addEventListener('input', refresh);
  category.addEventListener('change', refresh);
  tone.addEventListener('change', () => {
    preferences.tone = Number(tone.value);
    savePreferences(preferences, storage, key);
    refresh();
  });
  more.addEventListener('click', appendBatch);
  retry.addEventListener('click', load);
  scroll.addEventListener('scroll', () => {
    if (count < results.length && scroll.scrollTop + scroll.clientHeight >= scroll.scrollHeight - 64) appendBatch();
  }, { passive: true });
  menu.addEventListener('click', event => {
    const gif = event.target.closest('[data-gif]');
    if (gif) {
      window.composer_gif_add(trigger.closest('.js_composer'), gif.dataset.gif);
      window.HSDropdown.close(dropdown);
      return;
    }
    const button = event.target.closest('[data-emoji-value],[data-sticker]');
    if (button) insert(button.dataset.emojiValue || button.dataset.sticker, !!button.dataset.sticker);
  });
  if (gifs && menu.querySelector('[data-gif-tab]')) attachGifs(menu);
  grid.addEventListener('keydown', event => {
    const buttons = [...grid.querySelectorAll('button')];
    const index = buttons.indexOf(document.activeElement);
    const direction = menu.dir === 'rtl' ? -1 : 1;
    const movement = { ArrowRight: direction, ArrowLeft: -direction, ArrowDown: 8, ArrowUp: -8, Home: -index, End: buttons.length - 1 - index }[event.key];
    if (index < 0 || movement === undefined) return;
    event.preventDefault();
    event.stopPropagation();
    buttons[Math.max(0, Math.min(buttons.length - 1, index + movement))]?.focus();
  });
  menu.addEventListener('keydown', event => {
    if (event.key === 'Escape') {
      event.preventDefault();
      event.stopPropagation();
      window.HSDropdown.close(dropdown);
      trigger.focus();
    } else if (event.target.matches('input,select,textarea')) {
      event.stopPropagation();
    }
  });
  /* focus search */
  function focusSearch() {
    if (document.activeElement === trigger && !window.matchMedia?.('(pointer: coarse)').matches) search.focus();
  }
  dropdown.addEventListener('open.dropdown', () => { tone.value = String(preferences.tone); refresh(); focusSearch(); });
  if (!window.HSDropdown.getInstance(dropdown)) new window.HSDropdown(dropdown);
  window.HSDropdown.open(dropdown);
  focusSearch();
  load();
}


// attach gifs
function attachGifs(menu) {
  const tab = menu.querySelector('[data-gif-tab]');
  const search = menu.querySelector('[data-gif-search]');
  const grid = menu.querySelector('[data-gif-grid]');
  const status = menu.querySelector('[data-gif-status]');
  const retry = menu.querySelector('[data-gif-retry]');
  const scroll = menu.querySelector('[data-gif-scroll]');
  let query = '';
  let offset = 0;
  let total = Infinity;
  let loading = false;
  let request = 0;
  let timer;

  /* load */
  async function load(reset = false) {
    if (reset) {
      offset = 0;
      total = Infinity;
      grid.replaceChildren();
      scroll.scrollTop = 0;
    }
    if (loading && !reset) return;
    if (offset >= total) return;
    const current = ++request;
    loading = true;
    status.textContent = translate('Loading');
    status.classList.remove('hidden');
    retry.classList.add('hidden');
    try {
      const result = await window.giphy_search(query, offset, 24);
      if (current !== request) return;
      const batch = document.createDocumentFragment();
      for (const item of result.data || []) {
        const preview = item.images?.fixed_width;
        const full = item.images?.fixed_height;
        if (!preview?.url || !full?.url) continue;
        const button = document.createElement('button');
        button.type = 'button';
        button.className = 'mb-1 block w-full overflow-hidden rounded-field bg-base-200 focus-visible:outline-2 focus-visible:outline-primary';
        button.dataset.gif = full.url;
        button.title = item.title || 'GIF';
        button.setAttribute('aria-label', item.title || 'GIF');
        const image = document.createElement('img');
        image.className = 'block h-auto w-full';
        image.src = preview.url;
        image.width = preview.width;
        image.height = preview.height;
        image.alt = '';
        image.loading = 'lazy';
        button.append(image);
        batch.append(button);
      }
      grid.append(batch);
      offset += result.pagination?.count || (result.data || []).length;
      total = Math.min(result.pagination?.total_count ?? offset, 4999);
      if (!(result.data || []).length) total = offset;
      status.textContent = translate('No result found');
      status.classList.toggle('hidden', grid.childElementCount > 0);
    } catch {
      if (current !== request) return;
      status.textContent = translate('Unable to load GIFs. Please try again.');
      retry.classList.remove('hidden');
    } finally {
      if (current === request) loading = false;
    }
  }

  tab.addEventListener('change', () => {
    if (!grid.childElementCount && !loading) load(true);
    if (!window.matchMedia?.('(pointer: coarse)').matches) search.focus();
  });
  search.addEventListener('input', () => {
    clearTimeout(timer);
    timer = setTimeout(() => {
      if (search.value.trim() === query) return;
      query = search.value.trim();
      load(true);
    }, 350);
  });
  retry.addEventListener('click', () => load(!grid.childElementCount));
  scroll.addEventListener('scroll', () => {
    if (!loading && offset < total && scroll.scrollTop + scroll.clientHeight >= scroll.scrollHeight - 120) load();
  }, { passive: true });
}
