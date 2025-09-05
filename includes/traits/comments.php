<?php

/**
 * trait -> comments
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich - Handles - @sorydima @sorydev @durovshater @DmitrySoro90935 @tanechfund - also check https://dmitry.rechain.network for more information!
 */

trait CommentsTrait
{

  /* ------------------------------- */
  /* Comments */
  /* ------------------------------- */

  /**
   * get_comments
   * 
   * @param integer $node_id
   * @param integer $offset
   * @param boolean $is_post
   * @param boolean $pass_privacy_check
   * @param array $post
   * @param string $sorting
   * @return array
   */
  public function get_comments($node_id, $offset = 0, $is_post = true, $pass_privacy_check = true, $post = [], $sorting = "recent", $last_comment_id = null)
  {
    global $db, $system;
    $comments = [];
    $offset *= $system['min_results'];
    switch ($sorting) {
      case 'top':
        $order_query = " ORDER BY posts_comments.reaction_like_count DESC, posts_comments.reaction_love_count DESC, posts_comments.reaction_haha_count DESC, posts_comments.reaction_yay_count DESC, posts_comments.reaction_wow_count DESC, posts_comments.reaction_sad_count DESC, posts_comments.reaction_angry_count DESC, posts_comments.replies DESC";
        break;

      case 'all':
        $order_query = " ORDER BY posts_comments.comment_id ASC ";
        break;

      default:
        $order_query = " ORDER BY posts_comments.comment_id DESC ";
        break;
    }
    /* get comments */
    if ($is_post) {
      /* get post comments */
      if (!$pass_privacy_check) {
        /* (check|get) post */
        $post = $this->_check_post($node_id, false);
        if (!$post) {
          return false;
        }
      }
      /* get post comments */
      if (!$last_comment_id) {
        $get_comments = $db->query(sprintf("SELECT posts_comments.*, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, users.user_verified, users.user_subscribed, packages.name as package_name, pages.* FROM posts_comments LEFT JOIN users ON posts_comments.user_id = users.user_id AND posts_comments.user_type = 'user' LEFT JOIN packages ON users.user_subscribed = '1' AND users.user_package = packages.package_id LEFT JOIN pages ON posts_comments.user_id = pages.page_id AND posts_comments.user_type = 'page' WHERE NOT (users.user_name <=> NULL AND pages.page_name <=> NULL) AND posts_comments.node_type = 'post' AND posts_comments.node_id = %s " . $order_query . " LIMIT %s, %s", secure($node_id, 'int'), secure($offset, 'int', false), secure($system['min_results'], 'int', false)));
      } else {
        $get_comments = $db->query(sprintf("SELECT posts_comments.*, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, users.user_verified, users.user_subscribed, packages.name as package_name, pages.* FROM posts_comments LEFT JOIN users ON posts_comments.user_id = users.user_id AND posts_comments.user_type = 'user' LEFT JOIN packages ON users.user_subscribed = '1' AND users.user_package = packages.package_id LEFT JOIN pages ON posts_comments.user_id = pages.page_id AND posts_comments.user_type = 'page' WHERE NOT (users.user_name <=> NULL AND pages.page_name <=> NULL) AND posts_comments.node_type = 'post' AND posts_comments.node_id = %s AND posts_comments.comment_id > %s " . $order_query, secure($node_id, 'int'), secure($last_comment_id, 'int')));
      }
    } else {
      /* get photo comments */
      /* check privacy */
      if (!$pass_privacy_check) {
        /* (check|get) photo */
        $photo = $this->get_photo($node_id);
        if (!$photo) {
          _error(403);
        }
        $post = $photo['post'];
      }
      /* get photo comments */
      $get_comments = $db->query(sprintf("SELECT posts_comments.*, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, users.user_verified, users.user_subscribed, packages.name as package_name, pages.* FROM posts_comments LEFT JOIN users ON posts_comments.user_id = users.user_id AND posts_comments.user_type = 'user' LEFT JOIN packages ON users.user_subscribed = '1' AND users.user_package = packages.package_id LEFT JOIN pages ON posts_comments.user_id = pages.page_id AND posts_comments.user_type = 'page' WHERE NOT (users.user_name <=> NULL AND pages.page_name <=> NULL) AND posts_comments.node_type = 'photo' AND posts_comments.node_id = %s " . $order_query . " LIMIT %s, %s", secure($node_id, 'int'), secure($offset, 'int', false), secure($system['min_results'], 'int', false)));
    }
    if ($get_comments->num_rows == 0) {
      return $comments;
    }
    while ($comment = $get_comments->fetch_assoc()) {

      /* pass comments_disabled from post to comment */
      $comment['comments_disabled'] = $post['comments_disabled'];

      /* check if the page has been deleted */
      if ($comment['user_type'] == "page" && !$comment['page_admin']) {
        continue;
      }
      /* check if there is any blocking between the viewer & the comment author */
      if ($comment['user_type'] == "user" && $this->blocked($comment['user_id'])) {
        continue;
      }

      /* get reactions array */
      $comment['reactions']['like'] = $comment['reaction_like_count'];
      $comment['reactions']['love'] = $comment['reaction_love_count'];
      $comment['reactions']['haha'] = $comment['reaction_haha_count'];
      $comment['reactions']['yay'] = $comment['reaction_yay_count'];
      $comment['reactions']['wow'] = $comment['reaction_wow_count'];
      $comment['reactions']['sad'] = $comment['reaction_sad_count'];
      $comment['reactions']['angry'] = $comment['reaction_angry_count'];
      arsort($comment['reactions']);

      /* get total reactions */
      $comment['reactions_total_count'] = $comment['reaction_like_count'] + $comment['reaction_love_count'] + $comment['reaction_haha_count'] + $comment['reaction_yay_count'] + $comment['reaction_wow_count'] + $comment['reaction_sad_count'] + $comment['reaction_angry_count'];
      $comment['reactions_total_count_formatted'] = abbreviate_count($comment['reactions_total_count']);

      /* get replies */
      if ($comment['replies'] > 0) {
        $comment['comment_replies'] = $this->get_replies($comment['comment_id'], 0, true, $post);
      }

      /* parse text */
      $comment['text_plain'] = $comment['text'];
      $comment['text'] = $this->_parse(["text" => $comment['text']]);

      /* get the comment author */
      if ($comment['user_type'] == "user") {
        /* user type */
        $comment['author_id'] = $comment['user_id'];
        $comment['author_picture'] = get_picture($comment['user_picture'], $comment['user_gender']);
        $comment['author_url'] = $system['system_url'] . '/' . $comment['user_name'];
        $comment['author_name'] = ($system['show_usernames_enabled']) ? $comment['user_name'] : $comment['user_firstname'] . " " . $comment['user_lastname'];
        $comment['author_verified'] = $comment['user_verified'];
      } else {
        /* page type */
        $comment['author_id'] = $comment['page_admin'];
        $comment['author_picture'] = get_picture($comment['page_picture'], "page");
        $comment['author_url'] = $system['system_url'] . '/pages/' . $comment['page_name'];
        $comment['author_name'] = $comment['page_title'];
        $comment['author_verified'] = $comment['page_verified'];
      }

      /* check if viewer user react this comment */
      $comment['i_react'] = false;
      if ($this->_logged_in) {
        /* reaction */
        if ($comment['reactions_total_count'] > 0) {
          $get_reaction = $db->query(sprintf("SELECT reaction FROM posts_comments_reactions WHERE user_id = %s AND comment_id = %s", secure($this->_data['user_id'], 'int'), secure($comment['comment_id'], 'int')));
          if ($get_reaction->num_rows > 0) {
            $comment['i_react'] = true;
            $comment['i_reaction'] = $get_reaction->fetch_assoc()['reaction'];
          }
        }
      }

      /* check if viewer can manage comment [Edit|Delete] */
      $comment['edit_comment'] = false;
      $comment['delete_comment'] = false;
      if ($this->_logged_in) {
        /* viewer is (admin|moderator) */
        if ($this->_data['user_group'] < 3) {
          $comment['edit_comment'] = true;
          $comment['delete_comment'] = true;
        }
        /* viewer is the author of comment */
        if ($this->_data['user_id'] == $comment['author_id']) {
          $comment['edit_comment'] = true;
          $comment['delete_comment'] = true;
        }
        /* viewer is the author of post */
        if ($this->_data['user_id'] == $post['author_id']) {
          $comment['delete_comment'] = true;
        }
        /* viewer is the admin of the group of the post */
        if ($post['in_group'] && $post['is_group_admin']) {
          $comment['delete_comment'] = true;
        }
        /* viewer is the admin of the event of the post */
        if ($post['in_event'] && $post['is_event_admin']) {
          $comment['delete_comment'] = true;
        }
      }

      $comments[] = $comment;
    }
    return $comments;
  }


