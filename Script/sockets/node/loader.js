/**
 * sockets -> nodejs -> loader
 *
 * @package Sngine
 * @author Zamblek
 */

const { init_db_connection } = require('./libs/core/database');
const { init_system } = require('./libs/core/system');
const { init_i18n } = require('./libs/core/i18n');

/* how long to wait for the database to become reachable on boot */
const DB_MAX_ATTEMPTS = 30;
const DB_RETRY_DELAY = 2000;

/**
 * loader
 *
 * @return {Promise<{system: Object}>}
 */
async function loader() {
  /* init database connection (creates the pool; connects lazily) */
  init_db_connection();

  /* init system — retry while the database boots. In Docker, MySQL is often
     still initializing when this container starts, so ECONNREFUSED here is
     transient: wait and retry instead of crashing the whole server. */
  let system;
  for (let attempt = 1; ; attempt++) {
    try {
      system = await init_system();
      break;
    } catch (e) {
      if (attempt >= DB_MAX_ATTEMPTS) {
        console.log('❌ System initialization error: ' + e.message);
        process.exit(1);
      }
      console.log(`⏳ Waiting for database... (${attempt}/${DB_MAX_ATTEMPTS}) ${e.message}`);
      await new Promise((resolve) => setTimeout(resolve, DB_RETRY_DELAY));
    }
  }

  /* check system JWT key */
  if (!system.system_jwt_key) {
    console.log("❌ system_jwt_key is not set, Please open the website once to generate it");
    process.exit(1);
  }

  /* check if system is live */
  if (system.system_live != 1) {
    console.log('❌ System is not live: ' + (system.system_message || ''));
    process.exit(1);
  }

  /* init modules names */
  init_i18n(system);

  // 🚀 Starting the sockets server ...
  return { system };
}

module.exports = { loader };
