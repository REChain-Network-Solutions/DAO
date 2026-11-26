<?php

/**
 * functions -> ffmpeg
 * 
 * @package Sngine
 * @author Zamblek
 */

/* ------------------------------- */
/* FFMPEG */
/* ------------------------------- */

/**
 * ffmpeg_test
 * 
 * @return string
 */

function ffmpeg_test()
{
  global $system;
  /* check ffmpeg settings */
  if (!function_exists('shell_exec')) {
    throw new Exception(__("shell_exec function must be enabled for FFMPEG"));
  }
  if (!$system['ffmpeg_enabled']) {
    throw new Exception(__("FFMPEG must be enable before testing"));
  }
  if ($system['ffmpeg_path'] == "") {
    throw new Exception(__("FFMPEG path must be defined before testing"));
  }
  /* prepare */
  $input_video = ABSPATH . "includes/assets/videos/ffmpeg_test.mp4";
  $output_video = ABSPATH . "includes/assets/videos/ffmpeg_test_240.mp4";
  @unlink($output_video);
  $shell_response = shell_exec($system['ffmpeg_path'] . " -y -i $input_video -vcodec libx264 -preset " . $system['ffmpeg_speed'] . " -filter:v scale=426:-2 -crf 26 -pix_fmt yuv420p -c:a copy -movflags +faststart $output_video 2>&1");
  if (!file_exists($output_video)) {
    throw new Exception(__("FFMPEG Error") . ": " . $shell_response);
  }
  return $shell_response;
}

/**
 * ffmpeg_convert
 * 
 * @param integer $post_id
 * @param integer $post_author_id
 * @param string $video_name
 * @param string $thumbnail
 * @param string $post_type
 * @return void
 */

