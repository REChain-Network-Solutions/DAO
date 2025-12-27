<?php

/**
 * trait -> merits
 *
 * @package Delus
 * @author Sorokin Dmitry Olegovich
 */

trait MeritsTrait
{

  /* ------------------------------- */
  /* Merits */
  /* ------------------------------- */

  /**
   * get_merits_cycle_dates
   *
   * @return array
   */
  public function get_merits_cycle_dates()
  {
    global $system;
    /* set the start and end date of the merits peroid */
    switch ($system['merits_peroid']) {
      case '1':
        # Monthly
        $start_date = ($system['merits_peroid_reset'] == '1') ? date('Y-m-01') : date('Y-m-15');
        $end_date = ($system['merits_peroid_reset'] == '1') ? date('Y-m-t') : date('Y-m-15', strtotime('+1 month'));
        break;

      case '3':
        # Quarterly
        $current_month = date('n');
        $quarter_start_month = 1 + 3 * floor(($current_month - 1) / 3);
        $quarter_end_month = $quarter_start_month + 2;
        $start_date = ($system['merits_peroid_reset'] == '1') ? date("Y-{$quarter_start_month}-01") : date("Y-{$quarter_start_month}-15");
        $end_date = ($system['merits_peroid_reset'] == '1') ? date("Y-m-t", strtotime("last day of +" . (3 - ($current_month - $quarter_start_month) - 1) . " months")) : date("Y-{$quarter_end_month}-15");
        break;

      case '6':
        # Semi-Annually
        $current_month = date('n');
        $half_start_month = ($current_month <= 6) ? 1 : 7;
        $half_end_month = $half_start_month + 5;
        $start_date = ($system['merits_peroid_reset'] == '1') ? date("Y-{$half_start_month}-01") : date("Y-{$half_start_month}-15");
        $end_date = ($system['merits_peroid_reset'] == '1') ? date("Y-m-t", strtotime("last day of +" . (6 - ($current_month - $half_start_month) - 1) . " months")) : date("Y-{$half_end_month}-15");
        break;

      case '12':
        # Annually
        $start_date = ($system['merits_peroid_reset'] == '1') ? date('Y-01-01') : date('Y-01-15');
        $end_date = ($system['merits_peroid_reset'] == '1') ? date('Y-12-31') : date('Y-12-15');
        break;
    }
    /* set the reset and reminder dates */
    $reset_day = date('d', strtotime($end_date));
    $reset_date = date('Y-m-' . $reset_day);
    $is_reset_day = ($reset_day == date('d'));
    $reminder_day = date('d', strtotime($end_date . ' -7 days'));
    $reminder_date = date('Y-m-' . $reminder_day);
    $is_reminder_day = ($reminder_day == date('d'));
    /* return */
    return [
      "start_date" => $start_date,
      "end_date" => $end_date,
      "reset_day" => $reset_day,
      "reset_date" => $reset_date,
      "is_reset_day" => $is_reset_day,
      "reminder_day" => $reminder_day,
      "reminder_date" => $reminder_date,
      "is_reminder_day" => $is_reminder_day,
    ];
  }


  /**
   * get_user_merits_balance
   *
   * @param integer $user_id
   * @return array
   */
  public function get_user_merits_balance($user_id = null)
  {
    global $system, $db;
    $user_id = ($user_id) ? $user_id : $this->_data['user_id'];
    /* get the max merits balance */
    $max_merits = $system['merits_peroid_max'];
    /* get the user merits he sent in the current merits cycle */
    $cycle_dates = $this->get_merits_cycle_dates();
    $get_sent_merits = $db->query(sprintf("SELECT COUNT(*) as count FROM users_merits WHERE from_user_id = %s AND sent_date >= %s AND sent_date <= %s", secure($user_id, 'int'), secure($cycle_dates['start_date']), secure($cycle_dates['end_date'])));
    $sent_merits = $get_sent_merits->fetch_assoc()['count'];
    /* get the remining merits */
    $remining_merits = $max_merits - $sent_merits;
    /* get received merits */
    $get_received_merits = $db->query(sprintf("SELECT COUNT(*) as count FROM users_merits WHERE to_user_id = %s AND sent_date >= %s AND sent_date <= %s", secure($user_id, 'int'), secure($cycle_dates['start_date']), secure($cycle_dates['end_date'])));
    $received_merits = $get_received_merits->fetch_assoc()['count'];
    return ["max" => $max_merits, "sent" => $sent_merits, "remining" => $remining_merits, "received" => $received_merits];
  }


