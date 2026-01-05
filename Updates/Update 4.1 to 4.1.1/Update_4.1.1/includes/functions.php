<?php

/**
 * functions
 *
 * @package Delus
 * @author Sorokin Dmitry Olegovich
 */


/* ------------------------------- */
/* Core */
/* ------------------------------- */

/**
 * check_system_requirements
 *
 * @return array
 */
function check_system_requirements()
{
  /* init errors */
  $errors = [];
  /* set required php version*/
  $required_php_version = '8.2';
  /* check php version */
  if (version_compare($required_php_version, PHP_VERSION, '>=')) {
    $errors['PHP'] = true;
  }
  /* check if mysqli enabled */
  if (!extension_loaded('mysqli') || !function_exists('mysqli_connect')) {
    $errors['mysqli'] = true;
  }
  /* check if curl enabled */
  if (!extension_loaded('curl') || !function_exists('curl_init')) {
    $errors['curl'] = true;
  }
  /* check if mbstring enabled */
  if (!extension_loaded('mbstring')) {
    $errors['mbstring'] = true;
  }
  /* check if gd enabled */
  if (!extension_loaded('gd') || !function_exists('gd_info')) {
    $errors['gd'] = true;
  }
  /* check if the mime_content_type function exists */
  if (!extension_loaded('fileinfo') || !function_exists('mime_content_type')) {
    $errors['fileinfo'] = true;
  }
  /* check if zip enabled */
  if (!extension_loaded('zip')) {
    $errors['zip'] = true;
  }
  /* check if allow_url_fopen enabled */
  if (!ini_get('allow_url_fopen')) {
    $errors['allow_url_fopen'] = true;
  }
  /* check if htaccess exist */
  if (!file_exists(ABSPATH . '.htaccess')) {
    $errors['htaccess'] = true;
  }
  /* check if config writable */
  if (!is_writable(ABSPATH . 'includes/config-example.php')) {
    $errors['config'] = true;
  }
  /* return */
  return $errors;
}


/**
 * get_licence_key
 *
 * @param string $code
 * @return string
 */
function get_licence_key($code)
{
  $url = 'https://Sorokin Dmitry Olegovich.com/licenses/Delus/verify.php';
  $data = "code=" . $code . "&domain=" . $_SERVER['HTTP_HOST'];
  $ch = curl_init();
  curl_setopt($ch, CURLOPT_URL, $url);
  curl_setopt($ch, CURLOPT_POST, 1);
  curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
  curl_setopt($ch, CURLOPT_USERAGENT, 'Mozilla/5.0 (Windows NT 5.1; rv:5.0) Gecko/20100101 Firefox/5.0 Firefox/5.0');
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
  curl_setopt($ch, CURLOPT_TIMEOUT, 30);
  curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
  curl_setopt($ch, CURLOPT_MAXREDIRS, 10);
  $response = curl_exec($ch);
  $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
  if (curl_errno($ch)) {
    throw new Exception("Error Processing Request");
  }
  curl_close($ch);
  if ($httpCode != 200) {
    throw new Exception("Error Processing Request");
  }
  $responseJson = json_decode($response, true);
  if ($responseJson['error']) {
    throw new Exception($responseJson['error']['message'] . ' Error Code #' . $responseJson['error']['code']);
  }
  return $responseJson['licence_key'];
}


/**
 * valid_api_request
 *
 * @return boolean
 */
function valid_api_request()
{
  global $system;
  $headers = _getallheaders();
  $apiKey = $headers["x-api-key"] ?? '';
  $signature = $headers["x-signature"] ?? '';
  $timestamp = $headers["x-timestamp"] ?? '';
  if ($apiKey !== $system['system_api_key']) {
    return false;
  }
  if (abs(time() - intval($timestamp)) > 300) {
    return false;
  }
  $expectedSignature = hash_hmac('sha256', $timestamp, $system['system_api_secret']);
  return hash_equals($expectedSignature, $signature);
}


/**
 * generate_api_key
 *
 * @return string
 */
function generate_api_key()
{
  return bin2hex(random_bytes(24));
}


/**
 * generate_api_secret
 *
 * @return string
 */
function generate_api_secret()
{
  return bin2hex(random_bytes(32));
}


/**
 * generate_jwt_key
 *
 * @return string
 */
function generate_jwt_key()
{
  return bin2hex(random_bytes(16));
}


/**
 * redirect
 *
 * @param string $url
 * @return void
 */
function redirect($url = '')
{
  if ($url) {
    header('Location: ' . SYS_URL . $url);
  } else {
    header('Location: ' . SYS_URL);
  }
  exit;
}


/**
 * reload
 *
 * @return void
 */
function reload()
{
  header("Refresh:0");
  exit;
}


/**
 * secure_system_values
 *
 * @return array
 */
function secure_system_values()
{
  global $system;
  $allowed_values = [
    'system_title',
    'activation_type',
    'chat_heartbeat',
    'chat_seen_enabled',
    'audio_call_enabled',
    'video_call_enabled',
    'chat_typing_enabled',
    'chat_photos_enabled',
    'system_uploads',
    'voice_notes_chat_enabled',
    'voice_notes_durtaion',
    'contact_enabled',
    'location_info_enabled',
    'getting_started_location_required',
    'work_info_enabled',
    'getting_started_work_required',
    'education_info_enabled',
    'getting_started_education_required',
    'friends_enabled',
    'system_url',
    'languages',
    'social_login_enabled',
    'facebook_login_enabled',
    'google_login_enabled',
    'twitter_login_enabled',
    'linkedin_login_enabled',
    'vk_login_enabled',
    'wordpress_login_enabled',
    'registration_enabled',
    'invitation_enabled',
    'show_usernames_enabled',
    'activation_enabled',
    'genders_disabled',
    'age_restriction',
    'select_user_group_enabled',
    'newsletter_consent',
    'theme_mode_night',
    'system_theme_mode_select',
    'registration_type',
    'getting_started',
    'users_approval_enabled'
  ];
  return array_intersect_key($system, array_flip($allowed_values));
}


/**
 * secure_user_values
 *
 * @param object $user
 * @return array
 */
function secure_user_values($user)
{
  $disallowed_values = [
    'user_email_verification_code',
    'user_phone_verification_code',
    'user_two_factor_key',
    'user_two_factor_gsecret',
    'user_reset_key',
    'user_password',
    'session_token',
    'active_session_token',
  ];
  return array_diff_key($user->_data, array_flip($disallowed_values));
}


/**
 * api_test
 *
 * @return string
 */
function api_test()
{
  global $system;
  $url = $system['system_url'] . '/apis/php/ping';
  $apiKey = $system['system_api_key'];
  $apiSecret = $system['system_api_secret'];
  $timestamp = time();
  $signature = hash_hmac('sha256', $timestamp, $apiSecret);
  $headers = [
    "Content-Type: application/json",
    "x-api-key: $apiKey",
    "x-timestamp: $timestamp",
    "x-signature: $signature"
  ];
  $ch = curl_init();
  curl_setopt_array($ch, [
    CURLOPT_URL => $url,
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_HTTPHEADER => $headers,
    CURLOPT_TIMEOUT => 10,
  ]);
  $response = curl_exec($ch);
  $error = curl_error($ch);
  curl_close($ch);
  if ($response === false) {
    return json_encode([
      'success' => false,
      'message' => 'API connection failed: ' . $error
    ]);
  }
  return $response;
}



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
  }
  session_start();
  /* set session secret */
  if (!isset($_SESSION['secret'])) {
    $_SESSION['secret'] = get_hash_token();
  }
}


/**
 * init_security_headers
 *
 * @return void
 */
function init_security_headers()
{
  header('X-Frame-Options: SAMEORIGIN');
  header('X-XSS-Protection: 1; mode=block');
  header('X-Content-Type-Options: nosniff');
  header('Referrer-Policy: no-referrer');
  header('Strict-Transport-Security: max-age=31536000; includeSubDomains; preload');
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
 *
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
 * init_system
 *
 * @return array
 */
function init_system()
{
  global $db, $gettextLoader, $gettextTranslator;

  /* init system */
  $system = [];

  /* get system options */
  $get_system_options = $db->query("SELECT * FROM system_options");
  while ($system_option = $get_system_options->fetch_assoc()) {
    $system[$system_option['option_name']] = $system_option['option_value'];
  }

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
    } elseif ($system['ftp_enabled']) {
      $system['system_uploads'] = $system['ftp_endpoint'];
    } else {
      $system['system_uploads'] = $system['system_url'] . '/' . $system['uploads_directory'];
    }
  }

  /* set agora uploads */
  if ($system['live_enabled'] && $system['save_live_enabled']) {
    $system['system_agora_uploads'] = "https://s3." . $system['agora_s3_region'] . ".amazonaws.com/" . $system['agora_s3_bucket'];
  }

  /* set uploads accpeted extensions */
  $system['accpeted_video_extensions'] = set_extensions_string($system['video_extensions']);
  $system['accpeted_audio_extensions'] = set_extensions_string($system['audio_extensions']);
  $system['accpeted_file_extensions'] = set_extensions_string($system['file_extensions']);

  /* get system themes */
  $get_system_themes = $db->query("SELECT * FROM system_themes");
  while ($theme = $get_system_themes->fetch_assoc()) {
    if ($theme['default']) {
      $system['theme'] = $theme['name'];
    }
    if ($theme['enabled']) {
      $system['themes'][$theme['name']] = $theme;
    }
  }

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
      $system['theme'] = "default";
    }
  }

  /* set system theme (day|night) mode */
  $system['theme_mode_night'] = $system['system_theme_night_on'];
  if ($system['system_theme_mode_select']) {
    if (isset($_COOKIE['s_night_mode'])) {
      /* get cookei for web app */
      $system['theme_mode_night'] = ($_COOKIE['s_night_mode']) ? 1 : 0;
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

  /* set system langauge */
  $system['current_language'] = DEFAULT_LOCALE;
  $user_language = get_user_language_country()['language'];
  if (isset($_GET['lang'])) {
    /* get GET for web app */
    if (array_key_exists($_GET['lang'], $system['languages'])) {
      $system['language'] = $system['languages'][$_GET['lang']];
      if ($system['language']['code'] != DEFAULT_LOCALE) {
        $gettextTranslator = $gettextLoader->loadFile(ABSPATH . 'content/languages/locale/' . $system['language']['code'] . '/LC_MESSAGES/messages.po');
      }
      $system['current_language'] = $system['language']['code'];
      /* set language cookie */
      set_cookie('s_lang', $_GET['lang']);
    }
  } elseif (isset($_COOKIE['s_lang'])) {
    /* get cookie for web app */
    if (array_key_exists($_COOKIE['s_lang'], $system['languages'])) {
      $system['language'] = $system['languages'][$_COOKIE['s_lang']];
      if ($system['language']['code'] != DEFAULT_LOCALE) {
        $gettextTranslator = $gettextLoader->loadFile(ABSPATH . 'content/languages/locale/' . $system['language']['code'] . '/LC_MESSAGES/messages.po');
      }
      $system['current_language'] = $system['language']['code'];
    }
  } elseif (isset(_getallheaders()["x-lang"])) {
    /* get header for web app */
    if (array_key_exists(_getallheaders()["x-lang"], $system['languages'])) {
      $system['language'] = $system['languages'][_getallheaders()["x-lang"]];
      if ($system['language']['code'] != DEFAULT_LOCALE) {
        $gettextTranslator = $gettextLoader->loadFile(ABSPATH . 'content/languages/locale/' . $system['language']['code'] . '/LC_MESSAGES/messages.po');
      }
      $system['current_language'] = $system['language']['code'];
    }
  } elseif ($system['auto_language_detection'] && $user_language && array_key_exists($user_language, $system['languages'])) {
    /* get user language */
    $system['language'] = $system['languages'][$user_language];
    if ($system['language']['code'] != DEFAULT_LOCALE) {
      $gettextTranslator = $gettextLoader->loadFile(ABSPATH . 'content/languages/locale/' . $system['language']['code'] . '/LC_MESSAGES/messages.po');
    }
    $system['current_language'] = $system['language']['code'];
  } else {
    if (isset($system['default_language'])) {
      $system['language'] = $system['default_language'];
      if ($system['default_language']['code'] != DEFAULT_LOCALE) {
        $gettextTranslator = $gettextLoader->loadFile(ABSPATH . 'content/languages/locale/' . $system['default_language']['code'] . '/LC_MESSAGES/messages.po');
      }
      $system['current_language'] = $system['default_language']['code'];
    }
  }

  /* get system currency */
  $get_currency = $db->query("SELECT * FROM system_currencies WHERE system_currencies.default = '1'");
  $currency = $get_currency->fetch_assoc();
  $system['system_currency'] = $currency['code'];
  $system['system_currency_id'] = $currency['currency_id'];
  $system['system_currency_symbol'] = $currency['symbol'];
  $system['system_currency_dir'] = $currency['dir'];

  /* get system withdrawal method array */
  $system['wallet_payment_method_array'] = explode(",", $system['wallet_payment_method']);
  $system['affiliate_payment_method_array'] = explode(",", $system['affiliate_payment_method']);
  $system['points_payment_method_array'] = explode(",", $system['points_payment_method']);
  $system['market_payment_method_array'] = explode(",", $system['market_payment_method']);
  $system['funding_payment_method_array'] = explode(",", $system['funding_payment_method']);
  $system['monetization_payment_method_array'] = explode(",", $system['monetization_payment_method']);

  /* check if viewer IP banned */
  $check_banned_ip = $db->query(sprintf("SELECT COUNT(*) as count FROM blacklist WHERE node_type = 'ip' AND node_value = %s", secure(get_user_ip())));
  $system['viewer_ip_banned'] = ($check_banned_ip->fetch_assoc()['count'] > 0) ? true : false;

  /* return */
  return $system;
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
  $smarty->registerPlugin('modifier', 'is_empty', 'is_empty');
  $smarty->registerPlugin('modifier', 'array_reverse', 'array_reverse');
  $smarty->registerPlugin('modifier', 'htmlentities', 'htmlentities');
  $smarty->registerPlugin('modifier', 'get_vimeo_id', 'get_vimeo_id');
  $smarty->registerPlugin('modifier', 'get_youtube_id', 'get_youtube_id');
  $smarty->registerPlugin('modifier', 'minimize_css', 'minimize_css');
  $smarty->registerPlugin('modifier', 'html_entity_decode', 'html_entity_decode');
  $smarty->registerPlugin('modifier', 'get_extension', 'get_extension');
  $smarty->registerPlugin('modifier', 'strtoupper', 'strtoupper');
  $smarty->registerPlugin('modifier', 'htmlspecialchars', 'htmlspecialchars');
  $smarty->registerPlugin('modifier', 'count', 'count');
  $smarty->registerPlugin('modifier', 'explode', 'explode');
  $smarty->registerPlugin('modifier', 'date', 'date');
  $smarty->registerPlugin('modifier', 'number_format', 'number_format');
  $smarty->registerPlugin('modifier', 'strtolower', 'strtolower');
  $smarty->registerPlugin('modifier', 'get_payment_vat_value', 'get_payment_vat_value');
  $smarty->registerPlugin('modifier', 'get_payment_total_value', 'get_payment_total_value');
  $smarty->registerPlugin('modifier', 'get_payment_fees_value', 'get_payment_fees_value');
  $smarty->registerPlugin('modifier', 'get_payment_vat_percentage', 'get_payment_vat_percentage');
  $smarty->registerPlugin('modifier', 'implode', 'implode');
  $smarty->registerPlugin('modifier', 'trim', 'trim');
  $smarty->registerPlugin('modifier', 'filemtime', 'filemtime');
  return $smarty;
}


/**
 * get_system_session_hash
 *
 * @param string $hash
 * @return array
 */
function get_system_session_hash($hash)
{
  $hash_tokens = explode('-', $hash);
  if (count($hash_tokens) != 6) {
    return false;
  }
  $position = array_rand($hash_tokens);
  $token = $hash_tokens[$position];
  return ['token' => $token, 'position' => $position + 1];
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
}



/* ------------------------------- */
/* Security */
/* ------------------------------- */

/**
 * secure
 *
 * @param string $value
 * @param string $type
 * @param boolean $quoted
 * @return string
 */
function secure($value, $type = "", $quoted = true)
{
  global $db;
  if ($value !== 'null') {
    // [1] Sanitize
    /* Convert all applicable characters to HTML entities */
    $value = htmlentities((string)$value, ENT_QUOTES, 'utf-8');
    // [2] Safe SQL
    $value = $db->real_escape_string($value);
    switch ($type) {
      case 'int':
        $value = ($quoted) ? "'" . intval($value) . "'" : intval($value);
        break;
      case 'float':
        $value = ($quoted) ? "'" . floatval($value) . "'" : floatval($value);
        break;
      case 'datetime':
        $value = ($quoted) ? "'" . set_datetime($value) . "'" : set_datetime($value);
        break;
      case 'search':
        if ($quoted) {
          $value = (!is_empty($value)) ? "'%" . $value . "%'" : "''";
        } else {
          $value = (!is_empty($value)) ? "'%" . $value . "%'" : "''";
        }
        break;
      default:
        $value = (!is_empty($value)) ? $value : "";
        $value = ($quoted) ? "'" . $value . "'" : $value;
        break;
    }
  }
  return $value;
}


/**
 * _password_hash
 *
 * @param string $password
 * @return string
 */
function _password_hash($password)
{
  return password_hash($password, PASSWORD_DEFAULT);
}


/**
 * get_hash_key
 *
 * @param integer $length
 * @param boolean $only_numbers
 * @return string
 */
function get_hash_key($length = 8, $only_numbers = false)
{
  $chars = ($only_numbers) ? '0123456789' : 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  $count = mb_strlen($chars);
  for ($i = 0, $result = ''; $i < $length; $i++) {
    $index = rand(0, $count - 1);
    $result .= mb_substr($chars, $index, 1);
  }
  return $result;
}


/**
 * get_hash_token
 *
 * @return string
 */
function get_hash_token()
{
  return md5(get_hash_number());
}


/**
 * get_hash_number
 *
 * @return string
 */
function get_hash_number()
{
  return time() * rand(1, 99999);
}


/**
 * extarct_hash_token
 *
 * @param string $file_name
 * @return string
 */
function extarct_hash_token($file_name)
{
  $hash = '';
  preg_match('/\_.*\./', $file_name, $results);
  if ($results[0] != "") {
    $hash = $results[0];
    $hash = str_replace("_", "", $hash);
    $hash = str_replace(".", "", $hash);
  }
  return $hash;
}



/* ------------------------------- */
/* Cookies */
/* ------------------------------- */

/**
 * setcookie
 *
 * @param string $cookie_name
 * @param string $cookie_value
 * @param integer $is_expired
 * @param boolean $is_httponly
 * @return void
 */
function set_cookie($cookie_name, $cookie_value, $is_expired = false, $is_httponly = true)
{
  $secured = (get_system_protocol() == "https") ? true : false;
  $expire_time = ($is_expired) ?  0 : time() + 2592000;
  $httponly = ($is_httponly) ? true : false;
  $options = [
    'expires' => $expire_time,
    'path' => '/',
    'domain' => '',
    'secure' => $secured,
    'httponly' => $httponly,
    'samesite' => 'Lax'
  ];
  setcookie($cookie_name, $cookie_value, $options);
}


/**
 * unset_cookie
 *
 * @param string $cookie_name
 * @return void
 */
function unset_cookie($cookie_name)
{
  setcookie($cookie_name, "", -1, '/');
}



/* ------------------------------- */
/* Validation */
/* ------------------------------- */

/**
 * is_ajax
 *
 * @return void
 */
function is_ajax()
{
  if (!isset($_SERVER['HTTP_X_REQUESTED_WITH']) || ($_SERVER['HTTP_X_REQUESTED_WITH'] != 'XMLHttpRequest')) {
    redirect();
  }
}


/**
 * is_empty
 *
 * @param string $value
 * @return boolean
 */
function is_empty($value)
{
  if ($value == null || strlen(trim(preg_replace('/\xc2\xa0/', ' ', $value))) == 0) {
    return true;
  }
  return false;
}


/**
 * valid_email
 *
 * @param string $email
 * @return boolean
 */
function valid_email($email)
{
  if (filter_var($email, FILTER_VALIDATE_EMAIL) !== false) {
    return true;
  } else {
    return false;
  }
}


/**
 * valid_url
 *
 * @param string $url
 * @return boolean
 */
function valid_url($url)
{
  if (filter_var($url, FILTER_VALIDATE_URL) !== false) {
    return true;
  } else {
    return false;
  }
}


/**
 * valid_username
 *
 * @param string $username
 * @return boolean
 */
function valid_username($username)
{
  if (strlen($username) >= 3 && preg_match('/^[a-zA-Z0-9]+([_|.]?[a-zA-Z0-9])*$/', $username)) {
    return true;
  } else {
    return false;
  }
}


/**
 * valid_name
 *
 * @param string $name
 * @return boolean
 */
function valid_name($name)
{
  global $system;
  if ((!$system['special_characters_enabled'] && !ctype_graph($name)) || (!$system['special_characters_enabled'] && preg_match('/[[:punct:]]/i', $name) != false) || valid_url($name)) {
    return false;
  }
  return true;
}


/**
 * valid_extension
 *
 * @param string $extension
 * @param string $allowed_extensions
 * @return boolean
 */
function valid_extension($extension, $allowed_extensions)
{
  $extensions = explode(',', $allowed_extensions);
  foreach ($extensions as $key => $value) {
    $extensions[$key] = strtolower(trim($value));
  }
  if (is_array($extensions) && in_array($extension, $extensions)) {
    return true;
  }
  return false;
}


/**
 * set_extensions_string
 *
 * @param string $extensions
 * @return string
 */
function set_extensions_string($extensions)
{
  $extensions_string = "";
  $extensions = explode(',', $extensions);
  foreach ($extensions as $key => $value) {
    $extensions_string .= "." . strtolower(trim($value)) . ",";
  }
  $extensions_string = substr($extensions_string, 0, -1);
  return $extensions_string;
}



/* ------------------------------- */
/* Date */
/* ------------------------------- */

/**
 * set_datetime
 *
 * @param string $date
 * @return string
 */
function set_datetime($date)
{
  global $system;
  $date = str_replace(['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'], range(0, 9), $date); /* check and replace arabic numbers if any */
  $datetime = date("Y-m-d H:i:s", strtotime($date));
  return $datetime;
}


/**
 * get_datetime
 *
 * @param string $date
 * @return string
 */
function get_datetime($date)
{
  global $system;
  return date($system['system_datetime_format'], strtotime($date));
}



/* ------------------------------- */
/* JSON */
/* ------------------------------- */

/**
 * return_json
 *
 * @param array $response
 * @return json
 */
function return_json($response = [])
{
  header('Content-Type: application/json');
  exit(json_encode($response));
}


/**
 * return_json_async
 *
 * @param array $response
 * @return void
 */
function return_json_async($response = [])
{
  if (is_callable('fastcgi_finish_request')) {
    ob_end_clean();
    header("Content-Encoding: none");
    header("Connection: close");
    ignore_user_abort();
    ob_start();
    header('Content-Type: application/json');
    echo json_encode($response);
    $size = ob_get_length();
    header("Content-Length: $size");
    ob_end_flush();
    flush();
    session_write_close();
    fastcgi_finish_request();
  }
}



/* ------------------------------- */
/* Error */
/* ------------------------------- */

/**
 * _error
 *
 * @return void
 */
function _error()
{
  $args = func_get_args();
  if (count($args) > 1 && !in_array($args[0], ['BANNED_USER', 'PERMISSION'])) {
    $title = $args[0];
    $message = $args[1];
  } else {
    switch ($args[0]) {
      case 'DB_ERROR':
        $title = "Database Error";
        $message = "<div class='text-start'><h1>" . "Error establishing a database connection" . "</h1>
                            <p>" . "This either means that the username and password information in your config.php file is incorrect or we can't contact the database server at localhost. This could mean your host's database server is down." . "</p>
                            <ul>
                                <li>" . "Are you sure you have the correct username and password?" . "</li>
                                <li>" . "Are you sure that you have typed the correct hostname?" . "</li>
                                <li>" . "Are you sure that the database server is running?" . "</li>
                            </ul>
                            <p>" . "If you're unsure what these terms mean you should probably contact your host. If you still need help you can always visit the" . " <a href='https://Sorokin Dmitry Olegovich.com/support'>" . "Delus Support" . ".</a></p>
                            </div>";
        break;

      case 'SQL_ERROR':
        $title = __("Database Error");
        $message = __("An error occurred while writing to database. Please try again later");
        if (DEBUGGING) {
          $backtrace = debug_backtrace();
          $line = $backtrace[0]['line'];
          $file = $backtrace[0]['file'];
          $message .= "<br><br><small>This error function was called from line $line in file $file</small>";
        }
        break;

      case 'SQL_ERROR_THROWEN':
        $message = __("An error occurred while writing to database. Please try again later");
        if (DEBUGGING) {
          $backtrace = debug_backtrace();
          $line = $backtrace[0]['line'];
          $file = $backtrace[0]['file'];
          $message .= "<br><br><small>This error function was called from line $line in file $file</small>";
        }
        throw new SQLException($message);
        break;

      case 'PERMISSION':
        global $smarty;
        $title = __("Permission Needed");
        $message = ($args[1]) ? $args[1] : __("You do not have the permission to view this content");
        if (isset($smarty)) {
          $smarty->assign('message', $message);
          page_header($title);
          page_footer('permission');
          exit;
        }
        break;

      case 'CHAT_PERMISSION':
        global $smarty;
        $title = __("Permission Needed");
        $message = ($args[1]) ? $args[1] : __("Your privacy settings do not allow you to chat with this user, Go to your privacy settings to change this");
        if (isset($smarty)) {
          $smarty->assign('message', $message);
          page_header($title);
          page_footer('permission');
          exit;
        }
        break;

      case 'BANNED':
        global $smarty;
        $title = __("Banned");
        $message = __("You do not have the permission to view this content");
        if (isset($smarty)) {
          $smarty->assign('message', $message);
          page_header($title);
          page_footer('banned');
          exit;
        }
        break;

      case 'BANNED_USER':
        global $smarty;
        $title = __("Banned Account");
        $message = $args[1];
        if (isset($smarty)) {
          $smarty->assign('message', $message);
          page_header($title);
          page_footer('banned');
          exit;
        }
        break;

      case 'ACTIVATION':
        global $smarty;
        if (isset($smarty)) {
          page_header(__("Activation Required"));
          page_footer('activation');
          exit;
        }
        break;

      case 'APPROVAL':
        global $smarty;
        if (isset($smarty)) {
          page_header(__("Admin Approval Required"));
          page_footer('approval');
          exit;
        }
        break;

      case '400':
        header('HTTP/1.0 400 Bad Request');
        if (DEBUGGING) {
          $backtrace = debug_backtrace();
          $line = $backtrace[0]['line'];
          $file = $backtrace[0]['file'];
          exit("This error function was called from line $line in file $file");
        }
        exit;
        break;

      case '401':
        header('HTTP/1.0 401 Unauthorized');
        if (DEBUGGING) {
          $backtrace = debug_backtrace();
          $line = $backtrace[0]['line'];
          $file = $backtrace[0]['file'];
          exit("This error function was called from line $line in file $file");
        }
        exit;
        break;

      case '403':
        header('HTTP/1.0 403 Access Denied');
        if (DEBUGGING) {
          $backtrace = debug_backtrace();
          $line = $backtrace[0]['line'];
          $file = $backtrace[0]['file'];
          exit("This error function was called from line $line in file $file");
        }
        exit;
        break;

      case '404':
        global $smarty;
        header('HTTP/1.0 404 Not Found');
        $title = __("404 Not Found");
        $message = __("Sorry but the page you are looking for does not exist, have been removed. name changed or is temporarily unavailable");
        if (DEBUGGING) {
          $backtrace = debug_backtrace();
          $line = $backtrace[0]['line'];
          $file = $backtrace[0]['file'];
          $message .= "<br><br><small>This error function was called from line $line in file $file</small>";
        }
        if (isset($smarty)) {
          $smarty->assign('message', $message);
          page_header($title);
          page_footer('404');
          exit;
        }
        break;

      default:
        $title = __("Error");
        $message = __("There is some thing went wrong");
        if (DEBUGGING) {
          $backtrace = debug_backtrace();
          $line = $backtrace[0]['line'];
          $file = $backtrace[0]['file'];
          $message .= "<br><br>" . "<small>This error function was called from line $line in file $file</small>";
        }
        break;
    }
  }
  echo '<!DOCTYPE html>
            <html>
            <head>
                <meta charset="utf-8">
                <title>' . $title . '</title>
                <style type="text/css">
                    html {
                        background: #f1f1f1;
                    }
                    body {
                        color: #555;
                        font-family: "Open Sans", Arial,sans-serif;
                        margin: 0;
                        padding: 0;
                    }
                    .error-title {
                        background: #ce3426;
                        color: #fff;
                        text-align: center;
                        font-size: 34px;
                        font-weight: 100;
                        line-height: 50px;
                        padding: 60px 0;
                    }
                    .error-message {
                        margin: 1em auto;
                        padding: 1em 2em;
                        max-width: 600px;
                        font-size: 1em;
                        line-height: 1.8em;
                        text-align: center;
                    }
                    .error-message .code,
                    .error-message p {
                        margin-top: 0;
                        margin-bottom: 1.3em;
                    }
                    .error-message .code {
                        font-family: Consolas, Monaco, monospace;
                        background: rgba(0, 0, 0, 0.7);
                        padding: 10px;
                        color: rgba(255, 255, 255, 0.7);
                        word-break: break-all;
                        border-radius: 2px;
                    }
                    h1 {
                        font-size: 1.2em;
                    }

                    ul li {
                        margin-bottom: 1em;
                        font-size: 0.9em;
                    }
                    a {
                        color: #ce3426;
                        text-decoration: none;
                    }
                    a:hover {
                        text-decoration: underline;
                    }
                    .button {
                        background: #f7f7f7;
                        border: 1px solid #cccccc;
                        color: #555;
                        display: inline-block;
                        text-decoration: none;
                        margin: 0;
                        padding: 5px 10px;
                        cursor: pointer;
                        -webkit-border-radius: 3px;
                        -webkit-appearance: none;
                        border-radius: 3px;
                        white-space: nowrap;
                        -webkit-box-sizing: border-box;
                        -moz-box-sizing:    border-box;
                        box-sizing:         border-box;

                        -webkit-box-shadow: inset 0 1px 0 #fff, 0 1px 0 rgba(0,0,0,.08);
                        box-shadow: inset 0 1px 0 #fff, 0 1px 0 rgba(0,0,0,.08);
                        vertical-align: top;
                    }

                    .button.button-large {
                        height: 29px;
                        line-height: 28px;
                        padding: 0 12px;
                    }

                    .button:hover,
                    .button:focus {
                        background: #fafafa;
                        border-color: #999;
                        color: #222;
                        text-decoration: none;
                    }

                    .button:focus  {
                        -webkit-box-shadow: 1px 1px 1px rgba(0,0,0,.2);
                        box-shadow: 1px 1px 1px rgba(0,0,0,.2);
                    }

                    .button:active {
                        background: #eee;
                        border-color: #999;
                        color: #333;
                        -webkit-box-shadow: inset 0 2px 5px -3px rgba( 0, 0, 0, 0.5 );
                        box-shadow: inset 0 2px 5px -3px rgba( 0, 0, 0, 0.5 );
                    }
                    .text-start {
                        text-align: left;
                    }
                </style>
            </head>
            <body>
                <div class="error-title">' . $title . '</div>
                <div class="error-message">' . $message . '</div>
            </body>
            </html>';
  exit;
}



/* ------------------------------- */
/* Email */
/* ------------------------------- */

/**
 * _email
 *
 * @param string $email
 * @param string $subject
 * @param string $body_html
 * @param string $body_plain
 * @param boolean $is_html
 * @param boolean $only_smtp
 * @return boolean
 */
function _email($email, $subject, $body_html, $body_plain, $is_html = true, $only_smtp = false)
{
  global $system;
  /* set header */
  $header  = "MIME-Version: 1.0\r\n";
  $header .= "Mailer: " . html_entity_decode(__($system['system_title']), ENT_QUOTES) . "\r\n";
  if ($system['system_email']) {
    $header = "From: " . $system['system_email'] . "\r\n";
    $header .= "Reply-To: " . $system['system_email'] . "\r\n";
  }
  if ($is_html) {
    $header .= "Content-Type: text/html; charset=\"utf-8\"\r\n";
  } else {
    $header .= "Content-Type: text/plain; charset=\"utf-8\"\r\n";
  }
  /* send email */
  if ($system['email_smtp_enabled']) {
    /* SMTP */
    $mail = new PHPMailer\PHPMailer\PHPMailer;
    $mail->CharSet = "UTF-8";
    $mail->isSMTP();
    $mail->XMailer = $system['system_title'];
    $mail->Host = $system['email_smtp_server'];
    $mail->SMTPAuth = ($system['email_smtp_authentication']) ? true : false;
    $mail->Username = $system['email_smtp_username'];
    $mail->Password = html_entity_decode($system['email_smtp_password']);
    $mail->SMTPSecure = ($system['email_smtp_ssl']) ? 'ssl' : 'tls';
    $mail->Port = $system['email_smtp_port'];
    $setfrom = (is_empty($system['email_smtp_setfrom'])) ? $system['email_smtp_username'] : $system['email_smtp_setfrom'];
    $mail->setFrom($setfrom, html_entity_decode(__($system['system_title']), ENT_QUOTES));
    $mail->addAddress($email);
    $mail->Subject = $subject;
    if ($is_html) {
      $mail->isHTML(true);
      $mail->Body = $body_html;
      $mail->AltBody = $body_plain;
    } else {
      $mail->Body = $body_plain;
    }
    if (!$mail->send()) {
      if ($only_smtp) {
        return false;
      }
      /* send using mail() */
      if (!mail($email, $subject, $body_html, $header)) {
        return false;
      }
    }
  } else {
    if ($only_smtp) {
      return false;
    }
    /* send using mail() */
    if (!mail($email, $subject, $body_html, $header)) {
      return false;
    }
  }
  return true;
}


/**
 * email_smtp_test
 *
 * @return void
 */
function email_smtp_test()
{
  global $system;
  /* prepare test email */
  $subject = __("Test SMTP Connection on") . " " . html_entity_decode(__($system['system_title']), ENT_QUOTES);
  $body = get_email_template("test_email", $subject);
  /* send email */
  if (!_email($system['system_email'], $subject, $body['html'], $body['plain'], true, true)) {
    throw new Exception(__("Test email could not be sent. Please check your settings"));
  }
}


/**
 * get_email_template
 *
 * @param string $template_name
 * @param string $template_subject
 * @param array $template_variables
 * @return array
 */
function get_email_template($template_name, $template_subject, $template_variables = [])
{
  global $system, $smarty;
  $smarty->assign('system', $system);
  $smarty->assign("template_subject", $template_subject);
  if ($template_variables) {
    foreach ($template_variables as $key => $value) {
      $smarty->assign($key, $value);
    }
  }
  $body['html'] = $smarty->fetch("emails/" . $template_name . ".html");
  $body['plain'] = $smarty->fetch("emails/" . $template_name . ".txt");
  return $body;
}



/* ------------------------------- */
/* SMS */
/* ------------------------------- */

/**
 * sms_send
 *
 * @param string $phone
 * @param string $message
 * @return boolean
 */
function sms_send($phone, $message)
{
  global $system, $db, $date;
  /* check if this phone sent more than 3 SMS within 1 hour */
  $check_log = $db->query(sprintf("SELECT * FROM users_sms WHERE phone = %s AND insert_date > DATE_SUB(NOW(), INTERVAL 1 HOUR)", secure($phone)));
  if ($check_log->num_rows > $system['sms_limit']) {
    throw new Exception(__("You have reached the maximum number of SMS allowed per hour"));
    return false;
  }
  switch ($system['sms_provider']) {
    case 'twilio':
      $client = new Twilio\Rest\Client($system['twilio_sid'], $system['twilio_token']);
      $message = $client->account->messages->create(
        $phone,
        [
          'from' => $system['twilio_phone'],
          'body' => $message
        ]
      );
      if (!$message->sid) {
        return false;
      }
      break;

    case 'bulksms':
      $username = $system['bulksms_username'];
      $password = $system['bulksms_password'];
      $headers = [
        'Content-Type:application/json',
        'Authorization:Basic ' . base64_encode("$username:$password")
      ];
      $request_body = [
        [
          'to' => $phone,
          'body' => $message
        ]
      ];
      $ch = curl_init();
      curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
      curl_setopt($ch, CURLOPT_URL, "https://api.bulksms.com/v1/messages?auto-unicode=true&longMessageMaxParts=30");
      curl_setopt($ch, CURLOPT_POST, 1);
      curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
      curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($request_body));
      curl_setopt($ch, CURLOPT_TIMEOUT, 20);
      curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 10);
      $response = curl_exec($ch);
      $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
      if (curl_errno($ch)) {
        return false;
      }
      curl_close($ch);
      if ($httpCode != 201) {
        return false;
      }
      break;

    case 'infobip':
      $headers = [
        "Content-Type:application/json",
        "Accept:application/json"
      ];
      $request_body = [
        "from" => $system['system_title'],
        "to" => $phone,
        "text" => $message
      ];
      $userpwd = $system['infobip_username'] . ':' . $system['infobip_password'];
      $ch = curl_init();
      curl_setopt($ch, CURLOPT_URL, "https://api.infobip.com/sms/1/text/single");
      curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
      curl_setopt($ch, CURLOPT_HTTPAUTH, CURLAUTH_BASIC);
      curl_setopt($ch, CURLOPT_USERPWD, html_entity_decode($userpwd));
      curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 2);
      curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
      curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
      curl_setopt($ch, CURLOPT_MAXREDIRS, 2);
      curl_setopt($ch, CURLOPT_POST, 1);
      curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($request_body));
      curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0);
      $response = curl_exec($ch);
      $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
      if (curl_errno($ch)) {
        return false;
      }
      curl_close($ch);
      if (!($httpCode >= 200 && $httpCode < 300)) {
        return false;
      }
      break;

    case 'msg91':
      $request_body = [
        'template_id' => $system['msg91_template_id'],
        'short_url' => '0',
        'recipients' => [
          [
            'mobiles' => $phone,
            'VAR1' => $message
          ]
        ]
      ];
      $ch = curl_init();
      curl_setopt_array($ch, [
        CURLOPT_URL => "https://control.msg91.com/api/v5/flow",
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_ENCODING => "",
        CURLOPT_MAXREDIRS => 10,
        CURLOPT_TIMEOUT => 30,
        CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
        CURLOPT_CUSTOMREQUEST => "POST",
        CURLOPT_POSTFIELDS => json_encode($request_body),
        CURLOPT_HTTPHEADER => [
          "accept: application/json",
          "authkey: " . $system['msg91_authkey'],
          "content-type: application/json"
        ]
      ]);
      $response = curl_exec($ch);
      $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
      if (curl_errno($ch)) {
        return false;
      }
      curl_close($ch);
      if (!($httpCode >= 200 && $httpCode < 300)) {
        return false;
      }
      break;
  }
  /* insert this to SMS log */
  $db->query(sprintf("INSERT INTO users_sms (phone, insert_date) VALUES (%s, %s)", secure($phone), secure($date)));
  return true;
}


