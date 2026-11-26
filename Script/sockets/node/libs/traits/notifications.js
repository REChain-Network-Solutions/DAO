/**
 * sockets -> nodejs -> libs -> traits -> notifications
 *
 * @package Sngine
 * @author Zamblek
 */

const { query, secure } = require('../core/database');
const { init_system_datetime } = require('../core/datetime');

module.exports = {
  /**
   * post_notification
   * @param {Object} args
   * @return {Promise<void>}
   */
  async post_notification(args = {}) {
    const date = init_system_datetime();
    const to_user_id = args.to_user_id;
    const from_user_id = args.from_user_id ?? this._data.user_id;
    const from_user_type = args.from_user_type ?? 'user';
    const action = args.action;
    const node_type = args.node_type ?? '';
    const node_url = args.node_url ?? '';
    const message = args.message ?? '';
    const notify_id = args.notify_id ?? '';
    const system_notification = args.system_notification ?? false;

    if (to_user_id == null || action == null) return;

    if (!system_notification) {
      /* don't notify yourself (except async/system actions) */
      if (
        this._data.user_id == to_user_id &&
        !['async_request', 'video_converted'].includes(action)
      ) {
        return;
      }
    }

    /* ensure the receiver exists */
    const get_receiver = await query(
      `SELECT COUNT(*) as count FROM users WHERE user_id = ${secure(to_user_id, 'int')}`
    );
    if (get_receiver.rows[0].count == 0) return;

    /* insert notification */
    const inserted = await query(
      `INSERT INTO notifications (to_user_id, from_user_id, from_user_type, action, node_type, node_url, notify_id, message, time) VALUES (${secure(to_user_id, 'int')}, ${secure(from_user_id, 'int')}, ${secure(from_user_type)}, ${secure(action)}, ${secure(node_type)}, ${secure(node_url)}, ${secure(notify_id)}, ${secure(message)}, ${secure(date)})`
    );

    /* bump the live notifications counter and the newest id (chat messages are excluded, like PHP) */
    if (action != 'chat_message') {
      await query(
        `UPDATE users SET user_live_notifications_counter = user_live_notifications_counter + 1, user_live_notifications_lastid = GREATEST(user_live_notifications_lastid, ${secure(inserted.insertId, 'int', false)}) WHERE user_id = ${secure(to_user_id, 'int')}`
      );
    }
  },
};
