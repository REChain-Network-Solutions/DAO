{if $ads_campaigns}
  <!-- ads campaigns -->
  {foreach $ads_campaigns as $campaign}
    {assign var="campaign_is_post" value=($campaign['ads_type'] == "post")}
    <div class="{if !$campaign_is_post}card overflow-hidden rounded-3xl corner-squircle supports-[corner-shape:squircle]:rounded-[2.5rem] bg-[#F9F9F9] dark:bg-base-300 shadow-none text-sm{/if}">
      <div class="flex items-center{if $campaign_is_post} gap-2 pb-3 text-sm font-semibold{else} gap-3 px-5 py-3.5{/if}">
        {if $campaign_is_post}
          <span class="icon-[tabler--speakerphone] size-4 shrink-0 text-warning" aria-hidden="true"></span>
          {__("Sponsored")}
        {else}
          {$_ads_module_icon = ''}
          {if $system['system_theme_icons'] == 'svg'}
            {$_ads_module_icon = 'ads'|theme_module_icon:'size-8 shrink-0'}
          {/if}
          {if $_ads_module_icon}
            {$_ads_module_icon}
          {else}
            <span class="icon-[tabler--speakerphone] size-8 shrink-0 text-base-content/60" aria-hidden="true"></span>
          {/if}
          <h2 class="min-w-0 grow truncate text-sm font-semibold" title="{__("Sponsored")}">{__("Sponsored")}</h2>
        {/if}
        {if $user->_logged_in && $user->_data['user_id'] != $campaign['campaign_user_id']}
          {if $campaign_is_post}
            <span class="js_modal cursor-pointer ms-auto shrink-0" data-url="data/report.php?do=create&handle=ads_campaign&id={$campaign['campaign_id']}" title='{__("Report")}'>
              {include file='__svg_icons.tpl' icon="report" class="main-icon" width="20px" height="20px"}
            </span>
          {else}
            <button type="button" class="js_modal heroui button button--tertiary button--sm button--icon-only size-6 ms-auto shrink-0 rounded-lg corner-squircle supports-[corner-shape:squircle]:rounded-[0.75rem] border-transparent bg-black/5 text-base-content shadow-none hover:bg-black/10 dark:bg-white/10 dark:hover:bg-white/15" data-url="data/report.php?do=create&handle=ads_campaign&id={$campaign['campaign_id']}" aria-label='{__("Report")}' title='{__("Report")}'>
              <span class="icon-[tabler--flag] size-4" aria-hidden="true"></span>
            </button>
          {/if}
        {/if}
      </div>
      {if $campaign_is_post}
        <div class="{if $campaign['campaign_bidding'] == 'click'}js_ads-click-campaign{/if}" data-id="{$campaign['campaign_id']}">
          {include file='__feeds_post.tpl' post=$campaign['ads_post'] standalone=true}
        </div>
      {else}
        <div class="card-body rounded-t-3xl corner-squircle supports-[corner-shape:squircle]:rounded-t-[2.5rem] bg-base-100 p-3">
          <div class="{if $campaign['campaign_bidding'] == 'click'}js_ads-click-campaign {/if}flex flex-col rounded-[1.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[2.25rem] bg-[#F9F9F9] dark:bg-base-200 p-2" data-id="{$campaign['campaign_id']}">
            <a class="block overflow-hidden rounded-[1.375rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1.875rem] bg-base-200" href="{$campaign['ads_url']}" target="_blank" rel="noopener">
              {if $campaign['ads_image']}
                <img class="w-full object-cover" src="{$system['system_uploads']}/{$campaign['ads_image']}" alt="{$campaign['ads_title']}" loading="lazy">
              {else}
                <video class="block w-full" src="{$system['system_uploads']}/{$campaign['ads_video']}" autoplay muted loop playsinline></video>
              {/if}
            </a>
            <div class="flex flex-col px-3 pb-2 pt-4">
              {if $campaign['ads_title']}
                <a class="line-clamp-2 text-base font-semibold leading-snug text-base-content! hover:text-primary!" href="{$campaign['ads_url']}" target="_blank" rel="noopener" title="{$campaign['ads_title']}">{$campaign['ads_title']}</a>
              {/if}
              {if $campaign['ads_description']}
                <p class="mt-1.5 line-clamp-2 text-sm text-base-content/65" title="{$campaign['ads_description']}">{$campaign['ads_description']|truncate:200}</p>
              {/if}
              <a class="heroui button button--tertiary text-base-content button--sm mt-4 w-full rounded-[0.75rem] corner-squircle supports-[corner-shape:squircle]:rounded-[1rem]" href="{$campaign['ads_url']}" target="_blank" rel="noopener">
                {__("Learn More")}<span class="icon-[tabler--arrow-up-right] size-4 rtl:-scale-x-100" aria-hidden="true"></span>
              </a>
            </div>
          </div>
        </div>
      {/if}
    </div>
  {/foreach}
  <!-- ads campaigns -->
{/if}