  /**
   * get_replies
   * 
   * @param integer $comment_id
   * @param integer $offset
   * @param boolean $offset
   * @param array $post
   * @return array
   */
  public function get_replies($comment_id, $offset = 0, $pass_check = true, $post = [])
  {
    global $db, $system;
    $replies = [];
    $offset *= $system['min_results'];
    if (!$pass_check) {
      $comment = $this->get_comment($comment_id);
      if (!$comment) {
        _error(403);
      }
      $post_author_id = $comment['post']['author_id'];
    } else {
      $post_author_id = $post['author_id'];
    }
    /* get replies */
    $get_replies = $db->query(sprintf("SELECT * FROM (SELECT posts_comments.*, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, users.user_verified, users.user_subscribed, packages.name as package_name, pages.* FROM posts_comments LEFT JOIN users ON posts_comments.user_id = users.user_id AND posts_comments.user_type = 'user' LEFT JOIN packages ON users.user_subscribed = '1' AND users.user_package = packages.package_id LEFT JOIN pages ON posts_comments.user_id = pages.page_id AND posts_comments.user_type = 'page' WHERE NOT (users.user_name <=> NULL AND pages.page_name <=> NULL) AND posts_comments.node_type = 'comment' AND posts_comments.node_id = %s ORDER BY posts_comments.comment_id DESC LIMIT %s, %s) comments ORDER BY comments.comment_id ASC", secure($comment_id, 'int'), secure($offset, 'int', false), secure($system['min_results'], 'int', false)));
    if ($get_replies->num_rows == 0) {
      return $replies;
    }
    while ($reply = $get_replies->fetch_assoc()) {

      /* pass comments_disabled from (post|comment) to reply */
      $reply['comments_disabled'] = (isset($post['comments_disabled'])) ? $post['comments_disabled'] : $comment['comments_disabled'];

      /* check if the page has been deleted */
      if ($reply['user_type'] == "page" && !$reply['page_admin']) {
        continue;
      }
      /* check if there is any blocking between the viewer & the comment author */
      if ($reply['user_type'] == "user" && $this->blocked($reply['user_id'])) {
        continue;
      }

      /* get reactions array */
      $reply['reactions']['like'] = $reply['reaction_like_count'];
      $reply['reactions']['love'] = $reply['reaction_love_count'];
      $reply['reactions']['haha'] = $reply['reaction_haha_count'];
      $reply['reactions']['yay'] = $reply['reaction_yay_count'];
      $reply['reactions']['wow'] = $reply['reaction_wow_count'];
      $reply['reactions']['sad'] = $reply['reaction_sad_count'];
      $reply['reactions']['angry'] = $reply['reaction_angry_count'];
      arsort($reply['reactions']);

      /* get total reactions */
      $reply['reactions_total_count'] = $reply['reaction_like_count'] + $reply['reaction_love_count'] + $reply['reaction_haha_count'] + $reply['reaction_yay_count'] + $reply['reaction_wow_count'] + $reply['reaction_sad_count'] + $reply['reaction_angry_count'];
      $reply['reactions_total_count_formatted'] = abbreviate_count($reply['reactions_total_count']);

      /* parse text */
      $reply['text_plain'] = $reply['text'];
      $reply['text'] = $this->_parse(["text" => $reply['text']]);

      /* get the reply author */
      if ($reply['user_type'] == "user") {
        /* user type */
        $reply['author_id'] = $reply['user_id'];
        $reply['author_picture'] = get_picture($reply['user_picture'], $reply['user_gender']);
        $reply['author_url'] = $system['system_url'] . '/' . $reply['user_name'];
        $reply['author_user_name'] = $reply['user_name'];
        $reply['author_name'] = ($system['show_usernames_enabled']) ? $reply['user_name'] : $reply['user_firstname'] . " " . $reply['user_lastname'];
        $reply['author_verified'] = $reply['user_verified'];
      } else {
        /* page type */
        $reply['author_id'] = $reply['page_admin'];
        $reply['author_picture'] = get_picture($reply['page_picture'], "page");
        $reply['author_url'] = $system['system_url'] . '/pages/' . $reply['page_name'];
        $reply['author_name'] = $reply['page_title'];
        $reply['author_verified'] = $reply['page_verified'];
      }

      /* check if viewer user react this reply */
      $reply['i_react'] = false;
      if ($this->_logged_in) {
        /* reaction */
        if ($reply['reactions_total_count'] > 0) {
          $get_reaction = $db->query(sprintf("SELECT reaction FROM posts_comments_reactions WHERE user_id = %s AND comment_id = %s", secure($this->_data['user_id'], 'int'), secure($reply['comment_id'], 'int')));
          if ($get_reaction->num_rows > 0) {
            $reply['i_react'] = true;
            $reply['i_reaction'] = $get_reaction->fetch_assoc()['reaction'];
          }
        }
      }

      /* check if viewer can manage reply [Edit|Delete] */
      $reply['edit_comment'] = false;
      $reply['delete_comment'] = false;
      if ($this->_logged_in) {
        /* viewer is (admin|moderator) */
        if ($this->_data['user_group'] < 3) {
          $reply['edit_comment'] = true;
          $reply['delete_comment'] = true;
        }
        /* viewer is the author of reply */
        if ($this->_data['user_id'] == $reply['author_id']) {
          $reply['edit_comment'] = true;
          $reply['delete_comment'] = true;
        }
        /* viewer is the author of post */
        if ($this->_data['user_id'] == $post_author_id) {
          $reply['delete_comment'] = true;
        }
      }

      $replies[] = $reply;
    }
    return $replies;
  }


