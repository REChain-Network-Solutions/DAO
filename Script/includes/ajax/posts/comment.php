<?php

/**
 * ajax -> posts -> comment
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

// check demo account
if ($user->_data['user_demo']) {
  modal("ERROR", __("Demo Restriction"), __("You can't do this with demo account"));
}

// check comments permission
if (!$user->_data['can_comment']) {
  if ($user->_data['can_upgrade_comments']) {
    return_json(["callback" => "window.location = '" . $system['system_url'] . "/packages?highlight=true';"]);
  } else {
    modal("MESSAGE", __("Error"), __("You don't have the permission to do this"));
  }
}

// valid inputs
$valid['handle'] = ['post', 'photo', 'comment'];
if (!in_array($_POST['handle'], $valid['handle'])) {
  _error(400);
}
/* if id is set & not numeric */
if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
  _error(400);
}
/* if message not set */
if (!isset($_POST['message'])) {
  _error(400);
}
/* filter comment photo */
if (isset($_POST['photo'])) {
  $_POST['photo'] = json_decode($_POST['photo']);
  if ($_POST['photo']) {
    if (is_object($_POST['photo'])) {
      if (!is_valid_upload_source($_POST['photo']->source ?? null)) {
        _error(400);
      }
      $_POST['photo'] = $_POST['photo']->source;
    } elseif (!is_valid_upload_source($_POST['photo'])) {
      _error(400);
    }
  }
}
/* filter comment voice_note */
if (isset($_POST['voice_note'])) {
  $_POST['voice_note'] = json_decode($_POST['voice_note']);
  if ($_POST['voice_note']) {
    if (is_object($_POST['voice_note'])) {
      if (!is_valid_upload_source($_POST['voice_note']->source ?? null)) {
        _error(400);
      }
      $_POST['voice_note'] = $_POST['voice_note']->source;
    } elseif (!is_valid_upload_source($_POST['voice_note'])) {
      _error(400);
    }
  }
}
/* filter comment gif */
$_POST['gif'] = $_POST['gif'] ?? '';
if ($_POST['gif'] && (!$user->_data['can_send_gifs'] || !valid_gif_url($_POST['gif']))) {
  _error(400);
}

try {

  // initialize the return array
  $return = [];

  // comment
  $comment = $user->comment($_POST['handle'], $_POST['id'], $_POST['message'], $_POST['photo'], $_POST['voice_note'], $_POST['gif']);
  /* assign variables */
  $smarty->assign('_is_reply', ($_POST['handle'] == "comment") ? true : false);
  $smarty->assign('_comment', $comment);
  /* return */
  $return['comment'] = $smarty->fetch("__feeds_comment.tpl");

  // return & exit
  return_json($return);
} catch (Exception $e) {
  modal("ERROR", __("Error"), $e->getMessage());
}
