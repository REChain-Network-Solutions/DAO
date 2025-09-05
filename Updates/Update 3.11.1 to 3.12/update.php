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
define('SYS_UPDATE_VER', '3.12');
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

    CREATE TABLE `log_sessions` (
      `session_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
      `session_date` datetime NOT NULL,
      `session_type` enum('W','A','I') NOT NULL DEFAULT 'W',
      `session_ip` varchar(64) NOT NULL,
      `session_user_agent` varchar(256) DEFAULT NULL,
      `user_browser` varchar(64) DEFAULT NULL,
      `user_os` varchar(64) DEFAULT NULL,
      PRIMARY KEY (`session_id`),
      KEY `session_ip` (`session_ip`) USING BTREE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

    CREATE TABLE `log_commissions` (
      `payment_id` int(10) NOT NULL AUTO_INCREMENT,
      `user_id` int(10) unsigned NOT NULL,
      `amount` float NOT NULL,
      `handle` varchar(128) NOT NULL,
      `time` datetime NOT NULL,
      PRIMARY KEY (`payment_id`) USING BTREE,
      KEY `user_id` (`user_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

    CREATE TABLE `log_payments` (
      `payment_id` int(10) NOT NULL AUTO_INCREMENT,
      `user_id` int(10) unsigned NOT NULL,
      `amount` float NOT NULL,
      `method` varchar(64) NOT NULL,
      `handle` varchar(128) NOT NULL,
      `time` datetime NOT NULL,
      PRIMARY KEY (`payment_id`) USING BTREE,
      KEY `user_id` (`user_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

    CREATE TABLE `posts_views` (
      `view_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
      `view_date` datetime NOT NULL,
      `post_id` int(10) unsigned NOT NULL,
      `user_id` int(10) unsigned DEFAULT NULL,
      `guest_ip` varchar(64) DEFAULT NULL,
      PRIMARY KEY (`view_id`),
      KEY `user_id` (`user_id`),
      KEY `post_id` (`post_id`) USING BTREE,
      KEY `guest_ip` (`guest_ip`) USING BTREE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

    # Changing table groups fields
    ALTER TABLE `groups`
      ADD COLUMN `group_rate` FLOAT NOT NULL DEFAULT 0  COMMENT '' AFTER `chatbox_conversation_id`,
      MODIFY COLUMN `group_date` DATETIME NOT NULL  COMMENT '' AFTER `group_rate`;

    # Changing table permissions_groups fields
    ALTER TABLE `permissions_groups`
      ADD COLUMN `posts_permission` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `events_permission`,
      MODIFY COLUMN `blogs_permission` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `posts_permission`,
      ADD COLUMN `offers_permission` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `market_permission`,
      ADD COLUMN `jobs_permission` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `offers_permission`,
      MODIFY COLUMN `forums_permission` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `jobs_permission`;

    # Changing table posts_products fields
    ALTER TABLE `posts_products`
      ADD COLUMN `is_digital` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `available`,
      ADD COLUMN `product_download_url` TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL  COMMENT '' AFTER `is_digital`,
      ADD COLUMN `product_file_source` VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL  COMMENT '' AFTER `product_download_url`;

    # Changing table users fields
    ALTER TABLE `users`
      ADD COLUMN `email_user_verification` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1'  COMMENT '' AFTER `email_friend_requests`,
      ADD COLUMN `email_user_post_approval` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1'  COMMENT '' AFTER `email_user_verification`,
      ADD COLUMN `email_admin_verifications` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1'  COMMENT '' AFTER `email_user_post_approval`,
      ADD COLUMN `email_admin_post_approval` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1'  COMMENT '' AFTER `email_admin_verifications`,
      MODIFY COLUMN `facebook_connected` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `email_admin_post_approval`,
      ADD COLUMN `user_monetization_chat_price` FLOAT NOT NULL DEFAULT 0  COMMENT '' AFTER `user_monetization_enabled`,
      ADD COLUMN `user_monetization_call_price` FLOAT NOT NULL DEFAULT 0  COMMENT '' AFTER `user_monetization_chat_price`,
      MODIFY COLUMN `user_monetization_min_price` FLOAT NOT NULL DEFAULT 0  COMMENT '' AFTER `user_monetization_call_price`;

    # Changing table posts_offers fields
    ALTER TABLE `posts_offers`
      MODIFY COLUMN `end_date` DATETIME NULL DEFAULT NULL  COMMENT '' AFTER `amount_y`,
      ADD COLUMN `price` FLOAT UNSIGNED NOT NULL DEFAULT 0  COMMENT '' AFTER `end_date`,
      MODIFY COLUMN `thumbnail` VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL  COMMENT '' AFTER `price`;

    # Changing table events fields
    ALTER TABLE `events`
      ADD COLUMN `event_page_id` INT(10) UNSIGNED NULL DEFAULT NULL  COMMENT '' AFTER `event_admin`,
      MODIFY COLUMN `event_category` INT(10) UNSIGNED NOT NULL  COMMENT '' AFTER `event_page_id`,
      ADD COLUMN `event_tickets_link` VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL  COMMENT '' AFTER `chatbox_conversation_id`,
      ADD COLUMN `event_prices` TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL  COMMENT '' AFTER `event_tickets_link`,
      ADD COLUMN `event_rate` FLOAT NOT NULL DEFAULT 0  COMMENT '' AFTER `event_prices`,
      MODIFY COLUMN `event_date` DATETIME NOT NULL  COMMENT '' AFTER `event_rate`;

    # Changing table posts_jobs_applications fields
    ALTER TABLE `posts_jobs_applications`
      ADD COLUMN `cv` VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL  COMMENT '' AFTER `question_3_answer`,
      MODIFY COLUMN `applied_time` DATETIME NOT NULL  COMMENT '' AFTER `cv`;

    # Changing table reviews fields, indexes
    ALTER TABLE `reviews`
      ADD COLUMN `node_id` INT(10) UNSIGNED NOT NULL  COMMENT '' AFTER `review_id`,
      ADD COLUMN `node_type` VARCHAR(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL  COMMENT '' AFTER `node_id`,
      MODIFY COLUMN `user_id` INT(10) UNSIGNED NOT NULL  COMMENT '' AFTER `node_type`,
      DROP COLUMN `page_id`,
      DROP INDEX `page_id`,
      ADD INDEX `page_id` USING BTREE (node_id);

    # Changing table system_countries fields
    ALTER TABLE `system_countries`
      ADD COLUMN `country_vat` INT(10) UNSIGNED NULL DEFAULT NULL  COMMENT '' AFTER `phone_code`,
      MODIFY COLUMN `default` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL  COMMENT '' AFTER `country_vat`;

    # Changing table posts fields
    ALTER TABLE `posts`
      ADD COLUMN `for_adult` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `is_hidden`,
      MODIFY COLUMN `is_anonymous` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `for_adult`,
      ADD COLUMN `post_rate` FLOAT NOT NULL DEFAULT 0  COMMENT '' AFTER `views`,
      MODIFY COLUMN `points_earned` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `post_rate`,
      MODIFY COLUMN `tips_enabled` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `points_earned`,
      MODIFY COLUMN `processing` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `paid_text`,
      ADD COLUMN `pre_approved` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1'  COMMENT '' AFTER `processing`,
      ADD COLUMN `has_approved` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `pre_approved`;

    # Changing table orders fields
    ALTER TABLE `orders`
      ADD COLUMN `is_digital` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `order_hash`,
      MODIFY COLUMN `seller_id` INT(10) UNSIGNED NOT NULL  COMMENT '' AFTER `is_digital`;

    # Changing table verification_requests indexes
    ALTER TABLE `verification_requests`
      DROP INDEX `node_id_node_type`;
    
    COMMIT;
      
	";
  $db->multi_query($structure) or _error("Error", $db->error);


  // flush multi_queries
  do {
  } while (mysqli_more_results($db) && mysqli_next_result($db));


  // update notifications table
  $db->query("UPDATE notifications SET action = 'job_application' WHERE action = 'page_job_application'") or _error("Error", $db->error);
  $db->query("UPDATE notifications SET action = 'page_review_reply' WHERE action = 'review_reply'") or _error("Error", $db->error);


  // update permissions_groups table (update posts_permission, offers_permission, jobs_permission)
  $db->query("UPDATE permissions_groups SET posts_permission = '1', offers_permission = '1', jobs_permission = '1'") or _error("Error", $db->error);


  // update reviews table (set node_type = page)
  $db->query("UPDATE reviews SET node_type = 'page'") or _error("Error", $db->error);


  // update reviews_replacement_enabled to pages_reviews_replacement_enabled & reviews_enabled to pages_reviews_enabled
  $db->query("UPDATE system_options SET option_name = 'pages_reviews_enabled' WHERE option_name = 'reviews_enabled'") or _error("Error", $db->error);
  $db->query("UPDATE system_options SET option_name = 'pages_reviews_replacement_enabled' WHERE option_name = 'reviews_replacement_enabled'") or _error("Error", $db->error);


  // insert new system options
  $db->query("INSERT INTO system_options (option_name, option_value) VALUES
      ('pages_events_enabled', '1'),
      ('verification_for_monetization', '0'),
      ('verification_for_adult_content', '0'),
      ('adult_mode', '1'),
      ('payment_vat_enabled', '0'),
      ('payment_country_vat_enabled', '1'),
      ('payment_vat_percentage', '20'),
      ('payment_fees_enabled', '1'),
      ('payment_fees_percentage', '1'),
      ('watermark_videos_enabled', '0'),
      ('watermark_videos_icon', ''),
      ('watermark_videos_position', 'center'),
      ('watermark_videos_opacity', '0.5'),
      ('watermark_videos_xoffset', '10'),
      ('watermark_videos_yoffset', '10'),
      ('posts_approval_enabled', '0'),
      ('posts_approval_limit', '5'),
      ('verification_for_posts', '0'),
      ('email_admin_verifications', '0'),
      ('email_admin_post_approval', '0'),
      ('email_user_verification', '0'),
      ('email_user_post_approval', '0'),
      ('posts_views_type', 'unique'),
      ('market_shopping_cart_enabled', '1'),
      ('groups_reviews_enabled', '0'),
      ('groups_reviews_replacement_enabled', '0'),
      ('events_reviews_enabled', '0'),
      ('events_reviews_replacement_enabled', '0'),
      ('posts_reviews_enabled', '0'),
      ('posts_reviews_replacement_enabled', '0'),
      ('landing_page_template', 'default')
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