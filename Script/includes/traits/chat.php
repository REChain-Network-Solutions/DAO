<?php

/**
 * trait -> chat
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich - Handles - @sorydima @sorydev @durovshater @DmitrySoro90935 @tanechfund - also check https://dmitry.rechain.network for more information!
 */

trait ChatTrait
{

  /* ------------------------------- */
  /* Chat */
  /* ------------------------------- */

  /**
   * user_online
   * 
   * @param integer $user_id
   * @return boolean
   */
  public function user_online($user_id)
  {
    global $db, $system;
    /* check if the target user is a friend to the viewer */
    if (!$this->friendship_approved($user_id)) {
      return false;
    }
    /* check if the target user is online & enable the chat */
    $get_user_status = $db->query(sprintf(
      "SELECT COUNT(*) as count 
      FROM users 
      WHERE user_id = %s 
        AND user_chat_enabled = '1' 
        AND user_privacy_chat != 'me'
        AND user_last_seen >= SUBTIME(NOW(), SEC_TO_TIME(%s))",
      secure($user_id, 'int'),
      secure($system['offline_time'], 'int', false)
    ));
    if ($get_user_status->fetch_assoc()['count'] == 0) {
      return false;
    }
    return true;
  }


  /**
   * update_user_last_seen
   * 
   * @return void
   */
  public function update_user_last_seen()
  {
    global $db;
    /* init system datetime */
    $date = init_system_datetime();
    /* update user last seen */
    $db->query(sprintf("UPDATE users SET user_last_seen = %s WHERE user_id = %s", secure($date), secure($this->_data['user_id'], 'int')));
  }


  /**
   * get_contacts
   * 
   * @param array $args
   * @return array
   */
  public function get_contacts($args = [])
  {
    global $db, $system;
    /* prepare query */
    $query = $args['query'] ?? '';
    $where_query = ($query) ? sprintf(' AND (user_name LIKE %1$s OR user_firstname LIKE %1$s OR user_lastname LIKE %1$s)', secure($query, 'search')) : "";
    /* skipped ids */
    $skipped_array = ($args['skipped_ids']) ? array_filter($args['skipped_ids'], [$this, "filter_ids"]) : [];
    $skipped_ids_query = ($skipped_array) ? sprintf(' AND user_id NOT IN (%s)', $this->spread_ids($skipped_array)) : "";
    /* get contacts */
    $contacts = [];
    $max_results = 20;
    $offset = $args['offset'] ?? 0;
    $offset *= $max_results;
    $get_contacts = $db->query(sprintf(
      "SELECT 
        user_id, 
        user_name, 
        user_firstname, 
        user_lastname, 
        user_gender, 
        user_picture, 
        user_last_seen, 
        (user_last_seen >= SUBTIME(NOW(), SEC_TO_TIME(%s))) AS user_is_online 
      FROM users 
      WHERE user_id IN (%s) %s %s 
      ORDER BY user_last_seen DESC 
      LIMIT %s, %s",
      secure($system['offline_time'], 'int'),
      $this->spread_ids($this->get_friends_or_followings_ids()),
      $where_query,
      $skipped_ids_query,
      secure($offset, 'int', false),
      secure($max_results, 'int', false)
    ));
    if ($get_contacts->num_rows > 0) {
      while ($contact = $get_contacts->fetch_assoc()) {
        $contact['user_picture'] = get_picture($contact['user_picture'], $contact['user_gender']);
        $contact['user_fullname'] = ($system['show_usernames_enabled']) ? $contact['user_name'] : $contact['user_firstname'] . " " . $contact['user_lastname'];
        $contacts[] = $contact;
      }
    }
    $has_more = (count($contacts) < $max_results) ? false : true;
    return ['data' => $contacts, 'has_more' => $has_more];
  }


  /**
   * get_conversations_new
   * 
   * @return array
   */
  public function get_conversations_new()
  {
    global $db;
    $conversations = [];
    if (!empty($_SESSION['chat_boxes_opened'])) {
      /* make list from opened chat boxes keys (conversations ids) */
      $chat_boxes_opened_list = $this->spread_ids($_SESSION['chat_boxes_opened']);
      $get_conversations = $db->query(sprintf(
        "SELECT conversations.conversation_id 
        FROM conversations 
        INNER JOIN conversations_users 
          ON conversations.conversation_id = conversations_users.conversation_id 
        WHERE conversations.node_id IS NULL 
          AND conversations_users.user_id = %s 
          AND conversations_users.seen = '0' 
          AND conversations_users.deleted = '0' 
          AND conversations.conversation_id NOT IN (%s)",
        secure($this->_data['user_id'], 'int'),
        $chat_boxes_opened_list
      ));
    } else {
      $get_conversations = $db->query(sprintf(
        "SELECT conversations.conversation_id 
        FROM conversations 
        INNER JOIN conversations_users 
          ON conversations.conversation_id = conversations_users.conversation_id 
        WHERE conversations.node_id IS NULL 
          AND conversations_users.user_id = %s 
          AND conversations_users.seen = '0' 
          AND conversations_users.deleted = '0'",
        secure($this->_data['user_id'], 'int')
      ));
    }
    if ($get_conversations->num_rows > 0) {
      while ($conversation = $get_conversations->fetch_assoc()) {
        $db->query(sprintf("UPDATE conversations_users SET seen = '1' WHERE conversation_id = %s AND user_id = %s", secure($conversation['conversation_id'], 'int'), secure($this->_data['user_id'], 'int')));
        $conversations[] = $this->get_conversation($conversation['conversation_id']);
      }
    }
    return $conversations;
  }


