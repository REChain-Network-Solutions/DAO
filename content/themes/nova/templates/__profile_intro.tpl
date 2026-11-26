<div class="min-w-0 space-y-5">
  <!-- panel [merits] -->
  {if $view == "" && $system['merits_enabled'] && $system['merits_widgets_statistics'] && $profile['user_id'] == $user->_data['user_id']}
    {include file='__merits_balance.tpl'}
  {/if}
  <!-- panel [merits] -->

  <!-- photos -->
  {if $profile['photos']}
    <section class="card overflow-hidden rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-[#F9F9F9] shadow-none dark:bg-base-300">
      {include file='__card_header.tpl' _card_title=__("Photos") _card_url="`$system['system_url']`/`$profile['user_name']`/photos" _card_label=__("See All")}
      <div class="card-body gap-4 rounded-t-3xl corner-squircle supports-[corner-shape:squircle]:rounded-t-[2.5rem] bg-base-100 p-4">
        <ul class="grid grid-cols-3 gap-0.5 overflow-hidden rounded-box">
          {foreach $profile['photos'] as $photo}
            {include file='__profile_media.tpl' _kind='photo' _context="photos" _small=true}
          {/foreach}
        </ul>
      </div>
    </section>
  {/if}
  <!-- photos -->

  <!-- friends -->
  {if $profile['friends_count'] > 0 && $profile['friends']}
    <section class="card hidden overflow-hidden rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-[#F9F9F9] shadow-none dark:bg-base-300 lg:flex">
      {include file='__card_header.tpl' _card_title=__("Friends") _card_url="`$system['system_url']`/`$profile['user_name']`/friends" _card_label=__("See All")}
      <div class="card-body gap-4 rounded-t-3xl corner-squircle supports-[corner-shape:squircle]:rounded-t-[2.5rem] bg-base-100 p-4">
        <div class="grid grid-cols-3 gap-2">
          {foreach $profile['friends'] as $_friend}
            <a class="group flex min-w-0 flex-col rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-3xl bg-[#F9F9F9] p-1.5 text-center text-base-content! transition-colors hover:bg-base-200 hover:text-primary! dark:bg-base-200 dark:hover:bg-base-300" href="{$system['system_url']}/{$_friend['user_name']}">
              <span class="block overflow-hidden rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-2xl"><img class="aspect-square w-full object-cover transition-transform duration-300 group-hover:scale-105" src="{$_friend['user_picture']}" alt="" loading="lazy" /></span>
              <span class="w-full truncate px-0.5 pt-2 pb-1 text-xs font-medium" title="{if $system['show_usernames_enabled']}{$_friend['user_name']}{else}{$_friend['user_firstname']} {$_friend['user_lastname']}{/if}">
                {if $system['show_usernames_enabled']}{$_friend['user_name']}{else}{$_friend['user_firstname']} {$_friend['user_lastname']}{/if}
              </span>
            </a>
          {/foreach}
        </div>
      </div>
    </section>
  {/if}
  <!-- friends -->

  <!-- subscribers -->
  {if $profile['subscribers_count'] > 0}
    <section class="card hidden overflow-hidden rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-[#F9F9F9] shadow-none dark:bg-base-300 lg:flex">
      {capture assign="_panel_label"}{__("See All")}{/capture}
      {include file='__card_header.tpl' _card_title=__("Subscribers") _card_url="`$system['system_url']`/`$profile['user_name']`/subscribers" _card_label=$_panel_label}
      <div class="card-body gap-4 rounded-t-3xl corner-squircle supports-[corner-shape:squircle]:rounded-t-[2.5rem] bg-base-100 p-4">
        <div class="grid grid-cols-3 gap-2">
          {foreach $profile['subscribers'] as $_subscriber}
            <a class="group flex min-w-0 flex-col rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-3xl bg-[#F9F9F9] p-1.5 text-center text-base-content! transition-colors hover:bg-base-200 hover:text-primary! dark:bg-base-200 dark:hover:bg-base-300" href="{$system['system_url']}/{$_subscriber['user_name']}">
              <span class="block overflow-hidden rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-2xl"><img class="aspect-square w-full object-cover transition-transform duration-300 group-hover:scale-105" src="{$_subscriber['user_picture']}" alt="" loading="lazy" /></span>
              <span class="w-full truncate px-0.5 pt-2 pb-1 text-xs font-medium" title="{if $system['show_usernames_enabled']}{$_subscriber['user_name']}{else}{$_subscriber['user_firstname']} {$_subscriber['user_lastname']}{/if}">
                {if $system['show_usernames_enabled']}{$_subscriber['user_name']}{else}{$_subscriber['user_firstname']} {$_subscriber['user_lastname']}{/if}
              </span>
            </a>
          {/foreach}
        </div>
      </div>
    </section>
  {/if}
  <!-- subscribers -->

  <!-- pages -->
  {if $system['pages_enabled'] && count($profile['pages']) > 0}
    <section class="card hidden overflow-hidden rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-[#F9F9F9] shadow-none dark:bg-base-300 lg:flex">
      {include file='__card_header.tpl' _card_title=__("Pages") _card_url="`$system['system_url']`/`$profile['user_name']`/pages" _card_label=__("See All")}
      <div class="card-body gap-4 rounded-t-3xl corner-squircle supports-[corner-shape:squircle]:rounded-t-[2.5rem] bg-base-100 p-4">
        <div class="grid grid-cols-3 gap-2">
          {foreach $profile['pages'] as $_page}
            <a class="group flex min-w-0 flex-col rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-3xl bg-[#F9F9F9] p-1.5 text-center text-base-content! transition-colors hover:bg-base-200 hover:text-primary! dark:bg-base-200 dark:hover:bg-base-300" href="{$system['system_url']}/pages/{$_page['page_name']}">
              <span class="block overflow-hidden rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-2xl"><img class="aspect-square w-full object-cover transition-transform duration-300 group-hover:scale-105" src="{$_page['page_picture']}" alt="{$_page['page_title']}" loading="lazy" /></span>
              <span class="w-full truncate px-0.5 pt-2 pb-1 text-xs font-medium" title="{$_page['page_title']}">{$_page['page_title']}</span>
            </a>
          {/foreach}
        </div>
      </div>
    </section>
  {/if}
  <!-- pages -->

  <!-- groups -->
  {if $system['groups_enabled'] && count($profile['groups']) > 0}
    <section class="card hidden overflow-hidden rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-[#F9F9F9] shadow-none dark:bg-base-300 lg:flex">
      {include file='__card_header.tpl' _card_title=__("Groups") _card_url="`$system['system_url']`/`$profile['user_name']`/groups" _card_label=__("See All")}
      <div class="card-body gap-4 rounded-t-3xl corner-squircle supports-[corner-shape:squircle]:rounded-t-[2.5rem] bg-base-100 p-4">
        <div class="grid grid-cols-3 gap-2">
          {foreach $profile['groups'] as $_group}
            <a class="group flex min-w-0 flex-col rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-3xl bg-[#F9F9F9] p-1.5 text-center text-base-content! transition-colors hover:bg-base-200 hover:text-primary! dark:bg-base-200 dark:hover:bg-base-300" href="{$system['system_url']}/groups/{$_group['group_name']}">
              <span class="block overflow-hidden rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-2xl"><img class="aspect-square w-full object-cover transition-transform duration-300 group-hover:scale-105" src="{$_group['group_picture']}" alt="{$_group['group_title']}" loading="lazy" /></span>
              <span class="w-full truncate px-0.5 pt-2 pb-1 text-xs font-medium" title="{$_group['group_title']}">{$_group['group_title']}</span>
            </a>
          {/foreach}
        </div>
      </div>
    </section>
  {/if}
  <!-- groups -->

  <!-- events -->
  {if $system['events_enabled'] && count($profile['events']) > 0}
    <section class="card hidden overflow-hidden rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-[#F9F9F9] shadow-none dark:bg-base-300 lg:flex">
      {include file='__card_header.tpl' _card_title=__("Events") _card_url="`$system['system_url']`/`$profile['user_name']`/events" _card_label=__("See All")}
      <div class="card-body gap-4 rounded-t-3xl corner-squircle supports-[corner-shape:squircle]:rounded-t-[2.5rem] bg-base-100 p-4">
        <div class="grid grid-cols-3 gap-2">
          {foreach $profile['events'] as $_event}
            <a class="group flex min-w-0 flex-col rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-3xl bg-[#F9F9F9] p-1.5 text-center text-base-content! transition-colors hover:bg-base-200 hover:text-primary! dark:bg-base-200 dark:hover:bg-base-300" href="{$system['system_url']}/events/{$_event['event_id']}">
              <span class="block overflow-hidden rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-2xl"><img class="aspect-square w-full object-cover transition-transform duration-300 group-hover:scale-105" src="{$_event['event_picture']}" alt="{$_event['event_title']}" loading="lazy" /></span>
              <span class="w-full truncate px-0.5 pt-2 pb-1 text-xs font-medium" title="{$_event['event_title']}">{$_event['event_title']}</span>
            </a>
          {/foreach}
        </div>
      </div>
    </section>
  {/if}
  <!-- events -->

  <!-- gifts transactions -->
  {if $system['gifts_enabled'] && $profile['gift_transactions']}
    <section class="card hidden overflow-hidden rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-[#F9F9F9] shadow-none dark:bg-base-300 lg:flex">
      {include file='__card_header.tpl' _card_title=__("Gifts")}
      <div class="card-body gap-4 rounded-t-3xl corner-squircle supports-[corner-shape:squircle]:rounded-t-[2.5rem] bg-base-100 p-4">
        <ul class="grid grid-cols-3 gap-2">
          {foreach $profile['gift_transactions'] as $gift_transaction}
            <li class="min-w-0">
              <a class="group flex h-full min-w-0 flex-col rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-3xl bg-[#F9F9F9] p-1.5 pb-2 text-center text-base-content! transition-colors hover:bg-base-200 hover:text-primary! dark:bg-base-200 dark:hover:bg-base-300" href="{$system['system_url']}/{$gift_transaction['user_name']}">
                <span class="relative block">
                  <span class="block overflow-hidden rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-2xl bg-base-100">
                    <img class="aspect-square w-full object-cover transition-transform duration-300 group-hover:scale-105" src="{$gift_transaction['image']}" alt="" loading="lazy" />
                  </span>
                  <img class="absolute start-1/2 -bottom-3 size-7 -translate-x-1/2 rounded-full object-cover ring-2 ring-base-100 rtl:translate-x-1/2" src="{$gift_transaction['user_picture']}" alt="" loading="lazy" />
                </span>
                <span class="mt-4 w-full truncate px-0.5 text-xs font-medium" title="{$gift_transaction['user_fullname']}">{$gift_transaction['user_fullname']}</span>
                {if $gift_transaction['points']}
                  <span class="mt-0.5 inline-flex items-center justify-center gap-1 text-[0.6875rem] font-medium text-base-content/60 tabular-nums">
                    <span class="icon-[tabler--coins] size-3.5 text-warning" aria-hidden="true"></span>
                    {$gift_transaction['points']} {__("Points")}
                  </span>
                {/if}
              </a>
            </li>
          {/foreach}
        </ul>
      </div>
    </section>
  {/if}
  <!-- gifts transactions -->

  <!-- mini footer -->
  <div class="hidden lg:block">
    {include file='_footer_mini.tpl'}
  </div>
  <!-- mini footer -->
</div>
