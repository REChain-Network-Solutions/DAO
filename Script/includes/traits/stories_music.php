<?php

/**
 * trait -> stories music
 * 
 * @package Sngine
 * @author Zamblek
 */

trait StoriesMusicTrait
{

  /* ------------------------------- */
  /* Stories Music */
  /* ------------------------------- */

  /**
   * get_stories_music
   * 
   * @param string $tab
   * @param string $query
   * @return array
   */
  public function get_stories_music($tab = 'trending', $query = '')
  {
    global $db, $system;
    $tracks = [];
    if (!$system['stories_music_enabled']) {
      return $tracks;
    }
    $where = "enabled = '1'";
    if (!$system['stories_music_itunes_enabled']) {
      $where .= " AND provider != 'itunes'";
    }
    if (!$system['stories_music_library_enabled']) {
      $where .= " AND provider != 'library'";
    }
    if (!is_empty($query)) {
      $where .= sprintf(" AND provider = 'library' AND (title LIKE %1\$s OR artist LIKE %1\$s)", secure($query, 'search'));
      $order = "music_id DESC";
    } elseif ($tab == 'library') {
      $where .= " AND provider = 'library'";
      $order = "music_id DESC";
    } else {
      $where .= " AND uses > 0";
      $order = "uses DESC, music_id DESC";
    }
    $get_tracks = $db->query("SELECT * FROM stories_music WHERE " . $where . " ORDER BY " . $order . " LIMIT 30");
    while ($track = $get_tracks->fetch_assoc()) {
      $tracks[] = $this->parse_story_music($track);
    }
    /* add itunes charts */
    if (is_empty($query) && $tab != 'library' && $system['stories_music_itunes_enabled']) {
      $listed = array_column(array_filter($tracks, function ($track) {
        return $track['provider'] == 'itunes';
      }), 'id');
      $disabled = [];
      $charts = $this->get_itunes_charts();
      if ($charts) {
        $get_disabled = $db->query(sprintf("SELECT provider_id FROM stories_music WHERE provider = 'itunes' AND enabled = '0' AND provider_id IN (%s)", implode(',', array_map(function ($track) {
          return secure($track['id']);
        }, $charts))));
        $disabled = array_column($get_disabled->fetch_all(MYSQLI_ASSOC), 'provider_id');
      }
      foreach ($charts as $track) {
        if (!in_array($track['id'], $listed) && !in_array($track['id'], $disabled)) {
          $tracks[] = $track;
        }
      }
    }
    return $tracks;
  }


  /**
   * parse_story_music
   * 
   * @param array $track
   * @return array
   */
  public function parse_story_music($track)
  {
    global $system;
    $is_library = ($track['provider'] == 'library');
    return [
      'music_id' => (int) $track['music_id'],
      'provider' => $track['provider'],
      'id' => ($is_library) ? (int) $track['music_id'] : $track['provider_id'],
      'title' => html_entity_decode($track['title'], ENT_QUOTES),
      'artist' => html_entity_decode($track['artist'], ENT_QUOTES),
      'cover' => ($track['cover']) ? (($is_library) ? $system['system_uploads'] . '/' . $track['cover'] : html_entity_decode($track['cover'], ENT_QUOTES)) : '',
      'source' => ($is_library) ? $system['system_uploads'] . '/' . $track['source'] : html_entity_decode($track['source'], ENT_QUOTES),
      'url' => html_entity_decode($track['url'], ENT_QUOTES),
      'uses' => (int) $track['uses'],
    ];
  }


  /**
   * get_stories_music_tracks
   * 
   * @param array $ids
   * @return array
   */
  public function get_stories_music_tracks($ids)
  {
    global $db, $system;
    $tracks = [];
    $ids = array_filter(array_unique(array_map('intval', $ids)));
    if (!$ids || !$system['stories_music_enabled']) {
      return $tracks;
    }
    $get_tracks = $db->query(sprintf("SELECT * FROM stories_music WHERE enabled = '1' AND music_id IN (%s)", implode(',', $ids)));
    while ($track = $get_tracks->fetch_assoc()) {
      $tracks[$track['music_id']] = $this->parse_story_music($track);
    }
    return $tracks;
  }


