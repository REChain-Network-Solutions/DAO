<?php

/**
 * ajax -> users -> search
 *
 * @package Sngine
 * @author Zamblek
 */

// fetch bootstrap
require('../../../bootstrap.php');

// check AJAX Request
is_ajax();

// user access
user_access();

// valid inputs
if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
  _error(400);
}

try {

  // initialize the return array
  $return = [];

  // get node
  $type = (isset($_GET['type']) && in_array($_GET['type'], ['page', 'group', 'event'])) ? $_GET['type'] : 'user';
  switch ($type) {
    case 'page':
      $page = $user->get_page($_GET['id']);
      if (!$page) {
        _error(404);
      }
      $search = ['url' => '/pages/' . $page['page_name'], 'picture' => get_picture($page['page_picture'], 'page'), 'name' => $page['page_title']];
      break;

    case 'group':
      $group = $user->get_group($_GET['id']);
      if (!$group) {
        _error(404);
      }
      /* check group privacy */
      if ($group['group_privacy'] != "public" && !$user->_is_admin && !$user->_is_moderator && $user->check_group_membership($user->_data['user_id'], $group['group_id']) != "approved" && !$user->check_group_adminship($user->_data['user_id'], $group['group_id'])) {
        _error(403);
      }
      $search = ['url' => '/groups/' . $group['group_name'], 'picture' => get_picture($group['group_picture'], 'group'), 'name' => $group['group_title']];
      break;

    case 'event':
      $event = $user->get_event($_GET['id']);
      if (!$event) {
        _error(404);
      }
      /* check event privacy */
      if ($event['event_privacy'] != "public" && !$user->_is_admin && !$user->_is_moderator && !$user->check_event_membership($user->_data['user_id'], $event['event_id']) && !$user->check_event_adminship($user->_data['user_id'], $event['event_id'])) {
        _error(403);
      }
      $search = ['url' => '/events/' . $event['event_id'], 'picture' => get_picture($event['event_cover'], 'event'), 'name' => $event['event_title']];
      break;

    default:
      $profile = $user->get_user($_GET['id'], false);
      if (!$profile) {
        _error(404);
      }
      $search = ['url' => '/' . $profile['user_name'], 'picture' => $profile['user_picture'], 'name' => ($system['show_usernames_enabled']) ? $profile['user_name'] : $profile['user_firstname'] . ' ' . $profile['user_lastname']];
      break;
  }
  /* assign variables */
  $smarty->assign('search', $search);
  $smarty->assign('query', (isset($_GET['query'])) ? htmlentities(html_entity_decode($_GET['query'], ENT_QUOTES, 'utf-8'), ENT_QUOTES, 'utf-8') : '');
  /* return */
  $return['search'] = $smarty->fetch("ajax.profile.search.tpl");
  $return['callback'] = "modal_content(response.search);";

  // return & exit
  return_json($return);
} catch (Exception $e) {
  modal("ERROR", __("Error"), $e->getMessage());
}
