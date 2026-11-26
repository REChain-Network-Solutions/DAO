{if !$user->_logged_in && !$system['newsfeed_public']}
  {include file=$system['landing_template']|default:'index.landing.tpl'}
{else}
  {include file='index.newsfeed.tpl'}
{/if}