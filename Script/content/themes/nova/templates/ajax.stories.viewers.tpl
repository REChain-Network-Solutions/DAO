{foreach $viewers as $_user}
  {include file='__feeds_user.tpl' _tpl="list" _small=true _connection="" _reaction=$_user['reaction']}
{/foreach}