  /**
   * get_conversations
   * 
   * @param integer $offset
   * @return array
   */
  public function get_conversations($offset = 0)
  {
    global $db, $system;
    /* get conversations */
    $conversations = [];
    $offset = $args['offset'] ?? 0;
    $offset *= $system['max_results'];
    $get_conversations = $db->query(sprintf(
      "SELECT conversations.conversation_id 
      FROM conversations 
      INNER JOIN conversations_users 
        ON conversations.conversation_id = conversations_users.conversation_id 
      WHERE conversations_users.deleted = '0' 
        AND conversations_users.user_id = %s 
      ORDER BY conversations.last_message_id DESC 
      LIMIT %s, %s",
      secure($this->_data['user_id'], 'int'),
      secure($offset, 'int', false),
      secure($system['max_results'], 'int', false)
    ));
    if ($get_conversations->num_rows > 0) {
      while ($conversation = $get_conversations->fetch_assoc()) {
        $conversation = $this->get_conversation($conversation['conversation_id']);
        if ($conversation) {
          $conversations[] = $conversation;
        }
      }
    }
    $has_more = (count($conversations) < $system['max_results']) ? false : true;
    return ['data' => $conversations, 'has_more' => $has_more];
  }


  /**
   * get_conversation
   * 
   * @param integer $conversation_id
   * @return array
   */
  public function get_conversation($conversation_id)
  {
    global $db, $system;
    $conversation = [];
    $get_conversation = $db->query(sprintf(
      "SELECT 
        conversations.*, 
        conversations_messages.message,
        conversations_messages.image,
        conversations_messages.voice_note, 
        conversations_messages.time,
        conversations_users.seen 
      FROM conversations 
      LEFT JOIN conversations_messages 
        ON conversations.last_message_id = conversations_messages.message_id 
      INNER JOIN conversations_users 
        ON conversations.conversation_id = conversations_users.conversation_id 
      WHERE conversations_users.user_id = %s 
        AND conversations.conversation_id = %s",
      secure($this->_data['user_id'], 'int'),
      secure($conversation_id, 'int')
    ));
    if ($get_conversation->num_rows == 0) {
      return false;
    }
    $conversation = $get_conversation->fetch_assoc();
    /* get recipients */
    $get_recipients = $db->query(sprintf(
      "SELECT 
        conversations_users.seen,
        conversations_users.deleted,
        conversations_users.typing,
        users.user_id,
        users.user_name,
        users.user_firstname, 
        users.user_lastname,
        users.user_gender,
        users.user_picture,
        users.user_subscribed,
        users.user_verified,
        users.user_monetization_enabled,
        users.user_monetization_chat_price,
        users.user_monetization_call_price,
        users.user_privacy_chat,
        users.user_last_seen 
      FROM conversations_users 
      INNER JOIN users 
        ON conversations_users.user_id = users.user_id 
      WHERE conversations_users.conversation_id = %s 
        AND conversations_users.user_id != %s",
      secure($conversation['conversation_id'], 'int'),
      secure($this->_data['user_id'], 'int')
    ));
    $recipients_num = $get_recipients->num_rows;
    if (!$conversation['node_id'] && $recipients_num == 0) {
      return false;
    }
    $i = 1;
    $conversation['chat_price'] = 0;
    $conversation['call_price'] = 0;
    $conversation['paid_recipients'] = [];
    while ($recipient = $get_recipients->fetch_assoc()) {
      /* check if paid chat */
      if ($system['monetization_enabled'] && $this->check_user_permission($recipient['user_id'], 'monetization_permission') && $recipient['user_monetization_enabled'] && ($recipient['user_monetization_chat_price'] > 0 || $recipient['user_monetization_call_price'] > 0)) {
        $conversation['chat_price'] += $recipient['user_monetization_chat_price'];
        $conversation['call_price'] += $recipient['user_monetization_call_price'];
        $conversation['paid_recipients'][] = $recipient;
      }
      /* get recipient picture */
      $recipient['user_picture'] = get_picture($recipient['user_picture'], $recipient['user_gender']);
      /* add to conversation recipients */
      $conversation['recipients'][] = $recipient;
      /* prepare typing recipients */
      if ($system['chat_typing_enabled'] && $recipient['typing']) {
        /* check if recipient typing but offline */
        $get_recipient_status = $db->query(sprintf("SELECT COUNT(*) as count FROM users WHERE user_id = %s AND user_last_seen >= SUBTIME(NOW(), SEC_TO_TIME(%s))", secure($recipient['user_id'], 'int'), secure($system['offline_time'], 'int', false)));
        if ($get_recipient_status->fetch_assoc()['count'] == 0) {
          /* recipient offline -> remove his typing status */
          $db->query(sprintf("UPDATE conversations_users SET typing = '0' WHERE conversation_id = %s AND user_id = %s", secure($conversation_id, 'int'), secure($recipient['user_id'], 'int')));
        } else {
          /* recipient online -> return his typing status */
          if ($conversation['typing_name_list']) {
            $conversation['typing_name_list'] .= ", ";
          }
          $conversation['typing_name_list'] .= html_entity_decode(($system['show_usernames_enabled']) ? $recipient['user_name'] : $recipient['user_firstname'], ENT_QUOTES);
        }
      }
      /* prepare seen recipients */
      if ($system['chat_seen_enabled'] && $recipient['seen']) {
        if ($conversation['seen_name_list']) {
          $conversation['seen_name_list'] .= ", ";
        }
        $conversation['seen_name_list'] .= html_entity_decode(($system['show_usernames_enabled']) ? $recipient['user_name'] : $recipient['user_firstname'], ENT_QUOTES);
      }
      /* prepare conversation name_list */
      $conversation['name_list'] .= html_entity_decode(($system['show_usernames_enabled']) ? $recipient['user_name'] : $recipient['user_firstname'], ENT_QUOTES);
      if ($i < $recipients_num) {
        $conversation['name_list'] .= ", ";
      }
      $i++;
    }
    /* prepare conversation with multiple_recipients */
    switch ($conversation['node_type']) {
      case 'group':
        /* get group */
        $group = $this->get_group($conversation['node_id']);
        $conversation['multiple_recipients'] = true;
        $conversation['link'] = 'groups/' . $group['group_name'];
        $conversation['picture'] = get_picture($group['group_picture'], 'group');
        $conversation['name'] = __("Group") . ": " . $group['group_title'];
        break;

      case 'event':
        /* get event */
        $event = $this->get_event($conversation['node_id']);
        $conversation['multiple_recipients'] = true;
        $conversation['link'] = 'events/' . $conversation['node_id'];
        $conversation['picture'] = get_picture($group['event_cover'], 'event');
        $conversation['name'] = __("Event") . ": " . $event['event_title'];
        break;

      default:
        if ($recipients_num > 1) {
          /* multiple recipients */
          $conversation['multiple_recipients'] = true;
          $conversation['link'] = 'messages/' . $conversation['conversation_id'];
          $conversation['picture_left'] = $conversation['recipients'][0]['user_picture'];
          $conversation['picture_right'] = $conversation['recipients'][1]['user_picture'];
          if ($recipients_num > 2) {
            $conversation['name'] = html_entity_decode(($system['show_usernames_enabled']) ? $conversation['recipients'][0]['user_name'] : $conversation['recipients'][0]['user_firstname'], ENT_QUOTES) . ", " . html_entity_decode(($system['show_usernames_enabled']) ? $conversation['recipients'][1]['user_name'] : $conversation['recipients'][1]['user_firstname'], ENT_QUOTES) . " & " . ($recipients_num - 2) . " " . __("more");
          } else {
            $conversation['name'] = html_entity_decode(($system['show_usernames_enabled']) ? $conversation['recipients'][0]['user_name'] : $conversation['recipients'][0]['user_firstname'], ENT_QUOTES) . " & " . html_entity_decode(($system['show_usernames_enabled']) ? $conversation['recipients'][1]['user_name'] : $conversation['recipients'][1]['user_firstname'], ENT_QUOTES);
          }
        } else {
          /* one recipient */
          $conversation['multiple_recipients'] = false;
          $conversation['user_id'] = $conversation['recipients'][0]['user_id'];
          $conversation['link'] = $conversation['recipients'][0]['user_name'];
          $conversation['picture'] = $conversation['recipients'][0]['user_picture'];
          $conversation['name'] = html_entity_decode(($system['show_usernames_enabled']) ? $conversation['recipients'][0]['user_name'] : $conversation['recipients'][0]['user_firstname'] . " " . $conversation['recipients'][0]['user_lastname'], ENT_QUOTES);
          $conversation['name_html'] = popover($conversation['recipients'][0]['user_id'], $conversation['recipients'][0]['user_name'], ($system['show_usernames_enabled']) ? $conversation['recipients'][0]['user_name'] : $conversation['recipients'][0]['user_firstname'] . " " . $conversation['recipients'][0]['user_lastname']);
          $conversation['user_is_online'] = $this->user_online($conversation['recipients'][0]['user_id']);
          $conversation['user_last_seen'] = $conversation['recipients'][0]['user_last_seen'];
        }
        break;
    }
    /* get is chatbox */
    $conversation['is_chatbox'] = $conversation['node_id'] ? true : false;
    /* get total number of messages */
    $conversation['total_messages'] = $this->get_conversation_total_messages($conversation_id);
    /* decode message text */
    $conversation['message_orginal'] = $this->decode_emojis($conversation['message']);
    $conversation['message_orginal'] = censored_words($conversation['message_orginal']);
    $conversation['message_orginal_decoded'] = html_entity_decode($conversation['message_orginal'], ENT_QUOTES);
    $conversation['message'] = $this->_parse(["text" => $conversation['message'], "decode_mention" => false, "decode_hashtags" => false]);
    $conversation['message_decoded'] = html_entity_decode($conversation['message'], ENT_QUOTES);
    /* get last message */
    $conversation['last_message'] = $this->get_conversation_messages_by_id($conversation['last_message_id']);
    /* return */
    return $conversation;
  }


