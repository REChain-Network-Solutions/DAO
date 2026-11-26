<?php

/**
 * trait -> stories
 *
 * @package Sngine
 * @author Zamblek
 */

trait StoriesTrait
{

  /* ------------------------------- */
  /* Stories */
  /* ------------------------------- */

  /**
   * post_story
   *
   * @param array $args
   * @return integer
   */
  public function post_story($args = [])
  {
    global $db, $system, $date;
    /* check stories permission */
    if (!$this->_data['can_add_stories']) {
      throw new Exception(__("You don't have the permission to do this"));
    }
    /* prepare */
    $type = $args['type'] ?? 'photo';
    if (!in_array($type, ['photo', 'video', 'text'])) {
      throw new BadRequestException(__("Invalid request"));
    }
    if ($type == 'text' && !$system['stories_text_enabled']) {
      throw new ValidationException(__("This feature has been disabled by the admin"));
    }
    $source = $args['source'] ?? '';
    $thumbnail = $args['thumbnail'] ?? '';
    if ($type != 'text' && !is_valid_upload_source($source)) {
      throw new BadRequestException(__("Invalid request"));
    }
    if ($thumbnail && !is_valid_upload_source($thumbnail)) {
      throw new BadRequestException(__("Invalid request"));
    }
    if ($type == 'video' && !$this->_data['can_upload_videos']) {
      throw new AuthorizationException(__("Uploading videos feature has been disabled by the admin"));
    }
    $drawing = $args['drawing'] ?? '';
    if ($drawing && !is_valid_upload_source($drawing)) {
      throw new BadRequestException(__("Invalid request"));
    }
    $background = ($type == 'text' && in_array($args['background'] ?? '', ['aurora', 'sunset', 'ocean', 'forest', 'candy', 'grape', 'peach', 'midnight'])) ? $args['background'] : (($type == 'text') ? 'aurora' : '');
    $filter = ($type != 'text' && in_array($args['filter'] ?? '', ['vivid', 'warm', 'cool', 'mono', 'noir', 'fade', 'vintage', 'dramatic'])) ? $args['filter'] : '';
    $music_id = (!empty($args['music'])) ? $this->resolve_story_music($args['music']) : null;
    $layers = $this->filter_story_layers($args['layers'] ?? [], (bool) $music_id);
    if ($type == 'text' && !$layers && !$drawing) {
      throw new ValidationException(__("Add some text to your story"));
    }
    $is_ads = (!empty($args['is_ads']) && $this->_is_admin) ? '1' : '0';
    $privacy = (in_array($args['privacy'] ?? '', ['public', 'friends', 'close_friends'])) ? $args['privacy'] : 'public';
    $duration = ($type == 'video') ? 0 : max(($music_id) ? 15 : 1, (int) $system['stories_duration']);
    $expires_at = date('Y-m-d H:i:s', strtotime($date) + 86400);
    /* insert story */
    $db->query(sprintf(
      "INSERT INTO stories (user_id, type, source, thumbnail, background, filter, drawing, layers, duration, music_id, privacy, is_ads, time, expires_at) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)",
      secure($this->_data['user_id'], 'int'),
      secure($type),
      secure(($type == 'text') ? '' : $source),
      secure($thumbnail),
      secure($background),
      secure($filter),
      secure($drawing),
      secure(json_encode($layers, JSON_UNESCAPED_UNICODE)),
      secure($duration, 'int'),
      ($music_id) ? secure($music_id, 'int') : 'null',
      secure($privacy),
      secure($is_ads),
      secure($date),
      secure($expires_at)
    ));
    $story_id = $db->insert_id;
    cache_forget('stories:active:' . $this->_data['user_id']);
    /* remove pending uploads */
    remove_pending_uploads(array_filter([$source, $thumbnail, $drawing]));
    /* update music uses */
    if ($music_id) {
      $db->query(sprintf("UPDATE stories_music SET uses = uses + 1 WHERE music_id = %s", secure($music_id, 'int')));
    }
    /* post mention notifications */
    foreach ($layers as $layer) {
      if ($layer['type'] == 'mention') {
        $this->post_notification(['to_user_id' => $layer['user_id'], 'action' => 'mention', 'node_type' => 'story', 'node_url' => $story_id]);
      }
    }
    return $story_id;
  }


