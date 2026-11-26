<?php

/**
 * files
 * 
 * @package Sngine
 * @author Zamblek
 */

// fetch bootstrap
require('bootstrap.php');

try {
  // check if user not logged in (except for requests from mobile apps)
  if (!valid_api_request() && !$system['system_public'] && !$user->_logged_in) {
    user_login();
  }

  // confine the requested path to the uploads directory
  $req = (string) ($_GET['file'] ?? '');
  if ($req === '' || str_contains($req, '..') || str_contains($req, "\0") || $req[0] === '/' || str_contains($req, '\\')) {
    throw new Exception(__("File not found"));
  }
  $base = realpath(ABSPATH . $system['uploads_directory']);
  $file = realpath(ABSPATH . $system['uploads_directory'] . '/' . $req);
  if (!$base || !$file || !str_starts_with($file, $base . DIRECTORY_SEPARATOR) || !is_file($file)) {
    throw new Exception(__("File not found"));
  }

  // read the file contents and send the response
  $handle = fopen($file, "rb");
  $contents = fread($handle, filesize($file));
  fclose($handle);
  $content_type = mime_content_type($file);
  header("Content-type: " . $content_type);
  header("Content-disposition: inline; filename=" . basename($file));
  echo $contents;
} catch (Exception $e) {
  _error(__("Error"), $e->getMessage());
}
