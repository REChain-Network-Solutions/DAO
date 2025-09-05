<div class="panel panel-default">
    <div class="panel-heading with-icon">
        {if $sub_view == ""}
            <div class="pull-right flip">
                <a href="{$system['system_url']}/admincp/languages/add" class="btn btn-primary">
                    <i class="fa fa-plus"></i> {__("Add New Language")}
                </a>
            </div>
        {/if}
        <i class="fa fa-globe pr5 panel-icon"></i>
        <strong>{__("Languages")}</strong>
        {if $sub_view == "edit"} &rsaquo; <strong>{$data['title']}</strong>{/if}
        {if $sub_view == "add"} &rsaquo; <strong>{__("Add New")}</strong>{/if}
    </div>
    {if $sub_view == ""}
        <div class="panel-body">
            <div class="table-responsive">
                <table class="table table-striped table-bordered table-hover js_dataTable">
                    <thead>
                        <tr>
                            <th>{__("ID")}</th>
                            <th>{__("Title")}</th>
                            <th>{__("Code")}</th>
                            <th>{__("Dir")}</th>
                            <th>{__("Default")}</th>
                            <th>{__("Enabled")}</th>
                            <th>{__("Actions")}</th>
                        </tr>
                    </thead>
                    <tbody>
                        {foreach $rows as $row}
                        <tr>
                            <td>{$row['language_id']}</td>
                            <td>
                                <a target="_blank" href="{$system['system_url']}/admincp/languages/edit/{$row['language_id']}">
                                    <img class="tbl-image" src="{$row['flag']}">
                                    {$row['title']}
                                </a>
                            </td>
                            <td>{$row['code']}</td>
                            <td>{$row['dir']}</td>
                            <td>
                                {if $row['default']}
                                    <span class="label label-success">{__("Yes")}</span>
                                {else}
                                    <span class="label label-danger">{__("No")}</span>
                                {/if}
                            </td>
                            <td>
                                {if $row['enabled']}
                                    <span class="label label-success">{__("Yes")}</span>
                                {else}
                                    <span class="label label-danger">{__("No")}</span>
                                {/if}
                            </td>
                            <td>
                                <button data-toggle="tooltip" data-placement="top" title='{__("Delete")}' class="btn btn-xs btn-danger js_admin-deleter" data-handle="language" data-id="{$row['language_id']}">
                                    <i class="fa fa-trash-alt"></i>
                                </button>
                                <a data-toggle="tooltip" data-placement="top" title='{__("Edit")}' href="{$system['system_url']}/admincp/languages/edit/{$row['language_id']}" class="btn btn-xs btn-primary">
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
            <form class="js_ajax-forms form-horizontal" data-url="admin/languages.php?do=edit&id={$data['language_id']}">
                <div class="form-group">
                    <label class="col-sm-3 control-label text-left">
                        {__("Default")}
                    </label>
                    <div class="col-sm-9">
                        <label class="switch" for="default">
                            <input type="checkbox" name="default" id="default" {if $data['default']}checked{/if}>
                            <span class="slider round"></span>
                        </label>
                        <span class="help-block">
                            {__("Make it the default language of the site")}
                        </span>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-3 control-label text-left">
                        {__("Enabled")}
                    </label>
                    <div class="col-sm-9">
                        <label class="switch" for="enabled">
                            <input type="checkbox" name="enabled" id="enabled" {if $data['enabled']}checked{/if}>
                            <span class="slider round"></span>
                        </label>
                        <span class="help-block">
                            {__("Make it enbaled so the user can translate the site to it")}
                        </span>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-3 control-label text-left">
                        {__("Code")}
                    </label>
                    <div class="col-sm-9">
                        <input class="form-control" name="code" value="{$data['code']}">
                        <span class="help-block">
                            {__("Language country_code, For Example: en_us, ar_sa or fr_fr")}
                        </span>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-3 control-label text-left">
                        {__("Native Name")}
                    </label>
                    <div class="col-sm-9">
                        <input class="form-control" name="title" value="{$data['title']}">
                        <span class="help-block">
                            {__("The native name of this language")}
                        </span>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-3 control-label text-left">
                        {__("Flag")}
                    </label>
                    <div class="col-sm-9">
                        {if $data['flag'] == ''}
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
                                <input type="hidden" class="js_x-image-input" name="flag" value="">
                            </div>
                        {else}
                            <div class="x-image" style="background-image: url('{$system['system_uploads']}/{$data['flag']}')">
                                <button type="button" class="close js_x-image-remover" title='{__("Remove")}'>
                                    <span>×</span>
                                </button>
                                <div class="x-image-loader">
                                    <div class="progress x-progress">
                                        <div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
                                    </div>
                                </div>
                                <i class="fa fa-camera fa-lg js_x-uploader" data-handle="x-image"></i>
                                <input type="hidden" class="js_x-image-input" name="flag" value="{$data['flag']}">
                            </div>
                        {/if}
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-3 control-label text-left">
                        {__("Direction")}
                    </label>
                    <div class="col-sm-9">
                        <select class="form-control" name="dir">
                            <option {if $data['dir'] == "LTR"}selected{/if} value="LTR">LTR</option>
                            <option {if $data['dir'] == "RTL"}selected{/if} value="RTL">RTL</option>
                        </select>
                        <span class="help-block">
                            {__("The direction of this language 'Left To Right' or 'Right To Left'")}
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
            <form class="js_ajax-forms form-horizontal" data-url="admin/languages.php?do=add">
                <div class="form-group">
                    <label class="col-sm-3 control-label text-left">
                        {__("Default")}
                    </label>
                    <div class="col-sm-9">
                        <label class="switch" for="default">
                            <input type="checkbox" name="default" id="default">
                            <span class="slider round"></span>
                        </label>
                        <span class="help-block">
                            {__("Make it the default language of the site")}
                        </span>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-3 control-label text-left">
                        {__("Enabled")}
                    </label>
                    <div class="col-sm-9">
                        <label class="switch" for="enabled">
                            <input type="checkbox" name="enabled" id="enabled">
                            <span class="slider round"></span>
                        </label>
                        <span class="help-block">
                            {__("Make it enbaled so the user can translate the site to it")}
                        </span>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-3 control-label text-left">
                        {__("Code")}
                    </label>
                    <div class="col-sm-9">
                        <input class="form-control" name="code">
                        <span class="help-block">
                            {__("Language country_code, For Example: en_us, ar_sa or fr_fr")}
                        </span>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-3 control-label text-left">
                        {__("Native Name")}
                    </label>
                    <div class="col-sm-9">
                        <input class="form-control" name="title">
                        <span class="help-block">
                            {__("The native name of this language")}
                        </span>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-3 control-label text-left">
                        {__("Flag")}
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
                            <input type="hidden" class="js_x-image-input" name="flag" value="">
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-3 control-label text-left">
                        {__("Direction")}
                    </label>
                    <div class="col-sm-9">
                        <select class="form-control" name="dir">
                            <option value="LTR">LTR</option>
                            <option value="RTL">RTL</option>
                        </select>
                        <span class="help-block">
                            {__("The direction of this language 'Left To Right' or 'Right To Left'")}
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
    {/if}
</div>