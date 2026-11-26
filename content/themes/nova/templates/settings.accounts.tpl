<div class="card border border-base-300 bg-base-100 shadow-none">
  <div class="card-header flex flex-wrap items-center gap-3 border-b border-base-300">
    <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-base-content" aria-hidden="true">
      <span class="icon-[tabler--users] size-5"></span>
    </span>
    <div class="min-w-0 grow">
      <h2 class="card-title text-lg">{__("Connected Accounts")}</h2>
      <p class="text-sm text-base-content/60">{__("Switch between connected accounts")}</p>
    </div>
    {if $user->_data['user_id'] == $user->_data['user_master_account']}
      <button type="button" class="js_modal heroui button button--primary button--sm w-full sm:ms-auto sm:w-auto shrink-0 rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" data-url="#account-connector">
        <span class="icon-[tabler--user-plus] size-4" aria-hidden="true"></span>
        {__("Connect Account")}
      </button>
    {/if}
  </div>
  <div class="card-body gap-6 pt-6">
    {if count($user->connected_accounts()) > 1}
      {if $user->_data['user_id'] == $user->_data['user_master_account']}
        <ul class="flex flex-col gap-1">
          {foreach $user->connected_accounts() as $_user}
            {if $_user['user_id'] != $user->_data['user_id']}
              {include file='__feeds_user.tpl' _tpl="list" _connection="connected_account_remove"}
            {/if}
          {/foreach}
        </ul>
      {else}
        <div class="alert alert-info flex items-start gap-3 leading-5" role="alert">
          <span class="icon-[tabler--link] size-5 shrink-0" aria-hidden="true"></span>
          <p class="min-w-0 text-sm">{__("You are connected to this account")}</p>
        </div>
        <ul class="flex flex-col gap-1">
          {foreach $user->connected_accounts() as $_user}
            {if $_user['user_id'] == $user->_data['user_master_account']}
              {include file='__feeds_user.tpl' _tpl="list" _connection="connected_account_revoke"}
            {/if}
          {/foreach}
        </ul>
      {/if}
    {else}
      {include file='_no_data.tpl' _empty_icon="icon-[tabler--users-plus]"}
    {/if}
  </div>
</div>
