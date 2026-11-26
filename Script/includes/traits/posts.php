<?php

/**
 * trait -> posts
 * 
 * @package Sngine
 * @author Zamblek
 */

trait PostsTrait
{

  /* ------------------------------- */
  /* Posts */
  /* ------------------------------- */

  /**
   * get_posts
   * 
   * @param array $args
   * @return array
   */
  public function get_posts($args = [])
  {
    global $db, $system, $date;
    /* initialize vars */
    $posts = [];
    $this->_cursor = null;
    /* validate arguments */
    $get = !isset($args['get']) ? 'newsfeed' : $args['get'];
    $filter = !isset($args['filter']) ? 'all' : $args['filter'];
    $country = !isset($args['country']) ? 'all' : $args['country'];
    $category = !isset($args['category']) ? null : $args['category'];
    $max_results = !isset($args['results']) ? $system['newsfeed_results'] : $args['results'];
    if (!in_array($filter, ['all', '', 'link', 'media', 'live', 'photos', 'map', 'rich_text', 'article', 'product', 'funding', 'offer', 'job', 'course', 'poll', 'reel', 'video', 'audio', 'file', 'merit'])) {
      _error(400);
    }
    $last_post_id = !isset($args['last_post_id']) ? null : $args['last_post_id'];
    if (isset($last_post_id) && !is_numeric($last_post_id)) {
      _error(400);
    }
    if (isset($args['query'])) {
      $max_results = $system['search_results'];
      if (is_empty($args['query'])) {
        return $posts;
      } else {
        $query = secure($args['query'], 'search', false);
        if (!empty($args['hashtag'])) {
          /* search hashtag */
          $search_query = sprintf("(posts.post_id IN (SELECT hashtags_posts.post_id FROM hashtags_posts INNER JOIN hashtags ON hashtags_posts.hashtag_id = hashtags.hashtag_id WHERE hashtags.hashtag IN (%s, %s)))", secure($args['query']), secure(htmlentities($args['query'], ENT_QUOTES, 'UTF-8')));
        } else {
          $search_query = $this->posts_search_clause($args['query'], "(posts.text LIKE $query)");
        }
      }
    }
    $offset = !isset($args['offset']) ? 0 : $args['offset'];
    /* popular posts stop after 50 pages (their order can't be read from an index) */
    if ($get == 'popular' && $offset > 50) {
      return $posts;
    }
    $offset *= $max_results;
    $get_all = !isset($args['get_all']) ? false : true;
    /* prepare query */
    $order_query = "ORDER BY posts.time DESC, posts.post_id DESC";
    $cursor_columns = ['posts.time', 'posts.post_id'];
    $where_query = "";
    /* get posts */
    switch ($get) {
      case 'newsfeed':
        if (!$this->_logged_in && $query) {
          /* [Case: 1] user not logged in but searhing */
          $where_query .= "WHERE ("; /* [01] start of public search query clause */
          $where_query .= $search_query;
          /* get only public posts [except: group posts & event posts & wall posts] */
          $where_query .= " AND (posts.in_group = '0' AND posts.in_event = '0' AND posts.in_wall = '0' AND posts.privacy = 'public')";
          $where_query .= ")"; /* [01] end of public search query clause */
        } else {
          /* [Case: 2] user logged in or not whatever searching or not */
          /* get viewer user's newsfeed */
          $where_query .= "WHERE ("; /* [02] start of newsfeed clause */
          if ($query) {
            $where_query .= $search_query . " AND ("; /* [03] start of search sources clause */
          }
          $where_query .= "("; /* [04] start of newsfeed sources */
          $where_query .= $this->newsfeed_sources_clause();
          $where_query .= ")"; /* [04] end of newsfeed sources */
          if ($query) {
            /* get only public posts [except: group posts & event posts & wall posts] */
            $where_query .= " OR (posts.in_group = '0' AND posts.in_event = '0' AND posts.in_wall = '0' AND posts.privacy = 'public')";
            $where_query .= ")"; /* [03] end of search sources clause */
          }
          $where_query .= ")"; /* [02] end of newsfeed clause */
        }
        break;

      case 'posts_profile':
        if (isset($args['id']) && !is_numeric($args['id'])) {
          _error(400);
        }
        $id = $args['id'];
        /* get target user's posts */
        /* check if there is a viewer user */
        if ($this->_logged_in) {
          /* check if the target user is the viewer */
          if ($id == $this->_data['user_id']) {
            /* get all posts */
            $where_query .= "WHERE (";
            /* get all target posts */
            $where_query .= "(posts.user_id = $id AND posts.user_type = 'user')";
            /* get target wall posts (from others to the target) */
            $where_query .= " OR (posts.in_wall = '1' AND posts.wall_id = $id)";
            /* get target collaborative posts */
            $where_query .= " OR (posts.is_collaborative = '1' AND EXISTS (SELECT 1 FROM posts_collaborative_users pcu WHERE pcu.post_id = posts.post_id AND pcu.user_id = $id))";
            $where_query .= ")";
          } else {
            /* check if the viewer & the target user are friends */
            if ($this->friendship_approved($id)) {
              /* Yes they are friends */
              $where_query .= "WHERE (";
              /* get all target posts [except: group posts & event posts & hidden posts & anonymous posts] */
              $where_query .= "(posts.user_id = $id AND posts.user_type = 'user' AND posts.privacy != 'me'AND posts.is_hidden = '0' AND posts.is_anonymous = '0' AND posts.in_group = '0' AND posts.in_event = '0' )";
              /* get target wall posts (from others to the target) [except: hidden posts] */
              $where_query .= " OR (posts.in_wall = '1' AND posts.is_hidden = '0' AND posts.wall_id = $id)";
              /* get target collaborative posts [except: hidden posts] */
              $where_query .= " OR (posts.is_collaborative = '1' AND posts.is_hidden = '0' AND EXISTS (SELECT 1 FROM posts_collaborative_users pcu WHERE pcu.post_id = posts.post_id AND pcu.user_id = $id))";
              $where_query .= ")";
            } else {
              /* No they are not friends */
              /* get only public posts [except: hidden posts & anonymous posts] */
              /* note: we didn't except group posts & event posts as they are not public already */
              $where_query .= "WHERE (";
              $where_query .= "(posts.user_id = $id AND posts.user_type = 'user' AND posts.privacy = 'public' AND posts.is_hidden = '0' AND posts.is_anonymous = '0')";
              /* get target public wall posts (from others to the target) [except: hidden posts] */
              $where_query .= " OR (posts.in_wall = '1' AND posts.privacy = 'public' AND posts.is_hidden = '0' AND posts.wall_id = $id)";
              /* get target collaborative posts [except: hidden posts] */
              $where_query .= " OR (posts.is_collaborative = '1' AND posts.privacy = 'public' AND posts.is_hidden = '0' AND EXISTS (SELECT 1 FROM posts_collaborative_users pcu WHERE pcu.post_id = posts.post_id AND pcu.user_id = $id))";
              $where_query .= ")";
            }
          }
        } else {
          /* get only public posts [except: hidden posts] */
          $where_query .= "WHERE (";
          /* note: we didn't except group posts & event posts as they are not public already */
          $where_query .= "(posts.user_id = $id AND posts.user_type = 'user' AND posts.privacy = 'public' AND posts.is_hidden = '0' AND posts.is_anonymous = '0')";
          /* get target public wall posts (from others to the target) [except: hidden posts] */
          $where_query .= " OR (posts.in_wall = '1' AND posts.privacy = 'public' AND posts.is_hidden = '0' AND posts.wall_id = $id)";
          /* get target collaborative posts [except: hidden posts] */
          $where_query .= " OR (posts.is_collaborative = '1' AND posts.privacy = 'public' AND posts.is_hidden = '0' AND EXISTS (SELECT 1 FROM posts_collaborative_users pcu WHERE pcu.post_id = posts.post_id AND pcu.user_id = $id))";
          $where_query .= ")";
        }
        if ($query) {
          $legacy_query = "(posts.text LIKE $query";
          if ($filter == "product") {
            $legacy_query .= " OR posts.post_id IN (SELECT post_id FROM posts_products WHERE name LIKE $query)";
          } elseif ($filter == "article") {
            $legacy_query .= " OR posts.post_id IN (SELECT post_id FROM posts_articles WHERE title LIKE $query)";
          }
          $legacy_query .= ")";
          $where_query .= " AND " . $this->posts_search_clause($args['query'], $legacy_query);
        }
        break;

      case 'posts_page':
        if (isset($args['id']) && !is_numeric($args['id'])) {
          _error(400);
        }
        $id = $args['id'];
        $where_query .= "WHERE (posts.user_id = $id AND posts.user_type = 'page')";
        if ($query) {
          $where_query .= " AND " . $search_query;
        }
        break;

      case 'posts_group':
        if (isset($args['id']) && !is_numeric($args['id'])) {
          _error(400);
        }
        $id = $args['id'];
        $where_query .= "WHERE ((posts.group_id = $id AND posts.in_group = '1' AND posts.group_approved = '1') OR (posts.group_id = $id AND posts.post_type = 'group'))";
        if ($query) {
          $where_query .= " AND " . $search_query;
        }
        break;

      case 'posts_group_pending':
        if (isset($args['id']) && !is_numeric($args['id'])) {
          _error(400);
        }
        $id = $args['id'];
        $me = $this->_data['user_id'];
        $where_query .= "WHERE (posts.group_id = $id AND posts.in_group = '1' AND posts.group_approved = '0' AND posts.user_id = $me)";
        break;

      case 'posts_group_pending_all':
        if (isset($args['id']) && !is_numeric($args['id'])) {
          _error(400);
        }
        $id = $args['id'];
        $where_query .= "WHERE (posts.group_id = $id AND posts.in_group = '1' AND posts.group_approved = '0')";
        break;

      case 'posts_event':
        if (isset($args['id']) && !is_numeric($args['id'])) {
          _error(400);
        }
        $id = $args['id'];
        $where_query .= "WHERE ((posts.event_id = $id AND posts.in_event = '1' AND posts.event_approved = '1') OR (posts.event_id = $id AND posts.post_type = 'event'))";
        if ($query) {
          $where_query .= " AND " . $search_query;
        }
        break;

      case 'posts_event_pending':
        if (isset($args['id']) && !is_numeric($args['id'])) {
          _error(400);
        }
        $id = $args['id'];
        $me = $this->_data['user_id'];
        $where_query .= "WHERE (posts.event_id = $id AND posts.in_event = '1' AND posts.event_approved = '0' AND posts.user_id = $me)";
        break;

      case 'posts_event_pending_all':
        if (isset($args['id']) && !is_numeric($args['id'])) {
          _error(400);
        }
        $id = $args['id'];
        $where_query .= "WHERE (posts.event_id = $id AND posts.in_event = '1' AND posts.event_approved = '0')";
        break;

      case 'popular':
        /* get all popular public posts */
        $where_query .= "WHERE posts.privacy = 'public'";
        /* get popular posts within the last interval */
        $where_query .= sprintf(" AND (posts.time >= DATE_SUB(CURDATE(), INTERVAL 1 %s))", $system['popular_posts_interval']);
        /* order by comments, reactions & shares */
        $order_query = "ORDER BY posts.comments DESC, posts.reaction_like_count DESC, posts.reaction_love_count DESC, posts.reaction_haha_count DESC, posts.reaction_yay_count DESC, posts.reaction_wow_count DESC, posts.reaction_sad_count DESC, posts.reaction_angry_count DESC, posts.shares DESC";
        break;

      case 'discover':
        $where_query .= sprintf("WHERE posts.privacy = 'public' AND !(posts.user_id = %s AND posts.user_type = 'user')", secure($this->_data['user_id'], 'int'));
        /* exclude posts from viewer friends */
        /* viewer friends posts -> authors */
        $where_query .= sprintf(" AND !(posts.user_id IN (%s) AND posts.user_type = 'user')", $this->spread_ids($this->get_friends_followings_ids()));
        /* exclude posts from viewer followings */
        $where_query .= sprintf(" AND !(posts.user_id IN (%s) AND posts.user_type = 'user')", $this->spread_ids($this->followings_ids()));
        /* exclude posts from viewer liked pages */
        $where_query .= sprintf(" AND !(posts.user_id IN (%s) AND posts.user_type = 'page')", $this->spread_ids($this->get_pages_ids()));
        /* exclude posts from viewer joined groups */
        $where_query .= sprintf(" AND !(posts.group_id IN (%s) AND posts.in_group = '1')", $this->spread_ids($this->get_groups_ids(true)));
        /* exclude posts from viewer joined events */
        $where_query .= sprintf(" AND !(posts.event_id IN (%s) AND posts.in_event = '1')", $this->spread_ids($this->get_events_ids()));
        break;

      case 'following':
        if (!$this->_logged_in) {
          return $posts;
        }
        $me = secure($this->_data['user_id'], 'int');
        $where_query .= "WHERE posts.in_group = '0' AND posts.in_event = '0' AND (";
        /* viewer own posts */
        $where_query .= "(posts.user_id = $me AND posts.user_type = 'user')";
        /* friends posts */
        $where_query .= sprintf(" OR (posts.user_id IN (%s) AND posts.user_type = 'user' AND posts.privacy = 'friends')", $this->spread_ids($this->get_friends_followings_ids()));
        /* followings posts */
        $where_query .= sprintf(" OR (posts.user_id IN (%s) AND posts.user_type = 'user' AND posts.privacy = 'public')", $this->spread_ids($this->followings_ids()));
        /* liked pages posts */
        $where_query .= sprintf(" OR (posts.user_id IN (%s) AND posts.user_type = 'page')", $this->spread_ids($this->get_pages_ids()));
        $where_query .= ")";
        break;

      case 'saved':
        $id = $this->_data['user_id'];
        $where_query .= "INNER JOIN posts_saved ON posts.post_id = posts_saved.post_id WHERE (posts_saved.user_id = $id)";
        $order_query = "ORDER BY posts_saved.time DESC, posts.post_id DESC"; /* order by saved time not by post_id */
        $cursor_columns = ['posts_saved.time', 'posts.post_id'];
        break;

      case 'scheduled':
        $id = $this->_data['user_id'];
        /* [1] get viewer posts */
        $where_query .= "WHERE (posts.user_id = $id AND posts.user_type = 'user' AND posts.is_schedule = '1' AND posts.time > NOW())";
        /* [2] get viewer liked pages posts */
        $where_query .= sprintf(" OR (posts.user_id IN (%s) AND posts.user_type = 'page' AND posts.is_schedule = '1' AND posts.time > NOW())", $this->spread_ids($this->get_pages_managed_ids()));
        break;

      case 'memories':
        $id = $this->_data['user_id'];
        $where_query .= "WHERE DATE_FORMAT(DATE(posts.time),'%m-%d') = DATE_FORMAT(CURDATE(),'%m-%d') AND posts.time < (NOW() - INTERVAL 1 DAY) AND posts.user_id = $id AND posts.user_type = 'user'";
        break;

      case 'boosted':
        $id = $this->_data['user_id'];
        $where_query .= "WHERE (posts.boosted = '1' AND posts.boosted_by = $id)";
        break;

      default:
        _error(400);
        break;
    }
    /* exclude viewer hidden posts from results */
    if ($this->_logged_in) {
      $where_query .= sprintf(" AND (posts.post_id NOT IN (SELECT post_id FROM posts_hidden WHERE user_id = %s))", secure($this->_data['user_id'], 'int'));
    }
    /* filter posts */
    if ($filter != "all") {
      $where_query .= " AND (posts.post_type = '$filter')";
    }
    /* exclude banned users posts */
    $author_join = " LEFT JOIN users AS user_post_author ON posts.user_type = 'user' AND posts.user_id = user_post_author.user_id LEFT JOIN pages AS page_post_author ON posts.user_type = 'page' AND posts.user_id = page_post_author.page_id ";
    $where_query .= " AND (posts.user_type != 'user' OR IFNULL(user_post_author.user_banned, 0) = 0)";
    /* exclude processing posts */
    $where_query .= " AND (posts.processing != '1')";
    /* newsfeed location filter */
    if ($system['newsfeed_location_filter_enabled'] && $country != "all") {
      $where_query .= sprintf(" AND ( (posts.user_type = 'user' AND user_post_author.user_country = %s) OR (posts.user_type = 'page' AND page_post_author.page_country = %s) )", secure($country, 'int'), secure($country, 'int'));
    }
    /* newsfeed category filter */
    if ($category) {
      switch ($filter) {
        case 'video':
          $category_join = " LEFT JOIN posts_videos ON posts.post_id = posts_videos.post_id ";
          $where_query .= sprintf(" AND (posts_videos.category_id = %s)", secure($category, 'int'));
          break;
      }
    }
    /* prepare approval system */
    if ($system['posts_approval_enabled']) {
      $where_query .= " AND (posts.pre_approved = '1' OR posts.has_approved = '1') ";
    }
    /* check if profile posts updates disabled */
    if ($system['profile_posts_updates_disabled']) {
      /* exclude these types from the newsfeed ['profile_picture', 'profile_cover', 'page_picture', 'page_cover', 'group_picture', 'group_cover', 'event_cover'] */
      $where_query .= " AND (posts.post_type NOT IN ('profile_picture', 'profile_cover', 'page_picture', 'page_cover', 'group_picture', 'group_cover', 'event_cover'))";
    }
    /* posts caching system */
    if ($this->_logged_in && $system['newsfeed_caching_enabled'] && !isset($args['query']) && in_array($get, ['newsfeed', 'discover']) && !in_array($filter, ['reel', 'video'])) {
      $where_query .= " AND (posts.post_id NOT IN (SELECT post_id FROM posts_cache WHERE user_id = " . $this->_data['user_id'] . "))";
    }
    /* posts scheduling system (exclude scheduled & pending posts) */
    if ($system['posts_schedule_enabled'] && !in_array($get, ['scheduled', 'posts_group_pending', 'posts_group_pending_all', 'posts_event_pending', 'posts_event_pending_all'])) {
      $where_query .= " AND posts.time <= NOW()";
    }
    /* get posts */
    if ($last_post_id != null && !in_array($get, ['popular', 'saved', 'scheduled', 'memories'])) { /* excluded as not ordered by post_id */
      /* newer id & not older than the last post (ids are not always in time order) */
      $get_posts = $db->query("SELECT * FROM (SELECT posts.post_id, posts.time FROM posts " . $author_join . $category_join . $where_query . sprintf(") posts WHERE posts.post_id > %s AND posts.time >= COALESCE((SELECT last_post.time FROM posts AS last_post WHERE last_post.post_id = %s), '1970-01-01') ORDER BY posts.post_id DESC", secure($last_post_id, 'int'), secure($last_post_id, 'int')));
    } else {
      /* pages after the first continue from a cursor (the last post's time & id) instead of an offset */
      $use_cursor = !$get_all && !in_array($get, ['popular', 'scheduled']);
      $cursor = ($use_cursor) ? cursor_decode($args['cursor'] ?? null, ['datetime', 'int']) : null;
      if ($cursor) {
        $limit_statement = sprintf("LIMIT %s", secure($max_results, 'int', false));
        $where_query .= " AND " . cursor_where($cursor_columns, $cursor);
      } else {
        $limit_statement = ($get_all) ? "" : sprintf("LIMIT %s, %s", secure($offset, 'int', false), secure($max_results, 'int', false)); /* get_all for cases like download user's posts */
      }
      $get_posts = $db->query("SELECT posts.post_id, " . $cursor_columns[0] . " AS cursor_time FROM posts " . $author_join . $category_join . $where_query . " " . $order_query . " " . $limit_statement);
    }
    if ($get_posts->num_rows > 0) {
      $posts_rows = $get_posts->fetch_all(MYSQLI_ASSOC);
      $posts_ids = array_column($posts_rows, 'post_id');
      /* load the viewer's state for all posts at once */
      $previous_prefetch = $this->_posts_prefetch;
      $this->prefetch_posts($posts_ids);
      try {
        foreach ($posts_ids as $post_id) {
          $post = $this->get_post($post_id, true, true); /* $full_details = true, $pass_privacy_check = true */
          if ($post) {
            /* posts caching system */
            if ($this->_logged_in && $system['newsfeed_caching_enabled'] && !isset($args['query']) && in_array($get, ['newsfeed', 'discover']) && !in_array($filter, ['reel', 'video'])) {
              $db->query(sprintf("INSERT INTO posts_cache (user_id, post_id, cache_date) VALUES (%s, %s, %s)", secure($this->_data['user_id'], 'int'), secure($post['post_id'], 'int'), secure($date)));
            }
            $posts[] = $post;
          }
        }
      } finally {
        $this->_posts_prefetch = $previous_prefetch;
      }
      /* get authors stories */
      if ($posts && $this->_logged_in && $system['stories_enabled']) {
        $authors_ids = [];
        foreach ($posts as $post) {
          if ($post['user_type'] == "user" && !$post['is_anonymous']) {
            $authors_ids[] = $post['user_id'];
          }
        }
        $stories_rings = $this->get_stories_rings($authors_ids);
        foreach ($posts as $index => $post) {
          $posts[$index]['author_story'] = ($post['user_type'] == "user" && !$post['is_anonymous']) ? ($stories_rings[$post['user_id']] ?? '') : '';
        }
      }
      /* the position after the last post read (set last: loading the posts runs other lists) */
      $this->_cursor = null;
      if (!empty($use_cursor)) {
        $last_row = end($posts_rows);
        $this->_cursor = cursor_encode([$last_row['cursor_time'], $last_row['post_id']]);
      }
    }
    return $posts;
  }


