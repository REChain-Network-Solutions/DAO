{if $ads_campaigns}
  <!-- ads campaigns -->
  {foreach $ads_campaigns as $campaign}
    <div class="card {if $campaign['ads_type'] == "post"}bg-transparent{/if}">
      <div class="card-header bg-transparent {if $campaign['ads_type'] == "post"}plr0 pb0{/if}">
        <i class="fa fa-bullhorn fa-fw mr5 yellow"></i>{__("Sponsored")}
      </div>
      <div class="card-body {if $campaign['campaign_bidding'] == 'click'}js_ads-click-campaign{/if} {if $campaign['ads_type'] == "post"}plr0 pb0{/if}" data-id="{$campaign['campaign_id']}">
        {if $campaign['ads_type'] == "post"}
          {include file='__feeds_post.tpl' post=$campaign['ads_post'] standalone=true}
        {else}
          <a href="{$campaign['ads_url']}" target="_blank">
            <img class="img-fluid" src="{$system['system_uploads']}/{$campaign['ads_image']}">
          </a>
          {if $campaign['ads_title'] || $campaign['ads_description']}
            <div class="ptb5 plr10">
              <p class="ads-title">
                <a href="{$campaign['ads_url']}" target="_blank">{$campaign['ads_title']}</a>
              </p>
              <p class="ads-descrition">
                {$campaign['ads_description']|truncate:200}
              </p>
            </div>
          {/if}
        {/if}
      </div>
    </div>
  {/foreach}
  <!-- ads campaigns -->
{/if}