<!-- need subscription -->
{capture name='locked_cta'}
  {if isset($price)}
    <button type="button" class="js_modal heroui button button--primary h-auto min-h-11 max-w-full gap-2 rounded-full px-6 py-2.5 leading-snug whitespace-normal text-balance {if $_preview}pointer-events-none{/if}" {if $_preview}tabindex="-1" aria-disabled="true"{else}data-url="monetization/controller.php?do=get_plans&node_id={$node_id}&node_type={$node_type}" data-size="large"{/if}>
      <span class="icon-[tabler--crown] size-5 shrink-0" aria-hidden="true"></span>
      <span>{__("Subscribe from")} <span class="font-semibold">{if $discount_enabled}{print_money($price * (1 - $discount_percent / 100))}{else}{print_money($price)}{/if}</span>{if $discount_enabled} <span class="ms-1 font-normal line-through opacity-70">{print_money($price)}</span>{/if}</span>
    </button>
  {/if}
{/capture}
{include file='__locked_content.tpl' _icon="icon-[tabler--crown]" _title=__("This content is for subscribers") _meta='' _text=__("Subscribe to unlock this content") _image=$subscriptions_image _cta=$smarty.capture.locked_cta _framed=$_framed _compact=$_compact _preview=$_preview}
<!-- need subscription -->
