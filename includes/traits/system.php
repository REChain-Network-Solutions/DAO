<?php

/**
 * trait -> system
 * 
 * @package Sngine
 * @author Zamblek
 */

trait SystemTrait
{

  /* ------------------------------- */
  /* System Languages */
  /* ------------------------------- */

  /**
   * get_languages
   *
   * @return array
   */
  public function get_languages()
  {
    $languages = [];
    foreach (system_cache_rows('languages', "SELECT * FROM system_languages WHERE enabled = '1' ORDER BY language_order ASC") as $language) {
      $language['title_native'] = $language['title'];
      $language['title'] = __($language['title']);
      $language['flag'] = get_picture($language['flag'], 'language_flag');
      $languages[] = $language;
    }
    return $languages;
  }


  /**
   * check_language
   * 
   * @param integer $language_id
   * @return boolean
   */
  public function check_language($language_id)
  {
    global $db;
    $check = $db->query(sprintf("SELECT COUNT(*) as count FROM system_languages WHERE language_id = %s", secure($language_id, 'int')));
    if ($check->fetch_assoc()['count'] > 0) {
      return true;
    }
    return false;
  }


  /**
   * get_language
   * 
   * @param integer $language_id
   * @return array
   */
  public function get_language($language_id)
  {
    global $db;
    $get_language = $db->query(sprintf("SELECT * FROM system_languages WHERE language_id = %s", secure($language_id, 'int')));
    if ($get_language->num_rows == 0) {
      return null;
    }
    return $get_language->fetch_assoc();
  }


  /**
   * get_language_by_name
   * 
   * @param string $language_name
   * @return array
   */
  public function get_language_by_name($language_name)
  {
    global $db;
    $get_language = $db->query(sprintf("SELECT * FROM system_languages WHERE title = %s", secure($language_name)));
    if ($get_language->num_rows == 0) {
      return null;
    }
    return $get_language->fetch_assoc();
  }


  /**
   * get_language_by_code
   * 
   * @param string $language_code
   * @return array
   */
  public function get_language_by_code($language_code)
  {
    global $db;
    $get_language = $db->query(sprintf("SELECT * FROM system_languages WHERE code = %s", secure($language_code)));
    if ($get_language->num_rows == 0) {
      return null;
    }
    return $get_language->fetch_assoc();
  }



  /* ------------------------------- */
  /* System Countries */
  /* ------------------------------- */

  /**
   * prepare_country
   *
   * @param array $country
   * @param boolean $translate_name
   * @return array
   */
  private function prepare_country($country, $translate_name = false)
  {
    $country['country_name_native'] = $country['country_name'];
    $country_name = __($country['country_name']);
    if ($translate_name) {
      $country['country_name'] = $country_name;
    }
    $country['country_name_with_flag'] = trim(($country['country_flag'] ?? '') . ' ' . $country_name);
    return $country;
  }

  /**
   * get_countries 
   * 
   * @return array
   */
  public function get_countries()
  {
    $countries = [];
    foreach (system_cache_rows('countries', "SELECT * FROM system_countries WHERE enabled = '1' ORDER BY country_order ASC") as $country) {
      $countries[] = $this->prepare_country($country, true);
    }
    return $countries;
  }


  /**
   * check_country
   * 
   * @param integer $country_id
   * @return boolean
   */
  public function check_country($country_id)
  {
    global $db;
    $check = $db->query(sprintf("SELECT COUNT(*) as count FROM system_countries WHERE country_id = %s", secure($country_id, 'int')));
    if ($check->fetch_assoc()['count'] > 0) {
      return true;
    }
    return false;
  }


  /**
   * get_country
   * 
   * @param integer $country_id
   * @return array
   */
  public function get_country($country_id)
  {
    global $db;
    $get_country = $db->query(sprintf("SELECT * FROM system_countries WHERE country_id = %s", secure($country_id, 'int')));
    if ($get_country->num_rows == 0) {
      return null;
    }
    return $this->prepare_country($get_country->fetch_assoc());
  }


