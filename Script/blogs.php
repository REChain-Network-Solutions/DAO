<?php

/**
 * blogs
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich - Handles - @sorydima @sorydev @durovshater @DmitrySoro90935 @tanechfund - also check https://dmitry.rechain.network for more information!
 */

// fetch bootloader
require('bootloader.php');

// blogs enabled
if (!$system['blogs_enabled']) {
  _error(404);
}

// user access
if ($user->_logged_in || !$system['system_public']) {
  user_access();
}

try {

  // get view content
  switch ($_GET['view']) {
    case '':
      // page header
      page_header(__("Blogs") . ' | ' . __($system['system_title']), __($system['system_description_blogs']));

      // get selected country
      if (isset($_GET['country'])) {
        /* get selected country */
        $selected_country = $user->get_country_by_name($_GET['country']);
        /* assign variables */
        $smarty->assign('selected_country', $selected_country);
      }

      // get blogs
      $smarty->assign('blogs', $user->get_blogs(['country' => $selected_country['country_id']]));
      break;

    case 'category':
      // check category
      $category = $user->get_category("blogs_categories", $_GET['category_id']);
      if (!$category) {
        _error(404);
      }
      /* assign variables */
      $smarty->assign('category', $category);

      // page header
      page_header(__("Blogs") . ' &rsaquo; ' . __($category['category_name']) . ' | ' . __($system['system_title']), __($category['category_description']));

      // get selected country
      if (isset($_GET['country'])) {
        /* get selected country */
        $selected_country = $user->get_country_by_name($_GET['country']);
        /* assign variables */
        $smarty->assign('selected_country', $selected_country);
      }

      // get blogs
      $smarty->assign('blogs', $user->get_blogs(["category" => $_GET['category_id'], 'country' => $selected_country['country_id']]));

      // get blogs categories (sub-categories & only parents)
      $smarty->assign('blogs_categories', $user->get_categories("blogs_categories", $_GET['category_id'], false, true));

      // get latest blogs
      $smarty->assign('latest_blogs', $user->get_blogs(['random' => "true", 'results' => 5]));

      // get ads
      $smarty->assign('ads', $user->ads('blog'));

      // get widgets
      $smarty->assign('widgets', $user->widgets('blog'));
      break;

    case 'blog':
      // get blog
      $blog = $user->get_post($_GET['post_id']);
      if (!$blog) {
        _error(404);
      }
      /* assign variables */
      $smarty->assign('blog', $blog);

      // page header
      page_header($blog['og_title'] . ' | ' . __($system['system_title']), $blog['og_description'], $blog['og_image']);

      // get blogs categories (only parents)
      $smarty->assign('blogs_categories', $user->get_categories("blogs_categories", 0, false, true));

      // get latest blogs
      $smarty->assign('latest_blogs', $user->get_blogs(['random' => "true", 'results' => 5]));

      // get ads
      $smarty->assign('ads', $user->ads('blog'));
      $smarty->assign('ads_footer', $user->ads('blog_footer'));

      // get widgets
      $smarty->assign('widgets', $user->widgets('blog'));
      break;

    case 'edit':
      // user access
      user_access();

      // check blogs permission
      if (!$user->_data['can_write_blogs']) {
        _error(404);
      }

      // page header
      page_header(__("Edit Blog") . ' | ' . __($system['system_title']), __($system['system_description_blogs']));

      // get blog
      $blog = $user->get_post($_GET['post_id']);
      if (!$blog) {
        _error(404);
      }
      /* assign variables */
      $smarty->assign('blog', $blog);

      // get blogs categories
      $smarty->assign('blogs_categories', $user->get_categories("blogs_categories"));
      break;

    case 'new':
      // user access
      user_access();

      // check blogs permission
      if (!$user->_data['can_write_blogs']) {
        _error(404);
      }

      // page header
      page_header(__("Create New Blog") . ' | ' . __($system['system_title']), __($system['system_description_blogs']));

      // prepare publisher
      /* publish-to options */
      $share_to = "timeline";
      if (isset($_GET['page'])) {
        $share_to = "page";
        $share_to_page_id = (int) $_GET['page'];
        $smarty->assign('share_to_page_id', $share_to_page_id);
      } elseif (isset($_GET['group'])) {
        $share_to = "group";
        $share_to_group_id = (int) $_GET['group'];
        $smarty->assign('share_to_group_id', $share_to_group_id);
      } elseif (isset($_GET['event'])) {
        $share_to = "event";
        $share_to_event_id = (int) $_GET['event'];
        $smarty->assign('share_to_event_id', $share_to_event_id);
      }
      $smarty->assign('share_to', $share_to);
      /* get user pages */
      $smarty->assign('pages', $user->get_pages(['get_all' => true, 'managed' => true, 'user_id' => $user->_data['user_id']]));
      /* get user groups */
      $smarty->assign('groups', $user->get_groups(['get_all' => true, 'user_id' => $user->_data['user_id']]));
      /* get user events */
      $smarty->assign('events', $user->get_events(['get_all' => true, 'user_id' => $user->_data['user_id']]));

      // get blogs categories
      $smarty->assign('blogs_categories', $user->get_categories("blogs_categories"));
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
page_footer('blogs');
