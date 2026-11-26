<?php

/**
 * functions -> system
 * 
 * @package Sngine
 * @author Zamblek
 */

/* ------------------------------- */
/* System */
/* ------------------------------- */

/**
 * get_system_protocol
 * 
 * @return string
 */
function get_system_protocol()
{
  $is_secure = false;
  if (isset($_SERVER['HTTPS']) && strtolower($_SERVER['HTTPS']) == 'on') {
    $is_secure = true;
  } elseif (!empty($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] == 'https' || !empty($_SERVER['HTTP_X_FORWARDED_SSL']) && $_SERVER['HTTP_X_FORWARDED_SSL'] == 'on') {
    $is_secure = true;
  }
  return $is_secure ? 'https' : 'http';
}


/**
 * get_system_url
 * 
 * @return string
 */
function get_system_url()
{
  $protocol = get_system_protocol();
  $system_url =  $protocol . "://" . $_SERVER['HTTP_HOST'] . dirname($_SERVER['PHP_SELF']);
  return rtrim($system_url, '/');
}


/**
 * check_system_url
 * 
 * @return void
 */
function check_system_url()
{
  $protocol = get_system_protocol();
  $parsed_url = parse_url(SYS_URL);
  if (($parsed_url['scheme'] != $protocol) || ($parsed_url['host'] != $_SERVER['HTTP_HOST'])) {
    header('Location: ' . SYS_URL);
  }
}


/**
 * init_system_session
 * 
 * @return void
 */
function init_system_session()
{
  ini_set('session.cookie_httponly', 1);
  if (get_system_protocol() == "https") {
    ini_set('session.cookie_secure', 1);
    /* Sign in with Apple (and similar) returns via cross-site POST; Lax session cookies are not sent on that POST, so Hybridauth loses OAuth state. */
    if (PHP_VERSION_ID >= 70300) {
      session_set_cookie_params([
        'lifetime' => 0,
        'path' => '/',
        'secure' => true,
        'httponly' => true,
        'samesite' => 'None',
      ]);
    }
  }
  /* store sessions in Redis when enabled and reachable (otherwise PHP's default files) */
  if (redis_feature('sessions') && redis()) {
    session_set_save_handler(new RedisSessionHandler(), true);
  }
  session_start();
  /* set session secret */
  if (!isset($_SESSION['secret'])) {
    $_SESSION['secret'] = get_hash_token();
  }
  /* release the session lock early for requests that never write the session */
  if (defined('SESSION_READ_ONLY') && SESSION_READ_ONLY) {
    session_write_close();
  }
}


/**
 * allow_iframe_embedding
 * 
 * @return void
 */
function allow_iframe_embedding()
{
  if (headers_sent()) {
    return;
  }
  header_remove('X-Frame-Options');
  header_remove('Content-Security-Policy');
  header("Content-Security-Policy: frame-ancestors https: http:");
}


/**
 * init_system_datetime
 * 
 * @return string
 */
function init_system_datetime()
{
  date_default_timezone_set('UTC');
  $minutes_to_add = 0;
  $DateTime = new DateTime();
  $DateTime->add(new DateInterval('PT' . $minutes_to_add . 'M'));
  return $DateTime->format('Y-m-d H:i:s');
}


/**
 * init_db_connection
 * 
 * @param string $db_host
 * @param string $db_user
 * @param string $db_password
 * @param string $db_name
 * @param string $db_port
 * @return object
 */
function init_db_connection($db_host = null, $db_user = null, $db_password = null, $db_name = null, $db_port = null)
{
  $db_host = (isset($db_host)) ? $db_host : DB_HOST;
  $db_user = (isset($db_user)) ? $db_user : DB_USER;
  $db_password = (isset($db_password)) ? $db_password : DB_PASSWORD;
  $db_name = (isset($db_name)) ? $db_name : DB_NAME;
  $db_port = (isset($db_port)) ? $db_port : DB_PORT;
  $db = new mysqli($db_host, $db_user, $db_password, $db_name, $db_port);
  if (mysqli_connect_error()) {
    throw new Exception("DB_ERROR");
  }
  /* set db charset */
  $db->set_charset('utf8mb4');
  /* set db time to UTC */
  $db->query("SET time_zone = '+0:00'");
  return $db;
}


