<?php

/**
 * trait -> notifications
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich - Handles - @sorydima @sorydev @durovshater @DmitrySoro90935 @tanechfund - also check https://dmitry.rechain.network for more information!
 */

trait NotificationsTrait
{

  /* ------------------------------- */
  /* Notifications */
  /* ------------------------------- */

  /**
   * get_notifications
   * 
   * @param integer $offset
   * @param integer $last_notification_id
   * @return array
   */
  public function get_notifications($offset = 0, $last_notification_id = null)
  {
    global $db, $system, $control_panel;
    if (!isset($control_panel)) {
      $control_panel['url'] = ($this->_is_admin) ? "admincp" : "modcp";
    }
    $offset *= $system['max_results'];
    $notifications = [];
    if ($last_notification_id !== null) {
      $get_notifications = $db->query(sprintf("SELECT notifications.*, users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, users.user_subscribed, users.user_verified, pages.page_id, pages.page_title, pages.page_picture FROM notifications LEFT JOIN users ON notifications.from_user_id = users.user_id AND notifications.from_user_type = 'user' LEFT JOIN pages ON notifications.from_user_id = pages.page_id AND notifications.from_user_type = 'page' WHERE notifications.action != 'chat_message' AND (notifications.to_user_id = %s OR notifications.to_user_id = '0') AND notifications.notification_id > %s ORDER BY notifications.notification_id DESC", secure($this->_data['user_id'], 'int'), secure($last_notification_id, 'int')));
    } else {
      $get_notifications = $db->query(sprintf("SELECT notifications.*, users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, users.user_subscribed, users.user_verified, pages.page_id, pages.page_title, pages.page_picture FROM notifications LEFT JOIN users ON notifications.from_user_id = users.user_id AND notifications.from_user_type = 'user' LEFT JOIN pages ON notifications.from_user_id = pages.page_id AND notifications.from_user_type = 'page' WHERE notifications.action != 'chat_message' AND notifications.to_user_id = %s OR notifications.to_user_id = '0' ORDER BY notifications.notification_id DESC LIMIT %s, %s", secure($this->_data['user_id'], 'int'), secure($offset, 'int', false), secure($system['max_results'], 'int', false)));
    }
    if ($get_notifications->num_rows > 0) {
      while ($notification = $get_notifications->fetch_assoc()) {
        /* prepare notification name & picture */
        if ($notification['from_user_type'] == "user") {
          $notification['user_picture'] = get_picture($notification['user_picture'], $notification['user_gender']);
          $notification['name'] = ($system['show_usernames_enabled']) ? $notification['user_name'] : $notification['user_firstname'] . " " . $notification['user_lastname'];
        } else {
          $notification['user_picture'] = get_picture($notification['page_picture'], "page");
          $notification['name'] = $notification['page_title'];
        }
        /* prepare notification notify_id */
        $notification['notify_id'] = ($notification['notify_id']) ? "?notify_id=" . $notification['notify_id'] : "";
        /* prepare notification node_url */
        if (strpos($notification['node_url'], "-[guid=]") !== false) {
          /* Note: GUID in node_url to make the notification record unique */
          $notification['node_url'] = explode("-[guid=]", $notification['node_url'])[0];
        }
        /* parse notification */
        switch ($notification['action']) {
          case 'mass_notification':
            $notification['system_notification'] = true;
            $notification['icon'] = "fa fa-bell";
            $notification['user_picture'] = get_picture("", "system");
            $notification['name'] = __("System") . " " . __("Message");
            $notification['url'] = $notification['node_url'];
            $notification['message'] = $notification['message'];
            break;

          case 'friend_add':
            $notification['icon'] = "fa fa-user-plus";
            $notification['url'] = $system['system_url'] . '/' . $notification['user_name'];
            $notification['message'] = __("sent you a friend request");
            break;

          case 'friend_accept':
            $notification['icon'] = "fa fa-user-plus";
            $notification['url'] = $system['system_url'] . '/' . $notification['user_name'];
            $notification['message'] = __("accepted your friend request");
            break;

          case 'follow':
            $notification['icon'] = "fa fa-rss";
            $notification['url'] = $system['system_url'] . '/' . $notification['user_name'];
            $notification['message'] = __("now following you");
            break;

          case 'poke':
            $notification['icon'] = "fa fa-hand-point-right";
            $notification['url'] = $system['system_url'] . '/' . $notification['user_name'];
            $notification['message'] = __("poked you");
            break;

          case 'gift':
            $notification['icon'] = "fa fa-gift";
            $notification['url'] = $system['system_url'] . '/' . $this->_data['user_name'] . '?gift=' . $notification['node_url'];
            $notification['message'] = __("Sent you a gift");
            break;

          case 'subscribe_user':
          case 'subscribe_profile':
            $notification['icon'] = "fa fa-rss";
            $notification['url'] = $system['system_url'] . '/' . $notification['user_name'];
            $notification['message'] = __("subscribed to your profile");
            break;

          case 'subscribe_page':
            $notification['icon'] = "fa fa-rss";
            $notification['url'] = $system['system_url'] . '/pages/' . $notification['node_url'];
            $notification['message'] = __("subscribed to your page") . " '" . html_entity_decode($notification['node_type'], ENT_QUOTES) . "'";
            break;

          case 'subscribe_group':
            $notification['icon'] = "fa fa-rss";
            $notification['url'] = $system['system_url'] . '/groups/' . $notification['node_url'];
            $notification['message'] = __("subscribed to your group") . " '" . html_entity_decode($notification['node_type'], ENT_QUOTES) . "'";
            break;

          case 'paid_post':
            $notification['icon'] = "fa fa-dollar-sign";
            $notification['url'] = $system['system_url'] . '/posts/' . $notification['node_url'];
            $notification['message'] = __("bought your post");
            break;

          case 'react_like':
          case 'react_love':
          case 'react_haha':
          case 'react_yay':
          case 'react_wow':
          case 'react_sad':
          case 'react_angry':
            $notification['reaction'] = substr($notification['action'], strpos($notification['action'], "_") + 1);
            if ($notification['node_type'] == "post") {
              $notification['url'] = $system['system_url'] . '/posts/' . $notification['node_url'];
              $notification['message'] = __("reacted to your post");
            } elseif ($notification['node_type'] == "photo") {
              $notification['url'] = $system['system_url'] . '/photos/' . $notification['node_url'];
              $notification['message'] = __("reacted to your photo");
            } elseif ($notification['node_type'] == "post_comment") {
              $notification['url'] = $system['system_url'] . '/posts/' . $notification['node_url'] . $notification['notify_id'];
              $notification['message'] = __("reacted to your comment");
            } elseif ($notification['node_type'] == "photo_comment") {
              $notification['url'] = $system['system_url'] . '/photos/' . $notification['node_url'] . $notification['notify_id'];
              $notification['message'] = __("reacted to your comment");
            } elseif ($notification['node_type'] == "post_reply") {
              $notification['url'] = $system['system_url'] . '/posts/' . $notification['node_url'] . $notification['notify_id'];
              $notification['message'] = __("reacted to your reply");
            } elseif ($notification['node_type'] == "photo_reply") {
              $notification['url'] = $system['system_url'] . '/photos/' . $notification['node_url'] . $notification['notify_id'];
              $notification['message'] = __("reacted to your reply");
            }
            break;

          case 'comment':
            $notification['icon'] = "fa fa-comment";
            if ($notification['node_type'] == "post") {
              $notification['url'] = $system['system_url'] . '/posts/' . $notification['node_url'] . $notification['notify_id'];
              $notification['message'] = __("commented on your post");
            } elseif ($notification['node_type'] == "photo") {
              $notification['url'] = $system['system_url'] . '/photos/' . $notification['node_url'] . $notification['notify_id'];
              $notification['message'] = __("commented on your photo");
            }
            break;

          case 'reply':
            $notification['icon'] = "fa fa-comment";
            if ($notification['node_type'] == "post") {
              $notification['url'] = $system['system_url'] . '/posts/' . $notification['node_url'] . $notification['notify_id'];
            } elseif ($notification['node_type'] == "photo") {
              $notification['url'] = $system['system_url'] . '/photos/' . $notification['node_url'] . $notification['notify_id'];
            }
            $notification['message'] = __("replied to your comment");
            break;

          case 'share':
            $notification['icon'] = "fa fa-share";
            $notification['url'] = $system['system_url'] . '/posts/' . $notification['node_url'];
            $notification['message'] = __("shared your post");
            break;

          case 'vote':
            $notification['icon'] = "fa fa-check-circle";
            $notification['url'] = $system['system_url'] . '/posts/' . $notification['node_url'];
            $notification['message'] = __("voted on your poll");
            break;

          case 'mention':
            $notification['icon'] = "fa fa-comment";
            switch ($notification['node_type']) {
              case 'post':
                $notification['url'] = $system['system_url'] . '/posts/' . $notification['node_url'];
                $notification['message'] = __("mentioned you in a post");
                break;

              case 'comment_post':
                $notification['url'] = $system['system_url'] . '/posts/' . $notification['node_url'] . $notification['notify_id'];
                $notification['message'] = __("mentioned you in a comment");
                break;

              case 'comment_photo':
                $notification['url'] = $system['system_url'] . '/photos/' . $notification['node_url'] . $notification['notify_id'];
                $notification['message'] = __("mentioned you in a comment");
                break;

              case 'reply_post':
                $notification['url'] = $system['system_url'] . '/posts/' . $notification['node_url'] . $notification['notify_id'];
                $notification['message'] = __("mentioned you in a reply");
                break;

              case 'reply_photo':
                $notification['url'] = $system['system_url'] . '/photos/' . $notification['node_url'] . $notification['notify_id'];
                $notification['message'] = __("mentioned you in a reply");
                break;
            }
            break;

          case 'profile_visit':
            $notification['icon'] = "fa fa-eye";
            $notification['url'] = $system['system_url'] . '/' . $notification['user_name'];
            $notification['message'] = __("visited your profile");
            break;

          case 'wall':
            $notification['icon'] = "fa fa-comment";
            $notification['url'] = $system['system_url'] . '/posts/' . $notification['node_url'];
            $notification['message'] = __("posted on your wall");
            break;

          case 'page_invitation':
            $notification['icon'] = "fa fa-flag";
            $notification['url'] = $system['system_url'] . '/pages/' . $notification['node_url'];
            $notification['message'] = __("invite you to like a page") . " '" . html_entity_decode($notification['node_type'], ENT_QUOTES) . "'";
            break;

          case 'page_admin_addation':
            $notification['icon'] = "fa fa-users";
            $notification['url'] = $system['system_url'] . '/pages/' . $notification['node_url'];
            $notification['message'] = __("added you as admin to") . " '" . html_entity_decode($notification['node_type'], ENT_QUOTES) . "' " . __("page");
            break;

          case 'page_event':
            $notification['icon'] = "fa fa-calendar";
            $notification['url'] = $system['system_url'] . '/events/' . $notification['node_url'];
            $notification['message'] = __("created new event");
            break;

          case 'group_join':
            $notification['icon'] = "fa fa-users";
            $notification['url'] = $system['system_url'] . '/groups/' . $notification['node_url'] . '/settings/requests';
            $notification['message'] = __("asked to join your group") . " '" . html_entity_decode($notification['node_type'], ENT_QUOTES) . "'";
            break;

          case 'group_add':
            $notification['icon'] = "fa fa-users";
            $notification['url'] = $system['system_url'] . '/groups/' . $notification['node_url'];
            $notification['message'] = __("added you to") . " '" . html_entity_decode($notification['node_type'], ENT_QUOTES) . "' " . __("group");
            break;

          case 'group_accept':
            $notification['icon'] = "fa fa-users";
            $notification['url'] = $system['system_url'] . '/groups/' . $notification['node_url'];
            $notification['message'] = __("accepted your request to join") . " '" . html_entity_decode($notification['node_type'], ENT_QUOTES) . "' " . __("group");
            break;

          case 'group_invitation':
            $notification['icon'] = "fa fa-users";
            $notification['url'] = $system['system_url'] . '/groups/' . $notification['node_url'];
            $notification['message'] = __("invite you to join a group") . " '" . html_entity_decode($notification['node_type'], ENT_QUOTES) . "'";
            break;

          case 'group_admin_addation':
            $notification['icon'] = "fa fa-users";
            $notification['url'] = $system['system_url'] . '/groups/' . $notification['node_url'];
            $notification['message'] = __("added you as admin to") . " '" . html_entity_decode($notification['node_type'], ENT_QUOTES) . "' " . __("group");
            break;

          case 'group_post_pending':
            $notification['icon'] = "fa fa-users";
            $notification['url'] = $system['system_url'] . '/groups/' . $notification['node_url'] . '?pending';
            $notification['message'] = __("added pending post in your group") . " '" . html_entity_decode($notification['node_type'], ENT_QUOTES) . "'";
            break;

          case 'group_post_approval':
            $notification['icon'] = "fa fa-users";
            $notification['url'] = $system['system_url'] . '/groups/' . $notification['node_url'];
            $notification['message'] = __("approved your your pending post in group") . " '" . html_entity_decode($notification['node_type'], ENT_QUOTES) . "'";
            break;

          case 'event_invitation':
            $notification['icon'] = "fa fa-calendar";
            $notification['url'] = $system['system_url'] . '/events/' . $notification['node_url'];
            $notification['message'] = __("invite you to join an event") . " '" . html_entity_decode($notification['node_type'], ENT_QUOTES) . "'";
            break;

          case 'event_post_pending':
            $notification['icon'] = "fa fa-calendar";
            $notification['url'] = $system['system_url'] . '/events/' . $notification['node_url'] . '?pending';
            $notification['message'] = __("added pending post in your event") . " '" . html_entity_decode($notification['node_type'], ENT_QUOTES) . "'";
            break;

          case 'event_post_approval':
            $notification['icon'] = "fa fa-calendar";
            $notification['url'] = $system['system_url'] . '/events/' . $notification['node_url'];
            $notification['message'] = __("approved your your pending post in event") . " '" . html_entity_decode($notification['node_type'], ENT_QUOTES) . "'";
            break;

          case 'forum_reply':
            $notification['icon'] = "fa fa-comment";
            $notification['url'] = $system['system_url'] . '/forums/thread/' . $notification['node_url'];
            $notification['message'] = __("replied to your thread");
            break;

          case 'money_sent':
            $notification['icon'] = "fa fa-gift";
            $notification['url'] = $system['system_url'] . '/wallet';
            $notification['message'] = __("sent you") . " " . print_money($notification['node_type']);
            break;

          case 'tip_sent':
            $notification['icon'] = "fa fa-dollar-sign";
            $notification['url'] = $system['system_url'] . '/wallet';
            $notification['message'] = __("Tip you with") . " " . print_money($notification['node_type']);
            break;

          case 'coinpayments_complete':
            $notification['system_notification'] = true;
            $notification['icon'] = "fa fa-bell";
            $notification['user_picture'] = get_picture("", "system");
            $notification['url'] = $system['system_url'] . '/settings/coinpayments';
            $notification['message'] = __("Your CoinPayments transaction complete successfully");
            break;

          case 'bank_transfer':
            $notification['icon'] = "fa fa-university";
            $notification['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/bank';
            $notification['message'] = __("Sent new bank transfer");
            break;

          case 'bank_transfer_approved':
            $notification['system_notification'] = true;
            $notification['icon'] = "fa fa-bell";
            $notification['user_picture'] = get_picture("", "system");
            $notification['name'] = __("System") . " " . __("Message");
            $notification['url'] = $system['system_url'] . '/settings/bank';
            $notification['message'] = __("Your bank transfer has been approved");
            break;

          case 'bank_transfer_declined':
            $notification['system_notification'] = true;
            $notification['icon'] = "fa fa-bell";
            $notification['user_picture'] = get_picture("", "system");
            $notification['name'] = __("System") . " " . __("Message");
            $notification['url'] = $system['system_url'] . '/settings/bank';
            $notification['message'] = __("Your bank transfer has been declined");
            break;

          case 'wallet_withdrawal':
            $notification['icon'] = "fa fa-exchange-alt";
            $notification['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/wallet/payments';
            $notification['message'] = __("Sent new wallet withdrawal request");
            break;

          case 'wallet_withdrawal_approved':
            $notification['system_notification'] = true;
            $notification['icon'] = "fa fa-bell";
            $notification['user_picture'] = get_picture("", "system");
            $notification['name'] = __("System") . " " . __("Message");
            $notification['url'] = $system['system_url'] . '/wallet/payments';
            $notification['message'] = __("Your wallet withdrawal request has been approved");
            break;

          case 'wallet_withdrawal_declined':
            $notification['system_notification'] = true;
            $notification['icon'] = "fa fa-bell";
            $notification['user_picture'] = get_picture("", "system");
            $notification['name'] = __("System") . " " . __("Message");
            $notification['url'] = $system['system_url'] . '/wallet/payments';
            $notification['message'] = __("Your wallet withdrawal request has been declined");
            break;

          case 'affiliates_withdrawal':
            $notification['icon'] = "fa fa-exchange-alt";
            $notification['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/affiliates/payments';
            $notification['message'] = __("Sent new affiliates withdrawal request");
            break;

          case 'affiliates_withdrawal_approved':
            $notification['system_notification'] = true;
            $notification['icon'] = "fa fa-bell";
            $notification['user_picture'] = get_picture("", "system");
            $notification['name'] = __("System") . " " . __("Message");
            $notification['url'] = $system['system_url'] . '/settings/affiliates/payments';
            $notification['message'] = __("Your affiliates withdrawal request has been approved");
            break;

          case 'affiliates_withdrawal_declined':
            $notification['system_notification'] = true;
            $notification['icon'] = "fa fa-bell";
            $notification['user_picture'] = get_picture("", "system");
            $notification['name'] = __("System") . " " . __("Message");
            $notification['url'] = $system['system_url'] . '/settings/affiliates/payments';
            $notification['message'] = __("Your affiliates withdrawal request has been declined");
            break;

          case 'points_withdrawal':
            $notification['icon'] = "fa fa-piggy-bank";
            $notification['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/points/payments';
            $notification['message'] = __("Sent new points withdrawal request");
            break;

          case 'points_withdrawal_approved':
            $notification['system_notification'] = true;
            $notification['icon'] = "fa fa-bell";
            $notification['user_picture'] = get_picture("", "system");
            $notification['name'] = __("System") . " " . __("Message");
            $notification['url'] = $system['system_url'] . '/settings/points/payments';
            $notification['message'] = __("Your points withdrawal request has been approved");
            break;

          case 'points_withdrawal_declined':
            $notification['system_notification'] = true;
            $notification['icon'] = "fa fa-bell";
            $notification['user_picture'] = get_picture("", "system");
            $notification['name'] = __("System") . " " . __("Message");
            $notification['url'] = $system['system_url'] . '/settings/points/payments';
            $notification['message'] = __("Your points withdrawal request has been declined");
            break;

          case 'market_withdrawal':
            $notification['icon'] = "fa fa-shopping-bag";
            $notification['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/market/payments';
            $notification['message'] = __("Sent new market withdrawal request");
            break;

          case 'market_withdrawal_approved':
            $notification['system_notification'] = true;
            $notification['icon'] = "fa fa-bell";
            $notification['user_picture'] = get_picture("", "system");
            $notification['name'] = __("System") . " " . __("Message");
            $notification['url'] = $system['system_url'] . '/settings/market';
            $notification['message'] = __("Your market withdrawal request has been approved");
            break;

          case 'market_withdrawal_declined':
            $notification['system_notification'] = true;
            $notification['icon'] = "fa fa-bell";
            $notification['user_picture'] = get_picture("", "system");
            $notification['name'] = __("System") . " " . __("Message");
            $notification['url'] = $system['system_url'] . '/settings/market';
            $notification['message'] = __("Your market withdrawal request has been declined");
            break;

          case 'market_outofstock':
            $notification['system_notification'] = true;
            $notification['icon'] = "fa fa-bell";
            $notification['user_picture'] = get_picture("", "system");
            $notification['name'] = __("System") . " " . __("Message");
            $notification['url'] = $system['system_url'] . '/posts/' . $notification['node_url'];
            $notification['message'] = __("Your product is out of stock");
            break;

          case 'market_order':
            $notification['icon'] = "fa fa-shopping-bag";
            $notification['url'] = $system['system_url'] . '/market/sales?query=' . $notification['node_url'];
            $notification['message'] = __("You got new order");
            break;

          case 'market_order_tracking_updated':
            $notification['icon'] = "fa fa-shopping-bag";
            $notification['url'] = $system['system_url'] . '/market/orders?query=' . $notification['node_url'];
            $notification['message'] = __("Your order tracking updated");
            break;

          case 'market_order_status_updated':
            $notification['icon'] = "fa fa-shopping-bag";
            $notification['url'] = $system['system_url'] . '/market/orders?query=' . $notification['node_url'];
            $notification['message'] = __("Your order status updated");
            break;

          case 'market_order_delivered':
            $notification['icon'] = "fa fa-shopping-bag";
            $notification['url'] = $system['system_url'] . '/market/sales?query=' . $notification['node_url'];
            $notification['message'] = __("Your order delivered");
            break;

          case 'market_order_delivered_seller_system':
            $notification['system_notification'] = true;
            $notification['icon'] = "fa fa-bell";
            $notification['user_picture'] = get_picture("", "system");
            $notification['name'] = __("System") . " " . __("Message");
            $notification['url'] = $system['system_url'] . '/market/sales?query=' . $notification['node_url'];
            $notification['message'] = __("Your order delivered automatically");
            break;

          case 'market_order_delivered_buyer_system':
            $notification['system_notification'] = true;
            $notification['icon'] = "fa fa-bell";
            $notification['user_picture'] = get_picture("", "system");
            $notification['name'] = __("System") . " " . __("Message");
            $notification['url'] = $system['system_url'] . '/market/orders?query=' . $notification['node_url'];
            $notification['message'] = __("Your order delivered automatically");
            break;

          case 'job_application':
            $notification['icon'] = "fa fa-briefcase";
            $notification['url'] = $system['system_url'] . '/posts/' . $notification['node_url'];
            $notification['message'] = __("applied to your job");
            break;

          case 'course_application':
            $notification['icon'] = "fa fa-graduation-cap";
            $notification['url'] = $system['system_url'] . '/posts/' . $notification['node_url'];
            $notification['message'] = __("enrolled to your course");
            break;

          case 'funding_withdrawal':
            $notification['icon'] = "fa fa-hand-holding-usd";
            $notification['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/funding/payments';
            $notification['message'] = __("Sent new funding withdrawal request");
            break;

          case 'funding_withdrawal_approved':
            $notification['system_notification'] = true;
            $notification['icon'] = "fa fa-bell";
            $notification['user_picture'] = get_picture("", "system");
            $notification['name'] = __("System") . " " . __("Message");
            $notification['url'] = $system['system_url'] . '/settings/funding';
            $notification['message'] = __("Your funding withdrawal request has been approved");
            break;

          case 'funding_withdrawal_declined':
            $notification['system_notification'] = true;
            $notification['icon'] = "fa fa-bell";
            $notification['user_picture'] = get_picture("", "system");
            $notification['name'] = __("System") . " " . __("Message");
            $notification['url'] = $system['system_url'] . '/settings/funding';
            $notification['message'] = __("Your funding withdrawal request has been declined");
            break;

          case 'funding_donation':
            $notification['icon'] = "fa fa-hand-holding-usd";
            $notification['url'] = $system['system_url'] . '/posts/' . $notification['node_url'];
            $notification['message'] = __("donated to your funding request with") . " " . print_money($notification['node_type']);
            break;

          case 'monetization_withdrawal':
            $notification['icon'] = "fa fa-hand-holding-usd";
            $notification['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/monetization/payments';
            $notification['message'] = __("Sent new monetization withdrawal request");
            break;

          case 'monetization_withdrawal_approved':
            $notification['system_notification'] = true;
            $notification['icon'] = "fa fa-bell";
            $notification['user_picture'] = get_picture("", "system");
            $notification['name'] = __("System") . " " . __("Message");
            $notification['url'] = $system['system_url'] . '/settings/monetization';
            $notification['message'] = __("Your monetization withdrawal request has been approved");
            break;

          case 'monetization_withdrawal_declined':
            $notification['system_notification'] = true;
            $notification['icon'] = "fa fa-bell";
            $notification['user_picture'] = get_picture("", "system");
            $notification['name'] = __("System") . " " . __("Message");
            $notification['url'] = $system['system_url'] . '/settings/monetization';
            $notification['message'] = __("Your monetization withdrawal request has been declined");
            break;

          case 'ads_campaign_added':
            $notification['icon'] = "fa fa-bullseye";
            $notification['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/ads/users_ads';
            $notification['message'] = __("Added new ads campaign");
            break;

          case 'ads_campaign_edited':
            $notification['icon'] = "fa fa-bullseye";
            $notification['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/ads/users_ads';
            $notification['message'] = __("Edited ads campaign");
            break;

          case 'ads_campaign_approved':
            $notification['system_notification'] = true;
            $notification['icon'] = "fa fa-bell";
            $notification['user_picture'] = get_picture("", "system");
            $notification['name'] = __("System") . " " . __("Message");
            $notification['url'] = $system['system_url'] . '/ads';
            $notification['message'] = __("Your ads campaign has been approved");
            break;

          case 'ads_campaign_declined':
            $notification['system_notification'] = true;
            $notification['icon'] = "fa fa-bell";
            $notification['user_picture'] = get_picture("", "system");
            $notification['name'] = __("System") . " " . __("Message");
            $notification['url'] = $system['system_url'] . '/ads';
            $notification['message'] = __("Your ads campaign has been declined");
            break;

          case 'report':
            $notification['icon'] = "fa fa-flag";
            $notification['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/reports';
            $notification['message'] = __("reported new content");
            break;

          case 'verification_request':
            $notification['icon'] = "fa fa-check-circle";
            $notification['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/verification';
            $notification['message'] = __("sent new verification request");
            break;

          case 'verification_request_approved':
            $notification['system_notification'] = true;
            $notification['icon'] = "fa fa-bell";
            $notification['user_picture'] = get_picture("", "system");
            $notification['name'] = __("System") . " " . __("Message");
            $notification['url'] = $system['system_url'] . '/settings/verification';
            $notification['message'] = __("Your verification request has been approved");
            break;

          case 'verification_request_declined':
            $notification['system_notification'] = true;
            $notification['icon'] = "fa fa-bell";
            $notification['user_picture'] = get_picture("", "system");
            $notification['name'] = __("System") . " " . __("Message");
            $notification['url'] = $system['system_url'] . '/settings/verification';
            $notification['message'] = __("Your verification request has been declined");
            break;

          case 'verification_request_page_approved':
            $notification['system_notification'] = true;
            $notification['icon'] = "fa fa-bell";
            $notification['user_picture'] = get_picture("", "system");
            $notification['name'] = __("System") . " " . __("Message");
            $notification['url'] = $system['system_url'] . '/pages/' . $notification['node_url'] . '/settings/verification';
            $notification['message'] = __("Your page verification request has been approved");
            break;

          case 'verification_request_page_declined':
            $notification['system_notification'] = true;
            $notification['icon'] = "fa fa-bell";
            $notification['user_picture'] = get_picture("", "system");
            $notification['name'] = __("System") . " " . __("Message");
            $notification['url'] = $system['system_url'] . '/pages/' . $notification['node_url'] . '/settings/verification';
            $notification['message'] = __("Your page verification request has been declined");
            break;

          case 'live_stream':
            $notification['icon'] = "fa fa-video";
            $notification['url'] = $system['system_url'] . '/posts/' . $notification['node_url'];
            $notification['message'] = __("is live now");
            break;

          case 'async_request':
            $notification['system_notification'] = true;
            $notification['icon'] = "fa fa-bell";
            $notification['user_picture'] = get_picture("", "system");
            $notification['name'] = __("System") . " " . __("Message");
            $notification['url'] = $system['system_url'] . '/' . $control_panel['url'];
            $notification['message'] = $notification['message'];
            break;

          case 'video_converted':
            $notification['system_notification'] = true;
            $notification['icon'] = "fa fa-bell";
            $notification['user_picture'] = get_picture("", "system");
            $notification['name'] = __("System") . " " . __("Message");
            $notification['url'] = $system['system_url'] . '/posts/' . $notification['node_url'];
            $notification['message'] = __("Your video has been converted");
            break;

          case 'page_review':
            $notification['icon'] = "fa fa-star";
            $notification['url'] = $system['system_url'] . '/pages/' . $notification['node_url'] . '/reviews';
            $notification['message'] = __("reviewed your page");
            break;

          case 'page_review_reply':
            $notification['icon'] = "fa fa-star";
            $notification['url'] = $system['system_url'] . '/pages/' . $notification['node_url'] . '/reviews';
            $notification['message'] = __("replied on your review");
            break;

          case 'group_review':
            $notification['icon'] = "fa fa-star";
            $notification['url'] = $system['system_url'] . '/groups/' . $notification['node_url'] . '/reviews';
            $notification['message'] = __("reviewed your group");
            break;

          case 'group_review_reply':
            $notification['icon'] = "fa fa-star";
            $notification['url'] = $system['system_url'] . '/groups/' . $notification['node_url'] . '/reviews';
            $notification['message'] = __("replied on your review");
            break;

          case 'event_review':
            $notification['icon'] = "fa fa-star";
            $notification['url'] = $system['system_url'] . '/events/' . $notification['node_url'] . '/reviews';
            $notification['message'] = __("reviewed your event");
            break;

          case 'event_review_reply':
            $notification['icon'] = "fa fa-star";
            $notification['url'] = $system['system_url'] . '/events/' . $notification['node_url'] . '/reviews';
            $notification['message'] = __("replied on your review");
            break;

          case 'post_review':
            $notification['icon'] = "fa fa-star";
            $notification['url'] = $system['system_url'] . '/posts/' . $notification['node_url'];
            $notification['message'] = __("reviewed your post");
            break;

          case 'post_review_reply':
            $notification['icon'] = "fa fa-star";
            $notification['url'] = $system['system_url'] . '/posts/' . $notification['node_url'];
            $notification['message'] = __("replied on your review");
            break;

          case 'pending_post':
            $notification['icon'] = "fa fa-clock";
            $notification['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/posts/pending';
            $notification['message'] = __("sent new post for approval");
            break;

          case 'pending_post_approved':
            $notification['system_notification'] = true;
            $notification['icon'] = "fa fa-bell";
            $notification['user_picture'] = get_picture("", "system");
            $notification['name'] = __("System") . " " . __("Message");
            $notification['url'] = $system['system_url'] . '/posts/' . $notification['node_url'];
            $notification['message'] = __("Your post has been approved");
            break;

          case 'pending_user':
            $notification['icon'] = "fa fa-clock";
            $notification['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/users/pending';
            $notification['message'] = __("sent new user for approval");
            break;

          case 'pending_user_approved':
            $notification['system_notification'] = true;
            $notification['icon'] = "fa fa-bell";
            $notification['user_picture'] = get_picture("", "system");
            $notification['name'] = __("System") . " " . __("Message");
            $notification['url'] = $system['system_url'];
            $notification['message'] = __("Your account has been approved");
            break;

          case 'pending_payment_approved':
            $notification['system_notification'] = true;
            $notification['icon'] = "fa fa-bell";
            $notification['user_picture'] = get_picture("", "system");
            $notification['name'] = __("System") . " " . __("Message");
            $notification['url'] = $system['system_url'] . $notification['node_url'];
            $notification['message'] = __("Your pending payment has been approved");
            break;

          case 'chat_message_paid':
            $notification['icon'] = "fa fa-dollar-sign";
            $notification['url'] = $system['system_url'] . '/messages';
            $notification['message'] = __("sent you a paid message");
            break;

          case 'merit_received':
            $notification['icon'] = "fa fa-star";
            $notification['url'] = $system['system_url'] . '/posts/' . $notification['node_url'];
            $notification['message'] = __("sent you a merit");
            break;

          case 'merit_sent':
            $notification['system_notification'] = true;
            $notification['icon'] = "fa fa-bell";
            $notification['user_picture'] = get_picture("", "system");
            $notification['name'] = __("System") . " " . __("Message");
            $notification['url'] = $system['system_url'];
            $notification['message'] = __("Your merit has been sent");
            break;

          case 'merits_reminder':
            $notification['system_notification'] = true;
            $notification['icon'] = "fa fa-bell";
            $notification['user_picture'] = get_picture("", "system");
            $notification['name'] = __("System") . " " . __("Message");
            $notification['url'] = $system['system_url'];
            $notification['message'] = __("You still have ") . $notification['node_url'] . __(" merits to send");
            break;
        }
        /* prepare message */
        $notification['full_message'] = html_entity_decode($notification['name'], ENT_QUOTES) . " " . html_entity_decode($notification['message'], ENT_QUOTES);
        $notifications[] = $notification;
      }
    }
    return $notifications;
  }


  /**
   * post_notification
   * 
   * @param array $args
   * @return void
   */
  public function post_notification($args = [])
  {
    global $db, $date, $system, $gettextLoader, $gettextTranslator, $control_panel;
    if (!isset($control_panel)) {
      $control_panel['url'] = ($this->_is_admin) ? "admincp" : "modcp";
    }
    /* initialize arguments */
    $to_user_id = !isset($args['to_user_id']) ? _error(400) : $args['to_user_id'];
    $from_user_id = !isset($args['from_user_id']) ? $this->_data['user_id'] : $args['from_user_id'];
    $from_user_type = !isset($args['from_user_type']) ? 'user' : $args['from_user_type'];
    $action = !isset($args['action']) ? _error(400) : $args['action'];
    $node_type = !isset($args['node_type']) ? '' : $args['node_type'];
    $node_url = !isset($args['node_url']) ? '' : $args['node_url'];
    $message = !isset($args['message']) ? '' : $args['message'];
    $notify_id = !isset($args['notify_id']) ? '' : $args['notify_id'];
    $system_notification = !isset($args['system_notification']) ? false : $args['system_notification'];
    /* check if the notification is system notification */
    if ($system_notification) {
      /* yes, set the sender as system */
      $this->_data['user_fullname'] = __("System");
    } else {
      /* no, if the viewer is the target */
      if ($this->_data['user_id'] == $to_user_id && !in_array($action, ["async_request", "video_converted"])) {
        return;
      }
      /* get sender user (if not exists) */
      if (!$this->_data['user_fullname']) {
        $get_sender = $db->query(sprintf("SELECT * FROM users WHERE user_id = %s", secure($from_user_id, 'int')));
        if ($get_sender->num_rows == 0) {
          return;
        }
        $sender = $get_sender->fetch_assoc();
        $this->_data['user_fullname'] = ($system['show_usernames_enabled']) ? $sender['user_name'] : $sender['user_firstname'] . " " . $sender['user_lastname'];
      }
    }
    /* get receiver user */
    $get_receiver = $db->query(sprintf("SELECT * FROM users WHERE user_id = %s", secure($to_user_id, 'int')));
    if ($get_receiver->num_rows == 0) {
      return;
    }
    /* insert notification */
    $db->query(sprintf("INSERT INTO notifications (to_user_id, from_user_id, from_user_type, action, node_type, node_url, notify_id, message, time) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)", secure($to_user_id, 'int'), secure($from_user_id, 'int'), secure($from_user_type), secure($action), secure($node_type), secure($node_url), secure($notify_id), secure($message), secure($date)));
    /* update notifications counter +1 */
    if ($action != "chat_message") {
      $db->query(sprintf("UPDATE users SET user_live_notifications_counter = user_live_notifications_counter + 1 WHERE user_id = %s", secure($to_user_id, 'int')));
    }
    if ($system['onesignal_notification_enabled'] || $system['onesignal_messenger_notification_enabled'] || $system['onesignal_timeline_notification_enabled'] || $system['email_notifications']) {
      /* prepare receiver */
      $receiver = $get_receiver->fetch_assoc();
      $receiver['name'] = ($system['show_usernames_enabled']) ? $receiver['user_name'] : $receiver['user_firstname'] . " " . $receiver['user_lastname'];
      /* set notification language to receiver's language */
      if ($receiver['user_language'] != DEFAULT_LOCALE) {
        $gettextTranslator = $gettextLoader->loadFile(ABSPATH . 'content/languages/locale/' . $receiver['user_language'] . '/LC_MESSAGES/messages.po');
      }
      /* prepare notification notify_id */
      $notify_id = ($notify_id) ? "?notify_id=" . $notify_id : "";
      /* prepare notification node_url */
      if (strpos($node_url, "-[guid=]") !== false) {
        /* Note: GUID in node_url to make the notification record unique */
        $node_url = explode("-[guid=]", $node_url)[0];
      }
    }
    /* onesignal push notifications */
    if ($system['onesignal_notification_enabled'] || $system['onesignal_messenger_notification_enabled'] || $system['onesignal_timeline_notification_enabled']) {
      /* parse notification */
      switch ($action) {
        case 'mass_notification':
          $notification['url'] = $control_panel['url'] . '/mass_notifications';
          $notification['message'] = __("sent new mass notification");
          break;

        case 'friend_add':
          $notification['url'] = $system['system_url'] . '/' . $node_url;
          $notification['message'] = __("sent you a friend request");
          break;

        case 'friend_accept':
          $notification['url'] = $system['system_url'] . '/' . $node_url;
          $notification['message'] = __("accepted your friend request");
          break;

        case 'follow':
          $notification['url'] = $system['system_url'] . '/' . $node_url;
          $notification['message'] = __("now following you");
          break;

        case 'poke':
          $notification['url'] = $system['system_url'] . '/' . $node_url;
          $notification['message'] = __("poked you");
          break;

        case 'gift':
          $notification['url'] = $system['system_url'] . '/' . $this->_data['user_name'] . '?gift=' . $node_url;
          $notification['message'] = __("Sent you a gift");
          break;

        case 'subscribe_user':
        case 'subscribe_profile':
          $notification['url'] = $system['system_url'] . '/' . $node_url;
          $notification['message'] = __("subscribed to your profile");
          break;

        case 'subscribe_page':
          $notification['url'] = $system['system_url'] . '/pages/' . $node_url;
          $notification['message'] = __("subscribed to your page");
          break;

        case 'subscribe_group':
          $notification['url'] = $system['system_url'] . '/groups/' . $node_url;
          $notification['message'] = __("subscribed to your group");
          break;

        case 'paid_post':
          $notification['url'] = $system['system_url'] . '/posts/' . $node_url;
          $notification['message'] = __("paid to see your post");
          break;

        case 'react_like':
        case 'react_love':
        case 'react_haha':
        case 'react_yay':
        case 'react_wow':
        case 'react_sad':
        case 'react_angry':
          if ($node_type == "post") {
            $notification['url'] = $system['system_url'] . '/posts/' . $node_url;
            $notification['message'] = __("reacted to your post");
          } elseif ($node_type == "photo") {
            $notification['url'] = $system['system_url'] . '/photos/' . $node_url;
            $notification['message'] = __("reacted to your photo");
          } elseif ($node_type == "post_comment") {
            $notification['url'] = $system['system_url'] . '/posts/' . $node_url . $notify_id;
            $notification['message'] = __("reacted to your comment");
          } elseif ($node_type == "photo_comment") {
            $notification['url'] = $system['system_url'] . '/photos/' . $node_url . $notify_id;
            $notification['message'] = __("reacted to your comment");
          } elseif ($node_type == "post_reply") {
            $notification['url'] = $system['system_url'] . '/posts/' . $node_url . $notify_id;
            $notification['message'] = __("reacted to your reply");
          } elseif ($node_type == "photo_reply") {
            $notification['url'] = $system['system_url'] . '/photos/' . $node_url . $notify_id;
            $notification['message'] = __("reacted to your reply");
          }
          break;

        case 'comment':
          if ($node_type == "post") {
            $notification['url'] = $system['system_url'] . '/posts/' . $node_url . $notify_id;
            $notification['message'] = __("commented on your post");
          } elseif ($node_type == "photo") {
            $notification['url'] = $system['system_url'] . '/photos/' . $node_url . $notify_id;
            $notification['message'] = __("commented on your photo");
          }
          break;

        case 'reply':
          if ($node_type == "post") {
            $notification['url'] = $system['system_url'] . '/posts/' . $node_url . $notify_id;
          } elseif ($node_type == "photo") {
            $notification['url'] = $system['system_url'] . '/photos/' . $node_url . $notify_id;
          }
          $notification['message'] = __("replied to your comment");
          break;

        case 'share':
          $notification['url'] = $system['system_url'] . '/posts/' . $node_url;
          $notification['message'] = __("shared your post");
          break;

        case 'vote':
          $notification['url'] = $system['system_url'] . '/posts/' . $node_url;
          $notification['message'] = __("voted on your poll");
          break;

        case 'mention':
          switch ($node_type) {
            case 'post':
              $notification['url'] = $system['system_url'] . '/posts/' . $node_url;
              $notification['message'] = __("mentioned you in a post");
              break;

            case 'comment_post':
              $notification['url'] = $system['system_url'] . '/posts/' . $node_url . $notify_id;
              $notification['message'] = __("mentioned you in a comment");
              break;

            case 'comment_photo':
              $notification['url'] = $system['system_url'] . '/photos/' . $node_url . $notify_id;
              $notification['message'] = __("mentioned you in a comment");
              break;

            case 'reply_post':
              $notification['url'] = $system['system_url'] . '/posts/' . $node_url . $notify_id;
              $notification['message'] = __("mentioned you in a reply");
              break;

            case 'reply_photo':
              $notification['url'] = $system['system_url'] . '/photos/' . $node_url . $notify_id;
              $notification['message'] = __("mentioned you in a reply");
              break;
          }
          break;

        case 'profile_visit':
          $notification['url'] = $system['system_url'] . '/' . $this->_data['user_name'];
          $notification['message'] = __("visited your profile");
          break;

        case 'wall':
          $notification['url'] = $system['system_url'] . '/posts/' . $node_url;
          $notification['message'] = __("posted on your wall");
          break;

        case 'page_invitation':
          $notification['url'] = $system['system_url'] . '/pages/' . $node_url;
          $notification['message'] = __("invite you to like a page") . " '" . html_entity_decode($node_type, ENT_QUOTES) . "'";
          break;

        case 'page_admin_addation':
          $notification['url'] = $system['system_url'] . '/pages/' . $node_url;
          $notification['message'] = __("added you as admin to") . " '" . html_entity_decode($node_type, ENT_QUOTES) . "' " . __("page");
          break;

        case 'page_event':
          $notification['url'] = $system['system_url'] . '/events/' . $node_url;
          $notification['message'] = __("created new event");
          break;

        case 'group_join':
          $notification['url'] = $system['system_url'] . '/groups/' . $node_url . '/settings/requests';
          $notification['message'] = __("asked to join your group") . " '" . html_entity_decode($node_type, ENT_QUOTES) . "'";
          break;

        case 'group_add':
          $notification['url'] = $system['system_url'] . '/groups/' . $node_url;
          $notification['message'] = __("added you to") . " '" . html_entity_decode($node_type, ENT_QUOTES) . "' " . __("group");
          break;

        case 'group_accept':
          $notification['url'] = $system['system_url'] . '/groups/' . $node_url;
          $notification['message'] = __("accepted your request to join") . " '" . html_entity_decode($node_type, ENT_QUOTES) . "' " . __("group");
          break;

        case 'group_invitation':
          $notification['url'] = $system['system_url'] . '/groups/' . $node_url;
          $notification['message'] = __("invite you to join a group") . " '" . html_entity_decode($node_type, ENT_QUOTES) . "'";
          break;

        case 'group_admin_addation':
          $notification['url'] = $system['system_url'] . '/groups/' . $node_url;
          $notification['message'] = __("added you as admin to") . " '" . html_entity_decode($node_type, ENT_QUOTES) . "' " . __("group");
          break;

        case 'group_post_pending':
          $notification['url'] = $system['system_url'] . '/groups/' . $node_url . '?pending';
          $notification['message'] = __("added pending post in your group") . " '" . html_entity_decode($node_type, ENT_QUOTES) . "'";
          break;

        case 'group_post_approval':
          $notification['url'] = $system['system_url'] . '/groups/' . $node_url;
          $notification['message'] = __("approved your your pending post in group") . " '" . html_entity_decode($node_type, ENT_QUOTES) . "'";
          break;

        case 'event_invitation':
          $notification['url'] = $system['system_url'] . '/events/' . $node_url;
          $notification['message'] = __("invite you to join an event") . " '" . html_entity_decode($node_type, ENT_QUOTES) . "'";
          break;

        case 'event_post_pending':
          $notification['url'] = $system['system_url'] . '/events/' . $node_url . '?pending';
          $notification['message'] = __("added pending post in your event") . " '" . html_entity_decode($node_type, ENT_QUOTES) . "'";
          break;

        case 'event_post_approval':
          $notification['url'] = $system['system_url'] . '/events/' . $node_url;
          $notification['message'] = __("approved your your pending post in event") . " '" . html_entity_decode($node_type, ENT_QUOTES) . "'";
          break;

        case 'forum_reply':
          $notification['url'] = $system['system_url'] . '/forums/thread/' . $node_url;
          $notification['message'] = __("replied to your thread");
          break;

        case 'money_sent':
          $notification['url'] = $system['system_url'] . '/wallet';
          $notification['message'] = __("sent you") . " " . print_money($node_type);
          break;

        case 'tip_sent':
          $notification['url'] = $system['system_url'] . '/wallet';
          $notification['message'] = __("Tip you with") . " " . print_money($node_type);
          break;

        case 'coinpayments_complete':
          $notification['url'] = $system['system_url'] . '/settings/coinpayments';
          $notification['message'] = __("Your CoinPayments transaction complete successfully");
          break;

        case 'bank_transfer':
          $notification['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/bank';
          $notification['message'] = __("Sent new bank transfer");
          break;

        case 'bank_transfer_approved':
          $notification['url'] = $system['system_url'] . '/settings/bank';
          $notification['message'] = __("Approved your bank transfer");
          break;

        case 'bank_transfer_declined':
          $notification['url'] = $system['system_url'] . '/settings/bank';
          $notification['message'] = __("Declined your bank transfer");
          break;

        case 'wallet_withdrawal':
          $notification['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/wallet/payments';
          $notification['message'] = __("Sent new wallet withdrawal request");
          break;

        case 'wallet_withdrawal_approved':
          $notification['url'] = $system['system_url'] . '/wallet/payments';
          $notification['message'] = __("Approved your wallet withdrawal request");
          break;

        case 'wallet_withdrawal_declined':
          $notification['url'] = $system['system_url'] . '/wallet/payments';
          $notification['message'] = __("Declined your wallet withdrawal request");
          break;

        case 'affiliates_withdrawal':
          $notification['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/affiliates/payments';
          $notification['message'] = __("Sent new affiliates withdrawal request");
          break;

        case 'affiliates_withdrawal_approved':
          $notification['url'] = $system['system_url'] . '/settings/affiliates/payments';
          $notification['message'] = __("Approved your affiliates withdrawal request");
          break;

        case 'affiliates_withdrawal_declined':
          $notification['url'] = $system['system_url'] . '/settings/affiliates/payments';
          $notification['message'] = __("Declined your affiliates withdrawal request");
          break;

        case 'points_withdrawal':
          $notification['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/points/payments';
          $notification['message'] = __("Sent new points withdrawal request");
          break;

        case 'points_withdrawal_approved':
          $notification['url'] = $system['system_url'] . '/settings/points/payments';
          $notification['message'] = __("Approved your points withdrawal request");
          break;

        case 'points_withdrawal_declined':
          $notification['url'] = $system['system_url'] . '/settings/points/payments';
          $notification['message'] = __("Declined your points withdrawal request");
          break;

        case 'market_withdrawal':
          $notification['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/market/payments';
          $notification['message'] = __("Sent new market withdrawal request");
          break;

        case 'market_withdrawal_approved':
          $notification['url'] = $system['system_url'] . '/settings/market';
          $notification['message'] = __("Approved your market withdrawal request");
          break;

        case 'market_withdrawal_declined':
          $notification['url'] = $system['system_url'] . '/settings/market';
          $notification['message'] = __("Declined your market withdrawal request");
          break;

        case 'market_outofstock':
          $notification['url'] = $system['system_url'] . '/posts/' . $node_url;
          $notification['message'] = __("Your product is out of stock");
          break;

        case 'market_order':
          $notification['url'] = $system['system_url'] . '/market/sales?query=' . $node_url;
          $notification['message'] = __("You got new order");
          break;

        case 'market_order_tracking_updated':
          $notification['url'] = $system['system_url'] . '/market/orders?query=' . $node_url;
          $notification['message'] = __("Your order tracking updated");
          break;

        case 'market_order_status_updated':
          $notification['url'] = $system['system_url'] . '/market/orders?query=' . $node_url;
          $notification['message'] = __("Your order status updated");
          break;

        case 'market_order_delivered':
          $notification['url'] = $system['system_url'] . '/market/sales?query=' . $node_url;
          $notification['message'] = __("Your order delivered");
          break;

        case 'market_order_delivered_seller_system':
          $notification['url'] = $system['system_url'] . '/market/sales?query=' . $node_url;
          $notification['message'] = __("Your order delivered automatically");
          break;

        case 'market_order_delivered_buyer_system':
          $notification['url'] = $system['system_url'] . '/market/orders?query=' . $node_url;
          $notification['message'] = __("Your order delivered automatically");
          break;

        case 'job_application':
          $notification['url'] = $system['system_url'] . '/posts/' . $node_url;
          $notification['message'] = __("applied to your job");
          break;

        case 'course_application':
          $notification['url'] = $system['system_url'] . '/posts/' . $node_url;
          $notification['message'] = __("enrolled to your course");
          break;

        case 'funding_withdrawal':
          $notification['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/funding/payments';
          $notification['message'] = __("Sent new funding withdrawal request");
          break;

        case 'funding_withdrawal_approved':
          $notification['url'] = $system['system_url'] . '/settings/funding';
          $notification['message'] = __("Approved your funding withdrawal request");
          break;

        case 'funding_withdrawal_declined':
          $notification['url'] = $system['system_url'] . '/settings/funding';
          $notification['message'] = __("Declined your funding withdrawal request");
          break;

        case 'funding_donation':
          $notification['url'] = $system['system_url'] . '/posts/' . $node_url;
          $notification['message'] = __("donated to your funding request with") . " " . print_money($node_type);
          break;

        case 'monetization_withdrawal':
          $notification['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/monetization/payments';
          $notification['message'] = __("Sent new monetization withdrawal request");
          break;

        case 'monetization_withdrawal_approved':
          $notification['url'] = $system['system_url'] . '/settings/monetization';
          $notification['message'] = __("Approved your monetization withdrawal request");
          break;

        case 'monetization_withdrawal_declined':
          $notification['url'] = $system['system_url'] . '/settings/monetization';
          $notification['message'] = __("Declined your monetization withdrawal request");
          break;

        case 'ads_campaign_added':
          $notification['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/ads';
          $notification['message'] = __("Added new ads campaign");
          break;

        case 'ads_campaign_edited':
          $notification['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/ads';
          $notification['message'] = __("Edited ads campaign");
          break;

        case 'ads_campaign_approved':
          $notification['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/ads';
          $notification['message'] = __("Approved ads campaign");
          break;

        case 'ads_campaign_declined':
          $notification['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/ads';
          $notification['message'] = __("Declined your ads campaign");
          break;

        case 'report':
          $notification['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/reports';
          $notification['message'] = __("reported new content");
          break;

        case 'verification_request':
          $notification['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/verification';
          $notification['message'] = __("sent new verification request");
          break;
        case 'verification_request_approved':
          $notification['url'] = $system['system_url'] . '/settings/verification';
          $notification['message'] = __("Your verification request has been approved");
          break;
        case 'verification_request_declined':
          $notification['url'] = $system['system_url'] . '/settings/verification';
          $notification['message'] = __("Your verification request has been declined");
          break;
        case 'verification_request_page_approved':
          $notification['url'] = $system['system_url'] . '/pages/' . $node_url . '/settings/verification';
          $notification['message'] = __("Your page verification request has been approved");
          break;
        case 'verification_request_page_declined':
          $notification['url'] = $system['system_url'] . '/pages/' . $node_url . '/settings/verification';
          $notification['message'] = __("Your page verification request has been declined");
          break;
        case 'live_stream':
          $notification['url'] = $system['system_url'] . '/posts/' . $node_url;
          $notification['message'] = __("is live now");
          break;

        case 'async_request':
          $notification['url'] = $system['system_url'] . '/' . $control_panel['url'];
          $notification['message'] = $message;
          break;

        case 'video_converted':
          $notification['url'] = $system['system_url'] . '/posts/' . $node_url;
          $notification['message'] = __("Your video has been converted");
          break;

        case 'page_review':
          $notification['url'] = $system['system_url'] . '/pages/' . $node_url;
          $notification['message'] = __("reviewed your page");
          break;

        case 'page_review_reply':
          $notification['url'] = $system['system_url'] . '/pages/' . $node_url;
          $notification['message'] = __("replied to your review");
          break;

        case 'group_review':
          $notification['url'] = $system['system_url'] . '/groups/' . $node_url;
          $notification['message'] = __("reviewed your group");
          break;

        case 'group_review_reply':
          $notification['url'] = $system['system_url'] . '/groups/' . $node_url;
          $notification['message'] = __("replied to your review");
          break;

        case 'event_review':
          $notification['url'] = $system['system_url'] . '/events/' . $node_url;
          $notification['message'] = __("reviewed your event");
          break;

        case 'event_review_reply':
          $notification['url'] = $system['system_url'] . '/events/' . $node_url;
          $notification['message'] = __("replied to your review");
          break;

        case 'post_review':
          $notification['url'] = $system['system_url'] . '/posts/' . $node_url;
          $notification['message'] = __("reviewed your post");
          break;

        case 'post_review_reply':
          $notification['url'] = $system['system_url'] . '/posts/' . $node_url;
          $notification['message'] = __("replied to your review");
          break;

        case 'pending_post':
          $notification['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/posts/pending';
          $notification['message'] = __("sent new post for approval");
          break;

        case 'pending_post_approved':
          $notification['url'] = $system['system_url'] . '/posts/' . $node_url;
          $notification['message'] = __("Your post has been approved");
          break;

        case 'pending_user':
          $notification['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/users/pending';
          $notification['message'] = __("his account is pending approval");
          break;

        case 'pending_user_approved':
          $notification['url'] = $system['system_url'];
          $notification['message'] = __("Your account has been approved");
          break;

        case 'pending_payment_approved':
          $notification['url'] = $system['system_url'] . $node_url;
          $notification['message'] = __("Your pending payment has been approved");
          break;

        case 'chat_message_paid':
          $notification['url'] = $system['system_url'] . '/messages';
          $notification['message'] = __("sent you a paid message");
          break;

        case 'chat_message':
          $notification['url'] = $system['system_url'] . '/messages/' . $node_url;
          $notification['message'] = $message;
          break;

        case 'merit_received':
          $notification['url'] = $system['system_url'] . '/posts/' . $node_url;
          $notification['message'] = __("sent you a merit");
          break;

        case 'merit_sent':
          $notification['url'] = $system['system_url'];
          $notification['message'] = __("Your merit has been sent");
          break;

        case 'merits_reminder':
          $notification['url'] = $system['system_url'];
          $notification['message'] = __("You still have ") . $node_url . __(" merits to send");
          break;
      }
      /* prepare notification for web */
      $notification['full_message'] = html_entity_decode($this->_data['user_fullname'], ENT_QUOTES) . " " . html_entity_decode($notification['message'], ENT_QUOTES);
      /* prepare notification for mobile apps */
      $notification_mobile = $notification;
      $notification_mobile['headings'] = $this->_data['user_fullname'];
      $notification_mobile['full_message'] = $notification_mobile['message'];
      /* onesignal push notifications */
      $get_sessions = $db->query(sprintf("SELECT * FROM users_sessions WHERE user_id = %s AND (session_onesignal_user_id IS NOT NULL OR session_onesignal_user_id != '')", secure($receiver['user_id'], 'int')));
      while ($session = $get_sessions->fetch_assoc()) {
        if ($session['session_onesignal_user_id']) {
          if ($session['session_type'] == 'W') {
            onesignal_notification($session['session_onesignal_user_id'], $notification, 'web');
          } else {
            onesignal_notification($session['session_onesignal_user_id'], $notification_mobile, 'web-view');
            onesignal_notification($session['session_onesignal_user_id'], $notification_mobile, 'timeline');
            if ($action == 'chat_message') {
              onesignal_notification($session['session_onesignal_user_id'], $notification_mobile, 'messenger');
            }
          }
        }
      }
    }
    /* email notifications */
    if ($system['email_notifications']) {
      /* parse notification */
      switch ($action) {
        case 'friend_add':
          if (!$system['email_friend_requests'] || !$receiver['email_friend_requests']) {
            return;
          }
          $notification['url'] = $system['system_url'] . '/' . $node_url;
          $notification['message'] = __("sent you a friend request");
          break;

        case 'friend_accept':
          if (!$system['email_friend_requests'] || !$receiver['email_friend_requests']) {
            return;
          }
          $notification['url'] = $system['system_url'] . '/' . $node_url;
          $notification['message'] = __("accepted your friend request");
          break;

        case 'react_like':
        case 'react_love':
        case 'react_haha':
        case 'react_yay':
        case 'react_wow':
        case 'react_sad':
        case 'react_angry':
          if (!$system['email_post_likes'] || !$receiver['email_post_likes']) {
            return;
          }
          if ($node_type == "post") {
            $notification['url'] = $system['system_url'] . '/posts/' . $node_url;
            $notification['message'] = __("reacted to your post");
          } elseif ($node_type == "photo") {
            $notification['url'] = $system['system_url'] . '/photos/' . $node_url;
            $notification['message'] = __("reacted to your photo");
          } elseif ($node_type == "post_comment") {
            $notification['url'] = $system['system_url'] . '/posts/' . $node_url . $notify_id;
            $notification['message'] = __("reacted to your comment");
          } elseif ($node_type == "photo_comment") {
            $notification['url'] = $system['system_url'] . '/photos/' . $node_url . $notify_id;
            $notification['message'] = __("reacted to your comment");
          } elseif ($node_type == "post_reply") {
            $notification['url'] = $system['system_url'] . '/posts/' . $node_url . $notify_id;
            $notification['message'] = __("reacted to your reply");
          } elseif ($node_type == "photo_reply") {
            $notification['url'] = $system['system_url'] . '/photos/' . $node_url . $notify_id;
            $notification['message'] = __("reacted to your reply");
          }
          break;

        case 'comment':
          if (!$system['email_post_comments'] || !$receiver['email_post_comments']) {
            return;
          }
          if ($node_type == "post") {
            $notification['url'] = $system['system_url'] . '/posts/' . $node_url . $notify_id;
            $notification['message'] = __("commented on your post");
          } elseif ($node_type == "photo") {
            $notification['url'] = $system['system_url'] . '/photos/' . $node_url . $notify_id;
            $notification['message'] = __("commented on your photo");
          }
          break;

        case 'reply':
          if (!$system['email_post_comments'] || !$receiver['email_post_comments']) {
            return;
          }
          if ($node_type == "post") {
            $notification['url'] = $system['system_url'] . '/posts/' . $node_url . $notify_id;
          } elseif ($node_type == "photo") {
            $notification['url'] = $system['system_url'] . '/photos/' . $node_url . $notify_id;
          }
          $notification['message'] = __("replied to your comment");
          break;

        case 'share':
          if (!$system['email_post_shares'] || !$receiver['email_post_shares']) {
            return;
          }
          $notification['url'] = $system['system_url'] . '/posts/' . $node_url;
          $notification['message'] = __("shared your post");
          break;

        case 'mention':
          if (!$system['email_mentions'] || !$receiver['email_mentions']) {
            return;
          }
          switch ($node_type) {
            case 'post':
              $notification['url'] = $system['system_url'] . '/posts/' . $node_url;
              $notification['message'] = __("mentioned you in a post");
              break;

            case 'comment_post':
              $notification['url'] = $system['system_url'] . '/posts/' . $node_url . $notify_id;
              $notification['message'] = __("mentioned you in a comment");
              break;

            case 'comment_photo':
              $notification['url'] = $system['system_url'] . '/photos/' . $node_url . $notify_id;
              $notification['message'] = __("mentioned you in a comment");
              break;

            case 'reply_post':
              $notification['url'] = $system['system_url'] . '/posts/' . $node_url . $notify_id;
              $notification['message'] = __("mentioned you in a reply");
              break;

            case 'reply_photo':
              $notification['url'] = $system['system_url'] . '/photos/' . $node_url . $notify_id;
              $notification['message'] = __("mentioned you in a reply");
              break;
          }
          break;

        case 'profile_visit':
          if (!$system['email_profile_visits'] || !$receiver['email_profile_visits']) {
            return;
          }
          $notification['url'] = $system['system_url'] . '/' . $this->_data['user_name'];
          $notification['message'] = __("visited your profile");
          break;

        case 'wall':
          if (!$system['email_wall_posts'] || !$receiver['email_wall_posts']) {
            return;
          }
          $notification['url'] = $system['system_url'] . '/posts/' . $node_url;
          $notification['message'] = __("posted on your wall");
          break;

        case 'verification_request':
          if (!$system['email_admin_verifications'] || !$receiver['email_admin_verifications']) {
            return;
          }
          $notification['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/verification';
          $notification['message'] = __("sent new verification request");
          break;

        case 'verification_request_approved':
          if (!$system['email_user_verification'] || !$receiver['email_user_verification']) {
            return;
          }
          $notification['system_notification'] = true;
          $notification['url'] = $system['system_url'] . '/settings/verification';
          $notification['message'] = __("Your verification request has been approved");
          break;

        case 'verification_request_declined':
          if (!$system['email_user_verification'] || !$receiver['email_user_verification']) {
            return;
          }
          $notification['system_notification'] = true;
          $notification['url'] = $system['system_url'] . '/settings/verification';
          $notification['message'] = __("Your verification request has been declined");
          break;

        case 'verification_request_page_approved':
          if (!$system['email_user_verification'] || !$receiver['email_user_verification']) {
            return;
          }
          $notification['system_notification'] = true;
          $notification['url'] = $system['system_url'] . '/pages/' . $node_url . '/settings/verification';
          $notification['message'] = __("Your page verification request has been approved");
          break;

        case 'verification_request_page_declined':
          if (!$system['email_user_verification'] || !$receiver['email_user_verification']) {
            return;
          }
          $notification['system_notification'] = true;
          $notification['url'] = $system['system_url'] . '/pages/' . $node_url . '/settings/verification';
          $notification['message'] = __("Your page verification request has been declined");
          break;

        case 'pending_post':
          if (!$system['email_admin_post_approval'] || !$receiver['email_admin_post_approval']) {
            return;
          }
          $notification['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/posts/pending';
          $notification['message'] = __("sent new post for approval");
          break;

        case 'pending_post_approved':
          if (!$system['email_user_post_approval'] || !$receiver['email_user_post_approval']) {
            return;
          }
          $notification['system_notification'] = true;
          $notification['url'] = $system['system_url'] . '/posts/' . $node_url;
          $notification['message'] = __("Your post has been approved");
          break;

        case 'pending_user':
          if (!$system['email_admin_user_approval'] || !$receiver['email_admin_user_approval']) {
            return;
          }
          $notification['url'] = $system['system_url'] . '/' . $control_panel['url'] . '/users/pending';
          $notification['message'] = __("his account is pending approval");
          break;

        case 'pending_user_approved':
          $notification['system_notification'] = true;
          $notification['url'] = $system['system_url'];
          $notification['message'] = __("Your account has been approved");
          break;

        default:
          return;
          break;
      }
      /* prepare notification email */
      $subject = __("Notification from") . " " . html_entity_decode(__($system['system_title']), ENT_QUOTES);
      $body = get_email_template("notification_email", $subject, ["receiver" => $receiver, "notification" => $notification]);
      /* send email */
      _email($receiver['user_email'], $subject, $body['html'], $body['plain']);
    }
  }


  /**
   * post_notification_async
   * 
   * @param string $message
   * @return void
   */
  public function post_notification_async($message)
  {
    $this->post_notification(['to_user_id' => $this->_data['user_id'], 'action' => "async_request", 'message' => $message]);
  }


  /**
   * post_mass_notification
   * 
   * @param string $url
   * @param string $message
   * @return void
   */
  public function post_mass_notification($url, $message)
  {
    global $db, $date;
    /* insert notification */
    $db->query(sprintf("INSERT INTO notifications (to_user_id, from_user_id, action, node_type, node_url, message, time, seen) VALUES ('0', %s, 'mass_notification', 'notification', %s, %s, %s, '1')", secure($this->_data['user_id'], 'int'), secure($url), secure($message), secure($date)));
    /* update notifications counter +1 */
    $db->query(sprintf("UPDATE users SET user_live_notifications_counter = user_live_notifications_counter + 1"));
  }


  /**
   * delete_notification
   * 
   * @param integer $to_user_id
   * @param string $action
   * @param string $node_type
   * @param string $node_url
   * @return void
   */
  public function delete_notification($to_user_id, $action, $node_type = '', $node_url = '')
  {
    global $db;
    /* delete notification */
    $db->query(sprintf("DELETE FROM notifications WHERE to_user_id = %s AND from_user_id = %s AND action = %s AND node_type = %s AND node_url = %s", secure($to_user_id, 'int'), secure($this->_data['user_id'], 'int'), secure($action), secure($node_type), secure($node_url)));
    /* update notifications counter -1 */
    $db->query(sprintf("UPDATE users SET user_live_notifications_counter = IF(user_live_notifications_counter=0,0,user_live_notifications_counter-1) WHERE user_id = %s", secure($to_user_id, 'int')));
  }


  /**
   * notify_system_admins
   * 
   * @param string $action
   * @param boolean $notify_moderators
   * @return void
   */
  public function notify_system_admins($action, $notify_moderators = false, $from_user_id = null)
  {
    global $db;
    /* prepare */
    $from_user_id = ($from_user_id) ? $from_user_id : $this->_data['user_id'];
    /* get system admins */
    $where_query = ($notify_moderators) ? "user_group < 3" : "user_group = '1'";
    $get_system_admins = $db->query("SELECT user_id FROM users WHERE " . $where_query);
    if ($get_system_admins->num_rows == 0) {
      return;
    }
    while ($system_admin = $get_system_admins->fetch_assoc()) {
      /* post notification */
      $this->post_notification(['from_user_id' => $from_user_id, 'to_user_id' => $system_admin['user_id'], 'action' => $action]);
    }
  }


  /**
   * update_session_onesignal_id
   * 
   * @param string $onesignal_id
   * @param string $updated_session_type
   * @return void
   */
  public function update_session_onesignal_id($onesignal_id, $updated_session_type = null)
  {
    global $db;
    if ($updated_session_type) {
      $updated_session_query = sprintf(", session_type = %s", secure($updated_session_type));
    } else {
      $updated_session_query = "";
    }
    $db->query(sprintf("UPDATE users_sessions SET session_onesignal_user_id = %s " . $updated_session_query . " WHERE session_id = %s AND user_id = %s", secure($onesignal_id), secure($this->_data['session_id'], 'int'), secure($this->_data['user_id'], 'int')));
  }


  /**
   * delete_session_onesignal_id
   * 
   * @return void
   */
  public function delete_session_onesignal_id()
  {
    global $db;
    $db->query(sprintf("UPDATE users_sessions SET session_onesignal_user_id = '' WHERE session_id = %s AND user_id = %s", secure($this->_data['session_id'], 'int'), secure($this->_data['user_id'], 'int')));
  }
}
