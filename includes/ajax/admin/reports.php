<?php

/**
 * ajax -> admin -> reports
 * 
 * @package Sngine
 * @author Zamblek
 */

// fetch bootstrap
require('../../../bootstrap.php');

// check AJAX Request
is_ajax();

// check admin|moderator permission
admin_access('mods_reports_permission');

// check demo account
if ($user->_data['user_demo']) {
  modal("ERROR", __("Demo Restriction"), __("You can't do this with demo account"));
}

// handle reports
try {

  switch ($_GET['do']) {
    case 'view':
      /* valid inputs */
      if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
        _error(400);
      }
      $get_report = $db->query(sprintf("SELECT reports.*, reports_categories.category_name, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM reports LEFT JOIN reports_categories ON reports.category_id = reports_categories.category_id LEFT JOIN users ON reports.user_id = users.user_id WHERE reports.report_id = %s", secure($_GET['id'], 'int')));
      if ($get_report->num_rows == 0) {
        modal("ERROR", __("Error"), __("This report does not exist"));
      }
      $report = $get_report->fetch_assoc();
      if (!in_array($report['node_type'], ['message', 'conversation'])) {
        _error(400);
      }
      $report['user_picture'] = get_picture($report['user_picture'], $report['user_gender']);
      $report['user_fullname'] = ($system['show_usernames_enabled']) ? $report['user_name'] : trim($report['user_firstname'] . " " . $report['user_lastname']);

      /* resolve the conversation */
      $highlighted_id = 0;
      if ($report['node_type'] == 'message') {
        $message = $user->get_conversation_message_by_id($report['node_id']);
        if (!$message) {
          modal("ERROR", __("Error"), __("This message does not exist"));
        }
        $conversation_id = $message['conversation_id'];
        $highlighted_id = $message['message_id'];
      } else {
        $conversation_id = $report['node_id'];
      }

      $get_conversation = $db->query(sprintf("SELECT * FROM conversations WHERE conversation_id = %s", secure($conversation_id, 'int')));
      if ($get_conversation->num_rows == 0) {
        modal("ERROR", __("Error"), __("This conversation does not exist"));
      }
      $conversation = $get_conversation->fetch_assoc();

      /* participants */
      $get_participants = $db->query(sprintf(
        "SELECT users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture
         FROM conversations_users
         INNER JOIN users ON conversations_users.user_id = users.user_id
         WHERE conversations_users.conversation_id = %s
         ORDER BY conversations_users.user_id ASC",
        secure($conversation_id, 'int')
      ));
      $participants = [];
      $names = [];
      while ($participant = $get_participants->fetch_assoc()) {
        $participant['user_picture'] = get_picture($participant['user_picture'], $participant['user_gender']);
        $participant['user_fullname'] = ($system['show_usernames_enabled']) ? $participant['user_name'] : $participant['user_firstname'] . " " . $participant['user_lastname'];
        $participants[] = $participant;
        $names[] = $participant['user_fullname'];
      }
      $conversation['participants'] = $participants;
      $custom_name = trim((string)($conversation['name'] ?? ''));
      if ($conversation['node_type'] == 'group' && $conversation['node_id']) {
        $get_group = $db->query(sprintf("SELECT group_title FROM `groups` WHERE group_id = %s", secure($conversation['node_id'], 'int')));
        if ($get_group->num_rows > 0) {
          $conversation['name'] = __("Group") . ": " . $get_group->fetch_assoc()['group_title'];
        }
      } elseif ($conversation['node_type'] == 'event' && $conversation['node_id']) {
        $get_event = $db->query(sprintf("SELECT event_title FROM `events` WHERE event_id = %s", secure($conversation['node_id'], 'int')));
        if ($get_event->num_rows > 0) {
          $conversation['name'] = __("Event") . ": " . $get_event->fetch_assoc()['event_title'];
        }
      } elseif ($custom_name !== '') {
        $conversation['name'] = $custom_name;
      } else {
        $conversation['name'] = implode(', ', $names);
      }
      if (is_empty($conversation['name'])) {
        $conversation['name'] = __("Conversation") . " #" . $conversation_id;
      }

      /* messages */
      $messages = [];
      if ($report['node_type'] == 'message') {
        $get_before = $db->query(sprintf(
          "SELECT conversations_messages.*, users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, users.user_subscribed, users.user_verified
           FROM conversations_messages
           INNER JOIN users ON conversations_messages.user_id = users.user_id
           WHERE conversations_messages.conversation_id = %s AND conversations_messages.message_id < %s
           ORDER BY conversations_messages.message_id DESC LIMIT 5",
          secure($conversation_id, 'int'),
          secure($highlighted_id, 'int')
        ));
        $before = [];
        while ($row = $get_before->fetch_assoc()) {
          $before[] = $user->parse_message($row);
        }
        $get_after = $db->query(sprintf(
          "SELECT conversations_messages.*, users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, users.user_subscribed, users.user_verified
           FROM conversations_messages
           INNER JOIN users ON conversations_messages.user_id = users.user_id
           WHERE conversations_messages.conversation_id = %s AND conversations_messages.message_id > %s
           ORDER BY conversations_messages.message_id ASC LIMIT 5",
          secure($conversation_id, 'int'),
          secure($highlighted_id, 'int')
        ));
        $after = [];
        while ($row = $get_after->fetch_assoc()) {
          $after[] = $user->parse_message($row);
        }
        $messages = array_merge(array_reverse($before), [$message], $after);
      } else {
        $get_messages = $db->query(sprintf(
          "SELECT * FROM (
            SELECT conversations_messages.*, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, users.user_subscribed, users.user_verified
            FROM conversations_messages
            INNER JOIN users ON conversations_messages.user_id = users.user_id
            WHERE conversations_messages.conversation_id = %s
            ORDER BY conversations_messages.message_id DESC
            LIMIT 20
          ) messages ORDER BY messages.message_id ASC",
          secure($conversation_id, 'int')
        ));
        while ($row = $get_messages->fetch_assoc()) {
          $messages[] = $user->parse_message($row);
        }
      }

      /* paid media */
      $reported_message = null;
      foreach ($messages as &$_message) {
        if ($_message['is_paid'] == '1' && !$_message['media']['items']) {
          $_message['media']['items'] = $_message['media']['photos'];
          if ($_message['media']['video']) {
            $_message['media']['items'][] = $_message['media']['video'];
          }
        }
        if ($highlighted_id && $_message['message_id'] == $highlighted_id) {
          $reported_message = $_message;
        }
      }
      unset($_message);

      /* return */
      $smarty->assign('report', $report);
      $smarty->assign('conversation', $conversation);
      $smarty->assign('messages', $messages);
      $smarty->assign('highlighted_id', $highlighted_id);
      $smarty->assign('reported_message', $reported_message);
      $smarty->assign('node_type', $report['node_type']);
      return_json(['template' => $smarty->fetch("ajax.reports.message.tpl"), 'callback' => "modal_content(response.template, true);"]);
      break;

    case 'add_category':
      /* valid inputs */
      if (is_empty($_POST['category_name'])) {
        throw new Exception(__("Please enter a valid category name"));
      }
      if (!is_empty($_POST['category_order']) && !is_numeric($_POST['category_order'])) {
        throw new Exception(__("Please enter a valid category order"));
      }
      /* insert */
      $db->query(sprintf("INSERT INTO reports_categories (category_name, category_description, category_parent_id, category_order) VALUES (%s, %s, %s, %s)", secure($_POST['category_name']),  secure($_POST['category_description']), secure($_POST['category_parent_id'], 'int'), secure($_POST['category_order'], 'int')));
      /* return */
      return_json(['callback' => 'window.location = "' . $system['system_url'] . '/' . $control_panel['url'] . '/reports/categories";']);
      break;

    case 'edit_category':
      /* valid inputs */
      if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
        _error(400);
      }
      if (is_empty($_POST['category_name'])) {
        throw new Exception(__("Please enter a valid category name"));
      }
      if (!is_empty($_POST['category_order']) && !is_numeric($_POST['category_order'])) {
        throw new Exception(__("Please enter a valid category order"));
      }
      /* update */
      $db->query(sprintf("UPDATE reports_categories SET category_name = %s, category_description = %s, category_parent_id = %s, category_order = %s WHERE category_id = %s", secure($_POST['category_name']), secure($_POST['category_description']), secure($_POST['category_parent_id'], 'int'), secure($_POST['category_order'], 'int'), secure($_GET['id'], 'int')));
      /* return */
      return_json(['success' => true, 'message' => __("Category info have been updated")]);
      break;

    default:
      _error(400);
      break;
  }
} catch (Exception $e) {
  if (($_GET['do'] ?? '') == 'view') {
    modal("ERROR", __("Error"), $e->getMessage());
  }
  return_json(['error' => true, 'message' => $e->getMessage()]);
}
