<?php

/**
 * trait -> livestream
 * 
 * @package Sngine
 * @author Zamblek
 */

trait LiveStreamTrait
{

  /* ------------------------------- */
  /* Live Stream */
  /* ------------------------------- */

  /**
   * get_live_posts
   * 
   * @param array $args
   * @return array
   */
  public function get_live_posts($args = [])
  {
    global $db, $system;
    /* initialize vars */
    $posts = [];
    $this->_cursor = null;
    /* validate arguments */
    $view = (isset($args['view']) && in_array($args['view'], ["following", "manage"])) ? $args['view'] : "discover";
    $status = (isset($args['status']) && $args['status'] == "ended") ? "ended" : "live";
    $category_id = (isset($args['category_id']) && is_numeric($args['category_id'])) ? $args['category_id'] : null;
    $country_id = (isset($args['country_id']) && is_numeric($args['country_id'])) ? $args['country_id'] : null;
    $query = (isset($args['query']) && !is_empty($args['query'])) ? secure($args['query'], 'search') : null;
    $max_results = $system['live_results'];
    $offset = (isset($args['offset']) && is_numeric($args['offset'])) ? $args['offset'] : 0;
    $offset *= $max_results;
    /* prepare query */
    $where_query = "WHERE posts.post_type = 'live' AND posts.in_group = '0' AND posts.in_event = '0'";
    $where_query .= ($status == "ended") ? " AND posts_live.live_ended = '1'" : " AND posts_live.live_ended = '0'";
    switch ($view) {
      case 'manage':
        if (!$this->_logged_in) {
          return $posts;
        }
        $where_query .= sprintf(" AND posts.user_id = %s AND posts.user_type = 'user'", secure($this->_data['user_id'], 'int'));
        break;

      case 'following':
        if (!$this->_logged_in) {
          return $posts;
        }
        $me = secure($this->_data['user_id'], 'int');
        $where_query .= " AND (";
        /* viewer own lives */
        $where_query .= "(posts.user_id = $me AND posts.user_type = 'user')";
        /* friends lives */
        $where_query .= sprintf(" OR (posts.user_id IN (%s) AND posts.user_type = 'user' AND posts.privacy = 'friends')", $this->spread_ids($this->get_friends_followings_ids()));
        /* followings lives */
        $where_query .= sprintf(" OR (posts.user_id IN (%s) AND posts.user_type = 'user' AND posts.privacy = 'public')", $this->spread_ids($this->followings_ids()));
        /* liked pages lives */
        $where_query .= sprintf(" OR (posts.user_id IN (%s) AND posts.user_type = 'page')", $this->spread_ids($this->get_pages_ids()));
        $where_query .= ")";
        break;

      default:
        $where_query .= " AND posts.privacy = 'public'";
        break;
    }
    /* filter by category (with its sub-categories) */
    if ($category_id) {
      $categories_ids = [$category_id];
      $sub_categories = $this->get_sub_categories("posts_live_categories", $category_id);
      if ($sub_categories) {
        array_walk_recursive($sub_categories, function ($value, $key) use (&$categories_ids) {
          if ($key == "category_id") {
            $categories_ids[] = $value;
          }
        });
      }
      $where_query .= sprintf(" AND posts_live.category_id IN (%s)", $this->spread_ids($categories_ids));
    }
    /* search by title & description */
    if ($query) {
      $where_query .= " AND " . $this->posts_search_clause($args['query'], "(posts_live.live_title LIKE $query OR posts.text LIKE $query)");
    }
    /* exclude viewer hidden posts */
    if ($this->_logged_in) {
      $where_query .= sprintf(" AND (posts.post_id NOT IN (SELECT post_id FROM posts_hidden WHERE user_id = %s))", secure($this->_data['user_id'], 'int'));
    }
    /* exclude banned users posts */
    $author_join = " LEFT JOIN users AS user_post_author ON posts.user_type = 'user' AND posts.user_id = user_post_author.user_id LEFT JOIN pages AS page_post_author ON posts.user_type = 'page' AND posts.user_id = page_post_author.page_id ";
    $where_query .= " AND (posts.user_type != 'user' OR IFNULL(user_post_author.user_banned, 0) = 0)";
    /* filter by country */
    if ($country_id && $system['newsfeed_location_filter_enabled']) {
      $where_query .= sprintf(" AND ( (posts.user_type = 'user' AND user_post_author.user_country = %s) OR (posts.user_type = 'page' AND page_post_author.page_country = %s) )", secure($country_id, 'int'), secure($country_id, 'int'));
    }
    /* prepare approval system */
    if ($system['posts_approval_enabled'] && $view != "manage") {
      $where_query .= " AND (posts.pre_approved = '1' OR posts.has_approved = '1')";
    }
    /* get posts (pages after the first continue from a cursor, the last post id, instead of an offset) */
    $cursor = cursor_decode($args['cursor'] ?? null, ['int']);
    if ($cursor) {
      $where_query .= " AND " . cursor_where(['posts.post_id'], $cursor);
    }
    $limit_query = ($cursor) ? sprintf(" LIMIT %s", secure($max_results, 'int', false)) : sprintf(" LIMIT %s, %s", secure($offset, 'int', false), secure($max_results, 'int', false));
    $get_posts = $db->query("SELECT posts.post_id FROM posts INNER JOIN posts_live ON posts.post_id = posts_live.post_id " . $author_join . $where_query . " ORDER BY posts.post_id DESC" . $limit_query);
    if ($get_posts->num_rows > 0) {
      while ($post = $get_posts->fetch_assoc()) {
        $last_read_id = $post['post_id'];
        $post = $this->get_post($post['post_id'], false, true);
        if ($post) {
          $posts[] = $post;
        }
      }
    }
    $this->_cursor = (isset($last_read_id)) ? cursor_encode([$last_read_id]) : null;
    return $posts;
  }


