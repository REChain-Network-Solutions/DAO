<?php

/**
 * functions -> cache
 * 
 * @package Sngine
 * @author Zamblek
 */

/* ------------------------------- */
/* System Cache */
/* ------------------------------- */

/**
 * system_cache_file
 * 
 * @param string $name
 * @return string
 */
function system_cache_file($name)
{
  return ABSPATH . 'content/cache/' . $name . '.php';
}


/**
 * system_cache_stamp
 * 
 * @return string
 */
function system_cache_stamp()
{
  return md5(SYS_VER . '|' . SYS_URL . '|' . (DEBUGGING ? '1' : '0'));
}


/**
 * system_cache_memo
 * 
 * @return array
 */
function &system_cache_memo()
{
  static $memo = [];
  return $memo;
}


/**
 * system_cache_read
 * 
 * @param string $name
 * @param string $stamp
 * @param integer $ttl
 * @return mixed
 */
function system_cache_read($name, $stamp = null, $ttl = 60)
{
  $file = system_cache_file($name);
  $mtime = @filemtime($file);
  if ($mtime === false || ($ttl && $mtime < time() - $ttl)) {
    return null;
  }
  $cached = @include $file;
  if (!is_array($cached) || !array_key_exists('data', $cached) || ($cached['stamp'] ?? null) !== ($stamp ?? system_cache_stamp())) {
    return null;
  }
  return $cached['data'];
}


/**
 * system_cache_write
 * 
 * @param string $name
 * @param mixed $data
 * @param string $stamp
 * @return boolean
 */
function system_cache_write($name, $data, $stamp = null)
{
  $file = system_cache_file($name);
  $temp = $file . '.' . bin2hex(random_bytes(6)) . '.tmp';
  $contents = "<?php\n\nif (!defined('ABSPATH')) {\n  return false;\n}\n\nreturn " . var_export(['stamp' => $stamp ?? system_cache_stamp(), 'data' => $data], true) . ";\n";
  if (@file_put_contents($temp, $contents) === false) {
    return false;
  }
  if (!@rename($temp, $file)) {
    @unlink($temp);
    return false;
  }
  if (function_exists('opcache_invalidate')) {
    @opcache_invalidate($file, true);
  }
  return true;
}


/**
 * system_cache_remember
 * 
 * @param string $name
 * @param callable $builder
 * @param integer $ttl
 * @param string $stamp
 * @return mixed
 */
function system_cache_remember($name, $builder, $ttl = 60, $stamp = null)
{
  $memo = &system_cache_memo();
  if (array_key_exists($name, $memo)) {
    return $memo[$name];
  }
  $data = system_cache_read($name, $stamp, $ttl);
  if ($data === null) {
    $data = $builder();
    system_cache_write($name, $data, $stamp);
  }
  return $memo[$name] = $data;
}


/**
 * system_cache_rows
 * 
 * @param string $name
 * @param string $query
 * @return array
 */
function system_cache_rows($name, $query)
{
  return system_cache_remember($name, function () use ($query) {
    global $db;
    $rows = [];
    $result = $db->query($query);
    while ($row = $result->fetch_assoc()) {
      $rows[] = $row;
    }
    return $rows;
  });
}


/**
 * system_cache_flush
 * 
 * @param boolean $all
 * @return void
 */
function system_cache_flush($all = false)
{
  foreach ((array) glob(ABSPATH . 'content/cache/*.php') as $file) {
    if (!$all && str_starts_with(basename($file), 'lang_')) {
      continue;
    }
    @unlink($file);
    if (function_exists('opcache_invalidate')) {
      @opcache_invalidate($file, true);
    }
  }
  $memo = &system_cache_memo();
  $memo = [];
}


/**
 * system_cache_status
 * 
 * @return array
 */
function system_cache_status()
{
  $dir = ABSPATH . 'content/cache';
  $files = (array) glob($dir . '/*.php');
  return [
    'writable' => is_dir($dir) && is_writable($dir),
    'files' => count($files),
    'size' => array_sum(array_map('filesize', $files)),
    'opcache' => function_exists('opcache_get_status') && (bool) ini_get('opcache.enable'),
  ];
}



/* ------------------------------- */
/* Redis */
/* ------------------------------- */

/**
 * RedisSessionHandler
 */
class RedisSessionHandler implements SessionHandlerInterface, SessionUpdateTimestampHandlerInterface
{
  private $ttl;

  public function __construct()
  {
    $this->ttl = max(60, (int) ini_get('session.gc_maxlifetime'));
  }

