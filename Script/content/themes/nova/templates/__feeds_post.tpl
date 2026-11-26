{if !$standalone}<li>{/if}
  <!-- post -->
  {if $post['source'] == "popular"}
    <div class="mb-2 flex items-center gap-1.5 text-xs font-medium text-base-content/55">
      <span class="icon-[tabler--flame] size-4 text-accent" aria-hidden="true"></span>{__("Popular")}
    </div>
  {else if $post['source'] == "discover"}
    <div class="mb-2 flex items-center gap-1.5 text-xs font-medium text-base-content/55">
      <span class="icon-[tabler--sparkles] size-4 text-primary" aria-hidden="true"></span>{__("Suggested for you")}
    </div>
  {/if}
  <article class="post relative [&_.post-text_h1]:text-xl [&_.post-text_h1]:leading-7 [&_.post-text_h1]:font-bold [&_.post-text_h2]:text-lg [&_.post-text_h2]:leading-7 [&_.post-text_h2]:font-semibold [&_.post-text_ul]:list-disc [&_.post-text_ol]:list-decimal [&_.post-text_ol_ol]:list-[lower-alpha] [&_.post-text_ol_ol_ol]:list-[lower-roman] [&_.post-text_ul]:ps-[1.5em] [&_.post-text_ol]:ps-[1.5em] [&_.post-text_li_ul]:ps-[3em] [&_.post-text_li_ol]:ps-[3em] {if $boosted}rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem]{else}rounded-box{/if} bg-base-100 text-base-content shadow-surface dark:shadow-none
                {if $_get == "posts_profile" && $user->_data['user_id'] == $post['author_id'] && ($post['is_hidden'] || $post['is_anonymous'])}is_hidden{/if}
                {if $boosted}boosted border border-transparent [background:linear-gradient(var(--color-base-100),var(--color-base-100))_padding-box,linear-gradient(135deg,var(--color-primary),var(--color-accent))_border-box]{/if}
                {if ($post['still_scheduled']) OR ($post['is_pending']) OR ($post['in_group'] && !$post['group_approved']) OR ($post['in_event'] && !$post['event_approved'])}pending ring-1 ring-dashed ring-base-content/35{/if}" data-id="{$post['post_id']}" {if $post['still_scheduled']}data-schedule="true" {/if}>

    {if ($post['is_pending']) OR ($post['in_group'] && !$post['group_approved']) OR ($post['in_event'] && !$post['event_approved'])}
      <div class="pending-icon absolute end-4 top-0 z-10 inline-flex -translate-y-1/2 items-center gap-1 rounded-full bg-warning px-2.5 py-1 text-xs font-semibold text-warning-content shadow-sm" title="{__("Pending Post")}">
        <span class="icon-[tabler--clock] size-3.5" aria-hidden="true"></span>{__("Pending")}
      </div>
    {/if}

    {if $post['still_scheduled']}
      <div class="pending-icon absolute end-4 top-0 z-10 inline-flex -translate-y-1/2 items-center gap-1 rounded-full bg-warning px-2.5 py-1 text-xs font-semibold text-warning-content shadow-sm" title="{__("Scheduled Post")}">
        <span class="icon-[tabler--calendar-time] size-3.5" aria-hidden="true"></span>{__("Scheduled")}
      </div>
    {/if}

    {if $standalone && $pinned}
      <div class="pin-icon absolute end-4 top-0 z-10 inline-flex -translate-y-1/2 items-center gap-1 rounded-full bg-warning px-2.5 py-1 text-xs font-semibold text-warning-content shadow-sm" title="{__("Pinned Post")}">
        <span class="icon-[tabler--bookmark-filled] size-3.5" aria-hidden="true"></span>{__("Pinned")}
      </div>
    {/if}

    {if $standalone && $boosted && !$_carousel}
      <div class="boosted-icon absolute end-4 top-0 z-10 inline-flex -translate-y-1/2 items-center gap-1 rounded-full bg-warning px-2.5 py-1 text-xs font-semibold text-warning-content shadow-sm" title="{__("Promoted")}">
        <span class="icon-[tabler--speakerphone] size-3.5" aria-hidden="true"></span>{__("Promoted")}
      </div>
    {/if}

    <!-- memory post -->
    {if $_get == "memories"}
      <div class="post-memory-header flex items-center gap-3 border-b border-base-300 px-4 py-3">
        <span class="flex size-11 shrink-0 items-center justify-center rounded-full bg-info/10 text-info">
          <span class="icon-[tabler--history] size-5.5" aria-hidden="true"></span>
        </span>
        <div class="min-w-0 grow">
          <div class="text-xs font-medium text-base-content/60">{__("On This Day")}</div>
          <div class="js_moment text-lg leading-tight font-bold first-letter:uppercase" data-time="{$post['time']}">{$post['time']}</div>
        </div>
        <time class="flex shrink-0 items-center gap-1.5 rounded-full bg-base-200 px-3 py-1.5 text-xs font-medium text-base-content/70" datetime="{$post['time']|date_format:'%Y-%m-%d'}">
          <span class="icon-[tabler--calendar] size-4" aria-hidden="true"></span>{$post['time']|date_format:"%e"} {__($post['time']|date_format:"%b")} {$post['time']|date_format:"%Y"}
        </time>
      </div>
    {/if}
    <!-- memory post -->

    <!-- post body -->
    <div class="post-body min-w-0">

      <!-- post top alert -->
      {if $_get == "posts_profile" && $user->_data['user_id'] == $post['author_id'] && ($post['is_hidden'] || $post['is_anonymous'])}
        <div class="post-top-alert rounded-t-box bg-base-content/80 px-4 py-2.5 text-center text-sm font-medium text-base-100">{__("Only you can see this post")}</div>
      {/if}
      <!-- post top alert -->

      {if $post['is_collaborative'] && ($post['i_collaborative'] || ($post['is_paid'] && $post['author_id'] == $user->_data['user_id']))}
        <div class="post-collaborative-alert flex items-center justify-center gap-2 rounded-t-box bg-primary/10 px-4 py-3 text-center text-xs text-primary">
          <span class="icon-[tabler--info-circle] size-4 shrink-0" aria-hidden="true"></span>
          {if $post['i_collaborative']}
            {__("You are collaborating on this post")} {if $post['is_paid']} & {/if}
          {/if}
          {if $post['is_paid']}
            {__("Collaborators will receive")} {$post['collaborative_percent']}% {__("of the revenue")}
          {/if}
        </div>
      {/if}

      {include file='__feeds_post.body.tpl' _post=$post _shared=false}

      {if $post['can_get_details'] && !$post['needs_pro_package'] && !$post['needs_permission'] }
        <!-- post stats -->
        <div class="post-stats flex flex-wrap items-center gap-x-4 gap-y-2 px-4 pt-3 pb-2.5 text-[0.8125rem] leading-5 text-base-content/60">
          <!-- reactions stats -->
          {include file='__feeds_post.reactions_stats.tpl'}
          <!-- reactions stats -->

          <!-- comments & shares & views & plays & donations -->
          <div class="ms-auto flex flex-wrap items-center justify-end gap-x-4 gap-y-1">
            <!-- comments -->
            <button type="button" class="js_comments-toggle items-center gap-1.5 -mx-2 -my-1 cursor-pointer rounded-full px-2 py-1 transition-colors hover:bg-base-200 hover:text-base-content focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary {if $post['comments'] == 0}hidden{else}inline-flex{/if}" title="{__("Comments")}">
              <span class="icon-[tabler--message-circle] size-4" aria-hidden="true"></span>{$post['comments_formatted']}<span class="sr-only"> {__("Comments")}</span>
            </button>
            <!-- comments -->

            <!-- shares -->
            <button type="button" class="js_modal items-center gap-1.5 -mx-2 -my-1 cursor-pointer rounded-full px-2 py-1 transition-colors hover:bg-base-200 hover:text-base-content focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary {if $post['shares'] == 0}hidden{else}inline-flex{/if}" data-url="posts/who_shares.php?post_id={$post['post_id']}" title="{__("Shares")}">
              <span class="icon-[tabler--share-3] size-4" aria-hidden="true"></span>{$post['shares_formatted']}<span class="sr-only"> {__("Shares")}</span>
            </button>
            <!-- shares -->

            <!-- donations -->
            {if $post['post_type'] == "funding"}
              <button type="button" class="js_modal inline-flex items-center gap-1.5 -mx-2 -my-1 cursor-pointer rounded-full px-2 py-1 transition-colors hover:bg-base-200 hover:text-base-content focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary" data-url="posts/who_donates.php?post_id={$post['post_id']}" title="{__("Donations")}">
              <span class="icon-[tabler--heart-handshake] size-4" aria-hidden="true"></span>{$post['funding']['total_donations']}<span class="sr-only"> {__("Donations")}</span>
            </button>
            {/if}
            <!-- donations -->

            <!-- reviews -->
            {if $system['posts_reviews_enabled'] && $post['reviews_count'] > 0}
              <button type="button" class="js_modal inline-flex items-center gap-1.5 -mx-2 -my-1 cursor-pointer rounded-full px-2 py-1 transition-colors hover:bg-base-200 hover:text-base-content focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary" data-url="posts/who_reviews.php?post_id={$post['post_id']}" title="{__("Reviews")}">
              <span class="icon-[tabler--star] size-4" aria-hidden="true"></span>{$post['reviews_count_formatted']}<span class="sr-only"> {__("Reviews")}</span>
            </button>
            {/if}
            <!-- reviews -->

            <!-- plays -->
            {if $post['post_type'] == "video"}
              <span class="inline-flex items-center gap-1.5" title="{__("Views")}">
                <span class="icon-[tabler--player-play] size-4" aria-hidden="true"></span>{$post['video']['views']}<span class="sr-only"> {__("Views")}</span>
              </span>
            {elseif $post['post_type'] == "shared" && $post['origin']['post_type'] == "video"}
              <span class="inline-flex items-center gap-1.5" title="{__("Views")}">
                <span class="icon-[tabler--player-play] size-4" aria-hidden="true"></span>{$post['origin']['video']['views']}<span class="sr-only"> {__("Views")}</span>
              </span>
            {elseif $post['post_type'] == "audio"}
              <span class="inline-flex items-center gap-1.5" title="{__("Views")}">
                <span class="icon-[tabler--headphones] size-4" aria-hidden="true"></span>{$post['audio']['views']}<span class="sr-only"> {__("Views")}</span>
              </span>
            {elseif $post['post_type'] == "shared" && $post['origin']['post_type'] == "audio"}
              <span class="inline-flex items-center gap-1.5" title="{__("Views")}">
                <span class="icon-[tabler--headphones] size-4" aria-hidden="true"></span>{$post['origin']['audio']['views']}<span class="sr-only"> {__("Views")}</span>
              </span>
            {/if}
            <!-- plays -->

            <!-- views -->
            {if $system['posts_views_enabled']}
              <span class="inline-flex items-center gap-1.5" title="{__("Views")}">
                <span class="icon-[tabler--eye] size-4" aria-hidden="true"></span>{$post['views_formatted']}<span class="sr-only"> {__("Views")}</span>
              </span>
            {/if}
            <!-- views -->
          </div>
          <!-- comments & shares & views & plays & donations -->
        </div>
        <!-- post stats -->

        <!-- post actions -->
        {if $user->_logged_in && $_get != "posts_information"}
          <div class="post-actions mx-4 flex items-center gap-1 border-t border-base-content/10 py-1.5">
            <!-- reactions -->
            <div class="group/action action-btn unselectable reactions-wrapper flex h-10 min-w-0 flex-1 cursor-pointer items-center justify-center rounded-field px-2 text-sm font-medium text-base-content/70 transition-colors duration-200 hover:bg-primary/5 hover:text-primary {if $post['i_react']}js_unreact-post{/if}" data-reaction="{$post['i_reaction']}">
              <!-- reaction-btn -->
              <div class="reaction-btn flex items-center justify-center transition-transform duration-150 group-active/action:scale-95">
                {if !$post['i_react']}
                  <div class="reaction-btn-icon inline-flex transition-transform duration-200 ease-out group-hover/action:-rotate-6 group-hover/action:scale-110">
                    <span class="icon-[tabler--mood-smile] size-5" aria-hidden="true"></span>
                  </div>
                  <span class="reaction-btn-name ms-2 hidden sm:inline">{__("React")}</span>
                {else}
                  <div class="reaction-btn-icon inline-flex transition-transform duration-200 ease-out group-hover/action:-rotate-6 group-hover/action:scale-110">
                    <div class="inline-emoji no_animation inline-flex size-5">
                      {include file='__reaction_emojis.tpl' _reaction=$post['i_reaction']}
                    </div>
                  </div>
                  <span class="reaction-btn-name ms-2 hidden sm:inline" style="color: {$system['reactions'][$post['i_reaction']]['color']};">{__($system['reactions'][$post['i_reaction']]['title'])}</span>
                {/if}
              </div>
              <!-- reaction-btn -->

              {include file='__reactions_container.tpl' _handle="post"}
            </div>
            <!-- reactions -->

            <!-- comment -->
            <button type="button" class="group/action action-btn js_comment flex h-10 min-w-0 flex-1 cursor-pointer items-center justify-center gap-2 rounded-field px-2 text-sm font-medium text-base-content/70 transition-colors duration-200 hover:bg-primary/5 hover:text-primary active:scale-[0.97] {if $post['comments_disabled']}hidden{/if}">
              <span class="icon-[tabler--message-circle] size-5 shrink-0 transition-transform duration-200 ease-out group-hover/action:-rotate-6 group-hover/action:scale-110" aria-hidden="true"></span>
              <span class="hidden sm:inline">{__("Comment")}</span>
            </button>
            <!-- comment -->

            <!-- share -->
            {if !$post['still_scheduled'] && ($post['privacy'] == "public" || ($post['in_group'] && $post['group_privacy'] == "public") || ($post['in_event'] && $post['event_privacy'] == "public")) }
              <button type="button" class="js_modal group/action action-btn flex h-10 min-w-0 flex-1 cursor-pointer items-center justify-center gap-2 rounded-field px-2 text-sm font-medium text-base-content/70 transition-colors duration-200 hover:bg-primary/5 hover:text-primary active:scale-[0.97]" data-url="posts/share.php?do=create&post_id={$post['post_id']}">
                <span class="icon-[tabler--share-3] size-5 shrink-0 transition-transform duration-200 ease-out group-hover/action:-rotate-6 group-hover/action:scale-110" aria-hidden="true"></span>
                <span class="hidden sm:inline">{__("Share")}</span>
              </button>
            {/if}
            <!-- share -->

            <!-- review -->
            {if $post['author_id'] != $user->_data['user_id'] && $system['posts_reviews_enabled']}
              <button type="button" class="js_modal group/action action-btn flex h-10 min-w-0 flex-1 cursor-pointer items-center justify-center gap-2 rounded-field px-2 text-sm font-medium text-base-content/70 transition-colors duration-200 hover:bg-primary/5 hover:text-primary active:scale-[0.97]" data-url="modules/review.php?do=review&id={$post['post_id']}&type=post">
                <span class="icon-[tabler--star] size-5 shrink-0 transition-transform duration-200 ease-out group-hover/action:-rotate-6 group-hover/action:scale-110" aria-hidden="true"></span>
                <span class="hidden sm:inline">{__("Review")}</span>
              </button>
            {/if}
            <!-- review -->

            <!-- tips -->
            {if $post['author_id'] != $user->_data['user_id'] && $post['tips_enabled']}
              <button type="button" class="js_modal group/action action-btn flex h-10 min-w-0 flex-1 cursor-pointer items-center justify-center gap-2 rounded-field px-2 text-sm font-medium text-base-content/70 transition-colors duration-200 hover:bg-primary/5 hover:text-primary active:scale-[0.97]" data-url="#send-tip" data-options='{ "id": "{$post['author_id']}"}'>
                <span class="icon-[tabler--coin] size-5 shrink-0 transition-transform duration-200 ease-out group-hover/action:-rotate-6 group-hover/action:scale-110" aria-hidden="true"></span>
                <span class="hidden sm:inline">{__("Tip")}</span>
              </button>
            {/if}
            <!-- tips -->
          </div>
        {/if}
        <!-- post actions -->
      {/if}

    </div>
    <!-- post body -->

    <!-- post footer -->
    {if $post['can_get_details'] && !$post['needs_pro_package'] && !$post['needs_permission']}
      <div class="post-footer rounded-b-box border-t border-base-content/10 px-4 {if $user->_logged_in && (!$standalone || ($page != "post" && ($post['boosted'] || $pinned)))}hidden{/if}">
        <!-- comments -->
        {include file='__feeds_post.comments.tpl'}
        <!-- comments -->
      </div>
    {/if}
    <!-- post footer -->

    <!-- post approval -->
    {if ($post['in_group'] && $post['is_group_admin'] &&!$post['group_approved']) OR ($post['in_event'] && $post['is_event_admin'] &&!$post['event_approved']) }
      <div class="post-approval flex justify-end gap-2 rounded-b-box border-t border-base-300 bg-base-200/55 p-4">
        <button class="heroui button button--primary [--button-bg:var(--success)] [--button-bg-hover:var(--success-hover)] [--button-bg-pressed:var(--success-hover)] [--button-fg:var(--success-foreground)] button--sm me-1.25 js_approve-post"><span class="icon-[tabler--check] size-4 me-1.25" aria-hidden="true"></span>{__("Approve")}</button>
        <button class="heroui button button--danger button--sm js_delete-post"><span class="icon-[tabler--x] size-4 me-1.25" aria-hidden="true"></span>{__("Decline")}</button>
      </div>
    {/if}
    <!-- post approval -->

  </article>
  <!-- post -->
  {if !$standalone}
  </li>
{/if}
