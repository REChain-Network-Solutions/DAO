{include file='_head.tpl'}
{include file='_header.tpl'}

{if $system['system_wallpaper_default'] || !$system['system_wallpaper']}
  {assign var="landing_wallpaper" value="{$system['system_url']}/content/themes/{$system['theme']}/images/landing/aurora/welcome.webp"}
{else}
  {assign var="landing_wallpaper" value="{$system['system_uploads']}/{$system['system_wallpaper']}"}
{/if}

<!-- page content -->
<div class="relative flex min-h-dvh flex-col bg-cover bg-center" style="background-image: url('{$landing_wallpaper}');">
  <div class="absolute inset-0 bg-linear-to-t from-black/80 via-black/45 to-black/30 lg:bg-linear-to-r lg:from-black/80 lg:via-black/45 lg:to-black/20 lg:rtl:bg-linear-to-l"></div>

  <div class="relative z-1 flex flex-1 flex-col">
    <div class="w-full mx-auto px-4 sm:px-6{if !$system['fluid_design']} max-w-7xl{/if} flex w-full flex-1 flex-col items-center justify-center gap-10 py-12 lg:flex-row lg:justify-between lg:gap-16">

      <!-- welcome -->
      <div class="w-full max-w-xl text-white lg:w-auto lg:flex-1">
        {if $system['system_logo']}
          <img src="{$system['system_uploads']}/{if $system['system_logo_dark']}{$system['system_logo_dark']}{else}{$system['system_logo']}{/if}" class="mb-8 h-12 w-auto" alt="{__($system['system_title'])}">
        {else}
          <img src="{$system['system_url']}/content/themes/{$system['theme']}/images/favicon.png" class="mb-8 h-12 w-auto" alt="{__($system['system_title'])}">
        {/if}
        <p class="text-sm font-medium text-white/80">{__("Welcome to")} {__($system['system_title'])}</p>
        <h1 class="mt-3 text-3xl leading-tight font-semibold sm:text-4xl lg:text-5xl">{__($system['system_description'])}</h1>
        <p class="mt-5 text-lg text-white/80">{__("Share what's new and life moments with your friends")}</p>
      </div>
      <!-- welcome -->

      <!-- sign form -->
      <div class="w-full max-w-md shrink-0 rounded-box bg-base-100 p-6 shadow-2xl sm:p-8">
        {include file='__sign_form.aurora.tpl' do="in"}

        {if $system['play_store_badge_enabled'] || $system['appgallery_badge_enabled'] || $system['app_store_badge_enabled']}
          <div class="mt-8 flex flex-wrap items-center justify-center gap-3">
            {if $system['play_store_badge_enabled']}
              <a href="{$system['play_store_link']}" target="_blank">
                {include file='__svg_icons.tpl' icon="playstore_badge" height="48px"}
              </a>
            {/if}
            {if $system['appgallery_badge_enabled']}
              <a href="{$system['appgallery_store_link']}" target="_blank">
                {include file='__svg_icons.tpl' icon="appgallery_badge" height="48px"}
              </a>
            {/if}
            {if $system['app_store_badge_enabled']}
              <a href="{$system['app_store_link']}" target="_blank">
                {include file='__svg_icons.tpl' icon="appstore_badge" height="48px"}
              </a>
            {/if}
          </div>
        {/if}
      </div>
      <!-- sign form -->

    </div>

    {include file='_footer.links.tpl' _overlay=true}
  </div>
</div>
<!-- page content -->

{include file='_footer.tpl'}
