<?php

/**
 * trait -> rich text posts 
 * 
 * @package Sngine
 * @author Zamblek
 */

trait RichTextTrait
{

  /* ------------------------------- */
  /* Rich Text Posts */
  /* ------------------------------- */

  /**
   * publish_rich_text_post
   * 
   * @param string $text
   * @param string $share_to
   * @param integer $share_to_id
   * @return integer
   */
  public function publish_rich_text_post($text, $share_to, $share_to_id)
  {
    global $db, $system, $date;
    /* prepare */
    $share_to = is_empty($share_to) ? 'timeline' : $share_to;
    $share_to_id = is_empty($share_to_id) ? null : $share_to_id;
    if (!in_array($share_to, ['timeline', 'page', 'group', 'event'])) {
      throw new ValidationException(__("Invalid share to"));
    }
    if ($share_to != 'timeline' && !is_numeric($share_to_id)) {
      throw new ValidationException(__("Invalid share to id"));
    }
    /* check if rich text posts enabled */
    if (!$system['rich_text_posts_enabled']) {
      throw new ValidationException(__("The rich text posts module has been disabled by the admin"));
    }
    /* check rich text posts permission */
    if (!$this->_data['can_add_rich_text_posts']) {
      throw new ValidationException(__("You don't have the permission to do this"));
    }
    /* check if verification for posts required */
    if ($system['verification_for_posts'] && !$this->_data['user_verified']) {
      throw new ValidationException(__("To use this feature your account must be verified"));
    }
    /* check max posts/hour limit */
    $this->check_posts_limit(($share_to == 'page') ? 'page' : 'user', ($share_to == 'page') ? $share_to_id : null);
    /* validate text */
    if (is_empty($text)) {
      throw new ValidationException(__("You must enter some text for your rich text post"));
    }
    /* prepare text */
    if ($system['html_richtext_enabled']) {
      $clean_text = $text;
    } else {
      /* HTMLPurifier */
      $purifier = get_html_purifier();
      $clean_text = $purifier->purify($text);
    }
    /* prepare approval system */
    $pre_approved = 1;
    $has_approved = 1;
    $author_id = $share_to == 'page' ? $share_to_id : $this->_data['user_id'];
    $author_type = $share_to == 'page' ? 'page' : 'user';
    if ($this->check_posts_needs_approval($author_id, $author_type)) {
      $pre_approved = 0;
      $has_approved = 0;
    }
    /* check if paid modules enabled */
    if ($system['paid_blogs_enabled']) {
      $this->wallet_paid_module_payment('blogs');
    }
    /* publish to */
    switch ($share_to) {
      case 'timeline':
        /* insert the post */
        $db->query(sprintf(
          "INSERT INTO posts (
            user_id,
            user_type,
            post_type,
            time,
            privacy,
            pre_approved,
            has_approved
          ) VALUES (%s, 'user', 'rich_text', %s, 'public', %s, %s)",
          secure($this->_data['user_id'], 'int'),
          secure($date),
          secure($pre_approved),
          secure($has_approved)
        ));
        $post_id = $db->insert_id;
        break;

      case 'page':
        /* check if the page is valid */
        $page = $this->get_page($share_to_id);
        if (!$page) {
          _error(400);
        }
        /* check if the viewer is page admin */
        if (!$this->check_page_adminship($this->_data['user_id'], $share_to_id)) {
          _error(400);
        }
        /* insert the post */
        $db->query(sprintf(
          "INSERT INTO posts (
            user_id,
            user_type,
            post_type,
            time,
            privacy,
            pre_approved,
            has_approved
          ) VALUES (%s, 'page', 'rich_text', %s, 'public', %s, %s)",
          secure($share_to_id, 'int'),
          secure($date),
          secure($pre_approved),
          secure($has_approved)
        ));
        $post_id = $db->insert_id;
        break;

