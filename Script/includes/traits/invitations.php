<?php

/**
 * trait -> invitations
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich - Handles - @sorydima @sorydev @durovshater @DmitrySoro90935 @tanechfund - also check https://dmitry.rechain.network for more information!
 */

trait InvitationsTrait
{

  /* ------------------------------- */
  /* Invitations */
  /* ------------------------------- */

  /**
   * get_invitation_codes_details
   *
   * @return array
   */
  public function get_invitation_codes_details()
  {
    global $db;
    $codes = [];
    $get_codes = $db->query(sprintf('SELECT invitation_codes.*, users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM invitation_codes LEFT JOIN users ON invitation_codes.used_by = users.user_id WHERE invitation_codes.created_by = %s', secure($this->_data['user_id'], 'int')));
    if ($get_codes->num_rows > 0) {
      while ($code = $get_codes->fetch_assoc()) {
        if ($code['used']) {
          $code['user_picture'] = get_picture($code['user_picture'], $code['user_gender']);
        }
        $codes[] = $code;
      }
    }
    return $codes;
  }


  /**
   * get_invitation_codes_stats
   *
   * @return string
   */
  public function get_invitation_codes_stats()
  {
    global $db, $system;
    $get_generated_codes = $db->query(sprintf("SELECT COUNT(*) as count FROM invitation_codes WHERE created_by = %s AND created_date >= DATE_SUB(NOW(),INTERVAL 1 %s)", secure($this->_data['user_id'], 'int'), strtoupper($system['invitation_expire_period'])));
    $generated_codes = $get_generated_codes->fetch_assoc()['count'];
    $available_codes = $system['invitation_user_limit'] - $generated_codes;
    $get_used_codes = $db->query(sprintf("SELECT COUNT(*) as count FROM invitation_codes WHERE created_by = %s AND created_date >= DATE_SUB(NOW(),INTERVAL 1 %s) AND used = '1'", secure($this->_data['user_id'], 'int'), strtoupper($system['invitation_expire_period'])));
    $used_codes = $get_used_codes->fetch_assoc()['count'];
    return ["available" => $available_codes, "generated" => $generated_codes, "used" => $used_codes];
  }


  /**
   * check_user_invitation_codes
   *
   * @return void
   */
  public function can_generate_invitation_code()
  {
    global $db, $system;
    if ($this->_data['can_invite_users']) {
      if ($system['invitation_user_limit'] == 0) {
        return true;
      }
      $check_limit = $db->query(sprintf("SELECT COUNT(*) as count FROM invitation_codes WHERE created_by = %s AND created_date >= DATE_SUB(NOW(),INTERVAL 1 %s)", secure($this->_data['user_id'], 'int'), strtoupper($system['invitation_expire_period'])));
      if ($check_limit->fetch_assoc()['count'] < $system['invitation_user_limit']) {
        return true;
      }
    }
    return false;
  }


  /**
   * get_invitation_code
   *
   * @return string
   */
  public function generate_invitation_code()
  {
    global $db, $system, $date;
    /* check invitation enabled */
    if (!$system['invitation_enabled']) {
      throw new Exception(__("The invitation system has been disabled by the admin"));
    }
    /* check invitation permission */
    if (!$this->_data['can_invite_users']) {
      throw new Exception(__("You don't have the permission to do this"));
    }
    /* check if user can generate new code */
    if (!$this->can_generate_invitation_code()) {
      throw new Exception(__("You have reached the maximum number of invitation codes"));
    }
    $code = get_hash_key();
    $db->query(sprintf("INSERT INTO invitation_codes (code, created_by, created_date) VALUES (%s, %s, %s)", secure($code), secure($this->_data['user_id'], "int"), secure($date)));
    return $code;
  }


  /**
   * check_invitation_code
   *
   * @param string $code
   * @return boolean
   */
  public function check_invitation_code($code)
  {
    global $db;
    $query = $db->query(sprintf("SELECT COUNT(*) as count FROM invitation_codes WHERE code = %s AND used = '0'", secure($code)));
    if ($query->fetch_assoc()['count'] > 0) {
      return true;
    }
    return false;
  }


