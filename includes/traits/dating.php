<?php

/**
 * trait -> dating
 *
 * @package Sngine
 * @author Zamblek
 */

trait DatingTrait
{

  private $_dating_profile = false;
  private $_dating_matched = [];
  public $_dating_more = false;


  /* ------------------------------- */
  /* Dating */
  /* ------------------------------- */

  /**
   * dating_paid_enabled
   *
   * @return boolean
   */
  public function dating_paid_enabled()
  {
    global $system;
    return $system['wallet_enabled'] && method_exists($this, 'wallet_set_transaction');
  }


  /**
   * dating_perk
   *
   * @param string $perk
   * @return boolean
   */
  public function dating_perk($perk)
  {
    global $system;
    if ($perk == 'likes_list' && $system['dating_free_likes_list']) {
      return true;
    }
    return $system['packages_enabled'] && $this->_data['user_subscribed'] && !empty($this->_data['dating_' . $perk . '_enabled']);
  }


  /**
   * dating_feature_available
   *
   * @param string $feature
   * @return boolean
   */
  public function dating_feature_available($feature)
  {
    global $system;
    if ($system['packages_enabled']) {
      return true;
    }
    $profile = $this->get_dating_profile();
    switch ($feature) {
      case 'super_likes':
        if ($profile && ((int) $profile['super_likes_included'] + (int) $profile['super_likes_balance']) > 0) {
          return true;
        }
        return $this->dating_paid_enabled() && $system['dating_super_likes_price'] > 0 && $system['dating_super_likes_pack'] > 0;

      case 'boosts':
        if ($profile && ($profile['boosted'] || (int) $profile['boosts_included'] > 0)) {
          return true;
        }
        return $this->dating_paid_enabled() && $system['dating_boost_price'] > 0;

      default:
        return false;
    }
  }


  /**
   * dating_distance_unit
   *
   * @return float
   */
  public function dating_distance_unit()
  {
    global $system;
    return ($system['system_distance'] == "mile") ? 1.609344 : 1;
  }


  /**
   * get_dating_profile
   *
   * @param integer $user_id
   * @return array|null
   */
  public function get_dating_profile($user_id = null)
  {
    global $db;
    $own = ($user_id === null || $user_id == $this->_data['user_id']);
    if ($own && $this->_dating_profile !== false) {
      return $this->_dating_profile;
    }
    $get_profile = $db->query(sprintf("SELECT * FROM dating_profiles WHERE user_id = %s", secure(($own) ? $this->_data['user_id'] : $user_id, 'int')));
    $profile = ($get_profile->num_rows > 0) ? $get_profile->fetch_assoc() : null;
    if ($profile) {
      $profile['show_genders'] = ($profile['show_genders'] === '') ? [] : array_map('intval', explode(',', $profile['show_genders']));
      $profile['age'] = get_user_age($profile['birthdate']);
      $profile['boosted'] = $profile['boosted_until'] && strtotime($profile['boosted_until']) > time();
    }
    if ($own) {
      $this->_dating_profile = $profile;
    }
    return $profile;
  }


  /**
   * get_dating_interests
   *
   * @return array
   */
  public function get_dating_interests()
  {
    global $db;
    static $interests = null;
    if ($interests === null) {
      $interests = [];
      $get_interests = $db->query("SELECT * FROM dating_interests ORDER BY interest_order ASC, interest_id ASC");
      while ($interest = $get_interests->fetch_assoc()) {
        $interests[$interest['interest_id']] = $interest;
      }
    }
    return $interests;
  }


  /**
   * get_dating_profiles_interests
   *
   * @param array $users_ids
   * @return array
   */
  public function get_dating_profiles_interests($users_ids)
  {
    global $db;
    $interests = [];
    $users_ids = array_map('intval', $users_ids);
    if (!$users_ids) {
      return $interests;
    }
    $get_interests = $db->query("SELECT user_id, interest_id FROM dating_profiles_interests WHERE user_id IN (" . implode(',', $users_ids) . ")");
    while ($interest = $get_interests->fetch_assoc()) {
      $interests[$interest['user_id']][] = (int) $interest['interest_id'];
    }
    return $interests;
  }


  /**
   * get_dating_photos
   *
   * @param array $users_ids
   * @param boolean $approved
   * @return array
   */
  public function get_dating_photos($users_ids, $approved = true)
  {
    global $db, $system;
    $photos = [];
    $users_ids = array_map('intval', $users_ids);
    if (!$users_ids) {
      return $photos;
    }
    $status_statement = ($approved) ? " AND status = 'approved'" : "";
    $get_photos = $db->query("SELECT * FROM dating_photos WHERE user_id IN (" . implode(',', $users_ids) . ")" . $status_statement . " ORDER BY photo_order ASC, photo_id ASC");
    while ($photo = $get_photos->fetch_assoc()) {
      $photo['url'] = $system['system_uploads'] . '/' . $photo['source'];
      $photos[$photo['user_id']][] = $photo;
    }
    return $photos;
  }


  /**
   * save_dating_profile
   *
   * @param array $args
   * @return void
   */
  public function save_dating_profile($args)
  {
    global $db, $system, $date;
    $profile = $this->get_dating_profile();
    /* check permission */
    if (!$this->_data['can_use_dating']) {
      throw new ValidationException(__("You don't have the permission to do this"));
    }
    if ($system['dating_verified_only'] && !$this->_data['user_verified']) {
      throw new ValidationException(__("Only verified members can join dating"));
    }
    if ($profile && $profile['status'] == 'suspended') {
      throw new ValidationException(__("Your dating profile has been suspended"));
    }
    /* validate birthdate */
    if (!$profile) {
      $birthdate = DateTime::createFromFormat('!Y-m-d', (string) ($args['birthdate'] ?? ''));
      if (!$birthdate || $birthdate->format('Y-m-d') !== $args['birthdate']) {
        throw new ValidationException(__("Please select a valid birthdate"));
      }
      $birthdate = $birthdate->format('Y-m-d');
    } else {
      $birthdate = $profile['birthdate'];
    }
    $min_age = max(18, (int) $system['dating_min_age']);
    if (get_user_age($birthdate) < $min_age) {
      throw new ValidationException(__("You must be") . " " . $min_age . " " . __("years old or older to join dating"));
    }
    /* validate gender */
    if (!isset($args['gender']) || !$this->check_gender($args['gender'])) {
      throw new ValidationException(__("Please select a valid gender"));
    }
    /* validate show genders */
    $show_genders = [];
    foreach ((array) ($args['show_genders'] ?? []) as $gender_id) {
      if ($this->check_gender($gender_id)) {
        $show_genders[] = (int) $gender_id;
      }
    }
    /* validate ages */
    $show_min_age = max($min_age, min(99, (int) ($args['min_age'] ?? $min_age)));
    $show_max_age = max($show_min_age, min(99, (int) ($args['max_age'] ?? 99)));
    /* validate distance */
    $max_distance = max(1, min(max(1, (int) $system['dating_max_distance']), (int) ($args['max_distance'] ?? $system['dating_max_distance'])));
    /* validate bio */
    $bio = censored_words(trim((string) ($args['bio'] ?? '')));
    if (mb_strlen($bio) > 500) {
      throw new ValidationException(__("Your bio must be less than 500 characters long"));
    }
    /* validate location */
    $country_id = (int) ($args['country'] ?? 0);
    if ($country_id && !$this->check_country($country_id)) {
      throw new ValidationException(__("Please select a valid country"));
    }
    $city = trim((string) ($args['city'] ?? ''));
    if (mb_strlen($city) > 100) {
      throw new ValidationException(__("Please enter a valid city"));
    }
    $city_key = ($city === '') ? '' : $country_id . ':' . mb_strtolower($city);
    /* validate interests */
    $interests = array_values(array_intersect(array_map('intval', (array) ($args['interests'] ?? [])), array_keys($this->get_dating_interests())));
    $max_interests = max(1, (int) $system['dating_max_interests']);
    if (count($interests) > $max_interests) {
      throw new ValidationException(__("You can select up to") . " " . $max_interests . " " . __("interests"));
    }
    /* privacy */
    $hide_from_friends = (isset($args['hide_from_friends'])) ? '1' : '0';
    $hide_age = (isset($args['hide_age'])) ? '1' : '0';
    $hide_distance = (isset($args['hide_distance'])) ? '1' : '0';
    $incognito = (isset($args['incognito']) && $this->dating_perk('incognito')) ? '1' : '0';
    /* save */
    if (!$profile) {
      $db->query(sprintf(
        "INSERT INTO dating_profiles (user_id, gender, birthdate, show_genders, min_age, max_age, max_distance, bio, country_id, city, city_key, hide_from_friends, incognito, hide_age, hide_distance, time) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)",
        secure($this->_data['user_id'], 'int'),
        secure($args['gender'], 'int'),
        secure($birthdate),
        secure(implode(',', $show_genders)),
        secure($show_min_age, 'int'),
        secure($show_max_age, 'int'),
        secure($max_distance, 'int'),
        secure($bio),
        secure($country_id, 'int'),
        secure($city),
        secure($city_key),
        secure($hide_from_friends),
        secure($incognito),
        secure($hide_age),
        secure($hide_distance),
        secure($date)
      ));
    } else {
      $db->query(sprintf(
        "UPDATE dating_profiles SET gender = %s, show_genders = %s, min_age = %s, max_age = %s, max_distance = %s, bio = %s, country_id = %s, city = %s, city_key = %s, hide_from_friends = %s, incognito = %s, hide_age = %s, hide_distance = %s WHERE user_id = %s",
        secure($args['gender'], 'int'),
        secure(implode(',', $show_genders)),
        secure($show_min_age, 'int'),
        secure($show_max_age, 'int'),
        secure($max_distance, 'int'),
        secure($bio),
        secure($country_id, 'int'),
        secure($city),
        secure($city_key),
        secure($hide_from_friends),
        secure($incognito),
        secure($hide_age),
        secure($hide_distance),
        secure($this->_data['user_id'], 'int')
      ));
    }
    /* save interests */
    $db->query(sprintf("DELETE FROM dating_profiles_interests WHERE user_id = %s", secure($this->_data['user_id'], 'int')));
    foreach ($interests as $interest_id) {
      $db->query(sprintf("INSERT INTO dating_profiles_interests (user_id, interest_id) VALUES (%s, %s)", secure($this->_data['user_id'], 'int'), secure($interest_id, 'int')));
    }
    $this->_dating_profile = false;
    $this->dating_sync_location();
  }


