<?php

/**
 * ajax -> chat -> publisher
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

// check monetization permission
if (!$user->_data['can_monetize_content']) {
  if ($user->check_module_package_permission("monetization_permission")) {
    return_json(["callback" => "window.location = '" . $system['system_url'] . "/packages?highlight=true';"]);
  } else {
    modal("MESSAGE", __("Error"), __("You don't have the permission to do this"));
  }
}

try {

  // initialize the return array
  $return = [];

  // prepare publisher
  $smarty->assign('cid', $_GET['cid']);

  // get the publisher
  $return['publisher'] = $smarty->fetch("ajax.chat.publisher.tpl");
  $return['callback'] = "modal_content(response.publisher, true); if ($('#publisher-wapper').length > 0) { $('#publisher-wapper').data('publisher-detached', $('#publisher-wapper').contents().detach()); } $('.publisher textarea').trigger('click');";

  // return & exit
  return_json($return);
} catch (Exception $e) {
  modal("ERROR", __("Error"), $e->getMessage());
}
