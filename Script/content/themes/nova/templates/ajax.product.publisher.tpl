{include file='__modal_header.tpl' _icon="icon-[tabler--shopping-bag]" _title=__("Create New Product")}
<form class="publisher-mini">
  <div class="modal__body flex flex-col gap-4">
    {if $system['paid_products_enabled']}
      <div class="alert alert-soft alert-warning flex items-start gap-3 text-start" role="alert">
        <span class="icon-[tabler--alert-triangle] size-5 shrink-0" aria-hidden="true"></span>
        <p class="min-w-0">{__("This product post will cost you")} <span class="badge badge-soft">{$system['paid_products_cost']} {$system['system_currency']}</span> {__("to publish. The cost will be deducted from your wallet balance")}</p>
      </div>
    {/if}

    {if $system['market_digital_products_enabled']}
      <!-- digital product -->
      <div class="flex items-center gap-4 rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-[1.75rem] bg-base-200/60 p-4">
        <div class="min-w-0 grow">
          <div class="text-sm font-medium text-base-content" id="is_digital-label">{__("Digital Product")}</div>
          <p class="mt-0.5 text-xs text-base-content/60">{__("Enable this option if you are selling a digital product")}</p>
        </div>
        <input type="checkbox" class="switch switch-primary shrink-0 [--radius-selector:9999px] [--border:1px] js_publisher-digital" aria-labelledby="is_digital-label" name="is_digital" id="is_digital">
      </div>
      <!-- digital product -->
      <!-- download url -->
      <div id="digital_product" class="hidden space-y-4">
        <div class="w-full">
          <label class="label-text mb-1.5 block" for="product-publisher-product-url">{__("Download URL")}</label>
          <input name="product_url" type="text" class="input w-full [--border:1px]" id="product-publisher-product-url">
        </div>
        <!-- download url -->
        <!-- upload file -->
        <div class="w-full">
          <span class="label-text mb-1.5 block">{__("OR Upload your File")}</span>
          {include file='__x_image.tpl' _x_name="product_file" _x_handle="x-file" _x_type="file"}
          <p class="mt-1.5 text-sm text-base-content/60">{__("Allowed file types")}: {$system['file_extensions']}</p>
        </div>
        <!-- upload file -->
      </div>
    {/if}
    <!-- product name -->
    <div class="w-full">
      <label class="label-text mb-1.5 block" for="product-publisher-name">{__("Product Name")}</label>
      <input name="name" type="text" class="input w-full [--border:1px]" id="product-publisher-name">
    </div>
    <!-- product name -->
    <!-- total item units -->
    <div class="grid gap-4 sm:grid-cols-3">
      <div class="w-full sm:col-span-2">
        <label class="label-text mb-1.5 block" for="product-publisher-quantity">{__("Total Item Units")}</label>
        <input name="quantity" type="number" min="1" max="500" class="input w-full [--border:1px]" id="product-publisher-quantity">
      </div>
      <div class="w-full">
        <label class="label-text mb-1.5 block" for="product-publisher-price">{__("Price")} ({$system['system_currency']})</label>
        <input name="price" type="number" class="input w-full [--border:1px]" id="product-publisher-price">
      </div>
    </div>
    <!-- total item units -->
    <!-- category -->
    <div class="grid gap-4 sm:grid-cols-3">
      <div class="w-full sm:col-span-2">
        <label class="label-text mb-1.5 block" for="product-publisher-category">{__("Category")}</label>
        <select class="select w-full [--border:1px]" name="category" id="product-publisher-category">
          {foreach $market_categories as $category}
            {include file='__categories.recursive_options.tpl'}
          {/foreach}
        </select>
      </div>
      <div class="w-full">
        <label class="label-text mb-1.5 block" for="product-publisher-status">{__("Status")}</label>
        <select class="select w-full [--border:1px]" name="status" id="product-publisher-status">
          <option value="new">{__("New")}</option>
          <option value="old">{__("Used")}</option>
        </select>
      </div>
    </div>
    <!-- category -->
    <!-- location -->
    <div class="w-full">
      <label class="label-text mb-1.5 block" for="product-publisher-location">{__("Location")}</label>
      <input name="location" type="text" class="input w-full [--border:1px] js_geocomplete" id="product-publisher-location">
    </div>
    <!-- location -->
    <!-- description -->
    <div class="w-full">
      <label class="label-text mb-1.5 block" for="product-publisher-message">{__("Description")}</label>
      <textarea name="message" rows="5" dir="auto" class="textarea w-full [--border:1px]" id="product-publisher-message"></textarea>
    </div>
    <!-- description -->
    <!-- custom fields -->
    {if $custom_fields}
      {include file='__custom_fields.tpl' _custom_fields=$custom_fields _registration=true}
    {/if}
    <!-- custom fields -->
    <!-- photos -->
    <div class="w-full">
      <span class="label-text mb-1.5 block">{__("Photos")}</span>
      <div class="attachments [&_ul]:grid [&_ul]:grid-cols-3 [&_ul]:items-start [&_ul]:gap-2 [&_li]:relative [&_li]:overflow-hidden [&_li]:rounded-field [&_li]:bg-base-200 [&_img]:size-full [&_img]:object-cover [&_.button]:absolute [&_.button]:end-1 [&_.button]:top-1 [&_.name]:p-2 [&_.name]:text-xs [&_.name]:break-all" data-type="photos">
        <ul>
          <li class="add grid aspect-square place-items-center border border-dashed border-base-300 text-base-content/60 hover:text-base-content [&>.x-uploader]:absolute [&>.x-uploader]:inset-0 [&>.x-uploader]:z-10 [&>.x-uploader]:grid [&>.x-uploader]:cursor-pointer [&>.x-uploader]:place-items-center [&>.x-uploader]:overflow-hidden [&>.x-uploader>input[type=file]]:absolute [&>.x-uploader>input[type=file]]:inset-0 [&>.x-uploader>input[type=file]]:z-10 [&>.x-uploader>input[type=file]]:size-full [&>.x-uploader>input[type=file]]:cursor-pointer [&>.x-uploader>input[type=file]]:opacity-0">
            <span class="icon-[tabler--camera-plus] size-6 js_x-uploader" data-handle="publisher-mini" data-multiple="true" aria-hidden="true"></span>
          </li>
        </ul>
      </div>
    </div>
    <!-- photos -->
    <!-- error -->
    <div class="alert alert-soft alert-error alert-danger hidden"></div>
    <!-- error -->
  </div>
  <div class="modal__footer justify-end gap-2">
    {if $share_to == "page"}
      <input type="hidden" name="handle" value="page">
      <input type="hidden" name="id" value="{$share_to_id}">
    {elseif $share_to == "group"}
      <input type="hidden" name="handle" value="group">
      <input type="hidden" name="id" value="{$share_to_id}">
    {elseif $share_to == "event"}
      <input type="hidden" name="handle" value="event">
      <input type="hidden" name="id" value="{$share_to_id}">
    {/if}
    <button type="button" class="button button--primary js_publisher-btn js_publisher-product">{__("Publish")}</button>
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
