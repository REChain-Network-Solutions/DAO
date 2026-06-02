<?php

/**
 * ccbill status
 *
 * @package Sngine
 * @author Zamblek
 */

// fetch bootloader
require('bootloader.php');

// user access
user_access();

try {

  // get the payment
  $payment = ccbill_get_payment();

  // assign variables
  $smarty->assign('payment', $payment);
} catch (Exception $e) {
  _error(__("Error"), $e->getMessage());
}

// page footer
page_footer('ccbill_status');
