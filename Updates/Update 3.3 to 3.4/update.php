<?php

/**
 * update wizard
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich
 */

// set execution time
set_time_limit(0); /* unlimited max execution time */


// set system version
define('SYS_VER', '3.4');


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
        # Changing table custom_fields_values fields
        ALTER TABLE `custom_fields_values`
            MODIFY COLUMN `node_type` VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL;

        # Changing table posts_jobs fields
        ALTER TABLE `posts_jobs`
            MODIFY COLUMN `salary_minimum` FLOAT UNSIGNED NOT NULL,
            MODIFY COLUMN `salary_maximum` FLOAT UNSIGNED NOT NULL;

        # Changing table system_countries fields
        ALTER TABLE `system_countries`
            ADD COLUMN `default` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
            ADD COLUMN `enabled` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1',
            ADD COLUMN `country_order` INT(10) UNSIGNED NOT NULL DEFAULT 1;

        # Changing table posts_products fields
        ALTER TABLE `posts_products`
            MODIFY COLUMN `price` FLOAT UNSIGNED NOT NULL DEFAULT 0;

        # Changing table custom_fields fields
        ALTER TABLE `custom_fields`
            MODIFY COLUMN `field_for` VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'user',
            ADD COLUMN `in_search` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0';

        # Changing table users fields
        ALTER TABLE `users`
            ADD COLUMN `user_social_twitch` VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
            MODIFY COLUMN `user_social_linkedin` VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
            ADD COLUMN `user_free_tried` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0';

        # Changing table system_languages fields
        ALTER TABLE `system_languages`
            ADD COLUMN `language_order` INT(10) UNSIGNED NOT NULL DEFAULT 1;

        # Changing table packages fields
        ALTER TABLE `packages`
            ADD COLUMN `package_order` INT(10) UNSIGNED NOT NULL DEFAULT 1;

        # Changing table packages_payments fields
        ALTER TABLE `packages_payments`
            MODIFY COLUMN `package_price` FLOAT UNSIGNED NOT NULL,
            ADD COLUMN `user_id` INT(10) UNSIGNED NOT NULL;
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

    // update table system_countries
    $db->query("UPDATE system_countries SET country_order = country_id") or _error("Error", $db->error);;

    // update table system_countries
    $db->query("UPDATE packages SET package_order = package_id") or _error("Error", $db->error);;

    // insert new system_options values
    $db->query("INSERT INTO system_options (option_name, option_value) VALUES
        ('games_results', '12'),
        ('newsfeed_public', '0'),
        ('search_results', '10'),
        ('auto_play_videos', '1'),
        ('wasabi_enabled', '0'),
        ('wasabi_bucket', ''),
        ('wasabi_region', 'us-west-1'),
        ('wasabi_key', ''),
        ('wasabi_secret', ''),
        ('marketplace_results', '12'),
        ('offers_results', '12'),
        ('jobs_results', '12')") or _error("Error", $db->error);


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
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.14.0/css/all.css" crossorigin="anonymous">
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