  /**
   * create_live_post
   * 
   * @param array $args
   * @return integer
   */
  public function create_live_post($args = [])
  {
    global $db, $system, $date;
    /* check if live enabled */
    if (!$system['live_enabled']) {
      throw new Exception(__("The live feature has been disabled by the admin"));
    }
    /* check live permission */
    if (!$this->_data['can_go_live']) {
      throw new Exception(__("You don't have the permission to do this"));
    }
    /* prepare inputs */
    $node = $args['node'] ?? null;
    $node_id = $args['node_id'] ?? null;
    /* validate title */
    $live_title = trim($args['title'] ?? '');
    if (is_empty($live_title)) {
      throw new Exception(__("Please enter a title for your live stream"));
    }
    if (mb_strlen($live_title) > 100) {
      throw new Exception(__("Title must be less than 100 characters long"));
    }
    /* validate description */
    $description = trim($args['description'] ?? '');
    if (mb_strlen($description) > 500) {
      throw new Exception(__("Description must be less than 500 characters long"));
    }
    /* validate category */
    $category_id = 0;
    if (isset($args['category_id']) && $this->check_category("posts_live_categories", $args['category_id'])) {
      $category_id = $args['category_id'];
    } else {
      $get_default_category = $db->query("SELECT category_id FROM posts_live_categories WHERE category_parent_id = 0 ORDER BY category_order ASC LIMIT 1");
      if ($get_default_category->num_rows > 0) {
        $category_id = $get_default_category->fetch_assoc()['category_id'];
      }
    }
    /* get live provider */
    $live_provider = ($system['live_provider'] == "livekit") ? "livekit" : "agora";
    /* validate broadcast type */
    $broadcast_type = (isset($args['broadcast_type']) && $args['broadcast_type'] == "rtmp") ? "rtmp" : "camera";
    $livekit_ingress_id = null;
    if ($broadcast_type == "rtmp") {
      if ($live_provider != "livekit" || !$system['live_rtmp_enabled']) {
        throw new Exception(__("You don't have the permission to do this"));
      }
      /* get the streaming software room */
      $get_ingress = $db->query(sprintf("SELECT * FROM live_ingresses WHERE user_id = %s", secure($this->_data['user_id'], 'int')));
      if ($get_ingress->num_rows == 0) {
        throw new Exception(__("Please connect your streaming software first"));
      }
      $ingress = $get_ingress->fetch_assoc();
      if (!$ingress['ingress_room']) {
        throw new Exception(__("Please connect your streaming software first"));
      }
      $args['channel_name'] = $ingress['ingress_room'];
      $livekit_ingress_id = $ingress['ingress_id'];
    }
    $channel_name = $args['channel_name'] ?? '';
    if (is_empty($channel_name)) {
      _error(400);
    }
    if ($live_provider == "agora") {
      /* get agora recorder (uid|token) */
      $agora_recorder = $this->agora_token_builder(false, $channel_name);
      $agora_uid = $agora_recorder['uid'];
      $agora_token = $agora_recorder['token'];
    }
    /* prepare the post */
    $post['user_id'] = $this->_data['user_id'];
    $post['user_type'] = "user";
    $post['privacy'] = (isset($args['privacy']) && $args['privacy'] == "friends") ? 'friends' : 'public';
    $post['in_group'] = 0;
    $post['group_id'] = null;
    $post['group_approved'] = 0;
    $post['in_event'] = 0;
    $post['event_id'] = null;
    $post['event_approved'] = 0;
    $post['tips_enabled'] = ($node != 'page' && $this->_data['can_receive_tip'] && ($args['tips_enabled'] ?? '') == "true") ? '1' : '0';
    $post['for_subscriptions'] = (($args['for_subscriptions'] ?? '') == "true") ? '1' : '0';
    $post['is_paid'] = (($args['is_paid'] ?? '') == "true") ? '1' : '0';
    $post['post_price'] = ($post['is_paid']) ? ($args['post_price'] ?? 0) : 0;
    /* check paid post price */
    if ($post['is_paid'] && $post['post_price'] <= 0) {
      throw new Exception(__("Please enter a valid price"));
    }
    /* check if both for_subscriptions & is_paid enabled */
    if ($post['for_subscriptions'] && $post['is_paid']) {
      throw new Exception(__("You can't enable both subscriptions & paid post at the same time"));
    }
    /* check if node is set */
    if (!$node) {
      /* check monetization permission */
      if ($post['for_subscriptions'] || $post['is_paid']) {
        /* check if user has monetization enabled */
        if (!($this->_data['can_monetize_content'] && $this->_data['user_monetization_enabled'])) {
          modal("ERROR", __("Sorry"), __("You don't have the permission to do this"));
        }
        /* check if user has subscriptions plans */
        if ($post['for_subscriptions'] && $this->_data['user_monetization_plans'] <= 0) {
          modal("ERROR", __("Sorry"), __("You don't have the permission to do this"));
        }
      }
    } else {
      switch ($node) {
        case 'page':
          /* check if the page is valid */
          $page = $this->get_page($node_id);
          if (!$page) {
            _error(400);
          }
          /* check if the viewer is page admin */
          if (!$this->check_page_adminship($this->_data['user_id'], $node_id)) {
            _error(400);
          }
          /* check monetization permission */
          if ($post['for_subscriptions'] || $post['is_paid']) {
            /* check if page's admin can monetize content */
            $page['can_monetize_content'] = $system['monetization_enabled'] && $this->check_user_permission($page['page_admin'], 'monetization_permission');
            /* check if page has monetization enabled && subscriptions plans */
            if (!($page['can_monetize_content'] && $page['page_monetization_enabled'] && $page['page_monetization_plans'] > 0)) {
              modal("ERROR", __("Sorry"), __("You don't have the permission to do this"));
            }
            if ($post['for_subscriptions'] && $page['page_monetization_plans'] <= 0) {
              modal("ERROR", __("Sorry"), __("You don't have the permission to do this"));
            }
          }
          $post['user_id'] = $page['page_id'];
          $post['user_type'] = "page";
          $post['privacy'] = 'public';
          break;

        case 'group':
          /* check if the group is valid */
          $group = $this->get_group($node_id);
          if (!$group) {
            _error(400);
          }
          /* check if the viewer joined the group */
          if (!$this->check_group_membership($this->_data['user_id'], $group['group_id'])) {
            _error(400);
          }
          /* check if the viewer is group admin */
          $group['i_admin'] = $this->check_group_adminship($this->_data['user_id'], $group['group_id']);
          /* check if group publish enabled */
          if (!$group['group_publish_enabled'] && !$group['i_admin']) {
            modal("ERROR", __("Sorry"), __("Publish posts disabled by admin"));
          }
          /* check monetization permission */
          if ($post['for_subscriptions'] || $post['is_paid']) {
            /* check if group's admin can monetize content */
            $group['can_monetize_content'] = $system['monetization_enabled'] && $this->check_user_permission($group['group_admin'], 'monetization_permission');
            /* check if group has monetization enabled && subscriptions plans */
            if (!($group['can_monetize_content'] && $group['group_monetization_enabled'])) {
              modal("ERROR", __("Sorry"), __("You don't have the permission to do this"));
            }
            if ($post['for_subscriptions'] && $group['group_monetization_plans'] <= 0) {
              modal("ERROR", __("Sorry"), __("You don't have the permission to do this"));
            }
          }
          $post['privacy'] = 'custom';
          $post['in_group'] = 1;
          $post['group_id'] = $node_id;
          $post['group_approved'] = ($group['group_publish_approval_enabled'] && !$group['i_admin']) ? '0' : '1';
          break;

        case 'event':
          /* check if the event is valid */
          $event = $this->get_event($node_id);
          if (!$event) {
            _error(400);
          }
          /* check if the viewer is event member */
          if (!$this->check_event_membership($this->_data['user_id'], $node_id)) {
            _error(400);
          }
          /* check if the viewer is event admin */
          $event['i_admin'] = $this->check_event_adminship($this->_data['user_id'], $event['event_id']);
          /* check if event publish enabled */
          if (!$event['event_publish_enabled'] && !$event['i_admin']) {
            modal("ERROR", __("Sorry"), __("Publish posts disabled by admin"));
          }
          $post['privacy'] = 'custom';
          $post['in_event'] = 1;
          $post['event_id'] = $node_id;
          $post['event_approved'] = ($event['event_publish_approval_enabled'] && !$event['i_admin']) ? '0' : '1';
          break;
      }
    }
    /* prepare live video thumbnail */
    $video_thumbnail = (!is_empty($args['video_thumbnail'] ?? '') && $args['video_thumbnail'] != 'data:,') ? save_picture_from_url($args['video_thumbnail']) : '';
    /* insert post */
    $db->query(sprintf("INSERT INTO posts (user_id, user_type, post_type, in_group, group_id, group_approved, in_event, event_id, event_approved, text, tips_enabled, for_subscriptions, is_paid, post_price, privacy, time) VALUES (%s, %s, 'live', %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)", secure($post['user_id'], 'int'), secure($post['user_type']), secure($post['in_group']), secure($post['group_id'], 'int'), secure($post['group_approved']), secure($post['in_event']), secure($post['event_id'], 'int'), secure($post['event_approved']), secure($description), secure($post['tips_enabled']), secure($post['for_subscriptions']), secure($post['is_paid']), secure($post['post_price'], 'float'), secure($post['privacy']), secure($date)));
    $post_id = $db->insert_id;
    /* insert live */
    if ($live_provider == "livekit") {
      $db->query(sprintf("INSERT INTO posts_live (post_id, category_id, live_title, broadcast_type, live_provider, video_thumbnail, agora_uid, agora_channel_name, livekit_room, livekit_ingress_id) VALUES (%s, %s, %s, %s, 'livekit', %s, 0, '', %s, %s)", secure($post_id, 'int'), secure($category_id, 'int'), secure($live_title), secure($broadcast_type), secure($video_thumbnail), secure($channel_name), secure($livekit_ingress_id)));
    } else {
      $db->query(sprintf("INSERT INTO posts_live (post_id, category_id, live_title, broadcast_type, live_provider, video_thumbnail, agora_uid, agora_channel_name) VALUES (%s, %s, %s, 'camera', 'agora', %s, %s, %s)", secure($post_id, 'int'), secure($category_id, 'int'), secure($live_title), secure($video_thumbnail), secure($agora_uid, 'int'), secure($channel_name)));
    }
    $this->refresh_post_search($post_id);
    // [BACKGROUND PROCESS]
    /* return async */
    return_json_async(['post_id' => $post_id]);
    /* start live recording */
    if ($system['save_live_enabled']) {
      if ($live_provider == "livekit") {
        $this->_livekit_start_recording($post_id, $channel_name);
      } else {
        $this->_agora_start_recording($post_id, $agora_uid, $agora_token, $channel_name);
      }
    }
    /* notify all audience */
    switch ($node) {
      case 'page':
        /* notify page memebers */
        foreach ($this->get_page_members_ids($node_id) as $member_id) {
          $this->post_notification(['to_user_id' => $member_id, 'from_user_id' => $node_id, 'from_user_type' => 'page', 'action' => 'live_stream', 'node_type' => 'post', 'node_url' => $post_id]);
        }
        break;

      case 'group':
        /* notify group memebers */
        foreach ($this->get_group_members_ids($node_id) as $member_id) {
          $this->post_notification(['to_user_id' => $member_id, 'action' => 'live_stream', 'node_type' => 'post', 'node_url' => $post_id]);
        }
        break;

      case 'event':
        /* notify event memebers */
        foreach ($this->get_event_members_ids($node_id) as $member_id) {
          $this->post_notification(['to_user_id' => $member_id, 'action' => 'live_stream', 'node_type' => 'post', 'node_url' => $post_id]);
        }
        break;

      default:
        /* notify friends & followers (based on the audience) */
        if ($post['privacy'] == "friends") {
          $audience_ids = ($system['friends_enabled']) ? $this->get_friends_ids() : $this->get_followers_ids();
        } else {
          $audience_ids = ($system['friends_enabled']) ? array_merge($this->get_friends_ids(), $this->get_followers_ids()) : $this->get_followers_ids();
        }
        foreach (array_unique($audience_ids) as $audience_id) {
          $this->post_notification(['to_user_id' => $audience_id, 'action' => 'live_stream', 'node_type' => 'post', 'node_url' => $post_id]);
        }
        break;
    }
    return $post_id;
  }


