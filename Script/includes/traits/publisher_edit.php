<?php

/**
 * trait -> publisher edit
 *
 * @package Sngine
 * @author Zamblek
 */

trait PublisherEditTrait
{
  /**
   * normalize_publisher_attachments
   *
   * @param array $request
   * @return array
   */
  public function normalize_publisher_attachments($request)
  {
    foreach ($request as $value) {
      if (!is_scalar($value) && $value !== null) {
        throw new ValidationException(__("Invalid publisher data"));
      }
    }
    /* filter link */
    if (isset($request['link'])) {
      $request['link'] = json_decode($request['link']);
      if (!is_object($request['link']) || !isset($request['link']->source_url, $request['link']->source_type) || !is_string($request['link']->source_url) || !in_array($request['link']->source_type, ['link', 'photo', 'video', 'rich'], true)) {
        throw new ValidationException(__("Invalid publisher data"));
      }
    }
    /* filter photos */
    $photos = [];
    if (isset($request['photos'])) {
      $request['photos'] = json_decode($request['photos']);
      if (!is_object($request['photos'])) {
        throw new ValidationException(__("Invalid publisher data"));
      }
      foreach ($request['photos'] as $photo) {
        if (!is_object($photo)) {
          throw new ValidationException(__("Invalid publisher data"));
        }
        if (!is_valid_upload_source($photo->source ?? null)) {
          throw new ValidationException(__("Invalid publisher data"));
        }
        $photos[] = (array) $photo;
      }
      if (count($photos) == 0) {
        throw new ValidationException(__("Invalid publisher data"));
      }
    }
    /* photo layout and order */
    $photo_layout = $request['photo_layout'] ?? 'classic';
    if (!is_string($photo_layout) || !isset(get_photo_layout_presets()[$photo_layout])) {
      throw new ValidationException(__("Invalid publisher data"));
    }
    if (isset($request['photo_order'])) {
      if (!is_string($request['photo_order'])) {
        throw new ValidationException(__("Invalid publisher data"));
      }
      try {
        $photos = order_post_photos($photos, json_decode($request['photo_order']));
      } catch (InvalidArgumentException $e) {
        throw new ValidationException(__("Invalid publisher data"));
      }
    }
    /* filter voice_notes */
    if (isset($request['voice_notes'])) {
      $request['voice_notes'] = json_decode($request['voice_notes']);
      if (!is_object($request['voice_notes']) || !is_valid_upload_source($request['voice_notes']->source ?? null)) {
        throw new ValidationException(__("Invalid publisher data"));
      }
    }
    /* filter poll options */
    if (isset($request['poll_options'])) {
      $request['poll_options'] = json_decode($request['poll_options']);
      if (!is_array($request['poll_options'])) {
        throw new ValidationException(__("Invalid publisher data"));
      }
      /* check the options */
      $options = [];
      foreach ($request['poll_options'] as $option) {
        if (!is_string($option) || strlen($option) > 255) {
          throw new ValidationException(__("The poll option you provided is too long. Please try again"));
        }
        if (in_array($option, $options)) {
          throw new ValidationException(__("This option was already added to the poll"));
        }
        if (!is_empty($option)) {
          $options[] = $option;
        }
      }
      /* check if poll options are less than 2 */
      if (count($options) < 2) {
        throw new ValidationException(__("Please add at least two options to the poll"));
      }
      /* check the question */
      if (is_empty($request['message'])) {
        throw new ValidationException(__("Ask a question so people know what your poll is about"));
      }
    }
    /* filter reel */
    if (isset($request['reel'])) {
      $request['reel'] = json_decode($request['reel']);
      if (!is_object($request['reel']) || !is_valid_upload_source($request['reel']->source ?? null)) {
        throw new ValidationException(__("Invalid publisher data"));
      }
    }
    /* filter video */
    if (isset($request['video'])) {
      $request['video'] = json_decode($request['video']);
      if (!is_object($request['video']) || !is_valid_upload_source($request['video']->source ?? null)) {
        throw new ValidationException(__("Invalid publisher data"));
      }
    }
    /* filter audio */
    if (isset($request['audio'])) {
      $request['audio'] = json_decode($request['audio']);
      if (!is_object($request['audio']) || !is_valid_upload_source($request['audio']->source ?? null)) {
        throw new ValidationException(__("Invalid publisher data"));
      }
    }
    /* filter file */
    if (isset($request['file'])) {
      $request['file'] = json_decode($request['file']);
      if (!is_object($request['file']) || !is_valid_upload_source($request['file']->source ?? null)) {
        throw new ValidationException(__("Invalid publisher data"));
      }
    }
    /* filter reel/video thumbnails */
    if (!empty($request['reel_thumbnail']) && !is_valid_upload_source($request['reel_thumbnail'])) {
      throw new ValidationException(__("Invalid publisher data"));
    }
    if (!empty($request['video_thumbnail']) && !is_valid_upload_source($request['video_thumbnail'])) {
      throw new ValidationException(__("Invalid publisher data"));
    }
    if (!empty($request['paid_image']) && !is_valid_upload_source($request['paid_image'])) {
      throw new ValidationException(__("Invalid publisher data"));
    }
  
    if (count(array_unique(array_column($photos, 'source'))) !== count($photos)) {
      throw new ValidationException(__("Duplicate photo"));
    }
    $request['photos'] = $photos;
    $request['photo_layout'] = $photo_layout;
    $request['poll_options'] = $options ?? null;
    return $request;
  }

