<?php

/**
 * trait -> reviews
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich - Handles - @sorydima @sorydev @durovshater @DmitrySoro90935 @tanechfund - also check https://dmitry.rechain.network for more information!
 */

trait ReviewsTrait
{

  /* ------------------------------- */
  /* Reviews */
  /* ------------------------------- */

  /**
   * get_reviews
   * 
   * @param integer $node_id
   * @param string $node_type
   * @param integer $offset
   * @return array
   */
  public function get_reviews($node_id, $node_type = 'page', $offset = 0)
  {
    global $system, $db;
    $reviews = [];
    $offset *= $system['max_results_even'];
    /* get reviews */
    switch ($node_type) {
      case 'page':
        $get_reviews = $db->query(sprintf("SELECT reviews.review_id FROM reviews INNER JOIN users ON reviews.user_id = users.user_id INNER JOIN pages ON reviews.node_type = 'page' AND reviews.node_id = pages.page_id WHERE reviews.node_id = %s ORDER BY reviews.review_id DESC LIMIT %s, %s", secure($node_id, 'int'), secure($offset, 'int', false), secure($system['max_results_even'], 'int', false)));
        break;

      case 'group':
        $get_reviews = $db->query(sprintf("SELECT reviews.review_id FROM reviews INNER JOIN users ON reviews.user_id = users.user_id INNER JOIN groups ON reviews.node_type = 'group' AND reviews.node_id = groups.group_id WHERE reviews.node_id = %s ORDER BY reviews.review_id DESC LIMIT %s, %s", secure($node_id, 'int'), secure($offset, 'int', false), secure($system['max_results_even'], 'int', false)));
        break;

      case 'event':
        $get_reviews = $db->query(sprintf("SELECT reviews.review_id FROM reviews INNER JOIN users ON reviews.user_id = users.user_id INNER JOIN events ON reviews.node_type = 'event' AND reviews.node_id = events.event_id WHERE reviews.node_id = %s ORDER BY reviews.review_id DESC LIMIT %s, %s", secure($node_id, 'int'), secure($offset, 'int', false), secure($system['max_results_even'], 'int', false)));
        break;

      case 'post':
        $get_reviews = $db->query(sprintf("SELECT reviews.review_id FROM reviews INNER JOIN users ON reviews.user_id = users.user_id INNER JOIN posts ON reviews.node_type = 'post' AND reviews.node_id = posts.post_id WHERE reviews.node_id = %s ORDER BY reviews.review_id DESC LIMIT %s, %s", secure($node_id, 'int'), secure($offset, 'int', false), secure($system['max_results_even'], 'int', false)));
        break;
    }
    if ($get_reviews->num_rows > 0) {
      while ($review = $get_reviews->fetch_assoc()) {
        $review = $this->get_review($review['review_id']);
        if ($review) {
          $reviews[] = $review;
        }
      }
    }
    return $reviews;
  }


  /**
   * get_reviews_details
   * 
   * @param integer $node_id
   * @param string $node_type
   * @return array
   */
  public function get_reviews_details($node_id, $node_type = 'page')
  {
    global $system, $db;
    /* validate node type */
    if (!in_array($node_type, ['page', 'group', 'event', 'post'])) {
      return false;
    }
    $reviews = [];
    $get_reviews = $db->query(sprintf("SELECT reviews.rate FROM reviews WHERE reviews.node_id = %s AND reviews.node_type = %s", secure($node_id, 'int'), secure($node_type)));
    if ($get_reviews->num_rows > 0) {
      while ($review = $get_reviews->fetch_assoc()) {
        $reviews[] = $review['rate'];
      }
    }
    $reviews_details = [];
    $reviews_details['total'] = count($reviews);
    $reviews_details['average'] = ($reviews_details['total'] > 0) ? round(array_sum($reviews) / $reviews_details['total'], 1) : 0;
    $reviews_details['5_stars']['percentage'] = ($reviews_details['total'] > 0) ? round((count(array_keys($reviews, 5)) / $reviews_details['total']) * 100, 1) : 0;
    $reviews_details['5_stars']['count'] = count(array_keys($reviews, 5));
    $reviews_details['4_stars']['percentage'] = ($reviews_details['total'] > 0) ? round((count(array_keys($reviews, 4)) / $reviews_details['total']) * 100, 1) : 0;
    $reviews_details['4_stars']['count'] = count(array_keys($reviews, 4));
    $reviews_details['3_stars']['percentage'] = ($reviews_details['total'] > 0) ? round((count(array_keys($reviews, 3)) / $reviews_details['total']) * 100, 1) : 0;
    $reviews_details['3_stars']['count'] = count(array_keys($reviews, 3));
    $reviews_details['2_stars']['percentage'] = ($reviews_details['total'] > 0) ? round((count(array_keys($reviews, 2)) / $reviews_details['total']) * 100, 1) : 0;
    $reviews_details['2_stars']['count'] = count(array_keys($reviews, 2));
    $reviews_details['1_stars']['percentage'] = ($reviews_details['total'] > 0) ? round((count(array_keys($reviews, 1)) / $reviews_details['total']) * 100, 1) : 0;
    $reviews_details['1_stars']['count'] = count(array_keys($reviews, 1));
    return $reviews_details;
  }


