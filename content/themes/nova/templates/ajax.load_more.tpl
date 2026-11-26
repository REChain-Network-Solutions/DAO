{if $get == 'watch' || $get == 'watch_following' || $get == 'watch_manage'}
  {foreach $data as $post}
    {include file='__feeds_video.tpl'}
  {/foreach}


{elseif $get == 'live_now' || $get == 'live_ended'}
  {foreach $data as $post}
    {include file='__live_card.tpl'}
  {/foreach}


{elseif $get == 'newsfeed' || $get == 'posts_profile' || $get == 'posts_page' || $get == 'posts_group' || $get == 'posts_group_pending' || $get == 'posts_group_pending_all' || $get == 'posts_event' || $get == 'posts_event_pending' || $get == 'posts_event_pending_all' || $get == 'saved' || $get == 'scheduled' || $get == 'memories' || $get == 'boosted' || $get == 'popular' || $get == 'discover'}
  {include file='_widget.tpl'}
  {include file='_ads.tpl'}
  {include file='_ads_campaigns.tpl'}

  {if $get == 'newsfeed'}
    {if $reels}
      {include file='__reels_strip.tpl'}
    {/if}
  {/if}

  {foreach $data as $post}
    {include file='__feeds_post.tpl' _get=$get}
  {/foreach}

{elseif $get == 'reels'}
  {foreach $data as $post}
    {include file='__feeds_reel.tpl'}
  {/foreach}


{elseif $get == 'products_profile' || $get == 'products_page' || $get == 'products_group' || $get == 'products_event'}
  {foreach $data as $post}
    {include file='__feeds_product.tpl'}
  {/foreach}


{elseif $get == 'shares'}
  {foreach $data as $_post}
    {include file='__feeds_share.tpl'}
  {/foreach}


{elseif $get == 'blogs_profile' || $get == 'blogs_page' || $get == 'blogs_group' || $get == 'blogs_event'}
  {foreach $data as $blog}
    {include file='__feeds_blog.tpl' _tpl="featured"}
  {/foreach}


{elseif $get == 'post_comments' || $get == 'post_comments_top' || $get == 'post_comments_all' || $get == 'photo_comments' || $get == 'photo_comments_top' || $get == 'photo_comments_all'}
  {foreach $data as $comment}
    {include file='__feeds_comment.tpl' _comment=$comment}
  {/foreach}


{elseif $get == 'comment_replies'}
  {foreach $data as $comment}
    {include file='__feeds_comment.tpl' _comment=$comment _is_reply=true}
  {/foreach}


{elseif $get == 'photos'}
  {foreach $data as $photo}
    {if $tpl == "list"}
      {include file='__profile_media.tpl' _kind='photo' _context=$context _can_pin=($type == 'user')}
    {elseif $type == "user"}
      {include file='__feeds_photo.tpl' _context=$context _can_pin=true}
    {else}
      {include file='__feeds_photo.tpl' _context=$context}
    {/if}
  {/foreach}


{elseif $get == 'profile_photos'}
  {foreach $data as $photo}
    {include file='__feeds_profile_photo.tpl' _filter=$filter}
  {/foreach}


{elseif $get == 'albums'}
  {foreach $data as $album}
    {if $tpl == "list"}
      {include file='__profile_media.tpl' _kind='album'}
    {else}
      {include file='__feeds_album.tpl'}
    {/if}
  {/foreach}


{elseif $get == 'videos'}
  {foreach $data as $video}
    {if $tpl == "list"}
      {include file='__profile_media.tpl' _kind='video'}
    {else}
      {include file='__feeds_video.tpl'}
    {/if}
  {/foreach}


{elseif $get == 'videos_reels'}
  {foreach $data as $video}
    {if $tpl == "list"}
      {include file='__profile_media.tpl' _kind='video' _is_reel=true}
    {else}
      {include file='__feeds_video.tpl' _is_reel=true}
    {/if}
  {/foreach}


