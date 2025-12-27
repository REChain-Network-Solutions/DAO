<?php

/**
 * trait -> publisher
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich
 */

trait PublisherTrait
{

  /* ------------------------------- */
  /* Publisher */
  /* ------------------------------- */

  /**
   * publisher
   * 
   * @param array $args
   * @return array
   */
  public function publisher($args = [])
  {
    global $db, $system, $date;

    /* check posts permission */
    if (!$this->_data['can_publish_posts']) {
      throw new Exception(__("You don't have the permission to do this"));
    }

    /* check if verification for posts required */
    if ($system['verification_for_posts'] && !$this->_data['user_verified']) {
      throw new Exception(__("To enable this feature your account must be verified"));
    }

    /* check max posts/hour limit */
    $this->check_posts_limit($args['handle'], $args['id']);

    /* check post max length */
    if ($system['max_post_length'] > 0 && $this->_data['user_group'] >= 3) {
      if (strlen($args['message']) >= $system['max_post_length']) {
        modal("MESSAGE", __("Text Length Limit Reached"), __("Your message characters length is over the allowed limit") . " (" . $system['max_post_length'] . " " . __("Characters") . ")");
      }
    }

    /* prepare returned post */
    $post = [];
    $post['user_id'] = $this->_data['user_id'];
    $post['user_type'] = "user";
    $post['in_wall'] = 0;
    $post['wall_id'] = null;
    $post['in_group'] = 0;
    $post['group_id'] = null;
    $post['group_approved'] = 0;
    $post['in_event'] = 0;
    $post['event_id'] = null;
    $post['event_approved'] = 0;

    $post['author_id'] = $this->_data['user_id'];
    $post['post_author_picture'] = $this->_data['user_picture'];
    $post['post_author_url'] = $system['system_url'] . '/' . $this->_data['user_name'];
    $post['post_author_name'] = $this->_data['user_fullname'];
    $post['post_author_verified'] = $this->_data['user_verified'];
    $post['post_author_online'] = false;

    /* check the handle */
    if ($args['handle'] == "user") {
      /* check if system allow wall posts */
      if (!$system['wall_posts_enabled']) {
        _error(400);
      }
      /* check if the user is valid & the viewer can post on his wall */
      $check_user = $db->query(sprintf("SELECT * FROM users WHERE user_id = %s", secure($args['id'], 'int')));
      if ($check_user->num_rows == 0) {
        _error(400);
      }
      $_user = $check_user->fetch_assoc();
      if ($_user['user_privacy_wall'] == 'me' || ($_user['user_privacy_wall'] == 'friends' && !$this->friendship_approved($args['id']))) {
        _error(400);
      }
      $post['in_wall'] = 1;
      $post['wall_id'] = $args['id'];
      $post['wall_username'] = $_user['user_name'];
      $post['wall_fullname'] = ($system['show_usernames_enabled']) ? $_user['user_name'] : $_user['user_firstname'] . " " . $_user['user_lastname'];
    } elseif ($args['handle'] == "page") {
      /* check if the page is valid */
      $check_page = $db->query(sprintf("SELECT * FROM pages WHERE page_id = %s", secure($args['id'], 'int')));
      if ($check_page->num_rows == 0) {
        _error(400);
      }
      $_page = $check_page->fetch_assoc();
      /* check if the viewer is the admin */
      if (!$this->check_page_adminship($this->_data['user_id'], $args['id'])) {
        _error(400);
      }
      $post['user_id'] = $_page['page_id'];
      $post['user_type'] = "page";
      $post['post_author_picture'] = get_picture($_page['page_picture'], "page");
      $post['post_author_url'] = $system['system_url'] . '/pages/' . $_page['page_name'];
      $post['post_author_name'] = $_page['page_title'];
      $post['post_author_verified'] = $this->_data['page_verified'];
    } elseif ($args['handle'] == "group") {
      /* check if the group is valid & the viewer is group member (approved) */
      $check_group = $db->query(sprintf("SELECT `groups`.* FROM `groups` INNER JOIN groups_members ON `groups`.group_id = groups_members.group_id WHERE groups_members.approved = '1' AND groups_members.user_id = %s AND groups_members.group_id = %s", secure($this->_data['user_id'], 'int'), secure($args['id'], 'int')));
      $_group = $check_group->fetch_assoc();
      if (!$_group) {
        _error(400);
      }
      $_group['i_admin'] = $this->check_group_adminship($this->_data['user_id'], $_group['group_id']);
      /* check if group publish enabled */
      if (!$_group['group_publish_enabled'] && !$_group['i_admin']) {
        modal("MESSAGE", __("Sorry"), __("Publish posts disabled by admin"));
      }
      $post['in_group'] = 1;
      $post['group_id'] = $args['id'];
      $post['group_approved'] = ($_group['group_publish_approval_enabled'] && !$_group['i_admin']) ? '0' : '1';
    } elseif ($args['handle'] == "event") {
      /* check if the event is valid & the viewer is event member */
      $check_event = $db->query(sprintf("SELECT `events`.* FROM `events` INNER JOIN events_members ON `events`.event_id = events_members.event_id WHERE events_members.user_id = %s AND events_members.event_id = %s", secure($this->_data['user_id'], 'int'), secure($args['id'], 'int')));
      $_event = $check_event->fetch_assoc();
      if (!$_event) {
        _error(400);
      }
      $_event['i_admin'] = $this->check_event_adminship($this->_data['user_id'], $_event['event_id']);
      /* check if event publish enabled */
      if (!$_event['event_publish_enabled'] && !$_event['i_admin']) {
        modal("MESSAGE", __("Sorry"), __("Publish posts disabled by admin"));
      }
      $post['in_event'] = 1;
      $post['event_id'] = $args['id'];
      $post['event_approved'] = ($_event['event_publish_approval_enabled'] && !$_event['i_admin']) ? '0' : '1';
      /* post as page */
      if (isset($args['post_as_page'])) {
        /* check if the page is valid */
        $check_page = $db->query(sprintf("SELECT * FROM pages WHERE page_id = %s", secure($args['post_as_page'], 'int')));
        if ($check_page->num_rows == 0) {
          _error(400);
        }
        $_page = $check_page->fetch_assoc();
        /* check if the viewer is the admin */
        if (!$this->check_page_adminship($this->_data['user_id'], $args['post_as_page'])) {
          _error(400);
        }
        $post['user_id'] = $_page['page_id'];
        $post['user_type'] = "page";
        $post['post_author_picture'] = get_picture($_page['page_picture'], "page");
        $post['post_author_url'] = $system['system_url'] . '/pages/' . $_page['page_name'];
        $post['post_author_name'] = $_page['page_title'];
        $post['post_author_verified'] = $this->_data['page_verified'];
      }
    }

    /* check the user_type to set user online or not */
    if ($post['user_type'] == "user") {
      if ($this->_data['user_chat_enabled']) {
        $post['post_author_online'] = true;
      }
    }

    /* prepare approval system */
    $post['pre_approved'] = 1;
    $post['has_approved'] = 1;
    if ($this->check_posts_needs_approval($post['user_id'], $post['user_type'])) {
      $post['pre_approved'] = 0;
      $post['has_approved'] = 0;
    }

    /* prepare post data */
    $post['text'] = $args['message'];
    $post['location'] = $args['location'];
    $post['privacy'] = $args['privacy'];
    $post['is_schedule'] = (isset($args['is_schedule'])) ? $args['is_schedule'] : '0';
    $post['time'] = ($post['is_schedule']) ? $args['schedule_date'] : $date;
    $post['still_scheduled'] = ($post['is_schedule']) ? '1' : '0';
    $post['is_anonymous'] = (isset($args['is_anonymous'])) ? $args['is_anonymous'] : '0';
    $post['for_adult'] = (isset($args['for_adult'])) ? $args['for_adult'] : '0';
    $post['tips_enabled'] = (isset($args['tips_enabled'])) ? $args['tips_enabled'] : '0';
    $post['for_subscriptions'] = (isset($args['for_subscriptions'])) ? $args['for_subscriptions'] : '0';
    $post['subscriptions_image'] = $args['subscriptions_image'];
    /* check monetization permission */
    if ($post['for_subscriptions']) {
      switch ($args['handle']) {
        case 'me':
          if (!($this->_data['can_monetize_content'] && $this->_data['user_monetization_enabled'] && $this->_data['user_monetization_plans'] > 0)) {
            throw new Exception(__("You don't have the permission to do this"));
          }
          break;

        case 'page':
          /* check if page's admin can monetize content */
          $_page['can_monetize_content'] = $system['monetization_enabled'] && $this->check_user_permission($_page['page_admin'], 'monetization_permission');
          /* check if page has monetization enabled && subscriptions plans */
          $_page['has_subscriptions_plans'] = $_page['can_monetize_content'] && $_page['page_monetization_enabled'] && $_page['page_monetization_plans'] > 0;
          if (!$_page['has_subscriptions_plans']) {
            throw new Exception(__("You don't have the permission to do this"));
          }
          break;

        case 'group':
          /* check if group's admin can monetize content */
          $_group['can_monetize_content'] = $system['monetization_enabled'] && $this->check_user_permission($_group['group_admin'], 'monetization_permission');
          /* check if group has monetization enabled && subscriptions plans */
          $_group['has_subscriptions_plans'] = $_group['can_monetize_content'] && $_group['group_monetization_enabled'] && $_group['group_monetization_plans'] > 0;
          if (!$_group['has_subscriptions_plans']) {
            throw new Exception(__("You don't have the permission to do this"));
          }
          break;

        default:
          throw new Exception(__("You don't have the permission to do this"));
          break;
      }
    }
    $post['is_paid'] = (isset($args['is_paid'])) ? $args['is_paid'] : '0';
    $post['is_paid_locked'] = (isset($args['is_paid_locked'])) ? $args['is_paid_locked'] : '0';
    $post['post_price'] = $args['post_price'];
    $post['paid_text'] = $args['paid_text'];
    $post['paid_image'] = $args['paid_image'];
    $post['reaction_like_count'] = 0;
    $post['reaction_love_count'] = 0;
    $post['reaction_haha_count'] = 0;
    $post['reaction_yay_count'] = 0;
    $post['reaction_wow_count'] = 0;
    $post['reaction_sad_count'] = 0;
    $post['reaction_angry_count'] = 0;
    $post['reactions_total_count'] = 0;
    $post['comments'] = 0;
    $post['shares'] = 0;
    $post['views'] = 0;
    $post['processing'] = '0';
    $post['can_get_details'] = '1';

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

    /* post colored pattern */
    $post['colored_pattern'] = $args['colored_pattern'];

    /* prepare post type */
    if ($args['link']) {
      if ($args['link']->source_type == "link") {
        $post['post_type'] = 'link';
      } else {
        $post['post_type'] = 'media';
      }
    } elseif ($args['product']) {
      $post['post_type'] = 'product';
      $post['privacy'] = ($args['privacy']) ? $args['privacy'] : "public";
    } elseif ($args['funding']) {
      $post['post_type'] = 'funding';
      $post['privacy'] = "public";
    } elseif ($args['offer']) {
      $post['post_type'] = 'offer';
    } elseif ($args['job']) {
      $post['post_type'] = 'job';
    } elseif ($args['course']) {
      $post['post_type'] = 'course';
    } elseif ($args['poll_options']) {
      $post['post_type'] = 'poll';
    } elseif ($args['reel']) {
      $post['post_type'] = 'reel';
      /* check if ffmpeg enabled */
      if ($system['ffmpeg_enabled']) {
        $post['processing'] = '1';
      }
    } elseif (($args['photos'] && count($args['photos']) > 0) || $args['video'] || $args['audio'] || $args['file']) {
      /* post contains video */
      if ($args['video']) {
        $post['post_type'] = 'video';
        /* check if ffmpeg enabled */
        if ($system['ffmpeg_enabled']) {
          $post['processing'] = '1';
        }
      }
      /* post contains audio */
      if ($args['audio']) {
        $post['post_type'] = ($post['post_type'] == 'video') ? 'combo' : 'audio';
      }
      /* post contains file */
      if ($args['file']) {
        $post['post_type'] = (in_array($post['post_type'], ['combo', 'video', 'audio'])) ? 'combo' : 'file';
      }
      /* post contains photos */
      if ($args['photos'] && count($args['photos']) > 0) {
        if (!is_empty($args['album'])) {
          $post['post_type'] = 'album';
        } else {
          $post['post_type'] = (in_array($post['post_type'], ['combo', 'video', 'audio', 'file'])) ? 'combo' : 'photos';
        }
      }
    } else {
      if ($post['location'] != '') {
        $post['post_type'] = 'map';
      } else {
        $post['post_type'] = '';
      }
    }

    /* check if paid modules enabled */
    switch ($post['post_type']) {
      case 'product':
        if ($system['paid_products_enabled']) {
          $this->wallet_paid_module_payment('products');
        }
        break;

      case 'funding':
        if ($system['paid_funding_enabled']) {
          $this->wallet_paid_module_payment('funding');
        }
        break;

      case 'offer':
        if ($system['paid_offers_enabled']) {
          $this->wallet_paid_module_payment('offers');
        }
        break;

      case 'job':
        if ($system['paid_jobs_enabled']) {
          $this->wallet_paid_module_payment('jobs');
        }
        break;

      case 'course':
        if ($system['paid_courses_enabled']) {
          $this->wallet_paid_module_payment('courses');
        }
        break;
    }

    /* insert the post */
    $db->query(sprintf("INSERT INTO posts (user_id, user_type, in_wall, wall_id, in_group, group_id, group_approved, in_event, event_id, event_approved, post_type, colored_pattern, time, location, privacy, text, feeling_action, feeling_value, for_adult, is_schedule, is_anonymous, tips_enabled, for_subscriptions, subscriptions_image, is_paid, is_paid_locked, post_price, paid_text, paid_image, processing, pre_approved, has_approved, post_latitude, post_longitude) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)", secure($post['user_id'], 'int'), secure($post['user_type']), secure($post['in_wall'], 'int'), secure($post['wall_id'], 'int'), secure($post['in_group']), secure($post['group_id'], 'int'), secure($post['group_approved']), secure($post['in_event']), secure($post['event_id'], 'int'), secure($post['event_approved']), secure($post['post_type']), secure($post['colored_pattern'], 'int'), secure($post['time']), secure($post['location']), secure($post['privacy']), secure($post['text']), secure($post['feeling_action']), secure($post['feeling_value']), secure($post['for_adult']), secure($post['is_schedule']), secure($post['is_anonymous']), secure($post['tips_enabled']), secure($post['for_subscriptions']), secure($post['subscriptions_image']), secure($post['is_paid']), secure($post['is_paid_locked']), secure($post['post_price'], 'float'), secure($post['paid_text']), secure($post['paid_image']), secure($post['processing']), secure($post['pre_approved']), secure($post['has_approved']), secure($this->_data['user_latitude']), secure($this->_data['user_longitude'])));
    $post['post_id'] = $db->insert_id;

    /* remove pending uploads */
    remove_pending_uploads([$post['subscriptions_image'], $post['paid_image']]);

    /* insert the post [link] */
    if ($post['post_type'] == 'link') {
      $db->query(sprintf("INSERT INTO posts_links (post_id, source_url, source_host, source_title, source_text, source_thumbnail) VALUES (%s, %s, %s, %s, %s, %s)", secure($post['post_id'], 'int'), secure($args['link']->source_url), secure($args['link']->source_host), secure($args['link']->source_title), secure($args['link']->source_text), secure($args['link']->source_thumbnail)));
      $post['link']['link_id'] = $db->insert_id;
      $post['link']['post_id'] = $post['post_id'];
      $post['link']['source_url'] = $args['link']->source_url;
      $post['link']['source_host'] = $args['link']->source_host;
      $post['link']['source_title'] = $args['link']->source_title;
      $post['link']['source_text'] = $args['link']->source_text;
      $post['link']['source_thumbnail'] = $args['link']->source_thumbnail;
    }
    /* insert the post [media] */
    if ($post['post_type'] == 'media') {
      $db->query(sprintf("INSERT INTO posts_media (post_id, source_url, source_provider, source_type, source_title, source_text, source_html, source_thumbnail) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)", secure($post['post_id'], 'int'), secure($args['link']->source_url), secure($args['link']->source_provider), secure($args['link']->source_type), secure($args['link']->source_title), secure($args['link']->source_text), secure($args['link']->source_html), secure($args['link']->source_thumbnail)));
      $post['media']['media_id'] = $db->insert_id;
      $post['media']['post_id'] = $post['post_id'];
      $post['media']['source_url'] = $args['link']->source_url;
      $post['media']['source_type'] = $args['link']->source_type;
      $post['media']['source_provider'] = $args['link']->source_provider;
      $post['media']['source_title'] = $args['link']->source_title;
      $post['media']['source_text'] = $args['link']->source_text;
      $post['media']['source_html'] = $args['link']->source_html;
    }
    /* insert the post [photos] */
    if ($post['post_type'] == 'photos' || ($post['post_type'] == 'combo' && $args['photos'])) {
      if ($args['handle'] == "page") {
        /* check for page timeline album (public by default) */
        if (!$_page['page_album_timeline']) {
          /* create new page timeline album */
          $db->query(sprintf("INSERT INTO posts_photos_albums (user_id, user_type, title) VALUES (%s, 'page', 'Timeline Photos')", secure($_page['page_id'], 'int')));
          $_page['page_album_timeline'] = $db->insert_id;
          /* update page */
          $db->query(sprintf("UPDATE pages SET page_album_timeline = %s WHERE page_id = %s", secure($_page['page_album_timeline'], 'int'), secure($_page['page_id'], 'int')));
        }
        $album_id = $_page['page_album_timeline'];
      } elseif ($args['handle'] == "group") {
        /* check for group timeline album */
        if (!$_group['group_album_timeline']) {
          /* create new group timeline album */
          $db->query(sprintf("INSERT INTO posts_photos_albums (user_id, user_type, in_group, group_id, title, privacy) VALUES (%s, %s, %s, %s, 'Timeline Photos', 'custom')", secure($post['user_id'], 'int'), secure($post['user_type']), secure($post['in_group']), secure($post['group_id'], 'int')));
          $_group['group_album_timeline'] = $db->insert_id;
          /* update group */
          $db->query(sprintf("UPDATE `groups` SET group_album_timeline = %s WHERE group_id = %s", secure($_group['group_album_timeline'], 'int'), secure($_group['group_id'], 'int')));
        }
        $album_id = $_group['group_album_timeline'];
      } elseif ($args['handle'] == "event") {
        /* check for event timeline album */
        if (!$_event['event_album_timeline']) {
          /* create new event timeline album */
          $db->query(sprintf("INSERT INTO posts_photos_albums (user_id, user_type, in_event, event_id, title, privacy) VALUES (%s, %s, %s, %s, 'Timeline Photos', 'custom')", secure($post['user_id'], 'int'), secure($post['user_type']), secure($post['in_event']), secure($post['event_id'], 'int')));
          $_event['event_album_timeline'] = $db->insert_id;
          /* update event */
          $db->query(sprintf("UPDATE `events` SET event_album_timeline = %s WHERE event_id = %s", secure($_event['event_album_timeline'], 'int'), secure($_event['event_id'], 'int')));
        }
        $album_id = $_event['event_album_timeline'];
      } else {
        /* check for timeline album */
        if (!$this->_data['user_album_timeline']) {
          /* create new timeline album (public by default) */
          $db->query(sprintf("INSERT INTO posts_photos_albums (user_id, user_type, title) VALUES (%s, 'user', 'Timeline Photos')", secure($this->_data['user_id'], 'int')));
          $this->_data['user_album_timeline'] = $db->insert_id;
          /* update user */
          $db->query(sprintf("UPDATE users SET user_album_timeline = %s WHERE user_id = %s", secure($this->_data['user_album_timeline'], 'int'), secure($this->_data['user_id'], 'int')));
        }
        $album_id = $this->_data['user_album_timeline'];
      }
      foreach ($args['photos'] as $photo) {
        $db->query(sprintf("INSERT INTO posts_photos (post_id, album_id, source, blur) VALUES (%s, %s, %s, %s)", secure($post['post_id'], 'int'), secure($album_id, 'int'), secure($photo['source']), secure($photo['blur'])));
        $post_photo['photo_id'] = $db->insert_id;
        $post_photo['post_id'] = $post['post_id'];
        $post_photo['source'] = $photo['source'];
        $post_photo['blur'] = $photo['blur'];
        $post_photo['reaction_like_count'] = 0;
        $post_photo['reaction_love_count'] = 0;
        $post_photo['reaction_haha_count'] = 0;
        $post_photo['reaction_yay_count'] = 0;
        $post_photo['reaction_wow_count'] = 0;
        $post_photo['reaction_sad_count'] = 0;
        $post_photo['reaction_angry_count'] = 0;
        $post_photo['reactions_total_count'] = 0;
        $post_photo['comments'] = 0;
        $post['photos'][] = $post_photo;
      }
      $post['photos_num'] = count($post['photos']);
      /* remove pending uploads */
      remove_pending_uploads(array_column($args['photos'], 'source'));
    }
    /* insert the post [album] */
    if ($post['post_type'] == 'album') {
      /* create new album */
      $db->query(sprintf("INSERT INTO posts_photos_albums (user_id, user_type, in_group, group_id, in_event, event_id, title, privacy) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)", secure($post['user_id'], 'int'), secure($post['user_type']), secure($post['in_group']), secure($post['group_id'], 'int'), secure($post['in_event']), secure($post['event_id'], 'int'), secure($args['album']), secure($post['privacy'])));
      $album_id = $db->insert_id;
      foreach ($args['photos'] as $photo) {
        $db->query(sprintf("INSERT INTO posts_photos (post_id, album_id, source, blur) VALUES (%s, %s, %s, %s)", secure($post['post_id'], 'int'), secure($album_id, 'int'), secure($photo['source']), secure($photo['blur'])));
        $post_photo['photo_id'] = $db->insert_id;
        $post_photo['post_id'] = $post['post_id'];
        $post_photo['source'] = $photo['source'];
        $post_photo['blur'] = $photo['blur'];
        $post_photo['reaction_like_count'] = 0;
        $post_photo['reaction_love_count'] = 0;
        $post_photo['reaction_haha_count'] = 0;
        $post_photo['reaction_yay_count'] = 0;
        $post_photo['reaction_wow_count'] = 0;
        $post_photo['reaction_sad_count'] = 0;
        $post_photo['reaction_angry_count'] = 0;
        $post_photo['reactions_total_count'] = 0;
        $post_photo['comments'] = 0;
        $post['photos'][] = $post_photo;
      }
      $post['album']['album_id'] = $album_id;
      $post['album']['title'] = $args['album'];
      $post['photos_num'] = count($post['photos']);
      /* get album path */
      if ($post['in_group']) {
        $post['album']['path'] = 'groups/' . $_group['group_name'];
      } elseif ($post['in_event']) {
        $post['album']['path'] = 'events/' . $_event['event_id'];
      } elseif ($post['user_type'] == "user") {
        $post['album']['path'] = $this->_data['user_name'];
      } elseif ($post['user_type'] == "page") {
        $post['album']['path'] = 'pages/' . $_page['page_name'];
      }
      /* remove pending uploads */
      remove_pending_uploads(array_column($args['photos'], 'source'));
    }
    /* insert the post [product] */
    if ($post['post_type'] == 'product') {
      /* insert product details */
      /* Note: no need to return any data as publisher will redirect to post link */
      $db->query(sprintf("INSERT INTO posts_products (post_id, name, price, quantity, category_id, status, location, is_digital, product_download_url, product_file_source) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)", secure($post['post_id'], 'int'), secure($args['product']->name), secure($args['product']->price, 'float'), secure($args['product']->quantity, 'int'), secure($args['product']->category, 'int'), secure($args['product']->status), secure($args['product']->location), secure($args['product']->is_digital), secure($args['product']->product_url), secure($args['product']->product_file)));
      /* insert product photos */
      if (count($args['photos']) > 0) {
        foreach ($args['photos'] as $photo) {
          $db->query(sprintf("INSERT INTO posts_photos (post_id, source, blur) VALUES (%s, %s, %s)", secure($post['post_id'], 'int'), secure($photo['source']), secure($photo['blur'])));
        }
        /* remove pending uploads */
        remove_pending_uploads(array_column($args['photos'], 'source'));
      }
    }
    /* insert the post [funding] */
    if ($post['post_type'] == 'funding') {
      /* insert funding details */
      /* Note: no need to return any data as publisher will redirect to post link */
      $db->query(sprintf("INSERT INTO posts_funding (post_id, title, amount, cover_image) VALUES (%s, %s, %s, %s)", secure($post['post_id'], 'int'), secure($args['funding']->title), secure($args['funding']->amount), secure($args['funding']->cover_image)));
      /* remove pending uploads */
      remove_pending_uploads([$args['funding']->cover_image]);
    }
    /* insert the post [offer] */
    if ($post['post_type'] == 'offer') {
      /* prepare end date (optional) */
      $end_date = ($args['offer']->end_date) ? secure($args['offer']->end_date, 'datetime') : 'NULL';
      /* insert offer details */
      /* Note: no need to return any data as publisher will redirect to post link */
      $db->query(sprintf("INSERT INTO posts_offers (post_id, category_id, title, discount_type, discount_percent, discount_amount, buy_x, get_y, spend_x, amount_y, end_date, price) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)", secure($post['post_id'], 'int'), secure($args['offer']->category, 'int'), secure($args['offer']->title), secure($args['offer']->discount_type), secure($args['offer']->discount_percent, 'int'), secure($args['offer']->discount_amount), secure($args['offer']->buy_x), secure($args['offer']->get_y), secure($args['offer']->spend_x), secure($args['offer']->amount_y), $end_date, secure($args['offer']->price, 'float')));
      /* insert offer photos */
      if (count($args['photos']) > 0) {
        foreach ($args['photos'] as $photo) {
          $db->query(sprintf("INSERT INTO posts_photos (post_id, source, blur) VALUES (%s, %s, %s)", secure($post['post_id'], 'int'), secure($photo['source']), secure($photo['blur'])));
        }
        /* remove pending uploads */
        remove_pending_uploads(array_column($args['photos'], 'source'));
      }
    }
    /* insert the post [job] */
    if ($post['post_type'] == 'job') {
      /* insert job details */
      /* Note: no need to return any data as publisher will redirect to post link */
      $db->query(sprintf("INSERT INTO posts_jobs (post_id, category_id, title, location, salary_minimum, salary_minimum_currency, salary_maximum, salary_maximum_currency, pay_salary_per, type, question_1_type, question_1_title, question_1_choices, question_2_type, question_2_title, question_2_choices, question_3_type, question_3_title, question_3_choices, cover_image) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)", secure($post['post_id'], 'int'), secure($args['job']->category, 'int'), secure($args['job']->title), secure($args['job']->location), secure($args['job']->salary_minimum), secure($args['job']->salary_minimum_currency, 'int'), secure($args['job']->salary_maximum), secure($args['job']->salary_maximum_currency, 'int'), secure($args['job']->pay_salary_per), secure($args['job']->type), secure($args['job']->question_1_type), secure($args['job']->question_1_title), secure($args['job']->question_1_choices), secure($args['job']->question_2_type), secure($args['job']->question_2_title), secure($args['job']->question_2_choices), secure($args['job']->question_3_type), secure($args['job']->question_3_title), secure($args['job']->question_3_choices), secure($args['job']->cover_image)));
      /* remove pending uploads */
      remove_pending_uploads([$args['job']->cover_image]);
    }
    /* insert the post [course] */
    if ($post['post_type'] == 'course') {
      /* insert course details */
      /* Note: no need to return any data as publisher will redirect to post link */
      $db->query(sprintf("INSERT INTO posts_courses (post_id, category_id, title, location, fees, fees_currency, start_date, end_date, cover_image) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)", secure($post['post_id'], 'int'), secure($args['course']->category, 'int'), secure($args['course']->title), secure($args['course']->location), secure($args['course']->fees), secure($args['course']->fees_currency, 'int'), secure($args['course']->start_date, 'datetime'), secure($args['course']->end_date, 'datetime'), secure($args['course']->cover_image)));
      /* remove pending uploads */
      remove_pending_uploads([$args['course']->cover_image]);
    }
    /* insert the post [poll] */
    if ($post['post_type'] == 'poll') {
      /* insert poll */
      $db->query(sprintf("INSERT INTO posts_polls (post_id) VALUES (%s)", secure($post['post_id'], 'int')));
      $post['poll']['poll_id'] = $db->insert_id;
      $post['poll']['post_id'] = $post['post_id'];
      $post['poll']['votes'] = '0';
      /* insert poll options */
      foreach ($args['poll_options'] as $option) {
        $db->query(sprintf("INSERT INTO posts_polls_options (poll_id, text) VALUES (%s, %s)", secure($post['poll']['poll_id'], 'int'), secure($option)));
        $poll_option['option_id'] = $db->insert_id;
        $poll_option['text'] = $option;
        $poll_option['votes'] = 0;
        $poll_option['checked'] = false;
        $post['poll']['options'][] = $poll_option;
      }
    }
    /* insert the post [reel] */
    if ($post['post_type'] == 'reel' || $args['reel']) {
      $db->query(sprintf("INSERT INTO posts_reels (post_id, source, thumbnail) VALUES (%s, %s, %s)", secure($post['post_id'], 'int'), secure($args['reel']->source), secure($args['reel_thumbnail'])));
      $post['reel']['reel_id'] = $db->insert_id;
      $post['reel']['source'] = $args['reel']->source;
      $post['reel']['thumbnail'] = $args['reel_thumbnail'];
      /* remove pending uploads */
      remove_pending_uploads([$args['reel']->source, $args['reel_thumbnail']]);
    }
    /* insert the post [video] */
    if ($post['post_type'] == 'video' || ($post['post_type'] == 'combo' && $args['video'])) {
      $db->query(sprintf("INSERT INTO posts_videos (post_id, category_id, source, thumbnail) VALUES (%s, %s, %s, %s)", secure($post['post_id'], 'int'), secure($args['video_category']), secure($args['video']->source), secure($args['video_thumbnail'])));
      $post['video']['video_id'] = $db->insert_id;
      $post['video']['category_id'] = $args['video_category'];
      $post['video']['source'] = $args['video']->source;
      $post['video']['thumbnail'] = $args['video_thumbnail'];
      /* get category name */
      $get_category = $db->query(sprintf("SELECT * FROM posts_videos_categories WHERE category_id = %s", secure($args['video_category'], 'int')));
      $post['video']['category_name'] = $get_category->fetch_assoc()['category_name'];
      /* remove pending uploads */
      remove_pending_uploads([$args['video']->source, $args['video_thumbnail']]);
    }
    /* insert the post [audio] */
    if ($post['post_type'] == 'audio' || ($post['post_type'] == 'combo' && $args['audio'])) {
      $db->query(sprintf("INSERT INTO posts_audios (post_id, source) VALUES (%s, %s)", secure($post['post_id'], 'int'), secure($args['audio']->source)));
      $post['audio']['audio_id'] = $db->insert_id;
      $post['audio']['source'] = $args['audio']->source;
      /* remove pending uploads */
      remove_pending_uploads([$args['audio']->source]);
    }
    /* insert the post [file] */
    if ($post['post_type'] == 'file' || ($post['post_type'] == 'combo' && $args['file'])) {
      $db->query(sprintf("INSERT INTO posts_files (post_id, source) VALUES (%s, %s)", secure($post['post_id'], 'int'), secure($args['file']->source)));
      $post['file']['file_id'] = $db->insert_id;
      $post['file']['source'] = $args['file']->source;
      /* remove pending uploads */
      remove_pending_uploads([$args['file']->source]);
    }

    /* insert custom fields values */
    if ($args['custom_fields']) {
      foreach ($args['custom_fields'] as $field_id => $value) {
        $db->query(sprintf("INSERT INTO custom_fields_values (value, field_id, node_id, node_type) VALUES (%s, %s, %s, %s)", secure($value), secure($field_id, 'int'), secure($post['post_id'], 'int'), secure($post['post_type'])));
      }
    }

    /* post mention notifications */
    $this->post_mentions($args['message'], $post['post_id']);

    /* post wall notifications */
    if ($post['in_wall']) {
      $this->post_notification(['to_user_id' => $post['wall_id'], 'action' => 'wall', 'node_type' => 'post', 'node_url' => $post['post_id']]);
    }

    /* post in_group notification */
    if ($post['in_group'] && !$post['group_approved']) {
      /* send notification to group admin */
      $this->post_notification(['to_user_id' => $_group['group_admin'], 'action' => 'group_post_pending', 'node_type' => $_group['group_title'], 'node_url' => $_group['group_name'] . "-[guid=]" . $post['post_id']]);
    }

    /* post in_event notification */
    if ($post['in_event'] && !$post['event_approved']) {
      /* send notification to event admin */
      $this->post_notification(['to_user_id' => $_event['event_admin'], 'action' => 'event_post_pending', 'node_type' => $_event['event_title'], 'node_url' => $_event['event_id'] . "-[guid=]" . $post['post_id']]);
    }

    /* parse text */
    $post['text_plain'] = htmlentities($post['text'], ENT_QUOTES, 'utf-8');
    $post['text'] = $this->parse(["text" => $post['text_plain'], "trending_hashtags" => true, "post_id" => $post['post_id']]);

    /* get post colored pattern */
    $post['colored_pattern'] = $this->get_posts_colored_pattern($post['colored_pattern']);

    /* user can manage the post */
    $post['manage_post'] = true;

    /* points balance */
    $this->points_balance("add", $this->_data['user_id'], "post", $post['post_id']);

    /* check if post is pending */
    if ($post['has_approved'] == 0) {
      /* send notification to admins */
      $this->notify_system_admins("pending_post");
    }

    /* return */
    return $post;
  }


