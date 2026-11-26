<li class="flex items-center gap-3 px-5 py-3.5 sm:px-6">
  {if $transaction['node_type'] == "user" || $transaction['node_type'] == "tip"}
    <img class="size-10 shrink-0 rounded-full object-cover" src="{$transaction['user_picture']}" alt="" loading="lazy">
  {else}
    <div class="inline-flex size-10 shrink-0 items-center justify-center rounded-full {if $transaction['type'] == "out"}bg-error/10 text-error{else}bg-success/10 text-success{/if}">
      {if $transaction['node_type'] == "recharge"}
        <span class="icon-[tabler--plus] size-5" aria-hidden="true"></span>
      {elseif $transaction['node_type'] == "withdraw_wallet"}
        <span class="icon-[tabler--arrow-down] size-5" aria-hidden="true"></span>
      {elseif $transaction['node_type'] == "withdraw_affiliates"}
        <span class="icon-[tabler--users] size-5" aria-hidden="true"></span>
      {elseif $transaction['node_type'] == "withdraw_points"}
        <span class="icon-[tabler--coin] size-5" aria-hidden="true"></span>
      {elseif $transaction['node_type'] == "withdraw_market"}
        <span class="icon-[tabler--shopping-bag] size-5" aria-hidden="true"></span>
      {elseif $transaction['node_type'] == "withdraw_funding"}
        <span class="icon-[tabler--heart-handshake] size-5" aria-hidden="true"></span>
      {elseif $transaction['node_type'] == "withdraw_monetization"}
        <span class="icon-[tabler--currency-dollar] size-5" aria-hidden="true"></span>
      {elseif $transaction['node_type'] == "package_payment"}
        <span class="icon-[tabler--crown] size-5" aria-hidden="true"></span>
      {elseif $transaction['node_type'] == "subscribe_profile" || $transaction['node_type'] == "subscribe_user" || $transaction['node_type'] == "subscribe_page" || $transaction['node_type'] == "subscribe_group"}
        <span class="icon-[tabler--star] size-5" aria-hidden="true"></span>
      {elseif $transaction['node_type'] == "paid_post"}
        <span class="icon-[tabler--file-text] size-5" aria-hidden="true"></span>
      {elseif $transaction['node_type'] == "donate"}
        <span class="icon-[tabler--heart] size-5" aria-hidden="true"></span>
      {elseif $transaction['node_type'] == "market" || $transaction['node_type'] == "market_payment"}
        <span class="icon-[tabler--shopping-cart] size-5" aria-hidden="true"></span>
      {elseif $transaction['node_type'] == "paid_chat_message"}
        <span class="icon-[tabler--message] size-5" aria-hidden="true"></span>
      {elseif $transaction['node_type'] == "paid_call"}
        <span class="icon-[tabler--phone] size-5" aria-hidden="true"></span>
      {elseif $transaction['node_type'] == "blogs_module_payment"}
        <span class="icon-[tabler--news] size-5" aria-hidden="true"></span>
      {elseif $transaction['node_type'] == "products_module_payment"}
        <span class="icon-[tabler--package] size-5" aria-hidden="true"></span>
      {elseif $transaction['node_type'] == "funding_module_payment"}
        <span class="icon-[tabler--heart-handshake] size-5" aria-hidden="true"></span>
      {elseif $transaction['node_type'] == "offers_module_payment"}
        <span class="icon-[tabler--tag] size-5" aria-hidden="true"></span>
      {elseif $transaction['node_type'] == "jobs_module_payment"}
        <span class="icon-[tabler--briefcase] size-5" aria-hidden="true"></span>
      {elseif $transaction['node_type'] == "courses_module_payment"}
        <span class="icon-[tabler--school] size-5" aria-hidden="true"></span>
      {elseif $transaction['node_type'] == "ai_credits_payment"}
        <span class="icon-[tabler--sparkles] size-5" aria-hidden="true"></span>
      {elseif $transaction['node_type'] == "dating_super_likes" || $transaction['node_type'] == "dating_boost" || $transaction['node_type'] == "dating_priority_message"}
        <span class="icon-[tabler--heart] size-5" aria-hidden="true"></span>
      {else}
        <span class="icon-[tabler--wallet] size-5" aria-hidden="true"></span>
      {/if}
    </div>
  {/if}

  <div class="min-w-0 grow">
    <p class="truncate font-medium" title="{if $transaction['node_type'] == "user" || $transaction['node_type'] == "tip"} {if $system['show_usernames_enabled']} {$transaction['user_name']} {else} {$transaction['user_firstname']} {$transaction['user_lastname']} {/if} {elseif $transaction['node_type'] == "recharge"} {__("Add Funds")} {elseif $transaction['node_type'] == "withdraw_wallet"} {__("Wallet Withdrawal")} {elseif $transaction['node_type'] == "withdraw_affiliates"} {__("Affiliates Credit")} {elseif $transaction['node_type'] == "withdraw_points"} {__("Points Credit")} {elseif $transaction['node_type'] == "withdraw_market"} {__("Market Credit")} {elseif $transaction['node_type'] == "withdraw_funding"} {__("Funding Credit")} {elseif $transaction['node_type'] == "withdraw_monetization"} {__("Monetization Credit")} {elseif $transaction['node_type'] == "package_payment"} {__("Buy Pro Package")} {elseif $transaction['node_type'] == "subscribe_profile" || $transaction['node_type'] == "subscribe_user"} {__("Subscribe to Profile")} {elseif $transaction['node_type'] == "subscribe_page"} {__("Subscribe to Page")} {elseif $transaction['node_type'] == "subscribe_group"} {__("Subscribe to Group")} {elseif $transaction['node_type'] == "paid_post"} {__("Paid Post")} {elseif $transaction['node_type'] == "donate"} {__("Donate")} {elseif $transaction['node_type'] == "market" || $transaction['node_type'] == "market_payment"} {__("Market Purchase")} {elseif $transaction['node_type'] == "paid_chat_message"} {__("Paid Chat Message")} {elseif $transaction['node_type'] == "paid_call"} {__("Paid Call")} {elseif $transaction['node_type'] == "blogs_module_payment"} {__("Paid Blogs")} {elseif $transaction['node_type'] == "products_module_payment"} {__("Paid Products")} {elseif $transaction['node_type'] == "funding_module_payment"} {__("Paid Funding")} {elseif $transaction['node_type'] == "offers_module_payment"} {__("Paid Offers")} {elseif $transaction['node_type'] == "jobs_module_payment"} {__("Paid Jobs")} {elseif $transaction['node_type'] == "courses_module_payment"} {__("Paid Courses")} {elseif $transaction['node_type'] == "ai_credits_payment"} {__("AI Credits Payment")} {elseif $transaction['node_type'] == "dating_super_likes"} {__("Dating Super Likes")} {elseif $transaction['node_type'] == "dating_boost"} {__("Dating Boost")} {elseif $transaction['node_type'] == "dating_priority_message"} {__("Dating Message With a Like")} {/if}">
      {if $transaction['node_type'] == "user" || $transaction['node_type'] == "tip"}
        <a class="text-base-content! hover:text-primary!" target="_blank" href="{$system['system_url']}/{$transaction['user_name']}">
          {if $system['show_usernames_enabled']}
            {$transaction['user_name']}
          {else}
            {$transaction['user_firstname']} {$transaction['user_lastname']}
          {/if}
        </a>
      {elseif $transaction['node_type'] == "recharge"}
        {__("Add Funds")}
      {elseif $transaction['node_type'] == "withdraw_wallet"}
        {__("Wallet Withdrawal")}
      {elseif $transaction['node_type'] == "withdraw_affiliates"}
        {__("Affiliates Credit")}
      {elseif $transaction['node_type'] == "withdraw_points"}
        {__("Points Credit")}
      {elseif $transaction['node_type'] == "withdraw_market"}
        {__("Market Credit")}
      {elseif $transaction['node_type'] == "withdraw_funding"}
        {__("Funding Credit")}
      {elseif $transaction['node_type'] == "withdraw_monetization"}
        {__("Monetization Credit")}
      {elseif $transaction['node_type'] == "package_payment"}
        {__("Buy Pro Package")}
      {elseif $transaction['node_type'] == "subscribe_profile" || $transaction['node_type'] == "subscribe_user"}
        {__("Subscribe to Profile")}
      {elseif $transaction['node_type'] == "subscribe_page"}
        {__("Subscribe to Page")}
      {elseif $transaction['node_type'] == "subscribe_group"}
        {__("Subscribe to Group")}
      {elseif $transaction['node_type'] == "paid_post"}
        {__("Paid Post")}
      {elseif $transaction['node_type'] == "donate"}
        {__("Donate")}
      {elseif $transaction['node_type'] == "market" || $transaction['node_type'] == "market_payment"}
        {__("Market Purchase")}
      {elseif $transaction['node_type'] == "paid_chat_message"}
        {__("Paid Chat Message")}
      {elseif $transaction['node_type'] == "paid_call"}
        {__("Paid Call")}
      {elseif $transaction['node_type'] == "blogs_module_payment"}
        {__("Paid Blogs")}
      {elseif $transaction['node_type'] == "products_module_payment"}
        {__("Paid Products")}
      {elseif $transaction['node_type'] == "funding_module_payment"}
        {__("Paid Funding")}
      {elseif $transaction['node_type'] == "offers_module_payment"}
        {__("Paid Offers")}
      {elseif $transaction['node_type'] == "jobs_module_payment"}
        {__("Paid Jobs")}
      {elseif $transaction['node_type'] == "courses_module_payment"}
        {__("Paid Courses")}
      {elseif $transaction['node_type'] == "ai_credits_payment"}
        {__("AI Credits Payment")}
      {elseif $transaction['node_type'] == "dating_super_likes"}
        {__("Dating Super Likes")}
      {elseif $transaction['node_type'] == "dating_boost"}
        {__("Dating Boost")}
      {elseif $transaction['node_type'] == "dating_priority_message"}
        {__("Dating Message With a Like")}
      {/if}
    </p>
    <div class="mt-0.5 flex flex-wrap items-center gap-x-1.5 text-sm text-base-content/60">
      {if $transaction['type'] == "out"}
        <span>{__("To")}</span>
      {else}
        <span>{__("From")}</span>
      {/if}
      {if $transaction['node_type'] == "tip"}
        <span class="badge badge-soft badge-primary badge-sm rounded-full">{__("Tip")}</span>
      {/if}
      <span aria-hidden="true">·</span>
      <span class="js_moment" data-time="{$transaction['date']}">{$transaction['date']}</span>
    </div>
  </div>

  <div class="shrink-0 text-end">
    {if $transaction['amount']}
      <span class="whitespace-nowrap font-semibold {if $transaction['type'] == "out"}text-error{else}text-success{/if}">
        {if $transaction['type'] == "out"}−{else}+{/if}{print_money($transaction['amount'])}
      </span>
    {/if}
  </div>
</li>
