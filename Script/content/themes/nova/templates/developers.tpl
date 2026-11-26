{include file='_head.tpl'}
{include file='_header.tpl'}

<!-- page content -->
<div class="pb-8 sm:pb-12">

  <!-- page heading -->
  {if $view == ""}
    {include file='__page_header.tpl' _title=__("Developers") _text=__("Explore the developer tools we offer") _image="developers.svg"}
  {elseif $view == "apps"}
    {include file='__page_header.tpl' _title=__("My Apps") _text=__("Explore the developer tools we offer") _image="developers.svg"}
  {elseif $view == "new"}
    {include file='__page_header.tpl' _title=__("Create New App") _text=__("Explore the developer tools we offer") _image="developers.svg"}
  {elseif $view == "edit"}
    {include file='__page_header.tpl' _title=__("Edit App") _text=$app['app_name'] _image="developers.svg"}
  {else}
    {include file='__page_header.tpl' _title=__("Share Plugin") _text=__("Explore the developer tools we offer") _image="developers.svg"}
  {/if}
  <!-- page heading -->

  <!-- tabs -->
  <nav class="tabs tabs-bordered mt-6 gap-1 border-b border-base-300 sm:gap-6" aria-label="{__("Developers")}">
    {if $system['developers_apps_enabled']}
      <a class="tab -mb-px h-14 min-w-0 flex-1 flex-col justify-center gap-1 px-0 text-xs font-medium sm:h-11 sm:flex-none sm:shrink-0 sm:flex-row sm:justify-start sm:gap-1.5 sm:text-sm{if $view == ""} tab-active border-primary! text-primary!{else} border-transparent! text-base-content/60! hover:text-base-content!{/if}" href="{$system['system_url']}/developers" {if $view == ""}aria-current="page"{/if}>
        <span class="icon-[tabler--book] size-4 shrink-0" aria-hidden="true"></span>
        <span class="max-w-full truncate" title="{__("Documentation")}">{__("Documentation")}</span>
      </a>
    {/if}
    {if $user->_logged_in && $system['developers_apps_enabled']}
      <a class="tab -mb-px h-14 min-w-0 flex-1 flex-col justify-center gap-1 px-0 text-xs font-medium sm:h-11 sm:flex-none sm:shrink-0 sm:flex-row sm:justify-start sm:gap-1.5 sm:text-sm{if $view == "apps" || $view == "new" || $view == "edit"} tab-active border-primary! text-primary!{else} border-transparent! text-base-content/60! hover:text-base-content!{/if}" href="{$system['system_url']}/developers/apps" {if $view == "apps"}aria-current="page"{/if}>
        <span class="icon-[tabler--apps] size-4 shrink-0" aria-hidden="true"></span>
        <span class="max-w-full truncate" title="{__("My Apps")}">{__("My Apps")}</span>
      </a>
    {/if}
    {if $system['developers_share_enabled']}
      <a class="tab -mb-px h-14 min-w-0 flex-1 flex-col justify-center gap-1 px-0 text-xs font-medium sm:h-11 sm:flex-none sm:shrink-0 sm:flex-row sm:justify-start sm:gap-1.5 sm:text-sm{if $view == "share"} tab-active border-primary! text-primary!{else} border-transparent! text-base-content/60! hover:text-base-content!{/if}" href="{$system['system_url']}/developers/share" {if $view == "share"}aria-current="page"{/if}>
        <span class="icon-[tabler--share] size-4 shrink-0" aria-hidden="true"></span>
        <span class="max-w-full truncate" title="{__("Share Plugin")}">{__("Share Plugin")}</span>
      </a>
    {/if}
  </nav>
  <!-- tabs -->

  {if $view == ""}

    <!-- docs -->
    <div class="mt-6 flex flex-col gap-6">

      <!-- intro -->
      <div class="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
        <p class="max-w-3xl text-sm leading-relaxed text-base-content/70">{__("This documentation explain how to register, configure, and develop your app so you can successfully use our APIs")}</p>
        <span class="badge badge-soft badge-primary shrink-0 rounded-full">{__("API Version")} 1.1</span>
      </div>
      <!-- intro -->

      <!-- create app -->
      <section class="card scroll-mt-24 border border-base-300 bg-base-100 shadow-none" id="create-app" aria-labelledby="docs-create-app">
        <div class="card-header flex items-center gap-3 border-b border-base-300">
          <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-primary/10 text-primary" aria-hidden="true"><span class="icon-[tabler--circle-plus] size-5"></span></span>
          <h2 class="card-title text-lg" id="docs-create-app">{__("Create App")}</h2>
        </div>
        <div class="card-body gap-6 pt-6 text-sm leading-relaxed text-base-content/75">
          <p class="max-w-3xl">
            {__("In order for your app to access our APIs, you must register your app using the")} <a class="link link-primary font-medium" href="{$system['system_url']}/developers/apps">{__("App Dashboard")}</a>. {__("Registration creates an App ID that lets us know who you are, helps us distinguish your app from other apps")}.
          </p>
          <ol class="ms-3.5 flex flex-col gap-6 border-s border-dashed border-base-300 ps-7">
            <li class="relative">
              <span class="absolute -start-[2.625rem] top-0 flex size-7 items-center justify-center rounded-full bg-base-100 text-xs font-semibold text-primary ring-1 ring-base-300">1</span>
              <div class="flex flex-wrap items-center gap-3 pt-0.5">
                <span>{__("You will need to create a new App")}</span>
                <a class="heroui button button--primary button--sm rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" href="{$system['system_url']}/developers/new">
                  <span class="icon-[tabler--plus] size-4" aria-hidden="true"></span>
                  {__("Create New App")}
                </a>
              </div>
            </li>
            <li class="relative">
              <span class="absolute -start-[2.625rem] top-0 flex size-7 items-center justify-center rounded-full bg-base-100 text-xs font-semibold text-primary ring-1 ring-base-300">2</span>
              <div class="pt-0.5">
                {__("Once you created your App you will get your")} <code class="badge badge-soft badge-primary font-mono">app_id</code> {__("and")} <code class="badge badge-soft badge-primary font-mono">app_secret</code>
              </div>
            </li>
          </ol>
        </div>
      </section>
      <!-- create app -->

      <!-- log in with -->
      <section class="card scroll-mt-24 border border-base-300 bg-base-100 shadow-none" id="login-with" aria-labelledby="docs-login-with">
        <div class="card-header flex items-center gap-3 border-b border-base-300">
          <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-info/10 text-info" aria-hidden="true"><span class="icon-[tabler--login-2] size-5"></span></span>
          <h2 class="card-title text-lg" id="docs-login-with">{__("Log in With")}</h2>
        </div>
        <div class="card-body gap-6 pt-6 text-sm leading-relaxed text-base-content/75">
          <p class="max-w-3xl">{__("Log in With system is a fast and convenient way for people to create accounts and log into your app. Our Log in With system enables two scenarios, authentication and asking for permissions to access people's data. You can use Login With system simply for authentication or for both authentication and data access")}.</p>
          <ol class="ms-3.5 flex flex-col gap-8 border-s border-dashed border-base-300 ps-7">
            <li class="relative flex min-w-0 flex-col gap-3">
              <span class="absolute -start-[2.625rem] top-0 flex size-7 items-center justify-center rounded-full bg-base-100 text-xs font-semibold text-info ring-1 ring-base-300">1</span>
              <span class="pt-0.5">{__("Starting the OAuth login process, You need to use a link for your app like this")}:</span>
              {capture name="_code"}&lt;<span class="text-primary">a</span> <span class="text-info">href</span>=<span class="text-success">"{$system['system_url']}/api/oauth?app_id=YOUR_APP_ID"</span>&gt;Log in With {__($system['system_title'])}&lt;/<span class="text-primary">a</span>&gt;{/capture}
              {include file='__code_block.tpl' _id="docs-code-oauth" _lang="HTML" _code=$smarty.capture._code}
              <span>{__("The user will be redirect to Log in With page like this")}</span>
              <div class="flex justify-center rounded-2xl bg-base-200/60 p-4 sm:p-6">
                <img class="w-full max-w-sm rounded-xl shadow-sm" src="{$system['system_url']}/content/themes/{$system['theme']}/images/screenshots/login_with.png" alt="" loading="lazy">
              </div>
            </li>
            <li class="relative flex min-w-0 flex-col gap-3">
              <span class="absolute -start-[2.625rem] top-0 flex size-7 items-center justify-center rounded-full bg-base-100 text-xs font-semibold text-info ring-1 ring-base-300">2</span>
              <span class="pt-0.5">{__("Once the user accpeted your app, the user will be redirected to your App Redirect URL with")} <code class="badge badge-soft badge-info font-mono">auth_key</code> {__("like this")}:</span>
              {capture name="_code"}https://mydomain.com/my_redirect_url.php?<span class="text-info">auth_key</span>=<span class="text-accent">AUTH_KEY</span>{/capture}
              {include file='__code_block.tpl' _id="docs-code-redirect" _lang="URL" _code=$smarty.capture._code}
              <div class="flex items-start gap-3 rounded-xl border border-base-300 bg-base-200/50 p-4 text-sm text-base-content/80" role="note">
                <span class="icon-[tabler--info-circle] mt-0.5 size-5 shrink-0 text-info" aria-hidden="true"></span>
                <span>{__("This")} <code class="badge badge-soft badge-info font-mono">auth_key</code> {__("valid only for one time usage, so once you used it you will not be able to use it again and generate new code you will need to redirect the user to the log in with link again")}.</span>
              </div>
            </li>
          </ol>
        </div>
      </section>
      <!-- log in with -->

      <!-- access token -->
      <section class="card scroll-mt-24 border border-base-300 bg-base-100 shadow-none" id="access-token" aria-labelledby="docs-access-token">
        <div class="card-header flex items-center gap-3 border-b border-base-300">
          <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-warning/10 text-warning" aria-hidden="true"><span class="icon-[tabler--key] size-5"></span></span>
          <h2 class="card-title text-lg" id="docs-access-token">{__("Access Token")}</h2>
        </div>
        <div class="card-body gap-6 pt-6 text-sm leading-relaxed text-base-content/75">
          <p class="max-w-3xl">{__("Once you get the user approval of your app Log in With window and returned with the")} <code class="badge badge-soft badge-info font-mono">auth_key</code> {__("which means that now you are ready to retrive data from our APIs and to start this process you will need to authorize your app and get the")} <code class="badge badge-soft badge-error font-mono">access_token</code> {__("and you can follow our steps to learn how to get it")}.</p>
          <div class="flex min-w-0 flex-col gap-3">
            <span>{__("To get an access token, make an HTTP GET request to the following endpoint like this")}:</span>
            {capture name="_code"}<span class="text-primary">&lt;?php</span>

