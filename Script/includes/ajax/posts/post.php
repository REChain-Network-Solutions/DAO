<?php

/**
 * ajax -> posts -> post
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

  // valid inputs
  if (!in_array($_POST['handle'], ['me', 'user', 'page', 'group', 'event'])) {
    _error(400);
  }
  $_POST = $user->normalize_publisher_attachments($_POST);
  $photos = $_POST['photos'];
  $photo_layout = $_POST['photo_layout'];
  $options = $_POST['poll_options'];

  // initialize the return array
  $return = $inputs = [];

  // publisher
  /* check permissions */
  /* check colored posts permission */
  if (!$user->_data['can_add_colored_posts'] && isset($_POST['colored_pattern'])) {
    throw new ValidationException(__("You don't have the permission to add colored posts"));
  }
  /* check activity posts permission */
  if (!$user->_data['can_add_activity_posts'] && isset($_POST['feeling_action'])) {
    throw new ValidationException(__("You don't have the permission to add activity posts"));
  }
  /* check poll posts permission */
  if (!$user->_data['can_add_polls_posts'] && isset($options)) {
    throw new ValidationException(__("You don't have the permission to add polls posts"));
  }
  /* check geolocation posts permission */
  if (!$user->_data['can_add_geolocation_posts'] && isset($_POST['location']) && !empty($_POST['location'])) {
    throw new ValidationException(__("You don't have the permission to add geolocation posts"));
  }
  /* check scheduled posts permission */
  if (!$user->_data['can_schedule_posts'] && $_POST['is_schedule'] == "true") {
    throw new ValidationException(__("You don't have the permission to add scheduled posts"));
  }
  /* check anonymous posts permission */
  if (!$user->_data['can_add_anonymous_posts'] && $_POST['is_anonymous'] == "true") {
    throw new ValidationException(__("You don't have the permission to add anonymous posts"));
  }
  /* check adult posts permission */
  if ($system['verification_for_adult_content'] && !$user->_data['user_verified'] && $_POST['for_adult'] == "true") {
    throw new ValidationException(__("Your account must be verified to share adult content"));
  }
  /* check tips permission */
  if (!$user->_data['can_receive_tip'] && $_POST['tips_enabled'] == "true") {
    throw new ValidationException(__("You don't have the permission to enable tips"));
  }
  /* check paid posts permission */
  if (!$user->_data['can_monetize_content'] && !$user->_data['user_monetization_enabled'] && $_POST['is_paid'] == "true") {
    throw new ValidationException(__("You don't have the permission to add paid posts"));
  }
  /* valid inputs */
  switch ($_POST['handle']) {
    case 'page':
      if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
        _error(400);
      }
      $inputs['id'] = $_POST['id'];
      $inputs['privacy'] = 'public';
      $_get = 'posts_page';
      break;

    case 'group':
      if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
        _error(400);
      }
      $inputs['id'] = $_POST['id'];
      $inputs['privacy'] = 'custom';
      $_get = 'posts_group';
      break;

    case 'event':
      if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
        _error(400);
      }
      $inputs['id'] = $_POST['id'];
      $inputs['privacy'] = 'custom';
      $_get = 'posts_event';
      break;

    case 'user':
      if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
        _error(400);
      }
      $inputs['id'] = $_POST['id'];
      /* if privacy set and not valid */
      $_POST['privacy'] = ($system['newsfeed_source'] == "all_posts") ? "public" : $_POST['privacy'];
      if (!isset($_POST['privacy']) || !in_array($_POST['privacy'], ['friends', 'public'])) {
        _error(400);
      }
      $inputs['privacy'] = $_POST['privacy'];
      $_get = 'posts_profile';
      break;

    default:
      /* if privacy set and not valid */
      $_POST['privacy'] = ($system['newsfeed_source'] == "all_posts") ? "public" : $_POST['privacy'];
      if (!isset($_POST['privacy']) || !in_array($_POST['privacy'], ['me', 'friends', 'public'])) {
        _error(400);
      }
      $inputs['privacy'] = $_POST['privacy'];
      $_get = 'newfeed';
      break;
  }
  /* check is_schedule */
  $inputs['is_schedule'] = ($_POST['is_schedule'] == "true") ? '1' : '0';
  if ($inputs['is_schedule']) {
    $inputs['schedule_date'] = $_POST['schedule_date'];
    if (empty($inputs['schedule_date']) || strtotime($inputs['schedule_date']) < time()) {
      throw new ValidationException(__("Select a valid date and time for your scheduled post"));
    }
  }
  /* check is_anonymous */
  $inputs['is_anonymous'] = ($_POST['handle'] == 'me' && $_POST['is_anonymous'] == "true") ? '1' : '0';
  if ($inputs['is_anonymous']) {
    $_POST['album'] = "";
    $inputs['privacy'] = 'public';
  }
  /* check for_adult */
  $inputs['for_adult'] = ($_POST['for_adult'] == "true") ? '1' : '0';
  /* check tips_enabled */
  $inputs['tips_enabled'] = ($_POST['handle'] != 'page' && $_POST['tips_enabled'] == "true") ? '1' : '0';
  /* check for_subscriptions */
  $inputs['for_subscriptions'] = ($_POST['handle'] != 'user' && $_POST['for_subscriptions'] == "true") ? '1' : '0';
  if ($inputs['for_subscriptions']) {
    if ($_POST['subscriptions_image']) {
      $inputs['subscriptions_image'] = $_POST['subscriptions_image'];
    }
  }
  /* check is_paid */
  $inputs['is_paid'] = ($_POST['handle'] != 'user' && $_POST['is_paid'] == "true") ? '1' : '0';
  if ($inputs['is_paid']) {
    $inputs['is_paid_locked'] = ($_POST['is_paid_locked'] == "true") ? '1' : '0';
    if ($inputs['is_paid_locked'] && empty($_POST['file'])) {
      throw new ValidationException(__("You can not lock paid post without attached file"));
    }
    $inputs['post_price'] = $_POST['post_price'];
    if (!is_numeric($inputs['post_price']) || $inputs['post_price'] <= 0) {
      throw new ValidationException(__("Please enter a valid price"));
    }
    if ($system['monetization_max_paid_post_price'] > 0 && $inputs['post_price'] > $system['monetization_max_paid_post_price']) {
      throw new ValidationException(__("The price must be less than or equal to") . " " . print_money($system['monetization_max_paid_post_price']));
    }
    $inputs['paid_text'] = $_POST['paid_text'];
    if (strlen($inputs['paid_text']) > 1000) {
      throw new ValidationException(__("Paid content description is more than 1000 characters"));
    }
    if ($_POST['paid_image']) {
      $inputs['paid_image'] = $_POST['paid_image'];
    }
  }
  /* check is_collaborative */
  $inputs['is_collaborative'] = ($_POST['is_collaborative'] == "true") ? '1' : '0';
  if ($inputs['is_collaborative']) {
    /* check if anonymous post */
    if ($inputs['is_anonymous']) {
      throw new ValidationException(__("You can not collaborate with anonymous post"));
    }
    /* check if for_subscriptions post */
    if ($inputs['for_subscriptions']) {
      throw new ValidationException(__("You can not collaborate with for subscriptions post"));
    }
    /* validate collaborative users */
    $inputs['collaborative_users'] = $_POST['collaborative_users'];
    $inputs['collaborative_users_ids'] = $user->validate_collaborative_users($inputs['collaborative_users']);
    /* check if paid post */
    if ($inputs['is_paid']) {
      /* check if collaborative percent is valid */
      $inputs['collaborative_percent'] = $_POST['collaborative_percent'];
      if (!is_numeric($inputs['collaborative_percent']) || $inputs['collaborative_percent'] < 0 || $inputs['collaborative_percent'] > 100) {
        throw new ValidationException(__("Please enter a valid percentage"));
      }
    }
  }
  /* prepare inputs */
  $inputs['handle'] = $_POST['handle'];
  $inputs['message'] = $_POST['message'];
  $inputs['link'] = $_POST['link'];
  $inputs['photos'] = $photos;
  $inputs['photo_layout'] = $photo_layout;
  $inputs['album'] = $_POST['album'];
  $inputs['feeling_action'] = $_POST['feeling_action'];
  $inputs['feeling_value'] = $_POST['feeling_value'];
  $inputs['location'] = $_POST['location'];
  $inputs['latitude'] = $_POST['latitude'] ?? '';
  $inputs['longitude'] = $_POST['longitude'] ?? '';
  $inputs['colored_pattern'] = $_POST['colored_pattern'];
  $inputs['poll_options'] = $options;
  $inputs['reel'] = $_POST['reel'];
  $inputs['reel_thumbnail'] = $_POST['reel_thumbnail'];
  $inputs['video'] = $_POST['video'];
  $inputs['video_thumbnail'] = $_POST['video_thumbnail'];
  $inputs['video_category'] = $_POST['video_category'];
  $inputs['audio'] = ($_POST['voice_notes']) ? $_POST['voice_notes'] : $_POST['audio'];
  $inputs['file'] = $_POST['file'];
  $inputs['post_as_page'] = $_POST['post_as_page'];
  /* publish */
  $post = $user->publisher($inputs);

  /* check if approval required */
  if ($post['has_approved'] == '0') {
    /* check if post is (reel|video) && ffmpeg enabled */
    if ($system['ffmpeg_enabled'] && ($post['reel']['source'] || $post['video']['source'])) {
      // [BACKGROUND PROCESS]
      /* return async */
      return_json_async(['approval' => true]);
      /* start ffmpeg converting */
      if ($post['reel']['source']) {
        ffmpeg_convert($post['post_id'], $post['author_id'], $post['reel']['source'], $post['reel']['thumbnail'], 'reel');
      }
      if ($post['video']['source']) {
        ffmpeg_convert($post['post_id'], $post['author_id'], $post['video']['source'], $post['video']['thumbnail'], 'video');
      }
    } else {
      // return & exit
      return_json(['approval' => true]);
    }
  } else {
    /* check if post is (reel|video) && ffmpeg enabled */
    if ($system['ffmpeg_enabled'] && ($post['reel']['source'] || $post['video']['source'])) {
      // [BACKGROUND PROCESS]
      /* return async */
      return_json_async(['processing' => true]);
      /* start ffmpeg converting */
      if ($post['reel']['source']) {
        ffmpeg_convert($post['post_id'], $post['author_id'], $post['reel']['source'], $post['reel']['thumbnail'], 'reel');
      }
      if ($post['video']['source']) {
        ffmpeg_convert($post['post_id'], $post['author_id'], $post['video']['source'], $post['video']['thumbnail'], 'video');
      }
      // return & exit
      return_json(['processing' => true]);
    } else {
      /* get the published post */
      $smarty->assign('post', $user->get_post($post['post_id'], false, true, true));
      $smarty->assign('_get', $_get);
      /* return */
      $return['post_id'] = $post['post_id'];
      $return['post'] = $smarty->fetch("__feeds_post.tpl");
      // return & exit
      return_json($return);
    }
  }
} catch (ValidationException $e) {
  return_json(['callback' => 'error.html("' . $e->getMessage() . '").slideDown();']);
} catch (Exception $e) {
  modal("ERROR", __("Error"), $e->getMessage());
}
