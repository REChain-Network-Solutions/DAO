<?php

/**
 * trait -> blogs
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich
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
    $offset = !isset($args['offset']) ? 0 : $args['offset'];
    $random = !isset($args['random']) ? false : true;
    $results = !isset($args['results']) ? $system['blogs_results'] : $args['results'];
    /* initialize vars */
    $posts = [];
    $offset *= $results;
    /* prepare country statement */
    if ($country && $system['newsfeed_location_filter_enabled'] && $country != "all") {
      $country_query .= sprintf(" AND ( (posts.user_type = 'user' AND user_post_author.user_country = %s) OR (posts.user_type = 'page' AND page_post_author.page_country = %s) )", secure($country, 'int'), secure($country, 'int'));
    }
    /* get posts */
    $where_query = ($category != null) ? sprintf("AND posts_articles.category_id = %s", secure($args['category'], 'int')) : "";
    $order_query = ($random) ? " ORDER BY RAND()" : "ORDER BY posts.post_id DESC ";
    $get_posts = $db->query(sprintf("SELECT posts.post_id FROM posts INNER JOIN posts_articles ON posts.post_id = posts_articles.post_id AND posts.post_type = 'article' LEFT JOIN users AS user_post_author ON posts.user_type = 'user' AND posts.user_id = user_post_author.user_id AND user_post_author.user_banned = '0' LEFT JOIN pages AS page_post_author ON posts.user_type = 'page' AND posts.user_id = page_post_author.page_id WHERE posts.in_group = '0' AND posts.in_event = '0' AND (posts.pre_approved = '1' OR posts.has_approved = '1') " . $where_query . $country_query . $order_query . " LIMIT %s, %s", secure($offset, 'int', false), secure($results, 'int', false)));
    if ($get_posts->num_rows > 0) {
      while ($post = $get_posts->fetch_assoc()) {
        $post = $this->get_post($post['post_id'], false, false, true);
        if ($post) {
          $posts[] = $post;
        }
      }
    }
    return $posts;
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
   * @param boolean $tips_enabled
   * @param boolean $for_subscriptions
   * @param boolean $is_paid
   * @param float $post_price
   * @param string $paid_text
   * @return integer
   */
  public function post_blog($publish_to, $page_id, $group_id, $event_id, $title, $text, $cover, $category_id, $tags, $tips_enabled, $for_subscriptions, $is_paid, $post_price, $paid_text)
  {
    global $db, $system, $date;
    /* check if blogs enabled */
    if (!$system['blogs_enabled']) {
      throw new Exception(__("The blogs module has been disabled by the admin"));
    }
    /* check blogs permission */
    if (!$this->_data['can_write_blogs']) {
      throw new Exception(__("You don't have the permission to do this"));
    }
    /* check if verification for posts required */
    if ($system['verification_for_posts'] && !$this->_data['user_verified']) {
      throw new Exception(__("To use this feature your account must be verified"));
    }
    /* check max posts/hour limit */
    $this->check_posts_limit(($publish_to == 'page') ? 'page' : 'user', ($publish_to == 'page') ? $page_id : null);
    /* check tips permission */
    if (!$this->_data['can_receive_tip'] && $tips_enabled) {
      throw new Exception(__("You don't have the permission to do this"));
    }
    /* check monetization permission */
    if ($for_subscriptions) {
      switch ($publish_to) {
        case 'timeline':
          if (!($this->_data['can_monetize_content'] && $this->_data['user_monetization_enabled'] && $this->_data['user_monetization_plans'] > 0)) {
            throw new Exception(__("You don't have the permission to do this"));
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
            throw new Exception(__("You don't have the permission to do this"));
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
            throw new Exception(__("You don't have the permission to do this"));
          }
          break;

        default:
          throw new Exception(__("You don't have the permission to do this"));
          break;
      }
    }
    /* check paid posts permission */
    if (!$this->_data['can_monetize_content'] && !$this->_data['user_monetization_enabled'] && $is_paid) {
      throw new Exception(__("You don't have the permission to do this"));
    }
    /* check if both for_subscriptions & is_paid enabled */
    if ($for_subscriptions && $is_paid) {
      throw new Exception(__("You can't enable both subscribers only & paid post"));
    }
    /* validate title */
    if (is_empty($title)) {
      throw new Exception(__("You must enter a title for your blog"));
    }
    if (strlen($title) < 3) {
      throw new Exception(__("Title must be at least 3 characters long. Please try another"));
    }
    /* validate text */
    if (is_empty($text)) {
      throw new Exception(__("You must enter some text for your blog"));
    }
    /* validate category */
    if (is_empty($category_id)) {
      throw new Exception(__("You must select valid category for your blog"));
    }
    $category = $this->get_category('blogs_categories', $category_id);
    if (!$category) {
      throw new Exception(__("You must select valid category for your blog"));
    }
    /* validate price */
    if ($is_paid) {
      if (!is_numeric($post_price) || $post_price <= 0) {
        throw new Exception(__("Please enter a valid price"));
      }
      if (strlen($paid_text) > 1000) {
        modal("ERROR", __("Error"), __("Paid post description is more than 1000 characters"));
      }
    }
    /* prepare text */
    if ($system['html_richtext_enabled']) {
      $clean_text = $text;
    } else {
      /* HTMLPurifier */
      $config = HTMLPurifier_Config::createDefault();
      $config->set('HTML.SafeIframe', true);
      $config->set('URI.SafeIframeRegexp', '%^(https?:)?(\/\/www\.youtube(?:-nocookie)?\.com\/embed\/|\/\/player\.vimeo\.com\/)%');
      $purifier = new HTMLPurifier($config);
      $clean_text = $purifier->purify($text);
    }
    /* prepare tags */
    $tags = ($tags) ? implode(',', array_column(json_decode(html_entity_decode($tags), true), "value")) : '';
    /* prepare tips enabled */
    $tips_enabled = ($publish_to != 'page' && $tips_enabled) ? '1' : '0';
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
        $db->query(sprintf("INSERT INTO posts (user_id, user_type, post_type, tips_enabled, for_subscriptions, is_paid, post_price, paid_text, time, privacy, pre_approved, has_approved) VALUES (%s, 'user', 'article', %s, %s, %s, %s, %s, %s, 'public', %s, %s)", secure($this->_data['user_id'], 'int'), secure($tips_enabled), secure($for_subscriptions), secure($is_paid), secure($post_price, 'float'), secure($paid_text), secure($date), secure($pre_approved), secure($has_approved)));
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
        $db->query(sprintf("INSERT INTO posts (user_id, user_type, post_type, tips_enabled, for_subscriptions, is_paid, post_price, paid_text, time, privacy, pre_approved, has_approved) VALUES (%s, 'page', 'article', %s, %s, %s, %s, %s, %s, 'public', %s, %s)", secure($page_id, 'int'), secure($tips_enabled), secure($for_subscriptions), secure($is_paid), secure($post_price, 'float'), secure($paid_text), secure($date), secure($pre_approved), secure($has_approved)));
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
        $db->query(sprintf("INSERT INTO posts (user_id, user_type, post_type, tips_enabled, for_subscriptions, is_paid, post_price, paid_text, time, privacy, in_group, group_id, group_approved, pre_approved, has_approved) VALUES (%s, 'user', 'article', %s, %s, %s, %s, %s, %s, 'custom', '1', %s, %s, %s, %s)", secure($this->_data['user_id'], 'int'), secure($tips_enabled), secure($for_subscriptions), secure($is_paid), secure($post_price, 'float'), secure($paid_text), secure($date), secure($group_id, 'int'), secure($group_approved), secure($pre_approved), secure($has_approved)));
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
        $db->query(sprintf("INSERT INTO posts (user_id, user_type, post_type, tips_enabled, is_paid, post_price, paid_text, time, privacy, in_event, event_id, event_approved, pre_approved, has_approved) VALUES (%s, 'user', 'article', %s, %s, %s, %s, %s, 'custom', '1', %s, %s, %s, %s)", secure($this->_data['user_id'], 'int'), secure($tips_enabled), secure($is_paid), secure($post_price, 'float'), secure($paid_text), secure($date), secure($event_id, 'int'), secure($event_approved), secure($pre_approved), secure($has_approved)));
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
    /* insert blog */
    $db->query(sprintf("INSERT INTO posts_articles (post_id, cover, title, text, category_id, tags) VALUES (%s, %s, %s, %s, %s, %s)", secure($post_id, 'int'), secure($cover), secure($title), secure($clean_text), secure($category_id, 'int'), secure($tags)));
    /* extract hosted images from the text */
    $uploaded_images = extract_uploaded_images_from_text($clean_text);
    /* remove pending uploads */
    remove_pending_uploads([$cover, ...$uploaded_images]);
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
   * @param boolean $tips_enabled
   * @param boolean $for_subscriptions
   * @param boolean $is_paid
   * @param float $post_price
   * @param string $paid_text
   * @return void
   */
  public function edit_blog($post_id, $title, $text, $cover, $category_id, $tags, $tips_enabled, $for_subscriptions, $is_paid, $post_price, $paid_text)
  {
    global $db, $system, $date;
    /* (check|get) post */
    $post = $this->_check_post($post_id, true);
    if (!$post) {
      _error(403);
    }
    /* check if viewer can edit post */
    if (!$post['manage_post']) {
      _error(403);
    }
    /* check if blogs enabled */
    if (!$system['blogs_enabled']) {
      throw new Exception(__("The blogs has been disabled by the admin"));
    }
    /* check blogs permission */
    if (!$this->_data['can_write_blogs']) {
      throw new Exception(__("You don't have the permission to do this"));
    }
    /* check tips permission */
    if (!$this->_data['can_receive_tip'] && $tips_enabled) {
      throw new Exception(__("You don't have the permission to do this"));
    }
    /* check monetization permission */
    if ($for_subscriptions) {
      if (!$post['can_be_for_subscriptions']) {
        throw new Exception(__("You don't have the permission to do this"));
      }
    }
    /* check paid posts permission */
    if (!$this->_data['can_monetize_content'] && !$this->_data['user_monetization_enabled'] && $is_paid) {
      throw new Exception(__("You don't have the permission to do this"));
    }
    /* check if both for_subscriptions & is_paid enabled */
    if ($for_subscriptions && $is_paid) {
      throw new Exception(__("You can't enable both subscribers only & paid post"));
    }
    /* validate title */
    if (is_empty($title)) {
      throw new Exception(__("You must enter a title for your blog"));
    }
    if (strlen($title) < 3) {
      throw new Exception(__("Title must be at least 3 characters long. Please try another"));
    }
    /* validate text */
    if (is_empty($text)) {
      throw new Exception(__("You must enter some text for your blog"));
    }
    /* validate category */
    if (is_empty($category_id)) {
      throw new Exception(__("You must select valid category for your blog"));
    }
    $category = $this->get_category('blogs_categories', $category_id);
    if (!$category) {
      throw new Exception(__("You must select valid category for your blog"));
    }
    /* validate price */
    if ($is_paid) {
      if (!is_numeric($post_price) || $post_price <= 0) {
        throw new Exception(__("Please enter a valid price"));
      }
      if (strlen($paid_text) > 1000) {
        modal("ERROR", __("Error"), __("Paid post description is more than 1000 characters"));
      }
    }
    /* prepare text */
    if ($system['html_richtext_enabled']) {
      $clean_text = $text;
    } else {
      /* HTMLPurifier */
      $config = HTMLPurifier_Config::createDefault();
      $config->set('HTML.SafeIframe', true);
      $config->set('URI.SafeIframeRegexp', '%^(https?:)?(\/\/www\.youtube(?:-nocookie)?\.com\/embed\/|\/\/player\.vimeo\.com\/)%');
      $purifier = new HTMLPurifier($config);
      $clean_text = $purifier->purify($text);
    }
    /* prepare tags */
    $tags = ($tags) ? implode(',', array_column(json_decode(html_entity_decode($tags), true), "value")) : '';
    /* prepare tips enabled */
    $tips_enabled = ($post['user_type'] != 'page' && $tips_enabled) ? '1' : '0';
    /* update the post */
    $db->query(sprintf("UPDATE posts SET tips_enabled = %s, for_subscriptions = %s, is_paid = %s, post_price = %s, paid_text = %s WHERE post_id = %s", secure($tips_enabled), secure($for_subscriptions), secure($is_paid), secure($post_price, 'float'), secure($oaid_text), secure($post_id, 'int')));
    /* update the blog */
    $db->query(sprintf("UPDATE posts_articles SET cover = %s, title = %s, text = %s, category_id = %s, tags = %s WHERE post_id = %s", secure($cover), secure($title), secure($clean_text), secure($category_id, 'int'), secure($tags), secure($post_id, 'int')));
    /* extract hosted images from the text */
    $uploaded_images = extract_uploaded_images_from_text($clean_text);
    /* remove pending uploads */
    remove_pending_uploads([$cover, ...$uploaded_images]);
  }
}
