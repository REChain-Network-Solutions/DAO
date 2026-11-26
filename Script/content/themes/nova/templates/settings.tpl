{include file='_head.tpl'}
{include file='_header.tpl'}

{* no .sg-offcanvas-sidebar here on purpose — core.js hides the header hamburger when the page has none *}

<!-- page content -->
<div class="pb-8 sm:pb-12">

  <div class="flex flex-col gap-4 lg:flex-row lg:items-start lg:gap-8">

    <!-- settings menu -->
    <button type="button" class="flex h-12 w-full items-center gap-3 rounded-2xl bg-base-100 px-4 text-sm font-medium text-base-content transition hover:bg-base-300 lg:hidden" aria-haspopup="dialog" aria-expanded="false" aria-controls="settings-drawer" data-overlay="#settings-drawer">
      <span class="icon-[tabler--menu-2] size-5 shrink-0 text-base-content/60" aria-hidden="true"></span>
      <span class="min-w-0 grow truncate text-start">{__("Settings")}</span>
      <span class="icon-[tabler--chevron-right] size-4 shrink-0 opacity-60 rtl:rotate-180" aria-hidden="true"></span>
    </button>
    <!-- settings menu -->

    <!-- categories -->
    <aside id="settings-drawer" class="overlay overlay-open:translate-x-0 drawer drawer-start hidden max-w-80 [--auto-close:lg] lg:static lg:z-auto lg:flex lg:h-auto lg:w-64 lg:max-w-none lg:shrink-0 lg:translate-x-0 lg:bg-transparent lg:shadow-none" role="dialog" aria-label="{__("Settings")}" tabindex="-1">
      <div class="flex shrink-0 items-center justify-between gap-3 px-5 pt-5 pb-2 lg:hidden">
        <h2 class="text-base font-semibold">{__("Settings")}</h2>
        <button type="button" class="heroui button button--ghost button--sm button--icon-only size-8 rounded-full" aria-label="{__("Close")}" data-overlay="#settings-drawer">
          <span class="icon-[tabler--x] size-5" aria-hidden="true"></span>
        </button>
      </div>
      <div class="drawer-body px-3 pb-6 lg:overflow-visible lg:p-0">
        {include file='__settings_nav.tpl'}
      </div>
    </aside>
    <!-- categories -->

    <!-- page -->
    <main class="min-w-0 flex-1">
        {if $view == ""}
          {include file='settings.account.tpl'}
        {elseif $view == "profile"}
          {include file='settings.profile.tpl'}
        {elseif $view == "security"}
          {include file='settings.security.tpl'}
        {elseif $view == "privacy"}
          {include file='settings.privacy.tpl'}
        {elseif $view == "notifications"}
          {include file='settings.notifications.tpl'}
        {elseif $view == "accounts"}
          {include file='settings.accounts.tpl'}
        {elseif $view == "linked"}
          {include file='settings.linked.tpl'}
        {elseif $view == "membership"}
          {include file='settings.membership.tpl'}
        {elseif $view == "invitations"}
          {include file='settings.invitations.tpl'}
        {elseif $view == "affiliates"}
          {include file='settings.affiliates.tpl'}
        {elseif $view == "points"}
          {include file='settings.points.tpl'}
        {elseif $view == "market"}
          {include file='settings.market.tpl'}
        {elseif $view == "funding"}
          {include file='settings.funding.tpl'}
        {elseif $view == "monetization"}
          {include file='settings.monetization.tpl'}
        {elseif $view == "coinpayments"}
          {include file='settings.coinpayments.tpl'}
        {elseif $view == "bank"}
          {include file='settings.bank.tpl'}
        {elseif $view == "verification"}
          {include file='settings.verification.tpl'}
        {elseif $view == "apps"}
          {include file='settings.apps.tpl'}
        {elseif $view == "blocking"}
          {include file='settings.blocking.tpl'}
        {elseif $view == "addresses"}
          {include file='settings.addresses.tpl'}
        {elseif $view == "information"}
          {include file='settings.information.tpl'}
        {elseif $view == "delete"}
          {include file='settings.delete.tpl'}
        {/if}
    </main>
    <!-- page -->

  </div>

</div>
<!-- page content -->

{include file='_footer.tpl'}