  /**
   * newsfeed_sources_clause
   * 
   * @param string $source
   * @return string
   */
  private function newsfeed_sources_clause($source = null)
  {
    global $system;
    $where_query = "";
    switch ($source ?? $system['newsfeed_source']) {
      case 'default':
        if ($this->_logged_in) {
          /* [1] get viewer posts */
          $me = $this->_data['user_id'];
          /* get viewer own posts */
          $where_query .= "(posts.user_id = $me AND posts.user_type = 'user')";
          /* get viewer collaborative posts */
          $where_query .= " OR (posts.is_collaborative = '1' AND posts.user_type = 'user' AND EXISTS (SELECT 1 FROM posts_collaborative_users pcu WHERE pcu.post_id = posts.post_id AND pcu.user_id = $me))";
          /* [2] get posts from friends still followed */
          /* viewer friends posts -> authors */
          $where_query .= sprintf(" OR (posts.user_id IN (%s) AND posts.user_type = 'user' AND posts.privacy = 'friends' AND posts.in_group = '0' AND posts.in_event = '0')", $this->spread_ids($this->get_friends_followings_ids()));
          /* viewer friends posts -> their wall posts */
          $where_query .= sprintf(" OR (posts.in_wall = '1' AND posts.user_type = 'user' AND posts.privacy = 'friends' AND posts.wall_id IN (%s))", $this->spread_ids($this->get_friends_followings_ids()));
          /* viewer friends posts -> collaborative posts */
          $where_query .= sprintf(" OR ( posts.is_collaborative = '1' AND posts.user_type = 'user' AND posts.privacy = 'friends' AND EXISTS (SELECT 1 FROM posts_collaborative_users pcu WHERE pcu.post_id = posts.post_id AND pcu.user_id IN (%s)))", $this->spread_ids($this->get_friends_followings_ids()));
          /* [3] get posts from followings */
          /* viewer followings posts -> authors */
          $where_query .= sprintf(" OR (posts.user_id IN (%s) AND posts.user_type = 'user' AND posts.privacy = 'public' AND posts.in_group = '0' AND posts.in_event = '0')", $this->spread_ids($this->followings_ids()));
          /* viewer followings posts -> their wall posts */
          $where_query .= sprintf(" OR (posts.in_wall = '1' AND posts.user_type = 'user' AND posts.privacy = 'public' AND posts.wall_id IN (%s))", $this->spread_ids($this->followings_ids()));
          /* viewer followings posts -> collaborative posts */
          $where_query .= sprintf(" OR (posts.is_collaborative = '1' AND posts.user_type = 'user' AND posts.privacy = 'public' AND EXISTS (SELECT 1 FROM posts_collaborative_users pcu WHERE pcu.post_id = posts.post_id AND pcu.user_id IN (%s)))", $this->spread_ids($this->followings_ids()));
          /* [4] get viewer liked pages posts */
          $where_query .= sprintf(" OR (posts.user_id IN (%s) AND posts.user_type = 'page')", $this->spread_ids($this->get_pages_ids()));
          /* [5] get groups (memberhsip approved only) posts & exclude the viewer posts */
          $where_query .= sprintf(" OR (posts.group_id IN (%s) AND posts.in_group = '1' AND posts.group_approved = '1' AND posts.user_id != %s)", $this->spread_ids($this->get_groups_ids(true)), $me);
          /* [6] get events posts & exclude the viewer posts */
          $where_query .= sprintf(" OR (posts.event_id IN (%s) AND posts.in_event = '1' AND posts.event_approved = '1' AND posts.user_id != %s)", $this->spread_ids($this->get_events_ids()), $me);
        } else {
          /* get all posts (exclude any post in a group or event and not approved) */
          $where_query .= " posts.privacy = 'public' AND ((posts.in_group = '0' AND posts.in_event = '0') OR (posts.in_group = '1' AND posts.group_approved = '1') OR (posts.in_event = '1' AND posts.event_approved = '1')) ";
        }
        break;

      case 'all_posts':
        /* get all posts (exclude any post in a group or event and not approved) */
        $where_query .= " (posts.in_group = '0' AND posts.in_event = '0') OR (posts.in_group = '1' AND posts.group_approved = '1') OR (posts.in_event = '1' AND posts.event_approved = '1')";
        break;
    }
    return $where_query;
  }


  /**
   * prefetch_posts
   * 
   * @param array $posts_ids
   * @return void
   */
  private function prefetch_posts($posts_ids, $with_comments = true)
  {
    global $db, $system;
    /* POSTS_PREFETCH_DISABLED in config.php loads every post on its own (troubleshooting) */
    if (defined('POSTS_PREFETCH_DISABLED') && POSTS_PREFETCH_DISABLED) {
      return;
    }
    $posts_ids = array_values(array_unique(array_map('intval', $posts_ids)));
    if (!$posts_ids) {
      return;
    }
    /* the posts and the origins of shared posts */
    $nodes = [];
    $round_ids = $posts_ids;
    for ($round = 0; $round < 2 && $round_ids; $round++) {
      $origins_ids = [];
      $get_nodes = $db->query(sprintf("SELECT post_id, user_id, user_type, in_group, group_id, in_event, event_id, post_type, origin_id, comments FROM posts WHERE post_id IN (%s)", implode(',', $round_ids)));
      while ($node = $get_nodes->fetch_assoc()) {
        $nodes[$node['post_id']] = $node;
        if ($node['post_type'] == 'shared' && $node['origin_id'] && !isset($nodes[$node['origin_id']])) {
          $origins_ids[] = (int) $node['origin_id'];
        }
      }
      $round_ids = array_values(array_unique($origins_ids));
    }
    if (!$nodes) {
      return;
    }
    $ids = implode(',', array_keys($nodes));
    $pages_ids = $groups_ids = $events_ids = [];
    foreach ($nodes as $node) {
      if ($node['user_type'] == 'page') {
        $pages_ids[(int) $node['user_id']] = true;
      }
      /* posts inside a group or event, and posts announcing a new group or event */
      if (($node['in_group'] || $node['post_type'] == 'group') && $node['group_id']) {
        $groups_ids[(int) $node['group_id']] = true;
      }
      if (($node['in_event'] || $node['post_type'] == 'event') && $node['event_id']) {
        $events_ids[(int) $node['event_id']] = true;
      }
    }
    $prefetch = [
      'rows_covered' => array_fill_keys(array_keys($nodes), true),
      'rows' => [],
      'details_covered' => [],
      'details' => [],
      'posts' => array_fill_keys(array_keys($nodes), true),
      'saved' => [],
      'reactions' => [],
      'reviews' => [],
      'group_membership' => array_fill_keys(array_keys($groups_ids), false),
      'event_membership' => array_fill_keys(array_keys($events_ids), false),
    ];
    if ($this->_logged_in) {
      $viewer_id = secure($this->_data['user_id'], 'int');
      /* saves */
      $get_saved = $db->query(sprintf("SELECT post_id FROM posts_saved WHERE user_id = %s AND post_id IN (%s)", $viewer_id, $ids));
      while ($saved = $get_saved->fetch_assoc()) {
        $prefetch['saved'][$saved['post_id']] = true;
      }
      /* reactions */
      $get_reactions = $db->query(sprintf("SELECT post_id, reaction FROM posts_reactions WHERE user_id = %s AND post_id IN (%s)", $viewer_id, $ids));
      while ($reaction = $get_reactions->fetch_assoc()) {
        $prefetch['reactions'][$reaction['post_id']] ??= $reaction['reaction'];
      }
      /* groups & events memberships */
      if ($groups_ids) {
        $get_memberships = $db->query(sprintf("SELECT group_id, approved FROM groups_members WHERE user_id = %s AND group_id IN (%s)", $viewer_id, implode(',', array_keys($groups_ids))));
        while ($membership = $get_memberships->fetch_assoc()) {
          $prefetch['group_membership'][$membership['group_id']] = ($membership['approved'] == '1') ? "approved" : "pending";
        }
      }
      if ($events_ids) {
        $get_memberships = $db->query(sprintf("SELECT event_id, is_invited, is_interested, is_going FROM events_members WHERE user_id = %s AND event_id IN (%s)", $viewer_id, implode(',', array_keys($events_ids))));
        while ($membership = $get_memberships->fetch_assoc()) {
          $prefetch['event_membership'][$membership['event_id']] = ['is_invited' => $membership['is_invited'], 'is_interested' => $membership['is_interested'], 'is_going' => $membership['is_going']];
        }
      }
      /* pages & groups admins (the per-request lists check_page_adminship() & check_group_adminship() read) */
      if (!defined('SOCKET_SERVER')) {
        if ($pages_ids) {
          $get_admins = $db->query(sprintf("SELECT page_id, user_id FROM pages_admins WHERE page_id IN (%s)", implode(',', array_keys($pages_ids))));
          $admins = [];
          while ($admin = $get_admins->fetch_assoc()) {
            $admins[$admin['page_id']][] = $admin['user_id'];
          }
          foreach (array_keys($pages_ids) as $page_id) {
            $this->_connections_ids['page_admins'][$page_id] = $admins[$page_id] ?? [];
          }
        }
        if ($groups_ids) {
          $get_admins = $db->query(sprintf("SELECT group_id, user_id FROM groups_admins WHERE group_id IN (%s)", implode(',', array_keys($groups_ids))));
          $admins = [];
          while ($admin = $get_admins->fetch_assoc()) {
            $admins[$admin['group_id']][] = $admin['user_id'];
          }
          foreach (array_keys($groups_ids) as $group_id) {
            $this->_connections_ids['group_admins'][$group_id] = $admins[$group_id] ?? [];
          }
        }
      }
    }
    /* posts rows */
    $get_rows = $db->query($this->post_row_query(sprintf("posts.post_id IN (%s)", $ids), true));
    while ($row = $get_rows->fetch_assoc()) {
      $row_id = $row['prefetch_post_id'];
      unset($row['prefetch_post_id']);
      $prefetch['rows'][$row_id] = $row;
    }
    /* details of each post type */
    $types_ids = [];
    foreach ($nodes as $node) {
      $types_ids[$node['post_type']][] = (int) $node['post_id'];
    }
    foreach ($this->post_details_queries() as $key => [$types, $select, $from, $column, $order]) {
      $details_ids = [];
      foreach ($types as $type) {
        $details_ids = array_merge($details_ids, $types_ids[$type] ?? []);
      }
      if (!$details_ids) {
        continue;
      }
      $prefetch['details_covered'][$key] = array_fill_keys($details_ids, true);
      $get_details = $db->query(sprintf("SELECT %s, %s AS prefetch_post_id FROM %s WHERE %s IN (%s) %s", $select, $column, $from, $column, implode(',', $details_ids), $order));
      while ($detail = $get_details->fetch_assoc()) {
        $detail_id = $detail['prefetch_post_id'];
        unset($detail['prefetch_post_id']);
        $prefetch['details'][$key][$detail_id][] = $detail;
      }
    }
    /* first comments of each post, their first replies and the viewer's reactions on them (as get_comments() & get_replies() load them) */
    $commented_ids = [];
    foreach ($posts_ids as $post_id) {
      if (isset($nodes[$post_id]) && $nodes[$post_id]['comments'] > 0) {
        $commented_ids[] = $post_id;
      }
    }
    if ($commented_ids && $with_comments) {
      $prefetch['details_covered']['comments'] = array_fill_keys($commented_ids, true);
      $prefetch['details']['comments'] = $this->prefetch_comments('post', $commented_ids, "comments.comment_id DESC");
      $comments_ids = $replied_ids = [];
      foreach ($prefetch['details']['comments'] as $post_comments) {
        foreach ($post_comments as $comment) {
          $comments_ids[] = (int) $comment['comment_id'];
          if ($comment['replies'] > 0) {
            $replied_ids[] = (int) $comment['comment_id'];
          }
        }
      }
      if ($replied_ids) {
        $prefetch['details_covered']['replies'] = array_fill_keys($replied_ids, true);
        $prefetch['details']['replies'] = $this->prefetch_comments('comment', $replied_ids, "comments.comment_id ASC");
        foreach ($prefetch['details']['replies'] as $comment_replies) {
          foreach ($comment_replies as $reply) {
            $comments_ids[] = (int) $reply['comment_id'];
          }
        }
      }
      if ($this->_logged_in && $comments_ids) {
        $prefetch['details_covered']['comment_reactions'] = array_fill_keys($comments_ids, true);
        $get_reactions = $db->query(sprintf("SELECT comment_id, reaction FROM posts_comments_reactions WHERE user_id = %s AND comment_id IN (%s)", secure($this->_data['user_id'], 'int'), implode(',', $comments_ids)));
        while ($reaction = $get_reactions->fetch_assoc()) {
          $prefetch['details']['comment_reactions'][$reaction['comment_id']] ??= [['reaction' => $reaction['reaction']]];
        }
      }
    }
    /* reviews counts */
    if ($system['posts_reviews_enabled']) {
      $prefetch['reviews'] = array_fill_keys(array_keys($nodes), '0');
      $get_reviews = $db->query(sprintf("SELECT node_id, COUNT(*) AS count FROM reviews WHERE node_type = 'post' AND node_id IN (%s) GROUP BY node_id", $ids));
      while ($review = $get_reviews->fetch_assoc()) {
        $prefetch['reviews'][$review['node_id']] = $review['count'];
      }
    }
    $this->_posts_prefetch = $prefetch;
  }


  /**
   * posts_search_clause
   *
   * @param string $query
   * @param string $legacy_sql
   * @return string
   */
  public function posts_search_clause($query, $legacy_sql)
  {
    global $db, $system;
    /* check if the search index is ready */
    if (empty($system['posts_search_ready'])) {
      return $legacy_sql;
    }
    /* prepare query */
    $query = get_search_text($query);
    if ($query === '') {
      return "(0)";
    }
    $with_body = !empty($system['blogs_search_content_enabled']);
    /* prepare terms */
    $terms = [];
    if (!preg_match('/[\p{Han}\p{Hiragana}\p{Katakana}\p{Hangul}\p{Thai}\p{Lao}\p{Khmer}\p{Myanmar}]/u', $query)) {
      $stopwords = ['about', 'are', 'com', 'for', 'from', 'how', 'that', 'the', 'this', 'was', 'what', 'when', 'where', 'who', 'will', 'with', 'und', 'www'];
      foreach (explode(' ', $query) as $term) {
        $length = mb_strlen($term, 'UTF-8');
        if ($length < 3 || $length > 84 || in_array(mb_strtolower($term, 'UTF-8'), $stopwords)) {
          continue;
        }
        $terms[mb_strtolower($term, 'UTF-8')] = "+" . $term . "*";
      }
      $terms = array_slice($terms, 0, 8);
    }
    /* prepare condition */
    if ($terms) {
      $condition = sprintf("MATCH (%s) AGAINST ('%s' IN BOOLEAN MODE)", ($with_body) ? "search_text, search_body" : "search_text", $db->real_escape_string(implode(' ', $terms)));
    } else {
      $like = "'%" . $db->real_escape_string($query) . "%'";
      $condition = "search_text LIKE " . $like;
      if ($with_body) {
        $condition .= " OR search_body LIKE " . $like;
      }
    }
    return "(posts.post_id IN (SELECT post_id FROM posts_search WHERE " . $condition . "))";
  }


  /**
   * refresh_post_search
   *
   * @param integer $post_id
   * @return void
   */
  public function refresh_post_search($post_id)
  {
    try {
      $this->refresh_posts_search([$post_id]);
    } catch (Throwable $e) {
      error_log('Post search index: ' . $e->getMessage());
    }
  }


  /**
   * refresh_posts_search
   *
   * @param array $posts_ids
   * @return void
   */
  public function refresh_posts_search($posts_ids)
  {
    global $db;
    $posts_ids = array_values(array_unique(array_filter(array_map('intval', (array) $posts_ids))));
    if (!$posts_ids) {
      return;
    }
    $texts = array_fill_keys($posts_ids, '');
    $bodies = array_fill_keys($posts_ids, '');
    $types = [];
    /* get posts */
    $get_posts = $db->query(sprintf("SELECT post_id, post_type, text, paid_text FROM posts WHERE post_id IN (%s)", implode(',', $posts_ids)));
    while ($post = $get_posts->fetch_assoc()) {
      $types[$post['post_type']][] = $post['post_id'];
      $texts[$post['post_id']] = $post['text'] . ' ' . $post['paid_text'];
    }
    /* get posts details */
    $details = [
      'article' => "SELECT post_id, title, tags, text AS body FROM posts_articles WHERE post_id IN (%s)",
      'rich_text' => "SELECT post_id, text FROM posts_rich_text WHERE post_id IN (%s)",
      'job' => "SELECT post_id, title, location FROM posts_jobs WHERE post_id IN (%s)",
      'product' => "SELECT post_id, name, location FROM posts_products WHERE post_id IN (%s)",
      'course' => "SELECT post_id, title, location FROM posts_courses WHERE post_id IN (%s)",
      'offer' => "SELECT post_id, title FROM posts_offers WHERE post_id IN (%s)",
      'funding' => "SELECT post_id, title FROM posts_funding WHERE post_id IN (%s)",
      'link' => "SELECT post_id, source_host, source_title, source_text FROM posts_links WHERE post_id IN (%s)",
      'media' => "SELECT post_id, source_title, source_text FROM posts_media WHERE post_id IN (%s)",
      'poll' => "SELECT posts_polls.post_id, posts_polls_options.text FROM posts_polls INNER JOIN posts_polls_options ON posts_polls.poll_id = posts_polls_options.poll_id WHERE posts_polls.post_id IN (%s)",
      'merit' => "SELECT post_id, message FROM posts_merits WHERE post_id IN (%s)",
      'live' => "SELECT post_id, live_title FROM posts_live WHERE post_id IN (%s)",
      'album' => "SELECT DISTINCT posts_photos.post_id, posts_photos_albums.title FROM posts_photos INNER JOIN posts_photos_albums ON posts_photos.album_id = posts_photos_albums.album_id WHERE posts_photos.post_id IN (%s)",
    ];
    foreach (array_intersect_key($details, $types) as $type => $details_query) {
      $get_details = $db->query(sprintf($details_query, implode(',', $types[$type])));
      while ($row = $get_details->fetch_assoc()) {
        $post_id = $row['post_id'];
        if (isset($row['body'])) {
          $bodies[$post_id] .= ' ' . $row['body'];
        }
        unset($row['post_id'], $row['body']);
        $texts[$post_id] .= ' ' . implode(' ', $row);
      }
    }
    /* update search index */
    $values = [];
    $values_length = 0;
    $empty_ids = [];
    $insert_query = "INSERT INTO posts_search (post_id, search_text, search_body) VALUES %s ON DUPLICATE KEY UPDATE search_text = VALUES(search_text), search_body = VALUES(search_body)";
    foreach ($posts_ids as $post_id) {
      $text = get_search_text($texts[$post_id]);
      $body = get_search_text($bodies[$post_id]);
      if ($text === '' && $body === '') {
        $empty_ids[] = $post_id;
        continue;
      }
      $value = sprintf("(%s, '%s', '%s')", $post_id, $db->real_escape_string($text), $db->real_escape_string($body));
      $values[] = $value;
      $values_length += strlen($value);
      if ($values_length > 1000000) {
        $db->query(sprintf($insert_query, implode(',', $values)));
        $values = [];
        $values_length = 0;
      }
    }
    if ($values) {
      $db->query(sprintf($insert_query, implode(',', $values)));
    }
    if ($empty_ids) {
      $db->query(sprintf("DELETE FROM posts_search WHERE post_id IN (%s)", implode(',', $empty_ids)));
    }
  }


  /**
   * rebuild_posts_search
   *
   * @param integer $limit
   * @return integer
   */
  public function rebuild_posts_search($limit = 500)
  {
    global $db;
    /* get cursor */
    $get_cursor = $db->query("SELECT option_value FROM system_options WHERE option_name = 'posts_search_cursor'");
    $cursor = ($get_cursor->num_rows > 0) ? $get_cursor->fetch_assoc()['option_value'] : 0;
    /* get posts */
    $get_posts = $db->query(sprintf("SELECT post_id FROM posts WHERE post_id > %s ORDER BY post_id ASC LIMIT %s", secure($cursor, 'int'), secure($limit, 'int', false)));
    $posts_ids = array_column($get_posts->fetch_all(MYSQLI_ASSOC), 'post_id');
    if (!$posts_ids) {
      update_system_options(['posts_search_ready' => secure('1')]);
      return 0;
    }
    $this->refresh_posts_search($posts_ids);
    /* update cursor */
    $db->query(sprintf("INSERT INTO system_options (option_name, option_value) VALUES ('posts_search_cursor', %s) ON DUPLICATE KEY UPDATE option_value = VALUES(option_value)", secure(end($posts_ids), 'int')));
    return count($posts_ids);
  }


  /**
   * get_posts_count
   *
   * @param integer $node_id
   * @param string $node_type
   * @return integer
   */
  public function get_posts_count($node_id, $node_type)
  {
    global $db;
    $node_id = secure($node_id, 'int');
    switch ($node_type) {
      case 'user':
        $where_statement = "WHERE posts.user_id = $node_id AND posts.user_type = 'user' AND posts.in_group = '0' AND posts.in_event = '0'";
        break;

      case 'page':
        $where_statement = "WHERE posts.user_id = $node_id AND posts.user_type = 'page'";
        break;

      case 'group':
        $where_statement = "WHERE posts.group_id = $node_id AND posts.in_group = '1'";
        break;

      case 'event':
        $where_statement = "WHERE posts.event_id = $node_id AND posts.in_event = '1'";
        break;

      default:
        _error(400);
        break;
    }
    $where_statement .= " AND (posts.processing != '1') AND (posts.pre_approved = '1' OR posts.has_approved = '1') ";
    $get_count = $db->query("SELECT COUNT(*) as count FROM posts " . $where_statement);
    return $get_count->fetch_assoc()['count'];
  }


