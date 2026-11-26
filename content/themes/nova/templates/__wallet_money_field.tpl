<div class="w-full">
  <label class="label-text mb-1.5 block" for="wallet-amount">{__("Amount")}</label>
  <div class="input w-full [--border:1px]">
    {if $system['system_currency_dir'] != "right"}
      <span class="my-auto me-2 shrink-0 font-medium text-base-content/60">{$system['system_currency_symbol']}</span>
    {/if}
    <input type="text" class="grow" placeholder="0.00" min="1.00" max="1000" name="amount" id="wallet-amount" inputmode="decimal">
    {if $system['system_currency_dir'] == "right"}
      <span class="my-auto ms-2 shrink-0 font-medium text-base-content/60">{$system['system_currency_symbol']}</span>
    {/if}
  </div>
</div>