  /**
   * comment
   * 
   * @param string $handle
   * @param integer $node_id
   * @param string $message
   * @param string $photo
   * @param string $voice_note
   * @return array
   */
  public function comment($handle, $node_id, $message, $photo, $voice_note)
  {
    global $db, $system, $date;

    /* check max comments/hour limit */
    if ($system['max_comments_hour'] > 0 && $this->_data['user_group'] >= 3) {
      $check_limit = $db->query(sprintf("SELECT COUNT(*) as count FROM posts_comments WHERE posts_comments.time >= DATE_SUB(NOW(),INTERVAL 1 HOUR) AND user_id = %s AND user_type = 'user'", secure($this->_data['user_id'], 'int')));
      if ($check_limit->fetch_assoc()['count'] >= $system['max_comments_hour']) {
        modal("MESSAGE", __("Maximum Limit Reached"), __("You have reached the maximum limit of comments/hour, please try again later"));
      }
    }

    /* check comment max length */
    if ($system['max_comment_length'] > 0 && $this->_data['user_group'] >= 3) {
      if (strlen($message) >= $system['max_comment_length']) {
        modal("MESSAGE", __("Text Length Limit Reached"), __("Your message characters length is over the allowed limit") . " (" . $system['max_comment_length'] . " " . __("Characters") . ")");
      }
    }

    /* default */
    $comment = [];
    $comment['node_id'] = $node_id;
    $comment['node_type'] = $handle;
    $comment['text'] = $message;
    $comment['image'] = $photo;
    $comment['voice_note'] = $voice_note;
    $comment['time'] = $date;
    $comment['reaction_like_count'] = 0;
    $comment['reaction_love_count'] = 0;
    $comment['reaction_haha_count'] = 0;
    $comment['reaction_yay_count'] = 0;
    $comment['reaction_wow_count'] = 0;
    $comment['reaction_sad_count'] = 0;
    $comment['reaction_angry_count'] = 0;
    $comment['reactions_total_count'] = 0;
    $comment['replies'] = 0;

    /* check the handle */
    switch ($handle) {
      case 'post':
        /* (check|get) post */
        $post = $this->_check_post($node_id, false, false);
        if (!$post) {
          _error(403);
        }
        break;

      case 'photo':
        /* (check|get) photo */
        $photo = $this->get_photo($node_id);
        if (!$photo) {
          _error(403);
        }
        $post = $photo['post'];
        break;

      case 'comment':
        /* (check|get) comment */
        $parent_comment = $this->get_comment($node_id, false);
        if (!$parent_comment) {
          _error(403);
        }
        $post = $parent_comment['post'];
        break;
    }

    /* check if comments disabled */
    if ($post['comments_disabled']) {
      throw new Exception(__("Comments disabled for this post"));
    }

    /* check if there is any blocking between the viewer & the target */
    if (($post['user_type'] == "user" && $this->blocked($post['author_id'])) || ($handle == "comment" && $this->blocked($parent_comment['author_id']))) {
      _error(403);
    }

    /* check if the viewer is page admin of the target post */
    if (!$post['is_page_admin']) {
      $comment['user_id'] = $this->_data['user_id'];
      $comment['user_type'] = "user";
      $comment['author_picture'] = $this->_data['user_picture'];
      $comment['author_url'] = $system['system_url'] . '/' . $this->_data['user_name'];
      $comment['author_user_name'] = $this->_data['user_name'];
      $comment['author_name'] = $this->_data['user_fullname'];
      $comment['author_verified'] = $this->_data['user_verified'];
    } else {
      $comment['user_id'] = $post['page_id'];
      $comment['user_type'] = "page";
      $comment['author_picture'] = get_picture($post['page_picture'], "page");
      $comment['author_url'] = $system['system_url'] . '/pages/' . $post['page_name'];
      $comment['author_name'] = $post['page_title'];
      $comment['author_verified'] = $post['page_verified'];
    }

    /* insert the comment */
    $db->query(sprintf("INSERT INTO posts_comments (node_id, node_type, user_id, user_type, text, image, voice_note, time) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)", secure($comment['node_id'], 'int'), secure($comment['node_type']), secure($comment['user_id'], 'int'), secure($comment['user_type']), secure($comment['text']), secure($comment['image']), secure($comment['voice_note']), secure($comment['time'])));
    $comment['comment_id'] = $db->insert_id;
    /* remove pending uploads */
    remove_pending_uploads([$comment['image']]);
    /* update (post|photo|comment) (comments|replies) counter */
    switch ($handle) {
      case 'post':
        $db->query(sprintf("UPDATE posts SET comments = comments + 1 WHERE post_id = %s", secure($node_id, 'int')));
        break;

      case 'photo':
        $db->query(sprintf("UPDATE posts_photos SET comments = comments + 1 WHERE photo_id = %s", secure($node_id, 'int')));
        break;

      case 'comment':
        $db->query(sprintf("UPDATE posts_comments SET replies = replies + 1 WHERE comment_id = %s", secure($node_id, 'int')));
        if ($parent_comment['node_type'] == "post") {
          $db->query(sprintf("UPDATE posts SET comments = comments + 1 WHERE post_id = %s", secure($parent_comment['node_id'], 'int')));
        } elseif ($parent_comment['node_type'] == "photo") {
          $db->query(sprintf("UPDATE posts_photos SET comments = comments + 1 WHERE photo_id = %s", secure($parent_comment['node_id'], 'int')));
        }
        break;
    }

    /* post notification */
    if ($handle == "comment") {
      $this->post_notification(['to_user_id' => $parent_comment['author_id'], 'from_user_id' => $comment['user_id'], 'from_user_type' => $comment['user_type'], 'action' => 'reply', 'node_type' => $parent_comment['node_type'], 'node_url' => $parent_comment['node_id'], 'notify_id' => 'comment_' . $comment['comment_id']]);
      if ($post['author_id'] != $parent_comment['author_id']) {
        $this->post_notification(['to_user_id' => $post['author_id'], 'action' => 'comment', 'node_type' => $parent_comment['node_type'], 'node_url' => $parent_comment['node_id'], 'notify_id' => 'comment_' . $comment['comment_id']]);
      }
    } else {
      $this->post_notification(['to_user_id' => $post['author_id'], 'action' => 'comment', 'node_type' => $handle, 'node_url' => $node_id, 'notify_id' => 'comment_' . $comment['comment_id']]);
    }

    /* post mention notifications if any */
    if ($handle == "comment") {
      $this->post_mentions($comment['text'], $parent_comment['node_id'], "reply_" . $parent_comment['node_type'], 'comment_' . $comment['comment_id'], [$post['author_id'], $parent_comment['author_id']]);
    } else {
      $this->post_mentions($comment['text'], $node_id, "comment_" . $handle, 'comment_' . $comment['comment_id'], [$post['author_id']]);
    }

    /* parse text */
    $comment['text_plain'] = htmlentities($comment['text'], ENT_QUOTES, 'utf-8');
    $comment['text'] = $this->_parse(["text" => $comment['text_plain']]);

    /* check if viewer can manage comment [Edit|Delete] */
    $comment['edit_comment'] = true;
    $comment['delete_comment'] = true;

    /* points balance */
    $this->points_balance("add", $post['author_id'], "post_comment", $comment['comment_id']);
    $this->points_balance("add", $this->_data['user_id'], "comment", $comment['comment_id']);

    /* return */
    return $comment;
  }


