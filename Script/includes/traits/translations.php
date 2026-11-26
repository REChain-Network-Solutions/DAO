<?php

/**
 * trait -> translations
 *
 * @package Sngine
 * @author Zamblek
 */

trait TranslationsTrait
{

  /* ------------------------------- */
  /* Translations */
  /* ------------------------------- */

  /**
   * translate_node
   *
   * @param string $node_type
   * @param integer $node_id
   * @param string|null $field
   * @return array
   */
  public function translate_node($node_type, $node_id, $field = null)
  {
    global $db, $system;
    /* get the source fields */
    $sources = $this->_get_translation_sources($node_type, $node_id);
    if ($field) {
      if (!array_key_exists($field, $sources)) {
        throw new Exception(__("Nothing to translate"));
      }
      $sources = [$field => $sources[$field]];
    }
    $sources = array_filter($sources, fn($text) => !is_empty($text));
    if (!$sources) {
      throw new Exception(__("Nothing to translate"));
    }
    /* get the target language */
    $target_lang = substr($system['language']['code'], 0, 2);
    /* translate each field (cache first) */
    $translations = [];
    foreach ($sources as $node_field => $text) {
      $source_hash = sha1($text);
      $get_cache = $db->query(sprintf("SELECT source_hash, translated_text FROM translations_cache WHERE node_type = %s AND node_id = %s AND node_field = %s AND target_lang = %s", secure($node_type), secure($node_id, 'int'), secure($node_field), secure($target_lang)));
      if ($get_cache->num_rows > 0) {
        $cache = $get_cache->fetch_assoc();
        if ($cache['source_hash'] == $source_hash) {
          if ($cache['translated_text'] !== null) {
            $translations[$node_field] = html_entity_decode($cache['translated_text'], ENT_QUOTES, 'UTF-8');
          }
          continue;
        }
      }
      /* call the translation api */
      $result = $this->_translation_api($text, $target_lang);
      if (!$result) {
        throw new Exception(__("There is something that went wrong!"));
      }
      $translated_text = ($result['source_lang'] == $target_lang) ? null : $result['text'];
      $db->query(sprintf("INSERT INTO translations_cache (node_type, node_id, node_field, target_lang, source_hash, source_lang, translated_text, created_at) VALUES (%s, %s, %s, %s, %s, %s, %s, %s) ON DUPLICATE KEY UPDATE source_hash = VALUES(source_hash), source_lang = VALUES(source_lang), translated_text = VALUES(translated_text), created_at = VALUES(created_at)", secure($node_type), secure($node_id, 'int'), secure($node_field), secure($target_lang), secure($source_hash), secure($result['source_lang']), ($translated_text === null) ? 'NULL' : secure($translated_text), secure(date('Y-m-d H:i:s'))));
      if ($translated_text !== null) {
        $translations[$node_field] = $translated_text;
      }
    }
    /* return */
    return [
      'same' => empty($translations),
      'translations' => $translations
    ];
  }


  /**
   * delete_translations
   *
   * @param string $node_type
   * @param integer $node_id
   * @return void
   */
  public function delete_translations($node_type, $node_id)
  {
    global $db;
    $db->query(sprintf("DELETE FROM translations_cache WHERE node_type = %s AND node_id = %s", secure($node_type), secure($node_id, 'int')));
  }


