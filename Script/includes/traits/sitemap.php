<?php

/**
 * trait -> sitemap
 *
 * @package Sngine
 * @author Zamblek
 */

trait SitemapTrait
{

  /* ------------------------------- */
  /* Sitemap */
  /* ------------------------------- */

  /**
   * sitemap_types
   *
   * @return array
   */
  public function sitemap_types()
  {
    global $system;
    static $types = null;
    if ($types !== null) {
      return $types;
    }
    $url = $system['system_url'];
    /* posts gate */
    $posts_joins = " LEFT JOIN users AS post_user ON posts.user_type = 'user' AND posts.user_id = post_user.user_id LEFT JOIN pages AS post_page ON posts.user_type = 'page' AND posts.user_id = post_page.page_id LEFT JOIN `groups` AS post_group ON posts.in_group = '1' AND posts.group_id = post_group.group_id LEFT JOIN `events` AS post_event ON posts.in_event = '1' AND posts.event_id = post_event.event_id";
    $posts_gate = " AND posts.is_hidden = '0' AND posts.processing != '1' AND posts.is_paid = '0' AND posts.for_subscriptions = '0' AND posts.time <= NOW()";
    $posts_gate .= " AND ((posts.privacy = 'public' AND posts.in_group = '0' AND posts.in_event = '0') OR (posts.in_group = '1' AND posts.group_approved = '1' AND post_group.group_privacy = 'public') OR (posts.in_event = '1' AND posts.event_approved = '1' AND post_event.event_privacy = 'public'))";
    $posts_gate .= " AND ((posts.user_type = 'user' AND post_user.user_banned = '0') OR (posts.user_type = 'page' AND post_page.page_id IS NOT NULL))";
    if ($system['posts_approval_enabled']) {
      $posts_gate .= " AND (posts.pre_approved = '1' OR posts.has_approved = '1')";
    }
    if ($system['adult_mode']) {
      $posts_gate .= " AND posts.for_adult = '0'";
    }
    $post_loc = function ($row) use ($url) {
      return $url . '/posts/' . $row['post_id'];
    };
    /* posts modules */
    $module = function ($title, $enabled, $table, $key, $post_type, $select, $loc, $where = "", $photos = false) use ($posts_joins, $posts_gate) {
      return [
        'title' => $title,
        'enabled' => $enabled,
        'table' => $table,
        'key' => $key,
        'select' => "item." . $key . " AS id, posts.post_id, posts.time AS lastmod" . $select,
        'from' => $table . " AS item INNER JOIN posts ON item.post_id = posts.post_id AND posts.post_type = '" . $post_type . "'" . $posts_joins,
        'range' => "item." . $key,
        'where' => $where . $posts_gate,
        'loc' => $loc,
        'photos' => $photos,
      ];
    };
    $types = [
      'site' => [
        'title' => __("Main Pages"),
        'enabled' => true,
      ],
      'posts' => [
        'title' => __("Posts"),
        'enabled' => true,
        'table' => "posts",
        'key' => "post_id",
        'select' => "posts.post_id AS id, posts.post_id, posts.time AS lastmod, LEFT(posts.text, 300) AS text, posts_videos.source AS video, posts_videos.thumbnail AS video_thumbnail",
        'from' => "posts LEFT JOIN posts_videos ON posts.post_type = 'video' AND posts.post_id = posts_videos.post_id" . $posts_joins,
        'range' => "posts.post_id",
        'where' => " AND posts.post_type NOT IN ('article', 'product', 'job', 'offer', 'course', 'funding', 'reel', 'shared', 'profile_picture', 'profile_cover', 'page_picture', 'page_cover', 'group_picture', 'group_cover', 'event_cover')" . $posts_gate,
        'loc' => $post_loc,
        'photos' => true,
      ],
      'blogs' => $module(__("Blogs"), $system['blogs_enabled'], "posts_articles", "article_id", "article", ", item.title, item.cover AS image", function ($row) use ($url) {
        return $url . '/blogs/' . $row['post_id'] . '/' . get_url_text($row['title']);
      }),
      'products' => $module(__("Products"), $system['market_enabled'], "posts_products", "product_id", "product", "", $post_loc, " AND item.available = '1'", true),
      'jobs' => $module(__("Jobs"), $system['jobs_enabled'], "posts_jobs", "job_id", "job", ", item.cover_image AS image", $post_loc, " AND item.available = '1'"),
      'offers' => $module(__("Offers"), $system['offers_enabled'], "posts_offers", "offer_id", "offer", ", item.thumbnail AS image", $post_loc),
      'courses' => $module(__("Courses"), $system['courses_enabled'], "posts_courses", "course_id", "course", ", item.cover_image AS image", $post_loc, " AND item.available = '1'"),
      'funding' => $module(__("Funding"), $system['funding_enabled'], "posts_funding", "funding_id", "funding", ", item.cover_image AS image", $post_loc),
      'reels' => $module(__("Reels"), $system['reels_enabled'], "posts_reels", "reel_id", "reel", ", LEFT(posts.text, 300) AS text, item.source AS video, item.thumbnail AS video_thumbnail", function ($row) use ($url) {
        return $url . '/reels/' . $row['post_id'];
      }),
      'users' => [
        'title' => __("Users"),
        'enabled' => true,
        'table' => "users",
        'key' => "user_id",
        'select' => "user_id AS id, user_name, user_picture AS image",
        'from' => "users",
        'range' => "user_id",
        'where' => " AND user_banned = '0'" . (($system['users_approval_enabled']) ? " AND user_approved = '1'" : ""),
        'loc' => function ($row) use ($url) {
          return $url . '/' . $row['user_name'];
        },
      ],
      'pages' => [
        'title' => __("Pages"),
        'enabled' => $system['pages_enabled'],
        'table' => "pages",
        'key' => "page_id",
        'select' => "page_id AS id, page_name, page_picture AS image",
        'from' => "pages",
        'range' => "page_id",
        'where' => "",
        'loc' => function ($row) use ($url) {
          return $url . '/pages/' . $row['page_name'];
        },
      ],
      'groups' => [
        'title' => __("Groups"),
        'enabled' => $system['groups_enabled'],
        'table' => "`groups`",
        'key' => "group_id",
        'select' => "group_id AS id, group_name, group_picture AS image",
        'from' => "`groups`",
        'range' => "group_id",
        'where' => " AND group_privacy = 'public'",
        'loc' => function ($row) use ($url) {
          return $url . '/groups/' . $row['group_name'];
        },
      ],
      'events' => [
        'title' => __("Events"),
        'enabled' => $system['events_enabled'],
        'table' => "`events`",
        'key' => "event_id",
        'select' => "event_id AS id, event_cover AS image",
        'from' => "`events`",
        'range' => "event_id",
        'where' => " AND event_privacy = 'public'",
        'loc' => function ($row) use ($url) {
          return $url . '/events/' . $row['id'];
        },
      ],
      'forums' => [
        'title' => __("Forum Threads"),
        'enabled' => $system['forums_enabled'],
        'table' => "forums_threads",
        'key' => "thread_id",
        'select' => "thread_id AS id, title, IFNULL(last_reply, time) AS lastmod",
        'from' => "forums_threads",
        'range' => "thread_id",
        'where' => "",
        'loc' => function ($row) use ($url) {
          return $url . '/forums/thread/' . $row['id'] . '/' . get_url_text($row['title']);
        },
      ],
      'movies' => [
        'title' => __("Movies"),
        'enabled' => $system['movies_enabled'],
        'table' => "movies",
        'key' => "movie_id",
        'select' => "movie_id AS id, title, poster AS image",
        'from' => "movies",
        'range' => "movie_id",
        'where' => "",
        'loc' => function ($row) use ($url) {
          return $url . '/movie/' . $row['id'] . '/' . get_url_text($row['title']);
        },
      ],
      'games' => [
        'title' => __("Games"),
        'enabled' => $system['games_enabled'],
        'table' => "games",
        'key' => "game_id",
        'select' => "game_id AS id, title, thumbnail AS image",
        'from' => "games",
        'range' => "game_id",
        'where' => "",
        'loc' => function ($row) use ($url) {
          return $url . '/games/' . $row['id'] . '/' . get_url_text($row['title']);
        },
      ],
    ];
    return $types;
  }


