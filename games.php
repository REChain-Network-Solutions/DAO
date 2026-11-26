<?php

/**
 * games
 * 
 * @package Sngine
 * @author Zamblek
 */

// fetch bootloader
require('bootloader.php');

// games enabled
if (!$system['games_enabled']) {
  _error(404);
}

// user access
if ($user->_logged_in || !$system['system_public']) {
  user_access();
}

try {

  // get games genres
  $genres = $user->get_games_genres();
  /* assign variables */
  $smarty->assign('genres', $genres);

  // prepare filter
  $_GET['filter'] = (isset($_GET['filter'])) ? $_GET['filter'] : '';
  if (!in_array($_GET['filter'], ['', 'popular'])) {
    _error(404);
  }

  // prepare query args
  $args = ['filter' => $_GET['filter']];
  /* prepare pager url */
  $url = "";

  // get view content
  $_GET['view'] = (isset($_GET['view'])) ? $_GET['view'] : '';
  switch ($_GET['view']) {
    case '':
      // page header
      page_header(__("Games") . ' | ' . __($system['system_title']), __($system['system_description_games']));
      break;

    case 'search':
      // check query
      if (!isset($_GET['query']) || is_empty($_GET['query'])) {
        redirect('/games');
      }
      /* assign variables */
      $smarty->assign('query', htmlentities($_GET['query'], ENT_QUOTES, 'utf-8'));

      // prepare query
      $args['query'] = $_GET['query'];
      /* prepare pager url */
      $url = "/search/" . $_GET['query'];

      // page header
      page_header(__("Games") . ' | ' . __($system['system_title']), __($system['system_description_games']));
      break;

    case 'genre':
      // get genre
      $genre = $user->get_games_genre($_GET['genre_id']);
      if (!$genre) {
        _error(404);
      }
      /* assign variables */
      $smarty->assign('genre', $genre);

      // prepare query
      $args['genre_id'] = $genre['genre_id'];
      /* prepare pager url */
      $url = "/genre/" . $genre['genre_id'] . "/" . $genre['genre_url'];

      // page header
      page_header(__($genre['genre_name']) . ' - ' . __("Games") . ' | ' . __($system['system_title']), __($genre['genre_description']));
      break;

    case 'played':
      // user access
      user_access();

      // prepare query
      $args['filter'] = 'played';
      /* prepare pager url */
      $url = "/played";

      // page header
      page_header(__("Your Games"));
      break;

    case 'game':
      // games permission
      if ($user->_logged_in) {
        if (!$user->_data['can_play_games']) {
          _error('PERMISSION');
        }
      }

      // get game
      $game = $user->get_game($_GET['game_id']);
      if (!$game) {
        _error(404);
      }
      /* assign variables */
      $smarty->assign('game', $game);

      // get related games
      $related = [];
      if ($game['genres_list']) {
        $related = $user->get_games(['genre_id' => $game['genres_list'][0]['genre_id'], 'exclude' => $game['game_id'], 'limit' => 12]);
      }
      /* assign variables */
      $smarty->assign('related', $related);

      // page header
      page_header($game['title'], $game['description'], $game['thumbnail']);
      break;

    default:
      _error(404);
      break;
  }

  if ($_GET['view'] != "game") {

    // games home (featured carousel + rows), only on the unfiltered index
    $home = false;
    $popular = [];
    if ($_GET['view'] == "" && !$_GET['filter'] && (!isset($_GET['page']) || (int) $_GET['page'] <= 1)) {
      $recent = $user->get_games(['limit' => 17]);
      if ($recent) {
        $home = true;
        $popular = $user->get_games(['filter' => 'popular', 'limit' => 12]);
        /* prepare featured (each slide carries the next two as its stack) */
        $featured_source = array_slice($recent, 0, 5);
        $featured_count = count($featured_source);
        $featured = [];
        foreach ($featured_source as $_i => $_featured) {
          $_featured['stack'] = [];
          if ($featured_count > 1) {
            $_featured['stack'][] = $featured_source[($_i + 1) % $featured_count];
          }
          if ($featured_count > 2) {
            $_featured['stack'][] = $featured_source[($_i + 2) % $featured_count];
          }
          $featured[] = $_featured;
        }
        /* get genres rows */
        $genre_rows = [];
        foreach ($genres as $_genre) {
          if (count($genre_rows) >= 6) {
            break;
          }
          $_genre_games = $user->get_games(['genre_id' => $_genre['genre_id'], 'limit' => 12]);
          if ($_genre_games) {
            $genre_rows[] = ['genre' => $_genre, 'games' => $_genre_games];
          }
        }
        /* assign variables */
        $smarty->assign('featured', $featured);
        $smarty->assign('row_recent', (count($recent) > 5) ? array_slice($recent, 5, 12) : $recent);
        $smarty->assign('row_popular', $popular);
        $smarty->assign('row_played', $user->get_games(['filter' => 'played', 'limit' => 12]));
        $smarty->assign('genre_rows', $genre_rows);
      }
    }
    /* assign variables */
    $smarty->assign('home', $home);

    // get sidebar games
    $rail_games = ($popular) ? array_slice($popular, 0, 3) : $user->get_games(['filter' => 'popular', 'limit' => 3]);
    /* assign variables */
    $smarty->assign('rail_games', $rail_games);

    if (!$home) {
      // prepare pager
      require('includes/class-pager.php');
      $params['selected_page'] = (!isset($_GET['page']) || (int) $_GET['page'] == 0) ? 1 : $_GET['page'];
      $params['total_items'] = $user->count_games($args);
      $params['items_per_page'] = $system['games_results'];
      $params['url'] = $system['system_url'] . '/games' . $url . '/%s';
      if ($_GET['filter']) {
        $params['url'] .= "?filter=" . $_GET['filter'];
      }
      $pager = new Pager($params);

      // get games
      $args['limit'] = $params['items_per_page'];
      $args['offset'] = $pager->getOffset();
      $games = $user->get_games($args);
      /* assign variables */
      $smarty->assign('games', $games);
      $smarty->assign('total', $params['total_items']);
      $smarty->assign('pager', $pager->getPager());
    }

    // get ads
    $ads = $user->ads('games');
    /* assign variables */
    $smarty->assign('ads', $ads);
  }

  // assign view
  $smarty->assign('view', $_GET['view']);
  $smarty->assign('filter', $_GET['filter']);
} catch (Exception $e) {
  _error(__("Error"), $e->getMessage());
}

// page footer
page_footer('games');
