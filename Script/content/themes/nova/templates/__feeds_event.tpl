{if $_tpl == "box"}
  <li class="group flex min-w-0 flex-col overflow-hidden rounded-box border border-base-300 {if $_darker}bg-base-200{else}bg-base-100{/if} transition-shadow hover:shadow-md">
    <a class="relative block aspect-video overflow-hidden bg-linear-to-br from-primary/25 via-primary/10 to-secondary/20" href="{$system['system_url']}/events/{$_event['event_id']}{if $_search}?ref=qs{/if}" aria-label="{$_event['event_title']}">
      {if $_event['event_cover']}
        <img class="size-full object-cover transition-transform duration-500 group-hover:scale-105" src="{$_event['event_picture']}" alt="" loading="lazy">
      {else}
        <span class="absolute inset-0 flex items-center justify-center text-primary/40" aria-hidden="true"><span class="icon-[tabler--calendar-event] size-12"></span></span>
      {/if}
      <time class="absolute start-3 top-3 flex min-w-12 flex-col items-center rounded-xl bg-base-100/95 px-2 py-1 leading-tight text-base-content shadow-sm backdrop-blur-sm" datetime="{$_event['event_start_date']|date_format:"%Y-%m-%dT%H:%M"}">
        <strong class="text-lg font-bold">{$_event['event_start_date']|date_format:"%e"}</strong>
        <span class="text-[11px] font-semibold uppercase text-primary">{__($_event['event_start_date']|date_format:"%b")}</span>
      </time>
      {if $_promoted}
        <span class="badge badge-warning badge-sm absolute end-3 top-3 gap-1 rounded-full">
          <span class="icon-[tabler--speakerphone] size-3"></span>
          {__("Promoted")}
        </span>
      {/if}
      <span class="absolute {if $_promoted}start-3 bottom-3{else}end-3 top-3{/if} flex items-center gap-1 rounded-full bg-black/50 px-2 py-0.5 text-[11px] font-medium text-white backdrop-blur-sm">
        {if $_event['event_is_online']}<span class="icon-[tabler--broadcast] size-3.5" aria-hidden="true"></span>{__("Online Event")}{else}<span class="icon-[tabler--map-pin] size-3.5" aria-hidden="true"></span>{__("In Person")}{/if}
      </span>
    </a>
    <div class="flex grow flex-col gap-2 p-4">
      <h3 class="line-clamp-2 font-semibold leading-snug" title="{$_event['event_title']}"><a class="text-base-content! hover:text-primary!" href="{$system['system_url']}/events/{$_event['event_id']}{if $_search}?ref=qs{/if}">{$_event['event_title']}</a></h3>
      <div class="flex flex-col gap-1 text-xs text-base-content/60">
        <span class="flex items-center gap-1.5"><span class="icon-[tabler--clock] size-3.5 shrink-0" aria-hidden="true"></span><time datetime="{$_event['event_start_date']|date_format:"%Y-%m-%dT%H:%M"}">{__($_event['event_start_date']|date_format:"%a")}, {$_event['event_start_date']|date_format:"%I:%M %p"}</time></span>
        {if !$_event['event_is_online'] && $_event['event_location']}
          <span class="flex min-w-0 items-center gap-1.5"><span class="icon-[tabler--map-pin] size-3.5 shrink-0" aria-hidden="true"></span><span class="truncate" title="{$_event['event_location']}">{$_event['event_location']}</span></span>
        {/if}
      </div>
      <div class="mt-auto flex items-center justify-between gap-2 border-t border-base-300 pt-3 [&>.button]:shrink-0">
        <span class="text-xs text-base-content/60">{$_event['event_going']} {__("Going")} · {$_event['event_interested']} {__("Interested")}</span>
        {if $_event['i_joined']['is_interested']}
          {include file='__connection_button.tpl' _state="event_interested" _id=$_event['event_id']}
        {else}
          {include file='__connection_button.tpl' _state="event_interest" _id=$_event['event_id']}
        {/if}
      </div>
    </div>
  </li>
{elseif $_tpl == "list"}
  <li class="feeds-item flex items-center gap-3 rounded-2xl px-3 py-2.5 transition-colors hover:bg-base-200">
    <a class="shrink-0" href="{$system['system_url']}/events/{$_event['event_id']}{if $_search}?ref=qs{/if}">
      <img class="{if $_small}size-10{else}size-12{/if} rounded-full object-cover" src="{$_event['event_picture']}" alt="{$_event['event_title']}">
    </a>
    <div class="min-w-0 flex-1">
      <span class="name block min-w-0">
        <a class="block truncate text-sm font-semibold text-base-content! hover:text-primary!" href="{$system['system_url']}/events/{$_event['event_id']}{if $_search}?ref=qs{/if}" title="{$_event['event_title']}">{$_event['event_title']|truncate:30}</a>
      </span>
      <div class="text-sm text-base-content/60">{$_event['event_interested']} {__("Interested")}</div>
    </div>
    <div class="ms-auto flex shrink-0 flex-wrap items-center gap-2">
      {if $_event['i_joined']['is_interested']}
        {include file='__connection_button.tpl' _state="event_interested" _id=$_event['event_id']}
      {else}
        {include file='__connection_button.tpl' _state="event_interest" _id=$_event['event_id']}
      {/if}
    </div>
  </li>
{/if}
