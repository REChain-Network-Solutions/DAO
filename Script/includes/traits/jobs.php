<?php

/**
 * trait -> jobs
 * 
 * @package Sngine
 * @author Zamblek
 */

trait JobsTrait
{

  /* ------------------------------- */
  /* Jobs */
  /* ------------------------------- */

  /**
   * check_user_job_application
   * 
   * @param integer $post_id
   * @return boolean
   */
  public function check_user_job_application($post_id)
  {
    global $db;
    $check_application = $db->query(sprintf("SELECT COUNT(*) as count FROM posts_jobs_applications WHERE post_id = %s AND user_id = %s", secure($post_id, 'int'), secure($this->_data['user_id'], 'int')));
    if ($check_application->fetch_assoc()['count'] > 0) {
      return true;
    }
    return false;
  }


  /**
   * send_job_application
   * 
   * @param array $post
   * @param array $args
   * @return void
   */
  public function send_job_application($post, $args = [])
  {
    global $db, $date;
    /* prepare inputs */
    $args['work_now'] = (isset($args['work_now'])) ? '1' : '0';
    /* insert job application */
    $db->query(sprintf("INSERT INTO posts_jobs_applications (post_id, user_id, name, location, phone, email, work_place, work_position, work_description, work_from, work_to, work_now, question_1_answer, question_2_answer, question_3_answer, cv, applied_time) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)", secure($post['post_id'], 'int'), secure($this->_data['user_id'], 'int'), secure($args['name']), secure($args['location']), secure($args['phone']), secure($args['email']), secure($args['work_place']), secure($args['work_position']), secure($args['work_description']), secure($args['work_from']), secure($args['work_to']), secure($args['work_now']), secure($args['question_1_answer']), secure($args['question_2_answer']), secure($args['question_3_answer']), secure($args['cv']), secure($date)));
    $application_id = $db->insert_id;
    /* send notification to post author */
    $this->post_notification(['to_user_id' => $post['author_id'], 'action' => 'job_application', 'node_type' => ($post['page_title']) ? $post['page_title'] : '', 'node_url' => $post['post_id']]);
    /* remove pending uploads */
    remove_pending_uploads([$args['cv']]);
  }


  /**
   * get_total_job_candidates
   * 
   * @param integer $post_id
   * @return integer
   */
  public function get_total_job_candidates($post_id)
  {
    global $db;
    $get_candidates = $db->query(sprintf("SELECT COUNT(*) as count FROM posts_jobs_applications WHERE post_id = %s", secure($post_id, 'int')));
    return $get_candidates->fetch_assoc()['count'];
  }


  /**
   * get_job_candidates
   * 
   * @param integer $post_id
   * @param integer $offset
   * @return array
   */
  public function get_job_candidates($post_id, $offset = 0, $cursor = null)
  {
    global $db, $system;
    /* (check|get) post */
    $post = $this->get_post($post_id, false);
    if (!$post) {
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
    $cursor_statement = ($cursor) ? " AND " . cursor_where(['posts_jobs_applications.application_id'], $cursor) : "";
    $limit_statement = ($cursor) ? sprintf("LIMIT %s", secure($system['max_results'], 'int', false)) : sprintf("LIMIT %s, %s", secure($offset, 'int', false), secure($system['max_results'], 'int', false));
    $get_candidates = $db->query(sprintf('SELECT posts_jobs_applications.application_id AS `cursor`, posts_jobs_applications.*, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, users.user_subscribed, packages.name as package_name, users.user_verified FROM posts_jobs_applications INNER JOIN users ON posts_jobs_applications.user_id = users.user_id LEFT JOIN packages ON users.user_subscribed = "1" AND users.user_package = packages.package_id WHERE posts_jobs_applications.post_id = %s' . $cursor_statement . ' ORDER BY posts_jobs_applications.application_id DESC ' . $limit_statement, secure($post_id, 'int')));
    [$get_candidates, $next_cursor] = cursor_result($get_candidates);
    if ($get_candidates->num_rows > 0) {
      while ($candidate = $get_candidates->fetch_assoc()) {
        $candidate['user_picture'] = get_picture($candidate['user_picture'], $candidate['user_gender']);
        $candidate['question_1_title'] = $post['job']['question_1_title'];
        $candidate['question_1_answer'] = ($post['job']['question_1_type'] != "multiple_choice") ? $candidate['question_1_answer'] : $post['job']['question_1_options'][$candidate['question_1_answer']];
        $candidate['question_2_title'] = $post['job']['question_2_title'];
        $candidate['question_2_answer'] = ($post['job']['question_2_type'] != "multiple_choice") ? $candidate['question_2_answer'] : $post['job']['question_2_options'][$candidate['question_2_answer']];
        $candidate['question_3_title'] = $post['job']['question_3_title'];
        $candidate['question_3_answer'] = ($post['job']['question_3_type'] != "multiple_choice") ? $candidate['question_3_answer'] : $post['job']['question_3_options'][$candidate['question_3_answer']];
        $candidates[] = $candidate;
      }
    }
    $this->_cursor = $next_cursor ?? null;
    return $candidates;
  }


  /**
   * get_promoted_jobs
   * 
   * @return array
   */
  public function get_promoted_jobs()
  {
    return $this->get_promoted_posts('job', 'posts_jobs', ['available' => true]);
  }


  /**
   * get_jobs
   * 
   * @param array $args
   * @return array
   */
  public function get_jobs($args = [])
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
      $where_query .= " AND " . $this->posts_search_clause($query, sprintf('(posts.text LIKE %1$s OR posts_jobs.title LIKE %1$s)', secure($query, 'search')));
    }
    if ($category) {
      $where_query .= sprintf("AND posts_jobs.category_id = %s", secure($category, 'int'));
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

      case 'salary-high':
        $order_query .= " posts_jobs.salary_maximum DESC ";
        break;

      case 'salary-low':
        $order_query .= " posts_jobs.salary_maximum ASC ";
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
    $available_query = ($managed) ? "" : " AND posts_jobs.available = '1'";
    $from_query = " FROM posts INNER JOIN posts_jobs ON posts.post_id = posts_jobs.post_id " . $author_join . " WHERE posts.in_group = '0' AND posts.in_event = '0'" . $available_query . $approval_query . $where_query . $country_query;
    /* around the viewer when a distance is set */
    $listing_ids = ($distance) ? $this->get_nearby_listing_ids('job', $distance, $from_query, $order_query) : null;
    $params['total_items'] = ($listing_ids !== null) ? count($listing_ids) : $db->query("SELECT COUNT(*) as count" . $from_query)->fetch_assoc()['count'];
    $params['items_per_page'] = $system['jobs_results'];
    $params['url'] = $system['system_url'] . '/jobs' . $url . '/%s';
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
