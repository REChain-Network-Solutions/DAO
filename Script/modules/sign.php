<?php

/**
 * modules -> sign (in|up|out|reset)
 * 
 * @package Sngine
 * @author Zamblek
 */

// fetch bootloader
require('../bootloader.php');

try {

  switch ($_GET['do']) {
    case 'in':
      // check user logged in
      if ($user->_logged_in) {
        redirect();
      }

      // get the referer URL
      referer_url();

      // page header
      page_header(__($system['system_title']) . " &rsaquo; " . __("Login"));

      // get genders
      if (!$system['genders_disabled']) {
        $smarty->assign('genders', $user->get_genders());
      }

      // get custom fields
      $smarty->assign('custom_fields', $user->get_custom_fields());

      // get users groups
      if ($system['select_user_group_enabled']) {
        $smarty->assign('user_groups', $user->get_users_groups());
      }

      // assign varible
      $smarty->assign('do', $_GET['do']);

      // page footer
      page_footer('sign');
      break;

    case 'up':
      // check user logged in
      if ($user->_logged_in) {
        redirect();
      }

      // check if registration enabled
      if (!$system['registration_enabled']) {
        _error(404);
      }

      // get the referer URL
      referer_url();

      // page header
      page_header(__($system['system_title']) . " &rsaquo; " . __("Sign Up"));

      // get invitation code
      if ($system['invitation_enabled'] && isset($_GET['invitation_code'])) {
        $smarty->assign('invitation_code', htmlentities($_GET['invitation_code'], ENT_QUOTES, 'utf-8'));
      }

      // get genders
      if (!$system['genders_disabled']) {
        $smarty->assign('genders', $user->get_genders());
      }

      // get custom fields
      $smarty->assign('custom_fields', $user->get_custom_fields());

      // get users groups
      if ($system['select_user_group_enabled']) {
        $smarty->assign('user_groups', $user->get_users_groups());
      }

      // assign varible
      $smarty->assign('do', $_GET['do']);

      // page footer
      page_footer('sign');
      break;

    case 'out':
      // check the token
      if (!isset($_GET['cache']) || $_SESSION['secret'] != $_GET['cache']) {
        exit;
      }
      // check user logged in
      if (!$user->_logged_in) {
        redirect();
      }

      // sign out
      $user->sign_out(true);
      redirect();
      break;

    case 'reset':
      // check user logged in
      if ($user->_logged_in) {
        redirect();
      }

      // page header
      page_header(__($system['system_title']) . " &rsaquo; " . __("Forgot your password?"));

      // page footer
      page_footer('reset');
      break;

    default:
      _error(404);
      break;
  }
} catch (Exception $e) {
  _error(__("Error"), $e->getMessage());
}
