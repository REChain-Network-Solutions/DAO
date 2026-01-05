<?php
/**
 * update wizard
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich
 */

// set execution time
set_time_limit(0); /* unlimited max execution time */


// set system version
define('SYS_VER', '3.0');


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

CREATE TABLE `system_genders` (
  `gender_id` int(10) unsigned NOT NULL auto_increment,
  `gender_name` varchar(64) NOT NULL,
  `gender_order` int(10) NOT NULL DEFAULT '1',
  UNIQUE KEY `name`(`gender_name`),
  PRIMARY KEY (`gender_id`)
) ENGINE=InnoDB row_format=DYNAMIC;

INSERT INTO `system_genders` (`gender_id`, `gender_name`, `gender_order`) VALUES
(1, 'Male', 1),
(2, 'Female', 2),
(3, 'Other', 3);

CREATE TABLE `wallet_payments` (
  `payment_id` int(10) NOT NULL auto_increment,
  `user_id` int(10) unsigned NOT NULL,
  `amount` varchar(32) NOT NULL,
  `method` varchar(64) NOT NULL,
  `method_value` text NOT NULL,
  `time` datetime NOT NULL,
  `status` tinyint(1) NOT NULL,
  PRIMARY KEY (`payment_id`)
) ENGINE=InnoDB row_format=DYNAMIC;

ALTER TABLE `blogs_categories`
  ADD COLUMN `category_description` text NULL;

ALTER TABLE `custom_fields`
  ADD COLUMN `is_link` enum('0','1') NOT NULL DEFAULT '0';

ALTER TABLE `events_categories`
  ADD COLUMN `category_description` text NULL;

ALTER TABLE `groups_categories`
  ADD COLUMN `category_description` text NULL;

ALTER TABLE `jobs_categories`
  ADD COLUMN `category_description` text NULL;

ALTER TABLE `market_categories`
  ADD COLUMN `category_description` text NULL;

ALTER TABLE `notifications`
  ADD COLUMN `from_user_type` enum('user','page') NOT NULL DEFAULT 'user';

ALTER TABLE `offers_categories`
  ADD COLUMN `category_description` text NULL;

ALTER TABLE `pages_categories`
  ADD COLUMN `category_description` text NULL;

ALTER TABLE `posts_products`
  MODIFY COLUMN `price` float NOT NULL DEFAULT 0;

ALTER TABLE `system_themes`
  ADD COLUMN `enabled` enum('0','1') NULL;

