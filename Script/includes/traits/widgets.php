<?php

/**
 * trait -> widgets
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich
 */

trait WidgetsTrait
{

  /* ------------------------------- */
  /* Widgets */
  /* ------------------------------- */

  /**
   * widget
   * 
   * @param array $place
   * @return array
   */
  public function widgets($place)
  {
    global $db, $system;
    $widgets = [];
    $get_widgets = $db->query(sprintf("SELECT * FROM widgets WHERE place = %s ORDER BY place_order ASC", secure($place)));
    if ($get_widgets->num_rows > 0) {
      while ($widget = $get_widgets->fetch_assoc()) {
        /* check the widget language */
        if ($widget['language_id'] == 0 || $widget['language_id'] == $system['language']['language_id']) {
          $widget['code'] = html_entity_decode($widget['code'], ENT_QUOTES);
          $widgets[] = $widget;
        }
      }
    }
    return $widgets;
  }
}
