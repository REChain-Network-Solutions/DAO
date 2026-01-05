<?php
/**
 * Delus updater
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich
 */

// set system version
define('SYS_VER', '2.5.3');


// set absolut & base path
define('ABSPATH',dirname(__FILE__).'/');
define('BASEPATH',dirname($_SERVER['PHP_SELF']));


// check the config file
if(!file_exists(ABSPATH.'includes/config.php')) {
    /* the config file doesn't exist -> start the installer */
    header('Location: ./install');
}


// get system configurations
require_once(ABSPATH.'includes/config.php');


// enviroment settings
if(DEBUGGING) {
    ini_set("display_errors", true);
    error_reporting(E_ALL ^ E_NOTICE);
} else {
    ini_set("display_errors", false);
    error_reporting(0);
}


// get functions
require_once(ABSPATH.'includes/functions.php');


// connect to the database
$db = new mysqli(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME);
$db->set_charset('utf8');
if(mysqli_connect_error()) {
    _error(DB_ERROR);
}


// install
if(isset($_POST['submit'])) {

    // [0] check valid purchase code
    /* get licence key */
    try {
        $licence_key = get_licence_key($_POST['purchase_code']);
        if(is_empty($_POST['purchase_code']) || $licence_key === false) {
            _error("Error", "Please enter a valid purchase code");
        }
        /* update session hash for AJAX CSRF security */
        $session_hash = $licence_key;
    } catch (Exception $e) {
        _error("Error", $e->getMessage());
    }
    
    
    // [2] update the Delus tables
    $structure = "

CREATE TABLE `ads_campaigns` (
  `campaign_id` int(10) NOT NULL auto_increment,
  `campaign_user_id` int(10) unsigned NOT NULL,
  `campaign_title` varchar(255) NOT NULL,
  `campaign_start_date` datetime NOT NULL,
  `campaign_end_date` datetime NOT NULL,
  `campaign_budget` double NOT NULL,
  `campaign_spend` double NOT NULL DEFAULT 0,
  `campaign_bidding` enum('click','view') NOT NULL,
  `audience_countries` text NOT NULL,
  `audience_gender` varchar(32) NOT NULL,
  `audience_relationship` varchar(64) NOT NULL,
  `ads_title` varchar(255) NULL,
  `ads_description` text NULL,
  `ads_type` varchar(32) NOT NULL,
  `ads_url` varchar(255) NULL,
  `ads_page` int(10) unsigned NULL,
  `ads_group` int(10) unsigned NULL,
  `ads_event` int(10) unsigned NULL,
  `ads_placement` enum('newsfeed','sidebar') NOT NULL,
  `ads_image` varchar(255) NOT NULL,
  `campaign_created_date` datetime NOT NULL,
  `campaign_is_active` enum('0','1') NOT NULL DEFAULT '1',
  `campaign_views` int(10) unsigned NOT NULL DEFAULT '0',
  `campaign_clicks` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`campaign_id`)
) ENGINE=MyISAM row_format=DYNAMIC;

CREATE TABLE `ads_users_wallet_transactions` (
  `transaction_id` int(10) NOT NULL auto_increment,
  `user_id` int(10) unsigned NOT NULL,
  `node_type` varchar(32) NOT NULL,
  `node_id` int(10) unsigned NULL,
  `amount` varchar(32) NOT NULL,
  `type` enum('in','out') NOT NULL,
  `date` datetime NOT NULL,
  PRIMARY KEY (`transaction_id`)
) ENGINE=MyISAM row_format=DYNAMIC;

ALTER TABLE `announcements_users`
  ADD COLUMN `id` int(10) unsigned NOT NULL auto_increment,
  ADD PRIMARY KEY (`id`);

ALTER TABLE `conversations_users`
  ADD COLUMN `id` int(10) unsigned NOT NULL auto_increment,
  ADD PRIMARY KEY (`id`);

ALTER TABLE `custom_fields`
  ADD COLUMN `field_for` enum('user','page','group','event') NOT NULL DEFAULT 'user'
  , ADD COLUMN `field_order` int(10) NOT NULL DEFAULT '1';

ALTER TABLE `events_members`
  ADD COLUMN `id` int(10) unsigned NOT NULL auto_increment,
  ADD PRIMARY KEY (`id`);

ALTER TABLE `followings`
  ADD COLUMN `id` int(10) unsigned NOT NULL auto_increment,
  ADD PRIMARY KEY (`id`);