  /**
   * _get_translation_sources
   *
   * @param string $node_type
   * @param integer $node_id
   * @return array
   */
  private function _get_translation_sources($node_type, $node_id)
  {
    global $db, $system;
    switch ($node_type) {
      case 'post':
        if (!$system['post_translation_enabled']) {
          _error(403);
        }
        $post = $this->get_post($node_id, false);
        if (!$post || empty($post['can_get_details']) || !empty($post['needs_pro_package']) || !empty($post['needs_permission'])) {
          _error(403);
        }
        $title = null;
        switch ($post['post_type']) {
          case 'funding':
            $title = $post['funding']['title'] ?? null;
            break;
          case 'offer':
            $title = $post['offer']['meta_title'] ?? null;
            break;
          case 'job':
            $title = $post['job']['title'] ?? null;
            break;
          case 'course':
            $title = $post['course']['title'] ?? null;
            break;
        }
        return [
          'text' => $this->_translation_clean($post['text_plain']),
          'title' => $this->_translation_clean($title)
        ];

      case 'page':
        if (!$system['post_translation_enabled']) {
          _error(403);
        }
        $get_page = $db->query(sprintf("SELECT page_title, page_description FROM pages WHERE page_id = %s", secure($node_id, 'int')));
        if ($get_page->num_rows == 0) {
          _error(404);
        }
        $page = $get_page->fetch_assoc();
        return [
          'title' => $this->_translation_clean($page['page_title']),
          'description' => $this->_translation_clean($page['page_description'])
        ];

      case 'group':
        if (!$system['post_translation_enabled']) {
          _error(403);
        }
        $get_group = $db->query(sprintf("SELECT group_title, group_description, group_privacy FROM `groups` WHERE group_id = %s", secure($node_id, 'int')));
        if ($get_group->num_rows == 0) {
          _error(404);
        }
        $group = $get_group->fetch_assoc();
        if ($group['group_privacy'] == 'secret' && !$this->_is_admin && $this->check_group_membership($this->_data['user_id'], $node_id) != 'approved') {
          _error(403);
        }
        return [
          'title' => $this->_translation_clean($group['group_title']),
          'description' => $this->_translation_clean($group['group_description'])
        ];

      case 'event':
        if (!$system['post_translation_enabled']) {
          _error(403);
        }
        $get_event = $db->query(sprintf("SELECT event_title, event_description, event_privacy, event_admin FROM `events` WHERE event_id = %s", secure($node_id, 'int')));
        if ($get_event->num_rows == 0) {
          _error(404);
        }
        $event = $get_event->fetch_assoc();
        if ($event['event_privacy'] == 'secret' && !$this->_is_admin && $event['event_admin'] != $this->_data['user_id'] && !$this->check_event_membership($this->_data['user_id'], $node_id)) {
          _error(403);
        }
        return [
          'title' => $this->_translation_clean($event['event_title']),
          'description' => $this->_translation_clean($event['event_description'])
        ];

      case 'user':
        if (!$system['post_translation_enabled'] || !$system['biography_info_enabled']) {
          _error(403);
        }
        $get_user = $db->query(sprintf("SELECT user_biography FROM users WHERE user_id = %s", secure($node_id, 'int')));
        if ($get_user->num_rows == 0) {
          _error(404);
        }
        if ($this->blocked($node_id)) {
          _error(403);
        }
        return [
          'description' => $this->_translation_clean($get_user->fetch_assoc()['user_biography'])
        ];

      case 'message':
        if (!$system['chat_translation_enabled']) {
          _error(403);
        }
        $get_message = $db->query(sprintf("SELECT conversation_id, message FROM conversations_messages WHERE message_id = %s", secure($node_id, 'int')));
        if ($get_message->num_rows == 0) {
          _error(404);
        }
        $message = $get_message->fetch_assoc();
        if (!$this->get_conversation($message['conversation_id'])) {
          _error(403);
        }
        return [
          'text' => $this->_translation_clean($message['message'])
        ];

      default:
        _error(400);
    }
  }


  /**
   * _translation_clean
   *
   * @param string|null $text
   * @return string
   */
  private function _translation_clean($text)
  {
    if (is_empty($text)) {
      return '';
    }
    $text = html_entity_decode(strip_tags(html_entity_decode($text, ENT_QUOTES, 'UTF-8')), ENT_QUOTES, 'UTF-8');
    return trim($text);
  }


