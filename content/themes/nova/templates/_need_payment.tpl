<!-- need payment -->
{if $discounted_price}{$_pay_price = $discounted_price}{else}{$_pay_price = $price}{/if}
{capture name='locked_meta'}{if $post_type == 'photos' || $post_type == 'album'}{__("Photos")}{elseif $post_type == 'video' || $post_type == 'reel' || $post_type == 'live'}{__("Video")}{elseif $post_type == 'audio'}{__("Audio")}{elseif $post_type == 'file'}{__("File")}{elseif $post_type}{__("Post")}{/if}{/capture}
{capture name='locked_cta'}
  <button type="button" class="js_modal heroui button button--primary h-auto min-h-11 max-w-full gap-2 rounded-full px-6 py-2.5 leading-snug whitespace-normal text-balance {if $_preview}pointer-events-none{elseif !$user->_logged_in}js_login{/if}" {if $_preview}tabindex="-1" aria-disabled="true"{elseif $user->_logged_in}data-url="#payment" data-options='{ "handle": "paid_post", "paid_post": "true", "id": {$post_id}, "price": {$_pay_price}, "vat": "{get_payment_vat_value($_pay_price)}", "fees": "{get_payment_fees_value($_pay_price)}", "total": "{get_payment_total_value($_pay_price)}", "total_printed": "{get_payment_total_value($_pay_price, true)}" }'{/if}>
    <span class="icon-[tabler--lock-open] size-5 shrink-0" aria-hidden="true"></span>
    <span>{__("Unlock for")} <span class="font-semibold">{print_money($_pay_price)}</span>{if $discounted_price} <span class="ms-1 font-normal line-through opacity-70">{print_money($price)}</span>{/if}</span>
  </button>
{/capture}
{include file='__locked_content.tpl' _icon="icon-[tabler--lock]" _title=__("Paid post") _meta=$smarty.capture.locked_meta _text=$paid_text _image=$paid_image _cta=$smarty.capture.locked_cta _framed=$_framed _compact=$_compact _preview=$_preview}
<!-- need payment -->
