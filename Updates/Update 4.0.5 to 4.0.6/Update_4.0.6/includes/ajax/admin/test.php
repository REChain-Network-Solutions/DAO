<?php

/**
 * ajax -> admin -> test
 * 
 * @package Sngine
 * @author Zamblek
 */

// fetch bootstrap
require('../../../bootstrap.php');

// check AJAX Request
is_ajax();

// check admin|moderator permission
if (!$user->_is_admin) {
  modal("MESSAGE", __("System Message"), __("You don't have the right permission to access this"));
}

// check demo account
if ($user->_data['user_demo']) {
  modal("ERROR", __("Demo Restriction"), __("You can't do this with demo account"));
}

// handle test
try {

  switch ($_POST['handle']) {
    case 'smtp':
      /* test */
      email_smtp_test();
      /* return */
      return_json(['success' => true, 'message' => __("Test email has been sent to") . ": " . $system['system_email']]);
      break;

    case 'sms':
      /* test */
      sms_test();
      /* return */
      return_json(['success' => true, 'message' => __("Test SMS has been sent to") . ": " . $system['system_phone']]);
      break;

    case 'google_vision':
      /* test */
      google_vision_test();
      /* return */
      return_json(['success' => true, 'message' => __("Connection established Successfully!")]);
      break;

    case 'ffmpeg':
      /* test */
      $response = ffmpeg_test();
      /* return */
      return_json(['success' => true, 'message' => $response]);
      break;

    case 's3':
      /* test */
      aws_s3_test($system['s3_bucket'], $system['s3_region'], $system['s3_key'], $system['s3_secret']);
      /* return */
      return_json(['success' => true, 'message' => __("Connection established Successfully!")]);
      break;

    case 's3-agora':
      /* test */
      aws_s3_test($system['agora_s3_bucket'], $system['agora_s3_region'], $system['agora_s3_key'], $system['agora_s3_secret']);
      /* return */
      return_json(['success' => true, 'message' => __("Connection established Successfully!")]);
      break;

    case 'google_cloud':
      /* test */
      google_cloud_test();
      /* return */
      return_json(['success' => true, 'message' => __("Connection established Successfully!")]);
      break;

    case 'digitalocean':
      /* test */
      digitalocean_space_test();
      /* return */
      return_json(['success' => true, 'message' => __("Connection established Successfully!")]);
      break;

    case 'wasabi':
      /* test */
      wasabi_test();
      /* return */
      return_json(['success' => true, 'message' => __("Connection established Successfully!")]);
      break;

    case 'backblaze':
      /* test */
      backblaze_test();
      /* return */
      return_json(['success' => true, 'message' => __("Connection established Successfully!")]);
      break;

    case 'yandex_cloud':
      /* test */
      yandex_cloud_test();
      /* return */
      return_json(['success' => true, 'message' => __("Connection established Successfully!")]);
      break;

    case 'cloudflare_r2':
      /* test */
      cloudflare_r2_test();
      /* return */
      return_json(['success' => true, 'message' => __("Connection established Successfully!")]);
      break;

    case 'ftp':
      /* test */
      ftp_test();
      /* return */
      return_json(['success' => true, 'message' => __("Connection established Successfully!")]);
      break;

    case 'api':
      /* test */
      $response = api_test();
      /* return */
      return_json(['success' => true, 'message' => $response]);
      break;

    default:
      _error(400);
      break;
  }
} catch (Exception $e) {
  return_json(['error' => true, 'message' => $e->getMessage()]);
}
