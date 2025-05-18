<?php

/**
 * ajax -> admin -> settings
 * 
 * @package delus
 * @author Dmitry Olegovich Sorokin - @sorydima , @sorydev , @durovshater Handles.
 */

// fetch bootstrap
require('../../../bootstrap.php');

// check AJAX Request
is_ajax();

// check admin|moderator permission
if (!$user->_is_admin && !in_array($_GET['edit'], ['wallet', 'affiliates', 'points', 'market', 'funding', 'tips'])) {
  modal("MESSAGE", __("System Message"), __("You don't have the right permission to access this"));
}
if ($_GET['edit'] == 'wallet' && !$user->_is_admin && ($user->_is_moderator && !$system['mods_wallet_permission'])) {
  modal("MESSAGE", __("System Message"), __("You don't have the right permission to access this"));
}
if ($_GET['edit'] == 'affiliates' && !$user->_is_admin && ($user->_is_moderator && !$system['mods_affiliates_permission'])) {
  modal("MESSAGE", __("System Message"), __("You don't have the right permission to access this"));
}
if ($_GET['edit'] == 'points' && !$user->_is_admin && ($user->_is_moderator && !$system['mods_points_permission'])) {
  modal("MESSAGE", __("System Message"), __("You don't have the right permission to access this"));
}
if ($_GET['edit'] == 'market' && !$user->_is_admin && ($user->_is_moderator && !$system['mods_market_permission'])) {
  modal("MESSAGE", __("System Message"), __("You don't have the right permission to access this"));
}
if ($_GET['edit'] == 'funding' && !$user->_is_admin && ($user->_is_moderator && !$system['mods_funding_permission'])) {
  modal("MESSAGE", __("System Message"), __("You don't have the right permission to access this"));
}
if ($_GET['edit'] == 'tips' && !$user->_is_admin && ($user->_is_moderator && !$system['mods_tips_permission'])) {
  modal("MESSAGE", __("System Message"), __("You don't have the right permission to access this"));
}

// check demo account
if ($user->_data['user_demo']) {
  modal("ERROR", __("Demo Restriction"), __("You can't do this with demo account"));
}

