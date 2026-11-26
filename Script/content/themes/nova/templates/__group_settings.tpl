<!-- group settings -->
<div class="flex flex-col gap-6 lg:flex-row lg:items-start">
  <aside class="w-full shrink-0 lg:w-64">
    <nav class="card rounded-3xl border border-base-300 bg-base-100 p-3 shadow-none" aria-label='{__("Group Settings")}'>
      <ul class="menu w-full gap-1 p-0 text-sm font-medium [--radius-field:1rem]">
        <li class="menu-title px-4 pt-1 pb-2 text-[11px]! font-medium! uppercase tracking-wider text-base-content/40!"><span>{__("Group Settings")}</span></li>
        {include file='__settings_nav_item.tpl' _icon="icon-[tabler--settings]" _active=($sub_view == '') _url="{$system['system_url']}/groups/{$group['group_name']}/settings" _title=__("Group Settings")}
        {if $group['group_privacy'] != 'public'}
          {include file='__settings_nav_item.tpl' _icon="icon-[tabler--user-question]" _active=($sub_view == 'requests') _url="{$system['system_url']}/groups/{$group['group_name']}/settings/requests" _title=__("Join Requests")}
        {/if}
        {include file='__settings_nav_item.tpl' _icon="icon-[tabler--users]" _active=($sub_view == 'members') _url="{$system['system_url']}/groups/{$group['group_name']}/settings/members" _title=__("Members")}
        {if $user->_data['can_monetize_content']}
          {include file='__settings_nav_item.tpl' _icon="icon-[tabler--coin]" _active=($sub_view == 'monetization' && $show != 'coupons') _url="{$system['system_url']}/groups/{$group['group_name']}/settings/monetization?show=settings" _title=__("Monetization")}
          {include file='__settings_nav_item.tpl' _icon="icon-[tabler--ticket]" _active=($sub_view == 'monetization' && $show == 'coupons') _url="{$system['system_url']}/groups/{$group['group_name']}/settings/monetization?show=coupons" _title=__("Coupons")}
        {/if}
        {if $user->_data['user_id'] == $group['group_admin']}
          {include file='__settings_nav_item.tpl' _danger=true _icon="icon-[tabler--trash]" _active=($sub_view == 'delete') _url="{$system['system_url']}/groups/{$group['group_name']}/settings/delete" _title=__("Delete Group")}
        {/if}
      </ul>
    </nav>
  </aside>
  <div class="min-w-0 flex-1 space-y-6">
    {if $sub_view == ''}
      <div class="card rounded-3xl border border-base-300 bg-base-100 shadow-none">
        <form class="js_ajax-forms" data-url="modules/create.php?type=group&do=edit&edit=settings&id={$group['group_id']}">
          {include file='__settings_card_header.tpl' _icon="icon-[tabler--settings]" _title=__("Group Settings")}
          <div class="card-body gap-6 pt-6">
            <div class="w-full">
              <label class="label-text mb-1.5 block" for="group-title">{__("Name Your Group")}</label>
              <input type="text" class="input w-full" id="group-title" name="title" placeholder='{__("Name of your group")}' value="{$group['group_title']}">
            </div>

            <div class="w-full">
              <label class="label-text mb-1.5 block" for="group-username">{__("Group Username")}</label>
              <div class="join w-full" dir="ltr">
                <span class="join-item flex min-w-10 max-w-64 shrink-0 items-center border border-e-0 border-base-300 bg-base-200 px-3 text-sm text-base-content/60">
                  <span class="truncate whitespace-nowrap" title="{$system['system_url']}/groups/">{$system['system_url']}/groups/</span>
                </span>
                <input type="text" class="input join-item min-w-0 flex-1" id="group-username" name="username" value="{$group['group_name']}" aria-describedby="group-username-help">
              </div>
              <p id="group-username-help" class="helper-text">{__("Can only contain alphanumeric characters (A–Z, 0–9) and periods ('.')")}</p>
            </div>

            <div class="grid gap-6 sm:grid-cols-2">
              <div class="w-full">
                <label class="label-text mb-1.5 block" for="group-privacy">{__("Select Privacy")}</label>
                <select class="select w-full" id="group-privacy" name="privacy">
                  <option value="public" {if $group['group_privacy'] == 'public'}selected{/if}>{__("Public Group")}</option>
                  <option value="closed" {if $group['group_privacy'] == 'closed'}selected{/if}>{__("Closed Group")}</option>
                  <option value="secret" {if $group['group_privacy'] == 'secret'}selected{/if}>{__("Secret Group")}</option>
                </select>
                <p class="helper-text">{__("Note: Change group privacy to public will approve any pending join requests")}</p>
              </div>

              <div class="w-full">
                <label class="label-text mb-1.5 block" for="group-category">{__("Category")}</label>
                <select class="select w-full" id="group-category" name="category">
                  {foreach $categories as $category}
                    {include file='__categories.recursive_options.tpl' data_category=$group['group_category']}
                  {/foreach}
                </select>
              </div>

              <div class="w-full">
                <label class="label-text mb-1.5 block" for="group-country">{__("Country")}</label>
                <select class="select w-full" id="group-country" name="country">
                  <option value="none">{__("Select Country")}</option>
                  {foreach $countries as $country}
                    <option value="{$country['country_id']}" {if $group['group_country'] == $country['country_id']}selected{/if}>{$country['country_name_with_flag']}</option>
                  {/foreach}
                </select>
              </div>

              <div class="w-full">
                <label class="label-text mb-1.5 block" for="group-language">{__("Language")}</label>
                <select class="select w-full" id="group-language" name="language">
                  <option value="none">{__("Select Language")}</option>
                  {foreach $languages as $language}
                    <option value="{$language['language_id']}" {if $group['group_language'] == $language['language_id']}selected{/if}>{$language['title']}</option>
                  {/foreach}
                </select>
              </div>
            </div>

            <div class="w-full">
              <label class="label-text mb-1.5 block" for="group-description">{__("About")}</label>
              <textarea class="textarea w-full" id="group-description" name="description" rows="4" dir="auto">{$group['group_description']}</textarea>
            </div>

            {if $custom_fields['basic']}
              {include file='__custom_fields.tpl' _custom_fields=$custom_fields['basic'] _registration=false}
            {/if}

            <!-- general -->
            <div class="flex flex-col divide-y divide-base-300 overflow-hidden rounded-xl border border-base-300">
              {if $system['chat_enabled']}
                <div class="flex items-center gap-4 p-4">
                  <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200" aria-hidden="true">
                    {include file='__svg_icons.tpl' icon="chat" class="main-icon" width="24px" height="24px"}
                  </span>
                  <div class="min-w-0 grow">
                    <div class="text-sm font-medium" id="chatbox_enabled-label">{__("Chat Box")}</div>
                    <p class="mt-0.5 hidden text-sm text-base-content/60 sm:block">{__("Enable chat box for this group")}</p>
                  </div>
                  <input class="switch switch-primary shrink-0 [--radius-selector:9999px]" aria-labelledby="chatbox_enabled-label" type="checkbox" name="chatbox_enabled" id="chatbox_enabled" {if $group['chatbox_enabled']}checked{/if}>
                </div>
              {/if}
              <div class="flex items-center gap-4 p-4">
                <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200" aria-hidden="true">
                  {include file='__svg_icons.tpl' icon="wall_posts" class="main-icon" width="24px" height="24px"}
                </span>
                <div class="min-w-0 grow">
                  <div class="text-sm font-medium" id="group_publish_enabled-label">{__("Members Can Publish Posts?")}</div>
                  <p class="mt-0.5 hidden text-sm text-base-content/60 sm:block">{__("Members can publish posts or only group admins")}</p>
                </div>
                <input class="switch switch-primary shrink-0 [--radius-selector:9999px]" aria-labelledby="group_publish_enabled-label" type="checkbox" name="group_publish_enabled" id="group_publish_enabled" {if $group['group_publish_enabled']}checked{/if}>
              </div>
              <div class="flex items-center gap-4 p-4">
                <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200" aria-hidden="true">
                  {include file='__svg_icons.tpl' icon="verification" class="main-icon" width="24px" height="24px"}
                </span>
                <div class="min-w-0 grow">
                  <div class="text-sm font-medium" id="group_publish_approval_enabled-label">{__("Post Approval")}</div>
                  <p class="mt-0.5 hidden text-sm text-base-content/60 sm:block">{__("All posts must be approved by a group admin")} ({__("Note: Disable it will approve any pending posts")})</p>
                </div>
                <input class="switch switch-primary shrink-0 [--radius-selector:9999px]" aria-labelledby="group_publish_approval_enabled-label" type="checkbox" name="group_publish_approval_enabled" id="group_publish_approval_enabled" {if $group['group_publish_approval_enabled']}checked{/if}>
              </div>
            </div>
            <!-- general -->

            <!-- error -->
            <div class="alert alert-error alert-danger hidden items-center" role="alert"></div>
            <!-- error -->
          </div>
          <div class="card-footer flex justify-end gap-3 border-t border-base-300 pt-6">
            <button type="submit" class="heroui button button--primary w-full sm:w-auto rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]">{__("Save Changes")}</button>
          </div>
        </form>
      </div>
    {elseif $sub_view == 'requests'}
      <div class="card rounded-3xl border border-base-300 bg-base-100 shadow-none">
        {include file='__settings_card_header.tpl' _icon="icon-[tabler--user-question]" _title=__("Member Requests")}
        <div class="card-body gap-6 pt-6">
          {if $group['requests']}
            <div class="flex flex-col gap-3">
              <ul class="flex flex-col gap-1">
                {foreach $group['requests'] as $_user}
                  {include file='__feeds_user.tpl' _tpl='list' _connection=$_user['connection']}
                {/foreach}
              </ul>

              <!-- see-more -->
              {if count($group['requests']) >= $system['max_results']}
                <div class="see-more js_see-more flex cursor-pointer items-center justify-center gap-2 rounded-box border border-base-300 bg-base-100 py-3 text-sm font-semibold transition-colors hover:border-primary/30 hover:bg-primary/5 hover:text-primary" data-get="group_requests" data-id="{$group['group_id']}">
                  <span>{__("See More")}</span>
                  <div class="loading loading-spinner loading-sm hidden"></div>
                </div>
              {/if}
              <!-- see-more -->
            </div>
          {else}
            {include file='_no_data.tpl' _empty_icon='icon-[tabler--user-question]' _empty_title=__("No Requests")}
          {/if}
        </div>
      </div>
    {elseif $sub_view == 'members'}
      <div class="card rounded-3xl border border-base-300 bg-base-100 shadow-none">
        <div class="card-header flex flex-wrap items-center gap-3 border-b border-base-300">
          <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-base-content" aria-hidden="true">
            <span class="icon-[tabler--user-shield] size-5"></span>
          </span>
          <div class="min-w-0 grow">
            <h2 class="card-title text-lg">{__("Admins")}</h2>
          </div>
          <span class="badge badge-soft rounded-full ms-auto shrink-0">{$group['group_admins_count']}</span>
        </div>
        <div class="card-body gap-6 pt-6">
          {if $group['group_admins']}
            <div class="flex flex-col gap-3">
              <ul class="flex flex-col gap-1">
                {foreach $group['group_admins'] as $_user}
                  {include file='__feeds_user.tpl' _tpl='list' _connection=$_user['connection']}
                {/foreach}
              </ul>

              <!-- see-more -->
              {if $group['group_admins_count'] >= $system['max_results_even']}
                <div class="see-more js_see-more flex cursor-pointer items-center justify-center gap-2 rounded-box border border-base-300 bg-base-100 py-3 text-sm font-semibold transition-colors hover:border-primary/30 hover:bg-primary/5 hover:text-primary" data-get="group_admins" data-id="{$group['group_id']}">
                  <span>{__("See More")}</span>
                  <div class="loading loading-spinner loading-sm hidden"></div>
                </div>
              {/if}
              <!-- see-more -->
            </div>
          {else}
            {include file='_no_data.tpl' _empty_icon='icon-[tabler--users]'}
          {/if}
        </div>
      </div>

      <div class="card rounded-3xl border border-base-300 bg-base-100 shadow-none">
        <div class="card-header flex flex-wrap items-center gap-3 border-b border-base-300">
          <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-base-content" aria-hidden="true">
            <span class="icon-[tabler--users] size-5"></span>
          </span>
          <div class="min-w-0 grow">
            <h2 class="card-title text-lg">{__("All Members")}</h2>
          </div>
          <span class="badge badge-soft rounded-full ms-auto shrink-0">{$group['group_members']}</span>
        </div>
        <div class="card-body gap-6 pt-6">
          {if $group['group_members'] > 0}
            <div class="flex flex-col gap-3">
              <ul class="flex flex-col gap-1">
                {foreach $group['members'] as $_user}
                  {include file='__feeds_user.tpl' _tpl='list' _connection=$_user['connection']}
                {/foreach}
              </ul>

              <!-- see-more -->
              {if $group['group_members'] >= $system['max_results_even']}
                <div class="see-more js_see-more flex cursor-pointer items-center justify-center gap-2 rounded-box border border-base-300 bg-base-100 py-3 text-sm font-semibold transition-colors hover:border-primary/30 hover:bg-primary/5 hover:text-primary" data-get="group_members_manage" data-id="{$group['group_id']}">
                  <span>{__("See More")}</span>
                  <div class="loading loading-spinner loading-sm hidden"></div>
                </div>
              {/if}
              <!-- see-more -->
            </div>
          {else}
            {include file='_no_data.tpl' _empty_icon='icon-[tabler--users]'}
          {/if}
        </div>
      </div>
    {elseif $sub_view == 'monetization'}
      {include file='__group_settings_monetization.tpl'}
    {elseif $sub_view == 'delete'}
      <div class="card rounded-3xl border border-base-300 bg-base-100 shadow-none">
        {include file='__settings_card_header.tpl' _icon="icon-[tabler--trash]" _title=__("Delete Group")}
        <div class="card-body gap-6 pt-6">
          <!-- danger zone -->
          <div class="flex flex-col gap-4 rounded-xl border border-error/30 bg-error/5 p-4 sm:flex-row sm:items-center sm:p-5">
            <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-error/10 text-error" aria-hidden="true">
              <span class="icon-[tabler--alert-triangle] size-5"></span>
            </span>
            <div class="min-w-0 grow">
              <div class="text-sm font-semibold text-error">{__("Delete Group")}</div>
              <p class="mt-0.5 text-sm text-base-content/70">{__("Once you delete your group you will no longer can access it again")}</p>
            </div>
            <button type="button" class="heroui button button--danger w-full shrink-0 sm:w-auto js_delete-group rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" data-id="{$group['group_id']}">
              <span class="icon-[tabler--trash] size-4" aria-hidden="true"></span>
              {__("Delete Group")}
            </button>
          </div>
          <!-- danger zone -->
        </div>
      </div>
    {/if}
  </div>
</div>
<!-- group settings -->
