<?php

/**
 * ajax -> admin -> static
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich - Handles - @sorydima @sorydev @durovshater @DmitrySoro90935 @tanechfund - also check https://dmitry.rechain.network for more information!
 */

// fetch bootstrap
require('../../../bootstrap.php');

// check AJAX Request
is_ajax();

// check admin|moderator permission
if (!$user->_is_admin && ($user->_is_moderator && !$system['mods_customization_permission'])) {
  modal("MESSAGE", __("System Message"), __("You don't have the right permission to access this"));
}

// check demo account
if ($user->_data['user_demo']) {
  modal("ERROR", __("Demo Restriction"), __("You can't do this with demo account"));
}

// handle static
try {

  switch ($_GET['do']) {
    case 'edit':
      /* get page */
      $get_static_page = $db->query(sprintf("SELECT * FROM static_pages WHERE page_id = %s", secure($_GET['id'], 'int')));
      if ($get_static_page->num_rows == 0) {
        _error(400);
      }
      $static_page = $get_static_page->fetch_assoc();
      /* prepare */
      $_POST['page_is_redirect'] = (isset($_POST['page_is_redirect'])) ? '1' : '0';
      $_POST['page_in_footer'] = (isset($_POST['page_in_footer'])) ? '1' : '0';
      $_POST['page_in_sidebar'] = (isset($_POST['page_in_sidebar'])) ? '1' : '0';
      /* valid inputs */
      if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
        _error(400);
      }
      if (is_empty($_POST['page_title'])) {
        throw new Exception(__("You must enter a title for your page"));
      }
      if ($_POST['page_is_redirect']) {
        if (is_empty($_POST['page_redirect_url']) || !valid_url($_POST['page_redirect_url'])) {
          throw new Exception(__("Please enter a valid URL to redirect to"));
        }
        $_POST['page_url'] = 'null';
      } else {
        if (is_empty($_POST['page_url']) || !valid_username($_POST['page_url'])) {
          throw new Exception(__("Please enter a valid URL to your page"));
        }
        if ($_POST['page_url'] != $static_page['page_url']) {
          $check_url = $db->query(sprintf("SELECT * FROM static_pages WHERE page_url = %s", secure($_POST['page_url'])));
          if ($check_url->num_rows > 0) {
            throw new Exception(__("Sorry, it looks like") . " <strong>" . $_POST['page_url'] . "</strong> " . __("belongs to an existing static page"));
          }
        }
        $_POST['page_redirect_url'] = 'null';
      }
      /* check if the page is in sidebar menu */
      if ($_POST['page_in_sidebar']) {
        if (is_empty($_POST['page_icon'])) {
          throw new Exception(__("You must enter an icon for your page"));
        }
      }
      /* update */
      $db->query(sprintf("UPDATE static_pages SET page_title = %s, page_is_redirect = %s, page_redirect_url = %s, page_url = %s, page_text = %s, page_in_footer = %s, page_in_sidebar = %s, page_icon = %s, page_order = %s WHERE page_id = %s", secure($_POST['page_title']), secure($_POST['page_is_redirect']), secure($_POST['page_redirect_url']), secure($_POST['page_url']), secure($_POST['page_text']), secure($_POST['page_in_footer']), secure($_POST['page_in_sidebar']), secure($_POST['page_icon']), secure($_POST['page_order'], 'int'), secure($_GET['id'], 'int')));
      /* extract hosted images from the text */
      $uploaded_images = extract_uploaded_images_from_text($_POST['page_text']);
      /* remove pending uploads */
      if ($uploaded_images) {
        remove_pending_uploads($uploaded_images);
      }
      /* remove pending uploads */
      remove_pending_uploads([$_POST['page_icon']]);
      /* return */
      return_json(['success' => true, 'message' => __("Static page info have been updated")]);
      break;

    case 'add':
      /* prepare */
      $_POST['page_is_redirect'] = (isset($_POST['page_is_redirect'])) ? '1' : '0';
      $_POST['page_in_footer'] = (isset($_POST['page_in_footer'])) ? '1' : '0';
      $_POST['page_in_sidebar'] = (isset($_POST['page_in_sidebar'])) ? '1' : '0';
      /* valid inputs */
      if (is_empty($_POST['page_title'])) {
        throw new Exception(__("You must enter a title for your page"));
      }
      if ($_POST['page_is_redirect']) {
        if (is_empty($_POST['page_redirect_url']) || !valid_url($_POST['page_redirect_url'])) {
          throw new Exception(__("Please enter a valid URL to redirect to"));
        }
        $_POST['page_url'] = 'null';
      } else {
        if (is_empty($_POST['page_url']) || !valid_username($_POST['page_url'])) {
          throw new Exception(__("Please enter a valid URL to your page"));
        }
        $check_url = $db->query(sprintf("SELECT * FROM static_pages WHERE page_url = %s", secure($_POST['page_url'])));
        if ($check_url->num_rows > 0) {
          throw new Exception(__("Sorry, it looks like") . " <strong>" . $_POST['page_url'] . "</strong> " . __("belongs to an existing static page"));
        }
        $_POST['page_redirect_url'] = 'null';
      }
      /* check if the page is in sidebar menu */
      if ($_POST['page_in_sidebar']) {
        if (is_empty($_POST['page_icon'])) {
          throw new Exception(__("You must enter an icon for your page"));
        }
      }
      /* insert */
      $db->query(sprintf("INSERT INTO static_pages (page_title, page_is_redirect, page_redirect_url, page_url, page_text, page_in_footer, page_in_sidebar, page_icon, page_order) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)", secure($_POST['page_title']), secure($_POST['page_is_redirect']), secure($_POST['page_redirect_url']), secure($_POST['page_url']), secure($_POST['page_text']), secure($_POST['page_in_footer']), secure($_POST['page_in_sidebar']), secure($_POST['page_icon']), secure($_POST['page_order'], 'int')));
      /* extract hosted images from the text */
      $uploaded_images = extract_uploaded_images_from_text($_POST['page_text']);
      /* remove pending uploads */
      if ($uploaded_images) {
        remove_pending_uploads($uploaded_images);
      }
      /* remove pending uploads */
      remove_pending_uploads([$_POST['page_icon']]);
      /* return */
      return_json(['callback' => 'window.location = "' . $system['system_url'] . '/' . $control_panel['url'] . '/static";']);
      break;

    default:
      _error(400);
      break;
  }
} catch (Exception $e) {
  return_json(['error' => true, 'message' => $e->getMessage()]);
}
