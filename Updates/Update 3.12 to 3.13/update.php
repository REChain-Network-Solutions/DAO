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
define('SYS_UPDATE_VER', '3.13');
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

    CREATE TABLE `activities_permisions_requests` (
      `request_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
      `user_id` int(10) unsigned NOT NULL,
      `page_id` varchar(128) DEFAULT NULL,
      `time` datetime NOT NULL,
      `status` tinyint(1) NOT NULL DEFAULT '0',
      PRIMARY KEY (`request_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

    CREATE TABLE `activities_permissions_users` (
      `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
      `user_id` int(10) unsigned NOT NULL,
      `page_id` int(10) unsigned NOT NULL,
      `permission` enum('viewer','editor') NOT NULL DEFAULT 'viewer',
      PRIMARY KEY (`id`),
      UNIQUE KEY `user_id_blocked_id` (`user_id`,`page_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

    CREATE TABLE `posts_cache` (
      `cache_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
      `cache_date` datetime NOT NULL,
      `post_id` int(10) unsigned NOT NULL,
      `user_id` int(10) unsigned NOT NULL,
      PRIMARY KEY (`cache_id`),
      KEY `user_id` (`user_id`),
      KEY `post_id` (`post_id`) USING BTREE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

    CREATE TABLE `groups_invites` (
      `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
      `group_id` int(10) unsigned NOT NULL,
      `user_id` int(10) unsigned NOT NULL,
      `from_user_id` int(10) unsigned NOT NULL,
      PRIMARY KEY (`id`),
      UNIQUE KEY `page_id_user_id_from_user_id` (`group_id`,`user_id`,`from_user_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

    CREATE TABLE `courses_categories` (
      `category_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
      `category_parent_id` int(10) unsigned NOT NULL,
      `category_name` varchar(256) NOT NULL,
      `category_description` text NOT NULL,
      `category_order` int(10) unsigned NOT NULL DEFAULT '1',
      PRIMARY KEY (`category_id`) USING BTREE,
      KEY `category_parent_id` (`category_parent_id`)
    ) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

    CREATE TABLE `posts_courses_applications` (
      `application_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
      `post_id` int(10) unsigned NOT NULL,
      `user_id` int(10) unsigned NOT NULL,
      `name` varchar(100) NOT NULL,
      `location` varchar(100) NOT NULL,
      `phone` varchar(100) NOT NULL,
      `email` varchar(100) NOT NULL,
      `applied_time` datetime NOT NULL,
      PRIMARY KEY (`application_id`) USING BTREE,
      KEY `post_id` (`post_id`),
      KEY `user_id` (`user_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

    CREATE TABLE `posts_courses` (
      `course_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
      `post_id` int(10) unsigned NOT NULL,
      `category_id` int(10) unsigned NOT NULL,
      `title` varchar(100) NOT NULL,
      `location` varchar(100) NOT NULL,
      `fees` float unsigned NOT NULL,
      `fees_currency` int(10) unsigned NOT NULL,
      `start_date` datetime NOT NULL,
      `end_date` datetime NOT NULL,
      `cover_image` varchar(256) NOT NULL,
      `available` enum('0','1') NOT NULL DEFAULT '1',
      PRIMARY KEY (`course_id`) USING BTREE,
      KEY `post_id` (`post_id`),
      KEY `category_id` (`category_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

    CREATE TABLE `activities` (
      `activity_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
      `page_id` int(10) unsigned NOT NULL,
      `category_id` int(10) unsigned NOT NULL,
      `user_id` int(11) DEFAULT NULL,
      `title` varchar(256) NOT NULL,
      `description` text NOT NULL,
      `follow_date` datetime DEFAULT NULL,
      `follow_message` text,
      `status` enum('created','pending','completed') NOT NULL DEFAULT 'created',
      `created_at` datetime NOT NULL,
      PRIMARY KEY (`activity_id`),
      KEY `post_id` (`page_id`),
      KEY `category_id` (`category_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

    CREATE TABLE `log_points` (
      `log_id` int(10) NOT NULL AUTO_INCREMENT,
      `user_id` int(10) unsigned NOT NULL,
      `node_id` int(10) unsigned NOT NULL,
      `node_type` varchar(128) NOT NULL,
      `points` float NOT NULL,
      `time` datetime NOT NULL,
      PRIMARY KEY (`log_id`) USING BTREE,
      KEY `user_id` (`user_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

    CREATE TABLE `users_uploads` (
      `id` int(11) NOT NULL AUTO_INCREMENT,
      `user_id` int(10) NOT NULL,
      `file_name` varchar(256) NOT NULL,
      `file_size` float NOT NULL,
      `insert_date` datetime NOT NULL,
      PRIMARY KEY (`id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8;

    CREATE TABLE `activities_categories` (
      `category_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
      `category_parent_id` int(10) unsigned NOT NULL,
      `category_name` varchar(256) NOT NULL,
      `category_description` text NOT NULL,
      `category_order` int(10) unsigned NOT NULL DEFAULT '1',
      PRIMARY KEY (`category_id`),
      KEY `category_parent_id` (`category_parent_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

    CREATE TABLE `log_subscriptions` (
      `payment_id` int(10) NOT NULL AUTO_INCREMENT,
      `plan_title` varchar(256) NOT NULL,
      `subscriber_id` int(10) unsigned NOT NULL,
      `node_id` int(10) unsigned NOT NULL,
      `node_type` varchar(32) NOT NULL DEFAULT '',
      `price` float NOT NULL,
      `commission` float NOT NULL,
      `time` datetime NOT NULL,
      PRIMARY KEY (`payment_id`) USING BTREE,
      KEY `user_id` (`node_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

    CREATE TABLE `posts_reels` (
      `reel_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
      `post_id` int(10) unsigned NOT NULL,
      `source` varchar(256) NOT NULL,
      `source_240p` varchar(256) DEFAULT NULL,
      `source_360p` varchar(256) DEFAULT NULL,
      `source_480p` varchar(256) DEFAULT NULL,
      `source_720p` varchar(256) DEFAULT NULL,
      `source_1080p` varchar(256) DEFAULT NULL,
      `source_1440p` varchar(256) DEFAULT NULL,
      `source_2160p` varchar(256) DEFAULT NULL,
      `thumbnail` varchar(256) DEFAULT NULL,
      `views` int(10) NOT NULL DEFAULT '0',
      PRIMARY KEY (`reel_id`),
      KEY `post_id` (`post_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

    # Changing table posts_jobs fields
    ALTER TABLE `posts_jobs`
      ADD COLUMN `salary_minimum_currency` INT(10) UNSIGNED NOT NULL  COMMENT '' AFTER `salary_minimum`,
      MODIFY COLUMN `salary_maximum` FLOAT UNSIGNED NOT NULL  COMMENT '' AFTER `salary_minimum_currency`,
      ADD COLUMN `salary_maximum_currency` INT(10) UNSIGNED NOT NULL  COMMENT '' AFTER `salary_maximum`,
      MODIFY COLUMN `pay_salary_per` VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL  COMMENT '' AFTER `salary_maximum_currency`;

    # Changing table posts fields
    ALTER TABLE `posts`
      ADD COLUMN `subscriptions_image` VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL  COMMENT '' AFTER `for_subscriptions`,
      MODIFY COLUMN `is_paid` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `subscriptions_image`,
      ADD COLUMN `paid_image` VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL  COMMENT '' AFTER `paid_text`,
      MODIFY COLUMN `processing` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `paid_image`,
      ADD COLUMN `post_latitude` VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `has_approved`,
      ADD COLUMN `post_longitude` VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `post_latitude`;

    # Changing table events fields
    ALTER TABLE `events`
      ADD COLUMN `event_country` INT(10) UNSIGNED NOT NULL  COMMENT '' AFTER `event_location`,
      MODIFY COLUMN `event_description` MEDIUMTEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL  COMMENT '' AFTER `event_country`,
      ADD COLUMN `event_is_sponsored` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `event_rate`,
      ADD COLUMN `event_sponsor_name` VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL  COMMENT '' AFTER `event_is_sponsored`,
      ADD COLUMN `event_sponsor_url` VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL  COMMENT '' AFTER `event_sponsor_name`,
      MODIFY COLUMN `event_date` DATETIME NOT NULL  COMMENT '' AFTER `event_sponsor_url`;

    # Changing table groups fields
    ALTER TABLE `groups`
      ADD COLUMN `group_country` INT(10) UNSIGNED NOT NULL  COMMENT '' AFTER `group_title`,
      MODIFY COLUMN `group_description` MEDIUMTEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL  COMMENT '' AFTER `group_country`;

    # Changing table static_pages fields
    ALTER TABLE `static_pages`
      MODIFY COLUMN `page_title` VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL  COMMENT '' AFTER `page_id`,
      ADD COLUMN `page_is_redirect` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `page_title`,
      ADD COLUMN `page_redirect_url` VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL  COMMENT '' AFTER `page_is_redirect`,
      MODIFY COLUMN `page_url` VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL  COMMENT '' AFTER `page_redirect_url`,
      MODIFY COLUMN `page_text` MEDIUMTEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL  COMMENT '' AFTER `page_url`,
      ADD COLUMN `page_in_sidebar` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `page_in_footer`,
      ADD COLUMN `page_icon` VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL  COMMENT '' AFTER `page_in_sidebar`,
      MODIFY COLUMN `page_order` INT(10) UNSIGNED NOT NULL DEFAULT 1  COMMENT '' AFTER `page_icon`;

    # Changing table bank_transfers fields
    ALTER TABLE `bank_transfers`
      ADD COLUMN `orders_collection_id` VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL  COMMENT '' AFTER `movie_id`,
      MODIFY COLUMN `price` FLOAT NULL DEFAULT NULL  COMMENT '' AFTER `orders_collection_id`;

    # Changing table users fields
    ALTER TABLE `users`
      ADD COLUMN `user_approved` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `user_activated`,
      MODIFY COLUMN `user_reseted` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `user_approved`,
      ADD COLUMN `user_privacy_chat` ENUM('me','friends','public') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'public'  COMMENT '' AFTER `user_tips_enabled`,
      MODIFY COLUMN `user_privacy_poke` ENUM('me','friends','public') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'public'  COMMENT '' AFTER `user_privacy_chat`,
      ADD COLUMN `email_admin_user_approval` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `email_admin_post_approval`,
      MODIFY COLUMN `facebook_connected` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `email_admin_user_approval`,
      ADD COLUMN `onesignal_android_user_id` VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL  COMMENT '' AFTER `onesignal_user_id`,
      ADD COLUMN `onesignal_ios_user_id` VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL  COMMENT '' AFTER `onesignal_android_user_id`,
      MODIFY COLUMN `user_language` VARCHAR(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'en_us'  COMMENT '' AFTER `onesignal_ios_user_id`;

    # Changing table widgets fields
    ALTER TABLE `widgets`
      ADD COLUMN `language_id` INT(10) NOT NULL DEFAULT 0  COMMENT '' AFTER `code`,
      ADD COLUMN `target_audience` ENUM('all','members','visitors') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'all'  COMMENT '' AFTER `language_id`;

    # Changing table pages fields
    ALTER TABLE `pages`
      ADD COLUMN `page_activities_enabled` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `page_tips_enabled`,
      MODIFY COLUMN `page_boosted` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `page_activities_enabled`,
      ADD COLUMN `page_pbid` VARCHAR(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL  COMMENT '' AFTER `page_rate`,
      MODIFY COLUMN `page_date` DATETIME NOT NULL  COMMENT '' AFTER `page_pbid`;

    # Changing table log_sessions indexes
    ALTER TABLE `log_sessions`
      ADD INDEX `session_user_agent` USING BTREE (session_user_agent),
      ADD INDEX `idx_session_ip_user_agent` USING BTREE (session_ip, session_user_agent);

    # Changing table orders fields, indexes
    ALTER TABLE `orders`
      ADD COLUMN `order_collection_id` VARCHAR(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL  COMMENT '' AFTER `order_hash`,
      ADD COLUMN `is_payment_done` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `order_collection_id`,
      MODIFY COLUMN `is_digital` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `is_payment_done`,
      ADD COLUMN `seller_page_id` INT(10) UNSIGNED NOT NULL DEFAULT 0  COMMENT '' AFTER `seller_id`,
      MODIFY COLUMN `buyer_id` INT(10) UNSIGNED NOT NULL  COMMENT '' AFTER `seller_page_id`,
      ADD INDEX `order_hash` USING BTREE (order_hash),
      ADD INDEX `order_collection_id` USING BTREE (order_collection_id);

    # Changing table permissions_groups fields
    ALTER TABLE `permissions_groups`
      ADD COLUMN `reels_permission` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `events_permission`,
      ADD COLUMN `watch_permission` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `reels_permission`,
      MODIFY COLUMN `blogs_permission` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `watch_permission`,
      MODIFY COLUMN `blogs_permission_read` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `blogs_permission`,
      MODIFY COLUMN `market_permission` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `blogs_permission_read`,
      ADD COLUMN `courses_permission` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `jobs_permission`,
      MODIFY COLUMN `forums_permission` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `courses_permission`,
      MODIFY COLUMN `stories_permission` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `gifts_permission`,
      MODIFY COLUMN `posts_permission` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `stories_permission`,
      MODIFY COLUMN `colored_posts_permission` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `posts_permission`,
      ADD COLUMN `funding_permission` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `ads_permission`,
      MODIFY COLUMN `monetization_permission` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `funding_permission`,
      ADD COLUMN `custom_points_system` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `tips_permission`,
      ADD COLUMN `points_per_currency` INT(10) UNSIGNED NOT NULL DEFAULT 100  COMMENT '' AFTER `custom_points_system`,
      DROP COLUMN `videos_permission_read`,
      DROP COLUMN `fundings_permission`;

    # Changing table hashtags_posts indexes
    ALTER TABLE `hashtags_posts`
      ADD INDEX `post_id` USING BTREE (post_id),
      ADD INDEX `hashtag_id` USING BTREE (hashtag_id);

    # Changing table system_countries fields
    ALTER TABLE `system_countries`
      MODIFY COLUMN `country_vat` FLOAT UNSIGNED NULL DEFAULT NULL  COMMENT '' AFTER `phone_code`;

    ############################################################################################################

    # Inserting data into courses_categories
    INSERT INTO `courses_categories` (`category_id`, `category_parent_id`, `category_name`, `category_description`, `category_order`) VALUES
    (1, 0, 'Admin &amp; Office', '', 1),
    (2, 0, 'Art &amp; Design', '', 2),
    (3, 0, 'Business Operations', '', 3),
    (4, 0, 'Cleaning &amp; Facilities', '', 4),
    (5, 0, 'Community &amp; Social Services', '', 5),
    (6, 0, 'Computer &amp; Data', '', 6),
    (7, 0, 'Construction &amp; Mining', '', 7),
    (8, 0, 'Education', '', 8),
    (9, 0, 'Farming &amp; Forestry', '', 9),
    (10, 0, 'Healthcare', '', 10),
    (11, 0, 'Installation, Maintenance &amp; Repair', '', 11),
    (12, 0, 'Legal', '', 12),
    (13, 0, 'Management', '', 13),
    (14, 0, 'Manufacturing', '', 14),
    (15, 0, 'Media &amp; Communication', '', 15),
    (16, 0, 'Personal Care', '', 16),
    (17, 0, 'Protective Services', '', 17),
    (18, 0, 'Restaurant &amp; Hospitality', '', 18),
    (19, 0, 'Retail &amp; Sales', '', 19),
    (20, 0, 'Science &amp; Engineering', '', 20),
    (21, 0, 'Sports &amp; Entertainment', '', 21),
    (22, 0, 'Transportation', '', 22),
    (23, 0, 'Other', '', 23);

    # Changing table posts_articles fields
    ALTER TABLE `posts_articles`
      DROP COLUMN `views`,
      ADD FULLTEXT INDEX `ft_tags` (tags);

    # Changing table posts_articles fields
    ALTER TABLE `posts_articles`
      ADD FULLTEXT INDEX `ft_title` (title);

    COMMIT;
      
	";
  $db->multi_query($structure) or _error("Error", $db->error);


  // flush multi_queries
  do {
  } while (mysqli_more_results($db) && mysqli_next_result($db));


  // Update All orders as PAID (is_payment_done)
  $db->query("UPDATE orders SET is_payment_done = '1'") or _error("Error", $db->error);


  // Update fundings_enabled to funding_enabled in system_options
  $db->query("UPDATE system_options SET option_name = 'funding_enabled' WHERE option_name = 'fundings_enabled'") or _error("Error", $db->error);


  // update permissions_groups set reels_permission & watch_permission & funding_permission to 1
  $db->query("UPDATE permissions_groups SET reels_permission = '1', watch_permission = '1', funding_permission = '1'") or _error("Error", $db->error);


  // update users table (user_approved = 1)
  $db->query("UPDATE users SET user_approved = '1'") or _error("Error", $db->error);


  // update all posts_jobs (set salary_minimum_currency = system_default_currency && salary_maximum_currency = system_default_currency)
  $get_default_currency = $db->query("SELECT currency_id FROM system_currencies WHERE `default` = '1' LIMIT 1");
  $default_currency = $get_default_currency->fetch_assoc();
  $db->query(sprintf("UPDATE posts_jobs SET salary_minimum_currency = %s, salary_maximum_currency = %s", secure($default_currency['currency_id'], 'int'), secure($default_currency['currency_id'], 'int'))) or _error("Error", $db->error);


  // Update Ads (ads_system) Set place value article = blog & article_footer = blog_footer
  $db->query("UPDATE ads_system SET place = 'blog' WHERE place = 'article'") or _error("Error", $db->error);
  $db->query("UPDATE ads_system SET place = 'blog_footer' WHERE place = 'article_footer'") or _error("Error", $db->error);


  // insert new system options
  $db->query("INSERT INTO system_options (option_name, option_value) VALUES
      ('authorize_net_enabled', '0'),
      ('authorize_net_api_login_id', ''),
      ('authorize_net_transaction_key', ''),
      ('authorize_net_mode', 'sandbox'),
      ('users_approval_enabled', ''),
      ('email_admin_user_approval', '0'),
      ('courses_enabled', '0'),
      ('courses_results', '12'),
      ('system_description_courses', 'Discover new courses'),
      ('disable_username_changes', '0'),
      ('user_privacy_chat', 'public'),
      ('user_privacy_poke', 'public'),
      ('user_privacy_gifts', 'public'),
      ('user_privacy_wall', 'public'),
      ('user_privacy_gender', 'public'),
      ('user_privacy_relationship', 'public'),
      ('user_privacy_birthdate', 'public'),
      ('user_privacy_basic', 'public'),
      ('user_privacy_work', 'public'),
      ('user_privacy_location', 'public'),
      ('user_privacy_education', 'public'),
      ('user_privacy_other', 'public'),
      ('user_privacy_friends', 'public'),
      ('user_privacy_followers', 'public'),
      ('user_privacy_subscriptions', 'public'),
      ('user_privacy_photos', 'public'),
      ('user_privacy_pages', 'public'),
      ('user_privacy_groups', 'public'),
      ('user_privacy_events', 'public'),
      ('yandex_cloud_enabled', '0'),
      ('yandex_cloud_bucket', ''),
      ('yandex_cloud_region', 'ru-central1'),
      ('yandex_cloud_key', ''),
      ('yandex_cloud_secret', ''),
      ('points_per_post_comment', '5'),
      ('points_per_post_reaction', '5'),
      ('profile_posts_updates_disabled', '0'),
      ('monetization_max_paid_post_price', '0'),
      ('monetization_max_plan_price', '0'),
      ('watermark_type', 'icon'),
      ('download_images_disabled', '0'),
      ('right_click_disabled', '0'),
      ('myfatoorah_enabled', '0'),
      ('myfatoorah_mode', 'test'),
      ('myfatoorah_test_token', ''),
      ('myfatoorah_live_token', ''),
      ('myfatoorah_live_api_url', ''),
      ('select_user_group_enabled', '0'),
      ('show_user_group_enabled', '0'),
      ('funding_wallet_payment_enabled', '1'),
      ('epayco_enabled', '0'),
      ('epayco_mode', 'test'),
      ('epayco_public_key', ''),
      ('epayco_private_key', ''),
      ('friends_enabled', '1'),
      ('flutterwave_enabled', '0'),
      ('flutterwave_mode', 'test'),
      ('flutterwave_public_key', ''),
      ('flutterwave_secret_key', ''),
      ('flutterwave_encryption_key', ''),
      ('max_daily_upload_size', '0'),
      ('pages_pbid_enabled', '0'),
      ('pages_activities_enabled', '0'),
      ('activities_edit_limit', '60'),
      ('stripe_payment_element_enabled', '0'),
      ('blogs_results', '12'),
      ('funding_results', '12'),
      ('verotel_enabled', '0'),
      ('verotel_shop_id', ''),
      ('verotel_signature_key', ''),
      ('auto_language_detection', '0'),
      ('paypal_payouts_enabled', '0'),
      ('moneypoolscash_payouts_enabled', '0'),
      ('reels_enabled', '1')
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