  /**
   * filter_story_layers
   *
   * @param array $layers
   * @param boolean $has_music
   * @return array
   */
  public function filter_story_layers($layers, $has_music = false)
  {
    global $db, $system;
    $filtered = [];
    if (!is_array($layers)) {
      return $filtered;
    }
    $mentions = [];
    $has_link = false;
    $has_music_layer = false;
    $has_poll = false;
    foreach (array_slice($layers, 0, 30) as $layer) {
      $layer = (array) $layer;
      $item = [
        'type' => $layer['type'] ?? '',
        'x' => min(1, max(0, (float) ($layer['x'] ?? 0.5))),
        'y' => min(1, max(0, (float) ($layer['y'] ?? 0.5))),
        'scale' => min(6, max(0.2, (float) ($layer['scale'] ?? 1))),
        'rotation' => fmod((float) ($layer['rotation'] ?? 0), 360),
      ];
      switch ($item['type']) {
        case 'text':
          $text = trim(strip_tags(html_entity_decode((string) ($layer['text'] ?? ''), ENT_QUOTES, 'UTF-8')));
          if ($text === '') {
            continue 2;
          }
          $item['text'] = mb_substr($text, 0, 500);
          $item['color'] = (preg_match('/^#[0-9a-f]{6}$/i', (string) ($layer['color'] ?? ''))) ? $layer['color'] : '#ffffff';
          $item['background'] = (preg_match('/^#[0-9a-f]{6}$/i', (string) ($layer['background'] ?? ''))) ? $layer['background'] : '';
          $item['font'] = (in_array($layer['font'] ?? '', ['modern', 'classic', 'signature', 'editorial', 'typewriter', 'neon'])) ? $layer['font'] : 'modern';
          $item['align'] = (in_array($layer['align'] ?? '', ['start', 'center', 'end'])) ? $layer['align'] : 'center';
          break;

        case 'emoji':
          $emoji = trim(strip_tags((string) ($layer['emoji'] ?? '')));
          if ($emoji === '') {
            continue 2;
          }
          $item['emoji'] = mb_substr($emoji, 0, 16);
          break;

        case 'sticker':
          $stickers = array_column($this->get_stickers(), 'image', 'sticker_id');
          if (!isset($stickers[$layer['id'] ?? ''])) {
            continue 2;
          }
          $item['id'] = (int) $layer['id'];
          $item['image'] = $stickers[$layer['id']];
          break;

        case 'mention':
          if (count($mentions) >= 5 || !is_string($layer['user_name'] ?? null)) {
            continue 2;
          }
          $get_user = $db->query(sprintf("SELECT user_id, user_name FROM users WHERE user_name = %s", secure($layer['user_name'])));
          if ($get_user->num_rows == 0) {
            continue 2;
          }
          $mentioned = $get_user->fetch_assoc();
          if (in_array($mentioned['user_id'], $mentions) || $this->blocked($mentioned['user_id'])) {
            continue 2;
          }
          $mentions[] = $mentioned['user_id'];
          $item['user_id'] = (int) $mentioned['user_id'];
          $item['user_name'] = $mentioned['user_name'];
          break;

        case 'link':
          $url = trim((string) ($layer['url'] ?? ''));
          if ($has_link || strlen($url) > 2000 || !preg_match('/^https?:\/\//i', $url) || !filter_var($url, FILTER_VALIDATE_URL) || $this->check_censored_domains($url)) {
            continue 2;
          }
          $has_link = true;
          $item['url'] = $url;
          $item['label'] = mb_substr((string) parse_url($url, PHP_URL_HOST), 0, 64);
          break;

        case 'poll':
          $options = array_values(array_filter(array_map(function ($option) {
            return mb_substr(trim(strip_tags((string) $option)), 0, 40);
          }, (array) ($layer['options'] ?? [])), 'strlen'));
          if ($has_poll || count($options) != 2 || !$system['stories_polls_enabled']) {
            continue 2;
          }
          $has_poll = true;
          $item['question'] = mb_substr(trim(strip_tags((string) ($layer['question'] ?? ''))), 0, 120);
          $item['options'] = $options;
          break;

        case 'music':
          if (!$has_music || $has_music_layer) {
            continue 2;
          }
          $has_music_layer = true;
          $item['style'] = (in_array($layer['style'] ?? '', ['pill', 'card', 'cover', 'text'])) ? $layer['style'] : 'pill';
          break;

        default:
          continue 2;
      }
      $filtered[] = $item;
    }
    return $filtered;
  }


  /**
   * parse_story_layers
   * 
   * @param string $layers
   * @return array
   */
  public function parse_story_layers($layers)
  {
    global $system;
    return array_map(function ($layer) use ($system) {
      if ($layer['type'] == 'sticker') {
        $layer['image'] = $system['system_uploads'] . '/' . $layer['image'];
      }
      return $layer;
    }, json_decode(html_entity_decode((string) $layers, ENT_QUOTES, 'UTF-8'), true) ?: []);
  }


  /**
   * get_story_thumb
   * 
   * @param array $story
   * @return array
   */
  public function get_story_thumb($story)
  {
    global $system;
    if ($story['type'] != 'text') {
      return ['thumb_layers' => '', 'thumb_drawing' => ''];
    }
    return [
      'thumb_layers' => json_encode($this->parse_story_layers($story['layers']), JSON_UNESCAPED_UNICODE),
      'thumb_drawing' => ($story['drawing']) ? $system['system_uploads'] . '/' . $story['drawing'] : '',
    ];
  }


