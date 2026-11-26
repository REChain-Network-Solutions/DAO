<?php

/**
 * update wizard
 * 
 * @package Sngine
 * @author Zamblek
 */

// set execution time
set_time_limit(0); /* unlimited max execution time */
ignore_user_abort(true); /* keep running if the browser disconnects */


// set ABSPATH
define('ABSPATH', __DIR__ . '/');


// get system version & exceptions
define('SYS_UPDATE_VER', '5.0');
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
  error_reporting(E_ALL & ~E_NOTICE & ~E_DEPRECATED);
} else {
  ini_set("display_errors", false);
  error_reporting(0);
}


// get functions
require_once(ABSPATH . 'includes/functions.php');


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


// update functions
/**
 * update_query
 *
 * @param string $query
 * @param string $context
 * @return mysqli_result|boolean
 */
function update_query($query, $context)
{
  global $db, $update_errors;
  $result = $db->query($query);
  if ($result === false) {
    $update_errors[] = "Couldn't finish while " . $context . " (" . mb_scrub(trim($db->error), 'UTF-8') . ")";
  }
  return $result;
}


/**
 * update_structure
 *
 * @param string $structure
 * @param int $progress_from
 * @param int $progress_to
 * @return void
 */
function update_structure($structure, $progress_from, $progress_to)
{
  $structure = preg_replace('/^\s*#.*$/m', '', $structure);
  $statements = [];
  foreach (preg_split('/;\s*(?:\r?\n|$)/', $structure) as $statement) {
    $statement = trim($statement);
    if ($statement === '' || preg_match('/^(START TRANSACTION|COMMIT)$/i', $statement)) {
      continue;
    }
    $statements[] = $statement;
  }
  foreach ($statements as $i => $statement) {
    stream_progress($progress_from + intdiv(($progress_to - $progress_from) * $i, count($statements)));
    if (preg_match('/^CREATE TABLE\s+(?:IF NOT EXISTS\s+)?`([^`]+)`/i', $statement, $matches)) {
      update_query(preg_replace('/^CREATE TABLE\s+(?:IF NOT EXISTS\s+)?/i', 'CREATE TABLE IF NOT EXISTS ', $statement), "creating the " . $matches[1] . " table");
    } elseif (preg_match('/^DROP TABLE\s+(?:IF EXISTS\s+)?`([^`]+)`/i', $statement, $matches)) {
      update_query(preg_replace('/^DROP TABLE\s+(?:IF EXISTS\s+)?/i', 'DROP TABLE IF EXISTS ', $statement), "removing the " . $matches[1] . " table");
    } elseif (preg_match('/^ALTER TABLE\s+`([^`]+)`\s+(.+)$/is', $statement, $matches)) {
      update_alter_table($matches[1], $matches[2]);
    } else {
      update_query($statement, "updating your database tables");
    }
  }
}


/**
 * update_alter_table
 *
 * @param string $table
 * @param string $clauses
 * @return boolean
 */
function update_alter_table($table, $clauses)
{
  global $db;
  $context = "updating the " . $table . " table";
  /* get current columns & indexes */
  $columns = [];
  $get_columns = update_query(sprintf("SHOW COLUMNS FROM `%s`", $table), $context);
  if (!$get_columns) {
    return false;
  }
  while ($column = $get_columns->fetch_assoc()) {
    $columns[strtolower($column['Field'])] = true;
  }
  $indexes = [];
  $get_indexes = update_query(sprintf("SHOW INDEX FROM `%s`", $table), $context);
  if (!$get_indexes) {
    return false;
  }
  while ($index = $get_indexes->fetch_assoc()) {
    $indexes[strtolower($index['Key_name'])] = true;
  }
  /* skip what is already applied */
  $pending = [];
  foreach (preg_split('/,\s*\r?\n/', trim($clauses)) as $clause) {
    $clause = trim($clause);
    if ($clause === '') {
      continue;
    }
    if (preg_match('/^ADD\s+(?:UNIQUE\s+|FULLTEXT\s+|SPATIAL\s+)?(?:INDEX|KEY)\s+`([^`]+)`/i', $clause, $matches)) {
      $name = strtolower($matches[1]);
      if (isset($indexes[$name])) {
        continue;
      }
      $indexes[$name] = true;
    } elseif (preg_match('/^ADD\s+PRIMARY\s+KEY/i', $clause)) {
      if (isset($indexes['primary'])) {
        continue;
      }
      $indexes['primary'] = true;
    } elseif (preg_match('/^DROP\s+(?:INDEX|KEY)\s+`([^`]+)`/i', $clause, $matches)) {
      $name = strtolower($matches[1]);
      if (!isset($indexes[$name])) {
        continue;
      }
      unset($indexes[$name]);
    } elseif (preg_match('/^DROP\s+PRIMARY\s+KEY/i', $clause)) {
      if (!isset($indexes['primary'])) {
        continue;
      }
      unset($indexes['primary']);
    } elseif (preg_match('/^ADD\s+(?:COLUMN\s+)?`([^`]+)`/i', $clause, $matches)) {
      $name = strtolower($matches[1]);
      if (isset($columns[$name])) {
        continue;
      }
      $columns[$name] = true;
    } elseif (preg_match('/^MODIFY\s+(?:COLUMN\s+)?`([^`]+)`/i', $clause, $matches)) {
      if (!isset($columns[strtolower($matches[1])])) {
        continue;
      }
    } elseif (preg_match('/^CHANGE\s+(?:COLUMN\s+)?`([^`]+)`\s+`([^`]+)`/i', $clause, $matches)) {
      $old_name = strtolower($matches[1]);
      if (!isset($columns[$old_name])) {
        continue;
      }
      unset($columns[$old_name]);
      $columns[strtolower($matches[2])] = true;
    } elseif (preg_match('/^DROP\s+(?:COLUMN\s+)?`([^`]+)`/i', $clause, $matches)) {
      $name = strtolower($matches[1]);
      if (!isset($columns[$name])) {
        continue;
      }
      unset($columns[$name]);
    }
    $pending[] = $clause;
  }
  if (!$pending) {
    return true;
  }
  /* apply all changes at once, or one by one if that fails */
  if ($db->query(sprintf("ALTER TABLE `%s` %s", $table, implode(", ", $pending))) !== false) {
    return true;
  }
  $applied = true;
  foreach ($pending as $clause) {
    if (!update_query(sprintf("ALTER TABLE `%s` %s", $table, $clause), $context)) {
      $applied = false;
    }
  }
  return $applied;
}


// verify licence (wizard step, before update)
if (isset($_POST['verify_licence'])) {
  header('Content-Type: application/json; charset=utf-8');
  header('Cache-Control: no-cache');
  try {
    if (is_empty($_POST['purchase_code'] ?? '')) {
      echo json_encode(['success' => false, 'message' => 'Please enter a valid purchase code']);
      exit;
    }
    $licence = get_licence_key($_POST['purchase_code'], 'update', SYS_UPDATE_VER);
    echo json_encode([
      'success' => true,
      'monetization' => !empty($licence['entitlements']['monetization']),
    ]);
  } catch (Exception $e) {
    echo json_encode(['success' => false, 'message' => $e->getMessage()]);
  }
  exit;
}


