<?php

/**
 * functions -> images
 * 
 * @package Sngine
 * @author Zamblek
 */

/* ------------------------------- */
/* Images */
/* ------------------------------- */

/**
 * get_watermark_opacity
 * 
 * @param mixed $value
 * @return float
 */
function get_watermark_opacity($value)
{
  if (!is_numeric($value)) {
    return 0.5;
  }
  return round(min(1, max(0, (float) $value)) * 20) / 20;
}


/**
 * get_watermark_percent
 * 
 * @param mixed $value
 * @param integer $default
 * @return integer
 */
function get_watermark_percent($value, $default)
{
  if (!is_numeric($value)) {
    return $default;
  }
  return (int) round(min(100, max(0, (float) $value)));
}


/**
 * get_picture
 * 
 * @param string $picture
 * @param string $type
 * @param array $system
 * @return string
 */
function get_picture($picture, $type, $system = null)
{
  if ($system == null) {
    global $system;
  }
  if ($picture == "") {
    switch ($type) {
      case 'page':
        $picture = $system['system_url'] . '/content/themes/' . $system['theme'] . '/images/blank/blank_page.png';
        break;

      case 'group':
        $picture = $system['system_url'] . '/content/themes/' . $system['theme'] . '/images/blank/blank_group.png';
        break;

      case 'event':
        $picture = $system['system_url'] . '/content/themes/' . $system['theme'] . '/images/blank/blank_event.png';
        break;

      case 'blog':
        $picture = $system['system_url'] . '/content/themes/' . $system['theme'] . '/images/blank/blank_blog.png';
        break;

      case 'movie':
        $picture = $system['system_url'] . '/content/themes/' . $system['theme'] . '/images/blank/blank_movie.png';
        break;

      case 'game':
        $picture = $system['system_url'] . '/content/themes/' . $system['theme'] . '/images/blank/blank_game.png';
        break;

      case 'package':
        $picture = $system['system_url'] . '/content/themes/' . $system['theme'] . '/images/blank/blank_package.png';
        break;

      case 'flag':
        $picture = $system['system_url'] . '/content/themes/' . $system['theme'] . '/images/blank/blank_flag.png';
        break;

      case 'system':
        $picture = $system['system_url'] . '/content/themes/' . $system['theme'] . '/images/svg/system/dashboard.svg';
        break;

      case 'static_page_icon':
        $picture = $system['system_url'] . '/content/themes/' . $system['theme'] . '/images/svg/system/dashboard.svg';
        break;

      case '1':
        $picture = $system['system_url'] . '/content/themes/' . $system['theme'] . '/images/blank/blank_profile_male.png';
        break;

      case '2':
        $picture = $system['system_url'] . '/content/themes/' . $system['theme'] . '/images/blank/blank_profile_female.png';
        break;

      default:
        $picture = $system['system_url'] . '/content/themes/' . $system['theme'] . '/images/blank/blank_profile.png';
        break;
    }
  } else {
    $picture = $system['system_uploads'] . '/' . $picture;
  }
  return $picture;
}


/**
 * reassemble_file_chunks
 * 
 * @param string $temp_directory
 * @param string $file_guid
 * @param string $file_name
 * @param int $totalChunks
 * @param string $final_file_path
 * @return void
 */
function reassemble_file_chunks($temp_directory, $file_guid, $file_name, $totalChunks, $final_file_path)
{
  $final_file = fopen($final_file_path, 'wb');
  if ($final_file === false) {
    throw new Exception(__("Could not create final file"));
  }
  for ($i = 0; $i < $totalChunks; $i++) {
    $chunk_file = $temp_directory . $file_guid . '_' . $file_name . ".part-" . $i;
    if (!file_exists($chunk_file)) {
      fclose($final_file);
      throw new Exception(__("Missing chunk file"));
    }
    $chunk_handle = fopen($chunk_file, 'rb');
    if ($chunk_handle === false) {
      fclose($final_file);
      throw new Exception(__("Could not open chunk file"));
    }
    while (!feof($chunk_handle)) {
      $buffer = fread($chunk_handle, 8192); // Read in 8KB chunks
      if ($buffer === false) {
        fclose($chunk_handle);
        fclose($final_file);
        throw new Exception(__("Error reading chunk file"));
      }
      if (fwrite($final_file, $buffer) === false) {
        fclose($chunk_handle);
        fclose($final_file);
        throw new Exception(__("Error writing to final file"));
      }
    }
    fclose($chunk_handle);
    unlink($chunk_file);
  }
  fclose($final_file);
}


