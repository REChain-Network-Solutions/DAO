/**
 * sockets -> nodejs -> libs -> templates -> feeds_message
 *
 * @package Sngine
 * @author Zamblek
 */

const { __ } = require('../core/i18n');
const { is_empty } = require('../core/database');
const { print_money, build_paid_message_payment_options } = require('../functions');
const { render_message_media, render_message_media_grid, render_file_card, file_href } = require('./feeds_message.media');

/**
 * render_need_payment_message
 *
 * @param {Object} params
 * @param {Object} params.message
 * @param {Object} params.system
 * @param {number|null} params.vat_percentage
 * @return {string}
 */
function render_need_payment_message({ message, system, vat_percentage = null }) {
  const uploads = system.system_uploads;
  const price = message.message_price;
  const discounted = message.message_price_discounted;
  const pay_price = discounted ? discounted : price;
  const payment_options = build_paid_message_payment_options(
    message.message_id,
    pay_price,
    system,
    vat_percentage
  );
  let html = `<div class="chat-paid-message relative isolate w-64 max-w-full overflow-hidden rounded-2xl ${message.paid_image ? '' : 'border border-primary/15 bg-primary/[0.04]'}">`;
  if (message.paid_image) {
    html += `<img class="absolute inset-0 -z-10 size-full object-cover" src="${uploads}/${message.paid_image}" alt="" loading="lazy">`;
    html += '<div class="absolute inset-0 -z-10 bg-linear-to-t from-black/85 via-black/50 to-black/20" aria-hidden="true"></div>';
  }
  html += `<div class="flex flex-col items-center gap-2 px-4 py-5 text-center ${message.paid_image ? 'text-white' : ''}">`;
  html += `<span class="flex size-10 items-center justify-center rounded-full ${message.paid_image ? 'bg-white/15 ring-1 ring-white/25 backdrop-blur-md' : 'bg-primary/10 text-primary'}" aria-hidden="true"><span class="icon-[tabler--lock] size-5"></span></span>`;
  html += '<p class="text-sm font-semibold">' + __('Paid message') + '</p>';
  if (message.paid_text) {
    html += `<p class="line-clamp-2 text-xs leading-relaxed ${message.paid_image ? 'text-white/80' : 'text-base-content/60'}" dir="auto" title="${String(message.paid_text).replace(/<[^>]*>/g, '')}">${message.paid_text}</p>`;
  }
  html += `<button type="button" class="js_modal btn btn-primary btn-sm mt-1 h-auto min-h-9 max-w-full gap-1.5 rounded-full px-4 py-1.5 leading-snug whitespace-normal text-balance" data-url="#payment" data-options='${payment_options}'>`;
  html += '<span class="icon-[tabler--lock-open] size-4 shrink-0" aria-hidden="true"></span>';
  html += '<span>' + __('Unlock for') + ` <span class="font-semibold">${print_money(pay_price, system)}</span>`;
  if (discounted) {
    html += ` <span class="ms-1 font-normal line-through opacity-70">${print_money(price, system)}</span>`;
  }
  html += '</span></button>';
  html += '</div></div>';
  return html;
}

/**
 * render_message
 *
 * @param {Object} params
 * @param {Object} params.message
 * @param {boolean} params.is_me
 * @param {Object} params.conversation
 * @param {Object} params.user
 * @param {Object} params.system
 * @param {number|null} params.vat_percentage
 * @return {string}
 */