  /**
   * end_live_post
   * 
   * @param integer $post_id
   * @return void
   */
  public function end_live_post($post_id)
  {
    global $db, $system;
    /* (check|get) post */
    $post = $this->get_post($post_id, false, true);
    if (!$post) {
      _error(403);
    }
    /* check if viewer can edit post */
    if (!$post['manage_post']) {
      _error(403);
    }
    /* end live post */
    $db->query(sprintf("UPDATE posts_live SET live_ended = '1' WHERE post_id = %s", secure($post_id, 'int')));
    /* remove all audience */
    $db->query(sprintf("DELETE FROM posts_live_users WHERE post_id = %s", secure($post_id, 'int')));
    /* remove the live restrictions */
    $host = $this->live_host($post);
    $db->query(sprintf("DELETE FROM live_restrictions WHERE host_type = %s AND host_id = %s AND post_id = %s AND type IN ('mute', 'kick')", secure($host['type']), secure($host['id'], 'int'), secure($post_id, 'int')));
    /* stop live recording */
    if ($system['save_live_enabled']) {
      if ($post['live']['live_provider'] == "livekit") {
        $this->_livekit_stop_recording($post_id, $post['live']['livekit_egress_id']);
      } else {
        $this->_agora_stop_recording($post_id, $post['live']['agora_uid'], $post['live']['agora_channel_name'], $post['live']['agora_resource_id'], $post['live']['agora_sid']);
      }
    }
    /* disconnect the streaming software */
    if ($post['live']['broadcast_type'] == "rtmp" && $post['live']['livekit_room']) {
      try {
        $this->_livekit_room_client()->deleteRoom($post['live']['livekit_room']);
      } catch (Throwable $e) {
        /* room already closed */
      }
    }
  }


  /**
   * _agora_start_recording
   * 
   * @param integer $post_id
   * @param string $agora_uid
   * @param string $agora_token
   * @param string $agora_channel_name
   * @return void
   */
  private function _agora_start_recording($post_id, $agora_uid, $agora_token, $agora_channel_name)
  {
    global $db, $system;

    /* prepare AWS S3 (agora use keys not values!) */
    $s3_regions = [
      "us-east-1",
      "us-east-2",
      "us-west-1",
      "us-west-2",
      "eu-west-1",
      "eu-west-2",
      "eu-west-3",
      "eu-central-1",
      "ap-southeast-1",
      "ap-southeast-2",
      "ap-northeast-1",
      "ap-northeast-2",
      "sa-east-1",
      "ca-central-1",
      "ap-south-1"
    ];
    if ($system['agora_s3_endpoint']) {
      /* S3-compatible storage (vendor = 11) */
      $agora_s3_vendor = 11;
      $agora_s3_region = 0;
    } else {
      /* AWS S3 (vendor = 1) */
      $agora_s3_vendor = 1;
      $agora_s3_region = array_search($system['agora_s3_region'], $s3_regions);
      if ($agora_s3_region === false) {
        return;
      }
    }

    /* generate the base64Credentials */
    $base64Credentials = base64_encode(trim($system['agora_customer_id']) . ":" . trim($system['agora_customer_certificate']));
    $agora_uid = (string) $agora_uid;

    /* get the recording resource */
    $response = $this->_agora_recording_request(
      "https://api.agora.io/v1/apps/" . $system['agora_app_id'] . "/cloud_recording/acquire",
      $base64Credentials,
      [
        "cname" => $agora_channel_name,
        "uid" => $agora_uid,
        "clientRequest" => [
          "scene" => 0,
          "resourceExpiredHour" => 24
        ]
      ]
    );
    $resourceId = $response?->resourceId ?? null;
    if (!$resourceId) {
      return;
    }

    /* prepare storage config */
    $storage_config = [
      "vendor" => $agora_s3_vendor,
      "region" => (int) $agora_s3_region,
      "bucket" => $system['agora_s3_bucket'],
      "accessKey" => $system['agora_s3_key'],
      "secretKey" => $system['agora_s3_secret'],
      "fileNamePrefix" => [
        "uploads",
        "videos",
        "y" . date('Y'),
        "m" . date('m')
      ]
    ];
    if ($system['agora_s3_endpoint']) {
      $storage_config['extensionParams'] = ["endpoint" => preg_replace('#^https?://#', '', $system['agora_s3_endpoint'])];
    }

    /* start cloud recording */
    $response = $this->_agora_recording_request(
      "https://api.agora.io/v1/apps/" . $system['agora_app_id'] . "/cloud_recording/resourceid/" . $resourceId . "/mode/mix/start",
      $base64Credentials,
      [
        "cname" => $agora_channel_name,
        "uid" => $agora_uid,
        "clientRequest" => [
          "token" => $agora_token,
          "recordingConfig" => [
            "channelType" => 1,
            "streamTypes" => 2,
            "audioProfile" => 1,
            "videoStreamType" => 0,
            "maxIdleTime" => 120,
            "transcodingConfig" => [
              "width" => 1280,
              "height" => 720,
              "fps" => 30,
              "bitrate" => 2260,
              "mixedVideoLayout" => 1
            ]
          ],
          "recordingFileConfig" => [
            "avFileType" => ["hls"]
          ],
          "storageConfig" => $storage_config
        ]
      ]
    );
    $sid = $response?->sid ?? null;
    if (!$sid) {
      return;
    }

    /* update post */
    $db->query(sprintf("UPDATE posts_live SET agora_resource_id = %s, agora_sid = %s WHERE post_id = %s", secure($resourceId), secure($sid), secure($post_id, 'int')));
  }


  /**
   * _agora_stop_recording
   * 
   * @param integer $post_id
   * @param string $agora_uid
   * @param string $agora_channel_name
   * @param string $agora_resource_id
   * @param string $agora_sid
   * @return void
   */
  private function _agora_stop_recording($post_id, $agora_uid, $agora_channel_name, $agora_resource_id, $agora_sid)
  {
    global $db, $system;

    if (!$agora_resource_id || !$agora_sid) {
      return;
    }

    /* generate the base64Credentials */
    $base64Credentials = base64_encode(trim($system['agora_customer_id']) . ":" . trim($system['agora_customer_certificate']));

    /* stop cloud recording */
    $response = $this->_agora_recording_request(
      "https://api.agora.io/v1/apps/" . $system['agora_app_id'] . "/cloud_recording/resourceid/" . $agora_resource_id . "/sid/" . $agora_sid . "/mode/mix/stop",
      $base64Credentials,
      [
        "cname" => $agora_channel_name,
        "uid" => (string) $agora_uid,
        "clientRequest" => (object) []
      ]
    );
    $file = $this->_agora_recording_file($response?->serverResponse?->fileList ?? null);
    if (!$file) {
      return;
    }

    /* update post */
    $db->query(sprintf("UPDATE posts_live SET live_recorded = '1', agora_file = %s WHERE post_id = %s", secure($file), secure($post_id, 'int')));
  }


