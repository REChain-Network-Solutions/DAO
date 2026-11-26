<?php

/**
 * functions -> design
 * 
 * @package Sngine
 * @author Zamblek
 */

/* ------------------------------- */
/* Modal */
/* ------------------------------- */

/**
 * modal
 * 
 * @return void
 */
function modal()
{
  $args = func_get_args();
  switch ($args[0]) {
    case 'LOGIN':
      return_json(["callback" => "modal('#modal-login')"]);
      break;
    case 'MESSAGE':
      return_json(["callback" => "modal('#modal-message', {title: '" . $args[1] . "', message: '" . addslashes($args[2]) . "'})"]);
      break;
    case 'ERROR':
      return_json(["callback" => "modal('#modal-error', {title: '" . $args[1] . "', message: '" . addslashes($args[2]) . "'})"]);
      break;
    case 'SUCCESS':
      return_json(["callback" => "modal('#modal-success', {title: '" . $args[1] . "', message: '" . addslashes($args[2]) . "'})"]);
      break;
    case 'INFO':
      return_json(["callback" => "modal('#modal-info', {title: '" . $args[1] . "', message: '" . addslashes($args[2]) . "'})"]);
      break;
    default:
      if (isset($args[1])) {
        return_json(["callback" => "modal('" . $args[0] . "', " . $args[1] . ")"]);
      } else {
        return_json(["callback" => "modal('" . $args[0] . "')"]);
      }
      break;
  }
}



/* ------------------------------- */
/* Popover */
/* ------------------------------- */

/**
 * popover
 * 
 * @param integer $uid
 * @param string $username
 * @param string $name
 * @return string
 */
function popover($uid, $username, $name)
{
  global $system;
  $popover = '<span class="js_user-popover" data-uid="' . $uid . '"><a href="' . $system['system_url'] . '/' . $username . '">' . $name . '</a></span>';
  return $popover;
}



/* ------------------------------- */
/* Page */
/* ------------------------------- */

/**
 * page_header
 * 
 * @param string $title
 * @param string $description
 * @param string $image
 * @return void
 */
function page_header($title, $description = '', $image = '')
{
  global $smarty, $system;
  $description = ($description != '') ? $description : __($system['system_description']);
  if ($image == '') {
    if ($system['system_ogimage']) {
      $image = $system['system_uploads'] . '/' . $system['system_ogimage'];
    } else {
      $image = $system['system_url'] . '/content/themes/' . $system['theme'] . '/images/og-image.jpg';
    }
  }
  $smarty->assign('page_title', $title);
  $smarty->assign('page_description', $description);
  $smarty->assign('page_image', $image);
}


/**
 * page_footer
 * 
 * @param string $page
 * @return void
 */
function page_footer($page)
{
  global $smarty;
  $smarty->assign('page', $page);
  $smarty->display("$page.tpl");
}



/* ------------------------------- */
/* Themes */
/* ------------------------------- */

/**
 * theme_assets
 * 
 * @param array $params
 * @return string
 */
function theme_assets($params)
{
  global $system;
  $entry = (!empty($params['entry'])) ? $params['entry'] : 'app';
  $theme = (!empty($params['theme'])) ? $params['theme'] : $system['theme'];
  if (!preg_match('/^[a-zA-Z0-9_-]+$/', $entry) || !preg_match('/^[a-zA-Z0-9_-]+$/', $theme)) {
    return '';
  }
  $dir = 'content/themes/' . $theme . '/dist/';
  $source = ($entry === 'emojis' && $theme === 'nova') ? 'includes/assets/js/core/emojis.js' : 'content/themes/' . $theme . '/src/css/' . $entry . '.css';
  if (defined('VITE_DEV_SERVER') && VITE_DEV_SERVER) {
    static $vite_client = false;
    $origin = rtrim(VITE_DEV_SERVER, '/');
    $html = '';
    if (!$vite_client) {
      $html .= '<script type="module" src="' . $origin . '/@vite/client"></script>' . "\n";
      $vite_client = true;
    }
    $html .= '<script type="module" src="' . $origin . '/' . $source . '"></script>';
    return $html;
  }
  static $manifests = [];
  if (!isset($manifests[$dir])) {
    $manifest_file = ABSPATH . $dir . '.vite/manifest.json';
    $manifest = (is_file($manifest_file)) ? json_decode(file_get_contents($manifest_file), true) : null;
    $manifests[$dir] = (is_array($manifest)) ? $manifest : [];
  }
  $manifest = $manifests[$dir];
  if (!isset($manifest[$source]['file'])) {
    return '';
  }
  $base = $system['system_url'] . '/' . $dir;
  $chunk = $manifest[$source];
  $styles = (!empty($chunk['css'])) ? $chunk['css'] : [];
  $preloads = [];
  $queue = (!empty($chunk['imports'])) ? $chunk['imports'] : [];
  $seen = [];
  while ($queue) {
    $key = array_shift($queue);
    if (isset($seen[$key]) || !isset($manifest[$key])) {
      continue;
    }
    $seen[$key] = true;
    $imported = $manifest[$key];
    if (!empty($imported['css'])) {
      $styles = array_merge($styles, $imported['css']);
    }
    if (!empty($imported['file'])) {
      $preloads[] = $imported['file'];
    }
    if (!empty($imported['imports'])) {
      $queue = array_merge($queue, $imported['imports']);
    }
  }
  if (substr($chunk['file'], -4) === '.css') {
    array_unshift($styles, $chunk['file']);
  }
  if (!empty($params['inline'])) {
    $html = '';
    foreach (array_unique($styles) as $file) {
      if (is_file(ABSPATH . $dir . $file)) {
        $html .= '<style>' . file_get_contents(ABSPATH . $dir . $file) . '</style>' . "\n";
      }
    }
    return $html;
  }
  $html = '';
  foreach (array_unique($styles) as $file) {
    $html .= '<link rel="stylesheet" href="' . $base . $file . '">' . "\n";
  }
  foreach (array_unique($preloads) as $file) {
    $html .= '<link rel="modulepreload" href="' . $base . $file . '">' . "\n";
  }
  if (substr($chunk['file'], -3) === '.js') {
    $html .= '<script type="module" src="' . $base . $chunk['file'] . '"></script>' . "\n";
  }
  return $html;
}


/**
 * theme_module_icon
 * 
 * @param string $slug
 * @param string $class
 * @param string $folder
 * @return string
 */
