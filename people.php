<?php

/**
 * people
 * 
 * @package Sngine
 * @author Zamblek
 */

// fetch bootloader
require('bootloader.php');

// user access
user_access();

try {

  // get friend requests
  $user->_data['friend_requests'] = $user->get_friend_requests();

  // get view content
  switch ($_GET['view']) {
    case '':
      // page header
      page_header(__("Discover People") . ' | ' . __($system['system_title']));

      // get new people
      $smarty->assign('people', $user->get_new_people());
      break;

    case 'find':
      // page header
      page_header(__("Find People"));

      // search filters
      $filters = $user->get_people_search_filters($_GET);
      $smarty->assign('people_search_filters', json_encode($filters, JSON_INVALID_UTF8_SUBSTITUTE));
      foreach ($filters as $key => $value) {
        if (strpos($key, 'fld_') !== 0) {
          $smarty->assign($key, htmlspecialchars((string) $value, ENT_QUOTES, 'utf-8'));
        }
      }

      // search users
      $people = $user->search_users($filters['distance_value'], $filters['query'], $filters['city'], $filters['country'], $filters['gender'], $filters['relationship'], $filters['online_status'], $filters['verified_status'], 0, $filters);
      $smarty->assign('people', $people);
      break;

    case 'friend_requests':
      // check if friends enabled
      if (!$system['friends_enabled']) {
        _error(404);
      }

      // page header
      page_header(__("Friend Requests"));
      break;

    case 'sent_requests':
      // check if friends enabled
      if (!$system['friends_enabled']) {
        _error(404);
      }

      // page header
      page_header(__("Friend Requests Sent"));

      // get friend requests sent
      $user->_data['friend_requests_sent'] = $user->get_friend_requests_sent();
      break;

    default:
      _error(404);
      break;
  }
  /* assign variables */
  $smarty->assign('view', $_GET['view']);

  // get total friend requests sent
  $user->_data['friend_requests_sent_total'] = $user->get_friend_requests_sent_total();

  // get genders
  $smarty->assign('genders', $user->get_genders());

  // get custom fields
  $custom_fields = $user->get_custom_fields(["get" => "search"]);
  foreach ($custom_fields as &$custom_field) {
    $custom_field['value'] = $filters['fld_' . $custom_field['field_id']] ?? ($custom_field['type'] == 'multipleselectbox' ? [] : ($custom_field['type'] == 'selectbox' ? 'any' : ''));
  }
  unset($custom_field);
  $smarty->assign('custom_fields', $custom_fields);

  // get ads campaigns
  $smarty->assign('ads_campaigns', method_exists($user, 'ads_campaigns') ? $user->ads_campaigns() : []);

  // get ads
  $smarty->assign('ads', $user->ads('people'));

  // get widgets
  $smarty->assign('widgets', $user->widgets('people'));
} catch (Exception $e) {
  _error(__("Error"), $e->getMessage());
}

// page footer
page_footer('people');