/**
 * check_db_version
 *
 * @param object $db
 * @return boolean
 */
function check_db_version($db)
{
  $get_version = $db->query("SELECT VERSION() AS version");
  if (!$get_version) {
    return false;
  }
  $version = preg_replace('/^5\.5\.5-/', '', $get_version->fetch_assoc()['version']);
  if (!preg_match('/^\d+(\.\d+)*/', $version, $matches)) {
    return false;
  }
  /* set required db version */
  $required_db_version = (stripos($version, 'mariadb') !== false) ? '10.6' : '8.0';
  return version_compare($matches[0], $required_db_version, '>=');
}


/**
 * theme_landing_thumbnail
 * 
 * @param string $theme
 * @param string $slug
 * @param string $variant
 * @return string
 */
function theme_landing_thumbnail($theme, $slug, $variant = 'light')
{
  if (empty($theme) || empty($slug) || str_contains($slug, '..') || str_contains($slug, '/') || str_contains($slug, '\\')) {
    return '';
  }
  $file = ($variant === 'dark') ? 'thumbnail-dark' : 'thumbnail';
  foreach (['webp', 'png'] as $extension) {
    $path = 'content/themes/' . $theme . '/images/landing/' . $slug . '/' . $file . '.' . $extension;
    if (is_file(ABSPATH . $path)) {
      return $path;
    }
  }
  return '';
}

/**
 * theme_landing_thumbnails
 * 
 * @param string $theme
 * @param string $slug
 * @return array
 */
function theme_landing_thumbnails($theme, $slug)
{
  return [
    'thumbnail_light' => theme_landing_thumbnail($theme, $slug, 'light'),
    'thumbnail_dark' => theme_landing_thumbnail($theme, $slug, 'dark'),
  ];
}

/**
 * theme_landing_wallpaper
 * 
 * @param string $theme
 * @param string $slug
 * @return string
 */
function theme_landing_wallpaper($theme, $slug)
{
  if (empty($slug) || str_contains($slug, '..') || str_contains($slug, '/') || str_contains($slug, '\\')) {
    $slug = 'default';
  }
  foreach (array_unique([$slug, 'default']) as $folder) {
    foreach (['webp', 'jpg'] as $extension) {
      $path = 'content/themes/' . $theme . '/images/landing/' . $folder . '/welcome.' . $extension;
      if (is_file(ABSPATH . $path)) {
        return $path;
      }
    }
  }
  return 'content/themes/' . $theme . '/images/landing/default/welcome.webp';
}

/**
 * init_system
 * 
 * @return array
 */
