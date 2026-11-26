{include file='_head.tpl'}
{include file='_header.tpl'}

{assign var="orbit_avatars" value="{$system['system_url']}/content/themes/{$system['theme']}/images/landing/default/avatars"}

<!-- page content -->
<div class="flex min-h-dvh flex-col overflow-hidden bg-[#f4f6ef] text-[#171b15] dark:bg-[#111310] dark:text-[#f5f7f0]">
  <header class="relative z-10 flex min-h-[4.7rem] items-center py-2.5 max-md:min-h-[3.8rem] max-md:py-2 w-full mx-auto max-w-7xl px-4 sm:px-6">
    <a class="inline-flex min-w-0 items-center gap-2.5 text-[1.3rem] font-extrabold tracking-tight max-[420px]:gap-2 max-[420px]:text-lg" href="{$system['system_url']}">
      {if $system['system_logo']}
        <img class="max-h-[2.7rem] max-w-40 object-contain dark:hidden max-[420px]:max-w-[7.5rem]" src="{$system['system_uploads']}/{$system['system_logo']}" alt="{__($system['system_title'])}">
        <img class="hidden max-h-[2.7rem] max-w-40 object-contain dark:block max-[420px]:max-w-[7.5rem]" src="{$system['system_uploads']}/{if $system['system_logo_dark']}{$system['system_logo_dark']}{else}{$system['system_logo']}{/if}" alt="{__($system['system_title'])}">
      {else}
        <img class="size-10 shrink-0 rounded-[0.65rem] object-cover max-[420px]:size-8" src="{$system['system_url']}/content/themes/{$system['theme']}/images/favicon.png" alt="">
        <span class="truncate" title="{__($system['system_title'])}">{__($system['system_title'])}</span>
      {/if}
    </a>
  </header>

  <main class="flex min-h-0 flex-1">
    <!-- hero -->
    <section class="relative grid min-h-0 flex-1 items-center gap-6 py-2 md:grid-cols-[minmax(0,1.15fr)_minmax(21rem,0.85fr)] md:gap-[clamp(1.5rem,4vw,5rem)] md:pt-2 md:pb-4 max-md:flex max-md:flex-col max-md:items-stretch max-md:gap-3 max-md:py-1.5 w-full mx-auto max-w-7xl px-4 sm:px-6" aria-labelledby="orbit-hero-title">
      <div class="pointer-events-none absolute -start-80 -top-64 size-[45rem] rounded-full border border-[#d9dfd4]/50 dark:border-[#393f37]/50" aria-hidden="true"></div>

      <div class="relative z-1 min-w-0 max-h-full max-md:shrink-0">
        <div class="inline-flex items-center gap-2.5 text-[0.82rem] font-semibold text-[#667063] max-md:hidden dark:text-[#aab2a5]">
          <span class="size-2 rounded-full bg-[#c9eb00] shadow-[0_0_0_0.3rem_#e7f5a8] dark:bg-[#dcff08] dark:shadow-[0_0_0_0.3rem_#334016]" aria-hidden="true"></span>
          {__("A place to stay close")}
        </div>
        <h1 id="orbit-hero-title" class="mt-3 max-w-[19ch] text-[clamp(2.35rem,3.1vw,3.7rem)] leading-[1.08] font-extrabold tracking-[-0.06em] [overflow-wrap:anywhere] max-md:mt-0 max-md:max-w-none max-md:text-[clamp(1.5rem,5vw,2.1rem)] max-[420px]:text-2xl">{if $system['system_description']}{__($system['system_description'])}{else}{__("Welcome to")} {__($system['system_title'])}{/if}</h1>
        <p class="mt-3.5 max-w-[35rem] text-[0.93rem] leading-normal text-[#667063] max-md:hidden dark:text-[#aab2a5]">{__("Share the moments that matter, follow the people you care about, and make room for new connections.")}</p>
        <div class="mt-4 max-md:hidden">
          <a class="group inline-flex min-h-12 items-center justify-center gap-5 rounded-full bg-[#c9eb00] px-5 py-2.5 text-sm font-bold text-[#151a0c]! transition-colors hover:bg-[#e2ff31] dark:bg-[#dcff08]" href="{$system['system_url']}/signup">{__("Get started")}<span class="inline-block transition-transform group-hover:translate-x-0.5 group-hover:-translate-y-0.5 motion-reduce:transition-none icon-[tabler--arrow-up-right] size-5" aria-hidden="true"></span></a>
        </div>

        <!-- community collage -->
        <div class="relative isolate mt-3.5 hidden h-[clamp(10rem,22vh,13rem)] max-w-[35rem] md:block" aria-hidden="true">
          <div class="absolute start-4 top-8 h-40 w-[27rem] -rotate-[23deg] rounded-full border border-[#d9dfd4] dark:border-[#393f37]"></div>
          <div class="absolute start-20 top-16 h-28 w-72 -rotate-[23deg] rounded-full border border-[#d9dfd4] dark:border-[#393f37]"></div>
          <div class="absolute start-6 top-1 w-[min(18rem,72%)] -rotate-[4deg] rounded-[1.25rem] border border-[#d9dfd4] bg-white p-3.5 shadow-[0_1rem_3rem_rgb(30_45_19_/_9%)] dark:border-[#393f37] dark:bg-[#1d201b] dark:shadow-[0_1rem_3rem_rgb(0_0_0_/_25%)]">
            <div class="flex items-center gap-1.5 text-[0.68rem] font-semibold text-[#667063] dark:text-[#aab2a5]">
              <span class="icon-[tabler--sparkles] size-5 text-[#171b15] dark:text-[#f5f7f0]"></span>
              <span>{__("Your community")}</span>
              <span class="ms-auto icon-[tabler--dots] size-5"></span>
            </div>
            <div class="flex pt-2.5 ps-0.5">
              <img class="size-[2.6rem] -ms-0.5 rotate-[4deg] rounded-[0.85rem] border-2 border-white object-cover even:-translate-y-1 even:-rotate-[7deg] dark:border-[#1d201b]" src="{$orbit_avatars}/1.webp" alt="" width="56" height="56">
              <img class="size-[2.6rem] -ms-0.5 rotate-[4deg] rounded-[0.85rem] border-2 border-white object-cover even:-translate-y-1 even:-rotate-[7deg] dark:border-[#1d201b]" src="{$orbit_avatars}/2.webp" alt="" width="56" height="56">
              <img class="size-[2.6rem] -ms-0.5 rotate-[4deg] rounded-[0.85rem] border-2 border-white object-cover even:-translate-y-1 even:-rotate-[7deg] dark:border-[#1d201b]" src="{$orbit_avatars}/3.webp" alt="" width="56" height="56">
              <img class="size-[2.6rem] -ms-0.5 rotate-[4deg] rounded-[0.85rem] border-2 border-white object-cover even:-translate-y-1 even:-rotate-[7deg] dark:border-[#1d201b]" src="{$orbit_avatars}/4.webp" alt="" width="56" height="56">
            </div>
            <div class="mt-2.5 text-[0.95rem] font-bold tracking-tight">{__("Find your people")}</div>
            <div class="mt-0.5 text-[0.68rem] text-[#667063] dark:text-[#aab2a5]">{__("A place for every connection.")}</div>
            <div class="mt-2.5 grid gap-1.5">
              <span class="h-1.5 w-[90%] rounded-full bg-[#eef1e9] dark:bg-[#2a2e28]"></span>
              <span class="h-1.5 w-[62%] rounded-full bg-[#eef1e9] dark:bg-[#2a2e28]"></span>
            </div>
          </div>
          <div class="absolute end-6 top-12 z-1 flex min-h-[6.5rem] w-36 rotate-[8deg] flex-col justify-between rounded-2xl border border-[#d9dfd4] bg-white p-3 text-[0.72rem] leading-snug font-bold shadow-[0_1rem_3rem_rgb(30_45_19_/_9%)] dark:border-[#393f37] dark:bg-[#1d201b] dark:shadow-[0_1rem_3rem_rgb(0_0_0_/_25%)]">
            <span class="icon-[tabler--message-circle-heart] size-6"></span>
            <span>{__("Keep the conversation going")}</span>
          </div>
          <div class="absolute start-52 bottom-1 z-2 flex items-center gap-1.5 -rotate-[4deg] rounded-full bg-[#c9eb00] px-3 py-2 text-[0.66rem] font-bold text-[#151a0c] dark:bg-[#dcff08]">
            <span class="size-1.5 rounded-full bg-[#151a0c]"></span>
            {__("Share your world")}
          </div>
        </div>
        <!-- community collage -->
      </div>

      <!-- sign form -->
      <div class="relative z-1 flex h-full min-h-0 w-full max-w-[28.5rem] items-center justify-self-end max-md:max-w-[34rem] max-md:flex-1 max-md:self-center" id="orbit-auth">
        <div class="pointer-events-none absolute -inset-x-3 inset-y-4 hidden rotate-[3deg] rounded-[2.2rem] border border-[#d9dfd4] md:block dark:border-[#393f37]" aria-hidden="true"></div>
        <div class="relative w-full max-h-full overflow-y-auto rounded-[1.7rem] border border-[#d9dfd4] bg-white p-4 shadow-[0_1.5rem_4rem_rgb(30_45_19_/_9%)] max-md:h-full max-md:rounded-[1.3rem] md:p-6 dark:border-[#393f37] dark:bg-[#1d201b] dark:shadow-[0_1.5rem_4rem_rgb(0_0_0_/_25%)]">
          <div class="mb-4 flex items-center gap-2.5 text-xs font-bold text-[#667063] max-md:hidden dark:text-[#aab2a5]">
            <span class="grid size-7 place-items-center rounded-full bg-[#c9eb00] text-[#151a0c] dark:bg-[#dcff08]" aria-hidden="true"><span class="icon-[tabler--asterisk] size-5"></span></span>
            <span>{__("Your space starts here")}</span>
          </div>
          {include file='__sign_form.default.tpl' do="in" _plain_signin=true _plain_signup=true _submit_arrow=true}
          {if $system['play_store_badge_enabled'] || $system['appgallery_badge_enabled'] || $system['app_store_badge_enabled']}
            <div class="mt-4 flex flex-wrap items-center justify-center gap-2.5 border-t border-[#d9dfd4] pt-4 dark:border-[#393f37]">
              {if $system['play_store_badge_enabled']}
                <a href="{$system['play_store_link']}" target="_blank" rel="noopener noreferrer" aria-label="{__("Google Play")}">{include file='__svg_icons.tpl' icon="playstore_badge" height="46px"}</a>
              {/if}
              {if $system['appgallery_badge_enabled']}
                <a href="{$system['appgallery_store_link']}" target="_blank" rel="noopener noreferrer" aria-label="{__("AppGallery")}">{include file='__svg_icons.tpl' icon="appgallery_badge" height="46px"}</a>
              {/if}
              {if $system['app_store_badge_enabled']}
                <a href="{$system['app_store_link']}" target="_blank" rel="noopener noreferrer" aria-label="{__("App Store")}">{include file='__svg_icons.tpl' icon="appstore_badge" height="46px"}</a>
              {/if}
            </div>
          {/if}
        </div>
      </div>
      <!-- sign form -->
    </section>
    <!-- hero -->
  </main>

  {include file='_footer.links.tpl'}
</div>
<!-- page content -->

{include file='_footer.tpl'}
