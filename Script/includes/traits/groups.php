<?php

/**
 * trait -> groups
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich - Handles - @sorydima @sorydev @durovshater @DmitrySoro90935 @tanechfund - also check https://dmitry.rechain.network for more information!
 */

trait GroupsTrait
{

  /* ------------------------------- */
  /* Groups */
  /* ------------------------------- */

  /**
   * get_groups
   * 
   * @param array $args
   * @return array
   */
  public function get_groups($args = [])
  {
    global $db, $system;
    /* initialize arguments */
    $user_id = !isset($args['user_id']) ? null : $args['user_id'];
    $category_id = !isset($args['category_id']) ? null : $args['category_id'];
    $country = !isset($args['country']) ? null : $args['country'];
    $language = !isset($args['language']) ? null : $args['language'];
    $offset = !isset($args['offset']) ? 0 : $args['offset'];
    $get_all = !isset($args['get_all']) ? false : true;
    $suggested = !isset($args['suggested']) ? false : true;
    $random = !isset($args['random']) ? false : true;
    $managed = !isset($args['managed']) ? false : true;
    $results = !isset($args['results']) ? $system['groups_results'] : $args['results'];
    /* initialize vars */
    $groups = [];
    $offset *= $results;
    /* prepare country statement */
    if ($country && $system['newsfeed_location_filter_enabled'] && $country != "all") {
      $country_statement = sprintf(" AND group_country = %s ", secure($country, 'int'));
    }
    /* prepare language statement */
    if ($language && $language != "all") {
      $language_statement = sprintf(" AND group_language = %s ", secure($language, 'int'));
    }
    if ($suggested) {
      /* get suggested groups */
      $where_statement = "";
      /* make a list from joined groups (approved|pending) */
      $where_statement .= sprintf("AND group_id NOT IN (%s) ", $this->spread_ids($this->get_groups_ids()));
      $category_statement = ($category_id) ? "AND group_category = " . secure($category_id, 'int') : "";
      $sort_statement = ($random) ? " ORDER BY RAND() " : " ORDER BY group_id DESC ";
      $limit_statement = ($get_all) ? "" : sprintf("LIMIT %s, %s", secure($offset, 'int', false), secure($results, 'int', false));
      $get_groups = $db->query("SELECT * FROM `groups` WHERE group_privacy != 'secret' " . $where_statement . $country_statement . $language_statement . $category_statement . $sort_statement . $limit_statement);
    } elseif ($managed) {
      /* get the "taget" all groups who admin */
      $limit_statement = ($get_all) ? "" : sprintf("LIMIT %s, %s", secure($offset, 'int', false), secure($results, 'int', false));
      $get_groups = $db->query(sprintf("SELECT `groups`.* FROM groups_admins INNER JOIN `groups` ON groups_admins.group_id = `groups`.group_id WHERE groups_admins.user_id = %s " . $country_statement . $language_statement . " ORDER BY group_id DESC " . $limit_statement, secure($user_id, 'int')));
    } elseif ($user_id == null) {
      /* get the "viewer" groups who admin */
      $limit_statement = ($get_all) ? "" : sprintf("LIMIT %s, %s", secure($offset, 'int', false), secure($results, 'int', false));
      $get_groups = $db->query(sprintf("SELECT `groups`.* FROM groups_admins INNER JOIN `groups` ON groups_admins.group_id = `groups`.group_id WHERE groups_admins.user_id = %s " . $country_statement . $language_statement . " ORDER BY group_id DESC " . $limit_statement, secure($this->_data['user_id'], 'int')));
      /* get the "target" groups*/
    } else {
      /* get the target user's privacy */
      $get_privacy = $db->query(sprintf("SELECT user_privacy_groups FROM users WHERE user_id = %s", secure($user_id, 'int')));
      $privacy = $get_privacy->fetch_assoc();
      /* check the target user's privacy */
      if (!$this->check_privacy($privacy['user_privacy_groups'], $user_id)) {
        return $groups;
      }
      /* if the viewer not the target exclude secret groups */
      $where_statement = ($this->_data['user_id'] == $user_id) ? "" : "AND `groups`.group_privacy != 'secret'";
      $limit_statement = ($get_all) ? "" : sprintf("LIMIT %s, %s", secure($offset, 'int', false), secure($results, 'int', false));
      $get_groups = $db->query(sprintf("SELECT `groups`.* FROM `groups` INNER JOIN groups_members ON `groups`.group_id = groups_members.group_id WHERE groups_members.approved = '1' AND groups_members.user_id = %s " . $where_statement . $country_statement . $language_statement . " ORDER BY group_id DESC " . $limit_statement, secure($user_id, 'int')));
    }
    if ($get_groups->num_rows > 0) {
      while ($group = $get_groups->fetch_assoc()) {
        $group['group_picture'] = get_picture($group['group_picture'], 'group');
        /* check if the viewer joined the group */
        $group['i_joined'] = $this->check_group_membership($this->_data['user_id'], $group['group_id']);;
        $groups[] = $group;
      }
    }
    return $groups;
  }


