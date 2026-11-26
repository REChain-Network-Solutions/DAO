<?php

/**
 * functions
 * 
 * @package Sngine
 * @author Zamblek
 */


/* ------------------------------- */
/* Includes */
/* ------------------------------- */

require(__DIR__ . '/functions-cache.php');
require(__DIR__ . '/functions-storage.php');
require(__DIR__ . '/functions-ffmpeg.php');
require(__DIR__ . '/functions-images.php');
require(__DIR__ . '/functions-sockets.php');
require(__DIR__ . '/functions-system.php');
require(__DIR__ . '/functions-errors.php');
require(__DIR__ . '/functions-messaging.php');
require(__DIR__ . '/functions-design.php');


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
  $required_php_version = '8.4';
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
  /* check if openssl enabled */
  if (!extension_loaded('openssl') || !function_exists('openssl_verify')) {
    $errors['openssl'] = true;
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
 * LicenceVerifyException
 * 
 * A refusal from the licence API, carrying its error code (e.g. license_invalid).
 */
if (!class_exists('LicenceVerifyException')) {
  class LicenceVerifyException extends Exception
  {
    public $licence_error_code = '';
  }
}


/**
 * get_licence_key
 * 
 * @param string $code
 * @param string $context
 * @param string|null $version
 * @return array
 */
function get_licence_key($code, $context = 'install', $version = null)
{
  $url = 'https://zamblek.com/api/v1/licenses/verify';
  $request = [
    'product' => 'sngine',
    'code' => $code,
    'domain' => $_SERVER['HTTP_HOST'] ?? '',
    'context' => $context,
  ];
  if ($version !== null && $version !== '') {
    $request['version'] = (string) $version;
  }
  $payload = json_encode($request);
  $ch = curl_init();
  curl_setopt($ch, CURLOPT_URL, $url);
  curl_setopt($ch, CURLOPT_POST, 1);
  curl_setopt($ch, CURLOPT_POSTFIELDS, $payload);
  curl_setopt($ch, CURLOPT_HTTPHEADER, [
    'Content-Type: application/json',
    'Accept: application/json',
  ]);
  curl_setopt($ch, CURLOPT_USERAGENT, 'Mozilla/5.0 (Windows NT 5.1; rv:5.0) Gecko/20100101 Firefox/5.0 Firefox/5.0');
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
  curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 5);
  curl_setopt($ch, CURLOPT_TIMEOUT, 10);
  curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
  curl_setopt($ch, CURLOPT_MAXREDIRS, 10);
  $response = curl_exec($ch);
  $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
  $curlError = curl_error($ch);
  if ($curlError || $httpCode == 503) {
    $hint = $curlError ? ' (' . $curlError . ')' : '';
    throw new Exception("License verification is temporarily unavailable. Please try again." . $hint);
  }
  $responseJson = json_decode($response, true);
  if (!is_array($responseJson)) {
    throw new Exception("License verification failed. Please try again.");
  }
  if (!empty($responseJson['valid'])) {
    licence_validate_payload($responseJson);
    return $responseJson;
  }
  if (!empty($responseJson['error']['message'])) {
    $message = $responseJson['error']['message'];
    if (!empty($responseJson['error']['code'])) {
      $message .= ' Error Code #' . $responseJson['error']['code'];
    }
    $exception = new LicenceVerifyException($message);
    $exception->licence_error_code = (string) ($responseJson['error']['code'] ?? '');
    throw $exception;
  }
  if (!empty($responseJson['message'])) {
    throw new Exception($responseJson['message']);
  }
  throw new Exception("License verification failed. Please try again.");
}


/**
 * licence_normalize_domain
 * 
 * @param string $domain
 * @return string
 */
function licence_normalize_domain($domain)
{
  $domain = strtolower(trim((string) $domain));
  $domain = preg_replace('#^https?://#', '', $domain);
  $domain = explode('/', $domain)[0];
  $domain = explode(':', $domain)[0];
  if (str_starts_with($domain, 'www.')) {
    $domain = substr($domain, 4);
  }
  return $domain;
}


/**
 * licence_ksort_recursive
 * 
 * @param array $data
 * @return array
 */
function licence_ksort_recursive($data)
{
  if (!is_array($data)) {
    return $data;
  }
  ksort($data);
  foreach ($data as $key => $value) {
    if (is_array($value)) {
      $data[$key] = licence_ksort_recursive($value);
    }
  }
  return $data;
}


/**
 * licence_canonical_json
 * 
 * @param array $payload
 * @return string|false
 */
