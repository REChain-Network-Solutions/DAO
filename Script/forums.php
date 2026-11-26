<?php

/**
 * forums
 * 
 * @package Sngine
 * @author Zamblek
 */

// fetch bootloader
require('bootloader.php');

// forums enabled
if (!$system['forums_enabled']) {
  _error(404);
}

// rss feed
if (isset($_GET['view']) && $_GET['view'] == 'rss') {
  if (!$system['system_public'] || !$system['forums_rss_enabled']) {
    _error(404);
  }
  try {
    $user->get_forums_feed([
      'forum_id' => $_GET['forum_id'] ?? null,
      'thread_id' => $_GET['thread_id'] ?? null,
    ]);
  } catch (Exception $e) {
    _error(__("Error"), $e->getMessage());
  }
}

// user access
if ($user->_logged_in || !$system['system_public']) {
  user_access();
}

try {

  // get view content
  switch ($_GET['view']) {
    case '':
      // page header
      page_header(__("Forums") . ' | ' . __($system['system_title']), __($system['system_description_forums']));

      // get forums
      $forums = $user->get_forums();
      /* get last posts */
      foreach ($forums as $section_key => $section) {
        if ($section['childs']) {
          foreach ($section['childs'] as $child_key => $child) {
            $forums[$section_key]['childs'][$child_key]['last_post'] = $user->get_forum_last_post($child['forum_id']);
          }
        }
      }
      /* assign variables */
      $smarty->assign('forums', $forums);

      // rss feed
      if ($system['forums_rss_enabled']) {
        $smarty->assign('rss_url', $system['system_url'] . '/forums/rss');
      }

      // get recent threads
      $recent_threads = $user->get_forum_recent_threads();
      /* assign variables */
      $smarty->assign('recent_threads', $recent_threads);

      // get online users
      if ($system['forums_online_enabled']) {
        $online_users = $user->get_forum_online_users();
        /* assign variables */
        $smarty->assign('online_users', $online_users);
      }

      // get insights
      if ($system['forums_statistics_enabled']) {
        /* total threads */
        $get_threads = $db->query("SELECT COUNT(*) as count FROM forums_threads");
        $insights['threads'] = $get_threads->fetch_assoc()['count'];
        /* total replies */
        $get_replies = $db->query("SELECT COUNT(*) as count FROM forums_replies");
        $insights['replies'] = $get_replies->fetch_assoc()['count'];
        /* total users */
        $get_users = $db->query("SELECT COUNT(*) as count FROM users");
        $insights['users'] = $get_users->fetch_assoc()['count'];
        /* assign variables */
        $smarty->assign('insights', $insights);
      }
      break;

    case 'recent':
      // page header
      page_header(__("Forums") . " &rsaquo; " . __("Recent") . ' | ' . __($system['system_title']), __($system['system_description_forums']));

      // get threads
      $threads = $user->get_forum_threads(['all' => true, 'sort' => $_GET['sort']]);
      /* assign variables */
      $smarty->assign('threads', $threads);

      // rss feed
      if ($system['forums_rss_enabled']) {
        $smarty->assign('rss_url', $system['system_url'] . '/forums/rss');
      }
      break;

    case 'forum':
      // get forum
      $forum = $user->get_forum($_GET['forum_id']);
      if (!$forum) {
        _error(404);
      }
      /* get last posts */
      if ($forum['childs']) {
        foreach ($forum['childs'] as $child_key => $child) {
          $forum['childs'][$child_key]['last_post'] = $user->get_forum_last_post($child['forum_id']);
        }
      }
      /* get threads */
      if ($forum['forum_threads'] > 0) {
        $forum['threads'] = $user->get_forum_threads(['forum' => $forum, 'sort' => $_GET['sort']]);
      }
      /* assign variables */
      $smarty->assign('forum', $forum);

      // rss feed
      if ($system['forums_rss_enabled'] && $forum['forum_section'] != '0') {
        $smarty->assign('rss_url', $system['system_url'] . '/forums/' . $forum['forum_id'] . '/' . $forum['title_url'] . '/rss');
      }

      // page header
      page_header($forum['forum_name'] . ' | ' . __($system['system_title']), $forum['forum_description']);
      break;

    case 'thread':
      // get thread
      $thread = $user->get_forum_thread($_GET['thread_id'], true);
      if (!$thread) {
        _error(404);
      }
      /* get replies */
      if ($thread['replies'] > 0) {
        $thread['thread_replies'] = $user->get_forum_replies(['thread' => $thread, 'sort' => $_GET['sort']]);
      }
      /* get suggested threads */
      $thread['suggested_threads'] = $user->get_forum_suggested_threads($thread);
      /* get posters */
      $get_posters = $db->query(sprintf("SELECT COUNT(DISTINCT user_id) as count FROM forums_replies WHERE thread_id = %s AND user_id != %s", secure($thread['thread_id'], 'int'), secure($thread['user_id'], 'int')));
      $thread['posters'] = $get_posters->fetch_assoc()['count'] + 1;
      /* get navigator */
      $navigator['sort'] = ($_GET['sort'] == 'newest') ? 'newest' : 'oldest';
      $navigator['per_page'] = $system['max_results'] * 2;
      $navigator['page'] = (!isset($_GET['page']) || (int) $_GET['page'] == 0) ? 1 : (int) $_GET['page'];
      $navigator['last_page'] = max(1, (int) ceil($thread['replies'] / $navigator['per_page']));
      $navigator['offset'] = ($navigator['page'] - 1) * $navigator['per_page'];
      $navigator['total'] = $thread['replies'] + 1;
      /* assign variables */
      $smarty->assign('navigator', $navigator);
      /* get viewer like */
      $thread['i_like'] = in_array($thread['thread_id'], $user->get_forum_likes('thread', [$thread['thread_id']]));
      /* assign variables */
      $smarty->assign('thread', $thread);

      // rss feed
      if ($system['forums_rss_enabled']) {
        $smarty->assign('rss_url', $system['system_url'] . '/forums/thread/' . $thread['thread_id'] . '/' . $thread['title_url'] . '/rss');
      }

      // page header
      page_header($thread['title'], $thread['text_snippet']);
      break;

    case 'new-thread':
      // user access
      user_access();

      // page header
      page_header(__("Forums") . " &rsaquo; " . __("Write New Thread") . ' | ' . __($system['system_title']), __($system['system_description_forums']));

      // get forum
      if (isset($_GET['forum_id'])) {
        $forum = $user->get_forum($_GET['forum_id'], false);
        if (!$forum) {
          _error(404);
        }
        /* assign variables */
        $smarty->assign('forum', $forum);
      }
      break;

    case 'edit-thread':
      // user access
      user_access();

      // page header
      page_header(__("Forums") . " &rsaquo; " . __("Edit Thread") . ' | ' . __($system['system_title']), __($system['system_description_forums']));

      // get thread
      $thread = $user->get_forum_thread($_GET['thread_id']);
      if (!$thread) {
        _error(404);
      }
      /* assign variables */
      $smarty->assign('thread', $thread);
      break;

    case 'new-reply':
      // user access
      user_access();

      // page header
      page_header(__("Forums") . " &rsaquo; " . __("Post Reply") . ' | ' . __($system['system_title']), __($system['system_description_forums']));

      // get thread
      $thread = $user->get_forum_thread($_GET['thread_id']);
      if (!$thread) {
        _error(404);
      }
      /* assign variables */
      $smarty->assign('thread', $thread);
      break;

    case 'edit-reply':
      // user access
      user_access();

      // page header
      page_header(__("Forums") . " &rsaquo; " . __("Edit Reply") . ' | ' . __($system['system_title']), __($system['system_description_forums']));

      // get reply
      $reply = $user->get_forum_reply($_GET['reply_id']);
      if (!$reply) {
        _error(404);
      }
      /* assign variables */
      $smarty->assign('reply', $reply);
      break;

    case 'my-threads':
      // user access
      user_access();

      // page header
      page_header(__("Forums") . " &rsaquo; " . __("My Threads") . ' | ' . __($system['system_title']), __($system['system_description_forums']));

      // get threads
      $threads = $user->get_forum_threads(['user_id' => $user->_data['user_id']]);
      /* assign variables */
      $smarty->assign('threads', $threads);
      break;

    case 'my-replies':
      // user access
      user_access();

      // page header
      page_header(__("Forums") . " &rsaquo; " . __("My Replies") . ' | ' . __($system['system_title']), __($system['system_description_forums']));

      // get replies
      $replies = $user->get_forum_replies(['user_id' => $user->_data['user_id']]);
      /* assign variables */
      $smarty->assign('replies', $replies);
      break;

    case 'search':
      // page header
      page_header(__("Forums") . " &rsaquo; " . __("Search") . ' | ' . __($system['system_title']), __($system['system_description_forums']));
      break;

    case 'search-results':
      // page header
      page_header(__("Forums") . " &rsaquo; " . __("Search Results") . ' | ' . __($system['system_title']), __($system['system_description_forums']));

      if (!isset($_GET['query']) || !isset($_GET['type']) || !isset($_GET['forum'])) {
        redirect('/forums/search');
      }
      $results = $user->search_forums($_GET['query'], $_GET['type'], $_GET['forum'], $_GET['recursive']);
      $smarty->assign('query', htmlentities($_GET['query'], ENT_QUOTES, 'utf-8'));
      $smarty->assign('type', $_GET['type']);
      $smarty->assign('results', $results);
      break;

    default:
      _error(404);
      break;
  }
  // get forums
  if (in_array($_GET['view'], ['search', 'new-thread'])) {
    $forums = $user->get_forums();
    /* assign variables */
    $smarty->assign('forums', $forums);
  }
  /* assign variables */
  $smarty->assign('view', $_GET['view']);
} catch (Exception $e) {
  _error(__("Error"), $e->getMessage());
}

// page footer
page_footer('forums');