function theme_module_icon($slug, $class = '', $folder = 'modules')
{
  global $system;
  static $cache = [], $count = 0, $token = null;
  $slug = preg_replace('/[^a-z0-9_-]/', '', strtolower((string) $slug));
  $folder = preg_replace('/[^a-z0-9_-]/', '', strtolower((string) $folder));
  if ($slug === '' || $folder === '' || empty($system['theme'])) {
    return '';
  }
  $key = $system['theme'] . ':' . $folder . ':' . $slug;
  if (!isset($cache[$key])) {
    $path = ABSPATH . 'content/themes/' . $system['theme'] . '/images/svg/' . $folder . '/' . $slug . '.svg';
    $cache[$key] = (is_file($path)) ? trim(preg_replace('/^.*?(?=<svg\b)/s', '', file_get_contents($path))) : '';
  }
  if ($cache[$key] === '') {
    return '';
  }
  /* unique ids per render and per request (ajax content lands next to page icons) */
  $token ??= bin2hex(random_bytes(3));
  $count++;
  $svg = preg_replace('/(\sid="|url\(#|href="#)([^")]+)/', '${1}${2}-mi' . $token . $count, $cache[$key]);
  $class = trim('module-icon ' . htmlspecialchars((string) $class, ENT_QUOTES));
  return preg_replace('/^<svg\b/', '<svg class="' . $class . '" aria-hidden="true" focusable="false"', $svg, 1);
}



/* ------------------------------- */
/* Bottom Bar */
/* ------------------------------- */

/**
 * bottom_bar_registry
 * 
 * @return array
 */
function bottom_bar_registry()
{
  global $system, $user;
  $logged_in = !empty($user->_logged_in);
  $data = ($logged_in) ? $user->_data : [];
  $url = $system['system_url'];
  return [
    'home' => ['label' => __("Home"), 'icon' => 'icon-[tabler--home]', 'url' => $url, 'page' => 'index', 'views' => [''], 'enabled' => true],
    'add' => ['label' => __("Add"), 'icon' => 'icon-[tabler--plus]', 'url' => '', 'page' => '', 'views' => [], 'enabled' => true],
    'menu' => ['label' => __("Menu"), 'icon' => 'icon-[tabler--user-circle]', 'url' => '', 'page' => '', 'views' => [], 'enabled' => true],
    'saved' => ['label' => __("Saved"), 'icon' => 'icon-[tabler--bookmark]', 'url' => $url . '/saved', 'page' => 'index', 'views' => ['saved'], 'enabled' => true],
    'scheduled' => ['label' => __("Scheduled"), 'icon' => 'icon-[tabler--calendar-time]', 'url' => $url . '/scheduled', 'page' => 'index', 'views' => ['scheduled'], 'enabled' => !empty($data['can_schedule_posts'])],
    'memories' => ['label' => __("Memories"), 'icon' => 'icon-[tabler--history]', 'url' => $url . '/memories', 'page' => 'index', 'views' => ['memories'], 'enabled' => !empty($system['memories_enabled'])],
    'people' => ['label' => __("People"), 'icon' => 'icon-[tabler--users]', 'url' => $url . '/people', 'page' => 'people', 'views' => [], 'enabled' => true],
    'pages' => ['label' => __("Pages"), 'icon' => 'icon-[tabler--flag]', 'url' => $url . '/pages', 'page' => 'pages', 'views' => [], 'enabled' => !empty($system['pages_enabled'])],
    'groups' => ['label' => __("Groups"), 'icon' => 'icon-[tabler--users-group]', 'url' => $url . '/groups', 'page' => 'groups', 'views' => [], 'enabled' => !empty($system['groups_enabled'])],
    'events' => ['label' => __("Events"), 'icon' => 'icon-[tabler--calendar-event]', 'url' => $url . '/events', 'page' => 'events', 'views' => [], 'enabled' => !empty($system['events_enabled'])],
    'reels' => ['label' => __("Reels"), 'icon' => 'icon-[tabler--movie]', 'url' => $url . '/reels', 'page' => 'reels', 'views' => [], 'enabled' => !empty($system['reels_enabled'])],
    'watch' => ['label' => __("Watch"), 'icon' => 'icon-[tabler--player-play]', 'url' => $url . '/watch', 'page' => 'watch', 'views' => [], 'enabled' => !empty($system['watch_enabled'])],
    'live' => ['label' => __("Live"), 'icon' => 'icon-[tabler--broadcast]', 'url' => $url . '/live', 'page' => 'live', 'views' => [], 'enabled' => !empty($system['live_enabled'])],
    'market' => ['label' => __("Market"), 'icon' => 'icon-[tabler--building-store]', 'url' => $url . '/market', 'page' => 'market', 'views' => [], 'enabled' => !empty($system['market_enabled'])],
    'blogs' => ['label' => __("Blogs"), 'icon' => 'icon-[tabler--article]', 'url' => $url . '/blogs', 'page' => 'blogs', 'views' => [], 'enabled' => !empty($system['blogs_enabled'])],
    'funding' => ['label' => __("Funding"), 'icon' => 'icon-[tabler--coin]', 'url' => $url . '/funding', 'page' => 'funding', 'views' => [], 'enabled' => !empty($system['funding_enabled'])],
    'offers' => ['label' => __("Offers"), 'icon' => 'icon-[tabler--discount]', 'url' => $url . '/offers', 'page' => 'offers', 'views' => [], 'enabled' => !empty($system['offers_enabled'])],
    'jobs' => ['label' => __("Jobs"), 'icon' => 'icon-[tabler--briefcase]', 'url' => $url . '/jobs', 'page' => 'jobs', 'views' => [], 'enabled' => !empty($system['jobs_enabled'])],
    'courses' => ['label' => __("Courses"), 'icon' => 'icon-[tabler--school]', 'url' => $url . '/courses', 'page' => 'courses', 'views' => [], 'enabled' => !empty($system['courses_enabled'])],
    'forums' => ['label' => __("Forums"), 'icon' => 'icon-[tabler--messages]', 'url' => $url . '/forums', 'page' => 'forums', 'views' => [], 'enabled' => !empty($system['forums_enabled'])],
    'movies' => ['label' => __("Movies"), 'icon' => 'icon-[tabler--device-tv]', 'url' => $url . '/movies', 'page' => 'movies', 'views' => [], 'enabled' => !empty($system['movies_enabled'])],
    'games' => ['label' => __("Games"), 'icon' => 'icon-[tabler--device-gamepad-2]', 'url' => $url . '/games', 'page' => 'games', 'views' => [], 'enabled' => !empty($system['games_enabled'])],
    'developers' => ['label' => __("Developers"), 'icon' => 'icon-[tabler--code]', 'url' => $url . '/developers' . (empty($system['developers_apps_enabled']) ? '/share' : ''), 'page' => 'developers', 'views' => [], 'enabled' => !empty($system['developers_apps_enabled']) || !empty($system['developers_share_enabled'])],
    'merits' => ['label' => __("Merits"), 'icon' => 'icon-[tabler--award]', 'url' => $url . '/merits', 'page' => 'merits', 'views' => [], 'enabled' => !empty($system['merits_enabled'])],
    'dating' => ['label' => __("Dating"), 'icon' => 'icon-[tabler--heart]', 'url' => $url . '/dating', 'page' => 'dating', 'views' => [], 'enabled' => !empty($data['can_use_dating'])],
    'directory' => ['label' => __("Directory"), 'icon' => 'icon-[tabler--list-details]', 'url' => $url . '/directory', 'page' => 'directory', 'views' => [], 'enabled' => !empty($system['directory_enabled'])],
    'wallet' => ['label' => __("Wallet"), 'icon' => 'icon-[tabler--wallet]', 'url' => $url . '/wallet', 'page' => 'wallet', 'views' => [], 'enabled' => !empty($system['wallet_enabled'])],
    'ads' => ['label' => __("Ads Manager"), 'icon' => 'icon-[tabler--speakerphone]', 'url' => $url . '/ads', 'page' => 'ads', 'views' => [], 'enabled' => !empty($system['ads_enabled'])],
    'boosted' => ['label' => __("Boosted"), 'icon' => 'icon-[tabler--rocket]', 'url' => $url . '/boosted/posts', 'page' => 'index', 'views' => ['boosted_posts', 'boosted_pages', 'boosted_groups', 'boosted_events'], 'enabled' => !empty($data['can_boost_posts']) || !empty($data['can_boost_pages']) || !empty($data['can_boost_groups']) || !empty($data['can_boost_events'])],
  ];
}


