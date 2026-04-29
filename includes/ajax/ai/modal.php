<?php

/**
 * ajax -> ai -> modal
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

try {

  // initialize the return array
  $return = [];

  // get modal
  switch ($_GET['handle']) {
    case 'post':
      // check ai posts permission
      if (!$user->_data['can_generate_ai_posts']) {
        if (!$user->check_module_package_permission("ai_posts_permission")) {
          return_json(["callback" => "window.location = '" . $system['system_url'] . "/packages?highlight=true';"]);
        } else {
          modal("MESSAGE", __("Error"), __("You don't have the permission to do this"));
        }
      }

      // return
      $return['template'] = $smarty->fetch("ajax.ai.post.tpl");
      $return['callback'] = "$('#modal').modal('show'); $('.modal-content:last').html(response.template);";
      break;

    case 'blog':
      // check ai blogs permission
      if (!$user->_data['can_generate_ai_blogs']) {
        if (!$user->check_module_package_permission("ai_blogs_permission")) {
          return_json(["callback" => "window.location = '" . $system['system_url'] . "/packages?highlight=true';"]);
        } else {
          modal("MESSAGE", __("Error"), __("You don't have the permission to do this"));
        }
      }

      // return
      $return['template'] = $smarty->fetch("ajax.ai.blog.tpl");
      $return['callback'] = "$('#modal').modal('show'); $('.modal-content:last').html(response.template);";
      break;

    case 'image':
      // check ai images permission
      if (!$user->_data['can_generate_ai_images']) {
        if (!$user->check_module_package_permission("ai_images_permission")) {
          return_json(["callback" => "window.location = '" . $system['system_url'] . "/packages?highlight=true';"]);
        } else {
          modal("MESSAGE", __("Error"), __("You don't have the permission to do this"));
        }
      }

      // return
      $return['template'] = $smarty->fetch("ajax.ai.image.tpl");
      $return['callback'] = "$('#modal').modal('show'); $('.modal-content:last').html(response.template);";
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
