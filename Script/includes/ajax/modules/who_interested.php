<?php

/**
 * ajax -> modules -> who interested
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

// valid inputs
if (!isset($_GET['event_id']) || !is_numeric($_GET['event_id'])) {
  _error(400);
}

try {

  // initialize the return array
  $return = [];

  // get interested users
  $users = $user->get_event_members($_GET['event_id'], 'interested');
  /* assign variables */
  $smarty->assign('users', $users);
  $smarty->assign('id', $_GET['event_id']);
  /* return */
  $return['template'] = $smarty->fetch("ajax.who_interested.tpl");
  $return['callback'] = "$('#modal').modal('show'); $('.modal-content:last').html(response.template);";

  // return & exit
  return_json($return);
} catch (Exception $e) {
  modal("ERROR", __("Error"), $e->getMessage());
}