  /**
   * get_post
   * 
   * @param integer $post_id
   * @param boolean $get_comments
   * @param boolean $pass_privacy_check
   * @param boolean $pass_views
   * @return array
   */
  public function get_post($post_id, $get_comments = true, $pass_privacy_check = false, $pass_views = false)
  {
    global $db, $system, $date;

    $post = $this->_check_post($post_id, $pass_privacy_check);
    if (!$post) {
      return false;
    }

    /* og-meta tags */
    $post['og_title'] = ($post['is_anonymous']) ? __("Anonymous") : $post['post_author_name'];
    if ($post['needs_subscription']) {
      if ($post['subscriptions_image']) {
        $post['og_image'] = $system['system_uploads'] . '/' . $post['subscriptions_image'];
      }
    }
    if ($post['needs_payment'] && !$post['can_get_details']) {
      $post['og_title'] .= ($post['paid_text'] != "") ? " - " . $post['paid_text'] : "";
      $post['og_description'] = $post['paid_text'];
      if ($post['paid_image']) {
        $post['og_image'] = $system['system_uploads'] . '/' . $post['paid_image'];
      }
    }

    if ($post['can_get_details']) {
      /* parse text */
      $this->prepare_post_text($post);

      /* og-meta tags */
      $post['og_title'] .= ($post['text_plain'] != "") ? " - " . $post['text_plain'] : "";
      $post['og_description'] = $post['text_plain'];

      /* post type */
      /* check if post is a shared post */
      if ($post['post_type'] == 'shared') {
        /* get origin post */
        $post['origin'] = $this->get_post($post['origin_id'], false, false, $pass_views);
        /* check if origin post has been deleted */
        if (!$post['origin']) {
          return false;
        }
      }
      /* check if post is a status post */
      if ($post['post_type'] == '') {
        /* get colored pattern */
        if ($post['colored_pattern']) {
          $post['colored_pattern'] = $this->get_posts_colored_pattern($post['colored_pattern']);
        }
      }
      /* check if post is a link post */
      if ($post['post_type'] == 'link') {
        /* get link */
        $get_link = $this->post_details('link', $post['post_id']) ?? $db->query(sprintf("SELECT * FROM posts_links WHERE post_id = %s", secure($post['post_id'], 'int')));
        /* check if link has been deleted */
        if ($get_link->num_rows == 0) {
          return false;
        }
        $post['link'] = $get_link->fetch_assoc();

        /* og-meta tags */
        $post['og_title'] = $post['link']['source_title'];
        $post['og_image'] = $post['link']['source_thumbnail'];
      }
      /* check if post is a media post */
      if ($post['post_type'] == 'media') {
        /* get media */
        $get_media = $this->post_details('media', $post['post_id']) ?? $db->query(sprintf("SELECT * FROM posts_media WHERE post_id = %s", secure($post['post_id'], 'int')));
        /* check if media has been deleted */
        if ($get_media->num_rows == 0) {
          return false;
        }
        $post['media'] = $get_media->fetch_assoc();
        /* og-meta tags */
        $post['og_title'] = $post['media']['source_title'];
        $post['og_image'] = $post['media']['source_thumbnail'];
      }
      /* check if post is a live post */
      if ($post['post_type'] == 'live') {
        /* get live details */
        $get_live = $this->post_details('live', $post['post_id']) ?? $db->query(sprintf("SELECT posts_live.*, posts_live_categories.category_name, (SELECT COUNT(*) FROM posts_live_users WHERE posts_live_users.post_id = posts_live.post_id) AS live_viewers FROM posts_live LEFT JOIN posts_live_categories ON posts_live.category_id = posts_live_categories.category_id WHERE posts_live.post_id = %s", secure($post['post_id'], 'int')));
        /* check if live has been deleted */
        if ($get_live->num_rows == 0) {
          return false;
        }
        $post['live'] = $get_live->fetch_assoc();
        $post['live']['category_url'] = get_url_text($post['live']['category_name'] ?? '');
        if (!$post['live']['live_ended']) {
          if ($post['live']['live_provider'] == "livekit") {
            /* generate new audience livekit (token) */
            $livekit = $this->livekit_live_token_builder(false, $post['live']['livekit_room']);
            $post['live']['livekit_audience_token'] = $livekit['token'] ?? null;
            $post['live']['livekit_audience_identity'] = $livekit['identity'] ?? null;
          } else {
            /* generate new audience agora (uid|token) */
            $agora = $this->agora_token_builder(false, $post['live']['agora_channel_name']);
            $post['live']['agora_audience_uid'] = $agora['uid'];
            $post['live']['agora_audience_token'] = $agora['token'];
          }
        }
      }
      /* check if post post has photos */
      if (in_array($post['post_type'], ['photos', 'album', 'profile_picture', 'profile_cover', 'page_picture', 'page_cover', 'group_picture', 'group_cover', 'event_cover', 'combo'])) {
        /* get photos */
        $get_photos = $this->post_details('photos', $post['post_id']) ?? $db->query(sprintf("SELECT * FROM posts_photos WHERE post_id = %s ORDER BY sort_order ASC, photo_id ASC", secure($post['post_id'], 'int')));
        $post['photos_num'] = $get_photos->num_rows;
        /* check if photos has been deleted */
        if ($post['photos_num'] == 0 && $post['post_type'] != 'combo') {
          return false;
        } else {
          while ($post_photo = $get_photos->fetch_assoc()) {
            $post['photos'][] = $post_photo;
          }
          if ($post['post_type'] == 'album') {
            $post['album'] = $this->get_album($post['photos'][0]['album_id'], false);
            if (!$post['album']) {
              return false;
            }
            /* og-meta tags */
            $post['og_title'] = $post['album']['title'];
            $post['og_image'] = $post['album']['cover'];
          } else {
            /* og-meta tags */
            $post['og_image'] = $system['system_uploads'] . '/' . $post['photos'][0]['source'];
          }
        }
      }
      /* check if post is a blog post */
      if ($post['post_type'] == 'article') {
        /* get blog */
        $get_blog = $this->post_details('article', $post['post_id']) ?? $db->query(sprintf("SELECT posts_articles.*, blogs_categories.category_name FROM posts_articles LEFT JOIN blogs_categories ON posts_articles.category_id = blogs_categories.category_id WHERE posts_articles.post_id = %s", secure($post['post_id'], 'int')));
        /* check if blog has been deleted */
        if ($get_blog->num_rows == 0) {
          return false;
        }
        $post['blog'] = $get_blog->fetch_assoc();
        /* get references */
        $get_references = $this->post_details('article_references', $post['post_id']) ?? $db->query(sprintf("SELECT title, link FROM posts_articles_references WHERE post_id = %s", secure($post['post_id'], 'int')));
        if ($get_references->num_rows > 0) {
          while ($reference = $get_references->fetch_assoc()) {
            $post['blog']['references'][] = $reference;
          }
        }
        /* check blogs permissions */
        $post['needs_pro_package'] = false;
        /* check if user is not the author of the post or not admin */
        if ($this->_data['user_id'] != $post['author_id'] && !$this->_is_admin) {
          /* check if user can read blogs OR blogs category in user_package_blogs_categories_ids */
          if (!$this->_data['can_read_blogs'] || ($system['packages_enabled'] && $this->_data['user_subscribed'] && $this->_data['allowed_blogs_categories'] > 0)) {
            if ($post['blog']['category_id'] && $this->_data['user_package_blogs_categories_ids'] && !in_array($post['blog']['category_id'], $this->_data['user_package_blogs_categories_ids'])) {
              $post['needs_pro_package'] = true;
              return $post;
            }
          }
        }
        $post['blog']['category_name'] = ($post['blog']['category_name']) ? $post['blog']['category_name'] : __("Uncategorized");
        $post['blog']['category_url'] = get_url_text($post['blog']['category_name']);
        $post['blog']['parsed_cover'] = get_picture($post['blog']['cover'], 'blog');
        $post['blog']['title_url'] = get_url_text($post['blog']['title']);
        $post['blog']['parsed_text'] = htmlspecialchars_decode($post['blog']['text'], ENT_QUOTES);
        $post['blog']['text_snippet'] = get_snippet_text($post['blog']['text']);
        $tags = (!is_empty($post['blog']['tags'])) ? explode(',', $post['blog']['tags']) : [];
        $post['blog']['parsed_tags'] = array_map('get_tag', $tags);
        /* og-meta tags */
        $post['og_title'] = $post['blog']['title'];
        $post['og_description'] = $post['blog']['text_snippet'];
        $post['og_image'] = $post['blog']['parsed_cover'];
      }
      /* check if post is a rich text post */
      if ($post['post_type'] == 'rich_text') {
        /* get rich text */
        $get_rich_text = $this->post_details('rich_text', $post['post_id']) ?? $db->query(sprintf("SELECT posts_rich_text.* FROM posts_rich_text WHERE posts_rich_text.post_id = %s", secure($post['post_id'], 'int')));
        /* check if rich text has been deleted */
        if ($get_rich_text->num_rows == 0) {
          return false;
        }
        $post['rich_text'] = $get_rich_text->fetch_assoc();
        $post['rich_text']['parsed_text'] = htmlspecialchars_decode($post['rich_text']['text'], ENT_QUOTES);
        $post['rich_text']['text_snippet'] = get_snippet_text($post['rich_text']['text']);
        /* og-meta tags */
        $post['og_title'] = $post['rich_text']['text_snippet'];
        $post['og_description'] = $post['rich_text']['text_snippet'];
      }
      /* check if post is a product post */
      if ($post['post_type'] == 'product') {
        /* get product */
        $get_product = $this->post_details('product', $post['post_id']) ?? $db->query(sprintf("SELECT posts_products.*, market_categories.category_name FROM posts_products INNER JOIN market_categories ON posts_products.category_id = market_categories.category_id WHERE posts_products.post_id = %s", secure($post['post_id'], 'int')));
        /* check if product has been deleted */
        if ($get_product->num_rows == 0) {
          return false;
        }
        $post['product'] = $get_product->fetch_assoc();
        $post['product']['category_url'] = get_url_text($post['product']['category_name']);
        /* get photos */
        $get_photos = $this->post_details('photos_latest', $post['post_id']) ?? $db->query(sprintf("SELECT * FROM posts_photos WHERE post_id = %s ORDER BY photo_id DESC", secure($post['post_id'], 'int')));
        $post['photos_num'] = $get_photos->num_rows;
        /* check if photos has been deleted */
        if ($post['photos_num'] > 0) {
          while ($post_photo = $get_photos->fetch_assoc()) {
            $post['photos'][] = $post_photo;
          }
          /* og-meta tags */
          $post['og_image'] = $system['system_uploads'] . '/' . $post['photos'][0]['source'];
        }
        /* product price */
        $post['product']['price_formatted'] = print_money($post['product']['price']);
        /* og-meta tags */
        $post['og_title'] = $post['product']['name'];
      }
      /* check if post is a funding post */
      if ($post['post_type'] == 'funding') {
        /* get funding */
        $get_funding = $this->post_details('funding', $post['post_id']) ?? $db->query(sprintf("SELECT posts_funding.*, funding_categories.category_name FROM posts_funding LEFT JOIN funding_categories ON posts_funding.category_id = funding_categories.category_id WHERE posts_funding.post_id = %s", secure($post['post_id'], 'int')));
        /* check if funding has been deleted */
        if ($get_funding->num_rows == 0) {
          return false;
        }
        $post['funding'] = $get_funding->fetch_assoc();
        if ($post['funding']['category_name']) {
          $post['funding']['category_url'] = get_url_text($post['funding']['category_name']);
        }
        $post['funding']['funding_completion'] = round($post['funding']['raised_amount'] * (100 / $post['funding']['amount']));
        /* og-meta tags */
        $post['og_title'] = $post['funding']['title'];
        $post['og_image'] = $system['system_uploads'] . '/' . $post['funding']['cover_image'];
      }
      /* check if post is a offer post */
      if ($post['post_type'] == 'offer') {
        /* get offer */
        $get_offer = $this->post_details('offer', $post['post_id']) ?? $db->query(sprintf("SELECT * FROM posts_offers WHERE post_id = %s", secure($post['post_id'], 'int')));
        /* check if offer has been deleted */
        if ($get_offer->num_rows == 0) {
          return false;
        }
        $post['offer'] = $get_offer->fetch_assoc();
        /* check offers permissions */
        $post['needs_permission'] = false;
        /* check if user is not the author of the post or not admin */
        if ($this->_data['user_id'] != $post['author_id'] && !$this->_is_admin) {
          /* check if user can read offers */
          if (!$this->_data['can_read_offers']) {
            $post['needs_permission'] = true;
            return $post;
          }
        }
        /* prepare offer title */
        switch ($post['offer']['discount_type']) {
          case 'discount_percent':
            $post['offer']['meta_title'] = $post['offer']['discount_percent'] . "% " . __("Off") . " " . $post['offer']['title'];
            break;

          case 'discount_amount':
            $post['offer']['meta_title'] = print_money($post['offer']['discount_amount']) . " " . __("Off") . " " . $post['offer']['title'];
            break;

          case 'buy_get_discount':
            $post['offer']['meta_title'] = __("Buy") . " " . $post['offer']['buy_x'] . " " . __("Get") . " " . $post['offer']['get_y'] . " " . $post['offer']['title'];
            break;

          case 'spend_get_off':
            $post['offer']['meta_title'] = __("Spend") . " " . print_money($post['offer']['spend_x']) . " " . __("Get") . " " . print_money($post['offer']['amount_y']) . " " . __("Off") . " " . $post['offer']['title'];
            break;

          case 'free_shipping':
            $post['offer']['meta_title'] = __("Free Shipping") . " " . $post['offer']['title'];
            break;
        }
        /* og-meta tags */
        $post['og_title'] = $post['offer']['meta_title'];
        $post['og_image'] = $system['system_uploads'] . '/' . $post['offer']['thumbnail'];
        /* get photos */
        $get_photos = $this->post_details('photos_latest', $post['post_id']) ?? $db->query(sprintf("SELECT * FROM posts_photos WHERE post_id = %s ORDER BY photo_id DESC", secure($post['post_id'], 'int')));
        $post['photos_num'] = $get_photos->num_rows;
        /* check if photos has been deleted */
        if ($post['photos_num'] > 0) {
          while ($post_photo = $get_photos->fetch_assoc()) {
            $post['photos'][] = $post_photo;
          }
          /* set offer thumbnail */
          $post['offer']['thumbnail'] = $post['photos'][0]['source'];
          /* og-meta tags */
          $post['og_image'] = $system['system_uploads'] . '/' . $post['photos'][0]['source'];
        }
      }
      /* check if post is a job post */
      if ($post['post_type'] == 'job') {
        /* get job */
        $get_job = $this->post_details('job', $post['post_id']) ?? $db->query(sprintf("SELECT * FROM posts_jobs WHERE post_id = %s", secure($post['post_id'], 'int')));
        /* check if job has been deleted */
        if ($get_job->num_rows == 0) {
          return false;
        }
        $post['job'] = $get_job->fetch_assoc();
        /* get job minimum salary currency */
        $post['job']['salary_minimum_currency'] = $this->get_currency($post['job']['salary_minimum_currency']);
        /* get job maximum salary currency */
        $post['job']['salary_maximum_currency'] = $this->get_currency($post['job']['salary_maximum_currency']);
        /* prepare job meta data */
        switch ($post['job']['pay_salary_per']) {
          case 'per_hour':
            $post['job']['pay_salary_per_meta'] = __("Hour");
            break;

          case 'per_day':
            $post['job']['pay_salary_per_meta'] = __("Day");
            break;

          case 'per_week':
            $post['job']['pay_salary_per_meta'] = __("Week");
            break;

          case 'per_month':
            $post['job']['pay_salary_per_meta'] = __("Month");
            break;

          case 'per_year':
            $post['job']['pay_salary_per_meta'] = __("Year");
            break;
        }
        switch ($post['job']['type']) {
          case 'full_time':
            $post['job']['type_meta'] = __("Full Time");
            break;

          case 'part_time':
            $post['job']['type_meta'] = __("Part Time");
            break;

          case 'internship':
            $post['job']['type_meta'] = __("Internship");
            break;

          case 'volunteer':
            $post['job']['type_meta'] = __("Volunteer");
            break;

          case 'contract':
            $post['job']['type_meta'] = __("Contract");
            break;
        }
        /* prepare job questions */
        if ($post['job']['question_1_type'] == "multiple_choice" && $post['job']['question_1_title']) {
          $post['job']['question_1_options'] = explode(PHP_EOL, $post['job']['question_1_choices']);
        }
        if ($post['job']['question_2_type'] == "multiple_choice" && $post['job']['question_2_title']) {
          $post['job']['question_2_options'] = explode(PHP_EOL, $post['job']['question_2_choices']);
        }
        if ($post['job']['question_3_type'] == "multiple_choice" && $post['job']['question_3_title']) {
          $post['job']['question_3_options'] = explode(PHP_EOL, $post['job']['question_3_choices']);
        }
        /* get candidates count */
        $post['job']['candidates_count'] = $this->get_total_job_candidates($post['post_id']);
        /* og-meta tags */
        $post['og_title'] = $post['job']['title'];
        $post['og_image'] = $system['system_uploads'] . '/' . $post['job']['cover_image'];
      }
      /* check if post is a course post */
      if ($post['post_type'] == 'course') {
        /* get course */
        $get_course = $this->post_details('course', $post['post_id']) ?? $db->query(sprintf("SELECT * FROM posts_courses WHERE post_id = %s", secure($post['post_id'], 'int')));
        /* check if course has been deleted */
        if ($get_course->num_rows == 0) {
          return false;
        }
        $post['course'] = $get_course->fetch_assoc();
        /* get course fees */
        $post['course']['fees_currency'] = $this->get_currency($post['course']['fees_currency']);
        /* get candidates count */
        $post['course']['candidates_count'] = $this->get_total_course_candidates($post['post_id']);
        /* check viewer application */
        $post['course']['i_applied'] = $this->_logged_in && $this->check_user_course_application($post['post_id']);
        /* og-meta tags */
        $post['og_title'] = $post['course']['title'];
        $post['og_image'] = $system['system_uploads'] . '/' . $post['course']['cover_image'];
      }
      /* check if post is a poll post */
      if ($post['post_type'] == 'poll') {
        $post['poll'] = $this->get_poll($post['post_id']);
        if (!$post['poll']) {
          return false;
        }
      }
      /* check if post is a reel post */
      if ($post['post_type'] == 'reel') {
        /* get reel */
        $get_reel = $this->post_details('reel', $post['post_id']) ?? $db->query(sprintf("SELECT posts_reels.* FROM posts_reels WHERE posts_reels.post_id = %s", secure($post['post_id'], 'int')));
        /* check if reel has been deleted */
        if ($get_reel->num_rows == 0) {
          return false;
        }
        $post['reel'] = $get_reel->fetch_assoc();
        /* og-meta tags */
        if ($post['reel']['thumbnail']) {
          $post['og_image'] = $system['system_uploads'] . '/' . $post['reel']['thumbnail'];
        }
      }
      /* check if post is a video post */
      if ($post['post_type'] == 'video' || $post['post_type'] == 'combo') {
        /* get video */
        $get_video = $this->post_details('video', $post['post_id']) ?? $db->query(sprintf("SELECT posts_videos.*, posts_videos_categories.category_name FROM posts_videos LEFT JOIN posts_videos_categories ON posts_videos.category_id = posts_videos_categories.category_id WHERE posts_videos.post_id = %s", secure($post['post_id'], 'int')));
        /* check if video has been deleted */
        if ($get_video->num_rows == 0) {
          if ($post['post_type'] != 'combo') {
            return false;
          }
        } else {
          $post['video'] = $get_video->fetch_assoc();
          $post['video']['category_url'] = get_url_text($post['video']['category_name']);
          /* og-meta tags */
          if ($post['video']['thumbnail']) {
            $post['og_image'] = $system['system_uploads'] . '/' . $post['video']['thumbnail'];
          }
          /* check videos permissions */
          $post['needs_pro_package'] = false;
          /* check if user is not the author of the post or not admin */
          if ($this->_data['user_id'] != $post['author_id'] && !$this->_is_admin) {
            /* check if user can watch videos OR video category in user_package_videos_categories_ids */
            if (!$this->_data['can_watch_videos'] || ($system['packages_enabled'] && $this->_data['user_subscribed'] && $this->_data['allowed_videos_categories'] > 0)) {
              if ($post['video']['category_id'] && $this->_data['user_package_videos_categories_ids'] && !in_array($post['video']['category_id'], $this->_data['user_package_videos_categories_ids'])) {
                $post['needs_pro_package'] = true;
                return $post;
              }
            }
          }
        }
      }
      /* check if post is a audio post */
      if ($post['post_type'] == 'audio' || $post['post_type'] == 'combo') {
        /* get audio */
        $get_audio = $this->post_details('audio', $post['post_id']) ?? $db->query(sprintf("SELECT * FROM posts_audios WHERE post_id = %s", secure($post['post_id'], 'int')));
        /* check if audio has been deleted */
        if ($get_audio->num_rows == 0) {
          if ($post['post_type'] != 'combo') {
            return false;
          }
        } else {
          $post['audio'] = $get_audio->fetch_assoc();
        }
      }
      /* check if post is a file post */
      if ($post['post_type'] == 'file' || $post['post_type'] == 'combo') {
        /* get file */
        $get_file = $this->post_details('file', $post['post_id']) ?? $db->query(sprintf("SELECT * FROM posts_files WHERE post_id = %s", secure($post['post_id'], 'int')));
        /* check if file has been deleted */
        if ($get_file->num_rows == 0) {
          if ($post['post_type'] != 'combo') {
            return false;
          }
        } else {
          $post['file'] = $this->decorate_file_attachment($get_file->fetch_assoc());
        }
      }
      /* check if post is merit post */
      if ($post['post_type'] == 'merit') {
        /* get merit */
        $get_merit = $this->post_details('merit', $post['post_id']) ?? $db->query(sprintf("SELECT posts_merits.*, merits_categories.category_name, merits_categories.category_image FROM posts_merits LEFT JOIN merits_categories ON posts_merits.category_id = merits_categories.category_id WHERE posts_merits.post_id = %s", secure($post['post_id'], 'int')));
        /* check if merit has been deleted */
        if ($get_merit->num_rows == 0) {
          return false;
        }
        $post['merit'] = $get_merit->fetch_assoc();
      }
      /* check if post is a group post */
      if ($post['post_type'] == 'group') {
        /* get group */
        $group = $this->get_group($post['post_group_id']);
        /* check if group has been deleted */
        if (!$group) {
          return false;
        }
        $group['group_members_formatted'] = abbreviate_count($group['group_members']);
        $group['i_joined'] = $this->check_group_membership($this->_data['user_id'], $group['group_id']);
        $post['group'] = $group;
        /* og-meta tags */
        $post['og_title'] = $group['group_title'];
        $post['og_image'] = $system['system_uploads'] . '/' . $group['group_cover'];
      }
      /* check if post is a event post */
      if ($post['post_type'] == 'event') {
        /* get event */
        $event = $this->get_event($post['post_event_id']);
        /* check if event has been deleted */
        if (!$event) {
          return false;
        }
        $event['event_interested_formatted'] = abbreviate_count($event['event_interested']);
        $event['i_joined'] = $this->check_event_membership($this->_data['user_id'], $event['event_id']);
        $post['event'] = $event;
        /* og-meta tags */
        $post['og_title'] = $event['event_title'];
        $post['og_image'] = $system['system_uploads'] . '/' . $event['event_cover'];
      }

      /* custom fields */
      if (in_array($post['post_type'], ['product', 'offer', 'job', 'course'])) {
        $post['custom_fields'] = $this->get_custom_fields(["for" => $post['post_type'], "get" => "profile", "node_id" => $post['post_id']]);
      }

      /* post feeling */
      if (!is_empty($post['feeling_action']) && !is_empty($post['feeling_value'])) {
        if ($post['feeling_action'] != "Feeling") {
          $_feeling_icon = get_feeling_icon($post['feeling_action'], get_feelings());
        } else {
          $_feeling_icon = get_feeling_icon($post['feeling_value'], get_feelings_types());
        }
        if ($_feeling_icon) {
          $post['feeling_icon'] = $_feeling_icon;
        }
      }

      /* get post comments */
      if ($get_comments) {
        if ($post['comments'] > 0) {
          $post['post_comments'] = $this->get_comments($post['post_id'], 0, true, true, $post);
        }
      }

      /* update post views */
      if ($system['posts_views_enabled'] && !$pass_views) {
        $this->count_post_view($post);
      }
    }

    /* get author story */
    if ($this->_posts_prefetch === null && $this->_logged_in && $system['stories_enabled'] && $post['user_type'] == "user" && !$post['is_anonymous']) {
      $post['author_story'] = $this->get_stories_rings([$post['user_id']])[$post['user_id']] ?? '';
    }
    return $post;
  }


