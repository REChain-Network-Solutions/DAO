<?php

/**
 * trait -> shortcuts
 *
 * @package Sngine
 * @author Zamblek
 */

trait ShortcutsTrait
{

  /* ------------------------------- */
  /* Shortcuts */
  /* ------------------------------- */

  /**
   * get_shortcuts
   *
   * @param array $args
   * @return array
   */
  public function get_shortcuts($args = [])
  {
    global $db, $system;
    /* initialize arguments */
    $manage = !isset($args['manage']) ? false : $args['manage'];
    $query = !isset($args['query']) ? '' : trim($args['query']);
    $offset = !isset($args['offset']) ? 0 : $args['offset'];
    $results = !isset($args['results']) ? $system['max_results'] : $args['results'];
    /* initialize vars */
    $shortcuts = [];
    $offset *= $results;
    $state_statement = ($manage) ? "" : " AND users_shortcuts.state IN ('pinned', 'auto')";
    $query_statement = ($query != '') ? ' AND (pages.page_title LIKE %2$s OR `groups`.group_title LIKE %2$s OR `events`.event_title LIKE %2$s OR games.title LIKE %2$s)' : "";
    $get_shortcuts = $db->query(sprintf("SELECT users_shortcuts.node_id, users_shortcuts.node_type, users_shortcuts.state, pages.page_name, pages.page_title, pages.page_picture, `groups`.group_name, `groups`.group_title, `groups`.group_picture, `events`.event_title, `events`.event_cover, games.title AS game_title, games.thumbnail AS game_thumbnail FROM users_shortcuts LEFT JOIN pages ON users_shortcuts.node_type = 'page' AND users_shortcuts.node_id = pages.page_id LEFT JOIN `groups` ON users_shortcuts.node_type = 'group' AND users_shortcuts.node_id = `groups`.group_id LEFT JOIN `events` ON users_shortcuts.node_type = 'event' AND users_shortcuts.node_id = `events`.event_id LEFT JOIN games ON users_shortcuts.node_type = 'game' AND users_shortcuts.node_id = games.game_id WHERE users_shortcuts.user_id = %1\$s" . $state_statement . " AND (pages.page_id IS NOT NULL OR `groups`.group_id IS NOT NULL OR `events`.event_id IS NOT NULL OR games.game_id IS NOT NULL)" . $query_statement . " ORDER BY users_shortcuts.state ASC, users_shortcuts.time DESC, users_shortcuts.id DESC LIMIT %3\$s, %4\$s", secure($this->_data['user_id'], 'int'), secure($query, 'search'), secure($offset, 'int', false), secure($results, 'int', false)));
    while ($row = $get_shortcuts->fetch_assoc()) {
      $shortcut = ['node_id' => $row['node_id'], 'node_type' => $row['node_type'], 'state' => $row['state']];
      switch ($row['node_type']) {
        case 'page':
          $shortcut['title'] = $row['page_title'];
          $shortcut['picture'] = get_picture($row['page_picture'], 'page');
          $shortcut['url'] = $system['system_url'] . '/pages/' . $row['page_name'];
          break;

        case 'group':
          $shortcut['title'] = $row['group_title'];
          $shortcut['picture'] = get_picture($row['group_picture'], 'group');
          $shortcut['url'] = $system['system_url'] . '/groups/' . $row['group_name'];
          break;

        case 'event':
          $shortcut['title'] = $row['event_title'];
          $shortcut['picture'] = get_picture($row['event_cover'], 'event');
          $shortcut['url'] = $system['system_url'] . '/events/' . $row['node_id'];
          break;

        case 'game':
          $shortcut['title'] = $row['game_title'];
          $shortcut['picture'] = get_picture($row['game_thumbnail'], 'game');
          $shortcut['url'] = $system['system_url'] . '/games/' . $row['node_id'] . '/' . get_url_text($row['game_title']);
          break;
      }
      $shortcuts[] = $shortcut;
    }
    return $shortcuts;
  }


  /**
   * add_shortcut
   *
   * @param integer $node_id
   * @param string $node_type
   * @param integer $user_id
   * @return void
   */
  public function add_shortcut($node_id, $node_type, $user_id = null)
  {
    global $db, $date;
    $user_id = $user_id ?? $this->_data['user_id'];
    $db->query(sprintf("INSERT INTO users_shortcuts (user_id, node_id, node_type, time) VALUES (%s, %s, %s, %s) ON DUPLICATE KEY UPDATE time = VALUES(time)", secure($user_id, 'int'), secure($node_id, 'int'), secure($node_type), secure($date)));
  }


  /**
   * remove_shortcut
   *
   * @param integer $node_id
   * @param string $node_type
   * @param integer $user_id
   * @return void
   */
  public function remove_shortcut($node_id, $node_type, $user_id = null)
  {
    global $db;
    $user_id = $user_id ?? $this->_data['user_id'];
    $db->query(sprintf("DELETE FROM users_shortcuts WHERE user_id = %s AND node_type = %s AND node_id = %s", secure($user_id, 'int'), secure($node_type), secure($node_id, 'int')));
  }


  /**
   * delete_shortcuts
   *
   * @param integer $node_id
   * @param string $node_type
   * @return void
   */
  public function delete_shortcuts($node_id, $node_type)
  {
    global $db;
    $db->query(sprintf("DELETE FROM users_shortcuts WHERE node_type = %s AND node_id = %s", secure($node_type), secure($node_id, 'int')));
  }


  /**
   * update_shortcuts
   *
   * @param array $states
   * @return void
   */
  public function update_shortcuts($states)
  {
    global $db;
    if (!is_array($states)) {
      return;
    }
    foreach (array_slice($states, 0, 200, true) as $key => $state) {
      $node = explode(':', (string) $key);
      if (count($node) != 2 || !in_array($node[0], ['page', 'group', 'event', 'game']) || !is_numeric($node[1]) || !in_array($state, ['pinned', 'auto', 'hidden'], true)) {
        continue;
      }
      $db->query(sprintf("UPDATE users_shortcuts SET state = %s WHERE user_id = %s AND node_type = %s AND node_id = %s", secure($state), secure($this->_data['user_id'], 'int'), secure($node[0]), secure($node[1], 'int')));
    }
  }
}
