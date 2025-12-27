<?php

/**
 * trait -> events
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich
 */

trait EventsTrait
{

  /* ------------------------------- */
  /* Events */
  /* ------------------------------- */

  /**
   * get_events
   * 
   * @param array $args
   * @return array
   */
  public function get_events($args = [])
  {
    global $db, $system;
    /* initialize arguments */
    $user_id = !isset($args['user_id']) ? null : $args['user_id'];
    $page_id = !isset($args['page_id']) ? null : $args['page_id'];
    $category_id = !isset($args['category_id']) ? null : $args['category_id'];
    $type = !isset($args['type']) ? null : $args['type'];
    $country = !isset($args['country']) ? null : $args['country'];
    $language = !isset($args['language']) ? null : $args['language'];
    $random = !isset($args['random']) ? false : true;
    $get_all = !isset($args['get_all']) ? false : true;
    $offset = !isset($args['offset']) ? 0 : $args['offset'];
    $results = !isset($args['results']) ? $system['events_results'] : $args['results'];
    $promoted = !isset($args['promoted']) ? false : true;
    $boosted = !isset($args['boosted']) ? false : true;
    $suggested = !isset($args['suggested']) ? false : true;
    $managed = !isset($args['managed']) ? false : true;
    $filter = !isset($args['filter']) ? "admin" : $args['filter'];
    /* initialize vars */
    $events = [];
    $offset *= $results;
    /* prepare is_online statement */
    $type_statement = "";
    if ($type) {
      if ($type == "in_person") {
        $type_statement = " AND event_is_online = '0' ";
      } elseif ($type == "online") {
        $type_statement = " AND event_is_online = '1' ";
      }
    }
    /* prepare country statement */
    if ($country && $system['newsfeed_location_filter_enabled'] && $country != "all") {
      $country_statement = sprintf(" AND event_country = %s ", secure($country, 'int'));
    }
    /* prepare language statement */
    if ($language && $language != "all") {
      $language_statement = sprintf(" AND event_language = %s ", secure($language, 'int'));
    }
    /* prepare limit statement */
    $limit_statement = ($get_all) ? "" : sprintf(" LIMIT %s, %s ", secure($offset, 'int', false), secure($results, 'int', false));
    /* prepare date filter to exclude past events */
    $date_filter = " AND event_end_date >= NOW() ";
    if ($promoted) {
      /* get promoted events */
      $get_events = $db->query(sprintf("SELECT * FROM `events` WHERE event_boosted = '1' " . $type_statement . $country_statement . $language_statement . " ORDER BY RAND() LIMIT %s, %s", secure($offset, 'int', false), secure($results, 'int', false)));
    } elseif ($boosted) {
      /* get the "viewer" boosted events */
      $get_events = $db->query(sprintf("SELECT * FROM `events` WHERE event_boosted = '1' AND event_boosted_by = %s " . $type_statement . $country_statement . $language_statement . " LIMIT %s, %s", secure($this->_data['user_id'], 'int'), secure($offset, 'int', false), secure($results, 'int', false)));
    } elseif ($suggested) {
      /* get suggested events */
      $where_statement = sprintf(" AND event_id NOT IN (%s) ", $this->spread_ids($this->get_events_ids()));
      $category_statement = ($category_id) ? sprintf(" AND event_category = %s ", secure($category_id, 'int')) : "";
      $sort_statement = ($random) ? " ORDER BY RAND() " : " ORDER BY event_id DESC ";
      $get_events = $db->query("SELECT * FROM `events` WHERE event_privacy != 'secret'" . $where_statement . $type_statement . $country_statement . $language_statement . $category_statement . $date_filter . $sort_statement . $limit_statement);
    } elseif ($managed) {
      /* get the "taget" all events who admin */
      $get_events = $db->query(sprintf("SELECT * FROM `events` WHERE event_admin = %s " . $type_statement . $country_statement . $language_statement . " ORDER BY event_id DESC", secure($user_id, 'int')));
    } elseif ($page_id != null) {
      /* get events that managed by target page */
      $get_events = $db->query(sprintf("SELECT * FROM `events` WHERE event_page_id = %s " . $type_statement . $country_statement . $language_statement . " ORDER BY event_id DESC" . $limit_statement, secure($page_id, 'int')));
    } elseif ($user_id == null) {
      /* get the "viewer" events who (going|interested|invited|admin) */
      switch ($filter) {
        case 'going':
          $get_events = $db->query(sprintf("SELECT `events`.* FROM `events` INNER JOIN events_members ON `events`.event_id = events_members.event_id WHERE events_members.is_going = '1' AND events_members.user_id = %s " . $type_statement . $country_statement . $language_statement . " ORDER BY event_id DESC" . $limit_statement, secure($this->_data['user_id'], 'int')));
          break;

        case 'interested':
          $get_events = $db->query(sprintf("SELECT `events`.* FROM `events` INNER JOIN events_members ON `events`.event_id = events_members.event_id WHERE events_members.is_interested = '1' AND events_members.user_id = %s " . $type_statement . $country_statement . $language_statement . " ORDER BY event_id DESC" . $limit_statement, secure($this->_data['user_id'], 'int')));
          break;

        case 'invited':
          $get_events = $db->query(sprintf("SELECT `events`.* FROM `events` INNER JOIN events_members ON `events`.event_id = events_members.event_id WHERE events_members.is_invited = '1' AND events_members.user_id = %s " . $type_statement . $country_statement . $language_statement . " ORDER BY event_id DESC" . $limit_statement, secure($this->_data['user_id'], 'int')));
          break;

        default:
          $get_events = $db->query(sprintf("SELECT * FROM `events` WHERE event_admin = %s " . $type_statement . $country_statement . $language_statement . " ORDER BY event_id DESC " . $limit_statement, secure($this->_data['user_id'], 'int')));
          break;
      }
    } else {
      /* get the "target" events */
      /* get the target user's privacy */
      $get_privacy = $db->query(sprintf("SELECT user_privacy_events FROM users WHERE user_id = %s", secure($user_id, 'int')));
      $privacy = $get_privacy->fetch_assoc();
      /* check the target user's privacy */
      if (!$this->check_privacy($privacy['user_privacy_events'], $user_id)) {
        return $events;
      }
      /* if the viewer not the target exclude secret groups */
      $where_statement = ($this->_data['user_id'] == $user_id) ? "" : " AND `events`.event_privacy != 'secret' ";
      $get_events = $db->query(sprintf("SELECT `events`.* FROM `events` INNER JOIN events_members ON `events`.event_id = events_members.event_id WHERE (events_members.is_going = '1' OR events_members.is_interested = '1') AND events_members.user_id = %s" . $where_statement . $type_statement . $country_statement . $language_statement . " ORDER BY event_id DESC" . $limit_statement, secure($user_id, 'int')));
    }
    if ($get_events->num_rows > 0) {
      while ($event = $get_events->fetch_assoc()) {
        $event['event_picture'] = get_picture($event['event_cover'], 'event');
        /* check if the viewer joined the event */
        $event['i_joined'] = $this->check_event_membership($this->_data['user_id'], $event['event_id']);;
        $events[] = $event;
      }
    }
    return $events;
  }


