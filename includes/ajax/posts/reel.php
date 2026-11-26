<?php

/**
 * ajax -> posts -> reel
 * 
 * @package Sngine
 * @author Zamblek
 */

// fetch bootstrap
require('../../../bootstrap.php');

// check AJAX Request
is_ajax();

// reels enabled
if (!$system['reels_enabled']) {
  _error(404);
}

// user access
if (!$system['system_public']) {
  user_access(true);
}

// valid inputs
if (!isset($_POST['post_id']) || !is_numeric($_POST['post_id'])) {
  _error(400);
}

try {

  // initialize the return array
  $return = [];

  switch ($_POST['do']) {
    case 'comments':
      // get post
      $post = $user->get_post($_POST['post_id'], true, false, true);
      if (!$post || $post['post_type'] != "reel" || !$post['reel'] || $user->reel_locked($post)) {
        _error(400);
      }
      /* assign variables */
      $smarty->assign('post', $post);
      /* return */
      $return['comments'] = $smarty->fetch("ajax.reel-comments.tpl");
      $return['count'] = $post['comments_formatted'];
      break;

    case 'view':
      // get post
      $post = $user->get_post($_POST['post_id'], false);
      if (!$post || $post['post_type'] != "reel" || !$post['reel'] || $user->reel_locked($post)) {
        _error(400);
      }
      // update media views (reel)
      $user->count_reel_view($post);
      break;

    default:
      _error(400);
      break;
  }

  // return & exit
  return_json($return);
} catch (Exception $e) {
  modal("ERROR", __("Error"), $e->getMessage());
}