  public function open(string $path, string $name): bool
  {
    return true;
  }

  public function close(): bool
  {
    return true;
  }

  public function read(string $id): string|false
  {
    return (string) redis_run(function ($redis) use ($id) {
      return $redis->get(redis_key('session:' . $id));
    }, '');
  }

  public function write(string $id, string $data): bool
  {
    redis_run(function ($redis) use ($id, $data) {
      $redis->setex(redis_key('session:' . $id), $this->ttl, $data);
    });
    return true;
  }

  public function destroy(string $id): bool
  {
    redis_run(function ($redis) use ($id) {
      $redis->del([redis_key('session:' . $id)]);
    });
    return true;
  }

  public function gc(int $max_lifetime): int|false
  {
    /* keys expire on their own */
    return 0;
  }

  public function validateId(string $id): bool
  {
    return (bool) redis_run(function ($redis) use ($id) {
      return $redis->exists(redis_key('session:' . $id));
    }, false);
  }

  public function updateTimestamp(string $id, string $data): bool
  {
    redis_run(function ($redis) use ($id) {
      $redis->expire(redis_key('session:' . $id), $this->ttl);
    });
    return true;
  }
}


/**
 * redis_settings
 * 
 * @param array $overrides
 * @return array
 */
function redis_settings($overrides = [])
{
  global $system;
  /* saved values went through secure() (html entities) */
  $settings = array_merge([
    'host' => html_entity_decode($system['redis_host'] ?? '127.0.0.1', ENT_QUOTES),
    'port' => $system['redis_port'] ?? '6379',
    'password' => html_entity_decode($system['redis_password'] ?? '', ENT_QUOTES),
    'database' => $system['redis_database'] ?? '0',
    'prefix' => html_entity_decode($system['redis_prefix'] ?? '', ENT_QUOTES),
    'tls' => $system['redis_tls_enabled'] ?? '0',
  ], $overrides);
  if ((string) $settings['prefix'] === '') {
    $settings['prefix'] = 'sngine:' . substr(md5(SYS_URL), 0, 8) . ':';
  }
  return $settings;
}


/**
 * redis_connect
 * 
 * @param array $settings
 * @return object
 */
function redis_connect($settings)
{
  if (!class_exists('Predis\Client')) {
    throw new Exception(__("The Predis library is not installed"));
  }
  $parameters = [
    'scheme' => ($settings['tls']) ? 'tls' : 'tcp',
    'host' => $settings['host'],
    'port' => (int) $settings['port'],
    'database' => (int) $settings['database'],
    'timeout' => 0.2,
    'read_write_timeout' => 0.5,
  ];
  if ((string) $settings['password'] !== '') {
    $parameters['password'] = $settings['password'];
  }
  $client = new Predis\Client($parameters);
  $client->connect();
  return $client;
}


/**
 * redis_state
 * 
 * @return array
 */
function &redis_state()
{
  static $state = ['tried' => false, 'client' => null, 'prefix' => '', 'stats' => []];
  return $state;
}


/**
 * redis_breaker_file
 * 
 * @return string
 */
function redis_breaker_file()
{
  return ABSPATH . 'content/cache/redis.down';
}


/**
 * redis
 * 
 * @return object|null
 */
function redis()
{
  global $system;
  $state = &redis_state();
  if ($state['tried']) {
    return $state['client'];
  }
  $state['tried'] = true;
  if (empty($system['redis_enabled'])) {
    return null;
  }
  $breaker = redis_breaker_file();
  if (is_file($breaker) && filemtime($breaker) > time() - 15) {
    return null;
  }
  try {
    $settings = redis_settings();
    $state['client'] = redis_connect($settings);
    $state['prefix'] = $settings['prefix'];
  } catch (Throwable $e) {
    redis_fail();
  }
  return $state['client'];
}


/**
 * redis_feature
 * 
 * @param string $feature
 * @return boolean
 */
function redis_feature($feature)
{
  global $system;
  return !empty($system['redis_enabled']) && !empty($system['redis_' . $feature . '_enabled']);
}


/**
 * redis_fail
 * 
 * @return void
 */
function redis_fail()
{
  $state = &redis_state();
  $state['client'] = null;
  $state['tried'] = true;
  @touch(redis_breaker_file());
}


/**
 * redis_key
 * 
 * @param string $key
 * @return string
 */
function redis_key($key)
{
  $state = &redis_state();
  return $state['prefix'] . $key;
}


/**
 * redis_run
 * 
 * @param callable $callback
 * @param mixed $default
 * @return mixed
 */