  /**
   * _livekit_start_recording
   * 
   * @param integer $post_id
   * @param string $room
   * @return void
   */
  private function _livekit_start_recording($post_id, $room)
  {
    global $db, $system;

    try {
      /* prepare the output file */
      $file = "uploads/videos/y" . date('Y') . "/m" . date('m') . "/live_" . $post_id . "_" . get_hash_key(8) . ".mp4";
      $s3 = new Livekit\S3Upload([
        'bucket' => $system['agora_s3_bucket'],
        'region' => $system['agora_s3_region'],
        'access_key' => $system['agora_s3_key'],
        'secret' => $system['agora_s3_secret'],
      ]);
      if ($system['agora_s3_endpoint']) {
        $s3->setEndpoint($system['agora_s3_endpoint']);
        $s3->setForcePathStyle(true);
      }
      $output = new Livekit\EncodedFileOutput([
        'file_type' => Livekit\EncodedFileType::MP4,
        'filepath' => $file,
        's3' => $s3,
      ]);
      $options = new Livekit\EncodingOptions([
        'width' => 1280,
        'height' => 720,
        'framerate' => 30,
        'video_bitrate' => 3000,
      ]);

      /* start room composite egress */
      $egress = $this->_livekit_egress_client()->startRoomCompositeEgress($room, 'speaker', $output, $options);

      /* update post */
      $db->query(sprintf("UPDATE posts_live SET livekit_egress_id = %s, livekit_file = %s WHERE post_id = %s", secure($egress->getEgressId()), secure($file), secure($post_id, 'int')));
    } catch (Throwable $e) {
      error_log("LiveKit Egress error: " . $e->getMessage());
    }
  }


  /**
   * _livekit_stop_recording
   * 
   * @param integer $post_id
   * @param string $egress_id
   * @return void
   */
  private function _livekit_stop_recording($post_id, $egress_id)
  {
    global $db;

    if (!$egress_id) {
      return;
    }

    try {
      /* stop egress */
      $this->_livekit_egress_client()->stopEgress($egress_id);
    } catch (Throwable $e) {
      /* egress already ended (e.g. the room closed) */
      error_log("LiveKit Egress error: " . $e->getMessage());
    }

    /* update post */
    $db->query(sprintf("UPDATE posts_live SET live_recorded = '1' WHERE post_id = %s", secure($post_id, 'int')));
  }


  /**
   * _livekit_egress_client
   * 
   * @return Agence104\LiveKit\EgressServiceClient
   */
  private function _livekit_egress_client()
  {
    global $system;
    return new Agence104\LiveKit\EgressServiceClient($this->_livekit_live_host(), $system['livekit_live_api_key'], $system['livekit_live_api_secret']);
  }


  /**
   * _livekit_ingress_client
   * 
   * @return Agence104\LiveKit\IngressServiceClient
   */
  private function _livekit_ingress_client()
  {
    global $system;
    return new Agence104\LiveKit\IngressServiceClient($this->_livekit_live_host(), $system['livekit_live_api_key'], $system['livekit_live_api_secret']);
  }


  /**
   * _livekit_room_client
   * 
   * @return Agence104\LiveKit\RoomServiceClient
   */
  private function _livekit_room_client()
  {
    global $system;
    return new Agence104\LiveKit\RoomServiceClient($this->_livekit_live_host(), $system['livekit_live_api_key'], $system['livekit_live_api_secret']);
  }


  /**
   * _livekit_live_host
   * 
   * @return string
   */
  private function _livekit_live_host()
  {
    global $system;
    return preg_replace('#^ws(s?)://#', 'http$1://', trim($system['livekit_live_ws_url']));
  }


  /**
   * live_rtmp_prepare
   * 
   * @param boolean $reset
   * @return array
   */
  public function live_rtmp_prepare($reset = false)
  {
    global $db, $system, $date;
    /* check if rtmp enabled */
    if (!$system['live_enabled'] || $system['live_provider'] != "livekit" || !$system['live_rtmp_enabled']) {
      throw new Exception(__("You don't have the permission to do this"));
    }
    /* check live permission */
    if (!$this->_data['can_go_live']) {
      throw new Exception(__("You don't have the permission to do this"));
    }
    $client = $this->_livekit_ingress_client();
    $room = get_hash_token();
    $identity = "host_rtmp_" . $this->_data['user_id'];
    /* get the viewer ingress */
    $ingress = null;
    $get_ingress = $db->query(sprintf("SELECT * FROM live_ingresses WHERE user_id = %s", secure($this->_data['user_id'], 'int')));
    if ($get_ingress->num_rows > 0) {
      $ingress = $get_ingress->fetch_assoc();
    }
    /* reset the stream key */
    if ($ingress && $reset) {
      try {
        $client->deleteIngress($ingress['ingress_id']);
      } catch (Throwable $e) {
        /* ingress already deleted */
      }
      $db->query(sprintf("DELETE FROM live_ingresses WHERE user_id = %s", secure($this->_data['user_id'], 'int')));
      $ingress = null;
    }
    try {
      if ($ingress) {
        /* check if the ingress is still streaming */
        $list = $client->listIngress('', $ingress['ingress_id']);
        $items = $list->getItems();
        if (count($items) == 0) {
          /* ingress deleted from the server */
          $db->query(sprintf("DELETE FROM live_ingresses WHERE user_id = %s", secure($this->_data['user_id'], 'int')));
          $ingress = null;
        } else {
          $state = $items[0]->getState();
          if ($state && in_array($state->getStatus(), [Livekit\IngressState\Status::ENDPOINT_BUFFERING, Livekit\IngressState\Status::ENDPOINT_PUBLISHING])) {
            throw new Exception(__("Please stop streaming from your streaming software first"));
          }
          /* move the ingress to the new room */
          $client->updateIngress($ingress['ingress_id'], "user_" . $this->_data['user_id'], $room, $identity, html_entity_decode($this->_data['user_fullname'], ENT_QUOTES));
          $db->query(sprintf("UPDATE live_ingresses SET ingress_room = %s, time = %s WHERE user_id = %s", secure($room), secure($date), secure($this->_data['user_id'], 'int')));
        }
      }
      if (!$ingress) {
        /* create new ingress */
        $info = $client->createIngress(Livekit\IngressInput::RTMP_INPUT, "user_" . $this->_data['user_id'], $room, $identity, html_entity_decode($this->_data['user_fullname'], ENT_QUOTES));
        $ingress = [
          'ingress_id' => $info->getIngressId(),
          'ingress_url' => $info->getUrl(),
          'stream_key' => $info->getStreamKey()
        ];
        $db->query(sprintf("INSERT INTO live_ingresses (user_id, ingress_id, ingress_url, stream_key, ingress_room, time) VALUES (%s, %s, %s, %s, %s, %s)", secure($this->_data['user_id'], 'int'), secure($ingress['ingress_id']), secure($ingress['ingress_url']), secure($ingress['stream_key']), secure($room), secure($date)));
      }
    } catch (Exception $e) {
      throw $e;
    } catch (Throwable $e) {
      error_log("LiveKit Ingress error: " . $e->getMessage());
      throw new Exception(__("Couldn't connect to the streaming server, please try again later"));
    }
    /* get preview token */
    $livekit = $this->livekit_live_token_builder(false, $room);
    return [
      'url' => html_entity_decode($ingress['ingress_url'], ENT_QUOTES),
      'stream_key' => html_entity_decode($ingress['stream_key'], ENT_QUOTES),
      'room' => $room,
      'token' => $livekit['token'] ?? null
    ];
  }


  /**
   * _agora_recording_request
   * 
   * @param string $url
   * @param string $base64Credentials
   * @param array $payload
   * @return object|null
   */
  private function _agora_recording_request($url, $base64Credentials, $payload)
  {
    $ch = curl_init();
    curl_setopt_array($ch, [
      CURLOPT_URL => $url,
      CURLOPT_HTTPHEADER => ['Authorization: Basic ' . $base64Credentials, 'Content-Type: application/json;charset=utf-8'],
      CURLOPT_CUSTOMREQUEST => 'POST',
      CURLOPT_POSTFIELDS => json_encode($payload),
      CURLOPT_RETURNTRANSFER => true,
      CURLOPT_TIMEOUT => 30
    ]);
    $raw = curl_exec($ch);
    $curl_error = curl_error($ch);
    if ($raw === false) {
      error_log("Agora Cloud Recording request failed: " . $curl_error);
      return null;
    }
    $response = json_decode($raw);
    if (!$response || (empty($response->resourceId) && empty($response->sid) && empty($response->serverResponse))) {
      error_log("Agora Cloud Recording error: " . $raw);
    }
    return $response;
  }


