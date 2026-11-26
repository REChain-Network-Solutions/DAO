{include file='__modal_header.tpl' _icon="icon-[tabler--heart-handshake]" _title=__("People Who Donated To This")}
<div class="modal__body flex flex-col gap-4">
  {if $users}
    <ul class="-mx-3 flex flex-col">
      {foreach $users as $_user}
        {include file='__feeds_user.tpl' _tpl="list" _connection=$_user["connection"] _donation=$_user['donation_amount'] _donation_time=$_user['donation_time']}
      {/foreach}
    </ul>

    {if count($users) >= $system['max_results']}
      <!-- see-more -->
      {include file='__modal_see_more.tpl' _get="donors" _id=$id}
      <!-- see-more -->
    {/if}
  {else}
    {include file='_no_data.tpl' _empty_icon="icon-[tabler--heart-handshake]" _empty_title=__("No people donated for this")}
  {/if}
</div>
