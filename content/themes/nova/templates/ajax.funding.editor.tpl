{include file='__modal_header.tpl' _icon="icon-[tabler--coin]" _title=__("Edit Funding Request")}
<form class="js_ajax-forms" data-url="posts/edit.php">
  <div class="modal__body flex flex-col gap-4">
    <!-- title -->
    <div>
      <label class="label-text mb-1.5 block" for="funding-edit-title">{__("Title")}</label>
      <input name="title" id="funding-edit-title" type="text" class="input w-full [--border:1px]" value="{$post['funding']['title']}">
    </div>
    <!-- title -->

    <!-- amount -->
    <div>
      <label class="label-text mb-1.5 block" for="funding-edit-amount">{__("Amount You Would Like To Receive")}</label>
      <div class="input w-full [--border:1px]">
        {if $system['system_currency_dir'] != "right"}
          <span class="my-auto me-2 shrink-0 font-medium text-base-content/60">{$system['system_currency_symbol']}</span>
        {/if}
        <input type="text" class="grow" inputmode="decimal" placeholder="0.00" name="amount" id="funding-edit-amount" value="{$post['funding']['amount']}">
        {if $system['system_currency_dir'] == "right"}
          <span class="my-auto ms-2 shrink-0 font-medium text-base-content/60">{$system['system_currency_symbol']}</span>
        {/if}
      </div>
    </div>
    <!-- amount -->

    <!-- category -->
    <div>
      <label class="label-text mb-1.5 block" for="funding-edit-category">{__("Category")}</label>
      <select class="select w-full [--border:1px]" name="category" id="funding-edit-category">
        {foreach $funding_categories as $category}
          {include file='__categories.recursive_options.tpl' data_category=$post['funding']['category_id']}
        {/foreach}
      </select>
    </div>
    <!-- category -->

    <!-- description -->
    <div>
      <label class="label-text mb-1.5 block" for="funding-edit-description">{__("Description")}</label>
      <textarea name="description" id="funding-edit-description" rows="5" dir="auto" class="textarea w-full [--border:1px]">{$post['text_plain']}</textarea>
    </div>
    <!-- description -->

    <!-- cover image -->
    <div>
      <span class="label-text mb-1.5 block">{__("Cover Image")}</span>
      {include file='__x_image.tpl' _x_name="cover_image" _x_value=$post['funding']['cover_image']}
    </div>
    <!-- cover image -->

    <!-- error -->
    <div class="alert alert-soft alert-error alert-danger hidden"></div>
    <!-- error -->
  </div>
  <div class="modal__footer justify-end gap-2">
    <input type="hidden" name="handle" value="funding">
    <input type="hidden" name="id" value="{$post['post_id']}">
    <button type="button" class="button button--tertiary" data-overlay="#modal">{__("Cancel")}</button>
    <button type="submit" class="button button--primary">{__("Save")}</button>
  </div>
</form>
