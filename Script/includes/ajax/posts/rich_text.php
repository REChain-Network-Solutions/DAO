<?php

/**
 * ajax -> posts -> rich_text
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

// check if rich text posts enabled
if (!$system['rich_text_posts_enabled']) {
  modal("MESSAGE", __("Error"), __("This feature has been disabled by the admin"));
}

// check rich text posts permission
if (!$user->_data['can_add_rich_text_posts']) {
  if ($user->check_module_package_permission("rich_text_posts_permission")) {
    return_json(["callback" => "window.location = '" . $system['system_url'] . "/packages?highlight=true';"]);
  } else {
    modal("MESSAGE", __("Error"), __("You don't have the permission to do this"));
  }
}

try {

  // initialize the return array
  $return = [];

  switch ($_REQUEST['do']) {
    case 'create':
      // valid inputs
      if (isset($_GET['page'])) {
        $share_to = "page";
        $share_to_id = (int) $_GET['page'];
      } elseif (isset($_GET['group'])) {
        $share_to = "group";
        $share_to_id = (int) $_GET['group'];
      } elseif (isset($_GET['event'])) {
        $share_to = "event";
        $share_to_id = (int) $_GET['event'];
      }

      // assign variables
      $smarty->assign('share_to', $share_to);
      $smarty->assign('share_to_id', $share_to_id);

      // return
      $return['template'] = $smarty->fetch("ajax.rich_text.publisher.tpl");
      $return['callback'] = "modal_content(response.template, true);";
      break;

    case 'publish':
      /* create rich text post */
      $post_id = $user->publish_rich_text_post($_POST['text'], $_POST['share_to'], $_POST['share_to_id']);

      // return
      $return['callback'] = "window.location = '" . $system['system_url'] . "/posts/" . $post_id . "';";
      break;

    case 'edit':
      // valid inputs
      if (!isset($_GET['post_id']) || !is_numeric($_GET['post_id'])) {
        _error(400);
      }

      // get rich text post
      $post = $user->get_post($_GET['post_id']);
      if (!$post || !$post['can_edit_post']) {
        _error(400);
      }

      // assign variables
      $smarty->assign('post', $post);

      // return
      $return['template'] = $smarty->fetch("ajax.rich_text.editor.tpl");
      $return['callback'] = "modal_content(response.template, true);";
      break;

    case 'update':
      // valid inputs
      if (!isset($_GET['post_id']) || !is_numeric($_GET['post_id'])) {
        _error(400);
      }

      // edit rich text post
      $user->update_rich_text_post($_GET['post_id'], $_POST['text']);

      // return
      $return['callback'] = "window.location = '" . $system['system_url'] . "/posts/" . $_GET['post_id'] . "';";
      break;

    default:
      _error(400);
      break;
  }

  // return & exit
  return_json($return);
} catch (Exception $e) {
  if (in_array($_REQUEST['do'], ['publish', 'update'])) {
    return_json(['error' => true, 'message' => $e->getMessage()]);
  } else {
    modal("ERROR", __("Error"), $e->getMessage());
  }
}
