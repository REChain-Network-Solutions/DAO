<?php

/**
 * blogs
 * 
 * @package Sngine
 * @author Zamblek
 */

// fetch bootloader
require('bootloader.php');

// blogs enabled
if (!$system['blogs_enabled']) {
  _error(404);
}

// rss feed
if (isset($_GET['view']) && $_GET['view'] == 'rss') {
  if (!$system['system_public'] || !$system['blogs_rss_enabled']) {
    _error(404);
  }
  try {
    $user->get_blogs_feed([
      'category_id' => $_GET['category_id'] ?? null,
    ]);
  } catch (Exception $e) {
    _error(__("Error"), $e->getMessage());
  }
}

// user access
if ($user->_logged_in || !$system['system_public']) {
  user_access();
}

try {

  // get view content
  $_GET['view'] = (isset($_GET['view'])) ? $_GET['view'] : '';
  switch ($_GET['view']) {
    case '':
    case 'search':
    case 'category':
    case 'manage':
      $args = [
        'sort' => $_GET['sort'] ?? '',
        'country' => $_GET['country'] ?? null,
        'distance' => $_GET['distance'] ?? null,
        'page' => $_GET['page'] ?? 1,
      ];
      switch ($_GET['view']) {
        case '':
          // page header
          page_header(__("Blogs") . ' | ' . __($system['system_title']), __($system['system_description_blogs']));

          // get blogs categories
          $smarty->assign('categories', $user->get_categories("blogs_categories"));
          $smarty->assign('promoted_blogs', $user->get_promoted_blogs());
          if ($system['blogs_rss_enabled']) {
            $smarty->assign('rss_url', $system['system_url'] . '/blogs/rss');
          }
          $args['url'] = "";
          break;

        case 'search':
          // check query
          if (!isset($_GET['query']) || is_empty($_GET['query'])) {
            redirect('/blogs');
          }
          /* assign variables */
          $smarty->assign('query', htmlentities($_GET['query'], ENT_QUOTES, 'utf-8'));

          // page header
          page_header(__("Blogs") . ' &rsaquo; ' . __("Search") . ' | ' . __($system['system_title']), __($system['system_description_blogs']));

          // get blogs categories
          $smarty->assign('categories', $user->get_categories("blogs_categories"));
          $args['query'] = $_GET['query'];
          $args['url'] = "/search/" . $_GET['query'];
          break;

        case 'category':
          // check category
          $current_category = $user->get_category("blogs_categories", $_GET['category_id'], true);
          if (!$current_category) {
            _error(404);
          }
          /* assign variables */
          $smarty->assign('current_category', $current_category);

          // page header
          page_header(__("Blogs") . ' &rsaquo; ' . __($current_category['category_name']) . ' | ' . __($system['system_title']), __($current_category['category_description']));

          // get blogs categories (only sub-categories)
          if (!$current_category['sub_categories'] && !$current_category['parent']) {
            $categories = $user->get_categories("blogs_categories");
          } else {
            $categories = $user->get_categories("blogs_categories", $current_category['category_id']);
          }
          $smarty->assign('categories', $categories);
          if ($system['blogs_rss_enabled']) {
            $smarty->assign('rss_url', $system['system_url'] . '/blogs/category/' . $current_category['category_id'] . '/' . $current_category['category_url'] . '/rss');
          }
          $args['category'] = $current_category['category_id'];
          $args['url'] = "/category/" . $current_category['category_id'] . "/" . $current_category['category_url'];
          break;

        case 'manage':
          // user access
          user_access();

          // page header
          page_header(__("My Blogs") . ' | ' . __($system['system_title']), __($system['system_description_blogs']));

          $args['managed'] = true;
          $args['user_id'] = $user->_data['user_id'];
          $args['url'] = "/manage";
          break;
      }

      // get blogs
      $smarty->assign($user->get_blogs_listing($args));

      // get ads
      $smarty->assign('ads', $user->ads('blogs'));
      break;

    case 'blog':
      // get blog
      $blog = $user->get_post($_GET['post_id']);
      if (!$blog) {
        _error(404);
      }
      // check if blog is still scheduled
      if ($blog['still_scheduled'] && !$blog['manage_post']) {
        _error(404);
      }
      // reading time
      $reading_text = html_entity_decode(strip_tags(preg_replace('/<[^>]*>/', ' ', $blog['blog']['parsed_text'] ?? '')), ENT_QUOTES | ENT_HTML5, 'UTF-8');
      $reading_words = preg_match_all('/[\p{L}\p{N}]+(?:[\x{2019}\x{0027}-][\p{L}\p{N}]+)*/u', $reading_text);
      $smarty->assign('reading_time', max(1, (int) ceil($reading_words / 200)));

      /* assign variables */
      $smarty->assign('blog', $blog);
      if ($system['blogs_rss_enabled']) {
        if (!empty($blog['blog']['category_id']) && !empty($blog['blog']['category_url'])) {
          $smarty->assign('rss_url', $system['system_url'] . '/blogs/category/' . $blog['blog']['category_id'] . '/' . $blog['blog']['category_url'] . '/rss');
        } else {
          $smarty->assign('rss_url', $system['system_url'] . '/blogs/rss');
        }
      }

      // page header
      page_header($blog['og_title'] . ' | ' . __($system['system_title']), $blog['og_description'], $blog['og_image']);

      // get blogs categories (only parents)
      $smarty->assign('blogs_categories', $user->get_categories("blogs_categories", 0, false, true));

      // get latest blogs
      $latest_blogs = $user->get_blogs(['random' => "true", 'results' => 6]);
      $latest_blogs = array_values(array_filter($latest_blogs, function ($latest_blog) use ($blog) {
        return $latest_blog['post_id'] != $blog['post_id'];
      }));
      $smarty->assign('latest_blogs', array_slice($latest_blogs, 0, 5));

      // get ads
      $smarty->assign('ads', $user->ads('blog'));
      $smarty->assign('ads_footer', $user->ads('blog_footer'));

      // get widgets
      $smarty->assign('widgets', $user->widgets('blog'));
      break;

    case 'edit':
      // user access
      user_access();

      // check blogs permission
      if (!$user->_data['can_write_blogs']) {
        if ($user->check_module_package_permission("blogs_permission")) {
          redirect("/packages?highlight=true");
        }
        _error(404);
      }

      // page header
      page_header(__("Edit Blog") . ' | ' . __($system['system_title']), __($system['system_description_blogs']));

      // get blog
      $blog = $user->get_post($_GET['post_id']);
      if (!$blog || !$blog['can_edit_post']) {
        _error(404);
      }
      /* assign variables */
      $smarty->assign('blog', $blog);

      // get blogs categories
      $smarty->assign('blogs_categories', $user->get_categories("blogs_categories"));
      break;

    case 'new':
      // user access
      user_access();

      // check blogs permission
      if (!$user->_data['can_write_blogs']) {
        if ($user->check_module_package_permission("blogs_permission")) {
          redirect("/packages?highlight=true");
        }
        _error(404);
      }

      // page header
      page_header(__("Create New Blog") . ' | ' . __($system['system_title']), __($system['system_description_blogs']));

      // prepare publisher
      /* publish-to options */
      $share_to = "timeline";
      if (isset($_GET['page'])) {
        $share_to = "page";
        $share_to_page_id = (int) $_GET['page'];
        $smarty->assign('share_to_page_id', $share_to_page_id);
      } elseif (isset($_GET['group'])) {
        $share_to = "group";
        $share_to_group_id = (int) $_GET['group'];
        $smarty->assign('share_to_group_id', $share_to_group_id);
      } elseif (isset($_GET['event'])) {
        $share_to = "event";
        $share_to_event_id = (int) $_GET['event'];
        $smarty->assign('share_to_event_id', $share_to_event_id);
      }
      $smarty->assign('share_to', $share_to);
      /* get user pages */
      $smarty->assign('pages', $user->get_pages(['get_all' => true, 'managed' => true, 'user_id' => $user->_data['user_id']]));
      /* get user groups */
      $smarty->assign('groups', $user->get_groups(['get_all' => true, 'user_id' => $user->_data['user_id']]));
      /* get user events */
      $smarty->assign('events', $user->get_events(['get_all' => true, 'user_id' => $user->_data['user_id']]));

      // get blogs categories
      $smarty->assign('blogs_categories', $user->get_categories("blogs_categories"));
      break;

    default:
      _error(404);
      break;
  }
  /* assign variables */
  $smarty->assign('view', $_GET['view']);
} catch (Exception $e) {
  _error(__("Error"), $e->getMessage());
}

// page footer
page_footer('blogs');
