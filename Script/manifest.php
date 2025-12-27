<?php

/**
 * manifest
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich
 */

// fetch bootstrap
require('bootstrap.php');

// response
header('Content-Type: application/json');
$smarty->display('manifest.tpl');
