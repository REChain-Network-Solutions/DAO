<?php
/**
 * Delus updater
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich - Handles - @sorydima @sorydev @durovshater @DmitrySoro90935 @tanechfund - also check https://dmitry.rechain.network for more information!
 */

// set system version
define('SYS_VER', '2.5.10');


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

CREATE TABLE `hashtags` (
  `hashtag_id` int(10) unsigned NOT NULL auto_increment,
  `hashtag` varchar(255) NOT NULL,
  PRIMARY KEY (`hashtag_id`)
) ENGINE=MyISAM;

CREATE TABLE `hashtags_posts` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `post_id` int(10) unsigned NOT NULL,
  `hashtag_id` int(10) unsigned NOT NULL,
  `created_at` datetime NULL,
  UNIQUE KEY `post_id_hashtag_id`(`post_id`,`hashtag_id`),
  PRIMARY KEY (`id`)
) ENGINE=MyISAM row_format=FIXED;

ALTER TABLE `posts`
  CHANGE `likes` `reaction_like_count` int(10) unsigned NOT NULL DEFAULT '0'
  , ADD COLUMN `reaction_love_count` int(10) unsigned NOT NULL DEFAULT '0'
  , ADD COLUMN `reaction_haha_count` int(10) unsigned NOT NULL DEFAULT '0'
  , ADD COLUMN `reaction_yay_count` int(10) unsigned NOT NULL DEFAULT '0'
  , ADD COLUMN `reaction_wow_count` int(10) unsigned NOT NULL DEFAULT '0'
  , ADD COLUMN `reaction_sad_count` int(10) unsigned NOT NULL DEFAULT '0'
  , ADD COLUMN `reaction_angry_count` int(10) unsigned NOT NULL DEFAULT '0';

ALTER TABLE `posts_likes`
  ADD COLUMN `reaction` varchar(32) NOT NULL DEFAULT 'like';

RENAME TABLE  `posts_likes` TO  `posts_reactions`;

ALTER TABLE `posts_comments`
  CHANGE `likes` `reaction_like_count` int(10) unsigned NOT NULL DEFAULT '0'
  , ADD COLUMN `reaction_love_count` int(10) unsigned NOT NULL DEFAULT '0'
  , ADD COLUMN `reaction_haha_count` int(10) unsigned NOT NULL DEFAULT '0'
  , ADD COLUMN `reaction_yay_count` int(10) unsigned NOT NULL DEFAULT '0'
  , ADD COLUMN `reaction_wow_count` int(10) unsigned NOT NULL DEFAULT '0'
  , ADD COLUMN `reaction_sad_count` int(10) unsigned NOT NULL DEFAULT '0'
  , ADD COLUMN `reaction_angry_count` int(10) unsigned NOT NULL DEFAULT '0';

ALTER TABLE `posts_comments_likes`
  ADD COLUMN `reaction` varchar(32) NULL DEFAULT 'like';

RENAME TABLE  `posts_comments_likes` TO  `posts_comments_reactions`;

ALTER TABLE `posts_photos`
  CHANGE `likes` `reaction_like_count` int(10) unsigned NOT NULL DEFAULT '0'
  , ADD COLUMN `reaction_love_count` int(10) unsigned NOT NULL DEFAULT '0'
  , ADD COLUMN `reaction_haha_count` int(10) unsigned NOT NULL DEFAULT '0'
  , ADD COLUMN `reaction_yay_count` int(10) unsigned NOT NULL DEFAULT '0'
  , ADD COLUMN `reaction_wow_count` int(10) unsigned NOT NULL DEFAULT '0'
  , ADD COLUMN `reaction_sad_count` int(10) unsigned NOT NULL DEFAULT '0'
  , ADD COLUMN `reaction_angry_count` int(10) unsigned NOT NULL DEFAULT '0';

ALTER TABLE `posts_photos_likes`
  ADD COLUMN `reaction` varchar(32) NOT NULL DEFAULT 'like';

RENAME TABLE  `posts_photos_likes` TO  `posts_photos_reactions`;

ALTER TABLE `posts_audios`
  ADD COLUMN `views` int(10) NOT NULL DEFAULT '0';

ALTER TABLE `posts_videos`
  ADD COLUMN `thumbnail` varchar(255) NULL
  , ADD COLUMN `views` int(10) NOT NULL DEFAULT '0';

ALTER TABLE `system_options`
  DROP COLUMN `system_wallpaper_default`
  , DROP COLUMN `system_wallpaper`
  , DROP COLUMN `system_random_profiles`
  , ADD COLUMN `system_datetime_format` varchar(255) NOT NULL DEFAULT 'd/m/Y H:i'
  , ADD COLUMN `trending_hashtags_enabled` enum('0','1') NOT NULL DEFAULT '1'
  , ADD COLUMN `trending_hashtags_interval` enum('day','week','month') NOT NULL DEFAULT 'week'
  , ADD COLUMN `trending_hashtags_limit` smallint(1) unsigned NOT NULL DEFAULT 5
  , ADD COLUMN `download_info_enabled` enum('0','1') NOT NULL DEFAULT '1'
  , ADD COLUMN `affiliate_payment_type` enum('fixed','percentage') NOT NULL DEFAULT 'fixed'
  , ADD COLUMN `affiliates_percentage` varchar(32) NOT NULL DEFAULT '1'
  , ADD COLUMN `auto_friend` enum('0','1') NOT NULL DEFAULT '0'
  , ADD COLUMN `auto_friend_users` mediumtext NULL
  , ADD COLUMN `auto_follow` enum('0','1') NOT NULL DEFAULT '0'
  , ADD COLUMN `auto_follow_users` mediumtext NULL
  , ADD COLUMN `auto_like` enum('0','1') NOT NULL DEFAULT '0'
  , ADD COLUMN `auto_like_pages` mediumtext NULL
  , ADD COLUMN `auto_join` enum('0','1') NOT NULL DEFAULT '0'
  , ADD COLUMN `auto_join_groups` mediumtext NULL
  , ADD COLUMN `last_backup_time` datetime NULL;

INSERT INTO `system_languages` (`code`, `title`, `flag`, `dir`, `default`, `enabled`) VALUES
('pt_br', 'Portuguese (Brazil)', 'flags/pt_br.png', 'LTR', '0', '1'),
('el_gr', 'Greek', 'flags/el_gr.png', 'LTR', '0', '1');

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