function init_system()
{
  global $db, $gettextTranslations;

  /* load the compiled system config */
  $config = system_config_load();
  $system = $config['system'];
  $system_themes = $config['themes'];

  /* set system theme */
  if (isset($_GET['theme'])) {
    if (array_key_exists($_GET['theme'], $system['themes'])) {
      if (file_exists(ABSPATH . 'content/themes/' . $_GET['theme'])) {
        $system['theme'] = $_GET['theme'];
        /* set theme cookie */
        set_cookie('s_theme', $_GET['theme']);
      }
    }
  } elseif (isset($_COOKIE['s_theme'])) {
    if (array_key_exists($_COOKIE['s_theme'], $system['themes'])) {
      if (file_exists(ABSPATH . 'content/themes/' . $_COOKIE['s_theme'])) {
        $system['theme'] = $_COOKIE['s_theme'];
      } else {
        /* unset theme cookie */
        unset_cookie('s_theme');
      }
    }
  } else {
    if (!isset($system['theme'])) {
      $system['theme'] = "nova";
    }
  }
  if (!isset($system['theme'])) {
    $system['theme'] = "nova";
  }

  /* overlay active theme design settings */
  $theme_design_defaults = [
    'fluid_design' => '0',
    'system_theme_night_on' => '0',
    'system_theme_mode_select' => '1',
    'system_theme_icons' => 'tabler',
    'system_theme_fonts' => 'google',
    'system_wallpaper_default' => '1',
    'system_wallpaper' => '',
    'css_customized' => '0',
    'css_background' => '',
    'css_link_color' => '',
    'css_header' => '',
    'css_header_search' => '',
    'css_header_search_color' => '',
    'css_btn_primary' => '',
    'css_header_icons' => '',
    'css_header_icons_night' => '',
    'css_main_icons' => '',
    'css_main_icons_night' => '',
    'css_action_icons' => '',
    'css_action_icons_night' => '',
    'css_custome_css' => '',
    'bottom_bar' => '',
    'sidebar' => '',
    'sidebar_more' => '',
  ];
  $active_theme = $system_themes[$system['theme']] ?? [];
  foreach ($theme_design_defaults as $theme_design_key => $theme_design_default) {
    $system[$theme_design_key] = $active_theme[$theme_design_key] ?? $theme_design_default;
  }

  /* resolve the active landing template */
  $landing_slug = $active_theme['landing'] ?? 'default';
  if ($landing_slug === '' || str_contains($landing_slug, '..') || str_contains($landing_slug, '/') || str_contains($landing_slug, '\\')) {
    $landing_slug = 'default';
  }
  $system['landing_preview'] = false;
  if (!empty($system['themes_demo_enabled']) && isset($_GET['landing']) && is_string($_GET['landing']) && preg_match('/^[A-Za-z0-9_-]{1,64}$/', $_GET['landing']) && !empty($active_theme['theme_id'])) {
    /* preview a landing registered for the active theme (demo only, not persisted) */
    $get_landing_preview = $db->query(sprintf("SELECT slug FROM system_theme_landings WHERE theme_id = %s AND slug = %s LIMIT 1", secure($active_theme['theme_id'], 'int'), secure($_GET['landing'])));
    if ($get_landing_preview && $get_landing_preview->num_rows > 0) {
      $landing_preview_slug = $get_landing_preview->fetch_assoc()['slug'];
      if ($landing_preview_slug === 'default' || is_file(ABSPATH . 'content/themes/' . $system['theme'] . '/templates/index.landing.' . $landing_preview_slug . '.tpl')) {
        $landing_slug = $landing_preview_slug;
        $system['landing_preview'] = true;
      }
    }
  }
  $landing_template = 'index.landing.tpl';
  if ($landing_slug !== 'default') {
    $landing_candidate = 'index.landing.' . $landing_slug . '.tpl';
    if (is_file(ABSPATH . 'content/themes/' . $system['theme'] . '/templates/' . $landing_candidate)) {
      $landing_template = $landing_candidate;
    }
  }
  $system['landing'] = $landing_slug;
  $system['landing_template'] = $landing_template;

  /* set system theme (day|night) mode */
  $system['theme_mode_night'] = $system['system_theme_night_on'];
  if ($system['system_theme_mode_select']) {
    if (isset($_COOKIE['s_night_mode'])) {
      /* get cookei for web app */
      $system['theme_mode_night'] = ($_COOKIE['s_night_mode']) ? 1 : 0;
    }
  }

  /* set system langauge */
  $system['current_language'] = DEFAULT_LOCALE;
  $user_language = get_user_language_country()['language'];
  if (isset($_GET['lang'])) {
    /* get GET for web app */
    if (array_key_exists($_GET['lang'], $system['languages'])) {
      $system['language'] = $system['languages'][$_GET['lang']];
      $system['current_language'] = $system['language']['code'];
      /* set language cookie */
      set_cookie('s_lang', $_GET['lang']);
    }
  } elseif (isset($_COOKIE['s_lang'])) {
    /* get cookie for web app */
    if (array_key_exists($_COOKIE['s_lang'], $system['languages'])) {
      $system['language'] = $system['languages'][$_COOKIE['s_lang']];
      $system['current_language'] = $system['language']['code'];
    }
  } elseif (isset(_getallheaders()["x-lang"])) {
    /* get header for web app */
    if (array_key_exists(_getallheaders()["x-lang"], $system['languages'])) {
      $system['language'] = $system['languages'][_getallheaders()["x-lang"]];
      $system['current_language'] = $system['language']['code'];
    }
  } elseif ($system['auto_language_detection'] && $user_language && array_key_exists($user_language, $system['languages'])) {
    /* get user language */
    $system['language'] = $system['languages'][$user_language];
    $system['current_language'] = $system['language']['code'];
  } else {
    if (isset($system['default_language'])) {
      $system['language'] = $system['default_language'];
      $system['current_language'] = $system['default_language']['code'];
    }
  }

  /* load translations */
  $gettextTranslations = translations_load($system['current_language']);
  /* keep the modules names in the admin panel */
  if ($gettextTranslations && $system['current_language'] == DEFAULT_LOCALE && preg_match('#/(admin|moderator)\.php$|/includes/ajax/admin/#', $_SERVER['SCRIPT_NAME'] ?? '')) {
    $gettextTranslations = [];
  }

  /* check if viewer IP banned */
  $check_banned_ip = $db->query(sprintf("SELECT COUNT(*) as count FROM blacklist WHERE node_type = 'ip' AND node_value = %s", secure(get_user_ip())));
  $system['viewer_ip_banned'] = ($check_banned_ip->fetch_assoc()['count'] > 0) ? true : false;

  /* disable Payments & Monetization flags when not entitled (memory only) */
  licence_refresh_if_needed();
  licence_disable_premium_flags($system);

  /* return */
  return $system;
}


