{include file='_head.tpl'}
{include file='_header.tpl'}

{* no .sg-offcanvas-sidebar here on purpose — core.js hides the header hamburger when the page has none *}

<!-- page content -->
<div class="ads-page pb-8 sm:pb-12">

  <!-- page heading -->
  {if $view == ""}
    {include file='__page_header.tpl' _title=__("Ads Manager") _text=__("Manage Ads, Create new Campaign") _image="ads.svg"}
  {elseif $view == "new"}
    {include file='__page_header.tpl' _title=__("New Campaign") _text=__("Manage Ads, Create new Campaign") _image="ads.svg"}
  {else}
    {include file='__page_header.tpl' _title=__("Edit Campaign") _text=$campaign['campaign_title'] _image="ads.svg"}
  {/if}
  <!-- page heading -->

  {if $view != ""}
    <div class="mt-6">
      <a class="heroui button button--ghost button--sm gap-1.5 rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem] px-2 text-base-content/70" href="{$system['system_url']}/ads">
        <span class="icon-[tabler--arrow-left] size-4 rtl:rotate-180" aria-hidden="true"></span>
        {__("Ads Manager")}
      </a>
    </div>
  {/if}

  <!-- adblock-warning-message -->
  <div class="adblock-warning-message hidden mt-6">
    <div class="alert alert-soft alert-warning flex items-start gap-3" role="alert">
      <span class="icon-[tabler--shield-exclamation] mt-0.5 size-5 shrink-0" aria-hidden="true"></span>
      <span>{__("Turn off the ad blocker or add this web page's URL as an exception so you use ads system without any problems")}, {__("After you turn off the ad blocker, you'll need to refresh your screen")}</span>
    </div>
  </div>
  <!-- adblock-warning-message -->

  {if $system['ads_budget_priority_enabled']}
    <!-- campaign priority -->
    <div class="alert alert-soft alert-info mt-6 flex items-start gap-3" role="status">
      <span class="icon-[tabler--info-circle] mt-0.5 size-5 shrink-0" aria-hidden="true"></span>
      <span>{__("Higher-budget priority is enabled. Eligible campaigns rotate, with larger total budgets shown first in each cycle. Click and view prices remain unchanged.")}</span>
    </div>
    <!-- campaign priority -->
  {/if}

  {if $view == ""}

    <!-- stats -->
    <div class="mt-6 grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
      <div class="card flex-row items-start gap-4 border border-base-300 bg-base-100 p-5 shadow-none">
        <span class="flex size-11 shrink-0 items-center justify-center rounded-2xl bg-primary/10 text-primary">
          <span class="icon-[tabler--wallet] size-5.5" aria-hidden="true"></span>
        </span>
        <div class="min-w-0">
          <span class="block text-sm text-base-content/60">{__("Wallet Balance")}</span>
          <span class="mt-1 block truncate text-2xl font-semibold tracking-tight" title="{print_money($user->_data['user_wallet_balance'])}">{print_money($user->_data['user_wallet_balance'])}</span>
          <a class="mt-1 inline-flex items-center gap-1 text-xs font-medium text-primary hover:underline" href="{$system['system_url']}/wallet">
            {__("Replenish your wallet credit")}
            <span class="icon-[tabler--arrow-right] size-3.5 rtl:rotate-180" aria-hidden="true"></span>
          </a>
        </div>
      </div>
      <div class="card flex-row items-start gap-4 border border-base-300 bg-base-100 p-5 shadow-none">
        <span class="flex size-11 shrink-0 items-center justify-center rounded-2xl bg-success/10 text-success">
          <span class="icon-[tabler--speakerphone] size-5.5" aria-hidden="true"></span>
        </span>
        <div class="min-w-0">
          <span class="block text-sm text-base-content/60">{__("Active Campaigns")}</span>
          <span class="mt-1 block text-2xl font-semibold tracking-tight">{$campaigns_stats['active']}</span>
        </div>
      </div>
      <div class="card flex-row items-start gap-4 border border-base-300 bg-base-100 p-5 shadow-none">
        <span class="flex size-11 shrink-0 items-center justify-center rounded-2xl bg-accent/10 text-accent">
          <span class="icon-[tabler--coins] size-5.5" aria-hidden="true"></span>
        </span>
        <div class="min-w-0">
          <span class="block text-sm text-base-content/60">{__("Spend")}</span>
          <span class="mt-1 block truncate text-2xl font-semibold tracking-tight" title="{print_money($campaigns_stats['spend'])}">{print_money($campaigns_stats['spend'])}</span>
        </div>
      </div>
      <div class="card flex-row items-start gap-4 border border-base-300 bg-base-100 p-5 shadow-none">
        <span class="flex size-11 shrink-0 items-center justify-center rounded-2xl bg-info/10 text-info">
          <span class="icon-[tabler--chart-bar] size-5.5" aria-hidden="true"></span>
        </span>
        <div class="min-w-0">
          <span class="block text-sm text-base-content/60">{__("Clicks/Views")}</span>
          <span class="mt-1 block text-2xl font-semibold tracking-tight">
            {$campaigns_stats['clicks']}<span class="mx-1.5 font-normal text-base-content/30">/</span>{$campaigns_stats['views']}
          </span>
        </div>
      </div>
    </div>
    <!-- stats -->

    <!-- ads campaigns -->
    <section class="card mt-6 min-w-0 border border-base-300 bg-base-100 shadow-none" aria-labelledby="ads-campaigns-title">
      <div class="card-header flex flex-wrap items-center gap-3 border-b border-base-300">
        <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-base-content" aria-hidden="true">
          <span class="icon-[tabler--speakerphone] size-5"></span>
        </span>
        <div class="min-w-0 grow">
          <h2 id="ads-campaigns-title" class="card-title text-lg">{__("My Campaigns")}</h2>
        </div>
        <a class="heroui button button--primary button--sm w-full sm:ms-auto sm:w-auto rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" href="{$system['system_url']}/ads/new">
          <span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>
          {__("New Campaign")}
        </a>
      </div>
      {if $campaigns}
        <div class="w-full overflow-x-auto">
          <table class="table js_dataTable">
            <thead>
              <tr>
                <th>{__("Title")}</th>
                <th>{__("Start - End Date")}</th>
                <th>{__("Budget")}</th>
                <th>{__("Bidding")}</th>
                <th>{__("Clicks/Views")}</th>
                <th>{__("Status")}</th>
                <th>{__("Created")}</th>
                <th data-orderable="false" class="w-14 text-end"><span class="sr-only">{__("Actions")}</span></th>
              </tr>
            </thead>
            <tbody>
              {foreach $campaigns as $campaign}
                <tr>
                  <td>
                    <div class="flex min-w-0 items-center gap-3">
                      {if $campaign['ads_type'] != "post" && $campaign['ads_image']}
                        <img class="size-10 shrink-0 rounded-xl object-cover" src="{$system['system_uploads']}/{$campaign['ads_image']}" alt="" loading="lazy">
                      {else}
                        <span class="flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-base-content/60">
                          {if $campaign['ads_type'] == "post"}
                            <span class="icon-[tabler--news] size-5" aria-hidden="true"></span>
                          {elseif $campaign['ads_video']}
                            <span class="icon-[tabler--video] size-5" aria-hidden="true"></span>
                          {elseif $campaign['ads_type'] == "page"}
                            <span class="icon-[tabler--flag] size-5" aria-hidden="true"></span>
                          {elseif $campaign['ads_type'] == "group"}
                            <span class="icon-[tabler--users-group] size-5" aria-hidden="true"></span>
                          {elseif $campaign['ads_type'] == "event"}
                            <span class="icon-[tabler--calendar-event] size-5" aria-hidden="true"></span>
                          {else}
                            <span class="icon-[tabler--link] size-5" aria-hidden="true"></span>
                          {/if}
                        </span>
                      {/if}
                      <div class="min-w-0">
                        <a class="block max-w-60 truncate font-medium text-base-content! hover:text-primary!" href="{$system['system_url']}/ads/edit/{$campaign['campaign_id']}" title="{$campaign['campaign_title']}">{$campaign['campaign_title']}</a>
                        <span class="block text-xs text-base-content/60">
                          {if $campaign['ads_type'] == "post"}{__("Post")}
                          {elseif $campaign['ads_type'] == "page"}{__("Page")}
                          {elseif $campaign['ads_type'] == "group"}{__("Group")}
                          {elseif $campaign['ads_type'] == "event"}{__("Event")}
                          {else}{__("URL")}{/if}
                          {if $campaign['ads_type'] != "post"}
                            · {if $campaign['ads_placement'] == "sidebar"}{__("Sidebar")}{else}{__("Newsfeed")}{/if}
                          {/if}
                        </span>
                      </div>
                    </div>
                  </td>
                  <td class="whitespace-nowrap text-sm">
                    <span class="block">{$campaign['campaign_start_date']|date_format:"%e %b %Y"}</span>
                    <span class="block text-base-content/60">{$campaign['campaign_end_date']|date_format:"%e %b %Y"}</span>
                  </td>
                  <td class="min-w-40">
                    <div class="flex items-baseline justify-between gap-2 whitespace-nowrap text-sm">
                      <span class="font-medium">{print_money($campaign['campaign_spend'])}</span>
                      <span class="text-base-content/60">{print_money($campaign['campaign_budget'])}</span>
                    </div>
                    <div class="progress mt-2" role="progressbar" aria-label="{__("Spend")}" aria-valuenow="{$campaign['campaign_spend_percent']}" aria-valuemin="0" aria-valuemax="100">
                      <div class="progress-bar {if $campaign['campaign_spend_percent'] >= 90}progress-error{else}progress-primary{/if}" style="width: {$campaign['campaign_spend_percent']}%"></div>
                    </div>
                  </td>
                  <td>
                    <span class="badge badge-soft gap-1 whitespace-nowrap rounded-full">
                      {if $campaign['campaign_bidding'] == "click"}
                        <span class="icon-[tabler--hand-click] size-3.5" aria-hidden="true"></span>{__("Click")}
                      {else}
                        <span class="icon-[tabler--eye] size-3.5" aria-hidden="true"></span>{__("View")}
                      {/if}
                    </span>
                  </td>
                  <td class="whitespace-nowrap">
                    {if $campaign['campaign_bidding'] == "click"}
                      <span class="font-semibold">{$campaign['campaign_clicks']}</span> <span class="text-sm text-base-content/60">{__("Clicks")}</span>
                    {else}
                      <span class="font-semibold">{$campaign['campaign_views']}</span> <span class="text-sm text-base-content/60">{__("Views")}</span>
                    {/if}
                  </td>
                  <td>
                    {if $campaign['campaign_is_declined']}
                      <span class="badge badge-soft badge-error gap-1.5 whitespace-nowrap rounded-full"><span class="size-1.5 rounded-full bg-current" aria-hidden="true"></span>{__("Declined")}</span>
                    {elseif !$campaign['campaign_is_approved']}
                      <span class="badge badge-soft badge-warning gap-1.5 whitespace-nowrap rounded-full"><span class="size-1.5 rounded-full bg-current" aria-hidden="true"></span>{__("Approval Pending")}</span>
                    {elseif $campaign['campaign_is_active']}
                      <span class="badge badge-soft badge-success gap-1.5 whitespace-nowrap rounded-full"><span class="size-1.5 rounded-full bg-current" aria-hidden="true"></span>{__("Active")}</span>
                    {else}
                      <span class="badge badge-soft gap-1.5 whitespace-nowrap rounded-full"><span class="size-1.5 rounded-full bg-current" aria-hidden="true"></span>{__("Not Active")}</span>
                    {/if}
                  </td>
                  <td class="whitespace-nowrap text-sm text-base-content/70">
                    <span class="js_moment" data-time="{$campaign['campaign_created_date']}">{$campaign['campaign_created_date']}</span>
                  </td>
                  <td class="w-14 text-end">
                    <div class="dropdown relative inline-flex [--placement:bottom-end]">
                      <button id="ads-campaign-actions-{$campaign['campaign_id']}" type="button" class="dropdown-toggle heroui button button--ghost button--sm button--icon-only size-7.5 rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Actions")}">
                        <span class="icon-[tabler--dots-vertical] size-5" aria-hidden="true"></span>
                      </button>
                      <ul class="dropdown-menu dropdown-open:opacity-100 menu-sm hidden min-w-40 p-1" role="menu" aria-orientation="vertical" aria-labelledby="ads-campaign-actions-{$campaign['campaign_id']}">
                        <li>
                          <a class="dropdown-item" role="menuitem" href="{$system['system_url']}/ads/edit/{$campaign['campaign_id']}">
                            <span class="icon-[tabler--edit] size-4" aria-hidden="true"></span>
                            {__("Edit")}
                          </a>
                        </li>
                        {if $campaign['campaign_is_approved']}
                          <li>
                            {if $campaign['campaign_is_active']}
                              <button type="button" class="dropdown-item js_ads-stop-campaign" role="menuitem" data-id="{$campaign['campaign_id']}">
                                <span class="icon-[tabler--player-pause] size-4" aria-hidden="true"></span>
                                {__("Stop")}
                              </button>
                            {else}
                              <button type="button" class="dropdown-item js_ads-resume-campaign" role="menuitem" data-id="{$campaign['campaign_id']}">
                                <span class="icon-[tabler--player-play] size-4" aria-hidden="true"></span>
                                {__("Resume")}
                              </button>
                            {/if}
                          </li>
                        {/if}
                        <li>
                          <button type="button" class="dropdown-item text-error js_ads-delete-campaign" role="menuitem" data-id="{$campaign['campaign_id']}">
                            <span class="icon-[tabler--trash] size-4" aria-hidden="true"></span>
                            {__("Delete")}
                          </button>
                        </li>
                      </ul>
                    </div>
                  </td>
                </tr>
              {/foreach}
            </tbody>
          </table>
        </div>
      {else}
        <div class="flex flex-col items-center justify-center gap-4 px-6 pb-14 pt-10 text-center">
          <span class="flex size-14 items-center justify-center rounded-2xl bg-primary/10 text-primary">
            <span class="icon-[tabler--speakerphone] size-7" aria-hidden="true"></span>
          </span>
          <span class="text-base-content/60">{__("No data to show")}</span>
          <a class="heroui button button--primary button--sm rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" href="{$system['system_url']}/ads/new">
            <span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>
            {__("New Campaign")}
          </a>
        </div>
      {/if}
    </section>
    <!-- ads campaigns -->

  {else}

    {include file='ads.form.tpl'}

  {/if}

</div>
<!-- page content -->

{include file='_footer.tpl'}
