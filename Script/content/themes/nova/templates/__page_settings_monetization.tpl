<!-- page monetization -->
{if $show == 'coupons'}
  <div class="card rounded-3xl border border-base-300 bg-base-100 shadow-none">
    <div class="card-header flex flex-wrap items-center gap-3 border-b border-base-300">
      <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-base-content" aria-hidden="true">
        <span class="icon-[tabler--ticket] size-5"></span>
      </span>
      <div class="min-w-0 grow">
        <h2 class="card-title text-lg">{__("Coupons")}</h2>
      </div>
      <button type="button" data-url="monetization/controller.php?do=add_coupon&node_id={$spage['page_id']}&node_type=page" class="js_modal heroui button button--primary button--sm w-full sm:ms-auto sm:w-auto shrink-0 rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]">
        <span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>
        {__("Generate New Coupon")}
      </button>
    </div>
    <div class="card-body gap-6 pt-6">
      {if $coupons}
        <div class="[&_.js-flyonui-datatable-toolbar]:px-0 [&_.js-flyonui-datatable-footer]:px-0">
          <table class="table table-zebra min-w-[720px] js_dataTable">
            <thead>
              <tr>
                <th>{__("Code")}</th>
                <th>{__("Discount")}</th>
                <th>{__("Created")}</th>
                <th>{__("Usage Details")}</th>
                <th>{__("One Time")}</th>
                <th class="text-end">{__("Actions")}</th>
              </tr>
            </thead>
            <tbody>
              {foreach $coupons as $coupon}
                <tr>
                  <td>
                    <code class="rounded-lg border border-base-300 bg-base-200/60 px-2 py-1 text-sm font-semibold tracking-wider" dir="ltr">{$coupon['coupon_code']}</code>
                  </td>
                  <td>
                    <span class="badge badge-soft rounded-full badge-lg badge-primary">
                      <span class="icon-[tabler--discount] size-4" aria-hidden="true"></span>{$coupon['discount_percent']}%
                    </span>
                  </td>
                  <td class="text-base-content/60">{$coupon['created_date']|date_format:"%e %B %Y"}</td>
                  <td>
                    {if $coupon['usage_counter'] > 0}
                      <button type="button" data-url="monetization/controller.php?do=coupon_users&coupon_id={$coupon['coupon_id']}" class="js_modal heroui button button--tertiary [--button-bg:var(--success-soft)] [--button-bg-hover:var(--success-soft-hover)] [--button-bg-pressed:var(--success-soft-hover)] [--button-fg:var(--success-soft-foreground)] button--sm rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]">
                        <span class="icon-[tabler--users] size-4" aria-hidden="true"></span>
                        {$coupon['usage_counter']} {__("Users")}
                      </button>
                    {else}
                      <span class="inline-flex items-center gap-1.5 text-sm text-base-content/60">
                        <span class="icon-[tabler--user-off] size-4" aria-hidden="true"></span>
                        {__("No One")}
                      </span>
                    {/if}
                  </td>
                  <td>
                    {if $coupon['is_onetime']}
                      <span class="inline-flex size-7 items-center justify-center rounded-full bg-success/10 text-success" title='{__("Yes")}'>
                        <span class="icon-[tabler--check] size-4" aria-hidden="true"></span>
                      </span>
                    {else}
                      <span class="inline-flex size-7 items-center justify-center rounded-full bg-base-200 text-base-content/50" title='{__("No")}'>
                        <span class="icon-[tabler--x] size-4" aria-hidden="true"></span>
                      </span>
                    {/if}
                  </td>
                  <td>
                    <div class="flex items-center justify-end gap-2">
                      <!-- share -->
                      <button type="button" data-url="monetization/controller.php?do=share_coupon&coupon_id={$coupon['coupon_id']}" class="js_modal heroui button button--tertiary text-base-content button--sm button--icon-only size-7.5 rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" aria-label='{__("Share")}' title='{__("Share")}'>
                        <span class="icon-[tabler--link] size-4" aria-hidden="true"></span>
                      </button>
                      <!-- share -->
                      <!-- delete -->
                      <button type="button" class="heroui button button--danger-soft button--sm button--icon-only size-7.5 js_monetization-coupon-deleter rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" data-id="{$coupon['coupon_id']}" aria-label='{__("Delete")}' title='{__("Delete")}'>
                        <span class="icon-[tabler--trash] size-4" aria-hidden="true"></span>
                      </button>
                      <!-- delete -->
                    </div>
                  </td>
                </tr>
              {/foreach}
            </tbody>
          </table>
        </div>
      {else}
        {include file='_no_data.tpl' _empty_icon="icon-[tabler--ticket]"}
      {/if}
    </div>
  </div>
{else}
  <div class="flex flex-col gap-6">
    <!-- monetization balance -->
    <div class="card rounded-3xl border border-base-300 bg-base-100 shadow-none">
      <div class="card-header flex flex-wrap items-center gap-3 border-b border-base-300">
        <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-base-content" aria-hidden="true">
          <span class="icon-[tabler--wallet] size-5"></span>
        </span>
        <div class="min-w-0 grow">
          <h2 class="card-title text-lg">{__("Monetization Balance")}</h2>
        </div>
        {if $system['monetization_money_withdraw_enabled'] || $system['monetization_money_transfer_enabled']}
          <div class="flex w-full gap-2 sm:ms-auto sm:w-auto sm:shrink-0 sm:flex-wrap">
            {if $system['monetization_money_transfer_enabled']}
              <a class="heroui button button--outline button--sm flex-1 sm:flex-none rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" href="{$system['system_url']}/wallet">
                <span class="icon-[tabler--wallet] size-4" aria-hidden="true"></span>
                {__("Wallet")}
              </a>
            {/if}
            {if $system['monetization_money_withdraw_enabled']}
              <a class="heroui button button--primary button--sm flex-1 sm:flex-none rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" href="{$system['system_url']}/settings/monetization/payments">
                <span class="icon-[tabler--cash] size-4" aria-hidden="true"></span>
                {__("Make a withdrawal")}
              </a>
            {/if}
          </div>
        {/if}
      </div>
      <div class="card-body pt-6">
        <div class="grid gap-4 sm:grid-cols-2">
          <div class="flex items-center gap-4 rounded-xl border border-base-300 bg-base-200/40 p-4 sm:p-5">
            <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-100 text-success" aria-hidden="true">
              <span class="icon-[tabler--coin] size-5"></span>
            </span>
            <div class="min-w-0">
              <div class="text-sm text-base-content/60">{__("Monetization Money Balance")}</div>
              <div class="truncate text-xl font-semibold" title="{print_money($user->_data['user_monetization_balance'])}">{print_money($user->_data['user_monetization_balance'])}</div>
            </div>
          </div>
          <div class="flex items-center gap-4 rounded-xl border border-base-300 bg-base-200/40 p-4 sm:p-5">
            <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-100 text-primary" aria-hidden="true">
              <span class="icon-[tabler--users] size-5"></span>
            </span>
            <div class="min-w-0">
              <div class="text-sm text-base-content/60">{__("Page Subscribers")}</div>
              <div class="truncate text-xl font-semibold" title="{$subscribers_count}">{$subscribers_count}</div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <!-- monetization balance -->

    <div class="card rounded-3xl border border-base-300 bg-base-100 shadow-none">
      <form class="js_ajax-forms" data-url="modules/create.php?type=page&do=edit&edit=monetization&id={$spage['page_id']}">
        {include file='__settings_card_header.tpl' _icon="icon-[tabler--coin]" _title=__("Monetization Settings")}
        <div class="card-body gap-6 pt-6">
          <div class="alert alert-info flex items-start gap-3 leading-5" role="alert">
            <span class="icon-[tabler--info-circle] size-5 shrink-0" aria-hidden="true"></span>
            <div class="min-w-0">
              <div class="font-medium">{__("Monetization")}</div>
              <ul class="mt-1 flex list-disc flex-col gap-1 ps-4 text-sm">
                <li>{__("Now you can earn money from your content. Via paid posts or subscriptions plans.")}</li>
                {if $system['monetization_commission'] > 0}
                  <li>{__("There is commission")} <strong>{$system['monetization_commission']}%</strong> {__("will be deducted")}.</li>
                {/if}
                <li>{__("Only super admin can manage monetization and money goes to his monetization money balance")}.</li>
              </ul>
            </div>
          </div>

          <!-- general -->
          <div class="flex flex-col divide-y divide-base-300 rounded-xl border border-base-300">
            <div class="flex items-center gap-4 p-4">
              <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200" aria-hidden="true">
                {include file='__svg_icons.tpl' icon="monetization" class="main-icon" width="24px" height="24px"}
              </span>
              <div class="min-w-0 grow">
                <div class="text-sm font-medium" id="page_monetization_enabled-label">{__("Monetization")}</div>
                <p class="mt-0.5 hidden text-sm text-base-content/60 sm:block">{__("Enable or disable monetization for your content")}</p>
              </div>
              <input class="switch switch-primary shrink-0 [--radius-selector:9999px]" aria-labelledby="page_monetization_enabled-label" type="checkbox" name="page_monetization_enabled" id="page_monetization_enabled" {if $spage['page_monetization_enabled']}checked{/if}>
            </div>
            <div class="flex flex-col gap-4 p-4">
              <div class="flex items-center gap-4">
                <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200" aria-hidden="true">
                  {include file='__svg_icons.tpl' icon="offers" class="main-icon" width="24px" height="24px"}
                </span>
                <div class="min-w-0 grow">
                  <div class="text-sm font-medium" id="page_monetization_discount_enabled-label">{__("Global Discount")}</div>
                  <p class="mt-0.5 hidden text-sm text-base-content/60 sm:block">{__("Enable or disable global discount for subscriptions plans and paid posts")}</p>
                </div>
                <input class="switch switch-primary shrink-0 [--radius-selector:9999px]" aria-labelledby="page_monetization_discount_enabled-label" type="checkbox" name="page_monetization_discount_enabled" id="page_monetization_discount_enabled" {if $spage['page_monetization_discount_enabled']}checked{/if}>
              </div>
              <div class="w-full sm:ps-14">
                <label class="label-text mb-1.5 block" for="page_monetization_discount_percent">{__("Discount Percent")}</label>
                <div class="input w-full items-center gap-2 sm:max-w-48">
                  <input type="number" min="1" max="99" class="grow" id="page_monetization_discount_percent" name="page_monetization_discount_percent" value="{$spage['page_monetization_discount_percent']}">
                  <span class="text-base-content/60" aria-hidden="true">%</span>
                </div>
                <p class="helper-text">{__("The discount percent to apply to all monetized content (min 1, max 99)")}</p>
              </div>
            </div>
          </div>
          <!-- general -->

          <!-- subscriptions -->
          <section class="flex flex-col gap-4 border-t border-base-300 pt-6">
            <h3 class="flex items-center gap-2 text-sm font-semibold">
              <span class="icon-[tabler--crown] size-5 text-base-content/60" aria-hidden="true"></span>
              {__("Subscriptions Plans")}
            </h3>
            {include file='__monetization_plans.tpl' _node_id=$spage['page_id'] _node_type='page'}
          </section>
          <!-- subscriptions -->

          <!-- success -->
          <div class="alert alert-success hidden items-center" role="status"></div>
          <!-- success -->

          <!-- error -->
          <div class="alert alert-error alert-danger hidden items-center" role="alert"></div>
          <!-- error -->
        </div>
        <div class="card-footer flex justify-end gap-3 border-t border-base-300 pt-6">
          <button type="submit" class="heroui button button--primary w-full sm:w-auto rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]">{__("Save Changes")}</button>
        </div>
      </form>
    </div>
  </div>
{/if}
<!-- page monetization -->