  /**
   * get_stories
   *
   * @return array
   */
  public function get_stories()
  {
    global $db, $system, $date;
    $me = (int) $this->_data['user_id'];
    $now = secure($date);
    $authors = [];
    /* my story */
    $mine = null;
    $get_mine = $db->query(sprintf("SELECT MAX(story_id) AS last_story_id FROM stories WHERE user_id = %s AND expires_at > %s", secure($me, 'int'), $now));
    $my_last_story_id = (int) $get_mine->fetch_assoc()['last_story_id'];
    /* ads stories */
    $get_ads = $db->query(sprintf("SELECT user_id, MAX(story_id) AS last_story_id FROM stories WHERE is_ads = '1' AND expires_at > %s GROUP BY user_id ORDER BY last_story_id DESC LIMIT 10", $now));
    while ($row = $get_ads->fetch_assoc()) {
      $authors[(int) $row['user_id']] = ['last_story_id' => (int) $row['last_story_id'], 'is_ads' => true];
    }
    /* friends or followings stories */
    $friends_ids = array_diff(array_map('intval', ($system['friends_enabled']) ? $this->friends_ids() : $this->followings_ids()), [$me]);
    if ($friends_ids) {
      $close_authors = $this->get_story_audience_authors('close');
      $close_query = ($close_authors) ? sprintf(" OR user_id IN (%s)", implode(',', $close_authors)) : "";
      $get_friends = $db->query(sprintf("SELECT user_id, MAX(story_id) AS last_story_id FROM stories WHERE user_id IN (%s) AND expires_at > %s AND (privacy != 'close_friends'" . $close_query . ") GROUP BY user_id ORDER BY last_story_id DESC LIMIT 50", implode(',', $friends_ids), $now));
      while ($row = $get_friends->fetch_assoc()) {
        $authors[(int) $row['user_id']] = $authors[(int) $row['user_id']] ?? ['last_story_id' => (int) $row['last_story_id'], 'is_ads' => false];
      }
    }
    /* everyone stories */
    if ($system['newsfeed_source'] != "default") {
      $get_recent = $db->query(sprintf("SELECT user_id, MAX(story_id) AS last_story_id FROM (SELECT user_id, story_id FROM stories WHERE expires_at > %s AND privacy = 'public' ORDER BY story_id DESC LIMIT 200) AS recent GROUP BY user_id ORDER BY last_story_id DESC LIMIT 50", $now));
      while ($row = $get_recent->fetch_assoc()) {
        $authors[(int) $row['user_id']] = $authors[(int) $row['user_id']] ?? ['last_story_id' => (int) $row['last_story_id'], 'is_ads' => false];
      }
    }
    unset($authors[$me]);
    /* remove blocked users */
    $hidden_authors = ($this->_data['user_group'] < 3) ? [] : $this->get_story_audience_authors('hidden');
    foreach (array_keys($authors) as $author_id) {
      if ($this->blocked($author_id) || (!$authors[$author_id]['is_ads'] && in_array($author_id, $hidden_authors))) {
        unset($authors[$author_id]);
      }
    }
    /* get seen stories */
    $seen = [];
    $last_ids = array_column($authors, 'last_story_id');
    if ($last_ids) {
      $get_seen = $db->query(sprintf("SELECT story_id FROM stories_views WHERE user_id = %s AND story_id IN (%s)", secure($me, 'int'), implode(',', $last_ids)));
      $seen = array_map('intval', array_column($get_seen->fetch_all(MYSQLI_ASSOC), 'story_id'));
    }
    /* get previews */
    $previews = [];
    $previews_ids = array_filter(array_merge($last_ids, [$my_last_story_id]));
    if ($previews_ids) {
      $get_previews = $db->query(sprintf("SELECT story_id, type, source, thumbnail, background, drawing, layers FROM stories WHERE story_id IN (%s)", implode(',', $previews_ids)));
      while ($preview = $get_previews->fetch_assoc()) {
        $image = ($preview['type'] == 'photo') ? $preview['source'] : $preview['thumbnail'];
        $previews[$preview['story_id']] = array_merge(['preview' => ($image) ? $system['system_uploads'] . '/' . $image : '', 'background' => $preview['background']], $this->get_story_thumb($preview));
      }
    }
    /* get authors */
    $users = [];
    $authors_ids = array_keys($authors);
    if ($my_last_story_id) {
      $authors_ids[] = $me;
    }
    if ($authors_ids) {
      $get_users = $db->query(sprintf("SELECT user_id, user_name, user_firstname, user_lastname, user_gender, user_picture, user_verified FROM users WHERE user_id IN (%s)", implode(',', $authors_ids)));
      while ($_user = $get_users->fetch_assoc()) {
        $_user['user_picture'] = get_picture($_user['user_picture'], $_user['user_gender']);
        $_user['user_fullname'] = ($system['show_usernames_enabled']) ? $_user['user_name'] : $_user['user_firstname'] . " " . $_user['user_lastname'];
        if ($_user['user_id'] == $me) {
          $mine = array_merge($_user, $previews[$my_last_story_id] ?? ['preview' => '', 'background' => '', 'thumb_layers' => '', 'thumb_drawing' => '']);
          continue;
        }
        $_user['last_story_id'] = $authors[$_user['user_id']]['last_story_id'];
        $_user['is_ads'] = $authors[$_user['user_id']]['is_ads'];
        $_user['seen'] = in_array($_user['last_story_id'], $seen);
        $users[] = array_merge($_user, $previews[$_user['last_story_id']] ?? ['preview' => '', 'background' => '', 'thumb_layers' => '', 'thumb_drawing' => '']);
      }
    }
    /* ads first, then unseen, then latest */
    usort($users, function ($a, $b) {
      return [$b['is_ads'], $a['seen'], $b['last_story_id']] <=> [$a['is_ads'], $b['seen'], $a['last_story_id']];
    });
    return ['mine' => $mine, 'users' => $users];
  }