function render_message({ message, is_me, conversation, user, system, vat_percentage = null }) {
  const uploads = system.system_uploads;
  const url = system.system_url;
  const viewer_id = user && user._data ? user._data.user_id : null;
  let mine = is_me === true;
  if (is_me === undefined) {
    mine = (conversation && conversation.as_page) ? !!message.page_id : (!message.page_id && message.user_id == viewer_id);
  }

  const copy_text = message.message_orginal_decoded || '';
  let html = `<li class="group/msg [&.chat-cont]:-mt-2" data-uid="${message.user_id}">`;
  html += `<div class="conversation clearfix flex items-end gap-2 ${mine ? 'right ms-auto flex-row-reverse' : ''}" id="${message.message_id}" data-copy="${escape_attr(copy_text)}">`;

  if (!mine) {
    html += '<div class="conversation-user shrink-0 group-[.chat-more]/msg:invisible">';
    html += `<a href="${url}/${message.page_id ? 'pages/' + message.page_name : message.user_name}"><img class="size-8 rounded-full object-cover ring-2 ring-base-100" src="${message.user_picture}" alt=""></a>`;
    html += '</div>';
  }

  html += `<div class="conversation-body flex min-w-0 max-w-[75%] in-[.chat-widget]:max-w-full flex-col gap-1 ${mine ? 'items-end' : 'items-start'} ${system.chat_translation_enabled == 1 && !is_empty(message.message) ? 'js_chat-translator' : ''}">`;

  if (message.reply) {
    html += `<button type="button" class="js_chat-reply-jump -mb-3 flex min-w-0 max-w-64 items-stretch gap-2.5 rounded-xl bg-base-200/70 pt-1.5 pb-4 ps-2 pe-3 text-start transition-colors hover:bg-base-200 ${mine ? 'ms-auto' : ''}" data-id="${message.reply.message_id}">`;
    html += '<span class="w-0.5 shrink-0 rounded-full bg-primary" aria-hidden="true"></span><span class="min-w-0">';
    if (message.reply.user_fullname) {
      html += `<span class="flex min-w-0 items-center gap-1 text-[11px] font-semibold text-primary"><span class="icon-[tabler--arrow-back-up] size-3 shrink-0" aria-hidden="true"></span><span class="truncate" title="${escape_html(message.reply.user_fullname)}">${escape_html(message.reply.user_fullname)}</span></span>`;
    }
    html += `<span class="block truncate text-xs text-base-content/65" title="${escape_html(message.reply.snippet || '')}">${escape_html(message.reply.snippet || '')}</span></span></button>`;
  }

  html += `<div class="relative flex min-w-0 max-w-full items-center gap-0.5 ${mine ? 'flex-row-reverse' : ''}">`;
  html += `<div class="chat-message-bubble flex min-w-0 flex-col gap-1 ${mine ? 'items-end' : 'items-start'}">`;

  if (message.call) {
    html += render_message_call({ message, mine, system });
  }

  if (message.story) {
    html += `<div class="chat-message-media flex flex-col gap-1.5 ${mine ? 'items-end' : 'items-start'} ${!is_empty(message.message) ? '-mb-5' : ''}">`;
    html += '<span class="flex items-center gap-1 text-xs text-base-content/60">';
    html += '<span class="icon-[tabler--arrow-back-up] size-3.5 shrink-0" aria-hidden="true"></span>';
    html += `${mine ? __('You replied to their story') : __('Replied to your story')}</span>`;
    if (message.story.unavailable) {
      html += '<span class="flex h-24 w-28 flex-col items-center justify-center gap-1.5 rounded-2xl bg-base-200 px-2 text-center text-xs text-base-content/60">';
      html += `<span class="icon-[tabler--history-off] size-5" aria-hidden="true"></span>${__('Story unavailable')}</span>`;
    } else {
      html += `<button type="button" class="js_story-open relative block h-48 w-28 overflow-hidden rounded-2xl bg-linear-to-br from-primary to-accent text-white transition hover:brightness-95 active:scale-[0.98]" data-story-id="${message.story.story_id}" title="${__('Tap to view')}" aria-label="${__('Tap to view')}">`;
      if (message.story.thumbnail) {
        html += `<img class="size-full object-cover" src="${message.story.thumbnail}" alt="" loading="lazy">`;
      } else {
        html += '<span class="absolute inset-0 flex items-center justify-center"><span class="icon-[tabler--history-toggle] size-6" aria-hidden="true"></span></span>';
      }
      html += '</button>';
    }
    html += '</div>';
  }

  if (!is_empty(message.message)) {
    html += `<div class="clearfix ${message.story ? 'relative z-10' : ''}">`;
    html += `<span class="text inline-block max-w-full break-words rounded-2xl px-3.5 py-2 text-sm leading-relaxed ${mine ? 'js_chat-color-me rounded-ee-md bg-primary text-primary-content group-[.chat-cont]/msg:rounded-se-md' : 'rounded-es-md group-[.chat-cont]/msg:rounded-ss-md border border-base-300/70 bg-base-100 text-base-content'}" dir="auto">${message.message}</span>`;
    html += '</div>';
  }

  if (message.media && message.media.items && message.media.items.length) {
    html += render_message_media_grid({ items: message.media.items, system });
  }

  if (message.gif) {
    html += '<div class="chat-message-media">';
    html += `<img class="block max-h-60 w-60 max-w-full rounded-2xl bg-base-200 object-cover" src="${message.gif}" alt="GIF" loading="lazy">`;
    html += '</div>';
  }

  if (message.is_paid != '1' && message.media && message.media.files && message.media.files.length) {
    html += '<div class="chat-message-media flex w-64 max-w-full flex-col gap-1.5">';
    message.media.files.forEach((file) => {
      html += render_file_card({ file, href: file_href(file, system) });
    });
    html += '</div>';
  }

  if (message.voice_note) {
    html += '<div class="chat-message-media w-72 max-w-full">';
    html += `<audio class="js_audio block h-10 w-full" id="audio-${message.message_id}" controls preload="metadata">`;
    html += `<source src="${uploads}/${message.voice_note}" type="audio/mpeg">`;
    html += `<source src="${uploads}/${message.voice_note}" type="audio/mp3">`;
    html += __('Your browser does not support HTML5 audio');
    html += '</audio></div>';
  }

  if (message.post) {
    html += '<div class="chat-message-media w-64 max-w-full">';
    html += `<a class="chat-product flex w-full items-center gap-3 overflow-hidden rounded-2xl border border-base-300 bg-base-100 p-1.5 transition-colors hover:bg-base-200" href="${url}/posts/${message.post.post_id}">`;
    html += '<div class="chat-product-image size-14 shrink-0 overflow-hidden rounded-xl bg-base-200">';
    html += `<img class="size-full object-cover" src="${uploads}/${message.post.photos[0].source}" alt="" loading="lazy"></div>`;
    html += '<div class="chat-product-info min-w-0 pe-2">';
    html += `<div class="chat-product-title truncate text-sm font-semibold text-base-content" title="${message.post.product.name}">${message.post.product.name}</div>`;
    html += `<div class="chat-product-price text-xs font-semibold text-primary">${message.post.product.price_formatted}</div>`;
    html += '</div></a></div>';
  }

  if (message.is_paid == '1') {
    if (message.can_get_details) {
      html += render_message_media({ message, system });
    } else if (message.needs_payment) {
      html += render_need_payment_message({ message, system, vat_percentage });
    }
  }

  html += '</div>';
  html += render_message_actions({ message, mine, conversation, system, copy_text });
  html += '</div>';

  html += `<div class="conversation-meta flex flex-wrap items-center gap-x-2 gap-y-1 px-1 text-[11px] leading-4 text-base-content/45 group-[.chat-more]/msg:hidden group-[.chat-more]/msg:has-[.seen,.chat-paid-badge]:flex ${mine ? 'justify-end' : ''}">`;
  html += `<div class="time js_moment group-[.chat-more]/msg:hidden" data-time="${message.time}">${message.time}</div>`;
  if (message.sender_fullname) {
    html += `<span class="truncate" title="${escape_attr(__('Replied by') + ' ' + message.sender_fullname)}">${__('Replied by')} ${escape_html(message.sender_fullname)}</span>`;
  }
  if (message.is_paid == '1' && message.can_get_details) {
    html += '<span class="chat-paid-badge badge badge-soft badge-warning h-5 gap-1 rounded-full px-1.5 text-[10px] font-semibold"><span class="icon-[tabler--coin] size-3" aria-hidden="true"></span>' + print_money(message.message_price, system) + '</span>';
  }
  if (conversation && conversation.last_seen_message_id == message.message_id) {
    html += '<span class="seen inline-flex items-center gap-1 text-primary"><span class="icon-[tabler--checks] size-3.5" aria-hidden="true"></span>' + __('Seen by') + ` <span class="js_seen-name-list">${conversation.seen_name_list || ''}</span></span>`;
  }
  html += '</div>';

  if (message.reactions_total_count > 0) {
    html += `<div class="js_chat-reactions-stats js_modal" data-url="posts/who_reacts.php?message_id=${message.message_id}">`;
    html += '<div class="reactions-stats flex cursor-pointer items-center">';
    let z = 10;
    for (const [reaction_type, reaction_count] of Object.entries(message.reactions || {})) {
      if (Number(reaction_count) > 0) {
        html += `<div class="reactions-stats-item relative -ms-1 flex rounded-full bg-base-100 p-px ring-1 ring-base-100 first:ms-0" style="z-index:${z--};"><div class="inline-emoji no_animation inline-flex size-4">${render_reaction_emoji(reaction_type, system)}</div></div>`;
      }
    }
    html += `<span class="ps-1 text-[11px] text-base-content/60">${message.reactions_total_count}</span></div></div>`;
  }

  if (system.chat_translation_enabled == 1 && !is_empty(message.message)) {
    html += `<div class="translate cursor-pointer px-1 text-[11px] font-medium text-primary hover:underline">${__('Tap to translate')}</div>`;
  }

  html += '</div></div></li>';
  return html;
}

