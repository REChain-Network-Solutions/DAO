/**
 * sockets -> nodejs -> libs -> functions
 * 
 * @package Sngine
 * @author Zamblek
 */

const { __ } = require('./core/i18n');

/* in-memory typing registry: { [room]: { [userId]: displayName } } (mirrors $GLOBALS['room_typing_list']) */
const room_typing_list = {};

/**
 * get_picture
 *
 * @param {string} picture
 * @param {string} type
 * @param {Object} system
 * @return {string}
 */
function get_picture(picture, type, system) {
  const theme = system && system.theme && system.theme !== 'undefined' ? system.theme : 'default';
  const themePath = `${system.system_url}/content/themes/${theme}/images`;
  if (picture === '' || picture === null || picture === undefined || picture === false) {
    switch (String(type)) {
      case 'page':
        return `${themePath}/blank/blank_page.png`;
      case 'group':
        return `${themePath}/blank/blank_group.png`;
      case 'event':
        return `${themePath}/blank/blank_event.png`;
      case 'blog':
        return `${themePath}/blank/blank_blog.png`;
      case 'movie':
        return `${themePath}/blank/blank_movie.png`;
      case 'game':
        return `${themePath}/blank/blank_game.png`;
      case 'package':
        return `${themePath}/blank/blank_package.png`;
      case 'flag':
        return `${themePath}/blank/blank_flag.png`;
      case 'system':
      case 'static_page_icon':
        return `${themePath}/svg/system/dashboard.svg`;
      case '1':
        return `${themePath}/blank/blank_profile_male.png`;
      case '2':
        return `${themePath}/blank/blank_profile_female.png`;
      default:
        return `${themePath}/blank/blank_profile.png`;
    }
  }
  return `${system.system_uploads}/${picture}`;
}

/**
 * html_entity_decode
 *
 * Mirrors PHP html_entity_decode($value, ENT_QUOTES) for the security-critical
 * entities (used when building display name lists).
 *
 * @param {string} value
 * @return {string}
 */
