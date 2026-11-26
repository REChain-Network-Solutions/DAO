<?php

/**
 * trait -> offers
 * 
 * @package Sngine
 * @author Zamblek
 */

trait OffersTrait
{

  /* ------------------------------- */
  /* Offers */
  /* ------------------------------- */

  /**
   * get_promoted_offers
   * 
   * @return array
   */
  public function get_promoted_offers()
  {
    return $this->get_promoted_posts('offer', 'posts_offers');
  }


  /**
   * get_offers
   * 
   * @param array $args
   * @return array
   */
  public function get_offers($args = [])
  {
    global $db, $system;
    $category = $args['category'] ?? null;
    $query = $args['query'] ?? null;
    $managed = !empty($args['managed']);
    $user_id = $args['user_id'] ?? null;
    $sort = $args['sort'] ?? '';
    $country = $args['country'] ?? null;
    $distance = null;
    $order_query = "";
    $country_query = "";
    $where_query = "";
    $selected_country = null;
    $url = $args['url'] ?? '';

    if ($query) {
      $where_query .= " AND " . $this->posts_search_clause($query, sprintf('(posts.text LIKE %1$s OR posts_offers.title LIKE %1$s)', secure($query, 'search')));
    }
    if ($category) {
      $where_query .= sprintf("AND posts_offers.category_id = %s", secure($category, 'int'));
    }
    if ($user_id) {
      $where_query .= sprintf(" AND posts.user_type = 'user' AND posts.user_id = %s", secure($user_id, 'int'));
    }

    if ($this->_logged_in && $system['location_finder_enabled'] && isset($args['distance']) && is_numeric($args['distance'])) {
      $distance = ($args['distance'] && is_numeric($args['distance']) && $args['distance'] > 0) ? $args['distance'] : 25;
    }

    $order_query .= ($order_query) ? "," : " ORDER BY ";
    switch ($sort) {
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

    if ($system['newsfeed_location_filter_enabled'] && $country && $country != "all") {
      $selected_country = $this->get_country_by_name($country);
      if ($selected_country) {
        $country_query .= sprintf(" AND ( (posts.user_type = 'user' AND user_post_author.user_country = %s) OR (posts.user_type = 'page' AND page_post_author.page_country = %s) )", secure($selected_country['country_id'], 'int'), secure($selected_country['country_id'], 'int'));
      }
    }

    require_once(ABSPATH . 'includes/class-pager.php');
    $params['selected_page'] = (!isset($args['page']) || (int) $args['page'] == 0) ? 1 : $args['page'];
    $author_join = " LEFT JOIN users AS user_post_author ON posts.user_type = 'user' AND posts.user_id = user_post_author.user_id AND user_post_author.user_banned = '0' LEFT JOIN pages AS page_post_author ON posts.user_type = 'page' AND posts.user_id = page_post_author.page_id ";
    $approval_query = ($managed) ? "" : " AND (posts.pre_approved = '1' OR posts.has_approved = '1')";
    $from_query = " FROM posts INNER JOIN posts_offers ON posts.post_id = posts_offers.post_id " . $author_join . " WHERE posts.in_group = '0' AND posts.in_event = '0'" . $approval_query . $where_query . $country_query;
    /* around the viewer when a distance is set */
    $listing_ids = ($distance) ? $this->get_nearby_listing_ids('offer', $distance, $from_query, $order_query) : null;
    $params['total_items'] = ($listing_ids !== null) ? count($listing_ids) : $db->query("SELECT COUNT(*) as count" . $from_query)->fetch_assoc()['count'];
    $params['items_per_page'] = $system['offers_results'];
    $params['url'] = $system['system_url'] . '/offers' . $url . '/%s';
    if (isset($selected_country)) {
      $params['url'] .= "?country=" . $selected_country['country_name'];
    }
    if (isset($args['distance'])) {
      $params['url'] .= ($selected_country) ? "&" : "?";
      $params['url'] .= "distance=" . $args['distance'];
    }
    if (isset($args['sort']) && $args['sort'] !== '') {
      $params['url'] .= ($selected_country || $distance) ? "&" : "?";
      $params['url'] .= "sort=" . $args['sort'];
    }
    $pager = new Pager($params);
    $limit_query = $pager->getLimitSql();

    $rows = [];
    if ($listing_ids !== null) {
      $posts_ids = array_slice($listing_ids, $pager->getOffset(), $params['items_per_page']);
    } else {
      $posts_ids = array_column($db->query("SELECT posts.post_id" . $from_query . $order_query . $limit_query)->fetch_all(MYSQLI_ASSOC), 'post_id');
    }
    foreach ($posts_ids as $post_id) {
      $row = $this->get_post($post_id);
      if ($row) {
        $rows[] = $row;
      }
    }

    return [
      'rows' => $rows,
      'total' => $params['total_items'],
      'pager' => $pager->getPager(),
      'sort' => $sort,
      'distance' => ($distance) ? htmlentities($distance, ENT_QUOTES, 'utf-8') : '',
      'selected_country' => $selected_country,
    ];
  }
}
