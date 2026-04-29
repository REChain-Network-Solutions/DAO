<?php

/**
 * manifest
 * 
 * @package Sngine
 * @author Zamblek
 */

// fetch bootstrap
require('bootstrap.php');

// response
header('Content-Type: application/json');
$smarty->display('manifest.tpl');