  /**
   * resolve_story_music
   * 
   * @param array $music
   * @return integer
   */
  public function resolve_story_music($music)
  {
    global $db, $system, $date;
    $music = (array) $music;
    $provider = $music['provider'] ?? '';
    $id = $music['id'] ?? '';
    if (!$system['stories_music_enabled'] || !is_numeric($id) || !in_array($provider, ['library', 'itunes']) || !$system['stories_music_' . $provider . '_enabled']) {
      throw new ValidationException(__("This track is not available"));
    }
    if ($provider == 'library') {
      $get_track = $db->query(sprintf("SELECT music_id FROM stories_music WHERE provider = 'library' AND enabled = '1' AND music_id = %s", secure($id, 'int')));
      if ($get_track->num_rows == 0) {
        throw new ValidationException(__("This track is not available"));
      }
      return (int) $get_track->fetch_assoc()['music_id'];
    }
    $get_track = $db->query(sprintf("SELECT music_id, enabled FROM stories_music WHERE provider = 'itunes' AND provider_id = %s", secure($id)));
    if ($get_track->num_rows > 0) {
      $track = $get_track->fetch_assoc();
      if (!$track['enabled']) {
        throw new ValidationException(__("This track is not available"));
      }
      return (int) $track['music_id'];
    }
    $track = $this->itunes_lookup($id);
    if (!$track) {
      throw new ValidationException(__("This track is not available"));
    }
    $db->query(sprintf(
      "INSERT INTO stories_music (provider, provider_id, title, artist, cover, source, url, time, updated_at) VALUES ('itunes', %s, %s, %s, %s, %s, %s, %s, %s) ON DUPLICATE KEY UPDATE music_id = LAST_INSERT_ID(music_id)",
      secure($id),
      secure($track['title']),
      secure($track['artist']),
      secure($track['cover']),
      secure($track['source']),
      secure($track['url']),
      secure($date),
      secure($date)
    ));
    return (int) $db->insert_id;
  }


  /**
   * refresh_story_music
   * 
   * @param integer $music_id
   * @return array|false
   */
  public function refresh_story_music($music_id)
  {
    global $db, $date;
    $get_track = $db->query(sprintf("SELECT * FROM stories_music WHERE provider = 'itunes' AND enabled = '1' AND music_id = %s", secure($music_id, 'int')));
    if ($get_track->num_rows == 0) {
      return false;
    }
    $track = $get_track->fetch_assoc();
    /* refresh once per hour */
    if (strtotime($date) - strtotime($track['updated_at']) < 3600) {
      return false;
    }
    $db->query(sprintf("UPDATE stories_music SET updated_at = %s WHERE music_id = %s", secure($date), secure($music_id, 'int')));
    $fresh = $this->itunes_lookup($track['provider_id']);
    if (!$fresh || $fresh['source'] == html_entity_decode($track['source'], ENT_QUOTES)) {
      return false;
    }
    $db->query(sprintf("UPDATE stories_music SET source = %s, cover = %s, url = %s WHERE music_id = %s", secure($fresh['source']), secure($fresh['cover']), secure($fresh['url']), secure($music_id, 'int')));
    $track['source'] = $fresh['source'];
    $track['cover'] = $fresh['cover'];
    $track['url'] = $fresh['url'];
    return $this->parse_story_music($track);
  }


