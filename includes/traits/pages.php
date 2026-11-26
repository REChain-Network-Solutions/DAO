<?php

/**
 * trait -> pages
 * 
 * @package Sngine
 * @author Zamblek
 */

trait PagesTrait
{

  /* ------------------------------- */
  /* Pages */
  /* ------------------------------- */

  /**
   * get_pages
   * 
   * @param array $args
   * @return array
   */
  public function get_pages($args = [])
  {
    global $db, $system;
    /* initialize arguments */
    $user_id = !isset($args['user_id']) ? null : $args['user_id'];
    $category_id = !isset($args['category_id']) ? null : $args['category_id'];
    $country = !isset($args['country']) ? null : $args['country'];
    $language = !isset($args['language']) ? null : $args['language'];
    $random = filter_var($args['random'] ?? false, FILTER_VALIDATE_BOOLEAN);
    $get_all = !isset($args['get_all']) ? false : true;
    $offset = !isset($args['offset']) ? 0 : $args['offset'];
    $results = !isset($args['results']) ? $system['pages_results'] : $args['results'];
    $promoted = !isset($args['promoted']) ? false : true;
    $boosted = !isset($args['boosted']) ? false : true;
    $suggested = !isset($args['suggested']) ? false : true;
    $managed = !isset($args['managed']) ? false : true;
    $count = !isset($args['count']) ? false : true;
    /* initialize vars */
    $pages = [];
    $this->_cursor = null;
    if ($count) {
      $offset = 0;
      $results = PHP_INT_MAX;
    }
    $offset *= $results;
    /* prepare query (wrapped as a count when requested) */
    $query = function ($sql) use ($db, $count) {
      return $db->query(($count) ? "SELECT COUNT(*) AS count FROM (" . $sql . ") AS results" : $sql);
    };
    /* prepare country statement */
    if ($country && $system['pages_location_filter_enabled'] && $country != "all") {
      $country_statement = sprintf(" AND page_country = %s ", secure($country, 'int'));
    }
    /* prepare language statement */
    if ($language && $language != "all") {
      $language_statement = sprintf(" AND page_language = %s ", secure($language, 'int'));
    }
    /* pages after the first continue from a cursor (the last page id) instead of an offset */
    $use_cursor = !$count && !$get_all && !$promoted && !($suggested && $random);
    $cursor = ($use_cursor) ? cursor_decode($args['cursor'] ?? null, ['int']) : null;
    $language_statement = ($language_statement ?? "") . (($cursor) ? " AND " . cursor_where(['pages.page_id'], $cursor) : "");
    if ($cursor) {
      $offset = 0;
    }
    if ($promoted) {
      /* get promoted pages */
      $residual_statement = ($country_statement ?? "") . ($language_statement ?? "");
      if ($count) {
        $get_pages = $query("SELECT page_id FROM pages WHERE page_boosted = '1' " . $residual_statement);
      } else {
        $filter = ($residual_statement) ? function ($ids) use ($db, $residual_statement) {
          return array_column($db->query(sprintf("SELECT page_id FROM pages WHERE page_id IN (%s) " . $residual_statement, implode(',', $ids)))->fetch_all(MYSQLI_ASSOC), 'page_id');
        } : null;
        $pages_ids = sample_ids('pages', 'page_id', "page_boosted = '1'", $results, ['pool' => 200, 'filter' => $filter, 'shared' => 'promoted_pages']);
        $rows = ($pages_ids) ? $db->query(sprintf("SELECT * FROM pages WHERE page_id IN (%s)", implode(',', $pages_ids)))->fetch_all(MYSQLI_ASSOC) : [];
        $get_pages = new PrefetchedResult(rows_by_ids($rows, 'page_id', $pages_ids));
      }
    } elseif ($boosted) {
      /* get the "viewer" boosted pages */
      $get_pages = $query(sprintf("SELECT * FROM pages WHERE page_boosted = '1' AND page_boosted_by = %s " . $country_statement . $language_statement . " ORDER BY page_id DESC LIMIT %s, %s", secure($this->_data['user_id'], 'int'), secure($offset, 'int', false), secure($results, 'int', false)));
    } elseif ($suggested) {
      /* get suggested pages */
      $category_statement = ($category_id) ? "AND page_category = " . secure($category_id, 'int') : "";
      if ($random && !$count) {
        /* random pages, sampled through the pages ids (or the category) */
        $residual_statement = ($country_statement ?? "") . ($language_statement ?? "");
        $filter = ($residual_statement) ? function ($ids) use ($db, $residual_statement) {
          return array_column($db->query(sprintf("SELECT page_id FROM pages WHERE page_id IN (%s) " . $residual_statement, implode(',', $ids)))->fetch_all(MYSQLI_ASSOC), 'page_id');
        } : null;
        $pages_ids = sample_ids('pages', 'page_id', ($category_id) ? sprintf("page_category = %s", secure($category_id, 'int')) : "page_id > 0", $results, ['pivots' => 3, 'exclude' => $this->get_pages_ids(), 'filter' => $filter]);
        $rows = ($pages_ids) ? $db->query(sprintf("SELECT * FROM pages WHERE page_id IN (%s)", implode(',', $pages_ids)))->fetch_all(MYSQLI_ASSOC) : [];
        $get_pages = new PrefetchedResult(rows_by_ids($rows, 'page_id', $pages_ids));
      } else {
        $get_pages = $query(sprintf("SELECT * FROM pages WHERE page_id NOT IN (%s) %s " . $country_statement . $language_statement . " ORDER BY page_id DESC LIMIT %s, %s", $this->spread_ids($this->get_pages_ids()), $category_statement, secure($offset, 'int', false), secure($results, 'int', false)));
      }
    } elseif ($managed) {
      /* get the "taget" all pages who admin */
      $limit_statement = ($get_all) ? "" : sprintf("LIMIT %s, %s", secure($offset, 'int', false), secure($results, 'int', false));
      $get_pages = $query(sprintf("SELECT pages.* FROM pages_admins INNER JOIN pages ON pages_admins.page_id = pages.page_id WHERE pages_admins.user_id = %s " . $country_statement . $language_statement . " ORDER BY page_id DESC " . $limit_statement, secure($user_id, 'int')));
    } elseif ($user_id == null) {
      /* get the "viewer" pages who admin */
      $limit_statement = ($get_all) ? "" : sprintf("LIMIT %s, %s", secure($offset, 'int', false), secure($results, 'int', false));
      $get_pages = $query(sprintf("SELECT pages.* FROM pages_admins INNER JOIN pages ON pages_admins.page_id = pages.page_id WHERE pages_admins.user_id = %s " . $country_statement . $language_statement . " ORDER BY page_id DESC " . $limit_statement, secure($this->_data['user_id'], 'int'), secure($offset, 'int', false), secure($results, 'int', false)));
    } else {
      /* get the "target" liked pages*/
      /* get the target user's privacy */
      $get_privacy = $db->query(sprintf("SELECT user_privacy_pages FROM users WHERE user_id = %s", secure($user_id, 'int')));
      $privacy = $get_privacy->fetch_assoc();
      /* check the target user's privacy */
      if (!$this->check_privacy($privacy['user_privacy_pages'], $user_id)) {
        return ($count) ? 0 : $pages;
      }
      $get_pages = $query(sprintf("SELECT pages.* FROM pages INNER JOIN pages_likes ON pages.page_id = pages_likes.page_id WHERE pages_likes.user_id = %s " . $country_statement . $language_statement . " ORDER BY pages.page_id DESC LIMIT %s, %s", secure($user_id, 'int'), secure($offset, 'int', false), secure($results, 'int', false)));
    }
    if ($count) {
      return (int) $get_pages->fetch_assoc()['count'];
    }
    if ($get_pages->num_rows > 0) {
      $rows = $get_pages->fetch_all(MYSQLI_ASSOC);
      $this->preload_memberships('pages', array_column($rows, 'page_id'));
      foreach ($rows as $page) {
        $page['page_picture'] = get_picture($page['page_picture'], 'page');
        /* check if the viewer liked the page */
        $page['i_like'] = $this->check_page_membership($this->_data['user_id'], $page['page_id']);
        $pages[] = $page;
      }
    }
    $this->_cursor = ($use_cursor && !empty($rows)) ? cursor_encode([end($rows)['page_id']]) : null;
    return $pages;
  }


