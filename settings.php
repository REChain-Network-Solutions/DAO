<?php

/**
 * settings
 * 
 * @package Delus
 * @author Dmitry
 */

// remove timeout limit
if (isset($_GET['view']) && $_GET['view'] == "download") {
  set_time_limit(0); /* unlimited max execution time */
}

// fetch bootloader
require('bootloader.php');

// user access
user_access(false, true);

try {

  // get view content
  switch ($_GET['view']) {
    case '':
      // page header
      page_header(__("Settings") . " &rsaquo; " . __("Account Settings"));
      break;

    case 'profile':
      // page header
      page_header(__("Settings") . " &rsaquo; " . __("Edit Profile"));

      // get content
      switch ($_GET['sub_view']) {
        case '':
          // parse birthdate
          $user->_data['user_birthdate_parsed'] = ($user->_data['user_birthdate']) ? date_parse($user->_data['user_birthdate']) : null;

          // get genders
          $smarty->assign('genders', $user->get_genders());

          // get countries if not defined
          if (!$countries) {
            $smarty->assign('countries', $user->get_countries());
          }
          break;

        case 'work':
          /* check if work info enabled */
          if (!$system['work_info_enabled']) {
            _error(404);
          }
          break;

        case 'location':
          /* check if location info enabled */
          if (!$system['location_info_enabled']) {
            _error(404);
          }
          break;

        case 'education':
          /* check if education info enabled */
          if (!$system['education_info_enabled']) {
            _error(404);
          }
          break;

        case 'other':
          break;

        case 'social':
          /* check if social links enabled */
          if (!$system['social_info_enabled']) {
            _error(404);
          }
          break;

        case 'design':
          /* check if profile background enabled */
          if (!$system['system_profile_background_enabled']) {
            _error(404);
          }
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
          page_header(__("Settings") . " &rsaquo; " . __("Change Password"));
          break;

        case 'sessions':
          // page header
          page_header(__("Settings") . " &rsaquo; " . __("Manage Sessions"));

          // get user sessions
          $sessions = [];
          if (!$user->_data['user_demo']) {
            $get_sessions = $db->query(sprintf("SELECT * FROM users_sessions WHERE user_id = %s", secure($user->_data['user_id'], 'int')));
            if ($get_sessions->num_rows > 0) {
              while ($session = $get_sessions->fetch_assoc()) {
                $sessions[] = $session;
              }
            }
          }
          /* assign variables */
          $smarty->assign('sessions', $sessions);
          break;

        case 'two-factor':
          // check if two-factor enabled
          if (!$system['two_factor_enabled']) {
            if ($user->_data['user_two_factor_enabled']) {
              /* disable two factor authentication for the user if enabled */
              $user->disable_two_factor_authentication($user->_data['user_id']);
            }
            _error(404);
          }

          // process
          /* check user two-factor */
          if ($user->_data['user_two_factor_enabled']) {
            /* enabled */
            /* system two-factor method != user two-factor method */
            if ($system['two_factor_type'] != $user->_data['user_two_factor_type']) {
              $user->disable_two_factor_authentication($user->_data['user_id']);
              reload();
            }
            /* system two-factor method = email but user email not verified */
            if ($system['two_factor_type'] == "email" && !$user->_data['user_email_verified']) {
              $user->disable_two_factor_authentication($user->_data['user_id']);
              reload();
            }
            /* system two-factor method = sms but not user phone not verified */
            if ($system['two_factor_type'] == "sms" && !$user->_data['user_phone_verified']) {
              $user->disable_two_factor_authentication($user->_data['user_id']);
              reload();
            }
          } else {
            /* disabled */
            if ($system['two_factor_type'] == "google") {
              /* Google Authenticator */
              $ga = new Sonata\GoogleAuthenticator\GoogleAuthenticator();
              /* get user gsecret */
              if (!$user->_data['user_two_factor_gsecret']) {
                /* create new gsecret */
                $two_factor_gsecret = $ga->generateSecret();
                /* update user gsecret */
                $db->query(sprintf("UPDATE users SET user_two_factor_gsecret = %s WHERE user_id = %s", secure($two_factor_gsecret), secure($user->_data['user_id'], 'int')));
              } else {
                $two_factor_gsecret = $user->_data['user_two_factor_gsecret'];
              }
              /* get QR */
              $two_factor_QR = \Sonata\GoogleAuthenticator\GoogleQrUrl::generate($user->_data['user_email'], $two_factor_gsecret, $system['system_title']);
              /* assign variables */
              $smarty->assign('two_factor_gsecret', $two_factor_gsecret);
              $smarty->assign('two_factor_QR', $two_factor_QR);
            }
          }

          // page header
          page_header(__("Settings") . " &rsaquo; " . __("Two-Factor Authentication"));
          break;

        default:
          _error(404);
          break;
      }
      break;

    case 'notifications':
      // page header
      page_header(__("Settings") . " &rsaquo; " . __("Notifications"));

      // email notifications
      $email_user_notifications_enabled = false;
      if ($system['email_notifications']) {
        if ($system['email_post_likes'] || $system['email_post_comments'] || $system['email_post_shares'] || $system['email_wall_posts'] || $system['email_mentions'] || $system['email_profile_visits'] || $system['email_friend_requests'] || $system['email_page_likes'] || $system['email_group_joins'] || ($system['verification_requests'] && $system['email_user_verification']) || ($system['posts_approval_enabled'] && $system['email_user_post_approval'])) {
          $email_user_notifications_enabled = true;
        }
      }
      $email_admin_notifications_enabled = false;
      if ($system['email_notifications']) {
        if ($system['email_admin_verifications'] || $system['email_admin_post_approval'] || $system['email_admin_user_approval']) {
          $email_admin_notifications_enabled = true;
        }
      }
      /* assign variables */
      $smarty->assign('email_user_notifications_enabled', $email_user_notifications_enabled);
      $smarty->assign('email_admin_notifications_enabled', $email_admin_notifications_enabled);
      break;

    case 'verification':
      if (!$system['verification_requests']) {
        _error(404);
      }
      // page header
      page_header(__("Settings") . " &rsaquo; " . __("Verification"));

      // check verification
      if ($user->_data['user_verified']) {
        $case = "verified";
        $user->delete_all_verification_requests($user->_data['user_id'], 'user');
      } else {
        /* check latest verification request */
        $get_last_request = $db->query(sprintf("SELECT * FROM verification_requests WHERE node_id = %s AND node_type = 'user' ORDER BY request_id DESC LIMIT 1", secure($user->_data['user_id'])));
        if ($get_last_request->num_rows > 0) {
          $last_request = $get_last_request->fetch_assoc();
          if ($last_request['status'] == '1') {
            $case = "request";
            $user->delete_all_verification_requests($user->_data['user_id'], 'user');
          } elseif ($last_request['status'] == '0') {
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

    case 'privacy':
      // page header
      page_header(__("Settings") . " &rsaquo; " . __("Privacy"));
      break;

    case 'blocking':
      // page header
      page_header(__("Settings") . " &rsaquo; " . __("Blocking"));

      // get blocks
      $blocks = $user->get_blocked();
      /* assign variables */
      $smarty->assign('blocks', $blocks);
      break;

    case 'accounts':
      // check if switch accounts enabled
      if (!$system['switch_accounts_enabled']) {
        _error(404);
      }

      // page header
      page_header(__("Settings") . " &rsaquo; " . __("Connected Accounts"));
      break;

    case 'linked':
      // check if social login enabled
      if (!$system['social_login_enabled']) {
        _error(404);
      }
      if (!$system['facebook_login_enabled'] && !$system['twitter_login_enabled'] && !$system['google_login_enabled'] && !$system['linkedin_login_enabled'] && !$system['vkontakte_login_enabled'] && !$system['wordpress_login_enabled'] && !$system['Delus_login_enabled']) {
        _error(404);
      }

      // page header
      page_header(__("Settings") . " &rsaquo; " . __("Linked Accounts"));
      break;

    case 'membership':
      // check if packages enabled
      if (!$system['packages_enabled']) {
        _error(404);
      }

      // page header
      page_header(__("Settings") . " &rsaquo; " . __("Membership"));

      // prepare user package
      if ($user->_data['user_subscribed']) {
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

      // package allowed categories
      if ($user->_data['can_pick_categories']) {
        // get videos categories
        $smarty->assign('videos_categories', $user->get_categories("posts_videos_categories"));
        // get blogs categories
        $smarty->assign('blogs_categories', $user->get_categories("blogs_categories"));
      }
      break;

    case 'monetization':
      // check monetization permission
      if (!$user->_data['can_monetize_content']) {
        _error(404);
      }

      // get content
      switch ($_GET['sub_view']) {
        case '':
          // page header
          page_header(__("Settings") . " &rsaquo; " . __("Monetization"));

          // get monetozaion plans
          $smarty->assign('monetization_plans', $user->get_monetization_plans());

          // get subscribers count
          $smarty->assign('subscribers_count', $user->get_subscribers_count());
          break;

        case 'payments':
          // check if affiliates withdraw enabled
          if (!$system['monetization_money_withdraw_enabled']) {
            _error(404);
          }

          // page header
          page_header(__("Settings") . " &rsaquo; " . __("Monetization Payments"));

          // get payments
          $payments = [];
          $get_payments = $db->query(sprintf('SELECT * FROM monetization_payments WHERE user_id = %s', secure($user->_data['user_id'], 'int')));
          if ($get_payments->num_rows > 0) {
            while ($payment = $get_payments->fetch_assoc()) {
              $payments[] = $payment;
            }
          }
          /* assign variables */
          $smarty->assign('payments', $payments);
          break;

        case 'earnings':
          // page header
          page_header(__("Settings") . " &rsaquo; " . __("Monetization Earnings"));

          // get earnings
          $earnings = [];
          $get_earnings = $db->query(sprintf("SELECT log_subscriptions.*, users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, users.user_subscribed, users.user_verified FROM log_subscriptions INNER JOIN users ON log_subscriptions.subscriber_id = users.user_id WHERE log_subscriptions.node_id = %s AND log_subscriptions.node_type = 'profile'", secure($user->_data['user_id'], 'int')));
          if ($get_earnings->num_rows > 0) {
            while ($earning = $get_earnings->fetch_assoc()) {
              $earning['user_picture'] = get_picture($earning['user_picture'], $earning['user_gender']);
              $earning['user_fullname'] = ($system['show_usernames_enabled']) ? $earning['user_name'] : $earning['user_firstname'] . " " . $earning['user_lastname'];
              $earning['earning'] = $earning['price'] - $earning['commission'];
              $earnings[] = $earning;
            }
          }
          /* assign variables */
          $smarty->assign('earnings', $earnings);

          // get total earnings
          $total_earnings = $db->query(sprintf("SELECT SUM(price - commission) as total_earnings FROM log_subscriptions WHERE node_id = %s AND node_type = 'profile'", secure($user->_data['user_id'], 'int')))->fetch_assoc();
          $smarty->assign('total_earnings', $total_earnings['total_earnings']);

          // get this month earnings
          $this_month_earnings = $db->query(sprintf("SELECT SUM(price - commission) as this_month_earnings FROM log_subscriptions WHERE node_id = %s AND node_type = 'profile' AND YEAR(`time`) = YEAR(CURRENT_DATE()) AND MONTH(`time`) = MONTH(CURRENT_DATE())", secure($user->_data['user_id'], 'int')))->fetch_assoc();
          $smarty->assign('this_month_earnings', $this_month_earnings['this_month_earnings']);
          break;

        default:
          _error(404);
          break;
      }
      break;

    case 'invitations':
      // check if packages enabled
      if (!$user->_data['can_invite_users']) {
        _error(404);
      }

      // page header
      page_header(__("Settings") . " &rsaquo; " . __("Invitations"));

      // get invitation codes
      $smarty->assign('invitation_codes', $user->get_invitation_codes_details());

      // get user invitation codes stats
      $smarty->assign('invitation_codes_stats', $user->get_invitation_codes_stats());
      break;

    case 'affiliates':
      // check if affiliates enabled
      if (!$system['affiliates_enabled']) {
        _error(404);
      }

      // get content
      switch ($_GET['sub_view']) {
        case '':
          // page header
          page_header(__("Settings") . " &rsaquo; " . __("Affiliates"));

          // get affiliates
          $affiliates = $user->get_affiliates($user->_data['user_id']);
          /* assign variables */
          $smarty->assign('affiliates', $affiliates);
          break;

        case 'payments':
          // check if affiliates withdraw enabled
          if (!$system['affiliates_money_withdraw_enabled']) {
            _error(404);
          }

          // page header
          page_header(__("Settings") . " &rsaquo; " . __("Affiliates Payments"));

          // get payments
          $payments = [];
          $get_payments = $db->query(sprintf('SELECT * FROM affiliates_payments WHERE user_id = %s', secure($user->_data['user_id'], 'int')));
          if ($get_payments->num_rows > 0) {
            while ($payment = $get_payments->fetch_assoc()) {
              $payments[] = $payment;
            }
          }
          /* assign variables */
          $smarty->assign('payments', $payments);
          break;

        default:
          _error(404);
          break;
      }
      break;

    case 'points':
      // check if points enabled
      if (!$system['points_enabled']) {
        _error(404);
      }

      // get content
      switch ($_GET['sub_view']) {
        case '':
          // page header
          page_header(__("Settings") . " &rsaquo; " . __("Points"));

          // get remaining balance
          $smarty->assign('remaining_points', $user->get_remaining_points($user->_data['user_id']));

          // get points transactions
          $transactions = $user->get_points_transactions();
          /* assign variables */
          $smarty->assign('transactions', $transactions);
          break;

        case 'payments':
          // check if points withdraw enabled
          if ($system['points_per_currency'] == 0 || !$system['points_money_withdraw_enabled']) {
            _error(404);
          }

          // page header
          page_header(__("Settings") . " &rsaquo; " . __("Points Payments"));

          // get payments
          $payments = [];
          $get_payments = $db->query(sprintf('SELECT * FROM points_payments WHERE user_id = %s', secure($user->_data['user_id'], 'int')));
          if ($get_payments->num_rows > 0) {
            while ($payment = $get_payments->fetch_assoc()) {
              $payments[] = $payment;
            }
          }
          /* assign variables */
          $smarty->assign('payments', $payments);
          break;

        default:
          _error(404);
          break;
      }
      break;

    case 'market':
      // check market permission
      if (!$user->_data['can_sell_products'] || !$system['market_shopping_cart_enabled']) {
        _error(404);
      }

      // page header
      page_header(__("Settings") . " &rsaquo; " . __("Marketplace"));

      // get payments
      $payments = [];
      $get_payments = $db->query(sprintf('SELECT * FROM market_payments WHERE user_id = %s', secure($user->_data['user_id'], 'int')));
      if ($get_payments->num_rows > 0) {
        while ($payment = $get_payments->fetch_assoc()) {
          $payments[] = $payment;
        }
      }
      /* assign variables */
      $smarty->assign('payments', $payments);
      break;

    case 'funding':
      // check funding permission
      if (!$user->_data['can_raise_funding']) {
        _error(404);
      }

      // page header
      page_header(__("Settings") . " &rsaquo; " . __("Funding"));

      // get payments
      $payments = [];
      $get_payments = $db->query(sprintf('SELECT * FROM funding_payments WHERE user_id = %s', secure($user->_data['user_id'], 'int')));
      if ($get_payments->num_rows > 0) {
        while ($payment = $get_payments->fetch_assoc()) {
          $payments[] = $payment;
        }
      }
      /* assign variables */
      $smarty->assign('payments', $payments);
      break;

    case 'coinpayments':
      // check if coinpayments enabled
      if (!$system['coinpayments_enabled']) {
        _error(404);
      }

      // page header
      page_header(__("Settings") . " &rsaquo; " . __("CoinPayments Transactions"));

      // get coinpayments transactions
      $coinpayments_transactions = $user->get_coinpayments_transactions();
      /* assign variables */
      $smarty->assign('coinpayments_transactions', $coinpayments_transactions);
      break;

    case 'bank':
      // check if bank transfers enabled
      if (!$system['bank_transfers_enabled']) {
        _error(404);
      }

      // page header
      page_header(__("Settings") . " &rsaquo; " . __("Bank Transfers"));

      // get bank transfers
      $transfers = [];
      $get_transfers = $db->query(sprintf('SELECT bank_transfers.*, packages.name as package_name, packages.price as package_price FROM bank_transfers LEFT JOIN packages ON bank_transfers.package_id = packages.package_id WHERE bank_transfers.user_id = %s', secure($user->_data['user_id'], 'int')));
      if ($get_transfers->num_rows > 0) {
        while ($transfer = $get_transfers->fetch_assoc()) {
          $transfers[] = $transfer;
        }
      }
      /* assign variables */
      $smarty->assign('transfers', $transfers);
      break;

    case 'apps':
      // check if developers (apps) enabled
      if (!$system['developers_apps_enabled']) {
        _error(404);
      }

      // page header
      page_header(__("Settings") . " &rsaquo; " . __("Apps"));

      // get apps
      $apps = $user->get_user_apps();
      /* assign variables */
      $smarty->assign('apps', $apps);
      break;

    case 'addresses':
      // page header
      page_header(__("Settings") . " &rsaquo; " . __("Your Addresses"));

      // get addresses
      $smarty->assign('addresses', $user->get_addresses());
      break;

    case 'information':
      // check if download info enabled
      if (!$system['download_info_enabled']) {
        _error(404);
      }

      // page header
      page_header(__("Settings") . " &rsaquo; " . __("Your Information"));
      break;

    case 'download':
      // check if download info enabled
      if (!$system['download_info_enabled']) {
        _error(404);
      }

      // download user information
      $user->download_user_information();
      break;

    case 'delete':
      // check if delete accounts enabled
      if (!$system['delete_accounts_enabled']) {
        _error(404);
      }

      // page header
      page_header(__("Settings") . " &rsaquo; " . __("Delete Account"));
      break;

    default:
      _error(404);
      break;
  }

  // get custom fields
  $smarty->assign('custom_fields', $user->get_custom_fields(["for" => "user", "get" => "settings", "node_id" => $user->_data['user_id']]));

  /* assign variables */
  $smarty->assign('view', $_GET['view']);
  $smarty->assign('sub_view', $_GET['sub_view']);
} catch (Exception $e) {
  _error(__("Error"), $e->getMessage());
}

// page footer
page_footer('settings');
