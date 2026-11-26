{assign var="is_default_landing" value=($theme_landing['is_default'] == '1' || $theme_landing['slug'] == 'default')}
{assign var="landing_slug" value=$theme_landing['slug']|default:''}
{if $is_default_landing}
  {assign var="landing_slug" value="default"}
{/if}
{assign var="landing_active" value=($active_landing == $landing_slug || ($is_default_landing && ($active_landing == '' || $active_landing == 'default')))}
{assign var="has_light_thumb" value=($theme_landing['thumbnail_light'] != '')}
{assign var="has_dark_thumb" value=($theme_landing['thumbnail_dark'] != '')}
{assign var="has_landing_thumbs" value=($has_light_thumb || $has_dark_thumb)}
{if $system['theme_mode_night']}
  {assign var="landing_thumb_mode" value="dark"}
{else}
  {assign var="landing_thumb_mode" value="light"}
{/if}
<div class="admin-theme-landing-option js_theme-landing-option group flex flex-col p-0" data-landing-index="{$landing_index}">
  <span class="admin-theme-landing-option-media js_theme-landing-thumbs" data-thumb-mode="{$landing_thumb_mode}">
    <label class="admin-theme-landing-thumbs-select" for="theme-landing-active-{$landing_index}">
      {if $has_landing_thumbs}
        <span class="admin-theme-landing-thumbs-track js_theme-landing-thumb-track">
          <span class="admin-theme-landing-thumb-slide js_theme-landing-thumb-slide" data-mode="light">
            {if $has_light_thumb}
              <img src="{$system['system_url']}/{$theme_landing['thumbnail_light']}" alt="{$theme_landing['title']|default:$landing_slug} {__("preview")}" loading="lazy">
            {else}
              <span class="admin-theme-landing-thumb-fallback">
                <span class="icon-[tabler--photo-off] size-7" aria-hidden="true"></span>
              </span>
            {/if}
          </span>
          <span class="admin-theme-landing-thumb-slide js_theme-landing-thumb-slide" data-mode="dark">
            {if $has_dark_thumb}
              <img src="{$system['system_url']}/{$theme_landing['thumbnail_dark']}" alt="{$theme_landing['title']|default:$landing_slug} {__("preview")}" loading="lazy">
            {else}
              <span class="admin-theme-landing-thumb-fallback">
                <span class="icon-[tabler--photo-off] size-7" aria-hidden="true"></span>
              </span>
            {/if}
          </span>
        </span>
      {else}
        <span class="admin-theme-landing-thumb-fallback">
          <span class="icon-[tabler--photo-off] size-7" aria-hidden="true"></span>
        </span>
      {/if}
    </label>
    {if $has_landing_thumbs}
      <button type="button" class="admin-theme-landing-thumb-mode js_theme-landing-thumb-mode" aria-label="{if $landing_thumb_mode == 'dark'}{__("Day Mode")}{else}{__("Night Mode")}{/if}">
        <span class="admin-theme-landing-thumb-sun icon-[tabler--sun] size-4" aria-hidden="true"></span>
        <span class="admin-theme-landing-thumb-moon icon-[tabler--moon] size-4" aria-hidden="true"></span>
      </button>
    {/if}
  </span>
  <label class="flex items-center justify-between gap-2 border-t border-base-300 p-3" for="theme-landing-active-{$landing_index}">
    <span class="min-w-0 truncate text-sm font-medium" title="{$theme_landing['title']|default:$landing_slug}">{$theme_landing['title']|default:$landing_slug}</span>
    <span class="icon-[tabler--circle-check-filled] size-5 shrink-0 text-success opacity-0 group-has-checked:opacity-100" aria-hidden="true"></span>
  </label>
  <input id="theme-landing-active-{$landing_index}" type="radio" name="landing" value="{$landing_slug}" class="radio hidden" {if $landing_active}checked{/if}>
</div>
