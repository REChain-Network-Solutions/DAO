{if $type == "close"}
  {include file='__modal_header.tpl' _icon="icon-[tabler--star]" _title=__("Close Friends")}
{else}
  {include file='__modal_header.tpl' _icon="icon-[tabler--eye-off]" _title=__("Hide Story From")}
{/if}
<div class="js_story-audience modal__body flex flex-col gap-4" data-type="{$type}">
  <p class="text-sm text-base-content/60">
    {if $type == "close"}
      {__("Only these people see the stories you share with close friends")}
    {else}
      {__("These people will not see any of your stories")}
    {/if}
  </p>

  <div class="w-full">
    <label class="label-text mb-1.5 block" for="story-audience-search">{__("Add People")}</label>
    <input type="text" class="js_story-audience-search input w-full [--border:1px]" id="story-audience-search" autocomplete="off" dir="auto" placeholder='{__("Search for people")}'>
    <div class="js_story-audience-results mt-1 flex flex-col"></div>
  </div>

  {if $users}
    <ul class="flex flex-col">
      {foreach $users as $_user}
        <li class="flex items-center gap-3 rounded-xl p-2">
          <img class="size-10 shrink-0 rounded-full object-cover" src="{$_user['user_picture']}" alt="" loading="lazy">
          <span class="min-w-0 flex-1 truncate text-sm font-semibold" title="{if $system['show_usernames_enabled']}{$_user['user_name']}{else}{$_user['user_firstname']} {$_user['user_lastname']}{/if}">
            {if $system['show_usernames_enabled']}{$_user['user_name']}{else}{$_user['user_firstname']} {$_user['user_lastname']}{/if}
          </span>
          <form class="js_ajax-forms contents" data-url="stories/audience.php?do=remove&amp;type={$type}&amp;id={$_user['user_id']}">
            <button type="submit" class="button button--tertiary button--sm shrink-0">{__("Remove")}</button>
          </form>
        </li>
      {/foreach}
    </ul>
  {else}
    {include file='_no_data.tpl' _empty_compact=true _empty_icon="icon-[tabler--users]" _empty_title=__("No people added yet")}
  {/if}
</div>
