{include file='__modal_header.tpl' _icon="icon-[tabler--palette]" _title=__("Themes")}
<div class="modal__body flex flex-col gap-6">
  <!-- themes -->
  <section class="flex flex-col gap-3" aria-labelledby="themes-demo-themes">
    <h3 id="themes-demo-themes" class="m-0 text-sm font-semibold">{__("Themes")}</h3>
    <div class="grid grid-cols-2 gap-4 sm:grid-cols-3">
      {foreach $themes as $theme}
        <a href="{$theme['url']}" rel="nofollow" class="group flex flex-col overflow-hidden rounded-xl border bg-base-100 transition hover:border-primary{if $theme['active']} border-primary ring-2 ring-primary/30{else} border-base-300{/if}" {if $theme['active']}aria-current="true"{/if}>
          <span class="relative block aspect-[16/10] w-full overflow-hidden bg-base-200">
            {if $theme['thumbnail']}
              <img class="absolute inset-0 size-full object-cover" src="{$system['system_url']}/{$theme['thumbnail']}" alt="{$theme['title']}" loading="lazy">
            {else}
              <span class="absolute inset-0 flex items-center justify-center text-base-content/40">
                <span class="icon-[tabler--photo-off] size-7" aria-hidden="true"></span>
              </span>
            {/if}
          </span>
          <span class="flex items-center justify-between gap-2 border-t border-base-300 p-3">
            <span class="min-w-0 truncate text-sm font-medium capitalize" title="{$theme['title']}">{$theme['title']}</span>
            {if $theme['active']}
              <span class="icon-[tabler--circle-check-filled] size-5 shrink-0 text-primary" aria-hidden="true"></span>
            {/if}
          </span>
        </a>
      {/foreach}
    </div>
  </section>
  <!-- themes -->

  {if !$system['newsfeed_public'] && $landings}
    <!-- landings -->
    <section class="flex flex-col gap-3" aria-labelledby="themes-demo-landings">
      <h3 id="themes-demo-landings" class="m-0 text-sm font-semibold">{__("Landing Pages")}</h3>
      {if $user->_logged_in}
        <div class="alert alert-soft alert-primary flex items-start gap-3 text-start" role="status">
          <span class="icon-[tabler--info-circle] size-5 shrink-0" aria-hidden="true"></span>
          <p class="min-w-0">{__("Sign out to preview the landing pages")}</p>
        </div>
      {/if}
      <div class="grid grid-cols-2 gap-4 sm:grid-cols-3">
        {foreach $landings as $landing}
          {if $user->_logged_in}
            <div class="flex flex-col overflow-hidden rounded-xl border border-base-300 bg-base-100 opacity-60" aria-disabled="true">
          {else}
            <a href="{$landing['url']}" rel="nofollow" class="group flex flex-col overflow-hidden rounded-xl border bg-base-100 transition hover:border-primary{if $landing['active']} border-primary ring-2 ring-primary/30{else} border-base-300{/if}" {if $landing['active']}aria-current="true"{/if}>
          {/if}
            <span class="relative block aspect-[16/10] w-full overflow-hidden bg-base-200">
              {if $landing['thumbnail']}
                <img class="absolute inset-0 size-full object-cover object-top" src="{$system['system_url']}/{$landing['thumbnail']}" alt="{$landing['title']}" loading="lazy">
              {else}
                <span class="absolute inset-0 flex items-center justify-center text-base-content/40">
                  <span class="icon-[tabler--photo-off] size-7" aria-hidden="true"></span>
                </span>
              {/if}
            </span>
            <span class="flex items-center justify-between gap-2 border-t border-base-300 p-3">
              <span class="min-w-0 truncate text-sm font-medium" title="{$landing['title']}">{$landing['title']}</span>
              {if $landing['active'] && !$user->_logged_in}
                <span class="icon-[tabler--circle-check-filled] size-5 shrink-0 text-primary" aria-hidden="true"></span>
              {/if}
            </span>
          {if $user->_logged_in}
            </div>
          {else}
            </a>
          {/if}
        {/foreach}
      </div>
    </section>
    <!-- landings -->
  {/if}
</div>