  /**
   * check_mutual_conversation
   * 
   * @param integer $conversation_id
   * @param integer $user_id
   * @return array
   */
  public function check_mutual_conversation($conversation_id = null, $user_id = null)
  {
    global $db;
    /* prepare */
    $conversation = [];
    /* if both not set */
    if (!$conversation_id && !$user_id) {
      throw new BadRequestException(__("Conversation ID or User ID is required"));
    }
    /* if user_id is set -> check if there is a mutual conversation */
    if ($user_id) {
      $mutual_conversation_id = $this->get_mutual_conversation_id((array)$user_id);
      if ($mutual_conversation_id) {
        /* set the conversation_id */
        $conversation_id = $mutual_conversation_id;
      }
    }
    /* get convertsation details */
    if ($conversation_id) {
      $conversation = $this->get_conversation($conversation_id);
      if ($conversation) {
        /* get conversation messages */
        $messages_data = $this->get_conversation_messages($conversation_id);
        $conversation['messages'] = $messages_data['messages'];
        $conversation['has_more'] = $messages_data['has_more'];
        /* check if last message sent by the viewer */
        if ($conversation['seen_name_list'] && end($conversation['messages'])['user_id'] == $this->_data['user_id']) {
          $conversation['last_seen_message_id'] = end($conversation['messages'])['message_id'];
        }
      }
    }
    /* update conversation as seen */
    $db->query(sprintf("UPDATE conversations_users SET seen = '1' WHERE conversation_id = %s AND user_id = %s", secure($conversation_id, 'int'), secure($this->_data['user_id'], 'int')));
    return $conversation;
  }


