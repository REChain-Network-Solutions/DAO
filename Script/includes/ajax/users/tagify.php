<?php

/**
 * ajax -> users -> tagify
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

// check demo account
if ($user->_data['user_demo']) {
  modal("ERROR", __("Demo Restriction"), __("You can't do this with demo account"));
}

// handle tagify
try {

  // initialize the return array
  $return = [];

  switch ($_POST['handle']) {
    case 'users':
      /* get users */
      $get_users = $db->query(sprintf('SELECT user_id, user_firstname, user_lastname FROM users WHERE user_id != %s AND (user_name LIKE %2$s OR user_firstname LIKE %2$s OR user_lastname LIKE %2$s OR CONCAT(user_firstname,  " ", user_lastname) LIKE %2$s) ORDER BY user_firstname ASC LIMIT %3$s', secure($user->_data['user_id'], 'int'), secure($_POST['query'], 'search'), secure($system['min_results'], 'int', false)));
      if ($get_users->num_rows > 0) {
        while ($_user = $get_users->fetch_assoc()) {
          $result['value'] = html_entity_decode(trim($_user['user_firstname']) . " " . trim($_user['user_lastname']));
          $result['id'] = $_user['user_id'];
          $list[] = $result;
        }
        $return['list'] = json_encode($list);
      }
      break;

    case 'video_categories':
      /* get video categories */
      $get_video_categories = $db->query(sprintf('SELECT category_id, category_name FROM posts_videos_categories WHERE category_name LIKE %1$s ORDER BY category_name ASC LIMIT %2$s', secure($_POST['query'], 'search'), secure($system['min_results'], 'int', false)));
      if ($get_video_categories->num_rows > 0) {
        while ($_category = $get_video_categories->fetch_assoc()) {
          $result['value'] = html_entity_decode($_category['category_name']);
          $result['id'] = $_category['category_id'];
          $list[] = $result;
        }
        $return['list'] = json_encode($list);
      }
      break;

    case 'blogs_categories':
      /* get blogs categories */
      $get_blogs_categories = $db->query(sprintf('SELECT category_id, category_name FROM blogs_categories WHERE category_name LIKE %1$s ORDER BY category_name ASC LIMIT %2$s', secure($_POST['query'], 'search'), secure($system['min_results'], 'int', false)));
      if ($get_blogs_categories->num_rows > 0) {
        while ($_category = $get_blogs_categories->fetch_assoc()) {
          $result['value'] = html_entity_decode($_category['category_name']);
          $result['id'] = $_category['category_id'];
          $list[] = $result;
        }
        $return['list'] = json_encode($list);
      }
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
