<?php

/**
 * ajax -> users -> location
 * 
 * @package Delus
 * @author Dmitry Sorokin - @sorydima & @sorydev Handles. 
 */

// fetch bootstrap
require('../../../bootstrap.php');

// check AJAX Request
is_ajax();

// user access
user_access(true);

try {

  // update user location
  $db->query(sprintf("UPDATE users SET user_latitude = %s, user_longitude = %s, user_location_updated = %s WHERE user_id = %s", secure($_POST['latitude']), secure($_POST['longitude']), secure($date), secure($user->_data['user_id'], 'int')));

  // return
  return_json();
} catch (Exception $e) {
  modal("ERROR", __("Error"), $e->getMessage());
}