  /**
   * get_mutual_conversation_id
   * 
   * @param array $recipients
   * @param boolean $check_deleted
   * @return integer
   */
  public function get_mutual_conversation_id($recipients, $check_deleted = false)
  {
    global $db;
    $recipients_array = (array)$recipients;
    $recipients_array = array_filter($recipients_array, [$this, "filter_ids"]);
    if (!$recipients_array) {
      throw new BadRequestException(__("Conversation recipients is required"));
    }
    $recipients_array[] = $this->_data['user_id'];
    $recipients_list = $this->spread_ids($recipients_array);
    $get_mutual_conversations = $db->query(sprintf('SELECT conversations.conversation_id FROM conversations_users INNER JOIN conversations ON conversations_users.conversation_id = conversations.conversation_id WHERE conversations.node_id IS NULL AND conversations_users.user_id IN (%s) GROUP BY conversations.conversation_id HAVING COUNT(conversations.conversation_id) = %s', $recipients_list, count($recipients_array)));
    if ($get_mutual_conversations->num_rows == 0) {
      return false;
    }
    while ($mutual_conversation = $get_mutual_conversations->fetch_assoc()) {
      /* get recipients */
      $where_statement = ($check_deleted) ? " AND deleted != '1' " : "";
      $get_recipients = $db->query(sprintf("SELECT COUNT(*) as count FROM conversations_users WHERE conversation_id = %s" . $where_statement, secure($mutual_conversation['conversation_id'], 'int')));
      if ($get_recipients->fetch_assoc()['count'] == count($recipients_array)) {
        return $mutual_conversation['conversation_id'];
      }
    }
  }


