{include file='__modal_header.tpl' _icon="icon-[tabler--tag]" _title=__("Edit Offer")}
<form class="js_ajax-forms" data-url="posts/edit.php">
  <div class="modal__body flex flex-col gap-4">
    <div class="grid gap-4 sm:grid-cols-2">
      <!-- discount type -->
      <div class="w-full">
        <label class="label-text mb-1.5 block" for="js_discount-type">{__("Type")}</label>
        <div class="select w-full [--border:1px]">
          <select class="min-w-0 ps-0!" id="js_discount-type" name="discount_type">
            <option value="discount_percent" {if $post['offer']['discount_type'] == "discount_percent"}selected{/if}>{__("Discount Percent")}</option>
            <option value="discount_amount" {if $post['offer']['discount_type'] == "discount_amount"}selected{/if}>{__("Discount Amount")}</option>
            <option value="buy_get_discount" {if $post['offer']['discount_type'] == "buy_get_discount"}selected{/if}>{__("Buy X Get Y Discount")}</option>
            <option value="spend_get_off" {if $post['offer']['discount_type'] == "spend_get_off"}selected{/if}>{__("Spend X Get Y Off")}</option>
            <option value="free_shipping" {if $post['offer']['discount_type'] == "free_shipping"}selected{/if}>{__("Free Shipping")}</option>
          </select>
        </div>
      </div>
      <!-- discount type -->
      <!-- discount percent -->
      <div id="js_discount-percent" class="w-full {if $post['offer']['discount_type'] !="discount_percent"}hidden{/if}">
        <label class="label-text mb-1.5 block" for="offer-editor-discount-percent">{__("Discount Percent")}</label>
        <div class="select w-full [--border:1px]">
          <select class="min-w-0 ps-0!" name="discount_percent" id="offer-editor-discount-percent">
            {for $i=1 to 99}
              <option value="{$i}" {if $post['offer']['discount_percent'] == $i}selected{/if}>{$i}%</option>
            {/for}
          </select>
        </div>
      </div>
      <!-- discount percent -->
      <!-- discount amount -->
      <div id="js_discount-amount" class="w-full {if $post['offer']['discount_type'] !="discount_amount"}hidden{/if}">
        <span class="label-text mb-1.5 block">{__("Discount Amount")}</span>
        <div class="input w-full [--border:1px]">
          {if $system['system_currency_dir'] == "left"}
            <span class="my-auto me-2 shrink-0 font-medium text-base-content/60">{$system['system_currency_symbol']}</span>
          {/if}
          <input name="discount_amount" type="text" class="grow" placeholder="0.00" value="{$post['offer']['discount_amount']}">
          {if $system['system_currency_dir'] == "right"}
            <span class="my-auto ms-2 shrink-0 font-medium text-base-content/60">{$system['system_currency_symbol']}</span>
          {/if}
        </div>
      </div>
      <!-- discount amount -->
    </div>
    <!-- buy get discount -->
    <div id="js_buy-get-discount" {if $post['offer']['discount_type'] != "buy_get_discount"}class="hidden" {/if}>
      <div class="grid gap-4 sm:grid-cols-2">
        <div class="w-full">
          <label class="label-text mb-1.5 block" for="offer-editor-buy-x">{__("Buy")}</label>
          <input name="buy_x" type="text" class="input w-full [--border:1px]" value="{$post['offer']['buy_x']}" id="offer-editor-buy-x">
          <p class="mt-1.5 text-sm text-base-content/60">{__("Enter numric value (Example: 5)")}</p>
        </div>
        <div class="w-full">
          <label class="label-text mb-1.5 block" for="offer-editor-get-y">{__("Get")}</label>
          <input name="get_y" type="text" class="input w-full [--border:1px]" value="{$post['offer']['get_y']}" id="offer-editor-get-y">
          <p class="mt-1.5 text-sm text-base-content/60">{__("Enter numric value (Example: 2)")}</p>
        </div>
      </div>
    </div>
    <!-- buy get discount -->
    <!-- spend get off -->
    <div id="js_spend-get-off" {if $post['offer']['discount_type'] != "spend_get_off"}class="hidden" {/if}>
      <div class="grid gap-4 sm:grid-cols-2">
        <div class="w-full">
          <span class="label-text mb-1.5 block">{__("Spend")}</span>
          <div class="input w-full [--border:1px]">
            {if $system['system_currency_dir'] == "left"}
              <span class="my-auto me-2 shrink-0 font-medium text-base-content/60">{$system['system_currency_symbol']}</span>
            {/if}
            <input name="spend_x" type="text" class="grow" placeholder="0.00" value="{$post['offer']['spend_x']}">
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
            <input name="amount_y" type="text" class="grow" placeholder="0.00" value="{$post['offer']['amount_y']}">
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
        <label class="label-text mb-1.5 block" for="offer-editor-end-date">{__("End Date")}</label>
        <input type="datetime-local" class="input w-full [--border:1px]" name="end_date" value="{$post['offer']['end_date']}" id="offer-editor-end-date">
      </div>
      <!-- end date -->
      <!-- category -->
      <div class="w-full">
        <label class="label-text mb-1.5 block" for="offer-editor-category">{__("Category")}</label>
        <div class="select w-full [--border:1px]">
          <select class="min-w-0 ps-0!" name="category" id="offer-editor-category">
            {foreach $offers_categories as $category}
              {include file='__categories.recursive_options.tpl' data_category=$post['offer']['category_id']}
            {/foreach}
          </select>
        </div>
      </div>
      <!-- category -->
    </div>

    <!-- title -->
    <div class="w-full">
      <label class="label-text mb-1.5 block" for="offer-editor-title">{__("Discounted Items and/or Services")}</label>
      <input name="title" type="text" class="input w-full [--border:1px]" value="{$post['offer']['title']}" id="offer-editor-title">
    </div>
    <!-- title -->
    <!-- original price -->
    <div class="w-full">
      <label class="label-text mb-1.5 block" for="offer-editor-price">{__("Original Price")}</label>
      <input name="price" type="text" class="input w-full [--border:1px]" value="{$post['offer']['price']}" id="offer-editor-price">
    </div>
    <!-- original price -->
    <!-- description -->
    <div class="w-full">
      <label class="label-text mb-1.5 block" for="offer-editor-description">{__("Description")}</label>
      <textarea name="description" rows="5" dir="auto" class="textarea w-full [--border:1px]" id="offer-editor-description">{$post['text_plain']}</textarea>
    </div>
    <!-- description -->
    <!-- custom fields -->
    {if $custom_fields['basic']}
      {include file='__custom_fields.tpl' _custom_fields=$custom_fields['basic'] _registration=false}
    {/if}
    <!-- custom fields -->
    <!-- thumbnail -->
    {if $post['offer']['thumbnail']}
      <div class="w-full">
        <span class="label-text mb-1.5 block">{__("Thumbnail")}</span>
        {include file='__x_image.tpl' _x_name="thumbnail" _x_value=$post['offer']['thumbnail']}
      </div>
    {/if}
    <!-- thumbnail -->
    <!-- error -->
    <div class="alert alert-soft alert-error alert-danger hidden"></div>
    <!-- error -->
  </div>
  <div class="modal__footer justify-end gap-2">
    <input type="hidden" name="handle" value="offer">
    <input type="hidden" name="id" value="{$post['post_id']}">
    <button type="button" class="button button--tertiary" data-overlay="#modal">{__("Cancel")}</button>
    <button type="submit" class="button button--primary">{__("Save")}</button>
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
  })
</script>
