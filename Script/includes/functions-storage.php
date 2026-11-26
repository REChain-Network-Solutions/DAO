<?php

/**
 * functions -> storage
 * 
 * @package Sngine
 * @author Zamblek
 */

/* ------------------------------- */
/* Upload */
/* ------------------------------- */

/**
 * get_upload_size_options
 *
 * @return array
 */
function get_upload_size_options()
{
  $options = [];
  foreach ([1, 2, 5, 10, 20, 50, 100, 200, 500] as $mb) {
    $options[$mb * 1024] = $mb . ' MB';
  }
  foreach ([1, 2, 5, 10, 25] as $gb) {
    $options[$gb * 1048576] = $gb . ' GB';
  }
  return $options;
}


/**
 * get_upload_size_option
 *
 * @param mixed $value
 * @param boolean $allow_unlimited
 * @return integer
 */
function get_upload_size_option($value, $allow_unlimited = false)
{
  $value = (is_numeric($value)) ? (int) $value : -1;
  if ($allow_unlimited && $value == 0) {
    return 0;
  }
  if ($value <= 0) {
    return ($allow_unlimited) ? 0 : 102400;
  }
  $options = array_keys(get_upload_size_options());
  foreach ($options as $option) {
    if ($option >= $value) {
      return $option;
    }
  }
  return end($options);
}


/**
 * upload_file
 * 
 * @param boolean $from_web
 * @return string|array
 */
