<?php

/**
 * ads
 * 
 * @package Sngine
 * @author Zamblek
 */

// fetch bootloader
require('bootloader.php');

// check if ads enabled
if (!$system['ads_enabled']) {
  _error(404);
}

// user access
user_access();

// check ads permission
if (!$user->_data['can_create_ads']) {
  if ($user->check_module_package_permission("ads_permission")) {
    redirect("/packages?highlight=true");
  }
  _error(404);
}

try {

  // get view content
  switch ($_GET['view']) {
    case '':
      // page header
      page_header(__("Ads Manager") . ' | ' . __($system['system_title']));

      // get campaigns
      $campaigns = $user->get_campaigns();
      $campaigns_stats = ['active' => 0, 'spend' => 0, 'clicks' => 0, 'views' => 0];
      foreach ($campaigns as &$campaign) {
        $campaign['campaign_spend_percent'] = ($campaign['campaign_budget'] > 0) ? min(100, round(($campaign['campaign_spend'] / $campaign['campaign_budget']) * 100)) : 0;
        if ($campaign['campaign_is_approved'] && $campaign['campaign_is_active'] && !$campaign['campaign_is_declined']) {
          $campaigns_stats['active']++;
        }
        $campaigns_stats['spend'] += $campaign['campaign_spend'];
        $campaigns_stats['clicks'] += $campaign['campaign_clicks'];
        $campaigns_stats['views'] += $campaign['campaign_views'];
      }
      unset($campaign);
      $smarty->assign('campaigns', $campaigns);
      $smarty->assign('campaigns_stats', $campaigns_stats);
      break;

    case 'new':
      // page header
      page_header(__("New Campaign"));

      // get viewer all managed pages
      $smarty->assign('pages', $user->get_pages(['get_all' => true, 'managed' => true, 'user_id' => $user->_data['user_id']]));

      // get viewer all managed groups
      $smarty->assign('groups', $user->get_groups(['get_all' => true, 'managed' => true, 'user_id' => $user->_data['user_id']]));

      // get viewer all managed events
      $smarty->assign('events', $user->get_events(['get_all' => true, 'managed' => true, 'user_id' => $user->_data['user_id']]));

      // get genders
      $smarty->assign('genders', $user->get_genders());

      // get countries if not defined
      if (!$countries) {
        $smarty->assign('countries', $user->get_countries());
      }

      // get campaign potential reach
      $smarty->assign('potential_reach', $user->campaign_potential_reach());
      break;

    case 'edit':
      // page header
      page_header(__("Edit Campaign"));

      // get campaign
      $campaign = $user->get_campaign($_GET['campaign_id']);
      if (!$campaign) {
        _error(404);
      }
      /* check permission */
      if (!($user->_data['user_group'] < 3 || $user->_data['user_id'] == $campaign['campaign_user_id'])) {
        _error(404);
      }
      /* assign variables */
      $smarty->assign('campaign', $campaign);

      // get target all managed pages
      $smarty->assign('pages', $user->get_pages(['get_all' => true, 'managed' => true, 'user_id' => $campaign['campaign_user_id']]));

      // get target all managed groups
      $smarty->assign('groups', $user->get_groups(['get_all' => true, 'managed' => true, 'user_id' => $campaign['campaign_user_id']]));

      // get target all managed events
      $smarty->assign('events', $user->get_events(['get_all' => true, 'managed' => true, 'user_id' => $campaign['campaign_user_id']]));

      // get genders
      $smarty->assign('genders', $user->get_genders());

      // get countries if not defined
      if (!$countries) {
        $smarty->assign('countries', $user->get_countries());
      }
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
page_footer('ads');
