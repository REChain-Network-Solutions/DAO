/**
 * sockets -> nodejs -> libs -> core -> database
 * 
 * @package Sngine
 * @author Zamblek
 */

const mysql = require('mysql2/promise');
const config = require('./config');

let pool = null;

/**
 * init_db_connection
 *
 * @return {import('mysql2/promise').Pool}
 */
function init_db_connection() {
  if (pool) return pool;
  pool = mysql.createPool({
    host: config.DB_HOST,
    user: config.DB_USER,
    password: config.DB_PASSWORD,
    database: config.DB_NAME,
    port: parseInt(config.DB_PORT, 10),
    charset: 'utf8mb4',
    timezone: 'Z', // UTC (mirrors SET time_zone = '+0:00')
    waitForConnections: true,
    connectionLimit: 10,
    namedPlaceholders: false,
    dateStrings: true,
  });
  return pool;
}

/**
 * query
 * 
 * @param {string} sql
 * @return {Promise<{rows: any[], num_rows: number, insertId: number, affectedRows: number}>}
 */
async function query(sql) {
  const conn = init_db_connection();
  const [result] = await conn.query(sql);
  if (Array.isArray(result)) {
    // SELECT
    return {
      rows: result,
      num_rows: result.length,
      insertId: 0,
      affectedRows: 0,
      fetch_assoc() {
        return this.rows.shift() || null;
      },
    };
  }
  // INSERT/UPDATE/DELETE
  return {
    rows: [],
    num_rows: 0,
    insertId: result.insertId || 0,
    affectedRows: result.affectedRows || 0,
    fetch_assoc() {
      return null;
    },
  };
}

/**
 * html_entities
 * 
 * @param {string} value
 * @return {string}
 */
function html_entities(value) {
  return String(value)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#039;');
}

/**
 * real_escape_string
 * 
 * @param {string} value
 * @return {string}
 */
function real_escape_string(value) {
  return String(value).replace(/[\0\x08\x09\x1a\n\r"'\\%]/g, (char) => {
    switch (char) {
      case '\0':
        return '\\0';
      case '\x08':
        return '\\b';
      case '\x09':
        return '\\t';
      case '\x1a':
        return '\\z';
      case '\n':
        return '\\n';
      case '\r':
        return '\\r';
      case '"':
      case "'":
      case '\\':
        return '\\' + char;
      default:
        return char;
    }
  });
}

/**
 * is_empty
 *
 * @param {*} value
 * @return {boolean}
 */
function is_empty(value) {
  return value === undefined || value === null || String(value).trim() === '';
}

/**
 * secure
 * 
 * @param {*} value
 * @param {string} type  '', 'int', 'float', 'datetime', 'search'
 * @param {boolean} quoted
 * @return {string|number}
 */
function secure(value, type = '', quoted = true) {
  if (value === 'null') return value;
  // [1] Sanitize
  value = html_entities(value === undefined || value === null ? '' : value);
  // [2] Safe SQL
  value = real_escape_string(value);
  switch (type) {
    case 'int': {
      const int = parseInt(value, 10) || 0;
      return quoted ? "'" + int + "'" : int;
    }
    case 'float': {
      const float = parseFloat(value) || 0;
      return quoted ? "'" + float + "'" : float;
    }
    case 'datetime':
      return quoted ? "'" + value + "'" : value;
    case 'search':
      return !is_empty(value) ? "'%" + value + "%'" : "''";
    default:
      value = !is_empty(value) ? value : '';
      return quoted ? "'" + value + "'" : value;
  }
}

module.exports = {
  init_db_connection,
  query,
  secure,
  html_entities,
  is_empty,
};
