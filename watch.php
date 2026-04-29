<?php

/**
 * watch
 * 
 * @package Sngine
 * @author Zamblek
 */

// fetch bootloader
require('bootloader.php');

// user access
user_access();

// watch enabled
if (!$system['watch_enabled']) {
  _error(404);
}

try {

  // newsfeed location filter
  if ($system['newsfeed_location_filter_enabled']) {
    // get countries if not defined
    if (!$countries) {
      $smarty->assign('countries', $user->get_countries());
    }

    // get selected country
    if (isset($_GET['country'])) {
      /* get selected country */
      $selected_country = $user->get_country_by_name($_GET['country']);
      /* assign variables */
      $smarty->assign('selected_country', $selected_country);
    }
  }

  // get view content
  switch ($_GET['view']) {
    case '':
      // page header
      page_header(__("Watch") . ' | ' . __($system['system_title']));

      // get watch categories
      $smarty->assign('categories', $user->get_categories("posts_videos_categories"));

      // get posts (watch)
      /* first get the videos from public */
      $posts_discover = ($selected_country) ? $user->get_posts(['get' => 'discover', 'filter' => 'video', 'country' => $selected_country['country_id']]) : $user->get_posts(['get' => 'discover', 'filter' => 'video']);
      /* second get the videos from friends */
      $posts_friends = ($selected_country) ? $user->get_posts(['get' => 'newsfeed', 'filter' => 'video', 'country' => $selected_country['country_id']]) : $user->get_posts(['get' => 'newsfeed', 'filter' => 'video']);
      /* merge the two arrays */
      $posts = array_merge($posts_discover, $posts_friends);
      /* assign variables */
      $smarty->assign('posts', $posts);
      $smarty->assign('view_title', __("Discover"));
      break;

    case 'category':
      // get category
      $current_category = $user->get_category("posts_videos_categories", $_GET['category_id'], true);
      if (!$current_category) {
        _error(404);
      }
      /* assign variables */
      $smarty->assign('current_category', $current_category);

      // page header
      page_header(__("Watch") . ' &rsaquo; ' . __($current_category['category_name']) . ' | ' . __($system['system_title']), __($current_category['category_description']));

      // get watch categories (only sub-categories)
      if (!$current_category['sub_categories'] && !$current_category['parent']) {
        $categories = $user->get_categories("posts_videos_categories");
      } else {
        $categories = $user->get_categories("posts_videos_categories", $current_category['category_id']);
      }
      /* assign variables */
      $smarty->assign('categories', $categories);

      // get posts (watch)
      /* first get the videos from public */
      $posts_discover = ($selected_country) ? $user->get_posts(['get' => 'discover', 'filter' => 'video', 'category' => $_GET['category_id'], 'country' => $selected_country['country_id']]) : $user->get_posts(['get' => 'discover', 'filter' => 'video', 'category' => $_GET['category_id']]);
      /* second get the videos from friends */
      $posts_friends = ($selected_country) ? $user->get_posts(['get' => 'newsfeed', 'filter' => 'video', 'category' => $_GET['category_id'], 'country' => $selected_country['country_id']]) : $user->get_posts(['get' => 'newsfeed', 'filter' => 'video', 'category' => $_GET['category_id']]);
      /* merge the two arrays */
      $posts = array_merge($posts_discover, $posts_friends);
      /* assign variables */
      $smarty->assign('posts', $posts);
      $smarty->assign('view_title', __($current_category['category_name']));
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
page_footer('watch');