  /**
   * update_invitation_code
   *
   * @param string $code
   * @param string $user_id
   * @return void
   */
  public function update_invitation_code($code, $user_id)
  {
    global $db, $date;
    $db->query(sprintf("UPDATE invitation_codes SET used = '1', used_by = %s, used_date = %s WHERE code = %s", secure($user_id, "int"), secure($date), secure($code)));
  }


  /**
   * send_invitation_email
   *
   * @param string $email
   * @param string $code
   * @return void
   */
  public function send_invitation_email($email, $code)
  {
    global $db, $system, $date;
    /* check invitation enabled */
    if (!$system['invitation_enabled']) {
      throw new Exception(__("The invitation system has been disabled by the admin"));
    }
    /* check invitation permission */
    if (!$this->_data['can_invite_users']) {
      throw new Exception(__("You don't have the permission to do this"));
    }
    /* check invitation code */
    if (!$this->check_invitation_code($code)) {
      throw new Exception(__("This invitation code is expired or invalid"));
    }
    /* check email */
    if (!valid_email($email)) {
      throw new Exception(__("Please enter a valid email address"));
    }
    if ($this->check_email($email)) {
      throw new Exception(__("Sorry, it looks like") . " " . $email . " " . __("belongs to an existing account"));
    }
    /* check if viewer already invited this email before */
    $check_invitation_log = $db->query(sprintf("SELECT COUNT(*) as count FROM users_invitations WHERE email_phone = %s", secure($email)));
    if ($check_invitation_log->fetch_assoc()['count'] > 0) {
      throw new Exception(__("You already invited this email before"));
    }
    /* prepare invitation email */
    $subject = html_entity_decode($this->_data['user_fullname'], ENT_QUOTES) . " " . __("Invite you to join") . " " . html_entity_decode(__($system['system_title']), ENT_QUOTES);
    $body = get_email_template("invitation_user_email", $subject, ["code" => $code]);
    /* send email */
    if (!_email($email, $subject, $body['html'], $body['plain'])) {
      throw new Exception(__("Invitation email could not be sent"));
    }
    /* add to log */
    $db->query(sprintf("INSERT INTO users_invitations (user_id, email_phone, invitation_date) VALUES (%s, %s, %s)", secure($this->_data['user_id'], 'int'), secure($email), secure($date)));
  }


  /**
   * send_invitation_sms
   *
   * @param string $phone
   * @param string $code
   * @return void
   */
  public function send_invitation_sms($phone, $code)
  {
    global $db, $system, $date;
    /* check invitation enabled */
    if (!$system['invitation_enabled']) {
      throw new Exception(__("The invitation system has been disabled by the admin"));
    }
    /* check invitation permission */
    if (!$this->_data['can_invite_users']) {
      throw new Exception(__("You don't have the permission to do this"));
    }
    /* check invitation code */
    if (!$this->check_invitation_code($code)) {
      throw new Exception(__("This invitation code is expired or invalid"));
    }
    /* check phone */
    if (is_empty($phone)) {
      throw new Exception(__("Please enter a valid phone number"));
    }
    if ($this->check_phone($phone)) {
      throw new Exception(__("Sorry, it looks like") . " " . $phone . " " . __("belongs to an existing account"));
    }
    /* check if viewer already invited this phone before */
    $check_invitation_log = $db->query(sprintf("SELECT COUNT(*) as count FROM users_invitations WHERE email_phone = %s", secure($phone)));
    if ($check_invitation_log->fetch_assoc()['count'] > 0) {
      throw new Exception(__("You already invited this phone number before"));
    }
    /* prepare activation SMS */
    $message = $this->_data['user_fullname'] . " " . __("Invite you to join") . " " . __($system['system_title']) . " " . $system['system_url'] . "/?ref=" . $this->_data['user_name'] . "&invitation_code=" . $code;
    /* send SMS */
    if (!sms_send($phone, $message)) {
      throw new Exception(__("Invitation SMS could not be sent"));
    }
    /* add to log */
    $db->query(sprintf("INSERT INTO users_invitations (user_id, email_phone, invitation_date) VALUES (%s, %s, %s)", secure($this->_data['user_id'], 'int'), secure($phone), secure($date)));
  }
}
