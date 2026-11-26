<!-- album buttons -->
{if $album['manage_album'] && $album['can_delete']}
  <div class="text-center">
    <button type="button" class="js_modal heroui button button--outline [--button-fg:var(--accent)] button--sm rounded-full ms-1.25 mb5" data-url="albums/modal.php?do=edit_title&id={$album['album_id']}">
      <span class="icon-[tabler--pencil] size-4 me-1.25" aria-hidden="true"></span>{__("Edit Album")}
    </button>
    {if $system['photos_enabled']}
      <button type="button" class="js_modal heroui button button--outline [--button-fg:var(--accent)] button--sm rounded-full ms-1.25 mb5" data-size="publisher" data-url="albums/modal.php?do=add_photos&id={$album['album_id']}">
        <span class="icon-[tabler--circle-plus] size-4 me-1.25" aria-hidden="true"></span>{__("Add Photos")}
      </button>
    {/if}
    <button type="button" class="heroui button button--outline [--button-fg:var(--danger)] button--sm rounded-full ms-1.25 mb5 js_delete-album" data-id="{$album['album_id']}">
      <span class="icon-[tabler--trash] size-4 me-1.25" aria-hidden="true"></span>{__("Delete Album")}
    </button>
  </div>
{/if}
<!-- album buttons -->

<!-- album title & meta -->
<div class="album-title">
  {__($album['title'])}
</div>
<div class="album-meta">
  {if $album['privacy'] == "me"}
    {__("Shared with")} <span class="icon-[tabler--lock] size-4" title='{__("Shared with")}: {__("Only Me")}'></span>
  {elseif $album['privacy'] == "friends"}
    {__("Shared with")} <span class="icon-[tabler--users] size-4" title='{__("Shared with")}: {if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}'></span>
  {elseif $album['privacy'] == "public"}
    {__("Shared with")} <span class="icon-[tabler--world] size-4" title='{__("Shared with")}: {__("Public")}'></span>
  {elseif $album['privacy'] == "custom"}
    {__("Shared with")} <span class="icon-[tabler--settings] size-4" title='{__("Shared with")} {__("Custom People")}'></span>
  {/if}
</div>
<!-- album title & meta -->

<!-- photos -->
{if count($album['photos']) > 0}
  <ul class="row">
    {foreach $album['photos'] as $photo}
      {include file='__feeds_photo.tpl' _context="album" _manage=$album['manage_album']}
    {/foreach}
  </ul>
  {if count($album['photos']) >= $system['max_results_even']}
    <!-- see-more -->
    <div class="see-more js_see-more flex cursor-pointer items-center justify-center gap-2 rounded-box border border-base-300 bg-base-100 py-3 text-sm font-semibold transition-colors hover:border-primary/30 hover:bg-primary/5 hover:text-primary" data-get="photos" data-id="{$album['album_id']}" data-type='album'>
      <span>{__("See More")}</span>
      <div class="loading loading-spinner loading-sm hidden"></div>
    </div>
    <!-- see-more -->
  {/if}
{else}
  <p class="text-center text-muted mt10">
    {__("This album is empty")}
  </p>
{/if}
<!-- photos -->
