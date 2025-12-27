<?php

/**
 * support
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich
 */

// fetch bootloader
require('bootloader.php');

// check if support enabled
if (!$system['support_center_enabled']) {
  _error(404);
}

// user access
user_access();

try {
  // get view content
  switch ($_GET['view']) {
    case '':
    case 'tickets':
      // page header
      page_header(__("Support Center") . ' | ' . __($system['system_title']));

      // get tickets
      $return = $user->get_support_tickets(['page' => $_GET['page'], 'status' => $_GET['status'], 'unassigned' => $_GET['unassigned']]);
      $smarty->assign('tickets', $return['tickets']);
      $smarty->assign('pager', $return['pager']);
      $smarty->assign('status', $_GET['status']);
      $smarty->assign('unassigned', $_GET['unassigned']);
      break;

    case 'find':
      // page header
      page_header(__("Support Center") . ' | ' . __($system['system_title']));

      // get tickets
      $return = $user->get_support_tickets(['page' => $_GET['page'], 'query' => $_GET['query']]);
      $smarty->assign('tickets', $return['tickets']);
      $smarty->assign('pager', $return['pager']);
      $smarty->assign('query', htmlentities($_GET['query'], ENT_QUOTES, 'utf-8'));
      break;

    case 'ticket':
      // page header
      page_header(__("Support Center") . ' | ' . __($system['system_title']));

      // get ticket
      $ticket = $user->get_support_ticket($_GET['ticket_id']);
      if (!$ticket) {
        _error(404);
      }
      $smarty->assign('ticket', $ticket);
      break;

    case 'new':
      // page header
      page_header(__("Create New Ticket") . ' | ' . __($system['system_title']) . " " . __("Support Center"));
      break;

    default:
      _error(404);
      break;
  }

  // get tickets stats
  $smarty->assign('tickets_stats', $user->get_support_tickets_stats());

  // assign variables
  $smarty->assign('view', $_GET['view']);
} catch (Exception $e) {
  _error(__("Error"), $e->getMessage());
}

// page footer
page_footer('support');
