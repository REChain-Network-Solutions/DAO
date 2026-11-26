<!-- footer links -->
<div class="{if $_bare}text-[0.8125rem] text-base-content/60{elseif $_overlay}mt-auto py-5 pb-6 text-[0.8125rem] text-white/75{else}mt-auto border-t border-base-300 pt-5 pb-6 text-[0.8125rem] text-base-content/60{/if}">
  <div class="{if !$_bare && !$_site_shell}w-full mx-auto px-4 sm:px-6{if !$system['fluid_design']} max-w-7xl{/if}{/if}">
    <div class="flex flex-wrap items-center justify-between gap-x-5 gap-y-3">
      <div class="inline-flex flex-wrap items-center gap-3">
        <span>&copy; {date('Y')} {__($system['system_title'])}</span>
        {if $system['languages']}
          {include file='__language_selector.tpl' _overlay=$_overlay}
        {/if}
        {include file='__theme_switcher.tpl' _overlay=$_overlay}
      </div>

      <div class="flex flex-wrap gap-x-4 gap-y-3">
        {if $static_pages}
          {foreach $static_pages as $static_page}
            {if $static_page['page_in_footer']}
              <a class="text-inherit! {if $_overlay}hover:text-white!{else}hover:text-primary!{/if}" href="{$static_page['url']}">
                {__($static_page['page_title'])}
              </a>
            {/if}
          {/foreach}
        {/if}
        {if $system['contact_enabled']}
          <a class="text-inherit! {if $_overlay}hover:text-white!{else}hover:text-primary!{/if}" href="{$system['system_url']}/contacts">
            {__("Contact Us")}
          </a>
        {/if}
        {if $system['support_center_enabled']}
          <a class="text-inherit! {if $_overlay}hover:text-white!{else}hover:text-primary!{/if}" href="{$system['system_url']}/support">
            {__("Support Center")}
          </a>
        {/if}
        {if $system['directory_enabled']}
          <a class="text-inherit! {if $_overlay}hover:text-white!{else}hover:text-primary!{/if}" href="{$system['system_url']}/directory">
            {__("Directory")}
          </a>
        {/if}
      </div>
    </div>
  </div>
</div>
<!-- footer links -->
