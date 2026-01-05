<div class="panel panel-default">
    <div class="panel-heading with-icon">
        {if $sub_view == ""}
            <div class="pull-right flip">
                <a href="{$system['system_url']}/admincp/packages/add" class="btn btn-primary">
                    <i class="fa fa-plus"></i> {__("Add New Package")}
                </a>
            </div>
        {/if}
        <i class="fa fa-cubes pr5 panel-icon"></i>
        <strong>{__("Pro Packages")}</strong>
        {if $sub_view == "edit"} &rsaquo; <strong>{$data['name']}</strong>{/if}
        {if $sub_view == "add"} &rsaquo; <strong>{__("Add New")}</strong>{/if}
        {if $sub_view == "subscribers"} &rsaquo; <strong>{__("Subscribers")}</strong>{/if}
        {if $sub_view == "earnings"} &rsaquo; <strong>{__("Earnings")}</strong>{/if}
    </div>
    {if $sub_view == ""}
        <div class="panel-body">
            <div class="alert alert-info">
                <div class="icon">
                    <i class="fa fa-info-circle fa-2x"></i>
                </div>
                <div class="text pt5">
                    {__("Make sure you have configured")} <a href="{$system['system_url']}/admincp/settings/payments">{__("Payments Settings")}</a>
                </div>
            </div>
            <div class="table-responsive">
                <table class="table table-striped table-bordered table-hover js_dataTable">
                    <thead>
                        <tr>
                            <th>{__("ID")}</th>
                            <th>{__("Name")}</th>
                            <th>{__("Price")}</th>
                            <th>{__("Period")}</th>
                            <th>{__("Boost Posts")}</th>
                            <th>{__("Boost Pages")}</th>
                            <th>{__("Actions")}</th>
                        </tr>
                    </thead>
                    <tbody>
                        {foreach $rows as $row}
                            <tr>
                                <td>{$row['package_id']}</td>
                                <td>
                                    <a target="_blank" href="{$system['system_url']}/admincp/packages/edit/{$row['package_id']}">
                                        <img class="tbl-image" src="{$row['icon']}">
                                        {$row['name']}
                                    </a>
                                </td>
                                <td>{$system['system_currency_symbol']}{$row['price']}</td>
                                <td>
                                    {if $row['period'] == 'life'}
                                        {__("Life Time")}
                                    {else}
                                        {$row['period_num']} {$row['period']|ucfirst}
                                    {/if}
                                </td>
                                <td>{$row['boost_posts']}</td>
                                <td>{$row['boost_pages']}</td>
                                <td>
                                    <button data-toggle="tooltip" data-placement="top" title='{__("Delete")}' class="btn btn-xs btn-danger js_admin-deleter" data-handle="package" data-id="{$row['package_id']}">
                                        <i class="fa fa-trash-alt"></i>
                                    </button>
                                    <a data-toggle="tooltip" data-placement="top" title='{__("Edit")}' href="{$system['system_url']}/admincp/packages/edit/{$row['package_id']}" class="btn btn-xs btn-primary">
                                        <i class="fa fa-pencil-alt"></i>
                                    </a>
                                </td>
                            </tr>
                        {/foreach}
                    </tbody>
                </table>
            </div>
        </div>
    {elseif $sub_view == "edit"}
        <div class="panel-body">
            <form class="js_ajax-forms form-horizontal" data-url="admin/packages.php?do=edit&id={$data['package_id']}">
                <div class="form-group">
                    <label class="col-sm-3 control-label text-left">
                        {__("Name")}
                    </label>
                    <div class="col-sm-9">
                        <input class="form-control" name="name" value="{$data['name']}">
                    </div>
                </div>

                <div class="form-group">
                    <label class="col-sm-3 control-label text-left">
                        {__("Price")} ({$system['system_currency']})
                    </label>
                    <div class="col-sm-9">
                        <input class="form-control" name="price" value="{$data['price']}">
                    </div>
                </div>

                <div class="form-group">
                    <label class="col-sm-3 control-label text-left">
                        {__("Paid Every")}
                    </label>
                    <div class="col-sm-9">
                        <div class="row">
                            <div class="col-xs-4">
                                <input class="form-control" name="period_num" value="{$data['period_num']}">
                            </div>
                            <div class="col-xs-8">
                                <select class="form-control" name="period">
                                    <option {if $data['period'] == "day"}selected{/if} value="day">{__("Day")}</option>
                                    <option {if $data['period'] == "week"}selected{/if} value="week">{__("Week")}</option>
                                    <option {if $data['period'] == "month"}selected{/if} value="month">{__("Month")}</option>
                                    <option {if $data['period'] == "year"}selected{/if} value="year">{__("Year")}</option>
                                    <option {if $data['period'] == "life"}selected{/if} value="life">{__("Life Time")}</option>
                                </select>
                            </div>
                        </div>
                        <span class="help-block">
                            {__("For example every 15 days, 2 Months, 1 Year")}
                        </span>
                    </div>
                </div>

                <div class="form-group">
                    <label class="col-sm-3 control-label text-left">
                        {__("Color")}
                    </label>
                    <div class="col-sm-9">
                        <div class="input-group colorpicker-component js_colorpicker">
                            <input type="text" class="form-control" name="color" value="{$data['color']}" />
                            <span class="input-group-addon"><i></i></span>
                        </div>
                        <span class="help-block">
                            {__("The theme color for this package")}
                        </span>
                    </div>
                </div>

                <div class="form-group">
                    <label class="col-sm-3 control-label text-left">
                        {__("Icon")}
                    </label>
                    <div class="col-sm-9">
                        {if $data['icon'] == ''}
                            <div class="x-image">
                                <button type="button" class="close x-hidden js_x-image-remover" title='{__("Remove")}'>
                                    <span>×</span>
                                </button>
                                <div class="x-image-loader">
                                    <div class="progress x-progress">
                                        <div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
                                    </div>
                                </div>
                                <i class="fa fa-camera fa-lg js_x-uploader" data-handle="x-image"></i>
                                <input type="hidden" class="js_x-image-input" name="icon" value="">
                            </div>
                        {else}
                            <div class="x-image" style="background-image: url('{$system['system_uploads']}/{$data['icon']}')">
                                <button type="button" class="close js_x-image-remover" title='{__("Remove")}'>
                                    <span>×</span>
                                </button>
                                <div class="x-image-loader">
                                    <div class="progress x-progress">
                                        <div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
                                    </div>
                                </div>
                                <i class="fa fa-camera fa-lg js_x-uploader" data-handle="x-image"></i>
                                <input type="hidden" class="js_x-image-input" name="icon" value="{$data['icon']}">
                            </div>
                        {/if}
                        <span class="help-block">
                            {__("The perfect size for icon should be (wdith: 60px & height: 60px)")}
                        </span>
                    </div>
                </div>

                <div class="form-group">
                    <label class="col-sm-3 control-label text-left">
                        {__("Boost Posts Enabled")}
                    </label>
                    <div class="col-sm-9">
                        <label class="switch" for="boost_posts_enabled">
                            <input type="checkbox" name="boost_posts_enabled" id="boost_posts_enabled" {if $data['boost_posts_enabled']}checked{/if}>
                            <span class="slider round"></span>
                        </label>
                        <span class="help-block">
                            {__("Enable boost posts feature")}
                        </span>
                    </div>
                </div>

                <div class="form-group">
                    <label class="col-sm-3 control-label text-left">
                        {__("Posts Boosts")}
                    </label>
                    <div class="col-sm-9">
                        <input class="form-control" name="boost_posts" value="{$data['boost_posts']}">
                        <span class="help-block">
                            {__("Max posts boosts allowed")}
                        </span>
                    </div>
                </div>

                <div class="form-group">
                    <label class="col-sm-3 control-label text-left">
                        {__("Boost Pages Enabled")}
                    </label>
                    <div class="col-sm-9">
                        <label class="switch" for="boost_pages_enabled">
                            <input type="checkbox" name="boost_pages_enabled" id="boost_pages_enabled" {if $data['boost_pages_enabled']}checked{/if}>
                            <span class="slider round"></span>
                        </label>
                        <span class="help-block">
                            {__("Enable boost pages feature")}
                        </span>
                    </div>
                </div>

                <div class="form-group">
                    <label class="col-sm-3 control-label text-left">
                        {__("Pages Boosts")}
                    </label>
                    <div class="col-sm-9">
                        <input class="form-control" name="boost_pages" value="{$data['boost_pages']}">
                        <span class="help-block">
                            {__("Max pages boosts allowed")}
                        </span>
                    </div>
                </div>

                <div class="form-group">
                    <div class="col-sm-9 col-sm-offset-3">
                        <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
                    </div>
                </div>

                <!-- success -->
                <div class="alert alert-success mb0 mt10 x-hidden" role="alert"></div>
                <!-- success -->

                <!-- error -->
                <div class="alert alert-danger mb0 mt10 x-hidden" role="alert"></div>
                <!-- error -->
            </form>
        </div>
    {elseif $sub_view == "add"}
        <div class="panel-body">
            <form class="js_ajax-forms form-horizontal" data-url="admin/packages.php?do=add">
                <div class="form-group">
                    <label class="col-sm-3 control-label text-left">
                        {__("Name")}
                    </label>
                    <div class="col-sm-9">
                        <input class="form-control" name="name">
                    </div>
                </div>

                <div class="form-group">
                    <label class="col-sm-3 control-label text-left">
                        {__("Price")} ({$system['system_currency']})
                    </label>
                    <div class="col-sm-9">
                        <input class="form-control" name="price">
                    </div>
                </div>

                <div class="form-group">
                    <label class="col-sm-3 control-label text-left">
                        {__("Paid Every")}
                    </label>
                    <div class="col-sm-9">
                        <div class="row">
                            <div class="col-xs-4">
                                <input class="form-control" name="period_num">
                            </div>
                            <div class="col-xs-8">
                                <select class="form-control" name="period">
                                    <option value="day">{__("Day")}</option>
                                    <option value="week">{__("Week")}</option>
                                    <option value="month">{__("Month")}</option>
                                    <option value="year">{__("Year")}</option>
                                    <option value="life">{__("Life Time")}</option>
                                </select>
                            </div>
                        </div>
                        <span class="help-block">
                            {__("For example every 15 days, 2 Months, 1 Year")}
                        </span>
                    </div>
                </div>

                <div class="form-group">
                    <label class="col-sm-3 control-label text-left">
                        {__("Color")}
                    </label>
                    <div class="col-sm-9">
                        <div class="input-group colorpicker-component js_colorpicker">
                            <input type="text" class="form-control" name="color" />
                            <span class="input-group-addon"><i></i></span>
                        </div>
                        <span class="help-block">
                            {__("The theme color for this package")}
                        </span>
                    </div>
                </div>

                <div class="form-group">
                    <label class="col-sm-3 control-label text-left">
                        {__("Icon")}
                    </label>
                    <div class="col-sm-9">
                        <div class="x-image">
                            <button type="button" class="close x-hidden js_x-image-remover" title='{__("Remove")}'>
                                <span>×</span>
                            </button>
                            <div class="x-image-loader">
                                <div class="progress x-progress">
                                    <div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
                                </div>
                            </div>
                            <i class="fa fa-camera fa-lg js_x-uploader" data-handle="x-image"></i>
                            <input type="hidden" class="js_x-image-input" name="icon" value="">
                        </div>
                        <span class="help-block">
                            {__("The perfect size for icon should be (wdith: 60px & height: 60px)")}
                        </span>
                    </div>
                </div>

                <div class="form-group">
                    <label class="col-sm-3 control-label text-left">
                        {__("Boost Posts Enabled")}
                    </label>
                    <div class="col-sm-9">
                        <label class="switch" for="boost_posts_enabled">
                            <input type="checkbox" name="boost_posts_enabled" id="boost_posts_enabled">
                            <span class="slider round"></span>
                        </label>
                        <span class="help-block">
                            {__("Enable boost posts feature")}
                        </span>
                    </div>
                </div>

                <div class="form-group">
                    <label class="col-sm-3 control-label text-left">
                        {__("Posts Boosts")}
                    </label>
                    <div class="col-sm-9">
                        <input class="form-control" name="boost_posts">
                        <span class="help-block">
                            {__("Max posts boosts allowed")}
                        </span>
                    </div>
                </div>

                <div class="form-group">
                    <label class="col-sm-3 control-label text-left">
                        {__("Boost Pages Enabled")}
                    </label>
                    <div class="col-sm-9">
                        <label class="switch" for="boost_pages_enabled">
                            <input type="checkbox" name="boost_pages_enabled" id="boost_pages_enabled">
                            <span class="slider round"></span>
                        </label>
                        <span class="help-block">
                            {__("Enable boost pages feature")}
                        </span>
                    </div>
                </div>

                <div class="form-group">
                    <label class="col-sm-3 control-label text-left">
                        {__("Pages Boosts")}
                    </label>
                    <div class="col-sm-9">
                        <input class="form-control" name="boost_pages">
                        <span class="help-block">
                            {__("Max pages boosts allowed")}
                        </span>
                    </div>
                </div>

                <div class="form-group">
                    <div class="col-sm-9 col-sm-offset-3">
                        <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
                    </div>
                </div>

                <!-- success -->
                <div class="alert alert-success mb0 mt10 x-hidden" role="alert"></div>
                <!-- success -->

                <!-- error -->
                <div class="alert alert-danger mb0 mt10 x-hidden" role="alert"></div>
                <!-- error -->
            </form>
        </div>
    {elseif $sub_view == "subscribers"}
        <div class="panel-body">
                
            <form class="form-horizontal">
                <div class="alert alert-info">
                    <div class="icon">
                        <i class="fa fa-info-circle fa-2x"></i>
                    </div>
                    <div class="text pt5">
                        {__("Garbage collector will remove all expired subscribers and their boosted posts and pages")} <button type="button" class="btn btn-sm btn-danger js_admin-tester" data-handle="packages" data-loading-text="<i class='fa fa-circle-o-notch fa-spin'></i> {__("Loading")}">
                            <i class="fa fa-bolt"></i> {__("Run")}
                        </button>
                    </div>
                </div>

                <!-- success -->
                <div class="alert alert-success mtb10 x-hidden"></div>
                <!-- success -->

                <!-- error -->
                <div class="alert alert-danger mtb10 x-hidden"></div>
                <!-- error -->
            </form>

            <div class="divider"></div>

            <div class="table-responsive">
                <table class="table table-striped table-bordered table-hover js_dataTable">
                    <thead>
                        <tr>
                            <th>{__("ID")}</th>
                            <th>{__("User")}</th>
                            <th>{__("Package")}</th>
                            <th>{__("Subscription")}</th>
                            <th>{__("Expiration")}</th>
                            <th>{__("Actions")}</th>
                        </tr>
                    </thead>
                    <tbody>
                        {foreach $rows as $row}
                        <tr>
                            <td><a href="{$system['system_url']}/{$row['user_name']}" target="_blank">{$row['user_id']}</a></td>
                            <td>
                                <a target="_blank" href="{$system['system_url']}/{$row['user_name']}">
                                    <img class="tbl-image" src="{$row['user_picture']}">
                                    {$row['user_firstname']} {$row['user_lastname']}
                                </a>
                            </td>
                            <td>
                                <a target="_blank" href="{$system['system_url']}/admincp/packages/edit/{$row['package_id']}">
                                    <img class="tbl-image" src="{$row['icon']}">
                                    {$row['name']}
                                </a>
                            </td>
                            <td>{$row['user_subscription_date']|date_format:"%e %B %Y"}</td>
                            <td>
                                {if $row['period'] == "life"}
                                    {__("Life Time")}
                                {else}
                                    {$row['subscription_end']|date_format:"%e %B %Y"} ({if $row['subscription_timeleft'] > 0}{__("Remaining")} {$row['subscription_timeleft']} {__("Days")}{else}{__("Expired")}{/if})
                                {/if}
                            </td>
                            <td>
                                <a data-toggle="tooltip" data-placement="top" title='{__("Edit")}' href="{$system['system_url']}/admincp/users/edit/{$row['user_id']}" class="btn btn-xs btn-primary">
                                    <i class="fa fa-pencil-alt"></i>
                                </a>
                            </td>
                        </tr>
                        {/foreach}
                    </tbody>
                </table>
            </div>
        </div>
    {elseif $sub_view == "earnings"}
        <div class="panel-body">
            <div class="row">
                <div class="col-sm-6">
                    <div class="stat-panel primary">
                        <div class="stat-cell">
                            <i class="fa fa-dollar-sign bg-icon"></i>
                            <span class="text-xlg">{$system['system_currency_symbol']}{$total_earnings|number_format:2}</span><br>
                            <span class="text-lg">{__("Total earnings")}</span><br>
                        </div>
                    </div>
                </div>
                <div class="col-sm-6">
                    <div class="stat-panel info">
                        <div class="stat-cell">
                            <i class="fa fa-dollar-sign bg-icon"></i>
                            <span class="text-xlg">{$system['system_currency_symbol']}{$month_earnings|number_format:2}</span><br>
                            <span class="text-lg">{__("This month earnings")}</span><br>
                        </div>
                    </div>
                </div>
            </div>

            <div class="table-responsive">
                <table class="table table-striped table-bordered table-hover js_dataTable">
                    <thead>
                        <tr>
                            <th>{__("Package")}</th>
                            <th>{__("Total Sales")}</th>
                            <th>{__("Total Earnings")}</th>
                        </tr>
                    </thead>
                    <tbody>
                        {foreach $rows as $key => $value}
                            <tr>
                                <td>{$key}</td>
                                <td>{$value['sales']}</td>
                                <td>{$system['system_currency_symbol']}{$value['earnings']|number_format:2}</td>
                            </tr>
                        {/foreach}
                    </tbody>
                </table>
            </div>

            <div id="admin-chart-earnings" class="admin-chart mt20"></div>
        </div>
    {/if}
</div>