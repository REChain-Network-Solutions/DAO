<!-- merits -->
{$_merits = $user->_data['merits_balance']}
{$_merits_percent = 0}
{if $_merits['max'] > 0 && $_merits['remining'] > 0}{$_merits_percent = ($_merits['remining'] * 100 / $_merits['max'])|string_format:"%d"}{/if}
{if $_merits_percent > 100}{$_merits_percent = 100}{/if}
<div class="relative overflow-hidden rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] border border-base-300/70 bg-linear-to-br from-orange-500/15 via-base-100 to-amber-400/15 p-5">
  <span class="pointer-events-none absolute -end-14 -top-14 size-44 rounded-full bg-orange-400/30 blur-3xl" aria-hidden="true"></span>
  <span class="pointer-events-none absolute -bottom-16 -start-12 size-40 rounded-full bg-amber-300/25 blur-3xl" aria-hidden="true"></span>
  <div class="relative flex items-center gap-3">
    {$_merits_icon = ''}{if $system['system_theme_icons'] == 'svg'}{$_merits_icon = 'merits'|theme_module_icon:'size-12 shrink-0'}{/if}
    {if $_merits_icon}
      {$_merits_icon}
    {else}
      <span class="flex size-12 shrink-0 items-center justify-center rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-3xl bg-orange-500/15 text-orange-500">
        <span class="icon-[tabler--award] size-6" aria-hidden="true"></span>
      </span>
    {/if}
    <div class="min-w-0">
      <h2 class="text-base font-semibold">{__("Merits")}</h2>
      <p class="truncate text-xs text-base-content/60" title="{__("Reward people who inspire you")}">{__("Reward people who inspire you")}</p>
    </div>
  </div>
  <div class="relative mt-4 rounded-2xl corner-squircle supports-[corner-shape:squircle]:rounded-3xl bg-base-100/75 p-4 shadow-xs backdrop-blur-sm">
    <div class="flex items-end justify-between gap-3">
      <div class="min-w-0">
        <span class="block text-xs text-base-content/60">{__("Merits left")}</span>
        <span class="mt-0.5 block text-2xl font-bold leading-none tabular-nums">{$_merits['remining']}<span class="text-sm font-medium text-base-content/40"> / {$_merits['max']}</span></span>
      </div>
      <span class="icon-[tabler--sparkles] size-6 shrink-0 text-orange-400" aria-hidden="true"></span>
    </div>
    <div class="progress mt-3 h-2 bg-orange-500/10" role="progressbar" aria-valuenow="{$_merits_percent}" aria-valuemin="0" aria-valuemax="100">
      <div class="progress-bar rounded-full bg-linear-to-r from-orange-500 to-amber-400" style="width: {$_merits_percent}%"></div>
    </div>
    <div class="mt-3 grid grid-cols-2 gap-2 text-xs">
      <div class="flex items-center gap-1.5 text-base-content/60">
        <span class="icon-[tabler--arrow-up-right] size-4 text-orange-500" aria-hidden="true"></span>
        {__("Sent")} <span class="ms-auto font-semibold text-base-content tabular-nums">{$_merits['sent']}</span>
      </div>
      <div class="flex items-center gap-1.5 border-s border-base-300 ps-2 text-base-content/60">
        <span class="icon-[tabler--arrow-down-left] size-4 text-success" aria-hidden="true"></span>
        {__("Received")} <span class="ms-auto font-semibold text-base-content tabular-nums">{$_merits['received']}</span>
      </div>
    </div>
  </div>
  <button type="button" class="js_modal heroui button button--tertiary relative mt-4 w-full rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem] border-0 bg-linear-to-r from-orange-500 to-amber-500 text-white shadow-md shadow-orange-500/25 hover:from-orange-600 hover:to-amber-500" data-size="large" data-url="users/merits.php?do=publish" {if $_merits['remining'] <= 0}disabled{/if}>
    <span class="icon-[tabler--star] size-4.5" aria-hidden="true"></span>{__("Send Merit")}
  </button>
</div>
<!-- merits -->