/**
 * system_config_load
 * 
 * @return array
 */
function system_config_load()
{
  return system_cache_remember('system', 'system_config_build');
}


/**
 * system_config_build
 * 
 * @return array
 */
function system_config_build()
{
  global $db;

  /* init system */
  $system = [];

  /* get system options */
  $get_system_options = $db->query("SELECT * FROM system_options");
  while ($system_option = $get_system_options->fetch_assoc()) {
    $system[$system_option['option_name']] = $system_option['option_value'];
  }
  $system['ads_budget_priority_enabled'] = $system['ads_budget_priority_enabled'] ?? '0';
  /* Redis defaults (optional) */
  $system += [
    'redis_enabled' => '0',
    'redis_host' => '127.0.0.1',
    'redis_port' => '6379',
    'redis_password' => '',
    'redis_database' => '0',
    'redis_prefix' => '',
    'redis_tls_enabled' => '0',
    'redis_widgets_enabled' => '1',
    'redis_relations_enabled' => '1',
    'redis_sessions_enabled' => '0',
    'redis_post_views_enabled' => '0',
  ];
  /* verification documents defaults */
  $system += [
    'verification_user_photo_enabled' => '1',
    'verification_user_photo_title' => 'Your Photo',
    'verification_user_passport_enabled' => '1',
    'verification_user_passport_title' => 'Passport or National ID',
    'verification_page_photo_enabled' => '1',
    'verification_page_photo_title' => 'Company Incorporation File',
    'verification_page_passport_enabled' => '1',
    'verification_page_passport_title' => 'Company Tax File',
  ];

  /* check system JWT */
  if (!$system['system_jwt_key']) {
    $system['system_jwt_key'] = generate_jwt_key();
    /* update */
    update_system_options([
      'system_jwt_key' => secure($system['system_jwt_key']),
    ]);
  }

  /* set system version */
  $system['system_version'] = SYS_VER;

  /* set system URL */
  $system['system_url'] = SYS_URL;

  /* set system debugging */
  $system['DEBUGGING'] = DEBUGGING;

  /* set system_date_format */
  $system['system_date_format'] = explode(' ', $system['system_datetime_format'], 2)[0];

  /* set system uploads */
  if ($system['uploads_cdn_url']) {
    $system['system_uploads'] = $system['uploads_cdn_url'];
  } else {
    if ($system['s3_enabled']) {
      $endpoint = "https://s3." . $system['s3_region'] . ".amazonaws.com/" . $system['s3_bucket'];
      $system['system_uploads'] = $endpoint . "/uploads";
    } elseif ($system['google_cloud_enabled']) {
      $endpoint = "https://storage.googleapis.com/" . $system['google_cloud_bucket'];
      $system['system_uploads'] = $endpoint . "/uploads";
    } elseif ($system['digitalocean_enabled']) {
      $endpoint = "https://" . $system['digitalocean_space_name'] . "." . $system['digitalocean_space_region'] . ".digitaloceanspaces.com";
      $system['system_uploads'] = $endpoint . "/uploads";
    } elseif ($system['wasabi_enabled']) {
      $endpoint = "https://s3." . $system['wasabi_region'] . ".wasabisys.com/" . $system['wasabi_bucket'];
      $system['system_uploads'] = $endpoint . "/uploads";
    } elseif ($system['backblaze_enabled']) {
      $endpoint = "https://s3." . $system['backblaze_region'] . ".backblazeb2.com/" . $system['backblaze_bucket'];
      $system['system_uploads'] = $endpoint . "/uploads";
    } elseif ($system['yandex_cloud_enabled']) {
      $endpoint = "https://storage.yandexcloud.net/" . $system['yandex_cloud_bucket'];
      $system['system_uploads'] = $endpoint . "/uploads";
    } elseif ($system['cloudflare_r2_enabled']) {
      $endpoint = $system['cloudflare_r2_custom_domain'];
      $system['system_uploads'] = $endpoint . "/uploads";
    } elseif ($system['pushr_enabled']) {
      $endpoint = $system['pushr_hostname'];
      $system['system_uploads'] = $endpoint . "/uploads";
    } elseif ($system['ovh_enabled']) {
      $endpoint = "https://" . $system['ovh_bucket'] . ".s3." . $system['ovh_region'] . ".io.cloud.ovh.net";
      $system['system_uploads'] = $endpoint . "/uploads";
    } elseif ($system['bunny_enabled']) {
      $endpoint = bunny_public_url($system);
      $system['system_uploads'] = $endpoint . "/uploads";
    } elseif ($system['storj_enabled']) {
      $endpoint = storj_public_url($system['storj_url']);
      $system['system_uploads'] = $endpoint . "/uploads";
    } elseif ($system['ftp_enabled']) {
      $system['system_uploads'] = $system['ftp_endpoint'];
    } else {
      $system['system_uploads'] = $system['system_url'] . '/' . $system['uploads_directory'];
    }
  }

  /* set agora uploads */
  if ($system['live_enabled'] && $system['save_live_enabled']) {
    if ($system['agora_s3_public_url']) {
      $system['system_agora_uploads'] = $system['agora_s3_public_url'];
    } elseif ($system['agora_s3_endpoint']) {
      $system['system_agora_uploads'] = $system['agora_s3_endpoint'] . "/" . $system['agora_s3_bucket'];
    } else {
      $system['system_agora_uploads'] = "https://s3." . $system['agora_s3_region'] . ".amazonaws.com/" . $system['agora_s3_bucket'];
    }
  }

  /* set uploads accpeted extensions */
  $system['accpeted_video_extensions'] = set_extensions_string($system['video_extensions']);
  $system['accpeted_audio_extensions'] = set_extensions_string($system['audio_extensions']);
  $system['accpeted_file_extensions'] = set_extensions_string($system['file_extensions']);

  /* get system themes */
  $system_themes = [];
  $system['themes'] = [];
  $get_system_themes = $db->query("SELECT * FROM system_themes");
  while ($theme = $get_system_themes->fetch_assoc()) {
    $theme['title'] = (!empty($theme['title'])) ? $theme['title'] : $theme['name'];
    $system_themes[$theme['name']] = $theme;
    if ($theme['default']) {
      $system['theme'] = $theme['name'];
    }
    if ($theme['enabled']) {
      $system['themes'][$theme['name']] = $theme;
    }
  }

  /* get system languages */
  $get_system_languages = $db->query("SELECT * FROM system_languages WHERE enabled = '1' ORDER BY language_order");
  while ($language = $get_system_languages->fetch_assoc()) {
    $language['flag'] = get_picture($language['flag'], 'flag', $system);
    if ($language['default']) {
      $system['default_language'] = $language;
    }
    $system['languages'][$language['code']] = $language;
  }

  /* get system currency */
  $get_currency = $db->query("SELECT * FROM system_currencies WHERE system_currencies.default = '1'");
  $currency = $get_currency->fetch_assoc();
  $system['system_currency'] = $currency['code'];
  $system['system_currency_id'] = $currency['currency_id'];
  $system['system_currency_symbol'] = $currency['symbol'];
  $system['system_currency_dir'] = $currency['dir'];

  /* get system country */
  $get_country = $db->query("SELECT * FROM system_countries WHERE system_countries.default = '1'");
  $country = $get_country->fetch_assoc();
  $system['default_country'] = $country;

  /* get system withdrawal method array */
  $system['wallet_payment_method_array'] = explode(",", $system['wallet_payment_method']);
  $system['affiliate_payment_method_array'] = explode(",", $system['affiliate_payment_method']);
  $system['points_payment_method_array'] = explode(",", $system['points_payment_method']);
  $system['market_payment_method_array'] = explode(",", $system['market_payment_method']);
  $system['funding_payment_method_array'] = explode(",", $system['funding_payment_method']);
  $system['monetization_payment_method_array'] = explode(",", $system['monetization_payment_method']);

  /* get system reactions */
  $reactions = [];
  $reactions_enabled = [];
  $get_reactions = $db->query("SELECT * FROM system_reactions ORDER BY reaction_order ASC");
  if ($get_reactions->num_rows > 0) {
    while ($reaction = $get_reactions->fetch_assoc()) {
      $reaction['image_url'] = $system['system_uploads'] . '/' . $reaction['image'];
      $reactions[$reaction['reaction']] = $reaction;
      if ($reaction['enabled']) {
        $reactions_enabled[$reaction['reaction']] = $reaction;
      }
    }
  }
  $system['reactions'] = $reactions;
  $system['reactions_enabled'] = $reactions_enabled;

  /* return */
  return ['system' => $system, 'themes' => $system_themes];
}


