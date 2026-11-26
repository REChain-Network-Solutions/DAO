{if $_type == "users"}
  {$_module_icon = 'pro'}
  {$_fallback_icon = 'icon-[tabler--crown] text-accent'}
  {$_shell = 'from-warning/25 via-base-100 to-accent/25'}
  {$_speed = 14000}
{elseif $_type == "pages"}
  {$_module_icon = 'pages'}
  {$_fallback_icon = 'icon-[tabler--flag] text-info'}
  {$_shell = 'from-info/25 via-base-100 to-primary/25'}
  {$_speed = 15000}
{elseif $_type == "groups"}
  {$_module_icon = 'groups'}
  {$_fallback_icon = 'icon-[tabler--users-group] text-success'}
  {$_shell = 'from-success/25 via-base-100 to-info/25'}
  {$_speed = 16000}
{else}
  {$_module_icon = 'events'}
  {$_fallback_icon = 'icon-[tabler--calendar-event] text-error'}
  {$_shell = 'from-error/20 via-base-100 to-secondary/25'}
  {$_speed = 17000}
{/if}
{$_promoted_icon = ''}
{if $system['system_theme_icons'] == 'svg'}
  {$_promoted_icon = $_module_icon|theme_module_icon:'size-14 shrink-0'}
{/if}
<!-- promoted {$_type} -->
<div class="rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-linear-to-br {$_shell} p-5 text-sm" data-carousel='{ "loadingClasses": "opacity-0", "isAutoPlay": true, "speed": {$_speed}, "isInfiniteLoop": true, "slidesQty": { "xs": 3, "sm": 4, "md": 5, "lg": 6, "xl": 3 }, "isRTL": {if $system['language']['dir'] == "RTL"}true{else}false{/if} }'>
  <div class="flex items-start gap-3">
    {if $_promoted_icon}
      {$_promoted_icon}
    {else}
      <span class="{$_fallback_icon} size-12 shrink-0" aria-hidden="true"></span>
    {/if}
    <div class="min-w-0 grow">
      <h2 class="text-base font-semibold">{$_title}</h2>
      <p class="mt-1 text-xs text-base-content/60">
        {if $_type == "users"}{__("Get latest activities from our popular users")}{elseif $_type == "pages"}{__("Discover popular pages picked for you")}{elseif $_type == "groups"}{__("Join popular groups from our community")}{else}{__("Don't miss the most popular events")}{/if}
      </p>
    </div>
    <div class="flex shrink-0 items-center gap-1.5">
      <button type="button" class="carousel-prev static heroui button button--tertiary button--sm button--icon-only size-6 rounded-lg corner-squircle supports-[corner-shape:squircle]:rounded-[0.75rem] border border-white/60 dark:border-white/10 dark:bg-black/25 dark:hover:border-white/20 dark:hover:bg-black/40 bg-base-100/35 text-base-content shadow-sm backdrop-blur-md hover:border-white/80 hover:bg-base-100/60" aria-label='{__("Previous")}'>
        <span class="icon-[tabler--chevron-left] size-4 rtl:rotate-180" aria-hidden="true"></span>
      </button>
      <button type="button" class="carousel-next static heroui button button--tertiary button--sm button--icon-only size-6 rounded-lg corner-squircle supports-[corner-shape:squircle]:rounded-[0.75rem] border border-white/60 dark:border-white/10 dark:bg-black/25 dark:hover:border-white/20 dark:hover:bg-black/40 bg-base-100/35 text-base-content shadow-sm backdrop-blur-md hover:border-white/80 hover:bg-base-100/60" aria-label='{__("Next")}'>
        <span class="icon-[tabler--chevron-right] size-4 rtl:rotate-180" aria-hidden="true"></span>
      </button>
    </div>
  </div>
  <div class="carousel -mx-1.5 mt-4 w-auto rounded-none bg-transparent">
    <div class="carousel-body peer opacity-0 [&.opacity-0]:absolute [&.opacity-0]:inset-x-0 [&.opacity-0]:top-0">
      {foreach $_items as $_item}
        {if $_type == "users"}
          {capture assign="_item_name"}{if $system['show_usernames_enabled']}{$_item['user_name']}{else}{$_item['user_firstname']}{/if}{/capture}
          {$_item_url = "`$system['system_url']`/`$_item['user_name']`"}
          {$_item_picture = $_item['user_picture']}
          {$_item_verified = $_item['user_verified']}
        {elseif $_type == "pages"}
          {$_item_name = $_item['page_title']}
          {$_item_url = "`$system['system_url']`/pages/`$_item['page_name']`"}
          {$_item_picture = $_item['page_picture']}
          {$_item_verified = $_item['page_verified']}
        {elseif $_type == "groups"}
          {$_item_name = $_item['group_title']}
          {$_item_url = "`$system['system_url']`/groups/`$_item['group_name']`"}
          {$_item_picture = $_item['group_picture']}
          {$_item_verified = false}
        {else}
          {$_item_name = $_item['event_title']}
          {$_item_url = "`$system['system_url']`/events/`$_item['event_id']`"}
          {$_item_picture = $_item['event_picture']}
          {$_item_verified = false}
        {/if}
        <div class="carousel-slide px-1.5 py-1">
          <a class="group relative block min-w-0 overflow-hidden rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[1.75rem] shadow-sm" href="{$_item_url}" title="{$_item_name}" aria-label="{$_item_name}">
            <img class="aspect-square w-full object-cover transition-transform duration-300 group-hover:scale-105" src="{$_item_picture}" alt="{$_item_name}" loading="lazy">
            <span class="absolute inset-x-0 bottom-0 flex min-w-0 items-center justify-center gap-1 bg-linear-to-t from-black/70 to-transparent px-1.5 pb-1.5 pt-5 text-white opacity-0 transition-opacity duration-200 group-hover:opacity-100 group-focus-visible:opacity-100" aria-hidden="true">
              <span class="truncate text-[11px] font-semibold" title="{$_item_name}">{$_item_name}</span>
              {if !empty($_item_verified)}
                <span class="verified-badge inline-flex shrink-0">
                  {include file='__svg_icons.tpl' icon="verified_badge" width="12px" height="12px"}
                </span>
              {/if}
            </span>
          </a>
        </div>
      {/foreach}
    </div>
    {include file='__carousel_skeleton.tpl' _type="promoted"}
  </div>
  {if $_type == "users" && $system['packages_enabled'] && !$user->_data['user_subscribed']}
    <a class="heroui button button--primary [--button-bg:var(--color-accent)] [--button-bg-hover:color-mix(in_oklab,var(--color-accent)_90%,black)] [--button-bg-pressed:color-mix(in_oklab,var(--color-accent)_90%,black)] [--button-fg:var(--color-accent-content)] mt-4 w-full rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" href="{$system['system_url']}/packages">{__("Upgrade Now")}</a>
  {/if}
</div>
<!-- promoted {$_type} -->
