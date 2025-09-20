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

<div class="{if $system['affiliates_levels'] < 2}x-hidden{/if}" id="affiliates-levels-2">
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

<div class="{if $system['affiliates_levels'] < 3}x-hidden{/if}" id="affiliates-levels-3">
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

<div class="{if $system['affiliates_levels'] < 4}x-hidden{/if}" id="affiliates-levels-4">
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

<div class="{if $system['affiliates_levels'] < 5}x-hidden{/if}" id="affiliates-levels-5">
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