  /**
   * get_event
   * 
   * @param integer $event_id
   * @return array
   */
  public function get_event($event_id)
  {
    global $db;
    $get_event = $db->query(sprintf("SELECT * FROM `events` WHERE event_id = %s", secure($event_id, 'int')));
    if ($get_event->num_rows == 0) {
      return false;
    }
    return $get_event->fetch_assoc();
  }


  /**
   * create_event
   * 
   * @param array $args
   * @return integer
   */
  public function create_event($args = [])
  {
    global $db, $system, $date;
    /* check if events enabled */
    if (!$system['events_enabled']) {
      throw new Exception(__("The events module has been disabled by the admin"));
    }
    /* check events permission */
    if (!$this->_data['can_create_events']) {
      throw new Exception(__("You don't have the permission to do this"));
    }
    /* check if it is page event */
    if (isset($args['page_id'])) {
      /* check if events page enabled */
      if (!$system['pages_events_enabled']) {
        throw new Exception(__("The pages events has been disabled by the admin"));
      }
      /* get page */
      $page = $this->get_page($args['page_id']);
      if (!$page) {
        throw new Exception(__("The page you are trying to add event to doesn't exist"));
      }
      /* check page adminship */
      if (!$this->check_page_adminship($this->_data['user_id'], $page['page_id'])) {
        throw new Exception(__("You don't have the permission to do this"));
      }
    }
    /* validate sponsor */
    $args['is_sponsored'] = (isset($args['is_sponsored'])) ? 1 : 0;
    if ($args['is_sponsored']) {
      /* check sponsor name */
      if (is_empty($args['sponsor_name'])) {
        throw new Exception(__("You must enter a sponsor name"));
      }
      /* check sponsor url */
      if (!valid_url($args['sponsor_url'])) {
        throw new Exception(__("Please enter a valid sponsor url"));
      }
    }
    /* validate title */
    if (is_empty($args['title'])) {
      throw new Exception(__("You must enter a name for your event"));
    }
    if (strlen($args['title']) < 3) {
      throw new Exception(__("Event name must be at least 3 characters long. Please try another"));
    }
    /* validate start & end dates */
    if (is_empty($args['start_date'])) {
      throw new Exception(__("You have to enter the event start date"));
    }
    if (is_empty($args['end_date'])) {
      throw new Exception(__("You have to enter the event end date"));
    }
    if (strtotime(set_datetime($args['start_date'])) > strtotime(set_datetime($args['end_date']))) {
      throw new Exception(__("Event end date must be after the start date"));
    }
    /* validate event type */
    $args['is_online'] = ($args['is_online'] == "1") ? 1 : 0;
    /* validate privacy */
    $args['privacy'] = (isset($args['page_id'])) ? "public" : $args['privacy'];
    if (!in_array($args['privacy'], ['secret', 'closed', 'public'])) {
      throw new Exception(__("You must select a valid privacy for your event"));
    }
    /* validate category */
    if (is_empty($args['category'])) {
      throw new Exception(__("You must select valid category for your event"));
    } else {
      if (!$this->check_category('events_categories', $args['category'])) {
        throw new Exception(__("You must select valid category for your event"));
      }
    }
    /* validate location */
    if ($args['is_online']) {
      $args['location'] = '';
    } else {
      if (is_empty($args['location'])) {
        throw new Exception(__("You have to enter the event location"));
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
    $custom_fields = $this->set_custom_fields($args, "event");
    /* check tickets link & prices info */
    if (isset($args['page_id'])) {
      if (!is_empty($args['tickets_link']) && !valid_url($args['tickets_link'])) {
        throw new Exception(__("Please enter a valid tickets link"));
      }
    }
    /* insert new event */
    if (isset($args['page_id'])) {
      $db->query(sprintf(
        "INSERT INTO `events` (
          event_is_sponsored, 
          event_sponsor_name, 
          event_sponsor_url, 
          event_privacy, 
          event_admin, 
          event_page_id, 
          event_category, 
          event_title, 
          event_location, 
          event_latitude, 
          event_longitude, 
          event_country, 
          event_language, 
          event_description, 
          event_start_date, 
          event_end_date, 
          event_is_online,
          event_date, 
          event_tickets_link, 
          event_prices
        ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)",
        secure($args['is_sponsored']),
        secure($args['sponsor_name']),
        secure($args['sponsor_url']),
        secure($args['privacy']),
        secure($this->_data['user_id'], 'int'),
        secure($args['page_id'], 'int'),
        secure($args['category'], 'int'),
        secure($args['title']),
        secure($args['location']),
        secure($args['latitude']),
        secure($args['longitude']),
        secure($args['country'], 'int'),
        secure($args['language'], 'int'),
        secure($args['description']),
        secure($args['start_date'], 'datetime'),
        secure($args['end_date'], 'datetime'),
        secure($args['is_online']),
        secure($date),
        secure($args['tickets_link']),
        secure($args['prices'])
      ));
    } else {
      $db->query(sprintf(
        "INSERT INTO `events` (
          event_is_sponsored, 
          event_sponsor_name, 
          event_sponsor_url, 
          event_privacy, 
          event_admin, 
          event_category, 
          event_title, 
          event_location, 
          event_latitude, 
          event_longitude, 
          event_country, 
          event_language, 
          event_description, 
          event_start_date, 
          event_end_date, 
          event_is_online,
          event_date
        ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)",
        secure($args['is_sponsored']),
        secure($args['sponsor_name']),
        secure($args['sponsor_url']),
        secure($args['privacy']),
        secure($this->_data['user_id'], 'int'),
        secure($args['category'], 'int'),
        secure($args['title']),
        secure($args['location']),
        secure($args['latitude']),
        secure($args['longitude']),
        secure($args['country'], 'int'),
        secure($args['language'], 'int'),
        secure($args['description']),
        secure($args['start_date'], 'datetime'),
        secure($args['end_date'], 'datetime'),
        secure($args['is_online']),
        secure($date)
      ));
    }
    /* get event_id */
    $event_id = $db->insert_id;
    /* insert custom fields values */
    if ($custom_fields) {
      foreach ($custom_fields as $field_id => $value) {
        $db->query(sprintf("INSERT INTO custom_fields_values (value, field_id, node_id, node_type) VALUES (%s, %s, %s, 'event')", secure($value), secure($field_id, 'int'), secure($event_id, 'int')));
      }
    }
    /* interest the event */
    $this->connect("event-interest", $event_id);
    /* notify page memebers */
    if (isset($args['page_id'])) {
      foreach ($this->get_page_members_ids($args['page_id']) as $member_id) {
        $this->post_notification(['to_user_id' => $member_id, 'from_user_id' => $args['page_id'], 'from_user_type' => 'page', 'action' => 'page_event', 'node_type' => 'event', 'node_url' => $event_id]);
      }
    }
    /* create event post */
    if ($args['create_post'] && in_array($args['privacy'], ['closed', 'public'])) {
      if (isset($args['page_id'])) {
        $db->query(sprintf("INSERT INTO posts (user_id, user_type, post_type, event_id, privacy, time) VALUES (%s, 'page', 'event', %s, 'public', %s)", secure($args['page_id'], 'int'), secure($event_id, 'int'), secure($date)));
      } else {
        $db->query(sprintf("INSERT INTO posts (user_id, user_type, post_type, event_id, privacy, time) VALUES (%s, 'user', 'event', %s, 'public', %s)", secure($this->_data['user_id'], 'int'), secure($event_id, 'int'), secure($date)));
      }
    }
    /* return event id */
    return $event_id;
  }


