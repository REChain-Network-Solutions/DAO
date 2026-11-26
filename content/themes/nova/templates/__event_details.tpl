<!-- event details -->
<div class="space-y-5">
  {include file='_ads.tpl'}
  <section class="js_translate-wrapper card overflow-hidden rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-[#F9F9F9] shadow-none dark:bg-base-300" aria-labelledby="event-about-title">
    <div class="flex items-center gap-3 px-5 py-3.5">
      <h2 id="event-about-title" class="min-w-0 grow truncate text-sm font-semibold">{__("About")}</h2>
      {if $system['post_translation_enabled'] && !is_empty($event['event_description'])}<button type="button" class="js_translator js_translator-description inline-flex size-6 shrink-0 cursor-pointer items-center justify-center rounded-full text-base-content/55 transition-colors hover:bg-base-200 hover:text-primary focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary" data-node-type="event" data-node-id="{$event['event_id']}" data-source=".event-description-text" data-translation=".post-text-translation" title="{__("Translate")}" aria-label="{__("Translate")}"><span class="icon-[tabler--language] size-4" aria-hidden="true"></span></button>{/if}
    </div>
    <div class="card-body gap-4 rounded-t-3xl corner-squircle supports-[corner-shape:squircle]:rounded-t-[2.5rem] bg-base-100 p-5">
    {if !is_empty($event['event_description'])}<div class="text-sm leading-relaxed text-base-content/75"><div class="js_readmore event-description-text" data-lines="4" dir="auto">{$event['event_description']|nl2br}</div><div class="post-text-translation mt-2 hidden border-s-2 border-base-300 ps-3 text-start" dir="auto"></div></div>{/if}
    <ul class="space-y-3.5 text-sm leading-relaxed break-words [&_a]:text-primary [&_a]:hover:underline{if !is_empty($event['event_description'])} border-t border-base-300 pt-4{/if}">
      {if $event['event_privacy'] == 'public'}
        <li class="flex items-start gap-3"><span class="icon-[tabler--world] mt-0.5 size-5 shrink-0 text-base-content/50" aria-hidden="true"></span><div class="min-w-0">{__("Public Event")}</div></li>
      {elseif $event['event_privacy'] == 'closed'}
        <li class="flex items-start gap-3"><span class="icon-[tabler--lock-open] mt-0.5 size-5 shrink-0 text-base-content/50" aria-hidden="true"></span><div class="min-w-0">{__("Closed Event")}</div></li>
      {else}
        <li class="flex items-start gap-3"><span class="icon-[tabler--lock] mt-0.5 size-5 shrink-0 text-base-content/50" aria-hidden="true"></span><div class="min-w-0">{__("Secret Event")}</div></li>
      {/if}
      <li class="flex items-start gap-3"><span class="icon-[tabler--tag] mt-0.5 size-5 shrink-0 text-base-content/50" aria-hidden="true"></span><div class="min-w-0">{__($event['event_category_name'])}</div></li>
      <li class="flex items-start gap-3"><span class="icon-[tabler--calendar-event] mt-0.5 size-5 shrink-0 text-base-content/50" aria-hidden="true"></span><div class="min-w-0"><span class="font-medium"><time datetime="{$event['event_start_date']|date_format:"%Y-%m-%dT%H:%M"}">{$event['event_start_date']|date_format:"%e"} {__($event['event_start_date']|date_format:"%b")} {$event['event_start_date']|date_format:"%I:%M %p"}</time></span><span class="block text-xs text-base-content/60">{__("to")} <time datetime="{$event['event_end_date']|date_format:"%Y-%m-%dT%H:%M"}">{$event['event_end_date']|date_format:"%e"} {__($event['event_end_date']|date_format:"%b")} {$event['event_end_date']|date_format:"%I:%M %p"}</time></span></div></li>
      <li class="flex items-start gap-3"><span class="icon-[tabler--user-star] mt-0.5 size-5 shrink-0 text-base-content/50" aria-hidden="true"></span><div class="min-w-0">{__("Hosted By")} {if $event['event_is_sponsored']}<a class="font-medium" target="_blank" rel="nofollow noopener" href="{$event['event_sponsor_url']}">{$event['event_sponsor_name']}</a>{else}<a class="font-medium" href="{$event['host_url']}">{$event['host_name']}</a>{/if}</div></li>
      {if $event['event_is_online']}
        <li class="flex items-start gap-3"><span class="icon-[tabler--broadcast] mt-0.5 size-5 shrink-0 text-base-content/50" aria-hidden="true"></span><div class="min-w-0">{__("Online Event")}</div></li>
      {else}
        <li class="flex items-start gap-3"><span class="icon-[tabler--map-pin] mt-0.5 size-5 shrink-0 text-base-content/50" aria-hidden="true"></span><div class="min-w-0">{if $event['event_location']}{$event['event_location']}{else}{__("In Person")}{/if}{if $event['distance']}<span class="block text-xs text-base-content/60">{$event['distance']}</span>{/if}</div></li>
      {/if}
      <li class="flex items-start gap-3"><span class="icon-[tabler--users] mt-0.5 size-5 shrink-0 text-base-content/50" aria-hidden="true"></span><div class="min-w-0"><a href="{$system['system_url']}/events/{$event['event_id']}/going"><span class="font-medium tabular-nums">{$event['event_going']}</span> {__("Going")}</a> · <a href="{$system['system_url']}/events/{$event['event_id']}/interested"><span class="font-medium tabular-nums">{$event['event_interested']}</span> {__("Interested")}</a> · <a href="{$system['system_url']}/events/{$event['event_id']}/invited"><span class="font-medium tabular-nums">{$event['event_invited']}</span> {__("Invited")}</a></div></li>
      <li class="flex items-start gap-3"><span class="icon-[tabler--news] mt-0.5 size-5 shrink-0 text-base-content/50" aria-hidden="true"></span><div class="min-w-0"><span class="font-medium tabular-nums">{$event['posts_count']}</span> {__("Posts")}</div></li>
      <li class="flex items-start gap-3"><span class="icon-[tabler--photo] mt-0.5 size-5 shrink-0 text-base-content/50" aria-hidden="true"></span><div class="min-w-0"><span class="font-medium tabular-nums">{$event['photos_count']}</span> {__("Photos")}</div></li>
      {if $system['videos_enabled'] || $system['reels_enabled']}
        <li class="flex items-start gap-3"><span class="icon-[tabler--video] mt-0.5 size-5 shrink-0 text-base-content/50" aria-hidden="true"></span><div class="min-w-0"><span class="font-medium tabular-nums">{$event['videos_count'] + $event['reels_count']}</span> {if $system['videos_enabled']}{__("Videos")}{/if}{if $system['videos_enabled'] && $system['reels_enabled']}/{/if}{if $system['reels_enabled']}{__("Reels")}{/if}</div></li>
      {/if}
      {if $system['events_reviews_enabled']}
        <li class="flex items-start gap-3"><span class="icon-[tabler--star] mt-0.5 size-5 shrink-0 text-base-content/50" aria-hidden="true"></span><div class="min-w-0"><a href="{$system['system_url']}/events/{$event['event_id']}/reviews"><span class="font-medium tabular-nums">{$event['reviews_count']}</span> {__("Reviews")}{if $event['event_rate']} · {$event['event_rate']|number_format:1} ★{/if}</a></div></li>
      {/if}
      {if $event['event_date']}
        <li class="flex items-start gap-3"><span class="icon-[tabler--calendar-plus] mt-0.5 size-5 shrink-0 text-base-content/50" aria-hidden="true"></span><div class="min-w-0">{__("Created")} <span class="font-medium">{__($event['event_date']|date_format:"%B")} {$event['event_date']|date_format:"%e"|trim}, {$event['event_date']|date_format:"%Y"}</span></div></li>
      {/if}
    </ul>
    {if !$event['event_is_online'] && $event['event_location'] && $system['geolocation_enabled']}{include file='__map.tpl' location=$event['event_location'] latitude=$event['event_latitude'] longitude=$event['event_longitude'] _title=__("Event location") _class="overflow-hidden rounded-2xl" _frame_class="block aspect-video w-full border-0" _no_link=true}{/if}
    </div>
  </section>
  {if $event['event_tickets_link'] || $event['event_prices']}<section class="card overflow-hidden rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-[#F9F9F9] shadow-none dark:bg-base-300">{include file='__card_header.tpl' _card_title=__("Tickets")}<div class="card-body gap-4 rounded-t-3xl corner-squircle supports-[corner-shape:squircle]:rounded-t-[2.5rem] bg-base-100 p-4">{if $event['event_prices']}<p class="break-words text-sm text-base-content/70" dir="auto">{$event['event_prices']|nl2br}</p>{/if}{if $event['event_tickets_link']}<a class="heroui button button--primary mt-4 w-full rounded-[1rem]" href="{$event['event_tickets_link']}" target="_blank" rel="nofollow noopener"><span class="icon-[tabler--ticket] size-5" aria-hidden="true"></span>{__("Tickets Link")}</a>{/if}</div></section>{/if}
  {if $custom_fields['basic']}<section class="card overflow-hidden rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-[#F9F9F9] shadow-none dark:bg-base-300">{include file='__card_header.tpl' _card_title=__("Info")}<div class="card-body gap-4 rounded-t-3xl corner-squircle supports-[corner-shape:squircle]:rounded-t-[2.5rem] bg-base-100 p-4"><dl class="grid gap-4 text-sm">{foreach $custom_fields['basic'] as $custom_field}{if $custom_field['value']}<div><dt class="text-base-content/60">{__($custom_field['label'])}</dt><dd class="mt-1 break-words font-medium">{if $custom_field['type'] == 'textbox' && $custom_field['is_link']}<a href="{$custom_field['value']}" class="link link-primary" target="_blank" rel="nofollow noopener">{__($custom_field['value']|trim)}</a>{elseif $custom_field['type'] == 'multipleselectbox'}{__($custom_field['value_string']|trim)}{else}{__($custom_field['value']|trim)}{/if}</dd></div>{/if}{/foreach}</dl></div></section>{/if}
  {if !empty($event['photos'])}<section class="card overflow-hidden rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-[#F9F9F9] shadow-none dark:bg-base-300">{include file='__card_header.tpl' _card_title=__("Photos") _card_url="`$system['system_url']`/events/`$event['event_id']`/photos" _card_label=__("See All")}<div class="card-body gap-4 rounded-t-3xl corner-squircle supports-[corner-shape:squircle]:rounded-t-[2.5rem] bg-base-100 p-4"><ul class="grid grid-cols-3 gap-0.5 overflow-hidden rounded-box">{foreach $event['photos'] as $photo}{include file='__profile_media.tpl' _kind='photo' _context='photos' _small=true}{/foreach}</ul></div></section>{/if}
  <!-- mini footer -->
  <div class="hidden lg:block">
    {include file='_footer_mini.tpl'}
  </div>
  <!-- mini footer -->
</div>
<!-- event details -->
