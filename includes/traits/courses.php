<?php

/**
 * trait -> courses
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich - Handles - @sorydima @sorydev @durovshater @DmitrySoro90935 @tanechfund - also check https://dmitry.rechain.network for more information!
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
  public function get_course_candidates($post_id, $offset = 0)
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
    $get_candidates = $db->query(sprintf('SELECT posts_courses_applications.*, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, users.user_subscribed, users.user_verified FROM posts_courses_applications INNER JOIN users ON posts_courses_applications.user_id = users.user_id WHERE posts_courses_applications.post_id = %s LIMIT %s, %s', secure($post_id, 'int'), secure($offset, 'int', false), secure($system['max_results'], 'int', false)));
    if ($get_candidates->num_rows > 0) {
      while ($candidate = $get_candidates->fetch_assoc()) {
        $candidate['user_picture'] = get_picture($candidate['user_picture'], $candidate['user_gender']);
        $candidates[] = $candidate;
      }
    }
    return $candidates;
  }
}
