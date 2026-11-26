<!-- Fonts -->
{if $system['system_theme_fonts'] == "local"}
  <link rel="stylesheet" href="{$system['system_url']}/content/themes/{$system['theme']}/fonts/fonts.css?v={$system['system_version']}">
{else}
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet" crossorigin="anonymous" />
  {if $system['language']['dir'] == "RTL"}
    <link href="https://fonts.googleapis.com/css2?family=Vazirmatn:wght@100..900&display=swap" rel="stylesheet">
  {/if}
  {if $_mono}
    <link href="https://fonts.googleapis.com/css2?family=Roboto+Mono:wght@400;500;600;700&display=swap" rel="stylesheet">
  {/if}
{/if}
<!-- Fonts -->
