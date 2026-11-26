{foreach $dating_photos as $_photo}
  <li class="js_dating-photo-item group relative aspect-[3/4] cursor-grab overflow-hidden rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[1.75rem] bg-base-300 shadow-lg" data-id="{$_photo['photo_id']}">
    <img class="size-full object-cover" src="{$_photo['url']}" alt="">
    <div class="absolute inset-x-2 bottom-2 flex flex-wrap items-center gap-1">
      {if $_photo@first}
        <span class="inline-flex items-center gap-1 rounded-full border border-white/25 bg-black/35 shadow-lg shadow-black/20 backdrop-blur-md px-2 py-0.5 text-[11px] font-medium text-white">
          <span class="icon-[tabler--star-filled] size-3 text-amber-300" aria-hidden="true"></span>
          {__("Main")}
        </span>
      {/if}
      {if $_photo['status'] == "pending"}
        <span class="inline-flex items-center gap-1 rounded-full border border-white/25 bg-black/35 shadow-lg shadow-black/20 backdrop-blur-md px-2 py-0.5 text-[11px] font-medium text-white">
          <span class="icon-[tabler--clock] size-3 text-amber-300" aria-hidden="true"></span>
          {__("In Review")}
        </span>
      {/if}
    </div>
    <button type="button" class="heroui button button--tertiary button--sm button--icon-only size-6 rounded-full absolute end-2 top-2 border border-white/25 bg-black/35 shadow-lg shadow-black/20 backdrop-blur-md text-white hover:bg-black/50 js_dating-photo-delete" data-id="{$_photo['photo_id']}" title='{__("Delete")}' aria-label='{__("Delete")}'>
      <span class="icon-[tabler--x] size-3.5" aria-hidden="true"></span>
    </button>
  </li>
{/foreach}