  /**
   * _agora_recording_file
   * 
   * @param mixed $fileList
   * @return string|null
   */
  private function _agora_recording_file($fileList)
  {
    if (is_string($fileList) && $fileList !== '') {
      return $fileList;
    }
    if (!is_array($fileList)) {
      return null;
    }
    $fallback = null;
    foreach ($fileList as $item) {
      $name = is_object($item) ? ($item->fileName ?? '') : ($item['fileName'] ?? '');
      if (!$name) {
        continue;
      }
      $playable = is_object($item) ? ($item->isPlayable ?? true) : ($item['isPlayable'] ?? true);
      if (!$playable) {
        continue;
      }
      if (str_ends_with($name, '.m3u8')) {
        return $name;
      }
      if (!$fallback) {
        $fallback = $name;
      }
    }
    return $fallback;
  }


  /**
   * join_live_post
   * 
   * @param integer $post_id
   * @param string $media_id
   * @return void
   */
  public function join_live_post($post_id, $media_id = '')
  {
    global $db;
    /* add new audience */
    $db->query(sprintf("INSERT INTO posts_live_users (user_id, post_id, media_id) VALUES (%s, %s, %s) ON DUPLICATE KEY UPDATE media_id = VALUES(media_id)", secure($this->_data['user_id'], 'int'), secure($post_id, 'int'), secure($media_id)));
  }


  /**
   * leave_live_post
   * 
   * @param integer $post_id
   * @return void
   */
  public function leave_live_post($post_id)
  {
    global $db;
    /* (check|get) post */
    $post = $this->_check_post($post_id, true);
    if (!$post) {
      _error(403);
    }
    /* remove audience */
    $db->query(sprintf("DELETE FROM posts_live_users WHERE user_id = %s AND post_id = %s", secure($this->_data['user_id'], 'int'), secure($post_id, 'int')));
  }


  /**
   * check_live_post
   * 
   * @param integer $post_id
   * @return boolean
   */
  public function check_live_post($post_id)
  {
    global $db;
    $check_live = $db->query(sprintf("SELECT post_id FROM posts_live WHERE post_id = %s AND live_ended = '0'", secure($post_id, 'int')));
    return $check_live->num_rows > 0;
  }


  /**
   * check_live_comment
   * 
   * @param integer $post_id
   * @param integer $comment_id
   * @return boolean
   */
  public function check_live_comment($post_id, $comment_id)
  {
    global $db;
    $check_comment = $db->query(sprintf("SELECT comments.comment_id FROM posts_comments comments LEFT JOIN posts_comments parents ON comments.node_type = 'comment' AND comments.node_id = parents.comment_id WHERE comments.comment_id = %s AND ((comments.node_type = 'post' AND comments.node_id = %2\$s) OR (parents.node_type = 'post' AND parents.node_id = %2\$s))", secure($comment_id, 'int'), secure($post_id, 'int')));
    return $check_comment->num_rows > 0;
  }


  /**
   * get_live_post_stats
   * 
   * @param integer $post_id
   * @param integer $last_comment_id
   * @param array $comments
   * @param integer $last_reply_id
   * @return array
   */
  public function get_live_post_stats($post_id, $last_comment_id, $comments = [], $last_reply_id = -1)
  {
    global $db;
    /* (check|get) post */
    $post = $this->_check_post($post_id, true);
    if (!$post) {
      return [];
    }
    /* total live users */
    $get_live_users = $db->query(sprintf("SELECT COUNT(*) as count FROM posts_live_users WHERE post_id = %s", secure($post_id, 'int')));

    /* check if viewer can moderate the live */
    $post['can_moderate_live'] = $this->can_moderate_live($post);

    /* get comments */
    $new_comments = $this->get_comments($post_id, 0, true, true, $post, false, $last_comment_id);

    /* get comments updates (reactions) */
    $updates = [];
    $parents_ids = [];
    $comments_ids = array_slice(array_filter(array_map('intval', array_keys((array) $comments))), 0, 100);
    if ($comments_ids) {
      $get_comments = $db->query(sprintf("SELECT comments.comment_id, comments.node_type, comments.reaction_like_count, comments.reaction_love_count, comments.reaction_haha_count, comments.reaction_yay_count, comments.reaction_wow_count, comments.reaction_sad_count, comments.reaction_angry_count FROM posts_comments comments LEFT JOIN posts_comments parents ON comments.node_type = 'comment' AND comments.node_id = parents.comment_id WHERE comments.comment_id IN (%s) AND ((comments.node_type = 'post' AND comments.node_id = %2\$s) OR (parents.node_type = 'post' AND parents.node_id = %2\$s))", implode(',', $comments_ids), secure($post_id, 'int')));
      while ($comment = $get_comments->fetch_assoc()) {
        if ($comment['node_type'] == 'post') {
          $parents_ids[] = $comment['comment_id'];
        }
        $signature = implode('.', [$comment['reaction_like_count'], $comment['reaction_love_count'], $comment['reaction_haha_count'], $comment['reaction_yay_count'], $comment['reaction_wow_count'], $comment['reaction_sad_count'], $comment['reaction_angry_count']]);
        $client_signature = (string) $comments[$comment['comment_id']];
        $updates[$comment['comment_id']] = ['signature' => $signature, 'comment' => null];
        if ($client_signature !== '' && $client_signature !== $signature) {
          $updates[$comment['comment_id']]['comment'] = $this->get_comment($comment['comment_id']);
        }
      }
    }

    /* get new replies */
    $replies = [];
    if ($last_reply_id < 0) {
      $get_last_reply = $db->query(sprintf("SELECT MAX(replies.comment_id) as last_reply_id FROM posts_comments replies INNER JOIN posts_comments parents ON replies.node_type = 'comment' AND replies.node_id = parents.comment_id WHERE parents.node_type = 'post' AND parents.node_id = %s", secure($post_id, 'int')));
      $last_reply_id = (int) $get_last_reply->fetch_assoc()['last_reply_id'];
    } elseif ($parents_ids) {
      $get_parents = $db->query(sprintf("SELECT DISTINCT node_id FROM posts_comments WHERE node_type = 'comment' AND node_id IN (%s) AND comment_id > %s", implode(',', $parents_ids), secure($last_reply_id, 'int')));
      while ($parent = $get_parents->fetch_assoc()) {
        foreach ($this->get_replies($parent['node_id'], 0, true, $post) as $reply) {
          if ($reply['comment_id'] > $last_reply_id) {
            $replies[$parent['node_id']][] = $reply;
          }
        }
      }
      foreach ($replies as $parent_replies) {
        foreach ($parent_replies as $reply) {
          $last_reply_id = max($last_reply_id, (int) $reply['comment_id']);
        }
      }
    }

    /* get post reactions */
    $reactions = [];
    $get_reactions = $db->query(sprintf("SELECT reaction_like_count, reaction_love_count, reaction_haha_count, reaction_yay_count, reaction_wow_count, reaction_sad_count, reaction_angry_count FROM posts WHERE post_id = %s", secure($post_id, 'int')));
    foreach ($get_reactions->fetch_assoc() as $reaction => $count) {
      $reactions[str_replace(['reaction_', '_count'], '', $reaction)] = (int) $count;
    }

    /* get viewer restriction */
    $restriction = ($post['can_moderate_live']) ? false : $this->get_live_restriction($post);

    return ["restriction" => ($restriction) ? $restriction['type'] : null, "live_count" => $get_live_users->fetch_assoc()['count'], "comments" => $new_comments, "updates" => $updates, "replies" => $replies, "last_reply_id" => $last_reply_id, "reactions" => $reactions];
  }


  /**
   * live_host
   * 
   * @param array $post
   * @return array
   */
  public function live_host($post)
  {
    return ['type' => ($post['user_type'] == "page") ? "page" : "user", 'id' => (int) $post['user_id']];
  }


  /**
   * check_live_moderator
   * 
   * @param array $post
   * @param integer $user_id
   * @return boolean
   */
  public function check_live_moderator($post, $user_id)
  {
    global $db;
    $host = $this->live_host($post);
    $check = $db->query(sprintf("SELECT user_id FROM live_moderators WHERE host_type = %s AND host_id = %s AND user_id = %s", secure($host['type']), secure($host['id'], 'int'), secure($user_id, 'int')));
    return $check->num_rows > 0;
  }


  /**
   * can_manage_live_moderators
   * 
   * @param array $post
   * @return boolean
   */
  public function can_manage_live_moderators($post)
  {
    global $system;
    if (empty($system['live_moderation_enabled']) || !$this->_logged_in || ($post['post_type'] ?? '') != 'live') {
      return false;
    }
    return $this->_data['user_group'] < 3 || $this->_data['user_id'] == $post['author_id'] || !empty($post['is_page_admin']);
  }


