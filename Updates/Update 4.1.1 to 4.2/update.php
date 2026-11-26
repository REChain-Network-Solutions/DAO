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