// update
if (isset($_POST['submit'])) {

  // check system requirements errors
  if ($requirements_errors) {
    stream_fail("You need to check the system requirements to continue, Back to your hosting support for help.");
  }


  // open the streaming response
  stream_start();


  // step 1: verifying purchase code
  stream_progress(6, 'Verifying purchase code');
  try {
    if (is_empty($_POST['purchase_code'])) {
      stream_fail("Please enter a valid purchase code");
    }
    $licence = get_licence_key($_POST['purchase_code'], 'update', SYS_UPDATE_VER);
    $licence_key = $_POST['purchase_code'];
  } catch (Exception $e) {
    stream_fail($e->getMessage());
  }


  // step 2: connecting to the database
  stream_progress(22, 'Connecting to the database');
  try {
    $db = init_db_connection();
  } catch (Exception $e) {
    stream_fail("Error establishing a database connection. Please try again.");
  }
  if (!check_db_version($db)) {
    stream_fail("Your database server is not supported. Sngine requires MySQL 8.0+ or MariaDB 10.6+, Back to your hosting support for help.");
  }


  // step 3: updating the database tables
  $update_errors = [];
  $structure = "

    START TRANSACTION;

    CREATE TABLE `iyzico_payments` (
      `payment_id` int unsigned NOT NULL AUTO_INCREMENT,
      `payment_status` enum('pending','paid','failed') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'pending',
      `user_id` int unsigned NOT NULL,
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
      `updated_at` datetime DEFAULT NULL,
      PRIMARY KEY (`payment_id`),
      UNIQUE KEY `iyzico_conversation_id` (`iyzico_conversation_id`),
      KEY `iyzico_token` (`iyzico_token`(191)),
      KEY `user_id` (`user_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    CREATE TABLE `posts_live_categories` (
      `category_id` int unsigned NOT NULL AUTO_INCREMENT,
      `category_parent_id` int unsigned NOT NULL,
      `category_name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `category_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `category_order` int unsigned NOT NULL DEFAULT '1',
      PRIMARY KEY (`category_id`),
      KEY `category_parent_id` (`category_parent_id`)
    ) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    CREATE TABLE `live_restrictions` (
      `host_type` enum('user','page') COLLATE utf8mb4_general_ci NOT NULL,
      `host_id` int unsigned NOT NULL,
      `user_id` int unsigned NOT NULL,
      `type` enum('timeout','mute','kick','ban') COLLATE utf8mb4_general_ci NOT NULL,
      `post_id` int unsigned NOT NULL,
      `expires_at` datetime DEFAULT NULL,
      `moderator_id` int unsigned NOT NULL,
      `time` datetime NOT NULL,
      PRIMARY KEY (`host_type`,`host_id`,`user_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    CREATE TABLE `funding_categories` (
      `category_id` int unsigned NOT NULL AUTO_INCREMENT,
      `category_parent_id` int unsigned NOT NULL,
      `category_name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `category_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `category_order` int unsigned NOT NULL DEFAULT '1',
      PRIMARY KEY (`category_id`) USING BTREE,
      KEY `category_parent_id` (`category_parent_id`)
    ) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    CREATE TABLE `sitemaps` (
      `sitemap_type` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
      `sitemap_part` int unsigned NOT NULL,
      `urls` int unsigned NOT NULL DEFAULT '0',
      `last_id` int unsigned NOT NULL DEFAULT '0',
      `notified_id` int unsigned NOT NULL DEFAULT '0',
      `last_modified` datetime DEFAULT NULL,
      `generated_at` datetime NOT NULL,
      PRIMARY KEY (`sitemap_type`,`sitemap_part`),
      KEY `generated_at` (`generated_at`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    CREATE TABLE `live_moderation_log` (
      `log_id` int unsigned NOT NULL AUTO_INCREMENT,
      `host_type` enum('user','page') COLLATE utf8mb4_general_ci NOT NULL,
      `host_id` int unsigned NOT NULL,
      `post_id` int unsigned NOT NULL,
      `moderator_id` int unsigned NOT NULL,
      `user_id` int unsigned NOT NULL,
      `action` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
      `details` varchar(256) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
      `time` datetime NOT NULL,
      PRIMARY KEY (`log_id`),
      KEY `host` (`host_type`,`host_id`,`log_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    CREATE TABLE `dating_matches` (
      `match_id` int unsigned NOT NULL AUTO_INCREMENT,
      `user_one_id` int unsigned NOT NULL,
      `user_two_id` int unsigned NOT NULL,
      `status` enum('active','unmatched') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'active',
      `unmatched_by` int unsigned DEFAULT NULL,
      `time` datetime NOT NULL,
      PRIMARY KEY (`match_id`),
      UNIQUE KEY `user_one_id_user_two_id` (`user_one_id`,`user_two_id`),
      KEY `user_one_id_status` (`user_one_id`,`status`,`match_id`),
      KEY `user_two_id_status` (`user_two_id`,`status`,`match_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    CREATE TABLE `stories_highlights_items` (
      `id` int unsigned NOT NULL AUTO_INCREMENT,
      `highlight_id` int unsigned NOT NULL,
      `story_id` int unsigned NOT NULL,
      PRIMARY KEY (`id`),
      UNIQUE KEY `highlight_id_story_id` (`highlight_id`,`story_id`),
      KEY `story_id` (`story_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    CREATE TABLE `users_shortcuts` (
      `id` int unsigned NOT NULL AUTO_INCREMENT,
      `user_id` int unsigned NOT NULL,
      `node_id` int unsigned NOT NULL,
      `node_type` enum('page','group','event','game') COLLATE utf8mb4_general_ci NOT NULL,
      `state` enum('pinned','auto','hidden') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'auto',
      `time` datetime NOT NULL,
      PRIMARY KEY (`id`),
      UNIQUE KEY `user_id_node_type_node_id` (`user_id`,`node_type`,`node_id`),
      KEY `user_id_state_time` (`user_id`,`state`,`time` DESC,`id` DESC),
      KEY `node_type_node_id` (`node_type`,`node_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    CREATE TABLE `system_theme_landings` (
      `landing_id` int unsigned NOT NULL AUTO_INCREMENT,
      `theme_id` int unsigned NOT NULL,
      `slug` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `title` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `is_default` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      PRIMARY KEY (`landing_id`),
      UNIQUE KEY `theme_slug` (`theme_id`,`slug`)
    ) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    CREATE TABLE `plisio_payments` (
      `payment_id` int unsigned NOT NULL AUTO_INCREMENT,
      `payment_status` enum('pending','paid','failed') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'pending',
      `user_id` int unsigned NOT NULL,
      `handle` varchar(64) COLLATE utf8mb4_general_ci NOT NULL,
      `reference_id` varchar(256) COLLATE utf8mb4_general_ci DEFAULT NULL,
      `amount` float NOT NULL,
      `total_amount` float NOT NULL,
      `currency` varchar(8) COLLATE utf8mb4_general_ci NOT NULL,
      `plisio_hash` varchar(128) COLLATE utf8mb4_general_ci NOT NULL,
      `plisio_txn_id` varchar(128) COLLATE utf8mb4_general_ci NOT NULL,
      `created_at` datetime NOT NULL,
      `updated_at` datetime DEFAULT NULL,
      PRIMARY KEY (`payment_id`),
      UNIQUE KEY `plisio_txn_id` (`plisio_txn_id`),
      KEY `plisio_hash` (`plisio_hash`),
      KEY `user_id` (`user_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    CREATE TABLE `dating_interests` (
      `interest_id` int unsigned NOT NULL AUTO_INCREMENT,
      `title` varchar(64) COLLATE utf8mb4_general_ci NOT NULL,
      `icon` varchar(32) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
      `interest_order` int unsigned NOT NULL DEFAULT '1',
      PRIMARY KEY (`interest_id`)
    ) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    CREATE TABLE `live_moderation_settings` (
      `host_type` enum('user','page') COLLATE utf8mb4_general_ci NOT NULL,
      `host_id` int unsigned NOT NULL,
      `slow_mode` smallint unsigned NOT NULL DEFAULT '0',
      `blocked_words` text COLLATE utf8mb4_general_ci,
      `links_blocked` enum('0','1') COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `repeats_blocked` enum('0','1') COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `rules` text COLLATE utf8mb4_general_ci,
      PRIMARY KEY (`host_type`,`host_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    CREATE TABLE `stories_audience` (
      `id` int unsigned NOT NULL AUTO_INCREMENT,
      `user_id` int unsigned NOT NULL,
      `target_id` int unsigned NOT NULL,
      `type` enum('close','hidden') COLLATE utf8mb4_general_ci NOT NULL,
      PRIMARY KEY (`id`),
      UNIQUE KEY `user_id_target_id_type` (`user_id`,`target_id`,`type`),
      KEY `target_id_type` (`target_id`,`type`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    CREATE TABLE `posts_locations` (
      `post_id` int unsigned NOT NULL,
      `post_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `location` point NOT NULL /*!80003 SRID 0 */,
      PRIMARY KEY (`post_id`),
      SPATIAL KEY `location` (`location`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    CREATE TABLE `dating_purchases` (
      `purchase_id` int unsigned NOT NULL AUTO_INCREMENT,
      `user_id` int unsigned NOT NULL,
      `item` enum('super_likes','boost','priority_message') COLLATE utf8mb4_general_ci NOT NULL,
      `quantity` int unsigned NOT NULL DEFAULT '1',
      `amount` float NOT NULL DEFAULT '0',
      `time` datetime NOT NULL,
      PRIMARY KEY (`purchase_id`),
      KEY `user_id` (`user_id`,`purchase_id`),
      KEY `time` (`time`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    CREATE TABLE `forums_likes` (
      `id` int unsigned NOT NULL AUTO_INCREMENT,
      `user_id` int unsigned NOT NULL,
      `node_id` int unsigned NOT NULL,
      `node_type` enum('thread','reply') COLLATE utf8mb4_general_ci NOT NULL,
      `time` datetime NOT NULL,
      PRIMARY KEY (`id`),
      UNIQUE KEY `user_id_node_id_node_type` (`user_id`,`node_id`,`node_type`),
      KEY `node_id_node_type` (`node_id`,`node_type`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    CREATE TABLE `posts_search` (
      `post_id` int unsigned NOT NULL,
      `search_text` mediumtext COLLATE utf8mb4_general_ci NOT NULL,
      `search_body` mediumtext COLLATE utf8mb4_general_ci NOT NULL,
      PRIMARY KEY (`post_id`),
      FULLTEXT KEY `ft_text` (`search_text`),
      FULLTEXT KEY `ft_all` (`search_text`,`search_body`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    CREATE TABLE `dating_locations` (
      `user_id` int unsigned NOT NULL,
      `location` point NOT NULL /*!80003 SRID 0 */,
      PRIMARY KEY (`user_id`),
      SPATIAL KEY `location` (`location`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    CREATE TABLE `users_locations` (
      `user_id` int unsigned NOT NULL,
      `location` point NOT NULL /*!80003 SRID 0 */,
      PRIMARY KEY (`user_id`),
      SPATIAL KEY `location` (`location`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    CREATE TABLE `pages_conversations` (
      `id` int unsigned NOT NULL AUTO_INCREMENT,
      `page_id` int unsigned NOT NULL,
      `conversation_id` int unsigned NOT NULL,
      `user_id` int unsigned NOT NULL,
      `seen` enum('0','1') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0',
      `typing` enum('0','1') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0',
      PRIMARY KEY (`id`),
      UNIQUE KEY `page_user` (`page_id`,`user_id`),
      UNIQUE KEY `conversation_id` (`conversation_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

    CREATE TABLE `dating_photos` (
      `photo_id` int unsigned NOT NULL AUTO_INCREMENT,
      `user_id` int unsigned NOT NULL,
      `source` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
      `status` enum('pending','approved') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'approved',
      `photo_order` tinyint unsigned NOT NULL DEFAULT '0',
      `time` datetime NOT NULL,
      PRIMARY KEY (`photo_id`),
      KEY `user_id_status_photo_order` (`user_id`,`status`,`photo_order`),
      KEY `status_photo_id` (`status`,`photo_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    CREATE TABLE `users_login_countries` (
      `user_id` int unsigned NOT NULL,
      `country_code` varchar(2) COLLATE utf8mb4_general_ci NOT NULL,
      `time` datetime NOT NULL,
      PRIMARY KEY (`user_id`,`country_code`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    CREATE TABLE `stories_reactions` (
      `id` int unsigned NOT NULL AUTO_INCREMENT,
      `story_id` int unsigned NOT NULL,
      `user_id` int unsigned NOT NULL,
      `reaction` varchar(32) COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'like',
      `time` datetime NOT NULL,
      PRIMARY KEY (`id`),
      UNIQUE KEY `story_id_user_id` (`story_id`,`user_id`),
      KEY `user_id` (`user_id`,`story_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    CREATE TABLE `stories_polls_votes` (
      `id` int unsigned NOT NULL AUTO_INCREMENT,
      `story_id` int unsigned NOT NULL,
      `user_id` int unsigned NOT NULL,
      `option` tinyint unsigned NOT NULL,
      `time` datetime NOT NULL,
      PRIMARY KEY (`id`),
      UNIQUE KEY `story_id_user_id` (`story_id`,`user_id`),
      KEY `user_id` (`user_id`,`story_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    CREATE TABLE `live_moderators` (
      `host_type` enum('user','page') COLLATE utf8mb4_general_ci NOT NULL,
      `host_id` int unsigned NOT NULL,
      `user_id` int unsigned NOT NULL,
      `time` datetime NOT NULL,
      PRIMARY KEY (`host_type`,`host_id`,`user_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    CREATE TABLE `dating_profiles` (
      `user_id` int unsigned NOT NULL,
      `status` enum('active','paused','suspended') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'active',
      `gender` int unsigned NOT NULL,
      `birthdate` date NOT NULL,
      `show_genders` varchar(64) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
      `min_age` tinyint unsigned NOT NULL DEFAULT '18',
      `max_age` tinyint unsigned NOT NULL DEFAULT '99',
      `max_distance` smallint unsigned NOT NULL DEFAULT '100',
      `bio` text COLLATE utf8mb4_general_ci,
      `country_id` int unsigned NOT NULL DEFAULT '0',
      `city` varchar(128) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
      `city_key` varchar(160) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
      `latitude` decimal(10,7) DEFAULT NULL,
      `longitude` decimal(10,7) DEFAULT NULL,
      `hide_from_friends` enum('0','1') COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `incognito` enum('0','1') COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `hide_age` enum('0','1') COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `hide_distance` enum('0','1') COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `boosted_until` datetime DEFAULT NULL,
      `super_likes_balance` int unsigned NOT NULL DEFAULT '0',
      `super_likes_included` int unsigned NOT NULL DEFAULT '0',
      `boosts_included` int unsigned NOT NULL DEFAULT '0',
      `included_period` char(7) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
      `time` datetime NOT NULL,
      PRIMARY KEY (`user_id`),
      KEY `status_gender_user_id` (`status`,`gender`,`user_id`),
      KEY `status_gender_country_id` (`status`,`gender`,`country_id`,`user_id`),
      KEY `status_gender_city_key` (`status`,`gender`,`city_key`,`user_id`),
      KEY `status_boosted_until` (`status`,`boosted_until`),
      KEY `status_time` (`status`,`time`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    CREATE TABLE `stories_highlights` (
      `highlight_id` int unsigned NOT NULL AUTO_INCREMENT,
      `user_id` int unsigned NOT NULL,
      `title` varchar(128) COLLATE utf8mb4_general_ci NOT NULL,
      `cover_story_id` int unsigned DEFAULT NULL,
      `time` datetime NOT NULL,
      PRIMARY KEY (`highlight_id`),
      KEY `user_id` (`user_id`,`highlight_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    CREATE TABLE `stories_views` (
      `view_id` int unsigned NOT NULL AUTO_INCREMENT,
      `story_id` int unsigned NOT NULL,
      `user_id` int unsigned NOT NULL,
      `time` datetime NOT NULL,
      PRIMARY KEY (`view_id`),
      UNIQUE KEY `story_id_user_id` (`story_id`,`user_id`),
      KEY `user_id` (`user_id`,`story_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    CREATE TABLE `translations_cache` (
      `translation_id` int unsigned NOT NULL AUTO_INCREMENT,
      `node_type` enum('post','page','group','event','message','user') COLLATE utf8mb4_general_ci NOT NULL,
      `node_id` int unsigned NOT NULL,
      `node_field` enum('text','title','description') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `target_lang` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `source_hash` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `source_lang` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `translated_text` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
      `created_at` datetime NOT NULL,
      PRIMARY KEY (`translation_id`),
      UNIQUE KEY `node_lang` (`node_type`,`node_id`,`node_field`,`target_lang`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    CREATE TABLE `dating_swipes` (
      `swipe_id` bigint unsigned NOT NULL AUTO_INCREMENT,
      `user_id` int unsigned NOT NULL,
      `target_id` int unsigned NOT NULL,
      `action` enum('pass','like','super') COLLATE utf8mb4_general_ci NOT NULL,
      `pending` enum('0','1') COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
      `message` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
      `time` datetime NOT NULL,
      PRIMARY KEY (`swipe_id`),
      UNIQUE KEY `user_id_target_id` (`user_id`,`target_id`),
      KEY `user_id_time` (`user_id`,`time`),
      KEY `target_id_pending_swipe_id` (`target_id`,`pending`,`swipe_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    CREATE TABLE `dating_profiles_interests` (
      `user_id` int unsigned NOT NULL,
      `interest_id` int unsigned NOT NULL,
      PRIMARY KEY (`user_id`,`interest_id`),
      KEY `interest_id_user_id` (`interest_id`,`user_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    CREATE TABLE `live_ingresses` (
      `user_id` int unsigned NOT NULL,
      `ingress_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `ingress_url` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `stream_key` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `ingress_room` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
      `time` datetime NOT NULL,
      PRIMARY KEY (`user_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    CREATE TABLE `stories_music` (
      `music_id` int unsigned NOT NULL AUTO_INCREMENT,
      `provider` enum('library','itunes') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'library',
      `provider_id` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL,
      `title` varchar(256) COLLATE utf8mb4_general_ci NOT NULL,
      `artist` varchar(256) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
      `cover` varchar(512) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
      `source` varchar(512) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
      `url` varchar(512) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
      `uses` int unsigned NOT NULL DEFAULT '0',
      `enabled` enum('0','1') COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1',
      `time` datetime NOT NULL,
      `updated_at` datetime NOT NULL,
      PRIMARY KEY (`music_id`),
      UNIQUE KEY `provider_provider_id` (`provider`,`provider_id`),
      KEY `enabled_uses` (`enabled`,`uses`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    DROP TABLE `emojis`;

    DROP TABLE `log_sessions`;

    DROP TABLE `stories_media`;

    # Changing table forums_threads fields, indexes
    ALTER TABLE `forums_threads`
      ADD COLUMN `likes` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '' AFTER `views`,
      MODIFY COLUMN `time` DATETIME NOT NULL COMMENT '' AFTER `likes`,
      ADD COLUMN `last_reply_user_id` INT UNSIGNED NULL DEFAULT NULL COMMENT '' AFTER `last_reply`,
      ADD COLUMN `is_pinned` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '' AFTER `last_reply_user_id`,
      ADD COLUMN `is_locked` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '' AFTER `is_pinned`,
      ADD INDEX `latest` USING BTREE (is_pinned, last_reply),
      ADD INDEX `replies` USING BTREE (replies),
      ADD INDEX `forum_last_reply` USING BTREE (forum_id, last_reply),
      ADD INDEX `forum_replies` USING BTREE (forum_id, replies),
      ADD INDEX `forum_latest` USING BTREE (forum_id, is_pinned, last_reply);

    # Changing table conversations_calls fields
    ALTER TABLE `conversations_calls`
      ADD COLUMN `answered_time` DATETIME NULL DEFAULT NULL COMMENT '' AFTER `declined`,
      ADD COLUMN `ended_time` DATETIME NULL DEFAULT NULL COMMENT '' AFTER `answered_time`,
      ADD COLUMN `ended_by` INT UNSIGNED NULL DEFAULT NULL COMMENT '' AFTER `ended_time`,
      MODIFY COLUMN `created_time` DATETIME NOT NULL COMMENT '' AFTER `ended_by`;

    # Changing table permissions_groups fields
    ALTER TABLE `permissions_groups`
      ADD COLUMN `comments_permission` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1' COMMENT '' AFTER `posts_permission`,
      MODIFY COLUMN `schedule_posts_permission` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '' AFTER `comments_permission`,
      ADD COLUMN `dating_permission` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1' COMMENT '' AFTER `points_per_currency`;

    # Changing table pages_likes indexes
    ALTER TABLE `pages_likes`
      ADD INDEX `user_id_page_id` USING BTREE (user_id, page_id);

    # Changing table forums_replies fields
    ALTER TABLE `forums_replies`
      ADD COLUMN `reply_to_id` INT UNSIGNED NULL DEFAULT NULL COMMENT '' AFTER `user_id`,
      MODIFY COLUMN `text` LONGTEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '' AFTER `reply_to_id`,
      ADD COLUMN `likes` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '' AFTER `text`,
      MODIFY COLUMN `time` DATETIME NOT NULL COMMENT '' AFTER `likes`;

    # Changing table posts_polls_options_users indexes
    ALTER TABLE `posts_polls_options_users`
      ADD INDEX `option_id_user_id` USING BTREE (option_id, user_id);

    # Changing table conversations_users indexes
    ALTER TABLE `conversations_users`
      ADD INDEX `user_id_conversation_id` USING BTREE (user_id, conversation_id);

    # Changing table groups_members indexes
    ALTER TABLE `groups_members`
      ADD INDEX `user_id_group_id` USING BTREE (user_id, group_id);

    # Changing table conversations_messages_media fields
    ALTER TABLE `conversations_messages_media`
      ADD COLUMN `name` VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '' AFTER `source`,
      ADD COLUMN `size` BIGINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '' AFTER `name`;

    # Changing table posts_funding fields
    ALTER TABLE `posts_funding`
      ADD COLUMN `category_id` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '' AFTER `cover_image`;

    # Changing table system_themes fields
    ALTER TABLE `system_themes`
      ADD COLUMN `title` VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '' AFTER `name`,
      MODIFY COLUMN `default` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '' AFTER `title`,
      ADD COLUMN `fluid_design` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '' AFTER `enabled`,
      ADD COLUMN `system_theme_night_on` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '' AFTER `fluid_design`,
      ADD COLUMN `system_theme_mode_select` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1' COMMENT '' AFTER `system_theme_night_on`,
      ADD COLUMN `system_theme_icons` ENUM('tabler','svg') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'tabler' COMMENT '' AFTER `system_theme_mode_select`,
      ADD COLUMN `system_theme_fonts` VARCHAR(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'google' COMMENT '' AFTER `system_theme_icons`,
      ADD COLUMN `system_wallpaper_default` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1' COMMENT '' AFTER `system_theme_fonts`,
      ADD COLUMN `system_wallpaper` VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '' AFTER `system_wallpaper_default`,
      ADD COLUMN `css_customized` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '' AFTER `system_wallpaper`,
      ADD COLUMN `css_background` VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '' AFTER `css_customized`,
      ADD COLUMN `css_link_color` VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '' AFTER `css_background`,
      ADD COLUMN `css_header` VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '' AFTER `css_link_color`,
      ADD COLUMN `css_header_search` VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '' AFTER `css_header`,
      ADD COLUMN `css_header_search_color` VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '' AFTER `css_header_search`,
      ADD COLUMN `css_btn_primary` VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '' AFTER `css_header_search_color`,
      ADD COLUMN `css_header_icons` VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '' AFTER `css_btn_primary`,
      ADD COLUMN `css_header_icons_night` VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '' AFTER `css_header_icons`,
      ADD COLUMN `css_main_icons` VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '' AFTER `css_header_icons_night`,
      ADD COLUMN `css_main_icons_night` VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '' AFTER `css_main_icons`,
      ADD COLUMN `css_action_icons` VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '' AFTER `css_main_icons_night`,
      ADD COLUMN `css_action_icons_night` VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '' AFTER `css_action_icons`,
      ADD COLUMN `css_custome_css` TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '' AFTER `css_action_icons_night`,
      ADD COLUMN `landing` VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'default' COMMENT '' AFTER `css_custome_css`,
      ADD COLUMN `bottom_bar` VARCHAR(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '' AFTER `landing`,
      ADD COLUMN `sidebar` VARCHAR(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '' AFTER `bottom_bar`,
      ADD COLUMN `sidebar_more` VARCHAR(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '' AFTER `sidebar`;

    # Changing table pages fields
    ALTER TABLE `pages`
      ADD COLUMN `page_messages_enabled` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '' AFTER `page_tips_enabled`,
      MODIFY COLUMN `page_boosted` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '' AFTER `page_messages_enabled`,
      ADD COLUMN `page_latitude` DECIMAL(10, 7) NULL DEFAULT NULL COMMENT '' AFTER `page_location`,
      ADD COLUMN `page_longitude` DECIMAL(10, 7) NULL DEFAULT NULL COMMENT '' AFTER `page_latitude`,
      MODIFY COLUMN `page_country` INT UNSIGNED NOT NULL COMMENT '' AFTER `page_longitude`;

    # Changing table ads_campaigns fields, indexes
    ALTER TABLE `ads_campaigns`
      ADD COLUMN `audience_age_min` TINYINT UNSIGNED NULL DEFAULT NULL COMMENT '' AFTER `audience_relationship`,
      ADD COLUMN `audience_age_max` TINYINT UNSIGNED NULL DEFAULT NULL COMMENT '' AFTER `audience_age_min`,
      MODIFY COLUMN `ads_title` VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '' AFTER `audience_age_max`,
      ADD INDEX `active_approved_placement` USING BTREE (campaign_is_active, campaign_is_approved, ads_placement);

    # Changing table posts fields, indexes
    ALTER TABLE `posts`
      ADD COLUMN `location_latitude` DECIMAL(10, 7) NULL DEFAULT NULL COMMENT '' AFTER `location`,
      ADD COLUMN `location_longitude` DECIMAL(10, 7) NULL DEFAULT NULL COMMENT '' AFTER `location_latitude`,
      MODIFY COLUMN `privacy` VARCHAR(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '' AFTER `location_longitude`,
      ADD COLUMN `photo_layout` VARCHAR(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'classic' COMMENT '' AFTER `post_longitude`,
      ADD INDEX `boosted_post_type` USING BTREE (boosted, post_type),
      ADD INDEX `origin_id_user_id` USING BTREE (origin_id, user_id),
      ADD INDEX `user_id_user_type_time` USING BTREE (user_id, user_type, `time`);

    # Changing table posts_photos_reactions indexes
    ALTER TABLE `posts_photos_reactions`
      ADD INDEX `photo_id_user_id` USING BTREE (photo_id, user_id);

    # Changing table groups_admins indexes
    ALTER TABLE `groups_admins`
      ADD INDEX `user_id` USING BTREE (user_id);

    # Changing table forums fields
    ALTER TABLE `forums`
      ADD COLUMN `forum_color` VARCHAR(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '' AFTER `forum_description`,
      ADD COLUMN `forum_icon` VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '' AFTER `forum_color`,
      MODIFY COLUMN `forum_order` INT UNSIGNED NOT NULL DEFAULT 1 COMMENT '' AFTER `forum_icon`;

    # Changing table posts_videos fields
    ALTER TABLE `posts_videos`
      ADD COLUMN `width` SMALLINT UNSIGNED NULL DEFAULT NULL COMMENT '' AFTER `thumbnail`,
      ADD COLUMN `height` SMALLINT UNSIGNED NULL DEFAULT NULL COMMENT '' AFTER `width`,
      MODIFY COLUMN `views` INT NOT NULL DEFAULT 0 COMMENT '' AFTER `height`;

    # Changing table pages_admins indexes
    ALTER TABLE `pages_admins`
      ADD INDEX `user_id` USING BTREE (user_id);

    # Changing table stories fields, indexes
    ALTER TABLE `stories`
      ADD COLUMN `origin_id` INT UNSIGNED NULL DEFAULT NULL COMMENT '' AFTER `user_id`,
      ADD COLUMN `type` ENUM('photo','video','text') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'photo' COMMENT '' AFTER `origin_id`,
      ADD COLUMN `source` VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '' AFTER `type`,
      ADD COLUMN `thumbnail` VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '' AFTER `source`,
      ADD COLUMN `background` VARCHAR(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '' AFTER `thumbnail`,
      ADD COLUMN `filter` VARCHAR(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '' AFTER `background`,
      ADD COLUMN `drawing` VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '' AFTER `filter`,
      ADD COLUMN `layers` MEDIUMTEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '' AFTER `drawing`,
      ADD COLUMN `duration` SMALLINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '' AFTER `layers`,
      ADD COLUMN `music_id` INT UNSIGNED NULL DEFAULT NULL COMMENT '' AFTER `duration`,
      ADD COLUMN `music_start` SMALLINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '' AFTER `music_id`,
      ADD COLUMN `privacy` ENUM('public','friends','close_friends') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'public' COMMENT '' AFTER `music_start`,
      MODIFY COLUMN `is_ads` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '' AFTER `privacy`,
      ADD COLUMN `highlighted` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '' AFTER `is_ads`,
      ADD COLUMN `views_count` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '' AFTER `highlighted`,
      ADD COLUMN `reactions_count` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '' AFTER `views_count`,
      ADD COLUMN `replies_count` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '' AFTER `reactions_count`,
      ADD COLUMN `poll_votes_1` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '' AFTER `replies_count`,
      ADD COLUMN `poll_votes_2` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '' AFTER `poll_votes_1`,
      MODIFY COLUMN `time` DATETIME NOT NULL COMMENT '' AFTER `poll_votes_2`,
      ADD COLUMN `expires_at` DATETIME NOT NULL DEFAULT '1970-01-01 00:00:00' COMMENT '' AFTER `time`,
      ADD INDEX `expires_at` USING BTREE (expires_at),
      ADD INDEX `origin_id` USING BTREE (origin_id),
      ADD INDEX `user_id_expires_at` USING BTREE (user_id, expires_at),
      ADD INDEX `is_ads_expires_at` USING BTREE (is_ads, expires_at),
      ADD INDEX `highlighted_expires_at` USING BTREE (highlighted, expires_at),
      DROP INDEX `user_id`;

    # Changing table conversations_messages fields, indexes
    ALTER TABLE `conversations_messages`
      ADD COLUMN `page_id` INT UNSIGNED NULL DEFAULT NULL COMMENT '' AFTER `user_id`,
      MODIFY COLUMN `message` LONGTEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '' AFTER `page_id`,
      ADD COLUMN `gif` VARCHAR(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '' AFTER `image`,
      MODIFY COLUMN `video` VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '' AFTER `gif`,
      ADD COLUMN `story_id` INT UNSIGNED NULL DEFAULT NULL COMMENT '' AFTER `product_post_id`,
      ADD COLUMN `reply_to` INT UNSIGNED NULL DEFAULT NULL COMMENT '' AFTER `story_id`,
      ADD COLUMN `call_id` INT UNSIGNED NULL DEFAULT NULL COMMENT '' AFTER `reply_to`,
      MODIFY COLUMN `reaction_like_count` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '' AFTER `call_id`,
      ADD INDEX `call_id` USING BTREE (call_id),
      ADD INDEX `page_id` USING BTREE (page_id);

    # Changing table users_sessions fields
    ALTER TABLE `users_sessions`
      ADD COLUMN `user_ip_country` VARCHAR(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '' AFTER `user_ip`,
      ADD COLUMN `user_ip_isp` VARCHAR(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '' AFTER `user_ip_country`,
      MODIFY COLUMN `user_browser` VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '' AFTER `user_ip_isp`;

    # Changing table events_members indexes
    ALTER TABLE `events_members`
      ADD INDEX `user_id_event_id` USING BTREE (user_id, event_id);

    # Changing table system_countries fields
    ALTER TABLE `system_countries`
      ADD COLUMN `country_flag` VARCHAR(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '' AFTER `country_code`,
      MODIFY COLUMN `country_name` VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '' AFTER `country_flag`;

    # Changing table events indexes
    ALTER TABLE `events`
      ADD INDEX `event_page_id` USING BTREE (event_page_id),
      ADD INDEX `event_boosted` USING BTREE (event_boosted),
      ADD INDEX `event_end_date` USING BTREE (event_end_date);

    # Changing table conversations fields
    ALTER TABLE `conversations`
      ADD COLUMN `pinned_message_id` INT UNSIGNED NULL DEFAULT NULL COMMENT '' AFTER `last_message_id`,
      MODIFY COLUMN `color` VARCHAR(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '' AFTER `pinned_message_id`,
      ADD COLUMN `name` VARCHAR(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '' AFTER `color`,
      MODIFY COLUMN `node_id` INT UNSIGNED NULL DEFAULT NULL COMMENT '' AFTER `name`;

    # Changing table posts_comments fields
    ALTER TABLE `posts_comments`
      ADD COLUMN `gif` VARCHAR(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '' AFTER `image`,
      MODIFY COLUMN `voice_note` VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '' AFTER `gif`;

    # Changing table posts_saved indexes
    ALTER TABLE `posts_saved`
      ADD INDEX `user_id_time` USING BTREE (user_id, `time`);

    # Changing table monetization_coupons_users indexes
    ALTER TABLE `monetization_coupons_users`
      ADD INDEX `coupon_id` USING BTREE (coupon_id);

    # Changing table posts_polls fields
    ALTER TABLE `posts_polls`
      ADD COLUMN `edit_locked` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '' AFTER `votes`;

    # Changing table posts_live fields, indexes
    ALTER TABLE `posts_live`
      ADD COLUMN `category_id` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '' AFTER `post_id`,
      ADD COLUMN `live_title` VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '' AFTER `category_id`,
      ADD COLUMN `broadcast_type` ENUM('camera','rtmp') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'camera' COMMENT '' AFTER `live_title`,
      ADD COLUMN `live_provider` VARCHAR(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'agora' COMMENT '' AFTER `broadcast_type`,
      MODIFY COLUMN `video_thumbnail` VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '' AFTER `live_provider`,
      ADD COLUMN `livekit_room` VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '' AFTER `agora_file`,
      ADD COLUMN `livekit_egress_id` VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '' AFTER `livekit_room`,
      ADD COLUMN `livekit_file` TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '' AFTER `livekit_egress_id`,
      MODIFY COLUMN `live_ended` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '' AFTER `livekit_file`,
      ADD COLUMN `livekit_ingress_id` VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '' AFTER `live_recorded`,
      ADD INDEX `category_id` USING BTREE (category_id),
      ADD INDEX `live_ended` USING BTREE (live_ended);

    # Changing table groups indexes
    ALTER TABLE `groups`
      ADD INDEX `group_boosted` USING BTREE (group_boosted);

    # Changing table posts_photos fields, indexes
    ALTER TABLE `posts_photos`
      ADD COLUMN `sort_order` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '' AFTER `comments`,
      ADD INDEX `post_photo_order` USING BTREE (post_id, sort_order, photo_id);

    # Changing table posts_files fields
    ALTER TABLE `posts_files`
      ADD COLUMN `name` VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '' AFTER `source`,
      ADD COLUMN `size` BIGINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '' AFTER `name`;

    # Changing table subscribers indexes
    ALTER TABLE `subscribers`
      ADD INDEX `node_id_node_type` USING BTREE (node_id, node_type);

    # Changing table packages fields
    ALTER TABLE `packages`
      ADD COLUMN `package_popular` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '' AFTER `package_hidden`,
      MODIFY COLUMN `verification_badge_enabled` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '' AFTER `package_popular`,
      ADD COLUMN `dating_unlimited_swipes_enabled` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '' AFTER `stripe_billing_plan`,
      ADD COLUMN `dating_likes_list_enabled` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '' AFTER `dating_unlimited_swipes_enabled`,
      ADD COLUMN `dating_rewind_enabled` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '' AFTER `dating_likes_list_enabled`,
      ADD COLUMN `dating_incognito_enabled` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '' AFTER `dating_rewind_enabled`,
      ADD COLUMN `dating_super_likes` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '' AFTER `dating_incognito_enabled`,
      ADD COLUMN `dating_boosts` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '' AFTER `dating_super_likes`;

    # Changing table posts_live_users fields
    ALTER TABLE `posts_live_users`
      ADD COLUMN `media_id` VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '' AFTER `post_id`;

    COMMIT;

	";
  stream_progress(40, 'Updating database tables');
  update_structure($structure, 40, 58);


  // step 4: applying new settings
  stream_progress(58, 'Applying new settings');
  /* insert new system options */
  update_query(
    "INSERT IGNORE INTO system_options (option_name, option_value) VALUES
      ('ads_budget_priority_enabled', '1'),
      ('agora_s3_endpoint', ''),
      ('agora_s3_public_url', ''),
      ('blogs_cover_required', '1'),
      ('blogs_rss_enabled', '1'),
      ('blogs_search_content_enabled', '1'),
      ('bunny_enabled', '0'),
      ('bunny_password', ''),
      ('bunny_region', ''),
      ('bunny_url', ''),
      ('bunny_zone', ''),
      ('chat_files_enabled', '1'),
      ('chat_max_media', '10'),
      ('comments_read_more_lines', '3'),
      ('cronjob_last_run', ''),
      ('cronjob_post_views_cleanup', '1'),
      ('dating_ads_frequency', '8'),
      ('dating_boost_minutes', '30'),
      ('dating_boost_price', '20'),
      ('dating_enabled', '0'),
      ('dating_free_likes_list', '0'),
      ('dating_free_swipes', '50'),
      ('dating_max_distance', '500'),
      ('dating_max_interests', '10'),
      ('dating_max_photos', '6'),
      ('dating_min_age', '18'),
      ('dating_photos_approval', '0'),
      ('dating_priority_message_price', '5'),
      ('dating_results', '12'),
      ('dating_super_likes_pack', '5'),
      ('dating_super_likes_price', '5'),
      ('dating_verified_only', '0'),
      ('deepl_key', ''),
      ('download_videos_disabled', '0'),
      ('forums_rss_enabled', '1'),
      ('geolocation_osm_url', 'https://photon.komoot.io'),
      ('geolocation_provider', 'google'),
      ('indexnow_enabled', '1'),
      ('indexnow_key', ''),
      ('infobip_api_key', ''),
      ('infobip_base_url', ''),
      ('infobip_sender', ''),
      ('ipinfo_enabled', '0'),
      ('ipinfo_token', ''),
      ('iyzico_api_key', ''),
      ('iyzico_enabled', '0'),
      ('iyzico_mode', 'sandbox'),
      ('iyzico_secret_key', ''),
      ('libretranslate_key', ''),
      ('libretranslate_url', ''),
      ('livekit_live_api_key', ''),
      ('livekit_live_api_secret', ''),
      ('livekit_live_ws_url', ''),
      ('live_chat_rules', 'Please respect the host and other viewers. No harassment, spam, threats, or inappropriate content. Violations may result in removal from the chat.'),
      ('live_moderation_enabled', '1'),
      ('live_provider', 'agora'),
      ('live_results', '12'),
      ('live_rtmp_enabled', '0'),
      ('llms_enabled', '1'),
      ('llms_notes', ''),
      ('login_alerts_enabled', '0'),
      ('mods_dating_permission', '0'),
      ('mods_stories_permission', '0'),
      ('module_names', ''),
      ('movies_results', '12'),
      ('ovh_bucket', ''),
      ('ovh_enabled', '0'),
      ('ovh_key', ''),
      ('ovh_region', ''),
      ('ovh_secret', ''),
      ('pages_messages_enabled', '1'),
      ('people_results', '12'),
      ('posts_edit_limit', '24'),
      ('posts_edit_limit_enabled', '0'),
      ('posts_read_more_lines', '5'),
      ('posts_search_cursor', '0'),
      ('posts_search_ready', '0'),
      ('posts_views_cleanup_error', ''),
      ('posts_views_cleanup_result', ''),
      ('posts_views_cleanup_time', ''),
      ('posts_views_days', '1'),
      ('posts_views_maintenance', 'idle'),
      ('posts_views_period', 'lifetime'),
      ('posts_views_schema_version', '1'),
      ('redis_database', '0'),
      ('redis_enabled', '0'),
      ('redis_host', '127.0.0.1'),
      ('redis_password', ''),
      ('redis_port', '6379'),
      ('redis_post_views_enabled', '1'),
      ('redis_prefix', ''),
      ('redis_relations_enabled', '1'),
      ('redis_sessions_enabled', '1'),
      ('redis_tls_enabled', '0'),
      ('redis_widgets_enabled', '1'),
      ('robots_txt', 'User-agent: *\r\nDisallow: /content/backups\r\nDisallow: /content/languages\r\nDisallow: /includes/libs\r\nDisallow: /install\r\nDisallow: /admincp\r\nDisallow: /modcp'),
      ('sitemap_enabled', '1'),
      ('sitemap_images_enabled', '1'),
      ('sitemap_refresh', '60'),
      ('sitemap_types', 'site,posts,blogs,products,jobs,offers,courses,funding,reels,users,pages,groups,events,forums,movies,games'),
      ('sitemap_urls_per_file', '10000'),
      ('sitemap_videos_enabled', '1'),
      ('stories_archive_enabled', '1'),
      ('stories_design', 'cards'),
      ('stories_highlights_enabled', '1'),
      ('stories_music_enabled', '1'),
      ('stories_music_itunes_country', 'US'),
      ('stories_music_itunes_enabled', '1'),
      ('stories_music_library_enabled', '1'),
      ('stories_polls_enabled', '1'),
      ('stories_reactions_enabled', '1'),
      ('stories_replies_enabled', '1'),
      ('stories_text_enabled', '1'),
      ('stories_video_max_duration', '60'),
      ('storj_bucket', ''),
      ('storj_enabled', '0'),
      ('storj_endpoint', ''),
      ('storj_key', ''),
      ('storj_secret', ''),
      ('storj_url', ''),
      ('system_description_live', 'Watch live streams and support your favorite creators'),
      ('themes_demo_enabled', '0'),
      ('translation_provider', 'google'),
      ('verification_page_passport_enabled', '1'),
      ('verification_page_passport_title', 'Company Tax File'),
      ('verification_page_photo_enabled', '1'),
      ('verification_page_photo_title', 'Company Incorporation File'),
      ('verification_user_passport_enabled', '1'),
      ('verification_user_passport_title', 'Passport or National ID'),
      ('verification_user_photo_enabled', '1'),
      ('verification_user_photo_title', 'Your Photo'),
      ('watch_results', '12'),
      ('watermark_videos_x', '50'),
      ('watermark_videos_y', '50'),
      ('watermark_x', '95'),
      ('watermark_y', '95')",
    "adding the new system settings"
  );
  /* set dating prices */
  update_query("UPDATE `system_options` SET `option_value` = '5' WHERE `option_name` = 'dating_super_likes_price' AND `option_value` IN ('', '0')", "setting dating prices");
  update_query("UPDATE `system_options` SET `option_value` = '20' WHERE `option_name` = 'dating_boost_price' AND `option_value` IN ('', '0')", "setting dating prices");
  update_query("UPDATE `system_options` SET `option_value` = '5' WHERE `option_name` = 'dating_priority_message_price' AND `option_value` IN ('', '0')", "setting dating prices");
  /* add live stream categories */
  $check_live_categories = update_query("SELECT COUNT(*) FROM `posts_live_categories`", "adding live stream categories");
  if ($check_live_categories && (int) $check_live_categories->fetch_row()[0] === 0) {
    update_query(
      "INSERT INTO `posts_live_categories` (`category_id`, `category_parent_id`, `category_name`, `category_description`, `category_order`) VALUES
        (1, 0, 'Social &amp; Talk', 'Conversations, Q&amp;A, hanging out, discussions', 1),
        (2, 0, 'Gaming', 'Gameplay, esports, game discussions', 2),
        (3, 0, 'Music', 'Performances, DJ sets, singing, instruments', 3),
        (4, 0, 'Sports', 'Matches, commentary, workouts, sports discussions', 4),
        (5, 0, 'Entertainment', 'Shows, performances, reactions, events', 5),
        (6, 0, 'Creative', 'Art, design, photography, crafts, making things', 6),
        (7, 0, 'Learning', 'Tutorials, classes, coding, educational streams', 7),
        (8, 0, 'Lifestyle', 'Cooking, travel, fitness, beauty, daily life', 8),
        (9, 0, 'News &amp; Events', 'Conferences, announcements, public events', 9),
        (10, 0, 'Other', 'Anything that doesn''t fit elsewhere', 10)",
      "adding live stream categories"
    );
  }
  update_query("UPDATE `posts_live` SET `category_id` = (SELECT MIN(`category_id`) FROM `posts_live_categories` WHERE `category_parent_id` = 0) WHERE `category_id` = 0 AND (SELECT COUNT(*) FROM `posts_live_categories` WHERE `category_parent_id` = 0) > 0", "updating live stream categories");
  /* add funding categories */
  $check_funding_categories = update_query("SELECT COUNT(*) FROM `funding_categories`", "adding funding categories");
  if ($check_funding_categories && (int) $check_funding_categories->fetch_row()[0] === 0) {
    update_query(
      "INSERT INTO `funding_categories` (`category_id`, `category_parent_id`, `category_name`, `category_description`, `category_order`) VALUES
        (1, 0, 'Medical', '', 1),
        (2, 0, 'Education', '', 2),
        (3, 0, 'Community', '', 3),
        (4, 0, 'Animals', '', 4),
        (5, 0, 'Environment', '', 5),
        (6, 0, 'Emergency', '', 6),
        (7, 0, 'Creative', '', 7),
        (8, 0, 'Other', '', 8)",
      "adding funding categories"
    );
  }
  update_query("UPDATE `posts_funding` SET `category_id` = (SELECT MIN(`category_id`) FROM `funding_categories` WHERE `category_parent_id` = 0) WHERE `category_id` = 0 AND (SELECT COUNT(*) FROM `funding_categories` WHERE `category_parent_id` = 0) > 0", "updating funding categories");
  /* add dating interests */
  $check_dating_interests = update_query("SELECT COUNT(*) FROM `dating_interests`", "adding dating interests");
  if ($check_dating_interests && (int) $check_dating_interests->fetch_row()[0] === 0) {
    update_query(
      "INSERT INTO `dating_interests` (`interest_id`, `title`, `icon`, `interest_order`) VALUES
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
        (15, 'Dancing', '💃', 15)",
      "adding dating interests"
    );
  }
  /* set country flags */
  update_query(
    "UPDATE `system_countries` SET `country_flag` = CASE `country_code`
        WHEN 'AF' THEN '🇦🇫'
        WHEN 'AL' THEN '🇦🇱'
        WHEN 'DZ' THEN '🇩🇿'
        WHEN 'DS' THEN '🇦🇸'
        WHEN 'AD' THEN '🇦🇩'
        WHEN 'AO' THEN '🇦🇴'
        WHEN 'AI' THEN '🇦🇮'
        WHEN 'AQ' THEN '🇦🇶'
        WHEN 'AG' THEN '🇦🇬'
        WHEN 'AR' THEN '🇦🇷'
        WHEN 'AM' THEN '🇦🇲'
        WHEN 'AW' THEN '🇦🇼'
        WHEN 'AU' THEN '🇦🇺'
        WHEN 'AT' THEN '🇦🇹'
        WHEN 'AZ' THEN '🇦🇿'
        WHEN 'BS' THEN '🇧🇸'
        WHEN 'BH' THEN '🇧🇭'
        WHEN 'BD' THEN '🇧🇩'
        WHEN 'BB' THEN '🇧🇧'
        WHEN 'BY' THEN '🇧🇾'
        WHEN 'BE' THEN '🇧🇪'
        WHEN 'BZ' THEN '🇧🇿'
        WHEN 'BJ' THEN '🇧🇯'
        WHEN 'BM' THEN '🇧🇲'
        WHEN 'BT' THEN '🇧🇹'
        WHEN 'BO' THEN '🇧🇴'
        WHEN 'BA' THEN '🇧🇦'
        WHEN 'BW' THEN '🇧🇼'
        WHEN 'BV' THEN '🇧🇻'
        WHEN 'BR' THEN '🇧🇷'
        WHEN 'IO' THEN '🇮🇴'
        WHEN 'BN' THEN '🇧🇳'
        WHEN 'BG' THEN '🇧🇬'
        WHEN 'BF' THEN '🇧🇫'
        WHEN 'BI' THEN '🇧🇮'
        WHEN 'KH' THEN '🇰🇭'
        WHEN 'CM' THEN '🇨🇲'
        WHEN 'CA' THEN '🇨🇦'
        WHEN 'CV' THEN '🇨🇻'
        WHEN 'KY' THEN '🇰🇾'
        WHEN 'CF' THEN '🇨🇫'
        WHEN 'TD' THEN '🇹🇩'
        WHEN 'CL' THEN '🇨🇱'
        WHEN 'CN' THEN '🇨🇳'
        WHEN 'CX' THEN '🇨🇽'
        WHEN 'CC' THEN '🇨🇨'
        WHEN 'CO' THEN '🇨🇴'
        WHEN 'KM' THEN '🇰🇲'
        WHEN 'CG' THEN '🇨🇬'
        WHEN 'CK' THEN '🇨🇰'
        WHEN 'CR' THEN '🇨🇷'
        WHEN 'HR' THEN '🇭🇷'
        WHEN 'CU' THEN '🇨🇺'
        WHEN 'CY' THEN '🇨🇾'
        WHEN 'CZ' THEN '🇨🇿'
        WHEN 'DK' THEN '🇩🇰'
        WHEN 'DJ' THEN '🇩🇯'
        WHEN 'DM' THEN '🇩🇲'
        WHEN 'DO' THEN '🇩🇴'
        WHEN 'TP' THEN '🇹🇱'
        WHEN 'EC' THEN '🇪🇨'
        WHEN 'EG' THEN '🇪🇬'
        WHEN 'SV' THEN '🇸🇻'
        WHEN 'GQ' THEN '🇬🇶'
        WHEN 'ER' THEN '🇪🇷'
        WHEN 'EE' THEN '🇪🇪'
        WHEN 'ET' THEN '🇪🇹'
        WHEN 'FK' THEN '🇫🇰'
        WHEN 'FO' THEN '🇫🇴'
        WHEN 'FJ' THEN '🇫🇯'
        WHEN 'FI' THEN '🇫🇮'
        WHEN 'FR' THEN '🇫🇷'
        WHEN 'FX' THEN '🇫🇷'
        WHEN 'GF' THEN '🇬🇫'
        WHEN 'PF' THEN '🇵🇫'
        WHEN 'TF' THEN '🇹🇫'
        WHEN 'GA' THEN '🇬🇦'
        WHEN 'GM' THEN '🇬🇲'
        WHEN 'GE' THEN '🇬🇪'
        WHEN 'DE' THEN '🇩🇪'
        WHEN 'GH' THEN '🇬🇭'
        WHEN 'GI' THEN '🇬🇮'
        WHEN 'GK' THEN '🇬🇬'
        WHEN 'GR' THEN '🇬🇷'
        WHEN 'GL' THEN '🇬🇱'
        WHEN 'GD' THEN '🇬🇩'
        WHEN 'GP' THEN '🇬🇵'
        WHEN 'GU' THEN '🇬🇺'
        WHEN 'GT' THEN '🇬🇹'
        WHEN 'GN' THEN '🇬🇳'
        WHEN 'GW' THEN '🇬🇼'
        WHEN 'GY' THEN '🇬🇾'
        WHEN 'HT' THEN '🇭🇹'
        WHEN 'HM' THEN '🇭🇲'
        WHEN 'HN' THEN '🇭🇳'
        WHEN 'HK' THEN '🇭🇰'
        WHEN 'HU' THEN '🇭🇺'
        WHEN 'IS' THEN '🇮🇸'
        WHEN 'IN' THEN '🇮🇳'
        WHEN 'IM' THEN '🇮🇲'
        WHEN 'ID' THEN '🇮🇩'
        WHEN 'IR' THEN '🇮🇷'
        WHEN 'IQ' THEN '🇮🇶'
        WHEN 'IE' THEN '🇮🇪'
        WHEN 'IL' THEN '🇮🇱'
        WHEN 'IT' THEN '🇮🇹'
        WHEN 'CI' THEN '🇨🇮'
        WHEN 'JE' THEN '🇯🇪'
        WHEN 'JM' THEN '🇯🇲'
        WHEN 'JP' THEN '🇯🇵'
        WHEN 'JO' THEN '🇯🇴'
        WHEN 'KZ' THEN '🇰🇿'
        WHEN 'KE' THEN '🇰🇪'
        WHEN 'KI' THEN '🇰🇮'
        WHEN 'KP' THEN '🇰🇵'
        WHEN 'KR' THEN '🇰🇷'
        WHEN 'XK' THEN '🇽🇰'
        WHEN 'KW' THEN '🇰🇼'
        WHEN 'KG' THEN '🇰🇬'
        WHEN 'LA' THEN '🇱🇦'
        WHEN 'LV' THEN '🇱🇻'
        WHEN 'LB' THEN '🇱🇧'
        WHEN 'LS' THEN '🇱🇸'
        WHEN 'LR' THEN '🇱🇷'
        WHEN 'LY' THEN '🇱🇾'
        WHEN 'LI' THEN '🇱🇮'
        WHEN 'LT' THEN '🇱🇹'
        WHEN 'LU' THEN '🇱🇺'
        WHEN 'MO' THEN '🇲🇴'
        WHEN 'MK' THEN '🇲🇰'
        WHEN 'MG' THEN '🇲🇬'
        WHEN 'MW' THEN '🇲🇼'
        WHEN 'MY' THEN '🇲🇾'
        WHEN 'MV' THEN '🇲🇻'
        WHEN 'ML' THEN '🇲🇱'
        WHEN 'MT' THEN '🇲🇹'
        WHEN 'MH' THEN '🇲🇭'
        WHEN 'MQ' THEN '🇲🇶'
        WHEN 'MR' THEN '🇲🇷'
        WHEN 'MU' THEN '🇲🇺'
        WHEN 'TY' THEN '🇾🇹'
        WHEN 'MX' THEN '🇲🇽'
        WHEN 'FM' THEN '🇫🇲'
        WHEN 'MD' THEN '🇲🇩'
        WHEN 'MC' THEN '🇲🇨'
        WHEN 'MN' THEN '🇲🇳'
        WHEN 'ME' THEN '🇲🇪'
        WHEN 'MS' THEN '🇲🇸'
        WHEN 'MA' THEN '🇲🇦'
        WHEN 'MZ' THEN '🇲🇿'
        WHEN 'MM' THEN '🇲🇲'
        WHEN 'NA' THEN '🇳🇦'
        WHEN 'NR' THEN '🇳🇷'
        WHEN 'NP' THEN '🇳🇵'
        WHEN 'NL' THEN '🇳🇱'
        WHEN 'NC' THEN '🇳🇨'
        WHEN 'NZ' THEN '🇳🇿'
        WHEN 'NI' THEN '🇳🇮'
        WHEN 'NE' THEN '🇳🇪'
        WHEN 'NG' THEN '🇳🇬'
        WHEN 'NU' THEN '🇳🇺'
        WHEN 'NF' THEN '🇳🇫'
        WHEN 'MP' THEN '🇲🇵'
        WHEN 'NO' THEN '🇳🇴'
        WHEN 'OM' THEN '🇴🇲'
        WHEN 'PK' THEN '🇵🇰'
        WHEN 'PW' THEN '🇵🇼'
        WHEN 'PS' THEN '🇵🇸'
        WHEN 'PA' THEN '🇵🇦'
        WHEN 'PG' THEN '🇵🇬'
        WHEN 'PY' THEN '🇵🇾'
        WHEN 'PE' THEN '🇵🇪'
        WHEN 'PH' THEN '🇵🇭'
        WHEN 'PN' THEN '🇵🇳'
        WHEN 'PL' THEN '🇵🇱'
        WHEN 'PT' THEN '🇵🇹'
        WHEN 'PR' THEN '🇵🇷'
        WHEN 'QA' THEN '🇶🇦'
        WHEN 'RE' THEN '🇷🇪'
        WHEN 'RO' THEN '🇷🇴'
        WHEN 'RU' THEN '🇷🇺'
        WHEN 'RW' THEN '🇷🇼'
        WHEN 'KN' THEN '🇰🇳'
        WHEN 'LC' THEN '🇱🇨'
        WHEN 'VC' THEN '🇻🇨'
        WHEN 'WS' THEN '🇼🇸'
        WHEN 'SM' THEN '🇸🇲'
        WHEN 'ST' THEN '🇸🇹'
        WHEN 'SA' THEN '🇸🇦'
        WHEN 'SN' THEN '🇸🇳'
        WHEN 'RS' THEN '🇷🇸'
        WHEN 'SC' THEN '🇸🇨'
        WHEN 'SL' THEN '🇸🇱'
        WHEN 'SG' THEN '🇸🇬'
        WHEN 'SK' THEN '🇸🇰'
        WHEN 'SI' THEN '🇸🇮'
        WHEN 'SB' THEN '🇸🇧'
        WHEN 'SO' THEN '🇸🇴'
        WHEN 'ZA' THEN '🇿🇦'
        WHEN 'GS' THEN '🇬🇸'
        WHEN 'ES' THEN '🇪🇸'
        WHEN 'LK' THEN '🇱🇰'
        WHEN 'SH' THEN '🇸🇭'
        WHEN 'PM' THEN '🇵🇲'
        WHEN 'SD' THEN '🇸🇩'
        WHEN 'SR' THEN '🇸🇷'
        WHEN 'SJ' THEN '🇸🇯'
        WHEN 'SZ' THEN '🇸🇿'
        WHEN 'SE' THEN '🇸🇪'
        WHEN 'CH' THEN '🇨🇭'
        WHEN 'SY' THEN '🇸🇾'
        WHEN 'TW' THEN '🇹🇼'
        WHEN 'TJ' THEN '🇹🇯'
        WHEN 'TZ' THEN '🇹🇿'
        WHEN 'TH' THEN '🇹🇭'
        WHEN 'TG' THEN '🇹🇬'
        WHEN 'TK' THEN '🇹🇰'
        WHEN 'TO' THEN '🇹🇴'
        WHEN 'TT' THEN '🇹🇹'
        WHEN 'TN' THEN '🇹🇳'
        WHEN 'TR' THEN '🇹🇷'
        WHEN 'TM' THEN '🇹🇲'
        WHEN 'TC' THEN '🇹🇨'
        WHEN 'TV' THEN '🇹🇻'
        WHEN 'UG' THEN '🇺🇬'
        WHEN 'UA' THEN '🇺🇦'
        WHEN 'AE' THEN '🇦🇪'
        WHEN 'GB' THEN '🇬🇧'
        WHEN 'US' THEN '🇺🇸'
        WHEN 'UM' THEN '🇺🇲'
        WHEN 'UY' THEN '🇺🇾'
        WHEN 'UZ' THEN '🇺🇿'
        WHEN 'VU' THEN '🇻🇺'
        WHEN 'VA' THEN '🇻🇦'
        WHEN 'VE' THEN '🇻🇪'
        WHEN 'VN' THEN '🇻🇳'
        WHEN 'VG' THEN '🇻🇬'
        WHEN 'VI' THEN '🇻🇮'
        WHEN 'WF' THEN '🇼🇫'
        WHEN 'EH' THEN '🇪🇭'
        WHEN 'YE' THEN '🇾🇪'
        WHEN 'ZR' THEN '🇨🇩'
        WHEN 'ZM' THEN '🇿🇲'
        WHEN 'ZW' THEN '🇿🇼'
        ELSE `country_flag`
      END WHERE `country_flag` = ''",
    "updating country flags"
  );
  /* set nova as the default theme */
  $check_nova = update_query("SELECT theme_id FROM system_themes WHERE name = 'nova'", "updating the default theme");
  if ($check_nova && $check_nova->num_rows == 0) {
    update_query("UPDATE system_themes SET name = 'nova' WHERE name = 'default'", "updating the default theme");
    if ($db->affected_rows == 0) {
      update_query("INSERT INTO system_themes (name, title, `default`, enabled) VALUES ('nova', 'Nova', '1', '1')", "updating the default theme");
    }
    update_query("UPDATE system_themes SET `default` = IF(name = 'nova', '1', '0'), enabled = IF(name = 'nova', '1', '0')", "updating the default theme");
    update_query("UPDATE system_themes SET title = 'Nova', fluid_design = '0', system_theme_night_on = '0', system_theme_mode_select = '1', system_theme_icons = 'svg', system_theme_fonts = 'google', system_wallpaper_default = '1', landing = 'default', bottom_bar = 'home,reels,add,watch,menu', sidebar = 'saved,scheduled,memories,stories_archive,people,dating,pages,groups,events,reels,watch,live', sidebar_more = 'wallet,ads,boosted,blogs,market,funding,offers,jobs,courses,forums,movies,games,merits,developers,directory' WHERE name = 'nova'", "updating the default theme");
  }
  /* seed theme titles from folder names */
  update_query("UPDATE system_themes SET title = name WHERE title = ''", "updating theme titles");
  /* seed the locked Default landing for every theme */
  update_query("INSERT IGNORE INTO system_theme_landings (theme_id, slug, title, is_default) SELECT theme_id, 'default', 'Default', '1' FROM system_themes", "adding theme landings");
  /* add nova landings */
  update_query("INSERT IGNORE INTO system_theme_landings (theme_id, slug, title, is_default) SELECT system_themes.theme_id, landings.slug, landings.title, '0' FROM system_themes JOIN (SELECT 'aurora' AS slug, 'Aurora' AS title UNION ALL SELECT 'summit', 'Summit' UNION ALL SELECT 'studio', 'Studio' UNION ALL SELECT 'orbit', 'Orbit' UNION ALL SELECT 'liquid', 'Liquid' UNION ALL SELECT 'terminal', 'Terminal' UNION ALL SELECT 'retro', 'Retro' UNION ALL SELECT 'minimal', 'Minimal') AS landings WHERE system_themes.name = 'nova'", "adding theme landings");
  /* update default language titles to native names */
  update_query("UPDATE `system_languages` SET `title` = CASE `code` WHEN 'ar_sa' THEN 'العربية' WHEN 'fr_fr' THEN 'Français' WHEN 'es_es' THEN 'Español' WHEN 'pt_pt' THEN 'Português' WHEN 'tr_tr' THEN 'Türkçe' WHEN 'nl_nl' THEN 'Nederlands' WHEN 'ru_ru' THEN 'Русский' WHEN 'ro_ro' THEN 'Română' WHEN 'pt_br' THEN 'Português (Brasil)' WHEN 'el_gr' THEN 'Ελληνικά' ELSE `title` END WHERE (`code`, `title`) IN (('ar_sa', 'Arabic'), ('fr_fr', 'French'), ('es_es', 'Spanish'), ('pt_pt', 'Portuguese'), ('tr_tr', 'Turkish'), ('nl_nl', 'Dutch'), ('ru_ru', 'Russian'), ('ro_ro', 'Romaian'), ('pt_br', 'Portuguese (Brazil)'), ('el_gr', 'Greek'))", "updating language titles");
  /* update conversations last message id */
  stream_progress(60);
  update_query("UPDATE `conversations` LEFT JOIN `conversations_messages` ON `conversations`.`last_message_id` = `conversations_messages`.`message_id` SET `conversations`.`last_message_id` = (SELECT IFNULL(MAX(`messages`.`message_id`), 0) FROM `conversations_messages` AS `messages` WHERE `messages`.`conversation_id` = `conversations`.`conversation_id`) WHERE `conversations`.`last_message_id` > 0 AND `conversations_messages`.`message_id` IS NULL", "updating conversations last messages");
  /* delete conversations with no messages */
  update_query("DELETE `conversations_users` FROM `conversations_users` INNER JOIN `conversations` ON `conversations_users`.`conversation_id` = `conversations`.`conversation_id` WHERE `conversations`.`last_message_id` = 0 AND `conversations`.`node_id` IS NULL", "deleting empty conversations");
  update_query("DELETE FROM `conversations` WHERE `last_message_id` = 0 AND `node_id` IS NULL", "deleting empty conversations");
  /* update user live requests lastid */
  stream_progress(62);
  update_query("UPDATE `users` SET `user_live_requests_lastid` = (SELECT IFNULL(MAX(`friends`.`id`), 0) FROM `friends` WHERE `friends`.`status` = 0 AND `friends`.`user_two_id` = `users`.`user_id`)", "updating user live requests lastid");
  stream_progress(64);
  update_query("UPDATE `users` LEFT JOIN (SELECT `to_user_id`, MAX(`notification_id`) AS `max_id` FROM `notifications` WHERE `action` != 'chat_message' AND `to_user_id` > 0 GROUP BY `to_user_id`) AS `user_notifications` ON `user_notifications`.`to_user_id` = `users`.`user_id` JOIN (SELECT IFNULL(MAX(`notification_id`), 0) AS `max_id` FROM `notifications` WHERE `action` != 'chat_message' AND `to_user_id` = 0) AS `broadcast_notifications` SET `users`.`user_live_notifications_lastid` = GREATEST(IFNULL(`user_notifications`.`max_id`, 0), `broadcast_notifications`.`max_id`)", "updating user live notifications lastid");
  /* add user shortcuts */
  stream_progress(66);
  update_query("INSERT IGNORE INTO `users_shortcuts` (`user_id`, `node_id`, `node_type`, `time`) SELECT `user_id`, `page_id`, 'page', NOW() FROM `pages_likes`", "adding user shortcuts");
  stream_progress(67);
  update_query("INSERT IGNORE INTO `users_shortcuts` (`user_id`, `node_id`, `node_type`, `time`) SELECT `user_id`, `group_id`, 'group', NOW() FROM `groups_members` WHERE `approved` = '1'", "adding user shortcuts");
  stream_progress(68);
  update_query("INSERT IGNORE INTO `users_shortcuts` (`user_id`, `node_id`, `node_type`, `time`) SELECT `user_id`, `event_id`, 'event', NOW() FROM `events_members` WHERE `is_going` = '1' OR `is_interested` = '1'", "adding user shortcuts");
  stream_progress(69);
  update_query("INSERT IGNORE INTO `users_shortcuts` (`user_id`, `node_id`, `node_type`, `time`) SELECT `user_id`, `game_id`, 'game', IFNULL(`last_played_time`, NOW()) FROM `games_players`", "adding user shortcuts");
  /* update forums threads last reply user */
  stream_progress(70);
  update_query("UPDATE `forums_threads` SET `last_reply_user_id` = (SELECT `forums_replies`.`user_id` FROM `forums_replies` WHERE `forums_replies`.`thread_id` = `forums_threads`.`thread_id` ORDER BY `forums_replies`.`reply_id` DESC LIMIT 1)", "updating forums threads");
  /* index users & listing posts locations (in chunks) */
  $locations = [
    'users' => ['table' => 'users_locations', 'id' => 'user_id', 'lat' => 'user_latitude', 'lng' => 'user_longitude', 'type' => ''],
    'posts' => ['table' => 'posts_locations', 'id' => 'post_id', 'lat' => 'post_latitude', 'lng' => 'post_longitude', 'type' => "`post_type` IN ('article', 'product', 'job', 'offer', 'funding', 'course') AND "],
  ];
  foreach ($locations as $source => $location) {
    $get_max_id = update_query("SELECT IFNULL(MAX(`" . $location['id'] . "`), 0) FROM `" . $source . "`", "indexing " . $source . " locations");
    $max_id = ($get_max_id) ? (int) $get_max_id->fetch_row()[0] : 0;
    for ($from_id = 0; $from_id < $max_id; $from_id += 50000) {
      stream_progress(72);
      update_query(sprintf(
        "INSERT IGNORE INTO `%1\$s` (`%2\$s`" . (($location['type']) ? ", `post_type`" : "") . ", `location`) SELECT `%2\$s`" . (($location['type']) ? ", `post_type`" : "") . ", POINT(CAST(`%4\$s` AS DECIMAL(10,7)), CAST(`%3\$s` AS DECIMAL(10,7))) FROM `%5\$s` WHERE `%2\$s` > %6\$d AND `%2\$s` <= %7\$d AND " . $location['type'] . "`%3\$s` REGEXP '^-?[0-9]{1,2}([.][0-9]+)?$' AND `%4\$s` REGEXP '^-?[0-9]{1,3}([.][0-9]+)?$' AND CAST(`%3\$s` AS DECIMAL(10,7)) BETWEEN -90 AND 90 AND CAST(`%4\$s` AS DECIMAL(10,7)) BETWEEN -180 AND 180 AND NOT (CAST(`%3\$s` AS DECIMAL(10,7)) = 0 AND CAST(`%4\$s` AS DECIMAL(10,7)) = 0)",
        $location['table'],
        $location['id'],
        $location['lat'],
        $location['lng'],
        $source,
        $from_id,
        $from_id + 50000
      ), "indexing " . $source . " locations");
    }
  }
  /* set translation provider */
  stream_progress(74);
  update_query("UPDATE `system_options` SET `option_value` = 'yandex' WHERE `option_name` = 'translation_provider' AND (SELECT `c` FROM (SELECT COUNT(*) AS `c` FROM `system_options` WHERE `option_name` = 'google_translation_key' AND `option_value` = '') g) = 1 AND (SELECT `c` FROM (SELECT COUNT(*) AS `c` FROM `system_options` WHERE `option_name` = 'yandex_key' AND `option_value` != '') y) = 1", "setting the translation provider");
  /* import robots.txt */
  if (is_file(ABSPATH . 'robots.txt')) {
    $robots_txt = @file_get_contents(ABSPATH . 'robots.txt');
    if ($robots_txt !== false && trim($robots_txt) !== '') {
      $robots_txt = trim(preg_replace('/^\s*Sitemap:.*$/mi', '', $robots_txt));
      update_query(sprintf("INSERT INTO system_options (option_name, option_value) VALUES ('robots_txt', %s) ON DUPLICATE KEY UPDATE option_value = VALUES(option_value)", secure($robots_txt)), "importing robots.txt");
    }
    @unlink(ABSPATH . 'robots.txt');
  }
  /* set upload sizes */
  $get_upload_sizes = update_query("SELECT option_name, option_value FROM system_options WHERE option_name IN ('max_photo_size', 'max_cover_size', 'max_avatar_size', 'max_video_size', 'max_audio_size', 'max_file_size', 'max_daily_upload_size')", "updating upload sizes");
  while ($get_upload_sizes && $upload_size = $get_upload_sizes->fetch_assoc()) {
    $upload_size_value = get_upload_size_option($upload_size['option_value'], ($upload_size['option_name'] == 'max_daily_upload_size'));
    if ((string) $upload_size_value !== $upload_size['option_value']) {
      update_query(sprintf("UPDATE system_options SET option_value = %s WHERE option_name = %s", secure($upload_size_value), secure($upload_size['option_name'])), "updating upload sizes");
    }
  }
  /* set watermark opacity */
  $get_watermark_opacity = update_query("SELECT option_name, option_value FROM system_options WHERE option_name IN ('watermark_opacity', 'watermark_videos_opacity')", "updating watermark opacity");
  while ($get_watermark_opacity && $watermark_opacity = $get_watermark_opacity->fetch_assoc()) {
    $watermark_opacity_value = (string) get_watermark_opacity($watermark_opacity['option_value']);
    if ($watermark_opacity_value !== $watermark_opacity['option_value']) {
      update_query(sprintf("UPDATE system_options SET option_value = %s WHERE option_name = %s", secure($watermark_opacity_value), secure($watermark_opacity['option_name'])), "updating watermark opacity");
    }
  }
  /* set watermark positions */
  $watermark_positions = [
    'watermark_x' => "(CASE WHEN p.option_value LIKE '%left%' THEN 0 WHEN p.option_value LIKE '%right%' THEN 100 ELSE 50 END) + o.offset_value / 5",
    'watermark_y' => "(CASE WHEN p.option_value LIKE '%top%' THEN 0 WHEN p.option_value LIKE '%bottom%' THEN 100 ELSE 50 END) + o.offset_value / 5",
    'watermark_videos_x' => "CASE WHEN p.option_value = 'center' THEN 50 WHEN p.option_value LIKE '%right%' THEN 100 - o.offset_value / 5 ELSE o.offset_value / 5 END",
    'watermark_videos_y' => "CASE WHEN p.option_value = 'center' THEN 50 WHEN p.option_value LIKE '%bottom%' THEN 100 - o.offset_value / 5 ELSE o.offset_value / 5 END",
  ];
  foreach ($watermark_positions as $option_name => $expression) {
    $position_option = (str_contains($option_name, 'videos')) ? 'watermark_videos_position' : 'watermark_position';
    $offset_option = str_replace(['_x', '_y'], ['_xoffset', '_yoffset'], $option_name);
    update_query(sprintf(
      "INSERT INTO system_options (option_name, option_value) SELECT '%1\$s', LEAST(100, GREATEST(0, ROUND(%2\$s))) FROM system_options p JOIN (SELECT IF(option_value REGEXP '^-?[0-9]+$', CAST(option_value AS SIGNED), 0) AS offset_value FROM system_options WHERE option_name = '%4\$s') o WHERE p.option_name = '%3\$s' ON DUPLICATE KEY UPDATE option_value = VALUES(option_value)",
      $option_name,
      $expression,
      $position_option,
      $offset_option
    ), "updating watermark positions");
  }
  /* add reserved usernames */
  update_query("UPDATE system_options SET option_value = CONCAT(LEFT(option_value, CHAR_LENGTH(option_value) - 1), IF(option_value = '[]', '', ','), '{&quot;value&quot;:&quot;dating&quot;}]') WHERE option_name = 'reserved_usernames' AND option_value LIKE '[%]' AND option_value NOT LIKE '%&quot;dating&quot;%'", "updating reserved usernames");
  /* set story expiry */
  update_query("UPDATE `stories` SET `expires_at` = DATE_ADD(`time`, INTERVAL 1 DAY) WHERE `expires_at` = '1970-01-01 00:00:00'", "updating the stories table");
  update_query("ALTER TABLE `stories` MODIFY COLUMN `expires_at` DATETIME NOT NULL", "updating the stories table");
  /* remove old stories */
  update_query("DELETE FROM `stories` WHERE `type` != 'text' AND `source` = ''", "removing old stories");
  /* remove empty photos posts */
  $empty_photos_posts = "`posts`.`post_type` IN ('photos', 'album', 'profile_picture', 'profile_cover', 'page_picture', 'page_cover', 'group_picture', 'group_cover', 'event_cover') AND NOT EXISTS (SELECT 1 FROM `posts_photos` WHERE `posts_photos`.`post_id` = `posts`.`post_id`)";
  foreach (['hashtags_posts', 'posts_hidden', 'posts_locations', 'posts_search', 'posts_paid', 'posts_reactions', 'posts_saved', 'posts_views'] as $empty_photos_table) {
    update_query("DELETE `" . $empty_photos_table . "` FROM `" . $empty_photos_table . "` INNER JOIN `posts` ON `" . $empty_photos_table . "`.`post_id` = `posts`.`post_id` WHERE " . $empty_photos_posts, "removing empty photos posts");
  }
  update_query("DELETE FROM `posts` WHERE " . $empty_photos_posts, "removing empty photos posts");
  /* remove old system options */
  update_query(
    "DELETE FROM system_options WHERE option_name IN (
      'session_hash',
      'landing_page_template',
      'fluid_design',
      'system_theme_night_on',
      'system_theme_mode_select',
      'system_wallpaper_default',
      'system_wallpaper',
      'css_customized',
      'css_background',
      'css_link_color',
      'css_header',
      'css_header_search',
      'css_header_search_color',
      'css_btn_primary',
      'css_header_icons',
      'css_header_icons_night',
      'css_main_icons',
      'css_main_icons_night',
      'css_action_icons',
      'css_action_icons_night',
      'css_custome_css',
      'merits_widgets_newsfeed',
      'infobip_username',
      'infobip_password'
    )",
    "removing old system settings"
  );


  // step 5: writing the configuration
  stream_progress(76, 'Writing configuration');
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
	define("LICENCE_KEY", \'' . addslashes($licence_key) . '\');
	?>';
  $config_file = 'includes/config.php';
  $handle = fopen($config_file, 'w') or stream_fail("Update wizard cannot create the config file");
  fwrite($handle, $config_string);
  fclose($handle);
  try {
    licence_store_payload($licence);
  } catch (Exception $e) {
    stream_fail($e->getMessage());
  }
  if (empty($licence['entitlements']['monetization'])) {
    licence_turn_off_premium_options();
  }


  // step 6: installing the payments & monetization module
  if (!empty($licence['entitlements']['monetization'])) {
    stream_progress(84, 'Installing payments and monetization files');
    try {
      $module = licence_install_module_zip(licence_download_module('monetization', $licence_key));
      if (empty($module['extracted'])) {
        $update_errors[] = $module['message'];
      }
    } catch (Exception $e) {
      $update_errors[] = "Payments and monetization files couldn't be installed (" . $e->getMessage() . "). Open AdminCP → License and click Verify and enable.";
    }
  }


  // step 7: finishing up
  stream_progress(90, 'Finishing up');
  if ($is_stream) {
    stream_progress(100);
    stream_send(['success' => true, 'redirect' => './', 'warnings' => $update_errors]);
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
  <title><?php echo SYS_NAME ?> &rsaquo; Update (v<?php echo SYS_UPDATE_VER ?>)</title>
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

    #congrats-view .warnings {
      display: none;
      margin: 0 0 20px;
      text-align: left;
    }

    #congrats-view .warnings.show {
      display: block;
    }

    #congrats-view .warnings ul {
      max-height: 180px;
      margin: 8px 0 0;
      padding-left: 18px;
      overflow-y: auto;
      font-size: 12.5px;
      word-break: break-word;
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
        <h1><?php echo SYS_NAME ?> Update</h1>
        <div class="ver">Version <?php echo SYS_UPDATE_VER ?></div>
      </div>
    </div>

    <ol class="stepper" id="stepper">
      <li class="active" data-step="0"><span class="dot">1</span><span class="lbl">Welcome</span></li>
      <li data-step="1"><span class="dot">2</span><span class="lbl">Requirements</span></li>
      <li data-step="2"><span class="dot">3</span><span class="lbl">License</span></li>
      <li data-step="3"><span class="dot">4</span><span class="lbl">Finish</span></li>
    </ol>

    <form id="wizard" method="post" novalidate data-requirements-ok="<?php echo $requirements_ok ? 'true' : 'false' ?>">
      <div class="alert" id="alert"></div>

      <!-- Step 1: Welcome -->
      <section class="panel active" data-step="0">
        <h2>Welcome</h2>
        <p>Welcome to the <strong><?php echo SYS_NAME ?></strong> update process. This wizard will bring your installation up to <strong>version <?php echo SYS_UPDATE_VER ?></strong>. Just confirm your license and let it run.</p>
        <div class="terms">
          <div class="box">
            <strong>Before you continue</strong>
            <ul>
              <li><svg class="ic ic-can" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                  <path d="M20 6L9 17l-5-5" />
                </svg>Make a full backup of your files and database.</li>
              <li><svg class="ic ic-can" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                  <path d="M20 6L9 17l-5-5" />
                </svg>Ensure you have replaced the old files with the new release.</li>
              <li><svg class="ic ic-can" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                  <path d="M20 6L9 17l-5-5" />
                </svg>Keep your purchase code handy to verify your license.</li>
            </ul>
          </div>
          <div class="box">
            <strong>Please do NOT</strong>
            <ul>
              <li><svg class="ic ic-cannot" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                  <path d="M18 6L6 18M6 6l12 12" />
                </svg>Close this window while the update is running.</li>
              <li><svg class="ic ic-cannot" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                  <path d="M18 6L6 18M6 6l12 12" />
                </svg>Run the update more than once on the same version.</li>
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
          <span>I have backed up my data and I'm ready to update.</span>
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

      <!-- Step 4: Review -->
      <section class="panel" data-step="3">
        <h2>Review &amp; Update</h2>
        <p>Confirm the details below, then start the update.</p>
        <div class="review">
          <div class="row"><span>Updating To</span><span>Version <?php echo SYS_UPDATE_VER ?></span></div>
          <div class="row"><span>License Key</span><span id="r_purchase_code">&mdash;</span></div>
        </div>
      </section>

      <div class="foot">
        <button type="button" class="btn ghost" id="btn-back" hidden>Back</button>
        <div style="flex:1"></div>
        <button type="button" class="btn primary" id="btn-next">Next</button>
        <button type="submit" class="btn primary" id="btn-install" name="submit" value="1" hidden>Update</button>
      </div>
    </form>
  </div>

  <!-- Progress overlay -->
  <div class="overlay" id="overlay" hidden>
    <div class="confetti" id="confetti" aria-hidden="true"></div>
    <div class="progress-card">
      <div id="progress-view">
        <h2>Updating <?php echo SYS_NAME ?></h2>
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
            Updating database tables
          </li>
          <li data-stage>
            <span class="mk">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3">
                <path d="M20 6L9 17l-5-5" />
              </svg>
            </span>
            Applying new settings
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
        <h2>Update complete! 🎉</h2>
        <div class="sub"><strong><?php echo SYS_NAME ?></strong> has been updated to version <?php echo SYS_UPDATE_VER ?> successfully.<span id="countdown-text"><br>Redirecting to your site in <span id="countdown">5</span>s&hellip;</span></div>
        <div class="notice is-warning warnings" id="warnings" role="note">
          <strong>Some database changes were skipped</strong>
          <p>Your site was updated, but the queries below could not be applied. Please copy this list and send it to support if something doesn't work as expected.</p>
          <ul id="warnings-list"></ul>
        </div>
        <button type="button" class="btn primary congrats-btn" id="btn-start">Go to Site</button>
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
            showAlert('Please confirm you have backed up your data before continuing.');
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
          fillReview();
        }
        return true;
      }
      /* fill review */
      function fillReview() {
        ['purchase_code'].forEach(function(id) {
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
          licenceNoticeBody.innerHTML = 'Your license includes monetization. The payments and monetization files will be installed during the update, and your existing settings will be kept. For more information, visit <a href="https://zamblek.com/pricing" target="_blank" rel="noopener">zamblek.com/pricing</a>.';
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
            fillReview();
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
        current = STEP_LICENSE;
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
      function showCongrats(url, warnings) {
        document.getElementById('progress-view').hidden = true;
        document.getElementById('congrats-view').hidden = false;
        launchConfetti();
        var go = function() {
          window.location.href = url;
        };
        document.getElementById('btn-start').addEventListener('click', go);
        /* show skipped queries & stay on the page */
        if (warnings && warnings.length) {
          var list = document.getElementById('warnings-list');
          warnings.forEach(function(warning) {
            var li = document.createElement('li');
            li.textContent = warning;
            list.appendChild(li);
          });
          document.getElementById('warnings').classList.add('show');
          document.getElementById('countdown-text').hidden = true;
          return;
        }
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
        if (!validate(STEP_LICENSE)) {
          current = STEP_LICENSE;
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
              showCongrats(msg.redirect || './', msg.warnings);
            }, 600);
          } else if (msg.success === false) {
            finalized = true;
            failUI(msg.message || 'The update could not be completed.');
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
            if (!finalized) failUI(serverMessage(httpError || 'The update ended unexpectedly. Please try again.'));
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