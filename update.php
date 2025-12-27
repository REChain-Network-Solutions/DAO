<?php

/**
 * update wizard
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich
 */

// set execution time
set_time_limit(0); /* unlimited max execution time */


// set ABSPATH
define('ABSPATH', __DIR__ . '/');


// get system version & exceptions
define('SYS_UPDATE_VER', '4.2');
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

    CREATE TABLE `support_tickets_replies` (
      `reply_id` int unsigned NOT NULL AUTO_INCREMENT,
      `ticket_id` int unsigned NOT NULL,
      `user_id` int unsigned NOT NULL,
      `text` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `created_at` datetime NOT NULL,
      PRIMARY KEY (`reply_id`),
      KEY `user_id` (`user_id`),
      KEY `ticket_id` (`ticket_id`) USING BTREE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    CREATE TABLE `support_tickets` (
      `ticket_id` int unsigned NOT NULL AUTO_INCREMENT,
      `user_id` int unsigned NOT NULL,
      `agent_id` int unsigned DEFAULT NULL,
      `subject` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `text` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `status` enum('opened','in_progress','pending','solved','closed') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'opened',
      `replies` int unsigned NOT NULL DEFAULT '0',
      `created_at` datetime NOT NULL,
      `updated_at` datetime DEFAULT NULL,
      PRIMARY KEY (`ticket_id`),
      KEY `user_id` (`user_id`),
      KEY `agent_id` (`agent_id`) USING BTREE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    CREATE TABLE `conversations_messages_reactions` (
      `id` int unsigned NOT NULL AUTO_INCREMENT,
      `message_id` int unsigned NOT NULL,
      `user_id` int unsigned NOT NULL,
      `reaction` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'like',
      `reaction_time` datetime DEFAULT NULL,
      PRIMARY KEY (`id`),
      UNIQUE KEY `post_id_user_id` (`message_id`,`user_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    CREATE TABLE `users_packages_points` (
      `id` int unsigned NOT NULL AUTO_INCREMENT,
      `user_id` int unsigned NOT NULL,
      `package_id` int unsigned NOT NULL,
      PRIMARY KEY (`id`),
      UNIQUE KEY `user_id_poked_id` (`user_id`,`package_id`) USING BTREE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    # Changing table conversations fields
    ALTER TABLE `conversations`
      DROP COLUMN `is_group`;

    # Changing table log_points fields
    ALTER TABLE `log_points`
      ADD COLUMN `is_added` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1' COMMENT '' AFTER `points`,
      MODIFY COLUMN `time` DATETIME NOT NULL COMMENT '' AFTER `is_added`;

    # Changing table users fields
    ALTER TABLE `users`
      ADD COLUMN `user_boosted_groups` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '' AFTER `user_boosted_pages`,
      ADD COLUMN `user_boosted_events` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '' AFTER `user_boosted_groups`,
      MODIFY COLUMN `user_started` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '' AFTER `user_boosted_events`,
      ADD COLUMN `affiliates_per_user_6` FLOAT UNSIGNED NOT NULL DEFAULT 0 COMMENT '' AFTER `affiliates_percentage_5`,
      ADD COLUMN `affiliates_percentage_6` FLOAT UNSIGNED NOT NULL DEFAULT 0 COMMENT '' AFTER `affiliates_per_user_6`,
      ADD COLUMN `affiliates_per_user_7` FLOAT UNSIGNED NOT NULL DEFAULT 0 COMMENT '' AFTER `affiliates_percentage_6`,
      ADD COLUMN `affiliates_percentage_7` FLOAT UNSIGNED NOT NULL DEFAULT 0 COMMENT '' AFTER `affiliates_per_user_7`,
      ADD COLUMN `affiliates_per_user_8` FLOAT UNSIGNED NOT NULL DEFAULT 0 COMMENT '' AFTER `affiliates_percentage_7`,
      ADD COLUMN `affiliates_percentage_8` FLOAT UNSIGNED NOT NULL DEFAULT 0 COMMENT '' AFTER `affiliates_per_user_8`,
      ADD COLUMN `affiliates_per_user_9` FLOAT UNSIGNED NOT NULL DEFAULT 0 COMMENT '' AFTER `affiliates_percentage_8`,
      ADD COLUMN `affiliates_percentage_9` FLOAT UNSIGNED NOT NULL DEFAULT 0 COMMENT '' AFTER `affiliates_per_user_9`,
      ADD COLUMN `affiliates_per_user_10` FLOAT UNSIGNED NOT NULL DEFAULT 0 COMMENT '' AFTER `affiliates_percentage_9`,
      ADD COLUMN `affiliates_percentage_10` FLOAT UNSIGNED NOT NULL DEFAULT 0 COMMENT '' AFTER `affiliates_per_user_10`,
      MODIFY COLUMN `points_earned` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '' AFTER `affiliates_percentage_10`,
      ADD COLUMN `plisio_hash` VARCHAR(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '' AFTER `coinbase_code`,
      ADD COLUMN `plisio_txn_id` VARCHAR(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '' AFTER `plisio_hash`,
      MODIFY COLUMN `is_fake` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '' AFTER `plisio_txn_id`;

    # Changing table packages fields
    ALTER TABLE `packages`
      MODIFY COLUMN `custom_description` TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '' AFTER `icon`,
      ADD COLUMN `package_hidden` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '' AFTER `package_order`,
      MODIFY COLUMN `verification_badge_enabled` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '' AFTER `package_hidden`,
      MODIFY COLUMN `package_permissions_group_id` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '' AFTER `verification_badge_enabled`,
      ADD COLUMN `free_points` INT UNSIGNED NOT NULL COMMENT '' AFTER `allowed_products`,
      MODIFY COLUMN `boost_posts_enabled` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '' AFTER `free_points`,
      ADD COLUMN `boost_groups_enabled` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '' AFTER `boost_pages`,
      ADD COLUMN `boost_groups` INT UNSIGNED NOT NULL COMMENT '' AFTER `boost_groups_enabled`,
      ADD COLUMN `boost_events_enabled` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '' AFTER `boost_groups`,
      ADD COLUMN `boost_events` INT UNSIGNED NOT NULL COMMENT '' AFTER `boost_events_enabled`,
      MODIFY COLUMN `paypal_billing_plan` VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '' AFTER `boost_events`;

    # Changing table permissions_groups fields
    ALTER TABLE `permissions_groups`
      ADD COLUMN `affiliates_per_user_6` FLOAT UNSIGNED NOT NULL DEFAULT 0 COMMENT '' AFTER `affiliates_percentage_5`,
      ADD COLUMN `affiliates_percentage_6` FLOAT UNSIGNED NOT NULL DEFAULT 0 COMMENT '' AFTER `affiliates_per_user_6`,
      ADD COLUMN `affiliates_per_user_7` FLOAT UNSIGNED NOT NULL DEFAULT 0 COMMENT '' AFTER `affiliates_percentage_6`,
      ADD COLUMN `affiliates_percentage_7` FLOAT UNSIGNED NOT NULL DEFAULT 0 COMMENT '' AFTER `affiliates_per_user_7`,
      ADD COLUMN `affiliates_per_user_8` FLOAT UNSIGNED NOT NULL DEFAULT 0 COMMENT '' AFTER `affiliates_percentage_7`,
      ADD COLUMN `affiliates_percentage_8` FLOAT UNSIGNED NOT NULL DEFAULT 0 COMMENT '' AFTER `affiliates_per_user_8`,
      ADD COLUMN `affiliates_per_user_9` FLOAT UNSIGNED NOT NULL DEFAULT 0 COMMENT '' AFTER `affiliates_percentage_8`,
      ADD COLUMN `affiliates_percentage_9` FLOAT UNSIGNED NOT NULL DEFAULT 0 COMMENT '' AFTER `affiliates_per_user_9`,
      ADD COLUMN `affiliates_per_user_10` FLOAT UNSIGNED NOT NULL DEFAULT 0 COMMENT '' AFTER `affiliates_percentage_9`,
      ADD COLUMN `affiliates_percentage_10` FLOAT UNSIGNED NOT NULL DEFAULT 0 COMMENT '' AFTER `affiliates_per_user_10`,
      MODIFY COLUMN `custom_points_system` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '' AFTER `affiliates_percentage_10`;

    # Changing table groups fields
    ALTER TABLE `groups`
      ADD COLUMN `group_boosted` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '' AFTER `group_pinned_post`,
      ADD COLUMN `group_boosted_by` INT UNSIGNED NULL DEFAULT NULL COMMENT '' AFTER `group_boosted`,
      MODIFY COLUMN `group_members` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '' AFTER `group_boosted_by`;

    # Changing table ads_campaigns fields
    ALTER TABLE `ads_campaigns`
      ADD COLUMN `ads_video` VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '' AFTER `ads_image`,
      MODIFY COLUMN `campaign_created_date` DATETIME NOT NULL COMMENT '' AFTER `ads_video`;

    # Changing table conversations_messages fields
    ALTER TABLE `conversations_messages`
      ADD COLUMN `video` VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '' AFTER `image`,
      MODIFY COLUMN `voice_note` VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '' AFTER `video`,
      ADD COLUMN `product_post_id` INT UNSIGNED NULL DEFAULT NULL COMMENT '' AFTER `voice_note`,
      ADD COLUMN `reaction_like_count` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '' AFTER `product_post_id`,
      ADD COLUMN `reaction_love_count` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '' AFTER `reaction_like_count`,
      ADD COLUMN `reaction_haha_count` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '' AFTER `reaction_love_count`,
      ADD COLUMN `reaction_yay_count` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '' AFTER `reaction_haha_count`,
      ADD COLUMN `reaction_wow_count` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '' AFTER `reaction_yay_count`,
      ADD COLUMN `reaction_sad_count` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '' AFTER `reaction_wow_count`,
      ADD COLUMN `reaction_angry_count` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '' AFTER `reaction_sad_count`,
      MODIFY COLUMN `time` DATETIME NOT NULL COMMENT '' AFTER `reaction_angry_count`;

    # Changing table events fields
    ALTER TABLE `events`
      ADD COLUMN `event_latitude` VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '' AFTER `event_location`,
      ADD COLUMN `event_longitude` VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '' AFTER `event_latitude`,
      MODIFY COLUMN `event_country` INT UNSIGNED NOT NULL COMMENT '' AFTER `event_longitude`,
      ADD COLUMN `event_boosted` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '' AFTER `event_pinned_post`,
      ADD COLUMN `event_boosted_by` INT UNSIGNED NULL DEFAULT NULL COMMENT '' AFTER `event_boosted`,
      MODIFY COLUMN `event_invited` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '' AFTER `event_boosted_by`;

    # Changing table gifts fields
    ALTER TABLE `gifts`
      ADD COLUMN `points` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '' AFTER `image`;

    COMMIT;
      
	";
  $db->multi_query($structure) or _error("Error", $db->error);


  // flush multi_queries
  do {
  } while (mysqli_more_results($db) && mysqli_next_result($db));


  // remove "system_back_swipe" from system options
  $db->query("DELETE FROM system_options WHERE option_name = 'system_back_swipe'");


  // insert new system options
  $db->query("INSERT INTO system_options (option_name, option_value) VALUES
      ('pro_groups_widget_enabled','0'),
      ('pro_events_widget_enabled','0'),
      ('plisio_enabled','0'),
      ('plisio_secret_key',''),
      ('chat_videos_enabled','1'),
      ('ageverif_enabled','0'),
      ('ageverif_api_key','0'),
      ('reels_minimum_duration','0'),
      ('reels_maximum_duration','0'),
      ('video_minimum_duration','0'),
      ('video_maximum_duration','0'),
      ('paid_blogs_enabled','0'),
      ('paid_blogs_cost','0'),
      ('paid_products_enabled','0'),
      ('paid_products_cost','0'),
      ('paid_funding_enabled','0'),
      ('paid_funding_cost','0'),
      ('paid_offers_enabled','0'),
      ('paid_offers_cost','0'),
      ('paid_jobs_enabled','0'),
      ('paid_jobs_cost','0'),
      ('paid_courses_enabled','0'),
      ('paid_courses_cost','0'),
      ('redirect_to_mobile_apps','0'),
      ('messaging_app_android_link',''),
      ('messaging_app_ios_link',''),
      ('gifts_points_enabled','0'),
      ('blogs_widget_enabled','1'),
      ('support_center_enabled','1'),
      ('affiliates_per_user_6','0'),
      ('affiliates_percentage_6','0'),
      ('affiliates_per_user_7','0'),
      ('affiliates_percentage_7','0'),
      ('affiliates_per_user_8','0'),
      ('affiliates_percentage_8','0'),
      ('affiliates_per_user_9','0'),
      ('affiliates_percentage_9','0'),
      ('affiliates_per_user_10','0'),
      ('affiliates_percentage_10','0')
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
	define("URL_CHECK", true);
	define("DEBUGGING", false);
	define("DEFAULT_LOCALE", \'en_us\');
	define("LICENCE_KEY", \'' . $licence_key . '\');
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
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" integrity="sha512-iecdLmaskl7CVkqkXNQ/ZH/XLlvWZOJyj7Yy7tcenmpD1ypASozpmT/E0iPtmFIB46ZmdtAc9eNBvH0H/ZpiBw==" crossorigin="anonymous" referrerpolicy="no-referrer" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" integrity="sha512-t4GWSVZO1eC8BM339Xd7Uphw5s17a86tIZIj8qRxhnKub6WoyhnrxeCIMeAqBPgdZGlCcG2PrZjMc+Wr78+5Xg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
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
  <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.min.js" integrity="sha512-3dZ9wIrMMij8rOH7X3kLfXAzwtcHpuYpEgQg1OA4QAob1e81H8ntUQmQm3pBudqIoySO5j0tHN4ENzA6+n2r4w==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
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