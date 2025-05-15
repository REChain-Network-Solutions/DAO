<?php

/**
 * APIs -> index
 * 
 * @package Delus
 * @author Dmitry Sorokin - @sorydima & @sorydev Handles. 
 */

// set API_STACK & API_BASE
define('API_STACK', '/apis/php');
$subdir = str_replace($_SERVER['DOCUMENT_ROOT'], '', dirname($_SERVER['SCRIPT_NAME']));
$subdir = str_replace(API_STACK, '', $subdir);
define('API_BASE', rtrim($subdir, '/') . API_STACK);


// set ABSPATH
define('ABSPATH', dirname(__DIR__, 2) . DIRECTORY_SEPARATOR);


// get system version & exceptions
require(ABSPATH . 'includes/sys_ver.php');
require(ABSPATH . 'includes/exceptions.php');


// require dependencies
require(ABSPATH . 'vendor/autoload.php');


// get functions
require(ABSPATH . 'includes/functions.php');
require('utils/functions.php');


// check config file
if (!file_exists(ABSPATH . 'includes/config.php')) {
  apiError("Fatal System Error");
}


// get config file
require(ABSPATH . 'includes/config.php');


// set debugging settings
if (DEBUGGING) {
  ini_set("display_errors", true);
  error_reporting(E_ALL & ~E_WARNING & ~E_NOTICE);
} else {
  ini_set("display_errors", false);
  error_reporting(0);
}


// configure localization
$gettextLoader = new Gettext\Loader\PoLoader();
$gettextTranslator = Gettext\Translations::create('default');


// init system session
init_system_session();


// init system datetime
$date = init_system_datetime();


// init database connection
try {
  $db = init_db_connection();
} catch (Exception $e) {
  apiError("Error establishing a database connection");
}


// init system
global $system;
try {
  init_system($system);
} catch (Exception $e) {
  apiError($e->getMessage());
}


// check apps API request
checkAPIRequest();


// get system session hash
$session_hash = get_system_session_hash($system['session_hash']);
if (!$session_hash) {
  apiError("Your session hash has been broken, Please contact Delus's support!");
}


// init smarty
global $smarty;
$smarty = init_smarty();


// get user
global $user;
require_once(ABSPATH . 'includes/class-user.php');
try {
  $user = new User();
} catch (Exception $e) {
  apiError($e->getMessage());
}


// init essential checks

/* check if system is live */
if (!$system['system_live']) {
  apiError($system['system_message'], 401);
}

/* check if the viewer IP is banned */
if ($system['viewer_ip_banned']) {
  apiError(__("Your IP has been blocked"), 401);
}

/* check if the viewer is banned */
if ($user->_is_banned) {
  apiError($user->_data['user_banned_message'], 401);
}


// 🚀 Starting the mobile app ...

// log session
$user->log_session();


// user authentication
isUserAuthenticated();


// init the app
require('libs/Express.php');
global $app;
$app = new Express();


// parse application/json
$app->use(expressJSON());


// set routes base path
$app->set('basePath', API_BASE);


// set exceptions handler
set_exception_handler(function ($e) {
  apiError($e->getMessage(), $e->getCode());
});


// routes
require('routes/core.php');
require('routes/modules.php');
