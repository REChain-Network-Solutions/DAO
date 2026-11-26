<?php

/**
 * trait -> publisher
 * 
 * @package Sngine
 * @author Zamblek
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

    /* photo layout */
    $photo_layout = $args['photo_layout'] ?? 'classic';
    if (!is_string($photo_layout) || !isset(get_photo_layout_presets()[$photo_layout])) {
      throw new ValidationException(__("Please select a valid photo layout"));
    }

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

    /* prepare post */
    $post = [];
    $post['photo_layout'] = $photo_layout;
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

    /* check the handle */
    if ($args['handle'] == "user") {
      /* check if system allow wall posts */
      if (!$system['wall_posts_enabled']) {
        throw new Exception(__("Wall posts are disabled"));
      }
      /* check if the user is valid & the viewer can post on his wall */
      $check_user = $db->query(sprintf("SELECT * FROM users WHERE user_id = %s", secure($args['id'], 'int')));
      if ($check_user->num_rows == 0) {
        throw new Exception(__("User not found"));
      }
      $_user = $check_user->fetch_assoc();
      if ($_user['user_privacy_wall'] == 'me' || ($_user['user_privacy_wall'] == 'friends' && !$this->friendship_approved($args['id']))) {
        throw new Exception(__("You cannot post on this user's wall"));
      }
      $post['in_wall'] = 1;
      $post['wall_id'] = $args['id'];
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
    $args['message'] = strip_tags($args['message'], '<p><br><b><strong><i><em><u><s><del><blockquote><ul><ol><li><h1><h2><span>');
    $post['text'] = $args['message'];
    $post['location'] = $args['location'];
    $post['has_coordinates'] = !is_empty($args['location']) && valid_location($args['latitude'] ?? null, $args['longitude'] ?? null);
    $post['privacy'] = $args['privacy'];
    $post['is_schedule'] = (isset($args['is_schedule'])) ? $args['is_schedule'] : '0';
    $post['time'] = ($post['is_schedule']) ? $args['schedule_date'] : $date;
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
    $post['is_collaborative'] = (isset($args['is_collaborative'])) ? $args['is_collaborative'] : '0';
    $post['collaborative_users_ids'] = $args['collaborative_users_ids'];
    $post['collaborative_percent'] = $args['collaborative_percent'];
    $post['processing'] = '0';

    /* post feeling */
    $post['feeling_action'] = '';
    $post['feeling_value'] = '';
    if (!is_empty($args['feeling_action']) && !is_empty($args['feeling_value'])) {
      if ($args['feeling_action'] != "Feeling") {
        $_feeling_icon = get_feeling_icon($args['feeling_action'], get_feelings());
      } else {
        $_feeling_icon = get_feeling_icon($args['feeling_value'], get_feelings_types());
      }
      if ($_feeling_icon) {
        $post['feeling_action'] = $args['feeling_action'];
        $post['feeling_value'] = $args['feeling_value'];
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
    $db->query(sprintf(
      "INSERT INTO posts (
          user_id, 
          user_type, 
          in_wall, 
          wall_id, 
          is_collaborative, 
          collaborative_percent, 
          in_group, 
          group_id, 
          group_approved, 
          in_event, 
          event_id, 
          event_approved, 
          post_type, 
          colored_pattern, 
          time, 
          location, 
          location_latitude, 
          location_longitude, 
          privacy, 
          text, 
          feeling_action, 
          feeling_value, 
          for_adult, 
          is_schedule, 
          is_anonymous, 
          tips_enabled, 
          for_subscriptions, 
          subscriptions_image, 
          is_paid, 
          is_paid_locked, 
          post_price, 
          paid_text, 
          paid_image, 
          processing, 
          pre_approved, 
          has_approved, 
          post_latitude, 
          post_longitude,
          photo_layout
        ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)",
      secure($post['user_id'], 'int'),
      secure($post['user_type']),
      secure($post['in_wall'], 'int'),
      secure($post['wall_id'], 'int'),
      secure($post['is_collaborative']),
      secure($post['collaborative_percent'], 'float'),
      secure($post['in_group']),
      secure($post['group_id'], 'int'),
      secure($post['group_approved']),
      secure($post['in_event']),
      secure($post['event_id'], 'int'),
      secure($post['event_approved']),
      secure($post['post_type']),
      secure($post['colored_pattern'], 'int'),
      secure($post['time']),
      secure($post['location']),
      secure($post['has_coordinates'] ? round((float) $args['latitude'], 7) : 'null'),
      secure($post['has_coordinates'] ? round((float) $args['longitude'], 7) : 'null'),
      secure($post['privacy']),
      secure($post['text']),
      secure($post['feeling_action']),
      secure($post['feeling_value']),
      secure($post['for_adult']),
      secure($post['is_schedule']),
      secure($post['is_anonymous']),
      secure($post['tips_enabled']),
      secure($post['for_subscriptions']),
      secure($post['subscriptions_image']),
      secure($post['is_paid']),
      secure($post['is_paid_locked']),
      secure($post['post_price'], 'float'),
      secure($post['paid_text']),
      secure($post['paid_image']),
      secure($post['processing']),
      secure($post['pre_approved']),
      secure($post['has_approved']),
      secure($this->_data['user_latitude']),
      secure($this->_data['user_longitude']),
      secure($post['photo_layout'])
    ));
    $post['post_id'] = $db->insert_id;
    $this->index_post_location($post['post_id'], $post['post_type']);

    /* remove pending uploads */
    remove_pending_uploads([$post['subscriptions_image'], $post['paid_image']]);

    /* insert the post [link] */
    if ($post['post_type'] == 'link') {
      $db->query(sprintf("INSERT INTO posts_links (post_id, source_url, source_host, source_title, source_text, source_thumbnail) VALUES (%s, %s, %s, %s, %s, %s)", secure($post['post_id'], 'int'), secure($args['link']->source_url), secure($args['link']->source_host), secure($args['link']->source_title), secure($args['link']->source_text), secure($args['link']->source_thumbnail)));
    }
    /* insert the post [media] */
    if ($post['post_type'] == 'media') {
      $db->query(sprintf("INSERT INTO posts_media (post_id, source_url, source_provider, source_type, source_title, source_text, source_html, source_thumbnail) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)", secure($post['post_id'], 'int'), secure($args['link']->source_url), secure($args['link']->source_provider), secure($args['link']->source_type), secure($args['link']->source_title), secure($args['link']->source_text), secure($args['link']->source_html), secure($args['link']->source_thumbnail)));
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
      foreach ($args['photos'] as $sort_order => $photo) {
        $db->query(sprintf("INSERT INTO posts_photos (post_id, album_id, source, blur, sort_order) VALUES (%s, %s, %s, %s, %s)", secure($post['post_id'], 'int'), secure($album_id, 'int'), secure($photo['source']), secure($photo['blur']), secure($sort_order, 'int')));
      }
      /* remove pending uploads */
      remove_pending_uploads(array_column($args['photos'], 'source'));
    }
    /* insert the post [album] */
    if ($post['post_type'] == 'album') {
      /* create new album */
      $db->query(sprintf("INSERT INTO posts_photos_albums (user_id, user_type, in_group, group_id, in_event, event_id, title, privacy) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)", secure($post['user_id'], 'int'), secure($post['user_type']), secure($post['in_group']), secure($post['group_id'], 'int'), secure($post['in_event']), secure($post['event_id'], 'int'), secure($args['album']), secure($post['privacy'])));
      $album_id = $db->insert_id;
      foreach ($args['photos'] as $sort_order => $photo) {
        $db->query(sprintf("INSERT INTO posts_photos (post_id, album_id, source, blur, sort_order) VALUES (%s, %s, %s, %s, %s)", secure($post['post_id'], 'int'), secure($album_id, 'int'), secure($photo['source']), secure($photo['blur']), secure($sort_order, 'int')));
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
      $db->query(sprintf("INSERT INTO posts_funding (post_id, category_id, title, amount, cover_image) VALUES (%s, %s, %s, %s, %s)", secure($post['post_id'], 'int'), secure($args['funding']->category, 'int'), secure($args['funding']->title), secure($args['funding']->amount), secure($args['funding']->cover_image)));
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
      $poll_id = $db->insert_id;
      /* insert poll options */
      foreach ($args['poll_options'] as $option) {
        $db->query(sprintf("INSERT INTO posts_polls_options (poll_id, text) VALUES (%s, %s)", secure($poll_id, 'int'), secure($option)));
      }
    }
    /* insert the post [reel] */
    if ($post['post_type'] == 'reel' || $args['reel']) {
      $db->query(sprintf("INSERT INTO posts_reels (post_id, source, thumbnail) VALUES (%s, %s, %s)", secure($post['post_id'], 'int'), secure($args['reel']->source), secure($args['reel_thumbnail'])));
      $post['reel']['source'] = $args['reel']->source;
      $post['reel']['thumbnail'] = $args['reel_thumbnail'];
      /* remove pending uploads */
      remove_pending_uploads([$args['reel']->source, $args['reel_thumbnail']]);
    }
    /* insert the post [video] */
    if ($post['post_type'] == 'video' || ($post['post_type'] == 'combo' && $args['video'])) {
      $video_width = (isset($args['video']->width) && is_numeric($args['video']->width) && $args['video']->width > 0) ? min((int) $args['video']->width, 65535) : 'null';
      $video_height = (isset($args['video']->height) && is_numeric($args['video']->height) && $args['video']->height > 0) ? min((int) $args['video']->height, 65535) : 'null';
      $db->query(sprintf("INSERT INTO posts_videos (post_id, category_id, source, thumbnail, width, height) VALUES (%s, %s, %s, %s, %s, %s)", secure($post['post_id'], 'int'), secure($args['video_category']), secure($args['video']->source), secure($args['video_thumbnail']), secure($video_width, 'int'), secure($video_height, 'int')));
      $post['video']['source'] = $args['video']->source;
      $post['video']['thumbnail'] = $args['video_thumbnail'];
      /* remove pending uploads */
      remove_pending_uploads([$args['video']->source, $args['video_thumbnail']]);
    }
    /* insert the post [audio] */
    if ($post['post_type'] == 'audio' || ($post['post_type'] == 'combo' && $args['audio'])) {
      $db->query(sprintf("INSERT INTO posts_audios (post_id, source) VALUES (%s, %s)", secure($post['post_id'], 'int'), secure($args['audio']->source)));
      /* remove pending uploads */
      remove_pending_uploads([$args['audio']->source]);
    }
    /* insert the post [file] */
    if ($post['post_type'] == 'file' || ($post['post_type'] == 'combo' && $args['file'])) {
      $db->query(sprintf(
        "INSERT INTO posts_files (post_id, source, name, size) VALUES (%s, %s, %s, %s)",
        secure($post['post_id'], 'int'),
        secure($args['file']->source),
        secure($this->sanitize_upload_file_name($args['file']->name ?? '')),
        secure(max(0, (int) ($args['file']->size ?? 0)), 'int')
      ));
      /* remove pending uploads */
      remove_pending_uploads([$args['file']->source]);
    }

    /* index the post for search */
    $this->refresh_post_search($post['post_id']);

    /* insert custom fields values */
    if ($args['custom_fields']) {
      foreach ($args['custom_fields'] as $field_id => $value) {
        $db->query(sprintf("INSERT INTO custom_fields_values (value, field_id, node_id, node_type) VALUES (%s, %s, %s, %s)", secure($value), secure($field_id, 'int'), secure($post['post_id'], 'int'), secure($post['post_type'])));
      }
    }

    /* post mention notifications */
    $this->post_mentions($args['message'], $post['post_id']);

    /* insert collaborative users */
    if ($post['is_collaborative']) {
      $this->insert_collaborative_users($post['post_id'], $post['collaborative_users_ids']);
    }

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

    /* record trending hashtags */
    $this->prepare_post_text($post, true);

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
   * validate_collaborative_users
   * 
   * @param string $collaborative_users
   * @return array
   */
  public function validate_collaborative_users($collaborative_users)
  {
    global $db, $system;
    $collaborative_users_ids = [];
    /* check if system allow collaborative posts */
    if (!$system['collaborative_posts_enabled']) {
      throw new Exception(__("Collaborative posts are disabled"));
    }
    /* check if user can add collaborative posts */
    if (!$this->_data['can_add_collaborative_posts']) {
      throw new Exception(__("You don't have the permission to add collaborative posts"));
    }
    /* check if collaborative users is empty */
    if (empty($collaborative_users)) {
      throw new ValidationException(__("Please select at least one user to collaborate with"));
    }
    /* remove values without id and if it's numeric */
    $collaborative_users_array = json_encode(array_filter(json_decode($collaborative_users, true), function ($value) {
      return isset($value['id']) && is_numeric($value['id']);
    }));
    /* make a list from target users */
    $collaborative_users_array = json_decode(html_entity_decode($collaborative_users), true);
    if (count($collaborative_users_array) == 0) {
      throw new ValidationException(__("Please select at least one user to collaborate with"));
    }
    foreach ($collaborative_users_array as $_user) {
      /* check if the user is valid & the viewer can post on his wall */
      $check_user = $db->query(sprintf("SELECT user_id, user_privacy_collaborative FROM users WHERE user_id = %s", secure($_user['id'], 'int')));
      if ($check_user->num_rows == 0) {
        continue;
      }
      $_user = $check_user->fetch_assoc();
      if ($_user['user_privacy_collaborative'] == 'me' || ($_user['user_privacy_collaborative'] == 'friends' && !$this->friendship_approved($_user['user_id']))) {
        continue;
      }
      $collaborative_users_ids[] = $_user['user_id'];
    }
    return $collaborative_users_ids;
  }


  /**
   * insert_collaborative_users
   * 
   * @param integer $post_id
   * @param array $collaborative_users_ids
   * @return void
   */
  public function insert_collaborative_users($post_id, $collaborative_users_ids)
  {
    global $db;
    foreach ($collaborative_users_ids as $collaborative_user_id) {
      /* insert collaborative user */
      $db->query(sprintf("INSERT INTO posts_collaborative_users (post_id, user_id) VALUES (%s, %s)", secure($post_id, 'int'), secure($collaborative_user_id, 'int')));
      /* send notification to collaborative user */
      $this->post_notification(['to_user_id' => $collaborative_user_id, 'action' => 'collaborative_post', 'node_type' => 'post', 'node_url' => $post_id]);
    }
  }


  /**
   * get_collaborative_users
   * 
   * @param integer $post_id
   * @return array
   */
  public function get_collaborative_users($post_id)
  {
    global $db, $system;
    $collaborative_users = [];
    $get_collaborative_users = $db->query(sprintf("SELECT users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_picture, user_gender FROM posts_collaborative_users INNER JOIN users ON posts_collaborative_users.user_id = users.user_id WHERE posts_collaborative_users.post_id = %s", secure($post_id, 'int')));
    while ($collaborative_user = $get_collaborative_users->fetch_assoc()) {
      $collaborative_user['user_picture'] = get_picture($collaborative_user['user_picture'], $collaborative_user['user_gender']);
      $collaborative_user['user_fullname'] = ($system['show_usernames_enabled']) ? $collaborative_user['user_name'] : $collaborative_user['user_firstname'] . " " . $collaborative_user['user_lastname'];
      $collaborative_users[] = $collaborative_user;
    }
    return $collaborative_users;
  }


  /**
   * is_collaborative_user
   * 
   * @param integer $user_id
   * @param integer $post_id
   * @return boolean
   */
  public function is_collaborative_user($user_id, $post_id)
  {
    global $db;
    $check_collaborative_user = $db->query(sprintf("SELECT COUNT(*) as count FROM posts_collaborative_users WHERE user_id = %s AND post_id = %s", secure($user_id, 'int'), secure($post_id, 'int')));
    if ($check_collaborative_user->fetch_assoc()['count'] > 0) {
      return true;
    }
    return false;
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
    $url_parsed = parse_url($url);
    if (!filter_var($url, FILTER_VALIDATE_URL) || !in_array(strtolower($url_parsed['scheme'] ?? ''), ['http', 'https'])) {
      return false;
    }
    /* check if the url is banned */
    $host = get_base_domain($url);
    if ($this->check_censored_domains($host)) {
      return false;
    }
    /* facebook embeds */
    if (in_array(strtolower($url_parsed['host']), ['facebook.com', 'www.facebook.com', 'm.facebook.com', 'web.facebook.com'])) {
      $path = $url_parsed['path'] ?? '/';
      parse_str($url_parsed['query'] ?? '', $query);
      $facebook_plugin = null;
      if (
        preg_match('~^/[^/]+/posts/(?:pfbid[a-zA-Z0-9]+|[0-9]+|[^/]+/[0-9]+)/?$~D', $path)
        || (in_array($path, ['/permalink.php', '/story.php']) && !empty($query['story_fbid']) && is_string($query['story_fbid']))
      ) {
        $facebook_plugin = 'post';
      } elseif (
        preg_match('~^/(?:[^/]+/videos/[0-9]+|reel/[0-9]+)/?$~D', $path)
        || (in_array($path, ['/watch', '/watch/', '/video.php']) && !empty($query['v']) && is_string($query['v']) && ctype_digit($query['v']))
      ) {
        $facebook_plugin = 'video';
      }
      if ($facebook_plugin) {
        $facebook_url = 'https://www.facebook.com' . $path;
        if (!empty($url_parsed['query'])) {
          $facebook_url .= '?' . $url_parsed['query'];
        }
        $iframe_url = 'https://www.facebook.com/plugins/' . $facebook_plugin . '.php?' . http_build_query(['href' => $facebook_url, 'show_text' => 'true', 'width' => 500], '', '&', PHP_QUERY_RFC3986);
        return [
          'source_url' => $url,
          'source_host' => $url_parsed['host'],
          'source_title' => 'Facebook',
          'source_text' => '',
          'source_thumbnail' => '',
          'source_html' => '<iframe src="' . htmlspecialchars($iframe_url, ENT_QUOTES, 'UTF-8') . '" width="500" height="680" frameborder="0" allowfullscreen="true" title="Facebook"></iframe>',
          'source_provider' => 'Facebook',
          'source_type' => 'rich',
        ];
      }
    }
    /* get the embed */
    $client = new Embed\Http\CurlClient();
    $client->setSettings([
      'ignored_errors' => [18, 23],
      'ssl_verify_host' => 2,
      'ssl_verify_peer' => 1,
      'follow_location' => true,
      'user_agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36',
    ]);
    $crawler = new Embed\Http\Crawler($client);
    $crawler->addDefaultHeaders([
      'Accept-Language' => 'en-US,en;q=0.9',
      'Cookie' => 'CONSENT=YES+',
    ]);
    $embed = new Embed\Embed($crawler);
    $info = $embed->get($url);
    if ($info && $info->getResponse()->getStatusCode() < 400) {
      $html = $info->code->html ?? '';
      $return = [];
      $return['source_url'] = $url;
      $return['source_host'] = $url_parsed['host'];
      $return['source_title'] = $info->title;
      $return['source_text'] = $info->description;
      $return['source_thumbnail'] = $info->image ? (string) $info->image : '';
      $return['source_html'] = $html;
      $return['source_provider'] = $info->providerName;
      $return['source_type'] = ($html && preg_match('/<(?:iframe|blockquote)\b/i', $html)) ? 'rich' : 'link';
      if ($return['source_type'] === 'rich' && preg_match('/(wp-embedded-content|m3u8|\.mov)/', $html)) {
        $return['source_type'] = 'link';
      }
      if ($info->providerName == "Twitch") {
        $return['source_html'] = str_replace("meta.tag", $_SERVER['HTTP_HOST'], $html);
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
   * is_post_edit_window_open
   *
   * @param array $post
   * @return boolean
   */
  public function is_post_edit_window_open($post)
  {
    global $system;
    /* bypass for admins & moderators */
    if ($this->_data['user_group'] < 3) {
      return true;
    }
    if (empty($system['posts_edit_limit_enabled'])) {
      return true;
    }
    $limit = (int) ($system['posts_edit_limit'] ?? 0);
    if ($limit <= 0) {
      return true;
    }
    $post_time = strtotime($post['time'] ?? '');
    if ($post_time === false) {
      return true;
    }
    /* scheduled posts stay editable until they go live */
    if ($post_time > time()) {
      return true;
    }
    return (time() - $post_time) <= ($limit * 3600);
  }


  /**
   * check_post_edit_window
   *
   * @param array $post
   * @return void
   */
  public function check_post_edit_window($post)
  {
    if (!$this->is_post_edit_window_open($post)) {
      throw new ValidationException(__("The edit window for this post has closed"));
    }
  }


  /**
   * queue_post_reapproval
   *
   * @param array $post
   * @return boolean
   */
  public function queue_post_reapproval($post)
  {
    global $system, $db;
    $pending = ($post['pre_approved'] == '0' && $post['has_approved'] == '0');
    /* bypass for admins & moderators */
    if ($this->_data['user_group'] < 3 || empty($system['posts_approval_enabled'])) {
      return $pending;
    }
    if ($pending) {
      return true;
    }
    $db->query(sprintf("UPDATE posts SET pre_approved = '0', has_approved = '0' WHERE post_id = %s", secure($post['post_id'], 'int')));
    $this->notify_system_admins("pending_post");
    return true;
  }


  /**
   * prepare_post_text
   *
   * @param array $post
   * @param boolean $trending_hashtags
   * @return void
   */
  private function prepare_post_text(&$post, $trending_hashtags = false)
  {
    $post['text_raw'] = $post['text'];
    $post['text_html'] = ($post['text_raw']) ? htmlspecialchars_decode($post['text_raw'], ENT_QUOTES) : $post['text_raw'];
    $post['text_html'] = ($post['text_html']) ? preg_replace(['/<p>\s*<br\s*\/?>\s*<\/p>/i', '/<\/p>\s*<p>/', '/^<p>/', '/<\/p>$/'], ['<p></p>', "\n", '', ''], $post['text_html']) : $post['text_html'];
    $post['text_html'] = ($post['text_html']) ? preg_replace('/(\s|<br\s*\/?>)+$/i', '', $post['text_html']) : $post['text_html'];
    $post['text_html'] = $this->sanitize_post_html($post['text_html']);
    $post['text_html'] = $this->convert_post_lists($post['text_html']);
    $post['text_plain'] = $this->decode_mentions($post['text_html'], true, true);
    $post['text_plain'] = ($post['text_plain']) ? strip_tags($post['text_plain']) : $post['text_plain'];
    $parse_args = ["text" => $post['text_html']];
    if ($trending_hashtags) {
      $parse_args['trending_hashtags'] = true;
      $parse_args['post_id'] = $post['post_id'];
    }
    $post['text'] = $this->parse($parse_args);
  }


  /**
   * sanitize_post_html
   *
   * @param string $html
   * @return string
   */
  private function sanitize_post_html($html)
  {
    if (!$html) return $html;
    return preg_replace_callback('/<(\/?)([a-z][a-z0-9]*)\b([^<>]*)>|</i', function ($matches) {
      /* escape stray brackets */
      if (!isset($matches[2])) {
        return '&lt;';
      }
      /* remove not allowed tags */
      $tag = strtolower($matches[2]);
      if (!in_array($tag, ['p', 'br', 'b', 'strong', 'i', 'em', 'u', 's', 'del', 'blockquote', 'ul', 'ol', 'li', 'h1', 'h2', 'span'])) {
        return '';
      }
      if ($matches[1]) {
        return '</' . $tag . '>';
      }
      /* keep safe attributes only */
      preg_match_all('/(?<=[\s"\'\/])(?:class|data-[a-z0-9-]+)="[^"]*"/i', $matches[3], $attributes);
      return '<' . $tag . ($attributes[0] ? ' ' . implode(' ', $attributes[0]) : '') . '>';
    }, $html);
  }


  /**
   * convert_post_lists
   *
   * @param string $html
   * @return string
   */
  private function convert_post_lists($html)
  {
    if (!$html || stripos($html, 'data-list=') === false) return $html;
    return preg_replace_callback('/<ol>(.*?)<\/ol>/is', function ($matches) {
      preg_match_all('/<li\b([^>]*)>(.*?)<\/li>/is', $matches[1], $items, PREG_SET_ORDER);
      $list = '';
      $levels = [];
      foreach ($items as $item) {
        $tag = (preg_match('/data-list="ordered"/i', $item[1])) ? 'ol' : 'ul';
        $level = (preg_match('/ql-indent-(\d+)/i', $item[1], $indent)) ? (int) $indent[1] : 0;
        $text = preg_replace('/<span class="ql-ui"[^>]*><\/span>/i', '', $item[2]);
        /* close deeper levels */
        while (count($levels) > $level + 1) {
          $list .= '</li></' . array_pop($levels) . '>';
        }
        /* close other list type */
        if (count($levels) == $level + 1 && end($levels) != $tag) {
          $list .= '</li></' . array_pop($levels) . '>';
        }
        /* same level */
        if (count($levels) == $level + 1) {
          $list .= '</li><li>' . $text;
          continue;
        }
        /* open new levels */
        while (count($levels) < $level) {
          $list .= '<' . $tag . '><li class="list-none">';
          $levels[] = $tag;
        }
        $list .= '<' . $tag . '><li>' . $text;
        $levels[] = $tag;
      }
      while ($levels) {
        $list .= '</li></' . array_pop($levels) . '>';
      }
      return $list;
    }, $html);
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
    $decode_stickers = !isset($args['decode_stickers']) ? true : $args['decode_stickers'];
    $decode_mentions = !isset($args['decode_mentions']) ? true : $args['decode_mentions'];
    $decode_mentions_html = !isset($args['decode_mentions_html']) ? true : $args['decode_mentions_html'];
    $decode_hashtags = !isset($args['decode_hashtags']) ? true : $args['decode_hashtags'];
    $trending_hashtags = !isset($args['trending_hashtags']) ? false : $args['trending_hashtags'];
    $post_id = !isset($args['post_id']) ? null : $args['post_id'];
    $nl2br = !isset($args['nl2br']) ? true : $args['nl2br'];
    /* decode urls */
    if ($decode_urls) {
      $text = decode_urls($text);
    }
    /* decode stickers */
    if ($decode_stickers) {
      $text = $this->decode_stickers($text);
    }
    /* decode @mention */
    if ($decode_mentions) {
      $text = $this->decode_mentions($text);
    }
    /* decode @mention html */
    if ($decode_mentions_html) {
      $text = $this->decode_mentions($text, true);
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


  /**
   * check_censored_domains
   * 
   * @param string $url
   * @return boolean
   */
  public function check_censored_domains($url)
  {
    global $system;
    /* check if censored domains is enabled */
    if (!$system['censored_domains_enabled']) {
      return false;
    }
    /* check if $system['censored_domains'] is empty */
    if (empty($system['censored_domains'])) {
      return false;
    }
    /* make a list from target usernames */
    $censored_domains = array_column(json_decode(html_entity_decode($system['censored_domains']), true), "value");
    if (count($censored_domains) == 0) {
      return false;
    }
    if (in_array(strtolower($url), $censored_domains)) {
      return true;
    }
    return false;
  }
}