ALTER TABLE `game_players`
  ADD COLUMN `id` int(10) unsigned NOT NULL auto_increment,
  ADD PRIMARY KEY (`id`);

ALTER TABLE `groups`
  ADD COLUMN `group_category` int(10) unsigned NOT NULL;

CREATE TABLE `groups_admins` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `group_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  UNIQUE KEY `group_id_user_id`(`group_id`,`user_id`),
  PRIMARY KEY (`id`)
) ENGINE=MyISAM row_format=FIXED;

CREATE TABLE `groups_categories` (
  `category_id` int(10) unsigned NOT NULL auto_increment,
  `category_name` varchar(255) NOT NULL,
  PRIMARY KEY (`category_id`)
) ENGINE=MyISAM row_format=DYNAMIC;

INSERT INTO `groups_categories` (`category_id`, `category_name`) VALUES
(1, 'Cars and Vehicles'),
(2, 'Comedy'),
(3, 'Economics and Trade'),
(4, 'Education'),
(5, 'Entertainment'),
(6, 'Movies and Animation'),
(7, 'Gaming'),
(8, 'History and Facts'),
(9, 'Live Style'),
(10, 'Natural'),
(11, 'News and Politics'),
(12, 'People and Nations'),
(13, 'Pets and Animals'),
(14, 'Places and Regions'),
(15, 'Science and Technology'),
(16, 'Sport'),
(17, 'Travel and Events'),
(18, 'Other');

ALTER TABLE `groups_members`
  ADD COLUMN `id` int(10) unsigned NOT NULL auto_increment,
  ADD PRIMARY KEY (`id`);

ALTER TABLE `pages`
  ADD COLUMN `page_boosted_by` int(10) unsigned NULL
  , ADD COLUMN `page_company` varchar(255) NULL
  , ADD COLUMN `page_phone` varchar(255) NULL
  , ADD COLUMN `page_website` varchar(255) NULL
  , ADD COLUMN `page_location` varchar(255) NULL
  , ADD COLUMN `page_action_text` varchar(32) NULL
  , ADD COLUMN `page_action_color` varchar(32) NULL
  , ADD COLUMN `page_action_url` varchar(255) NULL
  , ADD COLUMN `page_social_facebook` varchar(255) NULL
  , ADD COLUMN `page_social_twitter` varchar(255) NULL
  , ADD COLUMN `page_social_google` varchar(255) NULL
  , ADD COLUMN `page_social_youtube` varchar(255) NULL
  , ADD COLUMN `page_social_instagram` varchar(255) NULL
  , ADD COLUMN `page_social_linkedin` varchar(255) NULL
  , ADD COLUMN `page_social_vkontakte` varchar(255) NULL;

CREATE TABLE `pages_admins` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `page_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  UNIQUE KEY `page_id_user_id`(`page_id`,`user_id`),
  PRIMARY KEY (`id`)
) ENGINE=MyISAM row_format=DYNAMIC;

ALTER TABLE `pages_invites`
  ADD COLUMN `id` int(10) unsigned NOT NULL auto_increment,
  ADD PRIMARY KEY (`id`);

ALTER TABLE `pages_likes`
  ADD COLUMN `id` int(10) unsigned NOT NULL auto_increment,
  ADD PRIMARY KEY (`id`);

ALTER TABLE `posts`
  ADD COLUMN `boosted_by` int(10) unsigned NULL;

ALTER TABLE `posts_comments_likes`
  ADD COLUMN `id` int(10) unsigned NOT NULL auto_increment,
  ADD PRIMARY KEY (`id`);

ALTER TABLE `posts_hidden`
  ADD COLUMN `id` int(10) unsigned NOT NULL auto_increment,
  ADD PRIMARY KEY (`id`);

ALTER TABLE `posts_likes`
  ADD COLUMN `id` int(10) unsigned NOT NULL auto_increment,
  ADD PRIMARY KEY (`id`);

ALTER TABLE `posts_photos_likes`
  ADD COLUMN `id` int(10) unsigned NOT NULL auto_increment,
  ADD PRIMARY KEY (`id`);

ALTER TABLE `posts_saved`
  ADD COLUMN `id` int(10) unsigned NOT NULL auto_increment,
  ADD PRIMARY KEY (`id`);

ALTER TABLE `static_pages`
  DROP COLUMN `in_footer`
  , ADD COLUMN `page_in_footer` enum('0','1') NOT NULL DEFAULT '1';

