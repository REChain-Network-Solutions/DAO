<div class="footer-bottom-bar{if $page == 'reels'}x-hidden{/if}">
  <div class="container">
    <div class="footer-bottom-bar-links">
      <!-- home -->
      <div class="link {if $page == 'index' && $view == ''}active{/if}">
        <a href="{$system['system_url']}">
          {include file='__svg_icons.tpl' icon="header-home" class="header-icon {if $page == "index" && $view == ""}active{/if}" width="24px" height="24px"}
          <div class="title">{__("Home")}</div>
        </a>
      </div>
      <!-- home -->

      <!-- watch -->
      {if $system['reels_enabled']}
        <div class="link {if $page == 'reels'}active{/if}">
          <a href="{$system['system_url']}/reels">
          {include file='__svg_icons.tpl' icon="reels" class="header-icon {if $page == "reels"}active{/if}" width="24px" height="24px"}
          <div class="title">{__("Reels")}</div>
        </a>
      </div>
      {elseif $system['watch_enabled']}
      <div class="link {if $page == 'index' && $view == 'watch'}active{/if}">
        <a href="{$system['system_url']}/watch">
          {include file='__svg_icons.tpl' icon="watch" class="header-icon {if $page == "index" && $view == "watch"}active{/if}" width="24px" height="24px"}
          <div class="title">{__("Watch")}</div>
        </a>
      </div>
      {/if}
      <!-- watch -->

      <!-- add -->
      {if $user->_data['can_publish_posts'] || $user->_data['can_go_live'] || $user->_data['can_add_stories'] || $user->_data['can_write_blogs'] || $user->_data['can_sell_products'] || $user->_data['can_raise_funding'] || $user->_data['can_create_ads'] || $user->_data['can_create_pages'] || $user->_data['can_create_groups'] || $user->_data['can_create_events']}
        <div class="link">
          <a class="dropdown" href="#" data-bs-toggle="dropdown" data-display="static">
            {include file='__svg_icons.tpl' icon="header-plus" class="header-icon" width="24px" height="24px"}
            <div class="title">{__("Add")}</div>
          </a>
          <div class="dropdown-menu dropdown-widget">
            <div class="js_scroller" data-slimScroll-height="360">
              <div class="footer-quick-adds">
                {if $user->_data['can_publish_posts']}
                  <div class="add-quick-item full" data-toggle="modal" data-url="posts/publisher.php">
                    {include file='__svg_icons.tpl' icon="newsfeed" class="main-icon" width="24px" height="24px"}
                    <div class="mt5">{__("Post")}</div>
                  </div>
                {/if}
                {if $user->_data['can_go_live']}
                  <a class="add-quick-item" href="{$system['system_url']}/live">
                    {include file='__svg_icons.tpl' icon="live" class="main-icon" width="24px" height="24px"}
                    <div class="mt5">{__("Live")}</div>
                  </a>
                {/if}
                {if $user->_data['can_add_stories']}
                  <div class="add-quick-item" data-toggle="modal" data-url="posts/story.php?do=create">
                    {include file='__svg_icons.tpl' icon="24_hours" class="main-icon" width="24px" height="24px"}
                    <div class="mt5">{__("Story")}</div>
                  </div>
                {/if}
                {if $user->_data['can_write_blogs']}
                  <a class="add-quick-item" href="{$system['system_url']}/blogs/new">
                    {include file='__svg_icons.tpl' icon="blogs" class="main-icon" width="24px" height="24px"}
                    <div class="mt5">{__("Blog")}</div>
                  </a>
                {/if}
                {if $user->_data['can_sell_products']}
                  <div class="add-quick-item" data-toggle="modal" data-url="posts/product.php?do=create">
                    {include file='__svg_icons.tpl' icon="products" class="main-icon" width="24px" height="24px"}
                    <div class="mt5">{__("Product")}</div>
                  </div>
                {/if}
                {if $user->_data['can_raise_funding']}
                  <div class="add-quick-item" data-toggle="modal" data-url="posts/funding.php?do=create">
                    {include file='__svg_icons.tpl' icon="funding" class="main-icon" width="24px" height="24px"}
                    <div class="mt5">{__("Funding")}</div>
                  </div>
                {/if}
                {if $user->_data['can_create_ads']}
                  <a class="add-quick-item" href="{$system['system_url']}/ads/new">
                    {include file='__svg_icons.tpl' icon="ads" class="main-icon" width="24px" height="24px"}
                    <div class="mt5">{__("Ads")}</div>
                  </a>
                {/if}
                {if $user->_data['can_create_pages']}
                  <div class="add-quick-item" data-toggle="modal" data-url="modules/add.php?type=page">
                    {include file='__svg_icons.tpl' icon="pages" class="main-icon" width="24px" height="24px"}
                    <div class="mt5">{__("Page")}</div>
                  </div>
                {/if}
                {if $user->_data['can_create_groups']}
                  <div class="add-quick-item" data-toggle="modal" data-url="modules/add.php?type=group">
                    {include file='__svg_icons.tpl' icon="groups" class="main-icon" width="24px" height="24px"}
                    <div class="mt5">{__("Group")}</div>
                  </div>
                {/if}
                {if $user->_data['can_create_events']}
                  <div class="add-quick-item" data-toggle="modal" data-url="modules/add.php?type=event">
                    {include file='__svg_icons.tpl' icon="events" class="main-icon" width="24px" height="24px"}
                    <div class="mt5">{__("Event")}</div>
                  </div>
                {/if}
              </div>
            </div>
          </div>
        </div>
      {/if}
      <!-- add -->

      <!-- search -->
      <div class="link {if $page == 'search'}active{/if}">
        <a href="{$system['system_url']}/search">
          {include file='__svg_icons.tpl' icon="header-search" class="header-icon {if $page == "search"}active{/if}" width="24px" height="24px"}
          <div class="title">{__("Search")}</div>
        </a>
      </div>
      <!-- search -->

      <!-- menu -->
      <div class="link">
        {include file='_user_menu.tpl' _as_widget=true}
      </div>
      <!-- menu -->

    </div>
  </div>
</div>