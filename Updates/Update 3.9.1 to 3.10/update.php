<?php

/**
 * update wizard
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich
 */

// set execution time
set_time_limit(0); /* unlimited max execution time */


// set ABSPATH & BASEPATH
define('ABSPATH', __DIR__ . '/');
define('BASEPATH', dirname($_SERVER['PHP_SELF']));


// get system version & exceptions
define('SYS_UPDATE_VER', '3.10');
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

    CREATE TABLE `market_payments` (
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

    CREATE TABLE `orders` (
      `order_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
      `order_hash` varchar(128) NOT NULL,
      `seller_id` int(10) unsigned NOT NULL,
      `buyer_id` int(10) unsigned NOT NULL,
      `buyer_address_id` int(10) unsigned NOT NULL,
      `sub_total` float unsigned NOT NULL DEFAULT '0',
      `commission` float unsigned NOT NULL,
      `status` enum('placed','canceled','accepted','packed','shipped','delivered') NOT NULL DEFAULT 'placed',
      `tracking_link` text,
      `tracking_number` text,
      `insert_time` datetime NOT NULL,
      `update_time` datetime NOT NULL,
      PRIMARY KEY (`order_id`),
      KEY `seller_id` (`seller_id`) USING BTREE,
      KEY `buyer_id` (`buyer_id`) USING BTREE,
      KEY `buyer_address_id` (`buyer_address_id`) USING BTREE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8;

    CREATE TABLE `orders_items` (
      `id` int(10) NOT NULL AUTO_INCREMENT,
      `order_id` int(10) unsigned NOT NULL,
      `product_post_id` int(10) unsigned NOT NULL,
      `quantity` int(10) unsigned NOT NULL,
      `price` float unsigned NOT NULL,
      PRIMARY KEY (`id`),
      KEY `product_post_id` (`product_post_id`) USING BTREE,
      KEY `order_id` (`order_id`) USING BTREE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8;

    CREATE TABLE `users_addresses` (
      `address_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
      `user_id` int(10) unsigned NOT NULL,
      `address_title` varchar(256) NOT NULL,
      `address_country` varchar(256) NOT NULL,
      `address_city` varchar(256) NOT NULL,
      `address_zip_code` varchar(256) NOT NULL,
      `address_phone` varchar(256) NOT NULL,
      `address_details` text NOT NULL,
      PRIMARY KEY (`address_id`),
      KEY `user_id` (`user_id`) USING BTREE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

    CREATE TABLE `shopping_cart` (
      `id` int(10) NOT NULL AUTO_INCREMENT,
      `user_id` int(10) unsigned NOT NULL,
      `product_post_id` int(10) unsigned NOT NULL,
      `quantity` int(10) unsigned NOT NULL DEFAULT '1',
      PRIMARY KEY (`id`),
      KEY `user_id` (`user_id`) USING BTREE,
      KEY `product_post_id` (`product_post_id`) USING BTREE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8;

    CREATE TABLE `users_sms` (
      `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
      `phone` varchar(256) NOT NULL,
      `insert_date` datetime NOT NULL,
      PRIMARY KEY (`id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

    CREATE TABLE `users_top_friends` (
      `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
      `user_id` int(10) unsigned NOT NULL,
      `friend_id` int(10) unsigned NOT NULL,
      PRIMARY KEY (`id`),
      UNIQUE KEY `user_id_friend_id` (`user_id`,`friend_id`) USING BTREE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

    # Changing table followings indexes
    ALTER TABLE `followings`
      ADD INDEX `user_id` USING BTREE (user_id),
      ADD INDEX `following_id` USING BTREE (following_id);

    # Changing table groups indexes
    ALTER TABLE `groups`
      ADD INDEX `group_date` USING BTREE (group_date);

    # Changing table friends indexes
    ALTER TABLE `friends`
      ADD INDEX `user_one_id` USING BTREE (user_one_id),
      ADD INDEX `status` USING BTREE (status),
      ADD INDEX `user_two_id` USING BTREE (user_two_id);

    # Changing table system_reactions fields
    ALTER TABLE `system_reactions`
      ADD COLUMN `enabled` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1'  COMMENT '' AFTER `reaction_order`;

    # Changing table posts_photos fields
    ALTER TABLE `posts_photos`
      ADD COLUMN `pinned` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `blur`,
      MODIFY COLUMN `reaction_like_count` INT(10) UNSIGNED NOT NULL DEFAULT 0  COMMENT '' AFTER `pinned`;

    # Changing table verification_requests fields
    ALTER TABLE `verification_requests`
      ADD COLUMN `business_website` TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL  COMMENT '' AFTER `passport`,
      ADD COLUMN `business_address` TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL  COMMENT '' AFTER `business_website`,
      MODIFY COLUMN `message` TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL  COMMENT '' AFTER `business_address`;

    # Changing table users fields, indexes
    ALTER TABLE `users`
      ADD COLUMN `user_newsletter_enabled` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1'  COMMENT '' AFTER `user_chat_enabled`,
      ADD COLUMN `user_tips_enabled` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1'  COMMENT '' AFTER `user_newsletter_enabled`,
      MODIFY COLUMN `user_privacy_poke` ENUM('me','friends','public') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'public'  COMMENT '' AFTER `user_tips_enabled`,
      ADD COLUMN `Delus_connected` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `wordpress_id`,
      ADD COLUMN `Delus_id` VARCHAR(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL  COMMENT '' AFTER `Delus_connected`,
      MODIFY COLUMN `user_referrer_id` INT(10) NULL DEFAULT NULL  COMMENT '' AFTER `Delus_id`,
      ADD COLUMN `user_market_balance` FLOAT NOT NULL DEFAULT 0  COMMENT '' AFTER `user_affiliate_balance`,
      MODIFY COLUMN `user_funding_balance` FLOAT NOT NULL DEFAULT 0  COMMENT '' AFTER `user_market_balance`,
      DROP COLUMN `user_privacy_newsletter`,
      ADD INDEX `user_subscribed` USING BTREE (user_subscribed),
      ADD INDEX `user_banned` USING BTREE (user_banned),
      ADD INDEX `user_registered` USING BTREE (user_registered);

    # Changing table posts_products fields
    ALTER TABLE `posts_products`
      ADD COLUMN `quantity` INT(10) UNSIGNED NOT NULL DEFAULT 1  COMMENT '' AFTER `currency_id`,
      MODIFY COLUMN `category_id` INT(10) UNSIGNED NOT NULL  COMMENT '' AFTER `quantity`;

    # Changing table posts indexes
    ALTER TABLE `posts`
      ADD INDEX `time` USING BTREE (`time`),
      ADD INDEX `boosted` USING BTREE (boosted);

    # Changing table packages fields
    ALTER TABLE `packages`
      ADD COLUMN `allowed_products` INT(10) NOT NULL DEFAULT 0  COMMENT '' AFTER `allowed_videos_categories`,
      MODIFY COLUMN `verification_badge_enabled` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `allowed_products`;

    # Changing table pages fields, indexes
    ALTER TABLE `pages`
      ADD COLUMN `page_tips_enabled` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `page_verified`,
      MODIFY COLUMN `page_boosted` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `page_tips_enabled`,
      ADD INDEX `page_date` USING BTREE (page_date),
      ADD INDEX `page_boosted` USING BTREE (page_boosted);

    # Changing table events indexes
    ALTER TABLE `events`
      ADD INDEX `event_date` USING BTREE (event_date);
      
    COMMIT;
      
	";
  $db->multi_query($structure) or _error("Error", $db->error);


  // flush multi_queries
  do {
  } while (mysqli_more_results($db) && mysqli_next_result($db));


  // insert new system options
  $db->query("INSERT INTO system_options (option_name, option_value) VALUES
        ('Delus_login_enabled', '0'),
        ('Delus_appid', ''),
        ('Delus_secret', ''),
        ('Delus_app_name', ''),
        ('Delus_app_icon', ''),
        ('market_money_withdraw_enabled', '0'),
        ('market_payment_method', ''),
        ('market_payment_method_custom', ''),
        ('market_min_withdrawal', '50'),
        ('market_money_transfer_enabled', '0'),
        ('market_commission', '10'),
        ('sms_limit', '3'),
        ('switch_accounts_enabled', '1'),
        ('wallet_max_transfer', '100')
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