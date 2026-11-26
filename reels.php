<?php

/**
 * reels
 * 
 * @package Sngine
 * @author Zamblek
 */

// fetch bootloader
require('bootloader.php');

// reels enabled
if (!$system['reels_enabled']) {
  _error(404);
}

// user access
if (!$system['system_public']) {
  user_access();
}

try {

  // get tab
  $tab = (($_GET['tab'] ?? '') == 'following' && $user->_logged_in) ? 'following' : 'for_you';
  /* assign variables */
  $smarty->assign('tab', $tab);

  // get view content
  switch ($_GET['view']) {
    case '':

      // get posts (reels)
      $posts = $user->get_reels_feed(['tab' => $tab]);
      /* assign variables */
      $smarty->assign('posts', $posts);
      $smarty->assign('cursor', $user->_cursor);
      $smarty->assign('pinned', '');

      // page header
      page_header(__("Reels") . ' | ' . __($system['system_title']));
      break;

    case 'reel':
      // get post
      $post = $user->get_post($_GET['post_id'], false, false, true);
      if (!$post || $post['post_type'] != "reel" || !$post['reel']) {
        _error(404);
      }
      /* check locked post */
      if ($user->reel_locked($post)) {
        redirect('/posts/' . $post['post_id']);
      }
      /* assign variables */
      $smarty->assign('post', $post);

      // get posts (reels)
      $posts = $user->get_reels_feed(['tab' => $tab, 'exclude' => $post['post_id']]);
      /* add the post to the beginning of the array */
      array_unshift($posts, $post);
      /* assign variables */
      $smarty->assign('posts', $posts);
      $smarty->assign('cursor', $user->_cursor);
      $smarty->assign('pinned', $post['post_id']);

      // page header
      page_header($post['og_title'], $post['og_description'], $post['og_image']);
      break;

    default:
      _error(404);
      break;
  }
} catch (Exception $e) {
  _error(__("Error"), $e->getMessage());
}

// page footer
page_footer('reels');
