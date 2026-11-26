<?php

/**
 * live
 *
 * @package Sngine
 * @author Zamblek
 */

// fetch bootloader
require('bootloader.php');

// live enabled
if (!$system['live_enabled']) {
  _error(404);
}

try {

  // get view content
  switch ($_GET['view']) {
    case '':
    case 'following':
    case 'manage':
    case 'category':
    case 'search':
      // user access
      if ($_GET['view'] == "following" || $_GET['view'] == "manage" || $user->_logged_in || !$system['system_public']) {
        user_access();
      }

      // get selected country
      $selected_country = null;
      if ($system['newsfeed_location_filter_enabled'] && isset($_GET['country']) && $_GET['country'] != "all") {
        $selected_country = $user->get_country_by_name($_GET['country']);
        /* assign variables */
        $smarty->assign('selected_country', $selected_country);
      }

      // get view content
      $current_category = null;
      $query = null;
      switch ($_GET['view']) {
        case 'category':
          /* get category */
          $current_category = $user->get_category("posts_live_categories", $_GET['category_id'], true);
          if (!$current_category) {
            _error(404);
          }
          /* assign variables */
          $smarty->assign('current_category', $current_category);

          // page header
          page_header(__("Live") . ' &rsaquo; ' . __($current_category['category_name']) . ' | ' . __($system['system_title']), __($current_category['category_description']));
          break;

        case 'search':
          /* check query */
          if (!isset($_GET['query']) || is_empty($_GET['query'])) {
            redirect('/live');
          }
          $query = $_GET['query'];
          /* assign variables */
          $smarty->assign('query', htmlentities($query, ENT_QUOTES, 'utf-8'));

          // page header
          page_header(__("Live") . ' &rsaquo; ' . __("Search") . ' | ' . __($system['system_title']));
          break;

        case 'manage':
          // page header
          page_header(__("My Lives") . ' | ' . __($system['system_title']));
          break;

        default:
          // page header
          page_header(__("Live") . ' | ' . __($system['system_title']), __($system['system_description_live']));
          break;
      }

      // get live categories (only sub-categories)
      if (!$current_category || (!$current_category['sub_categories'] && !$current_category['parent'])) {
        $live_categories = $user->get_categories("posts_live_categories");
      } else {
        $live_categories = $user->get_categories("posts_live_categories", $current_category['category_id']);
      }
      /* assign variables */
      $smarty->assign('live_categories', $live_categories);

      // get live posts
      $args = [
        'view' => in_array($_GET['view'], ["following", "manage"]) ? $_GET['view'] : "discover",
        'category_id' => ($current_category) ? $current_category['category_id'] : null,
        'country_id' => ($selected_country) ? $selected_country['country_id'] : null,
        'query' => $query
      ];
      $lives_now = $user->get_live_posts(array_merge($args, ['status' => 'live']));
      $lives_ended = $user->get_live_posts(array_merge($args, ['status' => 'ended']));
      /* assign variables */
      $smarty->assign('lives_now', $lives_now);
      $smarty->assign('lives_ended', $lives_ended);
      break;

    case 'create':
      // user access
      user_access();

      // check demo account
      if ($user->_data['user_demo']) {
        _error('PERMISSION', __("You can't do this with demo account"));
      }

      // check live permission
      if (!$user->_data['can_go_live']) {
        if ($user->check_module_package_permission("live_permission")) {
          redirect("/packages?highlight=true");
        } else {
          _error('PERMISSION');
        }
      }

      // check approval system
      if ($user->check_posts_needs_approval($user->_data['user_id'])) {
        _error('PERMISSION', __("Posts approval system is enabled and you need to verify your account before you can go live"));
      }

      // page header
      page_header(__("Go Live") . ' | ' . __($system['system_title']));

      // get live provider credentials
      if ($system['live_provider'] == "livekit") {
        /* get livekit (token|room) */
        $livekit = $user->livekit_live_token_builder(true);
        /* assign variables */
        $smarty->assign('livekit', $livekit);
      } else {
        /* get agora (uid|token|channel_name) */
        $agora = $user->agora_token_builder(true, null, $user->_data['user_id']);
        /* assign variables */
        $smarty->assign('agora', $agora);
      }

      // get live categories
      $smarty->assign('live_categories', $user->get_categories("posts_live_categories", 0, false, true));

      // check if streaming software (rtmp) enabled
      $smarty->assign('can_rtmp', ($system['live_provider'] == "livekit" && $system['live_rtmp_enabled']));

      // check node (page|group|event|user)
      $node_author = null;
      if (isset($_GET['page_id']) && is_numeric($_GET['page_id'])) {
        /* get page */
        $page = $user->get_page($_GET['page_id']);
        if (!$page) {
          _error(404);
        }
        /* check if the viewer is page admin */
        if (!$user->check_page_adminship($user->_data['user_id'], $page['page_id'])) {
          _error(404);
        }
        /* get node_monetization_enabled */
        $node_monetization_enabled = $page['page_monetization_enabled'];
        /* get node_author */
        $node_author = $page['page_admin'];
        /* get node_monetization_plans */
        $node_monetization_plans = $page['page_monetization_plans'];
        /* assign variables */
        $smarty->assign('page_id', $_GET['page_id']);
      } elseif (isset($_GET['group_id']) && is_numeric($_GET['group_id'])) {
        /* get group */
        $group = $user->get_group($_GET['group_id']);
        if (!$group) {
          _error(404);
        }
        /* check if the viewer joined the group */
        if (!$user->check_group_membership($user->_data['user_id'], $group['group_id'])) {
          _error(404);
        }
        /* get node_monetization_enabled */
        $node_monetization_enabled = $group['group_monetization_enabled'];
        /* get node_author */
        $node_author = $group['group_admin'];
        /* get node_monetization_plans */
        $node_monetization_plans = $group['group_monetization_plans'];
        /* assign variables */
        $smarty->assign('group_id', $_GET['group_id']);
      } elseif (isset($_GET['event_id']) && is_numeric($_GET['event_id'])) {
        /* assign variables */
        $smarty->assign('event_id', $_GET['event_id']);
      } else {
        /* get node_monetization_enabled */
        $node_monetization_enabled = $user->_data['user_monetization_enabled'];
        /* get node_author */
        $node_author = $user->_data['user_id'];
        /* get node_monetization_plans */
        $node_monetization_plans = $user->_data['user_monetization_plans'];
      }

      // check if live can be monetized
      $can_be_for_subscriptions = false;
      $can_be_paid = false;
      if ($system['monetization_enabled'] && $node_author) {
        $node_can_monetize_content = $user->check_user_permission($node_author, 'monetization_permission');
        if ($node_monetization_enabled && $node_can_monetize_content) {
          $can_be_paid = true;
          if ($node_monetization_plans > 0) {
            $can_be_for_subscriptions = true;
          }
        }
      }
      /* assign variables */
      $smarty->assign('can_be_for_subscriptions', $can_be_for_subscriptions);
      $smarty->assign('can_be_paid', $can_be_paid);
      break;

    default:
      _error(404);
      break;
  }
  /* assign variables */
  $smarty->assign('view', $_GET['view']);
} catch (Exception $e) {
  _error(__("Error"), $e->getMessage());
}

// page footer
page_footer('live');
