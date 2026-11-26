/**
 * sockets -> nodejs -> libs -> traits -> calls
 *
 * @package Sngine
 * @author Zamblek
 */

const crypto = require('crypto');
const jwt = require('jsonwebtoken');
const { query, secure } = require('../core/database');
const { get_picture } = require('../functions');
const { __ } = require('../core/i18n');
const { init_system_datetime } = require('../core/datetime');

/**
 * get_hash_token
 * @return {string}
 */
function get_hash_token() {
  return crypto.randomBytes(24).toString('hex');
}

/**
 * crc32
 * @param {string} value
 * @return {number}
 */
function crc32(value) {
  let crc = 0xffffffff;
  for (const byte of Buffer.from(value)) {
    crc ^= byte;
    for (let i = 0; i < 8; i++) {
      crc = (crc >>> 1) ^ (0xedb88320 & -(crc & 1));
    }
  }
  return (crc ^ 0xffffffff) >>> 0;
}

/**
 * agora_rtc_token
 * @param {string} app_id
 * @param {string} app_certificate
 * @param {string} channel_name
 * @param {string} uid
 * @param {number} privilege_expired
 * @return {string}
 */
function agora_rtc_token(app_id, app_certificate, channel_name, uid, privilege_expired) {
  /* privileges: join channel + publish audio, video & data */
  const privileges = [1, 3, 2, 4];
  const message = Buffer.alloc(10 + privileges.length * 6);
  message.writeUInt32LE(crypto.randomInt(0, 100001), 0);
  message.writeUInt32LE(Math.floor(Date.now() / 1000) + 24 * 3600, 4);
  message.writeUInt16LE(privileges.length, 8);
  privileges.forEach((privilege, index) => {
    message.writeUInt16LE(privilege, 10 + index * 6);
    message.writeUInt32LE(privilege_expired, 12 + index * 6);
  });
  const signature = crypto
    .createHmac('sha256', app_certificate)
    .update(Buffer.concat([Buffer.from(app_id + channel_name + uid), message]))
    .digest();
  const content = Buffer.alloc(2 + signature.length + 10 + message.length);
  let pos = content.writeUInt16LE(signature.length, 0);
  pos += signature.copy(content, pos);
  pos = content.writeUInt32LE(crc32(channel_name), pos);
  pos = content.writeUInt32LE(crc32(uid), pos);
  pos = content.writeUInt16LE(message.length, pos);
  message.copy(content, pos);
  return '006' + app_id + content.toString('base64');
}