  /**
   * get_comment
   * 
   * @param integer $comment_id
   * @return array|false
   */
  public function get_comment($comment_id, $recursive = true)
  {
    global $db;
    /* get comment */
    $get_comment = $db->query(sprintf("SELECT posts_comments.*, pages.page_admin FROM posts_comments LEFT JOIN pages ON posts_comments.user_type = 'page' AND posts_comments.user_id = pages.page_id WHERE posts_comments.comment_id = %s", secure($comment_id, 'int')));
    if ($get_comment->num_rows == 0) {
      return false;
    }
    $comment = $get_comment->fetch_assoc();

    /* check if the page has been deleted */
    if ($comment['user_type'] == "page" && !$comment['page_admin']) {
      return false;
    }
    /* check if there is any blocking between the viewer & the comment author */
    if ($comment['user_type'] == "user" && $this->blocked($comment['user_id'])) {
      return false;
    }

    /* get reactions array */
    $comment['reactions']['like'] = $comment['reaction_like_count'];
    $comment['reactions']['love'] = $comment['reaction_love_count'];
    $comment['reactions']['haha'] = $comment['reaction_haha_count'];
    $comment['reactions']['yay'] = $comment['reaction_yay_count'];
    $comment['reactions']['wow'] = $comment['reaction_wow_count'];
    $comment['reactions']['sad'] = $comment['reaction_sad_count'];
    $comment['reactions']['angry'] = $comment['reaction_angry_count'];
    arsort($comment['reactions']);

    /* get total reactions */
    $comment['reactions_total_count'] = $comment['reaction_like_count'] + $comment['reaction_love_count'] + $comment['reaction_haha_count'] + $comment['reaction_yay_count'] + $comment['reaction_wow_count'] + $comment['reaction_sad_count'] + $comment['reaction_angry_count'];
    $comment['reactions_total_count_formatted'] = abbreviate_count($comment['reactions_total_count']);

    /* get the author */
    $comment['author_id'] = ($comment['user_type'] == "page") ? $comment['page_admin'] : $comment['user_id'];

    /* get post */
    switch ($comment['node_type']) {
      case 'post':
        $post = $this->_check_post($comment['node_id'], false, false);
        /* check if the post has been deleted */
        if (!$post) {
          return false;
        }
        $comment['post'] = $post;
        break;

      case 'photo':
        /* (check|get) photo */
        $photo = $this->get_photo($comment['node_id']);
        if (!$photo) {
          return false;
        }
        $comment['post'] = $photo['post'];
        break;

      case 'comment':
        if (!$recursive) {
          return false;
        }
        /* (check|get) comment */
        $parent_comment = $this->get_comment($comment['node_id'], false);
        if (!$parent_comment) {
          return false;
        }
        $comment['parent_comment'] = $parent_comment;
        $comment['post'] = $parent_comment['post'];
        break;
    }

    /* pass comments_disabled from post to comment */
    $comment['comments_disabled'] = $comment['post']['comments_disabled'];

    /* check if viewer user react this comment */
    $comment['i_react'] = false;
    if ($this->_logged_in) {
      /* reaction */
      if ($comment['reactions_total_count'] > 0) {
        $get_reaction = $db->query(sprintf("SELECT reaction FROM posts_comments_reactions WHERE user_id = %s AND comment_id = %s", secure($this->_data['user_id'], 'int'), secure($comment['comment_id'], 'int')));
        if ($get_reaction->num_rows > 0) {
          $comment['i_react'] = true;
          $comment['i_reaction'] = $get_reaction->fetch_assoc()['reaction'];
        }
      }
    }

    /* return */
    return $comment;
  }


