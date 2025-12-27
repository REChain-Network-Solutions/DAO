<?php

/**
 * bootloader
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich
 */

// fetch bootstrap
require('bootstrap.php');

try {
  // user logged in
  if ($user->_logged_in) {
    // get user data
    /* get friend requests */
    $user->_data['friend_requests'] = $user->get_friend_requests();
    /* get search log */
    $user->_data['search_log'] = $user->get_search_log();
    /* get conversations */
    $user->_data['conversations'] = $user->get_conversations()['data'];
    /* get notifications */
    $user->_data['notifications'] = $user->get_notifications();
    /* get online & offline friends */
    $detect = new Detection\MobileDetect();
    $smarty->assign('detect', $detect);
    if ($system['chat_enabled'] && $user->_data['user_privacy_chat'] != "me" && !($detect->isMobile() && !$detect->isTablet())) {
      /* get sidebar friends */
      $sidebar_friends = $user->get_contacts()['data'];
      /* assign variables */
      $smarty->assign('sidebar_friends', $sidebar_friends);
    }
    /* check if user subscribed */
    if ($system['packages_enabled']) {
      $user->check_user_package();
    }

    // get countries
    if ($system['2checkout_enabled'] || $system['authorize_net_enabled'] || $system['newsfeed_location_filter_enabled']) {
      $countries = $user->get_countries();
      /* assign variables */
      $smarty->assign('countries', $countries);
    }

    // get languages
    $languages = $user->get_languages();
    /* assign variables */
    $smarty->assign('languages', $languages);
  }

  // init affiliates system
  $user->init_affiliates();

  // get static pages
  $smarty->assign('static_pages', $user->get_static_pages());

  // get ads (header & footer)
  $ads_master['header'] = $user->ads('header');
  $ads_master['footer'] = $user->ads('footer');
  /* assign variables */
  $smarty->assign('ads_master', $ads_master);
} catch (Exception $e) {
  _error(__("Error"), $e->getMessage());
}
