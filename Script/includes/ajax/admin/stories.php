<?php

/**
 * ajax -> admin -> stories
 * 
 * @package Sngine
 * @author Zamblek
 */

// fetch bootstrap
require('../../../bootstrap.php');

// check AJAX Request
is_ajax();

// check admin|moderator permission
admin_access('mods_stories_permission');

// check demo account
if ($user->_data['user_demo']) {
  modal("ERROR", __("Demo Restriction"), __("You can't do this with demo account"));
}

// handle stories
try {

  switch ($_GET['do']) {
    case 'add_music':
    case 'edit_music':
      /* valid inputs */
      if (is_empty($_POST['title'])) {
        throw new Exception(__("Please enter a valid title"));
      }
      if (!is_valid_upload_source($_POST['source'] ?? null) || !str_starts_with($_POST['source'], 'sounds/')) {
        throw new Exception(__("Please upload the audio file"));
      }
      $cover = $_POST['cover'] ?? '';
      if ($cover && (!is_valid_upload_source($cover) || !str_starts_with($cover, 'photos/'))) {
        throw new Exception(__("Please upload a valid cover"));
      }
      if ($_GET['do'] == 'edit_music') {
        /* valid inputs */
        if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
          _error(400);
        }
        $get_track = $db->query(sprintf("SELECT * FROM stories_music WHERE provider = 'library' AND music_id = %s", secure($_GET['id'], 'int')));
        if ($get_track->num_rows == 0) {
          _error(400);
        }
        $track = $get_track->fetch_assoc();
        /* update */
        $db->query(sprintf("UPDATE stories_music SET title = %s, artist = %s, cover = %s, source = %s, updated_at = %s WHERE music_id = %s", secure($_POST['title']), secure($_POST['artist'] ?? ''), secure($cover), secure($_POST['source']), secure($date), secure($_GET['id'], 'int')));
        /* remove pending uploads */
        remove_pending_uploads(array_filter([$_POST['source'], $cover]));
        /* delete replaced files */
        if ($track['source'] != $_POST['source']) {
          delete_uploads_file($track['source']);
        }
        if ($track['cover'] && $track['cover'] != $cover) {
          delete_uploads_file($track['cover']);
        }
        /* return */
        return_json(['success' => true, 'message' => __("Track info have been updated")]);
      }
      /* insert */
      $db->query(sprintf("INSERT INTO stories_music (provider, title, artist, cover, source, time, updated_at) VALUES ('library', %s, %s, %s, %s, %s, %s)", secure($_POST['title']), secure($_POST['artist'] ?? ''), secure($cover), secure($_POST['source']), secure($date), secure($date)));
      /* remove pending uploads */
      remove_pending_uploads(array_filter([$_POST['source'], $cover]));
      /* return */
      return_json(['callback' => 'window.location = "' . $system['system_url'] . '/' . $control_panel['url'] . '/stories/music";']);
      break;

    case 'enable_music':
    case 'disable_music':
      /* valid inputs */
      if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
        _error(400);
      }
      /* update */
      $db->query(sprintf("UPDATE stories_music SET enabled = %s WHERE music_id = %s", secure(($_GET['do'] == 'enable_music') ? '1' : '0'), secure($_GET['id'], 'int')));
      /* return */
      return_json(['callback' => 'window.location.reload();']);
      break;

    default:
      _error(400);
      break;
  }
} catch (Exception $e) {
  return_json(['error' => true, 'message' => $e->getMessage()]);
}
