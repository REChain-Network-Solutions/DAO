{if count($boosted_posts) == 1}
  {include file='_boosted_post.tpl' post=$boosted_posts[0] _no_title=true}
{else}
  <!-- promoted posts -->
  <div class="js_boosted-carousel relative z-10" data-carousel='{ "loadingClasses": "opacity-0", "isAutoPlay": true, "speed": 13000, "isInfiniteLoop": true, "isRTL": {if $system['language']['dir'] == "RTL"}true{else}false{/if} }'>
    <div class="mb-3 flex items-center gap-3">
      <h2 class="flex min-w-0 grow items-center gap-2 text-sm font-semibold">
        <span class="inline-flex size-8 shrink-0 items-center justify-center rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-2xl bg-warning/15 text-base-content" aria-hidden="true"><span class="icon-[tabler--speakerphone] size-4.5"></span></span>
        <span class="truncate" title="{__("Promoted Posts")}">{__("Promoted Posts")}</span>
      </h2>
      <div class="flex shrink-0 items-center gap-1.5">
        <button type="button" class="carousel-prev static heroui button button--tertiary text-base-content button--sm button--icon-only size-6 rounded-lg corner-squircle supports-[corner-shape:squircle]:rounded-[0.75rem]" aria-label='{__("Previous")}'>
          <span class="icon-[tabler--chevron-left] size-4 rtl:rotate-180" aria-hidden="true"></span>
        </button>
        <button type="button" class="carousel-next static heroui button button--tertiary text-base-content button--sm button--icon-only size-6 rounded-lg corner-squircle supports-[corner-shape:squircle]:rounded-[0.75rem]" aria-label='{__("Next")}'>
          <span class="icon-[tabler--chevron-right] size-4 rtl:rotate-180" aria-hidden="true"></span>
        </button>
      </div>
    </div>
    <div class="carousel -mx-1 w-auto overflow-x-clip overflow-y-visible rounded-none bg-transparent">
      <div class="carousel-body peer w-full! items-start opacity-0 [transform:translateX(0)]! [&.opacity-0]:absolute [&.opacity-0]:inset-x-0 [&.opacity-0]:top-0">
        {foreach $boosted_posts as $_boosted_post}
          <div class="carousel-slide hidden w-full! shrink-0 px-1 transition-[opacity,translate]! duration-500! ease-out carousel-active:block starting:translate-x-6 starting:opacity-0 rtl:starting:-translate-x-6">
            {include file='__feeds_post.tpl' post=$_boosted_post standalone=true boosted=true _carousel=true}
          </div>
        {/foreach}
      </div>
      {include file='__carousel_skeleton.tpl' _type="post"}
    </div>
    <div class="carousel-pagination static mt-2 flex justify-center gap-1.5">
      {foreach $boosted_posts as $_boosted_post}
        <span class="carousel-dot size-2 carousel-active:bg-primary"></span>
      {/foreach}
    </div>
  </div>
  <!-- promoted posts -->
{/if}
