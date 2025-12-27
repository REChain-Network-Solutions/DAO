<?php

/**
 * class -> user
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich
 */

/* 
 * Index:
 * ----------------
 * Traits
 * Properties
 * Constructor
 * User Groups & Permissions
 * Get Ids
 * Get Users
 * User & Connections
 * Popovers
 * User Settings
 * Verifications
 * Addresses
 * Download User Information
 * User Sign (in|up|out)
 * Login As
 * Connected Accounts
 * Getting Started
 * Social Login
 * Two-Factor Authentication
 * Password
 * Activation Email
 * Activation Phone
 */

// include all trait files
foreach (glob(__DIR__ . '/traits/*.php') as $filename) {
  require_once $filename;
}

class User
{

  /* ------------------------------- */
  /* Traits */
  /* ------------------------------- */

  use AdsTrait,
    AffiliatesTrait,
    AnnouncementsTrait,
    BlogsTrait,
    CallsTrait,
    CategoriesTrait,
    ChatTrait,
    CommentsTrait,
    CoursesTrait,
    CustomFieldsTrait,
    DevelopersTrait,
    EventsTrait,
    ForumsTrait,
    FundingTrait,
    GamesTrait,
    GiftsTrait,
    GroupsTrait,
    HashtagsTrait,
    InvitationsTrait,
    JobsTrait,
    LiveStreamTrait,
    LoggerTrait,
    MarketplaceTrait,
    MentionsTrait,
    MeritsTrait,
    MonetizationTrait,
    MoviesTrait,
    NotificationsTrait,
    PackagesTrait,
    PagesTrait,
    PaymentsTrait,
    PhotosTrait,
    PointsTrait,
    PostsTrait,
    PublisherTrait,
    EmojiesStickersTrait,
    RealtimeTrait,
    ReelsTrait,
    ReportsTrait,
    ReviewsTrait,
    SearchTrait,
    StoriesTrait,
    SupportTrait,
    SystemTrait,
    ToolsTrait,
    VideosTrait,
    WalletTrait,
    WidgetsTrait;



  /* ------------------------------- */
  /* Properties */
  /* ------------------------------- */

  public $_login_as = false;
  public $_logged_in = false;
  public $_is_admin = false;
  public $_is_moderator = false;
  public $_is_banned = false;
  public $_data = [];
  public $_master_data = [];

  private $_cookie_user_id = "c_user";
  private $_cookie_user_token = "xs";
  private $_cookie_user_jwt = "user_jwt";
  private $_cookie_user_referrer = "ref";
  private $_cookie_user_login_as = "log_as";
  private $_cookie_user_session = "user_session";



  /* ------------------------------- */
  /* Constructor ✅ */
  /* ------------------------------- */

  /**
   * __construct ✅
   * 
   * @param string $jwt
   * @return void
   */
  public function __construct($jwt = null)
  {
    global $db, $system;
    if (isset($_COOKIE[$this->_cookie_user_id]) && isset($_COOKIE[$this->_cookie_user_token])) {
      $user_id = $_COOKIE[$this->_cookie_user_id];
      $user_token = $_COOKIE[$this->_cookie_user_token];
    } elseif (isset(_getallheaders()["x-auth-token"]) || $jwt) {
      try {
        $jwt = ($jwt) ? $jwt : _getallheaders()["x-auth-token"];
        $jwt = (array) Firebase\JWT\JWT::decode($jwt, new Firebase\JWT\Key($system['system_jwt_key'], 'HS256'));
        $user_id = $jwt['uid'];
        $user_token = $jwt['token'];
      } catch (Exception $e) {
        // throw new Exception($e->getMessage());
      }
    }
    if (isset($user_id) && isset($user_token)) {
      $get_user = $db->query(sprintf("SELECT users.*, users_groups.*, users_sessions.*, posts_photos.source as user_picture_full, packages.*, packages.name as package_name FROM users INNER JOIN users_sessions ON users.user_id = users_sessions.user_id LEFT JOIN posts_photos ON users.user_picture_id = posts_photos.photo_id LEFT JOIN packages ON users.user_subscribed = '1' AND users.user_package = packages.package_id LEFT JOIN users_groups ON users.user_group = '3' AND users.user_group_custom != '0' AND users.user_group_custom = users_groups.user_group_id WHERE users_sessions.user_id = %s AND users_sessions.session_token = %s", secure($user_id, 'int'), secure($user_token)));
      if ($get_user->num_rows > 0) {
        $this->_data = $get_user->fetch_assoc();
        /* check if there is 'login as' cookie */
        if ($this->_data['user_group'] == '1' && isset($_COOKIE[$this->_cookie_user_login_as]) && $_COOKIE[$this->_cookie_user_login_as] != $this->_data['user_id'] && $_COOKIE[$this->_cookie_user_login_as] != '1') {
          $login_as = $_COOKIE[$this->_cookie_user_login_as];
          $get_login_as = $db->query(sprintf("SELECT users.*, users_groups.*, users_sessions.*, posts_photos.source as user_picture_full, packages.*, packages.name as package_name, COALESCE(users.user_id, users_sessions.user_id) AS user_id FROM users LEFT JOIN users_sessions ON users.user_id = users_sessions.user_id LEFT JOIN posts_photos ON users.user_picture_id = posts_photos.photo_id LEFT JOIN packages ON users.user_subscribed = '1' AND users.user_package = packages.package_id LEFT JOIN users_groups ON users.user_group = '3' AND users.user_group_custom != '0' AND users.user_group_custom = users_groups.user_group_id WHERE users.user_id = %s", secure($login_as, 'int')));
          if ($get_login_as->num_rows > 0) {
            $login_as_user = $get_login_as->fetch_assoc();
            /* check this user is not admin */
            $this->_login_as = true;
            /* transfer old _data to _old_data */
            $this->_master_data = $this->_data;
            /* set new _data */
            $this->_data = $login_as_user;
          }
        }
        /* check if master account is not set */
        if ($this->_data['user_master_account'] == 0) {
          $db->query(sprintf("UPDATE users SET user_master_account = user_id WHERE user_id = %s", secure($this->_data['user_id'], 'int')));
          $this->_data['user_master_account'] = $this->_data['user_id'];
        }
        /* get user permissions group */
        if ($this->_data['user_group'] == '3') {
          $user_permissions_group = 1;
          if ($system['packages_enabled'] && $this->_data['user_subscribed']) {
            if ($this->_data['package_permissions_group_id']) {
              $user_permissions_group = $this->_data['package_permissions_group_id'];
            } elseif ($this->_data['user_verified']) {
              $user_permissions_group = 2;
            }
          } else {
            if ($this->_data['user_group_custom'] != '0') {
              $user_permissions_group = $this->_data['permissions_group_id'];
            } elseif ($this->_data['user_verified']) {
              $user_permissions_group = 2;
            }
          }
          $this->_data['user_permissions_group'] = $this->get_permissions_group($user_permissions_group);
        }
        /* get master connected accounts */
        $this->_data['connected_accounts'] = $this->get_connected_accounts($this->_data['user_master_account']);
        /* prepare full name */
        $this->_data['user_fullname'] = ($system['show_usernames_enabled']) ? $this->_data['user_name'] : $this->_data['user_firstname'] . " " . $this->_data['user_lastname'];
        /* check unusual login */
        if (!$this->_login_as && $system['unusual_login_enabled'] && !defined('SKIP_UNUSUAL_LOGIN_CHECK')) {
          if ($this->_data['user_ip'] != get_user_ip()) {
            return;
          }
        }
        $this->_logged_in = true;
        $this->_is_admin = ($this->_data['user_group'] == 1) ? true : false;
        $this->_is_moderator = ($this->_data['user_group'] == 2) ? true : false;
        $this->_is_banned = (!$this->_is_admin && $this->_data['user_banned']) ? true : false;
        $this->_data['user_banned_message'] = ($this->_data['user_banned_message']) ? $this->_data['user_banned_message'] : __("Your account has been banned");
        /* check if user adult */
        $this->_data['user_age'] = get_user_age($this->_data['user_birthdate']);
        $this->_data['user_adult'] = ($this->_data['user_age'] >= 18) ? true : false;
        /* update user language */
        if ($system['current_language'] != $this->_data['user_language']) {
          $db->query(sprintf("UPDATE users SET user_language = %s WHERE user_id = %s", secure($system['current_language']), secure($this->_data['user_id'], 'int')));
        }
        /* update user last seen */
        $db->query(sprintf("UPDATE users SET user_last_seen = NOW() WHERE user_id = %s", secure($this->_data['user_id'], 'int')));
        /* active session */
        $this->_data['active_session_id'] = $this->_data['session_id'];
        $this->_data['active_session_token'] = $this->_data['session_token'];
        /* get user picture */
        $this->_data['user_picture_default'] = ($this->_data['user_picture']) ? false : true;
        $this->_data['user_picture_raw'] = $this->_data['user_picture'];
        $this->_data['user_picture'] = get_picture($this->_data['user_picture'], $this->_data['user_gender']);
        $this->_data['user_picture_full'] = ($this->_data['user_picture_full']) ? $system['system_uploads'] . '/' . $this->_data['user_picture_full'] : $this->_data['user_picture_full'];
        /* get all friends ids */
        $this->_data['friends_ids'] = $this->get_friends_ids();
        /* get all followings ids */
        $this->_data['followings_ids'] = $this->get_followings_ids();
        /* get all friend requests ids */
        $this->_data['friend_requests_ids'] = $this->get_friend_requests_ids();
        /* get all friend requests sent ids */
        $this->_data['friend_requests_sent_ids'] = $this->get_friend_requests_sent_ids();
        /* package permissions */
        $this->_data['can_boost_posts'] = false;
        $this->_data['can_boost_pages'] = false;
        $this->_data['can_pick_categories'] = false;
        $this->_data['user_products_limit'] = 0; /* 0 = unlimited */
        if ($system['packages_enabled'] && ($this->_is_admin || $this->_data['user_subscribed'])) {
          if ($this->_is_admin || ($this->_data['boost_posts_enabled'] && ($this->_data['user_boosted_posts'] < $this->_data['boost_posts']))) {
            $this->_data['can_boost_posts'] = true;
          }
          if ($this->_is_admin || ($this->_data['boost_pages_enabled'] && ($this->_data['user_boosted_pages'] < $this->_data['boost_pages']))) {
            $this->_data['can_boost_pages'] = true;
          }
          if ($this->_is_admin || ($this->_data['boost_groups_enabled'] && ($this->_data['user_boosted_groups'] < $this->_data['boost_groups']))) {
            $this->_data['can_boost_groups'] = true;
          }
          if ($this->_is_admin || ($this->_data['boost_events_enabled'] && ($this->_data['user_boosted_events'] < $this->_data['boost_events']))) {
            $this->_data['can_boost_events'] = true;
          }
          if ($this->_data['allowed_videos_categories'] > 0 || $this->_data['allowed_blogs_categories'] > 0) {
            $this->_data['can_pick_categories'] = true;
          }
          $this->_data['user_products_limit'] = $this->_data['allowed_products'];
        }
        /* get allowed videos & blogs categories ids */
        $this->_data['user_package_videos_categories_ids'] = ($this->_data['user_package_videos_categories']) ? array_column(json_decode(html_entity_decode($this->_data['user_package_videos_categories']), true), "id") : [];
        $this->_data['user_package_blogs_categories_ids'] = ($this->_data['user_package_blogs_categories']) ? array_column(json_decode(html_entity_decode($this->_data['user_package_blogs_categories']), true), "id") : [];
        /* check pages permission */
        $this->_data['can_create_pages'] = $system['pages_enabled'] && $this->check_module_permission('pages_permission');
        /* check groups permission */
        $this->_data['can_create_groups'] = $system['groups_enabled'] && $this->check_module_permission('groups_permission');
        /* check events permission */
        $this->_data['can_create_events'] = $system['events_enabled'] && $this->check_module_permission('events_permission');
        /* check reels permission */
        $this->_data['can_add_reels'] = $system['reels_enabled'] && $this->check_module_permission('reels_permission');
        /* check watch permission */
        $this->_data['can_watch_videos'] = $system['watch_enabled'] && $this->check_module_permission('watch_permission');
        /* check blogs permission */
        $this->_data['can_write_blogs'] = $system['blogs_enabled'] && $this->check_module_permission('blogs_permission');
        /* check blogs read permission */
        $this->_data['can_read_blogs'] = $system['blogs_enabled'] && $this->check_module_permission('blogs_permission_read');
        /* check market permission */
        $this->_data['can_sell_products'] = $system['market_enabled'] && $this->check_module_permission('market_permission');
        /* check offers permission */
        $this->_data['can_create_offers'] = $system['offers_enabled'] && $this->check_module_permission('offers_permission');
        /* check offers read permission */
        $this->_data['can_read_offers'] = $system['offers_enabled'] && $this->check_module_permission('offers_permission_read');
        /* check jobs permission */
        $this->_data['can_create_jobs'] = $system['jobs_enabled'] && $this->check_module_permission('jobs_permission');
        /* check courses permission */
        $this->_data['can_create_courses'] = $system['courses_enabled'] && $this->check_module_permission('courses_permission');
        /* check forums permission */
        $this->_data['can_use_forums'] = $system['forums_enabled'] && $this->check_module_permission('forums_permission');
        /* check movies permission */
        $this->_data['can_watch_movies'] = $system['movies_enabled'] && $this->check_module_permission('movies_permission');
        /* check games permission */
        $this->_data['can_play_games'] = $system['games_enabled'] && $this->check_module_permission('games_permission');
        /* check gifts permission */
        $this->_data['can_send_gifts'] = $system['gifts_enabled'] && $this->check_module_permission('gifts_permission');
        /* check stories permission */
        $this->_data['can_add_stories'] = $system['stories_enabled'] && $this->check_module_permission('stories_permission');
        /* check posts permission */
        $this->_data['can_publish_posts'] = $this->check_module_permission('posts_permission');
        /* check scheduled posts permission */
        $this->_data['can_schedule_posts'] = $system['posts_schedule_enabled'] && $this->check_module_permission('schedule_posts_permission');
        /* check colored posts permission */
        $this->_data['can_add_colored_posts'] = $system['colored_posts_enabled'] && $this->check_module_permission('colored_posts_permission');
        /* check activity posts permission */
        $this->_data['can_add_activity_posts'] = $system['activity_posts_enabled'] && $this->check_module_permission('activity_posts_permission');
        /* check polls posts permission */
        $this->_data['can_add_polls_posts'] = $system['polls_enabled'] && $this->check_module_permission('polls_posts_permission');
        /* check geolocation posts permission */
        $this->_data['can_add_geolocation_posts'] = $system['geolocation_enabled'] && $this->check_module_permission('geolocation_posts_permission');
        /* check gif posts permission */
        $this->_data['can_add_gif_posts'] = $system['gif_enabled'] && $this->check_module_permission('gif_posts_permission');
        /* check anonymous posts permission */
        $this->_data['can_add_anonymous_posts'] = $system['anonymous_mode'] && $this->check_module_permission('anonymous_posts_permission');
        /* check invitation permission */
        $this->_data['can_invite_users'] = $system['invitation_enabled'] && $this->check_module_permission('invitation_permission');
        /* check audio call permission */
        $this->_data['can_start_audio_call'] = $system['audio_call_enabled'] && $this->check_module_permission('audio_call_permission');
        /* check video call permission */
        $this->_data['can_start_video_call'] = $system['video_call_enabled'] && $this->check_module_permission('video_call_permission');
        /* check live stream permission */
        $this->_data['can_go_live'] = $system['live_enabled'] && $this->check_module_permission('live_permission');
        /* check videos upload permission */
        $this->_data['can_upload_videos'] = $system['videos_enabled'] && $this->check_module_permission('videos_upload_permission');
        /* check audios upload permission */
        $this->_data['can_upload_audios'] = $system['audio_enabled'] && $this->check_module_permission('audios_upload_permission');
        /* check files upload permission */
        $this->_data['can_upload_files'] = $system['file_enabled'] && $this->check_module_permission('files_upload_permission');
        /* check ads permission */
        $this->_data['can_create_ads'] = $system['ads_enabled'] && $this->check_module_permission('ads_permission');
        /* check funding permission */
        $this->_data['can_raise_funding'] = $system['funding_enabled'] && $this->check_module_permission('funding_permission');
        /* check monetization permission */
        $this->_data['can_monetize_content'] = $system['monetization_enabled'] && $this->check_module_permission('monetization_permission');
        /* check tip permission */
        $this->_data['can_receive_tip'] = $system['tips_enabled'] && $this->check_module_permission('tips_permission');
        /* check is user ads free */
        $this->_data['ads_free'] = $system['packages_enabled'] && $this->_data['user_subscribed'] && $system['packages_ads_free_enabled'];
        /* check custom points per currency */
        $system['points_per_currency'] = ($this->_data['user_permissions_group']['custom_points_system']) ? $this->_data['user_permissions_group']['points_per_currency'] : $system['points_per_currency'];
      }
    }
  }



  /* ------------------------------- */
  /* User Groups & Permissions */
  /* ------------------------------- */

  /**
   * check_module_permission
   * 
   * @param string $permission
   * @return boolean
   */
  public function check_module_permission($permission)
  {
    /* check if user is admin or moderator */
    if ($this->_is_admin || $this->_is_moderator) {
      return true;
    }
    return ($this->_data['user_permissions_group'][$permission]) ? true : false;
  }


  /**
   * check_module_package_permission
   * 
   * @param string $permission
   * @return boolean
   */
  public function check_module_package_permission($permission)
  {
    global $system, $db;
    if ($system['packages_enabled']) {
      $check_permission = $db->query(sprintf("SELECT COUNT(*) AS count FROM packages WHERE package_permissions_group_id IN (SELECT permissions_group_id FROM permissions_groups WHERE %s = '1')", secure($permission)));
      if ($check_permission->fetch_assoc()['count'] > 0) {
        return true;
      }
    }
    return false;
  }


  /**
   * check user permission
   * 
   * @param integer $user_id
   * @param string $permission
   * @return boolean
   */
  public function check_user_permission($user_id, $permission)
  {
    global $db, $system;
    $get_profile = $db->query(sprintf("SELECT users.user_id, users.user_group, users.user_group_custom, users.user_verified, users.user_subscribed , users_groups.permissions_group_id, packages.package_permissions_group_id FROM users LEFT JOIN packages ON users.user_subscribed = '1' AND users.user_package = packages.package_id LEFT JOIN users_groups ON users.user_group = '3' AND users.user_group_custom != '0' AND users.user_group_custom = users_groups.user_group_id WHERE users.user_id = %s", secure($user_id, 'int')));
    if ($get_profile->num_rows == 0) {
      return false;
    }
    $profile = $get_profile->fetch_assoc();
    /* if user is admin or moderator */
    if ($profile['user_group'] < '3') {
      return true;
    }
    /* get profile permissions group */
    $user_permissions_group = 1;
    /* check if pro packages enabled and user subscribed */
    if ($system['packages_enabled'] && $profile['user_subscribed']) {
      if ($profile['package_permissions_group_id']) {
        $user_permissions_group = $profile['package_permissions_group_id'];
      } elseif ($profile['user_verified']) {
        $user_permissions_group = 2;
      }
    } else {
      if ($profile['user_group_custom'] != '0') {
        $user_permissions_group = $profile['permissions_group_id'];
      } elseif ($profile['user_verified']) {
        $user_permissions_group = 2;
      }
    }
    $profile['user_permissions_group'] = $this->get_permissions_group($user_permissions_group);
    return ($profile['user_permissions_group'][$permission]) ? true : false;
  }


  /**
   * get_users_groups
   * 
   * @return array
   */
  public function get_users_groups()
  {
    global $db;
    $users_groups = [];
    $get_users_groups = $db->query("SELECT users_groups.*, permissions_groups.permissions_group_title, (SELECT COUNT(*) as count FROM users WHERE user_group_custom = users_groups.user_group_id) AS users_count FROM users_groups INNER JOIN permissions_groups ON users_groups.permissions_group_id = permissions_groups.permissions_group_id ORDER BY users_groups.user_group_id ASC");
    if ($get_users_groups->num_rows > 0) {
      while ($group = $get_users_groups->fetch_assoc()) {
        $users_groups[] = $group;
      }
    }
    return $users_groups;
  }


  /**
   * get_user_group
   * 
   * @param integer $user_group_id
   * @return boolean|array
   */
  public function get_user_group($user_group_id)
  {
    global $db;
    $get_user_group = $db->query(sprintf("SELECT users_groups.*, permissions_groups.permissions_group_title, (SELECT COUNT(*) as count FROM users WHERE user_group_custom = users_groups.user_group_id) AS users_count FROM users_groups INNER JOIN permissions_groups ON users_groups.permissions_group_id = permissions_groups.permissions_group_id WHERE user_group_id = %s", secure($user_group_id, 'int')));
    if ($get_user_group->num_rows == 0) {
      return false;
    }
    return $get_user_group->fetch_assoc();
  }


  /**
   * check_user_group
   * 
   * @param integer $user_group_id
   * @return boolean
   */
  public function check_user_group($user_group_id)
  {
    global $db;
    $check = $db->query(sprintf("SELECT COUNT(*) as count FROM users_groups INNER JOIN permissions_groups ON users_groups.permissions_group_id = permissions_groups.permissions_group_id WHERE user_group_id = %s", secure($user_group_id, 'int')));
    if ($check->fetch_assoc()['count'] > 0) {
      return true;
    }
    return false;
  }


  /**
   * get_permissions_groups
   * 
   * @return array
   */
  public function get_permissions_groups()
  {
    global $db;
    $permissions_groups = [];
    $get_permissions_groups = $db->query("SELECT permissions_group_id, permissions_group_title FROM permissions_groups WHERE permissions_group_id > 2 ORDER BY permissions_group_id ASC");
    if ($get_permissions_groups->num_rows > 0) {
      while ($permission_group = $get_permissions_groups->fetch_assoc()) {
        $permissions_groups[] = $permission_group;
      }
    }
    return $permissions_groups;
  }


  /**
   * get_permissions_group
   * 
   * @param integer $permissions_group_id
   * @return false|array
   */
  public function get_permissions_group($permissions_group_id)
  {
    global $db;
    $get_permissions_group = $db->query(sprintf("SELECT * FROM permissions_groups WHERE permissions_group_id = %s", secure($permissions_group_id, 'int')));
    if ($get_permissions_group->num_rows == 0) {
      return false;
    }
    return $get_permissions_group->fetch_assoc();
  }


  /**
   * check_permissions_group
   * 
   * @param integer $permissions_group_id
   * @return boolean
   */
  public function check_permissions_group($permissions_group_id)
  {
    global $db;
    $check = $db->query(sprintf("SELECT COUNT(*) as count FROM permissions_groups WHERE permissions_group_id = %s", secure($permissions_group_id, 'int')));
    if ($check->fetch_assoc()['count'] > 0) {
      return true;
    }
    return false;
  }



  /* ------------------------------- */
  /* Get Ids */
  /* ------------------------------- */

