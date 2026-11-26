{foreach $cards as $card}
  {include file='__dating_card.tpl'}
  {if $dating_ad && $system['dating_ads_frequency'] > 0 && $card@iteration % $system['dating_ads_frequency'] == 0}
    <article class="js_dating-card absolute inset-0 flex flex-col overflow-hidden rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] border border-base-300 bg-base-100 shadow-xl transition-transform duration-300 will-change-transform" data-ad="true">
      <div class="flex items-center gap-2 border-b border-base-300 px-5 py-3 text-xs font-medium uppercase tracking-wider text-base-content/50">
        <span class="icon-[tabler--speakerphone] size-4" aria-hidden="true"></span>
        {__("Sponsored")}
      </div>
      <div class="min-h-0 grow overflow-y-auto break-words p-5 pb-28 text-sm [&_iframe]:max-w-full [&_img]:max-w-full">{$dating_ad['code']}</div>
    </article>
  {/if}
{/foreach}
