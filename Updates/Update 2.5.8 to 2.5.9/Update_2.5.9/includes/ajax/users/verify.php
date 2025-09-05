<?php
/**
 * ajax -> users -> verify
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

// verify
try {

	/* valid inputs */
	if(!isset($_POST['photo']) || is_empty($_POST['photo'])) {
		throw new Exception(__("Please attach your photo and your Passport or National ID"));
	}
	if(!isset($_POST['passport']) || is_empty($_POST['passport'])) {
		throw new Exception(__("Please attach your photo and your Passport or National ID"));
	}
	if(!isset($_POST['message']) || is_empty($_POST['message']) ) {
		throw new Exception(__("Please share why your account should be verified"));
	}

	switch ($_GET['node']) {
		case 'user':
			$query = $db->query(sprintf("INSERT INTO verification_requests (node_id, node_type, photo, passport, message, time, status) VALUES (%s, 'user', %s, %s, %s, %s, '0')", secure($user->_data['user_id'], 'int'), secure($_POST['photo']), secure($_POST['passport']), secure($_POST['message']), secure($date) ));
			if(!$query) {
				throw new Exception(__("You have pending verification request already!"));
			}
			break;
		
		case 'page':
			/* valid inputs */
			if(!isset($_GET['node_id']) || !is_numeric($_GET['node_id'])) {
				_error(400);
			}
			/* check if the user is the page admin */
			if(!$user->check_page_adminship($user->_data['user_id'], $_GET['node_id'])) {
				_error(403);
			}
			$query = $db->query(sprintf("INSERT INTO verification_requests (node_id, node_type, photo, passport, message, time, status) VALUES (%s, 'page', %s, %s, %s, %s, '0')", secure($_GET['node_id'], 'int'), secure($_POST['photo']), secure($_POST['passport']), secure($_POST['message']), secure($date) ));
			if(!$query) {
				throw new Exception(__("You have pending verification request already!"));
			}
			break;

		default:
			_error(400);
			break;
	}

	// return & exit
	return_json( array('callback' => 'window.location.reload();') );

} catch (Exception $e) {
	return_json( array('error' => true, 'message' => $e->getMessage()) );
}

?>