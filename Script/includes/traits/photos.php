<?php

/**
 * trait -> photos
 *
 * @package Delus
 * @author Sorokin Dmitry Olegovich - Handles - @sorydima @sorydev @durovshater @DmitrySoro90935 @tanechfund - also check https://dmitry.rechain.network for more information!
 */

trait PhotosTrait
{

  /* ------------------------------- */
  /* Photos */
  /* ------------------------------- */

  /**
   * get_photos
   * 
   * @param integer $id
   * @param string $type
   * @param integer $offset
   * @param boolean $pass_check
   * @param boolean $get_pinned
   * @return array
   */
  public function get_photos($id, $type = 'user', $offset = 0, $pass_check = true, $get_pinned = false)
  {
    global $db, $system;
    $photos = [];
    switch ($type) {
      case 'album':
        $offset *= $system['max_results_even'];
        if (!$pass_check) {
          /* check the album */
          $album = $this->get_album($id, false);
          if (!$album) {
            return $photos;
          }
        }
        $get_photos = $db->query(sprintf("SELECT posts_photos.photo_id, posts_photos.source, posts_photos.blur, posts.user_id, posts.user_type, posts.privacy FROM posts_photos INNER JOIN posts ON posts_photos.post_id = posts.post_id WHERE posts_photos.album_id = %s AND posts.is_anonymous = '0' AND posts.is_paid = '0' AND (posts.pre_approved = '1' OR posts.has_approved = '1') ORDER BY posts_photos.photo_id DESC LIMIT %s, %s", secure($id, 'int'), secure($offset, 'int', false), secure($system['max_results_even'], 'int', false)));
        if ($get_photos->num_rows > 0) {
          while ($photo = $get_photos->fetch_assoc()) {
            /* check the photo privacy */
            if ($photo['privacy'] == "public" || $photo['privacy'] == "custom") {
              if ($album) {
                $photo['manage'] = $album['manage_album'];
              }
              $photos[] = $photo;
            } else {
              /* check the photo privacy */
              if ($this->check_privacy($photo['privacy'], $photo['user_id'])) {
                if ($album) {
                  $photo['manage'] = $album['manage_album'];
                }
                $photos[] = $photo;
              }
            }
          }
        }
        break;

      case 'user':
        /* get the target user's privacy */
        $get_privacy = $db->query(sprintf("SELECT user_privacy_photos FROM users WHERE user_id = %s", secure($id, 'int')));
        $privacy = $get_privacy->fetch_assoc();
        /* check the target user's privacy */
        if (!$this->check_privacy($privacy['user_privacy_photos'], $id)) {
          return $photos;
        }
        /* check manage photos */
        $manage_photos = false;
        if ($this->_logged_in) {
          /* viewer is (admin|moderator) */
          if ($this->_data['user_group'] < 3) {
            $manage_photos = true;
          }
          /* viewer is the author of photos */
          if ($this->_data['user_id'] == $id) {
            $manage_photos = true;
          }
        }
        /* get all user photos (except photos from groups, events, anonymous posts & paid posts) */
        $offset *= $system['min_results_even'];
        $order_statement = ($get_pinned) ? "posts_photos.pinned DESC, posts_photos.photo_id DESC" : "posts_photos.photo_id DESC";
        $get_photos = $db->query(sprintf("SELECT posts_photos.photo_id, posts_photos.source, posts_photos.blur, posts_photos.pinned, posts.privacy FROM posts_photos INNER JOIN posts ON posts_photos.post_id = posts.post_id WHERE posts.user_id = %s AND posts.user_type = 'user' AND posts.in_group = '0' AND posts.in_event = '0' AND posts.is_anonymous = '0' AND posts.is_paid = '0' AND (posts.pre_approved = '1' OR posts.has_approved = '1') ORDER BY $order_statement LIMIT %s, %s", secure($id, 'int'), secure($offset, 'int', false), secure($system['min_results_even'], 'int', false)));
        if ($get_photos->num_rows > 0) {
          while ($photo = $get_photos->fetch_assoc()) {
            if ($this->check_privacy($photo['privacy'], $id)) {
              $photo['manage'] = $manage_photos;
              $photos[] = $photo;
            }
          }
        }
        break;

      case 'page':
        /* check manage photos */
        $manage_photos = false;
        if ($this->_logged_in) {
          /* viewer is (admin|moderator) */
          if ($this->_data['user_group'] < 3) {
            $manage_photos = true;
          }
          /* viewer is the author of photos */
          if ($this->check_page_adminship($this->_data['user_id'], $id)) {
            $manage_photos = true;
          }
        }
        /* get all page photos */
        $offset *= $system['min_results_even'];
        $get_photos = $db->query(sprintf("SELECT posts_photos.photo_id, posts_photos.source, posts_photos.blur FROM posts_photos INNER JOIN posts ON posts_photos.post_id = posts.post_id WHERE posts.user_id = %s AND posts.user_type = 'page' AND posts.is_paid = '0' AND (posts.pre_approved = '1' OR posts.has_approved = '1') ORDER BY posts_photos.photo_id DESC LIMIT %s, %s", secure($id, 'int'), secure($offset, 'int', false), secure($system['min_results_even'], 'int', false)));
        if ($get_photos->num_rows > 0) {
          while ($photo = $get_photos->fetch_assoc()) {
            $photo['manage'] = $manage_photos;
            $photos[] = $photo;
          }
        }
        break;

      case 'group':
        if (!$pass_check) {
          /* check if the viewer is group member (approved) */
          if ($this->check_group_membership($this->_data['user_id'], $id) != "approved") {
            return $photos;
          }
        }
        /* check manage photos */
        $manage_photos = false;
        if ($this->_logged_in) {
          /* viewer is (admin|moderator) */
          if ($this->_data['user_group'] < 3) {
            $manage_photos = true;
          }
          /* viewer is the author of photos */
          if ($this->check_group_adminship($this->_data['user_id'], $id)) {
            $manage_photos = true;
          }
        }
        /* get all group photos */
        $offset *= $system['min_results_even'];
        $get_photos = $db->query(sprintf("SELECT posts_photos.photo_id, posts_photos.source, posts_photos.blur FROM posts_photos INNER JOIN posts ON posts_photos.post_id = posts.post_id WHERE posts.group_id = %s AND posts.in_group = '1' AND posts.is_paid = '0' AND (posts.pre_approved = '1' OR posts.has_approved = '1') ORDER BY posts_photos.photo_id DESC LIMIT %s, %s", secure($id, 'int'), secure($offset, 'int', false), secure($system['min_results_even'], 'int', false)));
        if ($get_photos->num_rows > 0) {
          while ($photo = $get_photos->fetch_assoc()) {
            $photo['manage'] = $manage_photos;
            $photos[] = $photo;
          }
        }
        break;

      case 'event':
        if (!$pass_check) {
          /* check if the viewer is event member (approved) */
          if (!$this->check_event_membership($this->_data['user_id'], $id)) {
            return $photos;
          }
        }
        /* check manage photos */
        $manage_photos = false;
        if ($this->_logged_in) {
          /* viewer is (admin|moderator) */
          if ($this->_data['user_group'] < 3) {
            $manage_photos = true;
          }
          /* viewer is the author of photos */
          if ($this->check_event_adminship($this->_data['user_id'], $id)) {
            $manage_photos = true;
          }
        }
        /* get all event photos */
        $offset *= $system['min_results_even'];
        $get_photos = $db->query(sprintf("SELECT posts_photos.photo_id, posts_photos.source, posts_photos.blur FROM posts_photos INNER JOIN posts ON posts_photos.post_id = posts.post_id WHERE posts.event_id = %s AND posts.in_event = '1' AND posts.is_paid = '0' AND (posts.pre_approved = '1' OR posts.has_approved = '1') ORDER BY posts_photos.photo_id DESC LIMIT %s, %s", secure($id, 'int'), secure($offset, 'int', false), secure($system['min_results_even'], 'int', false)));
        if ($get_photos->num_rows > 0) {
          while ($photo = $get_photos->fetch_assoc()) {
            $photo['manage'] = $manage_photos;
            $photos[] = $photo;
          }
        }
        break;
    }
    return $photos;
  }


