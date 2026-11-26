{if $page != "reels"}
  <!-- ads -->
  {include file='_ads.tpl' _ads=$ads_master['footer'] _master=true}
  <!-- ads -->
{/if}

{if !$_footer_links_rendered && !in_array($page, ['index', 'profile', 'page', 'group', 'event', 'messages', 'reels'])}
  {include file='_footer.links.tpl'}
{/if}

{if $_site_shell}
            </main>
            <!-- page content -->

            {include file='_chat_sidebar.tpl'}
          </div>
        </div>
        <!-- site shell -->
{/if}

</div>
<!-- main wrapper -->

<!-- Themes Demo -->
{if $system['themes_demo_enabled'] && !($user->_logged_in && $system['themes_demo_hide_loggedin'])}
  <button type="button" class="js_modal fixed end-3 top-1/2 z-40 flex -translate-y-1/2 flex-col items-center gap-1 rounded-field border border-base-300 bg-base-100 px-3 py-2.5 text-base-content/80 shadow-lg transition hover:text-primary" data-url="core/themes_demo.php" data-size="large">
    {include file='__svg_icons.tpl' icon="themes_switcher" class="main-icon" width="28px" height="28px"}
    <span class="text-sm font-medium">{__("Themes")}</span>
  </button>
{/if}
<!-- Themes Demo -->

<!-- Panic Mode -->
{if $user->_logged_in && $system['panic_mode_enabled']}
  <div id="panic-mode-content" class="fixed inset-0 z-[100050] hidden overflow-y-auto bg-white p-4 md:p-12">
    <div class="container mx-auto">
      <img class="mx-auto h-auto max-w-full" src="{$system['system_url']}/content/themes/{$system['theme']}/images/screenshots/panic_mode.png" alt="">
    </div>
  </div>
  <button type="button" id="panic-mode-toggle" class="heroui button button--tertiary button--icon-only fixed start-3 bottom-[calc(5rem+env(safe-area-inset-bottom))] z-[100060] size-11 rounded-full border border-base-300 bg-base-100 opacity-25 shadow-lg transition-opacity duration-200 hover:bg-base-100 hover:opacity-100 focus-visible:opacity-100 md:start-5 md:bottom-20" title="{__("Panic Mode")}" aria-label="{__("Panic Mode")}">
    {include file='__svg_icons.tpl' icon="panic" class="action-icon" width="20px" height="20px"}
  </button>
{/if}
<!-- Panic Mode -->



<!-- JS Files -->
{include file='_js_files.tpl'}
<!-- JS Files -->

<!-- JS Templates -->
{include file='_js_templates.tpl'}
<!-- JS Templates -->

<!-- Footer Custom JavaScript -->
{if $system['custome_js_footer']}
  <script>
    {html_entity_decode($system['custome_js_footer'], ENT_QUOTES)}
  </script>
{/if}
<!-- Footer Custom JavaScript -->

<!-- Analytics Code -->
{if $system['analytics_code']}{html_entity_decode($system['analytics_code'], ENT_QUOTES)}{/if}
<!-- Analytics Code -->

<!-- Sounds -->
{if $user->_logged_in}
  <!-- Notification -->
  <audio id="notification-sound" preload="auto">
    <source src="{$system['system_url']}/includes/assets/sounds/notification.mp3" type="audio/mpeg">
  </audio>
  <!-- Notification -->
  {if $system['chat_enabled']}
    <!-- Chat -->
    <audio id="chat-sound" preload="auto">
      <source src="{$system['system_url']}/includes/assets/sounds/chat.mp3" type="audio/mpeg">
    </audio>
    <!-- Chat -->
    <!-- Call -->
    <audio id="chat-calling-sound" preload="auto" loop="true">
      <source src="{$system['system_url']}/includes/assets/sounds/calling.mp3" type="audio/mpeg">
    </audio>
    <!-- Call -->
    <!-- Video -->
    <audio id="chat-ringing-sound" preload="auto" loop="true">
      <source src="{$system['system_url']}/includes/assets/sounds/ringing.mp3" type="audio/mpeg">
    </audio>
    <!-- Video -->
  {/if}
{/if}
<!-- Sounds -->

{if $user->_logged_in}
  {include file='_footer.bottom_bar.tpl'}
{/if}

<!-- PWA Install Banner -->
{if $system['pwa_enabled'] && $system['pwa_banner_enabled']}
  <div class="fixed inset-x-3 bottom-[calc(5rem+env(safe-area-inset-bottom))] z-[45] hidden md:inset-x-auto md:start-6 md:bottom-6 md:w-[22rem]" id="PWAInstallBanner" role="dialog" aria-labelledby="PWAInstallTitle">
    <div class="flex items-center gap-3 rounded-box border border-base-300 bg-base-100 p-3 shadow-lg">
      <img class="size-11 shrink-0 rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" src="{$system['system_uploads']}/{if $system['pwa_192_icon']}{$system['pwa_192_icon']}{else}pwa/icon-192x192.png{/if}" alt="{$system['system_title']}" />
      <div class="flex min-w-0 flex-1 flex-col">
        <span class="truncate text-sm font-semibold text-base-content" id="PWAInstallTitle" title="{$system['system_title']}">{$system['system_title']}</span>
        <span class="truncate text-xs text-base-content/60" title="{__("Add to your home screen")}">{__("Add to your home screen")}</span>
      </div>
      <button type="button" id="PWAInstallButton" class="heroui button button--primary button--sm shrink-0 rounded-[0.625rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]">{__("Install")}</button>
      <button type="button" id="PWAInstallClose" class="heroui button button--ghost button--sm button--icon-only size-7.5 shrink-0 rounded-full -me-1" aria-label="{__("Close")}">
        <span class="icon-[tabler--x] size-4" aria-hidden="true"></span>
      </button>
    </div>
  </div>

  <script>
    function isIos() {
      return /iphone|ipad|ipod/.test(navigator.userAgent.toLowerCase());
    }

    function isInStandaloneMode() {
      return ('standalone' in window.navigator) && window.navigator.standalone;
    }

    $(document).ready(function() {
      $("#PWAInstallClose").on("click", function(e) {
        $("#PWAInstallBanner").addClass("hidden");
        setCookie("PWAInstallCookieHide", 1, 14);
      });
      if (isIos() && !isInStandaloneMode()) {
        let cookie = getCookie("PWAInstallCookieHide");
        if (!cookie) {
          $("#PWAInstallBanner").removeClass("hidden");
        }
      }
    });
    window.addEventListener("beforeinstallprompt", function(event) {
      event.preventDefault();
      if (!getCookie("PWAInstallCookieHide")) {
        $("#PWAInstallBanner").removeClass("hidden");
      }
      window.promptEvent = event;
    });
    window.addEventListener("appinstalled", function() {
      $("#PWAInstallBanner").addClass("hidden");
      setCookie("PWAInstallCookieHide", 1, 14);
    });
    document.addEventListener("click", function(event) {
      if (event.target.matches("#PWAInstallButton")) {
        if (isIos()) {
          alert("To install this app, tap the Share icon and choose 'Add to Home Screen'");
        } else if (window.promptEvent) {
          window.promptEvent.prompt();
        }
      }
    });
  </script>
{/if}
<!-- PWA Install Banner -->

</body>

</html>