  /**
   * delete_comment
   * 
   * @param integer $comment_id
   * @return void
   */
  public function delete_comment($comment_id)
  {
    global $db;
    /* (check|get) comment */
    $comment = $this->get_comment($comment_id);
    if (!$comment) {
      _error(403);
    }
    /* check if viewer can manage comment [Delete] */
    $comment['delete_comment'] = false;
    if ($this->_logged_in) {
      /* viewer is (admin|moderator) */
      if ($this->_data['user_group'] < 3) {
        $comment['delete_comment'] = true;
      }
      /* viewer is the author of comment */
      if ($this->_data['user_id'] == $comment['author_id']) {
        $comment['delete_comment'] = true;
      }
      /* viewer is the author of post */
      if ($this->_data['user_id'] == $comment['post']['author_id']) {
        $comment['delete_comment'] = true;
      }
      /* viewer is the admin of the group of the post */
      if ($comment['post']['in_group'] && $comment['post']['is_group_admin']) {
        $comment['delete_comment'] = true;
      }
      /* viewer is the admin of the event of the post */
      if ($comment['post']['in_event'] && $comment['post']['is_event_admin']) {
        $comment['delete_comment'] = true;
      }
    }
    /* delete the comment */
    if ($comment['delete_comment']) {
      /* delete the comment */
      $db->query(sprintf("DELETE FROM posts_comments WHERE comment_id = %s", secure($comment_id, 'int')));
      /* delete comment image from uploads folder */
      delete_uploads_file($comment['image']);
      /* delete replies */
      if ($comment['replies'] > 0) {
        $get_replies = $db->query(sprintf("SELECT image FROM posts_comments WHERE node_type = 'comment' AND node_id = %s", secure($comment_id, 'int')));
        while ($reply = $get_replies->fetch_assoc()) {
          /* delete reply image from uploads folder */
          delete_uploads_file($reply['image']);
        }
        $db->query(sprintf("DELETE FROM posts_comments WHERE node_type = 'comment' AND node_id = %s", secure($comment_id, 'int')));
      }
      /* update comments counter */
      switch ($comment['node_type']) {
        case 'post':
          $db->query(sprintf("UPDATE posts SET comments = IF(comments=0,0,comments-%s) WHERE post_id = %s", secure($comment['replies'] + 1, 'int'), secure($comment['node_id'], 'int')));
          break;

        case 'photo':
          $db->query(sprintf("UPDATE posts_photos SET comments = IF(comments=0,0,comments-%s) WHERE photo_id = %s", secure($comment['replies'] + 1, 'int'), secure($comment['node_id'], 'int')));
          break;

        case 'comment':
          $db->query(sprintf("UPDATE posts_comments SET replies = IF(replies=0,0,replies-1) WHERE comment_id = %s", secure($comment['node_id'], 'int')));
          if ($comment['parent_comment']['node_type'] == "post") {
            $db->query(sprintf("UPDATE posts SET comments = IF(comments=0,0,comments-1) WHERE post_id = %s", secure($comment['parent_comment']['node_id'], 'int')));
          } elseif ($comment['parent_comment']['node_type'] == "photo") {
            $db->query(sprintf("UPDATE posts_photos SET comments = IF(comments=0,0,comments-1) WHERE photo_id = %s", secure($comment['parent_comment']['node_id'], 'int')));
          }
          break;
      }
      /* points balance */
      $this->points_balance("delete", $comment['post']['author_id'], "post_comment");
      $this->points_balance("delete", $comment['author_id'], "comment");
    }
  }


