<?php

/**
 * movies
 * 
 * @package Sngine
 * @author Zamblek
 */

// fetch bootloader
require('bootloader.php');

// movies enabled
if (!$system['movies_enabled']) {
  _error(404);
}

// user access
if ($user->_logged_in || !$system['system_public']) {
  user_access();
}

try {

  // get movies genres
  $genres = $user->get_movies_genres();
  /* assign variables */
  $smarty->assign('genres', $genres);

  // prepare filter
  $_GET['filter'] = (isset($_GET['filter'])) ? $_GET['filter'] : '';
  if (!in_array($_GET['filter'], ['', 'trending', 'free', 'paid'])) {
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
      page_header(__("Movies") . ' | ' . __($system['system_title']), __($system['system_description_movies']));
      break;

    case 'search':
      // check query
      if (!isset($_GET['query']) || is_empty($_GET['query'])) {
        redirect('/movies');
      }
      /* assign variables */
      $smarty->assign('query', htmlentities($_GET['query'], ENT_QUOTES, 'utf-8'));

      // prepare query
      $args['query'] = $_GET['query'];
      /* prepare pager url */
      $url = "/search/" . $_GET['query'];

      // page header
      page_header(__("Movies") . ' | ' . __($system['system_title']), __($system['system_description_movies']));
      break;

    case 'genre':
      // get genre
      $genre = $user->get_movies_genre($_GET['genre_id']);
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
      page_header(__("Movies") . ' &rsaquo; ' . __($genre['genre_name']) . ' | ' . __($system['system_title']), __($genre['genre_description']));
      break;

    case 'movie':
      // movies permission
      if ($user->_logged_in) {
        if (!$user->_data['can_watch_movies']) {
          _error('PERMISSION');
        }
      }

      // get movie
      $movie = $user->get_movie($_GET['movie_id']);
      if (!$movie) {
        _error(404);
      }
      /* assign variables */
      $smarty->assign('movie', $movie);

      // get related movies
      $related = [];
      if ($movie['genres_list']) {
        $related = $user->get_movies(['genre_id' => $movie['genres_list'][0]['genre_id'], 'exclude' => $movie['movie_id'], 'limit' => $system['movies_results']]);
      }
      /* assign variables */
      $smarty->assign('related', $related);

      // page header
      page_header($movie['title'], $movie['description'], $movie['poster']);
      break;

    default:
      _error(404);
      break;
  }

  if ($_GET['view'] != "movie") {

    // movies home (featured carousel + rows), only on the unfiltered index
    $home = false;
    $trending = [];
    if ($_GET['view'] == "" && !$_GET['filter'] && (!isset($_GET['page']) || (int) $_GET['page'] <= 1)) {
      $recent = $user->get_movies(['limit' => 5 + $system['movies_results']]);
      if ($recent) {
        $home = true;
        $trending = $user->get_movies(['filter' => 'trending', 'limit' => $system['movies_results']]);
        /* get genres rows */
        $genre_rows = [];
        foreach ($genres as $_genre) {
          if (count($genre_rows) >= 6) {
            break;
          }
          $_genre_movies = $user->get_movies(['genre_id' => $_genre['genre_id'], 'limit' => $system['movies_results']]);
          if ($_genre_movies) {
            $genre_rows[] = ['genre' => $_genre, 'movies' => $_genre_movies];
          }
        }
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
        /* assign variables */
        $smarty->assign('featured', $featured);
        $smarty->assign('row_recent', (count($recent) > 5) ? array_slice($recent, 5, $system['movies_results']) : $recent);
        $smarty->assign('row_trending', $trending);
        $smarty->assign('genre_rows', $genre_rows);
      }
    }
    /* assign variables */
    $smarty->assign('home', $home);

    // get sidebar movies
    $rail_movies = ($trending) ? array_slice($trending, 0, 3) : $user->get_movies(['filter' => 'trending', 'limit' => 3]);
    /* assign variables */
    $smarty->assign('rail_movies', $rail_movies);

    if (!$home) {
      // prepare pager
      require('includes/class-pager.php');
      $params['selected_page'] = (!isset($_GET['page']) || (int) $_GET['page'] == 0) ? 1 : $_GET['page'];
      $params['total_items'] = $user->count_movies($args);
      $params['items_per_page'] = $system['movies_results'];
      $params['url'] = $system['system_url'] . '/movies' . $url . '/%s';
      if ($_GET['filter']) {
        $params['url'] .= "?filter=" . $_GET['filter'];
      }
      $pager = new Pager($params);

      // get movies
      $args['limit'] = $params['items_per_page'];
      $args['offset'] = $pager->getOffset();
      $movies = $user->get_movies($args);
      /* assign variables */
      $smarty->assign('movies', $movies);
      $smarty->assign('total', $params['total_items']);
      $smarty->assign('pager', $pager->getPager());
    }

    // get ads
    $ads = $user->ads('movies');
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
page_footer('movies');
