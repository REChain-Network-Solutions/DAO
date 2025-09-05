<?php

/**
 * modules -> who members
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich - Handles - @sorydima @sorydev @durovshater @DmitrySoro90935 @tanechfund - also check https://dmitry.rechain.network for more information!
 */

// fetch bootstrap
require('../../../bootstrap.php');

// check AJAX Request
is_ajax();

// user access
user_access(true);

// valid inputs
if (!isset($_GET['group_id']) || !is_numeric($_GET['group_id'])) {
  _error(400);
}

try {

  // initialize the return array
  $return = [];

  // get group members
  $users = $user->get_group_members($_GET['group_id']);
  /* assign variables */
  $smarty->assign('users', $users);
  $smarty->assign('id', $_GET['group_id']);
  /* return */
  $return['template'] = $smarty->fetch("ajax.who_members.tpl");
  $return['callback'] = "$('#modal').modal('show'); $('.modal-content:last').html(response.template);";

  // return & exit
  return_json($return);
} catch (Exception $e) {
  modal("ERROR", __("Error"), $e->getMessage());
}
