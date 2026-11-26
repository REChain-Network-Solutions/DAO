<?php

/**
 * trait -> post views
 * 
 * @package Sngine
 */

trait PostViewsTrait
{
  public function post_view_options($lock = 'LOCK IN SHARE MODE')
  {
    global $db;
    $names = ['posts_views_enabled', 'posts_views_type', 'posts_views_period', 'posts_views_days', 'posts_views_maintenance', 'posts_views_schema_version'];
    $options = [];
    $result = $db->query("SELECT option_name, option_value FROM system_options WHERE option_name IN ('posts_views_enabled', 'posts_views_type', 'posts_views_period', 'posts_views_days', 'posts_views_maintenance', 'posts_views_schema_version') ORDER BY option_name $lock");
    while ($row = $result->fetch_assoc()) {
      $options[$row['option_name']] = $row['option_value'];
    }
    if (count($options) !== count($names) || $options['posts_views_schema_version'] !== '1') {
      throw new Exception('Post views migration is required');
    }
    return $options;
  }

  public function count_post_view($post)
  {
    /* Redis: skip repeat views and buffer counters */
    if (redis_feature('post_views') && redis() && $this->count_post_view_buffered($post)) {
      return;
    }
    $skip_seconds = $this->count_post_view_stored($post);
    /* remember the viewer until the database would count them again */
    if ($skip_seconds > 0 && redis_feature('post_views')) {
      $key = $this->post_view_seen_key($post);
      redis_run(function ($redis) use ($key, $skip_seconds) {
        $redis->setex($key, $skip_seconds, '1');
      });
    }
  }


  /**
   * count_post_view_buffered
   * 
   * @param array $post
   * @return boolean
   */
  private function count_post_view_buffered($post)
  {
    global $system;
    if ($system['posts_views_maintenance'] !== 'idle' || !$system['posts_views_enabled']) {
      return false;
    }
    if ($system['posts_views_type'] === 'all') {
      /* count in Redis, written to the database at most once a minute */
      $flush = redis_run(function ($redis) use ($post) {
        $responses = $redis->pipeline(function ($pipe) use ($post) {
          $pipe->hincrby(redis_key('post_views:pending'), $post['post_id'] . ':' . $post['author_id'], 1);
          $pipe->set(redis_key('post_views:flush'), '1', 'EX', 60, 'NX');
        });
        return (bool) $responses[1];
      }, null);
      if ($flush === null) {
        return false;
      }
      if ($flush) {
        register_shutdown_function([$this, 'flush_post_views']);
      }
      return true;
    }
    /* unique views: this viewer was already counted or checked recently */
    $key = $this->post_view_seen_key($post);
    return (bool) redis_run(function ($redis) use ($key) {
      return $redis->exists($key);
    }, false);
  }


  /**
   * post_view_seen_key
   * 
   * @param array $post
   * @return string
   */
  private function post_view_seen_key($post)
  {
    $viewer = ($this->_logged_in) ? 'u' . $this->_data['user_id'] : 'g' . md5(get_user_ip());
    return redis_key('post_views:seen:' . $post['post_id'] . ':' . $viewer);
  }


  /**
   * flush_post_views
   * 
   * @return integer
   */
  public function flush_post_views()
  {
    global $db;
    $views = redis_run(function ($redis) {
      $pending = redis_key('post_views:pending');
      if (!$redis->exists($pending)) {
        return [];
      }
      $flushing = $pending . ':' . bin2hex(random_bytes(6));
      $redis->rename($pending, $flushing);
      $views = $redis->hgetall($flushing);
      $redis->del([$flushing]);
      return $views;
    }, []);
    $updated = 0;
    foreach ($views as $node => $count) {
      [$post_id, $author_id] = array_pad(explode(':', $node, 2), 2, 0);
      $db->query(sprintf("UPDATE posts SET views = views + %s WHERE post_id = %s", secure($count, 'int', false), secure($post_id, 'int')));
      if ($db->affected_rows) {
        $updated++;
        for ($i = 0; $i < (int) $count; $i++) {
          $this->points_balance('add', $author_id, 'post_view', $post_id);
        }
      }
    }
    return $updated;
  }


  /**
   * post_views_redis_reset
   * 
   * @return void
   */
  public function post_views_redis_reset()
  {
    redis_run(function ($redis) {
      $redis->del([redis_key('post_views:pending')]);
      redis_flush($redis, redis_key('post_views:seen:'));
    });
  }