  /**
   * sitemap_enabled_types
   *
   * @return array
   */
  public function sitemap_enabled_types()
  {
    global $system;
    $selected = explode(',', (string) $system['sitemap_types']);
    $enabled = [];
    foreach ($this->sitemap_types() as $type => $definition) {
      if ($definition['enabled'] && in_array($type, $selected)) {
        $enabled[] = $type;
      }
    }
    return $enabled;
  }


  /**
   * sitemap_size
   *
   * @return integer
   */
  public function sitemap_size()
  {
    global $system;
    return min(50000, max(1000, (int) $system['sitemap_urls_per_file']));
  }


  /**
   * sitemap_parts
   *
   * @param string $type
   * @return integer
   */
  public function sitemap_parts($type)
  {
    global $db;
    if ($type == 'site') {
      return 1;
    }
    $definition = $this->sitemap_types()[$type];
    $get_max_id = $db->query("SELECT IFNULL(MAX(" . $definition['key'] . "), 0) FROM " . $definition['table']);
    return (int) ceil((int) $get_max_id->fetch_row()[0] / $this->sitemap_size());
  }


  /**
   * sitemap_file
   *
   * @param string $type
   * @param integer $part
   * @return string
   */
  public function sitemap_file($type, $part)
  {
    return ABSPATH . 'content/cache/sitemaps/' . $type . '-' . (int) $part . '.xml';
  }


