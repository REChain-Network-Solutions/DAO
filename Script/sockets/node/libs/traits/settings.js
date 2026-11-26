/**
 * sockets -> nodejs -> libs -> traits -> settings
 * 
 * @package Sngine
 * @author Zamblek
 */

const { query, secure } = require('../core/database');

module.exports = {
  /**
   * settings
   * @param {string} edit
   * @param {Object} args
   * @return {Promise<void>}
   */
  async settings(edit, args = {}) {
    switch (edit) {
      case 'chat': {
        const user_chat_enabled = args.user_chat_enabled ? '1' : '0';
        await query(
          `UPDATE users SET user_chat_enabled = ${secure(user_chat_enabled)} WHERE user_id = ${secure(this._data.user_id, 'int')}`
        );
        this._data.user_chat_enabled = user_chat_enabled;
        break;
      }
      default:
        break;
    }
  },
};