  /**
   * can_moderate_live
   * 
   * @param array $post
   * @return boolean
   */
  public function can_moderate_live($post)
  {
    global $system;
    if (isset($post['can_moderate_live'])) {
      return $post['can_moderate_live'];
    }
    if (empty($system['live_moderation_enabled']) || !$this->_logged_in || ($post['post_type'] ?? '') != 'live') {
      return false;
    }
    /* viewer is (admin|moderator) or the host */
    if ($this->can_manage_live_moderators($post)) {
      return true;
    }
    /* viewer is the admin of the (group|event) of the post */
    if ((!empty($post['in_group']) && !empty($post['is_group_admin'])) || (!empty($post['in_event']) && !empty($post['is_event_admin']))) {
      return true;
    }
    /* viewer is a live moderator */
    return $this->check_live_moderator($post, $this->_data['user_id']);
  }


  /**
   * get_live_restriction
   * 
   * @param array $post
   * @param integer $user_id
   * @return array|false
   */
  public function get_live_restriction($post, $user_id = null)
  {
    global $db, $system;
    if (empty($system['live_moderation_enabled'])) {
      return false;
    }
    $host = $this->live_host($post);
    $user_id = ($user_id) ? $user_id : $this->_data['user_id'];
    $get_restriction = $db->query(sprintf("SELECT *, (expires_at IS NOT NULL AND expires_at <= NOW()) AS expired, TIMESTAMPDIFF(SECOND, NOW(), expires_at) AS remaining FROM live_restrictions WHERE host_type = %s AND host_id = %s AND user_id = %s", secure($host['type']), secure($host['id'], 'int'), secure($user_id, 'int')));
    if ($get_restriction->num_rows == 0) {
      return false;
    }
    $restriction = $get_restriction->fetch_assoc();
    /* check if the restriction expired */
    if ($restriction['expired']) {
      $db->query(sprintf("DELETE FROM live_restrictions WHERE host_type = %s AND host_id = %s AND user_id = %s AND expires_at <= NOW()", secure($host['type']), secure($host['id'], 'int'), secure($user_id, 'int')));
      return false;
    }
    /* check if the restriction belongs to another (or ended) live */
    if (in_array($restriction['type'], ['mute', 'kick']) && ($restriction['post_id'] != $post['post_id'] || !$this->check_live_post($post['post_id']))) {
      return false;
    }
    return $restriction;
  }


  /**
   * get_live_users_states
   * 
   * @param array $post
   * @param array $users_ids
   * @return array
   */
  public function get_live_users_states($post, $users_ids)
  {
    global $db;
    $host = $this->live_host($post);
    $states = ['restrictions' => [], 'moderators' => []];
    $users_ids = implode(',', array_map('intval', $users_ids));
    $get_restrictions = $db->query(sprintf("SELECT user_id, type FROM live_restrictions WHERE host_type = %s AND host_id = %s AND user_id IN (%s) AND (type = 'ban' OR (type = 'timeout' AND expires_at > NOW()) OR (type IN ('mute', 'kick') AND post_id = %s))", secure($host['type']), secure($host['id'], 'int'), $users_ids, secure($post['post_id'], 'int')));
    while ($restriction = $get_restrictions->fetch_assoc()) {
      $states['restrictions'][$restriction['user_id']] = $restriction['type'];
    }
    $get_moderators = $db->query(sprintf("SELECT user_id FROM live_moderators WHERE host_type = %s AND host_id = %s AND user_id IN (%s)", secure($host['type']), secure($host['id'], 'int'), $users_ids));
    while ($moderator = $get_moderators->fetch_assoc()) {
      $states['moderators'][$moderator['user_id']] = true;
    }
    return $states;
  }


  /**
   * get_live_moderation
   * 
   * @param integer $post_id
   * @param integer $user_id
   * @return array
   */
  public function get_live_moderation($post_id, $user_id)
  {
    /* (check|get) post */
    $post = $this->_check_post($post_id, true);
    if (!$post || !$this->can_moderate_live($post)) {
      _error(403);
    }
    /* (check|get) target */
    $target = $this->get_user($user_id);
    if (!$target) {
      _error(403);
    }
    $target['is_moderator'] = $this->check_live_moderator($post, $user_id);
    $target['restriction'] = $this->get_live_restriction($post, $user_id);
    return ['post' => $post, 'target' => $target, 'can_manage_moderators' => $this->can_manage_live_moderators($post)];
  }


  /**
   * live_moderate
   * 
   * @param integer $post_id
   * @param integer $user_id
   * @param string $action
   * @param integer $duration
   * @return void
   */
  public function live_moderate($post_id, $user_id, $action, $duration = 0)
  {
    global $db, $date;
    $moderation = $this->get_live_moderation($post_id, $user_id);
    $post = $moderation['post'];
    $target = $moderation['target'];
    $host = $this->live_host($post);
    /* check the target */
    if ($target['user_id'] == $this->_data['user_id'] || $target['user_id'] == $post['author_id'] || $target['user_group'] < 3) {
      throw new Exception(__("You can't moderate this user"));
    }
    switch ($action) {
      case 'timeout':
      case 'mute':
      case 'kick':
      case 'ban':
        if ($target['is_moderator']) {
          throw new Exception(__("You can't moderate this user"));
        }
        if ($action != 'ban' && !$this->check_live_post($post_id)) {
          throw new Exception(__("This live has ended"));
        }
        $duration = (int) $duration;
        if ($action == 'timeout' && !in_array($duration, [1, 5, 10, 30, 60])) {
          _error(400);
        }
        $expires_at = ($action == 'timeout') ? sprintf("DATE_ADD(NOW(), INTERVAL %s MINUTE)", secure($duration, 'int', false)) : "NULL";
        $db->query(sprintf("INSERT INTO live_restrictions (host_type, host_id, user_id, type, post_id, expires_at, moderator_id, time) VALUES (%s, %s, %s, %s, %s, " . $expires_at . ", %s, %s) ON DUPLICATE KEY UPDATE type = VALUES(type), post_id = VALUES(post_id), expires_at = VALUES(expires_at), moderator_id = VALUES(moderator_id), time = VALUES(time)", secure($host['type']), secure($host['id'], 'int'), secure($user_id, 'int'), secure($action), secure($post_id, 'int'), secure($this->_data['user_id'], 'int'), secure($date)));
        $this->_live_moderation_log($host, $post_id, $user_id, $action, ($action == 'timeout') ? $duration : '');
        /* remove the user from the live */
        if (in_array($action, ['kick', 'ban'])) {
          $this->_live_eject($post_id, $user_id);
        }
        break;

      case 'unrestrict':
        if (!$target['restriction']) {
          return;
        }
        $db->query(sprintf("DELETE FROM live_restrictions WHERE host_type = %s AND host_id = %s AND user_id = %s", secure($host['type']), secure($host['id'], 'int'), secure($user_id, 'int')));
        $this->_live_moderation_log($host, $post_id, $user_id, 'unrestrict', $target['restriction']['type']);
        break;

      case 'add_moderator':
        if (!$moderation['can_manage_moderators']) {
          _error(403);
        }
        if ($target['is_moderator']) {
          return;
        }
        $db->query(sprintf("INSERT INTO live_moderators (host_type, host_id, user_id, time) VALUES (%s, %s, %s, %s)", secure($host['type']), secure($host['id'], 'int'), secure($user_id, 'int'), secure($date)));
        $db->query(sprintf("DELETE FROM live_restrictions WHERE host_type = %s AND host_id = %s AND user_id = %s", secure($host['type']), secure($host['id'], 'int'), secure($user_id, 'int')));
        $this->_live_moderation_log($host, $post_id, $user_id, 'add_moderator');
        break;

      case 'remove_moderator':
        if (!$moderation['can_manage_moderators']) {
          _error(403);
        }
        if (!$target['is_moderator']) {
          return;
        }
        $db->query(sprintf("DELETE FROM live_moderators WHERE host_type = %s AND host_id = %s AND user_id = %s", secure($host['type']), secure($host['id'], 'int'), secure($user_id, 'int')));
        $this->_live_moderation_log($host, $post_id, $user_id, 'remove_moderator');
        break;

      default:
        _error(400);
        break;
    }
  }