  /**
   * get_photos_count
   * 
   * @param integer $node_id
   * @param string $node_type
   * @return integer
   */
  public function get_photos_count($node_id, $node_type)
  {
    global $db;
    switch ($node_type) {
      case 'user':
        $get_photos = $db->query(sprintf("SELECT COUNT(*) as count FROM posts_photos INNER JOIN posts ON posts_photos.post_id = posts.post_id WHERE posts.user_id = %s AND posts.user_type = 'user' AND posts.in_group = '0' AND posts.in_event = '0' AND (posts.pre_approved = '1' OR posts.has_approved = '1')", secure($node_id, 'int')));
        break;

      case 'page':
        $get_photos = $db->query(sprintf("SELECT COUNT(*) as count FROM posts_photos INNER JOIN posts ON posts_photos.post_id = posts.post_id WHERE posts.user_id = %s AND posts.user_type = 'page' AND (posts.pre_approved = '1' OR posts.has_approved = '1')", secure($node_id, 'int')));
        break;

      case 'group':
        $get_photos = $db->query(sprintf("SELECT COUNT(*) as count FROM posts_photos INNER JOIN posts ON posts_photos.post_id = posts.post_id WHERE posts.group_id = %s AND posts.in_group = '1' AND (posts.pre_approved = '1' OR posts.has_approved = '1')", secure($node_id, 'int')));
        break;

      case 'event':
        $get_photos = $db->query(sprintf("SELECT COUNT(*) as count FROM posts_photos INNER JOIN posts ON posts_photos.post_id = posts.post_id WHERE posts.event_id = %s AND posts.in_event = '1' AND (posts.pre_approved = '1' OR posts.has_approved = '1')", secure($node_id, 'int')));
        break;

      default:
        _error(400);
        break;
    }
    if ($get_photos->num_rows > 0) {
      $count = $get_photos->fetch_assoc();
      return $count['count'];
    }
    return 0;
  }


