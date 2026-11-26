<li class="min-w-0 rounded-2xl border border-base-300 bg-base-100 p-4">
  <!-- author -->
  <div class="flex items-start gap-3">
    <a class="avatar shrink-0" href="{$system['system_url']}/{$_review['user_name']}">
      <span class="size-10 rounded-full"><img src="{$_review['user_picture']}" alt="" loading="lazy"></span>
    </a>
    <div class="min-w-0 flex-1">
      <div class="flex flex-wrap items-center gap-1.5">
        <span class="js_user-popover" data-uid="{$_review['user_id']}">
          <a class="font-semibold text-base-content! hover:text-primary!" href="{$system['system_url']}/{$_review['user_name']}">{$_review['user_fullname']}</a>
        </span>
        {if $_review['user_verified']}
          {include file='__badge.tpl' _badge="verified" _badge_type="user" _badge_size=16}
        {/if}
        {if $_review['user_subscribed']}
          {include file='__badge.tpl' _badge="pro" _badge_package=$_review['package_name'] _badge_size=16}
        {/if}
      </div>
      <div class="mt-0.5 flex flex-wrap items-center gap-x-2 gap-y-1">
        <span class="review-stars inline-flex items-center gap-0.5" aria-label="{$_review['rate']} {__("Stars")}">{include file='__stars_rate.tpl' rate=$_review['rate']}</span>
        <time class="js_moment text-xs text-base-content/60" data-time="{$_review['time']}">{$_review['time']}</time>
      </div>
    </div>
  </div>
  <!-- author -->

  <!-- review -->
  {if $_review['review']}
    <p class="mt-3 whitespace-pre-line break-words text-sm leading-relaxed text-base-content/80" dir="auto">{$_review['review']}</p>
  {/if}
  <!-- review -->

  <!-- photos -->
  {if $_review['photos']}
    <div class="mt-3 flex flex-wrap gap-2">
      {foreach $_review['photos'] as $_photo}
        <button type="button" class="js_lightbox-nodata size-20 overflow-hidden rounded-xl" data-image="{$system['system_uploads']}/{$_photo['source']}" aria-label='{__("Photo")}'>
          <img class="size-full object-cover" src="{$system['system_uploads']}/{$_photo['source']}" alt="" loading="lazy">
        </button>
      {/foreach}
    </div>
  {/if}
  <!-- photos -->

  <!-- reply -->
  {if $_review['reply']}
    {if $_review['node_type'] == "page"}
      {assign var="_reply_url" value="`$system['system_url']`/pages/`$_review['page']['page_name']`"}
      {assign var="_reply_picture" value=$_review['page']['page_picture']}
      {assign var="_reply_name" value=$_review['page']['page_title']}
    {elseif $_review['node_type'] == "group"}
      {assign var="_reply_url" value="`$system['system_url']`/groups/`$_review['group']['group_name']`"}
      {assign var="_reply_picture" value=$_review['group']['group_picture']}
      {assign var="_reply_name" value=$_review['group']['group_title']}
    {elseif $_review['node_type'] == "event"}
      {assign var="_reply_url" value="`$system['system_url']`/events/`$_review['event']['event_id']`"}
      {assign var="_reply_picture" value=$_review['event']['event_picture']}
      {assign var="_reply_name" value=$_review['event']['event_title']}
    {else}
      {assign var="_reply_url" value=$_review['post']['post_author_url']}
      {assign var="_reply_picture" value=$_review['post']['post_author_picture']}
      {assign var="_reply_name" value=$_review['post']['post_author_name']}
    {/if}
    <div class="mt-3 flex items-start gap-3 rounded-2xl bg-base-200/60 p-3">
      <a class="avatar shrink-0" href="{$_reply_url}">
        <span class="size-8 rounded-full"><img src="{$_reply_picture}" alt="" loading="lazy"></span>
      </a>
      <div class="min-w-0 text-sm">
        <div class="flex flex-wrap items-center gap-1.5">
          <a class="font-semibold text-base-content! hover:text-primary!" href="{$_reply_url}">{$_reply_name}</a>
          {if $_review['node_type'] == "page" && $_review['page']['page_verified']}
            {include file='__badge.tpl' _badge="verified" _badge_type="page" _badge_size=14}
          {/if}
        </div>
        <p class="mt-1 whitespace-pre-line break-words text-base-content/80" dir="auto">{$_review['reply']}</p>
      </div>
    </div>
  {/if}
  <!-- reply -->

  <!-- actions -->
  {if $_review['manage_review'] && !$_review['reply']}
    <button type="button" class="js_modal heroui button button--tertiary text-base-content button--sm mt-3 rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" data-url="modules/review.php?do=reply&id={$_review['review_id']}">
      <span class="icon-[tabler--message-circle] size-4" aria-hidden="true"></span>
      {__("Reply")}
    </button>
  {/if}
  <!-- actions -->
</li>
