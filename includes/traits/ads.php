<?php

/**
 * trait -> ads
 * 
 * @package Sngine
 * @author Zamblek
 */

trait AdsTrait
{

  /* ------------------------------- */
  /* Ads */
  /* ------------------------------- */

  /**
   * ads
   * 
   * @param string $place
   * @param integer $node_id
   * @return array
   */
  public function ads($place, $node_id = null)
  {
    global $db;
    $ads = [];
    /* check if the viewer is ads free */
    if ($this->_logged_in && $this->_data['ads_free']) {
      return $ads;
    }
    /* check if ads place is pages or grpups */
    $where_query = '';
    if ($node_id) {
      $node_id = secure($node_id, 'search');
      $node_id = str_replace("'%", "'%;", $node_id);
      $node_id = str_replace("%'", "&%'", $node_id);
    }
    if ($place == 'pages') {
      $where_query = sprintf('AND ads_pages_ids LIKE %s', $node_id);
    } elseif ($place == 'groups') {
      $where_query = sprintf('AND ads_groups_ids LIKE %s', $node_id);
    }
    if ($where_query) {
      $get_ads = $db->query(sprintf("SELECT * FROM ads_system WHERE place = %s ", secure($place)) . $where_query);
      $ads_units = $get_ads->fetch_all(MYSQLI_ASSOC);
    } else {
      $ads_units = array_filter(system_cache_rows('ads_system', "SELECT * FROM ads_system"), function ($ads_unit) use ($place) {
        return $ads_unit['place'] == $place;
      });
    }
    foreach ($ads_units as $ads_unit) {
      $ads_unit['code'] = html_entity_decode($ads_unit['code'], ENT_QUOTES);
      $ads[] = $ads_unit;
    }
    return $ads;
  }
}
