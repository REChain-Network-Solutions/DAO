{if $_viewer_type == "photo"}
  {$_viewer_reacted = $photo['i_react']}
  {$_viewer_reaction = $photo['i_reaction']}
  {$_viewer_comments = $photo['comments_formatted']}
  {$_viewer_handle = ($photo['is_single']) ? "post" : "photo"}
{else}
  {$_viewer_reacted = $post['i_react']}
  {$_viewer_reaction = $post['i_reaction']}
  {$_viewer_comments = $post['comments_formatted']}
  {$_viewer_handle = "post"}
{/if}

<!-- post body -->
<div class="post-body min-w-0 bg-base-100 [&_.post-text_h1]:text-xl [&_.post-text_h1]:leading-7 [&_.post-text_h1]:font-bold [&_.post-text_h2]:text-lg [&_.post-text_h2]:leading-7 [&_.post-text_h2]:font-semibold [&_.post-text_ul]:list-disc [&_.post-text_ol]:list-decimal [&_.post-text_ol_ol]:list-[lower-alpha] [&_.post-text_ol_ol_ol]:list-[lower-roman] [&_.post-text_ul]:ps-[1.5em] [&_.post-text_ol]:ps-[1.5em] [&_.post-text_li_ul]:ps-[3em] [&_.post-text_li_ol]:ps-[3em]">
  <!-- post header -->
  <div class="post-header flex items-start gap-3 px-4 pt-4 pb-3 pe-12">
    <div class="post-avatar relative shrink-0">
      {if $post['is_anonymous']}
        <div class="post-avatar-anonymous flex size-11 items-center justify-center rounded-full bg-base-200 text-base-content/60">
          {include file='__svg_icons.tpl' icon="spy" class="main-icon" width="22px" height="22px"}
        </div>
      {else}
        <a class="post-avatar-picture block size-11 rounded-full bg-base-200 bg-cover bg-center ring-1 ring-base-content/5" href="{$post['post_author_url']}" style="background-image:url({$post['post_author_picture']});" aria-label="{$post['post_author_name']}"></a>
        {if $post['post_author_online']}<span class="online-dot absolute end-0 bottom-0 size-3 rounded-full bg-success ring-2 ring-base-100" title="{__("Online")}"></span>{/if}
      {/if}
    </div>
    <div class="post-meta min-w-0 flex-1 pt-0.5">
      <div class="flex flex-wrap items-center gap-1">
        {if $post['is_anonymous']}
          <span class="post-author text-sm font-semibold">{__("Anonymous")}</span>
        {else}
          <span class="js_user-popover min-w-0" data-type="{$post['user_type']}" data-uid="{$post['user_id']}">
            <a class="post-author block truncate text-sm font-semibold text-base-content! hover:text-primary!" href="{$post['post_author_url']}" title="{$post['post_author_name']}">{$post['post_author_name']}</a>
          </span>
          {if $post['post_author_verified']}
            {include file='__badge.tpl' _badge="verified" _badge_type=$post['user_type']}
          {/if}
          {if $post['user_subscribed']}
            {include file='__badge.tpl' _badge="pro" _badge_package=$post['package_name']}
          {/if}
        {/if}
      </div>
      <div class="post-time mt-0.5 flex flex-wrap items-center gap-1.5 text-xs text-base-content/50">
        <a class="text-base-content/50! hover:text-primary!" href="{$system['system_url']}/posts/{$post['post_id']}"><span class="js_moment" data-time="{$post['time']}">{$post['time']}</span></a>
        {if $post['location']}<span aria-hidden="true">·</span><span class="truncate" title="{$post['location']}">{$post['location']}</span>{/if}
        <span aria-hidden="true">·</span>
        {if $post['privacy'] == "me"}
          <span class="icon-[tabler--lock] size-3.5" title='{__("Only Me")}' aria-hidden="true"></span>
        {elseif $post['privacy'] == "friends"}
          <span class="icon-[tabler--users] size-3.5" title='{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}' aria-hidden="true"></span>
        {elseif $post['privacy'] == "public"}
          <span class="icon-[tabler--world] size-3.5" title='{__("Public")}' aria-hidden="true"></span>
        {else}
          <span class="icon-[tabler--settings] size-3.5" title='{__("Custom People")}' aria-hidden="true"></span>
        {/if}
      </div>
    </div>
  </div>
  <!-- post header -->

  {if $_viewer_type == "video" && !is_empty($post['text'])}
    <div class="post-text js_readmore px-4 pb-2 text-start text-[0.9375rem] leading-6 wrap-break-word" dir="auto">{$post['text']}</div>
  {/if}

  {if $_viewer_type == "photo" && !$_lightbox}
    <div class="overflow-hidden bg-base-200 {if $photo['blur']}x-blured{/if}">
      <a href="{$system['system_url']}/photos/{$photo['photo_id']}" class="js_lightbox flex max-h-[42rem] items-center justify-center {if $photo['blur']}blur-md{/if}" data-id="{$photo['photo_id']}" data-image="{$system['system_uploads']}/{$photo['source']}" data-context="{if $photo['is_single']}album{else}post{/if}">
        <img class="max-h-[42rem] w-full object-contain" src="{$system['system_uploads']}/{$photo['source']}" alt="">
      </a>
    </div>
  {/if}

  <!-- post stats -->
  <div class="post-stats flex flex-wrap items-center gap-x-4 gap-y-2 px-4 pt-3 pb-2.5 text-[0.8125rem] leading-5 text-base-content/60">
    {include file='__feeds_post.reactions_stats.tpl'}
    <div class="ms-auto flex flex-wrap items-center justify-end gap-x-4 gap-y-1">
      <button type="button" class="js_comments-toggle inline-flex items-center gap-1.5 -mx-2 -my-1 cursor-pointer rounded-full px-2 py-1 transition-colors hover:bg-base-200 hover:text-base-content focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary" title="{__("Comments")}"><span class="icon-[tabler--message-circle] size-4" aria-hidden="true"></span>{$_viewer_comments}<span class="sr-only"> {__("Comments")}</span></button>
      {if $post['shares'] > 0}<button type="button" class="js_modal inline-flex items-center gap-1.5 -mx-2 -my-1 cursor-pointer rounded-full px-2 py-1 transition-colors hover:bg-base-200 hover:text-base-content focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary" data-url="posts/who_shares.php?post_id={$post['post_id']}" title="{__("Shares")}"><span class="icon-[tabler--share-3] size-4" aria-hidden="true"></span>{$post['shares_formatted']}<span class="sr-only"> {__("Shares")}</span></button>{/if}
    </div>
  </div>
  <!-- post stats -->

  {if $user->_logged_in}
    <!-- post actions -->
    <div class="post-actions mx-4 flex items-center gap-1 border-t border-base-content/10 py-1.5">
      <div class="group/action action-btn unselectable reactions-wrapper flex h-10 min-w-0 flex-1 cursor-pointer items-center justify-center rounded-field px-2 text-sm font-medium text-base-content/70 transition-colors duration-200 hover:bg-primary/5 hover:text-primary {if $_viewer_reacted}js_unreact-{$_viewer_handle}{/if}" data-reaction="{$_viewer_reaction}">
        <div class="reaction-btn flex items-center justify-center transition-transform duration-150 group-active/action:scale-95">
          {if !$_viewer_reacted}
            <div class="reaction-btn-icon inline-flex transition-transform duration-200 ease-out group-hover/action:-rotate-6 group-hover/action:scale-110"><span class="icon-[tabler--mood-smile] size-5" aria-hidden="true"></span></div>
            <span class="reaction-btn-name ms-2 hidden sm:inline">{__("React")}</span>
          {else}
            <div class="reaction-btn-icon inline-flex size-5 transition-transform duration-200 ease-out group-hover/action:-rotate-6 group-hover/action:scale-110"><div class="inline-emoji no_animation inline-flex size-5">{include file='__reaction_emojis.tpl' _reaction=$_viewer_reaction}</div></div>
            <span class="reaction-btn-name ms-2 hidden sm:inline" style="color: {$system['reactions'][$_viewer_reaction]['color']};">{__($system['reactions'][$_viewer_reaction]['title'])}</span>
          {/if}
        </div>
        {include file='__reactions_container.tpl' _handle=$_viewer_handle}
      </div>
      <button type="button" class="group/action action-btn js_comment flex h-10 min-w-0 flex-1 cursor-pointer items-center justify-center gap-2 rounded-field px-2 text-sm font-medium text-base-content/70 transition-colors duration-200 hover:bg-primary/5 hover:text-primary active:scale-[0.97] {if $post['comments_disabled']}hidden{/if}">
        <span class="icon-[tabler--message-circle] size-5 shrink-0 transition-transform duration-200 ease-out group-hover/action:-rotate-6 group-hover/action:scale-110" aria-hidden="true"></span><span class="hidden sm:inline">{__("Comment")}</span>
      </button>
      {if $post['privacy'] == "public"}
        <button type="button" class="js_modal group/action action-btn flex h-10 min-w-0 flex-1 cursor-pointer items-center justify-center gap-2 rounded-field px-2 text-sm font-medium text-base-content/70 transition-colors duration-200 hover:bg-primary/5 hover:text-primary active:scale-[0.97]" data-url="posts/share.php?do=create&post_id={$post['post_id']}{if $_viewer_type == "photo"}&photo_id={$photo['photo_id']}{/if}">
          <span class="icon-[tabler--share-3] size-5 shrink-0 transition-transform duration-200 ease-out group-hover/action:-rotate-6 group-hover/action:scale-110" aria-hidden="true"></span><span class="hidden sm:inline">{__("Share")}</span>
        </button>
      {/if}
    </div>
    <!-- post actions -->

    {if $_viewer_type != "photo" && $post['author_id'] != $user->_data['user_id'] && $post['tips_enabled']}
      <!-- post tips -->
      <div class="post-tips mx-4 border-t border-base-content/10 py-3">
        <div class="mb-2.5 flex items-center justify-between gap-2">
          <span class="flex min-w-0 items-center gap-2 text-sm font-semibold">
            <span class="inline-flex size-7 shrink-0 items-center justify-center rounded-full bg-warning/15 text-warning" aria-hidden="true"><span class="icon-[tabler--coin] size-4"></span></span>
            {__("Send a Tip")}
          </span>
          <button type="button" class="js_modal heroui button button--ghost button--sm shrink-0" data-url="#send-tip" data-options='{ "id": "{$post['author_id']}"}'>
            <span class="icon-[tabler--pencil-dollar] size-4" aria-hidden="true"></span>
            {__("Custom")}
          </button>
        </div>
        <div class="grid grid-cols-3 gap-2">
          {foreach [1, 5, 10, 20, 50, 100] as $_tip_value}
            <button type="button" class="js_modal heroui button button--tertiary button--sm w-full font-semibold tabular-nums" data-url="#send-tip" data-options='{ "id": "{$post['author_id']}", "value": "{$_tip_value}"}'>{print_money($_tip_value)}</button>
          {/foreach}
        </div>
      </div>
      <!-- post tips -->
    {/if}
  {/if}
</div>
<!-- post body -->

<!-- post footer -->
<div class="post-footer border-t border-base-content/10 px-4">
  {if $_viewer_type == "photo"}
    {include file='__feeds_post.comments.tpl' _is_photo=(!$photo['is_single'])?true:false}
  {elseif $_viewer_type == "live"}
    {include file='__feeds_post.comments.tpl' _live_comments=true}
  {else}
    {include file='__feeds_post.comments.tpl'}
  {/if}
</div>
<!-- post footer -->