      case 'group':
        /* check if the group is valid */
        $group = $this->get_group($share_to_id);
        if (!$group) {
          _error(400);
        }
        /* check if the viewer is group member */
        if ($this->check_group_membership($this->_data['user_id'], $share_to_id) != "approved") {
          _error(400);
        }
        /* check if user is a group admin */
        $group['i_admin'] = $this->check_group_adminship($this->_data['user_id'], $share_to_id);
        /* check if group publishing enabled */
        if (!$group['group_publish_enabled'] && !$group['i_admin']) {
          throw new Exception(__("Publishing to this group has been disabled by group admins"));
        }
        /* insert the post */
        $group_approved = ($group['group_publish_approval_enabled'] && !$group['i_admin']) ? "0" : "1";
        $db->query(sprintf(
          "INSERT INTO posts (
            user_id,
            user_type,
            post_type,
            time,
            privacy,
            in_group,
            group_id,
            group_approved,
            pre_approved,
            has_approved
          ) VALUES (%s, 'user', 'rich_text', %s, 'custom', '1', %s, %s, %s, %s)",
          secure($this->_data['user_id'], 'int'),
          secure($date),
          secure($share_to_id, 'int'),
          secure($group_approved),
          secure($pre_approved),
          secure($has_approved)
        ));
        $post_id = $db->insert_id;
        /* post in_group notification */
        if (!$group_approved) {
          /* send notification to group admin */
          $this->post_notification(['to_user_id' => $group['group_admin'], 'action' => 'group_post_pending', 'node_type' => $group['group_title'], 'node_url' => $group['group_name'] . "-[guid=]" . $post_id]);
        }
        break;

      case 'event':
        /* check if the event is valid */
        $event = $this->get_event($share_to_id);
        if (!$event) {
          _error(400);
        }
        /* check if the viewer is event member */
        if (!$this->check_event_membership($this->_data['user_id'], $share_to_id)) {
          _error(400);
        }
        /* check if user is a event admin */
        $event['i_admin'] = $this->check_event_adminship($this->_data['user_id'], $share_to_id);
        /* check if event publishing enabled */
        if (!$event['event_publish_enabled'] && !$event['i_admin']) {
          throw new Exception(__("Publishing to this event has been disabled by event admins"));
        }
        /* insert the post */
        $event_approved = ($event['event_publish_approval_enabled'] && !$event['i_admin']) ? "0" : "1";
        $db->query(sprintf(
          "INSERT INTO posts (
              user_id,
              user_type,
              post_type,
              time,
              privacy,
              in_event,
              event_id,
              event_approved,
              pre_approved,
              has_approved
            ) VALUES (%s, 'user', 'rich_text', %s, 'custom', '1', %s, %s, %s, %s)",
          secure($this->_data['user_id'], 'int'),
          secure($date),
          secure($share_to_id, 'int'),
          secure($event_approved),
          secure($pre_approved),
          secure($has_approved)
        ));
        $post_id = $db->insert_id;
        /* post in_event notification */
        if (!$event_approved) {
          /* send notification to event admin */
          $this->post_notification(['to_user_id' => $event['event_admin'], 'action' => 'event_post_pending', 'node_type' => $event['event_title'], 'node_url' => $event['event_name'] . "-[guid=]" . $post_id]);
        }
        break;

      default:
        _error(403);
        break;
    }
    /* insert rich text post */
    $db->query(sprintf("INSERT INTO posts_rich_text (post_id, text) VALUES (%s, %s)", secure($post_id, 'int'), secure($clean_text)));
    $this->refresh_post_search($post_id);
    /* extract hosted images from the text */
    $uploaded_images = extract_uploaded_images_from_text($clean_text);
    /* remove pending uploads */
    remove_pending_uploads([...$uploaded_images]);
    /* points balance (rich text) */
    $this->points_balance("add", $this->_data['user_id'], "post", $post_id);
    /* check if post is pending */
    if ($has_approved == 0) {
      /* send notification to admins */
      $this->notify_system_admins("pending_post");
    }
    return $post_id;
  }


  /**
   * update_rich_text_post
   * 
   * @param integer $post_id
   * @param string $text
   * @return void
   */
  public function update_rich_text_post($post_id, $text)
  {
    global $db, $system, $date;
    /* (check|get) post */
    $post = $this->_check_post($post_id, true);
    if (!$post) {
      _error(403);
    }
    /* check if viewer can edit post */
    if (!$post['manage_post']) {
      _error(403);
    }
    $this->check_post_edit_window($post);
    /* check if rich text posts enabled */
    if (!$system['rich_text_posts_enabled']) {
      throw new ValidationException(__("The rich text posts module has been disabled by the admin"));
    }
    /* check rich text posts permission */
    if (!$this->_data['can_add_rich_text_posts']) {
      throw new ValidationException(__("You don't have the permission to do this"));
    }
    /* validate text */
    if (is_empty($text)) {
      throw new ValidationException(__("You must enter some text for your blog"));
    }
    /* prepare text */
    if ($system['html_richtext_enabled']) {
      $clean_text = $text;
    } else {
      /* HTMLPurifier */
      $purifier = get_html_purifier();
      $clean_text = $purifier->purify($text);
    }
    /* update the rich text post */
    $db->query(sprintf("UPDATE posts_rich_text SET text = %s WHERE post_id = %s", secure($clean_text), secure($post_id, 'int')));
    $this->refresh_post_search($post_id);
    /* extract hosted images from the text */
    $uploaded_images = extract_uploaded_images_from_text($clean_text);
    /* remove pending uploads */
    remove_pending_uploads([...$uploaded_images]);
    $this->queue_post_reapproval($post);
  }
}
