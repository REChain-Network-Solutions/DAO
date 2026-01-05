<?php

/**
 * update wizard
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich
 */

// set execution time
set_time_limit(0); /* unlimited max execution time */


// set ABSPATH
define('ABSPATH', __DIR__ . '/');


// get system version & exceptions
define('SYS_UPDATE_VER', '4.1');
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

    CREATE TABLE `conversations_calls` (
    `call_id` int unsigned NOT NULL AUTO_INCREMENT,
    `is_video_call` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
    `from_user_id` int unsigned NOT NULL,
    `from_user_token` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
    `to_user_id` int unsigned NOT NULL,
    `to_user_token` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
    `room` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
    `answered` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
    `declined` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
    `created_time` datetime NOT NULL,
    `updated_time` datetime NOT NULL,
    PRIMARY KEY (`call_id`),
    KEY `from_user_id` (`from_user_id`),
    KEY `to_user_id` (`to_user_id`)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

  CREATE TABLE `users_uploads_pending` (
    `id` int NOT NULL AUTO_INCREMENT,
    `user_id` int NOT NULL,
    `file_name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
    `file_size` float NOT NULL,
    `handle` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
    `insert_date` datetime NOT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_file_name` (`file_name`) USING BTREE
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

  DROP TABLE `conversations_calls_audio`;

  DROP TABLE `conversations_calls_video`;

  # Changing table events fields
  ALTER TABLE `events`
    ADD COLUMN `event_language` INT UNSIGNED NOT NULL COMMENT '' AFTER `event_country`,
    MODIFY COLUMN `event_description` MEDIUMTEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '' AFTER `event_language`,
    ADD COLUMN `event_is_online` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '' AFTER `event_end_date`,
    MODIFY COLUMN `event_publish_enabled` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1' COMMENT '' AFTER `event_is_online`;

  # Changing table groups fields
  ALTER TABLE `groups`
    ADD COLUMN `group_language` INT UNSIGNED NOT NULL COMMENT '' AFTER `group_country`,
    MODIFY COLUMN `group_description` MEDIUMTEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '' AFTER `group_language`;

  # Changing table pages fields
  ALTER TABLE `pages`
    ADD COLUMN `page_language` INT UNSIGNED NOT NULL COMMENT '' AFTER `page_country`,
    MODIFY COLUMN `page_description` MEDIUMTEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '' AFTER `page_language`;

    COMMIT;
      
	";
  $db->multi_query($structure) or _error("Error", $db->error);


  // flush multi_queries
  do {
  } while (mysqli_more_results($db) && mysqli_next_result($db));


  // replace system options securionpay with shift4
  $db->query("UPDATE system_options SET option_name = 'shift4_enabled' WHERE option_name = 'securionpay_enabled'");
  $db->query("UPDATE system_options SET option_name = 'shift4_api_key' WHERE option_name = 'securionpay_api_key'");
  $db->query("UPDATE system_options SET option_name = 'shift4_api_secret' WHERE option_name = 'securionpay_api_secret'");


  // truncate table user_sessions (new cookies added)
  $db->query("TRUNCATE TABLE users_sessions");


  // insert new system options
  $db->query("INSERT INTO system_options (option_name, option_value) VALUES
      ('chat_socket_enabled','0'),
      ('chat_socket_proxied','1'),
      ('chat_socket_port','3000'),
      ('chat_socket_ssl_crt',''),
      ('chat_socket_ssl_key',''),
      ('chat_socket_ssl_verify_peer','1'),
      ('chat_socket_ssl_allow_self_signed','0'),
      ('chat_socket_server','php'),
      ('php_bin_path',''),
      ('nodejs_bin_path',''),
      ('cronjob_clear_pending_uploads','0'),
      ('pushr_enabled','0'),
      ('pushr_bucket',''),
      ('pushr_key',''),
      ('pushr_secret',''),
      ('pushr_endpoint',''),
      ('pushr_hostname',''),
      ('agora_call_app_id',''),
      ('agora_call_app_certificate',''),
      ('msg91_template_id',''),
      ('pro_users_widget_enabled','1'),
      ('pro_page_widget_enabled','1'),
      ('name_max_length','12')
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