<?php

/**
 * ajax -> posts -> blog
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
  $return['callback'] = 'window.location.replace(response.path);';

  switch ($_GET['do']) {
    case 'create':
      /* check blog cover & preview images */
      foreach (['cover', 'subscriptions_image', 'paid_image'] as $image) {
        if (!is_empty($_POST[$image]) && !is_valid_upload_source($_POST[$image])) {
          _error(400);
        }
      }
      // create blog
      $post_id = $user->post_blog($_POST['publish_to'], $_POST['page_id'], $_POST['group_id'], $_POST['event_id'], $_POST['title'], $_POST['text'], $_POST['cover'], $_POST['category'], $_POST['tags'], $_POST['references'], $_POST['tips_enabled'], $_POST['subscribers_only'], $_POST['paid_post'], $_POST['paid_post_price'], $_POST['paid_post_text'], $_POST['collaborative_post'], $_POST['collaborative_users'], $_POST['collaborative_percent'], $_POST['for_adult'], $_POST['subscriptions_image'], $_POST['paid_image'], $_POST['is_schedule'], $_POST['schedule_date']);

      // return
      $return['path'] = $system['system_url'] . '/blogs/' . $post_id . '/' . get_url_text($_POST['title']);
      break;

    case 'edit':
      // valid inputs
      if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
        _error(400);
      }
      /* check blog cover & preview images */
      foreach (['cover', 'subscriptions_image', 'paid_image'] as $image) {
        if (!is_empty($_POST[$image]) && !is_valid_upload_source($_POST[$image])) {
          _error(400);
        }
      }

      // edit blog
      $user->edit_blog($_GET['id'], $_POST['title'], $_POST['text'], $_POST['cover'], $_POST['category'], $_POST['tags'], $_POST['references'], $_POST['tips_enabled'], $_POST['subscribers_only'], $_POST['paid_post'], $_POST['paid_post_price'], $_POST['paid_post_text'], $_POST['for_adult'], $_POST['subscriptions_image'], $_POST['paid_image'], $_POST['is_schedule'], $_POST['schedule_date']);

      // return
      $return['path'] = $system['system_url'] . '/blogs/' . $_GET['id'] . '/' . get_url_text($_POST['title']);
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