function upload_file($from_web = false)
{
  global $system, $db, $user, $date;
  // set execution time (unlimited)
  set_time_limit(0);

  // valid inputs
  /* check if there is upload error */
  if (!isset($_FILES["file"]) || $_FILES["file"]["error"] != UPLOAD_ERR_OK) {
    throw new Exception(__("Something wrong with upload! Is 'upload_max_filesize' set correctly?"));
  }
  /* check file name not empty */
  if (!isset($_POST['name'])) {
    throw new ValidationException(__("Invalid file name"));
  }
  $file_name = $_POST['name'];
  /* check if guid not empty */
  if (!isset($_POST['guid'])) {
    throw new ValidationException(__("Invalid file guid"));
  }
  $file_guid = $_POST['guid'];

  // get chunked upload data
  $chunkIndex = isset($_POST['chunkIndex']) ? (int)$_POST['chunkIndex'] : 0;
  $totalChunks = isset($_POST['totalChunks']) ? (int)$_POST['totalChunks'] : 1;

  // check secret
  if ($from_web && $_SESSION['secret'] != $_POST['secret']) {
    /* check server post_max_size */
    if (isset($_SERVER['CONTENT_LENGTH'])) {
      $post_max_size = ini_get('post_max_size');
      $post_max_size = trim($post_max_size);
      $last = strtolower($post_max_size[strlen($post_max_size) - 1]);
      switch ($last) {
        case 'g':
          $post_max_size *= 1024;
        case 'm':
          $post_max_size *= 1024;
        case 'k':
          $post_max_size *= 1024;
      }
      if ($_SERVER['CONTENT_LENGTH'] > $post_max_size) {
        throw new ValidationException(__("The file size is so big") . ", " . __("The 'post_max_size' size is:") . " " . ($post_max_size / 1024 / 1024) . __("MB"));
      }
    }
    /* check server upload_max_filesize */
    if (isset($_SERVER['CONTENT_LENGTH'])) {
      $upload_max_filesize = ini_get('upload_max_filesize');
      $upload_max_filesize = trim($upload_max_filesize);
      $last = strtolower($upload_max_filesize[strlen($upload_max_filesize) - 1]);
      switch ($last) {
        case 'g':
          $upload_max_filesize *= 1024;
        case 'm':
          $upload_max_filesize *= 1024;
        case 'k':
          $upload_max_filesize *= 1024;
      }
      if ($_SERVER['CONTENT_LENGTH'] > $upload_max_filesize) {
        throw new ValidationException(__("The file size is so big") . ", " . __("The 'upload_max_filesize' size is:") . " " . ($upload_max_filesize / 1024 / 1024) . __("MB"));
      }
    }
    /* check server memory_limit */
    if (isset($_SERVER['CONTENT_LENGTH'])) {
      $memory_limit = ini_get('memory_limit');
      $memory_limit = trim($memory_limit);
      $last = strtolower($memory_limit[strlen($memory_limit) - 1]);
      switch ($last) {
        case 'g':
          $memory_limit *= 1024;
        case 'm':
          $memory_limit *= 1024;
        case 'k':
          $memory_limit *= 1024;
      }
      if ($_SERVER['CONTENT_LENGTH'] > $memory_limit) {
        throw new ValidationException(__("The file size is so big") . ", " . __("The 'memory_limit is:") . " " . ($memory_limit / 1024 / 1024) . __("MB"));
      }
    }
    /* none of the above */
    throw new BadRequestException(__("Invalid secret"));
  }

  // check if user exceeds the max upload limit per day
  if (!($user->_is_admin || $user->_is_moderator) && $system['max_daily_upload_size'] && $system['max_daily_upload_size'] != "0") {
    $max_daily_upload_size = $system['max_daily_upload_size'] * 1024;
    /* get the user total upload size from users_uploads */
    $get_total_upload_size = $db->query(sprintf("SELECT SUM(file_size) AS total_upload_size FROM users_uploads WHERE user_id = %s AND DATE(insert_date) = CURDATE();", secure($user->_data['user_id'])));
    $user_upload_size = $get_total_upload_size->fetch_assoc()['total_upload_size'];
    if ($user_upload_size >= $max_daily_upload_size) {
      throw new ValidationException(__("You have reached the maximum upload limit which is") . " " . round($system['max_daily_upload_size'] / 1024, 2) . "MB" . ", " . __("And you uploaded") . " " . round($user_upload_size / 1024 / 1024, 2) . "MB");
    }
  }

  // check type & handle & multiple
  if (!isset($_POST["type"])) {
    throw new BadRequestException(__("Invalid type"));
  }
  if (!isset($_POST["handle"])) {
    throw new BadRequestException(__("Invalid handle"));
  }
  if (!isset($_POST["multiple"])) {
    throw new BadRequestException(__("Invalid multiple"));
  }

  // prepare temporary directory for chunked uploads
  $temp_directory = ABSPATH . $system['uploads_directory'] . '/temp/';
  if (!file_exists($temp_directory)) {
    @mkdir($temp_directory, 0777, true);
  }

  // check if multiple files are uploaded
  if ($_POST["multiple"] == "true") {
    $finished_files = isset($_POST['finished_files']) ? json_decode($_POST['finished_files'], true) : [];
  }

  switch ($_POST["type"]) {
    case 'photos':
      // check photos upload permission
      if (!$user->_is_admin && $_POST['handle'] == 'publisher' && !$system['photos_enabled']) {
        throw new AuthorizationException(__("Uploading photos feature has been disabled by the admin"));
      }
      if (!$user->_is_admin && $_POST['handle'] == 'comment' && !$system['comments_photos_enabled']) {
        throw new AuthorizationException(__("Uploading photos feature has been disabled by the admin"));
      }
      if (!$user->_is_admin && $_POST['handle'] == 'chat' && !$system['chat_photos_enabled']) {
        throw new AuthorizationException(__("Uploading photos feature has been disabled by the admin"));
      }
      if (!$user->_is_admin && $_POST['handle'] == 'tinymce' && !$system['tinymce_photos_enabled']) {
        throw new AuthorizationException(__("Uploading photos feature has been disabled by the admin"));
      }

      // get allowed file size
      if ($_POST['handle'] == 'picture-user' || $_POST['handle'] == 'picture-page' || $_POST['handle'] == 'picture-group') {
        $max_allowed_size = $system['max_avatar_size'] * 1024;
      } elseif ($_POST['handle'] == 'cover-user' || $_POST['handle'] == 'cover-page' || $_POST['handle'] == 'cover-group') {
        $max_allowed_size = $system['max_cover_size'] * 1024;
      } else {
        $max_allowed_size = $system['max_photo_size'] * 1024;
      }

      // prepare uploads directory
      $folder = 'photos';
      $directory = $folder . '/' . date('Y') . '/' . date('m') . '/';
      if (!file_exists(ABSPATH . $system['uploads_directory'] . '/' . $directory)) {
        @mkdir(ABSPATH . $system['uploads_directory'] . '/' . $directory, 0777, true);
      }

      // check file extesnion
      $photo_extensions = 'jpg, jpeg, png, gif, webp, heic, heif';
      $extension = get_extension($file_name);
      if (!valid_extension($extension, $photo_extensions)) {
        throw new BadRequestException(__("The file type is not valid or not supported"));
      }

      // save each chunk to a temporary file
      $temp_file = $temp_directory . $file_guid . '_' . $file_name .  ".part-" . $chunkIndex;
      if (!@move_uploaded_file($_FILES['file']['tmp_name'], $temp_file)) {
        throw new Exception(__("Sorry, could not upload the file chunk"));
      }

      // if this is the last chunk, reassemble the file
      if ($chunkIndex + 1 === $totalChunks) {

        // prepare final file name & path
        $prefix = $system['uploads_prefix'] . '_' . get_hash_token();
        $final_file_name = $directory . $prefix . '.' . $extension;
        $final_file_path = ABSPATH . $system['uploads_directory'] . '/' . $final_file_name;

        // reassemble the chunks into the final file
        reassemble_file_chunks($temp_directory, $file_guid, $file_name, $totalChunks, $final_file_path);

        // check file size
        $final_file_size = filesize($final_file_path);
        if (!$user->_is_admin && !$user->_is_moderator) {
          if ($final_file_size > $max_allowed_size) {
            throw new ValidationException(__("The file size is so big") . ", " . __("The allowed file size is:") . " " . ($max_allowed_size / 1024 / 1024) . __("MB"));
          }
        }

        // init image
        require_once(ABSPATH . 'includes/class-image.php');
        $image = new Image($final_file_path);

        // save converted heic/heif images as jpg
        if (in_array(strtolower($extension), ['heic', 'heif'])) {
          unlink($final_file_path);
          $final_file_name = $directory . $prefix . $image->_img_ext;
          $final_file_path = ABSPATH . $system['uploads_directory'] . '/' . $final_file_name;
          $image->save($final_file_path, 'high');
        }

        // check if animated webp allowed
        if (!$system['allow_animated_images']) {
          if ($image->_img_type == "image/gif" || ($image->isWebpAnimated($final_file_path) && in_array($_POST['handle'], ['cover-user', 'picture-user', 'cover-page', 'picture-page', 'cover-group', 'picture-group', 'cover-event']))) {
            throw new ValidationException(__("Sorry, You can't upload animated webp images"));
          }
        }

        // check image resolution
        if (in_array($_POST['handle'], ['picture-user', 'picture-page', 'picture-group'])) {
          if ($image->getWidth() < 150 || $image->getHeight() < 150) {
            unlink($final_file_path);
            throw new ValidationException(__("Please choose an image that's at least 150 pixels wide and at least 150 pixels tall"));
          }
        } elseif (in_array($_POST['handle'], ['cover-user', 'cover-page', 'cover-group'])) {
          if ($system['limit_cover_photo']) {
            if ($image->getWidth() < 1296 || $image->getHeight() < 360) {
              unlink($final_file_path);
              throw new ValidationException(__("Please choose an image that's at least 1296 pixels wide and at least 360 pixels tall"));
            }
          }
        }

        // adult images detection
        $image_blured = 0;
        if ($system['adult_images_enabled']) {
          if ($_POST['handle'] != "x-image" && google_vision_check($final_file_path)) {
            if ($system['adult_images_action'] == "delete" || $_POST['handle'] == "dating") {
              throw new ValidationException(__("Sorry, can not upload the file for adult content"));
            } else {
              $image_blured = 1;
            }
          }
        }

        // blur images (exclude gif & webp)
        $image_source_blured = 0;
        if (isset($_POST['blur']) && $_POST['blur'] == "true") {
          if (!in_array($image->_img_type, ["image/gif", "image/webp"])) {
            /* watermark & blur */
            watermark_image($final_file_path, $image->_img_type);
            blur_image($final_file_path, $image->_img_type);
            $image_source_blured = 1;
          }
        }

        // watermark images (exclude gif & webp)
        $image_watermarked = false;
        if ($system['watermark_enabled']) {
          if (!in_array($image->_img_type, ["image/gif", "image/webp"]) && in_array($_POST['handle'], ['publisher', 'publisher-mini'])) {
            watermark_image($final_file_path, $image->_img_type);
            $image_watermarked = true;
          }
        }

        // save the new image (exclude gif & webp)
        if (!in_array($image->_img_type, ["image/gif", "image/webp"])) {
          if ($image_source_blured || $image_watermarked) {
            $image = new Image($final_file_path);
          }
          $image->save($final_file_path, $system['uploads_quality']);
        } else {
          sanitize_image_trailing_bytes($final_file_path, $image->_img_type);
        }

        // upload to
        if ($system['s3_enabled']) {
          /* Amazon S3 */
          aws_s3_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['google_cloud_enabled']) {
          /* Google Cloud */
          google_cloud_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['digitalocean_enabled']) {
          /* DigitalOcean */
          digitalocean_space_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['wasabi_enabled']) {
          /* Wasabi */
          wasabi_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['backblaze_enabled']) {
          /* Backblaze */
          backblaze_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['yandex_cloud_enabled']) {
          /* Yandex Cloud */
          yandex_cloud_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['cloudflare_r2_enabled']) {
          /* Cloudflare R2 */
          cloudflare_r2_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['pushr_enabled']) {
          /* Pushr */
          pushr_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['ovh_enabled']) {
          /* OVH Object Storage */
          ovh_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['bunny_enabled']) {
          /* Bunny Storage */
          bunny_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['storj_enabled']) {
          /* Storj */
          storj_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['ftp_enabled']) {
          /* FTP */
          ftp_upload($final_file_path, $final_file_name);
        }

        // add the file to the users uploads
        add_user_uploads($final_file_name, $final_file_size);

        // add the file to the pending uploads
        if (!in_array($_POST['handle'], ['cover-user', 'picture-user', 'cover-page', 'picture-page', 'cover-group', 'picture-group', 'cover-event'])) {
          add_pending_uploads($final_file_name, $final_file_size, $_POST['handle']);
        }

        // check the handle
        switch ($_POST['handle']) {
          case 'cover-user':
            /* check for cover album */
            if (!$user->_data['user_album_covers']) {
              /* create new cover album */
              $db->query(sprintf("INSERT INTO posts_photos_albums (user_id, user_type, title, privacy) VALUES (%s, 'user', 'Cover Photos', 'public')", secure($user->_data['user_id'], 'int')));
              $user->_data['user_album_covers'] = $db->insert_id;
              /* update user cover album id */
              $db->query(sprintf("UPDATE users SET user_album_covers = %s WHERE user_id = %s", secure($user->_data['user_album_covers'], 'int'), secure($user->_data['user_id'], 'int')));
            }
            /* insert updated cover photo post */
            $db->query(sprintf("INSERT INTO posts (user_id, user_type, post_type, time, privacy) VALUES (%s, 'user', 'profile_cover', %s, 'public')", secure($user->_data['user_id'], 'int'), secure($date)));
            $post_id = $db->insert_id;
            /* insert new cover photo to album */
            $db->query(sprintf("INSERT INTO posts_photos (post_id, album_id, source, blur) VALUES (%s, %s, %s, %s)", secure($post_id, 'int'), secure($user->_data['user_album_covers'], 'int'), secure($final_file_name), secure($image_blured)));
            $photo_id = $db->insert_id;
            /* update user cover */
            $db->query(sprintf("UPDATE users SET user_cover = %s, user_cover_id = %s WHERE user_id = %s", secure($final_file_name), secure($photo_id, 'int'), secure($user->_data['user_id'], 'int')));
            break;

          case 'picture-user':
            /* check for profile pictures album */
            if (!$user->_data['user_album_pictures']) {
              /* create new profile pictures album */
              $db->query(sprintf("INSERT INTO posts_photos_albums (user_id, user_type, title, privacy) VALUES (%s, 'user', 'Profile Pictures', 'public')", secure($user->_data['user_id'], 'int')));
              $user->_data['user_album_pictures'] = $db->insert_id;
              /* update user profile picture album id */
              $db->query(sprintf("UPDATE users SET user_album_pictures = %s WHERE user_id = %s", secure($user->_data['user_album_pictures'], 'int'), secure($user->_data['user_id'], 'int')));
            }
            /* insert updated profile picture post */
            $db->query(sprintf("INSERT INTO posts (user_id, user_type, post_type, time, privacy) VALUES (%s, 'user', 'profile_picture', %s, 'public')", secure($user->_data['user_id'], 'int'), secure($date)));
            $post_id = $db->insert_id;
            /* insert new profile picture to album */
            $db->query(sprintf("INSERT INTO posts_photos (post_id, album_id, source, blur) VALUES (%s, %s, %s, %s)", secure($post_id, 'int'), secure($user->_data['user_album_pictures'], 'int'), secure($final_file_name), secure($image_blured)));
            $photo_id = $db->insert_id;
            /* delete old cropped picture from uploads folder */
            delete_uploads_file($user->_data['user_picture_raw']);
            /* update user profile picture */
            $db->query(sprintf("UPDATE users SET user_picture = %s, user_picture_id = %s WHERE user_id = %s", secure($final_file_name), secure($photo_id, 'int'), secure($user->_data['user_id'], 'int')));
            break;

          case 'cover-page':
            /* check if page id is set */
            if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
              /* delete the uploaded image & return error 403 */
              unlink($final_file_path);
              _error(403);
            }
            /* check the page */
            $get_page = $db->query(sprintf("SELECT * FROM pages WHERE page_id = %s", secure($_POST['id'], 'int')));
            if ($get_page->num_rows == 0) {
              /* delete the uploaded image & return error 403 */
              unlink($final_file_path);
              _error(403);
            }
            $page = $get_page->fetch_assoc();
            /* check if the user is the page admin */
            if (!$user->check_page_adminship($user->_data['user_id'], $page['page_id'])) {
              /* delete the uploaded image & return error 403 */
              unlink($final_file_path);
              _error(403);
            }
            /* check for cover album */
            if (!$page['page_album_covers']) {
              /* create new cover album */
              $db->query(sprintf("INSERT INTO posts_photos_albums (user_id, user_type, title, privacy) VALUES (%s, 'page', 'Cover Photos', 'public')", secure($page['page_id'], 'int')));
              $page['page_album_covers'] = $db->insert_id;
              /* update page cover album id */
              $db->query(sprintf("UPDATE pages SET page_album_covers = %s WHERE page_id = %s", secure($page['page_album_covers'], 'int'), secure($page['page_id'], 'int')));
            }
            /* insert updated cover photo post */
            $db->query(sprintf("INSERT INTO posts (user_id, user_type, post_type, time, privacy) VALUES (%s, 'page', 'page_cover', %s, 'public')", secure($page['page_id'], 'int'), secure($date)));
            $post_id = $db->insert_id;
            /* insert new cover photo to album */
            $db->query(sprintf("INSERT INTO posts_photos (post_id, album_id, source, blur) VALUES (%s, %s, %s, %s)", secure($post_id, 'int'), secure($page['page_album_covers'], 'int'), secure($final_file_name), secure($image_blured)));
            $photo_id = $db->insert_id;
            /* update page cover */
            $db->query(sprintf("UPDATE pages SET page_cover = %s, page_cover_id = %s WHERE page_id = %s", secure($final_file_name), secure($photo_id, 'int'), secure($page['page_id'], 'int')));
            break;

          case 'picture-page':
            /* check if page id is set */
            if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
              /* delete the uploaded image & return error 403 */
              unlink($final_file_path);
              _error(403);
            }
            /* check the page */
            $get_page = $db->query(sprintf("SELECT * FROM pages WHERE page_id = %s", secure($_POST['id'], 'int')));
            if ($get_page->num_rows == 0) {
              /* delete the uploaded image & return error 403 */
              unlink($final_file_path);
              _error(403);
            }
            $page = $get_page->fetch_assoc();
            /* check if the user is the page admin */
            if (!$user->check_page_adminship($user->_data['user_id'], $page['page_id'])) {
              /* delete the uploaded image & return error 403 */
              unlink($final_file_path);
              _error(403);
            }
            /* check for page pictures album */
            if (!$page['page_album_pictures']) {
              /* create new page pictures album */
              $db->query(sprintf("INSERT INTO posts_photos_albums (user_id, user_type, title, privacy) VALUES (%s, 'page', 'Profile Pictures', 'public')", secure($page['page_id'], 'int')));
              $page['page_album_pictures'] = $db->insert_id;
              /* update page profile picture album id */
              $db->query(sprintf("UPDATE pages SET page_album_pictures = %s WHERE page_id = %s", secure($page['page_album_pictures'], 'int'), secure($page['page_id'], 'int')));
            }
            /* insert updated page picture post */
            $db->query(sprintf("INSERT INTO posts (user_id, user_type, post_type, time, privacy) VALUES (%s, 'page', 'page_picture', %s, 'public')", secure($page['page_id'], 'int'), secure($date)));
            $post_id = $db->insert_id;
            /* insert new page picture to album */
            $db->query(sprintf("INSERT INTO posts_photos (post_id, album_id, source, blur) VALUES (%s, %s, %s, %s)", secure($post_id, 'int'), secure($page['page_album_pictures'], 'int'), secure($final_file_name), secure($image_blured)));
            $photo_id = $db->insert_id;
            /* delete old cropped picture from uploads folder */
            delete_uploads_file($page['page_picture']);
            /* update page picture */
            $db->query(sprintf("UPDATE pages SET page_picture = %s, page_picture_id = %s WHERE page_id = %s", secure($final_file_name), secure($photo_id, 'int'), secure($page['page_id'], 'int')));
            break;

          case 'cover-group':
            /* check if group id is set */
            if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
              /* delete the uploaded image & return error 403 */
              unlink($final_file_path);
              _error(403);
            }
            /* check the group */
            $get_group = $db->query(sprintf("SELECT * FROM `groups` WHERE group_id = %s", secure($_POST['id'], 'int')));
            if ($get_group->num_rows == 0) {
              /* delete the uploaded image & return error 403 */
              unlink($final_file_path);
              _error(403);
            }
            $group = $get_group->fetch_assoc();
            /* check if the user is the group admin */
            if (!$user->check_group_adminship($user->_data['user_id'], $group['group_id'])) {
              /* delete the uploaded image & return error 403 */
              unlink($final_file_path);
              _error(403);
            }
            /* check for group covers album */
            if (!$group['group_album_covers']) {
              /* create new group covers album */
              $db->query(sprintf("INSERT INTO posts_photos_albums (user_id, user_type, in_group, group_id, title, privacy) VALUES (%s, 'user', '1', %s, 'Cover Photos', 'public')", secure($user->_data['user_id'], 'int'), secure($group['group_id'], 'int')));
              $group['group_album_covers'] = $db->insert_id;
              /* update group cover album id */
              $db->query(sprintf("UPDATE `groups` SET group_album_covers = %s WHERE group_id = %s", secure($group['group_album_covers'], 'int'), secure($group['group_id'], 'int')));
            }
            /* insert updated group cover post */
            $db->query(sprintf("INSERT INTO posts (user_id, user_type, post_type, in_group, group_id, time, privacy) VALUES (%s, 'user', 'group_cover', '1', %s, %s, 'custom')", secure($user->_data['user_id'], 'int'), secure($group['group_id'], 'int'), secure($date)));
            $post_id = $db->insert_id;
            /* insert new group cover to album */
            $db->query(sprintf("INSERT INTO posts_photos (post_id, album_id, source, blur) VALUES (%s, %s, %s, %s)", secure($post_id, 'int'), secure($group['group_album_covers'], 'int'), secure($final_file_name), secure($image_blured)));
            $photo_id = $db->insert_id;
            /* update group cover */
            $db->query(sprintf("UPDATE `groups` SET group_cover = %s, group_cover_id = %s WHERE group_id = %s", secure($final_file_name), secure($photo_id, 'int'), secure($group['group_id'], 'int')));
            break;

          case 'picture-group':
            /* check if group id is set */
            if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
              /* delete the uploaded image & return error 403 */
              unlink($final_file_path);
              _error(403);
            }
            /* check the group */
            $get_group = $db->query(sprintf("SELECT * FROM `groups` WHERE group_id = %s", secure($_POST['id'], 'int')));
            if ($get_group->num_rows == 0) {
              /* delete the uploaded image & return error 403 */
              unlink($final_file_path);
              _error(403);
            }
            $group = $get_group->fetch_assoc();
            /* check if the user is the group admin */
            if (!$user->check_group_adminship($user->_data['user_id'], $group['group_id'])) {
              /* delete the uploaded image & return error 403 */
              unlink($final_file_path);
              _error(403);
            }
            /* check for group pictures album */
            if (!$group['group_album_pictures']) {
              /* create new group pictures album */
              $db->query(sprintf("INSERT INTO posts_photos_albums (user_id, user_type, in_group, group_id, title, privacy) VALUES (%s, 'user', '1', %s, 'Profile Pictures', 'public')", secure($user->_data['user_id'], 'int'), secure($group['group_id'], 'int')));
              $group['group_album_pictures'] = $db->insert_id;
              /* update group profile picture album id */
              $db->query(sprintf("UPDATE `groups` SET group_album_pictures = %s WHERE group_id = %s", secure($group['group_album_pictures'], 'int'), secure($group['group_id'], 'int')));
            }
            /* insert updated group picture post */
            $db->query(sprintf("INSERT INTO posts (user_id, user_type, post_type, in_group, group_id, time, privacy) VALUES (%s, 'user', 'group_picture', '1', %s, %s, 'custom')", secure($user->_data['user_id'], 'int'), secure($group['group_id'], 'int'), secure($date)));
            $post_id = $db->insert_id;
            /* insert new group picture to album */
            $db->query(sprintf("INSERT INTO posts_photos (post_id, album_id, source, blur) VALUES (%s, %s, %s, %s)", secure($post_id, 'int'), secure($group['group_album_pictures'], 'int'), secure($final_file_name), secure($image_blured)));
            $photo_id = $db->insert_id;
            /* delete old cropped picture from uploads folder */
            delete_uploads_file($group['group_picture']);
            /* update group picture */
            $db->query(sprintf("UPDATE `groups` SET group_picture = %s, group_picture_id = %s WHERE group_id = %s", secure($final_file_name), secure($photo_id, 'int'), secure($group['group_id'], 'int')));
            break;

          case 'cover-event':
            /* check if event id is set */
            if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
              /* delete the uploaded image & return error 403 */
              unlink($final_file_path);
              _error(403);
            }
            /* check the event */
            $get_event = $db->query(sprintf("SELECT * FROM `events` WHERE event_id = %s", secure($_POST['id'], 'int')));
            if ($get_event->num_rows == 0) {
              /* delete the uploaded image & return error 403 */
              unlink($final_file_path);
              _error(403);
            }
            $event = $get_event->fetch_assoc();
            /* check if the user is the event admin */
            if (!$user->check_event_adminship($user->_data['user_id'], $event['event_id'])) {
              /* delete the uploaded image & return error 403 */
              unlink($final_file_path);
              _error(403);
            }
            /* check for event covers album */
            if (!$event['event_album_covers']) {
              /* create new event covers album */
              $db->query(sprintf("INSERT INTO posts_photos_albums (user_id, user_type, in_event, event_id, title, privacy) VALUES (%s, 'user', '1', %s, 'Cover Photos', 'public')", secure($user->_data['user_id'], 'int'), secure($event['event_id'], 'int')));
              $event['event_album_covers'] = $db->insert_id;
              /* update event cover album id */
              $db->query(sprintf("UPDATE `events` SET event_album_covers = %s WHERE event_id = %s", secure($event['event_album_covers'], 'int'), secure($event['event_id'], 'int')));
            }
            /* prepare author */
            $author_type = ($event['event_page_id']) ? 'page' : 'user';
            $author_id = ($event['event_page_id']) ? $event['event_page_id'] : $user->_data['user_id'];
            /* insert updated event cover post */
            $db->query(sprintf("INSERT INTO posts (user_id, user_type, post_type, in_event, event_id, time, privacy) VALUES (%s, %s, 'event_cover', '1', %s, %s, 'custom')", secure($author_id, 'int'), secure($author_type), secure($event['event_id'], 'int'), secure($date)));
            $post_id = $db->insert_id;
            /* insert new event cover to album */
            $db->query(sprintf("INSERT INTO posts_photos (post_id, album_id, source, blur) VALUES (%s, %s, %s, %s)", secure($post_id, 'int'), secure($event['event_album_covers'], 'int'), secure($final_file_name), secure($image_blured)));
            $photo_id = $db->insert_id;
            /* update event cover */
            $db->query(sprintf("UPDATE `events` SET event_cover = %s, event_cover_id = %s WHERE event_id = %s", secure($final_file_name), secure($photo_id, 'int'), secure($event['event_id'], 'int')));
            break;
        }

        // return the file name & exit
        if ($_POST["multiple"] == "true") {
          $finished_files[] = ["source" => $final_file_name, "blur" => $image_blured];
          if ($_POST["totalFiles"] == $_POST["fileIndex"] + 1) {
            return $finished_files;
          } else {
            return_json(['status' => 'ok', 'finished_files' => $finished_files]);
          }
        } else {
          return $final_file_name;
        }
      }

      // If not all chunks are uploaded yet, return a status
      return_json(['status' => 'ok']);
      break;

    case 'video':
      // check videos upload permission
      if (!$user->_data['can_upload_videos']) {
        throw new AuthorizationException(__("You don't have the permission to do this"));
      }
      if (!$user->_is_admin && $_POST['handle'] == 'chat' && !$system['chat_videos_enabled']) {
        throw new AuthorizationException(__("Uploading videos feature has been disabled by the admin"));
      }

      // get allowed file size
      $max_allowed_size = $system['max_video_size'] * 1024;

      // prepare uploads directory
      $folder = 'videos';
      $directory = $folder . '/' . date('Y') . '/' . date('m') . '/';
      if (!file_exists(ABSPATH . $system['uploads_directory'] . '/' . $directory)) {
        @mkdir(ABSPATH . $system['uploads_directory'] . '/' . $directory, 0777, true);
      }

      // check file extesnion
      $extension = get_extension($file_name);
      if (!valid_extension($extension, $system['video_extensions'])) {
        throw new BadRequestException(__("The file type is not valid or not supported"));
      }

      // save each chunk to a temporary file
      $temp_file = $temp_directory . $file_guid . '_' . $file_name .  ".part-" . $chunkIndex;
      if (!@move_uploaded_file($_FILES['file']['tmp_name'], $temp_file)) {
        throw new Exception(__("Sorry, could not upload the file chunk"));
      }

      // if this is the last chunk, reassemble the file
      if ($chunkIndex + 1 === $totalChunks) {

        // prepare final file name & path
        $prefix = $system['uploads_prefix'] . '_' . get_hash_token();
        $final_file_name = $directory . $prefix . '.' . $extension;
        $final_file_path = ABSPATH . $system['uploads_directory'] . '/' . $final_file_name;

        // reassemble the chunks into the final file
        reassemble_file_chunks($temp_directory, $file_guid, $file_name, $totalChunks, $final_file_path);

        // check file size
        $final_file_size = filesize($final_file_path);
        if (!$user->_is_admin && !$user->_is_moderator) {
          if ($final_file_size > $max_allowed_size) {
            throw new ValidationException(__("The file size is so big") . ", " . __("The allowed file size is:") . " " . ($max_allowed_size / 1024 / 1024) . __("MB"));
          }
        }

        // upload to
        if ($system['s3_enabled']) {
          /* Amazon S3 */
          aws_s3_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['google_cloud_enabled']) {
          /* Google Cloud */
          google_cloud_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['digitalocean_enabled']) {
          /* DigitalOcean */
          digitalocean_space_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['wasabi_enabled']) {
          /* Wasabi */
          wasabi_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['backblaze_enabled']) {
          /* Backblaze */
          backblaze_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['yandex_cloud_enabled']) {
          /* Yandex Cloud */
          yandex_cloud_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['cloudflare_r2_enabled']) {
          /* Cloudflare R2 */
          cloudflare_r2_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['pushr_enabled']) {
          /* Pushr */
          pushr_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['ovh_enabled']) {
          /* OVH Object Storage */
          ovh_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['bunny_enabled']) {
          /* Bunny Storage */
          bunny_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['storj_enabled']) {
          /* Storj */
          storj_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['ftp_enabled']) {
          /* FTP */
          ftp_upload($final_file_path, $final_file_name);
        }

        // add the file to the users uploads
        add_user_uploads($final_file_name, $final_file_size);

        // add the file to the pending uploads
        add_pending_uploads($final_file_name, $final_file_size, $_POST['handle']);

        // return the file new name & exit
        if ($_POST["multiple"] == "true") {
          $finished_files[] = $final_file_name;
          if ($_POST["totalFiles"] == $_POST["fileIndex"] + 1) {
            return $finished_files;
          } else {
            return_json(['status' => 'ok', 'finished_files' => $finished_files]);
          }
        } else {
          return $final_file_name;
        }
      }

      // If not all chunks are uploaded yet, return a status
      return_json(['status' => 'ok']);
      break;

    case 'reel':
      // check reels upload permission
      if (!$user->_data['can_add_reels']) {
        throw new AuthorizationException(__("You don't have the permission to do this"));
      }

      // get allowed file size
      $max_allowed_size = $system['max_video_size'] * 1024;

      // prepare uploads directory
      $folder = 'videos';
      $directory = $folder . '/' . date('Y') . '/' . date('m') . '/';
      if (!file_exists(ABSPATH . $system['uploads_directory'] . '/' . $directory)) {
        @mkdir(ABSPATH . $system['uploads_directory'] . '/' . $directory, 0777, true);
      }

      // check file extesnion
      $extension = get_extension($file_name);
      if (!valid_extension($extension, $system['video_extensions'])) {
        throw new BadRequestException(__("The file type is not valid or not supported"));
      }

      // save each chunk to a temporary file
      $temp_file = $temp_directory . $file_guid . '_' . $file_name .  ".part-" . $chunkIndex;
      if (!@move_uploaded_file($_FILES['file']['tmp_name'], $temp_file)) {
        throw new Exception(__("Sorry, could not upload the file chunk"));
      }

      // if this is the last chunk, reassemble the file
      if ($chunkIndex + 1 === $totalChunks) {

        // prepare final file name & path
        $prefix = $system['uploads_prefix'] . '_' . get_hash_token();
        $final_file_name = $directory . $prefix . '.' . $extension;
        $final_file_path = ABSPATH . $system['uploads_directory'] . '/' . $final_file_name;

        // reassemble the chunks into the final file
        reassemble_file_chunks($temp_directory, $file_guid, $file_name, $totalChunks, $final_file_path);

        // check file size
        $final_file_size = filesize($final_file_path);
        if (!$user->_is_admin && !$user->_is_moderator) {
          if ($final_file_size > $max_allowed_size) {
            throw new ValidationException(__("The file size is so big") . ", " . __("The allowed file size is:") . " " . ($max_allowed_size / 1024 / 1024) . __("MB"));
          }
        }

        // upload to
        if ($system['s3_enabled']) {
          /* Amazon S3 */
          aws_s3_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['google_cloud_enabled']) {
          /* Google Cloud */
          google_cloud_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['digitalocean_enabled']) {
          /* DigitalOcean */
          digitalocean_space_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['wasabi_enabled']) {
          /* Wasabi */
          wasabi_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['backblaze_enabled']) {
          /* Backblaze */
          backblaze_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['yandex_cloud_enabled']) {
          /* Yandex Cloud */
          yandex_cloud_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['cloudflare_r2_enabled']) {
          /* Cloudflare R2 */
          cloudflare_r2_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['pushr_enabled']) {
          /* Pushr */
          pushr_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['ovh_enabled']) {
          /* OVH Object Storage */
          ovh_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['bunny_enabled']) {
          /* Bunny Storage */
          bunny_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['storj_enabled']) {
          /* Storj */
          storj_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['ftp_enabled']) {
          /* FTP */
          ftp_upload($final_file_path, $final_file_name);
        }

        // add the file to the users uploads
        add_user_uploads($final_file_name, $final_file_size);

        // add the file to the pending uploads
        add_pending_uploads($final_file_name, $final_file_size, $_POST['handle']);

        // return the file new name & exit
        if ($_POST["multiple"] == "true") {
          $finished_files[] = $final_file_name;
          if ($_POST["totalFiles"] == $_POST["fileIndex"] + 1) {
            return $finished_files;
          } else {
            return_json(['status' => 'ok', 'finished_files' => $finished_files]);
          }
        } else {
          return $final_file_name;
        }
      }

      // If not all chunks are uploaded yet, return a status
      return_json(['status' => 'ok']);
      break;

    case 'audio':
      // check audios upload permission
      if (!$user->_data['can_upload_audios']) {
        throw new AuthorizationException(__("You don't have the permission to do this"));
      }

      // get allowed file size
      $max_allowed_size = $system['max_audio_size'] * 1024;

      // prepare uploads directory
      $folder = 'sounds';
      $directory = $folder . '/' . date('Y') . '/' . date('m') . '/';
      if (!file_exists(ABSPATH . $system['uploads_directory'] . '/' . $directory)) {
        @mkdir(ABSPATH . $system['uploads_directory'] . '/' . $directory, 0777, true);
      }

      // check file extesnion
      $extension = get_extension($file_name);
      if (!valid_extension($extension, $system['audio_extensions'])) {
        throw new BadRequestException(__("The file type is not valid or not supported"));
      }

      // save each chunk to a temporary file
      $temp_file = $temp_directory . $file_guid . '_' . $file_name .  ".part-" . $chunkIndex;
      if (!@move_uploaded_file($_FILES['file']['tmp_name'], $temp_file)) {
        throw new Exception(__("Sorry, could not upload the file chunk"));
      }

      // if this is the last chunk, reassemble the file
      if ($chunkIndex + 1 === $totalChunks) {

        // prepare final file name & path
        $prefix = $system['uploads_prefix'] . '_' . get_hash_token();
        $final_file_name = $directory . $prefix . '.' . $extension;
        $final_file_path = ABSPATH . $system['uploads_directory'] . '/' . $final_file_name;

        // reassemble the chunks into the final file
        reassemble_file_chunks($temp_directory, $file_guid, $file_name, $totalChunks, $final_file_path);

        // check file size
        $final_file_size = filesize($final_file_path);
        if (!$user->_is_admin && !$user->_is_moderator) {
          if ($final_file_size > $max_allowed_size) {
            throw new ValidationException(__("The file size is so big") . ", " . __("The allowed file size is:") . " " . ($max_allowed_size / 1024 / 1024) . __("MB"));
          }
        }

        // upload to
        if ($system['s3_enabled']) {
          /* Amazon S3 */
          aws_s3_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['google_cloud_enabled']) {
          /* Google Cloud */
          google_cloud_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['digitalocean_enabled']) {
          /* DigitalOcean */
          digitalocean_space_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['wasabi_enabled']) {
          /* Wasabi */
          wasabi_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['backblaze_enabled']) {
          /* Backblaze */
          backblaze_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['yandex_cloud_enabled']) {
          /* Yandex Cloud */
          yandex_cloud_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['cloudflare_r2_enabled']) {
          /* Cloudflare R2 */
          cloudflare_r2_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['pushr_enabled']) {
          /* Pushr */
          pushr_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['ovh_enabled']) {
          /* OVH Object Storage */
          ovh_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['bunny_enabled']) {
          /* Bunny Storage */
          bunny_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['storj_enabled']) {
          /* Storj */
          storj_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['ftp_enabled']) {
          /* FTP */
          ftp_upload($final_file_path, $final_file_name);
        }

        // add the file to the users uploads
        add_user_uploads($final_file_name, $final_file_size);

        // add the file to the pending uploads
        add_pending_uploads($final_file_name, $final_file_size, $_POST['handle']);

        // return the file new name & exit
        if ($_POST["multiple"] == "true") {
          $finished_files[] = $final_file_name;
          if ($_POST["totalFiles"] == $_POST["fileIndex"] + 1) {
            return $finished_files;
          } else {
            return_json(['status' => 'ok', 'finished_files' => $finished_files]);
          }
        } else {
          return $final_file_name;
        }
      }

      // If not all chunks are uploaded yet, return a status
      return_json(['status' => 'ok']);
      break;

    case 'file':
      // check files upload permission
      if ($_POST['handle'] != "x-file" && !$user->_data['can_upload_files']) {
        modal("ERROR", __("Not Allowed"), __("You don't have the permission to do this"));
      }
      if (!$user->_is_admin && $_POST['handle'] == 'chat' && !$system['chat_files_enabled']) {
        throw new AuthorizationException(__("Uploading files feature has been disabled by the admin"));
      }

      // get allowed file size
      $max_allowed_size = $system['max_file_size'] * 1024;

      // prepare uploads directory
      $folder = 'files';
      $directory = $folder . '/' . date('Y') . '/' . date('m') . '/';
      if (!file_exists(ABSPATH . $system['uploads_directory'] . '/' . $directory)) {
        @mkdir(ABSPATH . $system['uploads_directory'] . '/' . $directory, 0777, true);
      }

      // check file extesnion
      $extension = get_extension($file_name);
      if (!valid_extension($extension, $system['file_extensions'])) {
        throw new BadRequestException(__("The file type is not valid or not supported"));
      }

      // save each chunk to a temporary file
      $temp_file = $temp_directory . $file_guid . '_' . $file_name .  ".part-" . $chunkIndex;
      if (!@move_uploaded_file($_FILES['file']['tmp_name'], $temp_file)) {
        throw new Exception(__("Sorry, could not upload the file chunk"));
      }

      // if this is the last chunk, reassemble the file
      if ($chunkIndex + 1 === $totalChunks) {

        // prepare final file name & path
        $prefix = $system['uploads_prefix'] . '_' . get_hash_token();
        $final_file_name = $directory . $prefix . '.' . $extension;
        $final_file_path = ABSPATH . $system['uploads_directory'] . '/' . $final_file_name;

        // reassemble the chunks into the final file
        reassemble_file_chunks($temp_directory, $file_guid, $file_name, $totalChunks, $final_file_path);

        // check file size
        $final_file_size = filesize($final_file_path);
        if (!$user->_is_admin && !$user->_is_moderator) {
          if ($final_file_size > $max_allowed_size) {
            throw new ValidationException(__("The file size is so big") . ", " . __("The allowed file size is:") . " " . ($max_allowed_size / 1024 / 1024) . __("MB"));
          }
        }

        // upload to
        if ($system['s3_enabled']) {
          /* Amazon S3 */
          aws_s3_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['google_cloud_enabled']) {
          /* Google Cloud */
          google_cloud_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['digitalocean_enabled']) {
          /* DigitalOcean */
          digitalocean_space_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['wasabi_enabled']) {
          /* Wasabi */
          wasabi_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['backblaze_enabled']) {
          /* Backblaze */
          backblaze_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['yandex_cloud_enabled']) {
          /* Yandex Cloud */
          yandex_cloud_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['cloudflare_r2_enabled']) {
          /* Cloudflare R2 */
          cloudflare_r2_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['pushr_enabled']) {
          /* Pushr */
          pushr_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['ovh_enabled']) {
          /* OVH Object Storage */
          ovh_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['bunny_enabled']) {
          /* Bunny Storage */
          bunny_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['storj_enabled']) {
          /* Storj */
          storj_upload($final_file_path, $final_file_name, mime_content_type($final_file_path));
        } elseif ($system['ftp_enabled']) {
          /* FTP */
          ftp_upload($final_file_path, $final_file_name);
        }

        // add the file to the users uploads
        add_user_uploads($final_file_name, $final_file_size);

        // add the file to the pending uploads
        add_pending_uploads($final_file_name, $final_file_size, $_POST['handle']);

        // return the file new name & exit
        if ($_POST["multiple"] == "true") {
          $finished_files[] = $final_file_name;
          if ($_POST["totalFiles"] == $_POST["fileIndex"] + 1) {
            return $finished_files;
          } else {
            return_json(['status' => 'ok', 'finished_files' => $finished_files]);
          }
        } else {
          return $final_file_name;
        }
      }

      // If not all chunks are uploaded yet, return a status
      return_json(['status' => 'ok']);
      break;

    default:
      _error(403);
      break;
  }
}