<span class="text-info">$app_id</span> = <span class="text-success">"YOUR_APP_ID"</span>; <span class="text-base-content/45 italic">// your app id</span>
<span class="text-info">$app_secret</span> = <span class="text-success">"YOUR_APP_SECRET"</span>; <span class="text-base-content/45 italic">// your app secret</span>
<span class="text-info">$auth_key</span> = <span class="text-info">$_GET</span>[<span class="text-success">'auth_key'</span>]; <span class="text-base-content/45 italic">// the returned auth key from previous step</span>

<span class="text-base-content/45 italic">// Prepare the POST data</span>
<span class="text-info">$postData</span> = [
  <span class="text-success">'app_id'</span> =&gt; <span class="text-info">$app_id</span>,
  <span class="text-success">'app_secret'</span> =&gt; <span class="text-info">$app_secret</span>,
  <span class="text-success">'auth_key'</span> =&gt; <span class="text-info">$auth_key</span>
];

<span class="text-base-content/45 italic">// Initialize cURL</span>
<span class="text-info">$ch</span> = <span class="text-accent">curl_init</span>(<span class="text-success">'{$system['system_url']}/api/authorize'</span>);

<span class="text-base-content/45 italic">// Set cURL options for POST</span>
<span class="text-accent">curl_setopt</span>(<span class="text-info">$ch</span>, <span class="text-accent">CURLOPT_RETURNTRANSFER</span>, <span class="text-primary">true</span>);
<span class="text-accent">curl_setopt</span>(<span class="text-info">$ch</span>, <span class="text-accent">CURLOPT_POST</span>, <span class="text-primary">true</span>);
<span class="text-accent">curl_setopt</span>(<span class="text-info">$ch</span>, <span class="text-accent">CURLOPT_POSTFIELDS</span>, <span class="text-accent">http_build_query</span>(<span class="text-info">$postData</span>));