  /**
   * get_page
   * 
   * @param integer $page_id
   * @return array
   */
  public function get_page($page_id)
  {
    global $db;
    $get_page = $db->query(sprintf("SELECT * FROM pages WHERE page_id = %s", secure($page_id, 'int')));
    if ($get_page->num_rows == 0) {
      return false;
    }
    return $get_page->fetch_assoc();
  }


  /**
   * create_page
   * 
   * @param array $args
   * @return void
   */
  public function create_page($args = [])
  {
    global $db, $system, $date;
    /* check if pages enabled */
    if (!$system['pages_enabled']) {
      throw new Exception(__("The pages module has been disabled by the admin"));
    }
    /* check pages permission */
    if (!$this->_data['can_create_pages']) {
      throw new Exception(__("You don't have the permission to do this"));
    }
    /* validate title */
    if (is_empty($args['title'])) {
      throw new Exception(__("You must enter a title for your page"));
    }
    if (strlen($args['title']) < 3) {
      throw new Exception(__("Page title must be at least 3 characters long. Please try another"));
    }
    /* validate username */
    if (is_empty($args['username'])) {
      throw new Exception(__("You must enter a username for your page"));
    }
    if (!valid_username($args['username'])) {
      throw new Exception(__("Please enter a valid username (a-z0-9_.) with minimum 3 characters long"));
    }
    if ($this->reserved_username($args['username'])) {
      throw new Exception(__("You can't use") . " " . $args['username'] . " " . __("as username"));
    }
    if ($this->check_username($args['username'], 'page')) {
      throw new Exception(__("Sorry, it looks like this username") . " " . $args['username'] . " " . __("belongs to an existing page"));
    }
    /* validate category */
    if (is_empty($args['category'])) {
      throw new Exception(__("You must select valid category for your page"));
    } else {
      if (!$this->check_category('pages_categories', $args['category'])) {
        throw new Exception(__("You must select valid category for your page"));
      }
    }
    /* validate country */
    if ($args['country'] == "none") {
      throw new Exception(__("You must select valid country"));
    } else {
      if (!$this->check_country($args['country'])) {
        throw new Exception(__("You must select valid country"));
      }
    }
    /* validate language */
    if ($args['language'] == "none") {
      throw new Exception(__("You must select valid language"));
    } else {
      if (!$this->check_language($args['language'])) {
        throw new Exception(__("You must select valid language"));
      }
    }
    /* set custom fields */
    $custom_fields = $this->set_custom_fields($args, "page");
    /* insert new page */
    $db->query(sprintf(
      "INSERT INTO pages (
        page_admin, 
        page_category, 
        page_name, 
        page_title, 
        page_country, 
        page_language, 
        page_description, 
        page_date
      ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)",
      secure($this->_data['user_id'], 'int'),
      secure($args['category'], 'int'),
      secure($args['username']),
      secure($args['title']),
      secure($args['country'], 'int'),
      secure($args['language'], 'int'),
      secure($args['description']),
      secure($date)
    ));
    /* get page_id */
    $page_id = $db->insert_id;
    /* insert page PBID */
    if ($system['pages_pbid_enabled']) {
      $args['pbid'] = $this->generate_pbid($args['country'], $args['category'], $page_id);
      $db->query(sprintf("UPDATE pages SET page_pbid = %s WHERE page_id = %s", secure($args['pbid']), secure($page_id, 'int')));
    }
    /* insert custom fields values */
    if ($custom_fields) {
      foreach ($custom_fields as $field_id => $value) {
        $db->query(sprintf("INSERT INTO custom_fields_values (value, field_id, node_id, node_type) VALUES (%s, %s, %s, 'page')", secure($value), secure($field_id, 'int'), secure($page_id, 'int')));
      }
    }
    /* like the page */
    $this->connect("page-like", $page_id);
    /* page admin addation */
    $this->connect("page-admin-addation", $page_id, $this->_data['user_id']);
  }


  /**
   * edit_page
   * 
   * @param integer $page_id
   * @param string $edit
   * @param array $args
   * @return string
   */
  public function edit_page($page_id, $edit, $args)
  {
    global $db, $system;
    /* check if pages enabled */
    if (!$system['pages_enabled']) {
      throw new Exception(__("The pages module has been disabled by the admin"));
    }
    /* check pages permission */
    if (!$this->_data['can_create_pages']) {
      throw new Exception(__("You don't have the permission to do this"));
    }
    /* (check&get) page */
    $get_page = $db->query(sprintf("SELECT * FROM pages WHERE page_id = %s", secure($page_id, 'int')));
    if ($get_page->num_rows == 0) {
      _error(403);
    }
    $page = $get_page->fetch_assoc();
    /* check permission */
    $can_edit = false;
    /* viewer is (admin|moderator) */
    if ($this->_data['user_group'] < 3) {
      $can_edit = true;
      /* viewer is the admin of page */
    } elseif ($this->check_page_adminship($this->_data['user_id'], $page_id)) {
      $can_edit = true;
    }
    if (!$can_edit) {
      _error(403);
    }
    /* edit page */
    switch ($edit) {
      case 'settings':
        /* validate title */
        if (is_empty($args['title'])) {
          throw new Exception(__("You must enter a title for your page"));
        }
        if (strlen($args['title']) < 3) {
          throw new Exception(__("Page title must be at least 3 characters long. Please try another"));
        }
        /* validate username */
        if (strtolower($args['username']) != strtolower($page['page_name'])) {
          if (is_empty($args['username'])) {
            throw new Exception(__("You must enter a username for your page"));
          }
          if (!valid_username($args['username'])) {
            throw new Exception(__("Please enter a valid username (a-z0-9_.) with minimum 3 characters long"));
          }
          if ($this->reserved_username($args['username'])) {
            throw new Exception(__("You can't use") . " " . $args['username'] . " " . __("as username"));
          }
          if ($this->check_username($args['username'], 'page')) {
            throw new Exception(__("Sorry, it looks like this username") . " " . $args['username'] . " " . __("belongs to an existing page"));
          }
          /* set new page name */
          $page['page_name'] = $args['username'];
        }
        /* validate category */
        if (is_empty($args['category'])) {
          throw new Exception(__("You must select valid category for your page"));
        } else {
          if (!$this->check_category('pages_categories', $args['category'])) {
            throw new Exception(__("You must select valid category for your page"));
          }
        }
        /* prepare */
        $args['page_tips_enabled'] = (isset($args['page_tips_enabled'])) ? '1' : '0';
        $args['page_messages_enabled'] = ($system['pages_messages_enabled']) ? ((isset($args['page_messages_enabled'])) ? '1' : '0') : $page['page_messages_enabled'];
        /* edit from admin panel */
        $args['page_verified'] = ($this->_data['user_group'] == 1 && isset($args['page_verified'])) ? $args['page_verified'] : $page['page_verified'];
        /* update page */
        $db->query(sprintf("UPDATE pages SET page_category = %s, page_name = %s, page_title = %s, page_tips_enabled = %s, page_messages_enabled = %s, page_verified = %s WHERE page_id = %s", secure($args['category'], 'int'), secure($args['username']), secure($args['title']), secure($args['page_tips_enabled']), secure($args['page_messages_enabled']), secure($args['page_verified']), secure($page_id, 'int')));
        break;

      case 'info':
        /* validate country */
        if ($args['country'] == "none") {
          throw new Exception(__("You must select valid country"));
        } else {
          if (!$this->check_country($args['country'])) {
            throw new Exception(__("You must select valid country"));
          }
        }
        /* validate language */
        if ($args['language'] == "none") {
          throw new Exception(__("You must select valid language"));
        } else {
          if (!$this->check_language($args['language'])) {
            throw new Exception(__("You must select valid language"));
          }
        }
        /* validate website */
        if (!is_empty($args['website']) && !valid_url($args['website'])) {
          throw new Exception(__("Please enter a valid website URL"));
        }
        /* validate location */
        $has_coordinates = !is_empty($args['location']) && valid_location($args['latitude'] ?? null, $args['longitude'] ?? null);
        /* set custom fields */
        $this->set_custom_fields($args, "page", "settings", $page_id);
        /* update page */
        $db->query(sprintf(
          "UPDATE pages SET 
            page_company = %s, 
            page_phone = %s, 
            page_website = %s, 
            page_location = %s, 
            page_latitude = %s, 
            page_longitude = %s, 
            page_country = %s, 
            page_language = %s, 
            page_description = %s 
          WHERE page_id = %s",
          secure($args['company']),
          secure($args['phone']),
          secure($args['website']),
          secure($args['location']),
          secure($has_coordinates ? round((float) $args['latitude'], 7) : 'null'),
          secure($has_coordinates ? round((float) $args['longitude'], 7) : 'null'),
          secure($args['country'], 'int'),
          secure($args['language'], 'int'),
          secure($args['description']),
          secure($page_id, 'int')
        ));
        break;

      case 'action':
        /* validate action color */
        if (!in_array($args['action_color'], ['light', 'primary', 'success', 'info', 'warning', 'danger'])) {
          throw new Exception(__("Please select a valid action button color"));
        }
        /* validate action URL */
        if (!is_empty($args['action_url']) && !valid_url($args['action_url'])) {
          throw new Exception(__("Please enter a valid action button URL"));
        }
        /* update page */
        $db->query(sprintf("UPDATE pages SET page_action_text = %s, page_action_color = %s, page_action_url = %s WHERE page_id = %s", secure($args['action_text']), secure($args['action_color']), secure($args['action_url']), secure($page_id, 'int')));
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
        /* validate linkedin */
        if (!is_empty($args['linkedin']) && !valid_url($args['linkedin'])) {
          throw new Exception(__("Please enter a valid Linkedin Profile URL"));
        }
        /* validate vkontakte */
        if (!is_empty($args['vkontakte']) && !valid_url($args['vkontakte'])) {
          throw new Exception(__("Please enter a valid Vkontakte Profile URL"));
        }
        /* update page */
        $db->query(sprintf("UPDATE pages SET page_social_facebook = %s, page_social_twitter = %s, page_social_youtube = %s, page_social_instagram = %s, page_social_linkedin = %s, page_social_vkontakte = %s WHERE page_id = %s", secure($args['facebook']), secure($args['twitter']), secure($args['youtube']), secure($args['instagram']), secure($args['linkedin']), secure($args['vkontakte']), secure($page_id, 'int')));
        break;

      case 'monetization':
        /* prepare */
        $args['page_monetization_enabled'] = (isset($args['page_monetization_enabled'])) ? '1' : '0';
        $args['page_monetization_discount_enabled'] = (isset($args['page_monetization_discount_enabled'])) ? '1' : '0';
        /* validate discount percent */
        if (!is_numeric($args['page_monetization_discount_percent']) || $args['page_monetization_discount_percent'] < 1 || $args['page_monetization_discount_percent'] > 99) {
          throw new Exception(__("Please enter a valid discount percent (min 1, max 99)"));
        }
        /* update page */
        $db->query(
          sprintf(
            "UPDATE pages 
              SET 
                page_monetization_enabled = %s, 
                page_monetization_discount_enabled = %s, 
                page_monetization_discount_percent = %s 
              WHERE page_id = %s",
            secure($args['page_monetization_enabled']),
            secure($args['page_monetization_discount_enabled']),
            secure($args['page_monetization_discount_percent'], 'float'),
            secure($page_id, 'int')
          )
        );
        /* update monetization plans */
        $this->update_monetization_plans($page_id, 'page');
        break;
    }
    return $page['page_name'];
  }


  /**
   * delete_page
   * 
   * @param integer $page_id
   * @return void
   */
  public function delete_page($page_id)
  {
    global $db, $system;
    /* check if pages enabled */
    if (!$system['pages_enabled']) {
      throw new Exception(__("The pages module has been disabled by the admin"));
    }
    /* check pages permission */
    if (!$this->_data['can_create_pages']) {
      throw new Exception(__("You don't have the permission to do this"));
    }
    /* (check&get) page */
    $get_page = $db->query(sprintf("SELECT * FROM pages WHERE page_id = %s", secure($page_id, 'int')));
    if ($get_page->num_rows == 0) {
      _error(403);
    }
    $page = $get_page->fetch_assoc();
    // delete page
    $can_delete = false;
    /* viewer is (admin|moderator) */
    if ($this->_data['user_group'] < 3) {
      $can_delete = true;
    }
    /* viewer is the super admin of page */
    if ($this->_data['user_id'] == $page['page_admin']) {
      $can_delete = true;
    }
    /* check if viewer can delete the page */
    if (!$can_delete) {
      _error(403);
    }
    /* delete the page */
    $db->query(sprintf("DELETE FROM pages WHERE page_id = %s", secure($page_id, 'int')));
    /* delete the page translations */
    $this->delete_translations('page', $page_id);
    /* delete the page members */
    $db->query(sprintf("DELETE FROM pages_likes WHERE page_id = %s", secure($page_id, 'int')));
    /* delete the page admins */
    $db->query(sprintf("DELETE FROM pages_admins WHERE page_id = %s", secure($page_id, 'int')));
    /* delete the page shortcuts */
    $this->delete_shortcuts($page_id, 'page');
    /* delete the page events */
    $db->query(sprintf("DELETE FROM `events` WHERE event_page_id = %s", secure($page_id, 'int')));
    /* delete the page conversations */
    $this->delete_page_conversations($page_id);
  }


  /**
   * get_page_admins_ids
   * 
   * @param integer $page_id
   * @return array
   */
  public function get_page_admins_ids($page_id)
  {
    global $db;
    /* many posts on one page share the same page (reset by connect() and on every call in socket servers) */
    if (!defined('SOCKET_SERVER') && isset($this->_connections_ids['page_admins'][$page_id])) {
      return $this->_connections_ids['page_admins'][$page_id];
    }
    $admins = [];
    $get_admins = $db->query(sprintf("SELECT user_id FROM pages_admins WHERE page_id = %s", secure($page_id, 'int')));
    if ($get_admins->num_rows > 0) {
      while ($admin = $get_admins->fetch_assoc()) {
        $admins[] = $admin['user_id'];
      }
    }
    return $this->_connections_ids['page_admins'][$page_id] = $admins;
  }


  /**
   * get_page_admins
   * 
   * @param integer $page_id
   * @param integer $offset
   * @return array
   */
  public function get_page_admins($page_id, $offset = 0, $cursor = null)
  {
    global $db, $system;
    $admins = [];
    $offset *= $system['max_results_even'];
    /* newest first; pages after the first continue from a cursor (the last admin id) instead of an offset */
    $this->_cursor = null;
    $cursor = cursor_decode($cursor, ['int']);
    $cursor_statement = ($cursor) ? " AND " . cursor_where(['pages_admins.user_id'], $cursor) : "";
    $limit_statement = ($cursor) ? sprintf("LIMIT %s", secure($system['max_results_even'], 'int', false)) : sprintf("LIMIT %s, %s", secure($offset, 'int', false), secure($system['max_results_even'], 'int', false));
    $get_admins = $db->query(sprintf("SELECT pages_admins.user_id AS `cursor`, users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, users.user_subscribed, packages.name as package_name, users.user_verified FROM pages_admins INNER JOIN users ON pages_admins.user_id = users.user_id LEFT JOIN packages ON users.user_subscribed = '1' AND users.user_package = packages.package_id WHERE pages_admins.page_id = %s" . $cursor_statement . " ORDER BY pages_admins.user_id DESC " . $limit_statement, secure($page_id, 'int')));
    [$get_admins, $next_cursor] = cursor_result($get_admins);
    if ($get_admins->num_rows > 0) {
      while ($admin = $get_admins->fetch_assoc()) {
        $admin['user_picture'] = get_picture($admin['user_picture'], $admin['user_gender']);
        /* get the connection */
        $admin['i_admin'] = true;
        $admin['connection'] = 'page_manage';
        $admin['node_id'] = $page_id;
        $admins[] = $admin;
      }
    }
    $this->_cursor = $next_cursor ?? null;
    return $admins;
  }


  /**
   * get_page_members
   * 
   * @param integer $page_id
   * @param integer $offset
   * @return array
   */
  public function get_page_members($page_id, $offset = 0, $cursor = null)
  {
    global $db, $system;
    $members = [];
    $offset *= $system['max_results_even'];
    /* newest accounts first; pages after the first continue from a cursor (the member id) instead of an offset */
    $this->_cursor = null;
    $cursor = cursor_decode($cursor, ['int']);
    $cursor_statement = ($cursor) ? " AND " . cursor_where(['pages_likes.user_id'], $cursor) : "";
    $limit_statement = ($cursor) ? sprintf("LIMIT %s", secure($system['max_results_even'], 'int', false)) : sprintf("LIMIT %s, %s", secure($offset, 'int', false), secure($system['max_results_even'], 'int', false));
    $get_members = $db->query(sprintf("SELECT pages_likes.user_id AS `cursor`, users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, users.user_subscribed, packages.name as package_name, users.user_verified FROM pages_likes INNER JOIN users ON pages_likes.user_id = users.user_id LEFT JOIN packages ON users.user_subscribed = '1' AND users.user_package = packages.package_id WHERE pages_likes.page_id = %s" . $cursor_statement . " ORDER BY pages_likes.user_id DESC " . $limit_statement, secure($page_id, 'int')));
    [$get_members, $next_cursor] = cursor_result($get_members);
    if ($get_members->num_rows > 0) {
      /* get page admins ids */
      $page_admins_ids = $this->get_page_admins_ids($page_id);
      while ($member = $get_members->fetch_assoc()) {
        $member['user_picture'] = get_picture($member['user_picture'], $member['user_gender']);
        /* get the connection */
        $member['i_admin'] = in_array($member['user_id'], $page_admins_ids);
        $member['connection'] = 'page_manage';
        $member['node_id'] = $page_id;
        $members[] = $member;
      }
    }
    $this->_cursor = $next_cursor;
    return $members;
  }


  /**
   * get_page_members_ids
   * 
   * @param integer $page_id
   * @return array
   */
  public function get_page_members_ids($page_id)
  {
    global $db;
    $members = [];
    $get_members = $db->query(sprintf("SELECT user_id FROM pages_likes WHERE page_id = %s", secure($page_id, 'int')));
    if ($get_members->num_rows > 0) {
      while ($member = $get_members->fetch_assoc()) {
        $members[] = $member['user_id'];
      }
    }
    return $members;
  }


  /**
   * get_page_invites
   * 
   * @param integer $page_id
   * @param integer $offset
   * @return array
   */
  public function get_page_invites($page_id, $offset = 0, $cursor = null)
  {
    global $db, $system;
    $friends = [];
    $offset *= $system['max_results_even'];
    /* newest first; pages after the first continue from a cursor (the last user id) instead of an offset */
    $this->_cursor = null;
    $cursor = cursor_decode($cursor, ['int']);
    $cursor_statement = ($cursor) ? " AND " . cursor_where(['users.user_id'], $cursor) : "";
    $limit_statement = ($cursor) ? sprintf("LIMIT %s", secure($system['max_results_even'], 'int', false)) : sprintf("LIMIT %s, %s", secure($offset, 'int', false), secure($system['max_results_even'], 'int', false));
    $get_friends = $db->query(sprintf("SELECT users.user_id AS `cursor`, users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, users.user_subscribed, packages.name as package_name, users.user_verified FROM users LEFT JOIN pages_likes ON users.user_id = pages_likes.user_id AND pages_likes.page_id = %s LEFT JOIN pages_invites ON users.user_id = pages_invites.user_id AND pages_invites.page_id = %s AND pages_invites.from_user_id = %s LEFT JOIN packages ON users.user_subscribed = '1' AND users.user_package = packages.package_id WHERE users.user_id IN (%s) AND pages_likes.id IS NULL AND pages_invites.id IS NULL" . $cursor_statement . " ORDER BY users.user_id DESC " . $limit_statement, secure($page_id, 'int'), secure($page_id, 'int'), secure($this->_data['user_id'], 'int'), $this->spread_ids($this->friends_ids())));
    [$get_friends, $next_cursor] = cursor_result($get_friends);
    while ($friend = $get_friends->fetch_assoc()) {
      $friend['user_picture'] = get_picture($friend['user_picture'], $friend['user_gender']);
      $friend['connection'] = 'page_invite';
      $friend['node_id'] = $page_id;
      $friends[] = $friend;
    }
    $this->_cursor = $next_cursor ?? null;
    return $friends;
  }


  /**
   * check_page_adminship
   * 
   * @param integer $user_id
   * @param integer $page_id
   * @return boolean
   */
  public function check_page_adminship($user_id, $page_id)
  {
    if ($this->_logged_in && $page_id) {
      /* get page admins ids */
      $page_admins_ids = $this->get_page_admins_ids($page_id);
      if (in_array($user_id, $page_admins_ids)) {
        return true;
      }
    }
    return false;
  }


  /**
   * check_page_membership
   * 
   * @param integer $user_id
   * @param integer $page_id
   * @return boolean
   */
  public function check_page_membership($user_id, $page_id)
  {
    global $db;
    /* loaded with its list by preload_memberships() */
    if ($this->_logged_in && $user_id == $this->_data['user_id'] && isset($this->_connections_ids['page_likes']) && array_key_exists((int) $page_id, $this->_connections_ids['page_likes'])) {
      return $this->_connections_ids['page_likes'][(int) $page_id];
    }
    if ($this->_logged_in) {
      $get_likes = $db->query(sprintf("SELECT COUNT(*) as count FROM pages_likes WHERE user_id = %s AND page_id = %s", secure($user_id, 'int'), secure($page_id, 'int')));
      if ($get_likes->fetch_assoc()['count'] > 0) {
        return true;
      }
    }
    return false;
  }


  /**
   * generate_pbid
   * 
   * @param integer $country
   * @param integer $category
   * @param integer $id
   * @return string
   */
  public function generate_pbid($country, $category, $id)
  {
    /* country code 4 digits */
    $country = str_pad($country, 4, "0", STR_PAD_LEFT);
    /* category code 4 digits */
    $category = str_pad($category, 4, "0", STR_PAD_LEFT);
    /* id code 8 digits */
    $id = str_pad($id, 8, "0", STR_PAD_LEFT);
    return $country . $category . $id;
  }
}
