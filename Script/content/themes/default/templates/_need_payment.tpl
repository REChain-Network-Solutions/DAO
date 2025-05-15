<!-- need payment -->
<div class="ptb20 plr20" {if $paid_image} style="background-image: url('{$system['system_uploads']}/{$paid_image}'); background-size: cover; background-position: center; min-height: 500px; position: relative;" {/if}>
  <div class="text-center text-muted" {if $paid_image} style="background: rgba(0, 0, 0, 0.5); padding: 20px; border-radius: 10px; position: absolute; bottom: 20px; left: 50%; transform: translateX(-50%); width: 90%;" {/if}>
    {include file='__svg_icons.tpl' icon="locked" class="main-icon mb20" width="56px" height="56px"}
    <div class="text-md">
      <span style="padding: 8px 20px; background: #ececec; border-radius: 18px; font-weight: bold; font-size: 13px;">
        {__("PAID POST")}
      </span>
    </div>
    <div class="d-grid">
      <button class="btn btn-info rounded rounded-pill mt20 {if !$user->_logged_in}js_login{/if}" {if $user->_logged_in}data-toggle="modal" data-url="#payment" data-options='{ "handle": "paid_post", "paid_post": "true", "id": {$post_id}, "price": {$price}, "vat": "{get_payment_vat_value($price)}", "fees": "{get_payment_fees_value($price)}", "total": "{get_payment_total_value($price)}", "total_printed": "{get_payment_total_value($price, true)}" }' {/if}>
        <i class="fa fa-money-check-alt mr5"></i>{__("PAY TO UNLOCK")} ({print_money($price|number_format:2)})
      </button>
      {if $paid_text}
        <div class="post-paid-description rounded" {if $paid_image} style="background: transparent; color: #fff;" {/if}>
          {$paid_text}
        </div>
      {/if}
    </div>
  </div>
</div>
<!-- need payment -->