<?php

/**
 * ajax -> admin -> design
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

// handle design
try {

  switch ($_GET['edit'] ?? '') {
    case 'general':
      /* prepare */
      $_POST['system_favicon_default'] = (isset($_POST['system_favicon_default'])) ? '1' : '0';
      $system_favicon = ($_POST['system_favicon_default']) ? '' : $_POST['system_favicon'];
      $_POST['system_ogimage_default'] = (isset($_POST['system_ogimage_default'])) ? '1' : '0';
      $system_ogimage = ($_POST['system_ogimage_default']) ? '' : $_POST['system_ogimage'];
      $_POST['themes_demo_enabled'] = (isset($_POST['themes_demo_enabled'])) ? '1' : '0';
      $_POST['themes_demo_hide_loggedin'] = (isset($_POST['themes_demo_hide_loggedin'])) ? '1' : '0';
      /* update */
      update_system_options([
        'system_logo' => secure($_POST['system_logo']),
        'system_logo_dark' => secure($_POST['system_logo_dark']),
        'system_favicon_default' => secure($_POST['system_favicon_default']),
        'system_favicon' => secure($system_favicon),
        'system_ogimage_default' => secure($_POST['system_ogimage_default']),
        'system_ogimage' => secure($system_ogimage),
        'themes_demo_enabled' => secure($_POST['themes_demo_enabled']),
        'themes_demo_hide_loggedin' => secure($_POST['themes_demo_hide_loggedin'])
      ]);
      /* remove pending uploads */
      remove_pending_uploads([$_POST['system_logo'], $_POST['system_logo_dark'], $_POST['system_favicon'], $_POST['system_ogimage']]);
      break;

    case 'landing':
      /* prepare */
      $_POST['play_store_badge_enabled'] = (isset($_POST['play_store_badge_enabled'])) ? '1' : '0';
      $_POST['appgallery_badge_enabled'] = (isset($_POST['appgallery_badge_enabled'])) ? '1' : '0';
      $_POST['app_store_badge_enabled'] = (isset($_POST['app_store_badge_enabled'])) ? '1' : '0';
      /* update */
      update_system_options([
        'play_store_badge_enabled' => secure($_POST['play_store_badge_enabled']),
        'appgallery_badge_enabled' => secure($_POST['appgallery_badge_enabled']),
        'appgallery_store_link' => secure($_POST['appgallery_store_link']),
        'play_store_link' => secure($_POST['play_store_link']),
        'app_store_badge_enabled' => secure($_POST['app_store_badge_enabled']),
        'app_store_link' => secure($_POST['app_store_link'])
      ]);
      break;

    case 'code':
      /* update */
      update_system_options([
        'custome_js_header' => secure($_POST['custome_js_header']),
        'custome_js_footer' => secure($_POST['custome_js_footer'])
      ]);
      break;

    case 'module_names':
      /* prepare */
      $module_names = module_names_values($_POST['module_names'] ?? []);
      foreach ($module_names as $module_name) {
        if (isset($module_name['singular']) != isset($module_name['plural'])) {
          throw new Exception(__("You must enter both the singular and the plural name"));
        }
      }
      /* update */
      update_system_options([
        'module_names' => secure(($module_names) ? json_encode($module_names) : '')
      ]);
      break;

    case '':
      /* legacy single-form save */
      $_POST['system_favicon_default'] = (isset($_POST['system_favicon_default'])) ? '1' : '0';
      $system_favicon = ($_POST['system_favicon_default']) ? '' : $_POST['system_favicon'];
      $_POST['system_ogimage_default'] = (isset($_POST['system_ogimage_default'])) ? '1' : '0';
      $system_ogimage = ($_POST['system_ogimage_default']) ? '' : $_POST['system_ogimage'];
      $_POST['play_store_badge_enabled'] = (isset($_POST['play_store_badge_enabled'])) ? '1' : '0';
      $_POST['appgallery_badge_enabled'] = (isset($_POST['appgallery_badge_enabled'])) ? '1' : '0';
      $_POST['app_store_badge_enabled'] = (isset($_POST['app_store_badge_enabled'])) ? '1' : '0';
      update_system_options([
        'system_logo' => secure($_POST['system_logo']),
        'system_logo_dark' => secure($_POST['system_logo_dark']),
        'system_favicon_default' => secure($_POST['system_favicon_default']),
        'system_favicon' => secure($system_favicon),
        'system_ogimage_default' => secure($_POST['system_ogimage_default']),
        'system_ogimage' => secure($system_ogimage),
        'play_store_badge_enabled' => secure($_POST['play_store_badge_enabled']),
        'appgallery_badge_enabled' => secure($_POST['appgallery_badge_enabled']),
        'appgallery_store_link' => secure($_POST['appgallery_store_link']),
        'play_store_link' => secure($_POST['play_store_link']),
        'app_store_badge_enabled' => secure($_POST['app_store_badge_enabled']),
        'app_store_link' => secure($_POST['app_store_link']),
        'custome_js_header' => secure($_POST['custome_js_header']),
        'custome_js_footer' => secure($_POST['custome_js_footer'])
      ]);
      remove_pending_uploads([$_POST['system_logo'], $_POST['system_logo_dark'], $_POST['system_favicon'], $_POST['system_ogimage']]);
      return_json(['callback' => 'window.location.reload();']);
      break;

    default:
      _error(400);
      break;
  }

  /* return */
  return_json(['success' => true, 'message' => __("Settings have been updated")]);
} catch (Exception $e) {
  return_json(['error' => true, 'message' => $e->getMessage()]);
}
