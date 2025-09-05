<?php

/**
 * trait -> livestream
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich - Handles - @sorydima @sorydev @durovshater @DmitrySoro90935 @tanechfund - also check https://dmitry.rechain.network for more information!
 */

trait LiveStreamTrait
{

  /* ------------------------------- */
  /* Live Stream */
  /* ------------------------------- */

  /**
   * create_live_post
   * 
   * @param string $agora_channel_name
   * @param string $video_thumbnail
   * @param string $node
   * @param integer $node_id
   * @param boolean $tips_enabled
   * @param boolean $for_subscriptions
   * @param boolean $is_paid
   * @param integer $post_price
   * @return integer
   */
  public function create_live_post($agora_channel_name, $video_thumbnail, $node = null, $node_id = null, $tips_enabled = false, $for_subscriptions = false, $is_paid = false, $post_price = 0)
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
    /* get agora recorder (uid|token) */
    $agora_recorder = $this->agora_token_builder(false, $agora_channel_name);
    $agora_uid = $agora_recorder['uid'];
    $agora_token = $agora_recorder['token'];
    /* prepare live video thumbnail */
    $video_thumbnail = ($video_thumbnail != 'data:,') ? $video_thumbnail : "https://dummyimage.com/16:9x1080/000000/ffffff/?text=Live+Video";
    $video_thumbnail = save_picture_from_url($video_thumbnail);
    /* prepare the post */
    $post['user_id'] = $this->_data['user_id'];
    $post['user_type'] = "user";
    $post['privacy'] = 'public';
    $post['in_group'] = 0;
    $post['group_id'] = null;
    $post['group_approved'] = 0;
    $post['in_event'] = 0;
    $post['event_id'] = null;
    $post['event_approved'] = 0;
    $post['tips_enabled'] = ($node != 'page' && $this->_data['can_receive_tip'] && $tips_enabled == "true") ? '1' : '0';
    $post['for_subscriptions'] = ($for_subscriptions == "true") ? '1' : '0';
    $post['is_paid'] = ($is_paid == "true") ? '1' : '0';
    $post['post_price'] = ($is_paid) ? $post_price : 0;
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
          $event = $this->get_event($event_id);
          if (!$event) {
            _error(400);
          }
          /* check if the viewer is event member */
          if (!$this->check_event_membership($this->_data['user_id'], $event_id)) {
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
    /* insert post */
    $db->query(sprintf("INSERT INTO posts (user_id, user_type, post_type, in_group, group_id, group_approved, in_event, event_id, event_approved, tips_enabled, for_subscriptions, is_paid, post_price, privacy, time) VALUES (%s, %s, 'live', %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)", secure($post['user_id'], 'int'), secure($post['user_type']), secure($post['in_group']), secure($post['group_id'], 'int'), secure($post['group_approved']), secure($post['in_event']), secure($post['event_id'], 'int'), secure($post['event_approved']), secure($post['tips_enabled']), secure($post['for_subscriptions']), secure($post['is_paid']), secure($post['post_price'], 'float'), secure($post['privacy']), secure($date)));
    $post_id = $db->insert_id;
    /* insert live */
    $db->query(sprintf("INSERT INTO posts_live (post_id, video_thumbnail, agora_uid, agora_channel_name) VALUES (%s, %s, %s, %s)", secure($post_id, 'int'), secure($video_thumbnail), secure($agora_uid, 'int'), secure($agora_channel_name)));
    // [BACKGROUND PROCESS]
    /* return async */
    return_json_async(['post_id' => $post_id]);
    /* start live recording */
    if ($system['save_live_enabled']) {
      $this->start_live_recording($post_id, $agora_uid, $agora_token, $agora_channel_name);
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
        /* notify friends */
        foreach ($this->get_friends_ids() as $friend_id) {
          $this->post_notification(['to_user_id' => $friend_id, 'action' => 'live_stream', 'node_type' => 'post', 'node_url' => $post_id]);
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
    /* stop live recording */
    if ($system['save_live_enabled']) {
      $this->stop_live_recording($post_id, $post['live']['agora_uid'], $post['live']['agora_channel_name'], $post['live']['agora_resource_id'], $post['live']['agora_sid']);
    }
  }


  /**
   * start_live_recording
   * 
   * @param integer $post_id
   * @param string $agora_uid
   * @param string $agora_token
   * @param string $agora_channel_name
   * @return void
   */
  public function start_live_recording($post_id, $agora_uid, $agora_token, $agora_channel_name)
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
    $system['agora_s3_region'] = array_search($system['agora_s3_region'], $s3_regions);

    /* generate the base64Credentials */
    $base64Credentials = base64_encode($system['agora_customer_id'] . ":" . $system['agora_customer_certificate']);

    /* get the recording resource */
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, "https://api.agora.io/v1/apps/" . $system['agora_app_id'] . "/cloud_recording/acquire");
    curl_setopt($ch, CURLOPT_HTTPHEADER, ['Authorization: Basic ' . $base64Credentials, 'Content-Type: application/json;charset=utf-8']);
    curl_setopt($ch, CURLOPT_CUSTOMREQUEST, 'POST');
    curl_setopt(
      $ch,
      CURLOPT_POSTFIELDS,
      '{
              "cname": "' . $agora_channel_name . '",
              "uid": "' . $agora_uid . '",
              "clientRequest":{}
            }'
    );
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    $response  = curl_exec($ch);
    curl_close($ch);
    $response = json_decode($response);
    $resourceId = $response->resourceId;
    if (!$resourceId) {
      return;
    }