function render_message_call({ message, mine, system }) {
  const call = message.call;
  const missed = call.status === 'missed' && !mine;
  const call_back = (call.is_video && system.video_call_enabled == 1) || (!call.is_video && system.audio_call_enabled == 1);
  let icon_class = 'bg-base-200 text-base-content/70';
  if (missed) icon_class = 'bg-error text-error-content';
  else if (mine) icon_class = 'bg-white/20';
  let icon;
  if (call.is_video) {
    icon = call.status === 'completed' ? '<span class="icon-[tabler--video] size-4"></span>' : '<span class="icon-[tabler--video-off] size-4"></span>';
  } else if (call.status !== 'completed') {
    icon = '<span class="icon-[tabler--phone-x] size-4"></span>';
  } else {
    icon = mine ? '<span class="icon-[tabler--phone-outgoing] size-4"></span>' : '<span class="icon-[tabler--phone-incoming] size-4"></span>';
  }
  let title;
  if (missed) title = call.is_video ? __('Missed video call') : __('Missed audio call');
  else title = call.is_video ? __('Video call') : __('Audio call');
  let subtitle = '';
  if (call.status === 'completed') subtitle = call.duration_formatted;
  else if (call.status === 'declined') subtitle = __('Declined');
  else if (mine) subtitle = __('No answer');
  else if (call_back) subtitle = __('Tap to call back');
  const uid = mine ? call.to_user_id : message.user_id;
  const name = mine ? call.to_user_fullname : message.user_fullname;
  const picture = mine ? call.to_user_picture : message.user_picture;
  const bubble_class = mine
    ? 'js_chat-color-me rounded-ee-md bg-primary text-primary-content group-[.chat-cont]/msg:rounded-se-md enabled:hover:opacity-90'
    : 'rounded-es-md border border-base-300/70 bg-base-100 text-base-content group-[.chat-cont]/msg:rounded-ss-md enabled:hover:bg-base-200';
  let html = `<button type="button" class="chat-message-call flex max-w-full items-center gap-2.5 rounded-2xl py-2 ps-2 pe-4 text-start transition-colors disabled:cursor-default ${call_back ? 'js_chat-call-start' : ''} ${bubble_class}" data-type="${call.is_video ? 'video' : 'audio'}" data-uid="${uid}" data-name="${escape_attr(name || '')}" data-picture="${escape_attr(picture || '')}" ${call_back ? `title="${escape_attr(__('Call back'))}"` : 'disabled'}>`;
  html += `<span class="flex size-8 shrink-0 items-center justify-center rounded-full ${icon_class}" aria-hidden="true">${icon}</span>`;
  html += '<span class="flex min-w-0 flex-col">';
  html += `<span class="whitespace-nowrap text-[13px] leading-5 font-semibold">${title}</span>`;
  html += `<span class="whitespace-nowrap text-xs leading-4 tabular-nums ${mine ? 'opacity-75' : 'text-base-content/60'}">${subtitle}</span>`;
  html += '</span>';
  html += '</button>';
  return html;
}

