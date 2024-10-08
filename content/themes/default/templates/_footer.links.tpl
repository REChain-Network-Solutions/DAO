<!-- footer links -->
<div class="{if $system['fluid_design']}container-fluid{else}container{/if}">
  <div class="row footer {if $page == 'index' && !$user->_logged_in}border-top-0{/if}">
    <div class="col-sm-6 dropdown">
      <span class="mr5">&copy; {date('Y')} {__($system['system_title'])}</span>
      <!-- language -->
      <a href="#" class="language-dropdown" data-bs-toggle="dropdown">
        <img width="16" height="16" class="mr10" src="{$system['language']['flag']}">
        <span>{$system['language']['title']}</span>
      </a>
      <div class="dropdown-menu">
        <div class="js_scroller">
          {foreach $system['languages'] as $language}
            <a class="dropdown-item" href="?lang={$language['code']}">
              <img width="16" height="16" class="mr10" src="{$language['flag']}">{$language['title']}
            </a>
          {/foreach}
        </div>
      </div>
      <!-- language -->
    </div>

    <div class="col-sm-6 links">
      {if $static_pages}
        {foreach $static_pages as $static_page}
          {if $static_page['page_in_footer']}
            <a {if !$static_page@first}class="pl10" {/if} href="{$static_page['url']}">
              {__($static_page['page_title'])}
            </a>
          {/if}
        {/foreach}
      {/if}
      {if $system['contact_enabled']}
        <a class="pl10" href="{$system['system_url']}/contacts">
          {__("Contact Us")}
        </a>
      {/if}
      {if $system['directory_enabled']}
        <a class="pl10" href="{$system['system_url']}/directory">
          {__("Directory")}
        </a>
      {/if}
    </div>
  </div>
</div>
<!-- footer links -->