  /**
   * send_merit
   *
   * @param array $recepients
   * @param integer $category_id
   * @param string $message
   * @param string $image
   * @return void
   */
  public function send_merit($recepients, $category_id, $message, $image)
  {
    global $system, $db, $date;
    /* check if merits enabled */
    if (!$system['merits_enabled']) {
      throw new Exception(__("The merits system has been disabled by the admin"));
    }
    /* prepare the recepients */
    if (is_empty($recepients)) {
      throw new ValidationException(__("You must select recepients"));
    }
    $recepients = json_decode(html_entity_decode($recepients), true);
    if (count($recepients) == 0) {
      throw new ValidationException(__("Invalid recepients"));
    }
    $recepients_ids = [];
    foreach ($recepients as $_user) {
      if (is_numeric($_user['id']) && !in_array($_user['id'], $recepients_ids)) {
        /* check if recepient is the viewer */
        if ($_user['id'] == $this->_data['user_id']) {
          throw new ValidationException(__("You can't send merits to yourself"));
        }
        /* check if the recepient is valid */
        $check_user = $db->query(sprintf("SELECT COUNT(*) as count FROM users WHERE user_id = %s", secure($_user['id'], 'int')));
        if ($check_user->fetch_assoc()['count'] == 0) {
          throw new ValidationException(__("Invalid recepients"));
        }
        /* check if the recepient received the max merits from the viewer in the current merits cycle */
        $cycle_dates = $this->get_merits_cycle_dates();
        $check_sent_merits = $db->query(sprintf("SELECT COUNT(*) as count FROM users_merits WHERE from_user_id = %s AND to_user_id = %s AND sent_date >= %s AND sent_date <= %s", secure($this->_data['user_id'], 'int'), secure($_user['id'], 'int'), secure($cycle_dates['start_date']), secure($cycle_dates['end_date'])));
        if ($check_sent_merits->fetch_assoc()['count'] >= $system['merits_send_peroid_max']) {
          throw new ValidationException(__("You can't send more merits to this user") . " " . $_user['value']);
        }
        $recepients_ids[] = $_user['id'];
      }
    }
    if (count($recepients_ids) == 0) {
      throw new ValidationException(__("Invalid recepients"));
    }
    /* check merits balance */
    $this->_data['merits_balance'] = $this->get_user_merits_balance();
    if ($this->_data['merits_balance']['remining'] < count($recepients_ids)) {
      throw new ValidationException(__("You don't have enough merits to send"));
    }
    /* check category */
    if (!$this->check_category('merits_categories', $category_id)) {
      throw new ValidationException(__("You must select valid category for your merit"));
    }
    /* send merits */
    foreach ($recepients_ids as $recepients_id) {
      $db->query(sprintf("INSERT INTO users_merits (from_user_id, to_user_id, category_id, message, image, sent_date) VALUES (%s, %s, %s, %s, %s, %s)", secure($this->_data['user_id'], 'int'), secure($recepients_id, 'int'), secure($category_id, 'int'), secure($message), secure($image), secure($date)));
      $merit_id = $db->insert_id;
      /* insert the merit post (wall post) */
      $db->query(sprintf("INSERT INTO posts (user_id, user_type, in_wall, wall_id, post_type, `time`, privacy) VALUES (%s, 'user', '1', %s, 'merit', %s, 'public')", secure($this->_data['user_id'], 'int'), secure($recepients_id, 'int'), secure($date)));
      $post_id = $db->insert_id;
      /* insert the merit post details */
      $db->query(sprintf("INSERT INTO posts_merits (post_id, category_id, message, image) VALUES (%s, %s, %s, %s)", secure($post_id, 'int'), secure($category_id, 'int'), secure($message), secure($image)));
      /* notify the recepients */
      if ($system['merits_notifications_recipient']) {
        $this->post_notification(['to_user_id' => $recepients_id, 'action' => 'merit_received', 'node_url' => $post_id]);
      }
    }
    /* notify user */
    $this->post_notification(['to_user_id' => $this->_data['user_id'], 'system_notification' => true, 'action' => 'merit_sent']);
    /* remove pending uploads */
    remove_pending_uploads([$image]);
  }


