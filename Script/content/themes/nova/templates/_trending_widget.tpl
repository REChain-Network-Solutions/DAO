{$_trending_icon = ''}
{if $system['system_theme_icons'] == 'svg'}
  {$_trending_icon = 'popular'|theme_module_icon:'size-14 shrink-0'}
{/if}
<div class="rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-linear-to-br from-error/30 via-warning/25 to-warning/5 p-5 text-sm">
  <div class="flex items-start gap-3">
    {if $_trending_icon}
      {$_trending_icon}
    {else}
      <span class="icon-[tabler--flame] size-12 shrink-0 text-error" aria-hidden="true"></span>
    {/if}
    <div class="min-w-0 grow">
      <h2 class="text-base font-semibold">{__("Trending")}</h2>
      <p class="mt-1 text-xs text-base-content/60">{__("Hashtags people are talking about right now")}</p>
    </div>
  </div>
  {$_trending_total = $trending_hashtags|count}
  <ol class="mt-4 flex flex-col gap-1.5">
    {foreach $trending_hashtags as $hashtag}
      {$_trending_position = 0}
      {if $_trending_total > 1}
        {$_trending_position = ($hashtag@iteration - 1) * 100 / ($_trending_total - 1)}
      {/if}
      <li>
        <a class="group flex items-center gap-3 rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[1.75rem] bg-base-100/70 px-2 py-2 text-base-content! shadow-sm backdrop-blur-sm transition-colors hover:bg-base-100" href="{$system['system_url']}/search/hashtag/{$hashtag['hashtag']}">
          <span class="flex w-9 shrink-0 items-center justify-center self-stretch rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-2xl bg-linear-to-b from-error via-warning to-warning/25 text-xs font-bold tabular-nums {if $hashtag@iteration <= $_trending_total * 0.6}text-white{else}text-base-content/70{/if}" style="background-size: 100% {$_trending_total * 100}%; background-position: 0 {$_trending_position}%;">{$hashtag@iteration}</span>
          <span class="min-w-0 grow">
            <span class="block truncate text-sm font-semibold" title="#{$hashtag['hashtag']}">#{$hashtag['hashtag']}</span>
            <span class="block text-xs text-base-content/60">{$hashtag['frequency']} {__("Posts")}</span>
          </span>
          <span class="icon-[tabler--arrow-up-right] size-4 shrink-0 text-error opacity-0 transition-opacity group-hover:opacity-100 rtl:-scale-x-100" aria-hidden="true"></span>
        </a>
      </li>
    {/foreach}
  </ol>
</div>
