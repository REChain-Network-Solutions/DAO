<!doctype html>

<html data-lang="{$system['language']['code']}" {if $system['language']['dir'] == "RTL"}dir="rtl" {/if}data-theme="admin{if $system['theme_mode_night']}-dark{/if}">

  <head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="generator" content="Sngine">
    <meta name="version" content="{$system['system_version']}">

    <meta name="robots" content="noindex, nofollow">
    <meta name="referrer" content="same-origin">

    <title>{$page_title|truncate:70}</title>

    <!-- Favicon -->
    {if $system['system_favicon_default']}
      <link rel="shortcut icon" href="{$system['system_url']}/content/themes/{$system['theme']}/images/favicon.png" />
    {elseif $system['system_favicon']}
      <link rel="shortcut icon" href="{$system['system_uploads']}/{$system['system_favicon']}" />
    {/if}
    <!-- Favicon -->

    {include file='_head.fonts.tpl' _mono=true}

    <script>
      try {
        if (localStorage.getItem('sngine.admin.sidebar') === 'collapsed') {
          document.documentElement.dataset.adminSidebar = 'collapsed';
        }
      } catch (error) { /* Storage may be unavailable; use the expanded sidebar. */ }
    </script>

    <!-- CSS (Vite) -->
    {theme_assets entry='admin'}
    {theme_assets entry='heroui'}
    <!-- CSS (Vite) -->

    <!-- CSS Plugins -->
    {include file='_css_files.tpl'}
    <!-- CSS Plugins -->

    <!-- Header Custom JavaScript -->
    {if $system['custome_js_header']}
      <script>
        {html_entity_decode($system['custome_js_header'], ENT_QUOTES)}
      </script>
    {/if}
    <!-- Header Custom JavaScript -->

  </head>
