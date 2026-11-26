/**
 * sockets -> nodejs -> libs -> traits -> nodes
 *
 * @package Sngine
 * @author Zamblek
 */

const { query, secure } = require('../core/database');
const { get_picture, print_money } = require('../functions');

module.exports = {
  /**
   * get_group (lean)
   * @param {number} group_id
   * @return {Promise<Object|false>}
   */
  async get_group(group_id) {
    const get_group = await query(
      `SELECT group_id, group_name, group_title, group_picture FROM \`groups\` WHERE group_id = ${secure(group_id, 'int')}`
    );
    if (get_group.num_rows === 0) return false;
    return get_group.rows[0];
  },

  /**
   * get_event (lean)
   * @param {number} event_id
   * @return {Promise<Object|false>}
   */
  async get_event(event_id) {
    const get_event = await query(
      `SELECT event_id, event_title, event_cover FROM events WHERE event_id = ${secure(event_id, 'int')}`
    );
    if (get_event.num_rows === 0) return false;
    return get_event.rows[0];
  },

  /**
   * get_chat_page (lean)
   * @param {number} page_id
   * @return {Promise<Object|false>}
   */
  async get_chat_page(page_id) {
    const get_page = await query(
      `SELECT page_id, page_admin, page_name, page_title, page_picture, page_verified, page_messages_enabled FROM pages WHERE page_id = ${secure(page_id, 'int')}`
    );
    if (get_page.num_rows === 0) return false;
    const page = get_page.rows[0];
    page.page_picture = get_picture(page.page_picture, 'page', this.system);
    return page;
  },

  /**
   * get_page_admins_ids
   * @param {number} page_id
   * @return {Promise<Array>}
   */
  async get_page_admins_ids(page_id) {
    const get_admins = await query(
      `SELECT user_id FROM pages_admins WHERE page_id = ${secure(page_id, 'int')}`
    );
    return get_admins.rows.map((row) => row.user_id);
  },

  /**
   * check_page_adminship
   * @param {number} user_id
   * @param {number} page_id
   * @return {Promise<boolean>}
   */
  async check_page_adminship(user_id, page_id) {
    const get_adminship = await query(
      `SELECT COUNT(*) as count FROM pages_admins WHERE page_id = ${secure(page_id, 'int')} AND user_id = ${secure(user_id, 'int')}`
    );
    return get_adminship.rows[0].count > 0;
  },

  /**
   * get_post (lean — product posts shared into chat)
   * @param {number} post_id
   * @return {Promise<Object|false>}
   */
  async get_post(post_id) {
    const get_post = await query(
      `SELECT posts.post_id, posts.post_type, posts_products.name, posts_products.price FROM posts LEFT JOIN posts_products ON posts.post_id = posts_products.post_id WHERE posts.post_id = ${secure(post_id, 'int')}`
    );
    if (get_post.num_rows === 0) return false;
    const row = get_post.rows[0];
    const post = { post_id: row.post_id, post_type: row.post_type };
    /* photos */
    const get_photos = await query(
      `SELECT source FROM posts_photos WHERE post_id = ${secure(post_id, 'int')} ORDER BY photo_id ASC`
    );
    post.photos = get_photos.rows.length ? get_photos.rows : [{ source: '' }];
    /* product */
    post.product = {
      name: row.name,
      price: row.price,
      price_formatted: print_money(row.price, this.system),
    };
    return post;
  },

  /**
   * check_group_membership (lean)
   * @param {number} user_id
   * @param {number} group_id
   * @return {Promise<string|false>}
   */
  async check_group_membership(user_id, group_id) {
    const get_membership = await query(
      `SELECT approved FROM groups_members WHERE group_id = ${secure(group_id, 'int')} AND user_id = ${secure(user_id, 'int')}`
    );
    if (get_membership.num_rows === 0) return false;
    return get_membership.rows[0].approved == 1 ? 'approved' : 'pending';
  },

  /**
   * check_event_membership (lean)
   * @param {number} user_id
   * @param {number} event_id
   * @return {Promise<boolean>}
   */
  async check_event_membership(user_id, event_id) {
    const get_membership = await query(
      `SELECT COUNT(*) as count FROM events_members WHERE event_id = ${secure(event_id, 'int')} AND user_id = ${secure(user_id, 'int')}`
    );
    return get_membership.rows[0].count > 0;
  },

  /**
   * get_country
   * @param {number} country_id
   * @return {Promise<Object|false>}
   */
  async get_country(country_id) {
    const get_country = await query(
      `SELECT * FROM system_countries WHERE country_id = ${secure(country_id, 'int')}`
    );
    if (get_country.num_rows === 0) return false;
    return get_country.rows[0];
  },

  /**
   * get_picture (instance helper bound to the loaded system)
   * @param {string} picture
   * @param {string} type
   * @return {string}
   */
  get_picture(picture, type) {
    return get_picture(picture, type, this.system);
  },
};
