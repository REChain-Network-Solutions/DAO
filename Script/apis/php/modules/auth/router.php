<?php

/**
 * APIs -> modules -> auth -> router
 *
 * @package Delus
 * @author Dmitry Sorokin - @sorydima & @sorydev Handles. 
 */

// get controller 
require('modules/auth/controller.php');

# [post] signup
$app->post('/auth/signup', function ($req, $res) {
  signUp($req, $res);
});

# [post] activation
$app->post('/auth/activation', function ($req, $res) {
  accountActivation($req, $res);
});

# [post] activation_resend
$app->post('/auth/activation_resend', function ($req, $res) {
  accountActivationResend($req, $res);
});

# [post] activation_reset
$app->post('/auth/activation_reset', function ($req, $res) {
  accountActivationReset($req, $res);
});

# [post] getting_started_update
$app->post('/auth/getting_started_update', function ($req, $res) {
  gettingStartedUpdate($req, $res);
});

# [post] getting_started_finish
$app->post('/auth/getting_started_finish', function ($req, $res) {
  gettingStartedFinish($req, $res);
});

# [post] signin
$app->post('/auth/signin', function ($req, $res) {
  signIn($req, $res);
});

# [post] two_factor_authentication
$app->post('/auth/two_factor_authentication', function ($req, $res) {
  twoFactorAuthentication($req, $res);
});

# [post] signout
$app->post('/auth/signout', function ($req, $res) {
  signOut($req, $res);
});

# [post] forget_password
$app->post('/auth/forget_password', function ($req, $res) {
  forgetPassword($req, $res);
});

# [post] forget_password_confirm
$app->post('/auth/forget_password_confirm', function ($req, $res) {
  forgetPasswordConfirm($req, $res);
});

# [post] forget_password_reset
$app->post('/auth/forget_password_reset', function ($req, $res) {
  forgetPasswordReset($req, $res);
});
