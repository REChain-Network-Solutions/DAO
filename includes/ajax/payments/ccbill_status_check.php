<?php

/**
 * ajax -> payments -> ccbill status check
 * 
 * @package Sngine
 * @author Zamblek
 */

// fetch bootstrap
require('../../../bootstrap.php');

// check AJAX Request
is_ajax();

// user access
user_access(true, true);

// check if CCBill enabled
if (!$system['ccbill_enabled']) {
  modal("MESSAGE", __("Error"), __("This feature has been disabled by the admin"));
}

try {

  // get the payment
  $payment = ccbill_get_payment();

  // check payment status
  if ($payment['payment_status'] == 'paid') {
    return_json(['callback' => 'window.location.href = "' . $payment['success_url'] . '";']);
  } else {
    return_json(['payment_status' => $payment['payment_status']]);
  }
} catch (Exception $e) {
  modal("ERROR", __("Error"), $e->getMessage());
}
