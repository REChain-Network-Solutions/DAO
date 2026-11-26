<?php

/**
 * ajax -> live -> reaction
 * 
 * @package Sngine
 * @author Zamblek
 */

// fetch bootstrap
require('../../../bootstrap.php');

// check AJAX Request
is_ajax();

// user access
user_access(true);

try {

  // initialize the return array
  $return = [];

  switch ($_POST['do']) {
    case 'start':
      // create live post
      $post_id = $user->create_live_post([
        'channel_name' => $_POST['channel_name'],
        'video_thumbnail' => $_POST['video_thumbnail'],
        'node' => $_POST['node'],
        'node_id' => $_POST['node_id'],
        'title' => $_POST['title'],
        'description' => $_POST['description'],
        'category_id' => $_POST['category_id'],
        'broadcast_type' => $_POST['broadcast_type'],
        'privacy' => $_POST['privacy'],
        'tips_enabled' => $_POST['tips_enabled'],
        'for_subscriptions' => $_POST['for_subscriptions'],
        'is_paid' => $_POST['is_paid'],
        'post_price' => $_POST['post_price']
      ]);

      // return
      $return['post_id'] = $post_id;
      break;

    case 'rtmp_prepare':
      // prepare the streaming software (url|key)
      $return['rtmp'] = $user->live_rtmp_prepare();
      break;

    case 'rtmp_reset':
      // reset the stream key
      $return['rtmp'] = $user->live_rtmp_prepare(true);
      break;

    case 'end':
      // update live post
      $user->end_live_post($_POST['post_id']);
      break;

    case 'join':
      // get live post
      $post = $user->get_post($_POST['post_id'], true, true);
      if (!$post) {
        throw new Exception(__("This live no longer exists"));
      }
      /* assign variables */
      $smarty->assign('post', $post);
      $smarty->assign('live_rules', ($post['live']['live_ended']) ? '' : $user->get_live_rules($post));

      // join live post
      if (!$post['live']['live_ended']) {
        /* check if the viewer is removed from the live */
        $restriction = $user->get_live_restriction($post);
        if ($restriction && in_array($restriction['type'], ['kick', 'ban']) && !$user->can_moderate_live($post)) {
          throw new Exception(__("You have been removed from this live"));
        }
        $user->join_live_post($_POST['post_id'], ($post['live']['live_provider'] == "livekit") ? $post['live']['livekit_audience_identity'] : $post['live']['agora_audience_uid']);
      }

      // return
      $return['live_provider'] = $post['live']['live_provider'];
      $return['livekit_room'] = $post['live']['livekit_room'];
      $return['livekit_token'] = $post['live']['livekit_audience_token'] ?? null;
      $return['agora_audience_uid'] = $post['live']['agora_audience_uid'] ?? null;
      $return['agora_audience_token'] = $post['live']['agora_audience_token'] ?? null;
      $return['agora_channel_name'] = $post['live']['agora_channel_name'];
      $return['live_ended'] = ($post['live']['live_ended']) ? true : false;
      $return['lightbox'] = $smarty->fetch("ajax.lightbox-live.tpl");
      break;

    case 'leave':
      // leave live post
      $user->leave_live_post($_POST['post_id']);
      break;

    case 'stats':
      // get live post stats
      $comments = json_decode($_POST['comments'] ?? '', true);
      $stats = $user->get_live_post_stats($_POST['post_id'], $_POST['last_comment_id'], (is_array($comments)) ? $comments : [], (int) ($_POST['last_reply_id'] ?? -1));
      /* assign variables */
      $smarty->assign('comments', $stats['comments']);

      // return
      $return['restriction'] = $stats['restriction'];
      $return['live_count'] = $stats['live_count'];
      $return['comments'] = $smarty->fetch("ajax.live.comments.tpl");
      $return['last_reply_id'] = $stats['last_reply_id'];
      $return['reactions'] = $stats['reactions'];
      /* comments updates */
      $return['updates'] = [];
      foreach ($stats['updates'] as $comment_id => $update) {
        $return['updates'][$comment_id] = ['signature' => $update['signature']];
        if ($update['comment']) {
          $smarty->assign('_comment', $update['comment']);
          $return['updates'][$comment_id]['stats'] = $smarty->fetch('__feeds_comment.reactions_stats.tpl');
        }
      }
      /* new replies */
      $return['replies'] = [];
      foreach ($stats['replies'] as $comment_id => $replies) {
        $smarty->assign('comments', $replies);
        $smarty->assign('_is_reply', true);
        $return['replies'][$comment_id] = $smarty->fetch("ajax.live.comments.tpl");
      }
      break;

    default:
      _error(400);
      break;
  }

  // return & exit
  return_json($return);
} catch (Exception $e) {
  modal("ERROR", __("Error"), $e->getMessage());
}