function licence_canonical_json($payload)
{
  $claims = [
    'product' => $payload['product'] ?? null,
    'domain' => $payload['domain'] ?? null,
    'license_type' => $payload['license_type'] ?? null,
    'entitlements' => $payload['entitlements'] ?? null,
    'issued_at' => $payload['issued_at'] ?? null,
    'expires_at' => $payload['expires_at'] ?? null,
  ];
  return json_encode(licence_ksort_recursive($claims), JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
}


/**
 * licence_public_key
 * 
 * @return \OpenSSLAsymmetricKey
 */
function licence_public_key()
{
  static $key = null;
  if ($key !== null) {
    return $key;
  }
  $pem = __DIR__ . '/public.pem';
  if (!is_file($pem)) {
    throw new Exception("License verification failed.");
  }
  $key = openssl_pkey_get_public(file_get_contents($pem));
  if ($key === false) {
    throw new Exception("License verification failed.");
  }
  return $key;
}


/**
 * licence_validate_integrity
 * 
 * @param array $payload
 * @return void
 */
function licence_validate_integrity($payload)
{
  if (!is_array($payload) || empty($payload['signature'])) {
    throw new Exception("License verification failed.");
  }
  $canonical = licence_canonical_json($payload);
  $signature = base64_decode($payload['signature'], true);
  if ($canonical === false || $signature === false) {
    throw new Exception("License verification failed.");
  }
  $verified = openssl_verify($canonical, $signature, licence_public_key(), OPENSSL_ALGO_SHA256);
  if ($verified !== 1) {
    throw new Exception("License verification failed.");
  }
  if (($payload['product'] ?? '') !== 'sngine') {
    throw new Exception("License verification failed.");
  }
}


/**
 * licence_validate_payload
 * 
 * @param array $payload
 * @param string|null $host
 * @return void
 */
function licence_validate_payload($payload, $host = null)
{
  licence_validate_integrity($payload);
  $expiresAt = strtotime($payload['expires_at'] ?? '');
  if ($expiresAt === false || $expiresAt <= time()) {
    throw new Exception("License verification expired. Please try again.");
  }
  $host = $host ?? ($_SERVER['HTTP_HOST'] ?? '');
  if ($host === '' && defined('SYS_URL')) {
    $host = SYS_URL;
  }
  $current = licence_normalize_domain($host);
  $signed = licence_normalize_domain($payload['domain'] ?? '');
  if ($current === '' || $signed === '' || $current !== $signed) {
    throw new Exception("License domain does not match this site.");
  }
}


/**
 * licence_store_payload
 * 
 * @param array $payload
 * @return void
 */
function licence_store_payload($payload)
{
  licence_validate_payload($payload);
  $json = json_encode($payload, JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
  if ($json === false) {
    throw new Exception("Unable to save the license file");
  }
  $contents = '<?php' . "\n\n" . '/**' . "\n" . ' * Auto-generated licence payload. Do not edit.' . "\n" . ' */' . "\n\n" . 'if (!defined(\'ABSPATH\')) {' . "\n" . '  return false;' . "\n" . '}' . "\n\n" . 'return json_decode(' . var_export($json, true) . ', true);' . "\n";
  $file = __DIR__ . '/sys_verif.php';
  if (file_put_contents($file, $contents) === false) {
    throw new Exception("Unable to save the license file");
  }
  if (function_exists('opcache_invalidate')) {
    @opcache_invalidate($file, true);
  }
  /* a licence without monetization (cancelled monthly plan, expired subscription, Regular) loses the module */
  if (empty($payload['entitlements']['monetization']) && licence_module_present()) {
    licence_remove_monetization_module();
  }
}


/**
 * licence_write_config
 *
 * @param string $licence_key
 * @return void
 */
function licence_write_config($licence_key)
{
  $file = __DIR__ . '/config.php';
  if (!is_file($file) || !is_writable($file)) {
    throw new Exception("Unable to write the config file");
  }
  $contents = file_get_contents($file);
  if ($contents === false) {
    throw new Exception("Unable to write the config file");
  }
  $define = 'define("LICENCE_KEY", ' . var_export((string) $licence_key, true) . ')';
  $pattern = '/define\(\s*([\'"])LICENCE_KEY\1\s*,\s*(([\'"]).*?(?<!\\\\)\3|[^)]*)\s*\)/s';
  if (preg_match($pattern, $contents)) {
    $contents = preg_replace_callback($pattern, function () use ($define) {
      return $define;
    }, $contents, 1);
  } elseif (preg_match('/\?>\s*$/', $contents)) {
    $contents = preg_replace_callback('/\?>\s*$/', function () use ($define) {
      return $define . ";\n?>\n";
    }, $contents, 1);
  } else {
    $contents = rtrim($contents) . "\n" . $define . ";\n";
  }
  if (file_put_contents($file, $contents, LOCK_EX) === false) {
    throw new Exception("Unable to write the config file");
  }
  if (function_exists('opcache_invalidate')) {
    @opcache_invalidate($file, true);
  }
}


/**
 * licence_load_payload
 * 
 * @param boolean $strict
 * @param boolean $reset
 * @return array|false
 */
function licence_load_payload($strict = false, $reset = false)
{
  static $payload = false;
  static $integrity_error = null;
  static $loaded = false;
  if ($reset) {
    $payload = false;
    $integrity_error = null;
    $loaded = false;
    return false;
  }
  if (!$loaded) {
    $loaded = true;
    $file = __DIR__ . '/sys_verif.php';
    if (!is_file($file)) {
      $integrity_error = new Exception("License verification failed.");
    } else {
      $data = include $file;
      try {
        licence_validate_integrity($data);
        try {
          licence_validate_payload($data);
          $payload = $data;
        } catch (Exception $e) {
          /* expiry or domain — entitlements off, file is authentic */
        }
      } catch (Exception $e) {
        $integrity_error = $e;
      }
    }
  }
  if ($strict && $integrity_error) {
    throw $integrity_error;
  }
  return $payload;
}


/**
 * licence_reset_payload_cache
 * 
 * @return void
 */
function licence_reset_payload_cache()
{
  licence_load_payload(false, true);
}


/**
 * licence_refresh_if_needed
 * 
 * @return void
 */
function licence_refresh_if_needed()
{
  if (!defined('LICENCE_KEY') || LICENCE_KEY === '') {
    return;
  }
  $file = __DIR__ . '/sys_verif.php';
  if (!is_file($file)) {
    return;
  }
  $cooldown = __DIR__ . '/sys_verif.refresh';
  if (is_file($cooldown) && filemtime($cooldown) > time() - 3600) {
    return;
  }
  $data = include $file;
  if (!is_array($data)) {
    return;
  }
  try {
    licence_validate_integrity($data);
  } catch (Exception $e) {
    return;
  }
  $expiresAt = strtotime($data['expires_at'] ?? '');
  if ($expiresAt === false || $expiresAt > time() + 86400) {
    return;
  }
  @touch($cooldown);
  try {
    $fresh = get_licence_key(LICENCE_KEY, 'admin');
    licence_store_payload($fresh);
    licence_reset_payload_cache();
    @unlink($cooldown);
  } catch (LicenceVerifyException $e) {
    /* a definitive refusal after the stored payload lapsed removes the module; outages never do */
    if ($expiresAt <= time() && in_array($e->licence_error_code, licence_revoking_error_codes(), true) && licence_module_present()) {
      licence_remove_monetization_module();
    }
  } catch (Exception $e) {
    /* keep cooldown; entitlements follow the existing expiry path */
  }
}


/**
 * licence_revoking_error_codes
 * 
 * Licence API refusals that mean the licence no longer covers monetization.
 * 
 * @return array
 */
function licence_revoking_error_codes()
{
  return ['license_invalid', 'license_canceled', 'license_wrong_item', 'account_suspended', '505'];
}


/**
 * licence_has_entitlement
 * 
 * @param string $name
 * @return boolean
 */
function licence_has_entitlement($name)
{
  $payload = licence_load_payload();
  if (!$payload) {
    return false;
  }
  return !empty($payload['entitlements'][$name]);
}


/**
 * licence_module_installed
 * 
 * @return boolean
 */
function licence_module_installed()
{
  static $installed = null;
  if ($installed === null) {
    /* development checkout keeps the source */
    $current = is_dir(ABSPATH . '.dev') || (defined('MONETIZATION_VER') && MONETIZATION_VER === SYS_VER);
    $installed = $current && !licence_module_missing_files();
  }
  return $installed;
}


/**
 * licence_module_present
 *
 * @return boolean
 */
function licence_module_present()
{
  return count(licence_module_missing_files()) < count(licence_module_paths());
}


/**
 * licence_module_missing_files
 *
 * @return array
 */
function licence_module_missing_files()
{
  $missing = [];
  foreach (licence_module_paths() as $rel) {
    if (!is_file(ABSPATH . $rel)) {
      $missing[] = $rel;
    }
  }
  return $missing;
}


/**
 * licence_zip_entry_allowed
 * 
 * @param string $name
 * @return boolean
 */
function licence_zip_entry_allowed($name)
{
  $name = str_replace('\\', '/', (string) $name);
  if ($name === '' || str_contains($name, '..')) {
    return false;
  }
  if (str_starts_with($name, '/') || preg_match('#^[a-zA-Z]:/#', $name)) {
    return false;
  }
  $normalized = strtolower($name);
  if ($normalized === 'includes/config.php' || $normalized === 'includes/sys_verif.php') {
    return false;
  }
  $root = rtrim(str_replace('\\', '/', ABSPATH), '/');
  $dest = $root . '/' . $name;
  if ($dest !== $root && !str_starts_with($dest, $root . '/')) {
    return false;
  }
  return true;
}


/**
 * licence_clear_compiled_templates
 * 
 * @return void
 */
function licence_clear_compiled_templates()
{
  foreach ((array) glob(ABSPATH . 'content/themes/*/templates_compiled', GLOB_ONLYDIR) as $dir) {
    if (!is_dir($dir)) {
      continue;
    }
    $items = new RecursiveIteratorIterator(
      new RecursiveDirectoryIterator($dir, FilesystemIterator::SKIP_DOTS),
      RecursiveIteratorIterator::CHILD_FIRST
    );
    foreach ($items as $item) {
      if ($item->isDir()) {
        @rmdir($item->getPathname());
      } else {
        @unlink($item->getPathname());
      }
    }
  }
}


/**
 * licence_api_error_message
 * 
 * @param array $responseJson
 * @return string
 */
function licence_api_error_message($responseJson)
{
  if (!empty($responseJson['error']['message'])) {
    $message = $responseJson['error']['message'];
    if (!empty($responseJson['error']['code'])) {
      $message .= ' Error Code #' . $responseJson['error']['code'];
    }
    return $message;
  }
  if (!empty($responseJson['message'])) {
    return $responseJson['message'];
  }
  return __("License verification failed. Please try again.");
}


/**
 * licence_is_zip_file
 * 
 * @param string $path
 * @return boolean
 */
function licence_is_zip_file($path)
{
  $fh = @fopen($path, 'rb');
  if ($fh === false) {
    return false;
  }
  $magic = fread($fh, 4);
  fclose($fh);
  return is_string($magic) && str_starts_with($magic, 'PK');
}


/**
 * licence_curl_to_file
 * 
 * @param string $url
 * @param string $dest
 * @param string|null $postBody
 * @return array{0:int,1:string}
 */
function licence_curl_to_file($url, $dest, $postBody = null)
{
  $fp = fopen($dest, 'w+b');
  if ($fp === false) {
    throw new Exception(__("Unable to write the module zip. Make sure content/backups is writable."));
  }
  $ch = curl_init();
  curl_setopt($ch, CURLOPT_URL, $url);
  curl_setopt($ch, CURLOPT_FILE, $fp);
  curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
  curl_setopt($ch, CURLOPT_MAXREDIRS, 10);
  curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 10);
  curl_setopt($ch, CURLOPT_TIMEOUT, 120);
  curl_setopt($ch, CURLOPT_USERAGENT, 'Mozilla/5.0 (Windows NT 5.1; rv:5.0) Gecko/20100101 Firefox/5.0 Firefox/5.0');
  if ($postBody !== null) {
    curl_setopt($ch, CURLOPT_POST, 1);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $postBody);
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
      'Content-Type: application/json',
      'Accept: application/zip, application/json',
    ]);
  }
  $ok = curl_exec($ch);
  $httpCode = (int) curl_getinfo($ch, CURLINFO_HTTP_CODE);
  $contentType = (string) curl_getinfo($ch, CURLINFO_CONTENT_TYPE);
  $curlError = curl_error($ch);
  fclose($fp);
  if (!$ok || $curlError || $httpCode == 503) {
    @unlink($dest);
    $hint = $curlError ? ' (' . $curlError . ')' : '';
    throw new Exception("License verification is temporarily unavailable. Please try again." . $hint);
  }
  return [$httpCode, $contentType];
}


