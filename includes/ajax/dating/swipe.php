<?php

/**
 * ajax -> dating -> swipe
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

// dating enabled
if (!$user->_data['can_use_dating']) {
  modal("MESSAGE", __("Error"), __("This feature has been disabled by the admin"));
}

// check demo account
if ($user->_data['user_demo']) {
  modal("ERROR", __("Demo Restriction"), __("You can't do this with demo account"));
}

try {

  // initialize the return array
  $return = [];

  switch ($_GET['do']) {
    case 'swipe':
      // valid inputs
      if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
        _error(400);
      }
      /* get the card before it gets swiped */
      $card = ($_POST['action'] != 'pass') ? $user->get_dating_card($_POST['id']) : null;

      // swipe
      $swipe = $user->dating_swipe($_POST['id'], $_POST['action'], $_POST['message'] ?? '');
      $return['matched'] = $swipe['matched'];
      if ($swipe['matched'] && $card) {
        /* assign variables */
        $smarty->assign('card', $card);
        $smarty->assign('match', $user->get_dating_match_user($_POST['id']));
        /* return */
        $return['template'] = $smarty->fetch("ajax.dating.match.tpl");
      }
      $return['balance'] = $user->get_dating_balance();
      break;

    case 'rewind':
      // rewind
      $target_id = $user->dating_rewind();
      $card = $user->get_dating_card($target_id);
      if ($card) {
        /* assign variables */
        $smarty->assign('cards', [$card]);
        /* return */
        $return['cards'] = $smarty->fetch("ajax.dating.cards.tpl");
      }
      $return['balance'] = $user->get_dating_balance();
      break;

    case 'deck':
      // get deck
      $exclude = (isset($_POST['exclude']) && is_array($_POST['exclude'])) ? $_POST['exclude'] : [];
      $deck = $user->get_dating_deck($exclude);
      /* assign variables */
      $ads = $user->ads('dating');
      $smarty->assign('cards', $deck['cards']);
      $smarty->assign('dating_ad', ($ads) ? $ads[array_rand($ads)] : null);
      /* return */
      $return['cards'] = ($deck['cards']) ? $smarty->fetch("ajax.dating.cards.tpl") : '';
      $return['exhausted'] = $deck['exhausted'];
      break;

    case 'message':
      // valid inputs
      if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
        _error(400);
      }
      /* assign variables */
      $smarty->assign('id', $_GET['id']);
      /* return */
      $return['template'] = $smarty->fetch("ajax.dating.message.tpl");
      $return['callback'] = "modal_content(response.template, true);";
      break;

    case 'unmatch':
      // valid inputs
      if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
        _error(400);
      }

      // unmatch
      $user->dating_unmatch($_POST['id']);
      if (isset($_POST['block']) && $_POST['block'] == 'true') {
        $user->connect('block', $_POST['id']);
      }
      break;

    default:
      _error(400);
      break;
  }

  // return & exit
  return_json($return);
} catch (ValidationException $e) {
  return_json(['error' => true, 'code' => $e->getCode(), 'message' => $e->getMessage()]);
} catch (Exception $e) {
  modal("ERROR", __("Error"), $e->getMessage());
}
