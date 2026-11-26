{include file='_head.tpl'}
{include file='_header.tpl'}

<!-- page content -->
<div class="flex min-h-0 flex-1 flex-col items-center justify-center py-8 text-center">
  <div class="relative flex size-28 items-center justify-center" aria-hidden="true">
    <span class="absolute inset-0 rounded-full bg-primary/5"></span>
    <span class="absolute inset-4 rounded-full bg-primary/10"></span>
    <span class="relative flex size-14 items-center justify-center rounded-box bg-base-100 text-primary shadow-sm ring-1 ring-primary/15">
      <span class="icon-[tabler--lock] size-7"></span>
    </span>
  </div>
  <span class="badge badge-soft badge-primary mt-5 rounded-full px-4 py-3 text-xs font-bold tracking-wide">{__("Permission Needed")}</span>
  <h1 class="mt-4 text-2xl font-semibold tracking-tight">{__("Oops!")}</h1>
  <p class="mt-2 max-w-sm text-sm leading-relaxed text-base-content/60">{$message}</p>
  <div class="mt-8 flex flex-wrap items-center justify-center gap-3">
    <a class="heroui button button--primary" href="{$system['system_url']}">{__("Back to homepage")}</a>
    {if !$user->_logged_in}
      <a class="heroui button button--tertiary text-base-content rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" href="{$system['system_url']}/signin">{__("Sign In")}</a>
    {/if}
  </div>
</div>
<!-- page content -->

{include file='_footer.tpl'}