// handle settings
try {

  switch ($_GET['edit']) {
    case 'general':
      /* prepare */
      $_POST['system_live'] = (isset($_POST['system_live'])) ? '1' : '0';
      /* update */
      update_system_options([
        'system_live' => secure($_POST['system_live']),
        'system_message' => secure($_POST['system_message']),
        'system_email' => secure($_POST['system_email']),
        'system_datetime_format' => secure($_POST['system_datetime_format']),
        'system_distance' => secure($_POST['system_distance'])
      ]);

      /* remove any default currency */
      $db->query("UPDATE system_currencies SET system_currencies.default = '0'");
      /* set selected currency as default */
      $db->query(sprintf("UPDATE system_currencies SET 
						system_currencies.default = '1' WHERE currency_id = %s", secure($_POST['system_currency'], 'int')));
      break;

    case 'seo':
      /* prepare */
      $_POST['system_public'] = (isset($_POST['system_public'])) ? '1' : '0';
      $_POST['newsfeed_public'] = (isset($_POST['newsfeed_public'])) ? '1' : '0';
      if ($_POST['newsfeed_public']) {
        /* if newsfeed_public enabled enfore system to be public */
        $_POST['system_public'] = 1;
      }
      $_POST['directory_enabled'] = (isset($_POST['directory_enabled'])) ? '1' : '0';
      /* update */
      update_system_options([
        'system_public' => secure($_POST['system_public']),
        'newsfeed_public' => secure($_POST['newsfeed_public']),
        'directory_enabled' => secure($_POST['directory_enabled']),
        'system_title' => secure($_POST['system_title']),
        'system_description' => secure($_POST['system_description']),
        'system_keywords' => secure($_POST['system_keywords']),
        'system_description_directory' => secure($_POST['system_description_directory']),
        'system_description_pages' => secure($_POST['system_description_pages']),
        'system_description_groups' => secure($_POST['system_description_groups']),
        'system_description_events' => secure($_POST['system_description_events']),
        'system_description_blogs' => secure($_POST['system_description_blogs']),
        'system_description_marketplace' => secure($_POST['system_description_marketplace']),
        'system_description_funding' => secure($_POST['system_description_funding']),
        'system_description_offers' => secure($_POST['system_description_offers']),
        'system_description_jobs' => secure($_POST['system_description_jobs']),
        'system_description_courses' => secure($_POST['system_description_courses']),
        'system_description_forums' => secure($_POST['system_description_forums']),
        'system_description_movies' => secure($_POST['system_description_movies']),
        'system_description_games' => secure($_POST['system_description_games'])
      ]);
      break;

    case 'features':
      /* prepare */
      $_POST['location_finder_enabled'] = (isset($_POST['location_finder_enabled'])) ? '1' : '0';
      $_POST['auto_language_detection'] = (isset($_POST['auto_language_detection'])) ? '1' : '0';
      $_POST['contact_enabled'] = (isset($_POST['contact_enabled'])) ? '1' : '0';
      $_POST['daytime_msg_enabled'] = (isset($_POST['daytime_msg_enabled'])) ? '1' : '0';
      $_POST['pokes_enabled'] = (isset($_POST['pokes_enabled'])) ? '1' : '0';
      $_POST['gifts_enabled'] = (isset($_POST['gifts_enabled'])) ? '1' : '0';
      $_POST['cookie_consent_enabled'] = (isset($_POST['cookie_consent_enabled'])) ? '1' : '0';
      $_POST['adblock_detector_enabled'] = (isset($_POST['adblock_detector_enabled'])) ? '1' : '0';
      /* update */
      update_system_options([
        'location_finder_enabled' => secure($_POST['location_finder_enabled']),
        'auto_language_detection' => secure($_POST['auto_language_detection']),
        'contact_enabled' => secure($_POST['contact_enabled']),
        'daytime_msg_enabled' => secure($_POST['daytime_msg_enabled']),
        'system_morning_message' => secure($_POST['system_morning_message']),
        'system_afternoon_message' => secure($_POST['system_afternoon_message']),
        'system_evening_message' => secure($_POST['system_evening_message']),
        'pokes_enabled' => secure($_POST['pokes_enabled']),
        'gifts_enabled' => secure($_POST['gifts_enabled']),
        'cookie_consent_enabled' => secure($_POST['cookie_consent_enabled']),
        'adblock_detector_enabled' => secure($_POST['adblock_detector_enabled']),
      ]);
      break;

    case 'modules':
      /* prepare */
      $_POST['pages_enabled'] = (isset($_POST['pages_enabled'])) ? '1' : '0';
      $_POST['pages_reviews_enabled'] = (isset($_POST['pages_reviews_enabled'])) ? '1' : '0';
      $_POST['pages_reviews_replacement_enabled'] = (isset($_POST['pages_reviews_replacement_enabled'])) ? '1' : '0';
      $_POST['pages_pbid_enabled'] = (isset($_POST['pages_pbid_enabled'])) ? '1' : '0';
      $_POST['groups_enabled'] = (isset($_POST['groups_enabled'])) ? '1' : '0';
      $_POST['groups_reviews_enabled'] = (isset($_POST['groups_reviews_enabled'])) ? '1' : '0';
      $_POST['groups_reviews_replacement_enabled'] = (isset($_POST['groups_reviews_replacement_enabled'])) ? '1' : '0';
      $_POST['events_enabled'] = (isset($_POST['events_enabled'])) ? '1' : '0';
      $_POST['pages_events_enabled'] = (isset($_POST['pages_events_enabled'])) ? '1' : '0';
      $_POST['events_reviews_enabled'] = (isset($_POST['events_reviews_enabled'])) ? '1' : '0';
      $_POST['events_reviews_replacement_enabled'] = (isset($_POST['events_reviews_replacement_enabled'])) ? '1' : '0';
      $_POST['blogs_enabled'] = (isset($_POST['blogs_enabled'])) ? '1' : '0';
      $_POST['reels_enabled'] = (isset($_POST['reels_enabled'])) ? '1' : '0';
      $_POST['watch_enabled'] = (isset($_POST['watch_enabled'])) ? '1' : '0';
      $_POST['offers_enabled'] = (isset($_POST['offers_enabled'])) ? '1' : '0';
      $_POST['jobs_enabled'] = (isset($_POST['jobs_enabled'])) ? '1' : '0';
      $_POST['courses_enabled'] = (isset($_POST['courses_enabled'])) ? '1' : '0';
      $_POST['forums_enabled'] = (isset($_POST['forums_enabled'])) ? '1' : '0';
      $_POST['forums_online_enabled'] = (isset($_POST['forums_online_enabled'])) ? '1' : '0';
      $_POST['forums_statistics_enabled'] = (isset($_POST['forums_statistics_enabled'])) ? '1' : '0';
      $_POST['movies_enabled'] = (isset($_POST['movies_enabled'])) ? '1' : '0';
      $_POST['games_enabled'] = (isset($_POST['games_enabled'])) ? '1' : '0';
      /* update */
      update_system_options([
        'pages_enabled' => secure($_POST['pages_enabled']),
        'pages_reviews_enabled' => secure($_POST['pages_reviews_enabled']),
        'pages_reviews_replacement_enabled' => secure($_POST['pages_reviews_replacement_enabled']),
        'pages_pbid_enabled' => secure($_POST['pages_pbid_enabled']),
        'groups_enabled' => secure($_POST['groups_enabled']),
        'groups_reviews_enabled' => secure($_POST['groups_reviews_enabled']),
        'groups_reviews_replacement_enabled' => secure($_POST['groups_reviews_replacement_enabled']),
        'events_enabled' => secure($_POST['events_enabled']),
        'pages_events_enabled' => secure($_POST['pages_events_enabled']),
        'events_reviews_enabled' => secure($_POST['events_reviews_enabled']),
        'events_reviews_replacement_enabled' => secure($_POST['events_reviews_replacement_enabled']),
        'blogs_enabled' => secure($_POST['blogs_enabled']),
        'reels_enabled' => secure($_POST['reels_enabled']),
        'watch_enabled' => secure($_POST['watch_enabled']),
        'offers_enabled' => secure($_POST['offers_enabled']),
        'jobs_enabled' => secure($_POST['jobs_enabled']),
        'courses_enabled' => secure($_POST['courses_enabled']),
        'forums_enabled' => secure($_POST['forums_enabled']),
        'forums_online_enabled' => secure($_POST['forums_online_enabled']),
        'forums_statistics_enabled' => secure($_POST['forums_statistics_enabled']),
        'movies_enabled' => secure($_POST['movies_enabled']),
        'games_enabled' => secure($_POST['games_enabled']),
      ]);
      break;

    case 'posts':
      /* prepare */
      $_POST['stories_enabled'] = (isset($_POST['stories_enabled'])) ? '1' : '0';
      $_POST['posts_schedule_enabled'] = (isset($_POST['posts_schedule_enabled'])) ? '1' : '0';
      $_POST['posts_approval_enabled'] = (isset($_POST['posts_approval_enabled'])) ? '1' : '0';
      $_POST['newsfeed_merge_enabled'] = (isset($_POST['newsfeed_merge_enabled'])) ? '1' : '0';
      $_POST['newsfeed_caching_enabled'] = (isset($_POST['newsfeed_caching_enabled'])) ? '1' : '0';
      $_POST['smooth_infinite_scroll'] = (isset($_POST['smooth_infinite_scroll'])) ? '1' : '0';
      $_POST['newsfeed_location_filter_enabled'] = (isset($_POST['newsfeed_location_filter_enabled'])) ? '1' : '0';
      $_POST['popular_posts_enabled'] = (isset($_POST['popular_posts_enabled'])) ? '1' : '0';
      $_POST['discover_posts_enabled'] = (isset($_POST['discover_posts_enabled'])) ? '1' : '0';
      $_POST['memories_enabled'] = (isset($_POST['memories_enabled'])) ? '1' : '0';
      $_POST['wall_posts_enabled'] = (isset($_POST['wall_posts_enabled'])) ? '1' : '0';
      $_POST['colored_posts_enabled'] = (isset($_POST['colored_posts_enabled'])) ? '1' : '0';
      $_POST['activity_posts_enabled'] = (isset($_POST['activity_posts_enabled'])) ? '1' : '0';
      $_POST['voice_notes_posts_enabled'] = (isset($_POST['voice_notes_posts_enabled'])) ? '1' : '0';
      $_POST['voice_notes_comments_enabled'] = (isset($_POST['voice_notes_comments_enabled'])) ? '1' : '0';
      $_POST['polls_enabled'] = (isset($_POST['polls_enabled'])) ? '1' : '0';
      $_POST['geolocation_enabled'] = (isset($_POST['geolocation_enabled'])) ? '1' : '0';
      $_POST['gif_enabled'] = (isset($_POST['gif_enabled'])) ? '1' : '0';
      $_POST['profile_posts_updates_disabled'] = (isset($_POST['profile_posts_updates_disabled'])) ? '1' : '0';
      $_POST['post_translation_enabled'] = (isset($_POST['post_translation_enabled'])) ? '1' : '0';
      $_POST['smart_yt_player'] = (isset($_POST['smart_yt_player'])) ? '1' : '0';
      $_POST['disable_yt_player'] = (isset($_POST['disable_yt_player'])) ? '1' : '0';
      $_POST['social_share_enabled'] = (isset($_POST['social_share_enabled'])) ? '1' : '0';
      $_POST['anonymous_mode'] = (isset($_POST['anonymous_mode'])) ? '1' : '0';
      $_POST['adult_mode'] = (isset($_POST['adult_mode'])) ? '1' : '0';
      $_POST['posts_online_status'] = (isset($_POST['posts_online_status'])) ? '1' : '0';
      $_POST['desktop_infinite_scroll'] = (isset($_POST['desktop_infinite_scroll'])) ? '1' : '0';
      $_POST['mobile_infinite_scroll'] = (isset($_POST['mobile_infinite_scroll'])) ? '1' : '0';
      $_POST['auto_play_videos'] = (isset($_POST['auto_play_videos'])) ? '1' : '0';
      $_POST['fluid_videos_enabled'] = (isset($_POST['fluid_videos_enabled'])) ? '1' : '0';
      $_POST['posts_views_enabled'] = (isset($_POST['posts_views_enabled'])) ? '1' : '0';
      $_POST['posts_reviews_enabled'] = (isset($_POST['posts_reviews_enabled'])) ? '1' : '0';
      $_POST['posts_reviews_replacement_enabled'] = (isset($_POST['posts_reviews_replacement_enabled'])) ? '1' : '0';
      $_POST['trending_hashtags_enabled'] = (isset($_POST['trending_hashtags_enabled'])) ? '1' : '0';
      $_POST['download_images_disabled'] = (isset($_POST['download_images_disabled'])) ? '1' : '0';
      $_POST['right_click_disabled'] = (isset($_POST['right_click_disabled'])) ? '1' : '0';
      /* update */
      update_system_options([
        'stories_enabled' => secure($_POST['stories_enabled']),
        'stories_duration' => secure($_POST['stories_duration']),
        'posts_schedule_enabled' => secure($_POST['posts_schedule_enabled']),
        'posts_approval_enabled' => secure($_POST['posts_approval_enabled']),
        'posts_approval_limit' => secure($_POST['posts_approval_limit']),
        'newsfeed_source' => secure($_POST['newsfeed_source']),
        'newsfeed_merge_enabled' => secure($_POST['newsfeed_merge_enabled']),
        'merge_recent_results' => secure($_POST['merge_recent_results']),
        'merge_popular_results' => secure($_POST['merge_popular_results']),
        'merge_discover_results' => secure($_POST['merge_discover_results']),
        'newsfeed_caching_enabled' => secure($_POST['newsfeed_caching_enabled']),
        'smooth_infinite_scroll' => secure($_POST['smooth_infinite_scroll']),
        'newsfeed_location_filter_enabled' => secure($_POST['newsfeed_location_filter_enabled']),
        'popular_posts_enabled' => secure($_POST['popular_posts_enabled']),
        'popular_posts_interval' => secure($_POST['popular_posts_interval']),
        'discover_posts_enabled' => secure($_POST['discover_posts_enabled']),
        'memories_enabled' => secure($_POST['memories_enabled']),
        'wall_posts_enabled' => secure($_POST['wall_posts_enabled']),
        'colored_posts_enabled' => secure($_POST['colored_posts_enabled']),
        'activity_posts_enabled' => secure($_POST['activity_posts_enabled']),
        'voice_notes_posts_enabled' => secure($_POST['voice_notes_posts_enabled']),
        'voice_notes_comments_enabled' => secure($_POST['voice_notes_comments_enabled']),
        'voice_notes_durtaion' => secure($_POST['voice_notes_durtaion']),
        'voice_notes_encoding' => secure($_POST['voice_notes_encoding']),
        'polls_enabled' => secure($_POST['polls_enabled']),
        'geolocation_enabled' => secure($_POST['geolocation_enabled']),
        'geolocation_key' => secure($_POST['geolocation_key']),
        'gif_enabled' => secure($_POST['gif_enabled']),
        'giphy_key' => secure($_POST['giphy_key']),
        'profile_posts_updates_disabled' => secure($_POST['profile_posts_updates_disabled']),
        'post_translation_enabled' => secure($_POST['post_translation_enabled']),
        'google_translation_key' => secure($_POST['google_translation_key']),
        'yandex_key' => secure($_POST['yandex_key']),
        'smart_yt_player' => secure($_POST['smart_yt_player']),
        'disable_yt_player' => secure($_POST['disable_yt_player']),
        'social_share_enabled' => secure($_POST['social_share_enabled']),
        'max_post_length' => secure($_POST['max_post_length'], 'int'),
        'max_comment_length' => secure($_POST['max_comment_length'], 'int'),
        'max_posts_hour' => secure($_POST['max_posts_hour'], 'int'),
        'max_comments_hour' => secure($_POST['max_comments_hour'], 'int'),
        'default_privacy' => secure($_POST['default_privacy']),
        'anonymous_mode' => secure($_POST['anonymous_mode']),
        'adult_mode' => secure($_POST['adult_mode']),
        'posts_online_status' => secure($_POST['posts_online_status']),
        'desktop_infinite_scroll' => secure($_POST['desktop_infinite_scroll']),
        'mobile_infinite_scroll' => secure($_POST['mobile_infinite_scroll']),
        'auto_play_videos' => secure($_POST['auto_play_videos']),
        'fluid_videos_enabled' => secure($_POST['fluid_videos_enabled']),
        'posts_views_enabled' => secure($_POST['posts_views_enabled']),
        'posts_views_type' => secure($_POST['posts_views_type']),
        'posts_reviews_enabled' => secure($_POST['posts_reviews_enabled']),
        'posts_reviews_replacement_enabled' => secure($_POST['posts_reviews_replacement_enabled']),
        'trending_hashtags_enabled' => secure($_POST['trending_hashtags_enabled']),
        'trending_hashtags_interval' => secure($_POST['trending_hashtags_interval']),
        'trending_hashtags_limit' => secure($_POST['trending_hashtags_limit'], 'int'),
        'download_images_disabled' => secure($_POST['download_images_disabled'], 'int'),
        'right_click_disabled' => secure($_POST['right_click_disabled'], 'int'),
      ]);
      /* clear posts_cache if newsfeed caching disabled */
      $db->query("DELETE FROM posts_cache");
      break;

    case 'registration':
      /* prepare */
      $_POST['registration_enabled'] = (isset($_POST['registration_enabled'])) ? '1' : '0';
      $_POST['select_user_group_enabled'] = (isset($_POST['select_user_group_enabled'])) ? '1' : '0';
      $_POST['show_user_group_enabled'] = (isset($_POST['show_user_group_enabled'])) ? '1' : '0';
      $_POST['invitation_enabled'] = (isset($_POST['invitation_enabled'])) ? '1' : '0';
      $_POST['activation_enabled'] = (isset($_POST['activation_enabled'])) ? '1' : '0';
      $_POST['activation_required'] = (isset($_POST['activation_required'])) ? '1' : '0';
      $_POST['users_approval_enabled'] = (isset($_POST['users_approval_enabled'])) ? '1' : '0';
      $_POST['whitelist_enabled'] = (isset($_POST['whitelist_enabled'])) ? '1' : '0';
      $_POST['age_restriction'] = (isset($_POST['age_restriction'])) ? '1' : '0';
      $_POST['getting_started'] = (isset($_POST['getting_started'])) ? '1' : '0';
      $_POST['getting_started_profile_image_required'] = (isset($_POST['getting_started_profile_image_required'])) ? '1' : '0';
      $_POST['getting_started_location_required'] = (isset($_POST['getting_started_location_required'])) ? '1' : '0';
      $_POST['getting_started_work_required'] = (isset($_POST['getting_started_work_required'])) ? '1' : '0';
      $_POST['getting_started_education_required'] = (isset($_POST['getting_started_education_required'])) ? '1' : '0';
      $_POST['newsletter_consent'] = (isset($_POST['newsletter_consent'])) ? '1' : '0';
      /* update */
      update_system_options([
        'registration_enabled' => secure($_POST['registration_enabled']),
        'select_user_group_enabled' => secure($_POST['select_user_group_enabled']),
        'show_user_group_enabled' => secure($_POST['show_user_group_enabled']),
        'default_custom_user_group' => secure($_POST['default_custom_user_group'], 'int'),
        'registration_type' => secure($_POST['registration_type']),
        'invitation_enabled' => secure($_POST['invitation_enabled']),
        'invitation_user_limit' => secure($_POST['invitation_user_limit'], 'int'),
        'invitation_expire_period' => secure($_POST['invitation_expire_period']),
        'invitation_send_method' => secure($_POST['invitation_send_method']),
        'activation_enabled' => secure($_POST['activation_enabled']),
        'activation_required' => secure($_POST['activation_required']),
        'activation_type' => secure($_POST['activation_type']),
        'users_approval_enabled' => secure($_POST['users_approval_enabled']),
        'whitelist_enabled' => secure($_POST['whitelist_enabled']),
        'whitelist_providers' => secure($_POST['whitelist_providers']),
        'age_restriction' => secure($_POST['age_restriction']),
        'minimum_age' => secure($_POST['minimum_age'], 'int'),
        'getting_started' => secure($_POST['getting_started']),
        'getting_started_profile_image_required' => secure($_POST['getting_started_profile_image_required']),
        'getting_started_location_required' => secure($_POST['getting_started_location_required']),
        'getting_started_work_required' => secure($_POST['getting_started_work_required']),
        'getting_started_education_required' => secure($_POST['getting_started_education_required']),
        'newsletter_consent' => secure($_POST['newsletter_consent']),
        'max_accounts' => secure($_POST['max_accounts'], 'int'),
        'name_min_length' => secure($_POST['name_min_length'], 'int')
      ]);
      break;

    case 'social_login':
      /* prepare */
      $_POST['social_login_enabled'] = (isset($_POST['social_login_enabled'])) ? '1' : '0';
      $_POST['facebook_login_enabled'] = (isset($_POST['facebook_login_enabled'])) ? '1' : '0';
      $_POST['google_login_enabled'] = (isset($_POST['google_login_enabled'])) ? '1' : '0';
      $_POST['twitter_login_enabled'] = (isset($_POST['twitter_login_enabled'])) ? '1' : '0';
      $_POST['linkedin_login_enabled'] = (isset($_POST['linkedin_login_enabled'])) ? '1' : '0';
      $_POST['vkontakte_login_enabled'] = (isset($_POST['vkontakte_login_enabled'])) ? '1' : '0';
      $_POST['wordpress_login_enabled'] = (isset($_POST['wordpress_login_enabled'])) ? '1' : '0';
      $_POST['delus_login_enabled'] = (isset($_POST['delus_login_enabled'])) ? '1' : '0';
      /* update */
      update_system_options([
        'social_login_enabled' => secure($_POST['social_login_enabled']),
        'facebook_login_enabled' => secure($_POST['facebook_login_enabled']),
        'facebook_appid' => secure($_POST['facebook_appid']),
        'facebook_secret' => secure($_POST['facebook_secret']),
        'google_login_enabled' => secure($_POST['google_login_enabled']),
        'google_appid' => secure($_POST['google_appid']),
        'google_secret' => secure($_POST['google_secret']),
        'twitter_login_enabled' => secure($_POST['twitter_login_enabled']),
        'twitter_appid' => secure($_POST['twitter_appid']),
        'twitter_secret' => secure($_POST['twitter_secret']),
        'linkedin_login_enabled' => secure($_POST['linkedin_login_enabled']),
        'linkedin_appid' => secure($_POST['linkedin_appid']),
        'linkedin_secret' => secure($_POST['linkedin_secret']),
        'vkontakte_login_enabled' => secure($_POST['vkontakte_login_enabled']),
        'vkontakte_appid' => secure($_POST['vkontakte_appid']),
        'vkontakte_secret' => secure($_POST['vkontakte_secret']),
        'wordpress_login_enabled' => secure($_POST['wordpress_login_enabled']),
        'wordpress_appid' => secure($_POST['wordpress_appid']),
        'wordpress_secret' => secure($_POST['wordpress_secret']),
        'delus_login_enabled' => secure($_POST['delus_login_enabled']),
        'delus_appid' => secure($_POST['delus_appid']),
        'delus_secret' => secure($_POST['delus_secret']),
        'delus_app_domain' => secure($_POST['delus_app_domain']),
        'delus_app_name' => secure($_POST['delus_app_name']),
        'delus_app_icon' => secure($_POST['delus_app_icon'])
      ]);
      break;

    case 'accounts':
      /* prepare */
      $_POST['friends_enabled'] = (isset($_POST['friends_enabled'])) ? '1' : '0';
      $_POST['disable_declined_friendrequest'] = (isset($_POST['disable_declined_friendrequest'])) ? '1' : '0';
      $_POST['switch_accounts_enabled'] = (isset($_POST['switch_accounts_enabled'])) ? '1' : '0';
      $_POST['genders_disabled'] = (isset($_POST['genders_disabled'])) ? '1' : '0';
      $_POST['show_usernames_enabled'] = (isset($_POST['show_usernames_enabled'])) ? '1' : '0';
      $_POST['disable_username_changes'] = (isset($_POST['disable_username_changes'])) ? '1' : '0';
      $_POST['special_characters_enabled'] = (isset($_POST['special_characters_enabled'])) ? '1' : '0';
      $_POST['delete_accounts_enabled'] = (isset($_POST['delete_accounts_enabled'])) ? '1' : '0';
      $_POST['download_info_enabled'] = (isset($_POST['download_info_enabled'])) ? '1' : '0';
      $_POST['verification_requests'] = (isset($_POST['verification_requests'])) ? '1' : '0';
      $_POST['verification_docs_required'] = (isset($_POST['verification_docs_required'])) ? '1' : '0';
      $_POST['verification_for_posts'] = (isset($_POST['verification_for_posts'])) ? '1' : '0';
      $_POST['verification_for_monetization'] = (isset($_POST['verification_for_monetization'])) ? '1' : '0';
      $_POST['verification_for_adult_content'] = (isset($_POST['verification_for_adult_content'])) ? '1' : '0';
      /* update */
      update_system_options([
        'friends_enabled' => secure($_POST['friends_enabled']),
        'disable_declined_friendrequest' => secure($_POST['disable_declined_friendrequest']),
        'max_friends' => secure($_POST['max_friends'], 'int'),
        'switch_accounts_enabled' => secure($_POST['switch_accounts_enabled']),
        'genders_disabled' => secure($_POST['genders_disabled']),
        'show_usernames_enabled' => secure($_POST['show_usernames_enabled']),
        'disable_username_changes' => secure($_POST['disable_username_changes']),
        'special_characters_enabled' => secure($_POST['special_characters_enabled']),
        'delete_accounts_enabled' => secure($_POST['delete_accounts_enabled']),
        'download_info_enabled' => secure($_POST['download_info_enabled']),
        'verification_requests' => secure($_POST['verification_requests']),
        'verification_docs_required' => secure($_POST['verification_docs_required']),
        'verification_for_posts' => secure($_POST['verification_for_posts']),
        'verification_for_monetization' => secure($_POST['verification_for_monetization']),
        'verification_for_adult_content' => secure($_POST['verification_for_adult_content']),
      ]);
      /* check if switch accounts disabled */
      if ($_POST['switch_accounts_enabled'] == '0') {
        /* delete all switch accounts */
        $db->query(sprintf("DELETE FROM users_accounts"));
        /* update all users */
        $db->query("UPDATE users SET user_master_account = user_id");
      }
      break;

    case 'profile':
      /* prepare */
      $_POST['relationship_info_enabled'] = (isset($_POST['relationship_info_enabled'])) ? '1' : '0';
      $_POST['website_info_enabled'] = (isset($_POST['website_info_enabled'])) ? '1' : '0';
      $_POST['biography_info_enabled'] = (isset($_POST['biography_info_enabled'])) ? '1' : '0';
      $_POST['work_info_enabled'] = (isset($_POST['work_info_enabled'])) ? '1' : '0';
      $_POST['location_info_enabled'] = (isset($_POST['location_info_enabled'])) ? '1' : '0';
      $_POST['education_info_enabled'] = (isset($_POST['education_info_enabled'])) ? '1' : '0';
      $_POST['social_info_enabled'] = (isset($_POST['social_info_enabled'])) ? '1' : '0';
      $_POST['system_profile_background_enabled'] = (isset($_POST['system_profile_background_enabled'])) ? '1' : '0';
      /* update */
      update_system_options([
        'relationship_info_enabled' => secure($_POST['relationship_info_enabled']),
        'website_info_enabled' => secure($_POST['website_info_enabled']),
        'biography_info_enabled' => secure($_POST['biography_info_enabled']),
        'work_info_enabled' => secure($_POST['work_info_enabled']),
        'location_info_enabled' => secure($_POST['location_info_enabled']),
        'education_info_enabled' => secure($_POST['education_info_enabled']),
        'social_info_enabled' => secure($_POST['social_info_enabled']),
        'system_profile_background_enabled' => secure($_POST['system_profile_background_enabled']),
      ]);
      break;

    case 'privacy':
      /* prepare */
      $privacy = ['me', 'friends', 'public'];
      /* check if valid privacy */
      if (!in_array($_POST['user_privacy_chat'], $privacy) || !in_array($_POST['user_privacy_poke'], $privacy) || !in_array($_POST['user_privacy_gifts'], $privacy) || !in_array($_POST['user_privacy_wall'], $privacy) || !in_array($_POST['user_privacy_gender'], $privacy) || !in_array($_POST['user_privacy_relationship'], $privacy) || !in_array($_POST['user_privacy_birthdate'], $privacy) || !in_array($_POST['user_privacy_basic'], $privacy) || !in_array($_POST['user_privacy_work'], $privacy) || !in_array($_POST['user_privacy_location'], $privacy) || !in_array($_POST['user_privacy_education'], $privacy) || !in_array($_POST['user_privacy_other'], $privacy) || !in_array($_POST['user_privacy_friends'], $privacy) || !in_array($_POST['user_privacy_followers'], $privacy) || !in_array($_POST['user_privacy_subscriptions'], $privacy) || !in_array($_POST['user_privacy_photos'], $privacy) || !in_array($_POST['user_privacy_pages'], $privacy) || !in_array($_POST['user_privacy_groups'], $privacy) || !in_array($_POST['user_privacy_events'], $privacy)) {
        _error(400);
      }
      /* update */
      update_system_options([
        'user_privacy_chat' => secure($_POST['user_privacy_chat']),
        'user_privacy_poke' => secure($_POST['user_privacy_poke']),
        'user_privacy_gifts' => secure($_POST['user_privacy_gifts']),
        'user_privacy_wall' => secure($_POST['user_privacy_wall']),
        'user_privacy_gender' => secure($_POST['user_privacy_gender']),
        'user_privacy_relationship' => secure($_POST['user_privacy_relationship']),
        'user_privacy_birthdate' => secure($_POST['user_privacy_birthdate']),
        'user_privacy_basic' => secure($_POST['user_privacy_basic']),
        'user_privacy_work' => secure($_POST['user_privacy_work']),
        'user_privacy_location' => secure($_POST['user_privacy_location']),
        'user_privacy_education' => secure($_POST['user_privacy_education']),
        'user_privacy_other' => secure($_POST['user_privacy_other']),
        'user_privacy_friends' => secure($_POST['user_privacy_friends']),
        'user_privacy_followers' => secure($_POST['user_privacy_followers']),
        'user_privacy_subscriptions' => secure($_POST['user_privacy_subscriptions']),
        'user_privacy_photos' => secure($_POST['user_privacy_photos']),
        'user_privacy_pages' => secure($_POST['user_privacy_pages']),
        'user_privacy_groups' => secure($_POST['user_privacy_groups']),
        'user_privacy_events' => secure($_POST['user_privacy_events']),
      ]);

      break;

    case 'email':
      /* prepare */
      $_POST['email_smtp_enabled'] = (isset($_POST['email_smtp_enabled'])) ? '1' : '0';
      $_POST['email_smtp_authentication'] = (isset($_POST['email_smtp_authentication'])) ? '1' : '0';
      $_POST['email_smtp_ssl'] = (isset($_POST['email_smtp_ssl'])) ? '1' : '0';
      /* update */
      update_system_options([
        'email_smtp_enabled' => secure($_POST['email_smtp_enabled']),
        'email_smtp_authentication' => secure($_POST['email_smtp_authentication']),
        'email_smtp_ssl' => secure($_POST['email_smtp_ssl']),
        'email_smtp_server' => secure($_POST['email_smtp_server']),
        'email_smtp_port' => secure($_POST['email_smtp_port']),
        'email_smtp_username' => secure($_POST['email_smtp_username']),
        'email_smtp_password' => secure($_POST['email_smtp_password']),
        'email_smtp_setfrom' => secure($_POST['email_smtp_setfrom'])
      ]);
      break;

    case 'sms':
      /* update */
      update_system_options([
        'sms_provider' => secure($_POST['sms_provider']),
        'sms_limit' => secure($_POST['sms_limit']),
        'twilio_sid' => secure($_POST['twilio_sid']),
        'twilio_token' => secure($_POST['twilio_token']),
        'twilio_phone' => secure($_POST['twilio_phone']),
        'bulksms_username' => secure($_POST['bulksms_username']),
        'bulksms_password' => secure($_POST['bulksms_password']),
        'infobip_username' => secure($_POST['infobip_username']),
        'infobip_password' => secure($_POST['infobip_password']),
        'msg91_authkey' => secure($_POST['msg91_authkey']),
        'system_phone' => secure($_POST['system_phone'])
      ]);
      break;

    case 'website_notifications':
      /* prepare */
      $_POST['profile_notification_enabled'] = (isset($_POST['profile_notification_enabled'])) ? '1' : '0';
      $_POST['browser_notifications_enabled'] = (isset($_POST['browser_notifications_enabled'])) ? '1' : '0';
      $_POST['noty_notifications_enabled'] = (isset($_POST['noty_notifications_enabled'])) ? '1' : '0';
      /* update */
      update_system_options([
        'profile_notification_enabled' => secure($_POST['profile_notification_enabled']),
        'browser_notifications_enabled' => secure($_POST['browser_notifications_enabled']),
        'noty_notifications_enabled' => secure($_POST['noty_notifications_enabled'])
      ]);
      break;

    case 'email_notifications':
      /* prepare */
      $_POST['email_notifications'] = (isset($_POST['email_notifications'])) ? '1' : '0';
      $_POST['email_post_likes'] = (isset($_POST['email_post_likes'])) ? '1' : '0';
      $_POST['email_post_comments'] = (isset($_POST['email_post_comments'])) ? '1' : '0';
      $_POST['email_post_shares'] = (isset($_POST['email_post_shares'])) ? '1' : '0';
      $_POST['email_wall_posts'] = (isset($_POST['email_wall_posts'])) ? '1' : '0';
      $_POST['email_mentions'] = (isset($_POST['email_mentions'])) ? '1' : '0';
      $_POST['email_profile_visits'] = (isset($_POST['email_profile_visits'])) ? '1' : '0';
      $_POST['email_friend_requests'] = (isset($_POST['email_friend_requests'])) ? '1' : '0';
      $_POST['email_user_verification'] = (isset($_POST['email_user_verification'])) ? '1' : '0';
      $_POST['email_user_post_approval'] = (isset($_POST['email_user_post_approval'])) ? '1' : '0';
      $_POST['email_admin_verifications'] = (isset($_POST['email_admin_verifications'])) ? '1' : '0';
      $_POST['email_admin_post_approval'] = (isset($_POST['email_admin_post_approval'])) ? '1' : '0';
      $_POST['email_admin_user_approval'] = (isset($_POST['email_admin_user_approval'])) ? '1' : '0';
      /* update */
      update_system_options([
        'email_notifications' => secure($_POST['email_notifications']),
        'email_post_likes' => secure($_POST['email_post_likes']),
        'email_post_comments' => secure($_POST['email_post_comments']),
        'email_post_shares' => secure($_POST['email_post_shares']),
        'email_wall_posts' => secure($_POST['email_wall_posts']),
        'email_mentions' => secure($_POST['email_mentions']),
        'email_profile_visits' => secure($_POST['email_profile_visits']),
        'email_friend_requests' => secure($_POST['email_friend_requests']),
        'email_user_verification' => secure($_POST['email_user_verification']),
        'email_user_post_approval' => secure($_POST['email_user_post_approval']),
        'email_admin_verifications' => secure($_POST['email_admin_verifications']),
        'email_admin_post_approval' => secure($_POST['email_admin_post_approval']),
        'email_admin_user_approval' => secure($_POST['email_admin_user_approval']),
      ]);
      break;

    case 'push_notifications':
      /* prepare */
      $_POST['onesignal_notification_enabled'] = (isset($_POST['onesignal_notification_enabled'])) ? '1' : '0';
      $_POST['onesignal_messenger_notification_enabled'] = (isset($_POST['onesignal_messenger_notification_enabled'])) ? '1' : '0';
      $_POST['onesignal_timeline_notification_enabled'] = (isset($_POST['onesignal_timeline_notification_enabled'])) ? '1' : '0';
      /* update */
      update_system_options([
        'onesignal_notification_enabled' => secure($_POST['onesignal_notification_enabled']),
        'onesignal_app_id' => secure($_POST['onesignal_app_id']),
        'onesignal_api_key' => secure($_POST['onesignal_api_key']),
        'onesignal_messenger_notification_enabled' => secure($_POST['onesignal_messenger_notification_enabled']),
        'onesignal_messenger_app_id' => secure($_POST['onesignal_messenger_app_id']),
        'onesignal_messenger_api_key' => secure($_POST['onesignal_messenger_api_key']),
        'onesignal_timeline_notification_enabled' => secure($_POST['onesignal_timeline_notification_enabled']),
        'onesignal_timeline_app_id' => secure($_POST['onesignal_timeline_app_id']),
        'onesignal_timeline_api_key' => secure($_POST['onesignal_timeline_api_key'])
      ]);
      break;

    case 'chat':
      /* prepare */
      $_POST['chat_enabled'] = (isset($_POST['chat_enabled'])) ? '1' : '0';
      $_POST['voice_notes_chat_enabled'] = (isset($_POST['voice_notes_chat_enabled'])) ? '1' : '0';
      $_POST['chat_status_enabled'] = (isset($_POST['chat_status_enabled'])) ? '1' : '0';
      $_POST['chat_typing_enabled'] = (isset($_POST['chat_typing_enabled'])) ? '1' : '0';
      $_POST['chat_seen_enabled'] = (isset($_POST['chat_seen_enabled'])) ? '1' : '0';
      $_POST['chat_permanently_delete_enabled'] = (isset($_POST['chat_permanently_delete_enabled'])) ? '1' : '0';
      $_POST['chat_translation_enabled'] = (isset($_POST['chat_translation_enabled'])) ? '1' : '0';
      /* update */
      update_system_options([
        'chat_enabled' => secure($_POST['chat_enabled']),
        'voice_notes_chat_enabled' => secure($_POST['voice_notes_chat_enabled']),
        'chat_status_enabled' => secure($_POST['chat_status_enabled']),
        'chat_typing_enabled' => secure($_POST['chat_typing_enabled']),
        'chat_seen_enabled' => secure($_POST['chat_seen_enabled']),
        'chat_permanently_delete_enabled' => secure($_POST['chat_permanently_delete_enabled']),
        'chat_translation_enabled' => secure($_POST['chat_translation_enabled'])
      ]);
      break;

    case 'audio_video_calls':
      /* prepare */
      $_POST['audio_call_enabled'] = (isset($_POST['audio_call_enabled'])) ? '1' : '0';
      $_POST['video_call_enabled'] = (isset($_POST['video_call_enabled'])) ? '1' : '0';
      /* update */
      update_system_options([
        'audio_call_enabled' => secure($_POST['audio_call_enabled']),
        'video_call_enabled' => secure($_POST['video_call_enabled']),
        'audio_video_provider' => secure($_POST['audio_video_provider']),
        'twilio_sid' => secure($_POST['twilio_sid']),
        'twilio_apisid' => secure($_POST['twilio_apisid']),
        'twilio_apisecret' => secure($_POST['twilio_apisecret']),
        'livekit_api_key' => secure($_POST['livekit_api_key']),
        'livekit_api_secret' => secure($_POST['livekit_api_secret']),
        'livekit_ws_url' => secure($_POST['livekit_ws_url'])
      ]);
      break;

    case 'live':
      /* prepare */
      $_POST['live_enabled'] = (isset($_POST['live_enabled'])) ? '1' : '0';
      $_POST['save_live_enabled'] = (isset($_POST['save_live_enabled'])) ? '1' : '0';
      /* update */
      update_system_options([
        'live_enabled' => secure($_POST['live_enabled']),
        'save_live_enabled' => secure($_POST['save_live_enabled']),
        'agora_app_id' => secure($_POST['agora_app_id']),
        'agora_app_certificate' => secure($_POST['agora_app_certificate']),
        'agora_customer_id' => secure($_POST['agora_customer_id']),
        'agora_customer_certificate' => secure($_POST['agora_customer_certificate']),
        'agora_s3_bucket' => secure($_POST['agora_s3_bucket']),
        'agora_s3_region' => secure($_POST['agora_s3_region']),
        'agora_s3_key' => secure($_POST['agora_s3_key']),
        'agora_s3_secret' => secure($_POST['agora_s3_secret'])
      ]);
      break;

    case 'uploads':
      /* prepare */
      $_POST['photos_enabled'] = (isset($_POST['photos_enabled'])) ? '1' : '0';
      $_POST['comments_photos_enabled'] = (isset($_POST['comments_photos_enabled'])) ? '1' : '0';
      $_POST['chat_photos_enabled'] = (isset($_POST['chat_photos_enabled'])) ? '1' : '0';
      $_POST['tinymce_photos_enabled'] = (isset($_POST['tinymce_photos_enabled'])) ? '1' : '0';
      $_POST['allow_heif_images'] = (isset($_POST['allow_heif_images'])) ? '1' : '0';
      $_POST['allow_animated_images'] = (isset($_POST['allow_animated_images'])) ? '1' : '0';
      $_POST['limit_cover_photo'] = (isset($_POST['limit_cover_photo'])) ? '1' : '0';
      $_POST['cover_crop_enabled'] = (isset($_POST['cover_crop_enabled'])) ? '1' : '0';
      $_POST['watermark_enabled'] = (isset($_POST['watermark_enabled'])) ? '1' : '0';
      $_POST['videos_enabled'] = (isset($_POST['videos_enabled'])) ? '1' : '0';
      $_POST['ffmpeg_enabled'] = (isset($_POST['ffmpeg_enabled'])) ? '1' : '0';
      $_POST['watermark_videos_enabled'] = (isset($_POST['watermark_videos_enabled'])) ? '1' : '0';
      $_POST['audio_enabled'] = (isset($_POST['audio_enabled'])) ? '1' : '0';
      $_POST['file_enabled'] = (isset($_POST['file_enabled'])) ? '1' : '0';
      $_POST['mask_file_path_enabled'] = (isset($_POST['mask_file_path_enabled'])) ? '1' : '0';
      /* check if allow_heif_images is enabled */
      if ($_POST['allow_heif_images'] && !extension_loaded('imagick')) {
        throw new Exception(__("The Imagick extension is required to enable HEIF/HEIC images support. Please enable it in your server configuration"));
      }
      /* update */
      update_system_options([
        'uploads_directory' => secure($_POST['uploads_directory']),
        'uploads_prefix' => secure($_POST['uploads_prefix']),
        'uploads_cdn_url' => secure($_POST['uploads_cdn_url']),
        'max_daily_upload_size' => secure($_POST['max_daily_upload_size']),
        'chunk_upload_size' => secure($_POST['chunk_upload_size']),
        'max_avatar_size' => secure($_POST['max_avatar_size']),
        'max_cover_size' => secure($_POST['max_cover_size']),
        'photos_enabled' => secure($_POST['photos_enabled']),
        'comments_photos_enabled' => secure($_POST['comments_photos_enabled']),
        'chat_photos_enabled' => secure($_POST['chat_photos_enabled']),
        'tinymce_photos_enabled' => secure($_POST['tinymce_photos_enabled']),
        'max_photo_size' => secure($_POST['max_photo_size']),
        'uploads_quality' => secure($_POST['uploads_quality']),
        'allow_heif_images' => secure($_POST['allow_heif_images']),
        'allow_animated_images' => secure($_POST['allow_animated_images']),
        'limit_cover_photo' => secure($_POST['limit_cover_photo']),
        'cover_crop_enabled' => secure($_POST['cover_crop_enabled']),
        'watermark_enabled' => secure($_POST['watermark_enabled']),
        'watermark_type' => secure($_POST['watermark_type']),
        'watermark_icon' => secure($_POST['watermark_icon']),
        'watermark_position' => secure($_POST['watermark_position']),
        'watermark_opacity' => secure($_POST['watermark_opacity']),
        'watermark_xoffset' => secure($_POST['watermark_xoffset']),
        'watermark_yoffset' => secure($_POST['watermark_yoffset']),
        'adult_images_enabled' => secure($_POST['adult_images_enabled']),
        'adult_images_action' => secure($_POST['adult_images_action']),
        'adult_images_api_key' => secure($_POST['adult_images_api_key']),
        'videos_enabled' => secure($_POST['videos_enabled']),
        'ffmpeg_enabled' => secure($_POST['ffmpeg_enabled']),
        'ffmpeg_path' => secure($_POST['ffmpeg_path']),
        'ffmpeg_speed' => secure($_POST['ffmpeg_speed']),
        'max_video_size' => secure($_POST['max_video_size']),
        'video_extensions' => secure($_POST['video_extensions']),
        'ffmpeg_240p_enabled' => secure($_POST['ffmpeg_240p_enabled']),
        'ffmpeg_360p_enabled' => secure($_POST['ffmpeg_360p_enabled']),
        'ffmpeg_480p_enabled' => secure($_POST['ffmpeg_480p_enabled']),
        'ffmpeg_720p_enabled' => secure($_POST['ffmpeg_720p_enabled']),
        'ffmpeg_1080p_enabled' => secure($_POST['ffmpeg_1080p_enabled']),
        'ffmpeg_1440p_enabled' => secure($_POST['ffmpeg_1440p_enabled']),
        'ffmpeg_2160p_enabled' => secure($_POST['ffmpeg_2160p_enabled']),
        'watermark_videos_enabled' => secure($_POST['watermark_videos_enabled']),
        'watermark_videos_icon' => secure($_POST['watermark_videos_icon']),
        'watermark_videos_position' => secure($_POST['watermark_videos_position']),
        'watermark_videos_opacity' => secure($_POST['watermark_videos_opacity']),
        'watermark_videos_xoffset' => secure($_POST['watermark_videos_xoffset']),
        'watermark_videos_yoffset' => secure($_POST['watermark_videos_yoffset']),
        'audio_enabled' => secure($_POST['audio_enabled']),
        'max_audio_size' => secure($_POST['max_audio_size']),
        'audio_extensions' => secure($_POST['audio_extensions']),
        'file_enabled' => secure($_POST['file_enabled']),
        'mask_file_path_enabled' => secure($_POST['mask_file_path_enabled']),
        'max_file_size' => secure($_POST['max_file_size']),
        'file_extensions' => secure($_POST['file_extensions']),
      ]);
      break;

    case 's3':
      /* prepare */
      $_POST['s3_enabled'] = (isset($_POST['s3_enabled'])) ? '1' : '0';
      /* if enabled is set -> disable all other options [digitalocean|ftp] */
      if ($_POST['s3_enabled']) {
        update_system_options([
          'google_cloud_enabled' => '0',
          'digitalocean_enabled' => '0',
          'wasabi_enabled' => '0',
          'backblaze_enabled' => '0',
          'yandex_cloud_enabled'  => '0',
          'ftp_enabled' => '0'
        ]);
      }
      /* update */
      update_system_options([
        's3_enabled' => secure($_POST['s3_enabled']),
        's3_bucket' => secure($_POST['s3_bucket']),
        's3_region' => secure($_POST['s3_region']),
        's3_key' => secure($_POST['s3_key']),
        's3_secret' => secure($_POST['s3_secret'])
      ]);
      break;

    case 'google_cloud':
      /* prepare */
      $_POST['google_cloud_enabled'] = (isset($_POST['google_cloud_enabled'])) ? '1' : '0';
      /* if enabled is set -> disable all other options [s3|digitalocean|wasabi|ftp] */
      if ($_POST['google_cloud_enabled']) {
        update_system_options([
          's3_enabled' => '0',
          'digitalocean_enabled' => '0',
          'wasabi_enabled' => '0',
          'backblaze_enabled' => '0',
          'yandex_cloud_enabled'  => '0',
          'ftp_enabled' => '0'
        ]);
      }
      /* update */
      update_system_options([
        'google_cloud_enabled' => secure($_POST['google_cloud_enabled']),
        'google_cloud_bucket' => secure($_POST['google_cloud_bucket']),
        'google_cloud_file' => secure($_POST['google_cloud_file'])
      ]);
      break;

    case 'digitalocean':
      /* prepare */
      $_POST['digitalocean_enabled'] = (isset($_POST['digitalocean_enabled'])) ? '1' : '0';
      /* if enabled is set -> disable all other options [s3|ftp] */
      if ($_POST['digitalocean_enabled']) {
        update_system_options([
          's3_enabled' => '0',
          'google_cloud_enabled' => '0',
          'wasabi_enabled' => '0',
          'backblaze_enabled' => '0',
          'yandex_cloud_enabled'  => '0',
          'ftp_enabled' => '0'
        ]);
      }
      /* update */
      update_system_options([
        'digitalocean_enabled' => secure($_POST['digitalocean_enabled']),
        'digitalocean_space_name' => secure($_POST['digitalocean_space_name']),
        'digitalocean_space_region' => secure($_POST['digitalocean_space_region']),
        'digitalocean_key' => secure($_POST['digitalocean_key']),
        'digitalocean_secret' => secure($_POST['digitalocean_secret'])
      ]);
      break;

    case 'wasabi':
      /* prepare */
      $_POST['wasabi_enabled'] = (isset($_POST['wasabi_enabled'])) ? '1' : '0';
      /* if enabled is set -> disable all other options [s3|digitalocean|ftp] */
      if ($_POST['wasabi_enabled']) {
        update_system_options([
          's3_enabled' => '0',
          'google_cloud_enabled' => '0',
          'digitalocean_enabled' => '0',
          'backblaze_enabled' => '0',
          'yandex_cloud_enabled'  => '0',
          'ftp_enabled' => '0'
        ]);
      }
      /* update */
      update_system_options([
        'wasabi_enabled' => secure($_POST['wasabi_enabled']),
        'wasabi_bucket' => secure($_POST['wasabi_bucket']),
        'wasabi_region' => secure($_POST['wasabi_region']),
        'wasabi_key' => secure($_POST['wasabi_key']),
        'wasabi_secret' => secure($_POST['wasabi_secret'])
      ]);
      break;

    case 'backblaze':
      /* prepare */
      $_POST['backblaze_enabled'] = (isset($_POST['backblaze_enabled'])) ? '1' : '0';
      /* if enabled is set -> disable all other options [s3|digitalocean|ftp] */
      if ($_POST['backblaze_enabled']) {
        update_system_options([
          's3_enabled' => '0',
          'google_cloud_enabled' => '0',
          'digitalocean_enabled' => '0',
          'wasabi_enabled' => '0',
          'yandex_cloud_enabled'  => '0',
          'ftp_enabled' => '0'
        ]);
      }
      /* update */
      update_system_options([
        'backblaze_enabled' => secure($_POST['backblaze_enabled']),
        'backblaze_bucket' => secure($_POST['backblaze_bucket']),
        'backblaze_region' => secure($_POST['backblaze_region']),
        'backblaze_key' => secure($_POST['backblaze_key']),
        'backblaze_secret' => secure($_POST['backblaze_secret'])
      ]);
      break;

    case 'yandex_cloud':
      /* prepare */
      $_POST['yandex_cloud_enabled'] = (isset($_POST['yandex_cloud_enabled'])) ? '1' : '0';
      /* if enabled is set -> disable all other options [s3|digitalocean|ftp] */
      if ($_POST['yandex_cloud_enabled']) {
        update_system_options([
          's3_enabled' => '0',
          'google_cloud_enabled' => '0',
          'digitalocean_enabled' => '0',
          'wasabi_enabled' => '0',
          'backblaze_enabled' => '0',
          'ftp_enabled' => '0'
        ]);
      }
      /* update */
      update_system_options([
        'yandex_cloud_enabled' => secure($_POST['yandex_cloud_enabled']),
        'yandex_cloud_bucket' => secure($_POST['yandex_cloud_bucket']),
        'yandex_cloud_region' => secure($_POST['yandex_cloud_region']),
        'yandex_cloud_key' => secure($_POST['yandex_cloud_key']),
        'yandex_cloud_secret' => secure($_POST['yandex_cloud_secret'])
      ]);
      break;

    case 'ftp':
      /* prepare */
      $_POST['ftp_enabled'] = (isset($_POST['ftp_enabled'])) ? '1' : '0';
      /* if enabled is set -> disable all other options [s3|digitalocean] */
      if ($_POST['ftp_enabled']) {
        update_system_options([
          's3_enabled' => '0',
          'digitalocean_enabled' => '0',
          'wasabi_enabled' => '0',
          'google_cloud_enabled' => '0',
        ]);
      }
      /* update */
      update_system_options([
        'ftp_enabled' => secure($_POST['ftp_enabled']),
        'ftp_hostname' => secure($_POST['ftp_hostname']),
        'ftp_username' => secure($_POST['ftp_username']),
        'ftp_password' => secure($_POST['ftp_password']),
        'ftp_port' => secure($_POST['ftp_port']),
        'ftp_path' => secure($_POST['ftp_path']),
        'ftp_endpoint' => secure($_POST['ftp_endpoint'])
      ]);
      break;

    case 'payments_settings':
      /* prepare */
      $_POST['payment_fees_enabled'] = (isset($_POST['payment_fees_enabled'])) ? '1' : '0';
      $_POST['payment_vat_enabled'] = (isset($_POST['payment_vat_enabled'])) ? '1' : '0';
      $_POST['payment_country_vat_enabled'] = (isset($_POST['payment_country_vat_enabled'])) ? '1' : '0';
      /* update */
      update_system_options([
        'payment_fees_enabled' => secure($_POST['payment_fees_enabled']),
        'payment_fees_percentage' => secure($_POST['payment_fees_percentage']),
        'payment_vat_enabled' => secure($_POST['payment_vat_enabled']),
        'payment_country_vat_enabled' => secure($_POST['payment_country_vat_enabled']),
        'payment_vat_percentage' => secure($_POST['payment_vat_percentage']),
      ]);
      break;

    case 'payments_methods':
      /* prepare */
      $_POST['paypal_enabled'] = (isset($_POST['paypal_enabled'])) ? '1' : '0';
      $_POST['paypal_payouts_enabled'] = (isset($_POST['paypal_payouts_enabled'])) ? '1' : '0';
      $_POST['creditcard_enabled'] = (isset($_POST['creditcard_enabled'])) ? '1' : '0';
      $_POST['alipay_enabled'] = (isset($_POST['alipay_enabled'])) ? '1' : '0';
      $_POST['stripe_payment_element_enabled'] = (isset($_POST['stripe_payment_element_enabled'])) ? '1' : '0';
      $_POST['paystack_enabled'] = (isset($_POST['paystack_enabled'])) ? '1' : '0';
      $_POST['coinpayments_enabled'] = (isset($_POST['coinpayments_enabled'])) ? '1' : '0';
      $_POST['2checkout_enabled'] = (isset($_POST['2checkout_enabled'])) ? '1' : '0';
      $_POST['authorize_net_enabled'] = (isset($_POST['authorize_net_enabled'])) ? '1' : '0';
      $_POST['razorpay_enabled'] = (isset($_POST['razorpay_enabled'])) ? '1' : '0';
      $_POST['cashfree_enabled'] = (isset($_POST['cashfree_enabled'])) ? '1' : '0';
      $_POST['coinbase_enabled'] = (isset($_POST['coinbase_enabled'])) ? '1' : '0';
      $_POST['securionpay_enabled'] = (isset($_POST['securionpay_enabled'])) ? '1' : '0';
      $_POST['moneypoolscash_enabled'] = (isset($_POST['moneypoolscash_enabled'])) ? '1' : '0';
      $_POST['moneypoolscash_payouts_enabled'] = (isset($_POST['moneypoolscash_payouts_enabled'])) ? '1' : '0';
      $_POST['myfatoorah_enabled'] = (isset($_POST['myfatoorah_enabled'])) ? '1' : '0';
      $_POST['epayco_enabled'] = (isset($_POST['epayco_enabled'])) ? '1' : '0';
      $_POST['flutterwave_enabled'] = (isset($_POST['flutterwave_enabled'])) ? '1' : '0';
      $_POST['verotel_enabled'] = (isset($_POST['verotel_enabled'])) ? '1' : '0';
      $_POST['mercadopago_enabled'] = (isset($_POST['mercadopago_enabled'])) ? '1' : '0';
      /* update */
      update_system_options([
        'paypal_enabled' => secure($_POST['paypal_enabled']),
        'paypal_payouts_enabled' => secure($_POST['paypal_payouts_enabled']),
        'paypal_mode' => secure($_POST['paypal_mode']),
        'paypal_id' => secure($_POST['paypal_id']),
        'paypal_secret' => secure($_POST['paypal_secret']),
        'paypal_webhook' => secure($_POST['paypal_webhook']),
        'creditcard_enabled' => secure($_POST['creditcard_enabled']),
        'alipay_enabled' => secure($_POST['alipay_enabled']),
        'stripe_payment_element_enabled' => secure($_POST['stripe_payment_element_enabled']),
        'stripe_mode' => secure($_POST['stripe_mode']),
        'stripe_test_secret' => secure($_POST['stripe_test_secret']),
        'stripe_test_publishable' => secure($_POST['stripe_test_publishable']),
        'stripe_live_secret' => secure($_POST['stripe_live_secret']),
        'stripe_live_publishable' => secure($_POST['stripe_live_publishable']),
        'stripe_webhook' => secure($_POST['stripe_webhook']),
        'paystack_enabled' => secure($_POST['paystack_enabled']),
        'paystack_secret' => secure($_POST['paystack_secret']),
        'coinpayments_enabled' => secure($_POST['coinpayments_enabled']),
        'coinpayments_merchant_id' => secure($_POST['coinpayments_merchant_id']),
        'coinpayments_ipn_secret' => secure($_POST['coinpayments_ipn_secret']),
        '2checkout_enabled' => secure($_POST['2checkout_enabled']),
        '2checkout_mode' => secure($_POST['2checkout_mode']),
        '2checkout_merchant_code' => secure($_POST['2checkout_merchant_code']),
        '2checkout_publishable_key' => secure($_POST['2checkout_publishable_key']),
        '2checkout_private_key' => secure($_POST['2checkout_private_key']),
        'authorize_net_enabled' => secure($_POST['authorize_net_enabled']),
        'authorize_net_mode' => secure($_POST['authorize_net_mode']),
        'authorize_net_api_login_id' => secure($_POST['authorize_net_api_login_id']),
        'authorize_net_transaction_key' => secure($_POST['authorize_net_transaction_key']),
        'razorpay_enabled' => secure($_POST['razorpay_enabled']),
        'razorpay_key_id' => secure($_POST['razorpay_key_id']),
        'razorpay_key_secret' => secure($_POST['razorpay_key_secret']),
        'cashfree_enabled' => secure($_POST['cashfree_enabled']),
        'cashfree_mode' => secure($_POST['cashfree_mode']),
        'cashfree_client_id' => secure($_POST['cashfree_client_id']),
        'cashfree_client_secret' => secure($_POST['cashfree_client_secret']),
        'coinbase_enabled' => secure($_POST['coinbase_enabled']),
        'coinbase_api_key' => secure($_POST['coinbase_api_key']),
        'securionpay_enabled' => secure($_POST['securionpay_enabled']),
        'securionpay_api_key' => secure($_POST['securionpay_api_key']),
        'securionpay_api_secret' => secure($_POST['securionpay_api_secret']),
        'moneypoolscash_enabled' => secure($_POST['moneypoolscash_enabled']),
        'moneypoolscash_payouts_enabled' => secure($_POST['moneypoolscash_payouts_enabled']),
        'moneypoolscash_api_key' => secure($_POST['moneypoolscash_api_key']),
        'moneypoolscash_merchant_email' => secure($_POST['moneypoolscash_merchant_email']),
        'moneypoolscash_merchant_password' => secure($_POST['moneypoolscash_merchant_password']),
        'myfatoorah_enabled' => secure($_POST['myfatoorah_enabled']),
        'myfatoorah_mode' => secure($_POST['myfatoorah_mode']),
        'myfatoorah_test_token' => secure($_POST['myfatoorah_test_token']),
        'myfatoorah_live_token' => secure($_POST['myfatoorah_live_token']),
        'myfatoorah_live_api_url' => secure($_POST['myfatoorah_live_api_url']),
        'epayco_enabled' => secure($_POST['epayco_enabled']),
        'epayco_mode' => secure($_POST['epayco_mode']),
        'epayco_public_key' => secure($_POST['epayco_public_key']),
        'epayco_private_key' => secure($_POST['epayco_private_key']),
        'flutterwave_enabled' => secure($_POST['flutterwave_enabled']),
        'flutterwave_mode' => secure($_POST['flutterwave_mode']),
        'flutterwave_public_key' => secure($_POST['flutterwave_public_key']),
        'flutterwave_secret_key' => secure($_POST['flutterwave_secret_key']),
        'flutterwave_encryption_key' => secure($_POST['flutterwave_encryption_key']),
        'verotel_enabled' => secure($_POST['verotel_enabled']),
        'verotel_shop_id' => secure($_POST['verotel_shop_id']),
        'verotel_signature_key' => secure($_POST['verotel_signature_key']),
        'mercadopago_enabled' => secure($_POST['mercadopago_enabled']),
        'mercadopago_public_key' => secure($_POST['mercadopago_public_key']),
        'mercadopago_access_token' => secure($_POST['mercadopago_access_token']),
      ]);
      break;

    case 'bank':
      /* prepare */
      $_POST['bank_transfers_enabled'] = (isset($_POST['bank_transfers_enabled'])) ? '1' : '0';
      /* update */
      update_system_options([
        'bank_transfers_enabled' => secure($_POST['bank_transfers_enabled']),
        'bank_name' => secure($_POST['bank_name']),
        'bank_account_number' => secure($_POST['bank_account_number']),
        'bank_account_name' => secure($_POST['bank_account_name']),
        'bank_account_routing' => secure($_POST['bank_account_routing']),
        'bank_account_country' => secure($_POST['bank_account_country']),
        'bank_transfer_note' => secure($_POST['bank_transfer_note'])
      ]);
      break;

    case 'security':
      /* prepare */
      $_POST['unusual_login_enabled'] = (isset($_POST['unusual_login_enabled'])) ? '1' : '0';
      $_POST['brute_force_detection_enabled'] = (isset($_POST['brute_force_detection_enabled'])) ? '1' : '0';
      $_POST['two_factor_enabled'] = (isset($_POST['two_factor_enabled'])) ? '1' : '0';
      $_POST['password_complexity_enabled'] = (isset($_POST['password_complexity_enabled'])) ? '1' : '0';
      $_POST['reserved_usernames_enabled'] = (isset($_POST['reserved_usernames_enabled'])) ? '1' : '0';
      $_POST['censored_words_enabled'] = (isset($_POST['censored_words_enabled'])) ? '1' : '0';
      $_POST['censored_domains_enabled'] = (isset($_POST['censored_domains_enabled'])) ? '1' : '0';
      $_POST['html_richtext_enabled'] = (isset($_POST['html_richtext_enabled'])) ? '1' : '0';
      $_POST['reCAPTCHA_enabled'] = (isset($_POST['reCAPTCHA_enabled'])) ? '1' : '0';
      $_POST['turnstile_enabled'] = (isset($_POST['turnstile_enabled'])) ? '1' : '0';
      /* validate */
      if ($_POST['reCAPTCHA_enabled'] && $_POST['turnstile_enabled']) {
        throw new Exception(__("You can't enable reCAPTCHA and Turnstile at the same time"));
      }
      /* update */
      update_system_options([
        'unusual_login_enabled' => secure($_POST['unusual_login_enabled']),
        'brute_force_detection_enabled' => secure($_POST['brute_force_detection_enabled']),
        'brute_force_bad_login_limit' => secure($_POST['brute_force_bad_login_limit'], 'int'),
        'brute_force_lockout_time' => secure($_POST['brute_force_lockout_time'], 'int'),
        'two_factor_enabled' => secure($_POST['two_factor_enabled']),
        'two_factor_type' => secure($_POST['two_factor_type']),
        'password_complexity_enabled' => secure($_POST['password_complexity_enabled']),
        'reserved_usernames_enabled' => secure($_POST['reserved_usernames_enabled']),
        'reserved_usernames' => secure($_POST['reserved_usernames']),
        'censored_words_enabled' => secure($_POST['censored_words_enabled']),
        'censored_words' => secure($_POST['censored_words']),
        'censored_domains_enabled' => secure($_POST['censored_domains_enabled']),
        'censored_domains' => secure($_POST['censored_domains']),
        'html_richtext_enabled' => secure($_POST['html_richtext_enabled']),
        'reCAPTCHA_enabled' => secure($_POST['reCAPTCHA_enabled']),
        'reCAPTCHA_site_key' => secure($_POST['reCAPTCHA_site_key']),
        'reCAPTCHA_secret_key' => secure($_POST['reCAPTCHA_secret_key']),
        'turnstile_enabled' => secure($_POST['turnstile_enabled']),
        'turnstile_site_key' => secure($_POST['turnstile_site_key']),
        'turnstile_secret_key' => secure($_POST['turnstile_secret_key']),
      ]);
      break;

    case 'limits':
      /* update */
      update_system_options([
        'data_heartbeat' => secure($_POST['data_heartbeat']),
        'chat_heartbeat' => secure($_POST['chat_heartbeat']),
        'offline_time' => secure($_POST['offline_time']),
        'newsfeed_results' => secure($_POST['newsfeed_results']),
        'pages_results' => secure($_POST['pages_results']),
        'groups_results' => secure($_POST['groups_results']),
        'events_results' => secure($_POST['events_results']),
        'blogs_results' => secure($_POST['blogs_results']),
        'marketplace_results' => secure($_POST['marketplace_results']),
        'funding_results' => secure($_POST['funding_results']),
        'offers_results' => secure($_POST['offers_results']),
        'jobs_results' => secure($_POST['jobs_results']),
        'courses_results' => secure($_POST['courses_results']),
        'games_results' => secure($_POST['games_results']),
        'search_results' => secure($_POST['search_results']),
        'min_results' => secure($_POST['min_results']),
        'max_results' => secure($_POST['max_results']),
        'min_results_even' => secure($_POST['min_results_even']),
        'max_results_even' => secure($_POST['max_results_even'])
      ]);
      break;

    case 'analytics':
      /* update */
      update_system_options([
        'analytics_code' => secure($_POST['message'])
      ]);
      break;

    case 'wallet':
      $_POST['wallet_enabled'] = (isset($_POST['wallet_enabled'])) ? '1' : '0';
      $_POST['wallet_transfer_enabled'] = (isset($_POST['wallet_transfer_enabled'])) ? '1' : '0';
      $_POST['wallet_withdrawal_enabled'] = (isset($_POST['wallet_withdrawal_enabled'])) ? '1' : '0';
      if ($system['ads_enabled'] && !$_POST['wallet_enabled']) {
        throw new Exception(__("You can not disable wallet as long as Ads system enabled, Disable it first"));
      }
      $wallet_payment_methods = [];
      if (isset($_POST['method_paypal'])) {
        $wallet_payment_methods[] = "paypal";
      }
      if (isset($_POST['method_skrill'])) {
        $wallet_payment_methods[] = "skrill";
      }
      if (isset($_POST['method_moneypoolscash'])) {
        $wallet_payment_methods[] = "moneypoolscash";
      }
      if (isset($_POST['method_bank'])) {
        $wallet_payment_methods[] = "bank";
      }
      if (isset($_POST['method_custom'])) {
        $wallet_payment_methods[] = "custom";
      }
      if ($_POST['wallet_withdrawal_enabled'] && count($wallet_payment_methods) == 0) {
        throw new Exception(__("You must select one withdrawal payment method at least"));
      }
      $wallet_payment_method = implode(",", $wallet_payment_methods);
      /* update */
      update_system_options([
        'wallet_enabled' => secure($_POST['wallet_enabled']),
        'wallet_transfer_enabled' => secure($_POST['wallet_transfer_enabled']),
        'wallet_max_transfer' => secure($_POST['wallet_max_transfer']),
        'wallet_withdrawal_enabled' => secure($_POST['wallet_withdrawal_enabled']),
        'wallet_payment_method' => secure($wallet_payment_method),
        'wallet_payment_method_custom' => secure($_POST['wallet_payment_method_custom']),
        'wallet_min_withdrawal' => secure($_POST['wallet_min_withdrawal'])
      ]);
      break;

    case 'affiliates':
      /* prepare */
      $_POST['affiliates_enabled'] = (isset($_POST['affiliates_enabled'])) ? '1' : '0';
      $_POST['affiliates_money_withdraw_enabled'] = (isset($_POST['affiliates_money_withdraw_enabled'])) ? '1' : '0';
      $_POST['affiliates_money_transfer_enabled'] = (isset($_POST['affiliates_money_transfer_enabled'])) ? '1' : '0';
      if (!$_POST['affiliates_money_withdraw_enabled'] && !$_POST['affiliates_money_transfer_enabled']) {
        throw new Exception(__("You must enable one method at least, either payments withdrawal requests or wallet transfer"));
      }
      $affiliate_payment_methods = [];
      if (isset($_POST['method_paypal'])) {
        $affiliate_payment_methods[] = "paypal";
      }
      if (isset($_POST['method_skrill'])) {
        $affiliate_payment_methods[] = "skrill";
      }
      if (isset($_POST['method_moneypoolscash'])) {
        $affiliate_payment_methods[] = "moneypoolscash";
      }
      if (isset($_POST['method_bank'])) {
        $affiliate_payment_methods[] = "bank";
      }
      if (isset($_POST['method_custom'])) {
        $affiliate_payment_methods[] = "custom";
      }
      if ($_POST['affiliates_money_withdraw_enabled'] && count($affiliate_payment_methods) == 0) {
        throw new Exception(__("You must select one withdrawal payment method at least"));
      }
      if (is_empty($_POST['affiliates_levels']) || !is_numeric($_POST['affiliates_levels']) || $_POST['affiliates_levels'] <= 0) {
        throw new Exception(__("You must enter valid number for affiliates levels"));
      }
      $affiliate_payment_method = implode(",", $affiliate_payment_methods);
      /* update */
      update_system_options([
        'affiliates_enabled' => secure($_POST['affiliates_enabled']),
        'affiliates_money_withdraw_enabled' => secure($_POST['affiliates_money_withdraw_enabled']),
        'affiliate_payment_method' => secure($affiliate_payment_method),
        'affiliate_payment_method_custom' => secure($_POST['affiliate_payment_method_custom']),
        'affiliates_min_withdrawal' => secure($_POST['affiliates_min_withdrawal']),
        'affiliates_money_transfer_enabled' => secure($_POST['affiliates_money_transfer_enabled']),
        'affiliate_type' => secure($_POST['affiliate_type']),
        'affiliates_levels' => secure($_POST['affiliates_levels']),
        'affiliate_payment_type' => secure($_POST['affiliate_payment_type']),
        'affiliate_payment_to' => secure($_POST['affiliate_payment_to']),
        'affiliates_per_user' => secure($_POST['affiliates_per_user']),
        'affiliates_percentage' => secure($_POST['affiliates_percentage']),
        'affiliates_per_user_2' => secure($_POST['affiliates_per_user_2']),
        'affiliates_percentage_2' => secure($_POST['affiliates_percentage_2']),
        'affiliates_per_user_3' => secure($_POST['affiliates_per_user_3']),
        'affiliates_percentage_3' => secure($_POST['affiliates_percentage_3']),
        'affiliates_per_user_4' => secure($_POST['affiliates_per_user_4']),
        'affiliates_percentage_4' => secure($_POST['affiliates_percentage_4']),
        'affiliates_per_user_5' => secure($_POST['affiliates_per_user_5']),
        'affiliates_percentage_5' => secure($_POST['affiliates_percentage_5']),
      ]);
      break;

    case 'points':
      /* prepare */
      $_POST['points_enabled'] = (isset($_POST['points_enabled'])) ? '1' : '0';
      $_POST['points_money_withdraw_enabled'] = (isset($_POST['points_money_withdraw_enabled'])) ? '1' : '0';
      $_POST['points_money_transfer_enabled'] = (isset($_POST['points_money_transfer_enabled'])) ? '1' : '0';
      if (!$_POST['points_money_withdraw_enabled'] && !$_POST['points_money_transfer_enabled']) {
        throw new Exception(__("You must enable one method at least, either payments withdrawal requests or wallet transfer"));
      }
      $points_payment_methods = [];
      if (isset($_POST['method_paypal'])) {
        $points_payment_methods[] = "paypal";
      }
      if (isset($_POST['method_skrill'])) {
        $points_payment_methods[] = "skrill";
      }
      if (isset($_POST['method_moneypoolscash'])) {
        $points_payment_methods[] = "moneypoolscash";
      }
      if (isset($_POST['method_bank'])) {
        $points_payment_methods[] = "bank";
      }
      if (isset($_POST['method_custom'])) {
        $points_payment_methods[] = "custom";
      }
      if ($_POST['points_money_withdraw_enabled'] && count($points_payment_methods) == 0) {
        throw new Exception(__("You must select one withdrawal payment method at least"));
      }
      $points_payment_method = implode(",", $points_payment_methods);
      /* update */
      update_system_options([
        'points_enabled' => secure($_POST['points_enabled']),
        'points_money_withdraw_enabled' => secure($_POST['points_money_withdraw_enabled']),
        'points_payment_method' => secure($points_payment_method),
        'points_payment_method_custom' => secure($_POST['points_payment_method_custom']),
        'points_min_withdrawal' => secure($_POST['points_min_withdrawal']),
        'points_money_transfer_enabled' => secure($_POST['points_money_transfer_enabled']),
        'points_per_currency' => secure($_POST['points_per_currency'], 'int'),
        'points_per_post' => secure($_POST['points_per_post'], 'int'),
        'points_per_post_view' => secure($_POST['points_per_post_view'], 'float'),
        'points_per_post_comment' => secure($_POST['points_per_post_comment'], 'int'),
        'points_per_post_reaction' => secure($_POST['points_per_post_reaction'], 'int'),
        'points_per_comment' => secure($_POST['points_per_comment'], 'int'),
        'points_per_reaction' => secure($_POST['points_per_reaction'], 'int'),
        'points_per_follow' => secure($_POST['points_per_follow'], 'int'),
        'points_per_referred' => secure($_POST['points_per_referred'], 'int'),
        'points_limit_user' => secure($_POST['points_limit_user'], 'int'),
        'points_limit_pro' => secure($_POST['points_limit_pro'], 'int')
      ]);
      break;

    case 'market':
      /* valid inputs */
      if (!is_numeric($_POST['market_delivery_days']) || $_POST['market_delivery_days'] <= 0) {
        throw new Exception(__("Please enter valid delivery days"));
      }
      if (!is_numeric($_POST['market_commission']) || $_POST['market_commission'] < 0 || $_POST['market_commission'] >= 100) {
        throw new Exception(__("Please enter valid commission >= 0 and < 100"));
      }
      /* prepare */
      $_POST['market_enabled'] = (isset($_POST['market_enabled'])) ? '1' : '0';
      $_POST['market_shopping_cart_enabled'] = (isset($_POST['market_shopping_cart_enabled'])) ? '1' : '0';
      $_POST['market_wallet_payment_enabled'] = (isset($_POST['market_wallet_payment_enabled'])) ? '1' : '0';
      $_POST['market_cod_payment_enabled'] = (isset($_POST['market_cod_payment_enabled'])) ? '1' : '0';
      $_POST['market_money_withdraw_enabled'] = (isset($_POST['market_money_withdraw_enabled'])) ? '1' : '0';
      $_POST['market_money_transfer_enabled'] = (isset($_POST['market_money_transfer_enabled'])) ? '1' : '0';
      if (!$_POST['market_money_withdraw_enabled'] && !$_POST['market_money_transfer_enabled']) {
        throw new Exception(__("You must enable one method at least, either payments withdrawal requests or wallet transfer"));
      }
      $market_payment_methods = [];
      if (isset($_POST['method_paypal'])) {
        $market_payment_methods[] = "paypal";
      }
      if (isset($_POST['method_skrill'])) {
        $market_payment_methods[] = "skrill";
      }
      if (isset($_POST['method_moneypoolscash'])) {
        $market_payment_methods[] = "moneypoolscash";
      }
      if (isset($_POST['method_bank'])) {
        $market_payment_methods[] = "bank";
      }
      if (isset($_POST['method_custom'])) {
        $market_payment_methods[] = "custom";
      }
      if ($_POST['market_money_withdraw_enabled'] && count($market_payment_methods) == 0) {
        throw new Exception(__("You must select one withdrawal payment method at least"));
      }
      $market_payment_method = implode(",", $market_payment_methods);
      /* update */
      update_system_options([
        'market_enabled' => secure($_POST['market_enabled']),
        'market_shopping_cart_enabled' => secure($_POST['market_shopping_cart_enabled']),
        'market_wallet_payment_enabled' => secure($_POST['market_wallet_payment_enabled']),
        'market_cod_payment_enabled' => secure($_POST['market_cod_payment_enabled']),
        'market_delivery_days' => secure($_POST['market_delivery_days']),
        'market_money_withdraw_enabled' => secure($_POST['market_money_withdraw_enabled']),
        'market_payment_method' => secure($market_payment_method),
        'market_payment_method_custom' => secure($_POST['market_payment_method_custom']),
        'market_min_withdrawal' => secure($_POST['market_min_withdrawal']),
        'market_money_transfer_enabled' => secure($_POST['market_money_transfer_enabled']),
        'market_commission' => secure($_POST['market_commission'])
      ]);
      break;

    case 'funding':
      /* valid inputs */
      if (!is_numeric($_POST['funding_commission']) || $_POST['funding_commission'] < 0 || $_POST['funding_commission'] >= 100) {
        throw new Exception(__("Please enter valid commission >= 0 and < 100"));
      }
      /* prepare */
      $_POST['funding_enabled'] = (isset($_POST['funding_enabled'])) ? '1' : '0';
      $_POST['funding_wallet_payment_enabled'] = (isset($_POST['funding_wallet_payment_enabled'])) ? '1' : '0';
      $_POST['funding_money_withdraw_enabled'] = (isset($_POST['funding_money_withdraw_enabled'])) ? '1' : '0';
      $_POST['funding_money_transfer_enabled'] = (isset($_POST['funding_money_transfer_enabled'])) ? '1' : '0';
      if (!$_POST['funding_money_withdraw_enabled'] && !$_POST['funding_money_transfer_enabled']) {
        throw new Exception(__("You must enable one method at least, either payments withdrawal requests or wallet transfer"));
      }
      $funding_payment_methods = [];
      if (isset($_POST['method_paypal'])) {
        $funding_payment_methods[] = "paypal";
      }
      if (isset($_POST['method_skrill'])) {
        $funding_payment_methods[] = "skrill";
      }
      if (isset($_POST['method_moneypoolscash'])) {
        $funding_payment_methods[] = "moneypoolscash";
      }
      if (isset($_POST['method_bank'])) {
        $funding_payment_methods[] = "bank";
      }
      if (isset($_POST['method_custom'])) {
        $funding_payment_methods[] = "custom";
      }
      if ($_POST['funding_money_withdraw_enabled'] && count($funding_payment_methods) == 0) {
        throw new Exception(__("You must select one withdrawal payment method at least"));
      }
      $funding_payment_method = implode(",", $funding_payment_methods);
      /* update */
      update_system_options([
        'funding_enabled' => secure($_POST['funding_enabled']),
        'funding_wallet_payment_enabled' => secure($_POST['funding_wallet_payment_enabled']),
        'funding_money_withdraw_enabled' => secure($_POST['funding_money_withdraw_enabled']),
        'funding_payment_method' => secure($funding_payment_method),
        'funding_payment_method_custom' => secure($_POST['funding_payment_method_custom']),
        'funding_min_withdrawal' => secure($_POST['funding_min_withdrawal']),
        'funding_money_transfer_enabled' => secure($_POST['funding_money_transfer_enabled']),
        'funding_commission' => secure($_POST['funding_commission'])
      ]);
      break;

    case 'tips':
      /* valid inputs */
      if (!is_numeric($_POST['tips_min_amount']) || $_POST['tips_min_amount'] <= 0) {
        throw new Exception(__("Please enter valid minimum tip amount"));
      }
      if (!is_numeric($_POST['tips_max_amount']) || $_POST['tips_max_amount'] <= 0) {
        throw new Exception(__("Please enter valid maximum tip amount"));
      }
      /* prepare */
      $_POST['tips_enabled'] = (isset($_POST['tips_enabled'])) ? '1' : '0';
      /* update */
      update_system_options([
        'tips_enabled' => secure($_POST['tips_enabled']),
        'tips_min_amount' => secure($_POST['tips_min_amount']),
        'tips_max_amount' => secure($_POST['tips_max_amount']),
      ]);
      break;

    case 'cronjob':
      /* prepare */
      $_POST['cronjob_enabled'] = (isset($_POST['cronjob_enabled'])) ? '1' : '0';
      $_POST['cronjob_undelivered_orders'] = (isset($_POST['cronjob_undelivered_orders'])) ? '1' : '0';
      $_POST['cronjob_reset_pro_packages'] = (isset($_POST['cronjob_reset_pro_packages'])) ? '1' : '0';
      $_POST['cronjob_merits_reminder'] = (isset($_POST['cronjob_merits_reminder'])) ? '1' : '0';
      /* update */
      update_system_options([
        'cronjob_enabled' => secure($_POST['cronjob_enabled']),
        'cronjob_undelivered_orders' => secure($_POST['cronjob_undelivered_orders']),
        'cronjob_reset_pro_packages' => secure($_POST['cronjob_reset_pro_packages']),
        'cronjob_merits_reminder' => secure($_POST['cronjob_merits_reminder']),
      ]);
      break;

    case 'merits_settings':
      /* prepare */
      $_POST['merits_enabled'] = (isset($_POST['merits_enabled'])) ? '1' : '0';
      /* update */
      update_system_options([
        'merits_enabled' => secure($_POST['merits_enabled']),
        'merits_peroid_max' => secure($_POST['merits_peroid_max']),
        'merits_send_peroid_max' => secure($_POST['merits_send_peroid_max']),
        'merits_peroid' => secure($_POST['merits_peroid']),
        'merits_peroid_reset' => secure($_POST['merits_peroid_reset']),
      ]);
      break;

    case 'merits_notifications':
      /* prepare */
      $_POST['merits_notifications_recharge'] = (isset($_POST['merits_notifications_recharge'])) ? '1' : '0';
      $_POST['merits_notifications_reminder'] = (isset($_POST['merits_notifications_reminder'])) ? '1' : '0';
      $_POST['merits_notifications_recipient'] = (isset($_POST['merits_notifications_recipient'])) ? '1' : '0';
      $_POST['merits_notifications_sender'] = (isset($_POST['merits_notifications_sender'])) ? '1' : '0';
      /* update */
      update_system_options([
        'merits_notifications_recharge' => secure($_POST['merits_notifications_recharge']),
        'merits_notifications_reminder' => secure($_POST['merits_notifications_reminder']),
        'merits_notifications_recipient' => secure($_POST['merits_notifications_recipient']),
        'merits_notifications_sender' => secure($_POST['merits_notifications_sender']),
      ]);
      break;

    case 'merits_widgets':
      /* prepare */
      $_POST['merits_widgets_newsfeed'] = (isset($_POST['merits_widgets_newsfeed'])) ? '1' : '0';
      $_POST['merits_widgets_balance'] = (isset($_POST['merits_widgets_balance'])) ? '1' : '0';
      $_POST['merits_widgets_winners'] = (isset($_POST['merits_widgets_winners'])) ? '1' : '0';
      $_POST['merits_widgets_statistics'] = (isset($_POST['merits_widgets_statistics'])) ? '1' : '0';
      /* update */
      update_system_options([
        'merits_widgets_newsfeed' => secure($_POST['merits_widgets_newsfeed']),
        'merits_widgets_balance' => secure($_POST['merits_widgets_balance']),
        'merits_widgets_winners' => secure($_POST['merits_widgets_winners']),
        'merits_widgets_statistics' => secure($_POST['merits_widgets_statistics']),
      ]);
      break;

    case 'pwa':
      /* prepare */
      $_POST['pwa_enabled'] = (isset($_POST['pwa_enabled'])) ? '1' : '0';
      $_POST['pwa_banner_enabled'] = (isset($_POST['pwa_banner_enabled'])) ? '1' : '0';
      /* update */
      update_system_options([
        'pwa_enabled' => secure($_POST['pwa_enabled']),
        'pwa_banner_enabled' => secure($_POST['pwa_banner_enabled']),
        'pwa_192_icon' => secure($_POST['pwa_192_icon']),
        'pwa_512_icon' => secure($_POST['pwa_512_icon']),
      ]);
      break;

    case 'apis':
      /* update */
      update_system_options([
        'system_api_key' => secure($_POST['system_api_key']),
        'system_api_secret' => secure($_POST['system_api_secret']),
        'system_jwt_key' => secure($_POST['system_jwt_key']),
      ]);
      break;

    default:
      _error(400);
      break;
  }
  return_json(['success' => true, 'message' => __("Settings have been updated")]);
} catch (Exception $e) {
  return_json(['error' => true, 'message' => $e->getMessage()]);
}
