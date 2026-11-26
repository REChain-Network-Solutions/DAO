{include file='_admin_head.tpl'}
{include file='_admin_header.tpl'}

<!-- page content -->
{if $licence_page}
  <section class="admin-settings-page" aria-labelledby="admin-licence-page-title">
    <div class="admin-settings-heading grid gap-1.5">
      <h1 id="admin-licence-page-title" class="text-2xl font-semibold">{$licence_page}</h1>
      <p class="text-base-content/60 text-sm">{__("This feature requires a monetization licence.")}</p>
    </div>
    {include file='__licence_lock.tpl'}
  </section>
{elseif is_file("content/themes/`$system.theme`/templates/admin.`$view`.tpl")}
  {include file="admin.$view.tpl"}
{else}
  {include file='__licence_lock.tpl'}
{/if}
<!-- page content -->

{include file='_admin_footer.tpl'}