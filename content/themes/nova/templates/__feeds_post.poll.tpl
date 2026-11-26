<div class="mb-5 flex flex-wrap items-center gap-x-1.5 text-sm text-base-content/60" role="status">
  <span class="poll-votes-count">{$poll['votes']|number_format} {__("Votes")}</span>
  <span aria-hidden="true">·</span>
  <span>{__("Select an option")}</span>
</div>
<div class="space-y-3" role="group" aria-label="{__("Poll")}">
  {foreach $poll['options'] as $option}
    <div class="relative">
      <button type="button" class="poll-option js_poll-vote relative flex min-h-14 w-full cursor-pointer items-center gap-2 overflow-hidden rounded-[1.75rem] corner-squircle border py-3 ps-4 pe-3 text-start transition-colors duration-300 ease-out motion-reduce:transition-none focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary disabled:cursor-wait sm:ps-5 sm:pe-4 {if $option['checked']}border-success bg-success/5{else}border-base-content/5 bg-base-200/40 hover:border-primary/40{/if}" data-id="{$option['option_id']}" data-option-votes="{$option['votes']}" aria-pressed="{if $option['checked']}true{else}false{/if}">
        <span class="percentage-bg pointer-events-none absolute inset-y-0 start-0 rounded-[calc(1.75rem-1px)] corner-squircle transition-[width,min-width,background-color] duration-300 ease-out motion-reduce:transition-none {if $option['percentage'] > 0}min-w-[3.375rem]{else}min-w-0{/if} {if $option['checked']}bg-success/15{elseif $option['votes'] > 0 && $option['votes'] == $poll['leading_votes']}bg-primary/25{else}bg-base-content/5{/if}" style="width: {$option['percentage']}%" aria-hidden="true"></span>
        <span class="relative flex min-w-0 flex-1 items-center">
          <span class="poll-check icon-[tabler--check] h-4 shrink-0 text-success transition-[width,margin-inline-end,opacity,scale] duration-300 ease-out motion-reduce:transition-none sm:h-5 {if $option['checked']}me-2 w-4 scale-100 opacity-100 sm:w-5{else}me-0 w-0 scale-75 opacity-0{/if}" aria-hidden="true"></span>
          <span class="poll-label min-w-0 text-sm wrap-anywhere sm:text-base {if $option['checked']}font-semibold{else}font-medium{/if}" dir="auto">{$option['text']}</span>
        </span>
        <span class="poll-voters-space shrink-0 transition-[width,margin-inline-start] duration-300 ease-out motion-reduce:transition-none {if $option['voters']}ms-0 w-12 sm:w-20{else}-ms-2 w-0{/if}" aria-hidden="true"></span>
        <span class="poll-percentage relative w-10 shrink-0 text-end text-sm tabular-nums sm:w-11 sm:text-base">{$option['percentage']|number_format:0}%</span>
      </button>
      {if $option['voters']}
        <div class="poll-voters absolute end-14 top-1/2 -translate-y-1/2 sm:end-17">
          <button type="button" class="js_modal flex cursor-pointer items-center rounded-full focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary disabled:cursor-wait" data-url="posts/who_votes.php?option_id={$option['option_id']}" aria-label="{__("Votes")}: {$option['votes']}" title="{__("Votes")}: {$option['votes']}">
            <span class="avatar-group -space-x-3 rtl:space-x-reverse sm:-space-x-2">
              {foreach $option['voters'] as $voter}
                <span class="avatar size-6 sm:size-8">
                  <span class="size-full rounded-full">
                    <img src="{$voter['picture']|escape}" alt="{$voter['name']|escape}" loading="lazy" class="size-full rounded-full object-cover">
                  </span>
                </span>
              {/foreach}
            </span>
          </button>
        </div>
      {/if}
    </div>
  {/foreach}
</div>