  /**
   * get_user_stories
   *
   * @param integer $user_id
   * @param integer $story_id
   * @param array $highlight
   * @param boolean $archived
   * @return array
   */
  public function get_user_stories($user_id, $story_id = null, $highlight = null, $archived = false)
  {
    global $db, $system, $date;
    $is_me = ($user_id == $this->_data['user_id']);
    /* get author */
    $get_author = $db->query(sprintf("SELECT user_id, user_name, user_firstname, user_lastname, user_gender, user_picture, user_verified, user_privacy_chat FROM users WHERE user_id = %s", secure($user_id, 'int')));
    if ($get_author->num_rows == 0 || (!$is_me && $this->blocked($user_id))) {
      throw new NoDataException(__("No data found"));
    }
    $author = $get_author->fetch_assoc();
    $author['user_picture'] = get_picture($author['user_picture'], $author['user_gender']);
    $author['user_fullname'] = ($system['show_usernames_enabled']) ? $author['user_name'] : $author['user_firstname'] . " " . $author['user_lastname'];
    /* get stories */
    $items = [];
    $rows = [];
    if ($archived) {
      $get_stories = $db->query(sprintf("SELECT * FROM stories WHERE story_id = %s AND user_id = %s", secure($story_id, 'int'), secure($user_id, 'int')));
    } elseif ($highlight) {
      $get_stories = $db->query(sprintf("SELECT stories.* FROM stories_highlights_items INNER JOIN stories ON stories_highlights_items.story_id = stories.story_id WHERE stories_highlights_items.highlight_id = %s ORDER BY stories_highlights_items.id ASC LIMIT 100", secure($highlight['highlight_id'], 'int')));
    } else {
      $get_stories = $db->query(sprintf("SELECT * FROM stories WHERE user_id = %s AND expires_at > %s ORDER BY story_id ASC LIMIT 100", secure($user_id, 'int'), secure($date)));
    }
    while ($story = $get_stories->fetch_assoc()) {
      if ($this->can_view_story($story)) {
        $rows[$story['story_id']] = $story;
      }
    }
    $seen = [];
    $reactions = [];
    if ($rows && !$is_me) {
      $ids = implode(',', array_keys($rows));
      $get_seen = $db->query(sprintf("SELECT story_id FROM stories_views WHERE user_id = %s AND story_id IN (%s)", secure($this->_data['user_id'], 'int'), $ids));
      $seen = array_column($get_seen->fetch_all(MYSQLI_ASSOC), 'story_id');
      $get_reactions = $db->query(sprintf("SELECT story_id, reaction FROM stories_reactions WHERE user_id = %s AND story_id IN (%s)", secure($this->_data['user_id'], 'int'), $ids));
      $reactions = array_column($get_reactions->fetch_all(MYSQLI_ASSOC), 'reaction', 'story_id');
    }
    $votes = [];
    if ($rows) {
      $get_votes = $db->query(sprintf("SELECT story_id, `option` FROM stories_polls_votes WHERE user_id = %s AND story_id IN (%s)", secure($this->_data['user_id'], 'int'), implode(',', array_keys($rows))));
      $votes = array_column($get_votes->fetch_all(MYSQLI_ASSOC), 'option', 'story_id');
    }
    $music = $this->get_stories_music_tracks(array_column($rows, 'music_id'));
    $start = null;
    foreach ($rows as $story) {
      $item = [
        'id' => (int) $story['story_id'],
        'type' => $story['type'],
        'source' => ($story['source']) ? $system['system_uploads'] . '/' . $story['source'] : '',
        'thumbnail' => ($story['thumbnail']) ? $system['system_uploads'] . '/' . $story['thumbnail'] : '',
        'background' => $story['background'],
        'filter' => $story['filter'],
        'drawing' => ($story['drawing']) ? $system['system_uploads'] . '/' . $story['drawing'] : '',
        'layers' => $this->parse_story_layers($story['layers']),
        'music' => $music[$story['music_id']] ?? null,
        'duration' => (int) $story['duration'],
        'time' => $story['time'],
        'is_ads' => (bool) $story['is_ads'],
        'privacy' => $story['privacy'],
        'poll' => ['votes' => [(int) $story['poll_votes_1'], (int) $story['poll_votes_2']], 'voted' => (int) ($votes[$story['story_id']] ?? 0)],
        'seen' => $is_me || $highlight || $archived || in_array($story['story_id'], $seen),
        'reaction' => $reactions[$story['story_id']] ?? '',
      ];
      if ($is_me || $this->_data['user_group'] < 3) {
        $item['views_count'] = (int) $story['views_count'];
        $item['reactions_count'] = (int) $story['reactions_count'];
      }
      if ($story_id && $story['story_id'] == $story_id) {
        $start = count($items);
      } elseif (!$story_id && $start === null && !$item['seen']) {
        $start = count($items);
      }
      $items[] = $item;
    }
    /* check if the viewer can reply */
    $can_reply = false;
    if (!$is_me && $system['chat_enabled'] && $system['stories_replies_enabled']) {
      try {
        $this->check_recipients_chat_privacy([$author]);
        $can_reply = true;
      } catch (Exception $e) {
        $can_reply = false;
      }
    }
    return [
      'user' => [
        'id' => (int) $author['user_id'],
        'name' => $author['user_name'],
        'fullname' => $author['user_fullname'],
        'picture' => $author['user_picture'],
        'verified' => (bool) $author['user_verified'],
        'url' => $system['system_url'] . '/' . $author['user_name'],
      ],
      'is_me' => $is_me,
      'can_manage' => $is_me || $this->_data['user_group'] < 3,
      'can_reply' => $can_reply,
      'can_react' => (bool) $system['stories_reactions_enabled'],
      'can_highlight' => $is_me && $system['stories_highlights_enabled'],
      'can_repost' => $is_me && $archived && $this->_data['can_add_stories'],
      'video_max' => (int) $system['stories_video_max_duration'],
      'highlight' => ($highlight) ? ['id' => (int) $highlight['highlight_id'], 'title' => html_entity_decode($highlight['title'], ENT_QUOTES)] : null,
      'start' => (int) $start,
      'items' => $items,
    ];
  }


  /**
   * get_story
   *
   * @param integer $story_id
   * @param boolean $active_only
   * @return array|false
   */
  public function get_story($story_id, $active_only = true)
  {
    global $db;
    /* init system datetime */
    $date = init_system_datetime();
    if (!is_numeric($story_id)) {
      return false;
    }
    $get_story = $db->query(sprintf("SELECT * FROM stories WHERE story_id = %s", secure($story_id, 'int')));
    if ($get_story->num_rows == 0) {
      return false;
    }
    $story = $get_story->fetch_assoc();
    if ($active_only && !$story['highlighted'] && $story['user_id'] != $this->_data['user_id'] && strtotime($story['expires_at']) <= strtotime($date)) {
      return false;
    }
    if (!$this->can_view_story($story)) {
      return false;
    }
    return $story;
  }


