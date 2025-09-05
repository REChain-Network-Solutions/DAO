<?php

/**
 * APIs -> modules -> user -> router
 *
 * @package Delus
 * @author Sorokin Dmitry Olegovich - Handles - @sorydima @sorydev @durovshater @DmitrySoro90935 @tanechfund - also check https://dmitry.rechain.network for more information!
 */

// get controller 
require('modules/user/controller.php');

# [post] connect
$app->post('/user/connect', function ($req, $res) {
  connectUser($req, $res);
});

# [post] image_delete
$app->post('/user/image_delete', function ($req, $res) {
  deleteAvatarCoverImage($req, $res);
});

# [post] onesignal
$app->post('/user/onesignal', function ($req, $res) {
  updateOnesignalId($req, $res);
});

# [post] delete
$app->post('/user/delete', function ($req, $res) {
  deleteUser($req, $res);
});
