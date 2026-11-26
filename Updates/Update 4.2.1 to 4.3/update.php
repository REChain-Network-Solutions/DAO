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
  <title><?php echo SYS_NAME ?> &rsaquo; Update (v<?php echo SYS_UPDATE_VER ?>)</title>
  <link rel="icon" type="image/png" href="content/themes/nova/images/favicon.png">
  <style>
    :root {
      --bg: #eef1f8;
      --card: #ffffff;
      --text: #1b2130;
      --muted: #6b7488;
      --line: #e7eaf2;
      --field: #f6f7fb;
      --accent: #5e72e4;
      --accent-2: #825ee4;
      --ok: #2dce89;
      --err: #f5365c;
      --shadow: 0 24px 60px -20px rgba(38, 47, 84, .35);
      --radius: 16px;
    }

    @media (prefers-color-scheme: dark) {
      :root {
        --bg: #0e1220;
        --card: #171d2e;
        --text: #e8ebf5;
        --muted: #9099b0;
        --line: #262d42;
        --field: #11172a;
        --shadow: 0 24px 60px -20px rgba(0, 0, 0, .6);
      }
    }

    * {
      box-sizing: border-box;
    }

    html {
      height: 100%;
    }

    body {
      margin: 0;
      font-family: system-ui, -apple-system, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
      color: var(--text);
      background: var(--bg);
      min-height: 100%;
      padding: 40px 16px;
      position: relative;
      overflow-x: hidden;
    }

    body::before {
      content: "";
      position: absolute;
      inset: 0 0 auto;
      height: 620px;
      z-index: 0;
      pointer-events: none;
      background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='45.033' height='78' viewBox='0 0 45.033 78'%3E%3Cg fill='none' stroke='%235e72e4' stroke-opacity='0.14' stroke-width='1'%3E%3Cpath d='M22.517 -26L45.034 -13L45.034 13L22.517 26L0 13L0 -13Z'/%3E%3Cpath d='M0 13L22.517 26L22.517 52L0 65L-22.517 52L-22.517 26Z'/%3E%3Cpath d='M45.033 13L67.55 26L67.55 52L45.033 65L22.516 52L22.516 26Z'/%3E%3Cpath d='M22.517 52L45.034 65L45.034 91L22.517 104L0 91L0 65Z'/%3E%3C/g%3E%3C/svg%3E");
      background-position: top center;
      -webkit-mask-image: linear-gradient(to bottom, #000 0%, #000 28%, transparent 82%);
      mask-image: linear-gradient(to bottom, #000 0%, #000 28%, transparent 82%);
    }

    @media (prefers-color-scheme: dark) {
      body::before {
        background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='45.033' height='78' viewBox='0 0 45.033 78'%3E%3Cg fill='none' stroke='%23a5b4fc' stroke-opacity='0.10' stroke-width='1'%3E%3Cpath d='M22.517 -26L45.034 -13L45.034 13L22.517 26L0 13L0 -13Z'/%3E%3Cpath d='M0 13L22.517 26L22.517 52L0 65L-22.517 52L-22.517 26Z'/%3E%3Cpath d='M45.033 13L67.55 26L67.55 52L45.033 65L22.516 52L22.516 26Z'/%3E%3Cpath d='M22.517 52L45.034 65L45.034 91L22.517 104L0 91L0 65Z'/%3E%3C/g%3E%3C/svg%3E");
      }
    }

    .installer {
      position: relative;
      z-index: 1;
      width: 100%;
      max-width: 560px;
      margin: 0 auto 40px;
      background: var(--card);
      border: 1px solid var(--line);
      border-radius: var(--radius);
      box-shadow: var(--shadow);
      overflow: hidden;
    }

    .hd {
      display: flex;
      align-items: center;
      gap: 14px;
      padding: 24px 28px;
      border-bottom: 1px solid var(--line);
    }

    .hd img {
      width: 42px;
      height: 42px;
      border-radius: 10px;
    }

    .hd h1 {
      font-size: 19px;
      margin: 0;
      letter-spacing: -.2px;
    }

    .hd .ver {
      font-size: 12.5px;
      color: var(--muted);
    }

    form {
      padding: 22px 28px 28px;
    }

    h2 {
      font-size: 17px;
      margin: 0 0 6px;
      letter-spacing: -.2px;
    }

    p {
      color: var(--muted);
      font-size: 14px;
      line-height: 1.6;
      margin: 0 0 16px;
    }

    .alert {
      display: none;
      margin: 0 0 16px;
      padding: 12px 14px;
      border-radius: 10px;
      font-size: 13.5px;
      background: rgba(245, 54, 92, .12);
      color: var(--err);
      border: 1px solid rgba(245, 54, 92, .25);
    }

    .alert.show {
      display: block;
    }

    .box {
      background: var(--field);
      border: 1px solid var(--line);
      border-radius: 12px;
      padding: 14px 16px;
      margin-bottom: 18px;
    }

    .box strong {
      font-size: 13px;
    }

    .box ul {
      margin: 10px 0 0;
      padding: 0;
      list-style: none;
    }

    .box li {
      display: flex;
      align-items: flex-start;
      gap: 9px;
      font-size: 13px;
      color: var(--muted);
      margin: 7px 0;
      line-height: 1.5;
    }

    .box li svg {
      width: 16px;
      height: 16px;
      flex: none;
      margin-top: 2px;
      color: var(--ok);
    }

    .field label {
      display: block;
      font-size: 13px;
      font-weight: 600;
      margin-bottom: 6px;
    }

    .field input {
      width: 100%;
      padding: 12px 14px;
      border-radius: 10px;
      border: 1px solid var(--line);
      background: var(--field);
      color: var(--text);
      font-size: 14px;
      transition: border-color .15s, box-shadow .15s;
    }

    .field input:focus {
      outline: none;
      border-color: var(--accent);
      box-shadow: 0 0 0 3px rgba(94, 114, 228, .18);
    }

    .field input.invalid {
      border-color: var(--err);
      box-shadow: 0 0 0 3px rgba(245, 54, 92, .15);
    }

    .agree {
      display: flex;
      align-items: center;
      gap: 10px;
      margin-top: 18px;
      cursor: pointer;
      user-select: none;
      font-size: 14px;
    }

    .agree input {
      width: 18px;
      height: 18px;
      accent-color: var(--accent);
    }

    .foot {
      margin-top: 24px;
      padding-top: 20px;
      border-top: 1px solid var(--line);
    }

    .btn {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 10px;
      width: 100%;
      border: none;
      border-radius: 10px;
      padding: 13px 22px;
      font-size: 14px;
      font-weight: 600;
      font-family: inherit;
      color: #fff;
      cursor: pointer;
      background: linear-gradient(135deg, var(--accent), var(--accent-2));
      box-shadow: 0 10px 22px -10px var(--accent);
      transition: .15s;
    }

    .btn:hover {
      filter: brightness(1.06);
    }

    .btn:disabled {
      opacity: .7;
      cursor: wait;
    }

    .spin {
      display: none;
      width: 14px;
      height: 14px;
      border: 2px solid rgba(255, 255, 255, .45);
      border-top-color: #fff;
      border-radius: 50%;
      animation: sp .6s linear infinite;
    }

    .btn:disabled .spin {
      display: inline-block;
    }

    @keyframes sp {
      to {
        transform: rotate(360deg);
      }
    }
  </style>
</head>

<body>
  <div class="installer">
    <div class="hd">
      <img src="content/themes/nova/images/favicon.png" alt="">
      <div>
        <h1><?php echo SYS_NAME ?> Update</h1>
        <div class="ver">Version <?php echo SYS_UPDATE_VER ?></div>
      </div>
    </div>

    <form id="wizard" method="post" novalidate>
      <div class="alert" id="alert"></div>

      <h2>Welcome</h2>
      <p>Welcome to the <strong><?php echo SYS_NAME ?></strong> update process. This wizard will bring your installation up to <strong>version <?php echo SYS_UPDATE_VER ?></strong>.</p>

      <div class="box">
        <strong>Before you continue</strong>
        <ul>
          <li><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
              <path d="M20 6L9 17l-5-5" />
            </svg>Make a full backup of your files and database.</li>
          <li><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
              <path d="M20 6L9 17l-5-5" />
            </svg>Ensure you have replaced the old files with the new release.</li>
          <li><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
              <path d="M20 6L9 17l-5-5" />
            </svg>Don't close this window while the update is running.</li>
        </ul>
      </div>

      <div class="field">
        <label for="purchase_code">Purchase Code</label>
        <input type="text" name="purchase_code" id="purchase_code" placeholder="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx">
      </div>

      <label class="agree">
        <input type="checkbox" id="backup-checkbox">
        <span>I have backed up my data and I'm ready to update.</span>
      </label>

      <div class="foot">
        <input type="hidden" name="submit" value="1">
        <button type="submit" class="btn" id="btn-update"><span class="spin"></span><span id="btn-label">Update</span></button>
      </div>
    </form>
  </div>

  <script>
    (function() {
      // initialize variables
      var form = document.getElementById('wizard');
      var code = document.getElementById('purchase_code');
      var backup = document.getElementById('backup-checkbox');
      var alertBox = document.getElementById('alert');
      var btn = document.getElementById('btn-update');


      // helper functions
      /* show alert */
      function showAlert(msg) {
        alertBox.textContent = msg;
        alertBox.classList.add('show');
      }


      // event listeners
      /* input change */
      code.addEventListener('input', function() {
        code.classList.remove('invalid');
      });
      /* submit */
      form.addEventListener('submit', function(e) {
        alertBox.classList.remove('show');
        if (!code.value.trim()) {
          e.preventDefault();
          code.classList.add('invalid');
          showAlert('Please enter a valid purchase code');
          return;
        }
        if (!backup.checked) {
          e.preventDefault();
          showAlert('Please confirm you have backed up your data before continuing.');
          return;
        }
        setTimeout(function() {
          btn.disabled = true;
          document.getElementById('btn-label').textContent = 'Updating...';
        }, 0);
      });
    })();
  </script>
</body>

</html>