  /**
   * _translation_api
   *
   * @param string $text
   * @param string $target_lang
   * @return array|false
   */
  private function _translation_api($text, $target_lang)
  {
    global $system;
    switch ($system['translation_provider']) {
      case 'yandex':
        /* Yandex translate */
        if (is_empty($system['yandex_key'])) {
          throw new Exception(__("Translation service not available!"));
        }
        $response = $this->_translation_request('https://translate.api.cloud.yandex.net/translate/v2/translate', [
          'texts' => [$text],
          'targetLanguageCode' => $target_lang,
          'format' => 'PLAIN_TEXT'
        ], ['Authorization: Api-Key ' . $system['yandex_key']], true);
        if (!$response || !isset($response['translations'][0]['text'])) {
          return false;
        }
        return [
          'text' => $response['translations'][0]['text'],
          'source_lang' => substr(strtolower($response['translations'][0]['detectedLanguageCode'] ?? ''), 0, 10)
        ];

      case 'deepl':
        /* DeepL translate */
        if (is_empty($system['deepl_key'])) {
          throw new Exception(__("Translation service not available!"));
        }
        $deepl_host = (str_ends_with($system['deepl_key'], ':fx')) ? 'api-free.deepl.com' : 'api.deepl.com';
        $deepl_langs = ['en' => 'EN-US', 'pt' => 'PT-BR'];
        $response = $this->_translation_request('https://' . $deepl_host . '/v2/translate', [
          'text' => [$text],
          'target_lang' => $deepl_langs[$target_lang] ?? strtoupper($target_lang)
        ], ['Authorization: DeepL-Auth-Key ' . $system['deepl_key']], true);
        if (!$response || !isset($response['translations'][0]['text'])) {
          return false;
        }
        return [
          'text' => $response['translations'][0]['text'],
          'source_lang' => substr(strtolower($response['translations'][0]['detected_source_language'] ?? ''), 0, 10)
        ];

      case 'libretranslate':
        /* LibreTranslate */
        if (is_empty($system['libretranslate_url'])) {
          throw new Exception(__("Translation service not available!"));
        }
        $fields = [
          'q' => $text,
          'source' => 'auto',
          'target' => $target_lang,
          'format' => 'text'
        ];
        if (!is_empty($system['libretranslate_key'])) {
          $fields['api_key'] = $system['libretranslate_key'];
        }
        $response = $this->_translation_request($system['libretranslate_url'] . '/translate', $fields);
        if (!$response || !isset($response['translatedText'])) {
          return false;
        }
        return [
          'text' => $response['translatedText'],
          'source_lang' => substr(strtolower($response['detectedLanguage']['language'] ?? ''), 0, 10)
        ];

      default:
        /* Google translate */
        if (is_empty($system['google_translation_key'])) {
          throw new Exception(__("Translation service not available!"));
        }
        $response = $this->_translation_request('https://translation.googleapis.com/language/translate/v2', [
          'key' => $system['google_translation_key'],
          'q' => $text,
          'target' => $target_lang,
          'format' => 'text'
        ]);
        if (!$response || !isset($response['data']['translations'][0]['translatedText'])) {
          return false;
        }
        return [
          'text' => $response['data']['translations'][0]['translatedText'],
          'source_lang' => substr($response['data']['translations'][0]['detectedSourceLanguage'] ?? '', 0, 10)
        ];
    }
  }


  /**
   * _translation_request
   *
   * @param string $url
   * @param array $fields
   * @param array $headers
   * @param boolean $json
   * @return array|false
   */
  private function _translation_request($url, $fields, $headers = [], $json = false)
  {
    if ($json) {
      $headers[] = 'Content-Type: application/json';
    }
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_POST, 1);
    curl_setopt($ch, CURLOPT_POSTFIELDS, ($json) ? json_encode($fields) : http_build_query($fields));
    if ($headers) {
      curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
    }
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
    curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 5);
    curl_setopt($ch, CURLOPT_TIMEOUT, 10);
    $response = curl_exec($ch);
    $http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    $connected = ($response !== false);
    $response = ($connected) ? json_decode($response, true) : false;
    if (!$connected || $http_code != 200) {
      /* show the error reason to admins */
      if ($this->_is_admin) {
        $message = (is_array($response)) ? ($response['error']['message'] ?? $response['message'] ?? $response['error'] ?? '') : '';
        if (!$connected) {
          $error = __("Can't connect to the translation service");
        } elseif (in_array($http_code, [401, 403]) || ($http_code == 400 && is_string($message) && stripos($message, 'key') !== false)) {
          $error = __("Invalid or unsupported API key");
        } elseif (in_array($http_code, [429, 456])) {
          $error = __("Usage limit exceeded");
        } elseif ($http_code == 404) {
          $error = __("Invalid service URL");
        } elseif ($http_code == 400) {
          $error = __("Unsupported language or invalid request");
        } else {
          $error = __("Service is not available right now");
        }
        throw new Exception(__("Translation service error") . ": " . $error);
      }
      return false;
    }
    return is_array($response) ? $response : false;
  }
}