/**
 * licence_download_module
 * 
 * @param string $module
 * @param string|null $licence_key
 * @return string
 */
function licence_download_module($module = 'monetization', $licence_key = null)
{
  if ($licence_key === null) {
    $licence_key = defined('LICENCE_KEY') ? LICENCE_KEY : '';
  }
  if ($licence_key === '') {
    throw new Exception(__("No license key found."));
  }
  $backups = ABSPATH . 'content/backups';
  if (!is_dir($backups) && !@mkdir($backups, 0777, true) && !is_dir($backups)) {
    throw new Exception(__("Unable to write the module zip. Make sure content/backups is writable."));
  }
  $url = 'https://zamblek.com/api/v1/licenses/modules/download';
  $tmp = $backups . '/sngine-monetization-download-' . time() . '.zip';
  $body = json_encode([
    'product' => 'sngine',
    'code' => $licence_key,
    'domain' => $_SERVER['HTTP_HOST'] ?? '',
    'module' => $module,
  ]);
  [$httpCode] = licence_curl_to_file($url, $tmp, $body);
  if (licence_is_zip_file($tmp) && $httpCode >= 200 && $httpCode < 300) {
    return $tmp;
  }
  $raw = @file_get_contents($tmp);
  @unlink($tmp);
  $json = json_decode((string) $raw, true);
  if (is_array($json) && !empty($json['url']) && is_string($json['url'])) {
    $tmp = $backups . '/sngine-monetization-download-' . time() . '.zip';
    [$httpCode] = licence_curl_to_file($json['url'], $tmp, null);
    if (licence_is_zip_file($tmp) && $httpCode >= 200 && $httpCode < 300) {
      return $tmp;
    }
    @unlink($tmp);
    throw new Exception(__("License verification failed. Please try again."));
  }
  if (is_array($json)) {
    throw new Exception(licence_api_error_message($json));
  }
  throw new Exception(__("License verification failed. Please try again."));
}


/**
 * licence_install_module_zip
 * 
 * @param string $zip_path
 * @return array
 */
function licence_install_module_zip($zip_path)
{
  $backups = ABSPATH . 'content/backups';
  if (!is_dir($backups) && !@mkdir($backups, 0777, true) && !is_dir($backups)) {
    throw new Exception(__("Unable to write the module zip. Make sure content/backups is writable."));
  }
  $zip_name = 'sngine-monetization-v' . SYS_VER . '.zip';
  $keep = $backups . '/' . $zip_name;
  $keep_rel = 'content/backups/' . $zip_name;
  if (!class_exists('ZipArchive')) {
    if (!is_file($zip_path)) {
      throw new Exception(__("Unable to open the module zip."));
    }
    if (realpath($zip_path) !== realpath($keep)) {
      if (!@rename($zip_path, $keep) && !@copy($zip_path, $keep)) {
        throw new Exception(__("Unable to write the module zip. Make sure content/backups is writable."));
      }
      if (is_file($zip_path) && realpath($zip_path) !== realpath($keep)) {
        @unlink($zip_path);
      }
    }
    return [
      'extracted' => false,
      'path' => $keep_rel,
      'message' => sprintf(__("PHP ZipArchive is not available. Unzip %s over the site root, then reload this page."), $keep_rel),
    ];
  }
  $zip = new ZipArchive();
  if ($zip->open($zip_path) !== true) {
    throw new Exception(__("Unable to open the module zip."));
  }
  $extracted = 0;
  for ($i = 0; $i < $zip->numFiles; $i++) {
    $name = $zip->getNameIndex($i);
    if ($name === false) {
      continue;
    }
    $name = str_replace('\\', '/', $name);
    if (str_ends_with($name, '/')) {
      continue;
    }
    if (!licence_zip_entry_allowed($name)) {
      continue;
    }
    $dest = ABSPATH . ltrim($name, '/');
    $dir = dirname($dest);
    if (!is_dir($dir) && !@mkdir($dir, 0777, true) && !is_dir($dir)) {
      $zip->close();
      throw new Exception(__("Unable to extract the module files."));
    }
    $contents = $zip->getFromIndex($i);
    if ($contents === false || file_put_contents($dest, $contents) === false) {
      $zip->close();
      throw new Exception(__("Unable to extract the module files."));
    }
    if (function_exists('opcache_invalidate')) {
      @opcache_invalidate($dest, true);
    }
    $extracted++;
  }
  $zip->close();
  @unlink($zip_path);
  licence_clear_compiled_templates();
  return [
    'extracted' => true,
    'count' => $extracted,
    'message' => __("Payments and monetization files are installed."),
  ];
}


/**
 * licence_admin_lock
 * 
 * @return array
 */
function licence_admin_lock()
{
  global $system, $control_panel;
  $panel = (!empty($control_panel['url'])) ? $control_panel['url'] : 'admincp';
  $url = $system['system_url'] . '/' . $panel . '/license';
  if (licence_has_entitlement('monetization')) {
    return [
      'type' => 'success',
      'title' => __("You can enable this feature with your current license."),
      'text' => __("All you need to do is visit the License page to verify that the required files are installed."),
      'url' => $url,
    ];
  }
  return [
    'type' => 'error',
    'title' => __("Sorry, you can't enable this feature with your current license."),
    'text' => __("You can check your license status from the License page."),
    'url' => $url,
  ];
}


/**
 * licence_throw_admin_lock
 * 
 * @return void
 */
function licence_throw_admin_lock()
{
  $lock = licence_admin_lock();
  throw new Exception($lock['title'] . ' ' . $lock['text'] . ' <a href="' . htmlentities($lock['url'], ENT_QUOTES, 'UTF-8') . '">' . __("License page") . '</a>');
}


/**
 * licence_premium_option_names
 * 
 * @return array
 */
function licence_premium_option_names()
{
  return [
    'ai_text_credit_enabled',
    'ai_image_credit_enabled',
    'paypal_enabled',
    'paypal_payouts_enabled',
    'creditcard_enabled',
    'alipay_enabled',
    'cashapp_enabled',
    'blik_enabled',
    'eps_enabled',
    'ideal_enabled',
    'bancontact_enabled',
    'przelewy24_enabled',
    'oxxo_enabled',
    'stripe_payment_element_enabled',
    'paystack_enabled',
    'iyzico_enabled',
    '2checkout_enabled',
    'authorize_net_enabled',
    'razorpay_enabled',
    'cashfree_enabled',
    'shift4_enabled',
    'myfatoorah_enabled',
    'epayco_enabled',
    'flutterwave_enabled',
    'verotel_enabled',
    'mercadopago_enabled',
    'plisio_enabled',
    'coinpayments_enabled',
    'coinbase_enabled',
    'ccbill_enabled',
    'bank_transfers_enabled',
    'ads_enabled',
    'wallet_enabled',
    'packages_enabled',
    'affiliates_money_transfer_enabled',
    'points_money_transfer_enabled',
    'paid_blogs_enabled',
    'paid_products_enabled',
    'paid_funding_enabled',
    'paid_offers_enabled',
    'paid_jobs_enabled',
    'paid_courses_enabled',
    'market_shopping_cart_enabled',
    'market_digital_products_enabled',
    'market_wallet_payment_enabled',
    'market_cod_payment_enabled',
    'market_money_withdraw_enabled',
    'market_money_transfer_enabled',
    'funding_enabled',
    'monetization_enabled',
    'tips_enabled',
  ];
}


/**
 * licence_turn_off_premium_options
 * 
 * @return void
 */
function licence_turn_off_premium_options()
{
  $premium_off = [];
  foreach (licence_premium_option_names() as $option_name) {
    $premium_off[$option_name] = secure('0');
  }
  update_system_options($premium_off, false);
}


/**
 * licence_module_paths
 * 
 * The Payments & Monetization module files, removed when the licence no longer
 * includes monetization. The list between the markers is regenerated from
 * .dev/deployment/monetization_files.json by zamblek.sh; do not edit it by hand.
 * 
 * @return array
 */
