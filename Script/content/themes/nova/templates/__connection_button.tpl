{if $_mustache}
  {capture assign="_b_uid"}{literal}{{uid}}{/literal}{/capture}
  {capture assign="_b_id"}{literal}{{id}}{/literal}{/capture}
  {capture assign="_b_privacy"}{literal}{{privacy}}{/literal}{/capture}
  {capture assign="_b_size"}{literal}{{size}}{/literal}{/capture}
{else}
  {assign var="_b_uid" value=$_uid}
  {assign var="_b_id" value=$_id}
  {assign var="_b_privacy" value=$_privacy}
  {if $_btn_size}{assign var="_b_size" value=$_btn_size}{else}{assign var="_b_size" value="sm"}{/if}
{/if}
{assign var="_b_undo" value='group/undo transition-[color,background-color,transform] duration-200 ease-out [&:hover:not([data-fresh])]:[--button-bg-hover:var(--danger-soft)] [&:hover:not([data-fresh])]:[--button-bg-pressed:var(--danger-soft-hover)] [&:hover:not([data-fresh])]:[--button-fg:var(--danger-soft-foreground)]'}
{if $_state == "friend_add"}
  <button type="button" class="heroui button button--primary button--{$_b_size} rounded-[0.625rem] [corner-shape:squircle] supports-[corner-shape:squircle]:rounded-[1rem] js_friend-add" data-uid="{$_b_uid}" data-size="{$_b_size}"><span class="icon-[tabler--user-plus] size-4" aria-hidden="true"></span>{__("Add Friend")}</button>
{elseif $_state == "friend_sent"}
  <button type="button" class="{$_b_undo} heroui button button--tertiary [--button-bg:var(--warning-soft)] [--button-bg-hover:var(--warning-soft-hover)] [--button-bg-pressed:var(--warning-soft-hover)] [--button-fg:var(--warning-soft-foreground)] button--{$_b_size} rounded-[0.625rem] [corner-shape:squircle] supports-[corner-shape:squircle]:rounded-[1rem] js_friend-cancel" data-uid="{$_b_uid}" data-size="{$_b_size}" title='{__("Cancel Request")}' aria-label='{__("Cancel Request")}'>
    <span class="inline-grid">
      <span class="col-start-1 row-start-1 inline-flex items-center justify-center gap-2 transition-opacity duration-200 ease-out group-[:hover:not([data-fresh])]/undo:opacity-0"><span class="icon-[tabler--clock] size-4" aria-hidden="true"></span>{__("Sent")}</span>
      <span class="col-start-1 row-start-1 inline-flex items-center justify-center gap-2 opacity-0 transition-opacity duration-200 ease-out group-[:hover:not([data-fresh])]/undo:opacity-100" aria-hidden="true"><span class="icon-[tabler--x] size-4"></span>{__("Cancel Request")}</span>
    </span>
  </button>
{elseif $_state == "friends"}
  <button type="button" class="{$_b_undo} heroui button button--tertiary [--button-bg:var(--success-soft)] [--button-bg-hover:var(--success-soft-hover)] [--button-bg-pressed:var(--success-soft-hover)] [--button-fg:var(--success-soft-foreground)] button--{$_b_size} rounded-[0.625rem] [corner-shape:squircle] supports-[corner-shape:squircle]:rounded-[1rem] js_friend-remove" data-uid="{$_b_uid}" data-size="{$_b_size}" title='{__("Unfriend")}' aria-label='{__("Unfriend")}'>
    <span class="inline-grid">
      <span class="col-start-1 row-start-1 inline-flex items-center justify-center gap-2 transition-opacity duration-200 ease-out group-[:hover:not([data-fresh])]/undo:opacity-0"><span class="icon-[tabler--user-check] size-4" aria-hidden="true"></span>{__("Friends")}</span>
      <span class="col-start-1 row-start-1 inline-flex items-center justify-center gap-2 opacity-0 transition-opacity duration-200 ease-out group-[:hover:not([data-fresh])]/undo:opacity-100" aria-hidden="true"><span class="icon-[tabler--x] size-4"></span>{__("Unfriend")}</span>
    </span>
  </button>
{elseif $_state == "friend_request"}
  <button type="button" class="heroui button button--primary button--{$_b_size} rounded-[0.625rem] [corner-shape:squircle] supports-[corner-shape:squircle]:rounded-[1rem] js_friend-accept" data-uid="{$_b_uid}" data-size="{$_b_size}"><span class="icon-[tabler--check] size-4" aria-hidden="true"></span>{__("Confirm")}</button>
  <button type="button" class="heroui button button--tertiary button--{$_b_size} button--icon-only grow-0! shrink-0 rounded-[0.625rem] [corner-shape:squircle] supports-[corner-shape:squircle]:rounded-[1rem] transition-[color,background-color,transform] duration-200 ease-out hover:[--button-bg-hover:var(--danger-soft)] hover:[--button-bg-pressed:var(--danger-soft-hover)] hover:[--button-fg:var(--danger-soft-foreground)] js_friend-decline" data-uid="{$_b_uid}" data-size="{$_b_size}" title='{__("Decline")}' aria-label='{__("Decline")}'><span class="icon-[tabler--x] size-4" aria-hidden="true"></span></button>
{elseif $_state == "follow"}
  <button type="button" class="heroui button button--primary [--button-bg:var(--color-info)] [--button-bg-hover:color-mix(in_oklab,var(--color-info)_90%,black)] [--button-bg-pressed:color-mix(in_oklab,var(--color-info)_90%,black)] [--button-fg:var(--color-info-content)] button--{$_b_size} rounded-[0.625rem] [corner-shape:squircle] supports-[corner-shape:squircle]:rounded-[1rem] js_follow" data-uid="{$_b_uid}" data-size="{$_b_size}"><span class="icon-[tabler--rss] size-4" aria-hidden="true"></span>{__("Follow")}</button>
{elseif $_state == "following"}
  <button type="button" class="{$_b_undo} heroui button button--tertiary [--button-bg:color-mix(in_oklab,var(--color-info)_14%,transparent)] [--button-bg-hover:color-mix(in_oklab,var(--color-info)_22%,transparent)] [--button-bg-pressed:color-mix(in_oklab,var(--color-info)_22%,transparent)] [--button-fg:color-mix(in_oklab,var(--color-info)_78%,var(--color-base-content))] button--{$_b_size} rounded-[0.625rem] [corner-shape:squircle] supports-[corner-shape:squircle]:rounded-[1rem] js_unfollow" data-uid="{$_b_uid}" data-size="{$_b_size}" title='{__("Unfollow")}' aria-label='{__("Unfollow")}'>
    <span class="inline-grid">
      <span class="col-start-1 row-start-1 inline-flex items-center justify-center gap-2 transition-opacity duration-200 ease-out group-[:hover:not([data-fresh])]/undo:opacity-0"><span class="icon-[tabler--check] size-4" aria-hidden="true"></span>{__("Following")}</span>
      <span class="col-start-1 row-start-1 inline-flex items-center justify-center gap-2 opacity-0 transition-opacity duration-200 ease-out group-[:hover:not([data-fresh])]/undo:opacity-100" aria-hidden="true"><span class="icon-[tabler--x] size-4"></span>{__("Unfollow")}</span>
    </span>
  </button>
{elseif $_state == "unblock"}
  <button type="button" class="heroui button button--danger-soft button--{$_b_size} rounded-[0.625rem] [corner-shape:squircle] supports-[corner-shape:squircle]:rounded-[1rem] js_unblock-user" data-uid="{$_b_uid}" data-size="{$_b_size}"><span class="icon-[tabler--lock-open] size-4" aria-hidden="true"></span>{__("Unblock")}</button>
{elseif $_state == "invite"}
  <button type="button" class="heroui button button--primary button--{$_b_size} rounded-[0.625rem] [corner-shape:squircle] supports-[corner-shape:squircle]:rounded-[1rem] js_{$_node}-invite" data-id="{$_b_id}" data-uid="{$_b_uid}" data-size="{$_b_size}"><span class="icon-[tabler--user-plus] size-4" aria-hidden="true"></span>{__("Invite")}</button>
{elseif $_state == "member_remove"}
  <button type="button" class="heroui button button--danger-soft button--{$_b_size} rounded-[0.625rem] [corner-shape:squircle] supports-[corner-shape:squircle]:rounded-[1rem] js_{$_node}-member-remove" data-id="{$_b_id}" data-uid="{$_b_uid}" data-size="{$_b_size}"><span class="icon-[tabler--trash] size-4" aria-hidden="true"></span>{__("Remove")}</button>
{elseif $_state == "admin_add"}
  <button type="button" class="heroui button button--tertiary text-base-content button--{$_b_size} rounded-[0.625rem] [corner-shape:squircle] supports-[corner-shape:squircle]:rounded-[1rem] js_{$_node}-admin-addation" data-id="{$_b_id}" data-uid="{$_b_uid}" data-size="{$_b_size}"><span class="icon-[tabler--shield-check] size-4" aria-hidden="true"></span>{__("Make Admin")}</button>
{elseif $_state == "admin_remove"}
  <button type="button" class="heroui button button--danger-soft button--{$_b_size} rounded-[0.625rem] [corner-shape:squircle] supports-[corner-shape:squircle]:rounded-[1rem] js_{$_node}-admin-remove" data-id="{$_b_id}" data-uid="{$_b_uid}" data-size="{$_b_size}"><span class="icon-[tabler--shield-x] size-4" aria-hidden="true"></span>{__("Remove Admin")}</button>
{elseif $_state == "group_request"}
  <button type="button" class="heroui button button--primary button--{$_b_size} rounded-[0.625rem] [corner-shape:squircle] supports-[corner-shape:squircle]:rounded-[1rem] js_group-request-accept" data-id="{$_b_id}" data-uid="{$_b_uid}" data-size="{$_b_size}"><span class="icon-[tabler--check] size-4" aria-hidden="true"></span>{__("Approve")}</button>
  <button type="button" class="heroui button button--tertiary button--{$_b_size} button--icon-only grow-0! shrink-0 rounded-[0.625rem] [corner-shape:squircle] supports-[corner-shape:squircle]:rounded-[1rem] transition-[color,background-color,transform] duration-200 ease-out hover:[--button-bg-hover:var(--danger-soft)] hover:[--button-bg-pressed:var(--danger-soft-hover)] hover:[--button-fg:var(--danger-soft-foreground)] js_group-request-decline" data-id="{$_b_id}" data-uid="{$_b_uid}" data-size="{$_b_size}" title='{__("Decline")}' aria-label='{__("Decline")}'><span class="icon-[tabler--x] size-4" aria-hidden="true"></span></button>
{elseif $_state == "account_remove"}
  <button type="button" class="heroui button button--danger-soft button--{$_b_size} rounded-[0.625rem] [corner-shape:squircle] supports-[corner-shape:squircle]:rounded-[1rem] js_connected-account-remove" data-uid="{$_b_uid}" data-size="{$_b_size}"><span class="icon-[tabler--trash] size-4" aria-hidden="true"></span>{__("Remove")}</button>
{elseif $_state == "account_revoke"}
  <button type="button" class="heroui button button--danger-soft button--{$_b_size} rounded-[0.625rem] [corner-shape:squircle] supports-[corner-shape:squircle]:rounded-[1rem] js_connected-account-revoke" data-size="{$_b_size}"><span class="icon-[tabler--trash] size-4" aria-hidden="true"></span>{__("Revoke")}</button>
{elseif $_state == "page_like"}
  <button type="button" class="heroui button button--primary [--button-bg:var(--color-info)] [--button-bg-hover:color-mix(in_oklab,var(--color-info)_90%,black)] [--button-bg-pressed:color-mix(in_oklab,var(--color-info)_90%,black)] [--button-fg:var(--color-info-content)] button--{$_b_size} rounded-[0.625rem] [corner-shape:squircle] supports-[corner-shape:squircle]:rounded-[1rem] js_like-page" data-id="{$_b_id}" data-size="{$_b_size}"><span class="icon-[tabler--heart] size-4" aria-hidden="true"></span>{__("Like")}</button>
{elseif $_state == "page_liked"}
  <button type="button" class="{$_b_undo} heroui button button--tertiary [--button-bg:color-mix(in_oklab,var(--color-info)_14%,transparent)] [--button-bg-hover:color-mix(in_oklab,var(--color-info)_22%,transparent)] [--button-bg-pressed:color-mix(in_oklab,var(--color-info)_22%,transparent)] [--button-fg:color-mix(in_oklab,var(--color-info)_78%,var(--color-base-content))] button--{$_b_size} rounded-[0.625rem] [corner-shape:squircle] supports-[corner-shape:squircle]:rounded-[1rem] js_unlike-page" data-id="{$_b_id}" data-size="{$_b_size}" title='{__("Unlike")}' aria-label='{__("Unlike")}'>
    <span class="inline-grid">
      <span class="col-start-1 row-start-1 inline-flex items-center justify-center gap-2 transition-opacity duration-200 ease-out group-[:hover:not([data-fresh])]/undo:opacity-0"><span class="icon-[tabler--heart-filled] size-4" aria-hidden="true"></span>{__("Liked")}</span>
      <span class="col-start-1 row-start-1 inline-flex items-center justify-center gap-2 opacity-0 transition-opacity duration-200 ease-out group-[:hover:not([data-fresh])]/undo:opacity-100" aria-hidden="true"><span class="icon-[tabler--x] size-4"></span>{__("Unlike")}</span>
    </span>
  </button>
{elseif $_state == "group_join"}
  <button type="button" class="heroui button button--primary button--{$_b_size} rounded-[0.625rem] [corner-shape:squircle] supports-[corner-shape:squircle]:rounded-[1rem] js_join-group" data-id="{$_b_id}" data-privacy="{$_b_privacy}" data-size="{$_b_size}"><span class="icon-[tabler--user-plus] size-4" aria-hidden="true"></span>{__("Join")}</button>
{elseif $_state == "group_joined"}
  <button type="button" class="{$_b_undo} heroui button button--tertiary [--button-bg:var(--success-soft)] [--button-bg-hover:var(--success-soft-hover)] [--button-bg-pressed:var(--success-soft-hover)] [--button-fg:var(--success-soft-foreground)] button--{$_b_size} rounded-[0.625rem] [corner-shape:squircle] supports-[corner-shape:squircle]:rounded-[1rem] js_leave-group" data-id="{$_b_id}" data-privacy="{$_b_privacy}" data-size="{$_b_size}" title='{__("Leave")}' aria-label='{__("Leave")}'>
    <span class="inline-grid">
      <span class="col-start-1 row-start-1 inline-flex items-center justify-center gap-2 transition-opacity duration-200 ease-out group-[:hover:not([data-fresh])]/undo:opacity-0"><span class="icon-[tabler--check] size-4" aria-hidden="true"></span>{__("Joined")}</span>
      <span class="col-start-1 row-start-1 inline-flex items-center justify-center gap-2 opacity-0 transition-opacity duration-200 ease-out group-[:hover:not([data-fresh])]/undo:opacity-100" aria-hidden="true"><span class="icon-[tabler--x] size-4"></span>{__("Leave")}</span>
    </span>
  </button>
{elseif $_state == "group_pending"}
  <button type="button" class="{$_b_undo} heroui button button--tertiary [--button-bg:var(--warning-soft)] [--button-bg-hover:var(--warning-soft-hover)] [--button-bg-pressed:var(--warning-soft-hover)] [--button-fg:var(--warning-soft-foreground)] button--{$_b_size} rounded-[0.625rem] [corner-shape:squircle] supports-[corner-shape:squircle]:rounded-[1rem] js_leave-group" data-id="{$_b_id}" data-privacy="{$_b_privacy}" data-size="{$_b_size}" title='{__("Cancel Request")}' aria-label='{__("Cancel Request")}'>
    <span class="inline-grid">
      <span class="col-start-1 row-start-1 inline-flex items-center justify-center gap-2 transition-opacity duration-200 ease-out group-[:hover:not([data-fresh])]/undo:opacity-0"><span class="icon-[tabler--clock] size-4" aria-hidden="true"></span>{__("Pending")}</span>
      <span class="col-start-1 row-start-1 inline-flex items-center justify-center gap-2 opacity-0 transition-opacity duration-200 ease-out group-[:hover:not([data-fresh])]/undo:opacity-100" aria-hidden="true"><span class="icon-[tabler--x] size-4"></span>{__("Cancel Request")}</span>
    </span>
  </button>
{elseif $_state == "event_go"}
  <button type="button" class="heroui button button--primary button--{$_b_size} rounded-[0.625rem] [corner-shape:squircle] supports-[corner-shape:squircle]:rounded-[1rem] js_go-event" data-id="{$_b_id}" data-size="{$_b_size}"><span class="icon-[tabler--calendar-check] size-4" aria-hidden="true"></span>{__("Going")}</button>
{elseif $_state == "event_going"}
  <button type="button" class="{$_b_undo} heroui button button--tertiary [--button-bg:var(--success-soft)] [--button-bg-hover:var(--success-soft-hover)] [--button-bg-pressed:var(--success-soft-hover)] [--button-fg:var(--success-soft-foreground)] button--{$_b_size} rounded-[0.625rem] [corner-shape:squircle] supports-[corner-shape:squircle]:rounded-[1rem] js_ungo-event" data-id="{$_b_id}" data-size="{$_b_size}" title='{__("Not Going")}' aria-label='{__("Not Going")}'>
    <span class="inline-grid">
      <span class="col-start-1 row-start-1 inline-flex items-center justify-center gap-2 transition-opacity duration-200 ease-out group-[:hover:not([data-fresh])]/undo:opacity-0"><span class="icon-[tabler--check] size-4" aria-hidden="true"></span>{__("Going")}</span>
      <span class="col-start-1 row-start-1 inline-flex items-center justify-center gap-2 opacity-0 transition-opacity duration-200 ease-out group-[:hover:not([data-fresh])]/undo:opacity-100" aria-hidden="true"><span class="icon-[tabler--x] size-4"></span>{__("Not Going")}</span>
    </span>
  </button>
{elseif $_state == "event_interest"}
  <button type="button" class="heroui button button--primary button--{$_b_size} rounded-[0.625rem] [corner-shape:squircle] supports-[corner-shape:squircle]:rounded-[1rem] js_interest-event" data-id="{$_b_id}" data-size="{$_b_size}"><span class="icon-[tabler--star] size-4" aria-hidden="true"></span>{__("Interested")}</button>
{elseif $_state == "event_interested"}
  <button type="button" class="{$_b_undo} heroui button button--tertiary [--button-bg:color-mix(in_oklab,var(--color-info)_14%,transparent)] [--button-bg-hover:color-mix(in_oklab,var(--color-info)_22%,transparent)] [--button-bg-pressed:color-mix(in_oklab,var(--color-info)_22%,transparent)] [--button-fg:color-mix(in_oklab,var(--color-info)_78%,var(--color-base-content))] button--{$_b_size} rounded-[0.625rem] [corner-shape:squircle] supports-[corner-shape:squircle]:rounded-[1rem] js_uninterest-event" data-id="{$_b_id}" data-size="{$_b_size}" title='{__("Not Interested")}' aria-label='{__("Not Interested")}'>
    <span class="inline-grid">
      <span class="col-start-1 row-start-1 inline-flex items-center justify-center gap-2 transition-opacity duration-200 ease-out group-[:hover:not([data-fresh])]/undo:opacity-0"><span class="icon-[tabler--check] size-4" aria-hidden="true"></span>{__("Interested")}</span>
      <span class="col-start-1 row-start-1 inline-flex items-center justify-center gap-2 opacity-0 transition-opacity duration-200 ease-out group-[:hover:not([data-fresh])]/undo:opacity-100" aria-hidden="true"><span class="icon-[tabler--x] size-4"></span>{__("Not Interested")}</span>
    </span>
  </button>
{/if}
