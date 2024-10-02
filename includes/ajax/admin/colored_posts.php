<?php

/**
 * ajax -> admin -> colored posts
 * 
 * @package Delus
 * @author Dmitry
 */

// fetch bootstrap
require('../../../bootstrap.php');

// check AJAX Request
is_ajax();

// check admin|moderator permission
if (!$user->_is_admin) {
  modal("MESSAGE", __("System Message"), __("You don't have the right permission to access this"));
}

// check demo account
if ($user->_data['user_demo']) {
  modal("ERROR", __("Demo Restriction"), __("You can't do this with demo account"));
}

// handle colored posts
try {

  switch ($_GET['do']) {
    case 'edit':
      /* valid inputs */
      if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
        _error(400);
      }
      if (!in_array($_POST['type'], ['color', 'image'])) {
        throw new Exception(__("You have to select a valid pattern type"));
      }
      if ($_POST['type'] == "color") {
        if (is_empty($_POST['background_color_1'])) {
          throw new Exception(__("You have to select the color 1"));
        }
        if (is_empty($_POST['background_color_2'])) {
          throw new Exception(__("You have to select the color 2"));
        }
      } else {
        if (is_empty($_POST['background_image'])) {
          throw new Exception(__("You have to upload the background image"));
        }
      }
      if (is_empty($_POST['text_color'])) {
        throw new Exception(__("You have to select the text color"));
      }
      /* update */
      $db->query(sprintf("UPDATE posts_colored_patterns SET type = %s, background_image = %s, background_color_1 = %s, background_color_2 = %s, text_color = %s WHERE pattern_id = %s", secure($_POST['type']), secure($_POST['background_image']), secure($_POST['background_color_1']), secure($_POST['background_color_2']), secure($_POST['text_color']), secure($_GET['id'], 'int')));
      /* return */
      return_json(['success' => true, 'message' => __("Pattern info have been updated")]);
      break;

    case 'add':
      /* valid inputs */
      if (!in_array($_POST['type'], ['color', 'image'])) {
        throw new Exception(__("You have to select a valid pattern type"));
      }
      if ($_POST['type'] == "color") {
        if (is_empty($_POST['background_color_1'])) {
          throw new Exception(__("You have to select the color 1"));
        }
        if (is_empty($_POST['background_color_2'])) {
          throw new Exception(__("You have to select the color 2"));
        }
      } else {
        if (is_empty($_POST['background_image'])) {
          throw new Exception(__("You have to upload the background image"));
        }
      }
      if (is_empty($_POST['text_color'])) {
        throw new Exception(__("You have to select the text color"));
      }
      /* insert */
      $db->query(sprintf("INSERT INTO posts_colored_patterns (type, background_image, background_color_1, background_color_2, text_color) VALUES (%s, %s, %s, %s, %s)", secure($_POST['type']), secure($_POST['background_image']), secure($_POST['background_color_1']), secure($_POST['background_color_2']), secure($_POST['text_color'])));
      /* return */
      return_json(['callback' => 'window.location = "' . $system['system_url'] . '/' . $control_panel['url'] . '/colored_posts";']);
      break;

    default:
      _error(400);
      break;
  }
} catch (Exception $e) {
  return_json(['error' => true, 'message' => $e->getMessage()]);
}