function licence_module_paths()
{
  return [
    /* monetization-paths:start */
    'content/themes/nova/templates/_js_templates.payments.tpl',
    'content/themes/nova/templates/admin.ads.users.tpl',
    'content/themes/nova/templates/admin.bank.tpl',
    'content/themes/nova/templates/admin.coinpayments.tpl',
    'content/themes/nova/templates/admin.earnings.tpl',
    'content/themes/nova/templates/admin.funding.tpl',
    'content/themes/nova/templates/admin.monetization.tpl',
    'content/themes/nova/templates/admin.paid_modules.tpl',
    'content/themes/nova/templates/admin.pro.tpl',
    'content/themes/nova/templates/admin.settings.ai.credit.tpl',
    'content/themes/nova/templates/admin.settings.payments.tpl',
    'content/themes/nova/templates/admin.tips.tpl',
    'content/themes/nova/templates/admin.wallet.tpl',
    'content/themes/nova/js/admin-earnings.js',
    'includes/ajax/admin/ads_campaigns.php',
    'includes/ajax/admin/funding.php',
    'includes/ajax/admin/monetization.php',
    'includes/ajax/admin/paid_modules.php',
    'includes/ajax/admin/payments.php',
    'includes/ajax/admin/pro.php',
    'includes/ajax/admin/tips.php',
    'includes/ajax/admin/wallet.php',
    'includes/ajax/monetization/controller.php',
    'includes/ajax/payments/2checkout.php',
    'includes/ajax/payments/authorize.php',
    'includes/ajax/payments/bank.php',
    'includes/ajax/payments/cash_on_delivery.php',
    'includes/ajax/payments/cashfree.php',
    'includes/ajax/payments/ccbill.php',
    'includes/ajax/payments/ccbill_status_check.php',
    'includes/ajax/payments/coinbase.php',
    'includes/ajax/payments/coinpayments.php',
    'includes/ajax/payments/coupon.php',
    'includes/ajax/payments/flutterwave.php',
    'includes/ajax/payments/mercadopago.php',
    'includes/ajax/payments/myfatoorah.php',
    'includes/ajax/payments/paypal.php',
    'includes/ajax/payments/paystack.php',
    'includes/ajax/payments/plisio.php',
    'includes/ajax/payments/iyzico.php',
    'includes/ajax/payments/razorpay.php',
    'includes/ajax/payments/shift4.php',
    'includes/ajax/payments/stripe.php',
    'includes/ajax/payments/trial.php',
    'includes/ajax/payments/verotel.php',
    'includes/ajax/payments/wallet.php',
    'includes/assets/js/core/payments.js',
    'includes/functions-payments.php',
    'includes/traits/campaigns.php',
    'includes/traits/funding.php',
    'includes/traits/monetization.php',
    'includes/traits/packages.php',
    'includes/traits/payments.php',
    'includes/traits/wallet.php',
    'sockets/node/libs/traits/monetization.js',
    'sockets/node/libs/traits/wallet.js',
    'webhooks/cashfree.php',
    'webhooks/ccbill.php',
    'webhooks/coinbase.php',
    'webhooks/coinpayments.php',
    'webhooks/epayco.php',
    'webhooks/flutterwave.php',
    'webhooks/mercadopago.php',
    'webhooks/mercadopago_callbak.php',
    'webhooks/myfatoorah.php',
    'webhooks/paypal.php',
    'webhooks/paypal_subscriptions.php',
    'webhooks/paystack.php',
    'webhooks/plisio.php',
    'webhooks/iyzico.php',
    'webhooks/stripe.php',
    'webhooks/stripe_subscriptions.php',
    'webhooks/verotel.php',
    /* monetization-paths:end */
  ];
}


/**
 * licence_remove_monetization_module
 * 
 * Deletes the Payments & Monetization files listed in licence_module_paths()
 * and switches the premium options off. Balances and history stay in the database, so
 * re-enabling the module with a qualifying licence restores everything.
 * A development checkout (one with a .dev folder) is never touched: it holds the source.
 * 
 * @return boolean
 */
function licence_remove_monetization_module()
{
  if (is_dir(ABSPATH . '.dev')) {
    return false;
  }
  $files = licence_module_paths();
  $root = rtrim(str_replace('\\', '/', ABSPATH), '/');
  foreach ($files as $rel) {
    if (!is_string($rel) || !licence_zip_entry_allowed($rel)) {
      continue;
    }
    $path = ABSPATH . ltrim($rel, '/');
    if (!is_file($path)) {
      continue;
    }
    @unlink($path);
    if (function_exists('opcache_invalidate')) {
      @opcache_invalidate($path, true);
    }
    /* prune folders the module created, stopping at the first one that still has files */
    $dir = dirname(str_replace('\\', '/', $path));
    while ($dir !== $root && str_starts_with($dir, $root . '/') && @rmdir($dir)) {
      $dir = dirname($dir);
    }
  }
  licence_clear_compiled_templates();
  if (function_exists('update_system_options') && isset($GLOBALS['db'])) {
    try {
      licence_turn_off_premium_options();
    } catch (Exception $e) {
      /* the in-memory flags still lock the features */
    }
  }
  return true;
}


/**
 * licence_disable_premium_flags
 * 
 * @param array $system
 * @return void
 */
function licence_disable_premium_flags(&$system)
{
  if (licence_has_entitlement('monetization')) {
    return;
  }
  foreach (licence_premium_option_names() as $name) {
    $system[$name] = '0';
  }
}


/**
 * licence_mask_key
 * 
 * @param string $key
 * @return string
 */
function licence_mask_key($key)
{
  $key = (string) $key;
  $len = strlen($key);
  if ($len === 0) {
    return '';
  }
  if ($len <= 4) {
    return str_repeat('•', $len);
  }
  return str_repeat('•', $len - 4) . substr($key, -4);
}


/**
 * licence_relative_days
 * 
 * @param int|null $days
 * @return string
 */
function licence_relative_days($days)
{
  if ($days === null) {
    return '';
  }
  $days = (int) $days;
  if ($days === 0) {
    return __("Today");
  }
  $abs = abs($days);
  if ($abs < 60) {
    $unit = ($abs === 1) ? __("day") : __("days");
    if ($days > 0) {
      return __("in") . ' ' . $abs . ' ' . $unit;
    }
    return $abs . ' ' . $unit . ' ' . __("ago");
  }
  $months = max(1, (int) round($abs / 30));
  $unit = ($months === 1) ? __("month") : __("months");
  if ($days > 0) {
    return __("in") . ' ' . $months . ' ' . $unit;
  }
  return $months . ' ' . $unit . ' ' . __("ago");
}


/**
 * licence_billing_cycle
 * 
 * @param array $payload
 * @return string|null
 */
function licence_billing_cycle($payload)
{
  if (!is_array($payload)) {
    return null;
  }
  $explicit = strtolower(trim((string) (
    $payload['billing_cycle']
    ?? $payload['billing_interval']
    ?? $payload['interval']
    ?? ''
  )));
  if (in_array($explicit, ['month', 'monthly'], true)) {
    return 'month';
  }
  if (in_array($explicit, ['year', 'yearly', 'annual', 'annually'], true)) {
    return 'year';
  }
  $issued = !empty($payload['issued_at']) ? strtotime($payload['issued_at']) : false;
  $support = !empty($payload['support_expires_at']) ? strtotime($payload['support_expires_at']) : false;
  if (!$issued || !$support || $support <= $issued) {
    return null;
  }
  $days = ($support - $issued) / 86400;
  if ($days <= 45) {
    return 'month';
  }
  if ($days >= 180) {
    return 'year';
  }
  return null;
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
    'chat_typing_enabled',
    'chat_seen_enabled',
    'chat_translation_enabled',
    'audio_call_enabled',
    'video_call_enabled',
    'chat_socket_enabled',
    'chat_photos_enabled',
    'system_uploads',
    'videos_enabled',
    'chat_videos_enabled',
    'chat_files_enabled',
    'chat_max_media',
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
    'users_approval_enabled',
    'reactions',
    'reactions_enabled'
  ];
  $values = array_intersect_key($system, array_flip($allowed_values));
  $values['module_names'] = module_names_values($system['module_names'] ?? '');
  return $values;
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
  $values = array_diff_key($user->_data, array_flip($disallowed_values));
  if ($user->_logged_in) {
    $values['friends_ids'] = $user->friends_ids();
    $values['followings_ids'] = $user->followings_ids();
    $values['friend_requests_ids'] = $user->friend_requests_ids();
    $values['friend_requests_sent_ids'] = $user->friend_requests_sent_ids();
    $values['connected_accounts'] = $user->connected_accounts();
  }
  return $values;
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
  if ($response === false) {
    return json_encode([
      'success' => false,
      'message' => 'API connection failed: ' . $error
    ]);
  }
  return $response;
}



