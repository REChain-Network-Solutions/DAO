<?php

/**
 * functions -> messaging
 * 
 * @package Sngine
 * @author Zamblek
 */

/* ------------------------------- */
/* Email */
/* ------------------------------- */

/**
 * _email
 * 
 * @param string $email
 * @param string $subject
 * @param string $body_html
 * @param string $body_plain
 * @param boolean $is_html
 * @param boolean $only_smtp
 * @return boolean
 */
function _email($email, $subject, $body_html, $body_plain, $is_html = true, $only_smtp = false)
{
  global $system;
  /* set header */
  $header  = "MIME-Version: 1.0\r\n";
  $header .= "Mailer: " . html_entity_decode(__($system['system_title']), ENT_QUOTES) . "\r\n";
  if ($system['system_email']) {
    $header = "From: " . $system['system_email'] . "\r\n";
    $header .= "Reply-To: " . $system['system_email'] . "\r\n";
  }
  if ($is_html) {
    $header .= "Content-Type: text/html; charset=\"utf-8\"\r\n";
  } else {
    $header .= "Content-Type: text/plain; charset=\"utf-8\"\r\n";
  }
  /* send email */
  if ($system['email_smtp_enabled']) {
    /* SMTP */
    $mail = new PHPMailer\PHPMailer\PHPMailer;
    $mail->CharSet = "UTF-8";
    $mail->isSMTP();
    $mail->XMailer = $system['system_title'];
    $mail->Host = $system['email_smtp_server'];
    $mail->SMTPAuth = ($system['email_smtp_authentication']) ? true : false;
    $mail->Username = $system['email_smtp_username'];
    $mail->Password = html_entity_decode($system['email_smtp_password']);
    $mail->SMTPSecure = ($system['email_smtp_ssl']) ? 'ssl' : 'tls';
    $mail->Port = $system['email_smtp_port'];
    $setfrom = (is_empty($system['email_smtp_setfrom'])) ? $system['email_smtp_username'] : $system['email_smtp_setfrom'];
    $mail->setFrom($setfrom, html_entity_decode(__($system['system_title']), ENT_QUOTES));
    $mail->addAddress($email);
    $mail->Subject = $subject;
    if ($is_html) {
      $mail->isHTML(true);
      $mail->Body = $body_html;
      $mail->AltBody = $body_plain;
    } else {
      $mail->Body = $body_plain;
    }
    if (!$mail->send()) {
      if ($only_smtp) {
        return false;
      }
      /* send using mail() */
      if (!mail($email, $subject, $body_html, $header)) {
        return false;
      }
    }
  } else {
    if ($only_smtp) {
      return false;
    }
    /* send using mail() */
    if (!mail($email, $subject, $body_html, $header)) {
      return false;
    }
  }
  return true;
}


/**
 * email_smtp_test
 * 
 * @return void
 */
function email_smtp_test()
{
  global $system;
  /* prepare test email */
  $subject = __("Test SMTP Connection on") . " " . html_entity_decode(__($system['system_title']), ENT_QUOTES);
  $body = get_email_template("test_email", $subject);
  /* send email */
  if (!_email($system['system_email'], $subject, $body['html'], $body['plain'], true, true)) {
    throw new Exception(__("Test email could not be sent. Please check your settings"));
  }
}


/**
 * get_email_template
 * 
 * @param string $template_name
 * @param string $template_subject
 * @param array $template_variables
 * @return array
 */
function get_email_template($template_name, $template_subject, $template_variables = [])
{
  global $system, $smarty;
  $smarty->assign('system', $system);
  $smarty->assign("template_subject", $template_subject);
  if ($template_variables) {
    foreach ($template_variables as $key => $value) {
      $smarty->assign($key, $value);
    }
  }
  $body['html'] = $smarty->fetch("emails/" . $template_name . ".html");
  $body['plain'] = $smarty->fetch("emails/" . $template_name . ".txt");
  return $body;
}



/* ------------------------------- */
/* SMS */
/* ------------------------------- */

/**
 * sms_send
 * 
 * @param string $phone
 * @param string $message
 * @return boolean
 */
