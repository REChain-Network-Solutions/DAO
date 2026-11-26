<?php

/**
 * trait -> forums
 * 
 * @package Sngine
 * @author Zamblek
 */

trait ForumsTrait
{

  /* ------------------------------- */
  /* Forums */
  /* ------------------------------- */

  /**
   * get_forums
   * 
   * @param integer $node_id
   * @param boolean $reverse
   * @return array
   */
  public function get_forums($node_id = 0, $reverse = false)
  {
    global $db;
    $tree = [];
    if (!$reverse) {
      // top-down tree (default)
      $get_nodes = $db->query(sprintf("SELECT * FROM forums WHERE forum_section = %s ORDER BY forum_order ASC", secure($node_id, 'int')));
      if ($get_nodes->num_rows > 0) {
        while ($node = $get_nodes->fetch_assoc()) {
          $node['title_url'] = get_url_text($node['forum_name']);
          $node['total_threads'] = $node['forum_threads'];
          $node['total_replies'] = $node['forum_replies'];
          $childs = $this->get_child_forums($node['forum_id']);
          if ($childs) {
            $node['total_threads'] += $childs['total_threads'];
            $node['total_replies'] += $childs['total_replies'];
            $node['childs'] = $childs['childs'];
          }
          $tree[] = $node;
        }
      }
    } else {
      // bottom-up tree
      while (true) {
        $get_parent = $db->query(sprintf("SELECT * FROM forums WHERE forum_id = %s", secure($node_id, 'int')));
        if ($get_parent->num_rows == 0) {
          break;
        }
        $parent = $get_parent->fetch_assoc();
        $parent['title_url'] = get_url_text($parent['forum_name']);
        $node_id = $parent['forum_section'];
        $tree[] = $parent;
        if ($node_id == 0) {
          break;
        }
      }
    }
    return $tree;
  }


  /**
   * get_child_forums
   * 
   * @param integer $node_id
   * @param integer $iteration
   * @return array
   */
  public function get_child_forums($node_id, $iteration = 1)
  {
    global $db;
    $tree = [];
    $get_nodes = $db->query(sprintf("SELECT * FROM forums WHERE forum_section = %s ORDER BY forum_order ASC", secure($node_id)));
    if ($get_nodes->num_rows > 0) {
      while ($node = $get_nodes->fetch_assoc()) {
        $node['iteration'] = $iteration;
        $node['title_url'] = get_url_text($node['forum_name']);
        $node['total_threads'] = $node['forum_threads'];
        $node['total_replies'] = $node['forum_replies'];
        $childs = $this->get_child_forums($node['forum_id'], $iteration + 1);
        if ($childs) {
          $node['total_threads'] += $childs['total_threads'];
          $node['total_replies'] += $childs['total_replies'];
          $node['childs'] = $childs['childs'];
        }
        $tree['total_threads'] += $node['total_threads'];
        $tree['total_replies'] += $node['total_replies'];
        $tree['childs'][] = $node;
      }
    }
    return $tree;
  }


  /**
   * get_child_forums_ids
   * 
   * @param array $nodes
   * @return void
   */
  public function get_child_forums_ids($nodes, &$list = [])
  {
    if (is_array($nodes)) {
      foreach ($nodes as $node) {
        $list[] = $node['forum_id'];
        if ($node['childs']) {
          $this->get_child_forums_ids($node['childs'], $list);
        }
      }
    }
  }


  /**
   * delete_forum
   * 
   * @param integer $node_id
   * @return void
   */
  public function delete_forum($node_id)
  {
    global $db;
    /* delete forum */
    $db->query(sprintf("DELETE FROM forums WHERE forum_id = %s", secure($node_id, 'int')));
    /* delete likes */
    $db->query(sprintf("DELETE FROM forums_likes WHERE node_type = 'reply' AND node_id IN (SELECT reply_id FROM forums_replies INNER JOIN forums_threads ON forums_replies.thread_id = forums_threads.thread_id WHERE forums_threads.forum_id = %s)", secure($node_id, 'int')));
    $db->query(sprintf("DELETE FROM forums_likes WHERE node_type = 'thread' AND node_id IN (SELECT thread_id FROM forums_threads WHERE forum_id = %s)", secure($node_id, 'int')));
    /* delete replies */
    $db->query(sprintf("DELETE FROM forums_replies WHERE thread_id IN (SELECT thread_id FROM forums_threads WHERE forum_id = %s)", secure($node_id, 'int')));
    /* delete threads */
    $db->query(sprintf("DELETE FROM forums_threads WHERE forum_id = %s", secure($node_id, 'int')));
    /* delete childs */
    $childs = $this->get_child_forums($node_id);
    if ($childs) {
      $this->delete_child_forums($childs['childs']);
    }
  }


  /**
   * delete_child_forums
   * 
   * @param array $nodes
   * @return void
   */
  public function delete_child_forums($nodes)
  {
    global $db;
    if (is_array($nodes)) {
      foreach ($nodes as $node) {
        /* delete forum */
        $db->query(sprintf("DELETE FROM forums WHERE forum_id = %s", secure($node['forum_id'], 'int')));
        /* delete likes */
        $db->query(sprintf("DELETE FROM forums_likes WHERE node_type = 'reply' AND node_id IN (SELECT reply_id FROM forums_replies INNER JOIN forums_threads ON forums_replies.thread_id = forums_threads.thread_id WHERE forums_threads.forum_id = %s)", secure($node['forum_id'], 'int')));
        $db->query(sprintf("DELETE FROM forums_likes WHERE node_type = 'thread' AND node_id IN (SELECT thread_id FROM forums_threads WHERE forum_id = %s)", secure($node['forum_id'], 'int')));
        /* delete replies */
        $db->query(sprintf("DELETE FROM forums_replies WHERE thread_id IN (SELECT thread_id FROM forums_threads WHERE forum_id = %s)", secure($node['forum_id'], 'int')));
        /* delete threads */
        $db->query(sprintf("DELETE FROM forums_threads WHERE forum_id = %s", secure($node['forum_id'], 'int')));
        /* delete childs */
        if ($node['childs']) {
          $this->delete_child_forums($node['childs']);
        }
      }
    }
  }


  /**
   * get_forum
   * 
   * @param integer $forum_id
   * @param boolean $get_childs
   * @return array
   */
  public function get_forum($forum_id, $get_childs = true)
  {
    global $db;
    $get_forum = $db->query(sprintf("SELECT * FROM forums WHERE forum_id = %s", secure($forum_id, 'int')));
    if ($get_forum->num_rows == 0) {
      return false;
    }
    $forum = $get_forum->fetch_assoc();
    $forum['title_url'] = get_url_text($forum['forum_name']);
    $forum['total_threads'] = $forum['forum_threads'];
    $forum['total_replies'] = $forum['forum_replies'];
    if ($get_childs) {
      $childs = $this->get_child_forums($forum['forum_id']);
      if ($childs) {
        $forum['total_threads'] += $childs['total_threads'];
        $forum['total_replies'] += $childs['total_replies'];
        $forum['childs'] = $childs['childs'];
      }
    }
    $forum['parents'] = $this->get_forums($forum['forum_section'], true);
    return $forum;
  }


