      </main>
      <!-- page content -->

      <!-- footer -->
      <footer class="admin-footer mt-auto flex shrink-0 items-center overflow-visible bg-base-100 border-base-content/20 border-t">
        <div class="admin-footer-bar flex w-full items-center justify-between gap-4 overflow-visible px-6 py-4 text-sm leading-tight">
          <div class="flex min-w-0 items-center gap-3">
            <span class="truncate" title="&copy; {$smarty.now|date_format:"%Y"} {__($system['system_title'])}">&copy; {$smarty.now|date_format:"%Y"} {__($system['system_title'])}</span>
            {if $system['languages']}
              <div class="dropdown admin-footer-language relative inline-flex [--offset:8] [--placement:top-start] [--strategy:absolute]">
                <button type="button" class="dropdown-toggle admin-footer-language-trigger"
                        aria-haspopup="menu" aria-expanded="false" aria-label="{__("Language")}">
                  <img class="admin-footer-language-flag" width="20" height="20" src="{$system['language']['flag']}" alt="">
                  <span>{$system['language']['title']}</span>
                </button>
                <ul class="dropdown-menu dropdown-open:opacity-100 hidden admin-footer-language-menu" role="menu">
                  {foreach $system['languages'] as $language}
                    <li>
                      <a class="dropdown-item{if $system['language']['code'] == $language['code']} dropdown-active{/if}" href="?lang={$language['code']}"{if $system['language']['code'] == $language['code']} aria-current="true"{/if}>
                        <img class="admin-footer-language-flag" width="18" height="18" src="{$language['flag']}" alt="">
                        <span class="admin-footer-language-title">{$language['title']}</span>
                        {if $system['language']['code'] == $language['code']}
                          <span class="icon-[tabler--check] admin-footer-language-check" aria-hidden="true"></span>
                        {/if}
                      </a>
                    </li>
                  {/foreach}
                </ul>
              </div>
            {/if}
            {if $system['system_theme_mode_select']}
              <button type="button" class="admin-footer-language-trigger admin-footer-theme-trigger js_theme-mode" data-mode="{if $system['theme_mode_night']}day{else}night{/if}">
                <span class="admin-theme-sun icon-[tabler--sun] size-4 shrink-0" aria-hidden="true"></span>
                <span class="admin-theme-moon icon-[tabler--moon] size-4 shrink-0" aria-hidden="true"></span>
                <span class="sr-only js_theme-mode-text">{if $system['theme_mode_night']}{__("Day Mode")}{else}{__("Night Mode")}{/if}</span>
              </button>
            {/if}
          </div>
          <span class="shrink-0">{__("Build")} v{$system['system_version']}</span>
        </div>
      </footer>
      <!-- footer -->

    </div>
  </div>

  <audio id="notification-sound" preload="auto">
    <source src="{$system['system_url']}/includes/assets/sounds/notification.mp3" type="audio/mpeg">
  </audio>
  {if $system['chat_enabled']}
    <audio id="chat-sound" preload="auto">
      <source src="{$system['system_url']}/includes/assets/sounds/chat.mp3" type="audio/mpeg">
    </audio>
    <audio id="chat-calling-sound" preload="auto" loop="true">
      <source src="{$system['system_url']}/includes/assets/sounds/calling.mp3" type="audio/mpeg">
    </audio>
    <audio id="chat-ringing-sound" preload="auto" loop="true">
      <source src="{$system['system_url']}/includes/assets/sounds/ringing.mp3" type="audio/mpeg">
    </audio>
  {/if}

  <!-- Command Palette -->
  {include file='_admin_header.search.tpl'}
  <!-- Command Palette -->

  <!-- JS Templates -->
  {include file='_js_templates.admin.tpl'}
  <!-- JS Templates -->

  <!-- JS Files -->
  {include file='_js_files.tpl'}
  <!-- JS Files -->

  <!-- Footer Custom JavaScript -->
  {if $system['custome_js_footer']}
    <script>
      {html_entity_decode($system['custome_js_footer'], ENT_QUOTES)}
    </script>
  {/if}
  <!-- Footer Custom JavaScript -->

</body>

</html>
