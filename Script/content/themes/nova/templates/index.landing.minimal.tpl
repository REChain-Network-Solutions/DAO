{include file='_head.tpl'}
{include file='_header.tpl'}

<!-- page content -->
<div class="flex min-h-dvh flex-col bg-base-200">
  <div class="flex flex-1 flex-col items-center justify-center gap-8 px-4 py-12 sm:px-6 lg:px-8">
    <!-- sign card -->
    <div class="relative flex w-full max-w-md flex-col items-center gap-6 overflow-hidden rounded-xl bg-base-100 px-6 py-12 shadow-md shadow-base-300/20 sm:px-8">
      <div class="absolute top-0 h-52 w-full bg-linear-to-b from-primary/10 to-transparent to-45%"></div>
      {if $system['system_logo']}
        <img class="relative z-1 h-9 w-auto object-contain dark:hidden" src="{$system['system_uploads']}/{$system['system_logo']}" alt="{__($system['system_title'])}">
        <img class="relative z-1 hidden h-9 w-auto object-contain dark:block" src="{$system['system_uploads']}/{if $system['system_logo_dark']}{$system['system_logo_dark']}{else}{$system['system_logo']}{/if}" alt="{__($system['system_title'])}">
      {else}
        <img class="relative z-1 size-9 object-contain" src="{$system['system_url']}/content/themes/{$system['theme']}/images/favicon.png" alt="{__($system['system_title'])}">
      {/if}

      {include file='__sign_form.minimal.tpl' do="in" _social_style="minimal"}
    </div>
    <!-- sign card -->

    {if $system['play_store_badge_enabled'] || $system['appgallery_badge_enabled'] || $system['app_store_badge_enabled']}
      <div class="flex flex-wrap items-center justify-center gap-3">
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

  {include file='_footer.links.tpl'}
</div>
<!-- page content -->

{include file='_footer.tpl'}
