{if $sub_view == ""}
  <section class="admin-settings-page admin-list-page flex min-w-0 flex-col gap-6" aria-labelledby="admin-dating-title">
    <header class="admin-list-heading flex items-start justify-between gap-4">
      <div class="admin-settings-heading grid gap-1.5">
        <h1 id="admin-dating-title" class="text-2xl font-semibold">{__("Dating")}</h1>
        <p class="text-base-content/60 text-sm">{__("Members, matches and earnings of the dating module.")}</p>
      </div>
      <div class="admin-list-heading-actions flex shrink-0 flex-wrap items-center justify-end gap-2">
        <a href="{$system['system_url']}/{$control_panel['url']}/dating/settings" class="btn btn-outline">
          <span class="icon-[tabler--settings] size-4" aria-hidden="true"></span>
          {__("Settings")}
        </a>
      </div>
    </header>

    {if !$system['dating_enabled']}
      <div class="alert alert-soft alert-warning" role="status">{__("Dating is disabled, enable it from the dating settings")}</div>
    {/if}

    <div class="admin-stats grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4 lg:gap-5">
      <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
        <span class="admin-stat-icon is-info icon-[tabler--users] size-6 shrink-0" aria-hidden="true"></span>
        <div class="flex min-w-0 flex-col gap-1">
          <span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Members")}">{__("Members")}</span>
          <p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{$insights['members']|number_format}</p>
        </div>
      </article>
      <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
        <span class="admin-stat-icon is-success icon-[tabler--user-check] size-6 shrink-0" aria-hidden="true"></span>
        <div class="flex min-w-0 flex-col gap-1">
          <span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Active Members")}">{__("Active Members")}</span>
          <p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{$insights['active']|number_format}</p>
        </div>
      </article>
      <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
        <span class="admin-stat-icon is-info icon-[tabler--user-plus] size-6 shrink-0" aria-hidden="true"></span>
        <div class="flex min-w-0 flex-col gap-1">
          <span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("New This Week")}">{__("New This Week")}</span>
          <p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{$insights['new_members']|number_format}</p>
        </div>
      </article>
      <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
        <span class="admin-stat-icon is-success icon-[tabler--heart-handshake] size-6 shrink-0" aria-hidden="true"></span>
        <div class="flex min-w-0 flex-col gap-1">
          <span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Matches")}">{__("Matches")}</span>
          <p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{$insights['matches']|number_format}</p>
        </div>
      </article>
      <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
        <span class="admin-stat-icon is-warning icon-[tabler--photo-search] size-6 shrink-0" aria-hidden="true"></span>
        <div class="flex min-w-0 flex-col gap-1">
          <span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Photos In Review")}">{__("Photos In Review")}</span>
          <p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{$insights['pending_photos']|number_format}</p>
        </div>
      </article>
      <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
        <span class="admin-stat-icon is-warning icon-[tabler--user-off] size-6 shrink-0" aria-hidden="true"></span>
        <div class="flex min-w-0 flex-col gap-1">
          <span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Suspended")}">{__("Suspended")}</span>
          <p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{$insights['suspended']|number_format}</p>
        </div>
      </article>
      <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
        <span class="admin-stat-icon is-success icon-[tabler--coin] size-6 shrink-0" aria-hidden="true"></span>
        <div class="flex min-w-0 flex-col gap-1">
          <span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Earnings")}">{__("Earnings")}</span>
          <p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{print_money($insights['revenue'])}</p>
        </div>
      </article>
      <article class="card admin-stat flex min-w-0 flex-col gap-6 border border-base-300 bg-base-100 p-5 lg:p-6">
        <span class="admin-stat-icon is-success icon-[tabler--calendar-dollar] size-6 shrink-0" aria-hidden="true"></span>
        <div class="flex min-w-0 flex-col gap-1">
          <span class="admin-stat-label min-w-0 truncate text-[15px] leading-snug" title="{__("Last 30 Days")}">{__("Last 30 Days")}</span>
          <p class="admin-stat-value m-0 text-[1.75rem] font-bold leading-tight tracking-tight tabular-nums sm:text-3xl">{print_money($insights['revenue_month'])}</p>
        </div>
      </article>
    </div>

    <div class="grid gap-6 lg:grid-cols-2">
      <section class="card admin-list-table-card min-w-0 overflow-visible border border-base-300 bg-base-100 shadow-none" aria-label="{__("Earnings")}">
        <div class="admin-list-table-wrap w-full overflow-x-auto">
          <table class="table admin-list-table min-w-0!">
            <thead>
              <tr>
                <th>{__("Source")}</th>
                <th>{__("Sales")}</th>
                <th>{__("Earnings")}</th>
              </tr>
            </thead>
            <tbody>
                <tr>
                  <td><span class="admin-list-name text-sm font-semibold">{__("Super Likes")}</span></td>
                  <td>{$insights['items']['super_likes']['sales']|default:0|number_format}</td>
                  <td>{print_money($insights['items']['super_likes']['total']|default:0)}</td>
                </tr>
                <tr>
                  <td><span class="admin-list-name text-sm font-semibold">{__("Boosts")}</span></td>
                  <td>{$insights['items']['boost']['sales']|default:0|number_format}</td>
                  <td>{print_money($insights['items']['boost']['total']|default:0)}</td>
                </tr>
                <tr>
                  <td><span class="admin-list-name text-sm font-semibold">{__("Messages With a Like")}</span></td>
                  <td>{$insights['items']['priority_message']['sales']|default:0|number_format}</td>
                  <td>{print_money($insights['items']['priority_message']['total']|default:0)}</td>
                </tr>
            </tbody>
          </table>
        </div>
      </section>

      <section class="card admin-list-table-card min-w-0 overflow-visible border border-base-300 bg-base-100 shadow-none" aria-label="{__("Genders")}">
        <div class="admin-list-table-wrap w-full overflow-x-auto">
          <table class="table admin-list-table min-w-0!">
            <thead>
              <tr>
                <th>{__("Gender")}</th>
                <th>{__("Members")}</th>
              </tr>
            </thead>
            <tbody>
              {foreach $insights['genders'] as $_gender}
                <tr>
                  <td><span class="admin-list-name text-sm font-semibold">{__($_gender['gender_name'])}</span></td>
                  <td>{$_gender['count']|number_format}</td>
                </tr>
              {foreachelse}
                <tr>
                  <td colspan="2" class="text-base-content/60 text-sm">{__("No data to show")}</td>
                </tr>
              {/foreach}
            </tbody>
          </table>
        </div>
      </section>
    </div>
  </section>