/**
 * sms_test
 *
 * @return void
 */
function sms_test()
{
  global $system;
  if (is_empty($system['system_phone'])) {
    throw new Exception(__("You need to enter Test Phone Number"));
  }
  switch ($system['sms_provider']) {
    case 'twilio':
      $client = new Twilio\Rest\Client($system['twilio_sid'], $system['twilio_token']);
      $message = $client->account->messages->create(
        $system['system_phone'],
        [
          'from' => $system['twilio_phone'],
          'body' => __("Test SMS from") . " " . __($system['system_title'])
        ]
      );
      if (!$message->sid) {
        throw new Exception(__("Test SMS could not be sent. Please check your settings"));
      }
      break;

    case 'bulksms':
      $username = $system['bulksms_username'];
      $password = $system['bulksms_password'];
      $headers = [
        'Content-Type:application/json',
        'Authorization:Basic ' . base64_encode("$username:$password")
      ];
      $request_body = [
        [
          'to' => $system['system_phone'],
          'body' => __("Test SMS from") . " " . __($system['system_title'])
        ]
      ];
      $ch = curl_init();
      curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
      curl_setopt($ch, CURLOPT_URL, "https://api.bulksms.com/v1/messages?auto-unicode=true&longMessageMaxParts=30");
      curl_setopt($ch, CURLOPT_POST, 1);
      curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
      curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($request_body));
      curl_setopt($ch, CURLOPT_TIMEOUT, 20);
      curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 10);
      $response = curl_exec($ch);
      $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
      if (curl_errno($ch)) {
        throw new Exception(__("Test SMS could not be sent. Please check your settings"));
      }
      curl_close($ch);
      if ($httpCode != 201) {
        throw new Exception(__("Test SMS could not be sent. Please check your settings"));
      }
      break;

    case 'infobip':
      $headers = [
        "Content-Type:application/json",
        "Accept:application/json"
      ];
      $request_body = [
        "from" => $system['system_title'],
        "to" => $system['system_phone'],
        "text" => __("Test SMS from") . " " . __($system['system_title'])
      ];
      $userpwd = $system['infobip_username'] . ':' . $system['infobip_password'];
      $ch = curl_init();
      curl_setopt($ch, CURLOPT_URL, "https://api.infobip.com/sms/1/text/single");
      curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
      curl_setopt($ch, CURLOPT_HTTPAUTH, CURLAUTH_BASIC);
      curl_setopt($ch, CURLOPT_USERPWD, html_entity_decode($userpwd));
      curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 2);
      curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
      curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
      curl_setopt($ch, CURLOPT_MAXREDIRS, 2);
      curl_setopt($ch, CURLOPT_POST, 1);
      curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($request_body));
      curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0);
      $response = curl_exec($ch);
      $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
      if (curl_errno($ch)) {
        throw new Exception(__("Test SMS could not be sent. Please check your settings"));
      }
      curl_close($ch);
      if (!($httpCode >= 200 && $httpCode < 300)) {
        throw new Exception(__("Test SMS could not be sent. Please check your settings"));
      }
      break;

    case 'msg91':
      $request_body = [
        'template_id' => $system['msg91_template_id'],
        'short_url' => '0',
        'recipients' => [
          [
            'mobiles' => $system['system_phone'],
            'VAR1' => __("Test SMS from") . " " . __($system['system_title'])
          ]
        ]
      ];
      $ch = curl_init();
      curl_setopt_array($ch, [
        CURLOPT_URL => "https://control.msg91.com/api/v5/flow",
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_ENCODING => "",
        CURLOPT_MAXREDIRS => 10,
        CURLOPT_TIMEOUT => 30,
        CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
        CURLOPT_CUSTOMREQUEST => "POST",
        CURLOPT_POSTFIELDS => json_encode($request_body),
        CURLOPT_HTTPHEADER => [
          "accept: application/json",
          "authkey: " . $system['msg91_authkey'],
          "content-type: application/json"
        ]
      ]);
      $response = curl_exec($ch);
      $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
      if (curl_errno($ch)) {
        throw new Exception(__("Test SMS could not be sent. Please check your settings"));
      }
      curl_close($ch);
      if (!($httpCode >= 200 && $httpCode < 300)) {
        throw new Exception(__("Test SMS could not be sent. Please check your settings"));
      }
      break;
  }
}



/* ------------------------------- */
/* OneSignal Notifications */
/* ------------------------------- */

/**
 * onesignal_notification
 *
 * @param string $send_to
 * @param string $notification
 * @param string $type
 * @return boolean
 */
function onesignal_notification($send_to, $notification, $type = 'web')
{
  global $system;
  switch ($type) {
    case 'web':
    case 'web-view':
      if (!$system['onesignal_notification_enabled']) {
        return false;
      }
      $onesignal_app_id = $system['onesignal_app_id'];
      $onesignal_api_key = $system['onesignal_api_key'];
      if ($type == 'web-view') {
        $notification['url'] = str_replace('https://', 'Delus://', $notification['url']);
      }
      break;

    case 'messenger':
      if (!$system['onesignal_messenger_notification_enabled']) {
        return false;
      }
      $onesignal_app_id = $system['onesignal_messenger_app_id'];
      $onesignal_api_key = $system['onesignal_messenger_api_key'];
      $notification['url'] = str_replace('https://', 'Delus_messenger://', $notification['url']);
      break;

    case 'timeline':
      if (!$system['onesignal_timeline_notification_enabled']) {
        return false;
      }
      $onesignal_app_id = $system['onesignal_timeline_app_id'];
      $onesignal_api_key = $system['onesignal_timeline_api_key'];
      $notification['url'] = str_replace('https://', 'Delus_timeline://', $notification['url']);
      break;
  }
  $request_body = [
    'app_id' => $onesignal_app_id,
    'include_player_ids' => [$send_to],
    'url' => $notification['url'],
    'contents' => [
      'en' => $notification['full_message']
    ],
    'headings' => [
      'en' => ($notification['headings']) ? $notification['headings'] : $system['system_title']
    ],
    'ios_badgeType' => 'Increase',
    'ios_badgeCount' => 1,
  ];
  $ch = curl_init();
  curl_setopt($ch, CURLOPT_URL, "https://onesignal.com/api/v1/notifications");
  curl_setopt($ch, CURLOPT_HTTPHEADER, [
    'Content-Type: application/json; charset=utf-8',
    'Authorization: Basic ' . $onesignal_api_key
  ]);
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
  curl_setopt($ch, CURLOPT_HEADER, 0);
  curl_setopt($ch, CURLOPT_POST, 1);
  curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($request_body));
  curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0);
  $response = curl_exec($ch);
  $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
  if (curl_errno($ch)) {
    return false;
  }
  curl_close($ch);
  if (!($httpCode >= 200 && $httpCode < 300)) {
    return false;
  }
  return true;
}



/* ------------------------------- */
/* Google Vision */
/* ------------------------------- */

/**
 * google_vision_test
 *
 * @return void
 */
function google_vision_test()
{
  global $system;
  $image_source = $system['system_url'] . '/content/themes/' . $system['theme'] . '/images/og-image.jpg';
  try {
    $content = '{
        "requests":[
            {
                "image":{
                    "content": "' . base64_encode(file_get_contents($image_source)) . '",
                },
                "features":[
                    {
                        "type":"SAFE_SEARCH_DETECTION",
                        "maxResults":1
                    },
                    {
                        "type":"WEB_DETECTION",
                        "maxResults":2
                    }
                ]
            }
        ]
    }';
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, 'https://vision.googleapis.com/v1/images:annotate?key=' . $system['adult_images_api_key']);
    curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type: application/json', 'Content-Length: ' . strlen($content)]);
    curl_setopt($ch, CURLOPT_CUSTOMREQUEST, 'POST');
    curl_setopt($ch, CURLOPT_POSTFIELDS, $content);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
    $response  = curl_exec($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    if (curl_errno($ch)) {
      throw new Exception("Error Processing Request");
    }
    curl_close($ch);
    $responseJson = json_decode($response);
    if ($responseJson->error) {
      throw new Exception($responseJson->error->message);
    }
    if ($responseJson->responses[0]->error) {
      throw new Exception($responseJson->responses[0]->error->message);
    }
    if (!$responseJson->responses[0]->safeSearchAnnotation) {
      throw new Exception(__("Connection Failed, Please check your settings"));
    }
  } catch (Exception $e) {
    if (DEBUGGING) {
      throw new Exception($e->getMessage());
    } else {
      throw new Exception(__("Connection Failed, Please check your settings"));
    }
  }
}


/**
 * google_vision_check
 *
 * @param string $image_source
 * @return boolean
 */
function google_vision_check($image_source)
{
  global $system;
  try {
    $content = '{
        "requests":[
            {
                "image":{
                    "content": "' . base64_encode(file_get_contents($image_source)) . '",
                },
                "features":[
                    {
                        "type":"SAFE_SEARCH_DETECTION",
                        "maxResults":1
                    },
                    {
                        "type":"WEB_DETECTION",
                        "maxResults":2
                    }
                ]
            }
        ]
    }';
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, 'https://vision.googleapis.com/v1/images:annotate?key=' . $system['adult_images_api_key']);
    curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type: application/json', 'Content-Length: ' . strlen($content)]);
    curl_setopt($ch, CURLOPT_CUSTOMREQUEST, 'POST');
    curl_setopt($ch, CURLOPT_POSTFIELDS, $content);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
    $response  = curl_exec($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    if (curl_errno($ch)) {
      return false;
    }
    curl_close($ch);
    $responseJson = json_decode($response);
    if ($responseJson->error) {
      return false;
    }
    if ($responseJson->responses[0]->error) {
      return false;
    }
    if ($responseJson->responses[0]->safeSearchAnnotation->adult == 'LIKELY' || $responseJson->responses[0]->safeSearchAnnotation->adult == 'VERY_LIKELY') {
      return true;
    } else {
      return false;
    }
  } catch (Exception $e) {
    return false;
  }
}



/* ------------------------------- */
/* Cloudflare */
/* ------------------------------- */

/**
 * cf_turnstile_response
 *
 * @param string $cf_turnstile_response
 * @return boolean
 */
function check_cf_turnstile($cf_turnstile_response)
{
  global $system;
  $user_ip = isset($_SERVER["HTTP_CF_CONNECTING_IP"]) ? $_SERVER["HTTP_CF_CONNECTING_IP"] : $_SERVER['REMOTE_ADDR'];
  $ch = curl_init();
  curl_setopt($ch, CURLOPT_URL, "https://challenges.cloudflare.com/turnstile/v0/siteverify");
  curl_setopt($ch, CURLOPT_POST, true);
  curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query([
    'secret' => $system['turnstile_secret_key'],
    'response' => $cf_turnstile_response,
    'remoteip' => $user_ip
  ]));
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
  curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
  curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);
  curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
  curl_setopt($ch, CURLOPT_TIMEOUT, 10);
  curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 10);
  $response = curl_exec($ch);
  $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
  if (curl_errno($ch)) {
    return false;
  }
  curl_close($ch);
  $response = json_decode($response, true);
  if ($httpCode != 200 || !$response['success']) {
    return false;
  }
  if (isset($response['error-codes'])) {
    foreach ($response['error-codes'] as $error) {
      if ($error == 'invalid-input-response') {
        return false;
      }
    }
  }
  return true;
}



/* ------------------------------- */
/* Upload */
/* ------------------------------- */

/**
 * upload_file
 *
 * @param boolean $from_web
 * @return string|array
 */
