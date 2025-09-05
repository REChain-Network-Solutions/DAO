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
define('SYS_UPDATE_VER', '3.11');
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

    CREATE TABLE `posts_paid` (
      `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
      `post_id` int(10) unsigned NOT NULL,
      `user_id` int(10) unsigned NOT NULL,
      `time` datetime NOT NULL,
      PRIMARY KEY (`id`),
      UNIQUE KEY `post_id_user_id` (`post_id`,`user_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

    CREATE TABLE `reviews` (
      `review_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
      `page_id` int(10) unsigned NOT NULL,
      `user_id` int(10) unsigned NOT NULL,
      `rate` smallint(1) NOT NULL,
      `review` text NOT NULL,
      `reply` text,
      `time` datetime NOT NULL,
      PRIMARY KEY (`review_id`),
      KEY `user_id` (`user_id`),
      KEY `page_id` (`page_id`) USING BTREE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

    CREATE TABLE `sneak_peaks` (
      `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
      `user_id` int(10) unsigned NOT NULL,
      `node_id` int(10) unsigned NOT NULL,
      `node_type` varchar(32) NOT NULL,
      `time` datetime NOT NULL,
      PRIMARY KEY (`id`),
      UNIQUE KEY `user_id_node_id_node_type` (`user_id`,`node_id`,`node_type`) USING BTREE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

    CREATE TABLE `reviews_photos` (
      `photo_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
      `review_id` int(10) unsigned NOT NULL,
      `source` varchar(256) NOT NULL,
      PRIMARY KEY (`photo_id`),
      KEY `review_id` (`review_id`) USING BTREE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

    CREATE TABLE `users_recurring_payments` (
      `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
      `user_id` int(10) unsigned NOT NULL,
      `payment_gateway` varchar(256) NOT NULL,
      `handle` varchar(256) NOT NULL,
      `handle_id` int(10) unsigned NOT NULL,
      `subscription_id` varchar(256) NOT NULL,
      `time` datetime NOT NULL,
      PRIMARY KEY (`id`),
      KEY `user_id` (`user_id`) USING BTREE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

    # Changing table users fields, indexes
    ALTER TABLE `users`
      ADD COLUMN `user_privacy_subscriptions` ENUM('me','friends','public') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'public'  COMMENT '' AFTER `user_privacy_events`,
      MODIFY COLUMN `email_post_likes` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1'  COMMENT '' AFTER `user_privacy_subscriptions`,
      ADD COLUMN `user_monetization_plans` INT(10) UNSIGNED NOT NULL DEFAULT 0  COMMENT '' AFTER `user_monetization_min_price`,
      MODIFY COLUMN `user_monetization_balance` FLOAT NOT NULL DEFAULT 0  COMMENT '' AFTER `user_monetization_plans`,
      ADD INDEX `user_lastname_idx` USING BTREE (user_lastname),
      ADD INDEX `user_firstname_idx` USING BTREE (user_firstname),
      ADD INDEX `user_name_idx` USING BTREE (user_name),
      ADD INDEX `user_id_idx` USING BTREE (user_id);

    # Changing table posts fields
    ALTER TABLE `posts`
      ADD COLUMN `for_subscriptions` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `tips_enabled`,
      ADD COLUMN `is_paid` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `for_subscriptions`,
      ADD COLUMN `post_price` FLOAT UNSIGNED NOT NULL DEFAULT 0  COMMENT '' AFTER `is_paid`,
      ADD COLUMN `paid_text` TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL  COMMENT '' AFTER `post_price`;

    # Changing table monetization_plans fields
    ALTER TABLE `monetization_plans`
      ADD COLUMN `paypal_billing_plan` VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL  COMMENT '' AFTER `plan_order`,
      ADD COLUMN `stripe_billing_plan` VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL  COMMENT '' AFTER `paypal_billing_plan`;

    # Changing table events fields, indexes
    ALTER TABLE `events`
      ADD COLUMN `chatbox_enabled` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `event_going`,
      ADD COLUMN `chatbox_conversation_id` INT(10) UNSIGNED NULL DEFAULT NULL  COMMENT '' AFTER `chatbox_enabled`,
      MODIFY COLUMN `event_date` DATETIME NOT NULL  COMMENT '' AFTER `chatbox_conversation_id`,
      ADD INDEX `event_title_idx` USING BTREE (event_title);

    # Changing table conversations fields
    ALTER TABLE `conversations`
      ADD COLUMN `node_id` INT(10) UNSIGNED NULL DEFAULT NULL  COMMENT '' AFTER `color`,
      ADD COLUMN `node_type` VARCHAR(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL  COMMENT '' AFTER `node_id`;

    # Changing table packages fields
    ALTER TABLE `packages`
      ADD COLUMN `paypal_billing_plan` VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL  COMMENT '' AFTER `package_order`,
      ADD COLUMN `stripe_billing_plan` VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL  COMMENT '' AFTER `paypal_billing_plan`;

    # Changing table posts_articles fields, indexes
    ALTER TABLE `posts_articles`
      MODIFY COLUMN `text` TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL  COMMENT '' AFTER `title`,
      MODIFY COLUMN `tags` TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL  COMMENT '' AFTER `category_id`,
      ADD INDEX `title_idx` USING BTREE (title);

    # Changing table groups fields, indexes
    ALTER TABLE `groups`
      ADD COLUMN `group_monetization_plans` INT(10) UNSIGNED NOT NULL DEFAULT 0  COMMENT '' AFTER `group_monetization_min_price`,
      ADD COLUMN `chatbox_enabled` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `group_monetization_plans`,
      ADD COLUMN `chatbox_conversation_id` INT(10) UNSIGNED NULL DEFAULT NULL  COMMENT '' AFTER `chatbox_enabled`,
      MODIFY COLUMN `group_date` DATETIME NOT NULL  COMMENT '' AFTER `chatbox_conversation_id`,
      ADD INDEX `group_name_idx` USING BTREE (group_name),
      ADD INDEX `group_title_idx` USING BTREE (group_title);

    # Changing table pages fields, indexes
    ALTER TABLE `pages`
      ADD COLUMN `page_monetization_plans` INT(10) UNSIGNED NOT NULL DEFAULT 0  COMMENT '' AFTER `page_monetization_min_price`,
      ADD COLUMN `page_rate` FLOAT NOT NULL DEFAULT 0  COMMENT '' AFTER `page_monetization_plans`,
      MODIFY COLUMN `page_date` DATETIME NOT NULL  COMMENT '' AFTER `page_rate`,
      ADD INDEX `page_name_idx` USING BTREE (page_name),
      ADD INDEX `page_title_idx` USING BTREE (page_title);

    # Changing table emojis fields
    ALTER TABLE `emojis`
      MODIFY COLUMN `class` VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL  COMMENT '' AFTER `unicode_char`,
      DROP COLUMN `pattern`;

    # Changing table posts_products fields, indexes
    ALTER TABLE `posts_products`
      MODIFY COLUMN `quantity` INT(10) UNSIGNED NOT NULL DEFAULT 1  COMMENT '' AFTER `price`,
      DROP COLUMN `currency_id`,
      DROP INDEX `currency_id`;
    
    COMMIT;
      
	";
  $db->multi_query($structure) or _error("Error", $db->error);


  // flush multi_queries
  do {
  } while (mysqli_more_results($db) && mysqli_next_result($db));


  // update users table (count user_monetization_plans from monetization_plans table)
  $db->query("UPDATE users SET user_monetization_plans = (SELECT COUNT(*) FROM monetization_plans WHERE node_type = 'profile' AND node_id = users.user_id)") or _error("Error", $db->error);


  // update groups table (count group_monetization_plans from monetization_plans table)
  $db->query("UPDATE `groups` SET group_monetization_plans = (SELECT COUNT(*) FROM monetization_plans WHERE node_type = 'group' AND node_id = `groups`.group_id)") or _error("Error", $db->error);


  // update pages table (count page_monetization_plans from monetization_plans table)
  $db->query("UPDATE pages SET page_monetization_plans = (SELECT COUNT(*) FROM monetization_plans WHERE node_type = 'page' AND node_id = pages.page_id)") or _error("Error", $db->error);


  // insert new system options
  $db->query("INSERT INTO system_options (option_name, option_value) VALUES
        ('paypal_webhook', ''),
        ('reviews_enabled', '1'),
        ('reviews_replacement_enabled', '1'),
        ('genders_disabled', '0'),
        ('stripe_webhook', ''),
        ('ffmpeg_240p_enabled', ''),
        ('ffmpeg_360p_enabled', ''),
        ('ffmpeg_480p_enabled', ''),
        ('ffmpeg_720p_enabled', ''),
        ('ffmpeg_1080p_enabled', ''),
        ('ffmpeg_1440p_enabled', ''),
        ('ffmpeg_2160p_enabled', ''),
        ('fluid_videos_enabled', '')
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