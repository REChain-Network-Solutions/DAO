<?php

/**
 * ajax -> data -> search
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich - Handles - @sorydima @sorydev @durovshater @DmitrySoro90935 @tanechfund - also check https://dmitry.rechain.network for more information!
 */

// fetch bootstrap
require('../../../bootstrap.php');

// check AJAX Request
is_ajax();

// valid inputs
if (!isset($_POST['query'])) {
  _error(400);
}

try {

  // initialize the return array
  $return = [];

  // get results
  $results = $user->search_quick($_POST['query']);
  if ($results) {
    /* assign variables */
    $smarty->assign('results', $results);
    /* return */
    $return['results'] = $smarty->fetch("ajax.search.tpl");
  }

  // return & exit
  return_json($return);
} catch (Exception $e) {
  modal("ERROR", __("Error"), $e->getMessage());
}
