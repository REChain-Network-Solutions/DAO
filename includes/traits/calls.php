<?php

/**
 * trait -> calls
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich
 */

trait CallsTrait
{

  /* ------------------------------- */
  /* Video/Audio Calls */
  /* ------------------------------- */

  /**
   * get_calls_history
   * 
   * @param integer $offset
   * @return array
   */
  public function get_calls_history($offset = 0)
  {
    global $db, $system;
    $calls = [];
    $offset = $args['offset'] ?? 0;
    $offset *= $system['max_results'];
    $get_calls = $db->query(sprintf(
      'SELECT * FROM conversations_calls WHERE from_user_id = %1$s OR to_user_id = %1$s ORDER BY created_time DESC LIMIT %2$s, %3$s',
      secure($this->_data['user_id'], 'int'),
      secure($offset, 'int', false),
      secure($system['max_results'], 'int', false)
    ));
    if ($get_calls && $get_calls->num_rows > 0) {
      while ($row = $get_calls->fetch_assoc()) {
        $row['is_video_call'] = $row['is_video_call'] == '1' ? true : false;
        $row['is_missed_call'] = ($row['declined'] == '1' && $row['answered'] == '0');
        $row['is_ingoing'] = ($row['to_user_id'] == $this->_data['user_id']);
        $row['caller_receiver'] = ($row['is_ingoing']) ? $this->get_user($row['from_user_id'], false) : $this->get_user($row['to_user_id'], false);
        $calls[] = $row;
      }
    }
    $has_more = (count($calls) < $system['max_results']) ? false : true;
    return ['data' => $calls, 'has_more' => $has_more];
  }