<span class="text-base-content/45 italic">// Execute request</span>
<span class="text-info">$response</span> = <span class="text-accent">curl_exec</span>(<span class="text-info">$ch</span>);

<span class="text-base-content/45 italic">// Check for cURL errors</span>
<span class="text-primary">if</span> (<span class="text-accent">curl_errno</span>(<span class="text-info">$ch</span>)) {
  <span class="text-primary">die</span>(<span class="text-success">'cURL error: '</span> . <span class="text-accent">curl_error</span>(<span class="text-info">$ch</span>));
}

<span class="text-base-content/45 italic">// Decode the JSON response</span>
<span class="text-info">$json</span> = <span class="text-accent">json_decode</span>(<span class="text-info">$response</span>, <span class="text-primary">true</span>);

<span class="text-base-content/45 italic">// Use the access token if available</span>
<span class="text-primary">if</span> (!<span class="text-primary">empty</span>(<span class="text-info">$json</span>[<span class="text-success">'access_token'</span>])) {
  <span class="text-info">$access_token</span> = <span class="text-info">$json</span>[<span class="text-success">'access_token'</span>]; <span class="text-base-content/45 italic">// your access token</span>
}
<span class="text-primary">?&gt;</span>{/capture}
            {include file='__code_block.tpl' _id="docs-code-token" _lang="PHP" _code=$smarty.capture._code}
            <div class="flex items-start gap-3 rounded-xl border border-base-300 bg-base-200/50 p-4 text-sm text-base-content/80" role="note">
              <span class="icon-[tabler--clock-hour-4] mt-0.5 size-5 shrink-0 text-warning" aria-hidden="true"></span>
              <span>{__("This")} <code class="badge badge-soft badge-error font-mono">access_token</code> {__("valid only for only one 1 hour, so once it got invalid you will need to genarte new one by redirect the user to the log in with link again")}.</span>
            </div>
          </div>
        </div>
      </section>
      <!-- access token -->

      <!-- apis -->
      <section class="card scroll-mt-24 border border-base-300 bg-base-100 shadow-none" id="apis" aria-labelledby="docs-apis">
        <div class="card-header flex items-center gap-3 border-b border-base-300">
          <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-success/10 text-success" aria-hidden="true"><span class="icon-[tabler--api] size-5"></span></span>
          <h2 class="card-title text-lg" id="docs-apis">{__("APIs")}</h2>
        </div>
        <div class="card-body gap-6 pt-6 text-sm leading-relaxed text-base-content/75">
          <p class="max-w-3xl">{__("Once you get your")} <code class="badge badge-soft badge-error font-mono">access_token</code> {__("Now you can retrieve informations from our system via HTTP GET requests which supports the following parameters")}</p>

          <div class="flex flex-wrap items-center gap-3 rounded-xl border border-base-300 p-3 sm:p-4" dir="ltr">
            <span class="badge badge-success rounded-md font-mono text-xs font-semibold">GET</span>
            <code class="min-w-0 grow break-all font-mono text-sm text-base-content">/api/get_user_info</code>
            <span class="text-sm text-base-content/60">{__("get user info")}</span>
          </div>

          <div class="grid gap-6 xl:grid-cols-2">
            <div class="flex min-w-0 flex-col gap-3">
              <span>{__("You can retrive user info like this")}</span>
              {capture name="_code"}<span class="text-primary">if</span> (!<span class="text-primary">empty</span>(<span class="text-info">$json</span>[<span class="text-success">'access_token'</span>])) {
  <span class="text-info">$access_token</span> = <span class="text-info">$json</span>[<span class="text-success">'access_token'</span>]; <span class="text-base-content/45 italic">// your access token</span>
  <span class="text-info">$get</span> = <span class="text-accent">file_get_contents</span>(<span class="text-success">"{$system['system_url']}/api/get_user_info?access_token=$access_token"</span>);
}{/capture}
              {include file='__code_block.tpl' _id="docs-code-request" _lang="PHP" _code=$smarty.capture._code}
            </div>
            <div class="flex min-w-0 flex-col gap-3">
              <span>{__("The result will be")}:</span>
              {capture name="_code"}{literal}{
  <span class="text-info">"user_info"</span>: {
    <span class="text-info">"user_id"</span>: <span class="text-success">""</span>,
    <span class="text-info">"user_name"</span>: <span class="text-success">""</span>,
    <span class="text-info">"user_email"</span>: <span class="text-success">""</span>,
    <span class="text-info">"user_firstname"</span>: <span class="text-success">""</span>,
    <span class="text-info">"user_lastname"</span>: <span class="text-success">""</span>,
    <span class="text-info">"user_gender"</span>: <span class="text-success">""</span>,
    <span class="text-info">"user_birthdate"</span>: <span class="text-success">""</span>,
    <span class="text-info">"user_picture"</span>: <span class="text-success">""</span>,
    <span class="text-info">"user_cover"</span>: <span class="text-success">""</span>,
    <span class="text-info">"user_registered"</span>: <span class="text-success">""</span>,
    <span class="text-info">"user_verified"</span>: <span class="text-success">""</span>,
    <span class="text-info">"user_relationship"</span>: <span class="text-success">""</span>,
    <span class="text-info">"user_biography"</span>: <span class="text-success">""</span>,
    <span class="text-info">"user_website"</span>: <span class="text-success">""</span>
  }
}{/literal}{/capture}
              {include file='__code_block.tpl' _id="docs-code-response" _lang="JSON" _code=$smarty.capture._code}
            </div>
          </div>
        </div>
      </section>
      <!-- apis -->

    </div>
    <!-- docs -->

  {elseif $view == "apps"}

    <!-- apps -->
    <div class="mt-6 grid gap-4 sm:grid-cols-2 xl:grid-cols-3">
      {foreach $apps as $app}
        <article class="card border border-base-300 bg-base-100 shadow-none transition-shadow hover:shadow-md">
          <div class="flex flex-col gap-4 p-5">
            <div class="flex items-start gap-4">
              {if $app['app_icon']}
                <img class="size-14 shrink-0 rounded-2xl object-cover shadow-sm" src="{$system['system_uploads']}/{$app['app_icon']}" alt="" loading="lazy">
              {else}
                <span class="flex size-14 shrink-0 items-center justify-center rounded-2xl bg-primary/10 text-primary"><span class="icon-[tabler--app-window] size-7" aria-hidden="true"></span></span>
              {/if}
              <div class="min-w-0 grow">
                <a class="block truncate text-base font-semibold text-base-content! hover:text-primary!" href="{$system['system_url']}/developers/edit/{$app['app_auth_id']}" title="{$app['app_name']}">{$app['app_name']}</a>
                {if $app['app_domain']}
                  <span class="mt-0.5 flex min-w-0 items-center gap-1 text-xs text-base-content/60" dir="ltr">
                    <span class="icon-[tabler--world] size-3.5 shrink-0" aria-hidden="true"></span>
                    <span class="truncate" title="{$app['app_domain']}">{$app['app_domain']}</span>
                  </span>
                {/if}
              </div>
            </div>

            <div class="flex items-center gap-2 rounded-xl bg-base-200/60 px-3 py-2">
              <span class="shrink-0 text-xs text-base-content/60">{__("App ID")}</span>
              <code class="min-w-0 grow truncate font-mono text-xs font-medium" dir="ltr" title="{$app['app_auth_id']}">{$app['app_auth_id']}</code>
              <button type="button" class="heroui button button--ghost button--sm button--icon-only size-6 rounded-full shrink-0 js_clipboard" data-clipboard-text="{$app['app_auth_id']}" title='{__("Copy")}' aria-label='{__("Copy")}'>
                <span class="js-clipboard-default icon-[tabler--copy] size-3.5" aria-hidden="true"></span>
                <span class="js-clipboard-success icon-[tabler--check] hidden size-3.5 text-success" aria-hidden="true"></span>
              </button>
            </div>
          </div>
          <div class="mt-auto flex items-center justify-between gap-3 border-t border-base-300 px-5 py-3">
            <span class="flex items-center gap-1.5 text-xs text-base-content/60">
              <span class="icon-[tabler--calendar] size-3.5" aria-hidden="true"></span>
              <span class="js_moment" data-time="{$app['app_date']}">{$app['app_date']}</span>
            </span>
            <div class="flex items-center gap-1">
              <a class="heroui button button--ghost button--sm button--icon-only size-7.5 rounded-full" href="{$system['system_url']}/developers/edit/{$app['app_auth_id']}" title='{__("Edit")}' aria-label='{__("Edit")}'>
                <span class="icon-[tabler--edit] size-4.5" aria-hidden="true"></span>
              </a>
              <button type="button" class="heroui button button--ghost button--sm button--icon-only size-7.5 rounded-full text-error js_developers-delete-app" data-id="{$app['app_auth_id']}" title='{__("Delete")}' aria-label='{__("Delete")}'>
                <span class="icon-[tabler--trash] size-4.5" aria-hidden="true"></span>
              </button>
            </div>
          </div>
        </article>
      {/foreach}

      <a class="group flex min-h-48 flex-col items-center justify-center gap-3 rounded-box border-2 border-dashed border-base-300 p-5 text-center text-base-content/60! transition-colors hover:border-primary/50 hover:bg-primary/5 hover:text-primary!" href="{$system['system_url']}/developers/new">
        <span class="flex size-12 items-center justify-center rounded-full bg-base-200 transition-colors group-hover:bg-primary/10" aria-hidden="true">
          <span class="icon-[tabler--plus] size-6"></span>
        </span>
        <span class="text-sm font-semibold">{__("Create New App")}</span>
      </a>
    </div>
    <!-- apps -->

  {elseif $view == "new" || $view == "edit"}

    <!-- app form -->
    <form class="js_ajax-forms mx-auto mt-6 flex max-w-3xl flex-col gap-6" data-url="developers/app.php?do={if $view == "edit"}edit&id={$app['app_auth_id']}{else}create{/if}">

      {if $view == "edit"}
        <!-- credentials -->
        <section class="card border border-base-300 bg-base-100 shadow-none" aria-labelledby="app-credentials-title">
          <div class="card-header flex items-center gap-3 border-b border-base-300">
            <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-base-content" aria-hidden="true">
              <span class="icon-[tabler--key] size-5"></span>
            </span>
            <div class="min-w-0">
              <h2 class="card-title text-lg" id="app-credentials-title">{__("App Credentials")}</h2>
              <p class="text-sm text-base-content/60">{__("Use these keys to authorize your app with our APIs")}</p>
            </div>
          </div>
          <div class="card-body gap-5 pt-6">
            <div class="grid gap-5 sm:grid-cols-5">
              <div class="min-w-0 sm:col-span-2">
                <label class="label-text mb-1.5 block" for="app_auth_id">{__("App ID")}</label>
                <div class="input w-full pe-1.5" dir="ltr">
                  <input type="text" class="min-w-0 grow truncate font-mono text-sm" id="app_auth_id" value="{$app['app_auth_id']}" title="{$app['app_auth_id']}" readonly>
                  <button type="button" class="heroui button button--ghost button--sm button--icon-only size-7.5 rounded-field my-auto shrink-0 js_clipboard" data-clipboard-text="{$app['app_auth_id']}" title='{__("Copy")}' aria-label='{__("Copy")} {__("App ID")}'>
                    <span class="js-clipboard-default icon-[tabler--copy] size-4" aria-hidden="true"></span>
                    <span class="js-clipboard-success icon-[tabler--check] hidden size-4 text-success" aria-hidden="true"></span>
                  </button>
                </div>
              </div>
              <div class="min-w-0 sm:col-span-3">
                <label class="label-text mb-1.5 block" for="app_auth_secret">{__("App Secret")}</label>
                <div class="input w-full pe-1.5" dir="ltr">
                  <input type="text" class="min-w-0 grow truncate font-mono text-sm" id="app_auth_secret" value="{$app['app_auth_secret']}" title="{$app['app_auth_secret']}" readonly>
                  <button type="button" class="heroui button button--ghost button--sm button--icon-only size-7.5 rounded-field my-auto shrink-0 js_clipboard" data-clipboard-text="{$app['app_auth_secret']}" title='{__("Copy")}' aria-label='{__("Copy")} {__("App Secret")}'>
                    <span class="js-clipboard-default icon-[tabler--copy] size-4" aria-hidden="true"></span>
                    <span class="js-clipboard-success icon-[tabler--check] hidden size-4 text-success" aria-hidden="true"></span>
                  </button>
                </div>
              </div>
            </div>
            <div class="flex items-start gap-3 rounded-xl border border-base-300 bg-base-200/50 p-4 text-sm text-base-content/80" role="note">
              <span class="icon-[tabler--shield-lock] mt-0.5 size-5 shrink-0 text-warning" aria-hidden="true"></span>
              <span>{__("Keep your App Secret private and never share it or expose it in client-side code")}.</span>
            </div>
          </div>
        </section>
        <!-- credentials -->
      {/if}

      <div class="card border border-base-300 bg-base-100 shadow-none">
        {include file='__settings_card_header.tpl' _icon="icon-[tabler--app-window]" _title=__("App Details") _text=__("Basic information about your App")}
        <div class="card-body gap-6 pt-6">

          <!-- app icon -->
          <div class="flex flex-col gap-4 rounded-xl border border-base-300 p-4 sm:flex-row sm:items-center sm:p-5">
            {if $view == "edit"}
              {include file='__x_image.tpl' _x_name="app_icon" _x_value=$app['app_icon'] _x_class="size-24"}
            {else}
              {include file='__x_image.tpl' _x_name="app_icon" _x_class="size-24"}
            {/if}
            <div class="min-w-0">
              <span class="block text-sm font-semibold" id="app-icon-label">{__("App Icon (1024 x 1024)")}</span>
              <span class="mt-1 block text-xs text-base-content/60">{__("App Icon (1024 x 1024), supported formats (JPG, PNG)")}</span>
            </div>
          </div>
          <!-- app icon -->

          <div class="grid gap-5 sm:grid-cols-2">
            <div class="w-full">
              <label class="label-text mb-1.5 block" for="app_name">{__("App Name")}</label>
              <input type="text" class="input w-full" name="app_name" id="app_name" value="{if $view == "edit"}{$app['app_name']}{/if}">
              <span class="mt-1.5 block text-xs text-base-content/60">{__("Your App Name")}</span>
            </div>
            <div class="w-full">
              <label class="label-text mb-1.5 block" for="app_category">{__("Category")}</label>
              <select class="select w-full" name="app_category" id="app_category">
                <option>{__("Select Category")}</option>
                {foreach $categories as $category}
                  {if $view == "edit"}
                    {include file='__categories.recursive_options.tpl' data_category=$app['app_category_id']}
                  {else}
                    {include file='__categories.recursive_options.tpl'}
                  {/if}
                {/foreach}
              </select>
              <span class="mt-1.5 block text-xs text-base-content/60">{__("Select a category for your App")}</span>
            </div>
            <div class="w-full">
              <label class="label-text mb-1.5 block" for="app_domain">{__("App Domain")}</label>
              <div class="input w-full" dir="ltr">
                <span class="icon-[tabler--world] my-auto me-2 size-4 shrink-0 text-base-content/50" aria-hidden="true"></span>
                <input type="text" class="grow" name="app_domain" id="app_domain" placeholder="www.domain.com" value="{if $view == "edit"}{$app['app_domain']}{/if}">
              </div>
              <span class="mt-1.5 block text-xs text-base-content/60">{__("Your App domain (example: www.domain.com)")}</span>
            </div>
            <div class="w-full">
              <label class="label-text mb-1.5 block" for="app_redirect_url">{__("Redirect URL")}</label>
              <div class="input w-full" dir="ltr">
                <span class="icon-[tabler--link] my-auto me-2 size-4 shrink-0 text-base-content/50" aria-hidden="true"></span>
                <input type="text" class="grow" name="app_redirect_url" id="app_redirect_url" placeholder="https://" value="{if $view == "edit"}{$app['app_redirect_url']}{/if}">
              </div>
              <span class="mt-1.5 block text-xs text-base-content/60">{__("Your App Redirect URL (example: https://www.domain.com/test.php)")}</span>
            </div>
          </div>

          <div class="w-full">
            <label class="label-text mb-1.5 block" for="app_description">{__("App Description")}</label>
            <textarea class="textarea w-full" name="app_description" id="app_description" rows="4">{if $view == "edit"}{$app['app_description']}{/if}</textarea>
            <span class="mt-1.5 block text-xs text-base-content/60">{__("Set a description for your App (maximum 200 characters)")}</span>
          </div>

          <!-- success -->
          <div class="alert alert-success hidden items-center" role="status"></div>
          <!-- success -->

          <!-- error -->
          <div class="alert alert-error alert-danger hidden items-center" role="alert"></div>
          <!-- error -->
        </div>
        <div class="card-footer flex flex-col-reverse gap-3 border-t border-base-300 pt-6 sm:flex-row sm:justify-end">
          <a class="heroui button button--outline w-full sm:w-auto" href="{$system['system_url']}/developers/apps">{__("Cancel")}</a>
          <button type="submit" class="heroui button button--primary w-full sm:w-auto">
            {if $view == "edit"}{__("Save Changes")}{else}{__("Create")}{/if}
          </button>
        </div>
      </div>
    </form>
    <!-- app form -->

  {elseif $view == "share"}

    <!-- share plugin -->
    <div class="mt-6 grid grid-cols-[minmax(0,1fr)] gap-6 lg:grid-cols-[minmax(0,1fr)_20rem] lg:items-start">

      <section class="card border border-base-300 bg-base-100 shadow-none" aria-labelledby="share-plugin-title">
        <div class="card-header flex items-center gap-3 border-b border-base-300">
          <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-primary/10 text-primary" aria-hidden="true"><span class="icon-[tabler--share] size-5"></span></span>
          <h2 class="card-title text-lg" id="share-plugin-title">{__("Share Plugin")}</h2>
        </div>
        <div class="card-body pt-6 text-sm leading-relaxed text-base-content/75">
          <ol class="ms-3.5 flex flex-col gap-8 border-s border-dashed border-base-300 ps-7">
            <li class="relative flex min-w-0 flex-col gap-3">
              <span class="absolute -start-[2.625rem] top-0 flex size-7 items-center justify-center rounded-full bg-base-100 text-xs font-semibold text-primary ring-1 ring-base-300">1</span>
              <span class="pt-0.5">{__("Add the following code in your site, inside the head tag")}:</span>
              {capture name="_code"}&lt;<span class="text-primary">script</span>&gt;
  <span class="text-primary">function</span> <span class="text-accent">SocialShare</span>(url) {
    window.<span class="text-accent">open</span>(<span class="text-success">'{$system['system_url']}/share?url='</span> + url, <span class="text-success">''</span>, <span class="text-success">'height=600,width=800'</span>);
  }
