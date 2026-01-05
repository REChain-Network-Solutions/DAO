<?php
/**
 * Delus updater
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich
 */

// set system version
define('SYS_VER', '2.5.4');


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

ALTER TABLE `ads_campaigns`
  MODIFY COLUMN `audience_countries` mediumtext NOT NULL
  , MODIFY COLUMN `ads_description` mediumtext NULL;

ALTER TABLE `ads_system`
  MODIFY COLUMN `code` mediumtext NOT NULL;

ALTER TABLE `announcements`
  MODIFY COLUMN `code` mediumtext NOT NULL;

CREATE TABLE `blogs_categories` (
  `category_id` int(10) unsigned NOT NULL auto_increment,
  `category_name` varchar(255) NOT NULL,
  PRIMARY KEY (`category_id`)
) ENGINE=MyISAM row_format=DYNAMIC;

INSERT INTO `blogs_categories` (`category_id`, `category_name`) VALUES
(1, 'Art'),
(2, 'Causes'),
(3, 'Crafts'),
(4, 'Dance'),
(5, 'Drinks'),
(6, 'Film'),
(7, 'Fitness'),
(8, 'Food'),
(9, 'Games'),
(10, 'Gardening'),
(11, 'Health'),
(12, 'Home'),
(13, 'Literature'),
(14, 'Music'),
(15, 'Networking'),
(16, 'Other'),
(17, 'Party'),
(18, 'Religion'),
(19, 'Shopping'),
(20, 'Sports'),
(21, 'Theater'),
(22, 'Wellness');

ALTER TABLE `conversations`
  ADD COLUMN `color` varchar(32) NULL;

ALTER TABLE `custom_fields`
  MODIFY COLUMN `select_options` mediumtext NOT NULL
  , MODIFY COLUMN `description` mediumtext NOT NULL;

ALTER TABLE `custom_fields_values`
  MODIFY COLUMN `value` mediumtext NOT NULL;

ALTER TABLE `events`
  MODIFY COLUMN `event_description` mediumtext NOT NULL
  , ADD COLUMN `event_cover_position` varchar(255) NULL;

ALTER TABLE `forums`
  MODIFY COLUMN `forum_description` mediumtext NULL;

ALTER TABLE `games`
  MODIFY COLUMN `description` mediumtext NOT NULL
  , MODIFY COLUMN `source` mediumtext NOT NULL;

ALTER TABLE `groups`
  MODIFY COLUMN `group_description` mediumtext NOT NULL
  , ADD COLUMN `group_cover_position` varchar(255) NULL;

ALTER TABLE `notifications`
  MODIFY COLUMN `message` mediumtext NULL;

ALTER TABLE `pages`
  MODIFY COLUMN `page_description` mediumtext NOT NULL
  , ADD COLUMN `page_cover_position` varchar(255) NULL;

ALTER TABLE `posts_articles`
  MODIFY COLUMN `tags` mediumtext NOT NULL
  , ADD COLUMN `category_id` int(10) unsigned NOT NULL;

ALTER TABLE `posts_links`
  MODIFY COLUMN `source_url` text NOT NULL
  , MODIFY COLUMN `source_text` mediumtext NOT NULL;

ALTER TABLE `posts_media`
  MODIFY COLUMN `source_url` mediumtext NOT NULL
  , MODIFY COLUMN `source_text` mediumtext NULL
  , MODIFY COLUMN `source_html` mediumtext NULL;

ALTER TABLE `static_pages`
  MODIFY COLUMN `page_text` mediumtext NOT NULL;

DROP TABLE `system_languages`;

CREATE TABLE `system_languages` (
  `language_id` int(10) UNSIGNED NOT NULL,
  `code` varchar(32) COLLATE utf8mb4_bin NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `flag` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `dir` enum('LTR','RTL') COLLATE utf8mb4_bin NOT NULL,
  `default` enum('0','1') COLLATE utf8mb4_bin NOT NULL,
  `enabled` enum('0','1') COLLATE utf8mb4_bin NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

INSERT INTO `system_languages` (`language_id`, `code`, `title`, `flag`, `dir`, `default`, `enabled`) VALUES
(1, 'en_us', 'English', 'flags/en_us.png', 'LTR', '1', '1'),
(2, 'ar_sa', 'Arabic', 'flags/ar_sa.png', 'RTL', '0', '1'),
(3, 'fr_fr', 'Fran&ccedil;ais', 'flags/fr_fr.png', 'LTR', '0', '1'),
(4, 'es_es', 'Espa&ntilde;ol', 'flags/es_es.png', 'LTR', '0', '1'),
(5, 'pt_pt', 'Portugu&ecirc;s', 'flags/pt_pt.png', 'LTR', '0', '1'),
(6, 'de_de', 'Deutsch', 'flags/de_de.png', 'LTR', '0', '1'),
(7, 'tr_tr', 'T&uuml;rk&ccedil;e', 'flags/tr_tr.png', 'LTR', '0', '1'),
(8, 'nl_nl', 'Dutch', 'flags/nl_nl.png', 'LTR', '0', '1'),
(9, 'it_it', 'Italiano', 'flags/it_it.png', 'LTR', '0', '1'),
(10, 'ru_ru', 'Russian', 'flags/ru_ru.png', 'LTR', '0', '1'),
(11, 'ro_ro', 'Romaian', 'flags/ro_ro.png', 'LTR', '0', '1');

ALTER TABLE `system_options`
  MODIFY COLUMN `system_message` mediumtext NOT NULL
  , MODIFY COLUMN `system_description` mediumtext NOT NULL
  , MODIFY COLUMN `system_keywords` mediumtext NOT NULL
  , MODIFY COLUMN `video_extensions` mediumtext NOT NULL
  , MODIFY COLUMN `audio_extensions` mediumtext NOT NULL
  , MODIFY COLUMN `file_extensions` mediumtext NOT NULL
  , MODIFY COLUMN `censored_words` mediumtext NOT NULL
  , MODIFY COLUMN `analytics_code` mediumtext NOT NULL
  , MODIFY COLUMN `css_custome_css` mediumtext NOT NULL
  , MODIFY COLUMN `custome_js_header` mediumtext NOT NULL
  , MODIFY COLUMN `custome_js_footer` mediumtext NOT NULL
  , ADD COLUMN `users_blogs_enabled` enum('0','1') NOT NULL DEFAULT '1'
  , ADD COLUMN `cookie_consent_enabled` enum('0','1') NOT NULL DEFAULT '1';

ALTER TABLE `users`
  DROP COLUMN `user_last_login`
  , ADD COLUMN `user_cover_position` varchar(255) NULL
  , ADD COLUMN `user_last_seen` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
  , ADD COLUMN `user_privacy_newsletter` enum('0','1') NOT NULL DEFAULT '0';

ALTER TABLE `widgets`
  MODIFY COLUMN `code` mediumtext NOT NULL;

DROP TABLE `users_online`;

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

    // [4] update system settings
    $db->query(sprintf("UPDATE system_options SET session_hash = %s", secure($session_hash) )) or _error("Error", $db->error);

    // [5] create config file
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

    // [6] Done
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