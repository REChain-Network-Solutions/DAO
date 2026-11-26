{if $_variant == "tile"}
  <div class="grid grid-cols-1 gap-4 sm:grid-cols-2 xl:grid-cols-3">
{else}
  <nav class="card overflow-hidden border border-base-300 bg-base-100 shadow-none" aria-label="{__("Directory")}">
    <a class="flex items-center gap-2 border-b border-base-300 px-4 py-3 text-base-content! hover:text-primary!" href="{$system['system_url']}/directory">
      <span class="icon-[tabler--layout-grid] size-4.5 shrink-0 text-base-content/60" aria-hidden="true"></span>
      <span class="text-sm font-semibold">{__("Directory")}</span>
    </a>
    <ul class="menu menu-sm gap-0.5 p-2">
{/if}

{include file='__directory_nav_item.tpl' _variant=$_variant _module="people" _tone="bg-emerald-500/10 hover:bg-emerald-500/15" _icon="icon-[tabler--users]" _active=($_view == "users") _external=false _url="{$system['system_url']}/directory/users" _title=__("Users") _text=__("Help friends know you better and show them what you have in common")}

{if $system['pages_enabled']}
  {include file='__directory_nav_item.tpl' _variant=$_variant _module="pages" _tone="bg-cyan-500/10 hover:bg-cyan-500/15" _icon="icon-[tabler--flag]" _active=($_view == "pages") _external=false _url="{$system['system_url']}/directory/pages" _title=__("Pages") _text=__("Never miss a thing out! Keep in touch with your fans and customers")}
{/if}

{if $system['groups_enabled']}
  {include file='__directory_nav_item.tpl' _variant=$_variant _module="groups" _tone="bg-rose-500/10 hover:bg-rose-500/15" _icon="icon-[tabler--users-group]" _active=($_view == "groups") _external=false _url="{$system['system_url']}/directory/groups" _title=__("Groups") _text=__("Communicate and collaborate with the people who share your interests")}
{/if}

{if $system['events_enabled']}
  {include file='__directory_nav_item.tpl' _variant=$_variant _module="events" _tone="bg-violet-500/10 hover:bg-violet-500/15" _icon="icon-[tabler--calendar-event]" _active=($_view == "events") _external=false _url="{$system['system_url']}/directory/events" _title=__("Events") _text=__("Members can organize community events for online and offline doings")}
{/if}

{include file='__directory_nav_item.tpl' _variant=$_variant _module="posts" _tone="bg-amber-500/10 hover:bg-amber-500/15" _icon="icon-[tabler--news]" _active=($_view == "posts") _external=false _url="{$system['system_url']}/directory/posts" _title=__("Posts") _text=__("See what everyone’s up to and what’s on their minds")}

{if $system['blogs_enabled']}
  {include file='__directory_nav_item.tpl' _variant=$_variant _module="blogs" _tone="bg-sky-500/10 hover:bg-sky-500/15" _icon="icon-[tabler--notebook]" _active=false _external=true _url="{$system['system_url']}/blogs" _title=__("Blogs") _text=__("Sharing thoughts, ideas and creating amazing contents")}
{/if}

{if $system['market_enabled']}
  {include file='__directory_nav_item.tpl' _variant=$_variant _module="marketplace" _tone="bg-orange-500/10 hover:bg-orange-500/15" _icon="icon-[tabler--building-store]" _active=false _external=true _url="{$system['system_url']}/market" _title=__("Marketplace") _text=__("Trusted community marketplace wherein members can post and browse items")}
{/if}

{if $system['funding_enabled']}
  {include file='__directory_nav_item.tpl' _variant=$_variant _module="funding" _tone="bg-teal-500/10 hover:bg-teal-500/15" _icon="icon-[tabler--heart-handshake]" _active=false _external=true _url="{$system['system_url']}/funding" _title=__("Funding") _text=__("Fundraisers make it easy to support friends, family and the causes that are important to you")}
{/if}

{if $system['offers_enabled']}
  {include file='__directory_nav_item.tpl' _variant=$_variant _module="offers" _tone="bg-green-500/10 hover:bg-green-500/15" _icon="icon-[tabler--tag]" _active=false _external=true _url="{$system['system_url']}/offers" _title=__("Offers") _text=__("Find the best offers that you can buy")}
{/if}

{if $system['jobs_enabled']}
  {include file='__directory_nav_item.tpl' _variant=$_variant _module="jobs" _tone="bg-pink-500/10 hover:bg-pink-500/15" _icon="icon-[tabler--briefcase]" _active=false _external=true _url="{$system['system_url']}/jobs" _title=__("Jobs") _text=__("Seeking for a job, You can find theme here")}
{/if}

{if $system['courses_enabled']}
  {include file='__directory_nav_item.tpl' _variant=$_variant _module="courses" _tone="bg-purple-500/10 hover:bg-purple-500/15" _icon="icon-[tabler--school]" _active=false _external=true _url="{$system['system_url']}/courses" _title=__("Courses") _text=__("Learn new skills, pursue your interests or advance your career with our short online courses")}
{/if}

{if $system['forums_enabled']}
  {include file='__directory_nav_item.tpl' _variant=$_variant _module="forums" _tone="bg-lime-500/10 hover:bg-lime-500/15" _icon="icon-[tabler--messages]" _active=false _external=true _url="{$system['system_url']}/forums" _title=__("Forums") _text=__("Forum is an old­school framework for online community")}
{/if}

{if $system['movies_enabled']}
  {include file='__directory_nav_item.tpl' _variant=$_variant _module="movies" _tone="bg-red-500/10 hover:bg-red-500/15" _icon="icon-[tabler--movie]" _active=false _external=true _url="{$system['system_url']}/movies" _title=__("Movies") _text=__("Watching movies always fun, Watch with the people who share your interests")}
{/if}

{if $system['games_enabled']}
  {include file='__directory_nav_item.tpl' _variant=$_variant _module="games" _tone="bg-indigo-500/10 hover:bg-indigo-500/15" _icon="icon-[tabler--device-gamepad-2]" _active=false _external=true _url="{$system['system_url']}/games" _title=__("Games") _text=__("Playing games always fun, Play with the people who share your interests")}
{/if}

{if $_variant == "tile"}
  </div>
{else}
    </ul>
  </nav>
{/if}
