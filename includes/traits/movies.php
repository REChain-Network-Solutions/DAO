<?php

/**
 * trait -> movies
 * 
 * @package Sngine
 * @author Zamblek
 */

trait MoviesTrait
{

  /* ------------------------------- */
  /* Movies */
  /* ------------------------------- */

  /**
   * movies_genres_map
   * 
   * @return array
   */
  private function movies_genres_map()
  {
    global $db;
    static $map = null;
    if ($map === null) {
      $map = [];
      $get_genres = $db->query("SELECT * FROM movies_genres ORDER BY genre_order ASC");
      while ($genre = $get_genres->fetch_assoc()) {
        $genre['genre_url'] = get_url_text($genre['genre_name']);
        $map[$genre['genre_id']] = $genre;
      }
    }
    return $map;
  }


  /**
   * decorate_movie
   * 
   * @param array $movie
   * @return array
   */
  private function decorate_movie($movie)
  {
    $movie['poster'] = get_picture($movie['poster'], 'movie');
    $movie['movie_url'] = get_url_text($movie['title']);
    $movie['genres_list'] = $this->get_movie_genres($movie['genres']);
    /* duration */
    $movie['duration_text'] = '';
    $duration = (int) $movie['duration'];
    if ($duration > 0) {
      $movie['duration_text'] = ($duration >= 60) ? floor($duration / 60) . __("h") . ' ' . ($duration % 60) . __("m") : $duration . __("m");
    }
    /* views */
    $views = (int) $movie['views'];
    if ($views >= 1000000) {
      $movie['views_text'] = round($views / 1000000, 1) . __("M");
    } elseif ($views >= 1000) {
      $movie['views_text'] = round($views / 1000, 1) . __("K");
    } else {
      $movie['views_text'] = $views;
    }
    return $movie;
  }


  /**
   * movies_where_query
   * 
   * @param array $args
   * @return string
   */
  private function movies_where_query($args = [])
  {
    $where = [];
    /* filter */
    switch ((isset($args['filter'])) ? $args['filter'] : '') {
      case 'free':
        $where[] = "is_paid = '0'";
        break;

      case 'paid':
        $where[] = "is_paid = '1'";
        break;
    }
    /* genre */
    if (!empty($args['genre_id'])) {
      $where[] = sprintf("find_in_set(%s, genres) > 0", secure($args['genre_id'], 'int'));
    }
    /* search query */
    if (!empty($args['query'])) {
      $where[] = sprintf('(title LIKE %1$s OR description LIKE %1$s OR stars LIKE %1$s)', secure($args['query'], 'search'));
    }
    /* excluded movie */
    if (!empty($args['exclude'])) {
      $where[] = sprintf("movie_id != %s", secure($args['exclude'], 'int'));
    }
    return ($where) ? " WHERE " . implode(" AND ", $where) . " " : " ";
  }


  /**
   * get_movies
   * 
   * @param array $args
   * @return array
   */
  public function get_movies($args = [])
  {
    global $db;
    $movies = [];
    /* prepare order query */
    $order_query = ((isset($args['filter']) && $args['filter'] == 'trending')) ? " ORDER BY views DESC, movie_id DESC " : " ORDER BY movie_id DESC ";
    /* prepare limit query */
    $limit_query = "";
    if (!empty($args['limit'])) {
      $offset = (!empty($args['offset'])) ? $args['offset'] : 0;
      $limit_query = sprintf(" LIMIT %s, %s", secure($offset, 'int', false), secure($args['limit'], 'int', false));
    }
    $get_movies = $db->query("SELECT * FROM movies" . $this->movies_where_query($args) . $order_query . $limit_query);
    while ($movie = $get_movies->fetch_assoc()) {
      $movies[] = $this->decorate_movie($movie);
    }
    return $movies;
  }


  /**
   * count_movies
   * 
   * @param array $args
   * @return integer
   */
  public function count_movies($args = [])
  {
    global $db;
    $get_count = $db->query("SELECT COUNT(*) AS count FROM movies" . $this->movies_where_query($args));
    return (int) $get_count->fetch_assoc()['count'];
  }


