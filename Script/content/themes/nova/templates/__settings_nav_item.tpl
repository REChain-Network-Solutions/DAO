<li>
  <a href="{$_url}" class="{if $_active}menu-active{elseif $_danger}text-error!{else}text-base-content!{/if}" {if $_active}aria-current="page" {/if}>
    <span class="{$_icon} size-5 shrink-0" aria-hidden="true"></span>
    <span class="grow">{$_title}</span>
  </a>
</li>