  /**
   * create_call
   * 
   * @param string $type
   * @param integer $to_user_id
   * @return array|false
   */
  public function create_call($type, $to_user_id)
  {
    global $db, $system, $date;
    /* check call type */
    switch ($type) {
      case 'audio':
        $is_video_call = 0;
        /* check if audio call enabled */
        if (!$system['audio_call_enabled']) {
          throw new Exception(__("The audio call feature has been disabled by the admin"));
        }
        /* check audio call permission */
        if (!$this->_data['can_start_audio_call']) {
          throw new Exception(__("You don't have the permission to do this"));
        }
        break;

      case 'video':
        $is_video_call = 1;
        /* check if video call enabled */
        if (!$system['video_call_enabled']) {
          throw new Exception(__("The video call feature has been disabled by the admin"));
        }
        /* check video call permission */
        if (!$this->_data['can_start_video_call']) {
          throw new Exception(__("You don't have the permission to do this"));
        }
        break;

      default:
        _error(400);
        break;
    }
    /* check if target user exist */
    $check_target_user = $db->query(sprintf("SELECT COUNT(*) as count FROM users WHERE user_id = %s", secure($to_user_id, 'int')));
    if ($check_target_user->fetch_assoc()['count'] == 0) {
      return false;
    }
    /* check blocking */
    if ($this->blocked($to_user_id)) {
      return false;
    }
    /* check recipients chat privacy */
    $this->check_recipients_chat_privacy([$this->get_user($to_user_id)]);
    /* check if target user offline */
    $check_target_busy_offline = $db->query(sprintf("SELECT COUNT(*) as count FROM users WHERE user_id = %s AND user_last_seen >= SUBTIME(NOW(), SEC_TO_TIME(%s))", secure($to_user_id, 'int'), secure($system['offline_time'], 'int', false)));
    if ($check_target_busy_offline->fetch_assoc()['count'] == 0) {
      return "recipient_offline";
    }
    /* check if target user busy (someone calling him || he calling someone || in a call) */
    $check_target_busy = $db->query(sprintf('SELECT COUNT(*) as count FROM conversations_calls WHERE (from_user_id = %1$s OR to_user_id = %1$s) AND declined = "0" AND updated_time >= SUBTIME(NOW(), SEC_TO_TIME(40))', secure($to_user_id, 'int')));
    if ($check_target_busy->fetch_assoc()['count'] > 0) {
      return "recipient_busy";
    }
    /* check if the viewer busy (someone calling him || he calling someone || in a call) */
    $check_viewer_busy = $db->query(sprintf('SELECT COUNT(*) as count FROM conversations_calls WHERE (from_user_id = %1$s OR to_user_id = %1$s) AND declined = "0" AND updated_time >= SUBTIME(NOW(), SEC_TO_TIME(40))', secure($this->_data['user_id'], 'int')));
    if ($check_viewer_busy->fetch_assoc()['count'] > 0) {
      return "caller_busy";
    }
    /* check paid call */
    if ($system['monetization_enabled'] && $this->check_user_permission($to_user_id, 'monetization_permission')) {
      $to_user_info = $this->get_user($to_user_id);
      if ($to_user_info['user_monetization_enabled'] && $to_user_info['user_monetization_call_price'] > 0) {
        $call_price = $to_user_info['user_monetization_call_price'];
        /* check if the viewer has enough balance */
        if ($this->_data['user_wallet_balance'] < $call_price) {
          throw new Exception(__("There is not enough credit in your wallet. Recharge your wallet to continue.") . " " . "<strong class='text-link' data-toggle='modal' data-url='#wallet-replenish'>" . __("Recharge Now") . "</strong>");
        }
      }
    }
    /* create a new room */
    $room = get_hash_token();
    /* caller */
    $caller_id = substr(get_hash_token(), 0, 15);
    if ($system['audio_video_provider'] == "twilio") {
      $caller_token = new Twilio\Jwt\AccessToken($system['twilio_sid'], $system['twilio_apisid'], $system['twilio_apisecret'], 3600, $caller_id);
      $caller_grant = new Twilio\Jwt\Grants\VideoGrant();
      $caller_grant->setRoom($room);
      $caller_token->addGrant($caller_grant);
      $caller_token_serialized = $caller_token->toJWT();
    } elseif ($system['audio_video_provider'] == "livekit") {
      $callerOptions = (new Agence104\LiveKit\AccessTokenOptions())->setIdentity($caller_id);
      $callerGrant = (new Agence104\LiveKit\VideoGrant())->setRoomJoin()->setRoomName($room);
      $caller_token_serialized = (new Agence104\LiveKit\AccessToken($system['livekit_api_key'], $system['livekit_api_secret']))
        ->init($callerOptions)
        ->setGrant($callerGrant)
        ->toJwt();
    } elseif ($system['audio_video_provider'] == "agora") {
      $callerTokenData = $this->agora_token_builder(true, $room, $this->_data['user_id'], true);
      $caller_token_serialized = $callerTokenData['token'];
    }
    /* receiver */
    $receiver_id = substr(get_hash_token(), 0, 15);
    if ($system['audio_video_provider'] == "twilio") {
      $receiver_token = new Twilio\Jwt\AccessToken($system['twilio_sid'], $system['twilio_apisid'], $system['twilio_apisecret'], 3600, $receiver_id);
      $receiver_grant = new Twilio\Jwt\Grants\VideoGrant();
      $receiver_grant->setRoom($room);
      $receiver_token->addGrant($receiver_grant);
      $receiver_token_serialized = $receiver_token->toJWT();
    } elseif ($system['audio_video_provider'] == "livekit") {
      $receiverOptions = (new Agence104\LiveKit\AccessTokenOptions())->setIdentity($receiver_id);
      $receiverGrant = (new Agence104\LiveKit\VideoGrant())->setRoomJoin()->setRoomName($room);
      $receiver_token_serialized = (new Agence104\LiveKit\AccessToken($system['livekit_api_key'], $system['livekit_api_secret']))
        ->init($receiverOptions)
        ->setGrant($receiverGrant)
        ->toJwt();
    } elseif ($system['audio_video_provider'] == "agora") {
      $receiverTokenData = $this->agora_token_builder(false, $room, $to_user_id, true);
      $receiver_token_serialized = $receiverTokenData['token'];
    }
    /* insert the call */
    $db->query(sprintf(
      "INSERT INTO conversations_calls (
        is_video_call,
        from_user_id, 
        from_user_token, 
        to_user_id, 
        to_user_token, 
        room, 
        created_time, 
        updated_time
      ) VALUES (
        %s, %s, %s, %s, %s, %s, %s, %s
      )",
      secure($is_video_call),
      secure($this->_data['user_id'], 'int'),
      secure($caller_token_serialized),
      secure($to_user_id, 'int'),
      secure($receiver_token_serialized),
      secure($room),
      secure($date),
      secure($date)
    ));
    $call = [
      'call_id' => $db->insert_id,
      'type' => $type,
      'is_video' => ($type == "video" ? true : false),
      'is_audio' => ($type == "audio" ? true : false),
      'caller_name' => $this->_data['user_fullname'],
      'caller_picture' => $this->_data['user_picture'],
    ];
    return $call;
  }


  /**
   * decline_call
   * 
   * @param integer $call_id
   * @return array
   */
  public function decline_call($call_id)
  {
    global $db, $date;
    /* check if user authorized */
    $check_call = $db->query(sprintf('SELECT * FROM conversations_calls WHERE call_id =  %1$s AND (from_user_id = %2$s OR to_user_id = %2$s)', secure($call_id, 'int'), secure($this->_data['user_id'], 'int')));
    if ($check_call->num_rows == 0) {
      throw new Exception(__("You are not authorized to do this"));
    }
    $call = $check_call->fetch_assoc();
    /* update the call */
    $db->query(sprintf("UPDATE conversations_calls SET declined = '1', updated_time = %s WHERE call_id = %s", secure($date), secure($call_id, 'int')));
    /* return */
    return $call;
  }


  /**
   * answer_call
   * 
   * @param integer $call_id
   * @return void
   */
  public function answer_call($call_id)
  {
    global $db, $system, $date;
    /* check if user authorized */
    $check_call = $db->query(sprintf("SELECT * FROM conversations_calls WHERE call_id = %s AND to_user_id = %s", secure($call_id, 'int'), secure($this->_data['user_id'], 'int')));
    if ($check_call->num_rows == 0) {
      throw new Exception(__("You are not authorized to do this"));
    }
    $call = $check_call->fetch_assoc();
    /* check paid call */
    if ($this->_data['can_monetize_content'] && $this->_data['user_monetization_enabled'] && $this->_data['user_monetization_call_price'] > 0) {
      $this->wallet_call_payment($this->_data['user_monetization_call_price'], $call['from_user_id'], $call['to_user_id']);
    }
    /* update the call */
    $db->query(sprintf("UPDATE conversations_calls SET answered = '1', updated_time = %s WHERE call_id = %s", secure($date), secure($call_id, 'int')));
    /* return */
    return $call;
  }


  /**
   * update_call
   * 
   * @param integer $call_id
   * @return void
   */
  public function update_call($call_id)
  {
    global $db, $date;
    /* check if user authorized */
    $check_call = $db->query(sprintf('SELECT COUNT(*) as count FROM conversations_calls WHERE call_id =  %1$s AND (from_user_id = %2$s OR to_user_id = %2$s)', secure($call_id, 'int'), secure($this->_data['user_id'], 'int')));
    if ($check_call->fetch_assoc()['count'] == 0) {
      throw new Exception(__("You are not authorized to do this"));
    }
    /* update the call */
    $db->query(sprintf("UPDATE conversations_calls SET updated_time = %s WHERE call_id = %s", secure($date), secure($call_id, 'int')));
  }


  /**
   * check_calling_response
   * 
   * @param integer $call_id
   * @return void
   */
  public function check_calling_response($call_id)
  {
    global $db, $date;
    /* check if user authorized */
    $check_call = $db->query(sprintf("SELECT * FROM conversations_calls WHERE call_id = %s AND from_user_id = %s", secure($call_id, 'int'), secure($this->_data['user_id'], 'int')));
    if ($check_call->num_rows == 0) {
      throw new Exception(__("You are not authorized to do this"));
    }
    $call = $check_call->fetch_assoc();
    /* update the call */
    $db->query(sprintf("UPDATE conversations_calls SET updated_time = %s WHERE call_id = %s", secure($date), secure($call_id, 'int')));
    /* return */
    if ($call['declined']) {
      return "declined";
    } else if ($call['answered']) {
      return $call;
    } else {
      return "no_answer";
    }
  }


  /**
   * check_new_calls
   * 
   * @return array
   */
  public function check_new_calls()
  {
    global $db, $system;
    /* new call -> [call created from less than 40 seconds and not answered nor declined] */
    $get_new_calls = $db->query(sprintf(
      "SELECT 
        conversations_calls.*,
        users.user_name,
        users.user_firstname, 
        users.user_lastname,
        users.user_gender,
        users.user_picture 
      FROM conversations_calls
      INNER JOIN users 
        ON conversations_calls.from_user_id = users.user_id 
      WHERE conversations_calls.to_user_id = %s 
        AND conversations_calls.created_time >= SUBTIME(NOW(), SEC_TO_TIME(40)) 
        AND conversations_calls.answered = '0' 
        AND conversations_calls.declined = '0'",
      secure($this->_data['user_id'], 'int')
    ));
    if ($get_new_calls->num_rows == 0) {
      return false;
    }
    $call = $get_new_calls->fetch_assoc();
    $call['caller_name'] = html_entity_decode(($system['show_usernames_enabled']) ? $call['user_name'] : $call['user_firstname'] . " " . $call['user_lastname'], ENT_QUOTES);
    $call['caller_picture'] = get_picture($call['user_picture'], $call['user_gender']);
    return $call;
  }
}
