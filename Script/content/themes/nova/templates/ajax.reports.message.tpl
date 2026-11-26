{if $node_type == "message"}
  {include file='__modal_header.tpl' _icon="icon-[tabler--message-report]" _title=__("Reported Message") _text=$conversation['name']}
{else}
  {include file='__modal_header.tpl' _icon="icon-[tabler--messages]" _title=__("Reported Conversation") _text=$conversation['name']}
{/if}
<div class="modal__body flex min-w-0 flex-col gap-4">
  <!-- report -->
  <div class="flex min-w-0 flex-col gap-3 rounded-2xl border border-base-300 bg-base-200/50 p-3">
    <div class="flex min-w-0 items-start gap-3">
      <a class="shrink-0" target="_blank" href="{$system['system_url']}/{$report['user_name']}">
        <img class="size-9 rounded-full border border-base-300 object-cover" src="{$report['user_picture']}" alt="" width="36" height="36" loading="lazy">
      </a>
      <div class="grid min-w-0 flex-1 gap-1">
        <div class="flex min-w-0 flex-wrap items-center gap-x-2 gap-y-1">
          <a class="truncate text-sm font-semibold" target="_blank" href="{$system['system_url']}/{$report['user_name']}" title="{$report['user_fullname']}">{$report['user_fullname']}</a>
          <span class="text-xs text-base-content/55">{$report['time']|date_format:"%e %B %Y %H:%M"}</span>
          {if $report['category_name']}
            <span class="badge badge-soft badge-warning badge-sm rounded-full">{__($report['category_name'])}</span>
          {/if}
        </div>
        {if $report['reason']}
          <p class="text-sm leading-relaxed break-words whitespace-pre-line text-base-content/80" dir="auto">{$report['reason']}</p>
        {else}
          <p class="text-sm text-base-content/50">{__("No reason provided")}</p>
        {/if}
      </div>
    </div>
    {if $reported_message}
      <!-- reported message -->
      <div class="flex min-w-0 flex-col gap-2 border-t border-base-300 pt-3">
        <div class="flex min-w-0 items-center gap-2">
          <a class="shrink-0" target="_blank" href="{$system['system_url']}/{$reported_message['user_name']}">
            <img class="size-6 rounded-full object-cover" src="{$reported_message['user_picture']}" alt="" width="24" height="24" loading="lazy">
          </a>
          <a class="truncate text-xs font-semibold" target="_blank" href="{$system['system_url']}/{$reported_message['user_name']}" title="{$reported_message['user_fullname']}">{$reported_message['user_fullname']}</a>
          <span class="shrink-0 text-[11px] text-base-content/50">{$reported_message['time']|date_format:"%e %B %Y %H:%M"}</span>
          <span class="badge badge-error badge-xs ms-auto shrink-0 gap-1 rounded-full"><span class="icon-[tabler--flag-filled] size-3" aria-hidden="true"></span>{__("Reported")}</span>
        </div>
        <div class="flex min-w-0 flex-col items-start gap-1 ps-8">
          {include file='__report_message.content.tpl' message=$reported_message _is_reporter=false}
        </div>
      </div>
      <!-- reported message -->
    {/if}
  </div>
  <!-- report -->

  <!-- conversation -->
  <div class="flex min-w-0 flex-col overflow-hidden rounded-2xl border border-base-300">
    <div class="flex min-w-0 items-center gap-3 border-b border-base-300 bg-base-100 px-3 py-2">
      <span class="text-sm font-semibold">{if $node_type == "message"}{__("Conversation Context")}{else}{__("Latest Messages")}{/if}</span>
      {if $conversation['participants']}
        <div class="ms-auto flex min-w-0 items-center gap-2">
          <div class="flex shrink-0 -space-x-2 rtl:space-x-reverse">
            {foreach $conversation['participants'] as $participant}
              {if $participant@iteration <= 5}
                <a class="block" target="_blank" href="{$system['system_url']}/{$participant['user_name']}" title="{$participant['user_fullname']}">
                  <img class="size-7 rounded-full object-cover ring-2 ring-base-100" src="{$participant['user_picture']}" alt="{$participant['user_fullname']}" width="28" height="28" loading="lazy">
                </a>
              {/if}
            {/foreach}
          </div>
          <span class="shrink-0 text-xs text-base-content/60">{$conversation['participants']|count} {__("Members")}</span>
        </div>
      {/if}
    </div>
    {if $messages}
      <div class="flex min-h-40 flex-col-reverse overflow-y-auto overscroll-contain bg-base-200/40 {if $node_type == "message"}max-h-[min(26rem,45dvh)]{else}max-h-[min(34rem,60dvh)]{/if}">
        <ul class="m-0 flex list-none flex-col p-3 sm:p-4">
          {assign var="_prev_day" value=""}
          {assign var="_prev_user" value=""}
          {foreach $messages as $message}
            {assign var="_day" value=$message['time']|date_format:"%Y-%m-%d"}
            {assign var="_is_reporter" value=($message['user_id'] == $report['user_id'])}
            {assign var="_is_reported" value=($highlighted_id && $message['message_id'] == $highlighted_id)}
            {assign var="_is_first" value=($_day != $_prev_day || $message['user_id'] != $_prev_user)}
            {if $_day != $_prev_day}
              <!-- day -->
              <li class="flex items-center gap-3 py-3 first:pt-0">
                <span class="h-px flex-1 bg-base-300"></span>
                <span class="text-[11px] font-medium text-base-content/55">{$message['time']|date_format:"%e %B %Y"}</span>
                <span class="h-px flex-1 bg-base-300"></span>
              </li>
              <!-- day -->
            {/if}
            <li class="flex min-w-0 items-end gap-2 {if $_day != $_prev_day}mt-0{elseif $_is_first}mt-3{else}mt-1{/if} {if $_is_reporter}flex-row-reverse{/if}">
              {if !$_is_reporter}
                <span class="w-8 shrink-0">
                  {if $_is_first}
                    <a class="block" target="_blank" href="{$system['system_url']}/{$message['user_name']}">
                      <img class="size-8 rounded-full object-cover" src="{$message['user_picture']}" alt="" width="32" height="32" loading="lazy">
                    </a>
                  {/if}
                </span>
              {/if}
              <div class="flex min-w-0 max-w-[80%] flex-col gap-1 {if $_is_reporter}items-end{else}items-start{/if}">
                {if $_is_first || $_is_reported}
                  <div class="flex min-w-0 max-w-full items-center gap-1.5 px-1 {if $_is_reporter}flex-row-reverse{/if}">
                    <a class="truncate text-xs font-semibold text-base-content/70" target="_blank" href="{$system['system_url']}/{$message['user_name']}" title="{$message['user_fullname']}">{$message['user_fullname']}</a>
                    {if $_is_reporter}
                      <span class="badge badge-soft badge-xs shrink-0 rounded-full">{__("Reporter")}</span>
                    {/if}
                    {if $_is_reported}
                      <span class="badge badge-error badge-xs shrink-0 gap-1 rounded-full"><span class="icon-[tabler--flag-filled] size-3" aria-hidden="true"></span>{__("Reported")}</span>
                    {/if}
                  </div>
                {/if}
                {if $message['reply']}
                  <div class="flex min-w-0 max-w-64 items-stretch gap-2 rounded-xl bg-base-100/70 px-2 py-1.5">
                    <span class="w-0.5 shrink-0 rounded-full bg-primary" aria-hidden="true"></span>
                    <span class="min-w-0">
                      {if $message['reply']['user_fullname']}
                        <span class="block truncate text-[11px] font-semibold text-primary" title="{$message['reply']['user_fullname']}">{$message['reply']['user_fullname']}</span>
                      {/if}
                      <span class="block truncate text-xs text-base-content/60" title="{$message['reply']['snippet']|escape:'html'}">{$message['reply']['snippet']|escape:'html'}</span>
                    </span>
                  </div>
                {/if}
                <div class="flex min-w-0 max-w-full flex-col gap-1 {if $_is_reporter}items-end{else}items-start{/if} {if $_is_reported}rounded-[1.25rem] p-1 ring-2 ring-error/60{/if}">
                  {include file='__report_message.content.tpl' _is_reporter=$_is_reporter}
                </div>
                <div class="flex items-center gap-2 px-1 text-[11px] leading-4 text-base-content/45">
                  <span title="{$message['time']|date_format:"%e %B %Y %H:%M"}">{$message['time']|date_format:"%H:%M"}</span>
                  {if $message['is_paid'] == '1'}
                    <span class="badge badge-soft badge-warning h-5 gap-1 rounded-full px-1.5 text-[10px] font-semibold">
                      <span class="icon-[tabler--coin] size-3" aria-hidden="true"></span>{print_money($message['message_price'])}
                    </span>
                  {/if}
                </div>
              </div>
            </li>
            {assign var="_prev_day" value=$_day}
            {assign var="_prev_user" value=$message['user_id']}
          {/foreach}
        </ul>
      </div>
    {else}
      <div class="flex min-h-40 flex-col items-center justify-center gap-2 bg-base-200/40 p-6 text-center">
        <span class="icon-[tabler--message-off] size-8 text-base-content/40" aria-hidden="true"></span>
        <p class="text-sm text-base-content/60">{__("No messages")}</p>
      </div>
    {/if}
  </div>
  <!-- conversation -->
</div>