function redis_run($callback, $default = null)
{
  $redis = redis();
  if (!$redis) {
    return $default;
  }
  try {
    return $callback($redis);
  } catch (Throwable $e) {
    redis_fail();
    return $default;
  }
}


/**
 * redis_stat
 * 
 * @param string $name
 * @return void
 */
function redis_stat($name)
{
  $state = &redis_state();
  if (!$state['stats']) {
    register_shutdown_function(function () {
      $state = &redis_state();
      $stats = $state['stats'];
      redis_run(function ($redis) use ($stats) {
        $redis->pipeline(function ($pipe) use ($stats) {
          foreach ($stats as $name => $count) {
            $pipe->hincrby(redis_key('stats'), $name, $count);
          }
        });
      });
    });
  }
  $state['stats'][$name] = ($state['stats'][$name] ?? 0) + 1;
}


/**
 * cache_remember
 * 
 * @param string $key
 * @param integer $ttl
 * @param callable $callback
 * @return mixed
 */
function cache_remember($key, $ttl, $callback)
{
  $cached = redis_run(function ($redis) use ($key) {
    return $redis->get(redis_key($key));
  });
  if ($cached !== null) {
    $value = json_decode($cached, true);
    if ($value !== null) {
      redis_stat('hits');
      return $value;
    }
  }
  $value = $callback();
  if (redis()) {
    redis_stat('misses');
    redis_run(function ($redis) use ($key, $ttl, $value) {
      $redis->setex(redis_key($key), $ttl, json_encode($value));
    });
  }
  return $value;
}


/**
 * widget_cache
 * 
 * @param string $key
 * @param integer $ttl
 * @param callable $callback
 * @return mixed
 */
function widget_cache($key, $ttl, $callback)
{
  return (redis_feature('widgets')) ? cache_remember('widgets:' . $key, $ttl, $callback) : $callback();
}


/**
 * widget_pool_ids
 * 
 * @param string $name
 * @param integer $count
 * @param callable $builder
 * @return array|null
 */
function widget_pool_ids($name, $count, $builder)
{
  if (!redis_feature('widgets')) {
    return null;
  }
  $state = &redis_state();
  /* long-running socket servers must not keep a request's snapshot */
  if (!isset($state['pools_epoch']) || defined('SOCKET_SERVER')) {
    $state['pools_epoch'] = redis_run(function ($redis) {
      return (int) $redis->get(redis_key('widgets:pools:epoch'));
    }, false);
  }
  $epoch = $state['pools_epoch'];
  if ($epoch === false) {
    unset($state['pools_epoch']);
    return null;
  }
  $key = redis_key('widgets:pool:' . $epoch . ':' . $name);
  /* "0" marks a pool that exists but is empty */
  $members = redis_run(function ($redis) use ($key, $count) {
    return $redis->srandmember($key, $count + 1);
  }, false);
  if ($members === false) {
    return null;
  }
  if ($members) {
    redis_stat('hits');
    $ids = array_values(array_filter(array_map('intval', $members)));
    return ['ids' => $ids, 'complete' => count($members) <= $count && count($ids) < 1000];
  }
  redis_stat('misses');
  $ids = array_slice(array_map('intval', $builder()), 0, 1000);
  redis_run(function ($redis) use ($key, $ids) {
    $redis->pipeline(function ($pipe) use ($key, $ids) {
      $pipe->sadd($key, array_merge([0], $ids));
      $pipe->expire($key, 300);
    });
  });
  shuffle($ids);
  return ['ids' => array_slice($ids, 0, $count), 'complete' => count($ids) <= $count && count($ids) < 1000];
}


/**
 * widget_pools_forget
 * 
 * @return void
 */
function widget_pools_forget()
{
  $state = &redis_state();
  unset($state['pools_epoch']);
  redis_run(function ($redis) {
    $redis->incr(redis_key('widgets:pools:epoch'));
  });
}


/**
 * relations_cache_get
 * 
 * @param integer $user_id
 * @param string $list
 * @param callable $builder
 * @return array
 */
