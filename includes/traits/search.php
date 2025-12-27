<?php

/**
 * trait -> search
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich
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
   * @param integer $offset
   * @return array
   */
  public function search($query, $tab, $offset = 0)
  {
    global $db, $system;
    $results = [];
    if ($tab != "posts") {
      $offset *= $system['search_results'];
    }
    switch ($tab) {
      case 'posts':
        /* search posts */
        $results = $this->get_posts(['query' => $query, 'offset' => $offset]);
        break;

      case 'blogs':
        /* search blogs */
        if ($system['blogs_enabled']) {
          /* check if query is hashtag with _ */
          if (strpos($query, "_") !== false) {
            $query = '+' . str_replace("_", " +", $query);
          }
          $get_blogs = $db->query(sprintf(
            '(SELECT post_id FROM posts_articles
              WHERE MATCH(title) AGAINST(%1$s IN BOOLEAN MODE)
              ORDER BY title ASC LIMIT %2$s, %3$s)
              UNION
              (SELECT post_id FROM posts_articles
              WHERE MATCH(tags) AGAINST(%1$s IN BOOLEAN MODE)
              ORDER BY title ASC LIMIT %2$s, %3$s)',
            secure($query),
            secure($offset, 'int', false),
            secure($system['search_results'], 'int', false)
          ));
          if ($get_blogs->num_rows > 0) {
            while ($blog = $get_blogs->fetch_assoc()) {
              $blog = $this->get_post($blog['post_id']);
              if ($blog) {
                $results[] = $blog;
              }
            }
          }
        }
        break;

      case 'users':
        /* search users */
        $get_users = $db->query(sprintf('SELECT user_id, user_name, user_firstname, user_lastname, user_gender, user_picture, user_subscribed, user_verified FROM users WHERE user_banned = "0" AND (user_name LIKE %1$s OR user_firstname LIKE %1$s OR user_lastname LIKE %1$s OR CONCAT(user_firstname,  " ", user_lastname) LIKE %1$s) ORDER BY user_firstname ASC LIMIT %2$s, %3$s', secure($query, 'search'), secure($offset, 'int', false), secure($system['search_results'], 'int', false)));
        if ($get_users->num_rows > 0) {
          while ($user = $get_users->fetch_assoc()) {
            $user['user_picture'] = get_picture($user['user_picture'], $user['user_gender']);
            /* get the connection between the viewer & the target */
            $user['connection'] = $this->connection($user['user_id']);
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
    $get_users = $db->query(sprintf('SELECT user_id, user_name, user_firstname, user_lastname, user_gender, user_picture, user_subscribed, user_verified FROM users WHERE user_banned = "0" AND (user_name LIKE %1$s OR user_firstname LIKE %1$s OR user_lastname LIKE %1$s OR CONCAT(user_firstname,  " ", user_lastname) LIKE %1$s) LIMIT %2$s', secure($query, 'search'), secure($system['min_results'], 'int', false)));
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
    /* sort results */
    function sort_results($a, $b)
    {
      return strcmp($a["sort"], $b["sort"]);
    }
    usort($results, 'sort_results');
    return $results;
  }


  /**
   * search_users
   * 
   * @param string $distance
   * @param string $query
   * @param string $city
   * @param string $country
   * @param string $country
   * @param string $gender
   * @param string $relationship
   * @param string $online_status
   * @param string verified_status
   * @return array
   */
  public function search_users($distance, $query, $city, $country, $gender, $relationship, $online_status, $verified_status)
  {
    global $db, $system;
    $results = [];
    $offset *= $system['max_results'];
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
    $where .= sprintf("WHERE users.user_id != '1' AND users.user_banned = '0' AND users.user_suggestions_hidden = '0' AND users.user_id != %s", secure($this->_data['user_id'], 'int'));
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
    if ($country != "none") {
      $where .= sprintf(" AND user_country = %s", secure($country));
    }
    /* gender */
    if ($gender != "any") {
      $where .= " AND users.user_gender = '$gender'";
    }
    /* relationship */
    if (isset($relationship) && $relationship != "any") {
      $where .= " AND users.user_relationship = '$relationship'";
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
    $custom_fields_query = $this->search_custom_fields($_POST);
    if ($custom_fields_query) {
      $where .= " AND (" . $custom_fields_query . ")";
      $distinct_query = "DISTINCT";
      $join_query = " LEFT JOIN custom_fields_values AS cfv ON cfv.node_type = 'user' AND cfv.node_id = users.user_id ";
    }
    /* build query */
    if ($system['location_finder_enabled']) {
      /* validate distance */
      $unit = ($system['system_distance'] == "mile") ? 3958 : 6371;
      $distance = ($distance && is_numeric($distance) && $distance > 0) ? $distance : 25;
      /* prepare query */
      $query = sprintf("SELECT " . $distinct_query . " user_id, user_name, user_firstname, user_lastname, user_gender, user_picture, user_subscribed, user_verified, (%s * acos(cos(radians(%s)) * cos(radians(user_latitude)) * cos(radians(user_longitude) - radians(%s)) + sin(radians(%s)) * sin(radians(user_latitude))) ) AS distance FROM users ", secure($unit, 'int'), secure($this->_data['user_latitude']), secure($this->_data['user_longitude']), secure($this->_data['user_latitude']));
      $query .= $join_query;
      $query .= $where;
      $query .= sprintf(" HAVING distance < %s ORDER BY distance ASC LIMIT %s", secure($distance, 'int'), secure($system['max_results'], 'int', false));
    } else {
      /* prepare query */
      $query = "SELECT " . $distinct_query . " user_id, user_name, user_firstname, user_lastname, user_gender, user_picture, user_subscribed, user_verified FROM users ";
      $query .= $join_query;
      $query .= $where;
      $query .= sprintf(" LIMIT %s", secure($system['max_results'], 'int', false));
    }
    /* get users */
    $get_users = $db->query($query);
    if ($get_users->num_rows > 0) {
      while ($user = $get_users->fetch_assoc()) {
        $user['user_picture'] = get_picture($user['user_picture'], $user['user_gender']);
        /* get the connection between the viewer & the target */
        $user['connection'] = $this->connection($user['user_id']);
        $results[] = $user;
      }
    }
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
    $get_search_log = $db->query(sprintf("SELECT users_searches.log_id, users_searches.node_type, users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, users.user_subscribed, users.user_verified, pages.*, `groups`.*, `events`.* FROM users_searches LEFT JOIN users ON users_searches.node_type = 'user' AND users_searches.node_id = users.user_id LEFT JOIN pages ON users_searches.node_type = 'page' AND users_searches.node_id = pages.page_id LEFT JOIN `groups` ON users_searches.node_type = 'group' AND users_searches.node_id = `groups`.group_id LEFT JOIN `events` ON users_searches.node_type = 'event' AND users_searches.node_id = `events`.event_id WHERE users_searches.user_id = %s ORDER BY users_searches.log_id DESC LIMIT %s", secure($this->_data['user_id'], 'int'), secure($system['min_results'], 'int', false)));
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
   * clear_search_log
   * 
   * @return void
   */
  public function clear_search_log()
  {
    global $db, $system;
    $db->query(sprintf("DELETE FROM users_searches WHERE user_id = %s", secure($this->_data['user_id'], 'int')));
  }
}
