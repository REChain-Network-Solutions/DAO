<?php

/**
 * ajax -> data -> load
 * 
 * @package Delus
 * @author Dmitry Sorokin - @sorydima & @sorydev Handles. 
 */

// fetch bootstrap
require('../../../bootstrap.php');

// check AJAX Request
is_ajax();

// user access (exclude these loads from login)
if ($system["system_public"] && !in_array($_POST['get'], ["newsfeed", "reels", "posts_profile", "posts_page", "posts_group", "posts_event", "suggested_pages", "suggested_groups", "suggested_events", "blogs", "category_blogs", "funding", "games", "search_posts", "search_blogs", "search_users", "search_pages", "search_groups", "search_events", "reviews"])) {
  user_access(true);
}

// valid inputs
if (!isset($_POST['offset']) || !is_numeric($_POST['offset'])) {
  _error(400);
}

try {

  // initialize the return array
  $return = [];

  // initialize the attach type
  $append = true;

  // get data
  switch ($_POST['get']) {
    case 'newsfeed':
      /* get newsfeed */
      if ($user->_logged_in && $system['newsfeed_merge_enabled']) {
        /* first get the posts from normal newsfeed */
        $data_newsfeed = $user->get_posts(['get' => $_POST['get'], 'filter' => $_POST['filter'], 'country' => $_POST['country'], 'offset' => $_POST['offset'], 'results' => $system['merge_recent_results']]);
        /* second get the posts from popular */
        $data_popular = $user->get_posts(['get' => 'popular', 'filter' => $_POST['filter'], 'country' => $_POST['country'], 'offset' => $_POST['offset'], 'results' => $system['merge_popular_results']]);
        $data_popular = array_map(function ($element) {
          $element['source'] = "popular";
          return $element;
        }, $data_popular);
        /* third get the posts from discover */
        $data_discover = $user->get_posts(['get' => 'discover', 'filter' => $_POST['filter'], 'country' => $_POST['country'], 'offset' => $_POST['offset'], 'results' => $system['merge_discover_results']]);
        $data_discover = array_map(function ($element) {
          $element['source'] = "discover";
          return $element;
        }, $data_discover);
        /* merge the three arrays */
        $data = array_merge($data_newsfeed, $data_popular, $data_discover);
      } else {
        $data = $user->get_posts(['get' => $_POST['get'], 'filter' => $_POST['filter'], 'country' => $_POST['country'], 'offset' => $_POST['offset']]);
      }

      if ($user->_logged_in) {
        // get posts (reels)
        /* first get the reels from discover */
        $offset = $_POST['offset'] - 1;
        $reels_discover = $user->get_posts(['get' => 'discover', 'filter' => 'reel', 'offset' => $offset]);
        /* second get the reels from newsfeed */
        $reels_newsfeed = $user->get_posts(['get' => 'newsfeed', 'filter' => 'reel', 'offset' => $offset]);
        /* merge the two arrays */
        $reels = array_merge($reels_discover, $reels_newsfeed);
        /* randomize the array */
        shuffle($reels);
        /* assign variables */
        $smarty->assign('reels', $reels);
      }

      // get widgets (newsfeed)
      switch ($_POST['offset']) {
        case '1':
          $widgets = $user->widgets('newfeed_1');
          break;

        case '2':
          $widgets = $user->widgets('newfeed_2');
          break;

        case '3':
          $widgets = $user->widgets('newfeed_3');
          break;
      }
      /* assign variables */
      $smarty->assign('widgets', $widgets);

      // get ads campaigns
      $ads_campaigns = $user->ads_campaigns('newsfeed');
      /* assign variables */
      $smarty->assign('ads_campaigns', $ads_campaigns);

      // get ads
      switch ($_POST['offset']) {
        case '1':
          $ads = $user->ads('newfeed_1');
          break;

        case '2':
          $ads = $user->ads('newfeed_2');
          break;

        case '3':
          $ads = $user->ads('newfeed_3');
          break;
      }
      /* assign variables */
      $smarty->assign('ads', $ads);
      break;

    case 'popular':
      /* get popular */
      $data = $user->get_posts(['get' => $_POST['get'], 'filter' => $_POST['filter'], 'country' => $_POST['country'], 'offset' => $_POST['offset']]);

      // get ads campaigns
      $ads_campaigns = $user->ads_campaigns('newsfeed');
      /* assign variables */
      $smarty->assign('ads_campaigns', $ads_campaigns);

      // get ads
      switch ($_POST['offset']) {
        case '1':
          $ads = $user->ads('newfeed_1');
          break;

        case '2':
          $ads = $user->ads('newfeed_2');
          break;

        case '3':
          $ads = $user->ads('newfeed_3');
          break;
      }
      /* assign variables */
      $smarty->assign('ads', $ads);
      break;

    case 'discover':
      /* get discover */
      $data = $user->get_posts(['get' => $_POST['get'], 'filter' => $_POST['filter'], 'country' => $_POST['country'], 'offset' => $_POST['offset']]);

      // get ads campaigns
      $ads_campaigns = $user->ads_campaigns('newsfeed');
      /* assign variables */
      $smarty->assign('ads_campaigns', $ads_campaigns);

      // get ads
      switch ($_POST['offset']) {
        case '1':
          $ads = $user->ads('newfeed_1');
          break;

        case '2':
          $ads = $user->ads('newfeed_2');
          break;

        case '3':
          $ads = $user->ads('newfeed_3');
          break;
      }
      /* assign variables */
      $smarty->assign('ads', $ads);
      break;

    case 'saved':
    case 'scheduled':
    case 'memories':
    case 'boosted':
      /* get [saved || scheduled || memories || boosted] */
      $data = $user->get_posts(['get' => $_POST['get'], 'filter' => $_POST['filter'], 'country' => $_POST['country'], 'offset' => $_POST['offset']]);
      break;

    case 'reels':
      /* get reels */
      /* first get the reels from public */
      $data_discover = ($user->_logged_in) ? $user->get_posts(['get' => 'discover', 'filter' => 'reel', 'offset' => $_POST['offset']]) : [];
      /* second get the reels from friends */
      $data_friends = $user->get_posts(['get' => 'newsfeed', 'filter' => 'reel', 'offset' => $_POST['offset']]);
      /* merge the two arrays */
      $data = array_merge($data_discover, $data_friends);
      break;

    case 'watch':
      /* get watch */
      /* first get the videos from public */
      $data_discover = $user->get_posts(['get' => 'discover', 'filter' => 'video', 'country' => $_POST['country'], 'offset' => $_POST['offset']]);
      /* second get the videos from friends */
      $data_friends = $user->get_posts(['get' => 'newsfeed', 'filter' => 'video', 'country' => $_POST['country'], 'offset' => $_POST['offset']]);
      /* merge the two arrays */
      $data = array_merge($data_discover, $data_friends);
      break;

    case 'posts_profile':
    case 'posts_page':
    case 'posts_group':
    case 'posts_group_pending':
    case 'posts_group_pending_all':
    case 'posts_event':
    case 'posts_event_pending':
    case 'posts_event_pending_all':
    case 'posts_event':
      /* get [posts_profile || posts_page || posts_group || posts_group_pending || posts_group_pending_all || posts_event || posts_event_pending ||  posts_event_pending_all] */
      /* check id */
      if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
        _error(400);
      }
      $data = $user->get_posts(['get' => $_POST['get'], 'filter' => $_POST['filter'], 'offset' => $_POST['offset'], 'id' => $_POST['id'], 'query' => $_POST['query']]);

      // get ads campaigns
      $ads_campaigns = $user->ads_campaigns('newsfeed');
      /* assign variables */
      $smarty->assign('ads_campaigns', $ads_campaigns);

      // get ads
      switch ($_POST['offset']) {
        case '1':
          $ads = $user->ads('newfeed_1');
          break;

        case '2':
          $ads = $user->ads('newfeed_2');
          break;

        case '3':
          $ads = $user->ads('newfeed_3');
          break;
      }
      /* assign variables */
      $smarty->assign('ads', $ads);
      break;

    case 'products_profile':
      /* get products */
      /* check id */
      if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
        _error(400);
      }
      $data = $user->get_posts(['get' => 'posts_profile', 'id' => $_POST['id'], 'filter' => 'product', 'offset' => $_POST['offset']]);
      break;

    case 'products_page':
      /* get products */
      /* check id */
      if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
        _error(400);
      }
      $data = $user->get_posts(['get' => 'posts_page', 'id' => $_POST['id'], 'filter' => 'product', 'offset' => $_POST['offset']]);
      break;

    case 'products_group':
      /* get products */
      /* check id */
      if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
        _error(400);
      }
      $data = $user->get_posts(['get' => 'posts_group', 'id' => $_POST['id'], 'filter' => 'product', 'offset' => $_POST['offset']]);
      break;

    case 'products_event':
      /* get products */
      /* check id */
      if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
        _error(400);
      }
      $data = $user->get_posts(['get' => 'posts_event', 'id' => $_POST['id'], 'filter' => 'product', 'offset' => $_POST['offset']]);
      break;

    case 'shares':
      /* get who shares the post */
      /* check id */
      if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
        _error(400);
      }
      $data = $user->who_shares($_POST['id'], $_POST['offset']);
      break;

    case 'blogs':
      /* get blogs */
      $data = $user->get_blogs(['offset' => $_POST['offset'], 'country' => $_POST['country']]);
      break;

    case 'category_blogs':
      /* get category blogs */
      /* check id */
      if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
        _error(400);
      }
      $data = $user->get_blogs(["category" => $_POST['id'], 'offset' => $_POST['offset'], 'country' => $_POST['country']]);
      break;

    case 'funding':
      /* get funding */
      $data = $user->get_funding(['offset' => $_POST['offset'], 'country' => $_POST['country']]);
      break;

    case 'post_comments':
      /* get post comments */
      /* check id */
      if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
        _error(400);
      }
      $data = $user->get_comments($_POST['id'], $_POST['offset'], true, false);
      break;

    case 'post_comments_top':
      /* get post comments top */
      /* check id */
      if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
        _error(400);
      }
      $data = $user->get_comments($_POST['id'], $_POST['offset'], true, false, [], "top");
      break;

    case 'post_comments_all':
      /* get post comments top */
      /* check id */
      if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
        _error(400);
      }
      $data = $user->get_comments($_POST['id'], $_POST['offset'], true, false, [], "all");
      break;

    case 'photo_comments':
      /* get photo comments */
      /* check id */
      if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
        _error(400);
      }
      $data = $user->get_comments($_POST['id'], $_POST['offset'], false, false);
      break;

    case 'photo_comments_top':
      /* get photo comments top */
      /* check id */
      if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
        _error(400);
      }
      $data = $user->get_comments($_POST['id'], $_POST['offset'], false, false, [], "top");
      break;

    case 'photo_comments_all':
      /* get photo comments top */
      /* check id */
      if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
        _error(400);
      }
      $data = $user->get_comments($_POST['id'], $_POST['offset'], false, false, [], "all");
      break;

    case 'comment_replies':
      /* get comment replies */
      /* check id */
      if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
        _error(400);
      }
      $append = false;
      $data = $user->get_replies($_POST['id'], $_POST['offset'], false);
      break;

    case 'photos':
      /* get photos */
      /* check id */
      if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
        _error(400);
      }
      $data = $user->get_photos($_POST['id'], $_POST['type'], $_POST['offset'], false);
      $context = ($_POST['type'] == "album") ? "album" : "photos";
      $smarty->assign('context', $context);
      $smarty->assign('type', $_POST['type']);
      break;

    case 'profile_photos':
      /* get photos */
      /* check id */
      if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
        _error(400);
      }
      /* check filter */
      if (!isset($_POST['filter']) || !in_array($_POST['filter'], ['avatar', 'cover'])) {
        _error(400);
      }
      /* check type */
      if (!isset($_POST['type']) || !in_array($_POST['type'], ['user', 'page', 'group', 'event'])) {
        _error(400);
      }
      $data = $user->get_photos($_POST['id'], $_POST['type'], $_POST['offset'], false);
      $smarty->assign('id', $_POST['id']);
      $smarty->assign('filter', $_POST['filter']);
      $smarty->assign('type', $_POST['type']);
      break;

    case 'albums':
      /* get albums */
      /* check id */
      if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
        _error(400);
      }
      $data = $user->get_albums($_POST['id'], $_POST['type'], $_POST['offset']);
      break;

    case 'videos':
      /* get videos */
      /* check id */
      if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
        _error(400);
      }
      $data = $user->get_videos($_POST['id'], $_POST['type'], $_POST['offset']);
      break;

    case 'videos_reels':
      /* get videos */
      /* check id */
      if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
        _error(400);
      }
      $data = $user->get_reels($_POST['id'], $_POST['type'], $_POST['offset']);
      break;

    case 'post_reactions':
      /* get who reacted to the post */
      /* check id */
      if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
        _error(400);
      }
      $data = $user->who_reacts(['post_id' => $_POST['id'], 'reaction_type' => $_POST['filter'], 'offset' => $_POST['offset']]);
      break;

    case 'photo_reactions':
      /* get who reacted to the photo */
      /* check id */
      if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
        _error(400);
      }
      $data = $user->who_reacts(['photo_id' => $_POST['id'], 'reaction_type' => $_POST['filter'], 'offset' => $_POST['offset']]);
      break;

    case 'comment_reactions':
      /* get who reacted to the comment */
      /* check id */
      if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
        _error(400);
      }
      $data = $user->who_reacts(['comment_id' => $_POST['id'], 'reaction_type' => $_POST['filter'], 'offset' => $_POST['offset']]);
      break;

    case 'donors':
      /* get donors */
      /* check id */
      if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
        _error(400);
      }
      $data = $user->who_donates($_POST['id'], $_POST['offset']);
      break;

    case 'voters':
      /* get voters */
      /* check id */
      if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
        _error(400);
      }
      $data = $user->who_votes($_POST['id'], $_POST['offset']);
      break;

    case 'blocks':
      /* get blocks */
      $data = $user->get_blocked($_POST['offset']);
      break;

    case 'affiliates':
      /* get affiliates */
      /* check uid */
      if (!isset($_POST['uid']) || !is_numeric($_POST['uid'])) {
        _error(400);
      }
      $data = $user->get_affiliates($_POST['uid'], $_POST['offset']);
      break;

    case 'friend_requests':
      /* get friend requests */
      $data = $user->get_friend_requests($_POST['offset']);
      break;

    case 'friend_requests_sent':
      /* get friend requests sent */
      $data = $user->get_friend_requests_sent($_POST['offset']);
      break;

    case 'mutual_friends':
      /* get mutual friends */
      /* check uid */
      if (!isset($_POST['uid']) || !is_numeric($_POST['uid'])) {
        _error(400);
      }
      $data = $user->get_mutual_friends($_POST['uid'], $_POST['offset']);
      break;

    case 'new_people':
      /* get new people */
      $data = $user->get_new_people($_POST['offset']);
      break;

    case 'friends':
      /* get friends */
      /* check uid */
      if (!isset($_POST['uid']) || !is_numeric($_POST['uid'])) {
        _error(400);
      }
      $data = $user->get_friends($_POST['uid'], $_POST['offset']);
      break;

    case 'followers':
      /* get followers */
      /* check uid */
      if (!isset($_POST['uid']) || !is_numeric($_POST['uid'])) {
        _error(400);
      }
      $data = $user->get_followers($_POST['uid'], $_POST['offset']);
      break;

    case 'followings':
      /* get followings */
      /* check uid */
      if (!isset($_POST['uid']) || !is_numeric($_POST['uid'])) {
        _error(400);
      }
      $data = $user->get_followings($_POST['uid'], $_POST['offset']);
      break;

    case 'subscribers':
      /* get subscribers */
      /* check uid */
      if (!isset($_POST['uid']) || !is_numeric($_POST['uid'])) {
        _error(400);
      }
      /* check type */
      if (!isset($_POST['type']) || !in_array($_POST['type'], ['user', 'page', 'group'])) {
        _error(400);
      }
      $data = $user->get_subscribers($_POST['uid'], $_POST['type'], $_POST['offset']);
      break;

    case 'subscriptions':
      /* get subscriptions */
      /* check uid */
      if (!isset($_POST['uid']) || !is_numeric($_POST['uid'])) {
        _error(400);
      }
      $data = $user->get_subscriptions($_POST['uid'], $_POST['offset']);
      break;

    case 'page_invites':
      /* get page invites */
      /* check id */
      if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
        _error(400);
      }
      $data = $user->get_page_invites($_POST['id'], $_POST['offset']);
      break;

    case 'page_members':
      /* get page members */
      /* check id */
      if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
        _error(400);
      }
      $data = $user->get_page_members($_POST['id'], $_POST['offset']);
      break;

    case 'page_admins':
      /* get page admins */
      /* check id */
      if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
        _error(400);
      }
      $data = $user->get_page_admins($_POST['id'], $_POST['offset']);
      break;

    case 'group_members':
      /* get group members */
      /* check id */
      if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
        _error(400);
      }
      $data = $user->get_group_members($_POST['id'], $_POST['offset']);
      break;

    case 'group_members_manage':
      /* get group members manage */
      /* check id */
      if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
        _error(400);
      }
      $data = $user->get_group_members($_POST['id'], $_POST['offset'], true);
      break;

    case 'group_admins':
      /* get group admins */
      /* check id */
      if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
        _error(400);
      }
      $data = $user->get_group_admins($_POST['id'], $_POST['offset']);
      break;


    case 'group_invites':
      /* get group invites */
      /* check id */
      if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
        _error(400);
      }
      $data = $user->get_group_invites($_POST['id'], $_POST['offset']);
      break;

    case 'group_requests':
      /* get group requests */
      /* check id */
      if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
        _error(400);
      }
      $data = $user->get_group_requests($_POST['id'], $_POST['offset']);
      break;

    case 'event_going':
      /* get event going members */
      /* check id */
      if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
        _error(400);
      }
      $data = $user->get_event_members($_POST['id'], 'going', $_POST['offset']);
      break;

    case 'event_interested':
      /* get event interested members */
      /* check id */
      if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
        _error(400);
      }
      $data = $user->get_event_members($_POST['id'], 'interested', $_POST['offset']);
      break;

    case 'event_invited':
      /* get event invited members */
      /* check id */
      if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
        _error(400);
      }
      $data = $user->get_event_members($_POST['id'], 'invited', $_POST['offset']);
      break;

    case 'event_invites':
      /* get event invites */
      /* check id */
      if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
        _error(400);
      }
      $data = $user->get_event_invites($_POST['id'], $_POST['offset']);
      break;

    case 'pages':
      /* get viewer pages */
      $data = $user->get_pages(['offset' => $_POST['offset'], 'country' => $_POST['country']]);
      break;

    case 'suggested_pages':
      /* get suggested pages */
      $data = $user->get_pages(['suggested' => true, 'offset' => $_POST['offset'], 'country' => $_POST['country']]);
      break;

    case 'category_pages':
      /* check id */
      if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
        _error(400);
      }
      /* get category pages */
      $data = $user->get_pages(['suggested' => true, 'category_id' => $_POST['id'], 'offset' => $_POST['offset'], 'country' => $_POST['country']]);
      break;

    case 'liked_pages':
    case 'profile_pages':
      /* get [liked_pages || profile_pages] */
      /* check uid */
      if (!isset($_POST['uid']) || !is_numeric($_POST['uid'])) {
        _error(400);
      }
      $data = $user->get_pages(['user_id' => $_POST['uid'], 'offset' => $_POST['offset'], 'country' => $_POST['country']]);
      break;

    case 'boosted_pages':
      /* get boosted pages */
      $data = $user->get_pages(['boosted' => true, 'offset' => $_POST['offset']]);
      break;

    case 'groups':
      /* get viewer groups */
      $data = $user->get_groups(['offset' => $_POST['offset'], 'country' => $_POST['country']]);
      break;

    case 'suggested_groups':
      /* get suggested groups */
      $data = $user->get_groups(['suggested' => true, 'offset' => $_POST['offset'], 'country' => $_POST['country']]);
      break;

    case 'category_groups':
      /* check id */
      if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
        _error(400);
      }
      /* get category groups */
      $data = $user->get_groups(['suggested' => true, 'category_id' => $_POST['id'], 'offset' => $_POST['offset'], 'country' => $_POST['country']]);
      break;

    case 'joined_groups':
    case 'profile_groups':
      /* get [joined_groups || profile_groups] */
      /* check uid */
      if (!isset($_POST['uid']) || !is_numeric($_POST['uid'])) {
        _error(400);
      }
      $data = $user->get_groups(['user_id' => $_POST['uid'], 'offset' => $_POST['offset'], 'country' => $_POST['country']]);
      break;

    case 'events':
      /* get viewer events */
      $data = $user->get_events(['offset' => $_POST['offset'], 'country' => $_POST['country']]);
      break;

    case 'suggested_events':
      /* get suggested events */
      $data = $user->get_events(['suggested' => true, 'offset' => $_POST['offset'], 'country' => $_POST['country']]);
      break;

    case 'category_events':
      /* check id */
      if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
        _error(400);
      }
      /* get category events */
      $data = $user->get_events(['suggested' => true, 'category_id' => $_POST['id'], 'offset' => $_POST['offset'], 'country' => $_POST['country']]);
      break;

    case 'going_events':
      /* get going events */
      $data = $user->get_events(['filter' => 'going', 'offset' => $_POST['offset'], 'country' => $_POST['country']]);
      break;

    case 'interested_events':
      /* get interested events */
      $data = $user->get_events(['filter' => 'interested', 'offset' => $_POST['offset'], 'country' => $_POST['country']]);
      break;

    case 'invited_events':
      /* get invited events */
      $data = $user->get_events(['filter' => 'invited', 'offset' => $_POST['offset'], 'country' => $_POST['country']]);
      break;

    case 'profile_events':
      /* get profile events */
      /* check uid */
      if (!isset($_POST['uid']) || !is_numeric($_POST['uid'])) {
        _error(400);
      }
      $data = $user->get_events(['user_id' => $_POST['uid'], 'offset' => $_POST['offset']]);
      break;

    case 'page_events':
      /* get page events */
      /* check id */
      if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
        _error(400);
      }
      $data = $user->get_events(['page_id' => $_POST['id'], 'results' => $system['max_results_even'], 'offset' => $_POST['offset']]);
      break;

    case 'games':
      /* get games */
      $data = $user->get_games($_POST['offset']);
      break;

    case 'genre_games':
      /* check id */
      if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
        _error(400);
      }
      /* get games */
      $data = $user->get_games($_POST['offset'], false, $_POST['id']);
      break;

    case 'played_games':
      /* get played games */
      $data = $user->get_games($_POST['offset'], true);
      break;

    case 'notifications':
      /* get notifications */
      $data = $user->get_notifications($_POST['offset']);
      break;

    case 'conversations':
      /* get conversations */
      $data = $user->get_conversations($_POST['offset'])['data'];
      break;

    case 'messages':
      /* get conversation messages */
      /* check id */
      if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
        _error(400);
      }
      $append = false;
      $data = $user->get_conversation_messages($_POST['id'], $_POST['offset'])['messages'];
      break;

    case 'job_candidates':
      /* get job candidates  */
      /* check id */
      if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
        _error(400);
      }
      $data = $user->get_job_candidates($_POST['id'], $_POST['offset']);
      break;

    case 'course_candidates':
      /* get course candidates  */
      /* check id */
      if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
        _error(400);
      }
      $data = $user->get_course_candidates($_POST['id'], $_POST['offset']);
      break;

    case 'search_posts':
    case 'search_blogs':
    case 'search_users':
    case 'search_pages':
    case 'search_groups':
    case 'search_events':
      /* get search results */
      /* check query */
      if (!isset($_POST['filter'])) {
        _error(400);
      }
      $tab = str_replace("search_", "", $_POST['get']);
      $data = $user->search($_POST['filter'], $tab, $_POST['offset']);
      break;

    case 'orders':
      /* get orders */
      if (isset($_POST['filter'])) {
        $data = $user->get_orders(['offset' => $_POST['offset'], 'filter' => $_POST['filter']]);
      } else {
        $data = $user->get_orders(['offset' => $_POST['offset']]);
      }
      break;

    case 'sales_orders':
      /* get orders */
      if (isset($_POST['filter'])) {
        $data = $user->get_orders(['sales_orders' => 'true', 'offset' => $_POST['offset'], 'filter' => $_POST['filter']]);
      } else {
        $data = $user->get_orders(['sales_orders' => 'true', 'offset' => $_POST['offset']]);
      }
      break;

    case 'reviews':
      /* check id */
      if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
        _error(400);
      }
      $data = $user->get_reviews($_POST['id'], $_POST['type'], $_POST['offset']);
      break;

    default:
      /* bad request */
      _error(400);
      break;
  }

  // handle data
  if ($data) {
    /* assign variables */
    $smarty->assign('offset', $_POST['offset']);
    $smarty->assign('get', $_POST['get']);
    $smarty->assign('data', $data);
    /* return */
    $return['append'] = $append;
    $return['data'] = $smarty->fetch("ajax.load_more.tpl");
  }

  // return & exit
  return_json($return);
} catch (Exception $e) {
  modal("ERROR", __("Error"), $e->getMessage());
}
