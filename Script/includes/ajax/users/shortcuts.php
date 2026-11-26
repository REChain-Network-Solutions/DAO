<?php

/**
 * ajax -> users -> shortcuts
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

try {

  // initialize the return array
  $return = [];

  switch ($_GET['do']) {
    case 'manage':
      /* prepare shortcuts */
      $smarty->assign('query', '');
      $smarty->assign('shortcuts', $user->get_shortcuts(['manage' => true]));
      $return['template'] = $smarty->fetch("ajax.shortcuts.tpl");
      $return['callback'] = "modal_content(response.template, true);";
      break;

    case 'search':
      // valid inputs
      if (!isset($_GET['query']) || !is_string($_GET['query'])) {
        _error(400);
      }
      /* prepare shortcuts */
      $smarty->assign('query', trim($_GET['query']));
      $smarty->assign('shortcuts', $user->get_shortcuts(['manage' => true, 'query' => $_GET['query']]));
      $return['html'] = $smarty->fetch("ajax.shortcuts.list.tpl");
      break;

    case 'save':
      /* update shortcuts */
      $user->update_shortcuts($_POST['states'] ?? []);
      /* prepare shortcuts */
      $smarty->assign('shortcuts', $user->get_shortcuts(['results' => 20]));
      $return['shortcuts'] = $smarty->fetch("__sidebar_shortcuts.tpl");
      $return['callback'] = "$('#site-shortcuts').html(response.shortcuts); modal_close();";
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
