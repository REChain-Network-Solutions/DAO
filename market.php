<?php

/**
 * market
 * 
 * @package Sngine
 * @author Zamblek
 */

// fetch bootloader
require('bootloader.php');

// market enabled
if (!$system['market_enabled']) {
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
      page_header(__("Marketplace") . ' | ' . __($system['system_title']), __($system['system_description_marketplace']));

      // get market categories
      $smarty->assign('categories', $user->get_categories("market_categories"));
      $smarty->assign('promoted_products', $user->get_promoted_products());
      $args['url'] = "";
      break;

    case 'search':
      // check query
      if (!isset($_GET['query']) || is_empty($_GET['query'])) {
        redirect('/market');
      }
      /* assign variables */
      $smarty->assign('query', htmlentities($_GET['query'], ENT_QUOTES, 'utf-8'));

      // page header
      page_header(__("Marketplace") . ' &rsaquo; ' . __("Search") . ' | ' . __($system['system_title']), __($system['system_description_marketplace']));

      // get market categories
      $smarty->assign('categories', $user->get_categories("market_categories"));
      $args['query'] = $_GET['query'];
      $args['url'] = "/search/" . $_GET['query'];
      break;

    case 'category':
      // check category
      $current_category = $user->get_category("market_categories", $_GET['category_id'], true);
      if (!$current_category) {
        _error(404);
      }
      /* assign variables */
      $smarty->assign('current_category', $current_category);

      // page header
      page_header(__("Marketplace") . ' &rsaquo; ' . __($current_category['category_name']) . ' | ' . __($system['system_title']), __($current_category['category_description']));

      // get market categories (only sub-categories)
      if (!$current_category['sub_categories'] && !$current_category['parent']) {
        $categories = $user->get_categories("market_categories");
      } else {
        $categories = $user->get_categories("market_categories", $current_category['category_id']);
      }
      $smarty->assign('categories', $categories);
      $args['category'] = $current_category['category_id'];
      $args['url'] = "/category/" . $current_category['category_id'] . "/" . $current_category['category_url'];
      break;

    case 'manage':
      // user access
      user_access();

      // page header
      page_header(__("My Products") . ' | ' . __($system['system_title']), __($system['system_description_marketplace']));

      $args['managed'] = true;
      $args['user_id'] = $user->_data['user_id'];
      $args['url'] = "/manage";
      break;

    case 'cart':
      // market shopping enabled
      if (!$system['market_shopping_cart_enabled']) {
        _error(404);
      }

      // page header
      page_header(__("Marketplace") . ' &rsaquo; ' . __("Cart") . ' | ' . __($system['system_title']));

      // get addresses
      $smarty->assign('addresses', $user->get_addresses());

      // get cart
      $smarty->assign('cart', $user->get_cart());
      break;

    case 'orders':
      // market shopping enabled
      if (!$system['market_shopping_cart_enabled']) {
        _error(404);
      }

      // page header
      page_header(__("Marketplace") . ' &rsaquo; ' . __("Orders") . ' | ' . __($system['system_title']));

      // get orders
      if (isset($_GET['query'])) {
        $smarty->assign('orders', $user->get_orders(['query' => $_GET['query']]));
        $smarty->assign('query', htmlentities($_GET['query'], ENT_QUOTES, 'utf-8'));
      } else {
        $smarty->assign('orders', $user->get_orders());
      }

      // get orders count
      $smarty->assign('orders_count', $user->get_orders_count());
      break;

    case 'sales':
      // market shopping enabled
      if (!$system['market_shopping_cart_enabled']) {
        _error(404);
      }

      // page header
      page_header(__("Marketplace") . ' &rsaquo; ' . __("Sales") . ' | ' . __($system['system_title']));

      // get orders
      if (isset($_GET['query'])) {
        $smarty->assign('orders', $user->get_orders(['sales_orders' => true, 'query' => $_GET['query']]));
        $smarty->assign('query', htmlentities($_GET['query'], ENT_QUOTES, 'utf-8'));
      } else {
        $smarty->assign('orders', $user->get_orders(['sales_orders' => true]));
      }

      // get orders count
      $smarty->assign('orders_count', $user->get_orders_count(true));

      // get monthly sales
      $smarty->assign('monthly_sales', $user->get_seller_monthly_sales());
      break;

    default:
      _error(404);
      break;
  }
  /* assign variables */
  $smarty->assign('view', $_GET['view']);

  // get products
  if (in_array($_GET['view'], ['', 'search', 'category', 'manage'])) {
    $smarty->assign($user->get_products($args));
  }

  // get ads
  $smarty->assign('ads', $user->ads('market'));
} catch (Exception $e) {
  _error(__("Error"), $e->getMessage());
}

// page footer
page_footer('market');
