<?php

/**
 * trait -> search
 * 
 * @package Sngine
 * @author Zamblek
 */

trait SearchTrait
{

  /* ------------------------------- */
  /* Search */
  /* ------------------------------- */

  /**
   * search
   * 
   * @param string $query
   * @param string $tab
   * @param string $data_type
   * @param integer $offset
   * @return array
   */
  public function search($query, $tab, $data_type = null, $offset = 0)
  {
    global $db, $system;
    $results = [];
    /* check hashtag */
    $hashtag = (mb_substr($query, 0, 1, 'UTF-8') == '#');
    if ($hashtag) {
      $query = mb_substr($query, 1, null, 'UTF-8');
    }
    if ($tab != "posts") {
      $offset *= $system['search_results'];
    }
    switch ($tab) {
      case 'posts':
        /* search posts */
        $results = $this->get_posts(['query' => $query, 'hashtag' => $hashtag, 'filter' => $data_type, 'offset' => $offset]);
        break;

      case 'users':
        /* search users */
        $get_users = $db->query(sprintf('SELECT user_id, user_name, user_firstname, user_lastname, user_gender, user_picture, user_subscribed, packages.name as package_name, user_verified FROM users LEFT JOIN packages ON users.user_subscribed = "1" AND users.user_package = packages.package_id WHERE user_banned = "0" AND user_incognito_enabled = "0" AND (user_name LIKE %1$s OR user_firstname LIKE %1$s OR user_lastname LIKE %1$s OR CONCAT(user_firstname,  " ", user_lastname) LIKE %1$s) ORDER BY user_firstname ASC LIMIT %2$s, %3$s', secure($query, 'search'), secure($offset, 'int', false), secure($system['search_results'], 'int', false)));
        if ($get_users->num_rows > 0) {
          while ($user = $get_users->fetch_assoc()) {
            $user['user_picture'] = get_picture($user['user_picture'], $user['user_gender']);
            /* get the connection between the viewer & the target */
            $user['connection'] = $this->connection($user['user_id']);
            /* get mutual friends */
            if ($this->_logged_in && $user['user_id'] != $this->_data['user_id']) {
              $mutual_friends = $this->get_mutual_friends_preview($user['user_id']);
              $user['mutual_friends_count'] = $mutual_friends['count'];
              $user['mutual_friends'] = $mutual_friends['friends'];
            }
            $results[] = $user;
          }
        }
        break;

      case 'pages':
        /* search pages */
        if ($system['pages_enabled']) {
          $get_pages = $db->query(sprintf('SELECT * FROM pages WHERE page_name LIKE %1$s OR page_title LIKE %1$s ORDER BY page_title ASC LIMIT %2$s, %3$s', secure($query, 'search'), secure($offset, 'int', false), secure($system['search_results'], 'int', false)));
          if ($get_pages->num_rows > 0) {
            while ($page = $get_pages->fetch_assoc()) {
              $page['page_picture'] = get_picture($page['page_picture'], 'page');
              /* check if the viewer liked the page */
              $page['i_like'] = $this->check_page_membership($this->_data['user_id'], $page['page_id']);
              $results[] = $page;
            }
          }
        }
        break;

      case 'groups':
        /* search groups */
        if ($system['groups_enabled']) {
          $get_groups = $db->query(sprintf('SELECT * FROM `groups` WHERE group_privacy != "secret" AND (group_name LIKE %1$s OR group_title LIKE %1$s) ORDER BY group_title ASC LIMIT %2$s, %3$s', secure($query, 'search'), secure($offset, 'int', false), secure($system['search_results'], 'int', false)));
          if ($get_groups->num_rows > 0) {
            while ($group = $get_groups->fetch_assoc()) {
              $group['group_picture'] = get_picture($group['group_picture'], 'group');
              /* check if the viewer joined the group */
              $group['i_joined'] = $this->check_group_membership($this->_data['user_id'], $group['group_id']);
              $results[] = $group;
            }
          }
        }
        break;

      case 'events':
        /* search events */
        if ($system['events_enabled']) {
          $get_events = $db->query(sprintf('SELECT * FROM `events` WHERE event_privacy != "secret" AND event_title LIKE %1$s ORDER BY event_title ASC LIMIT %2$s, %3$s', secure($query, 'search'), secure($offset, 'int', false), secure($system['search_results'], 'int', false)));
          if ($get_events->num_rows > 0) {
            while ($event = $get_events->fetch_assoc()) {
              $event['event_picture'] = get_picture($event['event_cover'], 'event');
              /* check if the viewer joined the event */
              $event['i_joined'] = $this->check_event_membership($this->_data['user_id'], $event['event_id']);
              $results[] = $event;
            }
          }
        }
        break;
    }
    return $results;
  }


