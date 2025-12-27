<?php

/**
 * trait -> ads
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich
 */

trait AdsTrait
{

  /* ------------------------------- */
  /* Ads */
  /* ------------------------------- */

  /**
   * ads
   * 
   * @param string $place
   * @param integer $node_id
   * @return array
   */
  public function ads($place, $node_id = null)
  {
    global $db;
    $ads = [];
    /* check if the viewer is ads free */
    if ($this->_logged_in && $this->_data['ads_free']) {
      return $ads;
    }
    /* check if ads place is pages or grpups */
    $where_query = '';
    if ($node_id) {
      $node_id = secure($node_id, 'search');
      $node_id = str_replace("'%", "'%;", $node_id);
      $node_id = str_replace("%'", "&%'", $node_id);
    }
    if ($place == 'pages') {
      $where_query = sprintf('AND ads_pages_ids LIKE %s', $node_id);
    } elseif ($place == 'groups') {
      $where_query = sprintf('AND ads_groups_ids LIKE %s', $node_id);
    }
    $get_ads = $db->query(sprintf("SELECT * FROM ads_system WHERE place = %s ", secure($place)) . $where_query);
    if ($get_ads->num_rows > 0) {
      while ($ads_unit = $get_ads->fetch_assoc()) {
        $ads_unit['code'] = html_entity_decode($ads_unit['code'], ENT_QUOTES);
        $ads[] = $ads_unit;
      }
    }
    return $ads;
  }