  /**
   * get_review
   * 
   * @param integer $review_id
   * @return array
   */
  public function get_review($review_id)
  {
    global $db, $system;
    /* get review */
    $get_review = $db->query(sprintf("SELECT reviews.*, users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM reviews INNER JOIN users ON reviews.user_id = users.user_id WHERE reviews.review_id = %s", secure($review_id, 'int')));
    if ($get_review->num_rows == 0) {
      return false;
    }
    $review = $get_review->fetch_assoc();
    switch ($review['node_type']) {
      case 'page':
        $page = $this->get_page($review['node_id']);
        if (!$page) {
          return false;
        }
        $page['page_picture'] = get_picture($page['page_picture'], 'page');
        $review['page'] = $page;
        $review['manage_review'] = ($this->_logged_in && $this->check_page_adminship($this->_data['user_id'], $page['page_id'])) ? true : false;
        break;

      case 'group':
        $group = $this->get_group($review['node_id']);
        if (!$group) {
          return false;
        }
        $group['group_picture'] = get_picture($group['group_picture'], 'group');
        $review['group'] = $group;
        $review['manage_review'] = ($this->_logged_in && $this->check_group_adminship($this->_data['user_id'], $group['group_id'])) ? true : false;
        break;

      case 'event':
        $event = $this->get_event($review['node_id']);
        if (!$event) {
          return false;
        }
        $event['event_picture'] = get_picture($event['event_picture'], 'event');
        $review['event'] = $event;
        $review['manage_review'] = ($this->_logged_in && $this->check_event_adminship($this->_data['user_id'], $event['event_id'])) ? true : false;
        break;

      case 'post':
        $post = $this->get_post($review['node_id']);
        if (!$post) {
          return false;
        }
        $review['post'] = $post;
        $review['manage_review'] = ($this->_logged_in && $this->_data['user_id'] == $post['author_id']) ? true : false;
        break;
    }
    /* get review user */
    $review['user_picture'] = get_picture($review['user_picture'], $review['user_gender']);
    $review['user_fullname'] = ($system['show_usernames_enabled']) ? $review['user_name'] : $review['user_firstname'] . " " . $review['user_lastname'];
    /* get review photos */
    $get_photos = $db->query(sprintf("SELECT * FROM reviews_photos WHERE review_id = %s", secure($review['review_id'], 'int')));
    while ($photo = $get_photos->fetch_assoc()) {
      $review['photos'][] = $photo;
    }
    return $review;
  }


