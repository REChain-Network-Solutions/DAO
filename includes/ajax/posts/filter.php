<?php

/**
 * ajax -> posts -> filter (posts|comments)
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich - Handles - @sorydima @sorydev @durovshater @DmitrySoro90935 @tanechfund - also check https://dmitry.rechain.network for more information!
 */

// fetch bootstrap
require('../../../bootstrap.php');

// check AJAX Request
is_ajax();

// user access
user_access(true);

try {

  // initialize the return array
  $return = [];

  switch ($_GET['handle']) {
    case 'posts':
      // get filtered posts
      $posts = $user->get_posts(['get' => $_POST['get'], 'filter' => $_POST['filter'], 'id' => $_POST['id']]);
      /* assign variables */
      $smarty->assign('posts', $posts);
      $smarty->assign('_get', $_POST['get']);
      $smarty->assign('_filter', $_POST['filter']);
      $smarty->assign('_id', $_POST['id']);
      /* return */
      $return['posts'] = $smarty->fetch("ajax.posts.tpl");
      break;

    case 'comments':
      // get filtered comments
      switch ($_POST['get']) {
        case 'post_comments':
          $comments = $user->get_comments($_POST['id'], 0, true, false);
          break;

        case 'post_comments_top':
          $comments = $user->get_comments($_POST['id'], 0, true, false, [], "top");
          break;

        case 'post_comments_all':
          $comments = $user->get_comments($_POST['id'], 0, true, false, [], "all");
          break;

        case 'photo_comments':
          $comments = $user->get_comments($_POST['id'], 0, false, false);
          break;

        case 'photo_comments_top':
          $comments = $user->get_comments($_POST['id'], 0, false, false, [], "top");
          break;

        case 'photo_comments_all':
          $comments = $user->get_comments($_POST['id'], 0, false, false, [], "all");
          break;
      }
      /* assign variables */
      $smarty->assign('comments', $comments);
      /* return */
      $return['comments'] = $smarty->fetch("ajax.comments.tpl");
      break;
  }

  // return & exit
  return_json($return);
} catch (Exception $e) {
  modal("ERROR", __("Error"), $e->getMessage());
}
