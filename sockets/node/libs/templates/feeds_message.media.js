/**
 * sockets -> nodejs -> libs -> templates -> feeds_message.media
 *
 * @package Sngine
 * @author Zamblek
 */

const { __ } = require('../core/i18n');

function escape_html(value) {
  return String(value || '').replace(/[&<>"']/g, (char) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[char]));
}

/**
 * file_href
 *
 * @param {Object} file
 * @param {Object} system
 * @return {string}
 */
function file_href(file, system) {
  if (system.mask_file_path_enabled == 1 && file.media_id) {
    return `${system.system_url}/downloads.php?type=message&id=${file.media_id}`;
  }
  return `${system.system_uploads}/${file.source}`;
}

function render_file_card({ file, href }) {
  const name = escape_html(file.name);
  const title = name || escape_html(__('Download File'));
  const type = escape_html(file.type);
  const size = escape_html(file.size_formatted);
  const download = file.name ? ` download="${name}"` : ' download';
  let html = `<a class="flex w-full items-center gap-3 rounded-2xl border border-base-300 bg-base-100 p-2 text-base-content! transition-colors hover:bg-base-200" href="${href}" target="_blank"${download}>`;
  html += '<span class="flex size-10 shrink-0 items-center justify-center rounded-xl bg-primary/10 text-primary" aria-hidden="true">';
  html += type ? `<span class="text-xs font-semibold">${type}</span>` : '<span class="icon-[tabler--file] size-5"></span>';
  html += '</span><span class="min-w-0 grow">';
  html += `<span class="block truncate text-sm font-semibold" title="${title}">${title}</span>`;
  if (type || size) html += `<span class="mt-0.5 block truncate text-xs text-base-content/55" title="${type}${type && size ? ' · ' : ''}${size}">${type}${type && size ? ' · ' : ''}${size}</span>`;
  html += '</span></a>';
  return html;
}

/**
 * render_message_media
 *
 * @param {Object} params
 * @param {Object} params.message
 * @param {Object} params.system
 * @return {string}
 */
function render_message_media({ message, system }) {
  const uploads = system.system_uploads;
  let html = '';

  if (message.media && message.media.photos && message.media.photos.length) {
    html += '<div class="chat-message-media flex w-64 max-w-full flex-col gap-1">';
    message.media.photos.forEach((photo) => {
      html += `<span class="js_lightbox-nodata block cursor-pointer overflow-hidden rounded-2xl border border-base-300/70 bg-base-200" data-image="${uploads}/${photo.source}">`;
      html += `<img class="block max-h-80 w-full object-cover" src="${uploads}/${photo.source}" alt="" loading="lazy"></span>`;
    });
    html += '</div>';
  }
  if (message.media && message.media.video) {
    const video = message.media.video;
    html += '<div class="chat-message-media w-80 max-w-full overflow-hidden rounded-2xl bg-black [&_.plyr]:rounded-2xl">';
    html += '<video class="video-wrapper js_video-plyr block w-full" controls preload="metadata">';
    html += `<source src="${uploads}/${video.source}" type="video/mp4">`;
    html += '</video></div>';
  }
  if (message.media && message.media.audio) {
    html += '<div class="chat-message-media w-72 max-w-full">';
    html += `<audio class="js_audio block h-10 w-full" id="audio-${message.message_id}" controls preload="metadata">`;
    html += `<source src="${uploads}/${message.media.audio.source}" type="audio/mpeg">`;
    html += `<source src="${uploads}/${message.media.audio.source}" type="audio/mp3">`;
    html += __('Your browser does not support HTML5 audio');
    html += '</audio></div>';
  }
  if (message.media && message.media.file) {
    html += '<div class="chat-message-media w-64 max-w-full">';
    html += render_file_card({ file: message.media.file, href: file_href(message.media.file, system) });
    html += '</div>';
  }

  return html;
}

/**
 * render_message_media_grid
 *
 * @param {Object} params
 * @param {Array} params.items
 * @param {Object} params.system
 * @return {string}
 */
function render_message_media_grid({ items, system }) {
  const uploads = system.system_uploads;
  const count = items.length;
  const more = `<span class="js_chat-media-more absolute inset-0 z-10 flex items-center justify-center bg-black/55 text-2xl font-semibold text-white" role="button" aria-label='${__('Show all')}'>+${count - 4}</span>`;
  let html = `<div class="chat-message-media js_chat-media grid w-72 max-w-full gap-0.5 overflow-hidden rounded-2xl border border-base-300/70 bg-base-100 ${count == 1 ? 'grid-cols-1' : 'grid-cols-2'}">`;
  items.forEach((item, index) => {
    const source = `${uploads}/${item.source}`;
    let tile = count == 1 ? '' : count == 3 && index == 0 ? 'row-span-2' : 'aspect-square';
    if (count > 4 && index > 3) tile += ' hidden js_chat-media-hidden';
    const overlay = count > 4 && index == 3 ? more : '';
    if (item.media_type === 'video') {
      html += `<span class="js_lightbox-nodata relative block cursor-pointer overflow-hidden bg-black ${tile}" data-video="${source}" data-gallery="true">`;
      html += `<video class="block w-full ${count == 1 ? 'max-h-80' : 'size-full object-cover'}" src="${source}#t=0.1" preload="metadata" muted playsinline></video>`;
      html += overlay;
      html += '<span class="js_chat-media-play pointer-events-none absolute inset-0 flex items-center justify-center">';
      html += '<span class="flex size-11 items-center justify-center rounded-full bg-black/55 text-white backdrop-blur-sm"><span class="icon-[tabler--player-play-filled] size-5" aria-hidden="true"></span></span>';
      html += '</span></span>';
    } else {
      html += `<span class="js_lightbox-nodata relative block cursor-pointer overflow-hidden bg-base-200 ${tile}" data-image="${source}" data-gallery="true">`;
      html += `<img class="block w-full ${count == 1 ? 'max-h-80 object-cover' : 'size-full object-cover'}" src="${source}" alt="" loading="lazy">`;
      html += overlay;
      html += '</span>';
    }
  });
  html += '</div>';
  return html;
}

module.exports = { render_message_media, render_message_media_grid, render_file_card, file_href };