&lt;/<span class="text-primary">script</span>&gt;{/capture}
              {include file='__code_block.tpl' _id="share-code-script" _lang="HTML" _code=$smarty.capture._code}
            </li>
            <li class="relative flex min-w-0 flex-col gap-3">
              <span class="absolute -start-[2.625rem] top-0 flex size-7 items-center justify-center rounded-full bg-base-100 text-xs font-semibold text-primary ring-1 ring-base-300">2</span>
              <span class="pt-0.5">{__("Then place the share button after changing the URL you want to share to your page HTML")}:</span>
              {capture name="_code"}&lt;<span class="text-primary">button</span> <span class="text-info">onclick</span>=<span class="text-success">"SocialShare('http://yoursite.com/')"</span>&gt;Share&lt;/<span class="text-primary">button</span>&gt;{/capture}
              {include file='__code_block.tpl' _id="share-code-url" _lang="HTML" _code=$smarty.capture._code}
            </li>
            <li class="relative flex min-w-0 flex-col gap-3">
              <span class="absolute -start-[2.625rem] top-0 flex size-7 items-center justify-center rounded-full bg-base-100 text-xs font-semibold text-primary ring-1 ring-base-300">3</span>
              <span class="pt-0.5">{__("Also you can use this code to share the current page")}:</span>
              {capture name="_code"}&lt;<span class="text-primary">button</span> <span class="text-info">onclick</span>=<span class="text-success">"SocialShare(window.location.href)"</span>&gt;Share&lt;/<span class="text-primary">button</span>&gt;{/capture}
              {include file='__code_block.tpl' _id="share-code-current" _lang="HTML" _code=$smarty.capture._code}
            </li>
          </ol>
        </div>
      </section>

      <!-- example -->
      <aside class="card border border-base-300 bg-base-100 shadow-none lg:sticky lg:top-24">
        <div class="card-header flex items-center gap-3 border-b border-base-300">
          <span class="inline-flex size-10 shrink-0 items-center justify-center rounded-xl bg-base-200 text-base-content" aria-hidden="true">
            <span class="icon-[tabler--player-play] size-5"></span>
          </span>
          <h2 class="card-title text-lg">{__("Example")}</h2>
        </div>
        <div class="card-body pt-6">
          <div class="flex items-center justify-center rounded-xl border border-dashed border-base-300 bg-base-200/50 px-4 py-8">
            <script>
              function SocialShare(url) {
                window.open(site_path + '/share?url=' + url, '', 'height=600,width=800');
              }
            </script>
            <button type="button" class="heroui button button--primary" onclick="SocialShare(window.location.href)">
              <span class="icon-[tabler--share] size-4" aria-hidden="true"></span>
              {__("Share")}
            </button>
          </div>
        </div>
      </aside>
      <!-- example -->

    </div>
    <!-- share plugin -->

  {/if}

</div>
<!-- page content -->

{include file='_footer.tpl'}
