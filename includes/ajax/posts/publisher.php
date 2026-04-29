<?php

/**
 * ajax -> posts -> publisher
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

// check posts permission
if (!$user->_data['can_publish_posts']) {
  if (!$user->check_module_package_permission("posts_permission")) {
    return_json(["callback" => "window.location = '" . $system['system_url'] . "/packages?highlight=true';"]);
  } else {
    modal("MESSAGE", __("Error"), __("You don't have the permission to do this"));
  }
}

try {

  // initialize the return array
  $return = [];

  // prepare publisher
  $smarty->assign('feelings', get_feelings());
  $smarty->assign('feelings_types', get_feelings_types());
  if ($system['colored_posts_enabled']) {
    $smarty->assign('colored_patterns', $user->get_posts_colored_patterns());
  }
  if ($user->_data['can_upload_videos']) {
    $smarty->assign('videos_categories', $user->get_categories("posts_videos_categories"));
  }

  // get the publisher
  $return['publisher'] = $smarty->fetch("ajax.posts.publisher.tpl");
  $return['callback'] = "$('#modal').modal('show'); $('.modal-content:last').html(response.publisher);";


  // return & exit
  return_json($return);
} catch (Exception $e) {
  modal("ERROR", __("Error"), $e->getMessage());
}