  /**
   * _live_eject
   * 
   * @param integer $post_id
   * @param integer $user_id
   * @return void
   */
  private function _live_eject($post_id, $user_id)
  {
    global $db, $system;
    /* get the audience */
    $get_audience = $db->query(sprintf("SELECT posts_live_users.media_id, posts_live.* FROM posts_live_users INNER JOIN posts_live ON posts_live_users.post_id = posts_live.post_id WHERE posts_live_users.user_id = %s AND posts_live_users.post_id = %s AND posts_live.live_ended = '0'", secure($user_id, 'int'), secure($post_id, 'int')));
    if ($get_audience->num_rows == 0) {
      return;
    }
    $audience = $get_audience->fetch_assoc();
    /* remove audience */
    $db->query(sprintf("DELETE FROM posts_live_users WHERE user_id = %s AND post_id = %s", secure($user_id, 'int'), secure($post_id, 'int')));
    if (!$audience['media_id']) {
      return;
    }
    if ($audience['live_provider'] == "livekit") {
      /* livekit */
      try {
        $this->_livekit_room_client()->removeParticipant($audience['livekit_room'], $audience['media_id']);
      } catch (Throwable $e) {
        /* participant already left */
      }
    } else {
      /* agora */
      $ch = curl_init();
      curl_setopt_array($ch, [
        CURLOPT_URL => "https://api.agora.io/dev/v1/kicking-rule",
        CURLOPT_HTTPHEADER => ['Authorization: Basic ' . base64_encode(trim($system['agora_customer_id']) . ":" . trim($system['agora_customer_certificate'])), 'Content-Type: application/json;charset=utf-8'],
        CURLOPT_CUSTOMREQUEST => 'POST',
        CURLOPT_POSTFIELDS => json_encode(['appid' => $system['agora_app_id'], 'cname' => $audience['agora_channel_name'], 'uid' => (int) $audience['media_id'], 'time' => 1440, 'privileges' => ['join_channel']]),
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_TIMEOUT => 10
      ]);
      if (curl_exec($ch) === false) {
        error_log("Agora kicking rule request failed: " . curl_error($ch));
      }
    }
  }


  /**
   * get_live_restrictions
   * 
   * @param string $host_type
   * @param integer $host_id
   * @return array
   */
  public function get_live_restrictions($host_type, $host_id)
  {
    global $db, $system;
    $host = $this->_check_live_host($host_type, $host_id);
    $restrictions = [];
    $get_restrictions = $db->query(sprintf("SELECT live_restrictions.type, live_restrictions.expires_at, live_restrictions.time, users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM live_restrictions INNER JOIN users ON live_restrictions.user_id = users.user_id LEFT JOIN posts_live ON live_restrictions.type IN ('mute', 'kick') AND live_restrictions.post_id = posts_live.post_id AND posts_live.live_ended = '0' WHERE live_restrictions.host_type = %s AND live_restrictions.host_id = %s AND (live_restrictions.type = 'ban' OR (live_restrictions.type = 'timeout' AND live_restrictions.expires_at > NOW()) OR posts_live.post_id IS NOT NULL) ORDER BY live_restrictions.user_id ASC LIMIT 100", secure($host['type']), secure($host['id'], 'int')));
    while ($restriction = $get_restrictions->fetch_assoc()) {
      $restriction['user_picture'] = get_picture($restriction['user_picture'], $restriction['user_gender']);
      $restriction['user_fullname'] = ($system['show_usernames_enabled']) ? $restriction['user_name'] : $restriction['user_firstname'] . " " . $restriction['user_lastname'];
      $restrictions[] = $restriction;
    }
    return $restrictions;
  }


  /**
   * delete_live_restriction
   * 
   * @param string $host_type
   * @param integer $host_id
   * @param integer $user_id
   * @return void
   */
  public function delete_live_restriction($host_type, $host_id, $user_id)
  {
    global $db;
    $host = $this->_check_live_host($host_type, $host_id);
    $get_restriction = $db->query(sprintf("SELECT type, post_id FROM live_restrictions WHERE host_type = %s AND host_id = %s AND user_id = %s", secure($host['type']), secure($host['id'], 'int'), secure($user_id, 'int')));
    if ($get_restriction->num_rows == 0) {
      return;
    }
    $restriction = $get_restriction->fetch_assoc();
    $db->query(sprintf("DELETE FROM live_restrictions WHERE host_type = %s AND host_id = %s AND user_id = %s", secure($host['type']), secure($host['id'], 'int'), secure($user_id, 'int')));
    $this->_live_moderation_log($host, $restriction['post_id'], $user_id, 'unrestrict', $restriction['type']);
  }


  /**
   * get_live_moderators
   * 
   * @param string $host_type
   * @param integer $host_id
   * @return array
   */
  public function get_live_moderators($host_type, $host_id)
  {
    global $db, $system;
    $host = $this->_check_live_host($host_type, $host_id);
    $moderators = [];
    $get_moderators = $db->query(sprintf("SELECT live_moderators.time, users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM live_moderators INNER JOIN users ON live_moderators.user_id = users.user_id WHERE live_moderators.host_type = %s AND live_moderators.host_id = %s ORDER BY live_moderators.user_id ASC LIMIT 100", secure($host['type']), secure($host['id'], 'int')));
    while ($moderator = $get_moderators->fetch_assoc()) {
      $moderator['user_picture'] = get_picture($moderator['user_picture'], $moderator['user_gender']);
      $moderator['user_fullname'] = ($system['show_usernames_enabled']) ? $moderator['user_name'] : $moderator['user_firstname'] . " " . $moderator['user_lastname'];
      $moderators[] = $moderator;
    }
    return $moderators;
  }


  /**
   * delete_live_moderator
   * 
   * @param string $host_type
   * @param integer $host_id
   * @param integer $user_id
   * @return void
   */
  public function delete_live_moderator($host_type, $host_id, $user_id)
  {
    global $db;
    $host = $this->_check_live_host($host_type, $host_id);
    $db->query(sprintf("DELETE FROM live_moderators WHERE host_type = %s AND host_id = %s AND user_id = %s", secure($host['type']), secure($host['id'], 'int'), secure($user_id, 'int')));
    if ($db->affected_rows > 0) {
      $this->_live_moderation_log($host, 0, $user_id, 'remove_moderator');
    }
  }


  /**
   * get_live_moderation_log
   * 
   * @param string $host_type
   * @param integer $host_id
   * @param integer $last_log_id
   * @return array
   */
  public function get_live_moderation_log($host_type, $host_id, $last_log_id = 0)
  {
    global $db, $system;
    $host = $this->_check_live_host($host_type, $host_id);
    $log = [];
    $where_query = ($last_log_id > 0) ? sprintf(" AND live_moderation_log.log_id < %s", secure($last_log_id, 'int')) : "";
    $get_log = $db->query(sprintf("SELECT live_moderation_log.*, moderators.user_name AS moderator_user_name, moderators.user_firstname AS moderator_firstname, moderators.user_lastname AS moderator_lastname, targets.user_name AS target_user_name, targets.user_firstname AS target_firstname, targets.user_lastname AS target_lastname FROM live_moderation_log LEFT JOIN users moderators ON live_moderation_log.moderator_id = moderators.user_id LEFT JOIN users targets ON live_moderation_log.user_id = targets.user_id WHERE live_moderation_log.host_type = %s AND live_moderation_log.host_id = %s" . $where_query . " ORDER BY live_moderation_log.log_id DESC LIMIT 30", secure($host['type']), secure($host['id'], 'int')));
    while ($entry = $get_log->fetch_assoc()) {
      $entry['moderator_name'] = ($system['show_usernames_enabled']) ? $entry['moderator_user_name'] : trim($entry['moderator_firstname'] . " " . $entry['moderator_lastname']);
      $entry['target_name'] = ($system['show_usernames_enabled']) ? $entry['target_user_name'] : trim($entry['target_firstname'] . " " . $entry['target_lastname']);
      $log[] = $entry;
    }
    return $log;
  }


  /**
   * get_live_settings
   * 
   * @param string $host_type
   * @param integer $host_id
   * @return array
   */
  public function get_live_settings($host_type, $host_id)
  {
    $host = $this->_check_live_host($host_type, $host_id);
    return $this->_live_settings($host);
  }


