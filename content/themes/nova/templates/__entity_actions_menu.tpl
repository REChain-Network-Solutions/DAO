<!-- profile actions -->
<div class="dropdown relative inline-flex [--placement:bottom-end]">
  <button type="button" class="dropdown-toggle heroui button button--tertiary button--icon-only size-10 rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" aria-haspopup="menu" aria-expanded="false" aria-label='{__("More")}' id="{$_node_type}-actions-menu">
    <span class="icon-[tabler--dots] size-4" aria-hidden="true"></span>
  </button>
  <div class="dropdown-menu dropdown-open:opacity-100 z-50 hidden w-72 max-w-[calc(100vw-2rem)] rounded-2xl border border-base-300 bg-base-100 p-2 shadow-lg" aria-labelledby="{$_node_type}-actions-menu">
    <button type="button" class="js_modal dropdown-close dropdown-item flex w-full items-start gap-3 rounded-xl px-3 py-2.5 text-start text-sm font-medium" data-url="modules/share.php?node_type={$_node_type}&node_username={$_node_username}">
      <span class="icon-[tabler--share-3] mt-px size-5 shrink-0 text-base-content/60" aria-hidden="true"></span>
      <span class="min-w-0"><span class="block">{__("Share")}</span><span class="block text-[0.6875rem] leading-4 font-normal whitespace-normal text-base-content/60">{$_share_description}</span></span>
    </button>
    {if $_can_invite}
      <button type="button" class="js_modal dropdown-close dropdown-item flex w-full items-start gap-3 rounded-xl px-3 py-2.5 text-start text-sm font-medium" data-url="modules/invites.php?type={$_node_type}&id={$_node_id}">
        <span class="icon-[tabler--user-plus] mt-px size-5 shrink-0 text-base-content/60" aria-hidden="true"></span>
        <span class="min-w-0"><span class="block">{__("Invite Friends")}</span><span class="block text-[0.6875rem] leading-4 font-normal whitespace-normal text-base-content/60">{$_invite_description}</span></span>
      </button>
    {/if}
    {if $system['packages_enabled'] && $_node_admin}
      {if $_node_boosted}
        <button type="button" class="dropdown-close dropdown-item flex w-full items-start gap-3 rounded-xl px-3 py-2.5 text-start text-sm font-medium js_unboost-{$_node_type}" data-id="{$_node_id}">
          <span class="icon-[tabler--bolt] mt-px size-5 shrink-0 text-base-content/60" aria-hidden="true"></span>
          <span class="min-w-0"><span class="block">{__("Unboost")}</span><span class="block text-[0.6875rem] leading-4 font-normal whitespace-normal text-base-content/60">{$_boost_description}</span></span>
        </button>
      {elseif $_can_boost}
        <button type="button" class="dropdown-close dropdown-item flex w-full items-start gap-3 rounded-xl px-3 py-2.5 text-start text-sm font-medium js_boost-{$_node_type}" data-id="{$_node_id}">
          <span class="icon-[tabler--bolt] mt-px size-5 shrink-0 text-base-content/60" aria-hidden="true"></span>
          <span class="min-w-0"><span class="block">{__("Boost")}</span><span class="block text-[0.6875rem] leading-4 font-normal whitespace-normal text-base-content/60">{$_boost_description}</span></span>
        </button>
      {else}
        <a class="dropdown-close dropdown-item flex w-full items-start gap-3 rounded-xl px-3 py-2.5 text-start text-sm font-medium text-base-content!" href="{$system['system_url']}/packages">
          <span class="icon-[tabler--bolt] mt-px size-5 shrink-0 text-base-content/60" aria-hidden="true"></span>
          <span class="min-w-0"><span class="block">{$_boost_description}</span><span class="block text-[0.6875rem] leading-4 font-normal whitespace-normal text-base-content/60">{__("Packages")}</span></span>
        </a>
      {/if}
    {/if}
    {if $user->_logged_in}
      {if !$_node_admin}
        <button type="button" class="js_modal dropdown-close dropdown-item flex w-full items-start gap-3 rounded-xl px-3 py-2.5 text-start text-sm font-medium" data-url="data/report.php?do=create&handle={$_node_type}&id={$_node_id}">
          <span class="icon-[tabler--flag] mt-px size-5 shrink-0 text-base-content/60" aria-hidden="true"></span>
          <span class="min-w-0"><span class="block">{__("Report")}</span><span class="block text-[0.6875rem] leading-4 font-normal whitespace-normal text-base-content/60">{__("Report this to admins")}</span></span>
        </button>
      {/if}
      {if $user->_is_admin || $user->_is_moderator}<div class="my-1 border-t border-base-300"></div>{/if}
      {if $user->_is_admin}
        <a class="dropdown-close dropdown-item flex w-full items-start gap-3 rounded-xl px-3 py-2.5 text-start text-sm font-medium text-base-content!" href="{$_admin_url}">
          <span class="icon-[tabler--user-cog] mt-px size-5 shrink-0 text-base-content/60" aria-hidden="true"></span>
          <span class="min-w-0"><span class="block">{__("Manage")}</span><span class="block text-[0.6875rem] leading-4 font-normal whitespace-normal text-base-content/60">{__("Edit in Admin Panel")}</span></span>
        </a>
      {elseif $user->_is_moderator}
        <a class="dropdown-close dropdown-item flex w-full items-start gap-3 rounded-xl px-3 py-2.5 text-start text-sm font-medium text-base-content!" href="{$_moderator_url}">
          <span class="icon-[tabler--user-cog] mt-px size-5 shrink-0 text-base-content/60" aria-hidden="true"></span>
          <span class="min-w-0"><span class="block">{__("Manage")}</span><span class="block text-[0.6875rem] leading-4 font-normal whitespace-normal text-base-content/60">{__("Edit in Moderator Panel")}</span></span>
        </a>
      {/if}
    {/if}
  </div>
</div>
<!-- profile actions -->
