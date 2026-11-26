{include file='_head.tpl'}
{include file='_header.tpl'}

<!-- page content -->
{capture name="auth_content"}
  <!-- app -->
  <div class="flex flex-col items-center text-center">
    <div class="flex items-center gap-3">
      {if $app['app_icon']}
        <img class="size-16 shrink-0 rounded-2xl border border-base-300 object-cover" src="{$system['system_uploads']}/{$app['app_icon']}" width="64" height="64" alt="{$app['app_name']}">
      {else}
        <span class="flex size-16 shrink-0 items-center justify-center rounded-2xl bg-primary/10 text-primary"><span class="icon-[tabler--app-window] size-8" aria-hidden="true"></span></span>
      {/if}
      <span class="icon-[tabler--arrows-exchange] size-5 shrink-0 text-base-content/40" aria-hidden="true"></span>
      <img class="size-16 shrink-0 rounded-full border border-base-300 object-cover" src="{$user->_data['user_picture']}" width="64" height="64" alt="{$user->_data['user_fullname']}">
    </div>
    <h2 class="mt-5 max-w-full truncate text-2xl font-semibold" title="{$app['app_name']}">{$app['app_name']}</h2>
    {if $app['app_domain']}
      <span class="mt-1 flex max-w-full min-w-0 items-center gap-1 text-sm text-base-content/60" dir="ltr">
        <span class="icon-[tabler--world] size-4 shrink-0" aria-hidden="true"></span>
        <span class="truncate" title="{$app['app_domain']}">{$app['app_domain']}</span>
      </span>
    {/if}
  </div>
  <!-- app -->

  <!-- app permissions -->
  <div class="mt-6 rounded-box border border-base-300">
    <div class="border-b border-base-300 px-4 py-3 text-sm font-medium text-base-content/80">{__("Will receive your")}:</div>
    <ul class="flex flex-col divide-y divide-base-300 text-sm">
      <li class="flex items-center gap-3 px-4 py-3">
        <span class="icon-[tabler--user] size-5 shrink-0 text-primary" aria-hidden="true"></span>
        <span class="grow">{__("Name")}</span>
        <span class="icon-[tabler--check] size-4 shrink-0 text-success" aria-hidden="true"></span>
      </li>
      <li class="flex items-center gap-3 px-4 py-3">
        <span class="icon-[tabler--mail] size-5 shrink-0 text-primary" aria-hidden="true"></span>
        <span class="grow">{__("Email Address")}</span>
        <span class="icon-[tabler--check] size-4 shrink-0 text-success" aria-hidden="true"></span>
      </li>
      <li class="flex items-center gap-3 px-4 py-3">
        <span class="icon-[tabler--photo] size-5 shrink-0 text-primary" aria-hidden="true"></span>
        <span class="grow">{__("Profile Picture")}</span>
        <span class="icon-[tabler--check] size-4 shrink-0 text-success" aria-hidden="true"></span>
      </li>
    </ul>
  </div>
  <!-- app permissions -->

  <div class="mt-6 flex flex-col gap-3">
    <button type="button" class="heroui button button--primary button--lg button--full-width js_developers-oauth-app" data-id="{$app['app_auth_id']}">
      <span class="icon-[tabler--circle-check] size-5 shrink-0" aria-hidden="true"></span>
      <span class="truncate" title="{__("Continue as")} {$user->_data['user_fullname']}">{__("Continue as")} {$user->_data['user_fullname']}</span>
    </button>
    <a href="{$system['system_url']}" class="heroui button button--ghost button--lg button--full-width">{__("Cancel")}</a>
  </div>
{/capture}
{include file='__auth_card.tpl'}
<!-- page content -->

{include file='_footer.tpl'}