{elseif $sub_view == "settings"}
  <section class="admin-settings-page" aria-labelledby="admin-dating-title">
    <div class="admin-settings-heading grid gap-1.5">
      <h1 id="admin-dating-title" class="text-2xl font-semibold">{__("Dating Settings")}</h1>
      <p class="text-base-content/60 text-sm">{__("Access, safety, limits and prices for the dating module.")}</p>
    </div>

    <div class="admin-settings-panel js_admin-settings-panel" id="General">
      <form class="js_ajax-forms" data-url="admin/settings.php?edit=dating_settings">
        <div class="admin-settings-layout block">
          <div class="admin-settings-form flex min-w-0 flex-col gap-4">
            <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
              <div class="admin-settings-section flex flex-col gap-5 p-6 admin-settings-section-plain">
                <h2 class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
                  <span class="icon-[tabler--heart] size-5" aria-hidden="true"></span>
                  {__("General")}
                </h2>

                <div class="admin-setting-switch js_admin-setting-switch">
                  <div>
                    <label class="admin-setting-label block text-sm font-medium leading-normal" for="dating_enabled">{__("Dating")}</label>
                    <div class="admin-setting-help text-sm leading-relaxed" id="dating_enabled-help">{__("Turn the dating module on or off")}</div>
                  </div>
                  <div class="text-end">
                    <input type="checkbox" class="switch switch-primary" name="dating_enabled" id="dating_enabled" {if $system['dating_enabled']}checked{/if} aria-describedby="dating_enabled-help">
                  </div>
                </div>

                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                  <label class="label-text" for="dating_max_distance">{__("Max Distance")}</label>
                  <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                    <input type="text" class="input w-full" name="dating_max_distance" id="dating_max_distance" value="{$system['dating_max_distance']}" aria-describedby="dating_max_distance-help" inputmode="numeric">
                    <div id="dating_max_distance-help" class="admin-setting-help text-sm leading-relaxed">{__("The widest distance a member can search within")}</div>
                  </div>
                </div>

                <div class="admin-setting-switch js_admin-setting-switch">
                  <div>
                    <label class="admin-setting-label block text-sm font-medium leading-normal" for="dating_worldwide">{__("Worldwide Search")}</label>
                    <div class="admin-setting-help text-sm leading-relaxed" id="dating_worldwide-help">{__("Members see profiles from anywhere, not only near them or in their country")}</div>
                  </div>
                  <div class="text-end">
                    <input type="checkbox" class="switch switch-primary" name="dating_worldwide" id="dating_worldwide" {if $system['dating_worldwide']}checked{/if} aria-describedby="dating_worldwide-help">
                  </div>
                </div>
              </div>
            </section>

            <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
              <div class="admin-settings-section flex flex-col gap-5 p-6 admin-settings-section-plain">
                <h2 class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
                  <span class="icon-[tabler--shield-check] size-5" aria-hidden="true"></span>
                  {__("Safety")}
                </h2>

                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                  <label class="label-text" for="dating_min_age">{__("Minimum Age")}</label>
                  <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                    <input type="text" class="input w-full" name="dating_min_age" id="dating_min_age" value="{$system['dating_min_age']}" aria-describedby="dating_min_age-help" inputmode="numeric">
                    <div id="dating_min_age-help" class="admin-setting-help text-sm leading-relaxed">{__("Members younger than this age can not join dating, 18 or more")}</div>
                  </div>
                </div>

                <div class="admin-setting-switch js_admin-setting-switch">
                  <div>
                    <label class="admin-setting-label block text-sm font-medium leading-normal" for="dating_verified_only">{__("Verified Members Only")}</label>
                    <div class="admin-setting-help text-sm leading-relaxed" id="dating_verified_only-help">{__("Only verified members can join and be seen in dating")}</div>
                  </div>
                  <div class="text-end">
                    <input type="checkbox" class="switch switch-primary" name="dating_verified_only" id="dating_verified_only" {if $system['dating_verified_only']}checked{/if} aria-describedby="dating_verified_only-help">
                  </div>
                </div>

                <div class="admin-setting-switch js_admin-setting-switch">
                  <div>
                    <label class="admin-setting-label block text-sm font-medium leading-normal" for="dating_photos_approval">{__("Photos Approval")}</label>
                    <div class="admin-setting-help text-sm leading-relaxed" id="dating_photos_approval-help">{__("New dating photos stay hidden until they are approved")}</div>
                  </div>
                  <div class="text-end">
                    <input type="checkbox" class="switch switch-primary" name="dating_photos_approval" id="dating_photos_approval" {if $system['dating_photos_approval']}checked{/if} aria-describedby="dating_photos_approval-help">
                  </div>
                </div>

                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                  <label class="label-text" for="dating_max_photos">{__("Max Photos")}</label>
                  <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                    <input type="text" class="input w-full" name="dating_max_photos" id="dating_max_photos" value="{$system['dating_max_photos']}" aria-describedby="dating_max_photos-help" inputmode="numeric">
                    <div id="dating_max_photos-help" class="admin-setting-help text-sm leading-relaxed">{__("The maximum number of photos in a dating profile")}</div>
                  </div>
                </div>

                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                  <label class="label-text" for="dating_max_interests">{__("Max Interests")}</label>
                  <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                    <input type="text" class="input w-full" name="dating_max_interests" id="dating_max_interests" value="{$system['dating_max_interests']}" aria-describedby="dating_max_interests-help" inputmode="numeric">
                    <div id="dating_max_interests-help" class="admin-setting-help text-sm leading-relaxed">{__("The maximum number of interests a member can select")}</div>
                  </div>
                </div>
              </div>
            </section>

            <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
              <div class="admin-settings-section flex flex-col gap-5 p-6 admin-settings-section-plain">
                <h2 class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
                  <span class="icon-[tabler--gift] size-5" aria-hidden="true"></span>
                  {__("Free Plan")}
                </h2>

                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                  <label class="label-text" for="dating_free_swipes">{__("Daily Swipes")}</label>
                  <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                    <input type="text" class="input w-full" name="dating_free_swipes" id="dating_free_swipes" value="{$system['dating_free_swipes']}" aria-describedby="dating_free_swipes-help" inputmode="numeric">
                    <div id="dating_free_swipes-help" class="admin-setting-help text-sm leading-relaxed">{__("The number of swipes a member gets every 24 hours without a package")}</div>
                  </div>
                </div>

                <div class="admin-setting-switch js_admin-setting-switch">
                  <div>
                    <label class="admin-setting-label block text-sm font-medium leading-normal" for="dating_free_likes_list">{__("See Who Liked You")}</label>
                    <div class="admin-setting-help text-sm leading-relaxed" id="dating_free_likes_list-help">{__("Let every member see who liked them without a package")}</div>
                  </div>
                  <div class="text-end">
                    <input type="checkbox" class="switch switch-primary" name="dating_free_likes_list" id="dating_free_likes_list" {if $system['dating_free_likes_list']}checked{/if} aria-describedby="dating_free_likes_list-help">
                  </div>
                </div>

                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                  <div class="flex items-center gap-1">
                    <label class="label-text" for="dating_ads_frequency">{__("Ads Frequency")}</label>
                    {capture assign="_tip"}{__("Ads come from the system ads with the Dating place, users ads campaigns are not shown")} <a class="link link-primary" href="{$system['system_url']}/{$control_panel['url']}/ads/system_ads">{__("System Ads")}</a>{/capture}
                    {include file='__admin_tip.tpl' _tip_id="dating-ads-tip" _tip_text=$_tip}
                  </div>
                  <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                    <input type="text" class="input w-full" name="dating_ads_frequency" id="dating_ads_frequency" value="{$system['dating_ads_frequency']}" aria-describedby="dating_ads_frequency-help" inputmode="numeric">
                    <div id="dating_ads_frequency-help" class="admin-setting-help text-sm leading-relaxed">{__("Show an ad after this number of profiles, 0 to disable")}</div>
                  </div>
                </div>
              </div>
            </section>

            {if $system['wallet_enabled']}
            <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
              <div class="admin-settings-section flex flex-col gap-5 p-6 admin-settings-section-plain">
                <h2 class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
                  <span class="icon-[tabler--coin] size-5" aria-hidden="true"></span>
                  {__("Prices")}
                  {capture assign="_tip"}{__("These prices are paid from the wallet by any member and are the same for everyone, they are not part of the pro packages")} <span class="mt-2 block">{__("Super likes and boosts included in a pro package are used first, set them from the package settings")} <a class="link link-primary" href="{$system['system_url']}/{$control_panel['url']}/pro/packages">{__("Pro Packages")}</a></span>{/capture}
                  {include file='__admin_tip.tpl' _tip_id="dating-prices-tip" _tip_text=$_tip}
                </h2>

                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                  <label class="label-text" for="dating_super_likes_pack">{__("Super Likes Pack")}</label>
                  <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                    <input type="text" class="input w-full" name="dating_super_likes_pack" id="dating_super_likes_pack" value="{$system['dating_super_likes_pack']}" aria-describedby="dating_super_likes_pack-help" inputmode="numeric">
                    <div id="dating_super_likes_pack-help" class="admin-setting-help text-sm leading-relaxed">{__("The number of super likes in a pack")}</div>
                  </div>
                </div>

                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                  <label class="label-text" for="dating_super_likes_price">{__("Super Likes Pack Price")} ({$system['system_currency']})</label>
                  <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                    <input type="text" class="input w-full" name="dating_super_likes_price" id="dating_super_likes_price" value="{$system['dating_super_likes_price']}" aria-describedby="dating_super_likes_price-help" inputmode="decimal">
                    <div id="dating_super_likes_price-help" class="admin-setting-help text-sm leading-relaxed">{__("The price of a super likes pack from the wallet, 0 to disable")}</div>
                  </div>
                </div>

                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                  <label class="label-text" for="dating_boost_minutes">{__("Boost Minutes")}</label>
                  <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                    <input type="text" class="input w-full" name="dating_boost_minutes" id="dating_boost_minutes" value="{$system['dating_boost_minutes']}" aria-describedby="dating_boost_minutes-help" inputmode="numeric">
                    <div id="dating_boost_minutes-help" class="admin-setting-help text-sm leading-relaxed">{__("How long a boosted profile stays on top")}</div>
                  </div>
                </div>

                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                  <label class="label-text" for="dating_boost_price">{__("Boost Price")} ({$system['system_currency']})</label>
                  <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                    <input type="text" class="input w-full" name="dating_boost_price" id="dating_boost_price" value="{$system['dating_boost_price']}" aria-describedby="dating_boost_price-help" inputmode="decimal">
                    <div id="dating_boost_price-help" class="admin-setting-help text-sm leading-relaxed">{__("The price of a boost from the wallet, 0 to disable")}</div>
                  </div>
                </div>

                <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                  <div class="flex items-center gap-1">
                    <label class="label-text" for="dating_priority_message_price">{__("Message With a Like Price")} ({$system['system_currency']})</label>
                    {capture assign="_tip"}{__("Members can only chat after a match, this lets a member pay to attach a short note to a like before matching")} <span class="mt-2 block">{__("The note shows at the top of the other member's likes, even if they can not see who liked them, and they can like back to match or pass")}</span> <span class="mt-2 block">{__("The price is paid from the wallet for every message and no pro package includes it")}</span>{/capture}
                    {include file='__admin_tip.tpl' _tip_id="dating-message-tip" _tip_text=$_tip}
                  </div>
                  <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                    <input type="text" class="input w-full" name="dating_priority_message_price" id="dating_priority_message_price" value="{$system['dating_priority_message_price']}" aria-describedby="dating_priority_message_price-help" inputmode="decimal">
                    <div id="dating_priority_message_price-help" class="admin-setting-help text-sm leading-relaxed">{__("The price of sending a message with a like, 0 to disable")}</div>
                  </div>
                </div>
              </div>
            </section>

            {else}
              <div class="alert alert-soft alert-info" role="status">{__("Enable the wallet to sell super likes, boosts and messages with a like")}</div>
              <input type="hidden" name="dating_super_likes_pack" value="{$system['dating_super_likes_pack']}">
              <input type="hidden" name="dating_super_likes_price" value="{$system['dating_super_likes_price']}">
              <input type="hidden" name="dating_boost_minutes" value="{$system['dating_boost_minutes']}">
              <input type="hidden" name="dating_boost_price" value="{$system['dating_boost_price']}">
              <input type="hidden" name="dating_priority_message_price" value="{$system['dating_priority_message_price']}">
            {/if}

            <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
              <div class="admin-settings-actions flex flex-col items-stretch gap-3 px-6 pb-6 pt-6">
                <div class="admin-settings-feedback w-full min-w-0" aria-live="polite">
                  <div class="alert alert-success admin-settings-notice [overflow-wrap:anywhere]" role="status" style="display: none"></div>
                  <div class="alert alert-error alert-danger admin-settings-notice [overflow-wrap:anywhere]" role="alert" style="display: none"></div>
                </div>
                <div class="admin-settings-buttons flex w-full flex-wrap items-center justify-end gap-2">
                  <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
                </div>
              </div>
            </section>
          </div>
        </div>
      </form>
    </div>
  </section>

