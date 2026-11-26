<?php

/**
 * sockets -> php -> loader
 * 
 * @package Sngine
 * @author Zamblek
 */

// set ABSPATH
define('ABSPATH', dirname(__DIR__, 2) . DIRECTORY_SEPARATOR);

// long-running process: per-request lists must not be kept between socket events
define('SOCKET_SERVER', true);


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
  print("❌ Config file not found\n");
  exit;
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


// init system session
init_system_session();


// init system datetime
$date = init_system_datetime();


// init database connection
try {
  $db = init_db_connection();
} catch (Exception $e) {
  print("❌ DB connection error: " . $e->getMessage() . "\n");
  exit;
}


// init system
try {
  $system = init_system();
} catch (Exception $e) {
  print("❌ System initialization error: " . $e->getMessage() . "\n");
  exit;
}


// init smarty
$smarty = init_smarty();
$smarty->assign('system', $system);


// get user
require_once(ABSPATH . 'includes/class-user.php');
try {
  $user = new User();
} catch (Exception $e) {
  print("❌ User initialization error: " . $e->getMessage() . "\n");
  exit;
}


// init essential checks

/* check if system is live */
if (!$system['system_live']) {
  print("❌ System is not live: " . $system['system_message'] . "\n");
  exit;
}

/* check if the viewer IP is banned */
if ($system['viewer_ip_banned']) {
  print("❌ Viewer IP is banned\n");
  exit;
}

/* check if the viewer is banned */
if ($user->_is_banned) {
  print("❌ Viewer is banned: " . $user->_data['user_banned_message'] . "\n");
  exit;
}


// 🚀 Starting the sockets server ...