/**
 * bottom_bar_keys
 * 
 * @param mixed $value
 * @return array
 */
function bottom_bar_keys($value)
{
  global $system;
  $registry = bottom_bar_registry();
  $keys = (is_array($value)) ? $value : explode(',', (string) $value);
  $keys = array_values(array_unique(array_filter($keys, function ($key) use ($registry) {
    return is_string($key) && isset($registry[$key]);
  })));
  /* default */
  if (!$keys) {
    $keys = ['home', (empty($system['reels_enabled']) && !empty($system['watch_enabled'])) ? 'watch' : 'reels', 'add', 'menu'];
  }
  /* menu is required */
  $keys = array_slice($keys, 0, (in_array('menu', $keys)) ? 5 : 4);
  if (!in_array('menu', $keys)) {
    $keys[] = 'menu';
  }
  return $keys;
}


/**
 * bottom_bar_items
 * 
 * @param string $value
 * @param boolean $manage
 * @return array
 */
function bottom_bar_items($value, $manage = false)
{
  $registry = bottom_bar_registry();
  $shown = [];
  foreach (bottom_bar_keys($value) as $key) {
    if ($manage || $registry[$key]['enabled']) {
      $shown[$key] = $registry[$key];
    }
  }
  if (!$manage) {
    return $shown;
  }
  return ['shown' => $shown, 'hidden' => array_diff_key($registry, $shown)];
}



/* ------------------------------- */
/* Sidebar */
/* ------------------------------- */

/**
 * sidebar_registry
 * 
 * @return array
 */
function sidebar_registry()
{
  global $system, $user;
  $logged_in = !empty($user->_logged_in);
  $registry = array_diff_key(bottom_bar_registry(), ['home' => true, 'add' => true, 'menu' => true]);
  foreach ($registry as $key => $item) {
    $registry[$key]['module'] = $key;
  }
  /* modules */
  $registry['saved']['module'] = 'bookmark';
  $registry['scheduled']['module'] = 'schedule';
  $registry['market']['module'] = 'marketplace';
  /* stories archive */
  $registry['stories_archive'] = ['label' => __("Stories"), 'icon' => 'icon-[tabler--history-toggle]', 'url' => $system['system_url'] . '/stories/archive', 'page' => 'index', 'views' => ['stories_archive'], 'enabled' => $logged_in && !empty($system['stories_enabled']) && !empty($system['stories_archive_enabled']), 'module' => 'stories'];
  /* labels */
  $registry['market']['label'] = __("Marketplace");
  /* members only */
  foreach (['saved', 'memories', 'people', 'watch', 'wallet', 'ads'] as $key) {
    $registry[$key]['enabled'] = $logged_in && $registry[$key]['enabled'];
  }
  return $registry;
}


/**
 * sidebar_keys
 * 
 * @param mixed $main
 * @param mixed $more
 * @return array
 */
function sidebar_keys($main, $more)
{
  $registry = sidebar_registry();
  $seen = [];
  $filter = function ($value) use ($registry, &$seen) {
    $keys = [];
    foreach ((is_array($value)) ? $value : explode(',', (string) $value) as $key) {
      if (is_string($key) && isset($registry[$key]) && !isset($seen[$key])) {
        $seen[$key] = true;
        $keys[] = $key;
      }
    }
    return $keys;
  };
  $main = $filter($main);
  $more = $filter($more);
  /* default */
  if (!$main && !$more) {
    $main = ['saved', 'scheduled', 'memories', 'stories_archive', 'people', 'dating', 'pages', 'groups', 'events', 'reels', 'watch', 'live'];
    $more = ['wallet', 'ads', 'boosted', 'blogs', 'market', 'funding', 'offers', 'jobs', 'courses', 'forums', 'movies', 'games', 'merits', 'developers', 'directory'];
  }
  return ['main' => $main, 'more' => $more];
}


/**
 * sidebar_items
 * 
 * @param string $main
 * @param string $more
 * @param boolean $manage
 * @return array
 */
function sidebar_items($main, $more = '', $manage = false)
{
  $registry = sidebar_registry();
  $items = ['main' => [], 'more' => []];
  foreach (sidebar_keys($main, $more) as $list => $keys) {
    foreach ($keys as $key) {
      if ($manage || $registry[$key]['enabled']) {
        $items[$list][$key] = $registry[$key];
      }
    }
  }
  if ($manage) {
    $items['hidden'] = array_diff_key($registry, $items['main'], $items['more']);
  }
  return $items;
}



/* ------------------------------- */
/* Modules Names */
/* ------------------------------- */

/**
 * module_names_catalogue
 * 
 * @return array
 */