  /**
   * edit_comment
   * 
   * @param integer $comment_id
   * @param string $message
   * @param string $photo
   * @return array
   */
  public function edit_comment($comment_id, $message, $photo)
  {
    global $db, $system;
    /* (check|get) comment */
    $comment = $this->get_comment($comment_id);
    if (!$comment) {
      _error(403);
    }
    /* check if viewer can manage comment [Edit] */
    $comment['edit_comment'] = false;
    if ($this->_logged_in) {
      /* viewer is (admin|moderator) */
      if ($this->_data['user_group'] < 3) {
        $comment['edit_comment'] = true;
      }
      /* viewer is the author of comment */
      if ($this->_data['user_id'] == $comment['author_id']) {
        $comment['edit_comment'] = true;
      }
    }
    if (!$comment['edit_comment']) {
      _error(400);
    }
    /* check post max length */
    if ($system['max_comment_length'] > 0 && $this->_data['user_group'] >= 3) {
      if (strlen($message) >= $system['max_comment_length']) {
        modal("MESSAGE", __("Text Length Limit Reached"), __("Your message characters length is over the allowed limit") . " (" . $system['max_comment_length'] . " " . __("Characters") . ")");
      }
    }
    /* update comment */
    $comment['text'] = $message;
    $comment['image'] = ($photo) ? $photo : $comment['image'];
    $db->query(sprintf("UPDATE posts_comments SET text = %s, image = %s WHERE comment_id = %s", secure($comment['text']), secure($comment['image']), secure($comment_id, 'int')));
    /* remove pending uploads */
    remove_pending_uploads([$comment['image']]);
    /* post mention notifications if any */
    if ($comment['node_type'] == "comment") {
      $this->post_mentions($comment['text'], $comment['parent_comment']['node_id'], "reply_" . $comment['parent_comment']['node_type'], 'comment_' . $comment['comment_id'], [$comment['post']['author_id'], $comment['parent_comment']['author_id']]);
    } else {
      $this->post_mentions($comment['text'], $comment['node_id'], "comment_" . $comment['node_type'], 'comment_' . $comment['comment_id'], [$comment['post']['author_id']]);
    }
    /* parse text */
    $comment['text_plain'] = htmlentities($comment['text'], ENT_QUOTES, 'utf-8');
    $comment['text'] = $this->_parse(["text" => $comment['text_plain']]);
    /* return */
    return $comment;
  }