  /**
   * get_post_editor
   *
   * @param integer $post_id
   * @return array
   */
  public function get_post_editor($post_id)
  {
    global $db;
    if (!is_scalar($post_id) || !ctype_digit((string) $post_id) || $post_id < 1) {
      throw new ValidationException(__("Invalid post"));
    }
    $post = $this->_check_post($post_id, true);
    if (!$post || !$post['manage_post']) {
      throw new ValidationException(__("This post is unavailable or you cannot edit it"));
    }
    $this->check_post_edit_window($post);
    if (in_array($post['post_type'], ['article', 'rich_text', 'product', 'funding', 'offer', 'job', 'course'])) {
      throw new ValidationException(__("Please use this post's dedicated editor"));
    }
    $fields = ['post_id', 'user_id', 'user_type', 'in_wall', 'wall_id', 'in_group', 'group_id', 'in_event', 'event_id', 'post_type', 'text', 'time', 'is_schedule', 'is_anonymous', 'privacy', 'location', 'location_latitude', 'location_longitude', 'feeling_action', 'feeling_value', 'colored_pattern', 'photo_layout', 'for_adult', 'tips_enabled', 'for_subscriptions', 'subscriptions_image', 'is_paid', 'is_paid_locked', 'post_price', 'paid_text', 'paid_image', 'is_collaborative', 'collaborative_percent'];
    $row = $db->query(sprintf("SELECT * FROM posts WHERE post_id = %s", secure($post_id, 'int')))->fetch_assoc();
    $state = array_intersect_key($row, array_flip($fields));
    $state['photos'] = $db->query(sprintf("SELECT photo_id, album_id, source, blur, sort_order FROM posts_photos WHERE post_id = %s ORDER BY sort_order, photo_id", secure($post_id, 'int')))->fetch_all(MYSQLI_ASSOC);
    foreach (['reel' => 'posts_reels', 'video' => 'posts_videos', 'audio' => 'posts_audios', 'file' => 'posts_files', 'link' => 'posts_links', 'media' => 'posts_media'] as $kind => $table) {
      $attachment = $db->query(sprintf("SELECT * FROM $table WHERE post_id = %s", secure($post_id, 'int')))->fetch_assoc();
      if ($attachment) {
        unset($attachment['views'], $attachment['post_id']);
      }
      $state[$kind] = $attachment ?: null;
    }
    $poll = $db->query(sprintf("SELECT * FROM posts_polls WHERE post_id = %s", secure($post_id, 'int')))->fetch_assoc();
    $state['poll_options'] = $poll ? $db->query(sprintf("SELECT option_id, text FROM posts_polls_options WHERE poll_id = %s ORDER BY option_id", secure($poll['poll_id'], 'int')))->fetch_all(MYSQLI_ASSOC) : [];
    $state['collaborative_users'] = $db->query(sprintf("SELECT user_id FROM posts_collaborative_users WHERE post_id = %s ORDER BY user_id", secure($post_id, 'int')))->fetch_all(MYSQLI_ASSOC);
    $state['revision'] = hash('sha256', json_encode($state));
    array_walk_recursive($state, function (&$value) {
      if (is_string($value)) $value = html_entity_decode($value, ENT_QUOTES, 'UTF-8');
    });
    $state['poll_locked'] = $poll && ($poll['votes'] > 0 || !empty($poll['edit_locked']));
    $state['limited'] = !in_array($post['post_type'], ['', 'map', 'photos', 'album', 'combo', 'link', 'media', 'poll', 'reel', 'video', 'audio', 'file'], true);
    $state['still_scheduled'] = $row['is_schedule'] && strtotime($row['time']) > time();
    $state['album'] = '';
    if ($post['post_type'] == 'album' && $state['photos']) {
      $album = $db->query(sprintf("SELECT title FROM posts_photos_albums WHERE album_id = %s", secure($state['photos'][0]['album_id'], 'int')))->fetch_assoc();
      $state['album'] = html_entity_decode($album['title'] ?? '', ENT_QUOTES, 'UTF-8');
    }
    $state['context'] = $post;
    return $state;
  }

