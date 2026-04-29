<?php

/**
 * funding
 * 
 * @package Sngine
 * @author Zamblek
 */

// fetch bootloader
require('bootloader.php');

// funding enabled
if (!$system['funding_enabled']) {
  _error(404);
}

// user access
if ($user->_logged_in || !$system['system_public']) {
  user_access();
}

try {

  // page header
  page_header(__("Funding") . ' | ' . __($system['system_title']), __($system['system_description_funding']));

  // get selected country
  if (isset($_GET['country'])) {
    /* get selected country */
    $selected_country = $user->get_country_by_name($_GET['country']);
    /* assign variables */
    $smarty->assign('selected_country', $selected_country);
  }

  // get funding requests
  $smarty->assign('funding_requests', $user->get_funding(['country' => $selected_country['country_id']]));
} catch (Exception $e) {
  _error(__("Error"), $e->getMessage());
}

// page footer
page_footer('funding');
