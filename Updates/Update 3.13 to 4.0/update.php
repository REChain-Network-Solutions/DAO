<?php

/**
 * update wizard
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich - Handles - @sorydima @sorydev @durovshater @DmitrySoro90935 @tanechfund - also check https://dmitry.rechain.network for more information!
 */

// set execution time
set_time_limit(0); /* unlimited max execution time */


// set ABSPATH
define('ABSPATH', __DIR__ . '/');


// get system version & exceptions
define('SYS_UPDATE_VER', '4.0');
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

    CREATE TABLE `merits_categories` (
      `category_id` int unsigned NOT NULL AUTO_INCREMENT,
      `category_parent_id` int unsigned NOT NULL,
      `category_name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `category_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `category_image` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `category_order` int unsigned NOT NULL DEFAULT '1',
      PRIMARY KEY (`category_id`),
      KEY `category_parent_id` (`category_parent_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    CREATE TABLE `users_merits` (
      `id` int unsigned NOT NULL AUTO_INCREMENT,
      `from_user_id` int unsigned NOT NULL,
      `to_user_id` int unsigned NOT NULL,
      `category_id` int unsigned NOT NULL,
      `message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
      `image` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `sent_date` datetime NOT NULL,
      PRIMARY KEY (`id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    CREATE TABLE `posts_merits` (
      `merit_id` int unsigned NOT NULL AUTO_INCREMENT,
      `post_id` int unsigned NOT NULL,
      `category_id` int unsigned NOT NULL,
      `message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `image` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      PRIMARY KEY (`merit_id`),
      KEY `post_id` (`post_id`),
      KEY `category_id` (`category_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    DROP TABLE `activities`;

    DROP TABLE `activities_permissions_users`;

    DROP TABLE `activities_categories`;

    DROP TABLE `activities_permisions_requests`;

    # Insert Merit Categories
    INSERT INTO `merits_categories` (`category_id`, `category_parent_id`, `category_name`, `category_description`, `category_image`, `category_order`) VALUES
    (1, 0, 'Respect', 'Respect', 'merits/Respect.png', 1),
    (2, 0, 'Integrity', 'Integrit', 'merits/Integrity.png', 2),
    (3, 0, 'Collaboration', 'Collaboration', 'merits/Collaboration.png', 3),
    (4, 0, 'Quality', 'Quality', 'merits/Quality.png', 4);

    # Changing table ads_campaigns fields
    ALTER TABLE `ads_campaigns`
      ADD COLUMN `ads_post_url` VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL  COMMENT '' AFTER `ads_url`,
      MODIFY COLUMN `ads_page` INT UNSIGNED NULL DEFAULT NULL  COMMENT '' AFTER `ads_post_url`;

    # Changing table conversations fields
    ALTER TABLE `conversations`
      ADD COLUMN `is_group` ENUM('1','0') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `node_type`;

    # Changing table orders fields
    ALTER TABLE `orders`
      ADD COLUMN `is_cash_on_delivery` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `is_payment_done`,
      MODIFY COLUMN `is_digital` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `is_cash_on_delivery`;

    # Changing table users_sessions fields
    ALTER TABLE `users_sessions`
      ADD COLUMN `session_onesignal_user_id` VARCHAR(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL  COMMENT '' AFTER `user_device_name`;

    # Changing table log_sessions fields
    ALTER TABLE `log_sessions`
      MODIFY COLUMN `session_user_agent` VARCHAR(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL  COMMENT '' AFTER `session_ip`;

    # Changing table pages fields
    ALTER TABLE `pages`
      MODIFY COLUMN `page_boosted` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `page_tips_enabled`,
      ADD COLUMN `is_fake` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `page_date`,
      DROP COLUMN `page_activities_enabled`;

    # Changing table users fields
    ALTER TABLE `users`
      ADD COLUMN `user_live_calls_counter` INT UNSIGNED NOT NULL DEFAULT 0  COMMENT '' AFTER `user_live_messages_lastid`,
      MODIFY COLUMN `user_live_notifications_counter` INT UNSIGNED NOT NULL DEFAULT 0  COMMENT '' AFTER `user_live_calls_counter`,
      ADD COLUMN `user_suggestions_hidden` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `user_tips_enabled`,
      MODIFY COLUMN `user_privacy_chat` ENUM('me','friends','public') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'public'  COMMENT '' AFTER `user_suggestions_hidden`,
      ADD COLUMN `custom_affiliates_system` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `user_referrer_id`,
      ADD COLUMN `affiliates_per_user` FLOAT UNSIGNED NOT NULL DEFAULT 0  COMMENT '' AFTER `custom_affiliates_system`,
      ADD COLUMN `affiliates_percentage` FLOAT UNSIGNED NOT NULL DEFAULT 0  COMMENT '' AFTER `affiliates_per_user`,
      ADD COLUMN `affiliates_per_user_2` FLOAT UNSIGNED NOT NULL DEFAULT 0  COMMENT '' AFTER `affiliates_percentage`,
      ADD COLUMN `affiliates_percentage_2` FLOAT UNSIGNED NOT NULL DEFAULT 0  COMMENT '' AFTER `affiliates_per_user_2`,
      ADD COLUMN `affiliates_per_user_3` FLOAT UNSIGNED NOT NULL DEFAULT 0  COMMENT '' AFTER `affiliates_percentage_2`,
      ADD COLUMN `affiliates_percentage_3` FLOAT UNSIGNED NOT NULL DEFAULT 0  COMMENT '' AFTER `affiliates_per_user_3`,
      ADD COLUMN `affiliates_per_user_4` FLOAT UNSIGNED NOT NULL DEFAULT 0  COMMENT '' AFTER `affiliates_percentage_3`,
      ADD COLUMN `affiliates_percentage_4` FLOAT UNSIGNED NOT NULL DEFAULT 0  COMMENT '' AFTER `affiliates_per_user_4`,
      ADD COLUMN `affiliates_per_user_5` FLOAT UNSIGNED NOT NULL DEFAULT 0  COMMENT '' AFTER `affiliates_percentage_4`,
      ADD COLUMN `affiliates_percentage_5` FLOAT UNSIGNED NOT NULL DEFAULT 0  COMMENT '' AFTER `affiliates_per_user_5`,
      MODIFY COLUMN `points_earned` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `affiliates_percentage_5`,
      ADD COLUMN `is_fake` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `coinbase_code`;

    # Changing table groups fields
    ALTER TABLE `groups`
      ADD COLUMN `is_fake` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `group_date`;

    # Changing table posts fields
    ALTER TABLE `posts`
      ADD COLUMN `is_schedule` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `is_hidden`,
      MODIFY COLUMN `for_adult` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `is_schedule`,
      ADD COLUMN `is_paid_locked` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `is_paid`,
      MODIFY COLUMN `post_price` FLOAT UNSIGNED NOT NULL DEFAULT 0  COMMENT '' AFTER `is_paid_locked`;

    # Changing table permissions_groups fields
    ALTER TABLE `permissions_groups`
      ADD COLUMN `offers_permission_read` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `offers_permission`,
      MODIFY COLUMN `jobs_permission` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `offers_permission_read`,
      ADD COLUMN `schedule_posts_permission` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `posts_permission`,
      MODIFY COLUMN `colored_posts_permission` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `schedule_posts_permission`,
      ADD COLUMN `custom_affiliates_system` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `tips_permission`,
      ADD COLUMN `affiliates_per_user` FLOAT UNSIGNED NOT NULL DEFAULT 0  COMMENT '' AFTER `custom_affiliates_system`,
      ADD COLUMN `affiliates_percentage` FLOAT UNSIGNED NOT NULL DEFAULT 0  COMMENT '' AFTER `affiliates_per_user`,
      ADD COLUMN `affiliates_per_user_2` FLOAT UNSIGNED NOT NULL DEFAULT 0  COMMENT '' AFTER `affiliates_percentage`,
      ADD COLUMN `affiliates_percentage_2` FLOAT UNSIGNED NOT NULL DEFAULT 0  COMMENT '' AFTER `affiliates_per_user_2`,
      ADD COLUMN `affiliates_per_user_3` FLOAT UNSIGNED NOT NULL DEFAULT 0  COMMENT '' AFTER `affiliates_percentage_2`,
      ADD COLUMN `affiliates_percentage_3` FLOAT UNSIGNED NOT NULL DEFAULT 0  COMMENT '' AFTER `affiliates_per_user_3`,
      ADD COLUMN `affiliates_per_user_4` FLOAT UNSIGNED NOT NULL DEFAULT 0  COMMENT '' AFTER `affiliates_percentage_3`,
      ADD COLUMN `affiliates_percentage_4` FLOAT UNSIGNED NOT NULL DEFAULT 0  COMMENT '' AFTER `affiliates_per_user_4`,
      ADD COLUMN `affiliates_per_user_5` FLOAT UNSIGNED NOT NULL DEFAULT 0  COMMENT '' AFTER `affiliates_percentage_4`,
      ADD COLUMN `affiliates_percentage_5` FLOAT UNSIGNED NOT NULL DEFAULT 0  COMMENT '' AFTER `affiliates_per_user_5`,
      MODIFY COLUMN `custom_points_system` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `affiliates_percentage_5`;

    # Changing table users fields
    ALTER TABLE `users` DROP COLUMN `onesignal_user_id`;
    ALTER TABLE `users` DROP COLUMN `onesignal_android_user_id`;
    ALTER TABLE `users` DROP COLUMN `onesignal_ios_user_id`;

    COMMIT;
      
	";
  $db->multi_query($structure) or _error("Error", $db->error);


  // flush multi_queries
  do {
  } while (mysqli_more_results($db) && mysqli_next_result($db));


  // update permissions_groups set schedule_posts_permission = 1
  $db->query("UPDATE permissions_groups SET schedule_posts_permission = '1' WHERE schedule_posts_permission = '0'") or _error("Error", $db->error);


  // update permissions_groups set offers_permission_read = 1
  $db->query("UPDATE permissions_groups SET offers_permission_read = '1' WHERE offers_permission_read = '0'") or _error("Error", $db->error);


  // remove pages_activities_enabled from system_options
  $db->query("DELETE FROM system_options WHERE option_name = 'pages_activities_enabled'") or _error("Error", $db->error);


  // Update audio_extensions "mp3, wav, ogg, m4a"
  $db->query("UPDATE system_options SET option_value = 'mp3,wav,ogg,m4a' WHERE option_name = 'audio_extensions'") or _error("Error", $db->error);


  // insert new system options
  $db->query("INSERT INTO system_options (option_name, option_value) VALUES
      ('google_translation_key',''),
      ('chat_translation_enabled','0'),
      ('market_wallet_payment_enabled','1'),
      ('censored_domains_enabled','0'),
      ('censored_domains',''),
      ('mods_users_permission','1'),
      ('mods_posts_permission','1'),
      ('mods_pages_permission','1'),
      ('mods_groups_permission','1'),
      ('mods_events_permission','1'),
      ('mods_blogs_permission','1'),
      ('mods_offers_permission','1'),
      ('mods_jobs_permission','1'),
      ('mods_courses_permission','1'),
      ('mods_forums_permission','1'),
      ('mods_movies_permission','1'),
      ('mods_games_permission','1'),
      ('mods_reports_permission','1'),
      ('mods_verifications_permission','1'),
      ('mods_ads_permission','0'),
      ('mods_wallet_permission','0'),
      ('mods_affiliates_permission','0'),
      ('mods_points_permission','0'),
      ('mods_marketplace_permission','0'),
      ('mods_funding_permission','0'),
      ('mods_monetization_permission','0'),
      ('mods_tips_permission','0'),
      ('mods_payments_permission','0'),
      ('mods_developers_permission','1'),
      ('mods_blacklist_permission','1'),
      ('mods_customization_permission','1'),
      ('mods_reach_permission','1'),
      ('mods_pro_permission','0'),
      ('ads_author_view_enabled','1'),
      ('audio_video_provider','twilio'),
      ('livekit_api_key',''),
      ('livekit_api_secret',''),
      ('livekit_ws_url',''),
      ('cover_crop_enabled','0'),
      ('market_cod_payment_enabled','0'),
      ('chunk_upload_size','100'),
      ('smooth_infinite_scroll','0'),
      ('newsfeed_merge_enabled','0'),
      ('merge_recent_results','12'),
      ('merge_popular_results','3'),
      ('merge_discover_results','3'),
      ('newsfeed_caching_enabled','0'),
      ('popular_posts_interval','month'),
      ('pwa_enabled','0'),
      ('pwa_192_icon',''),
      ('pwa_512_icon',''),
      ('pwa_banner_enabled','1'),
      ('mask_file_path_enabled','1'),
      ('disable_yt_player','0'),
      ('mercadopago_enabled','0'),
      ('mercadopago_public_key',''),
      ('mercadopago_access_token',''),
      ('merits_enabled','0'),
      ('merits_peroid_max','5'),
      ('merits_send_peroid_max','2'),
      ('merits_peroid','1'),
      ('merits_notifications_recharge','1'),
      ('merits_notifications_reminder','1'),
      ('merits_notifications_recipient','1'),
      ('merits_notifications_sender','1'),
      ('merits_widgets_newsfeed','1'),
      ('merits_widgets_winners','1'),
      ('merits_widgets_balance','1'),
      ('merits_widgets_statistics','1'),
      ('merits_peroid_reset','1'),
      ('cronjob_enabled','0'),
      ('cronjob_reset_pro_packages','1'),
      ('cronjob_undelivered_orders','1'),
      ('cronjob_merits_reminder','1'),
      ('system_back_swipe','0'),
      ('whitelist_enabled','0'),
      ('whitelist_providers',''),
      ('allow_heif_images','0'),
      ('affiliate_payment_to','buyer'),
      ('turnstile_enabled','0'),
      ('turnstile_site_key',''),
      ('turnstile_secret_key',''),
      ('password_complexity_enabled','0'),
      ('market_delivery_days','30'),
      ('system_api_key',''),
      ('system_api_secret',''),
      ('system_jwt_key','')
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