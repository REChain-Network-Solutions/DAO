<?php
/**
 * admin
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich
 */

// set override_shutdown
$override_shutdown = true;

// fetch bootstrap
require('bootstrap.php');

// user access
user_access();

// check admin logged in
if(!$user->_is_admin) {
    _error(__('System Message'), __("You don't have the right permission to access this"));
}

try {

	// check view
	switch ($_GET['view']) {
		case '':
			// page header
			page_header(__("Admin Panel"));

			// update view
			$_GET['view'] = 'dashboard';

			// get insights
			/* total users */
			$get_users = $db->query("SELECT * FROM users") or _error(SQL_ERROR);
	    	$insights['users'] = $get_users->num_rows;
	    	/* males|females|others */
	    	$get_males = $db->query("SELECT * FROM users WHERE user_gender = 'male'");
		    $insights['users_males'] = $get_males->num_rows;
		    $get_females = $db->query("SELECT * FROM users WHERE user_gender = 'female'");
		    $insights['users_females'] = $get_females->num_rows;
		    $get_others = $db->query("SELECT * FROM users WHERE user_gender = 'other'");
		    $insights['users_others'] = $get_others->num_rows;
		    $insights['users_males_percent'] = round(($insights['users_males']/$insights['users'])*100, 2);
		    $insights['users_females_percent'] = round(($insights['users_females']/$insights['users'])*100, 2);
		    $insights['users_others_percent'] = round(($insights['users_others']/$insights['users'])*100, 2);
		    /* banned */
		    $get_banned = $db->query("SELECT * FROM users WHERE user_banned = '1'") or _error(SQL_ERROR);
	    	$insights['banned'] = $get_banned->num_rows;
		    /* not activated */
		    $get_not_activated = $db->query("SELECT * FROM users WHERE user_activated = '0'") or _error(SQL_ERROR);
	    	$insights['not_activated'] = $get_not_activated->num_rows;
	    	/* online */
		    $get_online = $db->query(sprintf("SELECT * FROM users WHERE user_last_seen >= SUBTIME(NOW(), SEC_TO_TIME(%s))", secure($system['offline_time'], 'int', false) )) or _error(SQL_ERROR);
	    	$insights['online'] = $get_online->num_rows;
	    	/* posts */
		    $get_posts = $db->query("SELECT * FROM posts") or _error(SQL_ERROR);
	    	$insights['posts'] = $get_posts->num_rows;
	    	/* comments */
		    $get_comments = $db->query("SELECT * FROM posts_comments") or _error(SQL_ERROR);
	    	$insights['comments'] = $get_comments->num_rows;
	    	/* pages */
		    $get_pages = $db->query("SELECT * FROM pages") or _error(SQL_ERROR);
	    	$insights['pages'] = $get_pages->num_rows;
	    	/* groups */
		    $get_groups = $db->query("SELECT * FROM groups") or _error(SQL_ERROR);
	    	$insights['groups'] = $get_groups->num_rows;
	    	/* events */
		    $get_events = $db->query("SELECT * FROM events") or _error(SQL_ERROR);
	    	$insights['events'] = $get_events->num_rows;
	    	/* messages */
		    $get_messages = $db->query("SELECT * FROM conversations_messages") or _error(SQL_ERROR);
	    	$insights['messages'] = $get_messages->num_rows;
	    	/* notifications */
		    $get_notifications = $db->query("SELECT * FROM notifications") or _error(SQL_ERROR);
	    	$insights['notifications'] = $get_notifications->num_rows;

	    	// get chart data
			for($i=1; $i <= 12; $i++) {
				/* get users */
				$get_monthly_users = $db->query("SELECT * FROM users WHERE YEAR(user_registered) = YEAR(CURRENT_DATE()) AND MONTH(user_registered) = $i");
				$chart['users'][$i] = $get_monthly_users->num_rows;
				/* get pages */
				$get_monthly_pages = $db->query("SELECT * FROM pages WHERE YEAR(page_date) = YEAR(CURRENT_DATE()) AND MONTH(page_date) = $i");
				$chart['pages'][$i] = $get_monthly_pages->num_rows;
				/* get groups */
				$get_monthly_groups = $db->query("SELECT * FROM groups WHERE YEAR(group_date) = YEAR(CURRENT_DATE()) AND MONTH(group_date) = $i");
				$chart['groups'][$i] = $get_monthly_groups->num_rows;
				/* get events */
				$get_monthly_events = $db->query("SELECT * FROM events WHERE YEAR(event_date) = YEAR(CURRENT_DATE()) AND MONTH(event_date) = $i");
				$chart['events'][$i] = $get_monthly_events->num_rows;
				/* get posts */
				$get_monthly_posts = $db->query("SELECT * FROM posts WHERE YEAR(time) = YEAR(CURRENT_DATE()) AND MONTH(time) = $i");
				$chart['posts'][$i] = $get_monthly_posts->num_rows;
			}

	    	// assign variables
			$smarty->assign('insights', $insights);
			$smarty->assign('chart', $chart);
			break;

		case 'settings':
			// get content
			switch ($_GET['sub_view']) {
				case '':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("System Settings"));
					break;

				case 'posts':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Posts Settings"));
					break;

				case 'registration':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Registration Settings"));

					// get data
					$get_rows = $db->query("SELECT * FROM invitation_codes") or _error(SQL_ERROR);
					if($get_rows->num_rows > 0) {
						while($row = $get_rows->fetch_assoc()) {
							$rows[] = $row;
						}
					}

					// assign variables
					$smarty->assign('rows', $rows);
					break;

				case 'emails':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Emails Settings"));
					break;

				case 'sms':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("SMS Settings"));
					break;

				case 'chat':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Chat Settings"));
					break;

				case 'uploads':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Uploads Settings"));

					// get PHP upload_max_filesize
					$max_upload_size = ini_get("upload_max_filesize");
					/* assign variables */
					$smarty->assign('max_upload_size', $max_upload_size);
					break;

				case 'security':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Security Settings"));
					break;

				case 'payments':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Payments Settings"));
					break;

				case 'limits':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Limits Settings"));
					break;

				case 'analytics':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Analytics Settings"));
					break;
				
				default:
					_error(404);
					break;
			}
			break;

		case 'themes':
			// get content
			switch ($_GET['sub_view']) {
				case '':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Themes"));

					// get data
					$get_rows = $db->query("SELECT * FROM system_themes") or _error(SQL_ERROR);
					if($get_rows->num_rows > 0) {
						while($row = $get_rows->fetch_assoc()) {
							$rows[] = $row;
						}
					}
					
					// assign variables
					$smarty->assign('rows', $rows);
					break;

				case 'edit':
					// valid inputs
					if(!isset($_GET['id']) || !is_numeric($_GET['id'])) {
						_error(404);
					}
					
					// get data
					$get_data = $db->query(sprintf("SELECT * FROM system_themes WHERE theme_id = %s", secure($_GET['id'], 'int') )) or _error(SQL_ERROR);
					if($get_data->num_rows == 0) {
						_error(404);
					}
					$data = $get_data->fetch_assoc();
					
					// assign variables
					$smarty->assign('data', $data);
					
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Themes")." &rsaquo; ".$data['name']);
					break;

				case 'add':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Themes")." &rsaquo; ".__("Add New"));
					break;
				
				default:
					_error(404);
					break;
			}
			break;

		case 'design':
			// page header
			page_header(__("Admin")." &rsaquo; ".__("Design"));
			break;

		case 'languages':
			// get content
			switch ($_GET['sub_view']) {
				case '':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Languages"));

					// get data
					$get_rows = $db->query("SELECT * FROM system_languages") or _error(SQL_ERROR);
					if($get_rows->num_rows > 0) {
						while($row = $get_rows->fetch_assoc()) {
							$row['flag'] = get_picture($row['flag'], 'flag');
							$rows[] = $row;
						}
					}
					
					// assign variables
					$smarty->assign('rows', $rows);
					break;

				case 'edit':
					// valid inputs
					if(!isset($_GET['id']) || !is_numeric($_GET['id'])) {
						_error(404);
					}
					
					// get data
					$get_data = $db->query(sprintf("SELECT * FROM system_languages WHERE language_id = %s", secure($_GET['id'], 'int') )) or _error(SQL_ERROR);
					if($get_data->num_rows == 0) {
						_error(404);
					}
					$data = $get_data->fetch_assoc();
					
					// assign variables
					$smarty->assign('data', $data);
					
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Languages")." &rsaquo; ".$data['title']);
					break;

				case 'add':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Languages")." &rsaquo; ".__("Add New"));
					break;
				
				default:
					_error(404);
					break;
			}
			break;

		case 'users':
			// get content
			switch ($_GET['sub_view']) {
				case '':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Users"));
					
					// get data
					require('includes/class-pager.php');
					$params['selected_page'] = ( (int) $_GET['page'] == 0) ? 1 : $_GET['page'];
					$total = $db->query("SELECT * FROM users") or _error(SQL_ERROR);
					$params['total_items'] = $total->num_rows;
					$params['items_per_page'] = $system['max_results'];
					$params['url'] = $system['system_url'].'/admincp/users?page=%s';
					$pager = new Pager($params);
					$limit_query = $pager->getLimitSql();
					$get_rows = $db->query("SELECT * FROM users ".$limit_query) or _error(SQL_ERROR);
					if($get_rows->num_rows > 0) {
						while($row = $get_rows->fetch_assoc()) {
							$row['user_picture'] = get_picture($row['user_picture'], $row['user_gender']);
							$rows[] = $row;
						}
					}
					
					// assign variables
					$smarty->assign('rows', $rows);
					$smarty->assign('pager', $pager->getPager());
					break;

				case 'admins':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Users")." &rsaquo; ".__("Admins"));
					
					// get data
					require('includes/class-pager.php');
					$params['selected_page'] = ( (int) $_GET['page'] == 0) ? 1 : $_GET['page'];
					$total = $db->query("SELECT * FROM users WHERE user_group = '1'") or _error(SQL_ERROR);
					$params['total_items'] = $total->num_rows;
					$params['items_per_page'] = $system['max_results'];
					$params['url'] = $system['system_url'].'/admincp/users/admins?page=%s';
					$pager = new Pager($params);
					$limit_query = $pager->getLimitSql();
					$get_rows = $db->query("SELECT * FROM users WHERE user_group = '1' ".$limit_query) or _error(SQL_ERROR);
					if($get_rows->num_rows > 0) {
						while($row = $get_rows->fetch_assoc()) {
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
					page_header(__("Admin")." &rsaquo; ".__("Users")." &rsaquo; ".__("Moderators"));
					
					// get data
					require('includes/class-pager.php');
					$params['selected_page'] = ( (int) $_GET['page'] == 0) ? 1 : $_GET['page'];
					$total = $db->query("SELECT * FROM users WHERE user_group = '2'") or _error(SQL_ERROR);
					$params['total_items'] = $total->num_rows;
					$params['items_per_page'] = $system['max_results'];
					$params['url'] = $system['system_url'].'/admincp/users/moderators?page=%s';
					$pager = new Pager($params);
					$limit_query = $pager->getLimitSql();
					$get_rows = $db->query("SELECT * FROM users WHERE user_group = '2' ".$limit_query) or _error(SQL_ERROR);
					if($get_rows->num_rows > 0) {
						while($row = $get_rows->fetch_assoc()) {
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
					page_header(__("Admin")." &rsaquo; ".__("Users")." &rsaquo; ".__("Online"));
					
					// get data
					require('includes/class-pager.php');
					$params['selected_page'] = ( (int) $_GET['page'] == 0) ? 1 : $_GET['page'];
					$total = $db->query(sprintf("SELECT * FROM users WHERE user_last_seen >= SUBTIME(NOW(), SEC_TO_TIME(%s))", secure($system['offline_time'], 'int', false) )) or _error(SQL_ERROR);
					$params['total_items'] = $total->num_rows;
					$params['items_per_page'] = $system['max_results'];
					$params['url'] = $system['system_url'].'/admincp/users/online?page=%s';
					$pager = new Pager($params);
					$limit_query = $pager->getLimitSql();
					$get_rows = $db->query(sprintf("SELECT * FROM users WHERE user_last_seen >= SUBTIME(NOW(), SEC_TO_TIME(%s)) ".$limit_query, secure($system['offline_time'], 'int', false) )) or _error(SQL_ERROR);
					if($get_rows->num_rows > 0) {
						while($row = $get_rows->fetch_assoc()) {
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
					page_header(__("Admin")." &rsaquo; ".__("Users")." &rsaquo; ".__("Banned"));
					
					// get data
					require('includes/class-pager.php');
					$params['selected_page'] = ( (int) $_GET['page'] == 0) ? 1 : $_GET['page'];
					$total = $db->query("SELECT * FROM users WHERE user_banned = '1'") or _error(SQL_ERROR);
					$params['total_items'] = $total->num_rows;
					$params['items_per_page'] = $system['max_results'];
					$params['url'] = $system['system_url'].'/admincp/users/banned?page=%s';
					$pager = new Pager($params);
					$limit_query = $pager->getLimitSql();
					$get_rows = $db->query("SELECT * FROM users WHERE user_banned = '1' ".$limit_query) or _error(SQL_ERROR);
					if($get_rows->num_rows > 0) {
						while($row = $get_rows->fetch_assoc()) {
							$row['user_picture'] = get_picture($row['user_picture'], $row['user_gender']);
							$rows[] = $row;
						}
					}
					
					// assign variables
					$smarty->assign('rows', $rows);
					$smarty->assign('pager', $pager->getPager());
					break;

				case 'find':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Users"));
					
					// get data
					require('includes/class-pager.php');
					$params['selected_page'] = ( (int) $_GET['page'] == 0) ? 1 : $_GET['page'];
					$total = $db->query(sprintf('SELECT * FROM users WHERE (user_name LIKE %1$s OR user_firstname LIKE %1$s OR user_lastname LIKE %1$s OR CONCAT(user_firstname,  " ", user_lastname) LIKE %1$s OR user_email LIKE %1$s OR user_phone LIKE %1$s) ORDER BY user_firstname ASC', secure($_GET['query'], 'search') )) or _error(SQL_ERROR);
					$params['total_items'] = $total->num_rows;
					$params['items_per_page'] = $system['max_results'];
					$params['url'] = $system['system_url'].'/admincp/users/find?query='.$_GET['query'].'&page=%s';
					$pager = new Pager($params);
					$limit_query = $pager->getLimitSql();
					$get_rows = $db->query(sprintf('SELECT * FROM users WHERE (user_name LIKE %1$s OR user_firstname LIKE %1$s OR user_lastname LIKE %1$s OR CONCAT(user_firstname,  " ", user_lastname) LIKE %1$s OR user_email LIKE %1$s OR user_phone LIKE %1$s) ORDER BY user_firstname ASC '.$limit_query, secure($_GET['query'], 'search') )) or _error(SQL_ERROR);
					if($get_rows->num_rows > 0) {
						while($row = $get_rows->fetch_assoc()) {
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
					if(!isset($_GET['id']) || !is_numeric($_GET['id'])) {
						_error(404);
					}
					
					// get data
					$get_data = $db->query(sprintf("SELECT * FROM users LEFT JOIN packages ON users.user_subscribed = '1' AND users.user_package = packages.package_id WHERE users.user_id = %s ", secure($_GET['id'], 'int') )) or _error(SQL_ERROR);
					if($get_data->num_rows == 0) {
						_error(404);
					}
					$data = $get_data->fetch_assoc();
					$data['user_picture'] = get_picture($data['user_picture'], $data['user_gender']);
					/* get user's friends */
					$data['friends'] = count($user->get_friends_ids($data['user_id']));
					$data['followings'] = count($user->get_followings_ids($data['user_id']));
					$data['followers'] = count($user->get_followers_ids($data['user_id']));
					/* parse birthdate */
					$data['user_birthdate_parsed'] = date_parse($data['user_birthdate']);
					/* get user sessions */
					$get_sessions = $db->query(sprintf("SELECT * FROM users_sessions WHERE user_id = %s", secure($_GET['id'], 'int') )) or _error(SQL_ERROR);
					if($get_sessions->num_rows > 0) {
			            while($session = $get_sessions->fetch_assoc()) {
			            	$data['sessions'][] = $session;
			            }
			        }
			        /* prepare packages */
			        if($system['packages_enabled']) {
						/* prepare user package */
						if($data['user_subscribed']) {
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
						$packages = $user->get_packages();
						$smarty->assign('packages', $packages);
			        }
			        /* get custom fields */
					$smarty->assign('custom_fields', $user->get_custom_fields( array("for" => "user", "get" => "settings", "node_id" => $_GET['id']) ));

			        // get countries
					$countries = $user->get_countries();
					/* assign variables */
					$smarty->assign('countries', $countries);
					
					// assign variables
					$smarty->assign('data', $data);
					
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Users")." &rsaquo; ".$data['user_firstname']." ".$data['user_lastname']);
					break;

				default:
					_error(404);
					break;
			}
			break;

		case 'pages':
			// get content
			switch ($_GET['sub_view']) {
				case '':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Pages"));
					
					// get data
					$get_rows = $db->query("SELECT pages.*, users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM pages INNER JOIN users ON pages.page_admin = users.user_id") or _error(SQL_ERROR);
					if($get_rows->num_rows > 0) {
						while($row = $get_rows->fetch_assoc()) {
							$row['page_picture'] = get_picture($row['page_picture'], 'page');
							$row['user_picture'] = get_picture($row['user_picture'], $row['user_gender']);
							$rows[] = $row;
						}
					}
					
					// assign variables
					$smarty->assign('rows', $rows);
					break;

				case 'edit_page':
					// valid inputs
					if(!isset($_GET['id']) || !is_numeric($_GET['id'])) {
						_error(404);
					}
					
					// get data
					$get_data = $db->query(sprintf("SELECT pages.*, users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM pages INNER JOIN users ON pages.page_admin = users.user_id WHERE pages.page_id = %s", secure($_GET['id'], 'int') )) or _error(SQL_ERROR);
					if($get_data->num_rows == 0) {
						_error(404);
					}
					$data = $get_data->fetch_assoc();
					$data['page_picture'] = get_picture($data['page_picture'], 'page');
					$data['user_picture'] = get_picture($data['user_picture'], $data['user_gender']);
					/* get categories */
					$data['categories'] = $user->get_pages_categories();
					/* get custom fields */
					$smarty->assign('custom_fields', $user->get_custom_fields( array("for" => "page", "get" => "settings", "node_id" => $_GET['id']) ));
					
					// assign variables
					$smarty->assign('data', $data);
					
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Pages")." &rsaquo; ".$data['page_title']);
					break;

				case 'categories':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Pages")." &rsaquo; ".__("Categories"));
					
					// get data
					$rows = $user->get_pages_categories();
					
					// assign variables
					$smarty->assign('rows', $rows);
					break;

				case 'edit_category':
					// valid inputs
					if(!isset($_GET['id']) || !is_numeric($_GET['id'])) {
						_error(404);
					}
					
					// get data
					$get_data = $db->query(sprintf("SELECT * FROM pages_categories WHERE category_id = %s", secure($_GET['id'], 'int') )) or _error(SQL_ERROR);
					if($get_data->num_rows == 0) {
						_error(404);
					}
					$data = $get_data->fetch_assoc();
					
					// assign variables
					$smarty->assign('data', $data);
					
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Pages")." &rsaquo; ".__("Categories")." &rsaquo; ".$data['category_name']);
					break;

				case 'add_category':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Pages")." &rsaquo; ".__("Categories")." &rsaquo; ".__("Add New Category"));
					break;

				default:
					_error(404);
					break;
			}
			break;

		case 'groups':
			// get content
			switch ($_GET['sub_view']) {
				case '':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Groups"));
					
					// get data
					$get_rows = $db->query("SELECT groups.*, users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM groups INNER JOIN users ON groups.group_admin = users.user_id") or _error(SQL_ERROR);
					if($get_rows->num_rows > 0) {
						while($row = $get_rows->fetch_assoc()) {
							$row['group_picture'] = get_picture($row['group_picture'], 'group');
							$row['user_picture'] = get_picture($row['user_picture'], $row['user_gender']);
							$rows[] = $row;
						}
					}
					
					// assign variables
					$smarty->assign('rows', $rows);
					break;

				case 'edit_group':
					// valid inputs
					if(!isset($_GET['id']) || !is_numeric($_GET['id'])) {
						_error(404);
					}
					
					// get data
					$get_data = $db->query(sprintf("SELECT groups.*, users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM groups INNER JOIN users ON groups.group_admin = users.user_id WHERE groups.group_id = %s", secure($_GET['id'], 'int') )) or _error(SQL_ERROR);
					if($get_data->num_rows == 0) {
						_error(404);
					}
					$data = $get_data->fetch_assoc();
					$data['group_picture'] = get_picture($data['group_picture'], 'group');
					$data['user_picture'] = get_picture($data['user_picture'], $data['user_gender']);
					/* get categories */
					$data['categories'] = $user->get_groups_categories();
					/* get custom fields */
					$smarty->assign('custom_fields', $user->get_custom_fields( array("for" => "group", "get" => "settings", "node_id" => $_GET['id']) ));
					
					// assign variables
					$smarty->assign('data', $data);
					
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Groups")." &rsaquo; ".$data['group_title']);
					break;

				case 'categories':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Groups")." &rsaquo; ".__("Categories"));
					
					// get data
					$rows = $user->get_groups_categories();
					
					// assign variables
					$smarty->assign('rows', $rows);
					break;

				case 'edit_category':
					// valid inputs
					if(!isset($_GET['id']) || !is_numeric($_GET['id'])) {
						_error(404);
					}
					
					// get data
					$get_data = $db->query(sprintf("SELECT * FROM groups_categories WHERE category_id = %s", secure($_GET['id'], 'int') )) or _error(SQL_ERROR);
					if($get_data->num_rows == 0) {
						_error(404);
					}
					$data = $get_data->fetch_assoc();
					
					// assign variables
					$smarty->assign('data', $data);
					
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Groups")." &rsaquo; ".__("Categories")." &rsaquo; ".$data['category_name']);
					break;

				case 'add_category':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Groups")." &rsaquo; ".__("Categories")." &rsaquo; ".__("Add New Category"));
					break;

				default:
					_error(404);
					break;
			}
			break;

		case 'events':
			// get content
			switch ($_GET['sub_view']) {
				case '':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Events"));
					
					// get data
					$get_rows = $db->query("SELECT events.*, users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM events INNER JOIN users ON events.event_admin = users.user_id") or _error(SQL_ERROR);
					if($get_rows->num_rows > 0) {
						while($row = $get_rows->fetch_assoc()) {
							$row['user_picture'] = get_picture($row['user_picture'], $row['user_gender']);
							$rows[] = $row;
						}
					}
					
					// assign variables
					$smarty->assign('rows', $rows);
					break;

				case 'edit_event':
					// valid inputs
					if(!isset($_GET['id']) || !is_numeric($_GET['id'])) {
						_error(404);
					}
					
					// get data
					$get_data = $db->query(sprintf("SELECT events.*, users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM events INNER JOIN users ON events.event_admin = users.user_id WHERE events.event_id = %s", secure($_GET['id'], 'int') )) or _error(SQL_ERROR);
					if($get_data->num_rows == 0) {
						_error(404);
					}
					$data = $get_data->fetch_assoc();
					$data['event_picture'] = get_picture($data['event_cover'], 'event');
					$data['user_picture'] = get_picture($data['user_picture'], $data['user_gender']);
					/* get categories */
					$data['categories'] = $user->get_events_categories();
					/* get custom fields */
					$smarty->assign('custom_fields', $user->get_custom_fields( array("for" => "event", "get" => "settings", "node_id" => $_GET['id']) ));
					
					// assign variables
					$smarty->assign('data', $data);
					
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Events")." &rsaquo; ".$data['event_title']);
					break;

				case 'categories':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Events")." &rsaquo; ".__("Categories"));
					
					// get data
					$rows = $user->get_events_categories();
					
					// assign variables
					$smarty->assign('rows', $rows);
					break;

				case 'edit_category':
					// valid inputs
					if(!isset($_GET['id']) || !is_numeric($_GET['id'])) {
						_error(404);
					}
					
					// get data
					$get_data = $db->query(sprintf("SELECT * FROM events_categories WHERE category_id = %s", secure($_GET['id'], 'int') )) or _error(SQL_ERROR);
					if($get_data->num_rows == 0) {
						_error(404);
					}
					$data = $get_data->fetch_assoc();
					
					// assign variables
					$smarty->assign('data', $data);
					
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Events")." &rsaquo; ".__("Categories")." &rsaquo; ".$data['category_name']);
					break;

				case 'add_category':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Events")." &rsaquo; ".__("Categories")." &rsaquo; ".__("Add New Category"));
					break;

				default:
					_error(404);
					break;
			}
			break;

		case 'blogs':
			// get content
			switch ($_GET['sub_view']) {
				case 'categories':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Blogs")." &rsaquo; ".__("Categories"));
					
					// get data
					$rows = $user->get_blogs_categories();
					
					// assign variables
					$smarty->assign('rows', $rows);
					break;

				case 'edit_category':
					// valid inputs
					if(!isset($_GET['id']) || !is_numeric($_GET['id'])) {
						_error(404);
					}
					
					// get data
					$get_data = $db->query(sprintf("SELECT * FROM blogs_categories WHERE category_id = %s", secure($_GET['id'], 'int') )) or _error(SQL_ERROR);
					if($get_data->num_rows == 0) {
						_error(404);
					}
					$data = $get_data->fetch_assoc();
					
					// assign variables
					$smarty->assign('data', $data);
					
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Blogs")." &rsaquo; ".__("Categories")." &rsaquo; ".$data['category_name']);
					break;

				case 'add_category':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Blogs")." &rsaquo; ".__("Categories")." &rsaquo; ".__("Add New Category"));
					break;

				default:
					_error(404);
					break;
			}
			break;

		case 'market':
			// get content
			switch ($_GET['sub_view']) {
				case 'categories':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Market")." &rsaquo; ".__("Categories"));
					
					// get data
					$rows = $user->get_market_categories();
					
					// assign variables
					$smarty->assign('rows', $rows);
					break;

				case 'edit_category':
					// valid inputs
					if(!isset($_GET['id']) || !is_numeric($_GET['id'])) {
						_error(404);
					}
					
					// get data
					$get_data = $db->query(sprintf("SELECT * FROM market_categories WHERE category_id = %s", secure($_GET['id'], 'int') )) or _error(SQL_ERROR);
					if($get_data->num_rows == 0) {
						_error(404);
					}
					$data = $get_data->fetch_assoc();
					
					// assign variables
					$smarty->assign('data', $data);
					
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Market")." &rsaquo; ".__("Categories")." &rsaquo; ".$data['category_name']);
					break;

				case 'add_category':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Market")." &rsaquo; ".__("Categories")." &rsaquo; ".__("Add New Category"));
					break;

				default:
					_error(404);
					break;
			}
			break;

		case 'forums':
			// get content
			switch ($_GET['sub_view']) {
				case 'settings':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Forums")." &rsaquo; ".__("Settings"));
					break;

				case '':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Forums"));
					
					// get data
					$rows = $user->get_forums();

					// assign variables
					$smarty->assign('rows', $rows);
					break;

				case 'edit_forum':
					// valid inputs
					if(!isset($_GET['id']) || !is_numeric($_GET['id'])) {
						_error(404);
					}
					
					// get data
					$data = $user->get_forum($_GET['id']);
					if(!$data) {
						_error(404);
					}
					/* get sections */
					$data['sections'] = $user->get_forums();
					
					// assign variables
					$smarty->assign('data', $data);
					
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Forums")." &rsaquo; ".$data['forum_name']);
					break;

				case 'add_forum':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Forums")." &rsaquo; ".__("Add New Forum"));

					// get data
					$forums = $user->get_forums();

					// assign variables
					$smarty->assign('forums', $forums);
					break;

				default:
					_error(404);
					break;
			}
			break;

		case 'movies':
			// get content
			switch ($_GET['sub_view']) {
				case '':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Movies"));
					
					// get data
					$get_rows = $db->query("SELECT * FROM movies") or _error(SQL_ERROR);
					if($get_rows->num_rows > 0) {
						while($row = $get_rows->fetch_assoc()) {
							$row['movie_url'] = get_url_text($row['title']);
							$row['poster'] = get_picture($row['poster'], 'movie');
							$rows[] = $row;
						}
					}
					
					// assign variables
					$smarty->assign('rows', $rows);
					break;

				case 'edit_movie':
					// valid inputs
					if(!isset($_GET['id']) || !is_numeric($_GET['id'])) {
						_error(404);
					}
					
					// get data
					$get_data = $db->query(sprintf("SELECT * FROM movies WHERE movie_id = %s", secure($_GET['id'], 'int') )) or _error(SQL_ERROR);
					if($get_data->num_rows == 0) {
						_error(404);
					}
					$data = $get_data->fetch_assoc();
					/* get movie genres array */
					$data['genres'] = ($data['genres'])? explode(',', $data['genres']) : array();

					/* get genres */
					$data['movies_genres'] = $user->get_movies_genres();
					
					// assign variables
					$smarty->assign('data', $data);
					
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Movies")." &rsaquo; ".$data['title']);
					break;

				case 'add_movie':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Movies")." &rsaquo; ".__("Add New Movie"));

					// get data
					$genres = $user->get_movies_genres();

					// assign variables
					$smarty->assign('genres', $genres);
					break;

				case 'genres':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Movies")." &rsaquo; ".__("Genres"));
					
					// get data
					$rows = $user->get_movies_genres();
					
					// assign variables
					$smarty->assign('rows', $rows);
					break;

				case 'edit_genre':
					// valid inputs
					if(!isset($_GET['id']) || !is_numeric($_GET['id'])) {
						_error(404);
					}
					
					// get data
					$get_data = $db->query(sprintf("SELECT * FROM movies_genres WHERE genre_id = %s", secure($_GET['id'], 'int') )) or _error(SQL_ERROR);
					if($get_data->num_rows == 0) {
						_error(404);
					}
					$data = $get_data->fetch_assoc();
					
					// assign variables
					$smarty->assign('data', $data);
					
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Movies")." &rsaquo; ".__("Genres")." &rsaquo; ".$data['genre_name']);
					break;

				case 'add_genre':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Movies")." &rsaquo; ".__("Genres")." &rsaquo; ".__("Add New Genre"));
					break;

				default:
					_error(404);
					break;
			}
			break;

		case 'games':
			// get content
			switch ($_GET['sub_view']) {
				case '':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Games"));

					// get data
					$get_rows = $db->query("SELECT * FROM games") or _error(SQL_ERROR);
					if($get_rows->num_rows > 0) {
						while($row = $get_rows->fetch_assoc()) {
							$row['title_url'] = get_url_text($row['title']);
							$row['thumbnail'] = get_picture($row['thumbnail'], 'game');
							$rows[] = $row;
						}
					}
					
					// assign variables
					$smarty->assign('rows', $rows);
					break;

				case 'edit':
					// valid inputs
					if(!isset($_GET['id']) || !is_numeric($_GET['id'])) {
						_error(404);
					}
					
					// get data
					$get_data = $db->query(sprintf("SELECT * FROM games WHERE game_id = %s", secure($_GET['id'], 'int') )) or _error(SQL_ERROR);
					if($get_data->num_rows == 0) {
						_error(404);
					}
					$data = $get_data->fetch_assoc();
					
					// assign variables
					$smarty->assign('data', $data);
					
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Games")." &rsaquo; ".$data['title']);
					break;

				case 'add':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Games")." &rsaquo; ".__("Add New"));
					break;
				
				default:
					_error(404);
					break;
			}
			break;

		case 'ads':
			// get content
			switch ($_GET['sub_view']) {
				case '':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Ads")." &rsaquo; ".__("Settings"));
					break;

				case 'system_ads':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Ads")." &rsaquo; ".__("System Ads"));

					// get data
					$get_rows = $db->query("SELECT * FROM ads_system") or _error(SQL_ERROR);
					if($get_rows->num_rows > 0) {
						while($row = $get_rows->fetch_assoc()) {
							$rows[] = $row;
						}
					}
					
					// assign variables
					$smarty->assign('rows', $rows);
					break;

				case 'edit':
					// valid inputs
					if(!isset($_GET['id']) || !is_numeric($_GET['id'])) {
						_error(404);
					}
					
					// get data
					$get_data = $db->query(sprintf("SELECT * FROM ads_system WHERE ads_id = %s", secure($_GET['id'], 'int') )) or _error(SQL_ERROR);
					if($get_data->num_rows == 0) {
						_error(404);
					}
					$data = $get_data->fetch_assoc();
					
					// assign variables
					$smarty->assign('data', $data);
					
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Ads")." &rsaquo; ".$data['title']);
					break;

				case 'add':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Ads")." &rsaquo; ".__("Add New"));
					break;

				case 'users_ads':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Ads")." &rsaquo; ".__("Users Ads"));

					// get data
					$get_rows = $db->query("SELECT ads_campaigns.*, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM ads_campaigns INNER JOIN users ON ads_campaigns.campaign_user_id = users.user_id") or _error(SQL_ERROR);
					if($get_rows->num_rows > 0) {
						while($row = $get_rows->fetch_assoc()) {
							$row['user_picture'] = get_picture($row['user_picture'], $row['user_gender']);
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

		case 'packages':
			// get content
			switch ($_GET['sub_view']) {
				case '':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Pro Packages"));

					// get data
					$get_rows = $db->query("SELECT * FROM packages") or _error(SQL_ERROR);
					if($get_rows->num_rows > 0) {
						while($row = $get_rows->fetch_assoc()) {
							$row['icon'] = get_picture($row['icon'], 'package');
							$rows[] = $row;
						}
					}
					
					// assign variables
					$smarty->assign('rows', $rows);
					break;

				case 'edit':
					// valid inputs
					if(!isset($_GET['id']) || !is_numeric($_GET['id'])) {
						_error(404);
					}
					
					// get data
					$get_data = $db->query(sprintf("SELECT * FROM packages WHERE package_id = %s", secure($_GET['id'], 'int') )) or _error(SQL_ERROR);
					if($get_data->num_rows == 0) {
						_error(404);
					}
					$data = $get_data->fetch_assoc();
					
					// assign variables
					$smarty->assign('data', $data);
					
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Pro Packages")." &rsaquo; ".$data['name']);
					break;

				case 'add':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Pro Packages")." &rsaquo; ".__("Add New"));
					break;

				case 'subscribers':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Pro Packages")." &rsaquo; ".__("Subscribers"));

					// get data
					$get_rows = $db->query("SELECT users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, users.user_subscription_date, packages.* FROM users INNER JOIN packages ON users.user_package = packages.package_id WHERE users.user_subscribed = '1'") or _error(SQL_ERROR);
					if($get_rows->num_rows > 0) {
						while($row = $get_rows->fetch_assoc()) {
							$row['icon'] = get_picture($row['icon'], 'package');
							$row['user_picture'] = get_picture($row['user_picture'], $row['user_gender']);
							switch ($row['period']) {
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
			                $row['subscription_end'] = strtotime($row['user_subscription_date']) + ($row['period_num'] * $duration);
			                $row['subscription_timeleft'] = ceil(($row['subscription_end'] - time()) / (60 * 60 * 24));
							$rows[] = $row;
						}
					}

					// assign variables
					$smarty->assign('rows', $rows);
					break;

				case 'earnings':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Pro Packages")." &rsaquo; ".__("Earnings"));

					// get data
					$total_earnings = 0;
					$month_earnings = 0;
					$get_rows = $db->query("SELECT * FROM packages_payments") or _error(SQL_ERROR);
					$rows = array();
					if($get_rows->num_rows > 0) {
						while($row = $get_rows->fetch_assoc()) {
							$row_month = date("n",strtotime($row['payment_date']));
							if($rows[$row['package_name']]) {
								$rows[$row['package_name']]['sales']++;
								if($rows[$row['package_name']]['months_sales'][$row_month]) {
									$rows[$row['package_name']]['months_sales'][$row_month]++;
								} else {
									$rows[$row['package_name']]['months_sales'][$row_month] = 1;
								}
								$rows[$row['package_name']]['earnings'] += $row['package_price'];
								/* add to month earnings */
								if($row_month == date('n')) {
									$month_earnings += $row['package_price'];
								}
								/* add to total earnings */
								$total_earnings += $row['package_price'];
							} else {
								$rows[$row['package_name']]['sales'] = 1;
								$rows[$row['package_name']]['months_sales'][$row_month] = 1;
								$rows[$row['package_name']]['earnings'] = $row['package_price'];
								/* add to month earnings */
								if($row_month == date('n')) {
									$month_earnings += $row['package_price'];
								}
								/* add to total earnings */
								$total_earnings += $row['package_price'];
							}
						}
					}
					/* prepare months sales */
					if($rows) {
						foreach ($rows as $key => $value) {
							for($i=1; $i <= 12; $i++) {
								if($rows[$key]['months_sales'][$i]) {
									continue;
								} else {
									$rows[$key]['months_sales'][$i] = 0;
								}
							}
						}
					}

					// assign variables
					$smarty->assign('total_earnings', $total_earnings);
					$smarty->assign('month_earnings', $month_earnings);
					$smarty->assign('rows', $rows);
					break;
				
				default:
					_error(404);
					break;
			}
			break;

		case 'affiliates':
			// get content
			switch ($_GET['sub_view']) {
				case '':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Affiliates"));
					break;

				case 'payments':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Affiliates")." &rsaquo; ".__("Payment Requests"));

					// get data
					$get_rows = $db->query("SELECT affiliates_payments.*, users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM affiliates_payments INNER JOIN users ON affiliates_payments.user_id = users.user_id WHERE affiliates_payments.status = '0'") or _error(SQL_ERROR);
					if($get_rows->num_rows > 0) {
						while($row = $get_rows->fetch_assoc()) {
							$row['user_picture'] = get_picture($row['user_picture'], $row['user_gender']);
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
			// get content
			switch ($_GET['sub_view']) {
				case '':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Points System"));
					break;

				case 'payments':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Points System")." &rsaquo; ".__("Payment Requests"));

					// get data
					$get_rows = $db->query("SELECT points_payments.*, users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM points_payments INNER JOIN users ON points_payments.user_id = users.user_id WHERE points_payments.status = '0'") or _error(SQL_ERROR);
					if($get_rows->num_rows > 0) {
						while($row = $get_rows->fetch_assoc()) {
							$row['user_picture'] = get_picture($row['user_picture'], $row['user_gender']);
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

		case 'reports':
			// page header
			page_header(__("Admin")." &rsaquo; ".__("Reports"));

			// get data
			$get_rows = $db->query("SELECT reports.*, users.user_name, users.user_firstname, users.user_lastname, users.user_picture, users.user_gender FROM reports INNER JOIN users ON reports.user_id = users.user_id") or _error(SQL_ERROR);
			if($get_rows->num_rows > 0) {
				while($row = $get_rows->fetch_assoc()) {
					$row['user_picture'] = get_picture($row['user_picture'], $row['user_gender']);
					/* get reported node */
					if($row['node_type'] == "user") {
						$get_node = $db->query(sprintf("SELECT user_name, user_firstname, user_lastname, user_gender, user_picture FROM users WHERE user_id = %s", secure($row['node_id'], 'int') )) or _error(SQL_ERROR);
						if($get_node->num_rows == 0) continue;
						$node = $get_node->fetch_assoc();
						$node['user_picture'] = get_picture($node['user_picture'], $node['user_gender']);
						$node['color'] = 'primary';
						$node['name'] = $row['node_type'];

					} elseif ($row['node_type'] == 'page') {
						$get_node = $db->query(sprintf("SELECT page_name, page_title, page_picture FROM pages WHERE page_id = %s", secure($row['node_id'], 'int') )) or _error(SQL_ERROR);
						if($get_node->num_rows == 0) continue;
						$node = $get_node->fetch_assoc();
						$node['page_picture'] = get_picture($node['page_picture'], 'page');
						$node['color'] = 'info';
						$node['name'] = $row['node_type'];

					} elseif ($row['node_type'] == 'group') {
						$get_node = $db->query(sprintf("SELECT group_name, group_title, group_picture FROM groups WHERE group_id = %s", secure($row['node_id'], 'int') )) or _error(SQL_ERROR);
						if($get_node->num_rows == 0) continue;
						$node = $get_node->fetch_assoc();
						$node['group_picture'] = get_picture($node['group_picture'], 'group');
						$node['color'] = 'warning';
						$node['name'] = $row['node_type'];

					} elseif ($row['node_type'] == 'event') {
						$get_node = $db->query(sprintf("SELECT event_title, event_cover FROM events WHERE event_id = %s", secure($row['node_id'], 'int') )) or _error(SQL_ERROR);
						if($get_node->num_rows == 0) continue;
						$node = $get_node->fetch_assoc();
						$node['event_picture'] = get_picture($node['event_cover'], 'event');
						$node['color'] = 'success';
						$node['name'] = $row['node_type'];

					} elseif ($row['node_type'] == 'comment') {
						$comment = $user->get_comment($row['node_id']);
						if(!$comment) continue;
						if($comment['node_type'] == "post") {
							$_handle = '/posts/';
							$_node_id = $comment['node_id'];
						} elseif ($comment['node_type'] == "photo") {
							$_handle = '/photos/';
							$_node_id = $comment['node_id'];
						} elseif($comment['node_type'] == "comment") {
							$_handle = ($comment['parent_comment']['node_type'] == "post")? '/posts/': '/photos/';
							$_node_id = $comment['parent_comment']['node_id'];
						}
						$row['url'] = $system['system_url'].$_handle.$_node_id.'?notify_id=comment_'.$row['node_id'];
						$node['color'] = 'secondary';
						$node['name'] = $row['node_type'];

					} elseif ($row['node_type'] == 'post') {
						$node['color'] = 'danger';
						$node['name'] = $row['node_type'];

					} elseif ($row['node_type'] == 'forum_thread') {
						$thread = $user->get_forum_thread($row['node_id']);
						if(!$thread) continue;
						$row['url'] = $system['system_url'].'/forums/thread/'.$thread['thread_id'].'/'.$thread['title_url'];
						$node['color'] = 'secondary';
						$node['name'] = __("Forum Thread");

					} elseif ($row['node_type'] == 'forum_reply') {
						$reply = $user->get_forum_reply($row['node_id']);
						if(!$reply) continue;
						$row['url'] = $system['system_url'].'/forums/thread/'.$reply['thread']['thread_id'].'/'.$reply['thread']['title_url'].'/#reply-'.$reply['reply_id'];
						$node['color'] = 'secondary';
						$node['name'] = __("Forum Reply");
					}
					$row['node'] = $node;
					$rows[] = $row;
				}
			}
			
			// assign variables
			$smarty->assign('rows', $rows);
			break;

		case 'banned_ips':
			// get content
			switch ($_GET['sub_view']) {
				case '':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Banned IPs"));

					// get data
					$get_rows = $db->query("SELECT * FROM banned_ips") or _error(SQL_ERROR);
					if($get_rows->num_rows > 0) {
						while($row = $get_rows->fetch_assoc()) {
							$rows[] = $row;
						}
					}
					
					// assign variables
					$smarty->assign('rows', $rows);
					break;

				case 'add':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Banned IPs")." &rsaquo; ".__("Add New"));
					break;
				
				default:
					_error(404);
					break;
			}
			break;

		case 'verification':
			// get content
			switch ($_GET['sub_view']) {
				case '':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Verification")." &rsaquo; ".__("Requests"));
					
					// get data
					$get_rows = $db->query("SELECT verification_requests.*, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, pages.page_name, pages.page_title, pages.page_picture FROM verification_requests LEFT JOIN users ON verification_requests.node_type = 'user' AND verification_requests.node_id = users.user_id LEFT JOIN pages ON verification_requests.node_type = 'page' AND verification_requests.node_id = pages.page_id WHERE status = '0'") or _error(SQL_ERROR);
					if($get_rows->num_rows > 0) {
						while($row = $get_rows->fetch_assoc()) {
							/* get node */
							if($row['node_type'] == "user") {
								$row['user_picture'] = get_picture($row['user_picture'], $row['user_gender']);
								$row['color'] = 'primary';
							} elseif ($row['node_type'] == 'page') {
								$row['page_picture'] = get_picture($row['page_picture'], 'page');
								$row['color'] = 'info';
							}
							$rows[] = $row;
						}
					}
					
					// assign variables
					$smarty->assign('rows', $rows);
					break;

				case 'users':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Verification")." &rsaquo; ".__("Verified Users"));
					
					// get data
					$get_rows = $db->query("SELECT * FROM users WHERE user_verified = '1'") or _error(SQL_ERROR);
					if($get_rows->num_rows > 0) {
						while($row = $get_rows->fetch_assoc()) {
							$row['user_picture'] = get_picture($row['user_picture'], $row['user_gender']);
							$rows[] = $row;
						}
					}

					// assign variables
					$smarty->assign('rows', $rows);
					break;

				case 'pages':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Verification")." &rsaquo; ".__("Verified Pages"));
					
					// get data
					$get_rows = $db->query("SELECT * FROM pages WHERE page_verified = '1'") or _error(SQL_ERROR);
					if($get_rows->num_rows > 0) {
						while($row = $get_rows->fetch_assoc()) {
							$row['page_picture'] = get_picture($row['page_picture'], 'page');
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

		case 'tools':
			// get content
			switch ($_GET['sub_view']) {
				case 'faker':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Tools")." &rsaquo; ".__("Fake Users Generator"));
					break;
				
				default:
					_error(404);
					break;
			}
			break;
		
		case 'custom_fields':
			// get content
			switch ($_GET['sub_view']) {
				case '':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Custom Fields"));

					// get data
					$get_rows = $db->query("SELECT * FROM custom_fields") or _error(SQL_ERROR);
					if($get_rows->num_rows > 0) {
						while($row = $get_rows->fetch_assoc()) {
							$rows[] = $row;
						}
					}
					
					// assign variables
					$smarty->assign('rows', $rows);
					break;

				case 'edit':
					// valid inputs
					if(!isset($_GET['id']) || !is_numeric($_GET['id'])) {
						_error(404);
					}
					
					// get data
					$get_data = $db->query(sprintf("SELECT * FROM custom_fields WHERE field_id = %s", secure($_GET['id'], 'int') )) or _error(SQL_ERROR);
					if($get_data->num_rows == 0) {
						_error(404);
					}
					$data = $get_data->fetch_assoc();
					
					// assign variables
					$smarty->assign('data', $data);
					
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Custom Fields")." &rsaquo; ".$data['label']);
					break;

				case 'add':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Custom Fields")." &rsaquo; ".__("Add New"));
					break;
				
				default:
					_error(404);
					break;
			}
			break;

		case 'static':
			// get content
			switch ($_GET['sub_view']) {
				case '':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Static Pages"));

					// get data
					$get_rows = $db->query("SELECT * FROM static_pages") or _error(SQL_ERROR);
					if($get_rows->num_rows > 0) {
						while($row = $get_rows->fetch_assoc()) {
							$rows[] = $row;
						}
					}
					
					// assign variables
					$smarty->assign('rows', $rows);
					break;

				case 'edit':
					// valid inputs
					if(!isset($_GET['id']) || !is_numeric($_GET['id'])) {
						_error(404);
					}
					
					// get data
					$get_data = $db->query(sprintf("SELECT * FROM static_pages WHERE page_id = %s", secure($_GET['id'], 'int') )) or _error(SQL_ERROR);
					if($get_data->num_rows == 0) {
						_error(404);
					}
					$data = $get_data->fetch_assoc();
					
					// assign variables
					$smarty->assign('data', $data);
					
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Static Pages")." &rsaquo; ".$data['page_title']);
					break;

				case 'add':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Static Pages")." &rsaquo; ".__("Add New"));
					break;
				
				default:
					_error(404);
					break;
			}
			break;

		case 'widgets':
			// get content
			switch ($_GET['sub_view']) {
				case '':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Widgets"));

					// get data
					$get_rows = $db->query("SELECT * FROM widgets") or _error(SQL_ERROR);
					if($get_rows->num_rows > 0) {
						while($row = $get_rows->fetch_assoc()) {
							$rows[] = $row;
						}
					}
					
					// assign variables
					$smarty->assign('rows', $rows);
					break;

				case 'edit':
					// valid inputs
					if(!isset($_GET['id']) || !is_numeric($_GET['id'])) {
						_error(404);
					}
					
					// get data
					$get_data = $db->query(sprintf("SELECT * FROM widgets WHERE widget_id = %s", secure($_GET['id'], 'int') )) or _error(SQL_ERROR);
					if($get_data->num_rows == 0) {
						_error(404);
					}
					$data = $get_data->fetch_assoc();
					
					// assign variables
					$smarty->assign('data', $data);
					
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Widgets")." &rsaquo; ".$data['title']);
					break;

				case 'add':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Widgets")." &rsaquo; ".__("Add New"));
					break;
				
				default:
					_error(404);
					break;
			}
			break;

		case 'emojis':
			// get content
			switch ($_GET['sub_view']) {
				case '':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Emojis"));
					
					// get data
					$rows = $user->get_emojis();
					
					// assign variables
					$smarty->assign('rows', $rows);
					break;

				case 'edit':
					// valid inputs
					if(!isset($_GET['id']) || !is_numeric($_GET['id'])) {
						_error(404);
					}
					
					// get data
					$get_data = $db->query(sprintf("SELECT * FROM emojis WHERE emoji_id = %s", secure($_GET['id'], 'int') )) or _error(SQL_ERROR);
					if($get_data->num_rows == 0) {
						_error(404);
					}
					$data = $get_data->fetch_assoc();
					
					// assign variables
					$smarty->assign('data', $data);
					
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Emojis")." &rsaquo; ".__("Edit Emoji"));
					break;

				case 'add':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Emojis")." &rsaquo; ".__("Add New Emoji"));
					break;

				default:
					_error(404);
					break;
			}
			break;

		case 'stickers':
			// get content
			switch ($_GET['sub_view']) {
				case '':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Stickers"));
					
					// get data
					$rows = $user->get_stickers();
					
					// assign variables
					$smarty->assign('rows', $rows);
					break;

				case 'edit':
					// valid inputs
					if(!isset($_GET['id']) || !is_numeric($_GET['id'])) {
						_error(404);
					}
					
					// get data
					$get_data = $db->query(sprintf("SELECT * FROM stickers WHERE sticker_id = %s", secure($_GET['id'], 'int') )) or _error(SQL_ERROR);
					if($get_data->num_rows == 0) {
						_error(404);
					}
					$data = $get_data->fetch_assoc();
					
					// assign variables
					$smarty->assign('data', $data);
					
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Stickers")." &rsaquo; ".__("Edit Sticker"));
					break;

				case 'add':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Stickers")." &rsaquo; ".__("Add New Sticker"));
					break;

				default:
					_error(404);
					break;
			}
			break;

		case 'announcements':
			// get content
			switch ($_GET['sub_view']) {
				case '':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Announcements"));

					// get data
					$get_rows = $db->query("SELECT * FROM announcements") or _error(SQL_ERROR);
					if($get_rows->num_rows > 0) {
						while($row = $get_rows->fetch_assoc()) {
							$rows[] = $row;
						}
					}
					
					// assign variables
					$smarty->assign('rows', $rows);
					break;

				case 'edit':
					// valid inputs
					if(!isset($_GET['id']) || !is_numeric($_GET['id'])) {
						_error(404);
					}
					
					// get data
					$get_data = $db->query(sprintf("SELECT * FROM announcements WHERE announcement_id = %s", secure($_GET['id'], 'int') )) or _error(SQL_ERROR);
					if($get_data->num_rows == 0) {
						_error(404);
					}
					$data = $get_data->fetch_assoc();
					
					// assign variables
					$smarty->assign('data', $data);
					
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Announcements")." &rsaquo; ".$data['name']);
					break;

				case 'add':
					// page header
					page_header(__("Admin")." &rsaquo; ".__("Announcements")." &rsaquo; ".__("Add New"));
					break;
				
				default:
					_error(404);
					break;
			}
			break;

		case 'notifications':
			// page header
			page_header(__("Admin")." &rsaquo; ".__("Mass Notifications"));
			break;

		case 'newsletter':
			// page header
			page_header(__("Admin")." &rsaquo; ".__("Newsletter"));
			break;

		case 'changelog':
			// page header
			page_header(__("Admin")." &rsaquo; ".__("Changelog"));
			break;

		default:
			_error(404);
	}
	/* assign variables */
	$smarty->assign('view', $_GET['view']);
	$smarty->assign('sub_view', $_GET['sub_view']);

} catch (Exception $e) {
	_error(__("Error"), $e->getMessage());
}

// page footer
page_footer("admin");

?>