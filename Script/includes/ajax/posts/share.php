<?php

/**
 * ajax -> posts -> share
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

// valid inputs
if (!isset($_GET['post_id']) || !is_numeric($_GET['post_id'])) {
  _error(400);
}

try {

  // initialize the return array
  $return = [];

  switch ($_REQUEST['do']) {
    case 'publish':
      // publish
      $user->share($_GET['post_id'], $_POST);

      // return
      modal("SUCCESS", __("Success"),  __("This has been shared Successfully"));
      break;

    case 'create':
      // prepare publisher
      /* get post */
      $post = $user->get_post($_GET['post_id']);
      if (!$post) {
        _error(404);
      }
      /* check if photo id exists */
      if (isset($_GET['photo_id']) && is_numeric($_GET['photo_id'])) {
        $photo = $user->get_photo($_GET['photo_id']);
        if (!$photo) {
          _error(404);
        }
        $smarty->assign('photo', $photo);
      }
      /* prepare post share link */
      $post['share_link'] = $system['system_url'] . '/posts/' . $post['post_id'];
      if ($post['reel']) {
        $post['share_link'] = $system['system_url'] . '/reels/' . $post['post_id'];
      }
      /* check if post is a video and post is public */
      if ($system['video_embed_code_enabled'] && $post['post_type'] == 'video' && $post['privacy'] == 'public') {
        /* prepare embed video link */
        $post['embedded_video_link'] = $system['system_url'] . '/embed/' . $post['post_id'];
        $post['embedded_video_iframe'] = sprintf(
          '<iframe src="%s" width="560" height="315" frameborder="0" allowfullscreen allow="autoplay; encrypted-media; picture-in-picture"></iframe>',
          $post['embedded_video_link']
        );
      }

      $smarty->assign('post', $post);
      /* get user pages */
      $pages = $user->get_pages(['get_all' => true, 'managed' => true, 'user_id' => $user->_data['user_id']]);
      $smarty->assign('pages', $pages);
      /* get user groups */
      $groups = $user->get_groups(['get_all' => true, 'user_id' => $user->_data['user_id']]);
      $smarty->assign('groups', $groups);
      /* get user events */
      $events = $user->get_events(['get_all' => true, 'user_id' => $user->_data['user_id']]);
      $smarty->assign('events', $events);

      // return
      $return['share_publisher'] = $smarty->fetch("ajax.share.publisher.tpl");
      $return['callback'] = "modal_content(response.share_publisher, true);";
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
