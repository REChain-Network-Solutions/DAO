{if $user->_logged_in}
  {if $package['price'] == 0}
    <button type="button" class="{$_class} js_try-package" data-id='{$package["package_id"]}'>
      {__("Try Now")}
    </button>
  {else}
    <button type="button" class="{$_class} js_modal" data-url="#payment" data-options='{ "handle": "packages", "id": {$package["package_id"]}, "price": "{$package["price"]}", "vat": "{get_payment_vat_value($package['price'])}", "fees": "{get_payment_fees_value($package['price'])}", "total": "{get_payment_total_value($package['price'])}", "total_printed": "{get_payment_total_value($package['price'], true)}", "name": "{$package["name"]}", "img": "{$package["icon"]}" }'>
      {if !$user->_data['user_subscribed']}{__("Buy Now")}{else}{__("Upgrade Now")}{/if}
    </button>
  {/if}
{else}
  <a class="{$_class}" href="{$system['system_url']}/signin">
    {__("Buy Now")}
  </a>
{/if}
