{capture assign=_modal_title}{__("Mutual Friends")} ({$total_mutual_friends}){/capture}
{include file='__modal_header.tpl' _icon="icon-[tabler--users]" _title=$_modal_title}
<div class="modal__body flex flex-col gap-4">
  {if $mutual_friends}
    <ul class="-mx-3 flex flex-col">
      {foreach $mutual_friends as $_user}
        {include file='__feeds_user.tpl' _tpl="list" _connection="remove"}
      {/foreach}
    </ul>

    {if $total_mutual_friends >= $system['max_results']}
      <!-- see-more -->
      {include file='__modal_see_more.tpl' _get="mutual_friends" _uid=$uid}
      <!-- see-more -->
    {/if}
  {else}
    {include file='_no_data.tpl' _empty_icon="icon-[tabler--users]" _empty_title=__("No mutual friends")}
  {/if}
</div>