ALTER TABLE `users`
  ADD COLUMN `user_gender_id` int(10) UNSIGNED DEFAULT NULL
  , ADD COLUMN `user_privacy_gender` enum('me','friends','public') NOT NULL DEFAULT 'public';

	";
	$db->multi_query($structure) or _error("Error", $db->error);


	// flush multi_queries
	do{} while(mysqli_more_results($db) && mysqli_next_result($db));


	// update tables collections
	$get_db_tbls = $db->query("show tables") or _error("Error", $db->error);
	while($db_tbl = $get_db_tbls->fetch_array()) {
		foreach($db_tbl as $key => $value) {
			$db->query("ALTER TABLE $value CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci");
            $db->query("ALTER TABLE $value ROW_FORMAT=DYNAMIC ENGINE=INNODB");
		}
	}


    // update users genders
    $get_users = $db->query("SELECT user_id, user_gender FROM users") or _error("Error", $db->error);
    while($_user = $get_users->fetch_assoc()) {
        switch ($_user['user_gender']) {
            case 'male':
                $gender_id = 1;
                break;
            
            case 'female':
                $gender_id = 2;
                break;

            case 'other':
                $gender_id = 3;
                break;
        }
        $db->query(sprintf("UPDATE users SET user_gender_id = %s WHERE user_id = %s", secure($gender_id, 'int'), secure($_user['user_id'], 'int') )) or _error("Error", $db->error);
    }
    /* DROP user_gender */
    $db->query("ALTER TABLE `users` DROP COLUMN `user_gender` ") or _error("Error", $db->error);
    /* MODIFY user_gender_id -> user_gender */
    $db->query("ALTER TABLE `users` CHANGE user_gender_id user_gender int(10)") or _error("Error", $db->error);


    // update ads campagins
    $db->query("UPDATE ads_campaigns SET audience_gender = 'all'") or _error("Error", $db->error);


    // delete removed system options values
    $db->query("DELETE FROM system_options WHERE option_name = 'instagram_login_enabled' OR option_name = 'instagram_appid' OR option_name = 'instagram_secret'") or _error("Error", $db->error);


	// insert new system_options values
	$db->query("INSERT INTO system_options (option_name, option_value) VALUES
		('chat_permanently_delete_enabled', '1'),
        ('system_description_directory', ''),
        ('system_description_offers', ''),
        ('system_description_jobs', ''),
        ('system_description_blogs', ''),
        ('system_description_marketplace', ''),
        ('system_description_forums', ''),
        ('system_description_movies', ''),
        ('stories_duration', '3'),
        ('desktop_infinite_scroll', '1'),
        ('disable_declined_friendrequest', '0'),
        ('wallet_withdrawal_enabled', '0'),
        ('wallet_payment_method', 'paypal,skrill'),
        ('wallet_payment_method_custom', ''),
        ('wallet_min_withdrawal', '50'),
        ('location_finder_enabled', '0'),
        ('relationship_info_enabled', '1'),
        ('website_info_enabled', '1'),
        ('biography_info_enabled', '1'),
        ('work_info_enabled', '1'),
        ('education_info_enabled', '1'),
        ('social_info_enabled', '1'),
        ('location_info_enabled', '1'),
		('show_usernames_enabled', '0')") or _error("Error", $db->error);


	// update system settings
	update_system_options([ 
		'session_hash' => secure($session_hash)
	], false);

	// create config file
	$config_string = '<?php  
	define("DB_NAME", \''.DB_NAME.'\');
	define("DB_USER", \''.DB_USER.'\');
	define("DB_PASSWORD", \''.DB_PASSWORD.'\');
	define("DB_HOST", \''.DB_HOST.'\');
	define("DB_PORT", \''.DB_PORT.'\');
	define("SYS_URL", \''.SYS_URL.'\');
	define("DEBUGGING", false);
	define("DEFAULT_LOCALE", \'en_us\');
	define("LICENCE_KEY", \''.$licence_key.'\');
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
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="ie=edge">
        <title>Delus &rsaquo; Update (v<?php echo SYS_VER ?>)</title>
        <link rel="shortcut icon" href="includes/assets/js/core/installer/favicon.png" />
        <link href="https://fonts.googleapis.com/css?family=Karla:400,700&display=swap" rel="stylesheet" crossorigin="anonymous">
        <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.14.0/css/all.css" crossorigin="anonymous">
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" integrity="sha384-JcKb8q3iqJ61gNV9KGb8thSsNjpSL0n8PARn9HuZOnIxN0hoP+VmmDGMN5t9UJ0Z" crossorigin="anonymous">
        <link rel="stylesheet" href="includes/assets/js/core/installer/wizard.css">
    </head>
    <body>
        <main class="my-5">
            <div class="container">
                <form id="wizard" method="post" class="position-relative">
                    <!-- Step 1 -->
                    <h3>
                        <div class="media">
                            <div class="bd-wizard-step-icon"><i class="fas fa-cubes"></i></div>
                            <div class="media-body">
                                <div class="bd-wizard-step-title">Update</div>
                                <div class="bd-wizard-step-subtitle">Delus (v<?php echo SYS_VER ?>)</div>
                            </div>
                        </div>
                    </h3>
                    <section>
                        <div class="content-wrapper">
                            <h3 class="section-heading">Welcome!</h3>
                            <p>
                                Welcome to <strong>Delus</strong> updating process! Just fill in the information below.
                            </p>
                            <div class="row mt-4">
                                <div class="form-group col-12">
                                    <label for="purchase_code">Your Purchase Code</label>
                                    <input type="text" name="purchase_code" id="purchase_code" class="form-control"
                                        placeholder="xxx-xx-xxxx">
                                    <div class="invalid-feedback">
                                        This field can't be empty
                                    </div>
                                </div>
                            </div>
                        </div>
                    </section>
                    <!-- Step 1 -->
                    <!-- Submit -->
                    <div style="display: none;">
                        <button class="btn btn-primary" name="submit" type="submit" id="wizard-submittion">Submit</button>
                    </div>
                    <!-- Submit -->
                    <!-- Loader -->
                    <div id="loader" style="display: none;">
                        <div class="wizard-loader">
                            Updating<span class="spinner-grow spinner-grow-sm ml-3"></span>
                        </div>
                    </div>
                    <!-- Loader -->
                </form>
            </div>
        </main>
        <script src="https://code.jquery.com/jquery-3.5.1.min.js" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js" integrity="sha384-9/reFTGAW83EW2RDu2S0VKaIzap3H66lZH81PoYlFhbGU+6BZp6G7niu735Sk7lN" crossorigin="anonymous"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js" integrity="sha384-B4gt1jrGC7Jh4AgTPSdUtOBvfO8shuf57BaghqFfPlYxofvL8/KUEfYiJOMMV+rV" crossorigin="anonymous"></script>
        <script src="includes/assets/js/core/installer/jquery.steps.min.js"></script>
        <script type="text/javascript">
            // handle wizard
            var wizard = $("#wizard");
            wizard.steps({
                headerTag: "h3",
                bodyTag: "section",
                transitionEffect: "none",
                titleTemplate: '#title#',
                onFinished: function (event, currentIndex) {
                	/* check details */
                	if($('input[type="text"]').val() == "") {
                		$('input[type="text"]').addClass("is-invalid");
                		return false;
                	}
                    $("#loader").slideDown();
                    $("#wizard-submittion").click();
                    return true;
                },
			    labels: {
			        finish: "Update",
			    }
            });
            
            // handle inputs
            $('input[type="text"]').on('change', function () {
                if ($(this).val() == "") {
                    $(this).addClass("is-invalid");
                } else {
                    $(this).removeClass("is-invalid");
                }
            });
        </script>
    </body>
</html>