<?php

/**
 * ajax -> chat -> product
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

  // post product message
  $user->post_conversation_message($_POST, true);
} catch (Exception $e) {
  modal("ERROR", __("Error"), $e->getMessage());
}