  /**
   * sitemap_build
   *
   * @param string $type
   * @param integer $part
   * @param boolean $notify
   * @return integer
   */
  public function sitemap_build($type, $part, $notify = false)
  {
    global $db, $system, $date;
    $part = (int) $part;
    $entries = ($type == 'site') ? $this->_sitemap_site_entries() : $this->_sitemap_entries($type, $part);
    /* build xml */
    $escape = function ($value) {
      return htmlspecialchars((string) $value, ENT_XML1 | ENT_QUOTES, 'UTF-8');
    };
    $media = function ($source) use ($system) {
      return (preg_match('/^https?:\/\//i', $source)) ? $source : $system['system_uploads'] . '/' . $source;
    };
    $text = function ($value, $length) use ($system) {
      $value = trim(preg_replace('/\s+/u', ' ', strip_tags(html_entity_decode((string) $value, ENT_QUOTES, 'UTF-8'))));
      return ($value === '') ? html_entity_decode((string) $system['system_title'], ENT_QUOTES, 'UTF-8') : mb_substr($value, 0, $length);
    };
    $xml = '<?xml version="1.0" encoding="UTF-8"?>' . "\n";
    $xml .= '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9" xmlns:image="http://www.google.com/schemas/sitemap-image/1.1" xmlns:video="http://www.google.com/schemas/sitemap-video/1.1">' . "\n";
    $last_id = 0;
    $last_modified = null;
    foreach ($entries as $entry) {
      $xml .= "  <url>\n";
      $xml .= "    <loc>" . $escape($entry['loc']) . "</loc>\n";
      if (!empty($entry['lastmod'])) {
        $xml .= "    <lastmod>" . date('c', strtotime($entry['lastmod'])) . "</lastmod>\n";
        if ($last_modified === null || $entry['lastmod'] > $last_modified) {
          $last_modified = $entry['lastmod'];
        }
      }
      if ($system['sitemap_images_enabled']) {
        foreach ($entry['images'] as $image) {
          $xml .= "    <image:image><image:loc>" . $escape($media($image)) . "</image:loc></image:image>\n";
        }
      }
      if ($system['sitemap_videos_enabled'] && !empty($entry['video']) && !empty($entry['video_thumbnail'])) {
        $xml .= "    <video:video>\n";
        $xml .= "      <video:thumbnail_loc>" . $escape($media($entry['video_thumbnail'])) . "</video:thumbnail_loc>\n";
        $xml .= "      <video:title>" . $escape($text($entry['text'], 100)) . "</video:title>\n";
        $xml .= "      <video:description>" . $escape($text($entry['text'], 300)) . "</video:description>\n";
        $xml .= "      <video:content_loc>" . $escape($media($entry['video'])) . "</video:content_loc>\n";
        if (!empty($entry['lastmod'])) {
          $xml .= "      <video:publication_date>" . date('c', strtotime($entry['lastmod'])) . "</video:publication_date>\n";
        }
        $xml .= "    </video:video>\n";
      }
      $xml .= "  </url>\n";
      $last_id = max($last_id, $entry['id']);
    }
    $xml .= "</urlset>";
    /* write file */
    $file = $this->sitemap_file($type, $part);
    if (!is_dir(dirname($file))) {
      @mkdir(dirname($file), 0755, true);
    }
    $temp_file = $file . '.' . uniqid('', true) . '.tmp';
    if (@file_put_contents($temp_file, $xml) !== false) {
      @rename($temp_file, $file);
    }
    /* notify search engines */
    $get_sitemap = $db->query(sprintf("SELECT notified_id FROM sitemaps WHERE sitemap_type = %s AND sitemap_part = %s", secure($type), secure($part, 'int')));
    $notified_id = ($get_sitemap->num_rows > 0) ? (int) $get_sitemap->fetch_assoc()['notified_id'] : (($notify) ? 0 : $last_id);
    if ($type == 'site' || !$system['indexnow_enabled'] || is_empty($system['indexnow_key'])) {
      $notified_id = $last_id;
    } elseif ($last_id > $notified_id) {
      $urls = [];
      foreach ($entries as $entry) {
        if ($entry['id'] > $notified_id) {
          $urls[] = $entry['loc'];
        }
      }
      if ($this->_indexnow_request($urls)) {
        $notified_id = $last_id;
      }
    }
    /* save */
    $db->query(sprintf(
      "INSERT INTO sitemaps (sitemap_type, sitemap_part, urls, last_id, notified_id, last_modified, generated_at) VALUES (%1\$s, %2\$s, %3\$s, %4\$s, %5\$s, %6\$s, %7\$s) ON DUPLICATE KEY UPDATE urls = VALUES(urls), last_id = VALUES(last_id), notified_id = VALUES(notified_id), last_modified = VALUES(last_modified), generated_at = VALUES(generated_at)",
      secure($type),
      secure($part, 'int'),
      secure(count($entries), 'int'),
      secure($last_id, 'int'),
      secure($notified_id, 'int'),
      ($last_modified === null) ? "NULL" : secure($last_modified),
      secure($date)
    ));
    return count($entries);
  }


