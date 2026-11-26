{if $system['language']['dir'] == "RTL"}
  {assign var="invoice_dir" value="rtl"}
  {assign var="invoice_end" value="left"}
{else}
  {assign var="invoice_dir" value="ltr"}
  {assign var="invoice_end" value="right"}
{/if}
<div id="invoice-wrapper-{$order['order_id']}" style="display: none;">
  <div id="invoice-{$order['order_hash']}" dir="{$invoice_dir}" style="width: 100%; background: #ffffff; color: #1a1d2e; font-family: Arial, Helvetica, sans-serif; font-size: 13px; line-height: 1.45;">

    <div style="margin: 0 0 18px; text-align: center; font-size: 22px; font-weight: 700;">{$system['system_title']}</div>

    <table style="width: 100%; border-collapse: collapse; margin: 0 0 18px;">
      <tr>
        <td style="width: 50%; padding: 0 12px 10px 0; border-bottom: 2px solid #1a1d2e; vertical-align: bottom; font-size: 20px; font-weight: 700;">{__("Invoice")}</td>
        <td style="width: 50%; padding: 0 0 10px 12px; border-bottom: 2px solid #1a1d2e; vertical-align: bottom; text-align: {$invoice_end}; font-size: 13px; font-weight: 700;">{__("Order")} #{$order['order_hash']}</td>
      </tr>
    </table>

    <table style="width: 100%; border-collapse: collapse; margin: 0 0 22px;">
      <tr>
        <td style="width: 50%; padding: 0 18px 0 0; vertical-align: top;">
          <div style="margin: 0 0 4px; font-size: 11px; font-weight: 700; color: #5c6178;">{__("Seller")}</div>
          <div style="font-weight: 700;">{$order['seller_fullname']}</div>
          <div style="margin: 14px 0 4px; font-size: 11px; font-weight: 700; color: #5c6178;">{__("Order Date")}</div>
          <div>{$order['insert_time']}</div>
        </td>
        <td style="width: 50%; padding: 0 0 0 18px; vertical-align: top; text-align: {$invoice_end};">
          <div style="margin: 0 0 4px; font-size: 11px; font-weight: 700; color: #5c6178;">{__("Billed & Shipped To")}</div>
          <div style="font-weight: 700;">{$order['buyer_fullname']}</div>
          {if $order['address_details']}<div>{$order['address_details']}</div>{/if}
          {if $order['address_city']}<div>{$order['address_city']}</div>{/if}
          {if $order['address_country']}<div>{$order['address_country']}</div>{/if}
          {if $order['address_zip_code']}<div>{$order['address_zip_code']}</div>{/if}
          {if $order['address_phone']}<div>{$order['address_phone']}</div>{/if}
        </td>
      </tr>
    </table>

    <div style="margin: 0 0 8px; font-size: 15px; font-weight: 700;">{__("Order summary")}</div>

    <table style="width: 100%; border-collapse: collapse;">
      <thead>
        <tr>
          <td style="width: 46%; padding: 8px 10px; background: #f4f5f8; border-bottom: 1px solid #d9dce6; font-size: 11px; font-weight: 700; color: #5c6178;">{__("Item")}</td>
          <td style="width: 18%; padding: 8px 10px; background: #f4f5f8; border-bottom: 1px solid #d9dce6; text-align: {$invoice_end}; font-size: 11px; font-weight: 700; color: #5c6178;">{__("Price")}</td>
          <td style="width: 16%; padding: 8px 10px; background: #f4f5f8; border-bottom: 1px solid #d9dce6; text-align: center; font-size: 11px; font-weight: 700; color: #5c6178;">{__("Quantity")}</td>
          <td style="width: 20%; padding: 8px 10px; background: #f4f5f8; border-bottom: 1px solid #d9dce6; text-align: {$invoice_end}; font-size: 11px; font-weight: 700; color: #5c6178;">{__("Totals")}</td>
        </tr>
      </thead>
      <tbody>
        {foreach $order['items'] as $order_item}
          <tr>
            <td style="padding: 10px; border-bottom: 1px solid #e6e8ef; vertical-align: top;">{$order_item['post']['product']['name']}</td>
            <td style="padding: 10px; border-bottom: 1px solid #e6e8ef; text-align: {$invoice_end}; vertical-align: top; white-space: nowrap;">{print_money($order_item['price'])}</td>
            <td style="padding: 10px; border-bottom: 1px solid #e6e8ef; text-align: center; vertical-align: top;">{$order_item['quantity']}</td>
            <td style="padding: 10px; border-bottom: 1px solid #e6e8ef; text-align: {$invoice_end}; vertical-align: top; font-weight: 700; white-space: nowrap;">{print_money($order_item['price'] * $order_item['quantity'])}</td>
          </tr>
        {/foreach}
      </tbody>
    </table>

    <table style="width: 100%; border-collapse: collapse; margin-top: 12px;">
      <tr>
        <td style="width: 58%;"></td>
        <td style="width: 42%; padding: 0; vertical-align: top;">
          <table style="width: 100%; border-collapse: collapse;">
            {if $order['seller_id'] == $user->_data['user_id'] && $order['total_commission'] > 0}
              <tr>
                <td style="padding: 6px 10px; text-align: {$invoice_end}; color: #5c6178;">{__("Subtotal")}</td>
                <td style="padding: 6px 10px; text-align: {$invoice_end}; font-weight: 700; white-space: nowrap;">{print_money($order['sub_total'])}</td>
              </tr>
              <tr>
                <td style="padding: 6px 10px; text-align: {$invoice_end}; color: #5c6178;">{__("Commission")}</td>
                <td style="padding: 6px 10px; text-align: {$invoice_end}; font-weight: 700; white-space: nowrap;">- {print_money($order['total_commission'])}</td>
              </tr>
            {/if}
            <tr>
              <td style="padding: 10px; border-top: 2px solid #1a1d2e; text-align: {$invoice_end}; font-weight: 700;">{__("Total")}</td>
              <td style="padding: 10px; border-top: 2px solid #1a1d2e; text-align: {$invoice_end}; font-size: 16px; font-weight: 700; white-space: nowrap;">{if $order['seller_id'] == $user->_data['user_id']}{print_money($order['final_price'])}{else}{print_money($order['sub_total'])}{/if}</td>
            </tr>
          </table>
        </td>
      </tr>
    </table>

  </div>
</div>