  /**
   * add_review
   * 
   * @param integer $node_id
   * @param string $node_type
   * @param integer $rate
   * @param string $review
   * @param array $photos
   * @return array
   */
  public function add_review($node_id, $node_type, $rate, $review, $photos)
  {
    global $db, $system, $date;
    /* get node */
    switch ($node_type) {
      case 'page':
        /* check if reviews enabled */
        if (!$system['pages_reviews_enabled']) {
          throw new Exception(__("This feature has been disabled by the admin"));
        }
        /* get page */
        $page = $this->get_page($node_id);
        if (!$page) {
          throw new Exception(__("The page you're trying to review doesn't exist"));
        }
        break;

      case 'group':
        /* check if reviews enabled */
        if (!$system['groups_reviews_enabled']) {
          throw new Exception(__("This feature has been disabled by the admin"));
        }
        /* get group */
        $group = $this->get_group($node_id);
        if (!$group) {
          throw new Exception(__("The group you're trying to review doesn't exist"));
        }
        break;

      case 'event':
        /* check if reviews enabled */
        if (!$system['events_reviews_enabled']) {
          throw new Exception(__("This feature has been disabled by the admin"));
        }
        /* get event */
        $event = $this->get_event($node_id);
        if (!$event) {
          throw new Exception(__("The event you're trying to review doesn't exist"));
        }
        break;

      case 'post':
        /* check if reviews enabled */
        if (!$system['posts_reviews_enabled']) {
          throw new Exception(__("This feature has been disabled by the admin"));
        }
        /* get post */
        $post = $this->get_post($node_id);
        if (!$post) {
          throw new Exception(__("The post you're trying to review doesn't exist"));
        }
        break;

      default:
        throw new Exception(__("The node you're trying to review doesn't exist"));
        break;
    }
    /* check if the viewer already reviewed this node before */
    $get_review = $db->query(sprintf("SELECT review_id FROM reviews WHERE user_id = %s AND node_id = %s AND node_type = %s", secure($this->_data['user_id'], 'int'), secure($node_id, 'int'), secure($node_type)));
    if ($get_review->num_rows > 0) {
      switch ($node_type) {
        case 'page':
          if (!$system['pages_reviews_replacement_enabled']) {
            throw new Exception(__("You already reviewed this before"));
          }
          break;

        case 'group':
          if (!$system['groups_reviews_replacement_enabled']) {
            throw new Exception(__("You already reviewed this before"));
          }
          break;

        case 'event':
          if (!$system['events_reviews_replacement_enabled']) {
            throw new Exception(__("You already reviewed this before"));
          }
          break;

        case 'post':
          if (!$system['posts_reviews_replacement_enabled']) {
            throw new Exception(__("You already reviewed this before"));
          }
          break;
      }
      /* delete the old review */
      $this->delete_review($get_review->fetch_assoc()['review_id']);
    }
    switch ($node_type) {
      case 'page':
        /* check if the viewer is the page admin */
        if ($this->check_page_adminship($this->_data['user_id'], $node_id)) {
          throw new Exception(__("You can't review your own page"));
        }
        break;

      case 'group':
        /* check if the viewer is the group admin */
        if ($this->check_group_adminship($this->_data['user_id'], $node_id)) {
          throw new Exception(__("You can't review your own group"));
        }
        break;

      case 'event':
        /* check if the viewer is the event admin */
        if ($this->check_event_adminship($this->_data['user_id'], $node_id)) {
          throw new Exception(__("You can't review your own event"));
        }
        break;

      case 'post':
        /* check if the viewer is the post author */
        if ($this->_data['user_id'] == $post['author_id']) {
          throw new Exception(__("You can't review your own post"));
        }
        break;
    }
    /* validate rate */
    if (!in_array($rate, ['1', '2', '3', '4', '5'])) {
      throw new Exception(__("Please select a valid rate"));
    }
    /* validate review */
    if (!is_empty($review) && strlen($review) > 1000) {
      throw new Exception(__("Your review must be less than 1000 characters"));
    }
    /* validate photos */
    $filtered_photos = [];
    if (isset($photos)) {
      $photos = json_decode($photos);
      if (is_object($photos)) {
        /* filter the photos */
        foreach ($photos as $photo) {
          $filtered_photos[] = (array) $photo;
        }
      }
    }
    /* insert new review */
    $db->query(sprintf("INSERT INTO reviews (user_id, node_id, node_type, rate, review, time) VALUES (%s, %s, %s, %s, %s, %s)", secure($this->_data['user_id'], 'int'), secure($node_id, 'int'), secure($node_type), secure($rate, 'int'), secure($review), secure($date)));
    /* get review_id */
    $review_id = $db->insert_id;
    /* insert review photos */
    if ($filtered_photos) {
      foreach ($filtered_photos as $photo) {
        $db->query(sprintf("INSERT INTO reviews_photos (review_id, source) VALUES (%s, %s)", secure($review_id, 'int'), secure($photo['source'])));
      }
    }
    /* update node rate */
    $this->update_node_rate($node_id, $node_type);
    /* notify the node owner */
    switch ($node_type) {
      case 'page':
        $this->post_notification(['to_user_id' => $page['page_admin'], 'action' => 'page_review', 'node_type' => $page['page_title'], 'node_url' => $page['page_name']]);
        break;

      case 'group':
        $this->post_notification(['to_user_id' => $group['group_admin'], 'action' => 'group_review', 'node_type' => $group['group_title'], 'node_url' => $group['group_name']]);
        break;

      case 'event':
        $this->post_notification(['to_user_id' => $event['event_admin'], 'action' => 'event_review', 'node_type' => $event['event_title'], 'node_url' => $event['event_id']]);
        break;

      case 'post':
        $this->post_notification(['to_user_id' => $post['author_id'], 'action' => 'post_review', 'node_type' => $post['post_text'], 'node_url' => $post['post_id']]);
        break;
    }
    /* return the review */
    return $this->get_review($review_id);
  }