  /**
   * _sitemap_entries
   *
   * @param string $type
   * @param integer $part
   * @return array
   */
  private function _sitemap_entries($type, $part)
  {
    global $db;
    $definition = $this->sitemap_types()[$type];
    $size = $this->sitemap_size();
    $entries = [];
    $get_rows = $db->query(sprintf("SELECT " . $definition['select'] . " FROM " . $definition['from'] . " WHERE " . $definition['range'] . " > %s AND " . $definition['range'] . " <= %s" . $definition['where'] . " ORDER BY " . $definition['range'] . " ASC", secure(($part - 1) * $size, 'int'), secure($part * $size, 'int')));
    while ($row = $get_rows->fetch_assoc()) {
      if (isset($entries[$row['id']])) {
        continue;
      }
      $entries[$row['id']] = [
        'id' => (int) $row['id'],
        'loc' => $definition['loc']($row),
        'lastmod' => $row['lastmod'] ?? null,
        'images' => (!empty($row['image'])) ? [$row['image']] : [],
        'video' => $row['video'] ?? null,
        'video_thumbnail' => $row['video_thumbnail'] ?? null,
        'text' => $row['text'] ?? null,
        'post_id' => $row['post_id'] ?? null,
      ];
    }
    /* photos */
    if (!empty($definition['photos']) && $entries) {
      $posts = array_column($entries, 'id', 'post_id');
      foreach (array_chunk(array_keys($posts), 1000) as $posts_ids) {
        $get_photos = $db->query("SELECT post_id, source FROM posts_photos WHERE post_id IN (" . implode(',', array_map('intval', $posts_ids)) . ") ORDER BY photo_id ASC");
        while ($photo = $get_photos->fetch_assoc()) {
          $id = $posts[$photo['post_id']];
          if (count($entries[$id]['images']) < 10) {
            $entries[$id]['images'][] = $photo['source'];
          }
        }
      }
    }
    return array_values($entries);
  }


