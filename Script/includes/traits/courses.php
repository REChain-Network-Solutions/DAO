<?php

/**
 * trait -> courses
 * 
 * @package Sngine
 * @author Zamblek
 */

trait CoursesTrait
{

  /* ------------------------------- */
  /* Courses */
  /* ------------------------------- */

  /**
   * check_user_course_application
   * 
   * @param integer $post_id
   * @return boolean
   */
  public function check_user_course_application($post_id)
  {
    global $db;
    $check_application = $db->query(sprintf("SELECT COUNT(*) as count FROM posts_courses_applications WHERE post_id = %s AND user_id = %s", secure($post_id, 'int'), secure($this->_data['user_id'], 'int')));
    if ($check_application->fetch_assoc()['count'] > 0) {
      return true;
    }
    return false;
  }


  /**
   * send_course_application
   * 
   * @param array $post
   * @param array $args
   * @return void
   */
  public function send_course_application($post, $args = [])
  {
    global $db, $date;
    /* insert course application */
    $db->query(sprintf("INSERT INTO posts_courses_applications (post_id, user_id, name, location, phone, email, applied_time) VALUES (%s, %s, %s, %s, %s, %s, %s)", secure($post['post_id'], 'int'), secure($this->_data['user_id'], 'int'), secure($args['name']), secure($args['location']), secure($args['phone']), secure($args['email']), secure($date)));
    $application_id = $db->insert_id;
    /* send notification to post author */
    $this->post_notification(['to_user_id' => $post['author_id'], 'action' => 'course_application', 'node_type' => ($post['page_title']) ? $post['page_title'] : '', 'node_url' => $post['post_id']]);
  }


  /**
   * get_total_course_candidates
   * 
   * @param integer $post_id
   * @return integer
   */
  public function get_total_course_candidates($post_id)
  {
    global $db;
    $get_candidates = $db->query(sprintf("SELECT COUNT(*) as count FROM posts_courses_applications WHERE post_id = %s", secure($post_id, 'int')));
    return $get_candidates->fetch_assoc()['count'];
  }


  /**
   * get_course_candidates
   * 
   * @param integer $post_id
   * @param integer $offset
   * @return array
   */
  public function get_course_candidates($post_id, $offset = 0, $cursor = null)
  {
    global $db, $system;
    /* (check|get) post */
    $post = $this->get_post($post_id, false);
    if (!$post || $post['post_type'] != 'course' || !$post['can_get_details'] || empty($post['course'])) {
      _error(403);
    }
    /* check if viewer can edit post */
    if (!$post['manage_post']) {
      _error(403);
    }
    $candidates = [];
    $offset *= $system['max_results'];
    /* newest first; pages after the first continue from a cursor (the last application) instead of an offset */
    $this->_cursor = null;
    $cursor = cursor_decode($cursor, ['int']);
    $cursor_statement = ($cursor) ? " AND " . cursor_where(['posts_courses_applications.application_id'], $cursor) : "";
    $limit_statement = ($cursor) ? sprintf("LIMIT %s", secure($system['max_results'], 'int', false)) : sprintf("LIMIT %s, %s", secure($offset, 'int', false), secure($system['max_results'], 'int', false));
    $get_candidates = $db->query(sprintf('SELECT posts_courses_applications.application_id AS `cursor`, posts_courses_applications.*, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, users.user_subscribed, packages.name as package_name, users.user_verified FROM posts_courses_applications INNER JOIN users ON posts_courses_applications.user_id = users.user_id LEFT JOIN packages ON users.user_subscribed = "1" AND users.user_package = packages.package_id WHERE posts_courses_applications.post_id = %s' . $cursor_statement . ' ORDER BY posts_courses_applications.application_id DESC ' . $limit_statement, secure($post_id, 'int')));
    [$get_candidates, $next_cursor] = cursor_result($get_candidates);
    if ($get_candidates->num_rows > 0) {
      while ($candidate = $get_candidates->fetch_assoc()) {
        $candidate['user_picture'] = get_picture($candidate['user_picture'], $candidate['user_gender']);
        $candidates[] = $candidate;
      }
    }
    $this->_cursor = $next_cursor ?? null;
    return $candidates;
  }


  /**
   * get_promoted_courses
   * 
   * @return array
   */
  public function get_promoted_courses()
  {
    return $this->get_promoted_posts('course', 'posts_courses', ['available' => true]);
  }


