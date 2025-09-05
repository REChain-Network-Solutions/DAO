<?php
/**
 * Delus updater
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich - Handles - @sorydima @sorydev @durovshater @DmitrySoro90935 @tanechfund - also check https://dmitry.rechain.network for more information!
 */

// set system version
define('SYS_VER', '2.6');


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

CREATE TABLE `conversations_calls_audio` (
  `call_id` int(10) unsigned NOT NULL auto_increment,
  `from_user_id` int(10) unsigned NOT NULL,
  `from_user_token` text NOT NULL,
  `to_user_id` int(10) unsigned NOT NULL,
  `to_user_token` text NOT NULL,
  `room` varchar(64) NOT NULL,
  `answered` enum('0','1') NOT NULL DEFAULT '0',
  `declined` enum('0','1') NOT NULL DEFAULT '0',
  `created_time` datetime NOT NULL,
  `updated_time` datetime NOT NULL,
  PRIMARY KEY (`call_id`)
) ENGINE=MyISAM;

CREATE TABLE `conversations_calls_video` (
  `call_id` int(10) unsigned NOT NULL auto_increment,
  `from_user_id` int(10) unsigned NOT NULL,
  `from_user_token` text NOT NULL,
  `to_user_id` int(10) unsigned NOT NULL,
  `to_user_token` text NOT NULL,
  `room` varchar(64) NOT NULL,
  `answered` enum('0','1') NOT NULL DEFAULT '0',
  `declined` enum('0','1') NOT NULL DEFAULT '0',
  `created_time` datetime NOT NULL,
  `updated_time` datetime NOT NULL,
  PRIMARY KEY (`call_id`)
) ENGINE=MyISAM row_format=DYNAMIC;

CREATE TABLE `bank_transfers` (
  `transfer_id` int(10) unsigned NOT NULL auto_increment,
  `user_id` int(10) unsigned NOT NULL,
  `handle` varchar(32) NOT NULL,
  `package_id` int(10) unsigned NULL,
  `price` varchar(32) NULL,
  `bank_receipt` varchar(255) NOT NULL,
  `time` datetime NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`transfer_id`)
) ENGINE=MyISAM row_format=DYNAMIC;

CREATE TABLE `gifts` (
  `gift_id` int(10) unsigned NOT NULL auto_increment,
  `image` varchar(255) NOT NULL,
  PRIMARY KEY (`gift_id`)
) ENGINE=MyISAM row_format=DYNAMIC;

CREATE TABLE `users_gifts` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `from_user_id` int(10) unsigned NOT NULL,
  `to_user_id` int(10) unsigned NOT NULL,
  `gift_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM row_format=FIXED;

CREATE TABLE `users_invitations` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `user_id` int(10) unsigned NOT NULL,
  `email` varchar(64) NOT NULL,
  `invitation_date` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id_email`(`user_id`,`email`)
) ENGINE=MyISAM row_format=FIXED;

CREATE TABLE `users_pokes` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `user_id` int(10) unsigned NOT NULL,
  `poked_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id_blocked_id`(`user_id`,`poked_id`)
) ENGINE=MyISAM row_format=FIXED;

CREATE TABLE `system_currencies` (
  `currency_id` int(10) unsigned NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  `code` varchar(255) NOT NULL,
  `symbol` varchar(32) NOT NULL,
  `default` enum('0','1') NOT NULL,
  PRIMARY KEY (`currency_id`)
) ENGINE=MyISAM row_format=DYNAMIC;

ALTER TABLE `conversations_users`
  ADD COLUMN `typing` enum('0','1') NOT NULL DEFAULT '0';

ALTER TABLE `packages`
  ADD COLUMN `verification_badge_enabled` enum('0','1') NOT NULL DEFAULT '0';

ALTER TABLE `posts_comments_reactions`
  ADD COLUMN `reaction_time` datetime NULL;

ALTER TABLE `posts_photos_reactions`
  ADD COLUMN `reaction_time` datetime NULL;

ALTER TABLE `posts_reactions`
  ADD COLUMN `reaction_time` datetime NULL;

