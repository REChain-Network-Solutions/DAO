{strip}

<!-- Initialize -->
<script type="text/javascript">
    /* initialize vars */
    var site_title = "{$system['system_title']}";
    var site_path = "{$system['system_url']}";
    var ajax_path = site_path+"/includes/ajax/";
    var uploads_path = "{$system['system_uploads']}";
    var current_page = "{$page}";
    var secret = "{$secret}";
    var min_data_heartbeat = "{$system['data_heartbeat']*1000}";
    var min_chat_heartbeat = "{$system['chat_heartbeat']*1000}";
    var chat_enabled = {if $system['chat_enabled']}true{else}false{/if};
    var daytime_msg_enabled = {if $daytime_msg_enabled}true{else}false{/if};
    var browser_notifications_enabled = {if $system['browser_notifications_enabled']}true{else}false{/if};
    var noty_notifications_enabled = {if $system['noty_notifications_enabled']}true{else}false{/if};
    var giphy_key = "{$system['giphy_key']}";
    var geolocation_enabled = {if $system['geolocation_enabled']}true{else}false{/if};
    var post_translation_enabled = {if $system['post_translation_enabled']}true{else}false{/if};
    var yandex_key = "{$system['yandex_key']}";
    var chat_sound = {if $user->_data['chat_sound']}true{else}false{/if};
    var notifications_sound = {if $user->_data['notifications_sound']}true{else}false{/if};
    var currency = "{$system['system_currency']}";
    var stripe_key = {if $system['stripe_mode'] == "live"}"{$system['stripe_live_publishable']}"{else}"{$system['stripe_test_publishable']}"{/if};
    var adblock_detector = {if !$user->_is_admin && $system['adblock_detector_enabled']}true{else}false{/if};
    var theme_mode_night = {if $system['theme_mode_night']}true{else}false{/if};
    var theme_dir_rtl = {if $system['language']['dir'] == "LTR"}false{else}true{/if};
