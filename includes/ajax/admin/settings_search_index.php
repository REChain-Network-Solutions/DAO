<?php

/**
 * ajax -> admin -> settings_search_index
 *
 * @package Sngine
 * @author Zamblek
 */

// fetch bootstrap
require('../../../bootstrap.php');

// check AJAX Request
is_ajax();
user_access(true);

// check admin permission (settings pages are admin-only, moderators excluded — see admin.php)
if (!$user->_is_admin) {
  modal("MESSAGE", __("System Message"), __("You don't have the right permission to access this"));
}

// get active theme
$theme_id = 0;
$get_theme = $db->query(sprintf("SELECT theme_id FROM system_themes WHERE name = %s", secure($system['theme'])));
if ($get_theme && $get_theme->num_rows > 0) {
  $theme_id = (int) $get_theme->fetch_assoc()['theme_id'];
}

$results = [];
foreach (admin_settings_search_index() as $field) {
  // skip theme options when the active theme isn't registered
  if ($field['view'] == 'themes' && !$theme_id) {
    continue;
  }
  $path = ($field['view'] == 'themes') ? 'themes/edit/' . $theme_id : 'settings' . ($field['sub_view'] ? '/' . $field['sub_view'] : '');
  // skip monetization-gated fields when the entitlement isn't active
  if (!empty($field['monetization']) && empty($licence_monetization)) {
    continue;
  }
  $results[] = [
    'id'    => $field['id'],
    'label' => __($field['label']),
    'help'  => ($field['help']) ? __($field['help']) : '',
    'url'   => $system['system_url'] . '/' . $control_panel['url'] . '/' . $path . '?goto=' . urlencode($field['id']),
    'page'  => __($field['page']),
    'tab'   => implode(' › ', array_filter([
      ($field['tab']) ? __($field['tab']) : '',
      ($field['section']) ? __($field['section']) : '',
    ])),
  ];
}

return_json($results);
