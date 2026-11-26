<!-- search filter -->
{if isset($filter) && $filter !== 'all'}
  <a class="badge badge-soft badge-primary badge-lg shrink-0 gap-1.5 rounded-full text-sm font-medium" href="{$_base}?query={$query|escape:'url'}" title='{__("Clear")}'>
    {if $filter === ''}
      <span class="icon-[tabler--align-left] size-4 shrink-0" aria-hidden="true"></span>{__("Text")}
    {elseif $filter === 'link'}
      <span class="icon-[tabler--link] size-4 shrink-0" aria-hidden="true"></span>{__("Links")}
    {elseif $filter === 'media'}
      <span class="icon-[tabler--library-photo] size-4 shrink-0" aria-hidden="true"></span>{__("Media")}
    {elseif $filter === 'live'}
      <span class="icon-[tabler--broadcast] size-4 shrink-0" aria-hidden="true"></span>{__("Live")}
    {elseif $filter === 'photos'}
      <span class="icon-[tabler--photo] size-4 shrink-0" aria-hidden="true"></span>{__("Photos")}
    {elseif $filter === 'map'}
      <span class="icon-[tabler--map-pin] size-4 shrink-0" aria-hidden="true"></span>{__("Maps")}
    {elseif $filter === 'rich_text'}
      <span class="icon-[tabler--notes] size-4 shrink-0" aria-hidden="true"></span>{__("Write-ups")}
    {elseif $filter === 'article'}
      <span class="icon-[tabler--article] size-4 shrink-0" aria-hidden="true"></span>{__("Blogs")}
    {elseif $filter === 'product'}
      <span class="icon-[tabler--shopping-bag] size-4 shrink-0" aria-hidden="true"></span>{__("Products")}
    {elseif $filter === 'funding'}
      <span class="icon-[tabler--coin] size-4 shrink-0" aria-hidden="true"></span>{__("Funding")}
    {elseif $filter === 'offer'}
      <span class="icon-[tabler--discount-2] size-4 shrink-0" aria-hidden="true"></span>{__("Offers")}
    {elseif $filter === 'job'}
      <span class="icon-[tabler--briefcase] size-4 shrink-0" aria-hidden="true"></span>{__("Jobs")}
    {elseif $filter === 'course'}
      <span class="icon-[tabler--school] size-4 shrink-0" aria-hidden="true"></span>{__("Courses")}
    {elseif $filter === 'poll'}
      <span class="icon-[tabler--chart-bar] size-4 shrink-0" aria-hidden="true"></span>{__("Polls")}
    {elseif $filter === 'reel'}
      <span class="icon-[tabler--movie] size-4 shrink-0" aria-hidden="true"></span>{__("Reels")}
    {elseif $filter === 'video'}
      <span class="icon-[tabler--video] size-4 shrink-0" aria-hidden="true"></span>{__("Videos")}
    {elseif $filter === 'audio'}
      <span class="icon-[tabler--headphones] size-4 shrink-0" aria-hidden="true"></span>{__("Audios")}
    {elseif $filter === 'file'}
      <span class="icon-[tabler--file] size-4 shrink-0" aria-hidden="true"></span>{__("Files")}
    {elseif $filter === 'merit'}
      <span class="icon-[tabler--award] size-4 shrink-0" aria-hidden="true"></span>{__("Merits")}
    {/if}
    <span class="icon-[tabler--x] size-3.5 shrink-0 opacity-70" aria-hidden="true"></span>
  </a>
{/if}
<!-- search filter -->
