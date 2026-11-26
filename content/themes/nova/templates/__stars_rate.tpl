{for $_star=1 to 5}
  <span class="icon-[tabler--star-filled] {if $_size}{$_size}{else}size-4{/if} {if $rate >= $_star}text-warning{else}text-base-content/20{/if}" aria-hidden="true"></span>
{/for}
