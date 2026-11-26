<!-- suggested reels -->
<div class="card overflow-hidden rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-[#F9F9F9] dark:bg-base-300 shadow-none text-sm" data-carousel='{ "loadingClasses": "opacity-0", "isDraggable": true, "slidesQty": { "xs": 2, "sm": 3, "md": 3, "lg": 3, "xl": 3 }, "isRTL": {if $system['language']['dir'] == "RTL"}true{else}false{/if} }'>
  {include file='__card_header.tpl' _card_title=__("Reels") _card_url="`$system['system_url']`/reels" _card_arrows=true _card_arrow_class="border-transparent bg-black/5 text-base-content shadow-none hover:bg-black/10 dark:bg-white/10 dark:hover:bg-white/15"}
  <div class="card-body rounded-t-3xl corner-squircle supports-[corner-shape:squircle]:rounded-t-[2.5rem] bg-base-100 p-3">
    <div class="carousel rounded-none bg-transparent">
      <div class="carousel-body opacity-0">
        {foreach $reels as $reel}
          <div class="carousel-slide px-1">
            <a class="relative block aspect-[9/16] overflow-hidden rounded-[1.375rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1.875rem] bg-linear-to-br from-neutral-700 to-neutral-900" href="{$system['system_url']}/reels/{$reel['post_id']}">
              {if $reel['thumbnail']}
                <img class="size-full object-cover" src="{$system['system_uploads']}/{$reel['thumbnail']}" alt="" loading="lazy" draggable="false">
              {else}
                <span class="absolute inset-0 flex items-center justify-center text-white/60"><i class="icon-[tabler--movie] size-10" aria-hidden="true"></i></span>
              {/if}
              <span class="pointer-events-none absolute inset-x-0 bottom-0 h-16 bg-linear-to-t from-black/60 to-transparent"></span>
              <span class="absolute start-3 bottom-2.5 z-2 flex items-center gap-1 text-xs font-semibold text-white text-shadow-sm"><i class="icon-[tabler--player-play-filled] size-3.5" aria-hidden="true"></i>{$reel['views_formatted']}</span>
            </a>
          </div>
        {/foreach}
      </div>
    </div>
  </div>
</div>
<!-- suggested reels -->
