<li>
  <div class="comment flex items-start gap-2.5 {if $_is_reply}reply{/if}" data-id="{$_comment['comment_id']}" data-live-signature="{$_comment['reaction_like_count']}.{$_comment['reaction_love_count']}.{$_comment['reaction_haha_count']}.{$_comment['reaction_yay_count']}.{$_comment['reaction_wow_count']}.{$_comment['reaction_sad_count']}.{$_comment['reaction_angry_count']}" id="comment_{$_comment['comment_id']}">
    <!-- comment avatar -->
    <div class="comment-avatar shrink-0">
      <a class="comment-avatar-picture block {if $_is_reply}size-8{else}size-10{/if} rounded-full bg-cover bg-center" href="{$_comment['author_url']}" style="background-image:url({$_comment['author_picture']});" aria-label="{$_comment['author_name']}"></a>
    </div>
    <!-- comment avatar -->

    <!-- comment body -->
    <div class="comment-data min-w-0 flex-1 pb-2">
      <!-- comment menu -->
      {if $user->_logged_in}
        <div class="comment-btn dropdown relative float-end inline-flex [--offset:4] [--placement:bottom-end]">
          <button type="button" class="dropdown-toggle dropdown-toggle-icon inline-flex size-7 items-center justify-center rounded-full text-base-content/40 transition-colors hover:bg-base-300 hover:text-base-content" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Comment Actions")}"><span class="icon-[tabler--dots] size-4" aria-hidden="true"></span></button>
          <div class="dropdown-menu dropdown-open:opacity-100 hidden min-w-40" role="menu">
            {if !$_comment['edit_comment'] && !$_comment['delete_comment'] }
              <div class="js_modal dropdown-item cursor-pointer" data-url="data/report.php?do=create&handle=comment&id={$_comment['comment_id']}">{__("Report")}</div>
            {elseif !$_comment['edit_comment'] && $_comment['delete_comment']}
              <div class="dropdown-item cursor-pointer js_delete-comment">{__("Delete Comment")}</div>
            {else}
              <div class="dropdown-item cursor-pointer js_edit-comment">{__("Edit Comment")}</div>
              <div class="dropdown-item cursor-pointer js_delete-comment">{__("Delete Comment")}</div>
            {/if}
            {if $_comment['live_restrict']}
              <div class="js_modal js_live-action dropdown-item cursor-pointer" data-url="live/moderate.php?do=timeout&post_id={$_comment['live_post_id']}&user_id={$_comment['user_id']}" data-uid="{$_comment['user_id']}" data-group="restriction" data-action="timeout" data-off="{__("Timeout")}" data-on="{__("Remove Timeout")}">{if $_comment['live_restriction'] == "timeout"}{__("Remove Timeout")}{else}{__("Timeout")}{/if}</div>
              <div class="js_modal js_live-action dropdown-item cursor-pointer" data-url="live/moderate.php?do=mute&post_id={$_comment['live_post_id']}&user_id={$_comment['user_id']}" data-uid="{$_comment['user_id']}" data-group="restriction" data-action="mute" data-off="{__("Mute")}" data-on="{__("Unmute")}">{if $_comment['live_restriction'] == "mute"}{__("Unmute")}{else}{__("Mute")}{/if}</div>
              <div class="js_modal js_live-action dropdown-item cursor-pointer" data-url="live/moderate.php?do=kick&post_id={$_comment['live_post_id']}&user_id={$_comment['user_id']}" data-uid="{$_comment['user_id']}" data-group="restriction" data-action="kick" data-off="{__("Kick")}" data-on="{__("Remove Kick")}">{if $_comment['live_restriction'] == "kick"}{__("Remove Kick")}{else}{__("Kick")}{/if}</div>
            {/if}
            {if $_comment['live_ban']}
              <div class="js_modal js_live-action dropdown-item cursor-pointer" data-url="live/moderate.php?do=ban&post_id={$_comment['live_post_id']}&user_id={$_comment['user_id']}" data-uid="{$_comment['user_id']}" data-group="restriction" data-action="ban" data-off="{__("Ban")}" data-on="{__("Unban")}">{if $_comment['live_restriction'] == "ban"}{__("Unban")}{else}{__("Ban")}{/if}</div>
            {/if}
            {if $_comment['live_moderators']}
              <div class="js_modal js_live-action dropdown-item cursor-pointer" data-url="live/moderate.php?do=moderator&post_id={$_comment['live_post_id']}&user_id={$_comment['user_id']}" data-uid="{$_comment['user_id']}" data-group="moderator" data-action="moderator" data-off="{__("Make Moderator")}" data-on="{__("Remove Moderator")}">{if $_comment['live_is_moderator']}{__("Remove Moderator")}{else}{__("Make Moderator")}{/if}</div>
            {/if}
          </div>
        </div>
      {/if}
      <!-- comment menu -->

      <!-- comment author & text  -->
      <div class="comment-inner-wrapper flex">
        <div class="comment-inner js_notifier-flasher min-w-0 rounded-2xl bg-base-200/70 px-3.5 py-2">
          <!-- author -->
          <div class="comment-author flex flex-wrap items-center gap-1 text-sm font-semibold">
            <span class="js_user-popover" data-type="{$_comment['user_type']}" data-uid="{$_comment['user_id']}">
              <a class="text-base-content! hover:text-primary!" href="{$_comment['author_url']}">{$_comment['author_name']}</a>
            </span>
            {if $_comment['author_verified']}
              {include file='__badge.tpl' _badge="verified" _badge_type="user" _badge_size=20}
            {/if}
            {if $_comment['user_subscribed']}
              {include file='__badge.tpl' _badge="pro" _badge_package=$_comment['package_name'] _badge_size=20}
            {/if}
          </div>
          <!-- author -->

          <!-- text -->
          {include file='__feeds_comment.text.tpl'}
          <!-- text -->
        </div>
      </div>
      <!-- comment author & text  -->

      <!-- comment actions & time  -->
      <ul class="comment-actions mt-1 flex flex-wrap items-center gap-x-3 gap-y-1 ps-3.5 text-xs font-semibold text-base-content/60">
        <!-- reactions -->
        <li>
          <div class="cursor-pointer unselectable reactions-wrapper {if $_comment['i_react']}js_unreact-comment{/if}" data-reaction="{$_comment['i_reaction']}">
            <!-- reaction-btn -->
            <div class="reaction-btn flex items-center justify-center">
              {if !$_comment['i_react']}
                <div class="reaction-btn-icon hidden">
                  <span class="icon-[tabler--mood-smile] size-4" aria-hidden="true"></span>
                </div>
                <span class="reaction-btn-name cursor-pointer transition-colors hover:text-base-content">{__("React")}</span>
              {else}
                <div class="reaction-btn-icon hidden">
                  <div class="inline-emoji no_animation inline-flex size-4">
                    {include file='__reaction_emojis.tpl' _reaction=$_comment['i_reaction']}
                  </div>
                </div>
                <span class="reaction-btn-name cursor-pointer" style="color: {$system['reactions'][$_comment['i_reaction']]['color']};">{__($system['reactions'][$_comment['i_reaction']]['title'])}</span>
              {/if}
            </div>
            <!-- reaction-btn -->

            {include file='__reactions_container.tpl' _handle="comment"}
          </div>
        </li>
        <!-- reactions -->

        <!-- comment -->
        {if !$user->_logged_in || $user->_data['can_comment']}
          <li>
            <span class="cursor-pointer transition-colors hover:text-base-content js_reply {if $_comment['comments_disabled']}hidden{/if}" data-username="{if $user->_data['user_name'] != $_comment['author_user_name']}{$_comment['author_user_name']}{/if}">
              {__("Reply")}
            </span>
          </li>
        {/if}
        <!-- comment -->

        <!-- time  -->
        <li>
          <small class="js_moment font-normal text-base-content/45" data-time="{$_comment['time']}">{$_comment['time']}</small>
        </li>
        <!-- time  -->

        <!-- reactions stats -->
        <li class="js_comment-reactions-stats ms-1.25 {if $_comment['reactions_total_count'] == 0}hidden{/if}">
          {include file='__feeds_comment.reactions_stats.tpl'}
        </li>
        <!-- reactions stats -->
      </ul>
      <!-- comment actions & time  -->

      <!-- comment replies  -->
      {if !$_is_reply}
        {if !$standalone && $_comment['replies'] > 0}
          <div class="js_replies-toggle pt-1.5 ps-3.5">
            <span class="inline-flex cursor-pointer items-center gap-1.5 text-xs font-semibold text-base-content/70 transition-colors hover:text-base-content">
              <span class="icon-[tabler--corner-down-right] size-4 rtl:-scale-x-100" aria-hidden="true"></span>
              {$_comment['replies']} {__("Replies")}
            </span>
          </div>
        {/if}
        <div class="comment-replies mt-2 border-s-2 border-base-content/10 ps-3 {if !$standalone}hidden{/if}">
          <!-- previous replies -->
          {if $_comment['replies'] >= $system['min_results']}
            <div class="js_see-more pb-2 text-center text-xs" data-get="comment_replies" data-id="{$_comment['comment_id']}" data-remove="true">
              <span class="inline-flex cursor-pointer items-center gap-1.5 font-semibold text-base-content/70 transition-colors hover:text-base-content">
                <span class="icon-[tabler--message-circle-up] size-4" aria-hidden="true"></span>
                {__("View previous replies")}
              </span>
              <div class="loading loading-spinner loading-sm hidden"></div>
            </div>
          {/if}
          <!-- previous replies -->

          <!-- replies -->
          <ul class="js_replies flex flex-col gap-1">
            {if $_comment['replies'] > 0}
              {foreach $_comment['comment_replies'] as $reply}
                {include file='__feeds_comment.tpl' _comment=$reply _is_reply=true}
              {/foreach}
            {/if}
          </ul>
          <!-- replies -->

          <!-- post a reply -->
          {if $user->_logged_in && $user->_data['can_comment']}
            <div class="hidden js_reply-form">
              {include file='__composer.tpl' _context="reply" _size="sm" _class="comment-form"}
            </div>
          {/if}
          <!-- post a reply -->
        </div>
      {/if}
      <!-- comment replies  -->
    </div>
    <!-- comment body -->
  </div>
</li>
