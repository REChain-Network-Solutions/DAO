<?php

/**
 * ajax -> admin -> permissions groups
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich - Handles - @sorydima @sorydev @durovshater @DmitrySoro90935 @tanechfund - also check https://dmitry.rechain.network for more information!
 */

// fetch bootstrap
require('../../../bootstrap.php');

// check AJAX Request
is_ajax();

// check admin|moderator permission
if (!$user->_is_admin) {
  modal("MESSAGE", __("System Message"), __("You don't have the right permission to access this"));
}

// check demo account
if ($user->_data['user_demo']) {
  modal("ERROR", __("Demo Restriction"), __("You can't do this with demo account"));
}

// handle permissions groups
try {

  switch ($_GET['do']) {
    case 'add':
      /* valid inputs */
      if (is_empty($_POST['title'])) {
        throw new Exception(__("Please enter a valid group name"));
      }
      /* prepare */
      $_POST['pages_permission'] = (isset($_POST['pages_permission'])) ? '1' : '0';
      $_POST['groups_permission'] = (isset($_POST['groups_permission'])) ? '1' : '0';
      $_POST['events_permission'] = (isset($_POST['events_permission'])) ? '1' : '0';
      $_POST['reels_permission'] = (isset($_POST['reels_permission'])) ? '1' : '0';
      $_POST['watch_permission'] = (isset($_POST['watch_permission'])) ? '1' : '0';
      $_POST['blogs_permission'] = (isset($_POST['blogs_permission'])) ? '1' : '0';
      $_POST['blogs_permission_read'] = (isset($_POST['blogs_permission_read'])) ? '1' : '0';
      $_POST['market_permission'] = (isset($_POST['market_permission'])) ? '1' : '0';
      $_POST['offers_permission'] = (isset($_POST['offers_permission'])) ? '1' : '0';
      $_POST['offers_permission_read'] = (isset($_POST['offers_permission_read'])) ? '1' : '0';
      $_POST['jobs_permission'] = (isset($_POST['jobs_permission'])) ? '1' : '0';
      $_POST['courses_permission'] = (isset($_POST['courses_permission'])) ? '1' : '0';
      $_POST['forums_permission'] = (isset($_POST['forums_permission'])) ? '1' : '0';
      $_POST['movies_permission'] = (isset($_POST['movies_permission'])) ? '1' : '0';
      $_POST['games_permission'] = (isset($_POST['games_permission'])) ? '1' : '0';
      $_POST['gifts_permission'] = (isset($_POST['gifts_permission'])) ? '1' : '0';
      $_POST['stories_permission'] = (isset($_POST['stories_permission'])) ? '1' : '0';
      $_POST['posts_permission'] = (isset($_POST['posts_permission'])) ? '1' : '0';
      $_POST['schedule_posts_permission'] = (isset($_POST['schedule_posts_permission'])) ? '1' : '0';
      $_POST['colored_posts_permission'] = (isset($_POST['colored_posts_permission'])) ? '1' : '0';
      $_POST['activity_posts_permission'] = (isset($_POST['activity_posts_permission'])) ? '1' : '0';
      $_POST['polls_posts_permission'] = (isset($_POST['polls_posts_permission'])) ? '1' : '0';
      $_POST['geolocation_posts_permission'] = (isset($_POST['geolocation_posts_permission'])) ? '1' : '0';
      $_POST['gif_posts_permission'] = (isset($_POST['gif_posts_permission'])) ? '1' : '0';
      $_POST['anonymous_posts_permission'] = (isset($_POST['anonymous_posts_permission'])) ? '1' : '0';
      $_POST['invitation_permission'] = (isset($_POST['invitation_permission'])) ? '1' : '0';
      $_POST['audio_call_permission'] = (isset($_POST['audio_call_permission'])) ? '1' : '0';
      $_POST['video_call_permission'] = (isset($_POST['video_call_permission'])) ? '1' : '0';
      $_POST['live_permission'] = (isset($_POST['live_permission'])) ? '1' : '0';
      $_POST['videos_upload_permission'] = (isset($_POST['videos_upload_permission'])) ? '1' : '0';
      $_POST['audios_upload_permission'] = (isset($_POST['audios_upload_permission'])) ? '1' : '0';
      $_POST['files_upload_permission'] = (isset($_POST['files_upload_permission'])) ? '1' : '0';
      $_POST['ads_permission'] = (isset($_POST['ads_permission'])) ? '1' : '0';
      $_POST['funding_permission'] = (isset($_POST['funding_permission'])) ? '1' : '0';
      $_POST['monetization_permission'] = (isset($_POST['monetization_permission'])) ? '1' : '0';
      $_POST['tips_permission'] = (isset($_POST['tips_permission'])) ? '1' : '0';
      $_POST['custom_affiliates_system'] = (isset($_POST['custom_affiliates_system'])) ? '1' : '0';
      $_POST['custom_points_system'] = (isset($_POST['custom_points_system'])) ? '1' : '0';
      /* insert */
      $db->query(sprintf(
        "INSERT INTO permissions_groups (
        permissions_group_title,
        pages_permission,
        groups_permission,
        events_permission,
        reels_permission,
        watch_permission,
        blogs_permission,
        blogs_permission_read,
        market_permission,
        offers_permission,
        offers_permission_read,
        jobs_permission,
        courses_permission,
        forums_permission,
        movies_permission,
        games_permission,
        gifts_permission,
        stories_permission,
        posts_permission,
        schedule_posts_permission,
        colored_posts_permission,
        activity_posts_permission,
        polls_posts_permission,
        geolocation_posts_permission,
        gif_posts_permission,
        anonymous_posts_permission,
        invitation_permission,
        audio_call_permission,
        video_call_permission,
        live_permission,
        videos_upload_permission,
        audios_upload_permission,
        files_upload_permission,
        ads_permission,
        funding_permission,
        monetization_permission,
        tips_permission,
        custom_affiliates_system,
        affiliates_per_user,
        affiliates_percentage,
        affiliates_per_user_2,
        affiliates_percentage_2,
        affiliates_per_user_3,
        affiliates_percentage_3,
        affiliates_per_user_4,
        affiliates_percentage_4,
        affiliates_per_user_5,
        affiliates_percentage_5,
        custom_points_system,
        points_per_currency
        ) VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)",
        secure($_POST['title']),
        secure($_POST['pages_permission'], 'int'),
        secure($_POST['groups_permission'], 'int'),
        secure($_POST['events_permission'], 'int'),
        secure($_POST['reels_permission'], 'int'),
        secure($_POST['watch_permission'], 'int'),
        secure($_POST['blogs_permission'], 'int'),
        secure($_POST['blogs_permission_read'], 'int'),
        secure($_POST['market_permission'], 'int'),
        secure($_POST['offers_permission'], 'int'),
        secure($_POST['offers_permission_read'], 'int'),
        secure($_POST['jobs_permission'], 'int'),
        secure($_POST['courses_permission'], 'int'),
        secure($_POST['forums_permission'], 'int'),
        secure($_POST['movies_permission'], 'int'),
        secure($_POST['games_permission'], 'int'),
        secure($_POST['gifts_permission'], 'int'),
        secure($_POST['stories_permission'], 'int'),
        secure($_POST['posts_permission'], 'int'),
        secure($_POST['schedule_posts_permission'], 'int'),
        secure($_POST['colored_posts_permission'], 'int'),
        secure($_POST['activity_posts_permission'], 'int'),
        secure($_POST['polls_posts_permission'], 'int'),
        secure($_POST['geolocation_posts_permission'], 'int'),
        secure($_POST['gif_posts_permission'], 'int'),
        secure($_POST['anonymous_posts_permission'], 'int'),
        secure($_POST['invitation_permission'], 'int'),
        secure($_POST['audio_call_permission'], 'int'),
        secure($_POST['video_call_permission'], 'int'),
        secure($_POST['live_permission'], 'int'),
        secure($_POST['videos_upload_permission'], 'int'),
        secure($_POST['audios_upload_permission'], 'int'),
        secure($_POST['files_upload_permission'], 'int'),
        secure($_POST['ads_permission'], 'int'),
        secure($_POST['funding_permission'], 'int'),
        secure($_POST['monetization_permission'], 'int'),
        secure($_POST['tips_permission'], 'int'),
        secure($_POST['custom_affiliates_system'], 'int'),
        secure($_POST['affiliates_per_user'], 'float'),
        secure($_POST['affiliates_percentage'], 'float'),
        secure($_POST['affiliates_per_user_2'], 'float'),
        secure($_POST['affiliates_percentage_2'], 'float'),
        secure($_POST['affiliates_per_user_3'], 'float'),
        secure($_POST['affiliates_percentage_3'], 'float'),
        secure($_POST['affiliates_per_user_4'], 'float'),
        secure($_POST['affiliates_percentage_4'], 'float'),
        secure($_POST['affiliates_per_user_5'], 'float'),
        secure($_POST['affiliates_percentage_5'], 'float'),
        secure($_POST['custom_points_system'], 'int'),
        secure($_POST['points_per_currency'], 'int')
      ));
      /* return */
      return_json(['callback' => 'window.location = "' . $system['system_url'] . '/' . $control_panel['url'] . '/permissions_groups";']);
      break;

    case 'edit':
      /* valid inputs */
      if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
        _error(400);
      }
      if (is_empty($_POST['title'])) {
        throw new Exception(__("Please enter a valid group name"));
      }
      if (($_GET['id'] == '1' && $_POST['title'] != 'Users Permissions') || ($_GET['id'] == '2' && $_POST['title'] != 'Verified Permissions')) {
        throw new Exception(__("You can't edit this permissions group title because it's a default group"));
      }
      /* prepare */
      $_POST['pages_permission'] = (isset($_POST['pages_permission'])) ? '1' : '0';
      $_POST['groups_permission'] = (isset($_POST['groups_permission'])) ? '1' : '0';
      $_POST['events_permission'] = (isset($_POST['events_permission'])) ? '1' : '0';
      $_POST['reels_permission'] = (isset($_POST['reels_permission'])) ? '1' : '0';
      $_POST['watch_permission'] = (isset($_POST['watch_permission'])) ? '1' : '0';
      $_POST['blogs_permission'] = (isset($_POST['blogs_permission'])) ? '1' : '0';
      $_POST['blogs_permission_read'] = (isset($_POST['blogs_permission_read'])) ? '1' : '0';
      $_POST['market_permission'] = (isset($_POST['market_permission'])) ? '1' : '0';
      $_POST['offers_permission'] = (isset($_POST['offers_permission'])) ? '1' : '0';
      $_POST['offers_permission_read'] = (isset($_POST['offers_permission_read'])) ? '1' : '0';
      $_POST['jobs_permission'] = (isset($_POST['jobs_permission'])) ? '1' : '0';
      $_POST['courses_permission'] = (isset($_POST['courses_permission'])) ? '1' : '0';
      $_POST['forums_permission'] = (isset($_POST['forums_permission'])) ? '1' : '0';
      $_POST['movies_permission'] = (isset($_POST['movies_permission'])) ? '1' : '0';
      $_POST['games_permission'] = (isset($_POST['games_permission'])) ? '1' : '0';
      $_POST['gifts_permission'] = (isset($_POST['gifts_permission'])) ? '1' : '0';
      $_POST['stories_permission'] = (isset($_POST['stories_permission'])) ? '1' : '0';
      $_POST['posts_permission'] = (isset($_POST['posts_permission'])) ? '1' : '0';
      $_POST['schedule_posts_permission'] = (isset($_POST['schedule_posts_permission'])) ? '1' : '0';
      $_POST['colored_posts_permission'] = (isset($_POST['colored_posts_permission'])) ? '1' : '0';
      $_POST['activity_posts_permission'] = (isset($_POST['activity_posts_permission'])) ? '1' : '0';
      $_POST['polls_posts_permission'] = (isset($_POST['polls_posts_permission'])) ? '1' : '0';
      $_POST['geolocation_posts_permission'] = (isset($_POST['geolocation_posts_permission'])) ? '1' : '0';
      $_POST['gif_posts_permission'] = (isset($_POST['gif_posts_permission'])) ? '1' : '0';
      $_POST['anonymous_posts_permission'] = (isset($_POST['anonymous_posts_permission'])) ? '1' : '0';
      $_POST['invitation_permission'] = (isset($_POST['invitation_permission'])) ? '1' : '0';
      $_POST['audio_call_permission'] = (isset($_POST['audio_call_permission'])) ? '1' : '0';
      $_POST['video_call_permission'] = (isset($_POST['video_call_permission'])) ? '1' : '0';
      $_POST['live_permission'] = (isset($_POST['live_permission'])) ? '1' : '0';
      $_POST['videos_upload_permission'] = (isset($_POST['videos_upload_permission'])) ? '1' : '0';
      $_POST['audios_upload_permission'] = (isset($_POST['audios_upload_permission'])) ? '1' : '0';
      $_POST['files_upload_permission'] = (isset($_POST['files_upload_permission'])) ? '1' : '0';
      $_POST['ads_permission'] = (isset($_POST['ads_permission'])) ? '1' : '0';
      $_POST['funding_permission'] = (isset($_POST['funding_permission'])) ? '1' : '0';
      $_POST['monetization_permission'] = (isset($_POST['monetization_permission'])) ? '1' : '0';
      $_POST['tips_permission'] = (isset($_POST['tips_permission'])) ? '1' : '0';
      $_POST['custom_affiliates_system'] = (isset($_POST['custom_affiliates_system'])) ? '1' : '0';
      $_POST['custom_points_system'] = (isset($_POST['custom_points_system'])) ? '1' : '0';
      /* update */
      $db->query(sprintf(
        "UPDATE permissions_groups SET
        permissions_group_title = %s,
        pages_permission = %s,
        groups_permission = %s,
        events_permission = %s,
        reels_permission = %s,
        watch_permission = %s,
        blogs_permission = %s,
        blogs_permission_read = %s,
        market_permission = %s,
        offers_permission = %s,
        offers_permission_read = %s,
        jobs_permission = %s,
        courses_permission = %s,
        forums_permission = %s,
        movies_permission = %s,
        games_permission = %s,
        gifts_permission = %s,
        stories_permission = %s,
        posts_permission = %s,
        schedule_posts_permission = %s,
        colored_posts_permission = %s,
        activity_posts_permission = %s,
        polls_posts_permission = %s,
        geolocation_posts_permission = %s,
        gif_posts_permission = %s,
        anonymous_posts_permission = %s,
        invitation_permission = %s,
        audio_call_permission = %s,
        video_call_permission = %s,
        live_permission = %s,
        videos_upload_permission = %s,
        audios_upload_permission = %s,
        files_upload_permission = %s,
        ads_permission = %s,
        funding_permission = %s,
        monetization_permission = %s,
        tips_permission = %s,
        custom_affiliates_system = %s,
        affiliates_per_user = %s,
        affiliates_percentage = %s,
        affiliates_per_user_2 = %s,
        affiliates_percentage_2 = %s,
        affiliates_per_user_3 = %s,
        affiliates_percentage_3 = %s,
        affiliates_per_user_4 = %s,
        affiliates_percentage_4 = %s,
        affiliates_per_user_5 = %s,
        affiliates_percentage_5 = %s,
        custom_points_system = %s,
        points_per_currency = %s
        WHERE permissions_group_id = %s",
        secure($_POST['title']),
        secure($_POST['pages_permission'], 'int'),
        secure($_POST['groups_permission'], 'int'),
        secure($_POST['events_permission'], 'int'),
        secure($_POST['reels_permission'], 'int'),
        secure($_POST['watch_permission'], 'int'),
        secure($_POST['blogs_permission'], 'int'),
        secure($_POST['blogs_permission_read'], 'int'),
        secure($_POST['market_permission'], 'int'),
        secure($_POST['offers_permission'], 'int'),
        secure($_POST['offers_permission_read'], 'int'),
        secure($_POST['jobs_permission'], 'int'),
        secure($_POST['courses_permission'], 'int'),
        secure($_POST['forums_permission'], 'int'),
        secure($_POST['movies_permission'], 'int'),
        secure($_POST['games_permission'], 'int'),
        secure($_POST['gifts_permission'], 'int'),
        secure($_POST['stories_permission'], 'int'),
        secure($_POST['posts_permission'], 'int'),
        secure($_POST['schedule_posts_permission'], 'int'),
        secure($_POST['colored_posts_permission'], 'int'),
        secure($_POST['activity_posts_permission'], 'int'),
        secure($_POST['polls_posts_permission'], 'int'),
        secure($_POST['geolocation_posts_permission'], 'int'),
        secure($_POST['gif_posts_permission'], 'int'),
        secure($_POST['anonymous_posts_permission'], 'int'),
        secure($_POST['invitation_permission'], 'int'),
        secure($_POST['audio_call_permission'], 'int'),
        secure($_POST['video_call_permission'], 'int'),
        secure($_POST['live_permission'], 'int'),
        secure($_POST['videos_upload_permission'], 'int'),
        secure($_POST['audios_upload_permission'], 'int '),
        secure($_POST['files_upload_permission'], 'int'),
        secure($_POST['ads_permission'], 'int'),
        secure($_POST['funding_permission'], 'int'),
        secure($_POST['monetization_permission'], 'int'),
        secure($_POST['tips_permission'], 'int'),
        secure($_POST['custom_affiliates_system'], 'int'),
        secure($_POST['affiliates_per_user'], 'float'),
        secure($_POST['affiliates_percentage'], 'float'),
        secure($_POST['affiliates_per_user_2'], 'float'),
        secure($_POST['affiliates_percentage_2'], 'float'),
        secure($_POST['affiliates_per_user_3'], 'float'),
        secure($_POST['affiliates_percentage_3'], 'float'),
        secure($_POST['affiliates_per_user_4'], 'float'),
        secure($_POST['affiliates_percentage_4'], 'float'),
        secure($_POST['affiliates_per_user_5'], 'float'),
        secure($_POST['affiliates_percentage_5'], 'float'),
        secure($_POST['custom_points_system'], 'int'),
        secure($_POST['points_per_currency'], 'int'),
        secure($_GET['id'], 'int')
      ));
      /* return */
      return_json(['success' => true, 'message' => __("Permission group have been updated")]);
      break;

    case 'edit_mods':
      /* prepare */
      $_POST['mods_users_permission'] = (isset($_POST['mods_users_permission'])) ? '1' : '0';
      $_POST['mods_posts_permission'] = (isset($_POST['mods_posts_permission'])) ? '1' : '0';
      $_POST['mods_pages_permission'] = (isset($_POST['mods_pages_permission'])) ? '1' : '0';
      $_POST['mods_groups_permission'] = (isset($_POST['mods_groups_permission'])) ? '1' : '0';
      $_POST['mods_events_permission'] = (isset($_POST['mods_events_permission'])) ? '1' : '0';
      $_POST['mods_blogs_permission'] = (isset($_POST['mods_blogs_permission'])) ? '1' : '0';
      $_POST['mods_offers_permission'] = (isset($_POST['mods_offers_permission'])) ? '1' : '0';
      $_POST['mods_jobs_permission'] = (isset($_POST['mods_jobs_permission'])) ? '1' : '0';
      $_POST['mods_courses_permission'] = (isset($_POST['mods_courses_permission'])) ? '1' : '0';
      $_POST['mods_forums_permission'] = (isset($_POST['mods_forums_permission'])) ? '1' : '0';
      $_POST['mods_movies_permission'] = (isset($_POST['mods_movies_permission'])) ? '1' : '0';
      $_POST['mods_games_permission'] = (isset($_POST['mods_games_permission'])) ? '1' : '0';
      $_POST['mods_ads_permission'] = (isset($_POST['mods_ads_permission'])) ? '1' : '0';
      $_POST['mods_wallet_permission'] = (isset($_POST['mods_wallet_permission'])) ? '1' : '0';
      $_POST['mods_pro_permission'] = (isset($_POST['mods_pro_permission'])) ? '1' : '0';
      $_POST['mods_affiliates_permission'] = (isset($_POST['mods_affiliates_permission'])) ? '1' : '0';
      $_POST['mods_points_permission'] = (isset($_POST['mods_points_permission'])) ? '1' : '0';
      $_POST['mods_marketplace_permission'] = (isset($_POST['mods_marketplace_permission'])) ? '1' : '0';
      $_POST['mods_funding_permission'] = (isset($_POST['mods_funding_permission'])) ? '1' : '0';
      $_POST['mods_monetization_permission'] = (isset($_POST['mods_monetization_permission'])) ? '1' : '0';
      $_POST['mods_tips_permission'] = (isset($_POST['mods_tips_permission'])) ? '1' : '0';
      $_POST['mods_payments_permission'] = (isset($_POST['mods_payments_permission'])) ? '1' : '0';
      $_POST['mods_developers_permission'] = (isset($_POST['mods_developers_permission'])) ? '1' : '0';
      $_POST['mods_reports_permission'] = (isset($_POST['mods_reports_permission'])) ? '1' : '0';
      $_POST['mods_blacklist_permission'] = (isset($_POST['mods_blacklist_permission'])) ? '1' : '0';
      $_POST['mods_verifications_permission'] = (isset($_POST['mods_verifications_permission'])) ? '1' : '0';
      $_POST['mods_customization_permission'] = (isset($_POST['mods_customization_permission'])) ? '1' : '0';
      $_POST['mods_reach_permission'] = (isset($_POST['mods_reach_permission'])) ? '1' : '0';
      /* update */
      update_system_options([
        'mods_users_permission' => secure($_POST['mods_users_permission']),
        'mods_posts_permission' => secure($_POST['mods_posts_permission']),
        'mods_pages_permission' => secure($_POST['mods_pages_permission']),
        'mods_groups_permission' => secure($_POST['mods_groups_permission']),
        'mods_events_permission' => secure($_POST['mods_events_permission']),
        'mods_blogs_permission' => secure($_POST['mods_blogs_permission']),
        'mods_offers_permission' => secure($_POST['mods_offers_permission']),
        'mods_jobs_permission' => secure($_POST['mods_jobs_permission']),
        'mods_courses_permission' => secure($_POST['mods_courses_permission']),
        'mods_forums_permission' => secure($_POST['mods_forums_permission']),
        'mods_movies_permission' => secure($_POST['mods_movies_permission']),
        'mods_games_permission' => secure($_POST['mods_games_permission']),
        'mods_ads_permission' => secure($_POST['mods_ads_permission']),
        'mods_wallet_permission' => secure($_POST['mods_wallet_permission']),
        'mods_pro_permission' => secure($_POST['mods_pro_permission']),
        'mods_affiliates_permission' => secure($_POST['mods_affiliates_permission']),
        'mods_points_permission' => secure($_POST['mods_points_permission']),
        'mods_marketplace_permission' => secure($_POST['mods_marketplace_permission']),
        'mods_funding_permission' => secure($_POST['mods_funding_permission']),
        'mods_monetization_permission' => secure($_POST['mods_monetization_permission']),
        'mods_tips_permission' => secure($_POST['mods_tips_permission']),
        'mods_payments_permission' => secure($_POST['mods_payments_permission']),
        'mods_developers_permission' => secure($_POST['mods_developers_permission']),
        'mods_reports_permission' => secure($_POST['mods_reports_permission']),
        'mods_blacklist_permission' => secure($_POST['mods_blacklist_permission']),
        'mods_verifications_permission' => secure($_POST['mods_verifications_permission']),
        'mods_customization_permission' => secure($_POST['mods_customization_permission']),
        'mods_reach_permission' => secure($_POST['mods_reach_permission'])
      ]);
      /* return */
      return_json(['success' => true, 'message' => __("Permission group have been updated")]);
      break;

    default:
      _error(400);
      break;
  }
} catch (Exception $e) {
  return_json(['error' => true, 'message' => $e->getMessage()]);
}