  /**
   * get_forum_last_post
   * 
   * @param integer $forum_id
   * @return array
   */
  public function get_forum_last_post($forum_id)
  {
    global $db, $system;
    $get_thread = $db->query(sprintf("SELECT forums_threads.thread_id, forums_threads.title, forums_threads.text, forums_threads.time, forums_threads.replies, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM forums_threads INNER JOIN users ON forums_threads.user_id = users.user_id WHERE forums_threads.forum_id = %s ORDER BY forums_threads.last_reply DESC LIMIT 1", secure($forum_id, 'int')));
    if ($get_thread->num_rows == 0) {
      return false;
    }
    $post = $get_thread->fetch_assoc();
    $post['title_url'] = get_url_text($post['title']);
    /* get last reply */
    if ($post['replies'] > 0) {
      $get_reply = $db->query(sprintf("SELECT forums_replies.reply_id, forums_replies.text, forums_replies.time, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM forums_replies INNER JOIN users ON forums_replies.user_id = users.user_id WHERE forums_replies.thread_id = %s ORDER BY forums_replies.reply_id DESC LIMIT 1", secure($post['thread_id'], 'int')));
      if ($get_reply->num_rows > 0) {
        $post = array_merge($post, $get_reply->fetch_assoc());
      }
    }
    $post['user_picture'] = get_picture($post['user_picture'], $post['user_gender']);
    $post['user_fullname'] = ($system['show_usernames_enabled']) ? $post['user_name'] : $post['user_firstname'] . " " . $post['user_lastname'];
    $post['text_snippet'] = get_snippet_text($post['text']);
    unset($post['text']);
    return $post;
  }


  /**
   * get_forum_threads
   * 
   * @param array $args
   * @return array
   */
  public function get_forum_threads($args = [])
  {
    global $db, $system, $smarty;
    /* initialize vars */
    $threads = [];
    /* initialize arguments */
    $forum = !isset($args['forum']) ? null : $args['forum'];
    $user_id = !isset($args['user_id']) ? null : $args['user_id'];
    $query = !isset($args['query']) ? null : $args['query'];
    $all = !isset($args['all']) ? false : $args['all'];
    $sort = !isset($args['sort']) ? 'latest' : $args['sort'];
    /* prepare order statement */
    switch ($sort) {
      case 'top':
        $order = " ORDER BY forums_threads.replies DESC, forums_threads.thread_id DESC ";
        break;

      case 'newest':
        $order = " ORDER BY forums_threads.thread_id DESC ";
        break;

      case 'oldest':
        $order = " ORDER BY forums_threads.thread_id ASC ";
        break;

      default:
        $sort = 'latest';
        $order = ($forum !== null || $all) ? " ORDER BY forums_threads.is_pinned DESC, forums_threads.last_reply DESC, forums_threads.thread_id DESC " : " ORDER BY forums_threads.last_reply DESC, forums_threads.thread_id DESC ";
        break;
    }
    /* prepare select statement */
    $select = "SELECT forums_threads.*, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, last_users.user_name AS last_user_name, last_users.user_firstname AS last_user_firstname, last_users.user_lastname AS last_user_lastname FROM forums_threads INNER JOIN users ON forums_threads.user_id = users.user_id LEFT JOIN users AS last_users ON forums_threads.last_reply_user_id = last_users.user_id ";
    /* get threads */
    if ($forum !== null) {
      $get_total = $db->query(sprintf("SELECT COUNT(*) as count FROM forums_threads WHERE forum_id = %s", secure($forum['forum_id'], 'int')));
    } elseif ($all) {
      $get_total = $db->query("SELECT COUNT(*) as count FROM forums_threads");
    } elseif ($user_id !== null) {
      $get_total = $db->query(sprintf("SELECT COUNT(*) as count FROM forums_threads WHERE user_id = %s", secure($user_id, 'int')));
    } elseif ($query !== null) {
      /* prepare where statement */
      $where = "";
      /* query */
      $where .= (!is_empty($query)) ? sprintf(' WHERE title LIKE %1$s OR text LIKE %1$s ', secure($query, 'search')) : "";
      /* forums list */
      if ($args['forums_list']) {
        $forums_list = $this->spread_ids($args['forums_list']);
        $where = ($where != '') ? $where . " AND forum_id IN ($forums_list) " : $where;
      }
      $get_total = $db->query("SELECT COUNT(*) as count FROM forums_threads" . $where);
    }
    $total_items = $get_total->fetch_assoc()['count'];
    if ($total_items > 0) {
      require('includes/class-pager.php');
      $params['selected_page'] = (!isset($_GET['page']) || (int) $_GET['page'] == 0) ? 1 : $_GET['page'];
      $params['total_items'] = $total_items;
      $params['items_per_page'] = $system['max_results'] * 2;
      /* prepare pager URL */
      if ($forum !== null) {
        $params['url'] = $system['system_url'] . '/forums/' . $forum['forum_id'] . '/' . $forum['title_url'] . '?sort=' . $sort . '&page=%s';
      } elseif ($all) {
        $params['url'] = $system['system_url'] . '/forums/recent?sort=' . $sort . '&page=%s';
      } elseif ($user_id !== null) {
        $params['url'] = $system['system_url'] . '/forums/my-threads?page=%s';
      } elseif ($query !== null) {
        $params['url'] = remove_querystring_var($_SERVER['REQUEST_URI'], 'page');
        $params['url'] = $params['url'] . '&page=%s';
      }
      $pager = new Pager($params);
      $limit_query = $pager->getLimitSql();
      if ($forum !== null) {
        $get_threads = paged_query($select . sprintf("WHERE forums_threads.forum_id = %s", secure($forum['forum_id'], 'int')) . $order, 'forums_threads.thread_id', $limit_query);
      } elseif ($all) {
        $get_threads = paged_query($select . $order, 'forums_threads.thread_id', $limit_query);
      } elseif ($user_id !== null) {
        $get_threads = paged_query($select . sprintf("WHERE forums_threads.user_id = %s", secure($user_id, 'int')) . $order, 'forums_threads.thread_id', $limit_query);
      } elseif ($query !== null) {
        $get_threads = paged_query($select . $where . $order, 'forums_threads.thread_id', $limit_query);
      }
      $forums = [];
      while ($thread = $get_threads->fetch_assoc()) {
        $thread['user_picture'] = get_picture($thread['user_picture'], $thread['user_gender']);
        $thread['user_fullname'] = ($system['show_usernames_enabled']) ? $thread['user_name'] : $thread['user_firstname'] . " " . $thread['user_lastname'];
        if ($thread['last_user_name']) {
          $thread['last_user_fullname'] = ($system['show_usernames_enabled']) ? $thread['last_user_name'] : $thread['last_user_firstname'] . " " . $thread['last_user_lastname'];
        }
        $thread['title_url'] = get_url_text($thread['title']);
        /* parse text */
        $thread['parsed_text'] = htmlspecialchars_decode($thread['text'], ENT_QUOTES);
        $thread['text_snippet'] = get_snippet_text($thread['text']);
        /* get forum */
        if (!$forum) {
          if (!isset($forums[$thread['forum_id']])) {
            $forums[$thread['forum_id']] = $this->get_forum($thread['forum_id'], false);
          }
          $thread['forum'] = $forums[$thread['forum_id']];
        }
        $threads[] = $thread;
      }
      /* get last posts */
      $threads = $this->get_forum_threads_last_posts($threads);
      /* assign variables */
      $smarty->assign('total', $params['total_items']);
      $smarty->assign('pager', $pager->getPager());
    }
    $smarty->assign('sort', $sort);
    return $threads;
  }