/**
 * delete_avatar_cover_image
 * 
 * @param string $handle
 * @param int $id
 * @return void
 */
function delete_avatar_cover_image($handle, $id = null)
{
  global $db, $user, $system;
  switch ($_POST['handle']) {
    case 'cover-user':
      /* update user cover */
      $db->query(sprintf("UPDATE users SET user_cover = null, user_cover_id = null, user_cover_position = null WHERE user_id = %s", secure($user->_data['user_id'], 'int')));
      /* delete cover image from uploads folder */
      delete_uploads_file($user->_data['user_cover']);
      break;

    case 'picture-user':
      /* update user picture */
      $db->query(sprintf("UPDATE users SET user_picture = null, user_picture_id = null WHERE user_id = %s", secure($user->_data['user_id'], 'int')));
      /* delete picture image from uploads folder */
      delete_uploads_file($user->_data['user_picture_raw']);
      /* return */
      return get_picture('', $user->_data['user_gender']);
      break;

    case 'cover-page':
      /* check if page id is set */
      if (!isset($id) || !is_numeric($id)) {
        throw new BadRequestException(__("Invalid ID"));
      }
      /* check the page */
      $get_page = $db->query(sprintf("SELECT * FROM pages WHERE page_id = %s", secure($id, 'int')));
      if ($get_page->num_rows == 0) {
        throw new NoDataException(__("Page not found"));
      }
      $page = $get_page->fetch_assoc();
      /* check if the user is the page admin */
      if (!$user->check_page_adminship($user->_data['user_id'], $page['page_id'])) {
        throw new AuthorizationException(__("You don't have the right permission to do this"));
      }
      /* update page cover */
      $db->query(sprintf("UPDATE pages SET page_cover = null, page_cover_id = null, page_cover_position = null WHERE page_id = %s", secure($id, 'int')));
      /* delete cover image from uploads folder */
      delete_uploads_file($page['page_cover']);
      break;

    case 'picture-page':
      /* check if page id is set */
      if (!isset($id) || !is_numeric($id)) {
        throw new BadRequestException(__("Invalid ID"));
      }
      /* check the page */
      $get_page = $db->query(sprintf("SELECT * FROM pages WHERE page_id = %s", secure($id, 'int')));
      if ($get_page->num_rows == 0) {
        throw new NoDataException(__("Page not found"));
      }
      $page = $get_page->fetch_assoc();
      /* check if the user is the page admin */
      if (!$user->check_page_adminship($user->_data['user_id'], $page['page_id'])) {
        throw new AuthorizationException(__("You don't have the right permission to do this"));
      }
      /* update page picture */
      $db->query(sprintf("UPDATE pages SET page_picture = null, page_picture_id = null WHERE page_id = %s", secure($id, 'int')));
      /* delete picture image from uploads folder */
      delete_uploads_file($page['page_picture']);
      /* return */
      return get_picture('', 'page');
      break;

    case 'cover-group':
      /* check if group id is set */
      if (!isset($id) || !is_numeric($id)) {
        throw new BadRequestException(__("Invalid ID"));
      }
      /* check the group */
      $get_group = $db->query(sprintf("SELECT * FROM `groups` WHERE group_id = %s", secure($id, 'int')));
      if ($get_group->num_rows == 0) {
        throw new NoDataException(__("Group not found"));
      }
      $group = $get_group->fetch_assoc();
      /* check if the user is the group admin */
      if (!$user->check_group_adminship($user->_data['user_id'], $group['group_id'])) {
        throw new AuthorizationException(__("You don't have the right permission to do this"));
      }
      /* update group cover */
      $db->query(sprintf("UPDATE `groups` SET group_cover = null, group_cover_id = null, group_cover_position = null WHERE group_id = %s", secure($id, 'int')));
      /* delete cover image from uploads folder */
      delete_uploads_file($group['group_cover']);
      break;

    case 'picture-group':
      /* check if group id is set */
      if (!isset($id) || !is_numeric($id)) {
        throw new BadRequestException(__("Invalid ID"));
      }
      /* check the group */
      $get_group = $db->query(sprintf("SELECT * FROM `groups` WHERE group_id = %s", secure($id, 'int')));
      if ($get_group->num_rows == 0) {
        throw new NoDataException(__("Group not found"));
      }
      $group = $get_group->fetch_assoc();
      /* check if the user is the group admin */
      if (!$user->check_group_adminship($user->_data['user_id'], $group['group_id'])) {
        throw new AuthorizationException(__("You don't have the right permission to do this"));
      }
      /* update group picture */
      $db->query(sprintf("UPDATE `groups` SET group_picture = null, group_picture_id = null WHERE group_id = %s", secure($id, 'int')));
      /* delete picture image from uploads folder */
      delete_uploads_file($group['group_picture']);
      /* return */
      return get_picture('', 'group');
      break;

    case 'cover-event':
      /* check if event id is set */
      if (!isset($id) || !is_numeric($id)) {
        throw new BadRequestException(__("Invalid ID"));
      }
      /* check the event */
      $get_event = $db->query(sprintf("SELECT * FROM `events` WHERE event_id = %s", secure($id, 'int')));
      if ($get_event->num_rows == 0) {
        throw new NoDataException(__("Event not found"));
      }
      $event = $get_event->fetch_assoc();
      /* check if the user is the event admin */
      if (!$user->check_event_adminship($user->_data['user_id'], $event['event_id'])) {
        throw new AuthorizationException(__("You don't have the right permission to do this"));
      }
      /* update event cover */
      $db->query(sprintf("UPDATE `events` SET event_cover = null, event_cover_id = null, event_cover_position = null WHERE event_id = %s", secure($id, 'int')));
      /* delete cover image from uploads folder */
      delete_uploads_file($event['event_cover']);
      break;

    default:
      throw new BadRequestException(__("Invalid request"));
      break;
  }
}


