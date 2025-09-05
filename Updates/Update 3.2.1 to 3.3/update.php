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
define('SYS_VER', '3.3');


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
        CREATE TABLE `users_affiliates` (
        `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
        `referrer_id` int(10) unsigned NOT NULL,
        `referee_id` int(10) unsigned NOT NULL,
        PRIMARY KEY (`id`) USING BTREE,
        UNIQUE KEY `referrer_id_referee_id` (`referrer_id`,`referee_id`) USING BTREE
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

        # Changing table users fields
        ALTER TABLE `users`
            ADD COLUMN `user_banned_message` TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL  COMMENT '' AFTER `user_banned`,
            MODIFY COLUMN `user_live_requests_counter` INT(10) UNSIGNED NOT NULL DEFAULT 0  COMMENT '' AFTER `user_banned_message`,
            ADD COLUMN `points_earned` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `user_referrer_id`,
            MODIFY COLUMN `user_affiliate_balance` FLOAT NOT NULL DEFAULT 0  COMMENT '' AFTER `points_earned`;

        # Changing table packages fields
        ALTER TABLE `packages`
            ADD COLUMN `custom_description` TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL  COMMENT '' AFTER `boost_pages`;

        # Changing table invitation_codes fields
        ALTER TABLE `invitation_codes`
            MODIFY COLUMN `used_by` INT(10) UNSIGNED NULL DEFAULT NULL  COMMENT '' AFTER `created_date`,
            MODIFY COLUMN `used_date` DATETIME NULL DEFAULT NULL  COMMENT '' AFTER `used_by`;

        # Changing table ads_campaigns fields
        ALTER TABLE `ads_campaigns`
            ADD COLUMN `campaign_is_approved` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `campaign_is_active`,
            ADD COLUMN `campaign_is_declined` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `campaign_is_approved`,
            MODIFY COLUMN `campaign_views` INT(10) UNSIGNED NOT NULL DEFAULT 0  COMMENT '' AFTER `campaign_is_declined`;

        # Changing table followings fields
        ALTER TABLE `followings`
            ADD COLUMN `points_earned` ENUM('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0'  COMMENT '' AFTER `following_id`,
            ADD COLUMN `time` DATETIME NULL DEFAULT NULL  COMMENT '' AFTER `points_earned`;

        # Changing table system_countries fields
        ALTER TABLE `system_countries`
            ADD COLUMN `phone_code` VARCHAR(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL  COMMENT '' AFTER `country_name`;
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

    // empty table system_countries
    $db->query("TRUNCATE system_countries") or _error("SQL_ERROR_THROWEN");


    // insert new system_countries
    $db->query("
        INSERT INTO `system_countries` (`country_id`, `country_code`, `country_name`, `phone_code`) VALUES
            (1, 'AF', 'Afghanistan', '+93'),
            (2, 'AL', 'Albania', '+355'),
            (3, 'DZ', 'Algeria', '+213'),
            (4, 'DS', 'American Samoa', '+1684'),
            (5, 'AD', 'Andorra', '+376'),
            (6, 'AO', 'Angola', '+244'),
            (7, 'AI', 'Anguilla', '+1264'),
            (8, 'AQ', 'Antarctica', '+672'),
            (9, 'AG', 'Antigua and Barbuda', '+1268'),
            (10, 'AR', 'Argentina', '+54'),
            (11, 'AM', 'Armenia', '+374'),
            (12, 'AW', 'Aruba', '+297'),
            (13, 'AU', 'Australia', '+61'),
            (14, 'AT', 'Austria', '+43'),
            (15, 'AZ', 'Azerbaijan', '+994'),
            (16, 'BS', 'Bahamas', '+1242'),
            (17, 'BH', 'Bahrain', '+973'),
            (18, 'BD', 'Bangladesh', '+880'),
            (19, 'BB', 'Barbados', '+1246'),
            (20, 'BY', 'Belarus', '+375'),
            (21, 'BE', 'Belgium', '+32'),
            (22, 'BZ', 'Belize', '+501'),
            (23, 'BJ', 'Benin', '+229'),
            (24, 'BM', 'Bermuda', '+1441'),
            (25, 'BT', 'Bhutan', '+975'),
            (26, 'BO', 'Bolivia', '+591'),
            (27, 'BA', 'Bosnia and Herzegovina', '+387'),
            (28, 'BW', 'Botswana', '+267'),
            (29, 'BV', 'Bouvet Island', '+55'),
            (30, 'BR', 'Brazil', '+55'),
            (31, 'IO', 'British Indian Ocean Territory', '+246'),
            (32, 'BN', 'Brunei Darussalam', '+673'),
            (33, 'BG', 'Bulgaria', '+359'),
            (34, 'BF', 'Burkina Faso', '+226'),
            (35, 'BI', 'Burundi', '+257'),
            (36, 'KH', 'Cambodia', '+855'),
            (37, 'CM', 'Cameroon', '+237'),
            (38, 'CA', 'Canada', '+1'),
            (39, 'CV', 'Cape Verde', '+238'),
            (40, 'KY', 'Cayman Islands', '+ 345'),
            (41, 'CF', 'Central African Republic', '+236'),
            (42, 'TD', 'Chad', '+235'),
            (43, 'CL', 'Chile', '+56'),
            (44, 'CN', 'China', '+86'),
            (45, 'CX', 'Christmas Island', '+61'),
            (46, 'CC', 'Cocos (Keeling) Islands', '+61'),
            (47, 'CO', 'Colombia', '+57'),
            (48, 'KM', 'Comoros', '+269'),
            (49, 'CG', 'Congo', '+242'),
            (50, 'CK', 'Cook Islands', '+682'),
            (51, 'CR', 'Costa Rica', '+506'),
            (52, 'HR', 'Croatia (Hrvatska)', '+385'),
            (53, 'CU', 'Cuba', '+53'),
            (54, 'CY', 'Cyprus', '+357'),
            (55, 'CZ', 'Czech Republic', '+420'),
            (56, 'DK', 'Denmark', '+45'),
            (57, 'DJ', 'Djibouti', '+253'),
            (58, 'DM', 'Dominica', '+1767'),
            (59, 'DO', 'Dominican Republic', '+1849'),
            (60, 'TP', 'East Timor', NULL),
            (61, 'EC', 'Ecuador', '+593'),
            (62, 'EG', 'Egypt', '+20'),
            (63, 'SV', 'El Salvador', '+503'),
            (64, 'GQ', 'Equatorial Guinea', '+240'),
            (65, 'ER', 'Eritrea', '+291'),
            (66, 'EE', 'Estonia', '+372'),
            (67, 'ET', 'Ethiopia', '+251'),
            (68, 'FK', 'Falkland Islands (Malvinas)', '+500'),
            (69, 'FO', 'Faroe Islands', '+298'),
            (70, 'FJ', 'Fiji', '+679'),
            (71, 'FI', 'Finland', '+358'),
            (72, 'FR', 'France', '+33'),
            (73, 'FX', 'France, Metropolitan', NULL),
            (74, 'GF', 'French Guiana', '+594'),
            (75, 'PF', 'French Polynesia', '+689'),
            (76, 'TF', 'French Southern Territories', '+262'),
            (77, 'GA', 'Gabon', '+241'),
            (78, 'GM', 'Gambia', '+220'),
            (79, 'GE', 'Georgia', '+995'),
            (80, 'DE', 'Germany', '+49'),
            (81, 'GH', 'Ghana', '+233'),
            (82, 'GI', 'Gibraltar', '+350'),
            (83, 'GK', 'Guernsey', '+44'),
            (84, 'GR', 'Greece', '+30'),
            (85, 'GL', 'Greenland', '+299'),
            (86, 'GD', 'Grenada', '+1473'),
            (87, 'GP', 'Guadeloupe', '+590'),
            (88, 'GU', 'Guam', '+1671'),
            (89, 'GT', 'Guatemala', '+502'),
            (90, 'GN', 'Guinea', '+224'),
            (91, 'GW', 'Guinea-Bissau', '+245'),
            (92, 'GY', 'Guyana', '+595'),
            (93, 'HT', 'Haiti', '+509'),
            (94, 'HM', 'Heard and Mc Donald Islands', NULL),
            (95, 'HN', 'Honduras', '+504'),
            (96, 'HK', 'Hong Kong', '+852'),
            (97, 'HU', 'Hungary', '+36'),
            (98, 'IS', 'Iceland', '+354'),
            (99, 'IN', 'India', '+91'),
            (100, 'IM', 'Isle of Man', '+44'),
            (101, 'ID', 'Indonesia', '+62'),
            (102, 'IR', 'Iran (Islamic Republic of)', '+98'),
            (103, 'IQ', 'Iraq', '+964'),
            (104, 'IE', 'Ireland', '+353'),
            (105, 'IL', 'Israel', '+972'),
            (106, 'IT', 'Italy', '+39'),
            (107, 'CI', 'Ivory Coast', NULL),
            (108, 'JE', 'Jersey', '+44'),
            (109, 'JM', 'Jamaica', '+1876'),
            (110, 'JP', 'Japan', '+81'),
            (111, 'JO', 'Jordan', '+962'),
            (112, 'KZ', 'Kazakhstan', '+77'),
            (113, 'KE', 'Kenya', '+254'),
            (114, 'KI', 'Kiribati', '+686'),
            (115, 'KP', 'Korea, Democratic People\'s Republic of', '+850'),
            (116, 'KR', 'Korea, Republic of', '+82'),
            (117, 'XK', 'Kosovo', '+381'),
            (118, 'KW', 'Kuwait', '+965'),
            (119, 'KG', 'Kyrgyzstan', '+996'),
            (120, 'LA', 'Lao People\'s Democratic Republic', '+856'),
            (121, 'LV', 'Latvia', '+371'),
            (122, 'LB', 'Lebanon', '+961'),
            (123, 'LS', 'Lesotho', '+266'),
            (124, 'LR', 'Liberia', '+231'),
            (125, 'LY', 'Libyan Arab Jamahiriya', '+218'),
            (126, 'LI', 'Liechtenstein', '+423'),
            (127, 'LT', 'Lithuania', '+370'),
            (128, 'LU', 'Luxembourg', '+352'),
            (129, 'MO', 'Macau', '+853'),
            (130, 'MK', 'Macedonia', '+389'),
            (131, 'MG', 'Madagascar', '+261'),
            (132, 'MW', 'Malawi', '+265'),
            (133, 'MY', 'Malaysia', '+60'),
            (134, 'MV', 'Maldives', '+960'),
            (135, 'ML', 'Mali', '+223'),
            (136, 'MT', 'Malta', '+356'),
            (137, 'MH', 'Marshall Islands', '+692'),
            (138, 'MQ', 'Martinique', '+596'),
            (139, 'MR', 'Mauritania', '+222'),
            (140, 'MU', 'Mauritius', '+230'),
            (141, 'TY', 'Mayotte', '+269'),
            (142, 'MX', 'Mexico', '+52'),
            (143, 'FM', 'Micronesia, Federated States of', '+691'),
            (144, 'MD', 'Moldova, Republic of', '+373'),
            (145, 'MC', 'Monaco', '+377'),
            (146, 'MN', 'Mongolia', '+976'),
            (147, 'ME', 'Montenegro', '+382'),
            (148, 'MS', 'Montserrat', '+1664'),
            (149, 'MA', 'Morocco', '+212'),
            (150, 'MZ', 'Mozambique', '+258'),
            (151, 'MM', 'Myanmar', '+95'),
            (152, 'NA', 'Namibia', '+264'),
            (153, 'NR', 'Nauru', '+674'),
            (154, 'NP', 'Nepal', '+977'),
            (155, 'NL', 'Netherlands', '+31'),
            (156, 'AN', 'Netherlands Antilles', '+599'),
            (157, 'NC', 'New Caledonia', '+687'),
            (158, 'NZ', 'New Zealand', '+64'),
            (159, 'NI', 'Nicaragua', '+505'),
            (160, 'NE', 'Niger', '+227'),
            (161, 'NG', 'Nigeria', '+234'),
            (162, 'NU', 'Niue', '+683'),
            (163, 'NF', 'Norfolk Island', '+672'),
            (164, 'MP', 'Northern Mariana Islands', '+1670'),
            (165, 'NO', 'Norway', '+47'),
            (166, 'OM', 'Oman', '+968'),
            (167, 'PK', 'Pakistan', '+92'),
            (168, 'PW', 'Palau', '+680'),
            (169, 'PS', 'Palestine', '+970'),
            (170, 'PA', 'Panama', '+507'),
            (171, 'PG', 'Papua New Guinea', '+675'),
            (172, 'PY', 'Paraguay', '+595'),
            (173, 'PE', 'Peru', '+51'),
            (174, 'PH', 'Philippines', '+63'),
            (175, 'PN', 'Pitcairn', '+872'),
            (176, 'PL', 'Poland', '+48'),
            (177, 'PT', 'Portugal', '+351'),
            (178, 'PR', 'Puerto Rico', '+1939'),
            (179, 'QA', 'Qatar', '+974'),
            (180, 'RE', 'Reunion', '+262'),
            (181, 'RO', 'Romania', '+40'),
            (182, 'RU', 'Russian Federation', '+7'),
            (183, 'RW', 'Rwanda', '+250'),
            (184, 'KN', 'Saint Kitts and Nevis', '+1869'),
            (185, 'LC', 'Saint Lucia', '+1758'),
            (186, 'VC', 'Saint Vincent and the Grenadines', '+1784'),
            (187, 'WS', 'Samoa', '+685'),
            (188, 'SM', 'San Marino', '+378'),
            (189, 'ST', 'Sao Tome and Principe', '+239'),
            (190, 'SA', 'Saudi Arabia', '+966'),
            (191, 'SN', 'Senegal', '+221'),
            (192, 'RS', 'Serbia', '+381'),
            (193, 'SC', 'Seychelles', '+248'),
            (194, 'SL', 'Sierra Leone', '+232'),
            (195, 'SG', 'Singapore', '+65'),
            (196, 'SK', 'Slovakia', '+421'),
            (197, 'SI', 'Slovenia', '+386'),
            (198, 'SB', 'Solomon Islands', '+677'),
            (199, 'SO', 'Somalia', '+252'),
            (200, 'ZA', 'South Africa', '+27'),
            (201, 'GS', 'South Georgia South Sandwich Islands', '+500'),
            (202, 'ES', 'Spain', '+34'),
            (203, 'LK', 'Sri Lanka', '+94'),
            (204, 'SH', 'St. Helena', '+290'),
            (205, 'PM', 'St. Pierre and Miquelon', '+508'),
            (206, 'SD', 'Sudan', '+249'),
            (207, 'SR', 'Suriname', '+597'),
            (208, 'SJ', 'Svalbard and Jan Mayen Islands', '+47'),
            (209, 'SZ', 'Swaziland', '+268'),
            (210, 'SE', 'Sweden', '+46'),
            (211, 'CH', 'Switzerland', '+41'),
            (212, 'SY', 'Syrian Arab Republic', '+963'),
            (213, 'TW', 'Taiwan', '+886'),
            (214, 'TJ', 'Tajikistan', '+992'),
            (215, 'TZ', 'Tanzania, United Republic of', '+255'),
            (216, 'TH', 'Thailand', '+66'),
            (217, 'TG', 'Togo', '+228'),
            (218, 'TK', 'Tokelau', '+690'),
            (219, 'TO', 'Tonga', '+676'),
            (220, 'TT', 'Trinidad and Tobago', '+1868'),
            (221, 'TN', 'Tunisia', '+216'),
            (222, 'TR', 'Turkey', '+90'),
            (223, 'TM', 'Turkmenistan', '+993'),
            (224, 'TC', 'Turks and Caicos Islands', '+1649'),
            (225, 'TV', 'Tuvalu', '+688'),
            (226, 'UG', 'Uganda', '+256'),
            (227, 'UA', 'Ukraine', '+380'),
            (228, 'AE', 'United Arab Emirates', '+971'),
            (229, 'GB', 'United Kingdom', '+44'),
            (230, 'US', 'United States', '+1'),
            (231, 'UM', 'United States minor outlying islands', '+1'),
            (232, 'UY', 'Uruguay', '+598'),
            (233, 'UZ', 'Uzbekistan', '+998'),
            (234, 'VU', 'Vanuatu', '+678'),
            (235, 'VA', 'Vatican City State', '+379'),
            (236, 'VE', 'Venezuela', '+58'),
            (237, 'VN', 'Vietnam', '+84'),
            (238, 'VG', 'Virgin Islands (British)', '+1284'),
            (239, 'VI', 'Virgin Islands (U.S.)', '+1340'),
            (240, 'WF', 'Wallis and Futuna Islands', '+681'),
            (241, 'EH', 'Western Sahara', '+212'),
            (242, 'YE', 'Yemen', '+967'),
            (243, 'ZR', 'Zaire', NULL),
            (244, 'ZM', 'Zambia', '+260'),
            (245, 'ZW', 'Zimbabwe', '+263');
        ") or _error("SQL_ERROR_THROWEN");


    // insert new system_options values
    $db->query("INSERT INTO system_options (option_name, option_value) VALUES
        ('points_per_follow', '5'),
        ('points_per_referred', '5'),
        ('newsfeed_results', '10'),
        ('ads_approval_enabled', '1'),
        ('uploads_cdn_url', '0'),
        ('affiliates_levels', '5'),
        ('voice_notes_durtaion', '120'),
        ('voice_notes_encoding', 'mp3'),
        ('pages_results', '12'),
        ('groups_results', '12'),
        ('events_results', '12'),
        ('system_currency_dir', 'left')") or _error("Error", $db->error);


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
    <script src="https://code.jquery.com/jquery-3.5.1.min.js" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
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