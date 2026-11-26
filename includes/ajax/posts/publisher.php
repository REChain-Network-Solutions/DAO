<?php

/**
 * ajax -> posts -> publisher
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

// check posts permission
if (($_GET['do'] ?? '') != 'edit' && !$user->_data['can_publish_posts']) {
  if ($user->check_module_package_permission("posts_permission")) {
    return_json(["callback" => "window.location = '" . $system['system_url'] . "/packages?highlight=true';"]);
  } else {
    modal("MESSAGE", __("Error"), __("You don't have the permission to do this"));
  }
}

try {

  // initialize the return array
  $return = [];

  if (($_GET['do'] ?? '') == 'edit') {
    $editor = $user->get_post_editor($_GET['post_id'] ?? null);
    $post = $editor['context'];
    $handle = $editor['in_group'] ? 'group' : ($editor['in_event'] ? 'event' : ($editor['user_type'] == 'page' ? 'page' : ($editor['in_wall'] ? 'user' : 'me')));
    $node = [
      'handle' => $handle,
      'id' => $handle == 'group' ? $editor['group_id'] : ($handle == 'event' ? $editor['event_id'] : ($handle == 'page' ? $editor['user_id'] : $editor['wall_id'])),
      'name' => $editor['is_anonymous'] ? __("Anonymous") : $post['post_author_name'],
      'avatar' => $post['post_author_picture'],
      'target' => $editor['in_group'] ? $post['group_title'] : ($editor['in_event'] ? $post['event_title'] : null),
      'privacy' => in_array($handle, ['me', 'user']) && !$editor['is_anonymous'],
      'post_as_page' => false,
      'page_id' => null,
      'can_monetize_content' => $user->post_editor_can_subscribe($post),
      'monetization_enabled' => $user->post_editor_can_subscribe($post),
      'monetization_plans' => $user->post_editor_can_subscribe($post) ? 1 : 0,
    ];
    $editor['collaborative_users'] = array_map(function ($person) {
      return ['id' => $person['user_id'], 'value' => html_entity_decode($person['user_fullname'], ENT_QUOTES, 'UTF-8')];
    }, $user->get_collaborative_users($editor['post_id']));
    $editor['collaborative_json'] = json_encode($editor['collaborative_users']);
    unset($editor['context']);
    $smarty->assign('publisher_edit', $editor);
    $smarty->assign('publisher_node', $node);
    $smarty->assign('publisher_mode', null);
    $smarty->assign('feelings', get_feelings());
    $smarty->assign('feelings_types', get_feelings_types());
    $smarty->assign('colored_patterns', $user->get_posts_colored_patterns());
    $smarty->assign('videos_categories', $user->get_categories('posts_videos_categories'));
    $return['editor'] = $editor;
    $return['publisher'] = $smarty->fetch('ajax.posts.publisher.tpl');
    $return['callback'] = "if ($('#publisher-wapper').length && !$('#publisher-wapper').data('publisher-detached')) { $('#publisher-wapper').data('publisher-detached', $('#publisher-wapper').contents().detach()); } modal_content(response.publisher, true); quill_publisher(); publisher_edit_load($('#publisher-wapper-modal .publisher'), response.editor);";
    return_json($return);
  }

  // prepare publisher mode
  $publisher_mode = $_GET['mode'] ?? null;
  if (!is_string($publisher_mode) || !in_array($publisher_mode, ['photos', 'video', 'feelings', 'location'], true)) {
    $publisher_mode = null;
  }

  // prepare publisher node
  $publisher_handle = $_GET['handle'] ?? 'me';
  if (!is_string($publisher_handle) || !in_array($publisher_handle, ['me', 'user', 'page', 'group', 'event'], true)) {
    _error(400);
  }
  $publisher_node = [
    'handle' => $publisher_handle,
    'id' => null,
    'name' => $user->_data['user_fullname'],
    'avatar' => $user->_data['user_picture'],
    'target' => null,
    'privacy' => false,
    'post_as_page' => false,
    'page_id' => null,
    'can_monetize_content' => false,
    'monetization_enabled' => false,
    'monetization_plans' => 0,
  ];
  switch ($publisher_handle) {
    case 'me':
      $publisher_node['privacy'] = true;
      $publisher_node['can_monetize_content'] = $user->_data['can_monetize_content'];
      $publisher_node['monetization_enabled'] = $user->_data['user_monetization_enabled'];
      $publisher_node['monetization_plans'] = $user->_data['user_monetization_plans'];
      break;

    case 'user':
      if (!$system['wall_posts_enabled']) {
        modal("MESSAGE", __("Error"), __("Wall posts are disabled"));
      }
      $wall_user = $user->get_user($_GET['id'] ?? 0, false);
      if (!$wall_user || $wall_user['user_id'] == $user->_data['user_id']) {
        _error(400);
      }
      $wall_privacy = $db->query(sprintf("SELECT user_privacy_wall FROM users WHERE user_id = %s", secure($wall_user['user_id'], 'int')))->fetch_assoc()['user_privacy_wall'];
      if ($wall_privacy == 'me' || ($wall_privacy == 'friends' && !$user->friendship_approved($wall_user['user_id']))) {
        modal("MESSAGE", __("Error"), __("You cannot post on this user's wall"));
      }
      $publisher_node['id'] = $wall_user['user_id'];
      $publisher_node['target'] = $wall_user['user_fullname'];
      $publisher_node['privacy'] = true;
      break;

    case 'page':
      $page = $user->get_page($_GET['id'] ?? 0);
      if (!$page || !$user->check_page_adminship($user->_data['user_id'], $page['page_id'])) {
        _error(400);
      }
      $publisher_node['id'] = $page['page_id'];
      $publisher_node['name'] = $page['page_title'];
      $publisher_node['avatar'] = get_picture($page['page_picture'], 'page');
      $publisher_node['can_monetize_content'] = $system['monetization_enabled'] && $user->check_user_permission($page['page_admin'], 'monetization_permission');
      $publisher_node['monetization_enabled'] = $page['page_monetization_enabled'];
      $publisher_node['monetization_plans'] = $page['page_monetization_plans'];
      break;

    case 'group':
      $group = $user->get_group($_GET['id'] ?? 0);
      if (!$group || $user->check_group_membership($user->_data['user_id'], $group['group_id']) != "approved") {
        _error(400);
      }
      if (!$group['group_publish_enabled'] && !$user->check_group_adminship($user->_data['user_id'], $group['group_id'])) {
        modal("MESSAGE", __("Error"), __("Publishing to this group has been disabled by group admins"));
      }
      $publisher_node['id'] = $group['group_id'];
      $publisher_node['target'] = $group['group_title'];
      $publisher_node['can_monetize_content'] = $system['monetization_enabled'] && $user->check_user_permission($group['group_admin'], 'monetization_permission');
      $publisher_node['monetization_enabled'] = $group['group_monetization_enabled'];
      $publisher_node['monetization_plans'] = $group['group_monetization_plans'];
      break;

    case 'event':
      $event = $user->get_event($_GET['id'] ?? 0);
      if (!$event || !$user->check_event_membership($user->_data['user_id'], $event['event_id'])) {
        _error(400);
      }
      $event['i_admin'] = $user->check_event_adminship($user->_data['user_id'], $event['event_id']);
      if (!$event['event_publish_enabled'] && !$event['i_admin']) {
        modal("MESSAGE", __("Error"), __("Publishing to this event has been disabled by event admins"));
      }
      $publisher_node['id'] = $event['event_id'];
      $publisher_node['target'] = $event['event_title'];
      if ($event['event_page_id'] && $event['i_admin']) {
        $event_page = $user->get_page($event['event_page_id']);
        if ($event_page) {
          $publisher_node['post_as_page'] = true;
          $publisher_node['page_id'] = $event_page['page_id'];
          $publisher_node['name'] = $event_page['page_title'];
          $publisher_node['avatar'] = get_picture($event_page['page_picture'], 'page');
        }
      }
      break;
  }
  $smarty->assign('publisher_node', $publisher_node);

  // prepare publisher
  $smarty->assign('feelings', get_feelings());
  $smarty->assign('feelings_types', get_feelings_types());
  if ($system['colored_posts_enabled']) {
    $smarty->assign('colored_patterns', $user->get_posts_colored_patterns());
  }
  if ($user->_data['can_upload_videos']) {
    $smarty->assign('videos_categories', $user->get_categories("posts_videos_categories"));
  }
  $smarty->assign('publisher_mode', $publisher_mode);
  if (isset($_GET['url']) && is_string($_GET['url']) && !is_empty($_GET['url'])) {
    $smarty->assign('url', $_GET['url']);
  }

  // get the publisher
  $return['publisher'] = $smarty->fetch("ajax.posts.publisher.tpl");
  $return['callback'] = "modal_content(response.publisher, true); quill_publisher(); if ($('#publisher-wapper').length > 0) { $('#publisher-wapper').data('publisher-detached', $('#publisher-wapper').contents().detach()); } $('.publisher textarea').trigger('click');";
  if (isset($_GET['url']) && is_string($_GET['url']) && !is_empty($_GET['url'])) {
    $return['callback'] .= " initialize_scraper();";
  }
  switch ($publisher_mode) {
    case 'photos':
      $return['callback'] .= " $('#publisher-wapper-modal .js_publisher-tab[data-tab=\"photos\"] input[type=\"file\"]').trigger('click');";
      break;

    case 'video':
      $return['callback'] .= " $('#publisher-wapper-modal .js_publisher-tab[data-tab=\"video\"] input[type=\"file\"]').trigger('click');";
      break;

    case 'feelings':
      $return['callback'] .= " $('#publisher-wapper-modal .js_publisher-feelings').trigger('click');";
      break;

    case 'location':
      $return['callback'] .= " $('#publisher-wapper-modal .js_publisher-tab[data-tab=\"location\"]').trigger('click');";
      break;
  }


  // return & exit
  return_json($return);
} catch (Exception $e) {
  modal("ERROR", __("Error"), $e->getMessage());
}