  /**
   * set_dating_status
   *
   * @param string $status
   * @return void
   */
  public function set_dating_status($status)
  {
    global $db;
    $profile = $this->get_dating_profile();
    if (!$profile || $profile['status'] == 'suspended' || !in_array($status, ['active', 'paused'])) {
      throw new ValidationException(__("You can't do this right now"));
    }
    $db->query(sprintf("UPDATE dating_profiles SET status = %s WHERE user_id = %s", secure($status), secure($this->_data['user_id'], 'int')));
    $this->_dating_profile = false;
    $this->dating_sync_location();
  }


  /**
   * dating_sync_location
   *
   * @return void
   */
  public function dating_sync_location()
  {
    global $db;
    $profile = $this->get_dating_profile();
    if (!$profile) {
      return;
    }
    $located = valid_location($this->_data['user_latitude'] ?? null, $this->_data['user_longitude'] ?? null);
    /* only active profiles are searchable by distance */
    if (!$located || $profile['status'] != 'active') {
      $db->query(sprintf("DELETE FROM dating_locations WHERE user_id = %s", secure($this->_data['user_id'], 'int')));
      if ($profile['latitude'] !== null) {
        $db->query(sprintf("UPDATE dating_profiles SET latitude = NULL, longitude = NULL WHERE user_id = %s", secure($this->_data['user_id'], 'int')));
        $this->_dating_profile = false;
      }
      return;
    }
    if ($profile['latitude'] !== null && abs($profile['latitude'] - $this->_data['user_latitude']) < 0.000001 && abs($profile['longitude'] - $this->_data['user_longitude']) < 0.000001) {
      return;
    }
    $db->query(sprintf("UPDATE dating_profiles SET latitude = %s, longitude = %s WHERE user_id = %s", secure(sprintf("%.7F", $this->_data['user_latitude'])), secure(sprintf("%.7F", $this->_data['user_longitude'])), secure($this->_data['user_id'], 'int')));
    $db->query(sprintf("INSERT INTO dating_locations (user_id, location) VALUES (%1\$s, %2\$s) ON DUPLICATE KEY UPDATE location = %2\$s", secure($this->_data['user_id'], 'int'), location_point($this->_data['user_latitude'], $this->_data['user_longitude'])));
    $this->_dating_profile = false;
  }


  /**
   * delete_dating_profile
   *
   * @param integer $user_id
   * @return void
   */
  public function delete_dating_profile($user_id = null)
  {
    global $db;
    $user_id = ($user_id === null) ? $this->_data['user_id'] : $user_id;
    /* delete photos */
    $get_photos = $db->query(sprintf("SELECT source FROM dating_photos WHERE user_id = %s", secure($user_id, 'int')));
    while ($photo = $get_photos->fetch_assoc()) {
      delete_uploads_file($photo['source']);
    }
    $db->query(sprintf("DELETE FROM dating_photos WHERE user_id = %s", secure($user_id, 'int')));
    $db->query(sprintf("DELETE FROM dating_profiles_interests WHERE user_id = %s", secure($user_id, 'int')));
    $db->query(sprintf("DELETE FROM dating_locations WHERE user_id = %s", secure($user_id, 'int')));
    $db->query(sprintf("DELETE FROM dating_swipes WHERE user_id = %s", secure($user_id, 'int')));
    $db->query(sprintf("DELETE FROM dating_swipes WHERE target_id = %s", secure($user_id, 'int')));
    $db->query(sprintf("DELETE FROM dating_matches WHERE user_one_id = %s", secure($user_id, 'int')));
    $db->query(sprintf("DELETE FROM dating_matches WHERE user_two_id = %s", secure($user_id, 'int')));
    $db->query(sprintf("DELETE FROM dating_profiles WHERE user_id = %s", secure($user_id, 'int')));
    if ($user_id == $this->_data['user_id']) {
      $this->_dating_profile = false;
    }
  }


  /* ------------------------------- */
  /* Dating Photos */
  /* ------------------------------- */

  /**
   * add_dating_photo
   *
   * @param string $source
   * @return array
   */
  public function add_dating_photo($source)
  {
    global $db, $system, $date;
    if (!$this->_data['can_use_dating']) {
      throw new ValidationException(__("You don't have the permission to do this"));
    }
    if (!$this->get_dating_profile()) {
      throw new ValidationException(__("You can't do this right now"));
    }
    if (is_empty($source) || !is_valid_upload_source($source)) {
      throw new ValidationException(__("Please upload a valid photo"));
    }
    /* only my own dating uploads */
    $check = $db->query(sprintf("SELECT COUNT(*) AS count FROM users_uploads_pending WHERE user_id = %s AND file_name = %s AND handle = 'dating'", secure($this->_data['user_id'], 'int'), secure($source)));
    if ($check->fetch_assoc()['count'] == 0) {
      throw new ValidationException(__("Please upload a valid photo"));
    }
    $count = $db->query(sprintf("SELECT COUNT(*) AS count FROM dating_photos WHERE user_id = %s", secure($this->_data['user_id'], 'int')))->fetch_assoc()['count'];
    if ($count >= max(1, (int) $system['dating_max_photos'])) {
      throw new ValidationException(__("You have reached the maximum number of photos"));
    }
    $status = ($system['dating_photos_approval'] && !$this->_is_admin) ? 'pending' : 'approved';
    $db->query(sprintf("INSERT INTO dating_photos (user_id, source, status, photo_order, time) VALUES (%s, %s, %s, %s, %s)", secure($this->_data['user_id'], 'int'), secure($source), secure($status), secure($count, 'int'), secure($date)));
    $photo_id = $db->insert_id;
    remove_pending_uploads([$source]);
    return ['photo_id' => $photo_id, 'source' => $source, 'status' => $status, 'url' => $system['system_uploads'] . '/' . $source];
  }


