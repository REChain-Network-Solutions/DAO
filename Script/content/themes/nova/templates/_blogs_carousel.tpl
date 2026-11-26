<div class="card overflow-hidden rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-[#F9F9F9] dark:bg-base-300 shadow-none text-sm" data-carousel='{ "loadingClasses": "opacity-0", "isAutoPlay": true, "speed": 13000, "isInfiniteLoop": true, "isRTL": {if $system['language']['dir'] == "RTL"}true{else}false{/if} }'>
  {include file='__card_header.tpl' _card_title=__("Latest Blogs") _card_url="`$system['system_url']`/blogs" _card_arrows=true _card_arrow_class="border-transparent bg-black/5 text-base-content shadow-none hover:bg-black/10 dark:bg-white/10 dark:hover:bg-white/15"}
  <div class="card-body rounded-t-3xl corner-squircle supports-[corner-shape:squircle]:rounded-t-[2.5rem] bg-base-100 p-3">
    <div class="carousel rounded-none bg-transparent">
      <div class="carousel-body peer opacity-0 [&.opacity-0]:absolute [&.opacity-0]:inset-x-0 [&.opacity-0]:top-0">
        {foreach $latest_blogs as $blog}
          <div class="carousel-slide">
            <div class="flex h-full flex-col rounded-[1.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[2.25rem] bg-[#F9F9F9] dark:bg-base-200 p-2">
              <a class="block overflow-hidden rounded-[1.375rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1.875rem] bg-base-200" href="{$system['system_url']}/blogs/{$blog['post_id']}/{$blog['blog']['title_url']}">
                <img class="aspect-[4/3] w-full object-cover" src="{$blog['blog']['parsed_cover']}" alt="{$blog['blog']['title']}" loading="lazy">
              </a>
              <div class="flex grow flex-col px-3 pt-4">
                <div class="flex min-w-0 items-center gap-3 text-xs">
                  {if $blog['blog']['category_id']}
                    <a class="truncate font-medium text-primary! hover:underline" href="{$system['system_url']}/blogs/category/{$blog['blog']['category_id']}/{$blog['blog']['category_url']}" title="{__($blog['blog']['category_name'])}">{__($blog['blog']['category_name'])}</a>
                  {/if}
                  <span class="js_moment shrink-0 text-base-content/50" data-time="{$blog['time']}">{$blog['time']}</span>
                </div>
                <a class="mt-2 line-clamp-2 text-base font-semibold leading-snug text-base-content! hover:text-primary!" href="{$system['system_url']}/blogs/{$blog['post_id']}/{$blog['blog']['title_url']}" title="{$blog['blog']['title']}">{$blog['blog']['title']}</a>
                {if $blog['blog']['text_snippet']}
                  <p class="mt-1.5 line-clamp-2 text-sm text-base-content/65" title="{$blog['blog']['text_snippet']}">{$blog['blog']['text_snippet']|truncate:140}</p>
                {/if}
                <div class="mt-auto flex items-center justify-between gap-3 pb-2 pt-4">
                  <a class="flex min-w-0 items-center gap-2 text-base-content! hover:text-primary!" href="{$blog['post_author_url']}">
                    <img class="size-8 shrink-0 rounded-full object-cover" src="{$blog['post_author_picture']}" alt="" loading="lazy">
                    <span class="js_user-popover truncate text-sm font-medium" data-type="{$blog['user_type']}" data-uid="{$blog['user_id']}" title="{$blog['post_author_name']}">{$blog['post_author_name']}</span>
                    {if $blog['post_author_verified']}
                      {include file='__badge.tpl' _badge="verified" _badge_type=$blog['user_type'] _badge_size=14}
                    {/if}
                  </a>
                  <span class="flex shrink-0 items-center gap-1 text-xs font-medium text-base-content/60" title='{__("Views")}'>
                    <span class="icon-[tabler--eye] size-4" aria-hidden="true"></span>
                    {if $blog['views_formatted']}{$blog['views_formatted']}{else}0{/if}
                  </span>
                </div>
              </div>
            </div>
          </div>
        {/foreach}
      </div>
      {include file='__carousel_skeleton.tpl' _type="card" _media="aspect-[4/3]" _footer="author"}
    </div>
  </div>
</div>