/**
 * sanitize_image_trailing_bytes
 * 
 * @param string $file_path
 * @param string $mime_type
 * @return void
 */
function sanitize_image_trailing_bytes($file_path, $mime_type)
{
  $size = @filesize($file_path);
  if (!$size) {
    return;
  }
  if ($mime_type === 'image/webp') {
    $fh = @fopen($file_path, 'rb');
    if (!$fh) {
      return;
    }
    $header = fread($fh, 12);
    fclose($fh);
    if (strlen($header) < 12 || substr($header, 0, 4) !== 'RIFF' || substr($header, 8, 4) !== 'WEBP') {
      return;
    }
    $riff_size = unpack('V', substr($header, 4, 4))[1];
    $logical_end = 8 + $riff_size;
    if ($logical_end > 0 && $logical_end < $size) {
      if ($fh = @fopen($file_path, 'r+b')) {
        ftruncate($fh, $logical_end);
        fclose($fh);
      }
    }
    return;
  }
  if ($mime_type === 'image/gif') {
    $data = @file_get_contents($file_path);
    if ($data === false || strlen($data) < 14 || substr($data, 0, 3) !== 'GIF') {
      return;
    }
    $len = strlen($data);
    $pos = 6;
    $packed = ord($data[$pos + 4]);
    $pos += 7;
    if ($packed & 0x80) {
      $pos += 3 * (1 << (($packed & 0x07) + 1));
    }
    $end = -1;
    while ($pos < $len) {
      $b = ord($data[$pos]);
      if ($b === 0x3B) {
        $end = $pos + 1;
        break;
      } elseif ($b === 0x21) {
        $pos += 2;
        while ($pos < $len) {
          $bs = ord($data[$pos]);
          $pos += 1 + $bs;
          if ($bs === 0) {
            break;
          }
        }
      } elseif ($b === 0x2C) {
        $pos += 1;
        if ($pos + 9 > $len) {
          break;
        }
        $img_packed = ord($data[$pos + 8]);
        $pos += 9;
        if ($img_packed & 0x80) {
          $pos += 3 * (1 << (($img_packed & 0x07) + 1));
        }
        $pos += 1;
        while ($pos < $len) {
          $bs = ord($data[$pos]);
          $pos += 1 + $bs;
          if ($bs === 0) {
            break;
          }
        }
      } else {
        return;
      }
    }
    if ($end > 0 && $end < $len) {
      if ($fh = @fopen($file_path, 'r+b')) {
        ftruncate($fh, $end);
        fclose($fh);
      }
    }
    return;
  }
}


/**
 * save_picture_from_url
 * 
 * @param string $file
 * @param boolean $cropped
 * @param boolean $resize
 * @return string
 */
function save_picture_from_url($file, $cropped = false, $resize = false)
{
  global $system;
  /* check & create uploads dir */
  $folder = 'photos';
  $directory = $folder . '/' . date('Y') . '/' . date('m') . '/';
  // init image & prepare image name & path
  require_once(ABSPATH . 'includes/class-image.php');
  $image = new Image($file);
  $prefix = $system['uploads_prefix'] . '_' . get_hash_token();
  if ($cropped) {
    $image_name = $directory . $prefix . "_cropped" . $image->_img_ext;
    if ($resize) {
      $image->resizeWidth($_POST['resize_width']);
    }
    $_POST['width'] = (isset($_POST['width'])) ? $_POST['width'] : $image->getWidth();
    $_POST['height'] = (isset($_POST['height'])) ? $_POST['height'] : $image->getHeight();
    $image->crop($_POST['width'], $_POST['height'], $_POST['x'], $_POST['y']);
  } else {
    $image_name = $directory . $prefix . $image->_img_ext;
  }
  $path = ABSPATH . $system['uploads_directory'] . '/' . $image_name;
  /* set uploads directory */
  if (!file_exists(ABSPATH . $system['uploads_directory'] . '/' . $folder)) {
    @mkdir(ABSPATH . $system['uploads_directory'] . '/' . $folder, 0777, true);
  }
  if (!file_exists(ABSPATH . $system['uploads_directory'] . '/' . $folder . '/' . date('Y'))) {
    @mkdir(ABSPATH . $system['uploads_directory'] . '/' . $folder . '/' . date('Y'), 0777, true);
  }
  if (!file_exists($system['uploads_directory'] . '/' . $folder . '/' . date('Y') . '/' . date('m'))) {
    @mkdir(ABSPATH . $system['uploads_directory'] . '/' . $folder . '/' . date('Y') . '/' . date('m'), 0777, true);
  }
  /* save the new image */
  $image->save($path, $system['uploads_quality']);
  /* cloud storage */
  save_file_to_cloud($path, $image_name);
  return $image_name;
}