function module_names_catalogue()
{
  static $catalogue = null;
  if ($catalogue === null) {
    $catalogue = json_decode((string) @file_get_contents(ABSPATH . 'includes/module-names.json'), true);
    $catalogue = (is_array($catalogue)) ? $catalogue + ['modules' => [], 'words' => [], 'skip' => [], 'strings' => []] : ['modules' => [], 'words' => [], 'skip' => [], 'strings' => []];
  }
  return $catalogue;
}


/**
 * module_names_values
 * 
 * @param mixed $value
 * @return array
 */
function module_names_values($value)
{
  $catalogue = module_names_catalogue();
  $value = (is_array($value)) ? $value : json_decode(html_entity_decode((string) $value, ENT_QUOTES), true);
  $names = [];
  foreach ($catalogue['modules'] as $module => $terms) {
    foreach ($terms as $term => $default) {
      $name = $value[$module][$term] ?? '';
      $name = (is_string($name)) ? trim(preg_replace(['/[<>"\'`&\\\\]/', '/\s+/u'], ['', ' '], strip_tags($name))) : '';
      if ($name !== '' && $name !== $default) {
        $names[$module][$term] = mb_substr($name, 0, 32);
      }
    }
  }
  return $names;
}


/**
 * module_names_registry
 * 
 * @return array
 */
function module_names_registry()
{
  global $system;
  $catalogue = module_names_catalogue();
  $names = module_names_values($system['module_names'] ?? '');
  $icons = bottom_bar_registry();
  $registry = [];
  foreach ($catalogue['modules'] as $module => $terms) {
    $registry[$module] = ['label' => __($terms['name'] ?? $terms['plural']), 'icon' => $icons[$module]['icon'] ?? 'icon-[tabler--history]', 'terms' => []];
    foreach ($terms as $term => $default) {
      $registry[$module]['terms'][$term] = ['default' => $default, 'value' => $names[$module][$term] ?? ''];
    }
  }
  return $registry;
}


/**
 * module_names_rename
 * 
 * @param string $text
 * @param array $replacements
 * @param array $skip
 * @return string
 */
function module_names_rename($text, $replacements, $skip = [])
{
  $skip = array_map('strtolower', $skip);
  $words = array_keys($replacements);
  usort($words, function ($a, $b) {
    return strlen($b) - strlen($a);
  });
  $pattern = '/\b(?:(an?)(\s+))?(' . implode('|', array_map('preg_quote', $words)) . ')\b/iu';
  return preg_replace_callback($pattern, function ($matches) use ($replacements, $skip) {
    $word = strtolower($matches[3]);
    if (in_array($word, $skip)) {
      return $matches[0];
    }
    $name = $replacements[$word];
    if ($matches[3] === $word) {
      $name = mb_strtolower($name);
    } elseif ($matches[3] === strtoupper($matches[3])) {
      $name = mb_strtoupper($name);
    }
    if ($matches[1] === '') {
      return $name;
    }
    /* article */
    $article = (preg_match('/^[aeiou]/i', $name)) ? 'an' : 'a';
    if ($matches[1] === strtoupper($matches[1])) {
      $article = ($matches[1] === 'A') ? ucfirst($article) : strtoupper($article);
    } elseif ($matches[1] !== strtolower($matches[1])) {
      $article = ucfirst($article);
    }
    return $article . $matches[2] . $name;
  }, $text);
}


/**
 * module_names_overrides
 * 
 * @return array
 */
function module_names_overrides()
{
  $option = system_config_load()['system']['module_names'] ?? '';
  if ($option === '') {
    return [];
  }
  return system_cache_remember('module_names', function () use ($option) {
    $catalogue = module_names_catalogue();
    $names = module_names_values($option);
    $replacements = [];
    foreach ($catalogue['words'] as $word => $target) {
      if (isset($names[$target[0]][$target[1]])) {
        $replacements[strtolower($word)] = $names[$target[0]][$target[1]];
      }
    }
    $overrides = [];
    if ($replacements) {
      foreach ($catalogue['strings'] as $text) {
        $renamed = module_names_rename($text, $replacements, $catalogue['skip'][$text] ?? []);
        if ($renamed !== $text) {
          $overrides[$text] = $renamed;
        }
      }
    }
    return $overrides;
  });
}



/* ------------------------------- */
/* User Card */
/* ------------------------------- */

/**
 * user_card_details
 * 
 * @param array $target
 * @return array
 */
function user_card_details($target)
{
  global $user;
  if (!isset($user) || empty($target['user_id'])) {
    return ['mutual_friends_count' => 0, 'mutual_friends' => [], 'work' => null, 'location' => null, 'education' => null];
  }
  return $user->get_user_card_details($target);
}



/* ------------------------------- */
/* Admin Settings Search */
/* ------------------------------- */

/**
 * admin_settings_text
 * 
 * @param string $fragment
 * @return string
 */
function admin_settings_text($fragment)
{
  /* conditional extras (e.g. a "Disabled" badge) are not part of the label */
  $fragment = preg_replace('/\{if\s.*?\{\/if\}/s', '', $fragment);
  $fragment = preg_replace('/\{__\("((?:[^"\\\\]|\\\\.)*)"\)\}/s', '$1', $fragment);
  $fragment = preg_replace('/\{"([^"]*)"\}/s', '$1', $fragment);
  /* any remaining smarty tag carries no visible text */
  $fragment = preg_replace('/\{[^}]*\}/s', '', $fragment);
  $fragment = strip_tags($fragment);
  $fragment = html_entity_decode($fragment, ENT_QUOTES, 'UTF-8');
  $fragment = trim(preg_replace('/\s+/u', ' ', $fragment));
  /* a dropped dynamic tag can leave a dangling separator ("AI Credit/") */
  return trim($fragment, " \t\n\r/:,-");
}


/**
 * admin_settings_parse_template
 * 
 * @param string $file
 * @param array $context
 * @param array $fields
 * @return void
 */
