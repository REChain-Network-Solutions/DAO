<?php

/**
 * ajax -> admin -> delete
 * 
 * @package Sngine
 * @author Zamblek
 */

// fetch bootstrap
require('../../../bootstrap.php');

// check AJAX Request
is_ajax();

// valid inputs
if ($_POST['handle'] != "reports" && $_POST['handle'] != "user_points_reset") {
  if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
    _error(400);
  }
}

// check demo account
if ($user->_data['user_demo']) {
  modal("ERROR", __("Demo Restriction"), __("You can't do this with demo account"));
}

// refresh the compiled system cache
register_shutdown_function('system_cache_flush');

// handle delete
try {

  switch ($_POST['handle']) {

    case 'theme':
      // check admin|moderator permission
      if (!$user->_is_admin) {
        modal("MESSAGE", __("System Message"), __("You don't have the right permission to access this"));
      }
      /* check if this theme is the default one */
      $check_themes = $db->query(sprintf("SELECT COUNT(*) as count FROM system_themes WHERE system_themes.default = '1' and theme_id = %s", secure($_POST['id'], 'int')));
      if ($check_themes->fetch_assoc()['count'] > 0) {
        throw new Exception(__("This is your only default theme you need to mark other theme as default before change/delete this one"));
      }
      $db->query(sprintf("DELETE FROM system_theme_landings WHERE theme_id = %s", secure($_POST['id'], 'int')));
      $db->query(sprintf("DELETE FROM system_themes WHERE theme_id = %s", secure($_POST['id'], 'int')));
      break;

    case 'language':
      // check admin|moderator permission
      if (!$user->_is_admin) {
        modal("MESSAGE", __("System Message"), __("You don't have the right permission to access this"));
      }
      $db->query(sprintf("DELETE FROM system_languages WHERE language_id = %s", secure($_POST['id'], 'int')));
      break;

    case 'country':
      // check admin|moderator permission
      if (!$user->_is_admin) {
        modal("MESSAGE", __("System Message"), __("You don't have the right permission to access this"));
      }
      $db->query(sprintf("DELETE FROM system_countries WHERE country_id = %s", secure($_POST['id'], 'int')));
      break;

    case 'currency':
      // check admin|moderator permission
      if (!$user->_is_admin) {
        modal("MESSAGE", __("System Message"), __("You don't have the right permission to access this"));
      }
      $db->query(sprintf("DELETE FROM system_currencies WHERE currency_id = %s", secure($_POST['id'], 'int')));
      break;

    case 'gender':
      // check admin|moderator permission
      if (!$user->_is_admin) {
        modal("MESSAGE", __("System Message"), __("You don't have the right permission to access this"));
      }
      $db->query(sprintf("DELETE FROM system_genders WHERE gender_id = %s", secure($_POST['id'], 'int')));
      break;

    case 'user':
      // check admin|moderator permission
      if (!$user->_is_admin) {
        modal("MESSAGE", __("System Message"), __("You don't have the right permission to access this"));
      }
      // check if changing the super admin user
      if ($user->_data['user_id'] != '1' && $_POST['id'] == '1') {
        modal("MESSAGE", __("System Message"), __("You don't have the right permission to edit this user"));
      }
      // [BACKGROUND PROCESS]
      /* return async */
      return_json_async();
      /* delete report */
      if (isset($_POST['node']) && is_numeric($_POST['node'])) {
        $db->query(sprintf("DELETE FROM reports WHERE report_id = %s", secure($_POST['node'], 'int')));
      }
      /* delete user */
      $user->delete_user($_POST['id']);
      break;

    case 'user_posts':
      // check admin|moderator permission
      admin_access('mods_users_permission');
      // check if changing the super admin user
      if ($user->_data['user_id'] != '1' && $_POST['id'] == '1') {
        modal("MESSAGE", __("System Message"), __("You don't have the right permission to edit this user"));
      }
      // [BACKGROUND PROCESS]
      /* return async */
      return_json_async();
      /* delete user posts */
      $user->delete_posts($_POST['id']);
      break;

    case 'user_profile':
      // check admin|moderator permission
      admin_access('mods_users_permission');
      // check if changing the super admin user
      if ($user->_data['user_id'] != '1' && $_POST['id'] == '1') {
        modal("MESSAGE", __("System Message"), __("You don't have the right permission to edit this user"));
      }
      // get user info
      $user_info = $user->get_user($_POST['id']);
      if (!$user_info) {
        _error(400);
      }
      // check if the user is admin and viewer is not admin
      if ($user_info['user_group'] == '1' && !$user->_is_admin) {
        modal("MESSAGE", __("System Message"), __("You can't edit an admin user"));
      }
      // reset user profile
      $db->query(sprintf("UPDATE users SET user_relationship = NULL, user_biography = NULL, user_website = NULL, user_work_title = NULL, user_work_place = NULL, user_work_url = NULL, user_current_city = NULL, user_hometown = NULL, user_edu_major = NULL, user_edu_school = NULL, user_edu_class = NULL, user_social_facebook = NULL, user_social_twitter = NULL, user_social_youtube = NULL, user_social_instagram = NULL, user_social_twitch = NULL, user_social_linkedin = NULL, user_social_vkontakte = NULL WHERE user_id = %s", secure($_POST['id'], 'int')));
      $db->query(sprintf("DELETE FROM custom_fields_values WHERE node_type = 'user' AND node_id = %s", secure($_POST['id'], 'int')));
      break;

    case 'session':
      // check admin|moderator permission
      if (!$user->_is_admin) {
        modal("MESSAGE", __("System Message"), __("You don't have the right permission to access this"));
      }
      $db->query(sprintf("DELETE FROM users_sessions WHERE session_id = %s", secure($_POST['id'], 'int')));
      break;

    case 'user_sessions':
      // check admin|moderator permission
      if (!$user->_is_admin) {
        modal("MESSAGE", __("System Message"), __("You don't have the right permission to access this"));
      }
      // check if changing the super admin user
      if ($user->_data['user_id'] != '1' && $_POST['id'] == '1') {
        modal("MESSAGE", __("System Message"), __("You don't have the right permission to edit this user"));
      }
      // delete user sessions (keep the current one)
      $db->query(sprintf("DELETE FROM users_sessions WHERE user_id = %s AND session_id != %s", secure($_POST['id'], 'int'), secure($user->_data['active_session_id'], 'int')));
      break;

    case 'user_package':
      // check admin|moderator permission
      if (!$user->_is_admin) {
        modal("MESSAGE", __("System Message"), __("You don't have the right permission to access this"));
      }
      // unsubscribe user package
      $user->unsubscribe_user_package($_POST['id']);
      break;

    case 'user_group':
      // check admin|moderator permission
      if (!$user->_is_admin) {
        modal("MESSAGE", __("System Message"), __("You don't have the right permission to access this"));
      }
      /* update all users with such user group */
      $db->query(sprintf("UPDATE users SET user_group_custom = '0' WHERE user_group_custom = %s", secure($_POST['id'], 'int')));
      /* delete group */
      $db->query(sprintf("DELETE FROM users_groups WHERE user_group_id = %s", secure($_POST['id'], 'int')));
      /* update system default custom user group */
      if ($system['default_custom_user_group'] == $_POST['id']) {
        /* update system */
        update_system_options([
          'default_custom_user_group' => '0'
        ]);
      }
      break;

    case 'permissions_group':
      // check admin|moderator permission
      if (!$user->_is_admin) {
        modal("MESSAGE", __("System Message"), __("You don't have the right permission to access this"));
      }
      /* check if there is any users group using this permissions group */
      $check_users_groups = $db->query(sprintf("SELECT COUNT(*) as count FROM users_groups WHERE permissions_group_id = %s", secure($_POST['id'], 'int')));
      if ($check_users_groups->fetch_assoc()['count'] > 0) {
        throw new Exception(__("There are users groups using this permissions group"));
      }
      /* update all packages with this permissions group */
      $db->query(sprintf("UPDATE packages SET package_permissions_group_id = '0' WHERE package_permissions_group_id = %s", secure($_POST['id'], 'int')));
      /* delete permissions group */
      $db->query(sprintf("DELETE FROM permissions_groups WHERE permissions_group_id = %s", secure($_POST['id'], 'int')));
      break;

    case 'video_category':
      // check admin|moderator permission
      admin_access('mods_posts_permission');
      $user->delete_category("posts_videos_categories", $_POST['id']);
      break;

    case 'live_category':
      // check admin|moderator permission
      admin_access('mods_posts_permission');
      $user->delete_category("posts_live_categories", $_POST['id']);
      break;

    case 'page':
      // check admin|moderator permission
      admin_access('mods_pages_permission');
      // [BACKGROUND PROCESS]
      /* return async */
      return_json_async();
      /* delete report */
      if (isset($_POST['node']) && is_numeric($_POST['node'])) {
        $db->query(sprintf("DELETE FROM reports WHERE report_id = %s", secure($_POST['node'], 'int')));
      }
      /* delete page */
      $user->delete_page($_POST['id']);
      break;

    case 'page_posts':
      // check admin|moderator permission
      admin_access('mods_pages_permission');
      // [BACKGROUND PROCESS]
      /* return async */
      return_json_async();
      /* delete page posts */
      $user->delete_posts($_POST['id'], 'page');
      break;

    case 'page_category':
      // check admin|moderator permission
      admin_access('mods_pages_permission');
      $user->delete_category("pages_categories", $_POST['id']);
      break;

    case 'group':
      // check admin|moderator permission
      admin_access('mods_groups_permission');
      // [BACKGROUND PROCESS]
      /* return async */
      return_json_async();
      /* delete report */
      if (isset($_POST['node']) && is_numeric($_POST['node'])) {
        $db->query(sprintf("DELETE FROM reports WHERE report_id = %s", secure($_POST['node'], 'int')));
      }
      /* delete group */
      $user->delete_group($_POST['id']);
      break;

    case 'group_posts':
      // check admin|moderator permission
      admin_access('mods_groups_permission');
      // [BACKGROUND PROCESS]
      /* return async */
      return_json_async();
      /* delete group posts */
      $user->delete_posts($_POST['id'], 'group');
      break;

    case 'group_category':
      // check admin|moderator permission
      admin_access('mods_groups_permission');
      $user->delete_category("groups_categories", $_POST['id']);
      break;

    case 'event':
      // check admin|moderator permission
      admin_access('mods_events_permission');
      // [BACKGROUND PROCESS]
      /* return async */
      return_json_async();
      /* delete report */
      if (isset($_POST['node']) && is_numeric($_POST['node'])) {
        $db->query(sprintf("DELETE FROM reports WHERE report_id = %s", secure($_POST['node'], 'int')));
      }
      /* delete event */
      $user->delete_event($_POST['id']);
      break;

    case 'event_posts':
      // check admin|moderator permission
      admin_access('mods_events_permission');
      // [BACKGROUND PROCESS]
      /* return async */
      return_json_async();
      /* delete event posts */
      $user->delete_posts($_POST['id'], 'event');
      break;

    case 'event_category':
      // check admin|moderator permission
      admin_access('mods_events_permission');
      $user->delete_category("events_categories", $_POST['id']);
      break;

    case 'blogs_category':
      // check admin|moderator permission
      admin_access('mods_blogs_permission');
      $user->delete_category("blogs_categories", $_POST['id']);
      break;

    case 'market_category':
      // check admin|moderator permission
      admin_access('mods_marketplace_permission');
      $user->delete_category("market_categories", $_POST['id']);
      break;

    case 'order':
      // check admin|moderator permission
      admin_access('mods_marketplace_permission');
      if (!licence_has_entitlement('monetization')) {
        licence_throw_admin_lock();
      }
      /* delete order */
      $db->query(sprintf("DELETE FROM orders WHERE order_id = %s", secure($_POST['id'], 'int')));
      /* delete order items */
      $db->query(sprintf("DELETE FROM orders_items WHERE order_id = %s", secure($_POST['id'], 'int')));
      break;

    case 'offers_category':
      // check admin|moderator permission
      admin_access('mods_offers_permission');
      $user->delete_category("offers_categories", $_POST['id']);
      break;

    case 'funding_category':
      // check admin|moderator permission
      admin_access('mods_funding_permission');
      $user->delete_category("funding_categories", $_POST['id']);
      break;

    case 'jobs_category':
      // check admin|moderator permission
      admin_access('mods_jobs_permission');
      $user->delete_category("jobs_categories", $_POST['id']);
      break;

    case 'courses_category':
      // check admin|moderator permission
      admin_access('mods_courses_permission');
      $user->delete_category("courses_categories", $_POST['id']);
      break;

    case 'forum':
      // check admin|moderator permission
      admin_access('mods_forums_permission');
      // [BACKGROUND PROCESS]
      /* return async */
      return_json_async();
      /* delete report */
      if (isset($_POST['node']) && is_numeric($_POST['node'])) {
        $db->query(sprintf("DELETE FROM reports WHERE report_id = %s", secure($_POST['node'], 'int')));
      }
      /* delete forum */
      $user->delete_forum($_POST['id']);
      break;

    case 'forum_thread':
      // check admin|moderator permission
      admin_access('mods_forums_permission');
      // [BACKGROUND PROCESS]
      /* return async */
      return_json_async();
      /* delete forum thread */
      $user->delete_forum_thread($_POST['id']);
      if (isset($_POST['node']) && is_numeric($_POST['node'])) {
        /* delete report */
        $db->query(sprintf("DELETE FROM reports WHERE report_id = %s", secure($_POST['node'], 'int')));
      }
      break;

    case 'forum_reply':
      // check admin|moderator permission
      admin_access('mods_forums_permission');
      // [BACKGROUND PROCESS]
      /* return async */
      return_json_async();
      /* delete report */
      if (isset($_POST['node']) && is_numeric($_POST['node'])) {
        $db->query(sprintf("DELETE FROM reports WHERE report_id = %s", secure($_POST['node'], 'int')));
      }
      /* delete forum reply */
      $user->delete_forum_reply($_POST['id']);
      break;

    case 'movie':
      // check admin|moderator permission
      admin_access('mods_movies_permission');
      $db->query(sprintf("DELETE FROM movies WHERE movie_id = %s", secure($_POST['id'], 'int')));
      break;

    case 'movie_genre':
      // check admin|moderator permission
      admin_access('mods_movies_permission');
      $db->query(sprintf("DELETE FROM movies_genres WHERE genre_id = %s", secure($_POST['id'], 'int')));
      break;

    case 'game':
      // check admin|moderator permission
      admin_access('mods_games_permission');
      $db->query(sprintf("DELETE FROM games WHERE game_id = %s", secure($_POST['id'], 'int')));
      $user->delete_shortcuts($_POST['id'], 'game');
      break;

    case 'game_genre':
      // check admin|moderator permission
      admin_access('mods_games_permission');
      $db->query(sprintf("DELETE FROM games_genres WHERE genre_id = %s", secure($_POST['id'], 'int')));
      break;

    case 'ads_system':
      // check admin|moderator permission
      admin_access('mods_ads_permission');
      $db->query(sprintf("DELETE FROM ads_system WHERE ads_id = %s", secure($_POST['id'], 'int')));
      break;

    case 'ads_campaign':
      // check admin|moderator permission
      admin_access('mods_ads_permission');
      /* delete report */
      if (isset($_POST['node']) && is_numeric($_POST['node'])) {
        $db->query(sprintf("DELETE FROM reports WHERE report_id = %s", secure($_POST['node'], 'int')));
      }
      /* delete ads campaign */
      $user->delete_campaign($_POST['id']);
      break;

    case 'package':
      // check admin|moderator permission
      admin_access('mods_pro_permission');
      /* get the package */
      $package = method_exists($user, 'get_package') ? $user->get_package($_POST['id']) : null;
      /* update all users who have this package */
      $db->query(sprintf("UPDATE users SET user_subscribed = '0', user_package = null, user_subscription_date = null, user_boosted_posts = '0', user_boosted_pages = '0', user_boosted_groups = '0', user_boosted_events = '0' WHERE user_package = %s", secure($_POST['id'], 'int')));
      widget_pools_forget();
      /* remove all users recurring payments */
      $db->query(sprintf("DELETE FROM users_recurring_payments WHERE handle = 'packages' AND handle_id = %s", secure($_POST['id'], 'int')));
      /* delete package */
      $db->query(sprintf("DELETE FROM packages WHERE package_id = %s", secure($_POST['id'], 'int')));
      /* deactivate PayPal billing plan */
      if ($package && !empty($package['paypal_billing_plan']) && function_exists('paypal_deactivate_billing_plan')) {
        paypal_deactivate_billing_plan($package['paypal_billing_plan']);
      }
      /* deactivate Stripe plan */
      if ($package && !empty($package['stripe_plan_id']) && function_exists('stripe_deactivate_plan')) {
        stripe_deactivate_plan($package['stripe_plan_id']);
      }
      break;

    case 'dating_interest':
      // check admin|moderator permission
      if (!$user->_is_admin) {
        modal("MESSAGE", __("System Message"), __("You don't have the right permission to access this"));
      }
      $db->query(sprintf("DELETE FROM dating_interests WHERE interest_id = %s", secure($_POST['id'], 'int')));
      $db->query(sprintf("DELETE FROM dating_profiles_interests WHERE interest_id = %s", secure($_POST['id'], 'int')));
      break;

    case 'dating_profile':
      // check admin|moderator permission
      admin_access('mods_dating_permission');
      $user->delete_dating_profile($_POST['id']);
      break;

    case 'dating_photo':
      // check admin|moderator permission
      admin_access('mods_dating_permission');
      $user->delete_dating_photo($_POST['id'], true);
      break;

    case 'apps_category':
      // check admin|moderator permission
      admin_access('mods_developers_permission');
      $user->delete_category("developers_apps_categories", $_POST['id']);
      break;

    case 'report':
      // check admin|moderator permission
      admin_access('mods_reports_permission');
      $db->query(sprintf("DELETE FROM reports WHERE report_id = %s", secure($_POST['id'], 'int')));
      break;

    case 'reports':
      // check admin|moderator permission
      admin_access('mods_reports_permission');
      $db->query("DELETE FROM reports");
      break;

    case 'report_category':
      // check admin|moderator permission
      admin_access('mods_reports_permission');
      $user->delete_category("reports_categories", $_POST['id']);
      break;

    case 'post':
      // check admin|moderator permission
      admin_access('mods_posts_permission');
      // [BACKGROUND PROCESS]
      /* return async */
      return_json_async();
      /* delete report */
      if (isset($_POST['node']) && is_numeric($_POST['node'])) {
        $db->query(sprintf("DELETE FROM reports WHERE report_id = %s", secure($_POST['node'], 'int')));
      }
      /* delete post */
      $user->delete_post($_POST['id'], false);
      break;

    case 'comment':
      // check admin|moderator permission
      admin_access('mods_posts_permission');
      // [BACKGROUND PROCESS]
      /* return async */
      return_json_async();
      /* delete report */
      if (isset($_POST['node']) && is_numeric($_POST['node'])) {
        $db->query(sprintf("DELETE FROM reports WHERE report_id = %s", secure($_POST['node'], 'int')));
      }
      /* delete comment */
      $user->delete_comment($_POST['id']);
      break;

    case 'blacklist_node':
      // check admin|moderator permission
      admin_access('mods_blacklist_permission');
      $db->query(sprintf("DELETE FROM blacklist WHERE node_id = %s", secure($_POST['id'], 'int')));
      break;

    case 'custom_field':
      // check admin|moderator permission
      admin_access('mods_customization_permission');
      $db->query(sprintf("DELETE FROM custom_fields WHERE field_id = %s", secure($_POST['id'], 'int')));
      $db->query(sprintf("DELETE FROM custom_fields_values WHERE field_id = %s", secure($_POST['id'], 'int')));
      break;

    case 'static_page':
      // check admin|moderator permission
      admin_access('mods_customization_permission');
      $db->query(sprintf("DELETE FROM static_pages WHERE page_id = %s", secure($_POST['id'], 'int')));
      break;

    case 'pattern':
      // check admin|moderator permission
      admin_access('mods_customization_permission');
      $db->query(sprintf("DELETE FROM posts_colored_patterns WHERE pattern_id = %s", secure($_POST['id'], 'int')));
      break;

    case 'widget':
      // check admin|moderator permission
      admin_access('mods_customization_permission');
      $db->query(sprintf("DELETE FROM widgets WHERE widget_id = %s", secure($_POST['id'], 'int')));
      break;

    case 'story':
      // check admin|moderator permission
      admin_access('mods_stories_permission');
      /* delete report */
      if (isset($_POST['node']) && is_numeric($_POST['node'])) {
        $db->query(sprintf("DELETE FROM reports WHERE report_id = %s", secure($_POST['node'], 'int')));
      }
      /* delete story */
      $get_story = $db->query(sprintf("SELECT * FROM stories WHERE story_id = %s", secure($_POST['id'], 'int')));
      if ($get_story->num_rows > 0) {
        $user->delete_story_data($get_story->fetch_assoc());
      }
      break;

    case 'story_music':
      // check admin|moderator permission
      admin_access('mods_stories_permission');
      $get_track = $db->query(sprintf("SELECT * FROM stories_music WHERE music_id = %s", secure($_POST['id'], 'int')));
      if ($get_track->num_rows > 0) {
        $track = $get_track->fetch_assoc();
        if ($track['provider'] == 'library') {
          delete_uploads_file($track['source']);
          if ($track['cover']) {
            delete_uploads_file($track['cover']);
          }
        }
        $db->query(sprintf("DELETE FROM stories_music WHERE music_id = %s", secure($_POST['id'], 'int')));
      }
      break;

    case 'sticker':
      // check admin|moderator permission
      admin_access('mods_customization_permission');
      $db->query(sprintf("DELETE FROM stickers WHERE sticker_id = %s", secure($_POST['id'], 'int')));
      break;

    case 'gift':
      // check admin|moderator permission
      admin_access('mods_customization_permission');
      $db->query(sprintf("DELETE FROM gifts WHERE gift_id = %s", secure($_POST['id'], 'int')));
      break;

    case 'announcement':
      // check admin|moderator permission
      admin_access('mods_reach_permission');
      $db->query(sprintf("DELETE FROM announcements WHERE announcement_id = %s", secure($_POST['id'], 'int')));
      break;

    case 'merit_category':
      // check admin|moderator permission
      admin_access('mods_merit_permission');
      $user->delete_category("merits_categories", $_POST['id']);
      break;

    case 'backup':
      // check admin|moderator permission
      if (!$user->_is_admin) {
        modal("MESSAGE", __("System Message"), __("You don't have the right permission to access this"));
      }
      $user->delete_backup($_POST['id']);
      break;

    default:
      _error(400);
      break;
  }

  // return & exist
  return_json();
} catch (Exception $e) {
  modal("ERROR", __("Error"), $e->getMessage());
}