  /**
   * get_photo
   * 
   * @param integer $photo_id
   * @param boolean $full_details
   * @param boolean $get_gallery
   * @param string $context
   * @return array
   */
  public function get_photo($photo_id, $full_details = false, $get_gallery = false, $context = 'photos')
  {
    global $db, $system;

    /* get photo */
    $get_photo = $db->query(sprintf("SELECT * FROM posts_photos WHERE photo_id = %s", secure($photo_id, 'int')));
    if ($get_photo->num_rows == 0) {
      return false;
    }
    $photo = $get_photo->fetch_assoc();

    /* get post */
    $post = $this->_check_post($photo['post_id'], false, $full_details);
    if (!$post) {
      return false;
    }

    /* check if photo can be deleted */
    if ($post['in_group']) {
      /* check if (cover|profile) photo */
      $photo['can_delete'] = (($photo_id == $post['group_picture_id']) or ($photo_id == $post['group_cover_id'])) ? false : true;
    } elseif ($post['in_event']) {
      /* check if (cover) photo */
      $photo['can_delete'] = (($photo_id == $post['event_cover_id'])) ? false : true;
    } elseif ($post['user_type'] == "user") {
      /* check if (cover|profile) photo */
      $photo['can_delete'] = (($photo_id == $post['user_picture_id']) or ($photo_id == $post['user_cover_id'])) ? false : true;
    } elseif ($post['user_type'] == "page") {
      /* check if (cover|profile) photo */
      $photo['can_delete'] = (($photo_id == $post['page_picture_id']) or ($photo_id == $post['page_cover_id'])) ? false : true;
    }

    /* check photo type [single|mutiple] */
    $check_single = $db->query(sprintf("SELECT COUNT(*) as count FROM posts_photos WHERE post_id = %s", secure($photo['post_id'], 'int')));
    $photo['is_single'] = ($check_single->fetch_assoc()['count'] > 1) ? false : true;

    /* get reactions */
    if ($photo['is_single']) {
      /* [Case: 1] single photo => get (reactions) of post */

      /* get reactions array */
      $photo['reactions'] = $post['reactions'];

      /* get total reactions */
      $photo['reactions_total_count'] = $post['reactions_total_count'];
      $photo['reactions_total_count_formatted'] = $post['reactions_total_count_formatted'];

      /* check if viewer [reacted] this post */
      $photo['i_react'] = $post['i_react'];
      $photo['i_reaction'] = $post['i_reaction'];
    } else {
      /* [Case: 2] mutiple photo => get (reactions) of photo */

      /* get reactions array */
      $photo['reactions']['like'] = $photo['reaction_like_count'];
      $photo['reactions']['love'] = $photo['reaction_love_count'];
      $photo['reactions']['haha'] = $photo['reaction_haha_count'];
      $photo['reactions']['yay'] = $photo['reaction_yay_count'];
      $photo['reactions']['wow'] = $photo['reaction_wow_count'];
      $photo['reactions']['sad'] = $photo['reaction_sad_count'];
      $photo['reactions']['angry'] = $photo['reaction_angry_count'];
      arsort($photo['reactions']);

      /* get total reactions */
      $photo['reactions_total_count'] = $photo['reaction_like_count'] + $photo['reaction_love_count'] + $photo['reaction_haha_count'] + $photo['reaction_yay_count'] + $photo['reaction_wow_count'] + $photo['reaction_sad_count'] + $photo['reaction_angry_count'];
      $photo['reactions_total_count_formatted'] = abbreviate_count($photo['reactions_total_count']);

      /* check if viewer [reacted] this photo */
      $photo['i_react'] = false;
      if ($this->_logged_in) {
        /* reaction */
        $get_reaction = $db->query(sprintf("SELECT reaction FROM posts_photos_reactions WHERE user_id = %s AND photo_id = %s", secure($this->_data['user_id'], 'int'), secure($photo['photo_id'], 'int')));
        if ($get_reaction->num_rows > 0) {
          $photo['i_react'] = true;
          $photo['i_reaction'] = $get_reaction->fetch_assoc()['reaction'];
        }
      }
    }

    /* get full details (comments) */
    if ($full_details) {
      if ($photo['is_single']) {
        /* [Case: 1] single photo => get (comments) of post */

        /* get total comments */
        $photo['comments'] = $post['comments'];
        $photo['comments_formatted'] = abbreviate_count($photo['comments']);

        /* get post comments */
        if ($post['comments'] > 0) {
          $post['post_comments'] = $this->get_comments($post['post_id'], 0, true, true, $post);
        }
      } else {
        /* [Case: 2] mutiple photo => get (comments) of photo */

        /* get photo comments */
        if ($photo['comments'] > 0) {
          $photo['photo_comments'] = $this->get_comments($photo['photo_id'], 0, false, true, $post);
        }
      }
    }

    /* get gallery */
    if ($get_gallery) {
      switch ($context) {
        case 'post':
          $get_post_photos = $db->query(sprintf("SELECT photo_id, source FROM posts_photos WHERE post_id = %s ORDER BY photo_id ASC", secure($post['post_id'], 'int')));
          while ($post_photo = $get_post_photos->fetch_assoc()) {
            $post_photos[$post_photo['photo_id']] = $post_photo;
          }
          $photo['next'] = $post_photos[get_array_key($post_photos, $photo['photo_id'], 1)];
          $photo['prev'] = $post_photos[get_array_key($post_photos, $photo['photo_id'], -1)];
          break;

        case 'album':
          $get_album_photos = $db->query(sprintf("SELECT posts_photos.post_id, posts_photos.photo_id, posts_photos.source, posts.user_id, posts.privacy FROM posts_photos INNER JOIN posts ON posts_photos.post_id = posts.post_id WHERE posts_photos.album_id = %s", secure($photo['album_id'], 'int')));
          while ($album_photo = $get_album_photos->fetch_assoc()) {
            /* check the photo privacy */
            if ($album_photo['privacy'] == "public" || $album_photo['privacy'] == "custom") {
              $album_photos[$album_photo['photo_id']] = $album_photo;
            } else {
              /* check the photo privacy */
              if ($this->check_privacy($album_photo['privacy'], $album_photo['user_id'])) {
                $album_photos[$album_photo['photo_id']] = $album_photo;
              }
            }
          }
          $photo['next'] = ($post['is_anonymous']) ? null : $album_photos[get_array_key($album_photos, $photo['photo_id'], -1)];
          $photo['prev'] = ($post['is_anonymous']) ? null : $album_photos[get_array_key($album_photos, $photo['photo_id'], 1)];
          /* check the next & prev photos posts (if paid or for subscribers) */
          if ($photo['next']) {
            $next_post = $this->_check_post($photo['next']['post_id'], false, false);
            if ($next_post['needs_payment'] || $next_post['needs_subscription']) {
              $photo['next'] = null;
            }
          }
          if ($photo['prev']) {
            $prev_post = $this->_check_post($photo['prev']['post_id'], false, false);
            if ($prev_post['needs_payment'] || $prev_post['needs_subscription']) {
              $photo['prev'] = null;
            }
          }
          break;

        case 'photos':
          if ($post['in_group']) {
            $get_target_photos = $db->query(sprintf("SELECT posts_photos.post_id, posts_photos.photo_id, posts_photos.source, posts.user_id, posts.privacy FROM posts_photos INNER JOIN posts ON posts_photos.post_id = posts.post_id WHERE posts.in_group = '1' AND posts.group_id = %s", secure($post['group_id'], 'int')));
          } elseif ($post['in_event']) {
            $get_target_photos = $db->query(sprintf("SELECT posts_photos.post_id, posts_photos.photo_id, posts_photos.source, posts.user_id, posts.privacy FROM posts_photos INNER JOIN posts ON posts_photos.post_id = posts.post_id WHERE posts.in_event = '1' AND posts.event_id = %s", secure($post['event_id'], 'int')));
          } elseif ($post['user_type'] == "page") {
            $get_target_photos = $db->query(sprintf("SELECT posts_photos.post_id, posts_photos.photo_id, posts_photos.source, posts.user_id, posts.privacy FROM posts_photos INNER JOIN posts ON posts_photos.post_id = posts.post_id WHERE posts.user_type = 'page' AND posts.user_id = %s", secure($post['user_id'], 'int')));
          } elseif ($post['user_type'] == "user") {
            $get_target_photos = $db->query(sprintf("SELECT posts_photos.post_id, posts_photos.photo_id, posts_photos.source, posts.user_id, posts.privacy FROM posts_photos INNER JOIN posts ON posts_photos.post_id = posts.post_id WHERE posts.user_type = 'user' AND posts.user_id = %s", secure($post['user_id'], 'int')));
          }
          while ($target_photo = $get_target_photos->fetch_assoc()) {
            /* check the photo privacy */
            if ($target_photo['privacy'] == "public" || $target_photo['privacy'] == "custom") {
              $target_photos[$target_photo['photo_id']] = $target_photo;
            } else {
              /* check the photo privacy */
              if ($this->check_privacy($target_photo['privacy'], $target_photo['user_id'])) {
                $target_photos[$target_photo['photo_id']] = $target_photo;
              }
            }
          }
          $photo['next'] = $target_photos[get_array_key($target_photos, $photo['photo_id'], -1)];
          $photo['prev'] = $target_photos[get_array_key($target_photos, $photo['photo_id'], 1)];
          /* check the next & prev photos posts (if paid or for subscribers) */
          if ($photo['next']) {
            $next_post = $this->_check_post($photo['next']['post_id'], false, false);
            if ($next_post['needs_payment'] || $next_post['needs_subscription']) {
              $photo['next'] = null;
            }
          }
          if ($photo['prev']) {
            $prev_post = $this->_check_post($photo['prev']['post_id'], false, false);
            if ($prev_post['needs_payment'] || $prev_post['needs_subscription']) {
              $photo['prev'] = null;
            }
          }
          break;
      }
    }

    /* og-meta tags */
    $photo['og_title'] = $post['post_author_name'];
    $photo['og_title'] .= ($post['text'] != "") ? " - " . $post['text'] : "";
    $photo['og_description'] = $post['text'];
    $photo['og_image'] = $system['system_uploads'] . '/' . $photo['source'];

    /* return post array with photo */
    $photo['post'] = $post;
    return $photo;
  }