function admin_settings_parse_template($file, $context, &$fields)
{
  if (!is_file($file)) {
    return;
  }
  $source = file_get_contents($file);
  $dir = dirname($file) . '/';
  $page = $context['page'];
  if (preg_match('/<h1\b[^>]*>(.*?)<\/h1>/s', $source, $match)) {
    $title = admin_settings_text($match[1]);
    $page = ($title) ? $title : $page;
  }
  $tabs = [];
  if (preg_match_all('/data-tab="#([^"]+)"[^>]*>(.*?)<\/button>/s', $source, $matches, PREG_SET_ORDER)) {
    foreach ($matches as $match) {
      $tabs[$match[1]] = admin_settings_text($match[2]);
    }
  }
  $panels = [];
  if (preg_match_all('/<div\b([^>]*js_admin-settings-panel[^>]*)>/i', $source, $matches, PREG_OFFSET_CAPTURE)) {
    foreach ($matches[1] as $key => $attributes) {
      if (preg_match('/\bid="([^"]+)"/', $attributes[0], $id)) {
        $panels[] = ['offset' => $matches[0][$key][1], 'id' => $id[1]];
      }
    }
  }
  $tab_at = function ($offset) use ($panels, $tabs, $context) {
    $current = '';
    foreach ($panels as $panel) {
      if ($panel['offset'] < $offset) {
        $current = $panel['id'];
      }
    }
    return (isset($tabs[$current])) ? $tabs[$current] : $context['tab'];
  };
  $sections = [];
  if (preg_match_all('/<h[23]\b([^>]*js_admin-settings-section-title[^>]*)>(.*?)<\/h[23]>/s', $source, $matches, PREG_SET_ORDER | PREG_OFFSET_CAPTURE)) {
    foreach ($matches as $match) {
      $sections[] = ['offset' => $match[0][1], 'title' => admin_settings_text($match[2][0]), 'id' => (preg_match('/\bid="([^"]+)"/', $match[1][0], $id)) ? $id[1] : ''];
    }
  }
  $section_at = function ($offset) use ($sections) {
    $current = '';
    foreach ($sections as $section) {
      if ($section['offset'] < $offset) {
        $current = $section['title'];
      }
    }
    return $current;
  };
  $helps = [];
  if (preg_match_all('/<div\b[^>]*\bid="([^"]+)-help"[^>]*>(.*?)<\/div>/s', $source, $matches, PREG_SET_ORDER)) {
    foreach ($matches as $match) {
      $helps[$match[1]] = admin_settings_text($match[2]);
    }
  }
  $radios = [];
  if (preg_match_all('/<input\b[^>]*>/i', $source, $matches)) {
    foreach ($matches[0] as $tag) {
      if (strpos($tag, 'type="radio"') !== false && preg_match('/\bid="([^"]+)"/', $tag, $id)) {
        $radios[$id[1]] = true;
      }
    }
  }
  $found = [];
  if (preg_match_all('/<label\b[^>]*\bfor="([^"]+)"[^>]*>(.*?)<\/label>/s', $source, $matches, PREG_SET_ORDER | PREG_OFFSET_CAPTURE)) {
    foreach ($matches as $match) {
      if (!isset($radios[$match[1][0]])) {
        $found[] = ['id' => $match[1][0], 'body' => $match[2][0], 'offset' => $match[0][1]];
      }
    }
  }
  if (preg_match_all('/<div\b[^>]*class="label-text"[^>]*\bid="([^"]+)"[^>]*>(.*?)<\/div>/s', $source, $matches, PREG_SET_ORDER | PREG_OFFSET_CAPTURE)) {
    foreach ($matches as $match) {
      $found[] = ['id' => $match[1][0], 'body' => $match[2][0], 'offset' => $match[0][1]];
    }
  }
  foreach ($found as $field) {
    $label = admin_settings_text($field['body']);
    if (!$label || isset($fields[$field['id']]) || preg_match('/__|[{$]/', $field['id'])) {
      continue;
    }
    $help_key = (substr($field['id'], -6) === '-label') ? substr($field['id'], 0, -6) : $field['id'];
    $fields[$field['id']] = [
      'id'           => $field['id'],
      'label'        => $label,
      'help'         => (isset($helps[$help_key])) ? $helps[$help_key] : '',
      'view'         => $context['view'],
      'sub_view'     => $context['sub_view'],
      'page'         => $page,
      'tab'          => $tab_at($field['offset']),
      'section'      => $section_at($field['offset']),
      'monetization' => $context['monetization'],
    ];
  }
  foreach ($sections as $section) {
    if (!$section['title'] || !$section['id'] || isset($fields[$section['id']])) {
      continue;
    }
    $fields[$section['id']] = [
      'id'           => $section['id'],
      'label'        => $section['title'],
      'help'         => '',
      'view'         => $context['view'],
      'sub_view'     => $context['sub_view'],
      'page'         => $page,
      'tab'          => $tab_at($section['offset'] + 1),
      'section'      => '',
      'monetization' => $context['monetization'],
    ];
  }
  if (preg_match_all('/\{include file=\'(admin\.settings\.[^\']+\.tpl)\'\}/', $source, $matches, PREG_SET_ORDER | PREG_OFFSET_CAPTURE)) {
    foreach ($matches as $match) {
      $offset = $match[0][1];
      $before = substr($source, max(0, $offset - 300), min($offset, 300));
      admin_settings_parse_template($dir . $match[1][0], [
        'view'         => $context['view'],
        'sub_view'     => $context['sub_view'],
        'page'         => $page,
        'tab'          => $tab_at($offset),
        'monetization' => $context['monetization'] || (strpos($before, '$licence_monetization') !== false),
      ], $fields);
    }
  }
}


/**
 * admin_settings_search_index
 * 
 * @return array
 */
