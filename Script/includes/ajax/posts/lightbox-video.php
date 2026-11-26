<?php

/**
 * ajax -> posts -> lightbox-video
 * 
 * @package Sngine
 * @author Zamblek
 */

// fetch bootstrap
require('../../../bootstrap.php');

// check AJAX Request
is_ajax();

// valid inputs
if (!isset($_POST['post_id']) || !is_numeric($_POST['post_id'])) {
  _error(400);
}

try {

  // initialize the return array
  $return = [];

  // get post
  $post = $user->get_post($_POST['post_id'], true, true);
  if (!$post || !$post['video']) {
    _error(400);
  }

  // check locked post
  if (!$post['can_get_details'] || $post['needs_payment'] || $post['needs_subscription'] || $post['needs_pro_package'] || $post['needs_age_verification']) {
    $return['callback'] = "window.location = '" . $system['system_url'] . "/posts/" . $post['post_id'] . "';";
    return_json($return);
  }
  /* assign variables */
  $smarty->assign('post', $post);
  /* return */
  $return['player'] = $smarty->fetch("__video_player.tpl");
  $return['download'] = $system['system_url'] . '/downloads.php?type=video&id=' . $post['post_id'];
  $return['lightbox'] = $smarty->fetch("ajax.lightbox-video.tpl");

  // return & exit
  return_json($return);
} catch (Exception $e) {
  modal("ERROR", __("Error"), $e->getMessage());
}
