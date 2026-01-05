<?php
/**
 * Delus updater
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich
 */

// set system version
define('SYS_VER', '2.5.2');


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

    // [0] check valid purchase code
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

CREATE TABLE `forums` (
  `forum_id` int(10) unsigned NOT NULL auto_increment,
  `forum_section` int(10) unsigned NOT NULL,
  `forum_name` varchar(255) NOT NULL,
  `forum_description` text NULL,
  `forum_order` int(10) unsigned NOT NULL DEFAULT '1',
  `forum_threads` int(10) unsigned NOT NULL DEFAULT '0',
  `forum_replies` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`forum_id`)
) ENGINE=MyISAM row_format=DYNAMIC;

CREATE TABLE `forums_replies` (
  `reply_id` int(10) unsigned NOT NULL auto_increment,
  `thread_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `text` longtext NOT NULL,
  `time` datetime NOT NULL,
  PRIMARY KEY (`reply_id`)
) ENGINE=MyISAM row_format=DYNAMIC;

CREATE TABLE `forums_threads` (
  `thread_id` int(10) unsigned NOT NULL auto_increment,
  `forum_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `title` varchar(255) NOT NULL,
  `text` longtext NOT NULL,
  `replies` int(10) unsigned NOT NULL DEFAULT '0',
  `views` int(10) unsigned NOT NULL DEFAULT '0',
  `time` datetime NOT NULL,
  `last_reply` datetime NULL,
  PRIMARY KEY (`thread_id`)
) ENGINE=MyISAM row_format=DYNAMIC;

CREATE TABLE `invitation_codes` (
  `code_id` int(10) unsigned NOT NULL auto_increment,
  `code` varchar(64) NOT NULL,
  `valid` enum('0','1') NOT NULL DEFAULT '1',
  `date` datetime NOT NULL,
  PRIMARY KEY (`code_id`)
) ENGINE=MyISAM row_format=DYNAMIC;

ALTER TABLE `notifications`
  ADD COLUMN `message` text NULL;

ALTER TABLE `system_options`
  ADD COLUMN `browser_notifications_enabled` enum('0','1') NOT NULL DEFAULT '1'
  , ADD COLUMN `noty_notifications_enabled` enum('0','1') NOT NULL DEFAULT '1'
  , ADD COLUMN `polls_enabled` enum('0','1') NOT NULL DEFAULT '1'
  , ADD COLUMN `invitation_enabled` enum('0','1') NOT NULL DEFAULT '0'
  , ADD COLUMN `uploads_quality` enum('high','medium','low') NOT NULL DEFAULT 'medium'
  , ADD COLUMN `forums_enabled` enum('0','1') NOT NULL DEFAULT '1'
  , ADD COLUMN `forums_online_enabled` enum('0','1') NOT NULL DEFAULT '1'
  , ADD COLUMN `forums_statistics_enabled` enum('0','1') NOT NULL DEFAULT '1';

ALTER TABLE `users`
  MODIFY COLUMN `user_gender` enum('male','female','other') NOT NULL;
";
    

    $db->multi_query($structure) or _error("Error", $db->error);
    // flush multi_queries
    do{} while(mysqli_more_results($db) && mysqli_next_result($db));


    // [5] update system settings
    $db->query(sprintf("UPDATE system_options SET session_hash = %s", secure($session_hash) )) or _error("Error #103", $db->error);


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

    // [6] Done
    _error("System Updated", "Delus has been updated to 2.5.2");
}

?>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge"> 
        <meta name="viewport" content="width=device-width, initial-scale=1"> 
        
        <title>Delus v2.5.2 &rsaquo; Update</title>
        
        <link rel="stylesheet" type="text/css" href="includes/assets/js/Delus/installer/installer.css" />
        <script src="includes/assets/js/Delus/installer/modernizr.custom.js"></script>
    </head>

    <body>
        
        <div class="container">

            <div class="fs-form-wrap" id="fs-form-wrap">
                
                <div class="fs-title">
                    <h1>Delus v2.5.2 Update</h1>
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