  /**
   * get_merits_top_users
   *
   * @return array
   */
  public function get_merits_top_users()
  {
    global $system, $db;
    $results = [];
    /* get merits current cycle dates */
    $cycle_dates = $this->get_merits_cycle_dates();
    /* loop through the merits categories */
    $merits_categories = $this->get_categories("merits_categories");
    foreach ($merits_categories as $category) {
      $get_top_users = $db->query(sprintf("SELECT users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_picture, COUNT(*) as count FROM users_merits INNER JOIN users ON users_merits.to_user_id = users.user_id WHERE users_merits.category_id = %s AND users_merits.sent_date >= %s AND users_merits.sent_date <= %s GROUP BY users_merits.to_user_id ORDER BY count DESC LIMIT 1", secure($category['category_id'], 'int'), secure($cycle_dates['start_date']), secure($cycle_dates['end_date'])));
      if ($get_top_users->num_rows > 0) {
        $user = $get_top_users->fetch_assoc();
        $user['user_picture'] = get_picture($user['user_picture'], $user['user_gender']);
        $results[$category['category_id']]['category'] = $category;
        $results[$category['category_id']]['top_user'] = $user;
      }
    }
    return $results;
  }


  /**
   * get_merits_ranking
   *
   * @param array $args
   * @return array
   */
  public function get_merits_ranking($args = [])
  {
    global $system, $db;
    $results = [];
    /* get merits current cycle dates */
    $cycle_dates = $this->get_merits_cycle_dates();
    /* init params */
    $args['category'] = (isset($args['category'])) ? $args['category'] : null;
    $args['start_date'] = (isset($args['start_date'])) ? $args['start_date'] : $cycle_dates['start_date'];
    $args['end_date'] = (isset($args['end_date'])) ? $args['end_date'] : $cycle_dates['end_date'];
    $args['limit'] = (isset($args['limit'])) ? $args['limit'] : '10';
    /* get users */
    $where_query = ($args['category'] && $args['category'] != "all") ? " AND users_merits.category_id = " . secure($args['category'], 'int') : "";
    $get_users = $db->query(sprintf("SELECT users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_picture, COUNT(*) as count FROM users_merits INNER JOIN users ON users_merits.to_user_id = users.user_id WHERE users_merits.sent_date >= %s AND users_merits.sent_date <= %s %s GROUP BY users_merits.to_user_id ORDER BY count DESC LIMIT %s", secure($args['start_date']), secure($args['end_date']), $where_query, $args['limit']));
    if ($get_users->num_rows > 0) {
      while ($user = $get_users->fetch_assoc()) {
        $user['user_picture'] = get_picture($user['user_picture'], $user['user_gender']);
        $results[] = $user;
      }
    }
    return $results;
  }


  /**
   * merits_reminder
   *
   * @return void
   */
  public function merits_reminder()
  {
    global $system, $db;
    /* check if merits enabled & reminder notifications enabled */
    if (!$system['merits_enabled'] || !$system['merits_notifications_reminder']) return;
    /* get merits current cycle dates */
    $cycle_dates = $this->get_merits_cycle_dates();
    /* if reminder date is today */
    if (!$cycle_dates['is_reminder_day']) return;
    /* get users */
    $get_users = $db->query(sprintf("SELECT users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_email FROM users"));
    if ($get_users->num_rows > 0) {
      while ($user = $get_users->fetch_assoc()) {
        /* calculate the user merits balance */
        $user['merits_balance'] = $this->get_user_merits_balance($user['user_id']);
        /* check if the user has merits remining */
        if ($user['merits_balance']['remining'] > 0) {
          /* notify user */
          $this->post_notification(['to_user_id' => $user['user_id'], 'system_notification' => true, 'action' => 'merits_reminder', 'node_url' => $user['merits_balance']['remining']]);
        }
      }
    }
  }
}
