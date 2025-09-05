<?php
/**
 * updater wizard
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich - Handles - @sorydima @sorydev @durovshater @DmitrySoro90935 @tanechfund - also check https://dmitry.rechain.network for more information!
 */

// set system version
define('SYS_VER', '2.7');


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


// connect to the database
$db = new mysqli(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME, DB_PORT);
$db->set_charset('utf8');
if(mysqli_connect_error()) {
	_error(DB_ERROR);
}


// update
if(isset($_POST['submit'])) {

	// check valid purchase code
	try {
		$licence_key = get_licence_key($_POST['purchase_code']);
		if(is_empty($_POST['purchase_code']) || $licence_key === false) {
			_error("Error", "Please enter a valid purchase code");
		}
		$session_hash = $licence_key;
	} catch (Exception $e) {
		_error("Error", $e->getMessage());
	}


	// update the Delus tables
	$structure = "

CREATE TABLE `blacklist` (
  `node_id` int(10) unsigned NOT NULL auto_increment,
  `node_type` enum('ip','email','username') NOT NULL,
  `node_value` varchar(64) NOT NULL,
  `created_time` datetime NOT NULL,
  PRIMARY KEY (`node_id`)
) ENGINE=MyISAM;

CREATE TABLE `coinpayments_transactions` (
  `transaction_id` int(10) unsigned NOT NULL auto_increment,
  `transaction_txn_id` text NULL,
  `user_id` int(10) unsigned NOT NULL,
  `amount` varchar(32) NOT NULL,
  `product` text NOT NULL,
  `created_at` datetime NOT NULL,
  `last_update` datetime NOT NULL,
  `status` tinyint(1) unsigned NOT NULL,
  `status_message` text NULL,
  PRIMARY KEY (`transaction_id`)
) ENGINE=MyISAM row_format=DYNAMIC;

CREATE TABLE `SYSTEM_OPTIONS_TEMP` (
  `option_id` int(10) unsigned NOT NULL auto_increment,
  `option_name` varchar(128) NULL,
  `option_value` varchar(2048) NULL,
  UNIQUE KEY `option_name`(`option_name`),
  PRIMARY KEY (`option_id`)
) ENGINE=MyISAM row_format=DYNAMIC;

ALTER TABLE `ads_campaigns`
  MODIFY COLUMN `campaign_title` varchar(256) NOT NULL
  , MODIFY COLUMN `ads_url` varchar(256) NULL
  , MODIFY COLUMN `ads_image` varchar(256) NOT NULL;

ALTER TABLE `ads_system`
  MODIFY COLUMN `title` varchar(256) NOT NULL;

ALTER TABLE `announcements`
  MODIFY COLUMN `name` varchar(256) NOT NULL
  , MODIFY COLUMN `title` varchar(256) NOT NULL;

ALTER TABLE `bank_transfers`
  MODIFY COLUMN `bank_receipt` varchar(256) NOT NULL;

ALTER TABLE `blogs_categories`
  MODIFY COLUMN `category_name` varchar(256) NOT NULL;

ALTER TABLE `conversations_calls_audio`
  MODIFY COLUMN `from_user_token` mediumtext NOT NULL
  , MODIFY COLUMN `to_user_token` mediumtext NOT NULL;

ALTER TABLE `conversations_messages`
  MODIFY COLUMN `image` varchar(256) NOT NULL;

ALTER TABLE `custom_fields`
  MODIFY COLUMN `label` varchar(256) NOT NULL;

ALTER TABLE `developers_apps`
  MODIFY COLUMN `app_name` varchar(256) NOT NULL
  , MODIFY COLUMN `app_domain` varchar(256) NOT NULL
  , MODIFY COLUMN `app_redirect_url` varchar(256) NOT NULL
  , MODIFY COLUMN `app_description` mediumtext NOT NULL
  , MODIFY COLUMN `app_icon` varchar(256) NOT NULL;

ALTER TABLE `developers_apps_categories`
  MODIFY COLUMN `category_name` varchar(256) NOT NULL;

ALTER TABLE `developers_apps_users`
  MODIFY COLUMN `auth_key` varchar(128) NOT NULL
  , MODIFY COLUMN `access_token` varchar(128) NULL;

ALTER TABLE `emojis`
  MODIFY COLUMN `pattern` varchar(256) NOT NULL
  , MODIFY COLUMN `class` varchar(256) NOT NULL;

ALTER TABLE `events`
  MODIFY COLUMN `event_title` varchar(256) NOT NULL
  , MODIFY COLUMN `event_location` varchar(256) NULL
  , MODIFY COLUMN `event_cover` varchar(256) NULL
  , MODIFY COLUMN `event_cover_position` varchar(256) NULL;

ALTER TABLE `events_categories`
  MODIFY COLUMN `category_name` varchar(256) NOT NULL;

ALTER TABLE `forums`
  MODIFY COLUMN `forum_name` varchar(256) NOT NULL;

ALTER TABLE `forums_threads`
  MODIFY COLUMN `title` varchar(256) NOT NULL;

ALTER TABLE `games`
  MODIFY COLUMN `title` varchar(256) NOT NULL
  , MODIFY COLUMN `thumbnail` varchar(256) NOT NULL;

ALTER TABLE `gifts`
  MODIFY COLUMN `image` varchar(256) NOT NULL;

ALTER TABLE `groups`
  MODIFY COLUMN `group_title` varchar(256) NOT NULL
  , MODIFY COLUMN `group_picture` varchar(256) NULL
  , MODIFY COLUMN `group_cover` varchar(256) NULL
  , MODIFY COLUMN `group_cover_position` varchar(256) NULL;

ALTER TABLE `groups_categories`
  MODIFY COLUMN `category_name` varchar(256) NOT NULL;

ALTER TABLE `hashtags`
  MODIFY COLUMN `hashtag` varchar(256) NOT NULL;

ALTER TABLE `market_categories`
  MODIFY COLUMN `category_name` varchar(256) NOT NULL;

ALTER TABLE `movies`
  MODIFY COLUMN `title` varchar(256) NOT NULL
  , MODIFY COLUMN `poster` varchar(256) NULL;

ALTER TABLE `movies_genres`
  MODIFY COLUMN `genre_name` varchar(256) NOT NULL;

ALTER TABLE `notifications`
  MODIFY COLUMN `action` varchar(256) NOT NULL
  , MODIFY COLUMN `node_type` varchar(256) NOT NULL
  , MODIFY COLUMN `node_url` varchar(256) NOT NULL
  , MODIFY COLUMN `notify_id` varchar(256) NULL;

ALTER TABLE `packages`
  MODIFY COLUMN `name` varchar(256) NOT NULL
  , MODIFY COLUMN `icon` varchar(256) NOT NULL;

ALTER TABLE `packages_payments`
  MODIFY COLUMN `package_name` varchar(256) NOT NULL;

ALTER TABLE `pages`
  MODIFY COLUMN `page_title` varchar(256) NOT NULL
  , MODIFY COLUMN `page_picture` varchar(256) NULL
  , MODIFY COLUMN `page_cover` varchar(256) NULL
  , MODIFY COLUMN `page_cover_position` varchar(256) NULL
  , MODIFY COLUMN `page_company` varchar(256) NULL
  , MODIFY COLUMN `page_phone` varchar(256) NULL
  , MODIFY COLUMN `page_website` varchar(256) NULL
  , MODIFY COLUMN `page_location` varchar(256) NULL
  , MODIFY COLUMN `page_action_url` varchar(256) NULL
  , MODIFY COLUMN `page_social_facebook` varchar(256) NULL
  , MODIFY COLUMN `page_social_twitter` varchar(256) NULL
  , MODIFY COLUMN `page_social_youtube` varchar(256) NULL
  , MODIFY COLUMN `page_social_instagram` varchar(256) NULL
  , MODIFY COLUMN `page_social_linkedin` varchar(256) NULL
  , MODIFY COLUMN `page_social_vkontakte` varchar(256) NULL;

ALTER TABLE `pages_categories`
  MODIFY COLUMN `category_name` varchar(256) NOT NULL;

ALTER TABLE `posts`
  MODIFY COLUMN `location` varchar(256) NULL
  , MODIFY COLUMN `feeling_value` varchar(256) NULL
  , ADD COLUMN `is_hidden` enum('0','1') NOT NULL DEFAULT '0';

ALTER TABLE `posts_articles`
  MODIFY COLUMN `cover` varchar(256) NOT NULL
  , MODIFY COLUMN `title` varchar(256) NOT NULL;

ALTER TABLE `posts_audios`
  MODIFY COLUMN `source` varchar(256) NOT NULL;

ALTER TABLE `posts_colored_patterns`
  MODIFY COLUMN `background_image` varchar(256) NULL;

ALTER TABLE `posts_comments`
  MODIFY COLUMN `image` varchar(256) NULL;

ALTER TABLE `posts_files`
  MODIFY COLUMN `source` varchar(256) NOT NULL;

ALTER TABLE `posts_links`
  MODIFY COLUMN `source_host` varchar(256) NOT NULL
  , MODIFY COLUMN `source_title` varchar(256) NOT NULL;

ALTER TABLE `posts_media`
  MODIFY COLUMN `source_provider` varchar(256) NOT NULL
  , MODIFY COLUMN `source_type` varchar(256) NOT NULL
  , MODIFY COLUMN `source_title` varchar(256) NULL;

ALTER TABLE `posts_photos`
  MODIFY COLUMN `source` varchar(256) NOT NULL
  , ADD COLUMN `blur` enum('0','1') NOT NULL DEFAULT '0';

ALTER TABLE `posts_photos_albums`
  MODIFY COLUMN `title` varchar(256) NOT NULL;

ALTER TABLE `posts_polls_options`
  MODIFY COLUMN `text` varchar(256) NOT NULL;

ALTER TABLE `posts_products`
  MODIFY COLUMN `name` varchar(256) NOT NULL;

ALTER TABLE `posts_videos`
  MODIFY COLUMN `source` varchar(256) NOT NULL
  , MODIFY COLUMN `thumbnail` varchar(256) NULL;

ALTER TABLE `static_pages`
  MODIFY COLUMN `page_title` varchar(256) NOT NULL
  , ADD COLUMN `page_order` int(10) NOT NULL DEFAULT '1';

ALTER TABLE `stickers`
  MODIFY COLUMN `image` varchar(256) NOT NULL;

ALTER TABLE `stories_media`
  MODIFY COLUMN `source` varchar(256) NOT NULL;

ALTER TABLE `system_currencies`
  MODIFY COLUMN `name` varchar(256) NOT NULL
  , MODIFY COLUMN `code` varchar(32) NOT NULL;

ALTER TABLE `system_languages`
  MODIFY COLUMN `title` varchar(256) NOT NULL
  , MODIFY COLUMN `flag` varchar(256) NOT NULL;

ALTER TABLE `users`
  MODIFY COLUMN `user_latitude` varchar(256) NOT NULL DEFAULT '0'
  , MODIFY COLUMN `user_longitude` varchar(256) NOT NULL DEFAULT '0'
  , MODIFY COLUMN `user_firstname` varchar(256) NOT NULL
  , MODIFY COLUMN `user_lastname` varchar(256) NULL
  , MODIFY COLUMN `user_cover` varchar(256) NULL
  , MODIFY COLUMN `user_cover_position` varchar(256) NULL
  , MODIFY COLUMN `user_relationship` varchar(256) NULL
  , MODIFY COLUMN `user_website` varchar(256) NULL
  , MODIFY COLUMN `user_work_title` varchar(256) NULL
  , MODIFY COLUMN `user_work_place` varchar(256) NULL
  , MODIFY COLUMN `user_work_url` varchar(256) NULL
  , MODIFY COLUMN `user_current_city` varchar(256) NULL
  , MODIFY COLUMN `user_hometown` varchar(256) NULL
  , MODIFY COLUMN `user_edu_major` varchar(256) NULL
  , MODIFY COLUMN `user_edu_school` varchar(256) NULL
  , MODIFY COLUMN `user_edu_class` varchar(256) NULL
  , MODIFY COLUMN `user_social_facebook` varchar(256) NULL
  , MODIFY COLUMN `user_social_twitter` varchar(256) NULL
  , MODIFY COLUMN `user_social_youtube` varchar(256) NULL
  , MODIFY COLUMN `user_social_instagram` varchar(256) NULL
  , MODIFY COLUMN `user_social_linkedin` varchar(256) NULL
  , MODIFY COLUMN `user_social_vkontakte` varchar(256) NULL
  , MODIFY COLUMN `user_profile_background` varchar(256) NULL
  , ADD COLUMN `user_first_failed_login` datetime NULL
  , ADD COLUMN `user_failed_login_ip` varchar(64) NULL
  , ADD COLUMN `user_failed_login_count` int(10) unsigned NOT NULL DEFAULT '0';

ALTER TABLE `verification_requests`
  MODIFY COLUMN `photo` varchar(256) NULL
  , MODIFY COLUMN `passport` varchar(256) NULL;

ALTER TABLE `widgets`
  MODIFY COLUMN `title` varchar(256) NOT NULL
  , ADD COLUMN `place_order` int(10) unsigned NOT NULL DEFAULT '1';

    ";
	$db->multi_query($structure) or _error("Error", $db->error);


	// flush multi_queries
	do{} while(mysqli_more_results($db) && mysqli_next_result($db));


	// update tables collections
	$get_db_tbls = $db->query("show tables") or _error("Error", $db->error);
	while($db_tbl = $get_db_tbls->fetch_array()) {
		foreach($db_tbl as $key => $value) {
			$db->query("ALTER TABLE $value CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci");
		}
	}


	// convert system_options table
    $get_system_options = $db->query("SELECT * FROM system_options") or _error("SQL_ERROR");
    $system_options = $get_system_options->fetch_assoc();
	foreach ($system_options as $key => $value) {
		if($key == "id") continue;
		$db->query(sprintf("INSERT INTO `SYSTEM_OPTIONS_TEMP` (option_name, option_value) VALUES (%s, %s)", secure($key), secure($value) )) or _error("SQL_ERROR");
	}
    $db->query("DROP TABLE `system_options`") or _error("SQL_ERROR");
    $db->query("ALTER TABLE `SYSTEM_OPTIONS_TEMP` RENAME TO `system_options`") or _error("SQL_ERROR");


    // insert new system_options values
    $db->query("INSERT INTO system_options (option_name, option_value) VALUES
        ('2checkout_enabled', '0'),
        ('2checkout_merchant_code', ''),
        ('2checkout_mode', 'sandbox'),
        ('2checkout_private_key', ''),
        ('2checkout_publishable_key', ''),
        ('activity_posts_enabled', '1'),
        ('adult_images_action', 'blur'),
        ('adult_images_api_key', ''),
        ('adult_images_enabled', ''),
        ('brute_force_bad_login_limit', '5'),
        ('brute_force_detection_enabled', '1'),
        ('brute_force_lockout_time', '10'),
        ('bulksms_password', ''),
        ('bulksms_username', ''),
        ('coinpayments_enabled', '0'),
        ('coinpayments_ipn_secret', ''),
        ('coinpayments_merchant_id', ''),
        ('digitalocean_enabled', '0'),
        ('digitalocean_key', ''),
        ('digitalocean_secret', ''),
        ('digitalocean_space_name', ''),
        ('digitalocean_space_region', 'sfo2'),
        ('ftp_enabled', '0'),
        ('ftp_endpoint', ''),
        ('ftp_hostname', ''),
        ('ftp_password', ''),
        ('ftp_path', ''),
        ('ftp_port', ''),
        ('ftp_username', ''),
        ('infobip_password', ''),
        ('infobip_username', ''),
        ('sms_provider', 'twilio'),
        ('watermark_enabled', '0'),
        ('watermark_icon', ''),
        ('watermark_opacity', '1'),
        ('watermark_position', 'bottom right'),
        ('watermark_xoffset', '-30'),
        ('watermark_yoffset', '-30')") or _error("SQL_ERROR");


    // convert banned_ips table
    $get_banned_ips = $db->query("SELECT * FROM banned_ips") or _error("SQL_ERROR");
    while($banned_ip = $get_banned_ips->fetch_assoc()) {
        $db->query(sprintf("INSERT INTO `blacklist` (node_type, node_value, created_time) VALUES ('ip', %s, %s)", secure($banned_ip['ip']), secure($banned_ip['time']) )) or _error("SQL_ERROR");
    }
    $db->query("DROP TABLE `banned_ips`") or _error("SQL_ERROR");
    

	// update system settings
    update_system_options([ 
        'session_hash' => secure($session_hash)
    ], false);


	// create config file
	$config_string = '<?php  
	define("DB_NAME", "'.DB_NAME.'");
	define("DB_USER", "'.DB_USER.'");
	define("DB_PASSWORD", "'.DB_PASSWORD.'");
	define("DB_HOST", "'.DB_HOST.'");
	define("DB_PORT", "'.DB_PORT.'");
	define("SYS_URL", "'.SYS_URL.'");
	define("DEBUGGING", false);
	define("DEFAULT_LOCALE", "en_us");
	define("LICENCE_KEY", "'.$licence_key.'");
	?>';
	$config_file = 'includes/config.php';
	$handle = fopen($config_file, 'w') or _error("System Error", "Cannot create the config file");
	fwrite($handle, $config_string);
	fclose($handle);

	// Done
	_error("System Updated", "Delus has been updated to ".SYS_VER);
}

?>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge"> 
        <meta name="viewport" content="width=device-width, initial-scale=1"> 
        <title>Delus (<?php echo SYS_VER ?>) &rsaquo; Update</title>
        <link rel="stylesheet" type="text/css" href="includes/assets/js/Delus/installer/installer.css" />
        <script src="includes/assets/js/Delus/installer/modernizr.custom.js"></script>
    </head>

    <body>
        <div class="container">
            <div class="fs-form-wrap" id="fs-form-wrap">
                <div class="fs-title">
                    <h1>Delus (<?php echo SYS_VER ?>) Update</h1>
                </div>
                <form id="myform" class="fs-form fs-form-full" autocomplete="off" action="update.php" method="post">
                    <ol class="fs-fields">

                        <li>
                            <p class="fs-field-label fs-anim-upper">
                                Welcome to <strong>Delus</strong> updating process! Just fill in the information below.
                            </p>
                        </li>

                        <li>
                            <label class="fs-field-label fs-anim-upper" for="purchase_code" data-info="The purchase code of Delus">Purchase Code</label>
                            <input class="fs-anim-lower" id="purchase_code" name="purchase_code" type="text" placeholder="xxx-xx-xxxx" required/>
                        </li>

                    </ol>
                    <button class="fs-submit" name="submit" type="submit">Update</button>
                </form>
            </div>
        </div>
        <script src="includes/assets/js/Delus/installer/classie.js"></script>
        <script src="includes/assets/js/Delus/installer/fullscreenForm.js"></script>
        <script>
            (function() {
                var formWrap = document.getElementById( 'fs-form-wrap' );
                new FForm( formWrap, {
                    onReview : function() {
                        classie.add( document.body, 'overview' );
                    }
                } );
            })();
        </script>
    </body>
</html>