  /**
   * delete_photo
   * 
   * @param integer $photo_id
   * @return void
   */
  public function delete_photo($photo_id)
  {
    global $db, $system;
    /* (check|get) photo */
    $photo = $this->get_photo($photo_id);
    if (!$photo) {
      _error(403);
    }
    $post = $photo['post'];
    /* check if viewer can manage post */
    if (!$post['manage_post']) {
      _error(403);
    }
    /* check if photo can be deleted */
    if (!$photo['can_delete']) {
      throw new Exception(__("This photo can't be deleted as it maybe your current profile image or cover"));
    }
    /* delete the photo */
    $db->query(sprintf("DELETE FROM posts_photos WHERE photo_id = %s", secure($photo_id, 'int')));
    /* delete photo from uploads folder */
    delete_uploads_file($photo['source']);
  }


  /**
   * pin_photo
   * 
   * @param integer $photo_id
   * @return void
   */
  public function pin_photo($photo_id)
  {
    global $db, $system;
    /* (check|get) photo */
    $photo = $this->get_photo($photo_id);
    if (!$photo) {
      _error(403);
    }
    $post = $photo['post'];
    /* check if viewer can manage post */
    if (!$post['manage_post']) {
      _error(403);
    }
    /* pin the photo */
    $db->query(sprintf("UPDATE posts_photos SET pinned = '1' WHERE photo_id = %s", secure($photo_id, 'int')));
  }


