<?php

/**
 * ajax -> admin -> license
 *
 * @package Sngine
 * @author Zamblek
 */

// set execution time
set_time_limit(0); /* unlimited max execution time */

// fetch bootstrap
require('../../../bootstrap.php');

// check AJAX Request
is_ajax();

// check admin|moderator permission
if (!$user->_is_admin) {
  modal("MESSAGE", __("System Message"), __("You don't have the right permission to access this"));
}

// check demo account
if ($user->_data['user_demo']) {
  modal("ERROR", __("Demo Restriction"), __("You can't do this with demo account"));
}

// handle license
try {

  switch ($_POST['do']) {
    case 'enable':
      if (!defined('LICENCE_KEY') || LICENCE_KEY === '') {
        throw new Exception(__("No license key found."));
      }

      /* re-verify and store the signed payload */
      $fresh = get_licence_key(LICENCE_KEY, 'admin');
      licence_store_payload($fresh);

      if (empty($fresh['entitlements']['monetization'])) {
        throw new Exception(__("Payments & Monetization require an Extended or Subscription license."));
      }

      $zip = licence_download_module('monetization');
      $result = licence_install_module_zip($zip);

      if (empty($result['extracted'])) {
        modal("INFO", __("Payments & monetization"), $result['message']);
      }

      return_json([
        'callback' => "modal('#modal-success', {title: '" . addslashes(__("Payments & monetization")) . "', message: '" . addslashes($result['message']) . "'}); setTimeout(function(){ window.location.reload(); }, 1200);"
      ]);
      break;

    case 'change':
      /* check password */
      $user->verify_password($_POST['password_check']);

      /* check licence key */
      $licence_key = trim($_POST['licence_key'] ?? '');
      if (is_empty($licence_key)) {
        throw new Exception(__("Please enter a valid license key"));
      }

      /* check license files */
      $config_file = ABSPATH . 'includes/config.php';
      $licence_file = ABSPATH . 'includes/sys_verif.php';
      if (!is_writable($config_file) || (is_file($licence_file) ? !is_writable($licence_file) : !is_writable(dirname($licence_file)))) {
        throw new Exception(__("The includes folder must be writable to change the license key"));
      }

      /* verify and store the new license */
      $licence = get_licence_key($licence_key, 'update');
      licence_store_payload($licence);
      licence_write_config($licence_key);
      licence_reset_payload_cache();
      if (empty($licence['entitlements']['monetization'])) {
        licence_turn_off_premium_options();
      }

      return_json([
        'callback' => "modal('#modal-success', {title: '" . addslashes(__("License")) . "', message: '" . addslashes(__("The new license key has been applied")) . "'}); setTimeout(function(){ window.location.reload(); }, 1200);"
      ]);
      break;

    default:
      _error(400);
      break;
  }
} catch (Exception $e) {
  return_json(['error' => true, 'message' => $e->getMessage()]);
}
