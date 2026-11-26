<div class="{if $_small}col-4{else}col-6 col-md-4 col-lg-2{/if} {if $photo['blur']}x-blured{/if}">
  <a class="pg_photo {if !$_small}large{/if} js_lightbox" href="{$system['system_url']}/photos/{$photo['photo_id']}" data-id="{$photo['photo_id']}" data-image="{$system['system_uploads']}/{$photo['source']}" data-context="{$_context}" style="background-image:url({$system['system_uploads']}/{$photo['source']});">
    {if !$_small && ($_manage || $photo['manage'])}
      <!-- delete -->
      <div class="pg_photo-delete-btn">
        <button class="heroui button button--tertiary button--sm button--icon-only size-6 rounded-full js_delete-photo" type="button" data-id="{$photo['photo_id']}" title='{__("Delete")}'><span class="icon-[tabler--x] size-4" aria-hidden="true"></span></button>
      </div>
      <!-- delete -->
      {if $_can_pin}
        <!-- pin -->
        <div class="pg_photo-pin-btn {if $photo['pinned']}js_unpin-photo pinned{else}js_pin-photo{/if}" data-id="{$photo['photo_id']}" title='{__("Pin")}'>
          <span class="icon-[tabler--paperclip] size-4" aria-hidden="true"></span>
        </div>
        <!-- pin -->
      {/if}
    {/if}
  </a>
</div>