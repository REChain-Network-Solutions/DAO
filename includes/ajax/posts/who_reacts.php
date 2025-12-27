<?php

/**
 * ajax -> posts -> who reacts
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
/* if post_id & photo_id & comment_id & message_id not set */
if (!isset($_GET['post_id']) && !isset($_GET['photo_id']) && !isset($_GET['comment_id']) && !isset($_GET['message_id'])) {
  _error(400);
}
/* if post_id set but not numeric */
if (isset($_GET['post_id']) && !is_numeric($_GET['post_id'])) {
  _error(400);
}
/* if photo_id set but not numeric */
if (isset($_GET['photo_id']) && !is_numeric($_GET['photo_id'])) {
  _error(400);
}
/* if comment_id set but not numeric */
if (isset($_GET['comment_id']) && !is_numeric($_GET['comment_id'])) {
  _error(400);
}
/* if message_id set but not numeric */
if (isset($_GET['message_id']) && !is_numeric($_GET['message_id'])) {
  _error(400);
}

try {

  // initialize the return array
  $return = [];

  // check reaction_type
  $reaction_type = !isset($_GET['reaction_type']) ? "all" : $_GET['reaction_type'];
  if (!in_array($reaction_type, ['all', 'like', 'love', 'haha', 'yay', 'wow', 'sad', 'angry'])) {
    _error(400);
  }

  // get users who
  if (isset($_GET['post_id'])) {
    /* reacted to this post */
    $users = $user->who_reacts(['post_id' => $_GET['post_id'], 'reaction_type' => $reaction_type])['data'];
    $handle = "post";
    $get = 'post_id';
    $id = $_GET['post_id'];
  } elseif (isset($_GET['photo_id'])) {
    /* reacted to this photo */
    $users = $user->who_reacts(['photo_id' => $_GET['photo_id'], 'reaction_type' => $reaction_type])['data'];
    $handle = "photo";
    $get = 'photo_id';
    $id = $_GET['photo_id'];
  } elseif (isset($_GET['comment_id'])) {
    /* reacted to this comment */
    $users = $user->who_reacts(['comment_id' => $_GET['comment_id'], 'reaction_type' => $reaction_type])['data'];
    $handle = "comment";
    $get = 'comment_id';
    $id = $_GET['comment_id'];
  } elseif (isset($_GET['message_id'])) {
    /* reacted to this message */
    $users = $user->who_reacts(['message_id' => $_GET['message_id'], 'reaction_type' => $reaction_type])['data'];
    $handle = "message";
    $get = 'message_id';
    $id = $_GET['message_id'];
  } else {
    _error(400);
  }
  /* assign variables */
  $smarty->assign('reaction_type', $reaction_type);
  $smarty->assign('users', $users);
  $smarty->assign('handle', $handle);
  $smarty->assign('get', $get);
  $smarty->assign('id', $id);
  /* return */
  $return['template'] = $smarty->fetch("ajax.who_reacts.tpl");
  $return['callback'] = "$('#modal').modal('show'); $('.modal-content:last').html(response.template);";

  // return & exit
  return_json($return);
} catch (Exception $e) {
  modal("ERROR", __("Error"), $e->getMessage());
}