/**
 * get_photo_layout_presets
 * 
 * @return array
 */
function get_photo_layout_presets()
{
  return [
    'classic' => [
      2 => ['container' => 'grid h-72 grid-cols-2 gap-0.5 sm:h-96', 'first' => '', 'tile' => '', 'offset' => '', 'visible' => 2, 'mobile' => 0],
      3 => ['container' => 'grid h-80 grid-cols-3 grid-rows-2 gap-0.5 sm:h-[30rem]', 'first' => 'col-span-2 row-span-2', 'tile' => '', 'offset' => '', 'visible' => 3, 'mobile' => 0],
      4 => ['container' => 'grid h-96 grid-cols-3 grid-rows-3 gap-0.5 sm:h-[34rem]', 'first' => 'col-span-2 row-span-3', 'tile' => '', 'offset' => '', 'visible' => 4, 'mobile' => 0],
    ],
    'columns' => [
      2 => ['container' => 'grid grid-cols-2 items-start gap-2 bg-base-100 p-2 sm:gap-4 sm:p-4', 'first' => '', 'tile' => 'aspect-[4/7] rounded-2xl', 'offset' => 'mt-8 sm:mt-12', 'visible' => 2, 'mobile' => 0],
      3 => ['container' => 'grid grid-cols-3 items-start gap-2 bg-base-100 p-2 sm:gap-4 sm:p-4', 'first' => '', 'tile' => 'aspect-[3/7] rounded-2xl', 'offset' => 'mt-8 sm:mt-12', 'visible' => 3, 'mobile' => 0],
      4 => ['container' => 'grid grid-cols-3 items-start gap-2 bg-base-100 p-2 sm:grid-cols-4 sm:gap-4 sm:p-4', 'first' => '', 'tile' => 'aspect-[3/8] rounded-2xl', 'offset' => 'mt-8 sm:mt-10', 'visible' => 4, 'mobile' => 3],
    ],
    'frame' => [
      2 => ['container' => 'grid h-80 grid-cols-1 grid-rows-3 gap-0.5 sm:h-[30rem]', 'first' => 'col-span-full row-span-2', 'tile' => '', 'offset' => '', 'visible' => 2, 'mobile' => 0],
      3 => ['container' => 'grid h-80 grid-cols-2 grid-rows-3 gap-0.5 sm:h-[30rem]', 'first' => 'col-span-full row-span-2', 'tile' => '', 'offset' => '', 'visible' => 3, 'mobile' => 0],
      4 => ['container' => 'grid h-80 grid-cols-3 grid-rows-3 gap-0.5 sm:h-[30rem]', 'first' => 'col-span-full row-span-2', 'tile' => '', 'offset' => '', 'visible' => 4, 'mobile' => 0],
    ],
  ];
}