function relations_cache_get($user_id, $list, $builder)
{
  static $hashes = [];
  if (!redis_feature('relations')) {
    return $builder();
  }
  /* long-running socket servers must not keep a request's snapshot */
  if (defined('SOCKET_SERVER')) {
    $hashes = [];
  }
  if (!isset($hashes[$user_id])) {
    $hashes[$user_id] = redis_run(function ($redis) use ($user_id) {
      [$epoch, $version] = $redis->mget([redis_key('relations:epoch'), redis_key('relations:version:' . $user_id)]);
      $key = redis_key('relations:' . $user_id . ':' . (int) $epoch . ':' . (int) $version);
      return ['key' => $key, 'lists' => $redis->hgetall($key)];
    }, false);
  }
  if (!$hashes[$user_id]) {
    return $builder();
  }
  if (isset($hashes[$user_id]['lists'][$list])) {
    $value = json_decode($hashes[$user_id]['lists'][$list], true);
    if (is_array($value)) {
      redis_stat('hits');
      return $value;
    }
  }
  $value = $builder();
  redis_stat('misses');
  $key = $hashes[$user_id]['key'];
  redis_run(function ($redis) use ($key, $list, $value) {
    $redis->pipeline(function ($pipe) use ($key, $list, $value) {
      $pipe->hset($key, $list, json_encode($value));
      $pipe->expire($key, 3600);
    });
  });
  return $value;
}


/**
 * relations_cache_forget
 * 
 * @param integer
 * @return void
 */
function relations_cache_forget(...$user_ids)
{
  $user_ids = array_unique(array_filter(array_map('intval', $user_ids)));
  if (!$user_ids || !redis()) {
    return;
  }
  redis_run(function ($redis) use ($user_ids) {
    $redis->pipeline(function ($pipe) use ($user_ids) {
      foreach ($user_ids as $user_id) {
        /* outlives the cached lists (1 hour) so an expired version can't match an old list */
        $pipe->incr(redis_key('relations:version:' . $user_id));
        $pipe->expire(redis_key('relations:version:' . $user_id), 7200);
      }
    });
  });
}


/**
 * relations_cache_reset
 * 
 * @return void
 */
function relations_cache_reset()
{
  redis_run(function ($redis) {
    $redis->incr(redis_key('relations:epoch'));
  });
}


/**
 * cache_forget
 * 
 * @param string|array $keys
 * @return void
 */
function cache_forget($keys)
{
  $keys = array_map('redis_key', (array) $keys);
  redis_run(function ($redis) use ($keys) {
    $redis->del($keys);
  });
}


/**
 * redis_flush
 * 
 * @param object $redis
 * @param string $prefix
 * @return integer
 */
function redis_flush($redis, $prefix)
{
  $deleted = 0;
  $batch = [];
  foreach (new Predis\Collection\Iterator\Keyspace($redis, $prefix . '*', 500) as $key) {
    $batch[] = $key;
    if (count($batch) == 500) {
      $deleted += $redis->del($batch);
      $batch = [];
    }
  }
  if ($batch) {
    $deleted += $redis->del($batch);
  }
  return $deleted;
}


/**
 * redis_status
 * 
 * @return array
 */
function redis_status()
{
  global $system;
  $breaker = redis_breaker_file();
  $status = [
    'installed' => class_exists('Predis\Client'),
    'enabled' => !empty($system['redis_enabled']),
    'paused' => is_file($breaker) && filemtime($breaker) > time() - 15,
    'connected' => false,
    'error' => '',
  ];
  if (!$status['installed'] || !$status['enabled']) {
    return $status;
  }
  try {
    $settings = redis_settings();
    $redis = redis_connect($settings);
    $start = hrtime(true);
    $redis->ping();
    $status['latency'] = round((hrtime(true) - $start) / 1e6, 2);
    $info = [];
    foreach ($redis->info() as $section => $values) {
      $info = array_merge($info, is_array($values) ? $values : [$section => $values]);
    }
    $stats = $redis->hgetall($settings['prefix'] . 'stats');
    $status = array_merge($status, [
      'connected' => true,
      'prefix' => $settings['prefix'],
      'version' => $info['redis_version'] ?? '',
      'uptime_days' => $info['uptime_in_days'] ?? '',
      'memory' => $info['used_memory_human'] ?? '',
      'memory_max' => (!empty($info['maxmemory_human']) && $info['maxmemory_human'] !== '0B') ? $info['maxmemory_human'] : '',
      'clients' => $info['connected_clients'] ?? '',
      'keys' => $redis->dbsize(),
      'hits' => (int) ($stats['hits'] ?? 0),
      'misses' => (int) ($stats['misses'] ?? 0),
    ]);
    $requests = $status['hits'] + $status['misses'];
    $status['hit_rate'] = ($requests) ? round($status['hits'] * 100 / $requests, 1) : null;
  } catch (Throwable $e) {
    $status['error'] = $e->getMessage();
  }
  return $status;
}
