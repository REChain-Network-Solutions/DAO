<?php

/**
 * jobs
 * 
 * @package Sngine
 * @author Zamblek
 */

// fetch bootloader
require('bootloader.php');

// jobs enabled
if (!$system['jobs_enabled']) {
  _error(404);
}

// user access
if ($user->_logged_in || !$system['system_public']) {
  user_access();
}

try {

  // get view content
  $_GET['view'] = (isset($_GET['view'])) ? $_GET['view'] : '';
  $args = [
    'sort' => $_GET['sort'] ?? '',
    'country' => $_GET['country'] ?? null,
    'distance' => $_GET['distance'] ?? null,
    'page' => $_GET['page'] ?? 1,
  ];
  switch ($_GET['view']) {
    case '':
      // page header
      page_header(__("Jobs") . ' | ' . __($system['system_title']), __($system['system_description_jobs']));

      // get jobs categories
      $smarty->assign('categories', $user->get_categories("jobs_categories"));
      $smarty->assign('promoted_jobs', $user->get_promoted_jobs());
      $args['url'] = "";
      break;

    case 'search':
      // check query
      if (!isset($_GET['query']) || is_empty($_GET['query'])) {
        redirect('/jobs');
      }
      /* assign variables */
      $smarty->assign('query', htmlentities($_GET['query'], ENT_QUOTES, 'utf-8'));

      // page header
      page_header(__("Jobs") . ' &rsaquo; ' . __("Search") . ' | ' . __($system['system_title']), __($system['system_description_jobs']));

      // get jobs categories
      $smarty->assign('categories', $user->get_categories("jobs_categories"));
      $args['query'] = $_GET['query'];
      $args['url'] = "/search/" . $_GET['query'];
      break;

    case 'category':
      // check category
      $current_category = $user->get_category("jobs_categories", $_GET['category_id'], true);
      if (!$current_category) {
        _error(404);
      }
      /* assign variables */
      $smarty->assign('current_category', $current_category);

      // page header
      page_header(__("Jobs") . ' &rsaquo; ' . __($current_category['category_name']) . ' | ' . __($system['system_title']), __($current_category['category_description']));

      // get jobs categories (only sub-categories)
      if (!$current_category['sub_categories'] && !$current_category['parent']) {
        $categories = $user->get_categories("jobs_categories");
      } else {
        $categories = $user->get_categories("jobs_categories", $current_category['category_id']);
      }
      $smarty->assign('categories', $categories);
      $args['category'] = $current_category['category_id'];
      $args['url'] = "/category/" . $current_category['category_id'] . "/" . $current_category['category_url'];
      break;

    case 'manage':
      // user access
      user_access();

      // page header
      page_header(__("My Jobs") . ' | ' . __($system['system_title']), __($system['system_description_jobs']));

      $args['managed'] = true;
      $args['user_id'] = $user->_data['user_id'];
      $args['url'] = "/manage";
      break;

    default:
      _error(404);
      break;
  }

  // get jobs
  $smarty->assign($user->get_jobs($args));
  $smarty->assign('view', $_GET['view']);

  // get ads
  $smarty->assign('ads', $user->ads('jobs'));
} catch (Exception $e) {
  _error(__("Error"), $e->getMessage());
}

// page footer
page_footer('jobs');