  /**
   * update_live_settings
   * 
   * @param string $host_type
   * @param integer $host_id
   * @param array $args
   * @return void
   */
  public function update_live_settings($host_type, $host_id, $args = [])
  {
    global $db;
    $host = $this->_check_live_host($host_type, $host_id);
    $slow_mode = (in_array((int) $args['slow_mode'], [0, 5, 10, 30, 60, 120])) ? (int) $args['slow_mode'] : 0;
    $blocked_words = implode(', ', array_slice(array_unique(array_filter(array_map('trim', explode(',', str_replace(["\r", "\n"], ',', (string) $args['blocked_words']))))), 0, 200));
    if (mb_strlen($blocked_words) > 5000) {
      throw new Exception(__("Blocked words list is too long"));
    }
    $rules = trim((string) $args['rules']);
    if (mb_strlen($rules) > 1000) {
      throw new Exception(__("Chat rules are too long"));
    }
    $db->query(sprintf("INSERT INTO live_moderation_settings (host_type, host_id, slow_mode, blocked_words, links_blocked, repeats_blocked, rules) VALUES (%s, %s, %s, %s, %s, %s, %s) ON DUPLICATE KEY UPDATE slow_mode = VALUES(slow_mode), blocked_words = VALUES(blocked_words), links_blocked = VALUES(links_blocked), repeats_blocked = VALUES(repeats_blocked), rules = VALUES(rules)", secure($host['type']), secure($host['id'], 'int'), secure($slow_mode, 'int'), secure($blocked_words), secure(($args['links_blocked']) ? '1' : '0'), secure(($args['repeats_blocked']) ? '1' : '0'), secure($rules)));
    $this->_live_moderation_log($host, 0, 0, 'settings');
  }


  /**
   * get_live_rules
   * 
   * @param array $post
   * @return string
   */
  public function get_live_rules($post)
  {
    global $system;
    if (empty($system['live_moderation_enabled'])) {
      return '';
    }
    $settings = $this->_live_settings($this->live_host($post));
    return (trim($settings['rules']) !== '') ? $settings['rules'] : (string) ($system['live_chat_rules'] ?? '');
  }


  /**
   * check_live_comment_rules
   * 
   * @param array $post
   * @param string $message
   * @return void
   */
  public function check_live_comment_rules($post, $message)
  {
    global $db, $system, $date;
    if (empty($system['live_moderation_enabled'])) {
      return;
    }
    $settings = $this->_live_settings($this->live_host($post));
    if (!$settings['slow_mode'] && !$settings['links_blocked'] && !$settings['repeats_blocked'] && trim($settings['blocked_words']) === '') {
      return;
    }
    /* bypass the live moderators */
    if ($this->can_moderate_live($post)) {
      return;
    }
    $message = trim((string) $message);
    /* check blocked words */
    foreach (explode(',', html_entity_decode($settings['blocked_words'], ENT_QUOTES)) as $word) {
      $word = trim($word);
      if ($word !== '' && preg_match('/(?<![\p{L}\p{N}])' . preg_quote($word, '/') . '(?![\p{L}\p{N}])/iu', $message)) {
        throw new Exception(__("Your comment contains words that are not allowed in this live"));
      }
    }
    /* check links */
    if ($settings['links_blocked'] && preg_match('/(https?:\/\/|www\.)\S+|\b[a-z0-9-]{2,}\.(com|net|org|io|co|me|info|xyz|ly|tv|gg|app|shop|link|site|online|store|live|ru|cn)\b/iu', $message)) {
      throw new Exception(__("Links are not allowed in this live"));
    }
    /* check the last comment */
    if ($settings['slow_mode'] || $settings['repeats_blocked']) {
      $get_last_comment = $db->query(sprintf("SELECT text, TIMESTAMPDIFF(SECOND, time, %s) AS elapsed FROM posts_comments WHERE user_id = %s AND user_type = 'user' ORDER BY comment_id DESC LIMIT 1", secure($date), secure($this->_data['user_id'], 'int')));
      if ($get_last_comment->num_rows > 0) {
        $last_comment = $get_last_comment->fetch_assoc();
        if ($settings['slow_mode'] && $last_comment['elapsed'] >= 0 && $last_comment['elapsed'] < $settings['slow_mode']) {
          throw new Exception(__("Slow mode is on, you can comment again in") . " " . ($settings['slow_mode'] - $last_comment['elapsed']) . " " . __("Seconds"));
        }
        if ($settings['repeats_blocked'] && $message !== '' && $last_comment['elapsed'] < 300 && $last_comment['text'] === htmlentities($message, ENT_QUOTES, 'utf-8')) {
          throw new Exception(__("You have already posted this comment"));
        }
      }
    }
  }


  /**
   * _live_settings
   * 
   * @param array $host
   * @return array
   */
  private function _live_settings($host)
  {
    global $db;
    $get_settings = $db->query(sprintf("SELECT slow_mode, blocked_words, links_blocked, repeats_blocked, rules FROM live_moderation_settings WHERE host_type = %s AND host_id = %s", secure($host['type']), secure($host['id'], 'int')));
    if ($get_settings->num_rows == 0) {
      return ['slow_mode' => 0, 'blocked_words' => '', 'links_blocked' => false, 'repeats_blocked' => false, 'rules' => ''];
    }
    $settings = $get_settings->fetch_assoc();
    $settings['slow_mode'] = (int) $settings['slow_mode'];
    $settings['links_blocked'] = $settings['links_blocked'] == '1';
    $settings['repeats_blocked'] = $settings['repeats_blocked'] == '1';
    return $settings;
  }


  /**
   * _check_live_host
   * 
   * @param string $host_type
   * @param integer $host_id
   * @return array
   */
  private function _check_live_host($host_type, $host_id)
  {
    $host = ['type' => ($host_type == "page") ? "page" : "user", 'id' => (int) $host_id];
    if ($this->_data['user_group'] < 3) {
      return $host;
    }
    if (($host['type'] == "user" && $host['id'] == $this->_data['user_id']) || ($host['type'] == "page" && $this->check_page_adminship($this->_data['user_id'], $host['id']))) {
      return $host;
    }
    _error(403);
  }


  /**
   * _live_moderation_log
   * 
   * @param array $host
   * @param integer $post_id
   * @param integer $user_id
   * @param string $action
   * @param string $details
   * @return void
   */
  private function _live_moderation_log($host, $post_id, $user_id, $action, $details = '')
  {
    global $db, $date;
    $db->query(sprintf("INSERT INTO live_moderation_log (host_type, host_id, post_id, moderator_id, user_id, action, details, time) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)", secure($host['type']), secure($host['id'], 'int'), secure($post_id, 'int'), secure($this->_data['user_id'], 'int'), secure($user_id, 'int'), secure($action), secure(mb_substr((string) $details, 0, 250)), secure($date)));
  }


  /**
   * agora_token_builder
   * 
   * @param boolean $is_host
   * @param string $channel_name
   * @param string $uid
   * @param boolean $is_call
   * @return string
   */
  public function agora_token_builder($is_host = true, $channel_name = null, $uid = null, $is_call = false)
  {
    global $system;
    $channel_name = ($channel_name) ? $channel_name : get_hash_token();
    $uid = ($uid == null) ? mt_rand() : $uid;
    $role = ($is_host) ? TaylanUnutmaz\AgoraTokenBuilder\RtcTokenBuilder::RolePublisher : TaylanUnutmaz\AgoraTokenBuilder\RtcTokenBuilder::RoleAttendee;
    $expire_time = 36000;
    $current_timestamp = (new DateTime("now", new DateTimeZone('UTC')))->getTimestamp();
    $privilege_expired = $current_timestamp + $expire_time;
    $app_id = ($is_call) ? $system['agora_call_app_id'] : $system['agora_app_id'];
    $app_certificate = ($is_call) ? $system['agora_call_app_certificate'] : $system['agora_app_certificate'];
    if (empty($app_id) || empty($app_certificate)) {
      return [];
    }
    $token = TaylanUnutmaz\AgoraTokenBuilder\RtcTokenBuilder::buildTokenWithUid($app_id, $app_certificate, $channel_name, $uid, $role, $privilege_expired);
    return ["uid" => $uid, "token" => $token, "channel_name" => $channel_name];
  }


  /**
   * livekit_live_token_builder
   * 
   * @param boolean $is_host
   * @param string $room
   * @return array
   */
  public function livekit_live_token_builder($is_host = true, $room = null)
  {
    global $system;
    if (empty($system['livekit_live_api_key']) || empty($system['livekit_live_api_secret'])) {
      return [];
    }
    $room = ($room) ? $room : get_hash_token();
    $identity = ($is_host) ? "host_" . $this->_data['user_id'] : "viewer_" . $this->_data['user_id'] . "_" . get_hash_key(8);
    $options = (new Agence104\LiveKit\AccessTokenOptions())->setIdentity($identity)->setTtl(($is_host) ? 36000 : 600);
    $grant = (new Agence104\LiveKit\VideoGrant())->setRoomJoin()->setRoomName($room)->setCanPublish($is_host)->setCanSubscribe()->setCanPublishData(false)->setHidden(!$is_host);
    $token = (new Agence104\LiveKit\AccessToken($system['livekit_live_api_key'], $system['livekit_live_api_secret']))->init($options)->setGrant($grant)->toJwt();
    return ["token" => $token, "room" => $room, "identity" => $identity];
  }
}