CREATE TABLE `system_countries` (
  `country_id` int(10) unsigned NOT NULL auto_increment,
  `country_code` varchar(2) NOT NULL DEFAULT '',
  `country_name` varchar(64) NOT NULL DEFAULT '',
  PRIMARY KEY (`country_id`)
) ENGINE=MyISAM;

INSERT INTO `system_countries` (`country_id`, `country_code`, `country_name`) VALUES
(1, 'AF', 'Afghanistan'),
(2, 'AL', 'Albania'),
(3, 'DZ', 'Algeria'),
(4, 'DS', 'American Samoa'),
(5, 'AD', 'Andorra'),
(6, 'AO', 'Angola'),
(7, 'AI', 'Anguilla'),
(8, 'AQ', 'Antarctica'),
(9, 'AG', 'Antigua and Barbuda'),
(10, 'AR', 'Argentina'),
(11, 'AM', 'Armenia'),
(12, 'AW', 'Aruba'),
(13, 'AU', 'Australia'),
(14, 'AT', 'Austria'),
(15, 'AZ', 'Azerbaijan'),
(16, 'BS', 'Bahamas'),
(17, 'BH', 'Bahrain'),
(18, 'BD', 'Bangladesh'),
(19, 'BB', 'Barbados'),
(20, 'BY', 'Belarus'),
(21, 'BE', 'Belgium'),
(22, 'BZ', 'Belize'),
(23, 'BJ', 'Benin'),
(24, 'BM', 'Bermuda'),
(25, 'BT', 'Bhutan'),
(26, 'BO', 'Bolivia'),
(27, 'BA', 'Bosnia and Herzegovina'),
(28, 'BW', 'Botswana'),
(29, 'BV', 'Bouvet Island'),
(30, 'BR', 'Brazil'),
(31, 'IO', 'British Indian Ocean Territory'),
(32, 'BN', 'Brunei Darussalam'),
(33, 'BG', 'Bulgaria'),
(34, 'BF', 'Burkina Faso'),
(35, 'BI', 'Burundi'),
(36, 'KH', 'Cambodia'),
(37, 'CM', 'Cameroon'),
(38, 'CA', 'Canada'),
(39, 'CV', 'Cape Verde'),
(40, 'KY', 'Cayman Islands'),
(41, 'CF', 'Central African Republic'),
(42, 'TD', 'Chad'),
(43, 'CL', 'Chile'),
(44, 'CN', 'China'),
(45, 'CX', 'Christmas Island'),
(46, 'CC', 'Cocos (Keeling) Islands'),
(47, 'CO', 'Colombia'),
(48, 'KM', 'Comoros'),
(49, 'CG', 'Congo'),
(50, 'CK', 'Cook Islands'),
(51, 'CR', 'Costa Rica'),
(52, 'HR', 'Croatia (Hrvatska)'),
(53, 'CU', 'Cuba'),
(54, 'CY', 'Cyprus'),
(55, 'CZ', 'Czech Republic'),
(56, 'DK', 'Denmark'),
(57, 'DJ', 'Djibouti'),
(58, 'DM', 'Dominica'),
(59, 'DO', 'Dominican Republic'),
(60, 'TP', 'East Timor'),
(61, 'EC', 'Ecuador'),
(62, 'EG', 'Egypt'),
(63, 'SV', 'El Salvador'),
(64, 'GQ', 'Equatorial Guinea'),
(65, 'ER', 'Eritrea'),
(66, 'EE', 'Estonia'),
(67, 'ET', 'Ethiopia'),
(68, 'FK', 'Falkland Islands (Malvinas)'),
(69, 'FO', 'Faroe Islands'),
(70, 'FJ', 'Fiji'),
(71, 'FI', 'Finland'),
(72, 'FR', 'France'),
(73, 'FX', 'France, Metropolitan'),
(74, 'GF', 'French Guiana'),
(75, 'PF', 'French Polynesia'),
(76, 'TF', 'French Southern Territories'),
(77, 'GA', 'Gabon'),
(78, 'GM', 'Gambia'),
(79, 'GE', 'Georgia'),
(80, 'DE', 'Germany'),
(81, 'GH', 'Ghana'),
(82, 'GI', 'Gibraltar'),
(83, 'GK', 'Guernsey'),
(84, 'GR', 'Greece'),
(85, 'GL', 'Greenland'),
(86, 'GD', 'Grenada'),
(87, 'GP', 'Guadeloupe'),
(88, 'GU', 'Guam'),
(89, 'GT', 'Guatemala'),
(90, 'GN', 'Guinea'),
(91, 'GW', 'Guinea-Bissau'),
(92, 'GY', 'Guyana'),
(93, 'HT', 'Haiti'),
(94, 'HM', 'Heard and Mc Donald Islands'),
(95, 'HN', 'Honduras'),
(96, 'HK', 'Hong Kong'),
(97, 'HU', 'Hungary'),
(98, 'IS', 'Iceland'),
(99, 'IN', 'India'),
(100, 'IM', 'Isle of Man'),
(101, 'ID', 'Indonesia'),
(102, 'IR', 'Iran (Islamic Republic of)'),
(103, 'IQ', 'Iraq'),
(104, 'IE', 'Ireland'),
(105, 'IL', 'Israel'),
(106, 'IT', 'Italy'),
(107, 'CI', 'Ivory Coast'),
(108, 'JE', 'Jersey'),
(109, 'JM', 'Jamaica'),
(110, 'JP', 'Japan'),
(111, 'JO', 'Jordan'),
(112, 'KZ', 'Kazakhstan'),
(113, 'KE', 'Kenya'),
(114, 'KI', 'Kiribati'),
(115, 'KP', 'Korea, Democratic People\'s Republic of'),
(116, 'KR', 'Korea, Republic of'),
(117, 'XK', 'Kosovo'),
(118, 'KW', 'Kuwait'),
(119, 'KG', 'Kyrgyzstan'),
(120, 'LA', 'Lao People\'s Democratic Republic'),
(121, 'LV', 'Latvia'),
(122, 'LB', 'Lebanon'),
(123, 'LS', 'Lesotho'),
(124, 'LR', 'Liberia'),
(125, 'LY', 'Libyan Arab Jamahiriya'),
(126, 'LI', 'Liechtenstein'),
(127, 'LT', 'Lithuania'),
(128, 'LU', 'Luxembourg'),
(129, 'MO', 'Macau'),
(130, 'MK', 'Macedonia'),
(131, 'MG', 'Madagascar'),
(132, 'MW', 'Malawi'),
(133, 'MY', 'Malaysia'),
(134, 'MV', 'Maldives'),
(135, 'ML', 'Mali'),
(136, 'MT', 'Malta'),
(137, 'MH', 'Marshall Islands'),
(138, 'MQ', 'Martinique'),
(139, 'MR', 'Mauritania'),
(140, 'MU', 'Mauritius'),
(141, 'TY', 'Mayotte'),
(142, 'MX', 'Mexico'),
(143, 'FM', 'Micronesia, Federated States of'),
(144, 'MD', 'Moldova, Republic of'),
(145, 'MC', 'Monaco'),
(146, 'MN', 'Mongolia'),
(147, 'ME', 'Montenegro'),
(148, 'MS', 'Montserrat'),
(149, 'MA', 'Morocco'),
(150, 'MZ', 'Mozambique'),
(151, 'MM', 'Myanmar'),
(152, 'NA', 'Namibia'),
(153, 'NR', 'Nauru'),
(154, 'NP', 'Nepal'),
(155, 'NL', 'Netherlands'),
(156, 'AN', 'Netherlands Antilles'),
(157, 'NC', 'New Caledonia'),
(158, 'NZ', 'New Zealand'),
(159, 'NI', 'Nicaragua'),
(160, 'NE', 'Niger'),
(161, 'NG', 'Nigeria'),
(162, 'NU', 'Niue'),
(163, 'NF', 'Norfolk Island'),
(164, 'MP', 'Northern Mariana Islands'),
(165, 'NO', 'Norway'),
(166, 'OM', 'Oman'),
(167, 'PK', 'Pakistan'),
(168, 'PW', 'Palau'),
(169, 'PS', 'Palestine'),
(170, 'PA', 'Panama'),
(171, 'PG', 'Papua New Guinea'),
(172, 'PY', 'Paraguay'),
(173, 'PE', 'Peru'),
(174, 'PH', 'Philippines'),
(175, 'PN', 'Pitcairn'),
(176, 'PL', 'Poland'),
(177, 'PT', 'Portugal'),
(178, 'PR', 'Puerto Rico'),
(179, 'QA', 'Qatar'),
(180, 'RE', 'Reunion'),
(181, 'RO', 'Romania'),
(182, 'RU', 'Russian Federation'),
(183, 'RW', 'Rwanda'),
(184, 'KN', 'Saint Kitts and Nevis'),
(185, 'LC', 'Saint Lucia'),
(186, 'VC', 'Saint Vincent and the Grenadines'),
(187, 'WS', 'Samoa'),
(188, 'SM', 'San Marino'),
(189, 'ST', 'Sao Tome and Principe'),
(190, 'SA', 'Saudi Arabia'),
(191, 'SN', 'Senegal'),
(192, 'RS', 'Serbia'),
(193, 'SC', 'Seychelles'),
(194, 'SL', 'Sierra Leone'),
(195, 'SG', 'Singapore'),
(196, 'SK', 'Slovakia'),
(197, 'SI', 'Slovenia'),
(198, 'SB', 'Solomon Islands'),
(199, 'SO', 'Somalia'),
(200, 'ZA', 'South Africa'),
(201, 'GS', 'South Georgia South Sandwich Islands'),
(202, 'ES', 'Spain'),
(203, 'LK', 'Sri Lanka'),
(204, 'SH', 'St. Helena'),
(205, 'PM', 'St. Pierre and Miquelon'),
(206, 'SD', 'Sudan'),
(207, 'SR', 'Suriname'),
(208, 'SJ', 'Svalbard and Jan Mayen Islands'),
(209, 'SZ', 'Swaziland'),
(210, 'SE', 'Sweden'),
(211, 'CH', 'Switzerland'),
(212, 'SY', 'Syrian Arab Republic'),
(213, 'TW', 'Taiwan'),
(214, 'TJ', 'Tajikistan'),
(215, 'TZ', 'Tanzania, United Republic of'),
(216, 'TH', 'Thailand'),
(217, 'TG', 'Togo'),
(218, 'TK', 'Tokelau'),
(219, 'TO', 'Tonga'),
(220, 'TT', 'Trinidad and Tobago'),
(221, 'TN', 'Tunisia'),
(222, 'TR', 'Turkey'),
(223, 'TM', 'Turkmenistan'),
(224, 'TC', 'Turks and Caicos Islands'),
(225, 'TV', 'Tuvalu'),
(226, 'UG', 'Uganda'),
(227, 'UA', 'Ukraine'),
(228, 'AE', 'United Arab Emirates'),
(229, 'GB', 'United Kingdom'),
(230, 'US', 'United States'),
(231, 'UM', 'United States minor outlying islands'),
(232, 'UY', 'Uruguay'),
(233, 'UZ', 'Uzbekistan'),
(234, 'VU', 'Vanuatu'),
(235, 'VA', 'Vatican City State'),
(236, 'VE', 'Venezuela'),
(237, 'VN', 'Vietnam'),
(238, 'VG', 'Virgin Islands (British)'),
(239, 'VI', 'Virgin Islands (U.S.)'),
(240, 'WF', 'Wallis and Futuna Islands'),
(241, 'EH', 'Western Sahara'),
(242, 'YE', 'Yemen'),
(243, 'ZR', 'Zaire'),
(244, 'ZM', 'Zambia'),
(245, 'ZW', 'Zimbabwe');