function upload_file($from_web = false)
{
  global $system, $db, $user, $date;
  // set execution time (unlimited)
  set_time_limit(0);

  // valid inputs
  /* check if there is upload error */
  if (!isset($_FILES["file"]) || $_FILES["file"]["error"] != UPLOAD_ERR_OK) {
    throw new Exception(__("Something wrong with upload! Is 'upload_max_filesize' set correctly?"));
  }
  /* check file name not empty */
  if (!isset($_POST['name'])) {
    throw new ValidationException(__("Invalid file name"));
  }
  $file_name = $_POST['name'];
  /* check if guid not empty */
  if (!isset($_POST['guid'])) {
    throw new ValidationException(__("Invalid file guid"));
  }
  $file_guid = $_POST['guid'];

  // get chunked upload data
  $chunkIndex = isset($_POST['chunkIndex']) ? (int)$_POST['chunkIndex'] : 0;
  $totalChunks = isset($_POST['totalChunks']) ? (int)$_POST['totalChunks'] : 1;

  // check secret
  if ($from_web && $_SESSION['secret'] != $_POST['secret']) {
    /* check server post_max_size */
    if (isset($_SERVER['CONTENT_LENGTH'])) {
      $post_max_size = ini_get('post_max_size');
      $post_max_size = trim($post_max_size);
      $last = strtolower($post_max_size[strlen($post_max_size) - 1]);
      switch ($last) {
        case 'g':
          $post_max_size *= 1024;
        case 'm':
          $post_max_size *= 1024;
        case 'k':
          $post_max_size *= 1024;
      }
      if ($_SERVER['CONTENT_LENGTH'] > $post_max_size) {
        throw new ValidationException(__("The file size is so big") . ", " . __("The 'post_max_size' size is:") . " " . ($post_max_size / 1024 / 1024) . __("MB"));
      }
    }
    /* check server upload_max_filesize */
    if (isset($_SERVER['CONTENT_LENGTH'])) {
      $upload_max_filesize = ini_get('upload_max_filesize');
      $upload_max_filesize = trim($upload_max_filesize);
      $last = strtolower($upload_max_filesize[strlen($upload_max_filesize) - 1]);
      switch ($last) {
        case 'g':
          $upload_max_filesize *= 1024;
        case 'm':
          $upload_max_filesize *= 1024;
        case 'k':
          $upload_max_filesize *= 1024;
      }
      if ($_SERVER['CONTENT_LENGTH'] > $upload_max_filesize) {
        throw new ValidationException(__("The file size is so big") . ", " . __("The 'upload_max_filesize' size is:") . " " . ($upload_max_filesize / 1024 / 1024) . __("MB"));
      }
    }
    /* check server memory_limit */
    if (isset($_SERVER['CONTENT_LENGTH'])) {
      $memory_limit = ini_get('memory_limit');
      $memory_limit = trim($memory_limit);
      $last = strtolower($memory_limit[strlen($memory_limit) - 1]);
      switch ($last) {
        case 'g':
          $memory_limit *= 1024;
        case 'm':
          $memory_limit *= 1024;
        case 'k':
          $memory_limit *= 1024;
      }
      if ($_SERVER['CONTENT_LENGTH'] > $memory_limit) {
        throw new ValidationException(__("The file size is so big") . ", " . __("The 'memory_limit is:") . " " . ($memory_limit / 1024 / 1024) . __("MB"));
      }
    }
    /* none of the above */
    throw new BadRequestException(__("Invalid secret"));
  }

  // check if user exceeds the max upload limit per day
  if (!($user->_is_admin || $user->_is_moderator) && $system['max_daily_upload_size'] && $system['max_daily_upload_size'] != "0") {
    $max_daily_upload_size = $system['max_daily_upload_size'] * 1024;
    /* get the user total upload size from users_uploads */
    $get_total_upload_size = $db->query(sprintf("SELECT SUM(file_size) AS total_upload_size FROM users_uploads WHERE user_id = %s AND DATE(insert_date) = CURDATE();", secure($user->_data['user_id'])));
    $user_upload_size = $get_total_upload_size->fetch_assoc()['total_upload_size'];
    if ($user_upload_size >= $max_daily_upload_size) {
      throw new ValidationException(__("You have reached the maximum upload limit which is") . " " . round($system['max_daily_upload_size'] / 1024, 2) . "MB" . ", " . __("And you uploaded") . " " . round($user_upload_size / 1024 / 1024, 2) . "MB");
    }
  }

  // check type & handle & multiple
  if (!isset($_POST["type"])) {
    throw new BadRequestException(__("Invalid type"));
  }
  if (!isset($_POST["handle"])) {
    throw new BadRequestException(__("Invalid handle"));
  }
  if (!isset($_POST["multiple"])) {
    throw new BadRequestException(__("Invalid multiple"));
  }

  // prepare temporary directory for chunked uploads
  $temp_directory = ABSPATH . $system['uploads_directory'] . '/temp/';
  if (!file_exists($temp_directory)) {
    @mkdir($temp_directory, 0777, true);
  }

  // check if multiple files are uploaded
  if ($_POST["multiple"] == "true") {
    $finished_files = isset($_POST['finished_files']) ? json_decode($_POST['finished_files'], true) : [];
  }

  switch ($_POST["type"]) {
    case 'photos':
      // check photos upload permission
      if (!$user->_is_admin && $_POST['handle'] == 'publisher' && !$system['photos_enabled']) {
        throw new AuthorizationException(__("Uploading photos feature has been disabled by the admin"));
      }
      if (!$user->_is_admin && $_POST['handle'] == 'comment' && !$system['comments_photos_enabled']) {
        throw new AuthorizationException(__("Uploading photos feature has been disabled by the admin"));
      }
      if (!$user->_is_admin && $_POST['handle'] == 'chat' && !$system['chat_photos_enabled']) {
        throw new AuthorizationException(__("Uploading photos feature has been disabled by the admin"));
      }
      if (!$user->_is_admin && $_POST['handle'] == 'tinymce' && !$system['tinymce_photos_enabled']) {
        throw new AuthorizationException(__("Uploading photos feature has been disabled by the admin"));
      }

      // get allowed file size
      if ($_POST['handle'] == 'picture-user' || $_POST['handle'] == 'picture-page' || $_POST['handle'] == 'picture-group') {
        $max_allowed_size = $system['max_avatar_size'] * 1024;
      } elseif ($_POST['handle'] == 'cover-user' || $_POST['handle'] == 'cover-page' || $_POST['handle'] == 'cover-group') {
        $max_allowed_size = $system['max_cover_size'] * 1024;
      } else {
        $max_allowed_size = $system['max_photo_size'] * 1024;
      }

      // prepare uploads directory
      $folder = 'photos';
      $directory = $folder . '/' . date('Y') . '/' . date('m') . '/';
      if (!file_exists(ABSPATH . $system['uploads_directory'] . '/' . $directory)) {
        @mkdir(ABSPATH . $system['uploads_directory'] . '/' . $directory, 0777, true);
      }

      // check file extesnion
      $extension = get_extension($file_name);

      // save each chunk to a temporary file
      $temp_file = $temp_directory . $file_guid . '_' . $file_name .  ".part-" . $chunkIndex;
      if (!@move_uploaded_file($_FILES['file']['tmp_name'], $temp_file)) {
        throw new Exception(__("Sorry, could not upload the file chunk"));
      }

      // if this is the last chunk, reassemble the file
      if ($chunkIndex + 1 === $totalChunks) {

        // prepare final file name & path
        $prefix = $system['uploads_prefix'] . '_' . get_hash_token();
        $final_file_name = $directory . $prefix . '.' . $extension;
        $final_file_path = ABSPATH . $system['uploads_directory'] . '/' . $final_file_name;

        // reassemble the chunks into the final file
        reassemble_file_chunks($temp_directory, $file_guid, $file_name, $totalChunks, $final_file_path);

        // check file size
        $final_file_size = filesize($final_file_path);
        if (!$user->_is_admin && !$user->_is_moderator) {
          if ($final_file_size > $max_allowed_size) {
            throw new ValidationException(__("The file size is so big") . ", " . __("The allowed file size is:") . " " . ($max_allowed_size / 1024 / 1024) . __("MB"));
          }
        }

        // init image
        require_once(ABSPATH . 'includes/class-image.php');
        $image = new Image($final_file_path);

        // check if animated webp allowed
        if (!$system['allow_animated_images']) {
          if ($image->_img_type == "image/gif" || ($image->isWebpAnimated($final_file_path) && in_array($_POST['handle'], ['cover-user', 'picture-user', 'cover-page', 'picture-page', 'cover-group', 'picture-group', 'cover-event']))) {
            throw new ValidationException(__("Sorry, You can't upload animated webp images"));
          }
        }

        // check image resolution
        if (in_array($_POST['handle'], ['picture-user', 'picture-page', 'picture-group'])) {
          if ($image->getWidth() < 150 || $image->getHeight() < 150) {
            unlink($final_file_path);
            throw new ValidationException(__("Please choose an image that's at least 150 pixels wide and at least 150 pixels tall"));
          }
        } elseif (in_array($_POST['handle'], ['cover-user', 'cover-page', 'cover-group'])) {
          if ($system['limit_cover_photo']) {
            if ($image->getWidth() < 1296 || $image->getHeight() < 360) {
              unlink($final_file_path);
              throw new ValidationException(__("Please choose an image that's at least 1296 pixels wide and at least 360 pixels tall"));
            }
          }
        }

        // adult images detection
        $image_blured = 0;
        if ($system['adult_images_enabled']) {
          if ($_POST['handle'] != "x-image" && google_vision_check($final_file_path)) {
            if ($system['adult_images_action'] == "delete") {
              throw new ValidationException(__("Sorry, can not upload the file for adult content"));
            } else {
              $image_blured = 1;
            }
          }
        }

        // blur images (exclude gif & webp)
        $image_source_blured = 0;
        if ($_POST['blur'] == "true") {
          if (!in_array($image->_img_type, ["image/gif", "image/webp"])) {
            /* watermark & blur */
            watermark_image($final_file_path, $image->_img_type);
            blur_image($final_file_path, $image->_img_type);
            $image_source_blured = 1;
          }
        }

        // watermark images (exclude gif & webp)
        $image_watermarked = false;
        if ($system['watermark_enabled']) {
          if (!in_array($image->_img_type, ["image/gif", "image/webp"]) && in_array($_POST['handle'], ['publisher', 'publisher-mini'])) {
            watermark_image($final_file_path, $image->_img_type);
            $image_watermarked = true;
          }
        }

        // save the new image (exclude gif & webp)
        if (!in_array($image->_img_type, ["image/gif", "image/webp"])) {
          if ($image_source_blured || $image_watermarked) {
            $image = new Image($final_file_path);
          }
          $image->save($final_file_path, $system['uploads_quality']);
        }

        // upload to
        if ($system['s3_enabled']) {
          /* Amazon S3 */
          aws_s3_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['google_cloud_enabled']) {
          /* Google Cloud */
          google_cloud_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['digitalocean_enabled']) {
          /* DigitalOcean */
          digitalocean_space_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['wasabi_enabled']) {
          /* Wasabi */
          wasabi_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['backblaze_enabled']) {
          /* Backblaze */
          backblaze_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['yandex_cloud_enabled']) {
          /* Yandex Cloud */
          yandex_cloud_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['cloudflare_r2_enabled']) {
          /* Cloudflare R2 */
          cloudflare_r2_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['pushr_enabled']) {
          /* Pushr */
          pushr_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['ftp_enabled']) {
          /* FTP */
          ftp_upload($final_file_path, $final_file_name);
        }

        // add the file to the users uploads
        add_user_uploads($final_file_name, $final_file_size);

        // add the file to the pending uploads
        if (!in_array($_POST['handle'], ['cover-user', 'picture-user', 'cover-page', 'picture-page', 'cover-group', 'picture-group', 'cover-event'])) {
          add_pending_uploads($final_file_name, $final_file_size, $_POST['handle']);
        }

        // check the handle
        switch ($_POST['handle']) {
          case 'cover-user':
            /* check for cover album */
            if (!$user->_data['user_album_covers']) {
              /* create new cover album */
              $db->query(sprintf("INSERT INTO posts_photos_albums (user_id, user_type, title, privacy) VALUES (%s, 'user', 'Cover Photos', 'public')", secure($user->_data['user_id'], 'int')));
              $user->_data['user_album_covers'] = $db->insert_id;
              /* update user cover album id */
              $db->query(sprintf("UPDATE users SET user_album_covers = %s WHERE user_id = %s", secure($user->_data['user_album_covers'], 'int'), secure($user->_data['user_id'], 'int')));
            }
            /* insert updated cover photo post */
            $db->query(sprintf("INSERT INTO posts (user_id, user_type, post_type, time, privacy) VALUES (%s, 'user', 'profile_cover', %s, 'public')", secure($user->_data['user_id'], 'int'), secure($date)));
            $post_id = $db->insert_id;
            /* insert new cover photo to album */
            $db->query(sprintf("INSERT INTO posts_photos (post_id, album_id, source, blur) VALUES (%s, %s, %s, %s)", secure($post_id, 'int'), secure($user->_data['user_album_covers'], 'int'), secure($final_file_name), secure($image_blured)));
            $photo_id = $db->insert_id;
            /* update user cover */
            $db->query(sprintf("UPDATE users SET user_cover = %s, user_cover_id = %s WHERE user_id = %s", secure($final_file_name), secure($photo_id, 'int'), secure($user->_data['user_id'], 'int')));
            break;

          case 'picture-user':
            /* check for profile pictures album */
            if (!$user->_data['user_album_pictures']) {
              /* create new profile pictures album */
              $db->query(sprintf("INSERT INTO posts_photos_albums (user_id, user_type, title, privacy) VALUES (%s, 'user', 'Profile Pictures', 'public')", secure($user->_data['user_id'], 'int')));
              $user->_data['user_album_pictures'] = $db->insert_id;
              /* update user profile picture album id */
              $db->query(sprintf("UPDATE users SET user_album_pictures = %s WHERE user_id = %s", secure($user->_data['user_album_pictures'], 'int'), secure($user->_data['user_id'], 'int')));
            }
            /* insert updated profile picture post */
            $db->query(sprintf("INSERT INTO posts (user_id, user_type, post_type, time, privacy) VALUES (%s, 'user', 'profile_picture', %s, 'public')", secure($user->_data['user_id'], 'int'), secure($date)));
            $post_id = $db->insert_id;
            /* insert new profile picture to album */
            $db->query(sprintf("INSERT INTO posts_photos (post_id, album_id, source, blur) VALUES (%s, %s, %s, %s)", secure($post_id, 'int'), secure($user->_data['user_album_pictures'], 'int'), secure($final_file_name), secure($image_blured)));
            $photo_id = $db->insert_id;
            /* delete old cropped picture from uploads folder */
            delete_uploads_file($user->_data['user_picture_raw']);
            /* update user profile picture */
            $db->query(sprintf("UPDATE users SET user_picture = %s, user_picture_id = %s WHERE user_id = %s", secure($final_file_name), secure($photo_id, 'int'), secure($user->_data['user_id'], 'int')));
            break;

          case 'cover-page':
            /* check if page id is set */
            if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
              /* delete the uploaded image & return error 403 */
              unlink($final_file_path);
              _error(403);
            }
            /* check the page */
            $get_page = $db->query(sprintf("SELECT * FROM pages WHERE page_id = %s", secure($_POST['id'], 'int')));
            if ($get_page->num_rows == 0) {
              /* delete the uploaded image & return error 403 */
              unlink($final_file_path);
              _error(403);
            }
            $page = $get_page->fetch_assoc();
            /* check if the user is the page admin */
            if (!$user->check_page_adminship($user->_data['user_id'], $page['page_id'])) {
              /* delete the uploaded image & return error 403 */
              unlink($final_file_path);
              _error(403);
            }
            /* check for cover album */
            if (!$page['page_album_covers']) {
              /* create new cover album */
              $db->query(sprintf("INSERT INTO posts_photos_albums (user_id, user_type, title, privacy) VALUES (%s, 'page', 'Cover Photos', 'public')", secure($page['page_id'], 'int')));
              $page['page_album_covers'] = $db->insert_id;
              /* update page cover album id */
              $db->query(sprintf("UPDATE pages SET page_album_covers = %s WHERE page_id = %s", secure($page['page_album_covers'], 'int'), secure($page['page_id'], 'int')));
            }
            /* insert updated cover photo post */
            $db->query(sprintf("INSERT INTO posts (user_id, user_type, post_type, time, privacy) VALUES (%s, 'page', 'page_cover', %s, 'public')", secure($page['page_id'], 'int'), secure($date)));
            $post_id = $db->insert_id;
            /* insert new cover photo to album */
            $db->query(sprintf("INSERT INTO posts_photos (post_id, album_id, source, blur) VALUES (%s, %s, %s, %s)", secure($post_id, 'int'), secure($page['page_album_covers'], 'int'), secure($final_file_name), secure($image_blured)));
            $photo_id = $db->insert_id;
            /* update page cover */
            $db->query(sprintf("UPDATE pages SET page_cover = %s, page_cover_id = %s WHERE page_id = %s", secure($final_file_name), secure($photo_id, 'int'), secure($page['page_id'], 'int')));
            break;

          case 'picture-page':
            /* check if page id is set */
            if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
              /* delete the uploaded image & return error 403 */
              unlink($final_file_path);
              _error(403);
            }
            /* check the page */
            $get_page = $db->query(sprintf("SELECT * FROM pages WHERE page_id = %s", secure($_POST['id'], 'int')));
            if ($get_page->num_rows == 0) {
              /* delete the uploaded image & return error 403 */
              unlink($final_file_path);
              _error(403);
            }
            $page = $get_page->fetch_assoc();
            /* check if the user is the page admin */
            if (!$user->check_page_adminship($user->_data['user_id'], $page['page_id'])) {
              /* delete the uploaded image & return error 403 */
              unlink($final_file_path);
              _error(403);
            }
            /* check for page pictures album */
            if (!$page['page_album_pictures']) {
              /* create new page pictures album */
              $db->query(sprintf("INSERT INTO posts_photos_albums (user_id, user_type, title, privacy) VALUES (%s, 'page', 'Profile Pictures', 'public')", secure($page['page_id'], 'int')));
              $page['page_album_pictures'] = $db->insert_id;
              /* update page profile picture album id */
              $db->query(sprintf("UPDATE pages SET page_album_pictures = %s WHERE page_id = %s", secure($page['page_album_pictures'], 'int'), secure($page['page_id'], 'int')));
            }
            /* insert updated page picture post */
            $db->query(sprintf("INSERT INTO posts (user_id, user_type, post_type, time, privacy) VALUES (%s, 'page', 'page_picture', %s, 'public')", secure($page['page_id'], 'int'), secure($date)));
            $post_id = $db->insert_id;
            /* insert new page picture to album */
            $db->query(sprintf("INSERT INTO posts_photos (post_id, album_id, source, blur) VALUES (%s, %s, %s, %s)", secure($post_id, 'int'), secure($page['page_album_pictures'], 'int'), secure($final_file_name), secure($image_blured)));
            $photo_id = $db->insert_id;
            /* delete old cropped picture from uploads folder */
            delete_uploads_file($page['page_picture']);
            /* update page picture */
            $db->query(sprintf("UPDATE pages SET page_picture = %s, page_picture_id = %s WHERE page_id = %s", secure($final_file_name), secure($photo_id, 'int'), secure($page['page_id'], 'int')));
            break;

          case 'cover-group':
            /* check if group id is set */
            if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
              /* delete the uploaded image & return error 403 */
              unlink($final_file_path);
              _error(403);
            }
            /* check the group */
            $get_group = $db->query(sprintf("SELECT * FROM `groups` WHERE group_id = %s", secure($_POST['id'], 'int')));
            if ($get_group->num_rows == 0) {
              /* delete the uploaded image & return error 403 */
              unlink($final_file_path);
              _error(403);
            }
            $group = $get_group->fetch_assoc();
            /* check if the user is the group admin */
            if (!$user->check_group_adminship($user->_data['user_id'], $group['group_id'])) {
              /* delete the uploaded image & return error 403 */
              unlink($final_file_path);
              _error(403);
            }
            /* check for group covers album */
            if (!$group['group_album_covers']) {
              /* create new group covers album */
              $db->query(sprintf("INSERT INTO posts_photos_albums (user_id, user_type, in_group, group_id, title, privacy) VALUES (%s, 'user', '1', %s, 'Cover Photos', 'public')", secure($user->_data['user_id'], 'int'), secure($group['group_id'], 'int')));
              $group['group_album_covers'] = $db->insert_id;
              /* update group cover album id */
              $db->query(sprintf("UPDATE `groups` SET group_album_covers = %s WHERE group_id = %s", secure($group['group_album_covers'], 'int'), secure($group['group_id'], 'int')));
            }
            /* insert updated group cover post */
            $db->query(sprintf("INSERT INTO posts (user_id, user_type, post_type, in_group, group_id, time, privacy) VALUES (%s, 'user', 'group_cover', '1', %s, %s, 'custom')", secure($user->_data['user_id'], 'int'), secure($group['group_id'], 'int'), secure($date)));
            $post_id = $db->insert_id;
            /* insert new group cover to album */
            $db->query(sprintf("INSERT INTO posts_photos (post_id, album_id, source, blur) VALUES (%s, %s, %s, %s)", secure($post_id, 'int'), secure($group['group_album_covers'], 'int'), secure($final_file_name), secure($image_blured)));
            $photo_id = $db->insert_id;
            /* update group cover */
            $db->query(sprintf("UPDATE `groups` SET group_cover = %s, group_cover_id = %s WHERE group_id = %s", secure($final_file_name), secure($photo_id, 'int'), secure($group['group_id'], 'int')));
            break;

          case 'picture-group':
            /* check if group id is set */
            if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
              /* delete the uploaded image & return error 403 */
              unlink($final_file_path);
              _error(403);
            }
            /* check the group */
            $get_group = $db->query(sprintf("SELECT * FROM `groups` WHERE group_id = %s", secure($_POST['id'], 'int')));
            if ($get_group->num_rows == 0) {
              /* delete the uploaded image & return error 403 */
              unlink($final_file_path);
              _error(403);
            }
            $group = $get_group->fetch_assoc();
            /* check if the user is the group admin */
            if (!$user->check_group_adminship($user->_data['user_id'], $group['group_id'])) {
              /* delete the uploaded image & return error 403 */
              unlink($final_file_path);
              _error(403);
            }
            /* check for group pictures album */
            if (!$group['group_album_pictures']) {
              /* create new group pictures album */
              $db->query(sprintf("INSERT INTO posts_photos_albums (user_id, user_type, in_group, group_id, title, privacy) VALUES (%s, 'user', '1', %s, 'Profile Pictures', 'public')", secure($user->_data['user_id'], 'int'), secure($group['group_id'], 'int')));
              $group['group_album_pictures'] = $db->insert_id;
              /* update group profile picture album id */
              $db->query(sprintf("UPDATE `groups` SET group_album_pictures = %s WHERE group_id = %s", secure($group['group_album_pictures'], 'int'), secure($group['group_id'], 'int')));
            }
            /* insert updated group picture post */
            $db->query(sprintf("INSERT INTO posts (user_id, user_type, post_type, in_group, group_id, time, privacy) VALUES (%s, 'user', 'group_picture', '1', %s, %s, 'custom')", secure($user->_data['user_id'], 'int'), secure($group['group_id'], 'int'), secure($date)));
            $post_id = $db->insert_id;
            /* insert new group picture to album */
            $db->query(sprintf("INSERT INTO posts_photos (post_id, album_id, source, blur) VALUES (%s, %s, %s, %s)", secure($post_id, 'int'), secure($group['group_album_pictures'], 'int'), secure($final_file_name), secure($image_blured)));
            $photo_id = $db->insert_id;
            /* delete old cropped picture from uploads folder */
            delete_uploads_file($group['group_picture']);
            /* update group picture */
            $db->query(sprintf("UPDATE `groups` SET group_picture = %s, group_picture_id = %s WHERE group_id = %s", secure($final_file_name), secure($photo_id, 'int'), secure($group['group_id'], 'int')));
            break;

          case 'cover-event':
            /* check if event id is set */
            if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
              /* delete the uploaded image & return error 403 */
              unlink($final_file_path);
              _error(403);
            }
            /* check the event */
            $get_event = $db->query(sprintf("SELECT * FROM `events` WHERE event_id = %s", secure($_POST['id'], 'int')));
            if ($get_event->num_rows == 0) {
              /* delete the uploaded image & return error 403 */
              unlink($final_file_path);
              _error(403);
            }
            $event = $get_event->fetch_assoc();
            /* check if the user is the event admin */
            if (!$user->check_event_adminship($user->_data['user_id'], $event['event_id'])) {
              /* delete the uploaded image & return error 403 */
              unlink($final_file_path);
              _error(403);
            }
            /* check for event covers album */
            if (!$event['event_album_covers']) {
              /* create new event covers album */
              $db->query(sprintf("INSERT INTO posts_photos_albums (user_id, user_type, in_event, event_id, title, privacy) VALUES (%s, 'user', '1', %s, 'Cover Photos', 'public')", secure($user->_data['user_id'], 'int'), secure($event['event_id'], 'int')));
              $event['event_album_covers'] = $db->insert_id;
              /* update event cover album id */
              $db->query(sprintf("UPDATE `events` SET event_album_covers = %s WHERE event_id = %s", secure($event['event_album_covers'], 'int'), secure($event['event_id'], 'int')));
            }
            /* prepare author */
            $author_type = ($event['event_page_id']) ? 'page' : 'user';
            $author_id = ($event['event_page_id']) ? $event['event_page_id'] : $user->_data['user_id'];
            /* insert updated event cover post */
            $db->query(sprintf("INSERT INTO posts (user_id, user_type, post_type, in_event, event_id, time, privacy) VALUES (%s, %s, 'event_cover', '1', %s, %s, 'custom')", secure($author_id, 'int'), secure($author_type), secure($event['event_id'], 'int'), secure($date)));
            $post_id = $db->insert_id;
            /* insert new event cover to album */
            $db->query(sprintf("INSERT INTO posts_photos (post_id, album_id, source, blur) VALUES (%s, %s, %s, %s)", secure($post_id, 'int'), secure($event['event_album_covers'], 'int'), secure($final_file_name), secure($image_blured)));
            $photo_id = $db->insert_id;
            /* update event cover */
            $db->query(sprintf("UPDATE `events` SET event_cover = %s, event_cover_id = %s WHERE event_id = %s", secure($final_file_name), secure($photo_id, 'int'), secure($event['event_id'], 'int')));
            break;
        }

        // return the file name & exit
        if ($_POST["multiple"] == "true") {
          $finished_files[] = ["source" => $final_file_name, "blur" => $image_blured];
          if ($_POST["totalFiles"] == $_POST["fileIndex"] + 1) {
            return $finished_files;
          } else {
            return_json(['status' => 'ok', 'finished_files' => $finished_files]);
          }
        } else {
          return $final_file_name;
        }
      }

      // If not all chunks are uploaded yet, return a status
      return_json(['status' => 'ok']);
      break;

    case 'video':
      // check videos upload permission
      if (!$user->_data['can_upload_videos']) {
        throw new AuthorizationException(__("You don't have the permission to do this"));
      }

      // get allowed file size
      $max_allowed_size = $system['max_video_size'] * 1024;

      // prepare uploads directory
      $folder = 'videos';
      $directory = $folder . '/' . date('Y') . '/' . date('m') . '/';
      if (!file_exists(ABSPATH . $system['uploads_directory'] . '/' . $directory)) {
        @mkdir(ABSPATH . $system['uploads_directory'] . '/' . $directory, 0777, true);
      }

      // check file extesnion
      $extension = get_extension($file_name);
      if (!valid_extension($extension, $system['video_extensions'])) {
        throw new BadRequestException(__("The file type is not valid or not supported"));
      }

      // save each chunk to a temporary file
      $temp_file = $temp_directory . $file_guid . '_' . $file_name .  ".part-" . $chunkIndex;
      if (!@move_uploaded_file($_FILES['file']['tmp_name'], $temp_file)) {
        throw new Exception(__("Sorry, could not upload the file chunk"));
      }

      // if this is the last chunk, reassemble the file
      if ($chunkIndex + 1 === $totalChunks) {

        // prepare final file name & path
        $prefix = $system['uploads_prefix'] . '_' . get_hash_token();
        $final_file_name = $directory . $prefix . '.' . $extension;
        $final_file_path = ABSPATH . $system['uploads_directory'] . '/' . $final_file_name;

        // reassemble the chunks into the final file
        reassemble_file_chunks($temp_directory, $file_guid, $file_name, $totalChunks, $final_file_path);

        // check file size
        $final_file_size = filesize($final_file_path);
        if (!$user->_is_admin && !$user->_is_moderator) {
          if ($final_file_size > $max_allowed_size) {
            throw new ValidationException(__("The file size is so big") . ", " . __("The allowed file size is:") . " " . ($max_allowed_size / 1024 / 1024) . __("MB"));
          }
        }

        // upload to
        if ($system['s3_enabled']) {
          /* Amazon S3 */
          aws_s3_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['google_cloud_enabled']) {
          /* Google Cloud */
          google_cloud_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['digitalocean_enabled']) {
          /* DigitalOcean */
          digitalocean_space_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['wasabi_enabled']) {
          /* Wasabi */
          wasabi_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['backblaze_enabled']) {
          /* Backblaze */
          backblaze_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['yandex_cloud_enabled']) {
          /* Yandex Cloud */
          yandex_cloud_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['cloudflare_r2_enabled']) {
          /* Cloudflare R2 */
          cloudflare_r2_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['pushr_enabled']) {
          /* Pushr */
          pushr_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['ftp_enabled']) {
          /* FTP */
          ftp_upload($final_file_path, $final_file_name);
        }

        // add the file to the users uploads
        add_user_uploads($final_file_name, $final_file_size);

        // add the file to the pending uploads
        add_pending_uploads($final_file_name, $final_file_size, $handle);

        // return the file new name & exit
        if ($_POST["multiple"] == "true") {
          $finished_files[] = $final_file_name;
          if ($_POST["totalFiles"] == $_POST["fileIndex"] + 1) {
            return $finished_files;
          } else {
            return_json(['status' => 'ok', 'finished_files' => $finished_files]);
          }
        } else {
          return $final_file_name;
        }
      }

      // If not all chunks are uploaded yet, return a status
      return_json(['status' => 'ok']);
      break;

    case 'reel':
      // check reels upload permission
      if (!$user->_data['can_add_reels']) {
        throw new AuthorizationException(__("You don't have the permission to do this"));
      }

      // get allowed file size
      $max_allowed_size = $system['max_video_size'] * 1024;

      // prepare uploads directory
      $folder = 'videos';
      $directory = $folder . '/' . date('Y') . '/' . date('m') . '/';
      if (!file_exists(ABSPATH . $system['uploads_directory'] . '/' . $directory)) {
        @mkdir(ABSPATH . $system['uploads_directory'] . '/' . $directory, 0777, true);
      }

      // check file extesnion
      $extension = get_extension($file_name);
      if (!valid_extension($extension, $system['video_extensions'])) {
        throw new BadRequestException(__("The file type is not valid or not supported"));
      }

      // save each chunk to a temporary file
      $temp_file = $temp_directory . $file_guid . '_' . $file_name .  ".part-" . $chunkIndex;
      if (!@move_uploaded_file($_FILES['file']['tmp_name'], $temp_file)) {
        throw new Exception(__("Sorry, could not upload the file chunk"));
      }

      // if this is the last chunk, reassemble the file
      if ($chunkIndex + 1 === $totalChunks) {

        // prepare final file name & path
        $prefix = $system['uploads_prefix'] . '_' . get_hash_token();
        $final_file_name = $directory . $prefix . '.' . $extension;
        $final_file_path = ABSPATH . $system['uploads_directory'] . '/' . $final_file_name;

        // reassemble the chunks into the final file
        reassemble_file_chunks($temp_directory, $file_guid, $file_name, $totalChunks, $final_file_path);

        // check file size
        $final_file_size = filesize($final_file_path);
        if (!$user->_is_admin && !$user->_is_moderator) {
          if ($final_file_size > $max_allowed_size) {
            throw new ValidationException(__("The file size is so big") . ", " . __("The allowed file size is:") . " " . ($max_allowed_size / 1024 / 1024) . __("MB"));
          }
        }

        // upload to
        if ($system['s3_enabled']) {
          /* Amazon S3 */
          aws_s3_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['google_cloud_enabled']) {
          /* Google Cloud */
          google_cloud_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['digitalocean_enabled']) {
          /* DigitalOcean */
          digitalocean_space_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['wasabi_enabled']) {
          /* Wasabi */
          wasabi_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['backblaze_enabled']) {
          /* Backblaze */
          backblaze_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['yandex_cloud_enabled']) {
          /* Yandex Cloud */
          yandex_cloud_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['cloudflare_r2_enabled']) {
          /* Cloudflare R2 */
          cloudflare_r2_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['pushr_enabled']) {
          /* Pushr */
          pushr_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['ftp_enabled']) {
          /* FTP */
          ftp_upload($final_file_path, $final_file_name);
        }

        // add the file to the users uploads
        add_user_uploads($final_file_name, $final_file_size);

        // add the file to the pending uploads
        add_pending_uploads($final_file_name, $final_file_size, $handle);

        // return the file new name & exit
        if ($_POST["multiple"] == "true") {
          $finished_files[] = $final_file_name;
          if ($_POST["totalFiles"] == $_POST["fileIndex"] + 1) {
            return $finished_files;
          } else {
            return_json(['status' => 'ok', 'finished_files' => $finished_files]);
          }
        } else {
          return $final_file_name;
        }
      }

      // If not all chunks are uploaded yet, return a status
      return_json(['status' => 'ok']);
      break;

    case 'audio':
      // check audios upload permission
      if (!$user->_data['can_upload_audios']) {
        throw new AuthorizationException(__("You don't have the permission to do this"));
      }

      // get allowed file size
      $max_allowed_size = $system['max_audio_size'] * 1024;

      // prepare uploads directory
      $folder = 'sounds';
      $directory = $folder . '/' . date('Y') . '/' . date('m') . '/';
      if (!file_exists(ABSPATH . $system['uploads_directory'] . '/' . $directory)) {
        @mkdir(ABSPATH . $system['uploads_directory'] . '/' . $directory, 0777, true);
      }

      // check file extesnion
      $extension = get_extension($file_name);
      if (!valid_extension($extension, $system['audio_extensions'])) {
        throw new BadRequestException(__("The file type is not valid or not supported XX"));
      }

      // save each chunk to a temporary file
      $temp_file = $temp_directory . $file_guid . '_' . $file_name .  ".part-" . $chunkIndex;
      if (!@move_uploaded_file($_FILES['file']['tmp_name'], $temp_file)) {
        throw new Exception(__("Sorry, could not upload the file chunk"));
      }

      // if this is the last chunk, reassemble the file
      if ($chunkIndex + 1 === $totalChunks) {

        // prepare final file name & path
        $prefix = $system['uploads_prefix'] . '_' . get_hash_token();
        $final_file_name = $directory . $prefix . '.' . $extension;
        $final_file_path = ABSPATH . $system['uploads_directory'] . '/' . $final_file_name;

        // reassemble the chunks into the final file
        reassemble_file_chunks($temp_directory, $file_guid, $file_name, $totalChunks, $final_file_path);

        // check file size
        $final_file_size = filesize($final_file_path);
        if (!$user->_is_admin && !$user->_is_moderator) {
          if ($final_file_size > $max_allowed_size) {
            throw new ValidationException(__("The file size is so big") . ", " . __("The allowed file size is:") . " " . ($max_allowed_size / 1024 / 1024) . __("MB"));
          }
        }

        // upload to
        if ($system['s3_enabled']) {
          /* Amazon S3 */
          aws_s3_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['google_cloud_enabled']) {
          /* Google Cloud */
          google_cloud_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['digitalocean_enabled']) {
          /* DigitalOcean */
          digitalocean_space_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['wasabi_enabled']) {
          /* Wasabi */
          wasabi_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['backblaze_enabled']) {
          /* Backblaze */
          backblaze_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['yandex_cloud_enabled']) {
          /* Yandex Cloud */
          yandex_cloud_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['cloudflare_r2_enabled']) {
          /* Cloudflare R2 */
          cloudflare_r2_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['pushr_enabled']) {
          /* Pushr */
          pushr_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['ftp_enabled']) {
          /* FTP */
          ftp_upload($final_file_path, $final_file_name);
        }

        // add the file to the users uploads
        add_user_uploads($final_file_name, $final_file_size);

        // add the file to the pending uploads
        add_pending_uploads($final_file_name, $final_file_size, $handle);

        // return the file new name & exit
        if ($_POST["multiple"] == "true") {
          $finished_files[] = $final_file_name;
          if ($_POST["totalFiles"] == $_POST["fileIndex"] + 1) {
            return $finished_files;
          } else {
            return_json(['status' => 'ok', 'finished_files' => $finished_files]);
          }
        } else {
          return $final_file_name;
        }
      }

      // If not all chunks are uploaded yet, return a status
      return_json(['status' => 'ok']);
      break;

    case 'file':
      // check files upload permission
      if ($_POST['handle'] != "x-file" && !$user->_data['can_upload_files']) {
        modal("ERROR", __("Not Allowed"), __("You don't have the permission to do this"));
      }

      // get allowed file size
      $max_allowed_size = $system['max_file_size'] * 1024;

      // prepare uploads directory
      $folder = 'files';
      $directory = $folder . '/' . date('Y') . '/' . date('m') . '/';
      if (!file_exists(ABSPATH . $system['uploads_directory'] . '/' . $directory)) {
        @mkdir(ABSPATH . $system['uploads_directory'] . '/' . $directory, 0777, true);
      }

      // check file extesnion
      $extension = get_extension($file_name);
      if (!valid_extension($extension, $system['file_extensions'])) {
        throw new BadRequestException(__("The file type is not valid or not supported"));
      }

      // save each chunk to a temporary file
      $temp_file = $temp_directory . $file_guid . '_' . $file_name .  ".part-" . $chunkIndex;
      if (!@move_uploaded_file($_FILES['file']['tmp_name'], $temp_file)) {
        throw new Exception(__("Sorry, could not upload the file chunk"));
      }

      // if this is the last chunk, reassemble the file
      if ($chunkIndex + 1 === $totalChunks) {

        // prepare final file name & path
        $prefix = $system['uploads_prefix'] . '_' . get_hash_token();
        $final_file_name = $directory . $prefix . '.' . $extension;
        $final_file_path = ABSPATH . $system['uploads_directory'] . '/' . $final_file_name;

        // reassemble the chunks into the final file
        reassemble_file_chunks($temp_directory, $file_guid, $file_name, $totalChunks, $final_file_path);

        // check file size
        $final_file_size = filesize($final_file_path);
        if (!$user->_is_admin && !$user->_is_moderator) {
          if ($final_file_size > $max_allowed_size) {
            throw new ValidationException(__("The file size is so big") . ", " . __("The allowed file size is:") . " " . ($max_allowed_size / 1024 / 1024) . __("MB"));
          }
        }

        // upload to
        if ($system['s3_enabled']) {
          /* Amazon S3 */
          aws_s3_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['google_cloud_enabled']) {
          /* Google Cloud */
          google_cloud_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['digitalocean_enabled']) {
          /* DigitalOcean */
          digitalocean_space_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['wasabi_enabled']) {
          /* Wasabi */
          wasabi_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['backblaze_enabled']) {
          /* Backblaze */
          backblaze_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['yandex_cloud_enabled']) {
          /* Yandex Cloud */
          yandex_cloud_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['cloudflare_r2_enabled']) {
          /* Cloudflare R2 */
          cloudflare_r2_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['pushr_enabled']) {
          /* Pushr */
          pushr_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['ftp_enabled']) {
          /* FTP */
          ftp_upload($final_file_path, $final_file_name);
        }

        // add the file to the users uploads
        add_user_uploads($final_file_name, $final_file_size);

        // add the file to the pending uploads
        add_pending_uploads($final_file_name, $final_file_size, $handle);

        // return the file new name & exit
        if ($_POST["multiple"] == "true") {
          $finished_files[] = $final_file_name;
          if ($_POST["totalFiles"] == $_POST["fileIndex"] + 1) {
            return $finished_files;
          } else {
            return_json(['status' => 'ok', 'finished_files' => $finished_files]);
          }
        } else {
          return $final_file_name;
        }
      }

      // If not all chunks are uploaded yet, return a status
      return_json(['status' => 'ok']);
      break;

    default:
      _error(403);
      break;
  }
}


/**
 * delete_avatar_cover_image
 *
 * @param string $handle
 * @param int $id
 * @return void
 */
function delete_avatar_cover_image($handle, $id = null)
{
  global $db, $user, $system;
  switch ($_POST['handle']) {
    case 'cover-user':
      /* update user cover */
      $db->query(sprintf("UPDATE users SET user_cover = null, user_cover_id = null, user_cover_position = null WHERE user_id = %s", secure($user->_data['user_id'], 'int')));
      break;

    case 'picture-user':
      /* update user picture */
      $db->query(sprintf("UPDATE users SET user_picture = null, user_picture_id = null WHERE user_id = %s", secure($user->_data['user_id'], 'int')));
      /* return */
      return get_picture('', $user->_data['user_gender']);
      break;

    case 'cover-page':
      /* check if page id is set */
      if (!isset($id) || !is_numeric($id)) {
        throw new BadRequestException(__("Invalid ID"));
      }
      /* check the page */
      $get_page = $db->query(sprintf("SELECT * FROM pages WHERE page_id = %s", secure($id, 'int')));
      if ($get_page->num_rows == 0) {
        throw new NoDataException(__("Page not found"));
      }
      $page = $get_page->fetch_assoc();
      /* check if the user is the page admin */
      if (!$user->check_page_adminship($user->_data['user_id'], $page['page_id'])) {
        throw new AuthorizationException(__("You don't have the right permission to do this"));
      }
      /* update page cover */
      $db->query(sprintf("UPDATE pages SET page_cover = null, page_cover_id = null, page_cover_position = null WHERE page_id = %s", secure($id, 'int')));
      break;

    case 'picture-page':
      /* check if page id is set */
      if (!isset($id) || !is_numeric($id)) {
        throw new BadRequestException(__("Invalid ID"));
      }
      /* check the page */
      $get_page = $db->query(sprintf("SELECT * FROM pages WHERE page_id = %s", secure($id, 'int')));
      if ($get_page->num_rows == 0) {
        throw new NoDataException(__("Page not found"));
      }
      $page = $get_page->fetch_assoc();
      /* check if the user is the page admin */
      if (!$user->check_page_adminship($user->_data['user_id'], $page['page_id'])) {
        throw new AuthorizationException(__("You don't have the right permission to do this"));
      }
      /* update page picture */
      $db->query(sprintf("UPDATE pages SET page_picture = null, page_picture_id = null WHERE page_id = %s", secure($id, 'int')));
      /* return */
      return get_picture('', 'page');
      break;

    case 'cover-group':
      /* check if group id is set */
      if (!isset($id) || !is_numeric($id)) {
        throw new BadRequestException(__("Invalid ID"));
      }
      /* check the group */
      $get_group = $db->query(sprintf("SELECT * FROM `groups` WHERE group_id = %s", secure($id, 'int')));
      if ($get_group->num_rows == 0) {
        throw new NoDataException(__("Group not found"));
      }
      $group = $get_group->fetch_assoc();
      /* check if the user is the group admin */
      if (!$user->check_group_adminship($user->_data['user_id'], $group['group_id'])) {
        throw new AuthorizationException(__("You don't have the right permission to do this"));
      }
      /* update group cover */
      $db->query(sprintf("UPDATE `groups` SET group_cover = null, group_cover_id = null, group_cover_position = null WHERE group_id = %s", secure($id, 'int')));
      break;

    case 'picture-group':
      /* check if group id is set */
      if (!isset($id) || !is_numeric($id)) {
        throw new BadRequestException(__("Invalid ID"));
      }
      /* check the group */
      $get_group = $db->query(sprintf("SELECT * FROM `groups` WHERE group_id = %s", secure($id, 'int')));
      if ($get_group->num_rows == 0) {
        throw new NoDataException(__("Group not found"));
      }
      $group = $get_group->fetch_assoc();
      /* check if the user is the group admin */
      if (!$user->check_group_adminship($user->_data['user_id'], $group['group_id'])) {
        throw new AuthorizationException(__("You don't have the right permission to do this"));
      }
      /* update group picture */
      $db->query(sprintf("UPDATE `groups` SET group_picture = null, group_picture_id = null WHERE group_id = %s", secure($id, 'int')));
      /* return */
      return get_picture('', 'group');
      break;

    case 'cover-event':
      /* check if event id is set */
      if (!isset($id) || !is_numeric($id)) {
        throw new BadRequestException(__("Invalid ID"));
      }
      /* check the event */
      $get_event = $db->query(sprintf("SELECT * FROM `events` WHERE event_id = %s", secure($id, 'int')));
      if ($get_event->num_rows == 0) {
        throw new NoDataException(__("Event not found"));
      }
      $event = $get_event->fetch_assoc();
      /* check if the user is the event admin */
      if (!$user->check_event_adminship($user->_data['user_id'], $event['event_id'])) {
        throw new AuthorizationException(__("You don't have the right permission to do this"));
      }
      /* update event cover */
      $db->query(sprintf("UPDATE `events` SET event_cover = null, event_cover_id = null, event_cover_position = null WHERE event_id = %s", secure($id, 'int')));
      break;

    default:
      throw new BadRequestException(__("Invalid request"));
      break;
  }
}


/**
 * add_user_uploads
 *
 * @param string $file_name
 * @param int $file_size
 * @return void
 */
function add_user_uploads($file_name, $file_size)
{
  global $db, $user, $date;
  $db->query(sprintf("INSERT INTO users_uploads (user_id, file_name, file_size, insert_date) VALUES (%s, %s, %s, %s)", secure($user->_data['user_id'], 'int'), secure($file_name), secure($file_size), secure($date)));
}


/**
 * add_pending_uploads
 *
 * @param string $file_name
 * @param int $file_size
 * @param string $handle
 * @return void
 */
function add_pending_uploads($file_name, $file_size, $handle)
{
  global $db, $user, $date;
  $db->query(sprintf("INSERT INTO users_uploads_pending (user_id, file_name, file_size, handle, insert_date) VALUES (%s, %s, %s, %s, %s)", secure($user->_data['user_id'], 'int'), secure($file_name), secure($file_size), secure($handle), secure($date)));
}


/**
 * remove_pending_uploads
 *
 * @param array $files
 * @return void
 */
function remove_pending_uploads($files = [])
{
  global $db, $user;
  foreach ($files as $file_name) {
    if (empty($file_name)) continue;
    $db->query(sprintf("DELETE FROM users_uploads_pending WHERE user_id = %s AND file_name = %s", secure($user->_data['user_id'], 'int'), secure($file_name)));
  }
}


/**
 * clear_pending_uploads
 *
 * @return void
 */
function clear_pending_uploads()
{
  global $db;
  $pending_uploads = $db->query("SELECT * FROM users_uploads_pending");
  while ($pending_upload = $pending_uploads->fetch_assoc()) {
    delete_uploads_file($pending_upload['file_name']);
  }
}


/**
 * extract_uploaded_images_from_text
 *
 * @param string $text
 * @return array
 */
function extract_uploaded_images_from_text($text)
{
  global $system;
  $images = [];
  preg_replace_callback('/<img[^>]+src="([^"]+)"[^>]*>/', function ($matches) use (&$images, $system) {
    $src = $matches[1];
    if (strpos($src, $system['system_uploads']) === 0) {
      $relative_path = substr($src, strlen($system['system_uploads']));
      $relative_path = ltrim($relative_path, '/');
      $images[] = $relative_path;
    }
    return '';
  }, $text);
  return $images;
}


/* ------------------------------- */
/* Cloud Storage */
/* ------------------------------- */

/**
 * aws_s3_test
 *
 * @param string $s3_bucket
 * @param string $s3_region
 * @param string $s3_key
 * @param string $s3_secret
 *
 * @return void
 */
function aws_s3_test($s3_bucket, $s3_region, $s3_key, $s3_secret)
{
  try {
    $s3Client = Aws\S3\S3Client::factory([
      'version'    => 'latest',
      'region'      => $s3_region,
      'credentials' => [
        'key'    => $s3_key,
        'secret' => $s3_secret,
      ]
    ]);
    $buckets = $s3Client->listBuckets();
    if (empty($buckets)) {
      throw new Exception(__("There is no buckets in your account"));
    }
    if (!$s3Client->doesBucketExist($s3_bucket)) {
      throw new Exception(__("There is no bucket with this name in your account"));
    }
  } catch (Exception $e) {
    if (DEBUGGING) {
      throw new Exception($e->getMessage());
    } else {
      throw new Exception(__("Connection Failed, Please check your settings"));
    }
  }
}


/**
 * aws_s3_upload
 *
 * @param string $file_source
 * @param string $file_name
 * @param string $content_type
 * @return void
 */
function aws_s3_upload($file_source, $file_name, $content_type = "")
{
  global $system;
  $s3Client = Aws\S3\S3Client::factory([
    'version'     => 'latest',
    'region'      => $system['s3_region'],
    'credentials' => [
      'key'     => $system['s3_key'],
      'secret'  => $system['s3_secret'],
    ]
  ]);
  $Key = 'uploads/' . $file_name;
  $s3Client->putObject([
    'Bucket' => $system['s3_bucket'],
    'Key'    => $Key,
    'Body'   => fopen($file_source, 'r+'),
    'ContentDisposition' => 'inline',
    'ContentType' => $content_type,
    'ACL'    => 'public-read',
  ]);
  /* remove local file */
  gc_collect_cycles();
  if ($s3Client->doesObjectExist($system['s3_bucket'], $Key)) {
    unlink($file_source);
  }
}


