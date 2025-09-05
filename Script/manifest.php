<?php

/**
 * manifest
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich - Handles - @sorydima @sorydev @durovshater @DmitrySoro90935 @tanechfund - also check https://dmitry.rechain.network for more information!
 */

// fetch bootstrap
require('bootstrap.php');

// response
header('Content-Type: application/json');
$smarty->display('manifest.tpl');
