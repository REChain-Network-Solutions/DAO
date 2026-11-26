<?php

/**
 * ajax -> modules -> invites
 * 
 * @package Sngine
 * @author Zamblek
 */

// fetch bootstrap
require('../../../bootstrap.php');

// check AJAX Request
is_ajax();

// user access
user_access(true);

// valid inputs
if (!isset($_GET['type']) || !in_array($_GET['type'], ['page', 'group', 'event'])) {
  _error(400);
}
if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
  _error(400);
}

try {

  // initialize the return array
  $return = [];

  // get invites
  switch ($_GET['type']) {
    case 'page':
      /* check if the viewer is a page member */
      if (!$user->check_page_membership($user->_data['user_id'], $_GET['id'])) {
        _error(403);
      }
      $invites = $user->get_page_invites($_GET['id']);
      break;

    case 'group':
      /* check if the viewer is a group member */
      if ($user->check_group_membership($user->_data['user_id'], $_GET['id']) != "approved") {
        _error(403);
      }
      $invites = $user->get_group_invites($_GET['id']);
      break;

    case 'event':
      /* check if the viewer is a event member */
      if (!$user->check_event_membership($user->_data['user_id'], $_GET['id'])) {
        _error(403);
      }
      $invites = $user->get_event_invites($_GET['id']);
      break;
  }
  /* assign variables */
  $smarty->assign('type', $_GET['type']);
  $smarty->assign('id', $_GET['id']);
  $smarty->assign('invites', $invites);
  /* return */
  $return['invites'] = $smarty->fetch("ajax.invites.tpl");
  $return['callback'] = "modal_content(response.invites);";

  // return & exit
  return_json($return);
} catch (Exception $e) {
  modal("ERROR", __("Error"), $e->getMessage());
}
