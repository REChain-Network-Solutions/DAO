<?php

/**
 * APIs -> modules -> monetization -> controller
 *
 * @package Sngine
 * @author Zamblek
 */

// _initMonetizationPlans
function _initMonetizationPlans()
{
  global $user;
  // check demo account
  if ($user->_data['user_demo']) {
    throw new AuthorizationException(__("You can't do this with demo account"));
  }

  // check if monetization is enabled
  if (!$user->_data['can_monetize_content']) {
    throw new AuthorizationException(__("This feature has been disabled by the admin"));
  }
}

// getMonetizationPlans
function getMonetizationPlans($req, $res)
{
  global $user;
  $monetization_plans = $user->get_monetization_plans();
  apiResponse($res, ['data' => $monetization_plans]);
}

// getMonetizationPlan
function getMonetizationPlan($req, $res)
{
  global $user;
  _initMonetizationPlans();
  $monetization_plan = $user->get_monetization_plan($req->params['id']);
  apiResponse($res, ['data' => $monetization_plan]);
}

// insertMonetizationPlan
function insertMonetizationPlan($req, $res)
{
  global $user;
  _initMonetizationPlans();
  $monetization_plan = $user->insert_monetization_plan($req->body['node_id'], $req->body['node_type'], $req->body['title'], $req->body['price'], $req->body['period_num'], $req->body['period'], $req->body['custom_description'], $req->body['plan_order']);
  apiResponse($res, ['data' => $monetization_plan]);
}

// updateMonetizationPlan
function updateMonetizationPlan($req, $res)
{
  global $user;
  _initMonetizationPlans();
  $updated_monetization_plan = $user->update_monetization_plan($req->params['id'], $req->body['title'], $req->body['price'], $req->body['period_num'], $req->body['period'], $req->body['custom_description'], $req->body['plan_order']);
  apiResponse($res, ['data' => $updated_monetization_plan]);
}

// deleteMonetizationPlan
function deleteMonetizationPlan($req, $res)
{
  global $user;
  _initMonetizationPlans();
  $user->delete_monetization_plan($req->params['id']);
  apiResponse($res);
}
