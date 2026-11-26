{include file='_head.tpl'}
{include file='_header.tpl'}

<!-- page content -->
<div class="flex min-h-0 flex-1 flex-col items-center justify-center py-8 text-center">
  <div class="relative mb-2 flex items-center justify-center" aria-hidden="true">
    <span class="text-8xl font-bold tabular-nums text-primary/15 sm:text-9xl">404</span>
    <span class="icon-[tabler--search] absolute size-14 text-primary sm:size-16"></span>
  </div>
  <h1 class="text-2xl font-semibold tracking-tight sm:text-3xl">{__("Oops! Page Not Be Found")}</h1>
  <p class="mt-3 max-w-md text-sm leading-relaxed text-base-content/60">{$message}</p>
  <a class="heroui button button--primary mt-8" href="{$system['system_url']}">{__("Back to homepage")}</a>
</div>
<!-- page content -->

{include file='_footer.tpl'}