  /**
   * validate_publisher_content
   *
   * @param array $input
   * @return string
   */
  public function validate_publisher_content($input)
  {
    $media = array_filter(['photos' => !empty($input['photos']), 'video' => !empty($input['video']), 'audio' => !empty($input['audio']) || !empty($input['voice_notes']), 'file' => !empty($input['file'])]);
    $exclusive = array_filter(['link' => !empty($input['link']), 'poll' => !empty($input['poll_options']), 'reel' => !empty($input['reel']), 'colored' => !empty($input['colored_pattern']), 'album' => !empty($input['album']), 'voice_notes' => !empty($input['voice_notes'])]);
    if (count($exclusive) > 1 || ($exclusive && $media && !(isset($exclusive['album']) && array_keys($media) === ['photos']) && !(isset($exclusive['voice_notes']) && array_keys($media) === ['audio']))) {
      throw new ValidationException(__("These attachments cannot be combined"));
    }
    if (!empty($input['album']) && empty($input['photos'])) {
      throw new ValidationException(__("Please add at least one photo to the album"));
    }
    if (!preg_replace('/[\s\p{Z}\x{200B}]+/u', '', html_entity_decode(strip_tags($input['message'] ?? ''), ENT_QUOTES, 'UTF-8')) && !$media && empty($input['link']) && empty($input['reel']) && empty($input['location']) && empty($input['feeling_value'])) {
      throw new ValidationException(__("Please add content to your post"));
    }
    if (!empty($input['link'])) return $input['link']->source_type === 'link' ? 'link' : 'media';
    if (!empty($input['poll_options'])) return 'poll';
    if (!empty($input['reel'])) return 'reel';
    if (!empty($input['album'])) return 'album';
    if (count($media) > 1) return 'combo';
    if ($media) return array_key_first($media);
    return empty($input['location']) ? '' : 'map';
  }

  /**
   * edit_publisher_post
   *
   * @param integer $post_id
   * @param array $request
   * @return array
   */
  public function edit_publisher_post($post_id, $request)
  {
    global $db, $system;
    $this->get_post_editor($post_id);
    $db->begin_transaction();
    $deleted = $pending = $conversions = [];
    try {
      $db->query(sprintf("SELECT post_id FROM posts WHERE post_id = %s FOR UPDATE", secure($post_id, 'int')));
      $state = $this->get_post_editor($post_id);
      $post = $state['context'];
      if (!is_string($request['revision'] ?? null) || !hash_equals($state['revision'], $request['revision'])) {
        throw new ValidationException(__("This post has changed. Close and reopen the editor before saving again"));
      }
      $input = $this->normalize_publisher_attachments($request);
      $values = $this->validate_post_editor_settings($state, $input);
      if ($state['limited']) {
        if ($input['photos'] || !empty($input['link']) || !empty($input['reel']) || !empty($input['video']) || !empty($input['audio']) || !empty($input['file']) || !empty($input['voice_notes']) || !empty($input['poll_options']) || !empty($input['album'])) {
          throw new ValidationException(__("This post's attachments cannot be changed"));
        }
      } else {
        $input['message'] = $values['text'];
        foreach (['location', 'feeling_value', 'colored_pattern'] as $field) $input[$field] = $values[$field];
        if ($state['post_type'] == 'album') $input['album'] = $state['album'];
        $values['post_type'] = $this->validate_publisher_content($input);
        $this->validate_post_editor_poll($state, $input);
        $this->save_post_editor_photos($state, $input, $pending, $deleted);
        $this->save_post_editor_media($state, $input, $pending, $deleted, $conversions);
        $link_type = $this->save_post_editor_link($state, $input);
        if ($link_type) $values['post_type'] = $link_type;
        $this->save_post_editor_poll($state, $input);
      }
      foreach (['subscriptions_image', 'paid_image'] as $field) {
        if ($values[$field] != $state[$field]) {
          $this->check_post_editor_upload($values[$field], $pending, 'photos/');
          if ($state[$field]) $deleted[] = $state[$field];
        }
      }
      if ($conversions && $system['ffmpeg_enabled']) $values['processing'] = '1';
      if ($post['in_group'] && $post['group_publish_approval_enabled'] && !$post['is_group_admin']) $values['group_approved'] = '0';
      if ($post['in_event'] && $post['event_publish_approval_enabled'] && !$post['is_event_admin']) $values['event_approved'] = '0';
      $assignments = [];
      foreach ($values as $field => $value) {
        $type = $field == 'colored_pattern' ? 'int' : (in_array($field, ['post_price', 'collaborative_percent']) ? 'float' : '');
        $assignments[] = "$field = " . secure($value, $type);
      }
      $db->query(sprintf("UPDATE posts SET %s WHERE post_id = %s", implode(', ', $assignments), secure($post_id, 'int')));
      $this->refresh_post_search($post_id);
      $this->save_post_editor_collaborators($state, $input, $values);
      remove_pending_uploads(array_unique($pending));
      if ($values['text'] !== $state['text']) {
        $this->delete_hashtags($post_id);
        $this->delete_translations('post', $post_id);
        $this->parse(['text' => htmlentities($values['text'], ENT_QUOTES, 'UTF-8'), 'trending_hashtags' => true, 'post_id' => $post_id]);
        $this->post_mentions($values['text'], $post_id);
      }
      foreach (['group', 'event'] as $kind) {
        if (isset($values[$kind . '_approved']) && $post[$kind . '_approved']) {
          $this->post_notification(['to_user_id' => $post[$kind . '_admin'], 'action' => $kind . '_post_pending', 'node_type' => $post[$kind . '_title'], 'node_url' => ($kind === 'group' ? $post['group_name'] : $post['event_id']) . '-[guid=]' . $post_id]);
        }
      }
      $needs_approval = $this->queue_post_reapproval($post);
      $db->commit();
    } catch (Throwable $e) {
      $db->rollback();
      throw $e;
    }
    foreach (array_unique(array_filter($deleted)) as $source) {
      try {
        $this->delete_post_editor_upload($source);
      } catch (Throwable $e) {
        error_log('Post attachment cleanup: ' . $e->getMessage());
      }
    }
    return ['post_id' => $post_id, 'author_id' => $post['author_id'], 'processing' => !empty($values['processing']), 'approval' => ($post['in_group'] && ($values['group_approved'] ?? $post['group_approved']) == '0') || ($post['in_event'] && ($values['event_approved'] ?? $post['event_approved']) == '0') || $needs_approval, 'conversions' => $conversions];
  }