/**
 * add_user_uploads
 * 
 * @param string $file_name
 * @param int $file_size
 * @return void
 */
function add_user_uploads($file_name, $file_size)
{
  global $db, $user, $date;
  $db->query(sprintf("INSERT INTO users_uploads (user_id, file_name, file_size, insert_date) VALUES (%s, %s, %s, %s)", secure($user->_data['user_id'], 'int'), secure($file_name), secure($file_size), secure($date)));
}


/**
 * add_pending_uploads
 * 
 * @param string $file_name
 * @param int $file_size
 * @param string $handle
 * @return void
 */
function add_pending_uploads($file_name, $file_size, $handle)
{
  global $db, $user, $date;
  $db->query(sprintf("INSERT INTO users_uploads_pending (user_id, file_name, file_size, handle, insert_date) VALUES (%s, %s, %s, %s, %s)", secure($user->_data['user_id'], 'int'), secure($file_name), secure($file_size), secure($handle), secure($date)));
}


/**
 * remove_pending_uploads
 * 
 * @param array $files
 * @param int $user_id
 * @return void
 */
function remove_pending_uploads($files = [], $user_id = null)
{
  global $db, $user;
  $user_id = ($user_id) ? $user_id : $user->_data['user_id'];
  foreach ($files as $file_name) {
    if (empty($file_name)) continue;
    $db->query(sprintf("DELETE FROM users_uploads_pending WHERE user_id = %s AND file_name = %s", secure($user_id, 'int'), secure($file_name)));
  }
}