  /**
   * _sitemap_site_entries
   *
   * @return array
   */
  private function _sitemap_site_entries()
  {
    global $db, $system;
    $locs = [$system['system_url'] . '/'];
    foreach ($this->_sitemap_hubs() as $hub) {
      $locs[] = $hub['url'];
    }
    $get_static_pages = $db->query("SELECT page_url FROM static_pages WHERE page_is_redirect = '0' ORDER BY page_order ASC");
    while ($static_page = $get_static_pages->fetch_assoc()) {
      $locs[] = $system['system_url'] . '/static/' . $static_page['page_url'];
    }
    if ($system['forums_enabled']) {
      $get_forums = $db->query("SELECT forum_id, forum_name FROM forums ORDER BY forum_order ASC");
      while ($forum = $get_forums->fetch_assoc()) {
        $locs[] = $system['system_url'] . '/forums/' . $forum['forum_id'] . '/' . get_url_text($forum['forum_name']);
      }
    }
    $entries = [];
    foreach ($locs as $index => $loc) {
      $entries[] = ['id' => $index + 1, 'loc' => $loc, 'lastmod' => null, 'images' => []];
    }
    return $entries;
  }


  /**
   * _sitemap_hubs
   *
   * @return array
   */
  private function _sitemap_hubs()
  {
    global $system;
    $modules = [
      'blogs' => ['blogs_enabled', __("Blogs")],
      'market' => ['market_enabled', __("Market")],
      'forums' => ['forums_enabled', __("Forums")],
      'jobs' => ['jobs_enabled', __("Jobs")],
      'offers' => ['offers_enabled', __("Offers")],
      'courses' => ['courses_enabled', __("Courses")],
      'funding' => ['funding_enabled', __("Funding")],
      'movies' => ['movies_enabled', __("Movies")],
      'games' => ['games_enabled', __("Games")],
      'pages' => ['pages_enabled', __("Pages")],
      'groups' => ['groups_enabled', __("Groups")],
      'events' => ['events_enabled', __("Events")],
      'reels' => ['reels_enabled', __("Reels")],
      'live' => ['live_enabled', __("Live")],
      'directory' => ['directory_enabled', __("Directory")],
    ];
    $hubs = [];
    foreach ($modules as $path => $module) {
      if ($system[$module[0]]) {
        $hubs[] = ['url' => $system['system_url'] . '/' . $path, 'title' => $module[1]];
      }
    }
    return $hubs;
  }


  /**
   * sitemap_refresh
   *
   * @param integer $deadline
   * @return integer
   */
  public function sitemap_refresh($deadline = 0)
  {
    global $db, $system;
    $built = 0;
    $started = date('Y-m-d H:i:s');
    $stale = date('Y-m-d H:i:s', time() - max(1, (int) $system['sitemap_refresh']) * 60);
    $types = $this->sitemap_enabled_types();
    foreach ($types as $type) {
      $parts = $this->sitemap_parts($type);
      $sitemaps = [];
      $get_sitemaps = $db->query(sprintf("SELECT sitemap_part, generated_at FROM sitemaps WHERE sitemap_type = %s", secure($type)));
      while ($sitemap = $get_sitemaps->fetch_assoc()) {
        $sitemaps[$sitemap['sitemap_part']] = $sitemap['generated_at'];
      }
      /* remove extra parts */
      foreach ($sitemaps as $part => $generated_at) {
        if ($part > $parts) {
          $db->query(sprintf("DELETE FROM sitemaps WHERE sitemap_type = %s AND sitemap_part = %s", secure($type), secure($part, 'int')));
          @unlink($this->sitemap_file($type, $part));
        }
      }
      /* build new & latest parts */
      for ($part = 1; $part <= $parts; $part++) {
        if ($deadline && time() >= $deadline) {
          return $built;
        }
        if (!$deadline || !isset($sitemaps[$part]) || ($part == $parts && $sitemaps[$part] < $stale)) {
          $this->sitemap_build($type, $part, !empty($sitemaps));
          $built++;
        }
      }
    }
    /* rebuild oldest parts */
    if ($deadline && $types) {
      $types_list = implode(',', array_map('secure', $types));
      while (time() < $deadline) {
        $get_sitemap = $db->query(sprintf("SELECT sitemap_type, sitemap_part FROM sitemaps WHERE sitemap_type IN (%s) AND generated_at < %s AND generated_at < %s ORDER BY generated_at ASC LIMIT 1", $types_list, secure(date('Y-m-d H:i:s', time() - 86400)), secure($started)));
        if ($get_sitemap->num_rows == 0) {
          break;
        }
        $sitemap = $get_sitemap->fetch_assoc();
        $this->sitemap_build($sitemap['sitemap_type'], $sitemap['sitemap_part']);
        $built++;
      }
    }
    return $built;
  }