{else}
  <section class="admin-settings-page admin-list-page flex min-w-0 flex-col gap-6" aria-labelledby="admin-dating-title">
    {if $sub_view == "add_interest" || $sub_view == "edit_interest"}
      <div class="admin-form-layout mx-auto flex w-full max-w-[52rem] flex-col gap-6">
    {/if}

    {if $sub_view == "edit_member"}
      <header class="admin-user-hero flex min-w-0 flex-col gap-5 border-b border-base-300 pb-5 sm:flex-row sm:items-center sm:justify-between">
        <div class="admin-user-hero-identity flex min-w-0 items-center gap-4">
          <a class="admin-user-summary-photo size-16 shrink-0 overflow-hidden rounded-full border border-base-300 bg-base-200 focus-visible:outline-2 focus-visible:outline-offset-2" href="{$system['system_url']}/{$data['user_name']}" target="_blank" aria-label="{__("View Profile")}: {$data['user_firstname']} {$data['user_lastname']}">
            <img src="{$data['user_picture']}" alt="{$data['user_firstname']} {$data['user_lastname']}">
          </a>
          <div class="min-w-0">
            <h1 id="admin-dating-title" class="m-0 truncate text-2xl font-semibold" title="{$data['user_firstname']} {$data['user_lastname']}">
              <a class="text-inherit hover:underline focus-visible:underline focus-visible:outline-none" href="{$system['system_url']}/{$data['user_name']}" target="_blank">{$data['user_firstname']} {$data['user_lastname']}</a>
            </h1>
            <div class="admin-user-hero-meta mt-1 flex min-w-0 flex-wrap items-center gap-2">
              <a class="admin-user-summary-handle truncate" href="{$system['system_url']}/{$data['user_name']}" target="_blank" title="@{$data['user_name']}">@{$data['user_name']}</a>
              {if $data['status'] == "active"}
                <span class="badge badge-soft badge-success badge-sm rounded-full admin-user-hero-badge is-active">{__("Active")}</span>
              {elseif $data['status'] == "paused"}
                <span class="badge badge-soft badge-warning badge-sm rounded-full">{__("Paused")}</span>
              {else}
                <span class="badge badge-soft badge-error badge-sm rounded-full">{__("Suspended")}</span>
              {/if}
              {if $data['user_verified']}
                <span class="badge badge-soft badge-info badge-sm rounded-full admin-user-hero-badge is-verified">
                  <span class="icon-[tabler--rosette-discount-check] size-3.5" aria-hidden="true"></span>
                  {__("Verified")}
                </span>
              {/if}
            </div>
          </div>
        </div>
        <div class="admin-user-hero-actions flex shrink-0 flex-wrap items-center gap-2">
          <a class="btn btn-outline" href="{$system['system_url']}/{$control_panel['url']}/dating/members">
            <span class="icon-[tabler--arrow-left] size-4 rtl:rotate-180" aria-hidden="true"></span>
            {__("Go Back")}
          </a>
        </div>
      </header>
    {else}
    <header class="admin-list-heading flex items-start justify-between gap-4">
      <div class="admin-settings-heading grid gap-1.5">
        <h1 id="admin-dating-title" class="text-2xl font-semibold">
          {if $sub_view == "members"}{__("Dating Members")}
          {elseif $sub_view == "photos"}{__("Photos In Review")}
          {elseif $sub_view == "add_interest"}{__("Add New Interest")}
          {elseif $sub_view == "edit_interest"}{__("Edit Interest")}
          {else}{__("Interests")}{/if}
        </h1>
        <p class="text-base-content/60 text-sm">
          {if $sub_view == "members"}{__("Review dating profiles, suspend or remove them.")}
          {elseif $sub_view == "photos"}{__("Approve or delete the photos members uploaded.")}
          {elseif $sub_view == "add_interest"}{__("Create an interest members can pick.")}
          {elseif $sub_view == "edit_interest"}{__("Update this interest and its position.")}
          {else}{__("The interests members can add to their dating profile.")}{/if}
        </p>
      </div>

      <div class="admin-list-heading-actions flex shrink-0 flex-wrap items-center justify-end gap-2">
        {if $sub_view == "interests"}
          <a href="{$system['system_url']}/{$control_panel['url']}/dating/add_interest" class="btn btn-primary">
            <span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>
            {__("Add New Interest")}
          </a>
        {elseif $sub_view == "add_interest" || $sub_view == "edit_interest"}
          <a href="{$system['system_url']}/{$control_panel['url']}/dating/interests" class="btn btn-outline">
            <span class="icon-[tabler--arrow-left] size-4 rtl:rotate-180" aria-hidden="true"></span>
            {__("Go Back")}
          </a>
        {/if}
      </div>
    </header>
    {/if}

    {if $sub_view == "photos"}
      {if $rows}
        <section class="card admin-list-table-card min-w-0 overflow-visible border border-base-300 bg-base-100 shadow-none" aria-label="{__("Photos In Review")}">
          <div class="admin-list-table-wrap w-full overflow-x-auto">
            <table class="table admin-list-table">
              <thead>
                <tr>
                  <th>{__("Photo")}</th>
                  <th>{__("Member")}</th>
                  <th>{__("Uploaded")}</th>
                  <th class="admin-list-actions-column w-14 text-end"><span class="sr-only">{__("Actions")}</span></th>
                </tr>
              </thead>
              <tbody>
                {foreach $rows as $row}
                  <tr>
                    <td>
                      <button type="button" class="js_lightbox-nodata block h-20 w-15 cursor-pointer overflow-hidden rounded-lg bg-base-200" data-image="{$system['system_uploads']}/{$row['source']}" aria-label="{__("View Photo")}">
                        <img class="size-full object-cover" src="{$system['system_uploads']}/{$row['source']}" alt="" loading="lazy">
                      </button>
                    </td>
                    <td>
                      <a class="flex min-w-0 items-center gap-3" target="_blank" href="{$system['system_url']}/{$row['user_name']}">
                        <img class="size-9 shrink-0 rounded-full object-cover" src="{$row['user_picture']}" alt="" loading="lazy">
                        <span class="admin-list-name max-w-48 truncate text-sm font-semibold" title="{$row['user_firstname']} {$row['user_lastname']}">{$row['user_firstname']} {$row['user_lastname']}</span>
                      </a>
                    </td>
                    <td>{$row['time']|date_format:"%e %B %Y"}</td>
                    <td class="admin-list-actions-column w-14 text-end">
                      <div class="dropdown relative inline-flex [--placement:bottom-end]">
                        <button id="dating-photo-actions-{$row['photo_id']}" type="button" class="dropdown-toggle btn btn-text btn-circle btn-sm" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Open actions for")} {$row['user_firstname']} {$row['user_lastname']}">
                          <span class="icon-[tabler--dots-vertical] size-5" aria-hidden="true"></span>
                        </button>
                        <ul class="dropdown-menu dropdown-open:opacity-100 menu-sm hidden p-1 admin-list-actions-menu" role="menu" aria-orientation="vertical" aria-labelledby="dating-photo-actions-{$row['photo_id']}">
                          <li>
                            <form class="js_ajax-forms contents" data-url="admin/dating.php?do=approve_photo&amp;id={$row['photo_id']}">
                              <button type="submit" class="dropdown-item px-2" role="menuitem">
                                <span class="icon-[tabler--check] size-4" aria-hidden="true"></span>
                                {__("Approve")}
                              </button>
                            </form>
                          </li>
                          <li>
                            <button type="button" class="dropdown-item px-2 text-error js_admin-deleter" role="menuitem" data-handle="dating_photo" data-id="{$row['photo_id']}">
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
        </section>
        {if $pager}
          <div class="admin-list-pager">{$pager}</div>
        {/if}
      {else}
        <section class="card admin-list-empty flex min-h-[300px] flex-col items-center justify-center border border-base-300 bg-base-100 px-6 py-10 text-center shadow-none">
          <div class="admin-list-empty-icon mb-4 flex size-12 items-center justify-center rounded-[14px] border border-base-300 bg-base-200">
            <span class="icon-[tabler--photo-check] size-6" aria-hidden="true"></span>
          </div>
          <h2>{__("Nothing to review")}</h2>
          <p>{__("New dating photos will show up here when photos approval is on.")}</p>
        </section>
      {/if}

    {elseif $sub_view == "members"}
      <div>
        <nav class="tabs admin-settings-nav admin-form-tabs" aria-label="{__("Status")}">
          <a class="tab{if $status == ""} tab-active{/if}" href="{$system['system_url']}/{$control_panel['url']}/dating/members{if $query}?query={$query_url}{/if}" {if $status == ""}aria-current="page"{/if}>
            <span class="icon-[tabler--users] size-4" aria-hidden="true"></span>{__("All")}
          </a>
          <a class="tab{if $status == "active"} tab-active{/if}" href="{$system['system_url']}/{$control_panel['url']}/dating/members?status=active{if $query}&amp;query={$query_url}{/if}" {if $status == "active"}aria-current="page"{/if}>
            <span class="icon-[tabler--circle-check] size-4" aria-hidden="true"></span>{__("Active")}
          </a>
          <a class="tab{if $status == "paused"} tab-active{/if}" href="{$system['system_url']}/{$control_panel['url']}/dating/members?status=paused{if $query}&amp;query={$query_url}{/if}" {if $status == "paused"}aria-current="page"{/if}>
            <span class="icon-[tabler--player-pause] size-4" aria-hidden="true"></span>{__("Paused")}
          </a>
          <a class="tab{if $status == "suspended"} tab-active{/if}" href="{$system['system_url']}/{$control_panel['url']}/dating/members?status=suspended{if $query}&amp;query={$query_url}{/if}" {if $status == "suspended"}aria-current="page"{/if}>
            <span class="icon-[tabler--user-off] size-4" aria-hidden="true"></span>{__("Suspended")}
          </a>
        </nav>
      </div>

      <section class="card admin-list-table-card min-w-0 overflow-visible border border-base-300 bg-base-100 shadow-none" aria-label="{__("Dating Members")}">
        <div class="js-flyonui-datatable-toolbar border-base-300 flex items-center justify-between gap-3 border-b px-5 py-3 max-md:flex-wrap">
          <form class="input max-w-60" action="{$system['system_url']}/{$control_panel['url']}/dating/members" method="get" role="search">
            <span class="icon-[tabler--search] text-base-content/80 my-auto me-3 size-4 shrink-0" aria-hidden="true"></span>
            {if $status}<input type="hidden" name="status" value="{$status}">{/if}
            <input type="search" class="grow" name="query" id="admin-dating-members-query" value="{$query}" placeholder="{__("Search")}" title="{__("Search by Username, First Name, Last Name, Email or Phone")}" aria-label="{__("Search by Username, First Name, Last Name, Email or Phone")}" autocomplete="off">
          </form>
        </div>
        {if $rows}
          <div class="admin-list-table-wrap w-full overflow-x-auto">
            <table class="table admin-list-table">
              <thead>
                <tr>
                  <th>{__("Member")}</th>
                  <th>{__("Age")}</th>
                  <th>{__("City")}</th>
                  <th>{__("Likes")}</th>
                  <th>{__("Matches")}</th>
                  <th>{__("Reports")}</th>
                  <th>{__("Status")}</th>
                  <th>{__("Joined")}</th>
                  <th class="admin-list-actions-column w-14 text-end"><span class="sr-only">{__("Actions")}</span></th>
                </tr>
              </thead>
              <tbody>
                {foreach $rows as $row}
                  <tr>
                    <td>
                      <a class="flex min-w-0 items-center gap-3" href="{$system['system_url']}/{$control_panel['url']}/dating/edit_member/{$row['user_id']}">
                        <img class="size-9 shrink-0 rounded-full object-cover" src="{$row['user_picture']}" alt="" loading="lazy">
                        <span class="admin-list-name max-w-48 truncate text-sm font-semibold" title="{$row['user_firstname']} {$row['user_lastname']}">{$row['user_firstname']} {$row['user_lastname']}</span>
                      </a>
                    </td>
                    <td>{$row['age']}</td>
                    <td><span class="block max-w-32 truncate" title="{$row['city']}">{$row['city']}</span></td>
                    <td>{$row['likes']|number_format}</td>
                    <td>{$row['matches']|number_format}</td>
                    <td>{if $row['reports']}<span class="badge badge-soft badge-error badge-sm rounded-full">{$row['reports']}</span>{else}0{/if}</td>
                    <td>
                      {if $row['status'] == "active"}<span class="badge badge-soft badge-success badge-sm rounded-full">{__("Active")}</span>
                      {elseif $row['status'] == "paused"}<span class="badge badge-soft badge-sm rounded-full">{__("Paused")}</span>
                      {else}<span class="badge badge-soft badge-error badge-sm rounded-full">{__("Suspended")}</span>{/if}
                    </td>
                    <td>{$row['time']|date_format:"%e %B %Y"}</td>
                    <td class="admin-list-actions-column w-14 text-end">
                      <div class="dropdown relative inline-flex [--placement:bottom-end]">
                        <button id="dating-member-actions-{$row['user_id']}" type="button" class="dropdown-toggle btn btn-text btn-circle btn-sm" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Open actions for")} {$row['user_firstname']} {$row['user_lastname']}">
                          <span class="icon-[tabler--dots-vertical] size-5" aria-hidden="true"></span>
                        </button>
                        <ul class="dropdown-menu dropdown-open:opacity-100 menu-sm hidden p-1 admin-list-actions-menu" role="menu" aria-orientation="vertical" aria-labelledby="dating-member-actions-{$row['user_id']}">
                          <li>
                            <a class="dropdown-item px-2" role="menuitem" href="{$system['system_url']}/{$control_panel['url']}/dating/edit_member/{$row['user_id']}">
                              <span class="icon-[tabler--edit] size-4" aria-hidden="true"></span>
                              {__("Edit")}
                            </a>
                          </li>
                          <li>
                            <form class="js_ajax-forms contents" data-url="admin/dating.php?do={if $row['status'] == "suspended"}unsuspend{else}suspend{/if}&amp;id={$row['user_id']}">
                              <button type="submit" class="dropdown-item px-2" role="menuitem">
                                <span class="{if $row['status'] == "suspended"}icon-[tabler--user-check]{else}icon-[tabler--user-off]{/if} size-4" aria-hidden="true"></span>
                                {if $row['status'] == "suspended"}{__("Unsuspend")}{else}{__("Suspend")}{/if}
                              </button>
                            </form>
                          </li>
                          <li>
                            <button type="button" class="dropdown-item px-2 text-error js_admin-deleter" role="menuitem" data-handle="dating_profile" data-id="{$row['user_id']}">
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
          <div class="admin-list-empty admin-list-empty-inline flex min-h-60 flex-col items-center justify-center px-6 py-10 text-center">
            <div class="admin-list-empty-icon mb-4 flex size-12 items-center justify-center rounded-[14px] border border-base-300 bg-base-200">
              <span class="icon-[tabler--users] size-6" aria-hidden="true"></span>
            </div>
            <h2>{if $query}{__("No members found")}{else}{__("No members yet")}{/if}</h2>
            <p>{if $query}{__("Try a different search.")}{else}{__("Dating profiles will show up here.")}{/if}</p>
          </div>
        {/if}
      </section>
      {if $rows && $pager}
        <div class="admin-list-pager">{$pager}</div>
      {/if}

    {elseif $sub_view == "edit_member"}
      <div class="admin-user-edit grid w-full gap-6">
        <div class="admin-user-edit-aside flex min-w-0 flex-col gap-4 lg:sticky lg:top-[5.5rem]">
          <!-- summary -->
          <aside class="admin-user-summary flex min-w-0 flex-col gap-5 border border-base-300 bg-base-100 p-6" aria-label="{__("Dating Profile")}">
            <div class="admin-user-sidebar-heading flex min-w-0 items-center gap-3">
              <div class="admin-user-sidebar-heading-icon flex size-8 shrink-0 items-center justify-center rounded-md border border-base-300 bg-base-100">
                <span class="icon-[tabler--user-heart] size-4" aria-hidden="true"></span>
              </div>
              <h2 class="admin-settings-section-title m-0 text-sm font-semibold leading-snug">{__("Dating Profile")}</h2>
            </div>
            <ul class="admin-user-summary-list grid gap-3">
              <li>
                <span class="admin-user-summary-label"><span class="icon-[tabler--id] size-3.5" aria-hidden="true"></span>{__("User ID")}</span>
                <span class="admin-user-summary-value">{$data['user_id']}</span>
              </li>
              <li>
                <span class="admin-user-summary-label"><span class="icon-[tabler--heart] size-3.5" aria-hidden="true"></span>{__("Likes")}</span>
                <span class="admin-user-summary-value">{$data['likes']|number_format}</span>
              </li>
              <li>
                <span class="admin-user-summary-label"><span class="icon-[tabler--heart-handshake] size-3.5" aria-hidden="true"></span>{__("Matches")}</span>
                <span class="admin-user-summary-value">{$data['matches']|number_format}</span>
              </li>
              <li>
                <span class="admin-user-summary-label"><span class="icon-[tabler--flag] size-3.5" aria-hidden="true"></span>{__("Reports")}</span>
                <span class="admin-user-summary-value">{$data['reports']|number_format}</span>
              </li>
              <li>
                <span class="admin-user-summary-label"><span class="icon-[tabler--photo] size-3.5" aria-hidden="true"></span>{__("Photos")}</span>
                <span class="admin-user-summary-value">{$data['photos']|count}</span>
              </li>
              {if $data['boosted']}
                <li>
                  <span class="admin-user-summary-label"><span class="icon-[tabler--bolt] size-3.5" aria-hidden="true"></span>{__("Boosted Until")}</span>
                  <span class="admin-user-summary-value">{$data['boosted_until']|date_format:"%e %B %Y %H:%M"}</span>
                </li>
              {/if}
            </ul>
            <div class="admin-user-summary-actions grid gap-2 border-t border-base-300 pt-5">
              <a class="btn btn-outline w-full" href="{$system['system_url']}/{$data['user_name']}" target="_blank">
                <span class="icon-[tabler--arrow-up-right] size-4" aria-hidden="true"></span>
                {__("View Profile")}
              </a>
              <form class="js_ajax-forms contents" data-url="admin/dating.php?do={if $data['status'] == "active"}pause{elseif $data['status'] == "paused"}resume{else}unsuspend{/if}&amp;id={$data['user_id']}">
                {if $data['status'] == "active"}
                  <button type="submit" class="btn btn-outline w-full" title="{__("Hide the profile from everyone, the matches stay")}">
                    <span class="icon-[tabler--player-pause] size-4" aria-hidden="true"></span>
                    {__("Pause Profile")}
                  </button>
                {elseif $data['status'] == "paused"}
                  <button type="submit" class="btn btn-outline w-full" title="{__("The profile is paused and hidden from everyone")}">
                    <span class="icon-[tabler--player-play] size-4" aria-hidden="true"></span>
                    {__("Resume Profile")}
                  </button>
                {else}
                  <button type="submit" class="btn btn-outline w-full" title="{__("The profile is suspended, the member can not use dating")}">
                    <span class="icon-[tabler--lock-open] size-4" aria-hidden="true"></span>
                    {__("Unsuspend Profile")}
                  </button>
                {/if}
              </form>
              {if $data['status'] != "suspended"}
                <form class="js_ajax-forms contents" data-url="admin/dating.php?do=suspend&amp;id={$data['user_id']}">
                  <button type="submit" class="btn btn-outline w-full" title="{__("Block the member from dating, the account stays active")}">
                    <span class="icon-[tabler--ban] size-4" aria-hidden="true"></span>
                    {__("Suspend Profile")}
                  </button>
                </form>
              {/if}
            </div>
          </aside>
          <!-- summary -->

          <!-- danger zone -->
          <section class="admin-user-danger flex min-w-0 flex-col gap-5 border border-base-300 bg-base-100 p-6" aria-labelledby="admin-dating-danger-title">
            <div class="admin-user-sidebar-heading flex min-w-0 items-center gap-3">
              <div class="admin-user-sidebar-heading-icon is-danger flex size-8 shrink-0 items-center justify-center rounded-md border bg-base-100">
                <span class="icon-[tabler--alert-triangle] size-4" aria-hidden="true"></span>
              </div>
              <h2 id="admin-dating-danger-title" class="admin-user-danger-title m-0 text-sm font-semibold leading-snug text-error">{__("Danger Zone")}</h2>
            </div>
            <p class="admin-setting-help m-0 text-sm leading-relaxed">{__("Delete the dating profile, photos, likes and matches")}</p>
            <div class="admin-user-summary-actions grid gap-2">
              <button type="button" class="btn w-full text-error admin-user-danger-action js_admin-deleter" data-handle="dating_profile" data-id="{$data['user_id']}" data-redirect="{$system['system_url']}/{$control_panel['url']}/dating/members">
                <span class="icon-[tabler--trash] size-4" aria-hidden="true"></span>
                {__("Delete Profile")}
              </button>
            </div>
          </section>
          <!-- danger zone -->
        </div>

        <div class="admin-user-edit-main flex min-w-0 flex-col gap-6">
          <nav class="tabs admin-settings-nav admin-user-edit-nav" role="tablist" aria-label="{__("Dating Profile")}" aria-orientation="horizontal">
            <button type="button" id="dating-member-tab-profile" class="tab active-tab:tab-active active" data-tab="#dating-member-profile" aria-controls="dating-member-profile" role="tab" aria-selected="true"><span class="icon-[tabler--user-heart] size-4" aria-hidden="true"></span>{__("Profile")}</button>
            <button type="button" id="dating-member-tab-preferences" class="tab active-tab:tab-active" data-tab="#dating-member-preferences" aria-controls="dating-member-preferences" role="tab" aria-selected="false"><span class="icon-[tabler--adjustments-horizontal] size-4" aria-hidden="true"></span>{__("Preferences")}</button>
            <button type="button" id="dating-member-tab-privacy" class="tab active-tab:tab-active" data-tab="#dating-member-privacy" aria-controls="dating-member-privacy" role="tab" aria-selected="false"><span class="icon-[tabler--lock] size-4" aria-hidden="true"></span>{__("Privacy")}</button>
            <button type="button" id="dating-member-tab-photos" class="tab active-tab:tab-active" data-tab="#dating-member-photos" aria-controls="dating-member-photos" role="tab" aria-selected="false"><span class="icon-[tabler--photo] size-4" aria-hidden="true"></span>{__("Photos")}</button>
          </nav>

          <form class="js_ajax-forms contents" data-url="admin/dating.php?do=edit_member&amp;id={$data['user_id']}">
            <!-- profile -->
            <div id="dating-member-profile" class="admin-settings-panel js_admin-settings-panel" role="tabpanel" aria-labelledby="dating-member-tab-profile" tabindex="0">
              <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
                <div class="admin-settings-section flex flex-col gap-5 p-6">
                  <h2 class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
                    <span class="icon-[tabler--circle-check] size-5" aria-hidden="true"></span>
                    {__("Profile Status")}
                  </h2>

                  <div class="grid min-w-0 items-start gap-5 sm:grid-cols-2">
                    <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                      <label class="label-text" for="dating-member-status">{__("Status")}</label>
                      <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                        <select class="select w-full" name="status" id="dating-member-status">
                          <option {if $data['status'] == "active"}selected{/if} value="active">{__("Active")}</option>
                          <option {if $data['status'] == "paused"}selected{/if} value="paused">{__("Paused")}</option>
                          <option {if $data['status'] == "suspended"}selected{/if} value="suspended">{__("Suspended")}</option>
                        </select>
                      </div>
                    </div>

                    <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                      <label class="label-text" for="dating-member-super-likes">{__("Purchased Super Likes")}</label>
                      <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                        <input type="number" class="input w-full" name="super_likes_balance" id="dating-member-super-likes" min="0" value="{$data['super_likes_balance']}">
                      </div>
                    </div>
                  </div>
                </div>

                <div class="admin-settings-section flex flex-col gap-5 p-6">
                  <h2 class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
                    <span class="icon-[tabler--user-heart] size-5" aria-hidden="true"></span>
                    {__("Dating Profile")}
                  </h2>

                  <div class="grid min-w-0 items-start gap-5 sm:grid-cols-2">
                    <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                      <label class="label-text" for="dating-member-birthdate">{__("Birthdate")}</label>
                      <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                        <input type="date" class="input w-full" name="birthdate" id="dating-member-birthdate" value="{$data['birthdate']}">
                      </div>
                    </div>

                    <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                      <label class="label-text" for="dating-member-gender">{__("Gender")}</label>
                      <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                        <select class="select w-full" name="gender" id="dating-member-gender">
                          {foreach $genders as $_gender}
                            <option {if $data['gender'] == $_gender['gender_id']}selected{/if} value="{$_gender['gender_id']}">{$_gender['gender_name']}</option>
                          {/foreach}
                        </select>
                      </div>
                    </div>
                  </div>

                  <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                    <label class="label-text" for="dating-member-bio">{__("About Me")}</label>
                    <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                      <textarea class="textarea w-full" name="bio" id="dating-member-bio" rows="3" maxlength="500" dir="auto">{$data['bio']}</textarea>
                    </div>
                  </div>

                  <div class="grid min-w-0 items-start gap-5 sm:grid-cols-2">
                    <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                      <label class="label-text" for="dating-member-country">{__("Country")}</label>
                      <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                        <select class="select w-full" name="country" id="dating-member-country">
                          <option value="0">{__("Select Country")}</option>
                          {foreach $countries as $_country}
                            <option {if $data['country_id'] == $_country['country_id']}selected{/if} value="{$_country['country_id']}">{$_country['country_name_with_flag']}</option>
                          {/foreach}
                        </select>
                      </div>
                    </div>

                    <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                      <label class="label-text" for="dating-member-city">{__("City")}</label>
                      <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                        <input type="text" class="input w-full" name="city" id="dating-member-city" maxlength="100" value="{$data['city']}">
                      </div>
                    </div>
                  </div>
                </div>

                {if $dating_interests}
                  <div class="admin-settings-section flex flex-col gap-5 p-6">
                    <h2 class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
                      <span class="icon-[tabler--sparkles] size-5" aria-hidden="true"></span>
                      {__("Interests")}
                    </h2>
                    <div class="flex flex-wrap gap-2">
                      {foreach $dating_interests as $_interest}
                        <label class="inline-flex cursor-pointer items-center gap-1.5 rounded-full border border-base-300 px-3 py-1.5 text-sm transition-colors hover:bg-base-200/60 has-[:checked]:border-primary has-[:checked]:bg-primary has-[:checked]:text-primary-content">
                          <input type="checkbox" class="sr-only" name="interests[]" value="{$_interest['interest_id']}" {if in_array($_interest['interest_id'], $data['interests'])}checked{/if}>
                          <span aria-hidden="true">{$_interest['icon']}</span>
                          {__($_interest['title'])}
                        </label>
                      {/foreach}
                    </div>
                  </div>
                {/if}

                <div class="admin-settings-actions flex flex-col items-stretch gap-3 px-6 pb-6 pt-4">
                  <div class="admin-settings-feedback w-full min-w-0" aria-live="polite">
                    <div class="alert alert-success admin-settings-notice [overflow-wrap:anywhere]" role="status" style="display: none"></div>
                    <div class="alert alert-error alert-danger admin-settings-notice [overflow-wrap:anywhere]" role="alert" style="display: none"></div>
                  </div>
                  <div class="admin-settings-buttons flex w-full flex-wrap items-center justify-end gap-2">
                    <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
                  </div>
                </div>
              </section>
            </div>
            <!-- profile -->

            <!-- preferences -->
            <div id="dating-member-preferences" class="admin-settings-panel js_admin-settings-panel hidden" role="tabpanel" aria-labelledby="dating-member-tab-preferences" tabindex="0">
              <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
                <div class="admin-settings-section flex flex-col gap-5 p-6">
                  <h2 class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
                    <span class="icon-[tabler--adjustments-horizontal] size-5" aria-hidden="true"></span>
                    {__("Who They Want to Meet")}
                  </h2>

                  <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field {if $system['genders_disabled']}hidden{/if}" role="group" aria-labelledby="dating-member-show-label">
                    <div class="label-text" id="dating-member-show-label">{__("Looking For")}</div>
                    <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                      <div class="flex flex-wrap gap-2">
                        {foreach $genders as $_gender}
                          <label class="inline-flex cursor-pointer items-center gap-1.5 rounded-full border border-base-300 px-3 py-1.5 text-sm transition-colors hover:bg-base-200/60 has-[:checked]:border-primary has-[:checked]:bg-primary has-[:checked]:text-primary-content">
                            <input type="checkbox" class="sr-only" name="show_genders[]" value="{$_gender['gender_id']}" {if in_array($_gender['gender_id'], $data['show_genders'])}checked{/if}>
                            {$_gender['gender_name']}
                          </label>
                        {/foreach}
                      </div>
                      <div class="admin-setting-help text-sm leading-relaxed">{__("Leave empty to see everyone")}</div>
                    </div>
                  </div>

                  <div class="grid min-w-0 items-start gap-5 sm:grid-cols-3">
                    <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                      <label class="label-text" for="dating-member-min-age">{__("Min Age")}</label>
                      <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                        <input type="number" class="input w-full" name="min_age" id="dating-member-min-age" min="{$system['dating_min_age']}" max="99" value="{$data['min_age']}">
                      </div>
                    </div>

                    <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                      <label class="label-text" for="dating-member-max-age">{__("Max Age")}</label>
                      <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                        <input type="number" class="input w-full" name="max_age" id="dating-member-max-age" min="{$system['dating_min_age']}" max="99" value="{$data['max_age']}">
                      </div>
                    </div>

                    <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                      <label class="label-text" for="dating-member-distance">{__("Max Distance")}</label>
                      <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                        <label class="input w-full">
                          <input type="number" class="grow" name="max_distance" id="dating-member-distance" min="1" max="{$system['dating_max_distance']}" value="{$data['max_distance']}">
                          <span class="my-auto ms-2 shrink-0 text-sm text-base-content/60">{if $system['system_distance'] == "mile"}{__("ML")}{else}{__("KM")}{/if}</span>
                        </label>
                      </div>
                    </div>
                  </div>
                </div>

                <div class="admin-settings-actions flex flex-col items-stretch gap-3 px-6 pb-6 pt-4">
                  <div class="admin-settings-feedback w-full min-w-0" aria-live="polite">
                    <div class="alert alert-success admin-settings-notice [overflow-wrap:anywhere]" role="status" style="display: none"></div>
                    <div class="alert alert-error alert-danger admin-settings-notice [overflow-wrap:anywhere]" role="alert" style="display: none"></div>
                  </div>
                  <div class="admin-settings-buttons flex w-full flex-wrap items-center justify-end gap-2">
                    <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
                  </div>
                </div>
              </section>
            </div>
            <!-- preferences -->

            <!-- privacy -->
            <div id="dating-member-privacy" class="admin-settings-panel js_admin-settings-panel hidden" role="tabpanel" aria-labelledby="dating-member-tab-privacy" tabindex="0">
              <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
                <div class="admin-settings-section flex flex-col gap-5 p-6">
                  <h2 class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
                    <span class="icon-[tabler--lock] size-5" aria-hidden="true"></span>
                    {__("Privacy")}
                  </h2>

                  <div class="admin-setting-switch js_admin-setting-switch">
                    <div class="admin-setting-icon">
                      <span class="icon-[tabler--users-minus] size-6" aria-hidden="true"></span>
                    </div>
                    <div>
                      <label class="admin-setting-label block text-sm font-medium leading-normal" for="dating-member-hide-from-friends">{__("Hide from friends")}</label>
                      <div id="dating-member-hide-from-friends-help" class="admin-setting-help text-sm leading-relaxed">{__("They will not see this member in dating and this member will not see them")}</div>
                    </div>
                    <div class="text-end">
                      <input type="checkbox" class="switch switch-primary shrink-0 [--radius-selector:9999px]" name="hide_from_friends" id="dating-member-hide-from-friends" {if $data['hide_from_friends']}checked{/if} aria-describedby="dating-member-hide-from-friends-help">
                    </div>
                  </div>

                  <div class="admin-setting-switch js_admin-setting-switch">
                    <div class="admin-setting-icon">
                      <span class="icon-[tabler--cake-off] size-6" aria-hidden="true"></span>
                    </div>
                    <div>
                      <label class="admin-setting-label block text-sm font-medium leading-normal" for="dating-member-hide-age">{__("Hide age")}</label>
                      <div id="dating-member-hide-age-help" class="admin-setting-help text-sm leading-relaxed">{__("Other members will not see this member's age")}</div>
                    </div>
                    <div class="text-end">
                      <input type="checkbox" class="switch switch-primary shrink-0 [--radius-selector:9999px]" name="hide_age" id="dating-member-hide-age" {if $data['hide_age']}checked{/if} aria-describedby="dating-member-hide-age-help">
                    </div>
                  </div>

                  <div class="admin-setting-switch js_admin-setting-switch">
                    <div class="admin-setting-icon">
                      <span class="icon-[tabler--map-pin-off] size-6" aria-hidden="true"></span>
                    </div>
                    <div>
                      <label class="admin-setting-label block text-sm font-medium leading-normal" for="dating-member-hide-distance">{__("Hide distance")}</label>
                      <div id="dating-member-hide-distance-help" class="admin-setting-help text-sm leading-relaxed">{__("The exact location is never shown")}</div>
                    </div>
                    <div class="text-end">
                      <input type="checkbox" class="switch switch-primary shrink-0 [--radius-selector:9999px]" name="hide_distance" id="dating-member-hide-distance" {if $data['hide_distance']}checked{/if} aria-describedby="dating-member-hide-distance-help">
                    </div>
                  </div>

                  <div class="admin-setting-switch js_admin-setting-switch">
                    <div class="admin-setting-icon">
                      <span class="icon-[tabler--spy] size-6" aria-hidden="true"></span>
                    </div>
                    <div>
                      <label class="admin-setting-label block text-sm font-medium leading-normal" for="dating-member-incognito">{__("Incognito mode")}</label>
                      <div id="dating-member-incognito-help" class="admin-setting-help text-sm leading-relaxed">{__("Only the members they liked can see them, a pro package perk")}</div>
                    </div>
                    <div class="text-end">
                      <input type="checkbox" class="switch switch-primary shrink-0 [--radius-selector:9999px]" name="incognito" id="dating-member-incognito" {if $data['incognito']}checked{/if} aria-describedby="dating-member-incognito-help">
                    </div>
                  </div>
                </div>

                <div class="admin-settings-actions flex flex-col items-stretch gap-3 px-6 pb-6 pt-4">
                  <div class="admin-settings-feedback w-full min-w-0" aria-live="polite">
                    <div class="alert alert-success admin-settings-notice [overflow-wrap:anywhere]" role="status" style="display: none"></div>
                    <div class="alert alert-error alert-danger admin-settings-notice [overflow-wrap:anywhere]" role="alert" style="display: none"></div>
                  </div>
                  <div class="admin-settings-buttons flex w-full flex-wrap items-center justify-end gap-2">
                    <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
                  </div>
                </div>
              </section>
            </div>
            <!-- privacy -->
          </form>

          <!-- photos -->
          <div id="dating-member-photos" class="admin-settings-panel js_admin-settings-panel hidden" role="tabpanel" aria-labelledby="dating-member-tab-photos" tabindex="0">
            <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
              <div class="admin-settings-section flex flex-col gap-5 p-6">
                <h2 class="admin-settings-section-title m-0 text-sm font-semibold leading-snug js_admin-settings-section-title">
                  <span class="icon-[tabler--photo] size-5" aria-hidden="true"></span>
                  {__("Photos")}
                </h2>
                {if $data['photos']}
                  <ul class="grid grid-cols-2 gap-3 sm:grid-cols-3 xl:grid-cols-4">
                    {foreach $data['photos'] as $_photo}
                      <li class="relative aspect-[3/4] overflow-hidden rounded-box border border-base-300 bg-base-200">
                        <button type="button" class="js_lightbox-nodata block size-full cursor-pointer" data-image="{$_photo['url']}" aria-label="{__("View Photo")}">
                          <img class="size-full object-cover" src="{$_photo['url']}" alt="" loading="lazy">
                        </button>
                        {if $_photo@first}
                          <span class="badge badge-primary badge-sm absolute bottom-2 start-2 rounded-full">{__("Main")}</span>
                        {/if}
                        {if $_photo['status'] == "pending"}
                          <span class="badge badge-warning badge-sm absolute bottom-2 end-2 rounded-full">{__("In Review")}</span>
                        {/if}
                        <div class="absolute end-1.5 top-1.5 flex gap-1.5">
                          {if $_photo['status'] == "pending"}
                            <form class="js_ajax-forms contents" data-url="admin/dating.php?do=approve_photo&amp;id={$_photo['photo_id']}">
                              <button type="submit" class="btn btn-circle btn-sm border-0 bg-base-100/90 text-success shadow-sm hover:bg-base-100" title="{__("Approve")}" aria-label="{__("Approve")}">
                                <span class="icon-[tabler--check] size-4" aria-hidden="true"></span>
                              </button>
                            </form>
                          {/if}
                          <button type="button" class="btn btn-circle btn-sm border-0 bg-base-100/90 text-error shadow-sm hover:bg-base-100 js_admin-deleter" data-handle="dating_photo" data-id="{$_photo['photo_id']}" title="{__("Delete")}" aria-label="{__("Delete")}">
                            <span class="icon-[tabler--x] size-4" aria-hidden="true"></span>
                          </button>
                        </div>
                      </li>
                    {/foreach}
                  </ul>
                  <div class="admin-setting-help text-sm leading-relaxed">{__("The first photo is the main one")}</div>
                {else}
                  <div class="admin-setting-help text-sm leading-relaxed">{__("This member has no dating photos")}</div>
                {/if}
              </div>
            </section>
          </div>
          <!-- photos -->
        </div>
      </div>

    {elseif $sub_view == "interests"}
      {if $rows}
        <section class="card admin-list-table-card min-w-0 overflow-visible border border-base-300 bg-base-100 shadow-none" aria-label="{__("Interests")}">
          <div class="admin-list-table-wrap w-full overflow-x-auto">
            <table class="table admin-list-table min-w-0!">
              <thead>
                <tr>
                  <th>{__("Interest")}</th>
                  <th>{__("Order")}</th>
                  <th class="admin-list-actions-column w-14 text-end"><span class="sr-only">{__("Actions")}</span></th>
                </tr>
              </thead>
              <tbody>
                {foreach $rows as $row}
                  <tr>
                    <td><span class="admin-list-name text-sm font-semibold">{$row['icon']} {$row['title']}</span></td>
                    <td>{$row['interest_order']}</td>
                    <td class="admin-list-actions-column w-14 text-end">
                      <div class="dropdown relative inline-flex [--placement:bottom-end]">
                        <button id="dating-interest-actions-{$row['interest_id']}" type="button" class="dropdown-toggle btn btn-text btn-circle btn-sm" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Open actions for")} {$row['title']}">
                          <span class="icon-[tabler--dots-vertical] size-5" aria-hidden="true"></span>
                        </button>
                        <ul class="dropdown-menu dropdown-open:opacity-100 menu-sm hidden p-1 admin-list-actions-menu" role="menu" aria-orientation="vertical" aria-labelledby="dating-interest-actions-{$row['interest_id']}">
                          <li>
                            <a class="dropdown-item px-2" role="menuitem" href="{$system['system_url']}/{$control_panel['url']}/dating/edit_interest/{$row['interest_id']}">
                              <span class="icon-[tabler--edit] size-4" aria-hidden="true"></span>
                              {__("Edit")}
                            </a>
                          </li>
                          <li>
                            <button type="button" class="dropdown-item px-2 text-error js_admin-deleter" role="menuitem" data-handle="dating_interest" data-id="{$row['interest_id']}">
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
        </section>
      {else}
        <section class="card admin-list-empty flex min-h-[300px] flex-col items-center justify-center border border-base-300 bg-base-100 px-6 py-10 text-center shadow-none">
          <div class="admin-list-empty-icon mb-4 flex size-12 items-center justify-center rounded-[14px] border border-base-300 bg-base-200">
            <span class="icon-[tabler--sparkles] size-6" aria-hidden="true"></span>
          </div>
          <h2>{__("No interests yet")}</h2>
          <p>{__("Add interests members can pick for their dating profile.")}</p>
        </section>
      {/if}

    {elseif $sub_view == "add_interest" || $sub_view == "edit_interest"}
      <form class="js_ajax-forms admin-settings-form flex min-w-0 flex-col gap-4" data-url="admin/dating.php?do={if $sub_view == "edit_interest"}edit_interest&amp;id={$data['interest_id']}{else}add_interest{/if}">
        <section class="card admin-settings-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
          <div class="admin-settings-section flex flex-col gap-5 p-6">
            <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
              <label class="label-text" for="dating-interest-title">{__("Title")}</label>
              <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                <input class="input w-full" name="title" id="dating-interest-title" maxlength="64" value="{if $sub_view == "edit_interest"}{$data['title']}{/if}" autocomplete="off">
              </div>
            </div>

            <div class="grid min-w-0 gap-5 md:grid-cols-2">
              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="dating-interest-icon">{__("Emoji")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input class="input w-full" name="icon" id="dating-interest-icon" maxlength="8" value="{if $sub_view == "edit_interest"}{$data['icon']}{/if}" autocomplete="off">
                  <div class="admin-setting-help text-sm leading-relaxed">{__("An emoji shown before the title.")}</div>
                </div>
              </div>

              <div class="admin-setting-field flex min-w-0 flex-col gap-2 js_admin-setting-field">
                <label class="label-text" for="dating-interest-order">{__("Order")}</label>
                <div class="admin-setting-control flex min-w-0 flex-col gap-2">
                  <input class="input w-full" name="interest_order" id="dating-interest-order" value="{if $sub_view == "edit_interest"}{$data['interest_order']}{/if}" inputmode="numeric">
                  <div class="admin-setting-help text-sm leading-relaxed">{__("Lower numbers appear first.")}</div>
                </div>
              </div>
            </div>
          </div>

          <div class="admin-settings-actions flex flex-col items-stretch gap-3 px-6 pb-6 pt-4">
            <div class="admin-settings-feedback w-full min-w-0" aria-live="polite">
              <div class="alert alert-success admin-settings-notice [overflow-wrap:anywhere]" role="status" style="display: none"></div>
              <div class="alert alert-error alert-danger admin-settings-notice [overflow-wrap:anywhere]" role="alert" style="display: none"></div>
            </div>
            <div class="admin-settings-buttons flex w-full flex-wrap items-center justify-end gap-2">
              <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
            </div>
          </div>
        </section>
      </form>
    {/if}

    {if $sub_view == "add_interest" || $sub_view == "edit_interest"}
      </div>
    {/if}
  </section>
{/if}