  /**
   * unpin_photo
   * 
   * @param integer $photo_id
   * @return void
   */
  public function unpin_photo($photo_id)
  {
    global $db, $system;
    /* (check|get) photo */
    $photo = $this->get_photo($photo_id);
    if (!$photo) {
      _error(403);
    }
    $post = $photo['post'];
    /* check if viewer can manage post */
    if (!$post['manage_post']) {
      _error(403);
    }
    /* unpin the photo */
    $db->query(sprintf("UPDATE posts_photos SET pinned = '0' WHERE photo_id = %s", secure($photo_id, 'int')));
  }


  /**
   * react_photo
   * 
   * @param integer $photo_id
   * @param string $reaction
   * @return void
   */
  public function react_photo($photo_id, $reaction)
  {
    global $db, $date;
    /* check reation */
    if (!in_array($reaction, ['like', 'love', 'haha', 'yay', 'wow', 'sad', 'angry'])) {
      _error(403);
    }
    /* (check|get) photo */
    $photo = $this->get_photo($photo_id);
    if (!$photo) {
      _error(403);
    }
    $post = $photo['post'];
    /* check blocking */
    if ($post['user_type'] == "user" && $this->blocked($post['author_id'])) {
      _error(403);
    }

    /* reaction the post */
    if ($photo['i_react']) {
      /* remove any previous reaction */
      $db->query(sprintf("DELETE FROM posts_photos_reactions WHERE user_id = %s AND photo_id = %s", secure($this->_data['user_id'], 'int'), secure($photo_id, 'int')));
      /* update photo reaction counter */
      $reaction_field = "reaction_" . $photo['i_reaction'] . "_count";
      $db->query(sprintf("UPDATE posts_photos SET $reaction_field = IF($reaction_field=0,0,$reaction_field-1) WHERE photo_id = %s", secure($photo_id, 'int')));
      /* delete notification */
      $this->delete_notification($post['author_id'], 'react_' . $photo['i_reaction'], 'photo', $photo_id);
    }
    $db->query(sprintf("INSERT INTO posts_photos_reactions (user_id, photo_id, reaction, reaction_time) VALUES (%s, %s, %s, %s)", secure($this->_data['user_id'], 'int'), secure($photo_id, 'int'), secure($reaction), secure($date)));
    $reaction_id = $db->insert_id;
    /* update photo reaction counter */
    $reaction_field = "reaction_" . $reaction . "_count";
    $db->query(sprintf("UPDATE posts_photos SET $reaction_field = $reaction_field + 1 WHERE photo_id = %s", secure($photo_id, 'int')));
    /* post notification */
    $this->post_notification(['to_user_id' => $post['author_id'], 'action' => 'react_' . $reaction, 'node_type' => 'photo', 'node_url' => $photo_id]);
    /* points balance */
    $this->points_balance("add", $this->_data['user_id'], "posts_photos_reactions", $reaction_id);
  }


