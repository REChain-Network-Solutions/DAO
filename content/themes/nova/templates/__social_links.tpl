<!-- social links -->
{if $_social_node["`$_social_prefix`_social_facebook"] || $_social_node["`$_social_prefix`_social_twitter"] || $_social_node["`$_social_prefix`_social_youtube"] || $_social_node["`$_social_prefix`_social_instagram"] || $_social_node["`$_social_prefix`_social_twitch"] || $_social_node["`$_social_prefix`_social_linkedin"] || $_social_node["`$_social_prefix`_social_vkontakte"]}
  <div class="border-t border-base-300 pt-4">
    <h3 class="mb-2 text-xs font-semibold tracking-wide text-base-content/50 uppercase">{__("Social Links")}</h3>
    <ul class="-mx-2 space-y-0.5">
      {foreach [['facebook', 'Facebook', 'facebook'], ['twitter', 'X', 'x'], ['youtube', 'YouTube', 'youtube'], ['instagram', 'Instagram', 'instagram'], ['twitch', 'Twitch', 'twitch'], ['linkedin', 'LinkedIn', 'linkedin'], ['vkontakte', 'VK', 'vk']] as $_social}
        {$_social_link = $_social_node["`$_social_prefix`_social_`$_social[0]`"]}
        {if $_social_link}
          <li>
            <a class="group flex items-center gap-3 rounded-xl px-2 py-1.5 text-base-content! transition-colors hover:bg-base-200" target="_blank" rel="nofollow noopener" href="{$_social_link}">
              <span class="flex size-9 shrink-0 items-center justify-center rounded-xl border border-base-300 bg-base-100">
                {include file='__svg_icons.tpl' icon=$_social[2] width="18px" height="18px"}
              </span>
              <span class="min-w-0 flex-1">
                <span class="block text-sm font-medium leading-tight">{$_social[1]}</span>
                <span class="block truncate text-xs text-base-content/50 rtl:text-right" dir="ltr" title='{$_social_link|regex_replace:"#[?\#].*$#":""|regex_replace:"#/+$#":""|regex_replace:"#^.*/#":""}'>{$_social_link|regex_replace:"#[?\#].*$#":""|regex_replace:"#/+$#":""|regex_replace:"#^.*/#":""}</span>
              </span>
              <span class="icon-[tabler--arrow-up-right] size-4 shrink-0 text-base-content/30 transition-colors group-hover:text-base-content/70 rtl:-scale-x-100" aria-hidden="true"></span>
            </a>
          </li>
        {/if}
      {/foreach}
    </ul>
  </div>
{/if}
<!-- social links -->