  /**
   * delete_dating_photo
   *
   * @param integer $photo_id
   * @param boolean $from_admin
   * @return void
   */
  public function delete_dating_photo($photo_id, $from_admin = false)
  {
    global $db;
    $owner_statement = ($from_admin) ? "" : sprintf(" AND user_id = %s", secure($this->_data['user_id'], 'int'));
    $get_photo = $db->query(sprintf("SELECT * FROM dating_photos WHERE photo_id = %s", secure($photo_id, 'int')) . $owner_statement);
    if ($get_photo->num_rows == 0) {
      throw new ValidationException(__("This photo is not available"));
    }
    $photo = $get_photo->fetch_assoc();
    $db->query(sprintf("DELETE FROM dating_photos WHERE photo_id = %s", secure($photo_id, 'int')));
    delete_uploads_file($photo['source']);
  }


  /**
   * sort_dating_photos
   *
   * @param array $photos_ids
   * @return void
   */
  public function sort_dating_photos($photos_ids)
  {
    global $db;
    foreach (array_slice(array_values((array) $photos_ids), 0, 20) as $order => $photo_id) {
      $db->query(sprintf("UPDATE dating_photos SET photo_order = %s WHERE photo_id = %s AND user_id = %s", secure($order, 'int'), secure($photo_id, 'int'), secure($this->_data['user_id'], 'int')));
    }
  }


  /* ------------------------------- */
  /* Dating Discovery */
  /* ------------------------------- */

  /**
   * dating_filter
   *
   * @param array $rows
   * @param array $options
   * @return Closure
   */
  private function dating_filter(&$rows, $options = [])
  {
    global $db, $system;
    $me = $this->get_dating_profile();
    $my_id = (int) $this->_data['user_id'];
    $genders = array_map('intval', $options['genders'] ?? $me['show_genders']);
    $min_age = (int) ($options['min_age'] ?? $me['min_age']);
    $max_age = (int) ($options['max_age'] ?? $me['max_age']);
    $interest = (int) ($options['interest'] ?? 0);
    $friends = array_fill_keys(array_map('intval', $this->friends_ids()), true);
    return function ($ids) use (&$rows, $db, $system, $me, $my_id, $genders, $min_age, $max_age, $interest, $friends) {
      $ids = array_map('intval', $ids);
      if (!$ids) {
        return [];
      }
      /* eligible profiles */
      $where = "p.status = 'active' AND u.user_banned = '0'";
      $where .= ($genders) ? " AND p.gender IN (" . implode(',', $genders) . ")" : "";
      $where .= sprintf(" AND (p.show_genders = '' OR FIND_IN_SET(%s, p.show_genders))", secure($me['gender'], 'int'));
      $where .= sprintf(" AND p.birthdate <= DATE_SUB(CURDATE(), INTERVAL %s YEAR)", secure($min_age, 'int'));
      $where .= ($max_age < 99) ? sprintf(" AND p.birthdate > DATE_SUB(CURDATE(), INTERVAL %s YEAR)", secure($max_age + 1, 'int')) : "";
      $where .= sprintf(" AND p.min_age <= %1\$s AND (p.max_age >= %1\$s OR p.max_age >= 99)", secure($me['age'], 'int'));
      $where .= ($system['dating_verified_only']) ? " AND u.user_verified = '1'" : "";
      $where .= " AND EXISTS (SELECT 1 FROM dating_photos WHERE dating_photos.user_id = p.user_id AND dating_photos.status = 'approved')";
      $where .= ($interest) ? sprintf(" AND EXISTS (SELECT 1 FROM dating_profiles_interests WHERE dating_profiles_interests.user_id = p.user_id AND dating_profiles_interests.interest_id = %s)", secure($interest, 'int')) : "";
      $found = [];
      $get_profiles = $db->query("SELECT p.*, u.user_firstname, u.user_verified, u.user_last_seen FROM dating_profiles p INNER JOIN users u ON p.user_id = u.user_id WHERE p.user_id IN (" . implode(',', $ids) . ") AND " . $where);
      while ($profile = $get_profiles->fetch_assoc()) {
        /* hidden from friends */
        if (($me['hide_from_friends'] || $profile['hide_from_friends']) && isset($friends[(int) $profile['user_id']])) {
          continue;
        }
        $found[(int) $profile['user_id']] = $profile;
      }
      if (!$found) {
        return [];
      }
      /* already swiped */
      $get_swiped = $db->query(sprintf("SELECT target_id FROM dating_swipes WHERE user_id = %s AND target_id IN (%s)", secure($my_id, 'int'), implode(',', array_keys($found))));
      while ($swiped = $get_swiped->fetch_assoc()) {
        unset($found[(int) $swiped['target_id']]);
      }
      if (!$found) {
        return [];
      }
      /* their likes */
      $liked = [];
      $get_liked = $db->query(sprintf("SELECT user_id, action, message FROM dating_swipes WHERE target_id = %s AND pending = '1' AND user_id IN (%s)", secure($my_id, 'int'), implode(',', array_keys($found))));
      while ($like = $get_liked->fetch_assoc()) {
        $liked[(int) $like['user_id']] = $like;
      }
      foreach ($found as $id => $profile) {
        /* incognito profiles are seen only by the members they liked */
        if ($profile['incognito'] && !isset($liked[$id])) {
          unset($found[$id]);
          continue;
        }
        $profile['liked_me'] = isset($liked[$id]);
        $profile['super_liked_me'] = isset($liked[$id]) && $liked[$id]['action'] == 'super';
        $profile['message'] = $liked[$id]['message'] ?? '';
        $rows[$id] = $profile;
      }
      return array_keys($found);
    };
  }


  /**
   * get_dating_cards
   *
   * @param array $ids
   * @param array $rows
   * @return array
   */
  private function get_dating_cards($ids, $rows)
  {
    global $system;
    $cards = [];
    $ids = array_values(array_filter(array_map('intval', $ids), fn($id) => isset($rows[$id])));
    if (!$ids) {
      return $cards;
    }
    $me = $this->get_dating_profile();
    $photos = $this->get_dating_photos($ids);
    $interests = $this->get_dating_interests();
    $profiles_interests = $this->get_dating_profiles_interests(array_merge($ids, [$this->_data['user_id']]));
    $my_interests = $profiles_interests[$this->_data['user_id']] ?? [];
    $unit = $this->dating_distance_unit();
    $offline = time() - ((int) $system['offline_time'] * 60);
    $genders = array_column($this->get_genders(), 'gender_name', 'gender_id');
    foreach ($ids as $id) {
      $row = $rows[$id];
      if (empty($photos[$id])) {
        continue;
      }
      $card = [
        'user_id' => $id,
        'name' => $row['user_firstname'],
        'age' => ($row['hide_age']) ? null : get_user_age($row['birthdate']),
        'gender' => (int) $row['gender'],
        'gender_name' => $genders[$row['gender']] ?? '',
        'verified' => (bool) $row['user_verified'],
        'bio' => $row['bio'],
        'city' => $row['city'],
        'distance' => null,
        'photos' => array_column($photos[$id], 'url'),
        'interests' => [],
        'shared' => 0,
        'match' => 0,
        'liked_me' => !empty($row['liked_me']),
        'super_liked_me' => !empty($row['super_liked_me']),
        'message' => $row['message'] ?? '',
        'online' => strtotime($row['user_last_seen']) >= $offline,
      ];
      /* a rounded distance, never the exact one */
      if (!$row['hide_distance'] && $me['latitude'] !== null && $row['latitude'] !== null) {
        $card['distance'] = max(1, (int) ceil(location_distance($me['latitude'], $me['longitude'], $row['latitude'], $row['longitude']) / $unit));
      }
      foreach ($profiles_interests[$id] ?? [] as $interest_id) {
        if (isset($interests[$interest_id])) {
          $shared = in_array($interest_id, $my_interests);
          $card['shared'] += ($shared) ? 1 : 0;
          $card['interests'][] = ['title' => $interests[$interest_id]['title'], 'icon' => $interests[$interest_id]['icon'], 'shared' => $shared];
        }
      }
      /* shared interests first */
      usort($card['interests'], fn($a, $b) => $b['shared'] <=> $a['shared']);
      $card['match'] = $this->get_dating_match_score($me, $row, $card['shared'], count($my_interests), count($card['interests']));
      $cards[] = $card;
    }
    return $cards;
  }


