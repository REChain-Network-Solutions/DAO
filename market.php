<?php

/**
 * market
 * 
 * @package Delus
 * @author Dmitry
 */

// fetch bootloader
require('bootloader.php');

// market enabled
if (!$system['market_enabled']) {
  _error(404);
}

// user access
if (!$system['system_public']) {
  user_access();
}

try {

  // get view content
  $_GET['view'] = (isset($_GET['view'])) ? $_GET['view'] : '';
  switch ($_GET['view']) {
    case '':
      // get promoted products
      $promoted_products = [];
      $get_promoted = $db->query("SELECT posts.post_id FROM posts INNER JOIN posts_products ON posts.post_id = posts_products.post_id WHERE posts.post_type = 'product' AND posts_products.available = '1' AND posts.boosted = '1' AND (posts.pre_approved = '1' OR posts.has_approved = '1') ORDER BY RAND() LIMIT 3");
      while ($promoted_product = $get_promoted->fetch_assoc()) {
        $promoted_product = $user->get_post($promoted_product['post_id']);
        if ($promoted_product) {
          $promoted_products[] = $promoted_product;
        }
      }
      /* assign variables */
      $smarty->assign('promoted_products', $promoted_products);

      // prepare query
      /* prepare where query */
      $where_query = "";
      /* prepare pager url */
      $url = "";

      // page header
      page_header(__("Marketplace") . ' | ' . __($system['system_title']), __($system['system_description_marketplace']));

      // get market categories
      $categories = $user->get_categories("market_categories");
      /* assign variables */
      $smarty->assign('categories', $categories);
      break;

    case 'search':
      // check query
      if (!isset($_GET['query']) || is_empty($_GET['query'])) {
        redirect('/market');
      }
      /* assign variables */
      $smarty->assign('query', htmlentities($_GET['query'], ENT_QUOTES, 'utf-8'));

      // prepare query
      /* prepare where query */
      $where_query = sprintf('AND (posts.text LIKE %1$s OR posts_products.name LIKE %1$s)', secure($_GET['query'], 'search'));
      /* prepare pager url */
      $url = "/search/" . $_GET['query'];

      // page header
      page_header(__("Marketplace") . ' &rsaquo; ' . __("Search") . ' | ' . __($system['system_title']), __($system['system_description_marketplace']));

      // get market categories
      $categories = $user->get_categories("market_categories");
      /* assign variables */
      $smarty->assign('categories', $categories);
      break;

    case 'category':
      // check category
      $current_category = $user->get_category("market_categories", $_GET['category_id'], true);
      if (!$current_category) {
        _error(404);
      }
      /* assign variables */
      $smarty->assign('current_category', $current_category);

      // prepare query
      /* prepare where query */
      $where_query = sprintf("AND posts_products.category_id = %s", secure($current_category['category_id'], 'int'));
      /* prepare pager url */
      $url = "/category/" . $current_category['category_id'] . "/" . $current_category['category_url'];

      // page header
      page_header(__("Marketplace") . ' &rsaquo; ' . __($current_category['category_name']) . ' | ' . __($system['system_title']), __($current_category['category_description']));

      // get market categories (only sub-categories)
      if (!$current_category['sub_categories'] && !$current_category['parent']) {
        $categories = $user->get_categories("market_categories");
      } else {
        $categories = $user->get_categories("market_categories", $current_category['category_id']);
      }
      /* assign variables */
      $smarty->assign('categories', $categories);
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

  // get view contnet (common)
  if (in_array($view, ['', 'search', 'category'])) {

    // prepare queries
    $distance_clause = "";
    $distance_query = "";
    $order_query = "";

    // prepare distance
    if ($user->_logged_in && $system['location_finder_enabled'] && isset($_GET['distance']) && is_numeric($_GET['distance'])) {
      /* validate distance */
      $distance = $_GET['distance'];
      $unit = ($system['system_distance'] == "mile") ? 3958 : 6371;
      $distance = ($_GET['distance'] && is_numeric($_GET['distance']) && $_GET['distance'] > 0) ? $_GET['distance'] : 25;
      $distance_clause = sprintf("(%s * acos(cos(radians(%s)) * cos(radians(user_latitude)) * cos(radians(user_longitude) - radians(%s)) + sin(radians(%s)) * sin(radians(user_latitude))) ) AS distance ", secure($unit, 'int'), secure($user->_data['user_latitude']), secure($user->_data['user_longitude']), secure($user->_data['user_latitude']));
      $distance_query .= sprintf(" HAVING distance < %s ", secure($distance, 'int'));
      $order_query .= " ORDER BY distance ASC ";
    }

    // prepare sort
    $order_query .= ($order_query) ? "," : " ORDER BY ";
    switch ($_GET['sort']) {
      case '':
      case 'latest':
        $order_query .= " posts.post_id DESC ";
        break;

      case 'price-high':
        $order_query .= " posts_products.price DESC ";
        break;

      case 'price-low':
        $order_query .= " posts_products.price ASC ";
        break;

      default:
        _error(404);
        break;
    }

    // get products
    require('includes/class-pager.php');
    $params['selected_page'] = (!isset($_GET['page']) || (int) $_GET['page'] == 0) ? 1 : $_GET['page'];
    $distance_max_clause = ($distance_clause) ? ", MAX" . $distance_clause : "";
    $total = $db->query("SELECT COUNT(*) as count " . $distance_max_clause . " FROM posts INNER JOIN posts_products ON posts.post_id = posts_products.post_id INNER JOIN users ON posts.user_id = users.user_id WHERE posts.post_type = 'product' AND posts_products.available = '1' AND (posts.pre_approved = '1' OR posts.has_approved = '1')" . $where_query . $distance_query . $order_query);
    $params['total_items'] = $total->fetch_assoc()['count'];
    $params['items_per_page'] = $system['marketplace_results'];
    $params['url'] = $system['system_url'] . '/market' . $url . '/%s';
    $params['url'] .= (isset($distance)) ? "?distance=" . $distance : "";
    if (isset($_GET['sort'])) {
      $params['url'] .= ($distance) ? "&" : "?";
      $params['url'] .= "sort=" . $_GET['sort'];
    }
    $pager = new Pager($params);
    $limit_query = $pager->getLimitSql();

    // get posts
    $rows = [];
    $distance_clause = ($distance_clause) ? ", " . $distance_clause : "";
    $get_rows = $db->query("SELECT posts.post_id " . $distance_clause . " FROM posts INNER JOIN posts_products ON posts.post_id = posts_products.post_id INNER JOIN users ON posts.user_id = users.user_id WHERE posts.post_type = 'product' AND posts_products.available = '1' AND (posts.pre_approved = '1' OR posts.has_approved = '1')" . $where_query . $distance_query . $order_query . $limit_query);
    while ($row = $get_rows->fetch_assoc()) {
      $row = $user->get_post($row['post_id']);
      if ($row) {
        $rows[] = $row;
      }
    }
    /* assign variables */
    $smarty->assign('sort', $_GET['sort']);
    $smarty->assign('distance', ($distance) ? htmlentities($distance, ENT_QUOTES, 'utf-8') : '');
    $smarty->assign('rows', $rows);
    $smarty->assign('total', $params['total_items']);
    $smarty->assign('pager', $pager->getPager());
  }

  // get ads
  $ads = $user->ads('market');
  /* assign variables */
  $smarty->assign('ads', $ads);
} catch (Exception $e) {
  _error(__("Error"), $e->getMessage());
}

// page footer
page_footer('market');
