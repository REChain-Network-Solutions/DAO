<?php

/**
 * trait -> affiliates
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich
 */

trait AffiliatesTrait
{

  /* ------------------------------- */
  /* Affiliates */
  /* ------------------------------- */

  /**
   * init_affiliates
   * 
   * @return void
   */
  public function init_affiliates()
  {
    if (!$this->_logged_in && isset($_GET['ref'])) {
      set_cookie($this->_cookie_user_referrer, $_GET['ref']);
    }
  }


  /**
   * affiliates_balance
   * 
   * @param string $type
   * @param integer $referee_id
   * @param integer $referrer_id
   * @param integer $package_price
   * @return void
   */
  private function process_affiliates($type, $referee_id, $referrer_id = null, $package_price = null)
  {
    global $db, $system;
    /* check if affiliates enabled */
    if (!$system['affiliates_enabled']) {
      return;
    }
    /* check if there is no referrer */
    if (!$referrer_id && !isset($_COOKIE[$this->_cookie_user_referrer])) {
      return;
    }
    /* get referrer (from the cookie) */
    if (!$referrer_id && isset($_COOKIE[$this->_cookie_user_referrer])) {
      $get_referrer = $db->query(sprintf("SELECT user_id FROM users WHERE user_name = %s", secure($_COOKIE[$this->_cookie_user_referrer])));
      if ($get_referrer->num_rows == 0) {
        return;
      }
      $referrer_id = $get_referrer->fetch_assoc()['user_id'];
    }
    /* secure affiliates system (prevent new user to refer himself by set cookie manually) */
    if ($referrer_id == $referee_id) {
      return;
    }
    /* update referee (if not updated before) */
    $db->query(sprintf("UPDATE users SET user_referrer_id = %s WHERE user_id = %s AND user_referrer_id IS NULL", secure($referrer_id, 'int'), secure($referee_id, 'int')));
    /* check if the affiliate type is not correct */
    if ($system['affiliate_type'] != $type) {
      return;
    }
    /* check custom affiliates */
    $referrer = $this->get_user($referrer_id);
    /* get referrer permissions group */
    if ($referrer['user_group'] == '3') {
      $user_permissions_group = 1;
      if ($system['packages_enabled'] && $referrer['user_subscribed']) {
        if ($referrer['package_permissions_group_id']) {
          $user_permissions_group = $referrer['package_permissions_group_id'];
        } elseif ($referrer['user_verified']) {
          $user_permissions_group = 2;
        }
      } else {
        if ($referrer['user_group_custom'] != '0') {
          $user_permissions_group = $referrer['permissions_group_id'];
        } elseif ($referrer['user_verified']) {
          $user_permissions_group = 2;
        }
      }
      $referrer['user_permissions_group'] = $this->get_permissions_group($user_permissions_group);
    }
    /* set custom affiliates system */
    if ($referrer['user_permissions_group']['custom_affiliates_system']) {
      $system['affiliates_per_user'] = $referrer['user_permissions_group']['affiliates_per_user'];
      $system['affiliates_percentage'] = $referrer['user_permissions_group']['affiliates_percentage'];
    }
    if ($referrer['custom_affiliates_system']) {
      $system['affiliates_per_user'] = $referrer['affiliates_per_user'];
      $system['affiliates_percentage'] = $referrer['affiliates_percentage'];
    }
    /* set balance */
    if ($system['affiliate_type'] == "packages" && $system['affiliate_payment_type'] == "percentage") {
      $balance = ($package_price * $system['affiliates_percentage']) / 100;
    } else {
      $balance = $system['affiliates_per_user'];
    }
    /* update referrer balance */
    $this->update_referrer_balance($referrer_id, $referee_id, $balance);
    /* points balance */
    $this->points_balance("add", $referrer_id, "referred", $referee_id);
  }


