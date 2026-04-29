<div class="card">
  {if $sub_view == ""}
    {include file='admin.settings.system.tpl'}
  {elseif $sub_view == "posts"}
    {include file='admin.settings.posts.tpl'}
  {elseif $sub_view == "ai"}
    {include file='admin.settings.ai.tpl'}
  {elseif $sub_view == "registration"}
    {include file='admin.settings.registration.tpl'}
  {elseif $sub_view == "accounts"}
    {include file='admin.settings.accounts.tpl'}
  {elseif $sub_view == "email"}
    {include file='admin.settings.email.tpl'}
  {elseif $sub_view == "sms"}
    {include file='admin.settings.sms.tpl'}
  {elseif $sub_view == "notifications"}
    {include file='admin.settings.notifications.tpl'}
  {elseif $sub_view == "chat"}
    {include file='admin.settings.chat.tpl'}
  {elseif $sub_view == "live"}
    {include file='admin.settings.live.tpl'}
  {elseif $sub_view == "uploads"}
    {include file='admin.settings.uploads.tpl'}
  {elseif $sub_view == "security"}
    {include file='admin.settings.security.tpl'}
  {elseif $sub_view == "payments"}
    {include file='admin.settings.payments.tpl'}
  {elseif $sub_view == "limits"}
    {include file='admin.settings.limits.tpl'}
  {elseif $sub_view == "analytics"}
    {include file='admin.settings.analytics.tpl'}
  {/if}
</div>