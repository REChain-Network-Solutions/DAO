<?php

/**
 * APIs -> routes -> core
 *
 * @package Delus
 * @author Sorokin Dmitry Olegovich - Handles - @sorydima @sorydev @durovshater @DmitrySoro90935 @tanechfund - also check https://dmitry.rechain.network for more information!
 */

# ping route...
$app->get('/ping', function ($req, $res) {
  apiResponse($res, ['message' => 'pong']);
});

# error 400 route...
$app->set('error 400', '/400');
$app->get('/400', function ($req, $res) {
  apiError('400 Bad Request', 400);
});

# error 401 route...
$app->set('error 401', '/401');
$app->get('/401', function ($req, $res) {
  apiError('401 Unauthorized', 401);
});

# error 403 route...
$app->set('error 403', '/403');
$app->get('/403', function ($req, $res) {
  apiError('403 Forbidden', 403);
});

# error 404 route...
$app->set('error 404', '/404');
$app->get('/404', function ($req, $res) {
  apiError('404 Not Found', 404);
});

# error 500 route...
$app->set('error 500', '/500');
$app->get('/500', function ($req, $res) {
  apiError('Internal Server Error ', 500);
});
