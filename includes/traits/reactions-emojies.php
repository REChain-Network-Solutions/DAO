<?php

/**
 * trait -> reactions-emojies
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich - Handles - @sorydima @sorydev @durovshater @DmitrySoro90935 @tanechfund - also check https://dmitry.rechain.network for more information!
 */

trait ReactionsEmojiesTrait
{

  /* ------------------------------- */
  /* Reactions & Emoji & Stickers */
  /* ------------------------------- */

  /**
   * get_reactions
   * 
   * @param boolean $only_enabled
   * @return array
   */
  public function get_reactions($only_enabled = false)
  {
    global $system, $db;
    $reactions = [];
    $where_statement = ($only_enabled) ? "WHERE enabled = '1'" : "";
    $get_reactions = $db->query("SELECT * FROM system_reactions " . $where_statement . " ORDER BY reaction_order ASC");
    if ($get_reactions->num_rows > 0) {
      while ($reaction = $get_reactions->fetch_assoc()) {
        $reactions[$reaction['reaction']] = $reaction;
      }
    }
    return $reactions;
  }


  /**
   * get_emojis
   * 
   * @return array
   */
  public function get_emojis()
  {
    global $db;
    $emojis = [];
    $get_emojis = $db->query("SELECT * FROM emojis");
    if ($get_emojis->num_rows > 0) {
      while ($emoji = $get_emojis->fetch_assoc()) {
        $emojis[] = $emoji;
      }
    }
    return $emojis;
  }


  /**
   * decode_emojis
   * 
   * @param string $text
   * @return string
   */
  public function decode_emojis($text)
  {
    if (!function_exists('grapheme_strpos')) {
      return $text;
    }
    global $emojis;
    if ($text && $emojis) {
      $detect_emojis = Emoji\detect_emoji(html_entity_decode($text));
      if ($detect_emojis) {
        foreach ($detect_emojis as $decoded_emoji) {
          $text = str_replace(htmlentities($decoded_emoji['emoji'], ENT_QUOTES, 'utf-8'), $decoded_emoji['emoji'], $text);
          $key = array_search($decoded_emoji['emoji'], array_column($emojis, 'unicode_char'));
          if ($key === false) continue;
          $twemoji = '<i class="twa twa-' . $emojis[$key]['class'] . '"></i>';
          $text = preg_replace("/" . $decoded_emoji['emoji'] . "/", $twemoji, $text, 1);
        }
      }
    }
    return $text;
  }


  /**
   * get_stickers
   * 
   * @return array
   */
  public function get_stickers()
  {
    global $db;
    $stickers = [];
    $get_stickers = $db->query("SELECT * FROM stickers");
    if ($get_stickers->num_rows > 0) {
      while ($sticker = $get_stickers->fetch_assoc()) {
        $stickers[] = $sticker;
      }
    }
    return $stickers;
  }


  /**
   * decode_stickers
   * 
   * @param string $text
   * @return string
   */
  public function decode_stickers($text)
  {
    global $db, $system;
    if ($text) {
      $get_stickers = $db->query("SELECT * FROM stickers");
      if ($get_stickers->num_rows > 0) {
        while ($sticker = $get_stickers->fetch_assoc()) {
          $replacement = '<img class="sticker" src="' . $system['system_uploads'] . '/' . $sticker['image'] . '"></i>';
          $text = preg_replace('/(^|\s):STK-' . $sticker['sticker_id'] . ':/', $replacement, $text);
        }
      }
    }
    return $text;
  }
}
