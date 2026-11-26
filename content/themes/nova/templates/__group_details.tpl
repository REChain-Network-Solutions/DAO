<!-- group details -->
<div class="space-y-5">
  {include file='_ads.tpl'}
  <section class="js_translate-wrapper card overflow-hidden rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-[#F9F9F9] shadow-none dark:bg-base-300" aria-labelledby="group-about-title">
    <div class="flex items-center gap-3 px-5 py-3.5">
      <h2 id="group-about-title" class="min-w-0 grow truncate text-sm font-semibold">{__("About")}</h2>
      {if $system['post_translation_enabled'] && !is_empty($group['group_description'])}<button type="button" class="js_translator js_translator-description inline-flex size-6 shrink-0 cursor-pointer items-center justify-center rounded-full text-base-content/55 transition-colors hover:bg-base-200 hover:text-primary focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary" data-node-type="group" data-node-id="{$group['group_id']}" data-source=".group-description-text" data-translation=".post-text-translation" title="{__("Translate")}" aria-label="{__("Translate")}"><span class="icon-[tabler--language] size-4" aria-hidden="true"></span></button>{/if}
    </div>
    <div class="card-body gap-4 rounded-t-3xl corner-squircle supports-[corner-shape:squircle]:rounded-t-[2.5rem] bg-base-100 p-5">
    {if !is_empty($group['group_description'])}<div class="text-sm leading-relaxed text-base-content/75"><div class="js_readmore group-description-text" data-lines="4" dir="auto">{$group['group_description']|nl2br}</div><div class="post-text-translation mt-2 hidden border-s-2 border-base-300 ps-3 text-start" dir="auto"></div></div>{/if}
    <ul class="space-y-3.5 text-sm leading-relaxed break-words [&_a]:text-primary [&_a]:hover:underline{if !is_empty($group['group_description'])} border-t border-base-300 pt-4{/if}">
      {if $group['group_privacy'] == 'public'}
        <li class="flex items-start gap-3"><span class="icon-[tabler--world] mt-0.5 size-5 shrink-0 text-base-content/50" aria-hidden="true"></span><div class="min-w-0">{__("Public Group")}</div></li>
      {elseif $group['group_privacy'] == 'closed'}
        <li class="flex items-start gap-3"><span class="icon-[tabler--lock-open] mt-0.5 size-5 shrink-0 text-base-content/50" aria-hidden="true"></span><div class="min-w-0">{__("Closed Group")}</div></li>
      {else}
        <li class="flex items-start gap-3"><span class="icon-[tabler--lock] mt-0.5 size-5 shrink-0 text-base-content/50" aria-hidden="true"></span><div class="min-w-0">{__("Secret Group")}</div></li>
      {/if}
      <li class="flex items-start gap-3"><span class="icon-[tabler--tag] mt-0.5 size-5 shrink-0 text-base-content/50" aria-hidden="true"></span><div class="min-w-0">{__($group['group_category_name'])}</div></li>
      <li class="flex items-start gap-3"><span class="icon-[tabler--users] mt-0.5 size-5 shrink-0 text-base-content/50" aria-hidden="true"></span><div class="min-w-0"><a href="{$system['system_url']}/groups/{$group['group_name']}/members"><span class="font-medium tabular-nums">{$group['group_members']}</span> {__("Members")}</a></div></li>
      <li class="flex items-start gap-3"><span class="icon-[tabler--news] mt-0.5 size-5 shrink-0 text-base-content/50" aria-hidden="true"></span><div class="min-w-0"><span class="font-medium tabular-nums">{$group['posts_count']}</span> {__("Posts")}</div></li>
      <li class="flex items-start gap-3"><span class="icon-[tabler--photo] mt-0.5 size-5 shrink-0 text-base-content/50" aria-hidden="true"></span><div class="min-w-0"><span class="font-medium tabular-nums">{$group['photos_count']}</span> {__("Photos")}</div></li>
      {if $system['videos_enabled'] || $system['reels_enabled']}
        <li class="flex items-start gap-3"><span class="icon-[tabler--video] mt-0.5 size-5 shrink-0 text-base-content/50" aria-hidden="true"></span><div class="min-w-0"><span class="font-medium tabular-nums">{$group['videos_count'] + $group['reels_count']}</span> {if $system['videos_enabled']}{__("Videos")}{/if}{if $system['videos_enabled'] && $system['reels_enabled']}/{/if}{if $system['reels_enabled']}{__("Reels")}{/if}</div></li>
      {/if}
      {if $system['groups_reviews_enabled']}
        <li class="flex items-start gap-3"><span class="icon-[tabler--star] mt-0.5 size-5 shrink-0 text-base-content/50" aria-hidden="true"></span><div class="min-w-0"><span class="font-medium tabular-nums">{$group['reviews_count']}</span> {__("Reviews")}</div></li>
      {/if}
      {if $group['group_date']}
        <li class="flex items-start gap-3"><span class="icon-[tabler--calendar-plus] mt-0.5 size-5 shrink-0 text-base-content/50" aria-hidden="true"></span><div class="min-w-0">{__("Created")} <span class="font-medium">{__($group['group_date']|date_format:"%B")} {$group['group_date']|date_format:"%e"|trim}, {$group['group_date']|date_format:"%Y"}</span></div></li>
      {/if}
    </ul>
    </div>
  </section>
  {if $custom_fields['basic']}<section class="card overflow-hidden rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-[#F9F9F9] shadow-none dark:bg-base-300">{include file='__card_header.tpl' _card_title=__("Info")}<div class="card-body gap-4 rounded-t-3xl corner-squircle supports-[corner-shape:squircle]:rounded-t-[2.5rem] bg-base-100 p-4"><dl class="grid gap-4 text-sm">{foreach $custom_fields['basic'] as $custom_field}{if $custom_field['value']}<div><dt class="text-base-content/60">{__($custom_field['label'])}</dt><dd class="mt-1 break-words font-medium">{if $custom_field['type'] == 'textbox' && $custom_field['is_link']}<a href="{$custom_field['value']}" class="link link-primary" target="_blank" rel="nofollow noopener">{__($custom_field['value']|trim)}</a>{elseif $custom_field['type'] == 'multipleselectbox'}{__($custom_field['value_string']|trim)}{else}{__($custom_field['value']|trim)}{/if}</dd></div>{/if}{/foreach}</dl></div></section>{/if}
  {if !empty($group['photos'])}<section class="card overflow-hidden rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-[#F9F9F9] shadow-none dark:bg-base-300">{include file='__card_header.tpl' _card_title=__("Photos") _card_url="`$system['system_url']`/groups/`$group['group_name']`/photos" _card_label=__("See All")}<div class="card-body gap-4 rounded-t-3xl corner-squircle supports-[corner-shape:squircle]:rounded-t-[2.5rem] bg-base-100 p-4"><ul class="grid grid-cols-3 gap-0.5 overflow-hidden rounded-box">{foreach $group['photos'] as $photo}{include file='__profile_media.tpl' _kind='photo' _context='photos' _small=true}{/foreach}</ul></div></section>{/if}
  {if $group['has_subscriptions_plans'] && $group['subscribers_count'] > 0}<section class="card overflow-hidden rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-[#F9F9F9] shadow-none dark:bg-base-300">{include file='__card_header.tpl' _card_title=__("Subscribers") _card_url="`$system['system_url']`/groups/`$group['group_name']`/subscribers" _card_label=__("See All")}<div class="card-body gap-4 rounded-t-3xl corner-squircle supports-[corner-shape:squircle]:rounded-t-[2.5rem] bg-base-100 p-4"><div class="grid grid-cols-3 gap-2">{foreach $group['subscribers'] as $_subscriber}<a class="group flex min-w-0 flex-col rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-3xl bg-[#F9F9F9] p-1.5 text-center text-base-content! transition-colors hover:bg-base-200 hover:text-primary! dark:bg-base-200 dark:hover:bg-base-300" href="{$system['system_url']}/{$_subscriber['user_name']}"><span class="block overflow-hidden rounded-xl corner-squircle supports-[corner-shape:squircle]:rounded-2xl"><img class="aspect-square w-full object-cover transition-transform duration-300 group-hover:scale-105" src="{$_subscriber['user_picture']}" alt="" loading="lazy"></span><span class="w-full truncate px-0.5 pt-2 pb-1 text-xs font-medium" title="{if $system['show_usernames_enabled']}{$_subscriber['user_name']}{else}{$_subscriber['user_firstname']} {$_subscriber['user_lastname']}{/if}">{if $system['show_usernames_enabled']}{$_subscriber['user_name']}{else}{$_subscriber['user_firstname']} {$_subscriber['user_lastname']}{/if}</span></a>{/foreach}</div></div></section>{/if}
  <!-- mini footer -->
  <div class="hidden lg:block">
    {include file='_footer_mini.tpl'}
  </div>
  <!-- mini footer -->
</div>
<!-- group details -->
