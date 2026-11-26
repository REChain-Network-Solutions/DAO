<!-- album header -->
<div class="mb-5 flex flex-wrap items-center gap-3 rounded-box bg-base-200 p-3 sm:gap-4 sm:p-4">
  <a href="{$system['system_url']}/{$album['path']}/albums" class="heroui button button--tertiary button--icon-only size-10 shrink-0 rounded-full border-transparent bg-base-100 text-base-content shadow-sm" title='{__("Back to Albums")}' aria-label='{__("Back to Albums")}'>
    <span class="icon-[tabler--arrow-left] size-5 rtl:rotate-180" aria-hidden="true"></span>
  </a>
  <span class="size-14 shrink-0 overflow-hidden rounded-field bg-base-300 shadow-sm">
    <img class="size-full object-cover{if $album['cover']['blur']} blur-xl{/if}" src="{$album['cover']['source']}" alt="" loading="lazy">
  </span>

  <!-- album title & meta -->
  <div class="min-w-0 flex-1 basis-40">
    <h3 class="truncate text-lg font-semibold" title="{__($album['title'])}">{__($album['title'])}</h3>
    <div class="mt-1 flex flex-wrap items-center gap-x-3 gap-y-1 text-sm text-base-content/60">
      <span class="inline-flex items-center gap-1.5">
        <span class="icon-[tabler--photo] size-4" aria-hidden="true"></span>
        {$album['photos_count']} {__("photos")}
      </span>
      <span class="inline-flex items-center gap-1.5">
        {if $album['privacy'] == "me"}
          <span class="icon-[tabler--lock] size-4" aria-hidden="true"></span>{__("Only Me")}
        {elseif $album['privacy'] == "friends"}
          <span class="icon-[tabler--users] size-4" aria-hidden="true"></span>{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
        {elseif $album['privacy'] == "public"}
          <span class="icon-[tabler--world] size-4" aria-hidden="true"></span>{__("Public")}
        {elseif $album['privacy'] == "custom"}
          <span class="icon-[tabler--settings] size-4" aria-hidden="true"></span>{__("Custom People")}
        {/if}
      </span>
    </div>
  </div>
  <!-- album title & meta -->

  <!-- album buttons -->
  {if $album['manage_album'] && $album['can_delete']}
    <div class="flex flex-wrap items-center gap-2">
      <button type="button" class="js_modal heroui button button--tertiary button--sm rounded-full border-transparent bg-base-100 text-base-content shadow-sm" data-url="albums/modal.php?do=edit_title&id={$album['album_id']}">
        <span class="icon-[tabler--pencil] size-4" aria-hidden="true"></span>{__("Edit Album")}
      </button>
      {if $system['photos_enabled']}
        <button type="button" class="js_modal heroui button button--tertiary button--sm rounded-full border-transparent bg-base-100 text-base-content shadow-sm" data-size="publisher" data-url="albums/modal.php?do=add_photos&id={$album['album_id']}">
          <span class="icon-[tabler--photo-plus] size-4" aria-hidden="true"></span>{__("Add Photos")}
        </button>
      {/if}
      <button type="button" class="heroui button button--danger-soft button--sm rounded-full js_delete-album" data-id="{$album['album_id']}">
        <span class="icon-[tabler--trash] size-4" aria-hidden="true"></span>{__("Delete Album")}
      </button>
    </div>
  {/if}
  <!-- album buttons -->
</div>
<!-- album header -->

<!-- photos -->
{if count($album['photos']) > 0}
  <ul class="row grid grid-cols-2 gap-3 sm:grid-cols-3 xl:grid-cols-4">
    {foreach $album['photos'] as $photo}
      {include file='__profile_media.tpl' _kind='photo' _context="album" _manage=$album['manage_album']}
    {/foreach}
  </ul>
  {if count($album['photos']) >= $system['max_results_even']}
    <!-- see-more -->
    <button type="button" class="see-more js_see-more mt-5 w-full flex cursor-pointer items-center justify-center gap-2 rounded-box border border-base-300 bg-base-100 py-3 text-sm font-semibold transition-colors hover:border-primary/30 hover:bg-primary/5 hover:text-primary" data-tpl="list" data-get="photos" data-id="{$album['album_id']}" data-type='album'>
      <span>{__("See More")}</span>
      <i class="loading loading-spinner loading-sm hidden" aria-hidden="true"></i>
    </button>
    <!-- see-more -->
  {/if}
{else}
  <p class="py-10 text-center text-sm text-base-content/60">
    {__("This album is empty")}
  </p>
{/if}
<!-- photos -->
