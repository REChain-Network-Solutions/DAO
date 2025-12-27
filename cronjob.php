<?php

/**
 * cronjob
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich
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