  /**
   * get_forum_threads_last_posts
   * 
   * @param array $threads
   * @return array
   */
  public function get_forum_threads_last_posts($threads)
  {
    global $db, $system;
    $threads_ids = [];
    foreach ($threads as $key => $thread) {
      $threads[$key]['last_post'] = ['user_name' => $thread['user_name'], 'user_fullname' => $thread['user_fullname'], 'user_picture' => $thread['user_picture'], 'time' => $thread['time'], 'text_snippet' => get_snippet_text($thread['text'])];
      if ($thread['replies'] > 0) {
        $threads_ids[$thread['thread_id']] = $key;
      }
    }
    if ($threads_ids) {
      $get_replies = $db->query(sprintf("SELECT forums_replies.reply_id, forums_replies.thread_id, forums_replies.text, forums_replies.time, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM forums_replies INNER JOIN users ON forums_replies.user_id = users.user_id WHERE forums_replies.reply_id IN (SELECT MAX(reply_id) FROM forums_replies WHERE thread_id IN (%s) GROUP BY thread_id)", implode(',', array_map('intval', array_keys($threads_ids)))));
      while ($reply = $get_replies->fetch_assoc()) {
        $reply['user_picture'] = get_picture($reply['user_picture'], $reply['user_gender']);
        $reply['user_fullname'] = ($system['show_usernames_enabled']) ? $reply['user_name'] : $reply['user_firstname'] . " " . $reply['user_lastname'];
        $reply['text_snippet'] = get_snippet_text($reply['text']);
        unset($reply['text']);
        $threads[$threads_ids[$reply['thread_id']]]['last_post'] = $reply;
      }
    }
    return $threads;
  }


  /**
   * get_forum_recent_threads
   * 
   * @param integer $limit
   * @return array
   */
  public function get_forum_recent_threads($limit = 5)
  {
    global $db, $system;
    $threads = [];
    $get_threads = $db->query(sprintf("SELECT forums_threads.thread_id, forums_threads.title, forums_threads.time, forums_threads.replies, forums_threads.last_reply, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM forums_threads INNER JOIN users ON forums_threads.user_id = users.user_id ORDER BY forums_threads.is_pinned DESC, forums_threads.last_reply DESC, forums_threads.thread_id DESC LIMIT %s", secure($limit, 'int', false)));
    while ($thread = $get_threads->fetch_assoc()) {
      $thread['user_picture'] = get_picture($thread['user_picture'], $thread['user_gender']);
      $thread['user_fullname'] = ($system['show_usernames_enabled']) ? $thread['user_name'] : $thread['user_firstname'] . " " . $thread['user_lastname'];
      $thread['title_url'] = get_url_text($thread['title']);
      $threads[] = $thread;
    }
    return $threads;
  }


  /**
   * get_forum_suggested_threads
   * 
   * @param array $thread
   * @return array
   */
  public function get_forum_suggested_threads($thread)
  {
    global $db, $system;
    $threads = [];
    $get_threads = $db->query(sprintf("SELECT forums_threads.*, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM forums_threads INNER JOIN users ON forums_threads.user_id = users.user_id WHERE forums_threads.forum_id = %s AND forums_threads.thread_id != %s ORDER BY forums_threads.last_reply DESC LIMIT 5", secure($thread['forum_id'], 'int'), secure($thread['thread_id'], 'int')));
    while ($suggested = $get_threads->fetch_assoc()) {
      $suggested['user_picture'] = get_picture($suggested['user_picture'], $suggested['user_gender']);
      $suggested['user_fullname'] = ($system['show_usernames_enabled']) ? $suggested['user_name'] : $suggested['user_firstname'] . " " . $suggested['user_lastname'];
      $suggested['title_url'] = get_url_text($suggested['title']);
      $suggested['forum'] = $thread['forum'];
      $threads[] = $suggested;
    }
    return $this->get_forum_threads_last_posts($threads);
  }


  /**
   * get_forum_thread
   * 
   * @param integer $thread_id
   * @param boolean $update_views
   * @return array
   */
  public function get_forum_thread($thread_id, $update_views = false)
  {
    global $db, $system;
    $get_thread = $db->query(sprintf("SELECT forums_threads.*, users.user_group, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, users.user_registered FROM forums_threads INNER JOIN users ON forums_threads.user_id = users.user_id WHERE thread_id = %s", secure($thread_id, 'int')));
    if ($get_thread->num_rows == 0) {
      return false;
    }
    $thread = $get_thread->fetch_assoc();
    /* get forum */
    $thread['forum'] = $this->get_forum($thread['forum_id'], false);
    if (!$thread['forum']) {
      return false;
    }
    $thread['user_picture'] = get_picture($thread['user_picture'], $thread['user_gender']);
    $thread['user_fullname'] = ($system['show_usernames_enabled']) ? $thread['user_name'] : $thread['user_firstname'] . " " . $thread['user_lastname'];
    $thread['title_url'] = get_url_text($thread['title']);
    /* parse text */
    $thread['parsed_text'] = htmlspecialchars_decode($thread['text'], ENT_QUOTES);
    $thread['text_snippet'] = get_snippet_text($thread['text']);
    /* check if viewer can manage thread [Edit|Delete] */
    $thread['manage_thread'] = false;
    /* check if viewer can moderate thread [Pin|Lock] */
    $thread['moderate_thread'] = false;
    if ($this->_logged_in) {
      /* viewer is (admin|moderator) */
      if ($this->_data['user_group'] < 3) {
        $thread['manage_thread'] = true;
        $thread['moderate_thread'] = true;
      }
      /* viewer is the author of thread */
      if ($this->_data['user_id'] == $thread['user_id']) {
        $thread['manage_thread'] = true;
      }
    }
    /* update thread views */
    if ($update_views) {
      $db->query(sprintf("UPDATE forums_threads SET views = views + 1 WHERE thread_id = %s", secure($thread['thread_id'], 'int')));
    }
    return $thread;
  }