  /**
   * search_quick
   * 
   * @param string $query
   * @return array
   */
  public function search_quick($query)
  {
    global $db, $system;
    $results = [];
    /* search users */
    $get_users = $db->query(sprintf('SELECT user_id, user_name, user_firstname, user_lastname, user_gender, user_picture, user_subscribed, packages.name as package_name, user_verified FROM users LEFT JOIN packages ON users.user_subscribed = "1" AND users.user_package = packages.package_id WHERE user_banned = "0" AND user_incognito_enabled = "0" AND (user_name LIKE %1$s OR user_firstname LIKE %1$s OR user_lastname LIKE %1$s OR CONCAT(user_firstname,  " ", user_lastname) LIKE %1$s) LIMIT %2$s', secure($query, 'search'), secure($system['min_results'], 'int', false)));
    if ($get_users->num_rows > 0) {
      while ($user = $get_users->fetch_assoc()) {
        $user['user_picture'] = get_picture($user['user_picture'], $user['user_gender']);
        /* get the connection between the viewer & the target */
        $user['connection'] = $this->connection($user['user_id']);
        $user['sort'] = ($system['show_usernames_enabled']) ? $user['user_name'] : $user['user_firstname'];
        $user['type'] = 'user';
        $results[] = $user;
      }
    }
    /* search pages */
    if ($system['pages_enabled']) {
      $get_pages = $db->query(sprintf('SELECT * FROM pages WHERE page_name LIKE %1$s OR page_title LIKE %1$s LIMIT %2$s', secure($query, 'search'), secure($system['min_results'], 'int', false)));
      if ($get_pages->num_rows > 0) {
        while ($page = $get_pages->fetch_assoc()) {
          $page['page_picture'] = get_picture($page['page_picture'], 'page');
          /* check if the viewer liked the page */
          $page['i_like'] = $this->check_page_membership($this->_data['user_id'], $page['page_id']);
          $page['sort'] = $page['page_title'];
          $page['type'] = 'page';
          $results[] = $page;
        }
      }
    }
    /* search groups */
    if ($system['groups_enabled']) {
      $get_groups = $db->query(sprintf('SELECT * FROM `groups` WHERE group_privacy != "secret" AND (group_name LIKE %1$s OR group_title LIKE %1$s) LIMIT %2$s', secure($query, 'search'), secure($system['min_results'], 'int', false)));
      if ($get_groups->num_rows > 0) {
        while ($group = $get_groups->fetch_assoc()) {
          $group['group_picture'] = get_picture($group['group_picture'], 'group');
          /* check if the viewer joined the group */
          $group['i_joined'] = $this->check_group_membership($this->_data['user_id'], $group['group_id']);
          $group['sort'] = $group['group_title'];
          $group['type'] = 'group';
          $results[] = $group;
        }
      }
    }
    /* search events */
    if ($system['events_enabled']) {
      $get_events = $db->query(sprintf('SELECT * FROM `events` WHERE event_privacy != "secret" AND event_title LIKE %1$s LIMIT %2$s', secure($query, 'search'), secure($system['min_results'], 'int', false)));
      if ($get_events->num_rows > 0) {
        while ($event = $get_events->fetch_assoc()) {
          $event['event_picture'] = get_picture($event['event_cover'], 'event');
          /* check if the viewer joined the event */
          $event['i_joined'] = $this->check_event_membership($this->_data['user_id'], $event['event_id']);
          $event['sort'] = $event['event_title'];
          $event['type'] = 'event';
          $results[] = $event;
        }
      }
    }
    /* sort results (users, pages, groups then events, each by name) */
    $type_order = ['user' => 0, 'page' => 1, 'group' => 2, 'event' => 3];
    usort($results, function ($a, $b) use ($type_order) {
      $left = $type_order[$a['type']] ?? 9;
      $right = $type_order[$b['type']] ?? 9;
      if ($left !== $right) {
        return $left - $right;
      }
      return strcmp($a['sort'] ?? '', $b['sort'] ?? '');
    });
    return $results;
  }