  /**
   * unreact_photo
   * 
   * @param integer $photo_id
   * @param string $reaction
   * @return void
   */
  public function unreact_photo($photo_id, $reaction)
  {
    global $db;
    /* (check|get) photo */
    $photo = $this->get_photo($photo_id);
    if (!$photo) {
      _error(403);
    }
    $post = $photo['post'];
    /* unreact the photo */
    $db->query(sprintf("DELETE FROM posts_photos_reactions WHERE user_id = %s AND photo_id = %s", secure($this->_data['user_id'], 'int'), secure($photo_id, 'int')));
    /* update photo reaction counter */
    $reaction_field = "reaction_" . $photo['i_reaction'] . "_count";
    $db->query(sprintf("UPDATE posts_photos SET $reaction_field = IF($reaction_field=0,0,$reaction_field-1) WHERE photo_id = %s", secure($photo_id, 'int')));
    /* delete notification */
    $this->delete_notification($post['author_id'], 'react_' . $reaction, 'photo', $photo_id);
    /* points balance */
    $this->points_balance("delete", $this->_data['user_id'], "posts_photos_reactions");
  }


  /**
   * get_albums
   * 
   * @param integer $user_id
   * @param string $type
   * @param integer $offset
   * @return array
   */
  public function get_albums($id, $type = 'user', $offset = 0)
  {
    global $db, $system;
    /* initialize vars */
    $albums = [];
    $offset *= $system['max_results_even'];
    switch ($type) {
      case 'user':
        $get_albums = $db->query(sprintf("SELECT album_id FROM posts_photos_albums WHERE user_type = 'user' AND user_id = %s AND in_group = '0' AND in_event = '0' LIMIT %s, %s", secure($id, 'int'), secure($offset, 'int', false), secure($system['max_results_even'], 'int', false)));
        break;

      case 'page':
        $get_albums = $db->query(sprintf("SELECT album_id FROM posts_photos_albums WHERE user_type = 'page' AND user_id = %s LIMIT %s, %s", secure($id, 'int'), secure($offset, 'int', false), secure($system['max_results_even'], 'int', false)));
        break;

      case 'group':
        $get_albums = $db->query(sprintf("SELECT album_id FROM posts_photos_albums WHERE in_group = '1' AND group_id = %s LIMIT %s, %s", secure($id, 'int'), secure($offset, 'int', false), secure($system['max_results_even'], 'int', false)));
        break;

      case 'event':
        $get_albums = $db->query(sprintf("SELECT album_id FROM posts_photos_albums WHERE in_event = '1' AND event_id = %s LIMIT %s, %s", secure($id, 'int'), secure($offset, 'int', false), secure($system['max_results_even'], 'int', false)));
        break;
    }
    if ($get_albums->num_rows > 0) {
      while ($album = $get_albums->fetch_assoc()) {
        $album = $this->get_album($album['album_id'], false); /* $full_details = false */
        if ($album) {
          $albums[] = $album;
        }
      }
    }
    return $albums;
  }