  /**
   * get_country_by_name
   * 
   * @param integer $country_name
   * @return array
   */
  public function get_country_by_name($country_name)
  {
    global $db;
    $get_country = $db->query(sprintf("SELECT * FROM system_countries WHERE country_name = %s", secure($country_name)));
    if ($get_country->num_rows == 0) {
      return null;
    }
    return $this->prepare_country($get_country->fetch_assoc());
  }


  /**
   * get_country_by_code
   * 
   * @param integer $country_code
   * @return array
   */
  public function get_country_by_code($country_code)
  {
    global $db;
    $get_country = $db->query(sprintf("SELECT * FROM system_countries WHERE country_code = %s", secure($country_code)));
    if ($get_country->num_rows == 0) {
      return null;
    }
    return $this->prepare_country($get_country->fetch_assoc());
  }


  /**
   * get_session_location
   * 
   * @param array $session
   * @return string
   */
  public function get_session_location($session)
  {
    static $countries = null;
    if (empty($session['user_ip_country'])) {
      return '';
    }
    if ($countries === null) {
      $countries = array_column($this->get_countries(), 'country_name', 'country_code');
    }
    $location = $countries[$session['user_ip_country']] ?? $session['user_ip_country'];
    if (!empty($session['user_ip_isp'])) {
      $location .= ' · ' . $session['user_ip_isp'];
    }
    return $location;
  }



  /* ------------------------------- */
  /* System Currencies */
  /* ------------------------------- */

  /**
   * get_currencies
   * 
   * @param boolean $get_all
   * @return array
   */
  public function get_currencies($get_all = false)
  {
    global $db, $system;
    $currencies = [];
    $where_statement = ($get_all) ? "" : "WHERE enabled = '1'";
    $get_currencies = $db->query("SELECT * FROM system_currencies {$where_statement} ORDER BY currency_id ASC");
    if ($get_currencies->num_rows > 0) {
      while ($currency = $get_currencies->fetch_assoc()) {
        $currencies[] = $currency;
      }
    }
    return $currencies;
  }


  /**
   * check_currency
   * 
   * @param integer $currency_id
   * @return boolean
   */
  public function check_currency($currency_id)
  {
    global $db;
    $check = $db->query(sprintf("SELECT COUNT(*) as count FROM system_currencies WHERE currency_id = %s", secure($currency_id, 'int')));
    if ($check->fetch_assoc()['count'] > 0) {
      return true;
    }
    return false;
  }


  /**
   * get_currency
   * 
   * @param integer $currency_id
   * @return boolean
   */
  public function get_currency($currency_id)
  {
    global $db;
    $get_currency = $db->query(sprintf("SELECT * FROM system_currencies WHERE currency_id = %s", secure($currency_id, 'int')));
    if ($get_currency->num_rows == 0) {
      return null;
    }
    return $get_currency->fetch_assoc();
  }



  /* ------------------------------- */
  /* System Genders */
  /* ------------------------------- */

  /**
   * get_genders 
   * 
   * @param boolean $sorted
   * @return array
   */
  public function get_genders($sorted = true)
  {
    global $db, $system;
    $genders = [];
    $order_query = ($sorted) ? " ORDER BY gender_order ASC " : " ORDER BY gender_id ASC ";
    $get_genders = $db->query("SELECT * FROM system_genders" . $order_query);
    if ($get_genders->num_rows > 0) {
      while ($gender = $get_genders->fetch_assoc()) {
        $gender['gender_name'] = __($gender['gender_name']);
        $genders[] = $gender;
      }
    }
    return $genders;
  }


  /**
   * get_gender 
   * 
   * @param integer $gender_id
   * @return string
   */
  public function get_gender($gender_id)
  {
    global $db;
    $get_gender = $db->query(sprintf("SELECT gender_name FROM system_genders WHERE gender_id = %s", secure($gender_id, 'int')));
    if ($get_gender->num_rows == 0) {
      return __("N/A");
    }
    return __($get_gender->fetch_assoc()['gender_name']);
  }


