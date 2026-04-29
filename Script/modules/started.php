<?php

/**
 * modules -> started
 * 
 * @package Sngine
 * @author Zamblek
 */

// fetch bootloader
require('../bootloader.php');

// user access (simple)
if (!$user->_logged_in) {
  user_login();
}

// check user activated
if ($system['activation_enabled'] && $system['activation_required'] && !$user->_data['user_activated']) {
  _error('ACTIVATION');
}

// check user approval
if ($system['users_approval_enabled'] && !$user->_data['user_approved'] && $user->_data['user_group'] >= '3') {
  _error('APPROVAL');
}

// check user getted started
if (!$system['getting_started'] || $user->_data['user_started']) {
  redirect();
}

try {

  // get countries
  if (!$countries) {
    $smarty->assign('countries', $user->get_countries());
  }

  // get suggested people
  $smarty->assign('new_people', $user->get_new_people(0, true));

  // get friends
  $smarty->assign('friends', $user->get_friends($user->_data['user_id']));

  // get followers
  $smarty->assign('followers', $user->get_followers($user->_data['user_id']));

  // get pages
  $smarty->assign('pages', $user->get_pages());

  // get groups
  $smarty->assign('groups', $user->get_groups());
} catch (Exception $e) {
  _error(__("Error"), $e->getMessage());
}

// page header
page_header(__($system['system_title']) . " &rsaquo; " . __("Getting Started"));

// page footer
page_footer('started');
