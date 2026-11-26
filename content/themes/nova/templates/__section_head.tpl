<!-- section head -->
<div class="flex min-h-18 flex-wrap items-center justify-between gap-3 px-5 py-3.5">
  <!-- section title -->
  <h2 class="flex items-center gap-2 text-sm font-semibold{if $_group == "attendees"} max-sm:sr-only{/if}">{$_title}</h2>
  <!-- section title -->

  {if $_group == "attendees"}
    <!-- section tabs dropdown -->
    <div class="dropdown relative z-20 flex w-full sm:hidden [--placement:bottom-start] [--strategy:absolute]">
      <button id="section-attendees-dropdown" type="button" class="dropdown-toggle flex h-11 w-full items-center gap-2 rounded-full bg-base-content/5 px-4 text-sm font-medium text-base-content transition hover:bg-base-content/10" aria-haspopup="menu" aria-expanded="false">
        <span class="min-w-0 truncate text-start" title="{if $view == "interested"}{__("Interested")}{elseif $view == "invited"}{__("Invited")}{else}{__("Going")}{/if}">{if $view == "interested"}{__("Interested")}{elseif $view == "invited"}{__("Invited")}{else}{__("Going")}{/if}</span>
        <span class="badge badge-soft badge-primary badge-sm rounded-full">{if $view == "interested"}{$event['event_interested']|default:0}{elseif $view == "invited"}{$event['event_invited']|default:0}{else}{$event['event_going']|default:0}{/if}</span>
        <span class="icon-[tabler--chevron-down] ms-auto size-4 shrink-0 opacity-60" aria-hidden="true"></span>
      </button>
      <div class="dropdown-menu dropdown-open:opacity-100 hidden w-full p-1" role="menu" aria-labelledby="section-attendees-dropdown">
        <a class="dropdown-item{if $view == "going"} dropdown-active{else} text-inherit! hover:bg-primary/5 focus-visible:bg-primary/5{/if}" role="menuitem" href="{$_base}/going" {if $view == "going"}aria-current="page"{/if}>
          <span class="grow">{__("Going")}</span>
          <span class="badge badge-soft badge-sm rounded-full">{$event['event_going']|default:0}</span>
        </a>
        <a class="dropdown-item{if $view == "interested"} dropdown-active{else} text-inherit! hover:bg-primary/5 focus-visible:bg-primary/5{/if}" role="menuitem" href="{$_base}/interested" {if $view == "interested"}aria-current="page"{/if}>
          <span class="grow">{__("Interested")}</span>
          <span class="badge badge-soft badge-sm rounded-full">{$event['event_interested']|default:0}</span>
        </a>
        <a class="dropdown-item{if $view == "invited"} dropdown-active{else} text-inherit! hover:bg-primary/5 focus-visible:bg-primary/5{/if}" role="menuitem" href="{$_base}/invited" {if $view == "invited"}aria-current="page"{/if}>
          <span class="grow">{__("Invited")}</span>
          <span class="badge badge-soft badge-sm rounded-full">{$event['event_invited']|default:0}</span>
        </a>
      </div>
    </div>
    <!-- section tabs dropdown -->
  {/if}

  {if $_group && !($_group == "members" && !$group['has_subscriptions_plans']) && !($_group == "videos" && (!$system['videos_enabled'] || !$system['reels_enabled']))}
    <!-- section tabs -->
    <ul class="m-0 {if $_group == "attendees"}max-sm:hidden {/if}flex max-w-full list-none items-center gap-1 overflow-x-auto rounded-full bg-base-content/5 p-1 [scrollbar-width:none] [&::-webkit-scrollbar]:hidden">
      {if $_group == "photos"}
        <li class="shrink-0">
          <a class="inline-flex h-9 items-center gap-2 rounded-full px-4 text-sm font-medium whitespace-nowrap transition-colors focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary {if $view == "photos"}bg-base-100 text-base-content! shadow-sm{else}text-base-content/60! hover:text-base-content!{/if}" href="{$_base}/photos" {if $view == "photos"}aria-current="page"{/if}>
            {__("Photos")}
          </a>
        </li>
        <li class="shrink-0">
          <a class="inline-flex h-9 items-center gap-2 rounded-full px-4 text-sm font-medium whitespace-nowrap transition-colors focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary {if $view == "albums" || $view == "album"}bg-base-100 text-base-content! shadow-sm{else}text-base-content/60! hover:text-base-content!{/if}" href="{$_base}/albums" {if $view == "albums" || $view == "album"}aria-current="page"{/if}>
            {__("Albums")}
          </a>
        </li>
      {elseif $_group == "videos"}
        {if $system['videos_enabled']}
          <li class="shrink-0">
            <a class="inline-flex h-9 items-center gap-2 rounded-full px-4 text-sm font-medium whitespace-nowrap transition-colors focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary {if $view == "videos"}bg-base-100 text-base-content! shadow-sm{else}text-base-content/60! hover:text-base-content!{/if}" href="{$_base}/videos" {if $view == "videos"}aria-current="page"{/if}>
              {__("Videos")}
            </a>
          </li>
        {/if}
        {if $system['reels_enabled']}
          <li class="shrink-0">
            <a class="inline-flex h-9 items-center gap-2 rounded-full px-4 text-sm font-medium whitespace-nowrap transition-colors focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary {if $view == "reels"}bg-base-100 text-base-content! shadow-sm{else}text-base-content/60! hover:text-base-content!{/if}" href="{$_base}/reels" {if $view == "reels"}aria-current="page"{/if}>
              {__("Reels")}
            </a>
          </li>
        {/if}
      {elseif $_group == "attendees"}
        <li class="shrink-0">
          <a class="inline-flex h-9 items-center gap-2 rounded-full px-4 text-sm font-medium whitespace-nowrap transition-colors focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary {if $view == "going"}bg-base-100 text-base-content! shadow-sm{else}text-base-content/60! hover:text-base-content!{/if}" href="{$_base}/going" {if $view == "going"}aria-current="page"{/if}>
            {__("Going")}
            <span class="badge badge-soft badge-sm rounded-full">{$event['event_going']|default:0}</span>
          </a>
        </li>
        <li class="shrink-0">
          <a class="inline-flex h-9 items-center gap-2 rounded-full px-4 text-sm font-medium whitespace-nowrap transition-colors focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary {if $view == "interested"}bg-base-100 text-base-content! shadow-sm{else}text-base-content/60! hover:text-base-content!{/if}" href="{$_base}/interested" {if $view == "interested"}aria-current="page"{/if}>
            {__("Interested")}
            <span class="badge badge-soft badge-sm rounded-full">{$event['event_interested']|default:0}</span>
          </a>
        </li>
        <li class="shrink-0">
          <a class="inline-flex h-9 items-center gap-2 rounded-full px-4 text-sm font-medium whitespace-nowrap transition-colors focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary {if $view == "invited"}bg-base-100 text-base-content! shadow-sm{else}text-base-content/60! hover:text-base-content!{/if}" href="{$_base}/invited" {if $view == "invited"}aria-current="page"{/if}>
            {__("Invited")}
            <span class="badge badge-soft badge-sm rounded-full">{$event['event_invited']|default:0}</span>
          </a>
        </li>
      {elseif $_group == "members"}
        <li class="shrink-0">
          <a class="inline-flex h-9 items-center gap-2 rounded-full px-4 text-sm font-medium whitespace-nowrap transition-colors focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary {if $view == "members"}bg-base-100 text-base-content! shadow-sm{else}text-base-content/60! hover:text-base-content!{/if}" href="{$_base}/members" {if $view == "members"}aria-current="page"{/if}>
            {__("Members")}
            <span class="badge badge-soft badge-sm rounded-full">{$group['group_members']|default:0}</span>
          </a>
        </li>
        {if $group['has_subscriptions_plans']}
          <li class="shrink-0">
            <a class="inline-flex h-9 items-center gap-2 rounded-full px-4 text-sm font-medium whitespace-nowrap transition-colors focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary {if $view == "subscribers"}bg-base-100 text-base-content! shadow-sm{else}text-base-content/60! hover:text-base-content!{/if}" href="{$_base}/subscribers" {if $view == "subscribers"}aria-current="page"{/if}>
              {__("Subscribers")}
            </a>
          </li>
        {/if}
      {/if}
    </ul>
    <!-- section tabs -->
  {/if}

  {if $_actions}
    <!-- section actions -->
    <div class="flex min-w-0 flex-wrap items-center gap-2">{$_actions nofilter}</div>
    <!-- section actions -->
  {/if}
</div>
<!-- section head -->
