/**
 * sockets -> nodejs -> libs -> core -> config
 * 
 * @package Sngine
 * @author Zamblek
 */

const fs = require('fs');
const path = require('path');

// ABSPATH -> project root (two levels up from sockets/node)
const ABSPATH = path.resolve(__dirname, '..', '..', '..', '..');

/**
 * define
 * 
 * @param {string} contents
 * @param {string} name
 * @return {string|null}
 */
function define(contents, name) {
  const match = contents.match(
    new RegExp("define\\(\\s*['\"]" + name + "['\"]\\s*,\\s*(['\"])([\\s\\S]*?)\\1\\s*\\)", 'm')
  );
  return match ? match[2] : null;
}

/* check config file */
const configPath = path.join(ABSPATH, 'includes', 'config.php');
if (!fs.existsSync(configPath)) {
  console.log('❌ Config file not found');
  process.exit(1);
}

/* get config file */
const contents = fs.readFileSync(configPath, 'utf8');

const config = {
  ABSPATH,
  DB_NAME: define(contents, 'DB_NAME'),
  DB_USER: define(contents, 'DB_USER'),
  DB_PASSWORD: define(contents, 'DB_PASSWORD'),
  DB_HOST: define(contents, 'DB_HOST') || 'localhost',
  DB_PORT: define(contents, 'DB_PORT') || '3306',
  SYS_URL: define(contents, 'SYS_URL') || '',
  DEFAULT_LOCALE: define(contents, 'DEFAULT_LOCALE') || 'en_us',
  DEBUGGING: /define\(\s*['"]DEBUGGING['"]\s*,\s*true\s*\)/i.test(contents),
};

module.exports = config;
