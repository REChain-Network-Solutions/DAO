<!-- Plyr -->
<link rel="stylesheet" href="{$system['system_url']}/node_modules/plyr/dist/plyr.css">
<!-- Plyr -->

{if $user->_logged_in}
  <!-- Quill.js -->
  <link rel="stylesheet" href="{$system['system_url']}/node_modules/quill/dist/quill.bubble.css">
  <link rel="stylesheet" href="{$system['system_url']}/node_modules/quill-mention/dist/quill.mention.min.css">
  <!-- Quill.js -->

  <!-- Tagify -->
  <link rel="stylesheet" href="{$system['system_url']}/node_modules/@yaireo/tagify/dist/tagify.css">
  <!-- Tagify -->

  <!-- Crop Profile Picture -->
  {if in_array($page, ["started", "profile", "page", "group", "event"])}
    <link rel="stylesheet" href="{$system['system_url']}/node_modules/rcrop/dist/rcrop.min.css">
  {/if}
  <!-- Crop Profile Picture -->
{/if}

<!-- CodeMirror -->
{if $page == "admin" && ($view == "design" || ($view == "themes" && ($sub_view == "add" || $sub_view == "edit")) || ($view == "settings" && $sub_view == "uploads"))}
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.21/codemirror.min.css" integrity="sha512-yAvYFCgl0jKssk1XXo079Ec7sVXfN3OIotWiUP7zTrHhcRxMgRnEFjYhesnBZSfYPkd3sX7BmVTaWQLXvITMnQ==" crossorigin="anonymous" referrerpolicy="no-referrer" />
{/if}
<!-- CodeMirror -->

<!-- Cookies Consent -->
{if $system['cookie_consent_enabled']}
  <link rel="stylesheet" href="{$system['system_url']}/node_modules/vanilla-cookieconsent/dist/cookieconsent.css">
{/if}
<!-- Cookies Consent -->
