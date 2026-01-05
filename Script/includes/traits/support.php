<?php

/**
 * trait -> support center
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich
 */

trait SupportTrait
{

  /* ------------------------------- */
  /* Support Tickets */
  /* ------------------------------- */

  /**
   * get_support_tickets_stats
   * 
   * @return array
   */
  public function get_support_tickets_stats()
  {
    global $db;
    $stats = [];
    if ($this->_is_admin) {
      /* get stats of all tickets */
      $stats['total'] = $db->query("SELECT COUNT(*) AS count FROM support_tickets")->fetch_assoc()['count'];
      $stats['unassigned'] = $db->query("SELECT COUNT(*) AS count FROM support_tickets WHERE agent_id IS NULL OR agent_id = 0")->fetch_assoc()['count'];
      $stats['in_progress'] = $db->query("SELECT COUNT(*) AS count FROM support_tickets WHERE status = 'in_progress'")->fetch_assoc()['count'];
      $stats['opened'] = $db->query("SELECT COUNT(*) AS count FROM support_tickets WHERE status = 'opened'")->fetch_assoc()['count'];
      $stats['pending'] = $db->query("SELECT COUNT(*) AS count FROM support_tickets WHERE status = 'pending'")->fetch_assoc()['count'];
      $stats['solved'] = $db->query("SELECT COUNT(*) AS count FROM support_tickets WHERE status = 'solved'")->fetch_assoc()['count'];
      $stats['closed'] = $db->query("SELECT COUNT(*) AS count FROM support_tickets WHERE status = 'closed'")->fetch_assoc()['count'];
    } elseif ($this->_is_moderator) {
      /* get stats of tickets assigned to this moderator */
      $stats['total'] = $db->query(sprintf("SELECT COUNT(*) AS count FROM support_tickets WHERE agent_id = %s", secure($this->_data['user_id'], 'int')))->fetch_assoc()['count'];
      $stats['in_progress'] = $db->query(sprintf("SELECT COUNT(*) AS count FROM support_tickets WHERE agent_id = %s AND status = 'in_progress'", secure($this->_data['user_id'], 'int')))->fetch_assoc()['count'];
      $stats['opened'] = $db->query(sprintf("SELECT COUNT(*) AS count FROM support_tickets WHERE agent_id = %s AND status = 'opened'", secure($this->_data['user_id'], 'int')))->fetch_assoc()['count'];
      $stats['pending'] = $db->query(sprintf("SELECT COUNT(*) AS count FROM support_tickets WHERE agent_id = %s AND status = 'pending'", secure($this->_data['user_id'], 'int')))->fetch_assoc()['count'];
      $stats['solved'] = $db->query(sprintf("SELECT COUNT(*) AS count FROM support_tickets WHERE agent_id = %s AND status = 'solved'", secure($this->_data['user_id'], 'int')))->fetch_assoc()['count'];
      $stats['closed'] = $db->query(sprintf("SELECT COUNT(*) AS count FROM support_tickets WHERE agent_id = %s AND status = 'closed'", secure($this->_data['user_id'], 'int')))->fetch_assoc()['count'];
    } else {
      /* get stats of tickets created by this user */
      $stats['total'] = $db->query(sprintf("SELECT COUNT(*) AS count FROM support_tickets WHERE user_id = %s", secure($this->_data['user_id'], 'int')))->fetch_assoc()['count'];
      $stats['in_progress'] = $db->query(sprintf("SELECT COUNT(*) AS count FROM support_tickets WHERE user_id = %s AND status = 'in_progress'", secure($this->_data['user_id'], 'int')))->fetch_assoc()['count'];
      $stats['opened'] = $db->query(sprintf("SELECT COUNT(*) AS count FROM support_tickets WHERE user_id = %s AND status = 'opened'", secure($this->_data['user_id'], 'int')))->fetch_assoc()['count'];
      $stats['pending'] = $db->query(sprintf("SELECT COUNT(*) AS count FROM support_tickets WHERE user_id = %s AND status = 'pending'", secure($this->_data['user_id'], 'int')))->fetch_assoc()['count'];
      $stats['solved'] = $db->query(sprintf("SELECT COUNT(*) AS count FROM support_tickets WHERE user_id = %s AND status = 'solved'", secure($this->_data['user_id'], 'int')))->fetch_assoc()['count'];
      $stats['closed'] = $db->query(sprintf("SELECT COUNT(*) AS count FROM support_tickets WHERE user_id = %s AND status = 'closed'", secure($this->_data['user_id'], 'int')))->fetch_assoc()['count'];
    }
    return $stats;
  }


