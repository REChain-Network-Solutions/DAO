<?php

/**
 * trait -> games
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich - Handles - @sorydima @sorydev @durovshater @DmitrySoro90935 @tanechfund - also check https://dmitry.rechain.network for more information!
 */

trait GamesTrait
{

  /* ------------------------------- */
  /* Games */
  /* ------------------------------- */

  /**
   * get_games_genres
   * 
   * @param boolean $sorted
   * @return array
   */
  public function get_games_genres($sorted = true)
  {
    global $db;
    $genres = [];
    $order_query = ($sorted) ? " ORDER BY genre_order ASC " : " ORDER BY genre_id ASC ";
    $get_genres = $db->query("SELECT * FROM games_genres" . $order_query);
    if ($get_genres->num_rows > 0) {
      while ($genre = $get_genres->fetch_assoc()) {
        $genre['genre_url'] = get_url_text($genre['genre_name']);
        $genres[] = $genre;
      }
    }
    return $genres;
  }

  /**
   * get_games_genre
   * 
   * @param integer $genre_id
   * @return array
   */
  public function get_games_genre($genre_id)
  {
    global $db;
    $get_genre = $db->query(sprintf('SELECT * FROM games_genres WHERE genre_id = %s', secure($genre_id, 'int')));
    if ($get_genre->num_rows == 0) {
      return false;
    }
    $genre = $get_genre->fetch_assoc();
    $genre['genre_url'] = get_url_text($genre['genre_name']);
    return $genre;
  }


  /**
   * get_game_genres
   * 
   * @param string $game_genres
   * @return array
   */
  public function get_game_genres($game_genres)
  {
    global $db;
    $genres = [];
    if ($game_genres) {
      $get_genres = $db->query("SELECT * FROM games_genres WHERE genre_id IN (" . $game_genres . ")");
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
   * get_games
   * 
   * @param integer $offset
   * @param boolean $played
   * @param integer $genre_id
   * @return array
   */
  public function get_games($offset = 0, $played = false, $genre_id = null)
  {
    global $db, $system;
    $games = [];
    $offset *= $system['games_results'];
    if ($played) {
      $get_games = $db->query(sprintf('SELECT games.*, games_players.last_played_time FROM games INNER JOIN games_players ON games.game_id = games_players.game_id WHERE games_players.user_id = %s ORDER BY games_players.last_played_time DESC LIMIT %s, %s', secure($this->_data['user_id'], 'int'), secure($offset, 'int', false), secure($system['games_results'], 'int', false)));
    } else {
      $genre_statment = ($genre_id) ? sprintf("WHERE find_in_set(%s, genres) > 0", secure($genre_id, 'int')) : '';
      $get_games = $db->query(sprintf('SELECT * FROM games %s ORDER BY game_id DESC LIMIT %s, %s', $genre_statment, secure($offset, 'int', false), secure($system['games_results'], 'int', false)));
    }
    if ($get_games->num_rows > 0) {
      while ($game = $get_games->fetch_assoc()) {
        $game['thumbnail'] = get_picture($game['thumbnail'], 'game');
        $game['title_url'] = get_url_text($game['title']);
        $game['played'] = ($played) ? $game['last_played_time'] : false;
        $game['genres_list'] = $this->get_game_genres($game['genres']);
        $games[] = $game;
      }
    }
    return $games;
  }


  /**
   * get_game
   * 
   * @param integer $game_id
   * @return array
   */
  public function get_game($game_id)
  {
    global $db, $date;
    $get_game = $db->query(sprintf('SELECT * FROM games WHERE game_id = %s', secure($game_id, 'int')));
    if ($get_game->num_rows == 0) {
      return false;
    }
    $game = $get_game->fetch_assoc();
    $game['thumbnail'] = get_picture($game['thumbnail'], 'game');
    $game['genres_list'] = $this->get_game_genres($game['genres']);
    /* check if the viewer played this game before */
    if ($this->_logged_in) {
      $db->query(sprintf("DELETE FROM games_players WHERE game_id = %s AND user_id = %s", secure($game['game_id'], 'int'), secure($this->_data['user_id'], 'int')));
      $db->query(sprintf("INSERT INTO games_players (game_id, user_id, last_played_time) VALUES (%s, %s, %s)", secure($game['game_id'], 'int'), secure($this->_data['user_id'], 'int'), secure($date)));
    }
    return $game;
  }
}