/**
 * watermark_image
 * 
 * @param string $image_path
 * @param string $image_type
 * @return void
 */
function watermark_image($image_path, $image_type)
{
  global $system, $user;
  try {
    $image = new claviska\SimpleImage();
    $image->fromFile($image_path)->autoOrient();
    if ($system['watermark_type'] == "icon") {
      /* watermark using icon */
      if (!is_empty($system['watermark_icon'])) {
        $watermark = new claviska\SimpleImage($system['system_uploads'] . "/" . $system['watermark_icon']);
        $image->overlay(
          $watermark,
          'top left',
          get_watermark_opacity($system['watermark_opacity']),
          (int) round(($image->getWidth() - $watermark->getWidth()) * get_watermark_percent($system['watermark_x'] ?? null, 95) / 100),
          (int) round(($image->getHeight() - $watermark->getHeight()) * get_watermark_percent($system['watermark_y'] ?? null, 95) / 100)
        );
        $image->toFile($image_path, $image_type);
      }
    } else {
      /* watermark using user name */
      $username = parse_url($system['system_url'], PHP_URL_HOST) . '/' . $user->_data['user_name'];
      $font_file = ABSPATH . 'includes/assets/fonts/Inter/Inter-Regular.ttf';
      $font_size = 20;
      $color = '#ffffff';
      $angle = 135;
      $width = (int) round($image->getWidth() * 1.5);
      $height = (int) round($image->getHeight() * 1.5);
      /* create a new image with the text */
      $text_image = new claviska\SimpleImage();
      $text_image->fromNew($width, $height, 'transparent');
      /* estimate the width and height of the text box */
      $bbox = imagettfbbox($font_size, 0, $font_file, $username);
      $text_width = abs($bbox[4] - $bbox[0]);
      $text_height = abs($bbox[5] - $bbox[1]);
      $spacing = 30;
      /* draw the repeated text */
      for ($x = -$width; $x < $width * 1.5; $x += $text_width + $spacing) {
        for ($y = -$height; $y < $height * 1.5; $y += $text_height + $spacing) {
          $text_image->text($username, [
            'fontFile' => $font_file,
            'size' => $font_size,
            'color' => $color,
            'anchor' => 'top left',
            'xOffset' => $x,
            'yOffset' => $y
          ]);
        }
      }
      /* rotate the text image */
      $text_image->rotate($angle, 'transparent');
      /* flip the text image */
      $text_image->flip('both');
      /* overlay this text image on the original image */
      $image->overlay($text_image, 'center', get_watermark_opacity($system['watermark_opacity']));
      $image->toFile($image_path, $image_type);
    }
  } catch (Exception $e) {
    return $e->getMessage();
  }
}


/**
 * blur_image
 * 
 * @param string $image_path
 * @param string $image_type
 * @return void
 */
function blur_image($image_path, $image_type)
{
  global $system;
  try {
    $image = new claviska\SimpleImage();
    $image->fromFile($image_path)->autoOrient();
    $image->blur('gaussian', 25);
    $image->toFile($image_path, $image_type);
  } catch (Exception $e) {
    return $e->getMessage();
  }
}