  /**
   * count_post_view_stored
   * 
   * @param array $post
   * @return integer
   */
  private function count_post_view_stored($post)
  {
    global $db;
    for ($attempt = 0; $attempt < 3; $attempt++) {
      try {
        $db->begin_transaction();
        $options = $this->post_view_options();
        if ($options['posts_views_maintenance'] !== 'idle' || !$options['posts_views_enabled']) {
          $db->commit();
          return 0;
        }
        $post_id = secure($post['post_id'], 'int');
        $now = $db->query('SELECT UTC_TIMESTAMP() AS utc_now')->fetch_assoc()['utc_now'];
        $existing_post = $db->query("SELECT post_id FROM posts WHERE post_id = $post_id FOR UPDATE");
        if (!$existing_post->num_rows) {
          $db->commit();
          return 0;
        }
        $counted = $options['posts_views_type'] === 'all';
        /* lifetime unique views are never counted twice (re-checked daily) */
        $skip_seconds = ($counted) ? 0 : 86400;
        if (!$counted) {
          if ($this->_logged_in) {
            $column = 'user_id';
            $viewer = secure($this->_data['user_id'], 'int');
          } else {
            $column = 'guest_ip';
            $viewer = secure(get_user_ip());
          }
          $history = $db->query("SELECT view_id, view_date FROM posts_views WHERE post_id = $post_id AND $column = $viewer LIMIT 1 FOR UPDATE")->fetch_assoc();
          $seconds = ($options['posts_views_period'] === 'days') ? (int)$options['posts_views_days'] * 86400 : 0;
          if (!$history) {
            $db->query("INSERT INTO posts_views (post_id, $column, view_date) VALUES ($post_id, $viewer, " . secure($now) . ")");
            $counted = true;
            $skip_seconds = ($seconds) ? min($seconds, 86400) : 86400;
          } elseif ($options['posts_views_period'] === 'days') {
            if (strtotime($history['view_date'] . ' UTC') <= strtotime($now . ' UTC') - $seconds) {
              $db->query("UPDATE posts_views SET view_date = " . secure($now) . " WHERE view_id = " . secure($history['view_id'], 'int'));
              $counted = true;
              $skip_seconds = min($seconds, 86400);
            } else {
              /* not countable again before the period ends */
              $skip_seconds = min(strtotime($history['view_date'] . ' UTC') + $seconds - strtotime($now . ' UTC'), 86400);
            }
          }
        }
        if ($counted) {
          $db->query("UPDATE posts SET views = views + 1 WHERE post_id = $post_id");
          /* a batched copy of this post now has the old views count */
          unset($this->_posts_prefetch['rows_covered'][(int) $post['post_id']]);
          $this->points_balance('add', $post['author_id'], 'post_view', $post['post_id']);
        }
        $db->commit();
        return $skip_seconds;
      } catch (Throwable $e) {
        $db->rollback();
        if (in_array((int)$e->getCode(), [1205, 1213], true) && $attempt < 2) {
          usleep(20000 * ($attempt + 1));
          continue;
        }
        throw $e;
      }
    }
  }

  public function save_post_view_settings($values)
  {
    global $db;
    if (!in_array($values['posts_views_type'] ?? null, ['all', 'unique'], true) || !in_array($values['posts_views_period'] ?? null, ['lifetime', 'days'], true)) {
      throw new Exception(__("Invalid post views settings"));
    }
    $days = $values['posts_views_days'] ?? null;
    if (!is_string($days) || !preg_match('/^[1-9][0-9]*$/D', $days) || (float)$days > 36500) {
      throw new Exception(__("Enter a valid number of days between 1 and 36500"));
    }
    $db->begin_transaction();
    try {
      $previous = $this->post_view_options('FOR UPDATE');
      if ($previous['posts_views_maintenance'] !== 'idle') {
        throw new Exception(__("Post views maintenance is in progress"));
      }
      $clear = $previous['posts_views_type'] === 'unique' && $values['posts_views_type'] === 'all';
      update_system_options([
        'posts_views_enabled' => secure(!empty($values['posts_views_enabled']) ? '1' : '0'),
        'posts_views_type' => secure($values['posts_views_type']),
        'posts_views_period' => secure($values['posts_views_period']),
        'posts_views_days' => secure($days),
        'posts_views_maintenance' => secure($clear ? 'clear' : 'idle'),
      ]);
      $db->commit();
    } catch (Throwable $e) {
      $db->rollback();
      throw $e;
    }
    $this->post_views_redis_reset();
    if ($clear) {
      $this->finish_post_view_maintenance();
    }
  }

