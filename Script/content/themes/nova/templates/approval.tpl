{include file='_head.tpl'}
{include file='_header.tpl'}

<!-- page content -->
{capture name="auth_content"}
  <div class="text-center">
    <span class="icon-[tabler--clock-hour-4] mx-auto mb-4 block size-10 text-primary" aria-hidden="true"></span>
    <h2 class="mb-1.5 text-2xl font-semibold">{__("Pending Approval")}</h2>
    <p class="text-base-content/80">{__("Your account is pending approval. You will receive a notification once your account is approved")}</p>
  </div>
{/capture}
{include file='__auth_card.tpl'}
<!-- page content -->

{include file='_footer.tpl'}