/**
 * google_cloud_test
 *
 * @return void
 */
function google_cloud_test()
{
  global $system;
  try {
    $storage = new Google\Cloud\Storage\StorageClient([
      'keyFile' => json_decode(html_entity_decode($system['google_cloud_file'], ENT_QUOTES), true),
    ]);
    $bucket = $storage->bucket($system['google_cloud_bucket']);
    if (!$bucket->exists()) {
      throw new Exception(__("There is no buckets in your account"));
    }
  } catch (Exception $e) {
    if (DEBUGGING) {
      throw new Exception($e->getMessage());
    } else {
      throw new Exception(__("Connection Failed, Please check your settings"));
    }
  }
}


/**
 * google_cloud_upload
 *
 * @param string $file_source
 * @param string $file_name
 * @param string $content_type
 * @return void
 */
function google_cloud_upload($file_source, $file_name, $content_type = "")
{
  global $system;
  $storage = new Google\Cloud\Storage\StorageClient([
    'keyFile' => json_decode(html_entity_decode($system['google_cloud_file'], ENT_QUOTES), true),
  ]);
  $bucket = $storage->bucket($system['google_cloud_bucket']);
  $fileContent = file_get_contents($file_source);
  $Key = 'uploads/' . $file_name;
  $storageObject = $bucket->upload($fileContent, ['name' => $Key]);
  /* remove local file */
  gc_collect_cycles();
  if (!empty($storageObject)) {
    unlink($file_source);
  }
}


/**
 * digitalocean_space_test
 *
 * @return void
 */
function digitalocean_space_test()
{
  global $system;
  try {
    $s3Client = Aws\S3\S3Client::factory([
      'version'     => 'latest',
      'endpoint'    => 'https://' . $system['digitalocean_space_region'] . '.digitaloceanspaces.com',
      'region'      => $system['digitalocean_space_region'],
      'credentials' => [
        'key'     => $system['digitalocean_key'],
        'secret'  => $system['digitalocean_secret'],
      ]
    ]);
    $buckets = $s3Client->listBuckets();
    if (empty($buckets)) {
      throw new Exception(__("There is no buckets in your account"));
    }
    if (!$s3Client->doesBucketExist($system['digitalocean_space_name'])) {
      throw new Exception(__("There is no bucket with this name in your account"));
    }
  } catch (Exception $e) {
    if (DEBUGGING) {
      throw new Exception($e->getMessage());
    } else {
      throw new Exception(__("Connection Failed, Please check your settings"));
    }
  }
}


/**
 * digitalocean_space_upload
 *
 * @param string $file_source
 * @param string $file_name
 * @param string $content_type
 * @return void
 */
function digitalocean_space_upload($file_source, $file_name, $content_type = "")
{
  global $system;
  $s3Client = Aws\S3\S3Client::factory([
    'version'     => 'latest',
    'endpoint'    => 'https://' . $system['digitalocean_space_region'] . '.digitaloceanspaces.com',
    'region'      => $system['digitalocean_space_region'],
    'credentials' => [
      'key'     => $system['digitalocean_key'],
      'secret'  => $system['digitalocean_secret'],
    ]
  ]);
  $Key = 'uploads/' . $file_name;
  $s3Client->putObject([
    'Bucket' => $system['digitalocean_space_name'],
    'Key'    => $Key,
    'Body'   => fopen($file_source, 'r+'),
    'ContentDisposition' => 'inline',
    'ContentType' => $content_type,
    'ACL'    => 'public-read',
  ]);
  /* remove local file */
  gc_collect_cycles();
  if ($s3Client->doesObjectExist($system['digitalocean_space_name'], $Key)) {
    unlink($file_source);
  }
}


/**
 * wasabi_test
 *
 * @return void
 */
function wasabi_test()
{
  global $system;
  try {
    $s3Client = Aws\S3\S3Client::factory([
      'version'     => 'latest',
      'endpoint'    => 'https://s3.' . $system['wasabi_region'] . '.wasabisys.com',
      'region'      => $system['wasabi_region'],
      'credentials' => [
        'key'     => $system['wasabi_key'],
        'secret'  => $system['wasabi_secret'],
      ]
    ]);
    $buckets = $s3Client->listBuckets();
    if (empty($buckets)) {
      throw new Exception(__("There is no buckets in your account"));
    }
    if (!$s3Client->doesBucketExist($system['wasabi_bucket'])) {
      throw new Exception(__("There is no bucket with this name in your account"));
    }
  } catch (Exception $e) {
    if (DEBUGGING) {
      throw new Exception($e->getMessage());
    } else {
      throw new Exception(__("Connection Failed, Please check your settings"));
    }
  }
}


/**
 * wasabi_upload
 *
 * @param string $file_source
 * @param string $file_name
 * @param string $content_type
 * @return void
 */
function wasabi_upload($file_source, $file_name, $content_type = "")
{
  global $system;
  $s3Client = Aws\S3\S3Client::factory([
    'version'     => 'latest',
    'endpoint'    => 'https://s3.' . $system['wasabi_region'] . '.wasabisys.com',
    'region'      => $system['wasabi_region'],
    'credentials' => [
      'key'     => $system['wasabi_key'],
      'secret'  => $system['wasabi_secret'],
    ]
  ]);
  $Key = 'uploads/' . $file_name;
  $s3Client->putObject([
    'Bucket' => $system['wasabi_bucket'],
    'Key'    => $Key,
    'Body'   => fopen($file_source, 'r+'),
    'ContentDisposition' => 'inline',
    'ContentType' => $content_type,
    'ACL'    => 'public-read',
  ]);
  /* remove local file */
  gc_collect_cycles();
  if ($s3Client->doesObjectExist($system['wasabi_bucket'], $Key)) {
    unlink($file_source);
  }
}


/**
 * backblaze_test
 *
 * @return void
 */
function backblaze_test()
{
  global $system;
  try {
    $s3Client = Aws\S3\S3Client::factory([
      'version'     => 'latest',
      'endpoint'    => 'https://s3.' . $system['backblaze_region'] . '.backblazeb2.com',
      'region'      => $system['backblaze_region'],
      'credentials' => [
        'key'     => $system['backblaze_key'],
        'secret'  => $system['backblaze_secret'],
      ]
    ]);
    $buckets = $s3Client->listBuckets();
    if (empty($buckets)) {
      throw new Exception(__("There is no buckets in your account"));
    }
    if (!$s3Client->doesBucketExist($system['backblaze_bucket'])) {
      throw new Exception(__("There is no bucket with this name in your account"));
    }
  } catch (Exception $e) {
    if (DEBUGGING) {
      throw new Exception($e->getMessage());
    } else {
      throw new Exception(__("Connection Failed, Please check your settings"));
    }
  }
}


/**
 * backblaze_upload
 *
 * @param string $file_source
 * @param string $file_name
 * @param string $content_type
 * @return void
 */
function backblaze_upload($file_source, $file_name, $content_type = "")
{
  global $system;
  $s3Client = Aws\S3\S3Client::factory([
    'version'     => 'latest',
    'endpoint'    => 'https://s3.' . $system['backblaze_region'] . '.backblazeb2.com',
    'region'      => $system['backblaze_region'],
    'credentials' => [
      'key'     => $system['backblaze_key'],
      'secret'  => $system['backblaze_secret'],
    ]
  ]);
  $middleware = \Aws\Middleware::mapRequest(function (\Psr\Http\Message\RequestInterface $request) {
    foreach ($request->getHeaders() as $name => $values) {
      if (stripos($name, 'x-amz-checksum') === 0) {
        $request = $request->withoutHeader($name);
      }
    }
    return $request;
  });
  $s3Client->getHandlerList()->appendBuild($middleware, 'strip_checksum_headers');
  $Key = 'uploads/' . $file_name;
  $result = $s3Client->putObject([
    'Bucket' => $system['backblaze_bucket'],
    'Key'    => $Key,
    'Body'   => fopen($file_source, 'r+'),
    'ContentDisposition' => 'inline',
    'ContentType' => $content_type,
    'ACL'    => 'public-read',
  ]);
  /* remove local file */
  gc_collect_cycles();
  if ($s3Client->doesObjectExist($system['backblaze_bucket'], $Key)) {
    unlink($file_source);
  }
}


/**
 * yandex_cloud_test
 *
 * @return void
 */
function yandex_cloud_test()
{
  global $system;
  try {
    $s3Client = Aws\S3\S3Client::factory(array(
      'version'     => 'latest',
      'endpoint'    => 'https://s3.yandexcloud.net/',
      'region'      => $system['yandex_cloud_region'],
      'credentials' => array(
        'key'     => $system['yandex_cloud_key'],
        'secret'  => $system['yandex_cloud_secret'],
      )
    ));
    $buckets = $s3Client->listBuckets();
    if (empty($buckets)) {
      throw new Exception(__("There is no buckets in your account"));
    }
    if (!$s3Client->doesBucketExist($system['yandex_cloud_bucket'], $Key)) {
      throw new Exception(__("There is no bucket with this name in your account"));
    }
  } catch (Exception $e) {
    if (DEBUGGING) {
      throw new Exception($e->getMessage());
    } else {
      throw new Exception(__("Connection Failed, Please check your settings"));
    }
  }
}


/**
 * yandex_cloud_upload
 *
 * @param string $file_source
 * @param string $file_name
 * @param string $content_type
 * @return void
 */
function yandex_cloud_upload($file_source, $file_name, $content_type = "")
{
  global $system;
  $s3Client = Aws\S3\S3Client::factory(array(
    'version'     => 'latest',
    'endpoint'    => 'https://s3.yandexcloud.net/',
    'region'      => $system['yandex_cloud_region'],
    'credentials' => array(
      'key'     => $system['yandex_cloud_key'],
      'secret'  => $system['yandex_cloud_secret'],
    )
  ));
  $Key = 'uploads/' . $file_name;
  $s3Client->putObject([
    'Bucket' => $system['yandex_cloud_bucket'],
    'Key'    => $Key,
    'Body'   => fopen($file_source, 'r+'),
    'ContentDisposition' => 'inline',
    'ContentType' => $content_type,
    'ACL'    => 'public-read',
  ]);
  /* remove local file */
  gc_collect_cycles();
  if ($s3Client->doesObjectExist($system['yandex_cloud_bucket'], $Key)) {
    unlink($file_source);
  }
}


/**
 * cloudflare_r2_test
 *
 * @return void
 */
function cloudflare_r2_test()
{
  global $system;
  try {
    $s3Client = Aws\S3\S3Client::factory([
      'version'     => 'latest',
      'endpoint'    => $system['cloudflare_r2_endpoint'],
      'region' => 'auto',
      'credentials' => [
        'key'     => $system['cloudflare_r2_key'],
        'secret'  => $system['cloudflare_r2_secret'],
      ]
    ]);
    $buckets = $s3Client->listBuckets();
    if (empty($buckets)) {
      throw new Exception(__("There is no buckets in your account"));
    }
    if (!$s3Client->doesBucketExist($system['cloudflare_r2_bucket'])) {
      throw new Exception(__("There is no bucket with this name in your account"));
    }
  } catch (Exception $e) {
    if (DEBUGGING) {
      throw new Exception($e->getMessage());
    } else {
      throw new Exception(__("Connection Failed, Please check your settings"));
    }
  }
}


/**
 * cloudflare_r2_upload
 *
 * @param string $file_source
 * @param string $file_name
 * @param string $content_type
 * @return void
 */

function cloudflare_r2_upload($file_source, $file_name, $content_type = "")
{
  global $system;
  $s3Client = Aws\S3\S3Client::factory([
    'version'     => 'latest',
    'endpoint'    => $system['cloudflare_r2_endpoint'],
    'region' => 'auto',
    'credentials' => [
      'key'     => $system['cloudflare_r2_key'],
      'secret'  => $system['cloudflare_r2_secret'],
    ]
  ]);
  $Key = 'uploads/' . $file_name;
  $s3Client->putObject([
    'Bucket' => $system['cloudflare_r2_bucket'],
    'Key'    => $Key,
    'Body'   => fopen($file_source, 'r+'),
    'ContentDisposition' => 'inline',
    'ContentType' => $content_type,
    'ACL'    => 'public-read',
  ]);
  /* remove local file */
  gc_collect_cycles();
  if ($s3Client->doesObjectExist($system['cloudflare_r2_bucket'], $Key)) {
    unlink($file_source);
  }
}


/**
 * pushr_test
 *
 * @return void
 */
function pushr_test()
{
  global $system;
  try {
    $s3Client = Aws\S3\S3Client::factory([
      'version'     => 'latest',
      'endpoint'    => $system['pushr_endpoint'],
      'region' => 'auto',
      'credentials' => [
        'key'     => $system['pushr_key'],
        'secret'  => $system['pushr_secret'],
      ]
    ]);
    $buckets = $s3Client->listBuckets();
    if (empty($buckets)) {
      throw new Exception(__("There is no buckets in your account"));
    }
    if (!$s3Client->doesBucketExist($system['pushr_bucket'])) {
      throw new Exception(__("There is no bucket with this name in your account"));
    }
  } catch (Exception $e) {
    if (DEBUGGING) {
      throw new Exception($e->getMessage());
    } else {
      throw new Exception(__("Connection Failed, Please check your settings"));
    }
  }
}


/**
 * pushr_upload
 *
 * @param string $file_source
 * @param string $file_name
 * @param string $content_type
 * @return void
 */

function pushr_upload($file_source, $file_name, $content_type = "")
{
  global $system;
  $s3Client = Aws\S3\S3Client::factory([
    'version'     => 'latest',
    'endpoint'    => $system['pushr_endpoint'],
    'region' => 'auto',
    'credentials' => [
      'key'     => $system['pushr_key'],
      'secret'  => $system['pushr_secret'],
    ]
  ]);
  $Key = 'uploads/' . $file_name;
  $s3Client->putObject([
    'Bucket' => $system['pushr_bucket'],
    'Key'    => $Key,
    'Body'   => fopen($file_source, 'r+'),
    'ContentDisposition' => 'inline',
    'ContentType' => $content_type,
    'ACL'    => 'public-read',
  ]);
  /* remove local file */
  gc_collect_cycles();
  if ($s3Client->doesObjectExist($system['pushr_bucket'], $Key)) {
    unlink($file_source);
  }
}


/**
 * ftp_test
 *
 * @return void
 */
function ftp_test()
{
  global $system;
  try {
    $ftp = new \FtpClient\FtpClient();
    $ftp->connect($system['ftp_hostname'], false, $system['ftp_port']);
    $ftp->login($system['ftp_username'], $system['ftp_password']);
  } catch (Exception $e) {
    if (DEBUGGING) {
      throw new Exception($e->getMessage());
    } else {
      throw new Exception(__("Connection Failed, Please check your settings"));
    }
  }
}


/**
 * ftp_upload
 *
 * @param string $file_source
 * @param string $file_name
 * @return void
 */
function ftp_upload($file_source, $file_name)
{
  global $system;
  $ftp = new \FtpClient\FtpClient();
  $ftp->connect($system['ftp_hostname'], false, $system['ftp_port']);
  $ftp->login($system['ftp_username'], $system['ftp_password']);
  if (!empty($system['ftp_path']) && $system['ftp_path'] != "./") {
    $ftp->chdir($system['ftp_path']);
  }
  $file_path = substr($file_name, 0, strrpos($file_name, '/'));
  $ftp_path_info = explode('/', $file_path);
  $ftp_path = '';
  if (!$ftp->isDir($file_path)) {
    foreach ($ftp_path_info as $key => $value) {
      if (!empty($ftp_path)) {
        $ftp_path .= '/' . $value . '/';
      } else {
        $ftp_path .= $value . '/';
      }
      if (!$ftp->isDir($ftp_path)) {
        $mkdir = $ftp->mkdir($ftp_path);
      }
    }
  }
  $ftp->chdir($file_path);
  $ftp->pasv(true);
  if ($ftp->putFromPath($file_source, $file_name)) {
    unlink($file_source);
  }
  $ftp->close();
}


/**
 * delete_uploads_file
 *
 * @param string $file_name
 * @param bool $bypass_db_check
 * @return void
 */
function delete_uploads_file($file_name, $bypass_db_check = true)
{
  global $system, $db;
  if (!$file_name) {
    return;
  }
  /* delete from pending uploads */
  remove_pending_uploads([$file_name]);
  /* delete from database */
  if (!$bypass_db_check) {
    $check_upload = $db->query(sprintf("SELECT COUNT(*) AS count FROM users_uploads WHERE file_name = %s", secure($file_name)));
    if ($check_upload->fetch_assoc()['count'] > 0) {
      $db->query(sprintf("DELETE FROM users_uploads WHERE file_name = %s", secure($file_name)));
    }
  }
  /* delete from server */
  if ($system['s3_enabled']) {
    /* Amazon S3 */
    $s3Client = Aws\S3\S3Client::factory([
      'version'    => 'latest',
      'region'      => $system['s3_region'],
      'credentials' => [
        'key'    => $system['s3_key'],
        'secret' => $system['s3_secret'],
      ]
    ]);
    $Key = 'uploads/' . $file_name;
    if ($s3Client->doesObjectExist($system['s3_bucket'], $Key)) {
      $s3Client->deleteObject([
        'Bucket' => $system['s3_bucket'],
        'Key'    => $Key,
      ]);
    }
  } elseif ($system['google_cloud_enabled']) {
    /* Google Cloud */
    $storage = new Google\Cloud\Storage\StorageClient([
      'keyFile' => json_decode(html_entity_decode($system['google_cloud_file'], ENT_QUOTES), true),
    ]);
    $bucket = $storage->bucket($system['google_cloud_bucket']);
    $Key = 'uploads/' . $file_name;
    $object = $bucket->object($Key);
    if ($object->exists()) {
      $object->delete();
    }
  } elseif ($system['digitalocean_enabled']) {
    /* DigitalOcean */
    $s3Client = Aws\S3\S3Client::factory([
      'version'     => 'latest',
      'endpoint'    => 'https://' . $system['digitalocean_space_region'] . '.digitaloceanspaces.com',
      'region'      => $system['digitalocean_space_region'],
      'credentials' => [
        'key'     => $system['digitalocean_key'],
        'secret'  => $system['digitalocean_secret'],
      ]
    ]);
    $Key = 'uploads/' . $file_name;
    if ($s3Client->doesObjectExist($system['digitalocean_space_name'], $Key)) {
      $s3Client->deleteObject([
        'Bucket' => $system['digitalocean_space_name'],
        'Key'    => $Key,
      ]);
    }
  } elseif ($system['wasabi_enabled']) {
    /* Wasabi */
    $s3Client = Aws\S3\S3Client::factory([
      'version'     => 'latest',
      'endpoint'    => 'https://s3.' . $system['wasabi_region'] . '.wasabisys.com',
      'region'      => $system['wasabi_region'],
      'credentials' => [
        'key'     => $system['wasabi_key'],
        'secret'  => $system['wasabi_secret'],
      ]
    ]);
    $Key = 'uploads/' . $file_name;
    if ($s3Client->doesObjectExist($system['wasabi_bucket'], $Key)) {
      $s3Client->deleteObject([
        'Bucket' => $system['wasabi_bucket'],
        'Key'    => $Key,
      ]);
    }
  } elseif ($system['backblaze_enabled']) {
    /* Backblaze */
    $s3Client = Aws\S3\S3Client::factory([
      'version'     => 'latest',
      'endpoint'    => 'https://s3.' . $system['backblaze_region'] . '.backblazeb2.com',
      'region'      => $system['backblaze_region'],
      'credentials' => [
        'key'     => $system['backblaze_key'],
        'secret'  => $system['backblaze_secret'],
      ]
    ]);
    $Key = 'uploads/' . $file_name;
    if ($s3Client->doesObjectExist($system['backblaze_bucket'], $Key)) {
      $s3Client->deleteObject([
        'Bucket' => $system['backblaze_bucket'],
        'Key'    => $Key,
        'DeleteMarker' => 'true'
      ]);
    }
  } elseif ($system['yandex_cloud_enabled']) {
    /* Yandex Cloud */
    $s3Client = Aws\S3\S3Client::factory(array(
      'version'     => 'latest',
      'endpoint'    => 'https://s3.yandexcloud.net/',
      'region'      => $system['yandex_cloud_region'],
      'credentials' => array(
        'key'     => $system['yandex_cloud_key'],
        'secret'  => $system['yandex_cloud_secret'],
      )
    ));
    $Key = 'uploads/' . $file_name;
    if ($s3Client->doesObjectExist($system['yandex_cloud_bucket'], $Key)) {
      $s3Client->deleteObject([
        'Bucket' => $system['yandex_cloud_bucket'],
        'Key'    => $Key,
      ]);
    }
  } elseif ($system['cloudflare_r2_enabled']) {
    /* Cloudflare R2 */
    $s3Client = Aws\S3\S3Client::factory([
      'version'     => 'latest',
      'endpoint'    => $system['cloudflare_r2_endpoint'],
      'region' => 'auto',
      'credentials' => [
        'key'     => $system['cloudflare_r2_key'],
        'secret'  => $system['cloudflare_r2_secret'],
      ]
    ]);
    $Key = 'uploads/' . $file_name;
    if ($s3Client->doesObjectExist($system['cloudflare_r2_bucket'], $Key)) {
      $s3Client->deleteObject([
        'Bucket' => $system['cloudflare_r2_bucket'],
        'Key'    => $Key,
      ]);
    }
  } elseif ($system['pushr_enabled']) {
    /* Pushr */
    $s3Client = Aws\S3\S3Client::factory([
      'version'     => 'latest',
      'endpoint'    => $system['pushr_endpoint'],
      'region' => 'auto',
      'credentials' => [
        'key'     => $system['pushr_key'],
        'secret'  => $system['pushr_secret'],
      ]
    ]);
    $Key = 'uploads/' . $file_name;
    if ($s3Client->doesObjectExist($system['pushr_bucket'], $Key)) {
      $s3Client->deleteObject([
        'Bucket' => $system['pushr_bucket'],
        'Key'    => $Key,
      ]);
    }
  } elseif ($system['ftp_enabled']) {
    /* FTP */
    $ftp = new \FtpClient\FtpClient();
    $ftp->connect($system['ftp_hostname'], false, $system['ftp_port']);
    $ftp->login($system['ftp_username'], $system['ftp_password']);
    if (!empty($system['ftp_path']) && $system['ftp_path'] != "./") {
      $ftp->chdir($system['ftp_path']);
    }
    $file_path = substr($file_name, 0, strrpos($file_name, '/'));
    $file_name = substr($file_name, strrpos($file_name, '/') + 1);
    if (!$ftp->isDir($file_path)) {
      return;
    }
    $ftp->chdir($file_path);
    $ftp->pasv(true);
    $ftp->remove($file_name);
    $ftp->close();
  } else {
    /* local server */
    $realpath = realpath(ABSPATH . $system['uploads_directory'] . '/' . $file_name);
    if (is_file($realpath) && file_exists($realpath)) {
      unlink($realpath);
    }
  }
}


/**
 * save_file_to_cloud
 *
 * @param string $path
 * @param string $file_name
 * @return void
 */

function save_file_to_cloud($path, $file_name)
{
  global $system;
  /* Cloud Storage */
  if ($system['s3_enabled']) {
    /* Amazon S3 */
    aws_s3_upload($path, $file_name);
  } elseif ($system['google_cloud_enabled']) {
    /* Google Cloud */
    google_cloud_upload($path, $file_name);
  } elseif ($system['digitalocean_enabled']) {
    /* DigitalOcean */
    digitalocean_space_upload($path, $file_name);
  } elseif ($system['wasabi_enabled']) {
    /* Wasabi */
    wasabi_upload($path, $file_name);
  } elseif ($system['backblaze_enabled']) {
    /* Backblaze */
    backblaze_upload($path, $file_name);
  } elseif ($system['yandex_cloud_enabled']) {
    /* Yandex Cloud */
    yandex_cloud_upload($path, $file_name);
  } elseif ($system['cloudflare_r2_enabled']) {
    /* Cloudflare R2 */
    cloudflare_r2_upload($path, $file_name);
  } elseif ($system['pushr_enabled']) {
    /* Pushr */
    pushr_upload($path, $file_name);
  } elseif ($system['ftp_enabled']) {
    /* FTP */
    ftp_upload($path, $file_name);
  }
}



/* ------------------------------- */
/* FFMPEG */
/* ------------------------------- */

/**
 * ffmpeg_test
 *
 * @return string
 */

function ffmpeg_test()
{
  global $system;
  /* check ffmpeg settings */
  if (!function_exists('shell_exec')) {
    throw new Exception(__("shell_exec function must be enabled for FFMPEG"));
  }
  if (!$system['ffmpeg_enabled']) {
    throw new Exception(__("FFMPEG must be enable before testing"));
  }
  if ($system['ffmpeg_path'] == "") {
    throw new Exception(__("FFMPEG path must be defined before testing"));
  }
  /* prepare */
  $input_video = ABSPATH . "includes/assets/videos/ffmpeg_test.mp4";
  $output_video = ABSPATH . "includes/assets/videos/ffmpeg_test_240.mp4";
  @unlink($output_video);
  $shell_response = shell_exec($system['ffmpeg_path'] . " -y -i $input_video -vcodec libx264 -preset " . $system['ffmpeg_speed'] . " -filter:v scale=426:-2 -crf 26 $output_video 2>&1");
  if (!file_exists($output_video)) {
    throw new Exception(__("FFMPEG Error") . ": " . $shell_response);
  }
  return $shell_response;
}

/**
 * ffmpeg_convert
 *
 * @param integer $post_id
 * @param integer $post_author_id
 * @param string $video_name
 * @param string $thumbnail
 * @return void
 */

