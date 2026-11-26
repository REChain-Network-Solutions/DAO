<?php

/**
 * cronjob
 * 
 * @package Sngine
 * @author Zamblek
 */

// fetch bootloader
require('bootloader.php');

// check if hash is valid
if (!isset($_GET['hash']) || $_GET['hash'] != $system['cronjob_hash']) {
  exit;
}

// check if cronjob is enabled
if (!$system['cronjob_enabled']) {
  exit;
}

// update last run time
update_system_options(['cronjob_last_run' => secure($date)]);

// run tasks

/* [1] deliver all shipped undelivered orders */
if ($system['cronjob_undelivered_orders'] && $system['market_enabled']) {
  $user->deliver_undelivered_orders();
}

/* [2] reset pro packages */
if ($system['cronjob_reset_pro_packages'] && $system['packages_enabled']) {
  $user->check_users_package();
}

/* [3] clear pending uploads */
if ($system['cronjob_clear_pending_uploads']) {
  clear_pending_uploads();
}

/* [4] merits reminder */
if ($system['cronjob_merits_reminder'] && $system['merits_enabled'] && $system['merits_notifications_reminder']) {
  $user->merits_reminder();
}

/* [5] write post views counted in Redis */
if (redis()) {
  $user->flush_post_views();
}

/* [6] clear expired post views */
if ($system['cronjob_post_views_cleanup']) {
  try {
    $user->clean_expired_post_views();
  } catch (Throwable $e) {
    error_log('Post views cleanup: ' . $e->getMessage());
  }
}

/* [7] build posts search index */
if (empty($system['posts_search_ready'])) {
  try {
    $search_index_deadline = time() + 15;
    while ($user->rebuild_posts_search() > 0 && time() < $search_index_deadline);
  } catch (Throwable $e) {
    error_log('Post search index: ' . $e->getMessage());
  }
}

/* [8] refresh sitemaps */
if ($system['sitemap_enabled'] && $system['system_public']) {
  try {
    $user->sitemap_refresh(time() + 15);
  } catch (Throwable $e) {
    error_log('Sitemap: ' . $e->getMessage());
  }
}

/* [9] clear expired stories */
if ($system['stories_enabled']) {
  try {
    $user->clean_expired_stories();
  } catch (Throwable $e) {
    error_log('Stories cleanup: ' . $e->getMessage());
  }
}
