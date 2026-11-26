{assign var="payload" value=$licence_info['payload']}
{assign var="ui" value=$licence_info['ui']}
{assign var="kind" value=$licence_info['kind']}
{assign var="timeline" value=$licence_info['timeline']}

<section class="admin-settings-page admin-list-page admin-license admin-license-{$ui} flex min-w-0 flex-col gap-6" aria-labelledby="admin-license-title">
  <div class="admin-form-layout mx-auto flex w-full max-w-[64rem] flex-col gap-6">
    <header class="admin-list-heading flex items-start justify-between gap-4">
      <div class="admin-settings-heading grid gap-1.5">
        <h1 id="admin-license-title" class="text-2xl font-semibold">{__("License")}</h1>
        <p class="text-base-content/60 text-sm">{__("Verify your purchase, support window, and monetization access.")}</p>
      </div>
      <div class="admin-list-heading-actions flex shrink-0 flex-wrap items-center justify-end gap-2">
        <a href="{$system['system_url']}/{$control_panel['url']}/license" class="btn btn-outline">
          <span class="icon-[tabler--refresh] size-4" aria-hidden="true"></span>
          {__("Re-check")}
        </a>
        <button type="button" class="btn btn-primary js_modal" data-url="#admin-license-change" data-size="large">
          <span class="icon-[tabler--key] size-4" aria-hidden="true"></span>
          {if $licence_info['key_masked']}{__("Change Key")}{else}{__("Add Key")}{/if}
        </button>
      </div>
    </header>

    <section class="card admin-license-card min-w-0 overflow-hidden border border-base-300 bg-base-100 shadow-none">
      <div class="admin-license-inner flex flex-col gap-6 p-6">
        <!-- identity -->
        <div class="admin-license-identity flex items-start justify-between gap-4 max-md:flex-col">
          <div class="admin-license-identity-copy min-w-0">
            <h2 class="admin-license-title m-0 text-xl font-semibold leading-snug">
              {if $ui == "lapsed"}
                {__("Subscription lapsed")}
              {elseif $ui == "missing"}
                {__("No License Found")}
              {elseif $ui == "invalid"}
                {__("License Invalid")}
              {elseif $ui == "unreachable" && !$payload['domain']}
                {__("License Server Unreachable")}
              {elseif $payload['domain']}
                {__("Licensed to")} <span class="admin-license-mono">{$payload['domain']}</span>
              {else}
                {__("License")}
              {/if}
            </h2>
            <p class="admin-license-lead m-0 mt-2 max-w-xl text-sm leading-relaxed text-base-content/60">
              {if $ui == "unreachable"}
                {if $licence_info['api_warning']}{$licence_info['api_warning']}{else}{__("License server unreachable; showing last verified payload.")}{/if}
              {elseif $ui == "missing" || $ui == "invalid"}
                {if $licence_info['message']}{$licence_info['message']}{else}{__("License verification failed.")}{/if}
                {if $licence_info['api_warning']}<br>{$licence_info['api_warning']}{/if}
              {elseif $ui == "lapsed"}
                {__("Payment for")} {if $payload['domain']}<span class="admin-license-mono">{$payload['domain']}</span>{else}{__("this site")}{/if} {__("stopped on")} {if $payload['support_expires_at']}{$payload['support_expires_at']|date_format:"%e %B %Y"}{else}&mdash;{/if}. {__("Monetization and updates are switched off until you renew.")}
              {elseif $ui == "support_ended"}
                {if $kind == "extended"}{__("Extended license, perpetual.")}{else}{__("Regular license, perpetual.")}{/if} {__("Your site keeps running on the version you have — only new releases and support have stopped.")}
              {elseif $kind == "subscription"}
                {if $licence_info['billing'] == "year"}
                  {__("Subscription, billed yearly. Payments and monetization are part of this plan.")}
                {else}
                  {__("Subscription, billed monthly. Payments and monetization are part of this plan.")}
                {/if}
              {elseif $kind == "extended"}
                {__("Extended license, bought once and yours to keep. Support and updates run for 12 months and can be renewed.")}
              {else}
                {__("Regular license, bought once and yours to keep. Support and updates run for 12 months and can be renewed.")}
              {/if}
            </p>
          </div>
          <span class="admin-license-badge badge badge-soft badge-sm rounded-full shrink-0">
            <span class="admin-license-badge-dot" aria-hidden="true"></span>
            {if $ui == "active"}{__("Active")}
            {elseif $ui == "support_ended"}{__("Support ended")}
            {elseif $ui == "lapsed"}{__("Lapsed")}
            {elseif $ui == "cancelled"}{__("Cancelled")}
            {elseif $ui == "unreachable"}{__("Unreachable")}
            {elseif $ui == "missing"}{__("Missing")}
            {else}{__("Invalid")}{/if}
          </span>
        </div>
        <!-- identity -->

        {if $licence_info['key_masked']}
          <div class="admin-license-keyrow inline-flex max-w-full items-center gap-3 overflow-hidden rounded-lg border border-base-300 bg-base-200 px-4 py-3">
            <span class="admin-license-key-label shrink-0 text-[11px] font-semibold tracking-[0.12em] uppercase text-base-content/50">{__("Key")}</span>
            <span class="admin-license-key font-mono text-sm [overflow-wrap:anywhere]">{$licence_info['key_masked']}</span>
          </div>
        {/if}

        {if $timeline['mode'] != "none"}
          <!-- period -->
          <div class="admin-license-period">
            <div class="admin-license-period-head mb-4 flex items-baseline justify-between gap-3 text-[11px] font-semibold uppercase tracking-[0.1em] text-base-content/50">
              <span>
                {if $timeline['mode'] == "perpetual"}
                  {__("Support & Updates")}
                {else}
                  {__("License Period")}
                {/if}
              </span>
              <span class="normal-case tracking-normal">
                {if $ui == "support_ended"}
                  {__("Ended")} &middot; {__("license unaffected")}
                {elseif $ui == "lapsed"}
                  {__("Term ended")}
                {elseif $timeline['mode'] == "perpetual"}
                  {__("12 months")} &middot; {__("renewable")}
                {elseif $licence_info['support_timeleft'] !== null && $licence_info['support_timeleft'] > 0}
                  {$licence_info['support_timeleft']} {__("days remaining")}
                {else}
                  {__("Term ended")}
                {/if}
              </span>
            </div>

            <div class="admin-license-timeline admin-license-timeline-{$timeline['mode']}">
              <div class="admin-license-track">
                <div class="admin-license-track-elapsed" style="width: {$timeline['today_pct']}%;"></div>
                {if $timeline['mode'] == "term"}
                  <span class="admin-license-tick" aria-hidden="true"></span>
                {/if}
                <div class="admin-license-today{if $timeline['today_at_end']} admin-license-today-end{/if}" style="inset-inline-start: {$timeline['today_pct']}%;">
                  <span>{__("Today")}</span>
                </div>
              </div>
              {if $timeline['mode'] == "perpetual"}
                <div class="admin-license-forever">
                  <div class="admin-license-forever-line" aria-hidden="true"></div>
                  <div class="admin-license-forever-end">
                    <span class="admin-license-inf" aria-hidden="true">&infin;</span>
                    <span class="admin-license-forever-label">{__("License")} &middot; {__("Perpetual")}</span>
                  </div>
                </div>
              {/if}
            </div>

            <div class="admin-license-facts grid grid-cols-1 gap-4 sm:grid-cols-3">
              <div>
                <div class="admin-license-fact-label">
                  <span class="icon-[tabler--circle] size-3.5" aria-hidden="true"></span>
                  {__("Issued")}
                </div>
                <div class="admin-license-fact-value">{if $payload['issued_at']}{$payload['issued_at']|date_format:"%e %b %Y"}{else}&mdash;{/if}</div>
                <div class="admin-license-fact-sub">
                  {if $kind == "subscription"}
                    {if $payload['source'] == "freemius" || $payload['source'] == "zamblek"}Zamblek{elseif $payload['source']}{$payload['source']|ucfirst}{else}&mdash;{/if}
                  {else}
                    {__("one-time purchase")}
                  {/if}
                </div>
              </div>
              <div>
                <div class="admin-license-fact-label">
                  <span class="icon-[tabler--diamond] size-3.5" aria-hidden="true"></span>
                  {__("Next Verification")}
                </div>
                {if $ui == "lapsed"}
                  <div class="admin-license-fact-value">{__("Paused")}</div>
                  <div class="admin-license-fact-sub">{__("resumes on renewal")}</div>
                {else}
                  <div class="admin-license-fact-value">{if $payload['expires_at']}{$payload['expires_at']|date_format:"%e %b %Y"}{else}&mdash;{/if}</div>
                  <div class="admin-license-fact-sub">{if $licence_info['rel_verify']}{$licence_info['rel_verify']} &middot; {__("automatic")}{else}&nbsp;{/if}</div>
                {/if}
              </div>
              <div>
                {if $ui == "lapsed"}
                  <div class="admin-license-fact-label">
                    <span class="icon-[tabler--separator-vertical] size-3.5" aria-hidden="true"></span>
                    {__("Lapsed On")}
                  </div>
                  <div class="admin-license-fact-value is-alert">{if $payload['support_expires_at']}{$payload['support_expires_at']|date_format:"%e %b %Y"}{else}&mdash;{/if}</div>
                  <div class="admin-license-fact-sub">{if $licence_info['rel_support']}{$licence_info['rel_support']}{else}&nbsp;{/if}</div>
                {elseif $ui == "support_ended"}
                  <div class="admin-license-fact-label">
                    <span class="icon-[tabler--separator-vertical] size-3.5" aria-hidden="true"></span>
                    {__("Support Ended")}
                  </div>
                  <div class="admin-license-fact-value is-alert">{if $payload['support_expires_at']}{$payload['support_expires_at']|date_format:"%e %b %Y"}{else}&mdash;{/if}</div>
                  <div class="admin-license-fact-sub">{if $licence_info['rel_support']}{$licence_info['rel_support']}{else}&nbsp;{/if}</div>
                {elseif $kind == "subscription"}
                  <div class="admin-license-fact-label">
                    <span class="icon-[tabler--separator-vertical] size-3.5" aria-hidden="true"></span>
                    {__("Renews On")}
                  </div>
                  <div class="admin-license-fact-value">{if $payload['support_expires_at']}{$payload['support_expires_at']|date_format:"%e %b %Y"}{else}&mdash;{/if}</div>
                  <div class="admin-license-fact-sub">{if $licence_info['rel_support']}{$licence_info['rel_support']}{else}&nbsp;{/if}</div>
                {else}
                  <div class="admin-license-fact-label">
                    <span class="icon-[tabler--separator-vertical] size-3.5" aria-hidden="true"></span>
                    {__("Support Ends")}
                  </div>
                  <div class="admin-license-fact-value">{if $payload['support_expires_at']}{$payload['support_expires_at']|date_format:"%e %b %Y"}{else}&mdash;{/if}</div>
                  <div class="admin-license-fact-sub">{if $licence_info['rel_support']}{$licence_info['rel_support']}{else}&nbsp;{/if}</div>
                {/if}
              </div>
            </div>
          </div>
          <!-- period -->
        {/if}
      </div>

      {if $ui != "missing" && $ui != "invalid"}
        <!-- actions -->
        <div class="admin-license-actions border-t border-base-300 bg-base-200/60">
          {if $ui == "support_ended"}
            <div class="admin-license-action flex items-center justify-between gap-4 px-6 py-5 max-md:flex-col max-md:items-stretch">
              <div class="admin-license-action-main flex min-w-0 flex-1 items-center gap-4">
                <div class="admin-license-action-icon flex size-10 shrink-0 items-center justify-center rounded-[10px] border border-base-300 bg-base-100">
                  <span class="icon-[tabler--headset] size-5" aria-hidden="true"></span>
                </div>
                <div class="min-w-0">
                  <div class="admin-license-action-title text-sm font-semibold">{__("Support & updates")}</div>
                  <div class="admin-license-action-text mt-1 text-sm leading-relaxed text-base-content/60">{__("Your license stays active. Extend support for another 12 months to download new releases and open support tickets again.")}</div>
                </div>
              </div>
              <a class="btn btn-outline shrink-0" href="https://zamblek.com/purchases" target="_blank" rel="noopener">{__("Extend support from $19.99")}</a>
            </div>
          {/if}

          {if $ui == "lapsed"}
            <div class="admin-license-action flex items-center justify-between gap-4 px-6 py-5 max-md:flex-col max-md:items-stretch">
              <div class="min-w-0">
                <div class="admin-license-action-title text-sm font-semibold">{__("Subscription")}</div>
                <div class="admin-license-action-text mt-1 text-sm leading-relaxed text-base-content/60">{__("Renew to restore updates, support and monetization. Your balances, payouts and history are kept.")}</div>
              </div>
              <a class="btn btn-primary shrink-0" href="https://zamblek.com/purchases" target="_blank" rel="noopener">{__("Renew subscription")}</a>
            </div>
          {/if}

          {if $ui == "cancelled"}
            <div class="admin-license-action flex items-center justify-between gap-4 px-6 py-5 max-md:flex-col max-md:items-stretch">
              <div class="min-w-0">
                <div class="admin-license-action-title text-sm font-semibold">{__("Subscription cancelled")}</div>
                <div class="admin-license-action-text mt-1 text-sm leading-relaxed text-base-content/60">{__("Updates and payments & monetization stopped when the monthly subscription was cancelled. Support continues until the paid period ends.")}</div>
              </div>
              <a class="btn btn-primary shrink-0" href="https://zamblek.com/purchases" target="_blank" rel="noopener">{__("Reactivate subscription")}</a>
            </div>
          {/if}

          <div class="admin-license-action flex items-center justify-between gap-4 px-6 py-5 max-md:flex-col max-md:items-stretch">
            <div class="admin-license-action-main flex min-w-0 flex-1 items-center gap-4">
              <div class="admin-license-action-icon flex size-10 shrink-0 items-center justify-center rounded-[10px] border border-base-300 bg-base-100">
                <span class="icon-[tabler--credit-card] size-5" aria-hidden="true"></span>
              </div>
              <div class="min-w-0">
                <div class="admin-license-action-title text-sm font-semibold">{__("Payments & monetization")}</div>
                <div class="admin-license-action-text mt-1 text-sm leading-relaxed text-base-content/60">
                  {if $ui == "unreachable"}
                    {__("License server unreachable. Re-check to refresh payments and monetization.")}
                  {elseif $ui == "lapsed" || $ui == "cancelled"}
                    {__("Switched off and the module files removed. Balances and payout history are kept and return when you renew.")}
                  {elseif $kind == "regular"}
                    {__("Not part of the Regular license. Upgrade to Extended to sell subscriptions, run ads and take payouts.")}
                  {elseif $licence_info['monetization'] && $licence_info['module_installed']}
                    {__("Enabled for")} {if $payload['domain']}<span class="admin-license-mono">{$payload['domain']}</span>{else}{__("this site")}{/if}
                    {if $payload['issued_at']} {__("since")} {$payload['issued_at']|date_format:"%e %B %Y"}{/if}.
                    {if $ui == "support_ended"} {__("Unaffected by the support window.")}{/if}
                  {elseif $licence_info['monetization'] && $licence_info['module_present']}
                    {__("Some payments and monetization files are missing or out of date. Install them again to turn the features back on.")}
                  {else}
                    {__("Included in this license. Verify the domain to turn on paid subscriptions, ads and payouts.")}
                  {/if}
                </div>
              </div>
            </div>
            {if $ui == "unreachable"}
              <a class="btn btn-primary shrink-0" href="{$system['system_url']}/{$control_panel['url']}/license">{__("Re-check")}</a>
            {elseif $ui == "lapsed" || $ui == "cancelled"}
              <a class="btn btn-outline shrink-0" href="https://zamblek.com/purchases" target="_blank" rel="noopener">{__("Renew to restore")}</a>
            {elseif $kind == "regular"}
              <a class="btn btn-primary shrink-0" href="https://zamblek.com/pricing" target="_blank" rel="noopener">{__("Upgrade for $19.99")}</a>
            {elseif $licence_info['monetization'] && $licence_info['module_installed']}
              <span class="admin-license-enabled inline-flex shrink-0 items-center gap-1.5 text-sm font-semibold text-success">
                <span class="icon-[tabler--circle-check] size-4" aria-hidden="true"></span>
                {__("Enabled")}
              </span>
            {elseif $licence_info['monetization'] && $licence_info['module_present']}
              <a class="btn btn-primary js_admin-license-enable shrink-0" href="#">{__("Install files")}</a>
            {else}
              <a class="btn btn-primary js_admin-license-enable shrink-0" href="#">{__("Verify and enable")}</a>
            {/if}
          </div>
        </div>
        <!-- actions -->
      {/if}

      {if $payload['license_type'] || $payload['source'] || $payload['domain']}
        <!-- footer -->
        <div class="admin-license-foot grid grid-cols-1 border-t border-base-300 sm:grid-cols-3">
          <div class="px-6 py-5">
            <div class="admin-license-foot-label mb-1.5 text-[11px] font-semibold tracking-[0.1em] uppercase text-base-content/50">{__("License")}</div>
            <div class="admin-license-foot-value text-sm font-semibold">
              {if $kind == "subscription"}
                {__("Subscription")}{if $licence_info['billing'] == "year"} &middot; {__("yearly")}{elseif $licence_info['billing'] == "month"} &middot; {__("monthly")}{/if}
              {elseif $kind == "extended"}
                {__("Extended")} &middot; {__("one-time")}
              {else}
                {__("Regular")} &middot; {__("one-time")}
              {/if}
            </div>
          </div>
          <div class="px-6 py-5 sm:border-s sm:border-base-300">
            <div class="admin-license-foot-label mb-1.5 text-[11px] font-semibold tracking-[0.1em] uppercase text-base-content/50">{__("Source")}</div>
            <div class="admin-license-foot-value text-sm font-semibold">
              {if $payload['source'] == "freemius" || $payload['source'] == "zamblek"}
                <a class="link link-animated" href="https://zamblek.com/purchases" target="_blank" rel="noopener">Zamblek</a>
              {elseif $payload['source']}
                {$payload['source']|ucfirst}
              {else}
                &mdash;
              {/if}
            </div>
          </div>
          <div class="px-6 py-5 sm:border-s sm:border-base-300">
            <div class="admin-license-foot-label mb-1.5 text-[11px] font-semibold tracking-[0.1em] uppercase text-base-content/50">{__("Domain")}</div>
            <div class="admin-license-foot-value text-sm font-semibold">{if $payload['domain']}<span class="admin-license-mono">{$payload['domain']}</span>{else}&mdash;{/if}</div>
          </div>
        </div>
        <!-- footer -->
      {/if}
    </section>
  </div>
</section>
