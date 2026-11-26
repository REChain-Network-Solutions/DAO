{if !empty($_editor)}
  <div class="admin-affiliate-levels grid gap-3">
    {for $level=1 to 10}
      {if $level == 1}
        {assign var="affiliate_price_field" value="affiliates_per_user"}
        {assign var="affiliate_percentage_field" value="affiliates_percentage"}
      {else}
        {assign var="affiliate_price_field" value="affiliates_per_user_{$level}"}
        {assign var="affiliate_percentage_field" value="affiliates_percentage_{$level}"}
      {/if}
      <fieldset class="admin-affiliate-level min-w-0{if $level > 1 && $system['affiliates_levels'] < $level} hidden{/if}" {if $level > 1}id="affiliates-levels-{$level}"{/if}>
        <legend>{__("level")} {$level}</legend>
        <div class="admin-affiliate-level-grid grid gap-4 md:grid-cols-2">
          <div class="admin-setting-field flex min-w-0 flex-col gap-2">
            <label class="label-text" for="{$affiliate_price_field}">{__("Price/Referred")}</label>
            <div class="join w-full min-w-0">
              <span class="join-item flex min-w-10 shrink-0 items-center justify-center border border-e-0 border-base-300 bg-base-200 min-w-11 px-3 text-xs font-semibold text-base-content [[data-theme=admin-dark]_&]:border-base-content/30">{$system['system_currency']}</span>
              <input type="text" class="input join-item min-w-0 flex-1" name="{$affiliate_price_field}" id="{$affiliate_price_field}" value="{$_affiliate[$affiliate_price_field]}">
            </div>
            <div class="admin-setting-help text-sm leading-relaxed">{__("The fixed price for each new referred user")}</div>
          </div>
          <div class="admin-setting-field flex min-w-0 flex-col gap-2">
            <label class="label-text" for="{$affiliate_percentage_field}">{__("Percentage")}</label>
            <div class="join w-full min-w-0">
              <span class="join-item flex min-w-10 shrink-0 items-center justify-center border border-e-0 border-base-300 bg-base-200 min-w-11 px-3 text-xs font-semibold text-base-content [[data-theme=admin-dark]_&]:border-base-content/30">%</span>
              <input type="text" class="input join-item min-w-0 flex-1" name="{$affiliate_percentage_field}" id="{$affiliate_percentage_field}" value="{$_affiliate[$affiliate_percentage_field]}">
            </div>
            <div class="admin-setting-help text-sm leading-relaxed">{__("The percentage from price for each new referred user")}</div>
          </div>
        </div>
      </fieldset>
    {/for}
  </div>
{else}
<div class="heading-small mb20">
  {__("level 1")}
</div>
<div class="pl-md-4">
  <div class="row form-group">
    <label class="col-md-3 form-label">
      {__("Price/Referred")} ({$system['system_currency']})
    </label>
    <div class="col-md-9">
      <input type="text" class="form-control" name="affiliates_per_user" value="{$_affiliate['affiliates_per_user']}">
      <div class="form-text">
        {__("The fixed price for each new referred user")} ({__("level 1")})
      </div>
    </div>
  </div>

  <div class="row form-group">
    <label class="col-md-3 form-label">
      {__("Percentage")} (%)
    </label>
    <div class="col-md-9">
      <input type="text" class="form-control" name="affiliates_percentage" value="{$_affiliate['affiliates_percentage']}">
      <div class="form-text">
        {__("The percentage from price for each new referred user")} ({__("level 1")})
      </div>
    </div>
  </div>
</div>

<div class="{if $system['affiliates_levels'] < 2}hidden{/if}" id="affiliates-levels-2">
  <div class="divider dashed"></div>

  <div class="heading-small mb20">
    {__("level 2")}
  </div>
  <div class="pl-md-4">
    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Price/Referred")} ({$system['system_currency']})
      </label>
      <div class="col-md-9">
        <input type="text" class="form-control" name="affiliates_per_user_2" value="{$_affiliate['affiliates_per_user_2']}">
        <div class="form-text">
          {__("The fixed price for each new referred user")} ({__("level 2")})
        </div>
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Percentage")} (%)
      </label>
      <div class="col-md-9">
        <input type="text" class="form-control" name="affiliates_percentage_2" value="{$_affiliate['affiliates_percentage_2']}">
        <div class="form-text">
          {__("The percentage from price for each new referred user")} ({__("level 2")})
        </div>
      </div>
    </div>
  </div>
