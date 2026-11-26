{if $system['landing'] == 'summit'}
  {include file='index.landing.summit.tpl' _summit_do=$do}
{elseif $system['landing'] == 'studio'}
  {include file='index.landing.studio.tpl' _studio_do=$do}
{else}
  {include file='_head.tpl'}
  {include file='_header.tpl'}

  <!-- page content -->
  {capture name="auth_content"}
    {if $system['landing'] == 'orbit' || $system['landing'] == 'liquid'}
      {include file='__sign_form.minimal.tpl' _plain_signup=true}
    {else}
      {include file='__sign_form.minimal.tpl'}
    {/if}
  {/capture}
  {include file='__auth_card.tpl'}
  <!-- page content -->

  {include file='_footer.tpl'}
{/if}
