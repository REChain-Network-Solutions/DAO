<div class="flex flex-col gap-6">
  {if $user->_data['user_subscribed']}
    <div class="card border border-base-300 bg-base-100 shadow-none">
      <div class="card-header flex flex-wrap items-center gap-3 border-b border-base-300">
        <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-base-content" aria-hidden="true">
          <span class="icon-[tabler--crown] size-5"></span>
        </span>
        <div class="min-w-0 grow">
          <h2 class="card-title text-lg">{__("Package Details")}</h2>
          <p class="text-sm text-base-content/60">{__("Your package and billing")}</p>
        </div>
        <a href="{$system['system_url']}/packages" class="heroui button button--primary button--sm w-full sm:ms-auto sm:w-auto shrink-0 rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]">
          <span class="icon-[tabler--rocket] size-4" aria-hidden="true"></span>
          {__("Upgrade Package")}
        </a>
      </div>
      <div class="card-body gap-6 pt-6">
        <!-- package -->
        <div class="flex flex-wrap items-center gap-4 rounded-xl border border-base-300 bg-base-200/40 p-4 sm:p-5">
          <span class="inline-flex size-12 shrink-0 items-center justify-center rounded-xl bg-base-100 text-accent" aria-hidden="true">
            <span class="icon-[tabler--crown] size-6"></span>
          </span>
          <div class="min-w-0 grow">
            <div class="truncate text-lg font-semibold" title="{__($user->_data['package_name'])}">{__($user->_data['package_name'])}</div>
            <div class="text-sm text-base-content/60">
              {print_money($user->_data['price'])}
              {if $user->_data['period'] == "life"}{__("Life Time")}{else}{__("per")} {if $user->_data['period_num'] != '1'}{$user->_data['period_num']}{/if} {__($user->_data['period']|ucfirst)}{/if}
            </div>
          </div>
          {if $user->_data['period'] == "life"}
            <span class="badge badge-soft rounded-full badge-lg badge-success shrink-0">{__("Life Time")}</span>
          {elseif $user->_data['subscription_timeleft'] > 0}
            <span class="badge badge-soft rounded-full badge-lg badge-success shrink-0">{__("Remaining")} {$user->_data['subscription_timeleft']} {__("Days")}</span>
          {else}
            <span class="badge badge-soft rounded-full badge-lg badge-error shrink-0">{__("Expired")}</span>
          {/if}
        </div>
        <!-- package -->

        <!-- dates -->
        <div class="grid gap-4 sm:grid-cols-2">
          <div class="flex items-center gap-3 rounded-xl border border-base-300 p-4">
            <span class="inline-flex size-9 shrink-0 items-center justify-center rounded-lg bg-base-200 text-base-content" aria-hidden="true">
              <span class="icon-[tabler--calendar-check] size-5"></span>
            </span>
            <div class="min-w-0">
              <div class="text-sm text-base-content/60">{__("Subscription Date")}</div>
              <div class="text-sm font-semibold">{$user->_data['user_subscription_date']|date_format:"%e/%m/%Y"}</div>
            </div>
          </div>
          <div class="flex items-center gap-3 rounded-xl border border-base-300 p-4">
            <span class="inline-flex size-9 shrink-0 items-center justify-center rounded-lg bg-base-200 text-base-content" aria-hidden="true">
              <span class="icon-[tabler--calendar-x] size-5"></span>
            </span>
            <div class="min-w-0">
              <div class="text-sm text-base-content/60">{__("Expiration Date")}</div>
              <div class="text-sm font-semibold">
                {if $user->_data['period'] == "life"}{__("Life Time")}{else}{$user->_data['subscription_end']|date_format:"%e/%m/%Y"}{/if}
              </div>
            </div>
          </div>
        </div>
        <!-- dates -->

        <!-- boosts -->
        <div class="grid gap-4 sm:grid-cols-2">
            <div class="flex flex-col gap-3 rounded-xl border border-base-300 p-4">
              <div class="flex items-center gap-3">
                <span class="inline-flex size-9 shrink-0 items-center justify-center rounded-lg bg-base-200 text-base-content" aria-hidden="true">
                  <span class="icon-[tabler--news] size-5"></span>
                </span>
                <div class="min-w-0 grow">
                  <div class="truncate text-sm font-medium" id="boosted-posts-label" title="{__("Boosted Posts")}">{__("Boosted Posts")}</div>
                  <div class="text-sm text-base-content/60"><span class="font-semibold text-base-content">{$user->_data['user_boosted_posts']}</span> / {$user->_data['boost_posts']}</div>
                </div>
                <a class="heroui button button--ghost button--sm shrink-0 rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" href="{$system['system_url']}/boosted/posts">{__("Manage")}</a>
              </div>
              <div class="progress h-1.5" role="progressbar" aria-labelledby="boosted-posts-label" aria-valuenow="{if $user->_data['boost_posts'] == 0}0{else}{($user->_data['user_boosted_posts']/$user->_data['boost_posts'])*100}{/if}" aria-valuemin="0" aria-valuemax="100">
                <div class="progress-bar progress-primary" style="width: {if $user->_data['boost_posts'] == 0}0{else}{($user->_data['user_boosted_posts']/$user->_data['boost_posts'])*100}{/if}%"></div>
              </div>
            </div>
            <div class="flex flex-col gap-3 rounded-xl border border-base-300 p-4">
              <div class="flex items-center gap-3">
                <span class="inline-flex size-9 shrink-0 items-center justify-center rounded-lg bg-base-200 text-base-content" aria-hidden="true">
                  <span class="icon-[tabler--flag] size-5"></span>
                </span>
                <div class="min-w-0 grow">
                  <div class="truncate text-sm font-medium" id="boosted-pages-label" title="{__("Boosted Pages")}">{__("Boosted Pages")}</div>
                  <div class="text-sm text-base-content/60"><span class="font-semibold text-base-content">{$user->_data['user_boosted_pages']}</span> / {$user->_data['boost_pages']}</div>
                </div>
                <a class="heroui button button--ghost button--sm shrink-0 rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" href="{$system['system_url']}/boosted/pages">{__("Manage")}</a>
              </div>
              <div class="progress h-1.5" role="progressbar" aria-labelledby="boosted-pages-label" aria-valuenow="{if $user->_data['boost_pages'] == 0}0{else}{($user->_data['user_boosted_pages']/$user->_data['boost_pages'])*100}{/if}" aria-valuemin="0" aria-valuemax="100">
                <div class="progress-bar progress-warning" style="width: {if $user->_data['boost_pages'] == 0}0{else}{($user->_data['user_boosted_pages']/$user->_data['boost_pages'])*100}{/if}%"></div>
              </div>
            </div>
            <div class="flex flex-col gap-3 rounded-xl border border-base-300 p-4">
              <div class="flex items-center gap-3">
                <span class="inline-flex size-9 shrink-0 items-center justify-center rounded-lg bg-base-200 text-base-content" aria-hidden="true">
                  <span class="icon-[tabler--users-group] size-5"></span>
                </span>
                <div class="min-w-0 grow">
                  <div class="truncate text-sm font-medium" id="boosted-groups-label" title="{__("Boosted Groups")}">{__("Boosted Groups")}</div>
                  <div class="text-sm text-base-content/60"><span class="font-semibold text-base-content">{$user->_data['user_boosted_groups']}</span> / {$user->_data['boost_groups']}</div>
                </div>
                <a class="heroui button button--ghost button--sm shrink-0 rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" href="{$system['system_url']}/boosted/groups">{__("Manage")}</a>
              </div>
              <div class="progress h-1.5" role="progressbar" aria-labelledby="boosted-groups-label" aria-valuenow="{if $user->_data['boost_groups'] == 0}0{else}{($user->_data['user_boosted_groups']/$user->_data['boost_groups'])*100}{/if}" aria-valuemin="0" aria-valuemax="100">
                <div class="progress-bar progress-success" style="width: {if $user->_data['boost_groups'] == 0}0{else}{($user->_data['user_boosted_groups']/$user->_data['boost_groups'])*100}{/if}%"></div>
              </div>
            </div>
            <div class="flex flex-col gap-3 rounded-xl border border-base-300 p-4">
              <div class="flex items-center gap-3">
                <span class="inline-flex size-9 shrink-0 items-center justify-center rounded-lg bg-base-200 text-base-content" aria-hidden="true">
                  <span class="icon-[tabler--calendar-event] size-5"></span>
                </span>
                <div class="min-w-0 grow">
                  <div class="truncate text-sm font-medium" id="boosted-events-label" title="{__("Boosted Events")}">{__("Boosted Events")}</div>
                  <div class="text-sm text-base-content/60"><span class="font-semibold text-base-content">{$user->_data['user_boosted_events']}</span> / {$user->_data['boost_events']}</div>
                </div>
                <a class="heroui button button--ghost button--sm shrink-0 rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" href="{$system['system_url']}/boosted/events">{__("Manage")}</a>
              </div>
              <div class="progress h-1.5" role="progressbar" aria-labelledby="boosted-events-label" aria-valuenow="{if $user->_data['boost_events'] == 0}0{else}{($user->_data['user_boosted_events']/$user->_data['boost_events'])*100}{/if}" aria-valuemin="0" aria-valuemax="100">
                <div class="progress-bar progress-info" style="width: {if $user->_data['boost_events'] == 0}0{else}{($user->_data['user_boosted_events']/$user->_data['boost_events'])*100}{/if}%"></div>
              </div>
            </div>
        </div>
        <!-- boosts -->
      </div>

      {if $user->_data['can_pick_categories']}
        <form class="js_ajax-forms" data-url="users/settings.php?edit=membership">
          <div class="card-body gap-6 border-t border-base-300 pt-6">
            {if $user->_data['allowed_videos_categories'] > 0}
              <div class="w-full">
                <label class="label-text mb-1.5 block" for="package_videos_categories">{__("Videos Categories")}</label>
                <input type="text" class="js_tagify-ajax hidden min-h-10 w-full items-center! rounded-field bg-base-100 text-sm max-md:text-base [--placeholder-color-focus:color-mix(in_oklab,var(--color-base-content)_35%,transparent)]! [--placeholder-color:color-mix(in_oklab,var(--color-base-content)_45%,transparent)]! [--tag-bg:var(--color-base-200)]! [--tag-border-radius:9999px]! [--tag-hover:var(--color-base-300)]! [--tag-remove-btn-color:var(--color-base-content)]! [--tag-text-color:var(--color-base-content)]! [--tags-border-color:var(--color-base-300)]! [--tags-focus-border-color:var(--color-primary)]! [--tags-hover-border-color:color-mix(in_oklab,var(--color-base-content)_25%,transparent)]!" data-handle="video_categories" placeholder='{__("Search")}' name="package_videos_categories" id="package_videos_categories" value='{$user->_data['user_package_videos_categories']}'>
                <p class="helper-text">{__("You can select")} {$user->_data['allowed_videos_categories']} {__("categories")}</p>
              </div>
            {/if}

            {if $user->_data['allowed_blogs_categories'] > 0}
              <div class="w-full">
                <label class="label-text mb-1.5 block" for="package_blogs_categories">{__("Blogs Categories")}</label>
                <input type="text" class="js_tagify-ajax hidden min-h-10 w-full items-center! rounded-field bg-base-100 text-sm max-md:text-base [--placeholder-color-focus:color-mix(in_oklab,var(--color-base-content)_35%,transparent)]! [--placeholder-color:color-mix(in_oklab,var(--color-base-content)_45%,transparent)]! [--tag-bg:var(--color-base-200)]! [--tag-border-radius:9999px]! [--tag-hover:var(--color-base-300)]! [--tag-remove-btn-color:var(--color-base-content)]! [--tag-text-color:var(--color-base-content)]! [--tags-border-color:var(--color-base-300)]! [--tags-focus-border-color:var(--color-primary)]! [--tags-hover-border-color:color-mix(in_oklab,var(--color-base-content)_25%,transparent)]!" data-handle="blogs_categories" placeholder='{__("Search")}' name="package_blogs_categories" id="package_blogs_categories" value='{$user->_data['user_package_blogs_categories']}'>
                <p class="helper-text">{__("You can select")} {$user->_data['allowed_blogs_categories']} {__("categories")}</p>
              </div>
            {/if}

            <!-- success -->
            <div class="alert alert-success hidden items-center" role="status"></div>
            <!-- success -->

            <!-- error -->
            <div class="alert alert-error alert-danger hidden items-center" role="alert"></div>
            <!-- error -->
          </div>
          <div class="card-footer flex flex-col-reverse gap-3 border-t border-base-300 pt-6 sm:flex-row sm:flex-wrap sm:justify-between">
            <button type="button" class="heroui button button--danger-soft js_unsubscribe-package w-full sm:w-auto rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]">{__("Unsubscribe")}</button>
            <button type="submit" class="heroui button button--primary w-full sm:w-auto rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]">{__("Save Changes")}</button>
          </div>
        </form>
      {else}
        <div class="card-footer flex justify-end gap-3 border-t border-base-300 pt-6">
          <button type="button" class="heroui button button--danger-soft js_unsubscribe-package w-full sm:w-auto rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]">{__("Unsubscribe")}</button>
        </div>
      {/if}
    </div>
  {else}
    <!-- upgrade -->
    {$_pro_icon = ''}
    {if $system['system_theme_icons'] == 'svg'}
      {$_pro_icon = 'pro'|theme_module_icon:'size-14 shrink-0'}
    {/if}
    <div class="rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-linear-to-br from-warning/25 via-base-100 to-accent/25 p-5 sm:p-6">
      <div class="flex flex-wrap items-center gap-4">
        {if $_pro_icon}
          {$_pro_icon}
        {else}
          <span class="icon-[tabler--crown] size-12 shrink-0 text-accent" aria-hidden="true"></span>
        {/if}
        <div class="min-w-0 grow basis-48">
          <h2 class="text-lg font-semibold">{__("Upgrade to Pro")}</h2>
          <p class="mt-1 text-sm text-base-content/60">{__("Choose the Plan That's Right for You")}</p>
        </div>
        <a class="heroui button button--primary [--button-bg:var(--color-accent)] [--button-bg-hover:color-mix(in_oklab,var(--color-accent)_90%,black)] [--button-bg-pressed:color-mix(in_oklab,var(--color-accent)_90%,black)] [--button-fg:var(--color-accent-content)] w-full shrink-0 rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem] sm:w-auto" href="{$system['system_url']}/packages">{__("Upgrade Now")}</a>
      </div>
      <ul class="mt-5 grid gap-3 sm:grid-cols-2 xl:grid-cols-4">
        <li class="flex items-center gap-3 rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-3xl bg-base-100/75 p-3 shadow-xs backdrop-blur-sm">
          <span class="inline-flex size-9 shrink-0 items-center justify-center rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-2xl bg-accent/15 text-accent" aria-hidden="true">
            <span class="icon-[tabler--star] size-5"></span>
          </span>
          <span class="truncate text-sm font-medium" title="{__("Featured member")}">{__("Featured member")}</span>
        </li>
        <li class="flex items-center gap-3 rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-3xl bg-base-100/75 p-3 shadow-xs backdrop-blur-sm">
          <span class="inline-flex size-9 shrink-0 items-center justify-center rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-2xl bg-accent/15 text-accent" aria-hidden="true">
            <span class="icon-[tabler--rosette-discount-check] size-5"></span>
          </span>
          <span class="truncate text-sm font-medium" title="{__("Verified Badge")}">{__("Verified Badge")}</span>
        </li>
        <li class="flex items-center gap-3 rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-3xl bg-base-100/75 p-3 shadow-xs backdrop-blur-sm">
          <span class="inline-flex size-9 shrink-0 items-center justify-center rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-2xl bg-accent/15 text-accent" aria-hidden="true">
            <span class="icon-[tabler--speakerphone] size-5"></span>
          </span>
          <span class="truncate text-sm font-medium" title="{__("Posts Promotion")}">{__("Posts Promotion")}</span>
        </li>
        {if $system['packages_ads_free_enabled']}
          <li class="flex items-center gap-3 rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-3xl bg-base-100/75 p-3 shadow-xs backdrop-blur-sm">
            <span class="inline-flex size-9 shrink-0 items-center justify-center rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-2xl bg-accent/15 text-accent" aria-hidden="true">
              <span class="icon-[tabler--ad-off] size-5"></span>
            </span>
            <span class="truncate text-sm font-medium" title="{__("No Ads")}">{__("No Ads")}</span>
          </li>
        {else}
          <li class="flex items-center gap-3 rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-3xl bg-base-100/75 p-3 shadow-xs backdrop-blur-sm">
            <span class="inline-flex size-9 shrink-0 items-center justify-center rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-2xl bg-accent/15 text-accent" aria-hidden="true">
              <span class="icon-[tabler--flag] size-5"></span>
            </span>
            <span class="truncate text-sm font-medium" title="{__("Pages Promotion")}">{__("Pages Promotion")}</span>
          </li>
        {/if}
      </ul>
    </div>
    <!-- upgrade -->
  {/if}

  <!-- history -->
  <div class="card border border-base-300 bg-base-100 shadow-none">
    {include file='__settings_card_header.tpl' _icon="icon-[tabler--history]" _title=__("History")}
    <div class="card-body gap-6 pt-6">
      {if $packages_payments}
        <div class="[&_.js-flyonui-datatable-toolbar]:px-0 [&_.js-flyonui-datatable-footer]:px-0">
          <table class="table table-zebra min-w-[560px] js_dataTable">
            <thead>
              <tr>
                <th>{__("ID")}</th>
                <th>{__("Package")}</th>
                <th>{__("Amount")}</th>
                <th class="text-end">{__("Date")}</th>
              </tr>
            </thead>
            <tbody>
              {foreach $packages_payments as $package_payment}
                <tr>
                  <td>{$package_payment@iteration}</td>
                  <td class="font-medium">{$package_payment['package_name']}</td>
                  <td>{print_money($package_payment['package_price'])}</td>
                  <td class="text-end text-base-content/60">{__($package_payment['payment_date'])}</td>
                </tr>
              {/foreach}
            </tbody>
          </table>
        </div>
      {else}
        {include file='_no_transactions.tpl'}
      {/if}
    </div>
  </div>
  <!-- history -->
</div>
