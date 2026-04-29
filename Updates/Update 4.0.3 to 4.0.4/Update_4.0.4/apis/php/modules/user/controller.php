<?php

/**
 * APIs -> modules -> user -> controller
 *
 * @package Sngine
 * @author Zamblek
 */

// connectUser
function connectUser($req, $res)
{
  global $user;
  /* check demo account */
  if ($user->_data['user_demo']) {
    throw new AuthorizationException(__("You can't do this with demo account"));
  }
  $req->body['uid'] = ($req->body['uid'] == '0') ? null : $req->body['uid'];
  $user->connect($req->body['do'], $req->body['id'], $req->body['uid']);
  apiResponse($res);
}

// deleteAvatarCoverImage
function deleteAvatarCoverImage($req, $res)
{
  global $system, $user;
  /* check demo account */
  if ($user->_data['user_demo']) {
    throw new AuthorizationException(__("You can't do this with demo account"));
  }
  $response = delete_avatar_cover_image($req->body['handle']);
  apiResponse($res, ['data' => $response]);
}

// updateOnesignalId
function updateOnesignalId($req, $res)
{
  global $user;
  $user->update_session_onesignal_id($req->body['onesignal_id']);
  apiResponse($res);
}

// deleteUser
function deleteUser($req, $res)
{
  global $user;
  /* check demo account */
  if ($user->_data['user_demo']) {
    throw new AuthorizationException(__("You can't do this with demo account"));
  }
  $user->verify_password($req->body['password']);
  $user->delete_user($user->_data['user_id']);
  apiResponse($res);
}