  /**
   * react_comment
   * 
   * @param integer $comment_id
   * @param string $reaction
   * @return void
   */
  public function react_comment($comment_id, $reaction)
  {
    global $db, $date;
    /* check reation */
    if (!in_array($reaction, ['like', 'love', 'haha', 'yay', 'wow', 'sad', 'angry'])) {
      _error(403);
    }
    /* (check|get) comment */
    $comment = $this->get_comment($comment_id);
    if (!$comment) {
      _error(403);
    }
    /* check blocking */
    if ($this->blocked($comment['author_id'])) {
      _error(403);
    }
    /* react the comment */
    if ($comment['i_react']) {
      $db->query(sprintf("DELETE FROM posts_comments_reactions WHERE user_id = %s AND comment_id = %s", secure($this->_data['user_id'], 'int'), secure($comment_id, 'int')));
      /* update comment reaction counter */
      $reaction_field = "reaction_" . $comment['i_reaction'] . "_count";
      $db->query(sprintf("UPDATE posts_comments SET $reaction_field = IF($reaction_field=0,0,$reaction_field-1) WHERE comment_id = %s", secure($comment_id, 'int')));
      /* delete notification */
      switch ($comment['node_type']) {
        case 'post':
          $this->delete_notification($comment['author_id'], 'react_' . $comment['i_reaction'], 'post_comment', $comment['node_id']);
          break;

        case 'photo':
          $this->delete_notification($comment['author_id'], 'react_' . $comment['i_reaction'], 'photo_comment', $comment['node_id']);
          break;

        case 'comment':
          $_node_type = ($comment['parent_comment']['node_type'] == "post") ? "post_reply" : "photo_reply";
          $_node_url = $comment['parent_comment']['node_id'];
          $this->delete_notification($comment['author_id'], 'react_' . $comment['i_reaction'], $_node_type, $_node_url);
          break;
      }
    }
    $db->query(sprintf("INSERT INTO posts_comments_reactions (user_id, comment_id, reaction, reaction_time) VALUES (%s, %s, %s, %s)", secure($this->_data['user_id'], 'int'), secure($comment_id, 'int'), secure($reaction), secure($date)));
    /* update comment reaction counter */
    $reaction_field = "reaction_" . $reaction . "_count";
    $db->query(sprintf("UPDATE posts_comments SET $reaction_field = $reaction_field + 1 WHERE comment_id = %s", secure($comment_id, 'int')));
    /* post notification */
    switch ($comment['node_type']) {
      case 'post':
        $this->post_notification(['to_user_id' => $comment['author_id'], 'action' => 'react_' . $reaction, 'node_type' => 'post_comment', 'node_url' => $comment['node_id'], 'notify_id' => 'comment_' . $comment_id]);
        break;

      case 'photo':
        $this->post_notification(['to_user_id' => $comment['author_id'], 'action' => 'react_' . $reaction, 'node_type' => 'photo_comment', 'node_url' => $comment['node_id'], 'notify_id' => 'comment_' . $comment_id]);
        break;

      case 'comment':
        $_node_type = ($comment['parent_comment']['node_type'] == "post") ? "post_reply" : "photo_reply";
        $_node_url = $comment['parent_comment']['node_id'];
        $this->post_notification(['to_user_id' => $comment['author_id'], 'action' => 'react_' . $reaction, 'node_type' => $_node_type, 'node_url' => $_node_url, 'notify_id' => 'comment_' . $comment_id]);
        break;
    }
  }