/* ------------------------------- */
/* Batched Results */
/* ------------------------------- */

/**
 * PrefetchedResult
 */
class PrefetchedResult
{
  public $num_rows = 0;
  private $rows = [];

  public function __construct($rows)
  {
    $this->rows = array_values($rows);
    $this->num_rows = count($this->rows);
  }

  public function fetch_assoc(): ?array
  {
    return array_shift($this->rows);
  }

  public function fetch_all($mode = MYSQLI_ASSOC): array
  {
    $rows = $this->rows;
    $this->rows = [];
    return $rows;
  }
}



/* ------------------------------- */
/* Sampling */
/* ------------------------------- */

/**
 * sample_ids
 * 
 * @param string $table
 * @param string $id_column
 * @param string $scope_sql
 * @param integer $wanted
 * @param array $options
 * @return array
 */
function sample_ids($table, $id_column, $scope_sql, $wanted, $options = [])
{
  global $db;
  $wanted = max(1, (int) $wanted);
  $pool = (int) ($options['pool'] ?? min(200, max(20, 4 * $wanted)));
  $pivots = max(1, min(3, (int) ($options['pivots'] ?? 1)));
  $window = (int) ceil($pool / $pivots);
  $exclude = array_fill_keys(array_map('intval', $options['exclude'] ?? []), true);
  $filter = $options['filter'] ?? null;
  $from = sprintf("FROM `%s` WHERE %s", $table, $scope_sql);
  $picked = [];
  $seen = [];
  /* the shared pool first, then the database for what it can't fill */
  if (!empty($options['shared'])) {
    $shared = widget_pool_ids($options['shared'], $wanted * 3, function () use ($table, $id_column, $scope_sql) {
      return sample_ids($table, $id_column, $scope_sql, 1000, ['pool' => 1000]);
    });
    if ($shared !== null) {
      $candidates = [];
      foreach ($shared['ids'] as $id) {
        $seen[$id] = true;
        if (!isset($exclude[$id])) {
          $candidates[] = $id;
        }
      }
      if ($candidates && $filter) {
        $candidates = array_values(array_intersect($candidates, array_map('intval', $filter($candidates))));
      }
      shuffle($candidates);
      $picked = array_slice($candidates, 0, $wanted);
      if (count($picked) >= $wanted || $shared['complete']) {
        return $picked;
      }
    }
  }
  /* the scope's id range */
  $range = $db->query(sprintf("SELECT MIN(%s) AS min_id, MAX(%s) AS max_id %s", $id_column, $id_column, $from))->fetch_assoc();
  if (!$range || $range['max_id'] === null) {
    return $picked;
  }
  /* a scope whose id span fits in the pool is read whole in one window */
  if ((int) $range['max_id'] - (int) $range['min_id'] < $pool) {
    $pivots = 1;
    $window = $pool;
  }
  for ($round = 0; $round < 2 && count($picked) < $wanted; $round++) {
    /* one window per pivot, plus the start of the scope to wrap around */
    $selects = [];
    for ($i = 0; $i < $pivots; $i++) {
      $pivot = random_int((int) $range['min_id'], (int) $range['max_id']);
      $selects[] = sprintf("(SELECT %s AS id, %s AS part %s AND %s >= %s ORDER BY %s ASC LIMIT %s)", $id_column, $i * 2, $from, $id_column, $pivot, $id_column, $window);
      $selects[] = sprintf("(SELECT %s AS id, %s AS part %s AND %s < %s ORDER BY %s ASC LIMIT %s)", $id_column, $i * 2 + 1, $from, $id_column, $pivot, $id_column, $window);
    }
    $parts = [];
    $get_ids = $db->query(implode(" UNION ALL ", $selects));
    while ($row = $get_ids->fetch_assoc()) {
      $parts[$row['part']][] = (int) $row['id'];
    }
    $candidates = [];
    $read_all = false;
    for ($i = 0; $i < $pivots; $i++) {
      $forward = $parts[$i * 2] ?? [];
      $wrapped = $parts[$i * 2 + 1] ?? [];
      /* a short window continues from the start of the scope */
      $ids = array_merge($forward, array_slice($wrapped, 0, $window - count($forward)));
      if (count($forward) + count($wrapped) < $window) {
        $read_all = true;
      }
      foreach ($ids as $id) {
        if (!isset($seen[$id]) && !isset($exclude[$id])) {
          $seen[$id] = true;
          $candidates[] = $id;
        }
      }
    }
    if ($candidates && $filter) {
      $candidates = array_values(array_intersect($candidates, array_map('intval', $filter($candidates))));
    }
    shuffle($candidates);
    $picked = array_merge($picked, array_slice($candidates, 0, $wanted - count($picked)));
    /* the whole scope was read, another round finds nothing new */
    if ($read_all) {
      break;
    }
  }
  return $picked;
}


/**
 * rows_by_ids
 * 
 * @param array $rows
 * @param string $id_column
 * @param array $ids
 * @return array
 */
function rows_by_ids($rows, $id_column, $ids)
{
  $rows = array_column($rows, null, $id_column);
  $ordered = [];
  foreach ($ids as $id) {
    if (isset($rows[$id])) {
      $ordered[] = $rows[$id];
    }
  }
  return $ordered;
}



/* ------------------------------- */
/* Pagination */
/* ------------------------------- */

/**
 * cursor_encode
 * 
 * @param array $values
 * @return string
 */
function cursor_encode($values)
{
  return implode('|', $values);
}


/**
 * cursor_decode
 * 
 * @param mixed $cursor
 * @param array $types
 * @return array|null
 */
function cursor_decode($cursor, $types)
{
  if (!is_string($cursor) || $cursor === '') {
    return null;
  }
  $values = explode('|', $cursor);
  if (count($values) != count($types)) {
    return null;
  }
  foreach ($types as $index => $type) {
    $pattern = ($type == 'datetime') ? '/^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$/' : '/^\d{1,19}$/';
    if (!preg_match($pattern, $values[$index])) {
      return null;
    }
  }
  return $values;
}


/**
 * cursor_where
 * 
 * @param array $columns
 * @param array $values
 * @param boolean $descending
 * @return string
 */
function cursor_where($columns, $values, $descending = true)
{
  $operator = ($descending) ? "<" : ">";
  $conditions = [];
  $equals = "";
  foreach ($columns as $index => $column) {
    $value = (ctype_digit($values[$index])) ? secure($values[$index], 'int') : secure($values[$index]);
    $conditions[] = "(" . $equals . $column . " " . $operator . " " . $value . ")";
    $equals .= $column . " = " . $value . " AND ";
  }
  return "(" . implode(" OR ", $conditions) . ")";
}


/**
 * sql_top_level
 * 
 * @param string $sql
 * @param string $keyword
 * @param boolean $last
 * @return integer|false
 */
function sql_top_level($sql, $keyword, $last = false)
{
  $found = false;
  $depth = 0;
  $quote = null;
  $length = strlen($sql);
  $keyword_length = strlen($keyword);
  for ($i = 0; $i < $length; $i++) {
    $char = $sql[$i];
    if ($quote !== null) {
      if ($char == "\\") {
        $i++;
      } elseif ($char == $quote) {
        $quote = null;
      }
      continue;
    }
    if ($char == "'" || $char == '"' || $char == '`') {
      $quote = $char;
    } elseif ($char == '(') {
      $depth++;
    } elseif ($char == ')') {
      $depth--;
    } elseif ($depth == 0 && strncasecmp(substr($sql, $i, $keyword_length), $keyword, $keyword_length) === 0) {
      if (!$last) {
        return $i;
      }
      $found = $i;
    }
  }
  return $found;
}


/**
 * paged_query
 * 
 * @param string $sql
 * @param string $key
 * @param string $limit_query
 * @return mysqli_result|PrefetchedResult
 */