  /**
   * post_forum_thread
   * 
   * @param string $forum_id
   * @param string $title
   * @param string $text
   * @return integer
   */
  public function post_forum_thread($forum_id, $title, $text)
  {
    global $db, $system, $date;
    /* check if forums enabled */
    if (!$system['forums_enabled']) {
      throw new Exception(__("The forums module has been disabled by the admin"));
    }
    /* check forums permission */
    if (!$this->_data['can_use_forums']) {
      throw new Exception(__("You don't have the permission to do this"));
    }
    /* get forum */
    $forum = $this->get_forum($forum_id, false);
    /* check forum */
    if (!$forum) {
      _error(403);
    }
    if ($forum['forum_section'] == 0) {
      throw new Exception(__("You can't add a thread to a main section"));
    }
    /* validate title */
    if (is_empty($title)) {
      throw new Exception(__("You must enter a title for your thread"));
    }
    if (strlen($title) < 3) {
      throw new Exception(__("Thread title must be at least 3 characters long. Please try another"));
    }
    /* validate text */
    if (is_empty($text)) {
      throw new Exception(__("You must enter some text for your thread"));
    }
    if ($system['html_richtext_enabled']) {
      $clean_text = $text;
    } else {
      /* HTMLPurifier */
      $purifier = get_html_purifier();
      $clean_text = $purifier->purify($text);
    }
    /* insert thread */
    $db->query(sprintf("INSERT INTO forums_threads (forum_id, user_id, title, text, time, last_reply) VALUES (%s, %s, %s, %s, %s, %s)", secure($forum_id, 'int'), secure($this->_data['user_id'], 'int'), secure($title), secure($clean_text), secure($date), secure($date)));
    $thread_id = $db->insert_id;
    /* update forum */
    $db->query(sprintf("UPDATE forums SET forum_threads = forum_threads + 1 WHERE forum_id = %s", secure($forum_id, 'int')));
    /* extract hosted images from the text */
    $uploaded_images = extract_uploaded_images_from_text($clean_text);
    /* remove pending uploads */
    if ($uploaded_images) {
      remove_pending_uploads($uploaded_images);
    }
    return $thread_id;
  }


  /**
   * edit_forum_thread
   * 
   * @param string $thread_id
   * @param string $title
   * @param string $text
   * @return void
   */
  public function edit_forum_thread($thread_id, $title, $text)
  {
    global $db, $system;
    /* check if forums enabled */
    if (!$system['forums_enabled']) {
      throw new Exception(__("The forums module has been disabled by the admin"));
    }
    /* check forums permission */
    if (!$this->_data['can_use_forums']) {
      throw new Exception(__("You don't have the permission to do this"));
    }
    /* get thread */
    $thread = $this->get_forum_thread($thread_id);
    /* check thread */
    if (!$thread) {
      _error(403);
    }
    /* check permission */
    if (!$thread['manage_thread']) {
      _error(403);
    }
    /* validate title */
    if (is_empty($title)) {
      throw new Exception(__("You must enter a title for your thread"));
    }
    if (strlen($title) < 3) {
      throw new Exception(__("Thread title must be at least 3 characters long. Please try another"));
    }
    /* validate text */
    if (is_empty($text)) {
      throw new Exception(__("You must enter some text for your thread"));
    }
    if ($system['html_richtext_enabled']) {
      $clean_text = $text;
    } else {
      /* HTMLPurifier */
      $purifier = get_html_purifier();
      $clean_text = $purifier->purify($text);
    }
    /* edit thread */
    $db->query(sprintf("UPDATE forums_threads SET title = %s, text = %s WHERE thread_id = %s", secure($title), secure($clean_text), secure($thread_id, 'int')));
    /* extract hosted images from the text */
    $uploaded_images = extract_uploaded_images_from_text($clean_text);
    /* remove pending uploads */
    if ($uploaded_images) {
      remove_pending_uploads($uploaded_images);
    }
  }


  /**
   * delete_forum_thread
   * 
   * @param string $thread_id
   * @return array
   */
  public function delete_forum_thread($thread_id)
  {
    global $db, $system;
    /* check if forums enabled */
    if (!$system['forums_enabled']) {
      throw new Exception(__("The forums module has been disabled by the admin"));
    }
    /* check forums permission */
    if (!$this->_data['can_use_forums']) {
      throw new Exception(__("You don't have the permission to do this"));
    }
    /* get thread */
    $thread = $this->get_forum_thread($thread_id);
    /* check thread */
    if (!$thread) {
      _error(403);
    }
    /* check permission */
    if (!$thread['manage_thread']) {
      _error(403);
    }
    /* delete thread */
    $db->query(sprintf("DELETE FROM forums_threads WHERE thread_id = %s", secure($thread_id, 'int')));
    /* delete likes */
    $db->query(sprintf("DELETE FROM forums_likes WHERE node_type = 'thread' AND node_id = %s", secure($thread_id, 'int')));
    $db->query(sprintf("DELETE FROM forums_likes WHERE node_type = 'reply' AND node_id IN (SELECT reply_id FROM forums_replies WHERE thread_id = %s)", secure($thread_id, 'int')));
    /* delete replies */
    $db->query(sprintf("DELETE FROM forums_replies WHERE thread_id = %s", secure($thread_id, 'int')));
    /* update forum */
    $db->query(sprintf("UPDATE forums SET forum_threads = IF(forum_threads=0,0,forum_threads-1), forum_replies = IF(forum_replies=0,0,forum_replies-%s) WHERE forum_id = %s", secure($thread['replies'], 'int'), secure($thread['forum']['forum_id'], 'int')));
    return $thread['forum'];
  }