  /**
   * get_dating_match_score
   * 
   * @param array $me
   * @param array $row
   * @param integer $shared
   * @param integer $my_interests
   * @param integer $their_interests
   * @return integer
   */
  private function get_dating_match_score($me, $row, $shared, $my_interests, $their_interests)
  {
    $parts = [];
    /* interests */
    if ($my_interests && $their_interests) {
      $parts[] = [40, min(1, $shared / min($my_interests, $their_interests))];
    }
    /* age, how close each one is to the middle of the other's range */
    $age_fit = function ($age, $min_age, $max_age) {
      if ($age === null) {
        return null;
      }
      if ($age < $min_age || ($max_age < 99 && $age > $max_age)) {
        return 0;
      }
      $max_age = ($max_age >= 99) ? max($min_age + 20, $age) : $max_age;
      $half = ($max_age - $min_age) / 2;
      return ($half > 0) ? 1 - (0.4 * abs($age - ($min_age + $half)) / $half) : 1;
    };
    $ages = array_filter([$age_fit(get_user_age($row['birthdate']), (int) $me['min_age'], (int) $me['max_age']), $age_fit($me['age'], (int) $row['min_age'], (int) $row['max_age'])], fn($fit) => $fit !== null);
    if ($ages) {
      $parts[] = [25, array_sum($ages) / count($ages)];
    }
    /* distance */
    if (!$row['hide_distance'] && $me['latitude'] !== null && $row['latitude'] !== null) {
      $max_km = max(1, $me['max_distance'] * $this->dating_distance_unit());
      $parts[] = [25, max(0, 1 - (location_distance($me['latitude'], $me['longitude'], $row['latitude'], $row['longitude']) / $max_km))];
    } elseif ($me['city_key'] !== '' && $me['city_key'] === $row['city_key']) {
      $parts[] = [25, 1];
    } elseif ($me['country_id'] && $row['country_id']) {
      $parts[] = [25, ($me['country_id'] == $row['country_id']) ? 0.6 : 0.2];
    }
    /* preferences, a chosen gender counts more than an open one */
    $their_genders = ($row['show_genders'] === '') ? [] : array_map('intval', explode(',', $row['show_genders']));
    $gender_fit = function ($gender, $genders) {
      if (!$genders) {
        return 0.8;
      }
      return (in_array((int) $gender, $genders)) ? 1 : 0;
    };
    $parts[] = [10, ($gender_fit($row['gender'], $me['show_genders']) + $gender_fit($me['gender'], $their_genders)) / 2];
    /* the weighted average of what is known */
    $weight = array_sum(array_column($parts, 0));
    $score = 0;
    foreach ($parts as [$part_weight, $fit]) {
      $score += $part_weight * $fit;
    }
    return (int) round(100 * $score / $weight);
  }


  /**
   * get_dating_deck
   *
   * @param array $exclude
   * @param integer $needed
   * @return array
   */
  public function get_dating_deck($exclude = [], $needed = 12)
  {
    global $db, $system;
    $me = $this->get_dating_profile();
    if (!$me || $me['status'] != 'active') {
      return ['cards' => [], 'exhausted' => true];
    }
    $my_id = (int) $this->_data['user_id'];
    $exclude = array_merge([$my_id], array_map('intval', $this->blocks_ids()), array_slice(array_map('intval', (array) $exclude), 0, 100));
    $excluded = array_fill_keys($exclude, true);
    $rows = [];
    $filter = $this->dating_filter($rows);
    $picked = [];
    /* the members who already liked me */
    $likers = [];
    $get_likers = $db->query(sprintf("SELECT user_id FROM dating_swipes WHERE target_id = %s AND pending = '1' ORDER BY swipe_id DESC LIMIT 50", secure($my_id, 'int')));
    while ($liker = $get_likers->fetch_assoc()) {
      if (!isset($excluded[(int) $liker['user_id']])) {
        $likers[] = (int) $liker['user_id'];
      }
    }
    $head = array_slice($filter($likers), 0, 4);
    /* boosted members */
    $boosted = [];
    $get_boosted = $db->query("SELECT user_id FROM dating_profiles WHERE status = 'active' AND boosted_until > NOW() ORDER BY boosted_until DESC LIMIT 50");
    while ($boost = $get_boosted->fetch_assoc()) {
      if (!isset($excluded[(int) $boost['user_id']]) && !in_array((int) $boost['user_id'], $head)) {
        $boosted[] = (int) $boost['user_id'];
      }
    }
    $boosted = $filter($boosted);
    /* boosts reach the members around */
    $max_km = $me['max_distance'] * $this->dating_distance_unit();
    $boosted = array_filter($boosted, function ($id) use ($rows, $me, $max_km, $system) {
      if ($system['dating_worldwide']) {
        return true;
      }
      if ($me['latitude'] !== null && $rows[$id]['latitude'] !== null) {
        return location_distance($me['latitude'], $me['longitude'], $rows[$id]['latitude'], $rows[$id]['longitude']) <= $max_km;
      }
      return !$me['country_id'] || !$rows[$id]['country_id'] || $me['country_id'] == $rows[$id]['country_id'];
    });
    $head = array_merge($head, array_slice($boosted, 0, 3));
    shuffle($head);
    $picked = $head;
    $exclude = array_merge($exclude, $picked);
    /* nearby members */
    if ($me['latitude'] !== null && count($picked) < $needed) {
      $nearby = nearby_ids('dating_locations', 'user_id', $me['latitude'], $me['longitude'], $max_km, $needed - count($picked), ['cap' => 500, 'exclude' => $exclude, 'filter' => $filter]);
      $nearby = array_slice(array_keys($nearby), 0, $needed - count($picked));
      $picked = array_merge($picked, $nearby);
      $exclude = array_merge($exclude, $nearby);
    }
    /* the same city, then the same country */
    $scopes = [];
    if ($me['city_key'] !== '') {
      $scopes[] = sprintf("city_key = %s", secure($me['city_key']));
    }
    if ($me['country_id']) {
      $scopes[] = sprintf("country_id = %s", secure($me['country_id'], 'int'));
    }
    if ($system['dating_worldwide'] || (!$scopes && $me['latitude'] === null)) {
      $scopes[] = "";
    }
    $genders = ($me['show_genders']) ? $me['show_genders'] : array_map('intval', array_column($this->get_genders(), 'gender_id'));
    foreach ($scopes as $scope) {
      foreach ($genders as $gender_id) {
        if (count($picked) >= $needed) {
          break 2;
        }
        $scope_sql = sprintf("status = 'active' AND gender = %s", secure($gender_id, 'int')) . (($scope) ? " AND " . $scope : "");
        $sampled = sample_ids('dating_profiles', 'user_id', $scope_sql, $needed - count($picked), ['pivots' => 3, 'pool' => 200, 'exclude' => $exclude, 'filter' => $filter]);
        $picked = array_merge($picked, $sampled);
        $exclude = array_merge($exclude, $sampled);
      }
    }
    $cards = $this->get_dating_cards($picked, $rows);
    return ['cards' => $cards, 'exhausted' => count($cards) < $needed];
  }


