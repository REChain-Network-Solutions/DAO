<!-- panel [about] -->
<section class="js_translate-wrapper card overflow-hidden rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-[#F9F9F9] shadow-none dark:bg-base-300">
  <div class="flex items-center gap-3 px-5 py-3.5">
    <h2 class="min-w-0 grow truncate text-sm font-semibold" title="{__("About")}">{__("About")}</h2>
    {if $system['post_translation_enabled'] && $system['biography_info_enabled'] && !is_empty($profile['user_biography'])}
      <button type="button" class="js_translator js_translator-description inline-flex size-6 shrink-0 cursor-pointer items-center justify-center rounded-full text-base-content/55 transition-colors hover:bg-base-200 hover:text-primary focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary" data-node-type="user" data-node-id="{$profile['user_id']}" data-source=".profile-biography-text" data-translation=".post-text-translation" title="{__("Translate")}" aria-label="{__("Translate")}">
        <span class="icon-[tabler--language] size-4" aria-hidden="true"></span>
      </button>
    {/if}
  </div>
  <div class="card-body gap-5 rounded-t-3xl corner-squircle supports-[corner-shape:squircle]:rounded-t-[2.5rem] bg-base-100 p-5">

    <!-- bio -->
    {if $system['biography_info_enabled'] && !is_empty($profile['user_biography'])}
      <div class="border-b border-base-300 pb-5 text-sm leading-relaxed [overflow-wrap:anywhere] text-base-content/70">
        <div class="js_readmore profile-biography-text" data-lines="6" dir="auto">
          {$profile['user_biography']|nl2br}
        </div>
        <div class="post-text-translation mt-2 hidden border-s-2 border-base-300 ps-3 text-start" dir="auto"></div>
      </div>
    {/if}
    <!-- bio -->

    <!-- info -->
    <ul class="space-y-3.5 text-sm leading-relaxed break-words [&_a]:text-primary [&_a]:hover:underline">
      {if $system['work_info_enabled'] && $profile['user_work_title']}
        {if $profile['user_id'] == $user->_data['user_id'] || $profile['user_privacy_work'] == "public" || ($profile['user_privacy_work'] == "friends" && $profile['we_friends'])}
          <li class="flex items-start gap-3">
            <span class="icon-[tabler--briefcase] mt-0.5 size-5 shrink-0 text-base-content/50" aria-hidden="true"></span>
            <div class="min-w-0">
              {$profile['user_work_title']}
              {if $profile['user_work_place']}
                {__("at")}
                {if $profile['user_work_url']}
                  <a target="_blank" href="{$profile['user_work_url']}">{$profile['user_work_place']}</a>
                {else}
                  <span class="font-medium">{$profile['user_work_place']}</span>
                {/if}
              {/if}
            </div>
          </li>
        {/if}
      {/if}
      {if $system['location_info_enabled']}
        {if $profile['user_id'] == $user->_data['user_id'] || $profile['user_privacy_location'] == "public" || ($profile['user_privacy_location'] == "friends" && $profile['we_friends'])}
          {if $profile['user_current_city']}
            <li class="flex items-start gap-3">
              <span class="icon-[tabler--home] mt-0.5 size-5 shrink-0 text-base-content/50" aria-hidden="true"></span>
              <div class="min-w-0">{__("Lives in")} <span class="font-medium">{$profile['user_current_city']}</span></div>
            </li>
          {/if}
          {if $profile['user_hometown']}
            <li class="flex items-start gap-3">
              <span class="icon-[tabler--map-pin] mt-0.5 size-5 shrink-0 text-base-content/50" aria-hidden="true"></span>
              <div class="min-w-0">{__("From")} <span class="font-medium">{$profile['user_hometown']}</span></div>
            </li>
          {/if}
        {/if}
      {/if}
      {if $system['education_info_enabled'] && $profile['user_edu_major']}
        {if $profile['user_id'] == $user->_data['user_id'] || $profile['user_privacy_education'] == "public" || ($profile['user_privacy_education'] == "friends" && $profile['we_friends'])}
          <li class="flex items-start gap-3">
            <span class="icon-[tabler--school] mt-0.5 size-5 shrink-0 text-base-content/50" aria-hidden="true"></span>
            <div class="min-w-0">
              {__("Studied")} {$profile['user_edu_major']}
              {__("at")} <span class="font-medium">{$profile['user_edu_school']}</span>
              {if $profile['user_edu_class']}
                <div class="text-xs text-base-content/60">{__("Class of")} {$profile['user_edu_class']}</div>
              {/if}
            </div>
          </li>
        {/if}
      {/if}
      {if !$system['genders_disabled']}
        {if $profile['user_id'] == $user->_data['user_id'] || $profile['user_privacy_gender'] == "public" || ($profile['user_privacy_gender'] == "friends" && $profile['we_friends'])}
          <li class="flex items-start gap-3">
            <span class="icon-[tabler--gender-bigender] mt-0.5 size-5 shrink-0 text-base-content/50" aria-hidden="true"></span>
            <div class="min-w-0">{$profile['user_gender']}</div>
          </li>
        {/if}
      {/if}
      {if $system['relationship_info_enabled'] && $profile['user_relationship']}
        {if $profile['user_id'] == $user->_data['user_id'] || $profile['user_privacy_relationship'] == "public" || ($profile['user_privacy_relationship'] == "friends" && $profile['we_friends'])}
          <li class="flex items-start gap-3">
            <span class="icon-[tabler--heart] mt-0.5 size-5 shrink-0 text-base-content/50" aria-hidden="true"></span>
            <div class="min-w-0">
              {if $profile['user_relationship'] == "relationship"}
                {__("In a relationship")}
              {elseif $profile['user_relationship'] == "complicated"}
                {__("It's complicated")}
              {else}
                {__($profile['user_relationship']|ucfirst)}
              {/if}
            </div>
          </li>
        {/if}
      {/if}
      {if $profile['user_birthdate'] != null}
        {if $profile['user_id'] == $user->_data['user_id'] || $profile['user_privacy_birthdate'] == "public" || ($profile['user_privacy_birthdate'] == "friends" && $profile['we_friends'])}
          <li class="flex items-start gap-3">
            <span class="icon-[tabler--cake] mt-0.5 size-5 shrink-0 text-base-content/50" aria-hidden="true"></span>
            <div class="min-w-0">{__($profile['user_birthdate']|date_format:"%B")} {$profile['user_birthdate']|date_format:"%e"|trim}, {$profile['user_birthdate']|date_format:"%Y"}</div>
          </li>
        {/if}
      {/if}
      {if $system['website_info_enabled'] && $profile['user_website']}
        <li class="flex items-start gap-3">
          <span class="icon-[tabler--world] mt-0.5 size-5 shrink-0 text-base-content/50" aria-hidden="true"></span>
          <div class="min-w-0 [overflow-wrap:anywhere]"><a target="_blank" href="{$profile['user_website']}">{$profile['user_website']}</a></div>
        </li>
      {/if}
      <li class="flex items-start gap-3"><span class="icon-[tabler--news] mt-0.5 size-5 shrink-0 text-base-content/50" aria-hidden="true"></span><div class="min-w-0"><span class="font-medium tabular-nums">{$profile['posts_count']}</span> {__("Posts")}</div></li>
      <li class="flex items-start gap-3"><span class="icon-[tabler--photo] mt-0.5 size-5 shrink-0 text-base-content/50" aria-hidden="true"></span><div class="min-w-0"><span class="font-medium tabular-nums">{$profile['photos_count']}</span> {__("Photos")}</div></li>
      {if $system['videos_enabled'] || $system['reels_enabled']}
        <li class="flex items-start gap-3"><span class="icon-[tabler--video] mt-0.5 size-5 shrink-0 text-base-content/50" aria-hidden="true"></span><div class="min-w-0"><span class="font-medium tabular-nums">{$profile['videos_count'] + $profile['reels_count']}</span> {if $system['videos_enabled']}{__("Videos")}{/if}{if $system['videos_enabled'] && $system['reels_enabled']}/{/if}{if $system['reels_enabled']}{__("Reels")}{/if}</div></li>
      {/if}
      {if $profile['user_registered']}
        <li class="flex items-start gap-3">
          <span class="icon-[tabler--calendar-event] mt-0.5 size-5 shrink-0 text-base-content/50" aria-hidden="true"></span>
          <div class="min-w-0">{__("Joined")} <span class="font-medium">{__($profile['user_registered']|date_format:"%B")} {$profile['user_registered']|date_format:"%e"|trim}, {$profile['user_registered']|date_format:"%Y"}</span></div>
        </li>
      {/if}
    </ul>
    <!-- info -->

    <!-- custom fields -->
    {foreach ['basic', 'work', 'location', 'education', 'other'] as $_cf_group}
      {if $custom_fields[$_cf_group]}
        {if $profile['user_id'] == $user->_data['user_id'] || $profile["user_privacy_{$_cf_group}"] == "public" || ($profile["user_privacy_{$_cf_group}"] == "friends" && $profile['we_friends'])}
          <div class="border-t border-base-300 pt-4">
            <h3 class="mb-3 text-xs font-semibold tracking-wide text-base-content/50 uppercase">
              {if $_cf_group == "basic"}{__("Basic Info")}{elseif $_cf_group == "work"}{__("Work Info")}{elseif $_cf_group == "location"}{__("Location Info")}{elseif $_cf_group == "education"}{__("Education Info")}{else}{__("Other Info")}{/if}
            </h3>
            <dl class="space-y-3 text-sm break-words">
              {foreach $custom_fields[$_cf_group] as $custom_field}
                {if $custom_field['value']}
                  <div>
                    <dt class="text-xs text-base-content/60">{__($custom_field['label'])}</dt>
                    <dd class="mt-0.5">
                      {if $custom_field['type'] == "textbox" && $custom_field['is_link']}
                        <a class="text-primary hover:underline" href="{$custom_field['value']}">{__($custom_field['value']|trim)}</a>
                      {elseif $custom_field['type'] == "multipleselectbox"}
                        {__($custom_field['value_string']|trim)}
                      {else}
                        {__($custom_field['value']|trim)}
                      {/if}
                    </dd>
                  </div>
                {/if}
              {/foreach}
            </dl>
          </div>
        {/if}
      {/if}
    {/foreach}
    <!-- custom fields -->

    <!-- social links -->
    {if $system['social_info_enabled']}
      {include file='__social_links.tpl' _social_node=$profile _social_prefix="user"}
    {/if}
    <!-- social links -->
  </div>
</section>
<!-- panel [about] -->
