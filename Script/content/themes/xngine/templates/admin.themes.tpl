<div class="card">
  <div class="card-header with-icon">
    {if $sub_view == ""}
      <div class="float-end">
        <a href="{$system['system_url']}/{$control_panel['url']}/themes/add" class="btn btn-md btn-primary">
          <i class="fa fa-plus mr5"></i>{__("Add New Theme")}
        </a>
      </div>
    {elseif $sub_view == "add" || $sub_view == "edit"}
      <div class="float-end">
        <a href="{$system['system_url']}/{$control_panel['url']}/themes" class="btn btn-md btn-light">
          <i class="fa fa-arrow-circle-left mr5"></i>{__("Go Back")}
        </a>
      </div>
    {/if}
    <i class="fa fa-desktop mr10"></i>{__("Themes")}
    {if $sub_view == "edit"} &rsaquo; {$data['name']}{/if}
    {if $sub_view == "add"} &rsaquo; {__("Add New Theme")}{/if}
  </div>

  {if $sub_view == ""}

		<div class="card-body d-none">
			<div type="button" class="bg-info bg-opacity-25 p-3 p-lg-4 rounded-4 d-flex align-items-center justify-content-between gap-3 flex-wrap" data-bs-toggle="modal" data-bs-target="#updateModal">
				<div>
					<h5>Auto Update Theme</h5>
					<p class="m-0">Stay updated with automatic theme updates.</p>
				</div>
				<button class="btn btn-info">Update Theme</button>
			</div>
		</div>
		
		
	
    <div class="card-body">
      <div class="table-responsive">
        <table class="table table-striped table-bordered table-hover js_dataTable">
          <thead>
            <tr>
              <th>{__("ID")}</th>
              <th>{__("Thumbnail")}</th>
              <th>{__("Name")}</th>
              <th>{__("Default")}</th>
              <th>{__("Selectable")}</th>
              <th>{__("Actions")}</th>
            </tr>
          </thead>
          <tbody>
            {foreach $rows as $row}
              <tr>
                <td>{$row['theme_id']}</td>
                <td>
                  <img width="210" src="{$system['system_url']}/content/themes/{$row['name']}/thumbnail.png">
                </td>
                <td>{$row['name']}</td>
                <td>
                  {if $row['default']}
                    <span class="badge rounded-pill badge-lg bg-success">{__("Yes")}</span>
                  {else}
                    <span class="badge rounded-pill badge-lg bg-danger">{__("No")}</span>
                  {/if}
                </td>
                <td>
                  {if $row['enabled']}
                    <span class="badge rounded-pill badge-lg bg-success">{__("Yes")}</span>
                  {else}
                    <span class="badge rounded-pill badge-lg bg-danger">{__("No")}</span>
                  {/if}
                </td>
                <td>
                  <a data-bs-toggle="tooltip" title='{__("Edit")}' href="{$system['system_url']}/{$control_panel['url']}/themes/edit/{$row['theme_id']}" class="btn btn-sm btn-icon btn-rounded btn-primary">
                    <i class="fa fa-pencil-alt"></i>
                  </a>
                  <button data-bs-toggle="tooltip" title='{__("Delete")}' class="btn btn-sm btn-icon btn-rounded btn-danger js_admin-deleter" data-handle="theme" data-id="{$row['theme_id']}">
                    <i class="fa fa-trash-alt"></i>
                  </button>
                </td>
              </tr>
            {/foreach}
          </tbody>
        </table>
      </div>

      <div class="divider"></div>

      <div class="mt-4">
        <label class="d-block form-label">
          {__("Third-party Themes")}
        </label>
        <div class="d-flex py-3 px-2 align-items-start justify-content-between flex-wrap">
          <div class="d-inline-flex align-items-start">
            <a href="https://bit.ly/DelusElengineTheme" target="_blank">
              <img src="{$system['system_url']}/content/themes/{$system['theme']}/images/elengine.png" width="64" height="64">
            </a>
            <div class="ml15">
              <h5><a href="https://bit.ly/DelusElengineTheme" target="_blank">Elengine - The Ultimate Delus Theme</a></h5>
              <ul>
                <li>{__("Elegant and Modern Design")}</li>
                <li>{__("Regular and Free Updates")}</li>
                <li>{__("Lifetime support")}</li>
              </ul>
            </div>
          </div>
          <a href="https://bit.ly/DelusElengineTheme" class="btn btn-md btn-success" target="_blank">
            <i class="fa-solid fa-cart-shopping mr5"></i>{__("Buy Now")}
          </a>
        </div>

        <div class="d-flex py-3 px-2 align-items-start justify-content-between flex-wrap">
          <div class="d-inline-flex align-items-start">
            <a href="https://bit.ly/DelusXngineTheme" target="_blank">
              <img src="{$system['system_url']}/content/themes/{$system['theme']}/images/xngine.png" width="64" height="64">
            </a>
            <div class="ml15">
              <h5><a href="https://bit.ly/DelusXngineTheme" target="_blank">Xngine – The Ultimate Delus Theme</a></h5>
              <ul>
                <li>{__("Elegant and Modern Design")}</li>
                <li>{__("Regular and Free Updates")}</li>
                <li>{__("Lifetime support")}</li>
              </ul>
            </div>
          </div>
          <a href="https://bit.ly/DelusXngineTheme" class="btn btn-md btn-success" target="_blank">
            <i class="fa-solid fa-cart-shopping mr5"></i>{__("Buy Now")}
          </a>
        </div>
      </div>
    </div>
	
	
	
		<div class="modal fade" id="updateModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<h6 class="modal-title">Xngine Theme Updater</h6>
						<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
					</div>
					<div class="modal-body">
						<div id="scriptUpdateInfo" class="alert alert-danger mb-4" style="display: none;"></div>
						
						<div class="alert bg-warning bg-opacity-25 mb-4 p-3 small">
							IMPORTANT: Always take Backup of your site/theme first.<br><br>
							Do not proceed with auto-update if you've modified theme files or added custom work. Updating will overwrite your changes and result in loss of customizations.
						</div>
						
						<button id="checkUpdateBtn" class="btn py-3 btn-primary w-100">Check for Updates</button>
						
						<div id="updateArea" style="display:none;">
							<pre><p>v<span id="versionText"></span></p><div><strong>Changelog:</strong></div><div id="changelogText"></div></pre>
							
							<div id="purcc_code">
								<div class="form-floating mt-4 mb-1">
									<input type="text" class="form-control" placeholder=" " autocomplete="off" id="purchase_code">
									<label class="form-label">Enter Theme Purchase Code</label>
								</div>
								<div class="small mb-4">
									Get your purchase code <a href="https://portasale.com/user/purchases" target="_blank">here.</a>
								</div>
							</div>
							
							<button id="validateAndUpdate" class="btn py-3 btn-primary w-100">Download & Install Update</button>
						</div>
						
						<div id="updateResult"></div>
						
						<input type="hidden" id="scriptVersion" value="{$system['system_version']}">
						<input type="hidden" id="jsonFile" value="{$system['system_url']}/content/themes/{$system['theme']}/version.json">
						<input type="hidden" id="themeUpdater" value="{$system['system_url']}/content/themes/{$system['theme']}/templates/theme-updater.php">
					</div>
				</div>
			</div>
		</div>
	
	
	{literal}
	<script>
		const scriptVersion = document.getElementById('scriptVersion').value;
		const jsonFile = document.getElementById('jsonFile').value;
		const themeUpdater = document.getElementById('themeUpdater').value;

		document.getElementById('checkUpdateBtn').addEventListener('click', function () {
			const checkBtn = document.getElementById('checkUpdateBtn');
			const originalText = checkBtn.innerHTML;

			// Disable button and show loading text
			checkBtn.disabled = true;
			checkBtn.innerHTML = 'Checking for updates...';
	
			fetch(jsonFile)
			.then(response => {
				if (!response.ok) {
					throw new Error('version.json file not found');
				}
				return response.json();
			})
			.then(localData => {
				return fetch('https://k97.in/x_update/check-update.php', {
					method: 'POST',
					headers: {
						'Content-Type': 'application/json'
					},
					body: JSON.stringify({
						version: localData.version,
						script: scriptVersion,
						site: window.location.hostname
					})
				});
			})
			.then(response => response.json())
			.then(res => {
				const scriptUpdateDiv = document.getElementById('scriptUpdateInfo');

				// Display error in HTML if script version is outdated
				if (res.error) {
					if (scriptUpdateDiv) {
						scriptUpdateDiv.style.display = 'block';
						scriptUpdateDiv.innerHTML = res.error;
					}
					return;
				}

				// If theme update is available
				if (res.update_available) {
					checkBtn.remove();
					document.getElementById('updateArea').style.display = 'block';
					document.getElementById('versionText').innerHTML = res.version;
					document.getElementById('changelogText').innerHTML = res.changelog || 'No changelog provided.';
				} else {
					if (scriptUpdateDiv) scriptUpdateDiv.style.display = 'none'; // Clear any old errors
					alert('Your theme is up to date.');
				}
			})
			.catch(error => {
				if (error.message === 'version.json file not found') {
					alert('version.json file not found');
				} else {
					console.error('Error checking update:', error);
				}
			})
			.finally(() => {
				// Re-enable the button and restore original text
				checkBtn.disabled = false;
				checkBtn.innerHTML = originalText;
			});
		});

		document.getElementById('validateAndUpdate').addEventListener('click', function () {
			const purcode = document.getElementById('purcc_code');
			const code = document.getElementById('purchase_code').value;
			const site = window.location.hostname;
			
			const downBtn = document.getElementById('validateAndUpdate');
			const originalDownText = downBtn.innerHTML;

			// Disable button and show loading text
			downBtn.disabled = true;
			downBtn.innerHTML = 'Loading...';

			fetch('https://k97.in/x_update/validate-purchase.php', {
				method: 'POST',
				headers: {
					'Content-Type': 'application/json'
				},
				body: JSON.stringify({
					purchase_code: code,
					site: site
				})
			})
			.then(response => response.json())
			.then(res => {
				if (res.status === 'success') {
					purcode.remove();
					return fetch(themeUpdater, {
						method: 'POST',
						headers: {
							'Content-Type': 'application/json'
						},
						body: JSON.stringify({
							action: 'download_update',
							zip_url: res.zip_url
						})
					})
					.then(updateRes => updateRes.json())
					.then(updateData => {
						downBtn.remove();
						document.getElementById('updateResult').innerHTML = updateData.message;
						document.getElementById('updateResult').style.margin = '10px 0 0';
					});
				} else {
					document.getElementById('updateResult').innerHTML = res.message;
					document.getElementById('updateResult').style.margin = '10px 0 0';
				}
			})
			.catch(error => {
				console.error('Error validating or updating:', error);
				document.getElementById('updateResult').innerHTML = "An error occurred.";
				document.getElementById('updateResult').style.margin = '10px 0 0';
			})
			.finally(() => {
				// Re-enable the button and restore original text
				downBtn.disabled = false;
				downBtn.innerHTML = originalDownText;
			});
		});
	</script>
	{/literal}
	
	

  {elseif $sub_view == "edit"}

    <form class="js_ajax-forms" data-url="admin/themes.php?do=edit&id={$data['theme_id']}">
      <div class="card-body">
        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Default")}
          </label>
          <div class="col-md-9">
            <label class="switch" for="default">
              <input type="checkbox" name="default" id="default" {if $data['default']}checked{/if}>
              <span class="slider round"></span>
            </label>
            <div class="form-text">
              {__("Make it the default theme of the site")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Selectable")}
          </label>
          <div class="col-md-9">
            <label class="switch" for="enabled">
              <input type="checkbox" name="enabled" id="enabled" {if $data['enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
            <div class="form-text">
              {__("Make it the selectable so users can change the theme")}.<br>
              {__("(You must have 2+ selectable themes)")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Name")}
          </label>
          <div class="col-md-9">
            <input class="form-control" name="name" value="{$data['name']}">
            <div class="form-text">
              {__("Theme name should not contain spaces or special characters")}.<br>
              {__("(Valid name examples: mytheme, material, custom_theme)")}
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


  {elseif $sub_view == "add"}

    <form class="js_ajax-forms" data-url="admin/themes.php?do=add">
      <div class="card-body">
        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Default")}
          </label>
          <div class="col-md-9">
            <label class="switch" for="default">
              <input type="checkbox" name="default" id="default">
              <span class="slider round"></span>
            </label>
            <div class="form-text">
              {__("Make it the default theme of the site")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Selectable")}
          </label>
          <div class="col-md-9">
            <label class="switch" for="enabled">
              <input type="checkbox" name="enabled" id="enabled">
              <span class="slider round"></span>
            </label>
            <div class="form-text">
              {__("Make it the selectable so users can change the theme")}.<br>
              {__("(You must have 2+ selectable themes)")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Name")}
          </label>
          <div class="col-md-9">
            <input class="form-control" name="name">
            <div class="form-text">
              {__("Theme name should not contain spaces or special characters")}.<br>
              {__("(Valid name examples: mytheme, material, custom_theme)")}
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

  {/if}
</div>