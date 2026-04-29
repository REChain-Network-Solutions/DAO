<?php

/**
 * downloads
 * 
 * @package Sngine
 * @author Zamblek
 */

// fetch bootstrap
require('bootstrap.php');

try {
  // check if user not logged
  if (!$user->_logged_in) {
    user_login();
  }

  // check the post id
  if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
    throw new Exception(__("Error: File not found"));
  }

  // get post
  $post = $user->get_post($_GET['id']);
  if (!$post) {
    throw new Exception(__("Error: File not found"));
  }

  // stream the file
  $file_path = $system['uploads_directory'] . '/' . $post['file']['source'];
  if (file_exists($file_path)) {
    $filename = basename($file_path);
    header('Content-Description: File Transfer');
    header('Content-Type: application/octet-stream');
    header('Content-Disposition: attachment; filename="' . $filename . '"');
    header('Content-Length: ' . filesize($file_path));
    readfile($file_path);
    exit;
  } else {
    $cloud_file_path = $system['system_uploads'] . '/' . $post['file']['source'];
    $cloud_file = fopen($cloud_file_path, 'rb');
    if (!$cloud_file) {
      throw new Exception(__("Error: Unable to fetch the file from the cloud"));
    }
    $filename = basename($file_path);
    $file_size = get_headers($cloud_file_path, 1)['Content-Length'] ?? null;
    header('Content-Description: File Transfer');
    header('Content-Type: application/octet-stream');
    header('Content-Disposition: attachment; filename="' . $filename . '"');
    if ($file_size) {
      header('Content-Length: ' . $file_size);
    }
    while (!feof($cloud_file)) {
      echo fread($cloud_file, 8192);
      flush();
    }
    fclose($cloud_file);
    exit;
  }
} catch (Exception $e) {
  _error(__("Error"), $e->getMessage());
}
