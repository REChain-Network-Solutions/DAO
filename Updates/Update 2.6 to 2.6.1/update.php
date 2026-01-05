<?php
/**
 * Delus updater
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich
 */

// set system version
define('SYS_VER', '2.6.1');


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
$db = new mysqli(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME);
$db->set_charset('utf8');
if(mysqli_connect_error()) {
    _error(DB_ERROR);
}


// install
if(isset($_POST['submit'])) {

    // [1] check valid purchase code
    /* get licence key */
    try {
        $licence_key = get_licence_key($_POST['purchase_code']);
        if(is_empty($_POST['purchase_code']) || $licence_key === false) {
            _error("Error", "Please enter a valid purchase code");
        }
        /* update session hash for AJAX CSRF security */
        $session_hash = $licence_key;
    } catch (Exception $e) {
        _error("Error", $e->getMessage());
    }
    
    
    // [2] update the Delus tables
    $structure = "

CREATE TABLE `developers_apps` (
  `app_id` int(10) unsigned NOT NULL auto_increment,
  `app_user_id` int(10) unsigned NOT NULL,
  `app_category_id` int(10) unsigned NOT NULL,
  `app_auth_id` varchar(128) NOT NULL,
  `app_auth_secret` varchar(128) NOT NULL,
  `app_name` varchar(255) NOT NULL,
  `app_domain` varchar(255) NOT NULL,
  `app_redirect_url` varchar(255) NOT NULL,
  `app_description` text NOT NULL,
  `app_icon` varchar(255) NOT NULL,
  `app_date` datetime NOT NULL,
  UNIQUE KEY `app_auth_id`(`app_auth_id`),
  UNIQUE KEY `app_auth_secret`(`app_auth_secret`),
  PRIMARY KEY (`app_id`)
) ENGINE=MyISAM;

CREATE TABLE `developers_apps_categories` (
  `category_id` int(10) unsigned NOT NULL auto_increment,
  `category_name` varchar(255) NOT NULL,
  `category_order` int(10) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`category_id`)
) ENGINE=MyISAM row_format=DYNAMIC;

INSERT INTO `developers_apps_categories` (`category_id`, `category_name`, `category_order`) VALUES
(1, 'Business and Pages', 1),
(2, 'Community &amp; Government', 2),
(3, 'Education', 3),
(4, 'Entertainment', 4),
(5, 'Entertainment', 5),
(6, 'Games', 6),
(7, 'Lifestyle', 7),
(8, 'Messaging', 8),
(9, 'News', 9),
(10, 'Shopping', 10),
(11, 'Social Networks &amp; Dating', 11),
(12, 'Utility &amp; Productivity', 12);

