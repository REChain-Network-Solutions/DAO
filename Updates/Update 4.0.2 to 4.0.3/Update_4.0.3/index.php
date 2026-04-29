<?php

/**
 * index
 * 
 * @package Sngine
 * @author Zamblek
 */

// fetch bootloader
require('bootloader.php');

try {

  // check user logged in
  if (!$user->_logged_in) {

    // page header
    page_header(__("Welcome to") . ' ' . __($system['system_title']));

    if (!$system['newsfeed_public']) {

      // get genders
      $smarty->assign('genders', $user->get_genders());

      // get countries if not defined
      if (!$countries) {
        $smarty->assign('countries', $user->get_countries());
      }

      // get custom fields
      $smarty->assign('custom_fields', $user->get_custom_fields());

      // get users groups
      if ($system['select_user_group_enabled']) {
        $smarty->assign('user_groups', $user->get_users_groups());
      }
    } else {

      // check the view
      if ($_GET['view'] != "") {
        user_access();
      }

      // get announcements
      $smarty->assign('announcements', $user->get_announcements());

      // get widgets (newsfeed top)
      $newsfeed_widgets = $user->widgets('newsfeed_top');
      /* assign variables */
      $smarty->assign('newsfeed_widgets', $newsfeed_widgets);

      // newsfeed location filter
      if ($system['newsfeed_location_filter_enabled']) {
        // get countries if not defined
        if (!$countries) {
          $smarty->assign('countries', $user->get_countries());
        }

        // get selected country
        if (isset($_GET['country'])) {
          /* get selected country */
          $selected_country = $user->get_country_by_name($_GET['country']);
          /* assign variables */
          $smarty->assign('selected_country', $selected_country);
        }
      }

      // get boosted post
      if ($system['packages_enabled']) {
        $smarty->assign('boosted_post', $user->get_boosted_post());
      }

      // get posts (newsfeed)
      $posts = ($selected_country) ? $user->get_posts(['country' => $selected_country['country_id']]) : $user->get_posts();
      /* assign variables */
      $smarty->assign('posts', $posts);

      // get ads campaigns
      $ads_campaigns = $user->ads_campaigns();
      /* assign variables */
      $smarty->assign('ads_campaigns', $ads_campaigns);
    }
  } else {

    // user access
    user_access();

    // get announcements
    $smarty->assign('announcements', $user->get_announcements());

    // get view content
    switch ($_GET['view']) {
      case '':
        // page header
        page_header(__($system['system_title']));

        // get merits categories
        if ($system['merits_enabled'] && $system['merits_widgets_newsfeed']) {
          $smarty->assign('merits_categories', $user->get_categories("merits_categories"));
        }

        // get stories
        if ($system['stories_enabled']) {
          $smarty->assign('stories', $user->get_stories());
          $smarty->assign('has_story', $user->get_my_story());
        }

        // prepare publisher
        $smarty->assign('feelings', get_feelings());
        $smarty->assign('feelings_types', get_feelings_types());
        if ($system['colored_posts_enabled']) {
          $smarty->assign('colored_patterns', $user->get_posts_colored_patterns());
        }
        if ($user->_data['can_upload_videos']) {
          $smarty->assign('videos_categories', $user->get_categories("posts_videos_categories"));
        }

        // check daytime messages
        $daytime_msg_enabled = (isset($_COOKIE['dt_msg'])) ? false : $system['daytime_msg_enabled'];
        $smarty->assign('daytime_msg_enabled', $daytime_msg_enabled);

        // get widgets (newsfeed top)
        $newsfeed_widgets = $user->widgets('newsfeed_top');
        /* assign variables */
        $smarty->assign('newsfeed_widgets', $newsfeed_widgets);

        // newsfeed location filter
        if ($system['newsfeed_location_filter_enabled']) {
          // get countries if not defined
          if (!$countries) {
            $smarty->assign('countries', $user->get_countries());
          }

          // get selected country
          if (isset($_GET['country'])) {
            /* get selected country */
            $selected_country = $user->get_country_by_name($_GET['country']);
            /* assign variables */
            $smarty->assign('selected_country', $selected_country);
          }
        }

        // get boosted post
        if ($system['packages_enabled']) {
          $smarty->assign('boosted_post', $user->get_boosted_post());
        }

        // get posts (newsfeed)
        if ($system['newsfeed_merge_enabled']) {
          /* first get the posts from normal newsfeed */
          $posts_newsfeed = ($selected_country) ? $user->get_posts(['country' => $selected_country['country_id'], 'results' => $system['merge_recent_results']]) : $user->get_posts(['results' => $system['merge_recent_results']]);
          /* second get the posts from popular */
          $posts_popular = ($selected_country) ? $user->get_posts(['country' => $selected_country['country_id'], 'get' => 'popular', 'results' => $system['merge_popular_results']]) : $user->get_posts(['get' => 'popular', 'results' => $system['merge_popular_results']]);
          $posts_popular = array_map(function ($element) {
            $element['source'] = "popular";
            return $element;
          }, $posts_popular);
          /* third get the posts from discover */
          $posts_discover = ($selected_country) ? $user->get_posts(['country' => $selected_country['country_id'], 'get' => 'discover', 'results' => $system['merge_discover_results']]) :  $user->get_posts(['get' => 'discover', 'results' => $system['merge_discover_results']]);
          $posts_discover = array_map(function ($element) {
            $element['source'] = "discover";
            return $element;
          }, $posts_discover);
          /* merge the three arrays */
          $posts = array_merge($posts_newsfeed, $posts_popular, $posts_discover);
        } else {
          $posts = ($selected_country) ? $user->get_posts(['country' => $selected_country['country_id']]) : $user->get_posts();
        }
        /* if empty posts -> clear cache and reload */
        if ($system['newsfeed_caching_enabled'] && empty($posts)) {
          $redirect = $user->clear_posts_cache();
          if ($redirect) {
            redirect();
          }
        }
        /* assign variables */
        $smarty->assign('posts', $posts);
        break;

      case 'popular':
        // check if popular posts enabled
        if (!$system['popular_posts_enabled']) {
          _error(404);
        }

        // page header
        page_header(__("Popular Posts"));

        // newsfeed location filter
        if ($system['newsfeed_location_filter_enabled']) {
          // get countries if not defined
          if (!$countries) {
            $smarty->assign('countries', $user->get_countries());
          }

          // get selected country
          if (isset($_GET['country'])) {
            /* get selected country */
            $selected_country = $user->get_country_by_name($_GET['country']);
            /* assign variables */
            $smarty->assign('selected_country', $selected_country);
          }
        }

        // get posts (popular)
        $posts = ($selected_country) ? $user->get_posts(['country' => $selected_country['country_id'], 'get' => 'popular']) : $user->get_posts(['get' => 'popular']);
        /* assign variables */
        $smarty->assign('posts', $posts);
        break;

      case 'discover':
        // check if discover posts enabled
        if (!$system['discover_posts_enabled']) {
          _error(404);
        }

        // page header
        page_header(__("Discover Posts"));

        // newsfeed location filter
        if ($system['newsfeed_location_filter_enabled']) {
          // get countries if not defined
          if (!$countries) {
            $smarty->assign('countries', $user->get_countries());
          }

          // get selected country
          if (isset($_GET['country'])) {
            /* get selected country */
            $selected_country = $user->get_country_by_name($_GET['country']);
            /* assign variables */
            $smarty->assign('selected_country', $selected_country);
          }
        }

        // get posts (discover)
        $posts = ($selected_country) ? $user->get_posts(['country' => $selected_country['country_id'], 'get' => 'discover']) : $user->get_posts(['get' => 'discover']);
        /* if empty posts -> clear cache and reload */
        if ($system['newsfeed_caching_enabled'] && empty($posts)) {
          $redirect = $user->clear_posts_cache();
          if ($redirect) {
            redirect('/discover');
          }
        }
        /* assign variables */
        $smarty->assign('posts', $posts);
        break;

      case 'blogs':
        // check if blogs enabled
        if (!$system['blogs_enabled']) {
          _error(404);
        }

        // check blogs permission
        if (!$user->_data['can_write_blogs']) {
          _error(404);
        }

        // page header
        page_header(__("My Blogs"));

        // get posts (blogs)
        $posts = $user->get_posts(['get' => 'posts_profile', 'id' => $user->_data['user_id'], 'filter' => 'article']);
        /* assign variables */
        $smarty->assign('posts', $posts);
        break;

      case 'products':
        // check if market enabled
        if (!$system['market_enabled']) {
          _error(404);
        }

        // check market permission
        if (!$user->_data['can_sell_products']) {
          _error(404);
        }

        // page header
        page_header(__("My Products"));

        // get posts (products)
        $posts = $user->get_posts(['get' => 'posts_profile', 'id' => $user->_data['user_id'], 'filter' => 'product']);
        /* assign variables */
        $smarty->assign('posts', $posts);
        break;

      case 'funding':
        // check if funding enabled
        if (!$system['funding_enabled']) {
          _error(404);
        }

        // check funding permission
        if (!$user->_data['can_raise_funding']) {
          _error(404);
        }

        // page header
        page_header(__("My Funding"));

        // get posts (funding)
        $posts = $user->get_posts(['get' => 'posts_profile', 'id' => $user->_data['user_id'], 'filter' => 'funding']);
        /* assign variables */
        $smarty->assign('posts', $posts);
        break;

      case 'offers':
        // check if offers enabled
        if (!$system['offers_enabled']) {
          _error(404);
        }

        // check offers permission
        if (!$user->_data['can_create_offers']) {
          _error(404);
        }

        // page header
        page_header(__("My Offers"));

        // get posts (offers)
        $posts = $user->get_posts(['get' => 'posts_profile', 'id' => $user->_data['user_id'], 'filter' => 'offer']);
        /* assign variables */
        $smarty->assign('posts', $posts);
        break;

      case 'jobs':
        // check if jobs enabled
        if (!$system['jobs_enabled']) {
          _error(404);
        }

        // check jobs permission
        if (!$user->_data['can_create_jobs']) {
          _error(404);
        }

        // page header
        page_header(__("My Jobs"));

        // get posts (jobs)
        $posts = $user->get_posts(['get' => 'posts_profile', 'id' => $user->_data['user_id'], 'filter' => 'job']);
        /* assign variables */
        $smarty->assign('posts', $posts);
        break;

      case 'courses':
        // check if courses enabled
        if (!$system['courses_enabled']) {
          _error(404);
        }

        // check courses permission
        if (!$user->_data['can_create_courses']) {
          _error(404);
        }

        // page header
        page_header(__("My Courses"));

        // get posts (courses)
        $posts = $user->get_posts(['get' => 'posts_profile', 'id' => $user->_data['user_id'], 'filter' => 'course']);
        /* assign variables */
        $smarty->assign('posts', $posts);
        break;

      case 'saved':
        // page header
        page_header(__("Saved Posts"));

        // get posts (saved)
        $posts = $user->get_posts(['get' => 'saved']);
        /* assign variables */
        $smarty->assign('posts', $posts);
        break;

      case 'scheduled':
        // page header
        page_header(__("Scheduled Posts"));

        // get posts (scheduled)
        $posts = $user->get_posts(['get' => 'scheduled']);
        /* assign variables */
        $smarty->assign('posts', $posts);
        break;

      case 'memories':
        // page header
        page_header(__("Memories"));

        // get posts (memories)
        $posts = $user->get_posts(['get' => 'memories']);
        /* assign variables */
        $smarty->assign('posts', $posts);
        break;

      case 'boosted_posts':
        // check if packages enabled
        if (!$system['packages_enabled']) {
          error(404);
        }

        // page header
        page_header(__("Boosted Posts"));

        // get posts (boosted)
        $posts = $user->get_posts(['get' => 'boosted']);
        /* assign variables */
        $smarty->assign('posts', $posts);
        break;

      case 'boosted_pages':
        // check if packages enabled
        if (!$system['packages_enabled']) {
          error(404);
        }

        // check if pages enabled
        if (!$system['pages_enabled']) {
          error(404);
        }

        // page header
        page_header(__("Boosted Pages"));

        // get pages (boosted)
        $boosted_pages = $user->get_pages(['boosted' => true]);
        /* assign variables */
        $smarty->assign('boosted_pages', $boosted_pages);
        break;

      case 'watch':
        // check if watch enabled
        if (!$system['watch_enabled']) {
          _error(404);
        }

        // page header
        page_header(__("Watch") . ' | ' . __($system['system_title']));

        // newsfeed location filter
        if ($system['newsfeed_location_filter_enabled']) {
          // get countries if not defined
          if (!$countries) {
            $smarty->assign('countries', $user->get_countries());
          }

          // get selected country
          if (isset($_GET['country'])) {
            /* get selected country */
            $selected_country = $user->get_country_by_name($_GET['country']);
            /* assign variables */
            $smarty->assign('selected_country', $selected_country);
          }
        }

        // get posts (watch)
        /* first get the videos from public */
        $posts_discover = ($selected_country) ? $user->get_posts(['get' => 'discover', 'filter' => 'video', 'country' => $selected_country['country_id']]) : $user->get_posts(['get' => 'discover', 'filter' => 'video']);
        /* second get the videos from friends */
        $posts_friends = ($selected_country) ? $user->get_posts(['get' => 'newsfeed', 'filter' => 'video', 'country' => $selected_country['country_id']]) : $user->get_posts(['get' => 'newsfeed', 'filter' => 'video']);
        /* merge the two arrays */
        $posts = array_merge($posts_discover, $posts_friends);
        /* assign variables */
        $smarty->assign('posts', $posts);
        break;
      default:
        _error(404);
        break;
    }
    /* assign variables */
    $smarty->assign('view', $_GET['view']);


    /* get the merits balance (if enabled) */
    if ($system['merits_enabled'] && $system['merits_widgets_balance']) {
      $user->_data['merits_balance'] = $user->get_user_merits_balance();
    }

    // get merits top users
    if ($system['merits_enabled'] && $system['merits_widgets_winners']) {
      $smarty->assign('top_merits_users', $user->get_merits_top_users());
    }

    // get pro members & pages
    if ($system['packages_enabled']) {
      // get pro members
      $pro_members = $user->get_pro_members();
      /* assign variables */
      $smarty->assign('pro_members', $pro_members);
      // get promoted pages
      if ($system['pages_enabled']) {
        $promoted_pages = $user->get_pages(['promoted' => true]);
        /* assign variables */
        $smarty->assign('promoted_pages', $promoted_pages);
      }
    }

    // get suggested people
    $new_people = $user->get_new_people(0, true);
    /* assign variables */
    $smarty->assign('new_people', $new_people);

    // get suggested pages
    if ($system['pages_enabled']) {
      $new_pages = $user->get_pages(['suggested' => true, 'random' => 'true', 'results' => 5]);
      /* assign variables */
      $smarty->assign('new_pages', $new_pages);
    }

    // get suggested groups
    if ($system['groups_enabled']) {
      $new_groups = $user->get_groups(['suggested' => true, 'random' => 'true', 'results' => 5]);
      /* assign variables */
      $smarty->assign('new_groups', $new_groups);
    }

    // get suggested events
    if ($system['events_enabled']) {
      $new_events = $user->get_events(['suggested' => true, 'random' => 'true', 'results' => 5]);
      /* assign variables */
      $smarty->assign('new_events', $new_events);
    }

    // get ads campaigns
    $ads_campaigns = $user->ads_campaigns();
    /* assign variables */
    $smarty->assign('ads_campaigns', $ads_campaigns);
  }

  // get trending hashtags
  if (!(!$user->_logged_in && !$system['newsfeed_public']) && $system['trending_hashtags_enabled']) {
    $trending_hashtags = $user->get_trending_hashtags();
    /* assign variables */
    $smarty->assign('trending_hashtags', $trending_hashtags);
  }

  // get ads
  $ads = $user->ads('home');
  /* assign variables */
  $smarty->assign('ads', $ads);

  // get widgets
  $widgets = $user->widgets('home');
  /* assign variables */
  $smarty->assign('widgets', $widgets);
} catch (Exception $e) {
  _error(__("Error"), $e->getMessage());
}

// page footer
page_footer('index');