  /**
   * update_referrer_balance
   * 
   * @param integer $referrer_id
   * @param integer $referee_id
   * @param integer $balance
   * @param integer $iteration
   * @return void
   */
  private function update_referrer_balance($referrer_id, $referee_id, $balance, $iteration = 1)
  {
    global $db, $system;
    /* update current referrer balance */
    $db->query(sprintf("UPDATE users SET user_affiliate_balance = user_affiliate_balance + %s WHERE user_id = %s", secure($balance), secure($referrer_id, 'int')));
    /* insert to users affiliates graph if not exists */
    $db->query(sprintf("INSERT INTO users_affiliates (referrer_id, referee_id) VALUES (%s, %s) ON DUPLICATE KEY UPDATE referrer_id = referrer_id", secure($referrer_id, 'int'), secure($referee_id, 'int')));
    /* get parent referrer */
    if ($iteration < $system['affiliates_levels'] && $system['affiliates_levels'] <= 10) {
      $get_referrer = $db->query(sprintf("SELECT user_referrer_id FROM users WHERE user_referrer_id != '' AND user_referrer_id IS NOT NULL AND user_id = %s", secure($referrer_id, 'int')));
      if ($get_referrer->num_rows > 0) {
        $referrer = $get_referrer->fetch_assoc();
        $iteration++;
        /* check custom affiliates */
        $referrer = $this->get_user($referrer_id);
        /* get referrer permissions group */
        if ($referrer['user_group'] == '3') {
          $user_permissions_group = 1;
          if ($system['packages_enabled'] && $referrer['user_subscribed']) {
            if ($referrer['package_permissions_group_id']) {
              $user_permissions_group = $referrer['package_permissions_group_id'];
            } elseif ($referrer['user_verified']) {
              $user_permissions_group = 2;
            }
          } else {
            if ($referrer['user_group_custom'] != '0') {
              $user_permissions_group = $referrer['permissions_group_id'];
            } elseif ($referrer['user_verified']) {
              $user_permissions_group = 2;
            }
          }
          $referrer['user_permissions_group'] = $this->get_permissions_group($user_permissions_group);
        }
        /* set custom affiliates system */
        $affiliates_per_user_var = ($iteration == 1) ? 'affiliates_per_user' : 'affiliates_per_user_' . $iteration;
        $affiliates_percentage_var = ($iteration == 1) ? 'affiliates_percentage' : 'affiliates_percentage_' . $iteration;
        if ($referrer['user_permissions_group']['custom_affiliates_system']) {
          $system[$affiliates_per_user_var] = $referrer['user_permissions_group'][$affiliates_per_user_var];
          $system[$affiliates_percentage_var] = $referrer['user_permissions_group'][$affiliates_percentage_var];
        }
        if ($referrer['custom_affiliates_system']) {
          $system[$affiliates_per_user_var] = $referrer[$affiliates_per_user_var];
          $system[$affiliates_percentage_var] = $referrer[$affiliates_percentage_var];
        }
        /* set balance */
        if ($system['affiliate_type'] == "packages" && $system['affiliate_payment_type'] == "percentage") {
          $balance = ($package_price * $system[$affiliates_percentage_var]) / 100;
        } else {
          $balance = $system[$affiliates_per_user_var];
        }
        /* update parent referrer balance */
        $this->update_referrer_balance($referrer['user_referrer_id'], $referee_id, $balance, $iteration);
      }
    }
  }


  /**
   * get_affiliates
   * 
   * @param integer $user_id
   * @param integer $offset
   * @return array
   */
  public function get_affiliates($user_id, $offset = 0)
  {
    global $db, $system;
    $affiliates = [];
    $offset *= $system['max_results'];
    $get_affiliates = $db->query(sprintf('SELECT user_id, user_name, user_firstname, user_lastname, user_gender, user_picture, user_subscribed, user_verified FROM users INNER JOIN users_affiliates ON users.user_id = users_affiliates.referee_id WHERE users_affiliates.referrer_id = %s LIMIT %s, %s', secure($user_id, 'int'), secure($offset, 'int', false), secure($system['max_results'], 'int', false)));
    if ($get_affiliates->num_rows > 0) {
      while ($affiliate = $get_affiliates->fetch_assoc()) {
        $affiliate['user_picture'] = get_picture($affiliate['user_picture'], $affiliate['user_gender']);
        /* get the connection between the viewer & the target */
        $affiliate['connection'] = $this->connection($affiliate['user_id'], false);
        $affiliates[] = $affiliate;
      }
    }
    return $affiliates;
  }
}