  /**
   * get_album
   * 
   * @param integer $album_id
   * @param boolean $full_details
   * @return array
   */
  public function get_album($album_id, $full_details = true)
  {
    global $db, $system;
    $get_album = $db->query(sprintf("SELECT posts_photos_albums.*, users.user_name, users.user_album_pictures, users.user_album_covers, users.user_album_timeline, pages.page_id, pages.page_name, pages.page_admin, pages.page_album_pictures, pages.page_album_covers, pages.page_album_timeline, `groups`.group_name, `groups`.group_admin, `groups`.group_album_pictures, `groups`.group_album_covers, `groups`.group_album_timeline, `events`.event_admin, `events`.event_album_covers, `events`.event_album_timeline FROM posts_photos_albums LEFT JOIN users ON posts_photos_albums.user_id = users.user_id AND posts_photos_albums.user_type = 'user' LEFT JOIN pages ON posts_photos_albums.user_id = pages.page_id AND posts_photos_albums.user_type = 'page' LEFT JOIN `groups` ON posts_photos_albums.in_group = '1' AND posts_photos_albums.group_id = `groups`.group_id LEFT JOIN `events` ON posts_photos_albums.in_event = '1' AND posts_photos_albums.event_id = `events`.event_id WHERE NOT (users.user_name <=> NULL AND pages.page_name <=> NULL) AND posts_photos_albums.album_id = %s", secure($album_id, 'int')));
    if ($get_album->num_rows == 0) {
      return false;
    }
    $album = $get_album->fetch_assoc();
    /* get the author */
    $album['author_id'] = ($album['user_type'] == "page") ? $album['page_admin'] : $album['user_id'];
    /* check the album privacy  */
    /* if album in group & (the group is public || the viewer approved member of this group) => pass privacy check */
    if ($album['in_group'] && ($album['group_privacy'] == 'public' || $this->check_group_membership($this->_data['user_id'], $album['group_id']) == 'approved')) {
      $pass_privacy_check = true;
    }
    /* if album in event & (the event is public || the viewer member of this event) => pass privacy check */
    if ($album['in_event'] && ($album['event_privacy'] == 'public' || $this->check_event_membership($this->_data['user_id'], $album['event_id']))) {
      $pass_privacy_check = true;
    }
    if (!$pass_privacy_check) {
      if (!$this->check_privacy($album['privacy'], $album['author_id'])) {
        return false;
      }
    }
    /* get album path */
    if ($album['in_group']) {
      $album['path'] = 'groups/' . $album['group_name'];
      /* check if (cover|profile|timeline) album */
      $album['can_delete'] = (($album_id == $album['group_album_pictures']) or ($album_id == $album['group_album_covers']) or ($album_id == $album['group_album_timeline'])) ? false : true;
    } elseif ($album['in_event']) {
      $album['path'] = 'events/' . $album['event_id'];
      /* check if (cover|profile|timeline) album */
      $album['can_delete'] = (($album_id == $album['event_album_pictures']) or ($album_id == $album['event_album_covers']) or ($album_id == $album['event_album_timeline'])) ? false : true;
    } elseif ($album['user_type'] == "user") {
      $album['path'] = $album['user_name'];
      /* check if (cover|profile|timeline) album */
      $album['can_delete'] = (($album_id == $album['user_album_pictures']) or ($album_id == $album['user_album_covers']) or ($album_id == $album['user_album_timeline'])) ? false : true;
    } elseif ($album['user_type'] == "page") {
      $album['path'] = 'pages/' . $album['page_name'];
      /* check if (cover|profile|timeline) album */
      $album['can_delete'] = (($album_id == $album['user_album_timeline']) or ($album_id == $album['page_album_covers']) or ($album_id == $album['page_album_timeline'])) ? false : true;
    }
    /* get album cover photo */
    $where_statement = ($album['user_type'] == "user" && !$album['in_group'] && !$album['in_event']) ? "posts.privacy = 'public' AND" : '';
    $get_cover = $db->query(sprintf("SELECT source, blur FROM posts_photos INNER JOIN posts ON posts_photos.post_id = posts.post_id WHERE " . $where_statement . " posts_photos.album_id = %s AND posts.is_paid = '0' ORDER BY photo_id DESC LIMIT 1", secure($album_id, 'int')));
    if ($get_cover->num_rows == 0) {
      $album['cover']['source'] = $system['system_url'] . '/content/themes/' . $system['theme'] . '/images/blank_album.png';
      $album['cover']['blur'] = 0;
    } else {
      $cover = $get_cover->fetch_assoc();
      $album['cover']['source'] = $system['system_uploads'] . '/' . $cover['source'];
      $album['cover']['blur'] = $cover['blur'];
    }
    /* get album total photos count */
    $get_album_photos_count = $db->query(sprintf("SELECT COUNT(*) as count FROM posts_photos WHERE album_id = %s", secure($album_id, 'int')));
    $album['photos_count'] = $get_album_photos_count->fetch_assoc()['count'];
    /* check if viewer can manage album [Edit|Update|Delete] */
    $album['is_page_admin'] = $this->check_page_adminship($this->_data['user_id'], $album['page_id']);
    $album['is_group_admin'] = $this->check_group_adminship($this->_data['user_id'], $album['group_id']);
    $album['is_event_admin'] = $this->check_event_adminship($this->_data['user_id'], $album['event_id']);
    /* check if viewer can manage album [Edit|Update|Delete] */
    $album['manage_album'] = false;
    if ($this->_logged_in) {
      /* viewer is (admin|moderator) */
      if ($this->_data['user_group'] < 3) {
        $album['manage_album'] = true;
      }
      /* viewer is the author of post */
      if ($this->_data['user_id'] == $album['author_id']) {
        $album['manage_album'] = true;
      }
      /* viewer is the admin of the page */
      if ($album['user_type'] == "page" && $album['is_page_admin']) {
        $album['manage_album'] = true;
      }
      /* viewer is the admin of the group */
      if ($album['in_group'] && $album['is_group_admin']) {
        $album['manage_album'] = true;
      }
      /* viewer is the admin of the event */
      if ($album['in_event'] && $album['is_event_admin']) {
        $album['manage_album'] = true;
      }
    }
    /* get album photos */
    if ($full_details) {
      $album['photos'] = $this->get_photos($album_id, 'album');
    }
    return $album;
  }