  /**
   * get_boosted_posts
   * 
   * @param integer $count
   * @return array
   */
  public function get_boosted_posts($count = 5)
  {
    global $db, $system;
    $viewer_id = ($this->_logged_in) ? secure($this->_data['user_id'], 'int') : false;
    $candidates = sample_ids('posts', 'post_id', "boosted = '1'", $count * 2, [
      'pool' => 200,
      'shared' => 'boosted_posts',
      'filter' => function ($ids) use ($db, $viewer_id) {
        $ids = implode(',', $ids);
        $hidden_statement = ($viewer_id) ? sprintf(" AND post_id NOT IN (SELECT post_id FROM posts_hidden WHERE user_id = %s AND post_id IN (%s))", $viewer_id, $ids) : "";
        return array_column($db->query(sprintf("SELECT post_id FROM posts WHERE post_id IN (%s) AND time < NOW()" . $hidden_statement, $ids))->fetch_all(MYSQLI_ASSOC), 'post_id');
      },
    ]);
    /* the next candidate when one can't be shown */
    $posts = [];
    foreach ($candidates as $post_id) {
      $post = $this->get_post($post_id, true, true);
      if ($post) {
        $posts[] = $post;
        if (count($posts) >= $count) {
          break;
        }
      }
    }
    return $posts;
  }


  /**
   * index_post_location
   * 
   * @param integer $post_id
   * @param string $post_type
   * @return void
   */
  public function index_post_location($post_id, $post_type)
  {
    global $db;
    if (!in_array($post_type, ['article', 'product', 'job', 'offer', 'funding', 'course']) || !valid_location($this->_data['user_latitude'] ?? null, $this->_data['user_longitude'] ?? null)) {
      return;
    }
    $db->query(sprintf("INSERT IGNORE INTO posts_locations (post_id, post_type, location) VALUES (%s, %s, %s)", secure($post_id, 'int'), secure($post_type), location_point($this->_data['user_latitude'], $this->_data['user_longitude'])));
  }


  /**
   * get_nearby_listing_ids
   * 
   * @param string $post_type
   * @param float $distance
   * @param string $from_query
   * @param string $order_query
   * @return array|null
   */
  private function get_nearby_listing_ids($post_type, $distance, $from_query, $order_query)
  {
    global $db, $system;
    if (!valid_location($this->_data['user_latitude'] ?? null, $this->_data['user_longitude'] ?? null)) {
      return null;
    }
    $unit_km = ($system['system_distance'] == "mile") ? 1.609344 : 1;
    $nearby = nearby_ids('posts_locations', 'post_id', $this->_data['user_latitude'], $this->_data['user_longitude'], $distance * $unit_km, PHP_INT_MAX, [
      'post_type' => $post_type,
      'filter' => function ($ids) use ($db, $from_query) {
        return array_column($db->query("SELECT posts.post_id" . $from_query . " AND posts.post_id IN (" . implode(',', $ids) . ")")->fetch_all(MYSQLI_ASSOC), 'post_id');
      },
    ]);
    if (!$nearby) {
      return [];
    }
    /* equal distances (posts of the same author) keep the listing's order */
    $ranks = array_flip(array_map('intval', array_column($db->query("SELECT posts.post_id" . $from_query . " AND posts.post_id IN (" . implode(',', array_keys($nearby)) . ")" . $order_query . ", posts.post_id DESC")->fetch_all(MYSQLI_ASSOC), 'post_id')));
    $posts_ids = array_keys($nearby);
    usort($posts_ids, fn($a, $b) => ($nearby[$a] <=> $nearby[$b]) ?: ($ranks[$a] <=> $ranks[$b]));
    return $posts_ids;
  }


  /**
   * get_promoted_posts
   * 
   * @param string $post_type
   * @param string $details_table
   * @param array $args
   * @return array
   */
  public function get_promoted_posts($post_type, $details_table, $args = [])
  {
    global $db;
    $available = $args['available'] ?? false;
    $in_groups_events = $args['in_groups_events'] ?? false;
    $scheduled = $args['scheduled'] ?? false;
    $get_comments = $args['get_comments'] ?? true;
    $pass_views = $args['pass_views'] ?? false;
    $results = $args['results'] ?? 3;
    $promoted = [];
    /* prepare where statement */
    $where_statement = "";
    if (!$in_groups_events) {
      $where_statement .= " AND posts.in_group = '0' AND posts.in_event = '0'";
    }
    if ($available) {
      $where_statement .= sprintf(" AND `%s`.available = '1'", $details_table);
    }
    if ($scheduled) {
      $where_statement .= " AND (posts.is_schedule = '0' OR posts.time <= NOW())";
    }
    $posts_ids = sample_ids('posts', 'post_id', sprintf("boosted = '1' AND post_type = %s", secure($post_type)), $results, [
      'pool' => 200,
      'shared' => 'promoted_posts:' . $post_type,
      'filter' => function ($ids) use ($db, $details_table, $where_statement) {
        return array_column($db->query(sprintf("SELECT posts.post_id FROM posts INNER JOIN `%s` ON posts.post_id = `%s`.post_id WHERE posts.post_id IN (%s) AND (posts.pre_approved = '1' OR posts.has_approved = '1')" . $where_statement, $details_table, $details_table, implode(',', $ids)))->fetch_all(MYSQLI_ASSOC), 'post_id');
      },
    ]);
    if ($posts_ids) {
      $previous_prefetch = $this->_posts_prefetch;
      $this->prefetch_posts($posts_ids, $get_comments);
      try {
        foreach ($posts_ids as $post_id) {
          $post = $this->get_post($post_id, $get_comments, false, $pass_views);
          if ($post) {
            $promoted[] = $post;
          }
        }
      } finally {
        $this->_posts_prefetch = $previous_prefetch;
      }
    }
    return $promoted;
  }


  /**
   * who_reacts
   * 
   * @param array $args
   * @return array
   */
  public function who_reacts($args = [])
  {
    global $db, $system;
    /* initialize arguments */
    $post_id = !isset($args['post_id']) ? null : $args['post_id'];
    $photo_id = !isset($args['photo_id']) ? null : $args['photo_id'];
    $comment_id = !isset($args['comment_id']) ? null : $args['comment_id'];
    $message_id = !isset($args['message_id']) ? null : $args['message_id'];
    $reaction_type = !isset($args['reaction_type']) ? 'all' : $args['reaction_type'];
    /* check reation type */
    if (!in_array($reaction_type, ['all', 'like', 'love', 'haha', 'yay', 'wow', 'sad', 'angry'])) {
      _error(403);
    }
    $offset = !isset($args['offset']) ? 0 : $args['offset'];
    /* initialize vars */
    $users = [];
    $this->_cursor = null;
    $offset *= $system['max_results'];
    if ($post_id != null) {
      /* where statement */
      $where_statement = ($reaction_type == "all") ? "" : sprintf("AND posts_reactions.reaction = %s", secure($reaction_type));
      /* friends & followings first, then everyone else (a page of users ids, read through the index) */
      [$page_ids, $next_cursor] = $this->get_friends_first_page('posts_reactions', 'user_id', sprintf("posts_reactions.post_id = %s " . $where_statement, secure($post_id, 'int')), $offset, $system['max_results'], $args['cursor'] ?? null);
      /* get users who like the post */
      $get_users = $db->query(sprintf(
        'SELECT posts_reactions.reaction, users.user_id, users.user_name, users.user_firstname, 
                users.user_lastname, users.user_gender, users.user_picture, users.user_subscribed, packages.name as package_name, 
                users.user_verified 
         FROM posts_reactions 
         INNER JOIN users ON (posts_reactions.user_id = users.user_id)
         LEFT JOIN packages ON users.user_subscribed = "1" AND users.user_package = packages.package_id  
         WHERE posts_reactions.post_id = %s ' . $where_statement . ' 
         AND users.user_id IN (' . $this->spread_ids($page_ids) . ')',
        secure($post_id, 'int')
      ));
    } elseif ($photo_id != null) {
      /* where statement */
      $where_statement = ($reaction_type == "all") ? "" : sprintf("AND posts_photos_reactions.reaction = %s", secure($reaction_type));
      /* friends & followings first, then everyone else (a page of users ids, read through the index) */
      [$page_ids, $next_cursor] = $this->get_friends_first_page('posts_photos_reactions', 'user_id', sprintf("posts_photos_reactions.photo_id = %s " . $where_statement, secure($photo_id, 'int')), $offset, $system['max_results'], $args['cursor'] ?? null);
      /* get users who like the photo */
      $get_users = $db->query(sprintf(
        'SELECT posts_photos_reactions.reaction, users.user_id, users.user_name, users.user_firstname,
                users.user_lastname, users.user_gender, users.user_picture, users.user_subscribed, packages.name as package_name,
                users.user_verified
         FROM posts_photos_reactions
         INNER JOIN users ON (posts_photos_reactions.user_id = users.user_id)
         LEFT JOIN packages ON users.user_subscribed = "1" AND users.user_package = packages.package_id 
         WHERE posts_photos_reactions.photo_id = %s ' . $where_statement . '
         AND users.user_id IN (' . $this->spread_ids($page_ids) . ')',
        secure($photo_id, 'int')
      ));
    } elseif ($comment_id != null) {
      /* where statement */
      $where_statement = ($reaction_type == "all") ? "" : sprintf("AND posts_comments_reactions.reaction = %s", secure($reaction_type));
      /* friends & followings first, then everyone else (a page of users ids, read through the index) */
      [$page_ids, $next_cursor] = $this->get_friends_first_page('posts_comments_reactions', 'user_id', sprintf("posts_comments_reactions.comment_id = %s " . $where_statement, secure($comment_id, 'int')), $offset, $system['max_results'], $args['cursor'] ?? null);
      /* get users who like the comment */
      $get_users = $db->query(sprintf(
        'SELECT posts_comments_reactions.reaction, users.user_id, users.user_name, users.user_firstname,
                users.user_lastname, users.user_gender, users.user_picture, users.user_subscribed, packages.name as package_name,
                users.user_verified
         FROM posts_comments_reactions
         INNER JOIN users ON (posts_comments_reactions.user_id = users.user_id)
         LEFT JOIN packages ON users.user_subscribed = "1" AND users.user_package = packages.package_id 
         WHERE posts_comments_reactions.comment_id = %s ' . $where_statement . '
         AND users.user_id IN (' . $this->spread_ids($page_ids) . ')',
        secure($comment_id, 'int')
      ));
    } elseif ($message_id != null) {
      /* where statement */
      $where_statement = ($reaction_type == "all") ? "" : sprintf("AND conversations_messages_reactions.reaction = %s", secure($reaction_type));
      /* friends & followings first, then everyone else (a page of users ids, read through the index) */
      [$page_ids, $next_cursor] = $this->get_friends_first_page('conversations_messages_reactions', 'user_id', sprintf("conversations_messages_reactions.message_id = %s " . $where_statement, secure($message_id, 'int')), $offset, $system['max_results'], $args['cursor'] ?? null);
      /* get users who like the message */
      $get_users = $db->query(sprintf(
        'SELECT conversations_messages_reactions.reaction, users.user_id, users.user_name, users.user_firstname,
                users.user_lastname, users.user_gender, users.user_picture, users.user_subscribed, packages.name as package_name,
                users.user_verified
         FROM conversations_messages_reactions
         INNER JOIN users ON (conversations_messages_reactions.user_id = users.user_id)
         LEFT JOIN packages ON users.user_subscribed = "1" AND users.user_package = packages.package_id 
         WHERE conversations_messages_reactions.message_id = %s ' . $where_statement . '
         AND users.user_id IN (' . $this->spread_ids($page_ids) . ')',
        secure($message_id, 'int')
      ));
    } else {
      _error(400);
    }
    $get_users = new PrefetchedResult(rows_by_ids($get_users->fetch_all(MYSQLI_ASSOC), 'user_id', $page_ids));
    /* page conversation (customers see the page instead of its admins) */
    $page = false;
    $page_admins_ids = [];
    if ($message_id != null) {
      $get_message = $db->query(sprintf("SELECT conversation_id FROM conversations_messages WHERE message_id = %s", secure($message_id, 'int')));
      $page_id = ($get_message->num_rows > 0) ? $this->get_conversation_page_id($get_message->fetch_assoc()['conversation_id']) : false;
      if ($page_id && !$this->check_page_adminship($this->_data['user_id'], $page_id)) {
        $page = $this->get_chat_page($page_id);
        $page_admins_ids = $this->get_page_admins_ids($page_id);
      }
    }
    if ($get_users->num_rows > 0) {
      while ($_user = $get_users->fetch_assoc()) {
        if ($page && in_array($_user['user_id'], $page_admins_ids)) {
          $users[] = [
            'user_id' => 0,
            'user_name' => 'pages/' . $page['page_name'],
            'user_firstname' => $page['page_title'],
            'user_lastname' => '',
            'user_picture' => $page['page_picture'],
            'user_fullname' => html_entity_decode($page['page_title'], ENT_QUOTES),
            'user_verified' => $page['page_verified'],
            'user_subscribed' => '0',
            'connection' => 'me',
            'mutual_friends_count' => 0,
            'reaction' => $_user['reaction'],
            'reaction_image_url' => $system['reactions'][$_user['reaction']]['image_url'],
          ];
          continue;
        }
        /* user */
        $_user['user_picture'] = get_picture($_user['user_picture'], $_user['user_gender']);
        $_user['user_fullname'] = html_entity_decode((($system['show_usernames_enabled']) ? $_user['user_name'] : $_user['user_firstname'] . " " . $_user['user_lastname']), ENT_QUOTES);
        /* get the connection between the viewer & the target */
        $_user['connection'] = $this->connection($_user['user_id']);
        /* get mutual friends count */
        $_user['mutual_friends_count'] = $this->get_mutual_friends_count($_user['user_id']);
        /* reaction */
        $_user['reaction_image_url'] = $system['reactions'][$_user['reaction']]['image_url'];
        $users[] = $_user;
      }
    }
    $has_more = (count($users) == $system['max_results']) ? true : false;
    $this->_cursor = $next_cursor;
    return ['data' => $users, 'has_more' => $has_more, 'cursor' => $next_cursor];
  }


  /**
   * who_reacts_counts
   * 
   * @param array $args
   * @return array
   */
  public function who_reacts_counts($args = [])
  {
    global $db;
    /* get the reactions table */
    if (isset($args['post_id'])) {
      $table = "posts_reactions";
      $column = "post_id";
      $node_id = $args['post_id'];
    } elseif (isset($args['photo_id'])) {
      $table = "posts_photos_reactions";
      $column = "photo_id";
      $node_id = $args['photo_id'];
    } elseif (isset($args['comment_id'])) {
      $table = "posts_comments_reactions";
      $column = "comment_id";
      $node_id = $args['comment_id'];
    } elseif (isset($args['message_id'])) {
      $table = "conversations_messages_reactions";
      $column = "message_id";
      $node_id = $args['message_id'];
    } else {
      _error(400);
    }
    /* get reactions counts */
    $counts = ['all' => 0, 'like' => 0, 'love' => 0, 'haha' => 0, 'yay' => 0, 'wow' => 0, 'sad' => 0, 'angry' => 0];
    $get_counts = $db->query(sprintf("SELECT reaction, COUNT(*) AS count FROM %s WHERE %s = %s GROUP BY reaction", $table, $column, secure($node_id, 'int')));
    while ($reaction = $get_counts->fetch_assoc()) {
      $counts[$reaction['reaction']] = (int) $reaction['count'];
      $counts['all'] += (int) $reaction['count'];
    }
    return $counts;
  }


  /**
   * who_shares
   * 
   * @param integer $post_id
   * @param integer $offset
   * @return array
   */
  public function who_shares($post_id, $offset = 0, $cursor = null)
  {
    global $db, $system;
    $posts = [];
    $offset *= $system['max_results'];
    /* shares of friends & followings first, then everyone else, newest first (a page of posts ids) */
    [$posts_ids, $next_cursor] = $this->get_friends_first_page('posts', 'user_id', sprintf("posts.post_type = 'shared' AND posts.origin_id = %s", secure($post_id, 'int')), $offset, $system['max_results'], $cursor, 'post_id');
    foreach ($posts_ids as $shared_post_id) {
      $post = $this->get_post($shared_post_id);
      if ($post) {
        $posts[] = $post;
      }
    }
    $this->_cursor = $next_cursor;
    return $posts;
  }


  /**
   * who_donates
   * 
   * @param integer $post_id
   * @param integer $offset
   * @return array
   */
  public function who_donates($post_id, $offset = 0, $cursor = null)
  {
    global $db, $system;
    $donors = [];
    $offset *= $system['max_results'];
    /* newest first; pages after the first continue from a cursor (the last donation) instead of an offset */
    $this->_cursor = null;
    $cursor = cursor_decode($cursor, ['int']);
    $cursor_statement = ($cursor) ? " AND " . cursor_where(['posts_funding_donors.donation_id'], $cursor) : "";
    $limit_statement = ($cursor) ? sprintf("LIMIT %s", secure($system['max_results'], 'int', false)) : sprintf("LIMIT %s, %s", secure($offset, 'int', false), secure($system['max_results'], 'int', false));
    $get_donors = $db->query(sprintf(
      "SELECT 
          posts_funding_donors.donation_id AS `cursor`, 
          users.user_id, 
          users.user_name, 
          users.user_firstname, 
          users.user_lastname, 
          users.user_picture, 
          users.user_gender, 
          posts_funding_donors.donation_amount, 
          posts_funding_donors.donation_time 
        FROM posts_funding_donors 
        INNER JOIN users ON posts_funding_donors.user_id = users.user_id 
        WHERE posts_funding_donors.post_id = %s" . $cursor_statement . " 
        ORDER BY posts_funding_donors.donation_id DESC 
        " . $limit_statement,
      secure($post_id, 'int')
    ));
    [$get_donors, $next_cursor] = cursor_result($get_donors);
    while ($donor = $get_donors->fetch_assoc()) {
      $donor['user_picture'] = get_picture($donor['user_picture'], $donor['user_gender']);
      /* get the connection between the viewer & the target */
      $donor['connection'] = $this->connection($donor['user_id']);
      $donors[] = $donor;
    }
    $this->_cursor = $next_cursor;
    return $donors;
  }


  /**
   * get_poll
   * 
   * @param integer $post_id
   * @return array|false
   */
  public function get_poll($post_id)
  {
    global $db, $system;
    /* get poll */
    $get_poll = $db->query(sprintf("SELECT * FROM posts_polls WHERE post_id = %s", secure($post_id, 'int')));
    if ($get_poll->num_rows == 0) {
      return false;
    }
    $poll = $get_poll->fetch_assoc();
    $poll['options'] = [];
    $poll['leading_votes'] = 0;
    /* get options */
    $get_options = $db->query(sprintf("SELECT posts_polls_options.option_id, posts_polls_options.text, COUNT(posts_polls_options_users.id) AS votes, MAX(CASE WHEN posts_polls_options_users.user_id = %s THEN 1 ELSE 0 END) AS checked FROM posts_polls_options LEFT JOIN posts_polls_options_users ON posts_polls_options.option_id = posts_polls_options_users.option_id WHERE posts_polls_options.poll_id = %s GROUP BY posts_polls_options.option_id, posts_polls_options.text ORDER BY posts_polls_options.option_id", secure($this->_logged_in ? $this->_data['user_id'] : 0, 'int'), secure($poll['poll_id'], 'int')));
    if ($get_options->num_rows == 0) {
      return false;
    }
    while ($option = $get_options->fetch_assoc()) {
      $option['checked'] = (bool) $option['checked'];
      $option['percentage'] = $poll['votes'] > 0 ? ($option['votes'] / $poll['votes']) * 100 : 0;
      if (!$option['checked']) {
        $poll['leading_votes'] = max($poll['leading_votes'], $option['votes']);
      }
      /* get voter previews */
      $option['voters'] = [];
      if ($option['votes'] > 0) {
        $get_voters = $db->query(sprintf("SELECT users.user_name, users.user_firstname, users.user_lastname, users.user_picture, users.user_gender FROM posts_polls_options_users INNER JOIN users ON posts_polls_options_users.user_id = users.user_id WHERE posts_polls_options_users.option_id = %s ORDER BY posts_polls_options_users.id DESC LIMIT 3", secure($option['option_id'], 'int')));
        while ($voter = $get_voters->fetch_assoc()) {
          $option['voters'][] = [
            'name' => $system['show_usernames_enabled'] ? $voter['user_name'] : $voter['user_firstname'] . ' ' . $voter['user_lastname'],
            'picture' => get_picture($voter['user_picture'], $voter['user_gender'])
          ];
        }
      }
      $poll['options'][] = $option;
    }
    return $poll;
  }


