<?php
/**
 * update wizard
 * 
 * @package Sngine
 * @author Zamblek
 */

// set system version
define('SYS_VER', '2.8');


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


	// update the sngine tables
	$structure = "

ALTER TABLE `conversations_messages`
  ADD COLUMN `voice_note` varchar(256) NULL;

ALTER TABLE `posts`
  ADD COLUMN `is_anonymous` enum('0','1') NOT NULL DEFAULT '0'
  , ADD COLUMN `points_earned` enum('0','1') NOT NULL DEFAULT '0';

ALTER TABLE `posts_comments`
  ADD COLUMN `voice_note` varchar(256) NULL
  , ADD COLUMN `points_earned` enum('0','1') NOT NULL DEFAULT '0';

ALTER TABLE `posts_comments_reactions`
  ADD COLUMN `points_earned` enum('0','1') NOT NULL DEFAULT '0';

ALTER TABLE `posts_photos_reactions`
  ADD COLUMN `points_earned` enum('0','1') NULL DEFAULT '0';

ALTER TABLE `posts_reactions`
  ADD COLUMN `points_earned` enum('0','1') NOT NULL DEFAULT '0';

ALTER TABLE `users`
  ADD COLUMN `onesignal_user_id` varchar(100) NULL
  , ADD COLUMN `user_language` varchar(16) NULL DEFAULT 'en_us';


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
		('mobile_infinite_scroll', '0'),
		('limit_cover_photo', '1'),
		('comments_photos_enabled', '1'),
		('chat_photos_enabled', '1'),
		('onesignal_notification_enabled', '0'),
		('onesignal_app_id', ''),
		('onesignal_api_key', ''),
		('system_distance', 'kilometer'),
		('wallet_enabled', '0'),
		('wallet_transfer_enabled', '0'),
		('affiliates_money_withdraw_enabled', '1'),
		('affiliates_money_transfer_enabled', '0'),
		('pages_permission', 'everyone'),
		('groups_permission', 'everyone'),
		('events_permission', 'everyone'),
		('blogs_permission', 'everyone'),
		('market_permission', 'everyone'),
		('forums_permission', 'everyone'),
		('movies_permission', 'everyone'),
		('games_permission', 'everyone'),
		('jobs_enabled', '0'),
		('posts_online_status', '1'),
		('anonymous_mode', '0'),
		('tinymce_photos_enabled', '1'),
		('voice_notes_posts_enabled', '1'),
		('voice_notes_comments_enabled', '1'),
		('voice_notes_chat_enabled', '1')") or _error("SQL_ERROR");


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
	_error("System Updated", "Sngine has been updated to ".SYS_VER);
}

?>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge"> 
		<meta name="viewport" content="width=device-width, initial-scale=1"> 
		<title>Sngine (<?php echo SYS_VER ?>) &rsaquo; Update</title>
		<link rel="stylesheet" type="text/css" href="includes/assets/js/sngine/installer/installer.css" />
		<script src="includes/assets/js/sngine/installer/modernizr.custom.js"></script>
	</head>

	<body>
		<div class="container">
			<div class="fs-form-wrap" id="fs-form-wrap">
				<div class="fs-title">
					<h1>Sngine (<?php echo SYS_VER ?>) Update</h1>
				</div>
				<form id="myform" class="fs-form fs-form-full" autocomplete="off" action="update.php" method="post">
					<ol class="fs-fields">
						<li>
							<p class="fs-field-label fs-anim-upper">
								Welcome to <strong>Sngine</strong> updating process! Just fill in the information below.
							</p>
						</li>
						<li>
							<label class="fs-field-label fs-anim-upper" for="purchase_code" data-info="The purchase code of Sngine">Purchase Code</label>
							<input class="fs-anim-lower" id="purchase_code" name="purchase_code" type="text" placeholder="xxx-xx-xxxx" required/>
						</li>
					</ol>
					<button class="fs-submit" name="submit" type="submit">Update</button>
				</form>
			</div>
		</div>

		<script src="includes/assets/js/sngine/installer/classie.js"></script>
		<script src="includes/assets/js/sngine/installer/fullscreenForm.js"></script>
		<script>
			(function() {
				var formWrap = document.getElementById( 'fs-form-wrap' );
				new FForm( formWrap, {
					onReview : function() {
						classie.add( document.body, 'overview' );
					}
				});
			})();
		</script>
	</body>
</html>