<div class="card border border-base-300 bg-base-100 shadow-none">
  <div class="card-header flex flex-wrap items-center gap-3 border-b border-base-300">
    <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-base-content" aria-hidden="true">
      <span class="icon-[tabler--apps] size-5"></span>
    </span>
    <div class="min-w-0 grow">
      <h2 class="card-title text-lg">{__("Apps")}</h2>
      <p class="text-sm text-base-content/60">{__("Apps you have authorized")}</p>
    </div>
    {if $apps}
      <span class="badge badge-soft rounded-full ms-auto shrink-0">{count($apps)}</span>
    {/if}
  </div>
  <div class="card-body gap-6 pt-6">
    <div class="alert alert-info flex items-start gap-3 leading-5" role="alert">
      <span class="icon-[tabler--info-circle] size-5 shrink-0" aria-hidden="true"></span>
      <p class="min-w-0 text-sm">{__("These are apps you've used to log into. They can receive information you chose to share with them.")}</p>
    </div>

    {if $apps}
      <div class="flex flex-col divide-y divide-base-300 overflow-hidden rounded-xl border border-base-300">
        {foreach $apps as $app}
          <div class="flex items-center gap-4 p-4">
            <span class="inline-flex size-11 shrink-0 items-center justify-center overflow-hidden rounded-xl bg-base-200">
              <img class="size-full object-cover" src="{$system['system_uploads']}/{$app['app_icon']}" alt="{$app['app_name']}">
            </span>
            <div class="min-w-0 grow">
              <div class="truncate text-sm font-medium" title="{$app['app_name']}">{$app['app_name']}</div>
              {if $app['app_description']}
                <p class="mt-0.5 line-clamp-2 text-sm text-base-content/60" title="{$app['app_description']}">{$app['app_description']}</p>
              {/if}
            </div>
            <button type="button" class="heroui button button--danger-soft button--sm shrink-0 js_delete-user-app rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" data-id="{$app['app_auth_id']}" aria-label='{__("Remove")}'>
              <span class="icon-[tabler--trash] size-4" aria-hidden="true"></span>
              <span class="hidden sm:inline">{__("Remove")}</span>
            </button>
          </div>
        {/foreach}
      </div>
    {else}
      {include file='_no_data.tpl' _empty_icon="icon-[tabler--apps]"}
    {/if}
  </div>
</div>