</script>
<script type="text/javascript">
    /* i18n for JS */
    var __ = [];
    __["Ask something"] = "{__('Ask something')}";
    __["Add Friend"] = "{__('Add Friend')}";
    __["Friends"] = "{__('Friends')}";
    __["Friend Request Sent"] = "{__('Friend Request Sent')}";
    __["Following"] = "{__('Following')}";
    __["Follow"] = "{__('Follow')}";
    __["Pending"] = "{__('Pending')}";
    __["Remove"] = "{__('Remove')}";
    __["Error"] = "{__('Error')}";
    __["Success"] = "{__('Success')}";
    __["Loading"] = "{__('Loading')}";
    __["Like"] = "{__('Like')}";
    __["Unlike"] = "{__('Unlike')}";
    __["Joined"] = "{__('Joined')}";
    __["Join"] = "{__('Join')}";
    __["Remove Admin"] = "{__('Remove Admin')}";
    __["Make Admin"] = "{__('Make Admin')}";
    __["Going"] = "{__('Going')}";
    __["Interested"] = "{__('Interested')}";
    __["Delete"] = "{__('Delete')}";
    __["Delete Cover"] = "{__('Delete Cover')}";
    __["Delete Picture"] = "{__('Delete Picture')}";
    __["Delete Post"] = "{__('Delete Post')}";
    __["Delete Comment"] = "{__('Delete Comment')}";
    __["Delete Conversation"] = "{__('Delete Conversation')}";
    __["Report"] = "{__('Report')}";
    __["Block User"] = "{__('Block User')}";
    __["Unblock User"] = "{__('Unblock User')}";
    __["Mark as Available"] = "{__('Mark as Available')}";
    __["Mark as Sold"] = "{__('Mark as Sold')}";
    __["Save Post"] = "{__('Save Post')}";
    __["Unsave Post"] = "{__('Unsave Post')}";
    __["Boost Post"] = "{__('Boost Post')}";
    __["Unboost Post"] = "{__('Unboost Post')}";
    __["Pin Post"] = "{__('Pin Post')}";
    __["Unpin Post"] = "{__('Unpin Post')}";
    __["Verify"] = "{__('Verify')}";
    __["Decline"] = "{__('Decline')}";
    __["Boost"] = "{__('Boost')}";
    __["Unboost"] = "{__('Unboost')}";
    __["Mark as Paid"] = "{__('Mark as Paid')}";
    __["Read more"] = "{__('Read more')}";
    __["Read less"] = "{__('Read less')}";
    __['Turn On Chat'] = "{__('Turn On Chat')}";
    __['Turn Off Chat'] = "{__('Turn Off Chat')}";
    __["Monthly Average"] = "{__('Monthly Average')}";
    __["Jan"] = "{__('Jan')}";
    __["Feb"] = "{__('Feb')}";
    __["Mar"] = "{__('Mar')}";
    __["Apr"] = "{__('Apr')}";
    __["May"] = "{__('May')}";
    __["Jun"] = "{__('Jun')}";
    __["Jul"] = "{__('Jul')}";
    __["Aug"] = "{__('Aug')}";
    __["Sep"] = "{__('Sep')}";
    __["Oct"] = "{__('Oct')}";
    __["Nov"] = "{__('Nov')}";
    __["Dec"] = "{__('Dec')}";
    __["Users"] = "{__('Users')}";
    __["Pages"] = "{__('Pages')}";
    __["Groups"] = "{__('Groups')}";
    __["Events"] = "{__('Events')}";
    __["Posts"] = "{__('Posts')}";
    __["Translated"] = "{__('Translated')}";
    __["Are you sure you want to delete this?"] = "{__('Are you sure you want to delete this?')}";
    __["Are you sure you want to remove your cover photo?"] = "{__('Are you sure you want to remove your cover photo?')}";
    __["Are you sure you want to remove your profile picture?"] = "{__('Are you sure you want to remove your profile picture?')}";
    __["Are you sure you want to delete this post?"] = "{__('Are you sure you want to delete this post?')}";
    __["Are you sure you want to delete this comment?"] = "{__('Are you sure you want to delete this comment?')}";
    __["Are you sure you want to delete this conversation?"] = "{__('Are you sure you want to delete this conversation?')}";
    __["Are you sure you want to report this?"] = "{__('Are you sure you want to report this?')}";
    __["Are you sure you want to block this user?"] = "{__('Are you sure you want to block this user?')}";
    __["Are you sure you want to unblock this user?"] = "{__('Are you sure you want to unblock this user?')}";
    __["Are you sure you want to delete your account?"] = "{__('Are you sure you want to delete your account?')}";
    __["Are you sure you want to verify this request?"] = "{__('Are you sure you want to verify this request?')}";
    __["Are you sure you want to decline this request?"] = "{__('Are you sure you want to decline this request?')}";
    __["Are you sure you want to approve this request?"] = "{__('Are you sure you want to approve this request?')}";
    __["Are you sure you want to do this?"] = "{__('Are you sure you want to do this?')}";
    __["There is something that went wrong!"] = "{__('There is something that went wrong!')}";
    __["There is no more data to show"] = "{__('There is no more data to show')}";
    __["This website uses cookies to ensure you get the best experience on our website"] = "{__('This website uses cookies to ensure you get the best experience on our website')}";
    __["Got It!"] = "{__('Got It!')}";
    __["Learn More"] = "{__('Learn More')}";
    __["No result found"] = "{__('No result found')}";
    __["Turn on Commenting"] = "{__('Turn on Commenting')}";
    __["Turn off Commenting"] = "{__('Turn off Commenting')}";
    __["Day Mode"] = "{__('Day Mode')}";
    __["Night Mode"] = "{__('Night Mode')}";
</script>
<!-- Initialize -->

<!-- Dependencies Libs [jQuery|Bootstrap|Mustache] -->
<script src="https://code.jquery.com/jquery-3.3.1.min.js" integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8=" crossorigin="anonymous" {if !$user->_logged_in}defer{/if}></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous" {if !$user->_logged_in}defer{/if}></script>
{if $system['language']['dir'] == "LTR"}
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous" {if !$user->_logged_in}defer{/if}></script>    
{else}
    <script src="https://cdn.rtlcss.com/bootstrap/v4.2.1/js/bootstrap.min.js" integrity="sha384-a9xOd0rz8w0J8zqj1qJic7GPFfyMfoiuDjC9rqXlVOcGO/dmRqzMn34gZYDTel8k" crossorigin="anonymous" {if !$user->_logged_in}defer{/if}></script>
{/if}
<script src="{$system['system_url']}/includes/assets/js/mustache/mustache.min.js" {if !$user->_logged_in}defer{/if}></script>
<!-- Dependencies Libs [jQuery|Bootstrap|Mustache] -->

