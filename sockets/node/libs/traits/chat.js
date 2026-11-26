/**
 * sockets -> nodejs -> libs -> traits -> chat
 *
 * @package Sngine
 * @author Zamblek
 */

const { query, secure, html_entities, is_empty } = require('../core/database');
const { get_picture, html_entity_decode, is_valid_upload_source, get_user_age } = require('../functions');
const { __ } = require('../core/i18n');
const { init_system_datetime } = require('../core/datetime');
const {
  BadRequestException,
  ValidationException,
  AuthorizationException,
  PrivacyException,
} = require('../core/exceptions');

/**
 * nl2br
 * @param {string} text
 * @return {string}
 */
function nl2br(text) {
  return String(text === null || text === undefined ? '' : text).replace(/\r\n|\n\r|\n|\r/g, '<br />$&');
}

function sanitize_upload_file_name(name) {
  return String(name || '').replace(/[\0/\\]/g, '').split(/[/\\]/).pop().slice(0, 256);
}

function decorate_file_attachment(file) {
  file.name = String(file.name || '').trim();
  file.size = parseInt(file.size, 10) || 0;
  file.type = '';
  file.size_formatted = '';
  if (file.name) {
    const extension = file.name.includes('.') ? file.name.split('.').pop() : '';
    if (extension && extension !== file.name) file.type = extension.toUpperCase();
  }
  if (file.size > 0) {
    const units = ['B', 'KB', 'MB', 'GB'];
    const unit = Math.min(3, Math.floor(Math.log(Math.max(1, file.size)) / Math.log(1024)));
    const value = file.size / Math.pow(1024, unit);
    file.size_formatted = (unit ? value.toFixed(1) : String(Math.floor(value))) + ' ' + units[unit];
  }
  return file;
}

/**
 * popover
 * Minimal port — the profile name anchor used in conversation.name_html.
 * @param {number} user_id
 * @param {string} user_name
 * @param {string} fullname
 * @return {string}
 */
function popover(user_id, user_name, fullname) {
  return `<a href="#" data-uid="${user_id}" data-hovercard="${user_name}">${fullname}</a>`;
}