  /**
   * get_people_search_filters
   *
   * @param array $input
   * @return array
   */
  public function get_people_search_filters($input)
  {
    if (!is_array($input)) {
      throw new BadRequestException(__("Invalid search filters"));
    }
    $filters = [
      'distance_value' => 5000,
      'query' => '',
      'city' => '',
      'country' => 'none',
      'gender' => 'any',
      'relationship' => 'any',
      'online_status' => 'any',
      'verified_status' => 'any'
    ];
    foreach ($filters as $key => $default) {
      if (isset($input[$key])) {
        if (!is_scalar($input[$key])) {
          throw new BadRequestException(__("Invalid search filters"));
        }
        $filters[$key] = $input[$key];
      }
    }
    foreach ($this->get_custom_fields(['get' => 'search']) as $field) {
      $key = 'fld_' . $field['field_id'];
      if (!isset($input[$key])) {
        continue;
      }
      $value = $input[$key];
      if ($field['type'] == 'multipleselectbox') {
        if (!is_array($value)) {
          throw new BadRequestException(__("Invalid search filters"));
        }
        foreach ($value as $option) {
          if (!is_scalar($option)) {
            throw new BadRequestException(__("Invalid search filters"));
          }
        }
        $value = array_values($value);
      } elseif (!is_scalar($value)) {
        throw new BadRequestException(__("Invalid search filters"));
      }
      $filters[$key] = $value;
    }
    return $filters;
  }


