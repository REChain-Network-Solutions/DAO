<!doctype html>

<html data-lang="{$system['language']['code']}" {if $system['language']['dir'] == "RTL"} dir="RTL" {/if}>

  <head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="generator" content="Delus">
    <meta name="version" content="{$system['system_version']}">

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

    <!-- Favicon -->
    {if $system['system_favicon_default']}
      <link rel="shortcut icon" href="{$system['system_url']}/content/themes/{$system['theme']}/images/favicon.png" />
    {elseif $system['system_favicon']}
      <link rel="shortcut icon" href="{$system['system_uploads']}/{$system['system_favicon']}" />
    {/if}
    <!-- Favicon -->

    <!-- Fonts [Poppins|Tajawal|Font-Awesome] -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    {if $system['language']['dir'] == "LTR"}
      <link href="https://fonts.googleapis.com/css?family=Poppins:300,400,500,600,700" rel="stylesheet" crossorigin="anonymous" />
    {else}
      <link href="https://fonts.googleapis.com/css2?family=Tajawal:wght@200;300;400;500;700;800;900&display=swap" rel="stylesheet">
    {/if}
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css" integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <!-- Fonts [Poppins|Tajawal|Font-Awesome] -->

    <!-- CSS -->
    {if $system['language']['dir'] == "LTR"}
      <link href="{$system['system_url']}/node_modules/bootstrap/dist/css/bootstrap.min.css" rel="stylesheet">
      <link href="{$system['system_url']}/content/themes/{$system['theme']}/css/style.min.css?v={$system['system_version']}" rel="stylesheet">
    {else}
      <link rel="stylesheet" href="{$system['system_url']}/node_modules/bootstrap/dist/css/bootstrap.rtl.min.css">
      <link href="{$system['system_url']}/content/themes/{$system['theme']}/css/style.rtl.min.css?v={$system['system_version']}" rel="stylesheet">
    {/if}
    <!-- CSS -->

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