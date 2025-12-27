<?php

/**
 * ajax -> modules -> add
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich
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
        if (!$user->check_module_package_permission("pages_permission")) {
          return_json(["callback" => "window.location = '" . $system['system_url'] . "/packages?highlight=true';"]);
        } else {
          modal("MESSAGE", __("Error"), __("You don't have the permission to do this"));
        }
      }

      // get custom fields
      $smarty->assign('custom_fields', $user->get_custom_fields(["for" => "page"]));

      // get pages categories
      $smarty->assign('categories', $user->get_categories("pages_categories"));

      // get countries if not defined
      if (!$countries) {
        $smarty->assign('countries', $user->get_countries());
      }

      // get languages if not defined
      if (!$languages) {
        $smarty->assign('languages', $user->get_languages());
      }

      // return
      $return['template'] = $smarty->fetch("ajax.page.publisher.tpl");
      $return['callback'] = "$('#modal').modal('show'); $('.modal-content:last').html(response.template); initialize_modal();";
      break;

    case 'group':
      // check groups permission
      if (!$user->_data['can_create_groups']) {
        if (!$user->check_module_package_permission("groups_permission")) {
          return_json(["callback" => "window.location = '" . $system['system_url'] . "/packages?highlight=true';"]);
        } else {
          modal("MESSAGE", __("Error"), __("You don't have the permission to do this"));
        }
      }

      // get custom fields
      $smarty->assign('custom_fields', $user->get_custom_fields(["for" => "group"]));

      // get groups categories
      $smarty->assign('categories', $user->get_categories("groups_categories"));

      // get countries if not defined
      if (!$countries) {
        $smarty->assign('countries', $user->get_countries());
      }

      // get languages if not defined
      if (!$languages) {
        $smarty->assign('languages', $user->get_languages());
      }

      // return
      $return['template'] = $smarty->fetch("ajax.group.publisher.tpl");
      $return['callback'] = "$('#modal').modal('show'); $('.modal-content:last').html(response.template); initialize_modal();";
      break;

    case 'event':
      // check events permission
      if (!$user->_data['can_create_events']) {
        if (!$user->check_module_package_permission("events_permission")) {
          return_json(["callback" => "window.location = '" . $system['system_url'] . "/packages?highlight=true';"]);
        } else {
          modal("MESSAGE", __("Error"), __("You don't have the permission to do this"));
        }
      }

      // get custom fields
      $smarty->assign('custom_fields', $user->get_custom_fields(["for" => "event"]));

      // get events categories
      $smarty->assign('categories', $user->get_categories("events_categories"));

      // get countries if not defined
      if (!$countries) {
        $smarty->assign('countries', $user->get_countries());
      }

      // get languages if not defined
      if (!$languages) {
        $smarty->assign('languages', $user->get_languages());
      }

      // set page_id if set
      if (isset($_GET['page_id'])) {
        $smarty->assign('page_id', $_GET['page_id']);
      }

      // return
      $return['template'] = $smarty->fetch("ajax.event.publisher.tpl");
      $return['callback'] = "$('#modal').modal('show'); $('.modal-content:last').html(response.template); initialize_modal();";
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