/**
 * get_photo_layout
 * 
 * @param string $layout
 * @param integer $count
 * @return array
 */
function get_photo_layout($layout, $count)
{
  $presets = get_photo_layout_presets();
  $layout = is_string($layout) && isset($presets[$layout]) ? $layout : 'classic';
  if ($count < 2) {
    return ['container' => '', 'first' => '', 'tile' => '', 'offset' => '', 'visible' => max(0, (int) $count), 'mobile' => 0];
  }
  return $presets[$layout][min(4, (int) $count)];
}


/**
 * order_post_photos
 * 
 * @param array $photos
 * @param array $order
 * @return array
 */
function order_post_photos($photos, $order)
{
  if (!is_array($order) || !array_is_list($order) || count($order) !== count($photos)) {
    throw new InvalidArgumentException('Invalid photo order');
  }
  $by_source = [];
  foreach ($photos as $photo) {
    if (isset($by_source[$photo['source']])) {
      throw new InvalidArgumentException('Duplicate photo source');
    }
    $by_source[$photo['source']] = $photo;
  }
  $ordered = [];
  foreach ($order as $source) {
    if (!is_string($source) || !isset($by_source[$source])) {
      throw new InvalidArgumentException('Invalid photo order');
    }
    $ordered[] = $by_source[$source];
    unset($by_source[$source]);
  }
  return $ordered;
}