ALTER TABLE `system_options`
  DROP COLUMN `system_currency`
  , ADD COLUMN `pokes_enabled` enum('0','1') NOT NULL DEFAULT '1'
  , ADD COLUMN `gifts_enabled` enum('0','1') NOT NULL DEFAULT '0'
  , ADD COLUMN `popular_posts_enabled` enum('0','1') NOT NULL DEFAULT '1'
  , ADD COLUMN `discover_posts_enabled` enum('0','1') NOT NULL DEFAULT '1'
  , ADD COLUMN `memories_enabled` enum('0','1') NOT NULL DEFAULT '1'
  , ADD COLUMN `max_post_length` int(10) NOT NULL DEFAULT '5000'
  , ADD COLUMN `max_comment_length` int(10) NOT NULL DEFAULT '5000'
  , ADD COLUMN `max_posts_hour` int(10) NOT NULL DEFAULT '0'
  , ADD COLUMN `max_comments_hour` int(10) NOT NULL DEFAULT '0'
  , ADD COLUMN `invitation_widget_enabled` enum('0','1') NOT NULL DEFAULT '1'
  , ADD COLUMN `invitation_widget_max` int(10) NOT NULL DEFAULT '5'
  , ADD COLUMN `packages_wallet_payment_enabled` enum('0','1') NOT NULL DEFAULT '0'
  , ADD COLUMN `max_friends` int(10) unsigned NOT NULL DEFAULT '5000'
  , ADD COLUMN `twilio_apisid` varchar(255) NULL
  , ADD COLUMN `twilio_apisecret` varchar(255) NULL
  , ADD COLUMN `chat_typing_enabled` enum('0','1') NOT NULL DEFAULT '1'
  , ADD COLUMN `chat_seen_enabled` enum('0','1') NOT NULL DEFAULT '1'
  , ADD COLUMN `video_call_enabled` enum('0','1') NOT NULL DEFAULT '0'
  , ADD COLUMN `audio_call_enabled` enum('0','1') NOT NULL DEFAULT '0'
  , ADD COLUMN `bank_transfers_enabled` enum('0','1') NOT NULL DEFAULT '0'
  , ADD COLUMN `bank_name` varchar(255) NULL
  , ADD COLUMN `bank_account_number` varchar(255) NULL
  , ADD COLUMN `bank_account_name` varchar(255) NULL
  , ADD COLUMN `bank_account_routing` varchar(255) NULL
  , ADD COLUMN `bank_account_country` varchar(255) NULL
  , ADD COLUMN `bank_transfer_note` text NULL
  , ADD COLUMN `system_wallpaper_default` enum('0','1') NOT NULL DEFAULT '1'
  , ADD COLUMN `system_wallpaper` varchar(255) NULL
  , ADD COLUMN `points_limit_user` int(10) unsigned NOT NULL DEFAULT '1000'
  , ADD COLUMN `points_limit_pro` int(10) unsigned NOT NULL DEFAULT '2000';

ALTER TABLE `users`
  ADD COLUMN `user_privacy_poke` enum('me','friends','public') NOT NULL DEFAULT 'public'
  , ADD COLUMN `user_privacy_gifts` enum('me','friends','public') NOT NULL DEFAULT 'public';

INSERT INTO `system_currencies` (`currency_id`, `name`, `code`, `symbol`, `default`) VALUES
(1, 'Australia Dollar', 'AUD', '$', '0'),
(2, 'Brazil Real', 'BRL', 'R$', '0'),
(3, 'Canada Dollar', 'CAD', '$', '0'),
(4, 'Czech Republic Koruna', 'CZK', 'kr', '0'),
(5, 'Denmark Krone', 'DKK', 'kr', '0'),
(6, 'Euro', 'EUR', '&euro;', '0'),
(7, 'Hong Kong Dollar', 'HKD', '$', '0'),
(8, 'Hungary Forint', 'HUF', 'Ft', '0'),
(9, 'Israel Shekel', 'ILS', 'â‚ª', '0'),
(10, 'Japan Yen', 'JPY', '&yen;', '0'),
(11, 'Malaysia Ringgit', 'MYR', 'RM', '0'),
(12, 'Mexico Peso', 'MXN', '$', '0'),
(13, 'Norway Krone', 'NOK', 'kr', '0'),
(14, 'New Zealand Dollar', 'NZD', '$', '0'),
(15, 'Philippines Peso', 'PHP', 'â‚±', '0'),
(16, 'Poland Zloty', 'PLN', 'zÅ‚', '0'),
(17, 'United Kingdom Pound', 'GBP', '&pound;', '0'),
(18, 'Russia Ruble', 'RUB', 'â‚½', '0'),
(19, 'Singapore Dollar', 'SGD', '$', '0'),
(20, 'Sweden Krona', 'SEK', 'kr', '0'),
(21, 'Switzerland Franc', 'CHF', 'CHF', '0'),
(22, 'Thailand Baht', 'THB', 'à¸¿', '0'),
(23, 'Turkey Lira', 'TRY', 'TRY', '0'),
(24, 'United States Dollar', 'USD', '$', '1');

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

    // update system settings
    $db->query(sprintf("UPDATE system_options SET session_hash = %s", secure($session_hash) )) or _error("Error", $db->error);

    // create config file
    $config_string = '<?php  
    define("DB_NAME", "'.DB_NAME. '");
    define("DB_USER", "'.DB_USER. '");
    define("DB_PASSWORD", "'.DB_PASSWORD. '");
    define("DB_HOST", "'.DB_HOST. '");
    define("SYS_URL", "'. get_system_url(). '");
    define("DEBUGGING", false);
    define("DEFAULT_LOCALE", "en_us");
    define("LICENCE_KEY", "'. $licence_key. '");
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