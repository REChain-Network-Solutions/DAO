<?php

/**
 * ajax -> modules -> add
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

  switch ($_REQUEST['type']) {
    case 'page':
      // check pages permission
      if (!$user->_data['can_create_pages']) {
        if ($user->check_module_package_permission("pages_permission")) {
          return_json(["callback" => "window.location = '" . $system['system_url'] . "/packages?highlight=true';"]);
        } else {
          modal("MESSAGE", __("Error"), __("You don't have the permission to do this"));
        }
      }

      // get custom fields
      $smarty->assign('custom_fields', $user->get_custom_fields(["for" => "page"]));

      // get pages categories
      $smarty->assign('categories', $user->get_categories("pages_categories"));

      // template
      $template = "ajax.page.publisher.tpl";
      break;

    case 'group':
      // check groups permission
      if (!$user->_data['can_create_groups']) {
        if ($user->check_module_package_permission("groups_permission")) {
          return_json(["callback" => "window.location = '" . $system['system_url'] . "/packages?highlight=true';"]);
        } else {
          modal("MESSAGE", __("Error"), __("You don't have the permission to do this"));
        }
      }

      // get custom fields
      $smarty->assign('custom_fields', $user->get_custom_fields(["for" => "group"]));

      // get groups categories
      $smarty->assign('categories', $user->get_categories("groups_categories"));

      // template
      $template = "ajax.group.publisher.tpl";
      break;

    case 'event':
      // check events permission
      if (!$user->_data['can_create_events']) {
        if ($user->check_module_package_permission("events_permission")) {
          return_json(["callback" => "window.location = '" . $system['system_url'] . "/packages?highlight=true';"]);
        } else {
          modal("MESSAGE", __("Error"), __("You don't have the permission to do this"));
        }
      }

      // get custom fields
      $smarty->assign('custom_fields', $user->get_custom_fields(["for" => "event"]));

      // get events categories
      $smarty->assign('categories', $user->get_categories("events_categories"));

      // set page_id if set
      if (isset($_GET['page_id'])) {
        $smarty->assign('page_id', $_GET['page_id']);
      }

      // template
      $template = "ajax.event.publisher.tpl";

      break;

    default:
      _error(400);
      break;
  }

  // get countries if not defined
  if (!$countries) {
    $smarty->assign('countries', $user->get_countries());
  }

  // get languages if not defined
  if (!$languages) {
    $smarty->assign('languages', $user->get_languages());
  }

  // fallback country and language
  $country_fallback_value = ($user->_data['user_country']) ? $user->_data['user_country'] : $system['default_country']['country_id'];
  $language_fallback_value = ($user->_data['user_language']) ? $user->get_language_by_code($user->_data['user_language'])['language_id'] : $system['default_language']['language_id'];
  $smarty->assign('country_fallback_value', $country_fallback_value);
  $smarty->assign('language_fallback_value', $language_fallback_value);

  // return & exit
  $return['template'] = $smarty->fetch($template);
  $return['callback'] = "modal_content(response.template, true);";
  return_json($return);
} catch (Exception $e) {
  modal("ERROR", __("Error"), $e->getMessage());
}