  /**
   * who_votes
   * 
   * @param integer $post_id
   * @param integer $offset
   * @return array
   */
  public function who_votes($option_id, $offset = 0, $cursor = null)
  {
    global $db, $system;
    $voters = [];
    $offset *= $system['max_results'];
    /* friends & followings first, then everyone else (a page of users ids, read through the index) */
    [$page_ids, $next_cursor] = $this->get_friends_first_page('posts_polls_options_users', 'user_id', sprintf("posts_polls_options_users.option_id = %s", secure($option_id, 'int')), $offset, $system['max_results'], $cursor);
    $get_voters = $db->query(sprintf(
      "SELECT 
          users.user_id, 
          users.user_name, 
          users.user_firstname, 
          users.user_lastname, 
          users.user_picture, 
          users.user_gender 
        FROM posts_polls_options_users 
        INNER JOIN users ON posts_polls_options_users.user_id = users.user_id 
        WHERE option_id = %s 
          AND users.user_id IN (" . $this->spread_ids($page_ids) . ")",
      secure($option_id, 'int')
    ));
    $get_voters = new PrefetchedResult(rows_by_ids($get_voters->fetch_all(MYSQLI_ASSOC), 'user_id', $page_ids));
    while ($voter = $get_voters->fetch_assoc()) {
      $voter['user_picture'] = get_picture($voter['user_picture'], $voter['user_gender']);
      /* get the connection between the viewer & the target */
      $voter['connection'] = $this->connection($voter['user_id']);
      $voters[] = $voter;
    }
    $this->_cursor = $next_cursor;
    return $voters;
  }


  /**
   * prefetch_comments
   * 
   * @param string $node_type
   * @param array $nodes_ids
   * @param string $order
   * @return array
   */
  private function prefetch_comments($node_type, $nodes_ids, $order)
  {
    global $db, $system;
    $comments = [];
    $get_comments = $db->query(sprintf("SELECT * FROM (SELECT posts_comments.*, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, users.user_verified, users.user_subscribed, packages.name as package_name, pages.*, ROW_NUMBER() OVER (PARTITION BY posts_comments.node_id ORDER BY posts_comments.comment_id DESC) AS prefetch_rank FROM posts_comments LEFT JOIN users ON posts_comments.user_id = users.user_id AND posts_comments.user_type = 'user' LEFT JOIN packages ON users.user_subscribed = '1' AND users.user_package = packages.package_id LEFT JOIN pages ON posts_comments.user_id = pages.page_id AND posts_comments.user_type = 'page' WHERE NOT (users.user_name <=> NULL AND pages.page_name <=> NULL) AND posts_comments.node_type = %s AND posts_comments.node_id IN (%s)) comments WHERE comments.prefetch_rank <= %s ORDER BY %s", secure($node_type), implode(',', array_map('intval', $nodes_ids)), secure($system['min_results'], 'int', false), $order));
    while ($comment = $get_comments->fetch_assoc()) {
      unset($comment['prefetch_rank']);
      $comments[$comment['node_id']][] = $comment;
    }
    return $comments;
  }


  /**
   * post_details_queries
   * 
   * @return array
   */
  private function post_details_queries()
  {
    $photos_types = ['photos', 'album', 'profile_picture', 'profile_cover', 'page_picture', 'page_cover', 'group_picture', 'group_cover', 'event_cover', 'combo'];
    return [
      'link' => [['link'], "posts_links.*", "posts_links", "posts_links.post_id", ""],
      'media' => [['media'], "posts_media.*", "posts_media", "posts_media.post_id", ""],
      'live' => [['live'], "posts_live.*, posts_live_categories.category_name, (SELECT COUNT(*) FROM posts_live_users WHERE posts_live_users.post_id = posts_live.post_id) AS live_viewers", "posts_live LEFT JOIN posts_live_categories ON posts_live.category_id = posts_live_categories.category_id", "posts_live.post_id", ""],
      'photos' => [$photos_types, "posts_photos.*", "posts_photos", "posts_photos.post_id", "ORDER BY sort_order ASC, photo_id ASC"],
      'photos_latest' => [['product', 'offer'], "posts_photos.*", "posts_photos", "posts_photos.post_id", "ORDER BY photo_id DESC"],
      'article' => [['article'], "posts_articles.*, blogs_categories.category_name", "posts_articles LEFT JOIN blogs_categories ON posts_articles.category_id = blogs_categories.category_id", "posts_articles.post_id", ""],
      'article_references' => [['article'], "title, link", "posts_articles_references", "posts_articles_references.post_id", ""],
      'rich_text' => [['rich_text'], "posts_rich_text.*", "posts_rich_text", "posts_rich_text.post_id", ""],
      'product' => [['product'], "posts_products.*, market_categories.category_name", "posts_products INNER JOIN market_categories ON posts_products.category_id = market_categories.category_id", "posts_products.post_id", ""],
      'funding' => [['funding'], "posts_funding.*, funding_categories.category_name", "posts_funding LEFT JOIN funding_categories ON posts_funding.category_id = funding_categories.category_id", "posts_funding.post_id", ""],
      'offer' => [['offer'], "posts_offers.*", "posts_offers", "posts_offers.post_id", ""],
      'job' => [['job'], "posts_jobs.*", "posts_jobs", "posts_jobs.post_id", ""],
      'course' => [['course'], "posts_courses.*", "posts_courses", "posts_courses.post_id", ""],
      'reel' => [['reel'], "posts_reels.*", "posts_reels", "posts_reels.post_id", ""],
      'video' => [['video', 'combo'], "posts_videos.*, posts_videos_categories.category_name", "posts_videos LEFT JOIN posts_videos_categories ON posts_videos.category_id = posts_videos_categories.category_id", "posts_videos.post_id", ""],
      'audio' => [['audio', 'combo'], "posts_audios.*", "posts_audios", "posts_audios.post_id", ""],
      'file' => [['file', 'combo'], "posts_files.*", "posts_files", "posts_files.post_id", ""],
      'merit' => [['merit'], "posts_merits.*, merits_categories.category_name, merits_categories.category_image", "posts_merits LEFT JOIN merits_categories ON posts_merits.category_id = merits_categories.category_id", "posts_merits.post_id", ""],
    ];
  }


  /**
   * post_details
   * 
   * @param string $key
   * @param integer $post_id
   * @return PrefetchedResult|null
   */
  private function post_details($key, $post_id)
  {
    if (!isset($this->_posts_prefetch['details_covered'][$key][(int) $post_id])) {
      return null;
    }
    return new PrefetchedResult($this->_posts_prefetch['details'][$key][(int) $post_id] ?? []);
  }


  /**
   * post_row_query
   * 
   * @param string $condition
   * @param boolean $batch
   * @return string
   */
  private function post_row_query($condition, $batch = false)
  {
    return "SELECT 
                posts.*, 
                posts.group_id AS post_group_id,
                posts.event_id AS post_event_id,
                users.user_name,
                users.user_firstname, 
                users.user_lastname,
                users.user_gender,
                users.user_picture,
                users.user_picture_id,
                users.user_cover,
                users.user_cover_id,
                users.user_verified,
                users.user_subscribed,
                users.user_pinned_post,
                users.user_banned,
                users.user_monetization_enabled,
                users.user_monetization_discount_enabled,
                users.user_monetization_discount_percent,
                users.user_monetization_min_price,
                users.user_monetization_plans,
                users.user_chat_enabled AS post_author_chat_enabled,
                users.user_last_seen AS post_author_last_seen,
                packages.name as package_name,
                pages.*,
                `groups`.*,
                `events`.*" . (($batch) ? ", posts.post_id AS prefetch_post_id" : "") . "
            FROM posts
            LEFT JOIN users ON posts.user_id = users.user_id 
                AND posts.user_type = 'user'
            LEFT JOIN packages ON users.user_subscribed = '1'
                AND users.user_package = packages.package_id
            LEFT JOIN pages ON posts.user_id = pages.page_id
                AND posts.user_type = 'page'
            LEFT JOIN `groups` ON posts.in_group = '1'
                AND posts.group_id = `groups`.group_id
            LEFT JOIN `events` ON posts.in_event = '1'
                AND posts.event_id = `events`.event_id
            WHERE NOT (users.user_name <=> NULL AND pages.page_name <=> NULL)
                AND " . $condition;
  }


  /**
   * _check_post
   * 
   * @param integer $id
   * @param boolean $pass_privacy_check
   * @param boolean $full_details
   * @return array|false
   */
  private function _check_post($id, $pass_privacy_check = false, $full_details = true)
  {
    global $db, $system;

    /* get post (from the page's batch when get_posts() loaded it) */
    if (isset($this->_posts_prefetch['rows_covered'][(int) $id])) {
      $post = $this->_posts_prefetch['rows'][(int) $id] ?? null;
      if (!$post) {
        return false;
      }
    } else {
      $get_post = $db->query($this->post_row_query("posts.post_id = " . secure($id, 'int')));
      if ($get_post->num_rows == 0) {
        return false;
      }
      $post = $get_post->fetch_assoc();
    }
    /* check if the page has been deleted */
    if ($post['user_type'] == "page" && !$post['page_admin']) {
      return false;
    }
    /* check if there is any blocking between the viewer & the post author */
    if ($post['user_type'] == "user" && $this->blocked($post['user_id'])) {
      return false;
    }
    /* check if the user is banned */
    if ($post['user_type'] == "user" && $post['user_banned']) {
      return false;
    }
    /* check if the post is processing */
    if ($post['processing'] == '1') {
      return false;
    }

    /* get the author id */
    $post['author_id'] = ($post['user_type'] == "page") ? $post['page_admin'] : $post['user_id'];

    /* check if the post is pending (bypass the admins & moderators & post author) */
    $post['is_pending'] = $system['posts_approval_enabled'] && ($post['pre_approved'] == '0' && $post['has_approved'] == 0);
    if ($post['is_pending']) {
      if (!$this->_logged_in) {
        return false;
      }
      if ($this->_data['user_group'] >= 3 && $post['author_id'] != $this->_data['user_id']) {
        return false;
      }
    }

    /* get the author */
    $post['is_page_admin'] = $this->check_page_adminship($this->_data['user_id'], $post['page_id']);
    $post['is_group_admin'] = $this->check_group_adminship($this->_data['user_id'], $post['group_id']);
    /* the event row is already joined */
    $post['is_event_admin'] = ($this->_logged_in && $post['event_id'] && $post['event_admin'] == $this->_data['user_id']);
    $post['post_author_online'] = false;
    /* check the post author type */
    if ($post['user_type'] == "user") {
      /* user */
      $post['post_author_picture'] = get_picture($post['user_picture'], $post['user_gender']);
      $post['post_author_url'] = $system['system_url'] . '/' . $post['user_name'];
      $post['post_author_name'] = ($system['show_usernames_enabled']) ? $post['user_name'] : $post['user_firstname'] . " " . $post['user_lastname'];
      $post['post_author_verified'] = $post['user_verified'];
      $post['pinned'] = ((!$post['in_group'] && !$post['in_event'] && $post['post_id'] == $post['user_pinned_post']) || ($post['in_group'] && $post['post_id'] == $post['group_pinned_post']) || ($post['in_event'] && $post['post_id'] == $post['event_pinned_post'])) ? true : false;
      if ($system['posts_online_status']) {
        /* check if the post author is online & enable the chat */
        /* same as SUBTIME(NOW(), SEC_TO_TIME(offline_time)), which caps at 838:59:59 */
        if ($post['post_author_chat_enabled'] == '1' && $post['post_author_last_seen'] && strtotime($post['post_author_last_seen']) >= time() - min((int) $system['offline_time'], 3020399)) {
          $post['post_author_online'] = true;
        }
      }
    } else {
      /* page */
      $post['post_author_picture'] = get_picture($post['page_picture'], "page");
      $post['post_author_url'] = $system['system_url'] . '/pages/' . $post['page_name'];
      $post['post_author_name'] = $post['page_title'];
      $post['post_author_verified'] = $post['page_verified'];
      $post['pinned'] = ($post['post_id'] == $post['page_pinned_post']) ? true : false;
    }

    unset($post['post_author_chat_enabled'], $post['post_author_last_seen']);

    /* check if post is still scheduled */
    $post['still_scheduled'] = ($system['posts_schedule_enabled'] && $post['is_schedule'] && strtotime($post['time']) > time()) ? true : false;

    /* get post rating count */
    if ($system['posts_reviews_enabled']) {
      $post['reviews_count'] = $this->_posts_prefetch['reviews'][$post['post_id']] ?? $this->get_reviews_count($post['post_id'], 'post');
      $post['reviews_count_formatted'] = abbreviate_count($post['reviews_count']);
    }

    /* check if viewer can manage post [Edit|Pin|Delete] */
    $post['manage_post'] = false;
    if ($this->_logged_in) {
      /* viewer is (admin|moderator) */
      if ($this->_data['user_group'] < 3) {
        $post['manage_post'] = true;
      }
      /* viewer is the author of post */
      if ($this->_data['user_id'] == $post['author_id']) {
        $post['manage_post'] = true;
      }
      /* viewer is the admin of the page of the post */
      if ($post['user_type'] == "page" && $post['is_page_admin']) {
        $post['manage_post'] = true;
      }
      /* viewer is the admin of the group of the post */
      if ($post['in_group'] && $post['is_group_admin']) {
        $post['manage_post'] = true;
      }
      /* viewer is the admin of the event of the post */
      if ($post['in_event'] && $post['is_event_admin']) {
        $post['manage_post'] = true;
      }
    }
    $post['can_edit_post'] = $post['manage_post'] && $this->is_post_edit_window_open($post);

    /* check if post can be shared with subscribers only */
    $post['can_be_for_subscriptions'] = false;
    if ($this->_logged_in) {
      if ($system['monetization_enabled'] && !$post['in_event'] && !$post['is_collaborative']) {
        if ($post['in_group']) {
          $node_monetization_enabled = $post['group_monetization_enabled'];
          $node_author = $post['group_admin'];
          $node_monetization_plans = $post['group_monetization_plans'];
        } elseif ($post['user_type'] == "page") {
          $node_monetization_enabled = $post['page_monetization_enabled'];
          $node_author = $post['page_admin'];
          $node_monetization_plans = $post['page_monetization_plans'];
        } elseif ($post['user_type'] == "user") {
          $node_monetization_enabled = $post['user_monetization_enabled'];
          $node_author = $post['author_id'];
          $node_monetization_plans = $post['user_monetization_plans'];
        }
        if ($node_monetization_enabled && $this->check_user_permission($node_author, 'monetization_permission') && $node_monetization_plans > 0) {
          $post['can_be_for_subscriptions'] = true;
        }
      }
    }

    /* post monetization */
    $post['needs_payment'] = false;
    $post['needs_subscription'] = false;
    $post['preview_lock'] = false;
    if ($system['monetization_enabled'] && ($post['is_paid'] || $post['for_subscriptions'])) {
      /* get node_monetization_enabled */
      if ($post['in_group']) {
        $node_monetization_enabled = ($post['is_paid']) ? $post['user_monetization_enabled'] : $post['group_monetization_enabled'];
        $node_author = ($post['is_paid']) ? $post['author_id'] : $post['group_admin'];
        $node_monetization_plans = $post['group_monetization_plans'];
        $node_subscription_type = 'group';
        $node_subscription_id = $post['group_id'];
        $node_subscription_price = $post['group_monetization_min_price'];
        $node_monetization_discount_enabled = $post['group_monetization_discount_enabled'];
        $node_monetization_discount_percent = $post['group_monetization_discount_percent'];
      } elseif ($post['user_type'] == "page") {
        $node_monetization_enabled = $post['page_monetization_enabled'];
        $node_author = $post['page_admin'];
        $node_monetization_plans = $post['page_monetization_plans'];
        $node_subscription_type = 'page';
        $node_subscription_id = $post['page_id'];
        $node_subscription_price = $post['page_monetization_min_price'];
        $node_monetization_discount_enabled = $post['page_monetization_discount_enabled'];
        $node_monetization_discount_percent = $post['page_monetization_discount_percent'];
      } elseif ($post['user_type'] == "user") {
        $node_monetization_enabled = $post['user_monetization_enabled'];
        $node_author = $post['author_id'];
        $node_monetization_plans = $post['user_monetization_plans'];
        $node_subscription_type = 'profile';
        $node_subscription_id = $post['user_id'];
        $node_subscription_price = $post['user_monetization_min_price'];
        $node_monetization_discount_enabled = $post['user_monetization_discount_enabled'];
        $node_monetization_discount_percent = $post['user_monetization_discount_percent'];
      }
      /* get can_monetize_content */
      $post['can_monetize_content'] = $node_monetization_enabled && $this->check_user_permission($node_author, 'monetization_permission');
      if ($post['can_monetize_content']) {
        /* check if the viewer logged in */
        if ($this->_logged_in) {
          /* check if the viewer is not (admin || moderator) && not the author of the post */
          if ($this->_data['user_group'] == 3 && $post['author_id'] != $this->_data['user_id']) {
            if ($post['is_paid']) {
              /* check if the viewer subscribed to this node || paid for this post */
              if (!$this->is_user_paid_for_post($post['post_id'])) {
                $post['needs_payment'] = true;
                $post['post_price_discounted'] = ($node_monetization_discount_enabled) ? $post['post_price'] * (1 - $node_monetization_discount_percent / 100) : 0;
              }
            } else {
              if ($node_monetization_plans > 0) {
                /* check if the viewer subscribed to this node */
                if (!$this->is_subscribed($node_subscription_id, $node_subscription_type)) {
                  $post['needs_subscription'] = true;
                  $post['needs_subscription_type'] = $node_subscription_type;
                  $post['needs_subscription_id'] = $node_subscription_id;
                  $post['needs_subscription_price'] = $node_subscription_price;
                  $post['needs_subscription_discount_enabled'] = $node_monetization_discount_enabled;
                  $post['needs_subscription_discount_percent'] = $node_monetization_discount_percent;
                }
              }
            }
          } elseif ($post['author_id'] == $this->_data['user_id']) {
            /* preview the locked view for the author */
            if ($post['is_paid']) {
              $post['preview_lock'] = 'payment';
              $post['post_price_discounted'] = ($node_monetization_discount_enabled) ? $post['post_price'] * (1 - $node_monetization_discount_percent / 100) : 0;
            } elseif ($node_monetization_plans > 0) {
              $post['preview_lock'] = 'subscription';
              $post['preview_subscription_type'] = $node_subscription_type;
              $post['preview_subscription_id'] = $node_subscription_id;
              $post['preview_subscription_price'] = $node_subscription_price;
              $post['preview_subscription_discount_enabled'] = $node_monetization_discount_enabled;
              $post['preview_subscription_discount_percent'] = $node_monetization_discount_percent;
            }
          }
        } else {
          if ($post['is_paid']) {
            $post['needs_payment'] = true;
            $post['post_price_discounted'] = ($node_monetization_discount_enabled) ? $post['post_price'] * (1 - $node_monetization_discount_percent / 100) : 0;
          } else {
            if ($node_monetization_plans > 0) {
              $post['needs_subscription'] = true;
              $post['needs_subscription_type'] = $node_subscription_type;
              $post['needs_subscription_id'] = $node_subscription_id;
              $post['needs_subscription_price'] = $node_subscription_price;
              $post['needs_subscription_discount_enabled'] = $node_monetization_discount_enabled;
              $post['needs_subscription_discount_percent'] = $node_monetization_discount_percent;
            }
          }
        }
      }
    }

    /* preserve purchased access */
    if ($this->_logged_in && ($post['needs_payment'] || $post['needs_subscription']) && $this->is_user_paid_for_post($post['post_id'])) {
      $post['needs_payment'] = false;
      $post['needs_subscription'] = false;
    }

    /* post adult content */
    $post['needs_age_verification'] = false;
    if ($system['adult_mode'] && $post['for_adult']) {
      /* check if the viewer logged in */
      if ($this->_logged_in) {
        /* check if the viewer is not (admin || moderator) && not the author of the post */
        if ($this->_data['user_group'] == 3 && $post['author_id'] != $this->_data['user_id']) {
          /* user not adult */
          if (!$this->_data['user_adult']) {
            $post['needs_age_verification'] = true;
          } else {
            /* user adult but not verified */
            if ($system['verification_for_adult_content'] && !$this->_data['user_verified']) {
              $post['needs_age_verification'] = true;
            }
          }
        }
      } else {
        $post['needs_age_verification'] = true;
      }
    }

    /* set if can get full post details */
    $post['can_get_details'] = true;
    if ($post['needs_subscription'] || $post['needs_age_verification']) {
      $post['can_get_details'] = false;
    } elseif ($post['needs_payment']) {
      if ($post['is_paid_locked']) {
        switch ($post['post_type']) {
          case 'file':
            $post['can_get_details'] = true;
            break;
          case 'combo':
            $fileCount = $db->query(sprintf("SELECT COUNT(*) AS count FROM posts_files WHERE post_id = %s", secure($post['post_id'], 'int')))->fetch_assoc()['count'];
            $post['can_get_details'] = ($fileCount > 0);
            break;
          default:
            $post['can_get_details'] = false;
        }
      } else {
        $post['can_get_details'] = false;
      }
    }

    /* check if post is collaborative */
    if ($post['is_collaborative']) {
      /* get collaborative users */
      $post['collaborative_users'] = $this->get_collaborative_users($post['post_id']);
      /* check if the viewer is a collaborative user */
      $post['i_collaborative'] = false;
      if ($this->_logged_in && $post['author_id'] != $this->_data['user_id']) {
        $post['i_collaborative'] = $this->is_collaborative_user($this->_data['user_id'], $post['post_id']);
        /* if the viewer is a collaborative user, then they can get the full details of the post anyway */
        if ($post['i_collaborative']) {
          $post['can_get_details'] = true;
        }
      }
    }


    /* check privacy */
    /* overwrite the pass_privacy_check */
    if ($pass_privacy_check && $system['newsfeed_source'] == "all_posts" && ($post['in_group'] || $post['in_event'])) {
      /* pass_privacy_check set to false to exclude any post from closed/secret groups and events that users not member of */
      $pass_privacy_check = false;
    }
    /* if post in group & (the group is public || the viewer approved member of this group) => pass privacy check */
    if ($post['in_group'] && ($post['group_privacy'] == 'public' || $this->check_group_membership($this->_data['user_id'], $post['group_id']) == 'approved')) {
      $pass_privacy_check = true;
    }
    /* if post in event & (the event is public || the viewer member of this event) => pass privacy check */
    if ($post['in_event'] && ($post['event_privacy'] == 'public' || $this->check_event_membership($this->_data['user_id'], $post['event_id']))) {
      $pass_privacy_check = true;
    }

    /* get post meta details */
    if ($post['can_get_details']) {
      /* get reactions array */
      $post['reactions']['like'] = $post['reaction_like_count'];
      $post['reactions']['love'] = $post['reaction_love_count'];
      $post['reactions']['haha'] = $post['reaction_haha_count'];
      $post['reactions']['yay'] = $post['reaction_yay_count'];
      $post['reactions']['wow'] = $post['reaction_wow_count'];
      $post['reactions']['sad'] = $post['reaction_sad_count'];
      $post['reactions']['angry'] = $post['reaction_angry_count'];
      arsort($post['reactions']);

      /* get total reactions */
      $post['reactions_total_count'] = $post['reaction_like_count'] + $post['reaction_love_count'] + $post['reaction_haha_count'] + $post['reaction_yay_count'] + $post['reaction_wow_count'] + $post['reaction_sad_count'] + $post['reaction_angry_count'];

      /* format total (reactions, comments, shares, views) */
      $post['reactions_total_count_formatted'] = abbreviate_count($post['reactions_total_count']);
      $post['comments_formatted'] = abbreviate_count($post['comments']);
      $post['shares_formatted'] = abbreviate_count($post['shares']);
      $post['views_formatted'] = abbreviate_count($post['views']);

      /* full details */
      if ($full_details) {
        /* check if wall post */
        if ($post['in_wall']) {
          $get_wall_user = $db->query(sprintf("SELECT user_firstname, user_lastname, user_name FROM users WHERE user_id = %s", secure($post['wall_id'], 'int')));
          if ($get_wall_user->num_rows == 0) {
            return false;
          }
          $wall_user = $get_wall_user->fetch_assoc();
          $post['wall_username'] = $wall_user['user_name'];
          $post['wall_fullname'] = ($system['show_usernames_enabled']) ? $wall_user['user_name'] : $wall_user['user_firstname'] . " " . $wall_user['user_lastname'];
        }

        /* check if viewer [reacted|saved] this post */
        $post['i_save'] = false;
        $post['i_react'] = false;
        if ($this->_logged_in && isset($this->_posts_prefetch['posts'][$post['post_id']])) {
          /* loaded with the rest of the page by prefetch_posts() */
          $post['i_save'] = isset($this->_posts_prefetch['saved'][$post['post_id']]);
          if ($post['reactions_total_count'] > 0 && isset($this->_posts_prefetch['reactions'][$post['post_id']])) {
            $post['i_react'] = true;
            $post['i_reaction'] = $this->_posts_prefetch['reactions'][$post['post_id']];
          }
        } elseif ($this->_logged_in) {
          /* save */
          $check_save = $db->query(sprintf("SELECT COUNT(*) as count FROM posts_saved WHERE user_id = %s AND post_id = %s", secure($this->_data['user_id'], 'int'), secure($post['post_id'], 'int')));
          if ($check_save->fetch_assoc()['count'] > 0) {
            $post['i_save'] = true;
          }
          /* reaction */
          if ($post['reactions_total_count'] > 0) {
            $get_reaction = $db->query(sprintf("SELECT reaction FROM posts_reactions WHERE user_id = %s AND post_id = %s", secure($this->_data['user_id'], 'int'), secure($post['post_id'], 'int')));
            if ($get_reaction->num_rows > 0) {
              $post['i_react'] = true;
              $post['i_reaction'] = $get_reaction->fetch_assoc()['reaction'];
            }
          }
        }
      }
    }

    /* return post */
    if ($pass_privacy_check || $this->check_privacy($post['privacy'], $post['author_id'])) {
      return $post;
    }
    return false;
  }


