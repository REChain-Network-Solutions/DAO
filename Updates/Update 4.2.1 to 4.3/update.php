<?php

/**
 * update wizard
 * 
 * @package Sngine
 * @author Zamblek
 */

// set execution time
set_time_limit(0); /* unlimited max execution time */


// set ABSPATH
define('ABSPATH', __DIR__ . '/');


// get system version & exceptions
define('SYS_UPDATE_VER', '4.3');
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

    CREATE TABLE `monetization_coupons` (
      `coupon_id` int unsigned NOT NULL AUTO_INCREMENT,
      `coupon_code` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
      `discount_percent` float unsigned NOT NULL,
      `is_onetime` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
      `node_id` int unsigned NOT NULL,
      `node_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `created_date` datetime NOT NULL,
      `used` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `usage_counter` int unsigned NOT NULL DEFAULT '0',
      PRIMARY KEY (`coupon_id`),
      KEY `coupon_code` (`coupon_code`) USING BTREE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

    CREATE TABLE `posts_articles_references` (
      `refrence_id` int unsigned NOT NULL AUTO_INCREMENT,
      `post_id` int unsigned NOT NULL,
      `title` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `link` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      PRIMARY KEY (`refrence_id`),
      KEY `post_id` (`post_id`),
      KEY `title_idx` (`title`) USING BTREE,
      FULLTEXT KEY `ft_title` (`title`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    CREATE TABLE `posts_collaborative_users` (
      `id` int unsigned NOT NULL AUTO_INCREMENT,
      `post_id` int unsigned NOT NULL,
      `user_id` int unsigned NOT NULL,
      PRIMARY KEY (`id`),
      UNIQUE KEY `post_id_user_id` (`post_id`,`user_id`) USING BTREE,
      KEY `user_post` (`user_id`,`post_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    CREATE TABLE `monetization_coupons_users` (
      `id` int unsigned NOT NULL AUTO_INCREMENT,
      `user_id` int unsigned NOT NULL,
      `coupon_id` int unsigned NOT NULL,
      `used_date` datetime DEFAULT NULL,
      PRIMARY KEY (`id`),
      UNIQUE KEY `user_id_coupon_id` (`user_id`,`coupon_id`) USING BTREE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

    # Changing table log_subscriptions fields
    ALTER TABLE `log_subscriptions`
      MODIFY COLUMN `payment_id` INT UNSIGNED NOT NULL auto_increment COMMENT '' FIRST;

    # Changing table pages fields
    ALTER TABLE `pages`
      ADD COLUMN `page_monetization_discount_enabled` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '' AFTER `page_monetization_enabled`,
      ADD COLUMN `page_monetization_discount_percent` FLOAT NOT NULL DEFAULT 0 COMMENT '' AFTER `page_monetization_discount_enabled`,
      MODIFY COLUMN `page_monetization_min_price` FLOAT NOT NULL DEFAULT 0 COMMENT '' AFTER `page_monetization_discount_percent`;

    # Changing table market_payments fields
    ALTER TABLE `market_payments`
      MODIFY COLUMN `payment_id` INT UNSIGNED NOT NULL auto_increment COMMENT '' FIRST;

    # Changing table ads_system fields
    ALTER TABLE `ads_system`
      MODIFY COLUMN `ads_id` INT UNSIGNED NOT NULL auto_increment COMMENT '' FIRST;

    # Changing table bank_transfers fields
    ALTER TABLE `bank_transfers`
      ADD COLUMN `total` FLOAT NULL DEFAULT NULL COMMENT '' AFTER `price`,
      MODIFY COLUMN `bank_receipt` VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '' AFTER `total`;

    # Changing table affiliates_payments fields
    ALTER TABLE `affiliates_payments`
      MODIFY COLUMN `payment_id` INT UNSIGNED NOT NULL auto_increment COMMENT '' FIRST;

    # Changing table invitation_codes indexes
    ALTER TABLE `invitation_codes`
      ADD INDEX `code` USING BTREE (code);

    # Changing table orders_items fields
    ALTER TABLE `orders_items`
      MODIFY COLUMN `id` INT UNSIGNED NOT NULL auto_increment COMMENT '' FIRST;

    # Changing table log_commissions fields
    ALTER TABLE `log_commissions`
      MODIFY COLUMN `payment_id` INT UNSIGNED NOT NULL auto_increment COMMENT '' FIRST;

    # Changing table users fields
    ALTER TABLE `users`
      ADD COLUMN `user_privacy_collaborative` ENUM('me','friends','public') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'me' COMMENT '' AFTER `user_privacy_wall`,
      MODIFY COLUMN `user_privacy_gender` ENUM('me','friends','public') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'public' COMMENT '' AFTER `user_privacy_collaborative`,
      ADD COLUMN `user_monetization_discount_enabled` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '' AFTER `user_monetization_enabled`,
      ADD COLUMN `user_monetization_discount_percent` FLOAT NOT NULL DEFAULT 0 COMMENT '' AFTER `user_monetization_discount_enabled`,
      MODIFY COLUMN `user_monetization_chat_price` FLOAT NOT NULL DEFAULT 0 COMMENT '' AFTER `user_monetization_discount_percent`,
      ADD COLUMN `user_ai_credits_balance` INT NOT NULL DEFAULT 0 COMMENT '' AFTER `user_monetization_balance`,
      MODIFY COLUMN `chat_sound` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1' COMMENT '' AFTER `user_ai_credits_balance`;

    # Changing table announcements fields
    ALTER TABLE `announcements`
      MODIFY COLUMN `announcement_id` INT UNSIGNED NOT NULL auto_increment COMMENT '' FIRST;

    # Changing table points_payments fields
    ALTER TABLE `points_payments`
      MODIFY COLUMN `payment_id` INT UNSIGNED NOT NULL auto_increment COMMENT '' FIRST;

    # Changing table users_uploads_pending fields
    ALTER TABLE `users_uploads_pending`
      MODIFY COLUMN `id` INT UNSIGNED NOT NULL auto_increment COMMENT '' FIRST;

    # Changing table monetization_plans fields
    ALTER TABLE `monetization_plans`
      MODIFY COLUMN `plan_id` INT UNSIGNED NOT NULL auto_increment COMMENT '' FIRST;

    # Changing table users_uploads fields
    ALTER TABLE `users_uploads`
      MODIFY COLUMN `id` INT UNSIGNED NOT NULL auto_increment COMMENT '' FIRST;

    # Changing table wallet_transactions fields
    ALTER TABLE `wallet_transactions`
      MODIFY COLUMN `transaction_id` INT UNSIGNED NOT NULL auto_increment COMMENT '' FIRST;

    # Changing table games fields
    ALTER TABLE `games`
      MODIFY COLUMN `game_id` INT UNSIGNED NOT NULL auto_increment COMMENT '' FIRST;

    # Changing table log_payments fields
    ALTER TABLE `log_payments`
      MODIFY COLUMN `payment_id` INT UNSIGNED NOT NULL auto_increment COMMENT '' FIRST;

    # Changing table ads_campaigns fields
    ALTER TABLE `ads_campaigns`
      MODIFY COLUMN `campaign_id` INT UNSIGNED NOT NULL auto_increment COMMENT '' FIRST;

    # Changing table packages fields
    ALTER TABLE `packages`
      MODIFY COLUMN `package_id` INT UNSIGNED NOT NULL auto_increment COMMENT '' FIRST;

    # Changing table posts fields
    ALTER TABLE `posts`
      ADD COLUMN `is_collaborative` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '' AFTER `wall_id`,
      ADD COLUMN `collaborative_percent` FLOAT UNSIGNED NOT NULL DEFAULT 0 COMMENT '' AFTER `is_collaborative`,
      MODIFY COLUMN `post_type` VARCHAR(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '' AFTER `collaborative_percent`;

    # Changing table permissions_groups fields
    ALTER TABLE `permissions_groups`
      ADD COLUMN `ai_posts_permission` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '' AFTER `gifts_permission`,
      ADD COLUMN `ai_blogs_permission` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '' AFTER `ai_posts_permission`,
      ADD COLUMN `ai_images_permission` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '' AFTER `ai_blogs_permission`,
      MODIFY COLUMN `stories_permission` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '' AFTER `ai_images_permission`,
      MODIFY COLUMN `anonymous_posts_permission` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '' AFTER `schedule_posts_permission`,
      ADD COLUMN `collaborative_posts_permission` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '' AFTER `anonymous_posts_permission`,
      MODIFY COLUMN `colored_posts_permission` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '' AFTER `collaborative_posts_permission`,
      MODIFY COLUMN `invitation_permission` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '' AFTER `gif_posts_permission`;

    # Changing table shopping_cart fields
    ALTER TABLE `shopping_cart`
      MODIFY COLUMN `id` INT UNSIGNED NOT NULL auto_increment COMMENT '' FIRST;

    # Changing table funding_payments fields
    ALTER TABLE `funding_payments`
      MODIFY COLUMN `payment_id` INT UNSIGNED NOT NULL auto_increment COMMENT '' FIRST;

    # Changing table monetization_payments fields
    ALTER TABLE `monetization_payments`
      MODIFY COLUMN `payment_id` INT UNSIGNED NOT NULL auto_increment COMMENT '' FIRST;

    # Changing table groups fields
    ALTER TABLE `groups`
      ADD COLUMN `group_monetization_discount_enabled` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '' AFTER `group_monetization_enabled`,
      ADD COLUMN `group_monetization_discount_percent` FLOAT NOT NULL DEFAULT 0 COMMENT '' AFTER `group_monetization_discount_enabled`,
      MODIFY COLUMN `group_monetization_min_price` FLOAT NOT NULL DEFAULT 0 COMMENT '' AFTER `group_monetization_discount_percent`;

    # Changing table wallet_payments fields
    ALTER TABLE `wallet_payments`
      MODIFY COLUMN `payment_id` INT UNSIGNED NOT NULL auto_increment COMMENT '' FIRST;

    # Changing table packages_payments fields
    ALTER TABLE `packages_payments`
      MODIFY COLUMN `payment_id` INT UNSIGNED NOT NULL auto_increment COMMENT '' FIRST;

    # Changing table log_points fields
    ALTER TABLE `log_points`
      MODIFY COLUMN `log_id` INT UNSIGNED NOT NULL auto_increment COMMENT '' FIRST;

    COMMIT;
      
	";
  $db->multi_query($structure) or _error("Error", $db->error);


  // flush multi_queries
  do {
  } while (mysqli_more_results($db) && mysqli_next_result($db));


  // update users's collaborative posts privacy
  $db->query("UPDATE users SET user_privacy_collaborative = 'public'");


  // update bank transfers table set total = price
  $db->query("UPDATE bank_transfers SET total = price");


  // delete moneypoolscash related options
  $db->query("DELETE FROM system_options WHERE option_name = 'moneypoolscash_enabled'");
  $db->query("DELETE FROM system_options WHERE option_name = 'moneypoolscash_payouts_enabled'");
  $db->query("DELETE FROM system_options WHERE option_name = 'moneypoolscash_api_key'");
  $db->query("DELETE FROM system_options WHERE option_name = 'moneypoolscash_merchant_email'");
  $db->query("DELETE FROM system_options WHERE option_name = 'moneypoolscash_merchant_password'");


  // insert new system options
  $db->query("INSERT INTO system_options (option_name, option_value) VALUES
      ('system_description_watch','Explore the latest videos'),
      
      ('pages_location_filter_enabled','1'),
      ('groups_location_filter_enabled','1'),
      ('events_location_filter_enabled','1'),

      ('collaborative_posts_enabled','1'),
      ('user_privacy_collaborative','public'),
      ('monetization_discounts_enabled','1'),

      ('ai_mode','live'),
      ('ai_posts_enabled','0'),
      ('ai_posts_provider','openai'),
      ('ai_blogs_enabled','0'),
      ('ai_blogs_provider','openai'),
      ('ai_images_enabled','0'),
      ('openai_api_key',''),
      ('openai_text_model',''),
      ('openai_image_model',''),
      ('replicate_api_token',''),
      ('replicate_model',''),
      ('replicate_denoising_steps','1'),
      ('replicate_guidance_scale','1'),
      ('replicate_seed',''),
      ('ai_credit_cost','100'),
      ('ai_text_credit_enabled','1'),
      ('ai_generated_word_cost','10'),
      ('ai_image_credit_enabled','1'),
      ('ai_generated_image_cost','25')
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
  _error("System Updated", "Sngine has been updated to " . SYS_UPDATE_VER);
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
              <div class="bd-wizard-step-subtitle">Sngine (v<?php echo SYS_UPDATE_VER ?>)</div>
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