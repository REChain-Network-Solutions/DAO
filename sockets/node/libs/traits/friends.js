/**
 * sockets -> nodejs -> libs -> traits -> friends
 * @package Sngine
 * @author Zamblek
 */

const { query, secure } = require('../core/database');
const { get_picture } = require('../functions');

module.exports = {
  /**
   * get_friends_ids
   * @param {number|null} user_id
   * @return {Promise<Array>}
   */
  async get_friends_ids(user_id = null) {
    user_id = user_id != null ? user_id : this._data.user_id;
    const friends = [];
    const get_friends = await query(
      `SELECT user_id FROM (
          SELECT f.user_two_id AS friend_id FROM friends AS f WHERE f.status = 1 AND f.user_one_id = ${secure(user_id, 'int')}
          UNION
          SELECT f.user_one_id AS friend_id FROM friends AS f WHERE f.status = 1 AND f.user_two_id = ${secure(user_id, 'int')}
        ) AS t
       INNER JOIN users AS u ON friend_id = u.user_id`
    );
    for (const friend of get_friends.rows) friends.push(friend.user_id);
    return friends;
  },

  /**
   * get_followings_ids
   * @param {number|null} user_id
   * @return {Promise<Array>}
   */
  async get_followings_ids(user_id = null) {
    user_id = user_id != null ? user_id : this._data.user_id;
    const followings = [];
    const get_followings = await query(
      `SELECT followings.following_id FROM followings INNER JOIN users ON followings.following_id = users.user_id WHERE users.user_banned = '0' AND followings.user_id = ${secure(user_id, 'int')}`
    );
    for (const following of get_followings.rows) followings.push(following.following_id);
    return followings;
  },

  /**
   * get_friends_or_followings_ids
   * @return {Array}
   */
  get_friends_or_followings_ids() {
    if (this.system.friends_enabled == 1) {
      return this._data.friends_ids;
    }
    return this._data.followings_ids;
  },

  /**
   * spread_ids
   * @param {Array} array
   * @return {string}
   */
  spread_ids(array) {
    return !array || array.length === 0 ? '0' : array.join(',');
  },

  /**
   * filter_ids
   * @param {*} value
   * @return {number|undefined}
   */
  filter_ids(value) {
    if (!isNaN(value)) {
      const int = parseInt(value, 10);
      if (int !== 0) return int;
    }
    return undefined;
  },

  /**
   * friendship_approved
   * @param {number} user_id
   * @return {boolean}
   */
  friendship_approved(user_id) {
    if (this._logged_in) {
      const connections =
        this.system.friends_enabled == 1 ? this._data.friends_ids : this._data.followings_ids;
      return connections.map(String).includes(String(user_id));
    }
    return false;
  },

  /**
   * dating_matched
   * @param {number} user_id
   * @return {Promise<boolean>}
   */
  async dating_matched(user_id) {
    if (this.system.dating_enabled != 1 || !this._logged_in) {
      return false;
    }
    const one = Math.min(Number(user_id), Number(this._data.user_id));
    const two = Math.max(Number(user_id), Number(this._data.user_id));
    const check = await query(
      `SELECT COUNT(*) as count FROM dating_matches WHERE user_one_id = ${secure(one, 'int')} AND user_two_id = ${secure(two, 'int')} AND status = 'active'`
    );
    return check.rows[0].count != 0;
  },

  /**
   * blocked
   * @param {number} user_id
   * @return {Promise<boolean>}
   */
  async blocked(user_id) {
    /* bypass the block if the viewer is admin or moderator */
    if (this._data.user_group < 3) {
      return false;
    }
    if (this._logged_in) {
      const check = await query(
        `SELECT COUNT(*) as count FROM users_blocks WHERE (user_id = ${secure(this._data.user_id, 'int')} AND blocked_id = ${secure(user_id, 'int')}) OR (user_id = ${secure(user_id, 'int')} AND blocked_id = ${secure(this._data.user_id, 'int')})`
      );
      if (check.rows[0].count > 0) return true;
    }
    return false;
  },

  /**
   * get_user
   * @param {number} user_id
   * @param {boolean} full_info
   * @return {Promise<Object|false>}
   */
  async get_user(user_id, full_info = true) {
    const seen_window = full_info
      ? secure(this.system.online_status_timeout, 'int')
      : secure(this.system.offline_time, 'int');
    const requested_info = full_info
      ? `users.*, (users.user_last_seen >= SUBTIME(NOW(), SEC_TO_TIME(${seen_window}))) AS user_is_online, users_groups.permissions_group_id, packages.package_permissions_group_id`
      : `users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, users.user_subscribed, users.user_verified, users.user_last_seen, (users.user_last_seen >= SUBTIME(NOW(), SEC_TO_TIME(${seen_window}))) AS user_is_online`;
    const get_user = await query(
      `SELECT ${requested_info} FROM users LEFT JOIN packages ON users.user_subscribed = '1' AND users.user_package = packages.package_id LEFT JOIN users_groups ON users.user_group = '3' AND users.user_group_custom != '0' AND users.user_group_custom = users_groups.user_group_id WHERE users.user_id = ${secure(user_id, 'int')}`
    );
    if (get_user.num_rows === 0) return false;
    const _user = get_user.rows[0];
    _user.user_picture_default = _user.user_picture ? false : true;
    _user.user_picture = get_picture(_user.user_picture, _user.user_gender, this.system);
    _user.user_fullname =
      this.system.show_usernames_enabled == 1
        ? _user.user_name
        : _user.user_firstname + ' ' + _user.user_lastname;
    return _user;
  },

  /**
   * get_permissions_group
   * @param {number} group_id
   * @return {Promise<Object|false>}
   */
  async get_permissions_group(group_id) {
    const get_group = await query(
      `SELECT * FROM permissions_groups WHERE permissions_group_id = ${secure(group_id, 'int')}`
    );
    if (get_group.num_rows === 0) return false;
    return get_group.rows[0];
  },

  /**
   * check_user_permission
   * @param {number} user_id
   * @param {string} permission
   * @return {Promise<boolean>}
   */
  async check_user_permission(user_id, permission) {
    const get_profile = await query(
      `SELECT users.user_id, users.user_group, users.user_group_custom, users.user_verified, users.user_subscribed, users_groups.permissions_group_id, packages.package_permissions_group_id FROM users LEFT JOIN packages ON users.user_subscribed = '1' AND users.user_package = packages.package_id LEFT JOIN users_groups ON users.user_group = '3' AND users.user_group_custom != '0' AND users.user_group_custom = users_groups.user_group_id WHERE users.user_id = ${secure(user_id, 'int')}`
    );
    if (get_profile.num_rows === 0) return false;
    const profile = get_profile.rows[0];
    /* if user is admin or moderator */
    if (profile.user_group < 3) return true;
    /* get profile permissions group */
    let user_permissions_group = 1;
    if (this.system.packages_enabled == 1 && profile.user_subscribed == 1) {
      if (profile.package_permissions_group_id) {
        user_permissions_group = profile.package_permissions_group_id;
      } else if (profile.user_verified == 1) {
        user_permissions_group = 2;
      }
    } else {
      if (profile.user_group_custom != 0) {
        user_permissions_group = profile.permissions_group_id;
      } else if (profile.user_verified == 1) {
        user_permissions_group = 2;
      }
    }
    const permissions_group = await this.get_permissions_group(user_permissions_group);
    return permissions_group && permissions_group[permission] ? true : false;
  },
};