  /**
   * check_gender 
   * 
   * @param integer $gender_id
   * @return boolean
   */
  public function check_gender($gender_id)
  {
    global $db;
    $check = $db->query(sprintf("SELECT COUNT(*) as count FROM system_genders WHERE gender_id = %s", secure($gender_id, 'int')));
    if ($check->fetch_assoc()['count'] > 0) {
      return true;
    }
    return false;
  }



  /* ------------------------------- */
  /* Static Pages */
  /* ------------------------------- */

  /**
   * get_static_pages 
   * 
   * @param boolean $in_footer
   * 
   * @return array
   */
  public function get_static_pages()
  {
    global $system;
    $static_pages = [];
    foreach (system_cache_rows('static_pages', "SELECT page_title, page_is_redirect, page_redirect_url, page_url, page_in_footer, page_in_sidebar, page_icon FROM static_pages ORDER BY page_order ASC") as $static_page) {
      $static_page['url'] = ($static_page['page_is_redirect']) ? $static_page['page_redirect_url'] : $system['system_url'] . '/static/' . $static_page['page_url'];
      $static_page['page_icon'] = get_picture($static_page['page_icon'], 'static_page_icon');
      $static_pages[] = $static_page;
    }
    return $static_pages;
  }


  /**
   * get_static_page 
   * 
   * @param string $page_url
   * @return array
   */
  public function get_static_page($page_url)
  {
    global $db;
    $get_static_page = $db->query(sprintf("SELECT * FROM static_pages WHERE page_url = %s", secure($page_url)));
    if ($get_static_page->num_rows == 0) {
      throw new NoDataException(__("No data found"));
    }
    $static_page = $get_static_page->fetch_assoc();
    $static_page['page_text'] = html_entity_decode($static_page['page_text'], ENT_QUOTES);
    return $static_page;
  }



  /* ------------------------------- */
  /* Contact Us */
  /* ------------------------------- */

  /**
   * contact_us 
   * 
   * @param string $name
   * @param string $email
   * @param string $user_subject
   * @param string $message
   * @param string $recaptcha_response
   * @param string $turnstile_response
   * @param string $hcaptcha_response
   * @param bool $from_web
   * @return array
   */
  public function contact_us($name, $email, $user_subject, $message, $recaptcha_response = null, $turnstile_response = null, $hcaptcha_response = null, $from_web = false)
  {
    global $system;
    /* valid inputs */
    if (is_empty($name) || is_empty($email) || is_empty($user_subject) || is_empty($message)) {
      throw new ValidationException(__("You must fill in all of the fields"));
    }
    if (!valid_email($email)) {
      throw new ValidationException(__("Please enter a valid email address"));
    }
    /* check reCAPTCHA */
    if ($system['captcha_enabled'] && $system['captcha_provider'] == "recaptcha" && $from_web) {
      $recaptcha = new \ReCaptcha\ReCaptcha($system['reCAPTCHA_secret_key'], new \ReCaptcha\RequestMethod\CurlPost());
      $resp = $recaptcha->verify($_POST['g-recaptcha-response'], get_user_ip());
      if (!$resp->isSuccess()) {
        throw new ValidationException(__("The security check is incorrect. Please try again"));
      }
    }
    /* check Turnstile */
    if ($system['captcha_enabled'] && $system['captcha_provider'] == "turnstile" && $from_web) {
      if (!check_cf_turnstile($turnstile_response)) {
        throw new ValidationException(__("The security check is incorrect. Please try again"));
      }
    }
    /* check hCaptcha */
    if ($system['captcha_enabled'] && $system['captcha_provider'] == "hcaptcha" && $from_web) {
      if (!check_hcaptcha($hcaptcha_response)) {
        throw new ValidationException(__("The security check is incorrect. Please try again"));
      }
    }
    /* prepare email */
    $subject = __("New email message from") . " " . html_entity_decode(__($system['system_title']), ENT_QUOTES);
    $body = get_email_template("contact_form_email", $subject, ["name" => $name, "email" => $email, "subject" => $user_subject, "message" => $message]);
    /* send email */
    if (!_email($system['system_email'], $subject, $body['html'], $body['plain'])) {
      throw new Exception(__("Your email could not be sent. Please try again later"));
    }
  }
}