<!-- Dependencies Plugins -->
<script src="{$system['system_url']}/includes/assets/js/plugins/fastclick/fastclick.min.js" {if !$user->_logged_in}defer{/if}></script>
<script src="{$system['system_url']}/includes/assets/js/plugins/jquery.form/jquery.form.min.js" {if !$user->_logged_in}defer{/if}></script>
<script src="{$system['system_url']}/includes/assets/js/plugins/jquery.inview/jquery.inview.min.js" {if !$user->_logged_in}defer{/if}></script>
<script src="{$system['system_url']}/includes/assets/js/plugins/jquery.slimscroll/jquery.slimscroll.min.js" {if !$user->_logged_in}defer{/if}></script>
<script src="{$system['system_url']}/includes/assets/js/plugins/autosize/autosize.min.js" {if !$user->_logged_in}defer{/if}></script>
<script src="{$system['system_url']}/includes/assets/js/plugins/readmore/readmore.min.js" {if !$user->_logged_in}defer{/if}></script>
<script src="{$system['system_url']}/includes/assets/js/plugins/moment/moment-with-locales.min.js" {if !$user->_logged_in}defer{/if}></script>
<script src="{$system['system_url']}/includes/assets/js/plugins/mediaelementplayer/mediaelement-and-player.min.js" {if !$user->_logged_in}defer{/if}></script>
<link rel="stylesheet" type='text/css' href="{$system['system_url']}/includes/assets/js/plugins/mediaelementplayer/mediaelementplayer.min.css">

{if $user->_logged_in}

    <!-- jQuery-UI -->
    <script>var _tooltip = jQuery.fn.tooltip;</script>
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js" integrity="sha256-VazP97ZCwtekAsvgPBSUwPFKdrwD3unUfSGVYrahUqU=" crossorigin="anonymous"></script>
    <script>jQuery.fn.tooltip = _tooltip;</script>
    <script src="{$system['system_url']}/includes/assets/js/plugins/jquery-ui.triggeredAutocomplete/jquery-ui.triggeredAutocomplete.js"></script>
    <!-- jQuery-UI -->

    <script src="{$system['system_url']}/includes/assets/js/plugins/sticky-sidebar/theia-sticky-sidebar.min.js"></script>

    {if $system['geolocation_enabled']}
        <script src="{$system['system_url']}/includes/assets/js/plugins/jquery.geocomplete/jquery.geocomplete.min.js"></script>
        <script src="https://maps.googleapis.com/maps/api/js?libraries=places&key={$system['geolocation_key']}"></script>
    {/if}

    {if $system['noty_notifications_enabled']}
        <script src="{$system['system_url']}/includes/assets/js/plugins/noty/noty.min.js"></script>
        <link rel="stylesheet" type='text/css' href="{$system['system_url']}/includes/assets/js/plugins/noty/noty.css">
    {/if}

    <!-- Crop Profile Picture & Reposition Cover Photo -->
    {if $page == "started" || $page == "profile" || $page == "page" || $page == "group" || $page == "event"}
        <script src="{$system['system_url']}/includes/assets/js/plugins/jquery-ui.touch-punch/jquery-ui.touch-punch.min.js"></script>
        <script src="{$system['system_url']}/includes/assets/js/plugins/jquery.imagedrag/jquery.imagedrag.min.js"></script>
        <script src="{$system['system_url']}/includes/assets/js/plugins/rcrop/rcrop.min.js"></script>
        <link rel="stylesheet" type='text/css' href="{$system['system_url']}/includes/assets/js/plugins/rcrop/rcrop.min.css">
    {/if}
    <!-- Crop Profile Picture & Reposition Cover Photo -->

    <!-- Stories -->
    {if $page == "index" && $view == ""}
        <script src="{$system['system_url']}/includes/assets/js/plugins/zuck/zuck.js"></script>
        {if $system['language']['dir'] == "LTR"}
            <link rel="stylesheet" type='text/css' href="{$system['system_url']}/includes/assets/js/plugins/zuck/zuck.css">
        {else}
            <link rel="stylesheet" type='text/css' href="{$system['system_url']}/includes/assets/js/plugins/zuck/zuck.rtl.css">
        {/if}

        <script src="{$system['system_url']}/includes/assets/js/plugins/slick/slick.min.js"></script>
        <link rel="stylesheet" type='text/css' href="{$system['system_url']}/includes/assets/js/plugins/slick/slick.css">
        <link rel="stylesheet" type='text/css' href="{$system['system_url']}/includes/assets/js/plugins/slick/slick-theme.css">
    {/if}
    <!-- Stories -->

    <!-- Slick Slider -->
    {if $page == "index"}
        <script src="{$system['system_url']}/includes/assets/js/plugins/slick/slick.min.js"></script>
        <link rel="stylesheet" type='text/css' href="{$system['system_url']}/includes/assets/js/plugins/slick/slick.css">
        <link rel="stylesheet" type='text/css' href="{$system['system_url']}/includes/assets/js/plugins/slick/slick-theme.css">
    {/if}
    <!-- Slick Slider -->

    <!-- TinyMCE -->
    {if $page == "admin" || $page == "blogs" || $page == "forums"}
        <script src="{$system['system_url']}/includes/assets/js/plugins/tinymce/tinymce.min.js"></script>
    {/if}
    <!-- TinyMCE -->

    <!-- Bootstrap selectpicker & datetimepicker -->
    {if $page == "admin" || $page == "groups" || $page == "group" || $page == "events" || $page == "event" || $page == "ads"}
        <script src="{$system['system_url']}/includes/assets/js/plugins/bootstrap.select/bootstrap-select.min.js"></script>
        <link rel="stylesheet" type='text/css' href="{$system['system_url']}/includes/assets/js/plugins/bootstrap.select/bootstrap-select.min.css">

        <script src="{$system['system_url']}/includes/assets/js/plugins/bootstrap.datetimepicker/bootstrap-datetimepicker.min.js"></script>
        <link rel="stylesheet" type='text/css' href="{$system['system_url']}/includes/assets/js/plugins/bootstrap.datetimepicker/bootstrap-datetimepicker.min.css">
    {/if}
    <!-- Bootstrap selectpicker & datetimepicker -->

    <!-- Stripe -->
    {if $page == "packages" || $page == "ads"}
        <script src="https://checkout.stripe.com/checkout.js"></script>
    {/if}
    <!-- Stripe -->
{/if}
<!-- Dependencies Plugins -->