  /**
   * scraper
   * 
   * @param string $url
   * @return array
   */
  public function scraper($url)
  {
    global $system;
    $url_parsed = parse_url($url);
    if (!isset($url_parsed["scheme"])) {
      $url = "http://" . $url;
    }
    /* check if the url is banned */
    $host = get_base_domain($url);
    if ($system['censored_domains_enabled']) {
      $banned_domains = explode(',', trim($system['censored_domains']));
      if ($banned_domains && in_array($host, $banned_domains)) {
        return false;
      }
    }
    /* get the embed */
    $client = new Embed\Http\CurlClient();
    $client->setSettings([
      'ignored_errors' => [18, 23],
      'ssl_verify_host' => 1,
      'ssl_verify_peer' => 1,
      'follow_location' => true,
      'user_agent' => 'Delus',
    ]);
    $embed = new Embed\Embed(new Embed\Http\Crawler($client));
    $info = $embed->get($url);
    if ($info) {
      $return = [];
      $return['source_url'] = $url;
      $return['source_host'] = $url_parsed['host'];
      $return['source_title'] = $info->title;
      $return['source_text'] = $info->description;
      $return['source_thumbnail'] = $info->image;
      $return['source_html'] = $info->code->html;
      $return['source_provider'] = $info->providerName;
      $return['source_type'] = ($info->code->html && preg_match('/<iframe|blockquote>/', $info->code->html)) ? 'rich' : 'link';
      if ($return['source_type'] === 'rich' && preg_match('/(wp-embedded-content|m3u8|\.mov)/', $info->code->html)) {
        $return['source_type'] = 'link';
      }
      if ($info->providerName == "Twitch") {
        $return['source_html'] = str_replace("meta.tag", $_SERVER['HTTP_HOST'], $info->code->html);
      }
      return $return;
    } else {
      return false;
    }
  }