ALTER TABLE `system_options`
  DROP COLUMN `bitcoin_enabled`
  , ADD COLUMN `post_translation_enabled` enum('0','1') NOT NULL DEFAULT '0'
  , ADD COLUMN `yandex_key` varchar(255) NULL
  , ADD COLUMN `custome_js_header` text NOT NULL
  , ADD COLUMN `custome_js_footer` text NOT NULL
  , ADD COLUMN `ads_enabled` enum('0','1') NOT NULL DEFAULT '0'
  , ADD COLUMN `ads_cost_click` varchar(32) NOT NULL DEFAULT '0.05'
  , ADD COLUMN `ads_cost_view` varchar(32) NOT NULL DEFAULT '0.01';
  
ALTER TABLE `users`
  ADD COLUMN `user_country` int(10) unsigned NULL
  , ADD COLUMN `user_work_url` varchar(255) NULL
  , ADD COLUMN `user_wallet_balance` varchar(64) NOT NULL DEFAULT '0';

ALTER TABLE `users_blocks`
  ADD COLUMN `id` int(10) unsigned NOT NULL auto_increment,
  ADD PRIMARY KEY (`id`);

ALTER TABLE `users_online`
  ADD COLUMN `id` int(10) unsigned NOT NULL auto_increment,
  ADD PRIMARY KEY (`id`);

