<div class="modal-header">
  <h6 class="modal-title">{__("Group Members")}</h6>
  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
</div>
<div class="modal-body">
  {if $users}
    <ul>
      {foreach $users as $_user}
        {include file='__feeds_user.tpl' _tpl="list" _connection=$_user["connection"]}
      {/foreach}
    </ul>

    {if count($users) >= $system['max_results_even']}
      <!-- see-more -->
      <div class="alert alert-info see-more js_see-more" data-get="group_members" data-id="{$id}" data-tpl="list">
        <span>{__("See More")}</span>
        <div class="loader loader_small x-hidden"></div>
      </div>
      <!-- see-more -->
    {/if}
  {else}
    <p class="text-center text-muted">
      {__("No members found")}
    </p>
  {/if}
</div>