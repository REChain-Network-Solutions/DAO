<li class="group flex min-w-0 flex-col overflow-hidden rounded-box border border-base-300 bg-base-100 transition-shadow hover:shadow-md">
  {if $post['needs_subscription']}
    <a class="block" href="{$system['system_url']}/posts/{$post['post_id']}">
      {include file='_need_subscription.tpl' _compact=true}
    </a>
  {else}
    <a class="relative block aspect-[4/3] overflow-hidden bg-base-200" href="{$system['system_url']}/posts/{$post['post_id']}" aria-label="{$post['product']['name']}">
      {if $post['photos_num'] > 0}
        <img class="size-full object-cover transition-transform duration-500 group-hover:scale-105" src="{$system['system_uploads']}/{$post['photos'][0]['source']}" alt="" loading="lazy">
      {else}
        <img class="size-full object-cover" src="{$system['system_url']}/content/themes/{$system['theme']}/images/blank/blank_product.png" alt="" loading="lazy">
      {/if}
      {if $_boosted}
        <span class="badge badge-warning badge-sm absolute start-3 top-3 gap-1 rounded-full">
          <span class="icon-[tabler--speakerphone] size-3" aria-hidden="true"></span>
          {__("Promoted")}
        </span>
      {/if}
      <span class="absolute bottom-3 start-3 rounded-full bg-base-100/95 px-3 py-1 text-sm font-bold text-base-content shadow-sm backdrop-blur-sm">
        {if $post['product']['price'] > 0}{$post['product']['price_formatted']}{else}{__("Free")}{/if}
      </span>
    </a>

    <div class="flex grow flex-col gap-2 p-4">
      <div class="flex flex-wrap gap-1.5">
        {if $post['product']['is_digital']}
          <span class="badge badge-soft badge-primary badge-sm rounded-full">{__("Digital")}</span>
        {/if}
        {if $post['product']['status'] == "new"}
          <span class="badge badge-soft badge-info badge-sm rounded-full">{__("New")}</span>
        {else}
          <span class="badge badge-soft badge-sm rounded-full">{__("Used")}</span>
        {/if}
        {if $post['product']['available'] && $post['product']['quantity'] > 0}
          <span class="badge badge-soft badge-success badge-sm gap-1.5 rounded-full"><span class="size-1.5 rounded-full bg-current" aria-hidden="true"></span>{__("In stock")}</span>
        {elseif $post['product']['available']}
          <span class="badge badge-soft badge-error badge-sm gap-1.5 rounded-full"><span class="size-1.5 rounded-full bg-current" aria-hidden="true"></span>{__("Out of stock")}</span>
        {else}
          <span class="badge badge-soft badge-error badge-sm gap-1.5 rounded-full"><span class="size-1.5 rounded-full bg-current" aria-hidden="true"></span>{__("SOLD")}</span>
        {/if}
      </div>

      <a class="line-clamp-2 font-semibold leading-snug text-base-content! hover:text-primary!" href="{$system['system_url']}/posts/{$post['post_id']}" title="{$post['product']['name']}">{$post['product']['name']}</a>

      <div class="flex flex-col gap-1 text-xs text-base-content/60">
        <span class="flex min-w-0 items-center gap-1.5">
          <span class="icon-[tabler--map-pin] size-3.5 shrink-0" aria-hidden="true"></span>
          <span class="truncate" title="{if $post['product']['location']}{$post['product']['location']}{else}{__("N/A")}{/if}">{if $post['product']['location']}{$post['product']['location']}{else}{__("N/A")}{/if}</span>
        </span>
        {if $system['posts_reviews_enabled']}
          <span class="flex items-center gap-1.5">
            <span class="icon-[tabler--star-filled] size-3.5 shrink-0 text-warning" aria-hidden="true"></span>
            {if $post['post_rate']}<span class="font-semibold text-base-content">{$post['post_rate']|number_format:1}</span> ·{/if}
            {$post['reviews_count']} {__("Reviews")}
          </span>
        {/if}
      </div>

      <div class="mt-auto flex min-w-0 items-center gap-3 border-t border-base-300 pt-3 text-xs text-base-content/60">
        <a class="flex min-w-0 grow items-center gap-2 text-base-content/80! hover:text-primary!" href="{$post['post_author_url']}">
          <img class="size-8 shrink-0 rounded-full object-cover" src="{$post['post_author_picture']}" alt="" loading="lazy">
          <span class="min-w-0">
            <span class="js_user-popover block truncate font-medium" data-type="{$post['user_type']}" data-uid="{$post['user_id']}" title="{$post['post_author_name']}">{$post['post_author_name']}</span>
            <span class="js_moment block truncate text-base-content/50" data-time="{$post['time']}">{$post['time']}</span>
          </span>
        </a>
        <a class="heroui button button--tertiary text-base-content button--sm button--icon-only size-7.5 shrink-0 rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" href="{$system['system_url']}/posts/{$post['post_id']}" aria-label='{__("More")}' title='{__("More")}'>
          <span class="icon-[tabler--arrow-right] size-4 rtl:rotate-180" aria-hidden="true"></span>
        </a>
      </div>
    </div>
  {/if}
</li>
