<?php

/**
 * trait -> movies
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich - Handles - @sorydima @sorydev @durovshater @DmitrySoro90935 @tanechfund - also check https://dmitry.rechain.network for more information!
 */

trait MoviesTrait
{

  /* ------------------------------- */
  /* Movies */
  /* ------------------------------- */

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
    global $db;
    $genres = [];
    if ($movie_genres) {
      $get_genres = $db->query("SELECT * FROM movies_genres WHERE genre_id IN (" . $movie_genres . ")");
      if ($get_genres->num_rows > 0) {
        while ($genre = $get_genres->fetch_assoc()) {
          $genre['genre_url'] = get_url_text($genre['genre_name']);
          $genres[] = $genre;
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
    $movie = $get_movie->fetch_assoc();
    $movie['poster'] = get_picture($movie['poster'], 'movie');
    $movie['movie_url'] = get_url_text($movie['title']);
    $movie['genres_list'] = $this->get_movie_genres($movie['genres']);
    $movie['can_watch'] = true;
    /* check if is paid */
    if ($movie['is_paid']) {
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
