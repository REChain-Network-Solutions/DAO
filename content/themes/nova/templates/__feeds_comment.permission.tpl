<div class="py-3 text-center text-sm text-base-content/55">
  {__("You don't have the permission to comment")}.
  {if $user->_data['can_upgrade_comments']}
    <a class="font-semibold text-primary hover:underline" href="{$system['system_url']}/packages">{__("Upgrade")}</a>
  {/if}
</div>