  /**
   * can_view_story
   *
   * @param array $story
   * @return boolean
   */
  public function can_view_story($story)
  {
    if ($story['user_id'] == $this->_data['user_id'] || $this->_data['user_group'] < 3) {
      return true;
    }
    if ($this->blocked($story['user_id'])) {
      return false;
    }
    if ($story['is_ads']) {
      return true;
    }
    $audience = $this->get_story_audience_flags($story['user_id']);
    if ($audience['hidden']) {
      return false;
    }
    if ($story['privacy'] == 'public') {
      return true;
    }
    if ($story['privacy'] == 'friends') {
      return $this->friendship_approved($story['user_id']);
    }
    return $audience['close'];
  }


  /**
   * get_story_preview
   *
   * @param integer $story_id
   * @return array
   */
  public function get_story_preview($story_id)
  {
    global $db, $system;
    /* init system datetime */
    $date = init_system_datetime();
    $preview = ['story_id' => (int) $story_id, 'unavailable' => true, 'thumbnail' => ''];
    $get_story = $db->query(sprintf("SELECT story_id, type, source, thumbnail, highlighted, expires_at FROM stories WHERE story_id = %s", secure($story_id, 'int')));
    if ($get_story->num_rows == 0) {
      return $preview;
    }
    $story = $get_story->fetch_assoc();
    if (!$story['highlighted'] && strtotime($story['expires_at']) <= strtotime($date)) {
      return $preview;
    }
    $preview['unavailable'] = false;
    $thumbnail = ($story['type'] == 'photo') ? $story['source'] : $story['thumbnail'];
    $preview['thumbnail'] = ($thumbnail) ? $system['system_uploads'] . '/' . $thumbnail : '';
    return $preview;
  }


  /**
   * view_story
   *
   * @param integer $story_id
   * @return void
   */
  public function view_story($story_id)
  {
    global $db, $date;
    $story = $this->get_story($story_id);
    if (!$story) {
      _error(403);
    }
    if ($story['user_id'] == $this->_data['user_id']) {
      return;
    }
    $db->query(sprintf("INSERT IGNORE INTO stories_views (story_id, user_id, time) VALUES (%s, %s, %s)", secure($story_id, 'int'), secure($this->_data['user_id'], 'int'), secure($date)));
    if ($db->affected_rows > 0) {
      $db->query(sprintf("UPDATE stories SET views_count = views_count + 1 WHERE story_id = %s", secure($story_id, 'int')));
    }
  }


  /**
   * react_story
   *
   * @param integer $story_id
   * @param string $reaction
   * @return void
   */
  public function react_story($story_id, $reaction)
  {
    global $db, $system, $date;
    /* check reaction */
    if (!$system['stories_reactions_enabled'] || !isset($system['reactions_enabled'][$reaction])) {
      _error(403);
    }
    $story = $this->get_story($story_id);
    if (!$story || $story['user_id'] == $this->_data['user_id']) {
      _error(403);
    }
    /* view the story */
    $this->view_story($story_id);
    /* remove any previous reaction */
    $this->unreact_story($story_id);
    /* react the story */
    $db->query(sprintf("INSERT INTO stories_reactions (story_id, user_id, reaction, time) VALUES (%s, %s, %s, %s)", secure($story_id, 'int'), secure($this->_data['user_id'], 'int'), secure($reaction), secure($date)));
    $db->query(sprintf("UPDATE stories SET reactions_count = reactions_count + 1 WHERE story_id = %s", secure($story_id, 'int')));
    /* post notification */
    $this->post_notification(['to_user_id' => $story['user_id'], 'action' => 'react_' . $reaction, 'node_type' => 'story', 'node_url' => $story_id]);
  }


  /**
   * unreact_story
   *
   * @param integer $story_id
   * @return void
   */
  public function unreact_story($story_id)
  {
    global $db;
    $get_reaction = $db->query(sprintf("SELECT stories_reactions.reaction, stories.user_id FROM stories_reactions INNER JOIN stories ON stories_reactions.story_id = stories.story_id WHERE stories_reactions.story_id = %s AND stories_reactions.user_id = %s", secure($story_id, 'int'), secure($this->_data['user_id'], 'int')));
    if ($get_reaction->num_rows == 0) {
      return;
    }
    $reaction = $get_reaction->fetch_assoc();
    $db->query(sprintf("DELETE FROM stories_reactions WHERE story_id = %s AND user_id = %s", secure($story_id, 'int'), secure($this->_data['user_id'], 'int')));
    $db->query(sprintf("UPDATE stories SET reactions_count = IF(reactions_count=0,0,reactions_count-1) WHERE story_id = %s", secure($story_id, 'int')));
    /* delete notification */
    $this->delete_notification($reaction['user_id'], 'react_' . $reaction['reaction'], 'story', $story_id);
  }


  /**
   * get_story_viewers
   *
   * @param integer $story_id
   * @param integer $offset
   * @return array
   */
  public function get_story_viewers($story_id, $offset = 0)
  {
    global $db, $system;
    $story = $this->get_story($story_id, false);
    if (!$story || ($story['user_id'] != $this->_data['user_id'] && $this->_data['user_group'] >= 3)) {
      _error(403);
    }
    $viewers = [];
    $offset *= $system['max_results'];
    $get_viewers = $db->query(sprintf(
      "SELECT users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, users.user_subscribed, users.user_verified, stories_reactions.reaction
      FROM stories_views
      INNER JOIN users ON stories_views.user_id = users.user_id
      LEFT JOIN stories_reactions ON stories_reactions.story_id = stories_views.story_id AND stories_reactions.user_id = stories_views.user_id
      WHERE stories_views.story_id = %s
      ORDER BY stories_views.view_id DESC
      LIMIT %s, %s",
      secure($story_id, 'int'),
      secure($offset, 'int', false),
      secure($system['max_results'], 'int', false)
    ));
    while ($viewer = $get_viewers->fetch_assoc()) {
      $viewer['user_picture'] = get_picture($viewer['user_picture'], $viewer['user_gender']);
      $viewers[] = $viewer;
    }
    return ['story' => $story, 'viewers' => $viewers];
  }


