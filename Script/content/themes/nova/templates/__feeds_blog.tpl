{$_blog_gated = ($blog['needs_payment'] || $blog['needs_subscription'] || $blog['needs_pro_package'] || $blog['needs_age_verification'])}
{$_blog_featured = ($_tpl == "featured" && $_iteration == 1)}
{$_blog_url = "`$system['system_url']`/blogs/`$blog['post_id']`/`$blog['blog']['title_url']`"}
{capture name='blog_badges'}
  {if $_boosted}
    <span class="badge badge-warning badge-sm absolute start-3 top-3 gap-1 rounded-full">
      <span class="icon-[tabler--speakerphone] size-3" aria-hidden="true"></span>
      {__("Promoted")}
    </span>
  {/if}
  {if $blog['still_scheduled']}
    <span class="badge badge-warning badge-sm absolute end-3 top-3 gap-1 rounded-full">
      <span class="icon-[tabler--calendar-time] size-3" aria-hidden="true"></span>
      {__("Scheduled")}
    </span>
  {/if}
{/capture}
{capture name='blog_stats'}
  <span class="flex shrink-0 items-center gap-3">
    {if $blog['comments_formatted']}
      <span class="flex items-center gap-1"><span class="icon-[tabler--message-circle] size-3.5" aria-hidden="true"></span>{$blog['comments_formatted']}</span>
    {/if}
    {if $blog['views_formatted']}
      <span class="flex items-center gap-1"><span class="icon-[tabler--eye] size-3.5" aria-hidden="true"></span>{$blog['views_formatted']}</span>
    {/if}
  </span>
{/capture}
{if $_blog_gated}
<li class="flex min-w-0 flex-col overflow-hidden rounded-box border border-base-300 bg-base-100{if $_blog_featured} col-span-full{/if}">
    <div class="grow">
      {if $blog['needs_payment']}
        {include file='_need_payment.tpl' post_id=$blog['post_id'] price=$blog['post_price'] discounted_price=$blog['post_price_discounted'] paid_text=$blog['paid_text'] paid_image=$blog['paid_image'] _compact=true}
      {elseif $blog['needs_subscription']}
        {include file='_need_subscription.tpl' subscriptions_image=$blog['subscriptions_image'] _compact=true}
      {elseif $blog['needs_pro_package']}
        {include file='_need_pro_package.tpl' _compact=true}
      {else}
        {include file='_need_age_verification.tpl' _compact=true}
      {/if}
    </div>
</li>
{elseif $_blog_featured}
<li class="group relative isolate col-span-full flex min-h-80 min-w-0 flex-col justify-end overflow-hidden rounded-box bg-neutral text-white lg:min-h-[26rem]">
  <img class="absolute inset-0 -z-20 size-full object-cover transition-transform duration-500 group-hover:scale-105" src="{$blog['blog']['parsed_cover']}" alt="" loading="lazy">
  <span class="absolute inset-0 -z-10 bg-linear-to-t from-black/90 via-black/45 to-black/5" aria-hidden="true"></span>
  {$smarty.capture.blog_badges nofilter}
  <div class="flex max-w-3xl flex-col gap-3 p-5 sm:p-8">
    {if $blog['blog']['category_id']}
      <a class="relative z-10 inline-flex h-6 w-fit items-center rounded-full bg-white/15 px-2.5 text-xs font-medium text-white! backdrop-blur-sm hover:bg-white/25" href="{$system['system_url']}/blogs/category/{$blog['blog']['category_id']}/{$blog['blog']['category_url']}">{__($blog['blog']['category_name'])}</a>
    {/if}
    <a class="line-clamp-3 text-2xl leading-tight font-bold tracking-tight text-white! after:absolute after:inset-0 sm:text-3xl" href="{$_blog_url}" title="{$blog['blog']['title']}">{$blog['blog']['title']}</a>
    {if $blog['blog']['text_snippet']}
      <p class="line-clamp-2 text-sm leading-relaxed text-white/75 sm:text-base">{$blog['blog']['text_snippet']|truncate:280}</p>
    {/if}
    <div class="mt-1 flex min-w-0 items-center gap-3 text-xs text-white/70">
      <a class="relative z-10 flex min-w-0 grow items-center gap-2.5 text-white!" href="{$blog['post_author_url']}">
        <img class="size-9 shrink-0 rounded-full object-cover ring-2 ring-white/40" src="{$blog['post_author_picture']}" alt="" loading="lazy">
        <span class="min-w-0">
          <span class="js_user-popover block truncate text-sm font-semibold" data-type="{$blog['user_type']}" data-uid="{$blog['user_id']}" title="{$blog['post_author_name']}">{$blog['post_author_name']}</span>
          <span class="js_moment block truncate text-white/65" data-time="{$blog['time']}">{$blog['time']}</span>
        </span>
      </a>
      {$smarty.capture.blog_stats nofilter}
    </div>
  </div>
</li>
{else}
<li class="group relative flex min-w-0 flex-col overflow-hidden rounded-box bg-base-100 shadow-sm transition duration-300 hover:-translate-y-1 hover:shadow-lg">
  <div class="relative aspect-[16/10] overflow-hidden bg-base-200">
    <img class="size-full object-cover transition-transform duration-500 group-hover:scale-105" src="{$blog['blog']['parsed_cover']}" alt="" loading="lazy">
    {$smarty.capture.blog_badges nofilter}
    {if $blog['blog']['category_id']}
      <a class="absolute start-3 bottom-3 z-10 inline-flex h-6 items-center rounded-full bg-base-100/90 px-2.5 text-xs font-medium text-base-content! backdrop-blur-sm hover:bg-base-100" href="{$system['system_url']}/blogs/category/{$blog['blog']['category_id']}/{$blog['blog']['category_url']}">{__($blog['blog']['category_name'])}</a>
    {/if}
  </div>
  <div class="flex grow flex-col gap-2 p-4 sm:p-5">
    <a class="line-clamp-2 text-lg leading-snug font-bold tracking-tight text-base-content! after:absolute after:inset-0 group-hover:text-primary!" href="{$_blog_url}" title="{$blog['blog']['title']}">{$blog['blog']['title']}</a>
    {if $blog['blog']['text_snippet']}
      <p class="line-clamp-2 text-sm leading-relaxed text-base-content/65">{$blog['blog']['text_snippet']|truncate:140}</p>
    {/if}
    <div class="mt-auto flex min-w-0 items-center gap-3 pt-2 text-xs text-base-content/60">
      <a class="relative z-10 flex min-w-0 grow items-center gap-2 text-base-content/80! hover:text-primary!" href="{$blog['post_author_url']}">
        <img class="size-7 shrink-0 rounded-full object-cover" src="{$blog['post_author_picture']}" alt="" loading="lazy">
        <span class="js_user-popover min-w-0 truncate font-medium" data-type="{$blog['user_type']}" data-uid="{$blog['user_id']}" title="{$blog['post_author_name']}">{$blog['post_author_name']}</span>
        <span class="js_moment shrink-0 text-base-content/50" data-time="{$blog['time']}">{$blog['time']}</span>
      </a>
      {$smarty.capture.blog_stats nofilter}
    </div>
  </div>
</li>
{/if}