function ffmpeg_convert($post_id, $post_author_id, $video_name, $thumbnail = '', $post_type = 'video')
{
  global $system, $db, $user;
  /* check ffmpeg settings */
  if (!function_exists('shell_exec')) {
    throw new Exception(__("shell_exec function must be enabled for FFMPEG"));
  }
  if (!$system['ffmpeg_enabled']) {
    throw new Exception(__("FFMPEG must be enable before testing"));
  }
  if ($system['ffmpeg_path'] == "") {
    throw new Exception(__("FFMPEG path must be defined before testing"));
  }
  /* prepare posts table name */
  $posts_table = ($post_type == 'reel') ? 'posts_reels' : 'posts_videos';
  /* prepare uploads folder as staging */
  $photos_folder = 'photos';
  $photos_directory = $photos_folder . '/' . date('Y') . '/' . date('m') . '/';
  if (!file_exists(ABSPATH . $system['uploads_directory'] . '/' . $photos_folder)) {
    @mkdir(ABSPATH . $system['uploads_directory'] . '/' . $photos_folder, 0777, true);
  }
  if (!file_exists(ABSPATH . $system['uploads_directory'] . '/' . $photos_folder . '/' . date('Y'))) {
    @mkdir(ABSPATH . $system['uploads_directory'] . '/' . $photos_folder . '/' . date('Y'), 0777, true);
  }
  if (!file_exists($system['uploads_directory'] . '/' . $photos_folder . '/' . date('Y') . '/' . date('m'))) {
    @mkdir(ABSPATH . $system['uploads_directory'] . '/' . $photos_folder . '/' . date('Y') . '/' . date('m'), 0777, true);
  }
  $videos_folder = 'videos';
  $videos_directory = $videos_folder . '/' . date('Y') . '/' . date('m') . '/';
  if (!file_exists(ABSPATH . $system['uploads_directory'] . '/' . $videos_folder)) {
    @mkdir(ABSPATH . $system['uploads_directory'] . '/' . $videos_folder, 0777, true);
  }
  if (!file_exists(ABSPATH . $system['uploads_directory'] . '/' . $videos_folder . '/' . date('Y'))) {
    @mkdir(ABSPATH . $system['uploads_directory'] . '/' . $videos_folder . '/' . date('Y'), 0777, true);
  }
  if (!file_exists($system['uploads_directory'] . '/' . $videos_folder . '/' . date('Y') . '/' . date('m'))) {
    @mkdir(ABSPATH . $system['uploads_directory'] . '/' . $videos_folder . '/' . date('Y') . '/' . date('m'), 0777, true);
  }
  /* save original video */
  $original_video_local_path = ABSPATH . $system['uploads_directory'] . '/' . $video_name;
  $delete_fetched_file = false;
  if (!file_exists($original_video_local_path)) {
    $delete_fetched_file = true;
    $remote_file = fopen($system['system_uploads'] . '/' . $video_name, 'rb');
    $local_file = fopen($original_video_local_path, 'wb');
    if ($remote_file && $local_file) {
      while (!feof($remote_file)) {
        fwrite($local_file, fread($remote_file, 8192));
      }
      fclose($remote_file);
      fclose($local_file);
    } else {
      /* update post & return */
      $db->query(sprintf("UPDATE posts SET processing = '0' WHERE post_id = %s", secure($post_id, 'int')));
      return;
    }
  }
  /* set ffprobe_path */
  $system['ffprobe_path'] = substr_replace($system['ffmpeg_path'], 'ffprobe', strrpos($system['ffmpeg_path'], 'ffmpeg'), strlen('ffmpeg'));
  /* get original video resolution */
  $resolution = 0;
  $video_dimensions = json_decode((string) shell_exec($system['ffprobe_path'] . " -v error -select_streams v:0 -show_entries stream=width,height -of json " . escapeshellarg($original_video_local_path)), true);
  $video_width = $video_dimensions['streams'][0]['width'] ?? 0;
  $video_height = $video_dimensions['streams'][0]['height'] ?? 0;
  if (is_int($video_width) && $video_width > 0 && is_int($video_height) && $video_height > 0) {
    $resolution = max($video_width, $video_height);
  }
  /* get original video duration */
  $duration = 1;
  $duration = shell_exec($system['ffprobe_path'] . " -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 " . $original_video_local_path);
  /* generate new video thumbnail */
  if (!$thumbnail) {
    $thumbnail_prefix = $system['uploads_prefix'] . '_' . get_hash_token();
    $thumbnail_name = $photos_directory . $thumbnail_prefix . '.jpeg';
    $thumbnail_path = ABSPATH . $system['uploads_directory'] . '/' . $thumbnail_name;
    $extraction_time = ($duration > 1) ? ($duration / 2) : 1;
    if (!file_exists($thumbnail_path)) {
      shell_exec($system['ffmpeg_path'] . " -ss \"$extraction_time\" -i $original_video_local_path -vframes 1 -f mjpeg $thumbnail_path 2<&1");
      /* save the new video thumbnail to cloud */
      save_file_to_cloud($thumbnail_path, $thumbnail_name);
      /* update video thumbnail */
      $db->query(sprintf("UPDATE $posts_table SET thumbnail = %s WHERE post_id = %s", secure($thumbnail_name), secure($post_id, 'int')));
    }
  }
  /* get original hash */
  $original_hash = extarct_hash_token($video_name);
  /* set video prefix */
  $video_prefix = $system['uploads_prefix'] . '_' . $original_hash;
  /* check watermark videos enabled */
  $watermark_cmd = "";
  if ($system['watermark_videos_enabled']) {
    /* get water mark settings */
    $watermark_videos_icon = ABSPATH . $system['uploads_directory'] . '/' . $system['watermark_videos_icon'];
    /* check if the watermark icon exists */
    if (!file_exists($watermark_videos_icon)) {
      /* fetch the watermark icon */
      $remote_watermark_icon = fopen($system['system_uploads'] . '/' . $system['watermark_videos_icon'], 'rb');
      $local_watermark_icon = fopen($watermark_videos_icon, 'wb');
      if ($remote_watermark_icon && $local_watermark_icon) {
        while (!feof($remote_watermark_icon)) {
          fwrite($local_watermark_icon, fread($remote_watermark_icon, 8192));
        }
        fclose($remote_watermark_icon);
        fclose($local_watermark_icon);
      }
    }
    $watermark_videos_position = sprintf("(main_w-overlay_w)*%.2F:(main_h-overlay_h)*%.2F", get_watermark_percent($system['watermark_videos_x'] ?? null, 50) / 100, get_watermark_percent($system['watermark_videos_y'] ?? null, 50) / 100);
    $watermark_cmd = sprintf("-i %s -i %s -filter_complex \"[1:v]scale=iw:ih [watermark]; [watermark]format=argb,colorchannelmixer=aa=%s [watermark]; [0:v][watermark] overlay=%s\" -c:a copy", $watermark_videos_icon, $original_video_local_path, get_watermark_opacity($system['watermark_videos_opacity']), $watermark_videos_position);
  }
  /* convert video to 240p */
  $video_240p_name = $videos_directory . $video_prefix . '_240p.mp4';
  $video_240_local_path = ABSPATH . $system['uploads_directory'] . '/' . $video_240p_name;
  if ($system['ffmpeg_240p_enabled'] && !file_exists($video_240_local_path) && $resolution >= 426) {
    shell_exec($system['ffmpeg_path'] . " -y -i $original_video_local_path -vcodec libx264 -preset " . $system['ffmpeg_speed'] . " -filter:v \"scale='if(gte(iw,ih),426,-2)':'if(gte(iw,ih),-2,426)'\" -crf 26 -pix_fmt yuv420p -c:a copy -movflags +faststart $video_240_local_path 2>&1");
    if ($watermark_cmd) {
      $video_240p_marked_name = $videos_directory . $video_prefix . '_marked_240p.mp4';
      $video_240_marked_local_path = ABSPATH . $system['uploads_directory'] . '/' . $video_240p_marked_name;
      shell_exec($system['ffmpeg_path'] . " -y -i $video_240_local_path $watermark_cmd $video_240_marked_local_path 2<&1");
      if (file_exists($video_240_marked_local_path)) {
        /* remove local file */
        unlink($video_240_local_path);
        $video_240p_name = $video_240p_marked_name;
        $video_240_local_path = $video_240_marked_local_path;
      }
    }
    /* only upload & record if ffmpeg actually produced a valid (non-empty) file */
    if (file_exists($video_240_local_path) && filesize($video_240_local_path) > 0) {
      /* save the new video to cloud */
      save_file_to_cloud($video_240_local_path, $video_240p_name);
      /* update video */
      $db->query(sprintf("UPDATE $posts_table SET source_240p = %s WHERE post_id = %s", secure($video_240p_name), secure($post_id, 'int')));
    } else {
      @unlink($video_240_local_path);
    }
  }
  /* convert video to 360p */
  $video_360p_name = $videos_directory . $video_prefix . '_360p.mp4';
  $video_360_local_path = ABSPATH . $system['uploads_directory'] . '/' . $video_360p_name;
  if ($system['ffmpeg_360p_enabled'] && !file_exists($video_360_local_path) && $resolution >= 640) {
    shell_exec($system['ffmpeg_path'] . " -y -i $original_video_local_path -vcodec libx264 -preset " . $system['ffmpeg_speed'] . " -filter:v \"scale='if(gte(iw,ih),640,-2)':'if(gte(iw,ih),-2,640)'\" -crf 26 -pix_fmt yuv420p -c:a copy -movflags +faststart $video_360_local_path 2>&1");
    if ($watermark_cmd) {
      $video_360p_marked_name = $videos_directory . $video_prefix . '_marked_360p.mp4';
      $video_360_marked_local_path = ABSPATH . $system['uploads_directory'] . '/' . $video_360p_marked_name;
      shell_exec($system['ffmpeg_path'] . " -y -i $video_360_local_path $watermark_cmd $video_360_marked_local_path 2<&1");
      if (file_exists($video_360_marked_local_path)) {
        /* remove local file */
        unlink($video_360_local_path);
        $video_360p_name = $video_360p_marked_name;
        $video_360_local_path = $video_360_marked_local_path;
      }
    }
    /* only upload & record if ffmpeg actually produced a valid (non-empty) file */
    if (file_exists($video_360_local_path) && filesize($video_360_local_path) > 0) {
      /* save the new video to cloud */
      save_file_to_cloud($video_360_local_path, $video_360p_name);
      /* update video */
      $db->query(sprintf("UPDATE $posts_table SET source_360p = %s WHERE post_id = %s", secure($video_360p_name), secure($post_id, 'int')));
    } else {
      @unlink($video_360_local_path);
    }
  }
  /* convert video to 480p */
  $video_480p_name = $videos_directory . $video_prefix . '_480p.mp4';
  $video_480_local_path = ABSPATH . $system['uploads_directory'] . '/' . $video_480p_name;
  if ($system['ffmpeg_480p_enabled'] && !file_exists($video_480_local_path) && $resolution >= 854) {
    shell_exec($system['ffmpeg_path'] . " -y -i $original_video_local_path -vcodec libx264 -preset " . $system['ffmpeg_speed'] . " -filter:v \"scale='if(gte(iw,ih),854,-2)':'if(gte(iw,ih),-2,854)'\" -crf 26 -pix_fmt yuv420p -c:a copy -movflags +faststart $video_480_local_path 2>&1");
    if ($watermark_cmd) {
      $video_480p_marked_name = $videos_directory . $video_prefix . '_marked_480p.mp4';
      $video_480_marked_local_path = ABSPATH . $system['uploads_directory'] . '/' . $video_480p_marked_name;
      shell_exec($system['ffmpeg_path'] . " -y -i $video_480_local_path $watermark_cmd $video_480_marked_local_path 2<&1");
      if (file_exists($video_480_marked_local_path)) {
        /* remove local file */
        unlink($video_480_local_path);
        $video_480p_name = $video_480p_marked_name;
        $video_480_local_path = $video_480_marked_local_path;
      }
    }
    /* only upload & record if ffmpeg actually produced a valid (non-empty) file */
    if (file_exists($video_480_local_path) && filesize($video_480_local_path) > 0) {
      /* save the new video to cloud */
      save_file_to_cloud($video_480_local_path, $video_480p_name);
      /* update video */
      $db->query(sprintf("UPDATE $posts_table SET source_480p = %s WHERE post_id = %s", secure($video_480p_name), secure($post_id, 'int')));
    } else {
      @unlink($video_480_local_path);
    }
  }
  /* convert video to 720p */
  $video_720p_name = $videos_directory . $video_prefix . '_720p.mp4';
  $video_720_local_path = ABSPATH . $system['uploads_directory'] . '/' . $video_720p_name;
  if ($system['ffmpeg_720p_enabled'] && !file_exists($video_720_local_path) && $resolution >= 1280) {
    shell_exec($system['ffmpeg_path'] . " -y -i $original_video_local_path -vcodec libx264 -preset " . $system['ffmpeg_speed'] . " -filter:v \"scale='if(gte(iw,ih),1280,-2)':'if(gte(iw,ih),-2,1280)'\" -crf 26 -pix_fmt yuv420p -c:a copy -movflags +faststart $video_720_local_path 2>&1");
    if ($watermark_cmd) {
      $video_720p_marked_name = $videos_directory . $video_prefix . '_marked_720p.mp4';
      $video_720_marked_local_path = ABSPATH . $system['uploads_directory'] . '/' . $video_720p_marked_name;
      shell_exec($system['ffmpeg_path'] . " -y -i $video_720_local_path $watermark_cmd $video_720_marked_local_path 2<&1");
      if (file_exists($video_720_marked_local_path)) {
        /* remove local file */
        unlink($video_720_local_path);
        $video_720p_name = $video_720p_marked_name;
        $video_720_local_path = $video_720_marked_local_path;
      }
    }
    /* only upload & record if ffmpeg actually produced a valid (non-empty) file */
    if (file_exists($video_720_local_path) && filesize($video_720_local_path) > 0) {
      /* save the new video to cloud */
      save_file_to_cloud($video_720_local_path, $video_720p_name);
      /* update video */
      $db->query(sprintf("UPDATE $posts_table SET source_720p = %s WHERE post_id = %s", secure($video_720p_name), secure($post_id, 'int')));
    } else {
      @unlink($video_720_local_path);
    }
  }
  /* convert video to 1080p */
  $video_1080p_name = $videos_directory . $video_prefix . '_1080p.mp4';
  $video_1080_local_path = ABSPATH . $system['uploads_directory'] . '/' . $video_1080p_name;
  if ($system['ffmpeg_1080p_enabled'] && !file_exists($video_1080_local_path) && $resolution >= 1920) {
    shell_exec($system['ffmpeg_path'] . " -y -i $original_video_local_path -vcodec libx264 -preset " . $system['ffmpeg_speed'] . " -filter:v \"scale='if(gte(iw,ih),1920,-2)':'if(gte(iw,ih),-2,1920)'\" -crf 26 -pix_fmt yuv420p -c:a copy -movflags +faststart $video_1080_local_path 2>&1");
    if ($watermark_cmd) {
      $video_1080p_marked_name = $videos_directory . $video_prefix . '_marked_1080p.mp4';
      $video_1080_marked_local_path = ABSPATH . $system['uploads_directory'] . '/' . $video_1080p_marked_name;
      shell_exec($system['ffmpeg_path'] . " -y -i $video_1080_local_path $watermark_cmd $video_1080_marked_local_path 2<&1");
      if (file_exists($video_1080_marked_local_path)) {
        /* remove local file */
        unlink($video_1080_local_path);
        $video_1080p_name = $video_1080p_marked_name;
        $video_1080_local_path = $video_1080_marked_local_path;
      }
    }
    /* only upload & record if ffmpeg actually produced a valid (non-empty) file */
    if (file_exists($video_1080_local_path) && filesize($video_1080_local_path) > 0) {
      /* save the new video to cloud */
      save_file_to_cloud($video_1080_local_path, $video_1080p_name);
      /* update video */
      $db->query(sprintf("UPDATE $posts_table SET source_1080p = %s WHERE post_id = %s", secure($video_1080p_name), secure($post_id, 'int')));
    } else {
      @unlink($video_1080_local_path);
    }
  }
  /* convert video to 1440p */
  $video_1440p_name = $videos_directory . $video_prefix . '_1440p.mp4';
  $video_1440_local_path = ABSPATH . $system['uploads_directory'] . '/' . $video_1440p_name;
  if ($post_type != 'reel' && $system['ffmpeg_1440p_enabled'] && !file_exists($video_1440_local_path) && $resolution >= 2560) {
    shell_exec($system['ffmpeg_path'] . " -y -i $original_video_local_path -vcodec libx264 -preset " . $system['ffmpeg_speed'] . " -filter:v \"scale='if(gte(iw,ih),2560,-2)':'if(gte(iw,ih),-2,2560)'\" -crf 26 -pix_fmt yuv420p -c:a copy -movflags +faststart $video_1440_local_path 2>&1");
    if ($watermark_cmd) {
      $video_1440p_marked_name = $videos_directory . $video_prefix . '_marked_1440p.mp4';
      $video_1440_marked_local_path = ABSPATH . $system['uploads_directory'] . '/' . $video_1440p_marked_name;
      shell_exec($system['ffmpeg_path'] . " -y -i $video_1440_local_path $watermark_cmd $video_1440_marked_local_path 2<&1");
      if (file_exists($video_1440_marked_local_path)) {
        /* remove local file */
        unlink($video_1440_local_path);
        $video_1440p_name = $video_1440p_marked_name;
        $video_1440_local_path = $video_1440_marked_local_path;
      }
    }
    /* only upload & record if ffmpeg actually produced a valid (non-empty) file */
    if (file_exists($video_1440_local_path) && filesize($video_1440_local_path) > 0) {
      /* save the new video to cloud */
      save_file_to_cloud($video_1440_local_path, $video_1440p_name);
      /* update video */
      $db->query(sprintf("UPDATE $posts_table SET source_1440p = %s WHERE post_id = %s", secure($video_1440p_name), secure($post_id, 'int')));
    } else {
      @unlink($video_1440_local_path);
    }
  }
  /* convert video to 2160p */
  $video_2160p_name = $videos_directory . $video_prefix . '_2160p.mp4';
  $video_2160_local_path = ABSPATH . $system['uploads_directory'] . '/' . $video_2160p_name;
  if ($post_type != 'reel' && $system['ffmpeg_2160p_enabled'] && !file_exists($video_2160_local_path) && $resolution >= 3840) {
    shell_exec($system['ffmpeg_path'] . " -y -i $original_video_local_path -vcodec libx264 -preset " . $system['ffmpeg_speed'] . " -filter:v \"scale='if(gte(iw,ih),3840,-2)':'if(gte(iw,ih),-2,3840)'\" -crf 26 -pix_fmt yuv420p -c:a copy -movflags +faststart $video_2160_local_path 2>&1");
    if ($watermark_cmd) {
      $video_2160p_marked_name = $videos_directory . $video_prefix . '_marked_2160p.mp4';
      $video_2160_marked_local_path = ABSPATH . $system['uploads_directory'] . '/' . $video_2160p_marked_name;
      shell_exec($system['ffmpeg_path'] . " -y -i $video_2160_local_path $watermark_cmd $video_2160_marked_local_path 2<&1");
      if (file_exists($video_2160_marked_local_path)) {
        /* remove local file */
        unlink($video_2160_local_path);
        $video_2160p_name = $video_2160p_marked_name;
        $video_2160_local_path = $video_2160_marked_local_path;
      }
    }
    /* only upload & record if ffmpeg actually produced a valid (non-empty) file */
    if (file_exists($video_2160_local_path) && filesize($video_2160_local_path) > 0) {
      /* save the new video to cloud */
      save_file_to_cloud($video_2160_local_path, $video_2160p_name);
      /* update video */
      $db->query(sprintf("UPDATE $posts_table SET source_2160p = %s WHERE post_id = %s", secure($video_2160p_name), secure($post_id, 'int')));
    } else {
      @unlink($video_2160_local_path);
    }
  }
  /* remove fetched file (if any) */
  if ($delete_fetched_file) {
    unlink($original_video_local_path);
  }
  /* update post */
  $db->query(sprintf("UPDATE posts SET processing = '0' WHERE post_id = %s", secure($post_id, 'int')));
  /* notify post author */
  $user->post_notification(['to_user_id' => $post_author_id, 'action' => 'video_converted', 'node_type' => 'post', 'node_url' => $post_id]);
}
