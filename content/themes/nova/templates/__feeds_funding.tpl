{assign var=_completion value=$funding['funding']['funding_completion']|default:0}
{if $_completion > 100}{assign var=_bar value=100}{elseif $_completion < 0}{assign var=_bar value=0}{else}{assign var=_bar value=$_completion}{/if}

<li class="group flex min-w-0 flex-col overflow-hidden rounded-box border border-base-300 bg-base-100 transition-shadow hover:shadow-md">
  {if $funding['needs_subscription']}
    <div class="grow">
      {include file='_need_subscription.tpl' _compact=true}
    </div>
  {else}
    <a class="relative block aspect-video overflow-hidden bg-base-200" href="{$system['system_url']}/posts/{$funding['post_id']}" aria-label="{$funding['funding']['title']}">
      <img class="size-full object-cover transition-transform duration-500 group-hover:scale-105" src="{$system['system_uploads']}/{$funding['funding']['cover_image']}" alt="" loading="lazy">
      {if $_boosted}
        <span class="badge badge-warning badge-sm absolute start-3 top-3 gap-1 rounded-full">
          <span class="icon-[tabler--speakerphone] size-3" aria-hidden="true"></span>
          {__("Promoted")}
        </span>
      {/if}
      <span class="absolute {if $_boosted}start-3 top-12{else}start-3 top-3{/if} rounded-full bg-base-100/95 px-2.5 py-1 text-xs font-bold text-success shadow-sm backdrop-blur-sm">{$_completion}%</span>
    </a>
    <div class="flex grow flex-col gap-4 p-5">
      {if $funding['funding']['category_id'] && $funding['funding']['category_name']}
        <a class="badge badge-soft badge-primary w-fit rounded-full hover:bg-primary/20" href="{$system['system_url']}/funding/category/{$funding['funding']['category_id']}/{$funding['funding']['category_url']}">{__($funding['funding']['category_name'])}</a>
      {/if}
      <a class="line-clamp-2 text-lg font-bold leading-snug tracking-tight text-base-content! hover:text-primary!" href="{$system['system_url']}/posts/{$funding['post_id']}" title="{$funding['funding']['title']}">{$funding['funding']['title']}</a>
      {if $funding['text']}
        <p class="line-clamp-2 text-sm leading-relaxed text-base-content/65" title="{$funding['text']|strip_tags}">
          {$funding['text']|strip_tags|truncate:140}
        </p>
      {/if}

      <!-- progress -->
      <div class="flex flex-col gap-2 rounded-xl bg-base-200/50 p-3">
        <div class="flex items-end justify-between gap-3">
          <div class="min-w-0">
            <div class="truncate text-lg font-bold" title="{print_money($funding['funding']['raised_amount'])}">{print_money($funding['funding']['raised_amount'])}</div>
            <div class="truncate text-xs text-base-content/60" title="{__("Raised of")} {print_money($funding['funding']['amount'])}">{__("Raised of")} {print_money($funding['funding']['amount'])}</div>
          </div>
          <span class="shrink-0 text-sm font-semibold text-success">{$_completion}%</span>
        </div>
        <div class="progress h-2 bg-base-300" role="progressbar" aria-valuenow="{$_bar}" aria-valuemin="0" aria-valuemax="100" aria-valuetext="{$_completion}%">
          <div class="progress-bar progress-success" style="width: {$_bar}%"></div>
        </div>
      </div>
      <!-- progress -->

      <div class="mt-auto flex min-w-0 items-center gap-3 border-t border-base-300 pt-3 text-xs text-base-content/60">
        <a class="flex min-w-0 grow items-center gap-2 text-base-content/80! hover:text-primary!" href="{$funding['post_author_url']}">
          <img class="size-8 shrink-0 rounded-full object-cover" src="{$funding['post_author_picture']}" alt="" loading="lazy">
          <span class="min-w-0">
            <span class="js_user-popover block truncate font-medium" data-type="{$funding['user_type']}" data-uid="{$funding['user_id']}" title="{$funding['post_author_name']}">{$funding['post_author_name']}</span>
            <span class="js_moment block truncate text-base-content/50" data-time="{$funding['time']}">{$funding['time']}</span>
          </span>
        </a>
        {if $funding['funding']['total_donations']}
          <span class="flex shrink-0 items-center gap-1">
            <span class="icon-[tabler--heart-handshake] size-3.5" aria-hidden="true"></span>
            {$funding['funding']['total_donations']} {__("Donations")}
          </span>
        {/if}
      </div>
    </div>
  {/if}
</li>
