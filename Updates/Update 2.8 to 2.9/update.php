<?php
/**
 * update wizard
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich
 */

// set system version
define('SYS_VER', '2.9');


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

CREATE TABLE `jobs_categories` (
  `category_id` int(10) unsigned NOT NULL auto_increment,
  `category_name` varchar(256) NOT NULL,
  `category_order` int(10) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`category_id`)
) ENGINE=MyISAM row_format=DYNAMIC;

INSERT INTO `jobs_categories` (`category_id`, `category_name`, `category_order`) VALUES
(1, 'Admin &amp; Office', 1),
(2, 'Art &amp; Design', 2),
(3, 'Business Operations', 3),
(4, 'Cleaning &amp; Facilities', 4),
(5, 'Community &amp; Social Services', 5),
(6, 'Computer &amp; Data', 6),
(7, 'Construction &amp; Mining', 7),
(8, 'Education', 8),
(9, 'Farming &amp; Forestry', 9),
(10, 'Healthcare', 10),
(11, 'Installation, Maintenance &amp; Repair', 11),
(12, 'Legal', 12),
(13, 'Management', 13),
(14, 'Manufacturing', 14),
(15, 'Media &amp; Communication', 15),
(16, 'Personal Care', 16),
(17, 'Protective Services', 17),
(18, 'Restaurant &amp; Hospitality', 18),
(19, 'Retail &amp; Sales', 19),
(20, 'Science &amp; Engineering', 20),
(21, 'Sports &amp; Entertainment', 21),
(22, 'Transportation', 22),
(23, 'Other', 23);

CREATE TABLE `offers_categories` (
  `category_id` int(10) unsigned NOT NULL auto_increment,
  `category_name` varchar(256) NOT NULL,
  `category_order` int(10) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`category_id`)
) ENGINE=MyISAM row_format=DYNAMIC;

INSERT INTO `offers_categories` (`category_id`, `category_name`, `category_order`) VALUES
(1, 'Apparel &amp; Accessories', 1),
(2, 'Autos &amp; Vehicles', 2),
(3, 'Baby &amp; Children&#039;s Products', 3),
(4, 'Beauty Products &amp; Services', 4),
(5, 'Computers &amp; Peripherals', 5),
(6, 'Consumer Electronics', 6),
(7, 'Dating Services', 7),
(8, 'Financial Services', 8),
(9, 'Gifts &amp; Occasions', 9),
(10, 'Home &amp; Garden', 10),
(11, 'Other', 11);

CREATE TABLE `posts_jobs` (
  `job_id` int(10) unsigned NOT NULL auto_increment,
  `post_id` int(10) unsigned NOT NULL,
  `category_id` int(10) unsigned NOT NULL,
  `title` varchar(100) NOT NULL,
  `location` varchar(100) NOT NULL,
  `salary_minimum` varchar(100) NOT NULL,
  `salary_maximum` varchar(100) NOT NULL,
  `pay_salary_per` varchar(100) NOT NULL,
  `type` varchar(100) NOT NULL,
  `question_1_type` varchar(100) NULL,
  `question_1_title` varchar(256) NULL,
  `question_1_choices` text NULL,
  `question_2_type` varchar(100) NULL,
  `question_2_title` varchar(256) NULL,
  `question_2_choices` text NULL,
  `question_3_type` varchar(100) NULL,
  `question_3_title` varchar(256) NULL,
  `question_3_choices` text NULL,
  `cover_image` varchar(256) NOT NULL,
  `available` enum('0','1') NOT NULL DEFAULT '1',
  PRIMARY KEY (`job_id`)
) ENGINE=MyISAM row_format=DYNAMIC;

CREATE TABLE `posts_jobs_applications` (
  `application_id` int(10) unsigned NOT NULL auto_increment,
  `post_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `name` varchar(100) NOT NULL,
  `location` varchar(100) NOT NULL,
  `phone` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `work_place` varchar(100) NULL,
  `work_position` varchar(100) NULL,
  `work_description` text NULL,
  `work_from` varchar(100) NULL,
  `work_to` varchar(100) NULL,
  `work_now` enum('0','1') NULL,
  `question_1_answer` text NULL,
  `question_2_answer` text NULL,
  `question_3_answer` text NULL,
  `applied_time` datetime NOT NULL,
  PRIMARY KEY (`application_id`)
) ENGINE=MyISAM row_format=DYNAMIC;

CREATE TABLE `posts_live` (
  `live_id` int(10) unsigned NOT NULL auto_increment,
  `post_id` int(10) unsigned NOT NULL,
  `video_thumbnail` varchar(256) NOT NULL,
  `agora_uid` int(10) NOT NULL,
  `agora_channel_name` varchar(256) NOT NULL,
  `agora_resource_id` text NULL,
  `agora_sid` varchar(256) NULL,
  `agora_file` text NULL,
  `live_ended` enum('0','1') NOT NULL DEFAULT '0',
  `live_recorded` enum('0','1') NOT NULL DEFAULT '0',
  PRIMARY KEY (`live_id`)
) ENGINE=MyISAM row_format=DYNAMIC;

CREATE TABLE `posts_live_users` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `user_id` int(10) unsigned NOT NULL,
  `post_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id_post_id`(`user_id`,`post_id`)
) ENGINE=MyISAM row_format=FIXED;

ALTER TABLE `posts_media`
  ADD COLUMN `source_thumbnail` text NULL;

CREATE TABLE `posts_offers` (
  `offer_id` int(10) unsigned NOT NULL auto_increment,
  `post_id` int(10) unsigned NOT NULL,
  `category_id` int(10) unsigned NOT NULL,
  `title` varchar(100) NOT NULL,
  `discount_type` varchar(32) NOT NULL,
  `discount_percent` int(10) unsigned NOT NULL,
  `discount_amount` varchar(100) NOT NULL,
  `buy_x` varchar(100) NOT NULL,
  `get_y` varchar(100) NOT NULL,
  `spend_x` varchar(100) NOT NULL,
  `amount_y` varchar(100) NOT NULL,
  `end_date` datetime NOT NULL,
  `thumbnail` varchar(256) NOT NULL,
  PRIMARY KEY (`offer_id`)
) ENGINE=MyISAM row_format=DYNAMIC;

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


	// insert new system_options values
	$db->query("INSERT INTO system_options (option_name, option_value) VALUES
		('offers_enabled', '0'),
        ('live_enabled', '0'),
        ('save_live_enabled', '0'),
        ('live_permission', 'everyone'),
        ('agora_app_id', ''),
        ('agora_app_certificate', ''),
        ('agora_customer_id', ''),
        ('agora_customer_certificate', ''),
        ('agora_s3_bucket', ''),
        ('agora_s3_region', ''),
        ('agora_s3_key', ''),
		('agora_s3_secret', '')") or _error("Error", $db->error);


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
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="ie=edge">
        <title>Delus &rsaquo; Update (v<?php echo SYS_VER ?>)</title>
        <link rel="shortcut icon" href="includes/assets/js/Delus/installer/favicon.png" />
        <link href="https://fonts.googleapis.com/css?family=Karla:400,700&display=swap" rel="stylesheet" crossorigin="anonymous">
        <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.14.0/css/all.css" crossorigin="anonymous">
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" integrity="sha384-JcKb8q3iqJ61gNV9KGb8thSsNjpSL0n8PARn9HuZOnIxN0hoP+VmmDGMN5t9UJ0Z" crossorigin="anonymous">
        <link rel="stylesheet" href="includes/assets/js/Delus/installer/wizard.css">
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
        <script src="includes/assets/js/Delus/installer/jquery.steps.min.js"></script>
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