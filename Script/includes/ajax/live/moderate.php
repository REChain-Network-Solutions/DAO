<?php

/**
 * ajax -> live -> moderate
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

// live moderation enabled
if (empty($system['live_moderation_enabled'])) {
  _error(404);
}

// valid inputs
if (in_array($_REQUEST['do'], ['restrictions', 'unrestrict', 'settings', 'save_settings', 'moderators', 'delete_moderator', 'log'])) {
  if (!isset($_GET['host_type']) || !isset($_GET['host_id']) || !is_numeric($_GET['host_id'])) {
    _error(400);
  }
} elseif (!isset($_GET['post_id']) || !is_numeric($_GET['post_id'])) {
  _error(400);
}
if (!in_array($_REQUEST['do'], ['restrictions', 'settings', 'save_settings', 'moderators', 'log']) && (!isset($_GET['user_id']) || !is_numeric($_GET['user_id']))) {
  _error(400);
}

try {

  // initialize the return array
  $return = [];

  switch ($_REQUEST['do']) {
    case 'timeout':
    case 'mute':
    case 'kick':
    case 'ban':
    case 'moderator':
      // get live moderation
      $moderation = $user->get_live_moderation($_GET['post_id'], $_GET['user_id']);
      if ($_REQUEST['do'] == 'moderator' && !$moderation['can_manage_moderators']) {
        _error(403);
      }
      /* assign variables */
      $smarty->assign('view', $_REQUEST['do']);
      $smarty->assign('post_id', $_GET['post_id']);
      $smarty->assign('target', $moderation['target']);

      // return
      $return['template'] = $smarty->fetch("ajax.live.moderate.tpl");
      $return['callback'] = "modal_content(response.template, true);";
      break;

    case 'submit':
      // moderate
      $user->live_moderate($_GET['post_id'], $_GET['user_id'], $_POST['action'], $_POST['duration'] ?? 0);

      // return
      $return['callback'] = "modal_close();";
      if (in_array($_POST['action'], ['timeout', 'mute', 'kick', 'ban'])) {
        $return['callback'] .= " live_moderation_state(" . (int) $_GET['user_id'] . ", 'restriction', '" . $_POST['action'] . "');";
      } elseif ($_POST['action'] == 'remove_moderator') {
        $return['callback'] .= " live_moderation_state(" . (int) $_GET['user_id'] . ", 'moderator', '');";
      } else {
        $return['callback'] .= " live_moderation_state(" . (int) $_GET['user_id'] . ", 'restriction', '');";
        if ($_POST['action'] == 'add_moderator') {
          $return['callback'] .= " live_moderation_state(" . (int) $_GET['user_id'] . ", 'moderator', 'moderator');";
        }
      }
      $return['callback'] .= " live_socket_moderation();";
      break;

    case 'moderators':
      // get live moderators
      $smarty->assign('moderators', $user->get_live_moderators($_GET['host_type'], $_GET['host_id']));
      $smarty->assign('host_type', ($_GET['host_type'] == "page") ? "page" : "user");
      $smarty->assign('host_id', (int) $_GET['host_id']);

      // return
      $return['template'] = $smarty->fetch("ajax.live.moderators.tpl");
      $return['callback'] = "modal_content(response.template, true);";
      break;

    case 'delete_moderator':
      // delete live moderator
      $user->delete_live_moderator($_GET['host_type'], $_GET['host_id'], $_GET['user_id']);

      // return
      $return['callback'] = "$('#live-moderator-" . (int) $_GET['user_id'] . "').remove(); live_moderation_state(" . (int) $_GET['user_id'] . ", 'moderator', '');";
      break;

    case 'log':
      // get live moderation log
      $log = $user->get_live_moderation_log($_GET['host_type'], $_GET['host_id'], (int) ($_GET['last_log_id'] ?? 0));
      $smarty->assign('log', $log);
      $smarty->assign('last_log_id', (count($log) == 30) ? end($log)['log_id'] : 0);
      $smarty->assign('host_type', ($_GET['host_type'] == "page") ? "page" : "user");
      $smarty->assign('host_id', (int) $_GET['host_id']);

      // return
      $return['template'] = $smarty->fetch("ajax.live.log.tpl");
      $return['callback'] = "modal_content(response.template, true);";
      break;

    case 'settings':
      // get live settings
      $smarty->assign('settings', $user->get_live_settings($_GET['host_type'], $_GET['host_id']));
      $smarty->assign('host_type', ($_GET['host_type'] == "page") ? "page" : "user");
      $smarty->assign('host_id', (int) $_GET['host_id']);

      // return
      $return['template'] = $smarty->fetch("ajax.live.settings.tpl");
      $return['callback'] = "modal_content(response.template, true);";
      break;

    case 'save_settings':
      // update live settings
      $user->update_live_settings($_GET['host_type'], $_GET['host_id'], [
        'slow_mode' => $_POST['slow_mode'] ?? 0,
        'blocked_words' => $_POST['blocked_words'] ?? '',
        'links_blocked' => isset($_POST['links_blocked']),
        'repeats_blocked' => isset($_POST['repeats_blocked']),
        'rules' => $_POST['rules'] ?? ''
      ]);

      // return
      $return['callback'] = "modal_close();";
      break;

    case 'restrictions':
      // get live restrictions
      $smarty->assign('restrictions', $user->get_live_restrictions($_GET['host_type'], $_GET['host_id']));
      $smarty->assign('host_type', ($_GET['host_type'] == "page") ? "page" : "user");
      $smarty->assign('host_id', (int) $_GET['host_id']);

      // return
      $return['template'] = $smarty->fetch("ajax.live.restrictions.tpl");
      $return['callback'] = "modal_content(response.template, true);";
      break;

    case 'unrestrict':
      // delete live restriction
      $user->delete_live_restriction($_GET['host_type'], $_GET['host_id'], $_GET['user_id']);

      // return
      $return['callback'] = "$('#live-restriction-" . (int) $_GET['user_id'] . "').remove(); live_moderation_state(" . (int) $_GET['user_id'] . ", 'restriction', ''); live_socket_moderation();";
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