  /**
   * delete_story
   *
   * @param integer $story_id
   * @return void
   */
  public function delete_story($story_id)
  {
    global $db;
    $get_story = $db->query(sprintf("SELECT * FROM stories WHERE story_id = %s", secure($story_id, 'int')));
    if ($get_story->num_rows == 0) {
      _error(403);
    }
    $story = $get_story->fetch_assoc();
    if ($story['user_id'] != $this->_data['user_id'] && $this->_data['user_group'] >= 3) {
      _error(403);
    }
    $this->delete_story_data($story);
  }


  /**
   * delete_story_data
   *
   * @param array $story
   * @return void
   */
  public function delete_story_data($story)
  {
    global $db;
    /* delete story files (if not used by its reposts) */
    $origin_id = ($story['origin_id']) ? $story['origin_id'] : $story['story_id'];
    $check = $db->query(sprintf('SELECT COUNT(*) as count FROM stories WHERE story_id != %1$s AND (origin_id = %2$s OR story_id = %2$s)', secure($story['story_id'], 'int'), secure($origin_id, 'int')));
    if ($check->fetch_assoc()['count'] == 0) {
      foreach (['source', 'thumbnail', 'drawing'] as $file) {
        if ($story[$file]) {
          delete_uploads_file($story[$file]);
        }
      }
    }
    /* delete story */
    $db->query(sprintf("DELETE FROM stories WHERE story_id = %s", secure($story['story_id'], 'int')));
    cache_forget('stories:active:' . $story['user_id']);
    $db->query(sprintf("DELETE FROM stories_views WHERE story_id = %s", secure($story['story_id'], 'int')));
    $db->query(sprintf("DELETE FROM stories_reactions WHERE story_id = %s", secure($story['story_id'], 'int')));
    $db->query(sprintf("DELETE FROM stories_polls_votes WHERE story_id = %s", secure($story['story_id'], 'int')));
    /* delete story from highlights */
    $get_highlights = $db->query(sprintf("SELECT highlight_id FROM stories_highlights_items WHERE story_id = %s", secure($story['story_id'], 'int')));
    if ($get_highlights->num_rows > 0) {
      $db->query(sprintf("DELETE FROM stories_highlights_items WHERE story_id = %s", secure($story['story_id'], 'int')));
      while ($highlight = $get_highlights->fetch_assoc()) {
        $this->refresh_stories_highlight($highlight['highlight_id']);
      }
    }
  }


  /**
   * delete_user_stories
   *
   * @param integer $user_id
   * @return void
   */
  public function delete_user_stories($user_id)
  {
    global $db;
    $get_stories = $db->query(sprintf("SELECT * FROM stories WHERE user_id = %s", secure($user_id, 'int')));
    while ($story = $get_stories->fetch_assoc()) {
      $this->delete_story_data($story);
    }
    $db->query(sprintf("DELETE FROM stories_views WHERE user_id = %s", secure($user_id, 'int')));
    $db->query(sprintf("DELETE FROM stories_reactions WHERE user_id = %s", secure($user_id, 'int')));
    $db->query(sprintf("DELETE FROM stories_polls_votes WHERE user_id = %s", secure($user_id, 'int')));
    $db->query(sprintf('DELETE FROM stories_audience WHERE user_id = %1$s OR target_id = %1$s', secure($user_id, 'int')));
  }


  /**
   * vote_story
   * 
   * @param integer $story_id
   * @param integer $option
   * @return array
   */
  public function vote_story($story_id, $option)
  {
    global $db, $system, $date;
    if (!$system['stories_polls_enabled']) {
      _error(403);
    }
    $option = (int) $option;
    $story = $this->get_story($story_id);
    if (!$story || $story['user_id'] == $this->_data['user_id'] || !in_array($option, [1, 2]) || !str_contains(html_entity_decode((string) $story['layers'], ENT_QUOTES, 'UTF-8'), '"type":"poll"')) {
      _error(403);
    }
    $get_vote = $db->query(sprintf("SELECT `option` FROM stories_polls_votes WHERE story_id = %s AND user_id = %s", secure($story_id, 'int'), secure($this->_data['user_id'], 'int')));
    if ($get_vote->num_rows > 0) {
      $voted = (int) $get_vote->fetch_assoc()['option'];
      if ($voted != $option) {
        $db->query(sprintf("UPDATE stories_polls_votes SET `option` = %s WHERE story_id = %s AND user_id = %s", secure($option, 'int'), secure($story_id, 'int'), secure($this->_data['user_id'], 'int')));
        $db->query(sprintf('UPDATE stories SET poll_votes_%1$d = poll_votes_%1$d + 1, poll_votes_%2$d = IF(poll_votes_%2$d=0,0,poll_votes_%2$d-1) WHERE story_id = %3$s', $option, $voted, secure($story_id, 'int')));
      }
    } else {
      $db->query(sprintf("INSERT IGNORE INTO stories_polls_votes (story_id, user_id, `option`, time) VALUES (%s, %s, %s, %s)", secure($story_id, 'int'), secure($this->_data['user_id'], 'int'), secure($option, 'int'), secure($date)));
      if ($db->affected_rows > 0) {
        $db->query(sprintf('UPDATE stories SET poll_votes_%1$d = poll_votes_%1$d + 1 WHERE story_id = %2$s', $option, secure($story_id, 'int')));
        /* post notification */
        $this->post_notification(['to_user_id' => $story['user_id'], 'action' => 'vote', 'node_type' => 'story', 'node_url' => $story_id]);
      }
    }
    $get_votes = $db->query(sprintf("SELECT poll_votes_1, poll_votes_2 FROM stories WHERE story_id = %s", secure($story_id, 'int')));
    $votes = $get_votes->fetch_assoc();
    return ['votes' => [(int) $votes['poll_votes_1'], (int) $votes['poll_votes_2']], 'voted' => $option];
  }