  /**
   * ads_campaigns
   * 
   * @param string $place
   * @return array
   */
  public function ads_campaigns($place = 'sidebar')
  {
    global $db, $system, $date;
    $campaigns = [];
    /* check if ads enabled */
    if (!$system['ads_enabled']) {
      return $campaigns;
    }
    /* check if the viewer is ads free */
    if ($this->_logged_in && $this->_data['ads_free']) {
      return $campaigns;
    }
    /* get active campaigns */
    $get_campaigns = $db->query(sprintf("SELECT ads_campaigns.*, pages.page_name, `groups`.group_name, users.user_wallet_balance FROM ads_campaigns INNER JOIN users ON ads_campaigns.campaign_user_id = users.user_id LEFT JOIN pages ON ads_campaigns.ads_type = 'page' AND ads_campaigns.ads_page = pages.page_id LEFT JOIN `groups` ON ads_campaigns.ads_type = 'group' AND ads_campaigns.ads_group = `groups`.group_id WHERE ads_campaigns.campaign_is_approved = '1' AND ads_campaigns.campaign_is_active = '1' AND ads_campaigns.ads_placement = %s ORDER BY RAND()", secure($place)));
    if ($get_campaigns->num_rows > 0) {
      while ($campaign = $get_campaigns->fetch_assoc()) {
        /* check if viewer get 1 valid campaign */
        if (count($campaigns) >= 1) {
          break;
        }
        /* validate campaign */
        /* [1] -> campaign expired */
        if (strtotime($campaign['campaign_end_date']) <= strtotime($date)) {
          $db->query(sprintf("UPDATE ads_campaigns SET campaign_is_active = '0' WHERE campaign_id = %s", secure($campaign['campaign_id'], 'int')));
          continue;
        }
        $remaining = $campaign['campaign_budget'] - $campaign['campaign_spend'];
        /* [2] -> campaign remaining = 0 (spend == budget) */
        if ($remaining == 0) {
          $db->query(sprintf("UPDATE ads_campaigns SET campaign_is_active = '0' WHERE campaign_id = %s", secure($campaign['campaign_id'], 'int')));
          continue;
        }
        /* [3] -> campaign remaining > campaign's author wallet credit */
        if ($remaining > $campaign['user_wallet_balance']) {
          $db->query(sprintf("UPDATE ads_campaigns SET campaign_is_active = '0' WHERE campaign_id = %s", secure($campaign['campaign_id'], 'int')));
          continue;
        }
        /* [4] -> campaign remaining < cost per click */
        if ($remaining < $system['ads_cost_click'] && $campaign['campaign_bidding'] == "click") {
          $db->query(sprintf("UPDATE ads_campaigns SET campaign_is_active = '0' WHERE campaign_id = %s", secure($campaign['campaign_id'], 'int')));
          continue;
        }
        /* [5] -> campaign remaining < cost per view */
        if ($remaining < $system['ads_cost_view'] && $campaign['campaign_bidding'] == "view") {
          $db->query(sprintf("UPDATE ads_campaigns SET campaign_is_active = '0' WHERE campaign_id = %s", secure($campaign['campaign_id'], 'int')));
          continue;
        }
        /* check if "viewer" is campaign target audience (if logged in) */
        /* if viewer is campaign author */
        if ($this->_logged_in) {
          if (!$system['ads_author_view_enabled'] && $this->_data['user_id'] == $campaign['campaign_user_id']) {
            continue;
          }
          /* check viewer country */
          $campaign['audience_countries'] = ($campaign['audience_countries']) ? explode(',', $campaign['audience_countries']) : [];
          if ($campaign['audience_countries'] && !in_array($this->_data['user_country'], $campaign['audience_countries'])) {
            continue;
          }
          /* check viewer gender */
          if ($campaign['audience_gender'] != "all" && $this->_data['user_gender'] != $campaign['audience_gender']) {
            continue;
          }
          /* check viewer relationship */
          if ($campaign['audience_relationship'] != "all" && $this->_data['user_relationship'] != $campaign['audience_relationship']) {
            continue;
          }
        }
        /* prepare ads URL */
        switch ($campaign['ads_type']) {
          case 'post':
            /* get the post id from post ulr */
            $ads_post_url = explode('/', $campaign['ads_post_url']);
            $ads_post_id = end($ads_post_url);
            $post = $this->get_post($ads_post_id);
            if (!$post) {
              continue;
            }
            $campaign['ads_post'] = $post;
            break;

          case 'page':
            $campaign['ads_url'] = $system['system_url'] . '/pages/' . $campaign['page_name'];
            break;

          case 'group':
            $campaign['ads_url'] = $system['system_url'] . '/groups/' . $campaign['group_name'];
            break;

          case 'event':
            $campaign['ads_url'] = $system['system_url'] . '/events/' . $campaign['ads_event'];
            break;
        }
        /* update campaign if bidding = view */
        if ($campaign['campaign_bidding'] == "view") {
          /* update campaign spend & views */
          $db->query(sprintf("UPDATE ads_campaigns SET campaign_views = campaign_views + 1, campaign_spend = campaign_spend + %s WHERE campaign_id = %s", secure($system['ads_cost_view']), secure($campaign['campaign_id'], 'int')));
          /* decrease campaign author wallet balance */
          $db->query(sprintf('UPDATE users SET user_wallet_balance = IF(user_wallet_balance-%1$s<=0,0,user_wallet_balance-%1$s) WHERE user_id = %2$s', secure($system['ads_cost_view']), secure($campaign['campaign_user_id'], 'int')));
        }
        /* get campaigns */
        $campaigns[] = $campaign;
      }
    }
    return $campaigns;
  }


  /**
   * get_campaigns
   * 
   * @return array
   */
  public function get_campaigns()
  {
    global $db;
    $campaigns = [];
    $get_campaigns = $db->query(sprintf("SELECT * FROM ads_campaigns WHERE campaign_user_id = %s ORDER BY campaign_id DESC", secure($this->_data['user_id'], 'int')));
    if ($get_campaigns->num_rows > 0) {
      while ($campaign = $get_campaigns->fetch_assoc()) {
        $campaigns[] = $campaign;
      }
    }
    return $campaigns;
  }