  /**
   * edit_event
   * 
   * @param integer $event_id
   * @param string $title
   * @param string $location
   * @param string $start_date
   * @param string $end_date
   * @param string $privacy
   * @param integer $category
   * @param string $description
   * @return void
   */
  public function edit_event($event_id, $args)
  {
    global $db, $system;
    /* check if events enabled */
    if (!$system['events_enabled']) {
      throw new Exception(__("The events module has been disabled by the admin"));
    }
    /* check events permission */
    if (!$this->_data['can_create_events']) {
      throw new Exception(__("You don't have the permission to do this"));
    }
    /* (check&get) event */
    $get_event = $db->query(sprintf("SELECT * FROM `events` WHERE event_id = %s", secure($event_id, 'int')));
    if ($get_event->num_rows == 0) {
      _error(403);
    }
    $event = $get_event->fetch_assoc();
    /* check permission */
    $can_edit = false;
    /* viewer is (admin|moderator) */
    if ($this->_data['user_group'] < 3) {
      $can_edit = true;
      /* viewer is the admin of event */
    } elseif ($this->check_event_adminship($this->_data['user_id'], $event['event_id'])) {
      $can_edit = true;
    }
    if (!$can_edit) {
      _error(403);
    }
    /* check if it is page event */
    if ($event['event_page_id']) {
      /* check if events page enabled */
      if (!$system['pages_events_enabled']) {
        throw new Exception(__("The pages events has been disabled by the admin"));
      }
      /* get page */
      $page = $this->get_page($event['event_page_id']);
      if (!$page) {
        throw new Exception(__("The page you are trying to add event to doesn't exist"));
      }
      /* check page adminship */
      if (!$this->check_page_adminship($this->_data['user_id'], $page['page_id'])) {
        throw new Exception(__("You don't have the permission to do this"));
      }
    }
    /* validate sponsor */
    $args['is_sponsored'] = (isset($args['is_sponsored'])) ? 1 : 0;
    if ($args['is_sponsored']) {
      /* check sponsor name */
      if (is_empty($args['sponsor_name'])) {
        throw new Exception(__("You must enter a sponsor name"));
      }
      /* check sponsor url */
      if (!valid_url($args['sponsor_url'])) {
        throw new Exception(__("Please enter a valid sponsor url"));
      }
    }
    /* validate title */
    if (is_empty($args['title'])) {
      throw new Exception(__("You must enter a name for your event"));
    }
    if (strlen($args['title']) < 3) {
      throw new Exception(__("Event name must be at least 3 characters long. Please try another"));
    }
    /* validate start & end dates */
    if (is_empty($args['start_date'])) {
      throw new Exception(__("You have to enter the event start date"));
    }
    if (is_empty($args['end_date'])) {
      throw new Exception(__("You have to enter the event end date"));
    }
    if (strtotime(set_datetime($args['start_date'])) > strtotime(set_datetime($args['end_date']))) {
      throw new Exception(__("Event end date must be after the start date"));
    }
    /* validate event type */
    $args['is_online'] = ($args['is_online'] == "1") ? 1 : 0;
    /* validate privacy */
    $args['privacy'] = ($event['event_page_id']) ? "public" : $args['privacy'];
    if (!in_array($args['privacy'], ['secret', 'closed', 'public'])) {
      throw new Exception(__("You must select a valid privacy for your event"));
    }
    /* validate category */
    if (is_empty($args['category'])) {
      throw new Exception(__("You must select valid category for your event"));
    } else {
      if (!$this->check_category('events_categories', $args['category'])) {
        throw new Exception(__("You must select valid category for your event"));
      }
    }
    /* validate location */
    if ($args['is_online']) {
      $args['location'] = '';
    } else {
      if (is_empty($args['location'])) {
        throw new Exception(__("You have to enter the event location"));
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
    $this->set_custom_fields($args, "event", "settings", $event_id);
    /* check tickets link & prices info */
    if ($event['event_page_id']) {
      if (!is_empty($args['tickets_link']) && !valid_url($args['tickets_link'])) {
        throw new Exception(__("Please enter a valid tickets link"));
      }
    } else {
      $args['tickets_link'] = '';
      $args['prices'] = '';
    }
    /* update the event */
    $args['chatbox_enabled'] = (isset($args['chatbox_enabled'])) ? '1' : '0';
    $args['event_publish_enabled'] = (isset($args['event_publish_enabled'])) ? '1' : '0';
    $args['event_publish_approval_enabled'] = (isset($args['event_publish_approval_enabled'])) ? '1' : '0';
    $db->query(sprintf(
      "UPDATE `events` SET 
        event_is_sponsored = %s, 
        event_sponsor_name = %s, 
        event_sponsor_url = %s, 
        event_privacy = %s, 
        event_category = %s, 
        event_title = %s, 
        event_location = %s, 
        event_latitude = %s, 
        event_longitude = %s, 
        event_country = %s, 
        event_language = %s, 
        event_description = %s, 
        event_start_date = %s, 
        event_end_date = %s, 
        event_is_online = %s,
        chatbox_enabled = %s, 
        event_publish_enabled = %s, 
        event_publish_approval_enabled = %s, 
        event_tickets_link = %s, 
        event_prices = %s 
      WHERE event_id = %s",
      secure($args['is_sponsored']),
      secure($args['sponsor_name']),
      secure($args['sponsor_url']),
      secure($args['privacy']),
      secure($args['category'], 'int'),
      secure($args['title']),
      secure($args['location']),
      secure($args['latitude']),
      secure($args['longitude']),
      secure($args['country'], 'int'),
      secure($args['language'], 'int'),
      secure($args['description']),
      secure($args['start_date'], 'datetime'),
      secure($args['end_date'], 'datetime'),
      secure($args['is_online']),
      secure($args['chatbox_enabled']),
      secure($args['event_publish_enabled']),
      secure($args['event_publish_approval_enabled']),
      secure($args['tickets_link']),
      secure($args['prices']),
      secure($event_id, 'int')
    ));
    /* check if chatbox enabled */
    if ($args['chatbox_enabled']) {
      /* create new chatbox if not */
      if (!$event['chatbox_conversation_id']) {
        $conversation_id = $this->create_chatbox($event_id, 'event');
        /* update event */
        $db->query(sprintf("UPDATE `events` SET chatbox_conversation_id = %s WHERE event_id = %s", secure($conversation_id, 'int'), secure($event_id, 'int')));
      }
    }
    /* check if post approval disabled */
    if (!$args['event_publish_approval_enabled']) {
      /* approve any pending posts */
      $db->query(sprintf("UPDATE posts SET event_approved = '1' WHERE in_event = '1' AND event_id = %s", secure($event_id, 'int')));
    }
  }


  /**
   * delete_event
   * 
   * @param integer $event_id
   * @return void
   */
  public function delete_event($event_id)
  {
    global $db, $system;
    /* check if events enabled */
    if (!$system['events_enabled']) {
      throw new Exception(__("The events module has been disabled by the admin"));
    }
    /* check events permission */
    if (!$this->_data['can_create_events']) {
      throw new Exception(__("You don't have the permission to do this"));
    }
    /* (check&get) event */
    $get_event = $db->query(sprintf("SELECT * FROM `events` WHERE event_id = %s", secure($event_id, 'int')));
    if ($get_event->num_rows == 0) {
      _error(403);
    }
    $event = $get_event->fetch_assoc();
    // delete event
    $can_delete = false;
    /* viewer is (admin|moderator) */
    if ($this->_data['user_group'] < 3) {
      $can_delete = true;
      /* viewer is the admin of event */
    } elseif ($this->check_event_adminship($this->_data['user_id'], $event['event_id'])) {
      $can_delete = true;
    }
    /* delete the event */
    if (!$can_delete) {
      _error(403);
    }
    /* delete event */
    $db->query(sprintf("DELETE FROM `events` WHERE event_id = %s", secure($event_id, 'int')));
    /* delete event members */
    $db->query(sprintf("DELETE FROM `events_members` WHERE event_id = %s", secure($event_id, 'int')));
    /* check if the event has chatbox */
    if ($event['chatbox_conversation_id']) {
      /* delete the chatbox */
      $this->delete_chatbox($event['chatbox_conversation_id']);
    }
  }


  /**
   * get_event_members
   * 
   * @param integer $event_id
   * @param string $handle
   * @param integer $offset
   * @return array
   */
  public function get_event_members($event_id, $handle, $offset = 0)
  {
    global $db, $system;
    $members = [];
    $offset *= $system['max_results_even'];
    switch ($handle) {
      case 'going':
        $get_members = $db->query(sprintf(
          "
          SELECT 
            users.user_id, 
            users.user_name, 
            users.user_firstname, 
            users.user_lastname, 
            users.user_gender, 
            users.user_picture, 
            users.user_subscribed, 
            users.user_verified 
          FROM events_members 
          INNER JOIN users ON events_members.user_id = users.user_id 
          WHERE events_members.is_going = '1' 
            AND events_members.event_id = %s 
            " . $this->get_sql_order_by_friends_followings() . "
          LIMIT %s, %s",
          secure($event_id, 'int'),
          secure($offset, 'int', false),
          secure($system['max_results_even'], 'int', false)
        ));
        break;

      case 'interested':
        $get_members = $db->query(sprintf(
          "
          SELECT 
            users.user_id, 
            users.user_name, 
            users.user_firstname, 
            users.user_lastname, 
            users.user_gender, 
            users.user_picture, 
            users.user_subscribed, 
            users.user_verified 
          FROM events_members 
          INNER JOIN users ON events_members.user_id = users.user_id 
          WHERE events_members.is_interested = '1' 
            AND events_members.event_id = %s 
            " . $this->get_sql_order_by_friends_followings() . "
          LIMIT %s, %s",
          secure($event_id, 'int'),
          secure($offset, 'int', false),
          secure($system['max_results_even'], 'int', false)
        ));
        break;

      case 'invited':
        $get_members = $db->query(sprintf(
          "
          SELECT 
            users.user_id, 
            users.user_name, 
            users.user_firstname, 
            users.user_lastname, 
            users.user_gender, 
            users.user_picture, 
            users.user_subscribed, 
            users.user_verified 
          FROM events_members 
          INNER JOIN users ON events_members.user_id = users.user_id 
          WHERE events_members.is_invited = '1' 
            AND events_members.event_id = %s 
            " . $this->get_sql_order_by_friends_followings() . "
          LIMIT %s, %s",
          secure($event_id, 'int'),
          secure($offset, 'int', false),
          secure($system['max_results_even'], 'int', false)
        ));
        break;

      default:
        _error(400);
        break;
    }
    if ($get_members->num_rows > 0) {
      while ($member = $get_members->fetch_assoc()) {
        $member['user_picture'] = get_picture($member['user_picture'], $member['user_gender']);
        /* get the connection between the viewer & the target */
        $member['connection'] = $this->connection($member['user_id']);
        $members[] = $member;
      }
    }
    return $members;
  }


  /**
   * get_event_members_ids
   * 
   * @param integer $event_id
   * @return array
   */
  public function get_event_members_ids($event_id)
  {
    global $db;
    $members = [];
    $get_members = $db->query(sprintf("SELECT user_id FROM events_members WHERE event_id = %s", secure($event_id, 'int')));
    if ($get_members->num_rows > 0) {
      while ($member = $get_members->fetch_assoc()) {
        $members[] = $member['user_id'];
      }
    }
    return $members;
  }


  /**
   * get_event_invites
   * 
   * @param integer $event_id
   * @param integer $offset
   * @return array
   */
  public function get_event_invites($event_id, $offset = 0)
  {
    global $db, $system;
    $friends = [];
    $offset *= $system['max_results_even'];
    $get_friends = $db->query(sprintf("SELECT users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, users.user_subscribed, users.user_verified FROM users LEFT JOIN events_members ON users.user_id = events_members.user_id AND events_members.event_id = %s WHERE users.user_id IN (%s) AND events_members.id IS NULL LIMIT %s, %s", secure($event_id, 'int'), $this->spread_ids($this->_data['friends_ids']), secure($offset, 'int', false), secure($system['max_results_even'], 'int', false)));
    while ($friend = $get_friends->fetch_assoc()) {
      $friend['user_picture'] = get_picture($friend['user_picture'], $friend['user_gender']);
      $friend['connection'] = 'event_invite';
      $friend['node_id'] = $event_id;
      $friends[] = $friend;
    }
    return $friends;
  }


  /**
   * check_event_adminship
   * 
   * @param integer $user_id
   * @param integer $event_id
   * @return boolean
   */
  public function check_event_adminship($user_id, $event_id)
  {
    global $db;
    if ($this->_logged_in) {
      $check = $db->query(sprintf("SELECT COUNT(*) as count FROM `events` WHERE event_admin = %s AND event_id = %s", secure($user_id, 'int'), secure($event_id, 'int')));
      if ($check->fetch_assoc()['count'] > 0) {
        return true;
      }
    }
    return false;
  }


  /**
   * check_event_membership
   * 
   * @param integer $user_id
   * @param integer $event_id
   * @return mixed
   */
  public function check_event_membership($user_id, $event_id)
  {
    global $db;
    if ($this->_logged_in) {
      $get_membership = $db->query(sprintf("SELECT is_invited, is_interested, is_going FROM events_members WHERE user_id = %s AND event_id = %s", secure($user_id, 'int'), secure($event_id, 'int')));
      if ($get_membership->num_rows > 0) {
        return $get_membership->fetch_assoc();
      }
    }
    return false;
  }


  /**
   * get_event_pending_posts
   * 
   * @param integer $event_id
   * @param boolean $get_all
   * @return integer
   */
  public function get_event_pending_posts($event_id, $get_all = false)
  {
    global $db, $system;
    $get_all_query = ($get_all) ? "" : sprintf(" AND user_type = 'user' AND user_id = %s", secure($this->_data['user_id'], 'int'));
    $get_pending_posts = $db->query(sprintf("SELECT COUNT(*) as count FROM posts WHERE in_event = '1' AND event_approved = '0' AND event_id = %s" . $get_all_query, secure($event_id, 'int')));
    return $get_pending_posts->fetch_assoc()['count'];
  }
}
