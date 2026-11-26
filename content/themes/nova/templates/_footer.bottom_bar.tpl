<div class="js_site-bottom-bar fixed inset-x-3 bottom-[calc(0.75rem+env(safe-area-inset-bottom))] z-[35] h-14 rounded-full border border-base-300 bg-base-100 transition-transform duration-300 data-[hidden=true]:translate-y-[200%] md:hidden{if $page == 'reels'} hidden{/if}">
  <div class="h-full px-2">
    <div class="flex h-full items-stretch">
      {foreach $system['bottom_bar']|bottom_bar_items as $_key => $_item}
        {if $_key == 'add'}
          <div class="min-w-0 flex-1">
            <div class="dropdown flex h-full [--adaptive:none] [--placement:top]">
              <button type="button" class="dropdown-toggle flex h-full w-full min-w-0 items-center justify-center text-base-content!" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Add")}">
                <span class="inline-flex h-10 w-12 items-center justify-center rounded-full bg-primary! text-primary-content!"><span class="icon-[tabler--plus] size-5.5" aria-hidden="true"></span></span>
              </button>
              <div class="dropdown-menu dropdown-open:opacity-100 hidden inset-x-0 bottom-[calc(100%+0.5rem)] max-h-90 overflow-y-auto rounded-3xl border border-base-content/15 p-0 shadow-lg shadow-black/10 dark:shadow-black/25" role="menu">
                <div class="flex flex-wrap gap-2.5 p-4">
                  <div class="js_modal flex min-w-30 flex-1 basis-full cursor-pointer flex-col items-center justify-center gap-1.5 rounded-2xl bg-base-200 p-3 text-center text-[0.8125rem] text-base-content! hover:bg-[color-mix(in_oklab,var(--color-primary)_8%,var(--color-base-200))]" data-static="true" data-size="publisher" data-url="posts/publisher.php">
                    <span class="icon-[tabler--pencil] size-6 text-primary" aria-hidden="true"></span>
                    <div>{__("Post")}</div>
                  </div>
                  {if $system['live_enabled']}
                    <a class="flex min-w-30 flex-1 cursor-pointer flex-col items-center justify-center gap-1.5 rounded-2xl bg-base-200 p-3 text-center text-[0.8125rem] text-base-content! hover:bg-[color-mix(in_oklab,var(--color-primary)_8%,var(--color-base-200))]" href="{$system['system_url']}/live/create">
                      <span class="icon-[tabler--broadcast] size-6 text-error" aria-hidden="true"></span>
                      <div>{__("Live")}</div>
                    </a>
                  {/if}
                  {if $system['stories_enabled']}
                    <div class="js_story-create flex min-w-30 flex-1 cursor-pointer flex-col items-center justify-center gap-1.5 rounded-2xl bg-base-200 p-3 text-center text-[0.8125rem] text-base-content! hover:bg-[color-mix(in_oklab,var(--color-primary)_8%,var(--color-base-200))]">
                      <span class="icon-[tabler--clock] size-6 text-accent" aria-hidden="true"></span>
                      <div>{__("Story")}</div>
                    </div>
                  {/if}
                  {if $system['blogs_enabled']}
                    <a class="flex min-w-30 flex-1 cursor-pointer flex-col items-center justify-center gap-1.5 rounded-2xl bg-base-200 p-3 text-center text-[0.8125rem] text-base-content! hover:bg-[color-mix(in_oklab,var(--color-primary)_8%,var(--color-base-200))]" href="{$system['system_url']}/blogs/new">
                      <span class="icon-[tabler--article] size-6 text-info" aria-hidden="true"></span>
                      <div>{__("Blog")} {if $system['paid_blogs_enabled']}<span class="badge badge-sm badge-soft badge-error">{__("Paid")}</span>{/if}</div>
                    </a>
                  {/if}
                  {if $system['market_enabled']}
                    <div class="js_modal flex min-w-30 flex-1 cursor-pointer flex-col items-center justify-center gap-1.5 rounded-2xl bg-base-200 p-3 text-center text-[0.8125rem] text-base-content! hover:bg-[color-mix(in_oklab,var(--color-primary)_8%,var(--color-base-200))]" data-url="posts/product.php?do=create">
                      <span class="icon-[tabler--building-store] size-6 text-success" aria-hidden="true"></span>
                      <div>{__("Product")} {if $system['paid_products_enabled']}<span class="badge badge-sm badge-soft badge-error">{__("Paid")}</span>{/if}</div>
                    </div>
                  {/if}
                  {if $system['funding_enabled']}
                    <div class="js_modal flex min-w-30 flex-1 cursor-pointer flex-col items-center justify-center gap-1.5 rounded-2xl bg-base-200 p-3 text-center text-[0.8125rem] text-base-content! hover:bg-[color-mix(in_oklab,var(--color-primary)_8%,var(--color-base-200))]" data-url="posts/funding.php?do=create">
                      <span class="icon-[tabler--coin] size-6 text-warning" aria-hidden="true"></span>
                      <div>{__("Funding")} {if $system['paid_funding_enabled']}<span class="badge badge-sm badge-soft badge-error">{__("Paid")}</span>{/if}</div>
                    </div>
                  {/if}
                  {if $system['ads_enabled']}
                    <a class="flex min-w-30 flex-1 cursor-pointer flex-col items-center justify-center gap-1.5 rounded-2xl bg-base-200 p-3 text-center text-[0.8125rem] text-base-content! hover:bg-[color-mix(in_oklab,var(--color-primary)_8%,var(--color-base-200))]" href="{$system['system_url']}/ads/new">
                      <span class="icon-[tabler--speakerphone] size-6 text-accent" aria-hidden="true"></span>
                      <div>{__("Ads")}</div>
                    </a>
                  {/if}
                  {if $system['pages_enabled']}
                    <div class="js_modal flex min-w-30 flex-1 cursor-pointer flex-col items-center justify-center gap-1.5 rounded-2xl bg-base-200 p-3 text-center text-[0.8125rem] text-base-content! hover:bg-[color-mix(in_oklab,var(--color-primary)_8%,var(--color-base-200))]" data-url="modules/add.php?type=page">
                      <span class="icon-[tabler--flag] size-6 text-primary" aria-hidden="true"></span>
                      <div>{__("Page")}</div>
                    </div>
                  {/if}
                  {if $system['groups_enabled']}
                    <div class="js_modal flex min-w-30 flex-1 cursor-pointer flex-col items-center justify-center gap-1.5 rounded-2xl bg-base-200 p-3 text-center text-[0.8125rem] text-base-content! hover:bg-[color-mix(in_oklab,var(--color-primary)_8%,var(--color-base-200))]" data-url="modules/add.php?type=group">
                      <span class="icon-[tabler--users-group] size-6 text-info" aria-hidden="true"></span>
                      <div>{__("Group")}</div>
                    </div>
                  {/if}
                  {if $system['events_enabled']}
                    <div class="js_modal flex min-w-30 flex-1 cursor-pointer flex-col items-center justify-center gap-1.5 rounded-2xl bg-base-200 p-3 text-center text-[0.8125rem] text-base-content! hover:bg-[color-mix(in_oklab,var(--color-primary)_8%,var(--color-base-200))]" data-url="modules/add.php?type=event">
                      <span class="icon-[tabler--calendar-event] size-6 text-success" aria-hidden="true"></span>
                      <div>{__("Event")}</div>
                    </div>
                  {/if}
                </div>
              </div>
            </div>
          </div>
        {elseif $_key == 'menu'}
          <div class="relative min-w-0 flex-1">
            {include file='_user_menu.tpl' _as_widget=true}
          </div>
        {else}
          {$_active = ($page == $_item['page'] && (!$_item['views'] || in_array($view, $_item['views'])))}
          <div class="relative min-w-0 flex-1">
            <a class="flex h-full items-center justify-center {if $_active}font-semibold text-primary{else}text-base-content!{/if}" href="{$_item['url']}" aria-label="{$_item['label']}">
              <span class="inline-flex h-10 w-12 items-center justify-center rounded-full{if $_active} bg-primary/12{/if}"><span class="{$_item['icon']} size-5.5" aria-hidden="true"></span></span>
            </a>
          </div>
        {/if}
      {/foreach}
    </div>
  </div>
</div>