  /**
   * get_campaign
   * 
   * @param integer $campaign_id
   * @return array
   */
  public function get_campaign($campaign_id)
  {
    global $db, $system;
    $get_campaign = $db->query(sprintf("SELECT * FROM ads_campaigns WHERE campaign_id = %s", secure($campaign_id, 'int')));
    if ($get_campaign->num_rows == 0) {
      return false;
    }
    $campaign = $get_campaign->fetch_assoc();
    /* get audience countries array */
    $campaign['audience_countries'] = ($campaign['audience_countries']) ? explode(',', $campaign['audience_countries']) : [];
    /* get campaign potential reach */
    $campaign['campaign_potential_reach'] = $this->campaign_potential_reach($campaign['audience_countries'], $campaign['audience_gender'], $campaign['audience_relationship']);
    /* prepare ads URL */
    switch ($campaign['ads_type']) {
      case 'post':
        /* get the post id from post ulr */
        $ads_post_url = explode('/', $campaign['ads_post_url']);
        $ads_post_id = end($ads_post_url);
        $post = $this->get_post($ads_post_id);
        if (!$post) {
          return false;
        }
        $campaign['ads_post'] = $post;
        break;

      case 'page':
        $campaign['ads_url'] = $system['system_url'] . '/pages/' . $campaign['page_name'];
        break;

      case 'group':
        $campaign['ads_url'] = $system['system_url'] . '/groups/' . $campaign['group_name'];
        break;

      case 'event':
        $campaign['ads_url'] = $system['system_url'] . '/events/' . $campaign['ads_event'];
        break;
    }
    return $campaign;
  }


