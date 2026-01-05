<div class="panel panel-default">
    <div class="panel-heading with-icon">
        {if $sub_view == "categories"}
            <div class="pull-right flip">
                <a href="{$system['system_url']}/admincp/blogs/add_category" class="btn btn-primary">
                    <i class="fa fa-plus"></i> {__("Add New Category")}
                </a>
            </div>
        {elseif $sub_view == "add_category" || $sub_view == "edit_category"}
            <div class="pull-right flip">
                <a href="{$system['system_url']}/admincp/blogs/categories" class="btn btn-default">
                    <i class="fa fa-arrow-circle-left"></i> {__("Go Back")}
                </a>
            </div>
        {/if}
        <i class="fab fa-blogger-b pr5 panel-icon"></i>
        <strong>{__("Blogs")}</strong>
        {if $sub_view == "categories"} &rsaquo; <strong>{__("Categories")}</strong>{/if}
        {if $sub_view == "add_category"} &rsaquo; <strong>{__("Categories")}</strong> &rsaquo; <strong>{__("Add New")}</strong>{/if}
        {if $sub_view == "edit_category"} &rsaquo; <strong>{__("Categories")}</strong> &rsaquo; <strong>{$data['category_name']}</strong>{/if}
    </div>
    {if $sub_view == "categories"}
        <div class="panel-body">
            <div class="table-responsive">
                <table class="table table-striped table-bordered table-hover js_dataTable">
                    <thead>
                        <tr>
                            <th>{__("ID")}</th>
                            <th>{__("Title")}</th>
                            <th>{__("Actions")}</th>
                        </tr>
                    </thead>
                    <tbody>
                        {foreach $rows as $row}
                        <tr>
                            <td>{$row['category_id']}</td>
                            <td>{$row['category_name']}</td>
                            <td>
                                <button data-toggle="tooltip" data-placement="top" title='{__("Delete")}' class="btn btn-xs btn-danger js_admin-deleter" data-handle="blogs_category" data-id="{$row['category_id']}">
                                    <i class="fa fa-trash-alt"></i>
                                </button>
                                <a data-toggle="tooltip" data-placement="top" title='{__("Edit")}' href="{$system['system_url']}/admincp/blogs/edit_category/{$row['category_id']}" class="btn btn-xs btn-primary">
                                    <i class="fa fa-pencil-alt"></i>
                                </a>
                            </td>
                        </tr>
                        {/foreach}
                    </tbody>
                </table>
            </div>
        </div>
    {elseif $sub_view == "add_category"}
        <div class="panel-body">
            <form class="js_ajax-forms form-horizontal" data-url="admin/blogs.php?do=add_category">
                <div class="form-group">
                    <label class="col-sm-3 control-label text-left">
                        {__("Name")}
                    </label>
                    <div class="col-sm-9">
                        <input class="form-control" name="category_name">
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
    {elseif $sub_view == "edit_category"}
        <div class="panel-body">
            <form class="js_ajax-forms form-horizontal" data-url="admin/blogs.php?do=edit_category&id={$data['category_id']}">
                <div class="form-group">
                    <label class="col-sm-3 control-label text-left">
                        {__("Name")}
                    </label>
                    <div class="col-sm-9">
                        <input class="form-control" name="category_name" value="{$data['category_name']}">
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