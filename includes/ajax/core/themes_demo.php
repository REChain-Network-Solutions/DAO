<?php

/**
 * ajax -> core -> themes demo
 *
 * @package Sngine
 * @author Zamblek
 */

// fetch bootstrap
require('../../../bootstrap.php');

// check AJAX Request
is_ajax();

// check if themes demo enabled
if (empty($system['themes_demo_enabled']) || (!empty($system['themes_demo_hide_loggedin']) && $user->_logged_in)) {
  modal("MESSAGE", __("Error"), __("This feature has been disabled by the admin"));
}

try {

  // initialize the return array
  $return = [];

  // get themes
  $themes = [];
  $active_theme_id = 0;
  foreach ($system['themes'] as $theme) {
    if (!is_dir(ABSPATH . 'content/themes/' . $theme['name'])) {
      continue;
    }
    $thumbnail = 'content/themes/' . $theme['name'] . '/thumbnail.png';
    $themes[] = [
      'name' => $theme['name'],
      'title' => $theme['title'],
      'thumbnail' => (is_file(ABSPATH . $thumbnail)) ? $thumbnail : '',
      'url' => $system['system_url'] . '/?theme=' . rawurlencode($theme['name']),
      'active' => ($theme['name'] === $system['theme']),
    ];
    if ($theme['name'] === $system['theme']) {
      $active_theme_id = (int) $theme['theme_id'];
    }
  }

  // get landings of the active theme
  $landings = [];
  if ($active_theme_id && !$system['newsfeed_public']) {
    $get_landings = $db->query(sprintf("SELECT slug, title FROM system_theme_landings WHERE theme_id = %s ORDER BY is_default DESC, landing_id ASC", secure($active_theme_id, 'int')));
    while ($landing = $get_landings->fetch_assoc()) {
      if (!preg_match('/^[A-Za-z0-9_-]{1,64}$/', $landing['slug'])) {
        continue;
      }
      if ($landing['slug'] !== 'default' && !is_file(ABSPATH . 'content/themes/' . $system['theme'] . '/templates/index.landing.' . $landing['slug'] . '.tpl')) {
        continue;
      }
      $thumbnails = theme_landing_thumbnails($system['theme'], $landing['slug']);
      if ($system['theme_mode_night']) {
        $thumbnail = ($thumbnails['thumbnail_dark']) ?: $thumbnails['thumbnail_light'];
      } else {
        $thumbnail = ($thumbnails['thumbnail_light']) ?: $thumbnails['thumbnail_dark'];
      }
      $landings[] = [
        'title' => ($landing['title'] !== '') ? $landing['title'] : $landing['slug'],
        'thumbnail' => $thumbnail,
        'url' => $system['system_url'] . '/?landing=' . rawurlencode($landing['slug']),
        'active' => ($landing['slug'] === $system['landing']),
      ];
    }
  }

  /* assign variables */
  $smarty->assign('themes', $themes);
  $smarty->assign('landings', $landings);

  /* return */
  $return['template'] = $smarty->fetch("ajax.themes_demo.tpl");
  $return['callback'] = "modal_content(response.template);";

  // return & exit
  return_json($return);
} catch (Exception $e) {
  modal("ERROR", __("Error"), $e->getMessage());
}
