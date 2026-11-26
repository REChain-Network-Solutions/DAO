<!-- campaign form -->
<form class="js_ajax-forms mt-4" data-url="ads/campaign.php?do={if $view == "edit"}edit&id={$campaign['campaign_id']}{else}create{/if}">
  <div class="grid gap-6 lg:grid-cols-[minmax(0,1fr)_22rem] lg:items-start">

    <div class="flex min-w-0 flex-col gap-6">

      <!-- campaign details -->
      <section class="card border border-base-300 bg-base-100 p-5 shadow-none sm:p-6" aria-labelledby="ads-section-details">
        <header class="mb-5 flex items-center gap-3">
          <span class="flex size-8 shrink-0 items-center justify-center rounded-full bg-primary/10 text-sm font-semibold text-primary">1</span>
          <h2 id="ads-section-details" class="text-lg font-semibold">{__("Campaign Details")}</h2>
        </header>
        <div class="flex flex-col gap-5">
          <div>
            <label class="label-text mb-2 block" for="campaign_title">{__("Campaign Title")}</label>
            <input type="text" class="input w-full" name="campaign_title" id="campaign_title" value="{$campaign['campaign_title']}">
            <span class="mt-2 block text-xs text-base-content/60">{__("Set a title for your campaign")}</span>
          </div>
          <div class="grid gap-5 sm:grid-cols-2">
            <div>
              <label class="label-text mb-2 block" for="campaign_start_date">{__("Campaign Start Date")}</label>
              <input type="datetime-local" class="input w-full" name="campaign_start_date" id="campaign_start_date" value="{$campaign['campaign_start_date']}">
              <span class="mt-2 block text-xs text-base-content/60">{__("Set Campaign start datetime (UTC)")}</span>
            </div>
            <div>
              <label class="label-text mb-2 block" for="campaign_end_date">{__("Campaign End Date")}</label>
              <input type="datetime-local" class="input w-full" name="campaign_end_date" id="campaign_end_date" value="{$campaign['campaign_end_date']}">
              <span class="mt-2 block text-xs text-base-content/60">{__("Set Campaign end datetime (UTC)")}</span>
            </div>
          </div>
        </div>
      </section>
      <!-- campaign details -->

      <!-- campaign bidding -->
      <section class="card border border-base-300 bg-base-100 p-5 shadow-none sm:p-6" aria-labelledby="ads-section-bidding">
        <header class="mb-5 flex items-center gap-3">
          <span class="flex size-8 shrink-0 items-center justify-center rounded-full bg-primary/10 text-sm font-semibold text-primary">2</span>
          <h2 id="ads-section-bidding" class="text-lg font-semibold">{__("Campaign Bidding")}</h2>
        </header>
        <div class="flex flex-col gap-5">
          <div>
            <label class="label-text mb-2 block" for="campaign_budget">{__("Campaign Budget")}</label>
            <div class="input w-full">
              {if $system['system_currency_dir'] != "right"}
                <span class="my-auto me-2 shrink-0 font-medium text-base-content/60">{$system['system_currency_symbol']}</span>
              {/if}
              <input type="text" class="grow" inputmode="decimal" placeholder="0.00" name="campaign_budget" id="campaign_budget" value="{$campaign['campaign_budget']}">
              {if $system['system_currency_dir'] == "right"}
                <span class="my-auto ms-2 shrink-0 font-medium text-base-content/60">{$system['system_currency_symbol']}</span>
              {/if}
            </div>
            <span class="mt-2 block text-xs text-base-content/60">{__("Set a budget for your campaign, campaign will be paused if reached its limit")}</span>
          </div>
          <fieldset>
            <legend class="label-text mb-2">{__("Bidding")}</legend>
            <div class="grid gap-3 sm:grid-cols-2">
              <label class="group flex cursor-pointer items-center gap-3 rounded-field border border-base-300 p-4 transition-colors hover:border-primary/40 has-checked:border-primary has-checked:bg-primary/5 has-focus-visible:ring-2 has-focus-visible:ring-primary/30">
                <input type="radio" class="sr-only" name="campaign_bidding" value="click" {if !$campaign || $campaign['campaign_bidding'] == "click"}checked{/if}>
                <span class="flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-base-content/70 group-has-checked:bg-primary/10 group-has-checked:text-primary">
                  <span class="icon-[tabler--hand-click] size-5" aria-hidden="true"></span>
                </span>
                <span class="min-w-0 flex-1">
                  <span class="block font-medium">{__("Pay Per Click")}</span>
                  <span class="block text-sm text-base-content/60">{print_money($system['ads_cost_click'], null, null, false)}</span>
                </span>
                <span class="icon-[tabler--circle-check-filled] size-5 shrink-0 text-primary opacity-0 group-has-checked:opacity-100" aria-hidden="true"></span>
              </label>
              <label class="group flex cursor-pointer items-center gap-3 rounded-field border border-base-300 p-4 transition-colors hover:border-primary/40 has-checked:border-primary has-checked:bg-primary/5 has-focus-visible:ring-2 has-focus-visible:ring-primary/30">
                <input type="radio" class="sr-only" name="campaign_bidding" value="view" {if $campaign['campaign_bidding'] == "view"}checked{/if}>
                <span class="flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-base-content/70 group-has-checked:bg-primary/10 group-has-checked:text-primary">
                  <span class="icon-[tabler--eye] size-5" aria-hidden="true"></span>
                </span>
                <span class="min-w-0 flex-1">
                  <span class="block font-medium">{__("Pay Per View")}</span>
                  <span class="block text-sm text-base-content/60">{print_money($system['ads_cost_view'], null, null, false)}</span>
                </span>
                <span class="icon-[tabler--circle-check-filled] size-5 shrink-0 text-primary opacity-0 group-has-checked:opacity-100" aria-hidden="true"></span>
              </label>
            </div>
          </fieldset>
        </div>
      </section>
      <!-- campaign bidding -->

      <!-- target audience -->
      <section class="card border border-base-300 bg-base-100 p-5 shadow-none sm:p-6" aria-labelledby="ads-section-audience">
        <header class="mb-5 flex items-center gap-3">
          <span class="flex size-8 shrink-0 items-center justify-center rounded-full bg-primary/10 text-sm font-semibold text-primary">3</span>
          <h2 id="ads-section-audience" class="text-lg font-semibold">{__("Target Audience")}</h2>
        </header>
        <div class="flex flex-col gap-5">
          <div>
            <label class="label-text mb-2 block" for="js_ads-audience-countries">{__("Audience Country")}</label>
            <select class="hidden" multiple name="audience_countries[]" id="js_ads-audience-countries" data-select='{ "placeholder": "{__("All")}", "hasSearch": true, "searchPlaceholder": "{__("Search")}", "searchClasses": "input", "searchWrapperClasses": "sticky top-0 z-1 bg-base-100 p-2", "toggleTag": "<button type=\"button\" aria-expanded=\"false\"></button>", "toggleClasses": "advance-select-toggle", "dropdownClasses": "advance-select-menu max-h-60 overflow-y-auto pt-0 opacity-0 transition-opacity duration-300 select-opened:opacity-100", "optionClasses": "advance-select-option selected:select-active", "optionTemplate": "<div class=\"flex w-full items-center justify-between\"><span data-title></span><span class=\"icon-[tabler--check] hidden size-4 shrink-0 text-primary selected:block\"></span></div>", "extraMarkup": "<span class=\"icon-[tabler--caret-up-down] pointer-events-none absolute end-3 top-1/2 size-4 -translate-y-1/2 text-base-content/60\"></span>" }'>
              {foreach $countries as $country}
                <option {if $campaign && in_array($country['country_id'], $campaign['audience_countries'])}selected{/if} value="{$country['country_id']}">{$country['country_name_with_flag']}</option>
              {/foreach}
            </select>
          </div>
          <div class="grid gap-5 sm:grid-cols-2">
            <div class="{if $system['genders_disabled']}hidden{/if}">
              <label class="label-text mb-2 block" for="js_ads-audience-gender">{__("Audience Gender")}</label>
              <select class="select w-full" name="audience_gender" id="js_ads-audience-gender">
                <option {if $campaign['audience_gender'] == "all"}selected{/if} value="all">{__("All")}</option>
                {foreach $genders as $gender}
                  <option {if $campaign['audience_gender'] == $gender['gender_id']}selected{/if} value="{$gender['gender_id']}">{$gender['gender_name']}</option>
                {/foreach}
              </select>
            </div>
            {if $system['relationship_info_enabled']}
              <div>
                <label class="label-text mb-2 block" for="js_ads-audience-relationship">{__("Audience Relationship")}</label>
                <select class="select w-full" name="audience_relationship" id="js_ads-audience-relationship">
                  <option {if $campaign['audience_relationship'] == "all"}selected{/if} value="all">{__("All")}</option>
                  <option {if $campaign['audience_relationship'] == "single"}selected{/if} value="single">{__("Single")}</option>
                  <option {if $campaign['audience_relationship'] == "relationship"}selected{/if} value="relationship">{__("In a relationship")}</option>
                  <option {if $campaign['audience_relationship'] == "married"}selected{/if} value="married">{__("Married")}</option>
                  <option {if $campaign['audience_relationship'] == "complicated"}selected{/if} value="complicated">{__("It's complicated")}</option>
                  <option {if $campaign['audience_relationship'] == "separated"}selected{/if} value="separated">{__("Separated")}</option>
                  <option {if $campaign['audience_relationship'] == "divorced"}selected{/if} value="divorced">{__("Divorced")}</option>
                  <option {if $campaign['audience_relationship'] == "widowed"}selected{/if} value="widowed">{__("Widowed")}</option>
                </select>
              </div>
            {/if}
          </div>
          <fieldset>
            <legend class="label-text mb-2">{__("Age Range")}</legend>
            <div class="grid gap-5 sm:grid-cols-2">
              <div>
                <label class="label-text mb-2 block" for="js_ads-audience-age-min">{__("Minimum Age")}</label>
                <input type="number" class="input w-full" name="audience_age_min" id="js_ads-audience-age-min" min="1" max="120" step="1" placeholder="{__("No limit")}" value="{$campaign['audience_age_min']|default:''}">
              </div>
              <div>
                <label class="label-text mb-2 block" for="js_ads-audience-age-max">{__("Maximum Age")}</label>
                <input type="number" class="input w-full" name="audience_age_max" id="js_ads-audience-age-max" min="1" max="120" step="1" placeholder="{__("No limit")}" value="{$campaign['audience_age_max']|default:''}">
              </div>
            </div>
            <span class="mt-2 block text-xs text-base-content/60">{__("Leave blank for no age limit. Age limits include both endpoints and exclude people whose age is unknown.")}</span>
          </fieldset>
        </div>
      </section>
      <!-- target audience -->

      <!-- ads details -->
      <section class="card border border-base-300 bg-base-100 p-5 shadow-none sm:p-6" aria-labelledby="ads-section-ads">
        <header class="mb-5 flex items-center gap-3">
          <span class="flex size-8 shrink-0 items-center justify-center rounded-full bg-primary/10 text-sm font-semibold text-primary">4</span>
          <h2 id="ads-section-ads" class="text-lg font-semibold">{__("Ads Details")}</h2>
        </header>
        <div class="flex flex-col gap-5">
          <fieldset>
            <legend class="label-text mb-2">{__("Advertise For")}</legend>
            <div class="grid grid-cols-2 gap-3 sm:grid-cols-3 xl:grid-cols-5">
              <label class="group flex cursor-pointer flex-col items-center gap-2 rounded-field border border-base-300 px-3 py-4 text-center max-sm:col-span-2 text-sm font-medium transition-colors hover:border-primary/40 has-checked:border-primary has-checked:bg-primary/5 has-checked:text-primary has-focus-visible:ring-2 has-focus-visible:ring-primary/30">
                <input type="radio" class="js_campaign-type sr-only" name="ads_type" value="url" {if !$campaign || $campaign['ads_type'] == "url"}checked{/if}>
                <span class="flex size-10 items-center justify-center rounded-xl bg-base-200 text-base-content/70 group-has-checked:bg-primary/10 group-has-checked:text-primary">
                  <span class="icon-[tabler--link] size-5" aria-hidden="true"></span>
                </span>
                {__("URL")}
              </label>
              <label class="group flex cursor-pointer flex-col items-center gap-2 rounded-field border border-base-300 px-3 py-4 text-center text-sm font-medium transition-colors hover:border-primary/40 has-checked:border-primary has-checked:bg-primary/5 has-checked:text-primary has-focus-visible:ring-2 has-focus-visible:ring-primary/30">
                <input type="radio" class="js_campaign-type sr-only" name="ads_type" value="post" {if $campaign['ads_type'] == "post"}checked{/if}>
                <span class="flex size-10 items-center justify-center rounded-xl bg-base-200 text-base-content/70 group-has-checked:bg-primary/10 group-has-checked:text-primary">
                  <span class="icon-[tabler--news] size-5" aria-hidden="true"></span>
                </span>
                {__("Post")}
              </label>
              <label class="group flex cursor-pointer flex-col items-center gap-2 rounded-field border border-base-300 px-3 py-4 text-center text-sm font-medium transition-colors hover:border-primary/40 has-checked:border-primary has-checked:bg-primary/5 has-checked:text-primary has-focus-visible:ring-2 has-focus-visible:ring-primary/30">
                <input type="radio" class="js_campaign-type sr-only" name="ads_type" value="page" {if $campaign['ads_type'] == "page"}checked{/if}>
                <span class="flex size-10 items-center justify-center rounded-xl bg-base-200 text-base-content/70 group-has-checked:bg-primary/10 group-has-checked:text-primary">
                  <span class="icon-[tabler--flag] size-5" aria-hidden="true"></span>
                </span>
                {__("Page")}
              </label>
              <label class="group flex cursor-pointer flex-col items-center gap-2 rounded-field border border-base-300 px-3 py-4 text-center text-sm font-medium transition-colors hover:border-primary/40 has-checked:border-primary has-checked:bg-primary/5 has-checked:text-primary has-focus-visible:ring-2 has-focus-visible:ring-primary/30">
                <input type="radio" class="js_campaign-type sr-only" name="ads_type" value="group" {if $campaign['ads_type'] == "group"}checked{/if}>
                <span class="flex size-10 items-center justify-center rounded-xl bg-base-200 text-base-content/70 group-has-checked:bg-primary/10 group-has-checked:text-primary">
                  <span class="icon-[tabler--users-group] size-5" aria-hidden="true"></span>
                </span>
                {__("Group")}
              </label>
              <label class="group flex cursor-pointer flex-col items-center gap-2 rounded-field border border-base-300 px-3 py-4 text-center text-sm font-medium transition-colors hover:border-primary/40 has-checked:border-primary has-checked:bg-primary/5 has-checked:text-primary has-focus-visible:ring-2 has-focus-visible:ring-primary/30">
                <input type="radio" class="js_campaign-type sr-only" name="ads_type" value="event" {if $campaign['ads_type'] == "event"}checked{/if}>
                <span class="flex size-10 items-center justify-center rounded-xl bg-base-200 text-base-content/70 group-has-checked:bg-primary/10 group-has-checked:text-primary">
                  <span class="icon-[tabler--calendar-event] size-5" aria-hidden="true"></span>
                </span>
                {__("Event")}
              </label>
            </div>
            <span class="mt-2 block text-xs text-base-content/60">{__("You can advertise for a URL or one of your posts, pages, groups or events")}</span>
          </fieldset>

          <div class="{if $campaign && $campaign['ads_type'] != 'url'}hidden{/if}" id="js_campaign-type-url">
            <label class="label-text mb-2 block" for="ads_url">{__("Target URL")}</label>
            <input type="text" class="input w-full" name="ads_url" id="ads_url" placeholder="https://" value="{if $campaign['ads_type'] == 'url'}{$campaign['ads_url']}{/if}">
            <span class="mt-2 block text-xs text-base-content/60">{__("Enter your URL you want to advertise for")}</span>
          </div>
          <div class="{if $campaign['ads_type'] != 'post'}hidden{/if}" id="js_campaign-type-post">
            <label class="label-text mb-2 block" for="ads_post_url">{__("Target post URL")}</label>
            <input type="text" class="input w-full" name="ads_post_url" id="ads_post_url" value="{$campaign['ads_post_url']}">
            <span class="mt-2 block text-xs text-base-content/60">{__("Enter your post URL you want to advertise for")}</span>
          </div>
          <div class="{if $campaign['ads_type'] != 'page'}hidden{/if}" id="js_campaign-type-page">
            <label class="label-text mb-2 block" for="ads_page">{__("Target Page")}</label>
            <select class="select w-full" name="ads_page" id="ads_page">
              <option value="none">{__("Select Page")}</option>
              {foreach $pages as $page}
                <option {if $campaign['ads_page'] == $page['page_id']}selected{/if} value="{$page['page_id']}">{__($page['page_title'])}</option>
              {/foreach}
            </select>
            <span class="mt-2 block text-xs text-base-content/60">{__("Select one of your pages you want to advertise for")}</span>
          </div>
          <div class="{if $campaign['ads_type'] != 'group'}hidden{/if}" id="js_campaign-type-group">
            <label class="label-text mb-2 block" for="ads_group">{__("Target Group")}</label>
            <select class="select w-full" name="ads_group" id="ads_group">
              <option value="none">{__("Select Group")}</option>
              {foreach $groups as $group}
                <option {if $campaign['ads_group'] == $group['group_id']}selected{/if} value="{$group['group_id']}">{__($group['group_title'])}</option>
              {/foreach}
            </select>
            <span class="mt-2 block text-xs text-base-content/60">{__("Select one of your groups you want to advertise for")}</span>
          </div>
          <div class="{if $campaign['ads_type'] != 'event'}hidden{/if}" id="js_campaign-type-event">
            <label class="label-text mb-2 block" for="ads_event">{__("Target Event")}</label>
            <select class="select w-full" name="ads_event" id="ads_event">
              <option value="none">{__("Select Event")}</option>
              {foreach $events as $event}
                <option {if $campaign['ads_event'] == $event['event_id']}selected{/if} value="{$event['event_id']}">{__($event['event_title'])}</option>
              {/foreach}
            </select>
            <span class="mt-2 block text-xs text-base-content/60">{__("Select one of your events you want to advertise for")}</span>
          </div>

          <fieldset class="{if $campaign['ads_type'] == 'post'}hidden{/if}" id="js_campaign-placement">
            <legend class="label-text mb-2">{__("Ads Placement")}</legend>
            <div class="grid gap-3 sm:grid-cols-2">
              <label class="group flex cursor-pointer items-center gap-3 rounded-field border border-base-300 p-4 transition-colors hover:border-primary/40 has-checked:border-primary has-checked:bg-primary/5 has-focus-visible:ring-2 has-focus-visible:ring-primary/30">
                <input type="radio" class="sr-only" name="ads_placement" value="newsfeed" {if !$campaign || $campaign['ads_placement'] == "newsfeed"}checked{/if}>
                <span class="flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-base-content/70 group-has-checked:bg-primary/10 group-has-checked:text-primary">
                  <span class="icon-[tabler--layout-list] size-5" aria-hidden="true"></span>
                </span>
                <span class="min-w-0 flex-1 font-medium">{__("Newsfeed")}</span>
                <span class="icon-[tabler--circle-check-filled] size-5 shrink-0 text-primary opacity-0 group-has-checked:opacity-100" aria-hidden="true"></span>
              </label>
              <label class="group flex cursor-pointer items-center gap-3 rounded-field border border-base-300 p-4 transition-colors hover:border-primary/40 has-checked:border-primary has-checked:bg-primary/5 has-focus-visible:ring-2 has-focus-visible:ring-primary/30">
                <input type="radio" class="sr-only" name="ads_placement" value="sidebar" {if $campaign['ads_placement'] == "sidebar"}checked{/if}>
                <span class="flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-base-content/70 group-has-checked:bg-primary/10 group-has-checked:text-primary">
                  <span class="icon-[tabler--layout-sidebar-right] size-5" aria-hidden="true"></span>
                </span>
                <span class="min-w-0 flex-1 font-medium">{__("Sidebar")}</span>
                <span class="icon-[tabler--circle-check-filled] size-5 shrink-0 text-primary opacity-0 group-has-checked:opacity-100" aria-hidden="true"></span>
              </label>
            </div>
          </fieldset>

          <div>
            <label class="label-text mb-2 block" for="ads_title">{__("Ads Title")}</label>
            <input type="text" class="input w-full" name="ads_title" id="ads_title" value="{$campaign['ads_title']}">
            <span class="mt-2 block text-xs text-base-content/60">{__("Set a title for your ads")}</span>
          </div>
          <div>
            <label class="label-text mb-2 block" for="ads_description">{__("Ads Description")}</label>
            <textarea class="textarea w-full" name="ads_description" id="ads_description" rows="4">{$campaign['ads_description']}</textarea>
            <div class="mt-2 flex items-start justify-between gap-3 text-xs text-base-content/60">
              <span>{__("Set a description for your ads (maximum 200 characters)")}</span>
              <span class="shrink-0 tabular-nums"><span id="js_ads-description-count">0</span>/200</span>
            </div>
          </div>

          <div class="grid gap-5 sm:grid-cols-2">
            <div class="{if $campaign['ads_type'] == 'post'}hidden{/if}" id="js_campaign-image">
              <span class="label-text mb-2 block" id="ads-image-label">{__("Ads Image")}</span>
              {include file='__x_image.tpl' _x_name="ads_image" _x_value=$campaign['ads_image'] _x_class="aspect-video w-full"}
              <span class="mt-2 block text-xs text-base-content/60">{__("Maximum file size is")} {$system['max_photo_size']/1024}{__("MB")}</span>
            </div>
            <div class="{if $campaign['ads_type'] == 'post'}hidden{/if}" id="js_campaign-video">
              <span class="label-text mb-2 block" id="ads-video-label">{__("Or")} {__("Ads Video")}</span>
              {include file='__x_image.tpl' _x_name="ads_video" _x_value=$campaign['ads_video'] _x_handle="x-video" _x_type="video" _x_class="aspect-video w-full"}
              <span class="mt-2 block text-xs text-base-content/60">{__("Maximum file size is")} {$system['max_video_size']/1024}{__("MB")}</span>
            </div>
          </div>
        </div>
      </section>
      <!-- ads details -->

    </div>

    <!-- campaign summary -->
    <aside class="flex min-w-0 flex-col gap-4 lg:sticky lg:top-24">
      {if $user->_data['user_wallet_balance'] == 0}
        <div class="alert alert-soft alert-error flex items-start gap-3" role="alert">
          <span class="icon-[tabler--wallet-off] mt-0.5 size-5 shrink-0" aria-hidden="true"></span>
          <span>
            {__("Your current wallet credit is")}: <strong>{print_money($user->_data['user_wallet_balance'])}</strong>
            {__("You need to")} <a class="font-medium text-inherit! underline" href="{$system['system_url']}/wallet">{__("Replenish your wallet credit")}</a>
          </span>
        </div>
      {/if}

      {if $system['ads_approval_enabled']}
        <div class="alert alert-soft alert-warning flex items-start gap-3" role="alert">
          <span class="icon-[tabler--clock-check] mt-0.5 size-5 shrink-0" aria-hidden="true"></span>
          <span>{__("Your campaign will need to be approved by admin before publishing")}</span>
        </div>
      {/if}

      <!-- ads preview -->
      <section class="card border border-base-300 bg-base-100 p-5 shadow-none" aria-labelledby="ads-preview-title">
        <div class="mb-4 flex items-center justify-between gap-2">
          <h2 id="ads-preview-title" class="font-semibold">{__("Preview")}</h2>
          <span class="badge badge-warning gap-1 rounded-full">
            <span class="icon-[tabler--speakerphone] size-3.5" aria-hidden="true"></span>
            {__("Sponsored")}
          </span>
        </div>
        <div id="js_campaign-preview">
          <div class="js_campaign-preview-ad {if $campaign['ads_type'] == 'post'}hidden{/if}">
            <div class="overflow-hidden rounded-field border border-base-300">
              <div class="relative flex aspect-video items-center justify-center bg-base-200 text-base-content/30">
                <img class="js_campaign-preview-image size-full object-cover {if !$campaign['ads_image']}hidden{/if}" {if $campaign['ads_image']}src="{$system['system_uploads']}/{$campaign['ads_image']}"{/if} alt="">
                <video class="js_campaign-preview-video size-full object-cover {if $campaign['ads_image'] || !$campaign['ads_video']}hidden{/if}" {if !$campaign['ads_image'] && $campaign['ads_video']}src="{$system['system_uploads']}/{$campaign['ads_video']}"{/if} autoplay muted loop playsinline></video>
                <span class="js_campaign-preview-placeholder icon-[tabler--photo] size-10 {if $campaign['ads_image'] || $campaign['ads_video']}hidden{/if}" aria-hidden="true"></span>
              </div>
              <div class="p-4">
                <p class="js_campaign-preview-title break-words font-semibold" data-placeholder="{__("Ads Title")}">{if $campaign['ads_title']}{$campaign['ads_title']}{else}{__("Ads Title")}{/if}</p>
                <p class="js_campaign-preview-description mt-1 break-words text-sm text-base-content/60" data-placeholder="{__("Ads Description")}">{if $campaign['ads_description']}{$campaign['ads_description']|truncate:200}{else}{__("Ads Description")}{/if}</p>
              </div>
            </div>
          </div>
          <div class="js_campaign-preview-post {if $campaign['ads_type'] != 'post'}hidden{/if}">
            {if $campaign['ads_type'] == "post" && $campaign['ads_post']}
              {include file='__feeds_post.tpl' post=$campaign['ads_post'] standalone=true}
            {else}
              <div class="flex flex-col items-center gap-3 rounded-field border border-dashed border-base-300 px-4 py-10 text-center text-sm text-base-content/60">
                <span class="icon-[tabler--news] size-8" aria-hidden="true"></span>
                {__("Enter your post URL you want to advertise for")}
              </div>
            {/if}
          </div>
        </div>
      </section>
      <!-- ads preview -->

      <!-- potential reach -->
      <section class="card border border-base-300 bg-base-100 p-5 shadow-none" aria-labelledby="ads-reach-title">
        <div class="flex items-center justify-between gap-2">
          <h2 id="ads-reach-title" class="font-semibold">{__("Potential Reach")}</h2>
          <div class="hidden" id="js_ads-potential-reach-loader">
            <span class="loading loading-spinner loading-sm text-primary"></span>
          </div>
        </div>
        <div class="mt-3 flex items-center gap-3">
          <span class="flex size-11 shrink-0 items-center justify-center rounded-2xl bg-info/10 text-info">
            <span class="icon-[tabler--users] size-5.5" aria-hidden="true"></span>
          </span>
          <div class="min-w-0">
            <span class="block text-2xl font-semibold tracking-tight" id="js_ads-potential-reach">{if $view == "edit"}{$campaign['campaign_potential_reach']}{else}{$potential_reach}{/if}</span>
            <span class="text-sm text-base-content/60">{__("People")}</span>
          </div>
        </div>
      </section>
      <!-- potential reach -->

      <div class="flex flex-col gap-3">
        <button type="submit" class="heroui button button--primary button--lg button--full-width rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]">
          {if $view == "edit"}{__("Save Changes")}{else}{__("Publish")}{/if}
        </button>

        <!-- success -->
        <div class="alert alert-success hidden"></div>
        <!-- success -->

        <!-- error -->
        <div class="alert alert-danger alert-error hidden"></div>
        <!-- error -->
      </div>
    </aside>
    <!-- campaign summary -->

  </div>
</form>
<!-- campaign form -->