/**
 * clear_pending_uploads
 * 
 * @return void
 */
function clear_pending_uploads()
{
  global $db;
  $pending_uploads = $db->query("SELECT * FROM users_uploads_pending");
  while ($pending_upload = $pending_uploads->fetch_assoc()) {
    delete_uploads_file($pending_upload['file_name'], true, $pending_upload['user_id']);
  }
}


/**
 * extract_uploaded_images_from_text
 * 
 * @param string $text
 * @return array
 */
function extract_uploaded_images_from_text($text)
{
  global $system;
  $images = [];
  preg_replace_callback('/<img[^>]+src="([^"]+)"[^>]*>/', function ($matches) use (&$images, $system) {
    $src = $matches[1];
    if (strpos($src, $system['system_uploads']) === 0) {
      $relative_path = substr($src, strlen($system['system_uploads']));
      $relative_path = ltrim($relative_path, '/');
      $images[] = $relative_path;
    }
    return '';
  }, $text);
  return $images;
}


/* ------------------------------- */
/* Cloud Storage */
/* ------------------------------- */

/**
 * aws_s3_test
 * 
 * @param string $s3_bucket
 * @param string $s3_region
 * @param string $s3_key
 * @param string $s3_secret
 * @return void
 */
function aws_s3_test($s3_bucket, $s3_region, $s3_key, $s3_secret, $s3_endpoint = '')
{
  try {
    $s3_config = [
      'version'    => 'latest',
      'region'      => $s3_region,
      'credentials' => [
        'key'    => $s3_key,
        'secret' => $s3_secret,
      ]
    ];
    if ($s3_endpoint) {
      $s3_config['endpoint'] = $s3_endpoint;
      $s3_config['use_path_style_endpoint'] = true;
    }
    $s3Client = Aws\S3\S3Client::factory($s3_config);
    $buckets = $s3Client->listBuckets();
    if (empty($buckets)) {
      throw new Exception(__("There is no buckets in your account"));
    }
    if (!$s3Client->doesBucketExist($s3_bucket)) {
      throw new Exception(__("There is no bucket with this name in your account"));
    }
  } catch (Exception $e) {
    if (DEBUGGING) {
      throw new Exception($e->getMessage());
    } else {
      throw new Exception(__("Connection Failed, Please check your settings"));
    }
  }
}


/**
 * aws_s3_upload
 * 
 * @param string $file_source
 * @param string $file_name
 * @param string $content_type
 * @return void
 */
function aws_s3_upload($file_source, $file_name, $content_type = "")
{
  global $system;
  $s3Client = Aws\S3\S3Client::factory([
    'version'     => 'latest',
    'region'      => $system['s3_region'],
    'credentials' => [
      'key'     => $system['s3_key'],
      'secret'  => $system['s3_secret'],
    ]
  ]);
  $Key = 'uploads/' . $file_name;
  $s3Client->putObject([
    'Bucket' => $system['s3_bucket'],
    'Key'    => $Key,
    'Body'   => fopen($file_source, 'r+'),
    'ContentDisposition' => 'inline',
    'ContentType' => $content_type,
    'ACL'    => 'public-read',
  ]);
  /* remove local file */
  gc_collect_cycles();
  if ($s3Client->doesObjectExist($system['s3_bucket'], $Key)) {
    unlink($file_source);
  }
}


/**
 * google_cloud_test
 * 
 * @return void
 */
function google_cloud_test()
{
  global $system;
  try {
    $storage = new Google\Cloud\Storage\StorageClient([
      'keyFile' => json_decode(html_entity_decode($system['google_cloud_file'], ENT_QUOTES), true),
    ]);
    $bucket = $storage->bucket($system['google_cloud_bucket']);
    if (!$bucket->exists()) {
      throw new Exception(__("There is no buckets in your account"));
    }
  } catch (Exception $e) {
    if (DEBUGGING) {
      throw new Exception($e->getMessage());
    } else {
      throw new Exception(__("Connection Failed, Please check your settings"));
    }
  }
}


/**
 * google_cloud_upload
 * 
 * @param string $file_source
 * @param string $file_name
 * @param string $content_type
 * @return void
 */
function google_cloud_upload($file_source, $file_name, $content_type = "")
{
  global $system;
  $storage = new Google\Cloud\Storage\StorageClient([
    'keyFile' => json_decode(html_entity_decode($system['google_cloud_file'], ENT_QUOTES), true),
  ]);
  $bucket = $storage->bucket($system['google_cloud_bucket']);
  $fileContent = file_get_contents($file_source);
  $Key = 'uploads/' . $file_name;
  $storageObject = $bucket->upload($fileContent, ['name' => $Key]);
  /* remove local file */
  gc_collect_cycles();
  if (!empty($storageObject)) {
    unlink($file_source);
  }
}


/**
 * digitalocean_space_test
 * 
 * @return void
 */
function digitalocean_space_test()
{
  global $system;
  try {
    $s3Client = Aws\S3\S3Client::factory([
      'version'     => 'latest',
      'endpoint'    => 'https://' . $system['digitalocean_space_region'] . '.digitaloceanspaces.com',
      'region'      => $system['digitalocean_space_region'],
      'credentials' => [
        'key'     => $system['digitalocean_key'],
        'secret'  => $system['digitalocean_secret'],
      ]
    ]);
    $buckets = $s3Client->listBuckets();
    if (empty($buckets)) {
      throw new Exception(__("There is no buckets in your account"));
    }
    if (!$s3Client->doesBucketExist($system['digitalocean_space_name'])) {
      throw new Exception(__("There is no bucket with this name in your account"));
    }
  } catch (Exception $e) {
    if (DEBUGGING) {
      throw new Exception($e->getMessage());
    } else {
      throw new Exception(__("Connection Failed, Please check your settings"));
    }
  }
}


/**
 * digitalocean_space_upload
 * 
 * @param string $file_source
 * @param string $file_name
 * @param string $content_type
 * @return void
 */
function digitalocean_space_upload($file_source, $file_name, $content_type = "")
{
  global $system;
  $s3Client = Aws\S3\S3Client::factory([
    'version'     => 'latest',
    'endpoint'    => 'https://' . $system['digitalocean_space_region'] . '.digitaloceanspaces.com',
    'region'      => $system['digitalocean_space_region'],
    'credentials' => [
      'key'     => $system['digitalocean_key'],
      'secret'  => $system['digitalocean_secret'],
    ]
  ]);
  $Key = 'uploads/' . $file_name;
  $s3Client->putObject([
    'Bucket' => $system['digitalocean_space_name'],
    'Key'    => $Key,
    'Body'   => fopen($file_source, 'r+'),
    'ContentDisposition' => 'inline',
    'ContentType' => $content_type,
    'ACL'    => 'public-read',
  ]);
  /* remove local file */
  gc_collect_cycles();
  if ($s3Client->doesObjectExist($system['digitalocean_space_name'], $Key)) {
    unlink($file_source);
  }
}