  private function validate_post_editor_settings($state, $input)
  {
    global $system;
    if (!isset($input['message']) || !is_string($input['message'])) throw new ValidationException(__("Invalid post text"));
    $text = strip_tags($input['message'], '<p><br><b><strong><i><em><u><s><del><blockquote><ul><ol><li><h1><h2><span>');
    if ($system['max_post_length'] > 0 && $this->_data['user_group'] >= 3 && strlen($text) >= $system['max_post_length']) throw new ValidationException(__("Your message characters length is over the allowed limit"));
    $values = ['text' => $state['poll_locked'] && $input['message'] === $state['text'] ? $state['text'] : $text];
    foreach (['privacy', 'location', 'feeling_action', 'feeling_value', 'colored_pattern', 'photo_layout', 'subscriptions_image', 'paid_image', 'paid_text', 'post_price', 'collaborative_percent'] as $key) $values[$key] = $input[$key] ?? $state[$key] ?? '';
    foreach (['for_adult', 'tips_enabled', 'for_subscriptions', 'is_paid', 'is_paid_locked', 'is_collaborative'] as $key) {
      $values[$key] = array_key_exists($key, $input) ? $this->post_editor_boolean($input[$key]) : $state[$key];
    }
    $post = $state['context'];
    $fixed_privacy = $post['in_group'] || $post['in_event'] || $state['user_type'] == 'page' || $state['is_anonymous'];
    if ($fixed_privacy && $values['privacy'] != $state['privacy']) throw new ValidationException(__("This post's audience cannot be changed"));
    if (!$fixed_privacy && !in_array($values['privacy'], $state['in_wall'] ? ['public', 'friends'] : ['public', 'friends', 'me'], true)) throw new ValidationException(__("Invalid privacy"));
    if ($values['post_price'] === '') $values['post_price'] = 0;
    if ($values['collaborative_percent'] === '') $values['collaborative_percent'] = 0;
    if (strlen($values['location']) > 256 || strlen($values['feeling_value']) > 256 || strlen($values['paid_text']) > 1000) throw new ValidationException(__("Your message characters length is over the allowed limit"));
    foreach (['location' => 'can_add_geolocation_posts', 'feeling_action' => 'can_add_activity_posts', 'feeling_value' => 'can_add_activity_posts', 'colored_pattern' => 'can_add_colored_posts', 'tips_enabled' => 'can_receive_tip'] as $field => $permission) {
      if ($values[$field] && $values[$field] != $state[$field] && empty($this->_data[$permission])) throw new ValidationException(__("You don't have the permission to do this"));
    }
    $has_coordinates = $values['location'] && valid_location($input['latitude'] ?? null, $input['longitude'] ?? null);
    $values['location_latitude'] = $has_coordinates ? round((float) $input['latitude'], 7) : 'null';
    $values['location_longitude'] = $has_coordinates ? round((float) $input['longitude'], 7) : 'null';
    if ($values['colored_pattern'] && $values['colored_pattern'] != $state['colored_pattern'] && !$this->get_posts_colored_pattern($values['colored_pattern'])) throw new ValidationException(__("Invalid colored post"));
    if ($values['feeling_action'] && ($values['feeling_action'] != $state['feeling_action'] || $values['feeling_value'] != $state['feeling_value'])) {
      if (!get_feeling_icon($values['feeling_action'] == 'Feeling' ? $values['feeling_value'] : $values['feeling_action'], $values['feeling_action'] == 'Feeling' ? get_feelings_types() : get_feelings())) throw new ValidationException(__("Invalid feeling"));
    }
    if (!$values['feeling_value']) $values['feeling_action'] = '';
    if (strlen($input['album'] ?? '') > 256) throw new ValidationException(__("Album title is too long"));
    if ($state['limited']) {
      $values['colored_pattern'] = $state['colored_pattern'];
      $values['photo_layout'] = $state['photo_layout'];
    }
    if ($values['for_adult'] && !$state['for_adult'] && $system['verification_for_adult_content'] && !$this->_data['user_verified']) throw new ValidationException(__("Your account must be verified to share adult content"));
    $paid_changed = false;
    foreach (['is_paid', 'is_paid_locked', 'post_price', 'paid_text', 'paid_image'] as $field) $paid_changed = $paid_changed || $values[$field] != $state[$field];
    if ($values['is_paid'] && $paid_changed && (empty($this->_data['can_monetize_content']) || !$this->post_editor_can_monetize($post) || $state['in_wall'])) throw new ValidationException(__("You don't have the permission to add paid posts"));
    if ($values['is_paid'] && $values['for_subscriptions'] && (!$state['is_paid'] || !$state['for_subscriptions'])) throw new ValidationException(__("Choose paid content or subscribers only"));
    if ($values['is_paid'] && (!is_numeric($values['post_price']) || $values['post_price'] <= 0 || ($system['monetization_max_paid_post_price'] > 0 && $values['post_price'] > $system['monetization_max_paid_post_price'] && $paid_changed))) throw new ValidationException(__("Please enter a valid price"));
    if ($values['is_paid_locked'] && $values['is_paid'] && empty($input['file']) && !($state['limited'] && $state['file'])) throw new ValidationException(__("You can not lock paid post without attached file"));
    if (!$values['is_paid']) $values['is_paid_locked'] = '0';
    if ($values['for_subscriptions'] && ($values['for_subscriptions'] != $state['for_subscriptions'] || $values['subscriptions_image'] != $state['subscriptions_image']) && !$this->post_editor_can_subscribe($post)) throw new ValidationException(__("You don't have the permission to do this"));
    if ($state['still_scheduled']) {
      $schedule = isset($input['is_schedule']) ? $this->post_editor_boolean($input['is_schedule']) : '1';
      $when = $input['schedule_date'] ?? $state['time'];
      if ($schedule && (!is_string($when) || !preg_match('/^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$/', $when))) throw new ValidationException(__("Invalid schedule date"));
      if ($schedule && ($when != $state['time']) && (empty($this->_data['can_schedule_posts']) || !strtotime($when) || strtotime($when) <= time())) throw new ValidationException(__("Select a valid date and time for your scheduled post"));
      $values['is_schedule'] = $schedule;
      $values['time'] = $schedule ? $when : gmdate('Y-m-d H:i:s');
    }
    foreach (['user_id', 'user_type', 'in_group', 'group_id', 'in_event', 'event_id', 'wall_id', 'is_anonymous'] as $field) {
      if (isset($input[$field]) && (string) $input[$field] !== (string) $state[$field] && !($field == 'is_anonymous' && $this->post_editor_boolean($input[$field]) == $state[$field])) throw new ValidationException(__("This post's author and destination cannot be changed"));
    }
    return $values;
  }

