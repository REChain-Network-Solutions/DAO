<?php

/**
 * trait -> stickers
 * 
 * @package Sngine
 * @author Zamblek
 */

trait StickersTrait
{

  /* ------------------------------- */
  /* Stickers */
  /* ------------------------------- */

  /**
   * get_stickers
   * 
   * @return array
   */
  public function get_stickers()
  {
    return system_cache_rows('stickers', "SELECT * FROM stickers");
  }


  /**
   * decode_stickers
   * 
   * @param string $text
   * @return string
   */
  public function decode_stickers($text)
  {
    global $system;
    if ($text && str_contains($text, ':STK-')) {
      foreach ($this->get_stickers() as $sticker) {
        $replacement = '<img class="sticker" src="' . $system['system_uploads'] . '/' . $sticker['image'] . '"></i>';
        $text = preg_replace('/(^|\s):STK-' . $sticker['sticker_id'] . ':/', $replacement, $text);
      }
    }
    return $text;
  }
}
