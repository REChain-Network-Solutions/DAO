<div class="card">
  <div class="card-header with-icon">
    {if $sub_view == ""}
      <div class="float-end">
        <a href="{$system['system_url']}/{$control_panel['url']}/colored_posts/add" class="btn btn-md btn-primary">
          <i class="fa fa-plus mr5"></i>{__("Add New Pattern")}
        </a>
      </div>
    {else}
      <div class="float-end">
        <a href="{$system['system_url']}/{$control_panel['url']}/colored_posts" class="btn btn-md btn-light">
          <i class="fa fa-arrow-circle-left mr5"></i>{__("Go Back")}
        </a>
      </div>
    {/if}
    <i class="fa fa-palette mr10"></i>{__("Colored Posts")}
    {if $sub_view == "add"} &rsaquo; {__("Add New Pattern")}{/if}
    {if $sub_view == "edit"} &rsaquo; {__("Edit Pattern")}{/if}
  </div>

  {if $sub_view == ""}

    <div class="card-body">
      <div class="table-responsive">
        <table class="table table-striped table-bordered table-hover js_dataTable">
          <thead>
            <tr>
              <th>{__("ID")}</th>
              <th>{__("Preview")}</th>
              <th>{__("Actions")}</th>
            </tr>
          </thead>
          <tbody>
            {foreach $rows as $row}
              <tr>
                <td>{$row['pattern_id']}</td>
                <td>
                  {if $row['type'] == "color"}
                    <div class="post-colored-preview small" style="background-image: linear-gradient(45deg, {$row['background_color_1']}, {$row['background_color_2']});">
                      <h4 style="color: {$row['text_color']};">
                        {__("Hello World")}
                      </h4>
                    </div>
                  {else}
                    <div class="post-colored-preview small" style="background-image: url({$system['system_uploads']}/{$row['background_image']})">
                      <h4 style="color: {$row['text_color']};">
                        {__("Hello World")}
                      </h4>
                    </div>
                  {/if}
                </td>
                <td>
                  <a data-bs-toggle="tooltip" title='{__("Edit")}' href="{$system['system_url']}/{$control_panel['url']}/colored_posts/edit/{$row['pattern_id']}" class="btn btn-sm btn-icon btn-rounded btn-primary">
                    <i class="fa fa-pencil-alt"></i>
                  </a>
                  <button data-bs-toggle="tooltip" title='{__("Delete")}' class="btn btn-sm btn-icon btn-rounded btn-danger js_admin-deleter" data-handle="pattern" data-id="{$row['pattern_id']}">
                    <i class="fa fa-trash-alt"></i>
                  </button>
                </td>
              </tr>
            {/foreach}
          </tbody>
        </table>
      </div>
    </div>

  {elseif $sub_view == "add"}

    <form class="js_ajax-forms" data-url="admin/colored_posts.php?do=add">
      <div class="card-body">
        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Pattern Type")}
          </label>
          <div class="col-md-9">
            <div class="form-check form-check-inline">
              <input type="radio" name="type" id="pattern_type_color" value="color" class="form-check-input js_pattern-type" checked>
              <label class="form-check-label" for="pattern_type_color">{__("Background Color")}</label>
            </div>
            <div class="form-check form-check-inline">
              <input type="radio" name="type" id="pattern_type_image" value="image" class="form-check-input js_pattern-type">
              <label class="form-check-label" for="pattern_type_image">{__("Background Image")}</label>
            </div>
          </div>
        </div>

        <div id="js_pattern-type-color">
          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("Background Color 1")}
            </label>
            <div class="col-md-9">
              <div class="input-group js_colorpicker">
                <input type="text" class="form-control form-control-color js_pattern-background-color-1" name="background_color_1" value="#FF00FF" />
                <input type="color" class="form-control form-control-color" value="#FF00FF" />
              </div>
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("Background Color 2")}
            </label>
            <div class="col-md-9">
              <div class="input-group js_colorpicker">
                <input type="text" class="form-control form-control-color js_pattern-background-color-2" name="background_color_2" value="#3A3AD7" />
                <input type="color" class="form-control form-control-color" value="#3A3AD7" />
              </div>
            </div>
          </div>
        </div>

        <div id="js_pattern-type-image" class="x-hidden">
          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("Background Image")}
            </label>
            <div class="col-md-9">
              <div class="x-image">
                <button type="button" class="btn-close x-hidden js_x-image-remover" title='{__("Remove")}'></button>
                <div class="x-image-loader">
                  <div class="progress x-progress">
                    <div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
                  </div>
                </div>
                <i class="fa fa-camera fa-lg js_x-uploader" data-handle="x-image"></i>
                <input type="hidden" class="js_x-image-input js_pattern-background-image" name="background_image" value="">
              </div>
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Text Color")}
          </label>
          <div class="col-md-9">
            <div class="input-group js_colorpicker">
              <input type="text" class="form-control form-control-color js_pattern-text-color" name="text_color" value="#000000" />
              <input type="color" class="form-control form-control-color" value="#000000" />
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Preview")}
          </label>
          <div class="col-md-9">
            <div class="post-colored-preview js_pattern-preview" style="background-image: linear-gradient(45deg, #FF00FF, #3A3AD7);">
              <h2 style="color: #000000;">
                {__("Hello World")}
              </h2>
            </div>
          </div>
        </div>

        <!-- success -->
        <div class="alert alert-success mt15 mb0 x-hidden"></div>
        <!-- success -->

        <!-- error -->
        <div class="alert alert-danger mt15 mb0 x-hidden"></div>
        <!-- error -->
      </div>
      <div class="card-footer text-end">
        <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
      </div>
    </form>

  {elseif $sub_view == "edit"}

    <form class="js_ajax-forms" data-url="admin/colored_posts.php?do=edit&id={$data['pattern_id']}">
      <div class="card-body">
        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Pattern Type")}
          </label>
          <div class="col-md-9">
            <div class="form-check form-check-inline">
              <input type="radio" name="type" id="pattern_type_color" value="color" class="form-check-input js_pattern-type" {if $data['type'] == "color"}checked{/if}>
              <label class="form-check-label" for="pattern_type_color">{__("Background Color")}</label>
            </div>
            <div class="form-check form-check-inline">
              <input type="radio" name="type" id="pattern_type_image" value="image" class="form-check-input js_pattern-type" {if $data['type'] == "image"}checked{/if}>
              <label class="form-check-label" for="pattern_type_image">{__("Background Image")}</label>
            </div>
          </div>
        </div>

        <div id="js_pattern-type-color" {if $data['type'] == "image"}class="x-hidden" {/if}>
          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("Background Color 1")}
            </label>
            <div class="col-md-9">
              <div class="input-group js_colorpicker">
                <input type="text" class="form-control form-control-color js_pattern-background-color-1" name="background_color_1" value="{$data['background_color_1']}" />
                <input type="color" class="form-control form-control-color" value="{$data['background_color_1']}" />
              </div>
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("Background Color 2")}
            </label>
            <div class="col-md-9">
              <div class="input-group js_colorpicker">
                <input type="text" class="form-control form-control-color js_pattern-background-color-2" name="background_color_2" value="{$data['background_color_2']}" />
                <input type="color" class="form-control form-control-color" value="{$data['background_color_2']}" />
              </div>
            </div>
          </div>
        </div>

        <div id="js_pattern-type-image" {if $data['type'] == "color"}class="x-hidden" {/if}>
          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("Background Image")}
            </label>
            <div class="col-md-9">
              <div class="x-image" style="background-image: url('{$system['system_uploads']}/{$data['background_image']}')">
                <button type="button" class="btn-close js_x-image-remover" title='{__("Remove")}'></button>
                <div class="x-image-loader">
                  <div class="progress x-progress">
                    <div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
                  </div>
                </div>
                <i class="fa fa-camera fa-lg js_x-uploader" data-handle="x-image"></i>
                <input type="hidden" class="js_x-image-input js_pattern-background-image" name="background_image" value="{$data['background_image']}">
              </div>
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Text Color")}
          </label>
          <div class="col-md-9">
            <div class="input-group js_colorpicker">
              <input type="text" class="form-control form-control-color js_pattern-text-color" name="text_color" value="{$data['text_color']}" />
              <input type="color" class="form-control form-control-color" value="{$data['text_color']}" />
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Preview")}
          </label>
          <div class="col-md-9">
            {if $data['type'] == "color"}
              <div class="post-colored-preview js_pattern-preview" style="background-image: linear-gradient(45deg, {$data['background_color_1']}, {$data['background_color_2']});">
                <h2 style="color: {$data['text_color']};">
                  {__("Hello World")}
                </h2>
              </div>
            {else}
              <div class="post-colored-preview js_pattern-preview" style="background-image: url({$system['system_uploads']}/{$data['background_image']})">
                <h2 style="color: {$data['text_color']};">
                  {__("Hello World")}
                </h2>
              </div>
            {/if}
          </div>
        </div>

        <!-- success -->
        <div class="alert alert-success mt15 mb0 x-hidden"></div>
        <!-- success -->

        <!-- error -->
        <div class="alert alert-danger mt15 mb0 x-hidden"></div>
        <!-- error -->
      </div>
      <div class="card-footer text-end">
        <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
      </div>
    </form>

  {/if}
</div>