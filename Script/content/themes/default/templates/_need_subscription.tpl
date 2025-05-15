<!-- need subscription -->
<div class="ptb20 plr20" {if $subscriptions_image} style="background-image: url('{$system['system_uploads']}/{$subscriptions_image}'); background-size: cover; background-position: center; min-height: 500px; position: relative;" {/if}>
  <div class="text-center text-muted" {if $subscriptions_image} style="background: rgba(0, 0, 0, 0.5); padding: 20px; border-radius: 10px; position: absolute; bottom: 20px; left: 50%; transform: translateX(-50%); width: 90%;" {/if}>
    {include file='__svg_icons.tpl' icon="locked" class="main-icon mb20" width="56px" height="56px"}
    <div class="text-md">
      <span style="padding: 8px 20px; background: #ececec; border-radius: 18px; font-weight: bold; font-size: 13px;">
        {if isset($price)}
          {__("SUBSCRIBE TO SEE THIS")} {__($node_type|capitalize)|upper} {__("CONTENT")}
        {else}
          {__("SUBSCRIPTIONS CONTENT")}
        {/if}
      </span>
    </div>
    {if isset($price)}
      <div class="d-grid">
        <button class="btn btn-info rounded rounded-pill mt20" data-toggle="modal" data-url="monetization/controller.php?do=get_plans&node_id={$node_id}&node_type={$node_type}" data-size="large">
          <i class="fa fa-money-check-alt mr5"></i>{__("SUBSCRIBE")} {__("STARTING FROM")} ({print_money($price|number_format:2)})
        </button>
      </div>
    {/if}
  </div>
</div>
<!-- need subscription -->