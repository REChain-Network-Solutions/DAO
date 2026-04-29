<div class="modal-header">
  <h6 class="modal-title">
    <i class="fa fa-share mr5"></i>{__("Share Coupon Code")}
  </h6>
  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
</div>
<div class="modal-body">
  <div class="text-center">
    <div class="text-xlg">
      {__("Your coupon code is")}
    </div>
    <div>
      <span class="badge bg-danger rounded-pill text-xlg">{$coupon['coupon_code']}</span>
      <button type="button" class="btn btn-light rounded-pill ptb15 plr15 js_clipboard" data-clipboard-text="{$coupon['coupon_code']}" data-bs-toggle="tooltip" title='{__("Copy")}'>
        <i class="fas fa-copy"></i>
      </button>
    </div>
  </div>

  <div class="divider"></div>

  <div class="post-social-share" style="border-bottom: none;">
    {include file='__social_share.tpl' _link=$coupon['sharing_text']}
  </div>
</div>