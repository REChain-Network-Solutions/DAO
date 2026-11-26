<td class="text-center{if $_popular} bg-primary/5{/if}">
  {if $_value !== ""}
    {$_value}
  {elseif $_enabled}
    <span class="icon-[tabler--circle-check] size-5 shrink-0 align-middle text-primary" aria-hidden="true"></span><span class="sr-only">{__("Yes")}</span>
  {else}
    <span class="text-base-content/40" aria-hidden="true">-</span><span class="sr-only">{__("No")}</span>
  {/if}
</td>