  /**
   * sitemap_reset
   *
   * @return void
   */
  public function sitemap_reset()
  {
    global $db;
    $db->query("TRUNCATE TABLE sitemaps");
    foreach ((array) glob(ABSPATH . 'content/cache/sitemaps/*.xml') as $file) {
      @unlink($file);
    }
  }


  /**
   * get_sitemap_index
   *
   * @return string
   */
  public function get_sitemap_index()
  {
    global $db, $system;
    $types = $this->sitemap_enabled_types();
    $xml = '<?xml version="1.0" encoding="UTF-8"?>' . "\n";
    $xml .= '<sitemapindex xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">' . "\n";
    if ($types) {
      $types_list = implode(',', array_map('secure', $types));
      $get_count = $db->query("SELECT COUNT(*) FROM sitemaps WHERE sitemap_type IN (" . $types_list . ")");
      if ((int) $get_count->fetch_row()[0] == 0) {
        $this->sitemap_refresh(time() + 10);
      }
      $get_sitemaps = $db->query("SELECT sitemap_type, sitemap_part, generated_at FROM sitemaps WHERE sitemap_type IN (" . $types_list . ") AND urls > 0 ORDER BY FIELD(sitemap_type, " . $types_list . "), sitemap_part ASC");
      while ($sitemap = $get_sitemaps->fetch_assoc()) {
        $xml .= "  <sitemap>\n";
        $xml .= "    <loc>" . $system['system_url'] . "/sitemap-" . $sitemap['sitemap_type'] . "-" . $sitemap['sitemap_part'] . ".xml</loc>\n";
        $xml .= "    <lastmod>" . date('c', strtotime($sitemap['generated_at'])) . "</lastmod>\n";
        $xml .= "  </sitemap>\n";
      }
    }
    $xml .= "</sitemapindex>";
    return $xml;
  }


  /**
   * get_sitemap
   *
   * @param string $type
   * @param integer $part
   * @return string|false
   */
  public function get_sitemap($type, $part)
  {
    global $db, $system;
    $part = (int) $part;
    if (!in_array($type, $this->sitemap_enabled_types(), true) || $part < 1) {
      return false;
    }
    $parts = $this->sitemap_parts($type);
    if ($part > $parts) {
      return false;
    }
    $file = $this->sitemap_file($type, $part);
    $get_sitemap = $db->query(sprintf("SELECT generated_at FROM sitemaps WHERE sitemap_type = %s AND sitemap_part = %s", secure($type), secure($part, 'int')));
    $generated_at = ($get_sitemap->num_rows > 0) ? $get_sitemap->fetch_assoc()['generated_at'] : null;
    $stale = date('Y-m-d H:i:s', time() - max(1, (int) $system['sitemap_refresh']) * 60);
    if (!$generated_at || !is_file($file) || ($part == $parts && $generated_at < $stale)) {
      $this->sitemap_build($type, $part);
    }
    return (is_file($file)) ? file_get_contents($file) : false;
  }


  /**
   * get_sitemap_stats
   *
   * @return array
   */
  public function get_sitemap_stats()
  {
    global $db, $system;
    $selected = explode(',', (string) $system['sitemap_types']);
    $stats = ['urls' => 0, 'files' => 0, 'size' => 0, 'generated_at' => null, 'types' => []];
    foreach ((array) glob(ABSPATH . 'content/cache/sitemaps/*.xml') as $file) {
      $stats['size'] += (int) @filesize($file);
    }
    foreach ($this->sitemap_types() as $type => $definition) {
      $stats['types'][$type] = ['title' => $definition['title'], 'available' => (bool) $definition['enabled'], 'enabled' => in_array($type, $selected), 'urls' => 0, 'files' => 0, 'generated_at' => null];
    }
    $get_sitemaps = $db->query("SELECT sitemap_type, SUM(urls) AS urls, SUM(urls > 0) AS files, MAX(generated_at) AS generated_at FROM sitemaps GROUP BY sitemap_type");
    while ($sitemap = $get_sitemaps->fetch_assoc()) {
      $type = $sitemap['sitemap_type'];
      if (!isset($stats['types'][$type]) || !$stats['types'][$type]['available'] || !$stats['types'][$type]['enabled']) {
        continue;
      }
      $stats['types'][$type]['urls'] = (int) $sitemap['urls'];
      $stats['types'][$type]['files'] = (int) $sitemap['files'];
      $stats['types'][$type]['generated_at'] = $sitemap['generated_at'];
      $stats['urls'] += (int) $sitemap['urls'];
      $stats['files'] += (int) $sitemap['files'];
      if ($stats['generated_at'] === null || $sitemap['generated_at'] > $stats['generated_at']) {
        $stats['generated_at'] = $sitemap['generated_at'];
      }
    }
    return $stats;
  }



