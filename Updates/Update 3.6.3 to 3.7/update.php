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
define('SYS_VER', '3.7');


// set system name
define('SYS_NAME', 'Delus');


// set ABSPATH & BASEPATH
define('ABSPATH', __DIR__ . '/');
define('BASEPATH', dirname($_SERVER['PHP_SELF']));


// check config file
if (!file_exists(ABSPATH . 'includes/config.php')) {
  /* the config file doesn't exist -> start the installer */
  header('Location: ./install');
}


// get config file
require(ABSPATH . 'includes/config.php');


// set debugging settings
if (DEBUGGING) {
  ini_set("display_errors", true);
  error_reporting(E_ALL ^ E_NOTICE);
} else {
  ini_set("display_errors", false);
  error_reporting(0);
}


// get functions
require_once(ABSPATH . 'includes/functions.php');


// update
if (isset($_POST['submit'])) {

  // check purchase code
  try {
    $licence_key = get_licence_key($_POST['purchase_code']);
    if (is_empty($_POST['purchase_code']) || $licence_key === false) {
      _error("Error", "Please enter a valid purchase code");
    }
    $session_hash = $licence_key;
  } catch (Exception $e) {
    _error("Error", $e->getMessage());
  }


  // connect to the database
  $db = new mysqli(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME, DB_PORT);
  $db->set_charset('utf8mb4');
  if (mysqli_connect_error()) {
    _error("DB_ERROR");
  }


  // update database tables
  $structure = "

    CREATE TABLE `subscribers` (
      `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
      `user_id` int(10) unsigned NOT NULL,
      `node_id` int(10) unsigned NOT NULL,
      `node_type` varchar(32) NOT NULL,
      `time` datetime NOT NULL,
      PRIMARY KEY (`id`),
      UNIQUE KEY `user_id_following_id` (`user_id`,`node_id`)
    ) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

    CREATE TABLE `monetization_payments` (
      `payment_id` int(10) NOT NULL AUTO_INCREMENT,
      `user_id` int(10) unsigned NOT NULL,
      `amount` varchar(32) NOT NULL,
      `method` varchar(64) NOT NULL,
      `method_value` text NOT NULL,
      `time` datetime NOT NULL,
      `status` tinyint(1) NOT NULL,
      PRIMARY KEY (`payment_id`) USING BTREE,
      KEY `user_id` (`user_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

    CREATE TABLE `system_reactions` (
      `reaction_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
      `reaction` varchar(32) NOT NULL,
      `title` varchar(32) NOT NULL,
      `color` varchar(128) DEFAULT NULL,
      `image` varchar(256) NOT NULL,
      PRIMARY KEY (`reaction_id`)
    ) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

    INSERT INTO `system_reactions` (`reaction_id`, `reaction`, `title`, `color`, `image`) VALUES
    (1, 'like', 'Like', '#1E8BD2', 'reactions/like.png'),
    (2, 'love', 'Love', '#F25268', 'reactions/love.png'),
    (3, 'haha', 'Haha', '#F3B715', 'reactions/haha.png'),
    (4, 'yay', 'Yay', '#F3B715', 'reactions/yay.png'),
    (5, 'wow', 'Wow', '#F3B715', 'reactions/wow.png'),
    (6, 'sad', 'Sad', '#F3B715', 'reactions/sad.png'),
    (7, 'angry', 'Angry', '#F7806C', 'reactions/angry.png');

    # Changing table bank_transfers fields
    ALTER TABLE `bank_transfers`
      ADD COLUMN `node_id` INT(10) UNSIGNED NULL DEFAULT NULL  COMMENT '' AFTER `post_id`,
      ADD COLUMN `node_type` VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL  COMMENT '' AFTER `node_id`,
      MODIFY COLUMN `price` FLOAT NULL DEFAULT NULL  COMMENT '' AFTER `node_type`;

    # Changing table groups fields
    ALTER TABLE `groups`
      ADD COLUMN `group_monetization_enabled` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `group_members`,
      ADD COLUMN `group_monetization_price` FLOAT NOT NULL DEFAULT 0  COMMENT '' AFTER `group_monetization_enabled`,
      MODIFY COLUMN `group_date` DATETIME NOT NULL  COMMENT '' AFTER `group_monetization_price`;

    # Changing table users fields
    ALTER TABLE `users`
      ADD COLUMN `user_privacy_followers` ENUM('me','friends','public') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'public'  COMMENT '' AFTER `user_privacy_friends`,
      MODIFY COLUMN `user_privacy_photos` ENUM('me','friends','public') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'public'  COMMENT '' AFTER `user_privacy_followers`,
      MODIFY COLUMN `user_points` FLOAT NOT NULL DEFAULT 0  COMMENT '' AFTER `points_earned`,
      MODIFY COLUMN `user_wallet_balance` FLOAT NOT NULL DEFAULT 0  COMMENT '' AFTER `user_points`,
      MODIFY COLUMN `user_affiliate_balance` FLOAT NOT NULL DEFAULT 0  COMMENT '' AFTER `user_wallet_balance`,
      ADD COLUMN `user_monetization_enabled` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `user_funding_balance`,
      ADD COLUMN `user_monetization_price` FLOAT NOT NULL DEFAULT 0  COMMENT '' AFTER `user_monetization_enabled`,
      ADD COLUMN `user_monetization_balance` FLOAT NOT NULL DEFAULT 0  COMMENT '' AFTER `user_monetization_price`,
      MODIFY COLUMN `chat_sound` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1'  COMMENT '' AFTER `user_monetization_balance`;

    # Changing table pages fields
    ALTER TABLE `pages`
      ADD COLUMN `page_monetization_enabled` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `page_likes`,
      ADD COLUMN `page_monetization_price` FLOAT NOT NULL DEFAULT 0  COMMENT '' AFTER `page_monetization_enabled`,
      MODIFY COLUMN `page_date` DATETIME NOT NULL  COMMENT '' AFTER `page_monetization_price`;

	";
  $db->multi_query($structure) or _error("Error", $db->error);


  // flush multi_queries
  do {
  } while (mysqli_more_results($db) && mysqli_next_result($db));


  // update tables collections
  $get_db_tbls = $db->query("show tables") or _error("Error", $db->error);
  while ($db_tbl = $get_db_tbls->fetch_array()) {
    foreach ($db_tbl as $key => $value) {
      $db->query("ALTER TABLE `$value` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci");
    }
  }


  // insert new system options
  $db->query("INSERT INTO system_options (option_name, option_value) VALUES
        ('monetization_wallet_payment_enabled', '0'),
        ('content_monetization_commission', '10'),
        ('gifts_permission', 'everyone'),
        ('system_logo_dark', ''),
        ('monetization_enabled', '0'),
        ('monetization_permission', 'everyone'),
        ('monetization_money_withdraw_enabled', '1'),
        ('monetization_payment_method_custom', ''),
        ('monetization_min_withdrawal', '50'),
        ('monetization_money_transfer_enabled', '0'),
        ('monetization_commission', '10'),
        ('monetization_payment_method', 'paypal,skrill'),
        ('packages_ads_free_enabled', '0'),
        ('videos_upload_permission', 'everyone'),
        ('audios_upload_permission', 'everyone'),
        ('files_upload_permission', 'everyone'),
        ('colored_posts_permission', 'everyone'),
        ('activity_posts_permission', 'everyone'),
        ('polls_posts_permission', 'everyone'),
        ('geolocation_posts_permission', 'everyone'),
        ('anonymous_posts_permission', 'everyone'),
        ('gif_posts_permission', 'everyone')
        ") or _error("Error", $db->error);


  // update system settings
  update_system_options([
    'session_hash' => secure($session_hash)
  ], false);


  // create config file
  $config_string = '<?php  
	define("DB_NAME", \'' . DB_NAME . '\');
	define("DB_USER", \'' . DB_USER . '\');
	define("DB_PASSWORD", \'' . DB_PASSWORD . '\');
	define("DB_HOST", \'' . DB_HOST . '\');
	define("DB_PORT", \'' . DB_PORT . '\');
	define("SYS_URL", \'' . SYS_URL . '\');
	define("DEBUGGING", false);
	define("DEFAULT_LOCALE", \'en_us\');
	define("LICENCE_KEY", \'' . $licence_key . '\');
	?>';
  $config_file = 'includes/config.php';
  $handle = fopen($config_file, 'w') or _error("System Error", "Cannot create the config file");
  fwrite($handle, $config_string);
  fclose($handle);


  // finished!
  _error("System Updated", "Delus has been updated to " . SYS_VER);
}

?>

<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="X-UA-Compatible" content="ie=edge">
  <title><?php echo SYS_NAME ?> &rsaquo; Update (v<?php echo SYS_VER ?>)</title>
  <link rel="shortcut icon" href="includes/assets/js/core/installer/favicon.png" />
  <link href="https://fonts.googleapis.com/css?family=Karla:400,700&display=swap" rel="stylesheet" crossorigin="anonymous">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" integrity="sha512-1ycn6IcaQQ40/MKBW2W4Rhis/DbILU74C1vSrLJxCq57o941Ym01SwNsOMqvEBFlcgUa6xLiPY/NS5R+E6ztJQ==" crossorigin="anonymous" referrerpolicy="no-referrer" />
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
              Welcome to <strong><?php echo SYS_NAME ?></strong> updating process! Just fill in the information below.
            </p>
            <div class="row mt-4">
              <div class="form-group col-12">
                <label for="purchase_code">Your Purchase Code</label>
                <input type="text" name="purchase_code" id="purchase_code" class="form-control" placeholder="xxx-xx-xxxx">
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
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
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
      onFinished: function(event, currentIndex) {
        /* check details */
        if ($('input[type="text"]').val() == "") {
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
    $('input[type="text"]').on('change', function() {
      if ($(this).val() == "") {
        $(this).addClass("is-invalid");
      } else {
        $(this).removeClass("is-invalid");
      }
    });
  </script>
</body>

</html>