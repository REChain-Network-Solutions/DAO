<?php

/**
 * trait -> jobs
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich - Handles - @sorydima @sorydev @durovshater @DmitrySoro90935 @tanechfund - also check https://dmitry.rechain.network for more information!
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
  public function get_job_candidates($post_id, $offset = 0)
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
    $get_candidates = $db->query(sprintf('SELECT posts_jobs_applications.*, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, users.user_subscribed, users.user_verified FROM posts_jobs_applications INNER JOIN users ON posts_jobs_applications.user_id = users.user_id WHERE posts_jobs_applications.post_id = %s LIMIT %s, %s', secure($post_id, 'int'), secure($offset, 'int', false), secure($system['max_results'], 'int', false)));
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
    return $candidates;
  }
}