  /**
   * get_forum_replies
   * 
   * @param array $args
   * @return array
   */
  public function get_forum_replies($args = [])
  {
    global $db, $system, $smarty;
    /* initialize vars */
    $replies = [];
    /* initialize arguments */
    $thread = !isset($args['thread']) ? null : $args['thread'];
    $user_id = !isset($args['user_id']) ? null : $args['user_id'];
    $query = !isset($args['query']) ? null : $args['query'];
    $sort = (isset($args['sort']) && $args['sort'] == 'newest') ? 'newest' : 'oldest';
    /* get replies */
    if ($thread !== null) {
      $get_total = $db->query(sprintf("SELECT COUNT(*) as count FROM forums_replies WHERE thread_id = %s", secure($thread['thread_id'], 'int')));
    } elseif ($user_id !== null) {
      $get_total = $db->query(sprintf("SELECT COUNT(*) as count FROM forums_replies WHERE user_id = %s", secure($user_id, 'int')));
    } elseif ($query !== null) {
      /* prepare where statement */
      $where = "";
      /* query */
      $where .= (!is_empty($query)) ? sprintf(' WHERE forums_replies.text LIKE %1$s ', secure($query, 'search')) : "";
      /* forums list */
      if ($args['forums_list']) {
        $forums_list = $this->spread_ids($args['forums_list']);
        $where = ($where != '') ? $where . " AND forums_threads.forum_id IN ($forums_list) " : $where;
      }
      $get_total = $db->query("SELECT COUNT(*) as count FROM forums_replies INNER JOIN forums_threads ON forums_replies.thread_id = forums_threads.thread_id" . $where);
    }
    $total_items = $get_total->fetch_assoc()['count'];
    if ($total_items > 0) {
      require('includes/class-pager.php');
      $params['selected_page'] = (!isset($_GET['page']) || (int) $_GET['page'] == 0) ? 1 : $_GET['page'];
      $params['total_items'] = $total_items;
      $params['items_per_page'] = $system['max_results'] * 2;
      /* prepare pager URL */
      if ($thread !== null) {
        $params['url'] = $system['system_url'] . '/forums/thread/' . $thread['thread_id'] . '/' . $thread['title_url'] . '?sort=' . $sort . '&page=%s';
      } elseif ($user_id !== null) {
        $params['url'] = $system['system_url'] . '/forums/my-replies?page=%s';
      } elseif ($query !== null) {
        $params['url'] = remove_querystring_var($_SERVER['REQUEST_URI'], 'page');
        $params['url'] = $params['url'] . '&page=%s';
      }
      $pager = new Pager($params);
      $limit_query = $pager->getLimitSql();
      if ($thread !== null) {
        $get_replies = paged_query(sprintf("SELECT forums_replies.*, users.user_group, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, users.user_registered FROM forums_replies INNER JOIN users ON forums_replies.user_id = users.user_id WHERE forums_replies.thread_id = %s ORDER BY forums_replies.reply_id " . (($sort == 'newest') ? "DESC" : "ASC") . " ", secure($thread['thread_id'], 'int')), 'forums_replies.reply_id', $limit_query);
      } elseif ($user_id !== null) {
        $get_replies = paged_query(sprintf("SELECT forums_replies.*, users.user_group, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, users.user_registered FROM forums_replies INNER JOIN users ON forums_replies.user_id = users.user_id WHERE forums_replies.user_id = %s ORDER BY forums_replies.reply_id DESC ", secure($user_id, 'int')), 'forums_replies.reply_id', $limit_query);
      } elseif ($query !== null) {
        $get_replies = paged_query("SELECT forums_replies.*, users.user_group, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, users.user_registered FROM forums_replies INNER JOIN forums_threads ON forums_replies.thread_id = forums_threads.thread_id INNER JOIN users ON forums_replies.user_id = users.user_id " . $where . " ORDER BY forums_replies.reply_id DESC ", 'forums_replies.reply_id', $limit_query);
      }
      while ($reply = $get_replies->fetch_assoc()) {
        $reply['user_picture'] = get_picture($reply['user_picture'], $reply['user_gender']);
        $reply['user_fullname'] = ($system['show_usernames_enabled']) ? $reply['user_name'] : $reply['user_firstname'] . " " . $reply['user_lastname'];
        /* parse text */
        $reply['parsed_text'] = htmlspecialchars_decode($reply['text'], ENT_QUOTES);
        $reply['text_snippet'] = get_snippet_text($reply['text']);
        /* check if viewer can manage reply [Edit|Delete] */
        $reply['manage_reply'] = false;
        if ($this->_logged_in) {
          /* viewer is (admin|moderator) */
          if ($this->_data['user_group'] < 3) {
            $reply['manage_reply'] = true;
          }
          /* viewer is the author of reply */
          if ($this->_data['user_id'] == $reply['user_id']) {
            $reply['manage_reply'] = true;
          }
        }
        /* get thread */
        if (!$thread) {
          $reply['thread'] = $this->get_forum_thread($reply['thread_id']);
        }
        $replies[] = $reply;
      }
      /* get quoted replies */
      if ($thread !== null && $replies) {
        $quotes = $this->get_forum_replies_quotes(array_filter(array_column($replies, 'reply_to_id')));
        foreach ($replies as $key => $reply) {
          if ($reply['reply_to_id'] && isset($quotes[$reply['reply_to_id']])) {
            $replies[$key]['reply_to'] = $quotes[$reply['reply_to_id']];
          }
        }
      }
      /* get viewer likes */
      if ($thread !== null && $replies) {
        $liked_replies = $this->get_forum_likes('reply', array_column($replies, 'reply_id'));
        foreach ($replies as $key => $reply) {
          $replies[$key]['i_like'] = in_array($reply['reply_id'], $liked_replies);
        }
      }
      /* assign variables */
      $smarty->assign('selected_page', $params['selected_page']);
      $smarty->assign('total', $params['total_items']);
      $smarty->assign('pager', $pager->getPager());
    }
    return $replies;
  }


  /**
   * get_forum_replies_quotes
   * 
   * @param array $ids
   * @return array
   */
  public function get_forum_replies_quotes($ids)
  {
    global $db, $system;
    $quotes = [];
    if (!$ids) {
      return $quotes;
    }
    $get_replies = $db->query(sprintf("SELECT forums_replies.reply_id, forums_replies.thread_id, forums_replies.text, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM forums_replies INNER JOIN users ON forums_replies.user_id = users.user_id WHERE forums_replies.reply_id IN (%s)", implode(',', array_map('intval', $ids))));
    while ($reply = $get_replies->fetch_assoc()) {
      $reply['user_picture'] = get_picture($reply['user_picture'], $reply['user_gender']);
      $reply['user_fullname'] = ($system['show_usernames_enabled']) ? $reply['user_name'] : $reply['user_firstname'] . " " . $reply['user_lastname'];
      $reply['text_snippet'] = get_snippet_text($reply['text']);
      unset($reply['text']);
      $quotes[$reply['reply_id']] = $reply;
    }
    return $quotes;
  }


