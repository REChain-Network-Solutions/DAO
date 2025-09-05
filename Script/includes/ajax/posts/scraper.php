<?php

/**
 * ajax -> posts -> scraper
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich - Handles - @sorydima @sorydev @durovshater @DmitrySoro90935 @tanechfund - also check https://dmitry.rechain.network for more information!
 */

// fetch bootstrap
require('../../../bootstrap.php');

// check AJAX Request
is_ajax();

// user access
user_access(true);

// valid inputs
if (!isset($_POST['query']) || is_empty($_POST['query'])) {
  _error(403);
}

// initialize the return array
$return = [];

try {

  // scraper
  $link = $user->scraper(trim($_POST['query']));
  if ($link) {
    /* return */
    $return['link'] = $link;
  }
} catch (Exception $e) {
}

// return & exit
return_json($return);
