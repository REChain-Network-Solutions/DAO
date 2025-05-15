<?php

/**
 * ajax -> posts -> course
 * 
 * @package Delus
 * @author Dmitry Sorokin - @sorydima & @sorydev Handles. 
 */

// fetch bootstrap
require('../../../bootstrap.php');

// check AJAX Request
is_ajax();

// user access
user_access(true);

// check demo account
if ($user->_data['user_demo']) {
  modal("ERROR", __("Demo Restriction"), __("You can't do this with demo account"));
}

// check if courses enabled
if (!$system['courses_enabled']) {
  modal("MESSAGE", __("Error"), __("This feature has been disabled by the admin"));
}

// check courses permission
if (in_array($_GET['do'], ['create', 'publish', 'edit']) && !$user->_data['can_create_courses']) {
  modal("MESSAGE", __("Error"), __("You don't have the permission to do this"));
}

try {

  // initialize the return array
  $return = [];

  switch ($_GET['do']) {
    case 'create':
      // valid inputs
      if (isset($_GET['page'])) {
        $share_to = "page";
        $share_to_id = (int) $_GET['page'];
      } elseif (isset($_GET['group'])) {
        $share_to = "group";
        $share_to_id = (int) $_GET['group'];
      } elseif (isset($_GET['event'])) {
        $share_to = "event";
        $share_to_id = (int) $_GET['event'];
      }

      // assign variables
      $smarty->assign('share_to', $share_to);
      $smarty->assign('share_to_id', $share_to_id);
      $smarty->assign('courses_categories', $user->get_categories("courses_categories"));
      $smarty->assign('currencies', $user->get_currencies());
      $smarty->assign('custom_fields', $user->get_custom_fields(["for" => "course"]));

      // return
      $return['template'] = $smarty->fetch("ajax.course.publisher.tpl");
      $return['callback'] = "$('#modal').modal('show'); $('.modal-content:last').html(response.template); initialize_modal();";
      break;

    case 'publish':
      // valid inputs
      /* check course title */
      if (is_empty($_POST['title'])) {
        return_json(['error' => true, 'message' => __("Add title for your course")]);
      }
      if (strlen($_POST['title']) < 3) {
        return_json(['error' => true, 'message' => __("Minimum course title is 3 characters")]);
      }
      if (strlen($_POST['title']) > 100) {
        return_json(['error' => true, 'message' => __("Maximum course title is 100 characters")]);
      }
      /* check course location */
      if (is_empty($_POST['location'])) {
        return_json(['error' => true, 'message' => __("Add location for your course")]);
      }
      /* check fees */
      if (is_empty($_POST['fees']) || !is_numeric($_POST['fees']) || $_POST['fees'] < 0) {
        return_json(['error' => true, 'message' => __("Enter valid fees for your course")]);
      }
      if (!$user->check_currency($_POST['fees_currency'])) {
        return_json(['error' => true, 'message' => __("Select valid currency for your course")]);
      }
      /* check start date */
      if (is_empty($_POST['start_date'])) {
        return_json(['error' => true, 'message' => __("Add start date for your course")]);
      }
      if (strtotime($_POST['start_date']) < time()) {
        return_json(['error' => true, 'message' => __("Start date must be greater than current date")]);
      }
      /* check end date */
      if (is_empty($_POST['end_date'])) {
        return_json(['error' => true, 'message' => __("Add end date for your course")]);
      }
      if (strtotime($_POST['end_date']) < strtotime($_POST['start_date'])) {
        return_json(['error' => true, 'message' => __("End date must be greater than start date")]);
      }
      /* check course category */
      if (is_empty($_POST['category'])) {
        return_json(['error' => true, 'message' => __("select valid category for your course")]);
      }
      if (!$user->get_category("courses_categories", $_POST['category'])) {
        return_json(['error' => true, 'message' => __("select valid category for your course")]);
      }
      /* check course description */
      if (is_empty($_POST['description'])) {
        return_json(['error' => true, 'message' => __("Add description for your course")]);
      }
      if (strlen($_POST['description']) < 32) {
        return_json(['error' => true, 'message' => __("Minimum course description is 32 characters")]);
      }
      if (strlen($_POST['description']) > 1000) {
        return_json(['error' => true, 'message' => __("Maximum course description is 1000 characters")]);
      }
      /* check course cover */
      if (is_empty($_POST['cover_image'])) {
        return_json(['error' => true, 'message' => __("Add cover image for your course")]);
      }
      /* set custom fields */
      try {
        $inputs['custom_fields'] = $user->set_custom_fields($_POST, 'course');
      } catch (Exception $e) {
        return_json(['error' => true, 'message' => $e->getMessage()]);
      }
      /* check handle */
      switch ($_POST['handle']) {
        case 'page':
          if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
            _error(400);
          }
          $inputs['handle'] = "page";
          $inputs['id'] = $_POST['id'];
          $inputs['privacy'] = 'public';
          break;

        case 'group':
          if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
            _error(400);
          }
          $inputs['handle'] = "group";
          $inputs['id'] = $_POST['id'];
          $inputs['privacy'] = 'custom';
          break;

        case 'event':
          if (!isset($_POST['id']) || !is_numeric($_POST['id'])) {
            _error(400);
          }
          $inputs['handle'] = "event";
          $inputs['id'] = $_POST['id'];
          $inputs['privacy'] = 'custom';
          break;

        default:
          $inputs['privacy'] = "public";
          break;
      }

      /* prepare inputs */
      $inputs['is_anonymous'] = '0';
      $inputs['message'] = $_POST['description'];
      $inputs['course'] = (object)$_POST;

      // publish
      $post = $user->publisher($inputs);

      // return
      $return['callback'] = "window.location = '" . $system['system_url'] . "/posts/" . $post['post_id'] . "';";
      break;

    case 'edit':
      // valid inputs
      if (!isset($_GET['post_id']) || !is_numeric($_GET['post_id'])) {
        _error(400);
      }

      // get post
      $post = $user->get_post($_GET['post_id']);
      if (!$post) {
        modal("MESSAGE", __("Error"), __("This content is no longer exist"));
      }
      /* assign variables */
      $smarty->assign('post', $post);
      $smarty->assign('courses_categories', $user->get_categories("courses_categories"));
      $smarty->assign('currencies', $user->get_currencies());
      $smarty->assign('custom_fields', $user->get_custom_fields(["for" => "course", "get" => "settings", "node_id" => $_GET['post_id']]));

      // return
      $return['template'] = $smarty->fetch("ajax.course.editor.tpl");
      $return['callback'] = "$('#modal').modal('show'); $('.modal-content:last').html(response.template); initialize_modal();";
      break;

    case 'application':
      // valid inputs
      if (!isset($_GET['post_id']) || !is_numeric($_GET['post_id'])) {
        _error(400);
      }

      // check if user applied before
      if ($user->check_user_course_application($_GET['post_id'])) {
        modal("ERROR", __("Sorry"), __("You already applied for this course before"));
      }

      // get post
      $post = $user->get_post($_GET['post_id'], false);
      if (!$post) {
        modal("MESSAGE", __("Error"), __("This content is no longer exist"));
      }
      /* assign variables */
      $smarty->assign('post', $post);

      // return
      $return['template'] = $smarty->fetch("ajax.course.apply.tpl");
      $return['callback'] = "$('#modal').modal('show'); $('.modal-content:last').html(response.template); initialize_modal();";
      break;

    case 'apply':
      // valid inputs
      if (!isset($_GET['post_id']) || !is_numeric($_GET['post_id'])) {
        _error(400);
      }

      // check if user applied before
      if ($user->check_user_course_application($_GET['post_id'])) {
        modal("ERROR", __("Sorry"), __("You already applied for this course before"));
      }

      // get post
      $post = $user->get_post($_GET['post_id'], false);
      if (!$post) {
        modal("MESSAGE", __("Error"), __("This content is no longer exist"));
      }

      // valid inputs
      /* check name */
      if (is_empty($_POST['name'])) {
        return_json(['error' => true, 'message' => __("Please enter your name")]);
      }
      /* check location */
      if (is_empty($_POST['location'])) {
        return_json(['error' => true, 'message' => __("Please enter your location")]);
      }
      /* check phone */
      if (is_empty($_POST['phone'])) {
        return_json(['error' => true, 'message' => __("Please enter your phone number")]);
      }
      /* check email */
      if (is_empty($_POST['email'])) {
        return_json(['error' => true, 'message' => __("Please enter your email")]);
      }
      if (!valid_email($_POST['email'])) {
        return_json(['error' => true, 'message' => __("Please enter a valid email address")]);
      }

      // send course application
      $user->send_course_application($post, $_POST);

      // return
      modal("SUCCESS", __("Done"), __("Your application has been submitted successfully"));
      break;

    case 'candidates':
      // valid inputs
      if (!isset($_GET['post_id']) || !is_numeric($_GET['post_id'])) {
        _error(400);
      }

      // get course candidates
      $candidates = $user->get_course_candidates($_GET['post_id']);
      /* assign variables */
      $smarty->assign('post_id', $_GET['post_id']);
      $smarty->assign('candidates', $candidates);
      $smarty->assign('candidates_count', $user->get_total_course_candidates($_GET['post_id']));

      // return
      $return['template'] = $smarty->fetch("ajax.course.candidates.tpl");
      $return['callback'] = "$('#modal').modal('show'); $('.modal-content:last').html(response.template); initialize_modal();";
      break;

    default:
      _error(400);
      break;
  }

  // return & exit
  return_json($return);
} catch (Exception $e) {
  modal("ERROR", __("Error"), $e->getMessage());
}
