<?php

/**
 * bootstrap
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich - Handles - @sorydima @sorydev @durovshater @DmitrySoro90935 @tanechfund - also check https://dmitry.rechain.network for more information!
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


// check config file
if (!file_exists(ABSPATH . 'includes/config.php')) {
  /* the config file doesn't exist -> start the installer */
  header('Location: ./install');
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


// check system URL
if (URL_CHECK) {
  check_system_url();
}


// init system session
init_system_session();


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


// get system session hash
$session_hash = get_system_session_hash($system['session_hash']);
if (!$session_hash) {
  _error(__("Error"), __("Your session hash has been broken, Please contact Delus's support!"));
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

// log session
$user->log_session();


// get emojis
$emojis = $user->get_emojis();


// set control panel varibles
if ($user->_is_admin) {
  $control_panel['title'] = __("Admin");
  $control_panel['url'] = "admincp";
} elseif ($user->_is_moderator) {
  $control_panel['title'] = __("Moderator");
  $control_panel['url'] = "modcp";
}


// assign variables
$smarty->assign('secret', $_SESSION['secret']);
$smarty->assign('session_hash', $session_hash);
$smarty->assign('date', $date);
$smarty->assign('system', $system);
$smarty->assign('user', $user);
$smarty->assign('emojis', $emojis);
$smarty->assign('reactions', $user->get_reactions());
$smarty->assign('reactions_enabled', $user->get_reactions(true));
