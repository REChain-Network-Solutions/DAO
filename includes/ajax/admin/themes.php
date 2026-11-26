<?php

/**
 * ajax -> admin -> themes
 * 
 * @package Sngine
 * @author Zamblek
 */

// fetch bootstrap
require('../../../bootstrap.php');

// check AJAX Request
is_ajax();

// check admin|moderator permission
if (!$user->_is_admin) {
  modal("MESSAGE", __("System Message"), __("You don't have the right permission to access this"));
}

// check demo account
if ($user->_data['user_demo']) {
  modal("ERROR", __("Demo Restriction"), __("You can't do this with demo account"));
}

// refresh the compiled system cache
register_shutdown_function('system_cache_flush');

// handle themes
try {

  /* validate theme folder path */
  $theme_path = function ($name) {
    $name = trim((string) $name);
    if ($name === '' || str_contains($name, '..') || str_contains($name, '/') || str_contains($name, '\\')) {
      throw new Exception(__("Oops! There is no theme folder availble in your 'content/themes' folder with such name make sure you cloned the default theme folder first then rename it with your new theme name"));
    }
    if (!is_dir(ABSPATH . 'content/themes/' . $name)) {
      throw new Exception(__("Oops! There is no theme folder availble in your 'content/themes' folder with such name make sure you cloned the default theme folder first then rename it with your new theme name"));
    }
    return $name;
  };

  /* validate theme landing pages */
  $validate_landings = function () {
    $posted = $_POST['landings'] ?? [];
    if (!is_array($posted)) {
      $posted = [];
    }

    $default_title = 'Default';
    $extras = [];
    $slugs = [];

    foreach ($posted as $row) {
      if (!is_array($row)) {
        continue;
      }
      $is_default = (!empty($row['is_default']) && $row['is_default'] == '1');
      $slug = trim((string) ($row['slug'] ?? ''));
      $title = trim((string) ($row['title'] ?? ''));
      $id = (isset($row['id']) && is_numeric($row['id'])) ? (int) $row['id'] : 0;

      if ($is_default || $slug === 'default') {
        $default_title = ($title !== '') ? $title : 'Default';
        continue;
      }

      if ($slug === '' && $title === '') {
        continue;
      }
      if ($slug === '' || str_contains($slug, '..') || str_contains($slug, '/') || str_contains($slug, '\\') || !preg_match('/^[A-Za-z0-9_-]+$/', $slug) || strtolower($slug) === 'default') {
        throw new Exception(__("Landing slug should not contain spaces or special characters"));
      }
      $key = strtolower($slug);
      if (isset($slugs[$key])) {
        throw new Exception(__("Landing slug should not contain spaces or special characters"));
      }
      $slugs[$key] = true;
      if ($title === '') {
        throw new Exception(__("You must enter the landing title"));
      }
      $extras[] = ['id' => $id, 'slug' => $slug, 'title' => $title];
    }

    return ['default_title' => $default_title, 'extras' => $extras];
  };

  /* persist theme landing pages */
  $persist_landings = function ($theme_id, $landings) use ($db) {
    $default_title = $landings['default_title'];
    $extras = $landings['extras'];

    $keep_ids = [];
    $existing_default = $db->query(sprintf("SELECT landing_id FROM system_theme_landings WHERE theme_id = %s AND is_default = '1' LIMIT 1", secure($theme_id, 'int')));
    if ($existing_default->num_rows > 0) {
      $default_id = $existing_default->fetch_assoc()['landing_id'];
      $db->query(sprintf(
        "UPDATE system_theme_landings SET slug = 'default', title = %s, is_default = '1' WHERE landing_id = %s AND theme_id = %s",
        secure($default_title),
        secure($default_id, 'int'),
        secure($theme_id, 'int')
      ));
      $keep_ids[] = (int) $default_id;
    } else {
      $db->query(sprintf(
        "INSERT INTO system_theme_landings (theme_id, slug, title, is_default) VALUES (%s, 'default', %s, '1')",
        secure($theme_id, 'int'),
        secure($default_title)
      ));
      $keep_ids[] = (int) $db->insert_id;
    }

    foreach ($extras as $extra) {
      $existing_extra = false;
      if ($extra['id']) {
        $check_extra = $db->query(sprintf(
          "SELECT landing_id FROM system_theme_landings WHERE landing_id = %s AND theme_id = %s AND is_default = '0' LIMIT 1",
          secure($extra['id'], 'int'),
          secure($theme_id, 'int')
        ));
        $existing_extra = ($check_extra->num_rows > 0);
      }
      if ($existing_extra) {
        $db->query(sprintf(
          "UPDATE system_theme_landings SET slug = %s, title = %s, is_default = '0' WHERE landing_id = %s AND theme_id = %s AND is_default = '0'",
          secure($extra['slug']),
          secure($extra['title']),
          secure($extra['id'], 'int'),
          secure($theme_id, 'int')
        ));
        $keep_ids[] = (int) $extra['id'];
      } else {
        $db->query(sprintf(
          "INSERT INTO system_theme_landings (theme_id, slug, title, is_default) VALUES (%s, %s, %s, '0')",
          secure($theme_id, 'int'),
          secure($extra['slug']),
          secure($extra['title'])
        ));
        $keep_ids[] = (int) $db->insert_id;
      }
    }

    $keep_ids = array_unique(array_filter($keep_ids));
    if ($keep_ids) {
      $db->query(sprintf(
        "DELETE FROM system_theme_landings WHERE theme_id = %s AND is_default = '0' AND landing_id NOT IN (%s)",
        secure($theme_id, 'int'),
        implode(',', array_map('intval', $keep_ids))
      ));
    } else {
      $db->query(sprintf("DELETE FROM system_theme_landings WHERE theme_id = %s AND is_default = '0'", secure($theme_id, 'int')));
    }

    $active = trim((string) ($_POST['landing'] ?? 'default'));
    $valid_slugs = ['default' => true];
    foreach ($extras as $extra) {
      $valid_slugs[$extra['slug']] = true;
    }
    if (!isset($valid_slugs[$active])) {
      $active = 'default';
    }
    $db->query(sprintf("UPDATE system_themes SET landing = %s WHERE theme_id = %s", secure($active), secure($theme_id, 'int')));
  };

  /* prepare theme design fields */
  $prepare_theme = function () {
    $_POST['default'] = (isset($_POST['default'])) ? '1' : '0';
    $_POST['enabled'] = (isset($_POST['enabled'])) ? '1' : '0';
    $_POST['fluid_design'] = (isset($_POST['fluid_design'])) ? '1' : '0';
    $_POST['system_theme_night_on'] = (isset($_POST['system_theme_night_on'])) ? '1' : '0';
    $_POST['system_theme_mode_select'] = (isset($_POST['system_theme_mode_select'])) ? '1' : '0';
    $_POST['system_theme_icons'] = (isset($_POST['system_theme_icons']) && $_POST['system_theme_icons'] == 'svg') ? 'svg' : 'tabler';
    $_POST['system_theme_fonts'] = (isset($_POST['system_theme_fonts']) && $_POST['system_theme_fonts'] == 'local') ? 'local' : 'google';
    $_POST['system_wallpaper_default'] = (isset($_POST['system_wallpaper_default'])) ? '1' : '0';
    $_POST['css_customized'] = (isset($_POST['css_customized'])) ? '1' : '0';
    $_POST['title'] = $_POST['title'] ?? '';
    $_POST['system_wallpaper'] = $_POST['system_wallpaper'] ?? '';
    $_POST['css_background'] = $_POST['css_background'] ?? '';
    $_POST['css_link_color'] = $_POST['css_link_color'] ?? '';
    $_POST['css_header'] = $_POST['css_header'] ?? '';
    $_POST['css_header_search'] = $_POST['css_header_search'] ?? '';
    $_POST['css_header_search_color'] = $_POST['css_header_search_color'] ?? '';
    $_POST['css_btn_primary'] = $_POST['css_btn_primary'] ?? '';
    $_POST['css_header_icons'] = $_POST['css_header_icons'] ?? '';
    $_POST['css_header_icons_night'] = $_POST['css_header_icons_night'] ?? '';
    $_POST['css_main_icons'] = $_POST['css_main_icons'] ?? '';
    $_POST['css_main_icons_night'] = $_POST['css_main_icons_night'] ?? '';
    $_POST['css_action_icons'] = $_POST['css_action_icons'] ?? '';
    $_POST['css_action_icons_night'] = $_POST['css_action_icons_night'] ?? '';
    $_POST['css_custome_css'] = $_POST['css_custome_css'] ?? '';
    $_POST['bottom_bar'] = implode(',', bottom_bar_keys($_POST['bottom_bar'] ?? []));
    $sidebar = sidebar_keys($_POST['sidebar'] ?? [], $_POST['sidebar_more'] ?? []);
    $_POST['sidebar'] = implode(',', $sidebar['main']);
    $_POST['sidebar_more'] = implode(',', $sidebar['more']);
    if (is_empty($_POST['title'])) {
      throw new Exception(__("You must enter the theme title"));
    }
  };

  switch ($_GET['do']) {
    case 'check':
      $theme_path($_POST['name'] ?? '');
      return_json(['success' => true, 'message' => __("Theme path is correct")]);
      break;

    case 'edit':
      /* valid inputs */
      if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
        _error(400);
      }
      $_POST['name'] = $theme_path($_POST['name'] ?? '');
      $prepare_theme();
      $landings = $validate_landings();
      /* if default is set -> set all as not default first */
      if ($_POST['default']) {
        $db->query("UPDATE system_themes SET system_themes.default = '0'");
      } else {
        /*  default is not set -> check if this theme is the default one */
        $check_themes = $db->query(sprintf("SELECT COUNT(*) as count FROM system_themes WHERE system_themes.default = '1' and theme_id = %s", secure($_GET['id'], 'int')));
        if ($check_themes->fetch_assoc()['count'] > 0) {
          throw new Exception(__("This is your only default theme you need to mark other theme as default before change/delete this one"));
        }
      }
      /* update */
      $db->query(sprintf(
        "UPDATE system_themes SET system_themes.default = %s, enabled = %s, name = %s, title = %s, fluid_design = %s, system_theme_night_on = %s, system_theme_mode_select = %s, system_theme_icons = %s, system_theme_fonts = %s, system_wallpaper_default = %s, system_wallpaper = %s, css_customized = %s, css_background = %s, css_link_color = %s, css_header = %s, css_header_search = %s, css_header_search_color = %s, css_btn_primary = %s, css_header_icons = %s, css_header_icons_night = %s, css_main_icons = %s, css_main_icons_night = %s, css_action_icons = %s, css_action_icons_night = %s, css_custome_css = %s, bottom_bar = %s, sidebar = %s, sidebar_more = %s WHERE theme_id = %s",
        secure($_POST['default']),
        secure($_POST['enabled']),
        secure($_POST['name']),
        secure($_POST['title']),
        secure($_POST['fluid_design']),
        secure($_POST['system_theme_night_on']),
        secure($_POST['system_theme_mode_select']),
        secure($_POST['system_theme_icons']),
        secure($_POST['system_theme_fonts']),
        secure($_POST['system_wallpaper_default']),
        secure($_POST['system_wallpaper']),
        secure($_POST['css_customized']),
        secure($_POST['css_background']),
        secure($_POST['css_link_color']),
        secure($_POST['css_header']),
        secure($_POST['css_header_search']),
        secure($_POST['css_header_search_color']),
        secure($_POST['css_btn_primary']),
        secure($_POST['css_header_icons']),
        secure($_POST['css_header_icons_night']),
        secure($_POST['css_main_icons']),
        secure($_POST['css_main_icons_night']),
        secure($_POST['css_action_icons']),
        secure($_POST['css_action_icons_night']),
        secure($_POST['css_custome_css']),
        secure($_POST['bottom_bar']),
        secure($_POST['sidebar']),
        secure($_POST['sidebar_more']),
        secure($_GET['id'], 'int')
      ));
      $persist_landings($_GET['id'], $landings);
      /* remove pending uploads */
      remove_pending_uploads([$_POST['system_wallpaper']]);
      /* return */
      return_json(['success' => true, 'message' => __("Theme info have been updated")]);
      break;

    case 'add':
      /* valid inputs */
      $_POST['name'] = $theme_path($_POST['name'] ?? '');
      $prepare_theme();
      $landings = $validate_landings();
      /* if default is set -> set all as not default first */
      if ($_POST['default']) {
        $db->query("UPDATE system_themes SET system_themes.default = '0'");
      }
      /* insert */
      $db->query(sprintf(
        "INSERT INTO system_themes (system_themes.default, enabled, name, title, fluid_design, system_theme_night_on, system_theme_mode_select, system_theme_icons, system_theme_fonts, system_wallpaper_default, system_wallpaper, css_customized, css_background, css_link_color, css_header, css_header_search, css_header_search_color, css_btn_primary, css_header_icons, css_header_icons_night, css_main_icons, css_main_icons_night, css_action_icons, css_action_icons_night, css_custome_css, bottom_bar, sidebar, sidebar_more) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)",
        secure($_POST['default']),
        secure($_POST['enabled']),
        secure($_POST['name']),
        secure($_POST['title']),
        secure($_POST['fluid_design']),
        secure($_POST['system_theme_night_on']),
        secure($_POST['system_theme_mode_select']),
        secure($_POST['system_theme_icons']),
        secure($_POST['system_theme_fonts']),
        secure($_POST['system_wallpaper_default']),
        secure($_POST['system_wallpaper']),
        secure($_POST['css_customized']),
        secure($_POST['css_background']),
        secure($_POST['css_link_color']),
        secure($_POST['css_header']),
        secure($_POST['css_header_search']),
        secure($_POST['css_header_search_color']),
        secure($_POST['css_btn_primary']),
        secure($_POST['css_header_icons']),
        secure($_POST['css_header_icons_night']),
        secure($_POST['css_main_icons']),
        secure($_POST['css_main_icons_night']),
        secure($_POST['css_action_icons']),
        secure($_POST['css_action_icons_night']),
        secure($_POST['css_custome_css']),
        secure($_POST['bottom_bar']),
        secure($_POST['sidebar']),
        secure($_POST['sidebar_more'])
      ));
      $persist_landings($db->insert_id, $landings);
      /* remove pending uploads */
      remove_pending_uploads([$_POST['system_wallpaper']]);
      /* return */
      return_json(['callback' => 'window.location = "' . $system['system_url'] . '/' . $control_panel['url'] . '/themes";']);
      break;

    default:
      _error(400);
      break;
  }
} catch (Exception $e) {
  return_json(['error' => true, 'message' => $e->getMessage()]);
}
