/**
 * sockets -> nodejs -> libs -> core -> jwt
 * 
 * @package Sngine
 * @author Zamblek
 */

const jwt = require('jsonwebtoken');

/**
 * decode_jwt
 *
 * @param {string} token
 * @param {string} key  system['system_jwt_key']
 * @return {{uid: (number|string), token: string}}
 * @throws {Error} on invalid/expired token
 */
function decode_jwt(token, key) {
  const payload = jwt.verify(token, key, { algorithms: ['HS256'] });
  return {
    uid: payload.uid,
    token: payload.token,
  };
}

module.exports = { decode_jwt };
