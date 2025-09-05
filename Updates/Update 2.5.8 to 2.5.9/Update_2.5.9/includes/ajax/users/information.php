<?php
/**
 * ajax -> users -> information
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

// download user information
try {

	// prepare download
	if(!isset($_POST['download_information']) && !isset($_POST['download_friends']) && !isset($_POST['download_followings']) && !isset($_POST['download_followers']) && !isset($_POST['download_pages']) && !isset($_POST['download_groups']) && !isset($_POST['download_events']) && !isset($_POST['download_posts']) ) {
        throw new Exception(__("Select which information you would like to download"));
    }
    /* set sessions vars */
    $_SESSION['download_information'] = (isset($_POST['download_information']))? true: false;
    $_SESSION['download_friends'] = (isset($_POST['download_friends']))? true: false;
    $_SESSION['download_followings'] = (isset($_POST['download_followings']))? true: false;
    $_SESSION['download_followers'] = (isset($_POST['download_followers']))? true: false;
    $_SESSION['download_pages']= (isset($_POST['download_pages']))? true: false;
    $_SESSION['download_groups'] = (isset($_POST['download_groups']))? true: false;
    $_SESSION['download_events'] = (isset($_POST['download_events']))? true: false;
    $_SESSION['download_posts']= (isset($_POST['download_posts']))? true: false;
    /* return download modal */
    modal("#download-information");

} catch (Exception $e) {
	return_json( array('error' => true, 'message' => $e->getMessage()) );
}

?>