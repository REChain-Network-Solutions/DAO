{include file='__modal_header.tpl' _icon="icon-[tabler--share]" _title=__("People Who Shared This")}
<div class="modal__body flex flex-col gap-4">
  {if $posts}
    <ul class="-mx-3 flex flex-col">
      {foreach $posts as $_post}
        {include file='__feeds_share.tpl'}
      {/foreach}
    </ul>

    {if count($posts) >= $system['max_results']}
      <!-- see-more -->
      {include file='__modal_see_more.tpl' _get="shares" _id=$id}
      <!-- see-more -->
    {/if}
  {else}
    {include file='_no_data.tpl' _empty_icon="icon-[tabler--share]" _empty_title=__("No people shared this")}
  {/if}
</div>