  public function post_editor_can_subscribe($post)
  {
    global $system;
    if (empty($system['monetization_enabled']) || $post['in_event'] || $post['in_wall']) return false;
    $prefix = $post['in_group'] ? 'group' : ($post['user_type'] == 'page' ? 'page' : 'user');
    $owner = $prefix == 'group' ? $post['group_admin'] : $post['author_id'];
    return !empty($post[$prefix . '_monetization_enabled']) && !empty($post[$prefix . '_monetization_plans']) && $this->check_user_permission($owner, 'monetization_permission');
  }

  public function post_editor_can_monetize($post)
  {
    global $system;
    return !empty($system['monetization_enabled']) && !empty($post[$post['user_type'] == 'page' ? 'page_monetization_enabled' : 'user_monetization_enabled']) && $this->check_user_permission($post['author_id'], 'monetization_permission');
  }

  private function post_editor_boolean($value)
  {
    if (!in_array($value, ['true', 'false', '1', '0', 1, 0, true, false], true)) throw new ValidationException(__("Invalid publisher data"));
    return in_array($value, ['true', '1', 1, true], true) ? '1' : '0';
  }

  private function check_post_editor_upload($source, &$pending, $folder = null)
  {
    global $db;
    if (!$source) return;
    if (!is_valid_upload_source($source) || ($folder && !str_starts_with($source, $folder))) throw new ValidationException(__("Invalid attachment"));
    $upload = $db->query(sprintf("SELECT file_name FROM users_uploads_pending WHERE user_id = %s AND file_name = %s FOR UPDATE", secure($this->_data['user_id'], 'int'), secure($source)))->fetch_assoc();
    if (!$upload) throw new ValidationException(__("This upload is unavailable. Please upload the file again"));
    $pending[] = $source;
  }

