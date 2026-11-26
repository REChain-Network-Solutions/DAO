<?php

/**
 * trait -> games
 * 
 * @package Sngine
 * @author Zamblek
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
    $genres = [];
    if ($game_genres) {
      $map = $this->games_genres_map();
      foreach (explode(',', $game_genres) as $genre_id) {
        $genre_id = (int) trim($genre_id);
        if ($genre_id && isset($map[$genre_id])) {
          $genres[] = $map[$genre_id];
        }
      }
    }
    return $genres;
  }


  /**
   * games_genres_map
   * 
   * @return array
   */
  private function games_genres_map()
  {
    global $db;
    static $map = null;
    if ($map === null) {
      $map = [];
      $get_genres = $db->query("SELECT * FROM games_genres ORDER BY genre_order ASC");
      while ($genre = $get_genres->fetch_assoc()) {
        $genre['genre_url'] = get_url_text($genre['genre_name']);
        $map[$genre['genre_id']] = $genre;
      }
    }
    return $map;
  }


  /**
   * games_where_query
   * 
   * @param array $args
   * @return string
   */
  private function games_where_query($args = [])
  {
    $where = [];
    if (!empty($args['genre_id'])) {
      $where[] = sprintf("find_in_set(%s, games.genres) > 0", secure($args['genre_id'], 'int'));
    }
    if (!empty($args['query'])) {
      $where[] = sprintf('(games.title LIKE %1$s OR games.description LIKE %1$s)', secure($args['query'], 'search'));
    }
    if (!empty($args['exclude'])) {
      $where[] = sprintf("games.game_id != %s", secure($args['exclude'], 'int'));
    }
    return ($where) ? " WHERE " . implode(" AND ", $where) . " " : " ";
  }


  /**
   * decorate_game
   * 
   * @param array $game
   * @return array
   */
  private function decorate_game($game)
  {
    $game['thumbnail'] = get_picture($game['thumbnail'], 'game');
    $game['title_url'] = get_url_text($game['title']);
    $game['genres_list'] = $this->get_game_genres($game['genres']);
    $players = (int) (isset($game['players']) ? $game['players'] : 0);
    $game['players'] = $players;
    if ($players >= 1000000) {
      $game['players_text'] = round($players / 1000000, 1) . __("M");
    } elseif ($players >= 1000) {
      $game['players_text'] = round($players / 1000, 1) . __("K");
    } else {
      $game['players_text'] = $players;
    }
    return $game;
  }


  /**
   * get_games
   * 
   * @param array $args
   * @return array
   */
  public function get_games($args = [])
  {
    global $db;
    $games = [];
    $filter = (isset($args['filter'])) ? $args['filter'] : '';
    /* prepare limit query */
    $limit_query = "";
    if (!empty($args['limit'])) {
      $offset = (!empty($args['offset'])) ? $args['offset'] : 0;
      $limit_query = sprintf(" LIMIT %s, %s", secure($offset, 'int', false), secure($args['limit'], 'int', false));
    }
    /* your games: join the player rows of the viewer */
    if ($filter == 'played') {
      if (!$this->_logged_in) {
        return $games;
      }
      $get_games = $db->query(sprintf("SELECT games.*, games_players.last_played_time, (SELECT COUNT(DISTINCT user_id) FROM games_players WHERE game_id = games.game_id) AS players FROM games INNER JOIN games_players ON games.game_id = games_players.game_id AND games_players.user_id = %s" . $this->games_where_query($args) . " ORDER BY games_players.last_played_time DESC " . $limit_query, secure($this->_data['user_id'], 'int')));
    } else {
      $order_query = ($filter == 'popular') ? " ORDER BY players DESC, games.game_id DESC " : " ORDER BY games.game_id DESC ";
      $get_games = $db->query("SELECT games.*, (SELECT COUNT(DISTINCT user_id) FROM games_players WHERE game_id = games.game_id) AS players FROM games" . $this->games_where_query($args) . $order_query . $limit_query);
    }
    while ($game = $get_games->fetch_assoc()) {
      $game['played'] = (isset($game['last_played_time'])) ? $game['last_played_time'] : false;
      $games[] = $this->decorate_game($game);
    }
    return $games;
  }


  /**
   * count_games
   * 
   * @param array $args
   * @return integer
   */
  public function count_games($args = [])
  {
    global $db;
    $filter = (isset($args['filter'])) ? $args['filter'] : '';
    if ($filter == 'played') {
      if (!$this->_logged_in) {
        return 0;
      }
      $get_count = $db->query(sprintf("SELECT COUNT(*) AS count FROM games INNER JOIN games_players ON games.game_id = games_players.game_id AND games_players.user_id = %s" . $this->games_where_query($args), secure($this->_data['user_id'], 'int')));
    } else {
      $get_count = $db->query("SELECT COUNT(*) AS count FROM games" . $this->games_where_query($args));
    }
    return (int) $get_count->fetch_assoc()['count'];
  }


  /**
   * get_games_players
   * 
   * @param array $games_ids
   * @return array
   */
  public function get_games_players($games_ids)
  {
    global $db;
    $players = [];
    if (!$games_ids) {
      return $players;
    }
    $get_players = $db->query("SELECT game_id, COUNT(DISTINCT user_id) as count FROM games_players WHERE game_id IN (" . implode(',', array_map('intval', $games_ids)) . ") GROUP BY game_id");
    if ($get_players->num_rows > 0) {
      while ($player = $get_players->fetch_assoc()) {
        $players[$player['game_id']] = $player['count'];
      }
    }
    return $players;
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
    $get_game = $db->query(sprintf('SELECT games.*, (SELECT COUNT(DISTINCT user_id) FROM games_players WHERE game_id = games.game_id) AS players FROM games WHERE games.game_id = %s', secure($game_id, 'int')));
    if ($get_game->num_rows == 0) {
      return false;
    }
    $game = $this->decorate_game($get_game->fetch_assoc());
    /* check if the viewer played this game before */
    if ($this->_logged_in) {
      $db->query(sprintf("DELETE FROM games_players WHERE game_id = %s AND user_id = %s", secure($game['game_id'], 'int'), secure($this->_data['user_id'], 'int')));
      $db->query(sprintf("INSERT INTO games_players (game_id, user_id, last_played_time) VALUES (%s, %s, %s)", secure($game['game_id'], 'int'), secure($this->_data['user_id'], 'int'), secure($date)));
      /* add shortcut */
      $this->add_shortcut($game['game_id'], 'game');
    }
    return $game;
  }
}