function admin_settings_search_index()
{
  global $system;
  static $index = null;
  if ($index !== null) {
    return $index;
  }
  $theme = (!empty($system['theme'])) ? $system['theme'] : 'default';
  if (!preg_match('/^[a-zA-Z0-9_-]+$/', $theme)) {
    return $index = [];
  }
  $dir = ABSPATH . 'content/themes/' . $theme . '/templates/';
  $files = (array) glob($dir . 'admin.settings*.tpl');
  if (!$files) {
    return $index = [];
  }
  if (is_file($dir . 'admin.themes.tpl')) {
    $files[] = $dir . 'admin.themes.tpl';
  }
  $stamp = (int) filemtime(__FILE__);
  foreach ($files as $file) {
    $stamp = max($stamp, (int) filemtime($file));
  }
  $cache = ABSPATH . 'content/themes/' . $theme . '/templates_compiled/admin-settings-index.php';
  if (is_file($cache)) {
    $cached = @include($cache);
    if (is_array($cached) && isset($cached['stamp']) && $cached['stamp'] === $stamp) {
      return $index = $cached['fields'];
    }
  }
  $routes = [];
  $dispatcher = $dir . 'admin.settings.tpl';
  if (is_file($dispatcher) && preg_match_all('/\$sub_view\s*==\s*"([^"]*)"\}/s', file_get_contents($dispatcher), $matches, PREG_SET_ORDER | PREG_OFFSET_CAPTURE)) {
    $source = file_get_contents($dispatcher);
    foreach ($matches as $key => $match) {
      $start = $match[0][1] + strlen($match[0][0]);
      $end = (isset($matches[$key + 1])) ? $matches[$key + 1][0][1] : strlen($source);
      $branch = substr($source, $start, $end - $start);
      $gated = (strpos($branch, '$licence_monetization') !== false);
      if (preg_match_all('/\{include file=\'(admin\.settings\.[^\']+\.tpl)\'\}/', $branch, $includes)) {
        foreach ($includes[1] as $file) {
          $routes[$file] = ['sub_view' => $match[1][0], 'monetization' => $gated];
        }
      }
    }
  }
  $fields = [];
  foreach ($routes as $file => $route) {
    admin_settings_parse_template($dir . $file, ['view' => 'settings', 'sub_view' => $route['sub_view'], 'page' => '', 'tab' => '', 'monetization' => $route['monetization']], $fields);
  }
  /* theme options */
  admin_settings_parse_template($dir . 'admin.themes.tpl', ['view' => 'themes', 'sub_view' => 'edit', 'page' => 'Themes', 'tab' => '', 'monetization' => false], $fields);
  $index = array_values($fields);
  @file_put_contents($cache, "<?php\n\nreturn " . var_export(['stamp' => $stamp, 'fields' => $index], true) . ";\n", LOCK_EX);
  return $index;
}



/* ------------------------------- */
/* User Settings Search */
/* ------------------------------- */

/**
 * user_settings_split_top
 * 
 * @param string $expr
 * @param string $op
 * @return array
 */
function user_settings_split_top($expr, $op)
{
  $parts = [];
  $depth = 0;
  $quote = '';
  $start = 0;
  $length = strlen($expr);
  $op_len = strlen($op);
  for ($i = 0; $i < $length; $i++) {
    $char = $expr[$i];
    if ($quote) {
      if ($char === '\\') {
        $i++;
        continue;
      }
      if ($char === $quote) {
        $quote = '';
      }
      continue;
    }
    if ($char === '"' || $char === "'") {
      $quote = $char;
      continue;
    }
    if ($char === '(') {
      $depth++;
      continue;
    }
    if ($char === ')') {
      $depth = max(0, $depth - 1);
      continue;
    }
    if ($depth === 0 && substr($expr, $i, $op_len) === $op) {
      $parts[] = substr($expr, $start, $i - $start);
      $i += $op_len - 1;
      $start = $i + 1;
    }
  }
  $parts[] = substr($expr, $start);
  return $parts;
}


/**
 * user_settings_atom
 * 
 * @param string $atom
 * @return bool|null
 */
function user_settings_atom($atom)
{
  global $system, $user;
  $atom = trim($atom);
  if ($atom === '') {
    return true;
  }
  $neg = false;
  if ($atom[0] === '!') {
    $neg = true;
    $atom = trim(substr($atom, 1));
  }
  $result = null;
  if (preg_match('/^\$system\[[\'"]([^\'"]+)[\'"]\]\s*(==|!=|>=|<=|>|<)\s*(.+)$/', $atom, $match)) {
    $left = $system[$match[1]] ?? null;
    $right = trim($match[3], " \t\n\r'\"");
    switch ($match[2]) {
      case '==':
        $result = ((string) $left === (string) $right);
        break;
      case '!=':
        $result = ((string) $left !== (string) $right);
        break;
      case '>':
        $result = ((float) $left > (float) $right);
        break;
      case '<':
        $result = ((float) $left < (float) $right);
        break;
      case '>=':
        $result = ((float) $left >= (float) $right);
        break;
      case '<=':
        $result = ((float) $left <= (float) $right);
        break;
    }
  } elseif (preg_match('/^\$system\[[\'"]([^\'"]+)[\'"]\]$/', $atom, $match)) {
    $value = $system[$match[1]] ?? null;
    $result = !empty($value) && $value !== '0';
  } elseif (preg_match('/^\$user->_data\[[\'"]([^\'"]+)[\'"]\]$/', $atom, $match)) {
    $value = $user->_data[$match[1]] ?? null;
    $result = !empty($value) && $value !== '0';
  } elseif ($atom === '$user->_is_admin') {
    $result = !empty($user->_is_admin);
  } elseif ($atom === '$user->_is_moderator') {
    $result = !empty($user->_is_moderator);
  } else {
    return true;
  }
  return $neg ? !$result : $result;
}


/**
 * user_settings_eval_condition
 * 
 * @param string $expr
 * @return bool
 */
function user_settings_eval_condition($expr)
{
  $expr = trim($expr);
  if ($expr === '') {
    return true;
  }
  while ($expr !== '' && $expr[0] === '(' && substr($expr, -1) === ')') {
    $depth = 0;
    $wrapped = true;
    $length = strlen($expr);
    for ($i = 0; $i < $length; $i++) {
      if ($expr[$i] === '(') {
        $depth++;
      } elseif ($expr[$i] === ')') {
        $depth--;
        if ($depth === 0 && $i < $length - 1) {
          $wrapped = false;
          break;
        }
      }
    }
    if (!$wrapped) {
      break;
    }
    $expr = trim(substr($expr, 1, -1));
  }
  $ors = user_settings_split_top($expr, '||');
  if (count($ors) > 1) {
    foreach ($ors as $or) {
      if (user_settings_eval_condition($or)) {
        return true;
      }
    }
    return false;
  }
  $ands = user_settings_split_top($expr, '&&');
  if (count($ands) > 1) {
    foreach ($ands as $and) {
      if (!user_settings_eval_condition($and)) {
        return false;
      }
    }
    return true;
  }
  return user_settings_atom($expr);
}


/**
 * user_settings_conditions_at
 * 
 * @param string $source
 * @param int $offset
 * @return array
 */
function user_settings_conditions_at($source, $offset)
{
  if (!preg_match_all('/\{(\/if|elseif|else|if)\b([^}]*)\}/', $source, $matches, PREG_SET_ORDER | PREG_OFFSET_CAPTURE)) {
    return [];
  }
  $stack = [];
  foreach ($matches as $match) {
    if ($match[0][1] >= $offset) {
      break;
    }
    $tag = $match[1][0];
    $expr = trim($match[2][0]);
    if ($tag === 'if') {
      $stack[] = [$expr];
    } elseif ($tag === 'elseif') {
      if ($stack) {
        $stack[count($stack) - 1] = [$expr];
      }
    } elseif ($tag === 'else') {
      if ($stack) {
        $stack[count($stack) - 1] = [];
      }
    } elseif ($tag === '/if') {
      array_pop($stack);
    }
  }
  $conditions = [];
  foreach ($stack as $frame) {
    foreach ($frame as $expr) {
      if ($expr === '' || preg_match('/\$sub_view|\$view\b|\$case\b/', $expr)) {
        continue;
      }
      $conditions[] = $expr;
    }
  }
  return $conditions;
}