function paged_query($sql, $key, $limit_query)
{
  global $db;
  $sql = " " . preg_replace('/\s+/', ' ', trim($sql)) . " ";
  $from_position = sql_top_level($sql, " FROM ");
  /* grouped or combined queries are read as they are */
  if ($from_position === false || sql_top_level($sql, " GROUP BY ") !== false || sql_top_level($sql, " HAVING ") !== false || sql_top_level($sql, " UNION ") !== false) {
    return $db->query($sql . $limit_query);
  }
  $select = substr($sql, 0, $from_position);
  $from = substr($sql, $from_position);
  $order_position = sql_top_level($from, " ORDER BY ", true);
  $order = ($order_position !== false) ? substr($from, $order_position) : " ORDER BY " . $key . " ASC ";
  $body = ($order_position !== false) ? substr($from, 0, $order_position) : $from;
  /* the keys of the page */
  $keys = array_column($db->query("SELECT " . $key . " AS page_key" . $body . $order . $limit_query)->fetch_all(MYSQLI_ASSOC), 'page_key');
  if (!$keys) {
    return new PrefetchedResult([]);
  }
  /* the rows of the page */
  $keys_statement = $key . " IN (" . implode(',', array_map('intval', $keys)) . ")";
  $where_position = sql_top_level($body, " WHERE ");
  $body = ($where_position !== false) ? substr($body, 0, $where_position) . " WHERE (" . substr($body, $where_position + 7) . ") AND " . $keys_statement : $body . " WHERE " . $keys_statement;
  return $db->query($select . $body . $order);
}


/**
 * cursor_result
 * 
 * @param mysqli_result $result
 * @return array
 */
function cursor_result($result)
{
  $rows = $result->fetch_all(MYSQLI_ASSOC);
  $cursor = ($rows) ? (string) end($rows)['cursor'] : null;
  foreach ($rows as &$row) {
    unset($row['cursor']);
  }
  return [new PrefetchedResult($rows), $cursor];
}



/* ------------------------------- */
/* Location */
/* ------------------------------- */

/**
 * valid_location
 * 
 * @param mixed $latitude
 * @param mixed $longitude
 * @return boolean
 */
function valid_location($latitude, $longitude)
{
  if (!is_numeric($latitude) || !is_numeric($longitude)) {
    return false;
  }
  $latitude = (float) $latitude;
  $longitude = (float) $longitude;
  return $latitude >= -90 && $latitude <= 90 && $longitude >= -180 && $longitude <= 180 && !($latitude == 0 && $longitude == 0);
}


/**
 * location_point
 * 
 * @param float $latitude
 * @param float $longitude
 * @return string
 */
function location_point($latitude, $longitude)
{
  return sprintf("POINT(%.7F, %.7F)", (float) $longitude, (float) $latitude);
}


/**
 * location_distance
 * 
 * @param float $latitude1
 * @param float $longitude1
 * @param float $latitude2
 * @param float $longitude2
 * @return float
 */
function location_distance($latitude1, $longitude1, $latitude2, $longitude2)
{
  $latitude_delta = deg2rad($latitude2 - $latitude1);
  $longitude_delta = deg2rad($longitude2 - $longitude1);
  $angle = pow(sin($latitude_delta / 2), 2) + cos(deg2rad($latitude1)) * cos(deg2rad($latitude2)) * pow(sin($longitude_delta / 2), 2);
  return 6371 * 2 * asin(min(1, sqrt($angle)));
}


/**
 * location_boxes
 * 
 * @param float $latitude
 * @param float $longitude
 * @param float $radius_km
 * @return array
 */
function location_boxes($latitude, $longitude, $radius_km)
{
  $angle = $radius_km / 6371;
  $min_latitude = $latitude - rad2deg($angle);
  $max_latitude = $latitude + rad2deg($angle);
  /* the circle covers a pole: every longitude */
  if ($angle >= M_PI || $min_latitude <= -90 || $max_latitude >= 90) {
    return [[-180, max(-90, $min_latitude), 180, min(90, $max_latitude)]];
  }
  $longitude_delta = rad2deg(asin(min(1, sin($angle) / cos(deg2rad($latitude)))));
  $min_longitude = $longitude - $longitude_delta;
  $max_longitude = $longitude + $longitude_delta;
  if ($min_longitude < -180) {
    return [[$min_longitude + 360, $min_latitude, 180, $max_latitude], [-180, $min_latitude, $max_longitude, $max_latitude]];
  }
  if ($max_longitude > 180) {
    return [[$min_longitude, $min_latitude, 180, $max_latitude], [-180, $min_latitude, $max_longitude - 360, $max_latitude]];
  }
  return [[$min_longitude, $min_latitude, $max_longitude, $max_latitude]];
}


/**
 * nearby_ids
 * 
 * @param string $table
 * @param string $id_column
 * @param float $latitude
 * @param float $longitude
 * @param float $max_km
 * @param integer $needed
 * @param array $options
 * @return array
 */