  /**
   * get_courses
   * 
   * @param array $args
   * @return array
   */
  public function get_courses($args = [])
  {
    global $db, $system;
    $category = $args['category'] ?? null;
    $query = $args['query'] ?? null;
    $managed = !empty($args['managed']);
    $user_id = $args['user_id'] ?? null;
    $sort = $args['sort'] ?? '';
    $country = $args['country'] ?? null;
    $distance = null;
    $order_query = "";
    $country_query = "";
    $where_query = "";
    $selected_country = null;
    $url = $args['url'] ?? '';

    if ($query) {
      $where_query .= " AND " . $this->posts_search_clause($query, sprintf('(posts.text LIKE %1$s OR posts_courses.title LIKE %1$s)', secure($query, 'search')));
    }
    if ($category) {
      $where_query .= sprintf("AND posts_courses.category_id = %s", secure($category, 'int'));
    }
    if ($user_id) {
      $where_query .= sprintf(" AND posts.user_type = 'user' AND posts.user_id = %s", secure($user_id, 'int'));
    }

    if ($this->_logged_in && $system['location_finder_enabled'] && isset($args['distance']) && is_numeric($args['distance'])) {
      $distance = ($args['distance'] && is_numeric($args['distance']) && $args['distance'] > 0) ? $args['distance'] : 25;
    }

    $order_query .= ($order_query) ? "," : " ORDER BY ";
    switch ($sort) {
      case '':
      case 'latest':
        $order_query .= " posts.post_id DESC ";
        break;

      case 'price-high':
        $order_query .= " posts_courses.fees DESC ";
        break;

      case 'price-low':
        $order_query .= " posts_courses.fees ASC ";
        break;

      default:
        _error(404);
        break;
    }

    if ($system['newsfeed_location_filter_enabled'] && $country && $country != "all") {
      $selected_country = $this->get_country_by_name($country);
      if ($selected_country) {
        $country_query .= sprintf(" AND ( (posts.user_type = 'user' AND user_post_author.user_country = %s) OR (posts.user_type = 'page' AND page_post_author.page_country = %s) )", secure($selected_country['country_id'], 'int'), secure($selected_country['country_id'], 'int'));
      }
    }

    require_once(ABSPATH . 'includes/class-pager.php');
    $params['selected_page'] = (!isset($args['page']) || (int) $args['page'] == 0) ? 1 : $args['page'];
    $author_join = " LEFT JOIN users AS user_post_author ON posts.user_type = 'user' AND posts.user_id = user_post_author.user_id AND user_post_author.user_banned = '0' LEFT JOIN pages AS page_post_author ON posts.user_type = 'page' AND posts.user_id = page_post_author.page_id ";
    $approval_query = ($managed) ? "" : " AND (posts.pre_approved = '1' OR posts.has_approved = '1')";
    $available_query = ($managed) ? "" : " AND posts_courses.available = '1'";
    $from_query = " FROM posts INNER JOIN posts_courses ON posts.post_id = posts_courses.post_id " . $author_join . " WHERE posts.in_group = '0' AND posts.in_event = '0'" . $available_query . $approval_query . $where_query . $country_query;
    /* around the viewer when a distance is set */
    $listing_ids = ($distance) ? $this->get_nearby_listing_ids('course', $distance, $from_query, $order_query) : null;
    $params['total_items'] = ($listing_ids !== null) ? count($listing_ids) : $db->query("SELECT COUNT(*) as count" . $from_query)->fetch_assoc()['count'];
    $params['items_per_page'] = $system['courses_results'];
    $params['url'] = $system['system_url'] . '/courses' . $url . '/%s';
    if (isset($selected_country)) {
      $params['url'] .= "?country=" . $selected_country['country_name'];
    }
    if (isset($args['distance'])) {
      $params['url'] .= ($selected_country) ? "&" : "?";
      $params['url'] .= "distance=" . $args['distance'];
    }
    if (isset($args['sort']) && $args['sort'] !== '') {
      $params['url'] .= ($selected_country || $distance) ? "&" : "?";
      $params['url'] .= "sort=" . $args['sort'];
    }
    $pager = new Pager($params);
    $limit_query = $pager->getLimitSql();

    $rows = [];
    if ($listing_ids !== null) {
      $posts_ids = array_slice($listing_ids, $pager->getOffset(), $params['items_per_page']);
    } else {
      $posts_ids = array_column($db->query("SELECT posts.post_id" . $from_query . $order_query . $limit_query)->fetch_all(MYSQLI_ASSOC), 'post_id');
    }
    foreach ($posts_ids as $post_id) {
      $row = $this->get_post($post_id);
      if ($row) {
        $rows[] = $row;
      }
    }

    return [
      'rows' => $rows,
      'total' => $params['total_items'],
      'pager' => $pager->getPager(),
      'sort' => $sort,
      'distance' => ($distance) ? htmlentities($distance, ENT_QUOTES, 'utf-8') : '',
      'selected_country' => $selected_country,
    ];
  }
}
