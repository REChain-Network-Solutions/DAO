<!-- ads -->
{include file='_ads.tpl' _ads=$ads_master['footer'] _master=true}
<!-- ads -->

{if !in_array($page, ['index', 'profile', 'page', 'group', 'event'])}
  {include file='_footer.links.tpl'}
{/if}

</div>
<!-- main wrapper -->

<!-- Dependencies CSS [Twemoji-Awesome] -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/SebastianAigner/twemoji-amazing/twemoji-amazing.css">
<!-- Dependencies CSS [Twemoji-Awesome] -->

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
  <div class="pwa_install_banner" id="PWAInstallBanner">
    <div class="inner">
      <div class="close" id="PWAInstallClose">
        <i class="fa-regular fa-circle-xmark fa-lg"></i>
      </div>
      <div class="logo">
        <img src="{$system['system_uploads']}/{if $system['pwa_192_icon']}{$system['pwa_192_icon']}{else}pwa/icon-192x192.png{/if}" alt="logo" />
      </div>
      <div class="name">
        <span class="title">{$system['system_title']}</span>
        <span class="description">{$system['system_url']}</span>
      </div>
      <div class="cta">
        <button id="PWAInstallButton" class="btn btn-primary rounded-pill">{__("Install")}</button>
      </div>
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
        $("#PWAInstallBanner").removeClass("is-active");
        setCookie("PWAInstallCookieHide", 1, 14);
      });
      if (isIos() && !isInStandaloneMode()) {
        let cookie = getCookie("PWAInstallCookieHide");
        if (!cookie) {
          $("#PWAInstallBanner").addClass("is-active");
        }
      }
    });
    window.addEventListener("beforeinstallprompt", function(event) {
      event.preventDefault();
      if (!getCookie("PWAInstallCookieHide")) {
        $("#PWAInstallBanner").addClass("is-active");
      }
      window.promptEvent = event;
    });
    window.addEventListener("appinstalled", function() {
      $("#PWAInstallBanner").removeClass("is-active");
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