{if !$_badge_size}{$_badge_size = 18}{/if}
{if $_badge == "pro"}{$_badge_icon = "pro_badge"}{else}{$_badge_icon = "verified_badge"}{/if}
{capture name=badge_label}{if $_badge == "pro"}{if $_badge_package}{__($_badge_package)} {__("Member")}{else}{__("Pro User")}{/if}{elseif $_badge_type == "page"}{__("Verified Page")}{else}{__("Verified User")}{/if}{/capture}
<span class="tooltip {if $_badge == "pro"}pro-badge{else}verified-badge{/if} inline-flex shrink-0 [--placement:top] [--strategy:fixed] {$_badge_class}">
  {if $_badge_href}
    <a class="tooltip-toggle inline-flex" href="{$_badge_href}" aria-label="{$smarty.capture.badge_label|escape}">{include file='__svg_icons.tpl' icon=$_badge_icon width="{$_badge_size}px" height="{$_badge_size}px"}</a>
  {else}
    <span class="tooltip-toggle inline-flex" tabindex="0" aria-label="{$smarty.capture.badge_label|escape}">{include file='__svg_icons.tpl' icon=$_badge_icon width="{$_badge_size}px" height="{$_badge_size}px"}</span>
  {/if}
  <span class="tooltip-content tooltip-shown:opacity-100 tooltip-shown:visible" role="tooltip"><span class="tooltip-body px-2 py-1 text-xs font-medium">{$smarty.capture.badge_label}</span></span>
</span>
