<?php

/**
 * ajax -> admin -> offers
 * 
 * @package Delus
 * @author Dmitry Sorokin - @sorydima & @sorydev Handles. 
 */

// fetch bootstrap
require('../../../bootstrap.php');

// check AJAX Request
is_ajax();

// check admin|moderator permission
if (!$user->_is_admin && ($user->_is_moderator && !$system['mods_offers_permission'])) {
  modal("MESSAGE", __("System Message"), __("You don't have the right permission to access this"));
}

// check demo account
if ($user->_data['user_demo']) {
  modal("ERROR", __("Demo Restriction"), __("You can't do this with demo account"));
}

// handle offers
try {

  switch ($_GET['do']) {
    case 'add_category':
      /* valid inputs */
      if (is_empty($_POST['category_name'])) {
        throw new Exception(__("Please enter a valid category name"));
      }
      if (!is_empty($_POST['category_order']) && !is_numeric($_POST['category_order'])) {
        throw new Exception(__("Please enter a valid category order"));
      }
      /* insert */
      $db->query(sprintf("INSERT INTO offers_categories (category_name, category_description, category_parent_id, category_order) VALUES (%s, %s, %s, %s)", secure($_POST['category_name']),  secure($_POST['category_description']), secure($_POST['category_parent_id'], 'int'), secure($_POST['category_order'], 'int')));
      /* return */
      return_json(['callback' => 'window.location = "' . $system['system_url'] . '/' . $control_panel['url'] . '/offers/categories";']);
      break;

    case 'edit_category':
      /* valid inputs */
      if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
        _error(400);
      }
      if (is_empty($_POST['category_name'])) {
        throw new Exception(__("Please enter a valid category name"));
      }
      if (!is_empty($_POST['category_order']) && !is_numeric($_POST['category_order'])) {
        throw new Exception(__("Please enter a valid category order"));
      }
      /* update */
      $db->query(sprintf("UPDATE offers_categories SET category_name = %s, category_description = %s, category_parent_id = %s, category_order = %s WHERE category_id = %s", secure($_POST['category_name']), secure($_POST['category_description']), secure($_POST['category_parent_id'], 'int'), secure($_POST['category_order'], 'int'), secure($_GET['id'], 'int')));
      /* return */
      return_json(['success' => true, 'message' => __("Category info have been updated")]);
      break;

    default:
      _error(400);
      break;
  }
} catch (Exception $e) {
  return_json(['error' => true, 'message' => $e->getMessage()]);
}
