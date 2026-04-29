<?php

/**
 * ajax -> ai -> generate
 * 
 * @package Sngine
 * @author Zamblek
 */

// set max execution time
set_time_limit(0); /* unlimited max execution time */

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

  switch ($_POST['handle']) {
    case 'post':
      // check ai posts permission
      if (!$user->_data['can_generate_ai_posts']) {
        if (!$user->check_module_package_permission("ai_posts_permission")) {
          return_json(["callback" => "window.location = '" . $system['system_url'] . "/packages?highlight=true';"]);
        } else {
          modal("MESSAGE", __("Error"), __("You don't have the permission to do this"));
        }
      }

      // generate text
      $response = $user->generate_ai_text($_POST['prompt'], $_POST['max_result_length']);
      return_json([
        'success' => true,
        'generated_text' => $response['generated_text'],
        'ai_credits' => $response['ai_credits'],
        'words_balance' => $response['words_balance'],
      ]);
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

      // generate text
      $response = $user->generate_ai_text($_POST['prompt'], $_POST['max_result_length'], true);
      return_json([
        'success' => true,
        'generated_title' => $response['generated_title'],
        'generated_text' => $response['generated_text'],
        'ai_credits' => $response['ai_credits'],
        'words_balance' => $response['words_balance'],
      ]);
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

      // generate image
      $response = $user->generate_ai_image($_POST['prompt'], $_POST['image_size']);
      return_json([
        'success' => true,
        'generated_image' => $response['generated_image'],
        'ai_credits' => $response['ai_credits'],
        'images_balance' => $response['images_balance'],
      ]);
      break;

    default:
      _error(400);
      break;
  }

  // return & exit
  return_json($return);
} catch (Exception $e) {
  return_json(['error' => true, 'message' => $e->getMessage()]);
}