  /**
   * search_users
   * 
   * @param string $distance
   * @param string $query
   * @param string $city
   * @param string $country
   * @param string $gender
   * @param string $relationship
   * @param string $online_status
   * @param string $verified_status
   * @param integer $offset
   * @param array $custom_fields
   * @return array
   */
  public function search_users($distance, $query, $city, $country, $gender, $relationship, $online_status, $verified_status, $offset = 0, $custom_fields = [], $cursor = null)
  {
    global $db, $system;
    $results = [];
    $this->_cursor = null;
    $next_cursor = null;
    $people_results = $system['people_results'] ?? $system['max_results'];
    /* validate offset */
    $offset = filter_var($offset, FILTER_VALIDATE_INT, ['options' => ['min_range' => 0, 'max_range' => intdiv(PHP_INT_MAX, max(1, (int) $people_results))]]);
    if ($offset === false) {
      throw new BadRequestException(__("Invalid offset"));
    }
    $offset *= $people_results;
    /* validate gender */
    if ($gender != "any" && !$this->check_gender($gender)) {
      return $results;
    }
    /* validate relationship */
    if (isset($relationship) && !in_array($relationship, ['any', 'single', 'relationship', 'married', "complicated", 'separated', 'divorced', 'widowed'])) {
      return $results;
    }
    /* validate country */
    if (isset($country) && $country != "none" && !$this->check_country($country)) {
      return $results;
    }
    /* validate online status */
    if (!in_array($online_status, ['any', 'online', 'offline'])) {
      return $results;
    }
    /* validate verified status */
    if (!in_array($verified_status, ['any', 'verified', 'unverified'])) {
      return $results;
    }
    // prepare where statement
    $where = "";
    /* exclude the viewer & banned users */
    $where .= sprintf("WHERE users.user_id != '1' AND users.user_banned = '0' AND users.user_suggestions_hidden = '0' AND user_incognito_enabled = '0' AND users.user_id != %s", secure($this->_data['user_id'], 'int'));
    /* exclude unactivated users if activation enabled */
    if ($system['activation_enabled']) {
      $where .= " AND users.user_activated = '1'";
    }
    /* query */
    if ($query) {
      $where .= sprintf(' AND (user_name LIKE %1$s OR user_firstname LIKE %1$s OR user_lastname LIKE %1$s OR CONCAT(user_firstname,  " ", user_lastname) LIKE %1$s)', secure($query, 'search'));
    }
    /* city */
    if ($city) {
      $where .= sprintf(" AND user_current_city = %s", secure($city));
    }
    /* country */
    if (isset($country) && $country != "none") {
      $where .= sprintf(" AND user_country = %s", secure($country));
    }
    /* gender */
    if ($gender != "any") {
      $where .= sprintf(" AND users.user_gender = %s", secure($gender, 'int'));
    }
    /* relationship */
    if (isset($relationship) && $relationship != "any") {
      $where .= sprintf(" AND users.user_relationship = %s", secure($relationship));
    }
    /* online status */
    if ($online_status != "any") {
      if ($online_status == "online") {
        $where .= sprintf(" AND user_last_seen >= SUBTIME(NOW(), SEC_TO_TIME(%s))", secure($system['offline_time'], 'int', false));
      } else {
        $where .= sprintf(" AND user_last_seen < SUBTIME(NOW(), SEC_TO_TIME(%s))", secure($system['offline_time'], 'int', false));
      }
    }
    /* verified status */
    if ($verified_status != "any") {
      $where .= ($verified_status == "verified") ? " AND user_verified = '1'" : " AND user_verified = '0'";
    }
    /* custom fields */
    $join_query = "";
    $distinct_query = "";
    $custom_fields_query = $this->search_custom_fields($custom_fields);
    if ($custom_fields_query) {
      $where .= " AND " . $custom_fields_query;
    }
    /* build query */
    if ($system['location_finder_enabled'] && valid_location($this->_data['user_latitude'] ?? null, $this->_data['user_longitude'] ?? null)) {
      /* validate distance */
      $distance = ($distance && is_numeric($distance) && $distance > 0) ? $distance : 25;
      /* the nearest people */
      $get_users = new PrefetchedResult($this->get_nearby_people($where, $distance, $offset, $people_results, $join_query));
    } else {
      /* prepare query */
      /* pages after the first continue from a cursor (the last user id) instead of an offset */
      $cursor = cursor_decode($cursor, ['int']);
      if ($cursor) {
        $where .= " AND " . cursor_where(['users.user_id'], $cursor, false);
        $offset = 0;
      }
      $query = "SELECT " . $distinct_query . " users.user_id AS `cursor`, user_id, user_name, user_firstname, user_lastname, user_gender, user_picture, user_subscribed, packages.name as package_name, user_verified FROM users LEFT JOIN packages ON users.user_subscribed = '1' AND users.user_package = packages.package_id ";
      $query .= $join_query;
      $query .= $where;
      $query .= sprintf(" ORDER BY users.user_id ASC LIMIT %s, %s", secure($offset, 'int', false), secure($people_results, 'int', false));
      /* get users */
      [$get_users, $next_cursor] = cursor_result($db->query($query));
    }
    if ($get_users->num_rows > 0) {
      while ($user = $get_users->fetch_assoc()) {
        $user['user_picture'] = get_picture($user['user_picture'], $user['user_gender']);
        /* get the connection between the viewer & the target */
        $user['connection'] = $this->connection($user['user_id']);
        /* get mutual friends */
        if ($user['user_id'] != $this->_data['user_id']) {
          $mutual_friends = $this->get_mutual_friends_preview($user['user_id']);
          $user['mutual_friends_count'] = $mutual_friends['count'];
          $user['mutual_friends'] = $mutual_friends['friends'];
        }
        $results[] = $user;
      }
    }
    $this->_cursor = $next_cursor;
    return $results;
  }