</div>

<div class="{if $system['affiliates_levels'] < 3}hidden{/if}" id="affiliates-levels-3">
  <div class="divider dashed"></div>

  <div class="heading-small mb20">
    {__("level 3")}
  </div>
  <div class="pl-md-4">
    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Price/Referred")} ({$system['system_currency']})
      </label>
      <div class="col-md-9">
        <input type="text" class="form-control" name="affiliates_per_user_3" value="{$_affiliate['affiliates_per_user_3']}">
        <div class="form-text">
          {__("The fixed price for each new referred user")} ({__("level 3")})
        </div>
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Percentage")} (%)
      </label>
      <div class="col-md-9">
        <input type="text" class="form-control" name="affiliates_percentage_3" value="{$_affiliate['affiliates_percentage_3']}">
        <div class="form-text">
          {__("The percentage from price for each new referred user")} ({__("level 3")})
        </div>
      </div>
    </div>
  </div>
</div>

<div class="{if $system['affiliates_levels'] < 4}hidden{/if}" id="affiliates-levels-4">
  <div class="divider dashed"></div>

  <div class="heading-small mb20">
    {__("level 4")}
  </div>
  <div class="pl-md-4">
    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Price/Referred")} ({$system['system_currency']})
      </label>
      <div class="col-md-9">
        <input type="text" class="form-control" name="affiliates_per_user_4" value="{$_affiliate['affiliates_per_user_4']}">
        <div class="form-text">
          {__("The fixed price for each new referred user")} ({__("level 4")})
        </div>
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Percentage")} (%)
      </label>
      <div class="col-md-9">
        <input type="text" class="form-control" name="affiliates_percentage_4" value="{$_affiliate['affiliates_percentage_4']}">
        <div class="form-text">
          {__("The percentage from price for each new referred user")} ({__("level 4")})
        </div>
      </div>
    </div>
  </div>
</div>

<div class="{if $system['affiliates_levels'] < 5}hidden{/if}" id="affiliates-levels-5">
  <div class="divider dashed"></div>

  <div class="heading-small mb20">
    {__("level 5")}
  </div>
  <div class="pl-md-4">
    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Price/Referred")} ({$system['system_currency']})
      </label>
      <div class="col-md-9">
        <input type="text" class="form-control" name="affiliates_per_user_5" value="{$_affiliate['affiliates_per_user_5']}">
        <div class="form-text">
          {__("The fixed price for each new referred user")} ({__("level 5")})
        </div>
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Percentage")} (%)
      </label>
      <div class="col-md-9">
        <input type="text" class="form-control" name="affiliates_percentage_5" value="{$_affiliate['affiliates_percentage_5']}">
        <div class="form-text">
          {__("The percentage from price for each new referred user")} ({__("level 5")})
        </div>
      </div>
    </div>
  </div>
</div>

<div class="{if $system['affiliates_levels'] < 6}hidden{/if}" id="affiliates-levels-6">
  <div class="divider dashed"></div>

  <div class="heading-small mb20">
    {__("level 6")}
  </div>
  <div class="pl-md-4">
    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Price/Referred")} ({$system['system_currency']})
      </label>
      <div class="col-md-9">
        <input type="text" class="form-control" name="affiliates_per_user_6" value="{$_affiliate['affiliates_per_user_6']}">
        <div class="form-text">
          {__("The fixed price for each new referred user")} ({__("level 6")})
        </div>
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Percentage")} (%)
      </label>
      <div class="col-md-9">
        <input type="text" class="form-control" name="affiliates_percentage_6" value="{$_affiliate['affiliates_percentage_6']}">
        <div class="form-text">
          {__("The percentage from price for each new referred user")} ({__("level 6")})
        </div>
      </div>
    </div>
  </div>