/**
 * wasabi_test
 * 
 * @return void
 */
function wasabi_test()
{
  global $system;
  try {
    $s3Client = Aws\S3\S3Client::factory([
      'version'     => 'latest',
      'endpoint'    => 'https://s3.' . $system['wasabi_region'] . '.wasabisys.com',
      'region'      => $system['wasabi_region'],
      'credentials' => [
        'key'     => $system['wasabi_key'],
        'secret'  => $system['wasabi_secret'],
      ]
    ]);
    $buckets = $s3Client->listBuckets();
    if (empty($buckets)) {
      throw new Exception(__("There is no buckets in your account"));
    }
    if (!$s3Client->doesBucketExist($system['wasabi_bucket'])) {
      throw new Exception(__("There is no bucket with this name in your account"));
    }
  } catch (Exception $e) {
    if (DEBUGGING) {
      throw new Exception($e->getMessage());
    } else {
      throw new Exception(__("Connection Failed, Please check your settings"));
    }
  }
}


/**
 * wasabi_upload
 * 
 * @param string $file_source
 * @param string $file_name
 * @param string $content_type
 * @return void
 */
function wasabi_upload($file_source, $file_name, $content_type = "")
{
  global $system;
  $s3Client = Aws\S3\S3Client::factory([
    'version'     => 'latest',
    'endpoint'    => 'https://s3.' . $system['wasabi_region'] . '.wasabisys.com',
    'region'      => $system['wasabi_region'],
    'credentials' => [
      'key'     => $system['wasabi_key'],
      'secret'  => $system['wasabi_secret'],
    ]
  ]);
  $Key = 'uploads/' . $file_name;
  $s3Client->putObject([
    'Bucket' => $system['wasabi_bucket'],
    'Key'    => $Key,
    'Body'   => fopen($file_source, 'r+'),
    'ContentDisposition' => 'inline',
    'ContentType' => $content_type,
    'ACL'    => 'public-read',
  ]);
  /* remove local file */
  gc_collect_cycles();
  if ($s3Client->doesObjectExist($system['wasabi_bucket'], $Key)) {
    unlink($file_source);
  }
}


/**
 * backblaze_test
 * 
 * @return void
 */
function backblaze_test()
{
  global $system;
  try {
    $s3Client = Aws\S3\S3Client::factory([
      'version'     => 'latest',
      'endpoint'    => 'https://s3.' . $system['backblaze_region'] . '.backblazeb2.com',
      'region'      => $system['backblaze_region'],
      'credentials' => [
        'key'     => $system['backblaze_key'],
        'secret'  => $system['backblaze_secret'],
      ]
    ]);
    $buckets = $s3Client->listBuckets();
    if (empty($buckets)) {
      throw new Exception(__("There is no buckets in your account"));
    }
    if (!$s3Client->doesBucketExist($system['backblaze_bucket'])) {
      throw new Exception(__("There is no bucket with this name in your account"));
    }
  } catch (Exception $e) {
    if (DEBUGGING) {
      throw new Exception($e->getMessage());
    } else {
      throw new Exception(__("Connection Failed, Please check your settings"));
    }
  }
}


/**
 * backblaze_upload
 * 
 * @param string $file_source
 * @param string $file_name
 * @param string $content_type
 * @return void
 */
function backblaze_upload($file_source, $file_name, $content_type = "")
{
  global $system;
  $s3Client = Aws\S3\S3Client::factory([
    'version'     => 'latest',
    'endpoint'    => 'https://s3.' . $system['backblaze_region'] . '.backblazeb2.com',
    'region'      => $system['backblaze_region'],
    'credentials' => [
      'key'     => $system['backblaze_key'],
      'secret'  => $system['backblaze_secret'],
    ]
  ]);
  $middleware = \Aws\Middleware::mapRequest(function (\Psr\Http\Message\RequestInterface $request) {
    foreach ($request->getHeaders() as $name => $values) {
      if (stripos($name, 'x-amz-checksum') === 0) {
        $request = $request->withoutHeader($name);
      }
    }
    return $request;
  });
  $s3Client->getHandlerList()->appendBuild($middleware, 'strip_checksum_headers');
  $Key = 'uploads/' . $file_name;
  $result = $s3Client->putObject([
    'Bucket' => $system['backblaze_bucket'],
    'Key'    => $Key,
    'Body'   => fopen($file_source, 'r+'),
    'ContentDisposition' => 'inline',
    'ContentType' => $content_type,
    'ACL'    => 'public-read',
  ]);
  /* remove local file */
  gc_collect_cycles();
  if ($s3Client->doesObjectExist($system['backblaze_bucket'], $Key)) {
    unlink($file_source);
  }
}


/**
 * yandex_cloud_test
 * 
 * @return void
 */
function yandex_cloud_test()
{
  global $system;
  try {
    $s3Client = Aws\S3\S3Client::factory(array(
      'version'     => 'latest',
      'endpoint'    => 'https://s3.yandexcloud.net/',
      'region'      => $system['yandex_cloud_region'],
      'credentials' => array(
        'key'     => $system['yandex_cloud_key'],
        'secret'  => $system['yandex_cloud_secret'],
      )
    ));
    $buckets = $s3Client->listBuckets();
    if (empty($buckets)) {
      throw new Exception(__("There is no buckets in your account"));
    }
    if (!$s3Client->doesBucketExist($system['yandex_cloud_bucket'])) {
      throw new Exception(__("There is no bucket with this name in your account"));
    }
  } catch (Exception $e) {
    if (DEBUGGING) {
      throw new Exception($e->getMessage());
    } else {
      throw new Exception(__("Connection Failed, Please check your settings"));
    }
  }
}


/**
 * yandex_cloud_upload
 * 
 * @param string $file_source
 * @param string $file_name
 * @param string $content_type
 * @return void
 */
function yandex_cloud_upload($file_source, $file_name, $content_type = "")
{
  global $system;
  $s3Client = Aws\S3\S3Client::factory(array(
    'version'     => 'latest',
    'endpoint'    => 'https://s3.yandexcloud.net/',
    'region'      => $system['yandex_cloud_region'],
    'credentials' => array(
      'key'     => $system['yandex_cloud_key'],
      'secret'  => $system['yandex_cloud_secret'],
    )
  ));
  $Key = 'uploads/' . $file_name;
  $s3Client->putObject([
    'Bucket' => $system['yandex_cloud_bucket'],
    'Key'    => $Key,
    'Body'   => fopen($file_source, 'r+'),
    'ContentDisposition' => 'inline',
    'ContentType' => $content_type,
    'ACL'    => 'public-read',
  ]);
  /* remove local file */
  gc_collect_cycles();
  if ($s3Client->doesObjectExist($system['yandex_cloud_bucket'], $Key)) {
    unlink($file_source);
  }
}


/**
 * cloudflare_r2_test
 * 
 * @return void
 */
function cloudflare_r2_test()
{
  global $system;
  try {
    $s3Client = Aws\S3\S3Client::factory([
      'version'     => 'latest',
      'endpoint'    => $system['cloudflare_r2_endpoint'],
      'region' => 'auto',
      'use_path_style_endpoint' => true,
      'use_aws_shared_config_files' => false,
      'credentials' => [
        'key'     => $system['cloudflare_r2_key'],
        'secret'  => $system['cloudflare_r2_secret'],
      ]
    ]);
    $buckets = $s3Client->listBuckets();
    if (empty($buckets)) {
      throw new Exception(__("There is no buckets in your account"));
    }
    if (!$s3Client->doesBucketExist($system['cloudflare_r2_bucket'])) {
      throw new Exception(__("There is no bucket with this name in your account"));
    }
  } catch (Exception $e) {
    if (DEBUGGING) {
      throw new Exception($e->getMessage());
    } else {
      throw new Exception(__("Connection Failed, Please check your settings"));
    }
  }
}


/**
 * cloudflare_r2_upload
 * 
 * @param string $file_source
 * @param string $file_name
 * @param string $content_type
 * @return void
 */
function cloudflare_r2_upload($file_source, $file_name, $content_type = "")
{
  global $system;
  $s3Client = Aws\S3\S3Client::factory([
    'version'     => 'latest',
    'endpoint'    => $system['cloudflare_r2_endpoint'],
    'region' => 'auto',
    'use_path_style_endpoint' => true,
    'use_aws_shared_config_files' => false,
    'credentials' => [
      'key'     => $system['cloudflare_r2_key'],
      'secret'  => $system['cloudflare_r2_secret'],
    ],
  ]);
  $Key = 'uploads/' . $file_name;
  $params = [
    'ContentDisposition' => 'inline',
  ];
  if ($content_type !== '') {
    $params['ContentType'] = $content_type;
  }
  $uploader = new Aws\S3\MultipartUploader($s3Client, $file_source, [
    'bucket' => $system['cloudflare_r2_bucket'],
    'key'    => $Key,
    'params' => $params,
  ]);
  $uploader->upload();
  /* remove local file */
  gc_collect_cycles();
  if ($s3Client->doesObjectExist($system['cloudflare_r2_bucket'], $Key)) {
    unlink($file_source);
  }
}


/**
 * ovh_s3_client
 * 
 * @return Aws\S3\S3Client
 */
function ovh_s3_client()
{
  global $system;
  return Aws\S3\S3Client::factory([
    'version'     => 'latest',
    'endpoint'    => 'https://s3.' . $system['ovh_region'] . '.io.cloud.ovh.net',
    'region'      => $system['ovh_region'],
    'use_path_style_endpoint' => true,
    'use_aws_shared_config_files' => false,
    'request_checksum_calculation' => 'when_required',
    'response_checksum_validation' => 'when_required',
    'credentials' => [
      'key'     => $system['ovh_key'],
      'secret'  => $system['ovh_secret'],
    ]
  ]);
}


/**
 * ovh_test
 * 
 * @return void
 */
function ovh_test()
{
  global $system;
  try {
    $s3Client = ovh_s3_client();
    $buckets = $s3Client->listBuckets();
    if (empty($buckets)) {
      throw new Exception(__("There is no buckets in your account"));
    }
    if (!$s3Client->doesBucketExist($system['ovh_bucket'])) {
      throw new Exception(__("There is no bucket with this name in your account"));
    }
  } catch (Exception $e) {
    if (DEBUGGING) {
      throw new Exception($e->getMessage());
    } else {
      throw new Exception(__("Connection Failed, Please check your settings"));
    }
  }
}


/**
 * ovh_upload
 * 
 * @param string $file_source
 * @param string $file_name
 * @param string $content_type
 * @return void
 */
function ovh_upload($file_source, $file_name, $content_type = "")
{
  global $system;
  $s3Client = ovh_s3_client();
  $Key = 'uploads/' . $file_name;
  $s3Client->putObject([
    'Bucket' => $system['ovh_bucket'],
    'Key'    => $Key,
    'Body'   => fopen($file_source, 'r+'),
    'ContentDisposition' => 'inline',
    'ContentType' => $content_type,
    'ACL'    => 'public-read',
  ]);
  /* remove local file */
  gc_collect_cycles();
  if ($s3Client->doesObjectExist($system['ovh_bucket'], $Key)) {
    unlink($file_source);
  }
}


/**
 * bunny_s3_client
 *
 * @return Aws\S3\S3Client
 */
