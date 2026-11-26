<!-- page settings -->
<div class="flex flex-col gap-6 lg:flex-row lg:items-start">
  <aside class="w-full shrink-0 lg:w-64">
    <nav class="card rounded-3xl border border-base-300 bg-base-100 p-3 shadow-none" aria-label='{__("Page Settings")}'>
      <ul class="menu w-full gap-1 p-0 text-sm font-medium [--radius-field:1rem]">
        <li class="menu-title px-4 pt-1 pb-2 text-[11px]! font-medium! uppercase tracking-wider text-base-content/40!"><span>{__("Page Settings")}</span></li>
        {include file='__settings_nav_item.tpl' _icon="icon-[tabler--settings]" _active=($sub_view == '') _url="{$system['system_url']}/pages/{$spage['page_name']}/settings" _title=__("Settings")}
        {include file='__settings_nav_item.tpl' _icon="icon-[tabler--info-circle]" _active=($sub_view == 'info') _url="{$system['system_url']}/pages/{$spage['page_name']}/settings/info" _title=__("Information")}
        {include file='__settings_nav_item.tpl' _icon="icon-[tabler--user-shield]" _active=($sub_view == 'admins') _url="{$system['system_url']}/pages/{$spage['page_name']}/settings/admins" _title=__("Admins")}
        {if $system['pages_messages_enabled']}
          <li>
            <a href="{$system['system_url']}/pages/{$spage['page_name']}/settings/messages" class="{if $sub_view == 'messages'}menu-active{else}text-base-content!{/if}" {if $sub_view == 'messages'}aria-current="page" {/if}>
              <span class="icon-[tabler--message-circle] size-5 shrink-0" aria-hidden="true"></span>
              <span class="grow">{__("Messages")}</span>
              {if $spage['unseen_messages_count'] > 0}
                <span class="js_page-inbox-counter badge badge-primary badge-sm rounded-full">{$spage['unseen_messages_count']}</span>
              {/if}
            </a>
          </li>
        {/if}
        {if $user->_data['can_monetize_content']}
          {include file='__settings_nav_item.tpl' _icon="icon-[tabler--coin]" _active=($sub_view == 'monetization' && $show != 'coupons') _url="{$system['system_url']}/pages/{$spage['page_name']}/settings/monetization?show=settings" _title=__("Monetization")}
          {include file='__settings_nav_item.tpl' _icon="icon-[tabler--ticket]" _active=($sub_view == 'monetization' && $show == 'coupons') _url="{$system['system_url']}/pages/{$spage['page_name']}/settings/monetization?show=coupons" _title=__("Coupons")}
        {/if}
        {if $system['verification_requests']}
          {include file='__settings_nav_item.tpl' _icon="icon-[tabler--rosette-discount-check]" _active=($sub_view == 'verification') _url="{$system['system_url']}/pages/{$spage['page_name']}/settings/verification" _title=__("Verification")}
        {/if}
        {if $user->_data['user_id'] == $spage['page_admin']}
          {include file='__settings_nav_item.tpl' _danger=true _icon="icon-[tabler--trash]" _active=($sub_view == 'delete') _url="{$system['system_url']}/pages/{$spage['page_name']}/settings/delete" _title=__("Delete Page")}
        {/if}
      </ul>
    </nav>
  </aside>
  <div class="min-w-0 flex-1 space-y-6">
    {if $sub_view == ''}
      <div class="card rounded-3xl border border-base-300 bg-base-100 shadow-none">
        <form class="js_ajax-forms" data-url="modules/create.php?type=page&do=edit&edit=settings&id={$spage['page_id']}">
          {include file='__settings_card_header.tpl' _icon="icon-[tabler--settings]" _title=__("Page Settings") _text=__("Manage your page details")}
          <div class="card-body gap-6 pt-6">
            <div class="w-full">
              <label class="label-text mb-1.5 block" for="page-title">{__("Name Your Page")}</label>
              <input type="text" class="input w-full" id="page-title" name="title" value="{$spage['page_title']}">
            </div>

            <div class="w-full">
              <label class="label-text mb-1.5 block" for="page-username">{__("Page Username")}</label>
              <div class="join w-full" dir="ltr">
                <span class="join-item flex min-w-10 max-w-64 shrink-0 items-center border border-e-0 border-base-300 bg-base-200 px-3 text-sm text-base-content/60">
                  <span class="truncate whitespace-nowrap" title="{$system['system_url']}/pages/">{$system['system_url']}/pages/</span>
                </span>
                <input type="text" class="input join-item min-w-0 flex-1" id="page-username" name="username" value="{$spage['page_name']}" aria-describedby="page-username-help">
              </div>
              <p id="page-username-help" class="helper-text">{__("Can only contain alphanumeric characters (A–Z, 0–9) and periods ('.')")}</p>
            </div>

            <div class="w-full">
              <label class="label-text mb-1.5 block" for="page-category">{__("Category")}</label>
              <select class="select w-full" id="page-category" name="category">
                <option>{__("Select Category")}</option>
                {foreach $categories as $category}
                  {include file='__categories.recursive_options.tpl' data_category=$spage['page_category']}
                {/foreach}
              </select>
            </div>

            {if $user->_data['can_receive_tip'] || $system['pages_messages_enabled']}
              <!-- general -->
              <div class="flex flex-col divide-y divide-base-300 overflow-hidden rounded-xl border border-base-300">
                {if $user->_data['can_receive_tip']}
                  <div class="flex items-center gap-4 p-4">
                    <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200" aria-hidden="true">
                      {include file='__svg_icons.tpl' icon="tip" class="main-icon" width="24px" height="24px"}
                    </span>
                    <div class="min-w-0 grow">
                      <div class="text-sm font-medium" id="page_tips_enabled-label">{__("Tips Enabled")}</div>
                      <p class="mt-0.5 hidden text-sm text-base-content/60 sm:block">{__("Allow the send tips button on your page")}</p>
                    </div>
                    <input class="switch switch-primary shrink-0 [--radius-selector:9999px]" aria-labelledby="page_tips_enabled-label" type="checkbox" name="page_tips_enabled" id="page_tips_enabled" {if $spage['page_tips_enabled']}checked{/if}>
                  </div>
                {/if}
                {if $system['pages_messages_enabled']}
                  <div class="flex items-center gap-4 p-4">
                    <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200" aria-hidden="true">
                      {include file='__svg_icons.tpl' icon="chat" class="main-icon" width="24px" height="24px"}
                    </span>
                    <div class="min-w-0 grow">
                      <div class="text-sm font-medium" id="page_messages_enabled-label">{__("Messages Enabled")}</div>
                      <p class="mt-0.5 hidden text-sm text-base-content/60 sm:block">{__("Allow people to message your page")}</p>
                    </div>
                    <input class="switch switch-primary shrink-0 [--radius-selector:9999px]" aria-labelledby="page_messages_enabled-label" type="checkbox" name="page_messages_enabled" id="page_messages_enabled" {if $spage['page_messages_enabled']}checked{/if}>
                  </div>
                {/if}
              </div>
              <!-- general -->
            {/if}

            <!-- error -->
            <div class="alert alert-error alert-danger hidden items-center" role="alert"></div>
            <!-- error -->
          </div>
          <div class="card-footer flex justify-end gap-3 border-t border-base-300 pt-6">
            <button type="submit" class="heroui button button--primary w-full sm:w-auto rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]">{__("Save Changes")}</button>
          </div>
        </form>
      </div>
    {elseif $sub_view == 'info'}
      <div class="card rounded-3xl border border-base-300 bg-base-100 shadow-none">
        <form class="js_ajax-forms" data-url="modules/create.php?type=page&do=edit&edit=info&id={$spage['page_id']}">
          {include file='__settings_card_header.tpl' _icon="icon-[tabler--info-circle]" _title=__("Page Information")}
          <div class="card-body gap-6 pt-6">
            <div class="grid gap-6 sm:grid-cols-2">
              <div class="w-full">
                <label class="label-text mb-1.5 block" for="page-company">{__("Company")}</label>
                <div class="input w-full items-center gap-2">
                  <span class="icon-[tabler--building] size-5 shrink-0 text-base-content/50" aria-hidden="true"></span>
                  <input type="text" class="grow" id="page-company" name="company" value="{$spage['page_company']}">
                </div>
              </div>

              <div class="w-full">
                <label class="label-text mb-1.5 block" for="page-phone">{__("Phone")}</label>
                <div class="input w-full items-center gap-2">
                  <span class="icon-[tabler--phone] size-5 shrink-0 text-base-content/50" aria-hidden="true"></span>
                  <input type="text" class="grow" id="page-phone" name="phone" value="{$spage['page_phone']}" dir="ltr">
                </div>
              </div>

              <div class="w-full">
                <label class="label-text mb-1.5 block" for="page-website">{__("Website")}</label>
                <div class="input w-full items-center gap-2">
                  <span class="icon-[tabler--world] size-5 shrink-0 text-base-content/50" aria-hidden="true"></span>
                  <input type="text" class="grow" id="page-website" name="website" value="{$spage['page_website']}" placeholder="https://" dir="ltr">
                </div>
                <span class="helper-text">{__("Website link must start with http:// or https://")}</span>
              </div>

              <div class="w-full">
                <label class="label-text mb-1.5 block" for="page-location">{__("Location")}</label>
                <div class="input w-full items-center gap-2">
                  <span class="icon-[tabler--map-pin] size-5 shrink-0 text-base-content/50" aria-hidden="true"></span>
                  <input type="text" class="grow js_geocomplete" id="page-location" name="location" value="{$spage['page_location']}" autocomplete="off">
                </div>
                <input type="hidden" name="latitude" data-geo="lat" value="{$spage['page_latitude']}">
                <input type="hidden" name="longitude" data-geo="lng" value="{$spage['page_longitude']}">
              </div>

              <div class="w-full">
                <label class="label-text mb-1.5 block" for="page-country">{__("Country")}</label>
                <select class="select w-full" id="page-country" name="country">
                  <option value="none">{__("Select Country")}</option>
                  {foreach $countries as $country}
                    <option value="{$country['country_id']}" {if $spage['page_country'] == $country['country_id']}selected{/if}>{$country['country_name_with_flag']}</option>
                  {/foreach}
                </select>
              </div>

              <div class="w-full">
                <label class="label-text mb-1.5 block" for="page-language">{__("Language")}</label>
                <select class="select w-full" id="page-language" name="language">
                  <option value="none">{__("Select Language")}</option>
                  {foreach $languages as $language}
                    <option value="{$language['language_id']}" {if $spage['page_language'] == $language['language_id']}selected{/if}>{$language['title']}</option>
                  {/foreach}
                </select>
              </div>
            </div>

            <div class="w-full">
              <label class="label-text mb-1.5 block" for="page-description">{__("About")}</label>
              <textarea class="textarea w-full" id="page-description" name="description" rows="4" dir="auto">{$spage['page_description']}</textarea>
            </div>

            {if $custom_fields['basic']}
              {include file='__custom_fields.tpl' _custom_fields=$custom_fields['basic'] _registration=false}
            {/if}

            <!-- error -->
            <div class="alert alert-error alert-danger hidden items-center" role="alert"></div>
            <!-- error -->
          </div>
          <div class="card-footer flex justify-end gap-3 border-t border-base-300 pt-6">
            <button type="submit" class="heroui button button--primary w-full sm:w-auto rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]">{__("Save Changes")}</button>
          </div>
        </form>
      </div>

      <div class="card rounded-3xl border border-base-300 bg-base-100 shadow-none">
        <form class="js_ajax-forms" data-url="modules/create.php?type=page&do=edit&edit=action&id={$spage['page_id']}">
          {include file='__settings_card_header.tpl' _icon="icon-[tabler--click]" _title=__("Action Button")}
          <div class="card-body gap-6 pt-6">
            <div class="grid gap-6 sm:grid-cols-2">
              <div class="w-full">
                <label class="label-text mb-1.5 block" for="page-action-text">{__("Action Button Text")}</label>
                <input type="text" class="input w-full" id="page-action-text" name="action_text" value="{$spage['page_action_text']}">
              </div>

              <div class="w-full">
                <label class="label-text mb-1.5 block" for="page-action-url">{__("Action Button URL")}</label>
                <div class="input w-full items-center gap-2">
                  <span class="icon-[tabler--link] size-5 shrink-0 text-base-content/50" aria-hidden="true"></span>
                  <input type="text" class="grow" id="page-action-url" name="action_url" value="{$spage['page_action_url']}" placeholder="https://" dir="ltr">
                </div>
              </div>
            </div>

            <fieldset class="w-full">
              <legend class="label-text mb-1.5 block">{__("Action Button Color")}</legend>
              <div class="flex flex-wrap gap-2">
                {foreach ['light','primary','success','info','warning','danger'] as $_color}
                  <label class="cursor-pointer">
                    <input type="radio" class="peer sr-only" name="action_color" value="{$_color}" {if $spage['page_action_color'] == $_color}checked{/if}>
                    <span class="inline-flex min-h-10 items-center rounded-xl border-2 border-transparent px-3 text-sm font-medium peer-checked:border-primary peer-focus-visible:outline-2 peer-focus-visible:outline-primary {if $_color == 'danger'}bg-error/15 text-error{elseif $_color == 'light'}bg-base-200{elseif $_color == 'primary'}bg-primary/15 text-primary{elseif $_color == 'success'}bg-success/15 text-success{elseif $_color == 'info'}bg-info/15 text-info{else}bg-warning/15 text-warning{/if}">{$_color|capitalize}</span>
                  </label>
                {/foreach}
              </div>
            </fieldset>

            <!-- error -->
            <div class="alert alert-error alert-danger hidden items-center" role="alert"></div>
            <!-- error -->
          </div>
          <div class="card-footer flex justify-end gap-3 border-t border-base-300 pt-6">
            <button type="submit" class="heroui button button--primary w-full sm:w-auto rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]">{__("Save Changes")}</button>
          </div>
        </form>
      </div>

      <div class="card rounded-3xl border border-base-300 bg-base-100 shadow-none">
        <form class="js_ajax-forms" data-url="modules/create.php?type=page&do=edit&edit=social&id={$spage['page_id']}">
          {include file='__settings_card_header.tpl' _icon="icon-[tabler--share]" _title=__("Social Links")}
          <div class="card-body gap-6 pt-6">
            <div class="grid gap-6 sm:grid-cols-2">
              {foreach [['facebook', __("Facebook Profile URL"), 'facebook', 'https://facebook.com/'], ['twitter', __("X Profile URL"), 'x', 'https://x.com/'], ['youtube', __("YouTube Profile URL"), 'youtube', 'https://youtube.com/@'], ['instagram', __("Instagram Profile URL"), 'instagram', 'https://instagram.com/'], ['linkedin', __("LinkedIn Profile URL"), 'linkedin', 'https://linkedin.com/in/'], ['vkontakte', __("Vkontakte Profile URL"), 'vk', 'https://vk.com/']] as $_social}
                {assign var='_social_key' value="page_social_`$_social[0]`"}
                <div class="w-full">
                  <label class="label-text mb-1.5 block" for="page-social-{$_social[0]}">{$_social[1]}</label>
                  <div class="input w-full items-center gap-2">
                    <span class="grid size-5 shrink-0 place-items-center" aria-hidden="true">
                      {include file='__svg_icons.tpl' icon=$_social[2] width="20px" height="20px"}
                    </span>
                    <input type="text" class="grow" id="page-social-{$_social[0]}" name="{$_social[0]}" value="{$spage[$_social_key]}" placeholder="{$_social[3]}" dir="ltr">
                  </div>
                </div>
              {/foreach}
            </div>

            <!-- error -->
            <div class="alert alert-error alert-danger hidden items-center" role="alert"></div>
            <!-- error -->
          </div>
          <div class="card-footer flex justify-end gap-3 border-t border-base-300 pt-6">
            <button type="submit" class="heroui button button--primary w-full sm:w-auto rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]">{__("Save Changes")}</button>
          </div>
        </form>
      </div>
    {elseif $sub_view == 'admins'}
      <div class="card rounded-3xl border border-base-300 bg-base-100 shadow-none">
        <div class="card-header flex flex-wrap items-center gap-3 border-b border-base-300">
          <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-base-content" aria-hidden="true">
            <span class="icon-[tabler--user-shield] size-5"></span>
          </span>
          <div class="min-w-0 grow">
            <h2 class="card-title text-lg">{__("Admins")}</h2>
          </div>
          <span class="badge badge-soft rounded-full ms-auto shrink-0">{$spage['page_admins_count']}</span>
        </div>
        <div class="card-body gap-6 pt-6">
          {if $spage['page_admins']}
            <div class="flex flex-col gap-3">
              <ul class="flex flex-col gap-1">
                {foreach $spage['page_admins'] as $_user}
                  {include file='__feeds_user.tpl' _tpl='list' _connection=$_user['connection']}
                {/foreach}
              </ul>

              <!-- see-more -->
              {if $spage['page_admins_count'] >= $system['max_results_even']}
                <div class="see-more js_see-more flex cursor-pointer items-center justify-center gap-2 rounded-box border border-base-300 bg-base-100 py-3 text-sm font-semibold transition-colors hover:border-primary/30 hover:bg-primary/5 hover:text-primary" data-get="page_admins" data-id="{$spage['page_id']}">
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
          <span class="badge badge-soft rounded-full ms-auto shrink-0">{$spage['page_likes']}</span>
        </div>
        <div class="card-body gap-6 pt-6">
          {if $spage['page_likes'] > 0}
            <div class="flex flex-col gap-3">
              <ul class="flex flex-col gap-1">
                {foreach $spage['members'] as $_user}
                  {include file='__feeds_user.tpl' _tpl='list' _connection=$_user['connection']}
                {/foreach}
              </ul>

              <!-- see-more -->
              {if $spage['page_likes'] >= $system['max_results_even']}
                <div class="see-more js_see-more flex cursor-pointer items-center justify-center gap-2 rounded-box border border-base-300 bg-base-100 py-3 text-sm font-semibold transition-colors hover:border-primary/30 hover:bg-primary/5 hover:text-primary" data-get="page_members" data-id="{$spage['page_id']}">
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
    {elseif $sub_view == 'messages'}
      {include file='__page_settings_messages.tpl'}
    {elseif $sub_view == 'monetization'}
      {include file='__page_settings_monetization.tpl'}
    {elseif $sub_view == 'verification'}
      {include file='__page_settings_verification.tpl'}
    {elseif $sub_view == 'delete'}
      <div class="card rounded-3xl border border-base-300 bg-base-100 shadow-none">
        {include file='__settings_card_header.tpl' _icon="icon-[tabler--trash]" _title=__("Delete Page")}
        <div class="card-body gap-6 pt-6">
          <!-- danger zone -->
          <div class="flex flex-col gap-4 rounded-xl border border-error/30 bg-error/5 p-4 sm:flex-row sm:items-center sm:p-5">
            <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-error/10 text-error" aria-hidden="true">
              <span class="icon-[tabler--alert-triangle] size-5"></span>
            </span>
            <div class="min-w-0 grow">
              <div class="text-sm font-semibold text-error">{__("Delete Page")}</div>
              <p class="mt-0.5 text-sm text-base-content/70">{__("Once you delete your page you will no longer can access it again")}</p>
            </div>
            <button type="button" class="heroui button button--danger w-full shrink-0 sm:w-auto js_delete-page rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" data-id="{$spage['page_id']}">
              <span class="icon-[tabler--trash] size-4" aria-hidden="true"></span>
              {__("Delete Page")}
            </button>
          </div>
          <!-- danger zone -->
        </div>
      </div>
    {/if}
  </div>
</div>
<!-- page settings -->
