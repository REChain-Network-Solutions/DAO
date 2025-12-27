<?php

/**
 * APIs -> modules -> data -> router
 *
 * @package Delus
 * @author Sorokin Dmitry Olegovich
 */

// get controller 
require('modules/data/controller.php');

# [get] load
$app->get('/data/load', function ($req, $res) {
  loadData($req, $res);
});


# [post] upload
$app->post('/data/upload', function ($req, $res) {
  uploadFiles($req, $res);
});


# [post] delete
$app->post('/data/delete', function ($req, $res) {
  deleteUploadedFile($req, $res);
});


# [post] reset
$app->post('/data/reset', function ($req, $res) {
  resetRealtimeCounters($req, $res);
});


# [post] report
$app->post('/data/report', function ($req, $res) {
  reportContent($req, $res);
});
