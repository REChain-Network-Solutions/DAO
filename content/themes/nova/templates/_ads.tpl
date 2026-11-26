{if $_master}

  {if $_ads && !in_array($page, ["static", "settings", "admin"])}
    <div class="{if !$_site_shell}w-full mx-auto px-4 sm:px-6{if !$system['fluid_design']} max-w-7xl{/if}{/if} my-5">
      <!-- ads -->
      <div class="flex flex-col gap-4">
        {foreach $_ads as $ads_unit}
          <div class="card overflow-hidden rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-[#F9F9F9] dark:bg-base-300 shadow-none text-sm">
            {include file='__card_header.tpl' _card_title=__("Sponsored")}
            <div class="card-body rounded-t-3xl corner-squircle supports-[corner-shape:squircle]:rounded-t-[2.5rem] bg-base-100 block break-words px-5 py-4 [&_iframe]:max-w-full [&_img]:max-w-full">{$ads_unit['code']}</div>
          </div>
        {/foreach}
      </div>
      <!-- ads -->
    </div>
  {/if}

{else}

  {if $ads}
    <!-- ads -->
    {foreach $ads as $ads_unit}
      <div class="card overflow-hidden rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-[#F9F9F9] dark:bg-base-300 shadow-none text-sm">
        {include file='__card_header.tpl' _card_title=__("Sponsored")}
        <div class="card-body rounded-t-3xl corner-squircle supports-[corner-shape:squircle]:rounded-t-[2.5rem] bg-base-100 block break-words px-5 py-4 [&_iframe]:max-w-full [&_img]:max-w-full">{$ads_unit['code']}</div>
      </div>
    {/foreach}
    <!-- ads -->
  {/if}

{/if}
