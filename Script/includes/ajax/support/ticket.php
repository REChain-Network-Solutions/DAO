<?php

/**
 * ajax -> support -> ticket
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich
 */

// fetch bootstrap
require('../../../bootstrap.php');

// check AJAX Request
is_ajax();

// user access
user_access(true);

// check demo account
if ($user->_data['user_demo']) {
  modal("ERROR", __("Demo Restriction"), __("You can't do this with demo account"));
}

try {

  // initialize the return array
  $return = [];
  $return['callback'] = 'window.location.replace(response.path);';

  switch ($_GET['do']) {
    case 'create':
      // create support ticket
      $ticket_id = $user->create_support_ticket($_POST['subject'], $_POST['text']);

      // return
      $return['path'] = $system['system_url'] . '/support/tickets/' . $ticket_id;
      break;

    case 'reply':
      // reply to support ticket
      $user->reply_to_support_ticket($_GET['id'], $_POST['text']);

      // return
      $return['path'] = $system['system_url'] . '/support/tickets/' . $_GET['id'];
      break;

    case 'update':
      // check admin|moderator permission
      if (!$user->_is_admin && !$user->_is_moderator) {
        modal("ERROR", __("System Message"), __("You don't have the right permission to access this"));
      }

      // get support ticket
      $smarty->assign('ticket', $user->get_support_ticket($_GET['ticket_id']));

      // get agents
      if ($user->_is_admin) {
        $smarty->assign('agents', $user->get_admins_moderators());
      }

      // return
      $return['template'] = $smarty->fetch("ajax.ticket.update.tpl");
      $return['callback'] = "$('#modal').modal('show'); $('.modal-content:last').html(response.template); initialize_modal();";
      break;

    case 'edit':
      // edit support ticket
      $user->edit_support_ticket($_POST['ticket_id'], $_POST['status'], $_POST['agent_id']);

      // return
      $return['path'] = $system['system_url'] . '/support/tickets/' . $_POST['ticket_id'];
      break;

    default:
      _error(400);
      break;
  }

  // return & exit
  return_json($return);
} catch (Exception $e) {
  return_json(['error' => true, 'message' => $e->getMessage()]);
}
