<div class="dropdown relative inline-flex [--placement:bottom-end]">
  <button type="button" class="dropdown-toggle heroui button button--tertiary button--sm rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" id="forum-sort" aria-haspopup="menu" aria-expanded="false" aria-label="{__("Sort")}">
    {if $sort == "top"}{__("Top")}{elseif $sort == "newest"}{__("Newest")}{elseif $sort == "oldest"}{__("Oldest")}{else}{__("Latest")}{/if}
    <span class="icon-[tabler--chevron-down] dropdown-open:rotate-180 size-4" aria-hidden="true"></span>
  </button>
  <div class="dropdown-menu dropdown-open:opacity-100 z-50 hidden w-44 rounded-2xl border border-base-300 bg-base-100 p-2 shadow-lg" role="menu" aria-labelledby="forum-sort">
    <a class="dropdown-item rounded-xl px-3 py-2 text-sm font-medium{if $sort == "latest"} text-primary!{else} text-base-content!{/if}" role="menuitem" href="{$_url}">{__("Latest")}</a>
    <a class="dropdown-item rounded-xl px-3 py-2 text-sm font-medium{if $sort == "top"} text-primary!{else} text-base-content!{/if}" role="menuitem" href="{$_url}?sort=top">{__("Top")}</a>
    <a class="dropdown-item rounded-xl px-3 py-2 text-sm font-medium{if $sort == "newest"} text-primary!{else} text-base-content!{/if}" role="menuitem" href="{$_url}?sort=newest">{__("Newest")}</a>
    <a class="dropdown-item rounded-xl px-3 py-2 text-sm font-medium{if $sort == "oldest"} text-primary!{else} text-base-content!{/if}" role="menuitem" href="{$_url}?sort=oldest">{__("Oldest")}</a>
  </div>
</div>