function nearby_ids($table, $id_column, $latitude, $longitude, $max_km, $needed, $options = [])
{
  global $db;
  if (!valid_location($latitude, $longitude) || $max_km <= 0) {
    return [];
  }
  $latitude = (float) $latitude;
  $longitude = (float) $longitude;
  $cap = (int) ($options['cap'] ?? 2000);
  $exclude = array_fill_keys(array_map('intval', $options['exclude'] ?? []), true);
  $filter = $options['filter'] ?? null;
  $type_statement = (isset($options['post_type'])) ? sprintf(" AND post_type = %s", secure($options['post_type'])) : "";
  $rings = array_values(array_filter([2, 10, 50, 250, 1000, 5000, 20000], fn($ring) => $ring < $max_km));
  $rings[] = min($max_km, 20016);
  $eligible = [];
  $nearest = [];
  foreach ($rings as $ring) {
    /* one bounded read per box */
    $selects = [];
    foreach (location_boxes($latitude, $longitude, $ring) as $part => $box) {
      $selects[] = sprintf("(SELECT %1\$s AS id, %9\$d AS part, ST_Distance_Sphere(location, %2\$s, 6371000) AS distance FROM `%3\$s` WHERE MBRIntersects(ST_GeomFromText('POLYGON((%4\$.7F %5\$.7F, %6\$.7F %5\$.7F, %6\$.7F %7\$.7F, %4\$.7F %7\$.7F, %4\$.7F %5\$.7F))'), location)" . $type_statement . " LIMIT %8\$d)", $id_column, location_point($latitude, $longitude), $table, $box[0], $box[1], $box[2], $box[3], $cap + 1, $part);
    }
    $rows = $db->query(implode(" UNION ALL ", $selects))->fetch_all(MYSQLI_ASSOC);
    $overflow = max(array_count_values(array_column($rows, 'part')) ?: [0]) > $cap;
    /* inside the circle, not excluded, eligible */
    $found = [];
    foreach ($rows as $row) {
      $distance = $row['distance'] / 1000;
      if ($distance <= $ring && !isset($exclude[(int) $row['id']])) {
        $found[(int) $row['id']] = $distance;
      }
    }
    $unchecked = array_keys(array_diff_key($found, $eligible));
    if ($unchecked) {
      $kept = ($filter) ? array_fill_keys(array_map('intval', $filter($unchecked)), true) : array_fill_keys($unchecked, true);
      foreach ($unchecked as $id) {
        $eligible[$id] = isset($kept[$id]);
      }
    }
    $found = array_filter($found, fn($id) => $eligible[$id], ARRAY_FILTER_USE_KEY);
    uksort($found, fn($a, $b) => ($found[$a] <=> $found[$b]) ?: ($a <=> $b));
    if ($overflow) {
      /* the last complete box is exact, this one only tops it up */
      return $nearest + array_diff_key($found, $nearest);
    }
    $nearest = $found;
    if (count($nearest) >= $needed) {
      break;
    }
  }
  return $nearest;
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
 * set_cookie
 * 
 * @param string $cookie_name
 * @param string $cookie_value
 * @param boolean $is_expired
 * @param boolean $is_httponly
 * @return void
 */
function set_cookie($cookie_name, $cookie_value, $is_expired = false, $is_httponly = true)
{
  $secured = (get_system_protocol() == "https") ? true : false;
  $expire_time = ($is_expired) ?  0 : time() + 2592000;
  $httponly = ($is_httponly) ? true : false;
  /* None on HTTPS so cookies are sent on cross-site POST (e.g. Sign in with Apple callback); Lax would omit them and the user looks logged out. */
  $samesite = ($secured && PHP_VERSION_ID >= 70300) ? 'None' : 'Lax';
  $options = [
    'expires' => $expire_time,
    'path' => '/',
    'domain' => '',
    'secure' => $secured,
    'httponly' => $httponly,
    'samesite' => $samesite
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
  $secured = (get_system_protocol() == "https") ? true : false;
  $samesite = ($secured && PHP_VERSION_ID >= 70300) ? 'None' : 'Lax';
  setcookie($cookie_name, '', [
    'expires' => time() - 3600,
    'path' => '/',
    'domain' => '',
    'secure' => $secured,
    'httponly' => true,
    'samesite' => $samesite,
  ]);
}



/* ------------------------------- */
/* Validation */
/* ------------------------------- */

/**
 * is_ajax
 * 
 * @param boolean $redirect
 * @return boolean
 */
function is_ajax($redirect = true)
{
  $is_ajax = (isset($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) === 'xmlhttprequest');
  if ($redirect && !$is_ajax) {
    redirect();
  }
  return $is_ajax;
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
 * valid_gif_url
 * 
 * @param string $url
 * @return boolean
 */
function valid_gif_url($url)
{
  return is_string($url) && strlen($url) <= 512 && preg_match('~^https://[a-z0-9.-]+\.giphy\.com/[^\s<>"\x27]+$~i', $url);
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



/* ------------------------------- */
/* JSON */
/* ------------------------------- */

/**
 * return_json
 * 
 * @param array $response
 * @return void
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
/* Stream */
/* ------------------------------- */

/**
 * stream_start
 * 
 * @return void
 */
function stream_start()
{
  global $is_stream;
  if (!$is_stream) {
    return;
  }
  @ini_set('zlib.output_compression', '0');
  @ini_set('implicit_flush', '1');
  while (ob_get_level() > 0) {
    ob_end_flush();
  }
  ob_implicit_flush(1);
  header('Content-Type: application/x-ndjson');
  header('Cache-Control: no-cache');
  header('X-Accel-Buffering: no'); /* disable nginx proxy buffering */
}


/**
 * stream_send
 * 
 * @param array $data
 * @return void
 */
function stream_send($data)
{
  global $is_stream;
  if (!$is_stream) {
    return;
  }
  echo json_encode($data) . "\n";
  flush();
}


/**
 * stream_progress
 * 
 * @param int $progress
 * @param string|null $label
 * @return void
 */
function stream_progress($progress, $label = null)
{
  $data = ['progress' => $progress];
  if ($label !== null) {
    $data['label'] = $label;
  }
  stream_send($data);
}


/**
 * stream_fail
 * 
 * @param string $message
 * @return void
 */
function stream_fail($message)
{
  global $is_stream;
  if ($is_stream) {
    stream_send(['success' => false, 'message' => trim(strip_tags($message))]);
    exit;
  }
  _error('Error', $message);
}



/* ------------------------------- */
/* OneSignal Notifications */
/* ------------------------------- */

/**
 * onesignal_notification
 * 
 * @param string $send_to
 * @param mixed $notification
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
        $notification['url'] = str_replace('https://', 'sngine://', $notification['url']);
      }
      break;

    case 'messenger':
      if (!$system['onesignal_messenger_notification_enabled']) {
        return false;
      }
      $onesignal_app_id = $system['onesignal_messenger_app_id'];
      $onesignal_api_key = $system['onesignal_messenger_api_key'];
      $notification['url'] = str_replace('https://', 'sngine_messenger://', $notification['url']);
      break;

    case 'timeline':
      if (!$system['onesignal_timeline_notification_enabled']) {
        return false;
      }
      $onesignal_app_id = $system['onesignal_timeline_app_id'];
      $onesignal_api_key = $system['onesignal_timeline_api_key'];
      $notification['url'] = str_replace('https://', 'sngine_timeline://', $notification['url']);
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
      throw new Exception(__("Error Processing Request"));
    }
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
/* hCaptcha */
/* ------------------------------- */

/**
 * check_hcaptcha
 * 
 * @param string $token
 * @return boolean
 */
function check_hcaptcha($token)
{
  global $system;
  $payload = http_build_query([
    "secret" => $system['hcaptcha_secret_key'],
    "response" => $token,
    "remoteip" => get_user_ip(),
    "sitekey" => $system['hcaptcha_site_key'],
  ]);
  $ctx = stream_context_create([
    "http" => [
      "method" => "POST",
      "header" => "Content-type: application/x-www-form-urlencoded\r\n",
      "content" => $payload,
      "timeout" => 5,
    ],
  ]);
  $raw = file_get_contents(
    "https://api.hcaptcha.com/siteverify",
    false,
    $ctx
  );
  $response = json_decode($raw, true);
  if (!empty($response["success"])) {
    return true;
  } else {
    return false;
  }
}



/* ------------------------------- */
/* Cloudflare */
/* ------------------------------- */

/**
 * check_cf_turnstile
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
  }
}


/**
 * admin_access
 * 
 * @param string|null $permission
 * @return void
 */
function admin_access($permission = null)
{
  global $user, $system;
  if ($user->_is_admin) {
    return;
  }
  if ($permission !== null && $user->_is_moderator && !empty($system[$permission])) {
    return;
  }
  modal("MESSAGE", __("System Message"), __("You don't have the right permission to access this"));
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
 * get_feeling_emoji
 * 
 * @param string $icon
 * @return string
 */
function get_feeling_emoji($icon)
{
  $emojis = [
    'grinning-face-with-smiling-eyes' => '😁',
    'headphone' => '🎧',
    'glasses' => '👓',
    'video-game' => '🎮',
    'shortcake' => '🍰',
    'tropical-drink' => '🍹',
    'airplane' => '✈️',
    'books' => '📚',
    'calendar' => '📆',
    'birthday-cake' => '🎂',
    'magnifying-glass-tilted-left' => '🔍',
    'smiling-face-with-heart-eyes' => '😍',
    'relieved-face' => '😌',
    'flexed-biceps' => '💪',
    'disappointed-face' => '😞',
    'winking-face-with-tongue' => '😜',
    'downcast-face-with-sweat' => '😓',
    'sleeping-face' => '😴',
    'confused-face' => '😕',
    'worried-face' => '😟',
    'angry-face' => '😠',
    'pouting-face' => '😡',
    'face-with-open-mouth' => '😮',
    'pensive-face' => '😔',
    'confounded-face' => '😖',
  ];
  return $emojis[$icon] ?? '';
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
  if (!$system['censored_words_enabled']) {
    return $text;
  }
  if (!$text) {
    return $text;
  }
  $censored_words = json_decode(html_entity_decode($system['censored_words']), true);
  if (!$censored_words) {
    return $text;
  }
  $censored_words_values = array_column($censored_words, "value");
  if (count($censored_words_values) == 0) {
    return $text;
  }
  foreach ($censored_words_values as $word) {
    $word = trim($word);
    $pattern = '/\b' . $word . '\b/iu';
    $text = preg_replace($pattern, str_repeat('*', strlen($word)), $text);
  }
  return $text;
}



/* ------------------------------- */
/* Utilities */
/* ------------------------------- */

/**
 * __
 * 
 * @param string $text
 * @return string
 */
function __($text)
{
  global $gettextTranslations;
  if (!$text) {
    return '';
  }
  return $gettextTranslations[$text] ?? $text;
}


/**
 * translations_load
 * 
 * @param string $language_code
 * @return array
 */
function translations_load($language_code)
{
  static $loaded = [];
  if (isset($loaded[$language_code])) {
    return $loaded[$language_code];
  }
  if (!$language_code || $language_code == DEFAULT_LOCALE) {
    return $loaded[$language_code] = module_names_overrides();
  }
  if (!preg_match('/^[a-z]{2,3}_[a-z]{2,3}$/i', $language_code)) {
    return $loaded[$language_code] = [];
  }
  $po_file = ABSPATH . 'content/languages/locale/' . $language_code . '/LC_MESSAGES/messages.po';
  if (!is_file($po_file)) {
    return $loaded[$language_code] = [];
  }
  $stamp = filemtime($po_file) . '-' . filesize($po_file);
  $translations = system_cache_read('lang_' . $language_code, $stamp, 0);
  if ($translations === null) {
    $translations = [];
    $po_loader = new Gettext\Loader\PoLoader();
    foreach ($po_loader->loadFile($po_file) as $translation) {
      if ($translation->isDisabled() || !in_array($translation->getContext(), [null, ''], true)) {
        continue;
      }
      if ($translation->getTranslation()) {
        $translations[$translation->getOriginal()] = $translation->getTranslation();
      }
    }
    system_cache_write('lang_' . $language_code, $translations, $stamp);
  }
  return $loaded[$language_code] = $translations;
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
 * ipinfo_request
 *
 * @param string $ip
 * @return array|false
 */
function ipinfo_request($ip)
{
  global $system;
  $ch = curl_init();
  curl_setopt_array($ch, [
    CURLOPT_URL => 'https://api.ipinfo.io/lite/' . $ip,
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_HTTPHEADER => ["Authorization: Bearer " . html_entity_decode($system['ipinfo_token'], ENT_QUOTES)],
    CURLOPT_CONNECTTIMEOUT => 2,
    CURLOPT_TIMEOUT => 3,
  ]);
  $response = curl_exec($ch);
  $http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
  if ($response === false || $http_code != 200) {
    return false;
  }
  $response = json_decode($response, true);
  if (!is_array($response) || empty($response['country_code'])) {
    return false;
  }
  return [
    'country_code' => strtoupper($response['country_code']),
    'country' => $response['country'] ?? '',
    'asn' => $response['asn'] ?? '',
    'isp' => $response['as_name'] ?? ''
  ];
}


/**
 * ipinfo_lookup
 *
 * @param string $ip
 * @return array|false
 */
function ipinfo_lookup($ip)
{
  global $system;
  static $cache = [];
  if (!$system['ipinfo_enabled'] || !$system['ipinfo_token']) {
    return false;
  }
  if (!filter_var($ip, FILTER_VALIDATE_IP, FILTER_FLAG_NO_PRIV_RANGE | FILTER_FLAG_NO_RES_RANGE)) {
    return false;
  }
  if (isset($cache[$ip])) {
    return $cache[$ip];
  }
  /* get from cache */
  $key = 'ipinfo:' . md5($ip);
  $cached = redis_run(function ($redis) use ($key) {
    return $redis->get(redis_key($key));
  });
  if ($cached) {
    $cached = json_decode($cached, true);
    if (is_array($cached)) {
      return $cache[$ip] = $cached;
    }
  }
  /* get from ipinfo */
  $cache[$ip] = ipinfo_request($ip);
  if ($cache[$ip]) {
    $value = json_encode($cache[$ip]);
    redis_run(function ($redis) use ($key, $value) {
      $redis->setex(redis_key($key), 86400, $value);
    });
  }
  return $cache[$ip];
}


/**
 * ipinfo_test
 *
 * @return void
 */
function ipinfo_test()
{
  global $system;
  if (!$system['ipinfo_token'] || !ipinfo_request('8.8.8.8')) {
    throw new Exception(__("Connection Failed, Please check your settings"));
  }
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
 * @return array
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
 * @return int|null
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
  if (!$text) return $text;
  $pattern = '@(https?://([-\w\.]+[-\w])+(:\d+)?(/([\w/_\.#-]*(\?\S+)?[^\.\s])?)?)@';
  return preg_replace($pattern . 'u', '<a href="$1" target="_blank">$1</a>', $text) ?? preg_replace($pattern, '<a href="$1" target="_blank">$1</a>', $text);
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
  if (function_exists('transliterator_transliterate')) {
    $transliterated = transliterator_transliterate('Any-Latin; Latin-ASCII', $string);
    if ($transliterated !== false) {
      $string = $transliterated;
    }
  }
  $string = preg_replace('/[^A-Za-z0-9]+/', '-', $string);
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
 * get_search_text
 *
 * @param string $string
 * @return string
 */
function get_search_text($string)
{
  $string = mb_scrub((string) $string, 'UTF-8');
  /* decode entities & strip tags */
  $string = html_entity_decode($string, ENT_QUOTES | ENT_HTML5, 'UTF-8');
  $string = strip_tags(str_replace('<', ' <', $string));
  $string = html_entity_decode($string, ENT_QUOTES | ENT_HTML5, 'UTF-8');
  /* remove diacritics */
  $string = preg_replace('/[\x{0300}-\x{036F}\x{0591}-\x{05C7}\x{0610}-\x{061A}\x{0640}\x{064B}-\x{065F}\x{0670}\x{06D6}-\x{06ED}]+/u', '', $string);
  /* keep words only */
  $string = preg_replace('/[^\p{L}\p{M}\p{N}]+/u', ' ', $string);
  return trim((string) $string);
}


/**
 * get_html_purifier
 * 
 * @return HTMLPurifier
 */
function get_html_purifier()
{
  $config = HTMLPurifier_Config::createDefault();
  $config->set('HTML.SafeIframe', true);
  $config->set('URI.SafeIframeRegexp', '%^(https?:)?(\/\/www\.youtube(?:-nocookie)?\.com\/embed\/|\/\/player\.vimeo\.com\/)%');
  $config->set('Cache.DefinitionImpl', null);
  if ($def = $config->getHTMLDefinition(true)) {
    $def->addElement('details', 'Block', 'Flow', 'Common', ['open' => 'Bool#open']);
    $def->addElement('summary', 'Block', 'Flow', 'Common');
  }
  return new HTMLPurifier($config);
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
  if (!$url) {
    return '';
  }
  /* watch?v= */
  if (preg_match('/[?&]v=([a-zA-Z0-9_-]{11})/', $url, $match)) {
    return $match[1];
  }
  /* youtu.be/ID */
  if (preg_match('/youtu\.be\/([a-zA-Z0-9_-]{11})/', $url, $match)) {
    return $match[1];
  }
  /* youtube.com/embed/ID and youtube-nocookie.com/embed/ID (also iframe HTML) */
  if (preg_match('/youtube(?:-nocookie)?\.com\/embed\/([a-zA-Z0-9_-]{11})/', $url, $match)) {
    return $match[1];
  }
  /* youtube.com/shorts/ID */
  if (preg_match('/youtube\.com\/shorts\/([a-zA-Z0-9_-]{11})/', $url, $match)) {
    return $match[1];
  }
  /* youtube.com/v/ID */
  if (preg_match('/youtube\.com\/v\/([a-zA-Z0-9_-]{11})/', $url, $match)) {
    return $match[1];
  }
  return '';
}


/**
 * get_vimeo_id
 * 
 * @param string $url
 * @return int
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
  if (strpos($url, 'youtube') > 0 || strpos($url, 'youtu.be') > 0) {
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
 * @param mixed $current
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
 * @param boolean $formated
 * @return string
 */
function print_money($amount, $symbol = null, $dir = null, $formated = true)
{
  global $system;
  $amount = (float) $amount;
  $symbol = ($symbol) ? $symbol : $system['system_currency_symbol'];
  $dir = ($dir) ? $dir : $system['system_currency_dir'];
  if ($dir == "right") {
    return ($formated) ? number_format($amount, 2) . $symbol : $amount . $symbol;
  } else {
    return ($formated) ? $symbol . number_format($amount, 2) : $symbol . $amount;
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
  }
  $suffixes = ['K', 'M', 'B'];
  $value = $count;
  foreach ($suffixes as $i => $suffix) {
    $value = round($count / pow(1000, $i + 1), 1);
    if ($value < 1000 || $suffix == 'B') {
      break;
    }
  }
  return rtrim(rtrim(number_format($value, 1, '.', ''), '0'), '.') . __($suffix);
}


/**
 * calculate_distance
 * 
 * @param float $lat1
 * @param float $lon1
 * @param float $lat2
 * @param float $lon2
 * @return string|null
 */
function calculate_distance($lat1, $lon1, $lat2, $lon2)
{
  if (!$lat1 || !$lon1 || !$lat2 || !$lon2) {
    return null;
  }
  $earth_radius = 6371000;
  $lat_from = deg2rad($lat1);
  $lon_from = deg2rad($lon1);
  $lat_to = deg2rad($lat2);
  $lon_to = deg2rad($lon2);
  $lat_delta = $lat_to - $lat_from;
  $lon_delta = $lon_to - $lon_from;
  $angle = 2 * asin(sqrt(pow(sin($lat_delta / 2), 2) + cos($lat_from) * cos($lat_to) * pow(sin($lon_delta / 2), 2)));
  $distance = $earth_radius * $angle;
  if ($distance >= 1000) {
    return round($distance / 1000, 2) . ' KM';
  } else {
    return round($distance) . ' M';
  }
}


/**
 * count_words
 * 
 * @param string $text
 * @return int
 */
function count_words($text)
{
  /* [1] match and count all individual CJK characters */
  $cjk_pattern = '/[\x{3040}-\x{30FF}\x{3400}-\x{4DBF}\x{4E00}-\x{9FFF}\x{F900}-\x{FAFF}\x{AC00}-\x{D7AF}\x{1100}-\x{11FF}\x{3130}-\x{318F}]/u';
  $cjk_count = preg_match_all($cjk_pattern, $text, $matches);
  $cjk_count = ($cjk_count !== false) ? $cjk_count : 0;
  /* [2] replace CJK with spaces */
  $remaining = preg_replace($cjk_pattern, ' ', $text);
  /* [3] count space-separated Western words & numbers safely */
  preg_match_all('/[\p{L}\p{N}]+/u', $remaining, $western_matches);
  $western_count = count($western_matches[0]);
  return $cjk_count + $western_count;
}