module.exports = {
  /**
   * create_call
   * @param {string} type  'audio' | 'video'
   * @param {number} to_user_id
   * @return {Promise<Object|string|false>}
   */
  async create_call(type, to_user_id) {
    const date = init_system_datetime();
    let is_video_call;
    switch (type) {
      case 'audio':
        is_video_call = 0;
        if (this.system.audio_call_enabled != 1) {
          throw new Error(__('The audio call feature has been disabled by the admin'));
        }
        if (!this._data.can_start_audio_call) {
          throw new Error(__("You don't have the permission to do this"));
        }
        break;
      case 'video':
        is_video_call = 1;
        if (this.system.video_call_enabled != 1) {
          throw new Error(__('The video call feature has been disabled by the admin'));
        }
        if (!this._data.can_start_video_call) {
          throw new Error(__("You don't have the permission to do this"));
        }
        break;
      default:
        throw new Error(__('Bad Request'));
    }
    /* check if target user exist */
    const check_target = await query(
      `SELECT COUNT(*) as count FROM users WHERE user_id = ${secure(to_user_id, 'int')}`
    );
    if (check_target.rows[0].count == 0) return false;
    /* check blocking */
    if (await this.blocked(to_user_id)) return false;
    /* check recipients chat privacy */
    await this.check_recipients_chat_privacy([await this.get_user(to_user_id)]);
    /* check if target offline */
    const target_offline = await query(
      `SELECT COUNT(*) as count FROM users WHERE user_id = ${secure(to_user_id, 'int')} AND user_last_seen >= SUBTIME(NOW(), SEC_TO_TIME(${secure(this.system.offline_time, 'int', false)}))`
    );
    if (target_offline.rows[0].count == 0) return 'recipient_offline';
    /* check if target busy */
    const target_busy = await query(
      `SELECT COUNT(*) as count FROM conversations_calls WHERE (from_user_id = ${secure(to_user_id, 'int')} OR to_user_id = ${secure(to_user_id, 'int')}) AND declined = "0" AND updated_time >= SUBTIME(NOW(), SEC_TO_TIME(40))`
    );
    if (target_busy.rows[0].count > 0) return 'recipient_busy';
    /* check if viewer busy */
    const viewer_busy = await query(
      `SELECT COUNT(*) as count FROM conversations_calls WHERE (from_user_id = ${secure(this._data.user_id, 'int')} OR to_user_id = ${secure(this._data.user_id, 'int')}) AND declined = "0" AND updated_time >= SUBTIME(NOW(), SEC_TO_TIME(40))`
    );
    if (viewer_busy.rows[0].count > 0) return 'caller_busy';
    /* check paid call (wallet balance) */
    if (
      this.system.monetization_enabled == 1 &&
      (await this.check_user_permission(to_user_id, 'monetization_permission'))
    ) {
      const to_user_info = await this.get_user(to_user_id);
      if (to_user_info.user_monetization_enabled == 1 && to_user_info.user_monetization_call_price > 0) {
        if (Number(this._data.user_wallet_balance) < Number(to_user_info.user_monetization_call_price)) {
          throw new Error(__('There is not enough credit in your wallet. Recharge your wallet to continue.'));
        }
      }
    }
    /* create a room + provider tokens */
    const room = get_hash_token();
    const caller_token = this.generate_call_token(room, this._data.user_id, true);
    const receiver_token = this.generate_call_token(room, to_user_id, false);
    /* insert the call */
    const insert = await query(
      `INSERT INTO conversations_calls (is_video_call, from_user_id, from_user_token, to_user_id, to_user_token, room, created_time, updated_time) VALUES (${secure(is_video_call)}, ${secure(this._data.user_id, 'int')}, ${secure(caller_token)}, ${secure(to_user_id, 'int')}, ${secure(receiver_token)}, ${secure(room)}, ${secure(date)}, ${secure(date)})`
    );
    return {
      call_id: insert.insertId,
      type,
      is_video: type === 'video',
      is_audio: type === 'audio',
      caller_name: this._data.user_fullname,
      caller_picture: this._data.user_picture,
    };
  },

  /**
   * generate_call_token
   * @param {string} room
   * @param {number} identity_user_id
   * @param {boolean} is_caller
   * @return {string}
   */
  generate_call_token(room, identity_user_id, is_caller) {
    const provider = this.system.audio_video_provider;
    const now = Math.floor(Date.now() / 1000);
    const identity = get_hash_token().substring(0, 15);
    try {
      if (provider === 'twilio') {
        return jwt.sign(
          {
            jti: `${this.system.twilio_apisid}-${now}`,
            iss: this.system.twilio_apisid,
            sub: this.system.twilio_sid,
            exp: now + 3600,
            grants: { identity, video: { room } },
          },
          this.system.twilio_apisecret,
          { algorithm: 'HS256', header: { cty: 'twilio-fpa;v=1', typ: 'JWT' }, noTimestamp: true }
        );
      }
      if (provider === 'livekit') {
        return jwt.sign({ video: { roomJoin: true, room } }, this.system.livekit_api_secret, {
          algorithm: 'HS256',
          issuer: this.system.livekit_api_key,
          subject: identity,
          jwtid: identity,
          expiresIn: 6 * 3600,
        });
      }
      if (provider === 'agora') {
        if (!this.system.agora_call_app_id || !this.system.agora_call_app_certificate) return '';
        return agora_rtc_token(
          this.system.agora_call_app_id,
          this.system.agora_call_app_certificate,
          room,
          String(identity_user_id),
          now + 36000
        );
      }
    } catch (e) {
      console.log(`⚠️ Call token provider "${provider}" error: ${e.message}`);
    }
    return '';
  },

  /**
   * decline_call
   * @param {number} call_id
   * @return {Promise<Object>}
   */
  async decline_call(call_id) {
    const date = init_system_datetime();
    const check_call = await query(
      `SELECT * FROM conversations_calls WHERE call_id = ${secure(call_id, 'int')} AND (from_user_id = ${secure(this._data.user_id, 'int')} OR to_user_id = ${secure(this._data.user_id, 'int')})`
    );
    if (check_call.num_rows === 0) throw new Error(__('You are not authorized to do this'));
    const call = check_call.rows[0];
    const update = await query(
      `UPDATE conversations_calls SET declined = '1', ended_time = ${secure(date)}, ended_by = ${secure(this._data.user_id, 'int')}, updated_time = ${secure(date)} WHERE call_id = ${secure(call_id, 'int')} AND declined = '0'`
    );
    /* log the call */
    if (update.affectedRows > 0) {
      call.log_message_id = await this.log_call(call);
    }
    return call;
  },

  /**
   * get_message_call
   * @param {number} call_id
   * @return {Promise<Object|null>}
   */
  async get_message_call(call_id) {
    const get_call = await query(
      `SELECT conversations_calls.*, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM conversations_calls INNER JOIN users ON conversations_calls.to_user_id = users.user_id WHERE conversations_calls.call_id = ${secure(call_id, 'int')}`
    );
    if (get_call.num_rows === 0) return null;
    const call = get_call.rows[0];
    /* get the call status */
    let status = 'missed';
    if (call.answered_time) {
      status = 'completed';
    } else if (call.ended_by == call.to_user_id) {
      status = 'declined';
    }
    const duration =
      status === 'completed' && call.ended_time
        ? Math.max(0, Math.round((new Date(call.ended_time) - new Date(call.answered_time)) / 1000))
        : 0;
    const pad = (value) => String(value).padStart(2, '0');
    const duration_formatted =
      (duration >= 3600 ? pad(Math.floor(duration / 3600)) + ':' : '') + pad(Math.floor((duration % 3600) / 60)) + ':' + pad(duration % 60);
    return {
      call_id: call.call_id,
      is_video: call.is_video_call == '1',
      status,
      duration,
      duration_formatted,
      to_user_id: call.to_user_id,
      to_user_fullname: this.system.show_usernames_enabled == 1 ? call.user_name : `${call.user_firstname} ${call.user_lastname}`,
      to_user_picture: get_picture(call.user_picture, call.user_gender, this.system),
    };
  },

  /**
   * log_call
   * @param {Object} call
   * @return {Promise<number>}
   */
  async log_call(call) {
    const date = init_system_datetime();
    const other_user_id = call.from_user_id == this._data.user_id ? call.to_user_id : call.from_user_id;
    const receiver_seen = call.answered == '1' ? '1' : '0';
    /* get the conversation (or start new one) */
    let conversation_id = await this.get_mutual_conversation_id([other_user_id]);
    if (!conversation_id) {
      const insert_conversation = await query("INSERT INTO conversations (last_message_id) VALUES ('0')");
      conversation_id = insert_conversation.insertId;
      await query(
        `INSERT INTO conversations_users (conversation_id, user_id, seen) VALUES (${secure(conversation_id, 'int')}, ${secure(call.from_user_id, 'int')}, '1'), (${secure(conversation_id, 'int')}, ${secure(call.to_user_id, 'int')}, '1')`
      );
    }
    /* insert the message */
    const insert_message = await query(
      `INSERT INTO conversations_messages (conversation_id, user_id, message, image, video, voice_note, call_id, time) VALUES (${secure(conversation_id, 'int')}, ${secure(call.from_user_id, 'int')}, '', '', '', '', ${secure(call.call_id, 'int')}, ${secure(date)})`
    );
    const message_id = insert_message.insertId;
    /* update the conversation */
    await query(`UPDATE conversations SET last_message_id = ${secure(message_id, 'int')} WHERE conversation_id = ${secure(conversation_id, 'int')}`);
    await query(
      `UPDATE conversations_users SET seen = '1', deleted = '0' WHERE conversation_id = ${secure(conversation_id, 'int')} AND user_id = ${secure(call.from_user_id, 'int')}`
    );
    await query(
      `UPDATE conversations_users SET seen = '${receiver_seen}', deleted = '0' WHERE conversation_id = ${secure(conversation_id, 'int')} AND user_id = ${secure(call.to_user_id, 'int')}`
    );
    /* update users live messages */
    await query(`UPDATE users SET user_live_messages_lastid = ${secure(message_id, 'int')} WHERE user_id = ${secure(call.from_user_id, 'int')}`);
    await query(
      `UPDATE users SET user_live_messages_lastid = ${secure(message_id, 'int')}${receiver_seen == '0' ? ', user_live_messages_counter = user_live_messages_counter + 1' : ''} WHERE user_id = ${secure(call.to_user_id, 'int')}`
    );
    return message_id;
  },

  /**
   * answer_call
   * @param {number} call_id
   * @return {Promise<Object>}
   */
  async answer_call(call_id) {
    const date = init_system_datetime();
    const check_call = await query(
      `SELECT * FROM conversations_calls WHERE call_id = ${secure(call_id, 'int')} AND to_user_id = ${secure(this._data.user_id, 'int')}`
    );
    if (check_call.num_rows === 0) throw new Error(__('You are not authorized to do this'));
    const call = check_call.rows[0];
    /* paid call */
    if (
      this._data.can_monetize_content &&
      this._data.user_monetization_enabled == 1 &&
      this._data.user_monetization_call_price > 0
    ) {
      throw new Error(
        __('Paid calls are not supported on the NodeJS socket server yet. Use the PHP socket server for monetized calls.')
      );
    }
    await query(
      `UPDATE conversations_calls SET answered = '1', answered_time = ${secure(date)}, updated_time = ${secure(date)} WHERE call_id = ${secure(call_id, 'int')}`
    );
    return call;
  },

  /**
   * update_call
   * @param {number} call_id
   * @return {Promise<void>}
   */
  async update_call(call_id) {
    const date = init_system_datetime();
    const check_call = await query(
      `SELECT COUNT(*) as count FROM conversations_calls WHERE call_id = ${secure(call_id, 'int')} AND (from_user_id = ${secure(this._data.user_id, 'int')} OR to_user_id = ${secure(this._data.user_id, 'int')})`
    );
    if (check_call.rows[0].count == 0) throw new Error(__('You are not authorized to do this'));
    await query(
      `UPDATE conversations_calls SET updated_time = ${secure(date)} WHERE call_id = ${secure(call_id, 'int')}`
    );
  },

  /**
   * get_call_caller_picture (helper used when broadcasting)
   * @param {string} picture
   * @param {string} gender
   * @return {string}
   */
  _caller_picture(picture, gender) {
    return get_picture(picture, gender, this.system);
  },
};
