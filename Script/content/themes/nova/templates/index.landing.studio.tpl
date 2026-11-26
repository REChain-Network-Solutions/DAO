{include file='_head.tpl'}
{include file='_header.tpl'}

{assign var="studio_images" value="{$system['system_url']}/content/themes/{$system['theme']}/images/landing/studio"}
{if $system['system_wallpaper_default'] || !$system['system_wallpaper']}
  {assign var="studio_wallpaper" value="{$studio_images}/slide-1.webp"}
{else}
  {assign var="studio_wallpaper" value="{$system['system_uploads']}/{$system['system_wallpaper']}"}
{/if}

<!-- page content -->
<div class="min-h-dvh bg-base-100 lg:grid lg:grid-cols-2">

  <!-- showcase -->
  <div class="relative h-80 overflow-hidden bg-neutral sm:h-96 lg:sticky lg:top-0 lg:h-dvh lg:self-start">
    <div data-carousel='{ "loadingClasses": "opacity-0", "isAutoPlay": true, "isInfiniteLoop": true, "speed": 6000, "isRTL": {if $system['language']['dir'] == "RTL"}true{else}false{/if}, "dotsItemClasses": "h-1 w-8 cursor-pointer rounded-full bg-white/40 transition-all duration-300 carousel-active:w-12 carousel-active:bg-white" }' class="relative h-full">
      <div class="carousel h-full rounded-none">
        <div class="carousel-body h-full opacity-0">
          <!-- slide -->
          <div class="carousel-slide relative h-full">
            <div class="absolute inset-0 bg-cover bg-center" style="background-image: url('{$studio_wallpaper}');" aria-hidden="true"></div>
            <div class="absolute inset-0 bg-linear-to-t from-black/85 via-black/35 via-45% to-transparent to-70%" aria-hidden="true"></div>
            <div class="absolute inset-x-0 bottom-0 px-8 pb-16 text-white sm:px-12 sm:pb-20 lg:pb-24">
              <h2 class="text-3xl font-bold tracking-tight sm:text-4xl lg:text-5xl">{__("Create your vision")}</h2>
              <p class="mt-3 max-w-md text-white/80 sm:text-lg">{__("Share what you make with people who get it.")}</p>
            </div>
          </div>
          <!-- slide -->
          <!-- slide -->
          <div class="carousel-slide relative h-full">
            <div class="absolute inset-0 bg-cover bg-[position:45%_center]" style="background-image: url('{$studio_images}/slide-2.webp');" aria-hidden="true"></div>
            <div class="absolute inset-0 bg-linear-to-t from-black/85 via-black/35 via-45% to-transparent to-70%" aria-hidden="true"></div>
            <div class="absolute inset-x-0 bottom-0 px-8 pb-16 text-white sm:px-12 sm:pb-20 lg:pb-24">
              <h2 class="text-3xl font-bold tracking-tight sm:text-4xl lg:text-5xl">{__("Play together")}</h2>
              <p class="mt-3 max-w-md text-white/80 sm:text-lg">{__("Find your crew and jump into what you love.")}</p>
            </div>
          </div>
          <!-- slide -->
          <!-- slide -->
          <div class="carousel-slide relative h-full">
            <div class="absolute inset-0 bg-cover bg-[position:58%_center]" style="background-image: url('{$studio_images}/slide-3.webp');" aria-hidden="true"></div>
            <div class="absolute inset-0 bg-linear-to-t from-black/85 via-black/35 via-45% to-transparent to-70%" aria-hidden="true"></div>
            <div class="absolute inset-x-0 bottom-0 px-8 pb-16 text-white sm:px-12 sm:pb-20 lg:pb-24">
              <h2 class="text-3xl font-bold tracking-tight sm:text-4xl lg:text-5xl">{__("Bring your world to life")}</h2>
              <p class="mt-3 max-w-md text-white/80 sm:text-lg">{__("Groups, pages and moments that feel like yours.")}</p>
            </div>
          </div>
          <!-- slide -->
        </div>
      </div>
      <div class="carousel-pagination absolute bottom-7 start-8 flex gap-2 sm:bottom-9 sm:start-12 lg:bottom-12"></div>
    </div>

    <!-- logo -->
    <a class="absolute start-8 top-8 z-10 flex min-w-0 items-center gap-3 sm:start-12 sm:top-10" href="{$system['system_url']}">
      {if $system['system_logo']}
        <img class="h-9 w-auto" src="{$system['system_uploads']}/{if $system['system_logo_dark']}{$system['system_logo_dark']}{else}{$system['system_logo']}{/if}" alt="{__($system['system_title'])}">
      {else}
        <img class="size-9 shrink-0 rounded-lg object-cover" src="{$system['system_url']}/content/themes/{$system['theme']}/images/favicon.png" alt="">
        <span class="truncate text-lg font-bold text-white" title="{__($system['system_title'])}">{__($system['system_title'])}</span>
      {/if}
    </a>
    <!-- logo -->
  </div>
  <!-- showcase -->

  <!-- sign form -->
  <div class="flex flex-col px-6 sm:px-10 lg:min-h-dvh">
    <main class="flex flex-1 items-center justify-center py-12">
      <div class="w-full max-w-[440px]">
        {include file='__sign_form.studio.tpl' do=$_studio_do|default:'in'}

        {if $system['play_store_badge_enabled'] || $system['appgallery_badge_enabled'] || $system['app_store_badge_enabled']}
          <div class="mt-8 flex flex-wrap items-center justify-center gap-3">
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
      </div>
    </main>
    <div class="mx-auto w-full max-w-[440px] pb-8">
      {include file='_footer.links.tpl' _bare=true}
    </div>
  </div>
  <!-- sign form -->
</div>
<!-- page content -->

{include file='_footer.tpl' _footer_links_rendered=true}
