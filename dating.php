<?php

/**
 * dating
 * 
 * @package Sngine
 * @author Zamblek
 */

// fetch bootloader
require('bootloader.php');

// dating enabled
if (!$system['dating_enabled']) {
  _error(404);
}

// user access
user_access();

// check if user can use dating
if (!$user->_data['can_use_dating']) {
  _error('PERMISSION');
}

try {

  // valid inputs
  $_GET['view'] = $_GET['view'] ?? '';
  if (!in_array($_GET['view'], ['', 'browse', 'likes', 'matches', 'profile'])) {
    _error(404);
  }

  // get dating profile
  $user->dating_sync_location();
  $dating_profile = $user->get_dating_profile();
  /* incognito is a package perk */
  if ($dating_profile && $dating_profile['incognito'] && !$user->dating_perk('incognito')) {
    $db->query(sprintf("UPDATE dating_profiles SET incognito = '0' WHERE user_id = %s", secure($user->_data['user_id'], 'int')));
    $dating_profile['incognito'] = '0';
  }
  $dating_locked = $system['dating_verified_only'] && !$user->_data['user_verified'];
  $dating_photos = ($dating_profile) ? ($user->get_dating_photos([$user->_data['user_id']], false)[$user->_data['user_id']] ?? []) : [];
  /* members without a ready profile start from the profile */
  $dating_ready = !$dating_locked && $dating_profile && $dating_profile['status'] == 'active' && $dating_photos;
  if (!$dating_ready && $_GET['view'] != 'profile') {
    redirect('/dating/profile');
  }

  // page header
  page_header(__("Dating") . ' | ' . __($system['system_title']), __("Meet new people and find your match"));

  // get view content
  switch ($_GET['view']) {
    case '':
      // get deck
      $deck = $user->get_dating_deck();
      /* assign variables */
      $ads = $user->ads('dating');
      $smarty->assign('cards', $deck['cards']);
      $smarty->assign('ads', $ads);
      $smarty->assign('dating_ad', ($ads) ? $ads[array_rand($ads)] : null);
      break;

    case 'browse':
      // get filters
      $filters = [];
      foreach (['gender', 'min_age', 'max_age', 'distance', 'city', 'interest'] as $filter) {
        if (isset($_GET[$filter]) && $_GET[$filter] !== '') {
          $filters[$filter] = $_GET[$filter];
        }
      }
      // get members
      $members = $user->get_dating_browse($filters);
      /* assign variables */
      $smarty->assign('filters', $filters);
      $smarty->assign('filters_query', http_build_query($filters));
      $smarty->assign('members', $members);
      $smarty->assign('cursor', ($user->_dating_more) ? $user->_cursor : null);
      $smarty->assign('ads', $user->ads('dating'));
      break;

    case 'likes':
      // get likes
      $members = $user->get_dating_likes();
      /* assign variables */
      $smarty->assign('members', $members);
      $smarty->assign('cursor', ($user->_dating_more) ? $user->_cursor : null);
      $smarty->assign('can_see_likes', $user->dating_perk('likes_list'));
      break;

    case 'matches':
      // get matches
      $matches = $user->get_dating_matches();
      /* assign variables */
      $smarty->assign('matches', $matches);
      $smarty->assign('cursor', ($user->_dating_more) ? $user->_cursor : null);
      break;

    case 'profile':
      /* assign variables */
      $smarty->assign('countries', $user->get_countries());
      $smarty->assign('profile_interests', ($dating_profile) ? ($user->get_dating_profiles_interests([$user->_data['user_id']])[$user->_data['user_id']] ?? []) : []);
      $smarty->assign('can_use_incognito', $user->dating_perk('incognito'));
      break;
  }

  // assign variables
  $smarty->assign('view', $_GET['view']);
  $smarty->assign('dating_profile', $dating_profile);
  $smarty->assign('dating_photos', $dating_photos);
  $smarty->assign('dating_ready', $dating_ready);
  $smarty->assign('dating_locked', $dating_locked);
  $smarty->assign('dating_interests', $user->get_dating_interests());
  $smarty->assign('dating_likes_count', ($dating_ready) ? $user->get_dating_likes_count() : 0);
  $smarty->assign('dating_balance', ($dating_profile) ? $user->get_dating_balance() : null);
  $smarty->assign('dating_paid', $user->dating_paid_enabled());
  $smarty->assign('dating_upgrade', $system['packages_enabled'] && !$user->_data['user_subscribed']);
  $smarty->assign('genders', $user->get_genders());
} catch (Exception $e) {
  _error(__("Error"), $e->getMessage());
}

// page footer
page_footer('dating');