function ffmpeg_convert($post_id, $post_author_id, $video_name, $thumbnail = '', $post_type = 'video')
{
  global $system, $db, $user;
  /* check ffmpeg settings */
  if (!function_exists('shell_exec')) {
    throw new Exception(__("shell_exec function must be enabled for FFMPEG"));
  }
  if (!$system['ffmpeg_enabled']) {
    throw new Exception(__("FFMPEG must be enable before testing"));
  }
  if ($system['ffmpeg_path'] == "") {
    throw new Exception(__("FFMPEG path must be defined before testing"));
  }
  /* prepare posts table name */
  $posts_table = ($post_type == 'reel') ? 'posts_reels' : 'posts_videos';
  /* prepare uploads folder as staging */
  $photos_folder = 'photos';
  $photos_directory = $photos_folder . '/' . date('Y') . '/' . date('m') . '/';
  if (!file_exists(ABSPATH . $system['uploads_directory'] . '/' . $photos_folder)) {
    @mkdir(ABSPATH . $system['uploads_directory'] . '/' . $photos_folder, 0777, true);
  }
  if (!file_exists(ABSPATH . $system['uploads_directory'] . '/' . $photos_folder . '/' . date('Y'))) {
    @mkdir(ABSPATH . $system['uploads_directory'] . '/' . $photos_folder . '/' . date('Y'), 0777, true);
  }
  if (!file_exists($system['uploads_directory'] . '/' . $photos_folder . '/' . date('Y') . '/' . date('m'))) {
    @mkdir(ABSPATH . $system['uploads_directory'] . '/' . $photos_folder . '/' . date('Y') . '/' . date('m'), 0777, true);
  }
  $videos_folder = 'videos';
  $videos_directory = $videos_folder . '/' . date('Y') . '/' . date('m') . '/';
  if (!file_exists(ABSPATH . $system['uploads_directory'] . '/' . $videos_folder)) {
    @mkdir(ABSPATH . $system['uploads_directory'] . '/' . $videos_folder, 0777, true);
  }
  if (!file_exists(ABSPATH . $system['uploads_directory'] . '/' . $videos_folder . '/' . date('Y'))) {
    @mkdir(ABSPATH . $system['uploads_directory'] . '/' . $videos_folder . '/' . date('Y'), 0777, true);
  }
  if (!file_exists($system['uploads_directory'] . '/' . $videos_folder . '/' . date('Y') . '/' . date('m'))) {
    @mkdir(ABSPATH . $system['uploads_directory'] . '/' . $videos_folder . '/' . date('Y') . '/' . date('m'), 0777, true);
  }
  /* save original video */
  $original_video_local_path = ABSPATH . $system['uploads_directory'] . '/' . $video_name;
  $delete_fetched_file = false;
  if (!file_exists($original_video_local_path)) {
    $delete_fetched_file = true;
    $remote_file = fopen($system['system_uploads'] . '/' . $video_name, 'rb');
    $local_file = fopen($original_video_local_path, 'wb');
    if ($remote_file && $local_file) {
      while (!feof($remote_file)) {
        fwrite($local_file, fread($remote_file, 8192));
      }
      fclose($remote_file);
      fclose($local_file);
    } else {
      /* update post & return */
      $db->query(sprintf("UPDATE posts SET processing = '0' WHERE post_id = %s", secure($post_id, 'int')));
      return;
    }
  }
  /* set ffprobe_path */
  $system['ffprobe_path'] = substr_replace($system['ffmpeg_path'], 'ffprobe', strrpos($system['ffmpeg_path'], 'ffmpeg'), strlen('ffmpeg'));
  /* get original video resolution */
  $resolution = 0;
  $resolution = shell_exec($system['ffprobe_path'] . " -v error -select_streams v:0 -show_entries stream=width -of csv=s=x:p=0 " . $original_video_local_path);
  /* get original video duration */
  $duration = 1;
  $duration = shell_exec($system['ffprobe_path'] . " -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 " . $original_video_local_path);
  /* generate new video thumbnail */
  if (!$thumbnail) {
    $thumbnail_prefix = $system['uploads_prefix'] . '_' . get_hash_token();
    $thumbnail_name = $photos_directory . $thumbnail_prefix . '.jpeg';
    $thumbnail_path = ABSPATH . $system['uploads_directory'] . '/' . $thumbnail_name;
    $extraction_time = ($duration > 1) ? ($duration / 2) : 1;
    if (!file_exists($thumbnail_path)) {
      shell_exec($system['ffmpeg_path'] . " -ss \"$extraction_time\" -i $original_video_local_path -vframes 1 -f mjpeg $thumbnail_path 2<&1");
      /* save the new video thumbnail to cloud */
      save_file_to_cloud($thumbnail_path, $thumbnail_name);
      /* update video thumbnail */
      $db->query(sprintf("UPDATE $posts_table SET thumbnail = %s WHERE post_id = %s", secure($thumbnail_name), secure($post_id, 'int')));
    }
  }
  /* get original hash */
  $original_hash = extarct_hash_token($video_name);
  /* set video prefix */
  $video_prefix = $system['uploads_prefix'] . '_' . $original_hash;
  /* check watermark videos enabled */
  $watermark_cmd = "";
  if ($system['watermark_videos_enabled']) {
    /* get water mark settings */
    $watermark_videos_icon = ABSPATH . $system['uploads_directory'] . '/' . $system['watermark_videos_icon'];
    /* check if the watermark icon exists */
    if (!file_exists($watermark_videos_icon)) {
      /* fetch the watermark icon */
      $remote_watermark_icon = fopen($system['system_uploads'] . '/' . $system['watermark_videos_icon'], 'rb');
      $local_watermark_icon = fopen($watermark_videos_icon, 'wb');
      if ($remote_watermark_icon && $local_watermark_icon) {
        while (!feof($remote_watermark_icon)) {
          fwrite($local_watermark_icon, fread($remote_watermark_icon, 8192));
        }
        fclose($remote_watermark_icon);
        fclose($local_watermark_icon);
      }
    }
    switch ($system['watermark_videos_position']) {
      case 'top_left':
        $watermark_videos_position = sprintf("%s:%s", $system['watermark_videos_xoffset'], $system['watermark_videos_yoffset']);
        break;

      case 'top_right':
        $watermark_videos_position = sprintf("main_w-overlay_w-%s:%s", $system['watermark_videos_xoffset'], $system['watermark_videos_yoffset']);
        break;

      case 'bottom_left':
        $watermark_videos_position = sprintf("%s:main_h-overlay_h-%s", $system['watermark_videos_xoffset'], $system['watermark_videos_yoffset']);
        break;

      case 'bottom_right':
        $watermark_videos_position = sprintf("main_w-overlay_w-%s:main_h-overlay_h-%s", $system['watermark_videos_xoffset'], $system['watermark_videos_yoffset']);
        break;

      case 'center':
        $watermark_videos_position = sprintf("(main_w-overlay_w)/2:(main_h-overlay_h)/2");
        break;
    }
    $watermark_cmd = sprintf("-i %s -i %s -filter_complex \"[1:v]scale=iw:ih [watermark]; [watermark]format=argb,colorchannelmixer=aa=%s [watermark]; [0:v][watermark] overlay=%s\" -c:a copy", $watermark_videos_icon, $original_video_local_path, $system['watermark_videos_opacity'], $watermark_videos_position);
  }
  /* convert video to 240p */
  $video_240p_name = $videos_directory . $video_prefix . '_240p.mp4';
  $video_240_local_path = ABSPATH . $system['uploads_directory'] . '/' . $video_240p_name;
  if ($system['ffmpeg_240p_enabled'] && !file_exists($video_240_local_path) && $resolution >= 426) {
    shell_exec($system['ffmpeg_path'] . " -y -i $original_video_local_path -vcodec libx264 -preset " . $system['ffmpeg_speed'] . " -filter:v scale=426:-2 -crf 26 $video_240_local_path 2<&1");
    if ($watermark_cmd) {
      $video_240p_marked_name = $videos_directory . $video_prefix . '_marked_240p.mp4';
      $video_240_marked_local_path = ABSPATH . $system['uploads_directory'] . '/' . $video_240p_marked_name;
      shell_exec($system['ffmpeg_path'] . " -y -i $video_240_local_path $watermark_cmd $video_240_marked_local_path 2<&1");
      if (file_exists($video_240_marked_local_path)) {
        /* remove local file */
        unlink($video_240_local_path);
        $video_240p_name = $video_240p_marked_name;
        $video_240_local_path = $video_240_marked_local_path;
      }
    }
    /* save the new video to cloud */
    save_file_to_cloud($video_240_local_path, $video_240p_name);
    /* update video */
    $db->query(sprintf("UPDATE $posts_table SET source_240p = %s WHERE post_id = %s", secure($video_240p_name), secure($post_id, 'int')));
  }
  /* convert video to 360p */
  $video_360p_name = $videos_directory . $video_prefix . '_360p.mp4';
  $video_360_local_path = ABSPATH . $system['uploads_directory'] . '/' . $video_360p_name;
  if ($system['ffmpeg_360p_enabled'] && !file_exists($video_360_local_path) && $resolution >= 640) {
    shell_exec($system['ffmpeg_path'] . " -y -i $original_video_local_path -vcodec libx264 -preset " . $system['ffmpeg_speed'] . " -filter:v scale=640:-2 -crf 26 $video_360_local_path 2<&1");
    if ($watermark_cmd) {
      $video_360p_marked_name = $videos_directory . $video_prefix . '_marked_360p.mp4';
      $video_360_marked_local_path = ABSPATH . $system['uploads_directory'] . '/' . $video_360p_marked_name;
      shell_exec($system['ffmpeg_path'] . " -y -i $video_360_local_path $watermark_cmd $video_360_marked_local_path 2<&1");
      if (file_exists($video_360_marked_local_path)) {
        /* remove local file */
        unlink($video_360_local_path);
        $video_360p_name = $video_360p_marked_name;
        $video_360_local_path = $video_360_marked_local_path;
      }
    }
    /* save the new video to cloud */
    save_file_to_cloud($video_360_local_path, $video_360p_name);
    /* update video */
    $db->query(sprintf("UPDATE $posts_table SET source_360p = %s WHERE post_id = %s", secure($video_360p_name), secure($post_id, 'int')));
  }
  /* convert video to 480p */
  $video_480p_name = $videos_directory . $video_prefix . '_480p.mp4';
  $video_480_local_path = ABSPATH . $system['uploads_directory'] . '/' . $video_480p_name;
  if ($system['ffmpeg_480p_enabled'] && !file_exists($video_480_local_path) && $resolution >= 854) {
    shell_exec($system['ffmpeg_path'] . " -y -i $original_video_local_path -vcodec libx264 -preset " . $system['ffmpeg_speed'] . " -filter:v scale=854:-2 -crf 26 $video_480_local_path 2<&1");
    if ($watermark_cmd) {
      $video_480p_marked_name = $videos_directory . $video_prefix . '_marked_480p.mp4';
      $video_480_marked_local_path = ABSPATH . $system['uploads_directory'] . '/' . $video_480p_marked_name;
      shell_exec($system['ffmpeg_path'] . " -y -i $video_480_local_path $watermark_cmd $video_480_marked_local_path 2<&1");
      if (file_exists($video_480_marked_local_path)) {
        /* remove local file */
        unlink($video_480_local_path);
        $video_480p_name = $video_480p_marked_name;
        $video_480_local_path = $video_480_marked_local_path;
      }
    }
    /* save the new video to cloud */
    save_file_to_cloud($video_480_local_path, $video_480p_name);
    /* update video */
    $db->query(sprintf("UPDATE $posts_table SET source_480p = %s WHERE post_id = %s", secure($video_480p_name), secure($post_id, 'int')));
  }
  /* convert video to 720p */
  $video_720p_name = $videos_directory . $video_prefix . '_720p.mp4';
  $video_720_local_path = ABSPATH . $system['uploads_directory'] . '/' . $video_720p_name;
  if ($system['ffmpeg_720p_enabled'] && !file_exists($video_720_local_path) && $resolution >= 1280) {
    shell_exec($system['ffmpeg_path'] . " -y -i $original_video_local_path -vcodec libx264 -preset " . $system['ffmpeg_speed'] . " -filter:v scale=1280:-2 -crf 26 $video_720_local_path 2<&1");
    if ($watermark_cmd) {
      $video_720p_marked_name = $videos_directory . $video_prefix . '_marked_720p.mp4';
      $video_720_marked_local_path = ABSPATH . $system['uploads_directory'] . '/' . $video_720p_marked_name;
      shell_exec($system['ffmpeg_path'] . " -y -i $video_720_local_path $watermark_cmd $video_720_marked_local_path 2<&1");
      if (file_exists($video_720_marked_local_path)) {
        /* remove local file */
        unlink($video_720_local_path);
        $video_720p_name = $video_720p_marked_name;
        $video_720_local_path = $video_720_marked_local_path;
      }
    }
    /* save the new video to cloud */
    save_file_to_cloud($video_720_local_path, $video_720p_name);
    /* update video */
    $db->query(sprintf("UPDATE $posts_table SET source_720p = %s WHERE post_id = %s", secure($video_720p_name), secure($post_id, 'int')));
  }
  /* convert video to 1080p */
  $video_1080p_name = $videos_directory . $video_prefix . '_1080p.mp4';
  $video_1080_local_path = ABSPATH . $system['uploads_directory'] . '/' . $video_1080p_name;
  if ($system['ffmpeg_1080p_enabled'] && !file_exists($video_1080_local_path) && $resolution >= 1920) {
    shell_exec($system['ffmpeg_path'] . " -y -i $original_video_local_path -vcodec libx264 -preset " . $system['ffmpeg_speed'] . " -filter:v scale=1920:-2 -crf 26 $video_1080_local_path 2<&1");
    if ($watermark_cmd) {
      $video_1080p_marked_name = $videos_directory . $video_prefix . '_marked_1080p.mp4';
      $video_1080_marked_local_path = ABSPATH . $system['uploads_directory'] . '/' . $video_1080p_marked_name;
      shell_exec($system['ffmpeg_path'] . " -y -i $video_1080_local_path $watermark_cmd $video_1080_marked_local_path 2<&1");
      if (file_exists($video_1080_marked_local_path)) {
        /* remove local file */
        unlink($video_1080_local_path);
        $video_1080p_name = $video_1080p_marked_name;
        $video_1080_local_path = $video_1080_marked_local_path;
      }
    }
    /* save the new video to cloud */
    save_file_to_cloud($video_1080_local_path, $video_1080p_name);
    /* update video */
    $db->query(sprintf("UPDATE $posts_table SET source_1080p = %s WHERE post_id = %s", secure($video_1080p_name), secure($post_id, 'int')));
  }
  /* convert video to 1440p */
  $video_1440p_name = $videos_directory . $video_prefix . '_1440p.mp4';
  $video_1440_local_path = ABSPATH . $system['uploads_directory'] . '/' . $video_1440p_name;
  if ($system['ffmpeg_1440p_enabled'] && !file_exists($video_1440_local_path) && $resolution >= 2560) {
    shell_exec($system['ffmpeg_path'] . " -y -i $original_video_local_path -vcodec libx264 -preset " . $system['ffmpeg_speed'] . " -filter:v scale=2560:-2 -crf 26 $video_1440_local_path 2<&1");
    if ($watermark_cmd) {
      $video_1440p_marked_name = $videos_directory . $video_prefix . '_marked_1440p.mp4';
      $video_1440_marked_local_path = ABSPATH . $system['uploads_directory'] . '/' . $video_1440p_marked_name;
      shell_exec($system['ffmpeg_path'] . " -y -i $video_1440_local_path $watermark_cmd $video_1440_marked_local_path 2<&1");
      if (file_exists($video_1440_marked_local_path)) {
        /* remove local file */
        unlink($video_1440_local_path);
        $video_1440p_name = $video_1440p_marked_name;
        $video_1440_local_path = $video_1440_marked_local_path;
      }
    }
    /* save the new video to cloud */
    save_file_to_cloud($video_1440_local_path, $video_1440p_name);
    /* update video */
    $db->query(sprintf("UPDATE $posts_table SET source_1440p = %s WHERE post_id = %s", secure($video_1440p_name), secure($post_id, 'int')));
  }
  /* convert video to 2160p */
  $video_2160p_name = $videos_directory . $video_prefix . '_2160p.mp4';
  $video_2160_local_path = ABSPATH . $system['uploads_directory'] . '/' . $video_2160p_name;
  if ($system['ffmpeg_2160p_enabled'] && !file_exists($video_2160_local_path) && $resolution >= 3840) {
    shell_exec($system['ffmpeg_path'] . " -y -i $original_video_local_path -vcodec libx264 -preset " . $system['ffmpeg_speed'] . " -filter:v scale=3840:-2 -crf 26 $video_2160_local_path 2<&1");
    if ($watermark_cmd) {
      $video_2160p_marked_name = $videos_directory . $video_prefix . '_marked_2160p.mp4';
      $video_2160_marked_local_path = ABSPATH . $system['uploads_directory'] . '/' . $video_2160p_marked_name;
      shell_exec($system['ffmpeg_path'] . " -y -i $video_2160_local_path $watermark_cmd $video_2160_marked_local_path 2<&1");
      if (file_exists($video_2160_marked_local_path)) {
        /* remove local file */
        unlink($video_2160_local_path);
        $video_2160p_name = $video_2160p_marked_name;
        $video_2160_local_path = $video_2160_marked_local_path;
      }
    }
    /* save the new video to cloud */
    save_file_to_cloud($video_2160_local_path, $video_2160p_name);
    /* update video */
    $db->query(sprintf("UPDATE $posts_table SET source_2160p = %s WHERE post_id = %s", secure($video_2160p_name), secure($post_id, 'int')));
  }
  /* remove fetched file (if any) */
  if ($delete_fetched_file) {
    unlink($original_video_local_path);
  }
  /* update post */
  $db->query(sprintf("UPDATE posts SET processing = '0' WHERE post_id = %s", secure($post_id, 'int')));
  /* notify post author */
  $user->post_notification(['to_user_id' => $post_author_id, 'action' => 'video_converted', 'node_type' => 'post', 'node_url' => $post_id]);
}



/* ------------------------------- */
/* Payments */
/* ------------------------------- */

/**
 * get_payment_vat_percentage
 *
 * @return int
 */
function get_payment_vat_percentage()
{
  global $system, $user;
  $payment_vat_percentage = $system['payment_vat_percentage'];
  if ($system['payment_country_vat_enabled']) {
    $user_country = $user->get_country($user->_data['user_country']);
    if ($user_country && $user_country['country_vat']) {
      $payment_vat_percentage = $user_country['country_vat'];
    }
  }
  return $payment_vat_percentage;
}


/**
 * get_payment_vat_value
 *
 * @param float $amount
 * @param boolean $printed
 * @return float
 */
function get_payment_vat_value($amount, $printed = false)
{
  global $system;
  $vat = 0;
  if ($system['payment_vat_enabled']) {
    $payment_vat_percentage = get_payment_vat_percentage();
    $vat = ($amount * $payment_vat_percentage) / 100;
  }
  return ($printed) ? html_entity_decode(print_money($vat), ENT_QUOTES) : $vat;
}


/**
 * get_payment_fees_value
 *
 * @param float $amount
 * @param boolean $printed
 * @return float
 */
function get_payment_fees_value($amount, $printed = false)
{
  global $system;
  $fees = 0;
  if ($system['payment_fees_enabled']) {
    $fees = ($amount * $system['payment_fees_percentage']) / 100;
  }
  return ($printed) ? html_entity_decode(print_money($fees), ENT_QUOTES) : $fees;
}


/**
 * get_payment_total_value
 *
 * @param float $amount
 * @return float
 */
function get_payment_total_value($amount, $printed = false)
{
  $total = $amount + get_payment_vat_value($amount) + get_payment_fees_value($amount);
  $total = "" . round($total, 2);
  return ($printed) ? html_entity_decode(print_money($total), ENT_QUOTES) : $total;
}



/* ------------------------------- */
/* PayOuts */
/* ------------------------------- */

/**
 * process_automatic_withdrawal
 *
 * @param string $method
 * @param integer $amount
 * @param string $email
 * @return void
 */
function process_automatic_withdrawal($method, $amount, $email)
{
  global $system;
  switch ($method) {
    case 'paypal':
      if ($system['paypal_payouts_enabled']) {
        paypal_payout($amount, $email);
      }
      break;
    case 'moneypoolscash':
      if ($system['moneypoolscash_payouts_enabled']) {
        moneypoolscash_payout($amount, $email);
      }
      break;
  }
}



/* ------------------------------- */
/* PayPal */
/* ------------------------------- */

/**
 * paypal_access_token
 *
 * @return string
 */
function paypal_access_token()
{
  global $system;
  /* prepare API url */
  $paypal_api_url = ($system['paypal_mode'] == "sandbox") ? "https://api-m.sandbox.paypal.com" : "https://api.paypal.com";
  $ch = curl_init();
  curl_setopt($ch, CURLOPT_URL, $paypal_api_url . '/v1/oauth2/token');
  curl_setopt($ch, CURLOPT_HEADER, 0);
  curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type: application/x-www-form-urlencoded']);
  curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0);
  curl_setopt($ch, CURLOPT_POST, 1);
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
  curl_setopt($ch, CURLOPT_USERPWD, $system['paypal_id'] . ":" . $system['paypal_secret']);
  curl_setopt($ch, CURLOPT_POSTFIELDS, "grant_type=client_credentials");
  $response = curl_exec($ch);
  $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
  if (curl_errno($ch)) {
    throw new Exception("Error Processing Request");
  }
  curl_close($ch);
  $response = json_decode($response);
  if ($httpCode != 200) {
    $error = "Error Processing Request";
    if (DEBUGGING) {
      if ($response->error_description) {
        $error = $response->error_description;
      } elseif ($response->message) {
        $error = $response->message;
      } else {
        $backtrace = debug_backtrace();
        $line = $backtrace[0]['line'];
        $file = $backtrace[0]['file'];
        $error = "This error function was called from line $line in file $file";
      }
    }
    throw new Exception($error);
  }
  return $response->access_token;
}


/**
 * paypal_payment_link
 *
 * @param string $handle
 * @param float $price
 * @param integer $id
 * @return string
 */
function paypal_payment_link($handle, $price, $id = null)
{
  global $system, $user;
  /* prepare */
  $total = get_payment_total_value($price);
  switch ($handle) {
    case 'packages':
      /* get package */
      $package = $user->get_package($id);
      if ($package['paypal_billing_plan']) {
        return paypal_subscription_link($handle, $id, $package['paypal_billing_plan']);
      }
      $product = __($system['system_title']) . " " . __('Package') . " " . __($package['name']);
      $description = __('Pay For') . " " . __($system['system_title']) . " " . __('Package') . " " . __($package['name']);
      $URL['success'] = $system['system_url'] . "/webhooks/paypal.php?status=success&handle=packages&package_id=$id";
      $URL['cancel'] = $system['system_url'] . "/webhooks/paypal.php?status=cancel";
      break;

    case 'subscribe':
      /* get monetization plan */
      $monetization_plan = $user->get_monetization_plan($id, true);
      if (!$monetization_plan) {
        throw new Exception(__("The monetization plan you're trying to subscribe to is not found"));
      }
      if ($monetization_plan['paypal_billing_plan']) {
        return paypal_subscription_link($handle, $id, $monetization_plan['paypal_billing_plan']);
      }
      $product = __($system['system_title']) . " " . __('Monetization Plan') . " " . __($monetization_plan['name']);
      $description = __('Pay For') . " " . __($system['system_title']) . " " . __('Monetization Plan') . " " . __($monetization_plan['name']);
      $URL['success'] = $system['system_url'] . "/webhooks/paypal.php?status=success&handle=subscribe&plan_id=$id";
      $URL['cancel'] = $system['system_url'] . "/webhooks/paypal.php?status=cancel";
      break;

    case 'wallet':
      $product = __($system['system_title']) . " " . __('Wallet');
      $description = __('Pay For') . " " . __($system['system_title']);
      $URL['success'] = $system['system_url'] . "/webhooks/paypal.php?status=success&handle=wallet";
      $URL['cancel'] = $system['system_url'] . "/webhooks/paypal.php?status=cancel";
      $_SESSION['wallet_replenish_amount'] = $price;
      break;

    case 'donate':
      $product = __($system['system_title']) . " " . __('Funding Donation');
      $description = __('Pay For') . " " . __($system['system_title']);
      $URL['success'] = $system['system_url'] . "/webhooks/paypal.php?status=success&handle=donate&post_id=$id";
      $URL['cancel'] = $system['system_url'] . "/webhooks/paypal.php?status=cancel";
      $_SESSION['donation_amount'] = $price;
      break;

    case 'paid_post':
      $product = __($system['system_title']) . " " . __('Paid Post');
      $description = __('Pay For') . " " . __($system['system_title']);
      $URL['success'] = $system['system_url'] . "/webhooks/paypal.php?status=success&handle=paid_post&post_id=$id";
      $URL['cancel'] = $system['system_url'] . "/webhooks/paypal.php?status=cancel";
      break;

    case 'movies':
      $product = __($system['system_title']) . " " . __('Movies');
      $description = __('Pay For') . " " . __($system['system_title']);
      $URL['success'] = $system['system_url'] . "/webhooks/paypal.php?status=success&handle=movies&movie_id=$id";
      $URL['cancel'] = $system['system_url'] . "/webhooks/paypal.php?status=cancel";
      break;

    case 'marketplace':
      $product = __($system['system_title']) . " " . __('Marketplace');
      $description = __('Pay For') . " " . __($system['system_title']);
      $URL['success'] = $system['system_url'] . "/webhooks/paypal.php?status=success&handle=marketplace&orders_collection_id=$id";
      $URL['cancel'] = $system['system_url'] . "/webhooks/paypal.php?status=cancel";
      break;

    default:
      _error(400);
      break;
  }
  /* get access token */
  $access_token = paypal_access_token();
  /* prepare API url */
  $paypal_api_url = ($system['paypal_mode'] == "sandbox") ? "https://api-m.sandbox.paypal.com" : "https://api.paypal.com";
  /* create a payment */
  $request_body = [
    'intent' => 'sale',
    'payer' => [
      'payment_method' => 'paypal',
    ],
    'redirect_urls' => [
      'return_url' => $URL['success'],
      'cancel_url' => $URL['cancel'],
    ],
    'transactions' => [
      [
        'item_list' => [
          'items' => [
            [
              'name' => $product,
              'sku' => 'item',
              'price' => $total,
              'currency' => $system['system_currency'],
              'quantity' => 1,
            ],
          ],
        ],
        'amount' => [
          'currency' => $system['system_currency'],
          'total' => $total,
        ],
        'description' => $description,
      ],
    ],
  ];
  $ch = curl_init();
  curl_setopt($ch, CURLOPT_URL, $paypal_api_url . '/v1/payments/payment');
  curl_setopt($ch, CURLOPT_HEADER, 0);
  curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type: application/json', 'Authorization: Bearer ' . $access_token]);
  curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0);
  curl_setopt($ch, CURLOPT_POST, 1);
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
  curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($request_body));
  $response = curl_exec($ch);
  $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
  if (curl_errno($ch)) {
    throw new Exception("Error Processing Request");
  }
  curl_close($ch);
  $response = json_decode($response);
  if (!($httpCode >= 200 && $httpCode < 300)) {
    $error = "Error Processing Request";
    if (DEBUGGING) {
      if ($response->error_description) {
        $error = $response->error_description;
      } elseif ($response->message) {
        $error = $response->message;
      } else {
        $backtrace = debug_backtrace();
        $line = $backtrace[0]['line'];
        $file = $backtrace[0]['file'];
        $error = "This error function was called from line $line in file $file";
      }
    }
    throw new Exception($error);
  }
  return $response->links[1]->href;
}


/**
 * paypal_payment_check
 *
 * @param string $payment_id
 * @param string $payer_id
 * @return string
 */
function paypal_payment_check($payment_id, $payer_id)
{
  global $system;
  /* get access token */
  $access_token = paypal_access_token();
  /* prepare API url */
  $paypal_api_url = ($system['paypal_mode'] == "sandbox") ? "https://api-m.sandbox.paypal.com" : "https://api.paypal.com";
  /* check payment */
  $request_body = [
    'payer_id' => $payer_id,
  ];
  $ch = curl_init();
  curl_setopt($ch, CURLOPT_URL, $paypal_api_url . '/v1/payments/payment/' . $payment_id . '/execute');
  curl_setopt($ch, CURLOPT_HEADER, 0);
  curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type: application/json', 'Authorization: Bearer ' . $access_token]);
  curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0);
  curl_setopt($ch, CURLOPT_POST, 1);
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
  curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($request_body));
  $response = curl_exec($ch);
  $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
  if (curl_errno($ch)) {
    throw new Exception("Error Processing Request");
  }
  curl_close($ch);
  $response = json_decode($response);
  if (!($httpCode >= 200 && $httpCode < 300)) {
    $error = "Error Processing Request";
    if (DEBUGGING) {
      if ($response->error_description) {
        $error = $response->error_description;
      } elseif ($response->message) {
        $error = $response->message;
      } else {
        $backtrace = debug_backtrace();
        $line = $backtrace[0]['line'];
        $file = $backtrace[0]['file'];
        $error = "This error function was called from line $line in file $file";
      }
    }
    throw new Exception($error);
  }
  return $response;
}


/**
 * paypal_subscription_link
 *
 * @param string $handle
 * @param integer $id
 * @param string $billing_plan_id
 * 
 * @return string
 */
function paypal_subscription_link($handle, $id, $billing_plan_id)
{
  global $system, $user;
  /* prepare handle */
  switch ($handle) {
    case 'packages':
      $URL['success'] = $system['system_url'] . "/webhooks/paypal.php?status=success&handle=packages&package_id=$id";
      $URL['cancel'] = $system['system_url'] . "/webhooks/paypal.php?status=cancel";
      break;

    case 'subscribe':
      $URL['success'] = $system['system_url'] . "/webhooks/paypal.php?status=success&handle=subscribe&plan_id=$id";
      $URL['cancel'] = $system['system_url'] . "/webhooks/paypal.php?status=cancel";
      break;

    default:
      _error(400);
      break;
  }
  /* get access token */
  $access_token = paypal_access_token();
  /* prepare API url */
  $paypal_api_url = ($system['paypal_mode'] == "sandbox") ? "https://api-m.sandbox.paypal.com" : "https://api.paypal.com";
  /* create a subscription */
  $request_body = [
    'plan_id' => $billing_plan_id,
    'subscriber' => [
      'name' => [
        'given_name' => $user->_data['user_firstname'],
        'surname' => $user->_data['user_lastname'],
      ],
      'email_address' => $user->_data['user_email'],
    ],
    'application_context' => [
      'brand_name' => $system['system_title'],
      'locale' => $system['system_locale'],
      'shipping_preference' => 'NO_SHIPPING',
      'user_action' => 'SUBSCRIBE_NOW',
      'payment_method' => [
        'payer_selected' => 'PAYPAL',
        'payee_preferred' => 'IMMEDIATE_PAYMENT_REQUIRED',
      ],
      'return_url' => $URL['success'],
      'cancel_url' => $URL['cancel'],
    ],
  ];
  $ch = curl_init();
  curl_setopt($ch, CURLOPT_URL, $paypal_api_url . '/v1/billing/subscriptions');
  curl_setopt($ch, CURLOPT_HEADER, 0);
  curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type: application/json', 'Authorization: Bearer ' . $access_token]);
  curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0);
  curl_setopt($ch, CURLOPT_POST, 1);
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
  curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($request_body));
  $response = curl_exec($ch);
  $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
  if (curl_errno($ch)) {
    throw new Exception("Error Processing Request");
  }
  curl_close($ch);
  $response = json_decode($response);
  if (!($httpCode >= 200 && $httpCode < 300)) {
    $error = "Error Processing Request";
    if (DEBUGGING) {
      if ($response->error_description) {
        $error = $response->error_description;
      } elseif ($response->message) {
        $error = $response->message;
      } else {
        $backtrace = debug_backtrace();
        $line = $backtrace[0]['line'];
        $file = $backtrace[0]['file'];
        $error = "This error function was called from line $line in file $file";
      }
    }
    throw new Exception($error);
  }
  return $response->links[0]->href;
}


/**
 * paypal_subscription_check
 *
 * @param string $subscription_id
 * 
 * @return boolean
 */
function paypal_subscription_check($subscription_id)
{
  global $system;
  /* get access token */
  $access_token = paypal_access_token();
  /* prepare API url */
  $paypal_api_url = ($system['paypal_mode'] == "sandbox") ? "https://api-m.sandbox.paypal.com" : "https://api.paypal.com";
  /* check subscription */
  $ch = curl_init();
  curl_setopt($ch, CURLOPT_URL, $paypal_api_url . '/v1/billing/subscriptions/' . $subscription_id);
  curl_setopt($ch, CURLOPT_HEADER, 0);
  curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type: application/json', 'Authorization: Bearer ' . $access_token]);
  curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0);
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
  $response = curl_exec($ch);
  $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
  if (curl_errno($ch)) {
    throw new Exception("Error Processing Request");
  }
  curl_close($ch);
  $response = json_decode($response);
  if (!($httpCode >= 200 && $httpCode < 300)) {
    $error = "Error Processing Request";
    if (DEBUGGING) {
      if ($response->error_description) {
        $error = $response->error_description;
      } elseif ($response->message) {
        $error = $response->message;
      } else {
        $backtrace = debug_backtrace();
        $line = $backtrace[0]['line'];
        $file = $backtrace[0]['file'];
        $error = "This error function was called from line $line in file $file";
      }
    }
    throw new Exception($error);
  }
  if ($response->status == 'ACTIVE') {
    return true;
  }
  return false;
}


/**
 * paypal_create_billing_plan
 *
 * @param string $name
 * @param string $description
 * @param string $frequency
 * @param string $interval
 * @param string $amount
 * @return string
 */
function paypal_create_billing_plan($name, $description, $frequency, $interval, $amount)
{
  global $system;
  /* prepare total price */
  $total = get_payment_total_value($amount);
  /* get access token */
  $access_token = paypal_access_token();
  /* prepare API url */
  $paypal_api_url = ($system['paypal_mode'] == "sandbox") ? "https://api-m.sandbox.paypal.com" : "https://api.paypal.com";
  /* create a product for the plan */
  $request_body = [
    'name' => $name,
    'description' => ($description) ? $description : $name,
    'home_url' => $system['system_url'],
  ];
  $ch = curl_init();
  curl_setopt($ch, CURLOPT_URL, $paypal_api_url . '/v1/catalogs/products');
  curl_setopt($ch, CURLOPT_HEADER, 0);
  curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type: application/json', 'Authorization: Bearer ' . $access_token]);
  curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0);
  curl_setopt($ch, CURLOPT_POST, 1);
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
  curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($request_body));
  $response = curl_exec($ch);
  $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
  if (curl_errno($ch)) {
    throw new Exception("Error Processing Request");
  }
  curl_close($ch);
  $response = json_decode($response);
  if ($httpCode != 201) {
    $error = "Error Processing Request";
    if (DEBUGGING) {
      if ($response->error_description) {
        $error = $response->error_description;
      } elseif ($response->message) {
        $error = $response->message;
      } else {
        $backtrace = debug_backtrace();
        $line = $backtrace[0]['line'];
        $file = $backtrace[0]['file'];
        $error = "This error function was called from line $line in file $file";
      }
    }
    throw new Exception($error);
  }
  $product_id = $response->id;
  /* create a plan */
  $request_body = [
    'product_id' => $product_id,
    'name' => $name,
    'description' => ($description) ? $description : $name,
    'status' => 'ACTIVE',
    'billing_cycles' => [
      [
        'frequency' => [
          'interval_unit' => strtoupper($interval),
          'interval_count' => $frequency,
        ],
        'tenure_type' => 'REGULAR',
        'sequence' => 1,
        'total_cycles' => 0,
        'pricing_scheme' => [
          'fixed_price' => [
            'value' => $total,
            'currency_code' => $system['system_currency'],
          ],
        ],
      ],
    ],
    'payment_preferences' => [
      'auto_bill_outstanding' => true,
      'setup_fee' => [
        'value' => '0',
        'currency_code' => $system['system_currency'],
      ],
      'setup_fee_failure_action' => 'CONTINUE',
      'payment_failure_threshold' => 3,
    ],
    'taxes' => [
      'percentage' => '0',
      'inclusive' => false,
    ],
  ];
  $ch = curl_init();
  curl_setopt($ch, CURLOPT_URL, $paypal_api_url . '/v1/billing/plans');
  curl_setopt($ch, CURLOPT_HEADER, 0);
  curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type: application/json', 'Authorization: Bearer ' . $access_token]);
  curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0);
  curl_setopt($ch, CURLOPT_POST, 1);
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
  curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($request_body));
  $response = curl_exec($ch);
  $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
  if (curl_errno($ch)) {
    throw new Exception("Error Processing Request");
  }
  curl_close($ch);
  $response = json_decode($response);
  if ($httpCode != 201) {
    $error = "Error Processing Request";
    if (DEBUGGING) {
      if ($response->error_description) {
        $error = $response->error_description;
      } elseif ($response->message) {
        $error = $response->message;
      } else {
        $backtrace = debug_backtrace();
        $line = $backtrace[0]['line'];
        $file = $backtrace[0]['file'];
        $error = "This error function was called from line $line in file $file";
      }
    }
    throw new Exception($error);
  }
  $plan_id = $response->id;
  return $plan_id;
}


/**
 * paypal_edit_billing_plan
 *
 * @param string $billing_plan_id
 * @param string $name
 * @param string $description
 * @return void
 */
function paypal_edit_billing_plan($billing_plan_id, $name, $description)
{
  global $system;
  /* get access token */
  $access_token = paypal_access_token();
  /* prepare API url */
  $paypal_api_url = ($system['paypal_mode'] == "sandbox") ? "https://api-m.sandbox.paypal.com" : "https://api.paypal.com";
  /* get plan details */
  $ch = curl_init();
  curl_setopt($ch, CURLOPT_URL, $paypal_api_url . '/v1/billing/plans/' . $billing_plan_id);
  curl_setopt($ch, CURLOPT_HEADER, 0);
  curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type: application/json', 'Authorization: Bearer ' . $access_token]);
  curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0);
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
  $response = curl_exec($ch);
  $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
  if (curl_errno($ch)) {
    throw new Exception("Error Processing Request");
  }
  curl_close($ch);
  $response = json_decode($response);
  if ($httpCode != 200) {
    $error = "Error Processing Request";
    if (DEBUGGING) {
      if ($response->error_description) {
        $error = $response->error_description;
      } elseif ($response->message) {
        $error = $response->message;
      } else {
        $backtrace = debug_backtrace();
        $line = $backtrace[0]['line'];
        $file = $backtrace[0]['file'];
        $error = "This error function was called from line $line in file $file";
      }
    }
    throw new Exception($error);
  }
  $product_id = $response->product_id;
  /* update plan */
  $request_body = [
    [
      "op" => "replace",
      "path" => "/name",
      "value" => $name
    ],
    [
      "op" => "replace",
      "path" => "/description",
      "value" => ($description) ? $description : $name
    ]
  ];
  $ch = curl_init();
  curl_setopt($ch, CURLOPT_URL, $paypal_api_url . '/v1/billing/plans/' . $billing_plan_id);
  curl_setopt($ch, CURLOPT_HEADER, 0);
  curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type: application/json', 'Authorization: Bearer ' . $access_token]);
  curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0);
  curl_setopt($ch, CURLOPT_CUSTOMREQUEST, 'PATCH');
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
  curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($request_body));
  $response = curl_exec($ch);
  $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
  if (curl_errno($ch)) {
    throw new Exception("Error Processing Request");
  }
  curl_close($ch);
  $response = json_decode($response);
  if ($httpCode != 204) {
    $error = "Error Processing Request";
    if (DEBUGGING) {
      if ($response->error_description) {
        $error = $response->error_description;
      } elseif ($response->message) {
        $error = $response->message;
      } else {
        $backtrace = debug_backtrace();
        $line = $backtrace[0]['line'];
        $file = $backtrace[0]['file'];
        $error = "This error function was called from line $line in file $file";
      }
    }
    throw new Exception($error);
  }
}


/**
 * paypal_deactivate_billing_plan
 *
 * @param string $billing_plan_id
 * @return void
 */
function paypal_deactivate_billing_plan($billing_plan_id)
{
  global $system;
  /* get access token */
  $access_token = paypal_access_token();
  /* prepare API url */
  $paypal_api_url = ($system['paypal_mode'] == "sandbox") ? "https://api-m.sandbox.paypal.com" : "https://api.paypal.com";
  /* deactivate plan */
  $ch = curl_init();
  curl_setopt($ch, CURLOPT_URL, $paypal_api_url . '/v1/billing/plans/' . $billing_plan_id . '/deactivate');
  curl_setopt($ch, CURLOPT_HEADER, 0);
  curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type: application/json', 'Authorization: Bearer ' . $access_token]);
  curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0);
  curl_setopt($ch, CURLOPT_CUSTOMREQUEST, 'POST');
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
  $response = curl_exec($ch);
  $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
  if (curl_errno($ch)) {
    throw new Exception("Error Processing Request");
  }
  curl_close($ch);
  $response = json_decode($response);
  if ($httpCode != 204) {
    $error = "Error Processing Request";
    if (DEBUGGING) {
      if ($response->error_description) {
        $error = $response->error_description;
      } elseif ($response->message) {
        $error = $response->message;
      } else {
        $backtrace = debug_backtrace();
        $line = $backtrace[0]['line'];
        $file = $backtrace[0]['file'];
        $error = "This error function was called from line $line in file $file";
      }
    }
    throw new Exception($error);
  }
}


