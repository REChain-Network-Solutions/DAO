{include file='__modal_header.tpl' _icon="icon-[tabler--user-plus]" _title=__("Invite Friends")}
<div class="modal__body flex flex-col gap-4">
  {if $invites}
    <ul class="-mx-3 flex flex-col">
      {foreach $invites as $_user}
        {include file='__feeds_user.tpl' _tpl="list" _connection=$_user['connection']}
      {/foreach}
    </ul>

    {if count($invites) >= $system['max_results_even']}
      <!-- see-more -->
      {include file='__modal_see_more.tpl' _get="`$type`_invites" _id=$id _tpl="list"}
      <!-- see-more -->
    {/if}
  {else}
    {include file='_no_data.tpl' _empty_icon="icon-[tabler--users]" _empty_title=__("No friends to invite")}
  {/if}
</div>
