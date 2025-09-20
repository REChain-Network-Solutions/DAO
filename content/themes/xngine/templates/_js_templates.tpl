{strip}

  <!-- Toasts -->
  <div class="toast-container p-3 bottom-0 start-0 fixed-bottom">
  </div>
  <!-- Toasts -->

  <!-- Modals -->
  <div id="modal" class="modal fade">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-body">
          <div class="loader pt10 pb10"></div>
        </div>
      </div>
    </div>
  </div>

  <script id="modal-login" type="text/template">
    <div class="modal-header">
      <h6 class="modal-title">{__("Not Logged In")}</h6>
    </div>
    <div class="modal-body">
      <p>{__("Please log in to continue")}</p>
    </div>
    <div class="modal-footer">
      <a class="btn btn-primary" href="{$system['system_url']}/signin">{__("Login")}</a>
    </div>
  </script>

  <script id="modal-message" type="text/template">
    <div class="modal-header">
      <h6 class="modal-title">{literal}{{title}}{/literal}</h6>
      <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">
      </button>
    </div>
    <div class="modal-body">
      <p>{literal}{{{message}}}{/literal}</p>
    </div>
  </script>

  <script id="modal-success" type="text/template">
    <div class="modal-body text-center" style="padding: 50px;">
      {include file='__svg_icons.tpl' icon="checkmark" class="main-icon mb20" width="60px" height="60px"}
      <h4>{literal}{{title}}{/literal}</h4>
      <p class="mt20">{literal}{{{message}}}{/literal}</p>
    </div>
  </script>
  
  <script id="modal-info" type="text/template">
    <div class="modal-body text-center" style="padding: 50px;">
      {include file='__svg_icons.tpl' icon="info" class="main-icon mb20" width="60px" height="60px"}
      <h4>{literal}{{title}}{/literal}</h4>
      <p class="mt20">{literal}{{{message}}}{/literal}</p>
    </div>
  </script>

  <script id="modal-error" type="text/template">
    <div class="modal-body text-center" style="padding: 50px;">
      {include file='__svg_icons.tpl' icon="report" class="main-icon mb20" width="60px" height="60px"}
      <h4>{literal}{{title}}{/literal}</h4>
      <p class="mt20">{literal}{{{message}}}{/literal}</p>
    </div>
  </script>

  <script id="modal-confirm" type="text/template">
    <div class="modal-header">
      <h6 class="modal-title">{literal}{{title}}{/literal}</h6>
    </div>
    <div class="modal-body">
      <h6>{literal}{{{message}}}{/literal}</h6>
      {literal}{{#password_check}}{/literal}
      <div class="form-group mt20">
        <label class="form-label" for="modal-password-check">{__("Confirm Password")}</label>
        <input id="modal-password-check" name="password_check" type="password" class="form-control">
      </div>
      {literal}{{/password_check}}{/literal}
    </div>
    <div class="modal-footer">
      <button type="button" class="btn btn-light" data-bs-dismiss="modal">{__("Cancel")}</button>
      <button type="button" class="btn btn-primary" id="modal-confirm-ok">{__("Confirm")}</button>
    </div>
  </script>

  <script id="modal-confirm-payment" type="text/template">
    <div class="modal-body text-center" style="padding: 50px;">
      {include file='__svg_icons.tpl' icon="market" class="main-icon mb20" width="60px" height="60px"}
      <h4>{__("Payment Alert")}</h4>
      <p class="mt20">{__("You are about to purchase the items, do you want to proceed?")}</p>
      <div class="mt30 text-center">
        <button type="button" class="btn btn-light rounded-pill mr10" data-bs-dismiss="modal">{__("Cancel")}</button>
        <button type="button" class="btn btn-primary rounded-pill" id="modal-confirm-payment-ok">{__("Confirm")}</button>
      </div>    
    </div>
  </script>

  <script id="modal-loading" type="text/template">
    <div class="modal-body text-center">
      <div class="spinner-border text-primary"></div>
    </div>
  </script>
  <!-- Modals -->

  <!-- Theme Switcher -->
  <script id="theme-switcher" type="text/template">
    <div class="modal-header">
      <h6 class="modal-title">
        {include file='__svg_icons.tpl' icon="themes_switcher" class="main-icon mr10" width="24px" height="24px"}
        {__("Theme Switcher")}
      </h6>
      <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">
      </button>
    </div>
    <div class="modal-body pb0 pt30">
      <div class="row">
        {foreach $system['themes'] as $theme}
          <div class="col-6">
            <div style="background: rgb(0 0 0 / 0.06); padding: 8px; border-radius: 8px; margin-bottom: 30px;">
              <a style="display: block; position: relative; padding-bottom: 60%;" href="?theme={$theme['name']}">
                <img style="width: 100%; height: 100%; position: absolute; top: 0; right: 0; bottom: 0; left: 0; border-radius: 4px;" src="{$system['system_url']}/content/themes/{$theme['name']}/thumbnail.png">
                <span style="position: absolute; background: linear-gradient(transparent, rgb(0 0 0 / 0.7)); bottom: 0; left: 0; right: 0; width: 100%; border-radius: 0 0 8px 8px; color: #fff; font-size: 14px; text-align: center; text-transform: capitalize; padding: 20px 8px 8px;">
                  {$theme['name']}
                </span>
              </a>
            </div>
          </div>
        {/foreach}
      </div>
    </div>
  </script>
  <!-- Themes -->

  <!-- Search -->
  <script id="search-for" type="text/template">
    <div class="ptb10 plr10">
      <a href="{$system['system_url']}/search/{literal}{{#hashtag}}hashtag/{{/hashtag}}{/literal}{literal}{{query}}{/literal}">
        <i class="fa fa-search pr5"></i> {__("Search for")} {literal}{{#hashtag}}#{{/hashtag}}{/literal}{literal}{{query}}{/literal}
      </a>
    </div>
  </script>
  <!-- Search -->

	<!-- Lightbox -->
	<script id="lightbox" type="text/template">
		<div class="lightbox">
      <div class="lightbox-container">
        <div class="lightbox-preview">
          <div class="lightbox-next js_lightbox-slider">
            {if $system['language']['dir'] == 'RTL'}
              <i class="fa fa-chevron-circle-left fa-3x"></i>
            {else}
              <i class="fa fa-chevron-circle-right fa-3x"></i>
            {/if}
          </div>
          <div class="lightbox-prev js_lightbox-slider">
            {if $system['language']['dir'] == 'RTL'}
              <i class="fa fa-chevron-circle-right fa-3x"></i>
            {else}
              <i class="fa fa-chevron-circle-left fa-3x"></i>
            {/if}
          </div>
          {if !$system['download_images_disabled']}
            <div class="lightbox-download">
              <a href="{literal}{{image}}{/literal}" download>{__("Download")}</a> - <a target="_blank" href="{literal}{{image}}{/literal}">{__("View Original")}</a>
            </div>
          {/if}
          <img alt="" class="img-fluid" src="{literal}{{image}}{/literal}">
        </div>
        <div class="lightbox-data p-2">
          <div class="clearfix">
            <div class="pt5 pr5 float-end">
              <button type="button" class="btn-close lightbox-close js_lightbox-close">
              </button>
            </div>
          </div>
          <div class="lightbox-post">
            <div class="js_scroller" data-slimScroll-height="100%">
              <div class="loader mtb10"></div>
            </div>
          </div>
        </div>
      </div>
		</div>
	</script>

  <script id="lightbox-nodata" type="text/template">
    <div class="lightbox">
      <div class="lightbox-container">
        <div class="lightbox-preview nodata">
          <div class="lightbox-exit js_lightbox-close">
            <i class="fas fa-times fa-2x"></i>
          </div>
          <img alt="" class="img-fluid" src="{literal}{{image}}{/literal}">
        </div>
      </div>
    </div>
  </script>

  <script id="lightbox-live" type="text/template">
    <div class="lightbox" data-live-post-id="{literal}{{post_id}}{/literal}">
      <div class="lightbox-container">
        <div class="lightbox-preview with-live">
			<div class="live-stream-video position-relative x_live_show_modal" id="js_live-video">
				<div class="live-counter position-absolute text-center m-3 fw-medium small text-uppercase text-white d-flex align-items-center gap-2" id="js_live-counter">
					<span class="status rounded-2 offline" id=js_live-counter-status>{__("Offline")}</span>
					<span class="number rounded-2">
						<span id="js_live-counter-number">0</span>
					</span>
				</div>
				
				<div class="live-status position-absolute text-white top-0 end-0 start-0 bottom-0" id="js_live-status">
					<div class="d-flex align-items-center justify-content-center h-100 w-100">
						{__("Loading")} <span class="spinner-grow spinner-grow-sm ml10"></span>
					</div>
				</div>
			</div>
        </div>
        <div class="lightbox-data p-2">
			<div class="clearfix">
				<div class="pt5 pr5 float-end">
					<button type="button" class="btn-close lightbox-close js_lightbox-close">
				</button>
				</div>
			</div>
			<div class="lightbox-post">
				<div class="js_scroller" data-slimScroll-height="100%">
					<div class="loader mtb10"></div>
				</div>
			</div>
        </div>
      </div>
    </div>
  </script>
  <!-- Lightbox -->

  <!-- Two-Factor Authentication -->
  <script id="two-factor-authentication" type="text/template">
    <div class="modal-header">
      <h6 class="modal-title">{__("2FA Authentication")}</h6>
      <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
    </div>
    <form class="js_ajax-forms" data-url="core/two_factor_authentication.php">
      <div class="modal-body">
        <div class="mb20">
          {__("You've asked us to require a 6-digit login code when anyone tries to access your account from a new device or browser")}.
        </div>
        <div class="mb20">
          {__("Enter the 6-digit code that you received on your")} <strong>{literal}{{method}}{/literal}</strong>
        </div>
        <div class="form-group">
          <input class="form-control" name="two_factor_key" type="text" placeholder="######" required autofocus>
        </div>
        <!-- error -->
        <div class="alert alert-danger mb0 mt10 x-hidden"></div>
        <!-- error -->
      </div>
      <div class="modal-footer">
        <input name="user_id" type="hidden" value="{literal}{{user_id}}{/literal}">
        {literal}{{#remember}}{/literal}<input name="remember" type="hidden" value="true">{literal}{{/remember}}{/literal}
        {literal}{{#connecting_account}}{/literal}<input name="connecting_account" type="hidden" value="true">{literal}{{/connecting_account}}{/literal}
        <button type="submit" class="btn btn-primary">{__("Continue")}</button>
      </div>
    </form>
  </script>
  <!-- Two-Factor Authentication -->

  {if !$user->_logged_in}

    <!-- Forget Password -->
    <script id="forget-password-confirm" type="text/template">
      <div class="modal-header">
        <h6 class="modal-title">{__("Verification Code")}</h6>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <form class="js_ajax-forms" data-url="core/forget_password_confirm.php">
        <div class="modal-body">
          <div class="mb20">
            {__("We sent you an email with a six-digit verification code. Enter it below to continue to reset your password")}.
          </div>
          <div class="row">
            <div class="col-md-6">
              <div class="form-group">
                <input class="form-control" name="reset_key" type="text" placeholder="######" required autofocus>
              </div>
            </div>
            <div class="col-md-6">
              <label class="form-label mb5">{__("We sent your code to")}</label> <span class="badge badge-lg bg-light text-primary">{literal}{{email}}{/literal}</span>
            </div>
          </div>
          <!-- error -->
          <div class="alert alert-danger mt15 mb0 x-hidden"></div>
          <!-- error -->
        </div>
        <div class="modal-footer">
          <input name="email" type="hidden" value="{literal}{{email}}{/literal}">
          <button type="submit" class="btn btn-primary">{__("Continue")}</button>
        </div>
      </form>
    </script>

    <script id="forget-password-reset" type="text/template">
      <div class="modal-header">
        <h6 class="modal-title">{__("Change Your Password")}</h6>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <form class="js_ajax-forms" data-url="core/forget_password_reset.php">
        <div class="modal-body">
          <div class="form-group">
            <label class="form-label" for="password">{__("New Password")}</label>
            <input class="form-control" name="password" id="password" type="password" required autofocus>
          </div>
          <div class="form-group">
            <label class="form-label" for="confirm">{__("Confirm Password")}</label>
            <input class="form-control" name="confirm" id="confirm" type="password" required>
          </div>
          <!-- error -->
          <div class="alert alert-danger mb0 mt10 x-hidden"></div>
          <!-- error -->
        </div>
        <div class="modal-footer">
          <input name="email" type="hidden" value="{literal}{{email}}{/literal}">
          <input name="reset_key" type="hidden" value="{literal}{{reset_key}}{/literal}">
          <button type="submit" class="btn btn-primary">{__("Continue")}</button>
        </div>
      </form>
    </script>
    <!-- Forget Password -->

  {else}

    <!-- Account Switcher -->
    <script id="account-switcher" type="text/template">
      <div class="modal-header">
        <h6 class="modal-title">
          {include file='__svg_icons.tpl' icon="accounts_switcher" class="main-icon mr10" width="24px" height="24px"}
          {__("Switch Accounts")}
        </h6>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body ptb30">
        <ul>
          {foreach $user->_data['connected_accounts'] as $connected_account}
            <li class="feeds-item with-hover mt5">
              <div class="data-container js_connected-account-switch" data-uid="{$connected_account['user_id']}">
                <span class="data-avatar">
                  <img src="{$connected_account['user_picture']}" alt="">
                </span>
                <div class="data-content">
                  {if $connected_account['user_id'] == $user->_data['user_id']}
                    <div class="float-end">
                      <i class="fa fa-check-circle fa-fw fa-2x text-success"></i>
                    </div>
                  {/if}
                  <div class="mt5">
                    <span class="name text-link-no-underline">
                      {if $system['show_usernames_enabled']}
                        {$connected_account['user_name']}
                      {else}
                        {$connected_account['user_firstname']} {$connected_account['user_lastname']}
                      {/if}
                    </span>
                    {if $connected_account['user_verified']}
                      <span class="verified-badge" data-bs-toggle="tooltip" title='{__("Verified User")}'>
                        {include file='__svg_icons.tpl' icon="verified_badge" width="20px" height="20px"}
                      </span>
                    {/if}
                    {if $connected_account['user_subscribed']}
                      <span class="pro-badge" data-bs-toggle="tooltip" title='{__("Pro User")}'>
                        {include file='__svg_icons.tpl' icon="pro_badge" width="20px" height="20px"}
                      </span>
                    {/if}
                  </div>
                </div>
              </div>
            </li>
          {/foreach}
        </ul>
        {if $user->_data['user_id'] == $user->_data['user_master_account']}
          <div class="d-grid mt20">
            <button class="btn btn-primary" data-toggle="modal" data-url="#account-connector">{__("Add Account")}</button>
          </div>
        {/if}
      </div>
    </script>

    <script id="account-connector" type="text/template">
      <div class="modal-header">
        <h6 class="modal-title">
          {include file='__svg_icons.tpl' icon="accounts_switcher" class="main-icon mr10" width="24px" height="24px"}  
          {__("Connect Accounts")}
        </h6>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body ptb30">
        <form class="js_ajax-forms" data-url="users/switch.php" method="POST">
          <!-- username or email -->
          <div class="form-group">
            <div class="input-group">
              <span class="input-group-text"><i class="far fa-user fa-fw"></i></span>
              <input class="form-control" type="text" placeholder='{__("Email")} {__("or")} {__("Username")}' name="username_email" required>
            </div>
          </div>
          <!-- username or email -->
          <!-- password -->
          <div class="form-group">
            <div class="input-group">
              <span class="input-group-text"><i class="fas fa-key fa-fw"></i></span>
              <input class="form-control" type="password" placeholder='{__("Password")}' name="password" required>
            </div>
          </div>
          <!-- password -->
          <!-- submit -->
          <div class="d-grid form-group">
            <input type="hidden" name="do" value="signin">
            <button type="submit" class="btn btn-lg btn-primary bg-gradient-blue border-0 rounded-pill">{__("Login")}</button>
          </div>
          <!-- submit -->
          <!-- error -->
          <div class="alert alert-danger mt15 mb0 x-hidden"></div>
          <!-- error -->
        </form>
      </div>
    </script>
    <!-- Account Switcher -->

    <!-- Email Activation -->
    <script id="activation-email-reset" type="text/template">
      <div class="modal-header">
        <h6 class="modal-title">{__("Change Email Address")}</h6>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <form class="js_ajax-forms" data-url="core/activation_email_reset.php">
        <div class="modal-body">
          <div class="form-group">
            <label class="form-label mb10">{__("Current Email")}</label><br>
            <span class="badge badge-lg bg-info">{$user->_data['user_email']}</span>
          </div>
          <div class="form-group">
            <label class="form-label" for="email">{__("New Email")}</label>
            <input class="form-control" name="email" id="email" type="email" required autofocus>
          </div>
          <!-- error -->
          <div class="alert alert-danger mb0 mt10 x-hidden"></div>
          <!-- error -->
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-light" data-bs-dismiss="modal">{__("Cancel")}</button>
          <button type="submit" class="btn btn-primary">{__("Continue")}</button>
        </div>
      </form>
    </script>
    <!-- Email Activation -->

    <!-- Phone Activation -->
    <script id="activation-phone" type="text/template">
      <div class="modal-header">
        <h6 class="modal-title">{__("Enter the code from the SMS message")}</h6>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <form class="js_ajax-forms" data-url="core/activation_phone.php">
        <div class="modal-body">
          <div class="mb20">
            {__("Let us know if this mobile number belongs to you. Enter the code in the SMS")}
          </div>
          <div class="row">
            <div class="col-md-6">
              <div class="form-group">
                <input class="form-control" name="code" type="text" placeholder="######" required autofocus>
                {if $user->_data['user_phone']}
                  <div class="form-text">
                    <span class="text-link" data-toggle="modal" data-url="core/activation_phone_resend.php">{__("Resend SMS")}</span>
                  </div>
                {/if}
              </div>
              <!-- error -->
              <div class="alert alert-danger mb0 mt10 x-hidden"></div>
              <!-- error -->
            </div>
            <div class="col-md-6">
              {if $user->_data['user_phone']}
                {__("We sent your code to")} <strong>{$user->_data['user_phone']}</strong>
              {/if}
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-light" data-bs-dismiss="modal">{__("Cancel")}</button>
          <button type="submit" class="btn btn-primary">{__("Continue")}</button>
        </div>
      </form>
    </script>

    <script id="activation-phone-reset" type="text/template">
      <div class="modal-header">
        <h6 class="modal-title">{__("Change Phone Number")}</h6>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <form class="js_ajax-forms" data-url="core/activation_phone_reset.php">
        <div class="modal-body">
          {if $user->_data['user_phone']}
            <div class="form-group">
              <label class="form-label">{__("Current Phone")}</label>
              <p class="form-control-plaintext">{$user->_data['user_phone']}</p>
            </div>
          {/if}
          <div class="form-group">
            <label class="form-label">{__("New Phone")}</label>
            <input class="form-control" name="phone" type="text" required autofocus>
            <div class="form-text">
              {__("For example")}: +12344567890
            </div>
          </div>
          <!-- error -->
          <div class="alert alert-danger mb0 mt10 x-hidden"></div>
          <!-- error -->
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-light" data-bs-dismiss="modal">{__("Cancel")}</button>
          <button type="submit" class="btn btn-primary">{__("Continue")}</button>
        </div>
      </form>
    </script>
    <!-- Phone Activation -->

    <!-- x-uploader -->
    {/strip}
    <script id="x-uploader" type="text/template">
      <form class="x-uploader" action="{literal}{{url}}{/literal}" method="post" enctype="multipart/form-data">
        {literal}{{#multiple}}{/literal}
        <input name="file[]" type="file" multiple="multiple" accept="{literal}{{accept}}{/literal}">
        {literal}{{/multiple}}{/literal}
        {literal}{{^multiple}}{/literal}
        <input name="file" type="file" accept="{literal}{{accept}}{/literal}">
        {literal}{{/multiple}}{/literal}
        <input type="hidden" name="secret" value="{literal}{{secret}}{/literal}">
      </form>
    </script>
    {strip}
    <!-- x-uploader -->

    <!-- Noty Notification -->
    {if $system['noty_notifications_enabled']}
		<script id="toast-notification" type="text/template">
			<div class="toast border-0 bg-white p-3 d-block" role="alert" aria-live="assertive" aria-atomic="true">
				<div class="d-flex align-items-center justify-content-between x_user_info gap-3">
					<a href="{literal}{{url}}{/literal}" class="d-flex align-items-center position-relative gap-2">
						<img class="rounded-circle flex-0" src="{literal}{{image}}{/literal}" />
						<div class="body-color">{literal}{{message}}{/literal}</div>
					</a>
					<button type="button" class="btn-close flex-0" data-bs-dismiss="toast" aria-label="Close"></button>
				</div>
			</div>
		</script>
    {/if}
    <!-- Noty Notification -->

    <!-- Adblock Detector -->
    {if $system['adblock_detector_enabled']}
      <script id="adblock-detector" type="text/template">
        <div class="adblock-detector">
          {__("Our website is made possible by displaying online advertisements to our visitors")}<br>
          {__("Please consider supporting us by disabling your ad blocker")}.
        </div>
      </script>
    {/if}
    <!-- Adblock Detector -->

    <!-- Keyboard Shortcuts -->
    <script id="keyboard-shortcuts" type="text/template">
      <div class="modal-header">
        <h6 class="modal-title">
          {include file='__svg_icons.tpl' icon="keyboard" class="main-icon mr10" width="24px" height="24px"}
          {__("Keyboard Shortcuts")}
        </h6>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body text-xlg">
        <div class="mb10">
          <kbd>J</kbd> {__("Scroll to the next post")}
        </div>
        <div>
          <kbd>K</kbd> {__("Scroll to the previous post")}
        </div>
      </div>
    </script>
    <!-- Keyboard Shortcuts -->

    <!-- Emoji Menu -->
    <script id="emoji-menu" type="text/template">
      <div class="emoji-menu">
        <div class="tab-content">
          <div class="tab-pane tab-emojis active" id="tab-emojis-{literal}{{id}}{/literal}">
            <div class="js_scroller" data-slimScroll-height="180">
              {foreach $emojis as $emoji_index => $emoji }
                <div class="item item-{$emoji_index}"{if $emoji_index > 50 } style="display: none;" js-hidden {/if}>
                    <i data-emoji="{$emoji['unicode_char']}" class="js_emoji twa twa-2x twa-{$emoji['class']}"></i> 
                </div>
              {/foreach}
            </div>
          </div>
          <div class="tab-pane" id="tab-stickers-{literal}{{id}}{/literal}">
            <div class="js_scroller" data-slimScroll-height="180">
              {foreach from=$user->get_stickers() item=sticker}
                <div class="item">
                  <img data-emoji=":STK-{$sticker['sticker_id']}:" src="{$system['system_uploads']}/{$sticker['image']}" class="js_emoji">
                </div>
              {/foreach}
            </div>
          </div>
        </div>
        <ul class="nav nav-tabs">
          <li class="nav-item">
            <a class="nav-link active" href="#tab-emojis-{literal}{{id}}{/literal}" data-bs-toggle="tab">
              <i class="fa fa-smile fa-fw mr5"></i>{__("Emojis")}
            </a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="#tab-stickers-{literal}{{id}}{/literal}" data-bs-toggle="tab">
              <i class="fa fa-hand-peace fa-fw mr5"></i>{__("Stickers")}
            </a>
          </li>
        </ul>
      </div>
    </script>
    <!-- Emoji Menu -->

    <!-- Chat -->
    {if $system['chat_enabled'] && $user->_data['user_privacy_chat'] != "me"}
		<!-- Chat Sidebar -->
		<div class="chat-sidebar flex-column position-fixed {if !$user->_data['user_chat_enabled']}disabled{/if}">
			<div class="chat-sidebar-content w-100">
				<div class="js_scroller" data-slimScroll-height="100%">
					<!-- Online -->
					<div class="js_chat-contacts-online">
						{foreach $sidebar_friends as $_user}
							{if $_user['user_is_online']}
								<div class="chat-avatar-wrapper clickable js_chat-start" data-uid="{$_user['user_id']}" data-name="{$_user['user_fullname']}" data-link="{$_user['user_name']}" data-picture="{$_user['user_picture']}">
									<div class="chat-avatar position-relative mx-auto">
										<img class="rounded-circle" src="{$_user['user_picture']}" alt="" />
										<span class="online-dot position-absolute rounded-circle"></span>
									</div>
								</div>
							{/if}
						{/foreach}
					</div>
					<!-- Online -->
					
					<!-- Offline -->
					<div class="js_chat-contacts-offline">
						{foreach $sidebar_friends as $_user}
							{if !$_user['user_is_online']}
								<div class="chat-avatar-wrapper clickable js_chat-start" data-uid="{$_user['user_id']}" data-name="{$_user['user_fullname']}" data-link="{$_user['user_name']}" data-picture="{$_user['user_picture']}">
									<div class="chat-avatar position-relative mx-auto">
										<img class="rounded-circle" src="{$_user['user_picture']}" alt="" />
									</div>
									{if $system['chat_status_enabled']}
										<div class="last-seen rounded-2 text-center position-absolute text-white pe-none">
											<span class="js_moment" data-time="{$_user['user_last_seen']}">{$_user["user_last_seen"]}</span>
										</div>
									{/if}
								</div>
							{/if}
						{/foreach}
					</div>
					<!-- Offline -->
				</div>
			</div>
			<div class="chat-sidebar-footer">
				<a class="btn bg-white btn-chat rounded-circle mb10 lh-1 d-block mx-auto js_chat-new" href="{$system['system_url']}/messages/new">
					<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M14 6H22M18 2L18 10" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M6.09881 19.5C4.7987 19.3721 3.82475 18.9816 3.17157 18.3284C2 17.1569 2 15.2712 2 11.5V11C2 7.22876 2 5.34315 3.17157 4.17157C4.34315 3 6.22876 3 10 3H11.5M6.5 18C6.29454 19.0019 5.37769 21.1665 6.31569 21.8651C6.806 22.2218 7.58729 21.8408 9.14987 21.0789C10.2465 20.5441 11.3562 19.9309 12.5546 19.655C12.9931 19.5551 13.4395 19.5125 14 19.5C17.7712 19.5 19.6569 19.5 20.8284 18.3284C21.947 17.2098 21.9976 15.4403 21.9999 12" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /></svg>
				</a>
				<button class="btn bg-white btn-chat rounded-circle lh-1 d-block mx-auto" data-bs-toggle="dropdown" data-display="static">
					<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M15.5 12C15.5 13.933 13.933 15.5 12 15.5C10.067 15.5 8.5 13.933 8.5 12C8.5 10.067 10.067 8.5 12 8.5C13.933 8.5 15.5 10.067 15.5 12Z" stroke="currentColor" stroke-width="1.75" /><path d="M21.011 14.0965C21.5329 13.9558 21.7939 13.8854 21.8969 13.7508C22 13.6163 22 13.3998 22 12.9669V11.0332C22 10.6003 22 10.3838 21.8969 10.2493C21.7938 10.1147 21.5329 10.0443 21.011 9.90358C19.0606 9.37759 17.8399 7.33851 18.3433 5.40087C18.4817 4.86799 18.5509 4.60156 18.4848 4.44529C18.4187 4.28902 18.2291 4.18134 17.8497 3.96596L16.125 2.98673C15.7528 2.77539 15.5667 2.66972 15.3997 2.69222C15.2326 2.71472 15.0442 2.90273 14.6672 3.27873C13.208 4.73448 10.7936 4.73442 9.33434 3.27864C8.95743 2.90263 8.76898 2.71463 8.60193 2.69212C8.43489 2.66962 8.24877 2.77529 7.87653 2.98663L6.15184 3.96587C5.77253 4.18123 5.58287 4.28891 5.51678 4.44515C5.45068 4.6014 5.51987 4.86787 5.65825 5.4008C6.16137 7.3385 4.93972 9.37763 2.98902 9.9036C2.46712 10.0443 2.20617 10.1147 2.10308 10.2492C2 10.3838 2 10.6003 2 11.0332V12.9669C2 13.3998 2 13.6163 2.10308 13.7508C2.20615 13.8854 2.46711 13.9558 2.98902 14.0965C4.9394 14.6225 6.16008 16.6616 5.65672 18.5992C5.51829 19.1321 5.44907 19.3985 5.51516 19.5548C5.58126 19.7111 5.77092 19.8188 6.15025 20.0341L7.87495 21.0134C8.24721 21.2247 8.43334 21.3304 8.6004 21.3079C8.76746 21.2854 8.95588 21.0973 9.33271 20.7213C10.7927 19.2644 13.2088 19.2643 14.6689 20.7212C15.0457 21.0973 15.2341 21.2853 15.4012 21.3078C15.5682 21.3303 15.7544 21.2246 16.1266 21.0133L17.8513 20.034C18.2307 19.8187 18.4204 19.711 18.4864 19.5547C18.5525 19.3984 18.4833 19.132 18.3448 18.5991C17.8412 16.6616 19.0609 14.6226 21.011 14.0965Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /></svg>
				</button>
				<div class="dropdown-menu dropdown-menu-end action-dropdown-menu">
					<a class="dropdown-item align-items-start" href="{$system['system_url']}/settings/blocking">
						<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M13 22H6.59087C5.04549 22 3.81631 21.248 2.71266 20.1966C0.453365 18.0441 4.1628 16.324 5.57757 15.4816C7.97679 14.053 10.8425 13.6575 13.5 14.2952" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M16.5 6.5C16.5 8.98528 14.4853 11 12 11C9.51472 11 7.5 8.98528 7.5 6.5C7.5 4.01472 9.51472 2 12 2C14.4853 2 16.5 4.01472 16.5 6.5Z" stroke="currentColor" stroke-width="1.75" /><path d="M16.05 16.05L20.95 20.95M22 18.5C22 16.567 20.433 15 18.5 15C16.567 15 15 16.567 15 18.5C15 20.433 16.567 22 18.5 22C20.433 22 22 20.433 22 18.5Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /></svg>
						<div class="action">
							{__("Manage Blocking")}
							<div class="action-desc">{__("Manage blocked users")}</div>
						</div>
					</a>
					<a class="dropdown-item align-items-start" href="{$system['system_url']}/settings/privacy">
						<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M13 22H6.59087C5.04549 22 3.81631 21.248 2.71266 20.1966C0.453365 18.0441 4.1628 16.324 5.57757 15.4816C7.97679 14.053 10.8425 13.6575 13.5 14.2952" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M16.5 6.5C16.5 8.98528 14.4853 11 12 11C9.51472 11 7.5 8.98528 7.5 6.5C7.5 4.01472 9.51472 2 12 2C14.4853 2 16.5 4.01472 16.5 6.5Z" stroke="currentColor" stroke-width="1.75" /><path d="M16.05 16.05L20.95 20.95M22 18.5C22 16.567 20.433 15 18.5 15C16.567 15 15 16.567 15 18.5C15 20.433 16.567 22 18.5 22C20.433 22 22 20.433 22 18.5Z" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /></svg>
						<div class="action">
							{__("Privacy Settings")}
							<div class="action-desc">{__("Manage your privacy")}</div>
						</div>
					</a>
					<div class="dropdown-divider"></div>
					{if $user->_data['user_chat_enabled']}
						<div class="dropdown-item pointer js_chat-toggle" data-status="on">
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M19.439 15.439C20.3636 14.5212 21.0775 13.6091 21.544 12.955C21.848 12.5287 22 12.3155 22 12C22 11.6845 21.848 11.4713 21.544 11.045C20.1779 9.12944 16.6892 5 12 5C11.0922 5 10.2294 5.15476 9.41827 5.41827M6.74742 6.74742C4.73118 8.1072 3.24215 9.94266 2.45604 11.045C2.15201 11.4713 2 11.6845 2 12C2 12.3155 2.15201 12.5287 2.45604 12.955C3.8221 14.8706 7.31078 19 12 19C13.9908 19 15.7651 18.2557 17.2526 17.2526" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /><path d="M9.85786 10C9.32783 10.53 9 11.2623 9 12.0711C9 13.6887 10.3113 15 11.9289 15C12.7377 15 13.47 14.6722 14 14.1421" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" /><path d="M3 3L21 21" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" /></svg>
							<span class="js_chat-toggle-text">{__("Turn Off Active Status")}</span>
						</div>
					{else}
						<div class="dropdown-item pointer js_chat-toggle" data-status="off">
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M21.544 11.045C21.848 11.4713 22 11.6845 22 12C22 12.3155 21.848 12.5287 21.544 12.955C20.1779 14.8706 16.6892 19 12 19C7.31078 19 3.8221 14.8706 2.45604 12.955C2.15201 12.5287 2 12.3155 2 12C2 11.6845 2.15201 11.4713 2.45604 11.045C3.8221 9.12944 7.31078 5 12 5C16.6892 5 20.1779 9.12944 21.544 11.045Z" stroke="currentColor" stroke-width="1.75" /><path d="M15 12C15 10.3431 13.6569 9 12 9C10.3431 9 9 10.3431 9 12C9 13.6569 10.3431 15 12 15C13.6569 15 15 13.6569 15 12Z" stroke="currentColor" stroke-width="1.75" /></svg>
							<span class="js_chat-toggle-text">{__("Turn On Active Status")}</span>
						</div>
					{/if}
				</div>
			</div>
		</div>
		<!-- Chat Sidebar -->
    {/if}

    <script id="chat-box-new" type="text/template">
		<div class="chat-widget chat-box opened fresh">
			<!-- head -->
			<div class="chat-widget-head bg-white w-100 d-flex align-items-center justify-content-between pointer x_user_info">
				<!-- user-card -->
				<div class="chat-user-card d-flex align-items-center position-relative mw-0">
					<div class="name fw-medium mw-0 text-truncate">
						{__("New Message")}
					</div>
				</div>
				<!-- user-card -->

				<!-- buttons-->
				<div class="chat-head-btns flex-0 d-flex align-items-center gap-1">
					<span class="chat-head-btn lh-1 js_chat-box-close pointer">
						<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M19.0005 4.99988L5.00049 18.9999M5.00049 4.99988L19.0005 18.9999" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" /></svg>
					</span>
				</div>
				<!-- buttons-->
			</div>
			<!-- head -->
			<!-- content -->
			<div class="chat-widget-content position-relative bg-white p-0">
				<div class="chat-conversations js_scroller"></div>
				<div class="chat-to px-2 gap-2 position-absolute bg-white d-flex align-items-start js_autocomplete-tags">
					<div class="to flex-0 py-1 small">{__("To")}:</div>
					<div class="flex-1 d-flex align-items-center flex-wrap">
						<ul class="tags"></ul>
						<div class="typeahead">
							<input type="text" size="1" autofocus>
						</div>
					</div>
				</div>
				
				<div class="chat-voice-notes bg-white">
					<div class="voice-recording-wrapper p-2" data-handle="chat">
						<!-- processing message -->
						<div class="x-hidden small fw-medium js_voice-processing-message">
							<svg xmlns="http://www.w3.org/2000/svg" height="20" viewBox="0 0 24 24" width="20"><path d="M0 0h24v24H0V0z" fill="none"></path><path fill="#ef4c5d" d="M8 18c.55 0 1-.45 1-1V7c0-.55-.45-1-1-1s-1 .45-1 1v10c0 .55.45 1 1 1zm4 4c.55 0 1-.45 1-1V3c0-.55-.45-1-1-1s-1 .45-1 1v18c0 .55.45 1 1 1zm-8-8c.55 0 1-.45 1-1v-2c0-.55-.45-1-1-1s-1 .45-1 1v2c0 .55.45 1 1 1zm12 4c.55 0 1-.45 1-1V7c0-.55-.45-1-1-1s-1 .45-1 1v10c0 .55.45 1 1 1zm3-7v2c0 .55.45 1 1 1s1-.45 1-1v-2c0-.55-.45-1-1-1s-1 .45-1 1z"></path></svg> {__("Processing")} <span class="loading-dots"></span>
						</div>
						<!-- processing message -->

						<!-- success message -->
						<div class="x-hidden js_voice-success-message">
							<div class="d-flex align-items-center justify-content-between gap-3">
								<div class="d-flex align-items-center small fw-medium gap-1">
									<svg xmlns="http://www.w3.org/2000/svg" height="20" viewBox="0 0 24 24" width="20" class="flex-0"><path d="M0 0h24v24H0V0z" fill="none"/><path fill="#1bc3bb" d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zM9.29 16.29L5.7 12.7c-.39-.39-.39-1.02 0-1.41.39-.39 1.02-.39 1.41 0L10 14.17l6.88-6.88c.39-.39 1.02-.39 1.41 0 .39.39.39 1.02 0 1.41l-7.59 7.59c-.38.39-1.02.39-1.41 0z"/></svg> {__("Voice note recorded successfully")}
								</div>
								<button type="button" class="btn btn-voice-clear js_voice-remove p-0 text-danger text-opacity-75 flex-0">
									<svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" clip-rule="evenodd" d="M19.5825 15.6564C19.5058 16.9096 19.4449 17.9041 19.3202 18.6984C19.1922 19.5131 18.9874 20.1915 18.5777 20.7849C18.2029 21.3278 17.7204 21.786 17.1608 22.1303C16.5491 22.5067 15.8661 22.6713 15.0531 22.75L8.92739 22.7499C8.1135 22.671 7.42972 22.5061 6.8176 22.129C6.25763 21.7841 5.77494 21.3251 5.40028 20.7813C4.99073 20.1869 4.78656 19.5075 4.65957 18.6917C4.53574 17.8962 4.47623 16.9003 4.40122 15.6453L3.75 4.75H20.25L19.5825 15.6564ZM9.5 17.9609C9.08579 17.9609 8.75 17.6252 8.75 17.2109L8.75 11.2109C8.75 10.7967 9.08579 10.4609 9.5 10.4609C9.91421 10.4609 10.25 10.7967 10.25 11.2109L10.25 17.2109C10.25 17.6252 9.91421 17.9609 9.5 17.9609ZM15.25 11.2109C15.25 10.7967 14.9142 10.4609 14.5 10.4609C14.0858 10.4609 13.75 10.7967 13.75 11.2109V17.2109C13.75 17.6252 14.0858 17.9609 14.5 17.9609C14.9142 17.9609 15.25 17.6252 15.25 17.2109V11.2109Z" fill="currentColor"/><path fill-rule="evenodd" clip-rule="evenodd" d="M13.3473 1.28277C13.9124 1.33331 14.4435 1.50576 14.8996 1.84591C15.2369 2.09748 15.4712 2.40542 15.6714 2.73893C15.8569 3.04798 16.0437 3.4333 16.2555 3.8704L16.6823 4.7507H21C21.5523 4.7507 22 5.19842 22 5.7507C22 6.30299 21.5523 6.7507 21 6.7507C14.9998 6.7507 9.00019 6.7507 3 6.7507C2.44772 6.7507 2 6.30299 2 5.7507C2 5.19842 2.44772 4.7507 3 4.7507H7.40976L7.76556 3.97016C7.97212 3.51696 8.15403 3.11782 8.33676 2.79754C8.53387 2.45207 8.76721 2.13237 9.10861 1.87046C9.57032 1.51626 10.1121 1.33669 10.6899 1.28409C11.1249 1.24449 11.5634 1.24994 12 1.25064C12.5108 1.25146 12.97 1.24902 13.3473 1.28277ZM9.60776 4.7507H14.4597C14.233 4.28331 14.088 3.98707 13.9566 3.7682C13.7643 3.44787 13.5339 3.30745 13.1691 3.27482C12.9098 3.25163 12.5719 3.2507 12.0345 3.2507C11.4837 3.2507 11.137 3.25166 10.8712 3.27585C10.4971 3.30991 10.2639 3.45568 10.0739 3.78866C9.94941 4.00687 9.81387 4.29897 9.60776 4.7507Z" fill="currentColor"/></svg>
								</button>
							</div>
						</div>
						<!-- success message -->

						<!-- start recording -->
						<div class="btn btn-voice-start btn-main btn-sm js_voice-start">
							<svg xmlns="http://www.w3.org/2000/svg" height="16" viewBox="0 0 24 24" width="16"><path fill="currentColor" d="M12 14c1.66 0 3-1.34 3-3V5c0-1.66-1.34-3-3-3S9 3.34 9 5v6c0 1.66 1.34 3 3 3zm5.91-3c-.49 0-.9.36-.98.85C16.52 14.2 14.47 16 12 16s-4.52-1.8-4.93-4.15c-.08-.49-.49-.85-.98-.85-.61 0-1.09.54-1 1.14.49 3 2.89 5.35 5.91 5.78V20c0 .55.45 1 1 1s1-.45 1-1v-2.08c3.02-.43 5.42-2.78 5.91-5.78.1-.6-.39-1.14-1-1.14z"></path></svg> {__("Record")}
						</div>
						<!-- start recording -->

						<!-- stop recording -->
						<div class="btn btn-voice-stop btn-danger btn-sm js_voice-stop" style="display: none">
							<svg xmlns="http://www.w3.org/2000/svg" height="18" viewBox="0 0 24 24" width="18"><path fill="currentColor" d="M8 6h8c1.1 0 2 .9 2 2v8c0 1.1-.9 2-2 2H8c-1.1 0-2-.9-2-2V8c0-1.1.9-2 2-2z"></path></svg> {__("Recording")} <span class="js_voice-timer">00:00</span>
						</div>
						<!-- stop recording -->
					</div>
				</div>
				
				<div class="chat-attachments attachments p-2 bg-white clearfix x-hidden">
					<ul>
						<li class="loading">
							<div class="progress x-progress">
								<div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
							</div>
						</li>
					</ul>
				</div>
				<div class="x-form chat-form bg-white p-2 invisible">
					<div class="chat-form-message">
						<textarea class="pt-2 px-3 w-100 m-0 shadow-none border-0 d-block js_autosize js_post-message" dir="auto" rows="1" placeholder='{__("Write a message")}'></textarea>
					</div>
					<ul class="x-form-tools d-flex align-items-center gap-2 pt-2">
						{if $system['chat_photos_enabled']}
							<li class="x-form-tools-attach lh-1">
								<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none" class="js_x-uploader" data-handle="chat"><path d="M2.5 12C2.5 7.52166 2.5 5.28249 3.89124 3.89124C5.28249 2.5 7.52166 2.5 12 2.5C16.4783 2.5 18.7175 2.5 20.1088 3.89124C21.5 5.28249 21.5 7.52166 21.5 12C21.5 16.4783 21.5 18.7175 20.1088 20.1088C18.7175 21.5 16.4783 21.5 12 21.5C7.52166 21.5 5.28249 21.5 3.89124 20.1088C2.5 18.7175 2.5 16.4783 2.5 12Z" stroke="currentColor" stroke-width="1.75"></path><circle cx="16.5" cy="7.5" r="1.5" stroke="currentColor" stroke-width="1.75"></circle><path d="M16 22C15.3805 19.7749 13.9345 17.7821 11.8765 16.3342C9.65761 14.7729 6.87163 13.9466 4.01569 14.0027C3.67658 14.0019 3.33776 14.0127 3 14.0351" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round"></path><path d="M13 18C14.7015 16.6733 16.5345 15.9928 18.3862 16.0001C19.4362 15.999 20.4812 16.2216 21.5 16.6617" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round"></path></svg>
							</li>
						{/if}
						{if $system['voice_notes_chat_enabled']}
							<li class="x-form-tools-voice lh-1 js_chat-voice-notes-toggle">
								<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M17 7V11C17 13.7614 14.7614 16 12 16C9.23858 16 7 13.7614 7 11V7C7 4.23858 9.23858 2 12 2C14.7614 2 17 4.23858 17 7Z" stroke="currentColor" stroke-width="1.75"></path><path d="M17 7H14M17 11H14" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"></path><path d="M20 11C20 15.4183 16.4183 19 12 19M12 19C7.58172 19 4 15.4183 4 11M12 19V22M12 22H15M12 22H9" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"></path></svg>
							</li>
						{/if}
						<li class="x-form-tools-emoji lh-1 js_emoji-menu-toggle">
							<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" stroke-width="1.75" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round"> <path stroke="none" d="M0 0h24v24H0z" fill="none"></path> <circle cx="12" cy="12" r="9"></circle> <line x1="9" y1="10" x2="9.01" y2="10"></line> <line x1="15" y1="10" x2="15.01" y2="10"></line> <path d="M9.5 15a3.5 3.5 0 0 0 5 0"></path></svg>
						</li>
					</ul>
				</div>
			</div>
			<!-- content -->
		</div>
    </script>

    <script id="chat-box" type="text/template">
		<div class="chat-widget chat-box opened" id="{literal}{{chat_key_value}}{/literal}" {literal}{{#conversation_id}}{/literal}data-cid="{literal}{{conversation_id}}{/literal}" {literal}{{/conversation_id}}{/literal} {literal}{{#user_id}}{/literal}data-uid="{literal}{{user_id}}{/literal}" {literal}{{/user_id}}{/literal}>
			<!-- head -->
			<div class="chat-widget-head bg-white w-100 d-flex align-items-center justify-content-between pointer x_user_info">
				<!-- label -->
				<div class="chat-head-label"><span class="badge rounded-pill bg-danger js_chat-box-label"></span></div>
				<!-- label -->
          
				<!-- user-card -->
				<a class="chat-user-card gap-2 d-flex align-items-center position-relative mw-0 body-color" href="{$system['system_url']}/{literal}{{link}}{/literal}" title="{literal}{{name_list}}{/literal}">
					{literal}{{^multiple}}{/literal}
					<div class="avatar flex-0 position-relative rounded-circle">
						<img class="w-100 h-100 rounded-circle" src="{literal}{{picture}}{/literal}">
						<span class="online-dot position-absolute rounded-circle offline js_chat-box-status"></span>
					</div>
					{literal}{{/multiple}}{/literal}
					<div class="name fw-medium mw-0 text-truncate">
						<span>{literal}{{name}}{/literal}</span>
					</div>
				</a>
				<!-- user-card -->
          
				<!-- buttons-->
				<div class="chat-head-btns flex-0 d-flex align-items-center gap-1">
					<!-- video/audio calls (not multiple) -->
					{literal}{{^multiple}}{/literal}
						{if $system['audio_call_enabled'] && $user->_data['can_start_audio_call']}
							<span class="chat-head-btn lh-1 js_chat-call-start pointer" data-type="audio" data-uid="{literal}{{user_id}}{/literal}" data-name="{literal}{{name_list}}{/literal}" data-picture="{literal}{{picture}}{/literal}">
								<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M9.1585 5.71223L8.75584 4.80625C8.49256 4.21388 8.36092 3.91768 8.16405 3.69101C7.91732 3.40694 7.59571 3.19794 7.23592 3.08785C6.94883 3 6.6247 3 5.97645 3C5.02815 3 4.554 3 4.15597 3.18229C3.68711 3.39702 3.26368 3.86328 3.09497 4.3506C2.95175 4.76429 2.99278 5.18943 3.07482 6.0397C3.94815 15.0902 8.91006 20.0521 17.9605 20.9254C18.8108 21.0075 19.236 21.0485 19.6496 20.9053C20.137 20.7366 20.6032 20.3131 20.818 19.8443C21.0002 19.4462 21.0002 18.9721 21.0002 18.0238C21.0002 17.3755 21.0002 17.0514 20.9124 16.7643C20.8023 16.4045 20.5933 16.0829 20.3092 15.8362C20.0826 15.6393 19.7864 15.5077 19.194 15.2444L18.288 14.8417C17.6465 14.5566 17.3257 14.4141 16.9998 14.3831C16.6878 14.3534 16.3733 14.3972 16.0813 14.5109C15.7762 14.6297 15.5066 14.8544 14.9672 15.3038C14.4304 15.7512 14.162 15.9749 13.834 16.0947C13.5432 16.2009 13.1588 16.2403 12.8526 16.1951C12.5071 16.1442 12.2426 16.0029 11.7135 15.7201C10.0675 14.8405 9.15977 13.9328 8.28011 12.2867C7.99738 11.7577 7.85602 11.4931 7.80511 11.1477C7.75998 10.8414 7.79932 10.457 7.90554 10.1663C8.02536 9.83828 8.24905 9.56986 8.69643 9.033C9.14586 8.49368 9.37058 8.22402 9.48939 7.91891C9.60309 7.62694 9.64686 7.3124 9.61719 7.00048C9.58618 6.67452 9.44362 6.35376 9.1585 5.71223Z" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" /></svg>
							</span>
						{/if}
						{if $system['video_call_enabled'] && $user->_data['can_start_video_call']}
							<span class="chat-head-btn lh-1 js_chat-call-start pointer" data-type="video" data-uid="{literal}{{user_id}}{/literal}" data-name="{literal}{{name_list}}{/literal}" data-picture="{literal}{{picture}}{/literal}">
								<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M2 11C2 7.70017 2 6.05025 3.02513 5.02513C4.05025 4 5.70017 4 9 4H10C13.2998 4 14.9497 4 15.9749 5.02513C17 6.05025 17 7.70017 17 11V13C17 16.2998 17 17.9497 15.9749 18.9749C14.9497 20 13.2998 20 10 20H9C5.70017 20 4.05025 20 3.02513 18.9749C2 17.9497 2 16.2998 2 13V11Z" stroke="currentColor" stroke-width="1.5" /><path d="M17 8.90585L17.1259 8.80196C19.2417 7.05623 20.2996 6.18336 21.1498 6.60482C22 7.02628 22 8.42355 22 11.2181V12.7819C22 15.5765 22 16.9737 21.1498 17.3952C20.2996 17.8166 19.2417 16.9438 17.1259 15.198L17 15.0941" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" /><circle cx="11.5" cy="9.5" r="1.5" stroke="currentColor" stroke-width="1.5" /></svg>
							</span>
						{/if}
					{literal}{{/multiple}}{/literal}
					<!-- video/audio calls (not multiple) -->
					<span class="chat-head-btn lh-1 js_chat-box-close pointer">
						<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M19.0005 4.99988L5.00049 18.9999M5.00049 4.99988L19.0005 18.9999" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" /></svg>
					</span>
				</div>
				<!-- buttons-->
			</div>
			<!-- head -->
			<!-- content -->
			<div class="chat-widget-content position-relative bg-white p-0">
				<div class="chat-conversations js_scroller">
					<ul></ul>
				</div>
				<div class="chat-typing p-2">
					<div class="d-flex align-items-center gap-2 small text-muted">
						<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="16" height="16" color="currentColor" fill="none" class="flex-0"><path d="M8 13.5H16M8 8.5H12" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" /><path d="M6.09881 19C4.7987 18.8721 3.82475 18.4816 3.17157 17.8284C2 16.6569 2 14.7712 2 11V10.5C2 6.72876 2 4.84315 3.17157 3.67157C4.34315 2.5 6.22876 2.5 10 2.5H14C17.7712 2.5 19.6569 2.5 20.8284 3.67157C22 4.84315 22 6.72876 22 10.5V11C22 14.7712 22 16.6569 20.8284 17.8284C19.6569 19 17.7712 19 14 19C13.4395 19.0125 12.9931 19.0551 12.5546 19.155C11.3562 19.4309 10.2465 20.0441 9.14987 20.5789C7.58729 21.3408 6.806 21.7218 6.31569 21.3651C5.37769 20.6665 6.29454 18.5019 6.5 17.5" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" /></svg>
						<span class="loading-dots"><span class="js_chat-typing-users"></span> {__("Typing")}</span>
					</div>
				</div>
				<div class="chat-voice-notes bg-white">
					<div class="voice-recording-wrapper p-2" data-handle="chat">
						<!-- processing message -->
						<div class="x-hidden small fw-medium js_voice-processing-message">
							<svg xmlns="http://www.w3.org/2000/svg" height="20" viewBox="0 0 24 24" width="20"><path d="M0 0h24v24H0V0z" fill="none"></path><path fill="#ef4c5d" d="M8 18c.55 0 1-.45 1-1V7c0-.55-.45-1-1-1s-1 .45-1 1v10c0 .55.45 1 1 1zm4 4c.55 0 1-.45 1-1V3c0-.55-.45-1-1-1s-1 .45-1 1v18c0 .55.45 1 1 1zm-8-8c.55 0 1-.45 1-1v-2c0-.55-.45-1-1-1s-1 .45-1 1v2c0 .55.45 1 1 1zm12 4c.55 0 1-.45 1-1V7c0-.55-.45-1-1-1s-1 .45-1 1v10c0 .55.45 1 1 1zm3-7v2c0 .55.45 1 1 1s1-.45 1-1v-2c0-.55-.45-1-1-1s-1 .45-1 1z"></path></svg> {__("Processing")} <span class="loading-dots"></span>
						</div>
						<!-- processing message -->

						<!-- success message -->
						<div class="x-hidden js_voice-success-message">
							<div class="d-flex align-items-center justify-content-between gap-3">
								<div class="d-flex align-items-center small fw-medium gap-1">
									<svg xmlns="http://www.w3.org/2000/svg" height="20" viewBox="0 0 24 24" width="20" class="flex-0"><path d="M0 0h24v24H0V0z" fill="none"/><path fill="#1bc3bb" d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zM9.29 16.29L5.7 12.7c-.39-.39-.39-1.02 0-1.41.39-.39 1.02-.39 1.41 0L10 14.17l6.88-6.88c.39-.39 1.02-.39 1.41 0 .39.39.39 1.02 0 1.41l-7.59 7.59c-.38.39-1.02.39-1.41 0z"/></svg> {__("Voice note recorded successfully")}
								</div>
								<button type="button" class="btn btn-voice-clear js_voice-remove p-0 text-danger text-opacity-75 flex-0">
									<svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" clip-rule="evenodd" d="M19.5825 15.6564C19.5058 16.9096 19.4449 17.9041 19.3202 18.6984C19.1922 19.5131 18.9874 20.1915 18.5777 20.7849C18.2029 21.3278 17.7204 21.786 17.1608 22.1303C16.5491 22.5067 15.8661 22.6713 15.0531 22.75L8.92739 22.7499C8.1135 22.671 7.42972 22.5061 6.8176 22.129C6.25763 21.7841 5.77494 21.3251 5.40028 20.7813C4.99073 20.1869 4.78656 19.5075 4.65957 18.6917C4.53574 17.8962 4.47623 16.9003 4.40122 15.6453L3.75 4.75H20.25L19.5825 15.6564ZM9.5 17.9609C9.08579 17.9609 8.75 17.6252 8.75 17.2109L8.75 11.2109C8.75 10.7967 9.08579 10.4609 9.5 10.4609C9.91421 10.4609 10.25 10.7967 10.25 11.2109L10.25 17.2109C10.25 17.6252 9.91421 17.9609 9.5 17.9609ZM15.25 11.2109C15.25 10.7967 14.9142 10.4609 14.5 10.4609C14.0858 10.4609 13.75 10.7967 13.75 11.2109V17.2109C13.75 17.6252 14.0858 17.9609 14.5 17.9609C14.9142 17.9609 15.25 17.6252 15.25 17.2109V11.2109Z" fill="currentColor"/><path fill-rule="evenodd" clip-rule="evenodd" d="M13.3473 1.28277C13.9124 1.33331 14.4435 1.50576 14.8996 1.84591C15.2369 2.09748 15.4712 2.40542 15.6714 2.73893C15.8569 3.04798 16.0437 3.4333 16.2555 3.8704L16.6823 4.7507H21C21.5523 4.7507 22 5.19842 22 5.7507C22 6.30299 21.5523 6.7507 21 6.7507C14.9998 6.7507 9.00019 6.7507 3 6.7507C2.44772 6.7507 2 6.30299 2 5.7507C2 5.19842 2.44772 4.7507 3 4.7507H7.40976L7.76556 3.97016C7.97212 3.51696 8.15403 3.11782 8.33676 2.79754C8.53387 2.45207 8.76721 2.13237 9.10861 1.87046C9.57032 1.51626 10.1121 1.33669 10.6899 1.28409C11.1249 1.24449 11.5634 1.24994 12 1.25064C12.5108 1.25146 12.97 1.24902 13.3473 1.28277ZM9.60776 4.7507H14.4597C14.233 4.28331 14.088 3.98707 13.9566 3.7682C13.7643 3.44787 13.5339 3.30745 13.1691 3.27482C12.9098 3.25163 12.5719 3.2507 12.0345 3.2507C11.4837 3.2507 11.137 3.25166 10.8712 3.27585C10.4971 3.30991 10.2639 3.45568 10.0739 3.78866C9.94941 4.00687 9.81387 4.29897 9.60776 4.7507Z" fill="currentColor"/></svg>
								</button>
							</div>
						</div>
						<!-- success message -->

						<!-- start recording -->
						<div class="btn btn-voice-start btn-main btn-sm js_voice-start">
							<svg xmlns="http://www.w3.org/2000/svg" height="16" viewBox="0 0 24 24" width="16"><path fill="currentColor" d="M12 14c1.66 0 3-1.34 3-3V5c0-1.66-1.34-3-3-3S9 3.34 9 5v6c0 1.66 1.34 3 3 3zm5.91-3c-.49 0-.9.36-.98.85C16.52 14.2 14.47 16 12 16s-4.52-1.8-4.93-4.15c-.08-.49-.49-.85-.98-.85-.61 0-1.09.54-1 1.14.49 3 2.89 5.35 5.91 5.78V20c0 .55.45 1 1 1s1-.45 1-1v-2.08c3.02-.43 5.42-2.78 5.91-5.78.1-.6-.39-1.14-1-1.14z"></path></svg> {__("Record")}
						</div>
						<!-- start recording -->

						<!-- stop recording -->
						<div class="btn btn-voice-stop btn-danger btn-sm js_voice-stop" style="display: none">
							<svg xmlns="http://www.w3.org/2000/svg" height="18" viewBox="0 0 24 24" width="18"><path fill="currentColor" d="M8 6h8c1.1 0 2 .9 2 2v8c0 1.1-.9 2-2 2H8c-1.1 0-2-.9-2-2V8c0-1.1.9-2 2-2z"></path></svg> {__("Recording")} <span class="js_voice-timer">00:00</span>
						</div>
						<!-- stop recording -->
					</div>
				</div>
				<div class="chat-attachments p-2 bg-white attachments clearfix x-hidden">
					<ul>
						<li class="loading">
							<div class="progress x-progress">
								<div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
							</div>
						</li>
					</ul>
				</div>
				<div class="x-form chat-form bg-white p-2">
					<div class="chat-form-message">
						<textarea class="pt-2 px-3 w-100 m-0 shadow-none border-0 d-block js_autosize js_post-message" dir="auto" rows="1" placeholder='{__("Write a message")}'></textarea>
					</div>
					<ul class="x-form-tools d-flex align-items-center gap-2 pt-2">
						{if $system['chat_photos_enabled']}
							<li class="x-form-tools-attach lh-1">
								<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none" class="js_x-uploader" data-handle="chat"><path d="M2.5 12C2.5 7.52166 2.5 5.28249 3.89124 3.89124C5.28249 2.5 7.52166 2.5 12 2.5C16.4783 2.5 18.7175 2.5 20.1088 3.89124C21.5 5.28249 21.5 7.52166 21.5 12C21.5 16.4783 21.5 18.7175 20.1088 20.1088C18.7175 21.5 16.4783 21.5 12 21.5C7.52166 21.5 5.28249 21.5 3.89124 20.1088C2.5 18.7175 2.5 16.4783 2.5 12Z" stroke="currentColor" stroke-width="1.75"></path><circle cx="16.5" cy="7.5" r="1.5" stroke="currentColor" stroke-width="1.75"></circle><path d="M16 22C15.3805 19.7749 13.9345 17.7821 11.8765 16.3342C9.65761 14.7729 6.87163 13.9466 4.01569 14.0027C3.67658 14.0019 3.33776 14.0127 3 14.0351" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round"></path><path d="M13 18C14.7015 16.6733 16.5345 15.9928 18.3862 16.0001C19.4362 15.999 20.4812 16.2216 21.5 16.6617" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round"></path></svg>
							</li>
						{/if}
						{if $system['voice_notes_chat_enabled']}
							<li class="x-form-tools-voice js_chat-voice-notes-toggle lh-1">
								<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none"><path d="M17 7V11C17 13.7614 14.7614 16 12 16C9.23858 16 7 13.7614 7 11V7C7 4.23858 9.23858 2 12 2C14.7614 2 17 4.23858 17 7Z" stroke="currentColor" stroke-width="1.75"></path><path d="M17 7H14M17 11H14" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"></path><path d="M20 11C20 15.4183 16.4183 19 12 19M12 19C7.58172 19 4 15.4183 4 11M12 19V22M12 22H15M12 22H9" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"></path></svg>
							</li>
						{/if}
						<li class="x-form-tools-emoji js_emoji-menu-toggle lh-1">
							<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" stroke-width="1.75" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round"> <path stroke="none" d="M0 0h24v24H0z" fill="none"></path> <circle cx="12" cy="12" r="9"></circle> <line x1="9" y1="10" x2="9.01" y2="10"></line> <line x1="15" y1="10" x2="15.01" y2="10"></line> <path d="M9.5 15a3.5 3.5 0 0 0 5 0"></path></svg>
						</li>
						<li class="x-form-tools-colors js_chat-colors-menu-toggle lh-1 main pointer js_chat-color-me {literal}{{^conversation_id}}{/literal}x-hidden{literal}{{/conversation_id}}{/literal}">
							<i class="fa fa-circle fa-lg fa-fw"></i>
						</li>
					</ul>
				</div>
			</div>
			<!-- content -->
		</div>
    </script>

    <script id="chat-message" type="text/template">
		<li>
			<div class="conversation clearfix d-flex align-items-start py-1 gap-1 flex-wrap position-relative w-100 right justify-content-end" id="{literal}{{id}}{/literal}">
				<div class="conversation-body position-relative d-flex flex-column align-items-end">
					<div class="text js_chat-color-me" {literal}{{#color}}{/literal}style="background-color: {literal}{{color}}{/literal}" {literal}{{/color}}{/literal}>{literal}{{{message}}}{/literal}</div>

					{literal}{{#image}}{/literal}
						<span class="main pointer js_lightbox-nodata {literal}{{#message}}{/literal}mt5{literal}{{/message}}{/literal}" data-image="{$system['system_uploads']}/{literal}{{image}}{/literal}">
							<img alt="" class="img-fluid" src="{$system['system_uploads']}/{literal}{{image}}{/literal}">
						</span>
					{literal}{{/image}}{/literal}

					{literal}{{#voice_note}}{/literal}
						<audio class="js_audio w-100" id="audio-{literal}{{id}}{/literal}" controls preload="auto" style="min-width: 220px;">
							<source src="{$system['system_uploads']}/{literal}{{voice_note}}{/literal}" type="audio/mpeg">
							<source src="{$system['system_uploads']}/{literal}{{voice_note}}{/literal}" type="audio/mp3">
							{__("Your browser does not support HTML5 audio")}
						</audio>
					{literal}{{/voice_note}}{/literal}
					
					<div class="time js_moment" data-time="{literal}{{time}}{/literal}">
						{literal}{{time}}{/literal}
					</div>
				</div>
			</div>
		</li>
    </script>

    <script id="chat-calling" type="text/template">
		<div class="modal-header border-0">
			<h6 class="modal-title">
				{literal}{{#is_video}}{/literal}{include file='__svg_icons.tpl' icon="call_video" class="main-icon mr10" width="24px" height="24px"}{literal}{{/is_video}}{/literal}
				{literal}{{#is_audio}}{/literal}{include file='__svg_icons.tpl' icon="call_audio" class="main-icon mr10" width="24px" height="24px"}{literal}{{/is_audio}}{/literal}
				{__("Outgoing call")}
			</h6>
		</div>
		<div class="modal-body text-center">
			<div class="position-relative mb10">
				<div class="profile-avatar-wrapper static m-0 mx-auto">
					<img src="{literal}{{picture}}{/literal}" alt="{literal}{{name}}{/literal}">
				</div>
			</div>
			<h3>{literal}{{name}}{/literal}</h3>
			<p class="text-md js_chat-calling-message">{__("Connecting")}<span class="loading-dots"></span></p>

			<div class="video-call-stream-wrapper position-relative rounded-2">
				<div class="video-call-stream"></div>
				<div class="video-call-stream-local"></div>
			</div>

			<div class="mt-5 d-flex align-items-center gap-3 justify-content-center">
				<button type="button" class="btn btn-light x-hidden js_chat-call-close" data-bs-dismiss="modal">{__("Close")}</button>
				<button type="button" class="btn p-3 lh-1 btn-danger x-hidden js_chat-call-cancel" data-bs-dismiss="modal">
					<svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M8.12296 12.3415C8.04005 12.2058 7.95842 12.0666 7.87787 11.9238C7.57805 11.3922 7.42815 11.1265 7.37245 10.7648C7.31825 10.4129 7.38061 9.95699 7.52731 9.63257C7.67806 9.29918 7.93406 9.04318 8.44605 8.5312C8.96646 8.01078 9.22668 7.75057 9.37427 7.44592C9.53126 7.12186 9.59817 6.76154 9.56797 6.40272C9.53957 6.0654 9.39012 5.72912 9.09121 5.05658L8.83795 4.48675C8.49683 3.71921 8.32626 3.33544 8.04556 3.06418C7.86027 2.88512 7.64223 2.74342 7.40335 2.64682C7.04146 2.50049 6.6215 2.50049 5.78157 2.50049C4.53091 2.50049 3.90558 2.50049 3.41836 2.80412C3.11954 2.99034 2.83374 3.3065 2.67852 3.62255C2.42545 4.13784 2.48286 4.70556 2.59768 5.841C2.9658 9.48148 3.96613 12.4898 5.59866 14.8658L8.12296 12.3415Z" fill="currentColor"/><path d="M7.20268 16.7978C9.79631 19.3914 13.4486 20.9264 18.1595 21.4028C19.2949 21.5176 19.8626 21.575 20.3779 21.322C20.694 21.1667 21.0101 20.8809 21.1964 20.5821C21.5 20.0949 21.5 19.4696 21.5 18.2189C21.5 17.379 21.5 16.959 21.3537 16.5971C21.2571 16.3583 21.1154 16.1402 20.9363 15.9549C20.665 15.6742 20.2813 15.5037 19.5137 15.1625L18.9439 14.9093C18.2714 14.6104 17.9351 14.4609 17.5978 14.4325C17.239 14.4023 16.8786 14.4692 16.5546 14.6262C16.2499 14.7738 15.9897 15.034 15.4693 15.5544C14.9573 16.0664 14.7013 16.3224 14.3679 16.4732C14.0435 16.6199 13.5876 16.6822 13.2357 16.628C12.874 16.5723 12.6082 16.4224 12.0767 16.1226C11.1344 15.5912 10.3505 15.0126 9.66918 14.3313L7.20268 16.7978Z" fill="currentColor"/><path fill-rule="evenodd" clip-rule="evenodd" d="M21.457 2.54323C21.0664 2.15258 20.433 2.15258 20.0423 2.54323L2.54299 20.0426C2.15234 20.4332 2.15234 21.0666 2.54299 21.4573C2.93364 21.8479 3.56701 21.8479 3.95766 21.4573L21.457 3.9579C21.8477 3.56725 21.8477 2.93388 21.457 2.54323Z" fill="currentColor"/></svg>
				</button>
				<button type="button" class="btn p-3 lh-1 btn-danger x-hidden js_chat-call-end" data-bs-dismiss="modal">
					<svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M8.12296 12.3415C8.04005 12.2058 7.95842 12.0666 7.87787 11.9238C7.57805 11.3922 7.42815 11.1265 7.37245 10.7648C7.31825 10.4129 7.38061 9.95699 7.52731 9.63257C7.67806 9.29918 7.93406 9.04318 8.44605 8.5312C8.96646 8.01078 9.22668 7.75057 9.37427 7.44592C9.53126 7.12186 9.59817 6.76154 9.56797 6.40272C9.53957 6.0654 9.39012 5.72912 9.09121 5.05658L8.83795 4.48675C8.49683 3.71921 8.32626 3.33544 8.04556 3.06418C7.86027 2.88512 7.64223 2.74342 7.40335 2.64682C7.04146 2.50049 6.6215 2.50049 5.78157 2.50049C4.53091 2.50049 3.90558 2.50049 3.41836 2.80412C3.11954 2.99034 2.83374 3.3065 2.67852 3.62255C2.42545 4.13784 2.48286 4.70556 2.59768 5.841C2.9658 9.48148 3.96613 12.4898 5.59866 14.8658L8.12296 12.3415Z" fill="currentColor"/><path d="M7.20268 16.7978C9.79631 19.3914 13.4486 20.9264 18.1595 21.4028C19.2949 21.5176 19.8626 21.575 20.3779 21.322C20.694 21.1667 21.0101 20.8809 21.1964 20.5821C21.5 20.0949 21.5 19.4696 21.5 18.2189C21.5 17.379 21.5 16.959 21.3537 16.5971C21.2571 16.3583 21.1154 16.1402 20.9363 15.9549C20.665 15.6742 20.2813 15.5037 19.5137 15.1625L18.9439 14.9093C18.2714 14.6104 17.9351 14.4609 17.5978 14.4325C17.239 14.4023 16.8786 14.4692 16.5546 14.6262C16.2499 14.7738 15.9897 15.034 15.4693 15.5544C14.9573 16.0664 14.7013 16.3224 14.3679 16.4732C14.0435 16.6199 13.5876 16.6822 13.2357 16.628C12.874 16.5723 12.6082 16.4224 12.0767 16.1226C11.1344 15.5912 10.3505 15.0126 9.66918 14.3313L7.20268 16.7978Z" fill="currentColor"/><path fill-rule="evenodd" clip-rule="evenodd" d="M21.457 2.54323C21.0664 2.15258 20.433 2.15258 20.0423 2.54323L2.54299 20.0426C2.15234 20.4332 2.15234 21.0666 2.54299 21.4573C2.93364 21.8479 3.56701 21.8479 3.95766 21.4573L21.457 3.9579C21.8477 3.56725 21.8477 2.93388 21.457 2.54323Z" fill="currentColor"/></svg>
				</button>
			</div>
		</div>
    </script>

    <script id="chat-ringing" type="text/template">
		<div class="modal-header border-0">
			<h6 class="modal-title">
				{literal}{{#is_video}}{/literal}{include file='__svg_icons.tpl' icon="call_video" class="main-icon mr10" width="24px" height="24px"}{literal}{{/is_video}}{/literal}
				{literal}{{#is_audio}}{/literal}{include file='__svg_icons.tpl' icon="call_audio" class="main-icon mr10" width="24px" height="24px"}{literal}{{/is_audio}}{/literal}
				{__("Incoming call")}
			</h6>
		</div>
		<div class="modal-body text-center">
			<div class="position-relative mb10">
				<div class="profile-avatar-wrapper static m-0 mx-auto">
					<img src="{literal}{{picture}}{/literal}" alt="{literal}{{name}}{/literal}">
				</div>
			</div>
			<h3>{literal}{{name}}{/literal}</h3>
			{literal}{{#is_video}}{/literal}<p class="text-md js_chat-calling-message">{__("Wants to have video call with you")}</p>{literal}{{/is_video}}{/literal}
			{literal}{{#is_audio}}{/literal}<p class="text-md js_chat-calling-message">{__("Wants to have audio call with you")}</p>{literal}{{/is_audio}}{/literal}

			<div class="video-call-stream-wrapper position-relative rounded-2">
				<div class="video-call-stream"></div>
				<div class="video-call-stream-local"></div>
			</div>

			<div class="mt-5 d-flex align-items-center gap-3 justify-content-center">
				<button type="submit" class="btn p-3 lh-1 btn-success js_chat-call-answer" data-id="{literal}{{id}}{/literal}">
					<svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M9.09133 5.05585L8.83808 4.48602C8.49695 3.71848 8.32638 3.33471 8.04568 3.06345C7.8604 2.88439 7.64236 2.74269 7.40348 2.64609C7.04159 2.49976 6.62162 2.49976 5.78169 2.49976C4.53103 2.49976 3.90571 2.49976 3.41849 2.80339C3.11966 2.98961 2.83386 3.30577 2.67865 3.62181C2.42557 4.13711 2.48298 4.70483 2.5978 5.84027C3.55053 15.2621 8.7378 20.4493 18.1596 21.4021C19.295 21.5169 19.8628 21.5743 20.3781 21.3212C20.6941 21.166 21.0103 20.8802 21.1965 20.5814C21.5001 20.0942 21.5001 19.4688 21.5001 18.2182C21.5001 17.3783 21.5001 16.9583 21.3538 16.5964C21.2572 16.3575 21.1155 16.1395 20.9364 15.9542C20.6652 15.6735 20.2814 15.5029 19.5139 15.1618L18.944 14.9085C18.2715 14.6096 17.9352 14.4602 17.5979 14.4318C17.2391 14.4016 16.8787 14.4685 16.5547 14.6255C16.25 14.7731 15.9898 15.0333 15.4694 15.5537C14.9574 16.0657 14.7014 16.3217 14.368 16.4724C14.0436 16.6191 13.5877 16.6815 13.2358 16.6273C12.8742 16.5716 12.6084 16.4217 12.0768 16.1219C10.1923 15.059 8.94086 13.8075 7.87799 11.9231C7.57818 11.3915 7.42827 11.1257 7.37257 10.7641C7.31837 10.4122 7.38073 9.95626 7.52743 9.63184C7.67819 9.29845 7.93418 9.04245 8.44618 8.53046C8.96659 8.01004 9.2268 7.74984 9.37439 7.44518C9.53139 7.12113 9.59829 6.7608 9.56809 6.40199C9.5397 6.06467 9.39024 5.72839 9.09133 5.05585Z" fill="currentColor"/></svg>
				</button>
				<button type="button" class="btn p-3 lh-1 btn-danger js_chat-call-decline" data-id="{literal}{{id}}{/literal}" data-bs-dismiss="modal">
					<svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M8.12296 12.3415C8.04005 12.2058 7.95842 12.0666 7.87787 11.9238C7.57805 11.3922 7.42815 11.1265 7.37245 10.7648C7.31825 10.4129 7.38061 9.95699 7.52731 9.63257C7.67806 9.29918 7.93406 9.04318 8.44605 8.5312C8.96646 8.01078 9.22668 7.75057 9.37427 7.44592C9.53126 7.12186 9.59817 6.76154 9.56797 6.40272C9.53957 6.0654 9.39012 5.72912 9.09121 5.05658L8.83795 4.48675C8.49683 3.71921 8.32626 3.33544 8.04556 3.06418C7.86027 2.88512 7.64223 2.74342 7.40335 2.64682C7.04146 2.50049 6.6215 2.50049 5.78157 2.50049C4.53091 2.50049 3.90558 2.50049 3.41836 2.80412C3.11954 2.99034 2.83374 3.3065 2.67852 3.62255C2.42545 4.13784 2.48286 4.70556 2.59768 5.841C2.9658 9.48148 3.96613 12.4898 5.59866 14.8658L8.12296 12.3415Z" fill="currentColor"/><path d="M7.20268 16.7978C9.79631 19.3914 13.4486 20.9264 18.1595 21.4028C19.2949 21.5176 19.8626 21.575 20.3779 21.322C20.694 21.1667 21.0101 20.8809 21.1964 20.5821C21.5 20.0949 21.5 19.4696 21.5 18.2189C21.5 17.379 21.5 16.959 21.3537 16.5971C21.2571 16.3583 21.1154 16.1402 20.9363 15.9549C20.665 15.6742 20.2813 15.5037 19.5137 15.1625L18.9439 14.9093C18.2714 14.6104 17.9351 14.4609 17.5978 14.4325C17.239 14.4023 16.8786 14.4692 16.5546 14.6262C16.2499 14.7738 15.9897 15.034 15.4693 15.5544C14.9573 16.0664 14.7013 16.3224 14.3679 16.4732C14.0435 16.6199 13.5876 16.6822 13.2357 16.628C12.874 16.5723 12.6082 16.4224 12.0767 16.1226C11.1344 15.5912 10.3505 15.0126 9.66918 14.3313L7.20268 16.7978Z" fill="currentColor"/><path fill-rule="evenodd" clip-rule="evenodd" d="M21.457 2.54323C21.0664 2.15258 20.433 2.15258 20.0423 2.54323L2.54299 20.0426C2.15234 20.4332 2.15234 21.0666 2.54299 21.4573C2.93364 21.8479 3.56701 21.8479 3.95766 21.4573L21.457 3.9579C21.8477 3.56725 21.8477 2.93388 21.457 2.54323Z" fill="currentColor"/></svg>
				</button>
				<button type="button" class="btn p-3 lh-1 btn-danger x-hidden js_chat-call-end" data-id="{literal}{{id}}{/literal}" data-bs-dismiss="modal">
					<svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M8.12296 12.3415C8.04005 12.2058 7.95842 12.0666 7.87787 11.9238C7.57805 11.3922 7.42815 11.1265 7.37245 10.7648C7.31825 10.4129 7.38061 9.95699 7.52731 9.63257C7.67806 9.29918 7.93406 9.04318 8.44605 8.5312C8.96646 8.01078 9.22668 7.75057 9.37427 7.44592C9.53126 7.12186 9.59817 6.76154 9.56797 6.40272C9.53957 6.0654 9.39012 5.72912 9.09121 5.05658L8.83795 4.48675C8.49683 3.71921 8.32626 3.33544 8.04556 3.06418C7.86027 2.88512 7.64223 2.74342 7.40335 2.64682C7.04146 2.50049 6.6215 2.50049 5.78157 2.50049C4.53091 2.50049 3.90558 2.50049 3.41836 2.80412C3.11954 2.99034 2.83374 3.3065 2.67852 3.62255C2.42545 4.13784 2.48286 4.70556 2.59768 5.841C2.9658 9.48148 3.96613 12.4898 5.59866 14.8658L8.12296 12.3415Z" fill="currentColor"/><path d="M7.20268 16.7978C9.79631 19.3914 13.4486 20.9264 18.1595 21.4028C19.2949 21.5176 19.8626 21.575 20.3779 21.322C20.694 21.1667 21.0101 20.8809 21.1964 20.5821C21.5 20.0949 21.5 19.4696 21.5 18.2189C21.5 17.379 21.5 16.959 21.3537 16.5971C21.2571 16.3583 21.1154 16.1402 20.9363 15.9549C20.665 15.6742 20.2813 15.5037 19.5137 15.1625L18.9439 14.9093C18.2714 14.6104 17.9351 14.4609 17.5978 14.4325C17.239 14.4023 16.8786 14.4692 16.5546 14.6262C16.2499 14.7738 15.9897 15.034 15.4693 15.5544C14.9573 16.0664 14.7013 16.3224 14.3679 16.4732C14.0435 16.6199 13.5876 16.6822 13.2357 16.628C12.874 16.5723 12.6082 16.4224 12.0767 16.1226C11.1344 15.5912 10.3505 15.0126 9.66918 14.3313L7.20268 16.7978Z" fill="currentColor"/><path fill-rule="evenodd" clip-rule="evenodd" d="M21.457 2.54323C21.0664 2.15258 20.433 2.15258 20.0423 2.54323L2.54299 20.0426C2.15234 20.4332 2.15234 21.0666 2.54299 21.4573C2.93364 21.8479 3.56701 21.8479 3.95766 21.4573L21.457 3.9579C21.8477 3.56725 21.8477 2.93388 21.457 2.54323Z" fill="currentColor"/></svg>
				</button>
			</div>
		</div>
    </script>

    <script id="chat-colors-menu" type="text/template">
      <div class="chat-colors-menu">
        <div class="js_scroller" data-slimScroll-height="180">
          <div class="item js_chat-color" data-color="#5e72e4" style="color: #5e72e4;">
            <i class="fa fa-circle fa-2x"></i>
          </div>
          <div class="item js_chat-color" data-color="#0ba05d" style="color: #0ba05d;">
            <i class="fa fa-circle fa-2x"></i>
          </div>
          <div class="item js_chat-color" data-color="#ed9e6a" style="color: #ed9e6a;">
            <i class="fa fa-circle fa-2x"></i>
          </div>
          <div class="item js_chat-color" data-color="#a085e2" style="color: #a085e2;">
            <i class="fa fa-circle fa-2x"></i>
          </div>
          <div class="item js_chat-color" data-color="#01a5a5" style="color: #01a5a5;">
            <i class="fa fa-circle fa-2x"></i>
          </div>
          <div class="item js_chat-color" data-color="#2b87ce" style="color: #2b87ce;">
            <i class="fa fa-circle fa-2x"></i>
          </div>
          <div class="item js_chat-color" data-color="#ff72d2" style="color: #ff72d2;">
            <i class="fa fa-circle fa-2x"></i>
          </div>
          <div class="item js_chat-color" data-color="#c9605e" style="color: #c9605e;">
            <i class="fa fa-circle fa-2x"></i>
          </div>
          <div class="item js_chat-color" data-color="#056bba" style="color: #056bba;">
            <i class="fa fa-circle fa-2x"></i>
          </div>
          <div class="item js_chat-color" data-color="#fc9cde" style="color: #fc9cde;">
            <i class="fa fa-circle fa-2x"></i>
          </div>
          <div class="item js_chat-color" data-color="#70a0e0" style="color: #70a0e0;">
            <i class="fa fa-circle fa-2x"></i>
          </div>
          <div class="item js_chat-color" data-color="#f2812b" style="color: #f2812b;">
            <i class="fa fa-circle fa-2x"></i>
          </div>
          <div class="item js_chat-color" data-color="#8ec96c" style="color: #8ec96c;">
            <i class="fa fa-circle fa-2x"></i>
          </div>
          <div class="item js_chat-color" data-color="#f33d4c" style="color: #f33d4c;">
            <i class="fa fa-circle fa-2x"></i>
          </div>
          <div class="item js_chat-color" data-color="#aa2294" style="color: #aa2294;">
            <i class="fa fa-circle fa-2x"></i>
          </div>
          <div class="item js_chat-color" data-color="#0e71ea" style="color: #0e71ea;">
            <i class="fa fa-circle fa-2x"></i>
          </div>
          <div class="item js_chat-color" data-color="#b582af" style="color: #b582af;">
            <i class="fa fa-circle fa-2x"></i>
          </div>
          <div class="item js_chat-color" data-color="#a1ce79" style="color: #a1ce79;">
            <i class="fa fa-circle fa-2x"></i>
          </div>
          <div class="item js_chat-color" data-color="#56c4c5" style="color: #56c4c5;">
            <i class="fa fa-circle fa-2x"></i>
          </div>
          <div class="item js_chat-color" data-color="#f9a722" style="color: #f9a722;">
            <i class="fa fa-circle fa-2x"></i>
          </div>
          <div class="item js_chat-color" data-color="#f9c270" style="color: #f9c270;">
            <i class="fa fa-circle fa-2x"></i>
          </div>
          <div class="item js_chat-color" data-color="#609b41" style="color: #609b41;">
            <i class="fa fa-circle fa-2x"></i>
          </div>
          <div class="item js_chat-color" data-color="#51bcbc" style="color: #51bcbc;">
            <i class="fa fa-circle fa-2x"></i>
          </div>
          <div class="item js_chat-color" data-color="#008484" style="color: #008484;">
            <i class="fa fa-circle fa-2x"></i>
          </div>
          <div class="item js_chat-color" data-color="#5462a5" style="color: #5462a5;">
            <i class="fa fa-circle fa-2x"></i>
          </div>
        </div>
      </div>
    </script>

    <script id="chat-attachments-item" type="text/template">
      <li class="item deletable" data-src="{literal}{{src}}{/literal}">
        <img alt="" src="{literal}{{image_path}}{/literal}">
        <button type="button" class="btn-close js_chat-attachment-remover" title='{__("Remove")}'></button>
      </li>
    </script>
    <!-- Chat -->

    <!-- DayTime Messages -->
    {if $system['daytime_msg_enabled'] && $page == "index"}
		<script id="message-morning" type="text/template">
			<div class="card m-0 rounded-0 p-3 daytime_message morning">
				<button type="button" class="btn-close float-end shadow-none small js_daytime-remover"></button>
				<div class="d-flex align-items-center gap-10">
					<svg width="40" height="40" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M9.5 6.5C9.99153 5.9943 11.2998 4 12 4M14.5 6.5C14.0085 5.9943 12.7002 4 12 4M12 4V10" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/><path d="M18.3633 10.6367L16.9491 12.0509" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/><path d="M3 17H5" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/><path d="M5.63657 10.6366L7.05078 12.0508" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/><path d="M21 17H19" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/><path d="M21 20H3" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/><path opacity="0.4" d="M12 13C9.79086 13 8 14.7909 8 17H16C16 14.7909 14.2091 13 12 13Z" fill="currentColor"/><path d="M16 17C16 14.7909 14.2091 13 12 13C9.79086 13 8 14.7909 8 17" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
					<div class="">
						<div><strong class="fw-semibold">{__("Good Morning")}, {$user->_data['user_fullname']}</strong></div>
						<span class="text-muted">{__($system['system_morning_message'])}</span>
					</div>
				</div>
			</div>
		</script>

		<script id="message-afternoon" type="text/template">
			<div class="card m-0 rounded-0 p-3 daytime_message noon">
				<button type="button" class="btn-close float-end shadow-none small js_daytime-remover"></button>
				<div class="d-flex align-items-center gap-10">
					<svg width="40" height="40" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path opacity="0.4" d="M17 12C17 14.7614 14.7614 17 12 17C9.23858 17 7 14.7614 7 12C7 9.23858 9.23858 7 12 7C14.7614 7 17 9.23858 17 12Z" fill="currentColor"/><path d="M17 12C17 14.7614 14.7614 17 12 17C9.23858 17 7 14.7614 7 12C7 9.23858 9.23858 7 12 7C14.7614 7 17 9.23858 17 12Z" stroke="currentColor" stroke-width="1.5"/><path d="M12 2C11.6227 2.33333 11.0945 3.2 12 4M12 20C12.3773 20.3333 12.9055 21.2 12 22M19.5 4.50271C18.9685 4.46982 17.9253 4.72293 18.0042 5.99847M5.49576 17.5C5.52865 18.0315 5.27555 19.0747 4 18.9958M5.00271 4.5C4.96979 5.03202 5.22315 6.0763 6.5 5.99729M18 17.5026C18.5315 17.4715 19.5747 17.7108 19.4958 18.9168M22 12C21.6667 11.6227 20.8 11.0945 20 12M4 11.5C3.66667 11.8773 2.8 12.4055 2 11.5" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
					<div class="">
						<div><strong class="fw-semibold">{__("Good Afternoon")}, {$user->_data['user_fullname']}</strong></div>
						<span class="text-muted">{__($system['system_afternoon_message'])}</span>
					</div>
				</div>
			</div>
		</script>

		<script id="message-evening" type="text/template">
			<div class="card m-0 rounded-0 p-3 daytime_message evening">
				<button type="button" class="btn-close float-end shadow-none small js_daytime-remover"></button>
				<div class="d-flex align-items-center gap-10">
					<svg width="40" height="40" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path opacity="0.4" d="M16.1892 3.2463C14.6941 5.1807 14.4368 7.87928 15.7546 10.1113C17.0631 12.3278 19.5558 13.4589 22 13.1816C21.0321 16.5396 17.8856 19 14.1534 19C9.65042 19 6 15.4183 6 11C6 6.58172 9.65042 3 14.1534 3C14.8152 3 15.5731 3.10029 16.1892 3.2463Z" fill="currentColor"></path><path d="M19.5483 17C20.7476 15.9645 21.5819 14.6272 22 13.1756C19.5473 13.4746 17.0369 12.3432 15.7234 10.1113C14.4099 7.87928 14.6664 5.1807 16.1567 3.2463C14.1701 2.75234 11.9929 2.98823 10.0779 4.07295C7.30713 5.64236 5.83056 8.56635 6.0155 11.5" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path><path d="M2 15C5.5 18.5 11.5755 17 12.7324 15C12.9026 14.7058 13 14.3643 13 14C13 12.8954 12.1046 12 11 12C9.89543 12 9 12.8954 9 14" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"></path><path d="M14.0001 20.9146C14.1565 20.9699 14.3248 21 14.5001 21C15.3285 21 16.0001 20.3284 16.0001 19.5C16.0001 18.6716 15.3285 18 14.5001 18C14.206 18 13.9317 18.0846 13.7002 18.2309C12.5505 19.0225 10.4209 20.0378 8 20.301M5 20.1936C4.33025 20.0635 3.6594 19.8541 3 19.5478" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"></path><path d="M19 20.0003C19.2581 20.0003 19.9557 19.8804 21 19.4551" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"></path></svg>
					<div class="">
						<div><strong class="fw-semibold">{__("Good Evening")}, {$user->_data['user_fullname']}</strong></div>
						<span class="text-muted">{__($system['system_evening_message'])}</span>
					</div>
				</div>
			</div>
		</script>
    {/if}
    <!-- DayTime Messages -->

    <!-- Gifts -->
    {if $system['gifts_enabled'] && $page == "profile"}
      <script id="gifts" type="text/template">
        <div class="modal-header">
          <h6 class="modal-title">
            {include file='__svg_icons.tpl' icon="gifts" class="main-icon mr10" width="24px" height="24px"}
            {__("Gifts")}
          </h6>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <form class="js_ajax-forms" data-url="users/gifts.php?do=send&uid={literal}{{uid}}{/literal}">
          <div class="modal-body">
            <div class="js_scroller" data-slimScroll-height="440">
              <div class="row">
                {foreach from=$gifts item=gift}
                  <div class="col-12 col-sm-6 col-md-4 ptb5 plr5">
                    <input class="x-hidden input-label" type="radio" name="gift" value="{$gift['gift_id']}" id="gift_{$gift['gift_id']}" />
                    <label class="button-label-image" for="gift_{$gift['gift_id']}">
                      <img src="{$system['system_uploads']}/{$gift['image']}" />
                    </label>
                  </div>
                {/foreach}
              </div>
            </div>
            <!-- error -->
            <div class="alert alert-danger mb0 mt10 x-hidden"></div>
            <!-- error -->
          </div>
          <div class="modal-footer">
            <button type="submit" class="btn btn-primary">{__("Send")}</button>
          </div>
        </form>
      </script>

      <script id="gift" type="text/template">
        <div class="modal-header">
          <h6 class="modal-title">
            {include file='__svg_icons.tpl' icon="gifts" class="main-icon mr10" width="24px" height="24px"}
            {if $system['show_usernames_enabled']}{$gift['user_name']}{else}{$gift['user_firstname']} {$gift['user_lastname']}{/if} {__("sent you a gift")}
          </h6>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body text-center">
          <img class="img-fluid" src="{$system['system_uploads']}/{$gift['image']}">
        </div>
      </script>
    {/if}
    <!-- Gifts -->

    <!-- Uploader -->
    <script id="uploader-attachments-image-item" type="text/template">
      <li class="item deletable" data-src="{literal}{{src}}{/literal}">
        <img alt="" src="{literal}{{image_path}}{/literal}">
        <button type="button" class="btn-close {literal}{{#mini}}{/literal}js_publisher-mini-attachment-image-remover{literal}{{/mini}}{/literal}{literal}{{^mini}}{/literal}js_publisher-attachment-image-remover{literal}{{/mini}}{/literal}" title='{__("Remove")}'></button>
      </li>
    </script>

    <script id="uploader-attachments-video-item" type="text/template">
      <li class="item deletable" data-src="{literal}{{src}}{/literal}">
        <div class="name">{literal}{{name}}{/literal}</div>
        <button type="button" class="btn-close js_publisher-mini-attachment-video-remover" title='{__("Remove")}'></button>
      </li>
    </script>
    <!-- Uploader -->

    <!-- Publisher -->
    <script id="scraper-photo" type="text/template">
		<button type="button" class="btn btn-mat publisher-scraper-remover position-absolute rounded-circle text-white p-2 m-2 js_publisher-scraper-remover"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" stroke-width="2.5" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><line x1="18" y1="6" x2="6" y2="18" /><line x1="6" y1="6" x2="18" y2="18" /></svg></button>
		<div class="post-media">
			<div class="post-media-image d-block position-relative">
				<img src="{literal}{{url}}{/literal}">
				<div class="source text-truncate text-white m-2 position-absolute">{literal}{{provider}}{/literal}</div>
			</div>
		</div>
    </script>

    <script id="scraper-link" type="text/template">
		<button type="button" class="btn btn-mat publisher-scraper-remover position-absolute rounded-circle text-white p-2 m-2 js_publisher-scraper-remover"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" stroke-width="2.5" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><line x1="18" y1="6" x2="6" y2="18" /><line x1="6" y1="6" x2="18" y2="18" /></svg></button>
		<div class="post-media">
			{literal}{{#thumbnail}}{/literal}
				<a class="post-media-image d-block position-relative" href="{literal}{{url}}{/literal}" target="_blank">
					<img src="{literal}{{thumbnail}}{/literal}">
					<div class="source text-truncate text-white m-2 position-absolute">{literal}{{title}}{/literal}</div>
				</a>
			{literal}{{/thumbnail}}{/literal}
			<div class="post-media-meta w-100 pt-1">
				<a class="title d-inline-block" href="{literal}{{url}}{/literal}" target="_blank">{literal}{{host}}{/literal}</a>
				<div class="text overflow-hidden text-muted">{literal}{{text}}{/literal}</div>
			</div>
		</div>
    </script>

    <script id="scraper-media" type="text/template">
		<button type="button" class="btn btn-mat publisher-scraper-remover position-absolute rounded-circle text-white p-2 m-2 js_publisher-scraper-remover"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" stroke-width="2.5" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><line x1="18" y1="6" x2="6" y2="18" /><line x1="6" y1="6" x2="18" y2="18" /></svg></button>
		
		<div>
			{literal}{{{html}}}{/literal}
		</div>
    </script>

    <script id="scraper-player" type="text/template">
		<button type="button" class="btn btn-mat publisher-scraper-remover position-absolute rounded-circle text-white p-2 m-2 js_publisher-scraper-remover"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" stroke-width="2.5" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><line x1="18" y1="6" x2="6" y2="18" /><line x1="6" y1="6" x2="18" y2="18" /></svg></button>
		
		<div>
			<div class="ratio ratio-16x9">
				{literal}{{{html}}}{/literal}
			</div>
		</div>
    </script>

    <script id="scraper-facebook" type="text/template">
		<button type="button" class="btn btn-mat publisher-scraper-remover position-absolute rounded-circle text-white p-2 m-2 js_publisher-scraper-remover"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" stroke-width="2.5" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><line x1="18" y1="6" x2="6" y2="18" /><line x1="6" y1="6" x2="18" y2="18" /></svg></button>
		
		<div>
			<div class="embed-facebook-wrapper">
				{literal}{{{html}}}{/literal}
				<div class="embed-facebook-placeholder ptb30">
					<div class="d-flex justify-content-center">
						<div class="spinner-grow"></div>
					</div>
				</div>
			</div>
		</div>
    </script>

    <script id="poll-option" type="text/template">
		<div class="publisher-meta" data-meta="poll">
			<input type="text" placeholder='{__("Add an option")}...'>
		</div>
    </script>

    <script id="pubisher-gif" type="text/template">
		<button type="button" class="btn btn-mat publisher-scraper-remover position-absolute rounded-circle text-white p-2 m-2 js_publisher-gif-remover"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" stroke-width="2.5" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><line x1="18" y1="6" x2="6" y2="18" /><line x1="6" y1="6" x2="18" y2="18" /></svg></button>
		
		<div class="post-media">
			<div class="post-media-image d-block position-relative">
				<div class="image" style="background-image:url('{literal}{{src}}{/literal}');"></div>
			</div>
		</div>
    </script>
    <!-- Publisher -->

    <!-- Posts & Comments -->
    {if in_array($page, ["index", "profile", "page", "group", "event", "post", "photo", "market", "blogs", "directory", "search", "share", "reels"])}
      <!-- Comments -->
      <script id="comment-attachments-item" type="text/template">
        <li class="item deletable" data-src="{literal}{{src}}{/literal}">
          <img alt="" src="{literal}{{image_path}}{/literal}">
          <button type="button" class="btn-close js_comment-attachment-remover" title='{__("Remove")}'></button>
        </li>
      </script>
      <!-- Comments -->

      <!-- Edit (Posts|Comments) -->
      <script id="edit-post" type="text/template">
		<div class="post-edit mt-2">
			<div class="x-form post-form d-flex align-items-end p-0">
				<textarea rows="2" class="js_autosize js_mention js_update-post-textarea bg-transparent px-3 w-100 m-0 py-2 border-0">{literal}{{text}}{/literal}</textarea>
				<ul class="x-form-tools position-relative flex-0 mx-2 mb-2 lh-1">
					<li class="x-form-tools-emoji js_emoji-menu-toggle lh-1">
						<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" stroke-width="1.75" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">  <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>  <circle cx="12" cy="12" r="9"></circle>  <line x1="9" y1="10" x2="9.01" y2="10"></line>  <line x1="15" y1="10" x2="15.01" y2="10"></line>  <path d="M9.5 15a3.5 3.5 0 0 0 5 0"></path></svg>
					</li>
				</ul>
			</div>
			<div class="d-flex align-items-center justify-content-end mt-2 gap-2">
				<button class="btn btn-sm btn-link main js_unedit-post">{__("Cancel")}</button>
				<button class="btn btn-sm btn-main js_update-post">{__("Save")}</button>
			</div>
        </div>
      </script>

      <script id="edit-comment" type="text/template">
        <div class="comment-edit flex-1">
			<div class="x-form comment-form d-flex align-items-end p-0">
				<textarea rows="1" class="js_autosize js_mention js_update-comment-textarea bg-transparent px-3 w-100 m-0 py-2 border-0">{literal}{{text}}{/literal}</textarea>
				<ul class="x-form-tools position-relative flex-0 mx-2 mb-2 lh-1 d-flex align-items-center gap-2">
					<li class="x-form-tools-attach lh-1">
						<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="20" height="20" color="currentColor" fill="none" class="js_x-uploader" data-handle="comment"><path d="M2.5 12C2.5 7.52166 2.5 5.28249 3.89124 3.89124C5.28249 2.5 7.52166 2.5 12 2.5C16.4783 2.5 18.7175 2.5 20.1088 3.89124C21.5 5.28249 21.5 7.52166 21.5 12C21.5 16.4783 21.5 18.7175 20.1088 20.1088C18.7175 21.5 16.4783 21.5 12 21.5C7.52166 21.5 5.28249 21.5 3.89124 20.1088C2.5 18.7175 2.5 16.4783 2.5 12Z" stroke="currentColor" stroke-width="1.75"></path><circle cx="16.5" cy="7.5" r="1.5" stroke="currentColor" stroke-width="1.75"></circle><path d="M16 22C15.3805 19.7749 13.9345 17.7821 11.8765 16.3342C9.65761 14.7729 6.87163 13.9466 4.01569 14.0027C3.67658 14.0019 3.33776 14.0127 3 14.0351" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round"></path><path d="M13 18C14.7015 16.6733 16.5345 15.9928 18.3862 16.0001C19.4362 15.999 20.4812 16.2216 21.5 16.6617" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round"></path></svg>
					</li>
					<li class="x-form-tools-emoji js_emoji-menu-toggle lh-1">
						<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" stroke-width="1.75" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">  <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>  <circle cx="12" cy="12" r="9"></circle>  <line x1="9" y1="10" x2="9.01" y2="10"></line>  <line x1="15" y1="10" x2="15.01" y2="10"></line>  <path d="M9.5 15a3.5 3.5 0 0 0 5 0"></path></svg>
					</li>
				</ul>
			</div>
			<div class="comment-attachments attachments mt-2 clearfix x-hidden">
				<ul>
					<li class="loading">
						<div class="progress x-progress">
							<div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
						</div>
					</li>
				</ul>
			</div>
			<div class="d-flex align-items-center justify-content-end mt-2 gap-2">
				<button class="btn btn-sm btn-link js_unedit-comment">{__("Cancel")}</button>
				<button class="btn btn-sm btn-main js_update-comment">{__("Save")}</button>
			</div>
        </div>
      </script>
      <!-- Edit (Posts|Comments) -->

      <!-- Hidden (Posts|Authors) -->
      <script id="hidden-post" type="text/template">
        <div class="post p-3 position-relative flagged" data-id="{literal}{{id}}{/literal}">
			<div class="fw-semibold">{__("Post Hidden")}</div>
			<div class="">{__("This post will no longer appear to you")}.</div>
			<button class="btn btn-sm btn-main js_unhide-post mt-2">{__("Undo")}</button>
        </div>
      </script>

      <script id="hidden-author" type="text/template">
			<div class="post p-3 position-relative flagged" data-id="{literal}{{id}}{/literal}">
				<div class="">{__("You won't see posts from")} <span class="fw-semibold">{literal}{{name}}{/literal}</span> {__("in News Feed anymore")}.</div>
				<button class="btn btn-sm btn-main js_unhide-author mt-2" data-author-id="{literal}{{uid}}{/literal}" data-author-name="{literal}{{name}}{/literal}">{__("Undo")}</button>
			</div>
      </script>
      <!-- Hidden (Posts|Authors) -->

      {if $system['tips_enabled']}
        <!-- Tips -->
        <script id="send-tip" type="text/template">
          <div class="modal-header">
            <h6 class="modal-title">
              {include file='__svg_icons.tpl' icon="tips" class="main-icon mr10" width="24px" height="24px"}
              {__("Send Tip")}
            </h6>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <form class="js_ajax-forms" data-url="payments/wallet.php?do=send_tip">
            <div class="modal-body">
            <div class="form-group">
                <label class="form-label" for="amount">{__("Your Wallet Credit")}</label>
                <div>
                  <span class="badge badge-lg bg-info">{print_money($user->_data['user_wallet_balance']|number_format:2)}</span>
                </div>
              </div>
              <div class="form-group">
                <label class="form-label">{__("Amount")}</label>
                <div class="input-money {$system['system_currency_dir']}">
                  <span>{$system['system_currency_symbol']}</span>
                  <input class="form-control" type="text" placeholder="0.00" min="1.00" max="1000" name="amount" value="{literal}{{value}}{/literal}">
                </div>
                <div class="form-text">        
                  {__("The minimum amount")}: {print_money($system['tips_min_amount'])} {__("and the maximum")}: {print_money($system['tips_max_amount'])}
                </div>
              </div>
              <!-- error -->
              <div class="alert alert-danger mb0 mt10 x-hidden"></div>
              <!-- error -->
            </div>
            <div class="modal-footer">
              <input type="hidden" name="send_to_id" value="{literal}{{id}}{/literal}">
              <button type="button" class="btn btn-light" data-bs-dismiss="modal">{__("Cancel")}</button>
              <button type="submit" class="btn btn-primary">{__("Send")}</button>
            </div>
          </form>
        </script>
        <!-- Tips -->
      {/if}
    {/if}
    <!-- Posts & Comments -->

    <!-- Wallet -->
    <script id="wallet-replenish" type="text/template">
        <div class="modal-header">
          <h6 class="modal-title">
          {include file='__svg_icons.tpl' icon="payments" class="main-icon mr10" width="24px" height="24px"}
          {__("Replenish Credit")}
          </h6>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
      <form class="js_ajax-forms" data-url="payments/wallet.php?do=wallet_replenish">
          <div class="modal-body">
            <div class="form-group">
            <label class="form-label" for="amount">{__("Amount")}</label>
              <div class="input-money {$system['system_currency_dir']}">
                <span>{$system['system_currency_symbol']}</span>
                <input class="form-control" type="text" placeholder="0.00" min="1.00" max="1000" name="amount">
              </div>
            </div>
            <!-- error -->
            <div class="alert alert-danger mb0 mt10 x-hidden"></div>
            <!-- error -->
          </div>
          <div class="modal-footer">
          <button type="submit" class="btn btn-primary">{__("Continue")}</button>
          </div>
        </form>
      </script>
    
    {if $page == "wallet"}
      <script id="wallet-transfer" type="text/template">
        <div class="modal-header">
          <h6 class="modal-title">
            {include file='__svg_icons.tpl' icon="wallet_transfer" class="main-icon mr10" width="24px" height="24px"}
            {__("Send Money")}
          </h6>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <form class="js_ajax-forms" data-url="payments/wallet.php?do=wallet_transfer">
          <div class="modal-body">
            {if $system['wallet_max_transfer'] != "0"}
              <div class="alert alert-info mb20">
                <i class="fas fa-info-circle mr5"></i>
                {__("The maximum amount you can transfer is")} <span class="badge rounded-pill badge-lg bg-light text-primary">{print_money($system['wallet_max_transfer'])}</span>
              </div>
            {/if}
            <div class="form-group">
              <label class="form-label">{__("Amount")}</label>
              <div class="input-money {$system['system_currency_dir']}">
                <span>{$system['system_currency_symbol']}</span>
                <input class="form-control" type="text" placeholder="0.00" min="1.00" max="1000" name="amount">
              </div>
            </div>
            <div class="form-group">
              <label class="form-label" for="send_to">{__("Send To")}</label>
              <div class="position-relative js_autocomplete">
                <input class="form-control" type="text" placeholder="{__("Search for user name or email")}" name="send_to" id="send_to" autocomplete="off">
                <input type="hidden" name="send_to_id">
              </div>
            </div>
            <!-- error -->
            <div class="alert alert-danger mb0 mt10 x-hidden"></div>
            <!-- error -->
          </div>
          <div class="modal-footer">
            <button type="submit" class="btn btn-primary">{__("Send")}</button>
          </div>
        </form>
      </script>

      <script id="wallet-withdraw-affiliates" type="text/template">
        <div class="modal-header">
          <h6 class="modal-title">
            {include file='__svg_icons.tpl' icon="affiliates" class="main-icon mr10" width="24px" height="24px"}
            {__("Withdraw Affiliates Credit")}
          </h6>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <form class="js_ajax-forms" data-url="payments/wallet.php?do=wallet_withdraw_affiliates">
          <div class="modal-body">
            <div class="form-group">
              <label class="form-label" for="amount">{__("Your Affiliates Credit")}</label>
              <div>
                <span class="badge badge-lg bg-info">{print_money($user->_data['user_affiliate_balance']|number_format:2)}</span>
              </div>
            </div>
            <div class="form-group">
              <label class="form-label" for="amount">{__("Amount")}</label>
              <div class="input-money {$system['system_currency_dir']}">
                <span>{$system['system_currency_symbol']}</span>
                <input class="form-control" type="text" placeholder="0.00" min="1.00" max="1000" name="amount">
              </div>
            </div>
            <!-- error -->
            <div class="alert alert-danger mb0 mt10 x-hidden"></div>
            <!-- error -->
          </div>
          <div class="modal-footer">
            <button type="submit" class="btn btn-primary">{__("Continue")}</button>
          </div>
        </form>
      </script>

      <script id="wallet-withdraw-points" type="text/template">
        <div class="modal-header">
          <h6 class="modal-title">
            {include file='__svg_icons.tpl' icon="points" class="main-icon mr10" width="24px" height="24px"}
            {__("Withdraw Points Credit")}
          </h6>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <form class="js_ajax-forms" data-url="payments/wallet.php?do=wallet_withdraw_points">
          <div class="modal-body">
            <div class="form-group">
              <label class="form-label" for="amount">{__("Your Points Credit")}</label>
              <div>
                <span class="badge badge-lg bg-info">
                  {if $system['points_per_currency'] == 0}0{else}{print_money((((1/$system['points_per_currency'])*$user->_data['user_points'])|number_format:2))}{/if}
                </span>
              </div>
            </div>
            <div class="form-group">
              <label class="form-label" for="amount">{__("Amount")}</label>
              <div class="input-money {$system['system_currency_dir']}">
                <span>{$system['system_currency_symbol']}</span>
                <input class="form-control" type="text" placeholder="0.00" min="1.00" max="1000" name="amount">
              </div>
            </div>
            <!-- error -->
            <div class="alert alert-danger mb0 mt10 x-hidden"></div>
            <!-- error -->
          </div>
          <div class="modal-footer">
            <button type="submit" class="btn btn-primary">{__("Continue")}</button>
          </div>
        </form>
      </script>

      <script id="wallet-withdraw-market" type="text/template">
        <div class="modal-header">
          <h6 class="modal-title">
            {include file='__svg_icons.tpl' icon="market" class="main-icon mr10" width="24px" height="24px"}
            {__("Withdraw Market Credit")}
          </h6>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <form class="js_ajax-forms" data-url="payments/wallet.php?do=wallet_withdraw_market">
          <div class="modal-body">
            <div class="form-group">
              <label class="form-label" for="amount">{__("Your Funding Credit")}</label>
              <div>
                <span class="badge badge-lg bg-info">{print_money($user->_data['user_market_balance']|number_format:2)}</span>
              </div>
            </div>
            <div class="form-group">
              <label class="form-label" for="amount">{__("Amount")}</label>
              <div class="input-money {$system['system_currency_dir']}">
                <span>{$system['system_currency_symbol']}</span>
                <input class="form-control" type="text" placeholder="0.00" min="1.00" max="1000" name="amount">
              </div>
            </div>
            <!-- error -->
            <div class="alert alert-danger mb0 mt10 x-hidden"></div>
            <!-- error -->
          </div>
          <div class="modal-footer">
            <button type="submit" class="btn btn-primary">{__("Continue")}</button>
          </div>
        </form>
      </script>

      <script id="wallet-withdraw-funding" type="text/template">
        <div class="modal-header">
          <h6 class="modal-title">
            {include file='__svg_icons.tpl' icon="funding" class="main-icon mr10" width="24px" height="24px"}
            {__("Withdraw Funding Credit")}
          </h6>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <form class="js_ajax-forms" data-url="payments/wallet.php?do=wallet_withdraw_funding">
          <div class="modal-body">
            <div class="form-group">
              <label class="form-label" for="amount">{__("Your Funding Credit")}</label>
              <div>
                <span class="badge badge-lg bg-info">{print_money($user->_data['user_funding_balance']|number_format:2)}</span>
              </div>
            </div>
            <div class="form-group">
              <label class="form-label" for="amount">{__("Amount")}</label>
              <div class="input-money {$system['system_currency_dir']}">
                <span>{$system['system_currency_symbol']}</span>
                <input class="form-control" type="text" placeholder="0.00" min="1.00" max="1000" name="amount">
              </div>
            </div>
            <!-- error -->
            <div class="alert alert-danger mb0 mt10 x-hidden"></div>
            <!-- error -->
          </div>
          <div class="modal-footer">
            <button type="submit" class="btn btn-primary">{__("Continue")}</button>
          </div>
        </form>
      </script>

      <script id="wallet-withdraw-monetization" type="text/template">
        <div class="modal-header">
          <h6 class="modal-title">
            {include file='__svg_icons.tpl' icon="monetization" class="main-icon mr10" width="24px" height="24px"}
            {__("Withdraw Monetization Credit")}
          </h6>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <form class="js_ajax-forms" data-url="payments/wallet.php?do=wallet_withdraw_monetization">
          <div class="modal-body">
            <div class="form-group">
              <label class="form-label" for="amount">{__("Your Monetization Credit")}</label>
              <div>
                <span class="badge badge-lg bg-info">{print_money($user->_data['user_monetization_balance']|number_format:2)}</span>
              </div>
            </div>
            <div class="form-group">
              <label class="form-label" for="amount">{__("Amount")}</label>
              <div class="input-money {$system['system_currency_dir']}">
                <span>{$system['system_currency_symbol']}</span>
                <input class="form-control" type="text" placeholder="0.00" min="1.00" max="1000" name="amount">
              </div>
            </div>
            <!-- error -->
            <div class="alert alert-danger mb0 mt10 x-hidden"></div>
            <!-- error -->
          </div>
          <div class="modal-footer">
            <button type="submit" class="btn btn-primary">{__("Continue")}</button>
          </div>
        </form>
      </script>
    {/if}
    <!-- Wallet -->

    <!-- Crop Profile (Picture|Cover) -->
    {if in_array($page, ["started", "profile", "page", "group", "event"])}
      <script id="crop-profile-picture" type="text/template">
        <div class="modal-header">
          <h6 class="modal-title">
            {include file='__svg_icons.tpl' icon="crop" class="main-icon mr10" width="24px" height="24px"}
            {__("Crop Picture")}
          </h6>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body text-center">
          <div class="alert alert-info mb-20">
            <i class="fa fa-info-circle mr5"></i>{__("Crop animated images will make them static, You can skip the cropping process by clicking on the cancel button")}
          </div>
          <img id="cropped-profile-picture" src="{literal}{{image}}{/literal}" style="max-width: 100%;">
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-light" data-bs-dismiss="modal">{__("Cancel")}</button>
          <button type="button" class="btn btn-primary js_crop-picture" data-handle="{literal}{{handle}}{/literal}" data-id="{literal}{{id}}{/literal}">{__("Save")}</button>
        </div>
      </script>
	  
	  <script id="crop-profile-cover" type="text/template">
        <div class="modal-header">
          <h6 class="modal-title">
            {include file='__svg_icons.tpl' icon="crop" class="main-icon mr10" width="24px" height="24px"}
            {__("Crop Cover")}
          </h6>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body text-center">
          <div class="alert alert-info mb-20">
            <i class="fa fa-info-circle mr5"></i>{__("Crop animated images will make them static, You can skip the cropping process by clicking on the cancel button")}
          </div>
          <img id="cropped-profile-cover" src="{literal}{{image}}{/literal}" style="max-width: 100%;">
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-light" data-bs-dismiss="modal">{__("Cancel")}</button>
          <button type="button" class="btn btn-primary js_crop-cover" data-handle="{literal}{{handle}}{/literal}" data-id="{literal}{{id}}{/literal}">{__("Save")}</button>
        </div>
      </script>
    {/if}
    <!-- Crop Profile (Picture|Cover) -->

    <!-- Download Information -->
    {if $page == "settings"}
      <script id="download-information" type="text/template">
        <div class="modal-header">
          <h6 class="modal-title">
            {include file='__svg_icons.tpl' icon="user_information" class="main-icon mr10" width="24px" height="24px"}
            {__("Download Your Information")}
          </h6>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          <div class="text-center">
            {include file='__svg_icons.tpl' icon="ready" class="mb20" width="100px" height="100px"}
            <p class="text-lg">{__("Your file is ready to download")}</p>
            <a href="{$system['system_url']}/settings/download?hash={$user->_data['user_name']}-{$secret}" class="btn btn-md btn-primary bg-gradient-blue border-0 rounded-pill">
              <i class="fa fa-cloud-download-alt mr10"></i>{__("Download")}
            </a>
          </div>
        </div>
      </script>
    {/if}
    <!-- Download Information -->

    <!-- Verification Documents -->
    {if $page == "admin"}
      <script id="verification-documents" type="text/template">
        <div class="modal-header">
          <h6 class="modal-title">{__("Verification Documents")}</h6>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          {if $system['verification_docs_required']}
            <div class="row form-group">
              <label class="col-md-3 form-label">
                {__("Documents")}
              </label>
              <div class="col-sm-9">
                <div class="row">
                  <div class="col-sm-6">
                    <div class="section-title mb20">
                      {literal}{{#is_page}}{/literal}
                        {__("Company Incorporation File")}
                      {literal}{{/is_page}}{/literal}
                      {literal}{{^is_page}}{/literal}
                        {__("Personal Photo")}
                      {literal}{{/is_page}}{/literal}
                    </div>
                    <a target="_blank" href="{literal}{{photo}}{/literal}">
                      <img class="img-fluid" src="{literal}{{photo}}{/literal}">
                    </a>
                  </div>
                  <div class="col-sm-6">
                    <div class="section-title mb20">
                      {literal}{{#is_page}}{/literal}
                        {__("Company Tax File")}
                      {literal}{{/is_page}}{/literal}
                      {literal}{{^is_page}}{/literal}
                        {__("Passport or National ID")}
                      {literal}{{/is_page}}{/literal}
                    </div>
                    <a target="_blank" href="{literal}{{passport}}{/literal}">
                      <img class="img-fluid" src="{literal}{{passport}}{/literal}">
                    </a>
                  </div>
                </div>
              </div>
            </div>
          {/if}
          {literal}{{#is_page}}{/literal}
            <div class="row form-group">
              <label class="col-md-3 form-label">
                {__("Business Website")}
              </label>
              <div class="col-sm-9">
                <p class="pt5 pb0">{literal}{{website}}{/literal}</p>
              </div>
            </div>
            <div class="row form-group">
              <label class="col-md-3 form-label">
                {__("Business Address")}
              </label>
              <div class="col-sm-9">
                <p class="pt5 pb0">{literal}{{address}}{/literal}</p>
              </div>
            </div>
          {literal}{{/is_page}}{/literal}
          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("Message")}
            </label>
            <div class="col-sm-9">
              <p class="pt5 pb0">{literal}{{message}}{/literal}</p>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button class="btn btn-danger js_admin-unverify" data-handle="{literal}{{handle}}{/literal}" data-id="{literal}{{node-id}}{/literal}">
            <i class="fa fa-times mr5"></i>{__("Decline")}
          </button>
          <button class="btn btn-success js_admin-verify" data-handle="{literal}{{handle}}{/literal}" data-id="{literal}{{node-id}}{/literal}">
            <i class="fa fa-check mr5"></i>{__("Verify")}
          </button>
        </div>
      </script>
    {/if}
    <!-- Verification Documents -->

    <!-- Export CSV -->
    {if $page == "admin"}
      <script id="export-csv" type="text/template">
        <div class="modal-header">
          <h6 class="modal-title">{__("Export CSV")}</h6>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <form class="js_ajax-forms" data-url="admin/export.php">
          <div class="modal-body">
            <div class="form-group">
              <label class="form-label" for="from_row">{__("Row to begin at")}</label>
              <input type="text" class="form-control" name="from_row" id="from_row" value="0" required autofocus>
            </div>
            <div class="form-group">
              <label class="form-label" for="results">{__("Number of rows")}</label>
              <input type="text" class="form-control" name="results" id="results" value="10" required>
              <div class="form-text">
                {__("Set to 0 to export all results")}
              </div>
            </div>
            <div class="form-group">
            <label class="form-label" for="to">{__("Date range")}</label>
              <div class="input-group">
                <input type="date" class="form-control" name="from" value="{literal}{{from}}{/literal}">
                <input type="date" class="form-control" name="to" value="{literal}{{to}}{/literal}">
              </div>
            </div>
            <!-- error -->
            <div class="alert alert-danger mb0 mt10 x-hidden"></div>
            <!-- error -->
          </div>
          <div class="modal-footer">
            <input type="hidden" name="handle" value="{literal}{{handle}}{/literal}">
            <button type="button" class="btn btn-light" data-bs-dismiss="modal">{__("Cancel")}</button>
            <button type="submit" class="btn btn-success">{__("Export")}</button>
          </div>
        </form>
      </script>
    {/if}
    <!-- Export CSV -->

    <!-- Funding -->
    {if $system['funding_enabled'] && in_array($page, ["index", "profile", "page", "group", "post", "directory", "search", "funding"])}
      <script id="funding-donate" type="text/template">
        <div class="modal-header">
          <h6 class="modal-title">
            {include file='__svg_icons.tpl' icon="funding" class="main-icon mr10" width="24px" height="24px"}
            {__("Donate")}
          </h6>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <form class="js_ajax-forms" data-url="posts/funding.php?do=donate&post_id={literal}{{post_id}}{/literal}">
          <div class="modal-body">
            <div class="form-group">
              <label class="form-label" for="amount">{__("Amount")}</label>
              <div class="input-money {$system['system_currency_dir']}">
                <span>{$system['system_currency_symbol']}</span>
                <input class="form-control" type="text" placeholder="0.00" min="1.00" max="1000" name="amount" />
              </div>
            </div>
            <!-- error -->
            <div class="alert alert-danger mb0 mt10 x-hidden"></div>
            <!-- error -->
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-light" data-bs-dismiss="modal">{__("Cancel")}</button>
            <button type="submit" class="btn btn-primary">{__("Continue")}</button>
          </div>
        </form>
      </script>
    {/if}
    <!-- Funding -->

    <!-- Payment -->
    <script id="payment" type="text/template">
      <div class="modal-header">
        <h6 class="modal-title">{__("Payment")}</h6>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <div id="payment-summry">
          <div class="plr20 text-start">
            <div class="mb15">
              <span>{__("Amount")}</span>
              <span class="float-end">{literal}{{price}}{/literal}</span>
            </div>
            {if $system['payment_vat_enabled']}
            <div class="mb15">
              <span>{__("VAT")} +%{get_payment_vat_percentage()}</span>
              <span class="float-end">{literal}{{vat}}{/literal}</span>
            </div>
            {/if}
            {if $system['payment_fees_enabled']}
              <div class="mb15">
                <span>{__("Fees")} +%{$system['payment_fees_percentage']}</span>
                <span class="float-end">{literal}{{fees}}{/literal}</span>
              </div>
            {/if}
            <div class="divider mtb15"></div>
            <div class="mb15">
              <span><strong>{__("Total")}</strong></span>
              <span class="float-end"><strong>{literal}{{total_printed}}{/literal}</strong></span>
            </div>
            <div class="divider mtb15"></div>
            {if $system['wallet_enabled']}
              {if $page == "packages" && $system['packages_enabled'] && $system['packages_wallet_payment_enabled']}
                <div>
                  <small class="text-muted"><i>{__("Note: Paying via wallet credit will not be charged any VAT or fees")}</i></small>
                  <div class="divider mtb15"></div>
                </div>
              {/if}
              {if ($page != "packages" && $page != "wallet") && $system['monetization_enabled'] && $system['monetization_wallet_payment_enabled']}
                {literal}{{#subscribe}}{/literal}
                  <div>
                    <small class="text-muted"><i>{__("Note: Paying via wallet credit will not be charged any VAT or fees")}</i></small>
                    <div class="divider mtb15"></div>
                  </div>
                {literal}{{/subscribe}}{/literal}
              {/if}
              {if ($page != "packages" && $page != "wallet") && $system['monetization_enabled'] && $system['monetization_wallet_payment_enabled']}
                {literal}{{#paid_post}}{/literal}
                  <div>
                    <small class="text-muted"><i>{__("Note: Paying via wallet credit will not be charged any VAT or fees")}</i></small>
                    <div class="divider mtb15"></div>
                  </div>
                {literal}{{/paid_post}}{/literal}
              {/if}
              {if ($page != "packages" && $page != "wallet") && $system['funding_enabled'] && $system['funding_wallet_payment_enabled']}
                {literal}{{#donate}}{/literal}
                  <div>
                    <small class="text-muted"><i>{__("Note: Paying via wallet credit will not be charged any VAT or fees")}</i></small>
                    <div class="divider mtb15"></div>
                  </div>
                {literal}{{/donate}}{/literal}
              {/if}
			  {if ($page != "packages" && $page != "wallet") && $system['market_enabled'] && $system['market_wallet_payment_enabled']}
                {literal}{{#marketplace}}{/literal}
                  <div>
                    <small class="text-muted"><i>{__("Note: Paying via wallet credit")} {if $system['market_cod_payment_enabled']}{__("or Cash On Delivery")}{/if} {__("will not be charged any VAT or fees")}</i></small>
                    <div class="divider mtb15"></div>
                  </div>
                {literal}{{/marketplace}}{/literal}
              {/if}
            {/if}
            <div class="ptb10 text-end">
              <button type="button" class="btn btn-primary js_payment-pay">{__("Continue")}</button>
            </div>
          </div>
        </div>
        <div id="payment-methods" class="x-hidden">
          <div class="row justify-content-center text-center">
            {if $system['paypal_enabled']}
              <div class="col-12 col-sm-6 mb10">
                <div class="d-grid">
                  <button class="js_payment-paypal btn btn-md btn-payment" data-handle="{literal}{{handle}}{/literal}" {literal}{{#id}}{/literal} data-id="{literal}{{id}}{/literal}" {literal}{{/id}}{/literal} {literal}{{#price}}{/literal} data-price="{literal}{{price}}{/literal}" {literal}{{/price}}{/literal}>
                    <i class="fab fa-paypal fa-lg fa-fw mr5" style="color: #00186A;"></i>{__("PayPal")}
                  </button>
                </div>
              </div>
            {/if}
            {if $system['creditcard_enabled']}
              <div class="col-12 col-sm-6 mb10">
                <div class="d-grid">
                  <button class="js_payment-stripe btn btn-md btn-payment" data-handle="{literal}{{handle}}{/literal}" {literal}{{#id}}{/literal} data-id="{literal}{{id}}{/literal}" {literal}{{/id}}{/literal} {literal}{{#price}}{/literal} data-price="{literal}{{price}}{/literal}" {literal}{{/price}}{/literal} {literal}{{#name}}{/literal} data-name="{literal}{{name}}{/literal}" {literal}{{/name}}{/literal} {literal}{{#img}}{/literal} data-img="{literal}{{img}}{/literal}" {literal}{{/img}}{/literal} data-method="credit">
                    <i class="fa fa-credit-card fa-lg fa-fw mr5" style="color: #8798CC;"></i>{__("Credit Card")}
                  </button>
                </div>
              </div>
            {/if}
            {if $system['alipay_enabled']}
              <div class="col-12 col-sm-6 mb10">
                <div class="d-grid">
                  <button class="js_payment-stripe btn btn-md btn-payment" data-handle="{literal}{{handle}}{/literal}" {literal}{{#id}}{/literal} data-id="{literal}{{id}}{/literal}" {literal}{{/id}}{/literal} {literal}{{#price}}{/literal} data-price="{literal}{{price}}{/literal}" {literal}{{/price}}{/literal} {literal}{{#name}}{/literal} data-name="{literal}{{name}}{/literal}" {literal}{{/name}}{/literal} {literal}{{#img}}{/literal} data-img="{literal}{{img}}{/literal}" {literal}{{/img}}{/literal} data-method="alipay">
                    <i class="fab fa-alipay fa-lg fa-fw mr5" style="color: #5B9EDD;"></i>{__("Alipay")}
                  </button>
                </div>
              </div>
            {/if}
            {if $system['paystack_enabled']}
              <div class="col-12 col-sm-6 mb10">
                <div class="d-grid">
                  <button class="js_payment-paystack btn btn-md btn-payment" data-handle="{literal}{{handle}}{/literal}" {literal}{{#id}}{/literal} data-id="{literal}{{id}}{/literal}" {literal}{{/id}}{/literal} {literal}{{#price}}{/literal} data-price="{literal}{{price}}{/literal}" {literal}{{/price}}{/literal}>
                    {include file='__svg_icons.tpl' icon="paystack" class="mr5" width="20px" height="20px"}{__("Paystack")}
                  </button>
                </div>
              </div>
            {/if}
            {if $system['2checkout_enabled']}
              <div class="col-12 col-sm-6 mb10">
                <div class="d-grid">
                  <button class="btn btn-md btn-payment" data-toggle="modal" data-url="#twocheckout" data-options='{ "handle": "{literal}{{handle}}{/literal}", "id": "{literal}{{id}}{/literal}", "price": "{literal}{{price}}{/literal}" }'>
                    {include file='__svg_icons.tpl' icon="2co" class="mr5" width="20px" height="20px"}{__("2Checkout")}
                  </button>
                </div>
              </div>
            {/if}
            {if $system['authorize_net_enabled']}
              <div class="col-12 col-sm-6 mb10">
                <div class="d-grid">
                  <button class="btn btn-md btn-payment" data-toggle="modal" data-url="#authorizenet" data-options='{ "handle": "{literal}{{handle}}{/literal}", "id": "{literal}{{id}}{/literal}", "price": "{literal}{{price}}{/literal}" }'>
                    {include file='__svg_icons.tpl' icon="authorize.net" class="mr5" width="20px" height="20px"}{__("Authorize.Net")}
                  </button>
                </div>
              </div>
            {/if}
            {if $system['razorpay_enabled']}
              <div class="col-12 col-sm-6 mb10">
                <div class="d-grid">
                  <button class="btn btn-md btn-payment" data-toggle="modal" data-url="#razorpay" data-options='{ "handle": "{literal}{{handle}}{/literal}", "id": "{literal}{{id}}{/literal}", "price": "{literal}{{price}}{/literal}", "total": "{literal}{{total}}{/literal}" }'>
                    {include file='__svg_icons.tpl' icon="razorpay" class="mr5" width="20px" height="20px"}{__("Razorpay")}
                  </button>
                </div>
              </div>
            {/if}
            {if $system['cashfree_enabled']}
              <div class="col-12 col-sm-6 mb10">
                <div class="d-grid">
                  <button class="btn btn-md btn-payment" data-toggle="modal" data-url="#cashfree" data-options='{ "handle": "{literal}{{handle}}{/literal}", "id": "{literal}{{id}}{/literal}", "price": "{literal}{{price}}{/literal}" }'>
                    {include file='__svg_icons.tpl' icon="cashfree" class="mr5" width="20px" height="20px"}{__("Cashfree")}
                  </button>
                </div>
              </div>
            {/if}
            {if $system['shift4_enabled']}
              <div class="col-12 col-sm-6 mb10">
                <div class="d-grid">
                  <button class="js_payment-shift4 btn btn-md btn-payment" data-handle="{literal}{{handle}}{/literal}" {literal}{{#id}}{/literal} data-id="{literal}{{id}}{/literal}" {literal}{{/id}}{/literal} {literal}{{#price}}{/literal} data-price="{literal}{{price}}{/literal}" {literal}{{/price}}{/literal}>
                    {include file='__svg_icons.tpl' icon="shift4" class="mr10" width="20px" height="20px"}{__("Shift4")}
                  </button>
                </div>
              </div>
            {/if}
            {if $system['moneypoolscash_enabled']}
              <div class="col-12 col-sm-6 mb10">
                <div class="d-grid">
                  <button class="js_payment-moneypoolscash btn btn-md btn-payment" data-handle="{literal}{{handle}}{/literal}" {literal}{{#id}}{/literal} data-id="{literal}{{id}}{/literal}" {literal}{{/id}}{/literal} {literal}{{#price}}{/literal} data-price="{literal}{{price}}{/literal}" {literal}{{/price}}{/literal}>
                    {include file='__svg_icons.tpl' icon="moneypoolscash" class="mr10" width="20px" height="20px"}{__("MoneyPoolsCash")}
                  </button>
                </div>
              </div>
            {/if}
            {if $system['myfatoorah_enabled']}
              <div class="col-12 col-sm-6 mb10">
                <div class="d-grid">
                  <button class="js_payment-myfatoorah btn btn-md btn-payment" data-handle="{literal}{{handle}}{/literal}" {literal}{{#id}}{/literal} data-id="{literal}{{id}}{/literal}" {literal}{{/id}}{/literal} {literal}{{#price}}{/literal} data-price="{literal}{{price}}{/literal}" {literal}{{/price}}{/literal}>
                    {include file='__svg_icons.tpl' icon="myfatoorah" class="mr10" width="20px" height="20px"}{__("MyFatoorah")}
                  </button>
                </div>
              </div>
            {/if}
            {if $system['epayco_enabled']}
              <div class="col-12 col-sm-6 mb10">
                <div class="d-grid">
                  <button class="js_payment-epayco btn btn-md btn-payment" data-handle="{literal}{{handle}}{/literal}" {literal}{{#id}}{/literal} data-id="{literal}{{id}}{/literal}" {literal}{{/id}}{/literal} {literal}{{#price}}{/literal} data-price="{literal}{{price}}{/literal}" {literal}{{/price}}{/literal} {literal}{{#total}}{/literal} data-total="{literal}{{total}}{/literal}" {literal}{{/total}}{/literal}>
                    <img width="20px" height="20px" src="{$system['system_url']}/content/themes/{$system['theme']}/images/epayco.png" class="mr5">{__("Epayco")}
                  </button>
                </div>
              </div>
            {/if}
            {if $system['flutterwave_enabled']}
              <div class="col-12 col-sm-6 mb10">
                <div class="d-grid">
                  <button class="js_payment-flutterwave btn btn-md btn-payment" data-handle="{literal}{{handle}}{/literal}" {literal}{{#id}}{/literal} data-id="{literal}{{id}}{/literal}" {literal}{{/id}}{/literal} {literal}{{#price}}{/literal} data-price="{literal}{{price}}{/literal}" {literal}{{/price}}{/literal}>
                    {include file='__svg_icons.tpl' icon="flutterwave" class="mr5" width="20px" height="20px"}{__("Flutterwave")}
                  </button>
                </div>
              </div>
            {/if}
            {if $system['verotel_enabled']}
              <div class="col-12 col-sm-6 mb10">
                <div class="d-grid">
                  <button class="js_payment-verotel btn btn-md btn-payment" data-handle="{literal}{{handle}}{/literal}" {literal}{{#id}}{/literal} data-id="{literal}{{id}}{/literal}" {literal}{{/id}}{/literal} {literal}{{#price}}{/literal} data-price="{literal}{{price}}{/literal}" {literal}{{/price}}{/literal}>
                    <img width="20px" height="20px" src="{$system['system_url']}/content/themes/{$system['theme']}/images/verotel.png" class="mr5">{__("Verotel")}
                  </button>
                </div>
              </div>
            {/if}
			{if $system['mercadopago_enabled']}
              <div class="col-12 col-sm-6 mb10">
                <div class="d-grid">
                  <button class="js_payment-mercadopago btn btn-md btn-payment" data-handle="{literal}{{handle}}{/literal}" {literal}{{#id}}{/literal} data-id="{literal}{{id}}{/literal}" {literal}{{/id}}{/literal} {literal}{{#price}}{/literal} data-price="{literal}{{price}}{/literal}" {literal}{{/price}}{/literal}>
                    {include file='__svg_icons.tpl' icon="mercadopago" class="mr5" width="20px" height="20px"}{__("MercadoPago")}
                  </button>
                </div>
              </div>
            {/if}
            {if $system['coinpayments_enabled']}
              <div class="col-12 col-sm-6 mb10">
                <div class="d-grid">
                  <button class="js_payment-coinpayments btn btn-md btn-payment" data-handle="{literal}{{handle}}{/literal}" {literal}{{#id}}{/literal} data-id="{literal}{{id}}{/literal}" {literal}{{/id}}{/literal} {literal}{{#price}}{/literal} data-price="{literal}{{price}}{/literal}" {literal}{{/price}}{/literal}>
                    <i class="fab fa-bitcoin fa-lg fa-fw mr5" style="color: #FFC107;"></i>{__("CoinPayments")}
                  </button>
                </div>
              </div>
            {/if}
            {if $system['coinbase_enabled']}
              <div class="col-12 col-sm-6 mb10">
                <div class="d-grid">
                  <button class="js_payment-coinbase btn btn-md btn-payment" data-handle="{literal}{{handle}}{/literal}" {literal}{{#id}}{/literal} data-id="{literal}{{id}}{/literal}" {literal}{{/id}}{/literal} {literal}{{#price}}{/literal} data-price="{literal}{{price}}{/literal}" {literal}{{/price}}{/literal}>
                    {include file='__svg_icons.tpl' icon="coinbase" class="mr10" width="20px" height="20px"}{__("Coinbase")}
                  </button>
                </div>
              </div>
            {/if}
            {if $system['bank_transfers_enabled']}
              <div class="col-12 col-sm-6 mb10">
                <div class="d-grid">
                  <button class="btn btn-md btn-payment" data-toggle="modal" data-url="#bank-transfer" data-options='{ "handle": "{literal}{{handle}}{/literal}", "id": "{literal}{{id}}{/literal}", "price": "{literal}{{price}}{/literal}" }' data-size="large">
                    <i class="fa fa-university fa-lg fa-fw mr5" style="color: #4CAF50;"></i>{__("Bank Transfer")}
                  </button>
                </div>
              </div>
            {/if}
            {if $system['wallet_enabled']}
              {if $page == "packages" && $system['packages_enabled'] && $system['packages_wallet_payment_enabled']}
                <div class="col-12 col-sm-6 mb10">
                  <div class="d-grid">
                    <button class="js_payment-wallet-package btn btn-md btn-payment" data-id="{literal}{{id}}{/literal}">
                      <i class="fa fa-wallet fa-lg fa-fw mr5" style="color: #007bff;"></i>{__("Wallet Credit")}
                    </button>
                  </div>
                </div>
              {/if}
              {if ($page != "packages" && $page != "wallet") && $system['monetization_enabled'] && $system['monetization_wallet_payment_enabled']}
                {literal}{{#subscribe}}{/literal}
                <div class="col-12 col-sm-6 mb10">
                  <div class="d-grid">
                    <button class="js_payment-wallet-monetization btn btn-md btn-payment" data-id="{literal}{{id}}{/literal}">
                      <i class="fa fa-wallet fa-lg fa-fw mr5" style="color: #007bff;"></i>{__("Wallet Credit")}
                    </button>
                  </div>
                </div>
                {literal}{{/subscribe}}{/literal}
              {/if}
              {if ($page != "packages" && $page != "wallet") && $system['monetization_enabled'] && $system['monetization_wallet_payment_enabled']}
                {literal}{{#paid_post}}{/literal}
                <div class="col-12 col-sm-6 mb10">
                  <div class="d-grid">
                    <button class="js_payment-wallet-paid-post btn btn-md btn-payment" data-id="{literal}{{id}}{/literal}">
                      <i class="fa fa-wallet fa-lg fa-fw mr5" style="color: #007bff;"></i>{__("Wallet Credit")}
                    </button>
                  </div>
                </div>
                {literal}{{/paid_post}}{/literal}
              {/if}
              {if ($page != "packages" && $page != "wallet") && $system['funding_enabled'] && $system['funding_wallet_payment_enabled']}
                {literal}{{#donate}}{/literal}
                <div class="col-12 col-sm-6 mb10">
                  <div class="d-grid">
                    <button class="js_payment-wallet-donate btn btn-md btn-payment" data-id="{literal}{{id}}{/literal}" data-price="{literal}{{price}}{/literal}">
                      <i class="fa fa-wallet fa-lg fa-fw mr5" style="color: #007bff;"></i>{__("Wallet Credit")}
                    </button>
                  </div>
                </div>
                {literal}{{/donate}}{/literal}
              {/if}
			  {if ($page != "packages" && $page != "wallet") && $system['market_enabled'] && $system['market_wallet_payment_enabled']}
                {literal}{{#marketplace}}{/literal}
                <div class="col-12 col-sm-6 mb10">
                  <div class="d-grid">
                    <button class="js_payment-wallet-marketplace btn btn-md btn-payment" data-id="{literal}{{id}}{/literal}" data-price="{literal}{{price}}{/literal}">
                      <i class="fa fa-wallet fa-lg fa-fw mr5" style="color: #007bff;"></i>{__("Wallet Credit")}
                    </button>
                  </div>
                </div>
                {literal}{{/marketplace}}{/literal}
              {/if}
            {/if}
			{if $system['market_cod_payment_enabled']}
              {if $page == "market"}
                <div class="col-12 col-sm-6 mb10">
                  <div class="d-grid">
                    <button class="js_payment-cod-marketplace btn btn-md btn-payment" data-id="{literal}{{id}}{/literal}" data-price="{literal}{{price}}{/literal}">
                      <i class="fa fa-money-bill-wave fa-lg fa-fw mr5" style="color: #28a745;"></i>{__("Cash on Delivery")}
                    </button>
                  </div>
                </div>
              {/if}
            {/if}
          </div>
        </div>
      </div>
    </script>
    <!-- Payment -->

    <!-- Stripe Payment Element -->
    {if $system['stripe_payment_element_enabled']}
      <script id="stripe-payment-element" type="text/template">
        <div class="modal-header">
          <h6 class="modal-title">{__("Payment")}</h6>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <form id="stripe-payment-element-form">
          <div class="modal-body">
            <div id="stripe-payment-element-details">
              <!-- loading -->
              <div class="text-center">
                <span class="spinner-grow spinner-grow-lg"></span>
              </div>
              <!-- loading -->
            </div>
            <!-- error -->
            <div class="alert alert-danger mt15 mb0 x-hidden"></div>
            <!-- error -->
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-light" data-bs-dismiss="modal">{__("Cancel")}</button>
            <button type="submit" class="btn btn-primary"><i class="fa fa-check-circle mr10"></i>{__("Pay")}</button>
          </div>
        </form>
      </script>
    {/if}
    <!-- Stripe Payment Element -->

    <!-- 2Checkout -->
    {if $system['2checkout_enabled']}
      <script id="twocheckout" type="text/template">
        <div class="modal-header">
          <h6 class="modal-title">
            {include file='__svg_icons.tpl' icon="2co" class="mr10" width="24px" height="24px"}
            {__("2Checkout")}
          </h6>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <form id="twocheckout_form">
          <div class="modal-body">
            <div class="heading-small mb20">
              {__("Card Info")}
            </div>
            <div class="pl-md-4 pr-md-4">
              <div class="row">
                <div class="form-group col-md-12">
                  <label class="form-label">{__("Card Number")}</label>
                  <input class="form-control" name="card_number" type="text" required autocomplete="off">
                </div>
                <div class="form-group col-md-4">
                  <label class="form-label">{__("Exp Month")}</label>
                  <select class="form-select" name="card_exp_month" required>
                    {for $i=1 to 12}
                      <option value="{if $i < 10}0{/if}{$i}">{if $i < 10}0{/if}{$i}</option>
                    {/for}
                  </select>
                </div>
                <div class="form-group col-md-4">
                  <label class="form-label">{__("Exp Year")}</label>
                  <select class="form-select" name="card_exp_year" required>
                    {for $i=2024 to 2040}
                      <option value="{$i}">{$i}</option>
                    {/for}
                  </select>
                </div>
                <div class="form-group col-md-4">
                  <label class="form-label">{__("CVC")}</label>
                  <input class="form-control"  name="card_cvv" type="text" required autocomplete="off">
                </div>
              </div>
            </div>
            <div class="heading-small mb20">
              {__("Billing Information")}
            </div>
            <div class="pl-md-4 pr-md-4">
              <div class="row">
                <div class="form-group col-md-6">
                  <label class="form-label">{__("Name")}</label>
                  <input class="form-control" name="billing_name" type="text" required value="{$user->_data['user_fullname']}">
                </div>
                <div class="form-group col-md-6">
                  <label class="form-label">{__("Email")}</label>
                  <input class="form-control" name="billing_email" type="email" required value="{$user->_data['user_email']}">
                </div>
                <div class="form-group col-md-6">
                  <label class="form-label">{__("Phone")}</label>
                  <input class="form-control" name="billing_phone" type="text" required value="{$user->_data['user_phone']}">
                </div>
                <div class="form-group col-md-6">
                  <label class="form-label">{__("Address")}</label>
                  <input name="billing_address" type="text" class="form-control required">
                </div>
                <div class="form-group col-md-6">
                  <label class="form-label">{__("City")}</label>
                  <input class="form-control" name="billing_city" type="text" required>
                </div>
                <div class="form-group col-md-6">
                  <label class="form-label">{__("State")}</label>
                  <input class="form-control" name="billing_state" type="text" required>
                </div>
                <div class="form-group col-md-6">
                  <label class="form-label">{__("Country")}</label>
                  <select class="form-select"  name="billing_country" required>
                    <option value="none">{__("Select Country")}</option>
                    {foreach $countries as $country}
                      <option {if $user->_data['user_country'] == $country['country_id']}selected{/if} value="{$country['country_name']}">{$country['country_name']}</option>
                    {/foreach}
                  </select>
                </div>
                <div class="form-group col-md-6">
                  <label class="form-label">{__("Zip Code")}</label>
                  <input class="form-control" name="billing_zip_code" type="text" required>
                </div>
              </div>
            </div>
            <!-- error -->
            <div class="alert alert-danger mt15 mb0 x-hidden"></div>
            <!-- error -->
          </div>
          <div class="modal-footer">
            <input type="hidden" name="token" value="" />
            <input type="hidden" name="handle" value="{literal}{{handle}}{/literal}">
            <input type="hidden" name="id" value="{literal}{{id}}{/literal}">
            <input type="hidden" name="price" value="{literal}{{price}}{/literal}">
            <button type="button" class="btn btn-light" data-bs-dismiss="modal">{__("Cancel")}</button>
            <button type="submit" class="btn btn-primary"><i class="fa fa-check-circle mr10"></i>{__("Pay")}</button>
          </div>
        </form>
      </script>
    {/if}
    <!-- 2Checkout -->

    <!-- Authorize.Net -->
    {if $system['authorize_net_enabled']}
      <script id="authorizenet" type="text/template">
        <div class="modal-header">
          <h6 class="modal-title">
            {include file='__svg_icons.tpl' icon="authorize.net" class="mr10" width="24px" height="24px"}
            {__("Authorize.Net")}
          </h6>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <form class="js_ajax-forms" data-url="payments/authorize.php">
          <div class="modal-body">
            <div class="heading-small mb20">
              {__("Card Info")}
            </div>
            <div class="pl-md-4 pr-md-4">
              <div class="row">
                <div class="form-group col-md-12">
                  <label class="form-label">{__("Card Number")}</label>
                  <input class="form-control" name="card_number" type="text" required autocomplete="off">
                </div>
                <div class="form-group col-md-4">
                  <label class="form-label">{__("Exp Month")}</label>
                  <select class="form-select" name="card_exp_month" required>
                    {for $i=1 to 12}
                      <option value="{if $i < 10}0{/if}{$i}">{if $i < 10}0{/if}{$i}</option>
                    {/for}
                  </select>
                </div>
                <div class="form-group col-md-4">
                  <label class="form-label">{__("Exp Year")}</label>
                  <select class="form-select" name="card_exp_year" required>
                    {for $i=2024 to 2040}
                      <option value="{$i}">{$i}</option>
                    {/for}
                  </select>
                </div>
                <div class="form-group col-md-4">
                  <label class="form-label">{__("CVC")}</label>
                  <input class="form-control"  name="card_cvv" type="text" required autocomplete="off">
                </div>
              </div>
            </div>
            <div class="heading-small mb20">
              {__("Billing Information")}
            </div>
            <div class="pl-md-4 pr-md-4">
              <div class="row">
                <div class="form-group col-md-6">
                  <label class="form-label">{__("Name")}</label>
                  <input class="form-control" name="billing_name" type="text" required value="{$user->_data['user_fullname']}">
                </div>
                <div class="form-group col-md-6">
                  <label class="form-label">{__("Email")}</label>
                  <input class="form-control" name="billing_email" type="email" required value="{$user->_data['user_email']}">
                </div>
                <div class="form-group col-md-6">
                  <label class="form-label">{__("Phone")}</label>
                  <input class="form-control" name="billing_phone" type="text" required value="{$user->_data['user_phone']}">
                </div>
                <div class="form-group col-md-6">
                  <label class="form-label">{__("Address")}</label>
                  <input name="billing_address" type="text" class="form-control required">
                </div>
                <div class="form-group col-md-6">
                  <label class="form-label">{__("City")}</label>
                  <input class="form-control" name="billing_city" type="text" required>
                </div>
                <div class="form-group col-md-6">
                  <label class="form-label">{__("State")}</label>
                  <input class="form-control" name="billing_state" type="text" required>
                </div>
                <div class="form-group col-md-6">
                  <label class="form-label">{__("Country")}</label>
                  <select class="form-select"  name="billing_country" required>
                    <option value="none">{__("Select Country")}</option>
                    {foreach $countries as $country}
                      <option {if $user->_data['user_country'] == $country['country_id']}selected{/if} value="{$country['country_name']}">{$country['country_name']}</option>
                    {/foreach}
                  </select>
                </div>
                <div class="form-group col-md-6">
                  <label class="form-label">{__("Zip Code")}</label>
                  <input class="form-control" name="billing_zip_code" type="text" required>
                </div>
              </div>
            </div>
            <!-- error -->
            <div class="alert alert-danger mt15 mb0 x-hidden"></div>
            <!-- error -->
          </div>
          <div class="modal-footer">
            <input type="hidden" name="handle" value="{literal}{{handle}}{/literal}">
            <input type="hidden" name="id" value="{literal}{{id}}{/literal}">
            <input type="hidden" name="price" value="{literal}{{price}}{/literal}">
            <button type="button" class="btn btn-light" data-bs-dismiss="modal">{__("Cancel")}</button>
            <button type="submit" class="btn btn-primary"><i class="fa fa-check-circle mr10"></i>{__("Pay")}</button>
          </div>
        </form>
      </script>
    {/if}
    <!-- Authorize.Net -->

    <!-- Razorpay -->
    {if $system['razorpay_enabled']}
      <script id="razorpay" type="text/template">
        <div class="modal-header">
          <h6 class="modal-title">
            {include file='__svg_icons.tpl' icon="razorpay" class="mr10" width="24px" height="24px"}
            {__("Razorpay")}
          </h6>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <form id="razorpay_form">
          <div class="modal-body">
            <div class="row">
              <div class="form-group col-md-6">
                <label class="form-label">{__("Name")}</label>
                <input class="form-control" name="billing_name" type="text" required value="{$user->_data['user_fullname']}" />
              </div>
              <div class="form-group col-md-6">
                <label class="form-label">{__("Email")}</label>
                <input class="form-control" name="billing_email" type="email" required value="{$user->_data['user_email']}" />
              </div>
              <div class="form-group col-md-6">
                <label class="form-label">{__("Phone")}</label>
                <input class="form-control" name="billing_phone" type="text" required value="{$user->_data['user_phone']}" />
              </div>
            </div>
            <!-- error -->
            <div class="alert alert-danger mt15 mb0 x-hidden"></div>
            <!-- error -->
          </div>
          <div class="modal-footer">
            <input type="hidden" name="handle" value="{literal}{{handle}}{/literal}" />
            <input type="hidden" name="id" value="{literal}{{id}}{/literal}" />
            <input type="hidden" name="price" value="{literal}{{price}}{/literal}" />
            <input type="hidden" name="total" value="{literal}{{total}}{/literal}" />
            <button type="button" class="btn btn-light" data-bs-dismiss="modal">{__("Cancel")}</button>
            <button type="submit" class="btn btn-primary"><i class="fa fa-check-circle mr10"></i>{__("Pay")}</button>
          </div>
        </form>
      </script>
    {/if}
    <!-- Razorpay -->

    <!-- Cashfree -->
    {if $system['cashfree_enabled']}
      <script id="cashfree" type="text/template">
        <div class="modal-header">
          <h6 class="modal-title">
            {include file='__svg_icons.tpl' icon="cashfree" class="mr10" width="24px" height="24px"}
            {__("Cashfree")}
          </h6>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <form id="cashfree_form">
          <div class="modal-body">
            <div class="row">
              <div class="form-group col-md-6">
                <label class="form-label">{__("Name")}</label>
                <input class="form-control" name="billing_name" type="text" required value="{$user->_data['user_fullname']}" />
              </div>
              <div class="form-group col-md-6">
                <label class="form-label">{__("Email")}</label>
                <input class="form-control" name="billing_email" type="email" required value="{$user->_data['user_email']}" />
              </div>
              <div class="form-group col-md-6">
                <label class="form-label">{__("Phone")}</label>
                <input class="form-control" name="billing_phone" type="text" required value="{$user->_data['user_phone']}" />
              </div>
            </div>
            <!-- error -->
            <div class="alert alert-danger mt15 mb0 x-hidden"></div>
            <!-- error -->
          </div>
          <div class="modal-footer">
            <input type="hidden" name="handle" value="{literal}{{handle}}{/literal}" />
            <input type="hidden" name="id" value="{literal}{{id}}{/literal}" />
            <input type="hidden" name="price" value="{literal}{{price}}{/literal}" />
            <button type="button" class="btn btn-light" data-bs-dismiss="modal">{__("Cancel")}</button>
            <button type="submit" class="btn btn-primary"><i class="fa fa-check-circle mr10"></i>{__("Pay")}</button>
          </div>
        </form>
      </script>
    {/if}
    <!-- Cashfree -->

    <!-- Bank Transfer -->
    {if $system['bank_transfers_enabled']}
      <script id="bank-transfer" type="text/template">
        <div class="modal-header">
          <h6 class="modal-title">
            {include file='__svg_icons.tpl' icon="bank" class="main-icon mr10" width="24px" height="24px"}
            {__("Bank Transfer")}
          </h6>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <form class="js_ajax-forms" data-url="payments/bank.php">
          <div class="modal-body">
            <div class="page-header rounded bank-transfer mb30">
              <div class="circle-1"></div>
              <div class="circle-2"></div>
              <div class="inner text-left">
                {if $system['bank_name']}<h2 class="mb20"><i class="fa fa-university mr5"></i>{$system['bank_name']}</h2>{/if}
                {if $system['bank_account_number']}
                  <div class="mb10">
                  <div class="bank-info-meta">{$system['bank_account_number']}</div>
                  <span class="bank-info-help">{__("Account Number / IBAN")}</span>
                </div>
                {/if}
                {if $system['bank_account_name']}
                <div class="mb10">
                  <div class="bank-info-meta">{$system['bank_account_name']}</div>
                  <span class="bank-info-help">{__("Account Name")}</span>
                </div>
                {/if}
                {if $system['bank_account_routing'] || $system['bank_account_country']}
                <div class="row mb10">
                  {if $system['bank_account_routing']}
                  <div class="col-md-6">
                    <div class="bank-info-meta">{$system['bank_account_routing']}</div>
                    <span class="bank-info-help">{__("Routing Code")}</span>
                  </div>
                  {/if}
                  {if $system['bank_account_country']}
                  <div class="col-md-6">
                    <div class="bank-info-meta">{$system['bank_account_country']}</div>
                    <span class="bank-info-help">{__("Country")}</span>
                  </div>
                  {/if}
                </div>
                {/if}
              </div>
            </div>
            <div class="alert alert-warning">
              <div class="icon">
                <i class="fa fa-exclamation-triangle fa-2x"></i>
              </div>
              <div class="text">
                {$system['bank_transfer_note']}
              </div>
            </div>
            <div class="row form-group">
              <label class="col-md-3 form-label">
                {__("Bank Receipt")}
              </label>
              <div class="col-md-9">
                <div class="x-image">
                  <button type="button" class="btn-close x-hidden js_x-image-remover" title='{__("Remove")}'>
                  </button>
                  <div class="x-image-loader">
                    <div class="progress x-progress">
                      <div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
                    </div>
                  </div>
                  <i class="fa fa-camera fa-lg js_x-uploader" data-handle="x-image"></i>
                  <input type="hidden" class="js_x-image-input" name="bank_receipt" value="">

                </div>
                <div class="form-text">
                  {__("Please attach your bank receipt")}
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
          <div class="modal-footer">
            <input type="hidden" name="handle" value="{literal}{{handle}}{/literal}">
            <input type="hidden" name="id" value="{literal}{{id}}{/literal}">
            <input type="hidden" name="price" value="{literal}{{price}}{/literal}">
            <button type="button" class="btn btn-light" data-bs-dismiss="modal">{__("Cancel")}</button>
            <button type="submit" class="btn btn-primary"><i class="fa fa-check-circle mr10"></i>{__("Send")}</button>
          </div>
        </form> 
      </script>
    {/if}
    <!-- Bank Transfer -->

    <!-- Auto Connect -->
    {if $page == "admin" && $view == "tools" && $sub_view == "auto-connect"}
      <script id="auto-connect-node" type="text/template">
        <div class="auto-connect-node">
          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("Select")} {literal}{{nodes_name}}{/literal}
            </label>
            <div class="col-md-9">
              <select class="form-select mb10" name="{literal}{{country_field_name}}{/literal}">
                {foreach $countries as $country}
                  <option value="{$country['country_id']}">{$country['country_name']}</option>
                {/foreach}
              </select>
              <input type="text" class="js_tagify-ajax-late x-hidden" data-handle="{literal}{{nodes}}{/literal}" name="{literal}{{nodes_field_name}}{/literal}">
              <div class="form-text">
                {__("Search for nodes you want new accounts to auto connect")} {__("to this country")}
              </div>
            </div>
          </div>
        </div>
      </script>
    {/if}
    <!-- Auto Connect -->

  {/if}

{/strip}