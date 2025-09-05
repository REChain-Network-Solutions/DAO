<li>
    <div class="comment {if $_is_reply}reply{/if}" data-id="{$_comment['comment_id']}" id="comment_{$_comment['comment_id']}">
        <!-- comment avatar -->
        <div class="comment-avatar">
            <a class="comment-avatar-picture" href="{$_comment['author_url']}" style="background-image:url({$_comment['author_picture']});">
            </a>
        </div>
        <!-- comment avatar -->

        <!-- comment body -->
        <div class="comment-data">
            <!-- comment menu -->
            {if $user->_logged_in}
                {if !$_comment['edit_comment'] && !$_comment['delete_comment'] }
                    <div class="comment-btn">
                        <button type="button" class="close js_report" data-handle="comment" data-id="{$_comment['comment_id']}"  data-toggle="tooltip" data-placement="top" title='{__("Report")}'>
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                {elseif !$_comment['edit_comment'] && $_comment['delete_comment']}
                    <div class="comment-btn">
                        <button type="button" class="close js_delete-comment" data-toggle="tooltip" data-placement="top" title='{__("Delete")}'>
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                {else}
                    <div class="comment-btn dropdown float-right">
                        <button type="button" class="close" data-toggle="dropdown" data-display="static" data-tooltip="tooltip" data-placement="top" title='{__("Edit or Delete")}'>
                            <span aria-hidden="true">&times;</span>
                        </button>
                        <div class="dropdown-menu dropdown-menu-right">
                            <div class="dropdown-item pointer js_edit-comment">{__("Edit Comment")}</div>
                            <div class="dropdown-item pointer js_delete-comment">{__("Delete Comment")}</div>
                        </div>
                    </div>
                {/if}
            {/if}
            <!-- comment menu -->

            <!-- comment author & text  -->
            <div class="mb5 js_notifier-flasher">
                <!-- author -->
                <span class="text-semibold js_user-popover" data-type="{$_comment['user_type']}" data-uid="{$_comment['user_id']}">
                    <a href="{$_comment['author_url']}" >{$_comment['author_name']}</a>
                </span>
                {if $_comment['author_verified']}
                <i data-toggle="tooltip" data-placement="top" title='{__("Verified User")}' class="fa fa-check-circle fa-fw verified-badge"></i>
                {/if}
                <!-- author -->

                <!-- text -->
                {include file='__feeds_comment.text.tpl'}
                <!-- text -->
            </div>
            <!-- comment author & text  -->

            <!-- comment actions & time  -->
            <ul class="comment-actions clearfix">
                <!-- actions -->
                <li>
                    {if $_comment['i_like']}
                        <span class="text-link js_unlike-comment">{__("Unlike")}</span>
                    {else}
                        <span class="text-link js_like-comment">{__("Like")}</span>
                    {/if}
                </li>
                <li>
                    <span class="js_comment-likes {if {$_comment['likes']} == 0}x-hidden{/if}">
                        <span class="text-link" data-toggle="modal" data-url="posts/who_likes.php?comment_id={$_comment['comment_id']}"><i class="fa fa-thumbs-up"></i> <span class="js_comment-likes-num">{$_comment['likes']}</span></span>
                    </span>
                </li>
                <li>
                    <span class="text-link js_reply {if $post['comments_disabled']}x-hidden{/if}" data-username="{if $user->_data['user_name'] != $_comment['author_user_name']}{$_comment['author_user_name']}{/if}">{__("Reply")}</span>
                </li>
                <!-- actions -->

                <!-- time  -->
                <li>
                    <small class="text-muted js_moment" data-time="{$_comment['time']}">{$_comment['time']}</small>
                </li>
                <!-- time  -->
            </ul>
            <!-- comment actions & time  -->

            <!-- comment replies  -->
            {if !$_is_reply}
                {if !$standalone && $_comment['replies'] > 0}
                <div class="ptb10 plr10 js_replies-toggle">
                    <span class="text-link">
                        <i class="fa fa-comments"></i>
                        {$_comment['replies']} {__("Replies")}
                    </span>
                </div>
                {/if}
                <div class="comment-replies {if !$standalone}x-hidden{/if}">
                    <!-- previous replies -->
                    {if $_comment['replies'] >= $system['min_results']}
                        <div class="pb10 text-center js_see-more" data-get="comment_replies" data-id="{$_comment['comment_id']}" data-remove="true">
                            <span class="text-link">
                                <i class="fa fa-comment"></i>
                                {__("View previous replies")}
                            </span>
                            <div class="loader loader_small x-hidden"></div>
                        </div>
                    {/if}
                    <!-- previous replies -->

                    <!-- replies -->
                    <ul class="js_replies">
                        {if $_comment['replies'] > 0}
                            {foreach $_comment['comment_replies'] as $reply}
                            {include file='__feeds_comment.tpl' _comment=$reply _is_reply=true}
                            {/foreach}
                        {/if}
                    </ul>
                    <!-- replies -->

                    <!-- post a reply -->
                    {if $user->_logged_in}
                        <div class="x-hidden js_reply-form">
                            <div class="x-form comment-form">
                                <textarea dir="auto" class="js_autosize js_mention js_post-reply" rows="1" placeholder='{__("Write a reply")}'></textarea>
                                <ul class="x-form-tools clearfix">
                                    <li class="x-form-tools-post js_post-reply">
                                        <i class="far fa-paper-plane fa-lg fa-fw"></i>
                                    </li>
                                    <li class="x-form-tools-attach">
                                        <i class="far fa-image fa-lg fa-fw js_x-uploader" data-handle="comment"></i>
                                    </li>
                                    <li class="x-form-tools-emoji js_emoji-menu-toggle">
                                        <i class="far fa-smile-wink fa-lg fa-fw"></i>
                                    </li>
                                </ul>
                            </div>
                            <div class="comment-attachments attachments clearfix x-hidden">
                                <ul>
                                    <li class="loading">
                                        <div class="progress x-progress"><div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div></div>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    {/if}
                    <!-- post a reply -->
                </div>
            {/if}
            <!-- comment replies  -->
        </div>
        <!-- comment body -->
    </div>
</li>