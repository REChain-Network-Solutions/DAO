<?php

/**
 * pages
 * 
 * @package Delus
 * @author Dmitry Sorokin - @sorydima & @sorydev Handles. 
 */

// fetch bootloader
require('bootloader.php');

// pages enabled
if (!$system['pages_enabled']) {
  _error(404);
}

try {

  // get selected country
  if (isset($_GET['country'])) {
    /* get selected country */
    $selected_country = $user->get_country_by_name($_GET['country']);
    /* assign variables */
    $smarty->assign('selected_country', $selected_country);
  }

  // get view content
  switch ($_GET['view']) {
    case '':
      // user access
      if ($user->_logged_in || !$system['system_public']) {
        user_access();
      }

      // page header
      page_header(__("Pages") . ' | ' . __($system['system_title']), __($system['system_description_pages']));

      // get pages categories
      $smarty->assign('categories', $user->get_categories("pages_categories"));

      // get new pages
      $pages = $user->get_pages(['suggested' => true, 'country' => $selected_country['country_id']]);
      /* assign variables */
      $smarty->assign('pages', $pages);
      $smarty->assign('get', "suggested_pages");
      $smarty->assign('view_title', __("Discover"));
      break;

    case 'category':
      // user access
      if ($user->_logged_in || !$system['system_public']) {
        user_access();
      }

      // get category
      $current_category = $user->get_category("pages_categories", $_GET['category_id'], true);
      if (!$current_category) {
        _error(404);
      }
      /* assign variables */
      $smarty->assign('current_category', $current_category);

      // page header
      page_header(__("Pages") . ' &rsaquo; ' . __($current_category['category_name']) . ' | ' . __($system['system_title']), __($current_category['category_description']));

      // get pages categories (only sub-categories)
      if (!$current_category['sub_categories'] && !$current_category['parent']) {
        $categories = $user->get_categories("pages_categories");
      } else {
        $categories = $user->get_categories("pages_categories", $current_category['category_id']);
      }
      /* assign variables */
      $smarty->assign('categories', $categories);

      // get category pages
      $pages = $user->get_pages(['suggested' => true, 'category_id' => $_GET['category_id'], 'country' => $selected_country['country_id']]);
      /* assign variables */
      $smarty->assign('pages', $pages);
      $smarty->assign('get', "category_pages");
      $smarty->assign('view_title', __($current_category['category_name']));
      break;

    case 'liked':
      // user access
      user_access();

      // page header
      page_header(__("Liked Pages") . ' | ' . __($system['system_title']));

      // get liked pages
      $pages = $user->get_pages(['user_id' => $user->_data['user_id'], 'country' => $selected_country['country_id']]);
      /* assign variables */
      $smarty->assign('pages', $pages);
      $smarty->assign('get', "liked_pages");
      $smarty->assign('view_title', __("Liked Pages"));
      break;

    case 'manage':
      // user access
      user_access();

      // page header
      page_header(__("My Pages") . ' | ' . __($system['system_title']));

      // get managed pages
      $pages = $user->get_pages(['managed' => true, 'user_id' => $user->_data['user_id'], 'country' => $selected_country['country_id']]);
      /* assign variables */
      $smarty->assign('pages', $pages);
      $smarty->assign('get', "pages");
      $smarty->assign('view_title', __("My Pages"));
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
page_footer('pages');
