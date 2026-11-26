<div class="card border border-base-300 bg-base-100 shadow-none">
  {include file='__settings_card_header.tpl' _icon="icon-[tabler--user-off]" _title=__("Delete Account") _text=__("Permanently delete your account")}
  <div class="card-body gap-6 pt-6">
    <!-- danger zone -->
    <div class="flex flex-col gap-4 rounded-xl border border-error/30 bg-error/5 p-4 sm:flex-row sm:items-center sm:p-5">
      <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-error/10 text-error" aria-hidden="true">
        <span class="icon-[tabler--alert-triangle] size-5"></span>
      </span>
      <div class="min-w-0 grow">
        <div class="text-sm font-semibold text-error">{__("Delete My Account")}</div>
        <p class="mt-0.5 text-sm text-base-content/70">{__("Once you delete your account you will no longer can access it again")}</p>
      </div>
      <button type="button" class="heroui button button--danger w-full shrink-0 sm:w-auto js_delete-user rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]">
        <span class="icon-[tabler--trash] size-4" aria-hidden="true"></span>
        {__("Delete My Account")}
      </button>
    </div>
    <!-- danger zone -->
  </div>
</div>
