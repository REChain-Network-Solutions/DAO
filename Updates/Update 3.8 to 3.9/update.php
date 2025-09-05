<?php

/**
 * update wizard
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich - Handles - @sorydima @sorydev @durovshater @DmitrySoro90935 @tanechfund - also check https://dmitry.rechain.network for more information!
 */

// set execution time
set_time_limit(0); /* unlimited max execution time */


// set ABSPATH & BASEPATH
define('ABSPATH', __DIR__ . '/');
define('BASEPATH', dirname($_SERVER['PHP_SELF']));


// get system version & exceptions
define('SYS_UPDATE_VER', '3.9');
require(ABSPATH . 'includes/sys_ver.php');
require(ABSPATH . 'includes/exceptions.php');


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
    $JWT_SECRET = md5($licence_key);
  } catch (Exception $e) {
    _error("Error", $e->getMessage());
  }


  // init database connection
  try {
    $db = init_db_connection();
  } catch (Exception $e) {
    _error('DB_ERROR');
  }


  // update database tables
  $structure = "

    START TRANSACTION;

    CREATE TABLE `users_accounts` (
      `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
      `user_id` int(10) unsigned NOT NULL,
      `account_id` int(10) unsigned NOT NULL,
      PRIMARY KEY (`id`),
      UNIQUE KEY `user_id_account_id` (`user_id`,`account_id`) USING BTREE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

    CREATE TABLE `permissions_groups` (
      `permissions_group_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
      `permissions_group_title` varchar(255) NOT NULL,
      `pages_permission` enum('0','1') NOT NULL DEFAULT '0',
      `groups_permission` enum('0','1') NOT NULL DEFAULT '0',
      `events_permission` enum('0','1') NOT NULL DEFAULT '0',
      `blogs_permission` enum('0','1') NOT NULL DEFAULT '0',
      `market_permission` enum('0','1') NOT NULL DEFAULT '0',
      `forums_permission` enum('0','1') NOT NULL DEFAULT '0',
      `movies_permission` enum('0','1') NOT NULL DEFAULT '0',
      `games_permission` enum('0','1') NOT NULL DEFAULT '0',
      `gifts_permission` enum('0','1') NOT NULL DEFAULT '0',
      `blogs_permission_read` enum('0','1') NOT NULL DEFAULT '0',
      `videos_permission_read` enum('0','1') NOT NULL DEFAULT '0',
      `stories_permission` enum('0','1') NOT NULL DEFAULT '0',
      `colored_posts_permission` enum('0','1') NOT NULL DEFAULT '0',
      `activity_posts_permission` enum('0','1') NOT NULL DEFAULT '0',
      `polls_posts_permission` enum('0','1') NOT NULL DEFAULT '0',
      `geolocation_posts_permission` enum('0','1') NOT NULL DEFAULT '0',
      `gif_posts_permission` enum('0','1') NOT NULL DEFAULT '0',
      `anonymous_posts_permission` enum('0','1') NOT NULL DEFAULT '0',
      `invitation_permission` enum('0','1') NOT NULL DEFAULT '0',
      `audio_call_permission` enum('0','1') NOT NULL DEFAULT '0',
      `video_call_permission` enum('0','1') NOT NULL DEFAULT '0',
      `live_permission` enum('0','1') NOT NULL DEFAULT '0',
      `videos_upload_permission` enum('0','1') NOT NULL DEFAULT '0',
      `audios_upload_permission` enum('0','1') NOT NULL DEFAULT '0',
      `files_upload_permission` enum('0','1') NOT NULL DEFAULT '0',
      `ads_permission` enum('0','1') NOT NULL DEFAULT '0',
      `fundings_permission` enum('0','1') NOT NULL DEFAULT '0',
      `monetization_permission` enum('0','1') NOT NULL DEFAULT '0',
      `tips_permission` enum('0','1') NOT NULL DEFAULT '0',
      PRIMARY KEY (`permissions_group_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

    INSERT INTO `permissions_groups` (`permissions_group_id`, `permissions_group_title`, `pages_permission`, `groups_permission`, `events_permission`, `blogs_permission`, `market_permission`, `forums_permission`, `movies_permission`, `games_permission`, `gifts_permission`, `blogs_permission_read`, `videos_permission_read`, `stories_permission`, `colored_posts_permission`, `activity_posts_permission`, `polls_posts_permission`, `geolocation_posts_permission`, `gif_posts_permission`, `anonymous_posts_permission`, `invitation_permission`, `audio_call_permission`, `video_call_permission`, `live_permission`, `videos_upload_permission`, `audios_upload_permission`, `files_upload_permission`, `ads_permission`, `fundings_permission`, `monetization_permission`, `tips_permission`) VALUES
    (1, 'Users Permissions', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1'),
    (2, 'Verified Permissions', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1');

    CREATE TABLE `posts_videos_categories` (
      `category_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
      `category_parent_id` int(10) unsigned NOT NULL,
      `category_name` varchar(256) NOT NULL,
      `category_description` text NOT NULL,
      `category_order` int(10) unsigned NOT NULL DEFAULT '1',
      PRIMARY KEY (`category_id`),
      KEY `category_parent_id` (`category_parent_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

    INSERT INTO `posts_videos_categories` (`category_id`, `category_parent_id`, `category_name`, `category_description`, `category_order`) VALUES
    (1, 0, 'General', '', 1),
    (2, 0, 'Comedy', '', 2),
    (3, 0, 'Economics and Trade', '', 3),
    (4, 0, 'Education', '', 4),
    (5, 0, 'Entertainment', '', 5),
    (6, 0, 'Movies and Animation', '', 6),
    (7, 0, 'Gaming', '', 7),
    (8, 0, 'History and Facts', '', 8),
    (9, 0, 'Live Style', '', 9),
    (10, 0, 'Natural', '', 10),
    (11, 0, 'News and Politics', '', 11),
    (12, 0, 'People and Nations', '', 12),
    (13, 0, 'Pets and Animals', '', 13),
    (14, 0, 'Places and Regions', '', 14),
    (15, 0, 'Science and Technology', '', 15),
    (16, 0, 'Sport', '', 16),
    (17, 0, 'Travel and Events', '', 17),
    (18, 0, 'Other', '', 18);

    CREATE TABLE `users_groups` (
      `user_group_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
      `user_group_title` varchar(255) NOT NULL,
      `permissions_group_id` int(10) unsigned NOT NULL,
      PRIMARY KEY (`user_group_id`),
      KEY `permissions_group_id` (`permissions_group_id`) USING BTREE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

    CREATE TABLE `movies_payments` (
      `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
      `movie_id` int(10) unsigned NOT NULL,
      `user_id` int(10) unsigned NOT NULL,
      `payment_time` datetime NOT NULL,
      PRIMARY KEY (`id`),
      UNIQUE KEY `move_id_user_id` (`movie_id`,`user_id`) USING BTREE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

    # Changing table movies fields
    ALTER TABLE `movies`
      ADD COLUMN `is_paid` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `views`,
      ADD COLUMN `price` FLOAT NOT NULL DEFAULT 0  COMMENT '' AFTER `is_paid`,
      ADD COLUMN `available_for` INT(10) NOT NULL DEFAULT 0  COMMENT '' AFTER `price`;

    # Changing table packages fields, indexes
    ALTER TABLE `packages`
      ADD COLUMN `package_permissions_group_id` INT(10) UNSIGNED NOT NULL DEFAULT 0  COMMENT '' AFTER `icon`,
      ADD COLUMN `allowed_blogs_categories` INT(10) NOT NULL DEFAULT 0  COMMENT '' AFTER `package_permissions_group_id`,
      ADD COLUMN `allowed_videos_categories` INT(10) NOT NULL DEFAULT 0  COMMENT '' AFTER `allowed_blogs_categories`,
      MODIFY COLUMN `verification_badge_enabled` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `allowed_videos_categories`,
      ADD INDEX `package_permissions_group_id` USING BTREE (package_permissions_group_id);

    # Changing table ads_system fields
    ALTER TABLE `ads_system`
      ADD COLUMN `ads_pages_ids` TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL  COMMENT '' AFTER `place`,
      ADD COLUMN `ads_groups_ids` TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL  COMMENT '' AFTER `ads_pages_ids`,
      MODIFY COLUMN `code` MEDIUMTEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL  COMMENT '' AFTER `ads_groups_ids`;

    # Changing table bank_transfers fields
    ALTER TABLE `bank_transfers`
      ADD COLUMN `movie_id` INT(10) UNSIGNED NULL DEFAULT NULL  COMMENT '' AFTER `plan_id`,
      MODIFY COLUMN `price` FLOAT NULL DEFAULT NULL  COMMENT '' AFTER `movie_id`;

    # Changing table posts_links fields
    ALTER TABLE `posts_links`
      MODIFY COLUMN `source_title` TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL  COMMENT '' AFTER `source_host`;

    # Changing table posts_media fields
    ALTER TABLE `posts_media`
      MODIFY COLUMN `source_title` TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL  COMMENT '' AFTER `source_type`;

    # Changing table users fields
    ALTER TABLE `users`
      ADD COLUMN `user_master_account` INT(10) NOT NULL DEFAULT 0  COMMENT '' AFTER `user_id`,
      MODIFY COLUMN `user_group` TINYINT(10) UNSIGNED NOT NULL DEFAULT 3  COMMENT '' AFTER `user_master_account`,
      ADD COLUMN `user_group_custom` INT(11) NOT NULL DEFAULT 0  COMMENT '' AFTER `user_group`,
      MODIFY COLUMN `user_demo` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `user_group_custom`,
      ADD COLUMN `user_package_videos_categories` TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL  COMMENT '' AFTER `user_package`,
      ADD COLUMN `user_package_blogs_categories` TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL  COMMENT '' AFTER `user_package_videos_categories`,
      MODIFY COLUMN `user_subscription_date` DATETIME NULL DEFAULT NULL  COMMENT '' AFTER `user_package_blogs_categories`,
      ADD COLUMN `wordpress_connected` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `vkontakte_id`,
      ADD COLUMN `wordpress_id` VARCHAR(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL  COMMENT '' AFTER `wordpress_connected`,
      MODIFY COLUMN `user_referrer_id` INT(10) NULL DEFAULT NULL  COMMENT '' AFTER `wordpress_id`;

    # Changing table stories fields
    ALTER TABLE `stories`
      ADD COLUMN `is_ads` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `user_id`,
      MODIFY COLUMN `time` DATETIME NOT NULL  COMMENT '' AFTER `is_ads`;

    # Changing table posts_videos fields, indexes
    ALTER TABLE `posts_videos`
      ADD COLUMN `category_id` INT(10) UNSIGNED NOT NULL  COMMENT '' AFTER `post_id`,
      MODIFY COLUMN `source` VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL  COMMENT '' AFTER `category_id`,
      ADD INDEX `category_id` USING BTREE (category_id);

    COMMIT;
      
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


  // update users
  $db->query("UPDATE users SET user_master_account = user_id") or _error("Error", $db->error);


  // update posts_videos
  $db->query("UPDATE posts_videos SET category_id = '1'") or _error("Error", $db->error);


  // update all packages permissions to 1
  $db->query("UPDATE packages SET package_permissions_group_id = '1'") or _error("Error", $db->error);


  // remove old system options
  $db->query("DELETE FROM system_options WHERE option_name IN (
    'pages_permission', 
    'groups_permission', 
    'events_permission',
    'blogs_permission',
    'market_permission',
    'funding_permission',
    'monetization_permission',
    'tips_permission',
    'ads_permission',
    'forums_permission',
    'movies_permission',
    'games_permission',
    'gifts_permission',
    'stories_permission',
    'colored_posts_permission',
    'activity_posts_permission',
    'polls_posts_permission',
    'geolocation_posts_permission',
    'gif_posts_permission',
    'anonymous_posts_permission',
    'invitation_permission',
    'audio_call_permission',
    'video_call_permission',
    'live_permission',
    'videos_upload_permission',
    'audios_upload_permission',
    'files_upload_permission',
    'packages_ads_free_enabled'
    )") or _error("Error", $db->error);


  // insert new system options
  $db->query("INSERT INTO system_options (option_name, option_value) VALUES
        ('wordpress_login_enabled', '0'),
        ('wordpress_appid', ''),
        ('wordpress_secret', ''),
        ('moneypoolscash_merchant_password', ''),
        ('default_custom_user_group', '0'),
        ('verification_docs_required', '1'),
        ('fluid_design', '0'),
        ('css_header_icons', ''),
        ('css_header_icons_night', ''),
        ('css_main_icons', ''),
        ('css_main_icons_night', ''),
        ('css_action_icons', ''),
        ('css_action_icons_night', '')
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
  define("JWT_SECRET", \'' . $JWT_SECRET . '\');
	?>';
  $config_file = 'includes/config.php';
  $handle = fopen($config_file, 'w') or _error("System Error", "Cannot create the config file");
  fwrite($handle, $config_string);
  fclose($handle);


  // finished!
  _error("System Updated", "Delus has been updated to " . SYS_UPDATE_VER);
}

?>

<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="X-UA-Compatible" content="ie=edge">
  <title><?php echo SYS_NAME ?> &rsaquo; Update (v<?php echo SYS_UPDATE_VER ?>)</title>
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
              <div class="bd-wizard-step-subtitle">Delus (v<?php echo SYS_UPDATE_VER ?>)</div>
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
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.1/umd/popper.min.js" integrity="sha512-ubuT8Z88WxezgSqf3RLuNi5lmjstiJcyezx34yIU2gAHonIi27Na7atqzUZCOoY4CExaoFumzOsFQ2Ch+I/HCw==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
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
        $("#wizard-submittion").trigger('click');
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