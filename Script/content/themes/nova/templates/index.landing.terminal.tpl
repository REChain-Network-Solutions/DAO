{include file='_head.tpl'}
{include file='_header.tpl'}

<!-- page content -->
<div class="flex min-h-dvh flex-col bg-[#f4f1e6] bg-[linear-gradient(rgba(21,128,61,.05)_1px,transparent_1px)] bg-size-[100%_3px] font-mono dark:bg-[#0a0e0a] dark:bg-[linear-gradient(rgba(74,222,128,.04)_1px,transparent_1px)]">
  <div class="flex flex-1 items-center justify-center p-6">
    <!-- terminal -->
    <div class="w-full max-w-[460px] overflow-hidden rounded-xl border border-[#d8d3c0] bg-[#fbfaf4] shadow-[0_0_60px_rgba(21,128,61,.10)] dark:border-[#1d2b1d] dark:bg-[#0d130d] dark:shadow-[0_0_60px_rgba(74,222,128,.12)]">
      <!-- title bar -->
      <div class="flex items-center gap-[7px] border-b border-[#d8d3c0] bg-[#efebdf] px-3.5 py-[11px] dark:border-[#1d2b1d] dark:bg-[#111a11]">
        <span class="size-[11px] shrink-0 rounded-full bg-red-400" aria-hidden="true"></span>
        <span class="size-[11px] shrink-0 rounded-full bg-amber-400" aria-hidden="true"></span>
        <span class="size-[11px] shrink-0 rounded-full bg-emerald-400" aria-hidden="true"></span>
        <span class="ms-2 truncate text-[.75rem] tracking-[.04em] text-[#7d8b6f] dark:text-[#3f513f]" title="guest@{__($system['system_title'])|strtolower}: ~/auth">guest@{__($system['system_title'])|strtolower}: ~/auth</span>
      </div>
      <!-- title bar -->

      <div class="px-[26px] pt-[26px] pb-8">
        {include file='__sign_form.terminal.tpl' do="in"}

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
    </div>
    <!-- terminal -->
  </div>

  {include file='_footer.links.tpl'}
</div>
<!-- page content -->

{include file='_footer.tpl'}
