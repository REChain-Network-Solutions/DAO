{include file='__modal_header.tpl' _icon="icon-[tabler--tag]" _title=__("Create New Offer")}
<form class="js_ajax-forms publisher-mini" data-url="posts/offer.php?do=publish">
  <div class="modal__body flex flex-col gap-4">
    {if $system['paid_offers_enabled']}
      <div class="alert alert-soft alert-warning flex items-start gap-3 text-start" role="alert">
        <span class="icon-[tabler--alert-triangle] size-5 shrink-0" aria-hidden="true"></span>
        <p class="min-w-0">{__("This offer post will cost you")} <span class="badge badge-soft">{$system['paid_offers_cost']} {$system['system_currency']}</span> {__("to publish. The cost will be deducted from your wallet balance")}</p>
      </div>
    {/if}

    <div class="grid gap-4 sm:grid-cols-2">
      <!-- discount type -->
      <div class="w-full">
        <label class="label-text mb-1.5 block" for="js_discount-type">{__("Type")}</label>
        <div class="select w-full [--border:1px]">
          <select class="min-w-0 ps-0!" id="js_discount-type" name="discount_type">
            <option value="discount_percent">{__("Discount Percent")}</option>
            <option value="discount_amount">{__("Discount Amount")}</option>
            <option value="buy_get_discount">{__("Buy X Get Y Discount")}</option>
            <option value="spend_get_off">{__("Spend X Get Y Off")}</option>
            <option value="free_shipping">{__("Free Shipping")}</option>
          </select>
        </div>
      </div>
      <!-- discount type -->
      <!-- discount percent -->
      <div id="js_discount-percent" class="w-full">
        <label class="label-text mb-1.5 block" for="offer-publisher-discount-percent">{__("Discount Percent")}</label>
        <div class="select w-full [--border:1px]">
          <select class="min-w-0 ps-0!" name="discount_percent" id="offer-publisher-discount-percent">
            {for $i=1 to 99}
              <option value="{$i}">{$i}%</option>
            {/for}
          </select>
        </div>
      </div>
      <!-- discount percent -->
      <!-- discount amount -->
      <div id="js_discount-amount" class="w-full hidden">
        <span class="label-text mb-1.5 block">{__("Discount Amount")}</span>
        <div class="input w-full [--border:1px]">
          {if $system['system_currency_dir'] == "left"}
            <span class="my-auto me-2 shrink-0 font-medium text-base-content/60">{$system['system_currency_symbol']}</span>
          {/if}
          <input name="discount_amount" type="text" class="grow" placeholder="0.00">
          {if $system['system_currency_dir'] == "right"}
            <span class="my-auto ms-2 shrink-0 font-medium text-base-content/60">{$system['system_currency_symbol']}</span>
          {/if}
        </div>
      </div>
      <!-- discount amount -->
    </div>
    <!-- buy get discount -->
    <div id="js_buy-get-discount" class="hidden">
      <div class="grid gap-4 sm:grid-cols-2">
        <div class="w-full">
          <label class="label-text mb-1.5 block" for="offer-publisher-buy-x">{__("Buy")}</label>
          <input name="buy_x" type="text" class="input w-full [--border:1px]" id="offer-publisher-buy-x">
          <p class="mt-1.5 text-sm text-base-content/60">{__("Enter numric value (Example: 5)")}</p>
        </div>
        <div class="w-full">
          <label class="label-text mb-1.5 block" for="offer-publisher-get-y">{__("Get")}</label>
          <input name="get_y" type="text" class="input w-full [--border:1px]" id="offer-publisher-get-y">
          <p class="mt-1.5 text-sm text-base-content/60">{__("Enter numric value (Example: 2)")}</p>
        </div>
      </div>
    </div>
    <!-- buy get discount -->
    <!-- spend get off -->
    <div id="js_spend-get-off" class="hidden">
      <div class="grid gap-4 sm:grid-cols-2">
        <div class="w-full">
          <span class="label-text mb-1.5 block">{__("Spend")}</span>
          <div class="input w-full [--border:1px]">
            {if $system['system_currency_dir'] == "left"}
              <span class="my-auto me-2 shrink-0 font-medium text-base-content/60">{$system['system_currency_symbol']}</span>
            {/if}
            <input name="spend_x" type="text" class="grow" placeholder="0.00">
            {if $system['system_currency_dir'] == "right"}
              <span class="my-auto ms-2 shrink-0 font-medium text-base-content/60">{$system['system_currency_symbol']}</span>
            {/if}
          </div>
        </div>
        <div class="w-full">
          <span class="label-text mb-1.5 block">{__("Amount Off")}</span>
          <div class="input w-full [--border:1px]">
            {if $system['system_currency_dir'] == "left"}
              <span class="my-auto me-2 shrink-0 font-medium text-base-content/60">{$system['system_currency_symbol']}</span>
            {/if}
            <input name="amount_y" type="text" class="grow" placeholder="0.00">
            {if $system['system_currency_dir'] == "right"}
              <span class="my-auto ms-2 shrink-0 font-medium text-base-content/60">{$system['system_currency_symbol']}</span>
            {/if}
          </div>
        </div>
      </div>
    </div>
    <!-- spend get off -->
    <div class="grid gap-4 sm:grid-cols-2">
      <!-- end date -->
      <div class="w-full">
        <label class="label-text mb-1.5 flex h-5 items-center gap-1.5" for="offer-publisher-end-date">{__("End Date")}<span class="badge badge-soft badge-xs">{__("Optional")}</span></label>
        <input type="datetime-local" class="input w-full [--border:1px]" name="end_date" id="offer-publisher-end-date">
      </div>
      <!-- end date -->
      <!-- category -->
      <div class="w-full">
        <label class="label-text mb-1.5 block" for="offer-publisher-category">{__("Category")}</label>
        <div class="select w-full [--border:1px]">
          <select class="min-w-0 ps-0!" name="category" id="offer-publisher-category">
            {foreach $offers_categories as $category}
              {include file='__categories.recursive_options.tpl'}
            {/foreach}
          </select>
        </div>
      </div>
      <!-- category -->
    </div>
    <!-- title -->
    <div class="w-full">
      <label class="label-text mb-1.5 block" for="offer-publisher-title">{__("Discounted Items and/or Services")}</label>
      <input name="title" type="text" class="input w-full [--border:1px]" id="offer-publisher-title">
    </div>
    <!-- title -->
    <!-- original price -->
    <div class="w-full">
      <label class="label-text mb-1.5 flex h-5 items-center gap-1.5" for="offer-publisher-price">{__("Original Price")}<span class="badge badge-soft badge-xs">{__("Optional")}</span></label>
      <input name="price" type="text" class="input w-full [--border:1px]" id="offer-publisher-price">
    </div>
    <!-- original price -->
    <!-- description -->
    <div class="w-full">
      <label class="label-text mb-1.5 block" for="offer-publisher-description">{__("Description")}</label>
      <textarea name="description" rows="5" dir="auto" class="textarea w-full [--border:1px]" id="offer-publisher-description"></textarea>
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
    <input type="hidden" class="js_hidden-input-photos" name="photos" value="">
    <button type="button" class="button button--tertiary" data-overlay="#modal">{__("Cancel")}</button>
    <button type="submit" class="button button--primary js_publisher-btn">{__("Publish")}</button>
  </div>
</form>

<script>
  $(function() {
    /* handle offer input dependencies */
    $('#js_discount-type').on('change', function() {
      switch ($(this).val()) {
        case "discount_percent":
          $("#js_discount-percent").show();
          $("#js_discount-amount").hide();
          $("#js_buy-get-discount").hide();
          $("#js_spend-get-off").hide();
          break;

        case "discount_amount":
          $("#js_discount-percent").hide();
          $("#js_discount-amount").show();
          $("#js_buy-get-discount").hide();
          $("#js_spend-get-off").hide();
          break;

        case "buy_get_discount":
          $("#js_discount-percent").hide();
          $("#js_discount-amount").hide();
          $("#js_buy-get-discount").show();
          $("#js_spend-get-off").hide();
          break;

        case "spend_get_off":
          $("#js_discount-percent").hide();
          $("#js_discount-amount").hide();
          $("#js_buy-get-discount").hide();
          $("#js_spend-get-off").show();
          break;

        case "free_shipping":
          $("#js_discount-percent").hide();
          $("#js_discount-amount").hide();
          $("#js_buy-get-discount").hide();
          $("#js_spend-get-off").hide();
          break;
      }
    });
  });
</script>
