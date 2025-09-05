<?php

/**
 * APIs -> modules -> auth -> controller
 *
 * @package Delus
 * @author Sorokin Dmitry Olegovich - Handles - @sorydima @sorydev @durovshater @DmitrySoro90935 @tanechfund - also check https://dmitry.rechain.network for more information!
 */

// signUp
function signUp($req, $res)
{
  global $system, $user;
  $device_info = [
    "device_type" => $req->body['device_type'],
    "device_os" => ($req->body['device_type'] == 'A') ? 'Android' : 'iOS',
    "device_os_version" => $req->body['device_os_version'],
    "device_name" => $req->body['device_name'],
  ];
  $_POST['from_web'] = false;
  $response = $user->sign_up($_POST, $device_info);
  apiResponse($res, ['data' => $response]);
}

// accountActivation
function accountActivation($req, $res)
{
  global $system, $user;
  if ($system['activation_type'] == "email") {
    $user->activation_email($req->body['code']);
  } else {
    $user->activation_phone($req->body['code']);
  }
  apiResponse($res);
}

// accountActivationResend
function accountActivationResend($req, $res)
{
  global $system, $user;
  if ($system['activation_type'] == "email") {
    $user->activation_email_resend();
  } else {
    $user->activation_phone_resend();
  }
  apiResponse($res);
}

// accountActivationReset
function accountActivationReset($req, $res)
{
  global $system, $user;
  if ($system['activation_type'] == "email") {
    $user->activation_email_reset($req->body['email']);
  } else {
    $user->activation_phone_reset($req->body['phone']);
  }
  apiResponse($res);
}

// gettingStartedUpdate
function gettingStartedUpdate($req, $res)
{
  global $user;
  $user->getting_satrted_update($_POST);
  apiResponse($res, ['data' => $response]);
}

// gettingStartedFinish
function gettingStartedFinish($req, $res)
{
  global $user;
  $user->getting_satrted_finish();
  apiResponse($res, ['data' => $response]);
}

// signIn
function signIn($req, $res)
{
  global $user;
  $device_info = [
    "device_type" => $req->body['device_type'],
    "device_os" => ($req->body['device_type'] == 'A') ? 'Android' : 'iOS',
    "device_os_version" => $req->body['device_os_version'],
    "device_name" => $req->body['device_name'],
  ];
  $response = $user->sign_in($req->body['username_email'], $req->body['password'], false, false, $device_info);
  apiResponse($res, ['data' => $response]);
}

// twoFactorAuthentication
function twoFactorAuthentication($req, $res)
{
  global $user;
  $device_info = [
    "device_type" => $req->body['device_type'],
    "device_os" => ($req->body['device_type'] == 'A') ? 'Android' : 'iOS',
    "device_os_version" => $req->body['device_os_version'],
    "device_name" => $req->body['device_name'],
  ];
  $response = $user->two_factor_authentication($req->body['two_factor_key'], $req->body['user_id'], false, false, $device_info);
  apiResponse($res, ['data' => $response]);
}

// signOut
function signOut($req, $res)
{
  global $user;
  $user->sign_out();
  apiResponse($res);
}

// forgetPassword
function forgetPassword($req, $res)
{
  global $user;
  $user->forget_password($req->body['email']);
  apiResponse($res);
}

// forgetPasswordConfirm
function forgetPasswordConfirm($req, $res)
{
  global $user;
  $user->forget_password_confirm($req->body['email'], $req->body['reset_key']);
  apiResponse($res);
}

// forgetPasswordReset
function forgetPasswordReset($req, $res)
{
  global $user;
  $user->forget_password_reset($req->body['email'], $req->body['reset_key'], $req->body['password'], $req->body['confirm']);
  apiResponse($res, ['message' => __("Your password has been changed you can login now")]);
}
