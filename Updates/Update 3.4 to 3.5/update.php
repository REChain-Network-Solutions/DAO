<?php

/**
 * update wizard
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich - Handles - @sorydima @sorydev @durovshater @DmitrySoro90935 @tanechfund - also check https://dmitry.rechain.network for more information!
 */

// set execution time
set_time_limit(0); /* unlimited max execution time */


// set system version
define('SYS_VER', '3.5');


// set absolut & base path
define('ABSPATH', dirname(__FILE__) . '/');
define('BASEPATH', dirname($_SERVER['PHP_SELF']));


// check the config file
if (!file_exists(ABSPATH . 'includes/config.php')) {
  /* the config file doesn't exist -> start the installer */
  header('Location: ./install');
}


// get system configurations
require_once(ABSPATH . 'includes/config.php');


// enviroment settings
if (DEBUGGING) {
  ini_set("display_errors", true);
  error_reporting(E_ALL ^ E_NOTICE);
} else {
  ini_set("display_errors", false);
  error_reporting(0);
}


// get functions
require_once(ABSPATH . 'includes/functions.php');


// connect to the database
$db = new mysqli(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME, DB_PORT);
$db->set_charset('utf8');
if (mysqli_connect_error()) {
  _error("DB_ERROR");
}


// update
if (isset($_POST['submit'])) {

  // check valid purchase code
  try {
    $licence_key = get_licence_key($_POST['purchase_code']);
    if (is_empty($_POST['purchase_code']) || $licence_key === false) {
      _error("Error", "Please enter a valid purchase code");
    }
    $session_hash = $licence_key;
  } catch (Exception $e) {
    _error("Error", $e->getMessage());
  }


  // update the Delus tables
  $structure = "

CREATE TABLE `reports_categories` (
  `category_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `category_parent_id` int(10) unsigned NOT NULL,
  `category_name` varchar(256) NOT NULL,
  `category_description` text NOT NULL,
  `category_order` int(10) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

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

# Changing table system_options fields
ALTER TABLE `system_options`
	MODIFY COLUMN `option_value` TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL  COMMENT '' AFTER `option_name`;

# Changing table system_currencies fields
ALTER TABLE `system_currencies`
	ADD COLUMN `dir` ENUM('left','right') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'left'  COMMENT '' AFTER `symbol`,
	MODIFY COLUMN `default` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL  COMMENT '' AFTER `dir`,
	ADD COLUMN `enabled` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1'  COMMENT '' AFTER `default`;

# Changing table posts_products fields
ALTER TABLE `posts_products`
	ADD COLUMN `currency_id` INT(10) UNSIGNED NOT NULL  COMMENT '' AFTER `price`,
	MODIFY COLUMN `category_id` INT(10) UNSIGNED NOT NULL  COMMENT '' AFTER `currency_id`;

# Changing table reports fields
ALTER TABLE `reports`
	ADD COLUMN `category_id` INT(10) UNSIGNED NOT NULL  COMMENT '' AFTER `node_type`,
	ADD COLUMN `reason` TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL  COMMENT '' AFTER `category_id`,
	MODIFY COLUMN `time` DATETIME NOT NULL  COMMENT '' AFTER `reason`;

# Changing table users fields
ALTER TABLE `users`
	ADD COLUMN `coinbase_hash` VARCHAR(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL  COMMENT '' AFTER `user_free_tried`,
	ADD COLUMN `coinbase_code` VARCHAR(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL  COMMENT '' AFTER `coinbase_hash`;

	";
  $db->multi_query($structure) or _error("Error", $db->error);


  // flush multi_queries
  do {
  } while (mysqli_more_results($db) && mysqli_next_result($db));


  // update tables collections
  $get_db_tbls = $db->query("show tables") or _error("Error", $db->error);
  while ($db_tbl = $get_db_tbls->fetch_array()) {
    foreach ($db_tbl as $key => $value) {
      $db->query("ALTER TABLE $value CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci");
    }
  }

  // update table reports and set category_id = (others)
  $db->query("UPDATE reports SET category_id = '10'") or _error("Error", $db->error);


  // delete removed system options values
  $db->query("DELETE FROM system_options WHERE option_name = 'system_currency_dir'") or _error("Error", $db->error);


  // insert new system_options values
  $db->query("INSERT INTO system_options (option_name, option_value) VALUES
        ('activation_required', '1'),
        ('google_cloud_enabled', '0'),
        ('google_cloud_bucket', ''),
        ('google_cloud_file', ''),
        ('html_richtext_enabled', '0'),
        ('razorpay_enabled', '0'),
        ('razorpay_key_id', ''),
        ('razorpay_key_secret', ''),
        ('cashfree_enabled', '0'),
        ('cashfree_mode', 'sandbox'),
        ('cashfree_client_id', ''),
        ('cashfree_client_secret', ''),
        ('coinbase_enabled', '0'),
        ('coinbase_api_key', ''),
        ('securionpay_enabled', ''),
        ('securionpay_api_key', ''),
        ('securionpay_api_secret', '')") or _error("Error", $db->error);


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
	?>';

  $config_file = 'includes/config.php';
  $handle = fopen($config_file, 'w') or _error("System Error", "Cannot create the config file");
  fwrite($handle, $config_string);
  fclose($handle);


  // Done
  _error("System Updated", "Delus has been updated to " . SYS_VER);
}

?>

<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="X-UA-Compatible" content="ie=edge">
  <title>Delus &rsaquo; Update (v<?php echo SYS_VER ?>)</title>
  <link rel="shortcut icon" href="includes/assets/js/core/installer/favicon.png" />
  <link href="https://fonts.googleapis.com/css?family=Karla:400,700&display=swap" rel="stylesheet" crossorigin="anonymous">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" integrity="sha512-1ycn6IcaQQ40/MKBW2W4Rhis/DbILU74C1vSrLJxCq57o941Ym01SwNsOMqvEBFlcgUa6xLiPY/NS5R+E6ztJQ==" crossorigin="anonymous" referrerpolicy="no-referrer" />
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" integrity="sha384-JcKb8q3iqJ61gNV9KGb8thSsNjpSL0n8PARn9HuZOnIxN0hoP+VmmDGMN5t9UJ0Z" crossorigin="anonymous">
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
              <div class="bd-wizard-step-subtitle">Delus (v<?php echo SYS_VER ?>)</div>
            </div>
          </div>
        </h3>
        <section>
          <div class="content-wrapper">
            <h3 class="section-heading">Welcome!</h3>
            <p>
              Welcome to <strong>Delus</strong> updating process! Just fill in the information below.
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
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js" integrity="sha384-9/reFTGAW83EW2RDu2S0VKaIzap3H66lZH81PoYlFhbGU+6BZp6G7niu735Sk7lN" crossorigin="anonymous"></script>
  <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js" integrity="sha384-B4gt1jrGC7Jh4AgTPSdUtOBvfO8shuf57BaghqFfPlYxofvL8/KUEfYiJOMMV+rV" crossorigin="anonymous"></script>
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
        $("#wizard-submittion").click();
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