  /**
   * create_campaign
   * 
   * @param array $args
   * @return void
   */
  public function create_campaign($args = [])
  {
    global $db, $system, $date;
    /* check if ads enabled */
    if (!$system['ads_enabled']) {
      throw new Exception(__("The ads system has been disabled by the admin"));
    }
    /* check ads permission */
    if (!$this->_data['can_create_ads']) {
      throw new Exception(__("You don't have the permission to do this"));
    }
    /* validate campaign title */
    if (is_empty($args['campaign_title'])) {
      throw new Exception(__("You have to enter the campaign title"));
    }
    /* validate campaign start & end dates (UTC) */
    if (is_empty($args['campaign_start_date'])) {
      throw new Exception(__("You have to enter the campaign start date"));
    }
    if (is_empty($args['campaign_end_date'])) {
      throw new Exception(__("You have to enter the campaign end date"));
    }
    if (strtotime(set_datetime($args['campaign_start_date'])) >= strtotime(set_datetime($args['campaign_end_date']))) {
      throw new Exception(__("Campaign end date must be after the start date"));
    }
    if (strtotime(set_datetime($args['campaign_end_date'])) <= strtotime($date)) {
      throw new Exception(__("Campaign end date must be after today datetime"));
    }
    /* validate campaign budget */
    if (is_empty($args['campaign_budget']) || !is_numeric($args['campaign_budget'])) {
      throw new Exception(__("You must enter valid budget"));
    }
    if ($args['campaign_budget'] < max($system['ads_cost_click'], $system['ads_cost_view'])) {
      throw new Exception(__("The minimum budget must be") . " " . print_money(max($system['ads_cost_click'], $system['ads_cost_view'])) . " ");
    }
    if ($this->_data['user_wallet_balance'] < $args['campaign_budget']) {
      throw new Exception(__("There is not enough credit in your wallet. Recharge your wallet to continue.") . " " . "<strong class='text-link' data-toggle='modal' data-url='#wallet-replenish'>" . __("Recharge Now") . "</strong>");
    }
    /* validate campaign bidding */
    if (!in_array($args['campaign_bidding'], ['click', 'view'])) {
      throw new Exception(__("You have to select a valid bidding"));
    }
    /* validate audience countries */
    $args['audience_countries'] = (isset($args['audience_countries']) && is_array($args['audience_countries'])) ? $this->spread_ids($args['audience_countries']) : "";
    /* validate audience gender */
    if ($args['audience_gender'] != "all" && !$this->check_gender($args['audience_gender'])) {
      throw new Exception(__("You have to select a valid gender"));
    }
    /* validate audience relationship */
    if (!isset($args['audience_relationship'])) {
      $args['audience_relationship'] = "all";
    } else {
      if (!in_array($args['audience_relationship'], ['all', 'single', 'relationship', 'married', "complicated", 'separated', 'divorced', 'widowed'])) {
        throw new Exception(__("You have to select a valid relationship"));
      }
    }
    /* validate ads type */
    switch ($args['ads_type']) {
      case 'url':
        if (is_empty($args['ads_url']) || !valid_url($args['ads_url'])) {
          throw new Exception(__("You have to enter a valid URL for your ads"));
        }
        $args['ads_post_url'] = 'null';
        $args['ads_page'] = 'null';
        $args['ads_group'] = 'null';
        $args['ads_event'] = 'null';
        break;

      case 'post':
        if (is_empty($args['ads_post_url']) || !valid_url($args['ads_post_url'])) {
          throw new Exception(__("You have to enter a valid post URL for your ads"));
        }
        /* get the post id from post ulr */
        $ads_post_url = explode('/', $args['ads_post_url']);
        $ads_post_id = end($ads_post_url);
        $post = $this->get_post($ads_post_id);
        if (!$post) {
          throw new Exception(__("The post you are trying to promote is not found"));
        }
        $args['ads_url'] = 'null';
        $args['ads_page'] = 'null';
        $args['ads_group'] = 'null';
        $args['ads_event'] = 'null';
        $args['ads_placement'] = 'newsfeed';
        $args['ads_image'] = '';
        $args['ads_video'] = '';
        break;

      case 'page':
        if ($args['ads_page'] == "none") {
          throw new Exception(__("You have to select one for your pages for your ads"));
        }
        $args['ads_url'] = 'null';
        $args['ads_post_url'] = 'null';
        $args['ads_group'] = 'null';
        $args['ads_event'] = 'null';
        break;

      case 'group':
        if ($args['ads_group'] == "none") {
          throw new Exception(__("You have to select one for your groups for your ads"));
        }
        $args['ads_url'] = 'null';
        $args['ads_post_url'] = 'null';
        $args['ads_page'] = 'null';
        $args['ads_event'] = 'null';
        break;

      case 'event':
        if ($args['ads_event'] == "none") {
          throw new Exception(__("You have to select one for your events for your ads"));
        }
        $args['ads_url'] = 'null';
        $args['ads_post_url'] = 'null';
        $args['ads_page'] = 'null';
        $args['ads_group'] = 'null';
        break;

      default:
        throw new Exception(__("You have to select a valid ads type"));
        break;
    }
    /* validate ads placement */
    if (!in_array($args['ads_placement'], ['newsfeed', 'sidebar'])) {
      throw new Exception(__("You have to select a valid ads placement"));
    }
    /* validate ads image */
    if ($args['ads_type'] != 'post' && is_empty($args['ads_image']) && is_empty($args['ads_video'])) {
      throw new Exception(__("You have to upload an image or video for your ads"));
    }
    /* approval system */
    $campaign_is_approved = ($system['ads_approval_enabled']) ? '0' : '1';
    /* insert new campain */
    $db->query(sprintf(
      "INSERT INTO ads_campaigns (
            campaign_user_id, 
            campaign_title, 
            campaign_start_date, 
            campaign_end_date, 
            campaign_budget, 
            campaign_bidding, 
            audience_countries, 
            audience_gender, 
            audience_relationship, 
            ads_title, 
            ads_description, 
            ads_type, 
            ads_url, 
            ads_post_url, 
            ads_page, 
            ads_group, 
            ads_event, 
            ads_placement, 
            ads_image, 
            ads_video,
            campaign_created_date, 
            campaign_is_approved) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)",
      secure($this->_data['user_id'], 'int'),
      secure($args['campaign_title']),
      secure($args['campaign_start_date'], 'datetime'),
      secure($args['campaign_end_date'], 'datetime'),
      secure($args['campaign_budget']),
      secure($args['campaign_bidding']),
      secure($args['audience_countries']),
      secure($args['audience_gender']),
      secure($args['audience_relationship']),
      secure($args['ads_title']),
      secure($args['ads_description']),
      secure($args['ads_type']),
      secure($args['ads_url']),
      secure($args['ads_post_url']),
      secure($args['ads_page']),
      secure($args['ads_group']),
      secure($args['ads_event']),
      secure($args['ads_placement']),
      secure($args['ads_image']),
      secure($args['ads_video']),
      secure($date),
      secure($campaign_is_approved)
    ));
    /* send notification to admins */
    if ($system['ads_approval_enabled']) {
      $this->notify_system_admins("ads_campaign_added");
    }
    /* remove pending uploads */
    remove_pending_uploads([$args['ads_image'], $args['ads_video']]);
  }


  /**
   * edit_campaign
   * 
   * @param integer $campaign_id
   * @param array $args
   * @return void
   */
  public function edit_campaign($campaign_id, $args)
  {
    global $db, $system, $date;
    /* check if ads enabled */
    if ($this->_data['user_group'] >= 3 && !$system['ads_enabled']) {
      throw new Exception(__("The ads system has been disabled by the admin"));
    }
    /* (check&get) campaign */
    $get_campaign = $db->query(sprintf("SELECT ads_campaigns.*, users.user_wallet_balance FROM ads_campaigns INNER JOIN users ON ads_campaigns.campaign_user_id = users.user_id WHERE ads_campaigns.campaign_id = %s", secure($campaign_id, 'int')));
    if ($get_campaign->num_rows == 0) {
      _error(403);
    }
    $campaign = $get_campaign->fetch_assoc();
    /* check permission */
    $can_edit = false;
    /* viewer is (admin|moderator) */
    if ($this->_data['user_group'] < 3) {
      $can_edit = true;
      /* viewer is the creator of campaign */
    } elseif ($this->_data['user_id'] == $campaign['campaign_user_id']) {
      $can_edit = true;
    }
    /* edit the campaign */
    if (!$can_edit) {
      _error(403);
    }
    /* validate campaign title */
    if (is_empty($args['campaign_title'])) {
      throw new Exception(__("You have to enter the campaign title"));
    }
    /* validate campaign start & end dates */
    if (is_empty($args['campaign_start_date'])) {
      throw new Exception(__("You have to enter the campaign start date"));
    }
    if (is_empty($args['campaign_end_date'])) {
      throw new Exception(__("You have to enter the campaign end date"));
    }
    if (strtotime(set_datetime($args['campaign_start_date'])) > strtotime(set_datetime($args['campaign_end_date']))) {
      throw new Exception(__("Campaign end date must be after the start date"));
    }
    if (strtotime(set_datetime($args['campaign_end_date'])) <= strtotime($date)) {
      throw new Exception(__("Campaign end date must be after today datetime"));
    }
    /* validate campaign budget */
    if (is_empty($args['campaign_budget']) || !is_numeric($args['campaign_budget'])) {
      throw new Exception(__("You must enter valid budget"));
    }
    $remaining = $args['campaign_budget'] - $campaign['campaign_spend']; // campaign remaining (budget(new) - spend)
    if ($remaining == 0) {
      throw new Exception(__("The campaign total spend reached the campaign budget already, increase the campaign budget to resume the campaign"));
    }
    if ($remaining > $campaign['user_wallet_balance']) {
      throw new Exception(__("The remaining spend is larger than current wallet credit") . " " . print_money($campaign['user_wallet_balance']) . " " . __("You need to") . " " . __("Replenish wallet credit"));
    }
    /* validate campaign bidding */
    if (!in_array($args['campaign_bidding'], ['click', 'view'])) {
      throw new Exception(__("You have to select a valid bidding"));
    }
    if ($args['campaign_bidding'] == "click") {
      if ($remaining < $system['ads_cost_click']) {
        throw new Exception(__("The cost per click is larger than your campaign remaining spend") . " " . print_money($remaining) . " " . __("increase the campaign budget to resume the campaign"));
      }
    }
    if ($args['campaign_bidding'] == "view") {
      if ($remaining < $system['ads_cost_view']) {
        throw new Exception(__("The cost per view is larger than your campaign remaining spend") . " " . print_money($remaining) . " " . __("increase the campaign budget to resume the campaign"));
      }
    }
    /* validate audience countries */
    $args['audience_countries'] = (isset($args['audience_countries']) && is_array($args['audience_countries'])) ? $this->spread_ids($args['audience_countries']) : "";
    /* validate audience gender */
    if ($args['audience_gender'] != "all" && !$this->check_gender($args['audience_gender'])) {
      throw new Exception(__("You have to select a valid gender"));
    }
    /* validate audience relationship */
    if (!isset($args['audience_relationship'])) {
      $args['audience_relationship'] = "all";
    } else {
      if (!in_array($args['audience_relationship'], ['all', 'single', 'relationship', 'married', "complicated", 'separated', 'divorced', 'widowed'])) {
        throw new Exception(__("You have to select a valid relationship"));
      }
    }
    /* validate ads type */
    switch ($args['ads_type']) {
      case 'url':
        if (is_empty($args['ads_url']) || !valid_url($args['ads_url'])) {
          throw new Exception(__("You have to enter a valid URL for your ads"));
        }
        $args['ads_page'] = 'null';
        $args['ads_group'] = 'null';
        $args['ads_event'] = 'null';
        break;

      case 'post':
        if (is_empty($args['ads_post_url']) || !valid_url($args['ads_post_url'])) {
          throw new Exception(__("You have to enter a valid post URL for your ads"));
        }
        $args['ads_url'] = 'null';
        $args['ads_page'] = 'null';
        $args['ads_group'] = 'null';
        $args['ads_event'] = 'null';
        $args['ads_placement'] = 'newsfeed';
        $args['ads_image'] = '';
        $args['ads_video'] = '';
        break;

      case 'page':
        if ($args['ads_page'] == "none") {
          throw new Exception(__("You have to select one for your pages for your ads"));
        }
        $args['ads_url'] = 'null';
        $args['ads_group'] = 'null';
        $args['ads_event'] = 'null';
        break;

      case 'group':
        if ($args['ads_group'] == "none") {
          throw new Exception(__("You have to select one for your groups for your ads"));
        }
        $args['ads_url'] = 'null';
        $args['ads_page'] = 'null';
        $args['ads_event'] = 'null';
        break;

      case 'event':
        if ($args['ads_event'] == "none") {
          throw new Exception(__("You have to select one for your events for your ads"));
        }
        $args['ads_url'] = 'null';
        $args['ads_page'] = 'null';
        $args['ads_group'] = 'null';
        break;

      default:
        throw new Exception(__("You have to select a valid ads type"));
        break;
    }
    /* validate ads placement */
    if (!in_array($args['ads_placement'], ['newsfeed', 'sidebar'])) {
      throw new Exception(__("You have to select a valid ads placement"));
    }
    /* validate ads image */
    if ($args['ads_type'] != 'post' && is_empty($args['ads_image']) && is_empty($args['ads_video'])) {
      throw new Exception(__("You have to upload an image for your ads"));
    }
    /* approval system */
    $campaign_is_approved = ($system['ads_approval_enabled']) ? '0' : '1';
    /* update the campain */
    $db->query(sprintf(
      "UPDATE ads_campaigns SET 
            campaign_title = %s, 
            campaign_start_date = %s, 
            campaign_end_date = %s, 
            campaign_budget = %s, 
            campaign_bidding = %s, 
            audience_countries = %s, 
            audience_gender = %s, 
            audience_relationship = %s, 
            ads_title = %s, 
            ads_description = %s, 
            ads_type = %s, 
            ads_url = %s, 
            ads_page = %s, 
            ads_group = %s, 
            ads_event = %s, 
            ads_placement = %s, 
            ads_image = %s, 
            ads_video = %s,
            campaign_is_active = '1', 
            campaign_is_approved = %s WHERE campaign_id = %s",
      secure($args['campaign_title']),
      secure($args['campaign_start_date'], 'datetime'),
      secure($args['campaign_end_date'], 'datetime'),
      secure($args['campaign_budget']),
      secure($args['campaign_bidding']),
      secure($args['audience_countries']),
      secure($args['audience_gender']),
      secure($args['audience_relationship']),
      secure($args['ads_title']),
      secure($args['ads_description']),
      secure($args['ads_type']),
      secure($args['ads_url']),
      secure($args['ads_page']),
      secure($args['ads_group']),
      secure($args['ads_event']),
      secure($args['ads_placement']),
      secure($args['ads_image']),
      secure($args['ads_video']),
      secure($campaign_is_approved),
      secure($campaign_id, 'int')
    ));
    /* send notification to admins */
    if ($system['ads_approval_enabled']) {
      $this->notify_system_admins("ads_campaign_edited");
    }
    /* remove pending uploads */
    remove_pending_uploads([$args['ads_image'], $args['ads_video']]);
  }


  /**
   * delete_campaign
   * 
   * @param integer $campaign_id
   * @return void
   */
  public function delete_campaign($campaign_id)
  {
    global $db, $system;
    /* check if ads enabled */
    if ($this->_data['user_group'] >= 3 && !$system['ads_enabled']) {
      throw new Exception(__("The ads system has been disabled by the admin"));
    }
    /* (check&get) campaign */
    $get_campaign = $db->query(sprintf("SELECT * FROM ads_campaigns WHERE campaign_id = %s", secure($campaign_id, 'int')));
    if ($get_campaign->num_rows == 0) {
      _error(403);
    }
    $campaign = $get_campaign->fetch_assoc();
    // delete campaign
    $can_delete = false;
    /* viewer is (admin|moderator) */
    if ($this->_data['user_group'] < 3) {
      $can_delete = true;
      /* viewer is the creator of campaign */
    } elseif ($this->_data['user_id'] == $campaign['campaign_user_id']) {
      $can_delete = true;
    }
    /* delete the campaign */
    if (!$can_delete) {
      _error(403);
    }
    $db->query(sprintf("DELETE FROM ads_campaigns WHERE campaign_id = %s", secure($campaign_id, 'int')));
    /* delete ads image if exists */
    delete_uploads_file($campaign['ads_image']);
    /* delete ads video if exists */
    delete_uploads_file($campaign['ads_video']);
  }


  /**
   * update_campaign_status
   * 
   * @param integer $campaign_id
   * @param boolean $is_active
   * @return void
   */
  public function update_campaign_status($campaign_id, $is_active)
  {
    global $db, $system, $date;
    /* check if ads enabled */
    if ($this->_data['user_group'] >= 3 && !$system['ads_enabled']) {
      throw new Exception(__("The ads system has been disabled by the admin"));
    }
    /* (check&get) campaign */
    $get_campaign = $db->query(sprintf("SELECT ads_campaigns.*, users.user_wallet_balance FROM ads_campaigns INNER JOIN users ON ads_campaigns.campaign_user_id = users.user_id WHERE ads_campaigns.campaign_id = %s", secure($campaign_id, 'int')));
    if ($get_campaign->num_rows == 0) {
      _error(403);
    }
    $campaign = $get_campaign->fetch_assoc();
    // change campaign status
    $can_edit = false;
    /* viewer is (admin|moderator) */
    if ($this->_data['user_group'] < 3) {
      $can_edit = true;
      /* viewer is the creator of campaign */
    } elseif ($this->_data['user_id'] == $campaign['campaign_user_id']) {
      $can_edit = true;
    }
    /* change campaign status */
    if (!$can_edit) {
      _error(403);
    }
    /* check approval system */
    if (!$campaign['campaign_is_approved']) {
      throw new Exception(__("You can't do this till your campaign gets admin approval"));
    }
    $is_active = ($is_active) ? '1' : '0';
    if ($is_active) {
      /* validate campaign */
      if (strtotime($campaign['campaign_end_date']) <= strtotime($date)) {
        throw new Exception(__("Campaign end date must be after today datetime"));
      }
      $remaining = $campaign['campaign_budget'] - $campaign['campaign_spend']; // campaign remaining (budget - spend)
      if ($remaining == 0) {
        throw new Exception(__("The campaign total spend reached the campaign budget already, increase the campaign budget to resume the campaign"));
      }
      if ($remaining > $campaign['user_wallet_balance']) {
        throw new Exception(__("The remaining spend is larger than current wallet credit") . " " . print_money($campaign['user_wallet_balance']) . " " . __("You need to") . " " . __("Replenish wallet credit"));
      }
      if ($campaign['campaign_bidding'] == "click") {
        if ($remaining < $system['ads_cost_click']) {
          throw new Exception(__("The cost per click is larger than your campaign remaining spend") . " " . print_money($remaining) . " " . __("increase the campaign budget to resume the campaign"));
        }
      }
      if ($campaign['campaign_bidding'] == "view") {
        if ($remaining < $system['ads_cost_view']) {
          throw new Exception(__("The cost per view is larger than your campaign remaining spend") . " " . print_money($remaining) . " " . __("increase the campaign budget to resume the campaign"));
        }
      }
    }
    $db->query(sprintf("UPDATE ads_campaigns SET campaign_is_active = %s WHERE campaign_id = %s", secure($is_active), secure($campaign_id, 'int')));
  }


  /**
   * update_campaign_bidding
   * 
   * @param integer $campaign_id
   * @return void
   */
  public function update_campaign_bidding($campaign_id)
  {
    global $db, $system, $date;
    /* check if ads enabled */
    if (!$system['ads_enabled']) {
      return;
    }
    /* (check&get) campaign */
    $get_campaign = $db->query(sprintf("SELECT ads_campaigns.*, users.user_wallet_balance FROM ads_campaigns INNER JOIN users ON ads_campaigns.campaign_user_id = users.user_id WHERE ads_campaigns.campaign_id = %s", secure($campaign_id, 'int')));
    if ($get_campaign->num_rows == 0) {
      _error(403);
    }
    $campaign = $get_campaign->fetch_assoc();
    // update campaign if bidding = click
    if ($campaign['campaign_bidding'] == "click") {
      /* update campaign spend & clicks */
      $db->query(sprintf("UPDATE ads_campaigns SET campaign_clicks = campaign_clicks + 1, campaign_spend = campaign_spend + %s WHERE campaign_id = %s", secure($system['ads_cost_click']), secure($campaign['campaign_id'], 'int')));
      /* decrease campaign author wallet balance */
      $db->query(sprintf('UPDATE users SET user_wallet_balance = IF(user_wallet_balance-%1$s<=0,0,user_wallet_balance-%1$s) WHERE user_id = %2$s', secure($system['ads_cost_click']), secure($campaign['campaign_user_id'], 'int')));
    }
  }


  /**
   * campaign_estimated_reach
   * 
   * @param array $countries
   * @param string $gender
   * @param string $relationship
   * @return integer
   */
  public function campaign_potential_reach($countries = [], $gender = 'all', $relationship = 'all')
  {
    global $db, $system;
    $results = 0;
    /* validate gender */
    if ($gender != "all" && !$this->check_gender($gender)) {
      return $results;
    }
    /* validate relationship */
    $relationship = ($system['relationship_info_enabled']) ? $relationship : 'all';
    if (isset($relationship) && !in_array($relationship, ['all', 'single', 'relationship', 'married', "complicated", 'separated', 'divorced', 'widowed'])) {
      return $results;
    }
    /* prepare where statement */
    $where = "";
    /* validate countries */
    if ($countries) {
      if (!is_array($countries) || !is_numeric(implode('', $countries))) {
        return $results;
      }
      foreach ($countries as $key => $country) {
        if (!$this->check_country($country)) {
          unset($countries[$key]);
        }
      }
      if (count($countries) == 0) {
        return $results;
      }
      $countries_list = $this->spread_ids($countries);
      $where .= " WHERE user_country IN ($countries_list)";
    }
    /* gender */
    if ($gender != "all") {
      if ($where) {
        $where .= " AND user_gender = '$gender'";
      } else {
        $where .= " WHERE user_gender = '$gender'";
      }
    }
    /* relationship */
    if ($relationship != "all") {
      if ($where) {
        $where .= " AND user_relationship = '$relationship'";
      } else {
        $where .= " WHERE user_relationship = '$relationship'";
      }
    }
    /* get users */
    $get_users = $db->query("SELECT COUNT(*) as count FROM users" . $where);
    $results = $get_users->fetch_assoc()['count'];
    return $results;
  }
}