  /**
   * check_privacy
   * 
   * @param string $privacy
   * @param integer $author_id
   * @return boolean
   */
  public function check_privacy($privacy, $author_id)
  {
    if ($privacy == 'public') {
      return true;
    }
    if ($this->_logged_in) {
      /* check if the viewer is the system admin */
      if ($this->_data['user_group'] < 3) {
        return true;
      }
      /* check if the viewer is the target */
      if ($author_id == $this->_data['user_id']) {
        return true;
      }
      /* check if the viewer and the target are friends */
      if ($privacy == 'friends' && $this->friendship_approved($author_id)) {
        return true;
      }
      if (defined('PRIVACY_ERRORS')) {
        throw new PrivacyException(__("You don't have permission to view this post"));
      }
    } else {
      if (defined('PRIVACY_ERRORS')) {
        user_login();
      }
    }
    return false;
  }


  /**
   * clear_posts_cache
   * 
   * @return void
   */
  public function clear_posts_cache()
  {
    global $system, $db;
    $db->query(sprintf("DELETE FROM posts_cache WHERE user_id = %s", secure($this->_data['user_id'], 'int')));
    if ($db->affected_rows > 0) {
      return true;
    }
    return false;
  }



  /* ------------------------------- */
  /* Posts Actions */
  /* ------------------------------- */

