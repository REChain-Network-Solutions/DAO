{strip}

  <!-- Initialize -->
  <script>
    /* initialize vars */
    var site_title = "{__($system['system_title'])}";
    var site_path = "{$system['system_url']}";
    var ajax_path = site_path + "/includes/ajax/";
    var uploads_path = "{$system['system_uploads']}";
    var current_page = "{$page}";
    var system_version = "{$system['system_version']}";
    var system_debugging_mode = {if $system['DEBUGGING']}true{else}false{/if};
    var smooth_infinite_scroll = {if $system['smooth_infinite_scroll']}true{else}false{/if};
    var newsfeed_results = "{$system['newsfeed_results']}";
    /* language */
    var system_langauge_dir = "{strtolower($system['language']['dir'])}";
    var system_langauge_code = "{substr($system['language']['code'], 0, -3)}";
    /* datetime */
    var system_datetime_format = {if $system['system_datetime_format'] == "m/d/Y H:i"}'MM/DD/YYYY HH:mm'{else}'DD/MM/YYYY HH:mm'{/if};
    /* theme */
    var theme_mode_night = {if $system['theme_mode_night']}true{else}false{/if};
    var theme_dir_rtl = {if $system['language']['dir'] == "LTR"}false{else}true{/if};
    /* payments */
    var currency = "{$system['system_currency']}";
    var stripe_key = {if $system['stripe_mode'] == "live"}"{$system['stripe_live_publishable']}"{else}"{$system['stripe_test_publishable']}"{/if};
    var stripe_payment_element_enabled = {if $system['stripe_payment_element_enabled']}true{else}false{/if};
    var twocheckout_merchant_code = "{$system['2checkout_merchant_code']}";
    var twocheckout_publishable_key = "{$system['2checkout_publishable_key']}";
    var razorpay_key = "{$system['razorpay_key_id']}";
    var shift4_key = "{$system['shift4_api_key']}";
    var cashfree_mode = {if $system['cashfree_mode'] == "sandbox"}"sandbox"{else}"production"{/if};
    var epayco_key = "{$system['epayco_public_key']}";
    var epayco_test = {if $system['epayco_mode'] == "test"}true{else}false{/if};
    /* features */
    var adblock_detector = {if !$user->_is_admin && $system['adblock_detector_enabled']}true{else}false{/if};
    var location_finder = {if !$user->_is_admin && $system['location_finder_enabled']}true{else}false{/if};
    var desktop_infinite_scroll = {if $system['desktop_infinite_scroll']}true{else}false{/if};
    var mobile_infinite_scroll = {if $system['mobile_infinite_scroll']}true{else}false{/if};
    var fluid_videos_enabled = {if $system['fluid_videos_enabled']}true{else}false{/if};
    var read_more_lines = {$system['posts_read_more_lines']|default:5};
    var auto_play_videos = {if $system['auto_play_videos']}true{else}false{/if};
    var disable_yt_player = {if $system['disable_yt_player']}true{else}false{/if};
    {if $user->_logged_in}
      /* user */
      var user_id = "{$user->_data['user_id']}";
      var user_fullname = "{if $system['show_usernames_enabled']}{$user->_data['user_name']}{else}{$user->_data['user_firstname']} {$user->_data['user_lastname']}{/if}";
      /* ajax */
      var min_data_heartbeat = "{$system['data_heartbeat']*1000}";
      var min_chat_heartbeat = "{$system['chat_heartbeat']*1000}";
      /* uploads */
      var secret = "{$secret}";
      var allow_heif_images = {if $system['allow_heif_images']}true{else}false{/if};
      var accpeted_image_extensions = ".png, .gif, .jpeg, .jpg, .webp";
      if (allow_heif_images) {
        accpeted_image_extensions += ", .heic, .heif";
      }
      var accpeted_video_extensions = "{$system['accpeted_video_extensions']}";
      var video_minimum_duration = "{$system['video_minimum_duration']}";
      var video_maximum_duration = "{$system['video_maximum_duration']}";
      var reels_minimum_duration = "{$system['reels_minimum_duration']}";
      var reels_maximum_duration = "{$system['reels_maximum_duration']}";
      var accpeted_audio_extensions = "{$system['accpeted_audio_extensions']}";
      var accpeted_file_extensions = "{$system['accpeted_file_extensions']}";
      var tinymce_photos_enabled = {if $system['tinymce_photos_enabled']}true{else}false{/if};
      var cover_crop_enabled = {if $system['cover_crop_enabled']}true{else}false{/if};
      var chunk_upload_size = "{$system['chunk_upload_size']}";
      /* chat */
      var chat_enabled = {if $system['chat_enabled'] && $user->_data['user_privacy_chat'] != "me"}true{else}false{/if};
      var chat_socket_enabled = {if $system['chat_socket_enabled']}true{else}false{/if};
      {if $system['chat_socket_enabled']}
        var chat_socket_port = "{$system['chat_socket_port']}";
        var chat_socket_path = window.location.protocol + "//" + window.location.hostname {if !$system['chat_socket_proxied']} + ":" + chat_socket_port{/if};
      {/if}
      {if $system['redirect_to_mobile_apps']}
        var messaging_app_android_link = "{$system['messaging_app_android_link']}";
        var messaging_app_ios_link = "{$system['messaging_app_ios_link']}";
      {/if}
      var chat_typing_enabled = {if $system['chat_typing_enabled']}true{else}false{/if};
      var chat_seen_enabled = {if $system['chat_seen_enabled']}true{else}false{/if};
      var chat_max_media = {if $system['chat_max_media'] >= 1}{$system['chat_max_media']}{else}10{/if};
      var chat_sound = {if $user->_data['chat_sound']}true{else}false{/if};
      /* audio/video calls */
      var audio_video_provider = "{$system['audio_video_provider']}";
      var livekit_ws_url = "{$system['livekit_ws_url']}";
      var agora_call_app_id = "{$system['agora_call_app_id']}";
      var agora_sdk_url = "https://download.agora.io/sdk/release/AgoraRTC_N-4.24.9.js";
      var livekit_sdk_url = "https://cdn.jsdelivr.net/npm/livekit-client@2.22.4/dist/livekit-client.umd.min.js";
      /* live */
      var live_enabled = {if $system['live_enabled']}true{else}false{/if};
      {if $system['live_enabled']}
        var live_provider = "{if $system['live_provider'] == "livekit"}livekit{else}agora{/if}";
        var agora_app_id = "{$system['agora_app_id']}";
        var livekit_live_ws_url = "{$system['livekit_live_ws_url']}";
        {if $page == "live" && $view == "create"}
          {if $system['live_provider'] == "livekit"}
            var livekit_live_token = "{$livekit['token']}";
            var livekit_live_room = "{$livekit['room']}";
          {else}
            var agora_uid = {$agora['uid']};
            var agora_token = "{$agora['token']}";
            var agora_channel_name = "{$agora['channel_name']}";
          {/if}
        {/if}
      {/if}
      /* notifications */
      var notifications_sound = {if $user->_data['notifications_sound']}true{else}false{/if};
      var noty_notifications_enabled = {if $system['noty_notifications_enabled']}true{else}false{/if};
      var browser_notifications_enabled = {if $system['browser_notifications_enabled']}true{else}false{/if};
      /* stories */
      {if $system['stories_enabled']}
        var stories_composer_script = "{$system['system_url']}/includes/assets/js/core/stories-composer.js?v={$system['system_version']}-{filemtime('includes/assets/js/core/stories-composer.js')}";
      {/if}
      /* posts */
      var daytime_msg_enabled = {if $daytime_msg_enabled}true{else}false{/if};
      var giphy_key = "{$system['giphy_key']}";
      var geolocation_enabled = {if $system['geolocation_enabled']}true{else}false{/if};
      var geolocation_provider = "{$system['geolocation_provider']}";
      var geolocation_osm_url = "{$system['geolocation_osm_url']}";
      var post_translation_enabled = {if $system['post_translation_enabled']}true{else}false{/if};
      var chat_translation_enabled = {if $system['chat_translation_enabled']}true{else}false{/if};
      var voice_notes_durtaion = "{$system['voice_notes_durtaion']}";
      var voice_notes_encoding = "{$system['voice_notes_encoding']}";
      /* AI */
      {if $system['ai_text_credit_enabled'] || $system['ai_image_credit_enabled']}
        var ai_credit_cost = "{$system['ai_credit_cost']}";
      {/if}
    {/if}
  </script>
  {include file='_js_i18n.tpl'}
  <!-- Initialize -->

  <!-- jQuery -->
  <script src="{$system['system_url']}/node_modules/jquery/dist/jquery.min.js"></script>
  <!-- jQuery -->

  <!-- FlyonUI -->
  <script src="{$system['system_url']}/node_modules/flyonui/flyonui.js" defer></script>
  <!-- FlyonUI -->

  <!-- Dependencies Plugins -->
  <script src="{$system['system_url']}/node_modules/mustache/mustache.min.js" defer></script>
  <script src="{$system['system_url']}/node_modules/autosize/dist/autosize.min.js" defer></script>
  <script src="{$system['system_url']}/node_modules/moment/min/moment.min.js" defer></script>
  {$_moment_locale = $system['language']['code']|replace:'_':'-'|strtolower}
  {if !is_file("node_modules/moment/locale/`$_moment_locale`.js")}{$_moment_locale = substr($_moment_locale, 0, 2)}{/if}
  {if is_file("node_modules/moment/locale/`$_moment_locale`.js")}
    <script src="{$system['system_url']}/node_modules/moment/locale/{$_moment_locale}.js" defer></script>
  {/if}
  <script src="{$system['system_url']}/node_modules/plyr/dist/plyr.min.js" defer></script>

  {if $user->_logged_in}
    <!-- Sortable -->
    <script src="{$system['system_url']}/node_modules/sortablejs/Sortable.min.js" defer></script>
    <!-- Sortable -->

    <!-- Geocomplete -->
    {if $system['geolocation_enabled'] && $system['geolocation_provider'] != "openstreetmap"}
      <script src="https://maps.googleapis.com/maps/api/js?key={$system['geolocation_key']}&loading=async&v=beta" async></script>
    {/if}
    <!-- Geocomplete -->

    <!-- Crop Profile Picture & Reposition Cover Photo -->
    {if in_array($page, ["started", "profile", "page", "group", "event"])}
      <script src="{$system['system_url']}/node_modules/rcrop/dist/rcrop.min.js" defer></script>
    {/if}
    <!-- Crop Profile Picture & Reposition Cover Photo -->

    <!-- Voice Notes -->
    {if $system['voice_notes_posts_enabled'] || $system['voice_notes_comments_enabled'] || $system['voice_notes_chat_enabled']}
      <script src="{$system['system_url']}/node_modules/web-audio-recorder-js/lib-minified/WebAudioRecorder.min.js" defer></script>
    {/if}
    <!-- Voice Notes -->

    <!-- TinyMCE -->
    {if $user->_data['can_add_rich_text_posts'] || in_array($page, ["admin", "blogs", "forums", "support"])}
      <script src="{$system['system_url']}/node_modules/tinymce/tinymce.min.js" defer></script>
    {/if}
    <!-- TinyMCE -->

    <!-- Quill.js -->
    <script src="{$system['system_url']}/node_modules/quill/dist/quill.js" defer></script>
    <script src="{$system['system_url']}/node_modules/quill-mention/dist/quill.mention.min.js" defer></script>
    <!-- Quill.js -->

    <!-- Stripe & 2Checkout & Razorpay & Shift4 & Cashfree & Epayco -->
    {if in_array($page, ["index", "packages", "ads", "wallet", "market", "profile", "page", "group", "post", "directory", "search", "movies"])}
      {if $system['creditcard_enabled']}
        <script src="https://js.stripe.com/v3" defer></script>
      {/if}
      {if $system['2checkout_enabled']}
        <script src="https://www.2checkout.com/checkout/api/2co.min.js" defer></script>
      {/if}
      {if $system['razorpay_enabled']}
        <script src="https://checkout.razorpay.com/v1/checkout.js" defer></script>
      {/if}
      {if $system['shift4_enabled']}
        <script src="https://js.dev.shift4.com/checkout.js" defer></script>
      {/if}
      {if $system['cashfree_enabled']}
        <script src="https://sdk.cashfree.com/js/v3/cashfree.js" defer></script>
      {/if}
      {if $system['epayco_enabled']}
        <script src="https://checkout.epayco.co/checkout.js" defer></script>
      {/if}
    {/if}
    <!-- Stripe & 2Checkout & Razorpay & Shift4 & Cashfree & Epayco -->

    <!-- (Twillio|LiveKit) [Audio/Video Calls] -->
    {if $system['audio_call_enabled'] || $system['video_call_enabled']}
      {if $system['audio_video_provider'] == "twilio"}
        <script src="https://sdk.twilio.com/js/video/releases/2.36.1/twilio-video.min.js" defer></script>
      {/if}
      {if $system['audio_video_provider'] == "livekit"}
        <script src="https://cdn.jsdelivr.net/npm/livekit-client@2.22.4/dist/livekit-client.umd.min.js" defer></script>
      {/if}
    {/if}
    <!-- (Twillio|LiveKit) [Audio/Video Calls] -->

    <!-- (Agora|LiveKit) [Live Streaming] -->
    {if $system['live_enabled'] && $page == "live" && $view == "create"}
      {if $system['live_provider'] == "livekit"}
        {if !(($system['audio_call_enabled'] || $system['video_call_enabled']) && $system['audio_video_provider'] == "livekit")}
          <script src="https://cdn.jsdelivr.net/npm/livekit-client@2.22.4/dist/livekit-client.umd.min.js" defer></script>
        {/if}
      {else}
        <script src="https://download.agora.io/sdk/release/AgoraRTC_N-4.24.9.js" defer></script>
      {/if}
    {/if}
    <!-- (Agora|LiveKit) [Live Streaming] -->

    <!-- Datatables -->
    {if in_array($page, ["admin", "ads", "developers", "settings", "page", "group"])}
      <script src="{$system['system_url']}/node_modules/datatables.net/js/dataTables.min.js" defer></script>
      <script src="{$system['system_url']}/node_modules/flyonui/dist/datatable.js" defer></script>
    {/if}
    <!-- Datatables -->

    <!-- Tagify -->
    <script src="{$system['system_url']}/node_modules/@yaireo/tagify/dist/tagify.js" defer></script>
    <!-- Tagify -->

    <!-- HTML2PDF -->
    {if $page == "market"}
      <script src="https://cdn.jsdelivr.net/npm/html2canvas-pro@2.5.2/dist/html2canvas-pro.min.js" defer></script>
      <script src="https://cdn.jsdelivr.net/npm/html2pdf.js@0.14.0/dist/html2pdf.min.js" defer></script>
    {/if}
    <!-- HTML2PDF -->
  {/if}
  <!-- Dependencies Plugins -->

  <!-- System [JS] -->
  {theme_assets entry='emojis'}
  <script src="{$system['system_url']}/includes/assets/js/core/core.js?v={$system['system_version']}-{filemtime('includes/assets/js/core/core.js')}" defer></script>
  {if $page != "admin"}
    <script src="{$system['system_url']}/content/themes/{$system['theme']}/js/site-header.js?v={$system['system_version']}-{"content/themes/`$system.theme`/js/site-header.js"|filemtime}" defer></script>
  {/if}
  {if in_array($page, ["movies", "games"])}
    <script src="{$system['system_url']}/content/themes/{$system['theme']}/js/media.js?v={$system['system_version']}-{"content/themes/`$system.theme`/js/media.js"|filemtime}" defer></script>
  {/if}
  {if $user->_logged_in}
    <script src="{$system['system_url']}/includes/assets/js/core/user.js?v={$system['system_version']}-{filemtime('includes/assets/js/core/user.js')}" defer></script>
    <script src="{$system['system_url']}/includes/assets/js/core/post.js?v={$system['system_version']}-{filemtime('includes/assets/js/core/post.js')}" defer></script>
    {if $licence_monetization && is_file('includes/assets/js/core/payments.js')}
      <script src="{$system['system_url']}/includes/assets/js/core/payments.js?v={$system['system_version']}-{filemtime('includes/assets/js/core/payments.js')}" defer></script>
    {/if}
    {if $system['chat_enabled']}
      {if $system['chat_socket_enabled']}
        {if $system['chat_socket_server'] == "php"}
          <script src="https://cdnjs.cloudflare.com/ajax/libs/socket.io/2.5.0/socket.io.js" defer></script>
        {/if}
        {if $system['chat_socket_server'] == "nodejs"}
          <script src="https://cdnjs.cloudflare.com/ajax/libs/socket.io/4.8.4/socket.io.min.js" defer></script>
        {/if}
      {/if}
      <script src="{$system['system_url']}/includes/assets/js/core/chat.js?v={$system['system_version']}-{filemtime('includes/assets/js/core/chat.js')}" defer></script>
    {/if}
    {if $system['live_enabled'] && $page == "live" && $view == "create"}
      <script src="{$system['system_url']}/includes/assets/js/core/live.js?v={$system['system_version']}-{filemtime('includes/assets/js/core/live.js')}" defer></script>
    {/if}
  {else}
    <script src="{$system['system_url']}/includes/assets/js/core/login.js?v={$system['system_version']}-{filemtime('includes/assets/js/core/login.js')}" defer></script>
  {/if}
  {if $user->_logged_in && $system['stories_enabled']}
    <script src="{$system['system_url']}/includes/assets/js/core/stories.js?v={$system['system_version']}-{filemtime('includes/assets/js/core/stories.js')}" defer></script>
  {/if}
  {if $page == "dating"}
    <script src="{$system['system_url']}/includes/assets/js/core/dating.js?v={$system['system_version']}-{filemtime('includes/assets/js/core/dating.js')}" defer></script>
  {/if}
  {if $page == "reels"}
    <script src="{$system['system_url']}/includes/assets/js/core/reels.js?v={$system['system_version']}-{filemtime('includes/assets/js/core/reels.js')}" defer></script>
  {/if}
  <!-- System [JS] -->

  {if $page == "admin"}
    <!-- CodeMirror -->
    {if $view == "design" || ($view == "themes" && ($sub_view == "add" || $sub_view == "edit")) || ($view == "settings" && $sub_view == "uploads")}
      <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.21/codemirror.min.js" integrity="sha512-2GhuAIxcoXqN+nBSa8DZSpChVQNliC1wHHgTE6BEkISu+0+3ywUEF5RJrmWyD67Kxm6XjJkULfpU8hdzLMuFhA==" crossorigin="anonymous" referrerpolicy="no-referrer" defer></script>
      <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.21/mode/css/css.min.js" integrity="sha512-MGm8eF2KK4SjMCaW47o79+MO+UnM0x6wG236/AZ9LcOiB+a5BSSeYFKIEj1/Typ4FjFS0fX7teop2/TEMUnNxw==" crossorigin="anonymous" referrerpolicy="no-referrer" defer></script>
      <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.21/mode/javascript/javascript.min.js" integrity="sha512-k1xN8Ok3EjJVqkyue+rrYB9WJi34a101SAdtjJGS4sM0ZSFTb7IBseqeCL4OcKzmQRmtrKIYqVROZYIpHXc3Mg==" crossorigin="anonymous" referrerpolicy="no-referrer" defer></script>
    {/if}
    <!-- CodeMirror -->

    <!-- ApexCharts -->
    {if $view == "dashboard" || $view == "earnings"}
      <script src="{$system['system_url']}/node_modules/apexcharts/dist/apexcharts.min.js" defer></script>
      {if $view == "dashboard"}
        <script src="{$system['system_url']}/content/themes/{$system['theme']}/js/admin-dashboard.js?v={$system['system_version']}-{"content/themes/`$system.theme`/js/admin-dashboard.js"|filemtime}" defer></script>
      {elseif $view == "earnings"}
        <script src="{$system['system_url']}/content/themes/{$system['theme']}/js/admin-earnings.js?v={$system['system_version']}-{"content/themes/`$system.theme`/js/admin-earnings.js"|filemtime}" defer></script>
      {/if}
    {/if}
    <!-- ApexCharts -->

    <!-- Admin Layout -->
    <script src="{$system['system_url']}/content/themes/{$system['theme']}/js/admin-layout.js?v={$system['system_version']}-{"content/themes/`$system.theme`/js/admin-layout.js"|filemtime}" defer></script>
    <!-- Admin Layout -->

    <script src="{$system['system_url']}/includes/assets/js/core/admin.js?v={$system['system_version']}-{filemtime('includes/assets/js/core/admin.js')}" defer></script>
    {include file='_admin_charts.tpl'}
  {/if}

  <!-- Cookies Consent -->
  {if $system['cookie_consent_enabled']}
    <script src="{$system['system_url']}/node_modules/vanilla-cookieconsent/dist/cookieconsent.umd.js" defer></script>
    <script>
      window.addEventListener("load", function() {
        if (theme_mode_night) {
          document.documentElement.classList.add('cc--darkmode');
        }
        CookieConsent.run({
          categories: {
            necessary: {
              enabled: true,
              readOnly: true
            },
            analytics: {}
          },
          guiOptions: {
            consentModal: {
              layout: 'box',
              position: (theme_dir_rtl) ? 'bottom left' : 'bottom right',
              flipButtons: false,
              equalWeightButtons: true
            },
            preferencesModal: {
              layout: 'box',
              flipButtons: false,
              equalWeightButtons: true
            },
          },
          language: {
            default: system_langauge_code,
            translations: {
              [system_langauge_code]: {
                consentModal: {
                  title: '🍪 ' + __['We use cookies'],
                  description: __['We use cookies to improve your experience. You can accept, reject, or manage preferences.'],
                  acceptAllBtn: __['Accept all'],
                  acceptNecessaryBtn: __['Reject non-essential'],
                  showPreferencesBtn: __['Manage preferences']
                },
                preferencesModal: {
                  title: __['Consent Preferences Center'],
                  acceptAllBtn: __['Accept all'],
                  acceptNecessaryBtn: __['Reject non-essential'],
                  savePreferencesBtn: __['Save preferences'],
                  closeIconLabel: __['Close'],
                  sections: [{
                      title: __['Cookie Usage'],
                      description: __['Essential cookies are always on. Choose if you want analytics cookies too.']
                    },
                    {
                      title: __['Strictly Necessary cookies'],
                      description: __['These cookies are essential for the proper functioning of the website and cannot be disabled.'],
                      linkedCategory: 'necessary'
                    },
                    {
                      title: __['Analytics cookies'],
                      description: __['These cookies collect information about how you use our website. All of the data is anonymized and cannot be used to identify you.'],
                      linkedCategory: 'analytics'
                    },
                    {
                      title: __['More information'],
                      description: __['For any queries in relation to my policy on cookies and your choices,'] + ' <a href="' + site_path + '/contacts">' + __['Contact Us'] + '</a>'
                    }
                  ]
                }
              }
            }
          }
        });
      });
    </script>
  {/if}
  <!-- Cookies Consent -->

  <!-- OneSignal Notifications -->
  {if $user->_logged_in && $page != "reels" && $system['onesignal_notification_enabled']}
    <script src="https://cdn.onesignal.com/sdks/OneSignalSDK.js" async=""></script>
    <script>
      var onesignal_app_id = "{$system['onesignal_app_id']}";
      var onesignal_user_id = "{$user->_data['onesignal_user_id']}";
      var onesignal_push_id = "";
      var OneSignal = window.OneSignal || [];

      function saveAndroidOneSignalUserId(android_onesignal_user_id) {
        $.post(api['users/push_notifications'], { handle: 'update_android', id: android_onesignal_user_id });
      }

      function saveIOSOneSignalUserId(io_onesignal_user_id) {
        $.post(api['users/push_notifications'], { handle: 'update_ios', id: io_onesignal_user_id });
      }

      document.addEventListener('DOMContentLoaded', function() {
        OneSignal.push(function() {
          OneSignal.init({
            appId: onesignal_app_id,
            autoResubscribe: false,
            notifyButton: {
              enable: {if $system['onesignal_notify_button_enabled']}true{else}false{/if},
              /* Required to use the Subscription Bell */
              size: 'medium',
              /* One of 'small', 'medium', or 'large' */
              theme: 'default',
              /* One of 'default' (red-white) or 'inverse" (white-red) */
              position: (theme_dir_rtl) ? 'bottom-right' : 'bottom-left',
              /* Either 'bottom-left' or 'bottom-right' */
              offset: {
                bottom: '100px',
                left: '20px',
                /* Only applied if bottom-left */
                right: '20px' /* Only applied if bottom-right */
              },
              prenotify: true,
              /* Show an icon with 1 unread message for first-time site visitors */
              showCredit: false,
              /* Hide the OneSignal logo */
              text: {
                'tip.state.unsubscribed': __['Subscribe to notifications'],
                'tip.state.subscribed': __['You are subscribed to notifications'],
                'tip.state.blocked': __['You have blocked notifications'],
                'message.prenotify': __['Click to subscribe to notifications'],
                'message.action.subscribed': __['Thanks for subscribing!'],
                'message.action.resubscribed': __['You are subscribed to notifications'],
                'message.action.unsubscribed': __['You will not receive notifications again'],
                'dialog.main.title': __['Manage Site Notifications'],
                'dialog.main.button.subscribe': __['SUBSCRIBE'],
                'dialog.main.button.unsubscribe': __['UNSUBSCRIBE'],
                'dialog.blocked.title': __['Unblock Notifications'],
                'dialog.blocked.message': __['Follow these instructions to allow notifications:']
              },
              colors: {
                'circle.background': 'rgb(84,110,123)',
                'circle.foreground': 'white',
                'badge.background': 'rgb(84,110,123)',
                'badge.foreground': 'white',
                'badge.bordercolor': 'white',
                'pulse.color': 'white',
                'dialog.button.background.hovering': 'rgb(77, 101, 113)',
                'dialog.button.background.active': 'rgb(70, 92, 103)',
                'dialog.button.background': 'rgb(84,110,123)',
                'dialog.button.foreground': 'white'
              },
            },
            allowLocalhostAsSecureOrigin: true,
          });
          OneSignal.getUserId(function(userId) {
            onesignal_push_id = userId;
            if (userId != onesignal_user_id) {
              $.post(api['users/push_notifications'], { handle: 'update', id: onesignal_push_id });
            }
          });
          OneSignal.on('subscriptionChange', function(isSubscribed) {
            if (isSubscribed == false) {
              $.post(api['users/push_notifications'], { handle: 'delete' });
            } else {
              $.post(api['users/push_notifications'], { handle: 'update', id: onesignal_push_id });
            }
          });
        });
      });
    </script>
  {/if}
  <!-- OneSignal Notifications -->

  <!-- Mouse Right Click Disabled -->
  {if $system['right_click_disabled']}
    <script>
      document.addEventListener('contextmenu', event => event.preventDefault());
    </script>
  {/if}
  <!-- Mouse Right Click Disabled -->

{/strip}