  /**
   * delete_album
   * 
   * @param integer $album_id
   * @return void
   */
  public function delete_album($album_id)
  {
    global $db, $system;
    /* (check|get) album */
    $album = $this->get_album($album_id, false);
    if (!$album) {
      _error(403);
    }
    /* check if viewer can manage album */
    if (!$album['manage_album']) {
      _error(403);
    }
    /* check if album can be deleted */
    if (!$album['can_delete']) {
      throw new Exception(__("This album can't be deleted"));
    }
    /* delete the album */
    $db->query(sprintf("DELETE FROM posts_photos_albums WHERE album_id = %s", secure($album_id, 'int')));
    /* delete all album photos */
    $db->query(sprintf("DELETE FROM posts_photos WHERE album_id = %s", secure($album_id, 'int')));
    /* retrun path */
    $path = $system['system_url'] . "/" . $album['path'] . "/albums";
    return $path;
  }


  /**
   * edit_album
   * 
   * @param integer $album_id
   * @param string $title
   * @return void
   */
  public function edit_album($album_id, $title)
  {
    global $db;
    /* (check|get) album */
    $album = $this->get_album($album_id, false);
    if (!$album) {
      _error(400);
    }
    /* check if viewer can manage album */
    if (!$album['manage_album']) {
      _error(400);
    }
    /* validate all fields */
    if (is_empty($title)) {
      throw new Exception(__("You must fill in all of the fields"));
    }
    /* edit the album */
    $db->query(sprintf("UPDATE posts_photos_albums SET title = %s WHERE album_id = %s", secure($title), secure($album_id, 'int')));
  }


  /**
   * add_photos
   * 
   * @param array $args
   * @return array
   */
  public function add_album_photos($args = [])
  {
    global $db, $system, $date;
    /* (check|get) album */
    $album = $this->get_album($args['album_id'], false);
    if (!$album) {
      _error(400);
    }
    /* check if viewer can manage album */
    if (!$album['manage_album']) {
      _error(400);
    }
    /* check user_id */
    $user_id = ($album['user_type'] == "page") ? $album['page_id'] : $album['user_id'];
    /* check privacy */
    if ($album['in_group'] || $album['in_event']) {
      $args['privacy'] = 'custom';
    } elseif ($album['user_type'] == "page") {
      $args['privacy'] = 'public';
    } else {
      if (!in_array($args['privacy'], ['me', 'friends', 'public'])) {
        $args['privacy'] = 'public';
      }
    }
    /* post feeling */
    $post['feeling_action'] = '';
    $post['feeling_value'] = '';
    $post['feeling_icon'] = '';
    if (!is_empty($args['feeling_action']) && !is_empty($args['feeling_value'])) {
      if ($args['feeling_action'] != "Feeling") {
        $_feeling_icon = get_feeling_icon($args['feeling_action'], get_feelings());
      } else {
        $_feeling_icon = get_feeling_icon($args['feeling_value'], get_feelings_types());
      }
      if ($_feeling_icon) {
        $post['feeling_action'] = $args['feeling_action'];
        $post['feeling_value'] = $args['feeling_value'];
        $post['feeling_icon'] = $_feeling_icon;
      }
    }
    /* insert the post */
    $db->query(sprintf("INSERT INTO posts (user_id, user_type, in_group, group_id, in_event, event_id, post_type, time, location, privacy, text, feeling_action, feeling_value) VALUES (%s, %s, %s, %s, %s, %s, 'album', %s, %s, %s, %s, %s, %s)", secure($user_id, 'int'), secure($album['user_type']), secure($album['in_group']), secure($album['group_id'], 'int'), secure($album['in_event']), secure($album['event_id'], 'int'), secure($date), secure($args['location']), secure($args['privacy']), secure($args['message']), secure($post['feeling_action']), secure($post['feeling_value'])));
    $post_id = $db->insert_id;
    /* insert new photos */
    foreach ($args['photos'] as $photo) {
      $db->query(sprintf("INSERT INTO posts_photos (post_id, album_id, source, blur) VALUES (%s, %s, %s, %s)", secure($post_id, 'int'), secure($args['album_id'], 'int'), secure($photo['source']), secure($photo['blur'])));
    }
    /* remove pending uploads */
    remove_pending_uploads(array_column($args['photos'], 'source'));
    /* post mention notifications */
    $this->post_mentions($args['message'], $post_id);
    return $post_id;
  }
}