  public function reset_post_views()
  {
    global $db;
    $db->begin_transaction();
    try {
      $options = $this->post_view_options('FOR UPDATE');
      if ($options['posts_views_maintenance'] !== 'idle') {
        throw new Exception(__("Post views maintenance is in progress"));
      }
      update_system_options(['posts_views_maintenance' => secure('reset')]);
      $db->commit();
    } catch (Throwable $e) {
      $db->rollback();
      throw $e;
    }
    $this->finish_post_view_maintenance();
  }

  public function finish_post_view_maintenance()
  {
    global $db;
    $lock = $db->query("SELECT GET_LOCK('sngine_post_views_maintenance', 0) AS acquired")->fetch_assoc();
    if ((int)$lock['acquired'] !== 1) {
      throw new Exception(__("Post views maintenance is already running"));
    }
    try {
      $state = $db->query("SELECT option_value FROM system_options WHERE option_name = 'posts_views_maintenance'")->fetch_assoc()['option_value'];
      if ($state === 'reset') {
        $db->query("UPDATE posts SET views = 0");
      }
      if (in_array($state, ['clear', 'reset'], true)) {
        $this->post_views_redis_reset();
        $db->query("TRUNCATE TABLE posts_views");
        /* add missing indexes */
        $indexes = [];
        $get_indexes = $db->query("SHOW INDEX FROM posts_views");
        while ($index = $get_indexes->fetch_assoc()) {
          $indexes[$index['Key_name']] = true;
        }
        $missing_indexes = array_diff_key([
          'post_user' => "ADD UNIQUE INDEX `post_user` (post_id, user_id)",
          'post_guest' => "ADD UNIQUE INDEX `post_guest` (post_id, guest_ip)",
          'view_date_id' => "ADD INDEX `view_date_id` (view_date, view_id)",
        ], $indexes);
        if ($missing_indexes) {
          $db->query("ALTER TABLE posts_views " . implode(", ", $missing_indexes));
        }
        update_system_options(['posts_views_maintenance' => secure('idle')]);
      }
    } finally {
      $db->query("SELECT RELEASE_LOCK('sngine_post_views_maintenance')");
    }
  }

  public function clean_expired_post_views()
  {
    global $db;
    $lock = $db->query("SELECT GET_LOCK('sngine_post_views_cleanup', 0) AS acquired")->fetch_assoc();
    if ((int)$lock['acquired'] !== 1) {
      throw new Exception(__("Post views cleanup is already running"));
    }
    $deleted = 0;
    $remaining = false;
    $started = microtime(true);
    try {
      do {
        $db->begin_transaction();
        try {
          $options = $this->post_view_options();
          if ($options['posts_views_maintenance'] !== 'idle' || $options['posts_views_type'] !== 'unique' || $options['posts_views_period'] !== 'days') {
            throw new Exception(__("Timed unique views must be enabled to clean expired history"));
          }
          $days = (int)$options['posts_views_days'];
          $db->query("DELETE FROM posts_views WHERE view_date <= UTC_TIMESTAMP() - INTERVAL $days DAY ORDER BY view_date, view_id LIMIT 5000");
          $batch = $db->affected_rows;
          $deleted += $batch;
          $db->commit();
        } catch (Throwable $e) {
          $db->rollback();
          throw $e;
        }
      } while ($batch === 5000 && microtime(true) - $started < 20);
      if ($batch === 5000) {
        $db->begin_transaction();
        try {
          $options = $this->post_view_options();
          if ($options['posts_views_maintenance'] === 'idle' && $options['posts_views_type'] === 'unique' && $options['posts_views_period'] === 'days') {
            $days = (int)$options['posts_views_days'];
            $remaining = $db->query("SELECT view_id FROM posts_views WHERE view_date <= UTC_TIMESTAMP() - INTERVAL $days DAY LIMIT 1")->num_rows > 0;
          }
          $db->commit();
        } catch (Throwable $e) {
          $db->rollback();
          throw $e;
        }
      }
      update_system_options([
        'posts_views_cleanup_time' => secure(gmdate('Y-m-d H:i:s')),
        'posts_views_cleanup_result' => secure($deleted . ' deleted; ' . ($remaining ? 'more expired rows remain' : 'complete')),
        'posts_views_cleanup_error' => secure(''),
      ]);
      return ['deleted' => $deleted, 'remaining' => $remaining];
    } catch (Throwable $e) {
      update_system_options([
        'posts_views_cleanup_time' => secure(gmdate('Y-m-d H:i:s')),
        'posts_views_cleanup_result' => secure($deleted . ' deleted before error'),
        'posts_views_cleanup_error' => secure(substr($e->getMessage(), 0, 250)),
      ]);
      throw $e;
    } finally {
      $db->query("SELECT RELEASE_LOCK('sngine_post_views_cleanup')");
    }
  }
}