  /**
   * get_dating_browse
   *
   * @param array $filters
   * @param string $cursor
   * @return array
   */
  public function get_dating_browse($filters = [], $cursor = null)
  {
    global $db, $system;
    $this->_cursor = null;
    $this->_dating_more = false;
    $me = $this->get_dating_profile();
    if (!$me || $me['status'] != 'active') {
      return [];
    }
    $results = max(1, (int) $system['dating_results']);
    $min_age = max(18, (int) $system['dating_min_age']);
    /* filters */
    $options = [
      'genders' => (!empty($filters['gender']) && $this->check_gender($filters['gender'])) ? [(int) $filters['gender']] : $me['show_genders'],
      'min_age' => max($min_age, min(99, (int) ($filters['min_age'] ?? $me['min_age']))),
      'max_age' => max($min_age, min(99, (int) ($filters['max_age'] ?? $me['max_age']))),
      'interest' => (int) ($filters['interest'] ?? 0),
    ];
    $city = trim((string) ($filters['city'] ?? ''));
    $rows = [];
    $filter = $this->dating_filter($rows, $options);
    $exclude = array_merge([(int) $this->_data['user_id']], array_map('intval', $this->blocks_ids()));
    $excluded = array_fill_keys($exclude, true);
    $picked = [];
    /* by distance */
    if ($me['latitude'] !== null && $city === '' && !$system['dating_worldwide']) {
      $after = cursor_decode($cursor, ['int', 'int']);
      $distance = max(1, min((int) $system['dating_max_distance'], (int) ($filters['distance'] ?? $me['max_distance'])));
      $nearby = nearby_ids('dating_locations', 'user_id', $me['latitude'], $me['longitude'], $distance * $this->dating_distance_unit(), 500, ['cap' => 500, 'exclude' => $exclude, 'filter' => $filter]);
      foreach ($nearby as $id => $km) {
        $meters = (int) round($km * 1000);
        if ($after && ($meters < (int) $after[0] || ($meters == (int) $after[0] && $id <= (int) $after[1]))) {
          continue;
        }
        $picked[] = $id;
        $this->_cursor = cursor_encode([$meters, $id]);
        if (count($picked) == $results) {
          break;
        }
      }
      $this->_dating_more = count($picked) == $results;
      return $this->get_dating_cards($picked, $rows);
    }
    /* by city or country */
    $after = cursor_decode($cursor, ['int']);
    $last_id = ($after) ? (int) $after[0] : null;
    $scope = "";
    if ($city !== '') {
      $scope = sprintf(" AND city_key = %s", secure($me['country_id'] . ':' . mb_strtolower($city)));
    } elseif ($me['country_id'] && !$system['dating_worldwide']) {
      $scope = sprintf(" AND country_id = %s", secure($me['country_id'], 'int'));
    }
    $genders = ($options['genders']) ? $options['genders'] : array_map('intval', array_column($this->get_genders(), 'gender_id'));
    /* a fixed amount of rows is read per page */
    for ($round = 0; $round < 3 && count($picked) < $results; $round++) {
      $selects = [];
      foreach ($genders as $gender_id) {
        $selects[] = sprintf("(SELECT user_id FROM dating_profiles WHERE status = 'active' AND gender = %s", secure($gender_id, 'int')) . $scope . (($last_id) ? sprintf(" AND user_id < %s", secure($last_id, 'int')) : "") . " ORDER BY user_id DESC LIMIT 200)";
      }
      $scanned = [];
      $get_ids = $db->query(implode(" UNION ALL ", $selects) . " ORDER BY user_id DESC LIMIT 200");
      while ($row = $get_ids->fetch_assoc()) {
        $scanned[] = (int) $row['user_id'];
      }
      if (!$scanned) {
        break;
      }
      $kept = array_fill_keys($filter(array_values(array_filter($scanned, fn($id) => !isset($excluded[$id])))), true);
      $last_id = end($scanned);
      foreach ($scanned as $id) {
        if (isset($kept[$id])) {
          $picked[] = $id;
          if (count($picked) == $results) {
            $last_id = $id;
            break;
          }
        }
      }
      $this->_cursor = cursor_encode([$last_id]);
      $this->_dating_more = count($scanned) == 200 || count($picked) == $results;
      if (count($scanned) < 200) {
        break;
      }
    }
    return $this->get_dating_cards($picked, $rows);
  }


  /**
   * get_dating_likes_count
   *
   * @return integer
   */
  public function get_dating_likes_count()
  {
    global $db;
    return (int) $db->query(sprintf("SELECT COUNT(*) AS count FROM (SELECT 1 FROM dating_swipes WHERE target_id = %s AND pending = '1' LIMIT 100) likes", secure($this->_data['user_id'], 'int')))->fetch_assoc()['count'];
  }


  /**
   * get_dating_likes
   *
   * @param string $cursor
   * @return array
   */
  public function get_dating_likes($cursor = null)
  {
    global $db, $system;
    $this->_cursor = null;
    $me = $this->get_dating_profile();
    if (!$me || $me['status'] != 'active') {
      return [];
    }
    $results = max(1, (int) $system['dating_results']);
    $after = cursor_decode($cursor, ['int']);
    $cursor_statement = ($after) ? " AND " . cursor_where(['swipe_id'], $after) : "";
    /* priority messages are open to everyone */
    $perk_statement = ($this->dating_perk('likes_list')) ? "" : " AND message != ''";
    $ids = [];
    $last_id = null;
    $get_likes = $db->query(sprintf("SELECT swipe_id, user_id FROM dating_swipes WHERE target_id = %s AND pending = '1'", secure($this->_data['user_id'], 'int')) . $perk_statement . $cursor_statement . sprintf(" ORDER BY swipe_id DESC LIMIT %s", secure($results, 'int', false)));
    while ($like = $get_likes->fetch_assoc()) {
      $ids[] = (int) $like['user_id'];
      $last_id = $like['swipe_id'];
    }
    if ($ids) {
      $this->_cursor = cursor_encode([$last_id]);
    }
    $this->_dating_more = count($ids) == $results;
    $rows = [];
    $filter = $this->dating_filter($rows, ['genders' => [], 'min_age' => 18, 'max_age' => 99]);
    $blocked = array_fill_keys(array_map('intval', $this->blocks_ids()), true);
    $kept = array_fill_keys($filter(array_values(array_filter($ids, fn($id) => !isset($blocked[$id])))), true);
    return $this->get_dating_cards(array_values(array_filter($ids, fn($id) => isset($kept[$id]))), $rows);
  }


  /**
   * get_dating_matches
   *
   * @param string $cursor
   * @return array
   */
  public function get_dating_matches($cursor = null)
  {
    global $db, $system;
    $this->_cursor = null;
    $results = max(1, (int) $system['dating_results']);
    $after = cursor_decode($cursor, ['int']);
    $cursor_statement = ($after) ? sprintf(" AND match_id < %s", secure($after[0], 'int')) : "";
    $my_id = secure($this->_data['user_id'], 'int');
    $limit = secure($results, 'int', false);
    $matches = [];
    $get_matches = $db->query(
      "(SELECT match_id, user_two_id AS user_id, time FROM dating_matches WHERE user_one_id = " . $my_id . " AND status = 'active'" . $cursor_statement . " ORDER BY match_id DESC LIMIT " . $limit . ")"
        . " UNION ALL "
        . "(SELECT match_id, user_one_id AS user_id, time FROM dating_matches WHERE user_two_id = " . $my_id . " AND status = 'active'" . $cursor_statement . " ORDER BY match_id DESC LIMIT " . $limit . ")"
        . " ORDER BY match_id DESC LIMIT " . $limit
    );
    while ($match = $get_matches->fetch_assoc()) {
      $matches[(int) $match['user_id']] = $match;
    }
    if (!$matches) {
      return [];
    }
    $this->_cursor = cursor_encode([end($matches)['match_id']]);
    $this->_dating_more = count($matches) == $results;
    /* matched members are no longer anonymous */
    $photos = $this->get_dating_photos(array_keys($matches));
    $offline = time() - ((int) $system['offline_time'] * 60);
    $me = $this->get_dating_profile();
    $profiles_interests = $this->get_dating_profiles_interests(array_merge(array_keys($matches), [$this->_data['user_id']]));
    $my_interests = $profiles_interests[$this->_data['user_id']] ?? [];
    $get_users = $db->query("SELECT p.user_id, p.gender, p.birthdate, p.show_genders, p.min_age, p.max_age, p.country_id, p.city_key, p.latitude, p.longitude, p.hide_distance, p.hide_age, p.city, p.status, u.user_name, u.user_firstname, u.user_lastname, u.user_gender, u.user_picture, u.user_verified, u.user_last_seen FROM users u LEFT JOIN dating_profiles p ON p.user_id = u.user_id WHERE u.user_id IN (" . implode(',', array_keys($matches)) . ")");
    while ($row = $get_users->fetch_assoc()) {
      $id = (int) $row['user_id'];
      if (!$id || !isset($matches[$id])) {
        continue;
      }
      $matches[$id]['name'] = $row['user_firstname'];
      $matches[$id]['fullname'] = trim($row['user_firstname'] . ' ' . $row['user_lastname']);
      $matches[$id]['user_name'] = $row['user_name'];
      $matches[$id]['age'] = ($row['hide_age']) ? null : get_user_age($row['birthdate']);
      $matches[$id]['city'] = $row['city'];
      $matches[$id]['verified'] = (bool) $row['user_verified'];
      $matches[$id]['picture'] = get_picture($row['user_picture'], $row['user_gender']);
      $matches[$id]['photo'] = $photos[$id][0]['url'] ?? $matches[$id]['picture'];
      $matches[$id]['online'] = strtotime($row['user_last_seen']) >= $offline;
      $their_interests = $profiles_interests[$id] ?? [];
      $matches[$id]['match'] = ($me) ? $this->get_dating_match_score($me, $row, count(array_intersect($their_interests, $my_interests)), count($my_interests), count($their_interests)) : null;
    }
    return array_values(array_filter($matches, fn($match) => isset($match['name'])));
  }