function escape_html(value) {
  return String(value == null ? '' : value)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}

function escape_attr(value) {
  return escape_html(value).replace(/'/g, '&#39;');
}

function render_reaction_emoji(reaction, system) {
  const item = (system.reactions && system.reactions[reaction]) || {};
  return `<div class="emoji inline-flex size-full items-center justify-center rounded-full"><img class="size-full object-contain" src="${item.image_url || ''}" alt="${escape_attr(item.title || reaction)}"></div>`;
}

function render_reactions_container(system) {
  const enabled = system.reactions_enabled || system.reactions || {};
  let html = '<div class="reactions-container fixed z-50 hidden rounded-full border border-base-content/10 bg-base-100 p-1 shadow-xl in-[.chat-widget]:w-max in-[.chat-widget]:p-0.5">';
  let i = 1;
  const animations = ['[&_img]:origin-bottom [&_img]:animate-reaction-bounce', '[&_img]:animate-reaction-heartbeat', '[&_img]:origin-top [&_img]:animate-reaction-swing', '[&_img]:animate-reaction-pulse', '[&_img]:animate-reaction-fade-down', '[&_img]:animate-reaction-swing'];
  for (const [key, reaction] of Object.entries(enabled)) {
    const animation = animations[i - 1] || '[&_img]:animate-reaction-head-shake';
    html += `<div class="reactions_item reaction reaction-${i} js_react-message relative float-start mx-0.5 size-10 p-0.5 in-[.chat-widget]:mx-px in-[.chat-widget]:size-8 animate-reaction-in cursor-pointer transition-[scale,translate] duration-200 hover:z-10 hover:-translate-y-1 hover:scale-125 after:pointer-events-none after:absolute after:-top-1 after:left-1/2 after:-translate-x-1/2 after:-translate-y-full after:rounded-full after:bg-neutral/85 after:px-2 after:text-[10px] after:leading-4 after:font-bold after:whitespace-nowrap after:text-neutral-content after:opacity-0 after:transition-opacity after:content-[attr(data-title)] hover:after:opacity-100 motion-reduce:animate-none motion-reduce:[&_img]:animate-none ${animation}" style="animation-duration: ${i * 100}ms;" data-reaction="${reaction.reaction || key}" data-reaction-color="${reaction.color || ''}" data-title="${escape_attr(__(reaction.title || key))}">`;
    html += render_reaction_emoji(reaction.reaction || key, system);
    html += '</div>';
    i++;
  }
  html += '</div>';
  return html;
}

function render_message_actions({ message, mine, conversation, system, copy_text }) {
  const pinned = conversation && conversation.pinned_message_id == message.message_id;
  let html = `<div class="chat-message-actions flex shrink-0 items-center gap-0.5 opacity-100 transition-opacity md:opacity-0 md:group-hover/msg:opacity-100 md:group-focus-within/msg:opacity-100 md:has-[.dropdown.open]:opacity-100">`;
  html += `<div class="reactions-wrapper relative ${message.i_react ? 'js_unreact-message' : ''}" data-reaction="${message.i_reaction || ''}">`;
  html += `<button type="button" class="btn btn-text btn-circle btn-xs text-base-content/60 hover:text-primary" title="${__('React')}" aria-label="${__('React')}">`;
  if (message.i_react) {
    html += `<span class="reaction-btn-icon inline-flex size-4">${render_reaction_emoji(message.i_reaction, system)}</span>`;
  } else {
    html += '<span class="reaction-btn-icon inline-flex size-4"><span class="icon-[tabler--mood-smile] size-4" aria-hidden="true"></span></span>';
  }
  html += '</button>';
  html += render_reactions_container(system);
  html += '</div>';
  html += `<button type="button" class="btn btn-text btn-circle btn-xs text-base-content/60 hover:text-primary js_reply-message" data-id="${message.message_id}" data-name="${escape_attr(message.user_fullname || '')}" data-snippet="${escape_attr(copy_text || __('Message'))}" title="${__('Reply')}" aria-label="${__('Reply')}"><span class="icon-[tabler--arrow-back-up] size-4" aria-hidden="true"></span></button>`;
  html += `<div class="dropdown relative inline-flex [--offset:4] ${mine ? '[--placement:top-end]' : '[--placement:top-start]'}">`;
  html += `<button type="button" class="dropdown-toggle btn btn-text btn-circle btn-xs text-base-content/60 hover:text-primary dropdown-open:bg-base-content/10 dropdown-open:text-base-content" aria-haspopup="menu" aria-expanded="false" title="${__('More')}" aria-label="${__('More')}"><span class="icon-[tabler--dots] size-4" aria-hidden="true"></span></button>`;
  html += '<div class="dropdown-menu dropdown-open:opacity-100 z-50 hidden w-40 rounded-box border border-base-content/10 bg-base-100 p-1 shadow-xl" role="menu">';
  if (copy_text) html += `<button type="button" class="dropdown-close dropdown-item gap-2.5 rounded-field px-2.5 py-1.5 text-start text-[13px] font-medium text-base-content! js_copy-message" role="menuitem"><span class="icon-[tabler--copy] size-4 shrink-0 text-base-content/55" aria-hidden="true"></span><span>${__('Copy')}</span></button>`;
  html += pinned
    ? `<button type="button" class="dropdown-close dropdown-item gap-2.5 rounded-field px-2.5 py-1.5 text-start text-[13px] font-medium text-base-content! js_unpin-message" role="menuitem" data-cid="${conversation.conversation_id}"><span class="icon-[tabler--pinned-off] size-4 shrink-0 text-base-content/55" aria-hidden="true"></span><span>${__('Unpin')}</span></button>`
    : `<button type="button" class="dropdown-close dropdown-item gap-2.5 rounded-field px-2.5 py-1.5 text-start text-[13px] font-medium text-base-content! js_pin-message" role="menuitem"><span class="icon-[tabler--pin] size-4 shrink-0 text-base-content/55" aria-hidden="true"></span><span>${__('Pin')}</span></button>`;
  html += '<div class="-mx-1 my-1 border-t border-base-content/10" role="separator"></div>';
  if (mine) {
    html += `<button type="button" class="dropdown-close dropdown-item gap-2.5 rounded-field px-2.5 py-1.5 text-start text-[13px] font-medium text-error! hover:bg-error/10! focus-visible:bg-error/10! js_delete-message" role="menuitem"><span class="icon-[tabler--trash] size-4 shrink-0" aria-hidden="true"></span><span>${__('Remove')}</span></button>`;
  } else {
    html += `<button type="button" class="js_modal dropdown-close dropdown-item gap-2.5 rounded-field px-2.5 py-1.5 text-start text-[13px] font-medium text-error! hover:bg-error/10! focus-visible:bg-error/10!" role="menuitem" data-url="data/report.php?do=create&handle=message&id=${message.message_id}"><span class="icon-[tabler--flag] size-4 shrink-0" aria-hidden="true"></span><span>${__('Report')}</span></button>`;
  }
  html += '</div></div></div>';
  return html;
}

function render_chat_pin({ conversation, system }) {
  if (!conversation || !conversation.pinned_message) {
    return '<div class="js_chat-pin-wrap shrink-0"></div>';
  }
  const pinned = conversation.pinned_message;
  const snippet = pinned.message_orginal_decoded || __('Message');
  let html = '<div class="js_chat-pin-wrap shrink-0">';
  html += '<div class="js_chat-pin flex items-center gap-2 border-b border-base-300 bg-base-100 px-4 py-2 sm:px-5">';
  html += `<button type="button" class="js_chat-pin-jump group/pin flex min-w-0 grow items-center gap-3 rounded-field py-0.5 text-start" data-id="${pinned.message_id}">`;
  html += '<span class="flex size-8 shrink-0 items-center justify-center rounded-lg bg-primary/10 text-primary" aria-hidden="true"><span class="icon-[tabler--pinned] size-4"></span></span>';
  html += '<span class="min-w-0">';
  html += `<span class="block truncate text-xs font-semibold text-primary" title="${escape_html(pinned.user_fullname || '')}">${escape_html(pinned.user_fullname || '')}</span>`;
  html += `<span class="block truncate text-sm text-base-content/70 transition-colors group-hover/pin:text-base-content" title="${escape_html(snippet)}">${escape_html(snippet)}</span>`;
  html += '</span></button>';
  html += `<button type="button" class="btn btn-text btn-circle btn-sm shrink-0 text-base-content/50 hover:text-base-content js_unpin-message" data-cid="${conversation.conversation_id}" title="${__('Unpin')}" aria-label="${__('Unpin')}"><span class="icon-[tabler--pinned-off] size-4.5" aria-hidden="true"></span></button>`;
  html += '</div></div>';
  return html;
}

module.exports = { render_message, render_chat_pin };
