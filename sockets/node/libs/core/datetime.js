/**
 * sockets -> nodejs -> libs -> core -> datetime
 * 
 * @package Sngine
 * @author Zamblek
 */

/**
 * init_system_datetime
 * 
 * @return {string}
 */
function init_system_datetime() {
  const d = new Date();
  const pad = (n) => String(n).padStart(2, '0');
  return (
    d.getUTCFullYear() +
    '-' +
    pad(d.getUTCMonth() + 1) +
    '-' +
    pad(d.getUTCDate()) +
    ' ' +
    pad(d.getUTCHours()) +
    ':' +
    pad(d.getUTCMinutes()) +
    ':' +
    pad(d.getUTCSeconds())
  );
}

module.exports = { init_system_datetime };
