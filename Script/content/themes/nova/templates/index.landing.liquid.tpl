{include file='_head.tpl'}
{include file='_header.tpl'}

<!-- page content -->
<div class="relative isolate flex min-h-dvh flex-col overflow-hidden bg-linear-to-br from-[#f4e9ff] via-[#e7f1fc] to-[#f7f3ea] dark:from-[#2a1b52] dark:via-[#0f2036] dark:to-[#07131f]">
  <!-- wash -->
  <div class="pointer-events-none absolute inset-0 -z-10 overflow-hidden" aria-hidden="true">
    <div class="absolute start-[8%] top-[-8%] size-[28rem] rounded-full bg-amber-400/60 blur-3xl dark:bg-amber-400/75"></div>
    <div class="absolute end-[5%] top-[10%] size-[24rem] rounded-full bg-pink-500/50 blur-3xl dark:bg-pink-500/60"></div>
    <div class="absolute bottom-[-12%] left-1/2 size-[32rem] -translate-x-1/2 rounded-full bg-cyan-400/45 blur-3xl dark:bg-cyan-400/55"></div>
    <div class="absolute inset-0 bg-linear-to-b from-white/30 to-white/60 dark:from-[#060c16]/30 dark:to-[#060c16]/60"></div>
  </div>
  <!-- wash -->

  <main class="relative z-1 grid w-full flex-1 place-items-center px-5 py-7">
    <div class="w-full max-w-sm text-center">
      <a class="mb-6 inline-flex max-w-full items-center justify-center gap-2.5 text-lg font-extrabold tracking-tight text-base-content!" href="{$system['system_url']}" aria-label="{__($system['system_title'])}">
        {if $system['system_logo']}
          <img class="max-h-10 max-w-40 object-contain dark:hidden" src="{$system['system_uploads']}/{$system['system_logo']}" alt="{__($system['system_title'])}">
          <img class="hidden max-h-10 max-w-40 object-contain dark:block" src="{$system['system_uploads']}/{if $system['system_logo_dark']}{$system['system_logo_dark']}{else}{$system['system_logo']}{/if}" alt="{__($system['system_title'])}">
        {else}
          <img class="size-9 rounded-lg object-contain" src="{$system['system_url']}/content/themes/{$system['theme']}/images/favicon.png" alt="">
          <span>{__($system['system_title'])}</span>
        {/if}
      </a>

      <div class="rounded-box border border-base-content/10 bg-white/70 p-6 text-start shadow-2xl backdrop-blur-lg sm:p-8 dark:bg-[#0c1220]/60">
        {include file='__sign_form.default.tpl' do="in" _liquid_form=true}
      </div>
    </div>
  </main>

  {include file='_footer.links.tpl'}
</div>
<!-- page content -->

{include file='_footer.tpl'}