  /**
   * get_posts_colored_patterns
   * 
   * @return array
   */
  public function get_posts_colored_patterns()
  {
    global $db;
    $patterns = [];
    $get_patterns = $db->query("SELECT * FROM posts_colored_patterns");
    if ($get_patterns->num_rows > 0) {
      while ($pattern = $get_patterns->fetch_assoc()) {
        $patterns[] = $pattern;
      }
    }
    return $patterns;
  }


  /**
   * get_posts_colored_pattern
   * 
   * @param integer $pattern_id
   * @return array
   */
  public function get_posts_colored_pattern($pattern_id)
  {
    global $db;
    $get_pattern = $db->query(sprintf("SELECT * FROM posts_colored_patterns WHERE pattern_id = %s", secure($pattern_id, 'int')));
    if ($get_pattern->num_rows == 0) {
      return 0;
    }
    return $get_pattern->fetch_assoc();
  }


  /**
   * check_posts_needs_approval
   * 
   * @param integer $user_id
   * @param string $user_type
   * @return boolean
   */
  public function check_posts_needs_approval($user_id, $user_type = "user")
  {
    global $system, $db;
    /* check if approval is enabled (bypass for admins & moderators) */
    if ($system['posts_approval_enabled'] && $this->_data['user_group'] >= 3) {
      $get_approved_posts = $db->query(sprintf("SELECT COUNT(*) as count FROM posts WHERE user_id = %s AND user_type = %s AND has_approved = '1'", secure($user_id, 'int'), secure($user_type)));
      if ($get_approved_posts->fetch_assoc()['count'] < $system['posts_approval_limit']) {
        return true;
      }
    }
    return false;
  }