CREATE TABLE `developers_apps_users` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `app_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `auth_key` varchar(255) NOT NULL,
  `access_token` varchar(255) NULL,
  `access_token_date` datetime NULL,
  UNIQUE KEY `page_id_user_id`(`app_id`,`user_id`),
  PRIMARY KEY (`id`)
) ENGINE=MyISAM row_format=FIXED;

CREATE TABLE `posts_colored_patterns` (
  `pattern_id` int(10) unsigned NOT NULL auto_increment,
  `type` enum('color','image') NOT NULL DEFAULT 'color',
  `background_image` varchar(255) NULL,
  `background_color_1` varchar(32) NULL,
  `background_color_2` varchar(32) NULL,
  `text_color` varchar(32) NULL,
  PRIMARY KEY (`pattern_id`)
) ENGINE=MyISAM row_format=DYNAMIC;

INSERT INTO `posts_colored_patterns` (`pattern_id`, `type`, `background_image`, `background_color_1`, `background_color_2`, `text_color`) VALUES
(1, 'image', 'patterns/1.jpg', NULL, NULL, '#FFFFFF'),
(2, 'image', 'patterns/2.jpg', NULL, NULL, '#FFFFFF'),
(3, 'image', 'patterns/3.jpg', NULL, NULL, '#FFFFFF'),
(4, 'image', 'patterns/4.jpg', '', '', '#000000'),
(5, 'image', 'patterns/5.jpg', NULL, NULL, '#FFFFFF'),
(6, 'color', NULL, '#FF00FF', '#030355', '#FFF300'),
(7, 'color', '', '#FF003D', '#D73A3A', '#FFFFFF');

ALTER TABLE `affiliates_payments`
  CHANGE COLUMN `email` `method_value` TEXT NOT NULL;

ALTER TABLE `blogs_categories`
  ADD COLUMN `category_order` int(10) unsigned NOT NULL DEFAULT '1';

ALTER TABLE `events`
  ADD COLUMN `event_publish_enabled` enum('0','1') NOT NULL DEFAULT '1'
  , ADD COLUMN `event_publish_approval_enabled` enum('0','1') NOT NULL DEFAULT '0';

ALTER TABLE `events_categories`
  ADD COLUMN `category_order` int(10) unsigned NOT NULL DEFAULT '1';

ALTER TABLE `groups`
  ADD COLUMN `group_publish_enabled` enum('0','1') NOT NULL DEFAULT '1'
  , ADD COLUMN `group_publish_approval_enabled` enum('0','1') NOT NULL DEFAULT '0';

ALTER TABLE `groups_categories`
  ADD COLUMN `category_order` int(10) unsigned NOT NULL DEFAULT '1';

ALTER TABLE `market_categories`
  ADD COLUMN `category_order` int(10) unsigned NOT NULL DEFAULT '1';

ALTER TABLE `movies_genres`
  ADD COLUMN `genre_order` int(10) unsigned NOT NULL DEFAULT '1';

ALTER TABLE `notifications`
  MODIFY COLUMN `action` varchar(255) NOT NULL
  , MODIFY COLUMN `node_type` varchar(255) NOT NULL;

ALTER TABLE `pages`
  DROP COLUMN `page_social_google`;

ALTER TABLE `pages_categories`
  ADD COLUMN `category_order` int(10) unsigned NOT NULL DEFAULT '1';

ALTER TABLE `points_payments`
  CHANGE COLUMN `email` `method_value` TEXT NOT NULL;

ALTER TABLE `posts`
  ADD COLUMN `group_approved` enum('0','1') NOT NULL DEFAULT '1'
  , ADD COLUMN `event_approved` enum('0','1') NOT NULL DEFAULT '1'
  , ADD COLUMN `colored_pattern` int(10) unsigned NULL;

ALTER TABLE `posts_links`
  MODIFY COLUMN `source_thumbnail` text NOT NULL;

ALTER TABLE `system_options`
  MODIFY COLUMN `affiliate_payment_method` text NOT NULL
  , MODIFY COLUMN `points_payment_method` text NOT NULL
  , ADD COLUMN `colored_posts_enabled` enum('0','1') NOT NULL DEFAULT '1'
  , ADD COLUMN `unusual_login_enabled` enum('0','1') NOT NULL DEFAULT '1'
  , ADD COLUMN `newsletter_consent` enum('0','1') NOT NULL DEFAULT '1'
  , ADD COLUMN `google_login_enabled` enum('0','1') NOT NULL DEFAULT '0'
  , ADD COLUMN `google_appid` varchar(255) NULL
  , ADD COLUMN `google_secret` varchar(255) NULL
  , ADD COLUMN `system_profile_background_enabled` enum('0','1') NOT NULL DEFAULT '1'
  , ADD COLUMN `affiliate_payment_method_custom` varchar(255) NULL
  , ADD COLUMN `points_payment_method_custom` varchar(255) NULL
  , ADD COLUMN `developers_apps_enabled` enum('0','1') NOT NULL DEFAULT '0'
  , ADD COLUMN `developers_share_enabled` enum('0','1') NOT NULL DEFAULT '0';

ALTER TABLE `users`
  DROP COLUMN `user_social_google`
  , MODIFY COLUMN `facebook_id` varchar(128) NULL
  , MODIFY COLUMN `twitter_id` varchar(128) NULL
  , MODIFY COLUMN `instagram_id` varchar(128) NULL
  , MODIFY COLUMN `linkedin_id` varchar(128) NULL
  , MODIFY COLUMN `vkontakte_id` varchar(128) NULL
  , ADD COLUMN `user_profile_background` varchar(255) NULL
  , ADD COLUMN `google_connected` enum('0','1') NOT NULL DEFAULT '0'
  , ADD COLUMN `google_id` varchar(128) NULL;

ALTER TABLE `users` ADD UNIQUE KEY `google_id`(`google_id`);

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

    // update system settings [affiliate_payment_method]
    $db->query("UPDATE system_options SET affiliate_payment_method = 'paypal, skrill' WHERE affiliate_payment_method = 'both'") or _error("Error", $db->error);

    // update system settings [points_payment_method]
    $db->query("UPDATE system_options SET points_payment_method = 'paypal, skrill' WHERE points_payment_method = 'both'") or _error("Error", $db->error);

    // update system settings
    $db->query(sprintf("UPDATE system_options SET session_hash = %s", secure($session_hash) )) or _error("Error", $db->error);

    // create config file
    $config_string = '<?php  
    define("DB_NAME", "'.DB_NAME.'");
    define("DB_USER", "'.DB_USER.'");
    define("DB_PASSWORD", "'.DB_PASSWORD.'");
    define("DB_HOST", "'.DB_HOST.'");
    define("DB_PORT", "3306");
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