  /**
   * delete_review
   * 
   * @param integer $review_id
   * @return void
   */
  public function delete_review($review_id)
  {
    global $db, $system;
    /* get review */
    $review = $this->get_review($review_id);
    if (!$review) {
      throw new Exception(__("The review you're trying to delete doesn't exist"));
    }
    switch ($review['node_type']) {
      case 'page':
        /* check if reviews enabled */
        if (!$system['pages_reviews_enabled']) {
          throw new Exception(__("This feature has been disabled by the admin"));
        }
        break;

      case 'group':
        /* check if reviews enabled */
        if (!$system['groups_reviews_enabled']) {
          throw new Exception(__("This feature has been disabled by the admin"));
        }
        break;

      case 'event':
        /* check if reviews enabled */
        if (!$system['events_reviews_enabled']) {
          throw new Exception(__("This feature has been disabled by the admin"));
        }
        break;

      case 'post':
        /* check if reviews enabled */
        if (!$system['posts_reviews_enabled']) {
          throw new Exception(__("This feature has been disabled by the admin"));
        }
        break;
    }
    /* check if the viewer is the admin or moderator */
    if ($this->_data['user_group'] < 3) {
      $can_delete = true;
    }
    /* check if the viewer is the review owner */
    if ($this->_data['user_id'] == $review['user_id']) {
      $can_delete = true;
    }
    /* check if the viewer can delete the review */
    if (!$can_delete) {
      throw new Exception(__("You don't have the permission to do this"));
    }
    /* delete review */
    $db->query(sprintf("DELETE FROM reviews WHERE review_id = %s", secure($review_id, 'int')));
    /* delete review photos */
    $db->query(sprintf("DELETE FROM reviews_photos WHERE review_id = %s", secure($review_id, 'int')));
    /* update node rate */
    $this->update_node_rate($review['node_id'], $review['node_type']);
  }


  /**
   * add_review_reply
   * 
   * @param integer $review_id
   * @param string $reply
   * @return void
   */
  public function add_review_reply($review_id, $reply)
  {
    global $db, $system;
    /* get review */
    $review = $this->get_review($review_id);
    if (!$review) {
      throw new NoDataException(__("The review you're trying to reply on doesn't exist"));
    }
    /* check if the viewer is the node admin */
    switch ($review['node_type']) {
      case 'page':
        /* check if reviews enabled */
        if (!$system['pages_reviews_enabled']) {
          throw new Exception(__("This feature has been disabled by the admin"));
        }
        /* get page */
        $page = $this->get_page($review['node_id']);
        if (!$page) {
          throw new NoDataException(__("The page you're trying to reply on doesn't exist"));
        }
        if (!$this->check_page_adminship($this->_data['user_id'], $review['node_id'])) {
          throw new Exception(__("You don't have the permission to do this"));
        }
        break;

      case 'group':
        /* check if reviews enabled */
        if (!$system['groups_reviews_enabled']) {
          throw new Exception(__("This feature has been disabled by the admin"));
        }
        /* get group */
        $group = $this->get_group($review['node_id']);
        if (!$group) {
          throw new NoDataException(__("The group you're trying to reply on doesn't exist"));
        }
        if (!$this->check_group_adminship($this->_data['user_id'], $review['node_id'])) {
          throw new Exception(__("You don't have the permission to do this"));
        }
        break;

      case 'event':
        /* check if reviews enabled */
        if (!$system['events_reviews_enabled']) {
          throw new Exception(__("This feature has been disabled by the admin"));
        }
        /* get event */
        $event = $this->get_event($review['node_id']);
        if (!$event) {
          throw new NoDataException(__("The event you're trying to reply on doesn't exist"));
        }
        if (!$this->check_event_adminship($this->_data['user_id'], $review['node_id'])) {
          throw new Exception(__("You don't have the permission to do this"));
        }
        break;

      case 'post':
        /* check if reviews enabled */
        if (!$system['posts_reviews_enabled']) {
          throw new Exception(__("This feature has been disabled by the admin"));
        }
        /* get post */
        $post = $this->get_post($review['node_id']);
        if (!$post) {
          throw new NoDataException(__("The post you're trying to reply on doesn't exist"));
        }
        if ($this->_data['user_id'] != $post['author_id']) {
          throw new Exception(__("You don't have the permission to do this"));
        }
        break;
    }
    /* validate reply */
    if (is_empty($reply)) {
      throw new ValidationException(__("You must enter a reply"));
    }
    /* update review reply text field with the reply  */
    $db->query(sprintf("UPDATE reviews SET reply = %s WHERE review_id = %s", secure($reply), secure($review_id, 'int')));
    /* notify the review author */
    switch ($review['node_type']) {
      case 'page':
        $this->post_notification(['to_user_id' => $review['user_id'], 'from_user_id' => $page['page_id'], 'action' => 'page_review_reply', 'from_user_type' => 'page', 'node_type' => $page['page_title'], 'node_url' => $page['page_name']]);
        break;

      case 'group':
        $this->post_notification(['to_user_id' => $review['user_id'], 'action' => 'group_review_reply', 'node_type' => $group['group_title'], 'node_url' => $group['group_name']]);
        break;

      case 'event':
        $this->post_notification(['to_user_id' => $review['user_id'], 'action' => 'event_review_reply', 'node_type' => $event['event_title'], 'node_url' => $event['event_id']]);
        break;

      case 'post':
        $this->post_notification(['to_user_id' => $review['user_id'], 'action' => 'post_review_reply', 'node_type' => $post['post_text'], 'node_url' => $post['post_id']]);
        break;
    }
  }