  /**
   * parse
   * 
   * @param array $args
   * @return string
   */
  public function parse($args = [])
  {
    /* validate arguments */
    $text = $args['text'];
    $decode_urls = !isset($args['decode_urls']) ? true : $args['decode_urls'];
    $decode_emojis = !isset($args['decode_emojis']) ? true : $args['decode_emojis'];
    $decode_stickers = !isset($args['decode_stickers']) ? true : $args['decode_stickers'];
    $decode_mentions = !isset($args['decode_mentions']) ? true : $args['decode_mentions'];
    $decode_hashtags = !isset($args['decode_hashtags']) ? true : $args['decode_hashtags'];
    $trending_hashtags = !isset($args['trending_hashtags']) ? false : $args['trending_hashtags'];
    $post_id = !isset($args['post_id']) ? null : $args['post_id'];
    $nl2br = !isset($args['nl2br']) ? true : $args['nl2br'];
    /* decode urls */
    if ($decode_urls) {
      $text = decode_urls($text);
    }
    /* decode emojis */
    if ($decode_emojis) {
      $text = $this->decode_emojis($text);
    }
    /* decode stickers */
    if ($decode_stickers) {
      $text = $this->decode_stickers($text);
    }
    /* decode @mention */
    if ($decode_mentions) {
      $text = $this->decode_mention($text);
    }
    /* decode #hashtag */
    if ($decode_hashtags) {
      $text = $this->decode_hashtags($text, $trending_hashtags, $post_id);
    }
    /* censored words */
    $text = censored_words($text);
    /* nl2br */
    if ($nl2br && $text) {
      $text = nl2br($text);
    }
    return $text;
  }


  /**
   * check_posts_limit
   * 
   * @param string $handle
   * @param integer $handle_id
   * @return void
   */
  public function check_posts_limit($handle = 'user', $handle_id = null)
  {
    global $system, $db;
    /* check max posts/hour limit */
    if ($system['max_posts_hour'] > 0 && $this->_data['user_group'] >= 3) {
      $handle = ($handle == "page") ? "page" : "user";
      $where_query = ($handle == "page") ? sprintf("user_id = %s AND user_type = 'page'", secure($handle_id, 'int')) : sprintf("user_id = %s AND user_type = 'user'", secure($this->_data['user_id'], 'int'));
      $check_limit = $db->query("SELECT COUNT(*) as count FROM posts WHERE posts.time >= DATE_SUB(NOW(),INTERVAL 1 HOUR) AND " . $where_query);
      if ($check_limit->fetch_assoc()['count'] >= $system['max_posts_hour']) {
        throw new Exception(__("You have reached the maximum limit of posts/hour, please try again later"));
      }
    }
  }
}
