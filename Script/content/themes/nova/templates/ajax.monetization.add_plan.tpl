{include file='__modal_header.tpl' _icon="icon-[tabler--coin]" _title=__("New Plan")}
<form class="js_ajax-forms" data-url="monetization/controller.php?do=insert_plan">
  <div class="modal__body flex flex-col gap-4">
    <!-- title -->
    <div class="w-full">
      <label class="label-text mb-1.5 block" for="monetization-add-plan-title">{__("Title")}</label>
      <input name="title" type="text" class="input w-full [--border:1px]" id="monetization-add-plan-title">
    </div>
    <!-- title -->
    <!-- price -->
    <div class="w-full">
      <label class="label-text mb-1.5 block" for="monetization-add-plan-price">{__("Price")} ({$system['system_currency']})</label>
      <input name="price" type="text" class="input w-full [--border:1px]" id="monetization-add-plan-price">
      <p class="mt-1.5 text-sm text-base-content/60">{__("For example 10, 20, 30 (0 for free)")}</p>
    </div>
    <!-- price -->
    <!-- paid every -->
    <div class="w-full">
      <span class="label-text mb-1.5 block">{__("Paid Every")}</span>
      <div class="grid gap-4 sm:grid-cols-3">
        <div class="sm:col-span-2">
          <input class="input w-full [--border:1px]" name="period_num">
        </div>
        <div>
          <select class="select w-full [--border:1px]" name="period">
            <option value="minute">{__("Minute")}</option>
            <option value="hour">{__("Hour")}</option>
            <option value="day">{__("Day")}</option>
            <option value="week">{__("Week")}</option>
            <option value="month">{__("Month")}</option>
            <option value="year">{__("Year")}</option>
          </select>
        </div>
      </div>
      <p class="mt-1.5 text-sm text-base-content/60">{__("For example 15 days, 2 Months, 1 Year")}</p>
    </div>
    <!-- paid every -->
    <!-- description -->
    <div class="w-full">
      <label class="label-text mb-1.5 block" for="monetization-add-plan-custom-description">{__("Description")}</label>
      <textarea name="custom_description" rows="5" dir="auto" class="textarea w-full [--border:1px]" id="monetization-add-plan-custom-description"></textarea>
    </div>
    <!-- description -->
    <!-- order -->
    <div class="w-full">
      <label class="label-text mb-1.5 block" for="monetization-add-plan-plan-order">{__("Order")}</label>
      <input name="plan_order" type="text" class="input w-full [--border:1px]" id="monetization-add-plan-plan-order">
    </div>
    <!-- order -->
    <!-- error -->
    <div class="alert alert-soft alert-error alert-danger hidden"></div>
    <!-- error -->
  </div>
  <div class="modal__footer justify-end gap-2">
    <input type="hidden" name="node_id" value="{$node_id}">
    <input type="hidden" name="node_type" value="{$node_type}">
    <button type="button" class="button button--tertiary" data-overlay="#modal">{__("Cancel")}</button>
    <button type="submit" class="button button--primary">{__("Publish")}</button>
  </div>
</form>