    /* start cloud recording (vendor = 1 for AWS S3) */
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, "https://api.agora.io/v1/apps/" . $system['agora_app_id'] . "/cloud_recording/resourceid/" . $resourceId . "/mode/mix/start");
    curl_setopt($ch, CURLOPT_HTTPHEADER, ['Authorization: Basic ' . $base64Credentials, 'Content-Type: application/json;charset=utf-8']);
    curl_setopt($ch, CURLOPT_CUSTOMREQUEST, 'POST');
    curl_setopt(
      $ch,
      CURLOPT_POSTFIELDS,
      '{
                "cname":"' . $agora_channel_name . '",
                "uid":"' . $agora_uid . '",
                "clientRequest":{
                    "token":"' . $agora_token . '",
                    "recordingConfig":{
                        "channelType":1,
                        "streamTypes":2,
                        "audioProfile":1,
                        "videoStreamType":0,
                        "transcodingConfig":{
                            "width":1280,
                            "height":720,
                            "fps":30,
                            "bitrate":3420,
                            "maxResolutionUid":"1"
                            }
                        },
                    "storageConfig":{
                        "vendor": 1,
                        "region":' . $system['agora_s3_region'] . ',
                        "bucket":"' . $system['agora_s3_bucket'] . '",
                        "accessKey":"' . $system['agora_s3_key'] . '",
                        "secretKey":"' . $system['agora_s3_secret'] . '",
                        "fileNamePrefix": [
                            "uploads",
                            "videos",
                            "' . date('Y') . '",
                            "' . date('m') . '"
                          ]
                    }
                }
            } '
    );
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    $response  = curl_exec($ch);
    curl_close($ch);
    $response = json_decode($response);
    $sid = $response->sid;
    if (!$sid) {
      return;
    }

    /* update post */
    $db->query(sprintf("UPDATE posts_live SET agora_resource_id = %s, agora_sid = %s WHERE post_id = %s", secure($resourceId), secure($sid), secure($post_id, 'int')));
  }


  /**
   * stop_live_recording
   * 
   * @param integer $post_id
   * @param string $agora_uid
   * @param string $agora_channel_name
   * @param string $agora_resource_id
   * @param string $agora_sid
   * @return void
   */
  public function stop_live_recording($post_id, $agora_uid, $agora_channel_name, $agora_resource_id, $agora_sid)
  {
    global $db, $system;

    /* generate the base64Credentials */
    $base64Credentials = base64_encode($system['agora_customer_id'] . ":" . $system['agora_customer_certificate']);

    /* stop cloud recording */
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, "https://api.agora.io/v1/apps/" . $system['agora_app_id'] . "/cloud_recording/resourceid/" . $agora_resource_id . "/sid/" . $agora_sid . "/mode/mix/stop");
    curl_setopt($ch, CURLOPT_HTTPHEADER, ['Authorization: Basic ' . $base64Credentials, 'Content-Type: application/json;charset=utf-8']);
    curl_setopt($ch, CURLOPT_CUSTOMREQUEST, 'POST');
    curl_setopt(
      $ch,
      CURLOPT_POSTFIELDS,
      '{
                "cname": "' . $agora_channel_name . '",
                "uid": "' . $agora_uid . '",
                "clientRequest":{}
            }'
    );
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    $response  = curl_exec($ch);
    curl_close($ch);
    $response = json_decode($response);
    $file = $response->serverResponse->fileList;
    if (!$file) {
      return;
    }

    /* update post */
    $db->query(sprintf("UPDATE posts_live SET live_recorded = '1', agora_file = %s WHERE post_id = %s", secure($file), secure($post_id, 'int')));
  }


  /**
   * join_live_post
   * 
   * @param integer $post_id
   * @return void
   */
  public function join_live_post($post_id)
  {
    global $db;
    /* check if this user already joined the live post */
    $check = $db->query(sprintf("SELECT * FROM posts_live_users WHERE user_id = %s AND post_id = %s", secure($this->_data['user_id'], 'int'), secure($post_id, 'int')));
    if ($check->num_rows > 0) {
      return;
    }
    /* add new audience */
    $db->query(sprintf("INSERT INTO posts_live_users (user_id, post_id) VALUES (%s, %s)", secure($this->_data['user_id'], 'int'), secure($post_id, 'int')));
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
   * get_live_post_stats
   * 
   * @param integer $post_id
   * @return void
   */
  public function get_live_post_stats($post_id, $last_comment_id)
  {
    global $db;
    /* (check|get) post */
    $post = $this->_check_post($post_id, true);
    if (!$post) {
      return [];
    }
    /* total live users */
    $get_live_users = $db->query(sprintf("SELECT COUNT(*) as count FROM posts_live_users WHERE post_id = %s", secure($post_id, 'int')));

    /* get comments */
    $comments = $this->get_comments($post_id, 0, true, true, $post, false, $last_comment_id);

    return ["live_count" => $get_live_users->fetch_assoc()['count'], "comments" => $comments];
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
}