ALTER TABLE `ads` RENAME TO `ads_system`;

ALTER TABLE `users_custom_fields` RENAME TO `custom_fields_values`;

ALTER TABLE `custom_fields_values`
  ADD COLUMN `value_id` int(10) unsigned NOT NULL auto_increment
  , ADD COLUMN `node_id` int(10) unsigned NOT NULL
  , ADD COLUMN `node_type` enum('user','page','group','event') NOT NULL
  , ADD PRIMARY KEY (`value_id`)
  , DROP INDEX `user_id_field_id`;

ALTER TABLE `users_polls_options` RENAME TO `posts_polls_options_users`;

ALTER TABLE `posts_polls_options_users`
  ADD COLUMN `id` int(10) unsigned NOT NULL auto_increment,
  ADD PRIMARY KEY (`id`)

";
    

    $db->multi_query($structure) or _error("Error", $db->error);
    // flush multi_queries
    do{} while(mysqli_more_results($db) && mysqli_next_result($db));


    // [5] update system settings
    $db->query(sprintf("UPDATE system_options SET session_hash = %s", secure($session_hash) )) or _error("Error #103", $db->error);


    // [6] update pages & groups admins
    $get_pages = $db->query("SELECT page_id, page_admin FROM pages") or _error("Error #104", $db->error);
    if($get_pages->num_rows > 0) {
        while($_page = $get_pages->fetch_assoc()) {
            $db->query(sprintf("INSERT INTO pages_admins (page_id, user_id) VALUES (%s, %s)", secure($_page['page_id'], 'int'), secure($_page['page_admin'], 'int') ));
        }
    }
    $get_groups = $db->query("SELECT group_id, group_admin FROM groups") or _error("Error #105", $db->error);
    if($get_groups->num_rows > 0) {
        while($_group = $get_groups->fetch_assoc()) {
            $db->query(sprintf("INSERT INTO groups_admins (group_id, user_id) VALUES (%s, %s)", secure($_group['group_id'], 'int'), secure($_group['group_admin'], 'int') ));
        }
    }

     // [7] create config file
    $config_string = '<?php  
    define("DB_NAME", "'.DB_NAME. '");
    define("DB_USER", "'.DB_USER. '");
    define("DB_PASSWORD", "'.DB_PASSWORD. '");
    define("DB_HOST", "'.DB_HOST. '");
    define("SYS_URL", "'. get_system_url(). '");
    define("DEBUGGING", false);
    define("DEFAULT_LOCALE", "en_us");
    define("LICENCE_KEY", "'. $licence_key. '");
    
    ?>';
    
    $config_file = 'includes/config.php';
    $handle = fopen($config_file, 'w') or _error("System Error", "Cannot create the config file");
    
    fwrite($handle, $config_string);
    fclose($handle);

    // [8] Done
    _error("System Updated", "Delus has been updated to 2.5.3");
}

