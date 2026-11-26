<section class="admin-dashboard flex flex-col gap-4 sm:gap-6" aria-labelledby="admin-dashboard-title">
  <header class="admin-dashboard-heading grid gap-1.5">
    <h1 id="admin-dashboard-title" class="text-2xl font-semibold tracking-tight">
      {__("Welcome back")}, {if $user->_data['user_firstname']}{$user->_data['user_firstname']}{else}{$user->_data['user_name']}{/if}
    </h1>
    <p class="text-base-content/60 text-sm">
      {if $user->_is_admin}
        <a class="link link-animated" href="{$system['system_url']}/{$control_panel['url']}/users/online">{$insights['online']|number_format} {__("Online")}</a>
        {if $system['users_approval_enabled'] && $insights['pending'] > 0}
          — {$insights['pending']|number_format} {__("Pending")}
        {/if}
      {else}
        {$insights['posts']|number_format} {__("Posts")}
      {/if}
    </p>
  </header>

  <div class="admin-dashboard-kpis grid grid-cols-1 gap-3 sm:grid-cols-2 sm:gap-4 {if !$user->_is_admin || $system['users_approval_enabled']}lg:grid-cols-3{/if} lg:gap-6">
    {if $user->_is_admin}
      <article class="card admin-dashboard-kpi flex min-w-0 flex-col gap-3 border border-base-300 bg-base-100 p-4 shadow-none sm:p-5 lg:p-6">
        <div class="admin-dashboard-kpi-head flex min-w-0 items-center gap-2">
          <span class="icon-[tabler--users] admin-dashboard-kpi-icon size-4 shrink-0" aria-hidden="true"></span>
          <span class="admin-dashboard-kpi-label min-w-0 truncate text-[13px] font-medium" title="{__("Users")}">{__("Users")}</span>
        </div>
        {if $insights['users_last_month'] > 0}
          <p class="admin-dashboard-kpi-prev m-0 hidden text-xs leading-snug tabular-nums sm:block">{$insights['users_last_month']|number_format} {__("previous month")}</p>
        {else}
          <p class="admin-dashboard-kpi-prev m-0 hidden text-xs leading-snug tabular-nums sm:block">{$insights['users_month']|number_format} {__("this month")}</p>
        {/if}
        <p class="admin-dashboard-kpi-value m-0 text-[1.75rem] font-semibold leading-tight tracking-tight tabular-nums sm:text-[2rem]">{$insights['users']|number_format}</p>
        <div class="admin-dashboard-kpi-footer mt-auto flex min-h-5 items-center justify-between gap-2.5">
          {if $insights['users_last_month'] > 0}
            <span class="admin-dashboard-kpi-delta inline-flex min-w-0 items-center gap-1 text-xs {if $insights['users_month_pct'] >= 0}is-up{else}is-down{/if}">
              {if $insights['users_month_pct'] >= 0}<span class="icon-[tabler--arrow-up-right] size-3.5 shrink-0" aria-hidden="true"></span>{else}<span class="icon-[tabler--arrow-down-right] size-3.5 shrink-0" aria-hidden="true"></span>{/if}
              <span class="admin-dashboard-kpi-pct font-medium tabular-nums">{if $insights['users_month_pct'] >= 0}+{/if}{$insights['users_month_pct']}%</span>
              <span class="admin-dashboard-kpi-note min-w-0 truncate" title="{__("vs last month")}">{__("vs last month")}</span>
            </span>
          {else}
            <span class="admin-dashboard-kpi-note min-w-0 truncate" title="{$insights['users_month']|number_format} {__("this month")}">{$insights['users_month']|number_format} {__("this month")}</span>
          {/if}
          <a class="link link-animated admin-dashboard-action shrink-0 text-xs leading-snug" href="{$system['system_url']}/{$control_panel['url']}/users">{__("Manage Users")}</a>
        </div>
      </article>

      <article class="card admin-dashboard-kpi flex min-w-0 flex-col gap-3 border border-base-300 bg-base-100 p-4 shadow-none sm:p-5 lg:p-6">
        <div class="admin-dashboard-kpi-head flex min-w-0 items-center gap-2">
          <span class="icon-[tabler--news] admin-dashboard-kpi-icon size-4 shrink-0" aria-hidden="true"></span>
          <span class="admin-dashboard-kpi-label min-w-0 truncate text-[13px] font-medium" title="{__("Posts")}">{__("Posts")}</span>
        </div>
        {if $insights['posts_last_month'] > 0}
          <p class="admin-dashboard-kpi-prev m-0 hidden text-xs leading-snug tabular-nums sm:block">{$insights['posts_last_month']|number_format} {__("previous month")}</p>
        {else}
          <p class="admin-dashboard-kpi-prev m-0 hidden text-xs leading-snug tabular-nums sm:block">{$insights['posts_month']|number_format} {__("this month")}</p>
        {/if}
        <p class="admin-dashboard-kpi-value m-0 text-[1.75rem] font-semibold leading-tight tracking-tight tabular-nums sm:text-[2rem]">{$insights['posts']|number_format}</p>
        <div class="admin-dashboard-kpi-footer mt-auto flex min-h-5 items-center justify-between gap-2.5">
          {if $insights['posts_last_month'] > 0}
            <span class="admin-dashboard-kpi-delta inline-flex min-w-0 items-center gap-1 text-xs {if $insights['posts_month_pct'] >= 0}is-up{else}is-down{/if}">
              {if $insights['posts_month_pct'] >= 0}<span class="icon-[tabler--arrow-up-right] size-3.5 shrink-0" aria-hidden="true"></span>{else}<span class="icon-[tabler--arrow-down-right] size-3.5 shrink-0" aria-hidden="true"></span>{/if}
              <span class="admin-dashboard-kpi-pct font-medium tabular-nums">{if $insights['posts_month_pct'] >= 0}+{/if}{$insights['posts_month_pct']}%</span>
              <span class="admin-dashboard-kpi-note min-w-0 truncate" title="{__("vs last month")}">{__("vs last month")}</span>
            </span>
          {else}
            <span class="admin-dashboard-kpi-note min-w-0 truncate" title="{$insights['posts_month']|number_format} {__("this month")}">{$insights['posts_month']|number_format} {__("this month")}</span>
          {/if}
          <a class="link link-animated admin-dashboard-action shrink-0 text-xs leading-snug" href="{$system['system_url']}/{$control_panel['url']}/posts">{__("Manage Posts")}</a>
        </div>
      </article>

      {if $system['users_approval_enabled']}
      <article class="card admin-dashboard-kpi flex min-w-0 flex-col gap-3 border border-base-300 bg-base-100 p-4 shadow-none sm:p-5 lg:p-6">
        <div class="admin-dashboard-kpi-head flex min-w-0 items-center gap-2">
          <span class="icon-[tabler--user-check] admin-dashboard-kpi-icon size-4 shrink-0" aria-hidden="true"></span>
          <span class="admin-dashboard-kpi-label min-w-0 truncate text-[13px] font-medium" title="{__("Pending")}">{__("Pending")}</span>
        </div>
        <p class="admin-dashboard-kpi-prev m-0 hidden text-xs leading-snug tabular-nums sm:block">{$insights['not_activated']|number_format} {__("Not Activated")}</p>
        <p class="admin-dashboard-kpi-value m-0 text-[1.75rem] font-semibold leading-tight tracking-tight tabular-nums sm:text-[2rem]">{$insights['pending']|number_format}</p>
        <div class="admin-dashboard-kpi-footer mt-auto flex min-h-5 items-center justify-between gap-2.5">
          <span class="admin-dashboard-kpi-note min-w-0 truncate" title="{$insights['online']|number_format} {__("Online")}">{$insights['online']|number_format} {__("Online")}</span>
          <a class="link link-animated admin-dashboard-action shrink-0 text-xs leading-snug" href="{$system['system_url']}/{$control_panel['url']}/users/pending">{__("Manage Pending")}</a>
        </div>
      </article>
      {/if}
    {else}
      <article class="card admin-dashboard-kpi flex min-w-0 flex-col gap-3 border border-base-300 bg-base-100 p-4 shadow-none sm:p-5 lg:p-6">
        <div class="admin-dashboard-kpi-head flex min-w-0 items-center gap-2">
          <span class="icon-[tabler--news] admin-dashboard-kpi-icon size-4 shrink-0" aria-hidden="true"></span>
          <span class="admin-dashboard-kpi-label min-w-0 truncate text-[13px] font-medium" title="{__("Posts")}">{__("Posts")}</span>
        </div>
        <p class="admin-dashboard-kpi-prev m-0 hidden text-xs leading-snug tabular-nums sm:block">{$insights['posts_month']|number_format} {__("this month")}</p>
        <p class="admin-dashboard-kpi-value m-0 text-[1.75rem] font-semibold leading-tight tracking-tight tabular-nums sm:text-[2rem]">{$insights['posts']|number_format}</p>
        <div class="admin-dashboard-kpi-footer mt-auto flex min-h-5 items-center justify-between gap-2.5">
          <span class="admin-dashboard-kpi-note min-w-0 truncate" title="{$insights['comments']|number_format} {__("Comments")}">{$insights['comments']|number_format} {__("Comments")}</span>
          <a class="link link-animated admin-dashboard-action shrink-0 text-xs leading-snug" href="{$system['system_url']}/{$control_panel['url']}/posts">{__("Manage Posts")}</a>
        </div>
      </article>

      <article class="card admin-dashboard-kpi flex min-w-0 flex-col gap-3 border border-base-300 bg-base-100 p-4 shadow-none sm:p-5 lg:p-6">
        <div class="admin-dashboard-kpi-head flex min-w-0 items-center gap-2">
          <span class="icon-[tabler--file-text] admin-dashboard-kpi-icon size-4 shrink-0" aria-hidden="true"></span>
          <span class="admin-dashboard-kpi-label min-w-0 truncate text-[13px] font-medium" title="{__("Pages")}">{__("Pages")}</span>
        </div>
        <p class="admin-dashboard-kpi-prev m-0 hidden text-xs leading-snug tabular-nums sm:block">{$insights['groups']|number_format} {__("Groups")}</p>
        <p class="admin-dashboard-kpi-value m-0 text-[1.75rem] font-semibold leading-tight tracking-tight tabular-nums sm:text-[2rem]">{$insights['pages']|number_format}</p>
        <div class="admin-dashboard-kpi-footer mt-auto flex min-h-5 items-center justify-between gap-2.5">
          <span class="admin-dashboard-kpi-note min-w-0 truncate" title="{$insights['events']|number_format} {__("Events")}">{$insights['events']|number_format} {__("Events")}</span>
          <a class="link link-animated admin-dashboard-action shrink-0 text-xs leading-snug" href="{$system['system_url']}/{$control_panel['url']}/pages">{__("Manage Pages")}</a>
        </div>
      </article>

      <article class="card admin-dashboard-kpi flex min-w-0 flex-col gap-3 border border-base-300 bg-base-100 p-4 shadow-none sm:p-5 lg:p-6">
        <div class="admin-dashboard-kpi-head flex min-w-0 items-center gap-2">
          <span class="icon-[tabler--users-group] admin-dashboard-kpi-icon size-4 shrink-0" aria-hidden="true"></span>
          <span class="admin-dashboard-kpi-label min-w-0 truncate text-[13px] font-medium" title="{__("Groups")}">{__("Groups")}</span>
        </div>
        <p class="admin-dashboard-kpi-prev m-0 hidden text-xs leading-snug tabular-nums sm:block">{$insights['events']|number_format} {__("Events")}</p>
        <p class="admin-dashboard-kpi-value m-0 text-[1.75rem] font-semibold leading-tight tracking-tight tabular-nums sm:text-[2rem]">{$insights['groups']|number_format}</p>
        <div class="admin-dashboard-kpi-footer mt-auto flex min-h-5 items-center justify-between gap-2.5">
          <span class="admin-dashboard-kpi-note min-w-0 truncate" title="{$insights['pages']|number_format} {__("Pages")}">{$insights['pages']|number_format} {__("Pages")}</span>
          <a class="link link-animated admin-dashboard-action shrink-0 text-xs leading-snug" href="{$system['system_url']}/{$control_panel['url']}/groups">{__("Manage Groups")}</a>
        </div>
      </article>
    {/if}
  </div>

  {if $user->_is_admin}
    <div class="admin-dashboard-overview grid grid-cols-1 gap-4 xl:grid-cols-[minmax(0,1fr)_410px] xl:gap-6">
      <article class="card admin-dashboard-panel min-w-0 border border-base-300 bg-base-100 p-4 shadow-none sm:p-6 admin-dashboard-growth-panel">
        <header class="admin-dashboard-panel-head mb-5 flex items-center gap-2.5">
          <div class="admin-dashboard-panel-heading min-w-0">
            <h2 class="admin-dashboard-panel-title m-0 text-base font-semibold tracking-tight">{__("Users")} &amp; {__("Posts")}</h2>
            <p class="admin-dashboard-panel-hint mt-1 mb-0 text-[13px]">{__("Monthly Average")}</p>
          </div>
          <div class="admin-dashboard-chart-legend" aria-hidden="true">
            <span><i class="is-users"></i>{__("Users")}</span>
            <span><i class="is-posts"></i>{__("Posts")}</span>
          </div>
        </header>
        <div id="admin-chart-growth" class="admin-dashboard-chart min-h-[280px] w-full" aria-hidden="true"></div>
      </article>

      <article class="card admin-dashboard-panel min-w-0 border border-base-300 bg-base-100 p-4 shadow-none sm:p-6 admin-dashboard-breakdown">
        <header class="admin-dashboard-panel-head mb-5 flex items-center gap-2.5">
          <span class="admin-dashboard-panel-icon inline-flex size-8 shrink-0 items-center justify-center rounded-field border border-base-300">
            <span class="icon-[tabler--chart-bar] size-4" aria-hidden="true"></span>
          </span>
          <div class="admin-dashboard-panel-heading min-w-0">
            <h2 class="admin-dashboard-panel-title m-0 text-base font-semibold tracking-tight">{__("Pages")}, {__("Groups")} &amp; {__("Events")}</h2>
          </div>
        </header>

        <div class="admin-dashboard-breakdown-total">
          <strong>{$insights['community_total']|number_format}</strong>
          <span>{__("Total")}</span>
        </div>

        <div class="admin-dashboard-segments" aria-hidden="true">
          {if $insights['community_total'] > 0}
            {if $insights['pages'] > 0}<span class="is-pages" style="flex-grow: {$insights['pages']}"></span>{/if}
            {if $insights['groups'] > 0}<span class="is-groups" style="flex-grow: {$insights['groups']}"></span>{/if}
            {if $insights['events'] > 0}<span class="is-events" style="flex-grow: {$insights['events']}"></span>{/if}
          {else}
            <span class="is-empty"></span>
          {/if}
        </div>

        <div class="admin-dashboard-breakdown-legend" aria-hidden="true">
          <span><i class="is-pages"></i>{__("Pages")}</span>
          <span><i class="is-groups"></i>{__("Groups")}</span>
          <span><i class="is-events"></i>{__("Events")}</span>
        </div>

        <ul class="admin-dashboard-breakdown-list">
          <li>
            <span class="admin-dashboard-breakdown-name"><i class="is-pages"></i>{__("Pages")}</span>
            <strong>{$insights['pages']|number_format}</strong>
            <a class="link link-animated admin-dashboard-action shrink-0 text-xs leading-snug" href="{$system['system_url']}/{$control_panel['url']}/pages">{__("Manage")}</a>
          </li>
          <li>
            <span class="admin-dashboard-breakdown-name"><i class="is-groups"></i>{__("Groups")}</span>
            <strong>{$insights['groups']|number_format}</strong>
            <a class="link link-animated admin-dashboard-action shrink-0 text-xs leading-snug" href="{$system['system_url']}/{$control_panel['url']}/groups">{__("Manage")}</a>
          </li>
          <li>
            <span class="admin-dashboard-breakdown-name"><i class="is-events"></i>{__("Events")}</span>
            <strong>{$insights['events']|number_format}</strong>
            <a class="link link-animated admin-dashboard-action shrink-0 text-xs leading-snug" href="{$system['system_url']}/{$control_panel['url']}/events">{__("Manage")}</a>
          </li>
        </ul>
      </article>
    </div>

    <script type="application/json" id="admin-dashboard-data">{$dashboard_chart_json nofilter}</script>

    <article class="card admin-dashboard-panel min-w-0 border border-base-300 bg-base-100 p-4 shadow-none sm:p-6 admin-dashboard-attention pb-2">
      <header class="admin-dashboard-panel-head mb-5 flex items-center gap-2.5">
        <span class="admin-dashboard-panel-icon inline-flex size-8 shrink-0 items-center justify-center rounded-field border border-base-300">
          <span class="icon-[tabler--alert-triangle] size-4" aria-hidden="true"></span>
        </span>
        <div class="admin-dashboard-panel-heading min-w-0">
          <h2 class="admin-dashboard-panel-title m-0 text-base font-semibold tracking-tight">{__("Needs attention")}</h2>
        </div>
      </header>
      <ul class="admin-dashboard-queue">
        {if $system['users_approval_enabled']}
        <li>
          <span class="admin-dashboard-queue-icon"><span class="icon-[tabler--clock] size-4" aria-hidden="true"></span></span>
          <span class="admin-dashboard-queue-label">{__("Pending")}</span>
          <span class="admin-dashboard-queue-count">{$insights['pending']|number_format}</span>
          <a class="link link-animated admin-dashboard-action shrink-0 text-xs leading-snug" href="{$system['system_url']}/{$control_panel['url']}/users/pending">{__("Manage")}</a>
        </li>
        {/if}
        <li>
          <span class="admin-dashboard-queue-icon"><span class="icon-[tabler--mail] size-4" aria-hidden="true"></span></span>
          <span class="admin-dashboard-queue-label">{__("Not Activated")}</span>
          <span class="admin-dashboard-queue-count">{$insights['not_activated']|number_format}</span>
          <a class="link link-animated admin-dashboard-action shrink-0 text-xs leading-snug" href="{$system['system_url']}/{$control_panel['url']}/users/not_activated">{__("Manage")}</a>
        </li>
        <li>
          <span class="admin-dashboard-queue-icon"><span class="icon-[tabler--ban] size-4" aria-hidden="true"></span></span>
          <span class="admin-dashboard-queue-label">{__("Banned")}</span>
          <span class="admin-dashboard-queue-count">{$insights['banned']|number_format}</span>
          <a class="link link-animated admin-dashboard-action shrink-0 text-xs leading-snug" href="{$system['system_url']}/{$control_panel['url']}/users/banned">{__("Manage")}</a>
        </li>
        <li>
          <span class="admin-dashboard-queue-icon"><span class="icon-[tabler--flag] size-4" aria-hidden="true"></span></span>
          <span class="admin-dashboard-queue-label">{__("Reports")}</span>
          <span class="admin-dashboard-queue-count">{$reports_insights|number_format}</span>
          <a class="link link-animated admin-dashboard-action shrink-0 text-xs leading-snug" href="{$system['system_url']}/{$control_panel['url']}/reports">{__("Manage")}</a>
        </li>
        <li>
          <span class="admin-dashboard-queue-icon"><span class="icon-[tabler--rosette-discount-check] size-4" aria-hidden="true"></span></span>
          <span class="admin-dashboard-queue-label">{__("Verification Requests")}</span>
          <span class="admin-dashboard-queue-count">{$verification_requests_insights|number_format}</span>
          <a class="link link-animated admin-dashboard-action shrink-0 text-xs leading-snug" href="{$system['system_url']}/{$control_panel['url']}/verification">{__("Manage")}</a>
        </li>
      </ul>
    </article>
  {/if}
</section>
