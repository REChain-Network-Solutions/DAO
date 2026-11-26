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

  // check the id
  if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
    throw new Exception(__("Error: File not found"));
  }

  // get the backup
  if (($_GET['type'] ?? '') == 'backup') {
    if (!$user->_is_admin || $user->_data['user_demo']) {
      throw new Exception(__("Error: File not found"));
    }
    $backup = $user->get_backup($_GET['id']);
    $backup_file = (($_GET['file'] ?? '') == 'files') ? 'files' : 'database';
    if (!$backup || !isset($backup['files'][$backup_file])) {
      throw new Exception(__("Error: File not found"));
    }
    $base = realpath(ABSPATH . 'content/backups');
    $real_path = realpath($backup['files'][$backup_file]['path']);
    if (!$base || !$real_path || !str_starts_with($real_path, $base . DIRECTORY_SEPARATOR) || !is_file($real_path)) {
      throw new Exception(__("Error: File not found"));
    }
    /* release the session before the transfer */
    session_write_close();
    set_time_limit(0);
    while (ob_get_level() > 0) {
      ob_end_clean();
    }
    /* stream the file */
    header('Content-Description: File Transfer');
    header('Content-Type: application/octet-stream');
    header('Content-Disposition: attachment; filename="' . basename($real_path) . '"');
    header('Content-Length: ' . filesize($real_path));
    header('X-Accel-Buffering: no');
    readfile($real_path);
    exit;
  }

  // get the file
  if (in_array($_GET['type'] ?? '', ['message', 'message_media'])) {
    /* message file */
    $media_types = ($_GET['type'] == 'message_media') ? "'photo', 'video'" : "'file'";
    $get_media = $db->query(sprintf("SELECT conversations_messages_media.*, conversations_messages.conversation_id FROM conversations_messages_media INNER JOIN conversations_messages ON conversations_messages_media.message_id = conversations_messages.message_id WHERE conversations_messages_media.media_id = %s AND conversations_messages_media.media_type IN ($media_types)", secure($_GET['id'], 'int')));
    if ($get_media->num_rows == 0) {
      throw new Exception(__("Error: File not found"));
    }
    $file = $get_media->fetch_assoc();
    if ($file['media_type'] == 'photo' && $system['download_images_disabled']) {
      throw new Exception(__("Error: File not found"));
    }
    if ($file['media_type'] == 'video' && $system['download_videos_disabled']) {
      throw new Exception(__("Error: File not found"));
    }
    /* members, or report reviewers when the conversation is reported */
    $check_member = $db->query(sprintf("SELECT COUNT(*) as count FROM conversations_users WHERE conversation_id = %s AND user_id = %s", secure($file['conversation_id'], 'int'), secure($user->_data['user_id'], 'int')));
    if ($check_member->fetch_assoc()['count'] == 0) {
      $is_reviewer = ($user->_is_admin || ($user->_is_moderator && !empty($system['mods_reports_permission'])));
      if (!$is_reviewer) {
        throw new Exception(__("Error: File not found"));
      }
      $check_report = $db->query(sprintf("SELECT COUNT(*) as count FROM reports WHERE (node_type = 'conversation' AND node_id = %s) OR (node_type = 'message' AND node_id IN (SELECT message_id FROM conversations_messages WHERE conversation_id = %s))", secure($file['conversation_id'], 'int'), secure($file['conversation_id'], 'int')));
      if ($check_report->fetch_assoc()['count'] == 0) {
        throw new Exception(__("Error: File not found"));
      }
    }
    /* paid message access */
    $message = $user->get_conversation_message_by_id($file['message_id']);
    if (!$message || !empty($message['needs_payment']) || !empty($message['needs_age_verification'])) {
      throw new Exception(__("Error: File not found"));
    }
  } elseif (($_GET['type'] ?? '') == 'photo') {
    /* post photo */
    if ($system['download_images_disabled']) {
      throw new Exception(__("Error: File not found"));
    }
    $photo = $user->get_photo($_GET['id'], true);
    if (!$photo || empty($photo['source']) || !$photo['post']['can_get_details'] || $photo['post']['needs_payment'] || $photo['post']['needs_subscription'] || $photo['post']['needs_pro_package'] || $photo['post']['needs_age_verification']) {
      throw new Exception(__("Error: File not found"));
    }
    $file = ['source' => $photo['source']];
  } elseif (($_GET['type'] ?? '') == 'video') {
    /* post video */
    if ($system['download_videos_disabled']) {
      throw new Exception(__("Error: File not found"));
    }
    $post = $user->get_post($_GET['id'], false);
    if (!$post || empty($post['video']['source']) || !$post['can_get_details'] || $post['needs_payment'] || $post['needs_subscription'] || $post['needs_pro_package'] || $post['needs_age_verification']) {
      throw new Exception(__("Error: File not found"));
    }
    $file = ['source' => $post['video']['source']];
  } else {
    /* post file */
    $post = $user->get_post($_GET['id'], false);
    if (!$post) {
      throw new Exception(__("Error: File not found"));
    }
    $file = $post['file'] ?? [];
  }

  // reject traversal in the stored source
  $source = (string) ($file['source'] ?? '');
  if ($source === '' || str_contains($source, '..') || str_contains($source, "\0") || $source[0] === '/' || str_contains($source, '\\')) {
    throw new Exception(__("Error: File not found"));
  }

  // release the session before the transfer
  session_write_close();

  // stream the file
  $filename = !empty($file['name']) ? str_replace(['"', "\r", "\n"], '', html_entity_decode($file['name'], ENT_QUOTES)) : basename($source);
  $file_path = ABSPATH . $system['uploads_directory'] . '/' . $source;
  $base = realpath(ABSPATH . $system['uploads_directory']);
  $real_path = realpath($file_path);
  if ($base && $real_path && str_starts_with($real_path, $base . DIRECTORY_SEPARATOR) && is_file($real_path)) {
    header('Content-Description: File Transfer');
    header('Content-Type: application/octet-stream');
    header('Content-Disposition: attachment; filename="' . $filename . '"');
    header('Content-Length: ' . filesize($real_path));
    readfile($real_path);
    exit;
  }

  // stream from cloud storage
  $cloud_url = $system['system_uploads'] . '/' . $source;
  if (!function_exists('curl_init') || !filter_var($cloud_url, FILTER_VALIDATE_URL)) {
    throw new Exception(__("Error: Unable to fetch the file from the cloud"));
  }
  while (ob_get_level() > 0) {
    ob_end_clean();
  }
  $headers_sent = false;
  $status = 0;
  $length = 0;
  $ch = curl_init($cloud_url);
  curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
  curl_setopt($ch, CURLOPT_MAXREDIRS, 5);
  curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 20);
  curl_setopt($ch, CURLOPT_TIMEOUT, 0);
  curl_setopt($ch, CURLOPT_PROTOCOLS, CURLPROTO_HTTP | CURLPROTO_HTTPS);
  curl_setopt($ch, CURLOPT_REDIR_PROTOCOLS, CURLPROTO_HTTP | CURLPROTO_HTTPS);
  curl_setopt($ch, CURLOPT_HEADERFUNCTION, function ($ch, $header) use (&$headers_sent, &$status, &$length, $filename) {
    $line = trim($header);
    if (preg_match('#^HTTP/\d(?:\.\d)?\s+(\d+)#', $line, $matches)) {
      $status = (int) $matches[1];
      $length = 0;
      return strlen($header);
    }
    if (stripos($line, 'Content-Length:') === 0) {
      $length = (int) trim(substr($line, 15));
    }
    if ($line === '' && $status >= 200 && $status < 300 && !$headers_sent) {
      header('Content-Description: File Transfer');
      header('Content-Type: application/octet-stream');
      header('Content-Disposition: attachment; filename="' . $filename . '"');
      header('X-Accel-Buffering: no');
      if ($length > 0) {
        header('Content-Length: ' . $length);
      }
      $headers_sent = true;
    }
    return strlen($header);
  });
  curl_setopt($ch, CURLOPT_WRITEFUNCTION, function ($ch, $data) use (&$headers_sent, &$status) {
    if (!$headers_sent) {
      if ($status >= 300 && $status < 400) {
        return strlen($data);
      }
      return 0;
    }
    echo $data;
    flush();
    return strlen($data);
  });
  curl_exec($ch);
  if (!$headers_sent) {
    throw new Exception(__("Error: Unable to fetch the file from the cloud"));
  }
  exit;
} catch (Exception $e) {
  _error(__("Error"), $e->getMessage());
}
