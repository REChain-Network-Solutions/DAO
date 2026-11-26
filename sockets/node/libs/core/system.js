/**
 * sockets -> nodejs -> libs -> core -> system
 * 
 * @package Sngine
 * @author Zamblek
 */

const { query } = require('./database');
const config = require('./config');

/* system version */
const SYS_VER = '4.4';

/**
 * init_system
 *
 * @return {Promise<Object>}
 */
async function init_system() {
  const system = {};

  /* get system options */
  const get_system_options = await query('SELECT * FROM system_options');
  for (const option of get_system_options.rows) {
    system[option.option_name] = option.option_value;
  }

  /* set system version */
  system.system_version = SYS_VER;

  /* set system URL */
  system.system_url = config.SYS_URL;

  /* set system debugging */
  system.DEBUGGING = config.DEBUGGING;

  /* set system uploads */
  if (system.uploads_cdn_url) {
    system.system_uploads = system.uploads_cdn_url;
  } else if (system.s3_enabled == 1) {
    system.system_uploads = `https://s3.${system.s3_region}.amazonaws.com/${system.s3_bucket}/uploads`;
  } else if (system.google_cloud_enabled == 1) {
    system.system_uploads = `https://storage.googleapis.com/${system.google_cloud_bucket}/uploads`;
  } else if (system.digitalocean_enabled == 1) {
    system.system_uploads = `https://${system.digitalocean_space_name}.${system.digitalocean_space_region}.digitaloceanspaces.com/uploads`;
  } else if (system.wasabi_enabled == 1) {
    system.system_uploads = `https://s3.${system.wasabi_region}.wasabisys.com/${system.wasabi_bucket}/uploads`;
  } else if (system.backblaze_enabled == 1) {
    system.system_uploads = `https://s3.${system.backblaze_region}.backblazeb2.com/${system.backblaze_bucket}/uploads`;
  } else if (system.yandex_cloud_enabled == 1) {
    system.system_uploads = `https://storage.yandexcloud.net/${system.yandex_cloud_bucket}/uploads`;
  } else if (system.cloudflare_r2_enabled == 1) {
    system.system_uploads = `${system.cloudflare_r2_custom_domain}/uploads`;
  } else if (system.pushr_enabled == 1) {
    system.system_uploads = `${system.pushr_hostname}/uploads`;
  } else if (system.ovh_enabled == 1) {
    system.system_uploads = `https://${system.ovh_bucket}.s3.${system.ovh_region}.io.cloud.ovh.net/uploads`;
  } else if (system.bunny_enabled == 1) {
    const bunny_url = (system.bunny_url && /^https?:\/\//i.test(system.bunny_url) && !/storage\.bunnycdn\.com/i.test(system.bunny_url)) ? system.bunny_url.replace(/\/+$/, '') : `https://${system.bunny_zone}.b-cdn.net`;
    system.system_uploads = `${bunny_url}/uploads`;
  } else if (system.storj_enabled == 1) {
    const storj_url = String(system.storj_url || '').replace(/^(https?:\/\/link\.[^/]*storjshare\.io)\/s\//i, '$1/raw/').replace(/\/+$/, '');
    system.system_uploads = `${storj_url}/uploads`;
  } else if (system.ftp_enabled == 1) {
    system.system_uploads = system.ftp_endpoint;
  } else {
    system.system_uploads = `${system.system_url}/${system.uploads_directory}`;
  }

  /* get system theme (needed by get_picture() for default avatars) */
  const get_default_theme = await query("SELECT `name` FROM system_themes WHERE `default` = '1' LIMIT 1");
  system.theme = (get_default_theme.num_rows > 0 && get_default_theme.rows[0].name) ? get_default_theme.rows[0].name : 'default';

  /* get system reactions */
  system.reactions = {};
  system.reactions_enabled = {};
  const get_reactions = await query('SELECT * FROM system_reactions ORDER BY reaction_order ASC');
  for (const reaction of get_reactions.rows) {
    reaction.image_url = `${system.system_uploads}/${reaction.image}`;
    system.reactions[reaction.reaction] = reaction;
    if (reaction.enabled == 1) {
      system.reactions_enabled[reaction.reaction] = reaction;
    }
  }

  /* get system currency */
  const get_currency = await query("SELECT * FROM system_currencies WHERE system_currencies.default = '1'");
  if (get_currency.num_rows > 0) {
    const currency = get_currency.rows[0];
    system.system_currency = currency.code;
    system.system_currency_id = currency.currency_id;
    system.system_currency_symbol = currency.symbol;
    system.system_currency_dir = currency.dir;
  }

  return system;
}

module.exports = { init_system, SYS_VER };
