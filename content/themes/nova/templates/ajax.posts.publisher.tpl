{if !isset($publisher_edit)}{assign var="publisher_edit" value=false}{/if}
<div class="modal__header shrink-0 flex-row items-center gap-2.5 border-b border-base-300 px-4 py-3 sm:px-5">
  <h6 class="modal__heading min-w-0 flex-1 text-base font-semibold text-base-content">{if $publisher_edit}{__("Edit Post")}{else}{__("Create Post")}{/if}</h6>
  {include file='__close_button.tpl' extra_class='static js_close-publisher-modal' no_overlay=true}
</div>
<div class="modal__body flex min-h-0 flex-col overflow-hidden p-0">
  {include file='_publisher.tpl' _quick_mode=true _modal_mode=true _handle=$publisher_node['handle'] _id=$publisher_node['id'] _name=$publisher_node['name'] _avatar=$publisher_node['avatar'] _target=$publisher_node['target'] _post_as_page=$publisher_node['post_as_page'] _page_id=$publisher_node['page_id'] _node_can_monetize_content=$publisher_node['can_monetize_content'] _node_monetization_enabled=$publisher_node['monetization_enabled'] _node_monetization_plans=$publisher_node['monetization_plans'] _privacy=$publisher_node['privacy'] _publisher_mode=$publisher_mode}
</div>
