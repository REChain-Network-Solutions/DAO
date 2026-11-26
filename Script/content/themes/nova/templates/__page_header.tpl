{$_header_image = ''}
{if $_image && ("`$smarty.const.ABSPATH`content/themes/`$system['theme']`/images/svg/headers/`$_image`"|is_file)}
  {$_header_image = "`$system['system_url']`/content/themes/`$system['theme']`/images/svg/headers/`$_image`"}
{/if}
<section class="relative overflow-hidden rounded-3xl bg-base-100 text-base-content">
  {if $_header_image}
    <span class="pointer-events-none absolute inset-0 scale-110 bg-cover bg-center opacity-40 blur-2xl" style="background-image: url('{$_header_image}');" aria-hidden="true"></span>
  {else}
    <span class="pointer-events-none absolute inset-0 bg-linear-to-bl from-primary/20 via-primary/5 to-transparent" aria-hidden="true"></span>
  {/if}
  <span class="pointer-events-none absolute inset-0 bg-linear-to-t from-base-100 via-base-100/85 to-base-100/40" aria-hidden="true"></span>

  <div class="relative grid grid-cols-[minmax(0,1fr)_auto] items-center gap-4 px-5 py-5 sm:px-10 sm:py-8 md:min-h-52 md:grid-cols-5 md:gap-6">
    <div class="min-w-0 md:col-span-3">
      <h1 class="text-xl font-bold tracking-tight sm:text-3xl">{$_title}</h1>
      {if $_text}
        <p class="mt-1 max-w-md text-sm text-base-content/70 sm:mt-2 sm:text-base">{$_text}</p>
      {/if}
    </div>
    {if $_header_image}
      <div class="relative md:col-span-2 md:self-stretch">
        <img class="size-16 object-contain drop-shadow-lg sm:size-20 md:absolute md:-bottom-16 md:end-4 md:size-48 md:drop-shadow-2xl lg:size-56" src="{$_header_image}" alt="" loading="lazy">
      </div>
    {/if}
  </div>
</section>
