{if $_movies}
  <!-- movies row -->
  <section class="flex flex-col gap-4">
    <div class="flex items-center justify-between gap-3">
      <h2 class="flex min-w-0 items-center gap-2.5 text-lg font-semibold">
        <span class="{if $_icon}{$_icon}{else}icon-[tabler--movie]{/if} size-5 shrink-0 text-base-content/60" aria-hidden="true"></span>
        <span class="truncate" title="{$_title}">{$_title}</span>
      </h2>
      <div class="flex shrink-0 items-center gap-2">
        {if $_link}
          <a class="heroui button button--ghost button--sm gap-1 px-2 text-base-content/70 hover:text-primary" href="{$_link}">
            {__("See All")}
            <span class="icon-[tabler--chevron-right] size-4 rtl:rotate-180" aria-hidden="true"></span>
          </a>
        {/if}
      </div>
    </div>

    <div data-carousel='{ "loadingClasses": "opacity-0", "isDraggable": true, "slidesQty": { "xs": 2, "sm": 3, "md": 4, "lg": 4, "xl": 5 }, "isRTL": {if $system['language']['dir'] == "RTL"}true{else}false{/if} }' class="relative">
      <div class="carousel rounded-none bg-transparent">
        <div class="carousel-body peer cursor-grab opacity-0 [&.opacity-0]:absolute [&.opacity-0]:inset-x-0 [&.opacity-0]:top-0 carousel-dragging:cursor-grabbing carousel-dragging:transition-none">
          {foreach $_movies as $_movie}
            <div class="carousel-slide pe-4">
              {include file='__movies_card.tpl' _movie=$_movie}
            </div>
          {/foreach}
        </div>
        {include file='__carousel_skeleton.tpl' _type="movies"}
      </div>

      {if count($_movies) > 2}
        <!-- arrows -->
        <button type="button" disabled class="carousel-prev disabled absolute -start-4 bottom-14 z-10 inline-flex size-10 items-center justify-center rounded-full border border-base-300 bg-base-100 text-base-content shadow-md transition hover:bg-base-300 carousel-disabled:pointer-events-none carousel-disabled:opacity-0{if count($_movies) == 3} sm:hidden{elseif count($_movies) == 4} md:hidden{elseif count($_movies) == 5} xl:hidden{/if}" aria-label='{__("Previous")}'>
          <span class="icon-[tabler--chevron-left] size-5 rtl:rotate-180" aria-hidden="true"></span>
        </button>
        <button type="button" class="carousel-next absolute -end-1 bottom-14 z-10 inline-flex size-10 items-center justify-center rounded-full border border-base-300 bg-base-100 text-base-content shadow-md transition hover:bg-base-300 carousel-disabled:pointer-events-none carousel-disabled:opacity-0{if count($_movies) == 3} sm:hidden{elseif count($_movies) == 4} md:hidden{elseif count($_movies) == 5} xl:hidden{/if}" aria-label='{__("Next")}'>
          <span class="icon-[tabler--chevron-right] size-5 rtl:rotate-180" aria-hidden="true"></span>
        </button>
        <!-- arrows -->
      {/if}
    </div>
  </section>
  <!-- movies row -->
{/if}
