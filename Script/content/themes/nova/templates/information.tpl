<!doctype html>
<html lang="{$system['language']['code']}" {if $system['language']['dir'] == "RTL"}dir="rtl" {/if}data-theme="{$system['theme']}{if $system['theme_mode_night']}-dark{/if}">

  <head>
    <!-- Meta -->
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- Meta -->

    <!-- Title -->
    <title>{__("My Information")}</title>
    <!-- Title -->

    {include file='_head.fonts.tpl' _mono=false}

    <!-- CSS (Vite) -->
    {theme_assets entry='app' inline=true}
    <!-- CSS (Vite) -->

    <!-- CSS Customized -->
    {include file='_head.css.tpl'}
    <!-- CSS Customized -->
  </head>

  <body class="min-h-screen bg-base-200 text-base-content">

    <!-- header -->
    <header class="bg-primary px-4 pt-14 pb-28 text-center">
      <a class="text-3xl font-light text-primary-content!" href="{$system['system_url']}">{__($system['system_title'])}</a>
    </header>
    <!-- header -->

    <!-- page content -->
    <main class="mx-auto -mt-16 flex w-full flex-col gap-5 px-4 pb-6 sm:px-6{if !$system['fluid_design']} max-w-7xl{/if}">

      <!-- welcome -->
      <section class="card border border-base-300 bg-base-100 shadow-none">
        <div class="card-body items-center gap-1 p-6 text-center">
          <img class="size-24 rounded-full object-cover ring-4 ring-base-100" src="{$user->_data['user_picture']}" alt="">
          <h1 class="mt-2 max-w-full truncate text-xl font-semibold" title="{$user->_data['user_firstname']} {$user->_data['user_lastname']}">{$user->_data['user_firstname']} {$user->_data['user_lastname']}</h1>
          <span class="max-w-full truncate text-sm text-base-content/60" title="@{$user->_data['user_name']}">@{$user->_data['user_name']}</span>
        </div>
      </section>
      <!-- welcome -->

      <!-- information & sessions -->
      {if $user_data['information']}
        <!-- information -->
        <section class="card overflow-hidden border border-base-300 bg-base-100 shadow-none">
          {include file='__profile_section_head.tpl' _icon="icon-[tabler--id]" _title=__("Your Information")}
          <dl class="divide-y divide-base-300 text-sm">
            <div class="flex items-center justify-between gap-4 px-5 py-3">
              <dt class="shrink-0 text-base-content/60">{__("User ID")}</dt>
              <dd class="min-w-0 truncate font-medium" title="{$user_data['information']['user_id']}">{$user_data['information']['user_id']}</dd>
            </div>
            <div class="flex items-center justify-between gap-4 px-5 py-3">
              <dt class="shrink-0 text-base-content/60">{__("User Name")}</dt>
              <dd class="min-w-0 truncate font-medium" title="{$user_data['information']['user_name']}">{$user_data['information']['user_name']}</dd>
            </div>
            <div class="flex items-center justify-between gap-4 px-5 py-3">
              <dt class="shrink-0 text-base-content/60">{__("User First Name")}</dt>
              <dd class="min-w-0 truncate font-medium" title="{$user_data['information']['user_firstname']}">{$user_data['information']['user_firstname']}</dd>
            </div>
            <div class="flex items-center justify-between gap-4 px-5 py-3">
              <dt class="shrink-0 text-base-content/60">{__("User Last Name")}</dt>
              <dd class="min-w-0 truncate font-medium" title="{$user_data['information']['user_lastname']}">{$user_data['information']['user_lastname']}</dd>
            </div>
            <div class="flex items-center justify-between gap-4 px-5 py-3">
              <dt class="shrink-0 text-base-content/60">{__("User Email")}</dt>
              <dd class="min-w-0 truncate font-medium" title="{$user_data['information']['user_email']}">{$user_data['information']['user_email']}</dd>
            </div>
            <div class="flex items-center justify-between gap-4 px-5 py-3">
              <dt class="shrink-0 text-base-content/60">{__("User Phone")}</dt>
              <dd class="min-w-0 truncate font-medium" title="{$user_data['information']['user_phone']}">{$user_data['information']['user_phone']}</dd>
            </div>
            {if !$system['genders_disabled']}
              <div class="flex items-center justify-between gap-4 px-5 py-3">
                <dt class="shrink-0 text-base-content/60">{__("User Gender")}</dt>
                <dd class="min-w-0 truncate font-medium" title="{__($user_data['information']['user_gender'])}">{__($user_data['information']['user_gender'])}</dd>
              </div>
            {/if}
            <div class="flex items-center justify-between gap-4 px-5 py-3">
              <dt class="shrink-0 text-base-content/60">{__("Joined")}</dt>
              <dd class="min-w-0 truncate font-medium">{$user_data['information']['user_registered']|date_format:"%e %B %Y"}</dd>
            </div>
            <div class="flex items-center justify-between gap-4 px-5 py-3">
              <dt class="shrink-0 text-base-content/60">{__("Last Login")}</dt>
              <dd class="min-w-0 truncate font-medium">{$user_data['information']['user_last_seen']|date_format:"%e %B %Y"}</dd>
            </div>
          </dl>
        </section>
        <!-- information -->

        {if $user_data['information']['dating']}
          <!-- dating -->
          <section class="card overflow-hidden border border-base-300 bg-base-100 shadow-none">
            {include file='__profile_section_head.tpl' _icon="icon-[tabler--heart]" _title=__("Your Dating Profile")}
            <dl class="divide-y divide-base-300 text-sm">
              <div class="flex items-center justify-between gap-4 px-5 py-3">
                <dt class="shrink-0 text-base-content/60">{__("Birthdate")}</dt>
                <dd class="min-w-0 truncate font-medium">{$user_data['information']['dating']['birthdate']|date_format:"%e %B %Y"}</dd>
              </div>
              <div class="flex items-center justify-between gap-4 px-5 py-3">
                <dt class="shrink-0 text-base-content/60">{__("City")}</dt>
                <dd class="min-w-0 truncate font-medium" title="{$user_data['information']['dating']['city']}">{$user_data['information']['dating']['city']}</dd>
              </div>
              <div class="flex items-start justify-between gap-4 px-5 py-3">
                <dt class="shrink-0 text-base-content/60">{__("About Me")}</dt>
                <dd class="min-w-0 text-end font-medium">{$user_data['information']['dating']['bio']}</dd>
              </div>
              <div class="flex items-center justify-between gap-4 px-5 py-3">
                <dt class="shrink-0 text-base-content/60">{__("Joined")}</dt>
                <dd class="min-w-0 truncate font-medium">{$user_data['information']['dating']['time']|date_format:"%e %B %Y"}</dd>
              </div>
            </dl>
          </section>
          <!-- dating -->
        {/if}

        <!-- sessions -->
        <section class="card overflow-hidden border border-base-300 bg-base-100 shadow-none">
          {include file='__profile_section_head.tpl' _icon="icon-[tabler--shield-lock]" _title=__("Your Sessions")}
          {if $user_data['information']['sessions']}
            <div class="overflow-x-auto">
              <table class="table">
                <thead>
                  <tr>
                    <th>{__("ID")}</th>
                    <th>{__("Browser")}</th>
                    <th>{__("OS")}</th>
                    <th>{__("Date")}</th>
                    <th>{__("IP")}</th>
                    <th>{__("Location")}</th>
                  </tr>
                </thead>
                <tbody>
                  {foreach $user_data['information']['sessions'] as $session}
                    <tr>
                      <td>{$session@iteration}</td>
                      <td>
                        <span class="flex flex-wrap items-center gap-2">
                          {$session['user_browser']}
                          {if $session['session_id'] == $user->_data['active_session_id']}
                            <span class="badge badge-soft badge-success badge-sm rounded-full">{__("Active Session")}</span>
                          {/if}
                        </span>
                      </td>
                      <td>{$session['user_os']}</td>
                      <td class="whitespace-nowrap">{$session['session_date']}</td>
                      <td>{$session['user_ip']}</td>
                      <td>{$session['user_location']}</td>
                    </tr>
                  {/foreach}
                </tbody>
              </table>
            </div>
          {else}
            {include file='_no_data.tpl' _empty_icon="icon-[tabler--shield-lock]" _empty_compact=true}
          {/if}
        </section>
        <!-- sessions -->
      {/if}
      <!-- information & sessions -->

      <!-- friends -->
      {if is_array($user_data['friends'])}
        <section class="card overflow-hidden border border-base-300 bg-base-100 shadow-none">
          {capture name=section_title}{__("Your Friends")} <span class="badge badge-soft badge-primary badge-sm rounded-full">{count($user_data['friends'])}</span>{/capture}
          {include file='__profile_section_head.tpl' _icon="icon-[tabler--users]" _title=$smarty.capture.section_title}
          <div class="card-body p-5">
            {if $user_data['friends']}
              <ul class="grid grid-cols-1 gap-4 sm:grid-cols-2 xl:grid-cols-3">
                {foreach $user_data['friends'] as $_user}
                  {include file='__feeds_user.tpl' _tpl="box" _connection=$_user["connection"] _darker=true _no_action=true}
                {/foreach}
              </ul>
            {else}
              {include file='_no_data.tpl' _empty_icon="icon-[tabler--users]" _empty_compact=true}
            {/if}
          </div>
        </section>
      {/if}
      <!-- friends -->

      <!-- followings -->
      {if is_array($user_data['followings'])}
        <section class="card overflow-hidden border border-base-300 bg-base-100 shadow-none">
          {capture name=section_title}{__("Your Followings")} <span class="badge badge-soft badge-primary badge-sm rounded-full">{count($user_data['followings'])}</span>{/capture}
          {include file='__profile_section_head.tpl' _icon="icon-[tabler--user-check]" _title=$smarty.capture.section_title}
          <div class="card-body p-5">
            {if $user_data['followings']}
              <ul class="grid grid-cols-1 gap-4 sm:grid-cols-2 xl:grid-cols-3">
                {foreach $user_data['followings'] as $_user}
                  {include file='__feeds_user.tpl' _tpl="box" _connection=$_user["connection"] _darker=true _no_action=true}
                {/foreach}
              </ul>
            {else}
              {include file='_no_data.tpl' _empty_icon="icon-[tabler--user-check]" _empty_compact=true}
            {/if}
          </div>
        </section>
      {/if}
      <!-- followings -->

      <!-- followers -->
      {if is_array($user_data['followers'])}
        <section class="card overflow-hidden border border-base-300 bg-base-100 shadow-none">
          {capture name=section_title}{__("Your Followers")} <span class="badge badge-soft badge-primary badge-sm rounded-full">{count($user_data['followers'])}</span>{/capture}
          {include file='__profile_section_head.tpl' _icon="icon-[tabler--user-heart]" _title=$smarty.capture.section_title}
          <div class="card-body p-5">
            {if $user_data['followers']}
              <ul class="grid grid-cols-1 gap-4 sm:grid-cols-2 xl:grid-cols-3">
                {foreach $user_data['followers'] as $_user}
                  {include file='__feeds_user.tpl' _tpl="box" _connection=$_user["connection"] _darker=true _no_action=true}
                {/foreach}
              </ul>
            {else}
              {include file='_no_data.tpl' _empty_icon="icon-[tabler--user-heart]" _empty_compact=true}
            {/if}
          </div>
        </section>
      {/if}
      <!-- followers -->

      <!-- pages -->
      {if is_array($user_data['pages'])}
        <section class="card overflow-hidden border border-base-300 bg-base-100 shadow-none">
          {capture name=section_title}{__("Your Likes")} <span class="badge badge-soft badge-primary badge-sm rounded-full">{count($user_data['pages'])}</span>{/capture}
          {include file='__profile_section_head.tpl' _icon="icon-[tabler--flag]" _title=$smarty.capture.section_title}
          <div class="card-body p-5">
            {if $user_data['pages']}
              <ul class="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3">
                {foreach $user_data['pages'] as $_page}
                  {include file='__pages_card.tpl' _darker=true}
                {/foreach}
              </ul>
            {else}
              {include file='_no_data.tpl' _empty_icon="icon-[tabler--flag]" _empty_compact=true}
            {/if}
          </div>
        </section>
      {/if}
      <!-- pages -->

      <!-- groups -->
      {if is_array($user_data['groups'])}
        <section class="card overflow-hidden border border-base-300 bg-base-100 shadow-none">
          {capture name=section_title}{__("Your groups")} <span class="badge badge-soft badge-primary badge-sm rounded-full">{count($user_data['groups'])}</span>{/capture}
          {include file='__profile_section_head.tpl' _icon="icon-[tabler--users-group]" _title=$smarty.capture.section_title}
          <div class="card-body p-5">
            {if $user_data['groups']}
              <ul class="grid grid-cols-2 gap-4 sm:grid-cols-3 lg:grid-cols-4">
                {foreach $user_data['groups'] as $_group}
                  {include file='__feeds_group.tpl' _tpl="box" _darker=true}
                {/foreach}
              </ul>
            {else}
              {include file='_no_data.tpl' _empty_icon="icon-[tabler--users-group]" _empty_compact=true}
            {/if}
          </div>
        </section>
      {/if}
      <!-- groups -->

      <!-- events -->
      {if is_array($user_data['events'])}
        <section class="card overflow-hidden border border-base-300 bg-base-100 shadow-none">
          {capture name=section_title}{__("Your events")} <span class="badge badge-soft badge-primary badge-sm rounded-full">{count($user_data['events'])}</span>{/capture}
          {include file='__profile_section_head.tpl' _icon="icon-[tabler--calendar]" _title=$smarty.capture.section_title}
          <div class="card-body p-5">
            {if $user_data['events']}
              <ul class="grid grid-cols-2 gap-4 sm:grid-cols-3 lg:grid-cols-4">
                {foreach $user_data['events'] as $_event}
                  {include file='__feeds_event.tpl' _tpl="box" _darker=true}
                {/foreach}
              </ul>
            {else}
              {include file='_no_data.tpl' _empty_icon="icon-[tabler--calendar]" _empty_compact=true}
            {/if}
          </div>
        </section>
      {/if}
      <!-- events -->

      <!-- posts -->
      {if is_array($user_data['posts'])}
        <section class="card overflow-hidden border border-base-300 bg-base-100 shadow-none">
          {include file='__profile_section_head.tpl' _icon="icon-[tabler--news]" _title=__("Your posts")}
          <div class="card-body p-5">
            {if $user_data['posts']}
              <ul class="flex flex-col gap-5">
                {foreach $user_data['posts'] as $post}
                  {include file='__feeds_post.tpl' _get="posts_information"}
                {/foreach}
              </ul>
            {else}
              {include file='_no_data.tpl' _empty_icon="icon-[tabler--news]" _empty_compact=true}
            {/if}
          </div>
        </section>
      {/if}
      <!-- posts -->

    </main>
    <!-- page content -->

    <!-- footer -->
    <footer class="px-4 pb-8 text-center text-sm text-base-content/60">
      &copy; {date('Y')} {__($system['system_title'])}
    </footer>
    <!-- footer -->

  </body>

</html>
