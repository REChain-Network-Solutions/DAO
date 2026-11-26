<?php

/**
 * trait -> blogs
 * 
 * @package Sngine
 * @author Zamblek
 */

trait BlogsTrait
{

  /* ------------------------------- */
  /* Blogs */
  /* ------------------------------- */

  /**
   * get_blogs
   * 
   * @param array $args
   * @return array
   */
  public function get_blogs($args = [])
  {
    global $db, $system;
    /* initialize arguments */
    $category = !isset($args['category']) ? null : $args['category'];
    $country = !isset($args['country']) ? null : $args['country'];
    $user_id = !isset($args['user_id']) ? null : $args['user_id'];
    $managed = !empty($args['managed']);
    $offset = !isset($args['offset']) ? 0 : $args['offset'];
    $random = filter_var($args['random'] ?? false, FILTER_VALIDATE_BOOLEAN);
    $results = !isset($args['results']) ? $system['blogs_results'] : $args['results'];
    /* initialize vars */
    $posts = [];
    $offset *= $results;
    $country_query = "";
    $where_query = "";
    /* prepare country statement */
    if ($country && $system['newsfeed_location_filter_enabled'] && $country != "all") {
      $country_query .= sprintf(" AND ( (posts.user_type = 'user' AND user_post_author.user_country = %s) OR (posts.user_type = 'page' AND page_post_author.page_country = %s) )", secure($country, 'int'), secure($country, 'int'));
    }
    /* get posts */
    if ($category != null) {
      $where_query .= sprintf(" AND posts_articles.category_id = %s", secure($args['category'], 'int'));
    }
    if ($user_id) {
      $where_query .= sprintf(" AND posts.user_type = 'user' AND posts.user_id = %s", secure($user_id, 'int'));
    }
    $approval_query = ($managed) ? "" : " AND (posts.pre_approved = '1' OR posts.has_approved = '1') AND (posts.is_schedule = '0' OR posts.time <= NOW())";
    $from_query = "FROM posts INNER JOIN posts_articles ON posts.post_id = posts_articles.post_id AND posts.post_type = 'article' LEFT JOIN users AS user_post_author ON posts.user_type = 'user' AND posts.user_id = user_post_author.user_id AND user_post_author.user_banned = '0' LEFT JOIN pages AS page_post_author ON posts.user_type = 'page' AND posts.user_id = page_post_author.page_id WHERE posts.in_group = '0' AND posts.in_event = '0'" . $approval_query . $where_query . $country_query;
    if ($random) {
      /* random articles, sampled through the articles ids (or the category) */
      $articles_posts = [];
      $articles_ids = sample_ids('posts_articles', 'article_id', ($category != null) ? sprintf("category_id = %s", secure($category, 'int')) : "article_id > 0", $results, [
        'pivots' => 3,
        'filter' => function ($ids) use ($db, $from_query, &$articles_posts) {
          $get_articles = $db->query(sprintf("SELECT posts_articles.article_id, posts.post_id " . $from_query . " AND posts_articles.article_id IN (%s)", implode(',', $ids)));
          while ($article = $get_articles->fetch_assoc()) {
            $articles_posts[$article['article_id']] = $article['post_id'];
          }
          return array_keys($articles_posts);
        },
      ]);
      $posts_ids = array_map(fn($article_id) => $articles_posts[$article_id], $articles_ids);
    } else {
      $get_posts = $db->query(sprintf("SELECT posts.post_id " . $from_query . " ORDER BY posts.post_id DESC LIMIT %s, %s", secure($offset, 'int', false), secure($results, 'int', false)));
      $posts_ids = array_column($get_posts->fetch_all(MYSQLI_ASSOC), 'post_id');
    }
    if ($posts_ids) {
      /* load the articles in one batch (no comments) */
      $previous_prefetch = $this->_posts_prefetch;
      $this->prefetch_posts($posts_ids, false);
      try {
        foreach ($posts_ids as $post_id) {
          $post = $this->get_post($post_id, false, false, true);
          if ($post) {
            $posts[] = $post;
          }
        }
      } finally {
        $this->_posts_prefetch = $previous_prefetch;
      }
    }
    return $posts;
  }


  /**
   * get_promoted_blogs
   * 
   * @return array
   */
  public function get_promoted_blogs()
  {
    return $this->get_promoted_posts('article', 'posts_articles', ['scheduled' => true, 'get_comments' => false, 'pass_views' => true]);
  }