  /**
   * repost_story
   * 
   * @param integer $story_id
   * @return integer
   */
  public function repost_story($story_id)
  {
    global $db, $system, $date;
    /* check stories permission */
    if (!$system['stories_archive_enabled'] || !$this->_data['can_add_stories']) {
      throw new Exception(__("You don't have the permission to do this"));
    }
    $story = $this->check_my_story($story_id);
    if (strtotime($story['expires_at']) > strtotime($date)) {
      throw new ValidationException(__("This story is still active"));
    }
    if ($story['type'] == 'video' && !$this->_data['can_upload_videos']) {
      throw new AuthorizationException(__("Uploading videos feature has been disabled by the admin"));
    }
    if ($story['type'] == 'text' && !$system['stories_text_enabled']) {
      throw new ValidationException(__("This feature has been disabled by the admin"));
    }
    /* check music */
    $music_id = ($story['music_id'] && $this->get_stories_music_tracks([$story['music_id']])) ? $story['music_id'] : null;
    /* insert story */
    $db->query(sprintf(
      "INSERT INTO stories (user_id, origin_id, type, source, thumbnail, background, filter, drawing, layers, duration, music_id, privacy, is_ads, time, expires_at) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)",
      secure($this->_data['user_id'], 'int'),
      secure(($story['origin_id']) ? $story['origin_id'] : $story['story_id'], 'int'),
      secure($story['type']),
      secure($story['source']),
      secure($story['thumbnail']),
      secure($story['background']),
      secure($story['filter']),
      secure($story['drawing']),
      secure(html_entity_decode((string) $story['layers'], ENT_QUOTES, 'UTF-8')),
      secure($story['duration'], 'int'),
      ($music_id) ? secure($music_id, 'int') : 'null',
      secure($story['privacy']),
      secure(($story['is_ads'] && $this->_is_admin) ? '1' : '0'),
      secure($date),
      secure(date('Y-m-d H:i:s', strtotime($date) + 86400))
    ));
    $new_story_id = $db->insert_id;
    cache_forget('stories:active:' . $this->_data['user_id']);
    /* update music uses */
    if ($music_id) {
      $db->query(sprintf("UPDATE stories_music SET uses = uses + 1 WHERE music_id = %s", secure($music_id, 'int')));
    }
    return $new_story_id;
  }


  /**
   * get_stories_archive
   * 
   * @param integer $before
   * @return array
   */
  public function get_stories_archive($before = null)
  {
    global $db, $system, $date;
    $stories = [];
    $limit = 24;
    $before_query = ($before && is_numeric($before)) ? sprintf(" AND story_id < %s", secure($before, 'int')) : "";
    $get_stories = $db->query(sprintf("SELECT story_id, type, source, thumbnail, background, drawing, layers, highlighted, views_count, time FROM stories WHERE user_id = %s AND expires_at <= %s" . $before_query . " ORDER BY story_id DESC LIMIT %s", secure($this->_data['user_id'], 'int'), secure($date), secure($limit + 1, 'int', false)));
    while ($story = $get_stories->fetch_assoc()) {
      $preview = ($story['type'] == 'photo') ? $story['source'] : $story['thumbnail'];
      $story['preview'] = ($preview) ? $system['system_uploads'] . '/' . $preview : '';
      $stories[] = array_merge($story, $this->get_story_thumb($story));
    }
    $more = count($stories) > $limit;
    $stories = array_slice($stories, 0, $limit);
    return ['stories' => $stories, 'more' => $more, 'before' => ($stories) ? end($stories)['story_id'] : null];
  }


  /**
   * get_profile_stories
   * 
   * @param integer $user_id
   * @return array
   */
  public function get_profile_stories($user_id)
  {
    global $db, $system, $date;
    $state = ['active' => false, 'seen' => true, 'highlights' => []];
    if ($user_id != $this->_data['user_id'] && $this->blocked($user_id)) {
      return $state;
    }
    $ids = [];
    $get_stories = $db->query(sprintf("SELECT * FROM stories WHERE user_id = %s AND expires_at > %s ORDER BY story_id DESC LIMIT 100", secure($user_id, 'int'), secure($date)));
    while ($story = $get_stories->fetch_assoc()) {
      if ($this->can_view_story($story)) {
        $ids[] = (int) $story['story_id'];
      }
    }
    if ($ids) {
      $state['active'] = true;
      if ($user_id != $this->_data['user_id']) {
        $get_seen = $db->query(sprintf("SELECT COUNT(*) as count FROM stories_views WHERE user_id = %s AND story_id IN (%s)", secure($this->_data['user_id'], 'int'), implode(',', $ids)));
        $state['seen'] = ($get_seen->fetch_assoc()['count'] >= count($ids));
      }
    }
    $audience = ($user_id == $this->_data['user_id']) ? ['hidden' => false] : $this->get_story_audience_flags($user_id);
    if ($system['stories_highlights_enabled'] && (!$audience['hidden'] || $this->_data['user_group'] < 3)) {
      $state['highlights'] = $this->get_stories_highlights($user_id);
    }
    return $state;
  }


  /**
   * clean_expired_stories
   *
   * @return void
   */
  public function clean_expired_stories()
  {
    global $db, $system, $date;
    /* keep expired stories in the archive */
    if ($system['stories_archive_enabled']) {
      return;
    }
    $lock = $db->query("SELECT GET_LOCK('sngine_stories_cleanup', 0) AS acquired")->fetch_assoc();
    if ((int) $lock['acquired'] !== 1) {
      return;
    }
    $started = microtime(true);
    try {
      do {
        $get_stories = $db->query(sprintf("SELECT * FROM stories WHERE highlighted = '0' AND expires_at <= %s ORDER BY expires_at LIMIT 200", secure($date)));
        $batch = $get_stories->num_rows;
        while ($story = $get_stories->fetch_assoc()) {
          $this->delete_story_data($story);
        }
      } while ($batch === 200 && microtime(true) - $started < 15);
    } finally {
      $db->query("SELECT RELEASE_LOCK('sngine_stories_cleanup')");
    }
  }


