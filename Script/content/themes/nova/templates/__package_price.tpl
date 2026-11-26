<div class="flex flex-wrap items-baseline gap-x-1">
  <span class="text-3xl font-semibold text-base-content">{if $package['price'] == 0}{__("Free")}{else}{print_money($package['price'])}{/if}</span>
  <span class="text-sm text-base-content/60">/ {if $package['period'] == "life"}{__("Life Time")}{else}{if $package['period_num'] != '1'}{$package['period_num']} {/if}{__($package['period']|ucfirst)}{/if}</span>
</div>
