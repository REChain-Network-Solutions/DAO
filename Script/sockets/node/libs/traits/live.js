/**
 * sockets -> nodejs -> libs -> traits -> live
 *
 * @package Sngine
 * @author Zamblek
 */

const { query, secure } = require('../core/database');

module.exports = {
  /**
   * check_live_post
   * @param {number} post_id
   * @return {Promise<boolean>}
   */
  async check_live_post(post_id) {
    const check_live = await query(
      `SELECT post_id FROM posts_live WHERE post_id = ${secure(post_id, 'int')} AND live_ended = '0'`
    );
    return check_live.num_rows > 0;
  },

  /**
   * check_live_comment
   * @param {number} post_id
   * @param {number} comment_id
   * @return {Promise<boolean>}
   */
  async check_live_comment(post_id, comment_id) {
    const check_comment = await query(
      `SELECT comments.comment_id FROM posts_comments comments LEFT JOIN posts_comments parents ON comments.node_type = 'comment' AND comments.node_id = parents.comment_id WHERE comments.comment_id = ${secure(comment_id, 'int')} AND ((comments.node_type = 'post' AND comments.node_id = ${secure(post_id, 'int')}) OR (parents.node_type = 'post' AND parents.node_id = ${secure(post_id, 'int')}))`
    );
    return check_comment.num_rows > 0;
  },
};
