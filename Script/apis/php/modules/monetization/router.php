<?php

/**
 * APIs -> modules -> monetization -> router
 *
 * @package Delus
 * @author Sorokin Dmitry Olegovich
 */

// get controller 
require('modules/monetization/controller.php');

# [get] monetization_plans
$app->get('/monetization/monetization_plans', function ($req, $res) {
  getMonetizationPlans($req, $res);
});


# [post] monetization_plans
$app->post('/monetization/monetization_plans', function ($req, $res) {
  insertMonetizationPlan($req, $res);
});


# [get] monetization_plans/[:id]
$app->get('/monetization/monetization_plans/[:id]', function ($req, $res) {
  getMonetizationPlan($req, $res);
});


# [put] monetization_plans/[:id]
$app->put('/monetization/monetization_plans/[:id]', function ($req, $res) {
  updateMonetizationPlan($req, $res);
});


# [delete] monetization_plans/[:id]
$app->delete('/monetization/monetization_plans/[:id]', function ($req, $res) {
  deleteMonetizationPlan($req, $res);
});