  /**
   * unreact_comment
   * 
   * @param integer $comment_id
   * @param string $reaction
   * @return void
   */
  public function unreact_comment($comment_id, $reaction)
  {
    global $db;
    /* check reation */
    if (!in_array($reaction, ['like', 'love', 'haha', 'yay', 'wow', 'sad', 'angry'])) {
      _error(403);
    }
    /* (check|get) comment */
    $comment = $this->get_comment($comment_id);
    if (!$comment) {
      _error(403);
    }
    /* check blocking */
    if ($this->blocked($comment['author_id'])) {
      _error(403);
    }
    /* unreact the comment */
    if ($comment['i_react']) {
      $db->query(sprintf("DELETE FROM posts_comments_reactions WHERE user_id = %s AND comment_id = %s", secure($this->_data['user_id'], 'int'), secure($comment_id, 'int')));
      /* update comment reaction counter */
      $reaction_field = "reaction_" . $reaction . "_count";
      $db->query(sprintf("UPDATE posts_comments SET $reaction_field = IF($reaction_field=0,0,$reaction_field-1) WHERE comment_id = %s", secure($comment_id, 'int')));
      /* delete notification */
      switch ($comment['node_type']) {
        case 'post':
          $this->delete_notification($comment['author_id'], 'react_' . $reaction, 'post_comment', $comment['node_id']);
          break;

        case 'photo':
          $this->delete_notification($comment['author_id'], 'react_' . $reaction, 'photo_comment', $comment['node_id']);
          break;

        case 'comment':
          $_node_type = ($comment['parent_comment']['node_type'] == "post") ? "post_reply" : "photo_reply";
          $_node_url = $comment['parent_comment']['node_id'];
          $this->delete_notification($comment['author_id'], 'react_' . $reaction, $_node_type, $_node_url);
          break;
      }
    }
  }
}