</div>

<div class="{if $system['affiliates_levels'] < 7}hidden{/if}" id="affiliates-levels-7">
  <div class="divider dashed"></div>

  <div class="heading-small mb20">
    {__("level 7")}
  </div>
  <div class="pl-md-4">
    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Price/Referred")} ({$system['system_currency']})
      </label>
      <div class="col-md-9">
        <input type="text" class="form-control" name="affiliates_per_user_7" value="{$_affiliate['affiliates_per_user_7']}">
        <div class="form-text">
          {__("The fixed price for each new referred user")} ({__("level 7")})
        </div>
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Percentage")} (%)
      </label>
      <div class="col-md-9">
        <input type="text" class="form-control" name="affiliates_percentage_7" value="{$_affiliate['affiliates_percentage_7']}">
        <div class="form-text">
          {__("The percentage from price for each new referred user")} ({__("level 7")})
        </div>
      </div>
    </div>
  </div>
</div>

<div class="{if $system['affiliates_levels'] < 8}hidden{/if}" id="affiliates-levels-8">
  <div class="divider dashed"></div>

  <div class="heading-small mb20">
    {__("level 8")}
  </div>
  <div class="pl-md-4">
    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Price/Referred")} ({$system['system_currency']})
      </label>
      <div class="col-md-9">
        <input type="text" class="form-control" name="affiliates_per_user_8" value="{$_affiliate['affiliates_per_user_8']}">
        <div class="form-text">
          {__("The fixed price for each new referred user")} ({__("level 8")})
        </div>
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Percentage")} (%)
      </label>
      <div class="col-md-9">
        <input type="text" class="form-control" name="affiliates_percentage_8" value="{$_affiliate['affiliates_percentage_8']}">
        <div class="form-text">
          {__("The percentage from price for each new referred user")} ({__("level 8")})
        </div>
      </div>
    </div>
  </div>
</div>

<div class="{if $system['affiliates_levels'] < 9}hidden{/if}" id="affiliates-levels-9">
  <div class="divider dashed"></div>

  <div class="heading-small mb20">
    {__("level 9")}
  </div>
  <div class="pl-md-4">
    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Price/Referred")} ({$system['system_currency']})
      </label>
      <div class="col-md-9">
        <input type="text" class="form-control" name="affiliates_per_user_9" value="{$_affiliate['affiliates_per_user_9']}">
        <div class="form-text">
          {__("The fixed price for each new referred user")} ({__("level 9")})
        </div>
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Percentage")} (%)
      </label>
      <div class="col-md-9">
        <input type="text" class="form-control" name="affiliates_percentage_9" value="{$_affiliate['affiliates_percentage_9']}">
        <div class="form-text">
          {__("The percentage from price for each new referred user")} ({__("level 9")})
        </div>
      </div>
    </div>
  </div>
</div>

<div class="{if $system['affiliates_levels'] < 10}hidden{/if}" id="affiliates-levels-10">
  <div class="divider dashed"></div>

  <div class="heading-small mb20">
    {__("level 10")}
  </div>
  <div class="pl-md-4">
    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Price/Referred")} ({$system['system_currency']})
      </label>
      <div class="col-md-9">
        <input type="text" class="form-control" name="affiliates_per_user_10" value="{$_affiliate['affiliates_per_user_10']}">
        <div class="form-text">
          {__("The fixed price for each new referred user")} ({__("level 10")})
        </div>
      </div>
    </div>

    <div class="row form-group">
      <label class="col-md-3 form-label">
        {__("Percentage")} (%)
      </label>
      <div class="col-md-9">
        <input type="text" class="form-control" name="affiliates_percentage_10" value="{$_affiliate['affiliates_percentage_10']}">
        <div class="form-text">
          {__("The percentage from price for each new referred user")} ({__("level 10")})
        </div>
      </div>
    </div>
  </div>
</div>
{/if}
