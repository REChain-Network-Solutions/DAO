{include file='__modal_header.tpl' _icon="icon-[tabler--users-group]" _title=__("Create New Group")}
<form class="js_ajax-forms" data-url="modules/create.php?type=group&do=create">
  <div class="modal__body flex flex-col gap-4">
    <!-- name -->
    <div class="min-w-0 w-full">
      <label class="label-text mb-1.5 block px-0" for="title">{__("Name Your Group")}</label>
      <input type="text" class="input w-full [--border:1px]" name="title" id="title">
    </div>
    <!-- name -->
    <!-- username -->
    <div class="min-w-0 w-full">
      <label class="label-text mb-1.5 block px-0" for="username">{__("Group Username")}</label>
      <div class="join w-full min-w-0" dir="ltr">
        <span class="join-item hidden min-w-10 max-w-64 shrink-0 items-center border border-e-0 border-base-300 bg-base-200 px-3 text-sm text-base-content/60 sm:flex">
          <span class="truncate whitespace-nowrap" title="{$system['system_url']}/groups/">{$system['system_url']}/groups/</span>
        </span>
        <input type="text" class="input join-item min-w-0 flex-1 [--border:1px]" name="username" id="username">
      </div>
      <p class="mt-1.5 text-xs text-base-content/60">{__("Can only contain alphanumeric characters (A–Z, 0–9) and periods ('.')")}</p>
    </div>
    <!-- username -->
    <!-- privacy -->
    <div class="min-w-0 w-full">
      <label class="label-text mb-1.5 block px-0" for="privacy">{__("Select Privacy")}</label>
      <div class="select w-full min-w-0 [--border:1px]">
        <select class="min-w-0 ps-0!" name="privacy" id="privacy">
          <option value="public">{__("Public Group")}</option>
          <option value="closed">{__("Closed Group")}</option>
          <option value="secret">{__("Secret Group")}</option>
        </select>
      </div>
    </div>
    <!-- privacy -->
    <!-- category -->
    <div class="min-w-0 w-full">
      <label class="label-text mb-1.5 block px-0" for="category">{__("Category")}</label>
      <div class="select w-full min-w-0 [--border:1px]">
        <select class="min-w-0 ps-0!" name="category" id="category">
          <option>{__("Select Category")}</option>
          {foreach $categories as $category}
            {include file='__categories.recursive_options.tpl'}
          {/foreach}
        </select>
      </div>
    </div>
    <!-- category -->
    <!-- country -->
    <div class="min-w-0 w-full">
      <label class="label-text mb-1.5 block px-0" for="country">{__("Country")}</label>
      <div class="select w-full min-w-0 [--border:1px]">
        <select class="min-w-0 ps-0!" name="country" id="country">
          <option value="none">{__("Select Country")}</option>
          {foreach $countries as $country}
            <option value="{$country['country_id']}" {if $country['country_id'] == $country_fallback_value}selected{/if}>{$country['country_name_with_flag']}</option>
          {/foreach}
        </select>
      </div>
    </div>
    <!-- country -->
    <!-- language -->
    <div class="min-w-0 w-full">
      <label class="label-text mb-1.5 block px-0" for="language">{__("Language")}</label>
      <div class="select w-full min-w-0 [--border:1px]">
        <select class="min-w-0 ps-0!" name="language" id="language">
          <option value="none">{__("Select Language")}</option>
          {foreach $languages as $language}
            <option value="{$language['language_id']}" {if $language['language_id'] == $language_fallback_value}selected{/if}>{$language['title']}</option>
          {/foreach}
        </select>
      </div>
    </div>
    <!-- language -->
    <!-- description -->
    <div class="min-w-0 w-full">
      <label class="label-text mb-1.5 block px-0" for="description">{__("About")}</label>
      <textarea class="textarea w-full px-3 [--border:1px]" name="description" id="description"></textarea>
    </div>
    <!-- custom fields -->
    {if $custom_fields}
      {include file='__custom_fields.tpl' _custom_fields=$custom_fields _registration=true _input_class="input w-full [--border:1px]" _select_class="select w-full [--border:1px]" _textarea_class="textarea w-full px-3 [--border:1px]" _label_class="label-text px-0"}
    {/if}
    <!-- custom fields -->
    <!-- post -->
    <div class="flex items-center gap-4 rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[1.75rem] bg-base-200/60 p-4">
      <div class="min-w-0 grow">
        <div class="text-sm font-medium text-base-content" id="create_post-label">{__("Create Post")}</div>
        <p class="mt-0.5 text-xs text-base-content/60">{__("Create a post after creating the group")}<span class="block">{__("Post will be public and only works with public/closed ")}</span></p>
      </div>
      <input type="checkbox" class="switch switch-primary shrink-0 [--radius-selector:9999px] [--border:1px]" aria-labelledby="create_post-label" name="create_post" id="create_post">
    </div>
    <!-- post -->
    <!-- error -->
    <div class="alert alert-soft alert-error alert-danger hidden"></div>
    <!-- error -->
  </div>
  <div class="modal__footer justify-end gap-2">
    <button type="button" class="button button--tertiary" data-overlay="#modal">{__("Cancel")}</button>
    <button type="submit" class="button button--primary">{__("Create")}</button>
  </div>
</form>