/**
 * paypal_replace_billing_plan
 *
 * @param string $billing_plan_id
 * @param string $name
 * @param string $description
 * @param string $frequency
 * @param string $interval
 * @param string $amount
 * 
 * @return string
 */
function paypal_replace_billing_plan($billing_plan_id, $name, $description, $frequency, $interval, $amount)
{
  /* deactivate old plan */
  paypal_deactivate_billing_plan($billing_plan_id);
  /* create new plan */
  $new_plan_id = paypal_create_billing_plan($name, $description, $frequency, $interval, $amount);
  return $new_plan_id;
}


/**
 * paypal_verify_webhook_signature
 *
 * @param string $headers
 * @param string $body
 * 
 * @return boolean
 */
function paypal_verify_webhook_signature($headers, $body)
{
  global $system;
  /* get access token */
  $access_token = paypal_access_token();
  /* prepare API url */
  $paypal_api_url = ($system['paypal_mode'] == "sandbox") ? "https://api-m.sandbox.paypal.com" : "https://api.paypal.com";
  /* verify webhook signature */
  $request_body = [
    "auth_algo" => $headers['paypal-auth-algo'],
    "cert_url" => $headers['paypal-cert-url'],
    "transmission_id" => $headers['paypal-transmission-id'],
    "transmission_sig" => $headers['paypal-transmission-sig'],
    "transmission_time" => $headers['paypal-transmission-time'],
    "webhook_id" => $system['paypal_webhook'],
    "webhook_event" => $body
  ];
  $ch = curl_init();
  curl_setopt($ch, CURLOPT_URL, $paypal_api_url . '/v1/notifications/verify-webhook-signature');
  curl_setopt($ch, CURLOPT_HEADER, 0);
  curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type: application/json', 'Authorization: Bearer ' . $access_token]);
  curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 1);
  curl_setopt($ch, CURLOPT_POST, 1);
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
  curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($request_body));
  $response = curl_exec($ch);
  $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
  if (curl_errno($ch)) {
    return false;
  }
  curl_close($ch);
  $response = json_decode($response, true);
  if (!($httpCode >= 200 && $httpCode < 300)) {
    $error = "Error Processing Request";
    if (DEBUGGING) {
      if ($response->error_description) {
        $error = $response->error_description;
      } elseif ($response->message) {
        $error = $response->message;
      } else {
        $backtrace = debug_backtrace();
        $line = $backtrace[0]['line'];
        $file = $backtrace[0]['file'];
        $error = "This error function was called from line $line in file $file";
      }
    }
    throw new Exception($error);
  }
  if ($response['verification_status'] == 'SUCCESS') {
    return true;
  }
  return false;
}


/**
 * paypal_cancel_subscription
 *
 * @param string $subscription_id
 * 
 * @return void
 */
function paypal_cancel_subscription($subscription_id)
{
  global $system;
  /* get access token */
  $access_token = paypal_access_token();
  /* prepare API url */
  $paypal_api_url = ($system['paypal_mode'] == "sandbox") ? "https://api-m.sandbox.paypal.com" : "https://api.paypal.com";
  /* cancel subscription */
  $ch = curl_init();
  curl_setopt($ch, CURLOPT_URL, $paypal_api_url . '/v1/billing/subscriptions/' . $subscription_id . '/cancel');
  curl_setopt($ch, CURLOPT_HEADER, 0);
  curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type: application/json', 'Authorization: Bearer ' . $access_token]);
  curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0);
  curl_setopt($ch, CURLOPT_POST, 1);
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
  $response = curl_exec($ch);
  $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
  if (curl_errno($ch)) {
    throw new Exception("Error Processing Request");
  }
  curl_close($ch);
  $response = json_decode($response);
  if ($httpCode != 204) {
    $error = "Error Processing Request";
    if (DEBUGGING) {
      if ($response->error_description) {
        $error = $response->error_description;
      } elseif ($response->message) {
        $error = $response->message;
      } else {
        $backtrace = debug_backtrace();
        $line = $backtrace[0]['line'];
        $file = $backtrace[0]['file'];
        $error = "This error function was called from line $line in file $file";
      }
    }
  }
}


function paypal_payout($amount, $email)
{
  global $system;
  /* prepare total price */
  $total = $amount;
  /* get access token */
  $access_token = paypal_access_token();
  /* prepare API url */
  $paypal_api_url = ($system['paypal_mode'] == "sandbox") ? "https://api-m.sandbox.paypal.com" : "https://api.paypal.com";
  /* create a payout */
  $request_body = [
    'sender_batch_header' => [
      'sender_batch_id' => uniqid(),
      'recipient_type' => 'EMAIL',
      'email_subject' => 'You have money!',
      'email_message' => 'You received a payment. Thanks for using our service!'
    ],
    'items' => [
      [
        'recipient_type' => 'EMAIL',
        'amount' => [
          'value' => $total,
          'currency' => $system['system_currency'],
        ],
        'sender_item_id' => uniqid(),
        'recipient_wallet' => 'PAYPAL',
        'receiver' => $email,
      ],
    ],
  ];
  $ch = curl_init();
  curl_setopt($ch, CURLOPT_URL, $paypal_api_url . '/v1/payments/payouts');
  curl_setopt($ch, CURLOPT_HEADER, 0);
  curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type: application/json', 'Authorization: Bearer ' . $access_token]);
  curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0);
  curl_setopt($ch, CURLOPT_POST, 1);
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
  curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($request_body));
  $response = curl_exec($ch);
  $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
  if (curl_errno($ch)) {
    throw new Exception("Error Processing Request");
  }
  curl_close($ch);
  $response = json_decode($response);
  if ($httpCode != 201) {
    $error = "Error Processing Request";
    if (DEBUGGING) {
      if ($response->error_description) {
        $error = $response->error_description;
      } elseif ($response->message) {
        $error = $response->message;
      } else {
        $backtrace = debug_backtrace();
        $line = $backtrace[0]['line'];
        $file = $backtrace[0]['file'];
        $error = "This error function was called from line $line in file $file";
      }
    }
    throw new Exception($error);
  }
  return $response;
}



/* ------------------------------- */
/* Stripe */
/* ------------------------------- */

/**
 * stripe_payment_session
 *
 * @param string $method
 * @param string $handle
 * @param string $price
 * @param integer $id
 * @return string
 */
function stripe_payment_session($method, $handle, $price, $id = null)
{
  global $system, $user;
  /* prepare */
  $total = get_payment_total_value($price);
  switch ($handle) {
    case 'packages':
      /* get package */
      $package = $user->get_package($id);
      if ($package['stripe_billing_plan']) {
        return stripe_subscription_session($method, $handle, $id, $package['stripe_billing_plan']);
      }
      $product = __($system['system_title']) . " " . __('Package') . " " . __($package['name']);
      $description = __('Pay For') . " " . __($system['system_title']) . " " . __('Package') . " " . __($package['name']);
      $URL['success'] = $system['system_url'] . "/webhooks/stripe.php?status=success&handle=packages&package_id=$id";
      $URL['cancel'] = $system['system_url'] . "/webhooks/stripe.php?status=cancel";
      break;

    case 'subscribe':
      /* get monetization plan */
      $monetization_plan = $user->get_monetization_plan($id, true);
      if (!$monetization_plan) {
        throw new Exception(__("The monetization plan you're trying to subscribe to is not found"));
      }
      if ($monetization_plan['stripe_billing_plan']) {
        return stripe_subscription_session($method, $handle, $id, $monetization_plan['stripe_billing_plan']);
      }
      $product = __($system['system_title']) . " " . __('Monetization Plan') . " " . __($monetization_plan['name']);
      $description = __('Pay For') . " " . __($system['system_title']) . " " . __('Monetization Plan') . " " . __($monetization_plan['name']);
      $URL['success'] = $system['system_url'] . "/webhooks/stripe.php?status=success&handle=subscribe&plan_id=$id";
      $URL['cancel'] = $system['system_url'] . "/webhooks/stripe.php?status=cancel";
      break;

    case 'wallet':
      $product = __($system['system_title']) . " " . __('Wallet');
      $description = __('Pay For') . " " . __($system['system_title']);
      $URL['success'] = $system['system_url'] . "/webhooks/stripe.php?status=success&handle=wallet";
      $URL['cancel'] = $system['system_url'] . "/webhooks/stripe.php?status=cancel";
      $_SESSION['wallet_replenish_amount'] = $price;
      break;

    case 'donate':
      $product = __($system['system_title']) . " " . __('Funding Donation');
      $description = __('Pay For') . " " . __($system['system_title']);
      $URL['success'] = $system['system_url'] . "/webhooks/stripe.php?status=success&handle=donate&post_id=$id";
      $URL['cancel'] = $system['system_url'] . "/webhooks/stripe.php?status=cancel";
      $_SESSION['donation_amount'] = $price;
      break;

    case 'paid_post':
      $product = __($system['system_title']) . " " . __('Paid Post');
      $description = __('Pay For') . " " . __($system['system_title']);
      $URL['success'] = $system['system_url'] . "/webhooks/stripe.php?status=success&handle=paid_post&post_id=$id";
      $URL['cancel'] = $system['system_url'] . "/webhooks/stripe.php?status=cancel";
      break;

    case 'movies':
      $product = __($system['system_title']) . " " . __('Movies');
      $description = __('Pay For') . " " . __($system['system_title']);
      $URL['success'] = $system['system_url'] . "/webhooks/stripe.php?status=success&handle=movies&movie_id=$id";
      $URL['cancel'] = $system['system_url'] . "/webhooks/stripe.php?status=cancel";
      break;

    case 'marketplace':
      $product = __($system['system_title']) . " " . __('Marketplace');
      $description = __('Pay For') . " " . __($system['system_title']);
      $URL['success'] = $system['system_url'] . "/webhooks/stripe.php?status=success&handle=marketplace&orders_collection_id=$id";
      $URL['cancel'] = $system['system_url'] . "/webhooks/stripe.php?status=cancel";
      break;

    default:
      _error(400);
      break;
  }
  $method = ($method == 'credit') ? 'card' : 'alipay';
  /* Stripe */
  $secret_key = ($system['stripe_mode'] == "live") ? $system['stripe_live_secret'] : $system['stripe_test_secret'];
  if ($system['stripe_payment_element_enabled']) {
    $stripe = new \Stripe\StripeClient($secret_key);
    /* create a PaymentIntent with amount and currency */
    $paymentIntent = $stripe->paymentIntents->create([
      'amount' => ($system['system_currency'] == 'JPY') ? $total : $total * 100,
      'currency' => $system['system_currency'],
    ]);
    /* return clientSecret */
    return ['client_secret' => $paymentIntent->client_secret, 'success_url' => $URL['success']];
  } else {
    \Stripe\Stripe::setApiKey($secret_key);
    $product = \Stripe\Product::create([
      'name' => $product,
      'type' => 'service',
    ]);
    $session = \Stripe\Checkout\Session::create([
      'payment_method_types' => [$method],
      'line_items' => [[
        'price_data' => [
          'product' => $product->id,
          'unit_amount' => ($system['system_currency'] == 'JPY') ? $total : $total * 100,
          'currency' => $system['system_currency'],
        ],
        'quantity' => 1,
      ]],
      'mode' => 'payment',
      'success_url' => $URL['success'],
      'cancel_url' => $URL['cancel'],
    ]);
    $_SESSION['stripe_session'] = $session;
    return $session;
  }
}


/**
 * stripe_subscription_session
 *
 * @param string $method
 * @param string $handle
 * @param string $id
 * @param integer $billing_plan_id
 * @return string
 */
function stripe_subscription_session($method, $handle, $id, $billing_plan_id)
{
  global $system, $user;
  /* prepare method */
  $method = ($method == 'credit') ? 'card' : 'alipay';
  /* prepare handle */
  switch ($handle) {
    case 'packages':
      $URL['success'] = $system['system_url'] . "/webhooks/stripe.php?status=success&handle=packages&package_id=$id";
      $URL['cancel'] = $system['system_url'] . "/webhooks/stripe.php?status=cancel";
      break;

    case 'subscribe':
      $URL['success'] = $system['system_url'] . "/webhooks/stripe.php?status=success&handle=subscribe&plan_id=$id";
      $URL['cancel'] = $system['system_url'] . "/webhooks/stripe.php?status=cancel";
      break;

    default:
      _error(400);
      break;
  }
  /* Stripe */
  $secret_key = ($system['stripe_mode'] == "live") ? $system['stripe_live_secret'] : $system['stripe_test_secret'];
  if ($system['stripe_payment_element_enabled']) {
    $stripe = new \Stripe\StripeClient($secret_key);
    $customer = $stripe->customers->create([
      'email' => $user->_data['user_email'],
    ]);
    $subscription = $stripe->subscriptions->create([
      'customer' => $customer->id,
      'items' => [
        ['price' => $billing_plan_id],
      ],
      'payment_behavior' => 'default_incomplete',
      'expand' => ['latest_invoice.payment_intent'],
    ]);
    return [
      'client_secret' => $subscription->latest_invoice->payment_intent->client_secret,
      'subscription_id' => $subscription->id,
      'success_url' => $URL['success'],
      'cancel_url' => $URL['cancel']
    ];
  } else {
    \Stripe\Stripe::setApiKey($secret_key);
    $session = \Stripe\Checkout\Session::create([
      'payment_method_types' => [$method],
      'line_items' => [[
        'price' => $billing_plan_id,
        'quantity' => 1,
      ]],
      'mode' => 'subscription',
      'success_url' => $URL['success'],
      'cancel_url' => $URL['cancel'],
    ]);
    $_SESSION['stripe_session'] = $session;
    return $session;
  }
}


/**
 * stripe_payment_check
 *
 * @return boolean
 */
function stripe_payment_check()
{
  global $system;
  if ($_GET['payment_intent']) {
    $secret_key = ($system['stripe_mode'] == "live") ? $system['stripe_live_secret'] : $system['stripe_test_secret'];
    \Stripe\Stripe::setApiKey($secret_key);
    $payment_intent = \Stripe\PaymentIntent::retrieve($_GET['payment_intent']);
    if ($payment_intent->status == "succeeded") {
      if (isset($payment_intent->invoice)) {
        $invoice = \Stripe\Invoice::retrieve($payment_intent->invoice);
        if (isset($invoice->subscription)) {
          $payment_intent->mode = 'subscription';
          $payment_intent->subscription = $invoice->subscription;
        } else {
          $payment_intent->mode = 'one-time';
        }
      } else {
        $payment_intent->mode = 'one-time';
      }
      return $payment_intent;
    }
  }
  if ($_SESSION['stripe_session']) {
    $secret_key = ($system['stripe_mode'] == "live") ? $system['stripe_live_secret'] : $system['stripe_test_secret'];
    \Stripe\Stripe::setApiKey($secret_key);
    $session = \Stripe\Checkout\Session::retrieve($_SESSION['stripe_session']['id']);
    unset($_SESSION['stripe_session']);
    if ($session->payment_status == "paid") {
      return $session;
    }
  }
  return false;
}


/**
 * stripe_create_billing_plan
 *
 * @param string $name
 * @param string $description
 * @param string $frequency
 * @param string $interval
 * @param string $amount
 * @return string
 */
function stripe_create_billing_plan($name, $description, $frequency, $interval, $amount)
{
  global $system;
  /* prepare total price */
  $total = get_payment_total_value($amount);
  /* Stripe */
  $secret_key = ($system['stripe_mode'] == "live") ? $system['stripe_live_secret'] : $system['stripe_test_secret'];
  \Stripe\Stripe::setApiKey($secret_key);
  $product = \Stripe\Product::create([
    'name' => $name,
    'description' => ($description) ? $description : $name,
    'type' => 'service',
  ]);
  $plan = \Stripe\Plan::create([
    'product' => $product->id,
    'nickname' => ($description) ? $description : $name,
    'interval' => $interval,
    'interval_count' => $frequency,
    'currency' => $system['system_currency'],
    'amount' => ($system['system_currency'] == 'JPY') ? $total : $total * 100,
  ]);
  return $plan->id;
}


/**
 * stripe_edit_billing_plan
 *
 * @param string $billing_plan_id
 * @param string $description
 * @return void
 */
function stripe_edit_billing_plan($billing_plan_id, $description)
{
  global $system;
  /* Stripe */
  $secret_key = ($system['stripe_mode'] == "live") ? $system['stripe_live_secret'] : $system['stripe_test_secret'];
  \Stripe\Stripe::setApiKey($secret_key);
  $plan = \Stripe\Plan::update(
    $billing_plan_id,
    [
      'nickname' => $description,
    ]
  );
}


/**
 * stripe_deactivate_billing_plan
 *
 * @param string $billing_plan_id
 * @return void
 */
function stripe_deactivate_billing_plan($billing_plan_id)
{
  global $system;
  /* Stripe */
  $secret_key = ($system['stripe_mode'] == "live") ? $system['stripe_live_secret'] : $system['stripe_test_secret'];
  \Stripe\Stripe::setApiKey($secret_key);
  $plan = \Stripe\Plan::update(
    $billing_plan_id,
    [
      'active' => false,
    ]
  );
}


/**
 * stripe_replace_billing_plan
 *
 * @param string $billing_plan_id
 * @param string $name
 * @param string $description
 * @param string $frequency
 * @param string $interval
 * @param string $amount
 * 
 * @return string
 */
function stripe_replace_billing_plan($billing_plan_id, $name, $description, $frequency, $interval, $amount)
{
  /* deactivate old plan */
  stripe_deactivate_billing_plan($billing_plan_id);
  /* create new plan */
  $new_plan_id = stripe_create_billing_plan($name, $description, $frequency, $interval, $amount);
  return $new_plan_id;
}


/**
 * stripe_cancel_subscription
 *
 * @param string $subscription_id
 * 
 * @return void
 */
function stripe_cancel_subscription($subscription_id)
{
  global $system;
  /* Stripe */
  $secret_key = ($system['stripe_mode'] == "live") ? $system['stripe_live_secret'] : $system['stripe_test_secret'];
  \Stripe\Stripe::setApiKey($secret_key);
  /* retrieve the subscription */
  $subscription = \Stripe\Subscription::retrieve($subscription_id);
  /* cancel the subscription */
  $subscription->cancel();
}



/* ------------------------------- */
/* 2CheckOut */
/* ------------------------------- */

/**
 * twocheckout_check
 *
 * @param string $price
 * @return boolean
 */
function twocheckout_check($price)
{
  global $system;
  $total = get_payment_total_value($price);
  Twocheckout::privateKey($system['2checkout_private_key']);
  Twocheckout::sellerId($system['2checkout_merchant_code']);
  if ($system['2checkout_mode'] == 'sandbox') {
    Twocheckout::verifySSL(false);
  }
  $twocheckout_config = [
    "merchantOrderId" => get_hash_token(),
    "token" => $_POST['token'],
    "currency" => $system['system_currency'],
    "total" => $total,
    "billingAddr" => [
      "name" => $_POST['billing_name'],
      "addrLine1" => $_POST['billing_address'],
      "city" => $_POST['billing_city'],
      "state" => $_POST['billing_state'],
      "zipCode" => $_POST['billing_zip_code'],
      "country" => $_POST['billing_country'],
      "email" => $_POST['billing_email'],
      "phoneNumber" => $_POST['billing_phone']
    ]
  ];
  if ($system['2checkout_mode'] == 'sandbox') {
    $twocheckout_config['demo'] = true;
  }
  $charge = Twocheckout_Charge::auth($twocheckout_config);
  if ($charge['response']['responseCode'] == 'APPROVED') {
    return true;
  }
  return false;
}



/* ------------------------------- */
/* Authorize.net */
/* ------------------------------- */

/**
 * authorize_net_check
 *
 * @param string $price
 * @return boolean
 */
function authorize_net_check($price)
{
  global $system;
  $total = get_payment_total_value($price);
  /* set up authentication */
  $merchantAuthentication = new net\authorize\api\contract\v1\MerchantAuthenticationType();
  $merchantAuthentication->setName($system['authorize_net_api_login_id']);
  $merchantAuthentication->setTransactionKey($system['authorize_net_transaction_key']);
  /* set the transaction's refId */
  $refId = 'ref' . time();
  /* set up payment data */
  $creditCard = new net\authorize\api\contract\v1\CreditCardType();
  $creditCard->setCardNumber($_POST['card_number']);
  $creditCard->setExpirationDate($_POST['card_exp_year'] . '-' . $_POST['card_exp_month']);
  $creditCard->setCardCode($_POST['card_cvv']);
  /* add the payment data to a paymentType object */
  $payment = new net\authorize\api\contract\v1\PaymentType();
  $payment->setCreditCard($creditCard);
  /* set up billing address */
  $billTo = new net\authorize\api\contract\v1\CustomerAddressType();
  $billTo->setFirstName($_POST['billing_name']);
  $billTo->setAddress($_POST['billing_address']);
  $billTo->setCity($_POST['billing_city']);
  $billTo->setState($_POST['billing_state']);
  $billTo->setCountry($_POST['billing_country']);
  $billTo->setZip($_POST['billing_zip_code']);
  $billTo->setPhoneNumber($_POST['billing_phone']);
  $billTo->setEmail($_POST['billing_email']);
  /* set up transaction request */
  $request = new net\authorize\api\contract\v1\CreateTransactionRequest();
  $request->setMerchantAuthentication($merchantAuthentication);
  $request->setTransactionRequest(
    (new net\authorize\api\contract\v1\TransactionRequestType())
      ->setTransactionType("authCaptureTransaction")
      ->setAmount($total)
      ->setPayment($payment)
      ->setBillTo($billTo)
  );
  $request->setRefId($refId);
  /* execute transaction request */
  $controller = new net\authorize\api\controller\CreateTransactionController($request);
  if ($system['authorize_net_mode'] == "sandbox") {
    $response = $controller->executeWithApiResponse(\net\authorize\api\constants\ANetEnvironment::SANDBOX);
  } else {
    $response = $controller->executeWithApiResponse(\net\authorize\api\constants\ANetEnvironment::PRODUCTION);
  }
  /* handle response */
  if ($response != null) {
    $tresponse = $response->getTransactionResponse();
    if (($tresponse != null) && ($tresponse->getResponseCode() == "1")) {
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}



/* ------------------------------- */
/* Paystack */
/* ------------------------------- */

/**
 * paystack
 *
 * @param string $handle
 * @param string $price
 * @param integer $id
 * @return string
 */
function paystack($handle, $price, $id = null)
{
  global $system, $user;
  /* prepare */
  $total = get_payment_total_value($price);
  switch ($handle) {
    case 'packages':
      $callback = $system['system_url'] . "/webhooks/paystack.php?status=success&handle=packages&package_id=$id";
      break;

    case 'wallet':
      $callback = $system['system_url'] . "/webhooks/paystack.php?status=success&handle=wallet";
      $_SESSION['wallet_replenish_amount'] = $price;
      break;

    case 'donate':
      $callback = $system['system_url'] . "/webhooks/paystack.php?status=success&handle=donate&post_id=$id";
      $_SESSION['donation_amount'] = $price;
      break;

    case 'subscribe':
      $callback = $system['system_url'] . "/webhooks/paystack.php?status=success&handle=subscribe&plan_id=$id";
      break;

    case 'paid_post':
      $callback = $system['system_url'] . "/webhooks/paystack.php?status=success&handle=paid_post&post_id=$id";
      break;

    case 'movies':
      $callback = $system['system_url'] . "/webhooks/paystack.php?status=success&handle=movies&movie_id=$id";
      break;

    case 'marketplace':
      $callback = $system['system_url'] . "/webhooks/paystack.php?status=success&handle=marketplace&orders_collection_id=$id";
      break;

    default:
      _error(400);
      break;
  }
  /* Paystack */
  $headers = [
    'Authorization: Bearer ' . $system['paystack_secret'],
    'Content-Type: application/json',
  ];
  $request_body = [
    'email' => $user->_data['user_email'],
    'amount' => $total * 100,
    'callback_url' => $callback
  ];
  $ch = curl_init();
  curl_setopt($ch, CURLOPT_URL, "https://api.paystack.co/transaction/initialize");
  curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
  curl_setopt($ch, CURLOPT_POST, 1);
  curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($request_body));
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
  $response = curl_exec($ch);
  $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
  if (curl_errno($ch)) {
    throw new Exception("Error Processing Request");
  }
  curl_close($ch);
  $responseJson = json_decode($response, true);
  if (!$responseJson['status']) {
    throw new Exception($responseJson['message']);
  }
  return $responseJson['data']['authorization_url'];
}


/**
 * paystack_check
 *
 * @param string $reference
 * @return boolean
 */
function paystack_check($reference)
{
  global $system;
  $headers = [
    'Authorization: Bearer ' . $system['paystack_secret']
  ];
  $ch = curl_init();
  curl_setopt($ch, CURLOPT_URL, "https://api.paystack.co/transaction/verify/" . $reference);
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
  curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
  $response = curl_exec($ch);
  $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
  if (curl_errno($ch)) {
    return false;
  }
  curl_close($ch);
  $responseJson = json_decode($response, true);
  if ($responseJson['data']['status'] == 'success') {
    return true;
  }
  return false;
}



/* ------------------------------- */
/* Razorpay */
/* ------------------------------- */

/**
 * razorpay_check
 *
 * @param string $payment_id
 * @param integer $amount
 * @return boolean
 */

function razorpay_check($payment_id, $amount)
{
  global $system;
  /* prepare total */
  $total = get_payment_total_value($amount);
  /* Razorpay */
  $url = 'https://api.razorpay.com/v1/payments/' . $payment_id . '/capture';
  $params = http_build_query(['amount' => $total * 100, 'currency' => $system['currency']]);
  $ch = curl_init();
  curl_setopt($ch, CURLOPT_URL, $url);
  curl_setopt($ch, CURLOPT_USERPWD, $system['razorpay_key_id'] . ':' . $system['razorpay_key_secret']);
  curl_setopt($ch, CURLOPT_TIMEOUT, 60);
  curl_setopt($ch, CURLOPT_POST, 1);
  curl_setopt($ch, CURLOPT_POSTFIELDS, $params);
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
  curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, true);
  $response = curl_exec($ch);
  $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
  if (curl_errno($ch)) {
    return false;
  }
  curl_close($ch);
  $responseJson = json_decode($response, true);
  if ($responseJson['error_code']) {
    return false;
  }
  return true;
}



/* ------------------------------- */
/* Cashfree */
/* ------------------------------- */

/**
 * cashfree
 *
 * @param string $handle
 * @param string $price
 * @param integer $id
 * @param string $billing_name
 * @param string $billing_email
 * @param string $billing_phone
 * @return string
 */
function cashfree($handle, $price, $id, $billing_name, $billing_email, $billing_phone)
{
  global $system;
  /* prepare */
  $total = get_payment_total_value($price);
  $return_url = $system['system_url'] . "/webhooks/cashfree.php?orderId={order_id}";
  switch ($handle) {
    case 'packages':
      $return_url .= "&handle=packages&package_id=$id";
      break;

    case 'wallet':
      $return_url .= "&handle=wallet";
      $_SESSION['wallet_replenish_amount'] = $price;
      break;

    case 'donate':
      $return_url .= "&handle=donate&post_id=$id";
      $_SESSION['donation_amount'] = $price;
      break;

    case 'subscribe':
      $return_url .= "&handle=subscribe&plan_id=$id";
      break;

    case 'paid_post':
      $return_url .= "&handle=paid_post&post_id=$id";
      break;

    case 'movies':
      $return_url .= "&handle=movies&movie_id=$id";
      break;

    case 'marketplace':
      $return_url .= "&handle=marketplace&orders_collection_id=$id";
      break;

    default:
      _error(400);
      break;
  }
  /* Cashfree */
  $x_api_version = "2023-08-01";
  Cashfree\Cashfree::$XClientId = $system['cashfree_client_id'];
  Cashfree\Cashfree::$XClientSecret = $system['cashfree_client_secret'];
  if ($system['cashfree_mode'] == 'sandbox') {
    Cashfree\Cashfree::$XEnvironment = Cashfree\Cashfree::$SANDBOX;
  } else {
    Cashfree\Cashfree::$XEnvironment = Cashfree\Cashfree::$PRODUCTION;
  }
  $cashfree = new Cashfree\Cashfree();
  $create_orders_request = new Cashfree\Model\CreateOrderRequest();
  $create_orders_request->setOrderAmount($total);
  $create_orders_request->setOrderCurrency($system['system_currency']);
  $customer_details = new Cashfree\Model\CustomerDetails();
  $customer_details->setCustomerId(uniqid());
  $customer_details->setCustomerName($billing_name);
  $customer_details->setCustomerPhone($billing_phone);
  $customer_details->setCustomerEmail($billing_email);
  $create_orders_request->setCustomerDetails($customer_details);
  $order_meta = new Cashfree\Model\OrderMeta();
  $order_meta->setReturnUrl($return_url);
  $create_orders_request->setOrderMeta($order_meta);
  try {
    $result = $cashfree->PGCreateOrder($x_api_version, $create_orders_request);
    /* return payment_session_id */
    return $result[0]->getPaymentSessionId();
  } catch (Exception $e) {
    throw new Exception($e->getMessage());
  }
}


/**
 * cashfree_check
 *
 * @param string $orderId
 * @return boolean
 */
function cashfree_check($orderId)
{
  global $system;
  $x_api_version = "2023-08-01";
  Cashfree\Cashfree::$XClientId = $system['cashfree_client_id'];
  Cashfree\Cashfree::$XClientSecret = $system['cashfree_client_secret'];
  if ($system['cashfree_mode'] == 'sandbox') {
    Cashfree\Cashfree::$XEnvironment = Cashfree\Cashfree::$SANDBOX;
  } else {
    Cashfree\Cashfree::$XEnvironment = Cashfree\Cashfree::$PRODUCTION;
  }
  $cashfree = new Cashfree\Cashfree();
  try {
    $result = $cashfree->PGOrderFetchPayments($x_api_version, $orderId, null, null, null);
    if ($result && $result[0][0]->getPaymentStatus() == "SUCCESS") {
      return true;
    }
    return false;
  } catch (Exception $e) {
    throw new Exception($e->getMessage());
  }
}



/* ------------------------------- */
/* Coinbase */
/* ------------------------------- */

/**
 * coinbase
 *
 * @param string $handle
 * @param string $price
 * @param integer $id
 * @return array
 */
function coinbase($handle, $price, $id = null)
{
  global $system;
  /* prepare */
  $total = get_payment_total_value($price);
  $coinbase_hash = get_hash_token();
  switch ($handle) {
    case 'packages':
      $product = __($system['system_title']) . " " . __('Pro Package');
      $description = __('Pay For') . " " . __($system['system_title']);
      $URL['success'] = $system['system_url'] . "/webhooks/coinbase.php?status=success&handle=packages&package_id=$id&coinbase_hash=$coinbase_hash";
      $URL['cancel'] = $system['system_url'] . "/webhooks/coinbase.php?status=cancel";
      break;

    case 'wallet':
      $product = __($system['system_title']) . " " . __('Wallet');
      $description = __('Pay For') . " " . __($system['system_title']);
      $URL['success'] = $system['system_url'] . "/webhooks/coinbase.php?status=success&handle=wallet&coinbase_hash=$coinbase_hash";
      $URL['cancel'] = $system['system_url'] . "/webhooks/coinbase.php?status=cancel";
      $_SESSION['wallet_replenish_amount'] = $price;
      break;

    case 'donate':
      $product = __($system['system_title']) . " " . __('Funding Donation');
      $description = __('Pay For') . " " . __($system['system_title']);
      $URL['success'] = $system['system_url'] . "/webhooks/coinbase.php?status=success&handle=donate&post_id=$id&coinbase_hash=$coinbase_hash";
      $URL['cancel'] = $system['system_url'] . "/webhooks/coinbase.php?status=cancel";
      $_SESSION['donation_amount'] = $price;
      break;

    case 'subscribe':
      $product = __($system['system_title']) . " " . __('Subscribe');
      $description = __('Pay For') . " " . __($system['system_title']);
      $URL['success'] = $system['system_url'] . "/webhooks/coinbase.php?status=success&handle=subscribe&plan_id=$id&coinbase_hash=$coinbase_hash";
      $URL['cancel'] = $system['system_url'] . "/webhooks/coinbase.php?status=cancel";
      break;

    case 'paid_post':
      $product = __($system['system_title']) . " " . __('Paid Post');
      $description = __('Pay For') . " " . __($system['system_title']);
      $URL['success'] = $system['system_url'] . "/webhooks/coinbase.php?status=success&handle=paid_post&post_id=$id&coinbase_hash=$coinbase_hash";
      $URL['cancel'] = $system['system_url'] . "/webhooks/coinbase.php?status=cancel";
      break;

    case 'movies':
      $product = __($system['system_title']) . " " . __('Movies');
      $description = __('Pay For') . " " . __($system['system_title']);
      $URL['success'] = $system['system_url'] . "/webhooks/coinbase.php?status=success&handle=movies&movie_id=$id&coinbase_hash=$coinbase_hash";
      $URL['cancel'] = $system['system_url'] . "/webhooks/coinbase.php?status=cancel";
      break;

    case 'marketplace':
      $product = __($system['system_title']) . " " . __('Marketplace');
      $description = __('Pay For') . " " . __($system['system_title']);
      $URL['success'] = $system['system_url'] . "/webhooks/coinbase.php?status=success&handle=marketplace&orders_collection_id=$id&coinbase_hash=$coinbase_hash";
      $URL['cancel'] = $system['system_url'] . "/webhooks/coinbase.php?status=cancel";
      break;

    default:
      _error(400);
      break;
  }
  $headers = [
    "content-type: application/json",
    "X-Cc-Api-Key: " . $system['coinbase_api_key'],
    "X-Cc-Version: " . "2018-03-22",
  ];
  $request_body =  [
    'name' =>  $product,
    'description' => $description,
    'pricing_type' => 'fixed_price',
    'local_price' => [
      'amount' => $total,
      'currency' => $system['system_currency']
    ],
    'metadata' => [
      'coinbase_hash' => $coinbase_hash
    ],
    "redirect_url" => $URL['success'],
    'cancel_url' => $URL['cancel']
  ];
  /* Coinbase */
  $ch = curl_init();
  curl_setopt($ch, CURLOPT_URL, 'https://api.commerce.coinbase.com/charges');
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
  curl_setopt($ch, CURLOPT_POST, 1);
  curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
  curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($request_body));
  $response = curl_exec($ch);
  $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
  if (curl_errno($ch)) {
    throw new Exception("Error Processing Request");
  }
  curl_close($ch);
  $responseJson = json_decode($response, true);
  return [
    "coinbase_hash" => $coinbase_hash,
    "coinbase_code" => $responseJson['data']['code'],
    "hosted_url" => $responseJson["data"]["hosted_url"]
  ];
}


