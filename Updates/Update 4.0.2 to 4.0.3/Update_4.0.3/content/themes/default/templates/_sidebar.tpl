<div class="card main-side-nav-card">
  <div class="card-body with-nav">
    <ul class="main-side-nav">

      <!-- favorites -->
      <li {if $page == "index" && ($view == "" || $view == "discover" || $view == "popular")}class="active" {/if}>
        {if !$user->_logged_in || (!$system['popular_posts_enabled'] && !$system['discover_posts_enabled'])}
          <a href="{$system['system_url']}">
            {include file='__svg_icons.tpl' icon="newsfeed" class="main-icon mr10" width="24px" height="24px"}{__("News Feed")}
          </a>
        {else}
          <a href="#newsfeed" data-bs-toggle="collapse" {if $page == "index" && ($view == "discover" || $view == "popular")}aria-expanded="true" {/if}>
            {include file='__svg_icons.tpl' icon="newsfeed" class="main-icon mr10" width="24px" height="24px"}{__("News Feed")}
          </a>
          <div class='collapse {if $page == "index" && ($view == "discover" || $view == "popular")}show{/if}' id="newsfeed">
            <ul>
              <li {if $page == "index" && $view == ""}class="active" {/if}>
                <a href="{$system['system_url']}">
                  {include file='__svg_icons.tpl' icon="posts_recent" class="main-icon mr10" width="24px" height="24px"}{__("Recent Updates")}
                </a>
              </li>
              {if $system['popular_posts_enabled']}
                <li {if $page == "index" && $view == "popular"}class="active" {/if}>
                  <a href="{$system['system_url']}/popular">
                    {include file='__svg_icons.tpl' icon="popularity" class="main-icon mr10" width="24px" height="24px"}{__("Popular Posts")}
                  </a>
                </li>
              {/if}
              {if $system['discover_posts_enabled']}
                <li {if $page == "index" && $view == "discover"}class="active" {/if}>
                  <a href="{$system['system_url']}/discover">
                    {include file='__svg_icons.tpl' icon="posts_discover" class="main-icon mr10" width="24px" height="24px"}{__("Discover Posts")}
                  </a>
                </li>
              {/if}
            </ul>
          </div>
        {/if}
      </li>

      {if $user->_data['can_write_blogs'] || $user->_data['can_sell_products'] || $user->_data['can_raise_funding'] || $user->_data['can_create_offers'] || $user->_data['can_create_jobs'] || $user->_data['can_create_courses']}
        <a href="#mine" data-bs-toggle="collapse" {if $page == "index" && in_array($view, ['blogs', 'products', 'funding', 'offers', 'jobs', 'courses'])}aria-expanded="true" {/if}>
          {include file='__svg_icons.tpl' icon="my-box" class="main-icon mr10" width="24px" height="24px"}{__("Mine")}
        </a>
        <div class='collapse {if $page == "index" && in_array($view, ['blogs', 'products', 'funding', 'offers', 'jobs', 'courses'])}show{/if}' id="mine">
          <ul>
            {if $user->_data['can_write_blogs']}
              <li {if $page == "index" && $view == "blogs"}class="active" {/if}>
                <a href="{$system['system_url']}/my/blogs">
                  {include file='__svg_icons.tpl' icon="blogs" class="main-icon mr10" width="24px" height="24px"}{__("My Blogs")}
                </a>
              </li>
            {/if}
            {if $user->_data['can_sell_products']}
              <li {if $page == "index" && $view == "products"}class="active" {/if}>
                <a href="{$system['system_url']}/my/products">
                  {include file='__svg_icons.tpl' icon="products" class="main-icon mr10" width="24px" height="24px"}{__("My Products")}
                </a>
              </li>
            {/if}

            {if $user->_data['can_raise_funding']}
              <li {if $page == "index" && $view == "funding"}class="active" {/if}>
                <a href="{$system['system_url']}/my/funding">
                  {include file='__svg_icons.tpl' icon="money-bag" class="main-icon mr10" width="24px" height="24px"}{__("My Funding")}
                </a>
              </li>
            {/if}

            {if $user->_data['can_create_offers']}
              <li {if $page == "index" && $view == "offers"}class="active" {/if}>
                <a href="{$system['system_url']}/my/offers">
                  {include file='__svg_icons.tpl' icon="offers" class="main-icon mr10" width="24px" height="24px"}{__("My Offers")}
                </a>
              </li>
            {/if}

            {if $user->_data['can_create_jobs']}
              <li {if $page == "index" && $view == "jobs"}class="active" {/if}>
                <a href="{$system['system_url']}/my/jobs">
                  {include file='__svg_icons.tpl' icon="jobs" class="main-icon mr10" width="24px" height="24px"}{__("My Jobs")}
                </a>
              </li>
            {/if}

            {if $user->_data['can_create_courses']}
              <li {if $page == "index" && $view == "courses"}class="active" {/if}>
                <a href="{$system['system_url']}/my/courses">
                  {include file='__svg_icons.tpl' icon="courses" class="main-icon mr10" width="24px" height="24px"}{__("My Courses")}
                </a>
              </li>
            {/if}
          </ul>
        </div>
      {/if}

      {if $user->_logged_in}
        <li {if $page == "index" && $view == "saved"}class="active" {/if}>
          <a href="{$system['system_url']}/saved">
            {include file='__svg_icons.tpl' icon="saved" class="main-icon mr10" width="24px" height="24px"}{__("Saved")}
          </a>
        </li>
      {/if}

      {if $user->_data['can_schedule_posts']}
        <li {if $page == "index" && $view == "scheduled"}class="active" {/if}>
          <a href="{$system['system_url']}/scheduled">
            {include file='__svg_icons.tpl' icon="schedule" class="main-icon mr10" width="24px" height="24px"}{__("Scheduled")}
          </a>
        </li>
      {/if}

      {if $user->_logged_in}
        {if $system['memories_enabled']}
          <li {if $page == "index" && $view == "memories"}class="active" {/if}>
            <a href="{$system['system_url']}/memories">
              {include file='__svg_icons.tpl' icon="memories" class="main-icon mr10" width="24px" height="24px"}{__("Memories")}
            </a>
          </li>
        {/if}
      {/if}
      <!-- favorites -->

      <!-- advertising -->
      {if $user->_logged_in}
        {if $user->_data['can_create_ads'] || $system['wallet_enabled'] || $user->_data['can_boost_posts'] || $user->_data['can_boost_pages']}
          <li class="ptb5">
            <small class="text-muted">{__("Advertising")|upper}</small>
          </li>

          {if $user->_data['can_create_ads']}
            <li {if $page == "ads"}class="active" {/if}>
              <a href="{$system['system_url']}/ads">
                {include file='__svg_icons.tpl' icon="ads" class="main-icon mr10" width="24px" height="24px"}{__("Ads Manager")}
              </a>
            </li>
          {/if}

          {if $system['wallet_enabled']}
            <li {if $page == "wallet"}class="active" {/if}>
              <a href="{$system['system_url']}/wallet">
                {include file='__svg_icons.tpl' icon="wallet" class="main-icon mr10" width="24px" height="24px"}{__("Wallet")}
              </a>
            </li>
          {/if}

          {if $user->_data['can_boost_posts'] || $user->_data['can_boost_pages']}
            <a href="#boosted" data-bs-toggle="collapse" {if $page == "index" && ($view == "boosted_posts" || $view == "boosted_pages")}aria-expanded="true" {/if}>
              {include file='__svg_icons.tpl' icon="boosted" class="main-icon mr10" width="24px" height="24px"}{__("Boosted")}
            </a>
            <div class='collapse {if $page == "index" && ($view == "boosted_posts" || $view == "boosted_pages")}show{/if}' id="boosted">
              <ul>
                <li {if $page == "index" && $view == "boosted_posts"}class="active" {/if}>
                  <a href="{$system['system_url']}/boosted/posts">
                    {__("Boosted Posts")}
                  </a>
                </li>
                {if $system['pages_enabled']}
                  <li {if $page == "index" && $view == "boosted_pages"}class="active" {/if}>
                    <a href="{$system['system_url']}/boosted/pages">
                      {__("Boosted Pages")}
                    </a>
                  </li>
                {/if}
              </ul>
            </div>
          {/if}
        {/if}
      {/if}
      <!-- advertising -->

      <!-- explore -->
      <li class="ptb5">
        <small class="text-muted">{__("explore")|upper}</small>
      </li>

      {if $user->_logged_in}
        <li {if $page == "people"}class="active" {/if}>
          <a href="{$system['system_url']}/people">
            {include file='__svg_icons.tpl' icon="find_people" class="main-icon mr10" width="24px" height="24px"}{__("People")}
          </a>
        </li>
      {/if}

      {if $system['pages_enabled']}
        <li {if $page == "pages"}class="active" {/if}>
          <a href="{$system['system_url']}/pages">
            {include file='__svg_icons.tpl' icon="pages" class="main-icon mr10" width="24px" height="24px"}{__("Pages")}
          </a>
        </li>
      {/if}

      {if $system['groups_enabled']}
        <li {if $page == "groups"}class="active" {/if}>
          <a href="{$system['system_url']}/groups">
            {include file='__svg_icons.tpl' icon="groups" class="main-icon mr10" width="24px" height="24px"}{__("Groups")}
          </a>
        </li>
      {/if}

      {if $system['events_enabled']}
        <li {if $page == "events"}class="active" {/if}>
          <a href="{$system['system_url']}/events">
            {include file='__svg_icons.tpl' icon="events" class="main-icon mr10" width="24px" height="24px"}{__("Events")}
          </a>
        </li>
      {/if}

      {if $system['reels_enabled']}
        <li {if $page == "reels"}class="active" {/if}>
          <a href="{$system['system_url']}/reels">
            {include file='__svg_icons.tpl' icon="reels" class="main-icon mr10" width="24px" height="24px"}{__("Reels")}
          </a>
        </li>
      {/if}

      {if $user->_logged_in}
        {if $system['watch_enabled']}
          <li {if $page == "index" && $view == "watch"}class="active" {/if}>
            <a href="{$system['system_url']}/watch">
              {include file='__svg_icons.tpl' icon="watch" class="main-icon mr10" width="24px" height="24px"}{__("Watch")}
            </a>
          </li>
        {/if}
      {/if}

      {if $system['blogs_enabled']}
        <li {if $page == "blogs"}class="active" {/if}>
          <a href="{$system['system_url']}/blogs">
            {include file='__svg_icons.tpl' icon="blogs" class="main-icon mr10" width="24px" height="24px"}{__("Blogs")}
          </a>
        </li>
      {/if}

      {if $system['market_enabled']}
        <li>
          <a href="{$system['system_url']}/market">
            {include file='__svg_icons.tpl' icon="market" class="main-icon mr10" width="24px" height="24px"}{__("Market")}
          </a>
        </li>
      {/if}

      {if $system['funding_enabled']}
        <li {if $page == "funding"}class="active" {/if}>
          <a href="{$system['system_url']}/funding">
            {include file='__svg_icons.tpl' icon="funding" class="main-icon mr10" width="24px" height="24px"}{__("Funding")}
          </a>
        </li>
      {/if}

      {if $system['offers_enabled']}
        <li {if $page == "offers"}class="active" {/if}>
          <a href="{$system['system_url']}/offers">
            {include file='__svg_icons.tpl' icon="offers" class="main-icon mr10" width="24px" height="24px"}{__("Offers")}
          </a>
        </li>
      {/if}

      {if $system['jobs_enabled']}
        <li {if $page == "jobs"}class="active" {/if}>
          <a href="{$system['system_url']}/jobs">
            {include file='__svg_icons.tpl' icon="jobs" class="main-icon mr10" width="24px" height="24px"}{__("Jobs")}
          </a>
        </li>
      {/if}

      {if $system['courses_enabled']}
        <li {if $page == "courses"}class="active" {/if}>
          <a href="{$system['system_url']}/courses">
            {include file='__svg_icons.tpl' icon="courses" class="main-icon mr10" width="24px" height="24px"}{__("Courses")}
          </a>
        </li>
      {/if}

      {if $system['forums_enabled']}
        <li {if $page == "forums"}class="active" {/if}>
          <a href="{$system['system_url']}/forums">
            {include file='__svg_icons.tpl' icon="forums" class="main-icon mr10" width="24px" height="24px"}{__("Forums")}
          </a>
        </li>
      {/if}

      {if $system['movies_enabled']}
        <li {if $page == "movies"}class="active" {/if}>
          <a href="{$system['system_url']}/movies">
            {include file='__svg_icons.tpl' icon="movies" class="main-icon mr10" width="24px" height="24px"}{__("Movies")}
          </a>
        </li>
      {/if}

      {if $system['games_enabled']}
        <li {if $page == "games"}class="active" {/if}>
          <a href="{$system['system_url']}/games">
            {include file='__svg_icons.tpl' icon="games" class="main-icon mr10" width="24px" height="24px"}{__("Games")}
          </a>
        </li>
      {/if}

      {if $system['developers_apps_enabled'] || $system['developers_share_enabled']}
        <li {if $page == "developers"}class="active" {/if}>
          <a href="{$system['system_url']}/developers{if !$system['developers_apps_enabled']}/share{/if}">
            {include file='__svg_icons.tpl' icon="developers" class="main-icon mr10" width="24px" height="24px"}{__("Developers")}
          </a>
        </li>
      {/if}

      {if $system['merits_enabled']}
        <li {if $page == "merits"}class="active" {/if}>
          <a href="{$system['system_url']}/merits">
            {include file='__svg_icons.tpl' icon="merits" class="main-icon mr10" width="24px" height="24px"}{__("Merits")}
          </a>
        </li>
      {/if}

      {if $static_pages}
        {foreach $static_pages as $static_page}
          {if $static_page['page_in_sidebar']}
            <li {if $page == "static_page" && $static_page['page_id'] == $static_page_id}class="active" {/if}>
              <a href="{$static_page['url']}">
                <img width="24" height="24" class="mr10" src="{$static_page['page_icon']}">
                {__($static_page['page_title'])}
              </a>
            </li>
          {/if}
        {/foreach}
      {/if}
      <!-- explore -->
    </ul>
  </div>
</div>