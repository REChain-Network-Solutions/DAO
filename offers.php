<?php

/**
 * offers
 * 
 * @package Sngine
 * @author Zamblek
 */

// fetch bootloader
require('bootloader.php');

// offers enabled
if (!$system['offers_enabled']) {
  _error(404);
}

// user access
if ($user->_logged_in || !$system['system_public']) {
  user_access();
}

// check if user can view offers
if (!$user->_data['can_read_offers']) {
  _error('PERMISSION');
}

try {

  // get view content
  $_GET['view'] = (isset($_GET['view'])) ? $_GET['view'] : '';
  switch ($_GET['view']) {
    case '':
      // get promoted offers
      $promoted_offers = [];
      $get_promoted = $db->query("SELECT posts.post_id FROM posts INNER JOIN posts_offers ON posts.post_id = posts_offers.post_id WHERE posts.in_group = '0' AND posts.in_event = '0' AND posts.post_type = 'offer' AND posts.boosted = '1' AND (posts.pre_approved = '1' OR posts.has_approved = '1') ORDER BY RAND() LIMIT 3");
      while ($promoted_offer = $get_promoted->fetch_assoc()) {
        $promoted_offer = $user->get_post($promoted_offer['post_id']);
        if ($promoted_offer) {
          $promoted_offers[] = $promoted_offer;
        }
      }
      /* assign variables */
      $smarty->assign('promoted_offers', $promoted_offers);

      // prepare query
      /* prepare where query */
      $where_query = "";
      /* prepare pager url */
      $url = "";

      // page header
      page_header(__("Offers") . ' | ' . __($system['system_title']), __($system['system_description_offers']));

      // get offers categories
      $categories = $user->get_categories("offers_categories");
      /* assign variables */
      $smarty->assign('categories', $categories);
      break;

    case 'search':
      // check query
      if (!isset($_GET['query']) || is_empty($_GET['query'])) {
        redirect('/offers');
      }
      /* assign variables */
      $smarty->assign('query', htmlentities($_GET['query'], ENT_QUOTES, 'utf-8'));

      // prepare query
      /* prepare where query */
      $where_query = sprintf('AND (posts.text LIKE %1$s OR posts_offers.title LIKE %1$s)', secure($_GET['query'], 'search'));
      /* prepare pager url */
      $url = "/search/" . $_GET['query'];

      // page header
      page_header(__("Offers") . ' &rsaquo; ' . __("Search") . ' | ' . __($system['system_title']), __($system['system_description_offers']));

      // get offers categories
      $categories = $user->get_categories("offers_categories");
      /* assign variables */
      $smarty->assign('categories', $categories);
      break;

    case 'category':
      // check category
      $current_category = $user->get_category("offers_categories", $_GET['category_id'], true);
      if (!$current_category) {
        _error(404);
      }
      /* assign variables */
      $smarty->assign('current_category', $current_category);

      // prepare query
      /* prepare where query */
      $where_query = sprintf("AND posts_offers.category_id = %s", secure($current_category['category_id'], 'int'));
      /* prepare pager url */
      $url = "/category/" . $current_category['category_id'] . "/" . $current_category['category_url'];

      // page header
      page_header(__("Offers") . ' &rsaquo; ' . __($current_category['category_name']) . ' | ' . __($system['system_title']), __($current_category['category_description']));

      // get offers categories (only sub-categories)
      if (!$current_category['sub_categories'] && !$current_category['parent']) {
        $categories = $user->get_categories("offers_categories");
      } else {
        $categories = $user->get_categories("offers_categories", $current_category['category_id']);
      }
      /* assign variables */
      $smarty->assign('categories', $categories);
      break;

    default:
      _error(404);
      break;
  }

  // prepare queries
  $distance_clause = "";
  $distance_query = "";
  $order_query = "";
  $country_query = "";

  // prepare distance
  if ($user->_logged_in && $system['location_finder_enabled'] && isset($_GET['distance']) && is_numeric($_GET['distance'])) {
    /* validate distance */
    $distance = $_GET['distance'];
    $unit = ($system['system_distance'] == "mile") ? 3958 : 6371;
    $distance = ($_GET['distance'] && is_numeric($_GET['distance']) && $_GET['distance'] > 0) ? $_GET['distance'] : 25;
    $distance_clause = sprintf("(%s * acos(cos(radians(%s)) * cos(radians(post_latitude)) * cos(radians(post_longitude) - radians(%s)) + sin(radians(%s)) * sin(radians(post_latitude))) ) AS distance ", secure($unit, 'int'), secure($user->_data['user_latitude']), secure($user->_data['user_longitude']), secure($user->_data['user_latitude']));
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

    case 'expire-soon':
      $order_query .= " posts_offers.end_date ASC ";
      break;

    case 'expire-latest':
      $order_query .= " posts_offers.end_date DESC ";
      break;

    default:
      _error(404);
      break;
  }

  // prepare country 
  if ($system['newsfeed_location_filter_enabled'] && isset($_GET['country']) && $_GET['country'] != "all") {
    /* get selected country */
    $selected_country = $user->get_country_by_name($_GET['country']);
    /* assign variables */
    $smarty->assign('selected_country', $selected_country);
    /* prepare country query */
    if ($selected_country) {
      $country_query .= sprintf(" AND ( (posts.user_type = 'user' AND user_post_author.user_country = %s) OR (posts.user_type = 'page' AND page_post_author.page_country = %s) )", secure($selected_country['country_id'], 'int'), secure($selected_country['country_id'], 'int'));
    }
  }

  // get offers
  require('includes/class-pager.php');
  $params['selected_page'] = (!isset($_GET['page']) || (int) $_GET['page'] == 0) ? 1 : $_GET['page'];
  $distance_max_clause = ($distance_clause) ? ", MAX" . $distance_clause : "";
  $author_join = " LEFT JOIN users AS user_post_author ON posts.user_type = 'user' AND posts.user_id = user_post_author.user_id AND user_post_author.user_banned = '0' LEFT JOIN pages AS page_post_author ON posts.user_type = 'page' AND posts.user_id = page_post_author.page_id ";
  $total = $db->query("SELECT COUNT(*) as count " . $distance_max_clause . " FROM posts INNER JOIN posts_offers ON posts.post_id = posts_offers.post_id " . $author_join . " WHERE posts.in_group = '0' AND posts.in_event = '0' AND (posts.pre_approved = '1' OR posts.has_approved = '1')" . $where_query . $country_query . $distance_query . $order_query);
  $params['total_items'] = $total->fetch_assoc()['count'];
  $params['items_per_page'] = $system['offers_results'];
  $params['url'] = $system['system_url'] . '/offers' . $url . '/%s';
  if (isset($selected_country)) {
    $params['url'] .= "?country=" . $selected_country['country_name'];
  }
  if (isset($_GET['distance'])) {
    $params['url'] .= ($selected_country) ? "&" : "?";
    $params['url'] .= "distance=" . $_GET['distance'];
  }
  if (isset($_GET['sort'])) {
    $params['url'] .= ($selected_country || $distance) ? "&" : "?";
    $params['url'] .= "sort=" . $_GET['sort'];
  }
  $pager = new Pager($params);
  $limit_query = $pager->getLimitSql();

  // get posts
  $rows = [];
  $distance_clause = ($distance_clause) ? ", " . $distance_clause : "";
  $get_rows = $db->query("SELECT posts.post_id " . $distance_clause . " FROM posts INNER JOIN posts_offers ON posts.post_id = posts_offers.post_id " . $author_join . " WHERE posts.in_group = '0' AND posts.in_event = '0' AND (posts.pre_approved = '1' OR posts.has_approved = '1')" . $where_query . $country_query . $distance_query . $order_query . $limit_query);
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
  $smarty->assign('view', $_GET['view']);

  // get ads
  $ads = $user->ads('offers');
  /* assign variables */
  $smarty->assign('ads', $ads);
} catch (Exception $e) {
  _error(__("Error"), $e->getMessage());
}

// page footer
page_footer('offers');
