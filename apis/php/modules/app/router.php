<?php

/**
 * APIs -> modules -> app -> router
 *
 * @package Delus
 * @author Dmitry Sorokin - @sorydima & @sorydev Handles. 
 */

// get controller 
require('modules/app/controller.php');

# [get] settings
$app->get('/app/settings', function ($req, $res) {
  appSettings($req, $res);
});

# [post] contact_us
$app->post('/app/contact_us', function ($req, $res) {
  contactUs($req, $res);
});

# [get] static_pages
$app->get('/app/static_pages', function ($req, $res) {
  getStaticPages($req, $res);
});

# [get] static_pages/[:page_url]
$app->get('/app/static_pages/[:page_url]', function ($req, $res) {
  getStaticPage($req, $res);
});

# [get] genders
$app->get('/app/genders', function ($req, $res) {
  getGenders($req, $res);
});

# [get] user_groups
$app->get('/app/user_groups', function ($req, $res) {
  getUserGroups($req, $res);
});

# [get] countries
$app->get('/app/countries', function ($req, $res) {
  getCountries($req, $res);
});

# [get] custom_fields
$app->get('/app/custom_fields', function ($req, $res) {
  getCustomFields($req, $res);
});
