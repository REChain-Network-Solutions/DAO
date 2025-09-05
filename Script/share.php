<?php

/**
 * share
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich - Handles - @sorydima @sorydev @durovshater @DmitrySoro90935 @tanechfund - also check https://dmitry.rechain.network for more information!
 */

// fetch bootloader
require('bootloader.php');

// check if developers (share plugin) enabled
if (!$system['developers_share_enabled']) {
  _error(404);
}

// user access
user_access();

try {

  // prepare publisher
  /* get user pages */
  $pages = $user->get_pages(['get_all' => true, 'managed' => true, 'user_id' => $user->_data['user_id']]);
  $smarty->assign('pages', $pages);
  /* get user groups */
  $groups = $user->get_groups(['get_all' => true, 'user_id' => $user->_data['user_id']]);
  $smarty->assign('groups', $groups);
  /* get user events */
  $events = $user->get_events(['get_all' => true, 'user_id' => $user->_data['user_id']]);
  $smarty->assign('events', $events);
  $smarty->assign('feelings', get_feelings());
  $smarty->assign('feelings_types', get_feelings_types());
  if ($system['colored_posts_enabled']) {
    $smarty->assign('colored_patterns', $user->get_posts_colored_patterns());
  }
  if ($user->_data['can_upload_videos']) {
    $smarty->assign('videos_categories', $user->get_categories("posts_videos_categories"));
  }
  $smarty->assign('url', $_GET['url']);
} catch (Exception $e) {
  _error(__("Error"), $e->getMessage());
}

// page header
page_header(__($system['system_title']));

// page footer
page_footer('share');
