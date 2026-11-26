<?php

/**
 * sitemap
 *
 * @package Sngine
 * @author Zamblek
 */

// fetch bootstrap
require('bootstrap.php');

$view = $_GET['view'] ?? '';

// robots
if ($view == 'robots') {
  header('Content-Type: text/plain; charset=UTF-8');
  echo $user->get_robots_txt();
  exit;
}

// indexnow key
if ($view == 'key') {
  if (!$system['indexnow_enabled'] || is_empty($system['indexnow_key']) || !isset($_GET['key']) || $_GET['key'] !== $system['indexnow_key']) {
    _error(404);
  }
  header('Content-Type: text/plain; charset=UTF-8');
  echo $system['indexnow_key'];
  exit;
}

// website public
if (!$system['system_public']) {
  _error(404);
}

// llms
if ($view == 'llms') {
  if (!$system['llms_enabled']) {
    _error(404);
  }
  header('Content-Type: text/plain; charset=UTF-8');
  echo $user->get_llms_txt();
  exit;
}

// sitemap enabled
if (!$system['sitemap_enabled']) {
  _error(404);
}

try {
  if ($view == 'part') {
    $xml = $user->get_sitemap($_GET['type'] ?? '', $_GET['part'] ?? 0);
    if ($xml === false) {
      _error(404);
    }
  } else {
    $xml = $user->get_sitemap_index();
  }
} catch (Throwable $e) {
  _error(404);
}

header('Content-Type: application/xml; charset=UTF-8');
header('X-Robots-Tag: noindex');
echo $xml;