/**
 * coinbase_check
 *
 * @param string $coinbase_code
 * @return boolean
 */
function coinbase_check($coinbase_code)
{
  global $system;
  /* prepare */
  $headers = [
    "content-type: application/json",
    "X-Cc-Api-Key: " . $system['coinbase_api_key'],
    "X-Cc-Version: " . "2018-03-22",
  ];
  /* Coinbase */
  $ch = curl_init();
  curl_setopt($ch, CURLOPT_URL, 'https://api.commerce.coinbase.com/charges/' . $coinbase_code);
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
  curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
  $response = curl_exec($ch);
  $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
  if (curl_errno($ch)) {
    return false;
  }
  curl_close($ch);
  $responseJson = json_decode($response, true);
  if (!empty($responseJson) && isset($responseJson['data']['payments'][0]['transaction_id']) && ($responseJson['data']['payments'][0]['status'] == 'confirmed' || $responseJson['data']['payments'][0]['status'] == 'pending')) {
    return true;
  }
  return false;
}



/* ------------------------------- */
/* Shift4 */
/* ------------------------------- */

/**
 * shift4
 *
 * @param string $price
 * @return string
 */
function shift4($price)
{
  global $system;
  $total = get_payment_total_value($price);
  $shift4 = new Shift4\Shift4Gateway($system['shift4_api_secret']);
  $checkoutCharge = new Shift4\Request\CheckoutRequestCharge();
  $checkoutCharge->amount($total * 100)->currency($system['system_currency']);
  $checkoutRequest = new Shift4\Request\CheckoutRequest();
  $checkoutRequest->charge($checkoutCharge);
  $signedCheckoutRequest = $shift4->signCheckoutRequest($checkoutRequest);
  return $signedCheckoutRequest;
}


/**
 * shift4_check
 *
 * @param string $charge_id
 * @return boolean
 */
function shift4_check($charge_id)
{
  global $system;
  /* Shift4 */
  $url = "https://api.shift4.com/charges?limit=10";
  $ch = curl_init($url);
  curl_setopt($ch, CURLOPT_URL, $url);
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
  curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);
  curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0);
  curl_setopt($ch, CURLOPT_USERPWD, $system['shift4_api_secret'] . ":password");
  $response = curl_exec($ch);
  $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
  if (curl_errno($ch)) {
    return false;
  }
  curl_close($ch);
  $responseJson = json_decode($response, true);
  if (!empty($responseJson) && $responseJson['list'][0]['id'] == $charge_id) {
    return true;
  }
  return false;
}



/* ------------------------------- */
/* MoneyPoolsCash */
/* ------------------------------- */

/**
 * moneypoolscash_payment_token
 *
 * @return string
 */
function moneypoolscash_payment_token()
{
  global $system;
  $headers = [
    'Content-Type: application/json',
    'API-KEY: ' . $system['moneypoolscash_api_key'],
  ];
  $request_body = [
    'merchant_email' => $system['moneypoolscash_merchant_email']
  ];
  $ch = curl_init();
  curl_setopt_array($ch, [
    CURLOPT_URL => 'https://moneypoolscash.com/gettoken?merchant_email=' . $system['moneypoolscash_merchant_email'],
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_ENCODING => '',
    CURLOPT_MAXREDIRS => 10,
    CURLOPT_TIMEOUT => 0,
    CURLOPT_FOLLOWLOCATION => true,
    CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
    CURLOPT_CUSTOMREQUEST => 'GET',
    CURLOPT_POSTFIELDS => json_encode($request_body),
    CURLOPT_HTTPHEADER => $headers,
  ]);
  $response = curl_exec($ch);
  $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
  if (curl_errno($ch)) {
    throw new Exception("Error Processing Request");
  }
  curl_close($ch);
  if ($httpCode != 200) {
    throw new Exception("Error Processing Request");
  }
  $response = json_decode($response, true);
  if ($response['status'] != 'success') {
    throw new Exception("Error Processing Request");
  }
  $token = $response['data']['token'];
  return $token;
}


/**
 * moneypoolscash_wallet_token
 *
 * @return string
 */
function moneypoolscash_wallet_token()
{
  global $system;
  $headers = [
    'Content-Type: application/json',
    'User-Agent: Delus',
    'API-KEY: ' . $system['moneypoolscash_api_key'],
  ];
  $request_body = [
    'user' => [
      'email' => $system['moneypoolscash_merchant_email'],
      'password' => $system['moneypoolscash_merchant_password']
    ],
  ];
  $ch = curl_init();
  curl_setopt_array($ch, [
    CURLOPT_URL => 'https://moneypoolscash.com/api/loginapp',
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_ENCODING => '',
    CURLOPT_MAXREDIRS => 10,
    CURLOPT_TIMEOUT => 0,
    CURLOPT_FOLLOWLOCATION => true,
    CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
    CURLOPT_CUSTOMREQUEST => 'POST',
    CURLOPT_POSTFIELDS => json_encode($request_body),
    CURLOPT_HTTPHEADER => $headers,
  ]);
  $response = curl_exec($ch);
  $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
  if (curl_errno($ch)) {
    throw new Exception("Error Processing Request");
  }
  curl_close($ch);
  if ($httpCode != 200) {
    throw new Exception("Error Processing Request");
  }
  $response = json_decode($response, true);
  if ($response['result'] != 'success') {
    throw new Exception("Error Processing Request");
  }
  $token = $response['token'];
  return $token;
}


/**
 * moneypoolscash
 *
 * @param string $handle
 * @param string $price
 * @param integer $id
 * @return string
 */
function moneypoolscash($handle, $price, $id = null)
{
  global $system;
  /* prepare */
  $total = get_payment_total_value($price);
  $token = moneypoolscash_payment_token();
  switch ($handle) {
    case 'packages':
      $URL['success'] = $system['system_url'] . "/webhooks/moneypoolscash.php?status=success&handle=packages&package_id=$id";
      $URL['cancel'] = $system['system_url'] . "/webhooks/moneypoolscash.php?status=cancel";
      break;

    case 'wallet':
      $URL['success'] = $system['system_url'] . "/webhooks/moneypoolscash.php?status=success&handle=wallet";
      $URL['cancel'] = $system['system_url'] . "/webhooks/moneypoolscash.php?status=cancel";
      $_SESSION['wallet_replenish_amount'] = $price;
      break;

    case 'donate':
      $URL['success'] = $system['system_url'] . "/webhooks/moneypoolscash.php?status=success&handle=donate&post_id=$id";
      $URL['cancel'] = $system['system_url'] . "/webhooks/moneypoolscash.php?status=cancel";
      $_SESSION['donation_amount'] = $price;
      break;

    case 'subscribe':
      $URL['success'] = $system['system_url'] . "/webhooks/moneypoolscash.php?status=success&handle=subscribe&plan_id=$id";
      $URL['cancel'] = $system['system_url'] . "/webhooks/moneypoolscash.php?status=cancel";
      break;

    case 'paid_post':
      $URL['success'] = $system['system_url'] . "/webhooks/moneypoolscash.php?status=success&handle=paid_post&post_id=$id";
      $URL['cancel'] = $system['system_url'] . "/webhooks/moneypoolscash.php?status=cancel";
      break;

    case 'movies':
      $URL['success'] = $system['system_url'] . "/webhooks/moneypoolscash.php?status=success&handle=movies&movie_id=$id";
      $URL['cancel'] = $system['system_url'] . "/webhooks/moneypoolscash.php?status=cancel";
      break;

    case 'marketplace':
      $URL['success'] = $system['system_url'] . "/webhooks/moneypoolscash.php?status=success&handle=marketplace&orders_collection_id=$id";
      $URL['cancel'] = $system['system_url'] . "/webhooks/moneypoolscash.php?status=cancel";
      break;

    default:
      _error(400);
      break;
  }
  /* make payment request */
  $merchant_ref = md5(time() . rand(1111, 9999));
  $headers = [
    'Content-Type: application/json',
    'API-KEY: ' . $system['moneypoolscash_api_key'],
    'token: ' . $token,
  ];
  $request_body = [
    'merchant_email' => $system['moneypoolscash_merchant_email'],
    'amount' => $total,
    'currency' => $system['system_currency'],
    'return_url' => $URL['success'],
    'cancel_url' => $URL['cancel'],
    'merchant_ref' => $merchant_ref,
  ];
  $ch = curl_init();
  curl_setopt_array($ch, [
    CURLOPT_URL => 'https://moneypoolscash.com/payrequest',
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_ENCODING => '',
    CURLOPT_MAXREDIRS => 10,
    CURLOPT_TIMEOUT => 0,
    CURLOPT_FOLLOWLOCATION => true,
    CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
    CURLOPT_CUSTOMREQUEST => 'GET',
    CURLOPT_POSTFIELDS => json_encode($request_body),
    CURLOPT_HTTPHEADER => $headers,
  ]);
  $response = curl_exec($ch);
  $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
  if (curl_errno($ch)) {
    throw new Exception("Error Processing Request");
  }
  curl_close($ch);
  if ($httpCode != 200) {
    throw new Exception("Error Processing Request");
  }
  $response = json_decode($response, true);
  $_SESSION['moneypoolscash_merchant_ref'] = $merchant_ref;
  $_SESSION['moneypoolscash_trx'] = $response['data']['trx'];
  return $response['data']['redirect_url'];
}


/**
 * moneypoolscash_check
 *
 * @return boolean
 */
function moneypoolscash_check()
{
  global $system;
  /* get token */
  $token = moneypoolscash_payment_token();
  $headers = [
    'Content-Type: application/json',
    'API-KEY: ' . $system['moneypoolscash_api_key'],
    'token: ' . $token,
  ];
  $request_body = [
    'merchant_email' => $system['moneypoolscash_merchant_email'],
    'trx' => $_SESSION['moneypoolscash_trx'],
    'merchant_ref' => $_SESSION['moneypoolscash_merchant_ref'],
  ];
  $ch = curl_init();
  curl_setopt_array($ch, [
    CURLOPT_URL => 'https://moneypoolscash.com/gettrx',
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_ENCODING => '',
    CURLOPT_MAXREDIRS => 10,
    CURLOPT_TIMEOUT => 0,
    CURLOPT_FOLLOWLOCATION => true,
    CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
    CURLOPT_CUSTOMREQUEST => 'GET',
    CURLOPT_POSTFIELDS => json_encode($request_body),
    CURLOPT_HTTPHEADER => $headers,
  ]);
  $response = curl_exec($ch);
  $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
  if (curl_errno($ch)) {
    return false;
  }
  curl_close($ch);
  if ($httpCode != 200) {
    return false;
  }
  $response = json_decode($response, true);
  if ($response['code'] == '200' && $response['status'] == 'completed') {
    return true;
  }
  return false;
}


/**
 * moneypoolscash_payout
 * 
 * @param string $amount
 * @param string $email
 * @return void
 */
function moneypoolscash_payout($amount, $email)
{
  global $system;
  /* get token */
  $token = moneypoolscash_wallet_token();
  $headers = [
    'Content-Type: application/json',
    'API-KEY: ' . $system['moneypoolscash_api_key'],
    'token: ' . $token,
    'email: ' . $system['moneypoolscash_merchant_email'],
  ];
  $request_body = [
    'toemail' => $email,
    'amount' => $amount,
    'currency' => $system['system_currency'],
  ];
  $ch = curl_init();
  curl_setopt_array($ch, [
    CURLOPT_URL => 'https://moneypoolscash.com/api/transferfunds',
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_ENCODING => '',
    CURLOPT_MAXREDIRS => 10,
    CURLOPT_TIMEOUT => 0,
    CURLOPT_FOLLOWLOCATION => true,
    CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
    CURLOPT_CUSTOMREQUEST => 'POST',
    CURLOPT_POSTFIELDS => json_encode($request_body),
    CURLOPT_HTTPHEADER => $headers,
  ]);
  $response = curl_exec($ch);
  $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
  if (curl_errno($ch)) {
    throw new Exception("Error Processing Request");
  }
  curl_close($ch);
  if ($httpCode != 200) {
    throw new Exception("Error Processing Request");
  }
  $response = json_decode($response, true);
  if ($response['code'] != '200') {
    throw new Exception($response['message']);
  }
}



/* ------------------------------- */
/* MyFatoorah */
/* ------------------------------- */

/**
 * myfatoorah
 *
 * @param string $handle
 * @param string $price
 * @param integer $id
 * @return string
 */
function myfatoorah($handle, $price, $id = null)
{
  global $system;
  /* prepare */
  $total = get_payment_total_value($price);
  switch ($handle) {
    case 'packages':
      $callback = $system['system_url'] . "/webhooks/myfatoorah.php?status=success&handle=packages&package_id=$id";
      break;

    case 'wallet':
      $callback = $system['system_url'] . "/webhooks/myfatoorah.php?status=success&handle=wallet";
      $_SESSION['wallet_replenish_amount'] = $price;
      break;

    case 'donate':
      $callback = $system['system_url'] . "/webhooks/myfatoorah.php?status=success&handle=donate&post_id=$id";
      $_SESSION['donation_amount'] = $price;
      break;

    case 'subscribe':
      $callback = $system['system_url'] . "/webhooks/myfatoorah.php?status=success&handle=subscribe&plan_id=$id";
      break;

    case 'paid_post':
      $callback = $system['system_url'] . "/webhooks/myfatoorah.php?status=success&handle=paid_post&post_id=$id";
      break;

    case 'movies':
      $callback = $system['system_url'] . "/webhooks/myfatoorah.php?status=success&handle=movies&movie_id=$id";
      break;

    case 'marketplace':
      $callback = $system['system_url'] . "/webhooks/myfatoorah.php?status=success&handle=marketplace&orders_collection_id=$id";
      break;

    default:
      _error(400);
      break;
  }
  /* MyFatoorah */
  $myfatoorah_api_url = ($system['myfatoorah_mode'] == "test") ? "https://apitest.myfatoorah.com/" : $system['myfatoorah_live_api_url'];
  $myfatoorah_token = ($system['myfatoorah_mode'] == "test") ? $system['myfatoorah_test_token'] : $system['myfatoorah_live_token'];
  $headers = [
    'Authorization: Bearer ' . $myfatoorah_token,
    'Content-Type: application/json',
  ];

  $request_body = [
    'InvoiceValue' => $total,
    'PaymentMethodId' => 2,
    'CallBackUrl' => $callback,
    'ErrorUrl' => $system['system_url'] . "/webhooks/myfatoorah.php?status=cancel",
  ];
  $ch = curl_init();
  curl_setopt($ch, CURLOPT_URL, $myfatoorah_api_url . 'v2/ExecutePayment');
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
  curl_setopt($ch, CURLOPT_POST, 1);
  curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
  curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($request_body));
  $response = curl_exec($ch);
  $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
  if (curl_errno($ch)) {
    throw new Exception("Error Processing Request");
  }
  curl_close($ch);
  if ($httpCode != 200) {
    throw new Exception("Error Processing Request");
  }
  $response = json_decode($response, true);
  return $response['Data']['PaymentURL'];
}


/**
 * myfatoorah_check
 *
 * @param string $payment_id
 * @return boolean
 */
function myfatoorah_check($payment_id)
{
  global $system;
  /* MyFatoorah */
  $myfatoorah_api_url = ($system['myfatoorah_mode'] == "test") ? "https://apitest.myfatoorah.com/" : $system['myfatoorah_live_api_url'];
  $myfatoorah_token = ($system['myfatoorah_mode'] == "test") ? $system['myfatoorah_test_token'] : $system['myfatoorah_live_token'];
  $headers = [
    'Authorization: Bearer ' . $myfatoorah_token,
    'Content-Type: application/json',
  ];
  $request_body = [
    'Key' => $payment_id,
    'KeyType' => 'PaymentId',
  ];
  $ch = curl_init();
  curl_setopt($ch, CURLOPT_URL, $myfatoorah_api_url . 'v2/GetPaymentStatus');
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
  curl_setopt($ch, CURLOPT_POST, 1);
  curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
  curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($request_body));
  $response = curl_exec($ch);
  $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
  if (curl_errno($ch)) {
    return false;
  }
  curl_close($ch);
  $response = json_decode($response, true);
  if ($response['Data']['InvoiceStatus'] == 'Paid') {
    return true;
  }
  return false;
}



/* ------------------------------- */
/* Epayco */
/* ------------------------------- */

function epayco_check($ref_payco, $price)
{
  global $system;
  $total = get_payment_total_value($price);
  $ch = curl_init();
  curl_setopt($ch, CURLOPT_URL, "https://secure.epayco.co/validation/v1/reference/$ref_payco");
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
  $response = curl_exec($ch);
  $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
  if (curl_errno($ch)) {
    return false;
  }
  curl_close($ch);
  $response = json_decode($response, true);
  if ($httpCode == 200 && $response['success'] && $response['data']['x_amount'] == $total) {
    /* check x_transaction_state */
    if ($response['data']['x_transaction_state'] == 'Aceptada') {
      return true;
    }
  }
  return false;
}



/* ------------------------------- */
/* Flutterwave */
/* ------------------------------- */

/**
 * flutterwave
 *
 * @param string $handle
 * @param string $price
 * @param integer $id
 * @return string
 */
function flutterwave($handle, $price, $id = null)
{
  global $system;
  /* prepare */
  $total = get_payment_total_value($price);
  switch ($handle) {
    case 'packages':
      $callback = $system['system_url'] . "/webhooks/flutterwave.php?state=success&handle=packages&package_id=$id";
      break;

    case 'wallet':
      $callback = $system['system_url'] . "/webhooks/flutterwave.php?state=success&handle=wallet";
      $_SESSION['wallet_replenish_amount'] = $price;
      break;

    case 'donate':
      $callback = $system['system_url'] . "/webhooks/flutterwave.php?state=success&handle=donate&post_id=$id";
      $_SESSION['donation_amount'] = $price;
      break;

    case 'subscribe':
      $callback = $system['system_url'] . "/webhooks/flutterwave.php?state=success&handle=subscribe&plan_id=$id";
      break;

    case 'paid_post':
      $callback = $system['system_url'] . "/webhooks/flutterwave.php?state=success&handle=paid_post&post_id=$id";
      break;

    case 'movies':
      $callback = $system['system_url'] . "/webhooks/flutterwave.php?state=success&handle=movies&movie_id=$id";
      break;

    case 'marketplace':
      $callback = $system['system_url'] . "/webhooks/flutterwave.php?state=success&handle=marketplace&orders_collection_id=$id";
      break;

    default:
      _error(400);
      break;
  }

  /* Flutterwave */
  $flutterwave_api_url = ($system['flutterwave_mode'] == "test") ? "https://api.flutterwave.com/v3/payments" : "https://api.flutterwave.com/v3/payments";
  $headers = [
    'Content-Type: application/json',
    'Authorization: ' . 'Bearer ' . $system['flutterwave_secret_key'],
  ];
  $request_body = [
    'tx_ref' => uniqid(),
    'amount' => $total,
    'currency' => $system['system_currency'],
    'redirect_url' => $callback,
    'customer' => [
      'email' => $system['system_email'],
      'phonenumber' => $system['system_phone'],
      'name' => $system['system_title'],
    ],
    'customizations' => [
      'title' => $system['system_title'],
      'description' => __("Pay For") . " " . $system['system_title'],
      'logo' => $system['system_logo'],
    ],
  ];

  $ch = curl_init();
  curl_setopt($ch, CURLOPT_URL, $flutterwave_api_url);
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
  curl_setopt($ch, CURLOPT_POST, 1);
  curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
  curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($request_body));
  $response = curl_exec($ch);
  $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
  if (curl_errno($ch)) {
    throw new Exception("Error Processing Request: " . curl_error($ch));
  }
  curl_close($ch);
  if ($httpCode != 200) {
    throw new Exception("Error Processing Request: HTTP $httpCode");
  }
  $response = json_decode($response, true);
  if (isset($response['data']['link'])) {
    return $response['data']['link'];
  } else {
    throw new Exception("Error Processing Request: " . json_encode($response));
  }
}



/**
 * flutterwave_check
 *
 * @param string $tx_ref
 * @param string $transaction_id
 * @return boolean
 */
function flutterwave_check($tx_ref, $transaction_id)
{
  global $system;
  /* Flutterwave */
  $flutterwave_api_url = ($system['flutterwave_mode'] == "test") ? "https://api.flutterwave.com/v3/transactions/$transaction_id/verify" : "https://api.flutterwave.com/v3/transactions/$transaction_id/verify";
  $headers = [
    'Content-Type: application',
    'Authorization: ' . 'Bearer ' . $system['flutterwave_secret_key'],
  ];
  $ch = curl_init();
  curl_setopt($ch, CURLOPT_URL, $flutterwave_api_url);
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
  curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
  $response = curl_exec($ch);
  $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
  if (curl_errno($ch)) {
    return false;
  }
  curl_close($ch);
  $response = json_decode($response, true);
  if ($httpCode == 200 && $response['status'] == 'success' && $response['data']['tx_ref'] == $tx_ref && $response['data']['status'] == 'successful') {
    return true;
  }
  return false;
}



/* ------------------------------- */
/* Verotel */
/* ------------------------------- */

/**
 * verotel
 *
 * @param string $handle
 * @param string $price
 * @param integer $id
 * @return string
 */
function verotel($handle, $price, $id = null)
{
  global $system;
  $total = get_payment_total_value($price);
  switch ($handle) {
    case 'packages':
      $customs = [
        "custom1" => "packages",
        'custom2' => $id,
      ];
      break;

    case 'wallet':
      $customs = [
        "custom1" => "wallet",
      ];
      $_SESSION['wallet_replenish_amount'] = $price;
      break;

    case 'donate':
      $customs = [
        "custom1" => "donate",
        'custom2' => $id,
      ];
      $_SESSION['donation_amount'] = $price;
      break;

    case 'subscribe':
      $customs = [
        "custom1" => "subscribe",
        'custom2' => $id,
      ];
      break;

    case 'paid_post':
      $customs = [
        "custom1" => "paid_post",
        'custom2' => $id,
      ];
      break;

    case 'movies':
      $customs = [
        "custom1" => "movies",
        'custom2' => $id,
      ];
      break;

    case 'marketplace':
      $customs = [
        "custom1" => "marketplace",
        'custom2' => $id,
      ];
      break;

    default:
      _error(400);
      break;
  }
  /* Verotel */
  $flexpayClient = new Verotel\FlexPay\Client($system['verotel_shop_id'], $system['verotel_signature_key']);
  $computed_signature = $flexpayClient->get_signature([
    'custom1' => $customs['custom1'],
    'custom2' => $customs['custom2'],
    'description' => $system['system_title'],
    'priceAmount' => $total,
    'priceCurrency' => $system['system_currency'],
    'shopID' => $system['verotel_shop_id'],
    'version' => 4,
    'type' => 'purchase',
  ]);
  $verotel_payment_url = $flexpayClient->get_purchase_URL([
    'custom1' => $customs['custom1'],
    'custom2' => $customs['custom2'],
    'description' => $system['system_title'],
    'priceAmount' => $total,
    'priceCurrency' => $system['system_currency'],
    'shopID' => $system['verotel_shop_id'],
    'version' => 4,
    'type' => 'purchase',
    'successURL' => $callback,
    'declineURL' => $system['system_url'],
    'signature' => $computed_signature,
  ]);
  return $verotel_payment_url;
}


/**
 * verotel_check
 *
 * @param string $saleID
 * @return boolean
 */
function verotel_check($saleID)
{
  global $system;
  /* Verotel */
  $flexpayClient = new Verotel\FlexPay\Client($system['verotel_shop_id'], $system['verotel_signature_key']);
  $statusURL = $flexpayClient->get_status_URL(['saleID' => $saleID]);
  $statusPageData = file_get_contents($statusURL);
  $statusPageData = Symfony\Component\Yaml\Yaml::parse(file_get_contents($statusURL));
  if ($statusPageData['saleResult'] == 'APPROVED') {
    return true;
  }
  return false;
}



/* ------------------------------- */
/* MercadoPago */
/* ------------------------------- */

/**
 * mercadopago
 *
 * @param string $handle
 * @param string $price
 * @param integer $id
 * @return string
 */
function mercadopago($handle, $price, $id = null)
{
  global $system, $user;
  $total = get_payment_total_value($price);
  switch ($handle) {
    case 'packages':
      $callback = $system['system_url'] . "/webhooks/mercadopago.php?status=success&handle=packages&package_id=$id";
      break;

    case 'wallet':
      $callback = $system['system_url'] . "/webhooks/mercadopago.php?status=success&handle=wallet";
      $_SESSION['wallet_replenish_amount'] = $price;
      break;

    case 'donate':
      $callback = $system['system_url'] . "/webhooks/mercadopago.php?status=success&handle=donate&post_id=$id";
      $_SESSION['donation_amount'] = $price;
      break;

    case 'subscribe':
      $callback = $system['system_url'] . "/webhooks/mercadopago.php?status=success&handle=subscribe&plan_id=$id";
      break;

    case 'paid_post':
      $callback = $system['system_url'] . "/webhooks/mercadopago.php?status=success&handle=paid_post&post_id=$id";
      break;

    case 'movies':
      $callback = $system['system_url'] . "/webhooks/mercadopago.php?status=success&handle=movies&movie_id=$id";
      break;

    case 'marketplace':
      $callback = $system['system_url'] . "/webhooks/mercadopago.php?status=success&handle=marketplace&orders_collection_id=$id";
      break;

    default:
      _error(400);
      break;
  }
  /* MercadoPago */
  $headers = [
    'Authorization: Bearer ' . $system['mercadopago_access_token'],
    'Content-Type: application/json',
  ];
  $metadata = [
    "handle" => $handle,
    "id" => $id,
    "user_id" => $user->_data['user_id'],
    "price" => $price,
  ];
  $request_body = [
    "payments_methods" => [
      "excluded_payment_methods" => [],
      "excluded_payment_types" => [],
      "installments" => 12,
      "default_payment_method_id" => "account_money",
    ],
    'items' => [
      [
        'title' => "Payment for $handle",
        'quantity' => 1,
        'unit_price' => intval(($total)),
        'currency_id' => $system['system_currency'],
      ]
    ],
    'payer' => [
      'email' => $user->_data['user_email'],
      'name' => $user->_data['user_firstname'] . ' ' . $user->_data['user_lastname'],
    ],
    'back_urls' => [
      'success' => $callback,
      'failure' => $system['system_url'] . '/payment_status/failure',
      'pending' => $system['system_url'] . '/payment_status/pending',
    ],
    "metadata" => $metadata,
    'notification_url' => $system['system_url'] . "/webhooks/mercadopago_callbak.php",
    'auto_return' => 'approved'
  ];
  $ch = curl_init();
  curl_setopt($ch, CURLOPT_URL, "https://api.mercadopago.com/checkout/preferences");
  curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
  curl_setopt($ch, CURLOPT_POST, 1);
  curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($request_body));
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
  $response = curl_exec($ch);
  $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
  if (curl_errno($ch)) {
    throw new Exception("Error Processing Request");
  }
  curl_close($ch);
  $responseJson = json_decode($response, true);
  if (!isset($responseJson['init_point'])) {
    throw new Exception("Mercado Pago Error: " . json_encode($responseJson));
  }
  return $responseJson['init_point'];
}


/**
 * mercadopago_check
 *
 * @param string $payment_id
 * @return boolean
 */
function mercadopago_check($payment_id)
{
  global $system;
  $headers = [
    'Authorization: Bearer ' . $system['mercadopago_access_token'],
    'Content-Type: application/json',
  ];
  $ch = curl_init();
  curl_setopt($ch, CURLOPT_URL, "https://api.mercadopago.com/v1/payments/$payment_id");
  curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
  $response = curl_exec($ch);
  $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
  if (curl_errno($ch)) {
    return false;
  }
  curl_close($ch);
  $responseJson = json_decode($response, true);
  if ($httpCode == 200 && $responseJson['status'] == 'approved') {
    return $responseJson;
  }
  return false;
}



/* ------------------------------- */
/* User Access */
/* ------------------------------- */

/**
 * user_access
 *
 * @param boolean $is_ajax
 * @param boolean $bypass_subscription
 * @param boolean $bypass_getting_started
 * @param integer $oauth_app_id
 * @return void
 */
function user_access($is_ajax = false, $bypass_subscription = false, $bypass_getting_started = false, $oauth_app_id = null)
{
  global $user, $system;
  if ($is_ajax) {
    /* check user logged in */
    if (!$user->_logged_in) {
      modal('LOGIN');
    }
    /* check user activated */
    if ($system['activation_enabled'] && !$user->_data['user_activated']) {
      modal("MESSAGE", __("Not Activated"), __("Before you can interact with other users, you need to confirm your email address"));
    }
    /* check user approval */
    if ($system['users_approval_enabled'] && !$user->_data['user_approved'] && $user->_data['user_group'] >= '3') {
      modal("MESSAGE", __("Approval Needed"), __("Before you can interact with other users, you need to get approved by the admin"));
    }
    /* check user getted started */
    if ($system['getting_started'] && !$user->_data['user_started'] && !$bypass_getting_started) {
      modal("MESSAGE", __("Getting Started"), __("Before you can interact with other users, you need to complete your profile"));
    }
    /* check registration type */
    if ($system['registration_type'] == "paid" && $user->_data['user_group'] > '1' && !$user->_data['user_subscribed'] && !$bypass_subscription) {
      modal("MESSAGE", __("Subscription Needed"), __("Before you can interact with other users, you need to buy subscription package"));
    }
  } else {
    if (!$user->_logged_in) {
      user_login($oauth_app_id);
    }
    /* check user activated */
    if ($system['activation_enabled'] && $system['activation_required'] && !$user->_data['user_activated']) {
      _error('ACTIVATION');
    }
    /* check user approval */
    if ($system['users_approval_enabled'] && !$user->_data['user_approved'] && $user->_data['user_group'] >= '3') {
      _error('APPROVAL');
    }
    /* check user getted started */
    if ($system['getting_started'] && !$user->_data['user_started'] && !$bypass_getting_started) {
      redirect('/started');
    }
    /* check registration type */
    if ($system['registration_type'] == "paid" && $user->_data['user_group'] > '1' && !$user->_data['user_subscribed'] && !$bypass_subscription) {
      redirect('/packages');
    }
    /* check callback_redirect */
    if ($_SESSION['callback_redirect']) {
      $callback_redirect = $_SESSION['callback_redirect'];
      unset($_SESSION['callback_redirect']);
      redirect($callback_redirect);
    }
  }
}


/**
 * user_login
 *
 * @param integer $oauth_app_id
 * @return void
 */
function user_login($oauth_app_id = null)
{
  global $user, $smarty;
  $smarty->assign('highlight', __("You must sign in to see this page"));
  $smarty->assign('genders', $user->get_genders());
  $smarty->assign('custom_fields', $user->get_custom_fields());
  if ($system['select_user_group_enabled']) {
    $smarty->assign('user_groups', $user->get_users_groups());
  }
  if ($oauth_app_id) {
    $smarty->assign('oauth_app_id', $oauth_app_id);
  }
  /* check if the current url is not the main url */
  if ($_SERVER['REQUEST_URI'] != "/") {
    $_SESSION['callback_redirect'] = $_SERVER['REQUEST_URI'];
  }
  page_header(__("Sign in"));
  page_footer('sign');
  exit;
}


/**
 * referer_url
 *
 * @return void
 */