  /* ------------------------------- */
  /* Dating Swipes */
  /* ------------------------------- */

  /**
   * dating_refresh_included
   *
   * @return void
   */
  private function dating_refresh_included()
  {
    global $db, $system;
    $period = date('Y-m');
    $profile = $this->get_dating_profile();
    if (!$profile || $profile['included_period'] == $period) {
      return;
    }
    $subscribed = $system['packages_enabled'] && $this->_data['user_subscribed'];
    $super_likes = ($subscribed) ? (int) $this->_data['dating_super_likes'] : 0;
    $boosts = ($subscribed) ? (int) $this->_data['dating_boosts'] : 0;
    $db->query(sprintf("UPDATE dating_profiles SET super_likes_included = %s, boosts_included = %s, included_period = %s WHERE user_id = %s AND included_period != %s", secure($super_likes, 'int'), secure($boosts, 'int'), secure($period), secure($this->_data['user_id'], 'int'), secure($period)));
    $this->_dating_profile = false;
  }


  /**
   * get_dating_balance
   *
   * @return array
   */
  public function get_dating_balance()
  {
    global $db, $system;
    $this->dating_refresh_included();
    $profile = $this->get_dating_profile();
    $balance = [
      'super_likes' => (int) $profile['super_likes_included'] + (int) $profile['super_likes_balance'],
      'boosts' => (int) $profile['boosts_included'],
      'boosted' => $profile['boosted'],
      'boosted_until' => $profile['boosted_until'],
      'unlimited' => $this->dating_perk('unlimited_swipes'),
      'swipes_limit' => (int) $system['dating_free_swipes'],
      'swipes_left' => null,
    ];
    if (!$balance['unlimited']) {
      $used = (int) $db->query(sprintf("SELECT COUNT(*) AS count FROM (SELECT 1 FROM dating_swipes WHERE user_id = %s AND time >= DATE_SUB(%s, INTERVAL 1 DAY) LIMIT %s) swipes", secure($this->_data['user_id'], 'int'), secure(date('Y-m-d H:i:s')), secure($balance['swipes_limit'] + 1, 'int', false)))->fetch_assoc()['count'];
      $balance['swipes_left'] = max(0, $balance['swipes_limit'] - $used);
    }
    return $balance;
  }


  /**
   * dating_wallet_charge
   *
   * @param float $price
   * @param string $item
   * @param integer $quantity
   * @return void
   */
  private function dating_wallet_charge($price, $item, $quantity = 1)
  {
    global $db, $date;
    $db->query(sprintf("UPDATE users SET user_wallet_balance = user_wallet_balance - %1\$s WHERE user_id = %2\$s AND user_wallet_balance >= %1\$s", secure($price, 'float'), secure($this->_data['user_id'], 'int')));
    if ($db->affected_rows != 1) {
      throw new ValidationException(__("There is not enough credit in your wallet. Recharge your wallet to continue.") . " " . "<strong class='text-primary cursor-pointer js_modal' data-url='#wallet-replenish'>" . __("Recharge Now") . "</strong>");
    }
    $this->_data['user_wallet_balance'] -= $price;
    $this->wallet_set_transaction($this->_data['user_id'], 'dating_' . $item, 0, $price, 'out');
    $this->log_commission($this->_data['user_id'], $price, 'dating_' . $item);
    $db->query(sprintf("INSERT INTO dating_purchases (user_id, item, quantity, amount, time) VALUES (%s, %s, %s, %s, %s)", secure($this->_data['user_id'], 'int'), secure($item), secure($quantity, 'int'), secure($price, 'float'), secure($date)));
  }


  /**
   * dating_swipe
   *
   * @param integer $target_id
   * @param string $action
   * @param string $message
   * @return array
   */
  public function dating_swipe($target_id, $action, $message = '')
  {
    global $db, $system, $date;
    $me = $this->get_dating_profile();
    $my_id = (int) $this->_data['user_id'];
    $target_id = (int) $target_id;
    if (!$this->_data['can_use_dating'] || !$me || $me['status'] != 'active') {
      throw new ValidationException(__("Your dating profile is not active"));
    }
    if (!in_array($action, ['pass', 'like', 'super']) || !$target_id || $target_id == $my_id) {
      throw new ValidationException(__("You can't do this right now"));
    }
    if (in_array($target_id, $this->blocks_ids())) {
      throw new ValidationException(__("This member is not available"));
    }
    /* only the members I can see */
    $rows = [];
    $filter = $this->dating_filter($rows, ['genders' => [], 'min_age' => 18, 'max_age' => 99]);
    if (!$filter([$target_id])) {
      throw new ValidationException(__("This member is not available"));
    }
    /* priority message */
    $message = censored_words(trim((string) $message));
    $price = 0;
    if ($message !== '') {
      $price = (float) $system['dating_priority_message_price'];
      if ($action == 'pass' || $price <= 0 || !$this->dating_paid_enabled()) {
        throw new ValidationException(__("You can't do this right now"));
      }
      if (mb_strlen($message) > 200) {
        throw new ValidationException(__("Your message must be less than 200 characters long"));
      }
    }
    $this->dating_refresh_included();
    $unlimited = $this->dating_perk('unlimited_swipes');
    $matched = false;
    for ($attempt = 0; $attempt < 2; $attempt++) {
      try {
        $db->begin_transaction();
        /* my swipes run one at a time */
        $db->query(sprintf("SELECT user_id FROM dating_profiles WHERE user_id = %s FOR UPDATE", secure($my_id, 'int')));
        if (!$unlimited) {
          $limit = (int) $system['dating_free_swipes'];
          $used = (int) $db->query(sprintf("SELECT COUNT(*) AS count FROM (SELECT 1 FROM dating_swipes WHERE user_id = %s AND time >= DATE_SUB(%s, INTERVAL 1 DAY) LIMIT %s) swipes", secure($my_id, 'int'), secure($date), secure($limit + 1, 'int', false)))->fetch_assoc()['count'];
          if ($used >= $limit) {
            throw new ValidationException(__("You have reached your daily swipes limit"), 429);
          }
        }
        $db->query(sprintf("INSERT IGNORE INTO dating_swipes (user_id, target_id, action, pending, message, time) VALUES (%s, %s, %s, %s, %s, %s)", secure($my_id, 'int'), secure($target_id, 'int'), secure($action), secure(($action == 'pass') ? '0' : '1'), secure($message), secure($date)));
        if ($db->affected_rows != 1) {
          $db->rollback();
          return ['matched' => false];
        }
        if ($action == 'super') {
          $db->query(sprintf("UPDATE dating_profiles SET super_likes_included = super_likes_included - 1 WHERE user_id = %s AND super_likes_included > 0", secure($my_id, 'int')));
          if ($db->affected_rows != 1) {
            $db->query(sprintf("UPDATE dating_profiles SET super_likes_balance = super_likes_balance - 1 WHERE user_id = %s AND super_likes_balance > 0", secure($my_id, 'int')));
            if ($db->affected_rows != 1) {
              throw new ValidationException(__("You don't have any super likes left"), 402);
            }
          }
        }
        if ($price > 0) {
          $this->dating_wallet_charge($price, 'priority_message');
        }
        /* their answer */
        $get_reverse = $db->query(sprintf("SELECT swipe_id, action FROM dating_swipes WHERE user_id = %s AND target_id = %s FOR UPDATE", secure($target_id, 'int'), secure($my_id, 'int')));
        if ($get_reverse->num_rows > 0) {
          $reverse = $get_reverse->fetch_assoc();
          $db->query(sprintf("UPDATE dating_swipes SET pending = '0' WHERE (user_id = %1\$s AND target_id = %2\$s) OR (user_id = %2\$s AND target_id = %1\$s)", secure($my_id, 'int'), secure($target_id, 'int')));
          if ($action != 'pass' && $reverse['action'] != 'pass') {
            $db->query(sprintf("INSERT INTO dating_matches (user_one_id, user_two_id, time) VALUES (%s, %s, %s) ON DUPLICATE KEY UPDATE status = 'active', unmatched_by = NULL", secure(min($my_id, $target_id), 'int'), secure(max($my_id, $target_id), 'int'), secure($date)));
            $matched = true;
          }
        }
        $db->commit();
        break;
      } catch (ValidationException $e) {
        $db->rollback();
        throw $e;
      } catch (Throwable $e) {
        $db->rollback();
        if (in_array((int) $e->getCode(), [1205, 1213], true) && $attempt < 1) {
          usleep(20000);
          continue;
        }
        throw $e;
      }
    }
    $this->_dating_profile = false;
    unset($this->_dating_matched[$target_id]);
    /* notify */
    if ($matched) {
      $this->post_notification(['to_user_id' => $target_id, 'action' => 'dating_match', 'node_url' => 'matches']);
    } elseif ($message !== '') {
      $this->post_notification(['to_user_id' => $target_id, 'action' => 'dating_priority_message', 'node_url' => 'likes']);
    }
    return ['matched' => $matched];
  }