  /* ------------------------------- */
  /* IndexNow */
  /* ------------------------------- */

  /**
   * _indexnow_request
   *
   * @param array $urls
   * @return boolean
   */
  private function _indexnow_request($urls)
  {
    global $system;
    if (!$urls) {
      return true;
    }
    $ch = curl_init('https://api.indexnow.org/indexnow');
    curl_setopt_array($ch, [
      CURLOPT_POST => true,
      CURLOPT_RETURNTRANSFER => true,
      CURLOPT_CONNECTTIMEOUT => 5,
      CURLOPT_TIMEOUT => 15,
      CURLOPT_HTTPHEADER => ['Content-Type: application/json; charset=utf-8'],
      CURLOPT_POSTFIELDS => json_encode([
        'host' => parse_url($system['system_url'], PHP_URL_HOST),
        'key' => $system['indexnow_key'],
        'keyLocation' => $system['system_url'] . '/' . $system['indexnow_key'] . '.txt',
        'urlList' => array_slice($urls, 0, 10000),
      ]),
    ]);
    curl_exec($ch);
    $status = (int) curl_getinfo($ch, CURLINFO_HTTP_CODE);
    return $status == 200 || $status == 202;
  }



  /* ------------------------------- */
  /* Robots & LLMs */
  /* ------------------------------- */

  /**
   * get_robots_txt
   *
   * @return string
   */
  public function get_robots_txt()
  {
    global $system;
    $robots = trim(html_entity_decode((string) $system['robots_txt'], ENT_QUOTES, 'UTF-8'));
    if ($system['sitemap_enabled'] && $system['system_public']) {
      $robots .= "\n\nSitemap: " . $system['system_url'] . "/sitemap.xml";
    }
    return trim($robots) . "\n";
  }


  /**
   * get_llms_txt
   *
   * @return string
   */
  public function get_llms_txt()
  {
    global $db, $system;
    $decode = function ($value) {
      return trim(html_entity_decode((string) $value, ENT_QUOTES, 'UTF-8'));
    };
    $llms = "# " . $decode($system['system_title']) . "\n";
    if (!is_empty($system['system_description'])) {
      $llms .= "\n> " . $decode($system['system_description']) . "\n";
    }
    $llms .= "\n## " . __("Sections") . "\n\n";
    $llms .= "- [" . __("Home") . "](" . $system['system_url'] . "/)\n";
    foreach ($this->_sitemap_hubs() as $hub) {
      $llms .= "- [" . $hub['title'] . "](" . $hub['url'] . ")\n";
    }
    $get_static_pages = $db->query("SELECT page_url, page_title FROM static_pages WHERE page_is_redirect = '0' ORDER BY page_order ASC");
    if ($get_static_pages->num_rows > 0) {
      $llms .= "\n## " . __("Pages") . "\n\n";
      while ($static_page = $get_static_pages->fetch_assoc()) {
        $llms .= "- [" . $decode($static_page['page_title']) . "](" . $system['system_url'] . "/static/" . $static_page['page_url'] . ")\n";
      }
    }
    if ($system['sitemap_enabled']) {
      $llms .= "\n## " . __("Sitemap") . "\n\n";
      $llms .= "- [sitemap.xml](" . $system['system_url'] . "/sitemap.xml)\n";
    }
    if (!is_empty($system['llms_notes'])) {
      $llms .= "\n## " . __("Notes") . "\n\n" . $decode($system['llms_notes']) . "\n";
    }
    return $llms;
  }
}