  private function save_post_editor_photos($state, $input, &$pending, &$deleted)
  {
    global $db, $system;
    $existing = array_column($state['photos'], null, 'photo_id');
    $kept = [];
    foreach ($input['photos'] as $photo) {
      $id = $photo['photo_id'] ?? null;
      if ($id) {
        if (!isset($existing[$id]) || $existing[$id]['source'] !== $photo['source'] || isset($kept[$id])) throw new ValidationException(__("Invalid attachment"));
        $kept[$id] = true;
      } else {
        if (!str_starts_with($photo['source'], 'photos/')) throw new ValidationException(__("Invalid photo"));
        if (!$system['photos_enabled']) throw new ValidationException(__("Photos are disabled"));
        $this->check_post_editor_upload($photo['source'], $pending);
      }
    }
    $removed = array_diff(array_keys($existing), array_keys($kept));
    $declared = json_decode($input['removed_photos'] ?? '[]', true);
    if (!is_array($declared) || array_diff($removed, $declared) || array_diff($declared, $removed)) throw new ValidationException(__("Invalid removed photos"));
    $album_id = $state['photos'][0]['album_id'] ?? null;
    if ($input['photos'] && (!$album_id || (!empty($input['album']) && $state['post_type'] != 'album'))) $album_id = $this->post_editor_album($state, $input);
    foreach ($input['photos'] as $position => $photo) {
      if (!empty($photo['photo_id'])) {
        $db->query(sprintf("UPDATE posts_photos SET sort_order = %s, album_id = %s WHERE photo_id = %s AND post_id = %s", secure($position, 'int'), secure(!empty($input['album']) && $state['post_type'] != 'album' ? $album_id : $existing[$photo['photo_id']]['album_id'], 'int'), secure($photo['photo_id'], 'int'), secure($state['post_id'], 'int')));
      } else {
        $db->query(sprintf("INSERT INTO posts_photos (post_id, album_id, source, blur, sort_order) VALUES (%s, %s, %s, %s, %s)", secure($state['post_id'], 'int'), secure($album_id, 'int'), secure($photo['source']), secure(!empty($photo['blur']) ? 1 : 0, 'int'), secure($position, 'int')));
      }
    }
    foreach ($removed as $id) {
      $db->query(sprintf("DELETE FROM posts_photos WHERE photo_id = %s AND post_id = %s", secure($id, 'int'), secure($state['post_id'], 'int')));
      $deleted[] = $existing[$id]['source'];
    }
  }

  private function post_editor_album($state, $input)
  {
    global $db;
    if (!empty($input['album'])) {
      if ($state['is_anonymous']) throw new ValidationException(__("You can not create an album with an anonymous post"));
      $db->query(sprintf("INSERT INTO posts_photos_albums (user_id, user_type, in_group, group_id, in_event, event_id, title, privacy) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)", secure($state['user_id'], 'int'), secure($state['user_type']), secure($state['in_group']), secure($state['group_id'], 'int'), secure($state['in_event']), secure($state['event_id'], 'int'), secure($input['album']), secure($input['privacy'] ?? $state['privacy'])));
      return $db->insert_id;
    }
    [$table, $key, $column, $id] = $state['in_group'] ? ['groups', 'group_id', 'group_album_timeline', $state['group_id']] : ($state['in_event'] ? ['events', 'event_id', 'event_album_timeline', $state['event_id']] : ($state['user_type'] == 'page' ? ['pages', 'page_id', 'page_album_timeline', $state['user_id']] : ['users', 'user_id', 'user_album_timeline', $state['user_id']]));
    $row = $db->query(sprintf("SELECT $column FROM `$table` WHERE $key = %s FOR UPDATE", secure($id, 'int')))->fetch_assoc();
    if ($row[$column]) return $row[$column];
    $db->query(sprintf("INSERT INTO posts_photos_albums (user_id, user_type, in_group, group_id, in_event, event_id, title, privacy) VALUES (%s, %s, %s, %s, %s, %s, 'Timeline Photos', %s)", secure($state['user_id'], 'int'), secure($state['user_type']), secure($state['in_group']), secure($state['group_id'], 'int'), secure($state['in_event']), secure($state['event_id'], 'int'), secure($state['in_group'] || $state['in_event'] ? 'custom' : 'public')));
    $album_id = $db->insert_id;
    $db->query(sprintf("UPDATE `$table` SET $column = %s WHERE $key = %s", secure($album_id, 'int'), secure($id, 'int')));
    return $album_id;
  }