function referer_url()
{
  /* get the referer URL */
  $referer_url = isset($_SERVER['HTTP_REFERER']) ? $_SERVER['HTTP_REFERER'] : '';
  /* get the request URI from the referer URL */
  $referer_url = parse_url($referer_url, PHP_URL_PATH);
  /* validate and sanitize */
  if (!empty($referer_url) && $referer_url != "/") {
    /* disallowed paths */
    $disallowed = ['/favicon.ico', '/robots.txt', '/socket.io'];
    if (!in_array($referer_url, $disallowed) && strpos($referer_url, "/") === 0) {
      $_SESSION['callback_redirect'] = $referer_url;
    }
  }
}



/* ------------------------------- */
/* Modal */
/* ------------------------------- */

/**
 * modal
 *
 * @return json
 */
function modal()
{
  $args = func_get_args();
  switch ($args[0]) {
    case 'LOGIN':
      return_json(["callback" => "modal('#modal-login')"]);
      break;
    case 'MESSAGE':
      return_json(["callback" => "modal('#modal-message', {title: '" . $args[1] . "', message: '" . addslashes($args[2]) . "'})"]);
      break;
    case 'ERROR':
      return_json(["callback" => "modal('#modal-error', {title: '" . $args[1] . "', message: '" . addslashes($args[2]) . "'})"]);
      break;
    case 'SUCCESS':
      return_json(["callback" => "modal('#modal-success', {title: '" . $args[1] . "', message: '" . addslashes($args[2]) . "'})"]);
      break;
    case 'INFO':
      return_json(["callback" => "modal('#modal-info', {title: '" . $args[1] . "', message: '" . addslashes($args[2]) . "'})"]);
      break;
    default:
      if (isset($args[1])) {
        return_json(["callback" => "modal('" . $args[0] . "', " . $args[1] . ")"]);
      } else {
        return_json(["callback" => "modal('" . $args[0] . "')"]);
      }
      break;
  }
}



/* ------------------------------- */
/* Popover */
/* ------------------------------- */

/**
 * popover
 *
 * @param integer $uid
 * @param string $username
 * @param string $name
 * @return string
 */
function popover($uid, $username, $name)
{
  global $system;
  $popover = '<span class="js_user-popover" data-uid="' . $uid . '"><a href="' . $system['system_url'] . '/' . $username . '">' . $name . '</a></span>';
  return $popover;
}



/* ------------------------------- */
/* Page */
/* ------------------------------- */

/**
 * page_header
 *
 * @param string $title
 * @param string $description
 * @return void
 */
function page_header($title, $description = '', $image = '')
{
  global $smarty, $system;
  $description = ($description != '') ? $description : __($system['system_description']);
  if ($image == '') {
    if ($system['system_ogimage']) {
      $image = $system['system_uploads'] . '/' . $system['system_ogimage'];
    } else {
      $image = $system['system_url'] . '/content/themes/' . $system['theme'] . '/images/og-image.jpg';
    }
  }
  $smarty->assign('page_title', $title);
  $smarty->assign('page_description', $description);
  $smarty->assign('page_image', $image);
}


/**
 * page_footer
 *
 * @param string $page
 * @return void
 */
function page_footer($page)
{
  global $smarty;
  $smarty->assign('page', $page);
  $smarty->display("$page.tpl");
}



/* ------------------------------- */
/* Post Feelings */
/* ------------------------------- */

/**
 * get_feelings
 *
 * @return array
 */
function get_feelings()
{
  $feelings = [
    ["icon" => "grinning-face-with-smiling-eyes",  "action" => "Feeling",      "text" => __("Feeling"),      "placeholder" => __("How are you feeling?")],
    ["icon" => "headphone",                        "action" => "Listening To", "text" => __("Listening To"), "placeholder" => __("What are you listening to?")],
    ["icon" => "glasses",                          "action" => "Watching",     "text" => __("Watching"),     "placeholder" => __("What are you watching?")],
    ["icon" => "video-game",                       "action" => "Playing",      "text" => __("Playing"),      "placeholder" => __("What are you playing?")],
    ["icon" => "shortcake",                        "action" => "Eating",       "text" => __("Eating"),       "placeholder" => __("What are you eating?")],
    ["icon" => "tropical-drink",                   "action" => "Drinking",     "text" => __("Drinking"),     "placeholder" => __("What are you drinking?")],
    ["icon" => "airplane",                         "action" => "Traveling To", "text" => __("Traveling To"), "placeholder" => __("Where are you going?")],
    ["icon" => "books",                            "action" => "Reading",      "text" => __("Reading"),      "placeholder" => __("What are you reading?")],
    ["icon" => "calendar",                         "action" => "Attending",    "text" => __("Attending"),    "placeholder" => __("What are you attending?")],
    ["icon" => "birthday-cake",                    "action" => "Celebrating",  "text" => __("Celebrating"),  "placeholder" => __("What are you celebrating?")],
    ["icon" => "magnifying-glass-tilted-left",     "action" => "Looking For",  "text" => __("Looking For"),  "placeholder" => __("What are you looking for?")]
  ];
  return $feelings;
}


/**
 * get_feelings_types
 *
 * @return array
 */
function get_feelings_types()
{
  $feelings_types = [
    ["icon" => "grinning-face-with-smiling-eyes",  "action" => "Happy",      "text" => __("Happy")],
    ["icon" => "smiling-face-with-heart-eyes",     "action" => "Loved",      "text" => __("Loved")],
    ["icon" => "relieved-face",                    "action" => "Satisfied",  "text" => __("Satisfied")],
    ["icon" => "flexed-biceps",                    "action" => "Strong",     "text" => __("Strong")],
    ["icon" => "disappointed-face",                "action" => "Sad",        "text" => __("Sad")],
    ["icon" => "winking-face-with-tongue",         "action" => "Crazy",      "text" => __("Crazy")],
    ["icon" => "downcast-face-with-sweat",         "action" => "Tired",      "text" => __("Tired")],
    ["icon" => "sleeping-face",                    "action" => "Sleepy",     "text" => __("Sleepy")],
    ["icon" => "confused-face",                    "action" => "Confused",   "text" => __("Confused")],
    ["icon" => "worried-face",                     "action" => "Worried",    "text" => __("Worried")],
    ["icon" => "angry-face",                       "action" => "Angry",      "text" => __("Angry")],
    ["icon" => "pouting-face",                     "action" => "Annoyed",    "text" => __("Annoyed")],
    ["icon" => "face-with-open-mouth",             "action" => "Shocked",    "text" => __("Shocked")],
    ["icon" => "pensive-face",                     "action" => "Down",       "text" => __("Down")],
    ["icon" => "confounded-face",                  "action" => "Confounded", "text" => __("Confounded")]
  ];
  return $feelings_types;
}


/**
 * get_feeling_icon
 *
 * @param string $needle
 * @param array $array
 * @param string $key
 * @return string
 */
function get_feeling_icon($needle, $array, $key = "action")
{
  foreach ($array as $_key => $_val) {
    if ($_val[$key] === $needle) {
      return $array[$_key]['icon'];
    }
  }
  return false;
}



/* ------------------------------- */
/* Censored Words */
/* ------------------------------- */

/**
 * censored_words
 *
 * @param string $text
 * @return string
 */
function censored_words($text)
{
  global $system;
  if ($system['censored_words_enabled'] && $text) {
    $bad_words = explode(',', trim($system['censored_words']));
    if ($bad_words) {
      foreach ($bad_words as $word) {
        $word = trim($word);
        $pattern = '/\b' . $word . '\b/iu';
        $text = preg_replace($pattern, str_repeat('*', strlen($word)), $text);
      }
    }
  }
  return $text;
}



/* ------------------------------- */
/* Images */
/* ------------------------------- */

/**
 * get_picture
 *
 * @param string $picture
 * @param string $type
 * @param array $system
 * @return string
 */
function get_picture($picture, $type, $system = null)
{
  if ($system == null) {
    global $system;
  }
  if ($picture == "") {
    switch ($type) {
      case 'page':
        $picture = $system['system_url'] . '/content/themes/' . $system['theme'] . '/images/blank_page.png';
        break;

      case 'group':
        $picture = $system['system_url'] . '/content/themes/' . $system['theme'] . '/images/blank_group.png';
        break;

      case 'event':
        $picture = $system['system_url'] . '/content/themes/' . $system['theme'] . '/images/blank_event.png';
        break;

      case 'blog':
        $picture = $system['system_url'] . '/content/themes/' . $system['theme'] . '/images/blank_blog.png';
        break;

      case 'movie':
        $picture = $system['system_url'] . '/content/themes/' . $system['theme'] . '/images/blank_movie.png';
        break;

      case 'game':
        $picture = $system['system_url'] . '/content/themes/' . $system['theme'] . '/images/blank_game.png';
        break;

      case 'package':
        $picture = $system['system_url'] . '/content/themes/' . $system['theme'] . '/images/blank_package.png';
        break;

      case 'flag':
        $picture = $system['system_url'] . '/content/themes/' . $system['theme'] . '/images/blank_flag.png';
        break;

      case 'system':
        $picture = $system['system_url'] . '/content/themes/' . $system['theme'] . '/images/svg/dashboard.svg';
        break;

      case 'static_page_icon':
        $picture = $system['system_url'] . '/content/themes/' . $system['theme'] . '/images/svg/dashboard.svg';
        break;

      case '1':
        $picture = $system['system_url'] . '/content/themes/' . $system['theme'] . '/images/blank_profile_male.png';
        break;

      case '2':
        $picture = $system['system_url'] . '/content/themes/' . $system['theme'] . '/images/blank_profile_female.png';
        break;

      default:
        $picture = $system['system_url'] . '/content/themes/' . $system['theme'] . '/images/blank_profile.png';
        break;
    }
  } else {
    $picture = $system['system_uploads'] . '/' . $picture;
  }
  return $picture;
}


/**
 * reassemble_file_chunks
 * 
 * @param string $temp_directory
 * @param string $file_guid
 * @param string $file_name
 * @param int $totalChunks
 * @param string $final_file_path
 * @return void
 */
function reassemble_file_chunks($temp_directory, $file_guid, $file_name, $totalChunks, $final_file_path)
{
  $final_file = fopen($final_file_path, 'wb');
  if ($final_file === false) {
    throw new Exception(__("Could not create final file"));
  }
  for ($i = 0; $i < $totalChunks; $i++) {
    $chunk_file = $temp_directory . $file_guid . '_' . $file_name . ".part-" . $i;
    if (!file_exists($chunk_file)) {
      fclose($final_file);
      throw new Exception(__("Missing chunk file"));
    }
    $chunk_handle = fopen($chunk_file, 'rb');
    if ($chunk_handle === false) {
      fclose($final_file);
      throw new Exception(__("Could not open chunk file"));
    }
    while (!feof($chunk_handle)) {
      $buffer = fread($chunk_handle, 8192); // Read in 8KB chunks
      if ($buffer === false) {
        fclose($chunk_handle);
        fclose($final_file);
        throw new Exception(__("Error reading chunk file"));
      }
      if (fwrite($final_file, $buffer) === false) {
        fclose($chunk_handle);
        fclose($final_file);
        throw new Exception(__("Error writing to final file"));
      }
    }
    fclose($chunk_handle);
    unlink($chunk_file);
  }
  fclose($final_file);
}


/**
 * save_picture_from_url
 *
 * @param string $file
 * @param boolean $cropped
 * @return string
 */
function save_picture_from_url($file, $cropped = false, $resize = false)
{
  global $system;
  /* check & create uploads dir */
  $folder = 'photos';
  $directory = $folder . '/' . date('Y') . '/' . date('m') . '/';
  // init image & prepare image name & path
  require_once(ABSPATH . 'includes/class-image.php');
  $image = new Image($file);
  $prefix = $system['uploads_prefix'] . '_' . get_hash_token();
  if ($cropped) {
    $image_name = $directory . $prefix . "_cropped" . $image->_img_ext;
    if ($resize) {
      $image->resizeWidth($_POST['resize_width']);
    }
    $_POST['width'] = (isset($_POST['width'])) ? $_POST['width'] : $image->getWidth();
    $_POST['height'] = (isset($_POST['height'])) ? $_POST['height'] : $image->getHeight();
    $image->crop($_POST['width'], $_POST['height'], $_POST['x'], $_POST['y']);
  } else {
    $image_name = $directory . $prefix . $image->_img_ext;
  }
  $path = ABSPATH . $system['uploads_directory'] . '/' . $image_name;
  /* set uploads directory */
  if (!file_exists(ABSPATH . $system['uploads_directory'] . '/' . $folder)) {
    @mkdir(ABSPATH . $system['uploads_directory'] . '/' . $folder, 0777, true);
  }
  if (!file_exists(ABSPATH . $system['uploads_directory'] . '/' . $folder . '/' . date('Y'))) {
    @mkdir(ABSPATH . $system['uploads_directory'] . '/' . $folder . '/' . date('Y'), 0777, true);
  }
  if (!file_exists($system['uploads_directory'] . '/' . $folder . '/' . date('Y') . '/' . date('m'))) {
    @mkdir(ABSPATH . $system['uploads_directory'] . '/' . $folder . '/' . date('Y') . '/' . date('m'), 0777, true);
  }
  /* save the new image */
  $image->save($path, $system['uploads_quality']);
  /* cloud storage */
  save_file_to_cloud($path, $image_name);
  return $image_name;
}


/**
 * watermark_image
 *
 * @param string $image_path
 * @param string $image_type
 * @return void
 */
function watermark_image($image_path, $image_type)
{
  global $system, $user;
  try {
    $image = new claviska\SimpleImage();
    $image->fromFile($image_path)->autoOrient();
    if ($system['watermark_type'] == "icon") {
      /* watermark using icon */
      if (!is_empty($system['watermark_icon'])) {
        $image->overlay(
          $system['system_uploads'] . "/" . $system['watermark_icon'],
          $system['watermark_position'],
          $system['watermark_opacity'],
          $system['watermark_xoffset'],
          $system['watermark_yoffset']
        );
        $image->toFile($image_path, $image_type);
      }
    } else {
      /* watermark using user name */
      $username = parse_url($system['system_url'], PHP_URL_HOST) . '/' . $user->_data['user_name'];
      $font_file = ABSPATH . 'content/themes/' . $system['theme'] . '/fonts/Poppins/Poppins-Regular.ttf';
      $font_size = 20;
      $color = '#ffffff';
      $angle = 135;
      $width = $image->getWidth() * 1.5;
      $height = $image->getHeight() * 1.5;
      /* create a new image with the text */
      $text_image = new claviska\SimpleImage();
      $text_image->fromNew($width, $height, 'transparent');
      /* estimate the width and height of the text box */
      $bbox = imagettfbbox($font_size, 0, $font_file, $username);
      $text_width = abs($bbox[4] - $bbox[0]);
      $text_height = abs($bbox[5] - $bbox[1]);
      $spacing = 30;
      /* draw the repeated text */
      for ($x = -$width; $x < $width * 1.5; $x += $text_width + $spacing) {
        for ($y = -$height; $y < $height * 1.5; $y += $text_height + $spacing) {
          $text_image->text($username, [
            'fontFile' => $font_file,
            'size' => $font_size,
            'color' => $color,
            'anchor' => 'top left',
            'xOffset' => $x,
            'yOffset' => $y
          ]);
        }
      }
      /* rotate the text image */
      $text_image->rotate($angle, 'transparent');
      /* flip the text image */
      $text_image->flip('both');
      /* overlay this text image on the original image */
      $image->overlay($text_image, 'center', $system['watermark_opacity']);
      $image->toFile($image_path, $image_type);
    }
  } catch (Exception $e) {
    return $e->getMessage();
  }
}


/**
 * blur_image
 *
 * @param string $image_path
 * @param string $image_type
 * @return void
 */
function blur_image($image_path, $image_type)
{
  global $system;
  try {
    $image = new claviska\SimpleImage();
    $image->fromFile($image_path)->autoOrient();
    $image->blur('gaussian', 25);
    $image->toFile($image_path, $image_type);
  } catch (Exception $e) {
    return $e->getMessage();
  }
}



/* ------------------------------- */
/* Socket.io */
/* ------------------------------- */

/**
 * socket_certificate_test
 *
 * @return bool
 */
function socket_certificate_test()
{
  global $system;
  $certificate_path = $system['chat_socket_ssl_crt'] ?? null;
  $key_path = $system['chat_socket_ssl_key'] ?? null;
  if (!$certificate_path || !$key_path) {
    throw new Exception(__("Certificate or key path is not configured"));
  }
  if (!file_exists($certificate_path)) {
    throw new Exception(sprintf(__("Certificate file not found: %s"), $certificate_path));
  }
  if (!file_exists($key_path)) {
    throw new Exception(sprintf(__("Key file not found: %s"), $key_path));
  }
  if (!is_readable($certificate_path)) {
    throw new Exception(sprintf(__("Certificate file not readable: %s"), $certificate_path));
  }
  if (!is_readable($key_path)) {
    throw new Exception(sprintf(__("Key file not readable: %s"), $key_path));
  }
  return true;
}

/**
 * socket_io_action
 *
 * @param string $action
 * @return string
 */
function socket_io_action($action)
{
  global $system;
  $php_path = $system['php_bin_path'];
  $script_path = __DIR__ . '/../sockets/' . $system['chat_socket_server'] . '/socket.php';
  switch ($action) {
    case 'status':
      $response = shell_exec("$php_path $script_path status 2>&1");
      break;
    case 'start':
      $response = shell_exec("$php_path $script_path start -d 2>&1");
      break;
    case 'stop':
      $response = shell_exec("$php_path $script_path stop 2>&1");
      break;
  }
  return $response;
}


/**
 * get_all_sockets_user_ids
 *
 * @param object $io
 * @return array
 */
function get_all_sockets_user_ids($io)
{
  return array_unique(array_column($io->sockets->sockets, 'userId')) ?? [];
}


/**
 * get_all_sockets_by_user_id
 *
 * @param object $io
 * @param int $user_id
 * @return array
 */
function get_all_sockets_by_user_id($io, $user_id)
{
  $sockets = [];
  foreach ($io->sockets->sockets as $socketId => $socket) {
    if (isset($socket->userId) && $socket->userId == $user_id) {
      $sockets[$socketId] = $socket;
    }
  }
  return $sockets;
}


/**
 * handle_typing_change
 *
 * @param object $io
 * @param string $room
 * @param object $socket
 * @param object $user
 * @param boolean $is_typing
 * @return void
 */
function handle_typing_change($io, $room, $socket, $user, $is_typing)
{
  $conversation_id = str_replace('conversation_', '', $room);
  $user_display_name = html_entity_decode(($GLOBALS['system']['show_usernames_enabled']) ? $user->_data['user_name'] : $user->_data['user_firstname'],    ENT_QUOTES);
  init_room_typing_list($room);
  if ($is_typing) {
    add_typing_user($room, $socket->userId, $user_display_name);
  } else {
    remove_typing_user($room, $socket->userId);
  }
  /* broadcast typing list to other users in the room */
  $room_clients = $io->sockets->in($room)->sockets;
  foreach ($room_clients as $client) {
    if (!isset($client->userId)) continue;
    $other_typing_users = array_diff_key($GLOBALS['room_typing_list'][$room], [$client->userId => null]);
    $typing_name_list = implode(', ', $other_typing_users);
    $client->emit('event_server_typing', [
      'conversation_id' => $conversation_id,
      'typing_name_list' => $typing_name_list
    ]);
  }
  print("💬 [Emit] User {username: {$socket->username}, user_id: {$socket->userId}} Room: $room - Typing: " . ($is_typing ? 'true' : 'false') . "\n");
  /* cleanup empty room typing list */
  cleanup_empty_room_typing_list($room);
  /* update typing status */
  $user->update_conversation_typing_status($conversation_id, $is_typing);
}


/**
 * init_room_typing_list
 *
 * @param string $room
 * @return void
 */
function init_room_typing_list($room)
{
  if (!isset($GLOBALS['room_typing_list'][$room])) {
    $GLOBALS['room_typing_list'][$room] = [];
  }
}

/**
 * add_typing_user
 *
 * @param string $room
 * @param int $user_id
 * @param string $user_display_name
 * @return void
 */
function add_typing_user($room, $user_id, $user_display_name)
{
  if (!isset($GLOBALS['room_typing_list'][$room][$user_id])) {
    $GLOBALS['room_typing_list'][$room][$user_id] = $user_display_name;
  }
}


/**
 * remove_typing_user
 *
 * @param string $room
 * @param int $user_id
 * @return void
 */
function remove_typing_user($room, $user_id)
{
  if (isset($GLOBALS['room_typing_list'][$room][$user_id])) {
    unset($GLOBALS['room_typing_list'][$room][$user_id]);
  }
}


/**
 * clean_room_typing_list
 *
 * @param string $room
 * @return void
 */
function cleanup_empty_room_typing_list($room)
{
  if (empty($GLOBALS['room_typing_list'][$room])) {
    unset($GLOBALS['room_typing_list'][$room]);
  }
}


/**
 * cleanup_user_typing_list
 *
 * @param object $socket
 * @return array
 */
function cleanup_user_typing_list($socket)
{
  $affected_rooms = [];
  /* get only conversation rooms */
  $conversation_rooms = array_filter($socket->rooms, function ($room) {
    return strpos($room, 'conversation_') === 0;
  });
  /* filter only the typing rooms that match conversation rooms */
  $typing_rooms = array_intersect_key($GLOBALS['room_typing_list'], array_flip($conversation_rooms));
  /* get all rooms that the user is typing in */
  foreach ($typing_rooms as $room => &$typing_users) {
    if (isset($typing_users[$socket->userId])) {
      $affected_rooms[] = $room;
    }
  }
  return $affected_rooms;
}



/* ------------------------------- */
/* Utilities */
/* ------------------------------- */

/**
 * __
 *
 * @param string $string
 *
 * @return string
 */
function __($text)
{
  global $gettextTranslator;
  if (!$text) {
    return '';
  }
  if (!$gettextTranslator) {
    return $text;
  }
  $translation = $gettextTranslator->find('', $text);
  if (!$translation) {
    return $text;
  }
  $translated_text = $translation->getTranslation($text);
  return ($translated_text) ? $translated_text : $text;
}


/**
 * _getallheaders
 *
 * @return array
 */
function _getallheaders()
{
  return array_change_key_case(getallheaders(), CASE_LOWER);
}


/**
 * minimize_css
 *
 * @param string $file_path
 * @return string
 */
function minimize_css($file_path)
{
  global $smarty;
  $css = $smarty->fetch($file_path);
  if (empty($css)) {
    return $css;
  }
  // normalize whitespace.
  $css = preg_replace('/\s+/', ' ', $css);
  // remove spaces before and after comment.
  $css = preg_replace('/(\s+)(\/\*(.*?)\*\/)(\s+)/', '$2', $css);
  // remove all comments
  $css = preg_replace('/\/\*(.*?)\*\//', '', $css);
  // remove ; before }.
  $css = preg_replace('/;(?=\s*})/', '', $css);
  // remove space after , : ; { } */ >.
  $css = preg_replace('/(,|:|;|\{|}|\*\/|>) /', '$1', $css);
  // remove space before , ; { } ( ) >.
  $css = preg_replace('/ (,|;|\{|}|\(|\)|>)/', '$1', $css);
  // strips leading 0 on decimal values (converts 0.5px into .5px).
  $css = preg_replace('/(:| )0\.([0-9]+)(%|em|ex|px|in|cm|mm|pt|pc)/i', '${1}.${2}${3}', $css);
  // strips units if value is 0 (converts 0px to 0).
  $css = preg_replace('/(:| )(\.?)0(%|em|ex|px|in|cm|mm|pt|pc)/i', '${1}0', $css);
  // converts all zeros value into short-hand.
  $css = preg_replace('/0 0 0 0/', '0', $css);
  // shortern 6-character hex color codes to 3-character where possible.
  $css = preg_replace('/#([a-f0-9])\\1([a-f0-9])\\2([a-f0-9])\\3/i', '#\1\2\3', $css);
  // ensure 'and', 'or', and 'not' keywords in media queries are correctly spaced.
  $css = preg_replace('/(?<!:)\b(and|or|not)\(/', '$1 (', $css);
  return trim($css);
}


/**
 * get_user_ip
 *
 * @return string
 */
function get_user_ip()
{
  /* check various proxy headers in order of preference */
  $headers = [
    'HTTP_CF_CONNECTING_IP', // CloudFlare
    'HTTP_X_FORWARDED_FOR',  // Standard proxy header
    'HTTP_X_REAL_IP',        // Nginx proxy header
    'HTTP_CLIENT_IP',        // Client IP header
    'REMOTE_ADDR'            // Fallback to remote address
  ];
  foreach ($headers as $header) {
    if (isset($_SERVER[$header])) {
      /* if X-Forwarded-For contains multiple IPs, get the first one */
      if ($header === 'HTTP_X_FORWARDED_FOR') {
        $ips = explode(',', $_SERVER[$header]);
        return trim($ips[0]);
      }
      return $_SERVER[$header];
    }
  }
  /* fallback to REMOTE_ADDR if no headers are found */
  return $_SERVER['REMOTE_ADDR'];
}


/**
 * get_user_os
 *
 * @return string
 */
function get_user_os()
{
  $os_platform = "Unknown OS Platform";
  if (!isset($_SERVER['HTTP_USER_AGENT'])) {
    return $os_platform;
  }
  $os_array = [
    '/windows nt 10/i'      =>  'Windows 10',
    '/windows nt 6.3/i'     =>  'Windows 8.1',
    '/windows nt 6.2/i'     =>  'Windows 8',
    '/windows nt 6.1/i'     =>  'Windows 7',
    '/windows nt 6.0/i'     =>  'Windows Vista',
    '/windows nt 5.2/i'     =>  'Windows Server 2003/XP x64',
    '/windows nt 5.1/i'     =>  'Windows XP',
    '/windows xp/i'         =>  'Windows XP',
    '/windows nt 5.0/i'     =>  'Windows 2000',
    '/windows me/i'         =>  'Windows ME',
    '/win98/i'              =>  'Windows 98',
    '/win95/i'              =>  'Windows 95',
    '/win16/i'              =>  'Windows 3.11',
    '/macintosh|mac os x/i' =>  'Mac OS X',
    '/mac_powerpc/i'        =>  'Mac OS 9',
    '/linux/i'              =>  'Linux',
    '/ubuntu/i'             =>  'Ubuntu',
    '/iphone/i'             =>  'iPhone',
    '/ipod/i'               =>  'iPod',
    '/ipad/i'               =>  'iPad',
    '/android/i'            =>  'Android',
    '/blackberry/i'         =>  'BlackBerry',
    '/webos/i'              =>  'Mobile'
  ];
  foreach ($os_array as $regex => $value) {
    if (preg_match($regex, $_SERVER['HTTP_USER_AGENT'])) {
      $os_platform = $value;
    }
  }
  return $os_platform;
}


/**
 * get_user_browser
 *
 * @return string
 */
function get_user_browser()
{
  $browser = "Unknown Browser";
  if (!isset($_SERVER['HTTP_USER_AGENT'])) {
    return $browser;
  }
  $browser_array = [
    '/msie/i'       =>  'Internet Explorer',
    '/firefox/i'    =>  'Firefox',
    '/safari/i'     =>  'Safari',
    '/chrome/i'     =>  'Chrome',
    '/edge/i'       =>  'Edge',
    '/opera/i'      =>  'Opera',
    '/netscape/i'   =>  'Netscape',
    '/maxthon/i'    =>  'Maxthon',
    '/konqueror/i'  =>  'Konqueror',
    '/mobile/i'     =>  'Handheld Browser'
  ];
  foreach ($browser_array as $regex => $value) {
    if (preg_match($regex, $_SERVER['HTTP_USER_AGENT'])) {
      $browser = $value;
    }
  }
  return $browser;
}


/**
 * get_user_language_country
 *
 * @return string
 */
function get_user_language_country()
{
  if (empty($_SERVER['HTTP_ACCEPT_LANGUAGE'])) {
    return ['language' => null, 'country' => null];
  }
  $languages = explode(',', $_SERVER['HTTP_ACCEPT_LANGUAGE']);
  $primary = strtolower(explode(';', $languages[0])[0]);
  $primary = str_replace('-', '_', $primary);
  /* force 'ar' to 'ar_sa' */
  if (strpos($primary, 'ar') === 0) {
    return ['language' => 'ar_sa', 'country' => 'SA'];
  }
  /* ensure language has a country code */
  if (!strpos($primary, '_')) {
    $primary .= "_$primary";
  }
  return [
    'language' => $primary,
    'country' => strtoupper(explode('_', $primary)[1])
  ];
}


/**
 * get_user_age
 *
 * @param string $birthdate
 * @return string
 */
function get_user_age($birthdate)
{
  if ($birthdate === null) {
    return null;
  }
  $birthdate = DateTime::createFromFormat('Y-m-d', $birthdate);
  if ($birthdate === false) {
    return null;
  }
  $today = new DateTime('today');
  $age = $today->diff($birthdate)->y;
  return $age;
}


/**
 * get_extension
 *
 * @param string $path
 * @return string
 */
function get_extension($path)
{
  return strtolower(pathinfo($path, PATHINFO_EXTENSION));
}


/**
 * get_origin_url
 *
 * @param string $url
 * @return string
 */
function get_origin_url($url)
{
  stream_context_set_default([
    'http' => [
      'ignore_errors' => true,
      'method' => 'HEAD',
      'user_agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36',
    ]
  ]);
  $headers = get_headers($url, 1);
  if ($headers !== false && (isset($headers['location']) || isset($headers['Location']))) {
    $location = (isset($headers['location'])) ? $headers['location'] : $headers['Location'];
    return is_array($location) ? array_pop($location) : $location;
  }
  return $url;
}


/**
 * get_base_domain
 *
 * @param string $url
 * @return string
 */
function get_base_domain($url)
{
  $url = parse_url($url);
  $host = $url['host'];
  $host = explode('.', $host);
  $count = count($host);
  if ($count > 2) {
    $host = $host[$count - 2] . '.' . $host[$count - 1];
  } else {
    $host = $host[0] . '.' . $host[1];
  }
  return $host;
}


/**
 * decode_urls
 *
 * @param string $text
 * @return string
 */
function decode_urls($text)
{
  $text = ($text) ? preg_replace('/(https?:\/\/[^\s]+)/', "<a target='_blank' rel='nofollow' href=\"$1\">$1</a>", $text) : $text;
  return $text;
}


/**
 * get_url_text
 *
 * @param string $string
 * @param integer $length
 * @return string
 */
function get_url_text($string, $length = 10)
{
  $string = html_entity_decode($string, ENT_QUOTES);
  $string = htmlspecialchars_decode($string, ENT_QUOTES);
  $string = preg_replace('/[^\\pL\d]+/u', '-', $string);
  $string = trim($string, '-');
  $words = explode("-", $string);
  if (count($words) > $length) {
    $string = "";
    for ($i = 0; $i < $length; $i++) {
      $string .= "-" . $words[$i];
    }
    $string = trim($string, '-');
  }
  return $string;
}


/**
 * remove_querystring_var
 *
 * @param string $url
 * @param string $key
 * @return string
 */
function remove_querystring_var($url, $key)
{
  $url = preg_replace('/(.*)(?|&)' . $key . '=[^&]+?(&)(.*)/i', '$1$2$4', $url . '&');
  $url = substr($url, 0, -1);
  return $url;
}


/**
 * get_snippet_text
 *
 * @param string $string
 * @return string
 */
function get_snippet_text($string)
{
  $string = htmlspecialchars_decode($string, ENT_QUOTES);
  $string = strip_tags($string);
  return $string;
}


/**
 * get_tag
 *
 * @param string $string
 * @return string
 */
function get_tag($string)
{
  $string = trim($string);
  $string = preg_replace('/\s+/', '_', $string);
  return $string;
}


/**
 * get_youtube_id
 *
 * @param string $url
 * @param boolean $embed
 * @return string
 */
function get_youtube_id($url, $embed = true)
{
  if ($embed) {
    preg_match('/youtube\.com\/embed\/([^\&\?\/]+)/', $url, $id);
    return $id[1];
  } else {
    parse_str(parse_url($url, PHP_URL_QUERY), $id);
    return $id['v'];
  }
}


/**
 * get_vimeo_id
 *
 * @param string $url
 * @return string
 */
function get_vimeo_id($url)
{
  return (int) substr(parse_url($url, PHP_URL_PATH), 1);
}


/**
 * get_video_type
 *
 * @param string $url
 * @return string
 */
function get_video_type($url)
{
  if (strpos($url, 'youtube') > 0) {
    return 'youtube';
  } elseif (strpos($url, 'vimeo') > 0) {
    return 'vimeo';
  } else {
    return 'link';
  }
}


/**
 * get_array_key
 *
 * @param array $array
 * @param integer $current
 * @param integer $offset
 * @return mixed
 */
function get_array_key($array, $current, $offset = 1)
{
  $keys = array_keys($array);
  $index = array_search($current, $keys);
  if (isset($keys[$index + $offset])) {
    return $keys[$index + $offset];
  }
  return false;
}


/**
 * print_money
 *
 * @param string $amount
 * @param string $symbol
 * @param string $dir
 * @return string
 */

function print_money($amount, $symbol = null, $dir = null)
{
  global $system;
  $symbol = ($symbol) ? $symbol : $system['system_currency_symbol'];
  $dir = ($dir) ? $dir : $system['system_currency_dir'];
  if ($dir == "right") {
    return $amount . $symbol;
  } else {
    return $symbol . $amount;
  }
}


/**
 * abbreviate_count
 *
 * @param int $count
 * @return string
 */
function abbreviate_count($count)
{
  if ($count < 1000) {
    return $count;
  } elseif ($count < 1000000) {
    return round($count / 1000) . __('K');
  } else {
    return round($count / 1000000) . __('M');
  }
}