<!-- Delus [JS] -->
<script src="{$system['system_url']}/includes/assets/js/Delus/core.js" {if !$user->_logged_in}defer{/if}></script>
{if $user->_logged_in}
    <script src="{$system['system_url']}/includes/assets/js/Delus/user.js"></script>
    <script src="{$system['system_url']}/includes/assets/js/Delus/post.js"></script>
    <script src="{$system['system_url']}/includes/assets/js/Delus/chat.js"></script>
    <script src="{$system['system_url']}/includes/assets/js/Delus/showads.js"></script>
{/if}
<!-- Delus [JS] -->

{if $page == "admin"}
    <!-- Dependencies Plugins -->
    <script src="{$system['system_url']}/includes/assets/js/plugins/bootstrap.colorpicker/bootstrap-colorpicker.min.js"></script>
    <link rel="stylesheet" type='text/css' href="{$system['system_url']}/includes/assets/js/plugins/bootstrap.colorpicker/bootstrap-colorpicker.min.css">

    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/v/bs4/dt-1.10.18/datatables.min.css"/>
    <script type="text/javascript" src="https://cdn.datatables.net/v/bs4/dt-1.10.18/datatables.min.js"></script>

    <script src="{$system['system_url']}/includes/assets/js/plugins/jquery.treegrid/jquery.treegrid.min.js"></script>
    <script src="{$system['system_url']}/includes/assets/js/plugins/jquery.treegrid/jquery.treegrid.fontawesome.js"></script>
    <link rel="stylesheet" type='text/css' href="{$system['system_url']}/includes/assets/js/plugins/jquery.treegrid/jquery.treegrid.css">

    <script src="{$system['system_url']}/includes/assets/js/plugins/codemirror/lib/codemirror.js"></script>
    <script src="{$system['system_url']}/includes/assets/js/plugins/codemirror/mode/css/css.js"></script>
    <script src="{$system['system_url']}/includes/assets/js/plugins/codemirror/mode/javascript/javascript.js"></script>
    <link rel="stylesheet" type='text/css' href="{$system['system_url']}/includes/assets/js/plugins/codemirror/lib/codemirror.css">
    <!-- Dependencies Plugins [JS] -->

    <!-- Delus [JS] -->
    <script src="{$system['system_url']}/includes/assets/js/Delus/admin.js"></script>
    <!-- Delus [JS] -->

    <!-- Admin Charts -->
    <script src="https://code.highcharts.com/highcharts.js"></script>
    <script src="https://code.highcharts.com/modules/exporting.js"></script>
    {if $view == "dashboard"}
        <script>
           $(function () {
            Highcharts.setOptions();
            $('#admin-chart-dashboard').highcharts({
                chart: {
                    type: 'column',
                    backgroundColor: 'transparent',
                },
                title: {
                    text: __["Monthly Average"]
                },
                xAxis: {
                    categories: [
                        __["Jan"],
                        __["Feb"],
                        __["Mar"],
                        __["Apr"],
                        __["May"],
                        __["Jun"],
                        __["Jul"],
                        __["Aug"],
                        __["Sep"],
                        __["Oct"],
                        __["Nov"],
                        __["Dec"]
                    ],
                    crosshair: true
                },
                yAxis: {
                    min: 0,
                    title: {
                        text: "{'Y'|date}"
                    }
                },
                tooltip: {
                    headerFormat: '<span style="font-size:10px">{literal}{point.key}{/literal}</span><table>',
                    pointFormat: '<tr><td style="color:{literal}{series.color}{/literal};padding:0">{literal}{series.name}{/literal}: </td>' +
                        '<td style="padding:0"><b>{literal}{point.y}{/literal}</b></td></tr>',
                    footerFormat: '</table>',
                    shared: true,
                    useHTML: true
                },
                plotOptions: {
                    column: {
                        pointPadding: 0.2,
                        borderWidth: 0
                    }
                },
                series: [{
                    name: __["Users"],
                    data: [{','|implode:$chart['users']}]

                }, {
                    name: __["Pages"],
                    data: [{','|implode:$chart['pages']}]

                }, {
                    name: __["Groups"],
                    data: [{','|implode:$chart['groups']}]

                }, {
                    name: __["Events"],
                    data: [{','|implode:$chart['events']}]

                }, {
                    name: __["Posts"],
                    data: [{','|implode:$chart['posts']}]

                }]
            });
        });
        </script>
    {/if}
    {if $view == "packages" && $sub_view == "earnings"}
        <script>
           $(function () {
            Highcharts.setOptions();
            $('#admin-chart-earnings').highcharts({
                chart: {
                    type: 'column',
                    backgroundColor: 'transparent',
                },
                title: {
                    text: __["Monthly Average"]
                },
                xAxis: {
                    categories: [
                        __["Jan"],
                        __["Feb"],
                        __["Mar"],
                        __["Apr"],
                        __["May"],
                        __["Jun"],
                        __["Jul"],
                        __["Aug"],
                        __["Sep"],
                        __["Oct"],
                        __["Nov"],
                        __["Dec"]
                    ],
                    crosshair: true
                },
                yAxis: {
                    min: 0,
                    title: {
                        text: "{'Y'|date}"
                    }
                },
                tooltip: {
                    headerFormat: '<span style="font-size:10px">{literal}{point.key}{/literal}</span><table>',
                    pointFormat: '<tr><td style="color:{literal}{series.color}{/literal};padding:0">{literal}{series.name}{/literal}: </td>' +
                        '<td style="padding:0"><b>{literal}{point.y}{/literal}</b></td></tr>',
                    footerFormat: '</table>',
                    shared: true,
                    useHTML: true
                },
                plotOptions: {
                    column: {
                        pointPadding: 0.2,
                        borderWidth: 0
                    }
                },
                series: [
                    {foreach $rows as $key => $value}
                        {
                            name: "{$key}",
                            data: [{','|implode:$value['months_sales']}]
                        },
                    {/foreach}
                ]
            });
            
        });
        </script>
    {/if}
    <!-- Admin Charts -->

    <!-- Admin Code Editor -->
    {if $view == "design"}
        <script>
            $(function () {
                CodeMirror.fromTextArea(document.getElementById('custome_js_header'), {
                    mode: "javascript",
                    lineNumbers: true,
                    readOnly: false
                });

                CodeMirror.fromTextArea(document.getElementById('custome_js_footer'), {
                    mode: "javascript",
                    lineNumbers: true,
                    readOnly: false
                });

                CodeMirror.fromTextArea(document.getElementById('custom-css'), {
                    mode: "css",
                    lineNumbers: true,
                    readOnly: false
                });
            });
        </script>
    {/if}
    <!-- Admin Code Editor -->
{/if}

<!-- Cookies Policy -->
{if $system['cookie_consent_enabled']}
    <script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.0.3/cookieconsent.min.js" {if !$user->_logged_in}defer{/if}></script>
    <link rel="stylesheet" type="text/css" href="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.0.3/cookieconsent.min.css" />
    <script>
        window.addEventListener("load", function(){
            window.cookieconsent.initialise({
                "palette": {
                    "popup": {
                        "background": "#1e2321",
                        "text": "#fff"
                    },
                    "button": {
                        "background": "#3367d6"
                    }
                },
                "theme": "edgeless",
                "position": {if $system['language']['dir'] == 'LTR'}"bottom-left"{else}"bottom-right"{/if},
                "content": {
                    "message": __["This website uses cookies to ensure you get the best experience on our website"],
                    "dismiss": __["Got It!"],
                    "link": __["Learn More"],
                    "href": site_path+"/static/privacy"
                  }
            })
        });
    </script>
{/if}
<!-- Cookies Policy -->

{/strip}