function sms_send($phone, $message)
{
  global $system, $db, $date;
  /* check if this phone sent more than 3 SMS within 1 hour */
  $check_log = $db->query(sprintf("SELECT * FROM users_sms WHERE phone = %s AND insert_date > DATE_SUB(NOW(), INTERVAL 1 HOUR)", secure($phone)));
  if ($check_log->num_rows > $system['sms_limit']) {
    throw new Exception(__("You have reached the maximum number of SMS allowed per hour"));
    return false;
  }
  switch ($system['sms_provider']) {
    case 'twilio':
      $client = new Twilio\Rest\Client($system['twilio_sid'], $system['twilio_token']);
      $message = $client->account->messages->create(
        $phone,
        [
          'from' => $system['twilio_phone'],
          'body' => $message
        ]
      );
      if (!$message->sid) {
        return false;
      }
      break;

    case 'bulksms':
      $username = $system['bulksms_username'];
      $password = $system['bulksms_password'];
      $headers = [
        'Content-Type:application/json',
        'Authorization:Basic ' . base64_encode("$username:$password")
      ];
      $request_body = [
        [
          'to' => $phone,
          'body' => $message
        ]
      ];
      $ch = curl_init();
      curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
      curl_setopt($ch, CURLOPT_URL, "https://api.bulksms.com/v1/messages?auto-unicode=true&longMessageMaxParts=30");
      curl_setopt($ch, CURLOPT_POST, 1);
      curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
      curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($request_body));
      curl_setopt($ch, CURLOPT_TIMEOUT, 20);
      curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 10);
      $response = curl_exec($ch);
      $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
      if (curl_errno($ch)) {
        return false;
      }
      if ($httpCode != 201) {
        return false;
      }
      break;

    case 'infobip':
      if (!infobip_sms_send($phone, $message)) {
        return false;
      }
      break;

    case 'msg91':
      $request_body = [
        'template_id' => $system['msg91_template_id'],
        'short_url' => '0',
        'recipients' => [
          [
            'mobiles' => $phone,
            'VAR1' => $message
          ]
        ]
      ];
      $ch = curl_init();
      curl_setopt_array($ch, [
        CURLOPT_URL => "https://control.msg91.com/api/v5/flow",
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_ENCODING => "",
        CURLOPT_MAXREDIRS => 10,
        CURLOPT_TIMEOUT => 30,
        CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
        CURLOPT_CUSTOMREQUEST => "POST",
        CURLOPT_POSTFIELDS => json_encode($request_body),
        CURLOPT_HTTPHEADER => [
          "accept: application/json",
          "authkey: " . $system['msg91_authkey'],
          "content-type: application/json"
        ]
      ]);
      $response = curl_exec($ch);
      $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
      if (curl_errno($ch)) {
        return false;
      }
      if (!($httpCode >= 200 && $httpCode < 300)) {
        return false;
      }
      break;
  }
  /* insert this to SMS log */
  $db->query(sprintf("INSERT INTO users_sms (phone, insert_date) VALUES (%s, %s)", secure($phone), secure($date)));
  return true;
}


/**
 * infobip_sms_send
 * 
 * @param string $phone
 * @param string $message
 * @return boolean
 */
function infobip_sms_send($phone, $message)
{
  global $system;
  /* prepare base url */
  $base_url = rtrim(preg_replace('#^https?://#i', '', trim(html_entity_decode($system['infobip_base_url'] ?? ''))), '/');
  $api_key = trim(html_entity_decode($system['infobip_api_key'] ?? ''));
  if ($base_url == '' || $api_key == '') {
    return false;
  }
  /* prepare sender */
  $sender = (is_empty($system['infobip_sender'] ?? '')) ? $system['system_title'] : $system['infobip_sender'];
  $request_body = [
    "messages" => [
      [
        "sender" => html_entity_decode($sender, ENT_QUOTES),
        "destinations" => [
          ["to" => $phone]
        ],
        "content" => [
          "text" => $message
        ]
      ]
    ]
  ];
  $ch = curl_init();
  curl_setopt_array($ch, [
    CURLOPT_URL => "https://" . $base_url . "/sms/3/messages",
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_CONNECTTIMEOUT => 5,
    CURLOPT_TIMEOUT => 15,
    CURLOPT_POST => true,
    CURLOPT_POSTFIELDS => json_encode($request_body),
    CURLOPT_HTTPHEADER => [
      "Authorization: App " . $api_key,
      "Content-Type: application/json",
      "Accept: application/json"
    ]
  ]);
  $response = curl_exec($ch);
  $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
  if (curl_errno($ch)) {
    return false;
  }
  if (!($httpCode >= 200 && $httpCode < 300)) {
    return false;
  }
  /* check if the message rejected */
  $response = json_decode($response, true);
  if (($response['messages'][0]['status']['groupId'] ?? 0) == 5) {
    return false;
  }
  return true;
}