module.exports = {
  /**
   * user_online
   * @param {number} user_id
   * @return {Promise<boolean>}
   */
  async user_online(user_id) {
    if (!this.friendship_approved(user_id)) return false;
    const get_user_status = await query(
      `SELECT COUNT(*) as count FROM users WHERE user_id = ${secure(user_id, 'int')} AND user_chat_enabled = '1' AND user_privacy_chat != 'me' AND user_last_seen >= SUBTIME(NOW(), SEC_TO_TIME(${secure(this.system.offline_time, 'int', false)}))`
    );
    return get_user_status.rows[0].count != 0;
  },

  /**
   * get_conversation
   * @param {number} conversation_id
   * @param {boolean} as_page
   * @return {Promise<Object|false>}
   */
  async get_conversation(conversation_id, as_page = false) {
    let get_conversation;
    if (as_page) {
      /* page inbox (the viewer manages the page) */
      get_conversation = await query(
        `SELECT conversations.*, pages_conversations.seen FROM conversations INNER JOIN pages_conversations ON conversations.conversation_id = pages_conversations.conversation_id WHERE conversations.conversation_id = ${secure(conversation_id, 'int')}`
      );
    } else {
      get_conversation = await query(
        `SELECT conversations.*, conversations_users.seen FROM conversations INNER JOIN conversations_users ON conversations.conversation_id = conversations_users.conversation_id WHERE conversations_users.user_id = ${secure(this._data.user_id, 'int')} AND conversations.conversation_id = ${secure(conversation_id, 'int')}`
      );
    }
    if (get_conversation.num_rows === 0) return false;
    const conversation = get_conversation.rows[0];
    if (as_page && !(await this.check_page_adminship(this._data.user_id, conversation.node_id))) return false;
    conversation.custom_name = String(conversation.name || '').trim();

    /* get recipients */
    const get_recipients = await query(
      `SELECT conversations_users.seen, conversations_users.deleted, conversations_users.typing, users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, users.user_subscribed, users.user_verified, users.user_monetization_enabled, users.user_monetization_chat_price, users.user_monetization_call_price, users.user_privacy_chat, users.user_last_seen FROM conversations_users INNER JOIN users ON conversations_users.user_id = users.user_id WHERE conversations_users.conversation_id = ${secure(conversation.conversation_id, 'int')} AND conversations_users.user_id != ${secure(this._data.user_id, 'int')}`
    );
    const recipients = get_recipients.rows;
    const recipients_num = recipients.length;
    if ((!conversation.node_id || as_page) && recipients_num === 0) return false;

    conversation.recipients = [];
    conversation.chat_price = 0;
    conversation.call_price = 0;
    conversation.paid_recipients = [];
    conversation.name_list = conversation.name_list || '';
    conversation.typing_name_list = conversation.typing_name_list || '';
    conversation.seen_name_list = conversation.seen_name_list || '';

    let i = 1;
    for (const recipient of recipients) {
      /* check if paid chat */
      if (
        this.system.monetization_enabled == 1 &&
        !(await this.dating_matched(recipient.user_id)) &&
        (await this.check_user_permission(recipient.user_id, 'monetization_permission')) &&
        recipient.user_monetization_enabled == 1 &&
        (recipient.user_monetization_chat_price > 0 || recipient.user_monetization_call_price > 0)
      ) {
        conversation.chat_price += Number(recipient.user_monetization_chat_price);
        conversation.call_price += Number(recipient.user_monetization_call_price);
        conversation.paid_recipients.push(recipient);
      }
      /* get recipient picture */
      recipient.user_picture = get_picture(recipient.user_picture, recipient.user_gender, this.system);
      conversation.recipients.push(recipient);

      /* typing recipients */
      if (this.system.chat_typing_enabled == 1 && recipient.typing == 1) {
        const status = await query(
          `SELECT COUNT(*) as count FROM users WHERE user_id = ${secure(recipient.user_id, 'int')} AND user_last_seen >= SUBTIME(NOW(), SEC_TO_TIME(${secure(this.system.offline_time, 'int', false)}))`
        );
        if (status.rows[0].count == 0) {
          await query(
            `UPDATE conversations_users SET typing = '0' WHERE conversation_id = ${secure(conversation_id, 'int')} AND user_id = ${secure(recipient.user_id, 'int')}`
          );
        } else {
          if (conversation.typing_name_list) conversation.typing_name_list += ', ';
          conversation.typing_name_list += (
            this.system.show_usernames_enabled == 1 ? recipient.user_name : recipient.user_firstname
          );
        }
      }
      /* seen recipients */
      if (this.system.chat_seen_enabled == 1 && recipient.seen == 1) {
        if (conversation.seen_name_list) conversation.seen_name_list += ', ';
        conversation.seen_name_list += (
          this.system.show_usernames_enabled == 1 ? recipient.user_name : recipient.user_firstname
        );
      }
      /* name_list */
      conversation.name_list += (
        this.system.show_usernames_enabled == 1 ? recipient.user_name : recipient.user_firstname
      );
      if (i < recipients_num) conversation.name_list += ', ';
      i++;
    }

    /* prepare conversation with multiple_recipients */
    const show = this.system.show_usernames_enabled == 1;
    switch (conversation.node_type) {
      case 'group': {
        const group = await this.get_group(conversation.node_id);
        conversation.multiple_recipients = true;
        conversation.link = 'groups/' + (group ? group.group_name : conversation.node_id);
        conversation.picture = get_picture(group ? group.group_picture : '', 'group', this.system);
        conversation.name = __('Group') + ': ' + (group ? group.group_title : '');
        break;
      }
      case 'event': {
        const event = await this.get_event(conversation.node_id);
        conversation.multiple_recipients = true;
        conversation.link = 'events/' + conversation.node_id;
        conversation.picture = get_picture(event ? event.event_cover : '', 'event', this.system);
        conversation.name = __('Event') + ': ' + (event ? event.event_title : '');
        break;
      }
      case 'page': {
        const page = await this.get_chat_page(conversation.node_id);
        conversation.page_id = conversation.node_id;
        conversation.page_messages_enabled = !!(page && page.page_messages_enabled == 1 && this.system.pages_enabled == 1 && this.system.pages_messages_enabled == 1);
        if (!as_page) {
          /* the viewer is the customer -> the page is the recipient */
          const get_page_conversation = await query(
            `SELECT seen, typing FROM pages_conversations WHERE conversation_id = ${secure(conversation.conversation_id, 'int')}`
          );
          const page_conversation = get_page_conversation.rows[0] || {};
          conversation.multiple_recipients = false;
          conversation.link = page ? 'pages/' + page.page_name : 'messages/' + conversation.conversation_id;
          conversation.picture = page ? page.page_picture : get_picture('', 'page', this.system);
          conversation.name = page ? page.page_title : __('Page');
          conversation.name_list = conversation.name;
          conversation.name_html = `<a href="${this.system.system_url}/${conversation.link}">${conversation.name}</a>`;
          if (this.system.chat_seen_enabled == 1 && page_conversation.seen == 1) {
            conversation.seen_name_list = conversation.name;
          }
          if (this.system.chat_typing_enabled == 1 && page_conversation.typing == 1) {
            conversation.typing_name_list = conversation.name;
          }
          break;
        }
        /* the viewer manages the page -> the customer is the recipient */
        conversation.as_page = true;
        conversation.page_name = page ? page.page_name : '';
        conversation.page_title = page ? page.page_title : '';
      }
      /* falls through */
      default:
        if (recipients_num > 1) {
          conversation.multiple_recipients = true;
          conversation.link = 'messages/' + conversation.conversation_id;
          conversation.picture_left = conversation.recipients[0].user_picture;
          conversation.picture_right = conversation.recipients[1].user_picture;
          const n0 = (show ? conversation.recipients[0].user_name : conversation.recipients[0].user_firstname);
          const n1 = (show ? conversation.recipients[1].user_name : conversation.recipients[1].user_firstname);
          if (recipients_num > 2) {
            conversation.name = `${n0}, ${n1} & ${recipients_num - 2} ${__('more')}`;
          } else {
            conversation.name = `${n0} & ${n1}`;
          }
        } else {
          conversation.multiple_recipients = false;
          conversation.user_id = conversation.recipients[0].user_id;
          conversation.link = conversation.recipients[0].user_name;
          conversation.picture = conversation.recipients[0].user_picture;
          conversation.name = (
            show
              ? conversation.recipients[0].user_name
              : conversation.recipients[0].user_firstname + ' ' + conversation.recipients[0].user_lastname
          );
          conversation.name_html = popover(
            conversation.recipients[0].user_id,
            conversation.recipients[0].user_name,
            show
              ? conversation.recipients[0].user_name
              : conversation.recipients[0].user_firstname + ' ' + conversation.recipients[0].user_lastname
          );
          conversation.user_is_online = await this.user_online(conversation.recipients[0].user_id);
          conversation.user_last_seen = conversation.recipients[0].user_last_seen;
        }
        break;
    }

    if (conversation.custom_name && conversation.multiple_recipients && !conversation.node_id) {
      conversation.name = conversation.custom_name;
    }

    conversation.is_chatbox = this.is_chatbox_conversation(conversation);
    conversation.total_messages = await this.get_conversation_total_messages(conversation_id);
    conversation.last_message = await this.get_conversation_message_by_id(conversation.last_message_id, null, as_page);
    conversation.pinned_message = null;
    if (conversation.pinned_message_id) {
      conversation.pinned_message = await this.get_conversation_message_by_id(conversation.pinned_message_id, null, as_page);
      if (!conversation.pinned_message) {
        conversation.pinned_message_id = null;
      }
    }
    return conversation;
  },

  /**
   * is_my_message
   * @param {Object} message
   * @param {boolean} as_page
   * @return {boolean}
   */
  is_my_message(message, as_page = false) {
    if (as_page) return !!message.page_id;
    return !message.page_id && message.user_id == this._data.user_id;
  },

  /**
   * is_chatbox_conversation
   * @param {Object} conversation
   * @return {boolean}
   */
  is_chatbox_conversation(conversation) {
    return ['group', 'event'].includes(conversation.node_type);
  },

  /**
   * get_page_conversation_id
   * @param {number} page_id
   * @param {number} user_id
   * @return {Promise<number|false>}
   */
  async get_page_conversation_id(page_id, user_id) {
    const get_conversation = await query(
      `SELECT conversation_id FROM pages_conversations WHERE page_id = ${secure(page_id, 'int')} AND user_id = ${secure(user_id, 'int')}`
    );
    if (get_conversation.num_rows === 0) return false;
    return get_conversation.rows[0].conversation_id;
  },

  /**
   * get_conversation_page_id
   * @param {number} conversation_id
   * @return {Promise<number|false>}
   */
  async get_conversation_page_id(conversation_id) {
    const get_conversation = await query(
      `SELECT node_id FROM conversations WHERE conversation_id = ${secure(conversation_id, 'int')} AND node_type = 'page'`
    );
    if (get_conversation.num_rows === 0) return false;
    return get_conversation.rows[0].node_id;
  },

  /**
   * check_page_conversation_access
   * @param {number} conversation_id
   * @return {Promise<number|false>}
   */
  async check_page_conversation_access(conversation_id) {
    const page_id = await this.get_conversation_page_id(conversation_id);
    if (!page_id || !(await this.check_page_adminship(this._data.user_id, page_id))) return false;
    return page_id;
  },

  /**
   * get_conversation_members_ids
   * @param {number} conversation_id
   * @return {Promise<Array>}
   */
  async get_conversation_members_ids(conversation_id) {
    const get_members = await query(
      `SELECT user_id FROM conversations_users WHERE conversation_id = ${secure(conversation_id, 'int')}`
    );
    let members_ids = get_members.rows.map((row) => row.user_id);
    /* page conversation -> add the page admins */
    const page_id = await this.get_conversation_page_id(conversation_id);
    if (page_id) {
      members_ids = members_ids.concat(await this.get_page_admins_ids(page_id));
    }
    return [...new Set(members_ids.map(Number))];
  },

  /**
   * delete_page_conversation
   * @param {number} conversation_id
   * @return {Promise<void>}
   */
  async delete_page_conversation(conversation_id) {
    await query(`DELETE FROM conversations_messages_media WHERE message_id IN (SELECT message_id FROM conversations_messages WHERE conversation_id = ${secure(conversation_id, 'int')})`);
    await query(`DELETE FROM conversations_messages_reactions WHERE message_id IN (SELECT message_id FROM conversations_messages WHERE conversation_id = ${secure(conversation_id, 'int')})`);
    await query(`DELETE FROM conversations_messages WHERE conversation_id = ${secure(conversation_id, 'int')}`);
    await query(`DELETE FROM conversations WHERE conversation_id = ${secure(conversation_id, 'int')}`);
    await query(`DELETE FROM conversations_users WHERE conversation_id = ${secure(conversation_id, 'int')}`);
    await query(`DELETE FROM pages_conversations WHERE conversation_id = ${secure(conversation_id, 'int')}`);
  },

  /**
   * get_mutual_conversation_id
   * @param {Array} recipients
   * @param {boolean} check_deleted
   * @return {Promise<number|false>}
   */
  async get_mutual_conversation_id(recipients, check_deleted = false) {
    let recipients_array = (Array.isArray(recipients) ? recipients : [recipients])
      .map((v) => this.filter_ids(v))
      .filter((v) => v !== undefined);
    if (recipients_array.length === 0) {
      throw new BadRequestException(__('Conversation recipients is required'));
    }
    recipients_array.push(this._data.user_id);
    const recipients_list = this.spread_ids(recipients_array);
    const get_mutual = await query(
      `SELECT conversations.conversation_id FROM conversations_users INNER JOIN conversations ON conversations_users.conversation_id = conversations.conversation_id WHERE conversations.node_id IS NULL AND conversations_users.user_id IN (${recipients_list}) GROUP BY conversations.conversation_id HAVING COUNT(conversations.conversation_id) = ${recipients_array.length}`
    );
    if (get_mutual.num_rows === 0) return false;
    for (const mutual of get_mutual.rows) {
      const where_statement = check_deleted ? " AND deleted != '1' " : '';
      const get_recipients = await query(
        `SELECT COUNT(*) as count FROM conversations_users WHERE conversation_id = ${secure(mutual.conversation_id, 'int')}${where_statement}`
      );
      if (get_recipients.rows[0].count == recipients_array.length) {
        return mutual.conversation_id;
      }
    }
    return false;
  },

  /**
   * check_recipients_chat_privacy
   * @param {Array} recipients
   * @return {void}
   */
  async check_recipients_chat_privacy(recipients) {
    const show = this.system.show_usernames_enabled == 1;
    /* dating matches can always chat */
    if (recipients.length == 1 && (await this.dating_matched(recipients[0].user_id))) {
      return;
    }
    if (this._data.user_privacy_chat == 'me') {
      throw new PrivacyException(
        __('You set your chat privacy to no one, Go to your privacy settings to change this')
      );
    }
    for (const recipient of recipients) {
      const fullname = show
        ? recipient.user_name
        : recipient.user_firstname + ' ' + recipient.user_lastname;
      if (
        recipient.user_privacy_chat == 'me' ||
        (recipient.user_privacy_chat == 'friends' && !this.friendship_approved(recipient.user_id))
      ) {
        throw new PrivacyException(__("You can't chat with this") + ' ' + fullname);
      }
      if (
        this._data.user_privacy_chat == 'friends' &&
        !this.friendship_approved(recipient.user_id)
      ) {
        throw new PrivacyException(
          __("You can't chat with this") +
          ' ' +
          fullname +
          ' ' +
          __('because your chat privacy is set to friends only')
        );
      }
    }
  },

  /**
   * post_conversation_message
   * @param {Object} args
   * @param {boolean} from_web
   * @return {Promise<Object>}
   */
  async post_conversation_message(args = {}, from_web = false) {
    const date = init_system_datetime();
    let message = args.message ?? '';
    let photo = args.photo ?? '';
    let video = args.video ?? '';
    let voice_note = args.voice_note ?? '';
    const gif = args.gif ?? '';
    let product_post_id = args.product_post_id ?? null;
    let story_id = args.story_id ?? null;
    let reply_to = args.reply_to ?? null;
    if (reply_to && isNaN(reply_to)) {
      throw new BadRequestException(__('Invalid request'));
    }
    reply_to = reply_to ? parseInt(reply_to, 10) : null;
    let conversation_id = args.conversation_id ?? null;
    let recipients = args.recipients ?? null;
    let page_id = args.page_id ?? null;
    let as_page = !!args.as_page && args.as_page !== 'false';
    if (page_id && isNaN(page_id)) {
      throw new BadRequestException(__('Invalid request'));
    }
    /* check if story reply */
    if (story_id) {
      const story = this.system.stories_enabled == 1 && this.system.stories_replies_enabled == 1 ? await this.get_story(story_id) : false;
      if (!story || story.user_id == this._data.user_id) {
        throw new BadRequestException(__('This story is no longer available'));
      }
      story_id = parseInt(story.story_id, 10);
      reply_to = null;
      conversation_id = null;
      page_id = null;
      as_page = false;
      recipients = JSON.stringify([parseInt(story.user_id, 10)]);
    }

    /* filter web-encoded uploads (they arrive JSON-encoded) */
    if (photo && from_web) photo = JSON.parse(photo);
    if (video && from_web) video = JSON.parse(video);
    if (voice_note && from_web) voice_note = JSON.parse(voice_note);
    const upload_source = (item) => {
      const source = item && typeof item === 'object' ? item.source : item;
      if (!is_valid_upload_source(source)) {
        throw new BadRequestException(__('Bad Request'));
      }
      return source;
    };
    const media_sources = (media) => {
      if (media && typeof media === 'string') media = JSON.parse(media);
      if (!media || typeof media !== 'object') return [];
      return (Array.isArray(media) ? media : Object.values(media)).map(upload_source);
    };
    const media_files = (media) => {
      if (media && typeof media === 'string') media = JSON.parse(media);
      if (!media || typeof media !== 'object') return [];
      return (Array.isArray(media) ? media : Object.values(media)).map((item) => ({
        source: upload_source(item),
        name: sanitize_upload_file_name(item && typeof item === 'object' ? item.name : ''),
        size: Math.max(0, parseInt(item && typeof item === 'object' ? item.size : 0, 10) || 0),
      }));
    };
    let photos = media_sources(args.photos);
    let videos = media_sources(args.videos);
    let files = media_files(args.files);
    if (photo) photos.unshift(upload_source(photo));
    if (video) videos.unshift(upload_source(video));
    if (voice_note) voice_note = upload_source(voice_note);
    photos = [...new Set(photos)];
    videos = [...new Set(videos)];
    files = [...new Map(files.map((file) => [file.source, file])).values()];
    if (!this._is_admin) {
      if (photos.length && this.system.chat_photos_enabled != 1) {
        throw new AuthorizationException(__('Uploading photos feature has been disabled by the admin'));
      }
      if (videos.length && (this.system.chat_videos_enabled != 1 || this.system.videos_enabled != 1 || !(await this.check_user_permission(this._data.user_id, 'videos_upload_permission')))) {
        throw new AuthorizationException(__('Uploading videos feature has been disabled by the admin'));
      }
      if (files.length && (this.system.chat_files_enabled != 1 || this.system.file_enabled != 1 || !(await this.check_user_permission(this._data.user_id, 'files_upload_permission')))) {
        throw new AuthorizationException(__('Uploading files feature has been disabled by the admin'));
      }
    }
    /* filter gif */
    if (gif && (this.system.gif_enabled != 1 || is_empty(this.system.giphy_key) || typeof gif !== 'string' || gif.length > 512 || !/^https:\/\/[a-z0-9.-]+\.giphy\.com\/[^\s<>"']+$/i.test(gif))) {
      throw new BadRequestException(__('Invalid GIF'));
    }
    const max_media = Math.max(1, parseInt(this.system.chat_max_media ?? 10, 10) || 10);
    if (photos.length + videos.length + files.length > max_media) {
      throw new BadRequestException(__('You can only attach up to') + ' ' + max_media + ' ' + __('photos, videos and files'));
    }

    if (is_empty(message) && !photos.length && !videos.length && !files.length && !voice_note && !gif && !product_post_id) {
      throw new BadRequestException(__('Message or Image or Video or Voice Note is required'));
    }
    if (product_post_id) {
      const post = await this.get_post(product_post_id);
      if (!post) throw new BadRequestException(__('Product is not exists'));
      if (post.post_type != 'product') throw new BadRequestException(__('Product post is not valid'));
    }
    if (conversation_id && isNaN(conversation_id)) {
      throw new BadRequestException(__('Conversation ID must be numeric'));
    }
    /* check if page conversation */
    if (!page_id && conversation_id) {
      page_id = await this.get_conversation_page_id(conversation_id);
    }
    const page_conversation = !!(page_id || as_page);
    let notify_page_admins = false;
    let page = null;
    if (!page_conversation && !conversation_id && !recipients) {
      throw new BadRequestException(__('Conversation ID or Recipients is required'));
    }
    if (recipients) {
      recipients = JSON.parse(recipients);
      if (!Array.isArray(recipients)) throw new BadRequestException(__('Recipients must be an array'));
      recipients = recipients.filter((v) => !isNaN(v));
      for (const recipient of recipients) {
        if (await this.blocked(recipient)) {
          throw new AuthorizationException(__('You are not authorized to do this'));
        }
      }
    }

    let conversation;
    if (page_conversation) {
      /* [0] page conversation */
      if (as_page) {
        /* the page replies to the customer */
        if (!conversation_id) throw new BadRequestException(__('Invalid request'));
        conversation = await this.get_conversation(conversation_id, true);
        if (!conversation) throw new AuthorizationException(__('You are not authorized to do this'));
        page_id = conversation.page_id;
        /* update the page as seen */
        await query(
          `UPDATE pages_conversations SET seen = '1', typing = '0' WHERE conversation_id = ${secure(conversation_id, 'int')}`
        );
        /* update the customer as not seen and not deleted */
        await query(
          `UPDATE conversations_users SET seen = '0', deleted = '0' WHERE conversation_id = ${secure(conversation_id, 'int')}`
        );
      } else {
        /* the customer messages the page */
        page = await this.get_chat_page(page_id);
        if (!page || this.system.pages_enabled != 1 || this.system.pages_messages_enabled != 1 || page.page_messages_enabled != 1) {
          throw new AuthorizationException(__('This page is not receiving messages'));
        }
        if (await this.check_page_adminship(this._data.user_id, page_id)) {
          throw new BadRequestException(__("You can't message your own page"));
        }
        if (this._data.user_privacy_chat == 'me') {
          throw new PrivacyException(__('You set your chat privacy to no one, Go to your privacy settings to change this'));
        }
        const page_conversation_id = await this.get_page_conversation_id(page_id, this._data.user_id);
        if (conversation_id && conversation_id != page_conversation_id) {
          throw new AuthorizationException(__('You are not authorized to do this'));
        }
        if (!page_conversation_id) {
          /* insert conversation */
          const insert_conversation = await query(
            `INSERT INTO conversations (last_message_id, node_id, node_type) VALUES ('0', ${secure(page_id, 'int')}, 'page')`
          );
          conversation_id = insert_conversation.insertId;
          /* insert the customer (viewer) */
          await query(
            `INSERT INTO conversations_users (conversation_id, user_id, seen) VALUES (${secure(conversation_id, 'int')}, ${secure(this._data.user_id, 'int')}, '1')`
          );
          /* insert the page */
          await query(
            `INSERT INTO pages_conversations (page_id, conversation_id, user_id) VALUES (${secure(page_id, 'int')}, ${secure(conversation_id, 'int')}, ${secure(this._data.user_id, 'int')})`
          );
          notify_page_admins = true;
        } else {
          conversation_id = page_conversation_id;
          /* notify the page admins only if the page has seen the conversation */
          const get_page_conversation = await query(
            `SELECT seen FROM pages_conversations WHERE conversation_id = ${secure(conversation_id, 'int')}`
          );
          notify_page_admins = get_page_conversation.rows[0] && get_page_conversation.rows[0].seen == 1;
          /* update sender (viewer) as seen & not deleted */
          await query(
            `UPDATE conversations_users SET seen = '1', deleted = '0' WHERE conversation_id = ${secure(conversation_id, 'int')} AND user_id = ${secure(this._data.user_id, 'int')}`
          );
          /* update the page as not seen */
          await query(
            `UPDATE pages_conversations SET seen = '0' WHERE conversation_id = ${secure(conversation_id, 'int')}`
          );
        }
      }
    } else if (conversation_id == null) {
      /* new or existing mutual conversation */
      const mutual_conversation = await this.get_mutual_conversation_id(recipients);
      if (!mutual_conversation) {
        /* [1] start a new conversation */
        let chat_price = 0;
        const paid_recipients = [];
        const recipient_infos = [];
        for (const recipient of recipients) {
          const recipient_info = await this.get_user(recipient);
          if (
            this.system.monetization_enabled == 1 &&
            !(await this.dating_matched(recipient)) &&
            (await this.check_user_permission(recipient, 'monetization_permission'))
          ) {
            if (recipient_info.user_monetization_enabled == 1 && recipient_info.user_monetization_chat_price > 0) {
              chat_price += Number(recipient_info.user_monetization_chat_price);
              paid_recipients.push(recipient_info);
            }
          }
          recipient_infos.push(recipient_info);
        }
        await this.check_recipients_chat_privacy(recipient_infos);
        if (!product_post_id && chat_price > 0) await this.wallet_chat_payment(chat_price, paid_recipients);
        /* insert conversation */
        const insert_conversation = await query("INSERT INTO conversations (last_message_id) VALUES ('0')");
        conversation_id = insert_conversation.insertId;
        /* insert the sender (viewer) */
        await query(
          `INSERT INTO conversations_users (conversation_id, user_id, seen) VALUES (${secure(conversation_id, 'int')}, ${secure(this._data.user_id, 'int')}, '1')`
        );
        /* insert recipients */
        for (const recipient_info of recipient_infos) {
          await query(
            `INSERT INTO conversations_users (conversation_id, user_id) VALUES (${secure(conversation_id, 'int')}, ${secure(recipient_info.user_id, 'int')})`
          );
        }
      } else {
        /* [2] existing conversation */
        conversation_id = mutual_conversation;
        conversation = await this.get_conversation(conversation_id);
        await this.check_recipients_chat_privacy(conversation.recipients);
        if (!conversation.node_id && !product_post_id && conversation.chat_price > 0) {
          await this.wallet_chat_payment(conversation.chat_price, conversation.paid_recipients);
        }
      }
    } else {
      /* [3] post to an existing conversation */
      conversation = await this.get_conversation(conversation_id);
      if (!conversation) throw new AuthorizationException(__('You are not authorized to do this'));
      if (!conversation.node_type) await this.check_recipients_chat_privacy(conversation.recipients);
      if (!conversation.node_id && conversation.chat_price > 0) {
        await this.wallet_chat_payment(conversation.chat_price, conversation.paid_recipients);
      }
      if (conversation.node_id) {
        if (conversation.node_type === 'group') {
          const membership = await this.check_group_membership(this._data.user_id, conversation.node_id);
          if (membership != 'approved') throw new Error(__('You are not authorized to do this'));
        } else if (conversation.node_type === 'event') {
          const membership = await this.check_event_membership(this._data.user_id, conversation.node_id);
          if (!membership) throw new Error(__('You are not authorized to do this'));
        }
      }
      for (const recipient of conversation.recipients) {
        if (!conversation.node_id && (await this.blocked(recipient.user_id))) {
          const recipient_name = this.system.show_usernames_enabled == 1
            ? recipient.user_name
            : recipient.user_firstname + ' ' + recipient.user_lastname;
          throw new Error(__('You aren\'t allowed to message') + ' ' + recipient_name);
        }
      }
      /* update sender as seen & not deleted */
      await query(
        `UPDATE conversations_users SET seen = '1', deleted = '0' WHERE conversation_id = ${secure(conversation_id, 'int')} AND user_id = ${secure(this._data.user_id, 'int')}`
      );
      if (!conversation.node_id) {
        await query(
          `UPDATE conversations_users SET seen = '0', deleted = '0' WHERE conversation_id = ${secure(conversation_id, 'int')} AND user_id != ${secure(this._data.user_id, 'int')}`
        );
      }
    }

    /* prevent sharing the same product post twice in a row */
    if (product_post_id && conversation && conversation.last_message && conversation.last_message.product_post_id == product_post_id) {
      product_post_id = null;
      if (is_empty(message) && !photos.length && !videos.length && !files.length && !voice_note && !gif) {
        return;
      }
    }

    if (reply_to) {
      const check_reply = await query(
        `SELECT COUNT(*) as count FROM conversations_messages WHERE message_id = ${secure(reply_to, 'int')} AND conversation_id = ${secure(conversation_id, 'int')}`
      );
      if (check_reply.rows[0].count == 0) {
        throw new BadRequestException(__('Invalid request'));
      }
    }
    /* insert message */
    const insert_message = await query(
      `INSERT INTO conversations_messages (conversation_id, user_id, page_id, message, image, gif, video, voice_note, product_post_id, story_id, reply_to, time) VALUES (${secure(conversation_id, 'int')}, ${secure(this._data.user_id, 'int')}, ${as_page ? secure(page_id, 'int') : 'null'}, ${secure(message)}, ${secure('')}, ${secure(gif)}, ${secure('')}, ${secure(voice_note)}, ${product_post_id ? secure(product_post_id, 'int') : 'null'}, ${story_id ? secure(story_id, 'int') : 'null'}, ${reply_to ? secure(reply_to, 'int') : 'null'}, ${secure(date)})`
    );
    const message_id = insert_message.insertId;
    /* update story replies counter */
    if (story_id) {
      await query(`UPDATE stories SET replies_count = replies_count + 1 WHERE story_id = ${secure(story_id, 'int')}`);
    }
    /* insert media rows */
    for (const [media_type, sources] of [['photo', photos], ['video', videos]]) {
      for (const source of sources) {
        await query(
          `INSERT INTO conversations_messages_media (message_id, media_type, source) VALUES (${secure(message_id, 'int')}, ${secure(media_type)}, ${secure(source)})`
        );
      }
    }
    for (const file of files) {
      await query(
        `INSERT INTO conversations_messages_media (message_id, media_type, source, name, size) VALUES (${secure(message_id, 'int')}, 'file', ${secure(file.source)}, ${secure(file.name)}, ${secure(file.size, 'int')})`
      );
    }
    /* update conversation with last message id */
    await query(
      `UPDATE conversations SET last_message_id = ${secure(message_id, 'int')} WHERE conversation_id = ${secure(conversation_id, 'int')}`
    );
    /* update sender with last message id */
    await query(
      `UPDATE users SET user_live_messages_lastid = ${secure(message_id, 'int')} WHERE user_id = ${secure(this._data.user_id, 'int')}`
    );
    /* re-fetch conversation */
    conversation = await this.get_conversation(conversation_id, as_page);
    /* update recipients + notify */
    for (const recipient of conversation.recipients || []) {
      if (!recipient.deleted) {
        await query(
          `UPDATE users SET user_live_messages_lastid = ${secure(message_id, 'int')}, user_live_messages_counter = user_live_messages_counter + 1 WHERE user_id = ${secure(recipient.user_id, 'int')}`
        );
      }
      let notify_message = message;
      if (!notify_message) {
        if ((photos.length ? 1 : 0) + (videos.length ? 1 : 0) + (files.length ? 1 : 0) > 1) notify_message = __('Sent') + ' ' + (photos.length + videos.length + files.length) + ' ' + __('media files');
        else if (photos.length > 1) notify_message = __('Sent') + ' ' + photos.length + ' ' + __('photos');
        else if (photos.length) notify_message = __('Sent a photo');
        else if (videos.length > 1) notify_message = __('Sent') + ' ' + videos.length + ' ' + __('videos');
        else if (videos.length) notify_message = __('Sent a video');
        else if (files.length > 1) notify_message = __('Sent') + ' ' + files.length + ' ' + __('files');
        else if (files.length) notify_message = __('Sent a file');
        else if (gif) notify_message = __('Sent a GIF');
        if (voice_note) notify_message = __('Sent a voice message');
        if (product_post_id) notify_message = __('Shared a product');
      }
      await this.post_notification({
        to_user_id: recipient.user_id,
        from_user_id: as_page ? page_id : this._data.user_id,
        from_user_type: as_page ? 'page' : 'user',
        action: 'chat_message',
        node_url: conversation_id,
        message: notify_message,
      });
    }
    /* notify the page admins */
    if (notify_page_admins) {
      for (const page_admin_id of await this.get_page_admins_ids(page_id)) {
        await this.post_notification({
          to_user_id: page_admin_id,
          action: 'page_message',
          node_type: page.page_title,
          node_url: page.page_name + '/settings/messages?cid=' + conversation_id,
        });
      }
    }
    /* clear the viewer's typing status */
    if (as_page) {
      await query(
        `UPDATE pages_conversations SET typing = '0' WHERE conversation_id = ${secure(conversation_id, 'int')}`
      );
    } else {
      await query(
        `UPDATE conversations_users SET typing = '0' WHERE conversation_id = ${secure(conversation_id, 'int')} AND user_id = ${secure(this._data.user_id, 'int')}`
      );
    }
    /* remove pending uploads */
    for (const file_name of [...photos, ...videos, ...files.map((file) => file.source), voice_note]) {
      if (!file_name) continue;
      await query(
        `DELETE FROM users_uploads_pending WHERE user_id = ${secure(this._data.user_id, 'int')} AND file_name = ${secure(file_name)}`
      );
    }
    return conversation;
  },

  /**
   * post_conversation_paid_message
   * @param {Object} args
   * @param {boolean} from_web
   * @return {Promise<Object>}
   */
  async post_conversation_paid_message(args = {}, from_web = false) {
    const date = init_system_datetime();
    /* check monetization permission */
    if (!this._data.can_monetize_content || this._data.user_monetization_enabled != 1) {
      throw new AuthorizationException(__("You don't have the permission to do this"));
    }
    /* prepare */
    let message = args.message ?? '';
    let photos = args.photos ?? [];
    let video = args.video ?? null;
    let audio = args.audio ?? null;
    let file = args.file ?? null;
    const conversation_id = args.conversation_id ?? null;
    const message_price = args.message_price ?? 0;
    const paid_text = args.paid_text ?? '';
    const paid_image = args.paid_image ?? '';
    let reply_to = args.reply_to ?? null;
    if (reply_to && isNaN(reply_to)) {
      throw new BadRequestException(__('Invalid request'));
    }
    reply_to = reply_to ? parseInt(reply_to, 10) : null;
    const for_adult =
      args.for_adult === '1' || args.for_adult === true || args.for_adult === 'true' ? '1' : '0';
    /* filter photos */
    if (photos && from_web && typeof photos === 'string') {
      photos = JSON.parse(photos);
    }
    if (!photos || typeof photos !== 'object') {
      photos = [];
    }
    if (!Array.isArray(photos)) {
      photos = Object.values(photos);
    }
    for (const photo of photos) {
      const source = photo && (photo.source ?? photo['source']);
      if (!is_valid_upload_source(source)) {
        throw new BadRequestException(__('Bad Request'));
      }
    }
    /* filter video */
    if (video && from_web && typeof video === 'string') {
      video = JSON.parse(video);
    }
    if (video && typeof video === 'object' && !video.source) {
      video = null;
    }
    if (video) {
      if (typeof video !== 'object' || !is_valid_upload_source(video.source)) {
        throw new BadRequestException(__('Bad Request'));
      }
    }
    /* filter audio */
    if (audio && from_web && typeof audio === 'string') {
      audio = JSON.parse(audio);
    }
    if (audio && typeof audio === 'object' && !audio.source) {
      audio = null;
    }
    if (audio) {
      if (typeof audio !== 'object' || !is_valid_upload_source(audio.source)) {
        throw new BadRequestException(__('Bad Request'));
      }
    }
    /* filter file */
    if (file && from_web && typeof file === 'string') {
      file = JSON.parse(file);
    }
    if (file && typeof file === 'object' && !file.source) {
      file = null;
    }
    if (file) {
      if (typeof file !== 'object' || !is_valid_upload_source(file.source)) {
        throw new BadRequestException(__('Bad Request'));
      }
      file.name = sanitize_upload_file_name(file.name);
      file.size = Math.max(0, parseInt(file.size, 10) || 0);
    }
    /* filter paid image */
    if (paid_image && !is_valid_upload_source(paid_image)) {
      throw new BadRequestException(__('Bad Request'));
    }
    /* at least one media attachment required */
    const has_photos = photos.length > 0;
    const has_video = !!(video && typeof video === 'object');
    const has_audio = !!(audio && typeof audio === 'object');
    const has_file = !!(file && typeof file === 'object');
    const media_count =
      (has_photos ? 1 : 0) + (has_video ? 1 : 0) + (has_audio ? 1 : 0) + (has_file ? 1 : 0);
    if (media_count === 0) {
      throw new ValidationException(__('Please attach at least one media file'));
    }
    /* validate price */
    if (isNaN(message_price) || Number(message_price) <= 0) {
      throw new ValidationException(__('Please enter a valid price'));
    }
    if (
      this.system.monetization_max_paid_post_price > 0 &&
      Number(message_price) > Number(this.system.monetization_max_paid_post_price)
    ) {
      throw new ValidationException(
        __('The price must be less than or equal to') +
        ' ' +
        this.system.system_currency_symbol +
        Number(this.system.monetization_max_paid_post_price)
      );
    }
    /* validate paid text */
    if (String(paid_text).length > 1000) {
      throw new ValidationException(__('Paid content description is more than 1000 characters'));
    }
    /* validate conversation */
    if (!conversation_id || isNaN(conversation_id)) {
      throw new BadRequestException(__('Conversation ID must be numeric'));
    }
    let conversation = await this.get_conversation(conversation_id);
    if (!conversation) {
      throw new AuthorizationException(__('You are not authorized to do this'));
    }
    /* disable in group/event chatboxes for v1 */
    if (conversation.node_id) {
      throw new AuthorizationException(
        __('Paid media messages are not supported in group or event chats yet')
      );
    }
    if (reply_to) {
      const check_reply = await query(
        `SELECT COUNT(*) as count FROM conversations_messages WHERE message_id = ${secure(reply_to, 'int')} AND conversation_id = ${secure(conversation_id, 'int')}`
      );
      if (!check_reply.rows[0] || check_reply.rows[0].count == 0) {
        throw new BadRequestException(__('Invalid request'));
      }
    }
    /* check recipients chat privacy */
    await this.check_recipients_chat_privacy(conversation.recipients);
    /* check paid conversation */
    if (conversation.chat_price > 0) {
      await this.wallet_chat_payment(conversation.chat_price, conversation.paid_recipients);
    }
    for (const recipient of conversation.recipients) {
      if (await this.blocked(recipient.user_id)) {
        const recipient_name =
          this.system.show_usernames_enabled == 1
            ? recipient.user_name
            : recipient.user_firstname + ' ' + recipient.user_lastname;
        throw new Error(__("You aren't allowed to message") + ' ' + recipient_name);
      }
    }
    /* update sender (viewer) as seen and not deleted */
    await query(
      `UPDATE conversations_users SET seen = '1', deleted = '0' WHERE conversation_id = ${secure(conversation_id, 'int')} AND user_id = ${secure(this._data.user_id, 'int')}`
    );
    /* update recipients as not seen and not deleted */
    await query(
      `UPDATE conversations_users SET seen = '0', deleted = '0' WHERE conversation_id = ${secure(conversation_id, 'int')} AND user_id != ${secure(this._data.user_id, 'int')}`
    );
    /* insert message */
    const insert_message = await query(
      `INSERT INTO conversations_messages (conversation_id, user_id, message, image, video, voice_note, is_paid, message_price, paid_text, paid_image, for_adult, reply_to, time) VALUES (${secure(conversation_id, 'int')}, ${secure(this._data.user_id, 'int')}, ${secure(message)}, '', '', '', '1', ${secure(message_price, 'float')}, ${secure(paid_text)}, ${secure(paid_image)}, ${secure(for_adult)}, ${reply_to ? secure(reply_to, 'int') : 'null'}, ${secure(date)})`
    );
    const message_id = insert_message.insertId;
    const pending_uploads = [];
    if (paid_image) {
      pending_uploads.push(paid_image);
    }
    /* insert media rows */
    if (has_photos) {
      for (const photo of photos) {
        const source = photo && (photo.source ?? photo['source']);
        if (!is_valid_upload_source(source)) {
          throw new BadRequestException(__('Bad Request'));
        }
        await query(
          `INSERT INTO conversations_messages_media (message_id, media_type, source) VALUES (${secure(message_id, 'int')}, 'photo', ${secure(source)})`
        );
        pending_uploads.push(source);
      }
    }
    if (has_video) {
      await query(
        `INSERT INTO conversations_messages_media (message_id, media_type, source) VALUES (${secure(message_id, 'int')}, 'video', ${secure(video.source)})`
      );
      pending_uploads.push(video.source);
    }
    if (has_audio) {
      await query(
        `INSERT INTO conversations_messages_media (message_id, media_type, source) VALUES (${secure(message_id, 'int')}, 'audio', ${secure(audio.source)})`
      );
      pending_uploads.push(audio.source);
    }
    if (has_file) {
      await query(
        `INSERT INTO conversations_messages_media (message_id, media_type, source, name, size) VALUES (${secure(message_id, 'int')}, 'file', ${secure(file.source)}, ${secure(file.name || '')}, ${secure(file.size || 0, 'int')})`
      );
      pending_uploads.push(file.source);
    }
    /* update the conversation with last message id */
    await query(
      `UPDATE conversations SET last_message_id = ${secure(message_id, 'int')} WHERE conversation_id = ${secure(conversation_id, 'int')}`
    );
    /* update sender (viewer) with last message id */
    await query(
      `UPDATE users SET user_live_messages_lastid = ${secure(message_id, 'int')} WHERE user_id = ${secure(this._data.user_id, 'int')}`
    );
    /* re-fetch conversation */
    conversation = await this.get_conversation(conversation_id);
    /* update all recipients with last message id & only offline recipient messages counter */
    let notify_message = message;
    if (!notify_message) {
      notify_message = __('Sent paid content');
    }
    for (const recipient of conversation.recipients) {
      if (!recipient.deleted) {
        await query(
          `UPDATE users SET user_live_messages_lastid = ${secure(message_id, 'int')}, user_live_messages_counter = user_live_messages_counter + 1 WHERE user_id = ${secure(recipient.user_id, 'int')}`
        );
      }
      await this.post_notification({
        to_user_id: recipient.user_id,
        from_user_id: this._data.user_id,
        action: 'chat_message',
        node_url: conversation_id,
        message: notify_message,
      });
    }
    /* update typing status of the viewer for this conversation */
    await query(
      `UPDATE conversations_users SET typing = '0' WHERE conversation_id = ${secure(conversation_id, 'int')} AND user_id = ${secure(this._data.user_id, 'int')}`
    );
    /* remove pending uploads */
    for (const file_name of pending_uploads) {
      if (!file_name) continue;
      await query(
        `DELETE FROM users_uploads_pending WHERE user_id = ${secure(this._data.user_id, 'int')} AND file_name = ${secure(file_name)}`
      );
    }
    /* return with conversation */
    return conversation;
  },

  /**
   * get_conversation_message_by_id
   * @param {number} message_id
   * @param {number|null} viewer_id
   * @param {boolean} as_page
   * @return {Promise<Object|null>}
   */
  async get_conversation_message_by_id(message_id, viewer_id = null, as_page = false) {
    if (!message_id) return null;
    const get_message = await query(
      `SELECT conversations_messages.*, users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, users.user_subscribed, users.user_verified FROM conversations_messages INNER JOIN users ON conversations_messages.user_id = users.user_id WHERE conversations_messages.message_id = ${secure(message_id, 'int')}`
    );
    if (get_message.num_rows === 0) return null;
    return this.parse_message(get_message.rows[0], viewer_id, as_page);
  },

  /**
   * get_conversation_total_messages
   * @param {number} conversation_id
   * @return {Promise<number>}
   */
  async get_conversation_total_messages(conversation_id) {
    const res = await query(
      `SELECT COUNT(*) as count FROM conversations_messages WHERE conversation_id = ${secure(conversation_id, 'int')}`
    );
    return res.rows[0].count;
  },

  /**
   * parse_message
   * @param {Object} message
   * @param {number|null} viewer_id
   * @param {boolean} as_page
   * @return {Promise<Object>}
   */
  async parse_message(message, viewer_id = null, as_page = false) {
    let viewer = this._data;
    let viewer_logged_in = this._logged_in;
    if (viewer_id !== null && viewer_id != (this._data.user_id ?? null)) {
      const fetched_viewer = await this.get_user(viewer_id);
      if (fetched_viewer) {
        fetched_viewer.user_adult = get_user_age(fetched_viewer.user_birthdate) >= 18;
        viewer = fetched_viewer;
        viewer_logged_in = true;
      }
    }

    message.user_picture = get_picture(message.user_picture, message.user_gender, this.system);
    message.user_fullname =
      this.system.show_usernames_enabled == 1
        ? message.user_name
        : message.user_firstname + ' ' + message.user_lastname;
    /* prepare page data (sent as the page) */
    if (message.page_id) {
      const page = await this.get_chat_page(message.page_id);
      if (as_page) {
        /* page admins see who replied */
        message.sender_fullname = message.user_fullname;
      } else {
        /* customers never see the page admin */
        message.user_id = 0;
        message.user_name = '';
        message.user_firstname = page ? page.page_title : '';
        message.user_lastname = '';
        message.user_gender = '';
        message.user_subscribed = '0';
      }
      message.page_name = page ? page.page_name : '';
      message.user_picture = page ? page.page_picture : get_picture('', 'page', this.system);
      message.user_fullname = page ? page.page_title : __('Page');
      message.user_verified = page ? page.page_verified : '0';
    }
    /* reactions */
    message.reactions = {
      like: message.reaction_like_count || 0,
      love: message.reaction_love_count || 0,
      haha: message.reaction_haha_count || 0,
      yay: message.reaction_yay_count || 0,
      wow: message.reaction_wow_count || 0,
      sad: message.reaction_sad_count || 0,
      angry: message.reaction_angry_count || 0,
    };
    message.reactions_total_count = Object.values(message.reactions).reduce((a, b) => a + Number(b), 0);
    message.i_react = false;
    if (message.reactions_total_count > 0) {
      const get_reaction = await query(
        `SELECT reaction FROM conversations_messages_reactions WHERE user_id = ${secure(viewer.user_id, 'int')} AND message_id = ${secure(message.message_id, 'int')}`
      );
      if (get_reaction.num_rows > 0) {
        message.i_react = true;
        message.i_reaction = get_reaction.rows[0].reaction;
      }
    }
    /* message text */
    message.message_orginal = message.message;
    message.message_orginal_decoded = html_entity_decode(message.message);
    message.message = nl2br(message.message);
    message.message_decoded = html_entity_decode(message.message);
    /* product post */
    if (message.product_post_id) {
      const post = await this.get_post(message.product_post_id);
      if (post) message.post = post;
    }
    /* story */
    if (message.story_id) {
      message.story = await this.get_story_preview(message.story_id);
    }
    /* call */
    if (message.call_id) {
      message.call = await this.get_message_call(message.call_id);
    }
    /* get media */
    message.media = { items: [], photos: [], video: null, audio: null, file: null, files: [] };
    const get_media = await query(
      `SELECT * FROM conversations_messages_media WHERE message_id = ${secure(message.message_id, 'int')} ORDER BY media_id ASC`
    );
    for (const media of get_media.rows) {
      if (media.media_type === 'photo') {
        message.media.photos.push(media);
      } else if (media.media_type === 'video') {
        message.media.video = message.media.video ?? media;
      } else if (media.media_type === 'audio') {
        message.media.audio = media;
      } else if (media.media_type === 'file') {
        decorate_file_attachment(media);
        message.media.file = message.media.file ?? media;
        message.media.files.push(media);
      }
      if (message.is_paid != '1' && (media.media_type === 'photo' || media.media_type === 'video')) {
        message.media.items.push(media);
      }
    }
    if (message.is_paid != '1') {
      if (message.media.items.length) {
        /* legacy fields for older clients */
        for (const media of message.media.items) {
          if (media.media_type === 'photo' && !message.image) {
            message.image = media.source;
          } else if (media.media_type === 'video' && !message.video) {
            message.video = media.source;
          }
        }
      } else {
        /* legacy media columns */
        if (message.image) {
          message.media.items.push({ media_id: 0, message_id: message.message_id, media_type: 'photo', source: message.image });
        }
        if (message.video) {
          message.media.items.push({ media_id: 0, message_id: message.message_id, media_type: 'video', source: message.video });
        }
      }
    }
    message.media.photos_count = message.media.items.filter((media) => media.media_type === 'photo').length;
    message.media.videos_count = message.media.items.length - message.media.photos_count;
    message.media.files_count = message.media.files.length;
    message.reply = await this.get_message_reply_preview(message.reply_to);
    /* paid media message */
    message.needs_payment = false;
    message.can_get_details = true;
    message.message_price_discounted = 0;
    if (message.is_paid == '1') {
      message.message_price = message.message_price ?? 0;
      if (message.is_paid == '1' && this.system.monetization_enabled == 1) {
        const author = await this.get_user(message.user_id);
        const discount_enabled = author.user_monetization_discount_enabled == 1;
        const discount_percent = discount_enabled ? Number(author.user_monetization_discount_percent) : 0;
        if (viewer_logged_in) {
          if (viewer.user_group == 3 && message.user_id != viewer.user_id) {
            if (!(await this.is_user_paid_for_message(message.message_id, viewer.user_id))) {
              message.needs_payment = true;
              message.message_price_discounted = discount_enabled
                ? message.message_price * (1 - discount_percent / 100)
                : 0;
            }
          }
        } else {
          message.needs_payment = true;
          message.message_price_discounted = discount_enabled
            ? message.message_price * (1 - discount_percent / 100)
            : 0;
        }
      }
      message.needs_age_verification = false;
      if (this.system.adult_mode == 1 && message.for_adult == '1') {
        if (viewer_logged_in) {
          if (viewer.user_group == 3 && message.user_id != viewer.user_id) {
            if (!viewer.user_adult) {
              message.needs_age_verification = true;
            } else if (this.system.verification_for_adult_content == 1 && viewer.user_verified != 1) {
              message.needs_age_verification = true;
            }
          }
        } else {
          message.needs_age_verification = true;
        }
      }
      message.can_get_details = true;
      if (message.needs_age_verification) {
        message.can_get_details = false;
      } else if (message.needs_payment) {
        message.can_get_details = false;
      }
      if (viewer_logged_in && (message.user_id == viewer.user_id || viewer.user_group < 3)) {
        message.can_get_details = true;
        message.needs_payment = false;
      }
      if (!message.can_get_details) {
        message.media = { items: [], photos: [], video: null, audio: null, file: null, files: [] };
      }
    }
    return message;
  },

  /**
   * get_story
   * @param {number} story_id
   * @return {Promise<Object|false>}
   */
  async get_story(story_id) {
    if (isNaN(story_id)) {
      return false;
    }
    const get_story = await query(
      `SELECT story_id, user_id, privacy, is_ads FROM stories WHERE story_id = ${secure(story_id, 'int')} AND (highlighted = '1' OR expires_at > ${secure(init_system_datetime())})`
    );
    if (get_story.num_rows === 0) {
      return false;
    }
    const story = get_story.rows[0];
    if (story.user_id == this._data.user_id || this._data.user_group < 3) {
      return story;
    }
    if (await this.blocked(story.user_id)) {
      return false;
    }
    if (story.is_ads == '1') {
      return story;
    }
    const get_audience = await query(
      `SELECT type FROM stories_audience WHERE user_id = ${secure(story.user_id, 'int')} AND target_id = ${secure(this._data.user_id, 'int')}`
    );
    const audience = get_audience.rows.map((row) => row.type);
    if (audience.includes('hidden')) {
      return false;
    }
    if (story.privacy == 'public') {
      return story;
    }
    if (story.privacy == 'friends') {
      return this.friendship_approved(story.user_id) ? story : false;
    }
    return audience.includes('close') ? story : false;
  },

  /**
   * get_story_preview
   * @param {number} story_id
   * @return {Promise<Object>}
   */
  async get_story_preview(story_id) {
    const preview = { story_id: story_id, unavailable: true, thumbnail: '' };
    const get_story = await query(
      `SELECT story_id, type, source, thumbnail FROM stories WHERE story_id = ${secure(story_id, 'int')} AND (highlighted = '1' OR expires_at > ${secure(init_system_datetime())})`
    );
    if (get_story.num_rows === 0) {
      return preview;
    }
    const story = get_story.rows[0];
    const thumbnail = story.type == 'photo' ? story.source : story.thumbnail;
    preview.unavailable = false;
    preview.thumbnail = thumbnail ? this.system.system_uploads + '/' + thumbnail : '';
    return preview;
  },

  /**
   * get_message_reply_preview
   * @param {number|null} reply_to
   * @return {Promise<Object|null>}
   */
  async get_message_reply_preview(reply_to) {
    if (!reply_to) return null;
    const get_reply = await query(
      `SELECT conversations_messages.message_id, conversations_messages.message, conversations_messages.image, conversations_messages.gif, conversations_messages.video, conversations_messages.voice_note, conversations_messages.product_post_id, conversations_messages.call_id, conversations_calls.is_video_call, users.user_name, users.user_firstname, users.user_lastname, pages.page_title FROM conversations_messages INNER JOIN users ON conversations_messages.user_id = users.user_id LEFT JOIN pages ON conversations_messages.page_id = pages.page_id LEFT JOIN conversations_calls ON conversations_messages.call_id = conversations_calls.call_id WHERE conversations_messages.message_id = ${secure(reply_to, 'int')}`
    );
    if (get_reply.num_rows === 0) {
      return {
        message_id: reply_to,
        unavailable: true,
        user_fullname: '',
        snippet: __('Original message unavailable'),
      };
    }
    const row = get_reply.rows[0];
    let snippet = html_entity_decode(String(row.message || '')).trim();
    if (snippet === '') {
      const get_media = await query(
        `SELECT media_type FROM conversations_messages_media WHERE message_id = ${secure(row.message_id, 'int')} ORDER BY media_id ASC LIMIT 1`
      );
      const media_type = get_media.num_rows > 0 ? get_media.rows[0].media_type : null;
      if (media_type === 'photo' || row.image) snippet = __('Photo');
      else if (media_type === 'video' || row.video) snippet = __('Video');
      else if (media_type === 'file') snippet = __('File');
      else if (media_type === 'audio' || row.voice_note) snippet = __('Voice');
      else if (row.gif) snippet = __('GIF');
      else if (row.product_post_id) snippet = __('Product');
      else if (row.call_id) snippet = row.is_video_call == '1' ? __('Video call') : __('Audio call');
      else snippet = __('Message');
    } else if (snippet.length > 80) {
      snippet = snippet.slice(0, 80) + '...';
    }
    return {
      message_id: row.message_id,
      unavailable: false,
      user_fullname: row.page_title ? row.page_title : (this.system.show_usernames_enabled == 1 ? row.user_name : row.user_firstname + ' ' + row.user_lastname),
      snippet,
    };
  },

  /**
   * delete_conversation_message
   * @param {number} message_id
   * @return {Promise<void>}
   */
  async delete_conversation_message(message_id) {
    /* check if message exists and viewer is the sender (or manages the page who sent it) */
    const check_message = await query(
      `SELECT * FROM conversations_messages WHERE message_id = ${secure(message_id, 'int')}`
    );
    if (check_message.num_rows === 0) {
      throw new AuthorizationException(__('You are not authorized to do this'));
    }
    const message = check_message.rows[0];
    if (message.page_id) {
      if (!(await this.check_page_adminship(this._data.user_id, message.page_id))) {
        throw new AuthorizationException(__('You are not authorized to do this'));
      }
    } else if (message.user_id != this._data.user_id) {
      throw new AuthorizationException(__('You are not authorized to do this'));
    }
    await query(`DELETE FROM conversations_messages_media WHERE message_id = ${secure(message_id, 'int')}`);
    await query(`DELETE FROM conversations_messages_reactions WHERE message_id = ${secure(message_id, 'int')}`);
    await query(`DELETE FROM conversations_messages WHERE message_id = ${secure(message_id, 'int')}`);
    await query(`UPDATE conversations SET pinned_message_id = NULL WHERE pinned_message_id = ${secure(message_id, 'int')}`);
    await query(
      `UPDATE conversations c SET c.last_message_id = COALESCE((SELECT m.message_id FROM conversations_messages m WHERE m.conversation_id = c.conversation_id ORDER BY m.message_id DESC LIMIT 1), 0) WHERE c.conversation_id = ${secure(message.conversation_id, 'int')} AND c.last_message_id = ${secure(message_id, 'int')}`
    );
    const check_last = await query(
      `SELECT last_message_id FROM conversations WHERE conversation_id = ${secure(message.conversation_id, 'int')}`
    );
    if (!check_last.rows[0] || check_last.rows[0].last_message_id == 0) {
      if (await this.get_conversation_page_id(message.conversation_id)) {
        await this.delete_page_conversation(message.conversation_id);
      } else {
        await this.delete_conversation(message.conversation_id);
      }
    }
  },

  /**
   * pin_conversation_message
   * @param {number} message_id
   * @param {boolean} as_page
   * @return {Promise<Object>}
   */
  async pin_conversation_message(message_id, as_page = false) {
    let get_message;
    if (as_page) {
      get_message = await query(
        `SELECT message_id, conversation_id FROM conversations_messages WHERE message_id = ${secure(message_id, 'int')}`
      );
      if (get_message.num_rows === 0 || !(await this.check_page_conversation_access(get_message.rows[0].conversation_id))) {
        throw new AuthorizationException(__('You are not authorized to do this'));
      }
    } else {
      get_message = await query(
        `SELECT conversations_messages.message_id, conversations_messages.conversation_id FROM conversations_messages INNER JOIN conversations_users ON conversations_messages.conversation_id = conversations_users.conversation_id WHERE conversations_messages.message_id = ${secure(message_id, 'int')} AND conversations_users.user_id = ${secure(this._data.user_id, 'int')}`
      );
      if (get_message.num_rows === 0) {
        throw new AuthorizationException(__('You are not authorized to do this'));
      }
    }
    const message = get_message.rows[0];
    await query(
      `UPDATE conversations SET pinned_message_id = ${secure(message.message_id, 'int')} WHERE conversation_id = ${secure(message.conversation_id, 'int')}`
    );
    return this.get_conversation(message.conversation_id, as_page);
  },

  /**
   * unpin_conversation_message
   * @param {number} conversation_id
   * @param {boolean} as_page
   * @return {Promise<Object>}
   */
  async unpin_conversation_message(conversation_id, as_page = false) {
    const conversation = await this.get_conversation(conversation_id, as_page);
    if (!conversation) {
      throw new AuthorizationException(__('You are not authorized to do this'));
    }
    await query(`UPDATE conversations SET pinned_message_id = NULL WHERE conversation_id = ${secure(conversation_id, 'int')}`);
    conversation.pinned_message_id = null;
    conversation.pinned_message = null;
    return conversation;
  },

  /**
   * react_message
   * @param {number} message_id
   * @param {string} reaction
   * @return {Promise<Object>}
   */
  async react_message(message_id, reaction) {
    const allowed = ['like', 'love', 'haha', 'yay', 'wow', 'sad', 'angry'];
    if (!allowed.includes(reaction)) {
      throw new BadRequestException(__('Invalid input'));
    }
    const parsed = await this.get_conversation_message_by_id(message_id);
    if (!parsed) {
      throw new BadRequestException(__('Message not found'));
    }
    if (parsed.i_react) {
      await query(
        `DELETE FROM conversations_messages_reactions WHERE user_id = ${secure(this._data.user_id, 'int')} AND message_id = ${secure(message_id, 'int')}`
      );
      const old_field = 'reaction_' + parsed.i_reaction + '_count';
      await query(
        `UPDATE conversations_messages SET ${old_field} = IF(${old_field}=0,0,${old_field}-1) WHERE message_id = ${secure(message_id, 'int')}`
      );
    }
    const date = init_system_datetime();
    await query(
      `INSERT INTO conversations_messages_reactions (user_id, message_id, reaction, reaction_time) VALUES (${secure(this._data.user_id, 'int')}, ${secure(message_id, 'int')}, ${secure(reaction)}, ${secure(date)})`
    );
    const reaction_field = 'reaction_' + reaction + '_count';
    await query(
      `UPDATE conversations_messages SET ${reaction_field} = ${reaction_field} + 1 WHERE message_id = ${secure(message_id, 'int')}`
    );
    return this.get_conversation_message_by_id(message_id);
  },

  /**
   * unreact_message
   * @param {number} message_id
   * @param {string} reaction
   * @return {Promise<Object>}
   */
  async unreact_message(message_id, reaction) {
    const allowed = ['like', 'love', 'haha', 'yay', 'wow', 'sad', 'angry'];
    if (!allowed.includes(reaction)) {
      throw new BadRequestException(__('Invalid input'));
    }
    const parsed = await this.get_conversation_message_by_id(message_id);
    if (!parsed) {
      throw new BadRequestException(__('Message not found'));
    }
    if (parsed.i_react) {
      await query(
        `DELETE FROM conversations_messages_reactions WHERE user_id = ${secure(this._data.user_id, 'int')} AND message_id = ${secure(message_id, 'int')}`
      );
      const reaction_field = 'reaction_' + parsed.i_reaction + '_count';
      await query(
        `UPDATE conversations_messages SET ${reaction_field} = IF(${reaction_field}=0,0,${reaction_field}-1) WHERE message_id = ${secure(message_id, 'int')}`
      );
    }
    return this.get_conversation_message_by_id(message_id);
  },

  /**
   * delete_conversation
   * @param {number} conversation_id
   * @return {Promise<void>}
   */
  async delete_conversation(conversation_id) {
    const check = await query(
      `SELECT COUNT(*) as count FROM conversations_users INNER JOIN conversations ON conversations_users.conversation_id = conversations.conversation_id WHERE (conversations.node_id IS NULL OR conversations.node_type = 'page') AND conversations.conversation_id = ${secure(conversation_id, 'int')} AND conversations_users.user_id = ${secure(this._data.user_id, 'int')}`
    );
    if (check.rows[0].count == 0) {
      throw new AuthorizationException(__('You are not authorized to do this'));
    }
    /* page conversations stay in the page inbox */
    if (this.system.chat_permanently_delete_enabled == 1 && !(await this.get_conversation_page_id(conversation_id))) {
      await query(`DELETE FROM conversations WHERE conversation_id = ${secure(conversation_id, 'int')}`);
      await query(`DELETE FROM conversations_users WHERE conversation_id = ${secure(conversation_id, 'int')}`);
      await query(`DELETE FROM conversations_messages WHERE conversation_id = ${secure(conversation_id, 'int')}`);
    } else {
      await query(
        `UPDATE conversations_users SET typing = '0' WHERE conversation_id = ${secure(conversation_id, 'int')} AND user_id = ${secure(this._data.user_id, 'int')}`
      );
      await query(
        `UPDATE conversations_users SET deleted = '1' WHERE conversation_id = ${secure(conversation_id, 'int')} AND user_id = ${secure(this._data.user_id, 'int')}`
      );
    }
  },

  /**
   * leave_conversation
   * @param {number} conversation_id
   * @return {Promise<void>}
   */
  async leave_conversation(conversation_id) {
    const check = await query(
      `SELECT COUNT(*) as count FROM conversations_users WHERE conversation_id = ${secure(conversation_id, 'int')} AND user_id = ${secure(this._data.user_id, 'int')}`
    );
    if (check.rows[0].count == 0) {
      throw new AuthorizationException(__('You are not authorized to do this'));
    }
    await query(
      `UPDATE conversations_users SET typing = '0' WHERE conversation_id = ${secure(conversation_id, 'int')} AND user_id = ${secure(this._data.user_id, 'int')}`
    );
    await query(
      `UPDATE conversations_users SET deleted = '1' WHERE conversation_id = ${secure(conversation_id, 'int')} AND user_id = ${secure(this._data.user_id, 'int')}`
    );
  },

  /**
   * set_conversation_color
   * @param {number} conversation_id
   * @param {string} color
   * @return {Promise<void>}
   */
  async set_conversation_color(conversation_id, color) {
    const check = await query(
      `SELECT COUNT(*) as count FROM conversations_users WHERE conversation_id = ${secure(conversation_id, 'int')} AND user_id = ${secure(this._data.user_id, 'int')}`
    );
    if (check.rows[0].count == 0) {
      throw new AuthorizationException(__('You are not authorized to do this'));
    }
    await query(
      `UPDATE conversations SET color = ${secure(color)} WHERE conversation_id = ${secure(conversation_id, 'int')}`
    );
  },

  /**
   * get_group_conversation
   * @param {number} conversation_id
   * @return {Promise<Object>}
   */
  async get_group_conversation(conversation_id) {
    const check = await query(
      `SELECT COUNT(*) as count FROM conversations_users WHERE conversation_id = ${secure(conversation_id, 'int')} AND user_id = ${secure(this._data.user_id, 'int')} AND deleted = '0'`
    );
    if (check.rows[0].count == 0) {
      throw new AuthorizationException(__('You are not authorized to do this'));
    }
    const conversation = await this.get_conversation(conversation_id);
    if (!conversation || conversation.node_id || !conversation.multiple_recipients) {
      throw new AuthorizationException(__('You are not authorized to do this'));
    }
    return conversation;
  },

  /**
   * rename_conversation
   * @param {number} conversation_id
   * @param {string} name
   * @return {Promise<Object>}
   */
  async rename_conversation(conversation_id, name) {
    await this.get_group_conversation(conversation_id);
    name = String(name || '').trim();
    if (html_entities(name).length > 128) {
      throw new ValidationException(__('The name must be less than 128 characters'));
    }
    await query(
      `UPDATE conversations SET name = ${secure(name)} WHERE conversation_id = ${secure(conversation_id, 'int')}`
    );
    return this.get_conversation(conversation_id);
  },

  /**
   * add_conversation_user
   * @param {number} conversation_id
   * @param {number} user_id
   * @return {Promise<Object>}
   */
  async add_conversation_user(conversation_id, user_id) {
    if (!user_id || Number(user_id) === Number(this._data.user_id)) {
      throw new BadRequestException(__('Invalid request'));
    }
    const conversation = await this.get_group_conversation(conversation_id);
    if (conversation.recipients.length >= 10) {
      throw new ValidationException(__('You can only add up to 10 people'));
    }
    if (conversation.recipients.some((recipient) => Number(recipient.user_id) === Number(user_id))) {
      throw new ValidationException(__('This user is already in the conversation'));
    }
    if (await this.blocked(user_id)) {
      throw new AuthorizationException(__('You are not authorized to do this'));
    }
    const recipient = await this.get_user(user_id);
    if (!recipient) {
      throw new BadRequestException(__('Invalid request'));
    }
    await this.check_recipients_chat_privacy([recipient]);
    await query(
      `INSERT INTO conversations_users (conversation_id, user_id) VALUES (${secure(conversation_id, 'int')}, ${secure(user_id, 'int')})`
    );
    return this.get_conversation(conversation_id);
  },

  /**
   * remove_conversation_user
   * @param {number} conversation_id
   * @param {number} user_id
   * @return {Promise<Object|false>}
   */
  async remove_conversation_user(conversation_id, user_id) {
    if (!user_id) {
      throw new BadRequestException(__('Invalid request'));
    }
    const conversation = await this.get_group_conversation(conversation_id);
    const is_self = Number(user_id) === Number(this._data.user_id);
    const is_member =
      is_self || conversation.recipients.some((recipient) => Number(recipient.user_id) === Number(user_id));
    if (!is_member) {
      throw new AuthorizationException(__('You are not authorized to do this'));
    }
    await query(
      `DELETE FROM conversations_users WHERE conversation_id = ${secure(conversation_id, 'int')} AND user_id = ${secure(user_id, 'int')}`
    );
    if (is_self) {
      return false;
    }
    return this.get_conversation(conversation_id);
  },

  /**
   * update_conversation_typing_status
   * @param {number} conversation_id
   * @param {boolean} is_typing
   * @param {boolean} as_page
   * @return {Promise<void>}
   */
  async update_conversation_typing_status(conversation_id, is_typing, as_page = false) {
    if (this.system.chat_typing_enabled != 1) return;
    if (conversation_id == null || is_typing == null) return;
    /* page inbox */
    if (as_page) {
      if (!(await this.check_page_conversation_access(conversation_id))) return;
      await query(
        `UPDATE pages_conversations SET typing = ${secure(is_typing && is_typing !== 'false' ? '1' : '0')} WHERE conversation_id = ${secure(conversation_id, 'int')}`
      );
      return;
    }
    const check = await query(
      `SELECT COUNT(*) as count FROM conversations_users WHERE conversation_id = ${secure(conversation_id, 'int')} AND user_id = ${secure(this._data.user_id, 'int')}`
    );
    if (check.rows[0].count == 0) return;
    const typing = is_typing ? '1' : '0';
    await query(
      `UPDATE conversations_users SET typing = ${secure(typing)} WHERE conversation_id = ${secure(conversation_id, 'int')} AND user_id = ${secure(this._data.user_id, 'int')}`
    );
  },

  /**
   * update_conversation_seen_status
   * @param {Array|number} conversation_ids
   * @param {boolean} as_page
   * @return {Promise<void>}
   */
  async update_conversation_seen_status(conversation_ids, as_page = false) {
    if (conversation_ids == null) return;
    /* page inbox (the page read state is also the inbox unread state) */
    if (as_page) {
      for (const conversation_id of Array.isArray(conversation_ids) ? conversation_ids : [conversation_ids]) {
        if (await this.check_page_conversation_access(conversation_id)) {
          await query(
            `UPDATE pages_conversations SET seen = '1' WHERE conversation_id = ${secure(conversation_id, 'int')}`
          );
        }
      }
      return;
    }
    if (this.system.chat_seen_enabled != 1) return;
    const conversations_array = [];
    for (const conversation_id of Array.isArray(conversation_ids) ? conversation_ids : [conversation_ids]) {
      const check = await query(
        `SELECT COUNT(*) as count FROM conversations_users WHERE conversation_id = ${secure(conversation_id, 'int')} AND user_id = ${secure(this._data.user_id, 'int')}`
      );
      if (check.rows[0].count > 0) conversations_array.push(conversation_id);
    }
    if (conversations_array.length === 0) return;
    await query(
      `UPDATE conversations_users SET seen = '1' WHERE conversation_id IN (${this.spread_ids(conversations_array)}) AND user_id = ${secure(this._data.user_id, 'int')}`
    );
  },
};
