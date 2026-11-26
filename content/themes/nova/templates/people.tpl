{include file='_head.tpl'}
{include file='_header.tpl'}

<!-- page content -->
<div class="pb-8 sm:pb-12">

  <!-- page heading -->
  {if $view == "find"}
    {include file='__page_header.tpl' _title=__("People") _text=__("Browse people matching your search") _image="people.svg"}
  {elseif $view == "friend_requests"}
    {include file='__page_header.tpl' _title=__("People") _text=__("Review the people who want to connect with you") _image="people.svg"}
  {elseif $view == "sent_requests"}
    {include file='__page_header.tpl' _title=__("People") _text=__("Track the requests you have sent") _image="people.svg"}
  {else}
    {include file='__page_header.tpl' _title=__("People") _text=__("Discover members and make new connections") _image="people.svg"}
  {/if}
  <!-- page heading -->

  <!-- tabs -->
  <nav class="tabs tabs-bordered mt-6 gap-2 sm:gap-6 border-b border-base-300" aria-label='{__("People")}'>
    <a class="tab -mb-px h-11 flex-1 justify-center gap-1.5 px-0 text-sm sm:flex-none sm:shrink-0 sm:justify-start font-medium{if $view == "" || $view == "find"} tab-active border-primary! text-primary!{else} border-transparent! text-base-content/60! hover:text-base-content!{/if}" href="{$system['system_url']}/people" {if $view == ""}aria-current="page" {/if}>
      <span class="icon-[tabler--sparkles] size-4" aria-hidden="true"></span>
      {__("Discover")}
    </a>
    {if $system['friends_enabled']}
      <a class="tab -mb-px h-11 flex-1 justify-center gap-1.5 px-0 text-sm sm:flex-none sm:shrink-0 sm:justify-start font-medium{if $view == "friend_requests"} tab-active border-primary! text-primary!{else} border-transparent! text-base-content/60! hover:text-base-content!{/if}" href="{$system['system_url']}/people/friend_requests" {if $view == "friend_requests"}aria-current="page" {/if}>
        <span class="icon-[tabler--user-check] size-4" aria-hidden="true"></span>
        <span class="sm:hidden">{__("Requests")}</span>
        <span class="hidden sm:inline">{__("Friend Requests")}</span>
        {if $user->_data['friend_requests']}
          <span class="badge badge-primary badge-sm rounded-full">{count($user->_data['friend_requests'])}</span>
        {/if}
      </a>
      <a class="tab -mb-px h-11 flex-1 justify-center gap-1.5 px-0 text-sm sm:flex-none sm:shrink-0 sm:justify-start font-medium{if $view == "sent_requests"} tab-active border-primary! text-primary!{else} border-transparent! text-base-content/60! hover:text-base-content!{/if}" href="{$system['system_url']}/people/sent_requests" {if $view == "sent_requests"}aria-current="page" {/if}>
        <span class="icon-[tabler--send] size-4" aria-hidden="true"></span>
        <span class="sm:hidden">{__("Sent")}</span>
        <span class="hidden sm:inline">{__("Sent Requests")}</span>
        {if $user->_data['friend_requests_sent_total']}
          <span class="badge badge-soft badge-sm rounded-full">{$user->_data['friend_requests_sent_total']}</span>
        {/if}
      </a>
    {/if}
  </nav>
  <!-- tabs -->

  {assign var="_people_discovery" value=($view == "" || $view == "find")}
  {if $view == ""}
    {assign var="_people_items" value=$people}
    {assign var="_people_more_get" value="new_people"}
    {assign var="_people_more_limit" value=$system['people_results']}
  {elseif $view == "find"}
    {assign var="_people_items" value=$people}
    {assign var="_people_more_get" value="find_people"}
    {assign var="_people_more_limit" value=$system['people_results']|default:$system['max_results']}
  {elseif $view == "friend_requests"}
    {assign var="_people_items" value=$user->_data['friend_requests']}
    {assign var="_people_more_get" value="friend_requests"}
    {assign var="_people_more_limit" value=$system['max_results']}
  {else}
    {assign var="_people_items" value=$user->_data['friend_requests_sent']}
    {assign var="_people_more_get" value="friend_requests_sent"}
    {assign var="_people_more_limit" value=$system['max_results']}
  {/if}

  <div class="mt-6 grid gap-6{if $_people_discovery} lg:grid-cols-[18rem_minmax(0,1fr)]{else} lg:grid-cols-[minmax(0,1fr)_20rem]{/if} lg:items-start">

    {if $_people_discovery}
      <!-- filters -->
      <aside class="flex flex-col gap-6 lg:sticky lg:top-24" aria-label='{__("Search People")}'>
        <section class="card border border-base-300 bg-base-100 shadow-none">
          <form action="{$system['system_url']}/people/find" method="get">
            {include file='__settings_card_header.tpl' _icon="icon-[tabler--adjustments-horizontal]" _title=__("Find People") _text=__("Narrow your search") _text_class="text-xs"}
            <div class="card-body gap-4 pt-5">
              <div class="w-full">
                <label class="label-text mb-1.5 block" for="people-query">{__("Search for")}</label>
                <label class="input w-full">
                  <span class="icon-[tabler--search] my-auto me-2 size-4 shrink-0 text-base-content/50" aria-hidden="true"></span>
                  <input id="people-query" type="text" class="grow" name="query" value="{$query}" placeholder='{__("Name, username...")}'>
                </label>
              </div>
              {if $system['location_finder_enabled']}
                <div class="w-full">
                  <label class="label-text mb-1.5 block" for="people-distance">{__("Distance")}</label>
                  <input id="people-distance-slider" type="range" class="range range-primary range-sm [--color-neutral:var(--color-base-content)]" min="1" max="5000" name="distance_slider" value="{isset($distance_value)? $distance_value : 5000}" oninput="this.form.distance_value.value=this.value" aria-label='{__("Distance")}'>
                  <label class="input mt-2 w-full">
                    <input id="people-distance" type="number" class="grow" min="1" max="5000" name="distance_value" value="{isset($distance_value)? $distance_value : 5000}" oninput="this.form.distance_slider.value=this.value">
                    <span class="my-auto ms-2 shrink-0 text-sm text-base-content/60">{if $system['system_distance'] == "mile"}{__("ML")}{else}{__("KM")}{/if}</span>
                  </label>
                </div>
              {/if}
              {if $system['location_info_enabled']}
                <div class="w-full">
                  <label class="label-text mb-1.5 block" for="people-city">{__("City")}</label>
                  <input id="people-city" type="text" class="input w-full" name="city" value="{$city}">
                </div>
                <div class="w-full">
                  <label class="label-text mb-1.5 block" for="country">{__("Country")}</label>
                  <select class="select w-full" name="country" id="country">
                    <option value="none">{__("Any")}</option>
                    {foreach $countries as $_country}
                      <option {if $country == $_country['country_id']}selected{/if} value="{$_country['country_id']}">{$_country['country_name_with_flag']}</option>
                    {/foreach}
                  </select>
                </div>
              {/if}
              <div class="w-full {if $system['genders_disabled']}hidden{/if}">
                <label class="label-text mb-1.5 block" for="people-gender">{__("Gender")}</label>
                <select id="people-gender" class="select w-full" name="gender">
                  <option value="any">{__("Any")}</option>
                  {foreach $genders as $_gender}
                    <option {if $gender == $_gender['gender_id']}selected{/if} value="{$_gender['gender_id']}">{$_gender['gender_name']}</option>
                  {/foreach}
                </select>
              </div>
              {if $system['relationship_info_enabled']}
                <div class="w-full">
                  <label class="label-text mb-1.5 block" for="people-relationship">{__("Relationship")}</label>
                  <select id="people-relationship" class="select w-full" name="relationship">
                    <option {if $relationship == "any"}selected{/if} value="any">{__("Any")}</option>
                    <option {if $relationship == "single"}selected{/if} value="single">{__("Single")}</option>
                    <option {if $relationship == "relationship"}selected{/if} value="relationship">{__("In a relationship")}</option>
                    <option {if $relationship == "married"}selected{/if} value="married">{__("Married")}</option>
                    <option {if $relationship == "complicated"}selected{/if} value="complicated">{__("It's complicated")}</option>
                    <option {if $relationship == "separated"}selected{/if} value="separated">{__("Separated")}</option>
                    <option {if $relationship == "divorced"}selected{/if} value="divorced">{__("Divorced")}</option>
                    <option {if $relationship == "widowed"}selected{/if} value="widowed">{__("Widowed")}</option>
                  </select>
                </div>
              {/if}
              <div class="grid grid-cols-1 gap-3 sm:grid-cols-2">
                <div class="min-w-0">
                  <label class="label-text mb-1.5 block" for="people-online">{__("Online Status")}</label>
                  <select id="people-online" class="select w-full" name="online_status">
                    <option {if $online_status == "any"}selected{/if} value="any">{__("Any")}</option>
                    <option {if $online_status == "online"}selected{/if} value="online">{__("Online")}</option>
                    <option {if $online_status == "offline"}selected{/if} value="offline">{__("Offline")}</option>
                  </select>
                </div>
                <div class="min-w-0">
                  <label class="label-text mb-1.5 block" for="people-verified">{__("Verified Status")}</label>
                  <select id="people-verified" class="select w-full" name="verified_status">
                    <option {if $verified_status == "any"}selected{/if} value="any">{__("Any")}</option>
                    <option {if $verified_status == "verified"}selected{/if} value="verified">{__("Verified")}</option>
                    <option {if $verified_status == "unverified"}selected{/if} value="unverified">{__("Not Verified")}</option>
                  </select>
                </div>
              </div>
              {if $custom_fields}
                <div class="flex flex-col gap-4">
                  {include file='__custom_fields.tpl' _custom_fields=$custom_fields _registration=true _search=true}
                </div>
              {/if}
            </div>
            <div class="card-footer border-t border-base-300 pt-5">
              <button type="submit" class="heroui button button--primary button--full-width rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]">
                <span class="icon-[tabler--search] size-4" aria-hidden="true"></span>
                {__("Search")}
              </button>
            </div>
          </form>
        </section>

        {include file='_ads_campaigns.tpl'}
        {include file='_ads.tpl'}
        {include file='_widget.tpl'}
      </aside>
      <!-- filters -->
    {/if}

    <!-- people -->
    <div class="flex min-w-0 flex-col gap-4">
      <div>
        <h2 class="text-lg font-semibold">
          {if $view == "find"}{__("Search Results")}
          {elseif $view == "friend_requests"}{__("Friend Requests")}
          {elseif $view == "sent_requests"}{__("Friend Requests Sent")}
          {else}
            {__("People You May Know")}
          {/if}
        </h2>
        {if $view == "find" && $query}
          <p class="text-sm text-base-content/60">{__("Results for")} <strong class="text-base-content">{$query}</strong></p>
        {elseif $view == "friend_requests"}
          <p class="text-sm text-base-content/60">{__("Respond to requests from other members")}</p>
        {elseif $view == "sent_requests"}
          <p class="text-sm text-base-content/60">{__("Manage the connections you started")}</p>
        {/if}
      </div>

      {if $_people_items}
        <div>
          <ul class="grid grid-cols-1 gap-4 sm:grid-cols-3">
            {foreach $_people_items as $_user}
              {if $view == "find"}
                {include file='__people_card.tpl' _connection=$_user['connection']}
              {elseif $view == "friend_requests"}
                {include file='__people_card.tpl' _connection="request"}
              {elseif $view == "sent_requests"}
                {include file='__people_card.tpl' _connection="cancel"}
              {else}
                {include file='__people_card.tpl' _connection="add"}
              {/if}
            {/foreach}
          </ul>
          {if count($_people_items) >= $_people_more_limit}
            <div class="see-more js_see-more mt-6 flex cursor-pointer items-center justify-center gap-2 rounded-box border border-base-300 bg-base-100 py-3 text-sm font-semibold transition-colors hover:border-primary/30 hover:bg-primary/5 hover:text-primary" data-get="{$_people_more_get}" data-tpl="people" {if $view == "find"}data-filter="{$people_search_filters|escape:'html'}" {/if}>
              <span>{if $view == "find"}{__("Load More")}{else}{__("See More")}{/if}</span>
              <div class="loading loading-spinner loading-sm hidden"></div>
            </div>
          {/if}
        </div>
      {else}
        <div class="card border border-base-300 bg-base-100 shadow-none">
          {if $view == "find"}
            {include file='_no_data.tpl' _empty_icon="icon-[tabler--user-search]" _empty_title=__("No people match your search") _empty_text=__("Try changing your search filters")}
          {elseif $view == "friend_requests"}
            {include file='_no_data.tpl' _empty_icon="icon-[tabler--user-check]" _empty_title=__("No new requests")}
          {elseif $view == "sent_requests"}
            {include file='_no_data.tpl' _empty_icon="icon-[tabler--send]" _empty_title=__("No sent requests")}
          {else}
            {include file='_no_data.tpl' _empty_icon="icon-[tabler--users]" _empty_title=__("No people available") _empty_text=__("Try searching for a name or location")}
          {/if}
        </div>
      {/if}
    </div>
    <!-- people -->

    {if !$_people_discovery}
      <!-- aside -->
      <aside class="flex flex-col gap-6 lg:sticky lg:top-24">
        {include file='_ads_campaigns.tpl'}
        {include file='_ads.tpl'}
        {include file='_widget.tpl'}
      </aside>
      <!-- aside -->
    {/if}

  </div>

</div>
<!-- page content -->

{include file='_footer.tpl'}