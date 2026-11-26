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
define('SYS_UPDATE_VER', '4.5');
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


// verify licence (wizard step, before update)
if (isset($_POST['verify_licence'])) {
  header('Content-Type: application/json; charset=utf-8');
  header('Cache-Control: no-cache');
  try {
    if (is_empty($_POST['purchase_code'] ?? '')) {
      echo json_encode(['success' => false, 'message' => 'Please enter a valid purchase code']);
      exit;
    }
    $licence = get_licence_key($_POST['purchase_code'], 'update');
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
    $licence = get_licence_key($_POST['purchase_code'], 'update');
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


  // step 3: updating the database tables
  $structure = "

    START TRANSACTION;

    CREATE TABLE `conversations_messages_paid` (
      `id` int unsigned NOT NULL AUTO_INCREMENT,
      `message_id` int unsigned NOT NULL,
      `user_id` int unsigned NOT NULL,
      `time` datetime NOT NULL,
      PRIMARY KEY (`id`),
      KEY `message_id` (`message_id`),
      KEY `user_id` (`user_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    CREATE TABLE `posts_rich_text` (
      `rich_text_id` int unsigned NOT NULL AUTO_INCREMENT,
      `post_id` int unsigned NOT NULL,
      `text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      PRIMARY KEY (`rich_text_id`),
      KEY `post_id` (`post_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

    CREATE TABLE `conversations_messages_media` (
      `media_id` int unsigned NOT NULL AUTO_INCREMENT,
      `message_id` int unsigned NOT NULL,
      `media_type` enum('photo','video','audio','file') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      `source` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
      PRIMARY KEY (`media_id`),
      KEY `message_id` (`message_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    # Changing table conversations_messages fields
    ALTER TABLE `conversations_messages`
      ADD COLUMN `is_paid` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '' AFTER `message`,
      ADD COLUMN `message_price` FLOAT NOT NULL DEFAULT 0 COMMENT '' AFTER `is_paid`,
      ADD COLUMN `paid_text` TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '' AFTER `message_price`,
      ADD COLUMN `paid_image` VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '' AFTER `paid_text`,
      ADD COLUMN `for_adult` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '' AFTER `paid_image`,
      MODIFY COLUMN `image` VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '' AFTER `for_adult`;

    # Changing table users fields
    ALTER TABLE `users`
      ADD COLUMN `user_incognito_enabled` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '' AFTER `user_suggestions_hidden`,
      MODIFY COLUMN `user_privacy_chat` ENUM('me','friends','public') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'public' COMMENT '' AFTER `user_incognito_enabled`;

    # Changing table permissions_groups fields
    ALTER TABLE `permissions_groups`
      ADD COLUMN `rich_text_posts_permission` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '' AFTER `collaborative_posts_permission`,
      MODIFY COLUMN `colored_posts_permission` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '' AFTER `rich_text_posts_permission`;

    COMMIT;

	";
  stream_progress(40, 'Updating database tables');
  $db->multi_query($structure) or stream_fail(wizard_db_error($db, "The update couldn't finish while updating your database tables"));
  /* flush multi-query results */
  do {
    if ($db->errno) {
      stream_fail(wizard_db_error($db, "The update couldn't finish while updating your database tables"));
    }
  } while (mysqli_more_results($db) && mysqli_next_result($db));
  if ($db->errno) {
    stream_fail(wizard_db_error($db, "The update couldn't finish while updating your database tables"));
  }


  // step 4: applying new settings
  stream_progress(58, 'Applying new settings');
  /* remove old system options */
  $db->query("DELETE FROM system_options WHERE option_name = 'session_hash'") or stream_fail(wizard_db_error($db, "The update couldn't finish while removing old system settings"));
  /* insert new system options */
  // $db->query("INSERT INTO system_options (option_name, option_value) VALUES
  //     ('option_name', 'option_value')
  //     ") or stream_fail(wizard_db_error($db, "The update couldn't finish while adding the new system settings"));


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
  licence_turn_off_premium_options();


  // step 6: finishing up
  stream_progress(90, 'Finishing up');
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
        <div class="sub"><strong><?php echo SYS_NAME ?></strong> has been updated to version <?php echo SYS_UPDATE_VER ?> successfully.<br>Redirecting to your site in <span id="countdown">5</span>s&hellip;</div>
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
              showCongrats(msg.redirect || './');
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