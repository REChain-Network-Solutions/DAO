<?php

/**
 * ajax -> chat -> search
 *
 * @package Sngine
 * @author Zamblek
 */

// fetch bootstrap
require('../../../bootstrap.php');

// check AJAX Request
is_ajax();

// user access
user_access(true);

try {

  // initialize the return array
  $return = [];

  // valid inputs
  $query = trim((string) ($_GET['query'] ?? ''));
  $filter = in_array($_GET['filter'] ?? '', ['all', 'unread', 'groups']) ? $_GET['filter'] : 'all';

  // search conversations
  $results = $user->search_conversations($query, $filter, 0);

  /* assign variables */
  $smarty->assign('conversations', $results['data']);
  $smarty->assign('has_more', $results['has_more']);
  $smarty->assign('query', $query);
  $smarty->assign('filter', $filter);
  $smarty->assign('active_cid', $_GET['active_cid'] ?? 0);

  /* return */
  $return['html'] = $smarty->fetch("ajax.chat.search.tpl");

  // return & exit
  return_json($return);
} catch (Exception $e) {
  modal("ERROR", __("Error"), $e->getMessage());
}
