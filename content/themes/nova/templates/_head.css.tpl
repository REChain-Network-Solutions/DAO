{strip}
  {if $system['css_customized']}
    <style type="text/css">
      {if $system['css_background']}
        body {
          background: {$system['css_background']};
        }

      {/if}

      {if $system['css_link_color']}
        a,
        .data-content .name a,
        .text-primary,
        .post-stats-alt,
        .post-stats .fa,
        .side-nav>li.active>a,
        .navbar-container .data-content .name a {
          color: {$system['css_link_color']};
        }

      {/if}

      {if $system['css_btn_primary']}
        .btn-primary,
        .btn-primary:focus,
        .btn-primary:hover,
        .heroui .button--primary,
        .heroui.button--primary {
          background: {$system['css_btn_primary']}!important;
          border-color: {$system['css_btn_primary']}!important;
        }

      {/if}

      {if $system['css_header']}
        .site-topbar {
          background: {$system['css_header']};
        }

      {/if}

      {if $system['css_header_search']}
        .site-topbar .site-topbar-search {
          background: {$system['css_header_search']};
          border-color: {$system['css_header_search']};
        }

      {/if}

      {if $system['css_header_search_color']}
        .site-topbar .site-topbar-search,
        .site-topbar .site-topbar-search span {
          color: {$system['css_header_search_color']};
        }

      {/if}

      {if $system['css_header_icons']}
        .header-icon,
        .header-icon *,
        .site-topbar .site-topbar-icon,
        .site-topbar .site-topbar-icon span {
          color: {$system['css_header_icons']} ! important;
          fill: {$system['css_header_icons']} ! important;
        }

      {/if}

      {if $system['css_header_icons_night']}
        body.night-mode .header-icon,
        body.night-mode .header-icon *,
        [data-theme$="-dark"] .site-topbar .site-topbar-icon,
        [data-theme$="-dark"] .site-topbar .site-topbar-icon span {
          color: {$system['css_header_icons_night']} ! important;
          fill: {$system['css_header_icons_night']} ! important;
        }

      {/if}

      {if $system['css_main_icons']}
        .main-icon,
        .main-icon *,
        .x-form-tools {
          color: {$system['css_main_icons']} ! important;
          fill: {$system['css_main_icons']} ! important;
        }

      {/if}

      {if $system['css_main_icons_night']}
        body.night-mode .main-icon,
        body.night-mode .main-icon *,
        body.night-mode .x-form-tools {
          color: {$system['css_main_icons_night']} ! important;
          fill: {$system['css_main_icons_night']} ! important;
        }

      {/if}

      {if $system['css_action_icons']}
        .action-icon,
        .action-icon * {
          color: {$system['css_action_icons']} ! important;
          fill: {$system['css_action_icons']} ! important;
        }

      {/if}

      {if $system['css_action_icons_night']}
        body.night-mode .action-icon,
        body.night-mode .action-icon * {
          color: {$system['css_action_icons_night']} ! important;
          fill: {$system['css_action_icons_night']} ! important;
        }

      {/if}

      {html_entity_decode($system['css_custome_css'], ENT_QUOTES)}
    </style>
  {/if}
{/strip}