  /**
   * get_group
   * 
   * @param integer $group_id
   * @return array
   */
  public function get_group($group_id)
  {
    global $db;
    $get_group = $db->query(sprintf("SELECT * FROM `groups` WHERE group_id = %s", secure($group_id, 'int')));
    if ($get_group->num_rows == 0) {
      return false;
    }
    return $get_group->fetch_assoc();
  }


  /**
   * create_group
   * 
   * @param array $args
   * @return void
   */
  public function create_group($args = [])
  {
    global $db, $system, $date;
    /* check if groups enabled */
    if (!$system['groups_enabled']) {
      throw new Exception(__("The groups module has been disabled by the admin"));
    }
    /* check groups permission */
    if (!$this->_data['can_create_groups']) {
      throw new Exception(__("You don't have the permission to do this"));
    }
    /* validate title */
    if (is_empty($args['title'])) {
      throw new Exception(__("You must enter a name for your group"));
    }
    if (strlen($args['title']) < 3) {
      throw new Exception(__("Group name must be at least 3 characters long. Please try another"));
    }
    /* validate username */
    if (is_empty($args['username'])) {
      throw new Exception(__("You must enter a web address for your group"));
    }
    if (!valid_username($args['username'])) {
      throw new Exception(__("Please enter a valid web address (a-z0-9_.) with minimum 3 characters long"));
    }
    if ($this->reserved_username($args['username'])) {
      throw new Exception(__("You can't use") . " " . $args['username'] . " " . __("as web address"));
    }
    if ($this->check_username($args['username'], 'group')) {
      throw new Exception(__("Sorry, it looks like this web address") . " " . $args['username'] . " " . __("belongs to an existing group"));
    }
    /* validate privacy */
    if (!in_array($args['privacy'], ['secret', 'closed', 'public'])) {
      throw new Exception(__("You must select a valid privacy for your group"));
    }
    /* validate category */
    if (is_empty($args['category'])) {
      throw new Exception(__("You must select valid category for your group"));
    } else {
      if (!$this->check_category('groups_categories', $args['category'])) {
        throw new Exception(__("You must select valid category for your group"));
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
    $custom_fields = $this->set_custom_fields($args, "group");
    /* insert new group */
    $db->query(sprintf(
      "INSERT INTO `groups` (
        group_privacy, 
        group_admin, 
        group_name, 
        group_category, 
        group_title, 
        group_country, 
        group_language, 
        group_description, 
        group_date
      ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)",
      secure($args['privacy']),
      secure($this->_data['user_id'], 'int'),
      secure($args['username']),
      secure($args['category']),
      secure($args['title']),
      secure($args['country'], 'int'),
      secure($args['language'], 'int'),
      secure($args['description']),
      secure($date)
    ));
    /* get group_id */
    $group_id = $db->insert_id;
    /* insert custom fields values */
    if ($custom_fields) {
      foreach ($custom_fields as $field_id => $value) {
        $db->query(sprintf("INSERT INTO custom_fields_values (value, field_id, node_id, node_type) VALUES (%s, %s, %s, 'group')", secure($value), secure($field_id, 'int'), secure($group_id, 'int')));
      }
    }
    /* join the group */
    $this->connect("group-join", $group_id);
    /* group admin addation */
    $this->connect("group-admin-addation", $group_id, $this->_data['user_id']);
    /* create group post */
    if ($args['create_post'] && in_array($args['privacy'], ['closed', 'public'])) {
      $db->query(sprintf("INSERT INTO posts (user_id, user_type, post_type, group_id, privacy, time) VALUES (%s, 'user', 'group', %s, 'public', %s)", secure($this->_data['user_id'], 'int'), secure($group_id, 'int'), secure($date)));
    }
  }


  /**
   * edit_group
   * 
   * @param integer $group_id
   * @param string $edit
   * @param array $args
   * @return void
   */
  public function edit_group($group_id, $edit, $args)
  {
    global $db, $system;
    /* check if groups enabled */
    if (!$system['groups_enabled']) {
      throw new Exception(__("The groups module has been disabled by the admin"));
    }
    /* check groups permission */
    if (!$this->_data['can_create_groups']) {
      throw new Exception(__("You don't have the permission to do this"));
    }
    /* (check&get) group */
    $get_group = $db->query(sprintf("SELECT * FROM `groups` WHERE group_id = %s", secure($group_id, 'int')));
    if ($get_group->num_rows == 0) {
      _error(403);
    }
    $group = $get_group->fetch_assoc();
    /* check permission */
    $can_edit = false;
    /* viewer is (admin|moderator) */
    if ($this->_data['user_group'] < 3) {
      $can_edit = true;
      /* viewer is the admin of group */
    } elseif ($this->check_group_adminship($this->_data['user_id'], $group_id)) {
      $can_edit = true;
    }
    if (!$can_edit) {
      _error(403);
    }
    /* edit group */
    switch ($edit) {
      case 'settings':
        /* validate title */
        if (is_empty($args['title'])) {
          throw new Exception(__("You must enter a name for your group"));
        }
        if (strlen($args['title']) < 3) {
          throw new Exception(__("Group name must be at least 3 characters long. Please try another"));
        }
        /* validate username */
        if (strtolower($args['username']) != strtolower($group['group_name'])) {
          if (is_empty($args['username'])) {
            throw new Exception(__("You must enter a web address for your group"));
          }
          if (!valid_username($args['username'])) {
            throw new Exception(__("Please enter a valid web address (a-z0-9_.) with minimum 3 characters long"));
          }
          if ($this->reserved_username($args['username'])) {
            throw new Exception(__("You can't use") . " " . $args['username'] . " " . __("as web address"));
          }
          if ($this->check_username($args['username'], 'group')) {
            throw new Exception(__("Sorry, it looks like this web address") . " " . $args['username'] . " " . __("belongs to an existing group"));
          }
          /* set new group name */
          $group['group_name'] = $args['username'];
        }
        /* validate privacy */
        if (!in_array($args['privacy'], ['secret', 'closed', 'public'])) {
          throw new Exception(__("You must select a valid privacy for your group"));
        }
        /* validate category */
        if (is_empty($args['category'])) {
          throw new Exception(__("You must select valid category for your group"));
        } else {
          if (!$this->check_category('groups_categories', $args['category'])) {
            throw new Exception(__("You must select valid category for your group"));
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
        $this->set_custom_fields($args, "group", "settings", $group_id);
        /* update the group */
        $args['chatbox_enabled'] = (isset($args['chatbox_enabled'])) ? '1' : '0';
        $args['group_publish_enabled'] = (isset($args['group_publish_enabled'])) ? '1' : '0';
        $args['group_publish_approval_enabled'] = (isset($args['group_publish_approval_enabled'])) ? '1' : '0';
        $db->query(sprintf(
          "UPDATE `groups` SET 
            group_privacy = %s, 
            group_category = %s, 
            group_name = %s, 
            group_title = %s, 
            group_country = %s, 
            group_language = %s, 
            group_description = %s, 
            chatbox_enabled = %s, 
            group_publish_enabled = %s, 
            group_publish_approval_enabled = %s 
          WHERE group_id = %s",
          secure($args['privacy']),
          secure($args['category']),
          secure($args['username']),
          secure($args['title']),
          secure($args['country'], 'int'),
          secure($args['language'], 'int'),
          secure($args['description']),
          secure($args['chatbox_enabled']),
          secure($args['group_publish_enabled']),
          secure($args['group_publish_approval_enabled']),
          secure($group_id, 'int')
        ));
        /* check if group privacy changed to public */
        if ($args['privacy'] == "public") {
          /* approve any pending join requests */
          $db->query(sprintf("UPDATE groups_members SET approved = '1' WHERE group_id = %s", secure($group_id, 'int')));
          /* update members counter + affected rows */
          $rows_count = $db->affected_rows;
          $db->query(sprintf("UPDATE `groups` SET group_members = group_members + %s  WHERE group_id = %s", secure($rows_count, 'int'), secure($group_id, 'int')));
        }
        /* check if chatbox enabled */
        if ($args['chatbox_enabled']) {
          /* create new chatbox if not */
          if (!$group['chatbox_conversation_id']) {
            $conversation_id = $this->create_chatbox($group_id, 'group');
            /* update group */
            $db->query(sprintf("UPDATE `groups` SET chatbox_conversation_id = %s WHERE group_id = %s", secure($conversation_id, 'int'), secure($group_id, 'int')));
          }
        }
        /* check if post approval disabled */
        if (!$args['group_publish_approval_enabled']) {
          /* approve any pending posts */
          $db->query(sprintf("UPDATE posts SET group_approved = '1' WHERE in_group = '1' AND group_id = %s", secure($group_id, 'int')));
        }
        break;

      case 'monetization':
        /* prepare */
        $args['group_monetization_enabled'] = (isset($args['group_monetization_enabled'])) ? '1' : '0';
        /* update group */
        $db->query(sprintf("UPDATE `groups` SET group_monetization_enabled = %s WHERE group_id = %s", secure($args['group_monetization_enabled']), secure($group_id, 'int')));
        /* update monetization plans */
        $this->update_monetization_plans($group_id, 'group');
        break;
    }
    return $group['group_name'];
  }


  /**
   * delete_group
   * 
   * @param integer $group_id
   * @return void
   */
  public function delete_group($group_id)
  {
    global $db, $system;
    /* check if groups enabled */
    if (!$system['groups_enabled']) {
      throw new Exception(__("The groups module has been disabled by the admin"));
    }
    /* check groups permission */
    if (!$this->_data['can_create_groups']) {
      throw new Exception(__("You don't have the permission to do this"));
    }
    /* (check&get) group */
    $get_group = $db->query(sprintf("SELECT * FROM `groups` WHERE group_id = %s", secure($group_id, 'int')));
    if ($get_group->num_rows == 0) {
      _error(403);
    }
    $group = $get_group->fetch_assoc();
    // delete group
    $can_delete = false;
    /* viewer is (admin|moderator) */
    if ($this->_data['user_group'] < 3) {
      $can_delete = true;
    }
    /* viewer is the super admin of group */
    if ($this->_data['user_id'] == $group['group_admin']) {
      $can_delete = true;
    }
    /* check if viewer can delete the group */
    if (!$can_delete) {
      _error(403);
    }
    /* delete the group */
    $db->query(sprintf("DELETE FROM `groups` WHERE group_id = %s", secure($group_id, 'int')));
    /* delete the group members */
    $db->query(sprintf("DELETE FROM groups_members WHERE group_id = %s", secure($group_id, 'int')));
    /* delete the group admins */
    $db->query(sprintf("DELETE FROM groups_admins WHERE group_id = %s", secure($group_id, 'int')));
    /* check if the group has chatbox */
    if ($group['chatbox_conversation_id']) {
      /* delete the chatbox */
      $this->delete_chatbox($group['chatbox_conversation_id']);
    }
  }


  /**
   * get_group_admins_ids
   * 
   * @param integer $group_id
   * @return array
   */
  public function get_group_admins_ids($group_id)
  {
    global $db;
    $admins = [];
    $get_admins = $db->query(sprintf("SELECT user_id FROM groups_admins WHERE group_id = %s", secure($group_id, 'int')));
    if ($get_admins->num_rows > 0) {
      while ($admin = $get_admins->fetch_assoc()) {
        $admins[] = $admin['user_id'];
      }
    }
    return $admins;
  }


  /**
   * get_group_admins
   * 
   * @param integer $group_id
   * @param integer $offset
   * @return array
   */
  public function get_group_admins($group_id, $offset = 0)
  {
    global $db, $system;
    $admins = [];
    $offset *= $system['max_results_even'];
    $get_admins = $db->query(sprintf("SELECT users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, users.user_subscribed, users.user_verified FROM groups_admins INNER JOIN users ON groups_admins.user_id = users.user_id WHERE groups_admins.group_id = %s LIMIT %s, %s", secure($group_id, 'int'), secure($offset, 'int', false), secure($system['max_results_even'], 'int', false)));
    if ($get_admins->num_rows > 0) {
      while ($admin = $get_admins->fetch_assoc()) {
        $admin['user_picture'] = get_picture($admin['user_picture'], $admin['user_gender']);
        /* get the connection */
        $admin['i_admin'] = true;
        $admin['connection'] = 'group_manage';
        $admin['node_id'] = $group_id;
        $admins[] = $admin;
      }
    }
    return $admins;
  }


  /**
   * get_group_members
   * 
   * @param integer $group_id
   * @param integer $offset
   * @param boolean $manage
   * @return array
   */
  public function get_group_members($group_id, $offset = 0, $manage = false)
  {
    global $db, $system;
    $members = [];
    $offset *= $system['max_results_even'];
    $get_members = $db->query(sprintf("SELECT users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, users.user_subscribed, users.user_verified FROM groups_members INNER JOIN users ON groups_members.user_id = users.user_id WHERE groups_members.approved = '1' AND groups_members.group_id = %s LIMIT %s, %s", secure($group_id, 'int'), secure($offset, 'int', false), secure($system['max_results_even'], 'int', false)));
    if ($get_members->num_rows > 0) {
      /* get group admins ids */
      $group_admins_ids = $this->get_group_admins_ids($group_id);
      while ($member = $get_members->fetch_assoc()) {
        $member['user_picture'] = get_picture($member['user_picture'], $member['user_gender']);
        if ($manage) {
          /* get the connection */
          $member['i_admin'] = in_array($member['user_id'], $group_admins_ids);
          $member['connection'] = 'group_manage';
          $member['node_id'] = $group_id;
        } else {
          /* get the connection between the viewer & the target */
          $member['connection'] = $this->connection($member['user_id']);
        }
        $members[] = $member;
      }
    }
    return $members;
  }


  /**
   * get_group_members_ids
   * 
   * @param integer $group_id
   * @return array
   */
  public function get_group_members_ids($group_id)
  {
    global $db;
    $members = [];
    $get_members = $db->query(sprintf("SELECT user_id FROM groups_members WHERE approved = '1' AND group_id = %s", secure($group_id, 'int')));
    if ($get_members->num_rows > 0) {
      while ($member = $get_members->fetch_assoc()) {
        $members[] = $member['user_id'];
      }
    }
    return $members;
  }


  /**
   * get_group_invites
   * 
   * @param integer $group_id
   * @param integer $offset
   * @return array
   */
  public function get_group_invites($group_id, $offset = 0)
  {
    global $db, $system;
    $friends = [];
    $offset *= $system['max_results_even'];
    $get_friends = $db->query(sprintf("SELECT users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, users.user_subscribed, users.user_verified FROM users LEFT JOIN groups_members ON users.user_id = groups_members.user_id AND groups_members.group_id = %s LEFT JOIN groups_invites ON users.user_id = groups_invites.user_id AND groups_invites.group_id = %s AND groups_invites.from_user_id = %s WHERE users.user_id IN (%s) AND groups_members.id IS NULL AND groups_invites.id IS NULL LIMIT %s, %s", secure($group_id, 'int'), secure($group_id, 'int'), secure($this->_data['user_id'], 'int'), $this->spread_ids($this->_data['friends_ids']), secure($offset, 'int', false), secure($system['max_results_even'], 'int', false)));
    while ($friend = $get_friends->fetch_assoc()) {
      $friend['user_picture'] = get_picture($friend['user_picture'], $friend['user_gender']);
      $friend['connection'] = 'group_invite';
      $friend['node_id'] = $group_id;
      $friends[] = $friend;
    }
    return $friends;
  }


  /**
   * check_group_invitation
   * 
   * @param integer $user_id
   * @param integer $group_id
   * @return boolean
   */
  public function check_group_invitation($user_id, $group_id)
  {
    global $db;
    $get_invitation = $db->query(sprintf("SELECT * FROM groups_invites WHERE group_id = %s AND user_id = %s", secure($group_id, 'int'), secure($user_id, 'int')));
    return ($get_invitation->num_rows > 0) ? true : false;
  }


  /**
   * get_group_requests
   * 
   * @param integer $group_id
   * @param integer $offset
   * @return array
   */
  public function get_group_requests($group_id, $offset = 0)
  {
    global $db, $system;
    $requests = [];
    $offset *= $system['max_results'];
    $get_requests = $db->query(sprintf("SELECT users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, users.user_subscribed, users.user_verified FROM users INNER JOIN groups_members ON users.user_id = groups_members.user_id WHERE groups_members.approved = '0' AND groups_members.group_id = %s LIMIT %s, %s", secure($group_id, 'int'), secure($offset, 'int', false), secure($system['max_results'], 'int', false)));
    if ($get_requests->num_rows > 0) {
      while ($request = $get_requests->fetch_assoc()) {
        $request['user_picture'] = get_picture($request['user_picture'], $request['user_gender']);
        $request['connection'] = 'group_request';
        $request['node_id'] = $group_id;
        $requests[] = $request;
      }
    }
    return $requests;
  }


  /**
   * get_group_requests_total
   * 
   * @param integer $group_id
   * @return integer
   */
  public function get_group_requests_total($group_id)
  {
    global $db, $system;
    $get_requests = $db->query(sprintf("SELECT COUNT(*) as count FROM groups_members WHERE approved = '0' AND group_id = %s", secure($group_id, 'int')));
    return $get_requests->fetch_assoc()['count'];
  }


  /**
   * check_group_adminship
   * 
   * @param integer $user_id
   * @param integer $group_id
   * @return boolean
   */
  public function check_group_adminship($user_id, $group_id)
  {
    if ($this->_logged_in) {
      /* get group admins ids */
      $group_admins_ids = $this->get_group_admins_ids($group_id);
      if (in_array($user_id, $group_admins_ids)) {
        return true;
      }
    }
    return false;
  }


  /**
   * check_group_membership
   * 
   * @param integer $user_id
   * @param integer $group_id
   * @return mixed
   */
  public function check_group_membership($user_id, $group_id)
  {
    global $db;
    if ($this->_logged_in) {
      $get_membership = $db->query(sprintf("SELECT * FROM groups_members WHERE user_id = %s AND group_id = %s", secure($user_id, 'int'), secure($group_id, 'int')));
      if ($get_membership->num_rows > 0) {
        $membership = $get_membership->fetch_assoc();
        return ($membership['approved'] == '1') ? "approved" : "pending";
      }
    }
    return false;
  }


  /**
   * get_group_pending_posts
   * 
   * @param integer $group_id
   * @param boolean $get_all
   * @return integer
   */
  public function get_group_pending_posts($group_id, $get_all = false)
  {
    global $db, $system;
    $get_all_query = ($get_all) ? "" : sprintf(" AND user_type = 'user' AND user_id = %s", secure($this->_data['user_id'], 'int'));
    $get_pending_posts = $db->query(sprintf("SELECT COUNT(*) as count FROM posts WHERE in_group = '1' AND group_approved = '0' AND group_id = %s" . $get_all_query, secure($group_id, 'int')));
    return $get_pending_posts->fetch_assoc()['count'];
  }
}