  /**
   * get_forum_reply
   * 
   * @param integer $reply_id
   * @return array
   */
  public function get_forum_reply($reply_id)
  {
    global $db;
    $get_reply = $db->query(sprintf("SELECT * FROM forums_replies WHERE reply_id = %s", secure($reply_id, 'int')));
    if ($get_reply->num_rows == 0) {
      return false;
    }
    $reply = $get_reply->fetch_assoc();
    /* get thread */
    $reply['thread'] = $this->get_forum_thread($reply['thread_id']);
    if (!$reply['thread']) {
      return false;
    }
    /* check if viewer can manage reply [Edit|Delete] */
    $reply['manage_reply'] = false;
    if ($this->_logged_in) {
      /* viewer is (admin|moderator) */
      if ($this->_data['user_group'] < 3) {
        $reply['manage_reply'] = true;
      }
      /* viewer is the author of reply */
      if ($this->_data['user_id'] == $reply['user_id']) {
        $reply['manage_reply'] = true;
      }
    }
    return $reply;
  }


  /**
   * post_forum_reply
   * 
   * @param string $thread_id
   * @param string $text
   * @param integer $reply_to_id
   * @return array
   */
  public function post_forum_reply($thread_id, $text, $reply_to_id = null)
  {
    global $db, $system, $date;
    /* check if forums enabled */
    if (!$system['forums_enabled']) {
      throw new Exception(__("The forums module has been disabled by the admin"));
    }
    /* check forums permission */
    if (!$this->_data['can_use_forums']) {
      throw new Exception(__("You don't have the permission to do this"));
    }
    /* get thread */
    $thread = $this->get_forum_thread($thread_id);
    /* check forum */
    if (!$thread) {
      _error(403);
    }
    /* check if thread locked */
    if ($thread['is_locked'] && !$thread['moderate_thread']) {
      throw new Exception(__("This thread is locked"));
    }
    /* validate text */
    if (is_empty($text)) {
      throw new Exception(__("You must enter some text for your reply"));
    }
    if ($system['html_richtext_enabled']) {
      $clean_text = $text;
    } else {
      /* HTMLPurifier */
      $purifier = get_html_purifier();
      $clean_text = $purifier->purify($text);
    }
    /* check the quoted reply */
    if ($reply_to_id) {
      $quotes = $this->get_forum_replies_quotes([$reply_to_id]);
      if (!isset($quotes[$reply_to_id]) || $quotes[$reply_to_id]['thread_id'] != $thread['thread_id']) {
        $reply_to_id = null;
      }
    }
    /* insert reply */
    $db->query(sprintf("INSERT INTO forums_replies (thread_id, user_id, reply_to_id, text, time) VALUES (%s, %s, %s, %s, %s)", secure($thread_id, 'int'), secure($this->_data['user_id'], 'int'), ($reply_to_id) ? secure($reply_to_id, 'int') : 'NULL', secure($clean_text), secure($date)));
    $reply_id = $db->insert_id;
    /* update thread */
    $db->query(sprintf("UPDATE forums_threads SET last_reply = %s, last_reply_user_id = %s, replies = replies + 1 WHERE thread_id = %s", secure($date), secure($this->_data['user_id'], 'int'), secure($thread_id, 'int')));
    /* update forum */
    $db->query(sprintf("UPDATE forums SET forum_replies = forum_replies + 1 WHERE forum_id = %s", secure($thread['forum']['forum_id'], 'int')));
    /* post notification */
    $this->post_notification(['to_user_id' => $thread['user_id'], 'action' => 'forum_reply', 'node_url' => $thread['thread_id'] . '/' . $thread['title_url'] . '/#reply-' . $reply_id]);
    /* extract hosted images from the text */
    $uploaded_images = extract_uploaded_images_from_text($clean_text);
    /* remove pending uploads */
    if ($uploaded_images) {
      remove_pending_uploads($uploaded_images);
    }
    return ['reply_id' => $reply_id, 'thread' => $thread];
  }


  /**
   * edit_forum_reply
   * 
   * @param string $reply_id
   * @param string $text
   * @return array
   */
  public function edit_forum_reply($reply_id, $text)
  {
    global $db, $system;
    /* check if forums enabled */
    if (!$system['forums_enabled']) {
      throw new Exception(__("The forums module has been disabled by the admin"));
    }
    /* check forums permission */
    if (!$this->_data['can_use_forums']) {
      throw new Exception(__("You don't have the permission to do this"));
    }
    /* get reply */
    $reply = $this->get_forum_reply($reply_id);
    /* check reply */
    if (!$reply) {
      _error(403);
    }
    /* check permission */
    if (!$reply['manage_reply']) {
      _error(403);
    }
    /* validate text */
    if (is_empty($text)) {
      throw new Exception(__("You must enter some text for your thread"));
    }
    if ($system['html_richtext_enabled']) {
      $clean_text = $text;
    } else {
      /* HTMLPurifier */
      $purifier = get_html_purifier();
      $clean_text = $purifier->purify($text);
    }
    /* edit reply */
    $db->query(sprintf("UPDATE forums_replies SET text = %s WHERE reply_id = %s", secure($clean_text), secure($reply_id, 'int')));
    /* extract hosted images from the text */
    $uploaded_images = extract_uploaded_images_from_text($clean_text);
    /* remove pending uploads */
    if ($uploaded_images) {
      remove_pending_uploads($uploaded_images);
    }
    return ['reply_id' => $reply_id, 'thread' => $reply['thread']];
  }


  /**
   * delete_forum_reply
   * 
   * @param string $reply_id
   * @return void
   */
  public function delete_forum_reply($reply_id)
  {
    global $db, $system;
    /* check if forums enabled */
    if (!$system['forums_enabled']) {
      throw new Exception(__("The forums module has been disabled by the admin"));
    }
    /* check forums permission */
    if (!$this->_data['can_use_forums']) {
      throw new Exception(__("You don't have the permission to do this"));
    }
    /* get reply */
    $reply = $this->get_forum_reply($reply_id);
    /* check reply */
    if (!$reply) {
      _error(403);
    }
    /* check permission */
    if (!$reply['manage_reply']) {
      _error(403);
    }
    /* delete reply */
    $db->query(sprintf("DELETE FROM  forums_replies WHERE reply_id = %s", secure($reply_id, 'int')));
    /* delete likes */
    $db->query(sprintf("DELETE FROM forums_likes WHERE node_type = 'reply' AND node_id = %s", secure($reply_id, 'int')));
    /* update thread */
    $get_last_reply = $db->query(sprintf("SELECT user_id, time FROM forums_replies WHERE thread_id = %s ORDER BY reply_id DESC LIMIT 1", secure($reply['thread_id'], 'int')));
    $last_reply = ($get_last_reply->num_rows > 0) ? $get_last_reply->fetch_assoc() : ['user_id' => 'null', 'time' => $reply['thread']['time']];
    $db->query(sprintf("UPDATE forums_threads SET replies = IF(replies=0,0,replies-1), last_reply = %s, last_reply_user_id = %s WHERE thread_id = %s", secure($last_reply['time']), secure($last_reply['user_id'], 'int', false), secure($reply['thread_id'], 'int')));
    /* update forum */
    $db->query(sprintf("UPDATE forums SET forum_replies = IF(forum_replies=0,0,forum_replies-1) WHERE forum_id = %s", secure($reply['thread']['forum']['forum_id'], 'int')));
    /* delete notification */
    $this->delete_notification($reply['thread']['user_id'], 'forum_reply', '', $reply['thread']['thread_id'] . '/' . $reply['thread']['title_url'] . '/#reply-' . $reply_id);
  }


