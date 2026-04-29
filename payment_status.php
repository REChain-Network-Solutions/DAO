<?php

/**
 * payment status
 * 
 * @package Sngine
 * @author Zamblek
 */

// fetch bootloader
require('bootloader.php');

// user access
user_access();

// check the view [pending | failure]
if (!isset($_GET['view']) || !in_array($_GET['view'], ['pending', 'failure'])) {
  _error(404);
}

// assign varible
$smarty->assign('view', $_GET['view']);

// page footer
page_footer('payment_status');
