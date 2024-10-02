<?php

/**
 * ajax -> posts -> product
 * 
 * @package Delus
 * @author Dmitry
 */

// fetch bootstrap
require('../../../bootstrap.php');

// check AJAX Request
is_ajax();

// user access
user_access(true);

// check demo account
if ($user->_data['user_demo']) {
  modal("ERROR", __("Demo Restriction"), __("You can't do this with demo account"));
}

// check if market enabled
if (!$system['market_enabled']) {
  modal("MESSAGE", __("Error"), __("This feature has been disabled by the admin"));
}

// check market permission
if (!$user->_data['can_sell_products']) {
  modal("MESSAGE", __("Error"), __("You don't have the permission to do this"));
}

try {

  // initialize the return array
  $return = [];

  switch ($_REQUEST['do']) {
    case 'create':
      // valid inputs
      if (isset($_GET['page'])) {
        $share_to = "page";
        $share_to_id = (int) $_GET['page'];
      } elseif (isset($_GET['group'])) {
        $share_to = "group";
        $share_to_id = (int) $_GET['group'];
      } elseif (isset($_GET['event'])) {
        $share_to = "event";
        $share_to_id = (int) $_GET['event'];
      }

      // check products count permission
      if ($user->_data['user_products_limit'] > 0 && (!$user->_is_admin || !$user->_is_moderator)) {
        $user_products_count = $user->get_user_products_count();
        if ($user_products_count >= $user->_data['user_products_limit']) {
          modal("MESSAGE", __("Error"), __("You have reached the maximum products limit"));
        }
      }

      // assign variables
      $smarty->assign('share_to', $share_to);
      $smarty->assign('share_to_id', $share_to_id);
      $smarty->assign('market_categories', $user->get_categories("market_categories"));
      $smarty->assign('custom_fields', $user->get_custom_fields(["for" => "product"]));

      // return
      $return['template'] = $smarty->fetch("ajax.product.publisher.tpl");
      $return['callback'] = "$('#modal').modal('show'); $('.modal-content:last').html(response.template); initialize_modal();";
      break;

    case 'publish':
      // check products count permission
      if ($user->_data['user_products_limit'] > 0 && (!$user->_is_admin || !$user->_is_moderator)) {
        $user_products_count = $user->get_user_products_count();
        if ($user_products_count >= $user->_data['user_products_limit']) {
          modal("MESSAGE", __("Error"), __("You have reached the maximum products limit"));
        }
      }

      // valid inputs
      /* filter product */
      if (!isset($_POST['product'])) {
        _error(400);
      }
      $_POST['product'] = json_decode($_POST['product']);
      if (!is_object($_POST['product'])) {
        _error(400);
      }
      /* check if product digital and has no file nor link */
      if ($_POST['product']->is_digital == "1" && is_empty($_POST['product']->product_url) && is_empty($_POST['product']->product_file)) {
        return_json(['error' => true, 'message' => __("Please add your product file or download URL")]);
      }
      /* check product download URL */
      if (!is_empty($_POST['product']->product_url) && !valid_url($_POST['product']->product_url)) {
        return_json(['error' => true, 'message' => __("Please add valid product download URL")]);
      }
      /* check product name */
      if (is_empty($_POST['product']->name)) {
        return_json(['error' => true, 'message' => __("Please add your product name")]);
      }
      /* check product quantity */
      if (is_empty($_POST['product']->quantity)) {
        return_json(['error' => true, 'message' => __("Please add your product quantity")]);
      }
      if (!is_numeric($_POST['product']->quantity) || $_POST['product']->quantity <= 0) {
        return_json(['error' => true, 'message' => __("Please add valid product quantity")]);
      }
      /* check product price */
      if (is_empty($_POST['product']->price)) {
        return_json(['error' => true, 'message' => __("Please add your product price")]);
      }
      if (!is_numeric($_POST['product']->price) || $_POST['product']->price < 0) {
        return_json(['error' => true, 'message' => __("Please add valid product price (0 for free or more)")]);
      }
      /* check product category */
      if (!$user->get_category("market_categories", $_POST['product']->category)) {
        return_json(['error' => true, 'message' => __("Please select valid product category")]);
      }
      /* check product status */
      if (!in_array($_POST['product']->status, ['new', 'old'])) {
        return_json(['error' => true, 'message' => __("Please select valid product status")]);
      }
      /* filter photos */
      $photos = [];
      if (isset($_POST['photos'])) {
        $_POST['photos'] = json_decode($_POST['photos']);
        if (!is_object($_POST['photos'])) {
          _error(400);
        }
        /* filter the photos */
        foreach ($_POST['photos'] as $photo) {
          $photos[] = (array) $photo;
        }
        if (count($photos) == 0) {
          _error(400);
        }
      }
      /* set custom fields */
      try {
        $inputs['custom_fields'] = $user->set_custom_fields($_POST['product'], 'product');
      } catch (Exception $e) {
        return_json(['error' => true, 'message' => $e->getMessage()]);
      }

      /* prepare inputs */
      $inputs['privacy'] = "public";
      $inputs['handle'] = "me";
      if (isset($_POST['product']->handle)) {
        if (!in_array($_POST['product']->handle, ['page', 'group', 'event'])) {
          _error(400);
        }
        $inputs['handle'] = $_POST['product']->handle;
        $inputs['id'] = $_POST['product']->id;
        $inputs['privacy'] = in_array($_POST['product']->handle, ['group', 'event']) ? "custom" : "public";
      }
      $inputs['is_anonymous'] = '0';
      $inputs['message'] = $_POST['message'];
      $inputs['product'] = $_POST['product'];
      $inputs['photos'] = $photos;

      // publish
      $post = $user->publisher($inputs);

      // return
      $return['callback'] = "window.location = '" . $system['system_url'] . "/posts/" . $post['post_id'] . "';";
      break;

    case 'edit':
      // valid inputs
      if (!isset($_GET['post_id']) || !is_numeric($_GET['post_id'])) {
        _error(400);
      }

      // get post
      $post = $user->get_post($_GET['post_id']);
      if (!$post) {
        _error(400);
      }
      /* assign variables */
      $smarty->assign('post', $post);
      $smarty->assign('market_categories', $user->get_categories("market_categories"));
      $smarty->assign('custom_fields', $user->get_custom_fields(["for" => "product", "get" => "settings", "node_id" => $_GET['post_id']]));

      // return
      $return['template'] = $smarty->fetch("ajax.product.editor.tpl");
      $return['callback'] = "$('#modal').modal('show'); $('.modal-content:last').html(response.template); initialize_modal();";
      break;

    default:
      _error(400);
      break;
  }

  // return & exit
  return_json($return);
} catch (Exception $e) {
  modal("ERROR", __("Error"), $e->getMessage());
}