  /**
   * dating_rewind
   *
   * @return integer
   */
  public function dating_rewind()
  {
    global $db;
    if (!$this->dating_perk('rewind')) {
      throw new ValidationException(__("Upgrade your plan to undo your last swipe"), 402);
    }
    $my_id = (int) $this->_data['user_id'];
    $get_swipe = $db->query(sprintf("SELECT * FROM dating_swipes WHERE user_id = %s ORDER BY time DESC, swipe_id DESC LIMIT 1", secure($my_id, 'int')));
    if ($get_swipe->num_rows == 0) {
      throw new ValidationException(__("There is nothing to undo"));
    }
    $swipe = $get_swipe->fetch_assoc();
    /* only a pass can be taken back */
    if ($swipe['action'] != 'pass' || strtotime($swipe['time']) < time() - 3600) {
      throw new ValidationException(__("Your last swipe can't be undone"));
    }
    $db->query(sprintf("DELETE FROM dating_swipes WHERE swipe_id = %s AND user_id = %s", secure($swipe['swipe_id'], 'int'), secure($my_id, 'int')));
    /* their like waits for an answer again */
    $db->query(sprintf("UPDATE dating_swipes SET pending = '1' WHERE user_id = %s AND target_id = %s AND action != 'pass'", secure($swipe['target_id'], 'int'), secure($my_id, 'int')));
    return (int) $swipe['target_id'];
  }


  /**
   * get_dating_card
   *
   * @param integer $user_id
   * @return array|null
   */
  public function get_dating_card($user_id)
  {
    $rows = [];
    $filter = $this->dating_filter($rows, ['genders' => [], 'min_age' => 18, 'max_age' => 99]);
    $cards = $this->get_dating_cards($filter([(int) $user_id]), $rows);
    return $cards[0] ?? null;
  }


  /**
   * dating_matched
   *
   * @param integer $user_id
   * @return boolean
   */
  public function dating_matched($user_id)
  {
    global $db, $system;
    if (!$system['dating_enabled'] || !$this->_logged_in) {
      return false;
    }
    $user_id = (int) $user_id;
    /* long-running socket servers must see new matches at once */
    if (defined('SOCKET_SERVER')) {
      unset($this->_dating_matched[$user_id]);
    }
    return $this->_dating_matched[$user_id] ??= $db->query(sprintf("SELECT 1 FROM dating_matches WHERE user_one_id = %s AND user_two_id = %s AND status = 'active'", secure(min($user_id, (int) $this->_data['user_id']), 'int'), secure(max($user_id, (int) $this->_data['user_id']), 'int')))->num_rows > 0;
  }


  /**
   * get_dating_match_user
   * 
   * @param integer $user_id
   * @return array|null
   */
  public function get_dating_match_user($user_id)
  {
    global $db;
    if (!$this->dating_matched($user_id)) {
      return null;
    }
    $get_user = $db->query(sprintf("SELECT user_id, user_name, user_firstname, user_lastname, user_gender, user_picture FROM users WHERE user_id = %s", secure($user_id, 'int')));
    if ($get_user->num_rows == 0) {
      return null;
    }
    $match = $get_user->fetch_assoc();
    $match['fullname'] = trim($match['user_firstname'] . ' ' . $match['user_lastname']);
    $match['picture'] = get_picture($match['user_picture'], $match['user_gender']);
    return $match;
  }


  /**
   * dating_unmatch
   *
   * @param integer $user_id
   * @return void
   */
  public function dating_unmatch($user_id)
  {
    global $db;
    $my_id = (int) $this->_data['user_id'];
    $user_id = (int) $user_id;
    $db->query(sprintf("UPDATE dating_matches SET status = 'unmatched', unmatched_by = %s WHERE user_one_id = %s AND user_two_id = %s", secure($my_id, 'int'), secure(min($my_id, $user_id), 'int'), secure(max($my_id, $user_id), 'int')));
    $db->query(sprintf("UPDATE dating_swipes SET pending = '0' WHERE (user_id = %1\$s AND target_id = %2\$s) OR (user_id = %2\$s AND target_id = %1\$s)", secure($my_id, 'int'), secure($user_id, 'int')));
    unset($this->_dating_matched[$user_id]);
  }


  /* ------------------------------- */
  /* Dating Purchases */
  /* ------------------------------- */

  /**
   * dating_buy_super_likes
   *
   * @return void
   */
  public function dating_buy_super_likes()
  {
    global $db, $system;
    $price = (float) $system['dating_super_likes_price'];
    $pack = (int) $system['dating_super_likes_pack'];
    if (!$this->dating_paid_enabled() || $price <= 0 || $pack <= 0 || !$this->get_dating_profile()) {
      throw new ValidationException(__("You can't do this right now"));
    }
    try {
      $db->begin_transaction();
      $this->dating_wallet_charge($price, 'super_likes', $pack);
      $db->query(sprintf("UPDATE dating_profiles SET super_likes_balance = super_likes_balance + %s WHERE user_id = %s", secure($pack, 'int'), secure($this->_data['user_id'], 'int')));
      $db->commit();
    } catch (Throwable $e) {
      $db->rollback();
      throw $e;
    }
    $this->_dating_profile = false;
  }


