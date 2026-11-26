{include file='__modal_header.tpl' _icon="icon-[tabler--award]" _title=__("Send Merit") _text=__("Celebrate the people who inspire our community")}
<form class="js_ajax-forms" data-url="users/merits.php?do=send">
  <div class="modal__body flex flex-col gap-5">
    <div class="flex items-center gap-3 rounded-2xl border border-orange-500/15 bg-orange-500/5 p-3 sm:p-4">
      <span class="flex size-12 shrink-0 items-center justify-center rounded-xl bg-orange-500/15 text-2xl font-bold tabular-nums text-orange-600 dark:text-orange-400">{$user->_data['merits_balance']['remining']}</span>
      <div class="min-w-0 grow">
        <p class="text-sm font-semibold text-base-content">{__("Merits Balance")}</p>
        <p class="mt-0.5 text-xs text-base-content/60">{__("merits left")}</p>
      </div>
    </div>

    <div class="min-w-0">
      <span class="label-text mb-1.5 block">{__("People")}</span>
      <input type="text" id="merit-recipients" class="js_tagify-ajax hidden min-h-10 w-full items-center! rounded-field bg-base-100 text-sm max-md:text-base [--placeholder-color-focus:color-mix(in_oklab,var(--color-base-content)_35%,transparent)]! [--placeholder-color:color-mix(in_oklab,var(--color-base-content)_45%,transparent)]! [--tag-bg:var(--color-base-200)]! [--tag-border-radius:9999px]! [--tag-hover:var(--color-base-300)]! [--tag-remove-btn-color:var(--color-base-content)]! [--tag-text-color:var(--color-base-content)]! [--tags-border-color:var(--color-base-300)]! [--tags-focus-border-color:var(--color-primary)]! [--tags-hover-border-color:color-mix(in_oklab,var(--color-base-content)_25%,transparent)]!" data-handle="users" name="recepients" placeholder='{__("Search")}' aria-label='{__("People")}' aria-describedby="merit-recipients-help" />
      <p id="merit-recipients-help" class="mt-1.5 text-xs text-base-content/60">{__("Select the users to whom you want to send the merit")}</p>
    </div>

    <div class="min-w-0">
      <label class="label-text mb-1.5 block" for="merit-category">{__("Category")}</label>
      <select class="select w-full [--border:1px]" name="category" id="merit-category" aria-describedby="merit-category-help">
        <option value="">{__("Select Category")}</option>
        {foreach $merits_categories as $category}
          {include file='__categories.recursive_options.tpl' data_category=$category_id}
        {/foreach}
      </select>
      <p id="merit-category-help" class="mt-1.5 text-xs text-base-content/60">{__("Select the category in which they will be recognized")}</p>
    </div>

    <div class="grid gap-4 sm:grid-cols-[minmax(0,1fr)_7rem]">
      <div class="min-w-0">
        <label class="label-text mb-1.5 block" for="merit-message">{__("Message")} <span class="ms-1 text-xs font-normal text-base-content/50">{__("Optional")}</span></label>
        <textarea class="textarea min-h-28 w-full [--border:1px]" name="message" id="merit-message" rows="4" dir="auto" placeholder='{__("Write a message")}'></textarea>
      </div>
      <div>
        <div class="label-text mb-1.5 block" id="merit-image-label">{__("Image")} <span class="ms-1 text-xs font-normal text-base-content/50">{__("Optional")}</span></div>
        {include file='__x_image.tpl' _x_name="image"}
      </div>
    </div>
    <!-- error -->
    <div class="alert alert-soft alert-error alert-danger hidden"></div>
    <!-- error -->
  </div>
  <div class="modal__footer justify-end gap-2 border-t border-base-300 pt-4">
    <button type="button" class="button button--tertiary" data-overlay="#modal">{__("Cancel")}</button>
    <button type="submit" class="button button--primary">{__("Send Merit")}</button>
  </div>
</form>