  private function save_post_editor_media($state, $input, &$pending, &$deleted, &$conversions)
  {
    global $db, $system;
    if (!empty($input['voice_notes'])) $input['audio'] = $input['voice_notes'];
    $declared = json_decode($input['removed_media'] ?? '[]', true);
    if (!is_array($declared)) throw new ValidationException(__("Invalid attachment"));
    $removed = [];
    foreach (['reel' => 'posts_reels', 'video' => 'posts_videos', 'audio' => 'posts_audios', 'file' => 'posts_files'] as $kind => $table) {
      $old = $state[$kind];
      $new = $input[$kind] ?? null;
      $id_key = $kind . '_id';
      $retained = $new && !empty($new->$id_key);
      if ($retained && (!$old || (string) $new->$id_key !== (string) $old[$id_key] || $new->source !== $old['source'])) throw new ValidationException(__("Invalid attachment"));
      if (!$old && !$new) continue;
      if ($old && !$retained) $removed[] = $kind;
      if ($new && !$retained) {
        $allowed = $kind == 'reel' ? !empty($this->_data['can_add_reels']) : !empty($this->_data['can_upload_' . ($kind == 'audio' ? 'audios' : $kind . 's')]);
        if ($kind == 'audio' && !empty($input['voice_notes'])) $allowed = !empty($system['voice_notes_posts_enabled']);
        if (!$allowed) throw new ValidationException(__("You don't have the permission to upload this attachment"));
        $folder = in_array($kind, ['reel', 'video']) ? 'videos/' : ($kind == 'audio' ? 'sounds/' : 'files/');
        if (!str_starts_with($new->source, $folder)) throw new ValidationException(__("Invalid attachment type"));
        $this->check_post_editor_upload($new->source, $pending);
      }
      $fields = $new ? ['source' => $new->source] : [];
      if ($new && in_array($kind, ['video', 'reel'])) {
        $fields['thumbnail'] = $input[$kind . '_thumbnail'] ?? ($retained ? $old['thumbnail'] : '');
        if ($fields['thumbnail'] && (!$retained || $fields['thumbnail'] !== $old['thumbnail'])) $this->check_post_editor_upload($fields['thumbnail'], $pending, 'photos/');
        if ($retained && $old['thumbnail'] && $fields['thumbnail'] !== $old['thumbnail']) $deleted[] = $old['thumbnail'];
        if ($kind == 'video') {
          $fields['category_id'] = !empty($input['video_category']) ? $input['video_category'] : ($retained ? $old['category_id'] : 0);
          if (!ctype_digit((string) $fields['category_id'])) throw new ValidationException(__("Invalid video category"));
          if ($fields['category_id'] && (!$retained || $fields['category_id'] != $old['category_id']) && !$this->get_category('posts_videos_categories', $fields['category_id'])) throw new ValidationException(__("Invalid video category"));
        }
        if ($kind == 'video' && !$retained) {
          foreach (['width', 'height'] as $dimension) {
            if (isset($new->$dimension) && is_numeric($new->$dimension) && $new->$dimension > 0) $fields[$dimension] = min((int) $new->$dimension, 65535);
          }
        }
        if (!$retained) $conversions[$kind] = ['source' => $new->source, 'thumbnail' => $fields['thumbnail']];
      }
      if ($new && $kind == 'file' && !$retained) {
        $fields['name'] = $this->sanitize_upload_file_name($new->name ?? '');
        $fields['size'] = max(0, (int) ($new->size ?? 0));
      }
      if ($old && !$retained) {
        foreach ($old as $field => $value) if (($field === 'thumbnail' || str_starts_with($field, 'source')) && $value) $deleted[] = $value;
        $db->query(sprintf("DELETE FROM $table WHERE post_id = %s", secure($state['post_id'], 'int')));
      }
      if ($new) {
        $assignments = [];
        foreach ($fields as $field => $value) $assignments[] = "$field = " . secure($value);
        if ($retained) $db->query(sprintf("UPDATE $table SET %s WHERE post_id = %s", implode(', ', $assignments), secure($state['post_id'], 'int')));
        else $db->query(sprintf("INSERT INTO $table SET post_id = %s, %s", secure($state['post_id'], 'int'), implode(', ', $assignments)));
      }
    }
    if (array_diff($removed, $declared) || array_diff($declared, $removed)) throw new ValidationException(__("Invalid removed attachments"));
  }

  private function save_post_editor_link($state, $input)
  {
    global $db;
    $link = $input['link'] ?? null;
    $old = $state['link'] ?: $state['media'];
    if ($old && $link && ($link->link_id ?? $link->media_id ?? null) == ($old['link_id'] ?? $old['media_id'])) {
      if ($link->source_url !== $old['source_url']) throw new ValidationException(__("Invalid link"));
      return $state['post_type'];
    }
    if ($link) {
      if (($link->source_provider ?? '') == 'giphy') {
        if (empty($this->_data['can_add_gif_posts']) || !valid_gif_url($link->source_url ?? '')) throw new ValidationException(__("Invalid GIF"));
        $link = (object) ['source_url' => $link->source_url, 'source_provider' => 'giphy', 'source_type' => 'photo', 'source_title' => $link->source_url, 'source_text' => '', 'source_html' => '', 'source_thumbnail' => ''];
      } else {
        if (!valid_url($link->source_url ?? '')) throw new ValidationException(__("Invalid link"));
        $link = (object) $this->scraper($link->source_url);
      }
    }
    foreach (['posts_links', 'posts_media'] as $table) $db->query(sprintf("DELETE FROM $table WHERE post_id = %s", secure($state['post_id'], 'int')));
    if (!$link) return;
    $type = $link->source_type === 'link' ? 'link' : 'media';
    $table = $type == 'link' ? 'posts_links' : 'posts_media';
    $fields = $type == 'link' ? ['source_url', 'source_host', 'source_title', 'source_text', 'source_thumbnail'] : ['source_url', 'source_provider', 'source_type', 'source_title', 'source_text', 'source_html', 'source_thumbnail'];
    $assignments = [];
    foreach ($fields as $field) $assignments[] = "$field = " . secure($link->$field ?? '');
    $db->query(sprintf("INSERT INTO $table SET post_id = %s, %s", secure($state['post_id'], 'int'), implode(', ', $assignments)));
    return $type;
  }