/**
 * user_settings_field_allowed
 * 
 * @param array $field
 * @return bool
 */
function user_settings_field_allowed($field)
{
  if (!user_settings_view_allowed($field['view'] ?? '', $field['sub_view'] ?? '')) {
    return false;
  }
  foreach ((array) ($field['conditions'] ?? []) as $expr) {
    if (!user_settings_eval_condition($expr)) {
      return false;
    }
  }
  return true;
}


/**
 * user_settings_view_allowed
 * 
 * @param string $view
 * @param string $sub_view
 * @return bool
 */
function user_settings_view_allowed($view, $sub_view)
{
  global $system, $user;
  switch ($view) {
    case '':
    case 'privacy':
    case 'notifications':
    case 'blocking':
    case 'addresses':
      return true;

    case 'profile':
      if ($sub_view === 'work') {
        return !empty($system['work_info_enabled']);
      }
      if ($sub_view === 'location') {
        return !empty($system['location_info_enabled']);
      }
      if ($sub_view === 'education') {
        return !empty($system['education_info_enabled']);
      }
      if ($sub_view === 'social') {
        return !empty($system['social_info_enabled']);
      }
      if ($sub_view === 'design') {
        return !empty($system['system_profile_background_enabled']);
      }
      return true;

    case 'security':
      if ($sub_view === 'two-factor') {
        return !empty($system['two_factor_enabled']);
      }
      return in_array($sub_view, ['password', 'sessions', 'two-factor', ''], true);

    case 'verification':
      return !empty($system['verification_requests']);

    case 'accounts':
      return !empty($system['switch_accounts_enabled']);

    case 'linked':
      if (empty($system['social_login_enabled'])) {
        return false;
      }
      return !empty($system['apple_login_enabled']) || !empty($system['facebook_login_enabled']) || !empty($system['google_login_enabled']) || !empty($system['discord_login_enabled']) || !empty($system['twitter_login_enabled']) || !empty($system['linkedin_login_enabled']) || !empty($system['vkontakte_login_enabled']) || !empty($system['wordpress_login_enabled']) || !empty($system['sngine_login_enabled']);

    case 'membership':
      return !empty($system['packages_enabled']);

    case 'invitations':
      return !empty($user->_data['can_invite_users']);

    case 'affiliates':
      if (empty($system['affiliates_enabled'])) {
        return false;
      }
      if ($sub_view === 'payments') {
        return !empty($system['affiliates_money_withdraw_enabled']);
      }
      return true;

    case 'points':
      if (empty($system['points_enabled'])) {
        return false;
      }
      if ($sub_view === 'payments') {
        return !empty($system['points_per_currency']) && !empty($system['points_money_withdraw_enabled']);
      }
      return true;

    case 'market':
      return !empty($user->_data['can_sell_products']) && !empty($system['market_shopping_cart_enabled']);

    case 'funding':
      return !empty($user->_data['can_raise_funding']);

    case 'monetization':
      if (empty($user->_data['can_monetize_content'])) {
        return false;
      }
      if ($sub_view === 'payments') {
        return !empty($system['monetization_money_withdraw_enabled']);
      }
      return true;

    case 'coinpayments':
      return !empty($system['coinpayments_enabled']) && function_exists('licence_module_installed') && licence_module_installed() && method_exists($user, 'get_coinpayments_transactions');

    case 'bank':
      return !empty($system['bank_transfers_enabled']);

    case 'apps':
      return !empty($system['developers_apps_enabled']);

    case 'information':
      return !empty($system['download_info_enabled']);

    case 'delete':
      return !empty($system['delete_accounts_enabled']);
  }
  return false;
}


/**
 * user_settings_split_sub_views
 * 
 * @param string $source
 * @return array
 */
function user_settings_split_sub_views($source)
{
  if (!preg_match_all('/\{(?:else)?if\s+\$sub_view\s*==\s*"([^"]*)"\}/', $source, $matches, PREG_SET_ORDER | PREG_OFFSET_CAPTURE)) {
    return ['' => $source];
  }
  $branches = [];
  foreach ($matches as $key => $match) {
    $start = $match[0][1] + strlen($match[0][0]);
    $end = (isset($matches[$key + 1])) ? $matches[$key + 1][0][1] : strlen($source);
    $branches[$match[1][0]] = substr($source, $start, $end - $start);
  }
  return $branches;
}


/**
 * user_settings_parse_branch
 * 
 * @param string $source
 * @param array $context
 * @param array $fields
 * @return void
 */