  /**
   * delete_expired_stories
   *
   * @param boolean $include_highlighted
   * @return integer
   */
  public function delete_expired_stories($include_highlighted = false)
  {
    global $db, $date;
    $deleted = 0;
    $highlighted_query = ($include_highlighted) ? "" : " AND highlighted = '0'";
    do {
      $get_stories = $db->query(sprintf("SELECT * FROM stories WHERE expires_at <= %s" . $highlighted_query . " ORDER BY expires_at LIMIT 200", secure($date)));
      $batch = $get_stories->num_rows;
      while ($story = $get_stories->fetch_assoc()) {
        $this->delete_story_data($story);
      }
      $deleted += $batch;
    } while ($batch === 200);
    return $deleted;
  }

  /**
   * get_active_stories
   * 
   * @param array $users_ids
   * @return array
   */
  public function get_active_stories($users_ids)
  {
    global $db, $date;
    $active = [];
    $missing = $users_ids;
    /* get cached authors */
    $cached = redis_run(function ($redis) use ($users_ids) {
      return $redis->mget(array_map(function ($user_id) {
        return redis_key('stories:active:' . $user_id);
      }, $users_ids));
    });
    if (is_array($cached)) {
      foreach (array_values($users_ids) as $index => $user_id) {
        $stories = (isset($cached[$index])) ? json_decode($cached[$index], true) : null;
        if (is_array($stories)) {
          $active[$user_id] = $stories;
        }
      }
      $missing = array_diff($users_ids, array_keys($active));
    }
    /* get the other authors */
    if ($missing) {
      $rows = array_fill_keys($missing, []);
      $get_stories = $db->query(sprintf("SELECT story_id, user_id, privacy, is_ads, expires_at FROM stories WHERE user_id IN (%s) AND expires_at > %s", implode(',', $missing), secure($date)));
      while ($story = $get_stories->fetch_assoc()) {
        $rows[$story['user_id']][] = ['story_id' => (int) $story['story_id'], 'privacy' => $story['privacy'], 'is_ads' => (bool) $story['is_ads'], 'expires_at' => $story['expires_at']];
      }
      redis_run(function ($redis) use ($rows) {
        $redis->pipeline(function ($pipe) use ($rows) {
          foreach ($rows as $user_id => $stories) {
            $pipe->setex(redis_key('stories:active:' . $user_id), 600, json_encode($stories));
          }
        });
      });
      $active += $rows;
    }
    /* remove expired stories */
    $now = strtotime($date);
    foreach ($active as $user_id => $stories) {
      $active[$user_id] = array_values(array_filter($stories, function ($story) use ($now) {
        return strtotime($story['expires_at']) > $now;
      }));
    }
    return array_filter($active);
  }


  /**
   * get_stories_rings
   * 
   * @param array $users_ids
   * @return array
   */
  public function get_stories_rings($users_ids)
  {
    global $db, $system;
    static $rings = [];
    if (!$this->_logged_in || !$system['stories_enabled']) {
      return [];
    }
    $me = (int) $this->_data['user_id'];
    $users_ids = array_slice(array_values(array_unique(array_filter(array_map('intval', $users_ids)))), 0, 100);
    $pending = array_values(array_diff($users_ids, array_keys($rings)));
    if ($pending) {
      $rings += array_fill_keys($pending, '');
      $active = $this->get_active_stories($pending);
      $authors = array_diff(array_keys($active), [$me]);
      /* get the viewer place in authors lists */
      $audience = [];
      if ($authors && $this->_data['user_group'] >= 3) {
        $get_audience = $db->query(sprintf("SELECT user_id, type FROM stories_audience WHERE target_id = %s AND user_id IN (%s)", secure($me, 'int'), implode(',', $authors)));
        while ($row = $get_audience->fetch_assoc()) {
          $audience[$row['user_id']][$row['type']] = true;
        }
      }
      /* get visible stories */
      $visible = [];
      foreach ($authors as $author_id) {
        if ($this->blocked($author_id)) {
          continue;
        }
        foreach ($active[$author_id] as $story) {
          if ($this->_data['user_group'] < 3 || $story['is_ads']) {
            $visible[$author_id][] = $story['story_id'];
          } elseif (!empty($audience[$author_id]['hidden'])) {
            continue;
          } elseif ($story['privacy'] == 'public' || ($story['privacy'] == 'friends' && $this->friendship_approved($author_id)) || ($story['privacy'] == 'close_friends' && !empty($audience[$author_id]['close']))) {
            $visible[$author_id][] = $story['story_id'];
          }
        }
      }
      /* get seen stories */
      $seen = [];
      if ($visible) {
        $get_seen = $db->query(sprintf("SELECT story_id FROM stories_views WHERE user_id = %s AND story_id IN (%s)", secure($me, 'int'), implode(',', array_merge(...array_values($visible)))));
        $seen = array_map('intval', array_column($get_seen->fetch_all(MYSQLI_ASSOC), 'story_id'));
      }
      foreach ($visible as $author_id => $stories_ids) {
        $rings[$author_id] = (array_diff($stories_ids, $seen)) ? 'unseen' : 'seen';
      }
      if (!empty($active[$me])) {
        $rings[$me] = 'seen';
      }
    }
    return array_filter(array_intersect_key($rings, array_flip($users_ids)));
  }
}
