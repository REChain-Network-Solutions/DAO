<?php

/**
 * ajax -> user -> merits
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

  switch ($_GET['do']) {
    case 'publish':

      // get merits categories
      $merits_categories = $user->get_categories("merits_categories");
      /* assign variables */
      $smarty->assign('merits_categories', $merits_categories);

      // get merits balance
      $user->_data['merits_balance'] = $user->get_user_merits_balance();

      // get selected category if exists
      if (isset($_GET['category_id']) && is_numeric($_GET['category_id'])) {
        $smarty->assign('category_id', $_GET['category_id']);
      }

      // return
      $return['template'] = $smarty->fetch("ajax.merits.publisher.tpl");
      $return['callback'] = "$('#modal').modal('show'); $('.modal-content:last').html(response.template); initialize_modal();";
      break;

    case 'send':

      // send merit
      $user->send_merit($_POST['recepients'], $_POST['category'], $_POST['message'], $_POST['image']);

      // return
      modal("SUCCESS", __("Success"), __("The merit has been sent successfully"));
      break;

    default:
      _error(400);
      break;
  }

  // return & exit
  return_json($return);
} catch (ValidationException $e) {
  return_json(['error' => true, 'message' => $e->getMessage()]);
} catch (Exception $e) {
  modal("ERROR", __("Error"), $e->getMessage());
}
