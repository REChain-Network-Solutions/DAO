<?php

/**
 * admin
 * 
 * @package Sngine
 * @author Zamblek
 */

// set override_shutdown
$override_shutdown = true;

// fetch bootloader
require('bootloader.php');

// user access
user_access();

// check admin|moderator permission
if (!$user->_is_admin && !$user->_is_moderator) {
  _error(__('System Message'), __("You don't have the right permission to access this"));
}

// check moderator mode
if ($user->_is_moderator && !$moderator_mode) {
  /* moderator try to access admin panel */
  _error(__('System Message'), __("You don't have the right permission to access this"));
}

try {

  // get view content
  switch ($_GET['view']) {
    case '':
      // update view
      $_GET['view'] = 'dashboard';

      // page header
      page_header($control_panel['title'] . " " . __("Panel"));

      // get insights
      $insights = [];
      /* total users */
      $get_users = $db->query("SELECT COUNT(*) as count FROM users");
      $insights['users'] = $get_users->fetch_assoc()['count'];
      /* pending */
      $get_pending = $db->query("SELECT COUNT(*) as count FROM users WHERE user_approved = '0'");
      $insights['pending'] = $get_pending->fetch_assoc()['count'];
      /* not activated */
      $get_not_activated = $db->query("SELECT COUNT(*) as count FROM users WHERE user_activated = '0'");
      $insights['not_activated'] = $get_not_activated->fetch_assoc()['count'];
      /* banned */
      $get_banned = $db->query("SELECT COUNT(*) as count FROM users WHERE user_banned = '1'");
      $insights['banned'] = $get_banned->fetch_assoc()['count'];
      /* online */
      $get_online = $db->query(sprintf("SELECT COUNT(*) as count FROM users WHERE user_last_seen >= SUBTIME(NOW(), SEC_TO_TIME(%s))", secure($system['offline_time'], 'int', false)));
      $insights['online'] = $get_online->fetch_assoc()['count'];
      /* users this month / last month */
      $get_users_month = $db->query("SELECT COUNT(*) as count FROM users WHERE YEAR(user_registered) = YEAR(CURRENT_DATE()) AND MONTH(user_registered) = MONTH(CURRENT_DATE())");
      $insights['users_month'] = $get_users_month->fetch_assoc()['count'];
      $get_users_last_month = $db->query("SELECT COUNT(*) as count FROM users WHERE user_registered >= DATE_FORMAT(DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH), '%Y-%m-01') AND user_registered < DATE_FORMAT(CURRENT_DATE(), '%Y-%m-01')");
      $insights['users_last_month'] = $get_users_last_month->fetch_assoc()['count'];
      /* posts this month / last month */
      $get_posts_month = $db->query("SELECT COUNT(*) as count FROM posts WHERE YEAR(time) = YEAR(CURRENT_DATE()) AND MONTH(time) = MONTH(CURRENT_DATE())");
      $insights['posts_month'] = $get_posts_month->fetch_assoc()['count'];
      $get_posts_last_month = $db->query("SELECT COUNT(*) as count FROM posts WHERE time >= DATE_FORMAT(DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH), '%Y-%m-01') AND time < DATE_FORMAT(CURRENT_DATE(), '%Y-%m-01')");
      $insights['posts_last_month'] = $get_posts_last_month->fetch_assoc()['count'];
      /* month-over-month % (null when last month is 0) */
      $insights['users_month_pct'] = ($insights['users_last_month'] > 0) ? round((($insights['users_month'] - $insights['users_last_month']) / $insights['users_last_month']) * 100, 1) : null;
      $insights['posts_month_pct'] = ($insights['posts_last_month'] > 0) ? round((($insights['posts_month'] - $insights['posts_last_month']) / $insights['posts_last_month']) * 100, 1) : null;
      /* posts */
      $get_posts = $db->query("SELECT COUNT(*) as count FROM posts");
      $insights['posts'] = $get_posts->fetch_assoc()['count'];
      /* comments */
      $get_comments = $db->query("SELECT COUNT(*) as count FROM posts_comments");
      $insights['comments'] = $get_comments->fetch_assoc()['count'];
      /* pages */
      $get_pages = $db->query("SELECT COUNT(*) as count FROM pages INNER JOIN users ON pages.page_admin = users.user_id");
      $insights['pages'] = $get_pages->fetch_assoc()['count'];
      /* groups */
      $get_groups = $db->query("SELECT COUNT(*) as count FROM `groups`");
      $insights['groups'] = $get_groups->fetch_assoc()['count'];
      /* events */
      $get_events = $db->query("SELECT COUNT(*) as count FROM `events`");
      $insights['events'] = $get_events->fetch_assoc()['count'];
      $insights['community_total'] = $insights['pages'] + $insights['groups'] + $insights['events'];
      /* messages */
      $get_messages = $db->query("SELECT COUNT(*) as count FROM conversations_messages");
      $insights['messages'] = $get_messages->fetch_assoc()['count'];
      /* notifications */
      $get_notifications = $db->query("SELECT COUNT(*) as count FROM notifications");
      $insights['notifications'] = $get_notifications->fetch_assoc()['count'];

      // get chart data (one grouped query per series; keys 1–12 for the default theme)
      $chart = [
        'users' => array_fill(1, 12, 0),
        'pages' => array_fill(1, 12, 0),
        'groups' => array_fill(1, 12, 0),
        'events' => array_fill(1, 12, 0),
        'posts' => array_fill(1, 12, 0),
      ];
      $chart_queries = [
        'users' => "SELECT MONTH(user_registered) AS m, COUNT(*) AS c FROM users WHERE YEAR(user_registered) = YEAR(CURRENT_DATE()) GROUP BY m",
        'pages' => "SELECT MONTH(page_date) AS m, COUNT(*) AS c FROM pages WHERE YEAR(page_date) = YEAR(CURRENT_DATE()) GROUP BY m",
        'groups' => "SELECT MONTH(group_date) AS m, COUNT(*) AS c FROM `groups` WHERE YEAR(group_date) = YEAR(CURRENT_DATE()) GROUP BY m",
        'events' => "SELECT MONTH(event_date) AS m, COUNT(*) AS c FROM `events` WHERE YEAR(event_date) = YEAR(CURRENT_DATE()) GROUP BY m",
        'posts' => "SELECT MONTH(time) AS m, COUNT(*) AS c FROM posts WHERE YEAR(time) = YEAR(CURRENT_DATE()) GROUP BY m",
      ];
      foreach ($chart_queries as $key => $sql) {
        $get_monthly = $db->query($sql);
        while ($row = $get_monthly->fetch_assoc()) {
          $month = (int) $row['m'];
          if ($month >= 1 && $month <= 12) {
            $chart[$key][$month] = (int) $row['c'];
          }
        }
      }

      // assign variables
      $smarty->assign('insights', $insights);
      $smarty->assign('chart', $chart);
      $smarty->assign('dashboard_chart_json', json_encode([
        'users' => array_values($chart['users']),
        'posts' => array_values($chart['posts']),
      ], JSON_UNESCAPED_UNICODE | JSON_HEX_TAG | JSON_HEX_AMP | JSON_HEX_APOS));
      break;

    case 'settings':
      // check admin|moderator permission
      if ($user->_is_moderator) {
        _error(__('System Message'), __("You don't have the right permission to access this"));
      }

      // get nested view content
      switch ($_GET['sub_view']) {
        case '':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("System Settings"));

          // get currencies
          $smarty->assign('system_currencies', $user->get_currencies());
          break;

        case 'posts':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Posts Settings"));
          break;

        case 'ai':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("AI Settings"));
          break;

        case 'registration':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Registration Settings"));

          // get users groups
          $smarty->assign('user_groups', $user->get_users_groups());
          break;

        case 'accounts':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Accounts Settings"));
          break;

        case 'email':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Email Settings"));
          break;

        case 'sms':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("SMS Settings"));
          break;

        case 'notifications':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Notifications Settings"));
          break;

        case 'chat':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Chat Settings"));
          break;

        case 'live':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Live Stream Settings"));
          break;

        case 'uploads':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Uploads Settings"));

          // get PHP upload_max_filesize
          $max_upload_size = ini_get("upload_max_filesize");

          // get upload size options
          $upload_size_values = [];
          foreach (['max_photo_size', 'max_cover_size', 'max_avatar_size', 'max_video_size', 'max_audio_size', 'max_file_size'] as $upload_size_key) {
            $upload_size_values[$upload_size_key] = get_upload_size_option($system[$upload_size_key]);
          }
          $upload_size_values['max_daily_upload_size'] = get_upload_size_option($system['max_daily_upload_size'], true);
          /* assign variables */
          $smarty->assign('max_upload_size', $max_upload_size);
          $smarty->assign('upload_size_options', get_upload_size_options());
          $smarty->assign('upload_size_values', $upload_size_values);
          $smarty->assign('watermark_opacity_value', get_watermark_opacity($system['watermark_opacity']));
          $smarty->assign('watermark_videos_opacity_value', get_watermark_opacity($system['watermark_videos_opacity']));
          $smarty->assign('watermark_positions', [
            'watermark_x' => get_watermark_percent($system['watermark_x'] ?? null, 95),
            'watermark_y' => get_watermark_percent($system['watermark_y'] ?? null, 95),
            'watermark_videos_x' => get_watermark_percent($system['watermark_videos_x'] ?? null, 50),
            'watermark_videos_y' => get_watermark_percent($system['watermark_videos_y'] ?? null, 50),
          ]);
          break;

        case 'payments':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Payments Settings"));
          break;

        case 'security':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Security Settings"));
          break;

        case 'limits':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Limits Settings"));
          break;

        case 'analytics':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Analytics Settings"));
          break;

        case 'redis':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Redis Settings"));

          // get redis & system cache status
          $smarty->assign('redis_status', redis_status());
          $smarty->assign('redis_default_prefix', redis_settings(['prefix' => ''])['prefix']);
          $smarty->assign('system_cache_status', system_cache_status());
          break;

        default:
          _error(404);
          break;
      }
      break;

    case 'themes':
      // check admin|moderator permission
      if ($user->_is_moderator) {
        _error(__('System Message'), __("You don't have the right permission to access this"));
      }

      // get nested view content
      switch ($_GET['sub_view']) {
        case '':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Themes"));

          // get data
          $rows = [];
          $get_rows = $db->query("SELECT * FROM system_themes");
          if ($get_rows->num_rows > 0) {
            while ($row = $get_rows->fetch_assoc()) {
              $row['title'] = (!empty($row['title'])) ? $row['title'] : $row['name'];
              $row['thumbnail_exists'] = is_file("content/themes/{$row['name']}/thumbnail.png");
              $rows[] = $row;
            }
          }

          // assign variables
          $smarty->assign('rows', $rows);
          break;

        case 'edit':
          // valid inputs
          if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
            _error(404);
          }

          // get data
          $get_data = $db->query(sprintf("SELECT * FROM system_themes WHERE theme_id = %s", secure($_GET['id'], 'int')));
          if ($get_data->num_rows == 0) {
            _error(404);
          }
          $data = $get_data->fetch_assoc();
          $data['title'] = (!empty($data['title'])) ? $data['title'] : $data['name'];
          $data['landing'] = (!empty($data['landing'])) ? $data['landing'] : 'default';
          $data['wallpaper_preview'] = theme_landing_wallpaper($data['name'], $data['landing']);
          $data['landings'] = [];
          $get_landings = $db->query(sprintf("SELECT * FROM system_theme_landings WHERE theme_id = %s ORDER BY is_default DESC, landing_id ASC", secure($_GET['id'], 'int')));
          if ($get_landings && $get_landings->num_rows > 0) {
            while ($landing = $get_landings->fetch_assoc()) {
              $data['landings'][] = array_merge($landing, theme_landing_thumbnails($data['name'], $landing['slug']));
            }
          }
          if (!$data['landings']) {
            $data['landings'][] = array_merge(['landing_id' => '', 'slug' => 'default', 'title' => 'Default', 'is_default' => '1'], theme_landing_thumbnails($data['name'], 'default'));
          }
          if ($data['name'] == 'nova') {
            foreach (['orbit' => 'Orbit', 'liquid' => 'Liquid', 'summit' => 'Summit', 'studio' => 'Studio'] as $slug => $title) {
              if (!is_file(ABSPATH . 'content/themes/nova/templates/index.landing.' . $slug . '.tpl')) {
                continue;
              }
              $registered = false;
              foreach ($data['landings'] as $landing) {
                if ($landing['slug'] == $slug) {
                  $registered = true;
                  break;
                }
              }
              if (!$registered) {
                $data['landings'][] = array_merge(['landing_id' => '', 'slug' => $slug, 'title' => $title, 'is_default' => '0'], theme_landing_thumbnails('nova', $slug));
              }
            }
          }

          // assign variables
          $smarty->assign('data', $data);

          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Themes") . " &rsaquo; " . $data['title']);
          break;

        case 'add':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Themes") . " &rsaquo; " . __("Add New"));

          // default landing stub
          $smarty->assign('data', [
            'landing' => 'default',
            'wallpaper_preview' => theme_landing_wallpaper($system['theme'], 'default'),
            'landings' => [
              array_merge(['landing_id' => '', 'slug' => 'default', 'title' => 'Default', 'is_default' => '1'], theme_landing_thumbnails($system['theme'], 'default')),
            ],
          ]);
          break;

        default:
          _error(404);
          break;
      }
      break;

    case 'design':
      // check admin|moderator permission
      if ($user->_is_moderator) {
        _error(__('System Message'), __("You don't have the right permission to access this"));
      }

      // get modules names
      $smarty->assign('module_names', module_names_registry());

      // page header
      page_header($control_panel['title'] . " &rsaquo; " . __("Design"));
      break;

    case 'languages':
      // check admin|moderator permission
      if ($user->_is_moderator) {
        _error(__('System Message'), __("You don't have the right permission to access this"));
      }

      // get nested view content
      switch ($_GET['sub_view']) {
        case '':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Languages"));

          // get data
          $get_rows = $db->query("SELECT * FROM system_languages");
          if ($get_rows->num_rows > 0) {
            while ($row = $get_rows->fetch_assoc()) {
              $row['flag'] = get_picture($row['flag'], 'flag');
              $rows[] = $row;
            }
          }

          // assign variables
          $smarty->assign('rows', $rows);
          break;

        case 'edit':
          // valid inputs
          if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
            _error(404);
          }

          // get data
          $get_data = $db->query(sprintf("SELECT * FROM system_languages WHERE language_id = %s", secure($_GET['id'], 'int')));
          if ($get_data->num_rows == 0) {
            _error(404);
          }
          $data = $get_data->fetch_assoc();

          // assign variables
          $smarty->assign('data', $data);

          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Languages") . " &rsaquo; " . $data['title']);
          break;

        case 'add':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Languages") . " &rsaquo; " . __("Add New"));
          break;

        default:
          _error(404);
          break;
      }
      break;

    case 'countries':
      // check admin|moderator permission
      if ($user->_is_moderator) {
        _error(__('System Message'), __("You don't have the right permission to access this"));
      }

      // get nested view content
      switch ($_GET['sub_view']) {
        case '':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Countries"));

          // get data
          $get_rows = $db->query("SELECT * FROM system_countries");
          if ($get_rows->num_rows > 0) {
            while ($row = $get_rows->fetch_assoc()) {
              $rows[] = $row;
            }
          }

          // assign variables
          $smarty->assign('rows', $rows);
          break;

        case 'edit':
          // valid inputs
          if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
            _error(404);
          }

          // get data
          $get_data = $db->query(sprintf("SELECT * FROM system_countries WHERE country_id = %s", secure($_GET['id'], 'int')));
          if ($get_data->num_rows == 0) {
            _error(404);
          }
          $data = $get_data->fetch_assoc();

          // assign variables
          $smarty->assign('data', $data);

          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Countries") . " &rsaquo; " . $data['country_name']);
          break;

        case 'add':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Countries") . " &rsaquo; " . __("Add New"));
          break;

        default:
          _error(404);
          break;
      }
      break;

    case 'currencies':
      // check admin|moderator permission
      if ($user->_is_moderator) {
        _error(__('System Message'), __("You don't have the right permission to access this"));
      }

      // get nested view content
      switch ($_GET['sub_view']) {
        case '':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Currencies"));

          // get data
          $rows = $user->get_currencies(true);

          // assign variables
          $smarty->assign('rows', $rows);
          break;

        case 'edit':
          // valid inputs
          if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
            _error(404);
          }

          // get data
          $get_data = $db->query(sprintf("SELECT * FROM system_currencies WHERE currency_id = %s", secure($_GET['id'], 'int')));
          if ($get_data->num_rows == 0) {
            _error(404);
          }
          $data = $get_data->fetch_assoc();

          // assign variables
          $smarty->assign('data', $data);

          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Currencies") . " &rsaquo; " . $data['name']);
          break;

        case 'add':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Currencies") . " &rsaquo; " . __("Add New"));
          break;

        default:
          _error(404);
          break;
      }
      break;

    case 'genders':
      // check admin|moderator permission
      if ($user->_is_moderator) {
        _error(__('System Message'), __("You don't have the right permission to access this"));
      }

      // get nested view content
      switch ($_GET['sub_view']) {
        case '':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Genders"));

          // get data
          $rows = $user->get_genders(false);

          // assign variables
          $smarty->assign('rows', $rows);
          break;

        case 'edit':
          // valid inputs
          if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
            _error(404);
          }

          // get data
          $get_data = $db->query(sprintf("SELECT * FROM system_genders WHERE gender_id = %s", secure($_GET['id'], 'int')));
          if ($get_data->num_rows == 0) {
            _error(404);
          }
          $data = $get_data->fetch_assoc();

          // assign variables
          $smarty->assign('data', $data);

          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Genders") . " &rsaquo; " . $data['gender_name']);
          break;

        case 'add':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Genders") . " &rsaquo; " . __("Add New"));
          break;

        default:
          _error(404);
          break;
      }
      break;

    case 'users':
      // check admin|moderator permission
      if ($user->_is_moderator && !$system['mods_users_permission']) {
        _error(__('System Message'), __("You don't have the right permission to access this"));
      }

      // get nested view content
      switch ($_GET['sub_view']) {
        case '':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Users"));

          // check cug
          $cug_where_query = "";
          $cug_where_and_query = "";
          $query_string = "";
          if (isset($_GET['cug'])) {
            $cug = $user->get_user_group($_GET['cug']);
            if (!$cug) {
              _error(404);
            }
            $cug_where_query = " WHERE user_group_custom = " . secure($_GET['cug'], 'int') . " ";
            $cug_where_and_query = " AND user_group_custom =  " . secure($_GET['cug'], 'int') . " ";
            $query_string = "&cug=" . $_GET['cug'];
            $smarty->assign('cug', $cug);
          } elseif (isset($_GET['ncug'])) {
            $cug_where_query = " WHERE user_group = '3' AND user_group_custom = '0' ";
            $cug_where_and_query = " AND user_group = '3' AND user_group_custom =  '0' ";
            $query_string = "&ncug=true";
            $smarty->assign('ncug', true);
          }

          // get insights
          $insights = [];
          /* total users */
          $get_users = $db->query("SELECT COUNT(*) as count FROM users" . $cug_where_query);
          $insights['users'] = $get_users->fetch_assoc()['count'];
          $get_pending = $db->query("SELECT COUNT(*) as count FROM users WHERE user_approved = '0'" . $cug_where_and_query);
          $insights['pending'] = $get_pending->fetch_assoc()['count'];
          $get_banned = $db->query("SELECT COUNT(*) as count FROM users WHERE user_banned = '1'" . $cug_where_and_query);
          $insights['banned'] = $get_banned->fetch_assoc()['count'];
          $get_not_activated = $db->query("SELECT COUNT(*) as count FROM users WHERE user_activated = '0'" . $cug_where_and_query);
          $insights['not_activated'] = $get_not_activated->fetch_assoc()['count'];

          // get data
          require('includes/class-pager.php');
          $params['selected_page'] = (!isset($_GET['page']) || (int) $_GET['page'] == 0) ? 1 : $_GET['page'];
          $total = $db->query("SELECT COUNT(*) as count FROM users" . $cug_where_query);
          $params['total_items'] = $insights['users'];
          $params['items_per_page'] = $system['max_results'];
          $params['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/users?page=%s' . $query_string;
          $pager = new Pager($params);
          $limit_query = $pager->getLimitSql();
          $get_rows = paged_query("SELECT * FROM users " . $cug_where_query . "ORDER BY user_id ASC ", 'users.user_id', $limit_query);
          if ($get_rows->num_rows > 0) {
            while ($row = $get_rows->fetch_assoc()) {
              $row['user_picture'] = get_picture($row['user_picture'], $row['user_gender']);
              $rows[] = $row;
            }
          }

          // assign variables
          $smarty->assign('insights', $insights);
          $smarty->assign('rows', $rows);
          $smarty->assign('pager', $pager->getPager());
          break;

        case 'admins':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Users") . " &rsaquo; " . __("Admins"));

          // get data
          require('includes/class-pager.php');
          $params['selected_page'] = (!isset($_GET['page']) || (int) $_GET['page'] == 0) ? 1 : $_GET['page'];
          $total = $db->query("SELECT COUNT(*) as count FROM users WHERE user_group = '1'");
          $params['total_items'] = $total->fetch_assoc()['count'];
          $params['items_per_page'] = $system['max_results'];
          $params['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/users/admins?page=%s';
          $pager = new Pager($params);
          $limit_query = $pager->getLimitSql();
          $get_rows = paged_query("SELECT * FROM users WHERE user_group = '1' ORDER BY user_id ASC ", 'users.user_id', $limit_query);
          if ($get_rows->num_rows > 0) {
            while ($row = $get_rows->fetch_assoc()) {
              $row['user_picture'] = get_picture($row['user_picture'], $row['user_gender']);
              $rows[] = $row;
            }
          }

          // assign variables
          $smarty->assign('rows', $rows);
          $smarty->assign('pager', $pager->getPager());
          break;

        case 'moderators':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Users") . " &rsaquo; " . __("Moderators"));

          // get data
          require('includes/class-pager.php');
          $params['selected_page'] = (!isset($_GET['page']) || (int) $_GET['page'] == 0) ? 1 : $_GET['page'];
          $total = $db->query("SELECT COUNT(*) as count FROM users WHERE user_group = '2'");
          $params['total_items'] = $total->fetch_assoc()['count'];
          $params['items_per_page'] = $system['max_results'];
          $params['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/users/moderators?page=%s';
          $pager = new Pager($params);
          $limit_query = $pager->getLimitSql();
          $get_rows = paged_query("SELECT * FROM users WHERE user_group = '2' ORDER BY user_id ASC ", 'users.user_id', $limit_query);
          if ($get_rows->num_rows > 0) {
            while ($row = $get_rows->fetch_assoc()) {
              $row['user_picture'] = get_picture($row['user_picture'], $row['user_gender']);
              $rows[] = $row;
            }
          }

          // assign variables
          $smarty->assign('rows', $rows);
          $smarty->assign('pager', $pager->getPager());
          break;

        case 'online':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Users") . " &rsaquo; " . __("Online"));

          // get data
          require('includes/class-pager.php');
          $params['selected_page'] = (!isset($_GET['page']) || (int) $_GET['page'] == 0) ? 1 : $_GET['page'];
          $total = $db->query(sprintf("SELECT COUNT(*) as count FROM users WHERE user_last_seen >= SUBTIME(NOW(), SEC_TO_TIME(%s))", secure($system['offline_time'], 'int', false)));
          $params['total_items'] = $total->fetch_assoc()['count'];
          $params['items_per_page'] = $system['max_results'];
          $params['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/users/online?page=%s';
          $pager = new Pager($params);
          $limit_query = $pager->getLimitSql();
          $get_rows = paged_query(sprintf("SELECT * FROM users WHERE user_last_seen >= SUBTIME(NOW(), SEC_TO_TIME(%s)) ORDER BY user_id ASC ", secure($system['offline_time'], 'int', false)), 'users.user_id', $limit_query);
          if ($get_rows->num_rows > 0) {
            while ($row = $get_rows->fetch_assoc()) {
              $row['user_picture'] = get_picture($row['user_picture'], $row['user_gender']);
              $rows[] = $row;
            }
          }

          // assign variables
          $smarty->assign('rows', $rows);
          $smarty->assign('pager', $pager->getPager());
          break;

        case 'banned':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Users") . " &rsaquo; " . __("Banned"));

          // get data
          require('includes/class-pager.php');
          $params['selected_page'] = (!isset($_GET['page']) || (int) $_GET['page'] == 0) ? 1 : $_GET['page'];
          $total = $db->query("SELECT COUNT(*) as count FROM users WHERE user_banned = '1'");
          $params['total_items'] = $total->fetch_assoc()['count'];
          $params['items_per_page'] = $system['max_results'];
          $params['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/users/banned?page=%s';
          $pager = new Pager($params);
          $limit_query = $pager->getLimitSql();
          $get_rows = paged_query("SELECT * FROM users WHERE user_banned = '1' ORDER BY user_id ASC ", 'users.user_id', $limit_query);
          if ($get_rows->num_rows > 0) {
            while ($row = $get_rows->fetch_assoc()) {
              $row['user_picture'] = get_picture($row['user_picture'], $row['user_gender']);
              $rows[] = $row;
            }
          }

          // assign variables
          $smarty->assign('rows', $rows);
          $smarty->assign('pager', $pager->getPager());
          break;

        case 'not_activated':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Users") . " &rsaquo; " . __("Not Activated"));

          // get data
          require('includes/class-pager.php');
          $params['selected_page'] = (!isset($_GET['page']) || (int) $_GET['page'] == 0) ? 1 : $_GET['page'];
          $total = $db->query("SELECT COUNT(*) as count FROM users WHERE user_activated = '0'");
          $params['total_items'] = $total->fetch_assoc()['count'];
          $params['items_per_page'] = $system['max_results'];
          $params['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/users/not_activated?page=%s';
          $pager = new Pager($params);
          $limit_query = $pager->getLimitSql();
          $get_rows = paged_query("SELECT * FROM users WHERE user_activated = '0' ORDER BY user_id ASC ", 'users.user_id', $limit_query);
          if ($get_rows->num_rows > 0) {
            while ($row = $get_rows->fetch_assoc()) {
              $row['user_picture'] = get_picture($row['user_picture'], $row['user_gender']);
              $rows[] = $row;
            }
          }

          // assign variables
          $smarty->assign('rows', $rows);
          $smarty->assign('pager', $pager->getPager());
          break;

        case 'pending':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Users") . " &rsaquo; " . __("Pending"));

          // get data
          require('includes/class-pager.php');
          $params['selected_page'] = (!isset($_GET['page']) || (int) $_GET['page'] == 0) ? 1 : $_GET['page'];
          $total = $db->query("SELECT COUNT(*) as count FROM users WHERE user_approved = '0'");
          $params['total_items'] = $total->fetch_assoc()['count'];
          $params['items_per_page'] = $system['max_results'];
          $params['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/users/pending?page=%s';
          $pager = new Pager($params);
          $limit_query = $pager->getLimitSql();
          $get_rows = paged_query("SELECT * FROM users WHERE user_approved = '0' ORDER BY user_id ASC ", 'users.user_id', $limit_query);
          if ($get_rows->num_rows > 0) {
            while ($row = $get_rows->fetch_assoc()) {
              $row['user_picture'] = get_picture($row['user_picture'], $row['user_gender']);
              $rows[] = $row;
            }
          }

          // assign variables
          $smarty->assign('rows', $rows);
          $smarty->assign('pager', $pager->getPager());
          break;

        case 'stats':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Users") . " &rsaquo; " . __("Stats"));

          // prepare where query
          $where_query = "";
          $query_string = "";
          /* check from & to */
          $from = (isset($_GET['from'])) ? date('Y-m-d', strtotime($_GET['from'])) : null;
          $to = (isset($_GET['to'])) ? date('Y-m-d', strtotime($_GET['to'])) : null;
          if ($from && $to) {
            $where_query = sprintf(" AND (DATE(posts.time) BETWEEN %s AND %s)", secure($from, 'datetime'), secure($to, 'datetime'));
            $query_string = "&from=" . $_GET['from'] . "&to=" . $_GET['to'];
          }
          /* check query */
          if (isset($_GET['query'])) {
            $where_users_query = sprintf(' WHERE (users.user_name LIKE %1$s OR users.user_firstname LIKE %1$s OR users.user_lastname LIKE %1$s OR CONCAT(users.user_firstname,  " ", users.user_lastname) LIKE %1$s OR users.user_email LIKE %1$s OR users.user_phone LIKE %1$s)', secure($_GET['query'], 'search'));
            $query_string .= "&query=" . $_GET['query'];
          }

          // get data
          require('includes/class-pager.php');
          $params['selected_page'] = (!isset($_GET['page']) || (int) $_GET['page'] == 0) ? 1 : $_GET['page'];
          $total = $db->query("SELECT COUNT(*) as count FROM users");
          $params['total_items'] = $total->fetch_assoc()['count'];
          $params['items_per_page'] = $system['max_results'];
          $params['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/users/stats?page=%s' . $query_string;
          $pager = new Pager($params);
          $limit_query = $pager->getLimitSql();
          $get_rows = paged_query("SELECT users.*, (SELECT COUNT(*) FROM posts WHERE posts.user_id = users.user_id AND posts.user_type = 'user' " . $where_query . ") AS posts_count FROM users " . $where_users_query . " ORDER BY user_id ASC ", 'users.user_id', $limit_query);
          if ($get_rows->num_rows > 0) {
            while ($row = $get_rows->fetch_assoc()) {
              $row['user_picture'] = get_picture($row['user_picture'], $row['user_gender']);
              $rows[] = $row;
            }
          }

          // assign variables
          $smarty->assign('rows', $rows);
          $smarty->assign('pager', $pager->getPager());
          $smarty->assign('from', $from);
          $smarty->assign('to', $to);
          $smarty->assign('query', ($_GET['query']) ? htmlentities($_GET['query'], ENT_QUOTES, 'utf-8') : null);
          break;

        case 'find':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Users") . " &rsaquo; " . __("Find"));

          // get data
          require('includes/class-pager.php');
          $params['selected_page'] = (!isset($_GET['page']) || (int) $_GET['page'] == 0) ? 1 : $_GET['page'];
          $total = $db->query(sprintf('SELECT COUNT(*) as count FROM users WHERE (user_name LIKE %1$s OR user_firstname LIKE %1$s OR user_lastname LIKE %1$s OR CONCAT(user_firstname,  " ", user_lastname) LIKE %1$s OR user_email LIKE %1$s OR user_phone LIKE %1$s) ORDER BY user_firstname ASC', secure($_GET['query'], 'search')));
          $params['total_items'] = $total->fetch_assoc()['count'];
          $params['items_per_page'] = $system['max_results'];
          $params['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/users/find?query=' . $_GET['query'] . '&page=%s';
          $pager = new Pager($params);
          $limit_query = $pager->getLimitSql();
          $get_rows = paged_query(sprintf('SELECT * FROM users WHERE (user_name LIKE %1$s OR user_firstname LIKE %1$s OR user_lastname LIKE %1$s OR CONCAT(user_firstname,  " ", user_lastname) LIKE %1$s OR user_email LIKE %1$s OR user_phone LIKE %1$s) ', secure($_GET['query'], 'search')), 'users.user_id', $limit_query);
          if ($get_rows->num_rows > 0) {
            while ($row = $get_rows->fetch_assoc()) {
              $row['user_picture'] = get_picture($row['user_picture'], $row['user_gender']);
              $rows[] = $row;
            }
          }

          // assign variables
          $smarty->assign('rows', $rows);
          $smarty->assign('pager', $pager->getPager());
          break;

        case 'edit':
          // valid inputs
          if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
            _error(404);
          }

          // get data
          $get_data = $db->query(sprintf("SELECT * FROM users LEFT JOIN packages ON users.user_subscribed = '1' AND users.user_package = packages.package_id WHERE users.user_id = %s ", secure($_GET['id'], 'int')));
          if ($get_data->num_rows == 0) {
            _error(404);
          }
          $data = $get_data->fetch_assoc();
          /* get user full name */
          $data['user_fullname'] = ($system['show_usernames_enabled']) ? $data['user_name'] : $data['user_firstname'] . " " . $data['user_lastname'];
          /* get users groups */
          $data['user_groups'] = $user->get_users_groups();
          /* get user picture */
          $data['user_picture'] = get_picture($data['user_picture'], $data['user_gender']);
          /* get user's connections */
          $data['friends'] = $user->get_friends_count($data['user_id']);
          $data['followings'] = $user->get_followings_count($data['user_id']);
          $data['followers'] = $user->get_followers_count($data['user_id']);
          /* get posts count */
          $data['posts_count'] = $user->get_posts_count($data['user_id'], 'user');
          /* check if user online */
          $data['is_online'] = $user->user_online($data['user_id']);
          /* get user referrer */
          $data['user_referrer'] = $user->get_user($data['user_referrer_id']);
          /* parse birthdate */
          $data['user_birthdate_parsed'] = ($data['user_birthdate']) ? date_parse($data['user_birthdate']) : null;
          /* get user sessions */
          $get_sessions = $db->query(sprintf("SELECT * FROM users_sessions WHERE user_id = %s", secure($_GET['id'], 'int')));
          if ($get_sessions->num_rows > 0) {
            while ($session = $get_sessions->fetch_assoc()) {
              $session['user_location'] = $user->get_session_location($session);
              $data['sessions'][] = $session;
            }
          }
          /* prepare packages */
          if ($system['packages_enabled']) {
            /* prepare user package */
            if ($data['user_subscribed']) {
              switch ($data['period']) {
                case 'day':
                  $duration = 86400;
                  break;

                case 'week':
                  $duration = 604800;
                  break;

                case 'month':
                  $duration = 2629743;
                  break;

                case 'year':
                  $duration = 31556926;
                  break;
              }
              $data['subscription_end'] = strtotime($data['user_subscription_date']) + ($data['period_num'] * $duration);
              $data['subscription_timeleft'] = ceil(($data['subscription_end'] - time()) / (60 * 60 * 24));
            }
            /* get packages */
            $packages = method_exists($user, 'get_packages') ? $user->get_packages(true) : [];
            $smarty->assign('packages', $packages);
          }
          /* prepare monetization */
          $data['can_monetize_content'] = $system['monetization_enabled'] && $user->check_user_permission($data['user_id'], 'monetization_permission');
          // get monetozaion plans
          if ($data['can_monetize_content'] && method_exists($user, 'get_monetization_plans')) {
            $smarty->assign('monetization_plans', $user->get_monetization_plans($data['user_id']));
          }
          /* get custom fields */
          $smarty->assign('custom_fields', $user->get_custom_fields(["for" => "user", "get" => "settings", "node_id" => $_GET['id']]));

          // get genders
          $smarty->assign('genders',  $user->get_genders());

          // get countries
          if (!$countries) {
            $smarty->assign('countries', $user->get_countries());
          }

          // assign variables
          $smarty->assign('data', $data);

          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Users") . " &rsaquo; " . $data['user_firstname'] . " " . $data['user_lastname']);
          break;

        default:
          _error(404);
          break;
      }
      break;

    case 'users_groups':
      // check admin|moderator permission
      if ($user->_is_moderator) {
        _error(__('System Message'), __("You don't have the right permission to access this"));
      }

      // get nested view content
      switch ($_GET['sub_view']) {
        case '':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Users Groups"));

          // get data
          /* get system groups counts */
          /* get admins count */
          $get_admins = $db->query("SELECT COUNT(*) as count FROM users WHERE user_group = '1'");
          $counters['admins_count'] = $get_admins->fetch_assoc()['count'];
          /* get moderators count */
          $get_moderators = $db->query("SELECT COUNT(*) as count FROM users WHERE user_group = '2'");
          $counters['moderators_count'] = $get_moderators->fetch_assoc()['count'];
          /* get users count */
          $get_users = $db->query("SELECT COUNT(*) as count FROM users WHERE user_group = '3' AND user_group_custom = '0'");
          $counters['users_count'] = $get_users->fetch_assoc()['count'];
          /* get custom groups */
          $rows = $user->get_users_groups();

          // assign variables
          $smarty->assign('rows', $rows);
          $smarty->assign('counters', $counters);
          break;

        case 'edit':
          // valid inputs
          if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
            _error(404);
          }

          // get data
          $data = $user->get_user_group($_GET['id']);
          if (!$data) {
            _error(404);
          }
          /* get permissions groups */
          $data['permissions_groups'] = $user->get_permissions_groups();

          // assign variables
          $smarty->assign('data', $data);

          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Users Groups") . " &rsaquo; " . $data['user_group_title']);
          break;

        case 'add':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Users Groups") . " &rsaquo; " . __("Add New"));

          // get permissions groups
          $smarty->assign('permissions_groups', $user->get_permissions_groups());
          break;

        default:
          _error(404);
          break;
      }
      break;

    case 'permissions_groups':
      // check admin|moderator permission
      if ($user->_is_moderator) {
        _error(__('System Message'), __("You don't have the right permission to access this"));
      }

      // get nested view content
      switch ($_GET['sub_view']) {
        case '':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Permissions Groups"));

          // get data
          $rows = $user->get_permissions_groups();

          // assign variables
          $smarty->assign('rows', $rows);
          break;

        case 'edit':
          // valid inputs
          if (!isset($_GET['id']) || (!in_array($_GET['id'], ['mods', 'users', 'verified']) && !is_numeric($_GET['id']))) {
            _error(404);
          }
          if ($_GET['id'] == "mods") {
            $data['edit_mods'] = true;
            $data['permissions_group_title'] = __("Moderators");
          } else {
            if ($_GET['id'] == "users") {
              $_GET['id'] = '1';
            } elseif ($_GET['id'] == "verified") {
              $_GET['id'] = '2';
            }

            // get data
            $data = $user->get_permissions_group($_GET['id']);
            if (!$data) {
              _error(404);
            }
          }

          // assign variables
          $smarty->assign('data', $data);

          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Permissions Groups") . " &rsaquo; " . $data['permissions_group_title']);
          break;

        case 'add':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Permissions Groups") . " &rsaquo; " . __("Add New"));
          break;

        default:
          _error(404);
          break;
      }
      break;

    case 'posts':
      // check admin|moderator permission
      if ($user->_is_moderator && !$system['mods_posts_permission']) {
        _error(__('System Message'), __("You don't have the right permission to access this"));
      }

      // get nested view content
      switch ($_GET['sub_view']) {
        case '':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Posts"));

          // get insights
          $insights = [];
          $get_posts = $db->query("SELECT COUNT(*) as count FROM posts LEFT JOIN users ON posts.user_id = users.user_id AND posts.user_type = 'user' LEFT JOIN pages ON posts.user_id = pages.page_id AND posts.user_type = 'page' WHERE (posts.pre_approved = '1' OR posts.has_approved = '1') AND NOT (users.user_name <=> NULL AND pages.page_name <=> NULL)");
          $insights['posts'] = $get_posts->fetch_assoc()['count'];
          $get_pending_posts = $db->query("SELECT COUNT(*) as count FROM posts LEFT JOIN users ON posts.user_id = users.user_id AND posts.user_type = 'user' LEFT JOIN pages ON posts.user_id = pages.page_id AND posts.user_type = 'page' WHERE (posts.pre_approved = '0' AND posts.has_approved = '0') AND NOT (users.user_name <=> NULL AND pages.page_name <=> NULL)");
          $insights['pending_posts'] = $get_pending_posts->fetch_assoc()['count'];
          $get_posts_comments = $db->query("SELECT COUNT(*) as count FROM posts_comments");
          $insights['posts_comments'] = $get_posts_comments->fetch_assoc()['count'];
          $get_posts_likes = $db->query("SELECT COUNT(*) as count FROM posts_reactions");
          $insights['posts_likes'] = $get_posts_likes->fetch_assoc()['count'];

          // get data
          require('includes/class-pager.php');
          $params['selected_page'] = (!isset($_GET['page']) || (int) $_GET['page'] == 0) ? 1 : $_GET['page'];
          $params['total_items'] = $insights['posts'];
          $params['items_per_page'] = $system['max_results'];
          $params['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/posts?page=%s';
          $pager = new Pager($params);
          $limit_query = $pager->getLimitSql();
          $get_rows = paged_query("SELECT posts.*, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, pages.* FROM posts LEFT JOIN users ON posts.user_id = users.user_id AND posts.user_type = 'user' LEFT JOIN pages ON posts.user_id = pages.page_id AND posts.user_type = 'page' WHERE (posts.pre_approved = '1' OR posts.has_approved = '1') AND NOT (users.user_name <=> NULL AND pages.page_name <=> NULL) ORDER BY posts.post_id ASC ", 'posts.post_id', $limit_query);
          if ($get_rows->num_rows > 0) {
            while ($row = $get_rows->fetch_assoc()) {
              /* check the post author type */
              if ($row['user_type'] == "user") {
                /* user */
                $row['post_author_picture'] = get_picture($row['user_picture'], $row['user_gender']);
                $row['post_author_url'] = $system['system_url'] . '/' . $row['user_name'];
                $row['post_author_name'] = ($system['show_usernames_enabled']) ? $row['user_name'] : $row['user_firstname'] . " " . $row['user_lastname'];
              } else {
                /* page */
                $row['post_author_picture'] = get_picture($row['page_picture'], "page");
                $row['post_author_url'] = $system['system_url'] . '/pages/' . $row['page_name'];
                $row['post_author_name'] = $row['page_title'];
              }
              $rows[] = $row;
            }
          }

          // assign variables
          $smarty->assign('insights', $insights);
          $smarty->assign('rows', $rows);
          $smarty->assign('pager', $pager->getPager());
          break;

        case 'find':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Posts") . " &rsaquo; " . __("Find"));

          // get data
          require('includes/class-pager.php');
          $params['selected_page'] = (!isset($_GET['page']) || (int) $_GET['page'] == 0) ? 1 : $_GET['page'];
          $search_query = sprintf('(posts.post_id = %s OR ', secure($_GET['query'], 'int')) . $user->posts_search_clause($_GET['query'], sprintf('(posts.text LIKE %s)', secure($_GET['query'], 'search'))) . ')';
          $total = $db->query('SELECT COUNT(*) as count FROM posts LEFT JOIN users ON posts.user_id = users.user_id AND posts.user_type = "user" LEFT JOIN pages ON posts.user_id = pages.page_id AND posts.user_type = "page" WHERE NOT (users.user_name <=> NULL AND pages.page_name <=> NULL) AND ' . $search_query);
          $params['total_items'] = $total->fetch_assoc()['count'];
          $params['items_per_page'] = $system['max_results'];
          $params['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/posts/find?query=' . $_GET['query'] . '&page=%s';
          $pager = new Pager($params);
          $limit_query = $pager->getLimitSql();
          $get_rows = paged_query('SELECT posts.*, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, pages.* FROM posts LEFT JOIN users ON posts.user_id = users.user_id AND posts.user_type = "user" LEFT JOIN pages ON posts.user_id = pages.page_id AND posts.user_type = "page" WHERE NOT (users.user_name <=> NULL AND pages.page_name <=> NULL) AND ' . $search_query . ' ', 'posts.post_id', $limit_query);
          if ($get_rows->num_rows > 0) {
            while ($row = $get_rows->fetch_assoc()) {
              /* check the post author type */
              if ($row['user_type'] == "user") {
                /* user */
                $row['post_author_picture'] = get_picture($row['user_picture'], $row['user_gender']);
                $row['post_author_url'] = $system['system_url'] . '/' . $row['user_name'];
                $row['post_author_name'] = ($system['show_usernames_enabled']) ? $row['user_name'] : $row['user_firstname'] . " " . $row['user_lastname'];
              } else {
                /* page */
                $row['post_author_picture'] = get_picture($row['page_picture'], "page");
                $row['post_author_url'] = $system['system_url'] . '/pages/' . $row['page_name'];
                $row['post_author_name'] = $row['page_title'];
              }
              $rows[] = $row;
            }
          }

          // assign variables
          $smarty->assign('rows', $rows);
          $smarty->assign('pager', $pager->getPager());
          $smarty->assign('query', ($_GET['query']) ? htmlentities($_GET['query'], ENT_QUOTES, 'utf-8') : null);
          break;

        case 'pending':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Posts") . " &rsaquo; " . __("Pending"));

          // get insights
          $insights = [];
          $get_posts = $db->query("SELECT COUNT(*) as count FROM posts LEFT JOIN users ON posts.user_id = users.user_id AND posts.user_type = 'user' LEFT JOIN pages ON posts.user_id = pages.page_id AND posts.user_type = 'page' WHERE (posts.pre_approved = '1' OR posts.has_approved = '1') AND NOT (users.user_name <=> NULL AND pages.page_name <=> NULL)");
          $insights['posts'] = $get_posts->fetch_assoc()['count'];
          $get_pending_posts = $db->query("SELECT COUNT(*) as count FROM posts LEFT JOIN users ON posts.user_id = users.user_id AND posts.user_type = 'user' LEFT JOIN pages ON posts.user_id = pages.page_id AND posts.user_type = 'page' WHERE (posts.pre_approved = '0' AND posts.has_approved = '0') AND NOT (users.user_name <=> NULL AND pages.page_name <=> NULL)");
          $insights['pending_posts'] = $get_pending_posts->fetch_assoc()['count'];
          $get_posts_comments = $db->query("SELECT COUNT(*) as count FROM posts_comments");
          $insights['posts_comments'] = $get_posts_comments->fetch_assoc()['count'];
          $get_posts_likes = $db->query("SELECT COUNT(*) as count FROM posts_reactions");
          $insights['posts_likes'] = $get_posts_likes->fetch_assoc()['count'];

          // get data
          require('includes/class-pager.php');
          $params['selected_page'] = (!isset($_GET['page']) || (int) $_GET['page'] == 0) ? 1 : $_GET['page'];
          $params['total_items'] = $insights['pending_posts'];
          $params['items_per_page'] = $system['max_results'];
          $params['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/posts/pending?page=%s';
          $pager = new Pager($params);
          $limit_query = $pager->getLimitSql();
          $get_rows = paged_query("SELECT posts.*, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, pages.* FROM posts LEFT JOIN users ON posts.user_id = users.user_id AND posts.user_type = 'user' LEFT JOIN pages ON posts.user_id = pages.page_id AND posts.user_type = 'page' WHERE (posts.pre_approved = '0' AND posts.has_approved = '0') AND NOT (users.user_name <=> NULL AND pages.page_name <=> NULL) ORDER BY posts.post_id ASC ", 'posts.post_id', $limit_query);
          if ($get_rows->num_rows > 0) {
            while ($row = $get_rows->fetch_assoc()) {
              /* check the post author type */
              if ($row['user_type'] == "user") {
                /* user */
                $row['post_author_picture'] = get_picture($row['user_picture'], $row['user_gender']);
                $row['post_author_url'] = $system['system_url'] . '/' . $row['user_name'];
                $row['post_author_name'] = ($system['show_usernames_enabled']) ? $row['user_name'] : $row['user_firstname'] . " " . $row['user_lastname'];
              } else {
                /* page */
                $row['post_author_picture'] = get_picture($row['page_picture'], "page");
                $row['post_author_url'] = $system['system_url'] . '/pages/' . $row['page_name'];
                $row['post_author_name'] = $row['page_title'];
              }
              $rows[] = $row;
            }
          }

          // assign variables
          $smarty->assign('insights', $insights);
          $smarty->assign('rows', $rows);
          $smarty->assign('pager', $pager->getPager());
          break;

        case 'videos_categories':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Posts") . " &rsaquo; " . __("Videos Categories"));

          // get data
          $rows = $user->get_categories("posts_videos_categories");

          // assign variables
          $smarty->assign('rows', $rows);
          break;

        case 'edit_videos_category':
          // valid inputs
          if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
            _error(404);
          }

          // get data
          $get_data = $db->query(sprintf("SELECT * FROM posts_videos_categories WHERE category_id = %s", secure($_GET['id'], 'int')));
          if ($get_data->num_rows == 0) {
            _error(404);
          }
          $data = $get_data->fetch_assoc();
          /* get categories */
          $data['categories'] = $user->get_categories("posts_videos_categories");

          // assign variables
          $smarty->assign('data', $data);

          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Posts") . " &rsaquo; " . __("Videos Categories") . " &rsaquo; " . $data['category_name']);
          break;

        case 'add_videos_category':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Posts") . " &rsaquo; " . __("Videos Categories") . " &rsaquo; " . __("Add New Category"));

          // get data
          $categories = $user->get_categories("posts_videos_categories");

          // assign variables
          $smarty->assign('categories', $categories);
          break;

        case 'live_categories':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Posts") . " &rsaquo; " . __("Live Categories"));

          // get data
          $rows = $user->get_categories("posts_live_categories");

          // assign variables
          $smarty->assign('rows', $rows);
          break;

        case 'edit_live_category':
          // valid inputs
          if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
            _error(404);
          }

          // get data
          $get_data = $db->query(sprintf("SELECT * FROM posts_live_categories WHERE category_id = %s", secure($_GET['id'], 'int')));
          if ($get_data->num_rows == 0) {
            _error(404);
          }
          $data = $get_data->fetch_assoc();
          /* get categories */
          $data['categories'] = $user->get_categories("posts_live_categories");

          // assign variables
          $smarty->assign('data', $data);

          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Posts") . " &rsaquo; " . __("Live Categories") . " &rsaquo; " . $data['category_name']);
          break;

        case 'add_live_category':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Posts") . " &rsaquo; " . __("Live Categories") . " &rsaquo; " . __("Add New Category"));

          // get data
          $categories = $user->get_categories("posts_live_categories");

          // assign variables
          $smarty->assign('categories', $categories);
          break;

        default:
          _error(404);
          break;
      }
      break;

    case 'pages':
      // check admin|moderator permission
      if ($user->_is_moderator && !$system['mods_pages_permission']) {
        _error(__('System Message'), __("You don't have the right permission to access this"));
      }

      // get nested view content
      switch ($_GET['sub_view']) {
        case '':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Pages"));

          // get insights
          $insights = [];
          $get_pages = $db->query("SELECT COUNT(*) as count FROM pages INNER JOIN users ON pages.page_admin = users.user_id");
          $insights['pages'] = $get_pages->fetch_assoc()['count'];
          $get_pages_verified = $db->query("SELECT COUNT(*) as count FROM pages INNER JOIN users ON pages.page_admin = users.user_id WHERE pages.page_verified = '1'");
          $insights['pages_verified'] = $get_pages_verified->fetch_assoc()['count'];
          $get_pages_likes = $db->query("SELECT COUNT(*) as count FROM pages_likes INNER JOIN users ON pages_likes.user_id = users.user_id INNER JOIN pages ON pages_likes.page_id = pages.page_id");
          $insights['pages_likes'] = $get_pages_likes->fetch_assoc()['count'];

          // get data
          require('includes/class-pager.php');
          $params['selected_page'] = (!isset($_GET['page']) || (int) $_GET['page'] == 0) ? 1 : $_GET['page'];
          $params['total_items'] = $insights['pages'];
          $params['items_per_page'] = $system['max_results'];
          $params['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/pages?page=%s';
          $pager = new Pager($params);
          $limit_query = $pager->getLimitSql();
          $get_rows = paged_query("SELECT pages.*, users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM pages INNER JOIN users ON pages.page_admin = users.user_id ORDER BY pages.page_id ASC ", 'pages.page_id', $limit_query);
          if ($get_rows->num_rows > 0) {
            while ($row = $get_rows->fetch_assoc()) {
              $row['page_picture'] = get_picture($row['page_picture'], 'page');
              $row['user_picture'] = get_picture($row['user_picture'], $row['user_gender']);
              $rows[] = $row;
            }
          }

          // assign variables
          $smarty->assign('insights', $insights);
          $smarty->assign('rows', $rows);
          $smarty->assign('pager', $pager->getPager());
          break;

        case 'find':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Pages") . " &rsaquo; " . __("Find"));

          // get data
          require('includes/class-pager.php');
          $params['selected_page'] = (!isset($_GET['page']) || (int) $_GET['page'] == 0) ? 1 : $_GET['page'];
          $total = $db->query(sprintf('SELECT COUNT(*) as count FROM pages INNER JOIN users ON pages.page_admin = users.user_id WHERE pages.page_name LIKE %1$s OR pages.page_title LIKE %1$s', secure($_GET['query'], 'search')));
          $params['total_items'] = $total->fetch_assoc()['count'];
          $params['items_per_page'] = $system['max_results'];
          $params['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/pages/find?query=' . $_GET['query'] . '&page=%s';
          $pager = new Pager($params);
          $limit_query = $pager->getLimitSql();
          $get_rows = paged_query(sprintf('SELECT pages.*, users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM pages INNER JOIN users ON pages.page_admin = users.user_id WHERE pages.page_name LIKE %1$s OR pages.page_title LIKE %1$s ', secure($_GET['query'], 'search')), 'pages.page_id', $limit_query);
          if ($get_rows->num_rows > 0) {
            while ($row = $get_rows->fetch_assoc()) {
              $row['page_picture'] = get_picture($row['page_picture'], 'page');
              $row['user_picture'] = get_picture($row['user_picture'], $row['user_gender']);
              $rows[] = $row;
            }
          }

          // assign variables
          $smarty->assign('rows', $rows);
          $smarty->assign('pager', $pager->getPager());
          break;

        case 'edit_page':
          // valid inputs
          if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
            _error(404);
          }

          // get data
          $get_data = $db->query(sprintf("SELECT pages.*, users.* FROM pages INNER JOIN users ON pages.page_admin = users.user_id WHERE pages.page_id = %s", secure($_GET['id'], 'int')));
          if ($get_data->num_rows == 0) {
            _error(404);
          }
          $data = $get_data->fetch_assoc();
          $data['page_picture'] = get_picture($data['page_picture'], 'page');
          $data['user_picture'] = get_picture($data['user_picture'], $data['user_gender']);
          /* get categories */
          $data['categories'] = $user->get_categories("pages_categories");
          /* get countries */
          $data['countries'] = (!$countries) ? $user->get_countries() : $countries;
          /* get custom fields */
          $smarty->assign('custom_fields', $user->get_custom_fields(["for" => "page", "get" => "settings", "node_id" => $_GET['id']]));
          /* prepare monetization */
          $data['can_monetize_content'] = $system['monetization_enabled'] && $user->check_user_permission($data['page_admin'], 'monetization_permission');
          // get monetozaion plans
          if ($data['can_monetize_content'] && method_exists($user, 'get_monetization_plans')) {
            $smarty->assign('monetization_plans', $user->get_monetization_plans($data['page_id'], 'page'));
          }

          // assign variables
          $smarty->assign('data', $data);

          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Pages") . " &rsaquo; " . $data['page_title']);
          break;

        case 'categories':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Pages") . " &rsaquo; " . __("Categories"));

          // get data
          $rows = $user->get_categories("pages_categories");

          // assign variables
          $smarty->assign('rows', $rows);
          break;

        case 'edit_category':
          // valid inputs
          if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
            _error(404);
          }

          // get data
          $get_data = $db->query(sprintf("SELECT * FROM pages_categories WHERE category_id = %s", secure($_GET['id'], 'int')));
          if ($get_data->num_rows == 0) {
            _error(404);
          }
          $data = $get_data->fetch_assoc();
          /* get categories */
          $data['categories'] = $user->get_categories("pages_categories");

          // assign variables
          $smarty->assign('data', $data);

          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Pages") . " &rsaquo; " . __("Categories") . " &rsaquo; " . $data['category_name']);
          break;

        case 'add_category':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Pages") . " &rsaquo; " . __("Categories") . " &rsaquo; " . __("Add New Category"));

          // get data
          $categories = $user->get_categories("pages_categories");

          // assign variables
          $smarty->assign('categories', $categories);
          break;

        default:
          _error(404);
          break;
      }
      break;

    case 'groups':
      // check admin|moderator permission
      if ($user->_is_moderator && !$system['mods_groups_permission']) {
        _error(__('System Message'), __("You don't have the right permission to access this"));
      }

      // get nested view content
      switch ($_GET['sub_view']) {
        case '':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Groups"));

          // get insights
          $get_groups = $db->query("SELECT COUNT(*) as count FROM `groups`");
          $insights['groups'] = $get_groups->fetch_assoc()['count'];
          $get_public = $db->query("SELECT COUNT(*) as count FROM `groups` WHERE group_privacy = 'public'");
          $insights['public'] = $get_public->fetch_assoc()['count'];
          $get_closed = $db->query("SELECT COUNT(*) as count FROM `groups` WHERE group_privacy = 'closed'");
          $insights['closed'] = $get_closed->fetch_assoc()['count'];
          $get_secret = $db->query("SELECT COUNT(*) as count FROM `groups` WHERE group_privacy = 'secret'");
          $insights['secret'] = $get_secret->fetch_assoc()['count'];

          // get data
          require('includes/class-pager.php');
          $params['selected_page'] = (!isset($_GET['page']) || (int) $_GET['page'] == 0) ? 1 : $_GET['page'];
          $total = $db->query("SELECT COUNT(*) as count FROM `groups` INNER JOIN users ON `groups`.group_admin = users.user_id");
          $params['total_items'] = $total->fetch_assoc()['count'];
          $params['items_per_page'] = $system['max_results'];
          $params['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/groups?page=%s';
          $pager = new Pager($params);
          $limit_query = $pager->getLimitSql();
          $get_rows = paged_query("SELECT `groups`.*, users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM `groups` INNER JOIN users ON `groups`.group_admin = users.user_id ORDER BY `groups`.group_id ASC ", '`groups`.group_id', $limit_query);
          if ($get_rows->num_rows > 0) {
            while ($row = $get_rows->fetch_assoc()) {
              $row['group_picture'] = get_picture($row['group_picture'], 'group');
              $row['user_picture'] = get_picture($row['user_picture'], $row['user_gender']);
              $rows[] = $row;
            }
          }

          // assign variables
          $smarty->assign('insights', $insights);
          $smarty->assign('rows', $rows);
          $smarty->assign('pager', $pager->getPager());
          break;

        case 'find':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Groups") . " &rsaquo; " . __("Find"));

          // get data
          require('includes/class-pager.php');
          $params['selected_page'] = (!isset($_GET['page']) || (int) $_GET['page'] == 0) ? 1 : $_GET['page'];
          $total = $db->query(sprintf('SELECT COUNT(*) as count FROM `groups` INNER JOIN users ON `groups`.group_admin = users.user_id WHERE `groups`.group_name LIKE %1$s OR `groups`.group_title LIKE %1$s', secure($_GET['query'], 'search')));
          $params['total_items'] = $total->fetch_assoc()['count'];
          $params['items_per_page'] = $system['max_results'];
          $params['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/groups/find?query=' . $_GET['query'] . '&page=%s';
          $pager = new Pager($params);
          $limit_query = $pager->getLimitSql();
          $get_rows = paged_query(sprintf('SELECT `groups`.*, users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM `groups` INNER JOIN users ON `groups`.group_admin = users.user_id WHERE `groups`.group_name LIKE %1$s OR `groups`.group_title LIKE %1$s ', secure($_GET['query'], 'search')), '`groups`.group_id', $limit_query);
          if ($get_rows->num_rows > 0) {
            while ($row = $get_rows->fetch_assoc()) {
              $row['group_picture'] = get_picture($row['group_picture'], 'group');
              $row['user_picture'] = get_picture($row['user_picture'], $row['user_gender']);
              $rows[] = $row;
            }
          }

          // assign variables
          $smarty->assign('rows', $rows);
          $smarty->assign('pager', $pager->getPager());
          $smarty->assign('query', ($_GET['query']) ? htmlentities($_GET['query'], ENT_QUOTES, 'utf-8') : null);
          break;

        case 'edit_group':
          // valid inputs
          if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
            _error(404);
          }

          // get data
          $get_data = $db->query(sprintf("SELECT `groups`.*, users.* FROM `groups` INNER JOIN users ON `groups`.group_admin = users.user_id WHERE `groups`.group_id = %s", secure($_GET['id'], 'int')));
          if ($get_data->num_rows == 0) {
            _error(404);
          }
          $data = $get_data->fetch_assoc();
          $data['group_picture'] = get_picture($data['group_picture'], 'group');
          $data['user_picture'] = get_picture($data['user_picture'], $data['user_gender']);
          /* get categories */
          $data['categories'] = $user->get_categories("groups_categories");
          /* get countries */
          $data['countries'] = (!$countries) ? $user->get_countries() : $countries;
          /* get custom fields */
          $smarty->assign('custom_fields', $user->get_custom_fields(["for" => "group", "get" => "settings", "node_id" => $_GET['id']]));
          /* prepare monetization */
          $data['can_monetize_content'] = $system['monetization_enabled'] && $user->check_user_permission($data['group_admin'], 'monetization_permission');
          if ($data['can_monetize_content'] && method_exists($user, 'get_monetization_plans')) {
            // get monetozaion plans
            $smarty->assign('monetization_plans', $user->get_monetization_plans($data['group_id'], 'group'));
          }

          // assign variables
          $smarty->assign('data', $data);

          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Groups") . " &rsaquo; " . $data['group_title']);
          break;

        case 'categories':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Groups") . " &rsaquo; " . __("Categories"));

          // get data
          $rows = $user->get_categories("groups_categories");

          // assign variables
          $smarty->assign('rows', $rows);
          break;

        case 'edit_category':
          // valid inputs
          if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
            _error(404);
          }

          // get data
          $get_data = $db->query(sprintf("SELECT * FROM groups_categories WHERE category_id = %s", secure($_GET['id'], 'int')));
          if ($get_data->num_rows == 0) {
            _error(404);
          }
          $data = $get_data->fetch_assoc();
          /* get categories */
          $data['categories'] = $user->get_categories("groups_categories");

          // assign variables
          $smarty->assign('data', $data);

          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Groups") . " &rsaquo; " . __("Categories") . " &rsaquo; " . $data['category_name']);
          break;

        case 'add_category':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Groups") . " &rsaquo; " . __("Categories") . " &rsaquo; " . __("Add New Category"));

          // get data
          $categories = $user->get_categories("groups_categories");

          // assign variables
          $smarty->assign('categories', $categories);
          break;

        default:
          _error(404);
          break;
      }
      break;

    case 'events':
      // check admin|moderator permission
      if ($user->_is_moderator && !$system['mods_events_permission']) {
        _error(__('System Message'), __("You don't have the right permission to access this"));
      }

      // get nested view content
      switch ($_GET['sub_view']) {
        case '':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Events"));

          // get insights
          $insights = [];
          /* total events */
          $get_events = $db->query("SELECT COUNT(*) as count FROM `events`");
          $insights['events'] = $get_events->fetch_assoc()['count'];
          $get_upcoming = $db->query("SELECT COUNT(*) as count FROM `events` WHERE `event_end_date` >= NOW()");
          $insights['upcoming'] = $get_upcoming->fetch_assoc()['count'];
          $get_online = $db->query("SELECT COUNT(*) as count FROM `events` WHERE `event_is_online` = '1'");
          $insights['online'] = $get_online->fetch_assoc()['count'];
          $get_categories = $db->query("SELECT COUNT(*) as count FROM `events_categories`");
          $insights['categories'] = $get_categories->fetch_assoc()['count'];

          // get data
          require('includes/class-pager.php');
          $params['selected_page'] = (!isset($_GET['page']) || (int) $_GET['page'] == 0) ? 1 : $_GET['page'];
          $total = $db->query("SELECT COUNT(*) as count FROM `events` INNER JOIN users ON `events`.event_admin = users.user_id");
          $params['total_items'] = $total->fetch_assoc()['count'];
          $params['items_per_page'] = $system['max_results'];
          $params['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/events?page=%s';
          $pager = new Pager($params);
          $limit_query = $pager->getLimitSql();
          $get_rows = paged_query("SELECT `events`.*, users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM `events` INNER JOIN users ON `events`.event_admin = users.user_id ORDER BY `events`.event_id ASC ", '`events`.event_id', $limit_query);
          if ($get_rows->num_rows > 0) {
            while ($row = $get_rows->fetch_assoc()) {
              $row['event_picture'] = get_picture($row['event_cover'], 'event');
              $row['user_picture'] = get_picture($row['user_picture'], $row['user_gender']);
              $rows[] = $row;
            }
          }

          // assign variables
          $smarty->assign('insights', $insights);
          $smarty->assign('rows', $rows);
          $smarty->assign('pager', $pager->getPager());
          break;

        case 'find':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Events") . " &rsaquo; " . __("Find"));

          // get data
          require('includes/class-pager.php');
          $params['selected_page'] = (!isset($_GET['page']) || (int) $_GET['page'] == 0) ? 1 : $_GET['page'];
          $total = $db->query(sprintf('SELECT COUNT(*) as count FROM `events` INNER JOIN users ON `events`.event_admin = users.user_id WHERE `events`.event_title LIKE %1$s', secure($_GET['query'], 'search')));
          $params['total_items'] = $total->fetch_assoc()['count'];
          $params['items_per_page'] = $system['max_results'];
          $params['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/events/find?query=' . $_GET['query'] . '&page=%s';
          $pager = new Pager($params);
          $limit_query = $pager->getLimitSql();
          $get_rows = paged_query(sprintf('SELECT `events`.*, users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM `events` INNER JOIN users ON `events`.event_admin = users.user_id WHERE `events`.event_title LIKE %1$s ', secure($_GET['query'], 'search')), '`events`.event_id', $limit_query);
          if ($get_rows->num_rows > 0) {
            while ($row = $get_rows->fetch_assoc()) {
              $row['event_picture'] = get_picture($row['event_cover'], 'event');
              $row['user_picture'] = get_picture($row['user_picture'], $row['user_gender']);
              $rows[] = $row;
            }
          }

          // assign variables
          $smarty->assign('rows', $rows);
          $smarty->assign('pager', $pager->getPager());
          break;

        case 'edit_event':
          // valid inputs
          if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
            _error(404);
          }

          // get data
          $get_data = $db->query(sprintf("SELECT `events`.*, users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM `events` INNER JOIN users ON `events`.event_admin = users.user_id WHERE `events`.event_id = %s", secure($_GET['id'], 'int')));
          if ($get_data->num_rows == 0) {
            _error(404);
          }
          $data = $get_data->fetch_assoc();
          $data['event_picture'] = get_picture($data['event_cover'], 'event');
          $data['user_picture'] = get_picture($data['user_picture'], $data['user_gender']);
          /* get categories */
          $data['categories'] = $user->get_categories("events_categories");
          /* get countries */
          $data['countries'] = (!$countries) ? $user->get_countries() : $countries;
          /* get custom fields */
          $smarty->assign('custom_fields', $user->get_custom_fields(["for" => "event", "get" => "settings", "node_id" => $_GET['id']]));

          // assign variables
          $smarty->assign('data', $data);

          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Events") . " &rsaquo; " . $data['event_title']);
          break;

        case 'categories':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Events") . " &rsaquo; " . __("Categories"));

          // get data
          $rows = $user->get_categories("events_categories");

          // assign variables
          $smarty->assign('rows', $rows);
          break;

        case 'edit_category':
          // valid inputs
          if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
            _error(404);
          }

          // get data
          $get_data = $db->query(sprintf("SELECT * FROM events_categories WHERE category_id = %s", secure($_GET['id'], 'int')));
          if ($get_data->num_rows == 0) {
            _error(404);
          }
          $data = $get_data->fetch_assoc();
          /* get categories */
          $data['categories'] = $user->get_categories("events_categories");

          // assign variables
          $smarty->assign('data', $data);

          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Events") . " &rsaquo; " . __("Categories") . " &rsaquo; " . $data['category_name']);
          break;

        case 'add_category':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Events") . " &rsaquo; " . __("Categories") . " &rsaquo; " . __("Add New Category"));

          // get data
          $categories = $user->get_categories("events_categories");

          // assign variables
          $smarty->assign('categories', $categories);
          break;

        default:
          _error(404);
          break;
      }
      break;

    case 'blogs':
      // check admin|moderator permission
      if ($user->_is_moderator && !$system['mods_blogs_permission']) {
        _error(__('System Message'), __("You don't have the right permission to access this"));
      }

      // get nested view content
      switch ($_GET['sub_view']) {
        case '':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Blogs"));

          // get insights
          $insights = [];
          $get_blogs = $db->query("SELECT COUNT(*) as count FROM posts INNER JOIN posts_articles ON posts.post_id = posts_articles.post_id AND posts.post_type = 'article' LEFT JOIN users ON posts.user_id = users.user_id AND posts.user_type = 'user' LEFT JOIN pages ON posts.user_id = pages.page_id AND posts.user_type = 'page' WHERE NOT (users.user_name <=> NULL AND pages.page_name <=> NULL)");
          $insights['blogs'] = $get_blogs->fetch_assoc()['count'];
          $get_categories = $db->query("SELECT COUNT(*) as count FROM blogs_categories");
          $insights['categories'] = $get_categories->fetch_assoc()['count'];
          $get_comments = $db->query("SELECT COUNT(*) as count FROM posts_comments INNER JOIN posts ON posts_comments.node_id = posts.post_id AND posts_comments.node_type = 'post' AND posts.post_type = 'article'");
          $insights['comments'] = $get_comments->fetch_assoc()['count'];
          $get_reactions = $db->query("SELECT COUNT(*) as count FROM posts_reactions INNER JOIN posts ON posts_reactions.post_id = posts.post_id AND posts.post_type = 'article'");
          $insights['reactions'] = $get_reactions->fetch_assoc()['count'];

          // get data
          require('includes/class-pager.php');
          $params['selected_page'] = (!isset($_GET['page']) || (int) $_GET['page'] == 0) ? 1 : $_GET['page'];
          $params['total_items'] = $insights['blogs'];
          $params['items_per_page'] = $system['max_results'];
          $params['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/blogs?page=%s';
          $pager = new Pager($params);
          $limit_query = $pager->getLimitSql();
          $get_rows = paged_query("SELECT posts.*, posts_articles.title, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, pages.* FROM posts INNER JOIN posts_articles ON posts.post_id = posts_articles.post_id AND posts.post_type = 'article' LEFT JOIN users ON posts.user_id = users.user_id AND posts.user_type = 'user' LEFT JOIN pages ON posts.user_id = pages.page_id AND posts.user_type = 'page' WHERE NOT (users.user_name <=> NULL AND pages.page_name <=> NULL) ORDER BY posts.post_id ASC ", 'posts.post_id', $limit_query);
          if ($get_rows->num_rows > 0) {
            while ($row = $get_rows->fetch_assoc()) {
              $row['blog_title_url'] = get_url_text($row['title']);
              /* check the post author type */
              if ($row['user_type'] == "user") {
                /* user */
                $row['blog_author_picture'] = get_picture($row['user_picture'], $row['user_gender']);
                $row['blog_author_url'] = $system['system_url'] . '/' . $row['user_name'];
                $row['blog_author_name'] = ($system['show_usernames_enabled']) ? $row['user_name'] : $row['user_firstname'] . " " . $row['user_lastname'];
              } else {
                /* page */
                $row['blog_author_picture'] = get_picture($row['page_picture'], "page");
                $row['blog_author_url'] = $system['system_url'] . '/pages/' . $row['page_name'];
                $row['blog_author_name'] = $row['page_title'];
              }
              $rows[] = $row;
            }
          }

          // assign variables
          $smarty->assign('insights', $insights);
          $smarty->assign('rows', $rows);
          $smarty->assign('pager', $pager->getPager());
          break;

        case 'find':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Blogs") . " &rsaquo; " . __("Find"));

          // get data
          require('includes/class-pager.php');
          $params['selected_page'] = (!isset($_GET['page']) || (int) $_GET['page'] == 0) ? 1 : $_GET['page'];
          $legacy_query = ($system['blogs_search_content_enabled']) ? '(posts.text LIKE %1$s OR posts_articles.title LIKE %1$s OR posts_articles.tags LIKE %1$s OR posts_articles.text LIKE %1$s)' : '(posts.text LIKE %1$s OR posts_articles.title LIKE %1$s OR posts_articles.tags LIKE %1$s)';
          $search_query = $user->posts_search_clause($_GET['query'], sprintf($legacy_query, secure($_GET['query'], 'search')));
          $total = $db->query('SELECT COUNT(*) as count FROM posts INNER JOIN posts_articles ON posts.post_id = posts_articles.post_id AND posts.post_type = "article" LEFT JOIN users ON posts.user_id = users.user_id AND posts.user_type = "user" LEFT JOIN pages ON posts.user_id = pages.page_id AND posts.user_type = "page" WHERE NOT (users.user_name <=> NULL AND pages.page_name <=> NULL) AND ' . $search_query);
          $params['total_items'] = $total->fetch_assoc()['count'];
          $params['items_per_page'] = $system['max_results'];
          $params['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/blogs/find?query=' . $_GET['query'] . '&page=%s';
          $pager = new Pager($params);
          $limit_query = $pager->getLimitSql();
          $get_rows = paged_query('SELECT posts.*, posts_articles.title, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, pages.* FROM posts INNER JOIN posts_articles ON posts.post_id = posts_articles.post_id AND posts.post_type = "article" LEFT JOIN users ON posts.user_id = users.user_id AND posts.user_type = "user" LEFT JOIN pages ON posts.user_id = pages.page_id AND posts.user_type = "page" WHERE NOT (users.user_name <=> NULL AND pages.page_name <=> NULL) AND ' . $search_query . ' ', 'posts.post_id', $limit_query);
          if ($get_rows->num_rows > 0) {
            while ($row = $get_rows->fetch_assoc()) {
              $row['blog_title_url'] = get_url_text($row['title']);
              /* check the post author type */
              if ($row['user_type'] == "user") {
                /* user */
                $row['blog_author_picture'] = get_picture($row['user_picture'], $row['user_gender']);
                $row['blog_author_url'] = $system['system_url'] . '/' . $row['user_name'];
                $row['blog_author_name'] = ($system['show_usernames_enabled']) ? $row['user_name'] : $row['user_firstname'] . " " . $row['user_lastname'];
              } else {
                /* page */
                $row['blog_author_picture'] = get_picture($row['page_picture'], "page");
                $row['blog_author_url'] = $system['system_url'] . '/pages/' . $row['page_name'];
                $row['blog_author_name'] = $row['page_title'];
              }
              $rows[] = $row;
            }
          }

          // assign variables
          $smarty->assign('query', ($_GET['query']) ? htmlentities($_GET['query'], ENT_QUOTES, 'utf-8') : null);
          $smarty->assign('rows', $rows);
          $smarty->assign('pager', $pager->getPager());
          break;

        case 'categories':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Blogs") . " &rsaquo; " . __("Categories"));

          // get data
          $rows = $user->get_categories("blogs_categories");

          // assign variables
          $smarty->assign('rows', $rows);
          break;

        case 'edit_category':
          // valid inputs
          if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
            _error(404);
          }

          // get data
          $get_data = $db->query(sprintf("SELECT * FROM blogs_categories WHERE category_id = %s", secure($_GET['id'], 'int')));
          if ($get_data->num_rows == 0) {
            _error(404);
          }
          $data = $get_data->fetch_assoc();
          /* get categories */
          $data['categories'] = $user->get_categories("blogs_categories");

          // assign variables
          $smarty->assign('data', $data);

          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Blogs") . " &rsaquo; " . __("Categories") . " &rsaquo; " . $data['category_name']);
          break;

        case 'add_category':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Blogs") . " &rsaquo; " . __("Categories") . " &rsaquo; " . __("Add New Category"));

          // get data
          $categories = $user->get_categories("blogs_categories");

          // assign variables
          $smarty->assign('categories', $categories);
          break;

        default:
          _error(404);
          break;
      }
      break;

    case 'offers':
      // check admin|moderator permission
      if ($user->_is_moderator && !$system['mods_offers_permission']) {
        _error(__('System Message'), __("You don't have the right permission to access this"));
      }

      // prepare offers queries
      $offers_from_query = " FROM posts INNER JOIN posts_offers ON posts.post_id = posts_offers.post_id AND posts.post_type = 'offer' LEFT JOIN users ON posts.user_id = users.user_id AND posts.user_type = 'user' LEFT JOIN pages ON posts.user_id = pages.page_id AND posts.user_type = 'page'";
      $offers_author_query = " NOT (users.user_name <=> NULL AND pages.page_name <=> NULL)";
      $offers_select_query = "SELECT posts.*, posts_offers.*, (posts_offers.end_date IS NULL OR posts_offers.end_date >= NOW()) AS offer_active, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, pages.*";

      // get nested view content
      switch ($_GET['sub_view']) {
        case '':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Offers"));

          // get insights
          $insights = [];
          $get_offers = $db->query("SELECT COUNT(*) as count" . $offers_from_query . " WHERE" . $offers_author_query);
          $insights['offers'] = $get_offers->fetch_assoc()['count'];
          $get_active = $db->query("SELECT COUNT(*) as count" . $offers_from_query . " WHERE" . $offers_author_query . " AND (posts_offers.end_date IS NULL OR posts_offers.end_date >= NOW())");
          $insights['active'] = $get_active->fetch_assoc()['count'];
          $get_expired = $db->query("SELECT COUNT(*) as count" . $offers_from_query . " WHERE" . $offers_author_query . " AND posts_offers.end_date < NOW()");
          $insights['expired'] = $get_expired->fetch_assoc()['count'];
          $get_categories = $db->query("SELECT COUNT(*) as count FROM offers_categories");
          $insights['categories'] = $get_categories->fetch_assoc()['count'];

          // get data
          require('includes/class-pager.php');
          $params['selected_page'] = (!isset($_GET['page']) || (int) $_GET['page'] == 0) ? 1 : $_GET['page'];
          $params['total_items'] = $insights['offers'];
          $params['items_per_page'] = $system['max_results'];
          $params['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/offers?page=%s';
          $pager = new Pager($params);
          $limit_query = $pager->getLimitSql();
          $get_rows = paged_query($offers_select_query . $offers_from_query . " WHERE" . $offers_author_query . " ORDER BY posts.post_id ASC ", 'posts.post_id', $limit_query);
          if ($get_rows->num_rows > 0) {
            while ($row = $get_rows->fetch_assoc()) {
              /* check the post author type */
              if ($row['user_type'] == "user") {
                /* user */
                $row['offer_author_picture'] = get_picture($row['user_picture'], $row['user_gender']);
                $row['offer_author_url'] = $system['system_url'] . '/' . $row['user_name'];
                $row['offer_author_name'] = ($system['show_usernames_enabled']) ? $row['user_name'] : $row['user_firstname'] . " " . $row['user_lastname'];
              } else {
                /* page */
                $row['offer_author_picture'] = get_picture($row['page_picture'], "page");
                $row['offer_author_url'] = $system['system_url'] . '/pages/' . $row['page_name'];
                $row['offer_author_name'] = $row['page_title'];
              }
              $rows[] = $row;
            }
          }

          // assign variables
          $smarty->assign('insights', $insights);
          $smarty->assign('rows', $rows);
          $smarty->assign('pager', $pager->getPager());
          break;

        case 'find':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Offers") . " &rsaquo; " . __("Find"));

          // get data
          require('includes/class-pager.php');
          $params['selected_page'] = (!isset($_GET['page']) || (int) $_GET['page'] == 0) ? 1 : $_GET['page'];
          $search_query = $user->posts_search_clause($_GET['query'], sprintf("(posts.text LIKE %1\$s OR posts_offers.title LIKE %1\$s)", secure($_GET['query'], 'search')));
          $total = $db->query("SELECT COUNT(*) as count" . $offers_from_query . " WHERE" . $offers_author_query . " AND " . $search_query);
          $params['total_items'] = $total->fetch_assoc()['count'];
          $params['items_per_page'] = $system['max_results'];
          $params['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/offers/find?query=' . urlencode($_GET['query']) . '&page=%s';
          $pager = new Pager($params);
          $limit_query = $pager->getLimitSql();
          $get_rows = paged_query($offers_select_query . $offers_from_query . " WHERE" . $offers_author_query . " AND " . $search_query . " ORDER BY posts.post_id ASC ", 'posts.post_id', $limit_query);
          if ($get_rows->num_rows > 0) {
            while ($row = $get_rows->fetch_assoc()) {
              /* check the post author type */
              if ($row['user_type'] == "user") {
                /* user */
                $row['offer_author_picture'] = get_picture($row['user_picture'], $row['user_gender']);
                $row['offer_author_url'] = $system['system_url'] . '/' . $row['user_name'];
                $row['offer_author_name'] = ($system['show_usernames_enabled']) ? $row['user_name'] : $row['user_firstname'] . " " . $row['user_lastname'];
              } else {
                /* page */
                $row['offer_author_picture'] = get_picture($row['page_picture'], "page");
                $row['offer_author_url'] = $system['system_url'] . '/pages/' . $row['page_name'];
                $row['offer_author_name'] = $row['page_title'];
              }
              $rows[] = $row;
            }
          }

          // assign variables
          $smarty->assign('rows', $rows);
          $smarty->assign('pager', $pager->getPager());
          $smarty->assign('query', ($_GET['query']) ? htmlentities($_GET['query'], ENT_QUOTES, 'utf-8') : null);
          break;

        case 'categories':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Offers") . " &rsaquo; " . __("Categories"));

          // get data
          $rows = $user->get_categories("offers_categories");

          // assign variables
          $smarty->assign('rows', $rows);
          break;

        case 'edit_category':
          // valid inputs
          if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
            _error(404);
          }

          // get data
          $get_data = $db->query(sprintf("SELECT * FROM offers_categories WHERE category_id = %s", secure($_GET['id'], 'int')));
          if ($get_data->num_rows == 0) {
            _error(404);
          }
          $data = $get_data->fetch_assoc();
          /* get categories */
          $data['categories'] = $user->get_categories("offers_categories");

          // assign variables
          $smarty->assign('data', $data);

          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Offers") . " &rsaquo; " . __("Categories") . " &rsaquo; " . $data['category_name']);
          break;

        case 'add_category':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Offers") . " &rsaquo; " . __("Categories") . " &rsaquo; " . __("Add New Category"));

          // get data
          $categories = $user->get_categories("offers_categories");

          // assign variables
          $smarty->assign('categories', $categories);
          break;

        default:
          _error(404);
          break;
      }
      break;

    case 'jobs':
      // check admin|moderator permission
      if ($user->_is_moderator && !$system['mods_jobs_permission']) {
        _error(__('System Message'), __("You don't have the right permission to access this"));
      }

      // prepare jobs queries
      $jobs_from_query = " FROM posts INNER JOIN posts_jobs ON posts.post_id = posts_jobs.post_id AND posts.post_type = 'job' LEFT JOIN users ON posts.user_id = users.user_id AND posts.user_type = 'user' LEFT JOIN pages ON posts.user_id = pages.page_id AND posts.user_type = 'page'";
      $jobs_author_query = " NOT (users.user_name <=> NULL AND pages.page_name <=> NULL)";
      $jobs_select_query = "SELECT posts.*, posts_jobs.*, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, pages.*";
      $jobs_types = ['full_time' => __("Full Time"), 'part_time' => __("Part Time"), 'internship' => __("Internship"), 'volunteer' => __("Volunteer"), 'contract' => __("Contract")];

      // get nested view content
      switch ($_GET['sub_view']) {
        case '':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Jobs"));

          // get insights
          $insights = [];
          $get_jobs = $db->query("SELECT COUNT(*) as count" . $jobs_from_query . " WHERE" . $jobs_author_query);
          $insights['jobs'] = $get_jobs->fetch_assoc()['count'];
          $get_open = $db->query("SELECT COUNT(*) as count" . $jobs_from_query . " WHERE" . $jobs_author_query . " AND posts_jobs.available = '1'");
          $insights['open'] = $get_open->fetch_assoc()['count'];
          $get_closed = $db->query("SELECT COUNT(*) as count" . $jobs_from_query . " WHERE" . $jobs_author_query . " AND posts_jobs.available = '0'");
          $insights['closed'] = $get_closed->fetch_assoc()['count'];
          $get_categories = $db->query("SELECT COUNT(*) as count FROM jobs_categories");
          $insights['categories'] = $get_categories->fetch_assoc()['count'];

          // get data
          require('includes/class-pager.php');
          $params['selected_page'] = (!isset($_GET['page']) || (int) $_GET['page'] == 0) ? 1 : $_GET['page'];
          $params['total_items'] = $insights['jobs'];
          $params['items_per_page'] = $system['max_results'];
          $params['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/jobs?page=%s';
          $pager = new Pager($params);
          $limit_query = $pager->getLimitSql();
          $get_rows = paged_query($jobs_select_query . $jobs_from_query . " WHERE" . $jobs_author_query . " ORDER BY posts.post_id ASC ", 'posts.post_id', $limit_query);
          if ($get_rows->num_rows > 0) {
            while ($row = $get_rows->fetch_assoc()) {
              /* check the post author type */
              if ($row['user_type'] == "user") {
                /* user */
                $row['job_author_picture'] = get_picture($row['user_picture'], $row['user_gender']);
                $row['job_author_url'] = $system['system_url'] . '/' . $row['user_name'];
                $row['job_author_name'] = ($system['show_usernames_enabled']) ? $row['user_name'] : $row['user_firstname'] . " " . $row['user_lastname'];
              } else {
                /* page */
                $row['job_author_picture'] = get_picture($row['page_picture'], "page");
                $row['job_author_url'] = $system['system_url'] . '/pages/' . $row['page_name'];
                $row['job_author_name'] = $row['page_title'];
              }
              /* prepare job meta data */
              $row['type_meta'] = $jobs_types[$row['type']] ?? null;
              $rows[] = $row;
            }
          }

          // assign variables
          $smarty->assign('insights', $insights);
          $smarty->assign('rows', $rows);
          $smarty->assign('pager', $pager->getPager());
          break;

        case 'find':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Jobs") . " &rsaquo; " . __("Find"));

          // get data
          require('includes/class-pager.php');
          $params['selected_page'] = (!isset($_GET['page']) || (int) $_GET['page'] == 0) ? 1 : $_GET['page'];
          $search_query = $user->posts_search_clause($_GET['query'], sprintf("(posts.text LIKE %1\$s OR posts_jobs.title LIKE %1\$s)", secure($_GET['query'], 'search')));
          $total = $db->query("SELECT COUNT(*) as count" . $jobs_from_query . " WHERE" . $jobs_author_query . " AND " . $search_query);
          $params['total_items'] = $total->fetch_assoc()['count'];
          $params['items_per_page'] = $system['max_results'];
          $params['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/jobs/find?query=' . urlencode($_GET['query']) . '&page=%s';
          $pager = new Pager($params);
          $limit_query = $pager->getLimitSql();
          $get_rows = paged_query($jobs_select_query . $jobs_from_query . " WHERE" . $jobs_author_query . " AND " . $search_query . " ORDER BY posts.post_id ASC ", 'posts.post_id', $limit_query);
          if ($get_rows->num_rows > 0) {
            while ($row = $get_rows->fetch_assoc()) {
              /* check the post author type */
              if ($row['user_type'] == "user") {
                /* user */
                $row['job_author_picture'] = get_picture($row['user_picture'], $row['user_gender']);
                $row['job_author_url'] = $system['system_url'] . '/' . $row['user_name'];
                $row['job_author_name'] = ($system['show_usernames_enabled']) ? $row['user_name'] : $row['user_firstname'] . " " . $row['user_lastname'];
              } else {
                /* page */
                $row['job_author_picture'] = get_picture($row['page_picture'], "page");
                $row['job_author_url'] = $system['system_url'] . '/pages/' . $row['page_name'];
                $row['job_author_name'] = $row['page_title'];
              }
              /* prepare job meta data */
              $row['type_meta'] = $jobs_types[$row['type']] ?? null;
              $rows[] = $row;
            }
          }

          // assign variables
          $smarty->assign('rows', $rows);
          $smarty->assign('pager', $pager->getPager());
          $smarty->assign('query', ($_GET['query']) ? htmlentities($_GET['query'], ENT_QUOTES, 'utf-8') : null);
          break;

        case 'categories':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Jobs") . " &rsaquo; " . __("Categories"));

          // get data
          $rows = $user->get_categories("jobs_categories");

          // assign variables
          $smarty->assign('rows', $rows);
          break;

        case 'edit_category':
          // valid inputs
          if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
            _error(404);
          }

          // get data
          $get_data = $db->query(sprintf("SELECT * FROM jobs_categories WHERE category_id = %s", secure($_GET['id'], 'int')));
          if ($get_data->num_rows == 0) {
            _error(404);
          }
          $data = $get_data->fetch_assoc();
          /* get categories */
          $data['categories'] = $user->get_categories("jobs_categories");

          // assign variables
          $smarty->assign('data', $data);

          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Jobs") . " &rsaquo; " . __("Categories") . " &rsaquo; " . $data['category_name']);
          break;

        case 'add_category':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Jobs") . " &rsaquo; " . __("Categories") . " &rsaquo; " . __("Add New Category"));

          // get data
          $categories = $user->get_categories("jobs_categories");

          // assign variables
          $smarty->assign('categories', $categories);
          break;

        default:
          _error(404);
          break;
      }
      break;

    case 'courses':
      // check admin|moderator permission
      if ($user->_is_moderator && !$system['mods_courses_permission']) {
        _error(__('System Message'), __("You don't have the right permission to access this"));
      }

      // prepare courses queries
      $courses_from_query = " FROM posts INNER JOIN posts_courses ON posts.post_id = posts_courses.post_id AND posts.post_type = 'course' LEFT JOIN users ON posts.user_id = users.user_id AND posts.user_type = 'user' LEFT JOIN pages ON posts.user_id = pages.page_id AND posts.user_type = 'page'";
      $courses_author_query = " NOT (users.user_name <=> NULL AND pages.page_name <=> NULL)";
      $courses_select_query = "SELECT posts.*, posts_courses.*, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, pages.*";

      // get nested view content
      switch ($_GET['sub_view']) {
        case '':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Courses"));

          // get insights
          $insights = [];
          $get_courses = $db->query("SELECT COUNT(*) as count" . $courses_from_query . " WHERE" . $courses_author_query);
          $insights['courses'] = $get_courses->fetch_assoc()['count'];
          $get_open = $db->query("SELECT COUNT(*) as count" . $courses_from_query . " WHERE" . $courses_author_query . " AND posts_courses.available = '1'");
          $insights['open'] = $get_open->fetch_assoc()['count'];
          $get_closed = $db->query("SELECT COUNT(*) as count" . $courses_from_query . " WHERE" . $courses_author_query . " AND posts_courses.available = '0'");
          $insights['closed'] = $get_closed->fetch_assoc()['count'];
          $get_categories = $db->query("SELECT COUNT(*) as count FROM courses_categories");
          $insights['categories'] = $get_categories->fetch_assoc()['count'];

          // get data
          require('includes/class-pager.php');
          $params['selected_page'] = (!isset($_GET['page']) || (int) $_GET['page'] == 0) ? 1 : $_GET['page'];
          $params['total_items'] = $insights['courses'];
          $params['items_per_page'] = $system['max_results'];
          $params['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/courses?page=%s';
          $pager = new Pager($params);
          $limit_query = $pager->getLimitSql();
          $get_rows = paged_query($courses_select_query . $courses_from_query . " WHERE" . $courses_author_query . " ORDER BY posts.post_id ASC ", 'posts.post_id', $limit_query);
          if ($get_rows->num_rows > 0) {
            while ($row = $get_rows->fetch_assoc()) {
              /* check the post author type */
              if ($row['user_type'] == "user") {
                /* user */
                $row['course_author_picture'] = get_picture($row['user_picture'], $row['user_gender']);
                $row['course_author_url'] = $system['system_url'] . '/' . $row['user_name'];
                $row['course_author_name'] = ($system['show_usernames_enabled']) ? $row['user_name'] : $row['user_firstname'] . " " . $row['user_lastname'];
              } else {
                /* page */
                $row['course_author_picture'] = get_picture($row['page_picture'], "page");
                $row['course_author_url'] = $system['system_url'] . '/pages/' . $row['page_name'];
                $row['course_author_name'] = $row['page_title'];
              }
              $rows[] = $row;
            }
          }

          // assign variables
          $smarty->assign('insights', $insights);
          $smarty->assign('rows', $rows);
          $smarty->assign('pager', $pager->getPager());
          break;

        case 'find':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Courses") . " &rsaquo; " . __("Find"));

          // get data
          require('includes/class-pager.php');
          $params['selected_page'] = (!isset($_GET['page']) || (int) $_GET['page'] == 0) ? 1 : $_GET['page'];
          $search_query = $user->posts_search_clause($_GET['query'], sprintf("(posts.text LIKE %1\$s OR posts_courses.title LIKE %1\$s)", secure($_GET['query'], 'search')));
          $total = $db->query("SELECT COUNT(*) as count" . $courses_from_query . " WHERE" . $courses_author_query . " AND " . $search_query);
          $params['total_items'] = $total->fetch_assoc()['count'];
          $params['items_per_page'] = $system['max_results'];
          $params['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/courses/find?query=' . urlencode($_GET['query']) . '&page=%s';
          $pager = new Pager($params);
          $limit_query = $pager->getLimitSql();
          $get_rows = paged_query($courses_select_query . $courses_from_query . " WHERE" . $courses_author_query . " AND " . $search_query . " ORDER BY posts.post_id ASC ", 'posts.post_id', $limit_query);
          if ($get_rows->num_rows > 0) {
            while ($row = $get_rows->fetch_assoc()) {
              /* check the post author type */
              if ($row['user_type'] == "user") {
                /* user */
                $row['course_author_picture'] = get_picture($row['user_picture'], $row['user_gender']);
                $row['course_author_url'] = $system['system_url'] . '/' . $row['user_name'];
                $row['course_author_name'] = ($system['show_usernames_enabled']) ? $row['user_name'] : $row['user_firstname'] . " " . $row['user_lastname'];
              } else {
                /* page */
                $row['course_author_picture'] = get_picture($row['page_picture'], "page");
                $row['course_author_url'] = $system['system_url'] . '/pages/' . $row['page_name'];
                $row['course_author_name'] = $row['page_title'];
              }
              $rows[] = $row;
            }
          }

          // assign variables
          $smarty->assign('rows', $rows);
          $smarty->assign('pager', $pager->getPager());
          $smarty->assign('query', ($_GET['query']) ? htmlentities($_GET['query'], ENT_QUOTES, 'utf-8') : null);
          break;

        case 'categories':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Courses") . " &rsaquo; " . __("Categories"));

          // get data
          $rows = $user->get_categories("courses_categories");

          // assign variables
          $smarty->assign('rows', $rows);
          break;

        case 'edit_category':
          // valid inputs
          if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
            _error(404);
          }

          // get data
          $get_data = $db->query(sprintf("SELECT * FROM courses_categories WHERE category_id = %s", secure($_GET['id'], 'int')));
          if ($get_data->num_rows == 0) {
            _error(404);
          }
          $data = $get_data->fetch_assoc();
          /* get categories */
          $data['categories'] = $user->get_categories("courses_categories");

          // assign variables
          $smarty->assign('data', $data);

          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Courses") . " &rsaquo; " . __("Categories") . " &rsaquo; " . $data['category_name']);
          break;

        case 'add_category':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Courses") . " &rsaquo; " . __("Categories") . " &rsaquo; " . __("Add New Category"));

          // get data
          $categories = $user->get_categories("courses_categories");

          // assign variables
          $smarty->assign('categories', $categories);
          break;

        default:
          _error(404);
          break;
      }
      break;

    case 'forums':
      // check admin|moderator permission
      if ($user->_is_moderator && !$system['mods_forums_permission']) {
        _error(__('System Message'), __("You don't have the right permission to access this"));
      }

      // get nested view content
      switch ($_GET['sub_view']) {
        case '':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Forums"));

          // get insights
          $insights = [];
          $get_forums = $db->query("SELECT COUNT(*) as count FROM forums");
          $insights['forums'] = $get_forums->fetch_assoc()['count'];
          $get_sections = $db->query(sprintf("SELECT COUNT(*) as count FROM forums WHERE forum_section = %s", secure(0, 'int')));
          $insights['sections'] = $get_sections->fetch_assoc()['count'];
          $get_threads = $db->query("SELECT COUNT(*) as count FROM forums_threads");
          $insights['threads'] = $get_threads->fetch_assoc()['count'];
          $get_replies = $db->query("SELECT COUNT(*) as count FROM forums_replies");
          $insights['replies'] = $get_replies->fetch_assoc()['count'];

          // get data
          $rows = $user->get_forums();

          // assign variables
          $smarty->assign('insights', $insights);
          $smarty->assign('rows', $rows);
          break;

        case 'edit_forum':
          // valid inputs
          if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
            _error(404);
          }

          // get data
          $data = $user->get_forum($_GET['id']);
          if (!$data) {
            _error(404);
          }
          /* get sections */
          $data['sections'] = $user->get_forums();

          // assign variables
          $smarty->assign('data', $data);

          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Forums") . " &rsaquo; " . $data['forum_name']);
          break;

        case 'add_forum':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Forums") . " &rsaquo; " . __("Add New Forum"));

          // get data
          $forums = $user->get_forums();

          // assign variables
          $smarty->assign('forums', $forums);
          break;

        case 'threads':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Forums") . " &rsaquo; " . __("Threads"));

          // get data
          require('includes/class-pager.php');
          $params['selected_page'] = (!isset($_GET['page']) || (int) $_GET['page'] == 0) ? 1 : $_GET['page'];
          $total = $db->query("SELECT COUNT(*) as count FROM forums_threads INNER JOIN users ON forums_threads.user_id = users.user_id");
          $params['total_items'] = $total->fetch_assoc()['count'];
          $params['items_per_page'] = $system['max_results'];
          $params['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/forums/threads?page=%s';
          $pager = new Pager($params);
          $limit_query = $pager->getLimitSql();
          $get_rows = paged_query("SELECT forums_threads.*, users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM forums_threads INNER JOIN users ON forums_threads.user_id = users.user_id ORDER BY forums_threads.thread_id ASC ", 'forums_threads.thread_id', $limit_query);
          if ($get_rows->num_rows > 0) {
            while ($row = $get_rows->fetch_assoc()) {
              $row['thread_title_url'] = get_url_text($row['title']);
              $row['thread_author_picture'] = get_picture($row['user_picture'], $row['user_gender']);
              $row['thread_author_url'] = $system['system_url'] . '/' . $row['user_name'];
              $row['thread_author_name'] = ($system['show_usernames_enabled']) ? $row['user_name'] : $row['user_firstname'] . " " . $row['user_lastname'];
              $rows[] = $row;
            }
          }

          // assign variables
          $smarty->assign('rows', $rows);
          $smarty->assign('pager', $pager->getPager());
          break;

        case 'find_threads':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Forums") . " &rsaquo; " . __("Threads"));

          // get data
          require('includes/class-pager.php');
          $params['selected_page'] = (!isset($_GET['page']) || (int) $_GET['page'] == 0) ? 1 : $_GET['page'];
          $total = $db->query(sprintf('SELECT COUNT(*) as count FROM forums_threads INNER JOIN users ON forums_threads.user_id = users.user_id WHERE forums_threads.title LIKE %1$s OR forums_threads.text LIKE %1$s', secure($_GET['query'], 'search')));
          $params['total_items'] = $total->fetch_assoc()['count'];
          $params['items_per_page'] = $system['max_results'];
          $params['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/forums/find_threads?query=' . $_GET['query'] . '&page=%s';
          $pager = new Pager($params);
          $limit_query = $pager->getLimitSql();
          $get_rows = paged_query(sprintf('SELECT forums_threads.*, users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM forums_threads INNER JOIN users ON forums_threads.user_id = users.user_id WHERE forums_threads.title LIKE %1$s OR forums_threads.text LIKE %1$s ', secure($_GET['query'], 'search')), 'forums_threads.thread_id', $limit_query);
          if ($get_rows->num_rows > 0) {
            while ($row = $get_rows->fetch_assoc()) {
              $row['thread_title_url'] = get_url_text($row['title']);
              $row['thread_author_picture'] = get_picture($row['user_picture'], $row['user_gender']);
              $row['thread_author_url'] = $system['system_url'] . '/' . $row['user_name'];
              $row['thread_author_name'] = ($system['show_usernames_enabled']) ? $row['user_name'] : $row['user_firstname'] . " " . $row['user_lastname'];
              $rows[] = $row;
            }
          }

          // assign variables
          $smarty->assign('rows', $rows);
          $smarty->assign('pager', $pager->getPager());
          $smarty->assign('query', ($_GET['query']) ? htmlentities($_GET['query'], ENT_QUOTES, 'utf-8') : null);
          break;

        case 'replies':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Forums") . " &rsaquo; " . __("Replies"));

          // get data
          require('includes/class-pager.php');
          $params['selected_page'] = (!isset($_GET['page']) || (int) $_GET['page'] == 0) ? 1 : $_GET['page'];
          $total = $db->query("SELECT COUNT(*) as count FROM forums_replies INNER JOIN users ON forums_replies.user_id = users.user_id INNER JOIN forums_threads ON forums_replies.thread_id = forums_threads.thread_id");
          $params['total_items'] = $total->fetch_assoc()['count'];
          $params['items_per_page'] = $system['max_results'];
          $params['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/forums/replies?page=%s';
          $pager = new Pager($params);
          $limit_query = $pager->getLimitSql();
          $get_rows = paged_query("SELECT forums_replies.*, forums_threads.title, users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM forums_replies INNER JOIN users ON forums_replies.user_id = users.user_id INNER JOIN forums_threads ON forums_replies.thread_id = forums_threads.thread_id ORDER BY forums_replies.reply_id ASC ", 'forums_replies.reply_id', $limit_query);
          if ($get_rows->num_rows > 0) {
            while ($row = $get_rows->fetch_assoc()) {
              $row['thread_title_url'] = get_url_text($row['title']);
              $row['reply_author_picture'] = get_picture($row['user_picture'], $row['user_gender']);
              $row['reply_author_url'] = $system['system_url'] . '/' . $row['user_name'];
              $row['reply_author_name'] = ($system['show_usernames_enabled']) ? $row['user_name'] : $row['user_firstname'] . " " . $row['user_lastname'];
              $rows[] = $row;
            }
          }

          // assign variables
          $smarty->assign('rows', $rows);
          $smarty->assign('pager', $pager->getPager());
          break;

        case 'find_replies':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Forums") . " &rsaquo; " . __("Replies"));

          // get data
          require('includes/class-pager.php');
          $params['selected_page'] = (!isset($_GET['page']) || (int) $_GET['page'] == 0) ? 1 : $_GET['page'];
          $total = $db->query(sprintf('SELECT COUNT(*) as count FROM forums_replies INNER JOIN users ON forums_replies.user_id = users.user_id INNER JOIN forums_threads ON forums_replies.thread_id = forums_threads.thread_id WHERE forums_replies.text LIKE %1$s', secure($_GET['query'], 'search')));
          $params['total_items'] = $total->fetch_assoc()['count'];
          $params['items_per_page'] = $system['max_results'];
          $params['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/forums/find_replies?query=' . $_GET['query'] . '&page=%s';
          $pager = new Pager($params);
          $limit_query = $pager->getLimitSql();
          $get_rows = paged_query(sprintf('SELECT forums_replies.*, forums_threads.title, users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM forums_replies INNER JOIN users ON forums_replies.user_id = users.user_id INNER JOIN forums_threads ON forums_replies.thread_id = forums_threads.thread_id WHERE forums_replies.text LIKE %1$s ', secure($_GET['query'], 'search')), 'forums_replies.reply_id', $limit_query);
          if ($get_rows->num_rows > 0) {
            while ($row = $get_rows->fetch_assoc()) {
              $row['thread_title_url'] = get_url_text($row['title']);
              $row['reply_author_picture'] = get_picture($row['user_picture'], $row['user_gender']);
              $row['reply_author_url'] = $system['system_url'] . '/' . $row['user_name'];
              $row['reply_author_name'] = ($system['show_usernames_enabled']) ? $row['user_name'] : $row['user_firstname'] . " " . $row['user_lastname'];
              $rows[] = $row;
            }
          }

          // assign variables
          $smarty->assign('rows', $rows);
          $smarty->assign('pager', $pager->getPager());
          $smarty->assign('query', ($_GET['query']) ? htmlentities($_GET['query'], ENT_QUOTES, 'utf-8') : null);
          break;

        default:
          _error(404);
          break;
      }
      break;

    case 'movies':
      // check admin|moderator permission
      if ($user->_is_moderator && !$system['mods_movies_permission']) {
        _error(__('System Message'), __("You don't have the right permission to access this"));
      }

      // get nested view content
      switch ($_GET['sub_view']) {
        case '':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Movies"));

          // get insights
          $insights = [];
          $get_movies = $db->query("SELECT COUNT(*) as count FROM movies");
          $insights['movies'] = $get_movies->fetch_assoc()['count'];
          $get_paid = $db->query("SELECT COUNT(*) as count FROM movies WHERE is_paid = '1'");
          $insights['paid'] = $get_paid->fetch_assoc()['count'];
          $get_free = $db->query("SELECT COUNT(*) as count FROM movies WHERE is_paid = '0'");
          $insights['free'] = $get_free->fetch_assoc()['count'];
          $get_genres = $db->query("SELECT COUNT(*) as count FROM movies_genres");
          $insights['genres'] = $get_genres->fetch_assoc()['count'];

          // get data
          $get_rows = $db->query("SELECT * FROM movies");
          if ($get_rows->num_rows > 0) {
            while ($row = $get_rows->fetch_assoc()) {
              $row['movie_url'] = get_url_text($row['title']);
              $row['poster'] = get_picture($row['poster'], 'movie');
              $rows[] = $row;
            }
          }

          // assign variables
          $smarty->assign('insights', $insights);
          $smarty->assign('rows', $rows);
          break;

        case 'edit_movie':
          // valid inputs
          if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
            _error(404);
          }

          // get data
          $get_data = $db->query(sprintf("SELECT * FROM movies WHERE movie_id = %s", secure($_GET['id'], 'int')));
          if ($get_data->num_rows == 0) {
            _error(404);
          }
          $data = $get_data->fetch_assoc();
          /* get movie genres */
          $data['genres'] = ($data['genres']) ? explode(',', $data['genres']) : [];

          /* get genres */
          $data['movies_genres'] = $user->get_movies_genres();

          // assign variables
          $smarty->assign('data', $data);

          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Movies") . " &rsaquo; " . $data['title']);
          break;

        case 'add_movie':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Movies") . " &rsaquo; " . __("Add New Movie"));

          // get data
          $genres = $user->get_movies_genres();

          // assign variables
          $smarty->assign('genres', $genres);
          break;

        case 'genres':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Movies") . " &rsaquo; " . __("Genres"));

          // get data
          $rows = $user->get_movies_genres(false);

          // assign variables
          $smarty->assign('rows', $rows);
          break;

        case 'edit_genre':
          // valid inputs
          if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
            _error(404);
          }

          // get data
          $get_data = $db->query(sprintf("SELECT * FROM movies_genres WHERE genre_id = %s", secure($_GET['id'], 'int')));
          if ($get_data->num_rows == 0) {
            _error(404);
          }
          $data = $get_data->fetch_assoc();

          // assign variables
          $smarty->assign('data', $data);

          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Movies") . " &rsaquo; " . __("Genres") . " &rsaquo; " . $data['genre_name']);
          break;

        case 'add_genre':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Movies") . " &rsaquo; " . __("Genres") . " &rsaquo; " . __("Add New Genre"));
          break;

        default:
          _error(404);
          break;
      }
      break;

    case 'games':
      // check admin|moderator permission
      if ($user->_is_moderator && !$system['mods_games_permission']) {
        _error(__('System Message'), __("You don't have the right permission to access this"));
      }

      // prepare games genres
      $games_genres_map = [];
      foreach ($user->get_games_genres() as $_genre) {
        $games_genres_map[$_genre['genre_id']] = $_genre['genre_name'];
      }

      // get nested view content
      switch ($_GET['sub_view']) {
        case '':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Games"));

          // get insights
          $insights = [];
          $get_games = $db->query("SELECT COUNT(*) as count FROM games");
          $insights['games'] = $get_games->fetch_assoc()['count'];
          $insights['genres'] = count($games_genres_map);
          $get_players = $db->query("SELECT COUNT(DISTINCT user_id) as count FROM games_players");
          $insights['players'] = $get_players->fetch_assoc()['count'];
          $get_played = $db->query("SELECT COUNT(DISTINCT game_id) as count FROM games_players");
          $insights['played'] = $get_played->fetch_assoc()['count'];

          // get data
          require('includes/class-pager.php');
          $params['selected_page'] = (!isset($_GET['page']) || (int) $_GET['page'] == 0) ? 1 : $_GET['page'];
          $params['total_items'] = $insights['games'];
          $params['items_per_page'] = $system['max_results'];
          $params['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/games?page=%s';
          $pager = new Pager($params);
          $limit_query = $pager->getLimitSql();
          $get_rows = paged_query("SELECT * FROM games ORDER BY game_id DESC ", 'games.game_id', $limit_query);
          if ($get_rows->num_rows > 0) {
            while ($row = $get_rows->fetch_assoc()) {
              $row['title_url'] = get_url_text($row['title']);
              $row['thumbnail'] = get_picture($row['thumbnail'], 'game');
              /* get game genres */
              $row['genres_list'] = [];
              foreach (array_filter(explode(',', $row['genres'])) as $_genre_id) {
                if (isset($games_genres_map[$_genre_id])) {
                  $row['genres_list'][] = $games_genres_map[$_genre_id];
                }
              }
              $rows[] = $row;
            }
            /* get games players */
            $players = $user->get_games_players(array_column($rows, 'game_id'));
            foreach ($rows as $key => $row) {
              $rows[$key]['players'] = (isset($players[$row['game_id']])) ? $players[$row['game_id']] : 0;
            }
          }

          // assign variables
          $smarty->assign('insights', $insights);
          $smarty->assign('rows', $rows);
          $smarty->assign('pager', $pager->getPager());
          break;

        case 'find':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Games") . " &rsaquo; " . __("Find"));

          // get data
          require('includes/class-pager.php');
          $params['selected_page'] = (!isset($_GET['page']) || (int) $_GET['page'] == 0) ? 1 : $_GET['page'];
          $total = $db->query(sprintf("SELECT COUNT(*) as count FROM games WHERE (title LIKE %1\$s OR description LIKE %1\$s)", secure($_GET['query'], 'search')));
          $params['total_items'] = $total->fetch_assoc()['count'];
          $params['items_per_page'] = $system['max_results'];
          $params['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/games/find?query=' . urlencode($_GET['query']) . '&page=%s';
          $pager = new Pager($params);
          $limit_query = $pager->getLimitSql();
          $get_rows = paged_query(sprintf("SELECT * FROM games WHERE (title LIKE %1\$s OR description LIKE %1\$s) ORDER BY game_id DESC ", secure($_GET['query'], 'search')), 'games.game_id', $limit_query);
          if ($get_rows->num_rows > 0) {
            while ($row = $get_rows->fetch_assoc()) {
              $row['title_url'] = get_url_text($row['title']);
              $row['thumbnail'] = get_picture($row['thumbnail'], 'game');
              /* get game genres */
              $row['genres_list'] = [];
              foreach (array_filter(explode(',', $row['genres'])) as $_genre_id) {
                if (isset($games_genres_map[$_genre_id])) {
                  $row['genres_list'][] = $games_genres_map[$_genre_id];
                }
              }
              $rows[] = $row;
            }
            /* get games players */
            $players = $user->get_games_players(array_column($rows, 'game_id'));
            foreach ($rows as $key => $row) {
              $rows[$key]['players'] = (isset($players[$row['game_id']])) ? $players[$row['game_id']] : 0;
            }
          }

          // assign variables
          $smarty->assign('rows', $rows);
          $smarty->assign('pager', $pager->getPager());
          $smarty->assign('query', ($_GET['query']) ? htmlentities($_GET['query'], ENT_QUOTES, 'utf-8') : null);
          break;

        case 'edit':
          // valid inputs
          if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
            _error(404);
          }

          // get data
          $get_data = $db->query(sprintf("SELECT * FROM games WHERE game_id = %s", secure($_GET['id'], 'int')));
          if ($get_data->num_rows == 0) {
            _error(404);
          }
          $data = $get_data->fetch_assoc();
          /* get game genres */
          $data['genres'] = ($data['genres']) ? explode(',', $data['genres']) : [];

          /* get genres */
          $data['games_genres'] = $user->get_games_genres();

          // assign variables
          $smarty->assign('data', $data);

          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Games") . " &rsaquo; " . $data['title']);
          break;

        case 'add':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Games") . " &rsaquo; " . __("Add New"));

          // get data
          $genres = $user->get_games_genres();

          // assign variables
          $smarty->assign(
            'genres',
            $genres
          );
          break;

        case 'genres':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Games") . " &rsaquo; " . __("Genres"));

          // get data
          $rows = $user->get_games_genres(false);

          // assign variables
          $smarty->assign('rows', $rows);
          break;

        case 'edit_genre':
          // valid inputs
          if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
            _error(404);
          }

          // get data
          $get_data = $db->query(sprintf("SELECT * FROM games_genres WHERE genre_id = %s", secure($_GET['id'], 'int')));
          if ($get_data->num_rows == 0) {
            _error(404);
          }
          $data = $get_data->fetch_assoc();

          // assign variables
          $smarty->assign('data', $data);

          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Games") . " &rsaquo; " . __("Genres") . " &rsaquo; " . $data['genre_name']);
          break;

        case 'add_genre':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Games") . " &rsaquo; " . __("Genres") . " &rsaquo; " . __("Add New Genre"));
          break;

        default:
          _error(404);
          break;
      }
      break;

    case 'earnings':
    case 'wallet':
    case 'pro':
    case 'paid_modules':
    case 'funding':
    case 'monetization':
    case 'tips':
    case 'coinpayments':
    case 'bank':
      if ($licence_monetization && licence_module_installed()) {
        admin_monetization_view();
      } else {
        $licence_pages = [
          'earnings' => __("Earnings"),
          'wallet' => __("Wallet"),
          'pro' => __("Pro System"),
          'paid_modules' => __("Paid Modules"),
          'funding' => __("Funding"),
          'monetization' => __("Monetization"),
          'tips' => __("Tips"),
          'coinpayments' => __("CoinPayments"),
          'bank' => __("Bank Receipts"),
        ];
        $smarty->assign('licence_page', $licence_pages[$_GET['view']]);

        // page header
        page_header($control_panel['title'] . " &rsaquo; " . $licence_pages[$_GET['view']]);
      }
      break;

    case 'dating':
      // check admin|moderator permission
      if ($user->_is_moderator && (!$system['mods_dating_permission'] || !in_array($_GET['sub_view'], ['members', 'edit_member', 'photos']))) {
        _error(__('System Message'), __("You don't have the right permission to access this"));
      }

      // get nested view content
      switch ($_GET['sub_view']) {
        case '':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Dating"));

          // get insights
          $insights = $user->get_dating_insights();

          // assign variables
          $smarty->assign('insights', $insights);
          break;

        case 'settings':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Dating") . " &rsaquo; " . __("Settings"));
          break;

        case 'photos':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Dating") . " &rsaquo; " . __("Photos"));

          // get data
          require('includes/class-pager.php');
          $params['selected_page'] = (!isset($_GET['page']) || (int) $_GET['page'] == 0) ? 1 : $_GET['page'];
          $params['total_items'] = $db->query("SELECT COUNT(*) as count FROM dating_photos WHERE status = 'pending'")->fetch_assoc()['count'];
          $params['items_per_page'] = $system['max_results'];
          $params['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/dating/photos?page=%s';
          $pager = new Pager($params);
          $limit_query = $pager->getLimitSql();
          $rows = [];
          $get_rows = $db->query("SELECT dating_photos.*, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM dating_photos INNER JOIN users ON dating_photos.user_id = users.user_id WHERE dating_photos.status = 'pending' ORDER BY dating_photos.photo_id ASC " . $limit_query);
          while ($row = $get_rows->fetch_assoc()) {
            $row['user_picture'] = get_picture($row['user_picture'], $row['user_gender']);
            $rows[] = $row;
          }

          // assign variables
          $smarty->assign('rows', $rows);
          $smarty->assign('pager', $pager->getPager());
          break;

        case 'members':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Dating") . " &rsaquo; " . __("Members"));

          // get data
          $status = (isset($_GET['status']) && in_array($_GET['status'], ['active', 'paused', 'suspended'])) ? $_GET['status'] : '';
          $query = (isset($_GET['query']) && is_string($_GET['query'])) ? trim($_GET['query']) : '';
          $where = [];
          if ($status) {
            $where[] = sprintf("dating_profiles.status = %s", secure($status));
          }
          if ($query !== '') {
            $where[] = sprintf('(users.user_name LIKE %1$s OR users.user_firstname LIKE %1$s OR users.user_lastname LIKE %1$s OR CONCAT(users.user_firstname, " ", users.user_lastname) LIKE %1$s OR users.user_email LIKE %1$s OR users.user_phone LIKE %1$s)', secure($query, 'search'));
          }
          $where_query = ($where) ? " WHERE " . implode(" AND ", $where) : "";
          require('includes/class-pager.php');
          $params['selected_page'] = (!isset($_GET['page']) || (int) $_GET['page'] == 0) ? 1 : $_GET['page'];
          $params['total_items'] = $db->query("SELECT COUNT(*) as count FROM dating_profiles INNER JOIN users ON dating_profiles.user_id = users.user_id" . $where_query)->fetch_assoc()['count'];
          $params['items_per_page'] = $system['max_results'];
          $params['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/dating/members?' . (($status) ? 'status=' . $status . '&' : '') . (($query !== '') ? 'query=' . urlencode($query) . '&' : '') . 'page=%s';
          $pager = new Pager($params);
          $limit_query = $pager->getLimitSql();
          $rows = [];
          $get_rows = $db->query("SELECT dating_profiles.user_id, dating_profiles.status, dating_profiles.birthdate, dating_profiles.city, dating_profiles.time, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, users.user_verified, (SELECT COUNT(*) FROM dating_swipes WHERE dating_swipes.target_id = dating_profiles.user_id AND dating_swipes.action != 'pass') AS likes, (SELECT COUNT(*) FROM dating_matches WHERE dating_matches.status = 'active' AND (dating_matches.user_one_id = dating_profiles.user_id OR dating_matches.user_two_id = dating_profiles.user_id)) AS matches, (SELECT COUNT(*) FROM reports WHERE reports.node_type = 'user' AND reports.node_id = dating_profiles.user_id) AS reports FROM dating_profiles INNER JOIN users ON dating_profiles.user_id = users.user_id" . $where_query . " ORDER BY dating_profiles.time DESC " . $limit_query);
          while ($row = $get_rows->fetch_assoc()) {
            $row['user_picture'] = get_picture($row['user_picture'], $row['user_gender']);
            $row['age'] = get_user_age($row['birthdate']);
            $rows[] = $row;
          }

          // assign variables
          $smarty->assign('rows', $rows);
          $smarty->assign('status', $status);
          $smarty->assign('query', htmlentities($query, ENT_QUOTES, 'utf-8'));
          $smarty->assign('query_url', urlencode($query));
          $smarty->assign('pager', $pager->getPager());
          break;

        case 'edit_member':
          // valid inputs
          if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
            _error(404);
          }

          // get data
          $data = $user->get_dating_profile($_GET['id']);
          if (!$data) {
            _error(404);
          }
          $get_member = $db->query(sprintf("SELECT user_name, user_firstname, user_lastname, user_gender, user_picture, user_verified FROM users WHERE user_id = %s", secure($_GET['id'], 'int')));
          if ($get_member->num_rows == 0) {
            _error(404);
          }
          $data = array_merge($data, $get_member->fetch_assoc());
          $data['user_picture'] = get_picture($data['user_picture'], $data['user_gender']);
          $data['interests'] = $user->get_dating_profiles_interests([$data['user_id']])[$data['user_id']] ?? [];
          $data['photos'] = $user->get_dating_photos([$data['user_id']], false)[$data['user_id']] ?? [];
          $data['likes'] = $db->query(sprintf("SELECT COUNT(*) as count FROM dating_swipes WHERE target_id = %s AND action != 'pass'", secure($data['user_id'], 'int')))->fetch_assoc()['count'];
          $data['matches'] = $db->query(sprintf("SELECT COUNT(*) as count FROM dating_matches WHERE status = 'active' AND (user_one_id = %1\$s OR user_two_id = %1\$s)", secure($data['user_id'], 'int')))->fetch_assoc()['count'];
          $data['reports'] = $db->query(sprintf("SELECT COUNT(*) as count FROM reports WHERE node_type = 'user' AND node_id = %s", secure($data['user_id'], 'int')))->fetch_assoc()['count'];

          // assign variables
          $smarty->assign('data', $data);
          $smarty->assign('genders', $user->get_genders());
          $smarty->assign('countries', $user->get_countries());
          $smarty->assign('dating_interests', $user->get_dating_interests());

          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Dating") . " &rsaquo; " . __("Members") . " &rsaquo; " . $data['user_firstname'] . " " . $data['user_lastname']);
          break;

        case 'interests':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Dating") . " &rsaquo; " . __("Interests"));

          // assign variables
          $smarty->assign('rows', $user->get_dating_interests());
          break;

        case 'add_interest':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Dating") . " &rsaquo; " . __("Interests") . " &rsaquo; " . __("Add New Interest"));
          break;

        case 'edit_interest':
          // valid inputs
          if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
            _error(404);
          }

          // get data
          $get_data = $db->query(sprintf("SELECT * FROM dating_interests WHERE interest_id = %s", secure($_GET['id'], 'int')));
          if ($get_data->num_rows == 0) {
            _error(404);
          }
          $data = $get_data->fetch_assoc();

          // assign variables
          $smarty->assign('data', $data);

          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Dating") . " &rsaquo; " . __("Interests") . " &rsaquo; " . $data['title']);
          break;

        default:
          _error(404);
          break;
      }
      break;

    case 'stories':
      // check admin|moderator permission
      if ($user->_is_moderator && (!$system['mods_stories_permission'] || in_array($_GET['sub_view'], ['']))) {
        _error(__('System Message'), __("You don't have the right permission to access this"));
      }

      // get nested view content
      switch ($_GET['sub_view']) {
        case '':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Stories"));

          // get data
          $get_active = $db->query(sprintf("SELECT COUNT(*) as stories, COUNT(DISTINCT user_id) as authors, IFNULL(SUM(views_count), 0) as views, IFNULL(SUM(reactions_count), 0) as reactions, IFNULL(SUM(replies_count), 0) as replies FROM stories WHERE expires_at > %s", secure($date)));
          $insights = $get_active->fetch_assoc();
          $get_highlights = $db->query("SELECT COUNT(*) as count FROM stories_highlights");
          $insights['highlights'] = $get_highlights->fetch_assoc()['count'];
          $get_music = $db->query("SELECT COUNT(*) as count FROM stories_music WHERE enabled = '1'");
          $insights['music'] = $get_music->fetch_assoc()['count'];
          $get_reports = $db->query("SELECT COUNT(*) as count FROM reports WHERE node_type = 'story'");
          $insights['reports'] = $get_reports->fetch_assoc()['count'];

          // assign variables
          $smarty->assign('insights', $insights);
          break;

        case 'list':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Stories") . " &rsaquo; " . __("List Stories"));

          // get data
          $status = (isset($_GET['status']) && $_GET['status'] == 'archived') ? 'archived' : 'active';
          $where_query = sprintf(" WHERE stories.expires_at %s %s", ($status == 'archived') ? '<=' : '>', secure($date));
          require('includes/class-pager.php');
          $params['selected_page'] = (!isset($_GET['page']) || (int) $_GET['page'] == 0) ? 1 : $_GET['page'];
          $total = $db->query("SELECT COUNT(*) as count FROM stories" . $where_query);
          $params['total_items'] = $total->fetch_assoc()['count'];
          $params['items_per_page'] = $system['max_results'];
          $params['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/stories/list?' . (($status == 'archived') ? 'status=archived&' : '') . 'page=%s';
          $pager = new Pager($params);
          $limit_query = $pager->getLimitSql();
          $rows = [];
          $get_rows = $db->query("SELECT stories.*, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM stories INNER JOIN users ON stories.user_id = users.user_id" . $where_query . " ORDER BY stories.story_id DESC " . $limit_query);
          while ($row = $get_rows->fetch_assoc()) {
            $row['user_picture'] = get_picture($row['user_picture'], $row['user_gender']);
            $preview = ($row['type'] == 'photo') ? $row['source'] : $row['thumbnail'];
            $row['preview'] = ($preview) ? $system['system_uploads'] . '/' . $preview : '';
            $row['media'] = ($row['type'] != 'text' && $row['source']) ? $system['system_uploads'] . '/' . $row['source'] : '';
            $rows[] = $row;
          }

          // assign variables
          $smarty->assign('status', $status);
          $smarty->assign('rows', $rows);
          $smarty->assign('pager', $pager->getPager());
          break;

        case 'music':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Stories") . " &rsaquo; " . __("Music Library"));

          // get data
          $query = (isset($_GET['query'])) ? trim($_GET['query']) : '';
          $where_query = (!is_empty($query)) ? sprintf(" WHERE title LIKE %1\$s OR artist LIKE %1\$s", secure($query, 'search')) : "";
          require('includes/class-pager.php');
          $params['selected_page'] = (!isset($_GET['page']) || (int) $_GET['page'] == 0) ? 1 : $_GET['page'];
          $total = $db->query("SELECT COUNT(*) as count FROM stories_music" . $where_query);
          $params['total_items'] = $total->fetch_assoc()['count'];
          $params['items_per_page'] = $system['max_results'];
          $params['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/stories/music?page=%s' . ((!is_empty($query)) ? '&query=' . urlencode($query) : '');
          $pager = new Pager($params);
          $limit_query = $pager->getLimitSql();
          $rows = [];
          $get_rows = $db->query("SELECT * FROM stories_music" . $where_query . " ORDER BY music_id DESC " . $limit_query);
          while ($row = $get_rows->fetch_assoc()) {
            $rows[] = array_merge($row, $user->parse_story_music($row));
          }

          // assign variables
          $smarty->assign('rows', $rows);
          $smarty->assign('query', htmlentities($query, ENT_QUOTES, 'utf-8'));
          $smarty->assign('pager', $pager->getPager());
          break;

        case 'add_music':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Stories") . " &rsaquo; " . __("Music Library") . " &rsaquo; " . __("Add New Track"));
          break;

        case 'edit_music':
          // valid inputs
          if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
            _error(404);
          }

          // get data
          $get_data = $db->query(sprintf("SELECT * FROM stories_music WHERE provider = 'library' AND music_id = %s", secure($_GET['id'], 'int')));
          if ($get_data->num_rows == 0) {
            _error(404);
          }
          $data = $get_data->fetch_assoc();

          // assign variables
          $smarty->assign('data', $data);

          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Stories") . " &rsaquo; " . __("Music Library") . " &rsaquo; " . $data['title']);
          break;

        default:
          _error(404);
          break;
      }
      break;

    case 'ads':
      // check admin|moderator permission
      if ($user->_is_moderator && !$system['mods_ads_permission']) {
        _error(__('System Message'), __("You don't have the right permission to access this"));
      }

      // get nested view content
      switch ($_GET['sub_view']) {
        case '':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Ads") . " &rsaquo; " . __("Settings"));
          break;

        case 'users_ads':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Ads") . " &rsaquo; " . __("Users Ads"));

          if ($licence_monetization && licence_module_installed()) {
            admin_monetization_users_ads();
          }
          break;

        case 'system_ads':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Ads") . " &rsaquo; " . __("System Ads"));

          // get data
          $get_rows = $db->query("SELECT * FROM ads_system");
          if ($get_rows->num_rows > 0) {
            while ($row = $get_rows->fetch_assoc()) {
              $rows[] = $row;
            }
          }

          // assign variables
          $smarty->assign('rows', $rows);
          break;

        case 'edit':
          // valid inputs
          if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
            _error(404);
          }

          // get data
          $get_data = $db->query(sprintf("SELECT * FROM ads_system WHERE ads_id = %s", secure($_GET['id'], 'int')));
          if ($get_data->num_rows == 0) {
            _error(404);
          }
          $data = $get_data->fetch_assoc();

          // assign variables
          $smarty->assign('data', $data);

          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Ads") . " &rsaquo; " . $data['title']);
          break;

        case 'add':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Ads") . " &rsaquo; " . __("Add New"));
          break;

        default:
          _error(404);
          break;
      }
      break;

    case 'affiliates':
      // check admin|moderator permission
      if ($user->_is_moderator && !$system['mods_affiliates_permission']) {
        _error(__('System Message'), __("You don't have the right permission to access this"));
      }

      // get nested view content
      switch ($_GET['sub_view']) {
        case '':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Affiliates"));
          break;

        case 'payments':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Affiliates") . " &rsaquo; " . __("Payment Requests"));

          // get data
          $get_rows = $db->query("SELECT affiliates_payments.*, users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM affiliates_payments INNER JOIN users ON affiliates_payments.user_id = users.user_id WHERE affiliates_payments.status = '0'");
          if ($get_rows->num_rows > 0) {
            while ($row = $get_rows->fetch_assoc()) {
              $row['user_picture'] = get_picture($row['user_picture'], $row['user_gender']);
              switch ($row['method']) {
                case 'paypal':
                  $row['method_color'] = "info";
                  break;

                case 'skrill':
                  $row['method_color'] = "primary";
                  break;

                case 'bank':
                  $row['method_color'] = "danger";
                  break;

                case 'custom':
                  $row['method'] = $system['affiliate_payment_method_custom'];
                  $row['method_color'] = "warning";
                  break;
              }
              $rows[] = $row;
            }
          }

          // assign variables
          $smarty->assign('rows', $rows);
          break;

        default:
          _error(404);
          break;
      }
      break;

    case 'points':
      // check admin|moderator permission
      if ($user->_is_moderator && !$system['mods_points_permission']) {
        _error(__('System Message'), __("You don't have the right permission to access this"));
      }

      // get nested view content
      switch ($_GET['sub_view']) {
        case '':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Points System"));
          break;

        case 'payments':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Points System") . " &rsaquo; " . __("Payment Requests"));

          // get data
          $get_rows = $db->query("SELECT points_payments.*, users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM points_payments INNER JOIN users ON points_payments.user_id = users.user_id WHERE points_payments.status = '0'");
          if ($get_rows->num_rows > 0) {
            while ($row = $get_rows->fetch_assoc()) {
              $row['user_picture'] = get_picture($row['user_picture'], $row['user_gender']);
              switch ($row['method']) {
                case 'paypal':
                  $row['method_color'] = "info";
                  break;

                case 'skrill':
                  $row['method_color'] = "primary";
                  break;

                case 'bank':
                  $row['method_color'] = "danger";
                  break;

                case 'custom':
                  $row['method'] = $system['points_payment_method_custom'];
                  $row['method_color'] = "warning";
                  break;
              }
              $rows[] = $row;
            }
          }

          // assign variables
          $smarty->assign('rows', $rows);
          break;

        default:
          _error(404);
          break;
      }
      break;

    case 'market':
      // check admin|moderator permission
      if ($user->_is_moderator && !$system['mods_marketplace_permission']) {
        _error(__('System Message'), __("You don't have the right permission to access this"));
      }

      // get nested view content
      switch ($_GET['sub_view']) {
        case '':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Marketplace"));
          break;

        case 'products':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Marketplace") . " &rsaquo; " . __("Products"));

          // get data
          require('includes/class-pager.php');
          $params['selected_page'] = (!isset($_GET['page']) || (int) $_GET['page'] == 0) ? 1 : $_GET['page'];
          $total = $db->query("SELECT COUNT(*) as count FROM posts INNER JOIN posts_products ON posts.post_id = posts_products.post_id AND posts.post_type = 'product' LEFT JOIN users ON posts.user_id = users.user_id AND posts.user_type = 'user' LEFT JOIN pages ON posts.user_id = pages.page_id AND posts.user_type = 'page' WHERE NOT (users.user_name <=> NULL AND pages.page_name <=> NULL)");
          $params['total_items'] = $total->fetch_assoc()['count'];
          $params['items_per_page'] = $system['max_results'];
          $params['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/market/products?page=%s';
          $pager = new Pager($params);
          $limit_query = $pager->getLimitSql();
          $get_rows = paged_query("SELECT posts.*, posts_products.name, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, pages.* FROM posts INNER JOIN posts_products ON posts.post_id = posts_products.post_id AND posts.post_type = 'product' LEFT JOIN users ON posts.user_id = users.user_id AND posts.user_type = 'user' LEFT JOIN pages ON posts.user_id = pages.page_id AND posts.user_type = 'page' WHERE NOT (users.user_name <=> NULL AND pages.page_name <=> NULL) ORDER BY posts.post_id ASC ", 'posts.post_id', $limit_query);
          if ($get_rows->num_rows > 0) {
            while ($row = $get_rows->fetch_assoc()) {
              /* check the post author type */
              if ($row['user_type'] == "user") {
                /* user */
                $row['post_author_picture'] = get_picture($row['user_picture'], $row['user_gender']);
                $row['post_author_url'] = $system['system_url'] . '/' . $row['user_name'];
                $row['post_author_name'] = ($system['show_usernames_enabled']) ? $row['user_name'] : $row['user_firstname'] . " " . $row['user_lastname'];
              } else {
                /* page */
                $row['post_author_picture'] = get_picture($row['page_picture'], "page");
                $row['post_author_url'] = $system['system_url'] . '/pages/' . $row['page_name'];
                $row['post_author_name'] = $row['page_title'];
              }
              $rows[] = $row;
            }
          }

          // assign variables
          $smarty->assign('rows', $rows);
          $smarty->assign('pager', $pager->getPager());
          break;

          // assign variables
          $smarty->assign('rows', $rows);
          break;

        case 'find':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Marketplace") . " &rsaquo; " . __("Products") . " &rsaquo; " . __("Find"));

          // valid inputs
          if (!isset($_GET['query']) || is_empty($_GET['query'])) {
            _error(404);
          }

          // get data
          require('includes/class-pager.php');
          $params['selected_page'] = (!isset($_GET['page']) || (int) $_GET['page'] == 0) ? 1 : $_GET['page'];
          $search_query = $user->posts_search_clause($_GET['query'], sprintf('(posts.text LIKE %1$s OR posts_products.name LIKE %1$s OR posts_products.location LIKE %1$s)', secure($_GET['query'], 'search')));
          $total = $db->query('SELECT COUNT(*) as count FROM posts INNER JOIN posts_products ON posts.post_id = posts_products.post_id AND posts.post_type = "product" LEFT JOIN users ON posts.user_id = users.user_id AND posts.user_type = "user" LEFT JOIN pages ON posts.user_id = pages.page_id AND posts.user_type = "page" WHERE NOT (users.user_name <=> NULL AND pages.page_name <=> NULL) AND ' . $search_query);
          $params['total_items'] = $total->fetch_assoc()['count'];
          $params['items_per_page'] = $system['max_results'];
          $params['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/market/find?query=' . $_GET['query'] . '&page=%s';
          $pager = new Pager($params);
          $limit_query = $pager->getLimitSql();
          $get_rows = paged_query('SELECT posts.*, posts_products.name, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, pages.* FROM posts INNER JOIN posts_products ON posts.post_id = posts_products.post_id AND posts.post_type = "product" LEFT JOIN users ON posts.user_id = users.user_id AND posts.user_type = "user" LEFT JOIN pages ON posts.user_id = pages.page_id AND posts.user_type = "page" WHERE NOT (users.user_name <=> NULL AND pages.page_name <=> NULL) AND ' . $search_query . ' ', 'posts.post_id', $limit_query);
          if ($get_rows->num_rows > 0) {
            while ($row = $get_rows->fetch_assoc()) {
              /* check the post author type */
              if ($row['user_type'] == "user") {
                /* user */
                $row['post_author_picture'] = get_picture($row['user_picture'], $row['user_gender']);
                $row['post_author_url'] = $system['system_url'] . '/' . $row['user_name'];
                $row['post_author_name'] = ($system['show_usernames_enabled']) ? $row['user_name'] : $row['user_firstname'] . " " . $row['user_lastname'];
              } else {
                /* page */
                $row['post_author_picture'] = get_picture($row['page_picture'], "page");
                $row['post_author_url'] = $system['system_url'] . '/pages/' . $row['page_name'];
                $row['post_author_name'] = $row['page_title'];
              }
              $rows[] = $row;
            }
          }

          // assign variables
          $smarty->assign('rows', $rows);
          $smarty->assign('pager', $pager->getPager());
          break;

        case 'orders':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Marketplace") . " &rsaquo; " . __("Orders"));

          if (!licence_has_entitlement('monetization')) {
            break;
          }

          // get data
          require('includes/class-pager.php');
          $params['selected_page'] = (!isset($_GET['page']) || (int) $_GET['page'] == 0) ? 1 : $_GET['page'];
          $total = $db->query("SELECT COUNT(*) as count FROM orders INNER JOIN users u1 ON orders.buyer_id = u1.user_id INNER JOIN users u2 ON orders.seller_id = u2.user_id");
          $params['total_items'] = $total->fetch_assoc()['count'];
          $params['items_per_page'] = $system['max_results'];
          $params['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/market/orders?page=%s';
          $pager = new Pager($params);
          $limit_query = $pager->getLimitSql();
          $get_rows = paged_query("SELECT orders.*, u1.user_name AS buyer_username, u1.user_firstname AS buyer_firstname, u1.user_lastname AS buyer_lastname, u1.user_picture AS buyer_user_picture, u1.user_gender AS buyer_user_gender, u2.user_name AS seller_username, u2.user_firstname AS seller_firstname, u2.user_lastname AS seller_lastname, u2.user_picture AS seller_user_picture, u2.user_gender AS seller_user_gender FROM orders INNER JOIN users u1 ON orders.buyer_id = u1.user_id INNER JOIN users u2 ON orders.seller_id = u2.user_id ORDER BY orders.order_id DESC ", 'orders.order_id', $limit_query);
          if ($get_rows->num_rows > 0) {
            while ($row = $get_rows->fetch_assoc()) {
              /* prepare buyer's info */
              $row['buyer_fullname'] = ($system['show_usernames_enabled']) ? $row['buyer_username'] : $row['buyer_firstname'] . ' ' . $row['buyer_lastname'];
              $row['buyer_picture'] = get_picture($row['buyer_user_picture'], $row['buyer_user_gender']);
              /* prepare seller's info */
              $row['seller_fullname'] = ($system['show_usernames_enabled']) ? $row['seller_username'] : $row['seller_firstname'] . ' ' . $row['seller_lastname'];
              $row['seller_picture'] = get_picture($row['seller_user_picture'], $row['seller_user_gender']);
              /* prepare total commission */
              $row['total_commission'] = $row['sub_total'] * ($row['commission'] / 100);
              /* prepare final price */
              $row['final_price'] = $row['sub_total'] - $row['total_commission'];
              $rows[] = $row;
            }
          }

          // assign variables
          $smarty->assign('rows', $rows);
          $smarty->assign('pager', $pager->getPager());
          break;

          // assign variables
          $smarty->assign('rows', $rows);
          break;

        case 'find_orders':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Marketplace") . " &rsaquo; " . __("Orders"));

          if (!licence_has_entitlement('monetization')) {
            break;
          }

          // valid inputs
          if (!isset($_GET['query']) || is_empty($_GET['query'])) {
            _error(404);
          }

          // get data
          require('includes/class-pager.php');
          $params['selected_page'] = (!isset($_GET['page']) || (int) $_GET['page'] == 0) ? 1 : $_GET['page'];
          $total = $db->query(sprintf('SELECT COUNT(*) as count FROM orders INNER JOIN users u1 ON orders.buyer_id = u1.user_id INNER JOIN users u2 ON orders.seller_id = u2.user_id WHERE orders.order_hash LIKE %1$s', secure($_GET['query'], 'search')));
          $params['total_items'] = $total->fetch_assoc()['count'];
          $params['items_per_page'] = $system['max_results'];
          $params['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/market/find_orders?query=' . $_GET['query'] . '&page=%s';
          $pager = new Pager($params);
          $limit_query = $pager->getLimitSql();
          $get_rows = paged_query(sprintf('SELECT orders.*, u1.user_name AS buyer_username, u1.user_firstname AS buyer_firstname, u1.user_lastname AS buyer_lastname, u1.user_picture AS buyer_user_picture, u1.user_gender AS buyer_user_gender, u2.user_name AS seller_username, u2.user_firstname AS seller_firstname, u2.user_lastname AS seller_lastname, u2.user_picture AS seller_user_picture, u2.user_gender AS seller_user_gender FROM orders INNER JOIN users u1 ON orders.buyer_id = u1.user_id INNER JOIN users u2 ON orders.seller_id = u2.user_id WHERE orders.order_hash LIKE %1$s ', secure($_GET['query'], 'search')), 'orders.order_id', $limit_query);
          if ($get_rows->num_rows > 0) {
            while ($row = $get_rows->fetch_assoc()) {
              /* prepare buyer's info */
              $row['buyer_fullname'] = ($system['show_usernames_enabled']) ? $row['buyer_username'] : $row['buyer_firstname'] . ' ' . $row['buyer_lastname'];
              $row['buyer_picture'] = get_picture($row['buyer_user_picture'], $row['buyer_user_gender']);
              /* prepare seller's info */
              $row['seller_fullname'] = ($system['show_usernames_enabled']) ? $row['seller_username'] : $row['seller_firstname'] . ' ' . $row['seller_lastname'];
              $row['seller_picture'] = get_picture($row['seller_user_picture'], $row['seller_user_gender']);
              /* prepare total commission */
              $row['total_commission'] = $row['sub_total'] * ($row['commission'] / 100);
              /* prepare final price */
              $row['final_price'] = $row['sub_total'] - $row['total_commission'];
              $rows[] = $row;
            }
          }

          // assign variables
          $smarty->assign('rows', $rows);
          $smarty->assign('pager', $pager->getPager());
          break;

        case 'categories':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Marketplace") . " &rsaquo; " . __("Categories"));

          // get data
          $rows = $user->get_categories("market_categories");

          // assign variables
          $smarty->assign('rows', $rows);
          break;

        case 'edit_category':
          // valid inputs
          if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
            _error(404);
          }

          // get data
          $get_data = $db->query(sprintf("SELECT * FROM market_categories WHERE category_id = %s", secure($_GET['id'], 'int')));
          if ($get_data->num_rows == 0) {
            _error(404);
          }
          $data = $get_data->fetch_assoc();
          /* get categories */
          $data['categories'] = $user->get_categories("market_categories");

          // assign variables
          $smarty->assign('data', $data);

          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Marketplace") . " &rsaquo; " . __("Categories") . " &rsaquo; " . $data['category_name']);
          break;

        case 'add_category':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Marketplace") . " &rsaquo; " . __("Categories") . " &rsaquo; " . __("Add New Category"));

          // get data
          $categories = $user->get_categories("market_categories");

          // assign variables
          $smarty->assign('categories', $categories);
          break;

        case 'payments':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Marketplace") . " &rsaquo; " . __("Payment Requests"));

          if (!licence_has_entitlement('monetization')) {
            break;
          }

          // get data
          $get_rows = $db->query("SELECT market_payments.*, users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM market_payments INNER JOIN users ON market_payments.user_id = users.user_id WHERE market_payments.status = '0'");
          if ($get_rows->num_rows > 0) {
            while ($row = $get_rows->fetch_assoc()) {
              $row['user_picture'] = get_picture($row['user_picture'], $row['user_gender']);
              switch ($row['method']) {
                case 'paypal':
                  $row['method_color'] = "info";
                  break;

                case 'skrill':
                  $row['method_color'] = "primary";
                  break;

                case 'bank':
                  $row['method_color'] = "danger";
                  break;

                case 'custom':
                  $row['method'] = $system['market_payment_method_custom'];
                  $row['method_color'] = "warning";
                  break;
              }
              $rows[] = $row;
            }
          }

          // assign variables
          $smarty->assign('rows', $rows);
          break;

        default:
          _error(404);
          break;
      }
      break;

    case 'developers':
      // check admin|moderator permission
      if ($user->_is_moderator && !$system['mods_developers_permission']) {
        _error(__('System Message'), __("You don't have the right permission to access this"));
      }

      // get nested view content
      switch ($_GET['sub_view']) {
        case '':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Developers") . " &rsaquo; " . __("Settings"));
          break;

        case 'apps':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Developers") . " &rsaquo; " . __("Apps"));

          // get data
          $get_rows = $db->query("SELECT developers_apps.*, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM developers_apps INNER JOIN users ON developers_apps.app_user_id = users.user_id");
          if ($get_rows->num_rows > 0) {
            while ($row = $get_rows->fetch_assoc()) {
              $row['user_picture'] = get_picture($row['user_picture'], $row['user_gender']);
              $rows[] = $row;
            }
          }

          // assign variables
          $smarty->assign('rows', $rows);
          break;

        case 'categories':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Developers") . " &rsaquo; " . __("Categories"));

          // get data
          $rows = $user->get_categories("developers_apps_categories");

          // assign variables
          $smarty->assign('rows', $rows);
          break;

        case 'edit_category':
          // valid inputs
          if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
            _error(404);
          }

          // get data
          $get_data = $db->query(sprintf("SELECT * FROM developers_apps_categories WHERE category_id = %s", secure($_GET['id'], 'int')));
          if ($get_data->num_rows == 0) {
            _error(404);
          }
          $data = $get_data->fetch_assoc();
          /* get categories */
          $data['categories'] = $user->get_categories("developers_apps_categories");

          // assign variables
          $smarty->assign('data', $data);

          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Developers") . " &rsaquo; " . __("Categories") . " &rsaquo; " . $data['category_name']);
          break;

        case 'add_category':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Developers") . " &rsaquo; " . __("Categories") . " &rsaquo; " . __("Add New Category"));

          // get data
          $categories = $user->get_categories("developers_apps_categories");

          // assign variables
          $smarty->assign('categories', $categories);
          break;

        default:
          _error(404);
          break;
      }
      break;

    case 'reports':
      // check admin|moderator permission
      if ($user->_is_moderator && !$system['mods_reports_permission']) {
        _error(__('System Message'), __("You don't have the right permission to access this"));
      }

      // get nested view content
      switch ($_GET['sub_view']) {
        case '':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Reports"));

          // get insights
          $insights = [];
          /* total reports */
          $get_reports = $db->query("SELECT COUNT(*) as count FROM reports");
          $insights['reports'] = $get_reports->fetch_assoc()['count'];
          $get_accounts = $db->query("SELECT COUNT(*) as count FROM reports WHERE node_type = 'user'");
          $insights['accounts'] = $get_accounts->fetch_assoc()['count'];
          $get_content = $db->query("SELECT COUNT(*) as count FROM reports WHERE node_type IN ('post', 'comment', 'forum_thread', 'forum_reply')");
          $insights['content'] = $get_content->fetch_assoc()['count'];
          $get_recent = $db->query("SELECT COUNT(*) as count FROM reports WHERE time >= DATE_SUB(NOW(), INTERVAL 7 DAY)");
          $insights['recent'] = $get_recent->fetch_assoc()['count'];

          // get filters
          $nodes_types = ['user', 'page', 'group', 'event', 'post', 'comment', 'message', 'conversation', 'forum_thread', 'forum_reply', 'ads_campaign', 'story'];
          $type = (isset($_GET['type']) && in_array($_GET['type'], $nodes_types)) ? $_GET['type'] : '';
          $category_id = (isset($_GET['category']) && is_numeric($_GET['category'])) ? $_GET['category'] : '';
          $query = (isset($_GET['query']) && !is_empty($_GET['query'])) ? $_GET['query'] : '';
          $where_query = "";
          $query_string = "";
          if (!is_empty($type)) {
            $where_query .= sprintf(" AND reports.node_type = %s", secure($type));
            $query_string .= "&type=" . urlencode($type);
          }
          if (!is_empty($category_id)) {
            $where_query .= sprintf(" AND reports.category_id = %s", secure($category_id, 'int'));
            $query_string .= "&category=" . urlencode($category_id);
          }
          if (!is_empty($query)) {
            $where_query .= sprintf(" AND (reports.reason LIKE %s OR reports.report_id LIKE %s OR users.user_name LIKE %s)", secure($query, 'search'), secure($query, 'search'), secure($query, 'search'));
            $query_string .= "&query=" . urlencode($query);
          }

          // get data
          require('includes/class-pager.php');
          $params['selected_page'] = (!isset($_GET['page']) || (int) $_GET['page'] == 0) ? 1 : $_GET['page'];
          $total = $db->query("SELECT COUNT(*) as count FROM reports INNER JOIN users ON reports.user_id = users.user_id WHERE 1 = 1" . $where_query);
          $params['total_items'] = $total->fetch_assoc()['count'];
          $params['items_per_page'] = $system['max_results'];
          $params['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/reports?page=%s' . $query_string;
          $pager = new Pager($params);
          $limit_query = $pager->getLimitSql();
          $get_rows = paged_query("SELECT reports.*, reports_categories.category_name, users.user_name, users.user_firstname, users.user_lastname, users.user_picture, users.user_gender FROM reports INNER JOIN users ON reports.user_id = users.user_id LEFT JOIN reports_categories ON reports.category_id = reports_categories.category_id WHERE 1 = 1" . $where_query . " ORDER BY reports.report_id DESC ", 'reports.report_id', $limit_query);
          if ($get_rows->num_rows > 0) {
            while ($row = $get_rows->fetch_assoc()) {
              $row['user_picture'] = get_picture($row['user_picture'], $row['user_gender']);
              /* get reported node */
              $node = [];
              if ($row['node_type'] == "user") {
                $get_node = $db->query(sprintf("SELECT user_name, user_firstname, user_lastname, user_gender, user_picture FROM users WHERE user_id = %s", secure($row['node_id'], 'int')));
                if ($get_node->num_rows == 0) continue;
                $node = $get_node->fetch_assoc();
                $node['user_picture'] = get_picture($node['user_picture'], $node['user_gender']);
                $node['name'] = __("User");
              } elseif ($row['node_type'] == 'page') {
                $get_node = $db->query(sprintf("SELECT page_name, page_title, page_picture FROM pages WHERE page_id = %s", secure($row['node_id'], 'int')));
                if ($get_node->num_rows == 0) continue;
                $node = $get_node->fetch_assoc();
                $node['page_picture'] = get_picture($node['page_picture'], 'page');
                $node['name'] = __("Page");
              } elseif ($row['node_type'] == 'group') {
                $get_node = $db->query(sprintf("SELECT group_name, group_title, group_picture FROM `groups` WHERE group_id = %s", secure($row['node_id'], 'int')));
                if ($get_node->num_rows == 0) continue;
                $node = $get_node->fetch_assoc();
                $node['group_picture'] = get_picture($node['group_picture'], 'group');
                $node['name'] = __("Group");
              } elseif ($row['node_type'] == 'event') {
                $get_node = $db->query(sprintf("SELECT event_title, event_cover FROM `events` WHERE event_id = %s", secure($row['node_id'], 'int')));
                if ($get_node->num_rows == 0) continue;
                $node = $get_node->fetch_assoc();
                $node['event_picture'] = get_picture($node['event_cover'], 'event');
                $node['name'] = __("Event");
              } elseif ($row['node_type'] == 'comment') {
                $comment = $user->get_comment($row['node_id']);
                if (!$comment) continue;
                if ($comment['node_type'] == "post") {
                  $_handle = '/posts/';
                  $_node_id = $comment['node_id'];
                } elseif ($comment['node_type'] == "photo") {
                  $_handle = '/photos/';
                  $_node_id = $comment['node_id'];
                } elseif ($comment['node_type'] == "comment") {
                  $_handle = ($comment['parent_comment']['node_type'] == "post") ? '/posts/' : '/photos/';
                  $_node_id = $comment['parent_comment']['node_id'];
                }
                $row['url'] = $system['system_url'] . $_handle . $_node_id . '?notify_id=comment_' . $row['node_id'];
                $node['name'] = __("Comment");
              } elseif ($row['node_type'] == 'post') {
                $row['url'] = $system['system_url'] . '/posts/' . $row['node_id'];
                $node['name'] = __("Post");
              } elseif ($row['node_type'] == 'forum_thread') {
                $thread = $user->get_forum_thread($row['node_id']);
                if (!$thread) continue;
                $row['url'] = $system['system_url'] . '/forums/thread/' . $thread['thread_id'] . '/' . $thread['title_url'];
                $node['name'] = __("Forum Thread");
              } elseif ($row['node_type'] == 'forum_reply') {
                $reply = $user->get_forum_reply($row['node_id']);
                if (!$reply) continue;
                $row['url'] = $system['system_url'] . '/forums/thread/' . $reply['thread']['thread_id'] . '/' . $reply['thread']['title_url'] . '/#reply-' . $reply['reply_id'];
                $node['name'] = __("Forum Reply");
              } elseif ($row['node_type'] == 'ads_campaign') {
                $row['url'] = $system['system_url'] . '/ads/edit/' . $row['node_id'];
                $node['name'] = __("Ads Campaign");
              } elseif ($row['node_type'] == 'story') {
                $get_node = $db->query(sprintf("SELECT story_id FROM stories WHERE story_id = %s", secure($row['node_id'], 'int')));
                if ($get_node->num_rows == 0) continue;
                $row['url'] = $system['system_url'] . '/?story=' . $row['node_id'];
                $node['name'] = __("Story");
              } elseif ($row['node_type'] == 'message') {
                $get_node = $db->query(sprintf("SELECT message_id FROM conversations_messages WHERE message_id = %s", secure($row['node_id'], 'int')));
                if ($get_node->num_rows == 0) continue;
                $node['name'] = __("Message");
              } elseif ($row['node_type'] == 'conversation') {
                $get_node = $db->query(sprintf("SELECT conversation_id FROM conversations WHERE conversation_id = %s", secure($row['node_id'], 'int')));
                if ($get_node->num_rows == 0) continue;
                $node['name'] = __("Conversation");
              } else {
                $node['name'] = ucfirst(str_replace('_', ' ', $row['node_type']));
              }
              $row['node'] = $node;
              $rows[] = $row;
            }
          }

          // get categories
          $categories = $user->get_categories("reports_categories");

          // assign variables
          $smarty->assign('insights', $insights);
          $smarty->assign('categories', $categories);
          $smarty->assign('type', $type);
          $smarty->assign('category_id', $category_id);
          $smarty->assign('query', ($query) ? htmlentities($query, ENT_QUOTES, 'utf-8') : null);
          $smarty->assign('rows', $rows);
          $smarty->assign('pager', $pager->getPager());
          break;

        case 'categories':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Reports") . " &rsaquo; " . __("Categories"));

          // get data
          $rows = $user->get_categories("reports_categories");

          // assign variables
          $smarty->assign('rows', $rows);
          break;

        case 'edit_category':
          // valid inputs
          if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
            _error(404);
          }

          // get data
          $get_data = $db->query(sprintf("SELECT * FROM reports_categories WHERE category_id = %s", secure($_GET['id'], 'int')));
          if ($get_data->num_rows == 0) {
            _error(404);
          }
          $data = $get_data->fetch_assoc();
          /* get categories */
          $data['categories'] = $user->get_categories("reports_categories");

          // assign variables
          $smarty->assign('data', $data);

          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Reports") . " &rsaquo; " . __("Categories") . " &rsaquo; " . $data['category_name']);
          break;

        case 'add_category':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Reports") . " &rsaquo; " . __("Categories") . " &rsaquo; " . __("Add New Category"));

          // get data
          $categories = $user->get_categories("reports_categories");

          // assign variables
          $smarty->assign('categories', $categories);
          break;

        default:
          _error(404);
          break;
      }
      break;

    case 'blacklist':
      // check admin|moderator permission
      if ($user->_is_moderator && !$system['mods_blacklist_permission']) {
        _error(__('System Message'), __("You don't have the right permission to access this"));
      }

      // get nested view content
      switch ($_GET['sub_view']) {
        case '':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Blacklist"));

          // get insights
          $insights = [
            'total' => 0,
            'ip' => 0,
            'email' => 0,
            'username' => 0
          ];
          $get_insights = $db->query("SELECT node_type, COUNT(*) as count FROM blacklist GROUP BY node_type");
          while ($insight = $get_insights->fetch_assoc()) {
            $insights['total'] += $insight['count'];
            $insights[$insight['node_type']] = $insight['count'];
          }

          // get data
          $get_rows = $db->query("SELECT * FROM blacklist");
          if ($get_rows->num_rows > 0) {
            while ($row = $get_rows->fetch_assoc()) {
              $rows[] = $row;
            }
          }

          // assign variables
          $smarty->assign('insights', $insights);
          $smarty->assign('rows', $rows);
          break;

        case 'add':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Blacklist") . " &rsaquo; " . __("Add to Blacklist"));
          break;

        default:
          _error(404);
          break;
      }
      break;

    case 'verification':
      // check admin|moderator permission
      if ($user->_is_moderator && !$system['mods_verifications_permission']) {
        _error(__('System Message'), __("You don't have the right permission to access this"));
      }

      // get nested view content
      switch ($_GET['sub_view']) {
        case '':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Verification") . " &rsaquo; " . __("Requests"));

          // get insights
          $insights = [];
          $verification_from_query = " FROM verification_requests LEFT JOIN users ON verification_requests.node_type = 'user' AND verification_requests.node_id = users.user_id LEFT JOIN pages ON verification_requests.node_type = 'page' AND verification_requests.node_id = pages.page_id WHERE NOT (users.user_name <=> NULL AND pages.page_name <=> NULL) AND verification_requests.status = '0'";
          $get_requests = $db->query("SELECT COUNT(*) as count" . $verification_from_query);
          $insights['requests'] = $get_requests->fetch_assoc()['count'];
          $get_verified_users = $db->query("SELECT COUNT(*) as count FROM users WHERE user_verified = '1'");
          $insights['users'] = $get_verified_users->fetch_assoc()['count'];
          $get_verified_pages = $db->query("SELECT COUNT(*) as count FROM pages WHERE page_verified = '1'");
          $insights['pages'] = $get_verified_pages->fetch_assoc()['count'];

          // get data
          require('includes/class-pager.php');
          $params['selected_page'] = (!isset($_GET['page']) || (int) $_GET['page'] == 0) ? 1 : $_GET['page'];
          $params['total_items'] = $insights['requests'];
          $params['items_per_page'] = $system['max_results'];
          $params['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/verification?page=%s';
          $pager = new Pager($params);
          $limit_query = $pager->getLimitSql();
          $get_rows = paged_query("SELECT verification_requests.*, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, pages.page_name, pages.page_title, pages.page_picture" . $verification_from_query . " ORDER BY verification_requests.request_id DESC ", 'verification_requests.request_id', $limit_query);
          if ($get_rows->num_rows > 0) {
            while ($row = $get_rows->fetch_assoc()) {
              /* get node */
              if ($row['node_type'] == "user") {
                $row['user_picture'] = get_picture($row['user_picture'], $row['user_gender']);
              } elseif ($row['node_type'] == 'page') {
                $row['page_picture'] = get_picture($row['page_picture'], 'page');
              }
              $rows[] = $row;
            }
          }

          // assign variables
          $smarty->assign('insights', $insights);
          $smarty->assign('rows', $rows);
          $smarty->assign('pager', $pager->getPager());
          break;

        case 'users':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Verification") . " &rsaquo; " . __("Verified Users"));

          // get filters
          $query = (isset($_GET['query']) && !is_empty($_GET['query'])) ? $_GET['query'] : '';
          $where_query = "";
          $query_string = "";
          if (!is_empty($query)) {
            $where_query .= sprintf(" AND (user_name LIKE %s OR user_firstname LIKE %s OR user_lastname LIKE %s OR user_email LIKE %s)", secure($query, 'search'), secure($query, 'search'), secure($query, 'search'), secure($query, 'search'));
            $query_string .= "&query=" . urlencode($query);
          }

          // get data
          require('includes/class-pager.php');
          $params['selected_page'] = (!isset($_GET['page']) || (int) $_GET['page'] == 0) ? 1 : $_GET['page'];
          $total = $db->query("SELECT COUNT(*) as count FROM users WHERE user_verified = '1'" . $where_query);
          $params['total_items'] = $total->fetch_assoc()['count'];
          $params['items_per_page'] = $system['max_results'];
          $params['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/verification/users?page=%s' . $query_string;
          $pager = new Pager($params);
          $limit_query = $pager->getLimitSql();
          $get_rows = paged_query("SELECT * FROM users WHERE user_verified = '1'" . $where_query . " ORDER BY user_id ASC ", 'users.user_id', $limit_query);
          if ($get_rows->num_rows > 0) {
            while ($row = $get_rows->fetch_assoc()) {
              $row['user_picture'] = get_picture($row['user_picture'], $row['user_gender']);
              $rows[] = $row;
            }
          }

          // assign variables
          $smarty->assign('query', ($query) ? htmlentities($query, ENT_QUOTES, 'utf-8') : null);
          $smarty->assign('rows', $rows);
          $smarty->assign('pager', $pager->getPager());
          break;

        case 'pages':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Verification") . " &rsaquo; " . __("Verified Pages"));

          // get filters
          $query = (isset($_GET['query']) && !is_empty($_GET['query'])) ? $_GET['query'] : '';
          $where_query = "";
          $query_string = "";
          if (!is_empty($query)) {
            $where_query .= sprintf(" AND (page_title LIKE %s OR page_name LIKE %s)", secure($query, 'search'), secure($query, 'search'));
            $query_string .= "&query=" . urlencode($query);
          }

          // get data
          require('includes/class-pager.php');
          $params['selected_page'] = (!isset($_GET['page']) || (int) $_GET['page'] == 0) ? 1 : $_GET['page'];
          $total = $db->query("SELECT COUNT(*) as count FROM pages WHERE page_verified = '1'" . $where_query);
          $params['total_items'] = $total->fetch_assoc()['count'];
          $params['items_per_page'] = $system['max_results'];
          $params['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/verification/pages?page=%s' . $query_string;
          $pager = new Pager($params);
          $limit_query = $pager->getLimitSql();
          $get_rows = paged_query("SELECT * FROM pages WHERE page_verified = '1'" . $where_query . " ORDER BY page_id ASC ", 'pages.page_id', $limit_query);
          if ($get_rows->num_rows > 0) {
            while ($row = $get_rows->fetch_assoc()) {
              $row['page_picture'] = get_picture($row['page_picture'], 'page');
              $rows[] = $row;
            }
          }

          // assign variables
          $smarty->assign('query', ($query) ? htmlentities($query, ENT_QUOTES, 'utf-8') : null);
          $smarty->assign('rows', $rows);
          $smarty->assign('pager', $pager->getPager());
          break;

        default:
          _error(404);
          break;
      }
      break;

    case 'tools':
      // check admin|moderator permission
      if ($user->_is_moderator) {
        _error(__('System Message'), __("You don't have the right permission to access this"));
      }

      // get nested view content
      switch ($_GET['sub_view']) {
        case 'faker':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Tools") . " &rsaquo; " . __("Fake Generator"));

          // get countries if not defined
          if (!$countries) {
            $smarty->assign('countries', $user->get_countries());
          }

          // get pages categories
          $smarty->assign('pages_categories', $user->get_categories("pages_categories"));

          // get groups categories
          $smarty->assign('groups_categories', $user->get_categories("groups_categories"));
          break;

        case 'auto-connect':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Tools") . " &rsaquo; " . __("Auto Connect"));

          // get all custom auto-connect
          $get_rows = $db->query("SELECT * FROM auto_connect");
          if ($get_rows->num_rows > 0) {
            while ($row = $get_rows->fetch_assoc()) {
              $rows[$row['type']][] = $row;
            }
          }
          /* assign variables */
          $smarty->assign('rows', $rows);

          // get countries if not defined
          if (!$countries) {
            $smarty->assign('countries', $user->get_countries());
          }
          break;

        case 'garbage-collector':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Tools") . " &rsaquo; " . __("Garbage Collector"));

          // prepare counts
          /* users not activated */
          $get_users_not_activated = $db->query("SELECT COUNT(*) as count FROM users WHERE user_activated = '0'");
          $insights['users_not_activated'] = $get_users_not_activated->fetch_assoc()['count'];
          /* users not logged in 1 week */
          $get_users_not_logged_week = $db->query("SELECT COUNT(*) as count FROM users WHERE user_last_seen < NOW() - INTERVAL 1 WEEK");
          $insights['users_not_logged_week'] = $get_users_not_logged_week->fetch_assoc()['count'];
          /* users not logged in 1 month */
          $get_users_not_logged_month = $db->query("SELECT COUNT(*) as count FROM users WHERE user_last_seen < NOW() - INTERVAL 1 MONTH");
          $insights['users_not_logged_month'] = $get_users_not_logged_month->fetch_assoc()['count'];
          /* users not logged in 3 month3 */
          $get_users_not_logged_3_months = $db->query("SELECT COUNT(*) as count FROM users WHERE user_last_seen < NOW() - INTERVAL 3 MONTH");
          $insights['users_not_logged_3_months'] = $get_users_not_logged_3_months->fetch_assoc()['count'];
          /* users not logged in 1 month */
          $get_users_not_logged_6_months = $db->query("SELECT COUNT(*) as count FROM users WHERE user_last_seen < NOW() - INTERVAL 6 MONTH");
          $insights['users_not_logged_6_months'] = $get_users_not_logged_6_months->fetch_assoc()['count'];
          /* users not logged in 1 month */
          $get_users_not_logged_9_months = $db->query("SELECT COUNT(*) as count FROM users WHERE user_last_seen < NOW() - INTERVAL 9 MONTH");
          $insights['users_not_logged_9_months'] = $get_users_not_logged_9_months->fetch_assoc()['count'];
          /* users not logged in 1 year */
          $get_users_not_logged_year = $db->query("SELECT COUNT(*) as count FROM users WHERE user_last_seen < NOW() - INTERVAL 1 YEAR");
          $insights['users_not_logged_year'] = $get_users_not_logged_year->fetch_assoc()['count'];
          /* posts longer than 1 week */
          $get_posts_longer_week = $db->query("SELECT COUNT(*) as count FROM posts WHERE time < NOW() - INTERVAL 1 WEEK");
          $insights['posts_longer_week'] = $get_posts_longer_week->fetch_assoc()['count'];
          /* posts longer than 1 month */
          $get_posts_longer_month = $db->query("SELECT COUNT(*) as count FROM posts WHERE posts.time < NOW() - INTERVAL 1 MONTH");
          $insights['posts_longer_month'] = $get_posts_longer_month->fetch_assoc()['count'];
          /* posts longer than 1 year */
          $get_posts_longer_year = $db->query("SELECT COUNT(*) as count FROM posts WHERE posts.time < NOW() - INTERVAL 1 YEAR");
          $insights['posts_longer_year'] = $get_posts_longer_year->fetch_assoc()['count'];
          /* expired stories */
          $get_stories_expired = $db->query(sprintf("SELECT COUNT(*) as count FROM stories WHERE expires_at <= %s AND highlighted = '0'", secure($date)));
          $insights['stories_expired'] = $get_stories_expired->fetch_assoc()['count'];
          /* all expired stories */
          $get_stories_expired_all = $db->query(sprintf("SELECT COUNT(*) as count FROM stories WHERE expires_at <= %s", secure($date)));
          $insights['stories_expired_all'] = $get_stories_expired_all->fetch_assoc()['count'];
          /* get fake users */
          $get_fake_users = $db->query("SELECT COUNT(*) as count FROM users WHERE is_fake = '1'");
          $insights['fake_users'] = $get_fake_users->fetch_assoc()['count'];
          /* get fake pages */
          $get_fake_pages = $db->query("SELECT COUNT(*) as count FROM pages WHERE is_fake = '1'");
          $insights['fake_pages'] = $get_fake_pages->fetch_assoc()['count'];
          /* get fake groups */
          $get_fake_groups = $db->query("SELECT COUNT(*) as count FROM `groups` WHERE is_fake = '1'");
          $insights['fake_groups'] = $get_fake_groups->fetch_assoc()['count'];
          /* get undelivered shipped orders */
          $get_orders = $db->query(sprintf("SELECT COUNT(*) as count FROM orders WHERE `status` = 'shipped' AND update_time < NOW() - INTERVAL %s DAY", $system['market_delivery_days']));
          $insights['undelivered_orders'] = $get_orders->fetch_assoc()['count'];
          /* get pending uploads */
          $get_pending_uploads = $db->query("SELECT COUNT(*) as count FROM users_uploads_pending");
          $insights['pending_uploads'] = $get_pending_uploads->fetch_assoc()['count'];
          /* get pending uploads size */
          $get_pending_uploads_size = $db->query("SELECT SUM(file_size) as size FROM users_uploads_pending");
          $insights['pending_uploads_size'] = round($get_pending_uploads_size->fetch_assoc()['size'] / 1024 / 1024, 2);

          // assign variables
          $smarty->assign('insights', $insights);
          break;

        case 'search-index':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Tools") . " &rsaquo; " . __("Search Index"));

          // get search index status
          $get_cursor = $db->query("SELECT option_value FROM system_options WHERE option_name = 'posts_search_cursor'");
          $search_index['cursor'] = ($get_cursor->num_rows > 0) ? (int) $get_cursor->fetch_assoc()['option_value'] : 0;
          $get_last_post = $db->query("SELECT MAX(post_id) as last_post_id FROM posts");
          $search_index['last_post_id'] = (int) $get_last_post->fetch_assoc()['last_post_id'];
          $get_posts = $db->query("SELECT COUNT(*) as count FROM posts");
          $search_index['posts'] = (int) $get_posts->fetch_assoc()['count'];
          $get_indexed = $db->query("SELECT COUNT(*) as count FROM posts_search");
          $search_index['indexed'] = (int) $get_indexed->fetch_assoc()['count'];
          $get_size = $db->query("SELECT DATA_LENGTH + INDEX_LENGTH as size FROM information_schema.TABLES WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'posts_search'");
          $search_index['size'] = ($get_size && $get_size->num_rows > 0) ? (int) $get_size->fetch_assoc()['size'] : 0;
          if ($system['posts_search_ready']) {
            $search_index['progress'] = 100;
          } else {
            $search_index['progress'] = ($search_index['last_post_id'] > 0) ? min(100, (int) floor($search_index['cursor'] * 100 / $search_index['last_post_id'])) : 0;
          }
          /* assign variables */
          $smarty->assign('search_index', $search_index);
          break;

        case 'backups':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Tools") . " &rsaquo; " . __("Backup Database & Files"));

          // get backups
          $rows = $user->get_backups();
          $insights['total'] = count($rows);
          $insights['size'] = array_sum(array_column($rows, 'size'));
          /* assign variables */
          $smarty->assign('rows', $rows);
          $smarty->assign('insights', $insights);
          break;

        case 'cronjob':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Tools") . " &rsaquo; " . __("Cronjob Settings"));

          // check if $system cronjob hash is set
          if (empty($system['cronjob_hash'])) {
            $system['cronjob_hash'] = md5(uniqid());
            update_system_options([
              'cronjob_hash' => secure($system['cronjob_hash']),
            ]);
          }

          // get cronjob status
          if (!$system['cronjob_enabled']) {
            $cronjob_status = "disabled";
          } elseif (empty($system['cronjob_last_run'])) {
            $cronjob_status = "pending";
          } elseif (strtotime($system['cronjob_last_run']) < strtotime($date) - 172800) {
            $cronjob_status = "stopped";
          } else {
            $cronjob_status = "running";
          }
          /* assign variables */
          $smarty->assign('cronjob_status', $cronjob_status);
          break;

        case 'reset':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Tools") . " &rsaquo; " . __("Factory Reset"));
          break;

        default:
          _error(404);
          break;
      }
      break;

    case 'custom_fields':
      // check admin|moderator permission
      if ($user->_is_moderator && !$system['mods_customization_permission']) {
        _error(__('System Message'), __("You don't have the right permission to access this"));
      }

      // get nested view content
      switch ($_GET['sub_view']) {
        case '':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Custom Fields"));

          // get data
          $get_rows = $db->query("SELECT * FROM custom_fields");
          if ($get_rows->num_rows > 0) {
            while ($row = $get_rows->fetch_assoc()) {
              $rows[] = $row;
            }
          }

          // assign variables
          $smarty->assign('rows', $rows);
          break;

        case 'edit':
          // valid inputs
          if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
            _error(404);
          }

          // get data
          $get_data = $db->query(sprintf("SELECT * FROM custom_fields WHERE field_id = %s", secure($_GET['id'], 'int')));
          if ($get_data->num_rows == 0) {
            _error(404);
          }
          $data = $get_data->fetch_assoc();

          // assign variables
          $smarty->assign('data', $data);

          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Custom Fields") . " &rsaquo; " . $data['label']);
          break;

        case 'add':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Custom Fields") . " &rsaquo; " . __("Add New"));
          break;

        default:
          _error(404);
          break;
      }
      break;

    case 'static':
      // check admin|moderator permission
      if ($user->_is_moderator && !$system['mods_customization_permission']) {
        _error(__('System Message'), __("You don't have the right permission to access this"));
      }

      // get nested view content
      switch ($_GET['sub_view']) {
        case '':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Static Pages"));

          // get data
          $get_rows = $db->query("SELECT * FROM static_pages");
          if ($get_rows->num_rows > 0) {
            while ($row = $get_rows->fetch_assoc()) {
              $row['url'] = ($row['page_is_redirect']) ? $row['page_redirect_url'] : $system['system_url'] . '/static/' . $row['page_url'];
              $rows[] = $row;
            }
          }

          // assign variables
          $smarty->assign('rows', $rows);
          break;

        case 'edit':
          // valid inputs
          if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
            _error(404);
          }

          // get data
          $get_data = $db->query(sprintf("SELECT * FROM static_pages WHERE page_id = %s", secure($_GET['id'], 'int')));
          if ($get_data->num_rows == 0) {
            _error(404);
          }
          $data = $get_data->fetch_assoc();

          // assign variables
          $smarty->assign('data', $data);

          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Static Pages") . " &rsaquo; " . $data['page_title']);
          break;

        case 'add':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Static Pages") . " &rsaquo; " . __("Add New"));
          break;

        default:
          _error(404);
          break;
      }
      break;

    case 'colored_posts':
      // check admin|moderator permission
      if ($user->_is_moderator && !$system['mods_customization_permission']) {
        _error(__('System Message'), __("You don't have the right permission to access this"));
      }

      // get nested view content
      switch ($_GET['sub_view']) {
        case '':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Colored Posts"));

          // get data
          $rows = $user->get_posts_colored_patterns();

          // assign variables
          $smarty->assign('rows', $rows);
          break;

        case 'edit':
          // valid inputs
          if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
            _error(404);
          }

          // get data
          $get_data = $db->query(sprintf("SELECT * FROM posts_colored_patterns WHERE pattern_id = %s", secure($_GET['id'], 'int')));
          if ($get_data->num_rows == 0) {
            _error(404);
          }
          $data = $get_data->fetch_assoc();

          // assign variables
          $smarty->assign('data', $data);

          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Colored Posts") . " &rsaquo; " . $data['title']);
          break;

        case 'add':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Colored Posts") . " &rsaquo; " . __("Add New"));
          break;

        default:
          _error(404);
          break;
      }
      break;

    case 'widgets':
      // check admin|moderator permission
      if ($user->_is_moderator && !$system['mods_customization_permission']) {
        _error(__('System Message'), __("You don't have the right permission to access this"));
      }

      // get nested view content
      switch ($_GET['sub_view']) {
        case '':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Widgets"));

          // get data
          $get_rows = $db->query("SELECT widgets.*, system_languages.title AS language_title FROM widgets LEFT JOIN system_languages ON widgets.language_id = system_languages.language_id");
          if ($get_rows->num_rows > 0) {
            while ($row = $get_rows->fetch_assoc()) {
              $rows[] = $row;
            }
          }

          // assign variables
          $smarty->assign('rows', $rows);
          break;

        case 'edit':
          // valid inputs
          if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
            _error(404);
          }

          // get data
          $get_data = $db->query(sprintf("SELECT * FROM widgets WHERE widget_id = %s", secure($_GET['id'], 'int')));
          if ($get_data->num_rows == 0) {
            _error(404);
          }
          $data = $get_data->fetch_assoc();

          // assign variables
          $smarty->assign('data', $data);

          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Widgets") . " &rsaquo; " . $data['title']);
          break;

        case 'add':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Widgets") . " &rsaquo; " . __("Add New"));
          break;

        default:
          _error(404);
          break;
      }
      break;

    case 'reactions':
      // check admin|moderator permission
      if ($user->_is_moderator && !$system['mods_customization_permission']) {
        _error(__('System Message'), __("You don't have the right permission to access this"));
      }

      // get nested view content
      switch ($_GET['sub_view']) {
        case '':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Reactions"));

          // get data
          $rows = $system['reactions'];

          // assign variables
          $smarty->assign('rows', $rows);
          break;

        case 'edit':
          // valid inputs
          if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
            _error(404);
          }

          // get data
          $get_data = $db->query(sprintf("SELECT * FROM system_reactions WHERE reaction_id = %s", secure($_GET['id'], 'int')));
          if ($get_data->num_rows == 0) {
            _error(404);
          }
          $data = $get_data->fetch_assoc();

          // assign variables
          $smarty->assign('data', $data);

          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Reactions") . " &rsaquo; " . __("Edit Reaction"));
          break;

        default:
          _error(404);
          break;
      }
      break;

    case 'stickers':
      // check admin|moderator permission
      if ($user->_is_moderator && !$system['mods_customization_permission']) {
        _error(__('System Message'), __("You don't have the right permission to access this"));
      }

      // get nested view content
      switch ($_GET['sub_view']) {
        case '':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Stickers"));

          // get data
          $rows = $user->get_stickers();

          // assign variables
          $smarty->assign('rows', $rows);
          break;

        case 'edit':
          // valid inputs
          if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
            _error(404);
          }

          // get data
          $get_data = $db->query(sprintf("SELECT * FROM stickers WHERE sticker_id = %s", secure($_GET['id'], 'int')));
          if ($get_data->num_rows == 0) {
            _error(404);
          }
          $data = $get_data->fetch_assoc();

          // assign variables
          $smarty->assign('data', $data);

          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Stickers") . " &rsaquo; " . __("Edit Sticker"));
          break;

        case 'add':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Stickers") . " &rsaquo; " . __("Add New Sticker"));
          break;

        default:
          _error(404);
          break;
      }
      break;

    case 'gifts':
      // check admin|moderator permission
      if ($user->_is_moderator && !$system['mods_customization_permission']) {
        _error(__('System Message'), __("You don't have the right permission to access this"));
      }

      // get nested view content
      switch ($_GET['sub_view']) {
        case '':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Gifts"));

          // get data
          $rows = $user->get_gifts();

          // assign variables
          $smarty->assign('rows', $rows);
          break;

        case 'edit':
          // valid inputs
          if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
            _error(404);
          }

          // get data
          $get_data = $db->query(sprintf("SELECT * FROM gifts WHERE gift_id = %s", secure($_GET['id'], 'int')));
          if ($get_data->num_rows == 0) {
            _error(404);
          }
          $data = $get_data->fetch_assoc();

          // assign variables
          $smarty->assign('data', $data);

          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Gifts") . " &rsaquo; " . __("Edit Gift"));
          break;

        case 'add':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Gifts") . " &rsaquo; " . __("Add New Gift"));
          break;

        default:
          _error(404);
          break;
      }
      break;

    case 'announcements':
      // check admin|moderator permission
      if ($user->_is_moderator && !$system['mods_reach_permission']) {
        _error(__('System Message'), __("You don't have the right permission to access this"));
      }

      // get nested view content
      switch ($_GET['sub_view']) {
        case '':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Announcements"));

          // prepare insights
          $insights = [
            'total' => 0,
            'active' => 0,
            'scheduled' => 0,
            'expired' => 0
          ];
          $current_time = strtotime($date);

          // get data
          $get_rows = $db->query("SELECT * FROM announcements");
          if ($get_rows->num_rows > 0) {
            while ($row = $get_rows->fetch_assoc()) {
              $start_time = strtotime($row['start_date']);
              $end_time = strtotime($row['end_date']);
              if ($start_time > $current_time) {
                $row['status'] = 'scheduled';
              } elseif ($end_time < $current_time) {
                $row['status'] = 'expired';
              } else {
                $row['status'] = 'active';
              }
              $insights['total']++;
              $insights[$row['status']]++;
              $rows[] = $row;
            }
          }

          // assign variables
          $smarty->assign('insights', $insights);
          $smarty->assign('rows', $rows);
          break;

        case 'edit':
          // valid inputs
          if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
            _error(404);
          }

          // get data
          $get_data = $db->query(sprintf("SELECT * FROM announcements WHERE announcement_id = %s", secure($_GET['id'], 'int')));
          if ($get_data->num_rows == 0) {
            _error(404);
          }
          $data = $get_data->fetch_assoc();

          // assign variables
          $smarty->assign('data', $data);

          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Announcements") . " &rsaquo; " . $data['name']);
          break;

        case 'add':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Announcements") . " &rsaquo; " . __("Add New"));
          break;

        default:
          _error(404);
          break;
      }
      break;

    case 'notifications':
      // check admin|moderator permission
      if ($user->_is_moderator && !$system['mods_reach_permission']) {
        _error(__('System Message'), __("You don't have the right permission to access this"));
      }

      // page header
      page_header($control_panel['title'] . " &rsaquo; " . __("Mass Notifications"));
      break;

    case 'newsletter':
      // check admin|moderator permission
      if ($user->_is_moderator && !$system['mods_reach_permission']) {
        _error(__('System Message'), __("You don't have the right permission to access this"));
      }

      // page header
      page_header($control_panel['title'] . " &rsaquo; " . __("Newsletter"));

      // prepare counts
      /* all users */
      $get_users_all = $db->query("SELECT COUNT(*) as count FROM users WHERE user_activated = '1'");
      $insights['users_all'] = $get_users_all->fetch_assoc()['count'];
      /* users activated */
      $get_users_activated = $db->query("SELECT COUNT(*) as count FROM users WHERE user_activated = '1'");
      $insights['users_activated'] = $get_users_activated->fetch_assoc()['count'];
      /* users not activated */
      $get_users_not_activated = $db->query("SELECT COUNT(*) as count FROM users WHERE user_activated = '0'");
      $insights['users_not_activated'] = $get_users_not_activated->fetch_assoc()['count'];
      /* users not logged in from 1 week */
      $get_users_not_logged_week = $db->query("SELECT COUNT(*) as count FROM users WHERE user_last_seen < NOW() - INTERVAL 1 WEEK");
      $insights['users_not_logged_week'] = $get_users_not_logged_week->fetch_assoc()['count'];
      /* users not logged in from 1 month */
      $get_users_not_logged_month = $db->query("SELECT COUNT(*) as count FROM users WHERE user_last_seen < NOW() - INTERVAL 1 MONTH");
      $insights['users_not_logged_month'] = $get_users_not_logged_month->fetch_assoc()['count'];
      /* users not logged in from 3 month */
      $get_users_not_logged_3_months = $db->query("SELECT COUNT(*) as count FROM users WHERE user_last_seen < NOW() - INTERVAL 3 MONTH");
      $insights['users_not_logged_3_months'] = $get_users_not_logged_3_months->fetch_assoc()['count'];
      /* users not logged in from 6 month */
      $get_users_not_logged_6_months = $db->query("SELECT COUNT(*) as count FROM users WHERE user_last_seen < NOW() - INTERVAL 6 MONTH");
      $insights['users_not_logged_6_months'] = $get_users_not_logged_6_months->fetch_assoc()['count'];
      /* users not logged in from 9 month */
      $get_users_not_logged_9_months = $db->query("SELECT COUNT(*) as count FROM users WHERE user_last_seen < NOW() - INTERVAL 9 MONTH");
      $insights['users_not_logged_9_months'] = $get_users_not_logged_9_months->fetch_assoc()['count'];
      /* not logged in 1 year */
      $get_users_not_logged_year = $db->query("SELECT COUNT(*) as count FROM users WHERE user_last_seen < NOW() - INTERVAL 1 YEAR");
      $insights['users_not_logged_year'] = $get_users_not_logged_year->fetch_assoc()['count'];

      // assign variables
      $smarty->assign('insights', $insights);
      break;

    case 'merits':
      // check admin|moderator permission
      if ($user->_is_moderator) {
        _error(__('System Message'), __("You don't have the right permission to access this"));
      }

      // get nested view content
      switch ($_GET['sub_view']) {
        case '':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Merits"));

          // get data
          $cycle_dates = $user->get_merits_cycle_dates();

          // assign variables
          $smarty->assign('cycle_dates', $cycle_dates);
          break;

        case 'categories':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Merits") . " &rsaquo; " . __("Categories"));

          // get data
          $rows = $user->get_categories("merits_categories");

          // assign variables
          $smarty->assign('rows', $rows);
          break;

        case 'edit_category':
          // valid inputs
          if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
            _error(404);
          }

          // get data
          $get_data = $db->query(sprintf("SELECT * FROM merits_categories WHERE category_id = %s", secure($_GET['id'], 'int')));
          if ($get_data->num_rows == 0) {
            _error(404);
          }
          $data = $get_data->fetch_assoc();
          /* get categories */
          $data['categories'] = $user->get_categories("merits_categories");

          // assign variables
          $smarty->assign('data', $data);

          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Merits") . " &rsaquo; " . __("Categories") . " &rsaquo; " . $data['category_name']);
          break;

        case 'add_category':
          // page header
          page_header($control_panel['title'] . " &rsaquo; " . __("Merits") . " &rsaquo; " . __("Categories") . " &rsaquo; " . __("Add New Category"));

          // get data
          $categories = $user->get_categories("merits_categories");

          // assign variables
          $smarty->assign('categories', $categories);
          break;

        default:
          _error(404);
          break;
      }
      break;

    case 'sitemap':
      // check admin|moderator permission
      if ($user->_is_moderator) {
        _error(__('System Message'), __("You don't have the right permission to access this"));
      }

      // page header
      page_header($control_panel['title'] . " &rsaquo; " . __("Sitemap"));

      // get sitemap stats
      $sitemap_stats = $user->get_sitemap_stats();
      /* assign variables */
      $smarty->assign('sitemap_stats', $sitemap_stats);
      $smarty->assign('robots_file', is_file(ABSPATH . 'robots.txt'));
      $smarty->assign('llms_txt', $user->get_llms_txt());
      break;

    case 'pwa':
      // check admin|moderator permission
      if ($user->_is_moderator) {
        _error(__('System Message'), __("You don't have the right permission to access this"));
      }

      // page header
      page_header($control_panel['title'] . " &rsaquo; " . __("PWA"));
      break;

    case 'apis':
      // check admin|moderator permission
      if ($user->_is_moderator) {
        _error(__('System Message'), __("You don't have the right permission to access this"));
      }

      // page header
      page_header($control_panel['title'] . " &rsaquo; " . __("APIs"));
      break;

    case 'apps':
      // check admin|moderator permission
      if ($user->_is_moderator) {
        _error(__('System Message'), __("You don't have the right permission to access this"));
      }

      // page header
      page_header($control_panel['title'] . " &rsaquo; " . __("Apps"));
      break;

    case 'license':
      // check admin|moderator permission
      if ($user->_is_moderator) {
        _error(__('System Message'), __("You don't have the right permission to access this"));
      }

      // page header
      page_header($control_panel['title'] . " &rsaquo; " . __("License"));

      $licence_info = [
        'status' => 'missing',
        'message' => '',
        'api_warning' => '',
        'payload' => null,
        'key_masked' => licence_mask_key(defined('LICENCE_KEY') ? LICENCE_KEY : ''),
      ];

      $licence_file = ABSPATH . 'includes/sys_verif.php';
      if (!is_file($licence_file)) {
        $licence_info['status'] = 'missing';
        $licence_info['message'] = __("No license file found.");
      } else {
        $stored = include $licence_file;
        try {
          if (!is_array($stored)) {
            throw new Exception("License verification failed.");
          }
          licence_validate_payload($stored);
          $licence_info['payload'] = $stored;
          $licence_info['status'] = 'valid';
        } catch (Exception $e) {
          $licence_info['message'] = $e->getMessage();
          $licence_info['status'] = (strpos($e->getMessage(), 'expired') !== false) ? 'expired' : 'invalid';
        }
      }

      if (!$user->_data['user_demo'] && defined('LICENCE_KEY') && LICENCE_KEY !== '') {
        try {
          $fresh = get_licence_key(LICENCE_KEY, 'admin');
          licence_store_payload($fresh);
          $licence_info['payload'] = $fresh;
          $licence_info['status'] = 'valid';
          $licence_info['message'] = '';
        } catch (Exception $e) {
          $api_message = $e->getMessage();
          if (strpos($api_message, 'temporarily unavailable') !== false) {
            if ($licence_info['status'] == 'valid') {
              $licence_info['status'] = 'unreachable';
              $licence_info['api_warning'] = __("License server unreachable; showing last verified payload.");
            } else {
              $licence_info['api_warning'] = $api_message;
            }
          } else {
            $licence_info['status'] = (strpos($api_message, 'expired') !== false) ? 'expired' : 'invalid';
            $licence_info['message'] = $api_message;
          }
        }
      }

      if (is_array($licence_info['payload'])) {
        unset($licence_info['payload']['signature']);
      } else {
        $licence_info['payload'] = [];
      }

      // normalize the payload so the template never touches an undefined key
      $licence_info['payload'] = array_merge([
        'source' => '',
        'license_type' => '',
        'domain' => '',
        'issued_at' => '',
        'expires_at' => '',
        'support_expires_at' => '',
        'billing_cycle' => '',
        'entitlements' => [],
        'modules' => [],
      ], $licence_info['payload']);
      $licence_info['payload']['entitlements'] = array_merge(['monetization' => false], (array) $licence_info['payload']['entitlements']);
      foreach ($licence_info['payload']['modules'] as $_i => $_module) {
        $licence_info['payload']['modules'][$_i] = array_merge(['slug' => '', 'version' => '', 'available' => false], (array) $_module);
      }

      // days left before support & payload verification lapse
      $licence_info['support_timeleft'] = null;
      $licence_info['payload_timeleft'] = null;
      if (!empty($licence_info['payload']['support_expires_at'])) {
        $licence_info['support_timeleft'] = ceil((strtotime($licence_info['payload']['support_expires_at']) - time()) / (60 * 60 * 24));
      }
      if (!empty($licence_info['payload']['expires_at'])) {
        $licence_info['payload_timeleft'] = ceil((strtotime($licence_info['payload']['expires_at']) - time()) / (60 * 60 * 24));
      }

      $kind = strtolower(trim((string) $licence_info['payload']['license_type']));
      if (!in_array($kind, ['regular', 'extended', 'subscription'], true)) {
        $kind = 'regular';
      }
      $licence_info['kind'] = $kind;
      $licence_info['perpetual'] = ($kind !== 'subscription');
      $licence_info['support_ended'] = ($licence_info['support_timeleft'] !== null && $licence_info['support_timeleft'] <= 0);
      // newer licence servers sign support/updates inside entitlements; trust those over the unsigned date
      $signed = $licence_info['payload']['entitlements'];
      if (array_key_exists('support', $signed)) {
        $licence_info['support_ended'] = empty($signed['support']);
      }
      $licence_info['updates_ended'] = array_key_exists('updates', $signed) && empty($signed['updates']);
      $licence_info['monetization'] = !empty($licence_info['payload']['entitlements']['monetization']);
      $licence_info['module_installed'] = licence_module_installed();
      $licence_info['module_present'] = licence_module_present();

      $status = $licence_info['status'];
      if ($status == 'missing') {
        $ui = 'missing';
      } elseif ($status == 'invalid') {
        $ui = 'invalid';
      } elseif ($status == 'unreachable') {
        $ui = 'unreachable';
      } elseif ($kind == 'subscription' && ($licence_info['support_ended'] || $status == 'expired')) {
        $ui = 'lapsed';
      } elseif ($kind == 'subscription' && $licence_info['updates_ended'] && !$licence_info['monetization']) {
        $ui = 'cancelled';
      } elseif ($licence_info['perpetual'] && $licence_info['support_ended']) {
        $ui = 'support_ended';
      } else {
        $ui = 'active';
      }
      $licence_info['ui'] = $ui;

      $issued_ts = !empty($licence_info['payload']['issued_at']) ? strtotime($licence_info['payload']['issued_at']) : false;
      $support_ts = !empty($licence_info['payload']['support_expires_at']) ? strtotime($licence_info['payload']['support_expires_at']) : false;
      $timeline = [
        'mode' => 'none',
        'today_pct' => 0,
        'today_at_end' => false,
      ];
      if ($issued_ts && $support_ts && !in_array($ui, ['missing', 'invalid'], true)) {
        $timeline['mode'] = $licence_info['perpetual'] ? 'perpetual' : 'term';
        $span = $support_ts - $issued_ts;
        if ($span <= 0 || $licence_info['support_ended'] || time() >= $support_ts) {
          $timeline['today_pct'] = 100;
          $timeline['today_at_end'] = true;
        } else {
          $timeline['today_pct'] = (int) round(((time() - $issued_ts) / $span) * 100);
          $timeline['today_pct'] = max(0, min(100, $timeline['today_pct']));
          $timeline['today_at_end'] = ($timeline['today_pct'] >= 100);
        }
      }
      $licence_info['timeline'] = $timeline;
      $licence_info['rel_support'] = licence_relative_days($licence_info['support_timeleft']);
      $licence_info['rel_verify'] = licence_relative_days($licence_info['payload_timeleft']);
      $licence_info['billing'] = ($kind == 'subscription') ? licence_billing_cycle($licence_info['payload']) : null;

      $smarty->assign('licence_info', $licence_info);
      break;

    default:
      // check admin|moderator permission
      if (!$user->_is_admin || !$user->_is_moderator) {
        _error(__('System Message'), __("You don't have the right permission to access this"));
      }
      _error(404);
  }
  /* assign variables */
  $smarty->assign('view', $_GET['view']);
  $smarty->assign('sub_view', $_GET['sub_view']);
  $smarty->assign('control_panel', $control_panel);
  $smarty->assign('licence_lock', licence_admin_lock());

  // global insights
  if ($user->_is_admin) {
    if ($licence_monetization && licence_module_installed()) {
      admin_monetization_insights();
    }
    /* affiliates payments insights */
    $get_affiliates_payments = $db->query("SELECT COUNT(*) as count FROM affiliates_payments INNER JOIN users ON affiliates_payments.user_id = users.user_id WHERE affiliates_payments.status = '0'");
    $affiliates_payments_insights = $get_affiliates_payments->fetch_assoc()['count'];
    $smarty->assign('affiliates_payments_insights', $affiliates_payments_insights);
    /* points payments insights */
    $get_points_payments = $db->query("SELECT COUNT(*) as count FROM points_payments INNER JOIN users ON points_payments.user_id = users.user_id WHERE points_payments.status = '0'");
    $points_payments_insights = $get_points_payments->fetch_assoc()['count'];
    $smarty->assign('points_payments_insights', $points_payments_insights);
    /* marketplace payments insights */
    $get_marketplace_payments = $db->query("SELECT COUNT(*) as count FROM market_payments INNER JOIN users ON market_payments.user_id = users.user_id WHERE market_payments.status = '0'");
    $marketplace_payments_insights = $get_marketplace_payments->fetch_assoc()['count'];
    $smarty->assign('marketplace_payments_insights', $marketplace_payments_insights);
  }
  /* reports insights */
  $get_reports = $db->query("SELECT COUNT(*) as count FROM reports INNER JOIN users ON reports.user_id = users.user_id");
  $reports_insights = $get_reports->fetch_assoc()['count'];
  $smarty->assign('reports_insights', $reports_insights);
  /* verification requests insights */
  $get_verification_requests = $db->query("SELECT COUNT(*) as count FROM verification_requests LEFT JOIN users ON verification_requests.node_type = 'user' AND verification_requests.node_id = users.user_id LEFT JOIN pages ON verification_requests.node_type = 'page' AND verification_requests.node_id = pages.page_id WHERE NOT (users.user_name <=> NULL AND pages.page_name <=> NULL) AND verification_requests.status = '0'");
  $verification_requests_insights = $get_verification_requests->fetch_assoc()['count'];
  $smarty->assign('verification_requests_insights', $verification_requests_insights);
} catch (Exception $e) {
  _error(__("Error"), $e->getMessage());
}

// page footer
page_footer('admin');
