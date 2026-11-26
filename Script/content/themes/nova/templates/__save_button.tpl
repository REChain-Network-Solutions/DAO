{if $user->_logged_in}
  <button type="button" class="heroui button button--sm button--icon-only rounded-full size-9 {if $_style|default:'outline' == 'text'}button--ghost text-base-content/70{else}button--outline border-base-300 text-base-content{/if} [&.js\_unsave-post]:border-primary/30 [&.js\_unsave-post]:bg-primary/10 [&.js\_unsave-post]:text-primary {if $_saved}js_unsave-post{else}js_save-post{/if}" data-id="{$_post_id}">
    <i class="icon-[tabler--bookmark] size-4 in-[.js\_unsave-post]:hidden" aria-hidden="true"></i>
    <i class="icon-[tabler--bookmark-filled] hidden size-4 in-[.js\_unsave-post]:block" aria-hidden="true"></i>
    <span class="sr-only">{if $_saved}{__("Unsave Post")}{else}{__("Save Post")}{/if}</span>
  </button>
{/if}