  private function validate_post_editor_poll($state, $input)
  {
    if ($state['poll_locked'] && ($input['message'] !== $state['text'] || ($input['poll_options'] ?? []) !== array_column($state['poll_options'], 'text'))) throw new ValidationException(__("The question and options cannot be changed after people have voted"));
    if (!empty($input['poll_options']) && $input['poll_options'] !== array_column($state['poll_options'], 'text') && empty($this->_data['can_add_polls_posts'])) throw new ValidationException(__("You don't have the permission to add polls posts"));
  }

  private function save_post_editor_poll($state, $input)
  {
    global $db;
    $options = $input['poll_options'] ?? [];
    if ($options === array_column($state['poll_options'], 'text')) return;
    $poll = $db->query(sprintf("SELECT poll_id FROM posts_polls WHERE post_id = %s", secure($state['post_id'], 'int')))->fetch_assoc();
    if ($poll) {
      $db->query(sprintf("DELETE FROM posts_polls_options WHERE poll_id = %s", secure($poll['poll_id'], 'int')));
      if (!$options) $db->query(sprintf("DELETE FROM posts_polls WHERE poll_id = %s", secure($poll['poll_id'], 'int')));
    } elseif ($options) {
      $db->query(sprintf("INSERT INTO posts_polls (post_id) VALUES (%s)", secure($state['post_id'], 'int')));
      $poll = ['poll_id' => $db->insert_id];
    }
    foreach ($options as $option) $db->query(sprintf("INSERT INTO posts_polls_options (poll_id, text) VALUES (%s, %s)", secure($poll['poll_id'], 'int'), secure($option)));
  }

  private function save_post_editor_collaborators($state, $input, $values)
  {
    global $db;
    $old = array_column($state['collaborative_users'], 'user_id');
    $new = $old;
    if (!$values['is_collaborative']) $new = [];
    elseif (isset($input['collaborative_users'])) {
      $users = json_decode($input['collaborative_users'], true);
      if (!is_array($users)) throw new ValidationException(__("Invalid collaborators"));
      $ids = [];
      foreach ($users as $entry) {
        if (!is_array($entry) || !isset($entry['id']) || !ctype_digit((string) $entry['id']) || $entry['id'] == $state['context']['author_id']) throw new ValidationException(__("Invalid collaborators"));
        $ids[] = (string) $entry['id'];
      }
      $new = array_values(array_unique($ids));
      if (array_diff($new, $old)) {
        $approved = $this->validate_collaborative_users(json_encode(array_map(fn($id) => ['id' => $id], array_values(array_diff($new, $old)))));
        if (array_diff($new, $old, $approved)) throw new ValidationException(__("A selected user does not allow collaboration"));
      }
    }
    if ($values['is_collaborative'] && (!$new || $state['is_anonymous'] || $values['for_subscriptions'] || $state['user_type'] == 'page' || $state['in_wall'])) throw new ValidationException(__("This post cannot use these collaboration settings"));
    if ((!empty(array_diff($new, $old)) || $values['collaborative_percent'] != $state['collaborative_percent']) && empty($this->_data['can_add_collaborative_posts'])) throw new ValidationException(__("You don't have the permission to do this"));
    if (!is_numeric($values['collaborative_percent']) || $values['collaborative_percent'] < 0 || $values['collaborative_percent'] > 100) throw new ValidationException(__("Please enter a valid percentage"));
    foreach (array_diff($old, $new) as $id) $db->query(sprintf("DELETE FROM posts_collaborative_users WHERE post_id = %s AND user_id = %s", secure($state['post_id'], 'int'), secure($id, 'int')));
    $this->insert_collaborative_users($state['post_id'], array_diff($new, $old));
  }

  private function delete_post_editor_upload($source)
  {
    global $db;
    /* check references before removing a saved upload */
    $columns = $db->query("SELECT TABLE_NAME, COLUMN_NAME FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND DATA_TYPE IN ('varchar', 'text', 'mediumtext', 'longtext') AND (COLUMN_NAME LIKE '%source%' OR COLUMN_NAME LIKE '%image%' OR COLUMN_NAME LIKE '%picture%' OR COLUMN_NAME LIKE '%cover%' OR COLUMN_NAME IN ('thumbnail', 'text', 'message'))");
    $tables = [];
    while ($column = $columns->fetch_assoc()) {
      if (!preg_match('/^[a-zA-Z0-9_]+$/', $column['TABLE_NAME']) || !preg_match('/^[a-zA-Z0-9_]+$/', $column['COLUMN_NAME'])) continue;
      $tables[$column['TABLE_NAME']][] = '`' . $column['COLUMN_NAME'] . '` LIKE ' . secure('%' . $source . '%');
    }
    foreach ($tables as $table => $conditions) {
      if ($db->query("SELECT 1 FROM `$table` WHERE " . implode(' OR ', $conditions) . ' LIMIT 1')->num_rows) return;
    }
    delete_uploads_file($source);
  }
}
