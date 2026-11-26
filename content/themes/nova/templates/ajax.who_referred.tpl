{include file='__modal_header.tpl' _icon="icon-[tabler--user-plus]" _title=__("Referrals")}
<div class="modal__body flex flex-col gap-4">
  {if $users}
    <ul class="-mx-3 flex flex-col">
      {foreach $users as $_user}
        {include file='__feeds_user.tpl' _tpl="list" _connection=$_user["connection"]}
      {/foreach}
    </ul>

    {if count($users) >= $system['max_results']}
      <!-- see-more -->
      {include file='__modal_see_more.tpl' _get="affiliates" _uid=$id}
      <!-- see-more -->
    {/if}
  {else}
    {include file='_no_data.tpl' _empty_icon="icon-[tabler--user-plus]" _empty_title=__("No referrals yet")}
  {/if}
</div>
