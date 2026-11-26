{include file='__modal_header.tpl' _icon="icon-[tabler--photo]" _title=__("Select Photo")}
<div class="modal__body flex flex-col gap-4">
  {if $photos}
    <div>
      <ul class="grid grid-cols-3 gap-2">
        {foreach $photos as $photo}
          {include file='__feeds_profile_photo.tpl' _filter=$filter}
        {/foreach}
      </ul>
      <!-- see-more -->
      <button type="button" class="see-more js_see-more mt-4 w-full flex cursor-pointer items-center justify-center gap-2 rounded-box border border-base-300 bg-base-100 py-3 text-sm font-semibold transition-colors hover:border-primary/30 hover:bg-primary/5 hover:text-primary" data-get="profile_photos" data-id="{$id}" data-type='{$type}' data-filter="{$filter}">
        <span>{__("See More")}</span>
        <div class="loading loading-spinner loading-sm hidden"></div>
      </button>
      <!-- see-more -->
    </div>
  {else}
    {include file='_no_data.tpl' _empty_icon="icon-[tabler--photo]"}
  {/if}
</div>