?>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge"> 
        <meta name="viewport" content="width=device-width, initial-scale=1"> 
        
        <title>Delus v2.5.3 &rsaquo; Update</title>
        
        <link rel="stylesheet" type="text/css" href="includes/assets/js/Delus/installer/installer.css" />
        <script src="includes/assets/js/Delus/installer/modernizr.custom.js"></script>
    </head>

    <body>
        
        <div class="container">

            <div class="fs-form-wrap" id="fs-form-wrap">
                
                <div class="fs-title">
                    <h1>Delus v2.5.3 Update</h1>
                </div>
                
                <form id="myform" class="fs-form fs-form-full" autocomplete="off" action="update.php" method="post">
                    <ol class="fs-fields">

                        <li>
                            <p class="fs-field-label fs-anim-upper">
                                Welcome to <strong>Delus</strong> updating process! Just fill in the information below.
                            </p>
                        </li>

                        <li>
                            <label class="fs-field-label fs-anim-upper" for="purchase_code" data-info="The purchase code of Delus">Purchase Code</label>
                            <input class="fs-anim-lower" id="purchase_code" name="purchase_code" type="text" placeholder="xxx-xx-xxxx" required/>
                        </li>

                    </ol>
                    <button class="fs-submit" name="submit" type="submit">Update</button>
                </form>

            </div>

        </div>
        
        <script src="includes/assets/js/Delus/installer/classie.js"></script>
        <script src="includes/assets/js/Delus/installer/fullscreenForm.js"></script>
        <script>
            (function() {
                var formWrap = document.getElementById( 'fs-form-wrap' );
                new FForm( formWrap, {
                    onReview : function() {
                        classie.add( document.body, 'overview' );
                    }
                } );
            })();
        </script>

    </body>
</html>