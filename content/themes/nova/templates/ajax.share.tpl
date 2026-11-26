{include file='__modal_header.tpl' _icon="icon-[tabler--share]" _title=__("Share")}
<div class="modal__body flex flex-col gap-4">
  <!-- share link -->
  <div class="w-full">
    <label class="label-text mb-1.5 block" for="share-link">{__("Link")}</label>
    {include file='__copy_input.tpl' _id="share-link" _value=$share_link}
  </div>
  <!-- share link -->

  {if $system['social_share_enabled']}
    <!-- social share -->
    <div class="flex items-center justify-between gap-2">
      {include file='__social_share.tpl' _link=$share_link}
    </div>
    <!-- social share -->
  {/if}
</div>