  /**
   * get_blogs_listing
   * 
   * @param array $args
   * @return array
   */
  public function get_blogs_listing($args = [])
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
      $legacy_query = ($system['blogs_search_content_enabled']) ? '(posts.text LIKE %1$s OR posts_articles.title LIKE %1$s OR posts_articles.tags LIKE %1$s OR posts_articles.text LIKE %1$s)' : '(posts.text LIKE %1$s OR posts_articles.title LIKE %1$s OR posts_articles.tags LIKE %1$s)';
      $where_query .= " AND " . $this->posts_search_clause($query, sprintf($legacy_query, secure($query, 'search')));
    }
    if ($category) {
      $where_query .= sprintf("AND posts_articles.category_id = %s", secure($category, 'int'));
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
    $approval_query = ($managed) ? "" : " AND (posts.pre_approved = '1' OR posts.has_approved = '1') AND (posts.is_schedule = '0' OR posts.time <= NOW())";
    $from_query = " FROM posts INNER JOIN posts_articles ON posts.post_id = posts_articles.post_id AND posts.post_type = 'article' " . $author_join . " WHERE posts.in_group = '0' AND posts.in_event = '0'" . $approval_query . $where_query . $country_query;
    /* around the viewer when a distance is set */
    $listing_ids = ($distance) ? $this->get_nearby_listing_ids('article', $distance, $from_query, $order_query) : null;
    $params['total_items'] = ($listing_ids !== null) ? count($listing_ids) : $db->query("SELECT COUNT(*) as count" . $from_query)->fetch_assoc()['count'];
    $params['items_per_page'] = $system['blogs_results'];
    $params['url'] = $system['system_url'] . '/blogs' . $url . '/%s';
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
      $row = $this->get_post($post_id, false, false, true);
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


  /**
   * get_blogs_feed
   * 
   * @param array $args
   * @return void
   */
  public function get_blogs_feed($args = [])
  {
    global $db, $system;
    if (!$system['blogs_enabled'] || !$system['blogs_rss_enabled']) {
      _error(404);
    }
    $category_id = $args['category_id'] ?? null;
    $channel_title = __("Blogs") . ' | ' . __($system['system_title']);
    $channel_link = $system['system_url'] . '/blogs';
    $channel_description = __($system['system_description_blogs']);
    $feed_url = $system['system_url'] . '/blogs/rss';
    $where_query = "";
    if ($category_id) {
      $current_category = $this->get_category("blogs_categories", $category_id, true);
      if (!$current_category) {
        _error(404);
      }
      $where_query .= sprintf(" AND posts_articles.category_id = %s", secure($current_category['category_id'], 'int'));
      $channel_title = __("Blogs") . ' › ' . __($current_category['category_name']) . ' | ' . __($system['system_title']);
      $channel_link = $system['system_url'] . '/blogs/category/' . $current_category['category_id'] . '/' . $current_category['category_url'];
      if ($current_category['category_description']) {
        $channel_description = __($current_category['category_description']);
      }
      $feed_url = $channel_link . '/rss';
    }
    $items = [];
    $get_posts = $db->query(sprintf("SELECT posts.post_id, posts.time, posts_articles.title, posts_articles.cover FROM posts INNER JOIN posts_articles ON posts.post_id = posts_articles.post_id AND posts.post_type = 'article' LEFT JOIN users AS user_post_author ON posts.user_type = 'user' AND posts.user_id = user_post_author.user_id AND user_post_author.user_banned = '0' LEFT JOIN pages AS page_post_author ON posts.user_type = 'page' AND posts.user_id = page_post_author.page_id WHERE posts.in_group = '0' AND posts.in_event = '0' AND posts.in_wall = '0' AND posts.privacy = 'public' AND posts.is_hidden = '0' AND (posts.is_schedule = '0' OR posts.time <= NOW()) AND (posts.pre_approved = '1' OR posts.has_approved = '1')" . $where_query . " ORDER BY posts.post_id DESC LIMIT %s", secure($system['blogs_results'], 'int', false)));
    if ($get_posts->num_rows > 0) {
      while ($row = $get_posts->fetch_assoc()) {
        $post = $this->get_post($row['post_id'], false, false, true);
        if (!$post) {
          continue;
        }
        $title = (!empty($post['blog']['title'])) ? $post['blog']['title'] : $row['title'];
        $title_url = (!empty($post['blog']['title_url'])) ? $post['blog']['title_url'] : get_url_text($title);
        $link = $system['system_url'] . '/blogs/' . $post['post_id'] . '/' . $title_url;
        $locked = !empty($post['needs_payment']) || !empty($post['needs_subscription']) || !empty($post['needs_pro_package']) || !empty($post['needs_age_verification']);
        $item = [
          'title' => $title,
          'link' => $link,
          'pubDate' => date(DATE_RSS, strtotime($post['time'])),
          'locked' => $locked,
          'description' => '',
        ];
        if ($locked) {
          $item['description'] = $post['paid_text'] ?? '';
        } else {
          $item['creator'] = $post['post_author_name'] ?? '';
          $item['category'] = $post['blog']['category_name'] ?? '';
          $item['description'] = $post['blog']['parsed_text'] ?? '';
          if (!empty($post['blog']['cover'])) {
            $ext = strtolower(pathinfo($post['blog']['cover'], PATHINFO_EXTENSION));
            $mimes = ['jpg' => 'image/jpeg', 'jpeg' => 'image/jpeg', 'png' => 'image/png', 'gif' => 'image/gif', 'webp' => 'image/webp'];
            $item['enclosure'] = [
              'url' => $post['blog']['parsed_cover'],
              'type' => $mimes[$ext] ?? 'image/jpeg',
            ];
          }
        }
        $items[] = $item;
      }
    }
    $xml_escape = function ($value) {
      return htmlspecialchars((string) $value, ENT_XML1 | ENT_QUOTES, 'UTF-8');
    };
    $language = str_replace('_', '-', $system['language']['code']);
    $xml = '<?xml version="1.0" encoding="UTF-8"?>' . "\n";
    $xml .= '<rss version="2.0" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:atom="http://www.w3.org/2005/Atom">' . "\n";
    $xml .= "  <channel>\n";
    $xml .= "    <title>" . $xml_escape($channel_title) . "</title>\n";
    $xml .= "    <link>" . $xml_escape($channel_link) . "</link>\n";
    $xml .= "    <description>" . $xml_escape($channel_description) . "</description>\n";
    $xml .= "    <language>" . $xml_escape($language) . "</language>\n";
    $xml .= '    <atom:link href="' . $xml_escape($feed_url) . '" rel="self" type="application/rss+xml" />' . "\n";
    foreach ($items as $item) {
      $xml .= "    <item>\n";
      $xml .= "      <title>" . $xml_escape($item['title']) . "</title>\n";
      $xml .= "      <link>" . $xml_escape($item['link']) . "</link>\n";
      $xml .= '      <guid isPermaLink="true">' . $xml_escape($item['link']) . "</guid>\n";
      $xml .= "      <pubDate>" . $xml_escape($item['pubDate']) . "</pubDate>\n";
      if (!$item['locked']) {
        if ($item['creator'] !== '') {
          $xml .= "      <dc:creator>" . $xml_escape($item['creator']) . "</dc:creator>\n";
        }
        if ($item['category'] !== '') {
          $xml .= "      <category>" . $xml_escape($item['category']) . "</category>\n";
        }
        if (!empty($item['enclosure'])) {
          $xml .= '      <enclosure url="' . $xml_escape($item['enclosure']['url']) . '" length="0" type="' . $xml_escape($item['enclosure']['type']) . '" />' . "\n";
        }
      }
      if ($item['description'] !== '') {
        $xml .= "      <description><![CDATA[" . str_replace(']]>', ']]]]><![CDATA[>', $item['description']) . "]]></description>\n";
      }
      $xml .= "    </item>\n";
    }
    $xml .= "  </channel>\n";
    $xml .= "</rss>";
    header('Content-Type: application/rss+xml; charset=UTF-8');
    echo $xml;
    exit;
  }


  /**
   * post_blog
   * 
   * @param string $publish_to
   * @param string $page_id
   * @param string $group_id
   * @param string $event_id
   * @param string $title
   * @param string $text
   * @param string $cover
   * @param integer $category_id
   * @param string $tags
   * @param array $references
   * @param boolean $tips_enabled
   * @param boolean $for_subscriptions
   * @param boolean $is_paid
   * @param float $post_price
   * @param string $paid_text
   * @param boolean $is_collaborative
   * @param array $collaborative_users
   * @param float $collaborative_percent
   * @param boolean $for_adult
   * @param string $subscriptions_image
   * @param string $paid_image
   * @param boolean $is_schedule
   * @param string $schedule_date
   * @return integer
   */
  public function post_blog($publish_to, $page_id, $group_id, $event_id, $title, $text, $cover, $category_id, $tags, $references, $tips_enabled, $for_subscriptions, $is_paid, $post_price, $paid_text, $is_collaborative, $collaborative_users, $collaborative_percent, $for_adult = null, $subscriptions_image = '', $paid_image = '', $is_schedule = null, $schedule_date = '')
  {
    global $db, $system, $date;
    /* prepare */
    $tips_enabled = (isset($tips_enabled)) ? '1' : '0';
    $for_subscriptions = (isset($for_subscriptions)) ? '1' : '0';
    $is_paid = (isset($is_paid)) ? '1' : '0';
    $is_collaborative = (isset($is_collaborative)) ? '1' : '0';
    $for_adult = ($system['adult_mode'] && isset($for_adult)) ? '1' : '0';
    $is_schedule = (isset($is_schedule)) ? '1' : '0';
    /* check if blogs enabled */
    if (!$system['blogs_enabled']) {
      throw new ValidationException(__("The blogs module has been disabled by the admin"));
    }
    /* check blogs permission */
    if (!$this->_data['can_write_blogs']) {
      throw new ValidationException(__("You don't have the permission to do this"));
    }
    /* check if verification for posts required */
    if ($system['verification_for_posts'] && !$this->_data['user_verified']) {
      throw new ValidationException(__("To use this feature your account must be verified"));
    }
    /* check max posts/hour limit */
    $this->check_posts_limit(($publish_to == 'page') ? 'page' : 'user', ($publish_to == 'page') ? $page_id : null);
    /* check scheduled posts permission */
    if ($is_schedule) {
      if (!$this->_data['can_schedule_posts']) {
        throw new ValidationException(__("You don't have the permission to add scheduled posts"));
      }
      if (!is_string($schedule_date) || !preg_match('/^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$/', $schedule_date) || strtotime($schedule_date) <= time()) {
        throw new ValidationException(__("Select a valid date and time for your scheduled post"));
      }
    }
    /* check adult posts permission */
    if ($for_adult && $system['verification_for_adult_content'] && !$this->_data['user_verified']) {
      throw new ValidationException(__("Your account must be verified to share adult content"));
    }
    /* check tips permission */
    if (!$this->_data['can_receive_tip'] && $tips_enabled) {
      throw new ValidationException(__("You don't have the permission to do this"));
    }
    /* check monetization permission */
    if ($for_subscriptions) {
      switch ($publish_to) {
        case 'timeline':
          if (!($this->_data['can_monetize_content'] && $this->_data['user_monetization_enabled'] && $this->_data['user_monetization_plans'] > 0)) {
            throw new ValidationException(__("You don't have the permission to do this"));
          }
          break;

        case 'page':
          /* check if the page is valid */
          $page = $this->get_page($page_id);
          if (!$page) {
            _error(400);
          }
          /* check if page's admin can monetize content */
          $page['can_monetize_content'] = $system['monetization_enabled'] && $this->check_user_permission($page['page_admin'], 'monetization_permission');
          /* check if page has monetization enabled && subscriptions plans */
          if (!($page['can_monetize_content'] && $page['page_monetization_enabled'] && $page['page_monetization_plans'] > 0)) {
            throw new ValidationException(__("You don't have the permission to do this"));
          }
          break;

        case 'group':
          /* check if the group is valid */
          $group = $this->get_group($group_id);
          if (!$group) {
            _error(400);
          }
          /* check if group's admin can monetize content */
          $group['can_monetize_content'] = $system['monetization_enabled'] && $this->check_user_permission($group['group_admin'], 'monetization_permission');
          /* check if group has monetization enabled && subscriptions plans */
          if (!($group['can_monetize_content'] && $group['group_monetization_enabled'] && $group['group_monetization_plans'] > 0)) {
            throw new ValidationException(__("You don't have the permission to do this"));
          }
          break;

        default:
          throw new ValidationException(__("You don't have the permission to do this"));
          break;
      }
    }
    /* check if both for_subscriptions & is_paid enabled */
    if ($for_subscriptions && $is_paid) {
      throw new ValidationException(__("You can't enable both subscribers only & paid post"));
    }
    /* check paid posts permission */
    if (!$this->_data['can_monetize_content'] && !$this->_data['user_monetization_enabled'] && $is_paid) {
      throw new ValidationException(__("You don't have the permission to do this"));
    }
    /* check is_collaborative */
    if ($is_collaborative) {
      /* check if for_subscriptions post */
      if ($for_subscriptions) {
        throw new ValidationException(__("You can not collaborate with for subscriptions post"));
      }
      /* validate collaborative users */
      $collaborative_users_ids = $this->validate_collaborative_users($collaborative_users);
      /* check if paid post */
      if ($is_paid) {
        /* check if collaborative percent is valid */
        if (!is_numeric($collaborative_percent) || $collaborative_percent < 0 || $collaborative_percent > 100) {
          throw new ValidationException(__("Please enter a valid percentage"));
        }
      }
    }
    /* validate title */
    if (is_empty($title)) {
      throw new ValidationException(__("You must enter a title for your blog"));
    }
    if (strlen($title) < 3) {
      throw new ValidationException(__("Title must be at least 3 characters long. Please try another"));
    }
    /* validate text */
    if (is_empty($text)) {
      throw new ValidationException(__("You must enter some text for your blog"));
    }
    /* validate category */
    if (is_empty($category_id)) {
      throw new ValidationException(__("You must select valid category for your blog"));
    }
    $category = $this->get_category('blogs_categories', $category_id);
    if (!$category) {
      throw new ValidationException(__("You must select valid category for your blog"));
    }
    /* validate cover */
    if ($system['blogs_cover_required'] && is_empty($cover)) {
      throw new ValidationException(__("You must upload a cover image for your blog"));
    }
    /* validate references */
    if ($references) {
      foreach ($references as $key => $reference) {
        /* remove empty references */
        if (is_empty($reference['title']) && is_empty($reference['link'])) {
          unset($references[$key]);
          continue;
        }
        /* validate title */
        if (is_empty($reference['title'])) {
          throw new ValidationException(__("You must enter a title for your reference"));
        }
        /* validate link */
        if (is_empty($reference['link']) || !valid_url($reference['link'])) {
          throw new ValidationException(__("Please enter a valid URL for your reference: ") . $reference['title']);
        }
      }
    }
    /* validate paid price */
    if ($is_paid) {
      if (!is_numeric($post_price) || $post_price <= 0) {
        throw new ValidationException(__("Please enter a valid price"));
      }
      if ($system['monetization_max_paid_post_price'] > 0 && $post_price > $system['monetization_max_paid_post_price']) {
        throw new ValidationException(__("The price must be less than or equal to") . " " . print_money($system['monetization_max_paid_post_price']));
      }
      if (strlen($paid_text) > 1000) {
        throw new ValidationException(__("Paid content description is more than 1000 characters"));
      }
    }
    /* prepare text */
    if ($system['html_richtext_enabled']) {
      $clean_text = $text;
    } else {
      /* HTMLPurifier */
      $purifier = get_html_purifier();
      $clean_text = $purifier->purify($text);
    }
    /* prepare tags */
    $tags = ($tags) ? implode(',', array_column(json_decode(html_entity_decode($tags), true), "value")) : '';
    /* prepare tips enabled */
    $tips_enabled = ($publish_to != 'page' && $tips_enabled) ? '1' : '0';
    /* prepare preview images */
    $subscriptions_image = ($for_subscriptions) ? $subscriptions_image : '';
    $paid_image = ($is_paid) ? $paid_image : '';
    /* prepare time */
    $time = ($is_schedule) ? $schedule_date : $date;
    /* prepare approval system */
    $pre_approved = 1;
    $has_approved = 1;
    $author_id = $publish_to == 'page' ? $page_id : $this->_data['user_id'];
    $author_type = $publish_to == 'page' ? 'page' : 'user';
    if ($this->check_posts_needs_approval($author_id, $author_type)) {
      $pre_approved = 0;
      $has_approved = 0;
    }
    /* check if paid modules enabled */
    if ($system['paid_blogs_enabled']) {
      $this->wallet_paid_module_payment('blogs');
    }
    /* publish to */
    switch ($publish_to) {
      case 'timeline':
        /* insert the post */
        $db->query(sprintf(
          "INSERT INTO posts (
            user_id,
            user_type,
            post_type,
            tips_enabled,
            for_subscriptions,
            is_paid,
            post_price,
            paid_text,
            time,
            privacy,
            pre_approved,
            has_approved,
            is_collaborative,
            collaborative_percent,
            is_schedule,
            for_adult,
            subscriptions_image,
            paid_image
          ) VALUES (%s, 'user', 'article', %s, %s, %s, %s, %s, %s, 'public', %s, %s, %s, %s, %s, %s, %s, %s)",
          secure($this->_data['user_id'], 'int'),
          secure($tips_enabled),
          secure($for_subscriptions),
          secure($is_paid),
          secure($post_price, 'float'),
          secure($paid_text),
          secure($time),
          secure($pre_approved),
          secure($has_approved),
          secure($is_collaborative),
          secure($collaborative_percent, 'float'),
          secure($is_schedule),
          secure($for_adult),
          secure($subscriptions_image),
          secure($paid_image)
        ));
        $post_id = $db->insert_id;
        break;

      case 'page':
        /* check if the page is valid */
        $page = $this->get_page($page_id);
        if (!$page) {
          _error(400);
        }
        /* check if the viewer is page admin */
        if (!$this->check_page_adminship($this->_data['user_id'], $page_id)) {
          _error(400);
        }
        /* insert the post */
        $db->query(sprintf(
          "INSERT INTO posts (
            user_id,
            user_type,
            post_type,
            tips_enabled,
            for_subscriptions,
            is_paid,
            post_price,
            paid_text,
            time,
            privacy,
            pre_approved,
            has_approved,
            is_collaborative,
            collaborative_percent,
            is_schedule,
            for_adult,
            subscriptions_image,
            paid_image
          ) VALUES (%s, 'page', 'article', %s, %s, %s, %s, %s, %s, 'public', %s, %s, %s, %s, %s, %s, %s, %s)",
          secure($page_id, 'int'),
          secure($tips_enabled),
          secure($for_subscriptions),
          secure($is_paid),
          secure($post_price, 'float'),
          secure($paid_text),
          secure($time),
          secure($pre_approved),
          secure($has_approved),
          secure($is_collaborative),
          secure($collaborative_percent, 'float'),
          secure($is_schedule),
          secure($for_adult),
          secure($subscriptions_image),
          secure($paid_image)
        ));
        $post_id = $db->insert_id;
        break;

      case 'group':
        /* check if the group is valid */
        $group = $this->get_group($group_id);
        if (!$group) {
          _error(400);
        }
        /* check if the viewer is group member */
        if ($this->check_group_membership($this->_data['user_id'], $group_id) != "approved") {
          _error(400);
        }
        /* check if user is a group admin */
        $group['i_admin'] = $this->check_group_adminship($this->_data['user_id'], $group_id);
        /* check if group publishing enabled */
        if (!$group['group_publish_enabled'] && !$group['i_admin']) {
          throw new Exception(__("Publishing to this group has been disabled by group admins"));
        }
        /* insert the post */
        $group_approved = ($group['group_publish_approval_enabled'] && !$group['i_admin']) ? "0" : "1";
        $db->query(sprintf(
          "INSERT INTO posts (
            user_id,
            user_type,
            post_type,
            tips_enabled,
            for_subscriptions,
            is_paid,
            post_price,
            paid_text,
            time,
            privacy,
            in_group,
            group_id,
            group_approved,
            pre_approved,
            has_approved,
            is_collaborative,
            collaborative_percent,
            is_schedule,
            for_adult,
            subscriptions_image,
            paid_image
          ) VALUES (%s, 'user', 'article', %s, %s, %s, %s, %s, %s, 'custom', '1', %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)",
          secure($this->_data['user_id'], 'int'),
          secure($tips_enabled),
          secure($for_subscriptions),
          secure($is_paid),
          secure($post_price, 'float'),
          secure($paid_text),
          secure($time),
          secure($group_id, 'int'),
          secure($group_approved),
          secure($pre_approved),
          secure($has_approved),
          secure($is_collaborative),
          secure($collaborative_percent, 'float'),
          secure($is_schedule),
          secure($for_adult),
          secure($subscriptions_image),
          secure($paid_image)
        ));
        $post_id = $db->insert_id;
        /* post in_group notification */
        if (!$group_approved) {
          /* send notification to group admin */
          $this->post_notification(['to_user_id' => $group['group_admin'], 'action' => 'group_post_pending', 'node_type' => $group['group_title'], 'node_url' => $group['group_name'] . "-[guid=]" . $post_id]);
        }
        break;

      case 'event':
        /* check if the event is valid */
        $event = $this->get_event($event_id);
        if (!$event) {
          _error(400);
        }
        /* check if the viewer is event member */
        if (!$this->check_event_membership($this->_data['user_id'], $event_id)) {
          _error(400);
        }
        /* check if user is a event admin */
        $event['i_admin'] = $this->check_event_adminship($this->_data['user_id'], $event_id);
        /* check if event publishing enabled */
        if (!$event['event_publish_enabled'] && !$event['i_admin']) {
          throw new Exception(__("Publishing to this event has been disabled by event admins"));
        }
        /* insert the post */
        $event_approved = ($event['event_publish_approval_enabled'] && !$event['i_admin']) ? "0" : "1";
        $db->query(sprintf(
          "INSERT INTO posts (
              user_id,
              user_type,
              post_type,
              tips_enabled,
              is_paid,
              post_price,
              paid_text,
              time,
              privacy,
              in_event,
              event_id,
              event_approved,
              pre_approved,
              has_approved,
              is_collaborative,
              collaborative_percent,
              is_schedule,
              for_adult,
              paid_image
            ) VALUES (%s, 'user', 'article', %s, %s, %s, %s, %s, 'custom', '1', %s, %s, %s, %s, %s, %s, %s, %s, %s)",
          secure($this->_data['user_id'], 'int'),
          secure($tips_enabled),
          secure($is_paid),
          secure($post_price, 'float'),
          secure($paid_text),
          secure($time),
          secure($event_id, 'int'),
          secure($event_approved),
          secure($pre_approved),
          secure($has_approved),
          secure($is_collaborative),
          secure($collaborative_percent, 'float'),
          secure($is_schedule),
          secure($for_adult),
          secure($paid_image)
        ));
        $post_id = $db->insert_id;
        /* post in_event notification */
        if (!$event_approved) {
          /* send notification to event admin */
          $this->post_notification(['to_user_id' => $event['event_admin'], 'action' => 'event_post_pending', 'node_type' => $event['event_title'], 'node_url' => $event['event_name'] . "-[guid=]" . $post_id]);
        }
        break;

      default:
        _error(403);
        break;
    }
    $this->index_post_location($post_id, 'article');
    /* insert blog */
    $db->query(sprintf("INSERT INTO posts_articles (post_id, cover, title, text, category_id, tags) VALUES (%s, %s, %s, %s, %s, %s)", secure($post_id, 'int'), secure($cover), secure($title), secure($clean_text), secure($category_id, 'int'), secure($tags)));
    $this->refresh_post_search($post_id);
    /* insert references */
    if ($references) {
      foreach ($references as $reference) {
        $db->query(sprintf("INSERT INTO posts_articles_references (post_id, title, link) VALUES (%s, %s, %s)", secure($post_id, 'int'), secure($reference['title']), secure($reference['link'])));
      }
    }
    /* insert collaborative users */
    if ($is_collaborative) {
      $this->insert_collaborative_users($post_id, $collaborative_users_ids);
    }
    /* extract hosted images from the text */
    $uploaded_images = extract_uploaded_images_from_text($clean_text);
    /* remove pending uploads */
    remove_pending_uploads([$cover, $subscriptions_image, $paid_image, ...$uploaded_images]);
    /* points balance (blogs) */
    $this->points_balance("add", $this->_data['user_id'], "post", $post_id);
    /* check if post is pending */
    if ($has_approved == 0) {
      /* send notification to admins */
      $this->notify_system_admins("pending_post");
    }
    return $post_id;
  }


  /**
   * edit_blog
   * 
   * @param integer $post_id
   * @param string $title
   * @param string $text
   * @param string $cover
   * @param integer $category_id
   * @param string $tags
   * @param array $references
   * @param boolean $tips_enabled
   * @param boolean $for_subscriptions
   * @param boolean $is_paid
   * @param float $post_price
   * @param string $paid_text
   * @param boolean $for_adult
   * @param string $subscriptions_image
   * @param string $paid_image
   * @param boolean $is_schedule
   * @param string $schedule_date
   * @return void
   */
  public function edit_blog($post_id, $title, $text, $cover, $category_id, $tags, $references, $tips_enabled, $for_subscriptions, $is_paid, $post_price, $paid_text, $for_adult = null, $subscriptions_image = '', $paid_image = '', $is_schedule = null, $schedule_date = '')
  {
    global $db, $system, $date;
    /* prepare */
    $tips_enabled = (isset($tips_enabled)) ? '1' : '0';
    $for_subscriptions = (isset($for_subscriptions)) ? '1' : '0';
    $is_paid = (isset($is_paid)) ? '1' : '0';
    $for_adult = ($system['adult_mode'] && isset($for_adult)) ? '1' : '0';
    $is_schedule = (isset($is_schedule)) ? '1' : '0';
    /* (check|get) post */
    $post = $this->_check_post($post_id, true);
    if (!$post) {
      _error(403);
    }
    /* check if viewer can edit post */
    if (!$post['manage_post']) {
      _error(403);
    }
    $this->check_post_edit_window($post);
    /* check if blogs enabled */
    if (!$system['blogs_enabled']) {
      throw new ValidationException(__("The blogs has been disabled by the admin"));
    }
    /* check blogs permission */
    if (!$this->_data['can_write_blogs']) {
      throw new ValidationException(__("You don't have the permission to do this"));
    }
    /* check scheduled posts */
    $time = $post['time'];
    if ($post['still_scheduled'] && $this->_data['can_schedule_posts']) {
      if ($is_schedule) {
        if ($schedule_date != $post['time']) {
          if (!is_string($schedule_date) || !preg_match('/^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$/', $schedule_date) || strtotime($schedule_date) <= time()) {
            throw new ValidationException(__("Select a valid date and time for your scheduled post"));
          }
        }
        $time = $schedule_date;
      } else {
        $time = $date;
      }
    } else {
      $is_schedule = $post['is_schedule'];
    }
    /* check adult posts permission */
    if ($for_adult && !$post['for_adult'] && $system['verification_for_adult_content'] && !$this->_data['user_verified']) {
      throw new ValidationException(__("Your account must be verified to share adult content"));
    }
    /* check tips permission */
    if (!$this->_data['can_receive_tip'] && $tips_enabled) {
      throw new ValidationException(__("You don't have the permission to do this"));
    }
    /* check monetization permission */
    if ($for_subscriptions) {
      if (!$post['can_be_for_subscriptions']) {
        throw new ValidationException(__("You don't have the permission to do this"));
      }
    }
    /* check if both for_subscriptions & is_paid enabled */
    if ($for_subscriptions && $is_paid) {
      throw new ValidationException(__("You can't enable both subscribers only & paid post"));
    }
    /* check paid posts permission */
    if (!$this->_data['can_monetize_content'] && !$this->_data['user_monetization_enabled'] && $is_paid) {
      throw new ValidationException(__("You don't have the permission to do this"));
    }
    /* validate title */
    if (is_empty($title)) {
      throw new ValidationException(__("You must enter a title for your blog"));
    }
    if (strlen($title) < 3) {
      throw new ValidationException(__("Title must be at least 3 characters long. Please try another"));
    }
    /* validate text */
    if (is_empty($text)) {
      throw new ValidationException(__("You must enter some text for your blog"));
    }
    /* validate category */
    if (is_empty($category_id)) {
      throw new ValidationException(__("You must select valid category for your blog"));
    }
    $category = $this->get_category('blogs_categories', $category_id);
    if (!$category) {
      throw new ValidationException(__("You must select valid category for your blog"));
    }
    /* validate cover */
    if ($system['blogs_cover_required'] && is_empty($cover)) {
      throw new ValidationException(__("You must upload a cover image for your blog"));
    }
    /* validate references */
    if ($references) {
      foreach ($references as $key => $reference) {
        /* remove empty references */
        if (is_empty($reference['title']) && is_empty($reference['link'])) {
          unset($references[$key]);
          continue;
        }
        /* validate title */
        if (is_empty($reference['title'])) {
          throw new ValidationException(__("You must enter a title for your reference"));
        }
        /* validate link */
        if (is_empty($reference['link']) || !valid_url($reference['link'])) {
          throw new ValidationException(__("Please enter a valid URL for your reference: ") . $reference['title']);
        }
      }
    }
    /* validate paid price */
    if ($is_paid) {
      if (!is_numeric($post_price) || $post_price <= 0) {
        throw new ValidationException(__("Please enter a valid price"));
      }
      if ($system['monetization_max_paid_post_price'] > 0 && $post_price > $system['monetization_max_paid_post_price']) {
        throw new ValidationException(__("The price must be less than or equal to") . " " . print_money($system['monetization_max_paid_post_price']));
      }
      if (strlen($paid_text) > 1000) {
        throw new ValidationException(__("Paid content description is more than 1000 characters"));
      }
    }
    /* prepare text */
    if ($system['html_richtext_enabled']) {
      $clean_text = $text;
    } else {
      /* HTMLPurifier */
      $purifier = get_html_purifier();
      $clean_text = $purifier->purify($text);
    }
    /* prepare tags */
    $tags = ($tags) ? implode(',', array_column(json_decode(html_entity_decode($tags), true), "value")) : '';
    /* prepare tips enabled */
    $tips_enabled = ($post['user_type'] != 'page' && $tips_enabled) ? '1' : '0';
    /* prepare preview images */
    $subscriptions_image = ($for_subscriptions) ? $subscriptions_image : '';
    $paid_image = ($is_paid) ? $paid_image : '';
    /* update the post */
    $db->query(sprintf("UPDATE posts SET tips_enabled = %s, for_subscriptions = %s, subscriptions_image = %s, is_paid = %s, post_price = %s, paid_text = %s, paid_image = %s, for_adult = %s, is_schedule = %s, time = %s WHERE post_id = %s", secure($tips_enabled), secure($for_subscriptions), secure($subscriptions_image), secure($is_paid), secure($post_price, 'float'), secure($paid_text), secure($paid_image), secure($for_adult), secure($is_schedule), secure($time), secure($post_id, 'int')));
    /* delete replaced preview images */
    if ($post['subscriptions_image'] && $post['subscriptions_image'] != $subscriptions_image) {
      delete_uploads_file($post['subscriptions_image']);
    }
    if ($post['paid_image'] && $post['paid_image'] != $paid_image) {
      delete_uploads_file($post['paid_image']);
    }
    /* update the blog */
    $db->query(sprintf("UPDATE posts_articles SET cover = %s, title = %s, text = %s, category_id = %s, tags = %s WHERE post_id = %s", secure($cover), secure($title), secure($clean_text), secure($category_id, 'int'), secure($tags), secure($post_id, 'int')));
    $this->refresh_post_search($post_id);
    /* delete existing references */
    $db->query(sprintf("DELETE FROM posts_articles_references WHERE post_id = %s", secure($post_id, 'int')));
    /* update references */
    if ($references) {
      /* insert new references */
      foreach ($references as $reference) {
        $db->query(sprintf("INSERT INTO posts_articles_references (post_id, title, link) VALUES (%s, %s, %s)", secure($post_id, 'int'), secure($reference['title']), secure($reference['link'])));
      }
    }
    /* extract hosted images from the text */
    $uploaded_images = extract_uploaded_images_from_text($clean_text);
    /* remove pending uploads */
    remove_pending_uploads([$cover, $subscriptions_image, $paid_image, ...$uploaded_images]);
    $this->queue_post_reapproval($post);
  }
}
