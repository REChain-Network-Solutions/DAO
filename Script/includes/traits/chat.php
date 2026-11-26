<?php

/**
 * trait -> chat
 * 
 * @package Sngine
 * @author Zamblek
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
    $get_user_status = $this->conversation_details('online', $user_id) ?? $db->query(sprintf(
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
        WHERE (conversations.node_id IS NULL OR conversations.node_type = 'page')
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
        WHERE (conversations.node_id IS NULL OR conversations.node_type = 'page')
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
  public function get_conversations($offset = 0, $cursor = null)
  {
    global $db, $system;
    /* get conversations */
    $conversations = [];
    $next_cursor = null;
    $offset *= $system['max_results'];
    /* pages after the first continue from a cursor (the last conversation's last message & id) instead of an offset */
    $cursor = cursor_decode($cursor, ['int', 'int']);
    $cursor_statement = ($cursor) ? " AND " . cursor_where(['conversations.last_message_id', 'conversations.conversation_id'], $cursor) : "";
    $limit_statement = ($cursor) ? sprintf("LIMIT %s", secure($system['max_results'], 'int', false)) : sprintf("LIMIT %s, %s", secure($offset, 'int', false), secure($system['max_results'], 'int', false));
    $get_conversations = $db->query(sprintf(
      "SELECT conversations.conversation_id, conversations.last_message_id 
      FROM conversations 
      INNER JOIN conversations_users 
        ON conversations.conversation_id = conversations_users.conversation_id 
      WHERE conversations_users.deleted = '0' 
        AND conversations_users.user_id = %s" . $cursor_statement . " 
      ORDER BY conversations.last_message_id DESC, conversations.conversation_id DESC 
      " . $limit_statement,
      secure($this->_data['user_id'], 'int')
    ));
    if ($get_conversations->num_rows > 0) {
      $conversations_rows = $get_conversations->fetch_all(MYSQLI_ASSOC);
      $conversations_ids = array_column($conversations_rows, 'conversation_id');
      $last_row = end($conversations_rows);
      $next_cursor = cursor_encode([$last_row['last_message_id'], $last_row['conversation_id']]);
      /* load the details of all conversations at once */
      $previous_prefetch = $this->_conversations_prefetch;
      $this->prefetch_conversations($conversations_ids);
      try {
        foreach ($conversations_ids as $conversation_id) {
          $conversation = $this->get_conversation($conversation_id);
          if ($conversation) {
            $conversations[] = $conversation;
          }
        }
      } finally {
        $this->_conversations_prefetch = $previous_prefetch;
      }
    }
    $has_more = (count($conversations) < $system['max_results']) ? false : true;
    $this->_cursor = $next_cursor;
    return ['data' => $conversations, 'has_more' => $has_more, 'cursor' => $next_cursor];
  }


  /**
   * prefetch_conversations
   * 
   * @param array $conversations_ids
   * @return void
   */
  private function prefetch_conversations($conversations_ids)
  {
    global $db, $system;
    if (defined('POSTS_PREFETCH_DISABLED') && POSTS_PREFETCH_DISABLED) {
      return;
    }
    $conversations_ids = array_values(array_unique(array_filter(array_map('intval', $conversations_ids))));
    if (!$conversations_ids) {
      return;
    }
    $viewer_id = secure($this->_data['user_id'], 'int');
    $prefetch = [];
    $add = function ($key, $ids, $rows, $id_column = 'prefetch_id') use (&$prefetch) {
      $prefetch[$key . '_covered'] = array_fill_keys(array_map('intval', $ids), true);
      $prefetch[$key] = [];
      foreach ($rows as $row) {
        $row_id = $row[$id_column];
        if ($id_column == 'prefetch_id') {
          unset($row['prefetch_id']);
        }
        $prefetch[$key][$row_id][] = $row;
      }
    };
    $list = implode(',', $conversations_ids);
    /* conversations */
    $rows = $db->query(sprintf("SELECT conversations.*, conversations_users.seen, conversations.conversation_id AS prefetch_id FROM conversations INNER JOIN conversations_users ON conversations.conversation_id = conversations_users.conversation_id WHERE conversations_users.user_id = %s AND conversations.conversation_id IN (%s)", $viewer_id, $list))->fetch_all(MYSQLI_ASSOC);
    $add('rows', $conversations_ids, $rows);
    /* recipients */
    $recipients = $db->query(sprintf("SELECT conversations_users.seen, conversations_users.deleted, conversations_users.typing, users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, users.user_subscribed, users.user_verified, users.user_monetization_enabled, users.user_monetization_chat_price, users.user_monetization_call_price, users.user_privacy_chat, users.user_last_seen, conversations_users.conversation_id AS prefetch_id FROM conversations_users INNER JOIN users ON conversations_users.user_id = users.user_id WHERE conversations_users.conversation_id IN (%s) AND conversations_users.user_id != %s ORDER BY conversations_users.conversation_id, conversations_users.user_id", $list, $viewer_id))->fetch_all(MYSQLI_ASSOC);
    $add('recipients', $conversations_ids, $recipients);
    /* messages counts */
    $counts = [];
    foreach ($db->query(sprintf("SELECT conversation_id, COUNT(*) as count FROM conversations_messages WHERE conversation_id IN (%s) GROUP BY conversation_id", $list))->fetch_all(MYSQLI_ASSOC) as $count) {
      $counts[] = ['count' => $count['count'], 'prefetch_id' => $count['conversation_id']];
    }
    $prefetch['total_messages_covered'] = array_fill_keys($conversations_ids, true);
    $prefetch['total_messages'] = [];
    foreach ($conversations_ids as $conversation_id) {
      $prefetch['total_messages'][$conversation_id] = [['count' => '0']];
    }
    foreach ($counts as $count) {
      $prefetch['total_messages'][$count['prefetch_id']] = [['count' => $count['count']]];
    }
    /* last & pinned messages, their media and the viewer's reactions */
    $messages_ids = [];
    foreach ($rows as $row) {
      $messages_ids[] = (int) $row['last_message_id'];
      $messages_ids[] = (int) $row['pinned_message_id'];
    }
    $messages_ids = array_values(array_unique(array_filter($messages_ids)));
    if ($messages_ids) {
      $messages_list = implode(',', $messages_ids);
      $messages = $db->query(sprintf("SELECT conversations_messages.*, users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, users.user_subscribed, users.user_verified, conversations_messages.message_id AS prefetch_id FROM conversations_messages INNER JOIN users ON conversations_messages.user_id = users.user_id WHERE conversations_messages.message_id IN (%s)", $messages_list))->fetch_all(MYSQLI_ASSOC);
      $add('messages', $messages_ids, $messages);
      $prefetch = array_merge($prefetch, $this->prefetch_messages_details($messages_ids));
    }
    /* recipients online status & permissions */
    $users_ids = array_values(array_unique(array_map('intval', array_column($recipients, 'user_id'))));
    if ($users_ids) {
      $users_list = implode(',', $users_ids);
      $online = array_column($db->query(sprintf("SELECT user_id FROM users WHERE user_id IN (%s) AND user_chat_enabled = '1' AND user_privacy_chat != 'me' AND user_last_seen >= SUBTIME(NOW(), SEC_TO_TIME(%s))", $users_list, secure($system['offline_time'], 'int', false)))->fetch_all(MYSQLI_ASSOC), 'user_id');
      $prefetch['online_covered'] = array_fill_keys($users_ids, true);
      $prefetch['online'] = [];
      foreach ($users_ids as $user_id) {
        $prefetch['online'][$user_id] = [['count' => (in_array($user_id, $online)) ? '1' : '0']];
      }
      $profiles = $db->query(sprintf("SELECT users.user_id, users.user_group, users.user_group_custom, users.user_verified, users.user_subscribed , users_groups.permissions_group_id, packages.package_permissions_group_id, users.user_id AS prefetch_id FROM users LEFT JOIN packages ON users.user_subscribed = '1' AND users.user_package = packages.package_id LEFT JOIN users_groups ON users.user_group = '3' AND users.user_group_custom != '0' AND users.user_group_custom = users_groups.user_group_id WHERE users.user_id IN (%s)", $users_list))->fetch_all(MYSQLI_ASSOC);
      $add('permission_profiles', $users_ids, $profiles);
    }
    $this->_conversations_prefetch = $prefetch;
  }


  /**
   * prefetch_messages_details
   * 
   * @param array $messages_ids
   * @return array
   */
  private function prefetch_messages_details($messages_ids)
  {
    global $db;
    $messages_ids = array_values(array_unique(array_filter(array_map('intval', $messages_ids))));
    if (!$messages_ids) {
      return [];
    }
    $messages_list = implode(',', $messages_ids);
    $details = [
      'message_media_covered' => array_fill_keys($messages_ids, true),
      'message_media' => [],
      'message_reactions_covered' => array_fill_keys($messages_ids, true),
      'message_reactions' => [],
    ];
    $get_media = $db->query(sprintf("SELECT conversations_messages_media.*, conversations_messages_media.message_id AS prefetch_id FROM conversations_messages_media WHERE message_id IN (%s) ORDER BY media_id ASC", $messages_list));
    while ($media = $get_media->fetch_assoc()) {
      $media_message_id = $media['prefetch_id'];
      unset($media['prefetch_id']);
      $details['message_media'][$media_message_id][] = $media;
    }
    $get_reactions = $db->query(sprintf("SELECT message_id, reaction FROM conversations_messages_reactions WHERE user_id = %s AND message_id IN (%s)", secure($this->_data['user_id'], 'int'), $messages_list));
    while ($reaction = $get_reactions->fetch_assoc()) {
      $details['message_reactions'][$reaction['message_id']] ??= [['reaction' => $reaction['reaction']]];
    }
    return $details;
  }


  /**
   * conversation_details
   * 
   * @param string $key
   * @param integer $id
   * @return PrefetchedResult|null
   */
  private function conversation_details($key, $id)
  {
    if (!isset($this->_conversations_prefetch[$key . '_covered'][(int) $id])) {
      return null;
    }
    return new PrefetchedResult($this->_conversations_prefetch[$key][(int) $id] ?? []);
  }


  /**
   * search_conversations
   * 
   * @param string $query
   * @param string $filter
   * @param integer $offset
   * @return array
   */
  public function search_conversations($query = '', $filter = 'all', $offset = 0)
  {
    global $db, $system;
    $conversations = [];
    $offset = (int) $offset * $system['max_results'];
    $query = trim((string) $query);
    $where = [];
    $matched = "NULL";
    /* text search */
    if ($query !== '') {
      $q = secure($query, 'search');
      $matched = sprintf("(SELECT MAX(conversations_messages.message_id) FROM conversations_messages WHERE conversations_messages.conversation_id = conversations.conversation_id AND conversations_messages.message LIKE %s AND (conversations_messages.is_paid != '1' OR conversations_messages.user_id = %s))", $q, secure($this->_data['user_id'], 'int'));
      $where[] = sprintf(
        "(conversations.name LIKE %1\$s
          OR (conversations.node_type = 'group' AND EXISTS (SELECT 1 FROM `groups` WHERE `groups`.group_id = conversations.node_id AND `groups`.group_title LIKE %1\$s))
          OR (conversations.node_type = 'event' AND EXISTS (SELECT 1 FROM `events` WHERE `events`.event_id = conversations.node_id AND `events`.event_title LIKE %1\$s))
          OR EXISTS (SELECT 1 FROM conversations_users AS members INNER JOIN users ON members.user_id = users.user_id WHERE members.conversation_id = conversations.conversation_id AND members.user_id != %2\$s AND (CONCAT(users.user_firstname, ' ', users.user_lastname) LIKE %1\$s OR users.user_name LIKE %1\$s))
          OR %3\$s IS NOT NULL)",
        $q,
        secure($this->_data['user_id'], 'int'),
        $matched
      );
    }
    /* filters */
    if ($filter == 'unread') {
      $where[] = "conversations_users.seen = '0'";
    } elseif ($filter == 'groups') {
      $where[] = "(conversations.node_id IS NOT NULL OR (SELECT COUNT(*) FROM conversations_users AS members WHERE members.conversation_id = conversations.conversation_id) > 2)";
    }
    $get_conversations = $db->query(sprintf(
      "SELECT conversations.conversation_id, %s AS matched_message_id
      FROM conversations
      INNER JOIN conversations_users
        ON conversations.conversation_id = conversations_users.conversation_id
      WHERE conversations_users.deleted = '0'
        AND conversations_users.user_id = %s
        %s
      ORDER BY COALESCE(matched_message_id, conversations.last_message_id) DESC
      LIMIT %s, %s",
      $matched,
      secure($this->_data['user_id'], 'int'),
      ($where) ? "AND " . implode(" AND ", $where) : "",
      secure($offset, 'int', false),
      secure($system['max_results'], 'int', false)
    ));
    while ($row = $get_conversations->fetch_assoc()) {
      $conversation = $this->get_conversation($row['conversation_id']);
      if (!$conversation) {
        continue;
      }
      if ($row['matched_message_id']) {
        $conversation['search_message'] = $this->get_conversation_message_by_id($row['matched_message_id']);
      }
      $conversations[] = $conversation;
    }
    $has_more = (count($conversations) < $system['max_results']) ? false : true;
    return ['data' => $conversations, 'has_more' => $has_more];
  }


  /**
   * get_conversation
   * 
   * @param integer $conversation_id
   * @param boolean $as_page
   * @return array
   */
  public function get_conversation($conversation_id, $as_page = false)
  {
    global $db, $system;
    $conversation = [];
    if ($as_page) {
      /* page inbox (the viewer manages the page) */
      $get_conversation = $db->query(sprintf(
        "SELECT
          conversations.*,
          pages_conversations.seen
        FROM conversations
        INNER JOIN pages_conversations
          ON conversations.conversation_id = pages_conversations.conversation_id
        WHERE conversations.conversation_id = %s",
        secure($conversation_id, 'int')
      ));
    } else {
      $get_conversation = $this->conversation_details('rows', $conversation_id) ?? $db->query(sprintf(
        "SELECT
          conversations.*,
          conversations_users.seen
        FROM conversations
        INNER JOIN conversations_users
          ON conversations.conversation_id = conversations_users.conversation_id
        WHERE conversations_users.user_id = %s
          AND conversations.conversation_id = %s",
        secure($this->_data['user_id'], 'int'),
        secure($conversation_id, 'int')
      ));
    }
    if ($get_conversation->num_rows == 0) {
      return false;
    }
    $conversation = $get_conversation->fetch_assoc();
    if ($as_page && !$this->check_page_adminship($this->_data['user_id'], $conversation['node_id'])) {
      return false;
    }
    $conversation['custom_name'] = trim((string)($conversation['name'] ?? ''));
    /* get recipients */
    $get_recipients = ((!$as_page) ? $this->conversation_details('recipients', $conversation['conversation_id']) : null) ?? $db->query(sprintf(
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
    if ((!$conversation['node_id'] || $as_page) && $recipients_num == 0) {
      return false;
    }
    $i = 1;
    $conversation['chat_price'] = 0;
    $conversation['call_price'] = 0;
    $conversation['paid_recipients'] = [];
    while ($recipient = $get_recipients->fetch_assoc()) {
      /* check if paid chat */
      if ($system['monetization_enabled'] && !$this->dating_matched($recipient['user_id']) && $this->check_user_permission($recipient['user_id'], 'monetization_permission') && $recipient['user_monetization_enabled'] && ($recipient['user_monetization_chat_price'] > 0 || $recipient['user_monetization_call_price'] > 0)) {
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
          $conversation['typing_name_list'] .= (($system['show_usernames_enabled']) ? $recipient['user_name'] : $recipient['user_firstname']);
        }
      }
      /* prepare seen recipients */
      if ($system['chat_seen_enabled'] && $recipient['seen']) {
        if ($conversation['seen_name_list']) {
          $conversation['seen_name_list'] .= ", ";
        }
        $conversation['seen_name_list'] .= (($system['show_usernames_enabled']) ? $recipient['user_name'] : $recipient['user_firstname']);
      }
      /* prepare conversation name_list */
      $conversation['name_list'] .= (($system['show_usernames_enabled']) ? $recipient['user_name'] : $recipient['user_firstname']);
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

      case 'page':
        /* get page */
        $page = $this->get_chat_page($conversation['node_id']);
        $conversation['page_id'] = $conversation['node_id'];
        $conversation['page_messages_enabled'] = ($page && $page['page_messages_enabled'] && $system['pages_enabled'] && $system['pages_messages_enabled']);
        if (!$as_page) {
          /* the viewer is the customer -> the page is the recipient */
          $get_page_conversation = $db->query(sprintf("SELECT seen, typing FROM pages_conversations WHERE conversation_id = %s", secure($conversation['conversation_id'], 'int')));
          $page_conversation = $get_page_conversation->fetch_assoc();
          $conversation['multiple_recipients'] = false;
          $conversation['link'] = ($page) ? 'pages/' . $page['page_name'] : 'messages/' . $conversation['conversation_id'];
          $conversation['picture'] = ($page) ? $page['page_picture'] : get_picture('', 'page');
          $conversation['name'] = ($page) ? $page['page_title'] : __("Page");
          $conversation['name_list'] = $conversation['name'];
          $conversation['name_html'] = '<a href="' . $system['system_url'] . '/' . $conversation['link'] . '">' . $conversation['name'] . '</a>';
          if ($system['chat_seen_enabled'] && $page_conversation['seen']) {
            $conversation['seen_name_list'] = $conversation['name'];
          }
          if ($system['chat_typing_enabled'] && $page_conversation['typing']) {
            $conversation['typing_name_list'] = $conversation['name'];
          }
          break;
        }
        /* the viewer manages the page -> the customer is the recipient */
        $conversation['as_page'] = true;
        $conversation['page_name'] = ($page) ? $page['page_name'] : '';
        $conversation['page_title'] = ($page) ? $page['page_title'] : '';
        /* continue as one recipient conversation */

      default:
        if ($recipients_num > 1) {
          /* multiple recipients */
          $conversation['multiple_recipients'] = true;
          $conversation['link'] = 'messages/' . $conversation['conversation_id'];
          $conversation['picture_left'] = $conversation['recipients'][0]['user_picture'];
          $conversation['picture_right'] = $conversation['recipients'][1]['user_picture'];
          if ($recipients_num > 2) {
            $conversation['name'] = (($system['show_usernames_enabled']) ? $conversation['recipients'][0]['user_name'] : $conversation['recipients'][0]['user_firstname']) . ", " . (($system['show_usernames_enabled']) ? $conversation['recipients'][1]['user_name'] : $conversation['recipients'][1]['user_firstname']) . " & " . ($recipients_num - 2) . " " . __("more");
          } else {
            $conversation['name'] = (($system['show_usernames_enabled']) ? $conversation['recipients'][0]['user_name'] : $conversation['recipients'][0]['user_firstname']) . " & " . (($system['show_usernames_enabled']) ? $conversation['recipients'][1]['user_name'] : $conversation['recipients'][1]['user_firstname']);
          }
        } else {
          /* one recipient */
          $conversation['multiple_recipients'] = false;
          $conversation['user_id'] = $conversation['recipients'][0]['user_id'];
          $conversation['link'] = $conversation['recipients'][0]['user_name'];
          $conversation['picture'] = $conversation['recipients'][0]['user_picture'];
          $conversation['name'] = (($system['show_usernames_enabled']) ? $conversation['recipients'][0]['user_name'] : $conversation['recipients'][0]['user_firstname'] . " " . $conversation['recipients'][0]['user_lastname']);
          $conversation['name_html'] = popover($conversation['recipients'][0]['user_id'], $conversation['recipients'][0]['user_name'], ($system['show_usernames_enabled']) ? $conversation['recipients'][0]['user_name'] : $conversation['recipients'][0]['user_firstname'] . " " . $conversation['recipients'][0]['user_lastname']);
          $conversation['user_is_online'] = $this->user_online($conversation['recipients'][0]['user_id']);
          $conversation['user_last_seen'] = $conversation['recipients'][0]['user_last_seen'];
        }
        break;
    }
    if ($conversation['custom_name'] !== '' && !empty($conversation['multiple_recipients']) && empty($conversation['node_id'])) {
      $conversation['name'] = $conversation['custom_name'];
    }
    /* get is chatbox */
    $conversation['is_chatbox'] = $this->is_chatbox_conversation($conversation);
    /* get total number of messages */
    $conversation['total_messages'] = $this->get_conversation_total_messages($conversation_id);
    /* get last message */
    $conversation['last_message'] = $this->get_conversation_message_by_id($conversation['last_message_id'], null, $as_page);
    /* pinned message */
    $conversation['pinned_message'] = null;
    if (!empty($conversation['pinned_message_id'])) {
      $conversation['pinned_message'] = $this->get_conversation_message_by_id($conversation['pinned_message_id'], null, $as_page);
      if (!$conversation['pinned_message']) {
        $conversation['pinned_message_id'] = null;
      }
    }
    /* return */
    return $conversation;
  }


  /**
   * check_mutual_conversation
   * 
   * @param integer $conversation_id
   * @param integer $user_id
   * @param integer $page_id
   * @param boolean $as_page
   * @return array
   */
  public function check_mutual_conversation($conversation_id = null, $user_id = null, $page_id = null, $as_page = false)
  {
    global $db;
    /* prepare */
    $conversation = [];
    /* if both not set */
    if (!$conversation_id && !$user_id && !$page_id) {
      throw new BadRequestException(__("Conversation ID or User ID is required"));
    }
    /* if page_id is set -> check if there is a conversation with this page */
    if ($page_id) {
      $page_conversation_id = $this->get_page_conversation_id($page_id, $this->_data['user_id']);
      if ($page_conversation_id) {
        /* set the conversation_id */
        $conversation_id = $page_conversation_id;
      }
    } elseif ($user_id) {
      $mutual_conversation_id = $this->get_mutual_conversation_id((array)$user_id);
      if ($mutual_conversation_id) {
        /* set the conversation_id */
        $conversation_id = $mutual_conversation_id;
      }
    }
    /* get convertsation details */
    if ($conversation_id) {
      $conversation = $this->get_conversation($conversation_id, $as_page);
      if ($conversation) {
        /* get conversation messages */
        $messages_data = $this->get_conversation_messages($conversation_id, 0, null, $as_page);
        $conversation['messages'] = $messages_data['messages'];
        $conversation['has_more'] = $messages_data['has_more'];
        /* check if last message sent by the viewer */
        if ($conversation['seen_name_list'] && $conversation['messages'] && $this->is_my_message(end($conversation['messages']), $as_page)) {
          $conversation['last_seen_message_id'] = end($conversation['messages'])['message_id'];
        }
      }
    }
    /* update conversation as seen */
    if ($as_page) {
      if ($conversation) {
        $this->update_conversation_seen_status([$conversation_id], true);
      }
    } else {
      $db->query(sprintf("UPDATE conversations_users SET seen = '1' WHERE conversation_id = %s AND user_id = %s", secure($conversation_id, 'int'), secure($this->_data['user_id'], 'int')));
    }
    return $conversation;
  }


  /**
   * is_my_message
   * 
   * @param array $message
   * @param boolean $as_page
   * @return boolean
   */
  public function is_my_message($message, $as_page = false)
  {
    if ($as_page) {
      return !empty($message['page_id']);
    }
    return (empty($message['page_id']) && $message['user_id'] == $this->_data['user_id']);
  }


  /**
   * is_chatbox_conversation
   * 
   * @param array $conversation
   * @return boolean
   */
  public function is_chatbox_conversation($conversation)
  {
    return in_array($conversation['node_type'] ?? null, ['group', 'event']);
  }


  /**
   * get_chat_page
   * 
   * @param integer $page_id
   * @return array|false
   */
  public function get_chat_page($page_id)
  {
    global $db;
    $get_page = $db->query(sprintf("SELECT page_id, page_admin, page_name, page_title, page_picture, page_verified, page_messages_enabled FROM pages WHERE page_id = %s", secure($page_id, 'int')));
    if ($get_page->num_rows == 0) {
      return false;
    }
    $page = $get_page->fetch_assoc();
    $page['page_picture'] = get_picture($page['page_picture'], 'page');
    return $page;
  }


  /**
   * get_page_conversation_id
   * 
   * @param integer $page_id
   * @param integer $user_id
   * @return integer|false
   */
  public function get_page_conversation_id($page_id, $user_id)
  {
    global $db;
    $get_conversation = $db->query(sprintf("SELECT conversation_id FROM pages_conversations WHERE page_id = %s AND user_id = %s", secure($page_id, 'int'), secure($user_id, 'int')));
    if ($get_conversation->num_rows == 0) {
      return false;
    }
    return $get_conversation->fetch_assoc()['conversation_id'];
  }


  /**
   * get_conversation_page_id
   * 
   * @param integer $conversation_id
   * @return integer|false
   */
  public function get_conversation_page_id($conversation_id)
  {
    global $db;
    $get_conversation = $db->query(sprintf("SELECT node_id FROM conversations WHERE conversation_id = %s AND node_type = 'page'", secure($conversation_id, 'int')));
    if ($get_conversation->num_rows == 0) {
      return false;
    }
    return $get_conversation->fetch_assoc()['node_id'];
  }


  /**
   * check_page_conversation_access
   * 
   * @param integer $conversation_id
   * @return integer|false
   */
  public function check_page_conversation_access($conversation_id)
  {
    $page_id = $this->get_conversation_page_id($conversation_id);
    if (!$page_id || !$this->check_page_adminship($this->_data['user_id'], $page_id)) {
      return false;
    }
    return $page_id;
  }


  /**
   * get_page_conversations
   * 
   * @param integer $page_id
   * @param integer $offset
   * @return array
   */
  public function get_page_conversations($page_id, $offset = 0, $cursor = null)
  {
    global $db, $system;
    $this->_cursor = null;
    /* check if the viewer manages the page */
    if (!$this->check_page_adminship($this->_data['user_id'], $page_id)) {
      throw new AuthorizationException(__("You are not authorized to do this"));
    }
    /* get conversations */
    $conversations = [];
    $next_cursor = null;
    $offset *= $system['max_results'];
    /* pages after the first continue from a cursor (the last conversation's last message & id) instead of an offset */
    $cursor = cursor_decode($cursor, ['int', 'int']);
    $cursor_statement = ($cursor) ? " AND " . cursor_where(['conversations.last_message_id', 'conversations.conversation_id'], $cursor) : "";
    $limit_statement = ($cursor) ? sprintf("LIMIT %s", secure($system['max_results'], 'int', false)) : sprintf("LIMIT %s, %s", secure($offset, 'int', false), secure($system['max_results'], 'int', false));
    $get_conversations = $db->query(sprintf(
      "SELECT pages_conversations.conversation_id, conversations.last_message_id
      FROM pages_conversations
      INNER JOIN conversations
        ON pages_conversations.conversation_id = conversations.conversation_id
      WHERE pages_conversations.page_id = %s
        AND conversations.last_message_id > 0" . $cursor_statement . "
      ORDER BY conversations.last_message_id DESC, conversations.conversation_id DESC
      " . $limit_statement,
      secure($page_id, 'int')
    ));
    while ($conversation = $get_conversations->fetch_assoc()) {
      $next_cursor = cursor_encode([$conversation['last_message_id'], $conversation['conversation_id']]);
      $conversation = $this->get_conversation($conversation['conversation_id'], true);
      if ($conversation) {
        $conversations[] = $conversation;
      }
    }
    $has_more = (count($conversations) < $system['max_results']) ? false : true;
    $this->_cursor = $next_cursor;
    return ['data' => $conversations, 'has_more' => $has_more, 'cursor' => $next_cursor];
  }


  /**
   * get_conversation_members_ids
   * 
   * @param integer $conversation_id
   * @return array
   */
  public function get_conversation_members_ids($conversation_id)
  {
    global $db;
    $members_ids = [];
    $get_members = $db->query(sprintf("SELECT user_id FROM conversations_users WHERE conversation_id = %s", secure($conversation_id, 'int')));
    while ($member = $get_members->fetch_assoc()) {
      $members_ids[] = $member['user_id'];
    }
    /* page conversation -> add the page admins */
    $page_id = $this->get_conversation_page_id($conversation_id);
    if ($page_id) {
      $members_ids = array_merge($members_ids, $this->get_page_admins_ids($page_id));
    }
    return array_values(array_unique($members_ids));
  }


  /**
   * get_page_unseen_conversations_count
   * 
   * @param integer $page_id
   * @return integer
   */
  public function get_page_unseen_conversations_count($page_id)
  {
    global $db;
    $get_count = $db->query(sprintf("SELECT COUNT(*) as count FROM pages_conversations INNER JOIN conversations ON pages_conversations.conversation_id = conversations.conversation_id WHERE pages_conversations.page_id = %s AND pages_conversations.seen = '0' AND conversations.last_message_id > 0", secure($page_id, 'int')));
    return $get_count->fetch_assoc()['count'];
  }


  /**
   * delete_page_conversation
   * 
   * @param integer $conversation_id
   * @return void
   */
  private function delete_page_conversation($conversation_id)
  {
    global $db;
    /* delete conversation messages translations */
    $db->query(sprintf("DELETE FROM translations_cache WHERE node_type = 'message' AND node_id IN (SELECT message_id FROM conversations_messages WHERE conversation_id = %s)", secure($conversation_id, 'int')));
    /* delete conversation messages media */
    $this->delete_messages_media(sprintf("conversation_id = %s", secure($conversation_id, 'int')));
    /* delete conversation messages reactions */
    $db->query(sprintf("DELETE FROM conversations_messages_reactions WHERE message_id IN (SELECT message_id FROM conversations_messages WHERE conversation_id = %s)", secure($conversation_id, 'int')));
    /* delete conversation messages */
    $db->query(sprintf("DELETE FROM conversations_messages WHERE conversation_id = %s", secure($conversation_id, 'int')));
    /* delete conversation */
    $db->query(sprintf("DELETE FROM conversations WHERE conversation_id = %s", secure($conversation_id, 'int')));
    $db->query(sprintf("DELETE FROM conversations_users WHERE conversation_id = %s", secure($conversation_id, 'int')));
    $db->query(sprintf("DELETE FROM pages_conversations WHERE conversation_id = %s", secure($conversation_id, 'int')));
  }


  /**
   * delete_page_conversations
   * 
   * @param integer $page_id
   * @return void
   */
  public function delete_page_conversations($page_id)
  {
    global $db;
    $get_conversations = $db->query(sprintf("SELECT conversation_id FROM pages_conversations WHERE page_id = %s", secure($page_id, 'int')));
    while ($conversation = $get_conversations->fetch_assoc()) {
      $this->delete_page_conversation($conversation['conversation_id']);
    }
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
    $video = $args['video'] ?? '';
    $photos = $this->filter_message_media_sources($args['photos'] ?? null, $from_web);
    $videos = $this->filter_message_media_sources($args['videos'] ?? null, $from_web);
    $files = $this->filter_message_files($args['files'] ?? null, $from_web);
    $voice_note = $args['voice_note'] ?? '';
    $gif = $args['gif'] ?? '';
    $product_post_id = $args['product_post_id'] ?? null;
    $story_id = $args['story_id'] ?? null;
    $reply_to = $args['reply_to'] ?? null;
    $conversation_id = $args['conversation_id'] ?? null;
    $recipients = $args['recipients'] ?? null;
    $page_id = $args['page_id'] ?? null;
    $as_page = !empty($args['as_page']) && $args['as_page'] !== 'false';
    /* check if story reply */
    if ($story_id) {
      $story = ($system['stories_enabled'] && $system['stories_replies_enabled']) ? $this->get_story($story_id) : false;
      if (!$story || $story['user_id'] == $this->_data['user_id']) {
        throw new BadRequestException(__("This story is no longer available"));
      }
      $story_id = (int) $story['story_id'];
      $reply_to = null;
      $conversation_id = null;
      $page_id = null;
      $as_page = false;
      $recipients = json_encode([(int) $story['user_id']]);
    }
    if ($reply_to && !is_numeric($reply_to)) {
      throw new BadRequestException(__("Invalid request"));
    }
    $reply_to = ($reply_to) ? (int) $reply_to : null;
    if ($page_id && !is_numeric($page_id)) {
      throw new BadRequestException(__("Invalid request"));
    }
    /* filter photo */
    if ($photo && $from_web) {
      $photo = json_decode($photo);
    }
    if ($photo) {
      if (is_object($photo)) {
        if (!is_valid_upload_source($photo->source ?? null)) {
          _error(400);
        }
        $photo = $photo->source;
      } elseif (!is_valid_upload_source($photo)) {
        _error(400);
      }
    }
    /* filter video */
    if ($video && $from_web) {
      $video = json_decode($video);
    }
    if ($video) {
      if (is_object($video)) {
        if (!is_valid_upload_source($video->source ?? null)) {
          _error(400);
        }
        $video = $video->source;
      } elseif (!is_valid_upload_source($video)) {
        _error(400);
      }
    }
    /* filter voice note */
    if ($voice_note && $from_web) {
      $voice_note = json_decode($voice_note);
    }
    if ($voice_note) {
      if (is_object($voice_note)) {
        if (!is_valid_upload_source($voice_note->source ?? null)) {
          _error(400);
        }
        $voice_note = $voice_note->source;
      } elseif (!is_valid_upload_source($voice_note)) {
        _error(400);
      }
    }
    /* filter gif */
    if ($gif && (!$this->_data['can_send_gifs'] || !valid_gif_url($gif))) {
      throw new BadRequestException(__("Invalid GIF"));
    }
    /* prepare media */
    if ($photo) {
      array_unshift($photos, $photo);
    }
    if ($video) {
      array_unshift($videos, $video);
    }
    $photos = array_values(array_unique($photos));
    $videos = array_values(array_unique($videos));
    $files = array_values(array_unique($files));
    if (!$this->_is_admin) {
      if ($photos && !$system['chat_photos_enabled']) {
        throw new AuthorizationException(__("Uploading photos feature has been disabled by the admin"));
      }
      if ($videos && (!$system['chat_videos_enabled'] || !$this->_data['can_upload_videos'])) {
        throw new AuthorizationException(__("Uploading videos feature has been disabled by the admin"));
      }
      if ($files && (!$system['chat_files_enabled'] || !$this->_data['can_upload_files'])) {
        throw new AuthorizationException(__("Uploading files feature has been disabled by the admin"));
      }
    }
    $max_media = max(1, (int) ($system['chat_max_media'] ?? 10));
    if (count($photos) + count($videos) + count($files) > $max_media) {
      throw new BadRequestException(__("You can only attach up to") . " " . $max_media . " " . __("photos, videos and files"));
    }
    /* if message not set */
    if (is_empty($message) && !$photos && !$videos && !$files && !$voice_note && !$gif && !$product_post_id) {
      throw new BadRequestException(__("Message or Image or Video or Voice Note is required"));
    }
    /* check if product post shared */
    if ($product_post_id) {
      $post = $this->get_post($product_post_id);
      if (!$post) {
        throw new BadRequestException(__("Product is not exists"));
      }
      if ($post['post_type'] != 'product') {
        throw new BadRequestException(__("Product post is not valid"));
      }
    }
    /* if conversation_id set but not numeric */
    if ($conversation_id && !is_numeric($conversation_id)) {
      throw new BadRequestException(__("Conversation ID must be numeric"));
    }
    /* check if page conversation */
    if (!$page_id && $conversation_id) {
      $page_id = $this->get_conversation_page_id($conversation_id);
    }
    $page_conversation = ($page_id || $as_page);
    $notify_page_admins = false;
    /* if both (conversation_id & recipients) not set */
    if (!$page_conversation && !$conversation_id && !$recipients) {
      throw new BadRequestException(__("Conversation ID or Recipients is required"));
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
    if ($page_conversation) {
      /* [0] page conversation */
      if ($as_page) {
        /* the page replies to the customer */
        if (!$conversation_id) {
          throw new BadRequestException(__("Invalid request"));
        }
        $conversation = $this->get_conversation($conversation_id, true);
        if (!$conversation) {
          throw new AuthorizationException(__("You are not authorized to do this"));
        }
        $page_id = $conversation['page_id'];
        /* update the page as seen */
        $db->query(sprintf("UPDATE pages_conversations SET seen = '1', typing = '0' WHERE conversation_id = %s", secure($conversation_id, 'int')));
        /* update the customer as not seen and not deleted */
        $db->query(sprintf("UPDATE conversations_users SET seen = '0', deleted = '0' WHERE conversation_id = %s", secure($conversation_id, 'int')));
      } else {
        /* the customer messages the page */
        $page = $this->get_chat_page($page_id);
        if (!$page || !$system['pages_enabled'] || !$system['pages_messages_enabled'] || !$page['page_messages_enabled']) {
          throw new AuthorizationException(__("This page is not receiving messages"));
        }
        if ($this->check_page_adminship($this->_data['user_id'], $page_id)) {
          throw new BadRequestException(__("You can't message your own page"));
        }
        if ($this->_data['user_privacy_chat'] == 'me') {
          throw new PrivacyException(__("You set your chat privacy to no one, Go to your privacy settings to change this"));
        }
        $page_conversation_id = $this->get_page_conversation_id($page_id, $this->_data['user_id']);
        if ($conversation_id && $conversation_id != $page_conversation_id) {
          throw new AuthorizationException(__("You are not authorized to do this"));
        }
        if (!$page_conversation_id) {
          /* insert conversation */
          $db->query(sprintf("INSERT INTO conversations (last_message_id, node_id, node_type) VALUES ('0', %s, 'page')", secure($page_id, 'int')));
          $conversation_id = $db->insert_id;
          /* insert the customer (viewer) */
          $db->query(sprintf("INSERT INTO conversations_users (conversation_id, user_id, seen) VALUES (%s, %s, '1')", secure($conversation_id, 'int'), secure($this->_data['user_id'], 'int')));
          /* insert the page */
          $db->query(sprintf("INSERT INTO pages_conversations (page_id, conversation_id, user_id) VALUES (%s, %s, %s)", secure($page_id, 'int'), secure($conversation_id, 'int'), secure($this->_data['user_id'], 'int')));
          $notify_page_admins = true;
        } else {
          $conversation_id = $page_conversation_id;
          /* notify the page admins only if the page has seen the conversation */
          $get_page_conversation = $db->query(sprintf("SELECT seen FROM pages_conversations WHERE conversation_id = %s", secure($conversation_id, 'int')));
          $notify_page_admins = ($get_page_conversation->fetch_assoc()['seen'] == '1');
          /* update sender (viewer) as seen and not deleted if any */
          $db->query(sprintf("UPDATE conversations_users SET seen = '1', deleted = '0' WHERE conversation_id = %s AND user_id = %s", secure($conversation_id, 'int'), secure($this->_data['user_id'], 'int')));
          /* update the page as not seen */
          $db->query(sprintf("UPDATE pages_conversations SET seen = '0' WHERE conversation_id = %s", secure($conversation_id, 'int')));
        }
      }
    } elseif ($conversation_id == null) {
      /* [first] check previous conversation between (viewer & recipients) */
      $mutual_conversation = $this->get_mutual_conversation_id($recipients);
      if (!$mutual_conversation) {
        /* [1] there is no conversation between viewer and the recipients -> start new one */
        /* check paid conversation */
        $chat_price = 0;
        $paid_recipients = [];
        foreach ($recipients as &$recipient) {
          $recipient_info = $this->get_user($recipient);
          if ($system['monetization_enabled'] && !$this->dating_matched($recipient) && $this->check_user_permission($recipient, 'monetization_permission')) {
            if ($recipient_info['user_monetization_enabled'] && $recipient_info['user_monetization_chat_price'] > 0) {
              $chat_price += $recipient_info['user_monetization_chat_price'];
              $paid_recipients[] = $recipient_info;
            }
          }
          $recipient = $recipient_info;
        }
        /* check recipients chat privacy */
        $this->check_recipients_chat_privacy($recipients);
        /* check paid conversation (exclude: chatbox & product post) */
        if (!$product_post_id && $chat_price > 0) {
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
        /* check paid conversation (exclude: chatbox & product post) */
        if (!$conversation['node_id'] && !$product_post_id && $conversation['chat_price'] > 0) {
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
    /* check if user is trying to share product post again */
    if ($product_post_id && $conversation && $conversation['last_message']['product_post_id'] == $product_post_id) {
      $product_post_id = null;
      if (is_empty($message) && !$photos && !$videos && !$files && !$voice_note && !$gif) {
        return;
      }
    }
    /* validate reply target */
    if ($reply_to) {
      $check_reply = $db->query(sprintf("SELECT COUNT(*) as count FROM conversations_messages WHERE message_id = %s AND conversation_id = %s", secure($reply_to, 'int'), secure($conversation_id, 'int')));
      if ($check_reply->fetch_assoc()['count'] == 0) {
        throw new BadRequestException(__("Invalid request"));
      }
    }
    /* insert message */
    $db->query(sprintf(
      "INSERT INTO conversations_messages (
        conversation_id,
        user_id,
        page_id,
        message,
        image,
        gif,
        video,
        voice_note,
        product_post_id,
        story_id,
        reply_to,
        time
      ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)",
      secure($conversation_id, 'int'),
      secure($this->_data['user_id'], 'int'),
      ($as_page) ? secure($page_id, 'int') : 'null',
      secure($message),
      secure(''),
      secure($gif),
      secure(''),
      secure($voice_note),
      ($product_post_id) ? secure($product_post_id, 'int') : 'null',
      ($story_id) ? secure($story_id, 'int') : 'null',
      ($reply_to) ? secure($reply_to, 'int') : 'null',
      secure($date)
    ));
    $message_id = $db->insert_id;
    /* update story replies counter */
    if ($story_id) {
      $db->query(sprintf("UPDATE stories SET replies_count = replies_count + 1 WHERE story_id = %s", secure($story_id, 'int')));
    }
    /* insert media rows */
    foreach (['photo' => $photos, 'video' => $videos] as $media_type => $sources) {
      foreach ($sources as $source) {
        $db->query(sprintf("INSERT INTO conversations_messages_media (message_id, media_type, source) VALUES (%s, %s, %s)", secure($message_id, 'int'), secure($media_type), secure($source)));
      }
    }
    foreach ($files as $file) {
      $db->query(sprintf(
        "INSERT INTO conversations_messages_media (message_id, media_type, source, name, size) VALUES (%s, 'file', %s, %s, %s)",
        secure($message_id, 'int'),
        secure($file['source']),
        secure($file['name']),
        secure($file['size'], 'int')
      ));
    }
    /* update the conversation with last message id */
    $db->query(sprintf("UPDATE conversations SET last_message_id = %s WHERE conversation_id = %s", secure($message_id, 'int'), secure($conversation_id, 'int')));
    /* update sender (viewer) with last message id */
    $db->query(sprintf("UPDATE users SET user_live_messages_lastid = %s WHERE user_id = %s", secure($message_id, 'int'), secure($this->_data['user_id'], 'int')));
    /* get conversation */
    $conversation = $this->get_conversation($conversation_id, $as_page);
    /* update all recipients with last message id & only offline recipient messages counter */
    foreach ((array) $conversation['recipients'] as $recipient) {
      if (!$recipient['deleted']) {
        $db->query(sprintf("UPDATE users SET user_live_messages_lastid = %s, user_live_messages_counter = user_live_messages_counter + 1 WHERE user_id = %s", secure($message_id, 'int'), secure($recipient['user_id'], 'int')));
      }
      /* prepare notification message if image, video or voice note */
      if (!$message) {
        if ((int) !empty($photos) + (int) !empty($videos) + (int) !empty($files) > 1) {
          $message = __("Sent") . " " . (count($photos) + count($videos) + count($files)) . " " . __("media files");
        } elseif (count($photos) > 1) {
          $message = __("Sent") . " " . count($photos) . " " . __("photos");
        } elseif ($photos) {
          $message = __("Sent a photo");
        } elseif (count($videos) > 1) {
          $message = __("Sent") . " " . count($videos) . " " . __("videos");
        } elseif ($videos) {
          $message = __("Sent a video");
        } elseif (count($files) > 1) {
          $message = __("Sent") . " " . count($files) . " " . __("files");
        } elseif ($files) {
          $message = __("Sent a file");
        } elseif ($gif) {
          $message = __("Sent a GIF");
        }
        if ($voice_note) {
          $message = __("Sent a voice message");
        }
        if ($product_post_id) {
          $message = __("Shared a product");
        }
      }
      /* send notification */
      $this->post_notification(['to_user_id' => $recipient['user_id'], 'from_user_id' => ($as_page) ? $page_id : $this->_data['user_id'], 'from_user_type' => ($as_page) ? 'page' : 'user', 'action' => 'chat_message', 'node_url' => $conversation_id, 'message' => $message]);
    }
    /* notify the page admins */
    if ($notify_page_admins) {
      foreach ($this->get_page_admins_ids($page_id) as $page_admin_id) {
        $this->post_notification(['to_user_id' => $page_admin_id, 'action' => 'page_message', 'node_type' => $page['page_title'], 'node_url' => $page['page_name'] . '/settings/messages?cid=' . $conversation_id]);
      }
    }
    /* update typing status of the viewer for this conversation */
    if ($as_page) {
      $db->query(sprintf("UPDATE pages_conversations SET typing = '0' WHERE conversation_id = %s", secure($conversation_id, 'int')));
    } else {
      $db->query(sprintf("UPDATE conversations_users SET typing = '0' WHERE conversation_id = %s AND user_id = %s", secure($conversation_id, 'int'), secure($this->_data['user_id'], 'int')));
    }
    /* remove pending uploads */
    remove_pending_uploads(array_merge($photos, $videos, array_column($files, 'source'), [$voice_note]));
    /* return with conversation */
    return $conversation;
  }


  /**
   * filter_message_media_sources
   * 
   * @param mixed $media
   * @param boolean $from_web
   * @return array
   */
  private function filter_message_media_sources($media, $from_web = false)
  {
    if ($media && is_string($media)) {
      $media = json_decode($media, true);
    }
    if (!is_array($media)) {
      return [];
    }
    $sources = [];
    foreach ($media as $item) {
      $source = is_array($item) || is_object($item) ? (((array) $item)['source'] ?? null) : $item;
      if (!is_valid_upload_source($source)) {
        _error(400);
      }
      $sources[] = $source;
    }
    return $sources;
  }


  /**
   * filter_message_files
   * 
   * @param mixed $media
   * @param boolean $from_web
   * @return array
   */
  private function filter_message_files($media, $from_web = false)
  {
    if ($media && is_string($media)) {
      $media = json_decode($media, true);
    }
    if (!is_array($media)) {
      return [];
    }
    $files = [];
    foreach ($media as $item) {
      $files[] = $this->filter_upload_file_meta($item);
    }
    return $files;
  }


  /**
   * filter_upload_file_meta
   * 
   * @param mixed $item
   * @return array
   */
  protected function filter_upload_file_meta($item)
  {
    $item = is_array($item) || is_object($item) ? (array) $item : ['source' => $item];
    $source = $item['source'] ?? null;
    if (!is_valid_upload_source($source)) {
      _error(400);
    }
    return [
      'source' => $source,
      'name' => $this->sanitize_upload_file_name($item['name'] ?? ''),
      'size' => max(0, (int) ($item['size'] ?? 0)),
    ];
  }


  /**
   * sanitize_upload_file_name
   * 
   * @param mixed $name
   * @return string
   */
  protected function sanitize_upload_file_name($name)
  {
    $name = basename(str_replace(["\0", '/', '\\'], '', (string) $name));
    return function_exists('mb_substr') ? mb_substr($name, 0, 256) : substr($name, 0, 256);
  }


  /**
   * decorate_file_attachment
   * 
   * @param array $file
   * @return array
   */
  protected function decorate_file_attachment($file)
  {
    $file['name'] = trim((string) ($file['name'] ?? ''));
    $file['size'] = (int) ($file['size'] ?? 0);
    $file['type'] = '';
    $file['size_formatted'] = '';
    if ($file['name'] !== '') {
      $extension = pathinfo($file['name'], PATHINFO_EXTENSION);
      if ($extension !== '') {
        $file['type'] = strtoupper($extension);
      }
    }
    if ($file['size'] > 0) {
      $units = ['B', 'KB', 'MB', 'GB'];
      $unit = min(3, (int) floor(log(max(1, $file['size']), 1024)));
      $value = $file['size'] / pow(1024, $unit);
      $file['size_formatted'] = ($unit ? number_format($value, 1, '.', '') : (string) (int) $value) . ' ' . $units[$unit];
    }
    return $file;
  }


  /**
   * post_conversation_paid_message
   * 
   * @param array $args
   * @param boolean $from_web
   * @return array
   */
  public function post_conversation_paid_message($args = [], $from_web = false)
  {
    global $db, $system;
    /* init system datetime */
    $date = init_system_datetime();
    /* check monetization permission */
    if (!$this->_data['can_monetize_content'] || !$this->_data['user_monetization_enabled']) {
      throw new AuthorizationException(__("You don't have the permission to do this"));
    }
    /* prepare */
    $message = $args['message'] ?? '';
    $photos = $args['photos'] ?? [];
    $video = $args['video'] ?? null;
    $audio = $args['audio'] ?? null;
    $file = $args['file'] ?? null;
    $conversation_id = $args['conversation_id'] ?? null;
    $message_price = $args['message_price'] ?? 0;
    $paid_text = $args['paid_text'] ?? '';
    $paid_image = $args['paid_image'] ?? '';
    $reply_to = $args['reply_to'] ?? null;
    if ($reply_to && !is_numeric($reply_to)) {
      throw new BadRequestException(__("Invalid request"));
    }
    $reply_to = ($reply_to) ? (int) $reply_to : null;
    $for_adult = (isset($args['for_adult']) && ($args['for_adult'] === '1' || $args['for_adult'] === true || $args['for_adult'] === 'true')) ? '1' : '0';
    /* filter photos */
    if ($photos && $from_web) {
      $photos = json_decode($photos, true);
    }
    if (!is_array($photos)) {
      $photos = [];
    }
    foreach ($photos as &$photo) {
      $photo = (array) $photo;
      if (!is_valid_upload_source($photo['source'] ?? null)) {
        _error(400);
      }
    }
    unset($photo);
    /* filter video */
    if ($video && $from_web) {
      $video = json_decode($video);
    }
    if ($video) {
      if (!is_object($video) || !is_valid_upload_source($video->source ?? null)) {
        _error(400);
      }
    }
    /* filter audio */
    if ($audio && $from_web) {
      $audio = json_decode($audio);
    }
    if ($audio) {
      if (!is_object($audio) || !is_valid_upload_source($audio->source ?? null)) {
        _error(400);
      }
    }
    /* filter file */
    if ($file && $from_web) {
      $file = json_decode($file);
    }
    if ($file) {
      if (!is_object($file) || !is_valid_upload_source($file->source ?? null)) {
        _error(400);
      }
      $meta = $this->filter_upload_file_meta($file);
      $file->name = $meta['name'];
      $file->size = $meta['size'];
    }
    /* filter paid image */
    if ($paid_image && !is_valid_upload_source($paid_image)) {
      _error(400);
    }
    /* at least one media attachment required */
    $has_photos = (count($photos) > 0);
    $has_video = ($video && is_object($video));
    $has_audio = ($audio && is_object($audio));
    $has_file = ($file && is_object($file));
    $media_count = ($has_photos ? 1 : 0) + ($has_video ? 1 : 0) + ($has_audio ? 1 : 0) + ($has_file ? 1 : 0);
    if ($media_count == 0) {
      throw new ValidationException(__("Please attach at least one media file"));
    }
    /* validate price */
    if (!is_numeric($message_price) || $message_price <= 0) {
      throw new ValidationException(__("Please enter a valid price"));
    }
    if ($system['monetization_max_paid_post_price'] > 0 && $message_price > $system['monetization_max_paid_post_price']) {
      throw new ValidationException(__("The price must be less than or equal to") . " " . print_money($system['monetization_max_paid_post_price']));
    }
    /* validate paid text */
    if (strlen($paid_text) > 1000) {
      throw new ValidationException(__("Paid content description is more than 1000 characters"));
    }
    /* validate conversation */
    if (!$conversation_id || !is_numeric($conversation_id)) {
      throw new BadRequestException(__("Conversation ID must be numeric"));
    }
    $conversation = $this->get_conversation($conversation_id);
    if (!$conversation) {
      throw new AuthorizationException(__("You are not authorized to do this"));
    }
    /* disable in group/event chatboxes for v1 */
    if ($conversation['node_id']) {
      throw new AuthorizationException(__("Paid media messages are not supported in group or event chats yet"));
    }
    if ($reply_to) {
      $check_reply = $db->query(sprintf("SELECT COUNT(*) as count FROM conversations_messages WHERE message_id = %s AND conversation_id = %s", secure($reply_to, 'int'), secure($conversation_id, 'int')));
      if ($check_reply->fetch_assoc()['count'] == 0) {
        throw new BadRequestException(__("Invalid request"));
      }
    }
    /* check recipients chat privacy */
    $this->check_recipients_chat_privacy($conversation['recipients']);
    /* check paid conversation */
    if ($conversation['chat_price'] > 0) {
      $this->wallet_chat_payment($conversation['chat_price'], $conversation['paid_recipients']);
    }
    foreach ($conversation['recipients'] as $recipient) {
      if ($this->blocked($recipient['user_id'])) {
        $recipient_name = ($system['show_usernames_enabled']) ? $recipient['user_name'] : $recipient['user_firstname'] . " " . $recipient['user_lastname'];
        modal("MESSAGE", __("Message"), __("You aren't allowed to message") . " " . $recipient_name);
      }
    }
    /* update sender (viewer) as seen and not deleted */
    $db->query(sprintf("UPDATE conversations_users SET seen = '1', deleted = '0' WHERE conversation_id = %s AND user_id = %s", secure($conversation_id, 'int'), secure($this->_data['user_id'], 'int')));
    /* update recipients as not seen and not deleted */
    $db->query(sprintf("UPDATE conversations_users SET seen = '0', deleted = '0' WHERE conversation_id = %s AND user_id != %s", secure($conversation_id, 'int'), secure($this->_data['user_id'], 'int')));
    /* insert message */
    $db->query(sprintf(
      "INSERT INTO conversations_messages (
        conversation_id,
        user_id,
        message,
        image,
        video,
        voice_note,
        is_paid,
        message_price,
        paid_text,
        paid_image,
        for_adult,
        reply_to,
        time
      ) VALUES (%s, %s, %s, '', '', '', '1', %s, %s, %s, %s, %s, %s)",
      secure($conversation_id, 'int'),
      secure($this->_data['user_id'], 'int'),
      secure($message),
      secure($message_price, 'float'),
      secure($paid_text),
      secure($paid_image),
      secure($for_adult),
      ($reply_to) ? secure($reply_to, 'int') : 'null',
      secure($date)
    ));
    $message_id = $db->insert_id;
    $pending_uploads = [];
    if ($paid_image) {
      $pending_uploads[] = $paid_image;
    }
    /* insert media rows */
    if ($has_photos) {
      foreach ($photos as $photo) {
        if (!is_array($photo)) {
          $photo = (array) $photo;
        }
        if (!is_valid_upload_source($photo['source'] ?? null)) {
          _error(400);
        }
        $db->query(sprintf(
          "INSERT INTO conversations_messages_media (message_id, media_type, source) VALUES (%s, 'photo', %s)",
          secure($message_id, 'int'),
          secure($photo['source'])
        ));
        $pending_uploads[] = $photo['source'];
      }
    }
    if ($has_video) {
      $db->query(sprintf(
        "INSERT INTO conversations_messages_media (message_id, media_type, source) VALUES (%s, 'video', %s)",
        secure($message_id, 'int'),
        secure($video->source)
      ));
      $pending_uploads[] = $video->source;
    }
    if ($has_audio) {
      $db->query(sprintf(
        "INSERT INTO conversations_messages_media (message_id, media_type, source) VALUES (%s, 'audio', %s)",
        secure($message_id, 'int'),
        secure($audio->source)
      ));
      $pending_uploads[] = $audio->source;
    }
    if ($has_file) {
      $db->query(sprintf(
        "INSERT INTO conversations_messages_media (message_id, media_type, source, name, size) VALUES (%s, 'file', %s, %s, %s)",
        secure($message_id, 'int'),
        secure($file->source),
        secure($file->name ?? ''),
        secure((int) ($file->size ?? 0), 'int')
      ));
      $pending_uploads[] = $file->source;
    }
    /* update the conversation with last message id */
    $db->query(sprintf("UPDATE conversations SET last_message_id = %s WHERE conversation_id = %s", secure($message_id, 'int'), secure($conversation_id, 'int')));
    /* update sender (viewer) with last message id */
    $db->query(sprintf("UPDATE users SET user_live_messages_lastid = %s WHERE user_id = %s", secure($message_id, 'int'), secure($this->_data['user_id'], 'int')));
    /* get conversation */
    $conversation = $this->get_conversation($conversation_id);
    /* update all recipients with last message id & only offline recipient messages counter */
    $notify_message = $message;
    if (!$notify_message) {
      $notify_message = __("Sent paid content");
    }
    foreach ($conversation['recipients'] as $recipient) {
      if (!$recipient['deleted']) {
        $db->query(sprintf("UPDATE users SET user_live_messages_lastid = %s, user_live_messages_counter = user_live_messages_counter + 1 WHERE user_id = %s", secure($message_id, 'int'), secure($recipient['user_id'], 'int')));
      }
      /* send notification */
      $this->post_notification(['to_user_id' => $recipient['user_id'], 'from_user_id' => $this->_data['user_id'], 'action' => 'chat_message', 'node_url' => $conversation_id, 'message' => $notify_message]);
    }
    /* update typing status of the viewer for this conversation */
    $db->query(sprintf("UPDATE conversations_users SET typing = '0' WHERE conversation_id = %s AND user_id = %s", secure($conversation_id, 'int'), secure($this->_data['user_id'], 'int')));
    /* remove pending uploads */
    remove_pending_uploads($pending_uploads);
    /* return with conversation */
    return $conversation;
  }


  /**
   * get_conversation_messages
   * 
   * @param integer $conversation_id
   * @param integer $offset
   * @param integer $last_message_id
   * @param boolean $as_page
   * @return array
   */
  public function get_conversation_messages($conversation_id, $offset = 0, $last_message_id = null, $as_page = false, $cursor = null)
  {
    global $db, $system;
    $this->_cursor = null;
    /* check if user authorized to see this conversation */
    if ($as_page) {
      if (!$this->check_page_conversation_access($conversation_id)) {
        throw new Exception(__("You are not authorized to view this"));
      }
    } else {
      $check_conversation = $db->query(sprintf("SELECT COUNT(*) as count FROM conversations_users WHERE conversation_id = %s AND user_id = %s", secure($conversation_id, 'int'), secure($this->_data['user_id'], 'int')));
      if ($check_conversation->fetch_assoc()['count'] == 0) {
        throw new Exception(__("You are not authorized to view this"));
      }
    }
    $offset *= $system['max_results'];
    $messages = [];
    /* pages after the first continue from a cursor (the oldest message id shown) instead of an offset */
    $cursor = ($last_message_id !== null) ? null : cursor_decode($cursor, ['int']);
    $cursor_statement = ($cursor) ? " AND " . cursor_where(['conversations_messages.message_id'], $cursor) : "";
    $limit_statement = ($cursor) ? sprintf("LIMIT %s", secure($system['max_results'], 'int', false)) : sprintf("LIMIT %s, %s", secure($offset, 'int', false), secure($system['max_results'], 'int', false));
    if ($last_message_id !== null) {
      /* get all messages after the last_message_id */
      $get_messages = $db->query(sprintf(
        "SELECT 
          conversations_messages.*,
          users.user_name,
          users.user_firstname,
          users.user_lastname,
          users.user_gender,
          users.user_picture,
          users.user_subscribed,
          users.user_verified
        FROM conversations_messages
        INNER JOIN users ON conversations_messages.user_id = users.user_id
        WHERE conversations_messages.conversation_id = %s
        AND conversations_messages.message_id > %s",
        secure($conversation_id, 'int'),
        secure($last_message_id, 'int')
      ));
    } else {
      $get_messages = $db->query(sprintf(
        "SELECT * FROM (
          SELECT 
            conversations_messages.*,
            users.user_name,
            users.user_firstname,
            users.user_lastname,
            users.user_gender,
            users.user_picture,
            users.user_subscribed,
            users.user_verified
          FROM conversations_messages
          INNER JOIN users ON conversations_messages.user_id = users.user_id
          WHERE conversations_messages.conversation_id = %s" . $cursor_statement . "
          ORDER BY conversations_messages.message_id DESC
          " . $limit_statement . "
        ) messages 
        ORDER BY messages.message_id ASC",
        secure($conversation_id, 'int')
      ));
    }
    $rows = $get_messages->fetch_all(MYSQLI_ASSOC);
    /* load the media and the viewer's reactions of all messages at once */
    $previous_prefetch = $this->_conversations_prefetch;
    if (!(defined('POSTS_PREFETCH_DISABLED') && POSTS_PREFETCH_DISABLED)) {
      $this->_conversations_prefetch = $this->prefetch_messages_details(array_column($rows, 'message_id'));
    }
    try {
      foreach ($rows as $message) {
        $message = $this->parse_message($message, null, $as_page);
        $messages[] = $message;
      }
    } finally {
      $this->_conversations_prefetch = $previous_prefetch;
    }
    $has_more = (count($messages) == $system['max_results']) ? true : false;
    /* the position after the oldest message read */
    $next_cursor = ($rows && $last_message_id === null) ? cursor_encode([$rows[0]['message_id']]) : null;
    $this->_cursor = $next_cursor;
    return ['messages' => $messages, 'has_more' => $has_more, 'cursor' => $next_cursor];
  }


  /**
   * delete_conversation_message
   * 
   * @param integer $message_id
   * @return void
   */
  public function delete_conversation_message($message_id)
  {
    global $db;
    /* check if message exists and viewer is the sender (or manages the page who sent it) */
    $check_message = $db->query(sprintf("SELECT * FROM conversations_messages WHERE message_id = %s", secure($message_id, 'int')));
    if ($check_message->num_rows == 0) {
      throw new AuthorizationException(__("You are not authorized to do this"));
    }
    $message = $check_message->fetch_assoc();
    if ($message['page_id']) {
      if (!$this->check_page_adminship($this->_data['user_id'], $message['page_id'])) {
        throw new AuthorizationException(__("You are not authorized to do this"));
      }
    } elseif ($message['user_id'] != $this->_data['user_id']) {
      throw new AuthorizationException(__("You are not authorized to do this"));
    }
    /* delete message media */
    $this->delete_messages_media(sprintf("message_id = %s", secure($message_id, 'int')));
    /* delete message reactions */
    $db->query(sprintf("DELETE FROM conversations_messages_reactions WHERE message_id = %s", secure($message_id, 'int')));
    /* delete message */
    $db->query(sprintf("DELETE FROM conversations_messages WHERE message_id = %s", secure($message_id, 'int')));
    /* clear pin if this message was pinned */
    $db->query(sprintf("UPDATE conversations SET pinned_message_id = NULL WHERE pinned_message_id = %s", secure($message_id, 'int')));
    /* delete message translations */
    $this->delete_translations('message', $message_id);
    /* update the conversation with last message id */
    $db->query(sprintf(
      "UPDATE conversations c 
       SET c.last_message_id = COALESCE(
         (SELECT m.message_id 
          FROM conversations_messages m 
          WHERE m.conversation_id = c.conversation_id 
          ORDER BY m.message_id DESC 
          LIMIT 1), 
         0) 
       WHERE c.conversation_id = %s 
       AND c.last_message_id = %s",
      secure($message['conversation_id'], 'int'),
      secure($message_id, 'int')
    ));
    /* check if last_message_id became 0 -> delete conversation */
    $check_last_message = $db->query(sprintf("SELECT last_message_id FROM conversations WHERE conversation_id = %s", secure($message['conversation_id'], 'int')));
    $last_message_id = $check_last_message->fetch_assoc()['last_message_id'] ?? 0;
    if ($last_message_id == 0) {
      if ($this->get_conversation_page_id($message['conversation_id'])) {
        $this->delete_page_conversation($message['conversation_id']);
      } else {
        $this->delete_conversation($message['conversation_id']);
      }
    }
  }


  /**
   * get_conversation_message_by_id
   * 
   * @param integer $message_id
   * @param integer $viewer_id
   * @param boolean $as_page
   * @return array
   */
  public function get_conversation_message_by_id($message_id, $viewer_id = null, $as_page = false)
  {
    global $db;
    if (!$message_id) {
      return false;
    }
    $get_message = $this->conversation_details('messages', $message_id) ?? $db->query(sprintf(
      "SELECT 
        conversations_messages.*,
        users.user_id,
        users.user_name,
        users.user_firstname,
        users.user_lastname,
        users.user_gender,
        users.user_picture,
        users.user_subscribed,
        users.user_verified 
      FROM conversations_messages 
      INNER JOIN users 
        ON conversations_messages.user_id = users.user_id 
      WHERE conversations_messages.message_id = %s",
      secure($message_id, 'int')
    ));
    if ($get_message->num_rows == 0) {
      return false;
    }
    $message = $get_message->fetch_assoc();
    $message = $this->parse_message($message, $viewer_id, $as_page);
    return $message;
  }


  /**
   * get_conversation_paid_message_by_id
   * 
   * @param integer $message_id
   * @return array|false
   */
  public function get_conversation_paid_message_by_id($message_id)
  {
    global $db;
    $get_message = $db->query(sprintf(
      "SELECT 
        conversations_messages.*,
        users.user_id,
        users.user_name,
        users.user_firstname,
        users.user_lastname,
        users.user_gender,
        users.user_picture,
        users.user_subscribed,
        users.user_verified
      FROM conversations_messages
      INNER JOIN users ON conversations_messages.user_id = users.user_id
      WHERE conversations_messages.message_id = %s",
      secure($message_id, 'int')
    ));
    if ($get_message->num_rows == 0) {
      return false;
    }
    $message = $get_message->fetch_assoc();
    if ($message['is_paid'] != '1') {
      return false;
    }
    /* the viewer must be a participant of the conversation (webhooks run without a session) */
    if ($this->_logged_in) {
      $check_membership = $db->query(sprintf("SELECT COUNT(*) as count FROM conversations_users WHERE conversation_id = %s AND user_id = %s", secure($message['conversation_id'], 'int'), secure($this->_data['user_id'], 'int')));
      if ($check_membership->fetch_assoc()['count'] == 0) {
        return false;
      }
    }
    $message = $this->parse_message($message);
    if (!$message['needs_payment']) {
      return false;
    }
    return $message;
  }


  /**
   * get_conversation_profile
   * 
   * @param array $conversation
   * @return array|null
   */
  public function get_conversation_profile($conversation)
  {
    global $db, $system;
    if (!$conversation || $conversation['node_id']) {
      return null;
    }
    /* get shared photos */
    $photos = [];
    $shared_photos = sprintf(
      "SELECT message_id, image FROM conversations_messages WHERE conversation_id = %1\$s AND image != ''
       UNION ALL
       SELECT conversations_messages.message_id, conversations_messages_media.source AS image FROM conversations_messages_media INNER JOIN conversations_messages ON conversations_messages_media.message_id = conversations_messages.message_id WHERE conversations_messages.conversation_id = %1\$s AND conversations_messages.is_paid != '1' AND conversations_messages_media.media_type = 'photo'",
      secure($conversation['conversation_id'], 'int')
    );
    $get_photos = $db->query("SELECT message_id, image FROM (" . $shared_photos . ") shared_photos ORDER BY message_id DESC LIMIT 9");
    while ($photo = $get_photos->fetch_assoc()) {
      $photos[] = $photo;
    }
    $get_photos_count = $db->query("SELECT COUNT(*) as count FROM (" . $shared_photos . ") shared_photos");
    $photos_count = $get_photos_count->fetch_assoc()['count'];
    /* group conversation */
    if (!empty($conversation['multiple_recipients'])) {
      return [
        'is_group' => true,
        'photos' => $photos,
        'photos_count' => $photos_count,
        'members_count' => count((array)($conversation['recipients'] ?? [])) + 1,
      ];
    }
    /* one-to-one conversation */
    if (!$conversation['user_id']) {
      return null;
    }
    $get_profile = $db->query(sprintf("SELECT user_id, user_name, user_firstname, user_lastname, user_gender, user_picture, user_verified, user_subscribed, packages.name as package_name, user_biography, user_registered FROM users LEFT JOIN packages ON users.user_subscribed = '1' AND users.user_package = packages.package_id WHERE user_id = %s", secure($conversation['user_id'], 'int')));
    if ($get_profile->num_rows == 0) {
      return null;
    }
    $profile = $get_profile->fetch_assoc();
    $profile['is_group'] = false;
    $profile['user_picture'] = get_picture($profile['user_picture'], $profile['user_gender']);
    $profile['user_fullname'] = ($system['show_usernames_enabled']) ? $profile['user_name'] : $profile['user_firstname'] . " " . $profile['user_lastname'];
    $profile['connection'] = $this->connection($profile['user_id']);
    $profile['photos'] = $photos;
    $profile['photos_count'] = $photos_count;
    return $profile;
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
    $get_total_messages = $this->conversation_details('total_messages', $conversation_id) ?? $db->query(sprintf("SELECT COUNT(*) as count FROM conversations_messages WHERE conversation_id = %s", secure($conversation_id, 'int')));
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
    $check_conversation = $db->query(sprintf(
      "SELECT COUNT(*) as count
       FROM conversations_users
       INNER JOIN conversations
         ON conversations_users.conversation_id = conversations.conversation_id
       WHERE (conversations.node_id IS NULL OR conversations.node_type = 'page')
         AND conversations.conversation_id = %s
         AND conversations_users.user_id = %s",
      secure($conversation_id, 'int'),
      secure($this->_data['user_id'], 'int')
    ));
    if ($check_conversation->fetch_assoc()['count'] == 0) {
      throw new AuthorizationException(__("You are not authorized to do this"));
    }
    /* page conversations stay in the page inbox */
    if ($system['chat_permanently_delete_enabled'] && !$this->get_conversation_page_id($conversation_id)) {
      /* delete conversation */
      $db->query(sprintf("DELETE FROM conversations WHERE conversation_id = %s", secure($conversation_id, 'int')));
      /* delete conversation users */
      $db->query(sprintf("DELETE FROM conversations_users WHERE conversation_id = %s", secure($conversation_id, 'int')));
      /* delete conversation messages translations */
      $db->query(sprintf("DELETE FROM translations_cache WHERE node_type = 'message' AND node_id IN (SELECT message_id FROM conversations_messages WHERE conversation_id = %s)", secure($conversation_id, 'int')));
      /* delete conversation messages media */
      $this->delete_messages_media(sprintf("conversation_id = %s", secure($conversation_id, 'int')));
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
   * get_group_conversation
   * 
   * @param integer $conversation_id
   * @return array
   */
  private function get_group_conversation($conversation_id)
  {
    global $db;
    $check_viewer = $db->query(sprintf("SELECT COUNT(*) as count FROM conversations_users WHERE conversation_id = %s AND user_id = %s AND deleted = '0'", secure($conversation_id, 'int'), secure($this->_data['user_id'], 'int')));
    if ($check_viewer->fetch_assoc()['count'] == 0) {
      throw new AuthorizationException(__("You are not authorized to do this"));
    }
    $conversation = $this->get_conversation($conversation_id);
    if (!$conversation || $conversation['node_id'] || !$conversation['multiple_recipients']) {
      throw new AuthorizationException(__("You are not authorized to do this"));
    }
    return $conversation;
  }


  /**
   * rename_conversation
   * 
   * @param integer $conversation_id
   * @param string $name
   * @return array
   */
  public function rename_conversation($conversation_id, $name)
  {
    global $db;
    $this->get_group_conversation($conversation_id);
    $name = trim((string)$name);
    if (mb_strlen(htmlentities($name, ENT_QUOTES, 'utf-8')) > 128) {
      throw new ValidationException(__("The name must be less than 128 characters"));
    }
    $db->query(sprintf("UPDATE conversations SET name = %s WHERE conversation_id = %s", secure($name), secure($conversation_id, 'int')));
    return $this->get_conversation($conversation_id);
  }


  /**
   * add_conversation_user
   * 
   * @param integer $conversation_id
   * @param integer $user_id
   * @return array
   */
  public function add_conversation_user($conversation_id, $user_id)
  {
    global $db;
    if (!is_numeric($user_id) || $user_id == $this->_data['user_id']) {
      throw new BadRequestException(__("Invalid request"));
    }
    $conversation = $this->get_group_conversation($conversation_id);
    if (count($conversation['recipients']) >= 10) {
      throw new ValidationException(__("You can only add up to 10 people"));
    }
    foreach ($conversation['recipients'] as $recipient) {
      if ($recipient['user_id'] == $user_id) {
        throw new ValidationException(__("This user is already in the conversation"));
      }
    }
    if ($this->blocked($user_id)) {
      throw new AuthorizationException(__("You are not authorized to do this"));
    }
    $recipient = $this->get_user($user_id);
    if (!$recipient) {
      throw new BadRequestException(__("Invalid request"));
    }
    $this->check_recipients_chat_privacy([$recipient]);
    $db->query(sprintf("INSERT INTO conversations_users (conversation_id, user_id) VALUES (%s, %s)", secure($conversation_id, 'int'), secure($user_id, 'int')));
    return $this->get_conversation($conversation_id);
  }


  /**
   * remove_conversation_user
   * 
   * @param integer $conversation_id
   * @param integer $user_id
   * @return array|false
   */
  public function remove_conversation_user($conversation_id, $user_id)
  {
    global $db;
    if (!is_numeric($user_id)) {
      throw new BadRequestException(__("Invalid request"));
    }
    $conversation = $this->get_group_conversation($conversation_id);
    $is_member = ($user_id == $this->_data['user_id']);
    if (!$is_member) {
      foreach ($conversation['recipients'] as $recipient) {
        if ($recipient['user_id'] == $user_id) {
          $is_member = true;
          break;
        }
      }
    }
    if (!$is_member) {
      throw new AuthorizationException(__("You are not authorized to do this"));
    }
    $db->query(sprintf("DELETE FROM conversations_users WHERE conversation_id = %s AND user_id = %s", secure($conversation_id, 'int'), secure($user_id, 'int')));
    if ($user_id == $this->_data['user_id']) {
      return false;
    }
    return $this->get_conversation($conversation_id);
  }


  /**
   * update_conversation_typing_status
   * 
   * @param integer $conversation_id
   * @param boolean $is_typing
   * @param boolean $as_page
   * @return void
   */
  public function update_conversation_typing_status($conversation_id, $is_typing, $as_page = false)
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
    /* page inbox */
    if ($as_page) {
      if (!$this->check_page_conversation_access($conversation_id)) {
        return;
      }
      $is_typing = ($is_typing && $is_typing !== 'false') ? '1' : '0';
      $db->query(sprintf("UPDATE pages_conversations SET typing = %s WHERE conversation_id = %s", secure($is_typing), secure($conversation_id, 'int')));
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
   * @param boolean $as_page
   * @return void
   */
  public function update_conversation_seen_status($conversation_ids, $as_page = false)
  {
    global $db, $system;
    /* page inbox (the page read state is also the inbox unread state) */
    if ($as_page) {
      foreach ((array)$conversation_ids as $conversation_id) {
        if ($this->check_page_conversation_access($conversation_id)) {
          $db->query(sprintf("UPDATE pages_conversations SET seen = '1' WHERE conversation_id = %s", secure($conversation_id, 'int')));
        }
      }
      return;
    }
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
    /* delete conversation messages media */
    $this->delete_messages_media(sprintf("conversation_id = %s", secure($conversation_id, 'int')));
    /* delete conversation messages */
    $db->query(sprintf("DELETE FROM conversations_messages WHERE conversation_id = %s", secure($conversation_id, 'int')));
  }


  /**
   * delete_messages_media
   * 
   * @param string $where
   * @return void
   */
  private function delete_messages_media($where)
  {
    global $db;
    $files = [];
    $message_ids = [];
    $get_messages = $db->query("SELECT message_id, image, video, voice_note, paid_image FROM conversations_messages WHERE " . $where);
    while ($message = $get_messages->fetch_assoc()) {
      $message_ids[] = (int) $message['message_id'];
      array_push($files, $message['image'], $message['video'], $message['voice_note'], $message['paid_image']);
    }
    if (!$message_ids) {
      return;
    }
    $message_ids = implode(',', $message_ids);
    $get_media = $db->query("SELECT source FROM conversations_messages_media WHERE message_id IN (" . $message_ids . ")");
    while ($media = $get_media->fetch_assoc()) {
      $files[] = $media['source'];
    }
    $files = array_values(array_filter(array_unique($files)));
    remove_pending_uploads($files);
    foreach ($files as $file) {
      delete_uploads_file($file);
    }
    $db->query("DELETE FROM conversations_messages_media WHERE message_id IN (" . $message_ids . ")");
    $db->query("DELETE FROM conversations_messages_paid WHERE message_id IN (" . $message_ids . ")");
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
    /* dating matches can always chat */
    if (count($recipients) == 1 && $this->dating_matched(reset($recipients)['user_id'])) {
      return;
    }
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


  /**
   * parse_message
   * 
   * @param array $message
   * @param integer $viewer_id
   * @param boolean $as_page
   * @return array
   */
  public function parse_message($message, $viewer_id = null, $as_page = false)
  {
    global $system, $db;
    /* resolve the viewer context */
    $viewer = $this->_data;
    $viewer_logged_in = $this->_logged_in;
    if ($viewer_id !== null && $viewer_id != ($this->_data['user_id'] ?? null)) {
      $fetched_viewer = $this->get_user($viewer_id);
      if ($fetched_viewer) {
        $fetched_viewer['user_adult'] = (get_user_age($fetched_viewer['user_birthdate']) >= 18);
        $viewer = $fetched_viewer;
        $viewer_logged_in = true;
      }
    }
    /* prepare user data */
    $message['user_picture'] = get_picture($message['user_picture'], $message['user_gender']);
    $message['user_fullname'] = ($system['show_usernames_enabled']) ? $message['user_name'] : $message['user_firstname'] . " " . $message['user_lastname'];
    /* prepare page data (sent as the page) */
    if (!empty($message['page_id'])) {
      $page = $this->get_chat_page($message['page_id']);
      if ($as_page) {
        /* page admins see who replied */
        $message['sender_fullname'] = $message['user_fullname'];
      } else {
        /* customers never see the page admin */
        $message['user_id'] = 0;
        $message['user_name'] = '';
        $message['user_firstname'] = ($page) ? $page['page_title'] : '';
        $message['user_lastname'] = '';
        $message['user_gender'] = '';
        $message['user_subscribed'] = '0';
      }
      $message['page_name'] = ($page) ? $page['page_name'] : '';
      $message['user_picture'] = ($page) ? $page['page_picture'] : get_picture('', 'page');
      $message['user_fullname'] = ($page) ? $page['page_title'] : __("Page");
      $message['user_verified'] = ($page) ? $page['page_verified'] : '0';
    }
    /* get reactions array */
    $message['reactions']['like'] = $message['reaction_like_count'];
    $message['reactions']['love'] = $message['reaction_love_count'];
    $message['reactions']['haha'] = $message['reaction_haha_count'];
    $message['reactions']['yay'] = $message['reaction_yay_count'];
    $message['reactions']['wow'] = $message['reaction_wow_count'];
    $message['reactions']['sad'] = $message['reaction_sad_count'];
    $message['reactions']['angry'] = $message['reaction_angry_count'];
    arsort($message['reactions']);
    /* get total reactions */
    $message['reactions_total_count'] = $message['reaction_like_count'] + $message['reaction_love_count'] + $message['reaction_haha_count'] + $message['reaction_yay_count'] + $message['reaction_wow_count'] + $message['reaction_sad_count'] + $message['reaction_angry_count'];
    /* format total reactions count */
    $message['reactions_total_count_formatted'] = abbreviate_count($message['reactions_total_count']);
    /* check if viewer [reacted] this message */
    $message['i_react'] = false;
    /* reaction */
    if ($message['reactions_total_count'] > 0) {
      $get_reaction = (($viewer['user_id'] == $this->_data['user_id']) ? $this->conversation_details('message_reactions', $message['message_id']) : null) ?? $db->query(sprintf("SELECT reaction FROM conversations_messages_reactions WHERE user_id = %s AND message_id = %s", secure($viewer['user_id'], 'int'), secure($message['message_id'], 'int')));
      if ($get_reaction->num_rows > 0) {
        $message['i_react'] = true;
        $message['i_reaction'] = $get_reaction->fetch_assoc()['reaction'];
      }
    }
    /* decode message text */
    $message['message_orginal'] = $message['message'];
    $message['message_orginal'] = censored_words($message['message_orginal']);
    $message['message_orginal_decoded'] = html_entity_decode($message['message_orginal'], ENT_QUOTES);
    $message['message'] = $this->parse(["text" => $message['message'], "decode_hashtags" => false]);
    $message['message_decoded'] = html_entity_decode($message['message'], ENT_QUOTES);
    /* get product post */
    if ($message['product_post_id']) {
      $post = $this->get_post($message['product_post_id']);
      if ($post) {
        $message['post'] = $post;
      }
    }
    /* get story */
    if (!empty($message['story_id'])) {
      $message['story'] = $this->get_story_preview($message['story_id']);
    }
    /* get call */
    if (!empty($message['call_id'])) {
      $message['call'] = $this->get_message_call($message['call_id']);
    }
    /* get media */
    $message['media'] = ['items' => [], 'photos' => [], 'video' => null, 'audio' => null, 'file' => null, 'files' => []];
    $get_media = $this->conversation_details('message_media', $message['message_id']) ?? $db->query(sprintf("SELECT * FROM conversations_messages_media WHERE message_id = %s ORDER BY media_id ASC", secure($message['message_id'], 'int')));
    if ($get_media->num_rows > 0) {
      while ($media = $get_media->fetch_assoc()) {
        if ($media['media_type'] == 'photo') {
          $message['media']['photos'][] = $media;
        } elseif ($media['media_type'] == 'video') {
          $message['media']['video'] = $message['media']['video'] ?? $media;
        } elseif ($media['media_type'] == 'audio') {
          $message['media']['audio'] = $media;
        } elseif ($media['media_type'] == 'file') {
          $media = $this->decorate_file_attachment($media);
          $message['media']['file'] = $message['media']['file'] ?? $media;
          $message['media']['files'][] = $media;
        }
        if ($message['is_paid'] != '1' && in_array($media['media_type'], ['photo', 'video'])) {
          $message['media']['items'][] = $media;
        }
      }
    }
    if ($message['is_paid'] != '1') {
      if ($message['media']['items']) {
        /* legacy fields for older clients */
        foreach ($message['media']['items'] as $media) {
          if ($media['media_type'] == 'photo' && !$message['image']) {
            $message['image'] = $media['source'];
          } elseif ($media['media_type'] == 'video' && !$message['video']) {
            $message['video'] = $media['source'];
          }
        }
      } else {
        /* legacy media columns */
        if ($message['image']) {
          $message['media']['items'][] = ['media_id' => 0, 'message_id' => $message['message_id'], 'media_type' => 'photo', 'source' => $message['image']];
        }
        if ($message['video']) {
          $message['media']['items'][] = ['media_id' => 0, 'message_id' => $message['message_id'], 'media_type' => 'video', 'source' => $message['video']];
        }
      }
    }
    $message['media']['photos_count'] = count(array_filter($message['media']['items'], fn($media) => $media['media_type'] == 'photo'));
    $message['media']['videos_count'] = count($message['media']['items']) - $message['media']['photos_count'];
    $message['media']['files_count'] = count($message['media']['files']);
    /* reply preview */
    $message['reply'] = $this->get_message_reply_preview($message['reply_to'] ?? null);
    /* paid media message */
    $message['needs_payment'] = false;
    $message['can_get_details'] = true;
    if ($message['is_paid'] == '1') {
      $message['message_price'] = $message['message_price'] ?? 0;
      /* monetization access */
      if ($message['is_paid'] == '1' && $system['monetization_enabled']) {
        $author = $this->get_user($message['user_id']);
        $node_monetization_discount_enabled = $author['user_monetization_discount_enabled'];
        $node_monetization_discount_percent = $author['user_monetization_discount_percent'];
        if ($viewer_logged_in) {
          if ($viewer['user_group'] == 3 && $message['user_id'] != $viewer['user_id']) {
            if (!$this->is_user_paid_for_message($message['message_id'], $viewer['user_id'])) {
              $message['needs_payment'] = true;
              $message['message_price_discounted'] = ($node_monetization_discount_enabled) ? $message['message_price'] * (1 - $node_monetization_discount_percent / 100) : 0;
            }
          }
        } else {
          $message['needs_payment'] = true;
          $message['message_price_discounted'] = ($node_monetization_discount_enabled) ? $message['message_price'] * (1 - $node_monetization_discount_percent / 100) : 0;
        }
      }
      /* adult content gate */
      $message['needs_age_verification'] = false;
      if ($system['adult_mode'] && $message['for_adult'] == '1') {
        if ($viewer_logged_in) {
          if ($viewer['user_group'] == 3 && $message['user_id'] != $viewer['user_id']) {
            if (!$viewer['user_adult']) {
              $message['needs_age_verification'] = true;
            } elseif ($system['verification_for_adult_content'] && !$viewer['user_verified']) {
              $message['needs_age_verification'] = true;
            }
          }
        } else {
          $message['needs_age_verification'] = true;
        }
      }
      /* set if can get full message details */
      $message['can_get_details'] = true;
      if ($message['needs_age_verification']) {
        $message['can_get_details'] = false;
      } elseif ($message['needs_payment']) {
        $message['can_get_details'] = false;
      }
      /* author/admin always see full details */
      if ($viewer_logged_in && ($message['user_id'] == $viewer['user_id'] || $viewer['user_group'] < 3)) {
        $message['can_get_details'] = true;
        $message['needs_payment'] = false;
      }
      /* strip locked media sources */
      if (!$message['can_get_details']) {
        $message['media'] = ['items' => [], 'photos' => [], 'video' => null, 'audio' => null, 'file' => null, 'files' => []];
      }
    }
    return $message;
  }


  /**
   * react_message
   * 
   * @param integer $message_id
   * @param string $reaction
   * @return void
   */
  public function react_message($message_id, $reaction)
  {
    global $db, $date;
    /* check reation */
    if (!in_array($reaction, ['like', 'love', 'haha', 'yay', 'wow', 'sad', 'angry'])) {
      throw new BadRequestException(__("Invalid input"));
    }
    /* (check|get) message */
    $get_message = $db->query(sprintf(
      "SELECT 
        conversations_messages.*,
        users.user_id,
        users.user_name,
        users.user_firstname,
        users.user_lastname,
        users.user_gender,
        users.user_picture,
        users.user_subscribed,
        users.user_verified 
      FROM conversations_messages 
      INNER JOIN users 
        ON conversations_messages.user_id = users.user_id 
      INNER JOIN conversations_users 
        ON conversations_messages.conversation_id = conversations_users.conversation_id
      WHERE conversations_messages.message_id = %s",
      secure($message_id, 'int')
    ));
    if ($get_message->num_rows == 0) {
      throw new BadRequestException(__("Message not found"));
    }
    $message = $get_message->fetch_assoc();
    $message = $this->parse_message($message);
    /* react the message */
    if ($message['i_react']) {
      /* remove any previous reaction */
      $db->query(sprintf("DELETE FROM conversations_messages_reactions WHERE user_id = %s AND message_id = %s", secure($this->_data['user_id'], 'int'), secure($message_id, 'int')));
      /* update message reaction counter */
      $reaction_field = "reaction_" . $message['i_reaction'] . "_count";
      $db->query(sprintf("UPDATE conversations_messages SET $reaction_field = IF($reaction_field=0,0,$reaction_field-1) WHERE message_id = %s", secure($message_id, 'int')));
    }
    $db->query(sprintf("INSERT INTO conversations_messages_reactions (user_id, message_id, reaction, reaction_time) VALUES (%s, %s, %s, %s)", secure($this->_data['user_id'], 'int'), secure($message_id, 'int'), secure($reaction), secure($date)));
    $reaction_id = $db->insert_id;
    /* update message reaction counter */
    $reaction_field = "reaction_" . $reaction . "_count";
    $db->query(sprintf("UPDATE conversations_messages SET $reaction_field = $reaction_field + 1 WHERE message_id = %s", secure($message_id, 'int')));
  }


  /**
   * unreact_message
   * 
   * @param integer $message_id
   * @param string $reaction
   * @return void
   */
  public function unreact_message($message_id, $reaction)
  {
    global $db;
    /* check reation */
    if (!in_array($reaction, ['like', 'love', 'haha', 'yay', 'wow', 'sad', 'angry'])) {
      throw new BadRequestException(__("Invalid input"));
    }
    /* (check|get) message */
    $get_message = $db->query(sprintf(
      "SELECT 
        conversations_messages.*,
        users.user_id,
        users.user_name,
        users.user_firstname,
        users.user_lastname,
        users.user_gender,
        users.user_picture,
        users.user_subscribed,
        users.user_verified 
      FROM conversations_messages 
      INNER JOIN users 
        ON conversations_messages.user_id = users.user_id 
      INNER JOIN conversations_users 
        ON conversations_messages.conversation_id = conversations_users.conversation_id
      WHERE conversations_messages.message_id = %s",
      secure($message_id, 'int')
    ));
    if ($get_message->num_rows == 0) {
      throw new BadRequestException(__("Message not found"));
    }
    $message = $get_message->fetch_assoc();
    $message = $this->parse_message($message);
    /* unreact the message */
    if ($message['i_react']) {
      $db->query(sprintf("DELETE FROM conversations_messages_reactions WHERE user_id = %s AND message_id = %s", secure($this->_data['user_id'], 'int'), secure($message_id, 'int')));
      /* update message reaction counter */
      $reaction_field = "reaction_" . $message['i_reaction'] . "_count";
      $db->query(sprintf("UPDATE conversations_messages SET $reaction_field = IF($reaction_field=0,0,$reaction_field-1) WHERE message_id = %s", secure($message_id, 'int')));
    }
  }


  /**
   * get_message_reply_preview
   * 
   * @param integer $reply_to
   * @return array|null
   */
  public function get_message_reply_preview($reply_to)
  {
    global $db, $system;
    if (!$reply_to) {
      return null;
    }
    $get_reply = $db->query(sprintf(
      "SELECT 
        conversations_messages.message_id,
        conversations_messages.message,
        conversations_messages.image,
        conversations_messages.gif,
        conversations_messages.video,
        conversations_messages.voice_note,
        conversations_messages.product_post_id,
        conversations_messages.call_id,
        conversations_calls.is_video_call,
        users.user_name,
        users.user_firstname,
        users.user_lastname,
        pages.page_title
      FROM conversations_messages
      INNER JOIN users ON conversations_messages.user_id = users.user_id
      LEFT JOIN pages ON conversations_messages.page_id = pages.page_id
      LEFT JOIN conversations_calls ON conversations_messages.call_id = conversations_calls.call_id
      WHERE conversations_messages.message_id = %s",
      secure($reply_to, 'int')
    ));
    if ($get_reply->num_rows == 0) {
      return [
        'message_id' => $reply_to,
        'unavailable' => true,
        'user_fullname' => '',
        'snippet' => __("Original message unavailable"),
      ];
    }
    $row = $get_reply->fetch_assoc();
    $snippet = trim(html_entity_decode(censored_words((string) $row['message']), ENT_QUOTES));
    if ($snippet === '') {
      $get_media = $db->query(sprintf("SELECT media_type FROM conversations_messages_media WHERE message_id = %s ORDER BY media_id ASC LIMIT 1", secure($row['message_id'], 'int')));
      $media_type = ($get_media->num_rows > 0) ? $get_media->fetch_assoc()['media_type'] : null;
      if ($media_type == 'photo' || $row['image']) {
        $snippet = __("Photo");
      } elseif ($media_type == 'video' || $row['video']) {
        $snippet = __("Video");
      } elseif ($media_type == 'file') {
        $snippet = __("File");
      } elseif ($media_type == 'audio' || $row['voice_note']) {
        $snippet = __("Voice");
      } elseif ($row['gif']) {
        $snippet = __("GIF");
      } elseif ($row['product_post_id']) {
        $snippet = __("Product");
      } elseif ($row['call_id']) {
        $snippet = ($row['is_video_call'] == '1') ? __("Video call") : __("Audio call");
      } else {
        $snippet = __("Message");
      }
    } elseif (mb_strlen($snippet) > 80) {
      $snippet = mb_substr($snippet, 0, 80) . "...";
    }
    return [
      'message_id' => $row['message_id'],
      'unavailable' => false,
      'user_fullname' => ($row['page_title']) ? $row['page_title'] : (($system['show_usernames_enabled']) ? $row['user_name'] : $row['user_firstname'] . " " . $row['user_lastname']),
      'snippet' => $snippet,
    ];
  }


  /**
   * pin_conversation_message
   * 
   * @param integer $message_id
   * @param boolean $as_page
   * @return array
   */
  public function pin_conversation_message($message_id, $as_page = false)
  {
    global $db;
    if ($as_page) {
      $get_message = $db->query(sprintf("SELECT message_id, conversation_id FROM conversations_messages WHERE message_id = %s", secure($message_id, 'int')));
      if ($get_message->num_rows == 0) {
        throw new AuthorizationException(__("You are not authorized to do this"));
      }
      $message = $get_message->fetch_assoc();
      if (!$this->check_page_conversation_access($message['conversation_id'])) {
        throw new AuthorizationException(__("You are not authorized to do this"));
      }
    } else {
      $get_message = $db->query(sprintf(
        "SELECT conversations_messages.message_id, conversations_messages.conversation_id
        FROM conversations_messages
        INNER JOIN conversations_users ON conversations_messages.conversation_id = conversations_users.conversation_id
        WHERE conversations_messages.message_id = %s AND conversations_users.user_id = %s",
        secure($message_id, 'int'),
        secure($this->_data['user_id'], 'int')
      ));
      if ($get_message->num_rows == 0) {
        throw new AuthorizationException(__("You are not authorized to do this"));
      }
      $message = $get_message->fetch_assoc();
    }
    $db->query(sprintf(
      "UPDATE conversations SET pinned_message_id = %s WHERE conversation_id = %s",
      secure($message['message_id'], 'int'),
      secure($message['conversation_id'], 'int')
    ));
    return $this->get_conversation($message['conversation_id'], $as_page);
  }


  /**
   * unpin_conversation_message
   * 
   * @param integer $conversation_id
   * @param boolean $as_page
   * @return array
   */
  public function unpin_conversation_message($conversation_id, $as_page = false)
  {
    global $db;
    $conversation = $this->get_conversation($conversation_id, $as_page);
    if (!$conversation) {
      throw new AuthorizationException(__("You are not authorized to do this"));
    }
    $db->query(sprintf("UPDATE conversations SET pinned_message_id = NULL WHERE conversation_id = %s", secure($conversation_id, 'int')));
    $conversation['pinned_message_id'] = null;
    $conversation['pinned_message'] = null;
    return $conversation;
  }
}
