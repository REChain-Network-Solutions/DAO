{include file='_head.tpl'}
{include file='_header.tpl'}

<!-- page content -->
<div class="pb-8 sm:pb-12">

  <!-- page heading -->
  {if $view == "new"}
    {include file='__page_header.tpl' _title=__("Create New Ticket") _text=__("Fast Track Your Issue to Our Experts") _image="support.svg"}
  {else}
    {include file='__page_header.tpl' _title=__("Support Center") _text=__("Fast Track Your Issue to Our Experts") _image="support.svg"}
  {/if}
  <!-- page heading -->

  {$_support_create = (!$user->_is_admin && !$user->_is_moderator && $view != "new" && $view != "ticket")}
  {if $view == "ticket" || $view == "new" || $_support_create}
    <!-- toolbar -->
    <div class="mt-6 flex flex-wrap items-center gap-3 {if $view == "new"}mx-auto max-w-3xl{/if}">
      {if $view == "ticket" || $view == "new"}
        <a class="heroui button button--ghost button--sm w-fit gap-1.5 px-2 rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem] text-base-content/70" href="{$system['system_url']}/support/tickets">
          <span class="icon-[tabler--arrow-left] size-4 rtl:rotate-180" aria-hidden="true"></span>
          {__("Support Tickets")}
        </a>
      {/if}
      {if $_support_create}
        <a class="heroui button button--primary button--sm ms-auto w-full shrink-0 sm:w-auto rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" href="{$system['system_url']}/support/tickets/new">
          <span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>
          {__("Create Ticket")}
        </a>
      {/if}
    </div>
    <!-- toolbar -->
  {/if}

  {if $view == "new"}

    <!-- new ticket -->
    <div class="card mx-auto mt-6 max-w-3xl border border-base-300 bg-base-100 shadow-none">
      <div class="js_ajax-forms-html" data-url="support/ticket.php?do=create">
        <div class="flex items-center gap-3 border-b border-base-300 px-4 py-3">
          <span class="inline-flex size-9 shrink-0 items-center justify-center rounded-xl bg-base-200 text-base-content/70" aria-hidden="true">
            <span class="icon-[tabler--ticket] size-4.5"></span>
          </span>
          <h2 class="text-sm font-semibold">{__("Create New Ticket")}</h2>
        </div>
        <div class="flex flex-col gap-4 px-4 py-4">
          <div class="w-full">
            <label class="label-text mb-1.5 block" for="support-subject">{__("Subject")}</label>
            <input type="text" class="input w-full" name="subject" id="support-subject">
          </div>
          <div class="w-full">
            <label class="label-text mb-1.5 block" for="support-content">{__("Content")}</label>
            <textarea class="textarea js_wysiwyg w-full" name="text" id="support-content"></textarea>
          </div>

          <!-- error -->
          <div class="alert alert-error alert-danger hidden items-center" role="alert"></div>
          <!-- error -->
        </div>
        <div class="flex justify-end gap-3 border-t border-base-300 px-4 py-3">
          <button type="submit" class="heroui button button--primary rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]">
            <span class="icon-[tabler--send] size-4" aria-hidden="true"></span>
            {__("Submit")}
          </button>
        </div>
      </div>
    </div>
    <!-- new ticket -->

  {else}

    <div class="mt-6 grid gap-6 lg:grid-cols-[19rem_minmax(0,1fr)] lg:items-start">

      <!-- aside -->
      <aside class="lg:sticky lg:top-24">
        {if $view == "ticket"}
          <!-- ticket details -->
          <section class="card border border-base-300 bg-base-100 shadow-none" aria-labelledby="support-details-title">
            <div class="flex items-center gap-3 border-b border-base-300 px-4 py-3">
              <span class="inline-flex size-9 shrink-0 items-center justify-center rounded-xl bg-base-200 text-base-content/70" aria-hidden="true">
                <span class="icon-[tabler--ticket] size-4.5"></span>
              </span>
              <h2 class="text-sm font-semibold" id="support-details-title">{__("Ticket Details")}</h2>
            </div>
            <div class="relative space-y-4 px-4 py-4">
              <span class="absolute start-9 top-9 bottom-9 w-px bg-base-300" aria-hidden="true"></span>
              <div class="relative flex min-w-0 items-center gap-3">
                <img class="size-10 shrink-0 rounded-full object-cover ring-4 ring-base-100" src="{$ticket['requester_picture']}" alt="">
                <div class="min-w-0 grow">
                  <div class="text-xs text-base-content/60">{__("Requester")}</div>
                  <a class="block truncate text-sm font-semibold text-base-content! transition-colors hover:text-primary!" target="_blank" href="{$system['system_url']}/{$ticket['requester_username']}" title="{$ticket['requester_fullname']}">{$ticket['requester_fullname']}</a>
                </div>
              </div>
              <div class="relative flex min-w-0 items-center gap-3">
                {if $ticket['agent_id']}
                  {if $user->_is_admin || $user->_is_moderator}
                    <img class="size-10 shrink-0 rounded-full object-cover ring-4 ring-base-100" src="{$ticket['agent_picture']}" alt="">
                  {else}
                    <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-full bg-base-200 text-base-content/70 ring-4 ring-base-100" aria-hidden="true"><span class="icon-[tabler--headset] size-5"></span></span>
                  {/if}
                {else}
                  <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-full bg-base-200 text-base-content/50 ring-4 ring-base-100" aria-hidden="true"><span class="icon-[tabler--user-question] size-5"></span></span>
                {/if}
                <div class="min-w-0 grow">
                  <div class="text-xs text-base-content/60">{__("Agent")}</div>
                  {if $ticket['agent_id']}
                    {if $user->_is_admin || $user->_is_moderator}
                      <a class="block truncate text-sm font-semibold text-base-content! transition-colors hover:text-primary!" target="_blank" href="{$system['system_url']}/{$ticket['agent_username']}" title="{$ticket['agent_fullname']}">{$ticket['agent_fullname']}</a>
                    {else}
                      <span class="block truncate text-sm font-semibold" title="{__("Support Agent")}">{__("Support Agent")}</span>
                    {/if}
                  {else}
                    <span class="text-sm font-semibold text-base-content/60">{__("Unassigned")}</span>
                  {/if}
                </div>
              </div>
            </div>
            <div class="flex items-center justify-between gap-3 border-y border-base-300 bg-base-200/50 px-4 py-3">
              <span class="inline-flex items-center gap-2 text-xs font-medium text-base-content/60">
                <span class="icon-[tabler--activity] size-4" aria-hidden="true"></span>
                {__("Status")}
              </span>
              {include file='__support_status.tpl' _status=$ticket['status']}
            </div>
            <dl class="space-y-3 px-4 py-4">
              <div class="flex min-w-0 items-center gap-3">
                <dt class="flex min-w-0 items-center gap-3 text-xs text-base-content/60">
                  <span class="inline-flex size-8 shrink-0 items-center justify-center rounded-lg bg-base-200" aria-hidden="true">
                    <span class="icon-[tabler--refresh] size-3.5"></span>
                  </span>
                  <span>{__("Last Update")}</span>
                </dt>
                <dd class="ms-auto min-w-0 text-end text-sm font-medium"><span class="js_moment" data-time="{$ticket['updated_at']}">{$ticket['updated_at']}</span></dd>
              </div>
              <div class="flex min-w-0 items-center gap-3">
                <dt class="flex min-w-0 items-center gap-3 text-xs text-base-content/60">
                  <span class="inline-flex size-8 shrink-0 items-center justify-center rounded-lg bg-base-200" aria-hidden="true">
                    <span class="icon-[tabler--calendar-plus] size-3.5"></span>
                  </span>
                  <span>{__("Created At")}</span>
                </dt>
                <dd class="ms-auto min-w-0 text-end text-sm font-medium"><span class="js_moment" data-time="{$ticket['created_at']}">{$ticket['created_at']}</span></dd>
              </div>
            </dl>
            {if $user->_is_admin || $user->_is_moderator}
              <div class="border-t border-base-300 px-4 py-3">
                <button type="button" class="js_modal heroui button button--primary [--button-bg:var(--color-base-content)] [--button-bg-hover:color-mix(in_oklab,var(--color-base-content)_85%,transparent)] [--button-bg-pressed:color-mix(in_oklab,var(--color-base-content)_85%,transparent)] [--button-fg:var(--color-base-100)] button--sm w-full rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" data-url="support/ticket.php?do=update&ticket_id={$ticket['ticket_id']}">
                  <span class="icon-[tabler--edit] size-4" aria-hidden="true"></span>
                  {__("Update")}
                </button>
              </div>
            {/if}
          </section>
          <!-- ticket details -->
        {else}
          <!-- statuses -->
          <nav class="card border border-base-300 bg-base-100 shadow-none" aria-labelledby="support-statuses-title">
            <div class="flex items-center gap-3 border-b border-base-300 px-4 py-3">
              <span class="inline-flex size-9 shrink-0 items-center justify-center rounded-xl bg-base-200 text-base-content/70" aria-hidden="true">
                <span class="icon-[tabler--filter] size-4.5"></span>
              </span>
              <h2 class="text-sm font-semibold" id="support-statuses-title">{__("Tickets")}</h2>
            </div>
            <ul class="m-0 list-none space-y-1 px-2 py-3">
              <li>
                <a class="flex items-center gap-3 rounded-lg px-2 py-1.5 transition-colors {if ($view == "" || $view == "tickets") && !$status && !$unassigned}bg-primary/10 text-primary!{else}text-base-content! hover:bg-base-200/60{/if}" href="{$system['system_url']}/support/tickets" {if ($view == "" || $view == "tickets") && !$status && !$unassigned}aria-current="page"{/if}>
                  <span class="inline-flex size-8 shrink-0 items-center justify-center rounded-lg {if ($view == "" || $view == "tickets") && !$status && !$unassigned}bg-base-100 text-primary{else}bg-base-200 text-base-content/70{/if}" aria-hidden="true">
                    <span class="icon-[tabler--inbox] size-3.5"></span>
                  </span>
                  <span class="min-w-0 grow truncate text-sm font-medium" title='{__("All")}'>{__("All")}</span>
                  <span class="text-sm font-medium tabular-nums {if $tickets_stats['total'] == 0}opacity-40{/if}">{$tickets_stats['total']}</span>
                </a>
              </li>
              {if $user->_is_admin}
                <li>
                  <a class="flex items-center gap-3 rounded-lg px-2 py-1.5 transition-colors {if $unassigned}bg-primary/10 text-primary!{else}text-base-content! hover:bg-base-200/60{/if}" href="{$system['system_url']}/support/tickets?unassigned=true" {if $unassigned}aria-current="page"{/if}>
                    <span class="inline-flex size-8 shrink-0 items-center justify-center rounded-lg {if $unassigned}bg-base-100 text-primary{else}bg-base-200 text-base-content/70{/if}" aria-hidden="true">
                      <span class="icon-[tabler--user-question] size-3.5"></span>
                    </span>
                    <span class="min-w-0 grow truncate text-sm font-medium" title='{__("Unassigned")}'>{__("Unassigned")}</span>
                    <span class="text-sm font-medium tabular-nums {if $tickets_stats['unassigned'] == 0}opacity-40{/if}">{$tickets_stats['unassigned']}</span>
                  </a>
                </li>
              {/if}
              <li>
                <a class="flex items-center gap-3 rounded-lg px-2 py-1.5 transition-colors {if $status == "in_progress"}bg-primary/10 text-primary!{else}text-base-content! hover:bg-base-200/60{/if}" href="{$system['system_url']}/support/tickets?status=in_progress" {if $status == "in_progress"}aria-current="page"{/if}>
                  <span class="inline-flex size-8 shrink-0 items-center justify-center rounded-lg {if $status == "in_progress"}bg-base-100 text-primary{else}bg-base-200 text-base-content/70{/if}" aria-hidden="true">
                    <span class="icon-[tabler--progress] size-3.5"></span>
                  </span>
                  <span class="min-w-0 grow truncate text-sm font-medium" title='{__("In Progress")}'>{__("In Progress")}</span>
                  <span class="text-sm font-medium tabular-nums {if $tickets_stats['in_progress'] == 0}opacity-40{/if}">{$tickets_stats['in_progress']}</span>
                </a>
              </li>
            </ul>
            <div class="flex items-center gap-2 border-y border-base-300 bg-base-200/50 px-4 py-3 text-xs font-medium text-base-content/60">
              <span class="icon-[tabler--activity] size-4" aria-hidden="true"></span>
              {__("Status")}
            </div>
            <ul class="m-0 list-none space-y-1 px-2 py-3">
              <li>
                <a class="flex items-center gap-3 rounded-lg px-2 py-1.5 transition-colors {if $status == "opened"}bg-primary/10 text-primary!{else}text-base-content! hover:bg-base-200/60{/if}" href="{$system['system_url']}/support/tickets?status=opened" {if $status == "opened"}aria-current="page"{/if}>
                  <span class="inline-flex size-8 shrink-0 items-center justify-center rounded-lg {if $status == "opened"}bg-base-100 text-primary{else}bg-base-200 text-base-content/70{/if}" aria-hidden="true">
                    <span class="icon-[tabler--mail-opened] size-3.5"></span>
                  </span>
                  <span class="min-w-0 grow truncate text-sm font-medium" title='{__("Open")}'>{__("Open")}</span>
                  <span class="text-sm font-medium tabular-nums {if $tickets_stats['opened'] == 0}opacity-40{/if}">{$tickets_stats['opened']}</span>
                </a>
              </li>
              <li>
                <a class="flex items-center gap-3 rounded-lg px-2 py-1.5 transition-colors {if $status == "pending"}bg-primary/10 text-primary!{else}text-base-content! hover:bg-base-200/60{/if}" href="{$system['system_url']}/support/tickets?status=pending" {if $status == "pending"}aria-current="page"{/if}>
                  <span class="inline-flex size-8 shrink-0 items-center justify-center rounded-lg {if $status == "pending"}bg-base-100 text-primary{else}bg-base-200 text-base-content/70{/if}" aria-hidden="true">
                    <span class="icon-[tabler--clock-pause] size-3.5"></span>
                  </span>
                  <span class="min-w-0 grow truncate text-sm font-medium" title='{__("Pending")}'>{__("Pending")}</span>
                  <span class="text-sm font-medium tabular-nums {if $tickets_stats['pending'] == 0}opacity-40{/if}">{$tickets_stats['pending']}</span>
                </a>
              </li>
              <li>
                <a class="flex items-center gap-3 rounded-lg px-2 py-1.5 transition-colors {if $status == "solved"}bg-primary/10 text-primary!{else}text-base-content! hover:bg-base-200/60{/if}" href="{$system['system_url']}/support/tickets?status=solved" {if $status == "solved"}aria-current="page"{/if}>
                  <span class="inline-flex size-8 shrink-0 items-center justify-center rounded-lg {if $status == "solved"}bg-base-100 text-primary{else}bg-base-200 text-base-content/70{/if}" aria-hidden="true">
                    <span class="icon-[tabler--circle-check] size-3.5"></span>
                  </span>
                  <span class="min-w-0 grow truncate text-sm font-medium" title='{__("Solved")}'>{__("Solved")}</span>
                  <span class="text-sm font-medium tabular-nums {if $tickets_stats['solved'] == 0}opacity-40{/if}">{$tickets_stats['solved']}</span>
                </a>
              </li>
              <li>
                <a class="flex items-center gap-3 rounded-lg px-2 py-1.5 transition-colors {if $status == "closed"}bg-primary/10 text-primary!{else}text-base-content! hover:bg-base-200/60{/if}" href="{$system['system_url']}/support/tickets?status=closed" {if $status == "closed"}aria-current="page"{/if}>
                  <span class="inline-flex size-8 shrink-0 items-center justify-center rounded-lg {if $status == "closed"}bg-base-100 text-primary{else}bg-base-200 text-base-content/70{/if}" aria-hidden="true">
                    <span class="icon-[tabler--circle-x] size-3.5"></span>
                  </span>
                  <span class="min-w-0 grow truncate text-sm font-medium" title='{__("Closed")}'>{__("Closed")}</span>
                  <span class="text-sm font-medium tabular-nums {if $tickets_stats['closed'] == 0}opacity-40{/if}">{$tickets_stats['closed']}</span>
                </a>
              </li>
            </ul>
          </nav>
          <!-- statuses -->
        {/if}
      </aside>
      <!-- aside -->

      <!-- content -->
      <div class="flex min-w-0 flex-col gap-6">

        {if $view == "" || $view == "tickets" || $view == "find"}

          <!-- tickets -->
          <section class="card min-w-0 border border-base-300 bg-base-100 shadow-none" aria-labelledby="support-tickets-title">
            <div class="flex flex-wrap items-center gap-3 border-b border-base-300 px-4 py-3 sm:flex-nowrap">
              <span class="inline-flex size-9 shrink-0 items-center justify-center rounded-xl bg-base-200 text-base-content/70" aria-hidden="true">
                <span class="icon-[tabler--lifebuoy] size-4.5"></span>
              </span>
              <div class="min-w-0 grow">
                <h2 class="text-sm font-semibold" id="support-tickets-title">{__("Tickets")}</h2>
                {if $view == "find"}
                  <p class="truncate text-xs text-base-content/60" title="{__("Search")}: {$query}">{__("Search")}: <strong class="text-base-content">{$query}</strong></p>
                {/if}
              </div>
              <form class="w-full shrink-0 sm:ms-auto sm:w-72" action="{$system['system_url']}/support/tickets/find" method="get" role="search">
                <label class="input input-sm w-full">
                  <span class="icon-[tabler--search] my-auto me-2 size-4 shrink-0 text-base-content/50" aria-hidden="true"></span>
                  <input type="search" class="grow [&::-webkit-search-cancel-button]:appearance-none" name="query" value="{$query}" placeholder='{__("Search by Subject or TicketID")}' aria-label='{__("Search by Subject or TicketID")}'>
                  {if $view == "find"}
                    <a class="my-auto ms-2 inline-flex size-5 shrink-0 items-center justify-center rounded-full bg-base-200 text-base-content/60! transition-colors hover:bg-base-300 hover:text-base-content!" href="{$system['system_url']}/support/tickets" aria-label='{__("Clear")}' title='{__("Clear")}'>
                      <span class="icon-[tabler--x] size-3" aria-hidden="true"></span>
                    </a>
                  {/if}
                </label>
              </form>
            </div>
            {if $tickets}
              <div class="w-full overflow-x-auto">
                <table class="table w-full min-w-[36rem] table-fixed md:min-w-0">
                  <thead>
                    <tr class="border-b border-base-300 bg-base-200/50">
                      <th class="px-4 py-3 text-xs font-medium tracking-normal text-base-content/60 normal-case">{__("Subject")}</th>
                      <th class="w-48 px-4 py-3 text-xs font-medium tracking-normal text-base-content/60 normal-case">{__("Agent")}</th>
                      <th class="w-36 px-4 py-3 text-xs font-medium tracking-normal text-base-content/60 normal-case">{__("Status")}</th>
                    </tr>
                  </thead>
                  <tbody>
                    {foreach $tickets as $ticket}
                      <tr class="transition-colors hover:bg-base-200/40">
                        <td class="px-4 py-3">
                          <div class="flex min-w-0 items-center gap-3">
                            <img class="size-10 shrink-0 rounded-full object-cover" src="{$ticket['requester_picture']}" alt="">
                            <div class="min-w-0 grow">
                              <a class="block truncate text-sm font-semibold text-base-content! transition-colors hover:text-primary!" href="{$system['system_url']}/support/tickets/{$ticket['ticket_id']}" title="{$ticket['subject']}">{$ticket['subject']}</a>
                              <div class="mt-0.5 flex min-w-0 flex-wrap items-center gap-x-2 gap-y-1 text-xs text-base-content/60">
                                <span class="font-mono">#{$ticket['ticket_id']}</span>
                                <span aria-hidden="true">·</span>
                                <a class="max-w-40 truncate text-base-content/60! transition-colors hover:text-primary!" target="_blank" href="{$system['system_url']}/{$ticket['requester_username']}" title="{$ticket['requester_fullname']}">{$ticket['requester_fullname']}</a>
                                <span aria-hidden="true">·</span>
                                <span class="js_moment" data-time="{$ticket['updated_at']}" title='{__("Last Update")}'>{$ticket['updated_at']}</span>
                              </div>
                            </div>
                          </div>
                        </td>
                        <td class="px-4 py-3">
                          {if $ticket['agent_id']}
                            {if $user->_is_admin || $user->_is_moderator}
                              <a class="flex min-w-0 items-center gap-2 text-sm font-medium text-base-content! transition-colors hover:text-primary!" target="_blank" href="{$system['system_url']}/{$ticket['agent_username']}">
                                <img class="size-8 shrink-0 rounded-full object-cover" src="{$ticket['agent_picture']}" alt="">
                                <span class="min-w-0 truncate" title="{$ticket['agent_fullname']}">{$ticket['agent_fullname']}</span>
                              </a>
                            {else}
                              <span class="flex min-w-0 items-center gap-2 text-sm font-medium">
                                <span class="inline-flex size-8 shrink-0 items-center justify-center rounded-full bg-base-200 text-base-content/70" aria-hidden="true"><span class="icon-[tabler--headset] size-4"></span></span>
                                <span class="min-w-0 truncate" title='{__("Support Agent")}'>{__("Support Agent")}</span>
                              </span>
                            {/if}
                          {else}
                            <span class="flex min-w-0 items-center gap-2 text-sm font-medium text-base-content/60">
                              <span class="inline-flex size-8 shrink-0 items-center justify-center rounded-full bg-base-200 text-base-content/50" aria-hidden="true"><span class="icon-[tabler--user-question] size-4"></span></span>
                              <span class="min-w-0 truncate" title='{__("Unassigned")}'>{__("Unassigned")}</span>
                            </span>
                          {/if}
                        </td>
                        <td class="px-4 py-3">{include file='__support_status.tpl' _status=$ticket['status']}</td>
                      </tr>
                    {/foreach}
                  </tbody>
                </table>
              </div>
            {else}
              {include file='_no_data.tpl' _empty_icon="icon-[tabler--ticket]"}
            {/if}
          </section>
          {if $pager}{$pager}{/if}
          <!-- tickets -->

        {elseif $view == "ticket"}

          <!-- ticket heading -->
          <div class="min-w-0">
            <span class="font-mono text-xs text-base-content/50">#{$ticket['ticket_id']}</span>
            <h2 class="text-2xl font-bold tracking-tight">{$ticket['subject']}</h2>
          </div>
          <!-- ticket heading -->

          <!-- conversation -->
          <div class="flex flex-col gap-4">
            {include file='__support_message.tpl' _name=$ticket['requester_fullname'] _picture=$ticket['requester_picture'] _link="`$system['system_url']`/`$ticket['requester_username']`" _role=3 _agent=false _time=$ticket['created_at'] _text=$ticket['parsed_text']}
            {if $ticket['replies']}
              {foreach $ticket['replies'] as $reply}
                {$_reply_agent = ($reply['user_name'] != $ticket['requester_username'])}
                {if $user->_is_admin || $user->_is_moderator}
                  {include file='__support_message.tpl' _name=$reply['user_fullname'] _picture=$reply['user_picture'] _link="`$system['system_url']`/`$reply['user_name']`" _role=$reply['user_group'] _agent=$_reply_agent _time=$reply['created_at'] _text=$reply['parsed_text']}
                {else}
                  {include file='__support_message.tpl' _name=$reply['user_fullname'] _picture=$reply['user_picture'] _link="" _role=0 _agent=$_reply_agent _time=$reply['created_at'] _text=$reply['parsed_text']}
                {/if}
              {/foreach}
            {/if}
          </div>
          <!-- conversation -->

          <!-- reply form -->
          <div class="card border border-base-300 bg-base-100 shadow-none">
            <div class="js_ajax-forms-html" data-url="support/ticket.php?do=reply&id={$ticket['ticket_id']}">
              <div class="flex items-center gap-3 border-b border-base-300 px-4 py-3">
                <span class="inline-flex size-9 shrink-0 items-center justify-center rounded-xl bg-base-200 text-base-content/70" aria-hidden="true">
                  <span class="icon-[tabler--message-reply] size-4.5"></span>
                </span>
                <h2 class="text-sm font-semibold">{__("Post Reply")}</h2>
              </div>
              <div class="flex flex-col gap-4 px-4 py-4">
                <textarea class="textarea js_wysiwyg w-full" name="text" aria-label='{__("Post Reply")}'></textarea>

                <!-- error -->
                <div class="alert alert-error alert-danger hidden items-center" role="alert"></div>
                <!-- error -->
              </div>
              <div class="flex justify-end gap-3 border-t border-base-300 px-4 py-3">
                <button type="submit" class="heroui button button--primary rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]">
                  <span class="icon-[tabler--send] size-4" aria-hidden="true"></span>
                  {__("Submit")}
                </button>
              </div>
            </div>
          </div>
          <!-- reply form -->

        {/if}

      </div>
      <!-- content -->

    </div>

  {/if}

</div>
<!-- page content -->

{include file='_footer.tpl'}
