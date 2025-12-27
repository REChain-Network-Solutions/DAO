<?php

/**
 * trait -> developers
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich
 */

trait DevelopersTrait
{

  /* ------------------------------- */
  /* Developers Apps */
  /* ------------------------------- */

  /**
   * get_apps
   * 
   * @return array
   */
  public function get_apps()
  {
    global $db;
    $apps = [];
    $get_apps = $db->query(sprintf("SELECT * FROM developers_apps WHERE app_user_id = %s ORDER BY app_id DESC", secure($this->_data['user_id'], 'int')));
    if ($get_apps->num_rows > 0) {
      while ($app = $get_apps->fetch_assoc()) {
        $apps[] = $app;
      }
    }
    return $apps;
  }


  /**
   * get_user_apps
   * 
   * @return array
   */
  public function get_user_apps()
  {
    global $db;
    $apps = [];
    $get_apps = $db->query(sprintf("SELECT developers_apps.* FROM developers_apps_users INNER JOIN developers_apps ON developers_apps_users.app_id = developers_apps.app_id WHERE developers_apps_users.user_id = %s ORDER BY developers_apps_users.id DESC", secure($this->_data['user_id'], 'int')));
    if ($get_apps->num_rows > 0) {
      while ($app = $get_apps->fetch_assoc()) {
        $apps[] = $app;
      }
    }
    return $apps;
  }


  /**
   * get_app
   * 
   * @param integer $app_auth_id
   * @return array
   */
  public function get_app($app_auth_id)
  {
    global $db;
    $get_app = $db->query(sprintf("SELECT developers_apps.*, developers_apps_categories.category_name FROM developers_apps LEFT JOIN developers_apps_categories ON developers_apps.app_category_id = developers_apps_categories.category_id WHERE developers_apps.app_auth_id = %s", secure($app_auth_id, 'int')));
    if ($get_app->num_rows == 0) {
      return false;
    }
    $app = $get_app->fetch_assoc();
    return $app;
  }