function user_settings_parse_branch($source, $context, &$fields)
{
  $page = $context['page'];
  $help_text = $context['help'];
  if (preg_match_all('/_title=__\("((?:[^"\\\\]|\\\\.)*)"\)/', $source, $titles, PREG_SET_ORDER | PREG_OFFSET_CAPTURE)) {
    $page = $titles[0][1][0];
  } elseif (preg_match('/<h2\b[^>]*class="[^"]*card-title[^"]*"[^>]*>(.*?)<\/h2>/s', $source, $title)) {
    $page = admin_settings_text($title[1]);
  }
  if (preg_match('/_text=__\("((?:[^"\\\\]|\\\\.)*)"\)/', $source, $text)) {
    $help_text = $text[1];
  } elseif (preg_match('/<p\b[^>]*class="[^"]*text-base-content\/60[^"]*"[^>]*>(.*?)<\/p>/s', $source, $text)) {
    $help_text = admin_settings_text($text[1]);
  }
  $page_key = 'page:' . $context['view'] . ':' . $context['sub_view'];
  if ($page && !isset($fields[$page_key])) {
    $fields[$page_key] = [
      'id'         => '',
      'label'      => $page,
      'help'       => $help_text,
      'view'       => $context['view'],
      'sub_view'   => $context['sub_view'],
      'page'       => $page,
      'section'    => '',
      'conditions' => $context['conditions'],
    ];
  }
  $sections = [];
  if (preg_match_all('/<h3\b[^>]*>(.*?)<\/h3>/s', $source, $matches, PREG_SET_ORDER | PREG_OFFSET_CAPTURE)) {
    foreach ($matches as $match) {
      $title = admin_settings_text($match[1][0]);
      if ($title) {
        $sections[] = ['offset' => $match[0][1], 'title' => $title];
      }
    }
  }
  $section_at = function ($offset) use ($sections) {
    $current = '';
    foreach ($sections as $section) {
      if ($section['offset'] < $offset) {
        $current = $section['title'];
      }
    }
    return $current;
  };
  $page_at = function ($offset) use ($source, $page) {
    $current = $page;
    if (preg_match_all('/_title=__\("((?:[^"\\\\]|\\\\.)*)"\)|<h2\b[^>]*class="[^"]*card-title[^"]*"[^>]*>(.*?)<\/h2>/s', $source, $matches, PREG_SET_ORDER | PREG_OFFSET_CAPTURE)) {
      foreach ($matches as $match) {
        if ($match[0][1] >= $offset) {
          continue;
        }
        if (!empty($match[1][0])) {
          $current = $match[1][0];
        } elseif (!empty($match[2][0])) {
          $current = admin_settings_text($match[2][0]);
        }
      }
    }
    return $current;
  };
  $helps = [];
  if (preg_match_all('/<(?:p|div)\b[^>]*\bid="([^"]+)-help"[^>]*>(.*?)<\/(?:p|div)>/s', $source, $matches, PREG_SET_ORDER)) {
    foreach ($matches as $match) {
      $helps[$match[1]] = admin_settings_text($match[2]);
    }
  }
  $radios = [];
  if (preg_match_all('/<input\b[^>]*>/i', $source, $matches)) {
    foreach ($matches[0] as $tag) {
      if (stripos($tag, 'type="radio"') !== false && preg_match('/\bid="([^"]+)"/', $tag, $id)) {
        $radios[$id[1]] = true;
      }
    }
  }
  $found = [];
  if (preg_match_all('/<label\b[^>]*\bfor="([^"]+)"[^>]*>(.*?)<\/label>/s', $source, $matches, PREG_SET_ORDER | PREG_OFFSET_CAPTURE)) {
    foreach ($matches as $match) {
      if (!isset($radios[$match[1][0]])) {
        $found[] = ['id' => $match[1][0], 'body' => $match[2][0], 'offset' => $match[0][1]];
      }
    }
  }
  if (preg_match_all('/<(?:div|span)\b[^>]*\bid="([^"]+-label)"[^>]*>(.*?)<\/(?:div|span)>/s', $source, $matches, PREG_SET_ORDER | PREG_OFFSET_CAPTURE)) {
    foreach ($matches as $match) {
      $found[] = ['id' => $match[1][0], 'body' => $match[2][0], 'offset' => $match[0][1]];
    }
  }
  foreach ($found as $field) {
    $window = substr($source, max(0, $field['offset'] - 800), 800);
    if (strpos($window, 'js_hidden-section') !== false) {
      continue;
    }
    $label = admin_settings_text($field['body']);
    if (!$label || isset($fields[$field['id']])) {
      continue;
    }
    $help_key = (substr($field['id'], -6) === '-label') ? substr($field['id'], 0, -6) : $field['id'];
    $help = (isset($helps[$help_key])) ? $helps[$help_key] : '';
    if ($help === '') {
      $after = substr($source, $field['offset'], 500);
      if (preg_match('/<p\b[^>]*>(.*?)<\/p>/s', $after, $para)) {
        $help = admin_settings_text($para[1]);
      }
    }
    $fields[$field['id']] = [
      'id'         => $field['id'],
      'label'      => $label,
      'help'       => $help,
      'view'       => $context['view'],
      'sub_view'   => $context['sub_view'],
      'page'       => $page_at($field['offset']),
      'section'    => $section_at($field['offset']),
      'conditions' => array_values(array_unique(array_merge($context['conditions'], user_settings_conditions_at($source, $field['offset'])))),
    ];
  }
}


/**
 * user_settings_search_index
 * 
 * @return array
 */
function user_settings_search_index()
{
  global $system;
  static $index = null;
  if ($index !== null) {
    return $index;
  }
  $theme = (!empty($system['theme'])) ? $system['theme'] : 'nova';
  if (!preg_match('/^[a-zA-Z0-9_-]+$/', $theme)) {
    return $index = [];
  }
  $dir = ABSPATH . 'content/themes/' . $theme . '/templates/';
  $files = (array) glob($dir . 'settings*.tpl');
  if (!$files) {
    return $index = [];
  }
  $stamp = 0;
  foreach ($files as $file) {
    $stamp = max($stamp, (int) filemtime($file));
  }
  $cache = ABSPATH . 'content/themes/' . $theme . '/templates_compiled/user-settings-index.php';
  if (is_file($cache)) {
    $cached = @include($cache);
    if (is_array($cached) && isset($cached['stamp']) && $cached['stamp'] === $stamp) {
      return $index = $cached['fields'];
    }
  }
  $routes = [];
  $dispatcher = $dir . 'settings.tpl';
  if (is_file($dispatcher) && preg_match_all('/\$view\s*==\s*"([^"]*)"\}/s', file_get_contents($dispatcher), $matches, PREG_SET_ORDER | PREG_OFFSET_CAPTURE)) {
    $source = file_get_contents($dispatcher);
    foreach ($matches as $key => $match) {
      $start = $match[0][1] + strlen($match[0][0]);
      $end = (isset($matches[$key + 1])) ? $matches[$key + 1][0][1] : strlen($source);
      $branch = substr($source, $start, $end - $start);
      if (preg_match_all('/\{include file=\'(settings\.[^\']+\.tpl)\'\}/', $branch, $includes)) {
        foreach ($includes[1] as $file) {
          $routes[$file] = $match[1][0];
        }
      }
    }
  }
  $fields = [];
  foreach ($routes as $file => $view) {
    $path = $dir . $file;
    if (!is_file($path)) {
      continue;
    }
    $source = file_get_contents($path);
    foreach (user_settings_split_sub_views($source) as $sub_view => $branch) {
      user_settings_parse_branch($branch, [
        'view'       => $view,
        'sub_view'   => $sub_view,
        'page'       => '',
        'help'       => '',
        'conditions' => [],
      ], $fields);
    }
  }
  $index = array_values($fields);
  @file_put_contents($cache, "<?php\n\nreturn " . var_export(['stamp' => $stamp, 'fields' => $index], true) . ";\n", LOCK_EX);
  return $index;
}