{elseif $get == 'post_reactions' || $get == 'photo_reactions' || $get == 'comment_reactions' || $get == 'donors' || $get == 'voters' || $get == 'blocks' || $get == 'affiliates' || $get == 'group_requests'}
  {foreach $data as $_user}
    {include file='__feeds_user.tpl' _tpl="list" _connection=$_user["connection"] _reaction=$_user["reaction"] _donation=$_user['donation_amount'] _donation_time=$_user['donation_time']}
  {/foreach}


{elseif $get == 'friend_requests'}
  {foreach $data as $_user}
    {if $tpl == "people"}
      {include file='__people_card.tpl' _connection="request"}
    {else}
      {include file='__feeds_user.tpl' _tpl="list" _connection="request"}
    {/if}
  {/foreach}


{elseif $get == 'friend_requests_sent'}
  {foreach $data as $_user}
    {if $tpl == "people"}
      {include file='__people_card.tpl' _connection="cancel"}
    {else}
      {include file='__feeds_user.tpl' _tpl="list" _connection="cancel"}
    {/if}
  {/foreach}


{elseif $get == 'mutual_friends'}
  {foreach $data as $_user}
    {include file='__feeds_user.tpl' _tpl="list" _connection="remove"}
  {/foreach}


{elseif $get == 'dating_browse' || $get == 'dating_likes'}
  {foreach $data as $card}
    {include file='__dating_grid_card.tpl'}
  {/foreach}


{elseif $get == 'dating_matches'}
  {foreach $data as $match}
    {include file='__dating_grid_card.tpl' card=$match _matched=true}
  {/foreach}


{elseif $get == 'new_people'}
  {foreach $data as $_user}
    {if $tpl == "people"}
      {include file='__people_card.tpl' _connection="add"}
    {else}
      {include file='__feeds_user.tpl' _tpl="list" _connection="add"}
    {/if}
  {/foreach}


{elseif $get == 'friends'}
  {foreach $data as $_user}
    {include file='__feeds_user.tpl' _tpl="box" _connection=$_user["connection"] _top_friends=true _darker=true}
  {/foreach}


{elseif $get == 'followers' || $get == 'followings' || $get == 'subscribers' || $get == 'page_invites' || $get == 'group_members' || $get == 'group_invites'  || $get == 'event_going'  || $get == 'event_interested'  || $get == 'event_invited'  || $get == 'event_invites'}
  {foreach $data as $_user}
    {include file='__feeds_user.tpl' _tpl=$tpl _darker=true _connection=$_user["connection"]}
  {/foreach}


{elseif $get == 'subscriptions'}
  {foreach $data as $_subscription}
    {if $_subscription['node_type'] == "profile"}
      {include file='__people_card.tpl' _user=$_subscription _connection='unsubscribe' _darker=true}
    {elseif $_subscription['node_type'] == "page"}
      {include file='__pages_card.tpl' _page=$_subscription _connection='unsubscribe' _darker=true}
    {elseif $_subscription['node_type'] == "group"}
      {include file='__groups_card.tpl' _group=$_subscription _connection='unsubscribe' _darker=true}
    {/if}
  {/foreach}


{elseif $get == 'page_members' || $get == 'page_admins' || $get == 'group_members_manage' || $get == 'group_admins'}
  {foreach $data as $_user}
    {include file='__feeds_user.tpl' _tpl="list" _connection=$_user["connection"]}
  {/foreach}


{elseif $get == 'pages' || $get == 'suggested_pages' || $get == 'category_pages' || $get == 'liked_pages'}
  {foreach $data as $_page}
    {include file='__pages_card.tpl'}
  {/foreach}


{elseif $get == 'profile_pages'}
  {foreach $data as $_page}
    {include file='__pages_card.tpl'}
  {/foreach}


{elseif $get == 'boosted_pages'}
  {foreach $data as $_page}
    {include file='__feeds_page.tpl' _tpl='list'}
  {/foreach}