  /**
   * post_conversation_message
   * 
   * @param array $args
   * @return array
   */
  public function post_conversation_message($args = [], $from_web = false)
  {
    global $db, $system;
    /* init system datetime */
    $date = init_system_datetime();
    /* prepare */
    $message = $args['message'] ?? '';
    $photo = $args['photo'] ?? '';
    $voice_note = $args['voice_note'] ?? '';
    $conversation_id = $args['conversation_id'] ?? null;
    $recipients = $args['recipients'] ?? null;
    /* filter photo */
    if ($photo && $from_web) {
      $photo = json_decode($photo);
    }
    /* filter voice note */
    if ($voice_note && $from_web) {
      $voice_note = json_decode($voice_note);
    }
    /* if message not set */
    if (!$message && !$photo && !$voice_note) {
      throw new BadRequestException(__("Message or Image or Voice Note is required"));
    }
    /* if both (conversation_id & recipients) not set */
    if (!$conversation_id && !$recipients) {
      throw new BadRequestException(__("Conversation ID or Recipients is required"));
    }
    /* if conversation_id set but not numeric */
    if ($conversation_id && !is_numeric($conversation_id)) {
      throw new BadRequestException(__("Conversation ID must be numeric"));
    }
    /* if recipients not array */
    if ($recipients) {
      $recipients = json_decode($recipients);
      if (!is_array($recipients)) {
        throw new BadRequestException(__("Recipients must be an array"));
      }
      /* recipients must contain numeric values only */
      $recipients = array_filter($recipients, 'is_numeric');
      /* check blocking */
      foreach ($recipients as $recipient) {
        if ($this->blocked($recipient)) {
          throw new AuthorizationException(__("You are not authorized to do this"));
        }
      }
    }
    /* check if posting the message to (new || existed) conversation */
    if ($conversation_id == null) {
      /* [first] check previous conversation between (viewer & recipients) */
      $mutual_conversation = $this->get_mutual_conversation_id($recipients);
      if (!$mutual_conversation) {
        /* [1] there is no conversation between viewer and the recipients -> start new one */
        /* check paid conversation */
        $chat_price = 0;
        $paid_recipients = [];
        foreach ($recipients as &$recipient) {
          $recipient_info = $this->get_user($recipient);
          if ($system['monetization_enabled'] && $this->check_user_permission($recipient, 'monetization_permission')) {
            if ($recipient_info['user_monetization_enabled'] && $recipient_info['user_monetization_chat_price'] > 0) {
              $chat_price += $recipient_info['user_monetization_chat_price'];
              $paid_recipients[] = $recipient_info;
            }
          }
          $recipient = $recipient_info;
        }
        /* check recipients chat privacy */
        $this->check_recipients_chat_privacy($recipients);
        if ($chat_price > 0) {
          $this->wallet_chat_payment($chat_price, $paid_recipients);
        }
        /* insert conversation */
        $db->query("INSERT INTO conversations (last_message_id) VALUES ('0')");
        $conversation_id = $db->insert_id;
        /* insert the sender (viewer) */
        $db->query(sprintf("INSERT INTO conversations_users (conversation_id, user_id, seen) VALUES (%s, %s, '1')", secure($conversation_id, 'int'), secure($this->_data['user_id'], 'int')));
        /* insert recipients */
        foreach ($recipients as $_recipient) {
          $db->query(sprintf("INSERT INTO conversations_users (conversation_id, user_id) VALUES (%s, %s)", secure($conversation_id, 'int'), secure($_recipient['user_id'], 'int')));
        }
      } else {
        /* [2] there is a conversation between the viewer and the recipients */
        /* set the conversation_id */
        $conversation_id = $mutual_conversation;
        /* get conversation */
        $conversation = $this->get_conversation($conversation_id);
        /* check recipients chat privacy */
        $this->check_recipients_chat_privacy($conversation['recipients']);
        /* check paid conversation */
        if (!$conversation['node_id'] && $conversation['chat_price'] > 0) {
          $this->wallet_chat_payment($conversation['chat_price'], $conversation['paid_recipients']);
        }
      }
    } else {
      /* [3] post the message to -> existed conversation */
      /* check if user authorized */
      $conversation = $this->get_conversation($conversation_id);
      if (!$conversation) {
        throw new AuthorizationException(__("You are not authorized to do this"));
      }
      /* check recipients chat privacy (exclude: chatbox) */
      if (!$conversation['node_type']) {
        $this->check_recipients_chat_privacy($conversation['recipients']);
      }
      /* check paid conversation */
      if (!$conversation['node_id'] && $conversation['chat_price'] > 0) {
        $this->wallet_chat_payment($conversation['chat_price'], $conversation['paid_recipients']);
      }
      /* check if it's a chatbox */
      if ($conversation['node_id']) {
        switch ($conversation['node_type']) {
          case 'group':
            /* check user membership */
            $membership = $this->check_group_membership($this->_data['user_id'], $conversation['node_id']);
            if ($membership != "approved") {
              throw new Exception(__("You are not authorized to do this"));
            }
            break;

          case 'event':
            /* check user membership */
            $membership = $this->check_event_membership($this->_data['user_id'], $conversation['node_id']);
            if (!$membership) {
              throw new Exception(__("You are not authorized to do this"));
            }
            break;
        }
      }
      foreach ($conversation['recipients'] as $recipient) {
        /* check if the viewer is blocked by any of the recipients but not in a chatbox */
        if (!$conversation['node_id'] && $this->blocked($recipient['user_id'])) {
          $recipient_name = ($system['show_usernames_enabled']) ? $recipient['user_name'] : $recipient['user_firstname'] . " " . $recipient['user_lastname'];
          modal("MESSAGE", __("Message"), __("You aren't allowed to message") . " " . $recipient_name);
        }
      }
      /* update sender (viewer) as seen and not deleted if any */
      $db->query(sprintf("UPDATE conversations_users SET seen = '1', deleted = '0' WHERE conversation_id = %s AND user_id = %s", secure($conversation_id, 'int'), secure($this->_data['user_id'], 'int')));
      /* update recipients as not seen and not deleted if any (if not chatbox) */
      if (!$conversation['node_id']) {
        $db->query(sprintf("UPDATE conversations_users SET seen = '0', deleted = '0' WHERE conversation_id = %s AND user_id != %s", secure($conversation_id, 'int'), secure($this->_data['user_id'], 'int')));
      }
    }
    /* insert message */
    $db->query(sprintf("INSERT INTO conversations_messages (conversation_id, user_id, message, image, voice_note, time) VALUES (%s, %s, %s, %s, %s, %s)", secure($conversation_id, 'int'), secure($this->_data['user_id'], 'int'), secure($message), secure($photo), secure($voice_note), secure($date)));
    $message_id = $db->insert_id;
    /* update the conversation with last message id */
    $db->query(sprintf("UPDATE conversations SET last_message_id = %s WHERE conversation_id = %s", secure($message_id, 'int'), secure($conversation_id, 'int')));
    /* update sender (viewer) with last message id */
    $db->query(sprintf("UPDATE users SET user_live_messages_lastid = %s WHERE user_id = %s", secure($message_id, 'int'), secure($this->_data['user_id'], 'int')));
    /* get conversation */
    $conversation = $this->get_conversation($conversation_id);
    /* update all recipients with last message id & only offline recipient messages counter */
    foreach ($conversation['recipients'] as $recipient) {
      if (!$recipient['deleted']) {
        $db->query(sprintf("UPDATE users SET user_live_messages_lastid = %s, user_live_messages_counter = user_live_messages_counter + 1 WHERE user_id = %s", secure($message_id, 'int'), secure($recipient['user_id'], 'int')));
      }
      /* prepare notification message if voice note or image */
      if (!$message) {
        if ($voice_note) {
          $message = __("Sent a voice message");
        }
        if ($photo) {
          $message = __("Sent a photo");
        }
      }
      /* send notification */
      $this->post_notification(['to_user_id' => $recipient['user_id'], 'from_user_id' => $this->_data['user_id'], 'action' => 'chat_message', 'node_url' => $conversation_id, 'message' => $message]);
    }
    /* update typing status of the viewer for this conversation */
    $db->query(sprintf("UPDATE conversations_users SET typing = '0' WHERE conversation_id = %s AND user_id = %s", secure($conversation_id, 'int'), secure($this->_data['user_id'], 'int')));
    /* remove pending uploads */
    remove_pending_uploads([$photo, $voice_note]);
    /* return with conversation */
    return $conversation;
  }


