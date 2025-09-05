<?php
/**
 * settings
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich - Handles - @sorydima @sorydev @durovshater @DmitrySoro90935 @tanechfund - also check https://dmitry.rechain.network for more information!
 */

if(isset($_GET['view']) && $_GET['view'] == "download") {
	set_time_limit(0); /* unlimited max execution time */
}

// fetch bootstrap
require('bootstrap.php');

// user access
user_access();

try {

	// get view content
	switch ($_GET['view']) {
		case '':
			// page header
			page_header(__("Settings")." &rsaquo; ".__("Account Settings"));
			break;

		case 'profile':

			// page header
			page_header(__("Settings")." &rsaquo; ".__("Edit Profile"));

			// get content
			switch ($_GET['sub_view']) {
				case '':
					// parse birthdate
					$user->_data['user_birthdate_parsed'] = date_parse($user->_data['user_birthdate']);

					// get countries
					$countries = $user->get_countries();
					/* assign variables */
					$smarty->assign('countries', $countries);
					break;

				case 'work':
					break;

				case 'location':
					break;

				case 'education':
					break;

				case 'social':
					break;

				case 'other':
					break;

				default:
					_error(404);
					break;
			}
			break;

		case 'security':
			// get content
			switch ($_GET['sub_view']) {
				case 'password':
					// page header
					page_header(__("Settings")." &rsaquo; ".__("Change Password"));
					break;

				case 'sessions':
					// page header
					page_header(__("Settings")." &rsaquo; ".__("Manage Sessions"));

					// get user sessions
					$sessions = array();
					$get_sessions = $db->query(sprintf("SELECT * FROM users_sessions WHERE user_id = %s", secure($user->_data['user_id'], 'int') )) or _error(SQL_ERROR);
					if($get_sessions->num_rows > 0) {
			            while($session = $get_sessions->fetch_assoc()) {
			            	$sessions[] = $session;
			            }
			        }
			        /* assign variables */
					$smarty->assign('sessions', $sessions);
					break;

				case 'two-factor':
					/* system two-factor disabled */
					if(!$system['two_factor_enabled']) {
						if($user->_data['user_two_factor_enabled']) {
							$user->disable_two_factor_authentication($user->_data['user_id']);
						}
		                _error(404);
		            }
		            /* check user two-factor */
					if($user->_data['user_two_factor_enabled']) {
						/* enabled */
			            /* system two-factor method != user two-factor method */
			            if($system['two_factor_type'] != $user->_data['user_two_factor_type']) {
			                $user->disable_two_factor_authentication($user->_data['user_id']);
			                reload();
			            }
			            /* system two-factor method = email but user email not verified */
			            if($system['two_factor_type'] == "email" && !$user->_data['user_email_verified']) {
			                $user->disable_two_factor_authentication($user->_data['user_id']);
			                reload();
			            }
			            /* system two-factor method = sms but not user phone not verified */
			            if($system['two_factor_type'] == "sms" && !$user->_data['user_phone_verified']) {
			                $user->disable_two_factor_authentication($user->_data['user_id']);
			                reload();
			            }
					} else {
						/* disabled */
						if($system['two_factor_type'] == "google") {
							/* Google Authenticator */
							require_once(ABSPATH.'includes/libs/GoogleAuthenticator/GoogleAuthenticator.php');
							$ga = new PHPGangsta_GoogleAuthenticator();
							/* get user gsecret */
							if(!$user->_data['user_two_factor_gsecret']) {
								/* create new gsecret */
								$two_factor_gsecret = $ga->createSecret();
								/* update user gsecret */
								$db->query(sprintf("UPDATE users SET user_two_factor_gsecret = %s WHERE user_id = %s", secure($two_factor_gsecret), secure($user->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
							} else {
								$two_factor_gsecret = $user->_data['user_two_factor_gsecret'];
							}
							/* get QR */
							$two_factor_QR = $ga->getQRCodeGoogleUrl($user->_data['user_email'], $two_factor_gsecret, $system['system_title']);
							/* assign variables */
							$smarty->assign('two_factor_gsecret', $two_factor_gsecret);
							$smarty->assign('two_factor_QR', $two_factor_QR);
						}
					}
					// page header
					page_header(__("Settings")." &rsaquo; ".__("Two-Factor Authentication"));
					break;

				default:
					_error(404);
					break;
			}
			break;

		case 'privacy':
			// page header
			page_header(__("Settings")." &rsaquo; ".__("Privacy"));
			break;

		case 'notifications':
			// page header
			page_header(__("Settings")." &rsaquo; ".__("Notifications"));

			// email notifications
			$email_notifications_enabled = false;
			if($system['email_notifications']) {
				if($system['email_post_likes'] || $system['email_post_comments'] || $system['email_post_shares'] || $system['email_wall_posts'] || $system['email_mentions'] || $system['email_profile_visits'] || $system['email_friend_requests'] || $system['email_page_likes'] || $system['email_group_joins']) {
	                $email_notifications_enabled = true;
	            }
			}
			/* assign variables */
			$smarty->assign('email_notifications_enabled', $email_notifications_enabled);
			break;

		case 'linked':
			if(!$system['social_login_enabled']) {
				_error(404);
			}
			if(!$system['facebook_login_enabled'] && !$system['twitter_login_enabled'] && !$system['google_login_enabled'] && !$system['instagram_login_enabled'] && !$system['linkedin_login_enabled'] && !$system['vkontakte_login_enabled']) {
                _error(404);
            }
			// page header
			page_header(__("Settings")." &rsaquo; ".__("Linked Accounts"));
			break;

		case 'membership':
			if(!$system['packages_enabled']) {
				_error(404);
			}
			// page header
			page_header(__("Settings")." &rsaquo; ".__("Membership"));

			// prepare user package
            if($user->_data['user_subscribed']) {
                switch ($user->_data['period']) {
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
                $user->_data['subscription_end'] = strtotime($user->_data['user_subscription_date']) + ($user->_data['period_num'] * $duration);
                $user->_data['subscription_timeleft'] = ceil(($user->_data['subscription_end'] - time()) / (60 * 60 * 24));
            }
			break;

		case 'affiliates':
			if(!$system['affiliates_enabled']) {
				_error(404);
			}

			// get content
			switch ($_GET['sub_view']) {
				case '':
					// page header
					page_header(__("Settings")." &rsaquo; ".__("Affiliates"));

					// get affiliates
					$affiliates = $user->get_affiliates($user->_data['user_id']);
					/* assign variables */
					$smarty->assign('affiliates', $affiliates);
					break;

				case 'payments':
					// page header
					page_header(__("Settings")." &rsaquo; ".__("Affiliates Payments"));

					// get payments
					$payments = array();
					$get_payments = $db->query(sprintf('SELECT * FROM affiliates_payments WHERE user_id = %s', secure($user->_data['user_id'], 'int'))) or _error(SQL_ERROR);
			        if($get_payments->num_rows > 0) {
			            while($payment = $get_payments->fetch_assoc()) {
			                $payments[] = $payment;
			            }
			        }
			        /* assign variables */
					$smarty->assign('payments', $payments);
					break;
			}
			break;

		case 'points':
			if(!$system['points_enabled']) {
				_error(404);
			}

			// get content
			switch ($_GET['sub_view']) {
				case '':
					// page header
					page_header(__("Settings")." &rsaquo; ".__("points"));
					break;

				case 'payments':
					// page header
					page_header(__("Settings")." &rsaquo; ".__("Points Payments"));

					// get payments
					$payments = array();
					$get_payments = $db->query(sprintf('SELECT * FROM points_payments WHERE user_id = %s', secure($user->_data['user_id'], 'int'))) or _error(SQL_ERROR);
			        if($get_payments->num_rows > 0) {
			            while($payment = $get_payments->fetch_assoc()) {
			                $payments[] = $payment;
			            }
			        }
			        /* assign variables */
					$smarty->assign('payments', $payments);
					break;
			}
			break;

		case 'verification':
			if(!$system['verification_requests']) {
				_error(404);
			}
			// page header
			page_header(__("Settings")." &rsaquo; ".__("Verification"));

			// check verification
			if($user->_data['user_verified']) {
				$case = "verified";
			} else {
				/* check verification request */
				$get_request = $db->query(sprintf("SELECT * FROM verification_requests WHERE node_id = %s AND node_type = 'user'", secure($user->_data['user_id']))) or _error(SQL_ERROR);
				if($get_request->num_rows > 0) {
					$request = $get_request->fetch_assoc();
					if($request['status'] == '1') {
						if($user->_data['user_verified']) {
							$case = "verified";
						} else {
							/* remove any request */
							$db->query(sprintf("DELETE FROM verification_requests WHERE request_id = %s", secure($request['request_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
							$case = "request";
						}
					} elseif ($request['status'] == '0') {
						$case = "pending";
					} else {
						$case = "declined";
					}
				} else {
					$case = "request";
				}
			}
			/* assign variables */
			$smarty->assign('case', $case);
			break;

		case 'blocking':
			// page header
			page_header(__("Settings")." &rsaquo; ".__("Blocking"));

			// get blocks
			$blocks = $user->get_blocked();
			/* assign variables */
			$smarty->assign('blocks', $blocks);
			break;

		case 'information':
			// page header
			page_header(__("Settings")." &rsaquo; ".__("Download Your Information"));
			break;

		case 'download':
			// download user information
			$user->download_user_information();
			break;

		case 'delete':
			if(!$system['delete_accounts_enabled']) {
				_error(404);
			}
			// page header
			page_header(__("Settings")." &rsaquo; ".__("Delete Account"));
			break;

		default:
		_error(404);
	}

	// get custom fields
	$smarty->assign('custom_fields', $user->get_custom_fields( array("for" => "user", "get" => "settings", "node_id" => $user->_data['user_id']) ));

	/* assign variables */
	$smarty->assign('view', $_GET['view']);
	$smarty->assign('sub_view', $_GET['sub_view']);

} catch (Exception $e) {
	_error(__("Error"), $e->getMessage());
}

// page footer
page_footer("settings");

?>