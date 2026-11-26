{include file='_head.tpl'}
{include file='_header.tpl'}

{if $system['system_wallpaper_default'] || !$system['system_wallpaper']}
  {assign var="landing_wallpaper" value="{$system['system_url']}/content/themes/{$system['theme']}/images/landing/default/welcome.webp"}
{else}
  {assign var="landing_wallpaper" value="{$system['system_uploads']}/{$system['system_wallpaper']}"}
{/if}
{assign var="landing_avatars" value="{$system['system_url']}/content/themes/{$system['theme']}/images/landing/default/avatars"}

<!-- page content -->
<div class="min-h-dvh lg:grid lg:grid-cols-2">
  <!-- welcome -->
  <div class="relative flex min-h-64 flex-col justify-center bg-cover bg-center lg:sticky lg:top-0 lg:h-dvh" style="background-image: url('{$landing_wallpaper}');">
    <div class="absolute inset-0 bg-linear-to-t from-black/80 via-black/50 to-black/20 lg:bg-linear-to-r lg:from-black/80 lg:via-black/50 lg:to-black/25"></div>
    <div class="relative z-1 w-full max-w-xl px-6 py-10 text-start text-white sm:px-10 lg:px-14">
      <!-- welcome message -->
      {if $system['system_logo']}
        <img src="{$system['system_uploads']}/{if $system['system_logo_dark']}{$system['system_logo_dark']}{else}{$system['system_logo']}{/if}" class="mb-6 h-12 w-auto" alt="{__($system['system_title'])}">
      {/if}
      <p class="text-sm font-medium text-white/80">{__("Welcome to")} {__($system['system_title'])}</p>
      <h1 class="mt-3 text-3xl leading-tight font-semibold sm:text-4xl lg:text-5xl">{__($system['system_description'])}</h1>
      <!-- welcome message -->

      <!-- highlights -->
      <div class="mt-10 hidden flex-col gap-6 lg:flex">
        <div class="flex items-start gap-4">
          <div class="flex size-11 shrink-0 items-center justify-center rounded-xl bg-white/15 backdrop-blur-sm">
            <span class="icon-[tabler--users-group] size-6 text-white" aria-hidden="true"></span>
          </div>
          <div>
            <p class="font-semibold">{__("Connect with friends")}</p>
            <p class="mt-1 text-sm text-white/75">{__("Find the people you know and grow your circle every day")}</p>
          </div>
        </div>
        <div class="flex items-start gap-4">
          <div class="flex size-11 shrink-0 items-center justify-center rounded-xl bg-white/15 backdrop-blur-sm">
            <span class="icon-[tabler--messages] size-6 text-white" aria-hidden="true"></span>
          </div>
          <div>
            <p class="font-semibold">{__("Chat in real time")}</p>
            <p class="mt-1 text-sm text-white/75">{__("Messages, calls and group conversations without leaving the page")}</p>
          </div>
        </div>
        <div class="flex items-start gap-4">
          <div class="flex size-11 shrink-0 items-center justify-center rounded-xl bg-white/15 backdrop-blur-sm">
            <span class="icon-[tabler--photo-heart] size-6 text-white" aria-hidden="true"></span>
          </div>
          <div>
            <p class="font-semibold">{__("Share what's new")}</p>
            <p class="mt-1 text-sm text-white/75">{__("Photos, videos and life moments with the people who matter")}</p>
          </div>
        </div>
      </div>
      <!-- highlights -->

      <!-- members -->
      <div class="mt-10 hidden items-center gap-4 lg:flex">
        <div class="avatar-group -space-x-4">
          <div class="avatar">
            <div class="size-11 ring-2 ring-white/60">
              <img src="{$landing_avatars}/1.webp" alt="" loading="lazy">
            </div>
          </div>
          <div class="avatar">
            <div class="size-11 ring-2 ring-white/60">
              <img src="{$landing_avatars}/2.webp" alt="" loading="lazy">
            </div>
          </div>
          <div class="avatar">
            <div class="size-11 ring-2 ring-white/60">
              <img src="{$landing_avatars}/3.webp" alt="" loading="lazy">
            </div>
          </div>
          <div class="avatar">
            <div class="size-11 ring-2 ring-white/60">
              <img src="{$landing_avatars}/4.webp" alt="" loading="lazy">
            </div>
          </div>
        </div>
        <p class="text-sm text-white/80">{__("Join the community and start sharing today")}</p>
      </div>
      <!-- members -->
    </div>
  </div>
  <!-- welcome -->

  <!-- sign form -->
  <div class="flex flex-col bg-base-100 lg:min-h-dvh">
    <div class="mx-auto flex w-full max-w-md flex-1 flex-col justify-center px-6 py-12 sm:px-8">
      {include file='__sign_form.default.tpl' do="in"}

      {if $system['play_store_badge_enabled'] || $system['appgallery_badge_enabled'] || $system['app_store_badge_enabled']}
        <div class="mt-10 flex flex-wrap items-center justify-center gap-3">
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
  <!-- sign form -->
</div>
<!-- page content -->

{include file='_footer.tpl'}