  /**
   * update_forum_thread_status
   * 
   * @param integer $thread_id
   * @param string $action
   * @return void
   */
  public function update_forum_thread_status($thread_id, $action)
  {
    global $db, $system;
    /* check if forums enabled */
    if (!$system['forums_enabled']) {
      throw new Exception(__("The forums module has been disabled by the admin"));
    }
    /* get thread */
    $thread = $this->get_forum_thread($thread_id);
    /* check thread */
    if (!$thread) {
      _error(403);
    }
    /* check permission */
    if (!$thread['moderate_thread']) {
      _error(403);
    }
    switch ($action) {
      case 'pin':
        $db->query(sprintf("UPDATE forums_threads SET is_pinned = '1' WHERE thread_id = %s", secure($thread_id, 'int')));
        break;

      case 'unpin':
        $db->query(sprintf("UPDATE forums_threads SET is_pinned = '0' WHERE thread_id = %s", secure($thread_id, 'int')));
        break;

      case 'lock':
        $db->query(sprintf("UPDATE forums_threads SET is_locked = '1' WHERE thread_id = %s", secure($thread_id, 'int')));
        break;

      case 'unlock':
        $db->query(sprintf("UPDATE forums_threads SET is_locked = '0' WHERE thread_id = %s", secure($thread_id, 'int')));
        break;

      default:
        _error(400);
        break;
    }
  }


  /**
   * like_forum_post
   * 
   * @param string $handle
   * @param integer $id
   * @param boolean $like
   * @return integer
   */
  public function like_forum_post($handle, $id, $like = true)
  {
    global $db, $system, $date;
    /* check if forums enabled */
    if (!$system['forums_enabled']) {
      throw new Exception(__("The forums module has been disabled by the admin"));
    }
    /* check forums permission */
    if (!$this->_data['can_use_forums']) {
      throw new Exception(__("You don't have the permission to do this"));
    }
    /* check the post */
    switch ($handle) {
      case 'thread':
        $table = "forums_threads";
        $key = "thread_id";
        $post = $this->get_forum_thread($id);
        break;

      case 'reply':
        $table = "forums_replies";
        $key = "reply_id";
        $post = $this->get_forum_reply($id);
        break;

      default:
        _error(400);
        break;
    }
    if (!$post) {
      _error(403);
    }
    if ($like) {
      /* like */
      $db->query(sprintf("INSERT IGNORE INTO forums_likes (user_id, node_id, node_type, time) VALUES (%s, %s, %s, %s)", secure($this->_data['user_id'], 'int'), secure($id, 'int'), secure($handle), secure($date)));
      if ($db->affected_rows > 0) {
        $db->query(sprintf("UPDATE %s SET likes = likes + 1 WHERE %s = %s", $table, $key, secure($id, 'int')));
      }
    } else {
      /* unlike */
      $db->query(sprintf("DELETE FROM forums_likes WHERE user_id = %s AND node_id = %s AND node_type = %s", secure($this->_data['user_id'], 'int'), secure($id, 'int'), secure($handle)));
      if ($db->affected_rows > 0) {
        $db->query(sprintf("UPDATE %s SET likes = IF(likes=0,0,likes-1) WHERE %s = %s", $table, $key, secure($id, 'int')));
      }
    }
    $get_likes = $db->query(sprintf("SELECT likes FROM %s WHERE %s = %s", $table, $key, secure($id, 'int')));
    return (int) $get_likes->fetch_assoc()['likes'];
  }


  /**
   * get_forum_likes
   * 
   * @param string $handle
   * @param array $ids
   * @return array
   */
  public function get_forum_likes($handle, $ids)
  {
    global $db;
    $likes = [];
    if (!$this->_logged_in || !$ids) {
      return $likes;
    }
    $get_likes = $db->query(sprintf("SELECT node_id FROM forums_likes WHERE user_id = %s AND node_type = %s AND node_id IN (%s)", secure($this->_data['user_id'], 'int'), secure($handle), implode(',', array_map('intval', $ids))));
    while ($like = $get_likes->fetch_assoc()) {
      $likes[] = $like['node_id'];
    }
    return $likes;
  }