  /**
   * create_support_ticket
   * 
   * @param string $subject
   * @param string $text
   * @return void
   */
  public function create_support_ticket($subject, $text)
  {
    global $db, $system, $date;
    /* check if support center enabled */
    if (!$system['support_center_enabled']) {
      throw new Exception(__("The support center has been disabled by the admin"));
    }
    /* check if user is admin or moderator */
    if ($this->_is_admin || $this->_is_moderator) {
      throw new Exception(__("Admins and moderators can't create a support ticket"));
    }
    /* validate subject */
    if (is_empty($subject)) {
      throw new Exception(__("You must enter a subject for your ticket"));
    }
    if (strlen($subject) < 3) {
      throw new Exception(__("Subject must be at least 3 characters long. Please try another"));
    }
    if (strlen($subject) > 255) {
      throw new Exception(__("Subject must be less than 255 characters long. Please try another"));
    }
    /* validate content */
    if (is_empty($text)) {
      throw new Exception(__("You must enter a content for your ticket"));
    }
    if (strlen($text) < 10) {
      throw new Exception(__("Content must be at least 10 characters long. Please try another"));
    }
    if (strlen($text) > 10000) {
      throw new Exception(__("Content must be less than 10000 characters long. Please try another"));
    }
    /* insert new ticket */
    $db->query(
      sprintf(
        "INSERT INTO support_tickets (
            user_id,
            subject,
            text,
            created_at,
            updated_at
        ) VALUES (
            %s, %s, %s, %s, %s
        )",
        secure($this->_data['user_id'], 'int'),
        secure($subject),
        secure($text),
        secure($date),
        secure($date)
      )
    );
    $ticket_id = $db->insert_id;
    /* send notification to admins */
    $this->notify_system_admins("support_ticket_created");
    /* return ticket id */
    return $ticket_id;
  }


  /**
   * edit_support_ticket
   * 
   * @param integer $ticket_id
   * @param string $status
   * @param integer $agent_id
   * @return void
   */
  public function edit_support_ticket($ticket_id, $status, $agent_id)
  {
    global $db, $system, $date;
    /* check if support center enabled */
    if (!$system['support_center_enabled']) {
      throw new Exception(__("The support center has been disabled"));
    }
    /* get ticket */
    $ticket = $this->get_support_ticket($ticket_id);
    /* validate status */
    if (!in_array($status, ['opened', 'in_progress', 'pending', 'solved', 'closed'])) {
      throw new Exception(__("Invalid status"));
    }
    /* validate agent id */
    $agent_query = "";
    if ($this->_is_admin) {
      if ($agent_id != 0) {
        if (!is_numeric($agent_id)) {
          throw new Exception(__("Invalid agent id"));
        }
        /* check if agent exists */
        $agent = $this->get_user($agent_id);
        if (!$agent) {
          throw new Exception(__("Agent not found"));
        }
      }
      $agent_query = sprintf("agent_id = %s, ", secure($agent_id, 'int'));
    }
    /* update ticket */
    $db->query(sprintf("UPDATE support_tickets SET status = %s, " . $agent_query . "updated_at = %s WHERE ticket_id = %s", secure($status), secure($date), secure($ticket_id, 'int')));
    /* send notification to requester */
    $this->post_notification(['to_user_id' => $ticket['user_id'], 'action' => 'support_ticket_updated', 'node_url' => $ticket['ticket_id']]);
  }


  /**
   * reply_to_support_ticket
   * 
   * @param integer $ticket_id
   * @param string $text
   * @return void
   */
  public function reply_to_support_ticket($ticket_id, $text)
  {
    global $db, $system, $date;
    /* check if support center enabled */
    if (!$system['support_center_enabled']) {
      throw new Exception(__("The support center has been disabled"));
    }
    /* get ticket */
    $ticket = $this->get_support_ticket($ticket_id);
    /* check if user is the requester */
    if (!$this->_is_admin) {
      if ($this->_is_moderator) {
        /* check if user is the agent */
        if ($ticket['agent_id'] != $this->_data['user_id']) {
          throw new Exception(__("You don't have the permission to do this"));
        }
      } else {
        /* check if user is the requester */
        if ($ticket['user_id'] != $this->_data['user_id']) {
          throw new Exception(__("You don't have the permission to do this"));
        }
      }
    }
    /* validate text */
    if (is_empty($text)) {
      throw new Exception(__("You must enter a reply for your ticket"));
    }
    if (strlen($text) < 10) {
      throw new Exception(__("Reply must be at least 10 characters long. Please try another"));
    }
    if (strlen($text) > 10000) {
      throw new Exception(__("Reply must be less than 10000 characters long. Please try another"));
    }
    /* insert reply */
    $db->query(sprintf("INSERT INTO support_tickets_replies (ticket_id, user_id, text, created_at) VALUES (%s, %s, %s, %s)", secure($ticket_id, 'int'), secure($this->_data['user_id'], 'int'), secure($text), secure($date)));
    /* update ticket */
    $db->query(sprintf("UPDATE support_tickets SET status = 'in_progress', replies = replies + 1, updated_at = %s WHERE ticket_id = %s", secure($date), secure($ticket_id, 'int')));
    /* send notification to requester and agent */
    $to_user_id = ($this->_data['user_id'] == $ticket['user_id']) ? $ticket['agent_id'] : $ticket['user_id'];
    if ($to_user_id) {
      $this->post_notification(['to_user_id' => $to_user_id, 'action' => 'support_ticket_replied', 'node_url' => $ticket['ticket_id']]);
    }
  }


  /**
   * get_support_tickets
   * 
   * @param array $args
   * @return array
   */
  public function get_support_tickets($args = [])
  {
    global $db, $system, $date;
    $tickets = [];
    /* check if support center enabled */
    if (!$system['support_center_enabled']) {
      return $tickets;
    }
    /* prepare where & url query */
    $where_query = "";
    $url_query = "";
    /* query */
    $query = !isset($args['query']) ? null : $args['query'];
    if ($query) {
      $where_query = sprintf("support_tickets.subject LIKE %s OR support_tickets.ticket_id = %s", secure($query, 'search'), secure($query, 'int'));
      $url_query = "query=" . $query;
    }
    /* status (opened | in_progress | pending | solved | closed) */
    $status = !isset($args['status']) ? null : $args['status'];
    if ($status) {
      if (!in_array($status, ['opened', 'in_progress', 'pending', 'solved', 'closed'])) {
        throw new Exception(__("Invalid status"));
      }
      if ($where_query) $where_query .= " AND ";
      $where_query .= sprintf("support_tickets.status = %s", secure($status));
      if ($url_query) $url_query .= "&";
      $url_query = "status=" . $status;
    }
    /* unassigned */
    $unassigned = !isset($args['unassigned']) ? null : $args['unassigned'];
    if ($unassigned) {
      if ($where_query) $where_query .= " AND ";
      $where_query .= "support_tickets.agent_id IS NULL OR support_tickets.agent_id = 0";
      if ($url_query) $url_query .= "&";
      $url_query .= "unassigned=true";
    }
    /* user (admin | moderator | user) */
    if (!$this->_is_admin) {
      if ($this->_is_moderator) {
        if ($where_query) $where_query .= " AND ";
        $where_query .= sprintf("support_tickets.agent_id = %s", secure($this->_data['user_id'], 'int'));
      } else {
        if ($where_query) $where_query .= " AND ";
        $where_query .= sprintf("support_tickets.user_id = %s", secure($this->_data['user_id'], 'int'));
      }
    }
    /* prepare pager */
    require('includes/class-pager.php');
    $params['selected_page'] = (!isset($args['page']) || (int) $args['page'] == 0) ? 1 : $args['page'];
    $params['items_per_page'] = !isset($args['results']) ? $system['max_results'] : $args['results'];
    $params['url'] = $system['system_url'] . '/support/tickets?' . $url_query . '&page=%s';
    /* get total tickets */
    $total = $db->query(
      "SELECT COUNT(*) as count
       FROM support_tickets
       INNER JOIN users AS requesters ON support_tickets.user_id = requesters.user_id
       LEFT JOIN users AS agents ON support_tickets.agent_id = agents.user_id
       " . ($where_query ? "WHERE $where_query" : "")
    );
    $params['total_items'] = $total->fetch_assoc()['count'];
    /* create pager */
    $pager = new Pager($params);
    $limit_query = $pager->getLimitSql();
    /* get tickets */
    $get_tickets = $db->query(
      "SELECT 
            requesters.user_name AS requester_username,
            requesters.user_firstname AS requester_firstname,
            requesters.user_lastname AS requester_lastname,
            requesters.user_gender AS requester_gender,
            requesters.user_picture AS requester_picture,
            agents.user_name AS agent_username,
            agents.user_firstname AS agent_firstname,
            agents.user_lastname AS agent_lastname,
            agents.user_gender AS agent_gender,
            agents.user_picture AS agent_picture,
            support_tickets.* 
        FROM support_tickets
        INNER JOIN users AS requesters ON support_tickets.user_id = requesters.user_id
        LEFT JOIN users AS agents ON support_tickets.agent_id = agents.user_id
        " . ($where_query ? "WHERE $where_query" : "") . "
        ORDER BY support_tickets.updated_at DESC
        " . ($limit_query ? $limit_query : "")
    );
    if ($get_tickets->num_rows > 0) {
      while ($ticket = $get_tickets->fetch_assoc()) {
        $ticket['requester_picture'] = get_picture($ticket['requester_picture'], $ticket['requester_gender']);
        $ticket['requester_fullname'] = $system['show_usernames_enabled'] ? $ticket['requester_name'] : $ticket['requester_firstname'] . ' ' . $ticket['requester_lastname'];
        $ticket['agent_picture'] = get_picture($ticket['agent_picture'], $ticket['agent_gender']);
        $ticket['agent_fullname'] = $system['show_usernames_enabled'] ? $ticket['agent_name'] : $ticket['agent_firstname'] . ' ' . $ticket['agent_lastname'];
        $tickets[] = $ticket;
      }
    }
    /* return tickets */
    return [
      'tickets' => $tickets,
      'pager' => $pager->getPager()
    ];
  }


  /**
   * get_support_ticket
   * 
   * @param integer $ticket_id
   * @return array
   */
  public function get_support_ticket($ticket_id)
  {
    global $db, $system, $date;
    /* check if support center enabled */
    if (!$system['support_center_enabled']) {
      throw new Exception(__("The support center has been disabled"));
    }
    /* prepare where query */
    $where_query = "";
    if (!$this->_is_admin) {
      if ($this->_is_moderator) {
        $where_query .= sprintf(" AND support_tickets.agent_id = %s", secure($this->_data['user_id'], 'int'));
      } else {
        $where_query .= sprintf(" AND support_tickets.user_id = %s", secure($this->_data['user_id'], 'int'));
      }
    }
    /* get ticket */
    $get_ticket = $db->query(
      sprintf(
        "SELECT requesters.user_name AS requester_username,
            requesters.user_firstname AS requester_firstname,
            requesters.user_lastname AS requester_lastname,
            requesters.user_gender AS requester_gender,
            requesters.user_picture AS requester_picture,
            requesters.user_registered AS requester_registered,
            agents.user_name AS agent_username,
            agents.user_firstname AS agent_firstname,
            agents.user_lastname AS agent_lastname,
            agents.user_gender AS agent_gender,
            agents.user_picture AS agent_picture,
            support_tickets.*
        FROM support_tickets
        INNER JOIN users AS requesters ON support_tickets.user_id = requesters.user_id
        LEFT JOIN users AS agents ON support_tickets.agent_id = agents.user_id
        WHERE support_tickets.ticket_id = %s " . $where_query,
        secure($ticket_id, 'int')
      )
    );
    if ($get_ticket->num_rows == 0) {
      throw new Exception(__("Ticket not found"));
    }
    $ticket = $get_ticket->fetch_assoc();
    $ticket['requester_picture'] = get_picture($ticket['requester_picture'], $ticket['requester_gender']);
    $ticket['requester_fullname'] = $system['show_usernames_enabled'] ? $ticket['requester_name'] : $ticket['requester_firstname'] . ' ' . $ticket['requester_lastname'];
    $ticket['agent_picture'] = get_picture($ticket['agent_picture'], $ticket['agent_gender']);
    $ticket['agent_fullname'] = $system['show_usernames_enabled'] ? $ticket['agent_name'] : $ticket['agent_firstname'] . ' ' . $ticket['agent_lastname'];
    $ticket['parsed_text'] = htmlspecialchars_decode($ticket['text']);
    /* get replies */
    $ticket['replies'] = [];
    $get_replies = $db->query(
      sprintf(
        "SELECT 
                support_tickets_replies.*, 
                users.user_name, 
                users.user_firstname, 
                users.user_lastname, 
                users.user_gender, 
                users.user_picture,
                users.user_group
            FROM 
                support_tickets_replies 
            INNER JOIN users ON support_tickets_replies.user_id = users.user_id 
            WHERE support_tickets_replies.ticket_id = %s
            ORDER BY support_tickets_replies.reply_id ASC",
        secure($ticket_id, 'int')
      )
    );
    if ($get_replies->num_rows > 0) {
      while ($reply = $get_replies->fetch_assoc()) {
        if ($this->_is_admin || $this->_is_moderator) {
          $reply['user_picture'] = get_picture($reply['user_picture'], $reply['user_gender']);
          $reply['user_fullname'] = $system['show_usernames_enabled'] ? $reply['user_name'] : $reply['user_firstname'] . ' ' . $reply['user_lastname'];
        } else {
          if ($this->_data['user_id'] == $reply['user_id']) {
            $reply['user_picture'] = get_picture($reply['user_picture'], $reply['user_gender']);
            $reply['user_fullname'] = $system['show_usernames_enabled'] ? $reply['user_name'] : $reply['user_firstname'] . ' ' . $reply['user_lastname'];
          } else {
            $reply['user_picture'] = get_picture("", "system");
            $reply['user_fullname'] = __("Support Agent");
          }
        }
        $reply['parsed_text'] = htmlspecialchars_decode($reply['text']);
        $ticket['replies'][] = $reply;
      }
    }
    return $ticket;
  }
}
