<?php

/**
 * ajax -> users -> settings_search_index
 * 
 * @package Sngine
 * @author Zamblek
 */

// fetch bootstrap
require('../../../bootstrap.php');

// check AJAX Request
is_ajax();
user_access(true);

$results = [];
foreach (user_settings_search_index() as $field) {
  if (!user_settings_field_allowed($field)) {
    continue;
  }
  $view = $field['view'] ?? '';
  $sub_view = $field['sub_view'] ?? '';
  $url = $system['system_url'] . '/settings' . ($view !== '' ? '/' . $view : '') . ($sub_view !== '' ? '/' . $sub_view : '');
  if (!empty($field['id'])) {
    $url .= '?goto=' . urlencode($field['id']);
  }
  $results[] = [
    'id'      => $field['id'],
    'label'   => __($field['label']),
    'help'    => ($field['help']) ? __($field['help']) : '',
    'url'     => $url,
    'page'    => __($field['page']),
    'section' => ($field['section']) ? __($field['section']) : '',
  ];
}

return_json($results);