  /**
   * get_search_log
   * 
   * @return array
   */
  public function get_search_log()
  {
    global $db, $system;
    $results = [];
    $get_search_log = $db->query(sprintf("SELECT users_searches.log_id, users_searches.node_type, users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, users.user_subscribed, packages.name as package_name, users.user_verified, pages.*, `groups`.*, `events`.* FROM users_searches LEFT JOIN users ON users_searches.node_type = 'user' AND users_searches.node_id = users.user_id LEFT JOIN pages ON users_searches.node_type = 'page' AND users_searches.node_id = pages.page_id LEFT JOIN `groups` ON users_searches.node_type = 'group' AND users_searches.node_id = `groups`.group_id LEFT JOIN `events` ON users_searches.node_type = 'event' AND users_searches.node_id = `events`.event_id LEFT JOIN packages ON users.user_subscribed = '1' AND users.user_package = packages.package_id WHERE users_searches.user_id = %s ORDER BY users_searches.log_id DESC LIMIT %s", secure($this->_data['user_id'], 'int'), secure($system['min_results'], 'int', false)));
    if ($get_search_log->num_rows > 0) {
      while ($result = $get_search_log->fetch_assoc()) {
        switch ($result['node_type']) {
          case 'user':
            $result['user_picture'] = get_picture($result['user_picture'], $result['user_gender']);
            /* get the connection between the viewer & the target */
            $result['connection'] = $this->connection($result['user_id']);
            break;

          case 'page':
            $result['page_picture'] = get_picture($result['page_picture'], 'page');
            /* check if the viewer liked the page */
            $result['i_like'] = $this->check_page_membership($this->_data['user_id'], $result['page_id']);
            break;

          case 'group':
            $result['group_picture'] = get_picture($result['group_picture'], 'group');
            /* check if the viewer joined the group */
            $result['i_joined'] = $this->check_group_membership($this->_data['user_id'], $result['group_id']);
            break;

          case 'event':
            $result['event_picture'] = get_picture($result['event_cover'], 'event');
            /* check if the viewer joined the event */
            $result['i_joined'] = $this->check_event_membership($this->_data['user_id'], $result['event_id']);
            break;
        }
        $result['type'] = $result['node_type'];
        $results[] = $result;
      }
    }
    return $results;
  }


  /**
   * set_search_log
   * 
   * @param integer $node_id
   * @param string $node_type
   * @return void
   */
  public function set_search_log($node_id, $node_type)
  {
    global $db, $date;
    /* check if the search log exists */
    $check_search_log = $db->query(sprintf("SELECT log_id FROM users_searches WHERE user_id = %s AND node_id = %s AND node_type = %s", secure($this->_data['user_id'], 'int'), secure($node_id, 'int'), secure($node_type)));
    if ($check_search_log->num_rows == 0) {
      /* insert the search log */
      $db->query(sprintf("INSERT INTO users_searches (user_id, node_id, node_type, time) VALUES (%s, %s, %s, %s)", secure($this->_data['user_id'], 'int'), secure($node_id, 'int'), secure($node_type), secure($date)));
    }
  }


  /**
   * delete_search_log
   * 
   * @param integer $log_id
   * @return void
   */
  public function delete_search_log($log_id)
  {
    global $db;
    $db->query(sprintf("DELETE FROM users_searches WHERE log_id = %s AND user_id = %s", secure($log_id, 'int'), secure($this->_data['user_id'], 'int')));
  }


  /**
   * clear_search_log
   * 
   * @return void
   */
  public function clear_search_log()
  {
    global $db;
    $db->query(sprintf("DELETE FROM users_searches WHERE user_id = %s", secure($this->_data['user_id'], 'int')));
  }
}
