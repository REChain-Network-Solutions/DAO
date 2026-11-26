<?php

/**
 * install wizard
 * 
 * @package Sngine
 * @author Zamblek
 */

// set execution time
set_time_limit(0); /* unlimited max execution time */


// set ABSPATH
define('ABSPATH', __DIR__ . '/');


// get system version & exceptions
require(ABSPATH . 'includes/sys_ver.php');
require(ABSPATH . 'includes/exceptions.php');


// check config file
if (file_exists(ABSPATH . 'includes/config.php')) {
  /* the config file exist -> start the system */
  header('Location: ./');
}


// set debugging settings
ini_set("display_errors", true);
error_reporting(E_ALL & ~E_WARNING & ~E_NOTICE & ~E_DEPRECATED);


// get functions
require(ABSPATH . 'includes/functions.php');


// check system requirements
$requirements_matrix = [
  'PHP'             => ['PHP 8.4+', 'PHP version 8.4 or higher'],
  'mysqli'          => ['MySQLi', 'MySQLi PHP extension'],
  'curl'            => ['cURL', 'cURL PHP extension'],
  'openssl'         => ['OpenSSL', 'OpenSSL PHP extension'],
  'mbstring'        => ['Mbstring', 'Mbstring extension for UTF-8 strings'],
  'gd'              => ['GD Library', 'GD Library to handle images'],
  'fileinfo'        => ['Fileinfo', 'Fileinfo extension for file uploads'],
  'zip'             => ['ZIP', 'ZIP extension for taking backups'],
  'allow_url_fopen' => ['allow_url_fopen', 'allow_url_fopen must be enabled'],
  'htaccess'        => ['.htaccess', '.htaccess file for pretty links'],
  'config'          => ['includes/ writable', 'includes folder must be writable'],
];
$requirements_errors = check_system_requirements();
$requirements_ok = empty($requirements_errors);


// check AJAX Request
$is_stream = $is_ajax = is_ajax(false);


// turn off mysqli errors
mysqli_report(MYSQLI_REPORT_OFF);


// verify licence (wizard step, before install)
if (isset($_POST['verify_licence'])) {
  header('Content-Type: application/json; charset=utf-8');
  header('Cache-Control: no-cache');
  try {
    if (is_empty($_POST['purchase_code'] ?? '')) {
      echo json_encode(['success' => false, 'message' => 'Please enter a valid purchase code']);
      exit;
    }
    $licence = get_licence_key($_POST['purchase_code'], 'install');
    echo json_encode([
      'success' => true,
      'monetization' => !empty($licence['entitlements']['monetization']),
    ]);
  } catch (Exception $e) {
    echo json_encode(['success' => false, 'message' => $e->getMessage()]);
  }
  exit;
}


// install
if (isset($_POST['submit'])) {

  // check system requirements errors
  if ($requirements_errors) {
    stream_fail("You need to check the system requirements to continue, Back to your hosting support for help.");
  }


  // check admin data
  /* check email */
  if (!valid_email($_POST['admin_email'])) {
    stream_fail("Please enter a valid email address");
  }
  /* check username */
  if (!valid_username($_POST['admin_username'])) {
    stream_fail("Please enter a valid username (a-z0-9_.) with minimum 3 characters long");
  }
  if (in_array(strtolower($_POST['admin_username']), ['install', 'static', 'contact', 'contacts', 'sign', 'signin', 'login', 'signup', 'register', 'signout', 'logout', 'reset', 'activation', 'connect', 'revoke', 'packages', 'started', 'search', 'friends', 'messages', 'message', 'notifications', 'notification', 'settings', 'setting', 'posts', 'post', 'photos', 'photo', 'create', 'pages', 'page', 'groups', 'group', 'events', 'event', 'games', 'game', 'saved', 'forums', 'forum', 'blogs', 'blog', 'articles', 'article', 'directory', 'products', 'product', 'market', 'admincp', 'admin', 'admins', 'modcp', 'moderator', 'moderators', 'moderatorcp', 'chat', 'ads', 'wallet', 'boosted', 'people', 'popular', 'movies', 'movie', 'dating', 'api', 'apis', 'oauth', 'authorize', 'anonymous', 'jobs', 'job'])) {
    stream_fail("You can't use" . " <strong>" . $_POST['admin_username'] . "</strong> " . "as username");
  }
  /* check password */
  if (is_empty($_POST['admin_password']) || strlen($_POST['admin_password']) < 6) {
    stream_fail("Your password must be at least 6 characters long. Please try another");
  }
  if (strlen($_POST['admin_password']) > 64) {
    stream_fail("Your password must be less than 64 characters long. Please try another");
  }


  // open the streaming response
  stream_start();


  // step 1: verifying purchase code
  stream_progress(4, 'Verifying purchase code');
  try {
    if (is_empty($_POST['purchase_code'])) {
      stream_fail("Please enter a valid purchase code");
    }
    $licence = get_licence_key($_POST['purchase_code'], 'install');
    $licence_key = $_POST['purchase_code'];
  } catch (Exception $e) {
    stream_fail($e->getMessage());
  }


  // step 2: connecting to the database
  stream_progress(18, 'Connecting to the database');
  try {
    $db = init_db_connection($_POST['db_host'], $_POST['db_username'], $_POST['db_password'], $_POST['db_name'], $_POST['db_port']);
  } catch (Exception $e) {
    stream_fail("Error establishing a database connection. Please verify your database name, username, password, host and port, then try again.");
  }
  if (!check_db_version($db)) {
    stream_fail("Your database server is not supported. Sngine requires MySQL 8.0+ or MariaDB 10.6+, Back to your hosting support for help.");
  }


  // step 3: building the database structure
  $structure = "
    
    SET SQL_MODE = `NO_AUTO_VALUE_ON_ZERO`;
    START TRANSACTION;
    SET time_zone = `+00:00`;


    /*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
    /*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
    /*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
    /*!40101 SET NAMES utf8mb4 */;

    --
    -- Database: `sngine`
    --

    -- --------------------------------------------------------

    --
    -- Table structure for table `ads_campaigns`
    --

    CREATE TABLE `ads_campaigns` (
      `campaign_id` int UNSIGNED NOT NULL,
      `campaign_user_id` int UNSIGNED NOT NULL,
      `campaign_title` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `campaign_start_date` datetime NOT NULL,
      `campaign_end_date` datetime NOT NULL,
      `campaign_budget` double NOT NULL,
      `campaign_spend` double NOT NULL DEFAULT '0',
      `campaign_bidding` enum('click','view') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `audience_countries` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `audience_gender` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `audience_relationship` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `audience_age_min` tinyint UNSIGNED DEFAULT NULL,
      `audience_age_max` tinyint UNSIGNED DEFAULT NULL,
      `ads_title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `ads_description` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
      `ads_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `ads_url` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `ads_post_url` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `ads_page` int UNSIGNED DEFAULT NULL,
      `ads_group` int UNSIGNED DEFAULT NULL,
      `ads_event` int UNSIGNED DEFAULT NULL,
      `ads_placement` enum('newsfeed','sidebar') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `ads_image` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `ads_video` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `campaign_created_date` datetime NOT NULL,
      `campaign_is_active` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1',
      `campaign_is_approved` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `campaign_is_declined` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `campaign_views` int UNSIGNED NOT NULL DEFAULT '0',
      `campaign_clicks` int UNSIGNED NOT NULL DEFAULT '0'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `ads_system`
    --

    CREATE TABLE `ads_system` (
      `ads_id` int UNSIGNED NOT NULL,
      `title` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `place` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `ads_pages_ids` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
      `ads_groups_ids` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
      `code` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `time` datetime NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `affiliates_payments`
    --

    CREATE TABLE `affiliates_payments` (
      `payment_id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `amount` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `method` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `method_value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `time` datetime NOT NULL,
      `status` tinyint(1) NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `announcements`
    --

    CREATE TABLE `announcements` (
      `announcement_id` int UNSIGNED NOT NULL,
      `name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `title` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `code` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `start_date` datetime NOT NULL,
      `end_date` datetime NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `announcements_users`
    --

    CREATE TABLE `announcements_users` (
      `id` int UNSIGNED NOT NULL,
      `announcement_id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `auto_connect`
    --

    CREATE TABLE `auto_connect` (
      `id` int UNSIGNED NOT NULL,
      `type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `country_id` int UNSIGNED NOT NULL,
      `nodes_ids` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `bank_transfers`
    --

    CREATE TABLE `bank_transfers` (
      `transfer_id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `handle` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `package_id` int UNSIGNED DEFAULT NULL,
      `post_id` int UNSIGNED DEFAULT NULL,
      `plan_id` int UNSIGNED DEFAULT NULL,
      `movie_id` int UNSIGNED DEFAULT NULL,
      `orders_collection_id` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `price` float DEFAULT NULL,
      `total` float DEFAULT NULL,
      `bank_receipt` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `time` datetime NOT NULL,
      `status` tinyint(1) NOT NULL DEFAULT '0'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `blacklist`
    --

    CREATE TABLE `blacklist` (
      `node_id` int UNSIGNED NOT NULL,
      `node_type` enum('ip','email','username') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `node_value` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `created_time` datetime NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `blogs_categories`
    --

    CREATE TABLE `blogs_categories` (
      `category_id` int UNSIGNED NOT NULL,
      `category_parent_id` int UNSIGNED NOT NULL,
      `category_name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `category_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `category_order` int UNSIGNED NOT NULL DEFAULT '1'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    --
    -- Dumping data for table `blogs_categories`
    --

    INSERT INTO `blogs_categories` (`category_id`, `category_parent_id`, `category_name`, `category_description`, `category_order`) VALUES
    (1, 0, 'Art', '', 1),
    (2, 0, 'Causes', '', 2),
    (3, 0, 'Crafts', '', 3),
    (4, 0, 'Dance', '', 4),
    (5, 0, 'Drinks', '', 5),
    (6, 0, 'Film', '', 6),
    (7, 0, 'Fitness', '', 7),
    (8, 0, 'Food', '', 8),
    (9, 0, 'Games', '', 9),
    (10, 0, 'Gardening', '', 10),
    (11, 0, 'Health', '', 11),
    (12, 0, 'Home', '', 12),
    (13, 0, 'Literature', '', 13),
    (14, 0, 'Music', '', 14),
    (15, 0, 'Networking', '', 15),
    (16, 0, 'Other', '', 16),
    (17, 0, 'Party', '', 17),
    (18, 0, 'Religion', '', 18),
    (19, 0, 'Shopping', '', 19),
    (20, 0, 'Sports', '', 20),
    (21, 0, 'Theater', '', 21),
    (22, 0, 'Wellness', '', 22);

    -- --------------------------------------------------------

    --
    -- Table structure for table `ccbill_payments`
    --

    CREATE TABLE `ccbill_payments` (
      `payment_id` int UNSIGNED NOT NULL,
      `payment_status` enum('pending','paid','failed') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'pending',
      `user_id` int UNSIGNED NOT NULL,
      `handle` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `reference_id` int UNSIGNED DEFAULT NULL,
      `amount` float NOT NULL,
      `total_amount` float NOT NULL,
      `created_at` datetime NOT NULL,
      `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    -- --------------------------------------------------------

    --
    -- Table structure for table `coinpayments_transactions`
    --

    CREATE TABLE `coinpayments_transactions` (
      `transaction_id` int UNSIGNED NOT NULL,
      `transaction_txn_id` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
      `user_id` int UNSIGNED NOT NULL,
      `amount` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `product` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `created_at` datetime NOT NULL,
      `last_update` datetime NOT NULL,
      `status` tinyint UNSIGNED NOT NULL,
      `status_message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `conversations`
    --

    CREATE TABLE `conversations` (
      `conversation_id` int UNSIGNED NOT NULL,
      `last_message_id` int UNSIGNED NOT NULL,
      `pinned_message_id` int UNSIGNED DEFAULT NULL,
      `color` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `name` varchar(128) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
      `node_id` int UNSIGNED DEFAULT NULL,
      `node_type` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `conversations_calls`
    --

    CREATE TABLE `conversations_calls` (
      `call_id` int UNSIGNED NOT NULL,
      `is_video_call` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `from_user_id` int UNSIGNED NOT NULL,
      `from_user_token` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `to_user_id` int UNSIGNED NOT NULL,
      `to_user_token` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `room` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `answered` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `declined` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `answered_time` datetime DEFAULT NULL,
      `ended_time` datetime DEFAULT NULL,
      `ended_by` int UNSIGNED DEFAULT NULL,
      `created_time` datetime NOT NULL,
      `updated_time` datetime NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `conversations_messages`
    --

    CREATE TABLE `conversations_messages` (
      `message_id` int UNSIGNED NOT NULL,
      `conversation_id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `page_id` int UNSIGNED DEFAULT NULL,
      `message` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `is_paid` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `message_price` float NOT NULL DEFAULT '0',
      `paid_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
      `paid_image` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `for_adult` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `image` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `gif` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
      `video` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `voice_note` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `product_post_id` int UNSIGNED DEFAULT NULL,
      `story_id` int UNSIGNED DEFAULT NULL,
      `reply_to` int UNSIGNED DEFAULT NULL,
      `call_id` int UNSIGNED DEFAULT NULL,
      `reaction_like_count` int UNSIGNED NOT NULL DEFAULT '0',
      `reaction_love_count` int UNSIGNED NOT NULL DEFAULT '0',
      `reaction_haha_count` int UNSIGNED NOT NULL DEFAULT '0',
      `reaction_yay_count` int UNSIGNED NOT NULL DEFAULT '0',
      `reaction_wow_count` int UNSIGNED NOT NULL DEFAULT '0',
      `reaction_sad_count` int UNSIGNED NOT NULL DEFAULT '0',
      `reaction_angry_count` int UNSIGNED NOT NULL DEFAULT '0',
      `time` datetime NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `conversations_messages_media`
    --

    CREATE TABLE `conversations_messages_media` (
      `media_id` int UNSIGNED NOT NULL,
      `message_id` int UNSIGNED NOT NULL,
      `media_type` enum('photo','video','audio','file') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `source` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `name` varchar(256) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
      `size` bigint UNSIGNED NOT NULL DEFAULT '0'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    -- --------------------------------------------------------

    --
    -- Table structure for table `conversations_messages_paid`
    --

    CREATE TABLE `conversations_messages_paid` (
      `id` int UNSIGNED NOT NULL,
      `message_id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `time` datetime NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    -- --------------------------------------------------------

    --
    -- Table structure for table `conversations_messages_reactions`
    --

    CREATE TABLE `conversations_messages_reactions` (
      `id` int UNSIGNED NOT NULL,
      `message_id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `reaction` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'like',
      `reaction_time` datetime DEFAULT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `conversations_users`
    --

    CREATE TABLE `conversations_users` (
      `id` int UNSIGNED NOT NULL,
      `conversation_id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `seen` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `typing` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `deleted` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `courses_categories`
    --

    CREATE TABLE `courses_categories` (
      `category_id` int UNSIGNED NOT NULL,
      `category_parent_id` int UNSIGNED NOT NULL,
      `category_name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `category_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `category_order` int UNSIGNED NOT NULL DEFAULT '1'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    --
    -- Dumping data for table `courses_categories`
    --

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

    -- --------------------------------------------------------

    --
    -- Table structure for table `custom_fields`
    --

    CREATE TABLE `custom_fields` (
      `field_id` int UNSIGNED NOT NULL,
      `field_for` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `select_options` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `label` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `description` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `place` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `length` int NOT NULL DEFAULT '32',
      `field_order` int NOT NULL DEFAULT '1',
      `is_link` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `mandatory` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `in_registration` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `in_profile` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `in_search` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `custom_fields_values`
    --

    CREATE TABLE `custom_fields_values` (
      `value_id` int UNSIGNED NOT NULL,
      `value` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `field_id` int UNSIGNED NOT NULL,
      `node_id` int UNSIGNED NOT NULL,
      `node_type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `dating_interests`
    --

    CREATE TABLE `dating_interests` (
      `interest_id` int UNSIGNED NOT NULL,
      `title` varchar(64) COLLATE utf8mb4_general_ci NOT NULL,
      `icon` varchar(32) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
      `interest_order` int UNSIGNED NOT NULL DEFAULT '1'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    --
    -- Dumping data for table `dating_interests`
    --

    INSERT INTO `dating_interests` (`interest_id`, `title`, `icon`, `interest_order`) VALUES
    (1, 'Music', '🎵', 1),
    (2, 'Travel', '✈️', 2),
    (3, 'Coffee', '☕', 3),
    (4, 'Fitness', '💪', 4),
    (5, 'Foodie', '🍽️', 5),
    (6, 'Movies', '🎬', 6),
    (7, 'Pets', '🐶', 7),
    (8, 'Books', '📚', 8),
    (9, 'Art', '🎨', 9),
    (10, 'Gaming', '🎮', 10),
    (11, 'Nature', '🌿', 11),
    (12, 'Beach', '🏖️', 12),
    (13, 'Photography', '📷', 13),
    (14, 'Cooking', '🍳', 14),
    (15, 'Dancing', '💃', 15);

    -- --------------------------------------------------------

    --
    -- Table structure for table `dating_locations`
    --

    CREATE TABLE `dating_locations` (
      `user_id` int UNSIGNED NOT NULL,
      `location` point NOT NULL /*!80003 SRID 0 */
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    -- --------------------------------------------------------

    --
    -- Table structure for table `dating_matches`
    --

    CREATE TABLE `dating_matches` (
      `match_id` int UNSIGNED NOT NULL,
      `user_one_id` int UNSIGNED NOT NULL,
      `user_two_id` int UNSIGNED NOT NULL,
      `status` enum('active','unmatched') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'active',
      `unmatched_by` int UNSIGNED DEFAULT NULL,
      `time` datetime NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    -- --------------------------------------------------------

    --
    -- Table structure for table `dating_photos`
    --

    CREATE TABLE `dating_photos` (
      `photo_id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `source` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
      `status` enum('pending','approved') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'approved',
      `photo_order` tinyint UNSIGNED NOT NULL DEFAULT '0',
      `time` datetime NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    -- --------------------------------------------------------

    --
    -- Table structure for table `dating_profiles`
    --

    CREATE TABLE `dating_profiles` (
      `user_id` int UNSIGNED NOT NULL,
      `status` enum('active','paused','suspended') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'active',
      `gender` int UNSIGNED NOT NULL,
      `birthdate` date NOT NULL,
      `show_genders` varchar(64) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
      `min_age` tinyint UNSIGNED NOT NULL DEFAULT '18',
      `max_age` tinyint UNSIGNED NOT NULL DEFAULT '99',
      `max_distance` smallint UNSIGNED NOT NULL DEFAULT '100',
      `bio` text COLLATE utf8mb4_general_ci,
      `country_id` int UNSIGNED NOT NULL DEFAULT '0',
      `city` varchar(128) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
      `city_key` varchar(160) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
      `latitude` decimal(10,7) DEFAULT NULL,
      `longitude` decimal(10,7) DEFAULT NULL,
      `hide_from_friends` enum('0','1') COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `incognito` enum('0','1') COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `hide_age` enum('0','1') COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `hide_distance` enum('0','1') COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `boosted_until` datetime DEFAULT NULL,
      `super_likes_balance` int UNSIGNED NOT NULL DEFAULT '0',
      `super_likes_included` int UNSIGNED NOT NULL DEFAULT '0',
      `boosts_included` int UNSIGNED NOT NULL DEFAULT '0',
      `included_period` char(7) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
      `time` datetime NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    -- --------------------------------------------------------

    --
    -- Table structure for table `dating_profiles_interests`
    --

    CREATE TABLE `dating_profiles_interests` (
      `user_id` int UNSIGNED NOT NULL,
      `interest_id` int UNSIGNED NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    -- --------------------------------------------------------

    --
    -- Table structure for table `dating_purchases`
    --

    CREATE TABLE `dating_purchases` (
      `purchase_id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `item` enum('super_likes','boost','priority_message') COLLATE utf8mb4_general_ci NOT NULL,
      `quantity` int UNSIGNED NOT NULL DEFAULT '1',
      `amount` float NOT NULL DEFAULT '0',
      `time` datetime NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    -- --------------------------------------------------------

    --
    -- Table structure for table `dating_swipes`
    --

    CREATE TABLE `dating_swipes` (
      `swipe_id` bigint UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `target_id` int UNSIGNED NOT NULL,
      `action` enum('pass','like','super') COLLATE utf8mb4_general_ci NOT NULL,
      `pending` enum('0','1') COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `message` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
      `time` datetime NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    -- --------------------------------------------------------

    --
    -- Table structure for table `developers_apps`
    --

    CREATE TABLE `developers_apps` (
      `app_id` int UNSIGNED NOT NULL,
      `app_user_id` int UNSIGNED NOT NULL,
      `app_category_id` int UNSIGNED NOT NULL,
      `app_auth_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `app_auth_secret` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `app_name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `app_domain` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `app_redirect_url` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `app_description` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `app_icon` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `app_date` datetime NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `developers_apps_categories`
    --

    CREATE TABLE `developers_apps_categories` (
      `category_id` int UNSIGNED NOT NULL,
      `category_parent_id` int UNSIGNED NOT NULL,
      `category_name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `category_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `category_order` int UNSIGNED NOT NULL DEFAULT '1'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    --
    -- Dumping data for table `developers_apps_categories`
    --

    INSERT INTO `developers_apps_categories` (`category_id`, `category_parent_id`, `category_name`, `category_description`, `category_order`) VALUES
    (1, 0, 'Business and Pages', '', 1),
    (2, 0, 'Community &amp; Government', '', 2),
    (3, 0, 'Education', '', 3),
    (4, 0, 'Entertainment', '', 4),
    (5, 0, 'Entertainment', '', 5),
    (6, 0, 'Games', '', 6),
    (7, 0, 'Lifestyle', '', 7),
    (8, 0, 'Messaging', '', 8),
    (9, 0, 'News', '', 9),
    (10, 0, 'Shopping', '', 10),
    (11, 0, 'Social Networks &amp; Dating', '', 11),
    (12, 0, 'Utility &amp; Productivity', '', 12);

    -- --------------------------------------------------------

    --
    -- Table structure for table `developers_apps_users`
    --

    CREATE TABLE `developers_apps_users` (
      `id` int UNSIGNED NOT NULL,
      `app_id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `auth_key` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `access_token` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `access_token_date` datetime DEFAULT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `events`
    --

    CREATE TABLE `events` (
      `event_id` int UNSIGNED NOT NULL,
      `event_privacy` enum('secret','closed','public') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'public',
      `event_admin` int UNSIGNED NOT NULL,
      `event_page_id` int UNSIGNED DEFAULT NULL,
      `event_category` int UNSIGNED NOT NULL,
      `event_title` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `event_location` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `event_latitude` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `event_longitude` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `event_country` int UNSIGNED NOT NULL,
      `event_language` int UNSIGNED NOT NULL,
      `event_description` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `event_start_date` datetime NOT NULL,
      `event_end_date` datetime NOT NULL,
      `event_is_online` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `event_publish_enabled` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1',
      `event_publish_approval_enabled` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `event_cover` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `event_cover_id` int UNSIGNED DEFAULT NULL,
      `event_cover_position` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `event_album_covers` int DEFAULT NULL,
      `event_album_timeline` int DEFAULT NULL,
      `event_pinned_post` int DEFAULT NULL,
      `event_boosted` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `event_boosted_by` int UNSIGNED DEFAULT NULL,
      `event_invited` int UNSIGNED NOT NULL DEFAULT '0',
      `event_interested` int UNSIGNED NOT NULL DEFAULT '0',
      `event_going` int UNSIGNED NOT NULL DEFAULT '0',
      `chatbox_enabled` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `chatbox_conversation_id` int UNSIGNED DEFAULT NULL,
      `event_tickets_link` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `event_prices` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
      `event_rate` float NOT NULL DEFAULT '0',
      `event_is_sponsored` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `event_sponsor_name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `event_sponsor_url` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `event_date` datetime NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `events_categories`
    --

    CREATE TABLE `events_categories` (
      `category_id` int UNSIGNED NOT NULL,
      `category_parent_id` int UNSIGNED NOT NULL,
      `category_name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `category_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `category_order` int UNSIGNED NOT NULL DEFAULT '1'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    --
    -- Dumping data for table `events_categories`
    --

    INSERT INTO `events_categories` (`category_id`, `category_parent_id`, `category_name`, `category_description`, `category_order`) VALUES
    (1, 0, 'Art', '', 1),
    (2, 0, 'Causes', '', 2),
    (3, 0, 'Crafts', '', 3),
    (4, 0, 'Dance', '', 4),
    (5, 0, 'Drinks', '', 5),
    (6, 0, 'Film', '', 6),
    (7, 0, 'Fitness', '', 7),
    (8, 0, 'Food', '', 8),
    (9, 0, 'Games', '', 9),
    (10, 0, 'Gardening', '', 10),
    (11, 0, 'Health', '', 11),
    (12, 0, 'Home', '', 12),
    (13, 0, 'Literature', '', 13),
    (14, 0, 'Music', '', 14),
    (15, 0, 'Networking', '', 15),
    (16, 0, 'Other', '', 16),
    (17, 0, 'Party', '', 17),
    (18, 0, 'Religion', '', 18),
    (19, 0, 'Shopping', '', 19),
    (20, 0, 'Sports', '', 20),
    (21, 0, 'Theater', '', 21),
    (22, 0, 'Wellness', '', 22);

    -- --------------------------------------------------------

    --
    -- Table structure for table `events_members`
    --

    CREATE TABLE `events_members` (
      `id` int UNSIGNED NOT NULL,
      `event_id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `is_invited` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0',
      `is_interested` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0',
      `is_going` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `followings`
    --

    CREATE TABLE `followings` (
      `id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `following_id` int UNSIGNED NOT NULL,
      `points_earned` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `time` datetime DEFAULT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `forums`
    --

    CREATE TABLE `forums` (
      `forum_id` int UNSIGNED NOT NULL,
      `forum_section` int UNSIGNED NOT NULL,
      `forum_name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `forum_description` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
      `forum_color` varchar(32) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
      `forum_icon` varchar(64) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
      `forum_order` int UNSIGNED NOT NULL DEFAULT '1',
      `forum_threads` int UNSIGNED NOT NULL DEFAULT '0',
      `forum_replies` int UNSIGNED NOT NULL DEFAULT '0'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `forums_likes`
    --

    CREATE TABLE `forums_likes` (
      `id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `node_id` int UNSIGNED NOT NULL,
      `node_type` enum('thread','reply') COLLATE utf8mb4_general_ci NOT NULL,
      `time` datetime NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `forums_replies`
    --

    CREATE TABLE `forums_replies` (
      `reply_id` int UNSIGNED NOT NULL,
      `thread_id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `reply_to_id` int UNSIGNED DEFAULT NULL,
      `text` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `likes` int UNSIGNED NOT NULL DEFAULT '0',
      `time` datetime NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `forums_threads`
    --

    CREATE TABLE `forums_threads` (
      `thread_id` int UNSIGNED NOT NULL,
      `forum_id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `title` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `text` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `replies` int UNSIGNED NOT NULL DEFAULT '0',
      `views` int UNSIGNED NOT NULL DEFAULT '0',
      `likes` int UNSIGNED NOT NULL DEFAULT '0',
      `time` datetime NOT NULL,
      `last_reply` datetime DEFAULT NULL,
      `last_reply_user_id` int UNSIGNED DEFAULT NULL,
      `is_pinned` enum('0','1') COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `is_locked` enum('0','1') COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `friends`
    --

    CREATE TABLE `friends` (
      `id` int UNSIGNED NOT NULL,
      `user_one_id` int UNSIGNED NOT NULL,
      `user_two_id` int UNSIGNED NOT NULL,
      `status` tinyint(1) NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `funding_categories`
    --

    CREATE TABLE `funding_categories` (
      `category_id` int UNSIGNED NOT NULL,
      `category_parent_id` int UNSIGNED NOT NULL,
      `category_name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `category_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `category_order` int UNSIGNED NOT NULL DEFAULT '1'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    --
    -- Dumping data for table `funding_categories`
    --

    INSERT INTO `funding_categories` (`category_id`, `category_parent_id`, `category_name`, `category_description`, `category_order`) VALUES
    (1, 0, 'Medical', '', 1),
    (2, 0, 'Education', '', 2),
    (3, 0, 'Community', '', 3),
    (4, 0, 'Animals', '', 4),
    (5, 0, 'Environment', '', 5),
    (6, 0, 'Emergency', '', 6),
    (7, 0, 'Creative', '', 7),
    (8, 0, 'Other', '', 8);

    -- --------------------------------------------------------

    --
    -- Table structure for table `funding_payments`
    --

    CREATE TABLE `funding_payments` (
      `payment_id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `amount` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `method` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `method_value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `time` datetime NOT NULL,
      `status` tinyint(1) NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `games`
    --

    CREATE TABLE `games` (
      `game_id` int UNSIGNED NOT NULL,
      `title` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `description` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `genres` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
      `source` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `thumbnail` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `games_genres`
    --

    CREATE TABLE `games_genres` (
      `genre_id` int UNSIGNED NOT NULL,
      `genre_name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `genre_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `genre_order` int UNSIGNED NOT NULL DEFAULT '1'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    --
    -- Dumping data for table `games_genres`
    --

    INSERT INTO `games_genres` (`genre_id`, `genre_name`, `genre_description`, `genre_order`) VALUES
    (1, 'Action', '', 1),
    (2, 'Adventure', '', 2),
    (3, 'Animation', '', 3),
    (4, 'Comedy', '', 4),
    (5, 'Crime', '', 5),
    (6, 'Documentary', '', 6),
    (7, 'Drama', '', 7),
    (8, 'Family', '', 8),
    (9, 'Fantasy', '', 9),
    (10, 'History', '', 10),
    (11, 'Horror', '', 11),
    (12, 'Musical', '', 12),
    (13, 'Mythological', '', 13),
    (14, 'Romance', '', 14),
    (15, 'Sport', '', 15),
    (16, 'TV Show', '', 16),
    (17, 'Thriller', '', 17),
    (18, 'War', '', 18),
    (19, 'Others', '', 19),
    (20, 'Multiplayer', 'Multiplayer games', 20),
    (21, 'Racing', 'Racing games', 21),
    (22, 'Shooter', 'Shooter games', 22),
    (23, 'Puzzle', 'Puzzle games', 23);

    -- --------------------------------------------------------

    --
    -- Table structure for table `games_players`
    --

    CREATE TABLE `games_players` (
      `id` int UNSIGNED NOT NULL,
      `game_id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `last_played_time` datetime DEFAULT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `gifts`
    --

    CREATE TABLE `gifts` (
      `gift_id` int UNSIGNED NOT NULL,
      `image` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `points` int UNSIGNED NOT NULL DEFAULT '0'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `groups`
    --

    CREATE TABLE `groups` (
      `group_id` int UNSIGNED NOT NULL,
      `group_privacy` enum('secret','closed','public') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'public',
      `group_admin` int UNSIGNED NOT NULL,
      `group_category` int UNSIGNED NOT NULL,
      `group_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `group_title` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `group_country` int UNSIGNED NOT NULL,
      `group_language` int UNSIGNED NOT NULL,
      `group_description` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `group_publish_enabled` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1',
      `group_publish_approval_enabled` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `group_picture` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `group_picture_id` int UNSIGNED DEFAULT NULL,
      `group_cover` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `group_cover_id` int UNSIGNED DEFAULT NULL,
      `group_cover_position` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `group_album_pictures` int DEFAULT NULL,
      `group_album_covers` int DEFAULT NULL,
      `group_album_timeline` int DEFAULT NULL,
      `group_pinned_post` int DEFAULT NULL,
      `group_boosted` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `group_boosted_by` int UNSIGNED DEFAULT NULL,
      `group_members` int UNSIGNED NOT NULL DEFAULT '0',
      `group_monetization_enabled` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `group_monetization_discount_enabled` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `group_monetization_discount_percent` float NOT NULL DEFAULT '0',
      `group_monetization_min_price` float NOT NULL DEFAULT '0',
      `group_monetization_plans` int UNSIGNED NOT NULL DEFAULT '0',
      `chatbox_enabled` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `chatbox_conversation_id` int UNSIGNED DEFAULT NULL,
      `group_rate` float NOT NULL DEFAULT '0',
      `group_date` datetime NOT NULL,
      `is_fake` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `groups_admins`
    --

    CREATE TABLE `groups_admins` (
      `id` int UNSIGNED NOT NULL,
      `group_id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `groups_categories`
    --

    CREATE TABLE `groups_categories` (
      `category_id` int UNSIGNED NOT NULL,
      `category_parent_id` int UNSIGNED NOT NULL,
      `category_name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `category_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `category_order` int UNSIGNED NOT NULL DEFAULT '1'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    --
    -- Dumping data for table `groups_categories`
    --

    INSERT INTO `groups_categories` (`category_id`, `category_parent_id`, `category_name`, `category_description`, `category_order`) VALUES
    (1, 0, 'Cars and Vehicles', '', 1),
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

    -- --------------------------------------------------------

    --
    -- Table structure for table `groups_invites`
    --

    CREATE TABLE `groups_invites` (
      `id` int UNSIGNED NOT NULL,
      `group_id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `from_user_id` int UNSIGNED NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `groups_members`
    --

    CREATE TABLE `groups_members` (
      `id` int UNSIGNED NOT NULL,
      `group_id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `approved` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `hashtags`
    --

    CREATE TABLE `hashtags` (
      `hashtag_id` int UNSIGNED NOT NULL,
      `hashtag` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `hashtags_posts`
    --

    CREATE TABLE `hashtags_posts` (
      `id` int UNSIGNED NOT NULL,
      `post_id` int UNSIGNED NOT NULL,
      `hashtag_id` int UNSIGNED NOT NULL,
      `created_at` datetime DEFAULT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `invitation_codes`
    --

    CREATE TABLE `invitation_codes` (
      `code_id` int UNSIGNED NOT NULL,
      `code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `created_by` int UNSIGNED NOT NULL,
      `created_date` datetime NOT NULL,
      `used_by` int UNSIGNED DEFAULT NULL,
      `used_date` datetime DEFAULT NULL,
      `used` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `iyzico_payments`
    --

    CREATE TABLE `iyzico_payments` (
      `payment_id` int UNSIGNED NOT NULL,
      `payment_status` enum('pending','paid','failed') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'pending',
      `user_id` int UNSIGNED NOT NULL,
      `handle` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `reference_id` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `amount` float NOT NULL,
      `total_amount` float NOT NULL,
      `currency` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `promo_code` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `iyzico_conversation_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `iyzico_token` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `iyzico_payment_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `created_at` datetime NOT NULL,
      `updated_at` datetime DEFAULT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `jobs_categories`
    --

    CREATE TABLE `jobs_categories` (
      `category_id` int UNSIGNED NOT NULL,
      `category_parent_id` int UNSIGNED NOT NULL,
      `category_name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `category_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `category_order` int UNSIGNED NOT NULL DEFAULT '1'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    --
    -- Dumping data for table `jobs_categories`
    --

    INSERT INTO `jobs_categories` (`category_id`, `category_parent_id`, `category_name`, `category_description`, `category_order`) VALUES
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

    -- --------------------------------------------------------

    --
    -- Table structure for table `live_ingresses`
    --

    CREATE TABLE `live_ingresses` (
      `user_id` int UNSIGNED NOT NULL,
      `ingress_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `ingress_url` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `stream_key` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `ingress_room` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `time` datetime NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `live_moderation_log`
    --

    CREATE TABLE `live_moderation_log` (
      `log_id` int UNSIGNED NOT NULL,
      `host_type` enum('user','page') COLLATE utf8mb4_general_ci NOT NULL,
      `host_id` int UNSIGNED NOT NULL,
      `post_id` int UNSIGNED NOT NULL,
      `moderator_id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `action` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
      `details` varchar(256) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
      `time` datetime NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    -- --------------------------------------------------------

    --
    -- Table structure for table `live_moderation_settings`
    --

    CREATE TABLE `live_moderation_settings` (
      `host_type` enum('user','page') COLLATE utf8mb4_general_ci NOT NULL,
      `host_id` int UNSIGNED NOT NULL,
      `slow_mode` smallint UNSIGNED NOT NULL DEFAULT '0',
      `blocked_words` text COLLATE utf8mb4_general_ci,
      `links_blocked` enum('0','1') COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `repeats_blocked` enum('0','1') COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `rules` text COLLATE utf8mb4_general_ci
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    -- --------------------------------------------------------

    --
    -- Table structure for table `live_moderators`
    --

    CREATE TABLE `live_moderators` (
      `host_type` enum('user','page') COLLATE utf8mb4_general_ci NOT NULL,
      `host_id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `time` datetime NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    -- --------------------------------------------------------

    --
    -- Table structure for table `live_restrictions`
    --

    CREATE TABLE `live_restrictions` (
      `host_type` enum('user','page') COLLATE utf8mb4_general_ci NOT NULL,
      `host_id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `type` enum('timeout','mute','kick','ban') COLLATE utf8mb4_general_ci NOT NULL,
      `post_id` int UNSIGNED NOT NULL,
      `expires_at` datetime DEFAULT NULL,
      `moderator_id` int UNSIGNED NOT NULL,
      `time` datetime NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    -- --------------------------------------------------------

    --
    -- Table structure for table `log_commissions`
    --

    CREATE TABLE `log_commissions` (
      `payment_id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `amount` float NOT NULL,
      `handle` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `time` datetime NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `log_payments`
    --

    CREATE TABLE `log_payments` (
      `payment_id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `amount` float NOT NULL,
      `method` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `handle` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `time` datetime NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `log_points`
    --

    CREATE TABLE `log_points` (
      `log_id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `node_id` int UNSIGNED NOT NULL,
      `node_type` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `points` float NOT NULL,
      `is_added` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1',
      `time` datetime NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `log_subscriptions`
    --

    CREATE TABLE `log_subscriptions` (
      `payment_id` int UNSIGNED NOT NULL,
      `plan_title` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `subscriber_id` int UNSIGNED NOT NULL,
      `node_id` int UNSIGNED NOT NULL,
      `node_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
      `price` float NOT NULL,
      `commission` float NOT NULL,
      `time` datetime NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `market_categories`
    --

    CREATE TABLE `market_categories` (
      `category_id` int UNSIGNED NOT NULL,
      `category_parent_id` int UNSIGNED NOT NULL,
      `category_name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `category_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `category_order` int UNSIGNED NOT NULL DEFAULT '1'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    --
    -- Dumping data for table `market_categories`
    --

    INSERT INTO `market_categories` (`category_id`, `category_parent_id`, `category_name`, `category_description`, `category_order`) VALUES
    (1, 0, 'Apparel &amp; Accessories', '', 1),
    (2, 0, 'Autos &amp; Vehicles', '', 2),
    (3, 0, 'Baby &amp; Children&#039;s Products', '', 3),
    (4, 0, 'Beauty Products &amp; Services', '', 4),
    (5, 0, 'Computers &amp; Peripherals', '', 5),
    (6, 0, 'Consumer Electronics', '', 6),
    (7, 0, 'Dating Services', '', 7),
    (8, 0, 'Financial Services', '', 8),
    (9, 0, 'Gifts &amp; Occasions', '', 9),
    (10, 0, 'Home &amp; Garden', '', 10),
    (11, 0, 'Other', '', 11);

    -- --------------------------------------------------------

    --
    -- Table structure for table `market_payments`
    --

    CREATE TABLE `market_payments` (
      `payment_id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `amount` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `method` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `method_value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `time` datetime NOT NULL,
      `status` tinyint(1) NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `merits_categories`
    --

    CREATE TABLE `merits_categories` (
      `category_id` int UNSIGNED NOT NULL,
      `category_parent_id` int UNSIGNED NOT NULL,
      `category_name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `category_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `category_image` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `category_order` int UNSIGNED NOT NULL DEFAULT '1'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    --
    -- Dumping data for table `merits_categories`
    --

    INSERT INTO `merits_categories` (`category_id`, `category_parent_id`, `category_name`, `category_description`, `category_image`, `category_order`) VALUES
    (1, 0, 'Respect', 'Respect', 'merits/Respect.png', 1),
    (2, 0, 'Integrity', 'Integrit', 'merits/Integrity.png', 2),
    (3, 0, 'Collaboration', 'Collaboration', 'merits/Collaboration.png', 3),
    (4, 0, 'Quality', 'Quality', 'merits/Quality.png', 4);

    -- --------------------------------------------------------

    --
    -- Table structure for table `monetization_coupons`
    --

    CREATE TABLE `monetization_coupons` (
      `coupon_id` int UNSIGNED NOT NULL,
      `coupon_code` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
      `discount_percent` float UNSIGNED NOT NULL,
      `is_onetime` enum('0','1') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '0',
      `node_id` int UNSIGNED NOT NULL,
      `node_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `created_date` datetime NOT NULL,
      `used` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `usage_counter` int UNSIGNED NOT NULL DEFAULT '0'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

    -- --------------------------------------------------------

    --
    -- Table structure for table `monetization_coupons_users`
    --

    CREATE TABLE `monetization_coupons_users` (
      `id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `coupon_id` int UNSIGNED NOT NULL,
      `used_date` datetime DEFAULT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

    -- --------------------------------------------------------

    --
    -- Table structure for table `monetization_payments`
    --

    CREATE TABLE `monetization_payments` (
      `payment_id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `amount` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `method` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `method_value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `time` datetime NOT NULL,
      `status` tinyint(1) NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `monetization_plans`
    --

    CREATE TABLE `monetization_plans` (
      `plan_id` int UNSIGNED NOT NULL,
      `node_id` int UNSIGNED NOT NULL,
      `node_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `title` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `price` float NOT NULL,
      `period_num` int UNSIGNED NOT NULL,
      `period` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `custom_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
      `plan_order` int UNSIGNED NOT NULL DEFAULT '1',
      `paypal_billing_plan` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `stripe_billing_plan` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `movies`
    --

    CREATE TABLE `movies` (
      `movie_id` int UNSIGNED NOT NULL,
      `source` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `source_type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `title` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
      `imdb_url` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
      `stars` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
      `release_year` int DEFAULT NULL,
      `duration` int DEFAULT NULL,
      `genres` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
      `poster` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `views` int UNSIGNED NOT NULL DEFAULT '0',
      `is_paid` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `price` float NOT NULL DEFAULT '0',
      `available_for` int NOT NULL DEFAULT '0'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `movies_genres`
    --

    CREATE TABLE `movies_genres` (
      `genre_id` int UNSIGNED NOT NULL,
      `genre_name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `genre_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `genre_order` int UNSIGNED NOT NULL DEFAULT '1'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    --
    -- Dumping data for table `movies_genres`
    --

    INSERT INTO `movies_genres` (`genre_id`, `genre_name`, `genre_description`, `genre_order`) VALUES
    (1, 'Action', '', 1),
    (2, 'Adventure', '', 2),
    (3, 'Animation', '', 3),
    (4, 'Comedy', '', 4),
    (5, 'Crime', '', 5),
    (6, 'Documentary', '', 6),
    (7, 'Drama', '', 7),
    (8, 'Family', '', 8),
    (9, 'Fantasy', '', 9),
    (10, 'History', '', 10),
    (11, 'Horror', '', 11),
    (12, 'Musical', '', 12),
    (13, 'Mythological', '', 13),
    (14, 'Romance', '', 14),
    (15, 'Sport', '', 15),
    (16, 'TV Show', '', 16),
    (17, 'Thriller', '', 17),
    (18, 'War', '', 18),
    (19, 'Science Fiction', 'Science Fiction movies', 19),
    (20, 'Mystery', 'Mystery movies', 20);

    -- --------------------------------------------------------

    --
    -- Table structure for table `movies_payments`
    --

    CREATE TABLE `movies_payments` (
      `id` int UNSIGNED NOT NULL,
      `movie_id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `payment_time` datetime NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `notifications`
    --

    CREATE TABLE `notifications` (
      `notification_id` int UNSIGNED NOT NULL,
      `to_user_id` int UNSIGNED NOT NULL,
      `from_user_id` int UNSIGNED NOT NULL,
      `from_user_type` enum('user','page') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'user',
      `action` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `node_type` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `node_url` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `notify_id` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `message` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
      `time` datetime DEFAULT NULL,
      `seen` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `offers_categories`
    --

    CREATE TABLE `offers_categories` (
      `category_id` int UNSIGNED NOT NULL,
      `category_parent_id` int UNSIGNED NOT NULL,
      `category_name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `category_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `category_order` int UNSIGNED NOT NULL DEFAULT '1'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    --
    -- Dumping data for table `offers_categories`
    --

    INSERT INTO `offers_categories` (`category_id`, `category_parent_id`, `category_name`, `category_description`, `category_order`) VALUES
    (1, 0, 'Apparel &amp; Accessories', '', 1),
    (2, 0, 'Autos &amp; Vehicles', '', 2),
    (3, 0, 'Baby &amp; Children&#039;s Products', '', 3),
    (4, 0, 'Beauty Products &amp; Services', '', 4),
    (5, 0, 'Computers &amp; Peripherals', '', 5),
    (6, 0, 'Consumer Electronics', '', 6),
    (7, 0, 'Dating Services', '', 7),
    (8, 0, 'Financial Services', '', 8),
    (9, 0, 'Gifts &amp; Occasions', '', 9),
    (10, 0, 'Home &amp; Garden', '', 10),
    (11, 0, 'Other', '', 11);

    -- --------------------------------------------------------

    --
    -- Table structure for table `orders`
    --

    CREATE TABLE `orders` (
      `order_id` int UNSIGNED NOT NULL,
      `order_hash` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `order_collection_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `is_payment_done` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `is_cash_on_delivery` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `is_digital` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `seller_id` int UNSIGNED NOT NULL,
      `seller_page_id` int UNSIGNED NOT NULL DEFAULT '0',
      `buyer_id` int UNSIGNED NOT NULL,
      `buyer_address_id` int UNSIGNED NOT NULL,
      `sub_total` float UNSIGNED NOT NULL DEFAULT '0',
      `commission` float UNSIGNED NOT NULL,
      `status` enum('placed','canceled','accepted','packed','shipped','delivered') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'placed',
      `tracking_link` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
      `tracking_number` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
      `insert_time` datetime NOT NULL,
      `update_time` datetime NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    -- --------------------------------------------------------

    --
    -- Table structure for table `orders_items`
    --

    CREATE TABLE `orders_items` (
      `id` int UNSIGNED NOT NULL,
      `order_id` int UNSIGNED NOT NULL,
      `product_post_id` int UNSIGNED NOT NULL,
      `quantity` int UNSIGNED NOT NULL,
      `price` float UNSIGNED NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    -- --------------------------------------------------------

    --
    -- Table structure for table `packages`
    --

    CREATE TABLE `packages` (
      `package_id` int UNSIGNED NOT NULL,
      `name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `price` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `period_num` int UNSIGNED NOT NULL,
      `period` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `color` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `icon` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `custom_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
      `package_order` int UNSIGNED NOT NULL DEFAULT '1',
      `package_hidden` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `package_popular` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `verification_badge_enabled` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `package_permissions_group_id` int UNSIGNED NOT NULL DEFAULT '0',
      `allowed_blogs_categories` int NOT NULL DEFAULT '0',
      `allowed_videos_categories` int NOT NULL DEFAULT '0',
      `allowed_products` int NOT NULL DEFAULT '0',
      `free_points` int UNSIGNED NOT NULL,
      `boost_posts_enabled` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `boost_posts` int UNSIGNED NOT NULL,
      `boost_pages_enabled` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `boost_pages` int UNSIGNED NOT NULL,
      `boost_groups_enabled` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `boost_groups` int UNSIGNED NOT NULL,
      `boost_events_enabled` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `boost_events` int UNSIGNED NOT NULL,
      `paypal_billing_plan` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `stripe_billing_plan` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `dating_unlimited_swipes_enabled` enum('0','1') COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `dating_likes_list_enabled` enum('0','1') COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `dating_rewind_enabled` enum('0','1') COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `dating_incognito_enabled` enum('0','1') COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `dating_super_likes` int UNSIGNED NOT NULL DEFAULT '0',
      `dating_boosts` int UNSIGNED NOT NULL DEFAULT '0'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `packages_payments`
    --

    CREATE TABLE `packages_payments` (
      `payment_id` int UNSIGNED NOT NULL,
      `payment_date` datetime NOT NULL,
      `package_name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `package_price` float UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `pages`
    --

    CREATE TABLE `pages` (
      `page_id` int UNSIGNED NOT NULL,
      `page_admin` int UNSIGNED NOT NULL,
      `page_category` int UNSIGNED NOT NULL,
      `page_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `page_title` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `page_picture` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `page_picture_id` int UNSIGNED DEFAULT NULL,
      `page_cover` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `page_cover_id` int UNSIGNED DEFAULT NULL,
      `page_cover_position` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `page_album_pictures` int UNSIGNED DEFAULT NULL,
      `page_album_covers` int UNSIGNED DEFAULT NULL,
      `page_album_timeline` int UNSIGNED DEFAULT NULL,
      `page_pinned_post` int UNSIGNED DEFAULT NULL,
      `page_verified` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `page_tips_enabled` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `page_messages_enabled` enum('0','1') COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `page_boosted` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `page_boosted_by` int UNSIGNED DEFAULT NULL,
      `page_company` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `page_phone` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `page_website` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `page_location` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `page_latitude` decimal(10,7) DEFAULT NULL,
      `page_longitude` decimal(10,7) DEFAULT NULL,
      `page_country` int UNSIGNED NOT NULL,
      `page_language` int UNSIGNED NOT NULL,
      `page_description` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `page_action_text` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `page_action_color` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `page_action_url` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `page_social_facebook` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `page_social_twitter` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `page_social_youtube` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `page_social_instagram` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `page_social_linkedin` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `page_social_vkontakte` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `page_likes` int UNSIGNED NOT NULL DEFAULT '0',
      `page_monetization_enabled` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `page_monetization_discount_enabled` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `page_monetization_discount_percent` float NOT NULL DEFAULT '0',
      `page_monetization_min_price` float NOT NULL DEFAULT '0',
      `page_monetization_plans` int UNSIGNED NOT NULL DEFAULT '0',
      `page_rate` float NOT NULL DEFAULT '0',
      `page_pbid` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `page_date` datetime NOT NULL,
      `is_fake` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `pages_admins`
    --

    CREATE TABLE `pages_admins` (
      `id` int UNSIGNED NOT NULL,
      `page_id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `pages_categories`
    --

    CREATE TABLE `pages_categories` (
      `category_id` int UNSIGNED NOT NULL,
      `category_parent_id` int UNSIGNED NOT NULL,
      `category_name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `category_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `category_order` int UNSIGNED NOT NULL DEFAULT '1'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    --
    -- Dumping data for table `pages_categories`
    --

    INSERT INTO `pages_categories` (`category_id`, `category_parent_id`, `category_name`, `category_description`, `category_order`) VALUES
    (1, 0, 'Cars and Vehicles', '', 1),
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

    -- --------------------------------------------------------

    --
    -- Table structure for table `pages_conversations`
    --

    CREATE TABLE `pages_conversations` (
      `id` int UNSIGNED NOT NULL,
      `page_id` int UNSIGNED NOT NULL,
      `conversation_id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `seen` enum('0','1') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0',
      `typing` enum('0','1') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

    -- --------------------------------------------------------

    --
    -- Table structure for table `pages_invites`
    --

    CREATE TABLE `pages_invites` (
      `id` int UNSIGNED NOT NULL,
      `page_id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `from_user_id` int UNSIGNED NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `pages_likes`
    --

    CREATE TABLE `pages_likes` (
      `id` int UNSIGNED NOT NULL,
      `page_id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `permissions_groups`
    --

    CREATE TABLE `permissions_groups` (
      `permissions_group_id` int UNSIGNED NOT NULL,
      `permissions_group_title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `pages_permission` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `groups_permission` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `events_permission` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `reels_permission` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `watch_permission` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `blogs_permission` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `blogs_permission_read` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `market_permission` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `offers_permission` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `offers_permission_read` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `jobs_permission` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `courses_permission` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `forums_permission` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `movies_permission` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `games_permission` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `gifts_permission` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `ai_posts_permission` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `ai_blogs_permission` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `ai_images_permission` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `stories_permission` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `posts_permission` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `comments_permission` enum('0','1') COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1',
      `schedule_posts_permission` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `anonymous_posts_permission` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `collaborative_posts_permission` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `rich_text_posts_permission` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `colored_posts_permission` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `activity_posts_permission` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `polls_posts_permission` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `geolocation_posts_permission` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `gif_posts_permission` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `invitation_permission` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `audio_call_permission` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `video_call_permission` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `live_permission` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `videos_upload_permission` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `audios_upload_permission` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `files_upload_permission` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `ads_permission` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `funding_permission` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `monetization_permission` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `tips_permission` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `custom_affiliates_system` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `affiliates_per_user` float UNSIGNED NOT NULL DEFAULT '0',
      `affiliates_percentage` float UNSIGNED NOT NULL DEFAULT '0',
      `affiliates_per_user_2` float UNSIGNED NOT NULL DEFAULT '0',
      `affiliates_percentage_2` float UNSIGNED NOT NULL DEFAULT '0',
      `affiliates_per_user_3` float UNSIGNED NOT NULL DEFAULT '0',
      `affiliates_percentage_3` float UNSIGNED NOT NULL DEFAULT '0',
      `affiliates_per_user_4` float UNSIGNED NOT NULL DEFAULT '0',
      `affiliates_percentage_4` float UNSIGNED NOT NULL DEFAULT '0',
      `affiliates_per_user_5` float UNSIGNED NOT NULL DEFAULT '0',
      `affiliates_percentage_5` float UNSIGNED NOT NULL DEFAULT '0',
      `affiliates_per_user_6` float UNSIGNED NOT NULL DEFAULT '0',
      `affiliates_percentage_6` float UNSIGNED NOT NULL DEFAULT '0',
      `affiliates_per_user_7` float UNSIGNED NOT NULL DEFAULT '0',
      `affiliates_percentage_7` float UNSIGNED NOT NULL DEFAULT '0',
      `affiliates_per_user_8` float UNSIGNED NOT NULL DEFAULT '0',
      `affiliates_percentage_8` float UNSIGNED NOT NULL DEFAULT '0',
      `affiliates_per_user_9` float UNSIGNED NOT NULL DEFAULT '0',
      `affiliates_percentage_9` float UNSIGNED NOT NULL DEFAULT '0',
      `affiliates_per_user_10` float UNSIGNED NOT NULL DEFAULT '0',
      `affiliates_percentage_10` float UNSIGNED NOT NULL DEFAULT '0',
      `custom_points_system` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `points_per_currency` int UNSIGNED NOT NULL DEFAULT '100',
      `dating_permission` enum('0','1') COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    --
    -- Dumping data for table `permissions_groups`
    --

    INSERT INTO `permissions_groups` (`permissions_group_id`, `permissions_group_title`, `pages_permission`, `groups_permission`, `events_permission`, `reels_permission`, `watch_permission`, `blogs_permission`, `blogs_permission_read`, `market_permission`, `offers_permission`, `offers_permission_read`, `jobs_permission`, `courses_permission`, `forums_permission`, `movies_permission`, `games_permission`, `gifts_permission`, `ai_posts_permission`, `ai_blogs_permission`, `ai_images_permission`, `stories_permission`, `posts_permission`, `comments_permission`, `schedule_posts_permission`, `anonymous_posts_permission`, `collaborative_posts_permission`, `rich_text_posts_permission`, `colored_posts_permission`, `activity_posts_permission`, `polls_posts_permission`, `geolocation_posts_permission`, `gif_posts_permission`, `invitation_permission`, `audio_call_permission`, `video_call_permission`, `live_permission`, `videos_upload_permission`, `audios_upload_permission`, `files_upload_permission`, `ads_permission`, `funding_permission`, `monetization_permission`, `tips_permission`, `custom_affiliates_system`, `affiliates_per_user`, `affiliates_percentage`, `affiliates_per_user_2`, `affiliates_percentage_2`, `affiliates_per_user_3`, `affiliates_percentage_3`, `affiliates_per_user_4`, `affiliates_percentage_4`, `affiliates_per_user_5`, `affiliates_percentage_5`, `affiliates_per_user_6`, `affiliates_percentage_6`, `affiliates_per_user_7`, `affiliates_percentage_7`, `affiliates_per_user_8`, `affiliates_percentage_8`, `affiliates_per_user_9`, `affiliates_percentage_9`, `affiliates_per_user_10`, `affiliates_percentage_10`, `custom_points_system`, `points_per_currency`, `dating_permission`) VALUES
    (1, 'Users Permissions', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0', 100, '1'),
    (2, 'Verified Permissions', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '0', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0', 100, '1');

    -- --------------------------------------------------------

    --
    -- Table structure for table `plisio_payments`
    --

    CREATE TABLE `plisio_payments` (
      `payment_id` int UNSIGNED NOT NULL,
      `payment_status` enum('pending','paid','failed') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'pending',
      `user_id` int UNSIGNED NOT NULL,
      `handle` varchar(64) COLLATE utf8mb4_general_ci NOT NULL,
      `reference_id` varchar(256) COLLATE utf8mb4_general_ci DEFAULT NULL,
      `amount` float NOT NULL,
      `total_amount` float NOT NULL,
      `currency` varchar(8) COLLATE utf8mb4_general_ci NOT NULL,
      `plisio_hash` varchar(128) COLLATE utf8mb4_general_ci NOT NULL,
      `plisio_txn_id` varchar(128) COLLATE utf8mb4_general_ci NOT NULL,
      `created_at` datetime NOT NULL,
      `updated_at` datetime DEFAULT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `points_payments`
    --

    CREATE TABLE `points_payments` (
      `payment_id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `amount` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `method` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `method_value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `time` datetime NOT NULL,
      `status` tinyint(1) NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `posts`
    --

    CREATE TABLE `posts` (
      `post_id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `user_type` enum('user','page') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `in_group` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `group_id` int UNSIGNED DEFAULT NULL,
      `group_approved` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1',
      `in_event` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `event_id` int UNSIGNED DEFAULT NULL,
      `event_approved` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1',
      `in_wall` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `wall_id` int UNSIGNED DEFAULT NULL,
      `is_collaborative` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `collaborative_percent` float UNSIGNED NOT NULL DEFAULT '0',
      `post_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `colored_pattern` int UNSIGNED DEFAULT NULL,
      `origin_id` int UNSIGNED DEFAULT NULL,
      `time` datetime NOT NULL,
      `location` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `location_latitude` decimal(10,7) DEFAULT NULL,
      `location_longitude` decimal(10,7) DEFAULT NULL,
      `privacy` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `text` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
      `feeling_action` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `feeling_value` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `boosted` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `boosted_by` int UNSIGNED DEFAULT NULL,
      `comments_disabled` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `is_hidden` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `is_schedule` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `for_adult` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `is_anonymous` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `reaction_like_count` int UNSIGNED NOT NULL DEFAULT '0',
      `reaction_love_count` int UNSIGNED NOT NULL DEFAULT '0',
      `reaction_haha_count` int UNSIGNED NOT NULL DEFAULT '0',
      `reaction_yay_count` int UNSIGNED NOT NULL DEFAULT '0',
      `reaction_wow_count` int UNSIGNED NOT NULL DEFAULT '0',
      `reaction_sad_count` int UNSIGNED NOT NULL DEFAULT '0',
      `reaction_angry_count` int UNSIGNED NOT NULL DEFAULT '0',
      `comments` int UNSIGNED NOT NULL DEFAULT '0',
      `shares` int UNSIGNED NOT NULL DEFAULT '0',
      `views` int UNSIGNED NOT NULL DEFAULT '0',
      `post_rate` float NOT NULL DEFAULT '0',
      `points_earned` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `tips_enabled` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `for_subscriptions` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `subscriptions_image` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `is_paid` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `is_paid_locked` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `post_price` float UNSIGNED NOT NULL DEFAULT '0',
      `paid_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
      `paid_image` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `processing` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `pre_approved` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1',
      `has_approved` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `post_latitude` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `post_longitude` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `photo_layout` varchar(16) COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'classic'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `posts_articles`
    --

    CREATE TABLE `posts_articles` (
      `article_id` int UNSIGNED NOT NULL,
      `post_id` int UNSIGNED NOT NULL,
      `cover` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `title` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `category_id` int UNSIGNED NOT NULL,
      `tags` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `posts_articles_references`
    --

    CREATE TABLE `posts_articles_references` (
      `refrence_id` int UNSIGNED NOT NULL,
      `post_id` int UNSIGNED NOT NULL,
      `title` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `link` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `posts_audios`
    --

    CREATE TABLE `posts_audios` (
      `audio_id` int UNSIGNED NOT NULL,
      `post_id` int UNSIGNED NOT NULL,
      `source` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `views` int NOT NULL DEFAULT '0'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `posts_cache`
    --

    CREATE TABLE `posts_cache` (
      `cache_id` int UNSIGNED NOT NULL,
      `cache_date` datetime NOT NULL,
      `post_id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `posts_collaborative_users`
    --

    CREATE TABLE `posts_collaborative_users` (
      `id` int UNSIGNED NOT NULL,
      `post_id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `posts_colored_patterns`
    --

    CREATE TABLE `posts_colored_patterns` (
      `pattern_id` int UNSIGNED NOT NULL,
      `type` enum('color','image') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'color',
      `background_image` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `background_color_1` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `background_color_2` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `text_color` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    --
    -- Dumping data for table `posts_colored_patterns`
    --

    INSERT INTO `posts_colored_patterns` (`pattern_id`, `type`, `background_image`, `background_color_1`, `background_color_2`, `text_color`) VALUES
    (1, 'image', 'patterns/1.jpg', NULL, NULL, '#FFFFFF'),
    (2, 'image', 'patterns/2.jpg', NULL, NULL, '#FFFFFF'),
    (3, 'image', 'patterns/3.jpg', NULL, NULL, '#FFFFFF'),
    (4, 'image', 'patterns/4.jpg', '', '', '#000000'),
    (5, 'image', 'patterns/5.jpg', NULL, NULL, '#FFFFFF'),
    (6, 'color', NULL, '#FF00FF', '#030355', '#FFF300'),
    (7, 'color', '', '#FF003D', '#D73A3A', '#FFFFFF');

    -- --------------------------------------------------------

    --
    -- Table structure for table `posts_comments`
    --

    CREATE TABLE `posts_comments` (
      `comment_id` int UNSIGNED NOT NULL,
      `node_id` int UNSIGNED NOT NULL,
      `node_type` enum('post','photo','comment') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `user_type` enum('user','page') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `text` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `image` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `gif` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `voice_note` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `time` datetime NOT NULL,
      `reaction_like_count` int UNSIGNED NOT NULL DEFAULT '0',
      `reaction_love_count` int UNSIGNED NOT NULL DEFAULT '0',
      `reaction_haha_count` int UNSIGNED NOT NULL DEFAULT '0',
      `reaction_yay_count` int UNSIGNED NOT NULL DEFAULT '0',
      `reaction_wow_count` int UNSIGNED NOT NULL DEFAULT '0',
      `reaction_sad_count` int UNSIGNED NOT NULL DEFAULT '0',
      `reaction_angry_count` int UNSIGNED NOT NULL DEFAULT '0',
      `replies` int UNSIGNED NOT NULL DEFAULT '0',
      `points_earned` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `posts_comments_reactions`
    --

    CREATE TABLE `posts_comments_reactions` (
      `id` int UNSIGNED NOT NULL,
      `comment_id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `reaction` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'like',
      `reaction_time` datetime DEFAULT NULL,
      `points_earned` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `posts_courses`
    --

    CREATE TABLE `posts_courses` (
      `course_id` int UNSIGNED NOT NULL,
      `post_id` int UNSIGNED NOT NULL,
      `category_id` int UNSIGNED NOT NULL,
      `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `location` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `fees` float UNSIGNED NOT NULL,
      `fees_currency` int UNSIGNED NOT NULL,
      `start_date` datetime NOT NULL,
      `end_date` datetime NOT NULL,
      `cover_image` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `available` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `posts_courses_applications`
    --

    CREATE TABLE `posts_courses_applications` (
      `application_id` int UNSIGNED NOT NULL,
      `post_id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `location` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `phone` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `applied_time` datetime NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `posts_files`
    --

    CREATE TABLE `posts_files` (
      `file_id` int UNSIGNED NOT NULL,
      `post_id` int UNSIGNED NOT NULL,
      `source` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `name` varchar(256) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
      `size` bigint UNSIGNED NOT NULL DEFAULT '0'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `posts_funding`
    --

    CREATE TABLE `posts_funding` (
      `funding_id` int UNSIGNED NOT NULL,
      `post_id` int UNSIGNED NOT NULL,
      `title` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `amount` float NOT NULL DEFAULT '0',
      `raised_amount` float NOT NULL DEFAULT '0',
      `total_donations` int NOT NULL DEFAULT '0',
      `cover_image` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `category_id` int UNSIGNED NOT NULL DEFAULT '0'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `posts_funding_donors`
    --

    CREATE TABLE `posts_funding_donors` (
      `donation_id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `post_id` int UNSIGNED NOT NULL,
      `donation_amount` float UNSIGNED NOT NULL DEFAULT '0',
      `donation_time` datetime NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `posts_hidden`
    --

    CREATE TABLE `posts_hidden` (
      `id` int UNSIGNED NOT NULL,
      `post_id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `posts_jobs`
    --

    CREATE TABLE `posts_jobs` (
      `job_id` int UNSIGNED NOT NULL,
      `post_id` int UNSIGNED NOT NULL,
      `category_id` int UNSIGNED NOT NULL,
      `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `location` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `salary_minimum` float UNSIGNED NOT NULL,
      `salary_minimum_currency` int UNSIGNED NOT NULL,
      `salary_maximum` float UNSIGNED NOT NULL,
      `salary_maximum_currency` int UNSIGNED NOT NULL,
      `pay_salary_per` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `question_1_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `question_1_title` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `question_1_choices` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
      `question_2_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `question_2_title` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `question_2_choices` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
      `question_3_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `question_3_title` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `question_3_choices` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
      `cover_image` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `available` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `posts_jobs_applications`
    --

    CREATE TABLE `posts_jobs_applications` (
      `application_id` int UNSIGNED NOT NULL,
      `post_id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `location` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `phone` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `work_place` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `work_position` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `work_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
      `work_from` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `work_to` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `work_now` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `question_1_answer` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
      `question_2_answer` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
      `question_3_answer` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
      `cv` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `applied_time` datetime NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `posts_links`
    --

    CREATE TABLE `posts_links` (
      `link_id` int UNSIGNED NOT NULL,
      `post_id` int UNSIGNED NOT NULL,
      `source_url` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `source_host` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `source_title` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `source_text` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `source_thumbnail` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `posts_live`
    --

    CREATE TABLE `posts_live` (
      `live_id` int UNSIGNED NOT NULL,
      `post_id` int UNSIGNED NOT NULL,
      `category_id` int UNSIGNED NOT NULL DEFAULT '0',
      `live_title` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `broadcast_type` enum('camera','rtmp') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'camera',
      `live_provider` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'agora',
      `video_thumbnail` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `agora_uid` int NOT NULL,
      `agora_channel_name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `agora_resource_id` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
      `agora_sid` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `agora_file` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
      `livekit_room` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `livekit_egress_id` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `livekit_file` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
      `live_ended` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `live_recorded` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `livekit_ingress_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `posts_live_categories`
    --

    CREATE TABLE `posts_live_categories` (
      `category_id` int UNSIGNED NOT NULL,
      `category_parent_id` int UNSIGNED NOT NULL,
      `category_name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `category_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `category_order` int UNSIGNED NOT NULL DEFAULT '1'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    --
    -- Dumping data for table `posts_live_categories`
    --

    INSERT INTO `posts_live_categories` (`category_id`, `category_parent_id`, `category_name`, `category_description`, `category_order`) VALUES
    (1, 0, 'Social &amp; Talk', 'Conversations, Q&amp;A, hanging out, discussions', 1),
    (2, 0, 'Gaming', 'Gameplay, esports, game discussions', 2),
    (3, 0, 'Music', 'Performances, DJ sets, singing, instruments', 3),
    (4, 0, 'Sports', 'Matches, commentary, workouts, sports discussions', 4),
    (5, 0, 'Entertainment', 'Shows, performances, reactions, events', 5),
    (6, 0, 'Creative', 'Art, design, photography, crafts, making things', 6),
    (7, 0, 'Learning', 'Tutorials, classes, coding, educational streams', 7),
    (8, 0, 'Lifestyle', 'Cooking, travel, fitness, beauty, daily life', 8),
    (9, 0, 'News &amp; Events', 'Conferences, announcements, public events', 9),
    (10, 0, 'Other', 'Anything that doesn\'t fit elsewhere', 10);

    -- --------------------------------------------------------

    --
    -- Table structure for table `posts_live_users`
    --

    CREATE TABLE `posts_live_users` (
      `id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `post_id` int UNSIGNED NOT NULL,
      `media_id` varchar(64) COLLATE utf8mb4_general_ci NOT NULL DEFAULT ''
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `posts_locations`
    --

    CREATE TABLE `posts_locations` (
      `post_id` int UNSIGNED NOT NULL,
      `post_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `location` point NOT NULL /*!80003 SRID 0 */
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    -- --------------------------------------------------------

    --
    -- Table structure for table `posts_media`
    --

    CREATE TABLE `posts_media` (
      `media_id` int UNSIGNED NOT NULL,
      `post_id` int NOT NULL,
      `source_url` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `source_provider` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `source_type` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `source_title` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
      `source_text` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
      `source_html` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
      `source_thumbnail` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `posts_merits`
    --

    CREATE TABLE `posts_merits` (
      `merit_id` int UNSIGNED NOT NULL,
      `post_id` int UNSIGNED NOT NULL,
      `category_id` int UNSIGNED NOT NULL,
      `message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `image` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `posts_offers`
    --

    CREATE TABLE `posts_offers` (
      `offer_id` int UNSIGNED NOT NULL,
      `post_id` int UNSIGNED NOT NULL,
      `category_id` int UNSIGNED NOT NULL,
      `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `discount_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `discount_percent` int UNSIGNED NOT NULL,
      `discount_amount` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `buy_x` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `get_y` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `spend_x` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `amount_y` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `end_date` datetime DEFAULT NULL,
      `price` float UNSIGNED NOT NULL DEFAULT '0',
      `thumbnail` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `posts_paid`
    --

    CREATE TABLE `posts_paid` (
      `id` int UNSIGNED NOT NULL,
      `post_id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `time` datetime NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `posts_photos`
    --

    CREATE TABLE `posts_photos` (
      `photo_id` int UNSIGNED NOT NULL,
      `post_id` int UNSIGNED NOT NULL,
      `album_id` int UNSIGNED DEFAULT NULL,
      `source` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `blur` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `pinned` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `reaction_like_count` int UNSIGNED NOT NULL DEFAULT '0',
      `reaction_love_count` int UNSIGNED NOT NULL DEFAULT '0',
      `reaction_haha_count` int UNSIGNED NOT NULL DEFAULT '0',
      `reaction_yay_count` int UNSIGNED NOT NULL DEFAULT '0',
      `reaction_wow_count` int UNSIGNED NOT NULL DEFAULT '0',
      `reaction_sad_count` int UNSIGNED NOT NULL DEFAULT '0',
      `reaction_angry_count` int UNSIGNED NOT NULL DEFAULT '0',
      `comments` int UNSIGNED NOT NULL DEFAULT '0',
      `sort_order` int UNSIGNED NOT NULL DEFAULT '0'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `posts_photos_albums`
    --

    CREATE TABLE `posts_photos_albums` (
      `album_id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `user_type` enum('user','page') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `in_group` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `group_id` int UNSIGNED DEFAULT NULL,
      `in_event` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `event_id` int UNSIGNED DEFAULT NULL,
      `title` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `privacy` enum('me','friends','public','custom') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'public'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `posts_photos_reactions`
    --

    CREATE TABLE `posts_photos_reactions` (
      `id` int UNSIGNED NOT NULL,
      `photo_id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `reaction` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'like',
      `reaction_time` datetime DEFAULT NULL,
      `points_earned` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `posts_polls`
    --

    CREATE TABLE `posts_polls` (
      `poll_id` int UNSIGNED NOT NULL,
      `post_id` int UNSIGNED NOT NULL,
      `votes` int UNSIGNED NOT NULL DEFAULT '0',
      `edit_locked` tinyint UNSIGNED NOT NULL DEFAULT '0'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `posts_polls_options`
    --

    CREATE TABLE `posts_polls_options` (
      `option_id` int UNSIGNED NOT NULL,
      `poll_id` int UNSIGNED NOT NULL,
      `text` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `posts_polls_options_users`
    --

    CREATE TABLE `posts_polls_options_users` (
      `id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `poll_id` int UNSIGNED NOT NULL,
      `option_id` int UNSIGNED NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `posts_products`
    --

    CREATE TABLE `posts_products` (
      `product_id` int UNSIGNED NOT NULL,
      `post_id` int UNSIGNED NOT NULL,
      `name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `price` float UNSIGNED NOT NULL DEFAULT '0',
      `quantity` int UNSIGNED NOT NULL DEFAULT '1',
      `category_id` int UNSIGNED NOT NULL,
      `status` enum('new','old') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'new',
      `location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `available` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1',
      `is_digital` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `product_download_url` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
      `product_file_source` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `posts_reactions`
    --

    CREATE TABLE `posts_reactions` (
      `id` int UNSIGNED NOT NULL,
      `post_id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `reaction` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'like',
      `reaction_time` datetime DEFAULT NULL,
      `points_earned` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `posts_reels`
    --

    CREATE TABLE `posts_reels` (
      `reel_id` int UNSIGNED NOT NULL,
      `post_id` int UNSIGNED NOT NULL,
      `source` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `source_240p` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `source_360p` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `source_480p` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `source_720p` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `source_1080p` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `source_1440p` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `source_2160p` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `thumbnail` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `views` int NOT NULL DEFAULT '0'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `posts_rich_text`
    --

    CREATE TABLE `posts_rich_text` (
      `rich_text_id` int UNSIGNED NOT NULL,
      `post_id` int UNSIGNED NOT NULL,
      `text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `posts_saved`
    --

    CREATE TABLE `posts_saved` (
      `id` int UNSIGNED NOT NULL,
      `post_id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `time` datetime NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `posts_search`
    --

    CREATE TABLE `posts_search` (
      `post_id` int UNSIGNED NOT NULL,
      `search_text` mediumtext COLLATE utf8mb4_general_ci NOT NULL,
      `search_body` mediumtext COLLATE utf8mb4_general_ci NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `posts_videos`
    --

    CREATE TABLE `posts_videos` (
      `video_id` int UNSIGNED NOT NULL,
      `post_id` int UNSIGNED NOT NULL,
      `category_id` int UNSIGNED NOT NULL,
      `source` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `source_240p` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `source_360p` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `source_480p` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `source_720p` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `source_1080p` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `source_1440p` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `source_2160p` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `thumbnail` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `width` smallint UNSIGNED DEFAULT NULL,
      `height` smallint UNSIGNED DEFAULT NULL,
      `views` int NOT NULL DEFAULT '0'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `posts_videos_categories`
    --

    CREATE TABLE `posts_videos_categories` (
      `category_id` int UNSIGNED NOT NULL,
      `category_parent_id` int UNSIGNED NOT NULL,
      `category_name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `category_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `category_order` int UNSIGNED NOT NULL DEFAULT '1'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    --
    -- Dumping data for table `posts_videos_categories`
    --

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

    -- --------------------------------------------------------

    --
    -- Table structure for table `posts_views`
    --

    CREATE TABLE `posts_views` (
      `view_id` int UNSIGNED NOT NULL,
      `view_date` datetime NOT NULL,
      `post_id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED DEFAULT NULL,
      `guest_ip` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `reports`
    --

    CREATE TABLE `reports` (
      `report_id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `node_id` int UNSIGNED NOT NULL,
      `node_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `category_id` int UNSIGNED NOT NULL,
      `reason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `time` datetime NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `reports_categories`
    --

    CREATE TABLE `reports_categories` (
      `category_id` int UNSIGNED NOT NULL,
      `category_parent_id` int UNSIGNED NOT NULL,
      `category_name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `category_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `category_order` int UNSIGNED NOT NULL DEFAULT '1'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    --
    -- Dumping data for table `reports_categories`
    --

    INSERT INTO `reports_categories` (`category_id`, `category_parent_id`, `category_name`, `category_description`, `category_order`) VALUES
    (1, 0, 'Nudity', '', 1),
    (2, 0, 'Violence', '', 2),
    (3, 0, 'Harassment', '', 3),
    (4, 0, 'Suicide or Self-Injury', '', 4),
    (5, 0, 'False Information', '', 5),
    (6, 0, 'Spam', '', 6),
    (7, 0, 'Unauthorized Sales', '', 7),
    (8, 0, 'Hate Speech', '', 8),
    (9, 0, 'Terrorism', '', 9),
    (10, 0, 'Something Else', '', 10);

    -- --------------------------------------------------------

    --
    -- Table structure for table `reviews`
    --

    CREATE TABLE `reviews` (
      `review_id` int UNSIGNED NOT NULL,
      `node_id` int UNSIGNED NOT NULL,
      `node_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `rate` smallint NOT NULL,
      `review` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `reply` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
      `time` datetime NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `reviews_photos`
    --

    CREATE TABLE `reviews_photos` (
      `photo_id` int UNSIGNED NOT NULL,
      `review_id` int UNSIGNED NOT NULL,
      `source` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `shopping_cart`
    --

    CREATE TABLE `shopping_cart` (
      `id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `product_post_id` int UNSIGNED NOT NULL,
      `quantity` int UNSIGNED NOT NULL DEFAULT '1'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    -- --------------------------------------------------------

    --
    -- Table structure for table `sitemaps`
    --

    CREATE TABLE `sitemaps` (
      `sitemap_type` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
      `sitemap_part` int UNSIGNED NOT NULL,
      `urls` int UNSIGNED NOT NULL DEFAULT '0',
      `last_id` int UNSIGNED NOT NULL DEFAULT '0',
      `notified_id` int UNSIGNED NOT NULL DEFAULT '0',
      `last_modified` datetime DEFAULT NULL,
      `generated_at` datetime NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    -- --------------------------------------------------------

    --
    -- Table structure for table `sneak_peaks`
    --

    CREATE TABLE `sneak_peaks` (
      `id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `node_id` int UNSIGNED NOT NULL,
      `node_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `time` datetime NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `static_pages`
    --

    CREATE TABLE `static_pages` (
      `page_id` int UNSIGNED NOT NULL,
      `page_title` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `page_is_redirect` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `page_redirect_url` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `page_url` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `page_text` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `page_in_footer` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1',
      `page_in_sidebar` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `page_icon` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `page_order` int UNSIGNED NOT NULL DEFAULT '1'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    --
    -- Dumping data for table `static_pages`
    --

    INSERT INTO `static_pages` (`page_id`, `page_title`, `page_is_redirect`, `page_redirect_url`, `page_url`, `page_text`, `page_in_footer`, `page_in_sidebar`, `page_icon`, `page_order`) VALUES
    (1, 'About', '0', '', 'about', '&lt;p&gt;Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.&lt;/p&gt;\r\n&lt;h3 class=&quot;text-info&quot;&gt;Big Title&lt;/h3&gt;\r\n&lt;p&gt;Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.&lt;/p&gt;\r\n&lt;h3 class=&quot;text-info&quot;&gt;Big Title&lt;/h3&gt;\r\n&lt;p&gt;Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.&lt;/p&gt;', '1', '0', NULL, 1),
    (2, 'Terms', '0', '', 'terms', '&lt;p&gt;The Sngine website located at &lt;a href=&quot;https://demo.sngine.com/&quot;&gt;https://demo.sngine.com/&lt;/a&gt; is a copyrighted work belonging to Sngine. Certain features of the Site may be subject to additional guidelines, terms, or rules, which will be posted on the Site in connection with such features.&lt;/p&gt;\r\n&lt;p&gt;All such additional terms, guidelines, and rules are incorporated by reference into these Terms.&lt;/p&gt;\r\n&lt;p&gt;These Terms of Use described the legally binding terms and conditions that oversee your use of the Site.&amp;nbsp;BY LOGGING INTO THE SITE, YOU ARE BEING COMPLIANT THAT THESE TERMS and you represent that you have the authority and capacity to enter into these Terms.&amp;nbsp;YOU SHOULD BE AT LEAST 18 YEARS OF AGE TO ACCESS THE SITE. IF YOU DISAGREE WITH ALL OF THE PROVISION OF THESE TERMS, DO NOT LOG INTO AND/OR USE THE SITE.&lt;/p&gt;\r\n&lt;p&gt;These terms require the use of arbitration Section 10.2 on an individual basis to resolve disputes and also limit the remedies available to you in the event of a dispute.&lt;/p&gt;\r\n&lt;h2&gt;Access to the Site&lt;/h2&gt;\r\n&lt;p&gt;&lt;strong&gt;Subject to these Terms.&lt;/strong&gt; Company grants you a non-transferable, non-exclusive, revocable, limited license to access the Site solely for your own personal, noncommercial use.&lt;/p&gt;\r\n&lt;p&gt;&lt;strong&gt;Certain Restrictions.&lt;/strong&gt; The rights approved to you in these Terms are subject to the following restrictions: (a) you shall not sell, rent, lease, transfer, assign, distribute, host, or otherwise commercially exploit the Site; (b) you shall not change, make derivative works of, disassemble, reverse compile or reverse engineer any part of the Site; (c) you shall not access the Site in order to build a similar or competitive website; and (d) except as expressly stated herein, no part of the Site may be copied, reproduced, distributed, republished, downloaded, displayed, posted or transmitted in any form or by any means unless otherwise indicated, any future release, update, or other addition to functionality of the Site shall be subject to these Terms.&amp;nbsp; All copyright and other proprietary notices on the Site must be retained on all copies thereof.&lt;/p&gt;\r\n&lt;p&gt;Company reserves the right to change, suspend, or cease the Site with or without notice to you.&amp;nbsp; You approved that Company will not be held liable to you or any third-party for any change, interruption, or termination of the Site or any part.&lt;/p&gt;\r\n&lt;p&gt;&lt;strong&gt;No Support or Maintenance.&lt;/strong&gt; You agree that Company will have no obligation to provide you with any support in connection with the Site.&lt;/p&gt;\r\n&lt;p&gt;Excluding any User Content that you may provide, you are aware that all the intellectual property rights, including copyrights, patents, trademarks, and trade secrets, in the Site and its content are owned by Company or Company&amp;rsquo;s suppliers. Note that these Terms and access to the Site do not give you any rights, title or interest in or to any intellectual property rights, except for the limited access rights expressed in Section 2.1. Company and its suppliers reserve all rights not granted in these Terms.&lt;/p&gt;\r\n&lt;h2&gt;User Content&lt;/h2&gt;\r\n&lt;p&gt;&lt;strong&gt;User Content.&lt;/strong&gt; &quot;User Content&quot; means any and all information and content that a user submits to the Site. You are exclusively responsible for your User Content. You bear all risks associated with use of your User Content.&amp;nbsp; You hereby certify that your User Content does not violate our Acceptable Use Policy.&amp;nbsp; You may not represent or imply to others that your User Content is in any way provided, sponsored or endorsed by Company. Because you alone are responsible for your User Content, you may expose yourself to liability. Company is not obliged to backup any User Content that you post; also, your User Content may be deleted at any time without prior notice to you. You are solely responsible for making your own backup copies of your User Content if you desire.&lt;/p&gt;\r\n&lt;p&gt;You hereby grant to Company an irreversible, nonexclusive, royalty-free and fully paid, worldwide license to reproduce, distribute, publicly display and perform, prepare derivative works of, incorporate into other works, and otherwise use and exploit your User Content, and to grant sublicenses of the foregoing rights, solely for the purposes of including your User Content in the Site.&amp;nbsp; You hereby irreversibly waive any claims and assertions of moral rights or attribution with respect to your User Content.&lt;/p&gt;\r\n&lt;p&gt;&lt;strong&gt;Acceptable Use Policy.&lt;/strong&gt; The following terms constitute our &quot;Acceptable Use Policy&quot;: You agree not to use the Site to collect, upload, transmit, display, or distribute any User Content (i) that violates any third-party right or any intellectual property or proprietary right; (ii) that is unlawful, harassing, abusive, tortious, threatening, harmful, invasive of another&amp;rsquo;s privacy, vulgar, defamatory, false, intentionally misleading, trade libelous, pornographic, obscene, patently offensive, promotes racism, bigotry, hatred, or physical harm of any kind against any group or individual; (iii) that is harmful to minors in any way; or (iv) that is in violation of any law, regulation, or obligations or restrictions imposed by any third party.&lt;/p&gt;\r\n&lt;p&gt;In addition, you agree not to: (i) upload, transmit, or distribute to or through the Site any software intended to damage or alter a computer system or data; (ii) send through the Site unsolicited or unauthorized advertising, promotional materials, junk mail, spam, chain letters, pyramid schemes, or any other form of duplicative or unsolicited messages; (iii) use the Site to harvest, collect, gather or assemble information or data regarding other users without their consent; (iv) interfere with, disrupt, or create an undue burden on servers or networks connected to the Site, or violate the regulations, policies or procedures of such networks; (v) attempt to gain unauthorized access to the Site, whether through password mining or any other means; (vi) harass or interfere with any other user&amp;rsquo;s use and enjoyment of the Site; or (vi) use software or automated agents or scripts to produce multiple accounts on the Site, or to generate automated searches, requests, or queries to the Site.&lt;/p&gt;\r\n&lt;p&gt;We reserve the right to review any User Content, and to investigate and/or take appropriate action against you in our sole discretion if you violate the Acceptable Use Policy or any other provision of these Terms or otherwise create liability for us or any other person. Such action may include removing or modifying your User Content, terminating your Account in accordance with Section 8, and/or reporting you to law enforcement authorities.&lt;/p&gt;\r\n&lt;p&gt;If you provide Company with any feedback or suggestions regarding the Site, you hereby assign to Company all rights in such Feedback and agree that Company shall have the right to use and fully exploit such Feedback and related information in any manner it believes appropriate.&amp;nbsp; Company will treat any Feedback you provide to Company as non-confidential and non-proprietary.&lt;/p&gt;\r\n&lt;p&gt;You agree to indemnify and hold Company and its officers, employees, and agents harmless, including costs and attorneys&amp;rsquo; fees, from any claim or demand made by any third-party due to or arising out of (a) your use of the Site, (b) your violation of these Terms, (c) your violation of applicable laws or regulations or (d) your User Content.&amp;nbsp; Company reserves the right to assume the exclusive defense and control of any matter for which you are required to indemnify us, and you agree to cooperate with our defense of these claims.&amp;nbsp; You agree not to settle any matter without the prior written consent of Company.&amp;nbsp; Company will use reasonable efforts to notify you of any such claim, action or proceeding upon becoming aware of it.&lt;/p&gt;\r\n&lt;h2&gt;Third-Party Links &amp;amp; Ads; Other Users&lt;/h2&gt;\r\n&lt;p&gt;&lt;strong&gt;Third-Party Links &amp;amp; Ads.&lt;/strong&gt; The Site may contain links to third-party websites and services, and/or display advertisements for third-parties.&amp;nbsp; Such Third-Party Links &amp;amp; Ads are not under the control of Company, and Company is not responsible for any Third-Party Links &amp;amp; Ads.&amp;nbsp; Company provides access to these Third-Party Links &amp;amp; Ads only as a convenience to you, and does not review, approve, monitor, endorse, warrant, or make any representations with respect to Third-Party Links &amp;amp; Ads.&amp;nbsp; You use all Third-Party Links &amp;amp; Ads at your own risk, and should apply a suitable level of caution and discretion in doing so. When you click on any of the Third-Party Links &amp;amp; Ads, the applicable third party&amp;rsquo;s terms and policies apply, including the third party&amp;rsquo;s privacy and data gathering practices.&lt;/p&gt;\r\n&lt;p&gt;&lt;strong&gt;Other Users.&lt;/strong&gt; Each Site user is solely responsible for any and all of its own User Content.&amp;nbsp; Because we do not control User Content, you acknowledge and agree that we are not responsible for any User Content, whether provided by you or by others.&amp;nbsp; You agree that Company will not be responsible for any loss or damage incurred as the result of any such interactions.&amp;nbsp; If there is a dispute between you and any Site user, we are under no obligation to become involved.&lt;/p&gt;\r\n&lt;p&gt;You hereby release and forever discharge the Company and our officers, employees, agents, successors, and assigns from, and hereby waive and relinquish, each and every past, present and future dispute, claim, controversy, demand, right, obligation, liability, action and cause of action of every kind and nature, that has arisen or arises directly or indirectly out of, or that relates directly or indirectly to, the Site. If you are a California resident, you hereby waive California civil code section 1542 in connection with the foregoing, which states: &quot;a general release does not extend to claims which the creditor does not know or suspect to exist in his or her favor at the time of executing the release, which if known by him or her must have materially affected his or her settlement with the debtor.&quot;&lt;/p&gt;\r\n&lt;p&gt;&lt;strong&gt;Cookies and Web Beacons.&lt;/strong&gt; Like any other website, Sngine uses &amp;lsquo;cookies&amp;rsquo;. These cookies are used to store information including visitors&amp;rsquo; preferences, and the pages on the website that the visitor accessed or visited. The information is used to optimize the users&amp;rsquo; experience by customizing our web page content based on visitors&amp;rsquo; browser type and/or other information.&lt;/p&gt;\r\n&lt;p&gt;&lt;strong&gt;Google DoubleClick DART Cookie.&lt;/strong&gt; Google is one of a third-party vendor on our site. It also uses cookies, known as DART cookies, to serve ads to our site visitors based upon their visit to www.website.com and other sites on the internet. However, visitors may choose to decline the use of DART cookies by visiting the Google ad and content network Privacy Policy at the following URL &amp;ndash; &lt;a href=&quot;https://policies.google.com/technologies/ads&quot;&gt;https://policies.google.com/technologies/ads&lt;/a&gt;&lt;/p&gt;\r\n&lt;p&gt;&lt;strong&gt;Our Advertising Partners.&lt;/strong&gt; Some of advertisers on our site may use cookies and web beacons. Our advertising partners are listed below. Each of our advertising partners has their own Privacy Policy for their policies on user data. For easier access, we hyperlinked to their Privacy Policies below.&lt;/p&gt;\r\n&lt;ul&gt;\r\n&lt;li&gt;\r\n&lt;p&gt;Google&lt;/p&gt;\r\n&lt;p&gt;&lt;a href=&quot;https://policies.google.com/technologies/ads&quot;&gt;https://policies.google.com/technologies/ads&lt;/a&gt;&lt;/p&gt;\r\n&lt;/li&gt;\r\n&lt;/ul&gt;\r\n&lt;h2&gt;Disclaimers&lt;/h2&gt;\r\n&lt;p&gt;The site is provided on an &quot;as-is&quot; and &quot;as available&quot; basis, and company and our suppliers expressly disclaim any and all warranties and conditions of any kind, whether express, implied, or statutory, including all warranties or conditions of merchantability, fitness for a particular purpose, title, quiet enjoyment, accuracy, or non-infringement.&amp;nbsp; We and our suppliers make not guarantee that the site will meet your requirements, will be available on an uninterrupted, timely, secure, or error-free basis, or will be accurate, reliable, free of viruses or other harmful code, complete, legal, or safe.&amp;nbsp; If applicable law requires any warranties with respect to the site, all such warranties are limited in duration to ninety (90) days from the date of first use.&lt;/p&gt;\r\n&lt;p&gt;Some jurisdictions do not allow the exclusion of implied warranties, so the above exclusion may not apply to you.&amp;nbsp; Some jurisdictions do not allow limitations on how long an implied warranty lasts, so the above limitation may not apply to you.&lt;/p&gt;\r\n&lt;h2&gt;Limitation on Liability&lt;/h2&gt;\r\n&lt;p&gt;To the maximum extent permitted by law, in no event shall company or our suppliers be liable to you or any third-party for any lost profits, lost data, costs of procurement of substitute products, or any indirect, consequential, exemplary, incidental, special or punitive damages arising from or relating to these terms or your use of, or incapability to use the site even if company has been advised of the possibility of such damages.&amp;nbsp; Access to and use of the site is at your own discretion and risk, and you will be solely responsible for any damage to your device or computer system, or loss of data resulting therefrom.&lt;/p&gt;\r\n&lt;p&gt;To the maximum extent permitted by law, notwithstanding anything to the contrary contained herein, our liability to you for any damages arising from or related to this agreement, will at all times be limited to a maximum of fifty U.S. dollars (u.s. $50). The existence of more than one claim will not enlarge this limit.&amp;nbsp; You agree that our suppliers will have no liability of any kind arising from or relating to this agreement.&lt;/p&gt;\r\n&lt;p&gt;Some jurisdictions do not allow the limitation or exclusion of liability for incidental or consequential damages, so the above limitation or exclusion may not apply to you.&lt;/p&gt;\r\n&lt;p&gt;&lt;strong&gt;Term and Termination.&lt;/strong&gt; Subject to this Section, these Terms will remain in full force and effect while you use the Site.&amp;nbsp; We may suspend or terminate your rights to use the Site at any time for any reason at our sole discretion, including for any use of the Site in violation of these Terms.&amp;nbsp; Upon termination of your rights under these Terms, your Account and right to access and use the Site will terminate immediately.&amp;nbsp; You understand that any termination of your Account may involve deletion of your User Content associated with your Account from our live databases.&amp;nbsp; Company will not have any liability whatsoever to you for any termination of your rights under these Terms.&amp;nbsp; Even after your rights under these Terms are terminated, the following provisions of these Terms will remain in effect: Sections 2 through 2.5, Section 3 and Sections 4 through 10.&lt;/p&gt;\r\n&lt;h2&gt;Copyright Policy.&lt;/h2&gt;\r\n&lt;p&gt;Company respects the intellectual property of others and asks that users of our Site do the same.&amp;nbsp; In connection with our Site, we have adopted and implemented a policy respecting copyright law that provides for the removal of any infringing materials and for the termination of users of our online Site who are repeated infringers of intellectual property rights, including copyrights.&amp;nbsp; If you believe that one of our users is, through the use of our Site, unlawfully infringing the copyright(s) in a work, and wish to have the allegedly infringing material removed, the following information in the form of a written notification (pursuant to 17 U.S.C. &amp;sect; 512(c)) must be provided to our designated Copyright Agent:&lt;/p&gt;\r\n&lt;ul&gt;\r\n&lt;li&gt;your physical or electronic signature;&lt;/li&gt;\r\n&lt;li&gt;identification of the copyrighted work(s) that you claim to have been infringed;&lt;/li&gt;\r\n&lt;li&gt;identification of the material on our services that you claim is infringing and that you request us to remove;&lt;/li&gt;\r\n&lt;li&gt;sufficient information to permit us to locate such material;&lt;/li&gt;\r\n&lt;li&gt;your address, telephone number, and e-mail address;&lt;/li&gt;\r\n&lt;li&gt;a statement that you have a good faith belief that use of the objectionable material is not authorized by the copyright owner, its agent, or under the law; and&lt;/li&gt;\r\n&lt;li&gt;a statement that the information in the notification is accurate, and under penalty of perjury, that you are either the owner of the copyright that has allegedly been infringed or that you are authorized to act on behalf of the copyright owner.&lt;/li&gt;\r\n&lt;/ul&gt;\r\n&lt;p&gt;Please note that, pursuant to 17 U.S.C. &amp;sect; 512(f), any misrepresentation of material fact in a written notification automatically subjects the complaining party to liability for any damages, costs and attorney&amp;rsquo;s fees incurred by us in connection with the written notification and allegation of copyright infringement.&lt;/p&gt;\r\n&lt;h2&gt;General&lt;/h2&gt;\r\n&lt;p&gt;These Terms are subject to occasional revision, and if we make any substantial changes, we may notify you by sending you an e-mail to the last e-mail address you provided to us and/or by prominently posting notice of the changes on our Site.&amp;nbsp; You are responsible for providing us with your most current e-mail address.&amp;nbsp; In the event that the last e-mail address that you have provided us is not valid our dispatch of the e-mail containing such notice will nonetheless constitute effective notice of the changes described in the notice.&amp;nbsp; Any changes to these Terms will be effective upon the earliest of thirty (30) calendar days following our dispatch of an e-mail notice to you or thirty (30) calendar days following our posting of notice of the changes on our Site.&amp;nbsp; These changes will be effective immediately for new users of our Site.&amp;nbsp; Continued use of our Site following notice of such changes shall indicate your acknowledgement of such changes and agreement to be bound by the terms and conditions of such changes. Dispute Resolution. Please read this Arbitration Agreement carefully. It is part of your contract with Company and affects your rights.&amp;nbsp; It contains procedures for MANDATORY BINDING ARBITRATION AND A CLASS ACTION WAIVER.&lt;/p&gt;\r\n&lt;p&gt;&lt;strong&gt;Applicability of Arbitration Agreement.&lt;/strong&gt; All claims and disputes in connection with the Terms or the use of any product or service provided by the Company that cannot be resolved informally or in small claims court shall be resolved by binding arbitration on an individual basis under the terms of this Arbitration Agreement.&amp;nbsp; Unless otherwise agreed to, all arbitration proceedings shall be held in English.&amp;nbsp; This Arbitration Agreement applies to you and the Company, and to any subsidiaries, affiliates, agents, employees, predecessors in interest, successors, and assigns, as well as all authorized or unauthorized users or beneficiaries of services or goods provided under the Terms.&lt;/p&gt;\r\n&lt;p&gt;&lt;strong&gt;Notice Requirement and Informal Dispute Resolution.&lt;/strong&gt; Before either party may seek arbitration, the party must first send to the other party a written Notice of Dispute describing the nature and basis of the claim or dispute, and the requested relief.&amp;nbsp; A Notice to the Company should be sent to: Sngine. After the Notice is received, you and the Company may attempt to resolve the claim or dispute informally.&amp;nbsp; If you and the Company do not resolve the claim or dispute within thirty (30) days after the Notice is received, either party may begin an arbitration proceeding.&amp;nbsp; The amount of any settlement offer made by any party may not be disclosed to the arbitrator until after the arbitrator has determined the amount of the award to which either party is entitled.&lt;/p&gt;\r\n&lt;p&gt;&lt;strong&gt;Arbitration Rules.&lt;/strong&gt; Arbitration shall be initiated through the American Arbitration Association, an established alternative dispute resolution provider that offers arbitration as set forth in this section.&amp;nbsp; If AAA is not available to arbitrate, the parties shall agree to select an alternative ADR Provider.&amp;nbsp; The rules of the ADR Provider shall govern all aspects of the arbitration except to the extent such rules are in conflict with the Terms.&amp;nbsp; The AAA Consumer Arbitration Rules governing the arbitration are available online at adr.org or by calling the AAA at 1-800-778-7879.&amp;nbsp; The arbitration shall be conducted by a single, neutral arbitrator.&amp;nbsp; Any claims or disputes where the total amount of the award sought is less than Ten Thousand U.S. Dollars (US $10,000.00) may be resolved through binding non-appearance-based arbitration, at the option of the party seeking relief.&amp;nbsp; For claims or disputes where the total amount of the award sought is Ten Thousand U.S. Dollars (US $10,000.00) or more, the right to a hearing will be determined by the Arbitration Rules.&amp;nbsp; Any hearing will be held in a location within 100 miles of your residence, unless you reside outside of the United States, and unless the parties agree otherwise.&amp;nbsp; If you reside outside of the U.S., the arbitrator shall give the parties reasonable notice of the date, time and place of any oral hearings. Any judgment on the award rendered by the arbitrator may be entered in any court of competent jurisdiction.&amp;nbsp; If the arbitrator grants you an award that is greater than the last settlement offer that the Company made to you prior to the initiation of arbitration, the Company will pay you the greater of the award or $2,500.00.&amp;nbsp; Each party shall bear its own costs and disbursements arising out of the arbitration and shall pay an equal share of the fees and costs of the ADR Provider.&lt;/p&gt;\r\n&lt;p&gt;&lt;strong&gt;Additional Rules for Non-Appearance Based Arbitration.&lt;/strong&gt; If non-appearance based arbitration is elected, the arbitration shall be conducted by telephone, online and/or based solely on written submissions; the specific manner shall be chosen by the party initiating the arbitration.&amp;nbsp; The arbitration shall not involve any personal appearance by the parties or witnesses unless otherwise agreed by the parties.&lt;/p&gt;\r\n&lt;p&gt;&lt;strong&gt;Time Limits.&lt;/strong&gt; If you or the Company pursues arbitration, the arbitration action must be initiated and/or demanded within the statute of limitations and within any deadline imposed under the AAA Rules for the pertinent claim.&lt;/p&gt;\r\n&lt;p&gt;&lt;strong&gt;Authority of Arbitrator.&lt;/strong&gt; If arbitration is initiated, the arbitrator will decide the rights and liabilities of you and the Company, and the dispute will not be consolidated with any other matters or joined with any other cases or parties.&amp;nbsp; The arbitrator shall have the authority to grant motions dispositive of all or part of any claim.&amp;nbsp; The arbitrator shall have the authority to award monetary damages, and to grant any non-monetary remedy or relief available to an individual under applicable law, the AAA Rules, and the Terms.&amp;nbsp; The arbitrator shall issue a written award and statement of decision describing the essential findings and conclusions on which the award is based.&amp;nbsp; The arbitrator has the same authority to award relief on an individual basis that a judge in a court of law would have.&amp;nbsp; The award of the arbitrator is final and binding upon you and the Company.&lt;/p&gt;\r\n&lt;p&gt;&lt;strong&gt;Waiver of Jury Trial.&lt;/strong&gt; THE PARTIES HEREBY WAIVE THEIR CONSTITUTIONAL AND STATUTORY RIGHTS TO GO TO COURT AND HAVE A TRIAL IN FRONT OF A JUDGE OR A JURY, instead electing that all claims and disputes shall be resolved by arbitration under this Arbitration Agreement.&amp;nbsp; Arbitration procedures are typically more limited, more efficient and less expensive than rules applicable in a court and are subject to very limited review by a court.&amp;nbsp; In the event any litigation should arise between you and the Company in any state or federal court in a suit to vacate or enforce an arbitration award or otherwise, YOU AND THE COMPANY WAIVE ALL RIGHTS TO A JURY TRIAL, instead electing that the dispute be resolved by a judge.&lt;/p&gt;\r\n&lt;p&gt;&lt;strong&gt;Waiver of Class or Consolidated Actions.&lt;/strong&gt; All claims and disputes within the scope of this arbitration agreement must be arbitrated or litigated on an individual basis and not on a class basis, and claims of more than one customer or user cannot be arbitrated or litigated jointly or consolidated with those of any other customer or user.&lt;/p&gt;\r\n&lt;p&gt;&lt;strong&gt;Confidentiality.&lt;/strong&gt; All aspects of the arbitration proceeding shall be strictly confidential.&amp;nbsp; The parties agree to maintain confidentiality unless otherwise required by law.&amp;nbsp; This paragraph shall not prevent a party from submitting to a court of law any information necessary to enforce this Agreement, to enforce an arbitration award, or to seek injunctive or equitable relief.&lt;/p&gt;\r\n&lt;p&gt;&lt;strong&gt;Severability.&lt;/strong&gt; If any part or parts of this Arbitration Agreement are found under the law to be invalid or unenforceable by a court of competent jurisdiction, then such specific part or parts shall be of no force and effect and shall be severed and the remainder of the Agreement shall continue in full force and effect.&lt;/p&gt;\r\n&lt;p&gt;&lt;strong&gt;Right to Waive.&lt;/strong&gt; Any or all of the rights and limitations set forth in this Arbitration Agreement may be waived by the party against whom the claim is asserted.&amp;nbsp; Such waiver shall not waive or affect any other portion of this Arbitration Agreement.&lt;/p&gt;\r\n&lt;p&gt;&lt;strong&gt;Survival of Agreement.&lt;/strong&gt; This Arbitration Agreement will survive the termination of your relationship with Company.&lt;/p&gt;\r\n&lt;p&gt;&lt;strong&gt;Small Claims Court.&lt;/strong&gt; Nonetheless the foregoing, either you or the Company may bring an individual action in small claims court.&lt;/p&gt;\r\n&lt;p&gt;&lt;strong&gt;Emergency Equitable Relief.&lt;/strong&gt; Anyhow the foregoing, either party may seek emergency equitable relief before a state or federal court in order to maintain the status quo pending arbitration.&amp;nbsp; A request for interim measures shall not be deemed a waiver of any other rights or obligations under this Arbitration Agreement.&lt;/p&gt;\r\n&lt;p&gt;&lt;strong&gt;Claims Not Subject to Arbitration.&lt;/strong&gt; Notwithstanding the foregoing, claims of defamation, violation of the Computer Fraud and Abuse Act, and infringement or misappropriation of the other party&amp;rsquo;s patent, copyright, trademark or trade secrets shall not be subject to this Arbitration Agreement.&lt;/p&gt;\r\n&lt;p&gt;In any circumstances where the foregoing Arbitration Agreement permits the parties to litigate in court, the parties hereby agree to submit to the personal jurisdiction of the courts located within Netherlands County, California, for such purposes.&lt;/p&gt;\r\n&lt;p&gt;The Site may be subject to U.S. export control laws and may be subject to export or import regulations in other countries. You agree not to export, re-export, or transfer, directly or indirectly, any U.S. technical data acquired from Company, or any products utilizing such data, in violation of the United States export laws or regulations.&lt;/p&gt;\r\n&lt;p&gt;Company is located at the address in Section 10.8. If you are a California resident, you may report complaints to the Complaint Assistance Unit of the Division of Consumer Product of the California Department of Consumer Affairs by contacting them in writing at 400 R Street, Sacramento, CA 95814, or by telephone at (800) 952-5210.&lt;/p&gt;\r\n&lt;p&gt;&lt;strong&gt;Electronic Communications.&lt;/strong&gt; The communications between you and Company use electronic means, whether you use the Site or send us emails, or whether Company posts notices on the Site or communicates with you via email. For contractual purposes, you (a) consent to receive communications from Company in an electronic form; and (b) agree that all terms and conditions, agreements, notices, disclosures, and other communications that Company provides to you electronically satisfy any legal obligation that such communications would satisfy if it were be in a hard copy writing.&lt;/p&gt;\r\n&lt;p&gt;&lt;strong&gt;Entire Terms.&lt;/strong&gt; These Terms constitute the entire agreement between you and us regarding the use of the Site. Our failure to exercise or enforce any right or provision of these Terms shall not operate as a waiver of such right or provision. The section titles in these Terms are for convenience only and have no legal or contractual effect. The word &quot;including&quot; means &quot;including without limitation&quot;. If any provision of these Terms is held to be invalid or unenforceable, the other provisions of these Terms will be unimpaired and the invalid or unenforceable provision will be deemed modified so that it is valid and enforceable to the maximum extent permitted by law.&amp;nbsp; Your relationship to Company is that of an independent contractor, and neither party is an agent or partner of the other.&amp;nbsp; These Terms, and your rights and obligations herein, may not be assigned, subcontracted, delegated, or otherwise transferred by you without Company&amp;rsquo;s prior written consent, and any attempted assignment, subcontract, delegation, or transfer in violation of the foregoing will be null and void.&amp;nbsp; Company may freely assign these Terms.&amp;nbsp; The terms and conditions set forth in these Terms shall be binding upon assignees.&lt;/p&gt;\r\n&lt;p&gt;&lt;strong&gt;Your Privacy.&lt;/strong&gt; Please read our Privacy Policy.&lt;/p&gt;\r\n&lt;p&gt;&lt;strong&gt;Copyright/Trademark Information.&lt;/strong&gt; Copyright &amp;copy;. All rights reserved.&amp;nbsp; All trademarks, logos and service marks displayed on the Site are our property or the property of other third-parties. You are not permitted to use these Marks without our prior written consent or the consent of such third party which may own the Marks.&lt;/p&gt;', '1', '0', NULL, 2),
    (3, 'Privacy', '0', '', 'privacy', '&lt;p&gt;At Sngine, accessible from &lt;a href=&quot;https://demo.sngine.com/&quot;&gt;https://demo.sngine.com/&lt;/a&gt;, one of our main priorities is the privacy of our visitors. This Privacy Policy document contains types of information that is collected and recorded by Sngine and how we use it.&lt;/p&gt;\r\n&lt;p&gt;If you have additional questions or require more information about our Privacy Policy, do not hesitate to contact us.&lt;/p&gt;\r\n&lt;p&gt;This Privacy Policy applies only to our online activities and is valid for visitors to our website with regards to the information that they shared and/or collect in Sngine. This policy is not applicable to any information collected offline or via channels other than this website.&lt;/p&gt;\r\n&lt;h2&gt;Consent&lt;/h2&gt;\r\n&lt;p&gt;By using our website, you hereby consent to our Privacy Policy and agree to its terms.&lt;/p&gt;\r\n&lt;h2&gt;Information we collect&lt;/h2&gt;\r\n&lt;p&gt;The personal information that you are asked to provide, and the reasons why you are asked to provide it, will be made clear to you at the point we ask you to provide your personal information.&lt;/p&gt;\r\n&lt;p&gt;If you contact us directly, we may receive additional information about you such as your name, email address, phone number, the contents of the message and/or attachments you may send us, and any other information you may choose to provide.&lt;/p&gt;\r\n&lt;p&gt;When you register for an Account, we may ask for your contact information, including items such as name, company name, address, email address, and telephone number.&lt;/p&gt;\r\n&lt;h2&gt;How we use your information&lt;/h2&gt;\r\n&lt;p&gt;We use the information we collect in various ways, including to:&lt;/p&gt;\r\n&lt;ul&gt;\r\n&lt;li&gt;Provide, operate, and maintain our website&lt;/li&gt;\r\n&lt;li&gt;Improve, personalize, and expand our website&lt;/li&gt;\r\n&lt;li&gt;Understand and analyze how you use our website&lt;/li&gt;\r\n&lt;li&gt;Develop new products, services, features, and functionality&lt;/li&gt;\r\n&lt;li&gt;Communicate with you, either directly or through one of our partners, including for customer service, to provide you with updates and other information relating to the website, and for marketing and promotional purposes&lt;/li&gt;\r\n&lt;li&gt;Send you emails&lt;/li&gt;\r\n&lt;li&gt;Find and prevent fraud&lt;/li&gt;\r\n&lt;/ul&gt;\r\n&lt;h2&gt;Log Files&lt;/h2&gt;\r\n&lt;p&gt;Sngine follows a standard procedure of using log files. These files log visitors when they visit websites. All hosting companies do this and a part of hosting services&#039; analytics. The information collected by log files include internet protocol (IP) addresses, browser type, Internet Service Provider (ISP), date and time stamp, referring/exit pages, and possibly the number of clicks. These are not linked to any information that is personally identifiable. The purpose of the information is for analyzing trends, administering the site, tracking users&#039; movement on the website, and gathering demographic information.&lt;/p&gt;\r\n&lt;h2&gt;Cookies and Web Beacons&lt;/h2&gt;\r\n&lt;p&gt;Like any other website, Sngine uses &#039;cookies&#039;. These cookies are used to store information including visitors&#039; preferences, and the pages on the website that the visitor accessed or visited. The information is used to optimize the users&#039; experience by customizing our web page content based on visitors&#039; browser type and/or other information.&lt;/p&gt;\r\n&lt;h2&gt;Google DoubleClick DART Cookie&lt;/h2&gt;\r\n&lt;p&gt;Google is one of a third-party vendor on our site. It also uses cookies, known as DART cookies, to serve ads to our site visitors based upon their visit to www.website.com and other sites on the internet. However, visitors may choose to decline the use of DART cookies by visiting the Google ad and content network Privacy Policy at the following URL &amp;ndash;&amp;nbsp;&lt;a href=&quot;https://policies.google.com/technologies/ads&quot;&gt;https://policies.google.com/technologies/ads&lt;/a&gt;&lt;/p&gt;\r\n&lt;h2&gt;Our Advertising Partners&lt;/h2&gt;\r\n&lt;p&gt;Some of advertisers on our site may use cookies and web beacons. Our advertising partners are listed below. Each of our advertising partners has their own Privacy Policy for their policies on user data. For easier access, we hyperlinked to their Privacy Policies below.&lt;/p&gt;\r\n&lt;ul&gt;\r\n&lt;li&gt;\r\n&lt;p&gt;Google&lt;/p&gt;\r\n&lt;p&gt;&lt;a href=&quot;https://policies.google.com/technologies/ads&quot;&gt;https://policies.google.com/technologies/ads&lt;/a&gt;&lt;/p&gt;\r\n&lt;/li&gt;\r\n&lt;/ul&gt;\r\n&lt;h2&gt;Advertising Partners Privacy Policies&lt;/h2&gt;\r\n&lt;p&gt;You may consult this list to find the Privacy Policy for each of the advertising partners of Sngine.&lt;/p&gt;\r\n&lt;p&gt;Third-party ad servers or ad networks uses technologies like cookies, JavaScript, or Web Beacons that are used in their respective advertisements and links that appear on Sngine, which are sent directly to users&#039; browser. They automatically receive your IP address when this occurs. These technologies are used to measure the effectiveness of their advertising campaigns and/or to personalize the advertising content that you see on websites that you visit.&lt;/p&gt;\r\n&lt;p&gt;Note that Sngine has no access to or control over these cookies that are used by third-party advertisers.&lt;/p&gt;\r\n&lt;h2&gt;Third Party Privacy Policies&lt;/h2&gt;\r\n&lt;p&gt;Sngine&#039;s Privacy Policy does not apply to other advertisers or websites. Thus, we are advising you to consult the respective Privacy Policies of these third-party ad servers for more detailed information. It may include their practices and instructions about how to opt-out of certain options.&lt;/p&gt;\r\n&lt;p&gt;You can choose to disable cookies through your individual browser options. To know more detailed information about cookie management with specific web browsers, it can be found at the browsers&#039; respective websites.&lt;/p&gt;\r\n&lt;h2&gt;CCPA Privacy Rights (Do Not Sell My Personal Information)&lt;/h2&gt;\r\n&lt;p&gt;Under the CCPA, among other rights, California consumers have the right to:&lt;/p&gt;\r\n&lt;p&gt;Request that a business that collects a consumer&#039;s personal data disclose the categories and specific pieces of personal data that a business has collected about consumers.&lt;/p&gt;\r\n&lt;p&gt;Request that a business delete any personal data about the consumer that a business has collected.&lt;/p&gt;\r\n&lt;p&gt;Request that a business that sells a consumer&#039;s personal data, not sell the consumer&#039;s personal data.&lt;/p&gt;\r\n&lt;p&gt;If you make a request, we have one month to respond to you. If you would like to exercise any of these rights, please contact us.&lt;/p&gt;\r\n&lt;h2&gt;GDPR Data Protection Rights&lt;/h2&gt;\r\n&lt;p&gt;We would like to make sure you are fully aware of all of your data protection rights. Every user is entitled to the following:&lt;/p&gt;\r\n&lt;p&gt;The right to access &amp;ndash; You have the right to request copies of your personal data. We may charge you a small fee for this service.&lt;/p&gt;\r\n&lt;p&gt;The right to rectification &amp;ndash; You have the right to request that we correct any information you believe is inaccurate. You also have the right to request that we complete the information you believe is incomplete.&lt;/p&gt;\r\n&lt;p&gt;The right to erasure &amp;ndash; You have the right to request that we erase your personal data, under certain conditions.&lt;/p&gt;\r\n&lt;p&gt;The right to restrict processing &amp;ndash; You have the right to request that we restrict the processing of your personal data, under certain conditions.&lt;/p&gt;\r\n&lt;p&gt;The right to object to processing &amp;ndash; You have the right to object to our processing of your personal data, under certain conditions.&lt;/p&gt;\r\n&lt;p&gt;The right to data portability &amp;ndash; You have the right to request that we transfer the data that we have collected to another organization, or directly to you, under certain conditions.&lt;/p&gt;\r\n&lt;p&gt;If you make a request, we have one month to respond to you. If you would like to exercise any of these rights, please contact us.&lt;/p&gt;\r\n&lt;h2&gt;Children&#039;s Information&lt;/h2&gt;\r\n&lt;p&gt;Another part of our priority is adding protection for children while using the internet. We encourage parents and guardians to observe, participate in, and/or monitor and guide their online activity.&lt;/p&gt;\r\n&lt;p&gt;Sngine does not knowingly collect any Personal Identifiable Information from children under the age of 13. If you think that your child provided this kind of information on our website, we strongly encourage you to contact us immediately and we will do our best efforts to promptly remove such information from our records.&lt;/p&gt;', '1', '0', NULL, 3);

    -- --------------------------------------------------------

    --
    -- Table structure for table `stickers`
    --

    CREATE TABLE `stickers` (
      `sticker_id` int UNSIGNED NOT NULL,
      `image` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    --
    -- Dumping data for table `stickers`
    --

    INSERT INTO `stickers` (`sticker_id`, `image`) VALUES
    (1, 'stickers/1.png'),
    (2, 'stickers/2.png'),
    (3, 'stickers/3.png'),
    (4, 'stickers/4.png'),
    (5, 'stickers/5.png'),
    (6, 'stickers/6.png'),
    (7, 'stickers/7.png'),
    (8, 'stickers/8.png'),
    (9, 'stickers/9.png'),
    (10, 'stickers/10.png'),
    (11, 'stickers/11.png'),
    (12, 'stickers/12.png'),
    (13, 'stickers/13.png'),
    (14, 'stickers/14.png'),
    (15, 'stickers/15.png'),
    (16, 'stickers/16.png'),
    (17, 'stickers/17.png'),
    (18, 'stickers/18.png'),
    (19, 'stickers/19.png'),
    (20, 'stickers/20.png');

    -- --------------------------------------------------------

    --
    -- Table structure for table `stories`
    --

    CREATE TABLE `stories` (
      `story_id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `origin_id` int UNSIGNED DEFAULT NULL,
      `type` enum('photo','video','text') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'photo',
      `source` varchar(256) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
      `thumbnail` varchar(256) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
      `background` varchar(32) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
      `filter` varchar(32) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
      `drawing` varchar(256) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
      `layers` mediumtext COLLATE utf8mb4_general_ci,
      `duration` smallint UNSIGNED NOT NULL DEFAULT '0',
      `music_id` int UNSIGNED DEFAULT NULL,
      `music_start` smallint UNSIGNED NOT NULL DEFAULT '0',
      `privacy` enum('public','friends','close_friends') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'public',
      `is_ads` enum('0','1') COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `highlighted` enum('0','1') COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `views_count` int UNSIGNED NOT NULL DEFAULT '0',
      `reactions_count` int UNSIGNED NOT NULL DEFAULT '0',
      `replies_count` int UNSIGNED NOT NULL DEFAULT '0',
      `poll_votes_1` int UNSIGNED NOT NULL DEFAULT '0',
      `poll_votes_2` int UNSIGNED NOT NULL DEFAULT '0',
      `time` datetime NOT NULL,
      `expires_at` datetime NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    -- --------------------------------------------------------

    --
    -- Table structure for table `stories_audience`
    --

    CREATE TABLE `stories_audience` (
      `id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `target_id` int UNSIGNED NOT NULL,
      `type` enum('close','hidden') COLLATE utf8mb4_general_ci NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    -- --------------------------------------------------------

    --
    -- Table structure for table `stories_highlights`
    --

    CREATE TABLE `stories_highlights` (
      `highlight_id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `title` varchar(128) COLLATE utf8mb4_general_ci NOT NULL,
      `cover_story_id` int UNSIGNED DEFAULT NULL,
      `time` datetime NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    -- --------------------------------------------------------

    --
    -- Table structure for table `stories_highlights_items`
    --

    CREATE TABLE `stories_highlights_items` (
      `id` int UNSIGNED NOT NULL,
      `highlight_id` int UNSIGNED NOT NULL,
      `story_id` int UNSIGNED NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    -- --------------------------------------------------------

    --
    -- Table structure for table `stories_music`
    --

    CREATE TABLE `stories_music` (
      `music_id` int UNSIGNED NOT NULL,
      `provider` enum('library','itunes') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'library',
      `provider_id` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL,
      `title` varchar(256) COLLATE utf8mb4_general_ci NOT NULL,
      `artist` varchar(256) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
      `cover` varchar(512) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
      `source` varchar(512) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
      `url` varchar(512) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
      `uses` int UNSIGNED NOT NULL DEFAULT '0',
      `enabled` enum('0','1') COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1',
      `time` datetime NOT NULL,
      `updated_at` datetime NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    -- --------------------------------------------------------

    --
    -- Table structure for table `stories_polls_votes`
    --

    CREATE TABLE `stories_polls_votes` (
      `id` int UNSIGNED NOT NULL,
      `story_id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `option` tinyint UNSIGNED NOT NULL,
      `time` datetime NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    -- --------------------------------------------------------

    --
    -- Table structure for table `stories_reactions`
    --

    CREATE TABLE `stories_reactions` (
      `id` int UNSIGNED NOT NULL,
      `story_id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `reaction` varchar(32) COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'like',
      `time` datetime NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    -- --------------------------------------------------------

    --
    -- Table structure for table `stories_views`
    --

    CREATE TABLE `stories_views` (
      `view_id` int UNSIGNED NOT NULL,
      `story_id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `time` datetime NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    -- --------------------------------------------------------

    --
    -- Table structure for table `subscribers`
    --

    CREATE TABLE `subscribers` (
      `id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `node_id` int UNSIGNED NOT NULL,
      `node_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `plan_id` int UNSIGNED NOT NULL,
      `time` datetime NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `support_tickets`
    --

    CREATE TABLE `support_tickets` (
      `ticket_id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `agent_id` int UNSIGNED DEFAULT NULL,
      `subject` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `text` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `status` enum('opened','in_progress','pending','solved','closed') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'opened',
      `replies` int UNSIGNED NOT NULL DEFAULT '0',
      `created_at` datetime NOT NULL,
      `updated_at` datetime DEFAULT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `support_tickets_replies`
    --

    CREATE TABLE `support_tickets_replies` (
      `reply_id` int UNSIGNED NOT NULL,
      `ticket_id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `text` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `created_at` datetime NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `system_countries`
    --

    CREATE TABLE `system_countries` (
      `country_id` int UNSIGNED NOT NULL,
      `country_code` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `country_flag` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
      `country_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `phone_code` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `country_vat` float UNSIGNED DEFAULT NULL,
      `default` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `enabled` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1',
      `country_order` int UNSIGNED NOT NULL DEFAULT '1'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    --
    -- Dumping data for table `system_countries`
    --

    INSERT INTO `system_countries` (`country_id`, `country_code`, `country_flag`, `country_name`, `phone_code`, `country_vat`, `default`, `enabled`, `country_order`) VALUES
    (1, 'AF', '🇦🇫', 'Afghanistan', '+93', NULL, '0', '1', 1),
    (2, 'AL', '🇦🇱', 'Albania', '+355', NULL, '0', '1', 2),
    (3, 'DZ', '🇩🇿', 'Algeria', '+213', NULL, '0', '1', 3),
    (4, 'DS', '🇦🇸', 'American Samoa', '+1684', NULL, '0', '1', 4),
    (5, 'AD', '🇦🇩', 'Andorra', '+376', NULL, '0', '1', 5),
    (6, 'AO', '🇦🇴', 'Angola', '+244', NULL, '0', '1', 6),
    (7, 'AI', '🇦🇮', 'Anguilla', '+1264', NULL, '0', '1', 7),
    (8, 'AQ', '🇦🇶', 'Antarctica', '+672', NULL, '0', '1', 8),
    (9, 'AG', '🇦🇬', 'Antigua and Barbuda', '+1268', NULL, '0', '1', 9),
    (10, 'AR', '🇦🇷', 'Argentina', '+54', NULL, '0', '1', 10),
    (11, 'AM', '🇦🇲', 'Armenia', '+374', NULL, '0', '1', 11),
    (12, 'AW', '🇦🇼', 'Aruba', '+297', NULL, '0', '1', 12),
    (13, 'AU', '🇦🇺', 'Australia', '+61', NULL, '0', '1', 13),
    (14, 'AT', '🇦🇹', 'Austria', '+43', NULL, '0', '1', 14),
    (15, 'AZ', '🇦🇿', 'Azerbaijan', '+994', NULL, '0', '1', 15),
    (16, 'BS', '🇧🇸', 'Bahamas', '+1242', NULL, '0', '1', 16),
    (17, 'BH', '🇧🇭', 'Bahrain', '+973', NULL, '0', '1', 17),
    (18, 'BD', '🇧🇩', 'Bangladesh', '+880', NULL, '0', '1', 18),
    (19, 'BB', '🇧🇧', 'Barbados', '+1246', NULL, '0', '1', 19),
    (20, 'BY', '🇧🇾', 'Belarus', '+375', NULL, '0', '1', 20),
    (21, 'BE', '🇧🇪', 'Belgium', '+32', NULL, '0', '1', 21),
    (22, 'BZ', '🇧🇿', 'Belize', '+501', NULL, '0', '1', 22),
    (23, 'BJ', '🇧🇯', 'Benin', '+229', NULL, '0', '1', 23),
    (24, 'BM', '🇧🇲', 'Bermuda', '+1441', NULL, '0', '1', 24),
    (25, 'BT', '🇧🇹', 'Bhutan', '+975', NULL, '0', '1', 25),
    (26, 'BO', '🇧🇴', 'Bolivia', '+591', NULL, '0', '1', 26),
    (27, 'BA', '🇧🇦', 'Bosnia and Herzegovina', '+387', NULL, '0', '1', 27),
    (28, 'BW', '🇧🇼', 'Botswana', '+267', NULL, '0', '1', 28),
    (29, 'BV', '🇧🇻', 'Bouvet Island', '+55', NULL, '0', '1', 29),
    (30, 'BR', '🇧🇷', 'Brazil', '+55', NULL, '0', '1', 30),
    (31, 'IO', '🇮🇴', 'British Indian Ocean Territory', '+246', NULL, '0', '1', 31),
    (32, 'BN', '🇧🇳', 'Brunei Darussalam', '+673', NULL, '0', '1', 32),
    (33, 'BG', '🇧🇬', 'Bulgaria', '+359', NULL, '0', '1', 33),
    (34, 'BF', '🇧🇫', 'Burkina Faso', '+226', NULL, '0', '1', 34),
    (35, 'BI', '🇧🇮', 'Burundi', '+257', NULL, '0', '1', 35),
    (36, 'KH', '🇰🇭', 'Cambodia', '+855', NULL, '0', '1', 36),
    (37, 'CM', '🇨🇲', 'Cameroon', '+237', NULL, '0', '1', 37),
    (38, 'CA', '🇨🇦', 'Canada', '+1', NULL, '0', '1', 38),
    (39, 'CV', '🇨🇻', 'Cape Verde', '+238', NULL, '0', '1', 39),
    (40, 'KY', '🇰🇾', 'Cayman Islands', '+ 345', NULL, '0', '1', 40),
    (41, 'CF', '🇨🇫', 'Central African Republic', '+236', NULL, '0', '1', 41),
    (42, 'TD', '🇹🇩', 'Chad', '+235', NULL, '0', '1', 42),
    (43, 'CL', '🇨🇱', 'Chile', '+56', NULL, '0', '1', 43),
    (44, 'CN', '🇨🇳', 'China', '+86', NULL, '0', '1', 44),
    (45, 'CX', '🇨🇽', 'Christmas Island', '+61', NULL, '0', '1', 45),
    (46, 'CC', '🇨🇨', 'Cocos (Keeling) Islands', '+61', NULL, '0', '1', 46),
    (47, 'CO', '🇨🇴', 'Colombia', '+57', NULL, '0', '1', 47),
    (48, 'KM', '🇰🇲', 'Comoros', '+269', NULL, '0', '1', 48),
    (49, 'CG', '🇨🇬', 'Congo', '+242', NULL, '0', '1', 49),
    (50, 'CK', '🇨🇰', 'Cook Islands', '+682', NULL, '0', '1', 50),
    (51, 'CR', '🇨🇷', 'Costa Rica', '+506', NULL, '0', '1', 51),
    (52, 'HR', '🇭🇷', 'Croatia (Hrvatska)', '+385', NULL, '0', '1', 52),
    (53, 'CU', '🇨🇺', 'Cuba', '+53', NULL, '0', '1', 53),
    (54, 'CY', '🇨🇾', 'Cyprus', '+357', NULL, '0', '1', 54),
    (55, 'CZ', '🇨🇿', 'Czech Republic', '+420', NULL, '0', '1', 55),
    (56, 'DK', '🇩🇰', 'Denmark', '+45', NULL, '0', '1', 56),
    (57, 'DJ', '🇩🇯', 'Djibouti', '+253', NULL, '0', '1', 57),
    (58, 'DM', '🇩🇲', 'Dominica', '+1767', NULL, '0', '1', 58),
    (59, 'DO', '🇩🇴', 'Dominican Republic', '+1849', NULL, '0', '1', 59),
    (60, 'TP', '🇹🇱', 'East Timor', NULL, NULL, '0', '1', 60),
    (61, 'EC', '🇪🇨', 'Ecuador', '+593', NULL, '0', '1', 61),
    (62, 'EG', '🇪🇬', 'Egypt', '+20', NULL, '0', '1', 62),
    (63, 'SV', '🇸🇻', 'El Salvador', '+503', NULL, '0', '1', 63),
    (64, 'GQ', '🇬🇶', 'Equatorial Guinea', '+240', NULL, '0', '1', 64),
    (65, 'ER', '🇪🇷', 'Eritrea', '+291', NULL, '0', '1', 65),
    (66, 'EE', '🇪🇪', 'Estonia', '+372', NULL, '0', '1', 66),
    (67, 'ET', '🇪🇹', 'Ethiopia', '+251', NULL, '0', '1', 67),
    (68, 'FK', '🇫🇰', 'Falkland Islands (Malvinas)', '+500', NULL, '0', '1', 68),
    (69, 'FO', '🇫🇴', 'Faroe Islands', '+298', NULL, '0', '1', 69),
    (70, 'FJ', '🇫🇯', 'Fiji', '+679', NULL, '0', '1', 70),
    (71, 'FI', '🇫🇮', 'Finland', '+358', NULL, '0', '1', 71),
    (72, 'FR', '🇫🇷', 'France', '+33', NULL, '0', '1', 72),
    (73, 'FX', '🇫🇷', 'France, Metropolitan', NULL, NULL, '0', '1', 73),
    (74, 'GF', '🇬🇫', 'French Guiana', '+594', NULL, '0', '1', 74),
    (75, 'PF', '🇵🇫', 'French Polynesia', '+689', NULL, '0', '1', 75),
    (76, 'TF', '🇹🇫', 'French Southern Territories', '+262', NULL, '0', '1', 76),
    (77, 'GA', '🇬🇦', 'Gabon', '+241', NULL, '0', '1', 77),
    (78, 'GM', '🇬🇲', 'Gambia', '+220', NULL, '0', '1', 78),
    (79, 'GE', '🇬🇪', 'Georgia', '+995', NULL, '0', '1', 79),
    (80, 'DE', '🇩🇪', 'Germany', '+49', NULL, '0', '1', 80),
    (81, 'GH', '🇬🇭', 'Ghana', '+233', NULL, '0', '1', 81),
    (82, 'GI', '🇬🇮', 'Gibraltar', '+350', NULL, '0', '1', 82),
    (83, 'GK', '🇬🇬', 'Guernsey', '+44', NULL, '0', '1', 83),
    (84, 'GR', '🇬🇷', 'Greece', '+30', NULL, '0', '1', 84),
    (85, 'GL', '🇬🇱', 'Greenland', '+299', NULL, '0', '1', 85),
    (86, 'GD', '🇬🇩', 'Grenada', '+1473', NULL, '0', '1', 86),
    (87, 'GP', '🇬🇵', 'Guadeloupe', '+590', NULL, '0', '1', 87),
    (88, 'GU', '🇬🇺', 'Guam', '+1671', NULL, '0', '1', 88),
    (89, 'GT', '🇬🇹', 'Guatemala', '+502', NULL, '0', '1', 89),
    (90, 'GN', '🇬🇳', 'Guinea', '+224', NULL, '0', '1', 90),
    (91, 'GW', '🇬🇼', 'Guinea-Bissau', '+245', NULL, '0', '1', 91),
    (92, 'GY', '🇬🇾', 'Guyana', '+595', NULL, '0', '1', 92),
    (93, 'HT', '🇭🇹', 'Haiti', '+509', NULL, '0', '1', 93),
    (94, 'HM', '🇭🇲', 'Heard and Mc Donald Islands', NULL, NULL, '0', '1', 94),
    (95, 'HN', '🇭🇳', 'Honduras', '+504', NULL, '0', '1', 95),
    (96, 'HK', '🇭🇰', 'Hong Kong', '+852', NULL, '0', '1', 96),
    (97, 'HU', '🇭🇺', 'Hungary', '+36', NULL, '0', '1', 97),
    (98, 'IS', '🇮🇸', 'Iceland', '+354', NULL, '0', '1', 98),
    (99, 'IN', '🇮🇳', 'India', '+91', NULL, '0', '1', 99),
    (100, 'IM', '🇮🇲', 'Isle of Man', '+44', NULL, '0', '1', 100),
    (101, 'ID', '🇮🇩', 'Indonesia', '+62', NULL, '0', '1', 101),
    (102, 'IR', '🇮🇷', 'Iran (Islamic Republic of)', '+98', NULL, '0', '1', 102),
    (103, 'IQ', '🇮🇶', 'Iraq', '+964', NULL, '0', '1', 103),
    (104, 'IE', '🇮🇪', 'Ireland', '+353', NULL, '0', '1', 104),
    (105, 'IL', '🇮🇱', 'Israel', '+972', NULL, '0', '1', 105),
    (106, 'IT', '🇮🇹', 'Italy', '+39', NULL, '0', '1', 106),
    (107, 'CI', '🇨🇮', 'Ivory Coast', NULL, NULL, '0', '1', 107),
    (108, 'JE', '🇯🇪', 'Jersey', '+44', NULL, '0', '1', 108),
    (109, 'JM', '🇯🇲', 'Jamaica', '+1876', NULL, '0', '1', 109),
    (110, 'JP', '🇯🇵', 'Japan', '+81', NULL, '0', '1', 110),
    (111, 'JO', '🇯🇴', 'Jordan', '+962', NULL, '0', '1', 111),
    (112, 'KZ', '🇰🇿', 'Kazakhstan', '+77', NULL, '0', '1', 112),
    (113, 'KE', '🇰🇪', 'Kenya', '+254', NULL, '0', '1', 113),
    (114, 'KI', '🇰🇮', 'Kiribati', '+686', NULL, '0', '1', 114),
    (115, 'KP', '🇰🇵', 'Korea, Democratic People\'s Republic of', '+850', NULL, '0', '1', 115),
    (116, 'KR', '🇰🇷', 'Korea, Republic of', '+82', NULL, '0', '1', 116),
    (117, 'XK', '🇽🇰', 'Kosovo', '+381', NULL, '0', '1', 117),
    (118, 'KW', '🇰🇼', 'Kuwait', '+965', NULL, '0', '1', 118),
    (119, 'KG', '🇰🇬', 'Kyrgyzstan', '+996', NULL, '0', '1', 119),
    (120, 'LA', '🇱🇦', 'Lao People\'s Democratic Republic', '+856', NULL, '0', '1', 120),
    (121, 'LV', '🇱🇻', 'Latvia', '+371', NULL, '0', '1', 121),
    (122, 'LB', '🇱🇧', 'Lebanon', '+961', NULL, '0', '1', 122),
    (123, 'LS', '🇱🇸', 'Lesotho', '+266', NULL, '0', '1', 123),
    (124, 'LR', '🇱🇷', 'Liberia', '+231', NULL, '0', '1', 124),
    (125, 'LY', '🇱🇾', 'Libyan Arab Jamahiriya', '+218', NULL, '0', '1', 125),
    (126, 'LI', '🇱🇮', 'Liechtenstein', '+423', NULL, '0', '1', 126),
    (127, 'LT', '🇱🇹', 'Lithuania', '+370', NULL, '0', '1', 127),
    (128, 'LU', '🇱🇺', 'Luxembourg', '+352', NULL, '0', '1', 128),
    (129, 'MO', '🇲🇴', 'Macau', '+853', NULL, '0', '1', 129),
    (130, 'MK', '🇲🇰', 'Macedonia', '+389', NULL, '0', '1', 130),
    (131, 'MG', '🇲🇬', 'Madagascar', '+261', NULL, '0', '1', 131),
    (132, 'MW', '🇲🇼', 'Malawi', '+265', NULL, '0', '1', 132),
    (133, 'MY', '🇲🇾', 'Malaysia', '+60', NULL, '0', '1', 133),
    (134, 'MV', '🇲🇻', 'Maldives', '+960', NULL, '0', '1', 134),
    (135, 'ML', '🇲🇱', 'Mali', '+223', NULL, '0', '1', 135),
    (136, 'MT', '🇲🇹', 'Malta', '+356', NULL, '0', '1', 136),
    (137, 'MH', '🇲🇭', 'Marshall Islands', '+692', NULL, '0', '1', 137),
    (138, 'MQ', '🇲🇶', 'Martinique', '+596', NULL, '0', '1', 138),
    (139, 'MR', '🇲🇷', 'Mauritania', '+222', NULL, '0', '1', 139),
    (140, 'MU', '🇲🇺', 'Mauritius', '+230', NULL, '0', '1', 140),
    (141, 'TY', '🇾🇹', 'Mayotte', '+269', NULL, '0', '1', 141),
    (142, 'MX', '🇲🇽', 'Mexico', '+52', NULL, '0', '1', 142),
    (143, 'FM', '🇫🇲', 'Micronesia, Federated States of', '+691', NULL, '0', '1', 143),
    (144, 'MD', '🇲🇩', 'Moldova, Republic of', '+373', NULL, '0', '1', 144),
    (145, 'MC', '🇲🇨', 'Monaco', '+377', NULL, '0', '1', 145),
    (146, 'MN', '🇲🇳', 'Mongolia', '+976', NULL, '0', '1', 146),
    (147, 'ME', '🇲🇪', 'Montenegro', '+382', NULL, '0', '1', 147),
    (148, 'MS', '🇲🇸', 'Montserrat', '+1664', NULL, '0', '1', 148),
    (149, 'MA', '🇲🇦', 'Morocco', '+212', NULL, '0', '1', 149),
    (150, 'MZ', '🇲🇿', 'Mozambique', '+258', NULL, '0', '1', 150),
    (151, 'MM', '🇲🇲', 'Myanmar', '+95', NULL, '0', '1', 151),
    (152, 'NA', '🇳🇦', 'Namibia', '+264', NULL, '0', '1', 152),
    (153, 'NR', '🇳🇷', 'Nauru', '+674', NULL, '0', '1', 153),
    (154, 'NP', '🇳🇵', 'Nepal', '+977', NULL, '0', '1', 154),
    (155, 'NL', '🇳🇱', 'Netherlands', '+31', NULL, '0', '1', 155),
    (156, 'AN', '', 'Netherlands Antilles', '+599', NULL, '0', '1', 156),
    (157, 'NC', '🇳🇨', 'New Caledonia', '+687', NULL, '0', '1', 157),
    (158, 'NZ', '🇳🇿', 'New Zealand', '+64', NULL, '0', '1', 158),
    (159, 'NI', '🇳🇮', 'Nicaragua', '+505', NULL, '0', '1', 159),
    (160, 'NE', '🇳🇪', 'Niger', '+227', NULL, '0', '1', 160),
    (161, 'NG', '🇳🇬', 'Nigeria', '+234', NULL, '0', '1', 161),
    (162, 'NU', '🇳🇺', 'Niue', '+683', NULL, '0', '1', 162),
    (163, 'NF', '🇳🇫', 'Norfolk Island', '+672', NULL, '0', '1', 163),
    (164, 'MP', '🇲🇵', 'Northern Mariana Islands', '+1670', NULL, '0', '1', 164),
    (165, 'NO', '🇳🇴', 'Norway', '+47', NULL, '0', '1', 165),
    (166, 'OM', '🇴🇲', 'Oman', '+968', NULL, '0', '1', 166),
    (167, 'PK', '🇵🇰', 'Pakistan', '+92', NULL, '0', '1', 167),
    (168, 'PW', '🇵🇼', 'Palau', '+680', NULL, '0', '1', 168),
    (169, 'PS', '🇵🇸', 'Palestine', '+970', NULL, '0', '1', 169),
    (170, 'PA', '🇵🇦', 'Panama', '+507', NULL, '0', '1', 170),
    (171, 'PG', '🇵🇬', 'Papua New Guinea', '+675', NULL, '0', '1', 171),
    (172, 'PY', '🇵🇾', 'Paraguay', '+595', NULL, '0', '1', 172),
    (173, 'PE', '🇵🇪', 'Peru', '+51', NULL, '0', '1', 173),
    (174, 'PH', '🇵🇭', 'Philippines', '+63', NULL, '0', '1', 174),
    (175, 'PN', '🇵🇳', 'Pitcairn', '+872', NULL, '0', '1', 175),
    (176, 'PL', '🇵🇱', 'Poland', '+48', NULL, '0', '1', 176),
    (177, 'PT', '🇵🇹', 'Portugal', '+351', NULL, '0', '1', 177),
    (178, 'PR', '🇵🇷', 'Puerto Rico', '+1939', NULL, '0', '1', 178),
    (179, 'QA', '🇶🇦', 'Qatar', '+974', NULL, '0', '1', 179),
    (180, 'RE', '🇷🇪', 'Reunion', '+262', NULL, '0', '1', 180),
    (181, 'RO', '🇷🇴', 'Romania', '+40', NULL, '0', '1', 181),
    (182, 'RU', '🇷🇺', 'Russian Federation', '+7', NULL, '0', '1', 182),
    (183, 'RW', '🇷🇼', 'Rwanda', '+250', NULL, '0', '1', 183),
    (184, 'KN', '🇰🇳', 'Saint Kitts and Nevis', '+1869', NULL, '0', '1', 184),
    (185, 'LC', '🇱🇨', 'Saint Lucia', '+1758', NULL, '0', '1', 185),
    (186, 'VC', '🇻🇨', 'Saint Vincent and the Grenadines', '+1784', NULL, '0', '1', 186),
    (187, 'WS', '🇼🇸', 'Samoa', '+685', NULL, '0', '1', 187),
    (188, 'SM', '🇸🇲', 'San Marino', '+378', NULL, '0', '1', 188),
    (189, 'ST', '🇸🇹', 'Sao Tome and Principe', '+239', NULL, '0', '1', 189),
    (190, 'SA', '🇸🇦', 'Saudi Arabia', '+966', NULL, '0', '1', 190),
    (191, 'SN', '🇸🇳', 'Senegal', '+221', NULL, '0', '1', 191),
    (192, 'RS', '🇷🇸', 'Serbia', '+381', NULL, '0', '1', 192),
    (193, 'SC', '🇸🇨', 'Seychelles', '+248', NULL, '0', '1', 193),
    (194, 'SL', '🇸🇱', 'Sierra Leone', '+232', NULL, '0', '1', 194),
    (195, 'SG', '🇸🇬', 'Singapore', '+65', NULL, '0', '1', 195),
    (196, 'SK', '🇸🇰', 'Slovakia', '+421', NULL, '0', '1', 196),
    (197, 'SI', '🇸🇮', 'Slovenia', '+386', NULL, '0', '1', 197),
    (198, 'SB', '🇸🇧', 'Solomon Islands', '+677', NULL, '0', '1', 198),
    (199, 'SO', '🇸🇴', 'Somalia', '+252', NULL, '0', '1', 199),
    (200, 'ZA', '🇿🇦', 'South Africa', '+27', NULL, '0', '1', 200),
    (201, 'GS', '🇬🇸', 'South Georgia South Sandwich Islands', '+500', NULL, '0', '1', 201),
    (202, 'ES', '🇪🇸', 'Spain', '+34', NULL, '0', '1', 202),
    (203, 'LK', '🇱🇰', 'Sri Lanka', '+94', NULL, '0', '1', 203),
    (204, 'SH', '🇸🇭', 'St. Helena', '+290', NULL, '0', '1', 204),
    (205, 'PM', '🇵🇲', 'St. Pierre and Miquelon', '+508', NULL, '0', '1', 205),
    (206, 'SD', '🇸🇩', 'Sudan', '+249', NULL, '0', '1', 206),
    (207, 'SR', '🇸🇷', 'Suriname', '+597', NULL, '0', '1', 207),
    (208, 'SJ', '🇸🇯', 'Svalbard and Jan Mayen Islands', '+47', NULL, '0', '1', 208),
    (209, 'SZ', '🇸🇿', 'Swaziland', '+268', NULL, '0', '1', 209),
    (210, 'SE', '🇸🇪', 'Sweden', '+46', NULL, '0', '1', 210),
    (211, 'CH', '🇨🇭', 'Switzerland', '+41', NULL, '0', '1', 211),
    (212, 'SY', '🇸🇾', 'Syrian Arab Republic', '+963', NULL, '0', '1', 212),
    (213, 'TW', '🇹🇼', 'Taiwan', '+886', NULL, '0', '1', 213),
    (214, 'TJ', '🇹🇯', 'Tajikistan', '+992', NULL, '0', '1', 214),
    (215, 'TZ', '🇹🇿', 'Tanzania, United Republic of', '+255', NULL, '0', '1', 215),
    (216, 'TH', '🇹🇭', 'Thailand', '+66', NULL, '0', '1', 216),
    (217, 'TG', '🇹🇬', 'Togo', '+228', NULL, '0', '1', 217),
    (218, 'TK', '🇹🇰', 'Tokelau', '+690', NULL, '0', '1', 218),
    (219, 'TO', '🇹🇴', 'Tonga', '+676', NULL, '0', '1', 219),
    (220, 'TT', '🇹🇹', 'Trinidad and Tobago', '+1868', NULL, '0', '1', 220),
    (221, 'TN', '🇹🇳', 'Tunisia', '+216', NULL, '0', '1', 221),
    (222, 'TR', '🇹🇷', 'Turkey', '+90', NULL, '0', '1', 222),
    (223, 'TM', '🇹🇲', 'Turkmenistan', '+993', NULL, '0', '1', 223),
    (224, 'TC', '🇹🇨', 'Turks and Caicos Islands', '+1649', NULL, '0', '1', 224),
    (225, 'TV', '🇹🇻', 'Tuvalu', '+688', NULL, '0', '1', 225),
    (226, 'UG', '🇺🇬', 'Uganda', '+256', NULL, '0', '1', 226),
    (227, 'UA', '🇺🇦', 'Ukraine', '+380', NULL, '0', '1', 227),
    (228, 'AE', '🇦🇪', 'United Arab Emirates', '+971', NULL, '0', '1', 228),
    (229, 'GB', '🇬🇧', 'United Kingdom', '+44', NULL, '0', '1', 229),
    (230, 'US', '🇺🇸', 'United States', '+1', NULL, '1', '1', 230),
    (231, 'UM', '🇺🇲', 'United States minor outlying islands', '+1', NULL, '0', '1', 231),
    (232, 'UY', '🇺🇾', 'Uruguay', '+598', NULL, '0', '1', 232),
    (233, 'UZ', '🇺🇿', 'Uzbekistan', '+998', NULL, '0', '1', 233),
    (234, 'VU', '🇻🇺', 'Vanuatu', '+678', NULL, '0', '1', 234),
    (235, 'VA', '🇻🇦', 'Vatican City State', '+379', NULL, '0', '1', 235),
    (236, 'VE', '🇻🇪', 'Venezuela', '+58', NULL, '0', '1', 236),
    (237, 'VN', '🇻🇳', 'Vietnam', '+84', NULL, '0', '1', 237),
    (238, 'VG', '🇻🇬', 'Virgin Islands (British)', '+1284', NULL, '0', '1', 238),
    (239, 'VI', '🇻🇮', 'Virgin Islands (U.S.)', '+1340', NULL, '0', '1', 239),
    (240, 'WF', '🇼🇫', 'Wallis and Futuna Islands', '+681', NULL, '0', '1', 240),
    (241, 'EH', '🇪🇭', 'Western Sahara', '+212', NULL, '0', '1', 241),
    (242, 'YE', '🇾🇪', 'Yemen', '+967', NULL, '0', '1', 242),
    (243, 'ZR', '🇨🇩', 'Zaire', NULL, NULL, '0', '1', 243),
    (244, 'ZM', '🇿🇲', 'Zambia', '+260', NULL, '0', '1', 244),
    (245, 'ZW', '🇿🇼', 'Zimbabwe', '+263', NULL, '0', '1', 245);

    -- --------------------------------------------------------

    --
    -- Table structure for table `system_currencies`
    --

    CREATE TABLE `system_currencies` (
      `currency_id` int UNSIGNED NOT NULL,
      `name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `symbol` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `dir` enum('left','right') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'left',
      `default` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `enabled` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    --
    -- Dumping data for table `system_currencies`
    --

    INSERT INTO `system_currencies` (`currency_id`, `name`, `code`, `symbol`, `dir`, `default`, `enabled`) VALUES
    (1, 'Australia Dollar', 'AUD', '$', 'left', '0', '1'),
    (2, 'Brazil Real', 'BRL', 'R$', 'left', '0', '1'),
    (3, 'Canada Dollar', 'CAD', '$', 'left', '0', '1'),
    (4, 'Czech Republic Koruna', 'CZK', 'Kč', 'left', '0', '1'),
    (5, 'Denmark Krone', 'DKK', 'kr', 'left', '0', '1'),
    (6, 'Euro', 'EUR', '&euro;', 'left', '0', '1'),
    (7, 'Hong Kong Dollar', 'HKD', '$', 'left', '0', '1'),
    (8, 'Hungary Forint', 'HUF', 'Ft', 'left', '0', '1'),
    (9, 'Israel Shekel', 'ILS', '₪', 'left', '0', '1'),
    (10, 'Japan Yen', 'JPY', '&yen;', 'left', '0', '1'),
    (11, 'Malaysia Ringgit', 'MYR', 'RM', 'left', '0', '1'),
    (12, 'Mexico Peso', 'MXN', '$', 'left', '0', '1'),
    (13, 'Norway Krone', 'NOK', 'kr', 'left', '0', '1'),
    (14, 'New Zealand Dollar', 'NZD', '$', 'left', '0', '1'),
    (15, 'Philippines Peso', 'PHP', '₱', 'left', '0', '1'),
    (16, 'Poland Zloty', 'PLN', 'zł', 'left', '0', '1'),
    (17, 'United Kingdom Pound', 'GBP', '&pound;', 'left', '0', '1'),
    (18, 'Russia Ruble', 'RUB', '₽', 'left', '0', '1'),
    (19, 'Singapore Dollar', 'SGD', '$', 'left', '0', '1'),
    (20, 'Sweden Krona', 'SEK', 'kr', 'left', '0', '1'),
    (21, 'Switzerland Franc', 'CHF', 'CHF', 'left', '0', '1'),
    (22, 'Thailand Baht', 'THB', '฿', 'left', '0', '1'),
    (23, 'Turkey Lira', 'TRY', 'TRY', 'left', '0', '1'),
    (24, 'United States Dollar', 'USD', '$', 'left', '1', '1'),
    (25, 'India Rupee', 'INR', '₹', 'right', '0', '1'),
    (26, 'Mexican Pesos', 'MXN', '$', 'left', '0', '1'),
    (27, 'Chinese Yuan', 'CNY', '&yen;', 'left', '0', '0');

    -- --------------------------------------------------------

    --
    -- Table structure for table `system_genders`
    --

    CREATE TABLE `system_genders` (
      `gender_id` int UNSIGNED NOT NULL,
      `gender_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `gender_order` int NOT NULL DEFAULT '1'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    --
    -- Dumping data for table `system_genders`
    --

    INSERT INTO `system_genders` (`gender_id`, `gender_name`, `gender_order`) VALUES
    (1, 'Male', 1),
    (2, 'Female', 2),
    (3, 'Other', 3);

    -- --------------------------------------------------------

    --
    -- Table structure for table `system_languages`
    --

    CREATE TABLE `system_languages` (
      `language_id` int UNSIGNED NOT NULL,
      `code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `title` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `flag` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `dir` enum('LTR','RTL') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `default` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `enabled` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `language_order` int UNSIGNED NOT NULL DEFAULT '1'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    --
    -- Dumping data for table `system_languages`
    --

    INSERT INTO `system_languages` (`language_id`, `code`, `title`, `flag`, `dir`, `default`, `enabled`, `language_order`) VALUES
    (1, 'en_us', 'English', 'flags/en_us.png', 'LTR', '1', '1', 1),
    (2, 'ar_sa', 'العربية', 'flags/ar_sa.png', 'RTL', '0', '1', 2),
    (3, 'fr_fr', 'Français', 'flags/fr_fr.png', 'LTR', '0', '1', 3),
    (4, 'es_es', 'Español', 'flags/es_es.png', 'LTR', '0', '1', 4),
    (5, 'pt_pt', 'Português', 'flags/pt_pt.png', 'LTR', '0', '1', 5),
    (6, 'de_de', 'Deutsch', 'flags/de_de.png', 'LTR', '0', '1', 6),
    (7, 'tr_tr', 'Türkçe', 'flags/tr_tr.png', 'LTR', '0', '1', 7),
    (8, 'nl_nl', 'Nederlands', 'flags/nl_nl.png', 'LTR', '0', '1', 8),
    (9, 'it_it', 'Italiano', 'flags/it_it.png', 'LTR', '0', '1', 9),
    (10, 'ru_ru', 'Русский', 'flags/ru_ru.png', 'LTR', '0', '1', 10),
    (11, 'ro_ro', 'Română', 'flags/ro_ro.png', 'LTR', '0', '1', 11),
    (12, 'pt_br', 'Português (Brasil)', 'flags/pt_br.png', 'LTR', '0', '1', 12),
    (13, 'el_gr', 'Ελληνικά', 'flags/el_gr.png', 'LTR', '0', '1', 13);

    -- --------------------------------------------------------

    --
    -- Table structure for table `system_options`
    --

    CREATE TABLE `system_options` (
      `option_id` int UNSIGNED NOT NULL,
      `option_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `option_value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    --
    -- Dumping data for table `system_options`
    --

    INSERT INTO `system_options` (`option_id`, `option_name`, `option_value`) VALUES
    (1, 'system_public', '1'),
    (2, 'system_live', '1'),
    (3, 'system_message', 'We will Back Soon'),
    (4, 'system_title', 'Sngine'),
    (5, 'system_description', 'Share your memories, connect with others, make new friends'),
    (6, 'system_keywords', ''),
    (7, 'system_email', ''),
    (8, 'system_datetime_format', 'd/m/Y H:i'),
    (9, 'contact_enabled', '1'),
    (10, 'directory_enabled', '1'),
    (11, 'pages_enabled', '1'),
    (12, 'groups_enabled', '1'),
    (13, 'events_enabled', '1'),
    (14, 'blogs_enabled', '1'),
    (15, 'users_blogs_enabled', '1'),
    (16, 'market_enabled', '0'),
    (17, 'movies_enabled', '0'),
    (18, 'games_enabled', '0'),
    (19, 'daytime_msg_enabled', '1'),
    (20, 'pokes_enabled', '1'),
    (21, 'gifts_enabled', '0'),
    (22, 'profile_notification_enabled', '0'),
    (23, 'browser_notifications_enabled', '1'),
    (24, 'noty_notifications_enabled', '1'),
    (25, 'cookie_consent_enabled', '1'),
    (26, 'adblock_detector_enabled', '0'),
    (27, 'stories_enabled', '1'),
    (28, 'popular_posts_enabled', '1'),
    (29, 'discover_posts_enabled', '1'),
    (30, 'memories_enabled', '1'),
    (31, 'wall_posts_enabled', '1'),
    (32, 'activity_posts_enabled', '1'),
    (33, 'colored_posts_enabled', '1'),
    (34, 'polls_enabled', '1'),
    (35, 'geolocation_enabled', '0'),
    (36, 'geolocation_key', ''),
    (37, 'gif_enabled', '0'),
    (38, 'giphy_key', ''),
    (39, 'post_translation_enabled', '0'),
    (40, 'yandex_key', ''),
    (41, 'smart_yt_player', '1'),
    (42, 'social_share_enabled', '1'),
    (43, 'max_post_length', '5000'),
    (44, 'max_comment_length', '5000'),
    (45, 'max_posts_hour', '0'),
    (46, 'max_comments_hour', '0'),
    (47, 'default_privacy', 'public'),
    (48, 'trending_hashtags_enabled', '1'),
    (49, 'trending_hashtags_interval', 'week'),
    (50, 'trending_hashtags_limit', '5'),
    (51, 'registration_enabled', '1'),
    (52, 'registration_type', 'free'),
    (53, 'invitation_enabled', '0'),
    (56, 'packages_enabled', '0'),
    (57, 'packages_wallet_payment_enabled', '1'),
    (58, 'activation_enabled', '1'),
    (59, 'activation_type', 'email'),
    (60, 'verification_requests', '1'),
    (61, 'age_restriction', '0'),
    (62, 'minimum_age', '13'),
    (63, 'getting_started', '1'),
    (64, 'delete_accounts_enabled', '1'),
    (65, 'download_info_enabled', '1'),
    (66, 'newsletter_consent', '1'),
    (67, 'max_accounts', '0'),
    (68, 'max_friends', '5000'),
    (69, 'social_login_enabled', '0'),
    (70, 'facebook_login_enabled', '0'),
    (71, 'facebook_appid', ''),
    (72, 'facebook_secret', ''),
    (73, 'google_login_enabled', '0'),
    (74, 'google_appid', ''),
    (75, 'google_secret', ''),
    (76, 'twitter_login_enabled', '0'),
    (77, 'twitter_appid', ''),
    (78, 'twitter_secret', ''),
    (82, 'linkedin_login_enabled', '0'),
    (83, 'linkedin_appid', ''),
    (84, 'linkedin_secret', ''),
    (85, 'vkontakte_login_enabled', '0'),
    (86, 'vkontakte_appid', ''),
    (87, 'vkontakte_secret', ''),
    (88, 'email_smtp_enabled', '0'),
    (89, 'email_smtp_authentication', ''),
    (90, 'email_smtp_ssl', ''),
    (91, 'email_smtp_server', ''),
    (92, 'email_smtp_port', ''),
    (93, 'email_smtp_username', ''),
    (94, 'email_smtp_password', ''),
    (95, 'email_smtp_setfrom', ''),
    (96, 'email_notifications', '0'),
    (97, 'email_post_likes', '0'),
    (98, 'email_post_comments', '0'),
    (99, 'email_post_shares', '0'),
    (100, 'email_wall_posts', '0'),
    (101, 'email_mentions', '0'),
    (102, 'email_profile_visits', '0'),
    (103, 'email_friend_requests', '0'),
    (104, 'twilio_sid', ''),
    (105, 'twilio_token', ''),
    (106, 'twilio_phone', ''),
    (107, 'twilio_apisid', ''),
    (108, 'twilio_apisecret', ''),
    (109, 'system_phone', ''),
    (110, 'chat_enabled', '1'),
    (111, 'chat_status_enabled', '1'),
    (112, 'chat_typing_enabled', '1'),
    (113, 'chat_seen_enabled', '1'),
    (114, 'video_call_enabled', '0'),
    (115, 'audio_call_enabled', '0'),
    (116, 'uploads_directory', 'content/uploads'),
    (117, 'uploads_prefix', 'sngine'),
    (118, 'max_avatar_size', '102400'),
    (119, 'max_cover_size', '102400'),
    (120, 'photos_enabled', '1'),
    (121, 'max_photo_size', '102400'),
    (122, 'uploads_quality', 'medium'),
    (123, 'videos_enabled', '1'),
    (124, 'max_video_size', '102400'),
    (125, 'video_extensions', 'mp4, webm, ogg, mov, m4a, 3gp, 3g2, mj2, asf, avi, flv, webm, m4v, mpeg, ogv, mkv, ts'),
    (126, 'audio_enabled', '1'),
    (127, 'max_audio_size', '102400'),
    (128, 'audio_extensions', 'mp3, wav, ogg, m4a'),
    (129, 'file_enabled', '1'),
    (130, 'max_file_size', '102400'),
    (131, 'file_extensions', 'txt, zip, json, docx, pdf'),
    (132, 's3_enabled', '0'),
    (133, 's3_bucket', ''),
    (134, 's3_region', ''),
    (135, 's3_key', ''),
    (136, 's3_secret', ''),
    (137, 'digitalocean_enabled', '0'),
    (138, 'digitalocean_space_name', ''),
    (139, 'digitalocean_space_region', ''),
    (140, 'digitalocean_key', ''),
    (141, 'digitalocean_secret', ''),
    (142, 'ftp_enabled', '0'),
    (143, 'ftp_hostname', ''),
    (144, 'ftp_port', ''),
    (145, 'ftp_username', ''),
    (146, 'ftp_password', ''),
    (147, 'ftp_path', ''),
    (148, 'ftp_endpoint', ''),
    (150, 'unusual_login_enabled', '0'),
    (151, 'brute_force_detection_enabled', '1'),
    (152, 'brute_force_bad_login_limit', '5'),
    (153, 'brute_force_lockout_time', '10'),
    (154, 'two_factor_enabled', '1'),
    (155, 'two_factor_type', 'google'),
    (156, 'censored_words_enabled', '1'),
    (157, 'censored_words', '[{&quot;value&quot;:&quot;fuck&quot;},{&quot;value&quot;:&quot;fucking&quot;},{&quot;value&quot;:&quot;fucked&quot;},{&quot;value&quot;:&quot;fucker&quot;},{&quot;value&quot;:&quot;shit&quot;},{&quot;value&quot;:&quot;bitch&quot;},{&quot;value&quot;:&quot;bastard&quot;},{&quot;value&quot;:&quot;asshole&quot;},{&quot;value&quot;:&quot;dick&quot;},{&quot;value&quot;:&quot;cunt&quot;},{&quot;value&quot;:&quot;whore&quot;},{&quot;value&quot;:&quot;slut&quot;},{&quot;value&quot;:&quot;nigger&quot;},{&quot;value&quot;:&quot;nigga&quot;},{&quot;value&quot;:&quot;faggot&quot;},{&quot;value&quot;:&quot;retard&quot;}]'),
    (158, 'reCAPTCHA_enabled', '0'),
    (159, 'reCAPTCHA_site_key', ''),
    (160, 'reCAPTCHA_secret_key', ''),
    (161, 'paypal_enabled', '0'),
    (162, 'paypal_mode', ''),
    (163, 'paypal_id', ''),
    (164, 'paypal_secret', ''),
    (165, 'creditcard_enabled', '0'),
    (166, 'alipay_enabled', '0'),
    (167, 'stripe_mode', ''),
    (168, 'stripe_test_secret', ''),
    (169, 'stripe_test_publishable', ''),
    (170, 'stripe_live_secret', ''),
    (171, 'stripe_live_publishable', ''),
    (172, 'coinpayments_enabled', '0'),
    (173, 'coinpayments_merchant_id', ''),
    (174, 'coinpayments_ipn_secret', ''),
    (175, '2checkout_enabled', '0'),
    (176, '2checkout_mode', ''),
    (177, '2checkout_merchant_code', ''),
    (178, '2checkout_publishable_key', ''),
    (179, '2checkout_private_key', ''),
    (180, 'bank_transfers_enabled', '0'),
    (181, 'bank_name', ''),
    (182, 'bank_account_number', ''),
    (183, 'bank_account_name', ''),
    (184, 'bank_account_routing', ''),
    (185, 'bank_account_country', ''),
    (186, 'bank_transfer_note', 'In order to confirm the bank transfer, you will need to upload a receipt or take a screenshot of your transfer within 1 day from your payment date. If a bank transfer is made but no receipt is uploaded within this period, your order will be cancelled. We will verify and confirm your receipt within 3 working days from the date you upload it.'),
    (187, 'data_heartbeat', '5'),
    (188, 'chat_heartbeat', '10'),
    (189, 'offline_time', '10'),
    (190, 'min_results', '5'),
    (191, 'max_results', '10'),
    (192, 'min_results_even', '6'),
    (193, 'max_results_even', '12'),
    (194, 'analytics_code', ''),
    (197, 'system_profile_background_enabled', '1'),
    (198, 'system_logo', ''),
    (201, 'system_favicon_default', '1'),
    (202, 'system_favicon', ''),
    (203, 'system_ogimage_default', '1'),
    (204, 'system_ogimage', ''),
    (213, 'custome_js_header', '/* \r\nYou can add your JavaScript code here\r\n\r\nExample:\r\n\r\nvar x, y, z;\r\nx = 1;\r\ny = 2;\r\nz = x + y;\r\n*/'),
    (214, 'custome_js_footer', '/* \r\nYou can add your JavaScript code here\r\n\r\nExample:\r\n\r\nvar x, y, z;\r\nx = 1;\r\ny = 2;\r\nz = x + y;\r\n*/'),
    (215, 'forums_enabled', '0'),
    (216, 'forums_online_enabled', '1'),
    (217, 'forums_statistics_enabled', '1'),
    (218, 'affiliates_enabled', '0'),
    (219, 'affiliate_type', 'packages'),
    (220, 'affiliate_payment_method', 'paypal,skrill'),
    (221, 'affiliate_payment_method_custom', ''),
    (222, 'affiliates_min_withdrawal', '50'),
    (223, 'affiliate_payment_type', 'fixed'),
    (224, 'affiliates_per_user', '0.25'),
    (225, 'affiliates_percentage', '25'),
    (226, 'points_enabled', '0'),
    (227, 'points_money_withdraw_enabled', '1'),
    (228, 'points_payment_method', 'paypal,skrill'),
    (229, 'points_payment_method_custom', ''),
    (230, 'points_min_withdrawal', '50'),
    (231, 'points_money_transfer_enabled', '1'),
    (232, 'points_per_currency', '100'),
    (233, 'points_per_post', '0'),
    (234, 'points_per_comment', '5'),
    (235, 'points_per_reaction', '5'),
    (236, 'points_limit_user', '1000'),
    (237, 'points_limit_pro', '2000'),
    (238, 'ads_enabled', '0'),
    (239, 'ads_cost_click', '0.05'),
    (240, 'ads_cost_view', '0.01'),
    (241, 'developers_apps_enabled', '0'),
    (242, 'developers_share_enabled', '0'),
    (243, 'auto_friend', '0'),
    (244, 'auto_friend_users', ''),
    (245, 'auto_follow', '0'),
    (246, 'auto_follow_users', ''),
    (247, 'auto_like', '0'),
    (248, 'auto_like_pages', ''),
    (249, 'auto_join', '0'),
    (250, 'auto_join_groups', ''),
    (251, 'last_backup_time', ''),
    (252, 'sms_provider', 'twilio'),
    (253, 'bulksms_username', ''),
    (254, 'bulksms_password', ''),
    (257, 'watermark_enabled', '0'),
    (258, 'watermark_icon', ''),
    (259, 'watermark_position', 'bottom right'),
    (260, 'watermark_xoffset', '-30'),
    (261, 'watermark_yoffset', '-30'),
    (262, 'watermark_opacity', '0.5'),
    (263, 'adult_images_enabled', '0'),
    (264, 'adult_images_action', 'blur'),
    (265, 'adult_images_api_key', ''),
    (266, 'mobile_infinite_scroll', '0'),
    (267, 'limit_cover_photo', '1'),
    (268, 'comments_photos_enabled', '1'),
    (269, 'chat_photos_enabled', '1'),
    (270, 'onesignal_notification_enabled', '0'),
    (271, 'onesignal_app_id', ''),
    (272, 'onesignal_api_key', ''),
    (273, 'system_distance', 'kilometer'),
    (274, 'wallet_enabled', '0'),
    (275, 'wallet_transfer_enabled', '1'),
    (276, 'affiliates_money_withdraw_enabled', '1'),
    (277, 'affiliates_money_transfer_enabled', '1'),
    (286, 'jobs_enabled', '1'),
    (287, 'posts_online_status', '1'),
    (288, 'anonymous_mode', '1'),
    (289, 'tinymce_photos_enabled', '1'),
    (290, 'voice_notes_posts_enabled', '1'),
    (291, 'voice_notes_comments_enabled', '1'),
    (292, 'voice_notes_chat_enabled', '1'),
    (293, 'offers_enabled', '1'),
    (294, 'live_enabled', '0'),
    (295, 'save_live_enabled', '0'),
    (297, 'agora_app_id', ''),
    (298, 'agora_app_certificate', ''),
    (299, 'agora_customer_id', ''),
    (300, 'agora_customer_certificate', ''),
    (301, 'agora_s3_bucket', ''),
    (302, 'agora_s3_region', ''),
    (303, 'agora_s3_key', ''),
    (304, 'agora_s3_secret', ''),
    (305, 'chat_permanently_delete_enabled', '1'),
    (306, 'system_description_directory', 'Discover new people, create new connections and make new friends'),
    (307, 'system_description_offers', 'Discover new offers'),
    (308, 'system_description_jobs', 'Discover new jobs offers'),
    (309, 'system_description_blogs', 'Explore the latest blogs'),
    (310, 'system_description_marketplace', 'Discover new products'),
    (311, 'system_description_forums', 'The great place to discuss topics with other users'),
    (312, 'system_description_movies', 'Discover new movies'),
    (313, 'stories_duration', '3'),
    (314, 'desktop_infinite_scroll', '1'),
    (315, 'disable_declined_friendrequest', '0'),
    (316, 'wallet_withdrawal_enabled', '1'),
    (317, 'wallet_payment_method', 'paypal,skrill'),
    (318, 'wallet_payment_method_custom', ''),
    (319, 'wallet_min_withdrawal', '50'),
    (320, 'location_finder_enabled', '0'),
    (321, 'relationship_info_enabled', '1'),
    (322, 'website_info_enabled', '1'),
    (323, 'biography_info_enabled', '1'),
    (324, 'work_info_enabled', '1'),
    (325, 'education_info_enabled', '1'),
    (326, 'social_info_enabled', '1'),
    (327, 'location_info_enabled', '1'),
    (328, 'show_usernames_enabled', '0'),
    (329, 'msg91_authkey', ''),
    (330, 'name_min_length', '3'),
    (331, 'newsfeed_source', 'default'),
    (334, 'funding_enabled', '0'),
    (336, 'system_description_funding', 'Discover new funding requests'),
    (339, 'paystack_enabled', '0'),
    (340, 'paystack_secret', ''),
    (341, 'funding_money_withdraw_enabled', '1'),
    (342, 'funding_payment_method', 'paypal,skrill'),
    (343, 'funding_payment_method_custom', ''),
    (344, 'funding_min_withdrawal', '50'),
    (345, 'funding_money_transfer_enabled', '1'),
    (346, 'funding_commission', '10'),
    (347, 'play_store_badge_enabled', '0'),
    (348, 'play_store_link', ''),
    (349, 'app_store_badge_enabled', '0'),
    (350, 'app_store_link', ''),
    (352, 'invitation_user_limit', '5'),
    (353, 'invitation_expire_period', 'month'),
    (354, 'invitation_send_method', 'email'),
    (355, 'appgallery_badge_enabled', '0'),
    (356, 'appgallery_store_link', ''),
    (357, 'points_per_follow', '5'),
    (358, 'points_per_referred', '5'),
    (359, 'newsfeed_results', '12'),
    (365, 'ads_approval_enabled', '0'),
    (407, 'uploads_cdn_url', ''),
    (592, 'affiliates_levels', '5'),
    (692, 'voice_notes_durtaion', '120'),
    (693, 'voice_notes_encoding', 'wav'),
    (702, 'pages_results', '12'),
    (729, 'groups_results', '12'),
    (730, 'events_results', '12'),
    (921, 'system_currency_dir', 'left'),
    (968, 'games_results', '12'),
    (1004, 'newsfeed_public', '0'),
    (1005, 'search_results', '12'),
    (1006, 'auto_play_videos', '0'),
    (1010, 'wasabi_enabled', '0'),
    (1011, 'wasabi_bucket', ''),
    (1012, 'wasabi_region', ''),
    (1013, 'wasabi_key', ''),
    (1014, 'wasabi_secret', ''),
    (1028, 'marketplace_results', '12'),
    (1029, 'offers_results', '12'),
    (1030, 'jobs_results', '12'),
    (1068, 'activation_required', '1'),
    (1191, 's3', '0'),
    (1195, 'google_cloud_enabled', '0'),
    (1196, 'google_cloud_bucket', ''),
    (1197, 'google_cloud_file', ''),
    (1198, 'html_richtext_enabled', '0'),
    (1199, 'razorpay_enabled', '0'),
    (1200, 'razorpay_key_id', ''),
    (1201, 'razorpay_key_secret', ''),
    (1214, 'cashfree_enabled', '0'),
    (1215, 'cashfree_mode', ''),
    (1216, 'cashfree_client_id', ''),
    (1217, 'cashfree_client_secret', ''),
    (1228, 'coinbase_enabled', '0'),
    (1229, 'coinbase_api_key', ''),
    (1238, 'shift4_enabled', '0'),
    (1239, 'shift4_api_key', ''),
    (1240, 'shift4_api_secret', ''),
    (1247, 'special_characters_enabled', '1'),
    (1286, 'backblaze_enabled', '0'),
    (1287, 'backblaze_bucket', ''),
    (1288, 'backblaze_region', ''),
    (1289, 'backblaze_key', ''),
    (1290, 'backblaze_secret', ''),
    (1291, 'ffmpeg_enabled', '0'),
    (1292, 'ffmpeg_path', ''),
    (1293, 'ffmpeg_speed', 'medium'),
    (1294, 'reserved_usernames_enabled', '1'),
    (1295, 'reserved_usernames', '[{&quot;value&quot;:&quot;activation&quot;},{&quot;value&quot;:&quot;admin&quot;},{&quot;value&quot;:&quot;admincp&quot;},{&quot;value&quot;:&quot;administrator&quot;},{&quot;value&quot;:&quot;admins&quot;},{&quot;value&quot;:&quot;ads&quot;},{&quot;value&quot;:&quot;api&quot;},{&quot;value&quot;:&quot;apis&quot;},{&quot;value&quot;:&quot;blog&quot;},{&quot;value&quot;:&quot;blogs&quot;},{&quot;value&quot;:&quot;boosted&quot;},{&quot;value&quot;:&quot;bootstrap&quot;},{&quot;value&quot;:&quot;category&quot;},{&quot;value&quot;:&quot;ccbill&quot;},{&quot;value&quot;:&quot;connect&quot;},{&quot;value&quot;:&quot;contact&quot;},{&quot;value&quot;:&quot;contacts&quot;},{&quot;value&quot;:&quot;content&quot;},{&quot;value&quot;:&quot;course&quot;},{&quot;value&quot;:&quot;courses&quot;},{&quot;value&quot;:&quot;cronjob&quot;},{&quot;value&quot;:&quot;dating&quot;},{&quot;value&quot;:&quot;developer&quot;},{&quot;value&quot;:&quot;developers&quot;},{&quot;value&quot;:&quot;directory&quot;},{&quot;value&quot;:&quot;discover&quot;},{&quot;value&quot;:&quot;docker&quot;},{&quot;value&quot;:&quot;embed&quot;},{&quot;value&quot;:&quot;event&quot;},{&quot;value&quot;:&quot;events&quot;},{&quot;value&quot;:&quot;files&quot;},{&quot;value&quot;:&quot;forum&quot;},{&quot;value&quot;:&quot;forums&quot;},{&quot;value&quot;:&quot;funding&quot;},{&quot;value&quot;:&quot;game&quot;},{&quot;value&quot;:&quot;games&quot;},{&quot;value&quot;:&quot;going&quot;},{&quot;value&quot;:&quot;group&quot;},{&quot;value&quot;:&quot;groups&quot;},{&quot;value&quot;:&quot;includes&quot;},{&quot;value&quot;:&quot;index&quot;},{&quot;value&quot;:&quot;install&quot;},{&quot;value&quot;:&quot;interested&quot;},{&quot;value&quot;:&quot;invited&quot;},{&quot;value&quot;:&quot;job&quot;},{&quot;value&quot;:&quot;jobs&quot;},{&quot;value&quot;:&quot;joined&quot;},{&quot;value&quot;:&quot;liked&quot;},{&quot;value&quot;:&quot;live&quot;},{&quot;value&quot;:&quot;login&quot;},{&quot;value&quot;:&quot;logout&quot;},{&quot;value&quot;:&quot;manage&quot;},{&quot;value&quot;:&quot;market&quot;},{&quot;value&quot;:&quot;memories&quot;},{&quot;value&quot;:&quot;merit&quot;},{&quot;value&quot;:&quot;merits&quot;},{&quot;value&quot;:&quot;message&quot;},{&quot;value&quot;:&quot;messages&quot;},{&quot;value&quot;:&quot;modcp&quot;},{&quot;value&quot;:&quot;moderator&quot;},{&quot;value&quot;:&quot;moderators&quot;},{&quot;value&quot;:&quot;modules&quot;},{&quot;value&quot;:&quot;movie&quot;},{&quot;value&quot;:&quot;movies&quot;},{&quot;value&quot;:&quot;notification&quot;},{&quot;value&quot;:&quot;notifications&quot;},{&quot;value&quot;:&quot;offer&quot;},{&quot;value&quot;:&quot;offers&quot;},{&quot;value&quot;:&quot;package&quot;},{&quot;value&quot;:&quot;packages&quot;},{&quot;value&quot;:&quot;page&quot;},{&quot;value&quot;:&quot;pages&quot;},{&quot;value&quot;:&quot;payment_status&quot;},{&quot;value&quot;:&quot;people&quot;},{&quot;value&quot;:&quot;photo&quot;},{&quot;value&quot;:&quot;photos&quot;},{&quot;value&quot;:&quot;popular&quot;},{&quot;value&quot;:&quot;post&quot;},{&quot;value&quot;:&quot;posts&quot;},{&quot;value&quot;:&quot;profile&quot;},{&quot;value&quot;:&quot;reel&quot;},{&quot;value&quot;:&quot;reels&quot;},{&quot;value&quot;:&quot;register&quot;},{&quot;value&quot;:&quot;reset&quot;},{&quot;value&quot;:&quot;revoke&quot;},{&quot;value&quot;:&quot;saved&quot;},{&quot;value&quot;:&quot;scheduled&quot;},{&quot;value&quot;:&quot;search&quot;},{&quot;value&quot;:&quot;setting&quot;},{&quot;value&quot;:&quot;settings&quot;},{&quot;value&quot;:&quot;share&quot;},{&quot;value&quot;:&quot;signin&quot;},{&quot;value&quot;:&quot;signout&quot;},{&quot;value&quot;:&quot;signup&quot;},{&quot;value&quot;:&quot;sockets&quot;},{&quot;value&quot;:&quot;started&quot;},{&quot;value&quot;:&quot;static&quot;},{&quot;value&quot;:&quot;support&quot;},{&quot;value&quot;:&quot;upgraded&quot;},{&quot;value&quot;:&quot;vendor&quot;},{&quot;value&quot;:&quot;wallet&quot;},{&quot;value&quot;:&quot;watch&quot;},{&quot;value&quot;:&quot;webhooks&quot;},{&quot;value&quot;:&quot;update&quot;}]'),
    (1310, 'getting_started_profile_image_required', '0'),
    (1311, 'getting_started_location_required', '0'),
    (1312, 'getting_started_education_required', '0'),
    (1313, 'getting_started_work_required', '0'),
    (1314, 'posts_views_enabled', '1'),
    (1425, 'points_per_post_view', '0.001'),
    (1548, 'newsfeed_location_filter_enabled', '1'),
    (1833, 'monetization_wallet_payment_enabled', '1'),
    (1834, 'content_monetization_commission', '10'),
    (1836, 'system_logo_dark', ''),
    (1837, 'monetization_enabled', '0'),
    (1839, 'monetization_money_withdraw_enabled', '1'),
    (1840, 'monetization_payment_method_custom', ''),
    (1841, 'monetization_min_withdrawal', '50'),
    (1842, 'monetization_money_transfer_enabled', '1'),
    (1843, 'monetization_commission', '10'),
    (1844, 'monetization_payment_method', 'paypal,skrill'),
    (1855, 'watch_enabled', '1'),
    (1929, 'tips_enabled', '0'),
    (1931, 'tips_min_amount', '1'),
    (1932, 'tips_max_amount', '100'),
    (2047, 'allow_animated_images', '1'),
    (2059, 'system_description_pages', 'Discover pages'),
    (2060, 'system_description_groups', 'Discover groups'),
    (2061, 'system_description_events', 'Discover events'),
    (2062, 'system_description_games', 'Discover new games'),
    (2063, 'system_morning_message', 'Write it on your heart that every day is the best day in the year'),
    (2064, 'system_afternoon_message', 'May Your Good Afternoon Be Light, Blessed, Productive And Happy'),
    (2065, 'system_evening_message', 'We hope you are enjoying your evening'),
    (2129, 'moneypoolscash_enabled', '0'),
    (2130, 'moneypoolscash_api_key', ''),
    (2131, 'moneypoolscash_merchant_email', ''),
    (2148, 'wordpress_login_enabled', '0'),
    (2149, 'wordpress_appid', ''),
    (2150, 'wordpress_secret', ''),
    (2244, 'moneypoolscash_merchant_password', ''),
    (2266, 'default_custom_user_group', '0'),
    (2285, 'verification_docs_required', '1'),
    (2454, 'sngine_login_enabled', '0'),
    (2455, 'sngine_appid', ''),
    (2456, 'sngine_secret', ''),
    (2499, 'sngine_app_domain', ''),
    (2522, 'sngine_app_name', ''),
    (2570, 'sngine_app_icon', ''),
    (2571, 'market_money_withdraw_enabled', '1'),
    (2572, 'market_payment_method', 'paypal,skrill'),
    (2573, 'market_payment_method_custom', ''),
    (2574, 'market_min_withdrawal', '50'),
    (2575, 'market_money_transfer_enabled', '1'),
    (2576, 'market_commission', '10'),
    (2577, 'sms_limit', '3'),
    (2596, 'switch_accounts_enabled', '1'),
    (2597, 'wallet_max_transfer', '5'),
    (2753, 'packages_ads_free_enabled', '1'),
    (2823, 'paypal_webhook', ''),
    (2856, 'reviews_enabled', '1'),
    (2857, 'reviews_replacement_enabled', '1'),
    (2858, 'genders_disabled', '0'),
    (2859, 'stripe_webhook', ''),
    (2860, 'ffmpeg_240p_enabled', 'on'),
    (2861, 'ffmpeg_360p_enabled', 'on'),
    (2862, 'ffmpeg_480p_enabled', 'on'),
    (2863, 'ffmpeg_720p_enabled', 'on'),
    (2864, 'ffmpeg_1080p_enabled', 'on'),
    (2865, 'ffmpeg_1440p_enabled', ''),
    (2866, 'ffmpeg_2160p_enabled', ''),
    (2990, 'fluid_videos_enabled', '1'),
    (2991, 'pages_events_enabled', '1'),
    (2992, 'verification_for_monetization', '0'),
    (2993, 'verification_for_adult_content', '0'),
    (3004, 'adult_mode', '1'),
    (3119, 'payment_vat_enabled', '0'),
    (3120, 'payment_country_vat_enabled', '0'),
    (3121, 'payment_vat_percentage', '20'),
    (3122, 'payment_fees_enabled', '1'),
    (3123, 'payment_fees_percentage', '1'),
    (3125, 'watermark_videos_enabled', '0'),
    (3126, 'watermark_videos_icon', ''),
    (3127, 'watermark_videos_position', 'center'),
    (3128, 'watermark_videos_opacity', '0.5'),
    (3129, 'watermark_videos_xoffset', '10'),
    (3130, 'watermark_videos_yoffset', '10'),
    (3131, 'posts_approval_enabled', '0'),
    (3132, 'posts_approval_limit', '5'),
    (3133, 'verification_for_posts', '0'),
    (3134, 'email_admin_verifications', '0'),
    (3135, 'email_admin_post_approval', '0'),
    (3136, 'email_user_verification', '0'),
    (3137, 'email_user_post_approval', '0'),
    (3162, 'posts_views_type', 'unique'),
    (3163, 'market_shopping_cart_enabled', '1'),
    (3164, 'pages_reviews_enabled', '1'),
    (3165, 'pages_reviews_replacement_enabled', '1'),
    (3166, 'groups_reviews_enabled', '1'),
    (3167, 'groups_reviews_replacement_enabled', '1'),
    (3168, 'events_reviews_enabled', '1'),
    (3169, 'events_reviews_replacement_enabled', '1'),
    (3310, 'posts_reviews_enabled', '1'),
    (3311, 'posts_reviews_replacement_enabled', '1'),
    (3313, 'authorize_net_enabled', '0'),
    (3314, 'authorize_net_api_login_id', ''),
    (3315, 'authorize_net_transaction_key', ''),
    (3400, 'authorize_net_mode', 'sandbox'),
    (3401, 'users_approval_enabled', '0'),
    (3476, 'email_admin_user_approval', '0'),
    (3498, 'courses_enabled', '0'),
    (3518, 'courses_results', '12'),
    (3569, 'system_description_courses', 'Discover new courses'),
    (3570, 'disable_username_changes', '0'),
    (3571, 'user_privacy_chat', 'public'),
    (3572, 'user_privacy_poke', 'public'),
    (3573, 'user_privacy_gifts', 'public'),
    (3574, 'user_privacy_wall', 'public'),
    (3575, 'user_privacy_gender', 'public'),
    (3576, 'user_privacy_relationship', 'public'),
    (3577, 'user_privacy_birthdate', 'public'),
    (3578, 'user_privacy_basic', 'public'),
    (3579, 'user_privacy_work', 'public'),
    (3580, 'user_privacy_location', 'public'),
    (3581, 'user_privacy_education', 'public'),
    (3582, 'user_privacy_other', 'public'),
    (3583, 'user_privacy_friends', 'public'),
    (3584, 'user_privacy_followers', 'public'),
    (3585, 'user_privacy_subscriptions', 'public'),
    (3586, 'user_privacy_photos', 'public'),
    (3587, 'user_privacy_pages', 'public'),
    (3588, 'user_privacy_groups', 'public'),
    (3589, 'user_privacy_events', 'public'),
    (3714, 'yandex_cloud_enabled', '0'),
    (3715, 'yandex_cloud_bucket', ''),
    (3716, 'yandex_cloud_region', ''),
    (3717, 'yandex_cloud_key', ''),
    (3718, 'yandex_cloud_secret', ''),
    (3719, 'points_per_post_comment', '6'),
    (3720, 'points_per_post_reaction', '6'),
    (3754, 'profile_posts_updates_disabled', '0'),
    (3844, 'monetization_max_paid_post_price', '0'),
    (3845, 'monetization_max_plan_price', '0'),
    (3864, 'watermark_type', 'username'),
    (3865, 'download_images_disabled', '0'),
    (3866, 'right_click_disabled', '0'),
    (3867, 'myfatoorah_enabled', '0'),
    (3868, 'myfatoorah_mode', ''),
    (3869, 'myfatoorah_test_token', ''),
    (3870, 'myfatoorah_live_token', ''),
    (3871, 'myfatoorah_live_api_url', ''),
    (3872, 'select_user_group_enabled', '0'),
    (3948, 'show_user_group_enabled', '0'),
    (3949, 'funding_wallet_payment_enabled', '1'),
    (3950, 'epayco_enabled', '0'),
    (3951, 'epayco_mode', ''),
    (3952, 'epayco_public_key', ''),
    (3953, 'epayco_private_key', ''),
    (3954, 'friends_enabled', '1'),
    (4050, 'flutterwave_enabled', '0'),
    (4051, 'flutterwave_mode', ''),
    (4052, 'flutterwave_public_key', ''),
    (4053, 'flutterwave_secret_key', ''),
    (4054, 'flutterwave_encryption_key', ''),
    (4055, 'max_daily_upload_size', '0'),
    (4372, 'pages_pbid_enabled', '1'),
    (4374, 'activities_edit_limit', '15'),
    (4375, 'stripe_payment_element_enabled', '1'),
    (4606, 'blogs_results', '12'),
    (4624, 'funding_results', '12'),
    (4719, 'verotel_enabled', '0'),
    (4721, 'verotel_shop_id', ''),
    (4722, 'verotel_signature_key', ''),
    (4723, 'auto_language_detection', '1'),
    (4724, 'paypal_payouts_enabled', '0'),
    (4725, 'moneypoolscash_payouts_enabled', '0'),
    (4726, 'reels_enabled', '1'),
    (4727, 'google_translation_key', ''),
    (4775, 'chat_translation_enabled', '0'),
    (4776, 'market_wallet_payment_enabled', '1'),
    (4784, 'censored_domains_enabled', '0'),
    (4785, 'censored_domains', ''),
    (4786, 'mods_users_permission', '1'),
    (4793, 'mods_posts_permission', '1'),
    (4794, 'mods_pages_permission', '1'),
    (4795, 'mods_groups_permission', '1'),
    (4796, 'mods_events_permission', '1'),
    (4797, 'mods_blogs_permission', '1'),
    (4798, 'mods_offers_permission', '1'),
    (4799, 'mods_jobs_permission', '1'),
    (4800, 'mods_courses_permission', '1'),
    (4801, 'mods_forums_permission', '1'),
    (4802, 'mods_movies_permission', '1'),
    (4803, 'mods_games_permission', '1'),
    (4804, 'mods_reports_permission', '1'),
    (4805, 'mods_verifications_permission', '1'),
    (5083, 'mods_ads_permission', '0'),
    (5084, 'mods_wallet_permission', '0'),
    (5085, 'mods_affiliates_permission', '0'),
    (5086, 'mods_points_permission', '0'),
    (5087, 'mods_marketplace_permission', '0'),
    (5088, 'mods_funding_permission', '0'),
    (5089, 'mods_monetization_permission', '0'),
    (5090, 'mods_tips_permission', '0'),
    (5091, 'mods_payments_permission', '0'),
    (5092, 'mods_developers_permission', '1'),
    (5093, 'mods_blacklist_permission', '1'),
    (5094, 'mods_customization_permission', '1'),
    (5095, 'mods_reach_permission', '1'),
    (5137, 'mods_pro_permission', '0'),
    (5138, 'ads_author_view_enabled', '1'),
    (5156, 'audio_video_provider', 'agora'),
    (5157, 'livekit_api_key', ''),
    (5158, 'livekit_api_secret', ''),
    (5159, 'livekit_ws_url', ''),
    (5160, 'cover_crop_enabled', '0'),
    (5210, 'market_cod_payment_enabled', '0'),
    (5211, 'chunk_upload_size', '100'),
    (5719, 'smooth_infinite_scroll', '0'),
    (5771, 'newsfeed_merge_enabled', '0'),
    (5772, 'merge_recent_results', '12'),
    (5773, 'merge_popular_results', '3'),
    (5774, 'merge_discover_results', '3'),
    (5775, 'newsfeed_caching_enabled', '0'),
    (5796, 'popular_posts_interval', 'month'),
    (6017, 'pwa_enabled', '0'),
    (6018, 'pwa_192_icon', ''),
    (6019, 'pwa_512_icon', ''),
    (6020, 'pwa_banner_enabled', '1'),
    (6249, 'mask_file_path_enabled', '1'),
    (6252, 'disable_yt_player', '1'),
    (6614, 'mercadopago_enabled', '0'),
    (6615, 'mercadopago_public_key', ''),
    (6616, 'mercadopago_access_token', ''),
    (6797, 'merits_enabled', '0'),
    (6798, 'merits_peroid_max', '10'),
    (6799, 'merits_send_peroid_max', '5'),
    (6800, 'merits_peroid', '1'),
    (6805, 'merits_notifications_recharge', '1'),
    (6806, 'merits_notifications_reminder', '1'),
    (6807, 'merits_notifications_recipient', '1'),
    (6821, 'merits_widgets_winners', '1'),
    (6822, 'merits_widgets_balance', '1'),
    (6823, 'merits_widgets_statistics', '1'),
    (6868, 'merits_peroid_reset', '1'),
    (6944, 'cronjob_hash', '7d6c10684ae17ff98317c4b62e8b90d8'),
    (6948, 'cronjob_enabled', '0'),
    (6949, 'cronjob_reset_pro_packages', '1'),
    (6950, 'cronjob_merits_reminder', '1'),
    (6955, 'merits_notifications_sender', '1'),
    (6994, 'system_back_swipe', '0'),
    (7097, 'posts_schedule_enabled', '1'),
    (7100, 'whitelist_enabled', '0'),
    (7101, 'whitelist_providers', ''),
    (7394, 'allow_heif_images', '0'),
    (7501, 'affiliate_payment_to', 'buyer'),
    (7502, 'affiliates_per_user_2', '0.20'),
    (7503, 'affiliates_percentage_2', '20'),
    (7504, 'affiliates_per_user_3', '0.15'),
    (7505, 'affiliates_percentage_3', '15'),
    (7506, 'affiliates_per_user_4', '0.10'),
    (7507, 'affiliates_percentage_4', '10'),
    (7508, 'affiliates_per_user_5', '0.05'),
    (7509, 'affiliates_percentage_5', '5'),
    (7522, 'turnstile_enabled', '0'),
    (7523, 'turnstile_site_key', ''),
    (7524, 'turnstile_secret_key', ''),
    (7561, 'password_complexity_enabled', '0'),
    (7612, 'market_delivery_days', '30'),
    (7640, 'cronjob_undelivered_orders', '1'),
    (8259, 'system_api_key', ''),
    (8260, 'system_api_secret', ''),
    (8272, 'system_jwt_key', '4d459d1451454e53d20b7d67c7cd69af'),
    (8389, 'onesignal_messenger_notification_enabled', '0'),
    (8390, 'onesignal_messenger_app_id', ''),
    (8391, 'onesignal_messenger_api_key', ''),
    (8392, 'onesignal_timeline_notification_enabled', '0'),
    (8393, 'onesignal_timeline_app_id', ''),
    (8394, 'onesignal_timeline_api_key', ''),
    (8489, 'cloudflare_r2_enabled', '0'),
    (8490, 'cloudflare_r2_bucket', ''),
    (8491, 'cloudflare_r2_key', ''),
    (8492, 'cloudflare_r2_secret', ''),
    (8493, 'cloudflare_r2_endpoint', ''),
    (8501, 'cloudflare_r2_custom_domain', ''),
    (8691, 'chat_socket_enabled', '0'),
    (8692, 'chat_socket_port', '3000'),
    (8693, 'chat_socket_ssl_crt', ''),
    (8694, 'chat_socket_ssl_key', ''),
    (8695, 'chat_socket_ssl_verify_peer', '1'),
    (8696, 'chat_socket_ssl_allow_self_signed', '0'),
    (8769, 'chat_socket_server', 'php'),
    (8770, 'php_bin_path', ''),
    (8771, 'nodejs_bin_path', ''),
    (9132, 'cronjob_clear_pending_uploads', '1'),
    (9439, 'pushr_enabled', '0'),
    (9440, 'pushr_bucket', ''),
    (9441, 'pushr_key', ''),
    (9442, 'pushr_secret', ''),
    (9443, 'pushr_endpoint', ''),
    (9444, 'pushr_hostname', ''),
    (9870, 'agora_call_app_id', ''),
    (9871, 'agora_call_app_certificate', ''),
    (10003, 'msg91_template_id', ''),
    (10315, 'pro_users_widget_enabled', '1'),
    (10316, 'pro_page_widget_enabled', '1'),
    (10534, 'name_max_length', '12'),
    (10735, 'chat_socket_proxied', '1'),
    (11521, 'pro_groups_widget_enabled', '0'),
    (11522, 'pro_events_widget_enabled', '0'),
    (11668, 'plisio_enabled', '0'),
    (11669, 'plisio_secret_key', ''),
    (11670, 'chat_videos_enabled', '1'),
    (11687, 'market_digital_products_enabled', '1'),
    (11760, 'ageverif_enabled', '0'),
    (11761, 'ageverif_api_key', ''),
    (11822, 'reels_minimum_duration', '0'),
    (11823, 'reels_maximum_duration', '0'),
    (11919, 'video_minimum_duration', '0'),
    (11920, 'video_maximum_duration', '0'),
    (12025, 'paid_blogs_enabled', '0'),
    (12026, 'paid_blogs_cost', '0'),
    (12027, 'paid_products_enabled', '0'),
    (12028, 'paid_products_cost', '0'),
    (12029, 'paid_funding_enabled', '0'),
    (12030, 'paid_funding_cost', '0'),
    (12031, 'paid_offers_enabled', '0'),
    (12032, 'paid_offers_cost', '0'),
    (12033, 'paid_jobs_enabled', '0'),
    (12034, 'paid_jobs_cost', '0'),
    (12035, 'paid_courses_enabled', '0'),
    (12036, 'paid_courses_cost', '0'),
    (12293, 'redirect_to_mobile_apps', '0'),
    (12294, 'messaging_app_android_link', ''),
    (12295, 'messaging_app_ios_link', ''),
    (12320, 'gifts_points_enabled', '0'),
    (12369, 'blogs_widget_enabled', '1'),
    (12371, 'support_center_enabled', '1'),
    (13200, 'pages_location_filter_enabled', '1'),
    (13201, 'groups_location_filter_enabled', '1'),
    (13202, 'events_location_filter_enabled', '1'),
    (13330, 'collaborative_posts_enabled', '1'),
    (13332, 'user_privacy_collaborative', 'public'),
    (13519, 'monetization_discounts_enabled', '1'),
    (13683, 'ai_posts_enabled', '0'),
    (13684, 'ai_posts_provider', 'openai'),
    (13685, 'ai_blogs_enabled', '0'),
    (13686, 'ai_blogs_provider', 'openai'),
    (13687, 'ai_images_enabled', '0'),
    (13688, 'ai_images_provider', 'openai'),
    (13695, 'openai_api_key', ''),
    (13696, 'openai_text_model', ''),
    (13697, 'replicate_api_token', ''),
    (13698, 'replicate_model', ''),
    (13699, 'replicate_denoising_steps', '1'),
    (13700, 'replicate_guidance_scale', '1'),
    (13701, 'replicate_seed', ''),
    (13716, 'ai_credit_cost', '100'),
    (13717, 'ai_text_credit_enabled', '1'),
    (13718, 'ai_generated_word_cost', '10'),
    (13719, 'ai_image_credit_enabled', '1'),
    (13720, 'ai_generated_image_cost', '25'),
    (13750, 'system_description_watch', 'Explore the latest videos'),
    (14159, 'openai_image_model', ''),
    (14460, 'ai_mode', 'live'),
    (14616, 'captcha_enabled', '0'),
    (14617, 'captcha_provider', 'recaptcha'),
    (14618, 'hcaptcha_site_key', ''),
    (14619, 'hcaptcha_secret_key', ''),
    (14732, 'oxxo_enabled', '0'),
    (14870, 'blik_enabled', '0'),
    (14871, 'eps_enabled', '0'),
    (14951, 'ideal_enabled', '0'),
    (15205, 'cashapp_enabled', '0'),
    (15278, 'bancontact_enabled', '0'),
    (15417, 'przelewy24_enabled', '0'),
    (15627, 'ccbill_enabled', '0'),
    (15628, 'ccbill_account_number', ''),
    (15629, 'ccbill_recurring_subaccount_number', ''),
    (15630, 'ccbill_one_time_subaccount_number', ''),
    (15631, 'ccbill_flexform_id', ''),
    (15632, 'ccbill_salt_key', ''),
    (15633, 'ccbill_datalink_username', ''),
    (15634, 'ccbill_datalink_password', ''),
    (15716, 'apple_login_enabled', '0'),
    (15717, 'apple_appid', ''),
    (15718, 'apple_team_id', ''),
    (15719, 'apple_key_id', ''),
    (15720, 'apple_key_content', ''),
    (15746, 'discord_login_enabled', '0'),
    (15747, 'discord_appid', ''),
    (15748, 'discord_secret', ''),
    (16178, 'rich_text_posts_enabled', '1'),
    (16297, 'video_embed_code_enabled', '1'),
    (16400, 'incognito_mode_enabled', '1'),
    (16401, 'panic_mode_enabled', ''),
    (16999, 'affiliates_per_user_6', ''),
    (17000, 'affiliates_percentage_6', ''),
    (17001, 'affiliates_per_user_7', ''),
    (17002, 'affiliates_percentage_7', ''),
    (17003, 'affiliates_per_user_8', ''),
    (17004, 'affiliates_percentage_8', ''),
    (17005, 'affiliates_per_user_9', ''),
    (17006, 'affiliates_percentage_9', ''),
    (17007, 'affiliates_per_user_10', ''),
    (17008, 'affiliates_percentage_10', ''),
    (17769, 'themes_demo_enabled', '0'),
    (17847, 'movies_results', '12'),
    (17909, 'people_results', '12'),
    (17934, 'posts_read_more_lines', '5'),
    (17935, 'comments_read_more_lines', '3'),
    (17966, 'chat_files_enabled', '1'),
    (17967, 'chat_max_media', '10'),
    (18038, 'blogs_rss_enabled', '1'),
    (18088, 'posts_edit_limit_enabled', '0'),
    (18089, 'posts_edit_limit', '24'),
    (18090, 'pages_messages_enabled', '1'),
    (18101, 'cronjob_post_views_cleanup', '1'),
    (18107, 'posts_views_period', 'lifetime'),
    (18108, 'posts_views_days', '1'),
    (18109, 'posts_views_maintenance', 'idle'),
    (18110, 'posts_views_schema_version', '1'),
    (18111, 'posts_views_cleanup_time', ''),
    (18112, 'posts_views_cleanup_result', ''),
    (18113, 'posts_views_cleanup_error', ''),
    (18132, 'ovh_enabled', '0'),
    (18133, 'ovh_bucket', ''),
    (18134, 'ovh_region', ''),
    (18135, 'ovh_key', ''),
    (18136, 'ovh_secret', ''),
    (18218, 'ads_budget_priority_enabled', '1'),
    (18225, 'iyzico_enabled', '0'),
    (18226, 'iyzico_mode', 'sandbox'),
    (18227, 'iyzico_api_key', ''),
    (18228, 'iyzico_secret_key', ''),
    (18311, 'live_provider', 'agora'),
    (18312, 'livekit_live_api_key', ''),
    (18313, 'livekit_live_api_secret', ''),
    (18314, 'livekit_live_ws_url', ''),
    (18315, 'agora_s3_endpoint', ''),
    (18316, 'agora_s3_public_url', ''),
    (18355, 'live_rtmp_enabled', '0'),
    (18373, 'live_results', '12'),
    (18374, 'system_description_live', 'Watch live streams and support your favorite creators'),
    (18418, 'watch_results', '12'),
    (18512, 'redis_enabled', '0'),
    (18513, 'redis_host', '127.0.0.1'),
    (18514, 'redis_port', '6379'),
    (18515, 'redis_database', '0'),
    (18516, 'redis_password', ''),
    (18517, 'redis_prefix', ''),
    (18518, 'redis_tls_enabled', '0'),
    (18519, 'redis_widgets_enabled', '1'),
    (18520, 'redis_relations_enabled', '1'),
    (18521, 'redis_sessions_enabled', '1'),
    (18522, 'redis_post_views_enabled', '1'),
    (18536, 'blogs_search_content_enabled', '1'),
    (18537, 'posts_search_ready', '0'),
    (18538, 'posts_search_cursor', '0'),
    (18687, 'download_videos_disabled', '0'),
    (18728, 'cronjob_last_run', ''),
    (18729, 'translation_provider', 'google'),
    (18730, 'deepl_key', ''),
    (18731, 'libretranslate_url', ''),
    (18732, 'libretranslate_key', ''),
    (18740, 'geolocation_provider', 'google'),
    (18741, 'geolocation_osm_url', 'https://photon.komoot.io'),
    (18826, 'ipinfo_enabled', '0'),
    (18827, 'ipinfo_token', ''),
    (18828, 'login_alerts_enabled', '0'),
    (18829, 'sitemap_enabled', '1'),
    (18830, 'sitemap_types', 'site,posts,blogs,products,jobs,offers,courses,funding,reels,users,pages,groups,events,forums,movies,games'),
    (18831, 'sitemap_urls_per_file', '10000'),
    (18832, 'sitemap_refresh', '60'),
    (18833, 'sitemap_images_enabled', '1'),
    (18834, 'sitemap_videos_enabled', '1'),
    (18835, 'indexnow_enabled', '1'),
    (18836, 'indexnow_key', ''),
    (18837, 'robots_txt', 'User-agent: *\r\nDisallow: /content/backups\r\nDisallow: /content/languages\r\nDisallow: /includes/libs\r\nDisallow: /install\r\nDisallow: /admincp\r\nDisallow: /modcp'),
    (18838, 'llms_enabled', '1'),
    (18839, 'llms_notes', ''),
    (18946, 'live_chat_rules', 'Please respect the host and other viewers. No harassment, spam, threats, or inappropriate content. Violations may result in removal from the chat.'),
    (18947, 'live_moderation_enabled', '1'),
    (18979, 'dating_enabled', '0'),
    (18980, 'mods_dating_permission', '0'),
    (18981, 'dating_min_age', '18'),
    (18982, 'dating_verified_only', '0'),
    (18983, 'dating_photos_approval', '0'),
    (18984, 'dating_max_photos', '6'),
    (18985, 'dating_free_swipes', '50'),
    (18986, 'dating_free_likes_list', '0'),
    (18987, 'dating_max_distance', '500'),
    (18988, 'dating_results', '12'),
    (18989, 'dating_ads_frequency', '8'),
    (18990, 'dating_super_likes_pack', '5'),
    (18991, 'dating_super_likes_price', '0'),
    (18992, 'dating_boost_minutes', '30'),
    (18993, 'dating_boost_price', '0'),
    (18994, 'dating_priority_message_price', '0'),
    (19010, 'module_names', ''),
    (19027, 'dating_max_interests', '10'),
    (19087, 'stories_music_enabled', '1'),
    (19088, 'stories_music_itunes_enabled', '1'),
    (19089, 'stories_music_library_enabled', '1'),
    (19090, 'stories_music_itunes_country', 'US'),
    (19091, 'mods_stories_permission', '0'),
    (19092, 'stories_text_enabled', '1'),
    (19093, 'stories_reactions_enabled', '1'),
    (19094, 'stories_replies_enabled', '1'),
    (19095, 'stories_polls_enabled', '1'),
    (19096, 'stories_highlights_enabled', '1'),
    (19097, 'stories_video_max_duration', '60'),
    (19139, 'blogs_cover_required', '1'),
    (19188, 'stories_design', 'cards'),
    (19312, 'stories_archive_enabled', '1'),
    (19350, 'verification_user_photo_enabled', '1'),
    (19351, 'verification_user_photo_title', 'Your Photo'),
    (19352, 'verification_user_passport_enabled', '1'),
    (19353, 'verification_user_passport_title', 'Passport or National ID'),
    (19354, 'verification_page_photo_enabled', '1'),
    (19355, 'verification_page_photo_title', 'Company Incorporation File'),
    (19356, 'verification_page_passport_enabled', '1'),
    (19357, 'verification_page_passport_title', 'Company Tax File'),
    (19359, 'forums_rss_enabled', '1'),
    (19365, 'bunny_enabled', '0'),
    (19366, 'bunny_zone', ''),
    (19367, 'bunny_password', ''),
    (19368, 'bunny_region', ''),
    (19369, 'bunny_url', ''),
    (19446, 'watermark_x', '95'),
    (19447, 'watermark_y', '95'),
    (19448, 'watermark_videos_x', '50'),
    (19449, 'watermark_videos_y', '50'),
    (19504, 'storj_enabled', '0'),
    (19505, 'storj_bucket', ''),
    (19506, 'storj_key', ''),
    (19507, 'storj_secret', ''),
    (19508, 'storj_endpoint', ''),
    (19509, 'storj_url', ''),
    (19667, 'infobip_base_url', ''),
    (19668, 'infobip_api_key', ''),
    (19669, 'infobip_sender', '');

    -- --------------------------------------------------------

    --
    -- Table structure for table `system_reactions`
    --

    CREATE TABLE `system_reactions` (
      `reaction_id` int UNSIGNED NOT NULL,
      `reaction` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `title` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `color` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `image` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `reaction_order` int UNSIGNED NOT NULL DEFAULT '1',
      `enabled` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    --
    -- Dumping data for table `system_reactions`
    --

    INSERT INTO `system_reactions` (`reaction_id`, `reaction`, `title`, `color`, `image`, `reaction_order`, `enabled`) VALUES
    (1, 'like', 'Like', '#1e8bd2', 'reactions/like.png', 1, '1'),
    (2, 'love', 'Love', '#f25268', 'reactions/love.png', 2, '1'),
    (3, 'haha', 'Haha', '#f3b715', 'reactions/haha.png', 3, '1'),
    (4, 'yay', 'Yay', '#F3B715', 'reactions/yay.png', 4, '1'),
    (5, 'wow', 'Wow', '#f3b715', 'reactions/wow.png', 5, '1'),
    (6, 'sad', 'Sad', '#f3b715', 'reactions/sad.png', 6, '1'),
    (7, 'angry', 'Angry', '#f7806c', 'reactions/angry.png', 7, '1');

    -- --------------------------------------------------------

    --
    -- Table structure for table `system_themes`
    --

    CREATE TABLE `system_themes` (
      `theme_id` int UNSIGNED NOT NULL,
      `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `title` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
      `default` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `enabled` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `fluid_design` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `system_theme_night_on` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `system_theme_mode_select` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1',
      `system_theme_icons` enum('tabler','svg') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'tabler',
      `system_theme_fonts` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'google',
      `system_wallpaper_default` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1',
      `system_wallpaper` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
      `css_customized` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `css_background` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
      `css_link_color` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
      `css_header` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
      `css_header_search` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
      `css_header_search_color` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
      `css_btn_primary` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
      `css_header_icons` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
      `css_header_icons_night` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
      `css_main_icons` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
      `css_main_icons_night` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
      `css_action_icons` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
      `css_action_icons_night` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
      `css_custome_css` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
      `landing` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'default',
      `bottom_bar` varchar(512) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
      `sidebar` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
      `sidebar_more` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT ''
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    --
    -- Dumping data for table `system_themes`
    --

    INSERT INTO `system_themes` (`theme_id`, `name`, `title`, `default`, `enabled`, `fluid_design`, `system_theme_night_on`, `system_theme_mode_select`, `system_theme_icons`, `system_theme_fonts`, `system_wallpaper_default`, `system_wallpaper`, `css_customized`, `css_background`, `css_link_color`, `css_header`, `css_header_search`, `css_header_search_color`, `css_btn_primary`, `css_header_icons`, `css_header_icons_night`, `css_main_icons`, `css_main_icons_night`, `css_action_icons`, `css_action_icons_night`, `css_custome_css`, `landing`, `bottom_bar`, `sidebar`, `sidebar_more`) VALUES
    (1, 'nova', 'Nova', '1', '1', '0', '0', '1', 'svg', 'google', '1', '', '0', '', '', '', '', '', '', '', '', '', '', '', '', '', 'default', 'home,reels,add,watch,menu', 'saved,scheduled,memories,stories_archive,people,dating,pages,groups,events,reels,watch,live', 'wallet,ads,boosted,blogs,market,funding,offers,jobs,courses,forums,movies,games,merits,developers,directory');

    -- --------------------------------------------------------

    --
    -- Table structure for table `system_theme_landings`
    --

    CREATE TABLE `system_theme_landings` (
      `landing_id` int UNSIGNED NOT NULL,
      `theme_id` int UNSIGNED NOT NULL,
      `slug` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `title` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `is_default` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    --
    -- Dumping data for table `system_theme_landings`
    --

    INSERT INTO `system_theme_landings` (`landing_id`, `theme_id`, `slug`, `title`, `is_default`) VALUES
    (1, 1, 'default', 'Default', '1'),
    (2, 1, 'aurora', 'Aurora', '0'),
    (3, 1, 'summit', 'Summit', '0'),
    (4, 1, 'studio', 'Studio', '0'),
    (5, 1, 'orbit', 'Orbit', '0'),
    (6, 1, 'liquid', 'Liquid', '0'),
    (7, 1, 'terminal', 'Terminal', '0'),
    (8, 1, 'retro', 'Retro', '0'),
    (9, 1, 'minimal', 'Minimal', '0');

    -- --------------------------------------------------------

    --
    -- Table structure for table `translations_cache`
    --

    CREATE TABLE `translations_cache` (
      `translation_id` int UNSIGNED NOT NULL,
      `node_type` enum('post','page','group','event','message','user') COLLATE utf8mb4_general_ci NOT NULL,
      `node_id` int UNSIGNED NOT NULL,
      `node_field` enum('text','title','description') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `target_lang` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `source_hash` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `source_lang` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `translated_text` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
      `created_at` datetime NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `users`
    --

    CREATE TABLE `users` (
      `user_id` int UNSIGNED NOT NULL,
      `user_master_account` int NOT NULL DEFAULT '0',
      `user_group` tinyint UNSIGNED NOT NULL DEFAULT '3',
      `user_group_custom` int NOT NULL DEFAULT '0',
      `user_demo` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `user_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `user_email` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `user_email_verified` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `user_email_verification_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `user_phone` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `user_phone_verified` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `user_phone_verification_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `user_password` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `user_two_factor_enabled` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `user_two_factor_type` enum('email','sms','google') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `user_two_factor_key` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `user_two_factor_gsecret` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `user_activated` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `user_approved` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `user_reseted` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `user_reset_key` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `user_subscribed` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `user_package` int UNSIGNED DEFAULT NULL,
      `user_package_videos_categories` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
      `user_package_blogs_categories` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
      `user_subscription_date` datetime DEFAULT NULL,
      `user_boosted_posts` int UNSIGNED NOT NULL DEFAULT '0',
      `user_boosted_pages` int UNSIGNED NOT NULL DEFAULT '0',
      `user_boosted_groups` int UNSIGNED NOT NULL DEFAULT '0',
      `user_boosted_events` int UNSIGNED NOT NULL DEFAULT '0',
      `user_started` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `user_verified` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `user_banned` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `user_banned_message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
      `user_live_requests_counter` int UNSIGNED NOT NULL DEFAULT '0',
      `user_live_requests_lastid` int UNSIGNED NOT NULL DEFAULT '0',
      `user_live_messages_counter` int UNSIGNED NOT NULL DEFAULT '0',
      `user_live_messages_lastid` int UNSIGNED NOT NULL DEFAULT '0',
      `user_live_calls_counter` int UNSIGNED NOT NULL DEFAULT '0',
      `user_live_notifications_counter` int UNSIGNED NOT NULL DEFAULT '0',
      `user_live_notifications_lastid` int UNSIGNED NOT NULL DEFAULT '0',
      `user_latitude` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `user_longitude` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `user_location_updated` datetime DEFAULT NULL,
      `user_firstname` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `user_lastname` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `user_gender` int UNSIGNED DEFAULT NULL,
      `user_picture` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `user_picture_id` int UNSIGNED DEFAULT NULL,
      `user_cover` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `user_cover_id` int UNSIGNED DEFAULT NULL,
      `user_cover_position` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `user_album_pictures` int UNSIGNED DEFAULT NULL,
      `user_album_covers` int UNSIGNED DEFAULT NULL,
      `user_album_timeline` int UNSIGNED DEFAULT NULL,
      `user_pinned_post` int UNSIGNED DEFAULT NULL,
      `user_registered` datetime DEFAULT NULL,
      `user_last_seen` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
      `user_first_failed_login` datetime DEFAULT NULL,
      `user_failed_login_ip` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `user_failed_login_count` int UNSIGNED NOT NULL DEFAULT '0',
      `user_country` int UNSIGNED DEFAULT NULL,
      `user_birthdate` date DEFAULT NULL,
      `user_relationship` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `user_biography` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
      `user_website` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `user_work_title` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `user_work_place` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `user_work_url` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `user_current_city` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `user_hometown` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `user_edu_major` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `user_edu_school` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `user_edu_class` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `user_social_facebook` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `user_social_twitter` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `user_social_youtube` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `user_social_instagram` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `user_social_twitch` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `user_social_linkedin` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `user_social_vkontakte` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `user_profile_background` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `user_chat_enabled` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1',
      `user_newsletter_enabled` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1',
      `user_tips_enabled` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1',
      `user_suggestions_hidden` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `user_incognito_enabled` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `user_privacy_chat` enum('me','friends','public') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'public',
      `user_privacy_poke` enum('me','friends','public') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'public',
      `user_privacy_gifts` enum('me','friends','public') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'public',
      `user_privacy_wall` enum('me','friends','public') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'friends',
      `user_privacy_collaborative` enum('me','friends','public') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'me',
      `user_privacy_gender` enum('me','friends','public') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'public',
      `user_privacy_birthdate` enum('me','friends','public') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'public',
      `user_privacy_relationship` enum('me','friends','public') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'public',
      `user_privacy_basic` enum('me','friends','public') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'public',
      `user_privacy_work` enum('me','friends','public') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'public',
      `user_privacy_location` enum('me','friends','public') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'public',
      `user_privacy_education` enum('me','friends','public') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'public',
      `user_privacy_other` enum('me','friends','public') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'public',
      `user_privacy_friends` enum('me','friends','public') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'public',
      `user_privacy_followers` enum('me','friends','public') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'public',
      `user_privacy_photos` enum('me','friends','public') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'public',
      `user_privacy_pages` enum('me','friends','public') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'public',
      `user_privacy_groups` enum('me','friends','public') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'public',
      `user_privacy_events` enum('me','friends','public') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'public',
      `user_privacy_subscriptions` enum('me','friends','public') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'public',
      `email_post_likes` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1',
      `email_post_comments` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1',
      `email_post_shares` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1',
      `email_wall_posts` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1',
      `email_mentions` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1',
      `email_profile_visits` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1',
      `email_friend_requests` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1',
      `email_user_verification` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1',
      `email_user_post_approval` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1',
      `email_admin_verifications` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1',
      `email_admin_post_approval` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1',
      `email_admin_user_approval` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `apple_connected` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `apple_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `google_connected` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `google_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `facebook_connected` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `facebook_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `twitter_connected` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `twitter_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `discord_connected` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `discord_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `linkedin_connected` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `linkedin_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `vkontakte_connected` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `vkontakte_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `wordpress_connected` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `wordpress_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `sngine_connected` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `sngine_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `user_referrer_id` int DEFAULT NULL,
      `custom_affiliates_system` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `affiliates_per_user` float UNSIGNED NOT NULL DEFAULT '0',
      `affiliates_percentage` float UNSIGNED NOT NULL DEFAULT '0',
      `affiliates_per_user_2` float UNSIGNED NOT NULL DEFAULT '0',
      `affiliates_percentage_2` float UNSIGNED NOT NULL DEFAULT '0',
      `affiliates_per_user_3` float UNSIGNED NOT NULL DEFAULT '0',
      `affiliates_percentage_3` float UNSIGNED NOT NULL DEFAULT '0',
      `affiliates_per_user_4` float UNSIGNED NOT NULL DEFAULT '0',
      `affiliates_percentage_4` float UNSIGNED NOT NULL DEFAULT '0',
      `affiliates_per_user_5` float UNSIGNED NOT NULL DEFAULT '0',
      `affiliates_percentage_5` float UNSIGNED NOT NULL DEFAULT '0',
      `affiliates_per_user_6` float UNSIGNED NOT NULL DEFAULT '0',
      `affiliates_percentage_6` float UNSIGNED NOT NULL DEFAULT '0',
      `affiliates_per_user_7` float UNSIGNED NOT NULL DEFAULT '0',
      `affiliates_percentage_7` float UNSIGNED NOT NULL DEFAULT '0',
      `affiliates_per_user_8` float UNSIGNED NOT NULL DEFAULT '0',
      `affiliates_percentage_8` float UNSIGNED NOT NULL DEFAULT '0',
      `affiliates_per_user_9` float UNSIGNED NOT NULL DEFAULT '0',
      `affiliates_percentage_9` float UNSIGNED NOT NULL DEFAULT '0',
      `affiliates_per_user_10` float UNSIGNED NOT NULL DEFAULT '0',
      `affiliates_percentage_10` float UNSIGNED NOT NULL DEFAULT '0',
      `points_earned` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `user_points` float NOT NULL DEFAULT '0',
      `user_wallet_balance` float NOT NULL DEFAULT '0',
      `user_affiliate_balance` float NOT NULL DEFAULT '0',
      `user_market_balance` float NOT NULL DEFAULT '0',
      `user_funding_balance` float NOT NULL DEFAULT '0',
      `user_monetization_enabled` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `user_monetization_discount_enabled` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `user_monetization_discount_percent` float NOT NULL DEFAULT '0',
      `user_monetization_chat_price` float NOT NULL DEFAULT '0',
      `user_monetization_call_price` float NOT NULL DEFAULT '0',
      `user_monetization_min_price` float NOT NULL DEFAULT '0',
      `user_monetization_plans` int UNSIGNED NOT NULL DEFAULT '0',
      `user_monetization_balance` float NOT NULL DEFAULT '0',
      `user_ai_credits_balance` int NOT NULL DEFAULT '0',
      `chat_sound` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1',
      `notifications_sound` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1',
      `user_language` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'en_us',
      `user_free_tried` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `coinbase_hash` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `coinbase_code` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `plisio_hash` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `plisio_txn_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `is_fake` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `users_accounts`
    --

    CREATE TABLE `users_accounts` (
      `id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `account_id` int UNSIGNED NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `users_addresses`
    --

    CREATE TABLE `users_addresses` (
      `address_id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `address_title` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `address_country` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `address_city` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `address_zip_code` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `address_phone` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `address_details` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `users_affiliates`
    --

    CREATE TABLE `users_affiliates` (
      `id` int UNSIGNED NOT NULL,
      `referrer_id` int UNSIGNED NOT NULL,
      `referee_id` int UNSIGNED NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `users_blocks`
    --

    CREATE TABLE `users_blocks` (
      `id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `blocked_id` int UNSIGNED NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `users_gifts`
    --

    CREATE TABLE `users_gifts` (
      `id` int UNSIGNED NOT NULL,
      `from_user_id` int UNSIGNED NOT NULL,
      `to_user_id` int UNSIGNED NOT NULL,
      `gift_id` int UNSIGNED NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `users_groups`
    --

    CREATE TABLE `users_groups` (
      `user_group_id` int UNSIGNED NOT NULL,
      `user_group_title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `permissions_group_id` int UNSIGNED NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `users_invitations`
    --

    CREATE TABLE `users_invitations` (
      `id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `email_phone` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `invitation_date` datetime NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `users_locations`
    --

    CREATE TABLE `users_locations` (
      `user_id` int UNSIGNED NOT NULL,
      `location` point NOT NULL /*!80003 SRID 0 */
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    -- --------------------------------------------------------

    --
    -- Table structure for table `users_login_countries`
    --

    CREATE TABLE `users_login_countries` (
      `user_id` int UNSIGNED NOT NULL,
      `country_code` varchar(2) COLLATE utf8mb4_general_ci NOT NULL,
      `time` datetime NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `users_merits`
    --

    CREATE TABLE `users_merits` (
      `id` int UNSIGNED NOT NULL,
      `from_user_id` int UNSIGNED NOT NULL,
      `to_user_id` int UNSIGNED NOT NULL,
      `category_id` int UNSIGNED NOT NULL,
      `message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
      `image` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `sent_date` datetime NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `users_packages_points`
    --

    CREATE TABLE `users_packages_points` (
      `id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `package_id` int UNSIGNED NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `users_pokes`
    --

    CREATE TABLE `users_pokes` (
      `id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `poked_id` int UNSIGNED NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `users_recurring_payments`
    --

    CREATE TABLE `users_recurring_payments` (
      `id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `payment_gateway` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `handle` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `handle_id` int UNSIGNED NOT NULL,
      `subscription_id` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `time` datetime NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `users_searches`
    --

    CREATE TABLE `users_searches` (
      `log_id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `node_id` int UNSIGNED NOT NULL,
      `node_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `time` datetime DEFAULT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `users_sessions`
    --

    CREATE TABLE `users_sessions` (
      `session_id` int UNSIGNED NOT NULL,
      `session_token` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `session_date` datetime NOT NULL,
      `session_type` enum('W','A','I') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'W',
      `user_id` int UNSIGNED NOT NULL,
      `user_ip` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `user_ip_country` varchar(2) COLLATE utf8mb4_general_ci DEFAULT NULL,
      `user_ip_isp` varchar(128) COLLATE utf8mb4_general_ci DEFAULT NULL,
      `user_browser` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `user_os` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `user_os_version` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `user_device_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `session_onesignal_user_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `users_shortcuts`
    --

    CREATE TABLE `users_shortcuts` (
      `id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `node_id` int UNSIGNED NOT NULL,
      `node_type` enum('page','group','event','game') COLLATE utf8mb4_general_ci NOT NULL,
      `state` enum('pinned','auto','hidden') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'auto',
      `time` datetime NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    -- --------------------------------------------------------

    --
    -- Table structure for table `users_sms`
    --

    CREATE TABLE `users_sms` (
      `id` int UNSIGNED NOT NULL,
      `phone` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `insert_date` datetime NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `users_top_friends`
    --

    CREATE TABLE `users_top_friends` (
      `id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `friend_id` int UNSIGNED NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `users_uploads`
    --

    CREATE TABLE `users_uploads` (
      `id` int UNSIGNED NOT NULL,
      `user_id` int NOT NULL,
      `file_name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `file_size` float NOT NULL,
      `insert_date` datetime NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    -- --------------------------------------------------------

    --
    -- Table structure for table `users_uploads_pending`
    --

    CREATE TABLE `users_uploads_pending` (
      `id` int UNSIGNED NOT NULL,
      `user_id` int NOT NULL,
      `file_name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `file_size` float NOT NULL,
      `handle` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `insert_date` datetime NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    -- --------------------------------------------------------

    --
    -- Table structure for table `verification_requests`
    --

    CREATE TABLE `verification_requests` (
      `request_id` int UNSIGNED NOT NULL,
      `node_id` int UNSIGNED NOT NULL,
      `node_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `photo` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `passport` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `business_website` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
      `business_address` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
      `message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
      `time` datetime NOT NULL,
      `status` tinyint(1) NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `wallet_payments`
    --

    CREATE TABLE `wallet_payments` (
      `payment_id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `amount` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `method` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `method_value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `time` datetime NOT NULL,
      `status` tinyint(1) NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `wallet_transactions`
    --

    CREATE TABLE `wallet_transactions` (
      `transaction_id` int UNSIGNED NOT NULL,
      `user_id` int UNSIGNED NOT NULL,
      `node_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `node_id` int UNSIGNED DEFAULT NULL,
      `amount` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `type` enum('in','out') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `date` datetime NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    -- --------------------------------------------------------

    --
    -- Table structure for table `widgets`
    --

    CREATE TABLE `widgets` (
      `widget_id` int UNSIGNED NOT NULL,
      `title` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `place` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `place_order` int UNSIGNED NOT NULL DEFAULT '1',
      `code` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `language_id` int NOT NULL DEFAULT '0',
      `target_audience` enum('all','members','visitors') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'all'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    --
    -- Indexes for dumped tables
    --

    --
    -- Indexes for table `ads_campaigns`
    --
    ALTER TABLE `ads_campaigns`
      ADD PRIMARY KEY (`campaign_id`),
      ADD KEY `campaign_user_id` (`campaign_user_id`),
      ADD KEY `active_approved_placement` (`campaign_is_active`,`campaign_is_approved`,`ads_placement`);

    --
    -- Indexes for table `ads_system`
    --
    ALTER TABLE `ads_system`
      ADD PRIMARY KEY (`ads_id`);

    --
    -- Indexes for table `affiliates_payments`
    --
    ALTER TABLE `affiliates_payments`
      ADD PRIMARY KEY (`payment_id`),
      ADD KEY `user_id` (`user_id`);

    --
    -- Indexes for table `announcements`
    --
    ALTER TABLE `announcements`
      ADD PRIMARY KEY (`announcement_id`);

    --
    -- Indexes for table `announcements_users`
    --
    ALTER TABLE `announcements_users`
      ADD PRIMARY KEY (`id`),
      ADD UNIQUE KEY `announcement_id_user_id` (`announcement_id`,`user_id`);

    --
    -- Indexes for table `auto_connect`
    --
    ALTER TABLE `auto_connect`
      ADD PRIMARY KEY (`id`),
      ADD KEY `country_id` (`country_id`);

    --
    -- Indexes for table `bank_transfers`
    --
    ALTER TABLE `bank_transfers`
      ADD PRIMARY KEY (`transfer_id`),
      ADD KEY `user_id` (`user_id`),
      ADD KEY `package_id` (`package_id`),
      ADD KEY `post_id` (`post_id`);

    --
    -- Indexes for table `blacklist`
    --
    ALTER TABLE `blacklist`
      ADD PRIMARY KEY (`node_id`),
      ADD KEY `node_value` (`node_value`);

    --
    -- Indexes for table `blogs_categories`
    --
    ALTER TABLE `blogs_categories`
      ADD PRIMARY KEY (`category_id`),
      ADD KEY `category_parent_id` (`category_parent_id`);

    --
    -- Indexes for table `ccbill_payments`
    --
    ALTER TABLE `ccbill_payments`
      ADD PRIMARY KEY (`payment_id`);

    --
    -- Indexes for table `coinpayments_transactions`
    --
    ALTER TABLE `coinpayments_transactions`
      ADD PRIMARY KEY (`transaction_id`),
      ADD KEY `user_id` (`user_id`);

    --
    -- Indexes for table `conversations`
    --
    ALTER TABLE `conversations`
      ADD PRIMARY KEY (`conversation_id`),
      ADD KEY `last_message_id` (`last_message_id`);

    --
    -- Indexes for table `conversations_calls`
    --
    ALTER TABLE `conversations_calls`
      ADD PRIMARY KEY (`call_id`),
      ADD KEY `from_user_id` (`from_user_id`),
      ADD KEY `to_user_id` (`to_user_id`);

    --
    -- Indexes for table `conversations_messages`
    --
    ALTER TABLE `conversations_messages`
      ADD PRIMARY KEY (`message_id`),
      ADD KEY `conversation_id` (`conversation_id`),
      ADD KEY `user_id` (`user_id`),
      ADD KEY `page_id` (`page_id`),
      ADD KEY `call_id` (`call_id`);

    --
    -- Indexes for table `conversations_messages_media`
    --
    ALTER TABLE `conversations_messages_media`
      ADD PRIMARY KEY (`media_id`),
      ADD KEY `message_id` (`message_id`);

    --
    -- Indexes for table `conversations_messages_paid`
    --
    ALTER TABLE `conversations_messages_paid`
      ADD PRIMARY KEY (`id`),
      ADD KEY `message_id` (`message_id`),
      ADD KEY `user_id` (`user_id`);

    --
    -- Indexes for table `conversations_messages_reactions`
    --
    ALTER TABLE `conversations_messages_reactions`
      ADD PRIMARY KEY (`id`),
      ADD UNIQUE KEY `post_id_user_id` (`message_id`,`user_id`);

    --
    -- Indexes for table `conversations_users`
    --
    ALTER TABLE `conversations_users`
      ADD PRIMARY KEY (`id`),
      ADD UNIQUE KEY `conversation_id_user_id` (`conversation_id`,`user_id`),
      ADD KEY `user_id_conversation_id` (`user_id`,`conversation_id`);

    --
    -- Indexes for table `courses_categories`
    --
    ALTER TABLE `courses_categories`
      ADD PRIMARY KEY (`category_id`) USING BTREE,
      ADD KEY `category_parent_id` (`category_parent_id`);

    --
    -- Indexes for table `custom_fields`
    --
    ALTER TABLE `custom_fields`
      ADD PRIMARY KEY (`field_id`);

    --
    -- Indexes for table `custom_fields_values`
    --
    ALTER TABLE `custom_fields_values`
      ADD PRIMARY KEY (`value_id`),
      ADD UNIQUE KEY `field_id_node_id_node_type` (`field_id`,`node_id`,`node_type`),
      ADD KEY `value` (`value`(20));

    --
    -- Indexes for table `dating_interests`
    --
    ALTER TABLE `dating_interests`
      ADD PRIMARY KEY (`interest_id`);

    --
    -- Indexes for table `dating_locations`
    --
    ALTER TABLE `dating_locations`
      ADD PRIMARY KEY (`user_id`),
      ADD SPATIAL KEY `location` (`location`);

    --
    -- Indexes for table `dating_matches`
    --
    ALTER TABLE `dating_matches`
      ADD PRIMARY KEY (`match_id`),
      ADD UNIQUE KEY `user_one_id_user_two_id` (`user_one_id`,`user_two_id`),
      ADD KEY `user_one_id_status` (`user_one_id`,`status`,`match_id`),
      ADD KEY `user_two_id_status` (`user_two_id`,`status`,`match_id`);

    --
    -- Indexes for table `dating_photos`
    --
    ALTER TABLE `dating_photos`
      ADD PRIMARY KEY (`photo_id`),
      ADD KEY `user_id_status_photo_order` (`user_id`,`status`,`photo_order`),
      ADD KEY `status_photo_id` (`status`,`photo_id`);

    --
    -- Indexes for table `dating_profiles`
    --
    ALTER TABLE `dating_profiles`
      ADD PRIMARY KEY (`user_id`),
      ADD KEY `status_gender_user_id` (`status`,`gender`,`user_id`),
      ADD KEY `status_gender_country_id` (`status`,`gender`,`country_id`,`user_id`),
      ADD KEY `status_gender_city_key` (`status`,`gender`,`city_key`,`user_id`),
      ADD KEY `status_boosted_until` (`status`,`boosted_until`),
      ADD KEY `status_time` (`status`,`time`);

    --
    -- Indexes for table `dating_profiles_interests`
    --
    ALTER TABLE `dating_profiles_interests`
      ADD PRIMARY KEY (`user_id`,`interest_id`),
      ADD KEY `interest_id_user_id` (`interest_id`,`user_id`);

    --
    -- Indexes for table `dating_purchases`
    --
    ALTER TABLE `dating_purchases`
      ADD PRIMARY KEY (`purchase_id`),
      ADD KEY `user_id` (`user_id`,`purchase_id`),
      ADD KEY `time` (`time`);

    --
    -- Indexes for table `dating_swipes`
    --
    ALTER TABLE `dating_swipes`
      ADD PRIMARY KEY (`swipe_id`),
      ADD UNIQUE KEY `user_id_target_id` (`user_id`,`target_id`),
      ADD KEY `user_id_time` (`user_id`,`time`),
      ADD KEY `target_id_pending_swipe_id` (`target_id`,`pending`,`swipe_id`);

    --
    -- Indexes for table `developers_apps`
    --
    ALTER TABLE `developers_apps`
      ADD PRIMARY KEY (`app_id`),
      ADD UNIQUE KEY `app_auth_id` (`app_auth_id`),
      ADD UNIQUE KEY `app_auth_secret` (`app_auth_secret`),
      ADD KEY `app_user_id` (`app_user_id`),
      ADD KEY `app_category_id` (`app_category_id`);

    --
    -- Indexes for table `developers_apps_categories`
    --
    ALTER TABLE `developers_apps_categories`
      ADD PRIMARY KEY (`category_id`),
      ADD KEY `category_parent_id` (`category_parent_id`);

    --
    -- Indexes for table `developers_apps_users`
    --
    ALTER TABLE `developers_apps_users`
      ADD PRIMARY KEY (`id`),
      ADD UNIQUE KEY `app_id_user_id` (`app_id`,`user_id`) USING BTREE;

    --
    -- Indexes for table `events`
    --
    ALTER TABLE `events`
      ADD PRIMARY KEY (`event_id`),
      ADD KEY `event_admin` (`event_admin`),
      ADD KEY `event_category` (`event_category`),
      ADD KEY `event_cover_id` (`event_cover_id`),
      ADD KEY `event_album_covers` (`event_album_covers`),
      ADD KEY `event_album_timeline` (`event_album_timeline`),
      ADD KEY `event_date` (`event_date`) USING BTREE,
      ADD KEY `event_title_idx` (`event_title`) USING BTREE,
      ADD KEY `event_boosted` (`event_boosted`),
      ADD KEY `event_end_date` (`event_end_date`),
      ADD KEY `event_page_id` (`event_page_id`);

    --
    -- Indexes for table `events_categories`
    --
    ALTER TABLE `events_categories`
      ADD PRIMARY KEY (`category_id`),
      ADD KEY `category_parent_id` (`category_parent_id`);

    --
    -- Indexes for table `events_members`
    --
    ALTER TABLE `events_members`
      ADD PRIMARY KEY (`id`),
      ADD UNIQUE KEY `event_id_user_id` (`event_id`,`user_id`) USING BTREE,
      ADD KEY `user_id_event_id` (`user_id`,`event_id`);

    --
    -- Indexes for table `followings`
    --
    ALTER TABLE `followings`
      ADD PRIMARY KEY (`id`),
      ADD UNIQUE KEY `user_id_following_id` (`user_id`,`following_id`),
      ADD KEY `user_id` (`user_id`) USING BTREE,
      ADD KEY `following_id` (`following_id`) USING BTREE;

    --
    -- Indexes for table `forums`
    --
    ALTER TABLE `forums`
      ADD PRIMARY KEY (`forum_id`),
      ADD KEY `forum_section` (`forum_section`);

    --
    -- Indexes for table `forums_likes`
    --
    ALTER TABLE `forums_likes`
      ADD PRIMARY KEY (`id`),
      ADD UNIQUE KEY `user_id_node_id_node_type` (`user_id`,`node_id`,`node_type`),
      ADD KEY `node_id_node_type` (`node_id`,`node_type`);

    --
    -- Indexes for table `forums_replies`
    --
    ALTER TABLE `forums_replies`
      ADD PRIMARY KEY (`reply_id`),
      ADD KEY `thread_id` (`thread_id`),
      ADD KEY `user_id` (`user_id`);

    --
    -- Indexes for table `forums_threads`
    --
    ALTER TABLE `forums_threads`
      ADD PRIMARY KEY (`thread_id`),
      ADD KEY `forum_id` (`forum_id`),
      ADD KEY `user_id` (`user_id`),
      ADD KEY `latest` (`is_pinned`,`last_reply`),
      ADD KEY `forum_latest` (`forum_id`,`is_pinned`,`last_reply`),
      ADD KEY `replies` (`replies`),
      ADD KEY `forum_replies` (`forum_id`,`replies`),
      ADD KEY `forum_last_reply` (`forum_id`,`last_reply`);

    --
    -- Indexes for table `friends`
    --
    ALTER TABLE `friends`
      ADD PRIMARY KEY (`id`),
      ADD UNIQUE KEY `user_one_id_user_two_id` (`user_one_id`,`user_two_id`),
      ADD KEY `user_one_id` (`user_one_id`) USING BTREE,
      ADD KEY `user_two_id` (`user_two_id`) USING BTREE,
      ADD KEY `status` (`status`) USING BTREE;

    --
    -- Indexes for table `funding_categories`
    --
    ALTER TABLE `funding_categories`
      ADD PRIMARY KEY (`category_id`) USING BTREE,
      ADD KEY `category_parent_id` (`category_parent_id`);

    --
    -- Indexes for table `funding_payments`
    --
    ALTER TABLE `funding_payments`
      ADD PRIMARY KEY (`payment_id`) USING BTREE,
      ADD KEY `user_id` (`user_id`);

    --
    -- Indexes for table `games`
    --
    ALTER TABLE `games`
      ADD PRIMARY KEY (`game_id`);

    --
    -- Indexes for table `games_genres`
    --
    ALTER TABLE `games_genres`
      ADD PRIMARY KEY (`genre_id`);

    --
    -- Indexes for table `games_players`
    --
    ALTER TABLE `games_players`
      ADD PRIMARY KEY (`id`),
      ADD UNIQUE KEY `game_id_user_id` (`game_id`,`user_id`);

    --
    -- Indexes for table `gifts`
    --
    ALTER TABLE `gifts`
      ADD PRIMARY KEY (`gift_id`);

    --
    -- Indexes for table `groups`
    --
    ALTER TABLE `groups`
      ADD PRIMARY KEY (`group_id`),
      ADD UNIQUE KEY `group_name` (`group_name`) USING BTREE,
      ADD KEY `group_admin` (`group_admin`),
      ADD KEY `group_category` (`group_category`),
      ADD KEY `group_picture_id` (`group_picture_id`),
      ADD KEY `group_cover_id` (`group_cover_id`),
      ADD KEY `group_album_pictures` (`group_album_pictures`),
      ADD KEY `group_album_covers` (`group_album_covers`),
      ADD KEY `group_album_timeline` (`group_album_timeline`),
      ADD KEY `group_date` (`group_date`) USING BTREE,
      ADD KEY `group_title_idx` (`group_title`) USING BTREE,
      ADD KEY `group_name_idx` (`group_name`) USING BTREE,
      ADD KEY `group_boosted` (`group_boosted`);

    --
    -- Indexes for table `groups_admins`
    --
    ALTER TABLE `groups_admins`
      ADD PRIMARY KEY (`id`),
      ADD UNIQUE KEY `group_id_user_id` (`group_id`,`user_id`),
      ADD KEY `user_id` (`user_id`);

    --
    -- Indexes for table `groups_categories`
    --
    ALTER TABLE `groups_categories`
      ADD PRIMARY KEY (`category_id`),
      ADD KEY `category_parent_id` (`category_parent_id`);

    --
    -- Indexes for table `groups_invites`
    --
    ALTER TABLE `groups_invites`
      ADD PRIMARY KEY (`id`),
      ADD UNIQUE KEY `page_id_user_id_from_user_id` (`group_id`,`user_id`,`from_user_id`);

    --
    -- Indexes for table `groups_members`
    --
    ALTER TABLE `groups_members`
      ADD PRIMARY KEY (`id`),
      ADD UNIQUE KEY `group_id_user_id` (`group_id`,`user_id`),
      ADD KEY `user_id_group_id` (`user_id`,`group_id`);

    --
    -- Indexes for table `hashtags`
    --
    ALTER TABLE `hashtags`
      ADD PRIMARY KEY (`hashtag_id`),
      ADD KEY `hashtag` (`hashtag`);

    --
    -- Indexes for table `hashtags_posts`
    --
    ALTER TABLE `hashtags_posts`
      ADD PRIMARY KEY (`id`),
      ADD UNIQUE KEY `post_id_hashtag_id` (`post_id`,`hashtag_id`),
      ADD KEY `post_id` (`post_id`) USING BTREE,
      ADD KEY `hashtag_id` (`hashtag_id`) USING BTREE;

    --
    -- Indexes for table `invitation_codes`
    --
    ALTER TABLE `invitation_codes`
      ADD PRIMARY KEY (`code_id`),
      ADD KEY `created_by` (`created_by`),
      ADD KEY `used_by` (`used_by`),
      ADD KEY `code` (`code`) USING BTREE;

    --
    -- Indexes for table `iyzico_payments`
    --
    ALTER TABLE `iyzico_payments`
      ADD PRIMARY KEY (`payment_id`),
      ADD UNIQUE KEY `iyzico_conversation_id` (`iyzico_conversation_id`),
      ADD KEY `iyzico_token` (`iyzico_token`(191)),
      ADD KEY `user_id` (`user_id`);

    --
    -- Indexes for table `jobs_categories`
    --
    ALTER TABLE `jobs_categories`
      ADD PRIMARY KEY (`category_id`) USING BTREE,
      ADD KEY `category_parent_id` (`category_parent_id`);

    --
    -- Indexes for table `live_ingresses`
    --
    ALTER TABLE `live_ingresses`
      ADD PRIMARY KEY (`user_id`);

    --
    -- Indexes for table `live_moderation_log`
    --
    ALTER TABLE `live_moderation_log`
      ADD PRIMARY KEY (`log_id`),
      ADD KEY `host` (`host_type`,`host_id`,`log_id`);

    --
    -- Indexes for table `live_moderation_settings`
    --
    ALTER TABLE `live_moderation_settings`
      ADD PRIMARY KEY (`host_type`,`host_id`);

    --
    -- Indexes for table `live_moderators`
    --
    ALTER TABLE `live_moderators`
      ADD PRIMARY KEY (`host_type`,`host_id`,`user_id`);

    --
    -- Indexes for table `live_restrictions`
    --
    ALTER TABLE `live_restrictions`
      ADD PRIMARY KEY (`host_type`,`host_id`,`user_id`);

    --
    -- Indexes for table `log_commissions`
    --
    ALTER TABLE `log_commissions`
      ADD PRIMARY KEY (`payment_id`) USING BTREE,
      ADD KEY `user_id` (`user_id`);

    --
    -- Indexes for table `log_payments`
    --
    ALTER TABLE `log_payments`
      ADD PRIMARY KEY (`payment_id`) USING BTREE,
      ADD KEY `user_id` (`user_id`);

    --
    -- Indexes for table `log_points`
    --
    ALTER TABLE `log_points`
      ADD PRIMARY KEY (`log_id`) USING BTREE,
      ADD KEY `user_id` (`user_id`);

    --
    -- Indexes for table `log_subscriptions`
    --
    ALTER TABLE `log_subscriptions`
      ADD PRIMARY KEY (`payment_id`) USING BTREE,
      ADD KEY `user_id` (`node_id`);

    --
    -- Indexes for table `market_categories`
    --
    ALTER TABLE `market_categories`
      ADD PRIMARY KEY (`category_id`),
      ADD KEY `category_parent_id` (`category_parent_id`);

    --
    -- Indexes for table `market_payments`
    --
    ALTER TABLE `market_payments`
      ADD PRIMARY KEY (`payment_id`) USING BTREE,
      ADD KEY `user_id` (`user_id`);

    --
    -- Indexes for table `merits_categories`
    --
    ALTER TABLE `merits_categories`
      ADD PRIMARY KEY (`category_id`),
      ADD KEY `category_parent_id` (`category_parent_id`);

    --
    -- Indexes for table `monetization_coupons`
    --
    ALTER TABLE `monetization_coupons`
      ADD PRIMARY KEY (`coupon_id`),
      ADD KEY `coupon_code` (`coupon_code`) USING BTREE;

    --
    -- Indexes for table `monetization_coupons_users`
    --
    ALTER TABLE `monetization_coupons_users`
      ADD PRIMARY KEY (`id`),
      ADD UNIQUE KEY `user_id_coupon_id` (`user_id`,`coupon_id`) USING BTREE,
      ADD KEY `coupon_id` (`coupon_id`);

    --
    -- Indexes for table `monetization_payments`
    --
    ALTER TABLE `monetization_payments`
      ADD PRIMARY KEY (`payment_id`) USING BTREE,
      ADD KEY `user_id` (`user_id`);

    --
    -- Indexes for table `monetization_plans`
    --
    ALTER TABLE `monetization_plans`
      ADD PRIMARY KEY (`plan_id`);

    --
    -- Indexes for table `movies`
    --
    ALTER TABLE `movies`
      ADD PRIMARY KEY (`movie_id`);

    --
    -- Indexes for table `movies_genres`
    --
    ALTER TABLE `movies_genres`
      ADD PRIMARY KEY (`genre_id`);

    --
    -- Indexes for table `movies_payments`
    --
    ALTER TABLE `movies_payments`
      ADD PRIMARY KEY (`id`),
      ADD UNIQUE KEY `move_id_user_id` (`movie_id`,`user_id`) USING BTREE;

    --
    -- Indexes for table `notifications`
    --
    ALTER TABLE `notifications`
      ADD PRIMARY KEY (`notification_id`),
      ADD KEY `to_user_id` (`to_user_id`),
      ADD KEY `from_user_id` (`from_user_id`,`from_user_type`);

    --
    -- Indexes for table `offers_categories`
    --
    ALTER TABLE `offers_categories`
      ADD PRIMARY KEY (`category_id`) USING BTREE,
      ADD KEY `category_parent_id` (`category_parent_id`);

    --
    -- Indexes for table `orders`
    --
    ALTER TABLE `orders`
      ADD PRIMARY KEY (`order_id`),
      ADD KEY `seller_id` (`seller_id`) USING BTREE,
      ADD KEY `buyer_id` (`buyer_id`) USING BTREE,
      ADD KEY `buyer_address_id` (`buyer_address_id`) USING BTREE,
      ADD KEY `order_collection_id` (`order_collection_id`) USING BTREE,
      ADD KEY `order_hash` (`order_hash`) USING BTREE;

    --
    -- Indexes for table `orders_items`
    --
    ALTER TABLE `orders_items`
      ADD PRIMARY KEY (`id`),
      ADD KEY `product_post_id` (`product_post_id`) USING BTREE,
      ADD KEY `order_id` (`order_id`) USING BTREE;

    --
    -- Indexes for table `packages`
    --
    ALTER TABLE `packages`
      ADD PRIMARY KEY (`package_id`),
      ADD KEY `package_permissions_group_id` (`package_permissions_group_id`) USING BTREE;

    --
    -- Indexes for table `packages_payments`
    --
    ALTER TABLE `packages_payments`
      ADD PRIMARY KEY (`payment_id`),
      ADD KEY `user_id` (`user_id`);

    --
    -- Indexes for table `pages`
    --
    ALTER TABLE `pages`
      ADD PRIMARY KEY (`page_id`),
      ADD UNIQUE KEY `page_name` (`page_name`) USING BTREE,
      ADD KEY `page_admin` (`page_admin`),
      ADD KEY `page_category` (`page_category`),
      ADD KEY `page_cover_id` (`page_cover_id`),
      ADD KEY `page_picture_id` (`page_picture_id`),
      ADD KEY `page_country` (`page_country`),
      ADD KEY `page_album_pictures` (`page_album_pictures`),
      ADD KEY `page_album_covers` (`page_album_covers`),
      ADD KEY `page_album_timeline` (`page_album_timeline`),
      ADD KEY `page_boosted` (`page_boosted`) USING BTREE,
      ADD KEY `page_date` (`page_date`) USING BTREE,
      ADD KEY `page_name_idx` (`page_name`) USING BTREE,
      ADD KEY `page_title_idx` (`page_title`) USING BTREE;

    --
    -- Indexes for table `pages_admins`
    --
    ALTER TABLE `pages_admins`
      ADD PRIMARY KEY (`id`),
      ADD UNIQUE KEY `page_id_user_id` (`page_id`,`user_id`),
      ADD KEY `user_id` (`user_id`);

    --
    -- Indexes for table `pages_categories`
    --
    ALTER TABLE `pages_categories`
      ADD PRIMARY KEY (`category_id`),
      ADD KEY `category_parent_id` (`category_parent_id`);

    --
    -- Indexes for table `pages_conversations`
    --
    ALTER TABLE `pages_conversations`
      ADD PRIMARY KEY (`id`),
      ADD UNIQUE KEY `page_user` (`page_id`,`user_id`),
      ADD UNIQUE KEY `conversation_id` (`conversation_id`);

    --
    -- Indexes for table `pages_invites`
    --
    ALTER TABLE `pages_invites`
      ADD PRIMARY KEY (`id`),
      ADD UNIQUE KEY `page_id_user_id_from_user_id` (`page_id`,`user_id`,`from_user_id`);

    --
    -- Indexes for table `pages_likes`
    --
    ALTER TABLE `pages_likes`
      ADD PRIMARY KEY (`id`),
      ADD UNIQUE KEY `page_id_user_id` (`page_id`,`user_id`),
      ADD KEY `user_id_page_id` (`user_id`,`page_id`);

    --
    -- Indexes for table `permissions_groups`
    --
    ALTER TABLE `permissions_groups`
      ADD PRIMARY KEY (`permissions_group_id`);

    --
    -- Indexes for table `plisio_payments`
    --
    ALTER TABLE `plisio_payments`
      ADD PRIMARY KEY (`payment_id`),
      ADD UNIQUE KEY `plisio_txn_id` (`plisio_txn_id`),
      ADD KEY `plisio_hash` (`plisio_hash`),
      ADD KEY `user_id` (`user_id`);

    --
    -- Indexes for table `points_payments`
    --
    ALTER TABLE `points_payments`
      ADD PRIMARY KEY (`payment_id`),
      ADD KEY `user_id` (`user_id`);

    --
    -- Indexes for table `posts`
    --
    ALTER TABLE `posts`
      ADD PRIMARY KEY (`post_id`),
      ADD KEY `group_id` (`group_id`),
      ADD KEY `event_id` (`event_id`),
      ADD KEY `wall_id` (`wall_id`),
      ADD KEY `colored_pattern` (`colored_pattern`),
      ADD KEY `origin_id` (`origin_id`),
      ADD KEY `boosted_by` (`boosted_by`),
      ADD KEY `user_id` (`user_id`,`user_type`),
      ADD KEY `boosted` (`boosted`) USING BTREE,
      ADD KEY `time` (`time`) USING BTREE,
      ADD KEY `boosted_post_type` (`boosted`,`post_type`),
      ADD KEY `user_id_user_type_time` (`user_id`,`user_type`,`time`),
      ADD KEY `origin_id_user_id` (`origin_id`,`user_id`);

    --
    -- Indexes for table `posts_articles`
    --
    ALTER TABLE `posts_articles`
      ADD PRIMARY KEY (`article_id`),
      ADD KEY `post_id` (`post_id`),
      ADD KEY `category_id` (`category_id`),
      ADD KEY `title_idx` (`title`) USING BTREE;
    ALTER TABLE `posts_articles` ADD FULLTEXT KEY `ft_title` (`title`);
    ALTER TABLE `posts_articles` ADD FULLTEXT KEY `ft_tags` (`tags`);

    --
    -- Indexes for table `posts_articles_references`
    --
    ALTER TABLE `posts_articles_references`
      ADD PRIMARY KEY (`refrence_id`),
      ADD KEY `post_id` (`post_id`),
      ADD KEY `title_idx` (`title`) USING BTREE;
    ALTER TABLE `posts_articles_references` ADD FULLTEXT KEY `ft_title` (`title`);

    --
    -- Indexes for table `posts_audios`
    --
    ALTER TABLE `posts_audios`
      ADD PRIMARY KEY (`audio_id`),
      ADD KEY `post_id` (`post_id`);

    --
    -- Indexes for table `posts_cache`
    --
    ALTER TABLE `posts_cache`
      ADD PRIMARY KEY (`cache_id`),
      ADD KEY `user_id` (`user_id`),
      ADD KEY `post_id` (`post_id`) USING BTREE;

    --
    -- Indexes for table `posts_collaborative_users`
    --
    ALTER TABLE `posts_collaborative_users`
      ADD PRIMARY KEY (`id`),
      ADD UNIQUE KEY `post_id_user_id` (`post_id`,`user_id`) USING BTREE,
      ADD KEY `user_post` (`user_id`,`post_id`);

    --
    -- Indexes for table `posts_colored_patterns`
    --
    ALTER TABLE `posts_colored_patterns`
      ADD PRIMARY KEY (`pattern_id`);

    --
    -- Indexes for table `posts_comments`
    --
    ALTER TABLE `posts_comments`
      ADD PRIMARY KEY (`comment_id`),
      ADD KEY `node_id` (`node_id`,`node_type`),
      ADD KEY `user_id` (`user_id`,`user_type`);

    --
    -- Indexes for table `posts_comments_reactions`
    --
    ALTER TABLE `posts_comments_reactions`
      ADD PRIMARY KEY (`id`),
      ADD UNIQUE KEY `comment_id_user_id` (`comment_id`,`user_id`);

    --
    -- Indexes for table `posts_courses`
    --
    ALTER TABLE `posts_courses`
      ADD PRIMARY KEY (`course_id`) USING BTREE,
      ADD KEY `post_id` (`post_id`),
      ADD KEY `category_id` (`category_id`);

    --
    -- Indexes for table `posts_courses_applications`
    --
    ALTER TABLE `posts_courses_applications`
      ADD PRIMARY KEY (`application_id`) USING BTREE,
      ADD KEY `post_id` (`post_id`),
      ADD KEY `user_id` (`user_id`);

    --
    -- Indexes for table `posts_files`
    --
    ALTER TABLE `posts_files`
      ADD PRIMARY KEY (`file_id`),
      ADD KEY `post_id` (`post_id`);

    --
    -- Indexes for table `posts_funding`
    --
    ALTER TABLE `posts_funding`
      ADD PRIMARY KEY (`funding_id`) USING BTREE,
      ADD KEY `post_id` (`post_id`);

    --
    -- Indexes for table `posts_funding_donors`
    --
    ALTER TABLE `posts_funding_donors`
      ADD PRIMARY KEY (`donation_id`) USING BTREE,
      ADD KEY `user_id` (`user_id`),
      ADD KEY `post_id` (`post_id`);

    --
    -- Indexes for table `posts_hidden`
    --
    ALTER TABLE `posts_hidden`
      ADD PRIMARY KEY (`id`),
      ADD UNIQUE KEY `post_id_user_id` (`post_id`,`user_id`);

    --
    -- Indexes for table `posts_jobs`
    --
    ALTER TABLE `posts_jobs`
      ADD PRIMARY KEY (`job_id`) USING BTREE,
      ADD KEY `post_id` (`post_id`),
      ADD KEY `category_id` (`category_id`);

    --
    -- Indexes for table `posts_jobs_applications`
    --
    ALTER TABLE `posts_jobs_applications`
      ADD PRIMARY KEY (`application_id`) USING BTREE,
      ADD KEY `post_id` (`post_id`),
      ADD KEY `user_id` (`user_id`);

    --
    -- Indexes for table `posts_links`
    --
    ALTER TABLE `posts_links`
      ADD PRIMARY KEY (`link_id`),
      ADD KEY `post_id` (`post_id`);

    --
    -- Indexes for table `posts_live`
    --
    ALTER TABLE `posts_live`
      ADD PRIMARY KEY (`live_id`) USING BTREE,
      ADD KEY `post_id` (`post_id`),
      ADD KEY `category_id` (`category_id`),
      ADD KEY `live_ended` (`live_ended`);

    --
    -- Indexes for table `posts_live_categories`
    --
    ALTER TABLE `posts_live_categories`
      ADD PRIMARY KEY (`category_id`),
      ADD KEY `category_parent_id` (`category_parent_id`);

    --
    -- Indexes for table `posts_live_users`
    --
    ALTER TABLE `posts_live_users`
      ADD PRIMARY KEY (`id`) USING BTREE,
      ADD UNIQUE KEY `user_id_post_id` (`user_id`,`post_id`);

    --
    -- Indexes for table `posts_locations`
    --
    ALTER TABLE `posts_locations`
      ADD PRIMARY KEY (`post_id`),
      ADD SPATIAL KEY `location` (`location`);

    --
    -- Indexes for table `posts_media`
    --
    ALTER TABLE `posts_media`
      ADD PRIMARY KEY (`media_id`),
      ADD KEY `post_id` (`post_id`);

    --
    -- Indexes for table `posts_merits`
    --
    ALTER TABLE `posts_merits`
      ADD PRIMARY KEY (`merit_id`),
      ADD KEY `post_id` (`post_id`),
      ADD KEY `category_id` (`category_id`);

    --
    -- Indexes for table `posts_offers`
    --
    ALTER TABLE `posts_offers`
      ADD PRIMARY KEY (`offer_id`) USING BTREE,
      ADD KEY `post_id` (`post_id`),
      ADD KEY `category_id` (`category_id`);

    --
    -- Indexes for table `posts_paid`
    --
    ALTER TABLE `posts_paid`
      ADD PRIMARY KEY (`id`),
      ADD UNIQUE KEY `post_id_user_id` (`post_id`,`user_id`);

    --
    -- Indexes for table `posts_photos`
    --
    ALTER TABLE `posts_photos`
      ADD PRIMARY KEY (`photo_id`),
      ADD KEY `post_id` (`post_id`),
      ADD KEY `album_id` (`album_id`),
      ADD KEY `post_photo_order` (`post_id`,`sort_order`,`photo_id`);

    --
    -- Indexes for table `posts_photos_albums`
    --
    ALTER TABLE `posts_photos_albums`
      ADD PRIMARY KEY (`album_id`),
      ADD KEY `user_id` (`user_id`,`user_type`),
      ADD KEY `group_id` (`group_id`),
      ADD KEY `event_id` (`event_id`);

    --
    -- Indexes for table `posts_photos_reactions`
    --
    ALTER TABLE `posts_photos_reactions`
      ADD PRIMARY KEY (`id`),
      ADD UNIQUE KEY `user_id_photo_id` (`user_id`,`photo_id`),
      ADD KEY `photo_id_user_id` (`photo_id`,`user_id`);

    --
    -- Indexes for table `posts_polls`
    --
    ALTER TABLE `posts_polls`
      ADD PRIMARY KEY (`poll_id`),
      ADD KEY `post_id` (`post_id`);

    --
    -- Indexes for table `posts_polls_options`
    --
    ALTER TABLE `posts_polls_options`
      ADD PRIMARY KEY (`option_id`),
      ADD KEY `poll_id` (`poll_id`);

    --
    -- Indexes for table `posts_polls_options_users`
    --
    ALTER TABLE `posts_polls_options_users`
      ADD PRIMARY KEY (`id`),
      ADD UNIQUE KEY `user_id_poll_id` (`user_id`,`poll_id`),
      ADD KEY `option_id_user_id` (`option_id`,`user_id`);

    --
    -- Indexes for table `posts_products`
    --
    ALTER TABLE `posts_products`
      ADD PRIMARY KEY (`product_id`),
      ADD KEY `post_id` (`post_id`),
      ADD KEY `category_id` (`category_id`);

    --
    -- Indexes for table `posts_reactions`
    --
    ALTER TABLE `posts_reactions`
      ADD PRIMARY KEY (`id`),
      ADD UNIQUE KEY `post_id_user_id` (`post_id`,`user_id`);

    --
    -- Indexes for table `posts_reels`
    --
    ALTER TABLE `posts_reels`
      ADD PRIMARY KEY (`reel_id`),
      ADD KEY `post_id` (`post_id`);

    --
    -- Indexes for table `posts_rich_text`
    --
    ALTER TABLE `posts_rich_text`
      ADD PRIMARY KEY (`rich_text_id`),
      ADD KEY `post_id` (`post_id`);

    --
    -- Indexes for table `posts_saved`
    --
    ALTER TABLE `posts_saved`
      ADD PRIMARY KEY (`id`),
      ADD UNIQUE KEY `post_id_user_id` (`post_id`,`user_id`),
      ADD KEY `user_id_time` (`user_id`,`time`);

    --
    -- Indexes for table `posts_search`
    --
    ALTER TABLE `posts_search`
      ADD PRIMARY KEY (`post_id`);
    ALTER TABLE `posts_search` ADD FULLTEXT KEY `ft_text` (`search_text`);
    ALTER TABLE `posts_search` ADD FULLTEXT KEY `ft_all` (`search_text`,`search_body`);

    --
    -- Indexes for table `posts_videos`
    --
    ALTER TABLE `posts_videos`
      ADD PRIMARY KEY (`video_id`),
      ADD KEY `post_id` (`post_id`),
      ADD KEY `category_id` (`category_id`) USING BTREE;

    --
    -- Indexes for table `posts_videos_categories`
    --
    ALTER TABLE `posts_videos_categories`
      ADD PRIMARY KEY (`category_id`),
      ADD KEY `category_parent_id` (`category_parent_id`);

    --
    -- Indexes for table `posts_views`
    --
    ALTER TABLE `posts_views`
      ADD PRIMARY KEY (`view_id`),
      ADD UNIQUE KEY `post_user` (`post_id`,`user_id`),
      ADD UNIQUE KEY `post_guest` (`post_id`,`guest_ip`),
      ADD KEY `user_id` (`user_id`),
      ADD KEY `post_id` (`post_id`) USING BTREE,
      ADD KEY `guest_ip` (`guest_ip`) USING BTREE,
      ADD KEY `view_date_id` (`view_date`,`view_id`);

    --
    -- Indexes for table `reports`
    --
    ALTER TABLE `reports`
      ADD PRIMARY KEY (`report_id`),
      ADD KEY `user_id` (`user_id`),
      ADD KEY `category_id` (`category_id`),
      ADD KEY `node_id` (`node_id`);

    --
    -- Indexes for table `reports_categories`
    --
    ALTER TABLE `reports_categories`
      ADD PRIMARY KEY (`category_id`),
      ADD KEY `category_parent_id` (`category_parent_id`);

    --
    -- Indexes for table `reviews`
    --
    ALTER TABLE `reviews`
      ADD PRIMARY KEY (`review_id`),
      ADD KEY `user_id` (`user_id`),
      ADD KEY `page_id` (`node_id`) USING BTREE;

    --
    -- Indexes for table `reviews_photos`
    --
    ALTER TABLE `reviews_photos`
      ADD PRIMARY KEY (`photo_id`),
      ADD KEY `review_id` (`review_id`) USING BTREE;

    --
    -- Indexes for table `shopping_cart`
    --
    ALTER TABLE `shopping_cart`
      ADD PRIMARY KEY (`id`),
      ADD KEY `user_id` (`user_id`) USING BTREE,
      ADD KEY `product_post_id` (`product_post_id`) USING BTREE;

    --
    -- Indexes for table `sitemaps`
    --
    ALTER TABLE `sitemaps`
      ADD PRIMARY KEY (`sitemap_type`,`sitemap_part`),
      ADD KEY `generated_at` (`generated_at`);

    --
    -- Indexes for table `sneak_peaks`
    --
    ALTER TABLE `sneak_peaks`
      ADD PRIMARY KEY (`id`),
      ADD UNIQUE KEY `user_id_node_id_node_type` (`user_id`,`node_id`,`node_type`) USING BTREE;

    --
    -- Indexes for table `static_pages`
    --
    ALTER TABLE `static_pages`
      ADD PRIMARY KEY (`page_id`),
      ADD UNIQUE KEY `page_url` (`page_url`);

    --
    -- Indexes for table `stickers`
    --
    ALTER TABLE `stickers`
      ADD PRIMARY KEY (`sticker_id`);

    --
    -- Indexes for table `stories`
    --
    ALTER TABLE `stories`
      ADD PRIMARY KEY (`story_id`),
      ADD KEY `user_id_expires_at` (`user_id`,`expires_at`),
      ADD KEY `is_ads_expires_at` (`is_ads`,`expires_at`),
      ADD KEY `expires_at` (`expires_at`),
      ADD KEY `highlighted_expires_at` (`highlighted`,`expires_at`),
      ADD KEY `origin_id` (`origin_id`);

    --
    -- Indexes for table `stories_audience`
    --
    ALTER TABLE `stories_audience`
      ADD PRIMARY KEY (`id`),
      ADD UNIQUE KEY `user_id_target_id_type` (`user_id`,`target_id`,`type`),
      ADD KEY `target_id_type` (`target_id`,`type`);

    --
    -- Indexes for table `stories_highlights`
    --
    ALTER TABLE `stories_highlights`
      ADD PRIMARY KEY (`highlight_id`),
      ADD KEY `user_id` (`user_id`,`highlight_id`);

    --
    -- Indexes for table `stories_highlights_items`
    --
    ALTER TABLE `stories_highlights_items`
      ADD PRIMARY KEY (`id`),
      ADD UNIQUE KEY `highlight_id_story_id` (`highlight_id`,`story_id`),
      ADD KEY `story_id` (`story_id`);

    --
    -- Indexes for table `stories_music`
    --
    ALTER TABLE `stories_music`
      ADD PRIMARY KEY (`music_id`),
      ADD UNIQUE KEY `provider_provider_id` (`provider`,`provider_id`),
      ADD KEY `enabled_uses` (`enabled`,`uses`);

    --
    -- Indexes for table `stories_polls_votes`
    --
    ALTER TABLE `stories_polls_votes`
      ADD PRIMARY KEY (`id`),
      ADD UNIQUE KEY `story_id_user_id` (`story_id`,`user_id`),
      ADD KEY `user_id` (`user_id`,`story_id`);

    --
    -- Indexes for table `stories_reactions`
    --
    ALTER TABLE `stories_reactions`
      ADD PRIMARY KEY (`id`),
      ADD UNIQUE KEY `story_id_user_id` (`story_id`,`user_id`),
      ADD KEY `user_id` (`user_id`,`story_id`);

    --
    -- Indexes for table `stories_views`
    --
    ALTER TABLE `stories_views`
      ADD PRIMARY KEY (`view_id`),
      ADD UNIQUE KEY `story_id_user_id` (`story_id`,`user_id`),
      ADD KEY `user_id` (`user_id`,`story_id`);

    --
    -- Indexes for table `subscribers`
    --
    ALTER TABLE `subscribers`
      ADD PRIMARY KEY (`id`),
      ADD UNIQUE KEY `user_id_node_id_node_type` (`user_id`,`node_id`,`node_type`) USING BTREE,
      ADD KEY `node_id_node_type` (`node_id`,`node_type`);

    --
    -- Indexes for table `support_tickets`
    --
    ALTER TABLE `support_tickets`
      ADD PRIMARY KEY (`ticket_id`),
      ADD KEY `user_id` (`user_id`),
      ADD KEY `agent_id` (`agent_id`) USING BTREE;

    --
    -- Indexes for table `support_tickets_replies`
    --
    ALTER TABLE `support_tickets_replies`
      ADD PRIMARY KEY (`reply_id`),
      ADD KEY `user_id` (`user_id`),
      ADD KEY `ticket_id` (`ticket_id`) USING BTREE;

    --
    -- Indexes for table `system_countries`
    --
    ALTER TABLE `system_countries`
      ADD PRIMARY KEY (`country_id`);

    --
    -- Indexes for table `system_currencies`
    --
    ALTER TABLE `system_currencies`
      ADD PRIMARY KEY (`currency_id`);

    --
    -- Indexes for table `system_genders`
    --
    ALTER TABLE `system_genders`
      ADD PRIMARY KEY (`gender_id`) USING BTREE,
      ADD UNIQUE KEY `name` (`gender_name`) USING BTREE;

    --
    -- Indexes for table `system_languages`
    --
    ALTER TABLE `system_languages`
      ADD PRIMARY KEY (`language_id`),
      ADD UNIQUE KEY `code` (`code`);

    --
    -- Indexes for table `system_options`
    --
    ALTER TABLE `system_options`
      ADD PRIMARY KEY (`option_id`),
      ADD UNIQUE KEY `option_name` (`option_name`);

    --
    -- Indexes for table `system_reactions`
    --
    ALTER TABLE `system_reactions`
      ADD PRIMARY KEY (`reaction_id`);

    --
    -- Indexes for table `system_themes`
    --
    ALTER TABLE `system_themes`
      ADD PRIMARY KEY (`theme_id`),
      ADD UNIQUE KEY `name` (`name`);

    --
    -- Indexes for table `system_theme_landings`
    --
    ALTER TABLE `system_theme_landings`
      ADD PRIMARY KEY (`landing_id`),
      ADD UNIQUE KEY `theme_slug` (`theme_id`,`slug`);

    --
    -- Indexes for table `translations_cache`
    --
    ALTER TABLE `translations_cache`
      ADD PRIMARY KEY (`translation_id`),
      ADD UNIQUE KEY `node_lang` (`node_type`,`node_id`,`node_field`,`target_lang`);

    --
    -- Indexes for table `users`
    --
    ALTER TABLE `users`
      ADD PRIMARY KEY (`user_id`),
      ADD UNIQUE KEY `user_email` (`user_email`),
      ADD UNIQUE KEY `username` (`user_name`) USING BTREE,
      ADD UNIQUE KEY `facebook_id` (`facebook_id`),
      ADD UNIQUE KEY `twitter_id` (`twitter_id`),
      ADD UNIQUE KEY `linkedin_id` (`linkedin_id`),
      ADD UNIQUE KEY `vkontakte_id` (`vkontakte_id`),
      ADD UNIQUE KEY `user_phone` (`user_phone`),
      ADD UNIQUE KEY `google_id` (`google_id`),
      ADD KEY `user_picture_id` (`user_picture_id`),
      ADD KEY `user_gender` (`user_gender`),
      ADD KEY `user_cover_id` (`user_cover_id`),
      ADD KEY `user_country` (`user_country`),
      ADD KEY `user_album_pictures` (`user_album_pictures`),
      ADD KEY `user_album_covers` (`user_album_covers`),
      ADD KEY `user_album_timeline` (`user_album_timeline`),
      ADD KEY `user_banned` (`user_banned`) USING BTREE,
      ADD KEY `user_subscribed` (`user_subscribed`) USING BTREE,
      ADD KEY `user_registered` (`user_registered`) USING BTREE,
      ADD KEY `user_id_idx` (`user_id`) USING BTREE,
      ADD KEY `user_lastname_idx` (`user_lastname`) USING BTREE,
      ADD KEY `user_name_idx` (`user_name`) USING BTREE,
      ADD KEY `user_firstname_idx` (`user_firstname`) USING BTREE;

    --
    -- Indexes for table `users_accounts`
    --
    ALTER TABLE `users_accounts`
      ADD PRIMARY KEY (`id`),
      ADD UNIQUE KEY `user_id_account_id` (`user_id`,`account_id`) USING BTREE;

    --
    -- Indexes for table `users_addresses`
    --
    ALTER TABLE `users_addresses`
      ADD PRIMARY KEY (`address_id`),
      ADD KEY `user_id` (`user_id`) USING BTREE;

    --
    -- Indexes for table `users_affiliates`
    --
    ALTER TABLE `users_affiliates`
      ADD PRIMARY KEY (`id`) USING BTREE,
      ADD UNIQUE KEY `referrer_id_referee_id` (`referrer_id`,`referee_id`) USING BTREE;

    --
    -- Indexes for table `users_blocks`
    --
    ALTER TABLE `users_blocks`
      ADD PRIMARY KEY (`id`),
      ADD UNIQUE KEY `user_id_blocked_id` (`user_id`,`blocked_id`);

    --
    -- Indexes for table `users_gifts`
    --
    ALTER TABLE `users_gifts`
      ADD PRIMARY KEY (`id`),
      ADD KEY `from_user_id` (`from_user_id`),
      ADD KEY `to_user_id` (`to_user_id`),
      ADD KEY `gift_id` (`gift_id`);

    --
    -- Indexes for table `users_groups`
    --
    ALTER TABLE `users_groups`
      ADD PRIMARY KEY (`user_group_id`),
      ADD KEY `permissions_group_id` (`permissions_group_id`) USING BTREE;

    --
    -- Indexes for table `users_invitations`
    --
    ALTER TABLE `users_invitations`
      ADD PRIMARY KEY (`id`),
      ADD UNIQUE KEY `user_id_email_phone` (`user_id`,`email_phone`) USING BTREE;

    --
    -- Indexes for table `users_locations`
    --
    ALTER TABLE `users_locations`
      ADD PRIMARY KEY (`user_id`),
      ADD SPATIAL KEY `location` (`location`);

    --
    -- Indexes for table `users_login_countries`
    --
    ALTER TABLE `users_login_countries`
      ADD PRIMARY KEY (`user_id`,`country_code`);

    --
    -- Indexes for table `users_merits`
    --
    ALTER TABLE `users_merits`
      ADD PRIMARY KEY (`id`);

    --
    -- Indexes for table `users_packages_points`
    --
    ALTER TABLE `users_packages_points`
      ADD PRIMARY KEY (`id`),
      ADD UNIQUE KEY `user_id_poked_id` (`user_id`,`package_id`) USING BTREE;

    --
    -- Indexes for table `users_pokes`
    --
    ALTER TABLE `users_pokes`
      ADD PRIMARY KEY (`id`),
      ADD UNIQUE KEY `user_id_poked_id` (`user_id`,`poked_id`) USING BTREE;

    --
    -- Indexes for table `users_recurring_payments`
    --
    ALTER TABLE `users_recurring_payments`
      ADD PRIMARY KEY (`id`),
      ADD KEY `user_id` (`user_id`) USING BTREE;

    --
    -- Indexes for table `users_searches`
    --
    ALTER TABLE `users_searches`
      ADD PRIMARY KEY (`log_id`),
      ADD UNIQUE KEY `user_id_node_id_node_type` (`user_id`,`node_id`,`node_type`) USING BTREE,
      ADD KEY `user_id` (`user_id`);

    --
    -- Indexes for table `users_sessions`
    --
    ALTER TABLE `users_sessions`
      ADD PRIMARY KEY (`session_id`),
      ADD UNIQUE KEY `session_token` (`session_token`),
      ADD KEY `user_ip` (`user_ip`),
      ADD KEY `user_id` (`user_id`);

    --
    -- Indexes for table `users_shortcuts`
    --
    ALTER TABLE `users_shortcuts`
      ADD PRIMARY KEY (`id`),
      ADD UNIQUE KEY `user_id_node_type_node_id` (`user_id`,`node_type`,`node_id`),
      ADD KEY `user_id_state_time` (`user_id`,`state`,`time` DESC,`id` DESC),
      ADD KEY `node_type_node_id` (`node_type`,`node_id`);

    --
    -- Indexes for table `users_sms`
    --
    ALTER TABLE `users_sms`
      ADD PRIMARY KEY (`id`);

    --
    -- Indexes for table `users_top_friends`
    --
    ALTER TABLE `users_top_friends`
      ADD PRIMARY KEY (`id`),
      ADD UNIQUE KEY `user_id_friend_id` (`user_id`,`friend_id`) USING BTREE;

    --
    -- Indexes for table `users_uploads`
    --
    ALTER TABLE `users_uploads`
      ADD PRIMARY KEY (`id`);

    --
    -- Indexes for table `users_uploads_pending`
    --
    ALTER TABLE `users_uploads_pending`
      ADD PRIMARY KEY (`id`),
      ADD KEY `idx_file_name` (`file_name`) USING BTREE;

    --
    -- Indexes for table `verification_requests`
    --
    ALTER TABLE `verification_requests`
      ADD PRIMARY KEY (`request_id`);

    --
    -- Indexes for table `wallet_payments`
    --
    ALTER TABLE `wallet_payments`
      ADD PRIMARY KEY (`payment_id`) USING BTREE,
      ADD KEY `user_id` (`user_id`);

    --
    -- Indexes for table `wallet_transactions`
    --
    ALTER TABLE `wallet_transactions`
      ADD PRIMARY KEY (`transaction_id`),
      ADD KEY `user_id` (`user_id`);

    --
    -- Indexes for table `widgets`
    --
    ALTER TABLE `widgets`
      ADD PRIMARY KEY (`widget_id`);

    --
    -- AUTO_INCREMENT for dumped tables
    --

    --
    -- AUTO_INCREMENT for table `ads_campaigns`
    --
    ALTER TABLE `ads_campaigns`
      MODIFY `campaign_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `ads_system`
    --
    ALTER TABLE `ads_system`
      MODIFY `ads_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `affiliates_payments`
    --
    ALTER TABLE `affiliates_payments`
      MODIFY `payment_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `announcements`
    --
    ALTER TABLE `announcements`
      MODIFY `announcement_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `announcements_users`
    --
    ALTER TABLE `announcements_users`
      MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `auto_connect`
    --
    ALTER TABLE `auto_connect`
      MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `bank_transfers`
    --
    ALTER TABLE `bank_transfers`
      MODIFY `transfer_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `blacklist`
    --
    ALTER TABLE `blacklist`
      MODIFY `node_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `blogs_categories`
    --
    ALTER TABLE `blogs_categories`
      MODIFY `category_id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

    --
    -- AUTO_INCREMENT for table `ccbill_payments`
    --
    ALTER TABLE `ccbill_payments`
      MODIFY `payment_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `coinpayments_transactions`
    --
    ALTER TABLE `coinpayments_transactions`
      MODIFY `transaction_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `conversations`
    --
    ALTER TABLE `conversations`
      MODIFY `conversation_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `conversations_calls`
    --
    ALTER TABLE `conversations_calls`
      MODIFY `call_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `conversations_messages`
    --
    ALTER TABLE `conversations_messages`
      MODIFY `message_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `conversations_messages_media`
    --
    ALTER TABLE `conversations_messages_media`
      MODIFY `media_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `conversations_messages_paid`
    --
    ALTER TABLE `conversations_messages_paid`
      MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `conversations_messages_reactions`
    --
    ALTER TABLE `conversations_messages_reactions`
      MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `conversations_users`
    --
    ALTER TABLE `conversations_users`
      MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `courses_categories`
    --
    ALTER TABLE `courses_categories`
      MODIFY `category_id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

    --
    -- AUTO_INCREMENT for table `custom_fields`
    --
    ALTER TABLE `custom_fields`
      MODIFY `field_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `custom_fields_values`
    --
    ALTER TABLE `custom_fields_values`
      MODIFY `value_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `dating_interests`
    --
    ALTER TABLE `dating_interests`
      MODIFY `interest_id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

    --
    -- AUTO_INCREMENT for table `dating_matches`
    --
    ALTER TABLE `dating_matches`
      MODIFY `match_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `dating_photos`
    --
    ALTER TABLE `dating_photos`
      MODIFY `photo_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `dating_purchases`
    --
    ALTER TABLE `dating_purchases`
      MODIFY `purchase_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `dating_swipes`
    --
    ALTER TABLE `dating_swipes`
      MODIFY `swipe_id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `developers_apps`
    --
    ALTER TABLE `developers_apps`
      MODIFY `app_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `developers_apps_categories`
    --
    ALTER TABLE `developers_apps_categories`
      MODIFY `category_id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

    --
    -- AUTO_INCREMENT for table `developers_apps_users`
    --
    ALTER TABLE `developers_apps_users`
      MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `events`
    --
    ALTER TABLE `events`
      MODIFY `event_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `events_categories`
    --
    ALTER TABLE `events_categories`
      MODIFY `category_id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

    --
    -- AUTO_INCREMENT for table `events_members`
    --
    ALTER TABLE `events_members`
      MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `followings`
    --
    ALTER TABLE `followings`
      MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `forums`
    --
    ALTER TABLE `forums`
      MODIFY `forum_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `forums_likes`
    --
    ALTER TABLE `forums_likes`
      MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `forums_replies`
    --
    ALTER TABLE `forums_replies`
      MODIFY `reply_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `forums_threads`
    --
    ALTER TABLE `forums_threads`
      MODIFY `thread_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `friends`
    --
    ALTER TABLE `friends`
      MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `funding_categories`
    --
    ALTER TABLE `funding_categories`
      MODIFY `category_id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

    --
    -- AUTO_INCREMENT for table `funding_payments`
    --
    ALTER TABLE `funding_payments`
      MODIFY `payment_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `games`
    --
    ALTER TABLE `games`
      MODIFY `game_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `games_genres`
    --
    ALTER TABLE `games_genres`
      MODIFY `genre_id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

    --
    -- AUTO_INCREMENT for table `games_players`
    --
    ALTER TABLE `games_players`
      MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `gifts`
    --
    ALTER TABLE `gifts`
      MODIFY `gift_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `groups`
    --
    ALTER TABLE `groups`
      MODIFY `group_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `groups_admins`
    --
    ALTER TABLE `groups_admins`
      MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `groups_categories`
    --
    ALTER TABLE `groups_categories`
      MODIFY `category_id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

    --
    -- AUTO_INCREMENT for table `groups_invites`
    --
    ALTER TABLE `groups_invites`
      MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `groups_members`
    --
    ALTER TABLE `groups_members`
      MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `hashtags`
    --
    ALTER TABLE `hashtags`
      MODIFY `hashtag_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `hashtags_posts`
    --
    ALTER TABLE `hashtags_posts`
      MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `invitation_codes`
    --
    ALTER TABLE `invitation_codes`
      MODIFY `code_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `iyzico_payments`
    --
    ALTER TABLE `iyzico_payments`
      MODIFY `payment_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `jobs_categories`
    --
    ALTER TABLE `jobs_categories`
      MODIFY `category_id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

    --
    -- AUTO_INCREMENT for table `live_moderation_log`
    --
    ALTER TABLE `live_moderation_log`
      MODIFY `log_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `log_commissions`
    --
    ALTER TABLE `log_commissions`
      MODIFY `payment_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `log_payments`
    --
    ALTER TABLE `log_payments`
      MODIFY `payment_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `log_points`
    --
    ALTER TABLE `log_points`
      MODIFY `log_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `log_subscriptions`
    --
    ALTER TABLE `log_subscriptions`
      MODIFY `payment_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `market_categories`
    --
    ALTER TABLE `market_categories`
      MODIFY `category_id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

    --
    -- AUTO_INCREMENT for table `market_payments`
    --
    ALTER TABLE `market_payments`
      MODIFY `payment_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `merits_categories`
    --
    ALTER TABLE `merits_categories`
      MODIFY `category_id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

    --
    -- AUTO_INCREMENT for table `monetization_coupons`
    --
    ALTER TABLE `monetization_coupons`
      MODIFY `coupon_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `monetization_coupons_users`
    --
    ALTER TABLE `monetization_coupons_users`
      MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `monetization_payments`
    --
    ALTER TABLE `monetization_payments`
      MODIFY `payment_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `monetization_plans`
    --
    ALTER TABLE `monetization_plans`
      MODIFY `plan_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `movies`
    --
    ALTER TABLE `movies`
      MODIFY `movie_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `movies_genres`
    --
    ALTER TABLE `movies_genres`
      MODIFY `genre_id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

    --
    -- AUTO_INCREMENT for table `movies_payments`
    --
    ALTER TABLE `movies_payments`
      MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `notifications`
    --
    ALTER TABLE `notifications`
      MODIFY `notification_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `offers_categories`
    --
    ALTER TABLE `offers_categories`
      MODIFY `category_id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

    --
    -- AUTO_INCREMENT for table `orders`
    --
    ALTER TABLE `orders`
      MODIFY `order_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `orders_items`
    --
    ALTER TABLE `orders_items`
      MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `packages`
    --
    ALTER TABLE `packages`
      MODIFY `package_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `packages_payments`
    --
    ALTER TABLE `packages_payments`
      MODIFY `payment_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `pages`
    --
    ALTER TABLE `pages`
      MODIFY `page_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `pages_admins`
    --
    ALTER TABLE `pages_admins`
      MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `pages_categories`
    --
    ALTER TABLE `pages_categories`
      MODIFY `category_id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

    --
    -- AUTO_INCREMENT for table `pages_conversations`
    --
    ALTER TABLE `pages_conversations`
      MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `pages_invites`
    --
    ALTER TABLE `pages_invites`
      MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `pages_likes`
    --
    ALTER TABLE `pages_likes`
      MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `permissions_groups`
    --
    ALTER TABLE `permissions_groups`
      MODIFY `permissions_group_id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

    --
    -- AUTO_INCREMENT for table `plisio_payments`
    --
    ALTER TABLE `plisio_payments`
      MODIFY `payment_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `points_payments`
    --
    ALTER TABLE `points_payments`
      MODIFY `payment_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `posts`
    --
    ALTER TABLE `posts`
      MODIFY `post_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `posts_articles`
    --
    ALTER TABLE `posts_articles`
      MODIFY `article_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `posts_articles_references`
    --
    ALTER TABLE `posts_articles_references`
      MODIFY `refrence_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `posts_audios`
    --
    ALTER TABLE `posts_audios`
      MODIFY `audio_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `posts_cache`
    --
    ALTER TABLE `posts_cache`
      MODIFY `cache_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `posts_collaborative_users`
    --
    ALTER TABLE `posts_collaborative_users`
      MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `posts_colored_patterns`
    --
    ALTER TABLE `posts_colored_patterns`
      MODIFY `pattern_id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

    --
    -- AUTO_INCREMENT for table `posts_comments`
    --
    ALTER TABLE `posts_comments`
      MODIFY `comment_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `posts_comments_reactions`
    --
    ALTER TABLE `posts_comments_reactions`
      MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `posts_courses`
    --
    ALTER TABLE `posts_courses`
      MODIFY `course_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `posts_courses_applications`
    --
    ALTER TABLE `posts_courses_applications`
      MODIFY `application_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `posts_files`
    --
    ALTER TABLE `posts_files`
      MODIFY `file_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `posts_funding`
    --
    ALTER TABLE `posts_funding`
      MODIFY `funding_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `posts_funding_donors`
    --
    ALTER TABLE `posts_funding_donors`
      MODIFY `donation_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `posts_hidden`
    --
    ALTER TABLE `posts_hidden`
      MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `posts_jobs`
    --
    ALTER TABLE `posts_jobs`
      MODIFY `job_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `posts_jobs_applications`
    --
    ALTER TABLE `posts_jobs_applications`
      MODIFY `application_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `posts_links`
    --
    ALTER TABLE `posts_links`
      MODIFY `link_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `posts_live`
    --
    ALTER TABLE `posts_live`
      MODIFY `live_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `posts_live_categories`
    --
    ALTER TABLE `posts_live_categories`
      MODIFY `category_id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

    --
    -- AUTO_INCREMENT for table `posts_live_users`
    --
    ALTER TABLE `posts_live_users`
      MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `posts_media`
    --
    ALTER TABLE `posts_media`
      MODIFY `media_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `posts_merits`
    --
    ALTER TABLE `posts_merits`
      MODIFY `merit_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `posts_offers`
    --
    ALTER TABLE `posts_offers`
      MODIFY `offer_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `posts_paid`
    --
    ALTER TABLE `posts_paid`
      MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `posts_photos`
    --
    ALTER TABLE `posts_photos`
      MODIFY `photo_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `posts_photos_albums`
    --
    ALTER TABLE `posts_photos_albums`
      MODIFY `album_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `posts_photos_reactions`
    --
    ALTER TABLE `posts_photos_reactions`
      MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `posts_polls`
    --
    ALTER TABLE `posts_polls`
      MODIFY `poll_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `posts_polls_options`
    --
    ALTER TABLE `posts_polls_options`
      MODIFY `option_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `posts_polls_options_users`
    --
    ALTER TABLE `posts_polls_options_users`
      MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `posts_products`
    --
    ALTER TABLE `posts_products`
      MODIFY `product_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `posts_reactions`
    --
    ALTER TABLE `posts_reactions`
      MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `posts_reels`
    --
    ALTER TABLE `posts_reels`
      MODIFY `reel_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `posts_rich_text`
    --
    ALTER TABLE `posts_rich_text`
      MODIFY `rich_text_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `posts_saved`
    --
    ALTER TABLE `posts_saved`
      MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `posts_videos`
    --
    ALTER TABLE `posts_videos`
      MODIFY `video_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `posts_videos_categories`
    --
    ALTER TABLE `posts_videos_categories`
      MODIFY `category_id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

    --
    -- AUTO_INCREMENT for table `posts_views`
    --
    ALTER TABLE `posts_views`
      MODIFY `view_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `reports`
    --
    ALTER TABLE `reports`
      MODIFY `report_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `reports_categories`
    --
    ALTER TABLE `reports_categories`
      MODIFY `category_id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

    --
    -- AUTO_INCREMENT for table `reviews`
    --
    ALTER TABLE `reviews`
      MODIFY `review_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `reviews_photos`
    --
    ALTER TABLE `reviews_photos`
      MODIFY `photo_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `shopping_cart`
    --
    ALTER TABLE `shopping_cart`
      MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `sneak_peaks`
    --
    ALTER TABLE `sneak_peaks`
      MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `static_pages`
    --
    ALTER TABLE `static_pages`
      MODIFY `page_id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

    --
    -- AUTO_INCREMENT for table `stickers`
    --
    ALTER TABLE `stickers`
      MODIFY `sticker_id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

    --
    -- AUTO_INCREMENT for table `stories`
    --
    ALTER TABLE `stories`
      MODIFY `story_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `stories_audience`
    --
    ALTER TABLE `stories_audience`
      MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `stories_highlights`
    --
    ALTER TABLE `stories_highlights`
      MODIFY `highlight_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `stories_highlights_items`
    --
    ALTER TABLE `stories_highlights_items`
      MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `stories_music`
    --
    ALTER TABLE `stories_music`
      MODIFY `music_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `stories_polls_votes`
    --
    ALTER TABLE `stories_polls_votes`
      MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `stories_reactions`
    --
    ALTER TABLE `stories_reactions`
      MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `stories_views`
    --
    ALTER TABLE `stories_views`
      MODIFY `view_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `subscribers`
    --
    ALTER TABLE `subscribers`
      MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `support_tickets`
    --
    ALTER TABLE `support_tickets`
      MODIFY `ticket_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `support_tickets_replies`
    --
    ALTER TABLE `support_tickets_replies`
      MODIFY `reply_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `system_countries`
    --
    ALTER TABLE `system_countries`
      MODIFY `country_id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=246;

    --
    -- AUTO_INCREMENT for table `system_currencies`
    --
    ALTER TABLE `system_currencies`
      MODIFY `currency_id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

    --
    -- AUTO_INCREMENT for table `system_genders`
    --
    ALTER TABLE `system_genders`
      MODIFY `gender_id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

    --
    -- AUTO_INCREMENT for table `system_languages`
    --
    ALTER TABLE `system_languages`
      MODIFY `language_id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

    --
    -- AUTO_INCREMENT for table `system_options`
    --
    ALTER TABLE `system_options`
      MODIFY `option_id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20657;

    --
    -- AUTO_INCREMENT for table `system_reactions`
    --
    ALTER TABLE `system_reactions`
      MODIFY `reaction_id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

    --
    -- AUTO_INCREMENT for table `system_themes`
    --
    ALTER TABLE `system_themes`
      MODIFY `theme_id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

    --
    -- AUTO_INCREMENT for table `system_theme_landings`
    --
    ALTER TABLE `system_theme_landings`
      MODIFY `landing_id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

    --
    -- AUTO_INCREMENT for table `translations_cache`
    --
    ALTER TABLE `translations_cache`
      MODIFY `translation_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `users`
    --
    ALTER TABLE `users`
      MODIFY `user_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `users_accounts`
    --
    ALTER TABLE `users_accounts`
      MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `users_addresses`
    --
    ALTER TABLE `users_addresses`
      MODIFY `address_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `users_affiliates`
    --
    ALTER TABLE `users_affiliates`
      MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `users_blocks`
    --
    ALTER TABLE `users_blocks`
      MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `users_gifts`
    --
    ALTER TABLE `users_gifts`
      MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `users_groups`
    --
    ALTER TABLE `users_groups`
      MODIFY `user_group_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `users_invitations`
    --
    ALTER TABLE `users_invitations`
      MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `users_merits`
    --
    ALTER TABLE `users_merits`
      MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `users_packages_points`
    --
    ALTER TABLE `users_packages_points`
      MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `users_pokes`
    --
    ALTER TABLE `users_pokes`
      MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `users_recurring_payments`
    --
    ALTER TABLE `users_recurring_payments`
      MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `users_searches`
    --
    ALTER TABLE `users_searches`
      MODIFY `log_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `users_sessions`
    --
    ALTER TABLE `users_sessions`
      MODIFY `session_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `users_shortcuts`
    --
    ALTER TABLE `users_shortcuts`
      MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `users_sms`
    --
    ALTER TABLE `users_sms`
      MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `users_top_friends`
    --
    ALTER TABLE `users_top_friends`
      MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `users_uploads`
    --
    ALTER TABLE `users_uploads`
      MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `users_uploads_pending`
    --
    ALTER TABLE `users_uploads_pending`
      MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `verification_requests`
    --
    ALTER TABLE `verification_requests`
      MODIFY `request_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `wallet_payments`
    --
    ALTER TABLE `wallet_payments`
      MODIFY `payment_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `wallet_transactions`
    --
    ALTER TABLE `wallet_transactions`
      MODIFY `transaction_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

    --
    -- AUTO_INCREMENT for table `widgets`
    --
    ALTER TABLE `widgets`
      MODIFY `widget_id` int UNSIGNED NOT NULL AUTO_INCREMENT;
    COMMIT;

    /*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
    /*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
    /*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

    ";
  stream_progress(34, 'Building database tables');
  $db->multi_query($structure) or stream_fail(wizard_db_error($db, "The installation couldn't finish while building your database tables", 'install'));
  /* flush multi-query results */
  do {
    if ($db->errno) {
      stream_fail(wizard_db_error($db, "The installation couldn't finish while building your database tables", 'install'));
    }
  } while (mysqli_more_results($db) && mysqli_next_result($db));
  if ($db->errno) {
    stream_fail(wizard_db_error($db, "The installation couldn't finish while building your database tables", 'install'));
  }


  // step 4: creating the admin account
  stream_progress(50, 'Creating the admin account');
  /* generate system JWT key */
  $system_jwt_key = generate_jwt_key();
  /* update system options */
  update_system_options([
    'system_email' => secure($_POST['admin_email']),
    'system_jwt_key' => secure($system_jwt_key),
    'indexnow_key' => secure(md5(uniqid('', true))),
    'cronjob_hash' => secure(md5(uniqid('', true)))
  ], false);
  /* add the admin account */
  $db->query(sprintf("INSERT INTO users (user_group, user_email, user_name, user_firstname, user_password, user_gender, user_email_verified, user_activated, user_approved, user_verified, user_started, user_registered) VALUES ('1', %s, %s, %s, %s, '1', '1', '1', '1', '1', '1', %s)", secure($_POST['admin_email']), secure($_POST['admin_username']), secure($_POST['admin_username']), secure(_password_hash($_POST['admin_password'])), secure(gmdate('Y-m-d H:i:s')))) or stream_fail(wizard_db_error($db, "The installation couldn't finish while creating the admin account", 'install'));


  // step 5: writing the configuration
  stream_progress(67, 'Writing configuration');
  $config_string = '<?php
    define("DB_NAME", \'' . $_POST["db_name"] . '\');
    define("DB_USER", \'' . $_POST["db_username"] . '\');
    define("DB_PASSWORD", \'' . $_POST["db_password"] . '\');
    define("DB_HOST", \'' . $_POST["db_host"] . '\');
    define("DB_PORT", \'' . $_POST["db_port"] . '\');
    define("SYS_URL", \'' . get_system_url() . '\');
    define("URL_CHECK", true);
    define("DEBUGGING", false);
    define("DEFAULT_LOCALE", \'en_us\');
    define("LICENCE_KEY", \'' . addslashes($licence_key) . '\');
    ?>';
  $config_file = 'includes/config.php';
  $handle = fopen($config_file, 'w') or stream_fail("Installer wizard cannot create the config file");
  fwrite($handle, $config_string);
  fclose($handle);
  try {
    licence_store_payload($licence);
  } catch (Exception $e) {
    stream_fail($e->getMessage());
  }
  licence_turn_off_premium_options();


  // step 6: finishing up
  stream_progress(84, 'Finishing up');
  if ($is_stream) {
    stream_progress(100);
    stream_send(['success' => true, 'redirect' => './']);
    exit;
  }
  header('Location: ./');
}

?>

<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title><?php echo SYS_NAME ?> &rsaquo; Installer (v<?php echo SYS_VER ?>)</title>
  <link rel="icon" type="image/png" href="content/themes/nova/images/favicon.png">
  <style>
    :root {
      --bg: #eef1f8;
      --bg2: #e2e7f5;
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
        --bg2: #161c2f;
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
      top: 0;
      left: 50%;
      transform: translateX(-50%);
      width: 100%;
      max-width: none;
      height: 620px;
      z-index: 0;
      pointer-events: none;
      background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='45.033' height='78' viewBox='0 0 45.033 78'%3E%3Cg fill='none' stroke='%235e72e4' stroke-opacity='0.14' stroke-width='1'%3E%3Cpath d='M22.517 -26L45.034 -13L45.034 13L22.517 26L0 13L0 -13Z'/%3E%3Cpath d='M0 13L22.517 26L22.517 52L0 65L-22.517 52L-22.517 26Z'/%3E%3Cpath d='M45.033 13L67.55 26L67.55 52L45.033 65L22.516 52L22.516 26Z'/%3E%3Cpath d='M22.517 52L45.034 65L45.034 91L22.517 104L0 91L0 65Z'/%3E%3C/g%3E%3C/svg%3E");
      background-repeat: repeat;
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
      max-width: 760px;
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

    .stepper {
      list-style: none;
      display: flex;
      margin: 0;
      padding: 20px 28px 4px;
      gap: 6px;
    }

    .stepper li {
      flex: 1;
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 8px;
      position: relative;
      font-size: 12.5px;
      color: var(--muted);
    }

    .stepper li .dot {
      width: 30px;
      height: 30px;
      border-radius: 50%;
      display: grid;
      place-items: center;
      background: var(--field);
      border: 1px solid var(--line);
      font-weight: 700;
      font-size: 13px;
      transition: .25s;
      z-index: 1;
    }

    .stepper li::before {
      content: "";
      position: absolute;
      top: 15px;
      left: -50%;
      width: 100%;
      height: 2px;
      background: var(--line);
      z-index: 0;
    }

    .stepper li:first-child::before {
      display: none;
    }

    .stepper li.active .dot,
    .stepper li.done .dot {
      background: linear-gradient(135deg, var(--accent), var(--accent-2));
      border-color: transparent;
      color: #fff;
      box-shadow: 0 6px 16px -6px var(--accent);
    }

    .stepper li.active {
      color: var(--text);
      font-weight: 600;
    }

    .stepper li.done::before,
    .stepper li.active::before {
      background: var(--accent);
    }

    .stepper li .lbl {
      display: none;
      text-align: center;
      line-height: 1.2;
    }

    @media (min-width: 640px) {
      .stepper li .lbl {
        display: block;
      }
    }

    form {
      padding: 8px 28px 28px;
    }

    .alert {
      display: none;
      margin: 12px 0 4px;
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

    a {
      color: var(--accent);
    }

    .hint {
      margin: 8px 0 0;
      font-size: 13px;
      line-height: 1.55;
      color: var(--muted);
    }

    .notice {
      display: none;
      margin: 16px 0 0;
      padding: 14px 16px;
      border-radius: 12px;
      font-size: 13.5px;
      line-height: 1.55;
    }

    .notice.show {
      display: block;
    }

    .notice strong {
      display: block;
      margin-bottom: 4px;
    }

    .notice p {
      margin: 0;
      color: inherit;
      font-size: inherit;
    }

    .notice.is-included {
      background: rgba(45, 206, 137, .12);
      color: var(--ok);
      border: 1px solid rgba(45, 206, 137, .28);
    }

    .notice.is-core {
      background: var(--field);
      color: var(--text);
      border: 1px solid var(--line);
    }

    .notice.is-warning {
      display: block;
      background: rgba(251, 176, 59, .12);
      color: var(--text);
      border: 1px solid rgba(251, 176, 59, .35);
    }

    .notice.is-warning strong {
      color: #c47b00;
    }

    .notice.is-warning p+p {
      margin-top: 8px;
    }

    .panel .notice p {
      margin: 0;
      font-size: inherit;
    }

    .panel .notice.is-included p,
    .panel .notice.is-included a,
    .panel .notice.is-warning p {
      color: inherit;
    }

    .panel {
      display: none;
      padding-top: 12px;
      animation: fade .3s ease;
    }

    .panel.active {
      display: block;
    }

    @keyframes fade {
      from {
        opacity: 0;
        transform: translateY(6px);
      }

      to {
        opacity: 1;
        transform: none;
      }
    }

    .panel h2 {
      font-size: 17px;
      margin: 4px 0 6px;
      letter-spacing: -.2px;
    }

    .panel p {
      color: var(--muted);
      font-size: 14px;
      line-height: 1.6;
      margin: 0 0 14px;
    }

    .section-title {
      font-size: 12px;
      text-transform: uppercase;
      letter-spacing: .08em;
      color: var(--muted);
      margin: 20px 0 10px;
      font-weight: 700;
    }

    .terms {
      display: grid;
      gap: 16px;
    }

    .terms .box {
      background: var(--field);
      border: 1px solid var(--line);
      border-radius: 12px;
      padding: 14px 16px;
    }

    .terms .box strong {
      font-size: 13px;
    }

    .terms ul {
      margin: 10px 0 0;
      padding-left: 0;
      list-style: none;
    }

    .terms li {
      display: flex;
      align-items: flex-start;
      gap: 9px;
      font-size: 13px;
      color: var(--muted);
      margin: 7px 0;
      line-height: 1.5;
    }

    .terms li .ic {
      width: 16px;
      height: 16px;
      flex: none;
      margin-top: 2px;
    }

    .terms li .ic-can {
      color: var(--ok);
    }

    .terms li .ic-cannot {
      color: var(--err);
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

    .grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 14px;
    }

    .grid .full {
      grid-column: 1 / -1;
    }

    @media (max-width: 520px) {
      .grid {
        grid-template-columns: 1fr;
      }
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

    .req {
      list-style: none;
      margin: 0;
      padding: 0;
      display: grid;
      gap: 8px;
    }

    .req li {
      display: flex;
      align-items: center;
      gap: 12px;
      padding: 12px 14px;
      border: 1px solid var(--line);
      border-radius: 11px;
      background: var(--field);
    }

    .req .info {
      flex: 1;
      min-width: 0;
    }

    .req .name {
      font-size: 13.5px;
      font-weight: 600;
    }

    .req .desc {
      font-size: 12px;
      color: var(--muted);
    }

    .req .status {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      font-size: 12.5px;
      font-weight: 700;
      white-space: nowrap;
    }

    .req .status.pass {
      color: var(--ok);
    }

    .req .status.fail {
      color: var(--err);
    }

    .req .status svg {
      width: 16px;
      height: 16px;
    }

    .review {
      display: grid;
      gap: 10px;
    }

    .review .row {
      display: flex;
      justify-content: space-between;
      gap: 16px;
      padding: 11px 14px;
      background: var(--field);
      border: 1px solid var(--line);
      border-radius: 10px;
      font-size: 13.5px;
    }

    .review .row span:first-child {
      color: var(--muted);
    }

    .review .row span:last-child {
      font-weight: 600;
      text-align: right;
      word-break: break-word;
    }

    .foot {
      display: flex;
      justify-content: space-between;
      gap: 10px;
      margin-top: 26px;
      padding-top: 20px;
      border-top: 1px solid var(--line);
    }

    .btn {
      border: none;
      border-radius: 10px;
      padding: 12px 22px;
      font-size: 14px;
      font-weight: 600;
      cursor: pointer;
      transition: .15s;
      font-family: inherit;
    }

    .btn.primary {
      color: #fff;
      background: linear-gradient(135deg, var(--accent), var(--accent-2));
      box-shadow: 0 10px 22px -10px var(--accent);
    }

    .btn.primary:hover {
      filter: brightness(1.06);
    }

    .btn.ghost {
      background: transparent;
      color: var(--muted);
      border: 1px solid var(--line);
    }

    .btn.ghost:hover {
      color: var(--text);
      border-color: var(--muted);
    }

    .btn:disabled {
      opacity: .5;
      cursor: not-allowed;
    }

    .btn[hidden] {
      display: none;
    }

    .overlay {
      position: fixed;
      inset: 0;
      z-index: 50;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 20px;
      background: rgba(14, 18, 32, .6);
      backdrop-filter: blur(6px);
    }

    .overlay[hidden] {
      display: none;
    }

    .progress-card {
      position: relative;
      z-index: 1;
      width: 100%;
      max-width: 440px;
      background: var(--card);
      border: 1px solid var(--line);
      border-radius: 18px;
      padding: 30px 28px;
      box-shadow: var(--shadow);
      text-align: center;
    }

    .progress-card h2 {
      margin: 0 0 4px;
      font-size: 18px;
    }

    .progress-card .sub {
      color: var(--muted);
      font-size: 13px;
      margin-bottom: 22px;
    }

    .bar {
      position: relative;
      height: 10px;
      border-radius: 99px;
      background: var(--field);
      border: 1px solid var(--line);
      overflow: hidden;
    }

    .bar span {
      display: block;
      height: 100%;
      width: 0;
      border-radius: 99px;
      background: linear-gradient(90deg, var(--accent), var(--accent-2));
      transition: width .4s ease;
    }

    .bar::after {
      content: "";
      position: absolute;
      inset: 0;
      border-radius: 99px;
      background: linear-gradient(90deg, transparent, rgba(255, 255, 255, .45), transparent);
      transform: translateX(-100%);
      opacity: 0;
    }

    .bar.busy::after {
      opacity: 1;
      animation: shimmer 1.15s linear infinite;
    }

    @keyframes shimmer {
      to {
        transform: translateX(100%);
      }
    }

    .pct {
      font-size: 13px;
      font-weight: 700;
      color: var(--accent);
      margin: 10px 0 20px;
    }

    .stages {
      list-style: none;
      margin: 0;
      padding: 0;
      text-align: left;
      display: grid;
      gap: 9px;
    }

    .stages li {
      display: flex;
      align-items: center;
      gap: 10px;
      font-size: 13px;
      color: var(--muted);
      transition: color .2s;
    }

    .stages li .mk {
      width: 18px;
      height: 18px;
      border-radius: 50%;
      border: 2px solid var(--line);
      flex: none;
      display: grid;
      place-items: center;
      transition: .2s;
    }

    .stages li .mk svg {
      width: 11px;
      height: 11px;
      opacity: 0;
    }

    .stages li.active {
      color: var(--text);
      font-weight: 600;
    }

    .stages li.active .mk {
      border-color: var(--accent);
      border-top-color: transparent;
      animation: sp .7s linear infinite;
    }

    .stages li.done {
      color: var(--text);
    }

    .stages li.done .mk {
      background: var(--ok);
      border-color: var(--ok);
    }

    .stages li.done .mk svg {
      opacity: 1;
      color: #fff;
    }

    .spin {
      width: 10px;
      height: 10px;
      border: 2px solid transparent;
      border-top-color: var(--accent);
      border-radius: 50%;
      animation: sp .6s linear infinite;
    }

    @keyframes sp {
      to {
        transform: rotate(360deg);
      }
    }

    #congrats-view {
      text-align: center;
      position: relative;
    }

    .congrats-badge {
      width: 76px;
      height: 76px;
      border-radius: 50%;
      margin: 6px auto 18px;
      display: grid;
      place-items: center;
      color: #fff;
      background: linear-gradient(135deg, var(--ok), #2ab8d8);
      box-shadow: 0 12px 26px -10px var(--ok);
      animation: pop .5s cubic-bezier(.2, 1.4, .4, 1) both;
    }

    .congrats-badge svg {
      width: 38px;
      height: 38px;
    }

    #congrats-view h2 {
      margin: 0 0 6px;
      font-size: 22px;
    }

    #congrats-view .sub {
      margin-bottom: 24px;
    }

    .congrats-btn {
      width: 100%;
      padding: 15px 22px;
      font-size: 15px;
    }

    @keyframes pop {
      0% {
        transform: scale(0);
      }

      100% {
        transform: scale(1);
      }
    }

    .confetti {
      position: absolute;
      inset: 0;
      overflow: hidden;
      pointer-events: none;
      z-index: 2;
    }

    .confetti i {
      position: absolute;
      left: 50%;
      top: 50%;
      width: 9px;
      height: 15px;
      opacity: 0;
      border-radius: 1px;
      will-change: transform, opacity;
      animation: burst cubic-bezier(.2, .6, .3, 1) forwards;
    }

    @keyframes burst {
      0% {
        transform: translate(-50%, -50%) rotate(0deg) scale(.35);
        opacity: 1;
      }

      100% {
        transform: translate(calc(-50% + var(--tx)), calc(-50% + var(--ty))) rotate(var(--rot)) scale(1);
        opacity: 0;
      }
    }
  </style>
</head>

<body>
  <div class="installer">
    <div class="hd">
      <img src="content/themes/nova/images/favicon.png" alt="">
      <div>
        <h1><?php echo SYS_NAME ?> Installer</h1>
        <div class="ver">Version <?php echo SYS_VER ?></div>
      </div>
    </div>

    <ol class="stepper" id="stepper">
      <li class="active" data-step="0"><span class="dot">1</span><span class="lbl">Welcome</span></li>
      <li data-step="1"><span class="dot">2</span><span class="lbl">Requirements</span></li>
      <li data-step="2"><span class="dot">3</span><span class="lbl">License</span></li>
      <li data-step="3"><span class="dot">4</span><span class="lbl">Configuration</span></li>
      <li data-step="4"><span class="dot">5</span><span class="lbl">Finish</span></li>
    </ol>

    <form id="wizard" method="post" novalidate data-requirements-ok="<?php echo $requirements_ok ? 'true' : 'false' ?>">
      <div class="alert" id="alert"></div>

      <!-- Step 1: Welcome -->
      <section class="panel active" data-step="0">
        <h2>Welcome</h2>
        <p>Welcome to the <strong><?php echo SYS_NAME ?></strong> installation. Just fill in the required information and launch your own social network.</p>
        <div class="terms">
          <div class="box">
            <strong>You CAN</strong>
            <ul>
              <li><svg class="ic ic-can" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                  <path d="M20 6L9 17l-5-5" />
                </svg>Install on one (1) end-product (domain.com, sub.domain.com or domain.com/directory).</li>
              <li><svg class="ic ic-can" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                  <path d="M20 6L9 17l-5-5" />
                </svg>Install on your localhost for testing or development.</li>
              <li><svg class="ic ic-can" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                  <path d="M20 6L9 17l-5-5" />
                </svg>Edit the source code and design to suit your business needs.</li>
            </ul>
          </div>
          <div class="box">
            <strong>You CANNOT</strong>
            <ul>
              <li><svg class="ic ic-cannot" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                  <path d="M18 6L6 18M6 6l12 12" />
                </svg>Run it on two (2) or more end-products at the same time with the same license.</li>
              <li><svg class="ic ic-cannot" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                  <path d="M18 6L6 18M6 6l12 12" />
                </svg>Resell, distribute, give away or trade by any means to any third party.</li>
            </ul>
          </div>
        </div>
        <div class="notice show is-warning" role="note">
          <strong>Important License Notice</strong>
          <p>Sngine is copyrighted software and is sold exclusively under Zamblek’s license terms. Zamblek.com is the sole official provider of Sngine updates, support, and license issuance.</p>
          <p>License files are cryptographically signed per customer. Editing, replacing, or otherwise tampering with license files is a violation of these terms and may result in immediate suspension of your license and/or your Zamblek account, including loss of access to your licenses, product downloads, and future updates.</p>
        </div>
        <label class="agree">
          <input type="checkbox" id="license-checkbox">
          <span>I agree with the Terms and Conditions.</span>
        </label>
      </section>

      <!-- Step 2: Requirements -->
      <section class="panel" data-step="1">
        <h2>System Requirements</h2>
        <p>All items below must pass before you can continue. Contact your host if anything is missing.</p>
        <ul class="req">
          <?php foreach ($requirements_matrix as $key => $req) {
            $failed = isset($requirements_errors[$key]); ?>
            <li>
              <div class="info">
                <div class="name"><?php echo $req[0] ?></div>
                <div class="desc"><?php echo $req[1] ?></div>
              </div>
              <?php if ($failed) { ?>
                <span class="status fail">
                  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                    <path d="M18 6L6 18M6 6l12 12" />
                  </svg> Missing
                </span>
              <?php } else { ?>
                <span class="status pass">
                  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                    <path d="M20 6L9 17l-5-5" />
                  </svg> Ready
                </span>
              <?php } ?>
            </li>
          <?php } ?>
        </ul>
      </section>

      <!-- Step 3: License -->
      <section class="panel" data-step="2">
        <h2>License</h2>
        <p>Enter your license key to continue. You can get it from <a href="https://zamblek.com/purchases" target="_blank" rel="noopener">zamblek.com/purchases</a>, or use your Envato purchase code.</p>
        <div class="grid">
          <div class="field full">
            <label for="purchase_code">License Key</label>
            <input type="text" name="purchase_code" id="purchase_code" placeholder="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx">
            <div class="hint">Zamblek license key or Envato purchase code</div>
          </div>
        </div>
        <div class="notice" id="licence-notice">
          <strong id="licence-notice-title"></strong>
          <p id="licence-notice-body"></p>
        </div>
      </section>

      <!-- Step 4: Configuration -->
      <section class="panel" data-step="3">
        <h2>Database &amp; Administrator</h2>
        <p>Enter your database and administrator details.</p>

        <div class="section-title">Database</div>
        <div class="grid">
          <div class="field full">
            <label for="db_name">Database Name</label>
            <input type="text" name="db_name" id="db_name">
          </div>
          <div class="field">
            <label for="db_username">Database Username</label>
            <input type="text" name="db_username" id="db_username">
          </div>
          <div class="field">
            <label for="db_password">Database Password</label>
            <input type="text" name="db_password" id="db_password" data-optional="1">
          </div>
          <div class="field">
            <label for="db_host">Database Host</label>
            <input type="text" name="db_host" id="db_host" value="localhost">
          </div>
          <div class="field">
            <label for="db_port">Database Port</label>
            <input type="text" name="db_port" id="db_port" value="3306">
          </div>
        </div>

        <div class="section-title">Administrator</div>
        <div class="grid">
          <div class="field full">
            <label for="admin_email">Admin Email</label>
            <input type="text" name="admin_email" id="admin_email">
          </div>
          <div class="field">
            <label for="admin_username">Admin Username</label>
            <input type="text" name="admin_username" id="admin_username">
          </div>
          <div class="field">
            <label for="admin_password">Admin Password</label>
            <input type="password" name="admin_password" id="admin_password">
          </div>
        </div>
      </section>

      <!-- Step 5: Review -->
      <section class="panel" data-step="4">
        <h2>Review &amp; Install</h2>
        <p>Confirm your details, then start the installation.</p>
        <div class="review">
          <div class="row"><span>License Key</span><span id="r_purchase_code">&mdash;</span></div>
          <div class="row"><span>Database Name</span><span id="r_db_name">&mdash;</span></div>
          <div class="row"><span>Database Username</span><span id="r_db_username">&mdash;</span></div>
          <div class="row"><span>Database Host</span><span id="r_db_host">&mdash;</span></div>
          <div class="row"><span>Database Port</span><span id="r_db_port">&mdash;</span></div>
          <div class="row"><span>Admin Email</span><span id="r_admin_email">&mdash;</span></div>
          <div class="row"><span>Admin Username</span><span id="r_admin_username">&mdash;</span></div>
        </div>
      </section>

      <div class="foot">
        <button type="button" class="btn ghost" id="btn-back" hidden>Back</button>
        <div style="flex:1"></div>
        <button type="button" class="btn primary" id="btn-next">Next</button>
        <button type="submit" class="btn primary" id="btn-install" name="submit" value="1" hidden>Install</button>
      </div>
    </form>
  </div>

  <!-- Progress overlay -->
  <div class="overlay" id="overlay" hidden>
    <div class="confetti" id="confetti" aria-hidden="true"></div>
    <div class="progress-card">
      <div id="progress-view">
        <h2>Installing <?php echo SYS_NAME ?></h2>
        <div class="sub">This can take a moment. Please don't close this window.</div>
        <div class="bar"><span id="bar-fill"></span></div>
        <div class="pct" id="pct">0%</div>
        <ul class="stages" id="stages">
          <li data-stage>
            <span class="mk">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3">
                <path d="M20 6L9 17l-5-5" />
              </svg>
            </span>
            Verifying purchase code
          </li>
          <li data-stage>
            <span class="mk">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3">
                <path d="M20 6L9 17l-5-5" />
              </svg>
            </span>
            Connecting to the database
          </li>
          <li data-stage>
            <span class="mk">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3">
                <path d="M20 6L9 17l-5-5" />
              </svg>
            </span>
            Building database tables
          </li>
          <li data-stage>
            <span class="mk">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3">
                <path d="M20 6L9 17l-5-5" />
              </svg>
            </span>
            Creating the admin account
          </li>
          <li data-stage>
            <span class="mk">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3">
                <path d="M20 6L9 17l-5-5" />
              </svg>
            </span>
            Writing configuration
          </li>
          <li data-stage>
            <span class="mk">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3">
                <path d="M20 6L9 17l-5-5" />
              </svg>
            </span>
            Finishing up
          </li>
        </ul>
      </div>

      <!-- Congratulations -->
      <div id="congrats-view" hidden>
        <div class="congrats-badge">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
            <path d="M20 6L9 17l-5-5" />
          </svg>
        </div>
        <h2>You're all set! 🎉</h2>
        <div class="sub"><strong><?php echo SYS_NAME ?></strong> has been installed successfully.<br>Redirecting to your new site in <span id="countdown">5</span>s&hellip;</div>
        <button type="button" class="btn primary congrats-btn" id="btn-start">Let's Start</button>
      </div>
    </div>
  </div>

  <script>
    (function() {
      // initialize variables
      var form = document.getElementById('wizard');
      var panels = Array.prototype.slice.call(form.querySelectorAll('.panel'));
      var steps = Array.prototype.slice.call(document.querySelectorAll('#stepper li'));
      var alertBox = document.getElementById('alert');
      var btnBack = document.getElementById('btn-back');
      var btnNext = document.getElementById('btn-next');
      var btnInstall = document.getElementById('btn-install');
      var current = 0;
      var last = panels.length - 1;
      var requirementsOk = form.getAttribute('data-requirements-ok') === 'true';
      var licenceVerified = false;
      var licenceVerifiedCode = '';
      var licenceNotice = document.getElementById('licence-notice');
      var licenceNoticeTitle = document.getElementById('licence-notice-title');
      var licenceNoticeBody = document.getElementById('licence-notice-body');
      var STEP_LICENSE = 2;
      var STEP_DATABASE = 3;


      // helper functions
      /* show alert */
      function showAlert(msg) {
        alertBox.textContent = msg;
        alertBox.classList.add('show');
      }
      /* clear alert */
      function clearAlert() {
        alertBox.classList.remove('show');
      }
      /* render steps */
      function render() {
        panels.forEach(function(p, i) {
          p.classList.toggle('active', i === current);
        });
        steps.forEach(function(s, i) {
          s.classList.toggle('active', i === current);
          s.classList.toggle('done', i < current);
        });
        btnBack.hidden = current === 0;
        btnNext.hidden = current === last;
        btnInstall.hidden = current !== last;
        btnNext.textContent = (current === STEP_LICENSE && !licenceVerified) ? 'Verify License' : 'Next';
        clearAlert();
      }
      /* validate form */
      function validate(step) {
        clearAlert();
        if (step === 0) {
          if (!document.getElementById('license-checkbox').checked) {
            showAlert('You must agree to the Terms and Conditions to continue.');
            return false;
          }
        }
        if (step === 1) {
          if (!requirementsOk) {
            showAlert('Some requirements are missing. Please fix them before continuing.');
            return false;
          }
        }
        if (step === STEP_LICENSE) {
          var code = document.getElementById('purchase_code').value.trim();
          if (!code) {
            document.getElementById('purchase_code').classList.add('invalid');
            showAlert('Please enter a valid purchase code');
            return false;
          }
          document.getElementById('purchase_code').classList.remove('invalid');
        }
        if (step === STEP_DATABASE) {
          var ok = true;
          panels[STEP_DATABASE].querySelectorAll('input').forEach(function(inp) {
            if (inp.dataset.optional) return;
            if (!inp.value.trim()) {
              inp.classList.add('invalid');
              ok = false;
            } else inp.classList.remove('invalid');
          });
          if (!ok) {
            showAlert('Please fill in all required fields.');
            return false;
          }
          fillReview();
        }
        return true;
      }
      /* fill review */
      function fillReview() {
        ['purchase_code', 'db_name', 'db_username', 'db_host', 'db_port', 'admin_email', 'admin_username'].forEach(function(id) {
          var el = document.getElementById(id);
          var out = document.getElementById('r_' + id);
          if (el && out) out.textContent = el.value.trim() || '—';
        });
      }


      function resetLicenceNotice() {
        licenceVerified = false;
        licenceVerifiedCode = '';
        licenceNotice.classList.remove('show', 'is-included', 'is-core');
        licenceNoticeTitle.textContent = '';
        licenceNoticeBody.innerHTML = '';
        if (current === STEP_LICENSE) btnNext.textContent = 'Verify License';
      }

      function showLicenceNotice(included) {
        licenceNotice.classList.remove('is-included', 'is-core');
        if (included) {
          licenceNotice.classList.add('is-included');
          licenceNoticeTitle.textContent = 'Payments & Monetization are included';
          licenceNoticeBody.innerHTML = 'Monetization will be part of your installation. You can enable payments and monetization features after setup. For more information, visit <a href="https://zamblek.com/pricing" target="_blank" rel="noopener">zamblek.com/pricing</a>.';
        } else {
          licenceNotice.classList.add('is-core');
          licenceNoticeTitle.textContent = 'Payments & Monetization are not included';
          licenceNoticeBody.innerHTML = 'This license is a core-only install. Payments and monetization features will stay unavailable unless you upgrade. For more information, visit <a href="https://zamblek.com/pricing" target="_blank" rel="noopener">zamblek.com/pricing</a>.';
        }
        licenceNotice.classList.add('show');
      }

      function verifyLicenceThenNext() {
        if (!validate(STEP_LICENSE)) return;
        var code = document.getElementById('purchase_code').value.trim();
        if (licenceVerified && code === licenceVerifiedCode) {
          current++;
          render();
          return;
        }
        btnNext.disabled = true;
        btnNext.textContent = 'Verifying...';
        var data = new FormData();
        data.append('verify_licence', '1');
        data.append('purchase_code', code);
        fetch(window.location.href, {
            method: 'POST',
            headers: {
              'X-Requested-With': 'XMLHttpRequest',
              'Accept': 'application/json'
            },
            body: data
          })
          .then(function(res) {
            return res.json().catch(function() {
              return null;
            });
          })
          .then(function(msg) {
            btnNext.disabled = false;
            if (!msg || !msg.success) {
              resetLicenceNotice();
              showAlert((msg && msg.message) ? msg.message : 'License verification failed. Please try again.');
              btnNext.textContent = 'Verify License';
              return;
            }
            licenceVerified = true;
            licenceVerifiedCode = code;
            showLicenceNotice(!!msg.monetization);
            btnNext.textContent = 'Next';
            clearAlert();
          })
          .catch(function() {
            btnNext.disabled = false;
            resetLicenceNotice();
            btnNext.textContent = 'Verify License';
            showAlert('A network error occurred. Please check your connection and try again.');
          });
      }


      // event listeners
      /* next button */
      btnNext.addEventListener('click', function() {
        if (current === STEP_LICENSE) {
          verifyLicenceThenNext();
          return;
        }
        if (!validate(current)) return;
        if (current < last) {
          current++;
          render();
        }
      });
      /* back button */
      btnBack.addEventListener('click', function() {
        if (current > 0) {
          current--;
          render();
        }
      });
      /* input change */
      form.querySelectorAll('input').forEach(function(inp) {
        inp.addEventListener('input', function() {
          inp.classList.remove('invalid');
          if (inp.id === 'purchase_code' && licenceVerified && inp.value.trim() !== licenceVerifiedCode) {
            resetLicenceNotice();
          }
        });
      });


      // handle progress
      /* initialize progress */
      var overlay = document.getElementById('overlay');
      var barFill = document.getElementById('bar-fill');
      var bar = barFill.parentNode;
      var pctEl = document.getElementById('pct');
      var stageEls = Array.prototype.slice.call(document.querySelectorAll('#stages li'));
      /* set progress */
      function setProgress(pct) {
        barFill.style.width = pct + '%';
        pctEl.textContent = Math.round(pct) + '%';
        var idx = Math.min(stageEls.length - 1, Math.floor((pct / 100) * stageEls.length));
        stageEls.forEach(function(li, i) {
          li.classList.toggle('done', i < idx);
          li.classList.toggle('active', pct < 100 && i === idx);
        });
      }
      /* mark all stages done */
      function markAllDone() {
        bar.classList.remove('busy');
        setProgress(100);
        stageEls.forEach(function(li) {
          li.classList.remove('active');
          li.classList.add('done');
        });
      }
      /* fail UI */
      function failUI(message) {
        bar.classList.remove('busy');
        overlay.hidden = true;
        btnInstall.disabled = false;
        var licenseFail = /license|purchase code|domain does not match/i.test(message || '');
        current = licenseFail ? STEP_LICENSE : STEP_DATABASE;
        render();
        showAlert(message);
      }
      /* launch confetti */
      function launchConfetti() {
        var box = document.getElementById('confetti');
        box.innerHTML = '';
        var colors = ['#5e72e4', '#825ee4', '#2dce89', '#fb6340', '#ffd600', '#11cdef', '#f5365c'];
        var reach = 300; /* keep the burst around the popup, not the whole page */
        for (var i = 0; i < 120; i++) {
          var p = document.createElement('i');
          var angle = Math.random() * Math.PI * 2;
          var dist = 40 + Math.random() * reach;
          var sc = 0.6 + Math.random() * 0.9;
          p.style.setProperty('--tx', (Math.cos(angle) * dist).toFixed(0) + 'px');
          p.style.setProperty('--ty', (Math.sin(angle) * dist).toFixed(0) + 'px');
          p.style.setProperty('--rot', (Math.random() * 900 - 450).toFixed(0) + 'deg');
          p.style.background = colors[i % colors.length];
          p.style.width = (7 * sc).toFixed(1) + 'px';
          p.style.height = (13 * sc).toFixed(1) + 'px';
          p.style.animationDuration = (2.4 + Math.random() * 1.6) + 's';
          p.style.animationDelay = (Math.random() * 0.1) + 's';
          if (i % 3 === 0) p.style.borderRadius = '50%';
          box.appendChild(p);
        }
      }
      /* show congratulations */
      function showCongrats(url) {
        document.getElementById('progress-view').hidden = true;
        document.getElementById('congrats-view').hidden = false;
        launchConfetti();
        var go = function() {
          window.location.href = url;
        };
        document.getElementById('btn-start').addEventListener('click', go);
        var remaining = 5;
        var cd = document.getElementById('countdown');
        var ticker = setInterval(function() {
          remaining--;
          if (cd) cd.textContent = remaining;
          if (remaining <= 0) {
            clearInterval(ticker);
            go();
          }
        }, 1000);
      }


      // handle submit
      form.addEventListener('submit', function(e) {
        e.preventDefault();
        if (!licenceVerified) {
          current = STEP_LICENSE;
          render();
          showAlert('Please verify your license to continue.');
          return;
        }
        if (!validate(STEP_DATABASE)) {
          current = STEP_DATABASE;
          render();
          return;
        }
        btnInstall.disabled = true;
        overlay.hidden = false;
        bar.classList.add('busy');
        setProgress(0);
        var data = new FormData(form);
        data.append('submit', '1');
        var finalized = false;
        var rawText = '';
        var httpError = '';
        /* handle event */
        function handleEvent(msg) {
          if (!msg) return;
          if (typeof msg.progress === 'number') setProgress(msg.progress);
          if (msg.success === true) {
            finalized = true;
            markAllDone();
            setTimeout(function() {
              showCongrats(msg.redirect || './');
            }, 600);
          } else if (msg.success === false) {
            finalized = true;
            failUI(msg.message || 'The installation could not be completed.');
          }
        }
        /* handle line */
        function handleLine(line) {
          rawText += line + '\n';
          line = line.trim();
          if (!line) return;
          var msg = parseJSON(line);
          if (!msg && line.indexOf('{') !== -1) {
            msg = parseJSON(line.slice(line.indexOf('{'), line.lastIndexOf('}') + 1));
          }
          if (msg) handleEvent(msg);
        }
        /* safe JSON.parse */
        function parseJSON(str) {
          try {
            return JSON.parse(str);
          } catch (err) {
            return null;
          }
        }
        /* get server message */
        function serverMessage(fallback) {
          var text = rawText;
          var m = text.match(/"message"\s*:\s*"((?:[^"\\]|\\.)*)"/);
          if (m) {
            try {
              return JSON.parse('"' + m[1] + '"');
            } catch (e) {
              return m[1];
            }
          }
          var clean = text.replace(/<[^>]*>/g, ' ').replace(/\s+/g, ' ').trim();
          if (clean) return clean.length > 500 ? clean.slice(0, 500) + '…' : clean;
          return fallback;
        }
        fetch(window.location.href, {
            method: 'POST',
            headers: {
              'X-Requested-With': 'XMLHttpRequest'
            },
            body: data
          })
          .then(function(res) {
            if (!res.ok) {
              httpError = 'The server responded with an error (HTTP ' + res.status + ' ' + res.statusText + ').';
            }
            if (!res.body || !res.body.getReader) {
              return res.text().then(function(text) {
                text.split('\n').forEach(handleLine);
              });
            }
            var reader = res.body.getReader();
            var decoder = new TextDecoder();
            var buf = '';
            return (function pump() {
              return reader.read().then(function(r) {
                if (r.done) {
                  if (buf) handleLine(buf);
                  return;
                }
                buf += decoder.decode(r.value, {
                  stream: true
                });
                var lines = buf.split('\n');
                buf = lines.pop();
                lines.forEach(handleLine);
                return pump();
              });
            })();
          })
          .then(function() {
            if (!finalized) failUI(serverMessage(httpError || 'The installation ended unexpectedly. Please try again.'));
          })
          .catch(function() {
            if (!finalized) failUI(serverMessage('A network error occurred. Please check your connection and try again.'));
          });
      });
      render();
    })();
  </script>
</body>

</html>