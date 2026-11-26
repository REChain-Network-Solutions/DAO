{include file='__modal_header.tpl' _icon="icon-[tabler--coin]" _title=__("Create New Funding Request")}
<form class="js_ajax-forms" data-url="posts/funding.php?do=publish">
  <div class="modal__body flex flex-col gap-4">
    {if $system['paid_funding_enabled']}
      <div class="alert alert-soft alert-warning flex items-start gap-3 text-start" role="alert">
        <span class="icon-[tabler--alert-triangle] size-5 shrink-0" aria-hidden="true"></span>
        <p class="min-w-0">{__("This funding post will cost you")} <span class="badge badge-soft">{$system['paid_funding_cost']} {$system['system_currency']}</span> {__("to publish. The cost will be deducted from your wallet balance")}</p>
      </div>
    {/if}

    <!-- title -->
    <div>
      <label class="label-text mb-1.5 block" for="funding-title">{__("Title")}</label>
      <input name="title" id="funding-title" type="text" class="input w-full [--border:1px]">
    </div>
    <!-- title -->

    <!-- amount -->
    <div>
      <label class="label-text mb-1.5 block" for="funding-amount">{__("Amount You Would Like To Receive")}</label>
      <div class="input w-full [--border:1px]">
        {if $system['system_currency_dir'] != "right"}
          <span class="my-auto me-2 shrink-0 font-medium text-base-content/60">{$system['system_currency_symbol']}</span>
        {/if}
        <input type="text" class="grow" inputmode="decimal" placeholder="0.00" name="amount" id="funding-amount">
        {if $system['system_currency_dir'] == "right"}
          <span class="my-auto ms-2 shrink-0 font-medium text-base-content/60">{$system['system_currency_symbol']}</span>
        {/if}
      </div>
    </div>
    <!-- amount -->

    <!-- category -->
    <div>
      <label class="label-text mb-1.5 block" for="funding-category">{__("Category")}</label>
      <select class="select w-full [--border:1px]" name="category" id="funding-category">
        {foreach $funding_categories as $category}
          {include file='__categories.recursive_options.tpl'}
        {/foreach}
      </select>
    </div>
    <!-- category -->

    <!-- description -->
    <div>
      <label class="label-text mb-1.5 block" for="funding-description">{__("Description")}</label>
      <textarea name="description" id="funding-description" rows="5" dir="auto" class="textarea w-full [--border:1px]"></textarea>
    </div>
    <!-- description -->

    <!-- cover image -->
    <div>
      <span class="label-text mb-1.5 block">{__("Cover Image")}</span>
      {include file='__x_image.tpl' _x_name="cover_image"}
    </div>
    <!-- cover image -->

    <!-- error -->
    <div class="alert alert-soft alert-error alert-danger hidden"></div>
    <!-- error -->
  </div>
  <div class="modal__footer justify-end gap-2">
    <button type="button" class="button button--tertiary" data-overlay="#modal">{__("Cancel")}</button>
    <button type="submit" class="button button--primary">{__("Publish")}</button>
  </div>
</form>
