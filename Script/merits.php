<?php

/**
 * merits
 * 
 * @package Sngine
 * @author Zamblek
 */

// fetch bootloader
require('bootloader.php');

// user access
user_access();

try {

  // page header
  page_header(__("Merits") . ' | ' . __($system['system_title']));

  // get merits categories
  $smarty->assign('merits_categories', $user->get_categories("merits_categories"));

  // get merits ranking
  $config = [];
  if (isset($_GET['category'])) {
    $config['category'] = $_GET['category'];
  }
  if (isset($_GET['start_date']) && !empty($_GET['start_date'])) {
    $config['start_date'] = $_GET['start_date'];
  }
  if (isset($_GET['end_date']) && !empty($_GET['end_date'])) {
    $config['end_date'] = $_GET['end_date'];
  }
  $smarty->assign('merits_ranking_users', $user->get_merits_ranking($config));
  $smarty->assign('config', $config);
} catch (Exception $e) {
  _error(__("Error"), $e->getMessage());
}

// page footer
page_footer('merits');
