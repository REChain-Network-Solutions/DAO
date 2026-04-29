<?php

/**
 * ajax -> payments -> coupon
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

try {

  // valid inputs
  if (!isset($_POST['handle']) || !isset($_POST['price']) || !isset($_POST['promo_code'])) {
    _error(400);
  }

  switch ($_POST['handle']) {
    case 'subscribe':
    case 'paid_post':
      /* check monetization coupon */
      $coupon = $user->check_monetization_coupon($_POST['promo_code']);
      if (!$coupon) {
        return_json(['error' => true, 'message' => __("This coupon is not valid or expired")]);
      }
      /* prepare price */
      $discount = $_POST['price'] * $coupon['discount_percent'] / 100;
      $price = $_POST['price'] - $discount;
      $vat = get_payment_vat_value($price);
      $fees = get_payment_fees_value($price);
      $total = get_payment_total_value($price);
      $total_printed = get_payment_total_value($price, true);
      $message = "🎉 " . __("Coupon applied successfully") . " (" . $coupon['discount_percent'] . "%)";
      /* return */
      return_json(['success' => true, 'message' => $message, 'price' => $price, 'vat' => $vat, 'fees' => $fees, 'discount' => $discount, 'discount_percentage' => $coupon['discount_percent'], 'total' => $total, 'total_printed' => $total_printed]);
      break;
    default:
      _error(400);
      break;
  }
} catch (Exception $e) {
  modal("ERROR", __("Error"), $e->getMessage());
}