{elseif $get == 'groups' || $get == 'suggested_groups' || $get == 'category_groups' || $get == 'joined_groups'}
  {foreach $data as $_group}
    {if $tpl == "groups"}
      {include file='__groups_card.tpl'}
    {else}
      {include file='__feeds_group.tpl' _tpl='box'}
    {/if}
  {/foreach}


{elseif $get == 'profile_groups'}
  {foreach $data as $_group}
    {include file='__groups_card.tpl'}
  {/foreach}


{elseif $get == 'boosted_groups'}
  {foreach $data as $_group}
    {include file='__feeds_group.tpl' _tpl='list'}
  {/foreach}


{elseif $get == 'events' || $get == 'suggested_events' || $get == 'category_events' || $get == 'going_events' || $get == 'interested_events' || $get == 'invited_events'}
  {foreach $data as $_event}
    {include file='__feeds_event.tpl' _tpl='box'}
  {/foreach}


{elseif $get == 'profile_events' || $get == 'page_events'}
  {foreach $data as $_event}
    {include file='__feeds_event.tpl' _tpl='box'}
  {/foreach}


{elseif $get == 'boosted_events'}
  {foreach $data as $_event}
    {include file='__feeds_event.tpl' _tpl='list'}
  {/foreach}


{elseif $get == 'notifications'}
  {foreach $data as $notification}
    {include file='__feeds_notification.tpl' _tpl="with-action"}
  {/foreach}


{elseif $get == 'conversations' || $get == 'page_conversations' || $get == 'conversations_search'}
  {foreach $data as $conversation}
    {include file='__feeds_conversation.tpl'}
  {/foreach}


{elseif $get == 'shortcuts'}
  {foreach $data as $_shortcut}
    {include file='__shortcut_row.tpl'}
  {/foreach}


{elseif $get == 'messages' || $get == 'page_messages'}
  {foreach $data as $message}
    {include file='__feeds_message.tpl'}
  {/foreach}


{elseif $get == 'course_candidates'}
  {foreach $data as $candidate}
    {include file='__feeds_course_candidate.tpl'}
  {/foreach}


{elseif $get == 'job_candidates'}
  {foreach $data as $candidate}
    {include file='__feeds_candidate.tpl'}
  {/foreach}


{elseif $get == 'search_posts'}
  {foreach $data as $post}
    {include file='__feeds_post.tpl'}
  {/foreach}


{elseif $get == 'search_users' || $get == 'find_people'}
  {foreach $data as $_user}
    {include file='__people_card.tpl' _connection=$_user['connection']}
  {/foreach}


{elseif $get == 'search_pages'}
  {foreach $data as $_page}
    {include file='__pages_card.tpl'}
  {/foreach}


{elseif $get == 'search_groups'}
  {foreach $data as $_group}
    {include file='__groups_card.tpl'}
  {/foreach}


{elseif $get == 'search_events'}
  {foreach $data as $_event}
    {include file='__feeds_event.tpl' _tpl="box"}
  {/foreach}


{elseif $get == 'orders'}
  {foreach $data as $order}
    {include file='_order.tpl'}
  {/foreach}


{elseif $get == 'sales_orders'}
  {foreach $data as $order}
    {include file='_order.tpl' sales=true}
  {/foreach}


{elseif $get == 'reviews'}
  {foreach $data as $_review}
      {if $tpl == 'list' && $_review['node_type'] == 'group'}
        {include file='__group_review.tpl'}
      {elseif $tpl == 'list' && $_review['node_type'] == 'event'}
        {include file='__event_review.tpl'}
      {elseif $tpl == 'list'}
      {include file='__page_review.tpl'}
    {else}
      {include file='__feeds_review.tpl'}
    {/if}
  {/foreach}


{elseif $get == 'coupon_users'}
  {foreach $data as $_user}
    {include file='__feeds_user.tpl' _tpl="list" _connection=$_user["connection"]}
  {/foreach}

{/if}
