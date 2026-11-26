{assign var="is_default_landing" value=($theme_landing['is_default'] == '1' || $theme_landing['slug'] == 'default')}
{assign var="landing_slug" value=$theme_landing['slug']|default:''}
{if $is_default_landing}
  {assign var="landing_slug" value="default"}
{/if}
{assign var="landing_active" value=($active_landing == $landing_slug || ($is_default_landing && ($active_landing == '' || $active_landing == 'default')))}
{if $system['theme_mode_night']}
  {assign var="landing_thumb" value=$theme_landing['thumbnail_dark']|default:$theme_landing['thumbnail_light']}
{else}
  {assign var="landing_thumb" value=$theme_landing['thumbnail_light']|default:$theme_landing['thumbnail_dark']}
{/if}
<article class="js_theme-landing-row flex flex-col gap-4 rounded-[14px] border border-base-300 p-3 lg:flex-row lg:items-center" data-landing-index="{$landing_index}">
  <input type="hidden" name="landings[{$landing_index}][id]" value="{$theme_landing['landing_id']}">
  <input type="hidden" name="landings[{$landing_index}][is_default]" value="{if $is_default_landing}1{else}0{/if}">
  <div class="flex aspect-[16/10] w-full shrink-0 items-center justify-center overflow-hidden rounded-lg border border-base-300 bg-base-200 text-base-content/40 sm:w-40 lg:w-32">
    {if $landing_thumb}
      <img class="size-full object-cover object-top" src="{$system['system_url']}/{$landing_thumb}" alt="{$theme_landing['title']|default:$landing_slug} {__("preview")}" loading="lazy">
    {else}
      <span class="icon-[tabler--photo-off] size-6" aria-hidden="true"></span>
    {/if}
  </div>
  <div class="grid min-w-0 flex-1 grid-cols-1 items-start gap-4 sm:grid-cols-2">
    <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
      <label class="label-text" for="theme-landing-title-{$landing_index}">{__("Title")}</label>
      <div class="admin-setting-control flex min-w-0 flex-col gap-2">
        <input type="text" class="input w-full" name="landings[{$landing_index}][title]" id="theme-landing-title-{$landing_index}" value="{$theme_landing['title']}" autocomplete="off">
      </div>
    </div>
    <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
      <label class="label-text" for="theme-landing-slug-{$landing_index}">{__("Slug")}</label>
      {if $is_default_landing}
        <div class="admin-setting-control flex min-w-0 flex-col gap-2">
          <input type="hidden" name="landings[{$landing_index}][slug]" value="default">
          <input type="text" class="input w-full" id="theme-landing-slug-{$landing_index}" value="index.landing.tpl" disabled>
        </div>
      {else}
        <div class="admin-setting-control join w-full min-w-0" dir="ltr">
          <span class="join-item hidden sm:flex min-w-10 shrink-0 items-center justify-center border border-e-0 border-base-300 bg-base-200 px-3 text-sm text-base-content/60 [[data-theme=admin-dark]_&]:border-base-content/30">index.landing.</span>
          <input type="text" class="input join-item min-w-0 flex-1 js_theme-landing-slug" name="landings[{$landing_index}][slug]" id="theme-landing-slug-{$landing_index}" value="{$landing_slug}" autocomplete="off">
        </div>
      {/if}
    </div>
  </div>
  <div class="flex shrink-0 items-center justify-end gap-2 lg:w-28">
    <span class="js_theme-landing-badge badge badge-soft badge-success{if !$landing_active} hidden{/if}">
      <span class="icon-[tabler--circle-check-filled] size-4" aria-hidden="true"></span>
      {__("Active")}
    </span>
    {if !$is_default_landing}
      <button type="button" class="btn btn-text btn-square btn-sm js_remove-theme-landing" aria-label="{__("Delete")}" title="{__("Delete")}">
        <span class="icon-[tabler--trash] size-4" aria-hidden="true"></span>
      </button>
    {/if}
  </div>
</article>