  /**
   * create_app
   * 
   * @param array $args
   * @return void
   */
  public function create_app($args = [])
  {
    global $db, $system, $date;
    /* check if developers apps enabled */
    if (!$system['developers_apps_enabled']) {
      throw new Exception(__("The developers module has been disabled by the admin"));
    }
    /* validate app name */
    if (is_empty($args['app_name'])) {
      throw new Exception(__("You have to enter the App name"));
    }
    /* validate app domain */
    if (is_empty($args['app_domain'])) {
      throw new Exception(__("You have to enter the App domain"));
    }
    /* validate app redirect_url */
    if (is_empty($args['app_redirect_url'])) {
      throw new Exception(__("You have to enter the App redirect URL"));
    }
    if (!valid_url($args['app_redirect_url'])) {
      throw new Exception(__("Please enter a valid App redirect URL"));
    }
    /* validate app description */
    if (is_empty($args['app_description'])) {
      throw new Exception(__("You have to enter the App description"));
    }
    if (strlen($args['app_description']) > 200) {
      throw new Exception(__("Your App description is more than 200 characters"));
    }
    /* validate category */
    if (is_empty($args['app_category'])) {
      throw new Exception(__("You must select valid category for your App"));
    }
    $check = $db->query(sprintf("SELECT COUNT(*) as count FROM developers_apps_categories WHERE category_id = %s", secure($args['app_category'], 'int')));
    if ($check->fetch_assoc()['count'] == 0) {
      throw new Exception(__("You must select valid category for your App"));
    }
    /* validate app icon */
    if (is_empty($args['app_icon'])) {
      throw new Exception(__("You have to enter the App icon"));
    }
    /* generate app auth id & secret */
    $app_auth_id = get_hash_number();
    $app_auth_secret = get_hash_token();
    /* insert new app */
    $db->query(sprintf(
      "INSERT INTO developers_apps (
            app_user_id, 
            app_category_id, 
            app_auth_id, 
            app_auth_secret, 
            app_name, 
            app_domain, 
            app_redirect_url, 
            app_description, 
            app_icon, 
            app_date) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)",
      secure($this->_data['user_id'], 'int'),
      secure($args['app_category'], 'int'),
      secure($app_auth_id),
      secure($app_auth_secret),
      secure($args['app_name']),
      secure($args['app_domain']),
      secure($args['app_redirect_url']),
      secure($args['app_description']),
      secure($args['app_icon']),
      secure($date)
    ));
    /* remove pending uploads */
    remove_pending_uploads([$args['app_icon']]);
  }


  /**
   * edit_app
   * 
   * @param integer $app_auth_id
   * @param array $args
   * @return void
   */
  public function edit_app($app_auth_id, $args)
  {
    global $db, $system;
    /* check if developers apps enabled */
    if (!$system['developers_apps_enabled']) {
      throw new Exception(__("The developers module has been disabled by the admin"));
    }
    /* (check&get) app */
    $get_app = $db->query(sprintf("SELECT * FROM developers_apps WHERE app_auth_id = %s", secure($app_auth_id, 'int')));
    if ($get_app->num_rows == 0) {
      _error(403);
    }
    $app = $get_app->fetch_assoc();
    /* check permission */
    $can_edit = false;
    /* viewer is (admin|moderator) */
    if ($this->_data['user_group'] < 3) {
      $can_edit = true;
      /* viewer is the creator of app */
    } elseif ($this->_data['user_id'] == $app['app_user_id']) {
      $can_edit = true;
    }
    /* edit the app */
    if (!$can_edit) {
      _error(403);
    }
    /* validate app name */
    if (is_empty($args['app_name'])) {
      throw new Exception(__("You have to enter the app name"));
    }
    /* validate app domain */
    if (is_empty($args['app_domain'])) {
      throw new Exception(__("You have to enter the app domain"));
    }
    /* validate app redirect_url */
    if (is_empty($args['app_redirect_url'])) {
      throw new Exception(__("You have to enter the app redirect URL"));
    }
    if (!valid_url($args['app_redirect_url'])) {
      throw new Exception(__("Please enter a valid app redirect URL"));
    }
    /* validate app description */
    if (is_empty($args['app_description'])) {
      throw new Exception(__("You have to enter the app description"));
    }
    if (strlen($args['app_description']) > 200) {
      throw new Exception(__("Your App description is more than 200 characters"));
    }
    /* validate category */
    if (is_empty($args['app_category'])) {
      throw new Exception(__("You must select valid category for your App"));
    }
    $check = $db->query(sprintf("SELECT COUNT(*) as count FROM developers_apps_categories WHERE category_id = %s", secure($args['app_category'], 'int')));
    if ($check->fetch_assoc()['count'] == 0) {
      throw new Exception(__("You must select valid category for your App"));
    }
    /* validate app icon */
    if (is_empty($args['app_icon'])) {
      throw new Exception(__("You have to enter the app icon"));
    }
    /* update the app */
    $db->query(sprintf(
      "UPDATE developers_apps SET 
            app_category_id = %s, 
            app_name = %s, 
            app_domain = %s, 
            app_redirect_url = %s, 
            app_description = %s, 
            app_icon = %s  WHERE app_auth_id = %s",
      secure($args['app_category'], 'int'),
      secure($args['app_name']),
      secure($args['app_domain']),
      secure($args['app_redirect_url']),
      secure($args['app_description']),
      secure($args['app_icon']),
      secure($app_auth_id, 'int')
    ));
    /* remove pending uploads */
    remove_pending_uploads([$args['app_icon']]);
  }


  /**
   * delete_app
   * 
   * @param integer $app_auth_id
   * @return void
   */
  public function delete_app($app_auth_id)
  {
    global $db, $system;
    /* check if developers apps enabled */
    if ($this->_data['user_group'] >= 3 && !$system['developers_apps_enabled']) {
      throw new Exception(__("The developers module has been disabled by the admin"));
    }
    /* (check&get) app */
    $get_app = $db->query(sprintf("SELECT * FROM developers_apps WHERE app_auth_id = %s", secure($app_auth_id, 'int')));
    if ($get_app->num_rows == 0) {
      _error(403);
    }
    $app = $get_app->fetch_assoc();
    // delete app
    $can_delete = false;
    /* viewer is (admin|moderator) */
    if ($this->_data['user_group'] < 3) {
      $can_delete = true;
      /* viewer is the creator of app */
    } elseif ($this->_data['user_id'] == $app['app_user_id']) {
      $can_delete = true;
    }
    /* delete the app */
    if (!$can_delete) {
      _error(403);
    }
    $db->query(sprintf("DELETE FROM developers_apps WHERE app_auth_id = %s", secure($app_auth_id, 'int')));
    $db->query(sprintf("DELETE FROM developers_apps_users WHERE app_id = %s", secure($app['app_id'], 'int')));
  }


  /**
   * delete_user_app
   * 
   * @param integer $app_auth_id
   * @return void
   */
  public function delete_user_app($app_auth_id)
  {
    global $db, $system;
    /* check if developers apps enabled */
    if (!$system['developers_apps_enabled']) {
      throw new Exception(__("The developers module has been disabled by the admin"));
    }
    /* (check&get) app */
    $get_app = $db->query(sprintf("SELECT * FROM developers_apps WHERE app_auth_id = %s", secure($app_auth_id, 'int')));
    if ($get_app->num_rows > 0) {
      $app = $get_app->fetch_assoc();
      /* delete the user-app connection */
      $db->query(sprintf("DELETE FROM developers_apps_users WHERE app_id = %s AND user_id = %s", secure($app['app_id'], 'int'), secure($this->_data['user_id'], 'int')));
    }
  }


  /**
   * oauth_app
   * 
   * @param integer $app_auth_id
   * @param boolean $approving
   * @return void
   */
  public function oauth_app($app_auth_id, $approving = false)
  {
    global $db, $system, $smarty;
    /* check if developers apps enabled */
    if (!$system['developers_apps_enabled']) {
      if ($approving) {
        throw new Exception(__("The developers module has been disabled by the admin"));
      } else {
        _error(__('Error'), __("The developers module has been disabled by the admin"));
      }
    }
    /* (check&get) app */
    $app = $this->get_app($app_auth_id);
    if (!$app) {
      if ($approving) {
        throw new Exception(__("We're sorry, but the application you're trying to use doesn't exist or has been disabled"));
      } else {
        _error(__('Error'), __("We're sorry, but the application you're trying to use doesn't exist or has been disabled"));
      }
    }
    /* check if user OAuthenticated this app before */
    $check_user_connection = $db->query(sprintf("SELECT COUNT(*) as count FROM developers_apps_users WHERE app_id = %s AND user_id = %s", secure($app['app_id'], 'int'), secure($this->_data['user_id'], 'int')));
    if ($check_user_connection->fetch_assoc()['count'] > 0) {
      /* user OAuthenticated this app -> return redirect URL */
      /* generate new auth_key */
      $auth_key = get_hash_token();
      /* update auth_key */
      $db->query(sprintf("UPDATE developers_apps_users SET auth_key = %s WHERE app_id = %s AND user_id = %s", secure($auth_key), secure($app['app_id'], 'int'), secure($this->_data['user_id'], 'int')));
      /* return redirect_URL */
      $redirect_URL = $app['app_redirect_url'] . "?auth_key=" . $auth_key;
      if ($approving) {
        return $redirect_URL;
      } else {
        header('Location: ' . $redirect_URL);
      }
    } else {
      /* user didn't OAuthenticated this app -> OAuthenticated the app */
      if ($approving) {
        /* generate new auth_key */
        $auth_key = get_hash_token();
        /* insert new auth_key */
        $db->query(sprintf("INSERT INTO developers_apps_users (app_id, user_id, auth_key) VALUES (%s, %s, %s)", secure($app['app_id'], 'int'), secure($this->_data['user_id'], 'int'), secure($auth_key)));
        /* return redirect_URL */
        $redirect_URL = $app['app_redirect_url'] . "?auth_key=" . $auth_key;
        return $redirect_URL;
      } else {
        /* prepare OAuth page */
        $smarty->assign('app', $app);
        page_header(__("Log in With") . " " . __($system['system_title']));
        page_footer('app_oauth');
      }
    }
  }


  /**
   * authorize_app
   * 
   * @param integer $app_auth_id
   * @param string $app_auth_secret
   * @param string $auth_key
   * @return string
   */
  public function authorize_app($app_auth_id, $app_auth_secret, $auth_key)
  {
    global $db, $system, $date;
    /* check if developers apps enabled */
    if (!$system['developers_apps_enabled']) {
      throw new Exception(__("The developers module has been disabled by the admin"));
    }
    /* (check&get) app */
    $app = $this->get_app($app_auth_id);
    if (!$app) {
      throw new Exception(__("We're sorry, but the application you're trying to use doesn't exist or has been disabled"));
    }
    /* check app_auth_secret */
    if ($app['app_auth_secret'] !== $app_auth_secret) {
      return_json(['error' => true, 'message' => "Bad Request, invalid app_secret"]);
    }
    /* check if user OAuthenticated this app before */
    $get_user_connection = $db->query(sprintf("SELECT * FROM developers_apps_users WHERE app_id = %s AND auth_key = %s", secure($app['app_id'], 'int'), secure($auth_key)));
    if ($get_user_connection->num_rows == 0) {
      return_json(['error' => true, 'message' => "Bad Request, invalid auth_key"]);
    }
    $user_connection = $get_user_connection->fetch_assoc();
    /* generate new auth_key */
    $auth_key = get_hash_token();
    /* update auth_key */
    $db->query(sprintf("UPDATE developers_apps_users SET auth_key = %s WHERE app_id = %s AND user_id = %s", secure($auth_key), secure($app['app_id'], 'int'), secure($user_connection['user_id'])));
    /* check if there is access_token & valid */
    if ($user_connection['access_token'] && (strtotime($user_connection['access_token_date']) >= strtotime("-1 minutes"))) {
      $access_token = $user_connection['access_token'];
    } else {
      /* generate new access_token */
      $access_token = get_hash_token();
      /* update access_token */
      $db->query(sprintf("UPDATE developers_apps_users SET access_token = %s, access_token_date = %s WHERE app_id = %s AND user_id = %s", secure($access_token), secure($date), secure($app['app_id'], 'int'), secure($user_connection['user_id'])));
    }
    return $access_token;
  }


  /**
   * access_app
   * 
   * @param string $access_token
   * @return void
   */
  public function access_app($access_token)
  {
    global $db, $system, $smarty;
    /* check if developers apps enabled */
    if (!$system['developers_apps_enabled']) {
      throw new Exception(__("The developers module has been disabled by the admin"));
    }
    /* check if user OAuthenticated this app before */
    $check_user_connection = $db->query(sprintf("SELECT * FROM developers_apps_users WHERE access_token = %s", secure($access_token)));
    if ($check_user_connection->num_rows == 0) {
      return_json(['error' => true, 'message' => "Bad Request, invalid access_token"]);
    }
    $user_connection = $check_user_connection->fetch_assoc();
    /* check if there is access_token & valid */
    if ($user_connection['access_token'] && (strtotime($user_connection['access_token_date']) >= strtotime("-1 minutes"))) {
      return $user_connection['user_id'];
    } else {
      return_json(['error' => true, 'message' => "Bad Request, expired access_token"]);
    }
  }
}