/**
 * init_smarty
 * 
 * @return object
 */
function init_smarty()
{
  global $system;
  $smarty = new Smarty\Smarty;
  $smarty->setTemplateDir(ABSPATH . 'content/themes/' . $system['theme'] . '/templates');
  $smarty->setCompileDir(ABSPATH . 'content/themes/' . $system['theme'] . '/templates_compiled');
  $smarty->registerPlugin("modifier", "ucfirst", "ucfirst");
  $smarty->registerPlugin('modifier', '__', '__');
  $smarty->registerPlugin('modifier', 'print_money', 'print_money');
  $smarty->registerPlugin('modifier', 'abbreviate_count', 'abbreviate_count');
  $smarty->registerPlugin('modifier', 'is_empty', 'is_empty');
  $smarty->registerPlugin('modifier', 'array_reverse', 'array_reverse');
  $smarty->registerPlugin('modifier', 'get_vimeo_id', 'get_vimeo_id');
  $smarty->registerPlugin('modifier', 'get_youtube_id', 'get_youtube_id');
  $smarty->registerPlugin('modifier', 'html_entity_decode', 'html_entity_decode');
  $smarty->registerPlugin('modifier', 'strtoupper', 'strtoupper');
  $smarty->registerPlugin('modifier', 'count', 'count');
  $smarty->registerPlugin('modifier', 'explode', 'explode');
  $smarty->registerPlugin('modifier', 'date', 'date');
  $smarty->registerPlugin('modifier', 'number_format', 'number_format');
  $smarty->registerPlugin('modifier', 'strtolower', 'strtolower');
  $smarty->registerPlugin('modifier', 'strip_tags', 'strip_tags');
  $smarty->registerPlugin('modifier', 'photo_layout', 'get_photo_layout');
  $smarty->registerPlugin('modifier', 'get_feeling_emoji', 'get_feeling_emoji');
  $smarty->assign('photo_layout_presets_json', json_encode(get_photo_layout_presets()));
  /* payment modifiers: real helpers live in functions-payments.php (insert); stubs keep shared templates from fatalling on Regular */
  if (!function_exists('get_payment_vat_percentage')) {
    function get_payment_vat_percentage()
    {
      return 0;
    }
  }
  if (!function_exists('get_payment_vat_value')) {
    function get_payment_vat_value($amount, $printed = false)
    {
      return $printed ? html_entity_decode(print_money(0), ENT_QUOTES) : 0;
    }
  }
  if (!function_exists('get_payment_fees_value')) {
    function get_payment_fees_value($amount, $printed = false)
    {
      return $printed ? html_entity_decode(print_money(0), ENT_QUOTES) : 0;
    }
  }
  if (!function_exists('get_payment_total_value')) {
    function get_payment_total_value($amount, $printed = false)
    {
      $total = "" . round((float) $amount, 2);
      return $printed ? html_entity_decode(print_money($total), ENT_QUOTES) : $total;
    }
  }
  $smarty->registerPlugin('modifier', 'get_payment_vat_value', 'get_payment_vat_value');
  $smarty->registerPlugin('modifier', 'get_payment_total_value', 'get_payment_total_value');
  $smarty->registerPlugin('modifier', 'get_payment_fees_value', 'get_payment_fees_value');
  $smarty->registerPlugin('modifier', 'get_payment_vat_percentage', 'get_payment_vat_percentage');
  $smarty->registerPlugin('modifier', 'trim', 'trim');
  $smarty->registerPlugin('modifier', 'filemtime', 'filemtime');
  $smarty->registerPlugin('modifier', 'floor', 'floor');
  $smarty->registerPlugin('modifier', 'is_file', 'is_file');
  $smarty->registerPlugin('modifier', 'theme_module_icon', 'theme_module_icon');
  $smarty->registerPlugin('modifier', 'bottom_bar_items', 'bottom_bar_items');
  $smarty->registerPlugin('modifier', 'sidebar_items', 'sidebar_items');
  $smarty->registerPlugin('modifier', 'user_card_details', 'user_card_details');
  $smarty->registerPlugin('function', 'theme_assets', 'theme_assets');
  return $smarty;
}


/**
 * update_system_options
 * 
 * @param array $args
 * @param boolean $error_thrown
 * @return void
 */
function update_system_options($args = [], $error_thrown = true)
{
  global $db;
  $query_values = "";
  foreach ($args as $key => $value) {
    $query_values .= sprintf(" ('%s', %s),", $key, $value);
  }
  $query_values = substr($query_values, 0, -1);
  $db->query("INSERT INTO system_options (option_name, option_value) VALUES " . $query_values . " ON DUPLICATE KEY UPDATE option_name = VALUES(option_name), option_value = VALUES(option_value)") or ($error_thrown) ? _error('SQL_ERROR_THROWEN') : _error("Error", $db->error);
  system_cache_flush();
}
