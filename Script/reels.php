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

  // get view content
  switch ($_GET['view']) {
    case '':

      // get posts (reels)
      /* first get the reels from discover */
      $reels_discover = ($user->_logged_in) ? $user->get_posts(['get' => 'discover', 'filter' => 'reel']) : [];
      /* second get the reels from newsfeed */
      $reels_newsfeed = $user->get_posts(['get' => 'newsfeed', 'filter' => 'reel']);
      /* merge the two arrays */
      $posts = array_merge($reels_discover, $reels_newsfeed);
      /* randomize the array */
      shuffle($posts);
      /* assign variables */
      $smarty->assign('posts', $posts);

      // page header
      page_header(__("Reels") . ' | ' . __($system['system_title']));
      break;

    case 'reel':
      // get post
      $post = $user->get_post($_GET['post_id']);
      if (!$post || $post['post_type'] != "reel") {
        _error(404);
      }
      /* assign variables */
      $smarty->assign('post', $post);

      // get posts (reels)
      /* first get the reels from discover */
      $reels_discover = ($user->_logged_in) ? $user->get_posts(['get' => 'discover', 'filter' => 'reel']) : [];
      /* second get the reels from newsfeed */
      $reels_newsfeed = $user->get_posts(['get' => 'newsfeed', 'filter' => 'reel']);
      /* merge the two arrays */
      $posts = array_merge($reels_discover, $reels_newsfeed);
      /* randomize the array */
      shuffle($posts);
      /* remove the post from the array if exists */
      foreach ($posts as $key => $value) {
        if ($value['post_id'] == $post['post_id']) {
          unset($posts[$key]);
        }
      }
      /* add the post to the beginning of the array */
      array_unshift($posts, $post);
      /* assign variables */
      $smarty->assign('posts', $posts);

      // page header
      page_header($post['og_title'], $post['og_description'], $post['og_image']);
      break;
  }
} catch (Exception $e) {
  _error(__("Error"), $e->getMessage());
}

// page footer
page_footer('reels');
