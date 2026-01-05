<?php
/**
 * Delus updater
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich
 */

// set system version
define('SYS_VER', '2.5.6');


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

CREATE TABLE `games_players` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `game_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `last_played_time` datetime NULL,
  UNIQUE KEY `game_id_user_id`(`game_id`,`user_id`),
  PRIMARY KEY (`id`)
) ENGINE=MyISAM row_format=FIXED;

CREATE TABLE `movies` (
  `movie_id` int(10) unsigned NOT NULL auto_increment,
  `source` text NOT NULL,
  `source_type` varchar(64) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text NULL,
  `imdb_url` text NULL,
  `stars` text NULL,
  `release_year` int(10) NULL,
  `duration` int(10) NULL,
  `genres` mediumtext NULL,
  `poster` varchar(255) NULL,
  `views` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`movie_id`)
) ENGINE=MyISAM;

CREATE TABLE `movies_genres` (
  `genre_id` int(10) unsigned NOT NULL auto_increment,
  `genre_name` varchar(255) NOT NULL,
  `genre_description` text NOT NULL,
  PRIMARY KEY (`genre_id`)
) ENGINE=MyISAM row_format=DYNAMIC;

INSERT INTO `movies_genres` (`genre_id`, `genre_name`, `genre_description`) VALUES
(1, 'Action', ''),
(2, 'Adventure', ''),
(3, 'Animation', ''),
(4, 'Comedy', ''),
(5, 'Crime', ''),
(6, 'Documentary', ''),
(7, 'Drama', ''),
(8, 'Family', ''),
(9, 'Fantasy', ''),
(10, 'History', ''),
(11, 'Horror', ''),
(12, 'Musical', ''),
(13, 'Mythological', ''),
(14, 'Romance', ''),
(15, 'Sport', ''),
(16, 'TV Show', ''),
(17, 'Thriller', ''),
(18, 'War', '');

CREATE TABLE `points_payments` (
  `payment_id` int(10) NOT NULL auto_increment,
  `user_id` int(10) unsigned NOT NULL,
  `email` varchar(64) NOT NULL,
  `amount` varchar(32) NOT NULL,
  `method` varchar(64) NOT NULL,
  `time` datetime NOT NULL,
  `status` tinyint(1) NOT NULL,
  PRIMARY KEY (`payment_id`)
) ENGINE=MyISAM row_format=DYNAMIC;

ALTER TABLE `posts`
  ADD COLUMN `comments_disabled` enum('0','1') NOT NULL DEFAULT '0';

ALTER TABLE `posts_products`
  ADD COLUMN `status` enum('new','old') NOT NULL DEFAULT 'new';

ALTER TABLE `stories`
  DROP COLUMN `text`;

ALTER TABLE `stories_media`
  ADD COLUMN `text` text NOT NULL
  , ADD COLUMN `time` datetime NOT NULL;

ALTER TABLE `system_options`
  MODIFY COLUMN `default_privacy` enum('public','friends','me') NOT NULL DEFAULT 'public'
  , MODIFY COLUMN `forums_enabled` enum('0','1') NOT NULL DEFAULT '0'
  , ADD COLUMN `movies_enabled` enum('0','1') NOT NULL DEFAULT '0'
  , ADD COLUMN `adblock_detector_enabled` enum('0','1') NOT NULL DEFAULT '1'
  , ADD COLUMN `gif_enabled` enum('0','1') NOT NULL DEFAULT '0'
  , ADD COLUMN `giphy_key` varchar(255) NULL
  , ADD COLUMN `two_factor_enabled` enum('0','1') NOT NULL DEFAULT '0'
  , ADD COLUMN `two_factor_type` enum('email','sms','google') NOT NULL DEFAULT 'email'
  , ADD COLUMN `points_enabled` enum('0','1') NOT NULL DEFAULT '0'
  , ADD COLUMN `points_money_withdraw_enabled` enum('0','1') NOT NULL DEFAULT '0'
  , ADD COLUMN `points_payment_method` enum('paypal','skrill','both') NOT NULL DEFAULT 'both'
  , ADD COLUMN `points_min_withdrawal` int(10) unsigned NOT NULL DEFAULT '50'
  , ADD COLUMN `points_money_transfer_enabled` enum('0','1') NOT NULL DEFAULT '0'
  , ADD COLUMN `points_per_currency` int(10) unsigned NOT NULL DEFAULT '100'
  , ADD COLUMN `points_per_post` int(10) unsigned NOT NULL DEFAULT '20'
  , ADD COLUMN `points_per_comment` int(10) unsigned NOT NULL DEFAULT '10'
  , ADD COLUMN `points_per_reaction` int(10) unsigned NOT NULL DEFAULT '5';

ALTER TABLE `users`
  DROP COLUMN `user_activation_key`
  , MODIFY COLUMN `user_privacy_newsletter` enum('0','1') NOT NULL DEFAULT '1'
  , ADD COLUMN `user_email_verified` enum('0','1') NOT NULL DEFAULT '0'
  , ADD COLUMN `user_email_verification_code` varchar(64) NULL
  , ADD COLUMN `user_phone_verified` enum('0','1') NOT NULL DEFAULT '0'
  , ADD COLUMN `user_phone_verification_code` varchar(64) NULL
  , ADD COLUMN `user_two_factor_enabled` enum('0','1') NOT NULL DEFAULT '0'
  , ADD COLUMN `user_two_factor_type` enum('email','sms','google') NULL
  , ADD COLUMN `user_two_factor_key` varchar(64) NULL
  , ADD COLUMN `user_two_factor_gsecret` varchar(64) NULL
  , ADD COLUMN `user_latitude` varchar(255) NOT NULL DEFAULT '0'
  , ADD COLUMN `user_longitude` varchar(255) NOT NULL DEFAULT '0'
  , ADD COLUMN `user_location_updated` datetime NULL
  , ADD COLUMN `user_points` int(10) NOT NULL DEFAULT '0';

ALTER TABLE `verification_requests`
  ADD COLUMN `photo` varchar(255) NULL
  , ADD COLUMN `passport` varchar(255) NULL
  , ADD COLUMN `message` text NULL;

DROP TABLE `v2.5.5`.`game_players`;

";

    $db->multi_query($structure) or _error("Error", $db->error);
    // flush multi_queries
    do{} while(mysqli_more_results($db) && mysqli_next_result($db));

    // [3] update tables collections
    $get_db_tbls = $db->query("show tables") or _error("Error", $db->error);
    while($db_tbl = $get_db_tbls->fetch_array()) {
        foreach($db_tbl as $key => $value) {
            $db->query("ALTER TABLE $value CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_bin");
        }
    }

    // [4] users & ads_users_wallet_transactions table
    $db->query("UPDATE users SET user_privacy_newsletter = '1', user_email_verified = IF(user_activated = '1', '1', '0')") or _error("Error", $db->error);
    $db->query("UPDATE ads_users_wallet_transactions SET node_type = IF(node_type = 'withdraw', 'withdraw_affiliates', node_type)") or _error("Error", $db->error);

    // [5] update system settings
    $db->query(sprintf("UPDATE system_options SET session_hash = %s", secure($session_hash) )) or _error("Error", $db->error);

    // [6] create config file
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

    // [7] Done
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