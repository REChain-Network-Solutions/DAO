<?php
/**
 * ajax -> admin -> settings
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich
 */

// fetch bootstrap
require('../../../bootstrap.php');

// check AJAX Request
is_ajax();


// check admin logged in
if(!$user->_logged_in || !$user->_is_admin) {
	modal(MESSAGE, __("System Message"), __("You don't have the right permission to access this"));
}

// edit settings
try {

	switch ($_GET['edit']) {
		case 'general_settings':
			$_POST['system_public'] = (isset($_POST['system_public']))? '1' : '0';
			$_POST['system_live'] = (isset($_POST['system_live']))? '1' : '0';
			$db->query(sprintf("UPDATE system_options SET 
						system_public = %s, 
						system_live = %s, 
						system_message = %s, 
						system_title = %s, 
						system_description = %s, 
						system_keywords = %s, 
						system_email = %s ", secure($_POST['system_public']), secure($_POST['system_live']), secure($_POST['system_message']), secure($_POST['system_title']), secure($_POST['system_description']), secure($_POST['system_keywords']), secure($_POST['system_email']) )) or _error(SQL_ERROR_THROWEN);
			break;

		case 'features_settings':
			$_POST['contact_enabled'] = (isset($_POST['contact_enabled']))? '1' : '0';
			$_POST['directory_enabled'] = (isset($_POST['directory_enabled']))? '1' : '0';
			$_POST['pages_enabled'] = (isset($_POST['pages_enabled']))? '1' : '0';
			$_POST['groups_enabled'] = (isset($_POST['groups_enabled']))? '1' : '0';
			$_POST['events_enabled'] = (isset($_POST['events_enabled']))? '1' : '0';
			$_POST['blogs_enabled'] = (isset($_POST['blogs_enabled']))? '1' : '0';
			$_POST['market_enabled'] = (isset($_POST['market_enabled']))? '1' : '0';
			$_POST['games_enabled'] = (isset($_POST['games_enabled']))? '1' : '0';
			$_POST['daytime_msg_enabled'] = (isset($_POST['daytime_msg_enabled']))? '1' : '0';
			$_POST['verification_requests'] = (isset($_POST['verification_requests']))? '1' : '0';
			$_POST['profile_notification_enabled'] = (isset($_POST['profile_notification_enabled']))? '1' : '0';
			$db->query(sprintf("UPDATE system_options SET 
						contact_enabled = %s, 
						directory_enabled = %s, 
						pages_enabled = %s, 
						groups_enabled = %s, 
						events_enabled = %s, 
						blogs_enabled = %s, 
						market_enabled = %s, 
						games_enabled = %s, 
						daytime_msg_enabled = %s, 
						verification_requests = %s, 
						profile_notification_enabled = %s ", secure($_POST['contact_enabled']), secure($_POST['directory_enabled']), secure($_POST['pages_enabled']), secure($_POST['groups_enabled']), secure($_POST['events_enabled']), secure($_POST['blogs_enabled']), secure($_POST['market_enabled']), secure($_POST['games_enabled']), secure($_POST['daytime_msg_enabled']), secure($_POST['verification_requests']), secure($_POST['profile_notification_enabled']) )) or _error(SQL_ERROR_THROWEN);
			break;

		case 'posts':
			$_POST['stories_enabled'] = (isset($_POST['stories_enabled']))? '1' : '0';
			$_POST['wall_posts_enabled'] = (isset($_POST['wall_posts_enabled']))? '1' : '0';
			$_POST['social_share_enabled'] = (isset($_POST['social_share_enabled']))? '1' : '0';
			$_POST['smart_yt_player'] = (isset($_POST['smart_yt_player']))? '1' : '0';
			$_POST['geolocation_enabled'] = (isset($_POST['geolocation_enabled']))? '1' : '0';
			$db->query(sprintf("UPDATE system_options SET 
						stories_enabled = %s, 
						wall_posts_enabled = %s, 
						social_share_enabled = %s, 
						smart_yt_player = %s, 
						geolocation_enabled = %s, 
						geolocation_key = %s, 
						default_privacy = %s", secure($_POST['stories_enabled']), secure($_POST['wall_posts_enabled']), secure($_POST['social_share_enabled']), secure($_POST['smart_yt_player']), secure($_POST['geolocation_enabled']), secure($_POST['geolocation_key']), secure($_POST['default_privacy']) )) or _error(SQL_ERROR_THROWEN);
			break;

		case 'registration':
			$_POST['registration_enabled'] = (isset($_POST['registration_enabled']))? '1' : '0';
			$_POST['packages_enabled'] = (isset($_POST['packages_enabled']) || $_POST['registration_type'] == "paid")? '1' : '0';
			$_POST['activation_enabled'] = (isset($_POST['activation_enabled']))? '1' : '0';
			$_POST['age_restriction'] = (isset($_POST['age_restriction']))? '1' : '0';
			$_POST['getting_started'] = (isset($_POST['getting_started']))? '1' : '0';
			$_POST['delete_accounts_enabled'] = (isset($_POST['delete_accounts_enabled']))? '1' : '0';
			$db->query(sprintf("UPDATE system_options SET 
						registration_enabled = %s, 
						registration_type = %s, 
						packages_enabled = %s, 
						activation_enabled = %s, 
						activation_type = %s, 
						age_restriction = %s, 
						minimum_age = %s, 
						getting_started = %s, 
						delete_accounts_enabled = %s, 
						max_accounts = %s ", secure($_POST['registration_enabled']), secure($_POST['registration_type']), secure($_POST['packages_enabled']), secure($_POST['activation_enabled']), secure($_POST['activation_type']), secure($_POST['age_restriction']), secure($_POST['minimum_age']), secure($_POST['getting_started']), secure($_POST['delete_accounts_enabled']), secure($_POST['max_accounts']) )) or _error(SQL_ERROR_THROWEN);
			break;

		case 'social_login':
			$_POST['social_login_enabled'] = (isset($_POST['social_login_enabled']))? '1' : '0';
			$_POST['facebook_login_enabled'] = (isset($_POST['facebook_login_enabled']))? '1' : '0';
			$_POST['twitter_login_enabled'] = (isset($_POST['twitter_login_enabled']))? '1' : '0';
			$_POST['google_login_enabled'] = (isset($_POST['google_login_enabled']))? '1' : '0';
			$_POST['instagram_login_enabled'] = (isset($_POST['instagram_login_enabled']))? '1' : '0';
			$_POST['linkedin_login_enabled'] = (isset($_POST['linkedin_login_enabled']))? '1' : '0';
			$_POST['vkontakte_login_enabled'] = (isset($_POST['vkontakte_login_enabled']))? '1' : '0';
			$db->query(sprintf("UPDATE system_options SET 
						social_login_enabled = %s, 
						facebook_login_enabled = %s, 
						facebook_appid = %s, 
						facebook_secret = %s, 
						twitter_login_enabled = %s, 
						twitter_appid = %s, 
						twitter_secret = %s, 
						google_login_enabled = %s, 
						google_appid = %s, 
						google_secret = %s, 
						instagram_login_enabled = %s, 
						instagram_appid = %s, 
						instagram_secret = %s, 
						linkedin_login_enabled = %s, 
						linkedin_appid = %s, 
						linkedin_secret = %s, 
						vkontakte_login_enabled = %s, 
						vkontakte_appid = %s, 
						vkontakte_secret = %s ", secure($_POST['social_login_enabled']), secure($_POST['facebook_login_enabled']), secure($_POST['facebook_appid']), secure($_POST['facebook_secret']), secure($_POST['twitter_login_enabled']), secure($_POST['twitter_appid']), secure($_POST['twitter_secret']), secure($_POST['google_login_enabled']), secure($_POST['google_appid']), secure($_POST['google_secret']), secure($_POST['instagram_login_enabled']), secure($_POST['instagram_appid']), secure($_POST['instagram_secret']), secure($_POST['linkedin_login_enabled']), secure($_POST['linkedin_appid']), secure($_POST['linkedin_secret']), secure($_POST['vkontakte_login_enabled']), secure($_POST['vkontakte_appid']), secure($_POST['vkontakte_secret']) )) or _error(SQL_ERROR_THROWEN);
			break;

		case 'emails':
			$_POST['email_smtp_enabled'] = (isset($_POST['email_smtp_enabled']))? '1' : '0';
			$_POST['email_smtp_authentication'] = (isset($_POST['email_smtp_authentication']))? '1' : '0';
			$_POST['email_smtp_ssl'] = (isset($_POST['email_smtp_ssl']))? '1' : '0';
			$db->query(sprintf("UPDATE system_options SET 
						email_smtp_enabled = %s, 
						email_smtp_authentication = %s, 
						email_smtp_ssl = %s, 
						email_smtp_server = %s, 
						email_smtp_port = %s, 
						email_smtp_username = %s, 
						email_smtp_password = %s, 
						email_smtp_setfrom = %s ", secure($_POST['email_smtp_enabled']), secure($_POST['email_smtp_authentication']), secure($_POST['email_smtp_ssl']), secure($_POST['email_smtp_server']), secure($_POST['email_smtp_port']), secure($_POST['email_smtp_username']), secure($_POST['email_smtp_password']), secure($_POST['email_smtp_setfrom']) )) or _error(SQL_ERROR_THROWEN);
			break;

		case 'email_notifications':
			$_POST['email_notifications'] = (isset($_POST['email_notifications']))? '1' : '0';
			$_POST['email_post_likes'] = (isset($_POST['email_post_likes']))? '1' : '0';
			$_POST['email_post_comments'] = (isset($_POST['email_post_comments']))? '1' : '0';
			$_POST['email_post_shares'] = (isset($_POST['email_post_shares']))? '1' : '0';
			$_POST['email_wall_posts'] = (isset($_POST['email_wall_posts']))? '1' : '0';
			$_POST['email_mentions'] = (isset($_POST['email_mentions']))? '1' : '0';
			$_POST['email_profile_visits'] = (isset($_POST['email_profile_visits']))? '1' : '0';
			$_POST['email_friend_requests'] = (isset($_POST['email_friend_requests']))? '1' : '0';
			$db->query(sprintf("UPDATE system_options SET 
						email_notifications = %s, 
						email_post_likes = %s, 
						email_post_comments = %s, 
						email_post_shares = %s, 
						email_wall_posts = %s, 
						email_mentions = %s, 
						email_profile_visits = %s, 
						email_friend_requests = %s ", secure($_POST['email_notifications']), secure($_POST['email_post_likes']), secure($_POST['email_post_comments']), secure($_POST['email_post_shares']), secure($_POST['email_wall_posts']), secure($_POST['email_mentions']), secure($_POST['email_profile_visits']), secure($_POST['email_friend_requests']) )) or _error(SQL_ERROR_THROWEN);
			break;

		case 'sms':
			$db->query(sprintf("UPDATE system_options SET 
						twilio_sid = %s, 
						twilio_token = %s, 
						twilio_phone = %s, 
						system_phone = %s ", secure($_POST['twilio_sid']), secure($_POST['twilio_token']), secure($_POST['twilio_phone']), secure($_POST['system_phone']) )) or _error(SQL_ERROR_THROWEN);
			break;

		case 'chat':
			$_POST['chat_enabled'] = (isset($_POST['chat_enabled']))? '1' : '0';
			$_POST['chat_status_enabled'] = (isset($_POST['chat_status_enabled']))? '1' : '0';
			$db->query(sprintf("UPDATE system_options SET 
						chat_enabled = %s, 
						chat_status_enabled = %s ", secure($_POST['chat_enabled']), secure($_POST['chat_status_enabled']) )) or _error(SQL_ERROR_THROWEN);
			break;

		case 'uploads':
			$_POST['photos_enabled'] = (isset($_POST['photos_enabled']))? '1' : '0';
			$_POST['videos_enabled'] = (isset($_POST['videos_enabled']))? '1' : '0';
			$_POST['audio_enabled'] = (isset($_POST['audio_enabled']))? '1' : '0';
			$_POST['file_enabled'] = (isset($_POST['file_enabled']))? '1' : '0';
			$db->query(sprintf("UPDATE system_options SET 
						uploads_directory = %s, 
						uploads_prefix = %s, 
						max_avatar_size = %s, 
						max_cover_size = %s, 
						photos_enabled = %s, 
						max_photo_size = %s, 
						videos_enabled = %s, 
						max_video_size = %s, 
						video_extensions = %s, 
						audio_enabled = %s, 
						max_audio_size = %s, 
						audio_extensions = %s,
						file_enabled = %s, 
						max_file_size = %s, 
						file_extensions = %s ", secure($_POST['uploads_directory']), secure($_POST['uploads_prefix']), secure($_POST['max_avatar_size']), secure($_POST['max_cover_size']), secure($_POST['photos_enabled']), secure($_POST['max_photo_size']), secure($_POST['videos_enabled']), secure($_POST['max_video_size']), secure($_POST['video_extensions']), secure($_POST['audio_enabled']), secure($_POST['max_audio_size']), secure($_POST['audio_extensions']), secure($_POST['file_enabled']), secure($_POST['max_file_size']), secure($_POST['file_extensions']) )) or _error(SQL_ERROR_THROWEN);
			break;

		case 's3':
			$_POST['s3_enabled'] = (isset($_POST['s3_enabled']))? '1' : '0';
			$db->query(sprintf("UPDATE system_options SET 
						s3_enabled = %s,
						s3_bucket = %s,
						s3_region = %s,
						s3_key = %s,
						s3_secret = %s ", secure($_POST['s3_enabled']), secure($_POST['s3_bucket']), secure($_POST['s3_region']), secure($_POST['s3_key']), secure($_POST['s3_secret']) )) or _error(SQL_ERROR_THROWEN);
			break;

		case 'security':
			$_POST['censored_words_enabled'] = (isset($_POST['censored_words_enabled']))? '1' : '0';
			$_POST['reCAPTCHA_enabled'] = (isset($_POST['reCAPTCHA_enabled']))? '1' : '0';
			$db->query(sprintf("UPDATE system_options SET 
						censored_words_enabled = %s, 
						censored_words = %s, 
						reCAPTCHA_enabled = %s, 
						reCAPTCHA_site_key = %s, 
						reCAPTCHA_secret_key = %s", secure($_POST['censored_words_enabled']), secure($_POST['censored_words']), secure($_POST['reCAPTCHA_enabled']), secure($_POST['reCAPTCHA_site_key']), secure($_POST['reCAPTCHA_secret_key']) )) or _error(SQL_ERROR_THROWEN);
			break;

		case 'paypal':
			$_POST['paypal_enabled'] = (isset($_POST['paypal_enabled']))? '1' : '0';
			$db->query(sprintf("UPDATE system_options SET 
						paypal_enabled = %s, 
						paypal_mode = %s, 
						paypal_id = %s, 
						paypal_secret = %s", secure($_POST['paypal_enabled']), secure($_POST['paypal_mode']), secure($_POST['paypal_id']), secure($_POST['paypal_secret']) )) or _error(SQL_ERROR_THROWEN);
			break;

		case 'stripe':
			$_POST['creditcard_enabled'] = (isset($_POST['creditcard_enabled']))? '1' : '0';
			$_POST['bitcoin_enabled'] = (isset($_POST['bitcoin_enabled']))? '1' : '0';
			$_POST['alipay_enabled'] = (isset($_POST['alipay_enabled']))? '1' : '0';
			$db->query(sprintf("UPDATE system_options SET 
						creditcard_enabled = %s, 
						alipay_enabled = %s, 
						bitcoin_enabled = %s, 
						stripe_mode = %s, 
						stripe_test_secret = %s, 
						stripe_test_publishable = %s, 
						stripe_live_secret = %s, 
						stripe_live_publishable = %s", secure($_POST['creditcard_enabled']), secure($_POST['alipay_enabled']), secure($_POST['bitcoin_enabled']), secure($_POST['stripe_mode']), secure($_POST['stripe_test_secret']), secure($_POST['stripe_test_publishable']), secure($_POST['stripe_live_secret']), secure($_POST['stripe_live_publishable']) )) or _error(SQL_ERROR_THROWEN);
			break;

		case 'currency':
			$db->query(sprintf("UPDATE system_options SET 
						system_currency = %s", secure($_POST['system_currency']) )) or _error(SQL_ERROR_THROWEN);
			break;

		case 'limits':
			$db->query(sprintf("UPDATE system_options SET 
						data_heartbeat = %s, 
						chat_heartbeat = %s, 
						offline_time = %s, 
						min_results = %s, 
						max_results = %s, 
						min_results_even = %s, 
						max_results_even = %s", secure($_POST['data_heartbeat']), secure($_POST['chat_heartbeat']), secure($_POST['offline_time']), secure($_POST['min_results']), secure($_POST['max_results']), secure($_POST['min_results_even']), secure($_POST['max_results_even']) )) or _error(SQL_ERROR_THROWEN);
			break;

		case 'analytics':
			$db->query(sprintf("UPDATE system_options SET 
						analytics_code = %s ", secure($_POST['message']) )) or _error(SQL_ERROR_THROWEN);
			break;

		case 'affiliates':
			$_POST['affiliates_enabled'] = (isset($_POST['affiliates_enabled']))? '1' : '0';
			$db->query(sprintf("UPDATE system_options SET 
						affiliates_enabled = %s, 
						affiliate_type = %s, 
						affiliate_payment_method = %s, 
						affiliates_min_withdrawal = %s, 
						affiliates_per_user = %s ", secure($_POST['affiliates_enabled']), secure($_POST['affiliate_type']), secure($_POST['affiliate_payment_method']), secure($_POST['affiliates_min_withdrawal']), secure($_POST['affiliates_per_user']) )) or _error(SQL_ERROR_THROWEN);
			break;

		default:
			_error(400);
			break;
	}
	return_json( array('success' => true, 'message' => __("System settings have been updated")) );

} catch (Exception $e) {
	return_json( array('error' => true, 'message' => $e->getMessage()) );
}

?>