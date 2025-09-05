<?php

/**
 * ajax -> core -> theme
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich - Handles - @sorydima @sorydev @durovshater @DmitrySoro90935 @tanechfund - also check https://dmitry.rechain.network for more information!
 */

// fetch bootstrap
require('../../../bootstrap.php');

// check AJAX Request
is_ajax();

// set theme mode (day|night)
if (isset($_POST['mode'])) {
  set_cookie('s_night_mode', ($_POST['mode'] == "night") ? '1' : '0');
}
