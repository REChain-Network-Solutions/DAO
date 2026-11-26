/**
 * emojis js
 *
 * @package Sngine
 * @author Zamblek
 */

import manifest from '../emoji-data/manifest.json';

// initialize emojis
let picker;


// load picker
function loadPicker() {
  if (!picker) picker = import('./emoji-picker.js').catch(error => { picker = null; throw error; });
  return picker;
}


// initialize picker
async function initializePicker(trigger) {
  if (!trigger || trigger.dataset.emojiReady || trigger.dataset.emojiLoading) return;
  trigger.dataset.emojiLoading = 'true';
  trigger.setAttribute('aria-busy', 'true');
  const selection = trigger.emojiSelection || captureSelection(trigger);
  try {
    const module = await loadPicker();
    if (trigger.isConnected) module.attachPicker(trigger, selection, manifest);
  } catch {
    const menu = trigger.emojiMenu;
    if (menu) {
      const button = document.createElement('button');
      button.type = 'button';
      button.className = 'heroui button button--ghost button--sm m-3 h-auto whitespace-normal';
      button.textContent = window.__?.['Unable to load emojis. Please try again.'] || 'Unable to load emojis. Please try again.';
      button.dataset.emojiBootstrapRetry = '';
      button.emojiTrigger = trigger;
      menu.replaceChildren(button);
    }
  } finally {
    delete trigger.dataset.emojiLoading;
    trigger.removeAttribute('aria-busy');
  }
}


// start
function start() {
  document.addEventListener('pointerdown', event => {
    const trigger = event.target.closest('.js_emoji-menu-toggle');
    if (trigger) captureSelection(trigger);
  }, true);
  document.addEventListener('keydown', event => {
    if (!['Enter', ' ', 'ArrowDown', 'ArrowUp'].includes(event.key)) return;
    const trigger = event.target.closest('.js_emoji-menu-toggle');
    if (trigger) captureSelection(trigger);
  }, true);
  document.addEventListener('click', event => {
    const trigger = event.target.closest('.js_emoji-menu-toggle');
    if (trigger) captureSelection(trigger);
  }, true);
  document.addEventListener('open.dropdown', event => {
    initializePicker(event.target.querySelector(':scope > .js_emoji-menu-toggle'));
  });
  document.addEventListener('click', event => {
    const trigger = event.target.closest('.js_emoji-menu-toggle') || event.target.closest('[data-emoji-bootstrap-retry]')?.emojiTrigger;
    initializePicker(trigger);
  });
}


// capture selection
function captureSelection(trigger) {
  const dropdown = trigger.closest('.dropdown');
  trigger.emojiMenu ||= dropdown.querySelector('.emoji-menu');
  if (window.HSDropdown && !window.HSDropdown.getInstance(dropdown)) new window.HSDropdown(dropdown);
  const form = trigger.closest('.x-form');
  const editor = form?.querySelector('.js_quill');
  const quill = editor && window.jQuery(editor).data('quill');
  const textarea = form?.querySelector('textarea');
  trigger.emojiSelection = quill
    ? { quill, range: quill.getSelection() || quill.emojiSelection || trigger.emojiSelection?.range || { index: Math.max(0, quill.getLength() - 1), length: 0 } }
    : { textarea, start: textarea?.selectionStart || 0, end: textarea?.selectionEnd || 0 };
  return trigger.emojiSelection;
}


// run
if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', start, { once: true });
else start();
