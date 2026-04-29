<?php

/**
 * ajax -> payments -> cash on delivery
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

// check if Cash On Delivery enabled
if (!$system['market_cod_payment_enabled']) {
  modal("MESSAGE", __("Error"), __("This feature has been disabled by the admin"));
}

try {

  // valid inputs
  if (!isset($_POST['orders_collection_id'])) {
    _error(400);
  }

  // get orders collection
  $orders_collection = $user->get_orders_collection($_POST['orders_collection_id']);
  /* check if order collection exists */
  if (!$orders_collection) {
    _error(400);
  }
  /* check if user can use cash on delivery */
  if (!$orders_collection['can_use_cod']) {
    modal("ERROR", __("Error"), __("You cannot use cash on delivery with digital products"));
  }
  /* check if user already paid to this order collection */
  if ($orders_collection['paid']) {
    modal("SUCCESS", __("Paid"), __("You already paid to this order"));
  }

  // payment
  /* mark orders collection as paid */
  $user->mark_orders_collection_as_paid($_POST['orders_collection_id'], true);

  // return  & exit
  return_json(['callback' => 'window.location = site_path + "/market/orders"']);
} catch (Exception $e) {
  modal("ERROR", __("Error"), $e->getMessage());
}