  /**
   * update_node_rate
   * 
   * @param integer $node_id
   * @param string $node_type
   * @return void
   */
  public function update_node_rate($node_id, $node_type = "page")
  {
    global $db;
    switch ($node_type) {
      case 'page':
        /* get page */
        $page = $this->get_page($node_id);
        if (!$page) {
          throw new Exception(__("The page you're trying to review doesn't exist"));
        }
        /* update page rate */
        $db->query(sprintf("UPDATE pages SET page_rate = COALESCE((SELECT AVG(rate) FROM reviews WHERE node_id = %s AND node_type = 'page'), 0) WHERE page_id = %s", secure($node_id, 'int'), secure($node_id, 'int')));
        break;

      case 'group':
        /* get group */
        $group = $this->get_group($node_id);
        if (!$group) {
          throw new Exception(__("The group you're trying to review doesn't exist"));
        }
        /* update group rate */
        $db->query(sprintf("UPDATE `groups` SET group_rate = COALESCE((SELECT AVG(rate) FROM reviews WHERE node_id = %s AND node_type = 'group'), 0) WHERE group_id = %s", secure($node_id, 'int'), secure($node_id, 'int')));
        break;

      case 'event':
        /* get event */
        $event = $this->get_event($node_id);
        if (!$event) {
          throw new Exception(__("The event you're trying to review doesn't exist"));
        }
        /* update event rate */
        $db->query(sprintf("UPDATE events SET event_rate = COALESCE((SELECT AVG(rate) FROM reviews WHERE node_id = %s AND node_type = 'event'), 0) WHERE event_id = %s", secure($node_id, 'int'), secure($node_id, 'int')));
        break;

      case 'post':
        /* get post */
        $post = $this->get_post($node_id);
        if (!$post) {
          throw new Exception(__("The post you're trying to review doesn't exist"));
        }
        /* update post rate */
        $db->query(sprintf("UPDATE posts SET post_rate = COALESCE((SELECT AVG(rate) FROM reviews WHERE node_id = %s AND node_type = 'post'), 0) WHERE post_id = %s", secure($node_id, 'int'), secure($node_id, 'int')));
        break;
    }
  }


  /**
   * get_reviews_count
   * 
   * @param integer $node_id
   * @param string $node_type
   * @return integer
   */
  public function get_reviews_count($node_id, $node_type = "page")
  {
    global $db;
    $get_reviews = $db->query(sprintf("SELECT COUNT(*) as count FROM reviews WHERE node_id = %s AND node_type = %s", secure($node_id, 'int'), secure($node_type)));
    return $get_reviews->fetch_assoc()['count'];
  }
}
