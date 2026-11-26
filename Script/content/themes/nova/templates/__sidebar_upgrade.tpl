{if $user->_logged_in && $system['packages_enabled'] && !$user->_data['user_subscribed']}
  <!-- upgrade -->
  {$_pro_icon = ''}
  {if $system['system_theme_icons'] == 'svg'}
    {$_pro_icon = 'pro'|theme_module_icon:'size-12 shrink-0'}
  {/if}
  <div class="mt-5 rounded-box bg-primary/10 p-5">
    {if $_pro_icon}
      {$_pro_icon}
    {else}
      <span class="flex size-12 items-center justify-center rounded-full bg-primary text-primary-content">
        <span class="icon-[tabler--crown] size-6" aria-hidden="true"></span>
      </span>
    {/if}
    <h2 class="mt-4 text-base font-semibold">{__("Upgrade to Pro")}</h2>
    <p class="mt-1 text-xs text-base-content/60">{__("Choose the Plan That's Right for You")}</p>
    <a class="heroui button button--primary mt-4 w-full rounded-field" href="{$system['system_url']}/packages">{__("Upgrade Now")}</a>
  </div>
  <!-- upgrade -->
{/if}
