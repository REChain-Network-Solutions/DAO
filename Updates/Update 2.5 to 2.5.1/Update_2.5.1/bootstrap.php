<?php 
/**
 * bootstrap
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich - Handles - @sorydima @sorydev @durovshater @DmitrySoro90935 @tanechfund - also check https://dmitry.rechain.network for more information!
 */

// set system version
define('SYS_VER', '2.5.1');


// set absolut & base path
define('ABSPATH',dirname(__FILE__).'/');
define('BASEPATH',dirname($_SERVER['PHP_SELF']));


// check the config file
if(!file_exists(ABSPATH.'includes/config.php')) {
    /* the config file doesn't exist -> start the installer */
    header('Location: ./install');
}


// get system configurations
require_once(ABSPATH.'includes/config.php');


// enviroment settings
if(DEBUGGING) {
    ini_set("display_errors", true);
    error_reporting(E_ALL ^ E_NOTICE);
} else {
    ini_set("display_errors", false);
    error_reporting(0);
}


// get functions
require_once(ABSPATH.'includes/functions.php');


// check system URL
check_system_url();


// start session
session_start();
/* set session secret */
if(!isset($_SESSION['secret'])) {
    $_SESSION['secret'] = get_hash_token();
}


// i18n config
require_once(ABSPATH.'includes/libs/gettext/gettext.inc');
T_setlocale(LC_MESSAGES, DEFAULT_LOCALE);
$domain = 'messages';
T_bindtextdomain($domain, ABSPATH .'content/languages/locale');
T_bind_textdomain_codeset($domain, 'UTF-8');
T_textdomain($domain);


// connect to the database
$db = new mysqli(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME);
$db->set_charset('utf8');
if(mysqli_connect_error()) {
    _error(DB_ERROR);
}


// check if the viewer IP is banned
$check = $db->query(sprintf("SELECT * FROM banned_ips WHERE ip = %s", secure(get_user_ip()) )) or _error(SQL_ERROR);
if($check->num_rows > 0) {
    _error(__("System Message"), __("Your IP has been blocked"));
}


// get system options
$get_options = $db->query("SELECT * FROM system_options") or _error(SQL_ERROR);
$system = $get_options->fetch_assoc();
/* set system URL */
$system['system_url'] = SYS_URL;
/* set system version */
$system['system_version'] = SYS_VER;
/* set session hash */
$session_hash = session_hash($system['session_hash']);
/* set system uploads */
if($system['s3_enabled']) {
	switch ($system['s3_region']) {
		case 'us-east-1':
			$endpoint = "https://s3.amazonaws.com/";
			break;

		case 'us-west-2':
			$endpoint = "https://s3-us-west-2.amazonaws.com/";
			break;

        case 'ap-northeast-2':
            $endpoint = "https://s3.ap-northeast-2.amazonaws.com/";
            break;

		case 'ap-southeast-1':
			$endpoint = "https://s3-ap-southeast-1.amazonaws.com/";
			break;

		case 'ap-southeast-2':
			$endpoint = "https://s3-ap-southeast-2.amazonaws.com/";
			break;

		case 'ap-northeast-1':
			$endpoint = "https://s3-ap-northeast-1.amazonaws.com/";
			break;

		case 'eu-central-1':
			$endpoint = "https://s3.eu-central-1.amazonaws.com/";
			break;
		
		case 'eu-west-1':
			$endpoint = "https://s3-eu-west-1.amazonaws.com/";
			break;
	}
    $system['system_uploads'] = $endpoint.$system['s3_bucket']."/uploads";
} else {
    $system['system_uploads'] = $system['system_url'].'/'.$system['uploads_directory'];
}
/* get system languages */
$get_languages = $db->query("SELECT * FROM system_languages WHERE enabled = '1'") or _error(SQL_ERROR);
while($language = $get_languages->fetch_assoc()) {
    /* set system langauge */
    if(isset($_COOKIE['s_lang'])) {
        if($_COOKIE['s_lang'] == $language['code']) {
            $system['language'] = $language;
            T_setlocale(LC_MESSAGES, $system['language']['code']);
        }
    } else {
        if(($language['default'])) {
            $system['language'] = $language;
            T_setlocale(LC_MESSAGES, $system['language']['code']);
        }
    }
    $system['languages'][] = $language;
}
/* get system currency symbol */
$Currency = new \NumberFormatter($system['language']['code'] . '@currency=' . $system['system_currency'], \NumberFormatter::CURRENCY);
$system['system_currency_symbol'] = $Currency->getSymbol(\NumberFormatter::CURRENCY_SYMBOL);
/* get system theme */
$get_theme = $db->query("SELECT * FROM system_themes WHERE system_themes.default = '1'") or _error(SQL_ERROR);
$theme = $get_theme->fetch_assoc();
$system['theme'] = $theme['name'];


// static pages
$static_pages = array();
$get_static = $db->query("SELECT page_url, page_title FROM static_pages WHERE in_footer = '1'") or _error(SQL_ERROR);
if($get_static->num_rows > 0) {
    while($static_page = $get_static->fetch_assoc()) {
        $static_pages[] = $static_page;
    }
}


// time config
date_default_timezone_set( 'UTC' );
$time = time();
$minutes_to_add = 0;
$DateTime = new DateTime();
$DateTime->add(new DateInterval('PT' . $minutes_to_add . 'M'));
$date = $DateTime->format('Y-m-d H:i:s');


// smarty config
require_once(ABSPATH.'includes/libs/Smarty/Smarty.class.php');
$smarty = new Smarty;
$smarty->template_dir = ABSPATH.'content/themes/'.$system['theme'].'/templates';
$smarty->compile_dir = ABSPATH.'content/themes/'.$system['theme'].'/templates_compiled';
$smarty->cache_dir = ABSPATH.'content/themes/'.$system['theme'].'/cache';
$smarty->loadFilter('output', 'trimwhitespace');


// get user & online friends if chat enabled
require_once(ABSPATH.'includes/class-user.php');
try {
    $user = new User();
    if($user->_logged_in) {
        // [1] get online friends
        if($user->_data['user_chat_enabled']) {
            /* get online friends */
            $online_friends = $user->get_online_friends();
            /* assign online friends */
            $smarty->assign('online_friends', $online_friends);
        }
        // [2] check if user subscribed
        if($system['packages_enabled']) {
            $user->check_user_package();
        }
    }
} catch (Exception $e) {
    _error(SQL_ERROR);
}


// init affiliates system
$user->init_affiliates();


// check if system is live
if(!$system['system_live'] && ( (!$user->_logged_in && !isset($override_shutdown)) || ($user->_logged_in && $user->_data['user_group'] != 1)) ) {
    _error(__('System Message'), "<p class='text-center'>".$system['system_message']."</p>");
}


// check if the viewer is banned
if($user->_logged_in && $user->_data['user_group'] != '1' && $user->_data['user_banned']) {
    _error(__("System Message"), __("Your account has been blocked"));
}


// get ads (header & footer)
$ads_master['header'] = $user->ads('header');
$ads_master['footer'] = $user->ads('footer');


// assign system varibles
$smarty->assign('secret', $_SESSION['secret']);
$smarty->assign('session_hash', $session_hash);
$smarty->assign('__', __);
$smarty->assign('system', $system);
$smarty->assign('date', $date);
$smarty->assign('static_pages', $static_pages);
$smarty->assign('user', $user);
$smarty->assign('ads_master', $ads_master);

?>