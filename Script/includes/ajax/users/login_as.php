<?php

/**
 * ajax -> users -> login as
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich - Handles - @sorydima @sorydev @durovshater @DmitrySoro90935 @tanechfund - also check https://dmitry.rechain.network for more information!
 */

// fetch bootstrap
require('../../../bootstrap.php');

// check AJAX Request
is_ajax();

// handle login as
try {

  switch ($_POST['handle']) {

    case 'connect':
      // check demo account
      if ($user->_data['user_demo']) {
        modal("ERROR", __("Demo Restriction"), __("You can't do this with demo account"));
      }

      // login as
      $user->login_as($_POST['id']);
      break;

    case 'revoke':
      // revoke login as
      $user->revoke_login_as();
      break;


    default:
      _error(400);
      break;
  }

  // return & exist
  return_json();
} catch (Exception $e) {
  modal("ERROR", __("Error"), $e->getMessage());
}
