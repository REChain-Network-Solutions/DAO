<!doctype html>

<html data-lang="{$system['language']['code']}" {if $system['language']['dir'] == "RTL"}dir="rtl" {/if}data-theme="{$system['theme']}{if $system['theme_mode_night']}-dark{/if}">

  <head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
    <meta name="generator" content="Sngine">
    <meta name="version" content="{$system['system_version']}">
    {if $system['landing_preview']}
      <meta name="robots" content="noindex, nofollow">
    {/if}

    <!-- Title -->
    <title>{$page_title|truncate:70}</title>
    <!-- Title -->

    <!-- Meta -->
    <meta name="description" content="{$page_description|truncate:300}">
    <meta name="keywords" content="{$system['system_keywords']}">
    <!-- Meta -->

    <!-- OG-Meta -->
    <meta property="og:title" content="{$page_title|truncate:70}" />
    <meta property="og:description" content="{$page_description|truncate:300}" />
    <meta property="og:site_name" content="{__($system['system_title'])}" />
    <meta property="og:image" content="{$page_image}" />
    <!-- OG-Meta -->

    <!-- Twitter-Meta -->
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="{$page_title|truncate:70}" />
    <meta name="twitter:description" content="{$page_description|truncate:300}" />
    <meta name="twitter:image" content="{$page_image}" />
    <!-- Twitter-Meta -->

    {if $rss_url}
      <link rel="alternate" type="application/rss+xml" title="{__("RSS")}" href="{$rss_url}">
    {/if}

    <!-- Favicon -->
    {if $system['system_favicon_default']}
      <link rel="shortcut icon" href="{$system['system_url']}/content/themes/{$system['theme']}/images/favicon.png" />
    {elseif $system['system_favicon']}
      <link rel="shortcut icon" href="{$system['system_uploads']}/{$system['system_favicon']}" />
    {/if}
    <!-- Favicon -->

    {include file='_head.fonts.tpl' _mono=($page == "admin" && $view == "license")}

    <!-- CSS + JS (Vite) -->
    {theme_assets entry='app'}
    {theme_assets entry='heroui'}
    <!-- CSS + JS (Vite) -->

    <!-- CSS Plugins -->
    {include file='_css_files.tpl'}
    <!-- CSS Plugins -->

    <!-- CSS Customized -->
    {include file='_head.css.tpl'}
    <!-- CSS Customized -->

    <!-- Header Custom JavaScript -->
    {if $system['custome_js_header']}
      <script>
        {html_entity_decode($system['custome_js_header'], ENT_QUOTES)}
      </script>
    {/if}
    <!-- Header Custom JavaScript -->

    <!-- PWA -->
    {if $system['pwa_enabled']}
      <link rel="manifest" href="{$system['system_url']}/manifest.php">
      <!-- register service worker -->
      <script>
        if ('serviceWorker' in navigator) {
          navigator.serviceWorker.register('/sw.js').then((registration) => {
            console.log('Service Worker registered with scope:', registration.scope);
          }).catch((error) => {
            console.log('Service Worker registration failed:', error);
          });
        }
      </script>
      <!-- register service worker -->
    {else}
      <!-- unregister service worker -->
      <script>
        if ('serviceWorker' in navigator) {
          navigator.serviceWorker.getRegistrations().then(function(registrations) {
            for (let registration of registrations) {
              registration.unregister();
            }
          });
        }
      </script>
      <!-- unregister service worker -->
    {/if}
    <!-- PWA -->

    <!-- AgeVerif Checker -->
    {if !$user->_is_admin && $system['age_restriction'] && $system['ageverif_enabled'] && $system['ageverif_api_key']}
      <script src="https://www.ageverif.com/checker.js?key={$system['ageverif_api_key']}"></script>
    {/if}
    <!-- AgeVerif Checker -->

</head>