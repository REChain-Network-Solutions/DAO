{include file='_head.tpl'}
{include file='_header.tpl'}

<!-- page content -->
<div class="flex min-h-0 flex-1 flex-col items-center justify-center py-8">
  <div class="flex w-full max-w-lg flex-col items-center rounded-2xl border border-error/20 bg-base-100 px-6 py-10 text-center sm:px-10">
    <div class="relative flex size-24 items-center justify-center" aria-hidden="true">
      <span class="absolute inset-0 rounded-full bg-error/5"></span>
      <span class="absolute inset-3 rounded-full bg-error/10"></span>
      <span class="relative flex size-12 items-center justify-center rounded-box bg-base-100 text-error shadow-sm ring-1 ring-error/15">
        <span class="icon-[tabler--ban] size-6"></span>
      </span>
    </div>
    <span class="badge badge-soft badge-error mt-5 rounded-full px-4 py-3 text-xs font-bold tracking-wide">{__("Banned")}</span>
    <h1 class="mt-4 text-2xl font-semibold tracking-tight">{__("Banned!")}</h1>
    <p class="mt-2 max-w-sm text-sm leading-relaxed text-base-content/60">{__($message)}</p>
    <a class="heroui button button--danger mt-8" href="{$system['system_url']}">{__("Back to homepage")}</a>
  </div>
</div>
<!-- page content -->

{include file='_footer.tpl'}
