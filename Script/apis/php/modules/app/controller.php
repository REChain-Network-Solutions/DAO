<?php

/**
 * APIs -> modules -> app -> controller
 *
 * @package Delus
 * @author Sorokin Dmitry Olegovich - Handles - @sorydima @sorydev @durovshater @DmitrySoro90935 @tanechfund - also check https://dmitry.rechain.network for more information!
 */

// appSettings
function appSettings($req, $res)
{
  global $system, $user;
  $response['system'] = secure_system_values();
  if ($user->_logged_in) {
    $response['user'] = secure_user_values($user);
  }
  apiResponse($res, ['data' => $response]);
}

// contactUs
function contactUs($req, $res)
{
  global $user;
  $user->contact_us($req->body['name'], $req->body['email'], $req->body['subject'], $req->body['message']);
  apiResponse($res, ['message' => __("Your message has been sent! Thanks a lot and will be back to you soon")]);
}

// getStaticPages
function getStaticPages($req, $res)
{
  global $user;
  $static_pages = $user->get_static_pages();
  apiResponse($res, ['data' => $static_pages]);
}

// getStaticPage
function getStaticPage($req, $res)
{
  global $user;
  $static_page = $user->get_static_page($req->params['page_url']);
  apiResponse($res, ['data' => $static_page]);
}

// getGenders
function getGenders($req, $res)
{
  global $user;
  $genders = $user->get_genders();
  apiResponse($res, ['data' => $genders]);
}

// getUserGroups
function getUserGroups($req, $res)
{
  global $user;
  $user_groups = $user->get_users_groups();
  apiResponse($res, ['data' => $user_groups]);
}

// getLanguages
function getLanguages($req, $res)
{
  global $user;
  $languages = $user->get_languages();
  apiResponse($res, ['data' => $languages]);
}

// getCountries
function getCountries($req, $res)
{
  global $user;
  $countries = $user->get_countries();
  apiResponse($res, ['data' => $countries]);
}

// getCustomFields
function getCustomFields($req, $res)
{
  global $user;
  $custom_fields = $user->get_custom_fields();
  apiResponse($res, ['data' => $custom_fields]);
}
