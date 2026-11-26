<?php

/**
 * ajax -> admin -> sitemap
 *
 * @package Sngine
 * @author Zamblek
 */

// set execution time
set_time_limit(0); /* unlimited max execution time */

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

// handle sitemap
try {

  switch ($_GET['do']) {
    case 'settings':
      /* prepare */
      $_POST['sitemap_enabled'] = (isset($_POST['sitemap_enabled'])) ? '1' : '0';
      $_POST['sitemap_images_enabled'] = (isset($_POST['sitemap_images_enabled'])) ? '1' : '0';
      $_POST['sitemap_videos_enabled'] = (isset($_POST['sitemap_videos_enabled'])) ? '1' : '0';
      $_POST['indexnow_enabled'] = (isset($_POST['indexnow_enabled'])) ? '1' : '0';
      $sitemap_types = array_intersect(array_keys($user->sitemap_types()), (array) ($_POST['sitemap_types'] ?? []));
      /* valid inputs */
      if (!ctype_digit((string) $_POST['sitemap_urls_per_file']) || $_POST['sitemap_urls_per_file'] < 1000 || $_POST['sitemap_urls_per_file'] > 50000) {
        throw new Exception(__("URLs per file must be a number between 1,000 and 50,000"));
      }
      if (!ctype_digit((string) $_POST['sitemap_refresh']) || $_POST['sitemap_refresh'] < 1) {
        throw new Exception(__("You must enter a valid refresh interval"));
      }
      /* indexnow key */
      $indexnow_key = (is_empty($system['indexnow_key'])) ? md5(uniqid('', true)) : $system['indexnow_key'];
      /* update */
      update_system_options([
        'sitemap_enabled' => secure($_POST['sitemap_enabled']),
        'sitemap_types' => secure(implode(',', $sitemap_types)),
        'sitemap_urls_per_file' => secure($_POST['sitemap_urls_per_file']),
        'sitemap_refresh' => secure($_POST['sitemap_refresh']),
        'sitemap_images_enabled' => secure($_POST['sitemap_images_enabled']),
        'sitemap_videos_enabled' => secure($_POST['sitemap_videos_enabled']),
        'indexnow_enabled' => secure($_POST['indexnow_enabled']),
        'indexnow_key' => secure($indexnow_key),
      ]);
      /* reset sitemaps */
      if ($_POST['sitemap_urls_per_file'] != $system['sitemap_urls_per_file'] || $_POST['sitemap_images_enabled'] != $system['sitemap_images_enabled'] || $_POST['sitemap_videos_enabled'] != $system['sitemap_videos_enabled']) {
        $user->sitemap_reset();
      }
      /* return */
      return_json(['success' => true, 'message' => __("Settings have been updated")]);
      break;

    case 'robots':
      /* update */
      update_system_options([
        'robots_txt' => secure($_POST['robots_txt']),
      ]);
      /* return */
      return_json(['success' => true, 'message' => __("Settings have been updated")]);
      break;

    case 'llms':
      /* prepare */
      $_POST['llms_enabled'] = (isset($_POST['llms_enabled'])) ? '1' : '0';
      /* update */
      update_system_options([
        'llms_enabled' => secure($_POST['llms_enabled']),
        'llms_notes' => secure($_POST['llms_notes']),
      ]);
      /* return */
      return_json(['success' => true, 'message' => __("Settings have been updated")]);
      break;

    case 'rebuild':
      /* check if sitemap enabled */
      if (!$system['sitemap_enabled']) {
        throw new Exception(__("You have to enable the sitemap first"));
      }
      // [BACKGROUND PROCESS]
      /* return async */
      return_json_async(['success' => true, 'message' => __("Your request has been sent successfully and will be processed in the background")]);
      /* rebuild sitemaps */
      $user->sitemap_refresh();
      /* post async notification */
      $user->post_notification_async(__("Sitemaps have been rebuilt"));
      /* return */
      return_json(['success' => true, 'message' => __("Sitemaps have been rebuilt")]);
      break;

    default:
      _error(400);
      break;
  }
} catch (Exception $e) {
  return_json(['error' => true, 'message' => $e->getMessage()]);
}
