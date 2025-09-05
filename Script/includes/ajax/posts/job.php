<?php

/**
 * ajax -> posts -> job
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich - Handles - @sorydima @sorydev @durovshater @DmitrySoro90935 @tanechfund - also check https://dmitry.rechain.network for more information!
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

// check if jobs enabled
if (!$system['jobs_enabled']) {
  modal("MESSAGE", __("Error"), __("This feature has been disabled by the admin"));
}

// check jobs permission
if (in_array($_GET['do'], ['create', 'publish', 'edit']) && !$user->_data['can_create_jobs']) {
  if (!$user->check_module_package_permission("jobs_permission")) {
    return_json(["callback" => "window.location = '" . $system['system_url'] . "/packages?highlight=true';"]);
  } else {
    modal("MESSAGE", __("Error"), __("You don't have the permission to do this"));
  }
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
      $smarty->assign('jobs_categories', $user->get_categories("jobs_categories"));
      $smarty->assign('currencies', $user->get_currencies());
      $smarty->assign('custom_fields', $user->get_custom_fields(["for" => "job"]));

      // return
      $return['template'] = $smarty->fetch("ajax.job.publisher.tpl");
      $return['callback'] = "$('#modal').modal('show'); $('.modal-content:last').html(response.template); initialize_modal();";
      break;

    case 'publish':
      // valid inputs
      /* check job title */
      if (is_empty($_POST['title'])) {
        return_json(['error' => true, 'message' => __("Add title for your job")]);
      }
      if (strlen($_POST['title']) < 3) {
        return_json(['error' => true, 'message' => __("Minimum job title is 3 characters")]);
      }
      if (strlen($_POST['title']) > 100) {
        return_json(['error' => true, 'message' => __("Maximum job title is 100 characters")]);
      }
      /* check job location */
      if (is_empty($_POST['location'])) {
        return_json(['error' => true, 'message' => __("Add location for your job")]);
      }
      /* check salary range */
      if (is_empty($_POST['salary_minimum']) || !is_numeric($_POST['salary_minimum']) || $_POST['salary_minimum'] <= 0) {
        return_json(['error' => true, 'message' => __("Enter valid minimum salary")]);
      }
      if (!$user->check_currency($_POST['salary_minimum_currency'])) {
        return_json(['error' => true, 'message' => __("Select valid currency for your job")]);
      }
      if (is_empty($_POST['salary_maximum']) || !is_numeric($_POST['salary_maximum']) || $_POST['salary_maximum'] <= 0) {
        return_json(['error' => true, 'message' => __("Enter valid maximum salary")]);
      }
      if (!$user->check_currency($_POST['salary_maximum_currency'])) {
        return_json(['error' => true, 'message' => __("Select valid currency for your job")]);
      }
      if (!in_array($_POST['pay_salary_per'], ['per_hour', 'per_day', 'per_week', 'per_month', 'per_year'])) {
        return_json(['error' => true, 'message' => __("Select valid salary payment period")]);
      }
      /* check job type */
      if (!in_array($_POST['type'], ['full_time', 'part_time', 'internship', 'volunteer', 'contract'])) {
        return_json(['error' => true, 'message' => __("Select valid job type")]);
      }
      /* check job category */
      if (is_empty($_POST['category'])) {
        return_json(['error' => true, 'message' => __("select valid category for your job")]);
      }
      if (!$user->get_category("jobs_categories", $_POST['category'])) {
        return_json(['error' => true, 'message' => __("select valid category for your job")]);
      }
      /* check job description */
      if (is_empty($_POST['description'])) {
        return_json(['error' => true, 'message' => __("Add description for your job")]);
      }
      if (strlen($_POST['description']) < 32) {
        return_json(['error' => true, 'message' => __("Minimum job description is 32 characters")]);
      }
      if (strlen($_POST['description']) > 1000) {
        return_json(['error' => true, 'message' => __("Maximum job description is 1000 characters")]);
      }
      /* check question #1 */
      if ($_POST['question_1_type'] == "multiple_choice") {
        if (is_empty($_POST['question_1_title'])) {
          return_json(['error' => true, 'message' => __("Enter your question") . " #1"]);
        }
        if (is_empty($_POST['question_1_choices'])) {
          return_json(['error' => true, 'message' => __("Enter choices for your question") . " #1"]);
        }
      } else {
        $_POST['question_1_type'] = (is_empty($_POST['question_1_title'])) ? "" : $_POST['question_1_type'];
      }
      /* check question #2 */
      if ($_POST['question_2_type'] == "multiple_choice") {
        if (is_empty($_POST['question_2_title'])) {
          return_json(['error' => true, 'message' => __("Enter your question") . " #2"]);
        }
        if (is_empty($_POST['question_2_choices'])) {
          return_json(['error' => true, 'message' => __("Enter choices for your question") . " #2"]);
        }
      } else {
        $_POST['question_2_type'] = (is_empty($_POST['question_1_title'])) ? "" : $_POST['question_2_type'];
      }
      /* check question #3 */
      if ($_POST['question_3_type'] == "multiple_choice") {
        if (is_empty($_POST['question_3_title'])) {
          return_json(['error' => true, 'message' => __("Enter your question") . " #3"]);
        }
        if (is_empty($_POST['question_3_choices'])) {
          return_json(['error' => true, 'message' => __("Enter choices for your question") . " #3"]);
        }
      } else {
        $_POST['question_3_type'] = (is_empty($_POST['question_1_title'])) ? "" : $_POST['question_3_type'];
      }
      /* check job cover */
      if (is_empty($_POST['cover_image'])) {
        return_json(['error' => true, 'message' => __("Add cover image for your job")]);
      }
      /* set custom fields */
      try {
        $inputs['custom_fields'] = $user->set_custom_fields($_POST, 'job');
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
      $inputs['job'] = (object)$_POST;

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
      $smarty->assign('jobs_categories', $user->get_categories("jobs_categories"));
      $smarty->assign('currencies', $user->get_currencies());
      $smarty->assign('custom_fields', $user->get_custom_fields(["for" => "job", "get" => "settings", "node_id" => $_GET['post_id']]));

      // return
      $return['template'] = $smarty->fetch("ajax.job.editor.tpl");
      $return['callback'] = "$('#modal').modal('show'); $('.modal-content:last').html(response.template); initialize_modal();";
      break;

    case 'application':
      // valid inputs
      if (!isset($_GET['post_id']) || !is_numeric($_GET['post_id'])) {
        _error(400);
      }

      // check if user applied before
      if ($user->check_user_job_application($_GET['post_id'])) {
        modal("ERROR", __("Sorry"), __("You already applied for this job before"));
      }

      // get post
      $post = $user->get_post($_GET['post_id'], false);
      if (!$post) {
        modal("MESSAGE", __("Error"), __("This content is no longer exist"));
      }
      /* assign variables */
      $smarty->assign('post', $post);

      // return
      $return['template'] = $smarty->fetch("ajax.job.apply.tpl");
      $return['callback'] = "$('#modal').modal('show'); $('.modal-content:last').html(response.template); initialize_modal();";
      break;

    case 'apply':
      // valid inputs
      if (!isset($_GET['post_id']) || !is_numeric($_GET['post_id'])) {
        _error(400);
      }

      // check if user applied before
      if ($user->check_user_job_application($_GET['post_id'])) {
        modal("ERROR", __("Sorry"), __("You already applied for this job before"));
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
      /* check job questions */
      if ($post['job']['question_1_title'] && is_empty($_POST['question_1_answer'])) {
        return_json(['error' => true, 'message' => __("Please answer all the questions")]);
      }
      if ($post['job']['question_2_title'] && is_empty($_POST['question_2_answer'])) {
        return_json(['error' => true, 'message' => __("Please answer all the questions")]);
      }
      if ($post['job']['question_3_title'] && is_empty($_POST['question_3_answer'])) {
        return_json(['error' => true, 'message' => __("Please answer all the questions")]);
      }

      // send job application
      $user->send_job_application($post, $_POST);

      // return
      modal("SUCCESS", __("Done"), __("Your application has been submitted successfully"));
      break;

    case 'candidates':
      // valid inputs
      if (!isset($_GET['post_id']) || !is_numeric($_GET['post_id'])) {
        _error(400);
      }

      // get job candidates
      $candidates = $user->get_job_candidates($_GET['post_id']);
      /* assign variables */
      $smarty->assign('post_id', $_GET['post_id']);
      $smarty->assign('candidates', $candidates);
      $smarty->assign('candidates_count', $user->get_total_job_candidates($_GET['post_id']));

      // return
      $return['template'] = $smarty->fetch("ajax.job.candidates.tpl");
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