  /**
   * get_friends_ids
   * 
   * @param integer $user_id
   * @return array
   */
  public function get_friends_ids($user_id = null)
  {
    global $db;
    $user_id = (isset($user_id)) ? $user_id : $this->_data['user_id'];
    $friends = [];
    $get_friends = $db->query(sprintf('
          SELECT
            user_id
          FROM (
              SELECT
                  f.user_two_id AS friend_id
              FROM friends AS f
              WHERE f.status = 1 AND f.user_one_id = %1$s
              UNION
              SELECT
                  f.user_one_id AS friend_id
              FROM friends AS f
              WHERE f.status = 1 AND f.user_two_id = %1$s
            ) AS t
          INNER JOIN users AS u ON friend_id = u.user_id', secure($user_id, 'int')));
    if ($get_friends->num_rows > 0) {
      while ($friend = $get_friends->fetch_assoc()) {
        $friends[] = $friend['user_id'];
      }
    }
    return $friends;
  }


  /**
   * get_followings_ids
   * 
   * @param integer $user_id
   * @return array
   */
  public function get_followings_ids($user_id = null)
  {
    global $db;
    $user_id = (isset($user_id)) ? $user_id : $this->_data['user_id'];
    $followings = [];
    $get_followings = $db->query(sprintf("SELECT followings.following_id FROM followings INNER JOIN users ON followings.following_id = users.user_id WHERE users.user_banned = '0' AND followings.user_id = %s", secure($user_id, 'int')));
    if ($get_followings->num_rows > 0) {
      while ($following = $get_followings->fetch_assoc()) {
        $followings[] = $following['following_id'];
      }
    }
    return $followings;
  }


  /**
   * get_followers_ids
   * 
   * @param integer $user_id
   * @return array
   */
  public function get_followers_ids($user_id = null)
  {
    global $db;
    $user_id = (isset($user_id)) ? $user_id : $this->_data['user_id'];
    $followers = [];
    $get_followers = $db->query(sprintf("SELECT followings.user_id FROM followings INNER JOIN users ON followings.user_id = users.user_id WHERE users.user_banned = '0' AND followings.following_id = %s", secure($user_id, 'int')));
    if ($get_followers->num_rows > 0) {
      while ($follower = $get_followers->fetch_assoc()) {
        $followers[] = $follower['user_id'];
      }
    }
    return $followers;
  }


  /**
   * get_friends_followings_ids
   * 
   * @return array
   */
  public function get_friends_followings_ids()
  {
    global $system;
    if ($system['friends_enabled']) {
      return array_intersect($this->_data['friends_ids'], $this->_data['followings_ids']);
    } else {
      return $this->_data['followings_ids'];
    }
  }


  /**
   * get_friends_or_followings_ids
   * 
   * @return array
   */
  public function get_friends_or_followings_ids()
  {
    global $system;
    if ($system['friends_enabled']) {
      return $this->_data['friends_ids'];
    } else {
      return $this->_data['followings_ids'];
    }
  }


  /**
   * get_friend_requests_ids
   * 
   * @return array
   */
  public function get_friend_requests_ids()
  {
    global $db;
    $requests = [];
    $get_requests = $db->query(sprintf("SELECT user_one_id FROM friends WHERE status = 0 AND user_two_id = %s", secure($this->_data['user_id'], 'int')));
    if ($get_requests->num_rows > 0) {
      while ($request = $get_requests->fetch_assoc()) {
        $requests[] = $request['user_one_id'];
      }
    }
    return $requests;
  }


  /**
   * get_friend_requests_sent_ids
   * 
   * @return array
   */
  public function get_friend_requests_sent_ids()
  {
    global $db;
    $requests = [];
    $get_requests = $db->query(sprintf("SELECT user_two_id FROM friends WHERE status = 0 AND user_one_id = %s", secure($this->_data['user_id'], 'int')));
    if ($get_requests->num_rows > 0) {
      while ($request = $get_requests->fetch_assoc()) {
        $requests[] = $request['user_two_id'];
      }
    }
    return $requests;
  }


  /**
   * get_pages_ids
   * 
   * @return array
   */
  public function get_pages_ids()
  {
    global $db;
    $pages = [];
    if ($this->_logged_in) {
      $get_pages = $db->query(sprintf("SELECT page_id FROM pages_likes WHERE user_id = %s", secure($this->_data['user_id'], 'int')));
      if ($get_pages->num_rows > 0) {
        while ($page = $get_pages->fetch_assoc()) {
          $pages[] = $page['page_id'];
        }
      }
    }
    return $pages;
  }


  /**
   * get_groups_ids
   * 
   * @param boolean $only_approved
   * @return array
   */
  public function get_groups_ids($only_approved = false)
  {
    global $db;
    $groups = [];
    if ($this->_logged_in) {
      $where_statement = ($only_approved) ? " approved = '1' AND" : "";
      $get_groups = $db->query(sprintf("SELECT group_id FROM groups_members WHERE " . $where_statement . " user_id = %s", secure($this->_data['user_id'], 'int')));
      if ($get_groups->num_rows > 0) {
        while ($group = $get_groups->fetch_assoc()) {
          $groups[] = $group['group_id'];
        }
      }
    }
    return $groups;
  }


  /**
   * get_events_ids
   * 
   * @return array
   */
  public function get_events_ids()
  {
    global $db;
    $events = [];
    if ($this->_logged_in) {
      $get_events = $db->query(sprintf("SELECT event_id FROM events_members WHERE user_id = %s", secure($this->_data['user_id'], 'int')));
      if ($get_events->num_rows > 0) {
        while ($event = $get_events->fetch_assoc()) {
          $events[] = $event['event_id'];
        }
      }
    }
    return $events;
  }


  /**
   * spread_ids
   * 
   * @return string
   */
  public function spread_ids($array)
  {
    return (!$array) ? "0" : implode(',', $array);
  }


  /**
   * filter_ids
   * 
   * @return integer
   */
  public function filter_ids($value)
  {
    if (is_numeric($value)) {
      $value = intval($value);
      if ($value != 0) {
        return $value;
      }
    }
  }


  /**
   * get_sql_order_by_friends_followings
   * 
   * @param array $ids
   * @return string
   */
  public function get_sql_order_by_friends_followings()
  {
    return "ORDER BY 
            CASE WHEN users.user_id IN (" . $this->spread_ids($this->get_friends_followings_ids()) . ") THEN 0 ELSE 1 END, 
            users.user_id DESC";
  }



  /* ------------------------------- */
  /* Get Users */
  /* ------------------------------- */

  /**
   * get_friends
   * 
   * @param integer $user_id
   * @param integer $offset
   * @param boolean $get_all
   * @return array
   */
  public function get_friends($user_id, $offset = 0, $get_all = false)
  {
    global $db, $system;
    $friends = [];
    /* get the target user's privacy */
    $get_privacy = $db->query(sprintf("SELECT user_privacy_friends FROM users WHERE user_id = %s", secure($user_id, 'int')));
    $privacy = $get_privacy->fetch_assoc();
    /* check the target user's privacy */
    if (!$this->check_privacy($privacy['user_privacy_friends'], $user_id)) {
      return $friends;
    }
    $offset *= $system['max_results_even'];
    $limit_statement = ($get_all) ? "" : sprintf("LIMIT %s, %s", secure($offset, 'int', false), secure($system['max_results_even'], 'int', false));
    $get_friends = $db->query(sprintf('SELECT users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, users.user_subscribed, users.user_verified FROM friends INNER JOIN users ON (friends.user_one_id = users.user_id AND friends.user_one_id != %1$s) OR (friends.user_two_id = users.user_id AND friends.user_two_id != %1$s) WHERE users.user_banned = "0" AND friends.status = 1 AND (friends.user_one_id = %1$s OR friends.user_two_id = %1$s) ' . $limit_statement, secure($user_id, 'int')));
    if ($get_friends->num_rows > 0) {
      while ($friend = $get_friends->fetch_assoc()) {
        $friend['user_picture'] = get_picture($friend['user_picture'], $friend['user_gender']);
        /* get the connection between the viewer & the target */
        $friend['connection'] = $this->connection($friend['user_id']);
        $friend['top_friend'] = $this->is_top_friend($friend['user_id']);
        $friends[] = $friend;
      }
    }
    return $friends;
  }


  /**
   * get_top_friends
   * 
   * @param integer $user_id
   * @param integer $offset
   * @param boolean $get_all
   * @return array
   */
  public function get_top_friends($user_id, $offset = 0, $get_all = false)
  {
    global $db, $system;
    $top_friends = [];
    $offset *= $system['max_results_even'];
    /* get the target user's privacy */
    $get_privacy = $db->query(sprintf("SELECT user_privacy_friends FROM users WHERE user_id = %s", secure($user_id, 'int')));
    $privacy = $get_privacy->fetch_assoc();
    /* check the target user's privacy */
    if (!$this->check_privacy($privacy['user_privacy_friends'], $user_id)) {
      return $top_friends;
    }
    $limit_statement = ($get_all) ? "" : sprintf("LIMIT %s, %s", secure($offset, 'int', false), secure($system['max_results_even'], 'int', false));
    $get_top_friends = $db->query(sprintf("SELECT users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, users.user_subscribed, users.user_verified FROM users_top_friends INNER JOIN users ON users_top_friends.friend_id = users.user_id WHERE users.user_banned = '0' AND users_top_friends.user_id = %s " . $limit_statement, secure($user_id, 'int')));
    if ($get_top_friends->num_rows > 0) {
      while ($top_friend = $get_top_friends->fetch_assoc()) {
        $top_friend['user_picture'] = get_picture($top_friend['user_picture'], $top_friend['user_gender']);
        /* get the connection between the viewer & the target */
        $top_friend['connection'] = $this->connection($top_friend['user_id'], false);
        $top_friends[] = $top_friend;
      }
    }
    return $top_friends;
  }


  /**
   * get_friends_count
   * 
   * @param integer $user_id
   * @return integer
   */
  public function get_friends_count($user_id = null)
  {
    global $db;
    $user_id = (isset($user_id)) ? $user_id : $this->_data['user_id'];
    $get_friends_count = $db->query(sprintf('
          SELECT
            COUNT(*) AS count 
          FROM (
              SELECT
                  f.user_two_id AS friend_id
              FROM friends AS f
              WHERE f.status = 1 AND f.user_one_id = %1$s
              UNION
              SELECT
                  f.user_one_id AS friend_id
              FROM friends AS f
              WHERE f.status = 1 AND f.user_two_id = %1$s
            ) AS t
          INNER JOIN users AS u ON friend_id = u.user_id', secure($user_id, 'int')));
    return $get_friends_count->fetch_assoc()['count'];
  }


  /**
   * get_followings
   * 
   * @param integer $user_id
   * @param integer $offset
   * @param boolean $get_all
   * @return array
   */
  public function get_followings($user_id, $offset = 0, $get_all = false)
  {
    global $db, $system;
    $followings = [];
    $offset *= $system['max_results_even'];
    /* get the target user's privacy */
    $get_privacy = $db->query(sprintf("SELECT user_privacy_followers FROM users WHERE user_id = %s", secure($user_id, 'int')));
    $privacy = $get_privacy->fetch_assoc();
    /* check the target user's privacy */
    if (!$this->check_privacy($privacy['user_privacy_followers'], $user_id)) {
      return $followings;
    }
    $limit_statement = ($get_all) ? "" : sprintf("LIMIT %s, %s", secure($offset, 'int', false), secure($system['max_results_even'], 'int', false));
    $get_followings = $db->query(sprintf("SELECT users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, users.user_subscribed, users.user_verified FROM followings INNER JOIN users ON followings.following_id = users.user_id WHERE users.user_banned = '0' AND followings.user_id = %s " . $limit_statement, secure($user_id, 'int')));
    if ($get_followings->num_rows > 0) {
      while ($following = $get_followings->fetch_assoc()) {
        $following['user_picture'] = get_picture($following['user_picture'], $following['user_gender']);
        /* get the connection between the viewer & the target */
        $following['connection'] = $this->connection($following['user_id'], false);
        $followings[] = $following;
      }
    }
    return $followings;
  }


  /**
   * get_followings_count
   * 
   * @param integer $user_id
   * @return integer
   */
  public function get_followings_count($user_id = null)
  {
    global $db;
    $user_id = (isset($user_id)) ? $user_id : $this->_data['user_id'];
    $get_followings_count = $db->query(sprintf("SELECT COUNT(*) AS count FROM followings INNER JOIN users ON followings.following_id = users.user_id WHERE users.user_banned = '0' AND followings.user_id = %s", secure($user_id, 'int')));
    return $get_followings_count->fetch_assoc()['count'];
  }


  /**
   * get_followers
   * 
   * @param integer $user_id
   * @param integer $offset
   * @param boolean $get_all
   * @return array
   */
  public function get_followers($user_id, $offset = 0, $get_all = false)
  {
    global $db, $system;
    $followers = [];
    $offset *= $system['max_results_even'];
    /* get the target user's privacy */
    $get_privacy = $db->query(sprintf("SELECT user_privacy_followers FROM users WHERE user_id = %s", secure($user_id, 'int')));
    $privacy = $get_privacy->fetch_assoc();
    /* check the target user's privacy */
    if (!$this->check_privacy($privacy['user_privacy_followers'], $user_id)) {
      return $followers;
    }
    $limit_statement = ($get_all) ? "" : sprintf("LIMIT %s, %s", secure($offset, 'int', false), secure($system['max_results_even'], 'int', false));
    $get_followers = $db->query(sprintf("SELECT users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, users.user_subscribed, users.user_verified FROM followings INNER JOIN users ON followings.user_id = users.user_id WHERE users.user_banned = '0' AND followings.following_id = %s " . $limit_statement, secure($user_id, 'int')));
    if ($get_followers->num_rows > 0) {
      while ($follower = $get_followers->fetch_assoc()) {
        $follower['user_picture'] = get_picture($follower['user_picture'], $follower['user_gender']);
        /* get the connection between the viewer & the target */
        $follower['connection'] = $this->connection($follower['user_id'], false);
        $followers[] = $follower;
      }
    }
    return $followers;
  }


  /**
   * get_followers_count
   * 
   * @param integer $user_id
   * @return integer
   */
  public function get_followers_count($user_id = null)
  {
    global $db;
    $user_id = (isset($user_id)) ? $user_id : $this->_data['user_id'];
    $get_followers_count = $db->query(sprintf("SELECT COUNT(*) AS count FROM followings INNER JOIN users ON followings.user_id = users.user_id WHERE users.user_banned = '0' AND followings.following_id = %s", secure($user_id, 'int')));
    return $get_followers_count->fetch_assoc()['count'];
  }


  /**
   * get_subscribers
   * 
   * @param integer $node_id
   * @param string $node_type
   * @param integer $offset
   * @param boolean $get_all
   * @return array
   */
  public function get_subscribers($node_id, $node_type = 'profile', $offset = 0, $get_all = false)
  {
    global $db, $system;
    $subscribers = [];
    $offset *= $system['max_results_even'];
    $limit_statement = ($get_all) ? "" : sprintf("LIMIT %s, %s", secure($offset, 'int', false), secure($system['max_results_even'], 'int', false));
    $get_subscribers = $db->query(sprintf("SELECT users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, users.user_subscribed, users.user_verified FROM subscribers INNER JOIN users ON subscribers.user_id = users.user_id WHERE users.user_banned = '0' AND subscribers.node_id = %s AND subscribers.node_type = %s " . $limit_statement, secure($node_id, 'int'), secure($node_type)));
    if ($get_subscribers->num_rows > 0) {
      while ($subscriber = $get_subscribers->fetch_assoc()) {
        $subscriber['user_picture'] = get_picture($subscriber['user_picture'], $subscriber['user_gender']);
        /* get the connection between the viewer & the target */
        $subscriber['connection'] = $this->connection($subscriber['user_id'], false);
        $subscribers[] = $subscriber;
      }
    }
    return $subscribers;
  }


  /**
   * get_subscribers_count
   * 
   * @param integer $node_id
   * @param string $node_type
   * @return integer
   */
  public function get_subscribers_count($node_id = null, $node_type = 'profile')
  {
    global $db;
    $node_id = (isset($node_id)) ? $node_id : $this->_data['user_id'];
    $get_subscribers_count = $db->query(sprintf("SELECT COUNT(*) AS count FROM subscribers INNER JOIN users ON subscribers.user_id = users.user_id WHERE users.user_banned = '0' AND subscribers.node_id = %s AND subscribers.node_type = %s", secure($node_id, 'int'), secure($node_type)));
    return $get_subscribers_count->fetch_assoc()['count'];
  }


  /**
   * get_subscriptions
   * 
   * @param integer $user_id
   * @param integer $offset
   * @param boolean $get_all
   * @return array
   */
  public function get_subscriptions($user_id, $offset = 0, $get_all = false)
  {
    global $db, $system;
    $subscriptions = [];
    /* get the target user's privacy */
    $get_privacy = $db->query(sprintf("SELECT user_privacy_subscriptions FROM users WHERE user_id = %s", secure($user_id, 'int')));
    $privacy = $get_privacy->fetch_assoc();
    /* check the target user's privacy */
    if (!$this->check_privacy($privacy['user_privacy_subscriptions'], $user_id)) {
      return $subscriptions;
    }
    $offset *= $system['max_results_even'];
    $limit_statement = ($get_all) ? "" : sprintf("LIMIT %s, %s", secure($offset, 'int', false), secure($system['max_results_even'], 'int', false));
    $get_subscriptions = $db->query(sprintf("SELECT subscribers.plan_id, subscribers.node_type, subscribers.user_id AS plan_user_id, users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, users.user_subscribed, users.user_verified, pages.*, `groups`.* FROM subscribers LEFT JOIN users ON subscribers.node_id = users.user_id AND subscribers.node_type = 'profile' AND users.user_banned = '0' LEFT JOIN pages ON subscribers.node_id = pages.page_id AND subscribers.node_type = 'page' LEFT JOIN `groups` ON subscribers.node_id = `groups`.group_id AND subscribers.node_type = 'group' WHERE NOT (users.user_name <=> NULL AND pages.page_name <=> NULL AND `groups`.group_name <=> NULL) AND subscribers.user_id = %s" . $limit_statement, secure($user_id, 'int')));
    if ($get_subscriptions->num_rows > 0) {
      while ($subscription = $get_subscriptions->fetch_assoc()) {
        /* get node picture */
        switch ($subscription['node_type']) {
          case 'profile':
            $subscription['user_picture'] = get_picture($subscription['user_picture'], $subscription['user_gender']);
            break;

          case 'page':
            $subscription['page_picture'] = get_picture($subscription['page_picture'], 'page');
            break;

          case 'group':
            $subscription['group_picture'] = get_picture($subscription['group_picture'], 'group');
            break;
        }
        /* get monetization plan */
        $subscription['monetization_plan'] = $this->get_monetization_plan($subscription['plan_id'], true);
        $subscriptions[] = $subscription;
      }
    }
    return $subscriptions;
  }


  /**
   * get_subscriptions_count
   * 
   * @param integer $user_id
   * @return integer
   */
  public function get_subscriptions_count($user_id = null)
  {
    global $db;
    $user_id = (isset($user_id)) ? $user_id : $this->_data['user_id'];
    $get_subscriptions_count = $db->query(sprintf("SELECT COUNT(*) AS count FROM subscribers LEFT JOIN users ON subscribers.node_id = users.user_id AND subscribers.node_type = 'profile' AND users.user_banned = '0' LEFT JOIN pages ON subscribers.node_id = pages.page_id AND subscribers.node_type = 'page' LEFT JOIN `groups` ON subscribers.node_id = `groups`.group_id AND subscribers.node_type = 'group' WHERE NOT (users.user_name <=> NULL AND pages.page_name <=> NULL AND `groups`.group_name <=> NULL) AND subscribers.user_id = %s", secure($user_id, 'int')));
    return $get_subscriptions_count->fetch_assoc()['count'];
  }


  /**
   * get_blocked
   * 
   * @param integer $offset
   * @return array
   */
  public function get_blocked($offset = 0)
  {
    global $db, $system;
    $blocks = [];
    $offset *= $system['max_results'];
    $get_blocks = $db->query(sprintf('SELECT users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, users.user_subscribed, users.user_verified FROM users_blocks INNER JOIN users ON users_blocks.blocked_id = users.user_id WHERE users_blocks.user_id = %s LIMIT %s, %s', secure($this->_data['user_id'], 'int'), secure($offset, 'int', false), secure($system['max_results'], 'int', false)));
    if ($get_blocks->num_rows > 0) {
      while ($block = $get_blocks->fetch_assoc()) {
        $block['user_picture'] = get_picture($block['user_picture'], $block['user_gender']);
        $block['connection'] = 'blocked';
        $blocks[] = $block;
      }
    }
    return $blocks;
  }


  /**
   * check_last_friend_request
   * 
   * @param integer $last_request_id
   * @return boolean
   */
  public function check_last_friend_request($last_request_id)
  {
    global $db, $system;
    /* check if last friend reuqest deleted already */
    $deleted = $db->query(sprintf("SELECT COUNT(*) as count FROM friends WHERE id = %s", secure($last_request_id, 'int')));
    if ($deleted->fetch_assoc()['count'] == 0) {
      /* if yes > return true */
      return true;
    }
    return false;
  }


  /**
   * get_friend_requests
   * 
   * @param integer $offset
   * @param integer $last_request_id
   * @return array
   */
  public function get_friend_requests($offset = 0, $last_request_id = null)
  {
    global $db, $system;
    $requests = [];
    $offset *= $system['max_results'];
    if ($last_request_id !== null) {
      $get_requests = $db->query(sprintf("SELECT friends.id, friends.user_one_id as user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM friends INNER JOIN users ON friends.user_one_id = users.user_id WHERE friends.status = 0 AND friends.user_two_id = %s AND friends.id > %s ORDER BY friends.id DESC", secure($this->_data['user_id'], 'int'), secure($last_request_id, 'int')));
    } else {
      $get_requests = $db->query(sprintf("SELECT friends.id, friends.user_one_id as user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM friends INNER JOIN users ON friends.user_one_id = users.user_id WHERE friends.status = 0 AND friends.user_two_id = %s ORDER BY friends.id DESC LIMIT %s, %s", secure($this->_data['user_id'], 'int'), secure($offset, 'int', false), secure($system['max_results'], 'int', false)));
    }
    if ($get_requests->num_rows > 0) {
      while ($request = $get_requests->fetch_assoc()) {
        $request['user_picture'] = get_picture($request['user_picture'], $request['user_gender']);
        $request['mutual_friends_count'] = $this->get_mutual_friends_count($request['user_id']);
        $requests[] = $request;
      }
    }
    return $requests;
  }


  /**
   * get_friend_requests_sent
   * 
   * @param integer $offset
   * @return array
   */
  public function get_friend_requests_sent($offset = 0)
  {
    global $db, $system;
    $requests = [];
    $offset *= $system['max_results'];
    $get_requests = $db->query(sprintf("SELECT friends.user_two_id as user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM friends INNER JOIN users ON friends.user_two_id = users.user_id WHERE friends.status = 0 AND friends.user_one_id = %s LIMIT %s, %s", secure($this->_data['user_id'], 'int'), secure($offset, 'int', false), secure($system['max_results'], 'int', false)));
    if ($get_requests->num_rows > 0) {
      while ($request = $get_requests->fetch_assoc()) {
        $request['user_picture'] = get_picture($request['user_picture'], $request['user_gender']);
        $request['mutual_friends_count'] = $this->get_mutual_friends_count($request['user_id']);
        $requests[] = $request;
      }
    }
    return $requests;
  }


  /**
   * get_friend_requests_sent_total
   * 
   * @return integer
   */
  public function get_friend_requests_sent_total()
  {
    global $db;
    $get_total_requests = $db->query(sprintf("SELECT COUNT(*) as count FROM friends INNER JOIN users ON friends.user_two_id = users.user_id WHERE friends.status = 0 AND friends.user_one_id = %s", secure($this->_data['user_id'], 'int')));
    return $get_total_requests->fetch_assoc()['count'];
  }


  /**
   * get_mutual_friends
   * 
   * @param integer $user_two_id
   * @param integer $offset
   * @return array
   */
  public function get_mutual_friends($user_two_id, $offset = 0)
  {
    global $db, $system;
    $mutual_friends = [];
    $offset *= $system['max_results'];
    $mutual_friends_ids = array_intersect($this->_data['friends_ids'], $this->get_friends_ids($user_two_id));
    $get_mutual_friends = $db->query(sprintf("SELECT user_id, user_name, user_firstname, user_lastname, user_gender, user_picture, user_subscribed, user_verified FROM users WHERE user_id IN (%s) LIMIT %s, %s", $this->spread_ids($mutual_friends_ids), secure($offset, 'int', false), secure($system['max_results'], 'int', false)));
    if ($get_mutual_friends->num_rows > 0) {
      while ($mutual_friend = $get_mutual_friends->fetch_assoc()) {
        $mutual_friend['user_picture'] = get_picture($mutual_friend['user_picture'], $mutual_friend['user_gender']);
        $mutual_friends[] = $mutual_friend;
      }
    }
    return $mutual_friends;
  }


  /**
   * get_mutual_friends_count
   * 
   * @param integer $user_two_id
   * @return integer
   */
  public function get_mutual_friends_count($user_two_id)
  {
    return count(array_intersect($this->_data['friends_ids'], $this->get_friends_ids($user_two_id)));
  }


  /**
   * get_new_people
   * 
   * @param integer $offset
   * @param boolean $random
   * @return array
   */
  public function get_new_people($offset = 0, $random = false)
  {
    global $db, $system;
    $results = [];
    $offset *= $system['min_results'];
    // prepare where statement
    $where = "";
    /* user not IN (friends, followings, friend requests & friend requests sent) */
    $old_people_ids = array_unique(array_merge($this->_data['friends_ids'], $this->_data['followings_ids'], $this->_data['friend_requests_ids'], $this->_data['friend_requests_sent_ids']));
    $where .= sprintf("WHERE users.user_id != '1' AND users.user_banned = '0' AND users.user_suggestions_hidden = '0' AND users.user_id != %s AND users.user_id NOT IN (%s)", secure($this->_data['user_id'], 'int'), $this->spread_ids($old_people_ids));
    /* check if activation enabled */
    if ($system['activation_enabled']) {
      $where .= " AND users.user_activated = '1'";
    }
    /* get users */
    if ($system['location_finder_enabled']) {
      $unit = ($system['system_distance'] == "mile") ? 3958 : 6371;
      $distance = 10000;
      if ($random) {
        $get_users = $db->query(sprintf("SELECT * FROM (SELECT user_id, user_name, user_firstname, user_lastname, user_gender, user_picture, user_subscribed, user_verified, (%s * acos(cos(radians(%s)) * cos(radians(user_latitude)) * cos(radians(user_longitude) - radians(%s)) + sin(radians(%s)) * sin(radians(user_latitude))) ) AS distance FROM users " . $where . " HAVING distance < %s ORDER BY distance ASC LIMIT %s) tmp ORDER BY RAND() LIMIT %s", secure($unit, 'int'), secure($this->_data['user_latitude']), secure($this->_data['user_longitude']), secure($this->_data['user_latitude']), secure($distance, 'int'), secure($system['max_results'] * 2, 'int', false), secure($system['min_results'], 'int', false)));
      } else {
        $get_users = $db->query(sprintf("SELECT user_id, user_name, user_firstname, user_lastname, user_gender, user_picture, user_subscribed, user_verified, (%s * acos(cos(radians(%s)) * cos(radians(user_latitude)) * cos(radians(user_longitude) - radians(%s)) + sin(radians(%s)) * sin(radians(user_latitude))) ) AS distance FROM users " . $where . " HAVING distance < %s ORDER BY distance ASC LIMIT %s, %s", secure($unit, 'int'), secure($this->_data['user_latitude']), secure($this->_data['user_longitude']), secure($this->_data['user_latitude']), secure($distance, 'int'), secure($offset, 'int', false), secure($system['min_results'], 'int', false)));
      }
    } else {
      if ($random) {
        $get_users = $db->query(sprintf("SELECT users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, users.user_subscribed, users.user_verified FROM users JOIN (SELECT CEIL(RAND() * (SELECT MAX(user_id) FROM users)) AS user_id) AS u " . $where . " AND users.user_id >= u.user_id ORDER BY users.user_id ASC LIMIT %s, %s", secure($offset, 'int', false), secure($system['min_results'], 'int', false)));
      } else {
        $get_users = $db->query(sprintf("SELECT user_id, user_name, user_firstname, user_lastname, user_gender, user_picture, user_subscribed, user_verified FROM users " . $where . " LIMIT %s, %s", secure($offset, 'int', false), secure($system['min_results'], 'int', false)));
      }
    }
    if ($get_users->num_rows > 0) {
      while ($user = $get_users->fetch_assoc()) {
        /* check if there is any blocking between the viewer & the target user */
        if ($this->blocked($user['user_id'])) {
          continue;
        }
        $user['user_picture'] = get_picture($user['user_picture'], $user['user_gender']);
        $user['mutual_friends_count'] = $this->get_mutual_friends_count($user['user_id']);
        $results[] = $user;
      }
    }
    return $results;
  }


  /**
   * get_pro_members
   * 
   * @return array
   */
  public function get_pro_members()
  {
    global $db, $system;
    $pro_members = [];
    $get_pro_members = $db->query(sprintf("SELECT user_id, user_name, user_firstname, user_lastname, user_gender, user_picture, user_subscribed, user_verified FROM users WHERE user_subscribed = '1' ORDER BY RAND() LIMIT %s", $system['max_results']));
    if ($get_pro_members->num_rows > 0) {
      while ($user = $get_pro_members->fetch_assoc()) {
        $user['user_picture'] = get_picture($user['user_picture'], $user['user_gender']);
        $pro_members[] = $user;
      }
    }
    return $pro_members;
  }


  /**
   * get_users
   * 
   * @param string $query
   * @param array $skipped_array
   * @param boolean $mentioned
   * @return array
   */
  public function get_users($query, $skipped_array = [], $mentioned = false)
  {
    global $db, $system;
    $users = [];
    /* prepare where & order statement */
    if ($system['show_usernames_enabled']) {
      $where_statement = sprintf(" (user_name LIKE %s)", secure($query, 'search'));
      $order_statement = " ORDER BY user_name ";
    } else {
      $where_statement = sprintf(' (user_name LIKE %1$s OR user_firstname LIKE %1$s OR user_lastname LIKE %1$s OR CONCAT(user_firstname,  " ", user_lastname) LIKE %1$s) ', secure($query, 'search'));
      $order_statement = " ORDER BY user_firstname, user_lastname ";
    }
    /* prepare skipped statment */
    $skipped_array = array_filter($skipped_array, [$this, "filter_ids"]);
    $skipped_statment = ($skipped_array) ? sprintf(" user_id NOT IN (%s) AND ", $this->spread_ids($skipped_array)) : "";
    /* get users */
    $get_users = $db->query("SELECT user_id, user_name, user_firstname, user_lastname, user_gender, user_picture, user_subscribed, user_verified, user_monetization_enabled, user_monetization_chat_price, user_monetization_call_price, user_privacy_chat FROM users WHERE user_id != " . secure($this->_data['user_id'], 'int') . " AND " . $skipped_statment . $where_statement . $order_statement . " LIMIT " . secure($system['min_results'], 'int', false));
    if ($get_users->num_rows > 0) {
      while ($user = $get_users->fetch_assoc()) {
        /* check if there is any blocking between the viewer & the target user */
        if ($this->blocked($user['user_id'])) {
          continue;
        }
        /* check the chat privacy if not mentioned */
        if (!$mentioned && $user['user_privacy_chat'] == 'me' || $user['user_privacy_chat'] == 'friends' && !$this->friendship_approved($user['user_id'])) {
          continue;
        }
        /* check if paid chat */
        if ($system['monetization_enabled'] && $this->check_user_permission($user['user_id'], 'monetization_permission') && $user['user_monetization_enabled'] && ($user['user_monetization_chat_price'] > 0 || $user['user_monetization_call_price'] > 0)) {
          $user['chat_price'] = $user['user_monetization_chat_price'];
          $user['call_price'] = $user['user_monetization_call_price'];
        }
        $user['user_picture'] = get_picture($user['user_picture'], $user['user_gender']);
        if ($mentioned) {
          $mention_item['id'] = $user['user_id'];
          $mention_item['img'] = $user['user_picture'];
          $mention_item['label'] = ($system['show_usernames_enabled']) ? $user['user_name'] : $user['user_firstname'] . " " . $user['user_lastname'];
          $mention_item['value'] = "[" . $user['user_name'] . "]";
          $users[] = $mention_item;
        } else {
          $users[] = $user;
        }
      }
    }
    return $users;
  }


  /**
   * get_user
   * 
   * @param integer $user_id
   * @return array
   */
  public function get_user($user_id, $full_info = true)
  {
    global $db, $system;
    if ($full_info) {
      $requested_info = sprintf("users.*, (users.user_last_seen >= SUBTIME(NOW(), SEC_TO_TIME(%s))) AS user_is_online, users_groups.permissions_group_id, packages.package_permissions_group_id", secure($system['online_status_timeout'], 'int'));
    } else {
      $requested_info = sprintf("users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, users.user_subscribed, users.user_verified, users.user_last_seen, (users.user_last_seen >= SUBTIME(NOW(), SEC_TO_TIME(%s))) AS user_is_online", secure($system['offline_time'], 'int'));
    }
    $get_user = $db->query(sprintf("SELECT %s FROM users LEFT JOIN packages ON users.user_subscribed = '1' AND users.user_package = packages.package_id LEFT JOIN users_groups ON users.user_group = '3' AND users.user_group_custom != '0' AND users.user_group_custom = users_groups.user_group_id WHERE users.user_id = %s", $requested_info, secure($user_id, 'int')));
    if ($get_user->num_rows == 0) {
      return false;
    }
    $_user = $get_user->fetch_assoc();
    $_user['user_picture_default'] = ($_user['user_picture']) ? false : true;
    $_user['user_picture'] = get_picture($_user['user_picture'], $_user['user_gender']);
    $_user['user_fullname'] = ($system['show_usernames_enabled']) ? $_user['user_name'] : $_user['user_firstname'] . " " . $_user['user_lastname'];
    return $_user;
  }


  /**
   * get_admins_moderators
   * 
   * @param boolean $only_admins
   * @return array
   */
  public function get_admins_moderators($only_admins = false)
  {
    global $db;
    $admins_moderators = [];
    $where_query = ($only_admins) ? "user_group = 1" : "user_group < 3";
    $get_admins_moderators = $db->query(
      "SELECT 
        user_id, 
        user_name, 
        user_firstname, 
        user_lastname, 
        user_gender, 
        user_picture, 
        user_subscribed, 
        user_verified 
      FROM users 
      WHERE " . $where_query
    );
    if ($get_admins_moderators->num_rows > 0) {
      while ($user = $get_admins_moderators->fetch_assoc()) {
        $user['user_picture'] = get_picture($user['user_picture'], $user['user_gender']);
        $user['user_fullname'] = ($system['show_usernames_enabled']) ? $user['user_name'] : $user['user_firstname'] . " " . $user['user_lastname'];
        $admins_moderators[] = $user;
      }
    }
    return $admins_moderators;
  }



  /* ------------------------------- */
  /* User & Connections */
  /* ------------------------------- */

  /**
   * connect
   * 
   * @param string $do
   * @param integer $id
   * @param integer $uid
   * @return void
   */
  public function connect($do, $id, $uid = null)
  {
    global $db, $system;
    /* valid inputs */
    if (!in_array($do, ['favorite', 'unfavorite', 'block', 'unblock', 'friend-accept', 'friend-decline', 'friend-add', 'friend-cancel', 'friend-remove', 'follow', 'unfollow', 'poke', 'page-like', 'page-unlike', 'page-boost', 'page-unboost', 'page-invite', 'page-admin-addation', 'page-admin-remove', 'page-member-remove', 'group-join', 'group-leave', 'group-invite', 'group-accept', 'group-decline', 'group-boost', 'group-unboost', 'group-admin-addation', 'group-admin-remove', 'group-member-remove', 'event-go', 'event-ungo', 'event-interest', 'event-uninterest', 'event-boost', 'event-unboost', 'event-invite', 'delete-app'])) {
      throw new BadRequestException(__("Invalid input"));
    }
    /* check id */
    if (!isset($id) || !is_numeric($id)) {
      throw new BadRequestException(__("Invalid input"));
    }
    /* check uid */
    if (isset($uid) && !is_numeric($uid)) {
      throw new BadRequestException(__("Invalid input"));
    }
    // check if friends enabled
    if (!$system['friends_enabled'] && in_array($do, ['friend-accept', 'friend-decline', 'friend-add', 'friend-cancel', 'friend-remove'])) {
      throw new BadRequestException(__("Friends system is disabled"));
    }
    switch ($do) {
      case 'delete-app':
        /* delete user app */
        $this->delete_user_app($id);
        break;

      case 'block':
        /* check blocking */
        if ($this->blocked($id)) {
          throw new AuthorizationException(__("You have already blocked this user before!"));
        }
        /* remove any friendship */
        $this->connect('friend-remove', $id);
        /* delete the target from viewer's followings */
        $this->connect('unfollow', $id);
        /* delete the viewer from target's followings */
        $db->query(sprintf("DELETE FROM followings WHERE user_id = %s AND following_id = %s", secure($id, 'int'), secure($this->_data['user_id'], 'int')));
        /* block the user */
        $db->query(sprintf("INSERT INTO users_blocks (user_id, blocked_id) VALUES (%s, %s)", secure($this->_data['user_id'], 'int'), secure($id, 'int')));
        break;

      case 'unblock':
        /* unblock the user */
        $db->query(sprintf("DELETE FROM users_blocks WHERE user_id = %s AND blocked_id = %s", secure($this->_data['user_id'], 'int'), secure($id, 'int')));
        break;

      case 'favorite':
        /* check if the user is already in the viewer's favorites */
        $check = $db->query(sprintf("SELECT COUNT(*) as count FROM users_top_friends WHERE user_id = %s AND friend_id = %s", secure($this->_data['user_id'], 'int'), secure($id, 'int')));
        if ($check->fetch_assoc()['count'] > 0) {
          throw new AuthorizationException(__("This user is already in your top friends"));
        }
        /* check if the user is not friend */
        if (!$this->friendship_approved($id)) {
          throw new AuthorizationException(__("You must be friends to add this user to your top friends"));
        }
        /* add the user to the viewer's favorites */
        $db->query(sprintf("INSERT INTO users_top_friends (user_id, friend_id) VALUES (%s, %s)", secure($this->_data['user_id'], 'int'), secure($id, 'int')));
        break;

      case 'unfavorite':
        /* remove the user from the viewer's favorites */
        $db->query(sprintf("DELETE FROM users_top_friends WHERE user_id = %s AND friend_id = %s", secure($this->_data['user_id'], 'int'), secure($id, 'int')));
        break;

      case 'friend-accept':
        /* check if there is a friend request from the target to the viewer */
        $check = $db->query(sprintf("SELECT COUNT(*) as count FROM friends WHERE user_one_id = %s AND user_two_id = %s AND status = 0", secure($id, 'int'), secure($this->_data['user_id'], 'int')));
        /* if no -> return */
        if ($check->fetch_assoc()['count'] == 0) return;
        /* add the target as a friend */
        $db->query(sprintf("UPDATE friends SET status = 1 WHERE user_one_id = %s AND user_two_id = %s", secure($id, 'int'), secure($this->_data['user_id'], 'int')));
        /* post new notification */
        $this->post_notification(['to_user_id' => $id, 'action' => 'friend_accept', 'node_url' => $this->_data['user_name']]);
        /* follow */
        $this->_follow($id);
        break;

      case 'friend-decline':
        /* check if there is a friend request from the target to the viewer */
        $check = $db->query(sprintf("SELECT COUNT(*) as count FROM friends WHERE user_one_id = %s AND user_two_id = %s AND status = 0", secure($id, 'int'), secure($this->_data['user_id'], 'int')));
        /* if no -> return */
        if ($check->fetch_assoc()['count'] == 0) return;
        /* decline this friend request */
        if ($system['disable_declined_friendrequest']) {
          $db->query(sprintf("UPDATE friends SET status = -1 WHERE user_one_id = %s AND user_two_id = %s", secure($id, 'int'), secure($this->_data['user_id'], 'int')));
        } else {
          $db->query(sprintf("DELETE FROM friends WHERE user_one_id = %s AND user_two_id = %s", secure($id, 'int'), secure($this->_data['user_id'], 'int')));
        }
        /* unfollow */
        $this->_unfollow($id);
        break;

      case 'friend-add':
        /* check blocking */
        if ($this->blocked($id)) {
          throw new AuthorizationException(__("You have already blocked this user before!"));
        }
        /* check if there is any relation between the viewer & the target */
        $check_relation = $db->query(sprintf('SELECT COUNT(*) as count FROM friends WHERE (user_one_id = %1$s AND user_two_id = %2$s) OR (user_one_id = %2$s AND user_two_id = %1$s)', secure($this->_data['user_id'], 'int'),  secure($id, 'int')));
        /* if yes -> return */
        if ($check_relation->fetch_assoc()['count'] > 0) return;
        /* check max friends/user limit for both the viewer & the target */
        if ($system['max_friends'] > 0) {
          /* get target user group */
          $get_target_user = $db->query(sprintf("SELECT user_group FROM users WHERE user_id = %s", secure($id, 'int')));
          if ($get_target_user->num_rows == 0) return;
          $target_user = $get_target_user->fetch_assoc();
          /* viewer check */
          $check_viewer_limit = $db->query(sprintf('SELECT COUNT(*) as count FROM friends WHERE (user_one_id = %1$s OR user_two_id = %1$s) AND status = 1', secure($this->_data['user_id'], 'int')));
          if ($check_viewer_limit->fetch_assoc()['count'] >= $system['max_friends'] && $this->_data['user_group'] >= 3) {
            modal("MESSAGE", __("Maximum Limit Reached"), __("Your have reached the maximum limit of Friends" . " (" . $system['max_friends'] . " " . __("Friends") . ")"));
          }
          /* target check */
          $check_target_limit = $db->query(sprintf('SELECT COUNT(*) as count FROM friends WHERE (user_one_id = %1$s OR user_two_id = %1$s) AND status = 1', secure($id, 'int')));
          if ($check_target_limit->fetch_assoc()['count'] >= $system['max_friends'] && $target_user['user_group'] >= 3) {
            modal("MESSAGE", __("Maximum Limit Reached"), __("This user has reached the maximum limit of Friends" . " (" . $system['max_friends'] . " " . __("Friends") . ")"));
          }
        }
        /* add the friend request */
        $db->query(sprintf("INSERT INTO friends (user_one_id, user_two_id, status) VALUES (%s, %s, '0')", secure($this->_data['user_id'], 'int'),  secure($id, 'int')));
        /* update requests counter +1 */
        $db->query(sprintf("UPDATE users SET user_live_requests_counter = user_live_requests_counter + 1 WHERE user_id = %s", secure($id, 'int')));
        /* post new notification */
        $this->post_notification(['to_user_id' => $id, 'action' => 'friend_add', 'node_url' => $this->_data['user_name']]);
        /* follow */
        $this->_follow($id);
        break;

      case 'friend-cancel':
        /* check if there is a request from the viewer to the target */
        $check = $db->query(sprintf("SELECT COUNT(*) as count FROM friends WHERE user_one_id = %s AND user_two_id = %s AND status = 0", secure($this->_data['user_id'], 'int'),  secure($id, 'int')));
        /* if no -> return */
        if ($check->fetch_assoc()['count'] == 0) return;
        /* delete the friend request */
        $db->query(sprintf("DELETE FROM friends WHERE user_one_id = %s AND user_two_id = %s", secure($this->_data['user_id'], 'int'), secure($id, 'int')));
        /* update requests counter -1 */
        $db->query(sprintf("UPDATE users SET user_live_requests_counter = IF(user_live_requests_counter=0,0,user_live_requests_counter-1), user_live_notifications_counter = IF(user_live_notifications_counter=0,0,user_live_notifications_counter-1) WHERE user_id = %s", secure($id, 'int')));
        /* delete notification */
        $this->delete_notification($id, 'friend_add', "", $this->_data['user_name']);
        /* unfollow */
        $this->_unfollow($id);
        break;

      case 'friend-remove':
        /* check if there is any relation between me & him */
        $check = $db->query(sprintf('SELECT COUNT(*) as count FROM friends WHERE (user_one_id = %1$s AND user_two_id = %2$s AND status = 1) OR (user_one_id = %2$s AND user_two_id = %1$s AND status = 1)', secure($this->_data['user_id'], 'int'),  secure($id, 'int')));
        /* if no -> return */
        if ($check->fetch_assoc()['count'] == 0) return;
        /* delete this friend */
        $db->query(sprintf('DELETE FROM friends WHERE (user_one_id = %1$s AND user_two_id = %2$s AND status = 1) OR (user_one_id = %2$s AND user_two_id = %1$s AND status = 1)', secure($this->_data['user_id'], 'int'),  secure($id, 'int')));
        /* remove from top friends */
        $db->query(sprintf('DELETE FROM users_top_friends WHERE (user_id =  %1$s AND friend_id = %2$s) OR (user_id =  %2$s AND friend_id = %1$s)', secure($this->_data['user_id'], 'int'), secure($id, 'int')));
        break;

      case 'follow':
        $this->_follow($id);
        break;

      case 'unfollow':
        $this->_unfollow($id);
        break;

      case 'poke':
        /* check if the viewer allowed to poke the target */
        $get_target_user = $db->query(sprintf("SELECT user_privacy_poke FROM users WHERE user_id = %s", secure($id, 'int')));
        if ($get_target_user->num_rows == 0) return;
        $target_user = $get_target_user->fetch_assoc();
        if ($target_user['user_privacy_poke'] == "me" || ($target_user['user_privacy_poke'] == "friends" && !$this->friendship_approved($id))) {
          throw new Exception(__("You can't poke this user"));
        }
        /* check if the viewer poked the target before */
        if ($this->is_poked($id)) {
          throw new Exception(__("You have already poked this user before!"));
        }
        /* poke the target user */
        $db->query(sprintf("INSERT INTO users_pokes (user_id, poked_id) VALUES (%s, %s)", secure($this->_data['user_id'], 'int'),  secure($id, 'int')));
        /* post new notification */
        $this->post_notification(['to_user_id' => $id, 'action' => 'poke', 'node_url' => $this->_data['user_name']]);
        break;

      case 'page-like':
        /* check if the viewer already liked this page */
        $check = $db->query(sprintf("SELECT COUNT(*) as count FROM pages_likes WHERE user_id = %s AND page_id = %s", secure($this->_data['user_id'], 'int'),  secure($id, 'int')));
        /* if yes -> return */
        if ($check->fetch_assoc()['count'] > 0) return;
        /* if no -> like this page */
        $db->query(sprintf("INSERT INTO pages_likes (user_id, page_id) VALUES (%s, %s)", secure($this->_data['user_id'], 'int'),  secure($id, 'int')));
        /* update likes counter +1 */
        $db->query(sprintf("UPDATE pages SET page_likes = page_likes + 1  WHERE page_id = %s", secure($id, 'int')));
        break;

      case 'page-unlike':
        /* check if the viewer already liked this page */
        $check = $db->query(sprintf("SELECT COUNT(*) as count FROM pages_likes WHERE user_id = %s AND page_id = %s", secure($this->_data['user_id'], 'int'),  secure($id, 'int')));
        /* if no -> return */
        if ($check->fetch_assoc()['count'] == 0) return;
        /* if yes -> unlike this page */
        $db->query(sprintf("DELETE FROM pages_likes WHERE user_id = %s AND page_id = %s", secure($this->_data['user_id'], 'int'),  secure($id, 'int')));
        /* update likes counter -1 */
        $db->query(sprintf("UPDATE pages SET page_likes = IF(page_likes=0,0,page_likes-1) WHERE page_id = %s", secure($id, 'int')));
        break;

      case 'page-boost':
        if ($this->_is_admin) {
          /* check if the user is the system admin */
          $check = $db->query(sprintf("SELECT * FROM pages WHERE page_id = %s", secure($id, 'int')));
        } else {
          /* check if the user is the page admin */
          $check = $db->query(sprintf("SELECT * FROM pages WHERE page_id = %s AND page_admin = %s", secure($id, 'int'), secure($this->_data['user_id'], 'int')));
        }
        if ($check->num_rows == 0) {
          throw new AuthorizationException(__("You can't boost this page"));
        }
        $spage = $check->fetch_assoc();
        /* check if viewer can boost page */
        if (!$this->_data['can_boost_pages']) {
          throw new AuthorizationException(__("You reached the maximum number of boosted pages! Upgrade your package to get more"));
        }
        /* boost page */
        if (!$spage['page_boosted']) {
          /* boost page */
          $db->query(sprintf("UPDATE pages SET page_boosted = '1', page_boosted_by = %s WHERE page_id = %s", secure($this->_data['user_id'], 'int'), secure($id, 'int')));
          /* update user */
          $db->query(sprintf("UPDATE users SET user_boosted_pages = user_boosted_pages + 1 WHERE user_id = %s", secure($this->_data['user_id'], 'int')));
        }
        break;

      case 'page-unboost':
        if ($this->_is_admin) {
          /* check if the user is the system admin */
          $check = $db->query(sprintf("SELECT * FROM pages WHERE page_id = %s", secure($id, 'int')));
        } else {
          /* check if the user is the page admin */
          $check = $db->query(sprintf("SELECT * FROM pages WHERE page_id = %s AND page_admin = %s", secure($id, 'int'), secure($this->_data['user_id'], 'int')));
        }
        if ($check->num_rows == 0) {
          throw new AuthorizationException(__("You can't unboost this page"));
        }
        $spage = $check->fetch_assoc();
        /* unboost page */
        if ($spage['page_boosted']) {
          /* unboost page */
          $db->query(sprintf("UPDATE pages SET page_boosted = '0', page_boosted_by = NULL WHERE page_id = %s", secure($id, 'int')));
          /* update user */
          $db->query(sprintf("UPDATE users SET user_boosted_pages = IF(user_boosted_pages=0,0,user_boosted_pages-1) WHERE user_id = %s", secure($this->_data['user_id'], 'int')));
        }
        break;

      case 'page-invite':
        if ($uid == null) {
          throw new BadRequestException(__("Invalid input"));
        }
        /* check if the viewer liked the page */
        $check_viewer = $db->query(sprintf("SELECT pages.* FROM pages INNER JOIN pages_likes ON pages.page_id = pages_likes.page_id WHERE pages_likes.user_id = %s AND pages_likes.page_id = %s", secure($this->_data['user_id'], 'int'), secure($id, 'int')));
        /* if no -> return */
        if ($check_viewer->num_rows == 0) return;
        /* check if the target already liked this page */
        $check_target = $db->query(sprintf("SELECT * FROM pages_likes WHERE user_id = %s AND page_id = %s", secure($uid, 'int'),  secure($id, 'int')));
        /* if yes -> return */
        if ($check_target->num_rows > 0) return;
        /* check if the viewer already invited to the viewer to this page */
        $check_target = $db->query(sprintf("SELECT * FROM pages_invites WHERE page_id = %s AND user_id = %s AND from_user_id = %s", secure($id, 'int'), secure($uid, 'int'), secure($this->_data['user_id'], 'int')));
        /* if yes -> return */
        if ($check_target->num_rows > 0) return;
        /* if no -> invite to this page */
        /* get page */
        $page = $check_viewer->fetch_assoc();
        /* insert invitation */
        $db->query(sprintf("INSERT INTO pages_invites (page_id, user_id, from_user_id) VALUES (%s, %s, %s)", secure($id, 'int'), secure($uid, 'int'), secure($this->_data['user_id'], 'int')));
        /* send notification (page invitation) to the target user */
        $this->post_notification(['to_user_id' => $uid, 'action' => 'page_invitation', 'node_type' => $page['page_title'], 'node_url' => $page['page_name']]);
        break;

      case 'page-admin-addation':
        if ($uid == null) {
          throw new BadRequestException(__("Invalid input"));
        }
        /* check if the target already a page member */
        $check = $db->query(sprintf("SELECT * FROM pages_likes WHERE user_id = %s AND page_id = %s", secure($uid, 'int'),  secure($id, 'int')));
        /* if no -> return */
        if ($check->num_rows == 0) return;
        /* check if the target already a page admin */
        $check = $db->query(sprintf("SELECT * FROM pages_admins WHERE user_id = %s AND page_id = %s", secure($uid, 'int'),  secure($id, 'int')));
        /* if yes -> return */
        if ($check->num_rows > 0) return;
        /* get page */
        $get_page = $db->query(sprintf("SELECT * FROM pages WHERE page_id = %s", secure($id, 'int')));
        $page = $get_page->fetch_assoc();
        /* check if the viewer is page admin */
        if (!$this->check_page_adminship($this->_data['user_id'], $page['page_id']) && $this->_data['user_id'] != $page['page_admin']) {
          throw new BadRequestException(__("Invalid input"));
        }
        /* add the target as page admin */
        $db->query(sprintf("INSERT INTO pages_admins (user_id, page_id) VALUES (%s, %s)", secure($uid, 'int'),  secure($id, 'int')));
        /* send notification (page admin addation) to the target user */
        $this->post_notification(['to_user_id' => $uid, 'action' => 'page_admin_addation', 'node_type' => $page['page_title'], 'node_url' => $page['page_name']]);
        break;

      case 'page-admin-remove':
        if ($uid == null) {
          throw new BadRequestException(__("Invalid input"));
        }
        /* check if the target already a page admin */
        $check = $db->query(sprintf("SELECT * FROM pages_admins WHERE user_id = %s AND page_id = %s", secure($uid, 'int'),  secure($id, 'int')));
        /* if no -> return */
        if ($check->num_rows == 0) return;
        /* get page */
        $get_page = $db->query(sprintf("SELECT * FROM pages WHERE page_id = %s", secure($id, 'int')));
        $page = $get_page->fetch_assoc();
        /* check if the viewer is page admin */
        if (!$this->check_page_adminship($this->_data['user_id'], $page['page_id'])) {
          throw new BadRequestException(__("Invalid input"));
        }
        /* check if the target is the super page admin */
        if ($uid == $page['page_admin']) {
          throw new Exception(__("You can not remove page super admin"));
        }
        /* remove the target as page admin */
        $db->query(sprintf("DELETE FROM pages_admins WHERE user_id = %s AND page_id = %s", secure($uid, 'int'), secure($id, 'int')));
        /* delete notification (page admin addation) to the target user */
        $this->delete_notification($uid, 'page_admin_addation', $page['page_title'], $page['page_name']);
        break;

      case 'page-member-remove':
        if ($uid == null) {
          throw new BadRequestException(__("Invalid input"));
        }
        /* check if the target already a page member */
        $check = $db->query(sprintf("SELECT * FROM pages_likes WHERE user_id = %s AND page_id = %s", secure($uid, 'int'),  secure($id, 'int')));
        /* if no -> return */
        if ($check->num_rows == 0) return;
        /* get page */
        $get_page = $db->query(sprintf("SELECT * FROM pages WHERE page_id = %s", secure($id, 'int')));
        $page = $get_page->fetch_assoc();
        /* check if the target is the super page admin */
        if ($uid == $page['page_admin']) {
          throw new Exception(__("You can not remove page super admin"));
        }
        /* remove the target as page admin */
        $db->query(sprintf("DELETE FROM pages_admins WHERE user_id = %s AND page_id = %s", secure($uid, 'int'), secure($id, 'int')));
        /* remove the target as page member */
        $db->query(sprintf("DELETE FROM pages_likes WHERE user_id = %s AND page_id = %s", secure($uid, 'int'), secure($id, 'int')));
        /* update members counter -1 */
        $db->query(sprintf("UPDATE pages SET page_likes = IF(page_likes=0,0,page_likes-1) WHERE page_id = %s", secure($id, 'int')));
        break;

      case 'group-join':
        /* check if the viewer already joined (approved||pending) this group */
        $check = $db->query(sprintf("SELECT * FROM groups_members WHERE user_id = %s AND group_id = %s", secure($this->_data['user_id'], 'int'),  secure($id, 'int')));
        /* if yes -> return */
        if ($check->num_rows > 0) return;
        /* if no -> join this group */
        /* get group */
        $get_group = $db->query(sprintf("SELECT * FROM `groups` WHERE group_id = %s", secure($id, 'int')));
        $group = $get_group->fetch_assoc();
        /* check approved */
        $approved = 0;
        if ($group['group_privacy'] == 'public') {
          /* the group is public */
          $approved = '1';
        } elseif ($this->_data['user_id'] == $group['group_admin']) {
          /* the group admin join his group */
          $approved = '1';
        }
        $db->query(sprintf("INSERT INTO groups_members (user_id, group_id, approved) VALUES (%s, %s, %s)", secure($this->_data['user_id'], 'int'),  secure($id, 'int'), secure($approved)));
        if ($approved) {
          /* update members counter +1 */
          $db->query(sprintf("UPDATE `groups` SET group_members = group_members + 1  WHERE group_id = %s", secure($id, 'int')));
        } else {
          /* send notification (pending request) to group admin  */
          $this->post_notification(['to_user_id' => $group['group_admin'], 'action' => 'group_join', 'node_type' => $group['group_title'], 'node_url' => $group['group_name']]);
        }
        break;

      case 'group-leave':
        /* check if the viewer already joined (approved||pending) this group */
        $check = $db->query(sprintf("SELECT groups_members.approved, `groups`.* FROM groups_members INNER JOIN `groups` ON groups_members.group_id = `groups`.group_id WHERE groups_members.user_id = %s AND groups_members.group_id = %s", secure($this->_data['user_id'], 'int'),  secure($id, 'int')));
        /* if no -> return */
        if ($check->num_rows == 0) return;
        /* if yes -> leave this group */
        $group = $check->fetch_assoc();
        $db->query(sprintf("DELETE FROM groups_members WHERE user_id = %s AND group_id = %s", secure($this->_data['user_id'], 'int'),  secure($id, 'int')));
        /* update members counter -1 */
        if ($group['approved']) {
          $db->query(sprintf("UPDATE `groups` SET group_members = IF(group_members=0,0,group_members-1) WHERE group_id = %s", secure($id, 'int')));
        } else {
          /* delete notification (pending request) that sent to group admin */
          $this->delete_notification($group['group_admin'], 'group_join', $group['group_title'], $group['group_name']);
        }
        break;

      case 'group-invite':
        if ($uid == null) {
          throw new BadRequestException(__("Invalid input"));
        }
        /* check if the viewer is group member (approved) */
        $check_viewer = $db->query(sprintf("SELECT `groups`.* FROM `groups` INNER JOIN groups_members ON `groups`.group_id = groups_members.group_id WHERE groups_members.approved = '1' AND groups_members.user_id = %s AND groups_members.group_id = %s", secure($this->_data['user_id'], 'int'), secure($id, 'int')));
        /* if no -> return */
        if ($check_viewer->num_rows == 0) return;
        /* check if the target already joined (approved||pending) this group */
        $check_target = $db->query(sprintf("SELECT * FROM groups_members WHERE user_id = %s AND group_id = %s", secure($uid, 'int'),  secure($id, 'int')));
        /* if yes -> return */
        if ($check_target->num_rows > 0) return;
        /* check if the viewer already invited to the viewer to this group */
        $check_target = $db->query(sprintf("SELECT * FROM groups_invites WHERE group_id = %s AND user_id = %s AND from_user_id = %s", secure($id, 'int'), secure($uid, 'int'), secure($this->_data['user_id'], 'int')));
        /* if yes -> return */
        if ($check_target->num_rows > 0) return;
        /* if no -> invite to this group */
        /* get group */
        $group = $check_viewer->fetch_assoc();
        /* insert invitation */
        $db->query(sprintf("INSERT INTO groups_invites (group_id, user_id, from_user_id) VALUES (%s, %s, %s)", secure($id, 'int'), secure($uid, 'int'), secure($this->_data['user_id'], 'int')));
        /* send notification (group invitation) to the target user */
        $this->post_notification(['to_user_id' => $uid, 'action' => 'group_invitation', 'node_type' => $group['group_title'], 'node_url' => $group['group_name']]);
        break;

      case 'group-accept':
        if ($uid == null) {
          throw new BadRequestException(__("Invalid input"));
        }
        /* check if the target has pending request */
        $check = $db->query(sprintf("SELECT `groups`.* FROM `groups` INNER JOIN groups_members ON `groups`.group_id = groups_members.group_id WHERE groups_members.approved = '0' AND groups_members.user_id = %s AND groups_members.group_id = %s", secure($uid, 'int'), secure($id, 'int')));
        /* if no -> return */
        if ($check->num_rows == 0) return;
        $group = $check->fetch_assoc();
        /* check if the viewer is group admin */
        if (!$this->check_group_adminship($this->_data['user_id'], $group['group_id'])) {
          throw new BadRequestException(__("Invalid input"));
        }
        /* update request */
        $db->query(sprintf("UPDATE groups_members SET approved = '1' WHERE user_id = %s AND group_id = %s", secure($uid, 'int'), secure($id, 'int')));
        /* update members counter +1 */
        $db->query(sprintf("UPDATE `groups` SET group_members = group_members + 1  WHERE group_id = %s", secure($id, 'int')));
        /* send notification (group acceptance) to the target user */
        $this->post_notification(['to_user_id' => $uid, 'action' => 'group_accept', 'node_type' => $group['group_title'], 'node_url' => $group['group_name']]);
        break;

      case 'group-decline':
        if ($uid == null) {
          throw new BadRequestException(__("Invalid input"));
        }
        /* check if the target has pending request */
        $check = $db->query(sprintf("SELECT `groups`.* FROM `groups` INNER JOIN groups_members ON `groups`.group_id = groups_members.group_id WHERE groups_members.approved = '0' AND groups_members.user_id = %s AND groups_members.group_id = %s", secure($uid, 'int'), secure($id, 'int')));
        /* if no -> return */
        if ($check->num_rows == 0) return;
        $group = $check->fetch_assoc();
        /* check if the viewer is group admin */
        if (!$this->check_group_adminship($this->_data['user_id'], $group['group_id'])) {
          throw new BadRequestException(__("Invalid input"));
        }
        /* delete request */
        $db->query(sprintf("DELETE FROM groups_members WHERE user_id = %s AND group_id = %s", secure($uid, 'int'), secure($id, 'int')));
        break;

      case 'group-boost':
        if ($this->_is_admin) {
          /* check if the user is the system admin */
          $check = $db->query(sprintf("SELECT * FROM `groups` WHERE group_id = %s", secure($id, 'int')));
        } else {
          /* check if the user is the page admin */
          $check = $db->query(sprintf("SELECT * FROM `groups` WHERE group_id = %s AND group_admin = %s", secure($id, 'int'), secure($this->_data['user_id'], 'int')));
        }
        if ($check->num_rows == 0) {
          throw new AuthorizationException(__("You can't boost this group"));
        }
        $group = $check->fetch_assoc();
        /* check if viewer can boost group */
        if (!$this->_data['can_boost_groups']) {
          throw new AuthorizationException(__("You reached the maximum number of boosted groups! Upgrade your package to get more"));
        }
        /* boost group */
        if (!$group['group_boosted']) {
          /* boost group */
          $db->query(sprintf("UPDATE `groups` SET group_boosted = '1', group_boosted_by = %s WHERE group_id = %s", secure($this->_data['user_id'], 'int'), secure($id, 'int')));
          /* update user */
          $db->query(sprintf("UPDATE users SET user_boosted_groups = user_boosted_groups + 1 WHERE user_id = %s", secure($this->_data['user_id'], 'int')));
        }
        break;

      case 'group-unboost':
        if ($this->_is_admin) {
          /* check if the user is the system admin */
          $check = $db->query(sprintf("SELECT * FROM `groups` WHERE group_id = %s", secure($id, 'int')));
        } else {
          /* check if the user is the page admin */
          $check = $db->query(sprintf("SELECT * FROM `groups` WHERE group_id = %s AND group_admin = %s", secure($id, 'int'), secure($this->_data['user_id'], 'int')));
        }
        if ($check->num_rows == 0) {
          throw new AuthorizationException(__("You can't unboost this group"));
        }
        $group = $check->fetch_assoc();
        /* unboost group */
        if ($group['group_boosted']) {
          /* unboost group */
          $db->query(sprintf("UPDATE `groups` SET group_boosted = '0', group_boosted_by = NULL WHERE group_id = %s", secure($id, 'int')));
          /* update user */
          $db->query(sprintf("UPDATE users SET user_boosted_groups = IF(user_boosted_groups=0,0,user_boosted_groups-1) WHERE user_id = %s", secure($this->_data['user_id'], 'int')));
        }
        break;

      case 'group-admin-addation':
        if ($uid == null) {
          throw new BadRequestException(__("Invalid input"));
        }
        /* check if the target already a group member */
        $check = $db->query(sprintf("SELECT * FROM groups_members WHERE user_id = %s AND group_id = %s", secure($uid, 'int'),  secure($id, 'int')));
        /* if no -> return */
        if ($check->num_rows == 0) return;
        /* check if the target already a group admin */
        $check = $db->query(sprintf("SELECT * FROM groups_admins WHERE user_id = %s AND group_id = %s", secure($uid, 'int'),  secure($id, 'int')));
        /* if yes -> return */
        if ($check->num_rows > 0) return;
        /* get group */
        $get_group = $db->query(sprintf("SELECT * FROM `groups` WHERE group_id = %s", secure($id, 'int')));
        $group = $get_group->fetch_assoc();
        /* check if the viewer is group admin */
        if (!$this->check_group_adminship($this->_data['user_id'], $group['group_id']) && $this->_data['user_id'] != $group['group_admin']) {
          throw new BadRequestException(__("Invalid input"));
        }
        /* add the target as group admin */
        $db->query(sprintf("INSERT INTO groups_admins (user_id, group_id) VALUES (%s, %s)", secure($uid, 'int'),  secure($id, 'int')));
        /* send notification (group admin addation) to the target user */
        $this->post_notification(['to_user_id' => $uid, 'action' => 'group_admin_addation', 'node_type' => $group['group_title'], 'node_url' => $group['group_name']]);
        break;

      case 'group-admin-remove':
        if ($uid == null) {
          throw new BadRequestException(__("Invalid input"));
        }
        /* check if the target already a group admin */
        $check = $db->query(sprintf("SELECT * FROM groups_admins WHERE user_id = %s AND group_id = %s", secure($uid, 'int'),  secure($id, 'int')));
        /* if no -> return */
        if ($check->num_rows == 0) return;
        /* get group */
        $get_group = $db->query(sprintf("SELECT * FROM `groups` WHERE group_id = %s", secure($id, 'int')));
        $group = $get_group->fetch_assoc();
        /* check if the viewer is group admin */
        if (!$this->check_group_adminship($this->_data['user_id'], $group['group_id'])) {
          throw new BadRequestException(__("Invalid input"));
        }
        /* check if the target is the super group admin */
        if ($uid == $group['group_admin']) {
          throw new AuthorizationException(__("You can not remove group super admin"));
        }
        /* remove the target as group admin */
        $db->query(sprintf("DELETE FROM groups_admins WHERE user_id = %s AND group_id = %s", secure($uid, 'int'), secure($id, 'int')));
        /* delete notification (group admin addation) to the target user */
        $this->delete_notification($uid, 'group_admin_addation', $group['group_title'], $group['group_name']);
        break;

      case 'group-member-remove':
        if ($uid == null) {
          throw new BadRequestException(__("Invalid input"));
        }
        /* check if the target already a group member */
        $check = $db->query(sprintf("SELECT * FROM groups_members WHERE user_id = %s AND group_id = %s", secure($uid, 'int'),  secure($id, 'int')));
        /* if no -> return */
        if ($check->num_rows == 0) return;
        /* get group */
        $get_group = $db->query(sprintf("SELECT * FROM `groups` WHERE group_id = %s", secure($id, 'int')));
        $group = $get_group->fetch_assoc();
        /* check if the target is the super group admin */
        if ($uid == $group['group_admin']) {
          throw new AuthorizationException(__("You can not remove group super admin"));
        }
        /* remove the target as group admin */
        $db->query(sprintf("DELETE FROM groups_admins WHERE user_id = %s AND group_id = %s", secure($uid, 'int'), secure($id, 'int')));
        /* remove the target as group member */
        $db->query(sprintf("DELETE FROM groups_members WHERE user_id = %s AND group_id = %s", secure($uid, 'int'), secure($id, 'int')));
        /* update members counter -1 */
        $db->query(sprintf("UPDATE `groups` SET group_members = IF(group_members=0,0,group_members-1) WHERE group_id = %s", secure($id, 'int')));
        break;

      case 'event-go':
        /* check if the viewer member to this event */
        $check = $db->query(sprintf("SELECT * FROM events_members WHERE user_id = %s AND event_id = %s", secure($this->_data['user_id'], 'int'), secure($id, 'int')));
        $invited = false;
        $interested = false;
        if ($check->num_rows > 0) {
          $member = $check->fetch_assoc();
          /* if going -> return */
          if ($member['is_going'] == '1') return;
          $invited = ($member['is_invited'] == '1') ? true : false;
          $interested = ($member['is_interested'] == '1') ? true : false;
        }
        $approved = false;
        if ($invited || $interested) {
          $approved = true;
        } else {
          /* get event */
          $get_event = $db->query(sprintf("SELECT * FROM `events` WHERE event_id = %s", secure($id, 'int')));
          $event = $get_event->fetch_assoc();
          if ($event['event_privacy'] == 'public') {
            /* the event is public */
            $approved = true;
          } elseif ($this->check_event_adminship($this->_data['user_id'], $event['event_id'])) {
            /* the event admin going his event */
            $approved = true;
          }
        }
        if ($approved) {
          if ($invited || $interested) {
            $db->query(sprintf("UPDATE events_members SET is_going = '1' WHERE user_id = %s AND event_id = %s", secure($this->_data['user_id'], 'int'), secure($id, 'int')));
          } else {
            $db->query(sprintf("INSERT INTO events_members (user_id, event_id, is_going) VALUES (%s, %s, '1')", secure($this->_data['user_id'], 'int'), secure($id, 'int')));
          }
          /* update going counter +1 */
          $db->query(sprintf("UPDATE `events` SET event_going = event_going + 1  WHERE event_id = %s", secure($id, 'int')));
        }
        break;

      case 'event-ungo':
        /* check if the viewer member to this event */
        $check = $db->query(sprintf("SELECT * FROM events_members WHERE user_id = %s AND event_id = %s", secure($this->_data['user_id'], 'int'), secure($id, 'int')));
        /* if no -> return */
        if ($check->num_rows == 0) return;
        $invited = false;
        $interested = false;
        $member = $check->fetch_assoc();
        /* if not going -> return */
        if ($member['is_going'] == '0') return;
        $invited = ($member['is_invited'] == '1') ? true : false;
        $interested = ($member['is_interested'] == '1') ? true : false;
        if (!$invited && !$interested) {
          $db->query(sprintf("DELETE FROM events_members WHERE user_id = %s AND event_id = %s", secure($this->_data['user_id'], 'int'), secure($id, 'int')));
        } else {
          $db->query(sprintf("UPDATE events_members SET is_going = '0' WHERE user_id = %s AND event_id = %s", secure($this->_data['user_id'], 'int'), secure($id, 'int')));
        }
        /* update going counter -1 */
        $db->query(sprintf("UPDATE `events` SET event_going = IF(event_going=0,0,event_going-1)  WHERE event_id = %s", secure($id, 'int')));
        break;

      case 'event-interest':
        /* check if the viewer member to this event */
        $check = $db->query(sprintf("SELECT * FROM events_members WHERE user_id = %s AND event_id = %s", secure($this->_data['user_id'], 'int'), secure($id, 'int')));
        $invited = false;
        $going = false;
        if ($check->num_rows > 0) {
          $member = $check->fetch_assoc();
          /* if interested -> return */
          if ($member['is_interested'] == '1') return;
          $invited = ($member['is_invited'] == '1') ? true : false;
          $going = ($member['is_going'] == '1') ? true : false;
        }
        $approved = false;
        if ($invited || $going) {
          $approved = true;
        } else {
          /* get event */
          $get_event = $db->query(sprintf("SELECT * FROM `events` WHERE event_id = %s", secure($id, 'int')));
          $event = $get_event->fetch_assoc();
          if ($event['event_privacy'] == 'public') {
            /* the event is public */
            $approved = true;
          } elseif ($this->check_event_adminship($this->_data['user_id'], $event['event_id'])) {
            /* the event admin interested his event */
            $approved = true;
          }
        }
        if ($approved) {
          if ($invited || $going) {
            $db->query(sprintf("UPDATE events_members SET is_interested = '1' WHERE user_id = %s AND event_id = %s", secure($this->_data['user_id'], 'int'), secure($id, 'int')));
          } else {
            $db->query(sprintf("INSERT INTO events_members (user_id, event_id, is_interested) VALUES (%s, %s, '1')", secure($this->_data['user_id'], 'int'), secure($id, 'int')));
          }
          /* update interested counter +1 */
          $db->query(sprintf("UPDATE `events` SET event_interested = event_interested + 1  WHERE event_id = %s", secure($id, 'int')));
        }
        break;

      case 'event-uninterest':
        /* check if the viewer member to this event */
        $check = $db->query(sprintf("SELECT * FROM events_members WHERE user_id = %s AND event_id = %s", secure($this->_data['user_id'], 'int'), secure($id, 'int')));
        /* if no -> return */
        if ($check->num_rows == 0) return;
        $invited = false;
        $going = false;
        $member = $check->fetch_assoc();
        /* if not interested -> return */
        if ($member['is_interested'] == '0') return;
        $invited = ($member['is_invited'] == '1') ? true : false;
        $going = ($member['is_going'] == '1') ? true : false;
        if (!$invited && !$going) {
          $db->query(sprintf("DELETE FROM events_members WHERE user_id = %s AND event_id = %s", secure($this->_data['user_id'], 'int'), secure($id, 'int')));
        } else {
          $db->query(sprintf("UPDATE events_members SET is_interested = '0' WHERE user_id = %s AND event_id = %s", secure($this->_data['user_id'], 'int'), secure($id, 'int')));
        }
        /* update interested counter -1 */
        $db->query(sprintf("UPDATE `events` SET event_interested = IF(event_interested=0,0,event_interested-1)  WHERE event_id = %s", secure($id, 'int')));
        break;

      case 'event-boost':
        if ($this->_is_admin) {
          /* check if the user is the system admin */
          $check = $db->query(sprintf("SELECT * FROM `events` WHERE event_id = %s", secure($id, 'int')));
        } else {
          /* check if the user is the page admin */
          $check = $db->query(sprintf("SELECT * FROM `events` WHERE event_id = %s AND event_admin = %s", secure($id, 'int'), secure($this->_data['user_id'], 'int')));
        }
        if ($check->num_rows == 0) {
          throw new AuthorizationException(__("You can't boost this event"));
        }
        $event = $check->fetch_assoc();
        /* check if viewer can boost event */
        if (!$this->_data['can_boost_events']) {
          throw new AuthorizationException(__("You reached the maximum number of boosted events! Upgrade your package to get more"));
        }
        /* boost event */
        if (!$event['event_boosted']) {
          /* boost group */
          $db->query(sprintf("UPDATE `events` SET event_boosted = '1', event_boosted_by = %s WHERE event_id = %s", secure($this->_data['user_id'], 'int'), secure($id, 'int')));
          /* update user */
          $db->query(sprintf("UPDATE users SET user_boosted_events = user_boosted_events + 1 WHERE user_id = %s", secure($this->_data['user_id'], 'int')));
        }
        break;

      case 'event-unboost':
        if ($this->_is_admin) {
          /* check if the user is the system admin */
          $check = $db->query(sprintf("SELECT * FROM `events` WHERE event_id = %s", secure($id, 'int')));
        } else {
          /* check if the user is the page admin */
          $check = $db->query(sprintf("SELECT * FROM `events` WHERE event_id = %s AND event_admin = %s", secure($id, 'int'), secure($this->_data['user_id'], 'int')));
        }
        if ($check->num_rows == 0) {
          throw new AuthorizationException(__("You can't unboost this event"));
        }
        $event = $check->fetch_assoc();
        /* unboost event */
        if ($event['event_boosted']) {
          /* unboost event */
          $db->query(sprintf("UPDATE `events` SET event_boosted = '0', event_boosted_by = NULL WHERE event_id = %s", secure($id, 'int')));
          /* update user */
          $db->query(sprintf("UPDATE users SET user_boosted_events = IF(user_boosted_events=0,0,user_boosted_events-1) WHERE user_id = %s", secure($this->_data['user_id'], 'int')));
        }
        break;

      case 'event-invite':
        if ($uid == null) {
          throw new BadRequestException(__("Invalid input"));
        }
        /* check if the viewer is event member */
        $check_viewer = $db->query(sprintf("SELECT `events`.* FROM `events` INNER JOIN events_members ON `events`.event_id = events_members.event_id WHERE events_members.user_id = %s AND events_members.event_id = %s", secure($this->_data['user_id'], 'int'), secure($id, 'int')));
        /* if no -> return */
        if ($check_viewer->num_rows == 0) return;
        /* check if the target already event member */
        $check_target = $db->query(sprintf("SELECT * FROM events_members WHERE user_id = %s AND event_id = %s", secure($uid, 'int'),  secure($id, 'int')));
        /* if yes -> return */
        if ($check_target->num_rows > 0) return;
        /* get event */
        $event = $check_viewer->fetch_assoc();
        /* insert invitation */
        $db->query(sprintf("INSERT INTO events_members (user_id, event_id, is_invited) VALUES (%s, %s, '1')", secure($uid, 'int'), secure($id, 'int')));
        /* update invited counter +1 */
        $db->query(sprintf("UPDATE `events` SET event_invited = event_invited + 1  WHERE event_id = %s", secure($id, 'int')));
        /* send notification (page invitation) to the target user */
        $this->post_notification(['to_user_id' => $uid, 'action' => 'event_invitation', 'node_type' => $event['event_title'], 'node_url' => $event['event_id']]);
        break;
    }
  }


  /**
   * connection
   * 
   * @param integer $user_id
   * @param boolean $friendship
   * @return string
   */
  public function connection($user_id, $friendship = true)
  {
    /* check which type of connection (friendship|follow) connections to get */
    if ($friendship) {
      /* check if there is a logged user */
      if (!$this->_logged_in) {
        /* no logged user */
        return "add";
      }
      /* check if the viewer is the target */
      if ($user_id == $this->_data['user_id']) {
        return "me";
      }
      /* check if the viewer & the target are friends */
      if ($this->friendship_approved($user_id)) {
        return "remove";
      }
      /* check if the target sent a request to the viewer */
      if ($this->is_friend_request($user_id)) {
        return "request";
      }
      /* check if the viewer sent a request to the target */
      if ($this->is_friend_request_sent($user_id)) {
        return "cancel";
      }
      /* check if the viewer declined the friend request to the target */
      if ($this->friendship_declined($user_id)) {
        return "declined";
      }
      /* there is no relation between the viewer & the target */
      return "add";
    } else {
      /* check if there is a logged user */
      if (!$this->_logged_in) {
        /* no logged user */
        return "follow";
      }
      /* check if the viewer is the target */
      if ($user_id == $this->_data['user_id']) {
        return "me";
      }
      if ($this->is_following($user_id)) {
        /* the viewer follow the target */
        return "unfollow";
      } else {
        /* the viewer not follow the target */
        return "follow";
      }
    }
  }


  /**
   * banned
   *
   * @param integer $user_id
   * @return boolean
   */
  public function banned($user_id)
  {
    global $db;
    $check = $db->query(sprintf("SELECT COUNT(*) as count FROM users WHERE user_banned = '1' AND user_id = %s", secure($user_id, 'int')));
    if ($check->fetch_assoc()['count'] > 0) {
      return true;
    }
    return false;
  }


  /**
   * blocked
   * 
   * @param integer $user_id
   * @return boolean
   */
  public function blocked($user_id)
  {
    global $db;
    /* bypass the block if the viewer is admin or moderator  */
    if ($this->_data['user_group'] < 3) {
      return false;
    }
    /* check if there is any blocking between the viewer & the target */
    if ($this->_logged_in) {
      $check = $db->query(sprintf('SELECT COUNT(*) as count FROM users_blocks WHERE (user_id = %1$s AND blocked_id = %2$s) OR (user_id = %2$s AND blocked_id = %1$s)', secure($this->_data['user_id'], 'int'),  secure($user_id, 'int')));
      if ($check->fetch_assoc()['count'] > 0) {
        return true;
      }
    }
    return false;
  }


  /**
   * friendship_approved
   * 
   * @param integer $user_id
   * @return boolean
   */
  public function friendship_approved($user_id)
  {
    global $system;
    /* check if there is any approved friendship/follow request between the viewer & the target */
    if ($this->_logged_in) {
      $connections = $system['friends_enabled'] ? $this->_data['friends_ids'] : $this->_data['followings_ids'];
      /* check if the viewer & the target are friends/following */
      return (in_array($user_id, $connections)) ? true : false;
    }
    return false;
  }


  /**
   * friendship_declined
   * 
   * @param integer $user_id
   * @return boolean
   */
  public function friendship_declined($user_id)
  {
    global $db;
    /* check if there is any declined friendship request between the viewer & the target */
    if ($this->_logged_in) {
      $check = $db->query(sprintf('SELECT COUNT(*) as count FROM friends WHERE status = -1 AND (user_one_id = %1$s AND user_two_id = %2$s) OR (user_one_id = %2$s AND user_two_id = %1$s)', secure($this->_data['user_id'], 'int'),  secure($user_id, 'int')));
      if ($check->fetch_assoc()['count'] > 0) {
        return true;
      }
    }
    return false;
  }


  /**
   * is_following
   * 
   * @param integer $user_id
   * @return boolean
   */
  public function is_following($user_id)
  {
    if ($this->_logged_in) {
      return (in_array($user_id, $this->_data['followings_ids'])) ? true : false;
    }
    return false;
  }


  /**
   * is_friend_request
   * 
   * @param integer $user_id
   * @return boolean
   */
  public function is_friend_request($user_id)
  {
    if ($this->_logged_in) {
      return (in_array($user_id, $this->_data['friend_requests_ids'])) ? true : false;
    }
    return false;
  }


  /**
   * is_friend_request_sent
   * 
   * @param integer $user_id
   * @return boolean
   */
  public function is_friend_request_sent($user_id)
  {
    if ($this->_logged_in) {
      return (in_array($user_id, $this->_data['friend_requests_sent_ids'])) ? true : false;
    }
    return false;
  }


  public function is_top_friend($user_id)
  {
    global $db;
    if ($this->_logged_in) {
      $check = $db->query(sprintf("SELECT COUNT(*) as count FROM users_top_friends WHERE user_id = %s AND friend_id = %s", secure($this->_data['user_id'], 'int'), secure($user_id, 'int')));
      if ($check->fetch_assoc()['count'] > 0) {
        return true;
      }
    }
    return false;
  }


  /**
   * poked
   * 
   * @param integer $user_id
   * @return boolean
   */
  public function is_poked($user_id)
  {
    global $db;
    /* check if the viewer poked the target before */
    if ($this->_logged_in) {
      $check = $db->query(sprintf("SELECT COUNT(*) as count FROM users_pokes WHERE user_id = %s AND poked_id = %s ", secure($this->_data['user_id'], 'int'),  secure($user_id, 'int')));
      if ($check->fetch_assoc()['count'] > 0) {
        return true;
      }
    }
    return false;
  }


  /**
   * delete_user
   * 
   * @param integer $user_id
   * @return void
   */
  public function delete_user($user_id)
  {
    global $db;
    /* (check&get) user */
    $get_user = $db->query(sprintf("SELECT user_group FROM users WHERE user_id = %s", secure($user_id, 'int')));
    if ($get_user->num_rows == 0) {
      throw new BadRequestException(__("User not found"));
    }
    $user = $get_user->fetch_assoc();
    // delete user
    $can_delete = false;
    /* target is (admin|moderator) */
    if ($user['user_group'] < 3) {
      throw new BadRequestException(__("You can not delete admin/morderator accounts"));
    }
    /* viewer is (admin|moderator) */
    if ($this->_data['user_group'] < 3) {
      $can_delete = true;
    }
    /* viewer is the target */
    if ($this->_data['user_id'] == $user_id) {
      $can_delete = true;
    }
    /* delete the user */
    if ($can_delete) {
      /* delete user posts */
      $this->delete_posts($user_id);
      /* delete the user */
      $db->query(sprintf("DELETE FROM users WHERE user_id = %s", secure($user_id, 'int')));
      /* delete user posts */
      $this->delete_posts($user_id);
      /* delete all user pages */
      $db->query(sprintf("DELETE FROM pages WHERE page_admin = %s", secure($user_id, 'int')));
      $db->query(sprintf("DELETE FROM pages_admins WHERE user_id = %s", secure($user_id, 'int')));
      /* update all pages likes counter */
      $db->query(sprintf("UPDATE pages SET page_likes = IF(page_likes=0,0,page_likes-1) WHERE page_id IN (SELECT page_id FROM pages_likes WHERE user_id = %s)", secure($user_id, 'int')));
      /* delete the user from all liked pages */
      $db->query(sprintf("DELETE FROM pages_likes WHERE user_id = %s", secure($user_id, 'int')));
      /* delete the user from all invited pages */
      $db->query(sprintf("DELETE FROM pages_invites WHERE user_id = %s OR from_user_id = %s", secure($user_id, 'int'), secure($user_id, 'int')));
      /* delete all user groups */
      $db->query(sprintf("DELETE FROM `groups` WHERE group_admin = %s", secure($user_id, 'int')));
      $db->query(sprintf("DELETE FROM groups_admins WHERE user_id = %s", secure($user_id, 'int')));
      /* update all groups members counter */
      $db->query(sprintf("UPDATE `groups` SET group_members = IF(group_members=0,0,group_members-1) WHERE group_id IN (SELECT group_id FROM groups_members WHERE user_id = %s)", secure($user_id, 'int')));
      /* delete the user from all joined groups */
      $db->query(sprintf("DELETE FROM groups_members WHERE user_id = %s", secure($user_id, 'int')));
      /* delete all user events */
      $db->query(sprintf("DELETE FROM `events` WHERE event_admin = %s", secure($user_id, 'int')));
      /* update all events counters */
      $db->query(sprintf("UPDATE `events` SET event_invited = IF(event_invited=0,0,event_invited-1) WHERE event_id IN (SELECT event_id FROM events_members WHERE is_invited = '1' AND user_id = %s)", secure($user_id, 'int')));
      $db->query(sprintf("UPDATE `events` SET event_interested = IF(event_interested=0,0,event_interested-1) WHERE event_id IN (SELECT event_id FROM events_members WHERE is_interested = '1' AND user_id = %s)", secure($user_id, 'int')));
      $db->query(sprintf("UPDATE `events` SET event_going = IF(event_going=0,0,event_going-1) WHERE event_id IN (SELECT event_id FROM events_members WHERE is_going = '1' AND user_id = %s)", secure($user_id, 'int')));
      /* delete the user from all joined events */
      $db->query(sprintf("DELETE FROM events_members WHERE user_id = %s", secure($user_id, 'int')));
      /* delete all user friends connections */
      $db->query(sprintf('DELETE FROM friends WHERE user_one_id = %1$s OR user_two_id = %1$s', secure($user_id, 'int')));
      /* delete all user following connections */
      $db->query(sprintf('DELETE FROM followings WHERE user_id = %1$s OR following_id = %1$s', secure($user_id, 'int')));
      /* delete all user messages */
      $db->query(sprintf('DELETE FROM conversations_messages WHERE user_id = %s', secure($user_id, 'int')));
    }
  }


  /**
   * _follow
   * 
   * @param integer $user_id
   * @return void
   */
  private function _follow($user_id)
  {
    global $db, $date;
    /* check blocking */
    if ($this->blocked($user_id)) {
      _error(403);
    }
    /* check if the viewer already follow the target */
    $check = $db->query(sprintf("SELECT COUNT(*) as count FROM followings WHERE user_id = %s AND following_id = %s", secure($this->_data['user_id'], 'int'),  secure($user_id, 'int')));
    /* if yes -> return */
    if ($check->fetch_assoc()['count'] > 0) return;
    /* add as following */
    $db->query(sprintf("INSERT INTO followings (user_id, following_id, time) VALUES (%s, %s, %s)", secure($this->_data['user_id'], 'int'),  secure($user_id, 'int'), secure($date)));
    /* post new notification */
    $this->post_notification(['to_user_id' => $user_id, 'action' => 'follow']);
    /* points balance */
    $this->points_balance("add", $user_id, "follow", $this->_data['user_id']);
  }


  /**
   * _unfollow
   * 
   * @param integer $user_id
   * @return void
   */
  private function _unfollow($user_id)
  {
    global $db;
    /* check if the viewer already follow the target */
    $check = $db->query(sprintf("SELECT COUNT(*) as count FROM followings WHERE user_id = %s AND following_id = %s", secure($this->_data['user_id'], 'int'),  secure($user_id, 'int')));
    /* if no -> return */
    if ($check->fetch_assoc()['count'] == 0) return;
    /* delete from viewer's followings */
    $db->query(sprintf("DELETE FROM followings WHERE user_id = %s AND following_id = %s", secure($this->_data['user_id'], 'int'), secure($user_id, 'int')));
    /* delete notification */
    $this->delete_notification($user_id, 'follow');
    /* points balance */
    $this->points_balance("delete", $user_id, "follow");
  }



  /* ------------------------------- */
  /* Popovers */
  /* ------------------------------- */

  /**
   * popover
   * 
   * @param integer $id
   * @param string $type
   * @return array
   */
  public function popover($id, $type)
  {
    global $system, $db;
    $profile = [];
    /* check the type to get */
    if ($type == "user") {
      /* get user info */
      $get_profile = $db->query(sprintf("SELECT * FROM users WHERE user_id = %s", secure($id, 'int')));
      if ($get_profile->num_rows > 0) {
        $profile = $get_profile->fetch_assoc();
        /* get profile picture */
        $profile['user_picture'] = get_picture($profile['user_picture'], $profile['user_gender']);
        /* get followers count */
        $profile['followers_count'] = $this->get_followers_count($profile['user_id']);
        /* get mutual friends count between the viewer and the target */
        if ($this->_logged_in && $this->_data['user_id'] != $profile['user_id']) {
          $profile['mutual_friends_count'] = $this->get_mutual_friends_count($profile['user_id']);
        }
        /* get the connection between the viewer & the target */
        if ($profile['user_id'] != $this->_data['user_id']) {
          $profile['we_friends'] = $this->friendship_approved($profile['user_id']);
          $profile['he_request'] = $this->is_friend_request($profile['user_id']);
          $profile['i_request'] = $this->is_friend_request_sent($profile['user_id']);
          $profile['i_follow'] = $this->is_following($profile['user_id']);
        }
        $profile['chat_price'] = 0;
        if ($system['monetization_enabled'] && $this->check_user_permission($profile['user_id'], 'monetization_permission')) {
          if ($profile['user_monetization_enabled'] && $profile['user_monetization_chat_price'] > 0) {
            $profile['chat_price'] = $profile['user_monetization_chat_price'];
          }
        }
      }
    } else {
      /* get page info */
      $get_profile = $db->query(sprintf("SELECT * FROM pages WHERE page_id = %s", secure($id, 'int')));
      if ($get_profile->num_rows > 0) {
        $profile = $get_profile->fetch_assoc();
        $profile['page_picture'] = get_picture($profile['page_picture'], "page");
        /* check if the viewer liked the page */
        $profile['i_like'] = $this->check_page_membership($this->_data['user_id'], $id);
      }
    }
    return $profile;
  }



  /* ------------------------------- */
  /* User Settings */
  /* ------------------------------- */

  /**
   * settings
   * 
   * @param string $edit
   * @param array $args
   * @return void
   */
  public function settings($edit, $args)
  {
    global $db, $system;
    switch ($edit) {
      case 'account':
        /* validate current password (MD5 check for versions < v2.5) */
        if (md5($args['password']) != $this->_data['user_password'] && !password_verify($args['password'], $this->_data['user_password'])) {
          throw new Exception(__("Your current password is incorrect"));
        }
        /* validate email */
        if ($args['email'] != $this->_data['user_email']) {
          $this->activation_email_reset($args['email']);
        }
        /* validate phone */
        if (isset($args['phone']) && $args['phone'] != $this->_data['user_phone']) {
          $this->activation_phone_reset($args['phone']);
        }
        /* validate username */
        if (!$system['disable_username_changes']) {
          if (strtolower($args['username']) != strtolower($this->_data['user_name'])) {
            if (!valid_username($args['username'])) {
              throw new Exception(__("Please enter a valid username (a-z0-9_.) with minimum 3 characters long"));
            }
            if ($this->reserved_username($args['username'])) {
              throw new Exception(__("You can't use") . " " . $args['username'] . " " . __("as username"));
            }
            if ($this->check_username($args['username'])) {
              throw new Exception(__("Sorry, it looks like") . " " . $args['username'] . " " . __("belongs to an existing account"));
            }
            /* update user */
            $db->query(sprintf("UPDATE users SET user_name = %s WHERE user_id = %s", secure($args['username']), secure($this->_data['user_id'], 'int')));
            /* verification badge */
            if ($this->_data['user_verified']) {
              $db->query(sprintf("UPDATE users SET user_verified = '0' WHERE user_id = %s", secure($this->_data['user_id'], 'int')));
            }
          }
        }
        break;

      case 'basic':
        if (!$system['show_usernames_enabled']) {
          /* validate firstname */
          if (is_empty($args['firstname'])) {
            throw new Exception(__("You must enter first name"));
          }
          if (!valid_name($args['firstname'])) {
            throw new Exception(__("First name contains invalid characters"));
          }
          if (strlen($args['firstname']) < $system['name_min_length']) {
            throw new Exception(__("First name must be at least") . " " . $system['name_min_length'] . " " . __("characters long. Please try another"));
          }
          if (strlen($args['firstname']) > $system['name_max_length']) {
            throw new Exception(__("First name must be at most") . " " . $system['name_max_length'] . " " . __("characters long. Please try another"));
          }
          /* validate lastname */
          if (is_empty($args['lastname'])) {
            throw new Exception(__("You must enter last name"));
          }
          if (!valid_name($args['lastname'])) {
            throw new Exception(__("Last name contains invalid characters"));
          }
          if (strlen($args['lastname']) < $system['name_min_length']) {
            throw new Exception(__("Last name must be at least") . " " . $system['name_min_length'] . " " . __("characters long. Please try another"));
          }
          if (strlen($args['lastname']) > $system['name_max_length']) {
            throw new Exception(__("Last name must be at most") . " " . $system['name_max_length'] . " " . __("characters long. Please try another"));
          }
        } else {
          $args['firstname'] = $this->_data['user_firstname'];
          $args['lastname'] = $this->_data['user_lastname'];
        }
        /* validate gender */
        $args['gender'] = ($system['genders_disabled']) ? 1 : $args['gender'];
        if (!$system['genders_disabled'] && !$this->check_gender($args['gender'])) {
          throw new Exception(__("Please select a valid gender"));
        }
        /* validate country */
        if ($args['country'] == "none") {
          throw new Exception(__("You must select valid country"));
        } else {
          if (!$this->check_country($args['country'])) {
            throw new Exception(__("You must select valid country"));
          }
        }
        /* validate birthdate */
        if ($args['birth_month'] == "none" && $args['birth_day'] == "none" && $args['birth_year'] == "none") {
          $args['birth_date'] = 'null';
        } else {
          if (!in_array($args['birth_month'], range(1, 12))) {
            throw new Exception(__("Please select a valid birth month"));
          }
          if (!in_array($args['birth_day'], range(1, 31))) {
            throw new Exception(__("Please select a valid birth day"));
          }
          if (!in_array($args['birth_year'], range(1905, 2015))) {
            throw new Exception(__("Please select a valid birth year"));
          }
          $args['birth_date'] = $args['birth_year'] . '-' . $args['birth_month'] . '-' . $args['birth_day'];
        }
        /* validate relationship */
        if (!isset($args['relationship']) || $args['relationship'] == "none") {
          $args['relationship'] = 'null';
        } else {
          $relationships = ['single', 'relationship', 'married', "complicated", 'separated', 'divorced', 'widowed'];
          if (!in_array($args['relationship'], $relationships)) {
            throw new Exception(__("Please select a valid relationship"));
          }
        }
        /* validate website */
        if (!is_empty($args['website'])) {
          if (!valid_url($args['website'])) {
            throw new Exception(__("Please enter a valid website"));
          }
        } else {
          $args['website'] = 'null';
        }
        /* set custom fields */
        $this->set_custom_fields($args, "user", "settings", $this->_data['user_id']);
        /* update user */
        $db->query(sprintf("UPDATE users SET user_firstname = %s, user_lastname = %s, user_gender = %s, user_country = %s, user_birthdate = %s, user_relationship = %s, user_biography = %s, user_website = %s WHERE user_id = %s", secure($args['firstname']), secure($args['lastname']), secure($args['gender']), secure($args['country'], 'int'), secure($args['birth_date']), secure($args['relationship']), secure($args['biography']), secure($args['website']), secure($this->_data['user_id'], 'int')));
        /* verification badge */
        if ($this->_data['user_verified'] && ($this->_data['user_firstname'] !=  $args['firstname'] || $this->_data['user_lastname'] !=  $args['lastname'])) {
          $db->query(sprintf("UPDATE users SET user_verified = '0' WHERE user_id = %s", secure($this->_data['user_id'], 'int')));
        }
        break;

      case 'work':
        /* validate work website */
        if (!is_empty($args['work_url'])) {
          /* check if contains https:// or http:// if not add it */
          if (!preg_match("~^(?:f|ht)tps?://~i", $args['work_url'])) {
            $args['work_url'] = "https://" . $args['work_url'];
          }
          if (!valid_url($args['work_url'])) {
            throw new Exception(__("Please enter a valid work website"));
          }
        } else {
          $args['work_url'] = 'null';
        }
        /* set custom fields */
        $this->set_custom_fields($args, "user", "settings", $this->_data['user_id']);
        /* update user */
        $db->query(sprintf("UPDATE users SET user_work_title = %s, user_work_place = %s, user_work_url = %s WHERE user_id = %s", secure($args['work_title']), secure($args['work_place']), secure($args['work_url']), secure($this->_data['user_id'], 'int')));
        break;

      case 'location':
        /* set custom fields */
        $this->set_custom_fields($args, "user", "settings", $this->_data['user_id']);
        /* update user */
        $db->query(sprintf("UPDATE users SET user_current_city = %s, user_hometown = %s WHERE user_id = %s", secure($args['city']), secure($args['hometown']), secure($this->_data['user_id'], 'int')));
        break;

      case 'education':
        /* set custom fields */
        $this->set_custom_fields($args, "user", "settings", $this->_data['user_id']);
        /* update user */
        $db->query(sprintf("UPDATE users SET user_edu_major = %s, user_edu_school = %s, user_edu_class = %s WHERE user_id = %s", secure($args['edu_major']), secure($args['edu_school']), secure($args['edu_class']), secure($this->_data['user_id'], 'int')));
        break;

      case 'other':
        /* set custom fields */
        $this->set_custom_fields($args, "user", "settings", $this->_data['user_id']);
        break;

      case 'social':
        /* validate facebook */
        if (!is_empty($args['facebook']) && !valid_url($args['facebook'])) {
          throw new Exception(__("Please enter a valid Facebook Profile URL"));
        }
        /* validate twitter */
        if (!is_empty($args['twitter']) && !valid_url($args['twitter'])) {
          throw new Exception(__("Please enter a valid Twitter Profile URL"));
        }
        /* validate youtube */
        if (!is_empty($args['youtube']) && !valid_url($args['youtube'])) {
          throw new Exception(__("Please enter a valid YouTube Profile URL"));
        }
        /* validate instagram */
        if (!is_empty($args['instagram']) && !valid_url($args['instagram'])) {
          throw new Exception(__("Please enter a valid Instagram Profile URL"));
        }
        /* validate twitch */
        if (!is_empty($args['twitch']) && !valid_url($args['twitch'])) {
          throw new Exception(__("Please enter a valid Twitch Profile URL"));
        }
        /* validate linkedin */
        if (!is_empty($args['linkedin']) && !valid_url($args['linkedin'])) {
          throw new Exception(__("Please enter a valid Linkedin Profile URL"));
        }
        /* validate vkontakte */
        if (!is_empty($args['vkontakte']) && !valid_url($args['vkontakte'])) {
          throw new Exception(__("Please enter a valid Vkontakte Profile URL"));
        }
        /* update user */
        $db->query(sprintf("UPDATE users SET user_social_facebook = %s, user_social_twitter = %s, user_social_youtube = %s, user_social_instagram = %s, user_social_twitch = %s, user_social_linkedin = %s, user_social_vkontakte = %s WHERE user_id = %s", secure($args['facebook']), secure($args['twitter']), secure($args['youtube']), secure($args['instagram']), secure($args['twitch']), secure($args['linkedin']), secure($args['vkontakte']), secure($this->_data['user_id'], 'int')));
        break;

      case 'design':
        /* check if profile background enabled */
        if (!$system['system_profile_background_enabled']) {
          throw new Exception(__("The profile background feature has been disabled by the admin"));
        }
        /* update user */
        $db->query(sprintf("UPDATE users SET user_profile_background = %s WHERE user_id = %s", secure($args['user_profile_background']), secure($this->_data['user_id'], 'int')));
        /* remove pending uploads */
        remove_pending_uploads([$args['user_profile_background']]);
        break;

      case 'password':
        /* validate all fields */
        if (is_empty($args['current']) || is_empty($args['new']) || is_empty($args['confirm'])) {
          throw new Exception(__("You must fill in all of the fields"));
        }
        /* validate current password (MD5 check for versions < v2.5) */
        if (md5($args['current']) != $this->_data['user_password'] && !password_verify($args['current'], $this->_data['user_password'])) {
          throw new Exception(__("Your current password is incorrect"));
        }
        /* validate new password */
        if ($args['new'] != $args['confirm']) {
          throw new Exception(__("Your passwords do not match"));
        }
        /* check password */
        $this->check_password($args['new']);
        /* update user */
        $db->query(sprintf("UPDATE users SET user_password = %s WHERE user_id = %s", secure(_password_hash($args['new'])), secure($this->_data['user_id'], 'int')));
        /* delete sessions */
        $db->query(sprintf("DELETE FROM users_sessions WHERE session_id != %s AND user_id = %s", secure($this->_data['active_session_id']), secure($this->_data['user_id'], 'int')));
        break;

      case 'two-factor':
        if ($system['two_factor_type'] != $args['type']) {
          _error(400);
        }
        /* prepare */
        $args['two_factor_enabled'] = (isset($args['two_factor_enabled'])) ? '1' : '0';
        switch ($system['two_factor_type']) {
          case 'email':
            if ($args['two_factor_enabled'] && !$this->_data['user_email_verified']) {
              throw new Exception(__("Two-Factor Authentication can't be enabled till you verify your email address"));
            }
            break;

          case 'sms':
            if ($args['two_factor_enabled'] && !$this->_data['user_phone']) {
              throw new Exception(__("Two-Factor Authentication can't be enabled till you enter your phone number"));
            }
            if ($args['two_factor_enabled'] && !$this->_data['user_phone_verified']) {
              throw new Exception(__("Two-Factor Authentication can't be enabled till you verify your phone number"));
            }
            break;

          case 'google':
            if (isset($args['gcode'])) {
              /* Google Authenticator */
              $ga = new Sonata\GoogleAuthenticator\GoogleAuthenticator();
              /* verify code */
              if (!$ga->checkCode($this->_data['user_two_factor_gsecret'], $args['gcode'])) {
                throw new Exception(__("Invalid code, Try again or try to scan your QR code again"));
              }
              $args['two_factor_enabled'] = '1';
            }
            break;
        }
        /* update user */
        $db->query(sprintf("UPDATE users SET user_two_factor_enabled = %s, user_two_factor_type = %s WHERE user_id = %s", secure($args['two_factor_enabled']), secure($system['two_factor_type']), secure($this->_data['user_id'], 'int')));
        break;

      case 'privacy':
        /* prepare */
        $privacy = ['me', 'friends', 'public'];
        /* check if chat enabled */
        $args['user_chat_enabled'] = (isset($args['user_chat_enabled'])) ? '1' : '0';
        /* check if newsletter enabled */
        $args['user_newsletter_enabled'] = (isset($args['user_newsletter_enabled'])) ? '1' : '0';
        /* check if tips enabled */
        $args['user_tips_enabled'] = (isset($args['user_tips_enabled'])) ? '1' : '0';
        /* check if hidden from suggestions enabled */
        $args['user_suggestions_hidden'] = (isset($args['user_suggestions_hidden'])) ? '1' : '0';
        /* check if chat enabled */
        $args['user_privacy_chat'] = (isset($args['user_privacy_chat'])) ? $args['user_privacy_chat'] : 'public';
        /* check if pokes enabled */
        $args['user_privacy_poke'] = (isset($args['user_privacy_poke'])) ? $args['user_privacy_poke'] : 'public';
        /* check if gifts enabled */
        $args['user_privacy_gifts'] = (isset($args['user_privacy_gifts'])) ? $args['user_privacy_gifts'] : 'public';
        /* check if wall posts enabled */
        $args['user_privacy_wall'] = (isset($args['user_privacy_wall'])) ? $args['user_privacy_wall'] : 'public';
        /* check if genders enabled */
        $args['user_privacy_gender'] = (isset($args['user_privacy_gender'])) ? $args['user_privacy_gender'] : 'public';
        /* check if relationship info enabled */
        $args['user_privacy_relationship'] = (isset($args['user_privacy_relationship'])) ? $args['user_privacy_relationship'] : 'public';
        /* check if work info enabled */
        $args['user_privacy_work'] = (isset($args['user_privacy_work'])) ? $args['user_privacy_work'] : 'public';
        /* check if location info enabled */
        $args['user_privacy_location'] = (isset($args['user_privacy_location'])) ? $args['user_privacy_location'] : 'public';
        /* check if education info enabled */
        $args['user_privacy_education'] = (isset($args['user_privacy_education'])) ? $args['user_privacy_education'] : 'public';
        /* check if friends enabled */
        $args['user_privacy_friends'] = (isset($args['user_privacy_friends'])) ? $args['user_privacy_friends'] : 'public';
        /* check if subscriptions enabled */
        $args['user_privacy_subscriptions'] = (isset($args['user_privacy_subscriptions'])) ? $args['user_privacy_subscriptions'] : 'public';
        /* check if pages enabled */
        $args['user_privacy_pages'] = (isset($args['user_privacy_pages'])) ? $args['user_privacy_pages'] : 'public';
        /* check if groups enabled */
        $args['user_privacy_groups'] = (isset($args['user_privacy_groups'])) ? $args['user_privacy_groups'] : 'public';
        /* check if events enabled */
        $args['user_privacy_events'] = (isset($args['user_privacy_events'])) ? $args['user_privacy_events'] : 'public';
        /* check if valid privacy */
        if (!in_array($args['user_privacy_chat'], $privacy) || !in_array($args['user_privacy_poke'], $privacy) || !in_array($args['user_privacy_gifts'], $privacy) || !in_array($args['user_privacy_wall'], $privacy) || !in_array($args['user_privacy_gender'], $privacy) || !in_array($args['user_privacy_relationship'], $privacy) || !in_array($args['user_privacy_birthdate'], $privacy) || !in_array($args['user_privacy_basic'], $privacy) || !in_array($args['user_privacy_work'], $privacy) || !in_array($args['user_privacy_location'], $privacy) || !in_array($args['user_privacy_education'], $privacy) || !in_array($args['user_privacy_other'], $privacy) || !in_array($args['user_privacy_friends'], $privacy) || !in_array($args['user_privacy_followers'], $privacy) || !in_array($args['user_privacy_subscriptions'], $privacy) || !in_array($args['user_privacy_photos'], $privacy) || !in_array($args['user_privacy_pages'], $privacy) || !in_array($args['user_privacy_groups'], $privacy) || !in_array($args['user_privacy_events'], $privacy)) {
          _error(400);
        }
        /* update user */
        $db->query(sprintf(
          "UPDATE users SET 
                    user_chat_enabled = %s, 
                    user_newsletter_enabled = %s,
                    user_tips_enabled = %s,
                    user_suggestions_hidden = %s,
                    user_privacy_chat = %s,
                    user_privacy_poke = %s,
                    user_privacy_gifts = %s,
                    user_privacy_wall = %s,
                    user_privacy_gender = %s, 
                    user_privacy_relationship = %s,
                    user_privacy_birthdate = %s, 
                    user_privacy_basic = %s, 
                    user_privacy_work = %s, 
                    user_privacy_location = %s, 
                    user_privacy_education = %s, 
                    user_privacy_other = %s, 
                    user_privacy_friends = %s, 
                    user_privacy_followers = %s, 
                    user_privacy_subscriptions = %s, 
                    user_privacy_photos = %s, 
                    user_privacy_pages = %s, 
                    user_privacy_groups = %s, 
                    user_privacy_events = %s 
                    WHERE user_id = %s",
          secure($args['user_chat_enabled']),
          secure($args['user_newsletter_enabled']),
          secure($args['user_tips_enabled']),
          secure($args['user_suggestions_hidden']),
          secure($args['user_privacy_chat']),
          secure($args['user_privacy_poke']),
          secure($args['user_privacy_gifts']),
          secure($args['user_privacy_wall']),
          secure($args['user_privacy_gender']),
          secure($args['user_privacy_relationship']),
          secure($args['user_privacy_birthdate']),
          secure($args['user_privacy_basic']),
          secure($args['user_privacy_work']),
          secure($args['user_privacy_location']),
          secure($args['user_privacy_education']),
          secure($args['user_privacy_other']),
          secure($args['user_privacy_friends']),
          secure($args['user_privacy_followers']),
          secure($args['user_privacy_subscriptions']),
          secure($args['user_privacy_photos']),
          secure($args['user_privacy_pages']),
          secure($args['user_privacy_groups']),
          secure($args['user_privacy_events']),
          secure($this->_data['user_id'], 'int')
        ));
        break;

      case 'notifications':
        /* prepare */
        $args['chat_sound'] = (isset($args['chat_sound'])) ? '1' : '0';
        $args['notifications_sound'] = (isset($args['notifications_sound'])) ? '1' : '0';
        $args['email_post_likes'] = (isset($args['email_post_likes'])) ? '1' : '0';
        $args['email_post_comments'] = (isset($args['email_post_comments'])) ? '1' : '0';
        $args['email_post_shares'] = (isset($args['email_post_shares'])) ? '1' : '0';
        $args['email_wall_posts'] = (isset($args['email_wall_posts'])) ? '1' : '0';
        $args['email_mentions'] = (isset($args['email_mentions'])) ? '1' : '0';
        $args['email_profile_visits'] = (isset($args['email_profile_visits'])) ? '1' : '0';
        $args['email_friend_requests'] = (isset($args['email_friend_requests'])) ? '1' : '0';
        $args['email_user_verification'] = (isset($args['email_user_verification'])) ? '1' : '0';
        $args['email_user_post_approval'] = (isset($args['email_user_post_approval'])) ? '1' : '0';
        $args['email_admin_verifications'] = (isset($args['email_admin_verifications'])) ? '1' : '0';
        $args['email_admin_post_approval'] = (isset($args['email_admin_post_approval'])) ? '1' : '0';
        $args['email_admin_user_approval'] = (isset($args['email_admin_user_approval'])) ? '1' : '0';
        /* update user */
        $db->query(sprintf("UPDATE users SET chat_sound = %s, notifications_sound = %s, email_post_likes = %s, email_post_comments = %s, email_post_shares = %s, email_wall_posts = %s, email_mentions = %s, email_profile_visits = %s, email_friend_requests = %s, email_user_verification = %s, email_user_post_approval = %s, email_admin_verifications = %s, email_admin_post_approval = %s, email_admin_user_approval = %s WHERE user_id = %s", secure($args['chat_sound']), secure($args['notifications_sound']), secure($args['email_post_likes']), secure($args['email_post_comments']), secure($args['email_post_shares']), secure($args['email_wall_posts']), secure($args['email_mentions']), secure($args['email_profile_visits']), secure($args['email_friend_requests']), secure($args['email_user_verification']), secure($args['email_user_post_approval']), secure($args['email_admin_verifications']), secure($args['email_admin_post_approval']), secure($args['email_admin_user_approval']), secure($this->_data['user_id'], 'int')));
        break;

      case 'notifications_sound':
        /* prepare */
        $args['notifications_sound'] = ($args['notifications_sound'] == 0) ? 0 : 1;
        /* update user */
        $db->query(sprintf("UPDATE users SET notifications_sound = %s WHERE user_id = %s", secure($args['notifications_sound']), secure($this->_data['user_id'], 'int')));
        break;

      case 'chat':
        /* prepare */
        $args['user_chat_enabled'] = ($args['user_chat_enabled'] == 0) ? 0 : 1;
        /* update user */
        $db->query(sprintf("UPDATE users SET user_chat_enabled = %s WHERE user_id = %s", secure($args['user_chat_enabled']), secure($this->_data['user_id'], 'int')));
        break;

      case 'membership':
        /* videos */
        $videos_query = "";
        if ($this->_data['allowed_videos_categories'] > 0) {
          $package_videos_categories = json_decode(html_entity_decode($args['package_videos_categories']), true);
          if (!$package_videos_categories || count($package_videos_categories) < $this->_data['allowed_videos_categories']) {
            throw new Exception(__("You must select at least") . " " . $this->_data['allowed_videos_categories'] . " " . __("videos categories"));
          }
          if (count($package_videos_categories) > $this->_data['allowed_videos_categories']) {
            throw new Exception(__("You can't select more than") . " " . $this->_data['allowed_videos_categories'] . " " . __("videos categories"));
          }
          $videos_query = "user_package_videos_categories = " . secure($args['package_videos_categories']);
        }
        /* blogs */
        $blogs_query = "";
        if ($this->_data['allowed_blogs_categories'] > 0) {
          $package_blogs_categories = json_decode(html_entity_decode($args['package_blogs_categories']), true);
          if (!$package_blogs_categories || count($package_blogs_categories) < $this->_data['allowed_blogs_categories']) {
            throw new Exception(__("You must select at least") . " " . $this->_data['allowed_blogs_categories'] . " " . __("blogs categories"));
          }
          if (count($package_blogs_categories) > $this->_data['allowed_blogs_categories']) {
            throw new Exception(__("You can't select more than") . " " . $this->_data['allowed_blogs_categories'] . " " . __("blogs categories"));
          }
          $blogs_query = ($videos_query) ? ", " : "";
          $blogs_query .= "user_package_blogs_categories = " . secure($args['package_blogs_categories']);
        }
        /* update user */
        $db->query(sprintf("UPDATE users SET $videos_query $blogs_query WHERE user_id = %s", secure($this->_data['user_id'], 'int')));
        break;

      case 'monetization':
        /* check monetization permission */
        if (!$this->_data['can_monetize_content']) {
          throw new Exception(__("The monetization system has been disabled by the admin"));
        }
        /* prepare */
        $args['user_monetization_enabled'] = (isset($args['user_monetization_enabled'])) ? '1' : '0';
        /* check if verification for monetization required */
        if ($args['user_monetization_enabled'] && $system['verification_for_monetization'] && !$this->_data['user_verified']) {
          throw new Exception(__("To enable this feature your account must be verified"));
        }
        /* update user */
        $db->query(sprintf("UPDATE users SET user_monetization_enabled = %s, user_monetization_chat_price = %s, user_monetization_call_price = %s WHERE user_id = %s", secure($args['user_monetization_enabled']), secure($args['user_monetization_chat_price'], 'float'), secure($args['user_monetization_call_price'], 'float'), secure($this->_data['user_id'], 'int')));
        /* update monetization plans */
        $this->update_monetization_plans();
        break;
    }
  }



  /* ------------------------------- */
  /* Verifications */
  /* ------------------------------- */

  /**
   * update_node_verification_status
   * 
   * @param int $node_id
   * @param string $node_type
   * @param string $action
   * @return void
   */
  public function update_node_verification_status($node_id, $node_type = 'user', $action = 'verify')
  {
    global $db;
    if (!in_array($node_type, ['user', 'page'])) {
      throw new Exception(__("Invalid node type"));
    }
    if (!in_array($action, ['verify', 'unverify'])) {
      throw new Exception(__("Invalid action"));
    }
    $status = ($action == 'verify') ? '1' : '0';
    if ($node_type == 'page') {
      /* verify page */
      $db->query(sprintf("UPDATE pages SET page_verified = %s WHERE page_id = %s", secure($status, 'int'), secure($node_id, 'int'))) or _error("SQL_ERROR_THROWEN");
    } else {
      /* verify user */
      $db->query(sprintf("UPDATE users SET user_verified = %s WHERE user_id = %s", secure($status, 'int'), secure($node_id, 'int'))) or _error("SQL_ERROR_THROWEN");
    }
    /* remove all verification requests */
    $db->query(sprintf("DELETE FROM verification_requests WHERE node_type = %s AND node_id = %s", secure($node_type), secure($node_id, 'int'))) or _error("SQL_ERROR_THROWEN");
  }


  /**
   * send_verification_request
   * 
   * @param int $node_id
   * @param string $node_type
   * @param array $inputs
   * @return void
   */
  public function send_verification_request($node_id, $node_type, $inputs)
  {
    global $system, $db, $date;
    /* check if node has any pending requests */
    $get_requests = $db->query(sprintf("SELECT COUNT(*) AS count FROM verification_requests WHERE node_id = %s AND node_type = %s AND `status` = '0'", secure($node_id, 'int'), secure($node_type))) or _error("SQL_ERROR_THROWEN");
    if ($get_requests->fetch_assoc()['count'] > 0) {
      throw new ValidationException(__("You have a pending verification request"));
    }
    /* check if the user is the page admin */
    if ($node_type == 'page' && !$this->check_page_adminship($this->_data['user_id'], $node_id)) {
      throw new ValidationException(__("You are not authorized to verify this page"));
    }
    /* valid inputs */
    if ($system['verification_docs_required']) {
      if (!isset($inputs['photo']) || is_empty($inputs['photo'])) {
        throw new ValidationException(($node_type == 'page') ? __("Please attach your company incorporation file") : __("Please attach your photo"));
      }
      if (!isset($inputs['passport']) || is_empty($inputs['passport'])) {
        throw new ValidationException(($node_type == 'page') ? __("Please attach your tax file") : __("Please attach your Passport or National ID"));
      }
    } else {
      $inputs['photo'] = '';
      $inputs['passport'] = '';
    }
    if (!isset($inputs['message']) || is_empty($inputs['message'])) {
      throw new ValidationException(($node_type == 'page') ?  __("Please share why your page should be verified") : __("Please share why your account should be verified"));
    }
    /* insert verification request */
    if ($node_type == 'user') {
      $db->query(sprintf("INSERT INTO verification_requests (node_id, node_type, photo, passport, message, time, status) VALUES (%s, 'user', %s, %s, %s, %s, '0')", secure($node_id, 'int'), secure($inputs['photo']), secure($inputs['passport']), secure($inputs['message']), secure($date)));
    } else {
      $db->query(sprintf("INSERT INTO verification_requests (node_id, node_type, photo, passport, business_website, business_address, message, time, status) VALUES (%s, 'page', %s, %s, %s, %s, %s, %s, '0')", secure($node_id, 'int'), secure($inputs['photo']), secure($inputs['passport']), secure($inputs['business_website']), secure($inputs['business_address']), secure($inputs['message']), secure($date)));
    }
    /* send notification to admins */
    $this->notify_system_admins("verification_request", true);
    /* remove pending uploads */
    remove_pending_uploads([$inputs['photo'], $inputs['passport']]);
  }


  /**
   * delete_all_verification_requests
   * 
   * @param int $node_id
   * @param string $node_type
   * @return void
   */
  public function delete_all_verification_requests($node_id, $node_type)
  {
    global $db;
    $db->query(sprintf("DELETE FROM verification_requests WHERE node_id = %s AND node_type = %s", secure($node_id, 'int'), secure($node_type))) or _error("SQL_ERROR_THROWEN");
  }



  /* ------------------------------- */
  /* Addresses */
  /* ------------------------------- */

  /**
   * get_addresses
   * 
   * @param array $args
   * @return array
   */
  public function get_addresses()
  {
    global $db;
    $addresses = [];
    $get_addresses = $db->query(sprintf("SELECT * FROM users_addresses WHERE user_id = %s", secure($this->_data['user_id'], 'int'))) or _error("SQL_ERROR_THROWEN");
    if ($get_addresses->num_rows > 0) {
      while ($address = $get_addresses->fetch_assoc()) {
        $addresses[] = $address;
      }
    }
    return $addresses;
  }


  /**
   * get_address
   * 
   * @param int $address_id
   * @return array
   */
  public function get_address($address_id)
  {
    global $db, $system;
    $get_address = $db->query(sprintf("SELECT * FROM users_addresses WHERE address_id = %s AND user_id = %s", secure($address_id, 'int'), secure($this->_data['user_id'], 'int'))) or _error("SQL_ERROR_THROWEN");
    if ($get_address->num_rows == 0) {
      throw new NoDataException(__("No data found"));
    }
    $address = $get_address->fetch_assoc();
    return $address;
  }


  /**
   * insert_address
   * 
   * @param string $title
   * @param string $country
   * @param string $city
   * @param string $zip_code
   * @param string $phone
   * @param string $address
   * @return void
   */
  public function insert_address($title, $country, $city, $zip_code, $phone, $address)
  {
    global $db, $system;
    /* validate title */
    if (is_empty($title)) {
      throw new ValidationException(__("You must enter the title"));
    }
    /* validate country */
    if (is_empty($country)) {
      throw new ValidationException(__("You must enter the country"));
    }
    /* validate city */
    if (is_empty($city)) {
      throw new ValidationException(__("You must enter the city"));
    }
    /* validate zip code */
    if (is_empty($zip_code)) {
      throw new ValidationException(__("You must enter the zip code"));
    }
    /* validate phone */
    if (is_empty($phone)) {
      throw new ValidationException(__("You must enter the phone"));
    }
    /* validate address */
    if (is_empty($address)) {
      throw new ValidationException(__("You must enter the address"));
    }
    /* insert */
    $db->query(sprintf("INSERT INTO users_addresses (user_id, address_title, address_country, address_city, address_zip_code, address_phone, address_details) VALUES (%s, %s, %s, %s, %s, %s, %s)", secure($this->_data['user_id'], 'int'), secure($title), secure($country), secure($city), secure($zip_code), secure($phone), secure($address))) or _error("SQL_ERROR_THROWEN");
  }


  /**
   * update_address
   * 
   * @param int $address_id
   * @param string $title
   * @param string $country
   * @param string $city
   * @param string $zip_code
   * @param string $phone
   * @param string $address
   * @return void
   */
  public function update_address($address_id, $title, $country, $city, $zip_code, $phone, $address)
  {
    global $db;
    /* check if this address belongs to the user */
    $check_address = $db->query(sprintf("SELECT COUNT(*) AS count FROM users_addresses WHERE address_id = %s AND user_id = %s", secure($address_id, 'int'), secure($this->_data['user_id'], 'int'))) or _error("SQL_ERROR_THROWEN");
    if ($check_address->fetch_assoc()['count'] == 0) {
      throw new AuthorizationException(__("You are not authorized to do this action"));
    }
    /* validate title */
    if (is_empty($title)) {
      throw new ValidationException(__("You must enter the title"));
    }
    /* validate country */
    if (is_empty($country)) {
      throw new ValidationException(__("You must enter the country"));
    }
    /* validate city */
    if (is_empty($city)) {
      throw new ValidationException(__("You must enter the city"));
    }
    /* validate zip code */
    if (is_empty($zip_code)) {
      throw new ValidationException(__("You must enter the zip code"));
    }
    /* validate phone */
    if (is_empty($phone)) {
      throw new ValidationException(__("You must enter the phone"));
    }
    /* validate address */
    if (is_empty($address)) {
      throw new ValidationException(__("You must enter the address"));
    }
    /* update */
    $db->query(sprintf("UPDATE users_addresses SET address_title = %s, address_country = %s, address_city = %s, address_zip_code = %s, address_phone = %s, address_details = %s WHERE address_id = %s AND user_id = %s", secure($title), secure($country), secure($city), secure($zip_code), secure($phone), secure($address), secure($address_id, 'int'), secure($this->_data['user_id'], 'int'))) or _error("SQL_ERROR_THROWEN");
  }


  /**
   * delete_address
   * 
   * @param int $address_id
   * @return void
   */
  public function delete_address($address_id)
  {
    global $db;
    $db->query(sprintf("DELETE FROM users_addresses WHERE address_id = %s AND user_id = %s", secure($address_id, 'int'), secure($this->_data['user_id'], 'int'))) or _error("SQL_ERROR_THROWEN");
  }



  /* ------------------------------- */
  /* Download User Information */
  /* ------------------------------- */

  /**
   * download_user_information
   * 
   * @return array
   */
  public function download_user_information()
  {
    global $db, $system, $smarty;
    $user_data = [];
    /* information */
    if ($_SESSION['download_information']) {
      $this->_data['user_gender'] = $this->get_gender($this->_data['user_gender']);
      $user_data['information'] = $this->_data;
      /* user sessions */
      $sessions = [];
      $get_sessions = $db->query(sprintf("SELECT * FROM users_sessions WHERE user_id = %s", secure($this->_data['user_id'], 'int')));
      if ($get_sessions->num_rows > 0) {
        while ($session = $get_sessions->fetch_assoc()) {
          $sessions[] = $session;
        }
      }
      $user_data['information']['sessions'] = $sessions;
    }
    /* friends */
    if ($_SESSION['download_friends']) {
      $user_data['friends'] = $this->get_friends($this->_data['user_id'], 0, true);
    }
    /* followings */
    if ($_SESSION['download_followings']) {
      $user_data['followings'] = $this->get_followings($this->_data['user_id'], 0, true);
    }
    /* followers */
    if ($_SESSION['download_followers']) {
      $user_data['followers'] = $this->get_followers($this->_data['user_id'], 0, true);
    }
    /* pages */
    if ($_SESSION['download_pages']) {
      $user_data['pages'] = $this->get_pages(['managed' => true, 'user_id' => $this->_data['user_id']]);
    }
    /* groups */
    if ($_SESSION['download_groups']) {
      $user_data['groups'] = $this->get_groups(['get_all' => true, 'user_id' => $this->_data['user_id']]);
    }
    /* events */
    if ($_SESSION['download_events']) {
      $user_data['events'] = $this->get_events(['get_all' => true, 'user_id' => $this->_data['user_id']]);
    }
    /* posts */
    if ($_SESSION['download_posts']) {
      $user_data['posts'] = $this->get_posts(['get_all' => true, 'get' => 'posts_profile', 'id' => $this->_data['user_id']]);
    }
    /* assign variables */
    $smarty->assign('user_data', $user_data);
    /* return */
    $html_file = $smarty->fetch("information.tpl");
    header('Content-disposition: attachment; filename=' . $this->_data['user_name'] . ".html");
    header('Content-type: text/html');
    print($html_file);
    exit;
  }



  /* ------------------------------- */
  /* User Sign (in|up|out) ✅ */
  /* ------------------------------- */

  /**
   * sign_up ✅
   * 
   * @param array $args
   * @param array $device_info
   * @return void
   */
  public function sign_up($args = [], $device_info = [])
  {
    global $db, $system, $date;
    /* check if registration is enabled */
    if (!$system['registration_enabled']) {
      throw new AuthorizationException(__("Registration is closed right now"));
    }
    /* prepare */
    $args['from_web'] = (isset($args['from_web'])) ? $args['from_web'] : true;
    /* check invitation code */
    if ($system['invitation_enabled']) {
      if (!$this->check_invitation_code($args['invitation_code'])) {
        throw new ValidationException(__("The invitation code is invalid or expired"));
      }
    }
    /* check IP */
    $this->_check_ip();
    /* validate */
    if ($system['show_usernames_enabled']) {
      $args['first_name'] = $args['username'];
      $args['last_name'] = $args['username'];
    } else {
      if (!valid_name($args['first_name'])) {
        throw new ValidationException(__("Your first name contains invalid characters"));
      }
      if (strlen($args['first_name']) < $system['name_min_length']) {
        throw new ValidationException(__("Your first name must be at least") . " " . $system['name_min_length'] . " " . __("characters long. Please try another"));
      }
      if (strlen($args['first_name']) > $system['name_max_length']) {
        throw new ValidationException(__("Your first name must be at most") . " " . $system['name_max_length'] . " " . __("characters long. Please try another"));
      }
      if (!valid_name($args['last_name'])) {
        throw new ValidationException(__("Your last name contains invalid characters"));
      }
      if (strlen($args['last_name']) < $system['name_min_length']) {
        throw new ValidationException(__("Your last name must be at least") . " " . $system['name_min_length'] . " " . __("characters long. Please try another"));
      }
      if (strlen($args['last_name']) > $system['name_max_length']) {
        throw new ValidationException(__("Your last name must be at most") . " " . $system['name_max_length'] . " " . __("characters long. Please try another"));
      }
    }
    if (!valid_username($args['username'])) {
      throw new ValidationException(__("Please enter a valid username (a-z0-9_.) with minimum 3 characters long"));
    }
    if ($this->reserved_username($args['username'])) {
      throw new ValidationException(__("You can't use") . " " . $args['username'] . " " . __("as username"));
    }
    if ($this->check_username($args['username'])) {
      throw new ValidationException(__("Sorry, it looks like") . " " . $args['username'] . " " . __("belongs to an existing account"));
    }
    if (!valid_email($args['email'])) {
      throw new ValidationException(__("Please enter a valid email address"));
    }
    if ($this->check_email($args['email'])) {
      throw new ValidationException(__("Sorry, it looks like") . " " . $args['email'] . " " . __("belongs to an existing account"));
    }
    if ($system['activation_enabled'] && $system['activation_type'] == "sms") {
      if (is_empty($args['phone'])) {
        throw new ValidationException(__("Please enter a valid phone number"));
      }
      if ($this->check_phone($args['phone'])) {
        throw new ValidationException(__("Sorry, it looks like") . " " . $args['phone'] . " " . __("belongs to an existing account"));
      }
    } else {
      $args['phone'] = 'null';
    }
    /* check password */
    $this->check_password($args['password']);
    /* check gender */
    $args['gender'] = ($system['genders_disabled']) ? 1 : $args['gender'];
    if (!$system['genders_disabled'] && !$this->check_gender($args['gender'])) {
      throw new ValidationException(__("Please select a valid gender"));
    }
    /* check age restriction */
    if ($system['age_restriction']) {
      if (!in_array($args['birth_month'], range(1, 12))) {
        throw new ValidationException(__("Please select a valid birth month (1-12)"));
      }
      if (!in_array($args['birth_day'], range(1, 31))) {
        throw new ValidationException(__("Please select a valid birth day (1-31)"));
      }
      if (!in_array($args['birth_year'], range(1905, 2017))) {
        throw new ValidationException(__("Please select a valid birth year (1905-2017)"));
      }
      if (date("Y") - $args['birth_year'] < $system['minimum_age']) {
        throw new ValidationException(__("Sorry, You must be") . " " . $system['minimum_age'] . " " . __("years old to register"));
      }
      $args['birth_date'] = $args['birth_year'] . '-' . $args['birth_month'] . '-' . $args['birth_day'];
    } else {
      $args['birth_date'] = 'null';
    }
    /* set custom fields */
    $custom_fields = $this->set_custom_fields($args);
    /* check reCAPTCHA */
    if ($system['reCAPTCHA_enabled'] && $args['from_web']) {
      $recaptcha = new \ReCaptcha\ReCaptcha($system['reCAPTCHA_secret_key'], new \ReCaptcha\RequestMethod\CurlPost());
      $resp = $recaptcha->verify($args['g-recaptcha-response'], get_user_ip());
      if (!$resp->isSuccess()) {
        throw new ValidationException(__("The security check is incorrect. Please try again"));
      }
    }
    /* check Turnstile */
    if ($system['turnstile_enabled'] && $args['from_web']) {
      if (!check_cf_turnstile($args['cf-turnstile-response'])) {
        throw new ValidationException(__("The security check is incorrect. Please try again"));
      }
    }
    /* set custom user group */
    if ($system['select_user_group_enabled']) {
      /* check if user selected a custom user group */
      if (!isset($args['custom_user_group']) || $args['custom_user_group'] == 'none') {
        throw new ValidationException(__("Please select a valid user group"));
      }
      $custom_user_group = ($args['custom_user_group'] != '0' && $this->check_user_group($args['custom_user_group'])) ? $args['custom_user_group'] : '0';
    } else {
      $custom_user_group = ($system['default_custom_user_group'] != '0' && $this->check_user_group($system['default_custom_user_group'])) ? $system['default_custom_user_group'] : '0';
    }
    /* check newsletter agreement */
    $newsletter_agree = (isset($args['newsletter_agree'])) ? '1' : '0';
    /* check privacy agreement */
    if (!isset($args['privacy_agree']) && $args['from_web']) {
      throw new ValidationException(__("You must read and agree to our terms and privacy policy"));
    }
    /* generate verification code */
    $email_verification_code = ($system['activation_enabled'] && $system['activation_type'] == "email") ? get_hash_key(6, true) : 'null';
    $phone_verification_code = ($system['activation_enabled'] && $system['activation_type'] == "sms") ? get_hash_key(6, true) : 'null';
    /* check user approved */
    $user_approved = ($system['users_approval_enabled']) ? '0' : '1';
    /* register user */
    $db->query(sprintf("INSERT INTO users (user_group_custom, user_name, user_email, user_phone, user_password, user_firstname, user_lastname, user_gender, user_birthdate, user_registered, user_email_verification_code, user_phone_verification_code, user_newsletter_enabled, user_approved) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)", secure($custom_user_group), secure($args['username']), secure($args['email']), secure($args['phone']), secure(_password_hash($args['password'])), secure(ucwords($args['first_name'])), secure(ucwords($args['last_name'])), secure($args['gender']), secure($args['birth_date']), secure($date), secure($email_verification_code), secure($phone_verification_code), secure($newsletter_agree), secure($user_approved)));
    /* get user_id */
    $user_id = $db->insert_id;
    /* set default privacy */
    $this->_set_default_privacy($user_id);
    /* insert custom fields values */
    if ($custom_fields) {
      foreach ($custom_fields as $field_id => $value) {
        $db->query(sprintf("INSERT INTO custom_fields_values (value, field_id, node_id, node_type) VALUES (%s, %s, %s, 'user')", secure($value), secure($field_id, 'int'), secure($user_id, 'int')));
      }
    }
    /* send activation */
    if ($system['activation_enabled']) {
      if ($system['activation_type'] == "email") {
        /* prepare activation email */
        $subject = __("Just one more step to get started on") . " " . html_entity_decode(__($system['system_title']), ENT_QUOTES);
        $to_name = ($system['show_usernames_enabled']) ? $args['username'] : $args['first_name'] . " " . $args['last_name'];
        $body = get_email_template("activation_email", $subject, ["name" => $to_name, "email_verification_code" => $email_verification_code]);
        /* send email */
        if (!_email($args['email'], $subject, $body['html'], $body['plain'])) {
          throw new Exception(__("Activation email could not be sent") . ", " . __("But you can login now"));
        }
      } else {
        /* prepare activation SMS */
        $message  = __($system['system_title']) . " " . __("Activation Code") . ": " . $phone_verification_code;
        /* send SMS */
        if (!sms_send($args['phone'], $message)) {
          throw new Exception(__("Activation SMS could not be sent") . ", " . __("But you can login now"));
        }
      }
    } else {
      /* affiliates system (as activation disabled) */
      $this->process_affiliates("registration", $user_id);
    }
    /* update invitation code */
    if ($system['invitation_enabled']) {
      $this->update_invitation_code($args['invitation_code'], $user_id);
    }
    /* auto connect */
    $this->auto_friend($user_id);
    $this->auto_follow($user_id);
    $this->auto_like($user_id);
    $this->auto_join($user_id);
    /* user approval system */
    if ($system['users_approval_enabled']) {
      /* send notification to admins */
      $this->notify_system_admins("pending_user", true, $user_id);
    }
    /* set authentication */
    if ($args['from_web']) {
      $this->_set_authentication_cookies($user_id);
    } else {
      /* create JWT */
      $jwt = $this->_set_authentication_JWT($user_id, $device_info);
      /* create new user object */
      $user = new User($jwt);
      return ['token' => $jwt, 'user' => secure_user_values($user)];
    }
  }


  /**
   * sign_in ✅
   * 
   * @param string $username_email
   * @param string $password
   * @param boolean $remember
   * @param boolean $from_web
   * @param array $device_info
   * @param boolean $connecting_account
   * 
   * @return void
   */
  public function sign_in($username_email, $password, $remember = false, $from_web = false, $device_info = [], $connecting_account = false)
  {
    global $db, $system, $date;
    /* valid inputs */
    $username_email = trim($username_email);
    if (is_empty($username_email) || is_empty($password)) {
      throw new ValidationException(__("You must fill in all of the fields"));
    }
    /* check if username or email */
    if (valid_email($username_email)) {
      $user = $this->check_email($username_email, true);
      if ($user === false) {
        throw new ValidationException(__("The email you entered does not belong to any account"));
      }
      $field = "user_email";
    } else {
      if (!valid_username($username_email)) {
        throw new ValidationException(__("Please enter a valid email address or username"));
      }
      $user = $this->check_username($username_email, 'user', true);
      if ($user === false) {
        throw new ValidationException(__("The username you entered does not belong to any account"));
      }
      $field = "user_name";
    }
    /* check brute-force attack detection */
    if ($system['brute_force_detection_enabled']) {
      $lockout_time = (int) $system['brute_force_lockout_time'] * 60; /* convert to seconds */
      if (($user['user_failed_login_ip'] == get_user_ip()) && ($user['user_failed_login_count'] >= $system['brute_force_bad_login_limit']) && (time() - strtotime($user['user_first_failed_login']) <  $lockout_time)) {
        throw new ValidationException(__("Your account is currently locked out. Please try again later!"));
      }
    }
    /* check password */
    if (!password_verify($password, $user['user_password'])) {
      /* check brute-force attack detection */
      if ($system['brute_force_detection_enabled']) {
        if ($user['user_first_failed_login'] && (time() - strtotime($user['user_first_failed_login']) > $lockout_time)) {
          /* reset the failed login count if the lockout time has passed */
          $db->query(sprintf("UPDATE users SET user_first_failed_login = %s, user_failed_login_ip = %s, user_failed_login_count = 1 WHERE user_id = %s", secure($date), secure(get_user_ip()), secure($user['user_id'], 'int')));
        } else {
          /* increment failed login count and update first failed login time & ip if necessary */
          $db->query(sprintf("UPDATE users SET user_failed_login_count =  user_failed_login_count + 1 WHERE user_id = %s", secure($user['user_id'], 'int')));
          if (!$user['user_first_failed_login']) {
            $db->query(sprintf("UPDATE users SET user_first_failed_login = %s, user_failed_login_ip = %s WHERE user_id = %s", secure($date), secure(get_user_ip()), secure($user['user_id'], 'int')));
          }
        }
      }
      throw new ValidationException(__("Please re-enter your password") . ", " . __("The password you entered is incorrect"));
    }
    /* two-factor authentication */
    if ($user['user_two_factor_enabled']) {
      /* system two-factor disabled */
      if (!$system['two_factor_enabled']) {
        $this->disable_two_factor_authentication($user['user_id']);
        goto set_authentication;
      }
      /* system two-factor method != user two-factor method */
      if ($system['two_factor_type'] != $user['user_two_factor_type']) {
        $this->disable_two_factor_authentication($user['user_id']);
        goto set_authentication;
      }
      switch ($system['two_factor_type']) {
        case 'email':
          /* system two-factor method = email but user email not verified */
          if (!$user['user_email_verified']) {
            $this->disable_two_factor_authentication($user['user_id']);
            goto set_authentication;
          }
          /* generate two-factor key */
          $two_factor_key = get_hash_key(6, true);
          /* update user two factor key */
          $db->query(sprintf("UPDATE users SET user_two_factor_key = %s WHERE user_id = %s", secure($two_factor_key), secure($user['user_id'], 'int')));
          /* prepare method name */
          $method = __("Email");
          /* prepare activation email */
          $subject = html_entity_decode(__($system['system_title']), ENT_QUOTES) . " " . __("Two-Factor Authentication Token");
          $body = get_email_template("two_factor_email", $subject, ["user" => $user, "two_factor_key" => $two_factor_key]);
          /* send email */
          if (!_email($user['user_email'], $subject, $body['html'], $body['plain'])) {
            throw new Exception(__("Two-factor authentication email could not be sent"));
          }
          break;

        case 'sms':
          /* system two-factor method = sms but not user phone not verified */
          if (!$user['user_phone_verified']) {
            $this->disable_two_factor_authentication($user['user_id']);
            goto set_authentication;
          }
          /* generate two-factor key */
          $two_factor_key = get_hash_key(6, true);
          /* update user two factor key */
          $db->query(sprintf("UPDATE users SET user_two_factor_key = %s WHERE user_id = %s", secure($two_factor_key), secure($user['user_id'], 'int')));
          /* prepare method name */
          $method = __("Phone");
          /* prepare activation SMS */
          $message  = __($system['system_title']) . " " . __("Two-factor authentication key") . ": " . $two_factor_key;
          /* send SMS */
          if (!sms_send($user['user_phone'], $message)) {
            throw new Exception(__("Two-factor authentication SMS could not be sent"));
          }
          break;

        case 'google':
          /* prepare method name */
          $method = __("Google Authenticator app");
          break;
      }
      if ($from_web) {
        modal("#two-factor-authentication", "{user_id: '" . $user['user_id'] . "', remember: '" . $remember . "', method: '" . $method . "', connecting_account: '" . $connecting_account . "'}");
      } else {
        return ['2FA' => true, 'user_id' => $user['user_id'], 'method' => $method, 'connecting_account' => $connecting_account];
      }
    }
    /* set authentication */
    set_authentication:
    if ($connecting_account) {
      return $user;
    }
    if ($from_web) {
      $this->_set_authentication_cookies($user['user_id'], $remember);
    } else {
      /* create JWT */
      $jwt = $this->_set_authentication_JWT($user['user_id'], $device_info);
      /* create new user object */
      $user = new User($jwt);
      return ['token' => $jwt, 'user' => secure_user_values($user)];
    }
  }


  /**
   * sign_out ✅
   * 
   * @param boolean $from_web
   * @return void
   */
  public function sign_out($from_web = false)
  {
    global $db, $date;
    /* delete the session */
    $db->query(sprintf("DELETE FROM users_sessions WHERE session_token = %s AND user_id = %s", secure($this->_data['session_token']), secure($this->_data['user_id'], 'int')));
    /* destroy the session */
    session_destroy();
    if ($from_web) {
      /* unset the cookies */
      unset($_COOKIE[$this->_cookie_user_id]);
      unset($_COOKIE[$this->_cookie_user_token]);
      unset($_COOKIE[$this->_cookie_user_jwt]);
      unset_cookie($this->_cookie_user_id);
      unset_cookie($this->_cookie_user_token);
      unset_cookie($this->_cookie_user_jwt);
    }
  }


  /**
   * _set_authentication_cookies
   * 
   * @param integer $user_id
   * @param boolean $remember
   * @return void
   */
  private function _set_authentication_cookies($user_id, $remember = false)
  {
    global $db, $system, $date;
    /* generate new token */
    $session_token = get_hash_token();
    /* generate new JWT */
    $payload = [
      'uid' => $user_id,
      'token' => $session_token
    ];
    $jwt = Firebase\JWT\JWT::encode($payload, $system['system_jwt_key'], 'HS256');
    /* check brute-force attack detection */
    if ($system['brute_force_detection_enabled']) {
      $db->query(sprintf("UPDATE users SET user_failed_login_count = 0 WHERE user_id = %s", secure($user_id, 'int')));
    }
    /* insert user session */
    $db->query(sprintf("INSERT INTO users_sessions (session_token, session_date, user_id, user_ip, user_browser, user_os) VALUES (%s, %s, %s, %s, %s, %s)", secure($session_token), secure($date), secure($user_id, 'int'), secure(get_user_ip()), secure(get_user_browser()), secure(get_user_os())));
    /* secured cookies */
    $secured = (get_system_protocol() == "https") ? true : false;
    /* set authentication cookies */
    $is_expired = ($remember) ? false : true;
    set_cookie($this->_cookie_user_id, $user_id, $is_expired);
    set_cookie($this->_cookie_user_token, $session_token, $is_expired);
    set_cookie($this->_cookie_user_jwt, $jwt, $is_expired, false);
  }


  /**
   * _set_authentication_JWT ✅
   * 
   * @param integer $user_id
   * @param array $device_info
   * @return string
   */
  private function _set_authentication_JWT($user_id, $device_info)
  {
    global $db, $system, $date;
    /* generate new token */
    $session_token = get_hash_token();
    /* generate new JWT */
    $payload = [
      'uid' => $user_id,
      'token' => $session_token
    ];
    $jwt = Firebase\JWT\JWT::encode($payload, $system['system_jwt_key'], 'HS256');
    /* check brute-force attack detection */
    if ($system['brute_force_detection_enabled']) {
      $db->query(sprintf("UPDATE users SET user_failed_login_count = 0 WHERE user_id = %s", secure($user_id, 'int')));
    }
    /* insert user session */
    $db->query(sprintf("INSERT INTO users_sessions (session_token, session_date, session_type, user_id, user_ip, user_os, user_os_version, user_device_name) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)", secure($session_token), secure($date), secure($device_info['device_type']), secure($user_id, 'int'), secure(get_user_ip()), secure($device_info['device_os']), secure($device_info['device_os_version']), secure($device_info['device_name'])));
    return $jwt;
  }


  /**
   * _check_ip ✅
   * 
   * @return void
   */
  private function _check_ip()
  {
    global $db, $system;
    if ($system['max_accounts'] > 0) {
      $check = $db->query(sprintf("SELECT user_ip, COUNT(*) FROM users_sessions WHERE user_ip = %s GROUP BY user_id", secure(get_user_ip())));
      if ($check->num_rows >= $system['max_accounts']) {
        throw new ValidationException(__("You have reached the maximum number of account for your IP"));
      }
    }
  }


  /**
   * _set_default_privacy ✅
   * 
   * @return void
   */
  private function _set_default_privacy($user_id)
  {
    global $system, $db;
    /* update user */
    $db->query(sprintf(
      "UPDATE users SET 
        user_privacy_chat = %s,
        user_privacy_poke = %s,
        user_privacy_gifts = %s,
        user_privacy_wall = %s,
        user_privacy_gender = %s, 
        user_privacy_relationship = %s,
        user_privacy_birthdate = %s, 
        user_privacy_basic = %s, 
        user_privacy_work = %s, 
        user_privacy_location = %s, 
        user_privacy_education = %s, 
        user_privacy_other = %s, 
        user_privacy_friends = %s, 
        user_privacy_followers = %s, 
        user_privacy_subscriptions = %s, 
        user_privacy_photos = %s, 
        user_privacy_pages = %s, 
        user_privacy_groups = %s, 
        user_privacy_events = %s 
        WHERE user_id = %s",
      secure($system['user_privacy_chat']),
      secure($system['user_privacy_poke']),
      secure($system['user_privacy_gifts']),
      secure($system['user_privacy_wall']),
      secure($system['user_privacy_gender']),
      secure($system['user_privacy_relationship']),
      secure($system['user_privacy_birthdate']),
      secure($system['user_privacy_basic']),
      secure($system['user_privacy_work']),
      secure($system['user_privacy_location']),
      secure($system['user_privacy_education']),
      secure($system['user_privacy_other']),
      secure($system['user_privacy_friends']),
      secure($system['user_privacy_followers']),
      secure($system['user_privacy_subscriptions']),
      secure($system['user_privacy_photos']),
      secure($system['user_privacy_pages']),
      secure($system['user_privacy_groups']),
      secure($system['user_privacy_events']),
      secure($user_id, 'int')
    ));
  }



  /* ------------------------------- */
  /* Login As */
  /* ------------------------------- */

  /**
   * login_as ✅
   * 
   * @param integer $user_id
   * @return void
   */
  public function login_as($user_id)
  {
    global $db, $system;
    /* check if the viewer is admin */
    if (!$this->_is_admin) {
      throw new AuthorizationException(__("You are not authorized to do this action"));
    }
    /* check if the viewer is not the target user */
    if ($user_id == $this->_data['user_id']) {
      throw new Exception(__("Sorry, it looks like this account belongs to you"));
    }
    /* check if the target user exists */
    $user = $this->get_user($user_id);
    if (!$user) {
      throw new NoDataException(__("No data found"));
    }
    /* check if the target user is not the super admin */
    if ($user['user_id'] == 1) {
      throw new AuthorizationException(__("You are not authorized to do this action"));
    }
    /* set login as cookie */
    set_cookie($this->_cookie_user_login_as, $user['user_id']);
  }


  /**
   * revoke_login_as
   * 
   * @return void
   */
  public function revoke_login_as()
  {
    unset_cookie($this->_cookie_user_login_as);
  }



  /* ------------------------------- */
  /* Connected Accounts */
  /* ------------------------------- */

  /**
   * get_connected_accounts
   * 
   * @param integer $user_id
   * @return array
   */
  public function get_connected_accounts($user_id = null)
  {
    global $db;
    $user_id = (isset($user_id)) ? $user_id : $this->_data['user_id'];
    $accounts = [];
    $get_accounts = $db->query(sprintf('
    SELECT users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, users.user_subscribed, users.user_verified FROM users WHERE user_id = %1$s 
    UNION
    SELECT users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, users.user_subscribed, users.user_verified FROM users INNER JOIN users_accounts ON users.user_id = users_accounts.account_id WHERE users_accounts.user_id = %1$s', secure($user_id, 'int')));
    if ($get_accounts->num_rows > 0) {
      while ($account = $get_accounts->fetch_assoc()) {
        $account['user_picture'] = get_picture($account['user_picture'], $account['user_gender']);
        $accounts[] = $account;
      }
    }
    return $accounts;
  }


  /**
   * connected_account_signin
   * 
   * @param string $username_email
   * @param string $password
   * @return void
   */
  public function connected_account_signin($username_email, $password)
  {
    global $db;
    $user = $this->sign_in($username_email, $password, false, true, [], true);
    $this->connected_account_connect($user);
  }


  /**
   * connected_account_connect
   * 
   * @param array $user
   * @return void
   */
  public function connected_account_connect($user)
  {
    global $db;
    /* check if this user is the current user */
    if ($user['user_id'] == $this->_data['user_id']) {
      throw new Exception(__("Sorry, it looks like this account belongs to you"));
    }
    /* check if this user is already connected to other master */
    if ($user['user_master_account'] != $user['user_id']) {
      throw new Exception(__("Sorry, it looks like this account is already connected to another account"));
    }
    /* check if this user is a master account for other accounts */
    $master_check = $db->query(sprintf("SELECT COUNT(*) AS count FROM users WHERE user_master_account = %s", secure($user['user_id'], 'int')));
    if ($master_check->fetch_assoc()['count'] > 1) {
      throw new Exception(__("Sorry, it looks like this account is a master account for other accounts"));
    }
    /* insert new account as connected accounts */
    $db->query(sprintf("INSERT INTO users_accounts (user_id, account_id) VALUES (%s, %s)", secure($this->_data['user_id'], 'int'), secure($user['user_id'], 'int')));
    /* update new account master */
    $db->query(sprintf("UPDATE users SET user_master_account = %s WHERE user_id = %s", secure($this->_data['user_id'], 'int'), secure($user['user_id'], 'int')));
  }


  /**
   * connected_account_switch
   * 
   * @param integer $account_id
   * @return void
   */
  public function connected_account_switch($account_id)
  {
    global $db;
    /* search connected account if this account belongs to current user */
    if (array_search($account_id, array_column($this->_data['connected_accounts'], 'user_id')) === false) {
      throw new Exception(__("Sorry, it looks like this account doesn't belong to you"));
    }
    $this->_set_authentication_cookies($account_id, true);
  }


  /**
   * connected_account_remove
   * 
   * @param integer $account_id
   * @return void
   */
  public function connected_account_remove($account_id)
  {
    global $db;
    /* search connected account if this account belongs to current user */
    if (array_search($account_id, array_column($this->_data['connected_accounts'], 'user_id')) === false) {
      throw new Exception(__("Sorry, it looks like this account doesn't belong to you"));
    }
    /* remove from connected accounts */
    $db->query(sprintf("DELETE FROM users_accounts WHERE user_id = %s AND account_id = %s", secure($this->_data['user_id'], 'int'), secure($account_id, 'int')));
    /* update target user master */
    $db->query(sprintf("UPDATE users SET user_master_account = user_id WHERE user_id = %s", secure($account_id, 'int')));
  }


  /**
   * connected_account_revoke
   * 
   * @return void
   */
  public function connected_account_revoke()
  {
    global $db;
    /* remove from connected accounts */
    $db->query(sprintf("DELETE FROM users_accounts WHERE user_id = %s AND account_id = %s", secure($this->_data['user_master_account'], 'int'), secure($this->_data['user_id'], 'int')));
    /* update current user master */
    $db->query(sprintf("UPDATE users SET user_master_account = user_id WHERE user_id = %s", secure($this->_data['user_id'], 'int')));
  }



  /* ------------------------------- */
  /* Getting Started */
  /* ------------------------------- */

  /**
   * getting_satrted_update
   * 
   * @param array $args
   * @return void
   */
  public function getting_satrted_update($args)
  {
    global $db;
    /* validate country */
    if ($args['country'] == "none") {
      throw new ValidationException(__("You must select valid country"));
    } else {
      if (!$this->check_country($args['country'])) {
        throw new ValidationException(__("You must select valid country"));
      }
    }
    /* validate work website */
    if (!is_empty($args['work_url'])) {
      /* check if contains https:// or http:// if not add it */
      if (!preg_match("~^(?:f|ht)tps?://~i", $args['work_url'])) {
        $args['work_url'] = "https://" . $args['work_url'];
      }
      if (!valid_url($args['work_url'])) {
        throw new ValidationException(__("Please enter a valid work website"));
      }
    } else {
      $args['work_url'] = 'null';
    }
    /* update user */
    $db->query(sprintf("UPDATE users SET user_country = %s, user_work_title = %s, user_work_place = %s, user_work_url = %s, user_current_city = %s, user_hometown = %s, user_edu_major = %s, user_edu_school = %s, user_edu_class = %s WHERE user_id = %s", secure($args['country'], 'int'), secure($args['work_title']), secure($args['work_place']), secure($args['work_url']), secure($args['city']), secure($args['hometown']), secure($args['edu_major']), secure($args['edu_school']), secure($args['edu_class']), secure($this->_data['user_id'], 'int')));
  }


  /**
   * getting_satrted_finish
   * 
   * @return void
   */
  public function getting_satrted_finish()
  {
    global $db, $system;
    // check if there is any required data
    if ($system['getting_started_profile_image_required'] || $system['getting_started_location_required'] || $system['getting_started_education_required'] || $system['getting_started_work_required']) {
      $user_info = $this->get_user($this->_data['user_id']);
      /* check if profile image required */
      if ($system['getting_started_profile_image_required'] && $user_info['user_picture_default']) {
        throw new Exception(__("You must upload your profile image"));
      }
      /* check if location data required */
      if ($system['getting_started_location_required'] && is_empty($user_info['user_country'])) {
        throw new Exception(__("You must enter your location info"));
      }
      if ($system['getting_started_location_required'] && $system['location_info_enabled'] && (is_empty($user_info['user_current_city']) || is_empty($user_info['user_hometown']))) {
        throw new Exception(__("You must enter your location info"));
      }
      /* check if work data required */
      if ($system['getting_started_work_required'] && (is_empty($user_info['user_work_title']) || is_empty($user_info['user_work_place']))) {
        throw new Exception(__("You must enter your work info"));
      }
      /* check if education data required */
      if ($system['getting_started_education_required'] && (is_empty($user_info['user_edu_major']) || is_empty($user_info['user_edu_school']) || is_empty($user_info['user_edu_class']))) {
        throw new Exception(__("You must enter your education info"));
      }
    }
    // update user info
    $db->query(sprintf("UPDATE users SET user_started = '1' WHERE user_id = %s", secure($this->_data['user_id'], 'int')));
    // auto connect (custom country)
    $this->auto_friend($this->_data['user_id'], $this->_data['user_country']);
    $this->auto_follow($this->_data['user_id'], $this->_data['user_country']);
    $this->auto_like($this->_data['user_id'], $this->_data['user_country']);
    $this->auto_join($this->_data['user_id'], $this->_data['user_country']);
  }



  /* ------------------------------- */
  /* Social Login */
  /* ------------------------------- */

  /**
   * social_login
   * 
   * @param string $provider
   * @param object $user_profile
   * 
   * @return void
   */
  public function social_signin($provider, $user_profile)
  {
    global $db, $system, $smarty;
    switch ($provider) {
      case 'facebook':
        $social_id = "facebook_id";
        $social_connected = "facebook_connected";
        break;

      case 'google':
        $social_id = "google_id";
        $social_connected = "google_connected";
        break;

      case 'twitter':
        $social_id = "twitter_id";
        $social_connected = "twitter_connected";
        break;

      case 'instagram':
        $social_id = "instagram_id";
        $social_connected = "instagram_connected";
        break;

      case 'linkedin':
      case 'LinkedInOpenID':
        $social_id = "linkedin_id";
        $social_connected = "linkedin_connected";
        break;

      case 'vkontakte':
        $social_id = "vkontakte_id";
        $social_connected = "vkontakte_connected";
        break;

      case 'wordpress':
        $social_id = "wordpress_id";
        $social_connected = "wordpress_connected";
        break;

      case 'Delus':
        $social_id = "Delus_id";
        $social_connected = "Delus_connected";
        break;
    }
    /* check if user connected or not */
    $check_user = $db->query(sprintf("SELECT user_id FROM users WHERE $social_id = %s", secure($user_profile->identifier)));
    if ($check_user->num_rows > 0) {
      /* social account connected and just signing-in */
      $user = $check_user->fetch_assoc();
      /* signout if user logged-in */
      if ($this->_logged_in) {
        $this->sign_out(true);
      }
      /* set authentication cookies */
      $this->_set_authentication_cookies($user['user_id'], true);
      redirect();
    } else {
      /* user cloud be connecting his social account or signing-up */
      if ($this->_logged_in) {
        /* [1] connecting social account */
        $db->query(sprintf("UPDATE users SET $social_connected = '1', $social_id = %s WHERE user_id = %s", secure($user_profile->identifier), secure($this->_data['user_id'], 'int')));
        redirect('/settings/linked');
      } else {
        /* [2] signup with social account */
        $_SESSION['social_id'] = $user_profile->identifier;
        page_header(__($system['system_title']) . " &rsaquo; " . __("Sign Up"));
        $smarty->assign('provider', $provider);
        $smarty->assign('user_profile', $user_profile);
        if (!$system['genders_disabled']) {
          $smarty->assign('genders', $this->get_genders());
        }
        $smarty->assign('custom_fields', $this->get_custom_fields());
        if ($system['select_user_group_enabled']) {
          $smarty->assign('user_groups', $this->get_users_groups());
        }
        $smarty->display("signup_social.tpl");
      }
    }
  }


  /**
   * social_signup
   * 
   * @param array $args
   * @return void
   */
  public function social_signup($args = [])
  {
    global $db, $system, $date;
    /* check provider */
    switch ($args['provider']) {
      case 'facebook':
        $social_id = "facebook_id";
        $social_connected = "facebook_connected";
        break;

      case 'google':
        $social_id = "google_id";
        $social_connected = "google_connected";
        break;

      case 'twitter':
        $social_id = "twitter_id";
        $social_connected = "twitter_connected";
        break;

      case 'instagram':
        $social_id = "instagram_id";
        $social_connected = "instagram_connected";
        break;

      case 'linkedin':
      case 'LinkedInOpenID':
        $social_id = "linkedin_id";
        $social_connected = "linkedin_connected";
        break;

      case 'vkontakte':
        $social_id = "vkontakte_id";
        $social_connected = "vkontakte_connected";
        break;

      case 'wordpress':
        $social_id = "wordpress_id";
        $social_connected = "wordpress_connected";
        break;

      case 'Delus':
        $social_id = "Delus_id";
        $social_connected = "Delus_connected";
        break;

      default:
        throw new BadRequestException(__("Invalid provider"));
    }
    /* check if registration is enabled */
    if (!$system['registration_enabled']) {
      throw new AuthorizationException(__("Registration is closed right now"));
    }
    /* prepare */
    $args['from_web'] = (isset($args['from_web'])) ? $args['from_web'] : true;
    /* check invitation code */
    if ($system['invitation_enabled']) {
      if (!$this->check_invitation_code($args['invitation_code'])) {
        throw new ValidationException(__("The invitation code is invalid or expired"));
      }
    }
    /* check IP */
    $this->_check_ip();
    /* validate */
    if ($system['show_usernames_enabled']) {
      $args['first_name'] = $args['username'];
      $args['last_name'] = $args['username'];
    } else {
      if (!valid_name($args['first_name'])) {
        throw new ValidationException(__("Your first name contains invalid characters"));
      }
      if (strlen($args['first_name']) < $system['name_min_length']) {
        throw new ValidationException(__("Your first name must be at least") . " " . $system['name_min_length'] . " " . __("characters long. Please try another"));
      }
      if (strlen($args['first_name']) > $system['name_max_length']) {
        throw new ValidationException(__("Your first name must be at most") . " " . $system['name_max_length'] . " " . __("characters long. Please try another"));
      }
      if (!valid_name($args['last_name'])) {
        throw new ValidationException(__("Your last name contains invalid characters"));
      }
      if (strlen($args['last_name']) < $system['name_min_length']) {
        throw new ValidationException(__("Your last name must be at least") . " " . $system['name_min_length'] . " " . __("characters long. Please try another"));
      }
      if (strlen($args['last_name']) > $system['name_max_length']) {
        throw new ValidationException(__("Your last name must be at most") . " " . $system['name_max_length'] . " " . __("characters long. Please try another"));
      }
    }
    if (!valid_username($args['username'])) {
      throw new Exception(__("Please enter a valid username (a-z0-9_.) with minimum 3 characters long"));
    }
    if ($this->reserved_username($args['username'])) {
      throw new Exception(__("You can't use") . " " . $args['username'] . " " . __("as username"));
    }
    if ($this->check_username($args['username'])) {
      throw new Exception(__("Sorry, it looks like") . " " . $args['username'] . " " . __("belongs to an existing account"));
    }
    if (!valid_email($args['email'])) {
      throw new Exception(__("Please enter a valid email address"));
    }
    if ($this->check_email($args['email'])) {
      throw new Exception(__("Sorry, it looks like") . " " . $email . " " . __("belongs to an existing account"));
    }
    if ($system['activation_enabled'] && $system['activation_type'] == "sms") {
      if (is_empty($args['phone'])) {
        throw new ValidationException(__("Please enter a valid phone number"));
      }
      if ($this->check_phone($args['phone'])) {
        throw new ValidationException(__("Sorry, it looks like") . " " . $args['phone'] . " " . __("belongs to an existing account"));
      }
    } else {
      $args['phone'] = 'null';
    }
    /* check password */
    $this->check_password($args['password']);
    /* check gender */
    $args['gender'] = ($system['genders_disabled']) ? 1 : $args['gender'];
    if (!$system['genders_disabled'] && !$this->check_gender($args['gender'])) {
      throw new ValidationException(__("Please select a valid gender"));
    }
    /* check age restriction */
    if ($system['age_restriction']) {
      if (!in_array($args['birth_month'], range(1, 12))) {
        throw new ValidationException(__("Please select a valid birth month (1-12)"));
      }
      if (!in_array($args['birth_day'], range(1, 31))) {
        throw new ValidationException(__("Please select a valid birth day (1-31)"));
      }
      if (!in_array($args['birth_year'], range(1905, 2017))) {
        throw new ValidationException(__("Please select a valid birth year (1905-2017)"));
      }
      if (date("Y") - $args['birth_year'] < $system['minimum_age']) {
        throw new ValidationException(__("Sorry, You must be") . " " . $system['minimum_age'] . " " . __("years old to register"));
      }
      $args['birth_date'] = $args['birth_year'] . '-' . $args['birth_month'] . '-' . $args['birth_day'];
    } else {
      $args['birth_date'] = 'null';
    }
    /* set custom fields */
    $custom_fields = $this->set_custom_fields($args);
    /* set custom user group */
    if ($system['select_user_group_enabled']) {
      /* check if user selected a custom user group */
      if (!isset($args['custom_user_group']) || $args['custom_user_group'] == 'none') {
        throw new ValidationException(__("Please select a valid user group"));
      }
      $custom_user_group = ($args['custom_user_group'] != '0' && $this->check_user_group($args['custom_user_group'])) ? $args['custom_user_group'] : '0';
    } else {
      $custom_user_group = ($system['default_custom_user_group'] != '0' && $this->check_user_group($system['default_custom_user_group'])) ? $system['default_custom_user_group'] : '0';
    }
    /* check newsletter agreement */
    $newsletter_agree = (isset($args['newsletter_agree'])) ? '1' : '0';
    /* check privacy agreement */
    if (!isset($args['privacy_agree']) && $args['from_web']) {
      throw new ValidationException(__("You must read and agree to our terms and privacy policy"));
    }
    /* generate verification code */
    $email_verification_code = ($system['activation_enabled'] && $system['activation_type'] == "email") ? get_hash_key(6, true) : 'null';
    $phone_verification_code = ($system['activation_enabled'] && $system['activation_type'] == "sms") ? get_hash_key(6, true) : 'null';
    /* check user approved */
    $user_approved = ($system['users_approval_enabled']) ? '0' : '1';
    /* save avatar */
    $avatar_name = save_picture_from_url($args['avatar']);
    /* register user */
    $db->query(sprintf("INSERT INTO users (user_group_custom, user_name, user_email, user_phone, user_password, user_firstname, user_lastname, user_gender, user_birthdate, user_registered, user_email_verification_code, user_phone_verification_code, user_newsletter_enabled, user_approved, user_picture, $social_id, $social_connected) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, '1')", secure($custom_user_group), secure($args['username']), secure($args['email']), secure($args['phone']), secure(_password_hash($args['password'])), secure(ucwords($args['first_name'])), secure(ucwords($args['last_name'])), secure($args['gender']), secure($args['birth_date']), secure($date), secure($email_verification_code), secure($phone_verification_code), secure($newsletter_agree), secure($user_approved), secure($avatar_name), secure($_SESSION['social_id'])));
    /* get user_id */
    $user_id = $db->insert_id;
    /* set default privacy */
    $this->_set_default_privacy($user_id);
    /* insert custom fields values */
    if ($custom_fields) {
      foreach ($custom_fields as $field_id => $value) {
        $db->query(sprintf("INSERT INTO custom_fields_values (value, field_id, node_id, node_type) VALUES (%s, %s, %s, 'user')", secure($value), secure($field_id, 'int'), secure($user_id, 'int')));
      }
    }
    /* send activation */
    if ($system['activation_enabled']) {
      if ($system['activation_type'] == "email") {
        /* prepare activation email */
        $subject = __("Just one more step to get started on") . " " . html_entity_decode(__($system['system_title']), ENT_QUOTES);
        $to_name = ($system['show_usernames_enabled']) ? $args['username'] : $args['first_name'] . " " . $args['last_name'];
        $body = get_email_template("activation_email", $subject, ["name" => $to_name, "email_verification_code" => $email_verification_code]);
        /* send email */
        if (!_email($args['email'], $subject, $body['html'], $body['plain'])) {
          throw new Exception(__("Activation email could not be sent") . ", " . __("But you can login now"));
        }
      } else {
        /* prepare activation SMS */
        $message  = __($system['system_title']) . " " . __("Activation Code") . ": " . $phone_verification_code;
        /* send SMS */
        if (!sms_send($args['phone'], $message)) {
          throw new Exception(__("Activation SMS could not be sent") . ", " . __("But you can login now"));
        }
      }
    } else {
      /* affiliates system (as activation disabled) */
      $this->process_affiliates("registration", $user_id);
    }
    /* update invitation code */
    if ($system['invitation_enabled']) {
      $this->update_invitation_code($args['invitation_code'], $user_id);
    }
    /* auto connect */
    $this->auto_friend($user_id);
    $this->auto_follow($user_id);
    $this->auto_like($user_id);
    $this->auto_join($user_id);
    /* user approval system */
    if ($system['users_approval_enabled']) {
      /* send notification to admins */
      $this->notify_system_admins("pending_user", true, $user_id);
    }
    /* set authentication */
    if ($args['from_web']) {
      $this->_set_authentication_cookies($user_id);
    } else {
      /* create JWT */
      $jwt = $this->_set_authentication_JWT($user_id, $device_info);
      /* create new user object */
      $user = new User($jwt);
      return ['token' => $jwt, 'user' => secure_user_values($user)];
    }
  }



  /* ------------------------------- */
  /* Two-Factor Authentication ✅ */
  /* ------------------------------- */

  /**
   * two_factor_authentication ✅
   * 
   * @param string $two_factor_key
   * @param integer $user_id
   * @param boolean $remember
   * @param boolean $from_web
   * @param array $device_info
   * @param boolean $connecting_account
   * @return void
   */
  public function two_factor_authentication($two_factor_key, $user_id, $remember = false, $from_web = false, $device_info = [], $connecting_account = false)
  {
    global $db, $system;
    if ($system['two_factor_type'] == "google") {
      /* get user */
      $get_user = $db->query(sprintf("SELECT user_two_factor_gsecret FROM users WHERE user_id = %s", secure($user_id, 'int')));
      if ($get_user->num_rows == 0) {
        _error(400);
      }
      $_user = $get_user->fetch_assoc();
      /* Google Authenticator */
      $ga = new Sonata\GoogleAuthenticator\GoogleAuthenticator();
      /* verify code */
      if (!$ga->checkCode($_user['user_two_factor_gsecret'], $two_factor_key)) {
        throw new ValidationException(__("Invalid code, please try again"));
      }
    } else {
      /* check two-factor key */
      $check_key = $db->query(sprintf("SELECT COUNT(*) as count FROM users WHERE user_id = %s AND user_two_factor_key = %s", secure($user_id, 'int'), secure($two_factor_key)));
      if ($check_key->fetch_assoc()['count'] == 0) {
        throw new ValidationException(__("Invalid code, please try again"));
      }
    }
    /* set authentication */
    if ($connecting_account) {
      $user = $this->get_user($user_id);
      $this->connected_account_connect($user);
    }
    if ($from_web) {
      $this->_set_authentication_cookies($user_id, $remember);
    } else {
      /* create JWT */
      $jwt = $this->_set_authentication_JWT($user_id, $device_info);
      /* create new user object */
      $user = new User($jwt);
      return ['token' => $jwt, 'user' => secure_user_values($user)];
    }
  }


  /**
   * disable_two_factor_authentication ✅
   * 
   * @param integer $user_id
   * 
   * @return void
   */
  public function disable_two_factor_authentication($user_id)
  {
    global $db;
    $db->query(sprintf("UPDATE users SET user_two_factor_enabled = '0', user_two_factor_type = null, user_two_factor_key = null, user_two_factor_gsecret = null WHERE user_id = %s", secure($user_id, 'int')));
  }



  /* ------------------------------- */
  /* Password ✅ */
  /* ------------------------------- */

  /**
   * forget_password ✅
   * 
   * @param string $email
   * @param string $recaptcha_response
   * @param string $turnstile_response
   * @param bool $from_web
   * @return void
   */
  public function forget_password($email, $recaptcha_response = null, $turnstile_response = null, $from_web = false)
  {
    global $db, $system;
    if (!valid_email($email)) {
      throw new ValidationException(__("Please enter a valid email address"));
    }
    if (!$this->check_email($email)) {
      throw new ValidationException(__("Sorry, it looks like") . " " . $email . " " . __("doesn't belong to any account"));
    }
    /* check reCAPTCHA */
    if ($system['reCAPTCHA_enabled'] && $from_web) {
      $recaptcha = new \ReCaptcha\ReCaptcha($system['reCAPTCHA_secret_key'], new \ReCaptcha\RequestMethod\CurlPost());
      $resp = $recaptcha->verify($recaptcha_response, get_user_ip());
      if (!$resp->isSuccess()) {
        throw new ValidationException(__("The security check is incorrect. Please try again"));
      }
    }
    /* check Turnstile */
    if ($system['turnstile_enabled'] && $from_web) {
      if (!check_cf_turnstile($turnstile_response)) {
        throw new ValidationException(__("The security check is incorrect. Please try again"));
      }
    }
    /* generate reset key */
    $reset_key = get_hash_key(6, true);
    /* update user */
    $db->query(sprintf("UPDATE users SET user_reset_key = %s, user_reseted = '1' WHERE user_email = %s", secure($reset_key), secure($email)));
    /* send reset email */
    /* prepare reset email */
    $subject = __("Forget password verification code!");
    $body = get_email_template("forget_password_email", $subject, ["email" => $email, "reset_key" => $reset_key]);
    /* send email */
    if (!_email($email, $subject, $body['html'], $body['plain'])) {
      throw new Exception(__("Forget password verification email could not be sent!"));
    }
  }


  /**
   * forget_password_confirm ✅
   * 
   * @param string $email
   * @param string $reset_key
   * @return void
   */
  public function forget_password_confirm($email, $reset_key)
  {
    global $db;
    if (!valid_email($email)) {
      throw new ValidationException(__("Invalid email, please try again"));
    }
    /* check reset key */
    $check_key = $db->query(sprintf("SELECT COUNT(*) as count FROM users WHERE user_email = %s AND user_reset_key = %s AND user_reseted = '1'", secure($email), secure($reset_key)));
    if ($check_key->fetch_assoc()['count'] == 0) {
      throw new ValidationException(__("Invalid code, please try again"));
    }
  }


  /**
   * forget_password_reset ✅
   * 
   * @param string $email
   * @param string $reset_key
   * @param string $password
   * @param string $confirm
   * @return void
   */
  public function forget_password_reset($email, $reset_key, $password, $confirm)
  {
    global $db;
    if (!valid_email($email)) {
      throw new ValidationException(__("Invalid email, please try again"));
    }
    /* check reset key */
    $check_key = $db->query(sprintf("SELECT COUNT(*) as count FROM users WHERE user_email = %s AND user_reset_key = %s AND user_reseted = '1'", secure($email), secure($reset_key)));
    if ($check_key->fetch_assoc()['count'] == 0) {
      throw new ValidationException(__("Invalid code, please try again"));
    }
    /* check password */
    $this->check_password($password);
    /* check password confirm */
    if ($password !== $confirm) {
      throw new ValidationException(__("Your passwords do not match. Please try another"));
    }
    /* update user password */
    $db->query(sprintf("UPDATE users SET user_password = %s, user_reseted = '0' WHERE user_email = %s", secure(_password_hash($password)), secure($email)));
    /* delete sessions */
    $db->query(sprintf("DELETE FROM users_sessions WHERE user_id = (SELECT user_id FROM users WHERE user_email = %s)", secure($email)));
  }



  /* ------------------------------- */
  /* Activation Email ✅ */
  /* ------------------------------- */

  /**
   * activation_email
   * 
   * @param string $code
   * @return void
   */
  public function activation_email($code)
  {
    global $db, $system;
    /* check user */
    if ($this->_data['user_email_verified']) {
      return;
    }
    if ($this->_data['user_email_verification_code'] != $code) {
      throw new ValidationException(__("Invalid verification code"));
    }
    /* check if user [1] activate his account & verify his email or [2] just verify his email */
    if ($system['activation_enabled'] && $system['activation_type'] == "email" && !$this->_data['user_activated']) {
      /* [1] activate his account & verify his email */
      $db->query(sprintf("UPDATE users SET user_activated = '1', user_email_verified = '1' WHERE user_id = %s", secure($this->_data['user_id'], 'int')));
      /* affiliates system */
      $this->process_affiliates("registration", $this->_data['user_id'], $this->_data['user_referrer_id']);
    } else {
      /* [2] just verify his email */
      $db->query(sprintf("UPDATE users SET user_email_verified = '1' WHERE user_id = %s", secure($this->_data['user_id'], 'int')));
    }
  }


  /**
   * activation_email_resend
   * 
   * @param integer $user_id
   * @return void
   */
  public function activation_email_resend($user_id = null)
  {
    global $db, $system;
    if (isset($user_id)) {
      $user = $this->get_user($user_id);
      if (!$user) {
        throw new NoDataException(__("No data found"));
      }
      $to_email = $user['user_email'];
      $to_name = ($system['show_usernames_enabled']) ? $user['user_name'] : $user['user_firstname'] . " " . $user['user_lastname'];
    } else {
      $user_id = $this->_data['user_id'];
      $to_email = $this->_data['user_email'];
      $to_name = $this->_data['user_fullname'];
    }
    /* generate email verification code */
    $email_verification_code = get_hash_key(6, true);
    /* update user */
    $db->query(sprintf("UPDATE users SET user_email_verification_code = %s WHERE user_id = %s", secure($email_verification_code), secure($user_id, 'int')));
    /* prepare activation email */
    $subject = __("Just one more step to get started on") . " " . html_entity_decode(__($system['system_title']), ENT_QUOTES);
    $body = get_email_template("activation_email", $subject, ["name" => $to_name, "email_verification_code" => $email_verification_code]);
    /* send email */
    if (!_email($to_email, $subject, $body['html'], $body['plain'])) {
      throw new Exception(__("Activation email could not be sent"));
    }
  }


  /**
   * activation_email_reset
   * 
   * @param string $email
   * @return void
   */
  public function activation_email_reset($email)
  {
    global $db, $system;
    if (!valid_email($email)) {
      throw new ValidationException(__("Please enter a valid email address"));
    }
    if ($this->check_email($email)) {
      throw new ValidationException(__("Sorry, it looks like") . " " . $email . " " . __("belongs to an existing account"));
    }
    /* generate email verification code */
    $email_verification_code = get_hash_key(6, true);
    /* check if activation via email enabled */
    if ($system['activation_enabled'] && $system['activation_type'] == "email") {
      /* update user (not activated) */
      $db->query(sprintf("UPDATE users SET user_email = %s, user_email_verified = '0', user_email_verification_code = %s, user_activated = '0' WHERE user_id = %s", secure($email), secure($email_verification_code), secure($this->_data['user_id'], 'int')));
    } else {
      /* update user */
      $db->query(sprintf("UPDATE users SET user_email = %s, user_email_verified = '0', user_email_verification_code = %s WHERE user_id = %s", secure($email), secure($email_verification_code), secure($this->_data['user_id'], 'int')));
    }
    /* prepare activation email */
    $subject = __("Just one more step to get started on") . " " . html_entity_decode(__($system['system_title']), ENT_QUOTES);
    $body = get_email_template("activation_email", $subject, ["name" => $this->_data['user_fullname'], "email_verification_code" => $email_verification_code]);
    /* send email */
    if (!_email($email, $subject, $body['html'], $body['plain'])) {
      throw new Exception(__("Activation email could not be sent"));
    }
  }



  /* ------------------------------- */
  /* Activation Phone ✅ */
  /* ------------------------------- */

  /**
   * activation_phone
   * 
   * @param string $code
   * @return void
   */
  public function activation_phone($code)
  {
    global $db, $system;
    /* check if phone already verified */
    if ($this->_data['user_phone_verified']) {
      return;
    }
    /* check the verification code */
    if ($this->_data['user_phone_verification_code'] != $code) {
      throw new ValidationException(__("Invalid code, please try again"));
    }
    /* check if user [1] activate his account & his phone or [2] just verify his phone */
    if ($system['activation_enabled'] && $system['activation_type'] == "sms" && !$this->_data['user_activated']) {
      /* [1] activate his account & his phone */
      $db->query(sprintf("UPDATE users SET user_activated = '1', user_phone_verified = '1' WHERE user_id = %s", secure($this->_data['user_id'], 'int')));
      /* affiliates system */
      $this->process_affiliates("registration", $this->_data['user_id'], $this->_data['user_referrer_id']);
    } else {
      /* [2] just verify his phone */
      $db->query(sprintf("UPDATE users SET user_phone_verified = '1' WHERE user_id = %s", secure($this->_data['user_id'], 'int')));
    }
  }


  /**
   * activation_phone_resend
   * 
   * @return void
   */
  public function activation_phone_resend()
  {
    global $db, $system;
    /* generate phone verification code */
    $phone_verification_code = get_hash_key(6, true);
    /* update user */
    $db->query(sprintf("UPDATE users SET user_phone_verification_code = %s WHERE user_id = %s", secure($phone_verification_code), secure($this->_data['user_id'], 'int')));
    /* prepare activation SMS */
    $message  = __($system['system_title']) . " " . __("Activation Code") . ": " . $phone_verification_code;
    /* send SMS */
    if (!sms_send($this->_data['user_phone'], $message)) {
      throw new Exception(__("Activation SMS could not be sent"));
    }
  }


  /**
   * activation_phone_reset
   * 
   * @param string $phone
   * @return void
   */
  public function activation_phone_reset($phone)
  {
    global $db, $system;
    if (is_empty($phone)) {
      throw new ValidationException(__("Please enter a valid phone number"));
    }
    if ($this->check_phone($phone)) {
      throw new ValidationException(__("Sorry, it looks like") . " " . $phone . " " . __("belongs to an existing account"));
    }
    /* generate phone verification code */
    $phone_verification_code = get_hash_key(6, true);
    /* check if activation via sms enabled */
    if ($system['activation_enabled'] && $system['activation_type'] == "sms") {
      /* update user (not activated) */
      $db->query(sprintf("UPDATE users SET user_phone = %s, user_phone_verified = '0', user_phone_verification_code = %s, user_activated = '0' WHERE user_id = %s", secure($phone), secure($phone_verification_code), secure($this->_data['user_id'], 'int')));
    } else {
      /* update user */
      $db->query(sprintf("UPDATE users SET user_phone = %s, user_phone_verified = '0', user_phone_verification_code = %s WHERE user_id = %s", secure($phone), secure($phone_verification_code), secure($this->_data['user_id'], 'int')));
    }
    /* prepare activation SMS */
    $message  = __($system['system_title']) . " " . __("Activation Code") . ": " . $phone_verification_code;
    /* send SMS */
    if (!sms_send($phone, $message)) {
      throw new Exception(__("Activation SMS could not be sent"));
    }
  }



  /* ------------------------------- */
  /* Security Checks ✅ */
  /* ------------------------------- */

  /**
   * verify_password ✅
   * 
   * @param string $password
   * @return void
   */
  public function verify_password($password)
  {
    /* check if empty */
    if (is_empty($password)) {
      throw new ValidationException(__("You have to enter your password to continue"));
    }
    /* validate current password */
    if (!password_verify($password, $this->_data['user_password'])) {
      throw new ValidationException(__("Your current password is incorrect"));
    }
  }


  /**
   * check_password ✅
   *
   * @param string $password
   * @return void
   */
  public function check_password($password)
  {
    global $system;
    /* check minimum password length */
    if (strlen($password) < 6) {
      throw new ValidationException(__("Your password must be at least 6 characters long. Please try another"));
    }
    /* check maximum password length */
    if (strlen($password) > 64) {
      throw new ValidationException(__("Your password must be less than 64 characters long. Please try another"));
    }
    /* check if password complexity system enabled */
    if ($system['password_complexity_enabled']) {
      /* check if password contains at least one uppercase letter */
      if (!preg_match('/[A-Z]/', $password)) {
        throw new ValidationException(__("Your password must contain at least one uppercase letter. Please try another"));
      }
      /* check if password contains at least one lowercase letter */
      if (!preg_match('/[a-z]/', $password)) {
        throw new ValidationException(__("Your password must contain at least one lowercase letter. Please try another"));
      }
      /* check if password contains at least one number */
      if (!preg_match('/[0-9]/', $password)) {
        throw new ValidationException(__("Your password must contain at least one number. Please try another"));
      }
      /* check if password contains at least one special character */
      if (!preg_match('/[!@#$%^&*()_+\-=\[\]{};:"\\|,.<>\/?]+/', $password)) {
        throw new ValidationException(__("Your password must contain at least one special character. Please try another"));
      }
    }
  }


  /**
   * check_email ✅
   * 
   * @param string $email
   * @param boolean $return_info
   * @return boolean|array
   */
  public function check_email($email, $return_info = false)
  {
    global $system, $db;
    /* get email domain */
    $email_domain = explode('@', $email)[1];
    /* get email last domain (example: foo@bar.domain.com) return domain.com */
    $domain_parts = explode('.', $email_domain);
    $email_last_domain = $domain_parts[count($domain_parts) - 2] . '.' . $domain_parts[count($domain_parts) - 1];
    /* first check if whitelist enabled */
    if ($system['whitelist_enabled']) {
      if (!is_empty($system['whitelist_providers'])) {
        $whitelist_providers = array_column(json_decode(html_entity_decode($system['whitelist_providers']), true), 'value');
        if (count($whitelist_providers) != 0) {
          if (!in_array($email_domain, $whitelist_providers)) {
            throw new ValidationException(__("Only emails from the following providers are allowed") . " (" . implode(", ", $whitelist_providers) . ")");
          }
        }
      }
    } else {
      /* if not -> check if blacklist enabled */
      $check_banned = $db->query(sprintf("SELECT COUNT(*) as count FROM blacklist WHERE node_type = 'email' AND (node_value = %s OR node_value = %s)", secure($email_domain), secure($email_last_domain)));
      if ($check_banned->fetch_assoc()['count'] > 0) {
        throw new ValidationException(__("Sorry but this provider") . " " . $email_domain . " " . __("is not allowed in our system"));
      }
    }
    $query = $db->query(sprintf("SELECT * FROM users WHERE user_email = %s", secure($email)));
    if ($query->num_rows > 0) {
      if ($return_info) {
        $info = $query->fetch_assoc();
        return $info;
      }
      return true;
    }
    return false;
  }


  /**
   * check_phone ✅
   * 
   * @param string $phone
   * @return boolean
   */
  public function check_phone($phone)
  {
    global $db;
    $query = $db->query(sprintf("SELECT COUNT(*) as count FROM users WHERE user_phone = %s", secure($phone)));
    if ($query->fetch_assoc()['count'] > 0) {
      return true;
    }
    return false;
  }


  /**
   * check_username ✅
   * 
   * @param string $username
   * @param string $type
   * @param boolean $return_info
   * @return boolean|array
   */
  public function check_username($username, $type = 'user', $return_info = false)
  {
    global $db;
    /* check if banned by the system */
    $check_banned = $db->query(sprintf("SELECT COUNT(*) as count FROM blacklist WHERE node_type = 'username' AND node_value = %s", secure($username)));
    if ($check_banned->fetch_assoc()['count'] > 0) {
      throw new ValidationException(__("Sorry but this username") . " " . $username . " " . __("is not allowed in our system"));
    }
    /* check type (user|page|group) */
    switch ($type) {
      case 'page':
        $query = $db->query(sprintf("SELECT * FROM pages WHERE page_name = %s", secure($username)));
        break;

      case 'group':
        $query = $db->query(sprintf("SELECT * FROM `groups` WHERE group_name = %s", secure($username)));
        break;

      default:
        $query = $db->query(sprintf("SELECT * FROM users WHERE user_name = %s", secure($username)));
        break;
    }
    if ($query->num_rows > 0) {
      if ($return_info) {
        $info = $query->fetch_assoc();
        return $info;
      }
      return true;
    }
    return false;
  }


  /**
   * reserved_username ✅
   * 
   * @param string $username
   * @return boolean
   */
  public function reserved_username($username)
  {
    global $system;
    if (!$system['reserved_usernames_enabled']) {
      return false;
    }
    /* make a list from target usernames */
    $reserved_usernames = array_column(json_decode(html_entity_decode($system['reserved_usernames']), true), "value");
    if (count($reserved_usernames) == 0) {
      return false;
    }
    if (in_array(strtolower($username), $reserved_usernames)) {
      return true;
    }
    return false;
  }
}
