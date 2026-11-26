{include file='__modal_header.tpl' _icon="icon-[tabler--shopping-bag]" _title=__("Edit Product")}
<form class="js_ajax-forms" data-url="posts/edit.php">
  <div class="modal__body flex flex-col gap-4">
    {if $system['market_digital_products_enabled']}
      <!-- digital product -->
      <div class="flex items-center gap-4 rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[1.75rem] bg-base-200/60 p-4">
        <div class="min-w-0 grow">
          <div class="text-sm font-medium text-base-content" id="is_digital-label">{__("Digital Product")}</div>
          <p class="mt-0.5 text-xs text-base-content/60">{__("Enable this option if you are selling a digital product")}</p>
        </div>
        <input type="checkbox" class="switch switch-primary shrink-0 [--radius-selector:9999px] [--border:1px] js_publisher-digital" aria-labelledby="is_digital-label" name="is_digital" id="is_digital" {if $post['product']['is_digital']}checked{/if}>
      </div>
      <!-- digital product -->
      <!-- download url -->
      <div id="digital_product" class="{if !$post['product']['is_digital']}hidden {/if}space-y-4">
        <div class="w-full">
          <label class="label-text mb-1.5 block" for="product-editor-product-url">{__("Download URL")}</label>
          <input name="product_url" type="text" class="input w-full [--border:1px]" value="{$post['product']['product_download_url']}" id="product-editor-product-url">
        </div>
        <!-- download url -->
        <!-- upload file -->
        <div class="w-full">
          <span class="label-text mb-1.5 block">{__("OR Upload your File")}</span>
          {include file='__x_image.tpl' _x_name="product_file" _x_value=$post['product']['product_file_source'] _x_handle="x-file" _x_type="file"}
          <p class="mt-1.5 text-sm text-base-content/60">{__("Allowed file types")}: {$system['file_extensions']}</p>
        </div>
        <!-- upload file -->
      </div>
    {/if}
    <!-- product name -->
    <div class="w-full">
      <label class="label-text mb-1.5 block" for="product-editor-name">{__("Product Name")}</label>
      <input name="name" type="text" class="input w-full [--border:1px]" value="{$post['product']['name']}" id="product-editor-name">
    </div>
    <!-- product name -->
    <!-- total item units -->
    <div class="grid gap-4 sm:grid-cols-3">
      <div class="w-full sm:col-span-2">
        <label class="label-text mb-1.5 block" for="product-editor-quantity">{__("Total Item Units")}</label>
        <input name="quantity" type="number" min="1" max="500" value="{$post['product']['quantity']}" class="input w-full [--border:1px]" id="product-editor-quantity">
      </div>
      <div class="w-full">
        <label class="label-text mb-1.5 block" for="product-editor-price">{__("Price")} ({$system['system_currency']})</label>
        <input name="price" type="number" class="input w-full [--border:1px]" value="{$post['product']['price']}" id="product-editor-price">
      </div>
    </div>
    <!-- total item units -->
    <!-- category -->
    <div class="grid gap-4 sm:grid-cols-3">
      <div class="w-full sm:col-span-2">
        <label class="label-text mb-1.5 block" for="product-editor-category">{__("Category")}</label>
        <select class="select w-full [--border:1px]" name="category" id="product-editor-category">
          {foreach $market_categories as $category}
            {include file='__categories.recursive_options.tpl' data_category=$post['product']['category_id']}
          {/foreach}
        </select>
      </div>
      <div class="w-full">
        <label class="label-text mb-1.5 block" for="product-editor-status">{__("Status")}</label>
        <select class="select w-full [--border:1px]" name="status" id="product-editor-status">
          <option {if $post['product']['status'] == "new"}selected{/if} value="new">{__("New")}</option>
          <option {if $post['product']['status'] == "old"}selected{/if} value="old">{__("Used")}</option>
        </select>
      </div>
    </div>
    <!-- category -->
    <!-- location -->
    <div class="w-full">
      <label class="label-text mb-1.5 block" for="product-editor-location">{__("Location")}</label>
      <input name="location" type="text" class="input w-full [--border:1px] js_geocomplete" value="{$post['product']['location']}" id="product-editor-location">
    </div>
    <!-- location -->
    <!-- description -->
    <div class="w-full">
      <label class="label-text mb-1.5 block" for="product-editor-message">{__("Description")}</label>
      <textarea name="message" rows="5" dir="auto" class="textarea w-full [--border:1px]" id="product-editor-message">{$post['text_plain']}</textarea>
    </div>
    <!-- description -->
    <!-- custom fields -->
    {if $custom_fields['basic']}
      {include file='__custom_fields.tpl' _custom_fields=$custom_fields['basic'] _registration=false}
    {/if}
    <!-- custom fields -->
    <!-- error -->
    <div class="alert alert-soft alert-error alert-danger hidden"></div>
    <!-- error -->
  </div>
  <div class="modal__footer justify-end gap-2">
    <input type="hidden" name="handle" value="product">
    <input type="hidden" name="id" value="{$post['post_id']}">
    <button type="button" class="button button--tertiary" data-overlay="#modal">{__("Cancel")}</button>
    <button type="submit" class="button button--primary">{__("Save")}</button>
  </div>
</form>

<script>
  /* digital product */
  $('#is_digital').on('change', function() {
    if ($(this).prop('checked')) {
      $('#digital_product').fadeIn();
    } else {
      $('#digital_product').hide();
    }
  });
</script>
