<?php

/**
 * trait -> tools
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich
 */

trait ToolsTrait
{

  /* ------------------------------- */
  /* [Tools] Fake Generator */
  /* ------------------------------- */

  /**
   * fake_users_generator
   * 
   * @param integer $users_num
   * @param string $default_password
   * @param boolean $random_avatar
   * @param string $names_language
   * 
   * @return integer
   */
  public function fake_users_generator($users_num, $default_password, $random_avatar, $names_language)
  {
    global $db, $system, $date;
    /* default password */
    $default_password = ($default_password) ? $default_password : "123456789";
    /* random Avatar */
    $random_avatar = ($random_avatar) ? true : false;
    /* init Faker */
    $faker = Faker\Factory::create($names_language);
    /* random genders */
    $genders = ['male', 'female'];
    /* fake generator */
    $generated = 0;
    while ($generated < $users_num) {
      $fake_username = strtolower(str_replace(".", "_", $faker->userName)) . "_" . get_hash_key(4);
      $fake_email = $fake_username . "@" . $_SERVER['HTTP_HOST'];
      $fake_gender = array_rand($genders);
      $fake_firstname = $faker->firstName($genders[$fake_gender]);
      $fake_lastname = $faker->lastName;
      if ($random_avatar) {
        try {
          $fake_avatar = save_picture_from_url($this->get_random_profile_picture());
        } catch (Exception $e) {
          $fake_avatar = 'null';
        }
      } else {
        $fake_avatar = 'null';
      }
      /* insert new user */
      $query = $db->query(sprintf(
        "INSERT INTO users (
          user_name, 
          user_email, 
          user_password, 
          user_firstname, 
          user_lastname, 
          user_gender, 
          user_registered, 
          user_activated, 
          user_picture, 
          user_approved,
          is_fake
        ) VALUES (%s, %s, %s, %s, %s, %s, %s, '1', %s, '1', '1')",
        secure($fake_username),
        secure($fake_email),
        secure(_password_hash($default_password)),
        secure(ucwords($fake_firstname)),
        secure(ucwords($fake_lastname)),
        secure($fake_gender + 1, 'int'),
        secure($date),
        secure($fake_avatar)
      ));
      if (!$query) continue;
      $generated++;
    }
    return $generated;
  }


  /**
   * fake_pages_generator
   * 
   * @param integer $pages_num
   * @param boolean $random_avatar
   * @param string $names_language
   * @param integer $category
   * @param integer $country
   * @param integer $language
   * 
   * @return integer
   */
  public function fake_pages_generator($pages_num, $random_avatar, $names_language, $category, $country, $language)
  {
    global $db, $system, $date;
    /* random Avatar */
    $random_avatar = ($random_avatar) ? true : false;
    /* init Faker */
    $faker = Faker\Factory::create($names_language);
    /* fake generator */
    $generated = 0;
    while ($generated < $pages_num) {
      $fake_username = strtolower(str_replace(".", "_", $faker->userName)) . "_" . get_hash_key(4);
      $fake_title = $faker->firstName("male");
      if ($random_avatar) {
        try {
          $fake_avatar = save_picture_from_url($this->get_random_profile_picture());
        } catch (Exception $e) {
          $fake_avatar = 'null';
        }
      } else {
        $fake_avatar = 'null';
      }
      /* insert new page */
      $query = $db->query(sprintf(
        "INSERT INTO pages (
          page_admin, 
          page_category, 
          page_name, 
          page_title, 
          page_description, 
          page_picture, 
          page_country, 
          page_language, 
          page_date, 
          is_fake
        ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, '1')",
        secure($this->_data['user_id'], 'int'),
        secure($category, 'int'),
        secure($fake_username),
        secure($fake_title),
        secure($fake_title),
        secure($fake_avatar),
        secure($country),
        secure($language),
        secure($date)
      ));
      if (!$query) continue;
      $generated++;
      /* get page_id */
      $page_id = $db->insert_id;
      /* like the page */
      $this->connect("page-like", $page_id);
      /* page admin addation */
      $this->connect("page-admin-addation", $page_id, $this->_data['user_id']);
    }
    return $generated;
  }


  /**
   * fake_groups_generator
   * 
   * @param integer $groups_num
   * @param boolean $random_avatar
   * @param string $names_language
   * @param integer $category
   * @param integer $country
   * @param integer $language
   * 
   * @return integer
   */
  public function fake_groups_generator($groups_num, $random_avatar, $names_language, $category, $country, $language)
  {
    global $db, $system, $date;
    /* random Avatar */
    $random_avatar = ($random_avatar) ? true : false;
    /* init Faker */
    $faker = Faker\Factory::create($names_language);
    /* fake generator */
    $generated = 0;
    while ($generated < $groups_num) {
      $fake_username = strtolower(str_replace(".", "_", $faker->userName)) . "_" . get_hash_key(4);
      $fake_title = $faker->firstName("male");
      if ($random_avatar) {
        try {
          $fake_avatar = save_picture_from_url($this->get_random_profile_picture());
        } catch (Exception $e) {
          $fake_avatar = 'null';
        }
      } else {
        $fake_avatar = 'null';
      }
      /* insert new group */
      $query = $db->query(sprintf(
        "INSERT INTO `groups` (
          group_privacy, 
          group_admin, 
          group_name, 
          group_category, 
          group_title, 
          group_description, 
          group_picture, 
          group_country, 
          group_language, 
          group_date, 
          is_fake
        ) VALUES ('public', %s, %s, %s, %s, %s, %s, %s, %s, %s, '1')",
        secure($this->_data['user_id'], 'int'),
        secure($fake_username),
        secure($category),
        secure($fake_title),
        secure($fake_title),
        secure($fake_avatar),
        secure($country),
        secure($language),
        secure($date)
      ));
      if (!$query) continue;
      $generated++;
      /* get group_id */
      $group_id = $db->insert_id;
      /* join the group */
      $this->connect("group-join", $group_id);
      /* group admin addation */
      $this->connect("group-admin-addation", $group_id, $this->_data['user_id']);
    }
    return $generated;
  }


  /**
   * get_random_profile_picture
   * 
   * @return string
   */
  public function get_random_profile_picture()
  {
    $services = [
      /* Random User API */
      function () {
        $response = file_get_contents('https://randomuser.me/api/?inc=picture&noinfo');
        if ($response) {
          $data = json_decode($response, true);
          if (isset($data['results'][0]['picture']['large'])) {
            return $data['results'][0]['picture']['large'];
          }
        }
        return null;
      },
      /* UI Faces API */
      function () {
        $response = file_get_contents('https://api.uifaces.co/our-content/donated/XdLjsJX_.jpg');
        if ($response && !empty($response)) {
          return 'https://api.uifaces.co/our-content/donated/XdLjsJX_.jpg';
        }
        return null;
      },
      /* Picsum Photos */
      function () {
        return 'https://picsum.photos/400/400?random=' . time();
      }
    ];
    foreach ($services as $service) {
      try {
        $url = $service();
        if ($url) {
          return $url;
        }
      } catch (Exception $e) {
        continue;
      }
    }
    /* fallback to a default image */
    return 'https://via.placeholder.com/400x400/cccccc/666666?text=Profile';
  }



  /* ------------------------------- */
  /* [Tools] Auto Connect */
  /* ------------------------------- */

  /**
   * auto_friend
   * 
   * @param integer $user_id
   * @param integer $country_id
   * @return void
   */
  public function auto_friend($user_id, $country_id = null)
  {
    global $db, $system;
    if (!$system['auto_friend'] || !isset($user_id)) {
      return;
    }
    /* check if [system || custom] auto-friend */
    if ($country_id == null) {
      /* system auto-friend */
      if (is_empty($system['auto_friend_users'])) {
        return;
      }
      $auto_friend_users = $system['auto_friend_users'];
    } else {
      /* custom auto-friend */
      $get_auto_friend_users = $db->query(sprintf("SELECT nodes_ids FROM auto_connect WHERE type = 'friend' AND country_id = %s", secure($country_id, 'int')));
      if ($get_auto_friend_users->num_rows == 0) {
        return;
      }
      $auto_friend_users = $get_auto_friend_users->fetch_assoc()['nodes_ids'];
    }
    /* make a list from target friends */
    $auto_friend_users_array = json_decode(html_entity_decode($auto_friend_users), true);
    if (count($auto_friend_users_array) == 0) {
      return;
    }
    foreach ($auto_friend_users_array as $_user) {
      if (is_numeric($_user['id'])) {
        $auto_friend_users_ids[] = $_user['id'];
      }
    }
    if (count($auto_friend_users_ids) == 0) {
      return;
    }
    $auto_friend_users = $this->spread_ids($auto_friend_users_ids);
    /* get the user_id of each new friend */
    $get_auto_friends = $db->query("SELECT user_id FROM users WHERE user_id IN ($auto_friend_users)");
    if ($get_auto_friends->num_rows > 0) {
      while ($auto_friend = $get_auto_friends->fetch_assoc()) {
        /* check if the user is already friends with the target */
        $check_friendship = $db->query(sprintf("SELECT * FROM friends WHERE (user_one_id = %s AND user_two_id = %s) OR (user_one_id = %s AND user_two_id = %s)", secure($user_id, 'int'), secure($auto_friend['user_id'], 'int'), secure($auto_friend['user_id'], 'int'), secure($user_id, 'int')));
        if ($check_friendship->num_rows > 0) continue;
        /* add friend */
        $db->query(sprintf("INSERT INTO friends (user_one_id, user_two_id, status) VALUES (%s, %s, '1')", secure($user_id, 'int'),  secure($auto_friend['user_id'], 'int')));
        /* check if the user is already following the target */
        $check_following = $db->query(sprintf("SELECT * FROM followings WHERE user_id = %s AND following_id = %s", secure($user_id, 'int'), secure($auto_friend['user_id'], 'int')));
        if ($check_following->num_rows > 0) continue;
        /* follow */
        $db->query(sprintf("INSERT INTO followings (user_id, following_id) VALUES (%s, %s)", secure($user_id, 'int'),  secure($auto_friend['user_id'], 'int')));
      }
    }
  }


  /**
   * auto_follow
   * 
   * @param integer $user_id
   * @param integer $country_id
   * @return void
   */
  public function auto_follow($user_id, $country_id = null)
  {
    global $db, $system;
    if (!$system['auto_follow'] || !isset($user_id)) {
      return;
    }
    /* check if [system || custom] auto-follow */
    if ($country_id == null) {
      /* system auto-follow */
      if (is_empty($system['auto_follow_users'])) {
        return;
      }
      $auto_follow_users = $system['auto_follow_users'];
    } else {
      /* custom auto-follow */
      $get_auto_follow_users = $db->query(sprintf("SELECT nodes_ids FROM auto_connect WHERE type = 'follow' AND country_id = %s", secure($country_id, 'int')));
      if ($get_auto_follow_users->num_rows == 0) {
        return;
      }
      $auto_follow_users = $get_auto_follow_users->fetch_assoc()['nodes_ids'];
    }
    /* make a list from target followings */
    $auto_follow_users_array = json_decode(html_entity_decode($auto_follow_users), true);
    if (count($auto_follow_users_array) == 0) {
      return;
    }
    foreach ($auto_follow_users_array as $_user) {
      if (is_numeric($_user['id'])) {
        $auto_follow_users_ids[] = $_user['id'];
      }
    }
    if (count($auto_follow_users_ids) == 0) {
      return;
    }
    $auto_follow_users = $this->spread_ids($auto_follow_users_ids);
    /* get the user_id of each new following */
    $get_auto_followings = $db->query("SELECT user_id FROM users WHERE user_id IN ($auto_follow_users)");
    if ($get_auto_followings->num_rows > 0) {
      while ($auto_following = $get_auto_followings->fetch_assoc()) {
        /* check if the user is already following the target */
        $check_following = $db->query(sprintf("SELECT * FROM followings WHERE user_id = %s AND following_id = %s", secure($user_id, 'int'), secure($auto_following['user_id'], 'int')));
        if ($check_following->num_rows > 0) continue;
        $db->query(sprintf("INSERT INTO followings (user_id, following_id) VALUES (%s, %s)", secure($user_id, 'int'),  secure($auto_following['user_id'], 'int')));
      }
    }
  }


  /**
   * auto_like
   * 
   * @param integer $user_id
   * @param integer $country_id
   * @return void
   */
  public function auto_like($user_id, $country_id = null)
  {
    global $db, $system;
    if (!$system['auto_like'] || !isset($user_id)) {
      return;
    }
    /* check if [system || custom] auto-like */
    if ($country_id == null) {
      /* system auto-like */
      if (is_empty($system['auto_like_pages'])) {
        return;
      }
      $auto_like_pages = $system['auto_like_pages'];
    } else {
      /* custom auto-like */
      $get_auto_like_pages = $db->query(sprintf("SELECT nodes_ids FROM auto_connect WHERE type = 'like' AND country_id = %s", secure($country_id, 'int')));
      if ($get_auto_like_pages->num_rows == 0) {
        return;
      }
      $auto_like_pages = $get_auto_like_pages->fetch_assoc()['nodes_ids'];
    }
    /* make a list from target pages */
    $auto_like_pages_array = json_decode(html_entity_decode($auto_like_pages), true);
    if (count($auto_like_pages_array) == 0) {
      return;
    }
    foreach ($auto_like_pages_array as $_page) {
      if (is_numeric($_page['id'])) {
        $auto_like_pages_ids[] = $_page['id'];
      }
    }
    if (count($auto_like_pages_ids) == 0) {
      return;
    }
    $auto_like_pages = $this->spread_ids($auto_like_pages_ids);
    /* get the page_id of each new like */
    $get_auto_like = $db->query("SELECT page_id FROM pages WHERE page_id IN ($auto_like_pages)");
    if ($get_auto_like->num_rows > 0) {
      while ($auto_like = $get_auto_like->fetch_assoc()) {
        /* check if the user is already liked the target */
        $check_like = $db->query(sprintf("SELECT * FROM pages_likes WHERE user_id = %s AND page_id = %s", secure($user_id, 'int'), secure($auto_like['page_id'], 'int')));
        if ($check_like->num_rows > 0) continue;
        /* like */
        $db->query(sprintf("INSERT INTO pages_likes (user_id, page_id) VALUES (%s, %s)", secure($user_id, 'int'),  secure($auto_like['page_id'], 'int')));
        /* update likes counter +1 */
        $db->query(sprintf("UPDATE pages SET page_likes = page_likes + 1  WHERE page_id = %s", secure($auto_like['page_id'], 'int')));
      }
    }
  }


  /**
   * auto_join
   * 
   * @param integer $user_id
   * @param integer $country_id
   * @return void
   */
  public function auto_join($user_id, $country_id = null)
  {
    global $db, $system;
    if (!$system['auto_join'] || !isset($user_id)) {
      return;
    }
    /* check if [system || custom] auto-join */
    if ($country_id == null) {
      /* system auto-join */
      if (is_empty($system['auto_join_groups'])) {
        return;
      }
      $auto_join_groups = $system['auto_join_groups'];
    } else {
      /* custom auto-join */
      $get_auto_join_groups = $db->query(sprintf("SELECT nodes_ids FROM auto_connect WHERE type = 'join' AND country_id = %s", secure($country_id, 'int')));
      if ($get_auto_join_groups->num_rows == 0) {
        return;
      }
      $auto_join_groups = $get_auto_join_groups->fetch_assoc()['nodes_ids'];
    }
    /* make a list from target groups */
    $auto_join_groups_array = json_decode(html_entity_decode($auto_join_groups), true);
    if (count($auto_join_groups_array) == 0) {
      return;
    }
    foreach ($auto_join_groups_array as $_group) {
      if (is_numeric($_group['id'])) {
        $auto_join_groups_ids[] = $_group['id'];
      }
    }
    if (count($auto_join_groups_ids) == 0) {
      return;
    }
    $auto_join_groups = $this->spread_ids($auto_join_groups_ids);
    /* get the group_id of each new join */
    $get_auto_join = $db->query("SELECT group_id FROM `groups` WHERE group_id IN ($auto_join_groups)");
    if ($get_auto_join->num_rows > 0) {
      while ($auto_join = $get_auto_join->fetch_assoc()) {
        /* check if the user is already joined the target */
        $check_join = $db->query(sprintf("SELECT * FROM groups_members WHERE user_id = %s AND group_id = %s", secure($user_id, 'int'), secure($auto_join['group_id'], 'int')));
        if ($check_join->num_rows > 0) continue;
        /* join */
        $db->query(sprintf("INSERT INTO groups_members (user_id, group_id, approved) VALUES (%s, %s, '1')", secure($user_id, 'int'),  secure($auto_join['group_id'], 'int')));
        /* update members counter +1 */
        $db->query(sprintf("UPDATE `groups` SET group_members = group_members + 1  WHERE group_id = %s", secure($auto_join['group_id'], 'int')));
      }
    }
  }


  /**
   * add_custom_auto_connect
   * 
   * @param string $handle
   * @param array $args
   * @return void
   */
  public function add_custom_auto_connect($handle, $args)
  {
    global $db;
    /* validate handle */
    if (!in_array($handle, ['friend', 'follow', 'like', 'join'])) {
      return;
    }
    $countries = array_filter(
      $args,
      function ($key) {
        global $handle;
        return strpos($key, 'auto_' . $handle . '_country_') == 0;
      },
      ARRAY_FILTER_USE_KEY
    );
    if ($countries) {
      foreach ($countries as $field_name => $country_id) {
        /* get guid */
        $guid = substr($field_name, strlen('auto_' . $handle . '_country_'));
        /* check nodes_ids */
        $nodes_ids = $args['auto_' . $handle . '_nodes_ids_' . $guid];
        if (is_empty($nodes_ids)) {
          continue;
        }
        /* remove values without id */
        $nodes_ids = json_encode(array_filter(json_decode($nodes_ids, true), function ($value) {
          return isset($value['id']);
        }));
        if (is_empty($nodes_ids)) {
          continue;
        }
        /* check country */
        $check = $db->query(sprintf("SELECT COUNT(*) as count FROM system_countries WHERE country_id = %s", secure($country_id, 'int')));
        if ($check->fetch_assoc()['count'] == 0) {
          continue;
        }
        $db->query(sprintf("INSERT INTO auto_connect (type, country_id, nodes_ids) VALUES (%s, %s, %s)", secure($handle), secure($country_id, 'int'), secure($nodes_ids)));
      }
    }
  }



  /* ------------------------------- */
  /* [Tools] Backups */
  /* ------------------------------- */

  /**
   * backup_database
   * 
   * @param string $backup_folder_name
   * @return void
   */
  public function backup_database($backup_folder_name = '')
  {
    global $db, $date;
    $get_tables = $db->query('SHOW TABLES');
    while ($table = $get_tables->fetch_row()) {
      $tables[] = $table[0];
    }
    $content = "SET SQL_MODE = \"NO_AUTO_VALUE_ON_ZERO\";\nSET time_zone = \"+00:00\";\r\n/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;\r\n/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;\r\n/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;\r\n/*!40101 SET NAMES utf8mb4 */;\n\n";
    foreach ($tables as $table) {
      $result = $db->query("SELECT * FROM `$table`");
      $fields_count = $result->field_count;
      $rows_count = $db->affected_rows;
      $get_create_tbl = $db->query("SHOW CREATE TABLE `$table`");
      $TableMLine = $get_create_tbl->fetch_row();
      $content = (!isset($content) ?  '' : $content) . "\n\n" . $TableMLine[1] . ";\n\n";
      for ($i = 0, $st_counter = 0; $i < $fields_count; $i++, $st_counter = 0) {
        while ($row = $result->fetch_row()) {
          if ($st_counter % 100 == 0 || $st_counter == 0) {
            $content .= "\nINSERT INTO " . $table . " VALUES";
          }
          $content .= "\n(";
          for ($j = 0; $j < $fields_count; $j++) {
            if (isset($row[$j])) {
              $row[$j] = str_replace("\n", "\\n", addslashes($row[$j]));
              $content .= '"' . $row[$j] . '"';
            } else {
              $content .= ($row[$j] == null) ? 'null' : '""';
            }
            if ($j < ($fields_count - 1)) {
              $content .= ',';
            }
          }
          $content .= ")";
          if ((($st_counter + 1) % 100 == 0 && $st_counter != 0) || $st_counter + 1 == $rows_count) {
            $content .= ";";
          } else {
            $content .= ",";
          }
          $st_counter = $st_counter + 1;
        }
      }
      $content .= "\n\n\n";
    }
    $content .= "\r\n\r\n/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;\r\n/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;\r\n/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;";
    /* create backup folder */
    if (!$backup_folder_name) {
      $backup_folder_name = 'content/backups/' . date('d-m-Y') . '/' . time();
      if (!file_exists(ABSPATH . $backup_folder_name)) {
        @mkdir(ABSPATH . $backup_folder_name, 0777, true);
      }
      /* update last backup time */
      update_system_options(['last_backup_time' => secure($date)]);
    }
    /* set backup */
    $sql_backup_name = 'Database-Backup' . '_' . date('d-m-Y') . '.sql';
    $write_file = @file_put_contents(ABSPATH . $backup_folder_name . '/' . $sql_backup_name, $content);
    if (!$write_file) {
      throw new Exception(__("Backup failed!, Make sure the backup folder is writable (chmod 777)"));
    }
  }


  /**
   * backup_files
   * 
   * @param string $backup_folder_name
   * @return void
   */
  public function backup_files($backup_folder_name = '')
  {
    global $db, $date;
    /* create backup folder */
    if (!$backup_folder_name) {
      $backup_folder_name = 'content/backups/' . date('d-m-Y') . '/' . time();
      if (!file_exists(ABSPATH . $backup_folder_name)) {
        @mkdir(ABSPATH . $backup_folder_name, 0777, true);
      }
      /* update last backup time */
      update_system_options(['last_backup_time' => secure($date)]);
    }
    /* set backup */
    $files_backup_name = 'Files-Backup' . '_' . date('d-m-Y') . '.zip';
    $zip = new ZipArchive();
    $read_file = $zip->open(ABSPATH . $backup_folder_name . '/' . $files_backup_name, ZipArchive::CREATE | ZipArchive::OVERWRITE);
    if ($read_file !== true) {
      throw new Exception(__("Backup failed!, Make sure the backup folder is writable (chmod 777)"));
    }
    $files = new RecursiveIteratorIterator(new RecursiveDirectoryIterator(ABSPATH), RecursiveIteratorIterator::LEAVES_ONLY);
    foreach ($files as $name => $file) {
      if (strpos($file, 'content/backups') === false && strpos($file, 'content\backups') === false) {
        if (!$file->isDir()) {
          $file_path = $file->getRealPath();
          $relative_path = substr($file_path, strlen(ABSPATH));
          $zip->addFile($file_path, $relative_path);
        }
      }
    }
    $zip->close();
  }


  /**
   * backup_full
   * 
   * @return void
   */
  public function backup_full()
  {
    global $db, $date;
    /* backup database */
    $this->backup_database();
    /* backup files */
    $this->backup_files();
  }
}
