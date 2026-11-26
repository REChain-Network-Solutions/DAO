{include file='_head.tpl'}
{include file='_header.tpl'}

<!-- page content -->
<div class="flex min-h-dvh flex-col bg-[#fff1d6] bg-[radial-gradient(#11111114_1.5px,transparent_1.5px)] bg-size-[22px_22px] text-[#111] dark:bg-[#0b0724] dark:bg-[radial-gradient(#22d3ee2e_1.5px,transparent_1.5px)] dark:text-[#f8f5ff]">
  <div class="flex flex-1 items-center justify-center p-6">
    <!-- card -->
    <div class="w-full max-w-[400px] rounded-[14px] border-[3px] border-[#111] bg-white px-[34px] py-[38px] shadow-[8px_8px_0_#111] max-sm:px-6 dark:border-[#22d3ee] dark:bg-[#1a0b3d] dark:shadow-[8px_8px_0_#ff2e97]">
      {include file='__sign_form.retro.tpl' do="in"}

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
    <!-- card -->
  </div>

  {include file='_footer.links.tpl'}
</div>
<!-- page content -->

{include file='_footer.tpl'}