function html_entity_decode(value) {
  return String(value === null || value === undefined ? '' : value)
    .replace(/&amp;/g, '&')
    .replace(/&lt;/g, '<')
    .replace(/&gt;/g, '>')
    .replace(/&quot;/g, '"')
    .replace(/&#0?39;/g, "'")
    .replace(/&apos;/g, "'");
}

/* ------------------------------- */
/* Socket.io helpers */
/* ------------------------------- */

/**
 * get_all_sockets_user_ids
 *
 * @param {import('socket.io').Server} io
 * @return {Array<number|string>}
 */
function get_all_sockets_user_ids(io) {
  const ids = new Set();
  for (const [, socket] of io.sockets.sockets) {
    if (socket.data && socket.data.userId != null) {
      ids.add(socket.data.userId);
    }
  }
  return [...ids];
}

/**
 * get_all_sockets_by_user_id
 *
 * @param {import('socket.io').Server} io
 * @param {number|string} user_id
 * @return {Array<import('socket.io').Socket>}
 */
function get_all_sockets_by_user_id(io, user_id) {
  const sockets = [];
  for (const [, socket] of io.sockets.sockets) {
    if (socket.data && socket.data.userId == user_id) {
      sockets.push(socket);
    }
  }
  return sockets;
}

/* ------------------------------- */
/* Typing list helpers (mirror includes/functions.php) */
/* ------------------------------- */

function init_room_typing_list(room) {
  if (!room_typing_list[room]) room_typing_list[room] = {};
}

function add_typing_user(room, user_id, user_display_name) {
  if (room_typing_list[room][user_id] === undefined) {
    room_typing_list[room][user_id] = user_display_name;
  }
}

function remove_typing_user(room, user_id) {
  if (room_typing_list[room] && room_typing_list[room][user_id] !== undefined) {
    delete room_typing_list[room][user_id];
  }
}

function cleanup_empty_room_typing_list(room) {
  if (room_typing_list[room] && Object.keys(room_typing_list[room]).length === 0) {
    delete room_typing_list[room];
  }
}

/**
 * cleanup_user_typing_list
 *
 * @param {import('socket.io').Socket} socket
 * @return {string[]}
 */
function cleanup_user_typing_list(socket) {
  const affected_rooms = [];
  for (const room of socket.rooms) {
    if (String(room).indexOf('conversation_') !== 0) continue;
    if (room_typing_list[room] && room_typing_list[room][socket.data.userId] !== undefined) {
      affected_rooms.push(room);
    }
  }
  return affected_rooms;
}

/**
 * handle_typing_change
 *
 * @param {import('socket.io').Server} io
 * @param {string} room
 * @param {import('socket.io').Socket} socket
 * @param {Object} user
 * @param {boolean} is_typing
 * @param {Object} system
 * @param {boolean} as_page
 * @return {Promise<void>}
 */
async function handle_typing_change(io, room, socket, user, is_typing, system, as_page = false) {
  const conversation_id = room.replace('conversation_', '');
  let user_display_name = html_entity_decode(
    system.show_usernames_enabled == 1 ? user._data.user_name : user._data.user_firstname
  );
  if (as_page) {
    /* page inbox -> type as the page */
    const page_id = await user.check_page_conversation_access(conversation_id);
    const page = page_id ? await user.get_chat_page(page_id) : false;
    if (!page) return;
    user_display_name = html_entity_decode(page.page_title);
  }
  init_room_typing_list(room);
  if (is_typing) {
    add_typing_user(room, socket.data.userId, user_display_name);
  } else {
    remove_typing_user(room, socket.data.userId);
  }
  /* broadcast typing list to other users in the room */
  const room_clients = await io.in(room).fetchSockets();
  for (const client of room_clients) {
    if (client.data.userId == null) continue;
    const others = { ...room_typing_list[room] };
    delete others[client.data.userId];
    const typing_name_list = Object.values(others).join(', ');
    client.emit('event_server_typing', {
      conversation_id,
      typing_name_list,
    });
  }
  print(
    `💬 [Emit] User {username: ${socket.data.username}, user_id: ${socket.data.userId}} Room: ${room} - Typing: ${is_typing ? 'true' : 'false'}`
  );
  /* cleanup empty room typing list */
  cleanup_empty_room_typing_list(room);
  /* update typing status */
  await user.update_conversation_typing_status(conversation_id, is_typing, as_page);
}

/**
 * get_user_age
 * @param {string|null} birthdate
 * @return {number|null}
 */
function get_user_age(birthdate) {
  if (!birthdate) return null;
  const parts = String(birthdate).split('-');
  if (parts.length !== 3) return null;
  const birth = new Date(Date.UTC(parseInt(parts[0], 10), parseInt(parts[1], 10) - 1, parseInt(parts[2], 10)));
  if (isNaN(birth.getTime())) return null;
  const today = new Date();
  let age = today.getUTCFullYear() - birth.getUTCFullYear();
  const monthDiff = today.getUTCMonth() - birth.getUTCMonth();
  if (monthDiff < 0 || (monthDiff === 0 && today.getUTCDate() < birth.getUTCDate())) {
    age--;
  }
  return age;
}

/**
 * print_money
 * @param {number} amount
 * @param {Object} system
 * @return {string}
 */
function print_money(amount, system) {
  const formatted = Number(amount || 0).toFixed(2);
  const symbol = system.system_currency_symbol || '$';
  const dir = system.system_currency_dir || 'left';
  return dir === 'right' ? formatted + symbol : symbol + formatted;
}

/**
 * round_payment
 * @param {number} value
 * @return {number}
 */
function round_payment(value) {
  return Math.round(Number(value) * 100) / 100;
}

/**
 * get_payment_vat_value
 * @param {number} amount
 * @param {Object} system
 * @param {number|null} vat_percentage
 * @return {number}
 */
function get_payment_vat_value(amount, system, vat_percentage = null) {
  let vat = 0;
  if (system.payment_vat_enabled == 1) {
    const percentage =
      vat_percentage != null ? Number(vat_percentage) : Number(system.payment_vat_percentage) || 0;
    vat = (Number(amount) * percentage) / 100;
  }
  return vat;
}

/**
 * get_payment_fees_value
 * @param {number} amount
 * @param {Object} system
 * @return {number}
 */
function get_payment_fees_value(amount, system) {
  let fees = 0;
  if (system.payment_fees_enabled == 1) {
    fees = (Number(amount) * Number(system.payment_fees_percentage)) / 100;
  }
  return fees;
}

/**
 * get_payment_total_value
 * @param {number} amount
 * @param {Object} system
 * @param {number|null} vat_percentage
 * @param {boolean} printed
 * @return {string}
 */
function get_payment_total_value(amount, system, vat_percentage = null, printed = false) {
  const total = round_payment(
    Number(amount) +
    get_payment_vat_value(amount, system, vat_percentage) +
    get_payment_fees_value(amount, system)
  );
  return printed ? print_money(total, system) : String(total);
}

/**
 * build_paid_message_payment_options
 * @param {number} message_id
 * @param {number} price
 * @param {Object} system
 * @param {number|null} vat_percentage
 * @return {string}
 */
function build_paid_message_payment_options(message_id, price, system, vat_percentage = null) {
  const vat = round_payment(get_payment_vat_value(price, system, vat_percentage));
  const fees = round_payment(get_payment_fees_value(price, system));
  const total = get_payment_total_value(price, system, vat_percentage);
  const total_printed = get_payment_total_value(price, system, vat_percentage, true);
  return (
    '{ "handle": "paid_message", "paid_message": "true", "id": ' +
    Number(message_id) +
    ', "price": ' +
    Number(price) +
    ', "vat": "' +
    vat +
    '", "fees": "' +
    fees +
    '", "total": "' +
    total +
    '", "total_printed": "' +
    total_printed +
    '" }'
  );
}

/**
 * is_valid_upload_source
 *
 * Mirrors the PHP is_valid_upload_source() guard: only accept relative upload
 * paths under the known media folders, with no traversal or absolute paths.
 *
 * @param {string} source
 * @return {boolean}
 */
function is_valid_upload_source(source) {
  if (typeof source !== 'string' || source === '') {
    return false;
  }
  if (source.includes('..') || source.includes('\0')) {
    return false;
  }
  if (source[0] === '/' || source.includes('\\')) {
    return false;
  }
  return /^(files|photos|sounds|videos)\/\d{4}\/\d{2}\/[A-Za-z0-9._-]+\.[A-Za-z0-9]+$/.test(source);
}

/**
 * print
 *
 * Thin console logger mirroring the PHP server's print() lines.
 *
 * @param {string} message
 * @return {void}
 */
function print(message) {
  console.log(message);
}

module.exports = {
  room_typing_list,
  get_picture,
  html_entity_decode,
  get_user_age,
  print_money,
  build_paid_message_payment_options,
  get_all_sockets_user_ids,
  get_all_sockets_by_user_id,
  handle_typing_change,
  cleanup_user_typing_list,
  is_valid_upload_source,
  print,
  __,
};
