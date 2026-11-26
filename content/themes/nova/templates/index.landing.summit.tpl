{include file='_head.tpl'}
{include file='_header.tpl'}

{if $system['system_wallpaper_default'] || !$system['system_wallpaper']}
  {assign var="landing_wallpaper" value="{$system['system_url']}/content/themes/{$system['theme']}/images/landing/summit/welcome.webp"}
{else}
  {assign var="landing_wallpaper" value="{$system['system_uploads']}/{$system['system_wallpaper']}"}
{/if}

<!-- page content -->
<div class="relative isolate flex min-h-dvh flex-col overflow-hidden bg-base-100">

  <!-- wallpaper -->
  <div class="absolute inset-0 -z-10 bg-base-300 bg-cover bg-[position:center_40%] lg:start-[35%]" style="background-image: url('{$landing_wallpaper}');" aria-hidden="true"></div>
  <div class="absolute inset-0 -z-10 bg-linear-to-t from-base-100 from-60% to-base-100/30 lg:bg-linear-to-r lg:from-40% lg:via-base-100/45 lg:via-55% lg:to-base-100/10 lg:rtl:bg-linear-to-l" aria-hidden="true"></div>
  <svg class="pointer-events-none absolute inset-y-0 end-[calc(50%-150px)] -z-10 h-full w-[300px] text-base-content/25 max-lg:hidden rtl:-scale-x-100" viewBox="0 0 300 1000" preserveAspectRatio="none" aria-hidden="true">
    <path d="M150 0C60 120 210 250 120 380C50 480 190 560 110 690C50 790 170 880 90 1000" fill="none" stroke="currentColor" stroke-width="1.5" stroke-dasharray="6 7" vector-effect="non-scaling-stroke" />
  </svg>
  <!-- wallpaper -->

  <!-- sign form -->
  <div class="flex flex-1 flex-col justify-center px-6 py-10 sm:px-10 lg:w-1/2 lg:ps-[6vw] lg:pe-10">
    <div class="flex w-full max-w-[460px] flex-col gap-10">
      <header>
        <a class="flex min-w-0 items-center gap-3" href="{$system['system_url']}">
          {if $system['system_logo']}
            <img class="h-9 w-auto dark:hidden" src="{$system['system_uploads']}/{$system['system_logo']}" alt="{__($system['system_title'])}">
            <img class="hidden h-9 w-auto dark:block" src="{$system['system_uploads']}/{if $system['system_logo_dark']}{$system['system_logo_dark']}{else}{$system['system_logo']}{/if}" alt="{__($system['system_title'])}">
          {else}
            <img class="size-9 shrink-0 rounded-lg object-cover" src="{$system['system_url']}/content/themes/{$system['theme']}/images/favicon.png" alt="">
            <span class="truncate text-lg font-bold text-base-content" title="{__($system['system_title'])}.">{__($system['system_title'])}<span class="text-primary">.</span></span>
          {/if}
        </a>
      </header>

      <main>
        {include file='__sign_form.summit.tpl' do=$_summit_do|default:'in'}

        {if $system['play_store_badge_enabled'] || $system['appgallery_badge_enabled'] || $system['app_store_badge_enabled']}
          <div class="mt-8 flex flex-wrap items-center gap-3">
            {if $system['play_store_badge_enabled']}
              <a href="{$system['play_store_link']}" target="_blank" rel="noopener noreferrer" aria-label="{__("Google Play")}">
                {include file='__svg_icons.tpl' icon="playstore_badge" height="44px"}
              </a>
            {/if}
            {if $system['appgallery_badge_enabled']}
              <a href="{$system['appgallery_store_link']}" target="_blank" rel="noopener noreferrer" aria-label="{__("AppGallery")}">
                {include file='__svg_icons.tpl' icon="appgallery_badge" height="44px"}
              </a>
            {/if}
            {if $system['app_store_badge_enabled']}
              <a href="{$system['app_store_link']}" target="_blank" rel="noopener noreferrer" aria-label="{__("App Store")}">
                {include file='__svg_icons.tpl' icon="appstore_badge" height="44px"}
              </a>
            {/if}
          </div>
        {/if}
      </main>

      {include file='_footer.links.tpl' _bare=true}
    </div>
  </div>
  <!-- sign form -->
</div>
<!-- page content -->

{include file='_footer.tpl' _footer_links_rendered=true}