  /**
   * get_forums_feed
   * 
   * @param array $args
   * @return void
   */
  public function get_forums_feed($args = [])
  {
    global $db, $system;
    if (!$system['forums_enabled'] || !$system['forums_rss_enabled']) {
      _error(404);
    }
    $forum_id = $args['forum_id'] ?? null;
    $thread_id = $args['thread_id'] ?? null;
    $channel_title = __("Forums") . ' | ' . __($system['system_title']);
    $channel_link = $system['system_url'] . '/forums';
    $channel_description = __($system['system_description_forums']);
    $feed_url = $system['system_url'] . '/forums/rss';
    $limit = $system['max_results'] * 2;
    $items = [];
    if ($thread_id) {
      $thread = $this->get_forum_thread($thread_id);
      if (!$thread) {
        _error(404);
      }
      $channel_title = $thread['title'] . ' | ' . __($system['system_title']);
      $channel_link = $system['system_url'] . '/forums/thread/' . $thread['thread_id'] . '/' . $thread['title_url'];
      if ($thread['text_snippet']) {
        $channel_description = $thread['text_snippet'];
      }
      $feed_url = $channel_link . '/rss';
      $get_replies = $db->query(sprintf("SELECT forums_replies.reply_id, forums_replies.text, forums_replies.time, users.user_name, users.user_firstname, users.user_lastname FROM forums_replies INNER JOIN users ON forums_replies.user_id = users.user_id WHERE forums_replies.thread_id = %s ORDER BY forums_replies.reply_id DESC LIMIT %s", secure($thread['thread_id'], 'int'), secure($limit, 'int', false)));
      while ($reply = $get_replies->fetch_assoc()) {
        $items[] = [
          'title' => $thread['title'],
          'link' => $channel_link . '#reply-' . $reply['reply_id'],
          'pubDate' => date(DATE_RSS, strtotime($reply['time'])),
          'creator' => ($system['show_usernames_enabled']) ? $reply['user_name'] : $reply['user_firstname'] . " " . $reply['user_lastname'],
          'category' => __($thread['forum']['forum_name']),
          'description' => htmlspecialchars_decode($reply['text'], ENT_QUOTES),
        ];
      }
      if (count($items) < $limit) {
        $items[] = [
          'title' => $thread['title'],
          'link' => $channel_link,
          'pubDate' => date(DATE_RSS, strtotime($thread['time'])),
          'creator' => $thread['user_fullname'],
          'category' => __($thread['forum']['forum_name']),
          'description' => $thread['parsed_text'],
        ];
      }
    } else {
      $where_query = "";
      $forums = [];
      if ($forum_id) {
        $forum = $this->get_forum($forum_id, false);
        if (!$forum) {
          _error(404);
        }
        $forums[$forum['forum_id']] = $forum;
        $where_query = sprintf(" WHERE forums_threads.forum_id = %s", secure($forum['forum_id'], 'int'));
        $channel_title = __("Forums") . ' › ' . __($forum['forum_name']) . ' | ' . __($system['system_title']);
        $channel_link = $system['system_url'] . '/forums/' . $forum['forum_id'] . '/' . $forum['title_url'];
        if ($forum['forum_description']) {
          $channel_description = __($forum['forum_description']);
        }
        $feed_url = $channel_link . '/rss';
      }
      $get_threads = $db->query(sprintf("SELECT forums_threads.thread_id, forums_threads.forum_id, forums_threads.title, forums_threads.text, forums_threads.time, users.user_name, users.user_firstname, users.user_lastname FROM forums_threads INNER JOIN users ON forums_threads.user_id = users.user_id" . $where_query . " ORDER BY forums_threads.thread_id DESC LIMIT %s", secure($limit, 'int', false)));
      while ($thread = $get_threads->fetch_assoc()) {
        if (!isset($forums[$thread['forum_id']])) {
          $forums[$thread['forum_id']] = $this->get_forum($thread['forum_id'], false);
        }
        $items[] = [
          'title' => $thread['title'],
          'link' => $system['system_url'] . '/forums/thread/' . $thread['thread_id'] . '/' . get_url_text($thread['title']),
          'pubDate' => date(DATE_RSS, strtotime($thread['time'])),
          'creator' => ($system['show_usernames_enabled']) ? $thread['user_name'] : $thread['user_firstname'] . " " . $thread['user_lastname'],
          'category' => ($forums[$thread['forum_id']]) ? __($forums[$thread['forum_id']]['forum_name']) : '',
          'description' => htmlspecialchars_decode($thread['text'], ENT_QUOTES),
        ];
      }
    }
    $xml_escape = function ($value) {
      return htmlspecialchars(html_entity_decode((string) $value, ENT_QUOTES, 'UTF-8'), ENT_XML1 | ENT_QUOTES, 'UTF-8');
    };
    $language = str_replace('_', '-', $system['language']['code']);
    $xml = '<?xml version="1.0" encoding="UTF-8"?>' . "\n";
    $xml .= '<rss version="2.0" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:atom="http://www.w3.org/2005/Atom">' . "\n";
    $xml .= "  <channel>\n";
    $xml .= "    <title>" . $xml_escape($channel_title) . "</title>\n";
    $xml .= "    <link>" . $xml_escape($channel_link) . "</link>\n";
    $xml .= "    <description>" . $xml_escape($channel_description) . "</description>\n";
    $xml .= "    <language>" . $xml_escape($language) . "</language>\n";
    $xml .= '    <atom:link href="' . $xml_escape($feed_url) . '" rel="self" type="application/rss+xml" />' . "\n";
    foreach ($items as $item) {
      $xml .= "    <item>\n";
      $xml .= "      <title>" . $xml_escape($item['title']) . "</title>\n";
      $xml .= "      <link>" . $xml_escape($item['link']) . "</link>\n";
      $xml .= '      <guid isPermaLink="true">' . $xml_escape($item['link']) . "</guid>\n";
      $xml .= "      <pubDate>" . $xml_escape($item['pubDate']) . "</pubDate>\n";
      if ($item['creator'] !== '') {
        $xml .= "      <dc:creator>" . $xml_escape($item['creator']) . "</dc:creator>\n";
      }
      if ($item['category'] !== '') {
        $xml .= "      <category>" . $xml_escape($item['category']) . "</category>\n";
      }
      if ($item['description'] !== '') {
        $xml .= "      <description><![CDATA[" . str_replace(']]>', ']]]]><![CDATA[>', $item['description']) . "]]></description>\n";
      }
      $xml .= "    </item>\n";
    }
    $xml .= "  </channel>\n";
    $xml .= "</rss>";
    header('Content-Type: application/rss+xml; charset=UTF-8');
    echo $xml;
    exit;
  }


  /**
   * search_forums
   * 
   * @param string $query
   * @param string $type
   * @param mixed $forum
   * @param boolean $recursive
   * @return array
   */
  public function search_forums($query, $type, $forum, $recursive)
  {
    global $db, $system;
    /* init vars */
    $results = [];
    $params = [];
    /* check recursive */
    $recursive = (isset($recursive)) ? true : false;
    /* check forum */
    if ($forum == "all") {
      $params['forums_list'] = false;
    } else {
      $forum = $this->get_forum($forum);
      if (!$forum) {
        return $results;
      }
      $params['forums_list'][] = $forum['forum_id'];
      if ($recursive) {
        $this->get_child_forums_ids($forum['childs'], $params['forums_list']);
      }
    }
    /* include query */
    $params['query'] = $query;
    /* validate type */
    switch ($type) {
      case 'threads':
        $results = $this->get_forum_threads($params);
        break;

      case 'replies':
        $results = $this->get_forum_replies($params);
        break;
    }
    return $results;
  }


  /**
   * get_forum_online_users
   * 
   * @return array
   */
  public function get_forum_online_users()
  {
    global $db, $system;
    $users = [];
    $get_users = $db->query(sprintf("SELECT user_id, user_name, user_firstname, user_lastname, user_gender, user_picture, user_subscribed, packages.name as package_name, user_verified FROM users LEFT JOIN packages ON users.user_subscribed = '1' AND users.user_package = packages.package_id WHERE user_last_seen >= SUBTIME(NOW(), SEC_TO_TIME(%s)) AND user_chat_enabled = '1'", secure($system['offline_time'], 'int', false)));
    if ($get_users->num_rows > 0) {
      while ($user = $get_users->fetch_assoc()) {
        $user['user_picture'] = get_picture($user['user_picture'], $user['user_gender']);
        $users[] = $user;
      }
    }
    return $users;
  }
}
