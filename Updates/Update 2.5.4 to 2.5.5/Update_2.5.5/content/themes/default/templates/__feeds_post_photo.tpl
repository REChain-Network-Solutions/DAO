<!-- post body -->
<div class="post-body {if $_lightbox}pt0{/if}">

    <!-- post header -->
    <div class="post-header">
        <!-- post picture -->
        <div class="post-avatar">
            <a class="post-avatar-picture" href="{$post['post_author_url']}" style="background-image:url({$post['post_author_picture']});">
            </a>
        </div>
        <!-- post picture -->

        <!-- post meta -->
        <div class="post-meta">
            <!-- post menu & author name & type meta & feeling -->
            <div>
                <!-- post author name -->
                <span class="js_user-popover" data-type="{$post['user_type']}" data-uid="{$post['user_id']}">
                    <a href="{$post['post_author_url']}">{$post['post_author_name']}</a>
                </span>
                {if $post['post_author_verified']}
                    {if $post['user_type'] == "user"}
                    <i data-toggle="tooltip" data-placement="top" title='{__("Verified User")}' class="fa fa-check-circle fa-fw verified-badge"></i>
                    {else}
                    <i data-toggle="tooltip" data-placement="top" title='{__("Verified Page")}' class="fa fa-check-circle fa-fw verified-badge"></i>
                    {/if}
                {/if}
                {if $post['user_subscribed']}
                <i data-toggle="tooltip" data-placement="top" title='{__("Pro User")}' class="fa fa-bolt fa-fw pro-badge"></i>
                {/if}
                <!-- post author name -->
            </div>
            <!-- post menu & author name & type meta & feeling -->

            <!-- post time & location & privacy -->
            <div class="post-time">
                <a href="{$system['system_url']}/posts/{$post['post_id']}" class="js_moment" data-time="{$post['time']}">{$post['time']}</a>

                {if $post['location']}
                ·
                <i class="fa fa-map-marker"></i> <span>{$post['location']}</span>
                {/if}

                - 
                {if $post['privacy'] == "me"}
                    <i class="fa fa-lock" data-toggle="tooltip" data-placement="top" title='{__("Shared with")} {__("Only Me")}'></i>
                {elseif $post['privacy'] == "friends"}
                    <i class="fa fa-users" data-toggle="tooltip" data-placement="top" title='{__("Shared with")} {__("Friends")}'></i>
                {elseif $post['privacy'] == "public"}
                    <i class="fa fa-globe" data-toggle="tooltip" data-placement="top" title='{__("Shared with")} {__("Public")}'></i>
                {elseif $post['privacy'] == "custom"}
                    <i class="fa fa-cog" data-toggle="tooltip" data-placement="top" title='{__("Shared with")} {__("Custom People")}'></i>
                {/if}
            </div>
            <!-- post time & location & privacy -->
        </div>
        <!-- post meta -->
    </div>
    <!-- post header -->

    <!-- photo -->
    {if !$_lightbox}
        <div class="mt10 clearfix">
            <div class="pg_wrapper">
                <div class="pg_1x">
                    <a href="{$system['system_url']}/photos/{$photo['photo_id']}" class="js_lightbox" data-id="{$photo['photo_id']}" data-image="{$system['system_uploads']}/{$photo['source']}" data-context="{if $photo['is_single']}album{else}post{/if}">
                        <img src="{$system['system_uploads']}/{$photo['source']}">
                    </a>
                </div>
            </div>
        </div>
    {/if}
    <!-- photo -->

    <!-- post stats -->
    <div class="post-stats">
        <!-- likes -->
        <span class="text-clickable" data-toggle="modal" data-url="posts/who_likes.php?{if $photo['is_single']}post_id={$post['post_id']}{else}photo_id={$photo['photo_id']}{/if}">
            <i class="fa fa-thumbs-up"></i> 
            <span class="js_post-likes-num">
                {if $photo['is_single']}{$post['likes']}{else}{$photo['likes']}{/if}
            </span>
        </span>
        <!-- likes -->

        <span class="pull-right flip">
            <!-- comments -->
            <span class="text-clickable js_comments-toggle">
                <i class="fa fa-comments"></i> {if $photo['is_single']}{$post['comments']}{else}{$photo['comments']}{/if} {__("Comments")}
            </span>
            <!-- comments -->

            <!-- shares -->
            <span class="text-clickable ml10 {if $post['shares'] == 0}x-hidden{/if}" data-toggle="modal" data-url="posts/who_shares.php?post_id={$post['post_id']}">
                <i class="fa fa-share"></i> {$post['shares']} {__("Shares")}
            </span>
            <!-- shares -->
        </span>
    </div>
    <!-- post stats -->

    <!-- post actions -->
    {if $user->_logged_in}
        <div class="post-actions clearfix">
            <!-- like -->
            <span class="action-btn {if $photo['i_like']}text-active js_unlike-{if $photo['is_single']}post{else}photo{/if}{else}js_like-{if $photo['is_single']}post{else}photo{/if}{/if}">
                <i class="fa fa-thumbs-up"></i> <span>{__("Like")}</span>
            </span>
            <!-- like -->

            <!-- comment -->
            <span class="action-btn js_comment">
                <i class="fa fa-comment"></i> <span>{__("Comment")}</span>
            </span>
            <!-- comment -->

            <!-- share -->
            {if $post['privacy'] == "public"}
                <span class="action-btn {if $system['social_share_enabled']}js_share-toggle{else}js_share{/if}" data-id="{$post['post_id']}">
                    <i class="fa fa-share"></i> <span>{__("Share")}</span>
                </span>
            {/if}
            <!-- share -->
        </div>
    {/if}
    <!-- post actions -->
</div>

<!-- post footer -->
<div class="post-footer">
    <!-- social sharing -->
    {include file='__feeds_post.social.tpl'}
    <!-- social sharing -->

    <!-- comments -->
    {include file='__feeds_post.comments.tpl' _is_photo=(!$photo['is_single'])?true:false}
    <!-- comments -->
</div>
<!-- post footer -->