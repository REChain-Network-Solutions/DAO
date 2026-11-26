{include file='_head.tpl'}
{include file='_header.tpl'}

<!-- page content -->
<div class="pb-8 sm:pb-12">

  <!-- page heading -->
  {include file='__page_header.tpl' _title=__("Merits") _text=__("Celebrate the people who inspire our community") _image="merits.svg"}
  <!-- page heading -->

  <div class="mt-6 grid gap-6 lg:grid-cols-[minmax(0,1fr)_20rem] lg:items-start">

    <!-- ranking -->
    <div class="flex min-w-0 flex-col gap-6">

      <!-- filters -->
      <form class="rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] border border-base-300 bg-base-100 p-4 sm:p-5" method="get">
        <div class="grid gap-3 sm:grid-cols-2 xl:grid-cols-[minmax(0,1fr)_minmax(0,1fr)_minmax(0,1fr)_auto]">
          <div class="select w-full min-w-0">
            <span class="icon-[tabler--category] my-auto me-2 size-4 shrink-0 text-base-content/50" aria-hidden="true"></span>
            <select class="min-w-0 ps-0!" name="category" aria-label='{__("Category")}'>
              <option value="all">{__("All Categories")}</option>
              {foreach $merits_categories as $category}
                {include file='__categories.recursive_options.tpl' data_category=$config['category']}
              {/foreach}
            </select>
          </div>
          <label class="input w-full min-w-0">
            <span class="my-auto me-2 shrink-0 text-sm text-base-content/50">{__("From")}</span>
            <input type="date" class="grow" name="start_date" value="{$config['start_date']}" aria-label='{__("From")}'>
          </label>
          <label class="input w-full min-w-0">
            <span class="my-auto me-2 shrink-0 text-sm text-base-content/50">{__("To")}</span>
            <input type="date" class="grow" name="end_date" value="{$config['end_date']}" aria-label='{__("To")}'>
          </label>
          <div class="flex gap-2">
            <button type="submit" class="heroui button button--primary grow rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]">
              <span class="icon-[tabler--filter] size-4" aria-hidden="true"></span>{__("Filter")}
            </button>
            {if $config}
              <a class="heroui button button--tertiary button--icon-only size-10 rounded-field corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" href="{$system['system_url']}/merits" aria-label='{__("Reset")}' title='{__("Reset")}'>
                <span class="icon-[tabler--x] size-4" aria-hidden="true"></span>
              </a>
            {/if}
          </div>
        </div>
      </form>
      <!-- filters -->

      {if $merits_ranking_users}

        <!-- podium -->
        <div class="grid grid-cols-3 items-end gap-2 sm:gap-4">
          {foreach [2, 1, 3] as $_place}
            {if isset($merits_ranking_users[$_place - 1])}
              {$_ranked = $merits_ranking_users[$_place - 1]}
              {if $_place == 1}
                {$_podium_tone = 'from-amber-300/45 via-amber-100/30 to-base-100 dark:via-amber-300/10'}
                {$_podium_medal = 'from-amber-300 to-amber-500 text-amber-950'}
                {$_podium_ring = 'ring-amber-400'}
              {elseif $_place == 2}
                {$_podium_tone = 'from-slate-300/50 via-slate-100/30 to-base-100 dark:via-slate-300/10'}
                {$_podium_medal = 'from-slate-200 to-slate-400 text-slate-800'}
                {$_podium_ring = 'ring-slate-300'}
              {else}
                {$_podium_tone = 'from-orange-300/45 via-orange-100/30 to-base-100 dark:via-orange-300/10'}
                {$_podium_medal = 'from-orange-300 to-orange-600 text-white'}
                {$_podium_ring = 'ring-orange-400'}
              {/if}
              <a class="group relative flex min-w-0 flex-col items-center rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] border border-base-300 bg-linear-to-b {$_podium_tone} px-2 text-center text-base-content! transition-shadow hover:shadow-md sm:px-4 {if $_place == 1}pb-6 pt-8 sm:pb-8 sm:pt-10{else}pb-5 pt-6{/if}" href="{$system['system_url']}/{$_ranked['user_name']}">
                {if $_place == 1}
                  <span class="icon-[tabler--crown] absolute top-2 size-6 text-amber-500 sm:top-3 sm:size-7" aria-hidden="true"></span>
                {/if}
                <span class="relative mt-2">
                  <img class="{if $_place == 1}size-16 sm:size-24{else}size-14 sm:size-20{/if} rounded-full object-cover ring-4 {$_podium_ring} ring-offset-2 ring-offset-base-100" src="{$_ranked['user_picture']}" alt="" loading="lazy">
                  <span class="absolute -bottom-2 start-1/2 flex size-7 -translate-x-1/2 items-center justify-center rounded-full bg-linear-to-br {$_podium_medal} text-xs font-bold tabular-nums ring-2 ring-base-100 rtl:translate-x-1/2">{$_place}</span>
                </span>
                <span class="mt-4 flex min-w-0 max-w-full items-center justify-center gap-1">
                  <span class="truncate text-sm font-semibold group-hover:text-primary sm:text-base" title="{if $system['show_usernames_enabled']}{$_ranked['user_name']}{else}{$_ranked['user_firstname']} {$_ranked['user_lastname']}{/if}">{if $system['show_usernames_enabled']}{$_ranked['user_name']}{else}{$_ranked['user_firstname']} {$_ranked['user_lastname']}{/if}</span>
                  {if $_ranked['user_verified']}
                    {include file='__badge.tpl' _badge="verified" _badge_type="user" _badge_size=16 _badge_class="max-sm:hidden"}
                  {/if}
                </span>
                <span class="mt-2 inline-flex items-center gap-1 rounded-lg corner-squircle supports-[corner-shape:squircle]:rounded-xl bg-base-100/80 px-2 py-1 text-xs font-semibold tabular-nums shadow-xs">
                  <span class="icon-[tabler--award] size-3.5 text-primary" aria-hidden="true"></span>
                  {$_ranked['count']}
                  <span class="hidden font-normal text-base-content/60 sm:inline">{__("Merits")}</span>
                </span>
              </a>
            {else}
              <span></span>
            {/if}
          {/foreach}
        </div>
        <!-- podium -->

        {if $merits_ranking_users|count > 3}
          <!-- ranking list -->
          <ol class="flex flex-col gap-2 rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] border border-base-300 bg-base-100 p-2 sm:p-3">
            {foreach $merits_ranking_users as $_ranked}
              {if $_ranked@iteration > 3}
                <li>
                  <a class="group flex items-center gap-3 rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[1.75rem] px-3 py-2.5 text-base-content! transition-colors hover:bg-base-200" href="{$system['system_url']}/{$_ranked['user_name']}">
                    <span class="flex size-8 shrink-0 items-center justify-center rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-2xl bg-base-200 text-sm font-bold tabular-nums text-base-content/70 group-hover:bg-base-100">{$_ranked@iteration}</span>
                    <img class="size-11 shrink-0 rounded-full object-cover" src="{$_ranked['user_picture']}" alt="" loading="lazy">
                    <span class="flex min-w-0 grow items-center gap-1">
                      <span class="truncate font-semibold group-hover:text-primary" title="{if $system['show_usernames_enabled']}{$_ranked['user_name']}{else}{$_ranked['user_firstname']} {$_ranked['user_lastname']}{/if}">{if $system['show_usernames_enabled']}{$_ranked['user_name']}{else}{$_ranked['user_firstname']} {$_ranked['user_lastname']}{/if}</span>
                      {if $_ranked['user_verified']}
                        {include file='__badge.tpl' _badge="verified" _badge_type="user" _badge_size=16}
                      {/if}
                    </span>
                    <span class="flex shrink-0 items-center gap-1 rounded-lg corner-squircle supports-[corner-shape:squircle]:rounded-xl bg-primary/10 px-2.5 py-1 text-sm font-semibold text-primary tabular-nums">
                      <span class="icon-[tabler--award] size-4" aria-hidden="true"></span>
                      {$_ranked['count']}
                    </span>
                  </a>
                </li>
              {/if}
            {/foreach}
          </ol>
          <!-- ranking list -->
        {/if}

      {else}
        <div class="rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] border border-base-300 bg-base-100">
          {include file='_no_data.tpl' _empty_icon="icon-[tabler--trophy]" _empty_title=__("No merits yet") _empty_text=__("Be the first to appreciate someone who inspires you")}
        </div>
      {/if}

    </div>
    <!-- ranking -->

    <!-- aside -->
    <aside class="flex flex-col gap-6 lg:sticky lg:top-24">
      {if $system['merits_enabled']}
        {include file='__merits_balance.tpl'}
      {/if}

      <!-- merits cycle -->
      <div class="rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] border border-base-300 bg-base-100 p-5">
        <div class="flex items-center gap-3">
          <span class="flex size-10 shrink-0 items-center justify-center rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-2xl bg-base-200 text-base-content">
            <span class="icon-[tabler--calendar-repeat] size-5" aria-hidden="true"></span>
          </span>
          <h2 class="text-base font-semibold">{__("Current Cycle")}</h2>
        </div>
        <dl class="mt-4 flex flex-col gap-2 text-sm">
          <div class="flex items-center justify-between gap-3 rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-3xl bg-base-200 px-4 py-3">
            <dt class="text-base-content/60">{__("Started")}</dt>
            <dd class="font-semibold tabular-nums">{$merits_cycle['start_date']|date_format:"%b %e, %Y"}</dd>
          </div>
          <div class="flex items-center justify-between gap-3 rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-3xl bg-base-200 px-4 py-3">
            <dt class="text-base-content/60">{__("Resets")}</dt>
            <dd class="font-semibold tabular-nums">{$merits_cycle['end_date']|date_format:"%b %e, %Y"}</dd>
          </div>
        </dl>
      </div>
      <!-- merits cycle -->
    </aside>
    <!-- aside -->

  </div>
</div>
<!-- page content -->

{include file='_footer.tpl'}