function bunny_s3_client()
{
  global $system;
  return Aws\S3\S3Client::factory([
    'version'     => 'latest',
    'endpoint'    => 'https://' . $system['bunny_region'] . '-s3.storage.bunnycdn.com',
    'region'      => $system['bunny_region'],
    'use_path_style_endpoint' => true,
    'use_aws_shared_config_files' => false,
    'request_checksum_calculation' => 'when_required',
    'response_checksum_validation' => 'when_required',
    'credentials' => [
      'key'     => $system['bunny_zone'],
      'secret'  => $system['bunny_password'],
    ]
  ]);
}


/**
 * bunny_region_from_endpoint
 * 
 * @param string $endpoint
 * @return string
 */
function bunny_region_from_endpoint($endpoint)
{
  $endpoint = strtolower(trim($endpoint));
  if (preg_match('/^[a-z]{2,4}$/', $endpoint)) {
    return $endpoint;
  }
  if (!str_contains($endpoint, '://')) {
    $endpoint = 'https://' . $endpoint;
  }
  $host = (string) parse_url($endpoint, PHP_URL_HOST);
  if (preg_match('/^([a-z]{2,4})-s3\.storage\.bunnycdn\.com$/', $host, $matches)) {
    return $matches[1];
  }
  return '';
}


/**
 * bunny_is_pull_zone_url
 * 
 * @param string $url
 * @return boolean
 */
function bunny_is_pull_zone_url($url)
{
  $host = parse_url($url, PHP_URL_HOST);
  if (!filter_var($url, FILTER_VALIDATE_URL) || !in_array(parse_url($url, PHP_URL_SCHEME), ['http', 'https']) || !$host) {
    return false;
  }
  return !str_ends_with(strtolower($host), 'storage.bunnycdn.com');
}


/**
 * bunny_public_url
 * 
 * @param array $options
 * @return string
 */
function bunny_public_url($options = null)
{
  global $system;
  $options = $options ?? $system;
  if (!empty($options['bunny_url']) && bunny_is_pull_zone_url($options['bunny_url'])) {
    return rtrim($options['bunny_url'], '/');
  }
  return 'https://' . $options['bunny_zone'] . '.b-cdn.net';
}


/**
 * bunny_test
 * 
 * @return void
 */
function bunny_test()
{
  global $system;
  if (empty($system['bunny_zone']) || empty($system['bunny_password']) || empty($system['bunny_region'])) {
    throw new Exception(__("Please fill all the required fields"));
  }
  /* test storage */
  $Key = 'uploads/sngine-test-' . get_hash_key(8) . '.txt';
  try {
    $s3Client = bunny_s3_client();
    $s3Client->putObject([
      'Bucket' => $system['bunny_zone'],
      'Key'    => $Key,
      'Body'   => 'sngine',
      'ContentType' => 'text/plain',
    ]);
  } catch (Exception $e) {
    if (DEBUGGING) {
      throw new Exception($e->getMessage());
    } else {
      throw new Exception(__("Connection Failed, Please check your settings"));
    }
  }
  /* test pull zone */
  $public_url = bunny_public_url();
  $ch = curl_init($public_url . '/' . $Key);
  curl_setopt_array($ch, [
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_FOLLOWLOCATION => true,
    CURLOPT_CONNECTTIMEOUT => 10,
    CURLOPT_TIMEOUT => 20,
  ]);
  $body = curl_exec($ch);
  $status = curl_getinfo($ch, CURLINFO_HTTP_CODE);
  curl_close($ch);
  try {
    $s3Client->deleteObject([
      'Bucket' => $system['bunny_zone'],
      'Key'    => $Key,
    ]);
  } catch (Exception $e) {
  }
  if ($status != 200 || $body !== 'sngine') {
    throw new Exception(sprintf(__("Connected to your storage zone, but uploaded files are not public at %s. Create a Pull Zone connected to this storage zone and enter its URL"), $public_url));
  }
}


/**
 * bunny_upload
 *
 * @param string $file_source
 * @param string $file_name
 * @param string $content_type
 * @return void
 */
function bunny_upload($file_source, $file_name, $content_type = "")
{
  global $system;
  $s3Client = bunny_s3_client();
  $Key = 'uploads/' . $file_name;
  $params = [
    'Bucket' => $system['bunny_zone'],
    'Key'    => $Key,
    'Body'   => fopen($file_source, 'r+'),
    'ContentDisposition' => 'inline',
  ];
  if ($content_type !== '') {
    $params['ContentType'] = $content_type;
  }
  $s3Client->putObject($params);
  /* remove local file */
  gc_collect_cycles();
  if ($s3Client->doesObjectExist($system['bunny_zone'], $Key)) {
    unlink($file_source);
  }
}


/**
 * storj_s3_client
 * 
 * @return Aws\S3\S3Client
 */
function storj_s3_client()
{
  global $system;
  return Aws\S3\S3Client::factory([
    'version'     => 'latest',
    'endpoint'    => (!empty($system['storj_endpoint'])) ? $system['storj_endpoint'] : 'https://gateway.storjshare.io',
    'region'      => 'us-1',
    'use_path_style_endpoint' => true,
    'use_aws_shared_config_files' => false,
    'request_checksum_calculation' => 'when_required',
    'response_checksum_validation' => 'when_required',
    'credentials' => [
      'key'     => $system['storj_key'],
      'secret'  => $system['storj_secret'],
    ]
  ]);
}


/**
 * storj_public_url
 * 
 * @param string $url
 * @return string
 */
function storj_public_url($url)
{
  $url = trim((string) $url);
  if ($url !== '' && !preg_match('#^https?://#i', $url)) {
    $url = 'https://' . $url;
  }
  $host = strtolower((string) parse_url($url, PHP_URL_HOST));
  if (!filter_var($url, FILTER_VALIDATE_URL) || !in_array(parse_url($url, PHP_URL_SCHEME), ['http', 'https']) || !$host) {
    return '';
  }
  if (str_ends_with($host, 'storjshare.io')) {
    if (!str_starts_with($host, 'link.')) {
      return '';
    }
    $path = array_values(array_filter(explode('/', (string) parse_url($url, PHP_URL_PATH)), 'strlen'));
    if (count($path) < 3 || !in_array($path[0], ['s', 'raw'])) {
      return '';
    }
    return 'https://' . $host . '/raw/' . $path[1] . '/' . $path[2];
  }
  return rtrim(strtok($url, '?#'), '/');
}


/**
 * storj_test
 * 
 * @return void
 */
function storj_test()
{
  global $system;
  if (empty($system['storj_bucket']) || empty($system['storj_key']) || empty($system['storj_secret'])) {
    throw new Exception(__("Please fill all the required fields"));
  }
  $public_url = storj_public_url($system['storj_url']);
  if (!$public_url) {
    throw new Exception(__("Please enter your Storj share link or custom domain"));
  }
  /* test storage */
  $Key = 'uploads/sngine-test-' . get_hash_key(8) . '.txt';
  try {
    $s3Client = storj_s3_client();
    $s3Client->putObject([
      'Bucket' => $system['storj_bucket'],
      'Key'    => $Key,
      'Body'   => 'sngine',
      'ContentType' => 'text/plain',
    ]);
  } catch (Exception $e) {
    if (DEBUGGING) {
      throw new Exception($e->getMessage());
    } else {
      throw new Exception(__("Connection Failed, Please check your settings"));
    }
  }
  /* test public link */
  $ch = curl_init($public_url . '/' . $Key);
  curl_setopt_array($ch, [
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_FOLLOWLOCATION => true,
    CURLOPT_CONNECTTIMEOUT => 10,
    CURLOPT_TIMEOUT => 20,
  ]);
  $body = curl_exec($ch);
  $status = curl_getinfo($ch, CURLINFO_HTTP_CODE);
  curl_close($ch);
  try {
    $s3Client->deleteObject([
      'Bucket' => $system['storj_bucket'],
      'Key'    => $Key,
    ]);
  } catch (Exception $e) {
  }
  if ($status != 200 || $body !== 'sngine') {
    throw new Exception(sprintf(__("Connected to your bucket, but uploaded files are not public at %s. Share the bucket from the Storj console and paste its link"), $public_url));
  }
}


/**
 * storj_upload
 * 
 * @param string $file_source
 * @param string $file_name
 * @param string $content_type
 * @return void
 */
function storj_upload($file_source, $file_name, $content_type = "")
{
  global $system;
  $s3Client = storj_s3_client();
  $Key = 'uploads/' . $file_name;
  $params = [
    'Bucket' => $system['storj_bucket'],
    'Key'    => $Key,
    'Body'   => fopen($file_source, 'r+'),
    'ContentDisposition' => 'inline',
  ];
  if ($content_type !== '') {
    $params['ContentType'] = $content_type;
  }
  $s3Client->putObject($params);
  /* remove local file */
  gc_collect_cycles();
  if ($s3Client->doesObjectExist($system['storj_bucket'], $Key)) {
    unlink($file_source);
  }
}


/**
 * pushr_test
 * 
 * @return void
 */
function pushr_test()
{
  global $system;
  try {
    $s3Client = Aws\S3\S3Client::factory([
      'version'     => 'latest',
      'endpoint'    => $system['pushr_endpoint'],
      'region' => 'auto',
      'credentials' => [
        'key'     => $system['pushr_key'],
        'secret'  => $system['pushr_secret'],
      ]
    ]);
    $buckets = $s3Client->listBuckets();
    if (empty($buckets)) {
      throw new Exception(__("There is no buckets in your account"));
    }
    if (!$s3Client->doesBucketExist($system['pushr_bucket'])) {
      throw new Exception(__("There is no bucket with this name in your account"));
    }
  } catch (Exception $e) {
    if (DEBUGGING) {
      throw new Exception($e->getMessage());
    } else {
      throw new Exception(__("Connection Failed, Please check your settings"));
    }
  }
}


/**
 * pushr_upload
 * 
 * @param string $file_source
 * @param string $file_name
 * @param string $content_type
 * @return void
 */

function pushr_upload($file_source, $file_name, $content_type = "")
{
  global $system;
  $s3Client = Aws\S3\S3Client::factory([
    'version'     => 'latest',
    'endpoint'    => $system['pushr_endpoint'],
    'region' => 'auto',
    'credentials' => [
      'key'     => $system['pushr_key'],
      'secret'  => $system['pushr_secret'],
    ]
  ]);
  $Key = 'uploads/' . $file_name;
  $s3Client->putObject([
    'Bucket' => $system['pushr_bucket'],
    'Key'    => $Key,
    'Body'   => fopen($file_source, 'r+'),
    'ContentDisposition' => 'inline',
    'ContentType' => $content_type,
    'ACL'    => 'public-read',
  ]);
  /* remove local file */
  gc_collect_cycles();
  if ($s3Client->doesObjectExist($system['pushr_bucket'], $Key)) {
    unlink($file_source);
  }
}


/**
 * ftp_test
 * 
 * @return void
 */
function ftp_test()
{
  global $system;
  try {
    $ftp = new \FtpClient\FtpClient();
    $ftp->connect($system['ftp_hostname'], false, $system['ftp_port']);
    $ftp->login($system['ftp_username'], $system['ftp_password']);
  } catch (Exception $e) {
    if (DEBUGGING) {
      throw new Exception($e->getMessage());
    } else {
      throw new Exception(__("Connection Failed, Please check your settings"));
    }
  }
}


/**
 * ftp_upload
 * 
 * @param string $file_source
 * @param string $file_name
 * @return void
 */