  /**
   * share
   * 
   * @param integer $post_id
   * @param array $args
   * @return void
   */
  public function share($post_id, $args)
  {
    global $db, $date;
    /* check if the viewer can share the post */
    $post = $this->_check_post($post_id, true);
    if (!$post) {
      _error(403);
    }
    /* check if post is still scheduled */
    if ($post['still_scheduled']) {
      throw new Exception(__("This post is still scheduled"));
    }
    /* check if the post is not public */
    if ($post['privacy'] != 'public' && !($post['in_group'] && $post['group_privacy'] == "public") && !($post['in_event'] && $post['event_privacy'] == "public")) {
      _error(403);
    }
    /* check blocking */
    if ($post['user_type'] == "user" && $this->blocked($post['author_id'])) {
      _error(403);
    }
    // share post
    /* get the origin post */
    if ($post['post_type'] == "shared") {
      $origin = $this->_check_post($post['origin_id'], true);
      if (!$origin) {
        _error(403);
      }
      if ($origin['privacy'] != 'public' && !($origin['in_group'] && $origin['group_privacy'] == "public") && !($origin['in_event'] && $origin['event_privacy'] == "public")) {
        _error(403);
      }
      $post_id = $origin['post_id'];
      $author_id = $origin['author_id'];
    } else {
      $post_id = $post['post_id'];
      $author_id = $post['author_id'];
    }
    /* share to */
    switch ($args['share_to']) {
      case 'timeline':
        /* insert the new shared post */
        $db->query(sprintf("INSERT INTO posts (user_id, user_type, post_type, origin_id, time, privacy, text) VALUES (%s, 'user', 'shared', %s, %s, 'public', %s)", secure($this->_data['user_id'], 'int'), secure($post_id, 'int'), secure($date), secure($args['message'])));
        $this->refresh_post_search($db->insert_id);
        break;

      case 'page':
        /* check if the page is valid */
        $check_page = $db->query(sprintf("SELECT COUNT(*) as count FROM pages WHERE page_id = %s", secure($args['page'], 'int')));
        if ($check_page->fetch_assoc()['count'] == 0) {
          _error(400);
        }
        /* check if the viewer is page admin */
        if (!$this->check_page_adminship($this->_data['user_id'], $args['page'])) {
          _error(400);
        }
        /* insert the new shared post */
        $db->query(sprintf("INSERT INTO posts (user_id, user_type, post_type, origin_id, time, privacy, text) VALUES (%s, 'page', 'shared', %s, %s, 'public', %s)", secure($args['page'], 'int'), secure($post_id, 'int'), secure($date), secure($args['message'])));
        $this->refresh_post_search($db->insert_id);
        break;

      case 'group':
        /* check if the group is valid */
        $get_group = $db->query(sprintf("SELECT * FROM `groups` WHERE group_id = %s", secure($args['group'], 'int')));
        if ($get_group->num_rows == 0) {
          _error(400);
        }
        $group = $get_group->fetch_assoc();
        /* check if the viewer is group member */
        if ($this->check_group_membership($this->_data['user_id'], $args['group']) != "approved") {
          _error(400);
        }
        /* check if user is a group admin */
        $group['i_admin'] = $this->check_group_adminship($this->_data['user_id'], $group['group_id']);
        /* check if group publishing enabled */
        if (!$group['group_publish_enabled'] && !$group['i_admin']) {
          throw new Exception(__("Publishing to this group has been disabled by group admins"));
        }
        /* insert the new shared post */
        $group_approved = ($group['group_publish_approval_enabled'] && !$group['i_admin']) ? "0" : "1";
        $db->query(sprintf("INSERT INTO posts (user_id, user_type, post_type, origin_id, time, privacy, text, in_group, group_id, group_approved) VALUES (%s, 'user', 'shared', %s, %s, 'custom', %s, '1', %s, %s)", secure($this->_data['user_id'], 'int'), secure($post_id, 'int'), secure($date), secure($args['message']), secure($args['group'], 'int'), secure($group_approved)));
        $post_id = $db->insert_id;
        $this->refresh_post_search($post_id);
        /* post in_group notification */
        if (!$group_approved) {
          /* send notification to group admin */
          $this->post_notification(['to_user_id' => $group['group_admin'], 'action' => 'group_post_pending', 'node_type' => $group['group_title'], 'node_url' => $group['group_name'] . "-[guid=]" . $post_id]);
        }
        break;

      case 'event':
        /* check if the event is valid */
        $get_event = $db->query(sprintf("SELECT * FROM `events` WHERE event_id = %s", secure($args['event'], 'int')));
        if ($get_event->num_rows == 0) {
          _error(400);
        }
        $event = $get_event->fetch_assoc();
        /* check if the viewer is event member */
        if (!$this->check_event_membership($this->_data['user_id'], $args['event'])) {
          _error(400);
        }
        /* check if user is a event admin */
        $event['i_admin'] = $this->check_event_adminship($this->_data['user_id'], $event['event_id']);
        /* check if event publishing enabled */
        if (!$event['event_publish_enabled'] && !$event['i_admin']) {
          throw new Exception(__("Publishing to this event has been disabled by event admins"));
        }
        /* insert the new shared post */
        $event_approved = ($event['event_publish_approval_enabled'] && !$event['i_admin']) ? "0" : "1";
        $db->query(sprintf("INSERT INTO posts (user_id, user_type, post_type, origin_id, time, privacy, text, in_event, event_id, event_approved) VALUES (%s, 'user', 'shared', %s, %s, 'custom', %s, '1', %s, %s)", secure($this->_data['user_id'], 'int'), secure($post_id, 'int'), secure($date), secure($args['message']), secure($args['event'], 'int'), secure($event_approved)));
        $post_id = $db->insert_id;
        $this->refresh_post_search($post_id);
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
    /* update the origin post shares counter */
    $db->query(sprintf("UPDATE posts SET shares = shares + 1 WHERE post_id = %s", secure($post_id, 'int')));
    /* post notification */
    $this->post_notification(['to_user_id' => $author_id, 'action' => 'share', 'node_type' => 'post', 'node_url' => $post_id]);
  }


  /**
   * delete_posts
   * 
   * @param integer $node_id
   * @param string $node_type
   * @return void
   */
  public function delete_posts($node_id, $node_type = 'user')
  {
    global $db;
    /* get all user posts */
    switch ($node_type) {
      case 'user':
        $get_posts = $db->query(sprintf("SELECT post_id FROM posts WHERE user_id = %s AND user_type = 'user'", secure($node_id, 'int')));
        break;

      case 'page':
        $get_posts = $db->query(sprintf("SELECT post_id FROM posts WHERE user_id = %s AND user_type = 'page'", secure($node_id, 'int')));
        break;

      case 'group':
        $get_posts = $db->query(sprintf("SELECT post_id FROM posts WHERE group_id = %s AND in_group = '1'", secure($node_id, 'int')));
        break;

      case 'event':
        $get_posts = $db->query(sprintf("SELECT post_id FROM posts WHERE event_id = %s AND in_event = '1'", secure($node_id, 'int')));
        break;
    }
    if ($get_posts->num_rows > 0) {
      while ($post = $get_posts->fetch_assoc()) {
        $this->delete_post($post['post_id'], false);
      }
    }
  }


  /**
   * delete_post
   * 
   * @param integer $post_id
   * @param boolean $return_errors
   * @return boolean
   */
  public function delete_post($post_id, $return_errors = true)
  {
    global $db, $system;
    /* (check|get) post */
    $post = $this->get_post($post_id, false, true);
    if (!$post) {
      /* check & delete orphaned data */
      if (!$return_errors || $this->_is_admin) {
        $check_post = $db->query(sprintf("SELECT COUNT(*) as count FROM posts WHERE post_id = %s", secure($post_id, 'int')));
        if ($check_post->fetch_assoc()['count'] > 0) {
          $this->delete_hashtags($post_id);
          $db->query(sprintf("DELETE FROM posts WHERE post_id = %s", secure($post_id, 'int')));
          $db->query(sprintf("DELETE FROM posts_hidden WHERE post_id = %s", secure($post_id, 'int')));
          $db->query(sprintf("DELETE FROM posts_locations WHERE post_id = %s", secure($post_id, 'int')));
          $db->query(sprintf("DELETE FROM posts_search WHERE post_id = %s", secure($post_id, 'int')));
          $db->query(sprintf("DELETE FROM posts_paid WHERE post_id = %s", secure($post_id, 'int')));
          $db->query(sprintf("DELETE FROM posts_reactions WHERE post_id = %s", secure($post_id, 'int')));
          $db->query(sprintf("DELETE FROM posts_saved WHERE post_id = %s", secure($post_id, 'int')));
          $db->query(sprintf("DELETE FROM posts_views WHERE post_id = %s", secure($post_id, 'int')));
          $db->query(sprintf("DELETE FROM reports WHERE node_type = 'post' AND node_id = %s", secure($post_id, 'int')));
          $this->delete_translations('post', $post_id);
          return false;
        }
      }
      if (!$return_errors) {
        return;
      }
      _error(403);
    }
    /* can delete the post */
    if (!$post['manage_post']) {
      if (!$return_errors) {
        return;
      }
      _error(403);
    }
    /* delete hashtags */
    $this->delete_hashtags($post_id);
    /* delete post comments */
    $get_comments = $db->query(sprintf("SELECT posts_comments.comment_id FROM posts_comments WHERE node_id = %s AND node_type = 'post'", secure($post_id, 'int'))) or _error("SQL_ERROR_THROWEN");
    if ($get_comments->num_rows > 0) {
      while ($comment = $get_comments->fetch_assoc()) {
        $this->delete_comment($comment['comment_id']);
      }
    }
    /* set refresh */
    $refresh = false;
    /* delete post */
    $db->query(sprintf("DELETE FROM posts WHERE post_id = %s", secure($post_id, 'int')));
    /* delete post hidden */
    $db->query(sprintf("DELETE FROM posts_hidden WHERE post_id = %s", secure($post_id, 'int')));
    /* delete post location */
    $db->query(sprintf("DELETE FROM posts_locations WHERE post_id = %s", secure($post_id, 'int')));
    /* delete post search */
    $db->query(sprintf("DELETE FROM posts_search WHERE post_id = %s", secure($post_id, 'int')));
    /* delete post paid */
    $db->query(sprintf("DELETE FROM posts_paid WHERE post_id = %s", secure($post_id, 'int')));
    /* delete posts reactions */
    $db->query(sprintf("DELETE FROM posts_reactions WHERE post_id = %s", secure($post_id, 'int')));
    /* delete posts saved */
    $db->query(sprintf("DELETE FROM posts_saved WHERE post_id = %s", secure($post_id, 'int')));
    /* delete posts views */
    $db->query(sprintf("DELETE FROM posts_views WHERE post_id = %s", secure($post_id, 'int')));
    /* delete reports */
    $db->query(sprintf("DELETE FROM reports WHERE node_type = 'post' AND node_id = %s", secure($post_id, 'int')));
    /* delete translations */
    $this->delete_translations('post', $post_id);
    /* delete subscriptions image if exists */
    if ($post['for_subscriptions'] && $post['subscriptions_image']) {
      delete_uploads_file($post['subscriptions_image']);
    }
    /* delete paid image if exists */
    if ($post['is_paid'] && $post['paid_image']) {
      delete_uploads_file($post['paid_image']);
    }
    /* delete nested tables */
    /* delete photos post */
    if (in_array($post['post_type'], ['photos', 'album', 'profile_cover', 'profile_picture', 'page_cover', 'page_picture', 'group_cover', 'group_picture', 'event_cover', 'product', 'combo']) && $post['photos']) {
      /* delete post photos from database */
      $db->query(sprintf("DELETE FROM posts_photos WHERE post_id = %s", secure($post_id, 'int')));
      switch ($post['post_type']) {
        case 'profile_cover':
          /* update user cover if it's current cover */
          if ($post['user_cover_id']  ==  $post['photos'][0]['photo_id']) {
            $db->query(sprintf("UPDATE users SET user_cover = null, user_cover_id = null WHERE user_id = %s", secure($post['author_id'], 'int')));
            /* delete cover image from uploads folder */
            delete_uploads_file($post['user_cover']);
            /* return */
            $refresh = true;
          }
          break;

        case 'profile_picture':
          /* update user picture if it's current picture */
          if ($post['user_picture_id']  ==  $post['photos'][0]['photo_id']) {
            $db->query(sprintf("UPDATE users SET user_picture = null, user_picture_id = null WHERE user_id = %s", secure($post['author_id'], 'int')));
            /* delete cropped picture from uploads folder */
            delete_uploads_file($post['user_picture']);
            /* return */
            $refresh = true;
          }
          break;

        case 'page_cover':
          /* update page cover if it's current cover */
          if ($post['page_cover_id']  ==  $post['photos'][0]['photo_id']) {
            $db->query(sprintf("UPDATE pages SET page_cover = null, page_cover_id = null WHERE page_id = %s", secure($post['user_id'], 'int')));
            /* delete cover image from uploads folder */
            delete_uploads_file($post['page_cover']);
            /* return */
            $refresh = true;
          }
          break;

        case 'page_picture':
          /* update page picture if it's current picture */
          if ($post['page_picture_id']  ==  $post['photos'][0]['photo_id']) {
            $db->query(sprintf("UPDATE pages SET page_picture = null, page_picture_id = null WHERE page_id = %s", secure($post['user_id'], 'int')));
            /* delete cropped picture from uploads folder */
            delete_uploads_file($post['page_picture']);
            /* return */
            $refresh = true;
          }
          break;

        case 'group_cover':
          /* update group cover if it's current cover */
          if ($post['group_cover_id']  ==  $post['photos'][0]['photo_id']) {
            $db->query(sprintf("UPDATE `groups` SET group_cover = null, group_cover_id = null WHERE group_id = %s", secure($post['group_id'], 'int')));
            /* delete cover image from uploads folder */
            delete_uploads_file($post['group_cover']);
            /* return */
            $refresh = true;
          }
          break;

        case 'group_picture':
          /* update group picture if it's current picture */
          if ($post['group_picture_id']  ==  $post['photos'][0]['photo_id']) {
            $db->query(sprintf("UPDATE `groups` SET group_picture = null, group_picture_id = null WHERE group_id = %s", secure($post['group_id'], 'int')));
            /* delete cropped from uploads folder */
            delete_uploads_file($post['group_picture']);
            /* return */
            $refresh = true;
          }
          break;

        case 'event_cover':
          /* update event cover if it's current cover */
          if ($post['event_cover_id']  ==  $post['photos'][0]['photo_id']) {
            $db->query(sprintf("UPDATE `events` SET event_cover = null, event_cover_id = null WHERE event_id = %s", secure($post['event_id'], 'int')));
            /* delete cover image from uploads folder */
            delete_uploads_file($post['event_cover']);
            /* return */
            $refresh = true;
          }
          break;

        case 'product':
          /* delete nested table row */
          $db->query(sprintf("DELETE FROM posts_products WHERE post_id = %s", secure($post_id, 'int')));
          break;
      }
      /* delete uploads from uploads folder */
      foreach ($post['photos'] as $photo) {
        delete_uploads_file($photo['source']);
      }
    }
    /* delete media post */
    if ($post['post_type'] == 'media') {
      /* delete nested table row */
      $db->query(sprintf("DELETE FROM posts_media WHERE post_id = %s", secure($post_id, 'int')));
    }
    /* delete link post */
    if ($post['post_type'] == 'link') {
      /* delete nested table row */
      $db->query(sprintf("DELETE FROM posts_links WHERE post_id = %s", secure($post_id, 'int')));
    }
    /* delete live post */
    if ($post['post_type'] == 'live') {
      /* delete nested table row */
      $db->query(sprintf("DELETE FROM posts_live WHERE post_id = %s", secure($post_id, 'int')));
      /* delete live users */
      $db->query(sprintf("DELETE FROM posts_live_users WHERE post_id = %s", secure($post_id, 'int')));
    }
    /* delete blog post */
    if ($post['post_type'] == 'article') {
      /* delete nested table row */
      $db->query(sprintf("DELETE FROM posts_articles WHERE post_id = %s", secure($post_id, 'int')));
      /* delete uploads from uploads folder */
      delete_uploads_file($post['blog']['cover']);
      foreach (extract_uploaded_images_from_text($post['blog']['parsed_text']) as $image) {
        delete_uploads_file($image);
      }
    }
    /* delete rich text post */
    if ($post['post_type'] == 'rich_text') {
      /* delete nested table row */
      $db->query(sprintf("DELETE FROM posts_rich_text WHERE post_id = %s", secure($post_id, 'int')));
      /* delete uploads from uploads folder */
      foreach (extract_uploaded_images_from_text($post['rich_text']['parsed_text']) as $image) {
        delete_uploads_file($image);
      }
    }
    /* delete funding post */
    if ($post['post_type'] == 'funding') {
      /* delete nested table row */
      $db->query(sprintf("DELETE FROM posts_funding WHERE post_id = %s", secure($post_id, 'int')));
      /* delete funding donors */
      $db->query(sprintf("DELETE FROM posts_funding_donors WHERE post_id = %s", secure($post_id, 'int')));
      /* delete uploads from uploads folder */
      delete_uploads_file($post['funding']['cover_image']);
    }
    /* delete offer post */
    if ($post['post_type'] == 'offer') {
      /* delete nested table row */
      $db->query(sprintf("DELETE FROM posts_offers WHERE post_id = %s", secure($post_id, 'int')));
      /* delete uploads from uploads folder */
      delete_uploads_file($post['offer']['thumbnail']);
    }
    /* delete job post */
    if ($post['post_type'] == 'job') {
      /* delete nested table row */
      $db->query(sprintf("DELETE FROM posts_jobs WHERE post_id = %s", secure($post_id, 'int')));
      /* delete uploads from uploads folder */
      delete_uploads_file($post['job']['cover_image']);
    }
    /* delete course post */
    if ($post['post_type'] == 'course') {
      /* delete nested table row */
      $db->query(sprintf("DELETE FROM posts_courses WHERE post_id = %s", secure($post_id, 'int')));
      /* delete uploads from uploads folder */
      delete_uploads_file($post['course']['cover_image']);
    }
    /* delete poll post */
    if ($post['post_type'] == 'poll') {
      /* delete nested table row */
      $db->query(sprintf("DELETE FROM posts_polls WHERE post_id = %s", secure($post_id, 'int')));
      $db->query(sprintf("DELETE FROM posts_polls_options WHERE poll_id = %s", secure($post['poll']['poll_id'], 'int')));
      $db->query(sprintf("DELETE FROM posts_polls_options_users WHERE poll_id = %s", secure($post['poll']['poll_id'], 'int')));
    }
    /* delete reel post */
    if ($post['post_type'] == 'reel' && $post['reel']) {
      /* delete nested table row */
      $db->query(sprintf("DELETE FROM posts_reels WHERE post_id = %s", secure($post_id, 'int')));
      /* delete uploads from uploads folder */
      delete_uploads_file($post['reel']['thumbnail']);
      delete_uploads_file($post['reel']['source']);
      delete_uploads_file($post['reel']['source_240p']);
      delete_uploads_file($post['reel']['source_360p']);
      delete_uploads_file($post['reel']['source_480p']);
      delete_uploads_file($post['reel']['source_720p']);
      delete_uploads_file($post['reel']['source_1080p']);
      delete_uploads_file($post['reel']['source_1440p']);
      delete_uploads_file($post['reel']['source_2160p']);
    }
    /* delete video post */
    if (($post['post_type'] == 'video' || $post['post_type'] == 'combo') && $post['video']) {
      /* delete nested table row */
      $db->query(sprintf("DELETE FROM posts_videos WHERE post_id = %s", secure($post_id, 'int')));
      /* delete uploads from uploads folder */
      delete_uploads_file($post['video']['thumbnail']);
      delete_uploads_file($post['video']['source']);
      delete_uploads_file($post['video']['source_240p']);
      delete_uploads_file($post['video']['source_360p']);
      delete_uploads_file($post['video']['source_480p']);
      delete_uploads_file($post['video']['source_720p']);
      delete_uploads_file($post['video']['source_1080p']);
      delete_uploads_file($post['video']['source_1440p']);
      delete_uploads_file($post['video']['source_2160p']);
    }
    /* delete audio post */
    if (($post['post_type'] == 'audio' || $post['post_type'] == 'combo') && $post['audio']) {
      /* delete uploads from uploads folder */
      delete_uploads_file($post['audio']['source']);
      /* delete nested table row */
      $db->query(sprintf("DELETE FROM posts_audios WHERE post_id = %s", secure($post_id, 'int')));
    }
    /* delete file post */
    if (($post['post_type'] == 'file' || $post['post_type'] == 'combo') && $post['file']) {
      /* delete nested table row */
      $db->query(sprintf("DELETE FROM posts_files WHERE post_id = %s", secure($post_id, 'int')));
      /* delete uploads from uploads folder */
      delete_uploads_file($post['file']['source']);
    }
    /* points balance */
    $this->points_balance("delete", $post['author_id'], "post");
    /* delete post in_group notification */
    if ($post['in_group'] && !$post['group_approved']) {
      $this->delete_notification($post['group_admin'], 'group_post_pending', $post['group_title'], $post['group_name'] . "-[guid=]" . $post['post_id']);
    }
    /* delete post in_event notification */
    if ($post['in_event'] && !$post['event_approved']) {
      $this->delete_notification($post['event_admin'], 'event_post_pending', $post['event_title'], $post['event_id'] . "-[guid=]" . $post['post_id']);
    }
    /* delete collaborative users */
    if ($post['is_collaborative']) {
      /* delete collaborative users notifications */
      foreach ($post['collaborative_users'] as $collaborative_user) {
        $this->delete_notification($collaborative_user['user_id'], 'collaborative_post', 'post', $post_id);
      }
      /* delete collaborative users from database */
      $db->query(sprintf("DELETE FROM posts_collaborative_users WHERE post_id = %s", secure($post_id, 'int')));
    }
    return $refresh;
  }


  /**
   * edit_post
   * 
   * @param integer $post_id
   * @param string $message
   * @return array
   */
  public function edit_post($post_id, $message)
  {
    global $db, $system;
    $db->begin_transaction();
    try {
      $db->query(sprintf("SELECT post_id FROM posts WHERE post_id = %s FOR UPDATE", secure($post_id, 'int')));
      /* (check|get) post */
      $post = $this->_check_post($post_id, true);
      if (!$post) {
        throw new ValidationException(__("This post is unavailable or you cannot edit it"));
      }
      /* check if viewer can edit post */
      if (!$post['manage_post']) {
        throw new ValidationException(__("This post is unavailable or you cannot edit it"));
      }
      $this->check_post_edit_window($post);
      /* protect voted polls */
      if ($post['post_type'] == 'poll') {
        $poll = $db->query(sprintf("SELECT votes, edit_locked FROM posts_polls WHERE post_id = %s", secure($post_id, 'int')))->fetch_assoc();
        if ($poll && ($poll['votes'] > 0 || $poll['edit_locked']) && $message !== html_entity_decode($post['text'], ENT_QUOTES, 'UTF-8')) {
          throw new ValidationException(__("The question and options cannot be changed after people have voted"));
        }
      }
      /* sanitize message */
      $message = strip_tags($message, '<p><br><b><strong><i><em><u><s><del><blockquote><ul><ol><li><h1><h2><span>');
      /* check post max length */
      if ($system['max_post_length'] > 0 && $this->_data['user_group'] >= 3) {
        if (strlen($message) >= $system['max_post_length']) {
          modal("MESSAGE", __("Text Length Limit Reached"), __("Your message characters length is over the allowed limit") . " (" . $system['max_post_length'] . " " . __("Characters") . ")");
        }
      }
      /* delete hashtags */
      $this->delete_hashtags($post_id);
      /* check if post in_group with approval system */
      if ($post['in_group'] && $post['group_publish_approval_enabled'] && $post['group_approved']) {
        $post['group_approved'] = ($post['group_publish_approval_enabled'] && !$post['is_group_admin']) ? '0' : '1';
        /* post notification to group admin */
        if (!$post['group_approved']) {
          $this->post_notification(['to_user_id' => $post['group_admin'], 'action' => 'group_post_pending', 'node_type' => $post['group_title'], 'node_url' => $post['group_name'] . "-[guid=]" . $post['post_id']]);
        }
      }
      /* check if post in_event with approval system */
      if ($post['in_event'] && $post['event_publish_approval_enabled'] && $post['event_approved']) {
        $post['event_approved'] = ($post['event_publish_approval_enabled'] && !$post['is_event_admin']) ? '0' : '1';
        /* post notification to event admin */
        if (!$post['event_approved']) {
          $this->post_notification(['to_user_id' => $post['event_admin'], 'action' => 'event_post_pending', 'node_type' => $post['event_title'], 'node_url' => $post['event_id'] . "-[guid=]" . $post['post_id']]);
        }
      }
      /* update post */
      $db->query(sprintf("UPDATE posts SET text = %s, group_approved = %s, event_approved = %s WHERE post_id = %s", secure($message), secure($post['group_approved']), secure($post['event_approved']), secure($post_id, 'int')));
      $this->refresh_post_search($post_id);
      $this->queue_post_reapproval($post);
      /* post mention notifications */
      $this->post_mentions($message, $post_id);
      /* delete translations */
      $this->delete_translations('post', $post_id);
      /* parse text */
      $post['text_plain'] = htmlentities($message, ENT_QUOTES, 'utf-8');
      $post['text'] = $this->parse(["text" => $post['text_plain'], "trending_hashtags" => true, "post_id" => $post_id]);
      /* get post colored pattern */
      $post['colored_pattern'] = $this->get_posts_colored_pattern($post['colored_pattern']);
      /* return */
      $db->commit();
      return $post;
    } catch (Throwable $e) {
      $db->rollback();
      throw $e;
    }
  }


  /**
   * edit_product
   * 
   * @param integer $post_id
   * @param string $message
   * @param array $args
   * @return void
   */
  public function edit_product($post_id, $message, $args = [])
  {
    global $db, $system;
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
    /* update post */
    $db->query(sprintf("UPDATE posts SET text = %s WHERE post_id = %s", secure($message), secure($post_id, 'int')));
    /* update product */
    $db->query(sprintf("UPDATE posts_products SET name = %s, price = %s, quantity = %s, category_id = %s, status = %s, location = %s, is_digital = %s, product_download_url = %s, product_file_source = %s WHERE post_id = %s", secure($args['name']), secure($args['price'], 'float'), secure($args['quantity'], 'int'), secure($args['category'], 'int'), secure($args['status']), secure($args['location']), secure($args['is_digital']), secure($args['product_url']), secure($args['product_file']), secure($post_id, 'int')));
    $this->refresh_post_search($post_id);
    $this->queue_post_reapproval($post);
  }


  /**
   * edit_funding
   * 
   * @param integer $post_id
   * @param string $message
   * @param array $args
   * @return void
   */
  public function edit_funding($post_id, $message, $args = [])
  {
    global $db, $system;
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
    /* update post */
    $db->query(sprintf("UPDATE posts SET text = %s WHERE post_id = %s", secure($message), secure($post_id, 'int')));
    /* update funding */
    $db->query(sprintf("UPDATE posts_funding SET category_id = %s, title = %s, amount = %s, cover_image = %s WHERE post_id = %s", secure($args['category'], 'int'), secure($args['title']), secure($args['amount']), secure($args['cover_image']), secure($post_id, 'int')));
    /* remove pending uploads */
    remove_pending_uploads([$args['cover_image']]);
    $this->refresh_post_search($post_id);
    $this->queue_post_reapproval($post);
  }


  /**
   * edit_offer
   * 
   * @param integer $post_id
   * @param string $message
   * @param array $args
   * @return void
   */
  public function edit_offer($post_id, $message, $args = [])
  {
    global $db, $system;
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
    /* prepare end date (optional) */
    $end_date = ($args['end_date']) ? secure($args['end_date'], 'datetime') : 'NULL';
    /* update post */
    $db->query(sprintf("UPDATE posts SET text = %s WHERE post_id = %s", secure($message), secure($post_id, 'int')));
    /* update offer */
    $db->query(sprintf("UPDATE posts_offers SET category_id = %s, title = %s, discount_type = %s, discount_percent = %s, discount_amount = %s, buy_x = %s, get_y = %s, spend_x = %s, amount_y = %s, end_date = %s, thumbnail = %s, price = %s WHERE post_id = %s", secure($args['category'], 'int'), secure($args['title']), secure($args['discount_type']), secure($args['discount_percent'], 'int'), secure($args['discount_amount']), secure($args['buy_x']), secure($args['get_y']), secure($args['spend_x']), secure($args['amount_y']), $end_date, secure($args['thumbnail']), secure($args['price'], 'float'), secure($post_id, 'int')));
    /* remove pending uploads */
    remove_pending_uploads([$args['thumbnail']]);
    $this->refresh_post_search($post_id);
    $this->queue_post_reapproval($post);
  }


  /**
   * edit_job
   * 
   * @param integer $post_id
   * @param string $message
   * @param array $arg
   * @return void
   */
  public function edit_job($post_id, $message, $args = [])
  {
    global $db, $system;
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
    /* update post */
    $db->query(sprintf("UPDATE posts SET text = %s WHERE post_id = %s", secure($message), secure($post_id, 'int')));
    /* update job */
    $db->query(sprintf(
      "UPDATE posts_jobs SET 
            category_id = %s, 
            title = %s, 
            location = %s, 
            salary_minimum = %s, 
            salary_minimum_currency = %s, 
            salary_maximum = %s, 
            salary_maximum_currency = %s, 
            pay_salary_per = %s, 
            type = %s, 
            question_1_type = %s, 
            question_1_title = %s, 
            question_1_choices = %s, 
            question_2_type = %s, 
            question_2_title = %s, 
            question_2_choices = %s, 
            question_3_type = %s, 
            question_3_title = %s, 
            question_3_choices = %s, 
            cover_image = %s 
            WHERE post_id = %s",
      secure($args['category'], 'int'),
      secure($args['title']),
      secure($args['location']),
      secure($args['salary_minimum']),
      secure($args['salary_minimum_currency'], 'int'),
      secure($args['salary_maximum']),
      secure($args['salary_maximum_currency'], 'int'),
      secure($args['pay_salary_per']),
      secure($args['type']),
      secure($args['question_1_type']),
      secure($args['question_1_title']),
      secure($args['question_1_choices']),
      secure($args['question_2_type']),
      secure($args['question_2_title']),
      secure($args['question_2_choices']),
      secure($args['question_3_type']),
      secure($args['question_3_title']),
      secure($args['question_3_choices']),
      secure($args['cover_image']),
      secure($post_id, 'int')
    ));
    /* remove pending uploads */
    remove_pending_uploads([$args['cover_image']]);
    $this->refresh_post_search($post_id);
    $this->queue_post_reapproval($post);
  }


  /**
   * edit_course
   * 
   * @param integer $post_id
   * @param string $message
   * @param array $arg
   * @return void
   */
  public function edit_course($post_id, $message, $args = [])
  {
    global $db, $system;
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
    /* update post */
    $db->query(sprintf("UPDATE posts SET text = %s WHERE post_id = %s", secure($message), secure($post_id, 'int')));
    /* update course */
    $db->query(sprintf(
      "UPDATE posts_courses SET 
            category_id = %s, 
            title = %s, 
            location = %s, 
            fees = %s, 
            fees_currency = %s, 
            start_date = %s,
            end_date = %s,
            cover_image = %s 
            WHERE post_id = %s",
      secure($args['category'], 'int'),
      secure($args['title']),
      secure($args['location']),
      secure($args['fees']),
      secure($args['fees_currency'], 'int'),
      secure($args['start_date'], 'datetime'),
      secure($args['end_date'], 'datetime'),
      secure($args['cover_image']),
      secure($post_id, 'int')
    ));
    /* remove pending uploads */
    remove_pending_uploads([$args['cover_image']]);
    $this->refresh_post_search($post_id);
    $this->queue_post_reapproval($post);
  }


  /**
   * edit_privacy
   * 
   * @param integer $post_id
   * @param string $privacy
   * @return void
   */
  public function edit_privacy($post_id, $privacy)
  {
    global $db, $system;
    /* (check|get) post */
    $post = $this->_check_post($post_id, true);
    if (!$post) {
      _error(403);
    }
    /* check post type */
    if ($post['is_anonymous'] || $post['in_group'] || $post['in_event'] || in_array($post['post_type'], ['article', 'product', 'funding'])) {
      _error(400);
    }
    /* check if viewer can edit privacy */
    if ($post['manage_post'] && $post['user_type'] == 'user' && !$post['in_group'] && !$post['in_event'] && $post['post_type'] != "product") {
      /* update privacy */
      $db->query(sprintf("UPDATE posts SET privacy = %s WHERE post_id = %s", secure($privacy), secure($post_id, 'int')));
    } else {
      _error(403);
    }
  }


  /**
   * disallow_post
   * 
   * @param integer $post_id
   * @return void
   */
  public function disallow_post($post_id)
  {
    global $db;
    /* (check|get) post */
    $post = $this->_check_post($post_id);
    if (!$post) {
      _error(403);
    }
    /* check if viewer can edit post */
    if (!$post['manage_post']) {
      _error(403);
    }
    /* check if post is_anonymous */
    if ($post['is_anonymous']) {
      throw new Exception(__("You can not do this with anonymous post"));
    }
    /* set post as hidden */
    $db->query(sprintf("UPDATE posts SET is_hidden = '1' WHERE post_id = %s", secure($post_id, 'int')));
  }


  /**
   * allow_post
   * 
   * @param integer $post_id
   * @return void
   */
  public function allow_post($post_id)
  {
    global $db;
    /* (check|get) post */
    $post = $this->_check_post($post_id);
    if (!$post) {
      _error(403);
    }
    /* check if viewer can edit post */
    if (!$post['manage_post']) {
      _error(403);
    }
    /* check if post is_anonymous */
    if ($post['is_anonymous']) {
      throw new Exception(__("You can not do this with anonymous post"));
    }
    /* set post as not hidden */
    $db->query(sprintf("UPDATE posts SET is_hidden = '0' WHERE post_id = %s", secure($post_id, 'int')));
  }


  /**
   * disable_post_comments
   * 
   * @param integer $post_id
   * @return void
   */
  public function disable_post_comments($post_id)
  {
    global $db;
    /* (check|get) post */
    $post = $this->_check_post($post_id);
    if (!$post) {
      _error(403);
    }
    /* check if viewer can edit post */
    if (!$post['manage_post']) {
      _error(403);
    }
    /* trun off post commenting */
    $db->query(sprintf("UPDATE posts SET comments_disabled = '1' WHERE post_id = %s", secure($post_id, 'int')));
  }


  /**
   * enable_post_comments
   * 
   * @param integer $post_id
   * @return void
   */
  public function enable_post_comments($post_id)
  {
    global $db;
    /* (check|get) post */
    $post = $this->_check_post($post_id);
    if (!$post) {
      _error(403);
    }
    /* check if viewer can edit post */
    if (!$post['manage_post']) {
      _error(403);
    }
    /* trun on post commenting */
    $db->query(sprintf("UPDATE posts SET comments_disabled = '0' WHERE post_id = %s", secure($post_id, 'int')));
  }


  /**
   * approve_post
   * 
   * @param integer $post_id
   * @return void
   */
  public function approve_post($post_id)
  {
    global $db;
    /* (check|get) post */
    $post = $this->_check_post($post_id);
    if (!$post) {
      _error(403);
    }
    /* check if viewer can approve post */
    if ($post['in_group']) {
      if (!$post['is_group_admin']) {
        _error(403);
      }
      /* approve post */
      $db->query(sprintf("UPDATE posts SET group_approved = '1' WHERE post_id = %s", secure($post_id, 'int')));
      /* send notification to the post author */
      $this->post_notification(['to_user_id' => $post['author_id'], 'action' => 'group_post_approval', 'node_type' => $post['group_title'], 'node_url' => $post['group_name']]);
    } elseif ($post['in_event']) {
      if (!$post['is_event_admin']) {
        _error(403);
      }
      /* approve post */
      $db->query(sprintf("UPDATE posts SET event_approved = '1' WHERE post_id = %s", secure($post_id, 'int')));
      /* send notification to the post author */
      $this->post_notification(['to_user_id' => $post['author_id'], 'action' => 'event_post_approval', 'node_type' => $post['event_title'], 'node_url' => $post['event_id']]);
    }
  }


  /**
   * sold_post
   * 
   * @param integer $post_id
   * @return void
   */
  public function sold_post($post_id)
  {
    global $db;
    /* (check|get) post */
    $post = $this->_check_post($post_id);
    if (!$post) {
      _error(403);
    }
    /* check if viewer can edit post */
    if (!$post['manage_post']) {
      _error(403);
    }
    /* sold post */
    $db->query(sprintf("UPDATE posts_products SET available = '0' WHERE post_id = %s", secure($post_id, 'int')));
  }


  /**
   * unsold_post
   * 
   * @param integer $post_id
   * @return void
   */
  public function unsold_post($post_id)
  {
    global $db;
    /* (check|get) post */
    $post = $this->_check_post($post_id);
    if (!$post) {
      _error(403);
    }
    /* check if viewer can edit post */
    if (!$post['manage_post']) {
      _error(403);
    }
    /* unsold post */
    $db->query(sprintf("UPDATE posts_products SET available = '1' WHERE post_id = %s", secure($post_id, 'int')));
  }


  /**
   * closed_post
   * 
   * @param integer $post_id
   * @return void
   */
  public function closed_post($post_id)
  {
    global $db;
    /* (check|get) post */
    $post = $this->_check_post($post_id);
    if (!$post) {
      _error(403);
    }
    /* check if viewer can edit post */
    if (!$post['manage_post']) {
      _error(403);
    }
    /* close post */
    switch ($post['post_type']) {
      case 'job':
        $table = "posts_jobs";
        break;

      case 'course':
        $table = "posts_courses";
        break;
    }
    $db->query(sprintf("UPDATE $table SET available = '0' WHERE post_id = %s", secure($post_id, 'int')));
  }


  /**
   * unclosed_post
   * 
   * @param integer $post_id
   * @return void
   */
  public function unclosed_post($post_id)
  {
    global $db;
    /* (check|get) post */
    $post = $this->_check_post($post_id);
    if (!$post) {
      _error(403);
    }
    /* check if viewer can edit post */
    if (!$post['manage_post']) {
      _error(403);
    }
    /* unclose post */
    switch ($post['post_type']) {
      case 'job':
        $table = "posts_jobs";
        break;

      case 'course':
        $table = "posts_courses";
        break;
    }
    $db->query(sprintf("UPDATE $table SET available = '1' WHERE post_id = %s", secure($post_id, 'int')));
  }


  /**
   * save_post
   * 
   * @param integer $post_id
   * @return void
   */
  public function save_post($post_id)
  {
    global $db, $date;
    /* (check|get) post */
    $post = $this->_check_post($post_id);
    if (!$post) {
      _error(403);
    }
    /* save post */
    if (!$post['i_save']) {
      $db->query(sprintf("INSERT INTO posts_saved (post_id, user_id, time) VALUES (%s, %s, %s)", secure($post_id, 'int'), secure($this->_data['user_id'], 'int'), secure($date)));
    }
  }


  /**
   * unsave_post
   * 
   * @param integer $post_id
   * @return void
   */
  public function unsave_post($post_id)
  {
    global $db;
    /* (check|get) post */
    $post = $this->_check_post($post_id);
    if (!$post) {
      _error(403);
    }
    /* unsave post */
    if ($post['i_save']) {
      $db->query(sprintf("DELETE FROM posts_saved WHERE post_id = %s AND user_id = %s", secure($post_id, 'int'), secure($this->_data['user_id'], 'int')));
    }
  }


  /**
   * boost_post
   * 
   * @param integer $post_id
   * @return void
   */
  public function boost_post($post_id)
  {
    global $db;
    /* (check|get) post */
    $post = $this->_check_post($post_id);
    if (!$post) {
      _error(403);
    }
    /* check if viewer can edit post */
    if (!$post['manage_post']) {
      _error(403);
    }
    /* check if viewer can boost post */
    if (!$this->_data['can_boost_posts']) {
      throw new Exception(__("You reached the maximum number of boosted posts! Upgrade your package to get more"));
    }
    /* check if post is still scheduled */
    if ($post['still_scheduled']) {
      throw new Exception(__("This post is still scheduled"));
    }
    /* check if the post in_group or in_event */
    if ($post['in_group'] || $post['in_event']) {
      throw new Exception(__("You can't boost a post from a group or event"));
    }
    /* boost post */
    if (!$post['boosted']) {
      /* boost post */
      $db->query(sprintf("UPDATE posts SET boosted = '1', boosted_by = %s WHERE post_id = %s", secure($this->_data['user_id'], 'int'), secure($post_id, 'int')));
      widget_pools_forget();
      /* update user */
      $db->query(sprintf("UPDATE users SET user_boosted_posts = user_boosted_posts + 1 WHERE user_id = %s", secure($this->_data['user_id'], 'int')));
    }
  }


  /**
   * unboost_post
   * 
   * @param integer $post_id
   * @return void
   */
  public function unboost_post($post_id)
  {
    global $db;
    /* (check|get) post */
    $post = $this->_check_post($post_id);
    if (!$post) {
      _error(403);
    }
    /* check if viewer can edit post */
    if (!$post['manage_post']) {
      _error(403);
    }
    /* unboost post */
    if ($post['boosted']) {
      /* unboost post */
      $db->query(sprintf("UPDATE posts SET boosted = '0', boosted_by = NULL WHERE post_id = %s", secure($post_id, 'int')));
      widget_pools_forget();
      /* update user */
      $db->query(sprintf("UPDATE users SET user_boosted_posts = IF(user_boosted_posts=0,0,user_boosted_posts-1) WHERE user_id = %s", secure($this->_data['user_id'], 'int')));
    }
  }


  /**
   * pin_post
   * 
   * @param integer $post_id
   * @return void
   */
  public function pin_post($post_id)
  {
    global $db;
    /* (check|get) post */
    $post = $this->_check_post($post_id);
    if (!$post) {
      _error(403);
    }
    /* check if viewer can edit post */
    if (!$post['manage_post']) {
      _error(403);
    }
    /* check if post is still scheduled */
    if ($post['still_scheduled']) {
      throw new Exception(__("This post is still scheduled"));
    }
    /* check if post is_anonymous */
    if ($post['is_anonymous']) {
      throw new Exception(__("You can not do this with anonymous post"));
    }
    /* pin post */
    if (!$post['pinned']) {
      /* check the post author type */
      if ($post['user_type'] == "user") {
        /* user */
        if ($post['in_group']) {
          if (!$post['is_group_admin']) {
            throw new Exception(__("Only group admin can pin the post"));
          }
          /* update group */
          $db->query(sprintf("UPDATE `groups` SET group_pinned_post = %s WHERE group_id = %s", secure($post_id, 'int'), secure($post['group_id'], 'int')));
        } elseif ($post['in_event']) {
          if (!$post['is_event_admin']) {
            throw new Exception(__("Only event admin can pin the post"));
          }
          /* update event */
          $db->query(sprintf("UPDATE `events` SET event_pinned_post = %s WHERE event_id = %s", secure($post_id, 'int'), secure($post['event_id'], 'int')));
        } else {
          /* update user */
          $db->query(sprintf("UPDATE users SET user_pinned_post = %s WHERE user_id = %s", secure($post_id, 'int'), secure($post['author_id'], 'int')));
        }
      } else {
        /* update page */
        $db->query(sprintf("UPDATE pages SET page_pinned_post = %s WHERE page_id = %s", secure($post_id, 'int'), secure($post['user_id'], 'int')));
      }
    }
  }


  /**
   * unpin_post
   * 
   * @param integer $post_id
   * @return void
   */
  public function unpin_post($post_id)
  {
    global $db;
    /* (check|get) post */
    $post = $this->_check_post($post_id);
    if (!$post) {
      _error(403);
    }
    /* check if viewer can edit post */
    if (!$post['manage_post']) {
      _error(403);
    }
    /* check if post is_anonymous */
    if ($post['is_anonymous']) {
      throw new Exception(__("You can not do this with anonymous post"));
    }
    /* pin post */
    if ($post['pinned']) {
      /* check the post author type */
      if ($post['user_type'] == "user") {
        /* user */
        if ($post['in_group']) {
          if (!$post['is_group_admin']) {
            throw new Exception(__("Only group admin can unpin the post"));
          }
          /* update group */
          $db->query(sprintf("UPDATE `groups` SET group_pinned_post = '0' WHERE group_id = %s", secure($post['group_id'], 'int')));
        } elseif ($post['in_event']) {
          if (!$post['is_event_admin']) {
            throw new Exception(__("Only event admin can unpin the post"));
          }
          /* update event */
          $db->query(sprintf("UPDATE `events` SET event_pinned_post = '0' WHERE event_id = %s", secure($post['event_id'], 'int')));
        } else {
          /* update user */
          $db->query(sprintf("UPDATE users SET user_pinned_post = '0' WHERE user_id = %s", secure($post['user_id'], 'int')));
        }
      } else {
        /* update page */
        $db->query(sprintf("UPDATE pages SET page_pinned_post = '0' WHERE page_id = %s", secure($post['user_id'], 'int')));
      }
    }
  }


  /**
   * monetize_post
   * 
   * @param integer $post_id
   * @return void
   */
  public function monetize_post($post_id)
  {
    global $db;
    /* (check|get) post */
    $post = $this->_check_post($post_id);
    if (!$post) {
      _error(403);
    }
    /* check if viewer can edit post */
    if (!$post['manage_post']) {
      _error(403);
    }
    /* check if post can be monetized */
    if (!$post['can_be_for_subscriptions']) {
      _error(403);
    }
    /* monetize post */
    if (!$post['for_subscriptions']) {
      /* update post */
      $db->query(sprintf("UPDATE posts SET for_subscriptions = '1' WHERE post_id = %s", secure($post_id, 'int')));
    }
  }


  /**
   * unmonetize_post
   * 
   * @param integer $post_id
   * @return void
   */
  public function unmonetize_post($post_id)
  {
    global $db;
    /* (check|get) post */
    $post = $this->_check_post($post_id, true);
    if (!$post) {
      _error(403);
    }
    /* check if viewer can edit post */
    if (!$post['manage_post'] && !$post['is_group_admin'] && !$post['is_event_admin']) {
      _error(403);
    }
    /* check if post can be monetized */
    if (!$post['can_be_for_subscriptions']) {
      _error(403);
    }
    /* unmonetize post */
    if ($post['for_subscriptions']) {
      /* update post */
      $db->query(sprintf("UPDATE posts SET for_subscriptions = '0' WHERE post_id = %s", secure($post_id, 'int')));
    }
  }


  /**
   * react_post
   * 
   * @param integer $post_id
   * @param string $reaction
   * @return array|false
   */
  public function react_post($post_id, $reaction)
  {
    global $db, $date;
    /* check reation */
    if (!in_array($reaction, ['like', 'love', 'haha', 'yay', 'wow', 'sad', 'angry'])) {
      _error(403);
    }
    /* (check|get) post */
    $post = $this->_check_post($post_id);
    if (!$post) {
      _error(403);
    }
    /* check blocking */
    if ($post['user_type'] == "user" && $this->blocked($post['author_id'])) {
      _error(403);
    }
    /* react the post */
    if ($post['i_react']) {
      /* remove any previous reaction */
      $db->query(sprintf("DELETE FROM posts_reactions WHERE user_id = %s AND post_id = %s", secure($this->_data['user_id'], 'int'), secure($post_id, 'int')));
      /* update post reaction counter */
      $reaction_field = "reaction_" . $post['i_reaction'] . "_count";
      $db->query(sprintf("UPDATE posts SET $reaction_field = IF($reaction_field=0,0,$reaction_field-1) WHERE post_id = %s", secure($post_id, 'int')));
      /* delete notification */
      $this->delete_notification($post['author_id'], 'react_' . $post['i_reaction'], 'post', $post_id);
      /* points balance */
      $this->points_balance("delete", $post['author_id'], "post_reaction");
      $this->points_balance("delete", $this->_data['user_id'], "posts_reactions");
    }
    $db->query(sprintf("INSERT INTO posts_reactions (user_id, post_id, reaction, reaction_time) VALUES (%s, %s, %s, %s)", secure($this->_data['user_id'], 'int'), secure($post_id, 'int'), secure($reaction), secure($date)));
    $reaction_id = $db->insert_id;
    /* update post reaction counter */
    $reaction_field = "reaction_" . $reaction . "_count";
    $db->query(sprintf("UPDATE posts SET $reaction_field = $reaction_field + 1 WHERE post_id = %s", secure($post_id, 'int')));
    /* post notification */
    $this->post_notification(['to_user_id' => $post['author_id'], 'action' => 'react_' . $reaction, 'node_type' => 'post', 'node_url' => $post_id]);
    /* points balance */
    $this->points_balance("add", $post['author_id'], "post_reaction", $reaction_id);
    $this->points_balance("add", $this->_data['user_id'], "posts_reactions", $reaction_id);
    /* return */
    return $this->_check_post($post_id);
  }


  /**
   * unreact_post
   * 
   * @param integer $post_id
   * @param string $reaction
   * @return array|false
   */
  public function unreact_post($post_id, $reaction)
  {
    global $db;
    /* check reation */
    if (!in_array($reaction, ['like', 'love', 'haha', 'yay', 'wow', 'sad', 'angry'])) {
      _error(403);
    }
    /* (check|get) post */
    $post = $this->_check_post($post_id);
    if (!$post) {
      _error(403);
    }
    /* check blocking */
    if ($post['user_type'] == "user" && $this->blocked($post['author_id'])) {
      _error(403);
    }
    /* unreact the post */
    if ($post['i_react']) {
      /* remove the reaction */
      $db->query(sprintf("DELETE FROM posts_reactions WHERE user_id = %s AND post_id = %s", secure($this->_data['user_id'], 'int'), secure($post_id, 'int')));
      /* update post reaction counter */
      $reaction_field = "reaction_" . $reaction . "_count";
      $db->query(sprintf("UPDATE posts SET $reaction_field = IF($reaction_field=0,0,$reaction_field-1) WHERE post_id = %s", secure($post_id, 'int')));
      /* delete notification */
      $this->delete_notification($post['author_id'], 'react_' . $reaction, 'post', $post_id);
      /* points balance */
      $this->points_balance("delete", $post['author_id'], "post_reaction");
      $this->points_balance("delete", $this->_data['user_id'], "posts_reactions");
      /* get post */
      $post = $this->_check_post($post_id);
    }
    /* return */
    return $post;
  }


  /**
   * hide_post
   * 
   * @param integer $post_id
   * @return void
   */
  public function hide_post($post_id)
  {
    global $db;
    /* (check|get) post */
    $post = $this->_check_post($post_id);
    if (!$post) {
      _error(403);
    }
    /* check blocking */
    if ($post['user_type'] == "user" && $this->blocked($post['author_id'])) {
      _error(403);
    }
    /* hide the post */
    $db->query(sprintf("INSERT INTO posts_hidden (user_id, post_id) VALUES (%s, %s)", secure($this->_data['user_id'], 'int'), secure($post_id, 'int')));
  }


  /**
   * unhide_post
   * 
   * @param integer $post_id
   * @return void
   */
  public function unhide_post($post_id)
  {
    global $db;
    /* (check|get) post */
    $post = $this->_check_post($post_id);
    if (!$post) {
      _error(403);
    }
    /* unhide the post */
    $db->query(sprintf("DELETE FROM posts_hidden WHERE user_id = %s AND post_id = %s", secure($this->_data['user_id'], 'int'), secure($post_id, 'int')));
  }


  /**
   * add_vote
   * 
   * @param integer $option_id
   * @return void
   */
  public function add_vote($option_id)
  {
    global $db;
    $poll_post = $db->query(sprintf("SELECT posts_polls.post_id FROM posts_polls_options INNER JOIN posts_polls ON posts_polls_options.poll_id = posts_polls.poll_id WHERE option_id = %s", secure($option_id, 'int')))->fetch_assoc();
    if (!$poll_post) throw new ValidationException(__("This poll has changed. Please reload the post"));
    $db->begin_transaction();
    try {
      $db->query(sprintf("SELECT post_id FROM posts WHERE post_id = %s FOR UPDATE", secure($poll_post['post_id'], 'int')));
      /* get poll */
      $get_poll = $db->query(sprintf("SELECT posts_polls.* FROM posts_polls_options INNER JOIN posts_polls ON posts_polls_options.poll_id = posts_polls.poll_id WHERE option_id = %s", secure($option_id, 'int')));
      if ($get_poll->num_rows == 0) {
        throw new ValidationException(__("This poll is unavailable"));
      }
      $poll = $get_poll->fetch_assoc();
      /* (check|get) post */
      $post = $this->_check_post($poll['post_id']);
      if (!$post) {
        throw new ValidationException(__("This poll is unavailable"));
      }
      /* check blocking */
      if ($post['user_type'] == "user" && $this->blocked($post['author_id'])) {
        throw new ValidationException(__("This poll is unavailable"));
      }
      /* insert user vote */
      $vote = $db->query(sprintf("INSERT INTO posts_polls_options_users (user_id, poll_id, option_id) VALUES (%s, %s, %s)", secure($this->_data['user_id'], 'int'), secure($poll['poll_id'], 'int'), secure($option_id, 'int')));
      if ($vote) {
        /* update poll votes */
        $db->query(sprintf("UPDATE posts_polls SET edit_locked = 1, votes = votes + 1 WHERE poll_id = %s", secure($poll['poll_id'], 'int')));
        /* post notification */
        $this->post_notification(['to_user_id' => $post['author_id'], 'action' => 'vote', 'node_type' => 'post', 'node_url' => $post['post_id']]);
      }

      $db->commit();
    } catch (Throwable $e) {
      $db->rollback();
      throw $e;
    }
  }


  /**
   * delete_vote
   * 
   * @param integer $option_id
   * @return void
   */
  public function delete_vote($option_id)
  {
    global $db;
    $poll_post = $db->query(sprintf("SELECT posts_polls.post_id FROM posts_polls_options INNER JOIN posts_polls ON posts_polls_options.poll_id = posts_polls.poll_id WHERE option_id = %s", secure($option_id, 'int')))->fetch_assoc();
    if (!$poll_post) throw new ValidationException(__("This poll has changed. Please reload the post"));
    $db->begin_transaction();
    try {
      $db->query(sprintf("SELECT post_id FROM posts WHERE post_id = %s FOR UPDATE", secure($poll_post['post_id'], 'int')));
      /* get poll */
      $get_poll = $db->query(sprintf("SELECT posts_polls.* FROM posts_polls_options INNER JOIN posts_polls ON posts_polls_options.poll_id = posts_polls.poll_id WHERE option_id = %s", secure($option_id, 'int')));
      if ($get_poll->num_rows == 0) {
        throw new ValidationException(__("This poll is unavailable"));
      }
      $poll = $get_poll->fetch_assoc();
      /* (check|get) post */
      $post = $this->_check_post($poll['post_id']);
      if (!$post) {
        throw new ValidationException(__("This poll is unavailable"));
      }
      /* check blocking */
      if ($post['user_type'] == "user" && $this->blocked($post['author_id'])) {
        throw new ValidationException(__("This poll is unavailable"));
      }
      /* delete user vote */
      $db->query(sprintf("DELETE FROM posts_polls_options_users WHERE user_id = %s AND poll_id = %s AND option_id = %s", secure($this->_data['user_id'], 'int'), secure($poll['poll_id'], 'int'), secure($option_id, 'int')));
      if ($db->affected_rows > 0) {
        /* update poll votes */
        $db->query(sprintf("UPDATE posts_polls SET votes = IF(votes=0,0,votes-1) WHERE poll_id = %s", secure($poll['poll_id'], 'int')));
        /* delete notification */
        $this->delete_notification($post['author_id'], 'vote', 'post', $post['post_id']);
      }

      $db->commit();
    } catch (Throwable $e) {
      $db->rollback();
      throw $e;
    }
  }


  /**
   * change_vote
   * 
   * @param integer $option_id
   * @param integer $checked_id
   * @return void
   */
  public function change_vote($option_id, $checked_id)
  {
    global $db;
    $poll_post = $db->query(sprintf("SELECT posts_polls.post_id FROM posts_polls_options INNER JOIN posts_polls ON posts_polls_options.poll_id = posts_polls.poll_id WHERE option_id = %s", secure($option_id, 'int')))->fetch_assoc();
    if (!$poll_post) throw new ValidationException(__("This poll has changed. Please reload the post"));
    $db->begin_transaction();
    try {
      $db->query(sprintf("SELECT post_id FROM posts WHERE post_id = %s FOR UPDATE", secure($poll_post['post_id'], 'int')));
      /* get poll */
      $get_poll = $db->query(sprintf("SELECT posts_polls.* FROM posts_polls_options INNER JOIN posts_polls ON posts_polls_options.poll_id = posts_polls.poll_id WHERE option_id = %s", secure($option_id, 'int')));
      if ($get_poll->num_rows == 0) {
        throw new ValidationException(__("This poll is unavailable"));
      }
      $poll = $get_poll->fetch_assoc();
      /* (check|get) post */
      $post = $this->_check_post($poll['post_id']);
      if (!$post) {
        throw new ValidationException(__("This poll is unavailable"));
      }
      /* check blocking */
      if ($post['user_type'] == "user" && $this->blocked($post['author_id'])) {
        throw new ValidationException(__("This poll is unavailable"));
      }
      /* delete old vote */
      $db->query(sprintf("DELETE FROM posts_polls_options_users WHERE user_id = %s AND poll_id = %s AND option_id = %s", secure($this->_data['user_id'], 'int'), secure($poll['poll_id'], 'int'), secure($checked_id, 'int')));
      if ($db->affected_rows > 0) {
        /* insert new vote */
        $db->query(sprintf("INSERT INTO posts_polls_options_users (user_id, poll_id, option_id) VALUES (%s, %s, %s)", secure($this->_data['user_id'], 'int'), secure($poll['poll_id'], 'int'), secure($option_id, 'int')));
      }

      $db->commit();
    } catch (Throwable $e) {
      $db->rollback();
      throw $e;
    }
  }


  /**
   * update_media_views
   * 
   * @param string $media_type
   * @param integer $video_id
   * @return void
   */
  public function update_media_views($media_type, $media_id)
  {
    global $db;
    switch ($media_type) {
      case 'reel':
        $db->query(sprintf("UPDATE posts_reels SET views = views + 1 WHERE reel_id = %s", secure($media_id, 'int')));
        break;

      case 'video':
        $db->query(sprintf("UPDATE posts_videos SET views = views + 1 WHERE video_id = %s", secure($media_id, 'int')));
        break;

      case 'audio':
        $db->query(sprintf("UPDATE posts_audios SET views = views + 1 WHERE audio_id = %s", secure($media_id, 'int')));
        break;
    }
  }
}
