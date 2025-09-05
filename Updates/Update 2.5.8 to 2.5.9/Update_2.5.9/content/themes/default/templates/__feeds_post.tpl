{if !$standalone}<li>{/if}
    <!-- post -->
    <div class="post {if $boosted}boosted{/if}" data-id="{$post['post_id']}">

        {if $standalone && $pinned}
            <div class="pin-icon" data-toggle="tooltip" title="{__("Pinned Post")}">
                <i class="fa fa-bookmark"></i>
            </div>
        {/if}

        {if $standalone && $boosted}
            <div class="boosted-icon" data-toggle="tooltip" title="{__("Promoted")}">
                <i class="fa fa-bullhorn"></i>
            </div>
        {/if}

        <!-- post body -->
        <div class="post-body">
            
            {include file='__feeds_post.body.tpl' _post=$post _shared=false}

            <!-- post stats -->
            <div class="post-stats">
                <!-- likes -->
                <span class="text-clickable" data-toggle="modal" data-url="posts/who_likes.php?post_id={$post['post_id']}">
                    <i class="fa fa-thumbs-up"></i> 
                    <span class="js_post-likes-num">
                        {$post['likes']}
                    </span>
                </span>
                <!-- likes -->

                <span class="float-right">
                    <!-- comments -->
                    <span class="text-clickable js_comments-toggle">
                        <i class="fa fa-comments"></i> {$post['comments']} {__("Comments")}
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
            {if $user->_logged_in && $_get != "posts_information"}
                <div class="post-actions clearfix">
                    <!-- like -->
                    <div class="action-btn {if $post['i_like']}text-active js_unlike-post{else}js_like-post{/if}">
                        <i class="fa fa-thumbs-up fa-fw mr5"></i><span>{__("Like")}</span>
                    </div>
                    <!-- like -->

                    <!-- comment -->
                    <div class="action-btn js_comment {if $post['comments_disabled']}x-hidden{/if}">
                        <i class="fa fa-comment fa-fw mr5"></i><span>{__("Comment")}</span>
                    </div>
                    <!-- comment -->

                    <!-- share -->
                    {if $post['privacy'] == "public"}
                        <div class="action-btn" data-toggle="modal" data-url="posts/share.php?do=create&post_id={$post['post_id']}">
                            <i class="fa fa-share fa-fw mr5"></i><span>{__("Share")}</span>
                        </div>
                    {/if}
                    <!-- share -->
                </div>
            {/if}
            <!-- post actions -->

        </div>
        <!-- post body -->

        <!-- post footer -->
        <div class="post-footer {if !$standalone}x-hidden{/if}">
            <!-- comments -->
            {include file='__feeds_post.comments.tpl'}
            <!-- comments -->
        </div>
        <!-- post footer -->

    </div>
    <!-- post -->
{if !$standalone}</li>{/if}