{include file='_head.tpl'}
{include file='_header.tpl'}

<!-- page content -->
<div class="{if $system['fluid_design']}container-fluid{else}container{/if} mt20 sg-offcanvas">
  <div class="row">

    <!-- left panel -->
    <div class="col-md-4 col-lg-3 sg-offcanvas-sidebar js_sticky-sidebar">
      {include file='_sidebar.tpl'}
    </div>
    <!-- left panel -->

    <!-- content panel -->
    <div class="col-md-8 col-lg-9 sg-offcanvas-mainbar">

      <!-- tabs -->
      <div class="content-tabs rounded-sm shadow-sm clearfix">
        <ul>
          <li {if $view == "" || $view == "find"}class="active" {/if}>
            <a href="{$system['system_url']}/people">{__("Find")}</a>
          </li>
          {if $system['friends_enabled']}
            <li {if $view == "friend_requests"}class="active" {/if}>
              <a href="{$system['system_url']}/people/friend_requests">
                {__("Friend Requests")}
                {if $user->_data['friend_requests']}
                  <span class="badge badge-lg bg-info ml5">{count($user->_data['friend_requests'])}</span>
                {/if}
              </a>
            </li>
            <li {if $view == "sent_requests"}class="active" {/if}>
              <a href="{$system['system_url']}/people/sent_requests">
                {__("Sent Requests")}
                {if $user->_data['friend_requests_sent_total']}
                  <span class="badge badge-lg bg-warning ml5">{$user->_data['friend_requests_sent_total']}</span>
                {/if}
              </a>
            </li>
          {/if}
        </ul>
      </div>
      <!-- tabs -->

      <!-- content -->
      <div class="row">
        <!-- left panel -->
        <div class="col-lg-8 order-2 order-lg-1">
          <div class="card">

            {if $view == ""}
              <div class="card-header bg-transparent">
                <strong>{__("People You May Know")}</strong>
              </div>
              <div class="card-body">
                {if $people}
                  <ul>
                    {foreach $people as $_user}
                      {include file='__feeds_user.tpl' _tpl="list" _connection="add"}
                    {/foreach}
                  </ul>

                  <!-- see-more -->
                  {if count($people) >= $system['min_results']}
                    <div class="alert alert-post see-more js_see-more" data-get="new_people">
                      <span>{__("See More")}</span>
                      <div class="loader loader_small x-hidden"></div>
                    </div>
                  {/if}
                  <!-- see-more -->
                {else}
                  <p class="text-center text-muted">
                    {__("No people available")}
                  </p>
                {/if}
              </div>

            {elseif $view == "find"}
              <div class="card-header bg-transparent">
                <strong>{__("Search Results")}</strong>
              </div>
              <div class="card-body">
                {if $people}
                  <ul>
                    {foreach $people as $_user}
                      {include file='__feeds_user.tpl' _tpl="list" _connection=$_user['connection']}
                    {/foreach}
                  </ul>
                {else}
                  <p class="text-center text-muted">
                    {__("No people available for your search")}
                  </p>
                {/if}
              </div>

            {elseif $view == "friend_requests"}
              <div class="card-header bg-transparent">
                <strong>{__("Respond to Your Friend Request")}</strong>
              </div>
              <div class="card-body">
                {if $user->_data['friend_requests']}
                  <ul>
                    {foreach $user->_data['friend_requests'] as $_user}
                      {include file='__feeds_user.tpl' _tpl="list" _connection="request"}
                    {/foreach}
                  </ul>
                {else}
                  <p class="text-center text-muted">
                    {__("No new requests")}
                  </p>
                {/if}

                <!-- see-more -->
                {if count($user->_data['friend_requests']) >= $system['max_results']}
                  <div class="alert alert-info see-more js_see-more" data-get="friend_requests">
                    <span>{__("See More")}</span>
                    <div class="loader loader_small x-hidden"></div>
                  </div>
                {/if}
                <!-- see-more -->
              </div>

            {elseif $view == "sent_requests"}
              <div class="card-header bg-transparent">
                <strong>{__("Friend Requests Sent")}</strong>
              </div>
              <div class="card-body">
                {if $user->_data['friend_requests_sent']}
                  <ul>
                    {foreach $user->_data['friend_requests_sent'] as $_user}
                      {include file='__feeds_user.tpl' _tpl="list" _connection="cancel"}
                    {/foreach}
                  </ul>
                {else}
                  <p class="text-center text-muted">
                    {__("No new requests")}
                  </p>
                {/if}

                <!-- see-more -->
                {if count($user->_data['friend_requests_sent']) >= $system['max_results']}
                  <div class="alert alert-info see-more js_see-more" data-get="friend_requests_sent">
                    <span>{__("See More")}</span>
                    <div class="loader loader_small x-hidden"></div>
                  </div>
                {/if}
                <!-- see-more -->
              </div>

            {/if}

          </div>
        </div>
        <!-- left panel -->

        <!-- right panel -->
        <div class="col-lg-4 order-1 order-lg-2">
          <!-- search panel -->
          <div class="card">
            <div class="card-header">
              <i class="fa fa-search mr10"></i>{__("Search")}
            </div>
            <div class="card-body">
              <form action="{$system['system_url']}/people/find" method="post">
                {if $system['location_finder_enabled']}
                  <div class="form-group">
                    <label class="form-label">{__("Distance")} {$distance_value}</label>
                    <div class="d-grid">
                      <input type="range" class="custom-range mb10" min="1" max="5000" name="distance_slider" value="{isset($distance_value)? $distance_value : 5000}" oninput="this.form.distance_value.value=this.value">
                      <div class="input-group">
                        <span class="input-group-text" id="basic-addon1">{if $system['system_distance'] == "mile"}{__("ML")}{else}{__("KM")}{/if}</span>
                        <input type="number" class="form-control" min="1" max="5000" name="distance_value" value="{isset($distance_value)? $distance_value : 5000}" oninput="this.form.distance_slider.value=this.value">
                      </div>
                    </div>
                  </div>
                {/if}
                <!-- query -->
                <div class="form-group">
                  <label class="form-label">{__("Query")}</label>
                  <input type="text" class="form-control" name="query" value="{$query}">
                </div>
                <!-- query -->
                {if $system['location_info_enabled']}
                  <!-- city -->
                  <div class="form-group">
                    <label class="form-label">{__("City")}</label>
                    <input type="text" class="form-control" name="city" value="{$city}">
                  </div>
                  <!-- city -->
                  <!-- country -->
                  <div class="form-group">
                    <label class="form-label">{__("Country")}</label>
                    <select class="form-select" name="country" id="country">
                      <option value="none">{__("Any")}</option>
                      {foreach $countries as $_country}
                        <option {if $country == $_country['country_id']}selected{/if} value="{$_country['country_id']}">{$_country['country_name']}</option>
                      {/foreach}
                    </select>
                  </div>
                  <!-- country -->
                {/if}
                <!-- gender -->
                <div class="form-group {if $system['genders_disabled']}x-hidden{/if}">
                  <label class="form-label">{__("Gender")}</label>
                  <select class="form-select" name="gender">
                    <option value="any">{__("Any")}</option>
                    {foreach $genders as $_gender}
                      <option {if $gender == $_gender['gender_id']}selected{/if} value="{$_gender['gender_id']}">{$_gender['gender_name']}</option>
                    {/foreach}
                  </select>
                </div>
                <!-- gender -->
                <!-- relationship -->
                {if $system['relationship_info_enabled']}
                  <div class="form-group">
                    <label class="form-label">{__("Relationship")}</label>
                    <select class="form-select" name="relationship">
                      <option {if $relationship == "any"}selected{/if} value="any">{__("Any")}</option>
                      <option {if $relationship == "single"}selected{/if} value="single">{__("Single")}</option>
                      <option {if $relationship == "relationship"}selected{/if} value="relationship">{__("In a relationship")}</option>
                      <option {if $relationship == "married"}selected{/if} value="married">{__("Married")}</option>
                      <option {if $relationship == "complicated"}selected{/if} value="complicated">{__("It's complicated")}</option>
                      <option {if $relationship == "separated"}selected{/if} value="separated">{__("Separated")}</option>
                      <option {if $relationship == "divorced"}selected{/if} value="divorced">{__("Divorced")}</option>
                      <option {if $relationship == "widowed"}selected{/if} value="widowed">{__("Widowed")}</option>
                    </select>
                  </div>
                {/if}
                <!-- relationship -->
                <!-- online status -->
                <div class="form-group">
                  <label class="form-label">{__("Online Status")}</label>
                  <select class="form-select" name="online_status">
                    <option {if $online_status == "any"}selected{/if} value="any">{__("Any")}</option>
                    <option {if $online_status == "online"}selected{/if} value="online">{__("Online")}</option>
                    <option {if $online_status == "offline"}selected{/if} value="offline">{__("Offline")}</option>
                  </select>
                </div>
                <!-- online status -->
                <!-- verified status -->
                <div class="form-group">
                  <label class="form-label">{__("Verified Status")}</label>
                  <select class="form-select" name="verified_status">
                    <option {if $verified_status == "any"}selected{/if} value="any">{__("Any")}</option>
                    <option {if $verified_status == "verified"}selected{/if} value="verified">{__("Verified")}</option>
                    <option {if $verified_status == "unverified"}selected{/if} value="unverified">{__("Not Verified")}</option>
                  </select>
                </div>
                <!-- verified status -->
                <!-- custom fields -->
                {if $custom_fields}
                  {include file='__custom_fields.tpl' _custom_fields=$custom_fields _registration=true _search=true}
                {/if}
                <!-- custom fields -->
                <div class="d-grid">
                  <button type="submit" class="btn btn-primary" name="submit">{__("Search")}</button>
                </div>
              </form>
            </div>
          </div>
          <!-- search panel -->

          {include file='_ads_campaigns.tpl'}
          {include file='_ads.tpl'}
          {include file='_widget.tpl'}
        </div>
        <!-- right panel -->


      </div>
      <!-- content -->

    </div>
    <!-- content panel -->

  </div>
</div>
<!-- page content -->

{include file='_footer.tpl'}