  /**
   * get_conversation_messages
   * 
   * @param integer $conversation_id
   * @param integer $offset
   * @param integer $last_message_id
   * @return array
   */
  public function get_conversation_messages($conversation_id, $offset = 0, $last_message_id = null)
  {
    global $db, $system;
    /* check if user authorized to see this conversation */
    $check_conversation = $db->query(sprintf("SELECT COUNT(*) as count FROM conversations_users WHERE conversation_id = %s AND user_id = %s", secure($conversation_id, 'int'), secure($this->_data['user_id'], 'int')));
    if ($check_conversation->fetch_assoc()['count'] == 0) {
      throw new Exception(__("You are not authorized to view this"));
    }
    $offset *= $system['max_results'];
    $messages = [];
    if ($last_message_id !== null) {
      /* get all messages after the last_message_id */
      $get_messages = $db->query(sprintf("SELECT conversations_messages.message_id, conversations_messages.message, conversations_messages.image, conversations_messages.voice_note, conversations_messages.time, users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, users.user_subscribed, users.user_verified FROM conversations_messages INNER JOIN users ON conversations_messages.user_id = users.user_id WHERE conversations_messages.conversation_id = %s AND conversations_messages.message_id > %s", secure($conversation_id, 'int'), secure($last_message_id, 'int')));
    } else {
      $get_messages = $db->query(sprintf("SELECT * FROM ( SELECT conversations_messages.message_id, conversations_messages.message, conversations_messages.image, conversations_messages.voice_note, conversations_messages.time, users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, users.user_subscribed, users.user_verified FROM conversations_messages INNER JOIN users ON conversations_messages.user_id = users.user_id WHERE conversations_messages.conversation_id = %s ORDER BY conversations_messages.message_id DESC LIMIT %s,%s ) messages ORDER BY messages.message_id ASC", secure($conversation_id, 'int'), secure($offset, 'int', false), secure($system['max_results'], 'int', false)));
    }
    while ($message = $get_messages->fetch_assoc()) {
      $message['user_picture'] = get_picture($message['user_picture'], $message['user_gender']);
      $message['user_fullname'] = ($system['show_usernames_enabled']) ? $message['user_name'] : $message['user_firstname'] . " " . $message['user_lastname'];
      $message['message'] = $this->_parse(["text" => $message['message'], "decode_mentions" => false, "decode_hashtags" => false]);
      $message['message_decoded'] = html_entity_decode($message['message'], ENT_QUOTES);
      /* return */
      $messages[] = $message;
    }
    $has_more = (count($messages) == $system['max_results']) ? true : false;
    return ['messages' => $messages, 'has_more' => $has_more];
  }


  /**
   * get_conversation_messages_by_id
   * 
   * @param integer $message_id
   * @return array
   */
  public function get_conversation_messages_by_id($message_id)
  {
    global $db;
    $get_messages = $db->query(sprintf("SELECT conversations_messages.message_id, conversations_messages.message, conversations_messages.image, conversations_messages.voice_note, conversations_messages.time, users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, users.user_subscribed, users.user_verified FROM conversations_messages INNER JOIN users ON conversations_messages.user_id = users.user_id WHERE conversations_messages.message_id = %s", secure($message_id, 'int')));
    $message = $get_messages->fetch_assoc();
    $message['user_picture'] = get_picture($message['user_picture'], $message['user_gender']);
    $message['message'] = $this->_parse(["text" => $message['message'], "decode_mentions" => false, "decode_hashtags" => false]);
    $message['message_decoded'] = html_entity_decode($message['message'], ENT_QUOTES);
    return $message;
  }


  /**
   * get_conversation_total_messages
   * 
   * @param integer $conversation_id
   * @return integer
   */
  public function get_conversation_total_messages($conversation_id)
  {
    global $db;
    $get_total_messages = $db->query(sprintf("SELECT COUNT(*) as count FROM conversations_messages WHERE conversation_id = %s", secure($conversation_id, 'int')));
    return $get_total_messages->fetch_assoc()['count'];
  }


