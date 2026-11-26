{if $system['apple_login_enabled'] || $system['facebook_login_enabled'] || $system['google_login_enabled'] || $system['discord_login_enabled'] || $system['twitter_login_enabled'] || $system['linkedin_login_enabled'] || $system['vkontakte_login_enabled'] || $system['wordpress_login_enabled'] || $system['sngine_login_enabled']}
  {assign var="_divider_class" value="divider"}
  {assign var="_divider_pre" value=''}
  {assign var="_social_pre" value=''}
  {assign var="_social_post" value=''}
  {assign var="_wrap_class" value="flex flex-col gap-2"}
  {if $_style == 'icons'}
    {assign var="_social_list" value="flex flex-wrap gap-3"}
    {assign var="_social_btn" value="heroui button button--outline button--lg button--icon-only h-12 rounded-field grow"}
    {assign var="_social_label" value=false}
  {elseif $_style == 'plain'}
    {assign var="_divider_class" value="divider my-5"}
    {assign var="_social_list" value="flex flex-col gap-3"}
    {assign var="_social_btn" value="heroui button button--tertiary button--lg button--full-width justify-center gap-3 rounded-[0.75rem] border border-base-300 bg-base-100 font-medium text-base-content [--button-fg:var(--color-base-content)] hover:bg-base-200 dark:border-base-content/20"}
    {assign var="_social_label" value=true}
  {elseif $_style == 'terminal'}
    {assign var="_divider_class" value='my-5 text-center font-mono text-[.75rem] text-[#7d8b6f] dark:text-[#3f513f]'}
    {assign var="_divider_pre" value='// '}
    {assign var="_social_pre" value='[ '}
    {assign var="_social_post" value=' ]'}
    {assign var="_social_list" value='flex flex-col gap-2.5'}
    {assign var="_social_btn" value='flex w-full items-center justify-center gap-2 rounded-lg border border-[#cdd6c0] bg-transparent px-3 py-2.5 font-mono text-[.8rem] lowercase text-green-800! transition-colors hover:border-green-700 hover:bg-green-700/5 dark:border-[#1f3320] dark:text-green-300! dark:hover:border-green-400 dark:hover:bg-green-400/5'}
    {assign var="_social_label" value=true}
  {elseif $_style == 'retro'}
    {assign var="_divider_class" value='divider my-5 text-[.75rem] font-extrabold uppercase tracking-[.05em]'}
    {assign var="_social_list" value='flex flex-col gap-3'}
    {assign var="_social_btn" value='flex w-full items-center justify-center gap-2.5 rounded-[10px] border-[3px] border-[#111] bg-white px-3.5 py-3 text-[.8rem] font-extrabold uppercase tracking-[.04em] text-[#111]! shadow-[4px_4px_0_#111] transition-[box-shadow,translate] duration-[120ms] hover:translate-x-0.5 hover:translate-y-0.5 hover:shadow-[2px_2px_0_#111] active:translate-x-1 active:translate-y-1 active:shadow-none dark:border-[#22d3ee] dark:bg-[#0b0724] dark:text-[#f8f5ff]! dark:shadow-[4px_4px_0_#ff2e97] dark:hover:shadow-[2px_2px_0_#ff2e97]'}
    {assign var="_social_label" value=true}
  {elseif $_style == 'summit'}
    {assign var="_divider_class" value='divider my-5'}
    {assign var="_social_list" value='flex flex-col gap-3'}
    {assign var="_social_btn" value='heroui button button--tertiary button--lg button--full-width justify-center gap-3 rounded-[1rem] border border-base-300 bg-base-100 font-medium text-base-content [--button-fg:var(--color-base-content)] hover:bg-base-200 dark:border-base-content/20'}
    {assign var="_social_label" value=true}
  {elseif $_style == 'studio'}
    {assign var="_divider_class" value='divider my-0 text-base-content/50'}
    {assign var="_wrap_class" value="flex flex-col gap-6"}
    {assign var="_social_list" value='flex gap-3'}
    {assign var="_social_btn" value='heroui button button--tertiary button--lg grow rounded-[0.75rem] border-0 bg-base-content/5 text-base-content shadow-none [--button-fg:var(--color-base-content)] hover:bg-base-content/10'}
    {assign var="_social_label" value=false}
  {elseif $_style == 'liquid'}
    {assign var="_divider_class" value="divider my-0"}
    {assign var="_wrap_class" value="flex flex-col gap-5"}
    {assign var="_social_list" value="flex flex-col gap-3"}
    {assign var="_social_btn" value="heroui button button--tertiary button--lg button--full-width justify-center gap-3 rounded-[0.75rem] border border-base-300 bg-base-100 font-medium text-base-content [--button-fg:var(--color-base-content)] hover:bg-base-200 dark:border-base-content/20"}
    {assign var="_social_label" value=true}
  {elseif $_style == 'minimal'}
    {assign var="_divider_class" value="divider my-0"}
    {assign var="_wrap_class" value="flex flex-col gap-6"}
    {assign var="_social_list" value="flex flex-col gap-3"}
    {assign var="_social_btn" value="heroui button button--tertiary button--lg button--full-width justify-center gap-3 rounded-[0.75rem] border border-base-300 bg-base-100 font-medium text-base-content [--button-fg:var(--color-base-content)] hover:bg-base-200 dark:border-base-content/20"}
    {assign var="_social_label" value=true}
  {else}
    {assign var="_social_list" value="flex flex-col gap-2"}
    {assign var="_social_btn" value="heroui button button--outline button--full-width{if $_style == 'large'} button--lg{/if}"}
    {assign var="_social_label" value=true}
  {/if}
  <div class="{$_margin|default:"mt-6"} {$_wrap_class}">
    {if $_or_pos != 'bottom'}
      <div class="{$_divider_class}">{$_divider_pre}{__("or")}</div>
    {/if}
    <div class="{$_social_list}">
      {if $system['apple_login_enabled']}
        <a href="{$system['system_url']}/connect/apple" class="{$_social_btn}" {if !$_social_label}aria-label="{__("Sign in with Apple")}" title="{__("Sign in with Apple")}"{/if}>
          {include file='__svg_icons.tpl' icon="apple" class="size-4" width="16px" height="16px"}
          {if $_social_label}{$_social_pre}{__("Sign in with Apple")}{$_social_post}{/if}
        </a>
      {/if}
      {if $system['google_login_enabled']}
        <a href="{$system['system_url']}/connect/google" class="{$_social_btn}" {if !$_social_label}aria-label="{__("Sign in with Google")}" title="{__("Sign in with Google")}"{/if}>
          {include file='__svg_icons.tpl' icon="google" class="size-4" width="16px" height="16px"}
          {if $_social_label}{$_social_pre}{__("Sign in with Google")}{$_social_post}{/if}
        </a>
      {/if}
      {if $system['facebook_login_enabled']}
        <a href="{$system['system_url']}/connect/facebook" class="{$_social_btn}" {if !$_social_label}aria-label="{__("Sign in with Facebook")}" title="{__("Sign in with Facebook")}"{/if}>
          {include file='__svg_icons.tpl' icon="facebook" class="size-4" width="16px" height="16px"}
          {if $_social_label}{$_social_pre}{__("Sign in with Facebook")}{$_social_post}{/if}
        </a>
      {/if}
      {if $system['twitter_login_enabled']}
        <a href="{$system['system_url']}/connect/twitter" class="{$_social_btn}" {if !$_social_label}aria-label="{__("Sign in with X")}" title="{__("Sign in with X")}"{/if}>
          {include file='__svg_icons.tpl' icon="x" class="size-4" width="16px" height="16px"}
          {if $_social_label}{$_social_pre}{__("Sign in with X")}{$_social_post}{/if}
        </a>
      {/if}
      {if $system['discord_login_enabled']}
        <a href="{$system['system_url']}/connect/discord" class="{$_social_btn}" {if !$_social_label}aria-label="{__("Sign in with Discord")}" title="{__("Sign in with Discord")}"{/if}>
          {include file='__svg_icons.tpl' icon="discord" class="size-4" width="16px" height="16px"}
          {if $_social_label}{$_social_pre}{__("Sign in with Discord")}{$_social_post}{/if}
        </a>
      {/if}
      {if $system['linkedin_login_enabled']}
        <a href="{$system['system_url']}/connect/linkedin" class="{$_social_btn}" {if !$_social_label}aria-label="{__("Sign in with LinkedIn")}" title="{__("Sign in with LinkedIn")}"{/if}>
          {include file='__svg_icons.tpl' icon="linkedin" class="size-4" width="16px" height="16px"}
          {if $_social_label}{$_social_pre}{__("Sign in with LinkedIn")}{$_social_post}{/if}
        </a>
      {/if}
      {if $system['vkontakte_login_enabled']}
        <a href="{$system['system_url']}/connect/vkontakte" class="{$_social_btn}" {if !$_social_label}aria-label="{__("Sign in with VK")}" title="{__("Sign in with VK")}"{/if}>
          {include file='__svg_icons.tpl' icon="vk" class="size-4" width="16px" height="16px"}
          {if $_social_label}{$_social_pre}{__("Sign in with VK")}{$_social_post}{/if}
        </a>
      {/if}
      {if $system['wordpress_login_enabled']}
        <a href="{$system['system_url']}/connect/wordpress" class="{$_social_btn}" {if !$_social_label}aria-label="{__("Sign in with WordPress")}" title="{__("Sign in with WordPress")}"{/if}>
          {include file='__svg_icons.tpl' icon="wordpress" class="size-4" width="16px" height="16px"}
          {if $_social_label}{$_social_pre}{__("Sign in with WordPress")}{$_social_post}{/if}
        </a>
      {/if}
      {if $system['sngine_login_enabled']}
        <a href="https://{$system['sngine_app_domain']}/api/oauth?app_id={$system['sngine_appid']}" class="{$_social_btn}" {if !$_social_label}aria-label="{__("Sign in with")} {$system['sngine_app_name']}" title="{__("Sign in with")} {$system['sngine_app_name']}"{/if}>
          <img src="{$system['system_uploads']}/{$system['sngine_app_icon']}" width="16" height="16" alt="{__({$system['sngine_app_name']})}" class="size-4">
          {if $_social_label}{$_social_pre}{__("Sign in with")} {$system['sngine_app_name']}{$_social_post}{/if}
        </a>
      {/if}
    </div>
    {if $_or_pos == 'bottom'}
      <div class="{$_divider_class}">{$_divider_pre}{__("or")}</div>
    {/if}
  </div>
{/if}
