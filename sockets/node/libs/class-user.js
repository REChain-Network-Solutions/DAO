/**
 * sockets -> nodejs -> libs -> class-user
 *
 * @package Sngine
 * @author Zamblek
 */

const { query, secure } = require('./core/database');
const { decode_jwt } = require('./core/jwt');
const { get_picture } = require('./functions');

/* feature traits */
const friendsTrait = require('./traits/friends');
const chatTrait = require('./traits/chat');
const callsTrait = require('./traits/calls');
const liveTrait = require('./traits/live');
const nodesTrait = require('./traits/nodes');
const notificationsTrait = require('./traits/notifications');
const settingsTrait = require('./traits/settings');

let walletTrait = {};
try {
  walletTrait = require('./traits/wallet');
} catch (err) {
  if (err.code !== 'MODULE_NOT_FOUND') {
    throw err;
  }
}

let monetizationTrait = {};
try {
  monetizationTrait = require('./traits/monetization');
} catch (err) {
  if (err.code !== 'MODULE_NOT_FOUND') {
    throw err;
  }
}

class User {
  /**
   * @param {Object} system  the loaded system settings
   */
  constructor(system) {
    this.system = system;
    this._data = {};
    this._logged_in = false;
    this._is_admin = false;
    this._is_moderator = false;
    this._is_banned = false;
  }

  /**
   * authenticate
   *
   * Factory that mirrors `new User($jwt)` — async because it hits the DB.
   *
   * @param {string} jwt
   * @param {Object} system
   * @return {Promise<User>}
   * @throws {Error} when the token/session is invalid
   */
  static async authenticate(jwt, system) {
    const user = new User(system);
    /* decode + validate the JWT */
    const decoded = decode_jwt(jwt, system.system_jwt_key);
    const user_id = decoded.uid;
    const user_token = decoded.token;
    if (user_id == null || user_token == null) {
      throw new Error('Invalid Client JWT');
    }
    /* validate the session token */
    const get_user = await query(
      `SELECT users.*, users_sessions.session_id, users_sessions.session_token FROM users INNER JOIN users_sessions ON users.user_id = users_sessions.user_id WHERE users_sessions.user_id = ${secure(user_id, 'int')} AND users_sessions.session_token = ${secure(user_token)}`
    );
    if (get_user.num_rows === 0) {
      throw new Error('Invalid session');
    }
    user._data = get_user.rows[0];

    /* flags */
    user._logged_in = true;
    user._is_admin = user._data.user_group == 1;
    user._is_moderator = user._data.user_group == 2;
    user._is_banned = !user._is_admin && user._data.user_banned == 1;

    /* full name */
    user._data.user_fullname =
      system.show_usernames_enabled == 1
        ? user._data.user_name
        : user._data.user_firstname + ' ' + user._data.user_lastname;

    /* picture (users.user_picture holds the raw source) */
    user._data.user_picture_raw = user._data.user_picture;
    user._data.user_picture_default = user._data.user_picture ? false : true;
    user._data.user_picture = get_picture(user._data.user_picture, user._data.user_gender, system);

    /* connections */
    user._data.friends_ids = await user.get_friends_ids();
    user._data.followings_ids = await user.get_followings_ids();

    /* call & monetization permissions (self) */
    user._data.can_start_audio_call =
      system.audio_call_enabled == 1 &&
      (await user.check_user_permission(user._data.user_id, 'audio_call_permission'));
    user._data.can_start_video_call =
      system.video_call_enabled == 1 &&
      (await user.check_user_permission(user._data.user_id, 'video_call_permission'));
    user._data.can_monetize_content =
      system.monetization_enabled == 1 &&
      (await user.check_user_permission(user._data.user_id, 'monetization_permission'));

    /* update last seen (mirrors the PHP constructor) */
    await query(`UPDATE users SET user_last_seen = NOW() WHERE user_id = ${secure(user._data.user_id, 'int')}`);

    return user;
  }
}

/* compose the feature traits onto the prototype (mirrors PHP's `use ...Trait`) */
Object.assign(
  User.prototype,
  friendsTrait,
  chatTrait,
  callsTrait,
  liveTrait,
  nodesTrait,
  notificationsTrait,
  settingsTrait,
  walletTrait,
  monetizationTrait
);

module.exports = User;