  /**
   * delete_conversation
   * 
   * @param integer $conversation_id
   * @return void
   */
  public function delete_conversation($conversation_id)
  {
    global $db, $system;
    /* check if user authorized */
    $check_conversation = $db->query(sprintf("SELECT COUNT(*) as count FROM conversations_users INNER JOIN conversations ON conversations_users.conversation_id = conversations.conversation_id WHERE conversations.node_id IS NULL AND conversations.conversation_id = %s AND conversations_users.user_id = %s", secure($conversation_id, 'int'), secure($this->_data['user_id'], 'int')));
    if ($check_conversation->fetch_assoc()['count'] == 0) {
      throw new AuthorizationException(__("You are not authorized to do this"));
    }
    if ($system['chat_permanently_delete_enabled']) {
      /* delete conversation */
      $db->query(sprintf("DELETE FROM conversations WHERE conversation_id = %s", secure($conversation_id, 'int')));
      /* delete conversation users */
      $db->query(sprintf("DELETE FROM conversations_users WHERE conversation_id = %s", secure($conversation_id, 'int')));
      /* delete conversation messages */
      $db->query(sprintf("DELETE FROM conversations_messages WHERE conversation_id = %s", secure($conversation_id, 'int')));
    } else {
      /* update typing status of the viewer for this conversation */
      $is_typing = '0';
      $db->query(sprintf("UPDATE conversations_users SET typing = %s WHERE conversation_id = %s AND user_id = %s", secure($is_typing), secure($conversation_id, 'int'), secure($this->_data['user_id'], 'int')));
      /* update conversation as deleted */
      $db->query(sprintf("UPDATE conversations_users SET deleted = '1' WHERE conversation_id = %s AND user_id = %s", secure($conversation_id, 'int'), secure($this->_data['user_id'], 'int')));
    }
  }


  /**
   * leave_conversation
   * 
   * @param integer $conversation_id
   * @return void
   */
  public function leave_conversation($conversation_id)
  {
    global $db;
    /* check if user authorized */
    $check_conversation = $db->query(sprintf("SELECT COUNT(*) as count FROM conversations_users WHERE conversation_id = %s AND user_id = %s", secure($conversation_id, 'int'), secure($this->_data['user_id'], 'int')));
    if ($check_conversation->fetch_assoc()['count'] == 0) {
      throw new AuthorizationException(__("You are not authorized to do this"));
    }
    /* update typing status of the viewer for this conversation */
    $is_typing = '0';
    $db->query(sprintf("UPDATE conversations_users SET typing = %s WHERE conversation_id = %s AND user_id = %s", secure($is_typing), secure($conversation_id, 'int'), secure($this->_data['user_id'], 'int')));
    /* update conversation as deleted */
    $db->query(sprintf("UPDATE conversations_users SET deleted = '1' WHERE conversation_id = %s AND user_id = %s", secure($conversation_id, 'int'), secure($this->_data['user_id'], 'int')));
  }


  /**
   * get_conversation_color
   * 
   * @param integer $conversation_id
   * @return string
   */
  public function get_conversation_color($conversation_id)
  {
    global $db;
    $get_conversation = $db->query(sprintf("SELECT color FROM conversations WHERE conversation_id = %s", secure($conversation_id, 'int')));
    return $get_conversation->fetch_assoc()['color'];
  }


  /**
   * set_conversation_color
   * 
   * @param integer $conversation_id
   * @param string $color
   * @return void
   */
  public function set_conversation_color($conversation_id, $color)
  {
    global $db;
    /* check if user authorized */
    $check_conversation = $db->query(sprintf("SELECT COUNT(*) as count FROM conversations_users WHERE conversation_id = %s AND user_id = %s", secure($conversation_id, 'int'), secure($this->_data['user_id'], 'int')));
    if ($check_conversation->fetch_assoc()['count'] == 0) {
      throw new AuthorizationException(__("You are not authorized to do this"));
    }
    $db->query(sprintf("UPDATE conversations SET color = %s WHERE conversation_id = %s", secure($color), secure($conversation_id, 'int')));
  }


  /**
   * update_conversation_typing_status
   * 
   * @param integer $conversation_id
   * @param boolean $is_typing
   * @return void
   */
  public function update_conversation_typing_status($conversation_id, $is_typing)
  {
    global $db, $system;
    /* check if typing is enabled */
    if (!$system['chat_typing_enabled']) {
      return;
    }
    /* validate inputs */
    if (!isset($conversation_id) || !isset($is_typing)) {
      return;
    }
    /* check if user authorized */
    $check_conversation = $db->query(sprintf("SELECT COUNT(*) as count FROM conversations_users WHERE conversation_id = %s AND user_id = %s", secure($conversation_id, 'int'), secure($this->_data['user_id'], 'int')));
    if ($check_conversation->fetch_assoc()['count'] == 0) {
      return;
    }
    /* update typing status of the viewer for this conversation */
    $is_typing = ($is_typing) ? '1' : '0';
    $db->query(sprintf("UPDATE conversations_users SET typing = %s WHERE conversation_id = %s AND user_id = %s", secure($is_typing), secure($conversation_id, 'int'), secure($this->_data['user_id'], 'int')));
  }


