<?php

/**
 * manifest
 * 
 * @package Delus
 * @author Dmitry Sorokin - @sorydima & @sorydev Handles. 
 */

// fetch bootstrap
require('bootstrap.php');

// response
header('Content-Type: application/json');
$smarty->display('manifest.tpl');