/**
 * sms_test
 * 
 * @return void
 */
function sms_test()
{
  global $system;
  if (is_empty($system['system_phone'])) {
    throw new Exception(__("You need to enter Test Phone Number"));
  }
  switch ($system['sms_provider']) {
    case 'twilio':
      $client = new Twilio\Rest\Client($system['twilio_sid'], $system['twilio_token']);
      $message = $client->account->messages->create(
        $system['system_phone'],
        [
          'from' => $system['twilio_phone'],
          'body' => __("Test SMS from") . " " . __($system['system_title'])
        ]
      );
      if (!$message->sid) {
        throw new Exception(__("Test SMS could not be sent. Please check your settings"));
      }
      break;

    case 'bulksms':
      $username = $system['bulksms_username'];
      $password = $system['bulksms_password'];
      $headers = [
        'Content-Type:application/json',
        'Authorization:Basic ' . base64_encode("$username:$password")
      ];
      $request_body = [
        [
          'to' => $system['system_phone'],
          'body' => __("Test SMS from") . " " . __($system['system_title'])
        ]
      ];
      $ch = curl_init();
      curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
      curl_setopt($ch, CURLOPT_URL, "https://api.bulksms.com/v1/messages?auto-unicode=true&longMessageMaxParts=30");
      curl_setopt($ch, CURLOPT_POST, 1);
      curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
      curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($request_body));
      curl_setopt($ch, CURLOPT_TIMEOUT, 20);
      curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 10);
      $response = curl_exec($ch);
      $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
      if (curl_errno($ch)) {
        throw new Exception(__("Test SMS could not be sent. Please check your settings"));
      }
      if ($httpCode != 201) {
        throw new Exception(__("Test SMS could not be sent. Please check your settings"));
      }
      break;

    case 'infobip':
      if (!infobip_sms_send($system['system_phone'], __("Test SMS from") . " " . __($system['system_title']))) {
        throw new Exception(__("Test SMS could not be sent. Please check your settings"));
      }
      break;

    case 'msg91':
      $request_body = [
        'template_id' => $system['msg91_template_id'],
        'short_url' => '0',
        'recipients' => [
          [
            'mobiles' => $system['system_phone'],
            'VAR1' => __("Test SMS from") . " " . __($system['system_title'])
          ]
        ]
      ];
      $ch = curl_init();
      curl_setopt_array($ch, [
        CURLOPT_URL => "https://control.msg91.com/api/v5/flow",
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_ENCODING => "",
        CURLOPT_MAXREDIRS => 10,
        CURLOPT_TIMEOUT => 30,
        CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
        CURLOPT_CUSTOMREQUEST => "POST",
        CURLOPT_POSTFIELDS => json_encode($request_body),
        CURLOPT_HTTPHEADER => [
          "accept: application/json",
          "authkey: " . $system['msg91_authkey'],
          "content-type: application/json"
        ]
      ]);
      $response = curl_exec($ch);
      $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
      if (curl_errno($ch)) {
        throw new Exception(__("Test SMS could not be sent. Please check your settings"));
      }
      if (!($httpCode >= 200 && $httpCode < 300)) {
        throw new Exception(__("Test SMS could not be sent. Please check your settings"));
      }
      break;
  }
}
