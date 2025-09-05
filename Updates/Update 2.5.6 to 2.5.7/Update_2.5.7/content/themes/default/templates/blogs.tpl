{include file='_head.tpl'}
{include file='_header.tpl'}

<!-- page content -->
<div class="container mt20 offcanvas">
    <div class="row">
        {if $view == ""}
            <!-- side panel -->
            <div class="col-xs-12 visible-xs-block offcanvas-sidebar">
                {include file='_sidebar.tpl'}
            </div>
            <!-- side panel -->

            <!-- content panel -->
            <div class="col-xs-12 offcanvas-mainbar">
                <div class="blogs-wrapper">
                    <h2>{__("Recent")} <b>{__("Articles")}</b></h2>
                    {if $articles}
                        <ul class="row">
                            <!-- articles -->
                            {foreach $articles as $article}
                            {include file='__feeds_article.tpl' _tpl="featured" _iteration=$article@iteration}
                            {/foreach}
                            <!-- articles -->
                        </ul>

                        <!-- see-more -->
                        <div class="alert alert-post see-more js_see-more" data-get="articles">
                            <span>{__("More Articles")}</span>
                            <div class="loader loader_small x-hidden"></div>
                        </div>
                        <!-- see-more -->
                    {else}
                        <!-- no articles -->
                        <div class="text-center x-muted">
                            <i class="fa fa-newspaper fa-4x"></i>
                            <p class="mb10"><strong>{__("No articles to show")}</strong></p>
                        </div>
                        <!-- no articles -->
                    {/if}
                </div>
            </div>
            <!-- content panel -->
        {elseif $view == "category"}
            <!-- side panel -->
            <div class="col-xs-12 visible-xs-block offcanvas-sidebar">
                {include file='_sidebar.tpl'}
            </div>
            <!-- side panel -->

            <!-- content panel -->
            <div class="col-xs-12 offcanvas-mainbar">
                <div class="row">
                    <!-- left panel -->
                    <div class="col-md-8 mb20">
                        {if $articles}
                            <ul>
                                {foreach $articles as $article}
                                {include file='__feeds_article.tpl'}
                                {/foreach}
                            </ul>

                            <!-- see-more -->
                            <div class="alert alert-post see-more js_see-more" data-get="category_articles" data-id="{$category_id}">
                                <span>{__("More Articles")}</span>
                                <div class="loader loader_small x-hidden"></div>
                            </div>
                            <!-- see-more -->
                        {else}
                            <!-- no articles -->
                            <div class="text-center x-muted">
                                <i class="fa fa-newspaper fa-4x"></i>
                                <p class="mb10"><strong>{__("No articles to show")}</strong></p>
                            </div>
                            <!-- no articles -->
                        {/if}
                    </div>
                    <!-- left panel -->

                    <!-- right panel -->
                    <div class="col-md-4">
                        <!-- add new article -->
                        {if $user->_logged_in && $user->_data['can_write_articles']}
                            <div class="mb10 hidden-xs">
                                <a href="{$system['system_url']}/blogs/new" class="btn btn-sm btn-success btn-block">
                                    <i class="fa fa-edit mr5"></i>{__("Write New Article")}
                                </a>
                            </div>
                        {/if}
                        <!-- add new article -->
                        
                        {include file='_ads.tpl'}
                        {include file='_widget.tpl'}

                        <!-- blogs categoris -->
                        <div class="articles-widget-header">
                            <div class="articles-widget-title">{__("Categories")}</div>
                        </div>
                        
                        <ul class="article-categories clearfix">
                            {foreach $blogs_categories as $category}
                                <li>
                                    <a class="article-category" href="{$system['system_url']}/blogs/category/{$category['category_id']}/{$category['category_url']}">
                                        {$category['category_name']}
                                    </a>
                                </li>
                            {/foreach}
                            <li>
                                <a class="article-category" href="{$system['system_url']}/blogs/category/0/Uncategorized">
                                    {__("Uncategorized")}
                                </a>
                            </li>
                        </ul>
                        <!-- blogs categoris -->

                        <!-- read more -->
                        <div class="articles-widget-header">
                            <div class="articles-widget-title">{__("Read More")}</div>
                        </div>
                        
                        {foreach $latest_articles as $article}
                        {include file='__feeds_article.tpl' _small=true}
                        {/foreach}
                        <!-- read more -->
                    </div>
                    <!-- right panel -->
                </div>
            </div>
            <!-- content panel -->
        {elseif $view == "article"}
            <!-- side panel -->
            <div class="col-xs-12 visible-xs-block offcanvas-sidebar">
                {include file='_sidebar.tpl'}
            </div>
            <!-- side panel -->

            <!-- content panel -->
            <div class="col-xs-12 offcanvas-mainbar">
                <div class="row">
                    <!-- left panel -->
                    <div class="col-md-8 mb20">
                        <div class="article-wrapper">
                            <div class="mb10">
                                <a class="article-category" href="{$system['system_url']}/blogs/category/{$article['article']['category_id']}/{$article['article']['category_url']}">
                                    {$article['article']['category_name']}
                                </a>
                            </div>

                            <h3>{$article['article']['title']}</h3>
                            
                            <div class="mb20">
                                <div class="pull-right flip">
                                    {if $article['manage_post']}
                                        <a class="article-meta-counter" href="{$system['system_url']}/blogs/edit/{$article['post_id']}">
                                            <i class="fa fa-edit fa-fw"></i> {__("Edit")}
                                        </a>
                                        <a class="article-meta-counter js_delete-article" href="#" data-id="{$article['post_id']}">
                                            <i class="fa fa-trash fa-fw"></i>
                                        </a>
                                    {/if}
                                    <a class="article-meta-counter" href="#article-comments">
                                        <i class="fa fa-comments fa-fw"></i> {$article['comments']}
                                    </a>
                                    <div class="article-meta-counter" data-toggle="modal" data-url="posts/who_likes.php?post_id={$article['post_id']}">
                                        <i class="fa fa-thumbs-up fa-fw"></i> {$article['likes']}
                                    </div>
                                    <div class="article-meta-counter">
                                        <i class="fa fa-eye fa-fw"></i> {$article['article']['views']}
                                    </div>
                                </div>

                                <div class="post-avatar">
                                    <a class="post-avatar-picture" href="{$article['post_author_url']}" style="background-image:url({$article['post_author_picture']});">
                                    </a>
                                </div>
                                <div class="post-meta">
                                    <div>
                                        <!-- post author name -->
                                        <span class="js_user-popover" data-type="{$article['user_type']}" data-uid="{$article['user_id']}">
                                            <a href="{$article['post_author_url']}">{$article['post_author_name']}</a>
                                        </span>
                                        {if $article['post_author_verified']}
                                            {if $article['user_type'] == "user"}
                                            <i data-toggle="tooltip" data-placement="top" title='{__("Verified User")}' class="fa fa-check-circle fa-fw verified-badge"></i>
                                            {else}
                                            <i data-toggle="tooltip" data-placement="top" title='{__("Verified Page")}' class="fa fa-check-circle fa-fw verified-badge"></i>
                                            {/if}
                                        {/if}
                                        {if $article['user_subscribed']}
                                            <i data-toggle="tooltip" data-placement="top" title='{__("Pro User")}' class="fa fa-bolt fa-fw pro-badge"></i>
                                        {/if}
                                        <!-- post author name -->
                                    </div>
                                    <div class="post-time">
                                        {__("Posted")} <span class="js_moment" data-time="{$article['time']}">{$article['time']}</span>
                                    </div>
                                </div>
                            </div>

                            <div class="mb20">
                                <a href="http://www.facebook.com/sharer.php?u={$system['system_url']}/blogs/{$article['post_id']}/{$article['article']['title_url']}" class="btn btn-sm btn-rounded btn-facebook" target="_blank">
                                    <i class="fab fa-facebook-f fa-fw"></i>
                                </a>
                                <a href="https://twitter.com/intent/tweet?url={$system['system_url']}/blogs/{$article['post_id']}/{$article['article']['title_url']}" class="btn btn-sm btn-rounded btn-rounded btn-twitter" target="_blank">
                                    <i class="fab fa-twitter fa-fw"></i>
                                </a>
                                <a href="https://plus.google.com/share?url={$system['system_url']}/blogs/{$article['post_id']}/{$article['article']['title_url']}" class="btn btn-sm btn-rounded btn-google" target="_blank">
                                    <i class="fab fa-google fa-fw"></i>
                                </a>
                                <a href="https://vk.com/share.php?url={$system['system_url']}/blogs/{$article['post_id']}/{$article['article']['title_url']}" class="btn btn-sm btn-rounded btn-vk" target="_blank">
                                    <i class="fab fa-vk fa-fw"></i>
                                </a>
                                <a href="https://www.linkedin.com/shareArticle?mini=true&url={$system['system_url']}/blogs/{$article['post_id']}/{$article['article']['title_url']}" class="btn btn-sm btn-rounded btn-linkedin" target="_blank">
                                    <i class="fab fa-linkedin fa-fw"></i>
                                </a>
                                <a href="https://api.whatsapp.com/send?text={$system['system_url']}/blogs/{$article['post_id']}/{$article['article']['title_url']}" class="btn btn-sm btn-rounded btn-whatsapp" target="_blank">
                                    <i class="fab fa-whatsapp fa-fw"></i>
                                </a>
                                <a href="https://reddit.com/submit?url={$system['system_url']}/blogs/{$article['post_id']}/{$article['article']['title_url']}" class="btn btn-sm btn-rounded btn-reddit" target="_blank">
                                    <i class="fab fa-reddit fa-fw"></i>
                                </a>
                                <a href="https://pinterest.com/pin/create/button/?url={$system['system_url']}/blogs/{$article['post_id']}/{$article['article']['title_url']}" class="btn btn-sm btn-rounded btn-pinterest" target="_blank">
                                    <i class="fab fa-pinterest fa-fw"></i>
                                </a>
                            </div>
                            
                            {if $article['article']['cover']}
                                <div class="mb20">
                                    <img class="img-responsive" src="{$article['article']['parsed_cover']}">
                                </div>
                            {/if}

                            <div class="article-text">
                                {$article['article']['parsed_text']}
                            </div>

                            {if $article['article']['parsed_tags']}
                                <div class="article-tags">
                                    <ul>
                                        {foreach $article['article']['parsed_tags'] as $tag}
                                            <li>
                                                <a href="{$system['system_url']}/search/hashtag/{$tag}">{$tag}</a>
                                            </li>
                                        {/foreach}
                                    </ul>
                                </div>
                            {/if}
                        </div>
                        <!-- post footer -->
                        <div class="post-footer" id="article-comments">
                            <!-- comments -->
                            {include file='__feeds_post.comments.tpl' post=$article}
                            <!-- comments -->
                        </div>
                        <!-- post footer -->
                    </div>
                    <!-- left panel -->

                    <!-- right panel -->
                    <div class="col-md-4">
                        <!-- add new article -->
                        {if $user->_logged_in && $user->_data['can_write_articles']}
                            <div class="mb10 hidden-xs">
                                <a href="{$system['system_url']}/blogs/new" class="btn btn-sm btn-success btn-block">
                                    <i class="fa fa-edit mr5"></i>{__("Write New Article")}
                                </a>
                            </div>
                        {/if}
                        <!-- add new article -->
                        
                        {include file='_ads.tpl'}
                        {include file='_widget.tpl'}

                        <!-- blogs categoris -->
                        <div class="articles-widget-header">
                            <div class="articles-widget-title">{__("Categories")}</div>
                        </div>
                        
                        <ul class="article-categories clearfix">
                            {foreach $blogs_categories as $category}
                                <li>
                                    <a class="article-category" href="{$system['system_url']}/blogs/category/{$category['category_id']}/{$category['category_url']}">
                                        {$category['category_name']}
                                    </a>
                                </li>
                            {/foreach}
                            <li>
                                <a class="article-category" href="{$system['system_url']}/blogs/category/0/Uncategorized">
                                    {__("Uncategorized")}
                                </a>
                            </li>
                        </ul>
                        <!-- blogs categoris -->

                        <!-- read more -->
                        <div class="articles-widget-header">
                            <div class="articles-widget-title">{__("Read More")}</div>
                        </div>
                        
                        {foreach $latest_articles as $article}
                        {include file='__feeds_article.tpl' _small=true}
                        {/foreach}
                        <!-- read more -->
                    </div>
                    <!-- right panel -->
                </div>
            </div>
            <!-- content panel -->
        {elseif $view == "edit"}
            <!-- side panel -->
            <div class="col-sm-4 col-md-2 offcanvas-sidebar">
                {include file='_sidebar.tpl'}
            </div>
            <!-- side panel -->

            <!-- content panel -->
            <div class="col-sm-8 col-md-10 offcanvas-mainbar">
                <!-- content -->
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <div class="mt5">
                            <strong>{__("Edit Article")}</strong>
                        </div>
                    </div>
                    <div class="panel-body">
                        <form class="js_ajax-forms form-horizontal" data-url="posts/article.php?do=edit&id={$article['post_id']}">
                            <div class="form-group">
                                <label class="col-md-2 control-label">
                                    {__("Title")}
                                </label>
                                <div class="col-md-10">
                                    <input class="form-control" name="title" value="{$article['article']['title']}">
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-md-2 control-label">
                                    {__("Content")}
                                </label>
                                <div class="col-md-10">
                                    <textarea name="text" class="form-control js_wysiwyg">{$article['article']['text']}</textarea>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-md-2 control-label">
                                    {__("Cover")}
                                </label>
                                <div class="col-md-10">
                                    {if $article['article']['cover'] == ''}
                                        <div class="x-image">
                                            <button type="button" class="close x-hidden js_x-image-remover" title='{__("Remove")}'>
                                                <span>×</span>
                                            </button>
                                            <div class="x-image-loader">
                                                <div class="progress x-progress">
                                                    <div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
                                                </div>
                                            </div>
                                            <i class="fa fa-camera fa-lg js_x-uploader" data-handle="x-image"></i>
                                            <input type="hidden" class="js_x-image-input" name="cover" value="">
                                        </div>
                                    {else}
                                        <div class="x-image" style="background-image: url('{$system['system_uploads']}/{$article['article']['cover']}')">
                                            <button type="button" class="close js_x-image-remover" title='{__("Remove")}'>
                                                <span>×</span>
                                            </button>
                                            <div class="x-image-loader">
                                                <div class="progress x-progress">
                                                    <div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
                                                </div>
                                            </div>
                                            <i class="fa fa-camera fa-lg js_x-uploader" data-handle="x-image"></i>
                                            <input type="hidden" class="js_x-image-input" name="cover" value="{$article['article']['cover']}">
                                        </div>
                                    {/if}
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-md-2 control-label">
                                    {__("Category")}
                                </label>
                                <div class="col-md-10">
                                    <select class="form-control" name="category">
                                        <option>{__("Select Category")}</option>
                                        {foreach $blogs_categories as $category}
                                        <option value="{$category['category_id']}" {if $article['article']['category_id'] == $category['category_id']}selected{/if}>{__($category['category_name'])}</option>
                                        {/foreach}
                                    </select>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-md-2 control-label">
                                    {__("Tags")}
                                </label>
                                <div class="col-md-10">
                                    <input class="form-control" name="tags" value="{$article['article']['tags']}">
                                </div>
                            </div>

                            <div class="form-group">
                                <div class="col-md-10 col-md-offset-2">
                                    <button type="submit" class="btn btn-primary">{__("Publish")}</button>
                                    <button type="button" class="btn btn-danger js_delete-article" data-id="{$article['post_id']}">
                                        <i class="fa fa-trash mr5"></i>{__("Delete Article")}
                                    </button>
                                </div>
                            </div>
                            
                            <!-- error -->
                            <div class="alert alert-danger mb0 mt10 x-hidden" role="alert"></div>
                            <!-- error -->

                        </form>
                    </div>
                </div>
                <!-- content -->
            </div>
            <!-- content panel -->
        {elseif $view == "new"}
            <!-- side panel -->
            <div class="col-sm-4 col-md-2 offcanvas-sidebar">
                {include file='_sidebar.tpl'}
            </div>
            <!-- side panel -->

            <!-- content panel -->
            <div class="col-sm-8 col-md-10 offcanvas-mainbar">
                <!-- content -->
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <div class="mt5">
                            <strong>{__("Write New Article")}</strong>
                        </div>
                    </div>
                    <div class="panel-body">
                        <form class="js_ajax-forms form-horizontal" data-url="posts/article.php?do=create">
                            <div class="form-group">
                                <label class="col-md-2 control-label">
                                    {__("Title")}
                                </label>
                                <div class="col-md-10">
                                    <input class="form-control" name="title">
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-md-2 control-label">
                                    {__("Content")}
                                </label>
                                <div class="col-md-10">
                                    <textarea name="text" class="form-control js_wysiwyg"></textarea>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-md-2 control-label">
                                    {__("Cover")}
                                </label>
                                <div class="col-md-10">
                                    <div class="x-image">
                                        <button type="button" class="close x-hidden js_x-image-remover" title='{__("Remove")}'>
                                            <span>×</span>
                                        </button>
                                        <div class="x-image-loader">
                                            <div class="progress x-progress">
                                                <div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
                                            </div>
                                        </div>
                                        <i class="fa fa-camera fa-lg js_x-uploader" data-handle="x-image"></i>
                                        <input type="hidden" class="js_x-image-input" name="cover">
                                    </div>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-md-2 control-label">
                                    {__("Category")}
                                </label>
                                <div class="col-md-10">
                                    <select class="form-control" name="category">
                                        <option>{__("Select Category")}</option>
                                        {foreach $blogs_categories as $category}
                                        <option value="{$category['category_id']}">{__($category['category_name'])}</option>
                                        {/foreach}
                                    </select>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-md-2 control-label">
                                    {__("Tags")}
                                </label>
                                <div class="col-md-10">
                                    <input class="form-control" name="tags">
                                </div>
                            </div>

                            <div class="form-group">
                                <div class="col-md-10 col-md-offset-2">
                                    <button type="submit" class="btn btn-primary">{__("Publish")}</button>
                                </div>
                            </div>
                            
                            <!-- error -->
                            <div class="alert alert-danger mb0 mt10 x-hidden" role="alert"></div>
                            <!-- error -->

                        </form>
                    </div>
                </div>
                <!-- content -->
            </div>
            <!-- content panel -->
        {/if}
    </div>
</div>
<!-- page content -->

{include file='_footer.tpl'}