{strip}
  {include file='_js_templates.core.tpl'}
  {include file='_js_templates.uploader.tpl'}
  {include file='_js_templates.chat.tpl'}

    <!-- Verification Documents -->
    {if $page == "admin"}
      <script id="verification-documents" type="text/template">
        {include file='__modal_header.tpl' _icon="icon-[tabler--id]" _title=__("Verification Documents")}
        <div class="modal__body flex flex-col gap-4">
          <div class="grid gap-4 empty:hidden sm:grid-cols-2">
              {literal}{{#photo}}{/literal}
                <div>
                  <div class="admin-verification-doc">
                    <div class="admin-verification-doc-label">
                      {literal}{{#is_page}}{/literal}
                        {__($system['verification_page_photo_title'])}
                      {literal}{{/is_page}}{/literal}
                      {literal}{{^is_page}}{/literal}
                        {__($system['verification_user_photo_title'])}
                      {literal}{{/is_page}}{/literal}
                    </div>
                    <a class="admin-verification-doc-image" target="_blank" href="{literal}{{photo}}{/literal}">
                      <img class="max-w-full rounded-box" src="{literal}{{photo}}{/literal}" alt="">
                    </a>
                  </div>
                </div>
              {literal}{{/photo}}{/literal}
              {literal}{{#passport}}{/literal}
                <div>
                  <div class="admin-verification-doc">
                    <div class="admin-verification-doc-label">
                      {literal}{{#is_page}}{/literal}
                        {__($system['verification_page_passport_title'])}
                      {literal}{{/is_page}}{/literal}
                      {literal}{{^is_page}}{/literal}
                        {__($system['verification_user_passport_title'])}
                      {literal}{{/is_page}}{/literal}
                    </div>
                    <a class="admin-verification-doc-image" target="_blank" href="{literal}{{passport}}{/literal}">
                      <img class="max-w-full rounded-box" src="{literal}{{passport}}{/literal}" alt="">
                    </a>
                  </div>
                </div>
              {literal}{{/passport}}{/literal}
          </div>
          {literal}{{#is_page}}{/literal}
            <div class="admin-verification-info">
              <div class="admin-verification-info-item">
                <span class="admin-verification-info-label">{__("Business Website")}</span>
                <a href="{literal}{{website}}{/literal}" target="_blank" rel="noopener">{literal}{{website}}{/literal}</a>
              </div>
              <div class="admin-verification-info-item">
                <span class="admin-verification-info-label">{__("Business Address")}</span>
                <span>{literal}{{address}}{/literal}</span>
              </div>
            </div>
          {literal}{{/is_page}}{/literal}
          <div class="admin-verification-info">
            <div class="admin-verification-info-item">
              <span class="admin-verification-info-label">{__("Message")}</span>
              <span class="admin-verification-info-message">{literal}{{message}}{/literal}</span>
            </div>
          </div>
        </div>
        <div class="modal__footer justify-end gap-2">
          <button type="button" class="button button--danger js_admin-unverify" data-handle="{literal}{{handle}}{/literal}" data-id="{literal}{{node-id}}{/literal}">
            <span class="icon-[tabler--x] size-4" aria-hidden="true"></span>
            {__("Decline")}
          </button>
          <button type="button" class="button button--primary js_admin-verify" data-handle="{literal}{{handle}}{/literal}" data-id="{literal}{{node-id}}{/literal}">
            <span class="icon-[tabler--check] size-4" aria-hidden="true"></span>
            {__("Verify")}
          </button>
        </div>
      </script>
    {/if}
    <!-- Verification Documents -->

    <!-- Export CSV -->
    {if $page == "admin"}
      <script id="export-csv" type="text/template">
        {include file='__modal_header.tpl' _icon="icon-[tabler--file-export]" _title=__("Export CSV")}
        <form class="js_ajax-forms" data-url="admin/export.php">
          <div class="modal__body flex flex-col gap-4">
            <div class="w-full">
              <label class="label-text mb-1.5 block" for="from_row">{__("Row to begin at")}</label>
              <input type="text" class="input w-full [--border:1px]" name="from_row" id="from_row" value="0" required autofocus>
            </div>
            <div class="w-full">
              <label class="label-text mb-1.5 block" for="results">{__("Number of rows")}</label>
              <input type="text" class="input w-full [--border:1px]" name="results" id="results" value="10" required>
              <p class="mt-1.5 text-sm text-base-content/60">{__("Set to 0 to export all results")}</p>
            </div>
            <div class="w-full">
              <label class="label-text mb-1.5 block" for="export-from">{__("Date range")}</label>
              <div class="grid gap-2 sm:grid-cols-2">
                <input type="date" class="input w-full [--border:1px]" name="from" id="export-from" value="{literal}{{from}}{/literal}">
                <input type="date" class="input w-full [--border:1px]" name="to" value="{literal}{{to}}{/literal}" aria-label='{__("Date range")}'>
              </div>
            </div>
            <!-- error -->
            <div class="alert alert-soft alert-error alert-danger hidden"></div>
            <!-- error -->
          </div>
          <div class="modal__footer justify-end gap-2">
            <input type="hidden" name="handle" value="{literal}{{handle}}{/literal}">
            <button type="button" class="button button--tertiary" data-overlay="#modal">{__("Cancel")}</button>
            <button type="submit" class="button button--primary">{__("Export")}</button>
          </div>
        </form>
      </script>
    {/if}
    <!-- Export CSV -->

    <!-- Factory Reset -->
    {if $page == "admin" && $view == "tools" && $sub_view == "reset"}
      <script id="factory-reset" type="text/template">
        {include file='__modal_header.tpl' _icon="icon-[tabler--alert-triangle]" _title=__("Factory Reset") _danger=true}
        <form class="js_ajax-forms" data-url="admin/reset.php">
          <div class="modal__body flex flex-col gap-4">
            <p class="text-sm text-base-content/70">{__("Once you reset your website all data will be deleted and it will be like having a fresh installation")}</p>
            <input type="hidden" name="do" value="factory_reset">
            <div class="w-full">
              <label class="label-text mb-1.5 block" for="factory-reset-password">{__("Confirm Password")}</label>
              <input type="password" class="input w-full [--border:1px]" name="password_check" id="factory-reset-password" required autocomplete="current-password" autofocus>
            </div>
            <label class="flex cursor-pointer items-center justify-between gap-4 rounded-lg border border-base-300 p-3" for="factory-reset-confirm">
              <span class="min-w-0 text-sm">{__("I understand that all data will be deleted and this can not be undone")}</span>
              <input type="checkbox" class="switch switch-primary shrink-0 [--radius-selector:9999px] [--border:1px]" id="factory-reset-confirm" required>
            </label>
            <div class="alert alert-success" role="status" style="display: none"></div>
            <div class="alert alert-error alert-danger" role="alert" style="display: none"></div>
          </div>
          <div class="modal__footer justify-end gap-2">
            <button type="button" class="button button--tertiary" data-overlay="#modal">{__("Cancel")}</button>
            <button type="submit" class="button button--danger">{__("Reset Everything")}</button>
          </div>
        </form>
      </script>
    {/if}
    <!-- Factory Reset -->

    <!-- Change License Key -->
    {if $page == "admin" && $view == "license"}
      <script id="admin-license-change" type="text/template">
        {include file='__modal_header.tpl' _icon="icon-[tabler--key]" _title=__("Change License Key")}
        <form class="js_ajax-forms" data-url="admin/license.php" autocomplete="off">
          <div class="modal__body flex flex-col gap-5">
            <p class="text-sm leading-relaxed text-base-content/70">{__("Enter your new license key from")} <a class="link link-primary" href="https://zamblek.com/purchases" target="_blank" rel="noopener">zamblek.com/purchases</a> {__("or your Envato purchase code.")}</p>
            {if $licence_info['key_masked']}
              <div class="flex items-center gap-3 rounded-lg border border-base-300 bg-base-200/50 px-4 py-3">
                <span class="icon-[tabler--license] size-5 shrink-0 text-base-content/60" aria-hidden="true"></span>
                <span class="min-w-0 flex-1">
                  <span class="block text-xs text-base-content/60">{__("Current License Key")}</span>
                  <span class="block truncate font-mono text-sm" title="{$licence_info['key_masked']}">{$licence_info['key_masked']}</span>
                </span>
              </div>
            {/if}
            <input type="hidden" name="do" value="change">
            <div class="w-full">
              <label class="label-text mb-1.5 block" for="admin-license-key">{__("New License Key")}</label>
              <label class="input w-full [--border:1px]">
                <span class="icon-[tabler--key] my-auto me-3 size-4 shrink-0 text-base-content/60" aria-hidden="true"></span>
                <input type="text" class="grow font-mono" name="licence_key" id="admin-license-key" placeholder="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" required autocomplete="off" spellcheck="false" data-1p-ignore data-lpignore="true" autofocus>
              </label>
            </div>
            <div class="w-full">
              <label class="label-text mb-1.5 block" for="admin-license-password">{__("Confirm Password")}</label>
              <label class="input w-full [--border:1px]">
                <span class="icon-[tabler--lock] my-auto me-3 size-4 shrink-0 text-base-content/60" aria-hidden="true"></span>
                <input type="password" class="grow" name="password_check" id="admin-license-password" required autocomplete="new-password" data-1p-ignore data-lpignore="true">
              </label>
            </div>
            <div class="alert alert-soft alert-info flex items-start gap-3 text-sm" role="note">
              <span class="icon-[tabler--shield-check] mt-0.5 size-5 shrink-0" aria-hidden="true"></span>
              <span>{__("It will replace the current license on this website, your database is not touched.")}</span>
            </div>
            <div class="alert alert-success" role="status" style="display: none"></div>
            <div class="alert alert-error alert-danger" role="alert" style="display: none"></div>
          </div>
          <div class="modal__footer justify-end gap-2">
            <button type="button" class="button button--tertiary" data-overlay="#modal">{__("Cancel")}</button>
            <button type="submit" class="button button--primary">
              <span class="icon-[tabler--check] size-4" aria-hidden="true"></span>
              {__("Apply License")}
            </button>
          </div>
        </form>
      </script>
    {/if}
    <!-- Change License Key -->

    <!-- Auto Connect -->
    {if $page == "admin" && $view == "tools" && $sub_view == "auto-connect"}
      <script id="auto-connect-node" type="text/template">
        <div class="auto-connect-node admin-setting-field grid min-w-0 items-start gap-3 rounded-lg border border-base-300 p-4 md:grid-cols-[14rem_minmax(0,1fr)] js_admin-setting-field">
          <select class="select w-full" name="{literal}{{country_field_name}}{/literal}" aria-label="{__("Country")}">
            {foreach $countries as $country}
              <option value="{$country['country_id']}">{$country['country_name_with_flag']}</option>
            {/foreach}
          </select>
          <div class="admin-setting-control flex min-w-0 flex-col gap-2">
            <input type="text" class="js_tagify-ajax-late hidden" data-handle="{literal}{{nodes}}{/literal}" name="{literal}{{nodes_field_name}}{/literal}">
            <div class="admin-setting-help text-sm leading-relaxed">{__("Search for nodes you want new accounts to auto connect")} {__("to this country")}</div>
          </div>
        </div>
      </script>
    {/if}
    <!-- Auto Connect -->

    {if $system['switch_accounts_enabled']}
      <script id="account-switcher" type="text/template">
        {include file='__modal_header.tpl' _icon="icon-[tabler--switch-horizontal]" _title=__("Switch Accounts")}
        <div class="modal__body">
          {include file='__connected_accounts.tpl'}
        </div>
      </script>
    {/if}

    <script id="keyboard-shortcuts" type="text/template">
      {include file='__modal_header.tpl' _icon="icon-[tabler--keyboard]" _title=__("Keyboard Shortcuts")}
      <div class="modal__body flex flex-col gap-3">
        <div class="flex items-center gap-3 text-sm">
          <kbd class="kbd size-8 justify-center border border-base-300 bg-base-200 font-semibold text-base-content">J</kbd>
          <span>{__("Scroll to the next post")}</span>
        </div>
        <div class="flex items-center gap-3 text-sm">
          <kbd class="kbd size-8 justify-center border border-base-300 bg-base-200 font-semibold text-base-content">K</kbd>
          <span>{__("Scroll to the previous post")}</span>
        </div>
      </div>
    </script>
{/strip}