  /**
   * dating_boost
   *
   * @return void
   */
  public function dating_boost()
  {
    global $db, $system;
    $this->dating_refresh_included();
    $profile = $this->get_dating_profile();
    $minutes = max(1, (int) $system['dating_boost_minutes']);
    if (!$profile || $profile['status'] != 'active') {
      throw new ValidationException(__("Your dating profile is not active"));
    }
    if ($profile['boosted']) {
      throw new ValidationException(__("Your profile is already boosted"));
    }
    try {
      $db->begin_transaction();
      /* an included boost first */
      $db->query(sprintf("UPDATE dating_profiles SET boosts_included = boosts_included - 1 WHERE user_id = %s AND boosts_included > 0", secure($this->_data['user_id'], 'int')));
      if ($db->affected_rows != 1) {
        $price = (float) $system['dating_boost_price'];
        if (!$this->dating_paid_enabled() || $price <= 0) {
          throw new ValidationException(__("You don't have any boosts left"));
        }
        $this->dating_wallet_charge($price, 'boost');
      }
      $db->query(sprintf("UPDATE dating_profiles SET boosted_until = DATE_ADD(NOW(), INTERVAL %s MINUTE) WHERE user_id = %s", secure($minutes, 'int', false), secure($this->_data['user_id'], 'int')));
      $db->commit();
    } catch (Throwable $e) {
      $db->rollback();
      throw $e;
    }
    $this->_dating_profile = false;
  }


  /* ------------------------------- */
  /* Dating Admin */
  /* ------------------------------- */

  /**
   * update_dating_profile
   * 
   * @param integer $user_id
   * @param array $args
   * @return void
   */
  public function update_dating_profile($user_id, $args)
  {
    global $db, $system;
    $profile = $this->get_dating_profile($user_id);
    if (!$profile) {
      throw new Exception(__("This dating profile is not available"));
    }
    /* validate status */
    if (!in_array($args['status'] ?? '', ['active', 'paused', 'suspended'])) {
      throw new Exception(__("Please select a valid status"));
    }
    /* validate birthdate */
    $birthdate = DateTime::createFromFormat('!Y-m-d', (string) ($args['birthdate'] ?? ''));
    if (!$birthdate || $birthdate->format('Y-m-d') !== $args['birthdate']) {
      throw new Exception(__("Please select a valid birthdate"));
    }
    $birthdate = $birthdate->format('Y-m-d');
    $min_age = max(18, (int) $system['dating_min_age']);
    if (get_user_age($birthdate) < $min_age) {
      throw new Exception(__("The member must be") . " " . $min_age . " " . __("years old or older"));
    }
    /* validate gender */
    if (!isset($args['gender']) || !$this->check_gender($args['gender'])) {
      throw new Exception(__("Please select a valid gender"));
    }
    /* validate show genders */
    $show_genders = [];
    foreach ((array) ($args['show_genders'] ?? []) as $gender_id) {
      if ($this->check_gender($gender_id)) {
        $show_genders[] = (int) $gender_id;
      }
    }
    /* validate ages */
    $show_min_age = max($min_age, min(99, (int) ($args['min_age'] ?? $min_age)));
    $show_max_age = max($show_min_age, min(99, (int) ($args['max_age'] ?? 99)));
    /* validate distance */
    $max_distance = max(1, min(max(1, (int) $system['dating_max_distance']), (int) ($args['max_distance'] ?? $system['dating_max_distance'])));
    /* validate bio */
    $bio = trim((string) ($args['bio'] ?? ''));
    if (mb_strlen($bio) > 500) {
      throw new Exception(__("The bio must be less than 500 characters long"));
    }
    /* validate location */
    $country_id = (int) ($args['country'] ?? 0);
    if ($country_id && !$this->check_country($country_id)) {
      throw new Exception(__("Please select a valid country"));
    }
    $city = trim((string) ($args['city'] ?? ''));
    if (mb_strlen($city) > 100) {
      throw new Exception(__("Please enter a valid city"));
    }
    $city_key = ($city === '') ? '' : $country_id . ':' . mb_strtolower($city);
    /* validate interests */
    $interests = array_values(array_intersect(array_map('intval', (array) ($args['interests'] ?? [])), array_keys($this->get_dating_interests())));
    /* validate super likes */
    if (!isset($args['super_likes_balance']) || !is_numeric($args['super_likes_balance']) || $args['super_likes_balance'] < 0) {
      throw new Exception(__("Please enter a valid super likes balance"));
    }
    /* update */
    $db->query(sprintf(
      "UPDATE dating_profiles SET status = %s, gender = %s, birthdate = %s, show_genders = %s, min_age = %s, max_age = %s, max_distance = %s, bio = %s, country_id = %s, city = %s, city_key = %s, hide_from_friends = %s, incognito = %s, hide_age = %s, hide_distance = %s, super_likes_balance = %s WHERE user_id = %s",
      secure($args['status']),
      secure($args['gender'], 'int'),
      secure($birthdate),
      secure(implode(',', $show_genders)),
      secure($show_min_age, 'int'),
      secure($show_max_age, 'int'),
      secure($max_distance, 'int'),
      secure($bio),
      secure($country_id, 'int'),
      secure($city),
      secure($city_key),
      secure((isset($args['hide_from_friends'])) ? '1' : '0'),
      secure((isset($args['incognito'])) ? '1' : '0'),
      secure((isset($args['hide_age'])) ? '1' : '0'),
      secure((isset($args['hide_distance'])) ? '1' : '0'),
      secure($args['super_likes_balance'], 'int'),
      secure($user_id, 'int')
    ));
    /* only active profiles are searchable by distance */
    if ($args['status'] != 'active') {
      $db->query(sprintf("DELETE FROM dating_locations WHERE user_id = %s", secure($user_id, 'int')));
      $db->query(sprintf("UPDATE dating_profiles SET latitude = NULL, longitude = NULL WHERE user_id = %s", secure($user_id, 'int')));
    }
    /* update interests */
    $db->query(sprintf("DELETE FROM dating_profiles_interests WHERE user_id = %s", secure($user_id, 'int')));
    foreach ($interests as $interest_id) {
      $db->query(sprintf("INSERT INTO dating_profiles_interests (user_id, interest_id) VALUES (%s, %s)", secure($user_id, 'int'), secure($interest_id, 'int')));
    }
  }


  /**
   * get_dating_insights
   *
   * @return array
   */
  public function get_dating_insights()
  {
    global $db;
    $insights = [];
    $insights['members'] = $db->query("SELECT COUNT(*) AS count FROM dating_profiles")->fetch_assoc()['count'];
    $insights['active'] = $db->query("SELECT COUNT(*) AS count FROM dating_profiles WHERE status = 'active'")->fetch_assoc()['count'];
    $insights['suspended'] = $db->query("SELECT COUNT(*) AS count FROM dating_profiles WHERE status = 'suspended'")->fetch_assoc()['count'];
    $insights['new_members'] = $db->query("SELECT COUNT(*) AS count FROM dating_profiles WHERE time >= DATE_SUB(NOW(), INTERVAL 7 DAY)")->fetch_assoc()['count'];
    $insights['matches'] = $db->query("SELECT COUNT(*) AS count FROM dating_matches WHERE status = 'active'")->fetch_assoc()['count'];
    $insights['pending_photos'] = $db->query("SELECT COUNT(*) AS count FROM dating_photos WHERE status = 'pending'")->fetch_assoc()['count'];
    $insights['revenue'] = (float) $db->query("SELECT SUM(amount) AS total FROM dating_purchases")->fetch_assoc()['total'];
    $insights['revenue_month'] = (float) $db->query("SELECT SUM(amount) AS total FROM dating_purchases WHERE time >= DATE_SUB(NOW(), INTERVAL 30 DAY)")->fetch_assoc()['total'];
    $insights['items'] = [];
    $get_items = $db->query("SELECT item, COUNT(*) AS sales, SUM(amount) AS total FROM dating_purchases GROUP BY item");
    while ($item = $get_items->fetch_assoc()) {
      $insights['items'][$item['item']] = $item;
    }
    $insights['genders'] = [];
    $get_genders = $db->query("SELECT system_genders.gender_name, COUNT(*) AS count FROM dating_profiles INNER JOIN system_genders ON dating_profiles.gender = system_genders.gender_id GROUP BY dating_profiles.gender");
    while ($gender = $get_genders->fetch_assoc()) {
      $insights['genders'][] = $gender;
    }
    return $insights;
  }
}
