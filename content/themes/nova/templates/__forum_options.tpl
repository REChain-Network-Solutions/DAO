<option value="{$_node['forum_id']}" {if $_node['forum_section'] == '0'}disabled{/if} {if $_selected == $_node['forum_id']}selected{/if}>
  {if $_node['iteration']}{str_repeat("- - ", $_node['iteration'])}{/if}{__($_node['forum_name'])|truncate:40}
</option>
{if $_node['childs']}
  {foreach $_node['childs'] as $_child}
    {include file='__forum_options.tpl' _node=$_child _selected=$_selected}
  {/foreach}
{/if}