  /**
   * get_movies_genres
   * 
   * @param boolean $sorted
   * @return array
   */
  public function get_movies_genres($sorted = true)
  {
    global $db;
    $genres = [];
    $order_query = ($sorted) ? " ORDER BY genre_order ASC " : " ORDER BY genre_id ASC ";
    $get_genres = $db->query("SELECT * FROM movies_genres" . $order_query);
    if ($get_genres->num_rows > 0) {
      while ($genre = $get_genres->fetch_assoc()) {
        $genre['genre_url'] = get_url_text($genre['genre_name']);
        $genres[] = $genre;
      }
    }
    return $genres;
  }

  /**
   * get_movies_genre
   * 
   * @param integer $genre_id
   * @return array
   */
  public function get_movies_genre($genre_id)
  {
    global $db;
    $get_genre = $db->query(sprintf('SELECT * FROM movies_genres WHERE genre_id = %s', secure($genre_id, 'int')));
    if ($get_genre->num_rows == 0) {
      return false;
    }
    $genre = $get_genre->fetch_assoc();
    $genre['genre_url'] = get_url_text($genre['genre_name']);
    return $genre;
  }


  /**
   * get_movie_genres
   * 
   * @param string $movie_genres
   * @return array
   */
  public function get_movie_genres($movie_genres)
  {
    $genres = [];
    if ($movie_genres) {
      $map = $this->movies_genres_map();
      foreach (explode(',', $movie_genres) as $genre_id) {
        $genre_id = (int) trim($genre_id);
        if ($genre_id && isset($map[$genre_id])) {
          $genres[] = $map[$genre_id];
        }
      }
    }
    return $genres;
  }


  /**
   * get_movie
   * 
   * @param integer $movie_id
   * @return array
   */
  public function get_movie($movie_id)
  {
    global $db;
    $get_movie = $db->query(sprintf('SELECT * FROM movies WHERE movie_id = %s', secure($movie_id, 'int')));
    if ($get_movie->num_rows == 0) {
      return false;
    }
    $movie = $this->decorate_movie($get_movie->fetch_assoc());
    $movie['can_watch'] = true;
    /* check if is paid (checkout needs Payments & Monetization) */
    $movie_checkout = licence_has_entitlement('monetization') && is_file(ABSPATH . 'includes/assets/js/core/payments.js');
    if ($movie['is_paid'] && $movie_checkout) {
      $movie['can_watch'] = false;
      if ($this->_logged_in) {
        if ($this->_data['user_group'] < 3) {
          $movie['can_watch'] = true;
        } else {
          $get_payment = $db->query(sprintf('SELECT COUNT(*) AS count FROM movies_payments WHERE movie_id = %s AND user_id = %s AND DATE_ADD(payment_time, INTERVAL %s DAY) > NOW()', secure($movie_id, 'int'), secure($this->_data['user_id'], 'int'), secure($movie['available_for'], 'int')));
          if ($get_payment->fetch_assoc()['count'] > 0) {
            $movie['can_watch'] = true;
          }
        }
      }
    }
    /* update views */
    if ($movie['can_watch']) {
      $db->query(sprintf("UPDATE movies SET views = views + 1 WHERE movie_id = %s", secure($movie_id, 'int')));
    }
    return $movie;
  }


  /**
   * movie_payment
   * 
   * @param integer $movie_id
   * @param integer $user_id
   * @return string
   */
  public function movie_payment($movie_id, $user_id = null)
  {
    global $system, $db, $date;
    /* check user */
    $user_id = ($user_id) ? $user_id : $this->_data['user_id'];
    /* get movie */
    $movie = $this->get_movie($movie_id);
    /* remove any previous payment */
    $db->query(sprintf("DELETE FROM movies_payments WHERE movie_id = %s AND user_id = %s", secure($movie_id, 'int'), secure($user_id, 'int')));
    /* add movie payment */
    $db->query(sprintf("INSERT INTO movies_payments (movie_id, user_id, payment_time) VALUES (%s, %s,  %s)", secure($movie_id, 'int'), secure($user_id, 'int'), secure($date)));
    /* return movie link */
    return '/movie/' . $movie['movie_id'] . '/' . $movie['movie_url'];
  }
}