function ftp_upload($file_source, $file_name)
{
  global $system;
  $ftp = new \FtpClient\FtpClient();
  $ftp->connect($system['ftp_hostname'], false, $system['ftp_port']);
  $ftp->login($system['ftp_username'], $system['ftp_password']);
  if (!empty($system['ftp_path']) && $system['ftp_path'] != "./") {
    $ftp->chdir($system['ftp_path']);
  }
  $file_path = substr($file_name, 0, strrpos($file_name, '/'));
  $ftp_path_info = explode('/', $file_path);
  $ftp_path = '';
  if (!$ftp->isDir($file_path)) {
    foreach ($ftp_path_info as $key => $value) {
      if (!empty($ftp_path)) {
        $ftp_path .= '/' . $value . '/';
      } else {
        $ftp_path .= $value . '/';
      }
      if (!$ftp->isDir($ftp_path)) {
        $mkdir = $ftp->mkdir($ftp_path);
      }
    }
  }
  $ftp->chdir($file_path);
  $ftp->pasv(true);
  if ($ftp->putFromPath($file_source, $file_name)) {
    unlink($file_source);
  }
  $ftp->close();
}


/**
 * is_valid_upload_source
 * 
 * @param mixed $source
 * @return bool
 */
function is_valid_upload_source($source)
{
  if (!is_string($source) || $source === '') {
    return false;
  }
  if (str_contains($source, '..') || str_contains($source, "\0")) {
    return false;
  }
  if ($source[0] === '/' || str_contains($source, '\\')) {
    return false;
  }
  return (bool) preg_match(
    '#^(files|photos|sounds|videos)/\d{4}/\d{2}/[A-Za-z0-9._-]+\.[A-Za-z0-9]+$#',
    $source
  );
}


/**
 * delete_uploads_file
 * 
 * @param string $file_name
 * @param bool $bypass_db_check
 * @param int $user_id
 * @return void
 */
function delete_uploads_file($file_name, $bypass_db_check = true, $user_id = null)
{
  global $system, $db, $user;
  $user_id = ($user_id) ? $user_id : $user->_data['user_id'];
  if (!$file_name) {
    return;
  }
  /* delete from pending uploads */
  remove_pending_uploads([$file_name], $user_id);
  /* delete from database */
  $db->query(sprintf("DELETE FROM users_uploads WHERE file_name = %s", secure($file_name)));
  /* delete from server */
  if ($system['s3_enabled']) {
    /* Amazon S3 */
    $s3Client = Aws\S3\S3Client::factory([
      'version'    => 'latest',
      'region'      => $system['s3_region'],
      'credentials' => [
        'key'    => $system['s3_key'],
        'secret' => $system['s3_secret'],
      ]
    ]);
    $Key = 'uploads/' . $file_name;
    if ($s3Client->doesObjectExist($system['s3_bucket'], $Key)) {
      $s3Client->deleteObject([
        'Bucket' => $system['s3_bucket'],
        'Key'    => $Key,
      ]);
    }
  } elseif ($system['google_cloud_enabled']) {
    /* Google Cloud */
    $storage = new Google\Cloud\Storage\StorageClient([
      'keyFile' => json_decode(html_entity_decode($system['google_cloud_file'], ENT_QUOTES), true),
    ]);
    $bucket = $storage->bucket($system['google_cloud_bucket']);
    $Key = 'uploads/' . $file_name;
    $object = $bucket->object($Key);
    if ($object->exists()) {
      $object->delete();
    }
  } elseif ($system['digitalocean_enabled']) {
    /* DigitalOcean */
    $s3Client = Aws\S3\S3Client::factory([
      'version'     => 'latest',
      'endpoint'    => 'https://' . $system['digitalocean_space_region'] . '.digitaloceanspaces.com',
      'region'      => $system['digitalocean_space_region'],
      'credentials' => [
        'key'     => $system['digitalocean_key'],
        'secret'  => $system['digitalocean_secret'],
      ]
    ]);
    $Key = 'uploads/' . $file_name;
    if ($s3Client->doesObjectExist($system['digitalocean_space_name'], $Key)) {
      $s3Client->deleteObject([
        'Bucket' => $system['digitalocean_space_name'],
        'Key'    => $Key,
      ]);
    }
  } elseif ($system['wasabi_enabled']) {
    /* Wasabi */
    $s3Client = Aws\S3\S3Client::factory([
      'version'     => 'latest',
      'endpoint'    => 'https://s3.' . $system['wasabi_region'] . '.wasabisys.com',
      'region'      => $system['wasabi_region'],
      'credentials' => [
        'key'     => $system['wasabi_key'],
        'secret'  => $system['wasabi_secret'],
      ]
    ]);
    $Key = 'uploads/' . $file_name;
    if ($s3Client->doesObjectExist($system['wasabi_bucket'], $Key)) {
      $s3Client->deleteObject([
        'Bucket' => $system['wasabi_bucket'],
        'Key'    => $Key,
      ]);
    }
  } elseif ($system['backblaze_enabled']) {
    /* Backblaze */
    $s3Client = Aws\S3\S3Client::factory([
      'version'     => 'latest',
      'endpoint'    => 'https://s3.' . $system['backblaze_region'] . '.backblazeb2.com',
      'region'      => $system['backblaze_region'],
      'credentials' => [
        'key'     => $system['backblaze_key'],
        'secret'  => $system['backblaze_secret'],
      ]
    ]);
    $Key = 'uploads/' . $file_name;
    if ($s3Client->doesObjectExist($system['backblaze_bucket'], $Key)) {
      $s3Client->deleteObject([
        'Bucket' => $system['backblaze_bucket'],
        'Key'    => $Key,
        'DeleteMarker' => 'true'
      ]);
    }
  } elseif ($system['yandex_cloud_enabled']) {
    /* Yandex Cloud */
    $s3Client = Aws\S3\S3Client::factory(array(
      'version'     => 'latest',
      'endpoint'    => 'https://s3.yandexcloud.net/',
      'region'      => $system['yandex_cloud_region'],
      'credentials' => array(
        'key'     => $system['yandex_cloud_key'],
        'secret'  => $system['yandex_cloud_secret'],
      )
    ));
    $Key = 'uploads/' . $file_name;
    if ($s3Client->doesObjectExist($system['yandex_cloud_bucket'], $Key)) {
      $s3Client->deleteObject([
        'Bucket' => $system['yandex_cloud_bucket'],
        'Key'    => $Key,
      ]);
    }
  } elseif ($system['cloudflare_r2_enabled']) {
    /* Cloudflare R2 */
    $s3Client = Aws\S3\S3Client::factory([
      'version'     => 'latest',
      'endpoint'    => $system['cloudflare_r2_endpoint'],
      'region' => 'auto',
      'use_path_style_endpoint' => true,
      'use_aws_shared_config_files' => false,
      'credentials' => [
        'key'     => $system['cloudflare_r2_key'],
        'secret'  => $system['cloudflare_r2_secret'],
      ]
    ]);
    $Key = 'uploads/' . $file_name;
    $s3Client->deleteObject([
      'Bucket' => $system['cloudflare_r2_bucket'],
      'Key'    => $Key,
    ]);
  } elseif ($system['pushr_enabled']) {
    /* Pushr */
    $s3Client = Aws\S3\S3Client::factory([
      'version'     => 'latest',
      'endpoint'    => $system['pushr_endpoint'],
      'region' => 'auto',
      'credentials' => [
        'key'     => $system['pushr_key'],
        'secret'  => $system['pushr_secret'],
      ]
    ]);
    $Key = 'uploads/' . $file_name;
    if ($s3Client->doesObjectExist($system['pushr_bucket'], $Key)) {
      $s3Client->deleteObject([
        'Bucket' => $system['pushr_bucket'],
        'Key'    => $Key,
      ]);
    }
  } elseif ($system['ovh_enabled']) {
    /* OVH Object Storage */
    $s3Client = ovh_s3_client();
    $Key = 'uploads/' . $file_name;
    if ($s3Client->doesObjectExist($system['ovh_bucket'], $Key)) {
      $s3Client->deleteObject([
        'Bucket' => $system['ovh_bucket'],
        'Key'    => $Key,
      ]);
    }
  } elseif ($system['bunny_enabled']) {
    /* Bunny Storage */
    $s3Client = bunny_s3_client();
    $Key = 'uploads/' . $file_name;
    if ($s3Client->doesObjectExist($system['bunny_zone'], $Key)) {
      $s3Client->deleteObject([
        'Bucket' => $system['bunny_zone'],
        'Key'    => $Key,
      ]);
    }
  } elseif ($system['storj_enabled']) {
    /* Storj */
    $s3Client = storj_s3_client();
    $Key = 'uploads/' . $file_name;
    if ($s3Client->doesObjectExist($system['storj_bucket'], $Key)) {
      $s3Client->deleteObject([
        'Bucket' => $system['storj_bucket'],
        'Key'    => $Key,
      ]);
    }
  } elseif ($system['ftp_enabled']) {
    /* FTP */
    $ftp = new \FtpClient\FtpClient();
    $ftp->connect($system['ftp_hostname'], false, $system['ftp_port']);
    $ftp->login($system['ftp_username'], $system['ftp_password']);
    if (!empty($system['ftp_path']) && $system['ftp_path'] != "./") {
      $ftp->chdir($system['ftp_path']);
    }
    $file_path = substr($file_name, 0, strrpos($file_name, '/'));
    $file_name = substr($file_name, strrpos($file_name, '/') + 1);
    if (!$ftp->isDir($file_path)) {
      return;
    }
    $ftp->chdir($file_path);
    $ftp->pasv(true);
    $ftp->remove($file_name);
    $ftp->close();
  } else {
    /* local server */
    if (str_contains($file_name, '..') || str_contains($file_name, "\0") || $file_name[0] === '/' || str_contains($file_name, '\\')) {
      return;
    }
    $base = realpath(ABSPATH . $system['uploads_directory']);
    $realpath = realpath(ABSPATH . $system['uploads_directory'] . '/' . $file_name);
    if ($base && $realpath && str_starts_with($realpath, $base . DIRECTORY_SEPARATOR) && is_file($realpath)) {
      unlink($realpath);
    }
  }
}


/**
 * save_file_to_cloud
 * 
 * @param string $path
 * @param string $file_name
 * @return void
 */

function save_file_to_cloud($path, $file_name)
{
  global $system;
  /* Cloud Storage */
  $content_type = (is_file($path)) ? (string) mime_content_type($path) : "";
  if ($system['s3_enabled']) {
    /* Amazon S3 */
    aws_s3_upload($path, $file_name, $content_type);
  } elseif ($system['google_cloud_enabled']) {
    /* Google Cloud */
    google_cloud_upload($path, $file_name, $content_type);
  } elseif ($system['digitalocean_enabled']) {
    /* DigitalOcean */
    digitalocean_space_upload($path, $file_name, $content_type);
  } elseif ($system['wasabi_enabled']) {
    /* Wasabi */
    wasabi_upload($path, $file_name, $content_type);
  } elseif ($system['backblaze_enabled']) {
    /* Backblaze */
    backblaze_upload($path, $file_name, $content_type);
  } elseif ($system['yandex_cloud_enabled']) {
    /* Yandex Cloud */
    yandex_cloud_upload($path, $file_name, $content_type);
  } elseif ($system['cloudflare_r2_enabled']) {
    /* Cloudflare R2 */
    cloudflare_r2_upload($path, $file_name, $content_type);
  } elseif ($system['pushr_enabled']) {
    /* Pushr */
    pushr_upload($path, $file_name, $content_type);
  } elseif ($system['ovh_enabled']) {
    /* OVH Object Storage */
    ovh_upload($path, $file_name, $content_type);
  } elseif ($system['bunny_enabled']) {
    /* Bunny Storage */
    bunny_upload($path, $file_name, $content_type);
  } elseif ($system['storj_enabled']) {
    /* Storj */
    storj_upload($path, $file_name, $content_type);
  } elseif ($system['ftp_enabled']) {
    /* FTP */
    ftp_upload($path, $file_name);
  }
}
