<?php

/**
 * embed
 * 
 * @package Sngine
 * @author Zamblek
 */

// fetch bootloader
require('bootloader.php');

// allow embedding in external iframes
allow_iframe_embedding();

// valid inputs
if (!isset($_GET['post_id']) || !is_numeric($_GET['post_id'])) {
  _error(404);
}

try {

  // get post
  $post = $user->get_post($_GET['post_id']);
  if (!$post) {
    _error(404);
  }

  // check if post is embeddable
  if ($post['post_type'] != 'video') {
    _error(404);
  }
  if ($post['privacy'] != 'public') {
    _error(404);
  }
  if ($post['still_scheduled']) {
    _error(404);
  }
  if (!$post['can_get_details']) {
    _error(404);
  }
  if (!$post['video']) {
    _error(404);
  }

  /* assign variables */
  $smarty->assign('post', $post);
} catch (Exception $e) {
  _error(__("Error"), $e->getMessage());
}

// allow embedding in external iframes
allow_iframe_embedding();

// page header
page_header($post['og_title'], $post['og_description'], $post['og_image']);

// page footer
page_footer('embed');
