<div class="publisher-overlay"></div>
<div class="x-form publisher" data-handle="{$_handle}" {if $_id}data-id="{$_id}"{/if}>

    <!-- publisher loader -->
    <div class="publisher-loader">
        <div class="loader loader_small"></div>
    </div>
    <!-- publisher loader -->

    <!-- publisher-message -->
    <div class="publisher-message">
        {if $_handle == "page"}
            <img class="publisher-avatar" src="{$spage['page_picture']}">
        {else}
            <img class="publisher-avatar" src="{$user->_data['user_picture']}">
        {/if}
        <textarea dir="auto" class="js_autosize js_mention js_publisher-scraper" data-init-placeholder='{__("What is on your mind? #Hashtag.. @Mention.. Link..")}' placeholder='{__("What is on your mind? #Hashtag.. @Mention.. Link..")}'></textarea>
        <div class="publisher-emojis">
            <div class="relative">
                <span class="js_emoji-menu-toggle" data-toggle="tooltip" data-placement="top" title='{__("Insert an emoji")}'>
                    <i class="far fa-smile-wink fa-lg"></i>
                </span>
            </div>
        </div>
    </div>
    <!-- publisher-message -->

    <!-- publisher-slider -->
    <div class="publisher-slider">
        <!-- publisher scraper -->
        <div class="publisher-scraper"></div>
        <!-- publisher scraper -->

        <!-- post attachments -->
        <div class="publisher-attachments attachments clearfix x-hidden"></div>
        <!-- post attachments -->

        <!-- post album -->
        <div class="publisher-meta" data-meta="album">
            <i class="fa fa-file-image fa-fw"></i>
            <input type="text" placeholder='{__("Album title")}'>
        </div>
        <!-- post album -->

        <!-- post poll -->
        <div class="publisher-meta" data-meta="poll">
            <i class="fa fa-plus fa-fw"></i>
            <input type="text" placeholder='{__("Add an option")}...'>
        </div>
        <div class="publisher-meta" data-meta="poll">
            <i class="fa fa-plus fa-fw"></i>
            <input type="text" placeholder='{__("Add an option")}...'>
        </div>
        <!-- post poll -->

        <!-- post video -->
        <div class="publisher-meta" data-meta="video">
            <i class="fa fa-video fa-fw"></i>
            {__("Video uploaded successfully")}
            <div class="pull-right flip">
                <button type="button" class="close js_publisher-attachment-file-remover" data-type="video">
                    <span>&times;</span>
                </button>
            </div>
        </div>
        <!-- post video -->

        <!-- post audio -->
        <div class="publisher-meta" data-meta="audio">
            <i class="fa fa-music fa-fw"></i>
            {__("Audio uploaded successfully")}
            <div class="pull-right flip">
                <button type="button" class="close js_publisher-attachment-file-remover" data-type="audio">
                    <span>&times;</span>
                </button>
            </div>
        </div>
        <!-- post audio -->

        <!-- post file -->
        <div class="publisher-meta" data-meta="file">
            <i class="fa fa-file-alt fa-fw"></i>
            {__("File uploaded successfully")}
            <div class="pull-right flip">
                <button type="button" class="close js_publisher-attachment-file-remover" data-type="file">
                    <span>&times;</span>
                </button>
            </div>
        </div>
        <!-- post file -->

        <!-- post location -->
        <div class="publisher-meta" data-meta="location">
            <i class="fa fa-map-marker fa-fw"></i>
            <input class="js_geocomplete" type="text" placeholder='{__("Where are you?")}'>
        </div>
        <!-- post location -->

        <!-- post gif -->
        <div class="publisher-meta" data-meta="gif">
            <i class="fa fa-file-image fa-fw"></i>
            <input class="js_publisher-gif-search" type="text" placeholder='{__("Search GIFs")}'>
        </div>
        <!-- post gif -->

        <!-- post feelings -->
        <div class="publisher-meta feelings" data-meta="feelings">
            <div id="feelings-menu-toggle" data-init-text='{__("What are you doing?")}'>{__("What are you doing?")}</div>
            <div id="feelings-data" style="display: none">
                <input type="text" placeholder='{__("What are you doing?")}'>
                <span></span>
            </div>
            <div id="feelings-menu" class="dropdown-menu dropdown-widget">
                <div class="dropdown-widget-body ptb5">
                    <div class="js_scroller">
                        <ul class="feelings-list">
                            {foreach $feelings as $feeling}
                                <li class="feeling-item js_feelings-add" data-action="{$feeling['action']}" data-placeholder="{__($feeling['placeholder'])}">
                                    <div class="icon">
                                        <i class="twa twa-3x twa-{$feeling['icon']}"></i>
                                    </div>
                                    <div class="data">
                                        {__($feeling['text'])}
                                    </div>
                                </li>
                            {/foreach}
                        </ul>
                    </div>
                </div>
            </div>
            <div id="feelings-types" class="dropdown-menu dropdown-widget">
                <div class="dropdown-widget-body ptb5">
                    <div class="js_scroller">
                        <ul class="feelings-list">
                            {foreach $feelings_types as $type}
                                <li class="feeling-item js_feelings-type" data-type="{$type['action']}" data-icon="{$type['icon']}">
                                    <div class="icon">
                                        <i class="twa twa-3x twa-{$type['icon']}"></i>
                                    </div>
                                    <div class="data">
                                        {__($type['text'])}
                                    </div>
                                </li>
                            {/foreach}
                        </ul>
                    </div>
                </div>
            </div>
        </div>
        <!-- post feelings -->
    
        <!-- publisher-tools-tabs -->
        <div class="publisher-tools-tabs">
            <ul class="row">
                {if $system['photos_enabled']}
                    <li class="col-md-6">
                        <div class="publisher-tools-tab attach js_publisher-tab" data-tab="photos">
                            <i class="fa fa-camera fa-fw js_x-uploader" data-handle="publisher" data-multiple="true"></i> {__("Upload Photos")}
                        </div>
                    </li>
                    <li class="col-md-6">
                        <div class="publisher-tools-tab js_publisher-tab" data-tab="album">
                            <i class="fa fa-images fa-fw"></i> {__("Create Album")}
                        </div>
                    </li>
                {/if}
                {if $system['geolocation_enabled']}
                    <li class="col-md-6">
                        <div class="publisher-tools-tab js_publisher-tab" data-tab="location">
                            <i class="fa fa-map-marker fa-fw"></i> {__("Check In")}
                        </div>
                    </li>
                {/if}
                <li class="col-md-6">
                    <div class="publisher-tools-tab js_publisher-feelings">
                        <i class="fa fa-grin-beam fa-fw"></i> {__("Feelings/Activity")}
                    </div>
                </li>
                {if $system['gif_enabled']}
                    <li class="col-md-6">
                        <div class="publisher-tools-tab js_publisher-tab" data-tab="gif">
                            <i class="fa fa-file-image fa-fw"></i> {__("GIF")}
                        </div>
                    </li>
                {/if}
                {if $system['market_enabled'] && $_handle != "page" && $_handle != "group" && $_handle != "event"}
                    <li class="col-md-6">
                        <div class="publisher-tools-tab link js_publisher-tab" data-tab="product" data-toggle="modal" data-url="posts/product.php?do=create">
                            <i class="fa fa-shopping-cart fa-fw"></i> {__("Sell Something")}
                        </div>
                    </li>
                {/if}
                {if $system['blogs_enabled'] && $_handle != "page" && $_handle != "group" && $_handle != "event"}
                    <li class="col-md-6">
                        <a class="publisher-tools-tab link js_publisher-tab" data-tab="article" href="{$system['system_url']}/blogs/new">
                            <i class="fa fa-file-alt fa-fw"></i> {__("Write Article")}
                        </a>
                    </li>
                {/if}
                {if $system['polls_enabled']}
                    <li class="col-md-6">
                        <div class="publisher-tools-tab js_publisher-tab" data-tab="poll">
                            <i class="fa fa-chart-pie fa-fw"></i> {__("Create Poll")}
                        </div>
                    </li>
                {/if}
                {if $system['videos_enabled']}
                    <li class="col-md-6">
                        <div class="publisher-tools-tab attach js_publisher-tab" data-tab="video">
                            <i class="fa fa-video fa-fw js_x-uploader" data-handle="publisher" data-type="video"></i> {__("Upload Video")}
                        </div>
                    </li>
                {/if}
                {if $system['audio_enabled']}
                    <li class="col-md-6">
                        <div class="publisher-tools-tab attach js_publisher-tab" data-tab="audio">
                            <i class="fa fa-music fa-fw js_x-uploader" data-handle="publisher" data-type="audio"></i> {__("Upload Audio")}
                        </div>
                    </li>
                {/if}
                {if $system['file_enabled']}
                    <li class="col-md-6">
                        <div class="publisher-tools-tab attach js_publisher-tab" data-tab="file">
                            <i class="fa fa-paperclip fa-fw js_x-uploader" data-handle="publisher" data-type="file"></i> {__("Upload File")}
                        </div>
                    </li>
                {/if}
            </ul>
        </div>
        <!-- publisher-tools-tabs -->

        <!-- publisher-footer -->
        <div class="publisher-footer clearfix">
            <!-- publisher-buttons -->
            <div class="pull-right flip mt5 mr10">
                {if $_privacy}
                    <!-- privacy -->
                    {if $system['default_privacy'] == "me"}
                    <div class="btn-group js_publisher-privacy" data-toggle="tooltip" data-placement="top" data-value="me" title='{__("Shared with: Only Me")}'>
                        <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
                            <i class="btn-group-icon fa fa-lock"></i> <span class="btn-group-text hidden-xs">{__("Only Me")}</span> <span class="caret"></span>
                        </button>
                    {elseif $system['default_privacy'] == "friends"}
                    <div class="btn-group js_publisher-privacy" data-toggle="tooltip" data-placement="top" data-value="friends" title='{__("Shared with: Friends")}'>
                        <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
                            <i class="btn-group-icon fa fa-users"></i> <span class="btn-group-text hidden-xs">{__("Friends")}</span> <span class="caret"></span>
                        </button>
                    {else}
                    <div class="btn-group js_publisher-privacy" data-toggle="tooltip" data-placement="top" data-value="public" title='{__("Shared with: Public")}'>
                        <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
                            <i class="btn-group-icon fa fa-globe"></i> <span class="btn-group-text hidden-xs">{__("Public")}</span> <span class="caret"></span>
                        </button>
                    {/if}
                        <ul class="dropdown-menu" role="menu">
                            <li>
                                <a href="#" data-title='{__("Shared with: Public")}' data-value="public">
                                    <i class="fa fa-globe"></i> {__("Public")}
                                </a>
                            </li>
                            <li>
                                <a href="#" data-title='{__("Shared with: Friends")}' data-value="friends">
                                    <i class="fa fa-users"></i> {__("Friends")}
                                </a>
                            </li>
                            {if $_handle == 'me'}
                                <li>
                                    <a href="#" data-title='{__("Shared with: Only Me")}' data-value="me">
                                        <i class="fa fa-lock"></i> {__("Only Me")}
                                    </a>
                                </li>
                            {/if}
                        </ul>
                    </div>
                    <!-- privacy -->
                {/if}
                <button type="button" class="btn btn-primary js_publisher">{__("Post")}</button>
            </div>
            <!-- publisher-buttons -->
        </div>
        <!-- publisher-footer -->
    </div>
    <!-- publisher-slider -->
</div>