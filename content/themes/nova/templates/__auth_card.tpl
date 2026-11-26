{* centred auth card — matches the "minimal" landing design.
   Callers wrap their content in {capture name="auth_content"} … {/capture} first. *}
<div class="flex min-h-[calc(100dvh-5rem)] flex-col items-center justify-center gap-8 px-4 py-12 sm:px-6 lg:px-8">
  <div class="relative flex w-full {$_width|default:"max-w-md"} flex-col items-center gap-6 overflow-hidden rounded-box bg-base-100 px-6 py-12 shadow-md shadow-base-300/20 sm:px-8">
    <div class="absolute top-0 h-52 w-full bg-linear-to-b from-primary/10 to-transparent to-45%"></div>
    {if $system['system_logo']}
      <div class="relative z-1 flex items-center justify-center rounded-xl border border-primary/20 bg-base-100 p-2">
        <img src="{$system['system_uploads']}/{if $system['theme_mode_night'] && $system['system_logo_dark']}{$system['system_logo_dark']}{else}{$system['system_logo']}{/if}" class="size-8 object-contain" alt="{__($system['system_title'])}">
      </div>
    {/if}
    <div class="relative z-1 w-full">
      {$smarty.capture.auth_content nofilter}
    </div>
  </div>
</div>