  /**
   * update_conversation_seen_status
   * 
   * @param array $conversation_ids
   * @return void
   */
  public function update_conversation_seen_status($conversation_ids)
  {
    global $db, $system;
    /* check if seen is enabled */
    if (!$system['chat_seen_enabled']) {
      return;
    }
    /* validate inputs */
    if (!isset($conversation_ids)) {
      return;
    }
    /* check if user authorized */
    $conversations_array = [];
    foreach ((array)$conversation_ids as $conversation_id) {
      $check_conversation = $db->query(sprintf("SELECT COUNT(*) as count FROM conversations_users WHERE conversation_id = %s AND user_id = %s", secure($conversation_id, 'int'), secure($this->_data['user_id'], 'int')));
      if ($check_conversation->fetch_assoc()['count'] > 0) {
        $conversations_array[] = $conversation_id;
      }
    }
    if (!$conversations_array) return;
    /* update seen status of the viewer to these conversation(s) */
    $db->query(sprintf("UPDATE conversations_users SET seen = '1' WHERE conversation_id IN (%s) AND user_id = %s", $this->spread_ids($conversations_array), secure($this->_data['user_id'], 'int')));
  }


  /**
   * create_chatbox
   * 
   * @param integer $node_id
   * @param string $node_type
   * @return integer
   */
  public function create_chatbox($node_id, $node_type)
  {
    global $db, $system;
    /* insert conversation */
    $db->query(sprintf("INSERT INTO conversations (last_message_id, node_id, node_type) VALUES ('0', %s, %s)", secure($node_id, 'int'), secure($node_type)));
    $conversation_id = $db->insert_id;
    /* insert the node admin (viewer) */
    $db->query(sprintf("INSERT INTO conversations_users (conversation_id, user_id, seen) VALUES (%s, %s, '1')", secure($conversation_id, 'int'), secure($this->_data['user_id'], 'int')));
    /* return conversation_id */
    return $conversation_id;
  }


  /**
   * get_chatbox
   * 
   * @param integer $conversation_id
   * @return array
   */
  public function get_chatbox($conversation_id)
  {
    global $db;
    /* check if the viewer is already in chatbox */
    $check_conversations_users = $db->query(sprintf("SELECT COUNT(*) as count FROM conversations_users WHERE conversation_id = %s AND user_id = %s", secure($conversation_id, 'int'), secure($this->_data['user_id'], 'int')));
    if ($check_conversations_users->fetch_assoc()['count'] == 0) {
      /* insert the viewer */
      $db->query(sprintf("INSERT INTO conversations_users (conversation_id, user_id, seen) VALUES (%s, %s, '1')", secure($conversation_id, 'int'), secure($this->_data['user_id'], 'int')));
    }
    /* get conversation */
    $conversation = $this->get_conversation($conversation_id);
    if ($conversation) {
      /* get conversation messages */
      $conversation['messages'] = $this->get_conversation_messages($conversation_id)['messages'];
      /* return */
      return $conversation;
    }
    return false;
  }


  /**
   * delete_chatbox
   * 
   * @param integer $conversation_id
   * @return void
   */
  public function delete_chatbox($conversation_id)
  {
    global $db;
    /* delete conversation */
    $db->query(sprintf("DELETE FROM conversations WHERE conversation_id = %s", secure($conversation_id, 'int')));
    /* delete conversation users */
    $db->query(sprintf("DELETE FROM conversations_users WHERE conversation_id = %s", secure($conversation_id, 'int')));
    /* delete conversation messages */
    $db->query(sprintf("DELETE FROM conversations_messages WHERE conversation_id = %s", secure($conversation_id, 'int')));
  }


  /**
   * check_recipients_chat_privacy
   * 
   * @param array $recipients
   * @return void
   */
  public function check_recipients_chat_privacy($recipients)
  {
    global $system;
    /* check the viewer chat privacy */
    if ($this->_data['user_privacy_chat'] == 'me') {
      throw new PrivacyException(__("You set your chat privacy to no one, Go to your privacy settings to change this"));
    }
    foreach ($recipients as $recipient) {
      /* check the target recipient chat privacy */
      if ($recipient['user_privacy_chat'] == 'me' || $recipient['user_privacy_chat'] == 'friends' && !$this->friendship_approved($recipient['user_id'])) {
        $recipient['fullname'] = ($system['show_usernames_enabled']) ? $recipient['user_name'] : $recipient['user_firstname'] . " " . $recipient['user_lastname'];
        throw new PrivacyException(__("You can't chat with this") . " " . $recipient['fullname']);
      }
      /* check the viewer chat privacy */
      if ($this->_data['user_privacy_chat'] == 'friends' && !$this->friendship_approved($recipient['user_id'])) {
        $recipient['fullname'] = ($system['show_usernames_enabled']) ? $recipient['user_name'] : $recipient['user_firstname'] . " " . $recipient['user_lastname'];
        throw new PrivacyException(__("You can't chat with this") . " " . $recipient['fullname'] . " " . __("because your chat privacy is set to friends only"));
      }
    }
  }
}
