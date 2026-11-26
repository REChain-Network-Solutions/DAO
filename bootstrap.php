<?php

/**
 * bootstrap
 * 
 * @package Sngine
 * @author Zamblek
 */

// set ABSPATH
define('ABSPATH', __DIR__ . DIRECTORY_SEPARATOR);

// get system version & exceptions
require(ABSPATH . 'includes/sys_ver.php');
require(ABSPATH . 'includes/exceptions.php');


// require dependencies
require(ABSPATH . 'vendor/autoload.php');


// get functions
require(ABSPATH . 'includes/functions.php');
if (is_file(ABSPATH . 'includes/functions-payments.php')) {
  require(ABSPATH . 'includes/functions-payments.php');
}


// check config file
if (!file_exists(ABSPATH . 'includes/config.php')) {
  header('Location: ./install');
}


// get config file
require(ABSPATH . 'includes/config.php');


// set debugging settings
if (DEBUGGING) {
  ini_set("display_errors", true);
  error_reporting(E_ALL & ~E_WARNING & ~E_NOTICE & ~E_DEPRECATED);
} else {
  ini_set("display_errors", false);
  error_reporting(0);
}


// configure localization
$gettextTranslations = [];


// check system URL
if (URL_CHECK) {
  check_system_url();
}


// init system datetime
$date = init_system_datetime();


// init database connection
try {
  $db = init_db_connection();
} catch (Exception $e) {
  _error('DB_ERROR');
}


// init system
try {
  $system = init_system();
} catch (Exception $e) {
  _error(__("Error"), $e->getMessage());
}


// init system session
init_system_session();


// verify licence file
try {
  licence_load_payload(true);
  $licence_monetization = licence_has_entitlement('monetization');
  $licence_module_installed = licence_module_installed();
} catch (Exception $e) {
  _error(__("Error"), __("Your license file has been broken, Please contact Sngine's support!"));
}


// init smarty
$smarty = init_smarty();


// get user
require_once(ABSPATH . 'includes/class-user.php');
try {
  $user = new User();
} catch (Exception $e) {
  _error(__("Error"), $e->getMessage());
}


// init essential checks

/* check if system is live */
if (!$system['system_live'] && ((!$user->_logged_in && !isset($override_shutdown)) || ($user->_logged_in && $user->_data['user_group'] != 1))) {
  _error(__('System Message'), $system['system_message']);
}

/* check if the viewer IP is banned */
if ($system['viewer_ip_banned']) {
  _error(__("System Message"), __("Your IP has been blocked"));
}

/* check if the viewer is banned */
if ($user->_is_banned) {
  _error(__("System Message"), $user->_data['user_banned_message']);
}


// 🚀 Starting the web app ...

// set control panel varibles
if ($user->_is_admin) {
  $control_panel['title'] = __("Admin");
  $control_panel['url'] = "admincp";
} elseif ($user->_is_moderator) {
  $control_panel['title'] = __("Moderator");
  $control_panel['url'] = "modcp";
}


// assign variables
$smarty->assign('licence_monetization', $licence_monetization);
$smarty->assign('licence_module_installed', $licence_module_installed);
$smarty->assign('secret', $_SESSION['secret']);
$smarty->assign('date', $date);
$smarty->assign('system', $system);
$smarty->assign('user', $user);