  /**
   * get_itunes_charts
   * 
   * @return array
   */
  public function get_itunes_charts()
  {
    global $system;
    $country = (preg_match('/^[a-z]{2}$/i', (string) $system['stories_music_itunes_country'])) ? strtolower($system['stories_music_itunes_country']) : 'us';
    $charts = system_cache_read('stories_itunes_charts_' . $country, 'stories', 21600);
    if ($charts !== null) {
      return $charts;
    }
    /* retry failed requests after 10 minutes */
    if (system_cache_read('stories_itunes_charts_failed_' . $country, 'stories', 600) !== null) {
      return [];
    }
    $charts = [];
    $curl = curl_init();
    curl_setopt_array($curl, [
      CURLOPT_URL => "https://itunes.apple.com/" . $country . "/rss/topsongs/limit=50/json",
      CURLOPT_RETURNTRANSFER => true,
      CURLOPT_CONNECTTIMEOUT => 3,
      CURLOPT_TIMEOUT => 6,
    ]);
    $response = curl_exec($curl);
    $http_code = curl_getinfo($curl, CURLINFO_HTTP_CODE);
    curl_close($curl);
    $response = ($response !== false && $http_code == 200) ? json_decode($response, true) : null;
    $entries = $response['feed']['entry'] ?? [];
    foreach ((is_array($entries) && array_is_list($entries)) ? $entries : [] as $entry) {
      $id = (string) ($entry['id']['attributes']['im:id'] ?? '');
      $source = '';
      foreach ((array) ($entry['link'] ?? []) as $link) {
        if (($link['attributes']['im:assetType'] ?? '') == 'preview') {
          $source = (string) ($link['attributes']['href'] ?? '');
        }
      }
      if (!ctype_digit($id) || !preg_match('/^https:\/\/[a-z0-9.-]+\.apple\.com\//i', $source)) {
        continue;
      }
      $images = (array) ($entry['im:image'] ?? []);
      $cover = (string) (end($images)['label'] ?? '');
      $url = (string) ($entry['id']['label'] ?? '');
      $charts[] = [
        'provider' => 'itunes',
        'id' => $id,
        'title' => mb_substr((string) ($entry['im:name']['label'] ?? ''), 0, 250),
        'artist' => mb_substr((string) ($entry['im:artist']['label'] ?? ''), 0, 250),
        'cover' => (preg_match('/^https:\/\/[a-z0-9.-]+\.mzstatic\.com\//i', $cover)) ? $cover : '',
        'source' => $source,
        'url' => (preg_match('/^https:\/\/[a-z0-9.-]+\.apple\.com\//i', $url)) ? $url : '',
        'uses' => 0,
      ];
    }
    if ($charts) {
      system_cache_write('stories_itunes_charts_' . $country, $charts, 'stories');
    } else {
      system_cache_write('stories_itunes_charts_failed_' . $country, [], 'stories');
    }
    return $charts;
  }


  /**
   * itunes_lookup
   * 
   * @param string $track_id
   * @return array|false
   */
  public function itunes_lookup($track_id)
  {
    global $system;
    $country = (preg_match('/^[a-z]{2}$/i', (string) $system['stories_music_itunes_country'])) ? strtoupper($system['stories_music_itunes_country']) : 'US';
    $curl = curl_init();
    curl_setopt_array($curl, [
      CURLOPT_URL => "https://itunes.apple.com/lookup?entity=song&country=" . $country . "&id=" . urlencode($track_id),
      CURLOPT_RETURNTRANSFER => true,
      CURLOPT_CONNECTTIMEOUT => 3,
      CURLOPT_TIMEOUT => 6,
    ]);
    $response = curl_exec($curl);
    $http_code = curl_getinfo($curl, CURLINFO_HTTP_CODE);
    curl_close($curl);
    if ($response === false || $http_code != 200) {
      return false;
    }
    $response = json_decode($response, true);
    $result = $response['results'][0] ?? null;
    if (!$result || ($result['kind'] ?? '') != 'song' || empty($result['previewUrl']) || !preg_match('/^https:\/\/[a-z0-9.-]+\.apple\.com\//i', $result['previewUrl'])) {
      return false;
    }
    $cover = (string) ($result['artworkUrl100'] ?? '');
    $url = (string) ($result['trackViewUrl'] ?? '');
    return [
      'title' => mb_substr((string) ($result['trackName'] ?? ''), 0, 250),
      'artist' => mb_substr((string) ($result['artistName'] ?? ''), 0, 250),
      'cover' => (preg_match('/^https:\/\/[a-z0-9.-]+\.mzstatic\.com\//i', $cover)) ? $cover : '',
      'source' => $result['previewUrl'],
      'url' => (preg_match('/^https:\/\/[a-z0-9.-]+\.apple\.com\//i', $url)) ? $url : '',
    ];
  }
}
