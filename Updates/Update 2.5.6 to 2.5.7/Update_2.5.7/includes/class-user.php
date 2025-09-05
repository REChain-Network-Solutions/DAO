<?php
/**
 * class -> user
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich - Handles - @sorydima @sorydev @durovshater @DmitrySoro90935 @tanechfund - also check https://dmitry.rechain.network for more information!
 */

class User {

    public $_logged_in = false;
    public $_is_admin = false;
    public $_data = array();

    private $_cookie_user_id = "c_user";
    private $_cookie_user_token = "xs";
    private $_cookie_user_referrer = "ref";


    /* ------------------------------- */
    /* __construct */
    /* ------------------------------- */

    /**
     * __construct
     * 
     * @return void
     */
    public function __construct() {
        global $db, $system;
        if(isset($_COOKIE[$this->_cookie_user_id]) && isset($_COOKIE[$this->_cookie_user_token])) {
            $get_user = $db->query(sprintf("SELECT users.*, posts_photos.source as user_picture_full, packages.* FROM users INNER JOIN users_sessions ON users.user_id = users_sessions.user_id LEFT JOIN posts_photos ON users.user_picture_id = posts_photos.photo_id LEFT JOIN packages ON users.user_subscribed = '1' AND users.user_package = packages.package_id WHERE users_sessions.user_id = %s AND users_sessions.session_token = %s", secure($_COOKIE[$this->_cookie_user_id], 'int'), secure($_COOKIE[$this->_cookie_user_token]) )) or _error(SQL_ERROR_THROWEN);
            if($get_user->num_rows > 0) {
                $this->_data = $get_user->fetch_assoc();
                $this->_logged_in = true;
                $this->_is_admin = ($this->_data['user_group'] == 1)? true: false;
                /* update user last seen */
                $db->query(sprintf("UPDATE users SET user_last_seen = NOW() WHERE user_id = %s", secure($this->_data['user_id'], 'int'))) or _error(SQL_ERROR_THROWEN);
                /* active session */
                $this->_data['active_session'] = $_COOKIE[$this->_cookie_user_token];
                /* get user picture */
                $this->_data['user_picture_default'] = ($this->_data['user_picture'])? false : true;
                $this->_data['user_picture_raw'] = $this->_data['user_picture'];
                $this->_data['user_picture'] = get_picture($this->_data['user_picture'], $this->_data['user_gender']);
                $this->_data['user_picture_full'] = ($this->_data['user_picture_full'])? $system['system_uploads'].'/'.$this->_data['user_picture_full'] : $this->_data['user_picture_full'];
                /* get all friends ids */
                $this->_data['friends_ids'] = $this->get_friends_ids($this->_data['user_id']);
                /* get all followings ids */
                $this->_data['followings_ids'] = $this->get_followings_ids($this->_data['user_id']);
                /* get all friend requests ids */
                $this->_data['friend_requests_ids'] = $this->get_friend_requests_ids();
                /* get all friend requests sent ids */
                $this->_data['friend_requests_sent_ids'] = $this->get_friend_requests_sent_ids();
                /* get friend requests */
                $this->_data['friend_requests'] = $this->get_friend_requests();
                $this->_data['friend_requests_count'] = count($this->_data['friend_requests']);
                /* get friend requests sent */
                $this->_data['friend_requests_sent'] = $this->get_friend_requests_sent();
                $this->_data['friend_requests_sent_count'] = count($this->_data['friend_requests_sent']);
                /* get search log */
                $this->_data['search_log'] = $this->get_search_log();
                /* get new people */
                $this->_data['new_people'] = $this->get_new_people(0, true);
                /* get conversations */
                $this->_data['conversations'] = $this->get_conversations();
                /* get notifications */
                $this->_data['notifications'] = $this->get_notifications();
                /* can write articles */
                $this->_data['can_write_articles'] = false;
                if($system['blogs_enabled'] && ($this->_data['user_group'] < 3 || $system['users_blogs_enabled'])) {
                    $this->_data['can_write_articles'] = true;
                }
                /* get package */
                $this->_data['can_boost_posts'] = false;
                $this->_data['can_boost_pages'] = false;
                if($system['packages_enabled'] && ($this->_is_admin || $this->_data['user_subscribed'])) {
                    if($this->_is_admin || ($this->_data['boost_posts_enabled'] && ($this->_data['user_boosted_posts'] < $this->_data['boost_posts'])) ) {
                        $this->_data['can_boost_posts'] = true;
                    }
                    if($this->_is_admin || ($this->_data['boost_pages_enabled'] && ($this->_data['user_boosted_pages'] < $this->_data['boost_pages'])) ) {
                        $this->_data['can_boost_pages'] = true;
                    }
                }
            }
        }
    }


    /* ------------------------------- */
    /* Get Countries */
    /* ------------------------------- */

    /**
     * get_countries
     * 
     * @return array
     */
    public function get_countries() {
        global $db, $system;
        $countries = array();
        $get_countries = $db->query("SELECT * FROM system_countries") or _error(SQL_ERROR_THROWEN);
        if($get_countries->num_rows > 0) {
            while($country = $get_countries->fetch_assoc()) {
                $countries[] = $country;
            }
        }
        return $countries;
    }


    /* ------------------------------- */
    /* Get Ids */
    /* ------------------------------- */

    /**
     * get_friends_ids
     * 
     * @param integer $user_id
     * @return array
     */
    public function get_friends_ids($user_id) {
        global $db;
        $friends = array();
        $get_friends = $db->query(sprintf('SELECT users.user_id FROM friends INNER JOIN users ON (friends.user_one_id = users.user_id AND friends.user_one_id != %1$s) OR (friends.user_two_id = users.user_id AND friends.user_two_id != %1$s) WHERE status = 1 AND (user_one_id = %1$s OR user_two_id = %1$s)', secure($user_id, 'int'))) or _error(SQL_ERROR_THROWEN);
        if($get_friends->num_rows > 0) {
            while($friend = $get_friends->fetch_assoc()) {
                $friends[] = $friend['user_id'];
            }
        }
        return $friends;
    }


    /**
     * get_followings_ids
     * 
     * @param integer $user_id
     * @return array
     */
    public function get_followings_ids($user_id) {
        global $db;
        $followings = array();
        $get_followings = $db->query(sprintf("SELECT following_id FROM followings WHERE user_id = %s", secure($user_id, 'int'))) or _error(SQL_ERROR_THROWEN);
        if($get_followings->num_rows > 0) {
            while($following = $get_followings->fetch_assoc()) {
                $followings[] = $following['following_id'];
            }
        }
        return $followings;
    }


    /**
     * get_followers_ids
     * 
     * @param integer $user_id
     * @return array
     */
    public function get_followers_ids($user_id) {
        global $db;
        $followers = array();
        $get_followers = $db->query(sprintf("SELECT user_id FROM followings WHERE following_id = %s", secure($user_id, 'int'))) or _error(SQL_ERROR_THROWEN);
        if($get_followers->num_rows > 0) {
            while($follower = $get_followers->fetch_assoc()) {
                $followers[] = $follower['user_id'];
            }
        }
        return $followers;
    }


    /**
     * get_blocked_ids
     * 
     * @param integer $user_id
     * @return array
     */
    public function get_blocked_ids($user_id) {
        global $db, $system;
        $blocks = array();
        $get_blocks = $db->query(sprintf('SELECT blocked_id FROM users_blocks WHERE user_id = %s', secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
        if($get_blocks->num_rows > 0) {
            while($block = $get_blocks->fetch_assoc()) {
                $blocks[] = $block['blocked_id'];
            }
        }
        return $blocks;
    }


    /**
     * get_friend_requests_ids
     * 
     * @return array
     */
    public function get_friend_requests_ids() {
        global $db;
        $requests = array();
        $get_requests = $db->query(sprintf("SELECT user_one_id FROM friends WHERE status = 0 AND user_two_id = %s", secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
        if($get_requests->num_rows > 0) {
            while($request = $get_requests->fetch_assoc()) {
                $requests[] = $request['user_one_id'];
            }
        }
        return $requests;
    }


    /**
     * get_friend_requests_sent_ids
     * 
     * @return array
     */
    public function get_friend_requests_sent_ids() {
        global $db;
        $requests = array();
        $get_requests = $db->query(sprintf("SELECT user_two_id FROM friends WHERE status = 0 AND user_one_id = %s", secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
        if($get_requests->num_rows > 0) {
            while($request = $get_requests->fetch_assoc()) {
                $requests[] = $request['user_two_id'];
            }
        }
        return $requests;
    }


    /**
     * get_pages_ids
     * 
     * @return array
     */
    public function get_pages_ids() {
        global $db;
        $pages = array();
        if($this->_logged_in) {
            $get_pages = $db->query(sprintf("SELECT page_id FROM pages_likes WHERE user_id = %s", secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
            if($get_pages->num_rows > 0) {
                while($page = $get_pages->fetch_assoc()) {
                    $pages[] = $page['page_id'];
                }
            }
        }
        return $pages;
    }


    /**
     * get_groups_ids
     * 
     * @param boolean $only_approved
     * @return array
     */
    public function get_groups_ids($only_approved = false) {
        global $db;
        $groups = array();
        if($only_approved) {
            $get_groups = $db->query(sprintf("SELECT group_id FROM groups_members WHERE approved = '1' AND user_id = %s", secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
        } else {
            $get_groups = $db->query(sprintf("SELECT group_id FROM groups_members WHERE user_id = %s", secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
        }
        
        if($get_groups->num_rows > 0) {
            while($group = $get_groups->fetch_assoc()) {
                $groups[] = $group['group_id'];
            }
        }
        return $groups;
    }


    /**
     * get_events_ids
     * 
     * @return array
     */
    public function get_events_ids() {
        global $db;
        $events = array();
        $get_events = $db->query(sprintf("SELECT event_id FROM events_members WHERE user_id = %s", secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
        if($get_events->num_rows > 0) {
            while($event = $get_events->fetch_assoc()) {
                $events[] = $event['event_id'];
            }
        }
        return $events;
    }



    /* ------------------------------- */
    /* Get Users */
    /* ------------------------------- */

    /**
     * get_friends
     * 
     * @param integer $user_id
     * @param integer $offset
     * @return array
     */
    public function get_friends($user_id, $offset = 0) {
        global $db, $system;
        $friends = array();
        $offset *= $system['min_results_even'];
        /* get the target user's privacy */
        $get_privacy = $db->query(sprintf("SELECT user_privacy_friends FROM users WHERE user_id = %s", secure($user_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        $privacy = $get_privacy->fetch_assoc();
        /* check the target user's privacy  */
        if(!$this->_check_privacy($privacy['user_privacy_friends'], $user_id)) {
            return $friends;
        }
        $get_friends = $db->query(sprintf('SELECT users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM friends INNER JOIN users ON (friends.user_one_id = users.user_id AND friends.user_one_id != %1$s) OR (friends.user_two_id = users.user_id AND friends.user_two_id != %1$s) WHERE status = 1 AND (user_one_id = %1$s OR user_two_id = %1$s) LIMIT %2$s, %3$s', secure($user_id, 'int'), secure($offset, 'int', false), secure($system['min_results_even'], 'int', false) )) or _error(SQL_ERROR_THROWEN);
        if($get_friends->num_rows > 0) {
            while($friend = $get_friends->fetch_assoc()) {
                $friend['user_picture'] = get_picture($friend['user_picture'], $friend['user_gender']);
                /* get the connection between the viewer & the target */
                $friend['connection'] = $this->connection($friend['user_id']);
                $friends[] = $friend;
            }
        }
        return $friends;
    }


    /**
     * get_followings
     * 
     * @param integer $user_id
     * @param integer $offset
     * @return array
     */
    public function get_followings($user_id, $offset = 0) {
        global $db, $system;
        $followings = array();
        $offset *= $system['min_results_even'];
        $get_followings = $db->query(sprintf('SELECT users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM followings INNER JOIN users ON (followings.following_id = users.user_id) WHERE followings.user_id = %s LIMIT %s, %s', secure($user_id, 'int'), secure($offset, 'int', false), secure($system['min_results_even'], 'int', false) )) or _error(SQL_ERROR_THROWEN);
        if($get_followings->num_rows > 0) {
            while($following = $get_followings->fetch_assoc()) {
                $following['user_picture'] = get_picture($following['user_picture'], $following['user_gender']);
                /* get the connection between the viewer & the target */
                $following['connection'] = $this->connection($following['user_id'], false);
                $followings[] = $following;
            }
        }
        return $followings;
    }


    /**
     * get_followers
     * 
     * @param integer $user_id
     * @param integer $offset
     * @return array
     */
    public function get_followers($user_id, $offset = 0) {
        global $db, $system;
        $followers = array();
        $offset *= $system['min_results_even'];
        $get_followers = $db->query(sprintf('SELECT users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM followings INNER JOIN users ON (followings.user_id = users.user_id) WHERE followings.following_id = %s LIMIT %s, %s', secure($user_id, 'int'), secure($offset, 'int', false), secure($system['min_results_even'], 'int', false) )) or _error(SQL_ERROR_THROWEN);
        if($get_followers->num_rows > 0) {
            while($follower = $get_followers->fetch_assoc()) {
                $follower['user_picture'] = get_picture($follower['user_picture'], $follower['user_gender']);
                /* get the connection between the viewer & the target */
                $follower['connection'] = $this->connection($follower['user_id'], false);
                $followers[] = $follower;
            }
        }
        return $followers;
    }


    /**
     * get_blocked
     * 
     * @param integer $offset
     * @return array
     */
    public function get_blocked($offset = 0) {
        global $db, $system;
        $blocks = array();
        $offset *= $system['max_results'];
        $get_blocks = $db->query(sprintf('SELECT users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM users_blocks INNER JOIN users ON users_blocks.blocked_id = users.user_id WHERE users_blocks.user_id = %s LIMIT %s, %s', secure($this->_data['user_id'], 'int'), secure($offset, 'int', false), secure($system['max_results'], 'int', false) )) or _error(SQL_ERROR_THROWEN);
        if($get_blocks->num_rows > 0) {
            while($block = $get_blocks->fetch_assoc()) {
                $block['user_picture'] = get_picture($block['user_picture'], $block['user_gender']);
                $block['connection'] = 'blocked';
                $blocks[] = $block;
            }
        }
        return $blocks;
    }


    /**
     * get_friend_requests
     * 
     * @param integer $offset
     * @param integer $last_request_id
     * @return array
     */
    public function get_friend_requests($offset = 0, $last_request_id = null) {
        global $db, $system;
        $requests = array();
        $offset *= $system['max_results'];
        if($last_request_id !== null) {
            $get_requests = $db->query(sprintf("SELECT friends.id, friends.user_one_id as user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM friends INNER JOIN users ON friends.user_one_id = users.user_id WHERE friends.status = 0 AND friends.user_two_id = %s AND friends.id > %s ORDER BY friends.id DESC", secure($this->_data['user_id'], 'int'), secure($last_request_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        } else {
            $get_requests = $db->query(sprintf("SELECT friends.id, friends.user_one_id as user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM friends INNER JOIN users ON friends.user_one_id = users.user_id WHERE friends.status = 0 AND friends.user_two_id = %s ORDER BY friends.id DESC LIMIT %s, %s", secure($this->_data['user_id'], 'int'), secure($offset, 'int', false), secure($system['max_results'], 'int', false) )) or _error(SQL_ERROR_THROWEN);
        }
        if($get_requests->num_rows > 0) {
            while($request = $get_requests->fetch_assoc()) {
                $request['user_picture'] = get_picture($request['user_picture'], $request['user_gender']);
                $request['mutual_friends_count'] = $this->get_mutual_friends_count($request['user_id']);
                $requests[] = $request;
            }
        }
        return $requests;
    }


    /**
     * get_friend_requests_sent
     * 
     * @param integer $offset
     * @return array
     */
    public function get_friend_requests_sent($offset = 0) {
        global $db, $system;
        $requests = array();
        $offset *= $system['max_results'];
        $get_requests = $db->query(sprintf("SELECT friends.user_two_id as user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM friends INNER JOIN users ON friends.user_two_id = users.user_id WHERE friends.status = 0 AND friends.user_one_id = %s LIMIT %s, %s", secure($this->_data['user_id'], 'int'), secure($offset, 'int', false), secure($system['max_results'], 'int', false) )) or _error(SQL_ERROR_THROWEN);
        if($get_requests->num_rows > 0) {
            while($request = $get_requests->fetch_assoc()) {
                $request['user_picture'] = get_picture($request['user_picture'], $request['user_gender']);
                $request['mutual_friends_count'] = $this->get_mutual_friends_count($request['user_id']);
                $requests[] = $request;
            }
        }
        return $requests;
    }


    /**
     * get_mutual_friends
     * 
     * @param integer $user_two_id
     * @param integer $offset
     * @return array
     */
    public function get_mutual_friends($user_two_id, $offset = 0) {
        global $db, $system;
        $mutual_friends = array();
        $offset *= $system['max_results'];
        $mutual_friends = array_intersect($this->_data['friends_ids'], $this->get_friends_ids($user_two_id));
        /* if there is no mutual friends -> return empty array */
        if(count($mutual_friends) == 0) {
            return $mutual_friends;
        }
        /* slice the mutual friends array with system max results */
        $mutual_friends = array_slice($mutual_friends, $offset, $system['max_results']);
        /* if there is no more mutual friends to show -> return empty array */
        if(count($mutual_friends) == 0) {
            return $mutual_friends;
        }
        /* make a list from mutual friends */
        $mutual_friends_list = implode(',',$mutual_friends);
        /* get the user data of each mutual friend */
        $mutual_friends = array();
        $get_mutual_friends = $db->query("SELECT * FROM users WHERE user_id IN ($mutual_friends_list)") or _error(SQL_ERROR_THROWEN);
        if($get_mutual_friends->num_rows > 0) {
            while($mutual_friend = $get_mutual_friends->fetch_assoc()) {
                $mutual_friend['user_picture'] = get_picture($mutual_friend['user_picture'], $mutual_friend['user_gender']);
                $mutual_friend['mutual_friends_count'] = $this->get_mutual_friends_count($mutual_friend['user_id']);
                $mutual_friends[] = $mutual_friend;
            }
        }
        return $mutual_friends;
    }


    /**
     * get_mutual_friends_count
     * 
     * @param integer $user_two_id
     * @return integer
     */
    public function get_mutual_friends_count($user_two_id) {
        return count(array_intersect($this->_data['friends_ids'], $this->get_friends_ids($user_two_id)));
    }


    /**
     * get_new_people
     * 
     * @param integer $offset
     * @param boolean $random
     * @return array
     */
    public function get_new_people($offset = 0, $random = false) {
        global $db, $system;
        $results = array();
        $offset *= $system['min_results'];
        $unit = 6371;
        $distance = 10000;
        // prepare where statement
        $where = "";
        /* merge (friends, followings, friend requests & friend requests sent) and get the unique ids  */
        $old_people_ids = array_unique(array_merge($this->_data['friends_ids'], $this->_data['followings_ids'], $this->_data['friend_requests_ids'], $this->_data['friend_requests_sent_ids']));
        /* add the viewer to this list */
        $old_people_ids[] = $this->_data['user_id'];
        /* make a list from old people */
        $old_people_ids_list = implode(',',$old_people_ids);
        $where .= sprintf("WHERE user_banned = '0' AND user_id NOT IN (%s)", $old_people_ids_list);
        if($system['activation_enabled']) {
            $where .= " AND user_activated = '1'";
        }
        /* get users */
        if($random) {
            $get_users = $db->query(sprintf("SELECT * FROM (SELECT *, (%s * acos(cos(radians(%s)) * cos(radians(user_latitude)) * cos(radians(user_longitude) - radians(%s)) + sin(radians(%s)) * sin(radians(user_latitude))) ) AS distance FROM users ".$where." HAVING distance < %s ORDER BY distance ASC LIMIT %s) tmp ORDER BY RAND() LIMIT %s", secure($unit, 'int'), secure($this->_data['user_latitude']), secure($this->_data['user_longitude']), secure($this->_data['user_latitude']), secure($distance, 'int'), secure($system['max_results']*2, 'int', false), secure($system['min_results'], 'int', false) )) or _error(SQL_ERROR_THROWEN);
        } else {
            $get_users = $db->query(sprintf("SELECT *, (%s * acos(cos(radians(%s)) * cos(radians(user_latitude)) * cos(radians(user_longitude) - radians(%s)) + sin(radians(%s)) * sin(radians(user_latitude))) ) AS distance FROM users ".$where." HAVING distance < %s ORDER BY distance ASC LIMIT %s, %s", secure($unit, 'int'), secure($this->_data['user_latitude']), secure($this->_data['user_longitude']), secure($this->_data['user_latitude']), secure($distance, 'int'), secure($offset, 'int', false), secure($system['min_results'], 'int', false) )) or _error(SQL_ERROR_THROWEN);
        }
        if($get_users->num_rows > 0) {
            while($user = $get_users->fetch_assoc()) {
                /* check if there is any blocking between the viewer & the target user */
                if($this->blocked($user['user_id']) ) {
                    continue;
                }
                $user['user_picture'] = get_picture($user['user_picture'], $user['user_gender']);
                $user['mutual_friends_count'] = $this->get_mutual_friends_count($user['user_id']);
                $results[] = $user;
            }
        }
        return $results;
    }


    /**
     * get_pro_members
     * 
     * @return array
     */
    public function get_pro_members() {
        global $db;
        $pro_members = array();
        $get_pro_members = $db->query("SELECT * FROM users WHERE user_subscribed = '1' ORDER BY RAND() LIMIT 3") or _error(SQL_ERROR_THROWEN);
        if($get_pro_members->num_rows > 0) {
            while($user = $get_pro_members->fetch_assoc()) {
                $user['user_picture'] = get_picture($user['user_picture'], $user['user_gender']);
                $user['mutual_friends_count'] = $this->get_mutual_friends_count($user['user_id']);
                $pro_members[] = $user;
            }
        }
        return $pro_members;
    }


    /**
     * get_users
     * 
     * @param string $query
     * @param array $skipped_array
     * @return array
     */
    public function get_users($query, $skipped_array = array()) {
        global $db, $system;
        $users = array();
        if($skipped_array) {
            /* make a skipped list (including the viewer) */
            $skipped_list = implode(',', $skipped_array);
            /* get users */
            $get_users = $db->query(sprintf('SELECT * FROM users WHERE user_id != %1$s AND user_id NOT IN (%2$s) AND (user_name LIKE %3$s OR user_firstname LIKE %3$s OR user_lastname LIKE %3$s OR CONCAT(user_firstname,  " ", user_lastname) LIKE %3$s) ORDER BY user_firstname ASC LIMIT %4$s', secure($this->_data['user_id'], 'int'), $skipped_list, secure($query, 'search'), secure($system['min_results'], 'int', false) )) or _error(SQL_ERROR_THROWEN);
        } else {
            /* get users */
            $get_users = $db->query(sprintf('SELECT * FROM users WHERE user_id != %1$s AND (user_name LIKE %2$s OR user_firstname LIKE %2$s OR user_lastname LIKE %2$s OR CONCAT(user_firstname,  " ", user_lastname) LIKE %2$s) ORDER BY user_firstname ASC LIMIT %3$s', secure($this->_data['user_id'], 'int'), secure($query, 'search'), secure($system['min_results'], 'int', false) )) or _error(SQL_ERROR_THROWEN);
        }
        if($get_users->num_rows > 0) {
            while($user = $get_users->fetch_assoc()) {
                /* check if there is any blocking between the viewer & the target user */
                if($this->blocked($user['user_id']) ) {
                    continue;
                }
                $user['user_picture'] = get_picture($user['user_picture'], $user['user_gender']);
                $users[] = $user;
            }
        }
        return $users;
    }


    /**
     * get_user
     * 
     * @param integer $user_id
     * @return array
     */
    public function get_user($user_id) {
        global $db, $system;
        $get_user = $db->query(sprintf("SELECT * FROM users WHERE user_id = %s", secure($user_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        if($get_user->num_rows == 0) {
            return false;
        }
        return $get_user->fetch_assoc();
    }


    
    /* ------------------------------- */
    /* Search */
    /* ------------------------------- */

    /**
     * search_quick
     * 
     * @param string $query
     * @return array
     */
    public function search_quick($query) {
        global $db, $system;
        $results = array();
        /* search users */
        $get_users = $db->query(sprintf('SELECT user_id, user_name, user_firstname, user_lastname, user_gender, user_picture, user_subscribed, user_verified FROM users WHERE user_name LIKE %1$s OR user_firstname LIKE %1$s OR user_lastname LIKE %1$s OR CONCAT(user_firstname,  " ", user_lastname) LIKE %1$s LIMIT %2$s', secure($query, 'search'), secure($system['min_results'], 'int', false) )) or _error(SQL_ERROR_THROWEN);
        if($get_users->num_rows > 0) {
            while($user = $get_users->fetch_assoc()) {
                $user['user_picture'] = get_picture($user['user_picture'], $user['user_gender']);
                /* get the connection between the viewer & the target */
                $user['connection'] = $this->connection($user['user_id']);
                $user['sort'] = $user['user_firstname'];
                $user['type'] = 'user';
                $results[] = $user;
            }
        }
        /* search pages */
        $get_pages = $db->query(sprintf('SELECT * FROM pages WHERE page_name LIKE %1$s OR page_title LIKE %1$s LIMIT %2$s', secure($query, 'search'), secure($system['min_results'], 'int', false) )) or _error(SQL_ERROR_THROWEN);
        if($get_pages->num_rows > 0) {
            while($page = $get_pages->fetch_assoc()) {
                $page['page_picture'] = get_picture($page['page_picture'], 'page');
                /* check if the viewer liked the page */
                $page['i_like'] = false;
                if($this->_logged_in) {
                    $get_likes = $db->query(sprintf("SELECT * FROM pages_likes WHERE page_id = %s AND user_id = %s", secure($page['page_id'], 'int'), secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                    if($get_likes->num_rows > 0) {
                        $page['i_like'] = true;
                    }
                }
                $page['sort'] = $page['page_title'];
                $page['type'] = 'page';
                $results[] = $page;
            }
        }
        /* search groups */
        $get_groups = $db->query(sprintf('SELECT * FROM groups WHERE group_privacy != "secret" AND (group_name LIKE %1$s OR group_title LIKE %1$s) LIMIT %2$s', secure($query, 'search'), secure($system['min_results'], 'int', false) )) or _error(SQL_ERROR_THROWEN);
        if($get_groups->num_rows > 0) {
            while($group = $get_groups->fetch_assoc()) {
                $group['group_picture'] = get_picture($group['group_picture'], 'group');
                /* check if the viewer joined the group */
                $group['i_joined'] = $this->check_group_membership($this->_data['user_id'], $group['group_id']);
                $group['sort'] = $group['group_title'];
                $group['type'] = 'group';
                $results[] = $group;
            }
        }
        /* search events */
        $get_events = $db->query(sprintf('SELECT * FROM events WHERE event_privacy != "secret" AND event_title LIKE %1$s LIMIT %2$s', secure($query, 'search'), secure($system['min_results'], 'int', false) )) or _error(SQL_ERROR_THROWEN);
        if($get_events->num_rows > 0) {
            while($event = $get_events->fetch_assoc()) {
                $event['event_picture'] = get_picture($event['event_cover'], 'event');
                /* check if the viewer joined the event */
                $event['i_joined'] = $this->check_event_membership($this->_data['user_id'], $event['event_id']);
                $event['sort'] = $event['event_title'];
                $event['type'] = 'event';
                $results[] = $event;
            }
        }
        /* sort results */
        function sort_results($a, $b){
            return strcmp($a["sort"], $b["sort"]);
        }
        usort($results, sort_results);
        return $results;
    }


    /**
     * search
     * 
     * @param string $query
     * @return array
     */
    public function search($query) {
        global $db, $system;
        $results = array();
        $offset *= $system['max_results'];
        /* search posts */
        $posts = $this->get_posts( array('query' => $query) );
        if(count($posts) > 0) {
            $results['posts'] = $posts;
        }
        /* search articles */
        $get_articles = $db->query(sprintf('SELECT post_id FROM posts_articles WHERE title LIKE %1$s OR text LIKE %1$s ORDER BY title ASC LIMIT %2$s, %3$s', secure($query, 'search'), secure($offset, 'int', false), secure($system['max_results'], 'int', false) )) or _error(SQL_ERROR_THROWEN);
        if($get_articles->num_rows > 0) {
            while($article = $get_articles->fetch_assoc()) {
                $article = $this->get_post($article['post_id']);
                if($article) {
                    $results['articles'][] = $article;
                }
            }
        }
        /* search users */
        $get_users = $db->query(sprintf('SELECT * FROM users WHERE user_name LIKE %1$s OR user_firstname LIKE %1$s OR user_lastname LIKE %1$s OR CONCAT(user_firstname,  " ", user_lastname) LIKE %1$s ORDER BY user_firstname ASC LIMIT %2$s, %3$s', secure($query, 'search'), secure($offset, 'int', false), secure($system['max_results'], 'int', false) )) or _error(SQL_ERROR_THROWEN);
        if($get_users->num_rows > 0) {
            while($user = $get_users->fetch_assoc()) {
                $user['user_picture'] = get_picture($user['user_picture'], $user['user_gender']);
                /* get the connection between the viewer & the target */
                $user['connection'] = $this->connection($user['user_id']);
                $results['users'][] = $user;
            }
        }
        /* search pages */
        $get_pages = $db->query(sprintf('SELECT * FROM pages WHERE page_name LIKE %1$s OR page_title LIKE %1$s ORDER BY page_title ASC LIMIT %2$s, %3$s', secure($query, 'search'), secure($offset, 'int', false), secure($system['max_results'], 'int', false) )) or _error(SQL_ERROR_THROWEN);
        if($get_pages->num_rows > 0) {
            while($page = $get_pages->fetch_assoc()) {
                $page['page_picture'] = get_picture($page['page_picture'], 'page');
                /* get the connection */
                $page['i_like'] = $this->check_page_membership($this->_data['user_id'], $page['page_id']);
                $results['pages'][] = $page;
            }
        }
        /* search groups */
        $get_groups = $db->query(sprintf('SELECT * FROM groups WHERE group_privacy != "secret" AND (group_name LIKE %1$s OR group_title LIKE %1$s) ORDER BY group_title ASC LIMIT %2$s, %3$s', secure($query, 'search'), secure($offset, 'int', false), secure($system['max_results'], 'int', false) )) or _error(SQL_ERROR_THROWEN);
        if($get_groups->num_rows > 0) {
            while($group = $get_groups->fetch_assoc()) {
                $group['group_picture'] = get_picture($group['group_picture'], 'group');
                /* check if the viewer joined the group */
                $group['i_joined'] = $this->check_group_membership($this->_data['user_id'], $group['group_id']);
                $results['groups'][] = $group;
            }
        }
        /* search events */
        $get_events = $db->query(sprintf('SELECT * FROM events WHERE event_privacy != "secret" AND event_title LIKE %1$s ORDER BY event_title ASC LIMIT %2$s, %3$s', secure($query, 'search'), secure($offset, 'int', false), secure($system['max_results'], 'int', false) )) or _error(SQL_ERROR_THROWEN);
        if($get_events->num_rows > 0) {
            while($event = $get_events->fetch_assoc()) {
                $event['event_picture'] = get_picture($event['event_cover'], 'event');
                /* check if the viewer joined the event */
                $event['i_joined'] = $this->check_event_membership($this->_data['user_id'], $event['event_id']);
                $results['events'][] = $event;
            }
        }
        return $results;
    }


    /**
     * search_users
     * 
     * @param string $distance
     * @param string $keyword
     * @param string $gender
     * @param string $relationship
     * @param string $status
     * @return array
     */
    public function search_users($distance, $keyword, $gender, $relationship, $status) {
        global $db, $system;
        $results = array();
        $offset *= $system['max_results'];
        // validation
        /* validate distance */
        $unit = 6371;
        $distance = ($distance && is_numeric($distance) && $distance > 0)? $distance : 25;
        /* validate gender */
        if(!in_array($gender, array('any', 'male', 'female', 'other'))) {
            return $results;
        }
        /* validate relationship */
        if(!in_array($relationship, array('any','single', 'relationship', 'married', "complicated", 'separated', 'divorced', 'widowed'))) {
            return $results;
        }
        /* validate status */
        if(!in_array($status, array('any', 'online', 'offline'))) {
            return $results;
        }
        // prepare where statement
        $where = "";
        /* merge (friends, followings, friend requests & friend requests sent) and get the unique ids  */
        $old_people_ids = array_unique(array_merge($this->_data['friends_ids'], $this->_data['followings_ids'], $this->_data['friend_requests_ids'], $this->_data['friend_requests_sent_ids']));
        /* add the viewer to this list */
        $old_people_ids[] = $this->_data['user_id'];
        /* make a list from old people */
        $old_people_ids_list = implode(',',$old_people_ids);
        $where .= sprintf("WHERE user_banned = '0' AND user_id NOT IN (%s)", $old_people_ids_list);
        if($system['activation_enabled']) {
            $where .= " AND user_activated = '1'";
        }
        /* keyword */
        if($keyword) {
            $where .= sprintf(' AND (user_name LIKE %1$s OR user_firstname LIKE %1$s OR user_lastname LIKE %1$s OR CONCAT(user_firstname,  " ", user_lastname) LIKE %1$s)', secure($keyword, 'search'));
        }
        /* gender */
        if($gender != "any") {
            $where .= " AND users.user_gender = '$gender'";
        }
        /* relationship */
        if($relationship != "any") {
            $where .= " AND users.user_relationship = '$relationship'";
        }
        /* status */
        if($status != "any") {
            if($status == "online") {
                $where .= sprintf(" AND user_last_seen >= SUBTIME(NOW(), SEC_TO_TIME(%s))", secure($system['offline_time'], 'int', false));
            } else {
                $where .= sprintf(" AND user_last_seen < SUBTIME(NOW(), SEC_TO_TIME(%s))", secure($system['offline_time'], 'int', false));
            }
        }
        /* get users */
        $query = sprintf("SELECT *, (%s * acos(cos(radians(%s)) * cos(radians(user_latitude)) * cos(radians(user_longitude) - radians(%s)) + sin(radians(%s)) * sin(radians(user_latitude))) ) AS distance FROM users ", secure($unit, 'int'), secure($this->_data['user_latitude']), secure($this->_data['user_longitude']), secure($this->_data['user_latitude']));
        $query .= $where;
        $query .= sprintf(" HAVING distance < %s ORDER BY distance ASC LIMIT %s", secure($distance, 'int'), secure($system['max_results'], 'int', false) );
        $get_users = $db->query($query) or _error(SQL_ERROR_THROWEN);
        if($get_users->num_rows > 0) {
            while($user = $get_users->fetch_assoc()) {
                $user['user_picture'] = get_picture($user['user_picture'], $user['user_gender']);
                /* get the connection between the viewer & the target */
                $user['connection'] = $this->connection($user['user_id']);
                $results[] = $user;
            }
        }
        return $results;
    }


    /**
     * get_search_log
     * 
     * @return array
     */
    public function get_search_log() {
        global $db, $system;
        $results = array();
        $get_search_log = $db->query(sprintf("SELECT users_searches.log_id, users_searches.node_type, users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, users.user_subscribed, users.user_verified, pages.*, groups.*, events.* FROM users_searches LEFT JOIN users ON users_searches.node_type = 'user' AND users_searches.node_id = users.user_id LEFT JOIN pages ON users_searches.node_type = 'page' AND users_searches.node_id = pages.page_id LEFT JOIN groups ON users_searches.node_type = 'group' AND users_searches.node_id = groups.group_id LEFT JOIN events ON users_searches.node_type = 'event' AND users_searches.node_id = events.event_id WHERE users_searches.user_id = %s ORDER BY users_searches.log_id DESC LIMIT %s", secure($this->_data['user_id'], 'int'), secure($system['min_results'], 'int', false) )) or _error(SQL_ERROR_THROWEN);
        if($get_search_log->num_rows > 0) {
            while($result = $get_search_log->fetch_assoc()) {
                switch ($result['node_type']) {
                    case 'user':
                        $result['user_picture'] = get_picture($result['user_picture'], $result['user_gender']);
                        /* get the connection between the viewer & the target */
                        $result['connection'] = $this->connection($result['user_id']);
                        break;
                    
                    case 'page':
                        $result['page_picture'] = get_picture($result['page_picture'], 'page');
                        /* check if the viewer liked the page */
                        $result['i_like'] = false;
                        $get_likes = $db->query(sprintf("SELECT * FROM pages_likes WHERE page_id = %s AND user_id = %s", secure($result['page_id'], 'int'), secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                        if($get_likes->num_rows > 0) {
                            $result['i_like'] = true;
                        }
                        break;

                    case 'group':
                        $result['group_picture'] = get_picture($result['group_picture'], 'group');
                        /* check if the viewer joined the group */
                        $result['i_joined'] = $this->check_group_membership($this->_data['user_id'], $result['group_id']);
                        break;

                    case 'event':
                        $result['event_picture'] = get_picture($result['event_cover'], 'event');
                        /* check if the viewer joined the event */
                        $result['i_joined'] = $this->check_event_membership($this->_data['user_id'], $result['event_id']);
                        break;
                }
                $result['type'] = $result['node_type'];
                $results[] = $result;
            }
        }
        return $results;
    }


    /**
     * set_search_log
     * 
     * @param integer $node_id
     * @param string $node_type
     * @return void
     */
    public function set_search_log($node_id, $node_type) {
        global $db, $date;
        $db->query(sprintf("INSERT INTO users_searches (user_id, node_id, node_type, time) VALUES (%s, %s, %s, %s)", secure($this->_data['user_id'], 'int'), secure($node_id, 'int'), secure($node_type), secure($date) ));
    }


    /**
     * clear_search_log
     * 
     * @return void
     */
    public function clear_search_log() {
        global $db, $system;
        $db->query(sprintf("DELETE FROM users_searches WHERE user_id = %s", secure($this->_data['user_id'], 'int'))) or _error(SQL_ERROR_THROWEN);
    }
    


    /* ------------------------------- */
    /* User & Connections */
    /* ------------------------------- */

    /**
     * connect
     * 
     * @param string $do
     * @param integer $id
     * @param integer $uid
     * @return void
     */
    public function connect($do, $id, $uid = null) {
        global $db;
        switch ($do) {
            case 'block':
                /* check blocking */
                if($this->blocked($id)) {
                    throw new Exception(__("You have already blocked this user before!"));
                }
                /* remove any friendship */
                $this->connect('friend-remove', $id);
                /* delete the target from viewer's followings */
                $this->connect('unfollow', $id);
                /* delete the viewer from target's followings */
                $db->query(sprintf("DELETE FROM followings WHERE user_id = %s AND following_id = %s", secure($id, 'int'), secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                /* block the user */
                $db->query(sprintf("INSERT INTO users_blocks (user_id, blocked_id) VALUES (%s, %s)", secure($this->_data['user_id'], 'int'), secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                break;

            case 'unblock':
                /* check blocking */
                if(!$this->blocked($id)) return;
                /* unblock the user */
                $db->query(sprintf("DELETE FROM users_blocks WHERE user_id = %s AND blocked_id = %s", secure($this->_data['user_id'], 'int'), secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                break;

            case 'friend-accept':
                /* check if there is a friend request from the target to the viewer */
                $check = $db->query(sprintf("SELECT * FROM friends WHERE user_one_id = %s AND user_two_id = %s AND status = 0", secure($id, 'int'), secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                /* if no -> return */
                if($check->num_rows == 0) return;
                /* add the target as a friend */
                $db->query(sprintf("UPDATE friends SET status = 1 WHERE user_one_id = %s AND user_two_id = %s", secure($id, 'int'), secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                /* post new notification */
                $this->post_notification( array('to_user_id'=>$id, 'action'=>'friend_accept', 'node_url'=>$this->_data['user_name']) );
                /* follow */
                $this->_follow($id);
                break;

            case 'friend-decline':
                /* check if there is a friend request from the target to the viewer */
                $check = $db->query(sprintf("SELECT * FROM friends WHERE user_one_id = %s AND user_two_id = %s AND status = 0", secure($id, 'int'), secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                /* if no -> return */
                if($check->num_rows == 0) return;
                /* decline this friend request */
                $db->query(sprintf("UPDATE friends SET status = -1 WHERE user_one_id = %s AND user_two_id = %s", secure($id, 'int'), secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                /* unfollow */
                $this->_unfollow($id);
                break;

            case 'friend-add':
                /* check blocking */
                if($this->blocked($id)) {
                    _error(403);
                }
                /* check if there is any relation between the viewer & the target */
                $check = $db->query(sprintf('SELECT * FROM friends WHERE (user_one_id = %1$s AND user_two_id = %2$s) OR (user_one_id = %2$s AND user_two_id = %1$s)', secure($this->_data['user_id'], 'int'),  secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                /* if yes -> return */
                if($check->num_rows > 0) return;
                /* add the friend request */
                $db->query(sprintf("INSERT INTO friends (user_one_id, user_two_id, status) VALUES (%s, %s, '0')", secure($this->_data['user_id'], 'int'),  secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                /* update requests counter +1 */
                $db->query(sprintf("UPDATE users SET user_live_requests_counter = user_live_requests_counter + 1 WHERE user_id = %s", secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                /* post new notification */
                $this->post_notification( array('to_user_id'=>$id, 'action'=>'friend_add', 'node_url'=>$this->_data['user_name']) );
                /* follow */
                $this->_follow($id);
                break;

            case 'friend-cancel':
                /* check if there is a request from the viewer to the target */
                $check = $db->query(sprintf("SELECT * FROM friends WHERE user_one_id = %s AND user_two_id = %s AND status = 0", secure($this->_data['user_id'], 'int'),  secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                /* if no -> return */
                if($check->num_rows == 0) return;
                /* delete the friend request */
                $db->query(sprintf("DELETE FROM friends WHERE user_one_id = %s AND user_two_id = %s", secure($this->_data['user_id'], 'int'), secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                /* update requests counter -1 */
                $db->query(sprintf("UPDATE users SET user_live_requests_counter = IF(user_live_requests_counter=0,0,user_live_requests_counter-1), user_live_notifications_counter = IF(user_live_notifications_counter=0,0,user_live_notifications_counter-1) WHERE user_id = %s", secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                /* unfollow */
                $this->_unfollow($id);
                break;

            case 'friend-remove':
                /* check if there is any relation between me & him */
                $check = $db->query(sprintf('SELECT * FROM friends WHERE (user_one_id = %1$s AND user_two_id = %2$s AND status = 1) OR (user_one_id = %2$s AND user_two_id = %1$s AND status = 1)', secure($this->_data['user_id'], 'int'),  secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                /* if no -> return */
                if($check->num_rows == 0) return;
                /* delete this friend */
                $db->query(sprintf('DELETE FROM friends WHERE (user_one_id = %1$s AND user_two_id = %2$s AND status = 1) OR (user_one_id = %2$s AND user_two_id = %1$s AND status = 1)', secure($this->_data['user_id'], 'int'),  secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                break;

            case 'follow':
                $this->_follow($id);
                break;

            case 'unfollow':
                $this->_unfollow($id);
                break;

            case 'page-like':
                /* check if the viewer already liked this page */
                $check = $db->query(sprintf("SELECT * FROM pages_likes WHERE user_id = %s AND page_id = %s", secure($this->_data['user_id'], 'int'),  secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                /* if yes -> return */
                if($check->num_rows > 0) return;
                /* if no -> like this page */
                $db->query(sprintf("INSERT INTO pages_likes (user_id, page_id) VALUES (%s, %s)", secure($this->_data['user_id'], 'int'),  secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                /* update likes counter +1 */
                $db->query(sprintf("UPDATE pages SET page_likes = page_likes + 1  WHERE page_id = %s", secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                break;

            case 'page-unlike':
                /* check if the viewer already liked this page */
                $check = $db->query(sprintf("SELECT * FROM pages_likes WHERE user_id = %s AND page_id = %s", secure($this->_data['user_id'], 'int'),  secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                /* if no -> return */
                if($check->num_rows == 0) return;
                /* if yes -> unlike this page */
                $db->query(sprintf("DELETE FROM pages_likes WHERE user_id = %s AND page_id = %s", secure($this->_data['user_id'], 'int'),  secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                /* update likes counter -1 */
                $db->query(sprintf("UPDATE pages SET page_likes = IF(page_likes=0,0,page_likes-1) WHERE page_id = %s", secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                break;

            case 'page-boost':
                /* check if the user is the page admin */
                $check = $db->query(sprintf("SELECT * FROM pages WHERE page_id = %s AND page_admin = %s", secure($id, 'int'), secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                if($check->num_rows == 0) {
                    _error(403);
                }
                $spage = $check->fetch_assoc();
                /* check if viewer can boost page */
                if(!$this->_data['can_boost_pages']) {
                    modal(MESSAGE, __("Sorry"), __("You reached the maximum number of boosted pages! Upgrade your package to get more"));
                }
                /* boost page */
                if(!$spage['page_boosted']) {
                    /* boost page */
                    $db->query(sprintf("UPDATE pages SET page_boosted = '1', page_boosted_by = %s WHERE page_id = %s", secure($this->_data['user_id'], 'int'), secure($id, 'int'))) or _error(SQL_ERROR_THROWEN);
                    /* update user */
                    $db->query(sprintf("UPDATE users SET user_boosted_pages = user_boosted_pages + 1 WHERE user_id = %s", secure($this->_data['user_id'], 'int'))) or _error(SQL_ERROR_THROWEN);
                }
                break;

            case 'page-unboost':
                /* check if the user is the page admin */
                $check = $db->query(sprintf("SELECT * FROM pages WHERE page_id = %s AND page_admin = %s", secure($id, 'int'), secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                if($check->num_rows == 0) {
                    _error(403);
                }
                $spage = $check->fetch_assoc();
                /* unboost page */
                if($spage['page_boosted']) {
                    /* unboost page */
                    $db->query(sprintf("UPDATE pages SET page_boosted = '0', page_boosted_by = NULL WHERE page_id = %s", secure($id, 'int'))) or _error(SQL_ERROR_THROWEN);
                    /* update user */
                    $db->query(sprintf("UPDATE users SET user_boosted_pages = IF(user_boosted_pages=0,0,user_boosted_pages-1) WHERE user_id = %s", secure($this->_data['user_id'], 'int'))) or _error(SQL_ERROR_THROWEN);
                }
                break;

            case 'page-invite':
                if($uid == null) {
                    _error(400);
                }
                /* check if the viewer liked the page */
                $check_viewer = $db->query(sprintf("SELECT pages.* FROM pages INNER JOIN pages_likes ON pages.page_id = pages_likes.page_id WHERE pages_likes.user_id = %s AND pages_likes.page_id = %s", secure($this->_data['user_id'], 'int'), secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                /* if no -> return */
                if($check_viewer->num_rows == 0) return;
                /* check if the target already liked this page */
                $check_target = $db->query(sprintf("SELECT * FROM pages_likes WHERE user_id = %s AND page_id = %s", secure($uid, 'int'),  secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                /* if yes -> return */
                if($check_target->num_rows > 0) return;
                /* check if the viewer already invited to the viewer to this page */
                $check_target = $db->query(sprintf("SELECT * FROM pages_invites WHERE page_id = %s AND user_id = %s AND from_user_id = %s", secure($id, 'int'), secure($uid, 'int'), secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                /* if yes -> return */
                if($check_target->num_rows > 0) return;
                /* if no -> invite to this page */
                /* get page */
                $page = $check_viewer->fetch_assoc();
                /* insert invitation */
                $db->query(sprintf("INSERT INTO pages_invites (page_id, user_id, from_user_id) VALUES (%s, %s, %s)", secure($id, 'int'), secure($uid, 'int'), secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                /* send notification (page invitation) to the target user */
                $this->post_notification( array('to_user_id'=>$uid, 'action'=>'page_invitation', 'node_type'=>$page['page_title'], 'node_url'=>$page['page_name']) );
                break;

            case 'page-admin-addation':
                if($uid == null) {
                    _error(400);
                }
                /* check if the target already a page member */
                $check = $db->query(sprintf("SELECT * FROM pages_likes WHERE user_id = %s AND page_id = %s", secure($uid, 'int'),  secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                /* if no -> return */
                if($check->num_rows == 0) return;
                /* check if the target already a page admin */
                $check = $db->query(sprintf("SELECT * FROM pages_admins WHERE user_id = %s AND page_id = %s", secure($uid, 'int'),  secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                /* if yes -> return */
                if($check->num_rows > 0) return;
                /* get page */
                $get_page = $db->query(sprintf("SELECT * FROM pages WHERE page_id = %s", secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                $page = $get_page->fetch_assoc();
                /* check if the viewer is page admin */
                if(!$this->check_page_adminship($this->_data['user_id'], $page['page_id']) && $this->_data['user_id'] != $page['page_admin']) {
                    _error(400);
                }
                /* add the target as page admin */
                $db->query(sprintf("INSERT INTO pages_admins (user_id, page_id) VALUES (%s, %s)", secure($uid, 'int'),  secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                /* send notification (page admin addation) to the target user */
                $this->post_notification( array('to_user_id'=>$uid, 'action'=>'page_admin_addation', 'node_type'=>$page['page_title'], 'node_url'=>$page['page_name']) );
                break;

            case 'page-admin-remove':
                if($uid == null) {
                    _error(400);
                }
                /* check if the target already a page admin */
                $check = $db->query(sprintf("SELECT * FROM pages_admins WHERE user_id = %s AND page_id = %s", secure($uid, 'int'),  secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                /* if no -> return */
                if($check->num_rows == 0) return;
                /* get page */
                $get_page = $db->query(sprintf("SELECT * FROM pages WHERE page_id = %s", secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                $page = $get_page->fetch_assoc();
                /* check if the viewer is page admin */
                if(!$this->check_page_adminship($this->_data['user_id'], $page['page_id'])) {
                    _error(400);
                }
                /* check if the target is the super page admin */
                if($uid == $page['page_admin']) {
                    throw new Exception(__("You can not remove page super admin"));
                }
                /* remove the target as page admin */
                $db->query(sprintf("DELETE FROM pages_admins WHERE user_id = %s AND page_id = %s", secure($uid, 'int'), secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                /* delete notification (page admin addation) to the target user */
                $this->delete_notification($uid, 'page_admin_addation', $page['page_title'], $page['page_name']);
                break;

            case 'page-member-remove':
                if($uid == null) {
                    _error(400);
                }
                /* check if the target already a page member */
                $check = $db->query(sprintf("SELECT * FROM pages_likes WHERE user_id = %s AND page_id = %s", secure($uid, 'int'),  secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                /* if no -> return */
                if($check->num_rows == 0) return;
                /* get page */
                $get_page = $db->query(sprintf("SELECT * FROM pages WHERE page_id = %s", secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                $page = $get_page->fetch_assoc();
                /* check if the target is the super page admin */
                if($uid == $page['page_admin']) {
                    throw new Exception(__("You can not remove page super admin"));
                }
                /* remove the target as page admin */
                $db->query(sprintf("DELETE FROM pages_admins WHERE user_id = %s AND page_id = %s", secure($uid, 'int'), secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                /* remove the target as page member */
                $db->query(sprintf("DELETE FROM pages_likes WHERE user_id = %s AND page_id = %s", secure($uid, 'int'), secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                /* update members counter -1 */
                $db->query(sprintf("UPDATE pages SET page_likes = IF(page_likes=0,0,page_likes-1) WHERE page_id = %s", secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                break;

            case 'group-join':
                /* check if the viewer already joined (approved||pending) this group */
                $check = $db->query(sprintf("SELECT * FROM groups_members WHERE user_id = %s AND group_id = %s", secure($this->_data['user_id'], 'int'),  secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                /* if yes -> return */
                if($check->num_rows > 0) return;
                /* if no -> join this group */
                /* get group */
                $get_group = $db->query(sprintf("SELECT * FROM groups WHERE group_id = %s", secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                $group = $get_group->fetch_assoc();
                /* check approved */
                $approved = 0;
                if($group['group_privacy'] == 'public') {
                    /* the group is public */
                    $approved = '1';
                } elseif($this->_data['user_id'] == $group['group_admin']) {
                    /* the group admin join his group */
                    $approved = '1';
                }
                $db->query(sprintf("INSERT INTO groups_members (user_id, group_id, approved) VALUES (%s, %s, %s)", secure($this->_data['user_id'], 'int'),  secure($id, 'int'), secure($approved) )) or _error(SQL_ERROR_THROWEN);
                if($approved) {
                    /* update members counter +1 */
                    $db->query(sprintf("UPDATE groups SET group_members = group_members + 1  WHERE group_id = %s", secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                } else {
                    /* send notification (pending request) to group admin  */
                    $this->post_notification( array('to_user_id'=>$group['group_admin'], 'action'=>'group_join', 'node_type'=>$group['group_title'], 'node_url'=>$group['group_name']) );
                }
                break;

            case 'group-leave':
                /* check if the viewer already joined (approved||pending) this group */
                $check = $db->query(sprintf("SELECT groups_members.approved, groups.* FROM groups_members INNER JOIN groups ON groups_members.group_id = groups.group_id WHERE groups_members.user_id = %s AND groups_members.group_id = %s", secure($this->_data['user_id'], 'int'),  secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                /* if no -> return */
                if($check->num_rows == 0) return;
                /* if yes -> leave this group */
                $group = $check->fetch_assoc();
                $db->query(sprintf("DELETE FROM groups_members WHERE user_id = %s AND group_id = %s", secure($this->_data['user_id'], 'int'),  secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                /* update members counter -1 */
                if($group['approved']) {
                    $db->query(sprintf("UPDATE groups SET group_members = IF(group_members=0,0,group_members-1) WHERE group_id = %s", secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                } else {
                    /* delete notification (pending request) that sent to group admin */
                    $this->delete_notification($group['group_admin'], 'group_join', $group['group_title'], $group['group_name']);
                }
                break;

            case 'group-invite':
                if($uid == null) {
                    _error(400);
                }
                /* check if the viewer is group member (approved) */
                $check_viewer = $db->query(sprintf("SELECT groups.* FROM groups INNER JOIN groups_members ON groups.group_id = groups_members.group_id WHERE groups_members.approved = '1' AND groups_members.user_id = %s AND groups_members.group_id = %s", secure($this->_data['user_id'], 'int'), secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                /* if no -> return */
                if($check_viewer->num_rows == 0) return;
                /* check if the target already joined (approved||pending) this group */
                $check_target = $db->query(sprintf("SELECT * FROM groups_members WHERE user_id = %s AND group_id = %s", secure($uid, 'int'),  secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                /* if yes -> return */
                if($check_target->num_rows > 0) return;
                /* if no -> join this group */
                /* get group */
                $group = $check_viewer->fetch_assoc();
                /* check approved */
                $approved = 0;
                if($group['group_privacy'] == 'public') {
                    /* the group is public */
                    $approved = '1';
                } elseif($this->_data['user_id'] == $group['group_admin']) {
                    /* the group admin want to add a user */
                    $approved = '1';
                } elseif($uid == $group['group_admin']) {
                    /* the viewer invite group admin to join his group */
                    $approved = '1';
                }
                /* add the target user as group member */
                $db->query(sprintf("INSERT INTO groups_members (user_id, group_id, approved) VALUES (%s, %s, %s)", secure($uid, 'int'),  secure($id, 'int'), secure($approved) )) or _error(SQL_ERROR_THROWEN);
                if($approved) {
                    /* update members counter +1 */
                    $db->query(sprintf("UPDATE groups SET group_members = group_members + 1  WHERE group_id = %s", secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                    /* send notification (group addition) to the target user */
                    $this->post_notification( array('to_user_id'=>$uid, 'action'=>'group_add', 'node_type'=>$group['group_title'], 'node_url'=>$group['group_name']) );
                } else {
                    /* send notification (group addition) to the target user */
                    if($group['group_privacy'] != 'secret') {
                        $this->post_notification( array('to_user_id'=>$uid, 'action'=>'group_add', 'node_type'=>$group['group_title'], 'node_url'=>$group['group_name']) );
                    }
                    /* send notification (pending request) to group admin [from the target]  */
                    $this->post_notification( array('to_user_id'=>$group['group_admin'], 'from_user_id'=>$uid, 'action'=>'group_join', 'node_type'=>$group['group_title'], 'node_url'=>$group['group_name']) );
                }
                break;

            case 'group-accept':
                if($uid == null) {
                    _error(400);
                }
                /* check if the target has pending request */
                $check = $db->query(sprintf("SELECT groups.* FROM groups INNER JOIN groups_members ON groups.group_id = groups_members.group_id WHERE groups_members.approved = '0' AND groups_members.user_id = %s AND groups_members.group_id = %s", secure($uid, 'int'), secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                /* if no -> return */
                if($check->num_rows == 0) return;
                $group = $check->fetch_assoc();
                /* check if the viewer is group admin */
                if(!$this->check_group_adminship($this->_data['user_id'], $group['group_id'])) {
                    _error(400);
                }
                /* update request */
                $db->query(sprintf("UPDATE groups_members SET approved = '1' WHERE user_id = %s AND group_id = %s", secure($uid, 'int'), secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                /* update members counter +1 */
                $db->query(sprintf("UPDATE groups SET group_members = group_members + 1  WHERE group_id = %s", secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                /* send notification (group acceptance) to the target user */
                $this->post_notification( array('to_user_id'=>$uid, 'action'=>'group_accept', 'node_type'=>$group['group_title'], 'node_url'=>$group['group_name']) );
                break;

            case 'group-decline':
                if($uid == null) {
                    _error(400);
                }
                /* check if the target has pending request */
                $check = $db->query(sprintf("SELECT groups.* FROM groups INNER JOIN groups_members ON groups.group_id = groups_members.group_id WHERE groups_members.approved = '0' AND groups_members.user_id = %s AND groups_members.group_id = %s", secure($uid, 'int'), secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                /* if no -> return */
                if($check->num_rows == 0) return;
                $group = $check->fetch_assoc();
                /* check if the viewer is group admin */
                if(!$this->check_group_adminship($this->_data['user_id'], $group['group_id'])) {
                    _error(400);
                }
                /* delete request */
                $db->query(sprintf("DELETE FROM groups_members WHERE user_id = %s AND group_id = %s", secure($uid, 'int'), secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                break;

            case 'group-admin-addation':
                if($uid == null) {
                    _error(400);
                }
                /* check if the target already a group member */
                $check = $db->query(sprintf("SELECT * FROM groups_members WHERE user_id = %s AND group_id = %s", secure($uid, 'int'),  secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                /* if no -> return */
                if($check->num_rows == 0) return;
                /* check if the target already a group admin */
                $check = $db->query(sprintf("SELECT * FROM groups_admins WHERE user_id = %s AND group_id = %s", secure($uid, 'int'),  secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                /* if yes -> return */
                if($check->num_rows > 0) return;
                /* get group */
                $get_group = $db->query(sprintf("SELECT * FROM groups WHERE group_id = %s", secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                $group = $get_group->fetch_assoc();
                /* check if the viewer is group admin */
                if(!$this->check_group_adminship($this->_data['user_id'], $group['group_id']) && $this->_data['user_id'] != $group['group_admin']) {
                    _error(400);
                }
                /* add the target as group admin */
                $db->query(sprintf("INSERT INTO groups_admins (user_id, group_id) VALUES (%s, %s)", secure($uid, 'int'),  secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                /* send notification (group admin addation) to the target user */
                $this->post_notification( array('to_user_id'=>$uid, 'action'=>'group_admin_addation', 'node_type'=>$group['group_title'], 'node_url'=>$group['group_name']) );
                break;

            case 'group-admin-remove':
                if($uid == null) {
                    _error(400);
                }
                /* check if the target already a group admin */
                $check = $db->query(sprintf("SELECT * FROM groups_admins WHERE user_id = %s AND group_id = %s", secure($uid, 'int'),  secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                /* if no -> return */
                if($check->num_rows == 0) return;
                /* get group */
                $get_group = $db->query(sprintf("SELECT * FROM groups WHERE group_id = %s", secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                $group = $get_group->fetch_assoc();
                /* check if the viewer is group admin */
                if(!$this->check_group_adminship($this->_data['user_id'], $group['group_id'])) {
                    _error(400);
                }
                /* check if the target is the super group admin */
                if($uid == $group['group_admin']) {
                    throw new Exception(__("You can not remove group super admin"));
                }
                /* remove the target as group admin */
                $db->query(sprintf("DELETE FROM groups_admins WHERE user_id = %s AND group_id = %s", secure($uid, 'int'), secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                /* delete notification (group admin addation) to the target user */
                $this->delete_notification($uid, 'group_admin_addation', $group['group_title'], $group['group_name']);
                break;

            case 'group-member-remove':
                if($uid == null) {
                    _error(400);
                }
                /* check if the target already a group member */
                $check = $db->query(sprintf("SELECT * FROM groups_members WHERE user_id = %s AND group_id = %s", secure($uid, 'int'),  secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                /* if no -> return */
                if($check->num_rows == 0) return;
                /* get group */
                $get_group = $db->query(sprintf("SELECT * FROM groups WHERE group_id = %s", secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                $group = $get_group->fetch_assoc();
                /* check if the target is the super group admin */
                if($uid == $group['group_admin']) {
                    throw new Exception(__("You can not remove group super admin"));
                }
                /* remove the target as group admin */
                $db->query(sprintf("DELETE FROM groups_admins WHERE user_id = %s AND group_id = %s", secure($uid, 'int'), secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                /* remove the target as group member */
                $db->query(sprintf("DELETE FROM groups_members WHERE user_id = %s AND group_id = %s", secure($uid, 'int'), secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                /* update members counter -1 */
                $db->query(sprintf("UPDATE groups SET group_members = IF(group_members=0,0,group_members-1) WHERE group_id = %s", secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                break;

            case 'event-go':
                /* check if the viewer member to this event */
                $check = $db->query(sprintf("SELECT * FROM events_members WHERE user_id = %s AND event_id = %s", secure($this->_data['user_id'], 'int'), secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                $invited = false; $interested = false;
                if($check->num_rows > 0) {
                    $member = $check->fetch_assoc();
                    /* if going -> return */
                    if($member['is_going'] == '1') return;
                    $invited = ($member['is_invited'] == '1')? true: false;
                    $interested = ($member['is_interested'] == '1')? true: false;
                }
                $approved = false;
                if($invited || $interested) {
                    $approved = true;
                } else {
                    /* get event */
                    $get_event = $db->query(sprintf("SELECT * FROM events WHERE event_id = %s", secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                    $event = $get_event->fetch_assoc();
                    if($event['event_privacy'] == 'public') {
                        /* the event is public */
                        $approved = true;
                    } elseif($this->_data['user_id'] == $event['event_admin']) {
                        /* the event admin going his event */
                        $approved = true;
                    }
                }
                if($approved) {
                    if($invited || $interested) {
                        $db->query(sprintf("UPDATE events_members SET is_going = '1' WHERE user_id = %s AND event_id = %s", secure($this->_data['user_id'], 'int'), secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                    } else {
                        $db->query(sprintf("INSERT INTO events_members (user_id, event_id, is_going) VALUES (%s, %s, '1')", secure($this->_data['user_id'], 'int'), secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                    }
                    /* update going counter +1 */
                    $db->query(sprintf("UPDATE events SET event_going = event_going + 1  WHERE event_id = %s", secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                }
                break;

            case 'event-ungo':
                /* check if the viewer member to this event */
                $check = $db->query(sprintf("SELECT * FROM events_members WHERE user_id = %s AND event_id = %s", secure($this->_data['user_id'], 'int'), secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                /* if no -> return */
                if($check->num_rows == 0) return;
                $invited = false; $interested = false;
                $member = $check->fetch_assoc();
                /* if not going -> return */
                if($member['is_going'] == '0') return;
                $invited = ($member['is_invited'] == '1')? true: false;
                $interested = ($member['is_interested'] == '1')? true: false;
                if(!$invited && !$interested) {
                    $db->query(sprintf("DELETE FROM events_members WHERE user_id = %s AND event_id = %s", secure($this->_data['user_id'], 'int'), secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                } else {
                    $db->query(sprintf("UPDATE events_members SET is_going = '0' WHERE user_id = %s AND event_id = %s", secure($this->_data['user_id'], 'int'), secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                }
                /* update going counter -1 */
                $db->query(sprintf("UPDATE events SET event_going = IF(event_going=0,0,event_going-1)  WHERE event_id = %s", secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                break;

            case 'event-interest':
                /* check if the viewer member to this event */
                $check = $db->query(sprintf("SELECT * FROM events_members WHERE user_id = %s AND event_id = %s", secure($this->_data['user_id'], 'int'), secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                $invited = false; $going = false;
                if($check->num_rows > 0) {
                    $member = $check->fetch_assoc();
                    /* if interested -> return */
                    if($member['is_interested'] == '1') return;
                    $invited = ($member['is_invited'] == '1')? true: false;
                    $going = ($member['is_going'] == '1')? true: false;
                }
                $approved = false;
                if($invited || $going) {
                    $approved = true;
                } else {
                    /* get event */
                    $get_event = $db->query(sprintf("SELECT * FROM events WHERE event_id = %s", secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                    $event = $get_event->fetch_assoc();
                    if($event['event_privacy'] == 'public') {
                        /* the event is public */
                        $approved = true;
                    } elseif($this->_data['user_id'] == $event['event_admin']) {
                        /* the event admin interested his event */
                        $approved = true;
                    }
                }
                if($approved) {
                    if($invited || $going) {
                        $db->query(sprintf("UPDATE events_members SET is_interested = '1' WHERE user_id = %s AND event_id = %s", secure($this->_data['user_id'], 'int'), secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                    } else {
                        $db->query(sprintf("INSERT INTO events_members (user_id, event_id, is_interested) VALUES (%s, %s, '1')", secure($this->_data['user_id'], 'int'), secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                    }
                    /* update interested counter +1 */
                    $db->query(sprintf("UPDATE events SET event_interested = event_interested + 1  WHERE event_id = %s", secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                }
                break;

            case 'event-uninterest':
                /* check if the viewer member to this event */
                $check = $db->query(sprintf("SELECT * FROM events_members WHERE user_id = %s AND event_id = %s", secure($this->_data['user_id'], 'int'), secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                /* if no -> return */
                if($check->num_rows == 0) return;
                $invited = false; $going = false;
                $member = $check->fetch_assoc();
                /* if not interested -> return */
                if($member['is_interested'] == '0') return;
                $invited = ($member['is_invited'] == '1')? true: false;
                $going = ($member['is_going'] == '1')? true: false;
                if(!$invited && !$going) {
                    $db->query(sprintf("DELETE FROM events_members WHERE user_id = %s AND event_id = %s", secure($this->_data['user_id'], 'int'), secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                } else {
                    $db->query(sprintf("UPDATE events_members SET is_interested = '0' WHERE user_id = %s AND event_id = %s", secure($this->_data['user_id'], 'int'), secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                }
                /* update interested counter -1 */
                $db->query(sprintf("UPDATE events SET event_interested = IF(event_interested=0,0,event_interested-1)  WHERE event_id = %s", secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                break;

            case 'event-invite':
                if($uid == null) {
                    _error(400);
                }
                /* check if the viewer is event member */
                $check_viewer = $db->query(sprintf("SELECT events.* FROM events INNER JOIN events_members ON events.event_id = events_members.event_id WHERE events_members.user_id = %s AND events_members.event_id = %s", secure($this->_data['user_id'], 'int'), secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                /* if no -> return */
                if($check_viewer->num_rows == 0) return;
                /* check if the target already event member */
                $check_target = $db->query(sprintf("SELECT * FROM events_members WHERE user_id = %s AND event_id = %s", secure($uid, 'int'),  secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                /* if yes -> return */
                if($check_target->num_rows > 0) return;
                /* get event */
                $event = $check_viewer->fetch_assoc();
                /* insert invitation */
                $db->query(sprintf("INSERT INTO events_members (user_id, event_id, is_invited) VALUES (%s, %s, '1')", secure($uid, 'int'), secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                /* update invited counter +1 */
                $db->query(sprintf("UPDATE events SET event_invited = event_invited + 1  WHERE event_id = %s", secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                /* send notification (page invitation) to the target user */
                $this->post_notification( array('to_user_id'=>$uid, 'action'=>'event_invitation', 'node_type'=>$event['event_title'], 'node_url'=>$event['event_id']) );
                break;
        }
    }


    /**
     * connection
     * 
     * @param integer $user_id
     * @param boolean $friendship
     * @return string
     */
    public function connection($user_id, $friendship = true) {
        /* check which type of connection (friendship|follow) connections to get */
        if($friendship) {
            /* check if there is a logged user */
            if(!$this->_logged_in) {
                /* no logged user */
                return "add";
            }
            /* check if the viewer is the target */
            if($user_id == $this->_data['user_id']) {
                return "me";
            }
            /* check if the viewer & the target are friends */
            if(in_array($user_id, $this->_data['friends_ids'])) {
                return "remove";
            }
            /* check if the target sent a request to the viewer */
            if(in_array($user_id, $this->_data['friend_requests_ids'])) {
                return "request";
            }
            /* check if the viewer sent a request to the target */
            if(in_array($user_id, $this->_data['friend_requests_sent_ids'])) {
                return "cancel";
            }
            /* there is no relation between the viewer & the target */
            return "add";
        } else {
            /* check if there is a logged user */
            if(!$this->_logged_in) {
                /* no logged user */
                return "follow";
            }
            /* check if the viewer is the target */
            if($user_id == $this->_data['user_id']) {
                return "me";
            }
            if(in_array($user_id, $this->_data['followings_ids'])) {
                /* the viewer follow the target */
                return "unfollow";
            } else {
                /* the viewer not follow the target */
                return "follow";
            }
        }   
    }


    /**
     * banned
     *
     * @param integer $user_id
     * @return boolean
     */
    public function banned($user_id) {
        global $db;
        $check = $db->query(sprintf("SELECT * FROM users WHERE user_banned = '1' AND user_id = %s", secure($user_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        if($check->num_rows > 0) {
            return true;
        }
        return false;
    }


    /**
     * blocked
     * 
     * @param integer $user_id
     * @return boolean
     */
    public function blocked($user_id) {
        global $db;
        /* check if there is any blocking between the viewer & the target */
        if($this->_logged_in) {
            $check = $db->query(sprintf('SELECT * FROM users_blocks WHERE (user_id = %1$s AND blocked_id = %2$s) OR (user_id = %2$s AND blocked_id = %1$s)', secure($this->_data['user_id'], 'int'),  secure($user_id, 'int') )) or _error(SQL_ERROR_THROWEN);
            if($check->num_rows > 0) {
                return true;
            }
        }
        return false;
    }


    /**
     * delete_user
     * 
     * @param integer $user_id
     * @return void
     */
    public function delete_user($user_id) {
        global $db;
        /* (check&get) user */
        $get_user = $db->query(sprintf("SELECT * FROM users WHERE user_id = %s", secure($user_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        if($get_user->num_rows == 0) {
            _error(403);
        }
        $user = $get_user->fetch_assoc();
        // delete user
        $can_delete = false;
        /* target is (admin|moderator) */
        if($user['user_group'] < 3) {
            throw new Exception(__("You can not delete admin/morderator accounts"));
        }
        /* viewer is (admin|moderator) */
        if($this->_data['user_group'] < 3) {
            $can_delete = true;
        }
        /* viewer is the target */
        if($this->_data['user_id'] == $user_id) {
            $can_delete = true;
        }
        /* delete the user */
        if($can_delete) {
            /* delete the user */
            $db->query(sprintf("DELETE FROM users WHERE user_id = %s", secure($user_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        }
    }


    /**
     * _follow
     * 
     * @param integer $user_id
     * @return void
     */
    private function _follow($user_id) {
        global $db;
        /* check blocking */
        if($this->blocked($user_id)) {
            _error(403);
        }
        /* check if the viewer already follow the target */
        $check = $db->query(sprintf("SELECT * FROM followings WHERE user_id = %s AND following_id = %s", secure($this->_data['user_id'], 'int'),  secure($user_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        /* if yes -> return */
        if($check->num_rows > 0) return;
        /* add as following */
        $db->query(sprintf("INSERT INTO followings (user_id, following_id) VALUES (%s, %s)", secure($this->_data['user_id'], 'int'),  secure($user_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        /* post new notification */
        $this->post_notification( array('to_user_id' => $user_id, 'action'=> 'follow') );
    }


    /**
     * _unfollow
     * 
     * @param integer $user_id
     * @return void
     */
    private function _unfollow($user_id) {
        global $db;
        /* check if the viewer already follow the target */
        $check = $db->query(sprintf("SELECT * FROM followings WHERE user_id = %s AND following_id = %s", secure($this->_data['user_id'], 'int'),  secure($user_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        /* if no -> return */
        if($check->num_rows == 0) return;
        /* delete from viewer's followings */
        $db->query(sprintf("DELETE FROM followings WHERE user_id = %s AND following_id = %s", secure($this->_data['user_id'], 'int'), secure($user_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        /* delete notification */
        $this->delete_notification($user_id, 'follow');
    }



    /* ------------------------------- */
    /* Live */
    /* ------------------------------- */
    
    /**
     * live_counters_reset
     * 
     * @param string $counter
     * @return void
     */
    public function live_counters_reset($counter) {
        global $db;
        if($counter == "friend_requests") {
            $db->query(sprintf("UPDATE users SET user_live_requests_counter = 0 WHERE user_id = %s", secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
        } elseif($counter == "messages") {
            $db->query(sprintf("UPDATE users SET user_live_messages_counter = 0 WHERE user_id = %s", secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
        } elseif($counter == "notifications") {
            $db->query(sprintf("UPDATE users SET user_live_notifications_counter = 0 WHERE user_id = %s", secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN); 
            $db->query(sprintf("UPDATE notifications SET seen = '1' WHERE to_user_id = %s", secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN); 
        }
    }



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
    public function get_notifications($offset = 0, $last_notification_id = null) {
        global $db, $system;
        $offset *= $system['max_results'];
        $notifications = array();
        if($last_notification_id !== null) {
            $get_notifications = $db->query(sprintf("SELECT notifications.*, users.* FROM notifications INNER JOIN users ON notifications.from_user_id = users.user_id WHERE (notifications.to_user_id = %s OR notifications.to_user_id = '0') AND notifications.notification_id > %s ORDER BY notifications.notification_id DESC", secure($this->_data['user_id'], 'int'), secure($last_notification_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        } else {
            $get_notifications = $db->query(sprintf("SELECT notifications.*, users.* FROM notifications INNER JOIN users ON notifications.from_user_id = users.user_id WHERE notifications.to_user_id = %s OR notifications.to_user_id = '0' ORDER BY notifications.notification_id DESC LIMIT %s, %s", secure($this->_data['user_id'], 'int'), secure($offset, 'int', false), secure($system['max_results'], 'int', false) )) or _error(SQL_ERROR_THROWEN);
        }
        if($get_notifications->num_rows > 0) {
            while($notification = $get_notifications->fetch_assoc()) {
                $notification['user_picture'] = get_picture($notification['user_picture'], $notification['user_gender']);
                $notification['notify_id'] = ($notification['notify_id'])? "?notify_id=".$notification['notify_id'] : "";
                /* parse notification */
                switch ($notification['action']) {
                    case 'mass_notification':
                        $notification['icon'] = "fa-bell";
                        $notification['url'] = $notification['node_url'];
                        $notification['message'] = $notification['message'];
                        break;

                    case 'friend_add':
                        $notification['icon'] = "fa-user-plus";
                        $notification['url'] = $system['system_url'].'/'.$notification['user_name'];
                        $notification['message'] = __("sent you a friend request");
                        break;

                    case 'friend_accept':
                        $notification['icon'] = "fa-user-plus";
                        $notification['url'] = $system['system_url'].'/'.$notification['user_name'];
                        $notification['message'] = __("accepted your friend request");
                        break;

                    case 'follow':
                        $notification['icon'] = "fa-rss";
                        $notification['url'] = $system['system_url'].'/'.$notification['user_name'];
                        $notification['message'] = __("now following you");
                        break;

                    case 'like':
                        $notification['icon'] = "fa-thumbs-up";
                        if($notification['node_type'] == "post") {
                            $notification['url'] = $system['system_url'].'/posts/'.$notification['node_url'];
                            $notification['message'] = __("likes your post");

                        } elseif ($notification['node_type'] == "photo") {
                            $notification['url'] = $system['system_url'].'/photos/'.$notification['node_url'];
                            $notification['message'] = __("likes your photo");

                        } elseif ($notification['node_type'] == "post_comment") {
                            $notification['url'] = $system['system_url'].'/posts/'.$notification['node_url'].$notification['notify_id'];
                            $notification['message'] = __("likes your comment");

                        } elseif ($notification['node_type'] == "photo_comment") {
                            $notification['url'] = $system['system_url'].'/photos/'.$notification['node_url'].$notification['notify_id'];
                            $notification['message'] = __("likes your comment");
                        
                        } elseif ($notification['node_type'] == "post_reply") {
                            $notification['url'] = $system['system_url'].'/posts/'.$notification['node_url'].$notification['notify_id'];
                            $notification['message'] = __("likes your reply");

                        } elseif ($notification['node_type'] == "photo_reply") {
                            $notification['url'] = $system['system_url'].'/photos/'.$notification['node_url'].$notification['notify_id'];
                            $notification['message'] = __("likes your reply");
                        }
                        break;

                    case 'comment':
                        $notification['icon'] = "fa-comment";
                        if($notification['node_type'] == "post") {
                            $notification['url'] = $system['system_url'].'/posts/'.$notification['node_url'].$notification['notify_id'];
                            $notification['message'] = __("commented on your post");

                        } elseif ($notification['node_type'] == "photo") {
                            $notification['url'] = $system['system_url'].'/photos/'.$notification['node_url'].$notification['notify_id'];
                            $notification['message'] = __("commented on your photo");
                        }
                        break;

                    case 'reply':
                        $notification['icon'] = "fa-comment";
                        if($notification['node_type'] == "post") {
                            $notification['url'] = $system['system_url'].'/posts/'.$notification['node_url'].$notification['notify_id'];

                        } elseif ($notification['node_type'] == "photo") {
                            $notification['url'] = $system['system_url'].'/photos/'.$notification['node_url'].$notification['notify_id'];
                        }
                        $notification['message'] = __("replied to your comment");
                        break;

                    case 'share':
                        $notification['icon'] = "fa-share";
                        $notification['url'] = $system['system_url'].'/posts/'.$notification['node_url'];
                        $notification['message'] = __("shared your post");
                        break;

                    case 'vote':
                        $notification['icon'] = "fa-check-circle";
                        $notification['url'] = $system['system_url'].'/posts/'.$notification['node_url'];
                        $notification['message'] = __("voted on your poll");
                        break;

                    case 'mention':
                        $notification['icon'] = "fa-comment";
                        switch ($notification['node_type']) {
                            case 'post':
                                $notification['url'] = $system['system_url'].'/posts/'.$notification['node_url'];
                                $notification['message'] = __("mentioned you in a post");
                                break;
                            
                            case 'comment_post':
                                $notification['url'] = $system['system_url'].'/posts/'.$notification['node_url'].$notification['notify_id'];
                                $notification['message'] = __("mentioned you in a comment");
                                break;

                            case 'comment_photo':
                                $notification['url'] = $system['system_url'].'/photos/'.$notification['node_url'].$notification['notify_id'];
                                $notification['message'] = __("mentioned you in a comment");
                                break;

                            case 'reply_post':
                                $notification['url'] = $system['system_url'].'/posts/'.$notification['node_url'].$notification['notify_id'];
                                $notification['message'] = __("mentioned you in a reply");
                                break;

                            case 'reply_photo':
                                $notification['url'] = $system['system_url'].'/photos/'.$notification['node_url'].$notification['notify_id'];
                                $notification['message'] = __("mentioned you in a reply");
                                break;
                        }
                        break;

                    case 'profile_visit':
                        $notification['icon'] = "fa-eye";
                        $notification['url'] = $system['system_url'].'/'.$notification['user_name'];
                        $notification['message'] = __("visited your profile");
                        break;

                    case 'wall':
                        $notification['icon'] = "fa-comment";
                        $notification['url'] = $system['system_url'].'/posts/'.$notification['node_url'];
                        $notification['message'] = __("posted on your wall");
                        break;

                    case 'page_invitation':
                        $notification['icon'] = "fa-flag";
                        $notification['url'] = $system['system_url'].'/pages/'.$notification['node_url'];
                        $notification['message'] = __("invite you to like a page")." '".html_entity_decode($notification['node_type'], ENT_QUOTES)."'";
                        break;

                    case 'page_admin_addation':
                        $notification['icon'] = "fa-users";
                        $notification['url'] = $system['system_url'].'/pages/'.$notification['node_url'];
                        $notification['message'] = __("added you as admin to")." '".html_entity_decode($notification['node_type'], ENT_QUOTES)."' ".__("page");
                        break;

                    case 'group_join':
                        $notification['icon'] = "fa-users";
                        $notification['url'] = $system['system_url'].'/groups/'.$notification['node_url'].'/settings/requests';
                        $notification['message'] = __("asked to join your group")." '".html_entity_decode($notification['node_type'], ENT_QUOTES)."'";
                        break;

                    case 'group_add':
                        $notification['icon'] = "fa-users";
                        $notification['url'] = $system['system_url'].'/groups/'.$notification['node_url'];
                        $notification['message'] = __("added you to")." '".html_entity_decode($notification['node_type'], ENT_QUOTES)."' ".__("group");
                        break;

                    case 'group_accept':
                        $notification['icon'] = "fa-users";
                        $notification['url'] = $system['system_url'].'/groups/'.$notification['node_url'];
                        $notification['message'] = __("accepted your request to join")." '".html_entity_decode($notification['node_type'], ENT_QUOTES)."' ".__("group");
                        break;

                    case 'group_admin_addation':
                        $notification['icon'] = "fa-users";
                        $notification['url'] = $system['system_url'].'/groups/'.$notification['node_url'];
                        $notification['message'] = __("added you as admin to")." '".html_entity_decode($notification['node_type'], ENT_QUOTES)."' ".__("group");
                        break;

                    case 'event_invitation':
                        $notification['icon'] = "fa-calendar";
                        $notification['url'] = $system['system_url'].'/events/'.$notification['node_url'];
                        $notification['message'] = __("invite you to join an event")." '".html_entity_decode($notification['node_type'], ENT_QUOTES)."'";
                        break;

                    case 'forum_reply':
                        $notification['icon'] = "fa-comment";
                        $notification['url'] = $system['system_url'].'/forums/thread/'.$notification['node_url'];
                        $notification['message'] = __("replied to your thread");
                        break;

                    case 'money_sent':
                        $notification['icon'] = "fa-gift";
                        $notification['url'] = $system['system_url'].'/wallet';
                        $notification['message'] = __("sent you ").$system['system_currency_symbol'].$notification['node_type'];
                        break;
                }
                /* prepare message */
                $notification['full_message'] = $notification['user_firstname']." ".$notification['user_lastname']." ".html_entity_decode($notification['message'], ENT_QUOTES);
                $notifications[] = $notification;
            }
        }
        return $notifications;
    }


    /**
     * post_notification
     * 
     * @param integer $to_user_id
     * @param string $action
     * @param string $node_type
     * @param string $node_url
     * @param string $notify_id
     * @return void
     */
    public function post_notification($args = []) {
        global $db, $date, $system;
        /* initialize arguments */
        $to_user_id = !isset($args['to_user_id']) ? _error(400) : $args['to_user_id'];
        $from_user_id = !isset($args['from_user_id']) ? $this->_data['user_id'] : $args['from_user_id'];
        $action = !isset($args['action']) ? _error(400) : $args['action'];
        $node_type = !isset($args['node_type']) ? '' : $args['node_type'];
        $node_url = !isset($args['node_url']) ? '' : $args['node_url'];
        $notify_id = !isset($args['notify_id']) ? '' : $args['notify_id'];
        /* if the viewer is the target */
        if($this->_data['user_id'] == $to_user_id) {
            return;
        }
        /* get receiver user */
        $get_receiver = $db->query(sprintf("SELECT * FROM users WHERE user_id = %s", secure($to_user_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        if($get_receiver->num_rows == 0) {
            return;
        }
        /* insert notification */
        $db->query(sprintf("INSERT INTO notifications (to_user_id, from_user_id, action, node_type, node_url, notify_id, time) VALUES (%s, %s, %s, %s, %s, %s, %s)", secure($to_user_id, 'int'), secure($from_user_id, 'int'), secure($action), secure($node_type), secure($node_url), secure($notify_id), secure($date) )) or _error(SQL_ERROR_THROWEN);
        /* update notifications counter +1 */
        $db->query(sprintf("UPDATE users SET user_live_notifications_counter = user_live_notifications_counter + 1 WHERE user_id = %s", secure($to_user_id, 'int') )) or _error(SQL_ERROR_THROWEN);

        // email notifications 
        if($system['email_notifications']) {
            /* prepare receiver */
            $receiver = $get_receiver->fetch_assoc();
            /* parse notification */
            $notify_id = ($notify_id != '')? "?notify_id=".$notify_id : "";
            switch ($action) {
                case 'friend_add':
                    if($system['email_friend_requests'] && $receiver['email_friend_requests']) {
                        $notification['url'] = $system['system_url'].'/'.$node_url;
                        $notification['message'] = __("sent you a friend request");
                    }
                    break;

                case 'friend_accept':
                    if($system['email_friend_requests'] && $receiver['email_friend_requests']) {
                        $notification['url'] = $system['system_url'].'/'.$node_url;
                        $notification['message'] = __("accepted your friend request");
                    }
                    break;

                case 'like':
                    if($system['email_post_likes'] && $receiver['email_post_likes']) {
                        if($node_type == "post") {
                            $notification['url'] = $system['system_url'].'/posts/'.$node_url;
                            $notification['message'] = __("likes your post");

                        } elseif ($node_type == "photo") {
                            $notification['url'] = $system['system_url'].'/photos/'.$node_url;
                            $notification['message'] = __("likes your photo");

                        } elseif ($node_type == "post_comment") {
                            $notification['url'] = $system['system_url'].'/posts/'.$node_url.$notify_id;
                            $notification['message'] = __("likes your comment");

                        } elseif ($node_type == "photo_comment") {
                            $notification['url'] = $system['system_url'].'/photos/'.$node_url.$notify_id;
                            $notification['message'] = __("likes your comment");

                        } elseif ($node_type == "post_reply") {
                            $notification['url'] = $system['system_url'].'/posts/'.$node_url.$notify_id;
                            $notification['message'] = __("likes your reply");

                        } elseif ($node_type == "photo_reply") {
                            $notification['url'] = $system['system_url'].'/photos/'.$node_url.$notify_id;
                            $notification['message'] = __("likes your reply");
                        }
                    }
                    break;

                case 'comment':
                    if($system['email_post_comments'] && $receiver['email_post_comments']) {
                        if($node_type == "post") {
                            $notification['url'] = $system['system_url'].'/posts/'.$node_url.$notify_id;
                            $notification['message'] = __("commented on your post");

                        } elseif ($node_type == "photo") {
                            $notification['url'] = $system['system_url'].'/photos/'.$node_url.$notify_id;
                            $notification['message'] = __("commented on your photo");
                        }
                    }
                    break;

                case 'reply':
                    if($system['email_post_comments'] && $receiver['email_post_comments']) {
                        if($node_type == "post") {
                            $notification['url'] = $system['system_url'].'/posts/'.$node_url.$notify_id;

                        } elseif ($node_type == "photo") {
                            $notification['url'] = $system['system_url'].'/photos/'.$node_url.$notify_id;
                        }
                        $notification['message'] = __("replied to your comment");
                    }
                    break;

                case 'share':
                    if($system['email_post_shares'] && $receiver['email_post_shares']) {
                        $notification['url'] = $system['system_url'].'/posts/'.$node_url;
                        $notification['message'] = __("shared your post");
                    }
                    break;

                case 'mention':
                    if($system['email_mentions'] && $receiver['email_mentions']) {
                        $notification['icon'] = "fa-comment";
                        switch ($node_type) {
                            case 'post':
                                $notification['url'] = $system['system_url'].'/posts/'.$node_url;
                                $notification['message'] = __("mentioned you in a post");
                                break;
                            
                            case 'comment_post':
                                $notification['url'] = $system['system_url'].'/posts/'.$node_url.$notify_id;
                                $notification['message'] = __("mentioned you in a comment");
                                break;

                            case 'comment_photo':
                                $notification['url'] = $system['system_url'].'/photos/'.$node_url.$notify_id;
                                $notification['message'] = __("mentioned you in a comment");
                                break;

                            case 'reply_post':
                                $notification['url'] = $system['system_url'].'/posts/'.$node_url.$notify_id;
                                $notification['message'] = __("mentioned you in a reply");
                                break;

                            case 'reply_photo':
                                $notification['url'] = $system['system_url'].'/photos/'.$node_url.$notify_id;
                                $notification['message'] = __("mentioned you in a reply");
                                break;
                        }
                    }
                    break;

                case 'profile_visit':
                    if($system['email_profile_visits'] && $receiver['email_profile_visits']) {
                        $notification['url'] = $system['system_url'].'/'.$this->_data['user_name'];
                        $notification['message'] = __("visited your profile");
                    }
                    break;

                case 'wall':
                    if($system['email_wall_posts'] && $receiver['email_wall_posts']) {
                        $notification['url'] = $system['system_url'].'/posts/'.$node_url;
                        $notification['message'] = __("posted on your wall");
                    }
                    break;

                default:
                    return;
                    break;
            }
            /* prepare notification email */
            if($notification['message']) {
                $subject = __("New notification from")." ".$system['system_title'];
                $body  = __("Hi")." ".ucwords(html_entity_decode($receiver['user_firstname'], ENT_QUOTES)." ".html_entity_decode($receiver['user_lastname'], ENT_QUOTES)).",";
                $body .= "\r\n\r\n".$this->_data['user_firstname']." ".$this->_data['user_lastname']." ".$notification['message'];
                $body .= "\r\n\r\n".$notification['url'];
                $body .= "\r\n\r".$system['system_title']." ".__("Team");
                /* send email */
                _email($receiver['user_email'], $subject, $body);
            }
        }
    }


    /**
     * post_mass_notification
     * 
     * @param string $url
     * @param string $message
     * @return void
     */
    public function post_mass_notification($url, $message) {
        global $db, $date;
        /* insert notification */
        $db->query(sprintf("INSERT INTO notifications (to_user_id, from_user_id, action, node_type, node_url, message, time, seen) VALUES ('0', %s, 'mass_notification', 'notification', %s, %s, %s, '1')", secure($this->_data['user_id']), secure($url), secure($message), secure($date) )) or _error(SQL_ERROR_THROWEN);
        /* update notifications counter +1 */
        $db->query(sprintf("UPDATE users SET user_live_notifications_counter = user_live_notifications_counter + 1")) or _error(SQL_ERROR_THROWEN);
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
    public function delete_notification($to_user_id, $action, $node_type = '', $node_url = '') {
        global $db;
        /* delete notification */
        $db->query(sprintf("DELETE FROM notifications WHERE to_user_id = %s AND from_user_id = %s AND action = %s AND node_type = %s AND node_url = %s", secure($to_user_id, 'int'), secure($this->_data['user_id'], 'int'), secure($action), secure($node_type), secure($node_url) )) or _error(SQL_ERROR_THROWEN);
        /* update notifications counter -1 */
        $db->query(sprintf("UPDATE users SET user_live_notifications_counter = IF(user_live_notifications_counter=0,0,user_live_notifications_counter-1) WHERE user_id = %s", secure($to_user_id, 'int') )) or _error(SQL_ERROR_THROWEN);
    }



    /* ------------------------------- */
    /* Chat */
    /* ------------------------------- */

    /**
     * user_online
     * 
     * @param integer $user_id
     * @return boolean
     */
    public function user_online($user_id) {
        global $db, $system;
        /* check if the target user is a friend to the viewer */
        if(!in_array($user_id, $this->_data['friends_ids'])) {
            /* if no > return false */
            return false;
        }
        /* check if the target user is online & enable the chat */
        $get_user_status = $db->query(sprintf("SELECT * FROM users WHERE user_id = %s AND user_chat_enabled = '1' AND user_last_seen >= SUBTIME(NOW(), SEC_TO_TIME(%s))", secure($user_id, 'int'), secure($system['offline_time'], 'int', false) )) or _error(SQL_ERROR_THROWEN);
        if($get_user_status->num_rows == 0) {
            /* if no > return false */
            return false;
        }
        return true;
    }


    /**
     * get_online_friends
     * 
     * @return array
     */
    public function get_online_friends() {
        global $db, $system;
        /* get online friends */
        $online_friends = array();
        /* check if the viewer has friends */
        if(!$this->_data['friends_ids']) {
            return $online_friends;
        }
        /* make a list from viewer's friends */
        $friends_list = implode(',', $this->_data['friends_ids']);
        $get_online_friends = $db->query(sprintf("SELECT * FROM users WHERE user_last_seen >= SUBTIME(NOW(), SEC_TO_TIME(%s)) AND user_chat_enabled = '1' AND user_id IN (%s)", secure($system['offline_time'], 'int', false), $friends_list )) or _error(SQL_ERROR_THROWEN);
        if($get_online_friends->num_rows > 0) {
            while($online_friend = $get_online_friends->fetch_assoc()) {
                $online_friend['user_picture'] = get_picture($online_friend['user_picture'], $online_friend['user_gender']);
                $online_friend['user_is_online'] = '1';
                $online_friends[] = $online_friend;
            }
        }
        return $online_friends;
    }


    /**
     * get_offline_friends
     * 
     * @return array
     */
    public function get_offline_friends() {
        global $db, $system;
        /* get offline friends */
        $offline_friends = array();
        /* check if the viewer has friends */
        if(!$this->_data['friends_ids']) {
            return $offline_friends;
        }
        /* make a list from viewer's friends */
        $friends_list = implode(',', $this->_data['friends_ids']);
        $get_offline_friends = $db->query(sprintf("SELECT * FROM users WHERE user_last_seen < SUBTIME(NOW(), SEC_TO_TIME(%s)) AND user_id IN (%s)", secure($system['offline_time'], 'int', false), $friends_list )) or _error(SQL_ERROR_THROWEN);
        if($get_offline_friends->num_rows > 0) {
            while($offline_friend = $get_offline_friends->fetch_assoc()) {
                $offline_friend['user_picture'] = get_picture($offline_friend['user_picture'], $offline_friend['user_gender']);
                $offline_friend['user_is_online'] = '0';
                $offline_friends[] = $offline_friend;
            }
        }
        return $offline_friends;
    }
    

    /**
     * get_conversations_new
     * 
     * @return array
     */
    public function get_conversations_new() {
        global $db;
        $conversations = array();
        if(!empty($_SESSION['chat_boxes_opened'])) {
            /* make list from opened chat boxes keys (conversations ids) */
            $chat_boxes_opened_list = implode(',',$_SESSION['chat_boxes_opened']);
            $get_conversations = $db->query(sprintf("SELECT conversation_id FROM conversations_users WHERE user_id = %s AND seen = '0' AND deleted = '0' AND conversation_id NOT IN (%s)", secure($this->_data['user_id'], 'int'), $chat_boxes_opened_list )) or _error(SQL_ERROR_THROWEN);
        } else {
            $get_conversations = $db->query(sprintf("SELECT conversation_id FROM conversations_users WHERE user_id = %s AND seen = '0' AND deleted = '0'", secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
        }
        if($get_conversations->num_rows > 0) {
            while($conversation = $get_conversations->fetch_assoc()) {
                $db->query(sprintf("UPDATE conversations_users SET seen = '1' WHERE conversation_id = %s AND user_id = %s", secure($conversation['conversation_id'], 'int'), secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                $conversations[] = $this->get_conversation($conversation['conversation_id']);
            }
        }
        return $conversations;
    }

    
    /**
     * get_conversations
     * 
     * @param integer $offset
     * @return array
     */
    public function get_conversations($offset = 0) {
        global $db, $system;
        $conversations = array();
        $offset *= $system['max_results'];
        $get_conversations = $db->query(sprintf("SELECT conversations.conversation_id FROM conversations INNER JOIN conversations_users ON conversations.conversation_id = conversations_users.conversation_id WHERE conversations_users.deleted = '0' AND conversations_users.user_id = %s ORDER BY conversations.last_message_id DESC LIMIT %s, %s", secure($this->_data['user_id'], 'int'), secure($offset, 'int', false), secure($system['max_results'], 'int', false) )) or _error(SQL_ERROR_THROWEN);
        if($get_conversations->num_rows > 0) {
            while($conversation = $get_conversations->fetch_assoc()) {
                $conversation = $this->get_conversation($conversation['conversation_id']);
                if($conversation) {
                    $conversations[] = $conversation;
                }
            }
        }
        return $conversations;
    }


    /**
     * get_conversation
     * 
     * @param integer $conversation_id
     * @return array
     */
    public function get_conversation($conversation_id) {
        global $db;
        $conversation = array();
        $get_conversation = $db->query(sprintf("SELECT conversations.*, conversations_messages.message, conversations_messages.image, conversations_messages.time, conversations_users.seen FROM conversations INNER JOIN conversations_messages ON conversations.last_message_id = conversations_messages.message_id INNER JOIN conversations_users ON conversations.conversation_id = conversations_users.conversation_id WHERE conversations_users.user_id = %s AND conversations.conversation_id = %s", secure($this->_data['user_id'], 'int'), secure($conversation_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        if($get_conversation->num_rows == 0) {
            return false;
        }
        $conversation = $get_conversation->fetch_assoc();
        /* get recipients */
        $get_recipients = $db->query(sprintf("SELECT users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM conversations_users INNER JOIN users ON conversations_users.user_id = users.user_id WHERE conversations_users.conversation_id = %s AND conversations_users.user_id != %s", secure($conversation['conversation_id'], 'int'), secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
        $recipients_num = $get_recipients->num_rows;
        if($recipients_num == 0) {
            return false;
        }
        $i = 1;
        while($recipient = $get_recipients->fetch_assoc()) {
            $recipient['user_picture'] = get_picture($recipient['user_picture'], $recipient['user_gender']);
            $conversation['recipients'][] = $recipient;
            $conversation['name_list'] .= $recipient['user_firstname'];
            if($i < $recipients_num) {
                $conversation['name_list'] .= ", ";
            }
            $i++;
        }
        /* prepare conversation with multiple_recipients */
        if($recipients_num > 1) {
            /* multiple recipients */
            $conversation['multiple_recipients'] = true;
            $conversation['link'] = $conversation['conversation_id'];
            $conversation['picture_left'] = $conversation['recipients'][0]['user_picture'];
            $conversation['picture_right'] = $conversation['recipients'][1]['user_picture'];
            if($recipients_num > 2) {
                $conversation['name'] = $conversation['recipients'][0]['user_firstname'].", ".$conversation['recipients'][1]['user_firstname']." & ".($recipients_num - 2)." ".__("more");
            } else {
                $conversation['name'] = $conversation['recipients'][0]['user_firstname']." & ".$conversation['recipients'][1]['user_firstname'];
            }
        } else {
            /* one recipient */
            $conversation['multiple_recipients'] = false;
            $conversation['user_id'] = $conversation['recipients'][0]['user_id'];
            $conversation['link'] = $conversation['recipients'][0]['user_name'];
            $conversation['picture'] = $conversation['recipients'][0]['user_picture'];
            $conversation['name'] = html_entity_decode($conversation['recipients'][0]['user_firstname']." ".$conversation['recipients'][0]['user_lastname']);
            $conversation['name_html'] = popover($conversation['recipients'][0]['user_id'], $conversation['recipients'][0]['user_name'], $conversation['recipients'][0]['user_firstname']." ".$conversation['recipients'][0]['user_lastname']);
        }
        /* get total number of messages */
        $conversation['total_messages'] = $this->get_conversation_total_messages($conversation_id);
        /* decode message text */
        $conversation['message_orginal'] = $this->decode_emoji($conversation['message']);
        $conversation['message'] = $this->_parse($conversation['message'], true, false);
        /* return */
        return $conversation;
    }


    /**
     * get_mutual_conversation
     * 
     * @param array $recipients
     * @param boolean $check_deleted
     * @return integer
     */
    public function get_mutual_conversation($recipients, $check_deleted = false) {
        global $db;
        $recipients_array = (array)$recipients;
        $recipients_array[] = $this->_data['user_id'];
        $recipients_list = implode(',', $recipients_array);
        $get_mutual_conversations = $db->query(sprintf('SELECT conversation_id FROM conversations_users WHERE user_id IN (%s) GROUP BY conversation_id HAVING COUNT(conversation_id) = %s', $recipients_list, count($recipients_array) )) or _error(SQL_ERROR_THROWEN);
        if($get_mutual_conversations->num_rows == 0) {
            return false;
        }
        while($mutual_conversation = $get_mutual_conversations->fetch_assoc()) {
            /* get recipients */
            $where_statement = ($check_deleted)? " AND deleted != '1' ": "";
            $get_recipients = $db->query(sprintf("SELECT * FROM conversations_users WHERE conversation_id = %s".$where_statement, secure($mutual_conversation['conversation_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
            if($get_recipients->num_rows == count($recipients_array)) {
                return $mutual_conversation['conversation_id'];
            }
        }
    }


    /**
     * get_conversation_total_messages
     * 
     * @param integer $conversation_id
     * @return integer
     */
    public function get_conversation_total_messages($conversation_id) {
        global $db;
        $get_total_messages = $db->query(sprintf("SELECT * FROM conversations_messages WHERE conversation_id = %s", secure($conversation_id, 'int'))) or _error(SQL_ERROR_THROWEN);
        return $get_total_messages->num_rows;
    }


    /**
     * get_conversation_messages
     * 
     * @param integer $conversation_id
     * @param integer $offset
     * @param integer $last_message_id
     * @return array
     */
    public function get_conversation_messages($conversation_id, $offset = 0, $last_message_id = null) {
        global $db, $system;
        /* check if user authorized */
        $check_conversation = $db->query(sprintf("SELECT * FROM conversations_users WHERE conversation_id = %s AND user_id = %s", secure($conversation_id, 'int'), secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
        if($check_conversation->num_rows == 0) {
            throw new Exception(__("You are not authorized to view this"));
        }
        $offset *= $system['max_results'];
        $messages = array();
        if($last_message_id !== null) {
            /* get all messages after the last_message_id */
            $get_messages = $db->query(sprintf("SELECT conversations_messages.message_id, conversations_messages.message, conversations_messages.image, conversations_messages.time, users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM conversations_messages INNER JOIN users ON conversations_messages.user_id = users.user_id WHERE conversations_messages.conversation_id = %s AND conversations_messages.message_id > %s", secure($conversation_id, 'int'), secure($last_message_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        } else {
            $get_messages = $db->query(sprintf("SELECT * FROM ( SELECT conversations_messages.message_id, conversations_messages.message, conversations_messages.image, conversations_messages.time, users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM conversations_messages INNER JOIN users ON conversations_messages.user_id = users.user_id WHERE conversations_messages.conversation_id = %s ORDER BY conversations_messages.message_id DESC LIMIT %s,%s ) messages ORDER BY messages.message_id ASC", secure($conversation_id, 'int'), secure($offset, 'int', false), secure($system['max_results'], 'int', false) )) or _error(SQL_ERROR_THROWEN);
        }
        while($message = $get_messages->fetch_assoc()) {
            $message['user_picture'] = get_picture($message['user_picture'], $message['user_gender']);
            $message['message'] = $this->_parse($message['message'], true, false);
            /* return */
            $messages[] = $message;
        }
        return $messages;
    }


    /**
     * post_conversation_message
     * 
     * @param string $message
     * @param string $image
     * @param integer $conversation_id
     * @param array $recipients
     * @return array
     */
    public function post_conversation_message($message, $image, $conversation_id = null, $recipients = null) {
        global $db, $system, $date;
        /* check if posting the message to (new || existed) conversation */
        if($conversation_id == null) {
            /* [first] check previous conversation between (viewer & recipients) */
            $mutual_conversation = $this->get_mutual_conversation($recipients);
            if(!$mutual_conversation) {
                /* [1] there is no conversation between viewer and the recipients -> start new one */
                /* insert conversation */
                $db->query("INSERT INTO conversations (last_message_id) VALUES ('0')") or _error(SQL_ERROR_THROWEN);
                $conversation_id = $db->insert_id;
                /* insert the sender (viewer) */
                $db->query(sprintf("INSERT INTO conversations_users (conversation_id, user_id, seen) VALUES (%s, %s, '1')", secure($conversation_id, 'int'), secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                /* insert recipients */
                foreach($recipients as $recipient) {
                    $db->query(sprintf("INSERT INTO conversations_users (conversation_id, user_id) VALUES (%s, %s)", secure($conversation_id, 'int'), secure($recipient, 'int') )) or _error(SQL_ERROR_THROWEN);
                }
            } else {
                /* [2] there is a conversation between the viewer and the recipients */
                /* set the conversation_id */
                $conversation_id = $mutual_conversation;
            }
        } else {
            /* [3] post the message to -> existed conversation */
            /* check if user authorized */
            $conversation = $this->get_conversation($conversation_id);
            if(!$conversation) {
                throw new Exception(__("You are not authorized to do this"));
            }
            foreach($conversation['recipients'] as $recipient) {
                if($this->blocked($recipient['user_id'])) {
                    modal(MESSAGE, __("Message"), __("You aren't allowed to message")." ".$recipient['user_firstname']." ".$recipient['user_lastname']);
                }
            }
            /* update sender (viewer) as seen and not deleted if any */
            $db->query(sprintf("UPDATE conversations_users SET seen = '1', deleted = '0' WHERE conversation_id = %s AND user_id = %s", secure($conversation_id, 'int'), secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
            /* update recipients as not seen and not deleted if any */
            $db->query(sprintf("UPDATE conversations_users SET seen = '0', deleted = '0' WHERE conversation_id = %s AND user_id != %s", secure($conversation_id, 'int'), secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
        }
        /* insert message */
        $image = ($image != '')? $image : '';
        $db->query(sprintf("INSERT INTO conversations_messages (conversation_id, user_id, message, image, time) VALUES (%s, %s, %s, %s, %s)", secure($conversation_id, 'int'), secure($this->_data['user_id'], 'int'), secure($message), secure($image), secure($date) )) or _error(SQL_ERROR_THROWEN);
        $message_id = $db->insert_id;
        /* update the conversation with last message id */
        $db->query(sprintf("UPDATE conversations SET last_message_id = %s WHERE conversation_id = %s", secure($message_id, 'int'), secure($conversation_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        /* update sender (viewer) with last message id */
        $db->query(sprintf("UPDATE users SET user_live_messages_lastid = %s WHERE user_id = %s", secure($message_id, 'int'), secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
        /* get conversation */
        $conversation = $this->get_conversation($conversation_id);
        /* update all recipients with last message id & only offline recipient messages counter */
        foreach($conversation['recipients'] as $recipient) {
            $db->query(sprintf("UPDATE users SET user_live_messages_lastid = %s, user_live_messages_counter = IF(user_last_seen >= SUBTIME(NOW(), SEC_TO_TIME(%s)), user_live_messages_counter, user_live_messages_counter + 1) WHERE user_id = %s", secure($message_id, 'int'), secure($system['offline_time'], 'int', false), secure($recipient['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
        }
        /* return with conversation */
        return $conversation;       
    }


    /**
     * delete_conversation
     * 
     * @param integer $conversation_id
     * @return void
     */
    public function delete_conversation($conversation_id) {
        global $db;
        /* check if user authorized */
        $check_conversation = $db->query(sprintf("SELECT * FROM conversations_users WHERE conversation_id = %s AND user_id = %s", secure($conversation_id, 'int'), secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
        if($check_conversation->num_rows == 0) {
            throw new Exception(__("You are not authorized to do this"));
        }
        /* update conversation as deleted */
        $db->query(sprintf("UPDATE conversations_users SET deleted = '1' WHERE conversation_id = %s AND user_id = %s", secure($conversation_id, 'int'), secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
    }


    /**
     * get_conversation_color
     * 
     * @param integer $conversation_id
     * @return string
     */
    public function get_conversation_color($conversation_id) {
        global $db;
        $get_conversation = $db->query(sprintf("SELECT color FROM conversations WHERE conversation_id = %s", secure($conversation_id, 'int'))) or _error(SQL_ERROR_THROWEN);
        $conversation = $get_conversation->fetch_assoc();
        return $conversation['color'];
    }


    /**
     * set_conversation_color
     * 
     * @param integer $conversation_id
     * @param string $color
     * @return void
     */
    public function set_conversation_color($conversation_id, $color) {
        global $db;
        /* check if user authorized */
        $check_conversation = $db->query(sprintf("SELECT * FROM conversations_users WHERE conversation_id = %s AND user_id = %s", secure($conversation_id, 'int'), secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
        if($check_conversation->num_rows == 0) {
            _error(403);
        }
        $db->query(sprintf("UPDATE conversations SET color = %s WHERE conversation_id = %s", secure($color), secure($conversation_id, 'int') )) or _error(SQL_ERROR_THROWEN);
    }


    /* ------------------------------- */
    /* Emoji & Stickers */
    /* ------------------------------- */

    /**
     * get_emojis
     * 
     * @return array
     */
    public function get_emojis() {
        global $db;
        $emojis = array();
        $get_emojis = $db->query("SELECT * FROM emojis") or _error(SQL_ERROR_THROWEN);
        if($get_emojis->num_rows > 0) {
            while($emoji = $get_emojis->fetch_assoc()) {
                $emojis[] = $emoji;
            }
        }
        return $emojis;
    }


    /**
     * decode_emoji
     * 
     * @param string $text
     * @return string
     */
    public function decode_emoji($text) {
        global $db;
        $get_emojis = $db->query("SELECT * FROM emojis") or _error(SQL_ERROR_THROWEN);
        if($get_emojis->num_rows > 0) {
            while($emoji = $get_emojis->fetch_assoc()) {
                $replacement = '<i class="twa twa-xlg twa-'.$emoji['class'].'"></i>';
                $pattern = preg_quote($emoji['pattern'], '/');
                $text = preg_replace('/(^|\s)'.$pattern.'/', $replacement, $text);
            }
        }
        return $text;
    }


    /**
     * get_stickers
     * 
     * @return array
     */
    public function get_stickers() {
        global $db;
        $stickers = array();
        $get_stickers = $db->query("SELECT * FROM stickers") or _error(SQL_ERROR_THROWEN);
        if($get_stickers->num_rows > 0) {
            while($sticker = $get_stickers->fetch_assoc()) {
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
    public function decode_stickers($text) {
        global $db, $system;
        $get_stickers = $db->query("SELECT * FROM stickers") or _error(SQL_ERROR_THROWEN);
        if($get_stickers->num_rows > 0) {
            while($sticker = $get_stickers->fetch_assoc()) {
                $replacement = '<img class="" src="'.$system['system_uploads'].'/'.$sticker['image'].'"></i>';
                $text = preg_replace('/(^|\s):STK-'.$sticker['sticker_id'].':/', $replacement, $text);
            }
        }
        return $text;
    }




    /* ------------------------------- */
    /* @Mentions */
    /* ------------------------------- */

    /**
     * get_mentions
     * 
     * @param array $matches
     * @return string
     */
    public function get_mentions($matches) {
        global $db;
        $get_user = $db->query(sprintf("SELECT user_id, user_name, user_firstname, user_lastname FROM users WHERE user_name = %s", secure($matches[1]) )) or _error(SQL_ERROR_THROWEN);
        if($get_user->num_rows > 0) {
            $user = $get_user->fetch_assoc();
            $replacement = popover($user['user_id'], $user['user_name'], $user['user_firstname']." ".$user['user_lastname']);
        }else {
            $replacement = $matches[0];
        }
        return $replacement;
    }


    /**
     * post_mentions
     * 
     * @param string $text
     * @param integer $node_url
     * @param string $node_type
     * @param string $notify_id
     * @param array $excluded_ids
     * @return void
     */
    public function post_mentions($text, $node_url, $node_type = 'post', $notify_id = '', $excluded_ids = array()) {
        global $db;
        $where_query = "";
        if($excluded_ids) {
            $excluded_list = implode(',',$excluded_ids);
            $where_query = " user_id NOT IN ($excluded_list) AND ";
        }
        $done = array();
        if(preg_match_all('/\[([a-zA-Z0-9._]+)\]/', $text, $matches)) {
            foreach ($matches[1] as $username) {
                if($this->_data['user_name'] != $username && !in_array($username, $done)) {
                    $get_user = $db->query(sprintf("SELECT user_id FROM users WHERE ".$where_query." user_name = %s", secure($username) )) or _error(SQL_ERROR_THROWEN);
                    if($get_user->num_rows > 0) {
                        $_user = $get_user->fetch_assoc();
                        $this->post_notification( array('to_user_id'=>$_user['user_id'], 'action'=>'mention', 'node_type'=>$node_type, 'node_url'=>$node_url, 'notify_id'=>$notify_id) );
                        $done[] = $username;
                    }
                }
            }
        }
    }



    /* ------------------------------- */
    /* Popovers */
    /* ------------------------------- */

    /**
     * popover
     * 
     * @param integer $id
     * @param string $type
     * @return array
     */
    public function popover($id, $type) {
        global $db;
        $profile = array();
        /* check the type to get */
        if($type == "user") {
            /* get user info */
            $get_profile = $db->query(sprintf("SELECT * FROM users WHERE user_id = %s", secure($id, 'int'))) or _error(SQL_ERROR_THROWEN);
            if($get_profile->num_rows > 0) {
                $profile = $get_profile->fetch_assoc();
                /* get profile picture */
                $profile['user_picture'] = get_picture($profile['user_picture'], $profile['user_gender']);
                /* get followers count */
                $profile['followers_count'] = count($this->get_followers_ids($profile['user_id']));
                /* get mutual friends count between the viewer and the target */
                if($this->_logged_in && $this->_data['user_id'] != $profile['user_id']) {
                    $profile['mutual_friends_count'] = $this->get_mutual_friends_count($profile['user_id']);
                }
                /* get the connection between the viewer & the target */
                if($profile['user_id'] != $this->_data['user_id']) {
                    $profile['we_friends'] = (in_array($profile['user_id'], $this->_data['friends_ids']))? true: false;
                    $profile['he_request'] = (in_array($profile['user_id'], $this->_data['friend_requests_ids']))? true: false;
                    $profile['i_request'] = (in_array($profile['user_id'], $this->_data['friend_requests_sent_ids']))? true: false;
                    $profile['i_follow'] = (in_array($profile['user_id'], $this->_data['followings_ids']))? true: false;
                }
            }
        } else {
            /* get page info */
            $get_profile = $db->query(sprintf("SELECT * FROM pages WHERE page_id = %s", secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
            if($get_profile->num_rows > 0) {
                $profile = $get_profile->fetch_assoc();
                $profile['page_picture'] = get_picture($profile['page_picture'], "page");
                /* get the connection between the viewer & the target */
                $get_likes = $db->query(sprintf("SELECT * FROM pages_likes WHERE page_id = %s AND user_id = %s", secure($id, 'int'), secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                if($get_likes->num_rows > 0) {
                    $profile['i_like'] = true;
                } else {
                    $profile['i_like'] = false;
                }
            }
        }
        return $profile;
    }



    /* ------------------------------- */
    /* Stories */
    /* ------------------------------- */

    /**
     * get_stories
     * 
     * @return array
     */
    public function get_stories() {
        global $db, $system, $smarty;
        $stories = array();
        /* get stories */
        $authors = $this->_data['friends_ids'];
        /* add viewer to this list */
        $authors[] = $this->_data['user_id'];
        $friends_list = implode(',',$authors);
        $get_stories = $db->query("SELECT stories.*, users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM stories INNER JOIN users ON stories.user_id = users.user_id WHERE time>=DATE_SUB(NOW(), INTERVAL 1 DAY) AND stories.user_id IN ($friends_list) ORDER BY stories.story_id DESC") or _error(SQL_ERROR_THROWEN);
        if($get_stories->num_rows > 0) {
            while($_story = $get_stories->fetch_assoc()) {
                $story['id'] = $_story['story_id'];
                $story['photo'] = get_picture($_story['user_picture'], $_story['user_gender']);
                $story['name'] = $_story['user_firstname']." ".$_story['user_lastname'];
                $story['lastUpdated'] = strtotime($_story['time']);
                $story['items'] = array();
                /* get story media items */
                $get_media_items = $db->query(sprintf("SELECT * FROM stories_media WHERE story_id = %s", secure($_story['story_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                while($media_item = $get_media_items->fetch_assoc()) {
                    $story_item['id'] = $media_item['media_id'];
                    $story_item['type'] = ($media_item['is_photo'])? 'photo' : 'video';
                    $story_item['src'] = $system['system_uploads'].'/'.$media_item['source'];
                    $story_item['link'] = '#';
                    $story_item['linkText'] = $media_item['text'];
                    $story_item['time'] = strtotime($media_item['time']);
                    $story['items'][] = $story_item;
                }
                $stories[] = $story;
            }
        }
        return array("array"=> $stories, "json" => json_encode($stories));
    }


    /**
     * post_story
     * 
     * @param string $message
     * @param array $photos
     * @param array $videos
     * @return void
     */
    public function post_story($message, $photos, $videos) {
        global $db, $system, $date;
        /* check latest story */
        $get_last_story = $db->query(sprintf("SELECT * FROM stories WHERE time>=DATE_SUB(NOW(), INTERVAL 1 DAY) AND stories.user_id = %s", secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
        if($get_last_story->num_rows > 0) {
            /* update latest story */
            $last_story = $get_last_story->fetch_assoc();
            /* get story_id */
            $story_id = $last_story['story_id'];
            /* update story time */
            $db->query(sprintf("UPDATE stories SET time = %s WHERE story_id = %s", secure($date), secure($story_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        } else {
            /* insert new story */
            $db->query(sprintf("INSERT INTO stories (user_id, time) VALUES (%s, %s)", secure($this->_data['user_id'], 'int'), secure($date) )) or _error(SQL_ERROR_THROWEN);
            /* get story_id */
            $story_id = $db->insert_id;
        }
        /* insert story media items */
        foreach($photos as $photo) {
            $db->query(sprintf("INSERT INTO stories_media (story_id, source, text, time) VALUES (%s, %s, %s, %s)", secure($story_id, 'int'), secure($photo), secure($message), secure($date) )) or _error(SQL_ERROR_THROWEN);
        }
        foreach($videos as $video) {
            $db->query(sprintf("INSERT INTO stories_media (story_id, source, is_photo, text, time) VALUES (%s, %s, '0', %s, %s)", secure($story_id, 'int'), secure($video), secure($message), secure($date) )) or _error(SQL_ERROR_THROWEN);
        }
    }



    /* ------------------------------- */
    /* Publisher */
    /* ------------------------------- */

    /**
     * publisher
     * 
     * @param array $args
     * @return array
     */
    public function publisher($args = []) {
        global $db, $system, $date;
        $post = array();

        /* default */
        $post['user_id'] = $this->_data['user_id'];
        $post['user_type'] = "user";
        $post['in_wall'] = 0;
        $post['wall_id'] = null;
        $post['in_group'] = 0;
        $post['group_id'] = null;
        $post['in_event'] = 0;
        $post['event_id'] = null;

        $post['author_id'] = $this->_data['user_id'];
        $post['post_author_picture'] = $this->_data['user_picture'];
        $post['post_author_url'] = $system['system_url'].'/'.$this->_data['user_name'];
        $post['post_author_name'] = $this->_data['user_firstname']." ".$this->_data['user_lastname'];
        $post['post_author_verified'] = $this->_data['user_verified'];

        /* check the user_type */
        if($args['handle'] == "user") {
            /* check if system allow wall posts */
            if(!$system['wall_posts_enabled']) {
                _error(400);
            }
            /* check if the user is valid & the viewer can post on his wall */
            $check_user = $db->query(sprintf("SELECT * FROM users WHERE user_id = %s",secure($args['id'], 'int'))) or _error(SQL_ERROR_THROWEN);
            if($check_user->num_rows == 0) {
                _error(400);
            }
            $_user = $check_user->fetch_assoc();
            if($_user['user_privacy_wall'] == 'me' || ($_user['user_privacy_wall'] == 'friends' && !in_array($args['id'], $this->_data['friends_ids'])) ) {
                _error(400);
            }
            $post['in_wall'] = 1;
            $post['wall_id'] = $args['id'];
            $post['wall_username'] = $_user['user_name'];
            $post['wall_fullname'] = $_user['user_firstname']." ".$_user['user_lastname'];

        } elseif ($args['handle'] == "page") {
            /* check if the page is valid */
            $check_page = $db->query(sprintf("SELECT * FROM pages WHERE page_id = %s", secure($args['id'], 'int') )) or _error(SQL_ERROR_THROWEN);
            if($check_page->num_rows == 0) {
                _error(400);
            }
            $_page = $check_page->fetch_assoc();
            /* check if the viewer is the admin */
            if(!$this->check_page_adminship($this->_data['user_id'], $args['id'])) {
                _error(400);
            }

            $post['user_id'] = $_page['page_id'];
            $post['user_type'] = "page";
            $post['post_author_picture'] = get_picture($_page['page_picture'], "page");
            $post['post_author_url'] = $system['system_url'].'/pages/'.$_page['page_name'];
            $post['post_author_name'] = $_page['page_title'];
            $post['post_author_verified'] = $this->_data['page_verified'];

        } elseif ($args['handle'] == "group") {
            /* check if the group is valid & the viewer is group member (approved) */
            $check_group = $db->query(sprintf("SELECT groups.* FROM groups INNER JOIN groups_members ON groups.group_id = groups_members.group_id WHERE groups_members.approved = '1' AND groups_members.user_id = %s AND groups_members.group_id = %s", secure($this->_data['user_id'], 'int'), secure($args['id'], 'int') )) or _error(SQL_ERROR_THROWEN);
            $_group = $check_group->fetch_assoc();

            $post['in_group'] = 1;
            $post['group_id'] = $args['id'];

        } elseif ($args['handle'] == "event") {
            /* check if the event is valid & the viewer is event member */
            $check_event = $db->query(sprintf("SELECT events.* FROM events INNER JOIN events_members ON events.event_id = events_members.event_id WHERE events_members.user_id = %s AND events_members.event_id = %s", secure($this->_data['user_id'], 'int'), secure($args['id'], 'int') )) or _error(SQL_ERROR_THROWEN);
            $_event = $check_event->fetch_assoc();

            $post['in_event'] = 1;
            $post['event_id'] = $args['id'];
        }

        /* prepare post data */
        $post['text'] = $args['message'];
        $post['time'] = $date;
        $post['location'] = (!is_empty($args['location']) && valid_location($args['location']))? $args['location']: '';
        $post['privacy'] = $args['privacy'];
        $post['likes'] = 0;
        $post['comments'] = 0;
        $post['shares'] = 0;

        /* post feeling */
        $post['feeling_action'] = '';
        $post['feeling_value'] = '';
        $post['feeling_icon'] = '';
        if(!is_empty($args['feeling_action']) && !is_empty($args['feeling_value'])) {
            if($args['feeling_action'] != "Feeling") {
                $_feeling_icon = get_feeling_icon($args['feeling_action'], get_feelings());
            } else {
                $_feeling_icon = get_feeling_icon($args['feeling_value'], get_feelings_types());
            }
            if($_feeling_icon) {
                $post['feeling_action'] = $args['feeling_action'];
                $post['feeling_value'] = $args['feeling_value'];
                $post['feeling_icon'] = $_feeling_icon;
            }
        }

        /* prepare post type */
        if($args['link']) {
            if($args['link']->source_type == "link") {
                $post['post_type'] = 'link';
            } else {
                $post['post_type'] = 'media';
            }
        } elseif ($args['poll_options']) {
            $post['post_type'] = 'poll';
        } elseif ($args['product']) {
            $post['post_type'] = 'product';
            $post['privacy'] = "public";
        } elseif ($args['video']) {
            $post['post_type'] = 'video';
        } elseif ($args['audio']) {
            $post['post_type'] = 'audio';
        } elseif ($args['file']) {
            $post['post_type'] = 'file';
        } elseif(count($args['photos']) > 0) {
            if(!is_empty($args['album'])) {
                $post['post_type'] = 'album';
            } else {
                $post['post_type'] = 'photos';
            }
        } else {
            if($post['location'] != '') {
                $post['post_type'] = 'map';
            } else {
                $post['post_type'] = '';
            }
        }
        /* insert the post */
        $db->query(sprintf("INSERT INTO posts (user_id, user_type, in_wall, wall_id, in_group, group_id, in_event, event_id, post_type, time, location, privacy, text, feeling_action, feeling_value) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)", secure($post['user_id'], 'int'), secure($post['user_type']), secure($post['in_wall'], 'int'), secure($post['wall_id'], 'int'), secure($post['in_group']), secure($post['group_id'], 'int'), secure($post['in_event']), secure($post['event_id'], 'int'), secure($post['post_type']), secure($post['time']), secure($post['location']), secure($post['privacy']), secure($post['text']), secure($post['feeling_action']), secure($post['feeling_value']) )) or _error(SQL_ERROR_THROWEN);
        $post['post_id'] = $db->insert_id;

        switch ($post['post_type']) {
            case 'link':
                $db->query(sprintf("INSERT INTO posts_links (post_id, source_url, source_host, source_title, source_text, source_thumbnail) VALUES (%s, %s, %s, %s, %s, %s)", secure($post['post_id'], 'int'), secure($args['link']->source_url), secure($args['link']->source_host), secure($args['link']->source_title), secure($args['link']->source_text), secure($args['link']->source_thumbnail) )) or _error(SQL_ERROR_THROWEN);
                $post['link']['link_id'] = $db->insert_id;
                $post['link']['post_id'] = $post['post_id'];
                $post['link']['source_url'] = $args['link']->source_url;
                $post['link']['source_host'] = $args['link']->source_host;
                $post['link']['source_title'] = $args['link']->source_title;
                $post['link']['source_text'] = $args['link']->source_text;
                $post['link']['source_thumbnail'] = $args['link']->source_thumbnail;
                break;

            case 'poll':
                /* insert poll */
                $db->query(sprintf("INSERT INTO posts_polls (post_id) VALUES (%s)", secure($post['post_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                $post['poll']['poll_id'] = $db->insert_id;
                $post['poll']['post_id'] = $post['post_id'];
                $post['poll']['votes'] = '0';
                /* insert poll options */
                foreach($args['poll_options'] as $option) {
                    $db->query(sprintf("INSERT INTO posts_polls_options (poll_id, text) VALUES (%s, %s)", secure($post['poll']['poll_id'], 'int'), secure($option) )) or _error(SQL_ERROR_THROWEN);
                    $poll_option['option_id'] = $db->insert_id;
                    $poll_option['text'] = $option;
                    $poll_option['votes'] = 0;
                    $poll_option['checked'] = false;
                    $post['poll']['options'][] = $poll_option;
                }
                break;

            case 'product':
                $args['product']->location = (!is_empty($args['product']->location) && valid_location($args['product']->location))? $args['product']->location: '';
                $db->query(sprintf("INSERT INTO posts_products (post_id, name, price, category_id, status, location) VALUES (%s, %s, %s, %s, %s, %s)", secure($post['post_id'], 'int'), secure($args['product']->name), secure($args['product']->price), secure($args['product']->category, 'int'), secure($args['product']->status), secure($args['product']->location) )) or _error(SQL_ERROR_THROWEN);
                $post['product']['product_id'] = $db->insert_id;
                $post['product']['post_id'] = $post['post_id'];
                $post['product']['name'] = $args['product']->name;
                $post['product']['price'] = $args['product']->price;
                $post['product']['status'] = $args['product']->status;
                $post['product']['available'] = true;
                /* photos */
                if(count($args['photos']) > 0) {
                    foreach ($args['photos'] as $photo) {
                        $db->query(sprintf("INSERT INTO posts_photos (post_id, source) VALUES (%s, %s)", secure($post['post_id'], 'int'), secure($photo) )) or _error(SQL_ERROR_THROWEN);
                        $post_photo['photo_id'] = $db->insert_id;
                        $post_photo['post_id'] = $post['post_id'];
                        $post_photo['source'] = $photo;
                        $post_photo['likes'] = 0;
                        $post_photo['comments'] = 0;
                        $post['photos'][] = $post_photo;
                    }
                    $post['photos_num'] = count($post['photos']);
                }

            case 'video':
                $db->query(sprintf("INSERT INTO posts_videos (post_id, source) VALUES (%s, %s)", secure($post['post_id'], 'int'), secure($args['video']->source) )) or _error(SQL_ERROR_THROWEN);
                $post['video']['source'] = $args['video']->source;
                break;

            case 'audio':
                $db->query(sprintf("INSERT INTO posts_audios (post_id, source) VALUES (%s, %s)", secure($post['post_id'], 'int'), secure($args['audio']->source) )) or _error(SQL_ERROR_THROWEN);
                $post['audio']['source'] = $args['audio']->source;
                break;

            case 'file':
                $db->query(sprintf("INSERT INTO posts_files (post_id, source) VALUES (%s, %s)", secure($post['post_id'], 'int'), secure($args['file']->source) )) or _error(SQL_ERROR_THROWEN);
                $post['file']['source'] = $args['file']->source;
                break;
            
            case 'media':
                $db->query(sprintf("INSERT INTO posts_media (post_id, source_url, source_provider, source_type, source_title, source_text, source_html) VALUES (%s, %s, %s, %s, %s, %s, %s)", secure($post['post_id'], 'int'), secure($args['link']->source_url), secure($args['link']->source_provider), secure($args['link']->source_type), secure($args['link']->source_title), secure($args['link']->source_text), secure($args['link']->source_html) )) or _error(SQL_ERROR_THROWEN);
                $post['media']['media_id'] = $db->insert_id;
                $post['media']['post_id'] = $post['post_id'];
                $post['media']['source_url'] = $args['link']->source_url;
                $post['media']['source_type'] = $args['link']->source_type;
                $post['media']['source_provider'] = $args['link']->source_provider;
                $post['media']['source_title'] = $args['link']->source_title;
                $post['media']['source_text'] = $args['link']->source_text;
                $post['media']['source_html'] = $args['link']->source_html;
                break;

            case 'photos':
                if($args['handle'] == "page") {
                    /* check for page timeline album (public by default) */
                    if(!$_page['page_album_timeline']) {
                        /* create new page timeline album */
                        $db->query(sprintf("INSERT INTO posts_photos_albums (user_id, user_type, title) VALUES (%s, 'page', 'Timeline Photos')", secure($_page['page_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                        $_page['page_album_timeline'] = $db->insert_id;
                        /* update page */
                        $db->query(sprintf("UPDATE pages SET page_album_timeline = %s WHERE page_id = %s", secure($_page['page_album_timeline'], 'int'), secure($_page['page_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                    }
                    $album_id = $_page['page_album_timeline'];
                } elseif ($args['handle'] == "group") {
                    /* check for group timeline album */
                    if(!$_group['group_album_timeline']) {
                        /* create new group timeline album */
                        $db->query(sprintf("INSERT INTO posts_photos_albums (user_id, user_type, in_group, group_id, title, privacy) VALUES (%s, %s, %s, %s, 'Timeline Photos', 'custom')", secure($post['user_id'], 'int'), secure($post['user_type']), secure($post['in_group']), secure($post['group_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                        $_group['group_album_timeline'] = $db->insert_id;
                        /* update group */
                        $db->query(sprintf("UPDATE groups SET group_album_timeline = %s WHERE group_id = %s", secure($_group['group_album_timeline'], 'int'), secure($_group['group_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                    }
                    $album_id = $_group['group_album_timeline'];
                } elseif ($args['handle'] == "event") {
                    /* check for event timeline album */
                    if(!$_event['event_album_timeline']) {
                        /* create new event timeline album */
                        $db->query(sprintf("INSERT INTO posts_photos_albums (user_id, user_type, in_event, event_id, title, privacy) VALUES (%s, %s, %s, %s, 'Timeline Photos', 'custom')", secure($post['user_id'], 'int'), secure($post['user_type']), secure($post['in_event']), secure($post['event_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                        $_event['event_album_timeline'] = $db->insert_id;
                        /* update event */
                        $db->query(sprintf("UPDATE events SET event_album_timeline = %s WHERE event_id = %s", secure($_event['event_album_timeline'], 'int'), secure($_event['event_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                    }
                    $album_id = $_event['event_album_timeline'];
                } else {
                    /* check for timeline album */
                    if(!$this->_data['user_album_timeline']) {
                        /* create new timeline album (public by default) */
                        $db->query(sprintf("INSERT INTO posts_photos_albums (user_id, user_type, title) VALUES (%s, 'user', 'Timeline Photos')", secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                        $this->_data['user_album_timeline'] = $db->insert_id;
                        /* update user */
                        $db->query(sprintf("UPDATE users SET user_album_timeline = %s WHERE user_id = %s", secure($this->_data['user_album_timeline'], 'int'), secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                    }
                    $album_id = $this->_data['user_album_timeline'];
                }
                foreach ($args['photos'] as $photo) {
                    $db->query(sprintf("INSERT INTO posts_photos (post_id, album_id, source) VALUES (%s, %s, %s)", secure($post['post_id'], 'int'), secure($album_id, 'int'), secure($photo) )) or _error(SQL_ERROR_THROWEN);
                    $post_photo['photo_id'] = $db->insert_id;
                    $post_photo['post_id'] = $post['post_id'];
                    $post_photo['source'] = $photo;
                    $post_photo['likes'] = 0;
                    $post_photo['comments'] = 0;
                    $post['photos'][] = $post_photo;
                }
                $post['photos_num'] = count($post['photos']);
                break;

            case 'album':
                /* create new album */
                $db->query(sprintf("INSERT INTO posts_photos_albums (user_id, user_type, in_group, group_id, in_event, event_id, title, privacy) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)", secure($post['user_id'], 'int'), secure($post['user_type']), secure($post['in_group']), secure($post['group_id'], 'int'), secure($post['in_event']), secure($post['event_id'], 'int'), secure($args['album']), secure($post['privacy']) )) or _error(SQL_ERROR_THROWEN);
                $album_id = $db->insert_id;
                foreach ($args['photos'] as $photo) {
                    $db->query(sprintf("INSERT INTO posts_photos (post_id, album_id, source) VALUES (%s, %s, %s)", secure($post['post_id'], 'int'), secure($album_id, 'int'), secure($photo) )) or _error(SQL_ERROR_THROWEN);
                    $post_photo['photo_id'] = $db->insert_id;
                    $post_photo['post_id'] = $post['post_id'];
                    $post_photo['source'] = $photo;
                    $post_photo['likes'] = 0;
                    $post_photo['comments'] = 0;
                    $post['photos'][] = $post_photo;
                }
                $post['album']['album_id'] = $album_id;
                $post['album']['title'] = $args['album'];
                $post['photos_num'] = count($post['photos']);
                /* get album path */
                if($post['in_group']) {
                    $post['album']['path'] = 'groups/'.$_group['group_name'];
                } elseif ($post['in_event']) {
                    $post['album']['path'] = 'events/'.$_event['event_id'];
                } elseif ($post['user_type'] == "user") {
                    $post['album']['path'] = $this->_data['user_name'];
                } elseif ($post['user_type'] == "page") {
                    $post['album']['path'] = 'pages/'.$_page['page_name'];
                }
                break;
        }

        /* post mention notifications */
        $this->post_mentions($args['message'], $post['post_id']);

        /* post wall notifications */
        if($post['in_wall']) {
            $this->post_notification( array('to_user_id'=>$post['wall_id'], 'action'=>'wall', 'node_type'=>'post', 'node_url'=>$post['post_id']) );
        }

        /* parse text */
        $post['text_plain'] = htmlentities($post['text'], ENT_QUOTES, 'utf-8');
        $post['text'] = $this->_parse($post['text_plain']);

        /* user can manage the post */
        $post['manage_post'] = true;

        /* points balance */
        $this->points_balance("add", "post", $this->_data['user_id']);
        
        // return
        return $post;
    }


    /**
     * scraper
     * 
     * @param string $url
     * @return array
     */
    public function scraper($url) {
        $url_parsed = parse_url($url);
        if(!isset($url_parsed["scheme"]) ) {
            $url = "http://".$url;
        }
        $url = ger_origenal_url($url);
        require_once(ABSPATH.'includes/libs/Embed/autoloader.php');
        $dispatcher = new Embed\Http\CurlDispatcher([
            CURLOPT_FOLLOWLOCATION => false,
        ]);
        $embed = Embed\Embed::create($url, null, $dispatcher);
        if($embed) {
            $return = array();
            $return['source_url'] = $url;
            $return['source_title'] = $embed->title;
            $return['source_text'] = $embed->description;
            $return['source_type'] = $embed->type;
            if($return['source_type'] == "link") {
                $return['source_host'] = $url_parsed['host'];
                $return['source_thumbnail'] = $embed->image;
            } else {
                $return['source_html'] = $embed->code;
                $return['source_provider'] = $embed->providerName;                
            }
            return $return;
        } else {
            return false;
        }
    }


    /**
     * parse
     * 
     * @param string $text
     * @param boolean $nl2br
     * @param boolean $mention
     * @return string
     */
    private function _parse($text, $nl2br = true, $mention = true) {
        /* decode urls */
        $text = decode_urls($text);
        /* decode emoji */
        $text = $this->decode_emoji($text);
        /* decode stickers */
        $text = $this->decode_stickers($text);
        /* decode #hashtag */
        $text = decode_hashtag($text);
        /* decode @mention */
        if($mention) {
            $text = decode_mention($text);
        }
        /* censored words */
        $text = censored_words($text);
        /* nl2br */
        if($nl2br) {
            $text = nl2br($text);
        }
        return $text;
    }


    
    /* ------------------------------- */
    /* Posts */
    /* ------------------------------- */

    /**
     * get_posts
     * 
     * @param array $args
     * @return array
     */
    public function get_posts($args = []) {
        global $db, $system;
        /* initialize vars */
        $posts = array();
        /* validate arguments */
        $get = !isset($args['get'])? 'newsfeed' : $args['get'];
        $filter = !isset($args['filter'])? 'all' : $args['filter'];
        if(!in_array($filter, array('all', '', 'link', 'media', 'photos', 'video', 'audio', 'file', 'poll', 'product', 'article', 'map'))) {
            _error(400);
        }
        $last_post_id = !isset($args['last_post_id'])? null : $args['last_post_id'];
        if(isset($args['last_post']) && !is_numeric($args['last_post'])) {
            _error(400);
        }
        $offset = !isset($args['offset'])? 0 : $args['offset'];
        $offset *= $system['max_results'];
        if(isset($args['query'])) {
            if(is_empty($args['query'])) {
                return $posts;
            } else {
                $query = secure($args['query'], 'search', false);
            }
        }
        /* prepare query */
        $order_query = "ORDER BY posts.post_id DESC";
        $where_query = "";
        /* get posts */
        switch ($get) {
            case 'newsfeed':
                if(!$this->_logged_in && $query) {
                    /* [Case: 1] user not logged in but searhing */
                    $where_query .= "WHERE (";
                    $where_query .= "(posts.text LIKE $query)";
                    /* get only public posts [except: group posts & event posts & wall posts] */
                    $where_query .= " AND (posts.in_group = '0' AND posts.in_event = '0' AND posts.in_wall = '0' AND posts.privacy = 'public')";
                    $where_query .= ")";
                } else {
                    /* [Case: 2] user logged in whatever searching or not */
                    /* get viewer user's newsfeed */
                    $where_query .= "WHERE (";
                    /* get viewer posts */
                    $me = $this->_data['user_id'];
                    $where_query .= "(posts.user_id = $me AND posts.user_type = 'user')";
                    /* get posts from friends still followed */
                    $friends_ids = array_intersect($this->_data['friends_ids'], $this->_data['followings_ids']);
                    if($friends_ids) {
                        $friends_list = implode(',',$friends_ids);
                        /* viewer friends posts -> authors */
                        $where_query .= " OR (posts.user_id IN ($friends_list) AND posts.user_type = 'user' AND posts.privacy = 'friends' AND posts.in_group = '0')";
                        /* viewer friends posts -> their wall posts */
                        $where_query .= " OR (posts.in_wall = '1' AND posts.wall_id IN ($friends_list) AND posts.user_type = 'user' AND posts.privacy = 'friends')";
                    }
                    /* get posts from followings */
                    if($this->_data['followings_ids']) {
                        $followings_list = implode(',',$this->_data['followings_ids']);
                        /* viewer followings posts -> authors */
                        $where_query .= " OR (posts.user_id IN ($followings_list) AND posts.user_type = 'user' AND posts.privacy = 'public' AND posts.in_group = '0')";
                        /* viewer followings posts -> their wall posts */
                        $where_query .= " OR (posts.in_wall = '1' AND posts.wall_id IN ($followings_list) AND posts.user_type = 'user' AND posts.privacy = 'public')";
                    }
                    /* get viewer liked pages posts */
                    $pages_ids = $this->get_pages_ids();
                    if($pages_ids) {
                        $pages_list = implode(',',$pages_ids);
                        $where_query .= " OR (posts.user_id IN ($pages_list) AND posts.user_type = 'page')";
                    }
                    /* get groups (approved only) posts & exclude the viewer posts */
                    $groups_ids = $this->get_groups_ids(true);
                    if($groups_ids) {
                        $groups_list = implode(',',$groups_ids);
                        $where_query .= " OR (posts.group_id IN ($groups_list) AND posts.in_group = '1' AND posts.user_id != $me)";
                    }
                    /* get events posts & exclude the viewer posts */
                    $events_ids = $this->get_events_ids();
                    if($events_ids) {
                        $events_list = implode(',',$events_ids);
                        $where_query .= " OR (posts.event_id IN ($events_list) AND posts.in_event = '1' AND posts.user_id != $me)";
                    }
                    $where_query .= ")";
                    if($query) {
                        $where_query .= " AND (posts.text LIKE $query)";
                    }
                }
                break;

            case 'posts_profile':
                if(isset($args['id']) && !is_numeric($args['id'])) {
                    _error(400);
                }
                $id = $args['id'];
                /* get target user's posts */
                /* check if there is a viewer user */
                if($this->_logged_in) {
                    /* check if the target user is the viewer */
                    if($id == $this->_data['user_id']) {
                        /* get all posts */
                        $where_query .= "WHERE (";
                        /* get all target posts */
                        $where_query .= "(posts.user_id = $id AND posts.user_type = 'user')";
                        /* get target wall posts */
                        $where_query .= " OR (posts.wall_id = $id AND posts.in_wall = '1')";
                        $where_query .= ")";
                    } else {
                        /* check if the viewer & the target user are friends */
                        if(in_array($id, $this->_data['friends_ids'])) {
                            $where_query .= "WHERE (";
                            /* get all target posts [except: group posts] */
                            $where_query .= "(posts.user_id = $id AND posts.user_type = 'user' AND posts.in_group = '0' AND posts.privacy != 'me' )";
                            /* get target wall posts */
                            $where_query .= " OR (posts.wall_id = $id AND posts.in_wall = '1')";
                            $where_query .= ")";
                        } else {
                            /* get only public posts [except: wall posts & group posts] */
                            $where_query .= "WHERE (posts.user_id = $id AND posts.user_type = 'user' AND posts.in_group = '0' AND posts.in_wall = '0' AND posts.privacy = 'public')";
                        }
                    }
                } else {
                    /* get only public posts [except: wall posts & group posts] */
                    $where_query .= "WHERE (posts.user_id = $id AND posts.user_type = 'user' AND posts.in_group = '0' AND posts.in_wall = '0' AND posts.privacy = 'public')";
                }
                break;

            case 'posts_page':
                if(isset($args['id']) && !is_numeric($args['id'])) {
                    _error(400);
                }
                $id = $args['id'];
                $where_query .= "WHERE (posts.user_id = $id AND posts.user_type = 'page')";
                break;

            case 'posts_group':
                if(isset($args['id']) && !is_numeric($args['id'])) {
                    _error(400);
                }
                $id = $args['id'];
                $where_query .= "WHERE (posts.group_id = $id AND posts.in_group = '1')";
                break;

            case 'posts_event':
                if(isset($args['id']) && !is_numeric($args['id'])) {
                    _error(400);
                }
                $id = $args['id'];
                $where_query .= "WHERE (posts.event_id = $id AND posts.in_event = '1')";
                break;

            case 'popular':
                $where_query .= "WHERE posts.privacy = 'public'"; /* get all popular public posts */
                $order_query = "ORDER BY posts.comments DESC, posts.likes DESC, posts.shares DESC"; /* order by comments, likes & shares */
                break;

            case 'saved':
                $id = $this->_data['user_id'];
                $where_query .= "INNER JOIN posts_saved ON posts.post_id = posts_saved.post_id WHERE (posts_saved.user_id = $id)";
                $order_query = "ORDER BY posts_saved.time DESC"; /* order by saved time not by post_id */
                break;
            
            case 'boosted':
                $id = $this->_data['user_id'];
                $where_query .= "WHERE (posts.boosted = '1' AND posts.boosted_by = $id)";
                break;

            default:
                _error(400);
                break;
        }
        /* get viewer hidden posts to exclude from results */
        $hidden_posts = $this->_get_hidden_posts($this->_data['user_id']);
        if($hidden_posts) {
            $hidden_posts_list = implode(',',$hidden_posts);
            $where_query .= " AND (posts.post_id NOT IN ($hidden_posts_list))";
        }
        /* filter posts */
        if($filter != "all") {
           $where_query .= " AND (posts.post_type = '$filter')";
        }
        /* get posts */
        if($last_post_id != null && $get != 'saved' && $get != 'popular') { /* saved excluded as ordered by time not post_id */
            $get_posts = $db->query(sprintf("SELECT * FROM (SELECT posts.post_id FROM posts ".$where_query.") posts WHERE posts.post_id > %s ORDER BY posts.post_id DESC", secure($last_post_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        } else {
            $get_posts = $db->query(sprintf("SELECT posts.post_id FROM posts ".$where_query." ".$order_query." LIMIT %s, %s", secure($offset, 'int', false), secure($system['max_results'], 'int', false) )) or _error(SQL_ERROR_THROWEN);
        }
        if($get_posts->num_rows > 0) {
            while($post = $get_posts->fetch_assoc()) {
                $post = $this->get_post($post['post_id'], true, true); /* $full_details = true, $pass_privacy_check = true */
                if($post) {
                    $posts[] = $post;
                }
            }
        }
        return $posts;
    }


    /**
     * get_post
     * 
     * @param integer $post_id
     * @param boolean $get_comments
     * @param boolean $pass_privacy_check
     * @return array
     */
    public function get_post($post_id, $get_comments = true, $pass_privacy_check = false) {
        global $db, $system;

        $post = $this->_check_post($post_id, $pass_privacy_check);
        if(!$post) {
            return false;
        }

        /* parse text */
        $post['text_plain'] = $post['text'];
        $post['text'] = $this->_parse($post['text_plain']);

        /* og-meta tags */
        $post['og_title'] = $post['post_author_name'];
        $post['og_title'] .= ($post['text_plain'] != "")? " - ".$post['text_plain'] : "";
        $post['og_description'] = $post['text_plain'];

        /* post type */
        if($post['post_type'] == 'album' || $post['post_type'] == 'photos' || $post['post_type'] == 'profile_picture' || $post['post_type'] == 'profile_cover' || $post['post_type'] == 'page_picture' || $post['post_type'] == 'page_cover' || $post['post_type'] == 'group_picture' || $post['post_type'] == 'group_cover' || $post['post_type'] == 'event_cover') {
            /* get photos */
            $get_photos = $db->query(sprintf("SELECT * FROM posts_photos WHERE post_id = %s ORDER BY photo_id DESC", secure($post['post_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
            $post['photos_num'] = $get_photos->num_rows;
            /* check if photos has been deleted */
            if($post['photos_num'] == 0) {
                return false;
            }
            while($post_photo = $get_photos->fetch_assoc()) {
                $post['photos'][] = $post_photo;
            }
            if($post['post_type'] == 'album') {
                $post['album'] = $this->get_album($post['photos'][0]['album_id'], false);
                if(!$post['album']) {
                    return false;
                }
                /* og-meta tags */
                $post['og_title'] = $post['album']['title'];
                $post['og_image'] = $post['album']['cover'];
            } else {
                /* og-meta tags */
                $post['og_image'] = $system['system_uploads'].'/'.$post['photos'][0]['source'];
            }


        } elseif ($post['post_type'] == 'media') {
            /* get media */
            $get_media = $db->query(sprintf("SELECT * FROM posts_media WHERE post_id = %s", secure($post['post_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
            /* check if media has been deleted */
            if($get_media->num_rows == 0) {
                return false;
            }
            $post['media'] = $get_media->fetch_assoc();
            

        } elseif ($post['post_type'] == 'link') {
            /* get link */
            $get_link = $db->query(sprintf("SELECT * FROM posts_links WHERE post_id = %s", secure($post['post_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
            /* check if link has been deleted */
            if($get_link->num_rows == 0) {
                return false;
            }
            $post['link'] = $get_link->fetch_assoc();


        } elseif ($post['post_type'] == 'poll') {
            /* get poll */
            $get_poll = $db->query(sprintf("SELECT * FROM posts_polls WHERE post_id = %s", secure($post['post_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
            /* check if video has been deleted */
            if($get_poll->num_rows == 0) {
                return false;
            }
            $post['poll'] = $get_poll->fetch_assoc();
            /* get poll options */
            $get_poll_options = $db->query(sprintf("SELECT option_id, text FROM posts_polls_options WHERE poll_id = %s", secure($post['poll']['poll_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
            if($get_poll_options->num_rows == 0) {
                return false;
            }
            while($poll_option = $get_poll_options->fetch_assoc()) {
                /* get option votes */
                $get_option_votes = $db->query(sprintf("SELECT * FROM posts_polls_options_users WHERE option_id = %s", secure($poll_option['option_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                $poll_option['votes'] = $get_option_votes->num_rows;
                /* check if viewer voted */
                $poll_option['checked'] = false;
                if($this->_logged_in) {
                    $check = $db->query(sprintf("SELECT * FROM posts_polls_options_users WHERE user_id = %s AND option_id = %s", secure($this->_data['user_id'], 'int'), secure($poll_option['option_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                    if($check->num_rows > 0) {
                        $poll_option['checked'] = true;
                    }
                }
                $post['poll']['options'][] = $poll_option;
            }

        } elseif ($post['post_type'] == 'product') {
            /* get product */
            $get_product = $db->query(sprintf("SELECT * FROM posts_products WHERE post_id = %s", secure($post['post_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
            /* check if link has been deleted */
            if($get_product->num_rows == 0) {
                return false;
            }
            $post['product'] = $get_product->fetch_assoc();
            /* get photos */
            $get_photos = $db->query(sprintf("SELECT * FROM posts_photos WHERE post_id = %s ORDER BY photo_id DESC", secure($post['post_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
            $post['photos_num'] = $get_photos->num_rows;
            /* check if photos has been deleted */
            if($post['photos_num'] > 0) {
                while($post_photo = $get_photos->fetch_assoc()) {
                    $post['photos'][] = $post_photo;
                }
                /* og-meta tags */
                $post['og_image'] = $system['system_uploads'].'/'.$post['photos'][0]['source'];
            }
            /* og-meta tags */
            $post['og_title'] = $post['product']['name'];

        } elseif ($post['post_type'] == 'article') {
            /* get article */
            $get_article = $db->query(sprintf("SELECT posts_articles.*, blogs_categories.category_name FROM posts_articles LEFT JOIN blogs_categories ON posts_articles.category_id = blogs_categories.category_id WHERE posts_articles.post_id = %s", secure($post['post_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
            /* check if article has been deleted */
            if($get_article->num_rows == 0) {
                return false;
            }
            $post['article'] = $get_article->fetch_assoc();
            $post['article']['category_name'] = ($post['article']['category_name'])? $post['article']['category_name']: __("Uncategorized");
            $post['article']['category_url'] = get_url_text(html_entity_decode($post['article']['category_name'], ENT_QUOTES));
            $post['article']['parsed_cover'] = get_picture($post['article']['cover'], 'article');
            $post['article']['title_url'] = get_url_text(html_entity_decode($post['article']['title'], ENT_QUOTES));
            $post['article']['parsed_text'] = htmlspecialchars_decode($post['article']['text'], ENT_QUOTES);
            $post['article']['text_snippet'] = get_snippet_text($post['article']['text']);
            $tags = (!is_empty($post['article']['tags']))? explode(',', $post['article']['tags']): array();
            $post['article']['parsed_tags'] = array_map('get_tag', $tags);
            /* og-meta tags */
            $post['og_title'] = $post['article']['title'];
            $post['og_description'] = $post['article']['text_snippet'];
            $post['og_image'] = $post['article']['parsed_cover'];

        } elseif ($post['post_type'] == 'video') {
            /* get video */
            $get_video = $db->query(sprintf("SELECT * FROM posts_videos WHERE post_id = %s", secure($post['post_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
            /* check if video has been deleted */
            if($get_video->num_rows == 0) {
                return false;
            }
            $post['video'] = $get_video->fetch_assoc();

        } elseif ($post['post_type'] == 'audio') {
            /* get audio */
            $get_audio = $db->query(sprintf("SELECT * FROM posts_audios WHERE post_id = %s", secure($post['post_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
            /* check if audio has been deleted */
            if($get_audio->num_rows == 0) {
                return false;
            }
            $post['audio'] = $get_audio->fetch_assoc();

        } elseif ($post['post_type'] == 'file') {
            /* get file */
            $get_file = $db->query(sprintf("SELECT * FROM posts_files WHERE post_id = %s", secure($post['post_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
            /* check if file has been deleted */
            if($get_file->num_rows == 0) {
                return false;
            }
            $post['file'] = $get_file->fetch_assoc();

        } elseif ($post['post_type'] == 'shared') {
            /* get origin post */
            $post['origin'] = $this->get_post($post['origin_id'], false);
            /* check if origin post has been deleted */
            if(!$post['origin']) {
                return false;
            }

        } else {
            /* og-meta tags */
            $post['og_title'] = $post['post_author_name'];
            $post['og_title'] .= ($post['text_plain'] != "")? " - ".$post['text_plain'] : "";
            $post['og_description'] = $post['text_plain'];
        }

        /* post feeling */
        if(!is_empty($post['feeling_action']) && !is_empty($post['feeling_value'])) {
            if($post['feeling_action'] != "Feeling") {
                $_feeling_icon = get_feeling_icon($post['feeling_action'], get_feelings());
            } else {
                $_feeling_icon = get_feeling_icon($post['feeling_value'], get_feelings_types());
            }
            if($_feeling_icon) {
                $post['feeling_icon'] = $_feeling_icon;
            }
        }

        /* get post comments */
        if($get_comments) {
            if($post['comments'] > 0) {
                $post['post_comments'] = $this->get_comments($post['post_id'], 0, true, true, $post);
            }
        }

        return $post;
    }


    /**
     * get_boosted_post
     * 
     * @return array
     */
    public function get_boosted_post() {
        global $db, $system;
        /* get viewer hidden posts to exclude from results */
        $hidden_posts = $this->_get_hidden_posts($this->_data['user_id']);
        $where_query = "";
        if($hidden_posts) {
            $hidden_posts_list = implode(',',$hidden_posts);
            $where_query .= " AND (post_id NOT IN ($hidden_posts_list)) ";
        }
        $get_random_post = $db->query("SELECT post_id FROM posts WHERE boosted = '1'".$where_query."ORDER BY RAND() LIMIT 1") or _error(SQL_ERROR_THROWEN);
        if($get_random_post->num_rows == 0) {
            return false;
        }
        $random_post = $get_random_post->fetch_assoc();
        return $this->get_post($random_post['post_id'], true, true);
    }


    /**
     * who_likes
     * 
     * @param array $args
     * @return array
     */
    public function who_likes($args = []) {
        global $db, $system;
        /* initialize arguments */
        $post_id = !isset($args['post_id']) ? null : $args['post_id'];
        $photo_id = !isset($args['photo_id']) ? null : $args['photo_id'];
        $comment_id = !isset($args['comment_id']) ? null : $args['comment_id'];
        $offset = !isset($args['offset']) ? 0 : $args['offset'];
        /* initialize vars */
        $users = array();
        $offset *= $system['max_results'];
        if($post_id != null) {
            /* get users who like the post */
            $get_users = $db->query(sprintf('SELECT users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM posts_likes INNER JOIN users ON (posts_likes.user_id = users.user_id) WHERE posts_likes.post_id = %s LIMIT %s, %s', secure($post_id, 'int'), secure($offset, 'int', false), secure($system['max_results'], 'int', false) )) or _error(SQL_ERROR_THROWEN);
        } elseif ($photo_id != null) {
            /* get users who like the photo */
            $get_users = $db->query(sprintf('SELECT users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM posts_photos_likes INNER JOIN users ON (posts_photos_likes.user_id = users.user_id) WHERE posts_photos_likes.photo_id = %s LIMIT %s, %s', secure($photo_id, 'int'), secure($offset, 'int', false), secure($system['max_results'], 'int', false) )) or _error(SQL_ERROR_THROWEN);
        } else {
            /* get users who like the comment */
            $get_users = $db->query(sprintf('SELECT users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM posts_comments_likes INNER JOIN users ON (posts_comments_likes.user_id = users.user_id) WHERE posts_comments_likes.comment_id = %s LIMIT %s, %s', secure($comment_id, 'int'), secure($offset, 'int', false), secure($system['max_results'], 'int', false) )) or _error(SQL_ERROR_THROWEN);
        }
        if($get_users->num_rows > 0) {
            while($_user = $get_users->fetch_assoc()) {
                $_user['user_picture'] = get_picture($_user['user_picture'], $_user['user_gender']);
                /* get the connection between the viewer & the target */
                $_user['connection'] = $this->connection($_user['user_id']);
                /* get mutual friends count */
                $_user['mutual_friends_count'] = $this->get_mutual_friends_count($_user['user_id']);
                $users[] = $_user;
            }
        }
        return $users;
    }


    /**
     * who_shares
     * 
     * @param integer $post_id
     * @param integer $offset
     * @return array
     */
    public function who_shares($post_id, $offset = 0) {
        global $db, $system;
        $posts = array();
        $offset *= $system['max_results'];
        $get_posts = $db->query(sprintf('SELECT posts.post_id FROM posts INNER JOIN users ON posts.user_id = users.user_id WHERE posts.post_type = "shared" AND posts.origin_id = %s LIMIT %s, %s', secure($post_id, 'int'), secure($offset, 'int', false), secure($system['max_results'], 'int', false) )) or _error(SQL_ERROR_THROWEN);
        if($get_posts->num_rows > 0) {
            while($post = $get_posts->fetch_assoc()) {
                $post = $this->get_post($post['post_id']);
                if($post) {
                    $posts[] = $post;
                }
            }
        }
        return $posts;
    }


    /**
     * who_votes
     * 
     * @param integer $post_id
     * @param integer $offset
     * @return array
     */
    public function who_votes($option_id, $offset = 0) {
        global $db, $system;
        $voters = array();
        $offset *= $system['max_results'];
        $get_voters = $db->query(sprintf("SELECT users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_picture, users.user_gender FROM posts_polls_options_users INNER JOIN users ON posts_polls_options_users.user_id = users.user_id WHERE option_id = %s LIMIT %s, %s", secure($option_id, 'int'), secure($offset, 'int', false), secure($system['max_results'], 'int', false) )) or _error(SQL_ERROR_THROWEN);
        while($voter = $get_voters->fetch_assoc()) {
            $voter['user_picture'] = get_picture($voter['user_picture'], $voter['user_gender']);
            /* get the connection between the viewer & the target */
            $voter['connection'] = $this->connection($voter['user_id']);
            $voters[] = $voter;
        }
        return $voters;
    }


    /**
     * _get_hidden_posts
     * 
     * @param integer $user_id
     * @return array
     */
    private function _get_hidden_posts($user_id) {
        global $db;
        $hidden_posts = array();
        $get_hidden_posts = $db->query(sprintf("SELECT post_id FROM posts_hidden WHERE user_id = %s", secure($user_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        if($get_hidden_posts->num_rows > 0) {
            while($hidden_post = $get_hidden_posts->fetch_assoc()) {
                $hidden_posts[] = $hidden_post['post_id'];
            }
        }
        return $hidden_posts;
    }


    /**
     * _check_post
     * 
     * @param integer $id
     * @param boolean $pass_privacy_check
     * @param boolean $full_details
     * @return array|false
     */
    private function _check_post($id, $pass_privacy_check = false, $full_details = true) {
        global $db, $system;

        /* get post */
        $get_post = $db->query(sprintf("SELECT posts.*, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, users.user_picture_id, users.user_cover, users.user_cover_id, users.user_verified, users.user_subscribed, users.user_pinned_post, pages.*, groups.*, events.* FROM posts LEFT JOIN users ON posts.user_id = users.user_id AND posts.user_type = 'user' LEFT JOIN pages ON posts.user_id = pages.page_id AND posts.user_type = 'page' LEFT JOIN groups ON posts.in_group = '1' AND posts.group_id = groups.group_id LEFT JOIN events ON posts.in_event = '1' AND posts.event_id = events.event_id WHERE NOT (users.user_name <=> NULL AND pages.page_name <=> NULL) AND posts.post_id = %s", secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
        if($get_post->num_rows == 0) {
            return false;
        }
        $post = $get_post->fetch_assoc();
        /* check if the page has been deleted */
        if($post['user_type'] == "page" && !$post['page_admin']) {
            return false;
        }
        /* check if there is any blocking between the viewer & the post author */
        if($post['user_type'] == "user" && $this->blocked($post['user_id']) ) {
            return false;
        }
        
        /* get the author */
        $post['author_id'] = ($post['user_type'] == "page")? $post['page_admin'] : $post['user_id'];
        $post['is_page_admin'] = $this->check_page_adminship($this->_data['user_id'], $post['page_id']);
        $post['is_group_admin'] = $this->check_group_adminship($this->_data['user_id'], $post['group_id']);
        $post['is_event_admin'] = ($this->_logged_in && $this->_data['user_id'] == $post['event_admin'])? true : false;
        /* check the post author type */
        if($post['user_type'] == "user") {
            /* user */
            $post['post_author_picture'] = get_picture($post['user_picture'], $post['user_gender']);
            $post['post_author_url'] = $system['system_url'].'/'.$post['user_name'];
            $post['post_author_name'] = $post['user_firstname']." ".$post['user_lastname'];
            $post['post_author_verified'] = $post['user_verified'];
            $post['pinned'] = ( (!$post['in_group'] && !$post['in_event'] && $post['post_id'] == $post['user_pinned_post'] ) || ($post['in_group'] && $post['post_id'] == $post['group_pinned_post'] ) || ($post['in_event'] && $post['post_id'] == $post['event_pinned_post'] ) )? true : false;
        } else {
            /* page */
            $post['post_author_picture'] = get_picture($post['page_picture'], "page");
            $post['post_author_url'] = $system['system_url'].'/pages/'.$post['page_name'];
            $post['post_author_name'] = $post['page_title'];
            $post['post_author_verified'] = $post['page_verified'];
            $post['pinned'] = ($post['post_id'] == $post['page_pinned_post'])? true : false;
        }

        /* check if viewer can manage post [Edit|Pin|Delete] */
        $post['manage_post'] = false;
        if($this->_logged_in) {
            /* viewer is (admins|moderators)] */
            if($this->_data['user_group'] < 3) {
                $post['manage_post'] = true;
            }
            /* viewer is the author of post || page admin */
            if($this->_data['user_id'] == $post['author_id']) {
                $post['manage_post'] = true;
            }
            /* viewer is the admin of the page of the post */
            if($post['user_type'] == "page" && $post['is_page_admin']) {
                $post['manage_post'] = true;
            }
            /* viewer is the admin of the group of the post */
            if($post['in_group'] && $post['is_group_admin']) {
                $post['manage_post'] = true;
            }
            /* viewer is the admin of the event of the post */
            if($post['in_event'] && $post['is_event_admin']) {
                $post['manage_post'] = true;
            }
        }

        /* full details */
        if($full_details) {
            /* check if wall post */
            if($post['in_wall']) {
                $get_wall_user = $db->query(sprintf("SELECT user_firstname, user_lastname, user_name FROM users WHERE user_id = %s", secure($post['wall_id'] ,'int') )) or _error(SQL_ERROR_THROWEN);
                if($get_wall_user->num_rows == 0) {
                    return false;
                }
                $wall_user = $get_wall_user->fetch_assoc();
                $post['wall_username'] = $wall_user['user_name'];
                $post['wall_fullname'] = $wall_user['user_firstname']." ".$wall_user['user_lastname'];
            }
            
            /* check if viewer [liked|saved] this post */
            $post['i_save'] = false;
            $post['i_like'] = false;
            if($this->_logged_in) {
                /* save */
                $check_save = $db->query(sprintf("SELECT * FROM posts_saved WHERE user_id = %s AND post_id = %s", secure($this->_data['user_id'], 'int'), secure($post['post_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                if($check_save->num_rows > 0) {
                    $post['i_save'] = true;
                }
                /* like */
                $check_like = $db->query(sprintf("SELECT * FROM posts_likes WHERE user_id = %s AND post_id = %s", secure($this->_data['user_id'], 'int'), secure($post['post_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                if($check_like->num_rows > 0) {
                    $post['i_like'] = true;
                }
            }
        }

        /* check privacy */
        /* if post in group & (the group is public || the viewer approved member of this group) => pass privacy check */
        if( $post['in_group'] && ($post['group_privacy'] == 'public' || $this->check_group_membership($this->_data['user_id'], $post['group_id']) == 'approved') ) {
            $pass_privacy_check = true;
        }
        /* if post in event & (the event is public || the viewer member of this event) => pass privacy check */
        if( $post['in_event'] && ($post['event_privacy'] == 'public' || $this->check_event_membership($this->_data['user_id'], $post['event_id']))) {
            $pass_privacy_check = true;
        }
        if($pass_privacy_check || $this->_check_privacy($post['privacy'], $post['author_id'])) {
            return $post;
        }
        return false;
    }


    /**
     * _check_privacy
     * 
     * @param string $privacy
     * @param integer $author_id
     * @return boolean
     */
    private function _check_privacy($privacy, $author_id) {
        if($privacy == 'public') {
            return true;
        }
        if($this->_logged_in) {
            /* check if the viewer is the system admin */
            if($this->_data['user_group'] < 3) {
                return true;
            }
            /* check if the viewer is the target */
            if($author_id == $this->_data['user_id']) {
                return true;
            }
            /* check if the viewer and the target are friends */
            if($privacy == 'friends' && in_array($author_id, $this->_data['friends_ids'])) {
                return true;
            }
        }
        return false;
    }



    /* ------------------------------- */
    /* Comments & Replies */
    /* ------------------------------- */

    /**
     * get_comments
     * 
     * @param integer $node_id
     * @param integer $offset
     * @param boolean $is_post
     * @param boolean $pass_privacy_check
     * @param array $post
     * @return array
     */
    public function get_comments($node_id, $offset = 0, $is_post = true, $pass_privacy_check = true, $post = array()) {
        global $db, $system;
        $comments = array();
        $offset *= $system['min_results'];
        /* get comments */
        if($is_post) {
            /* get post comments */
            if(!$pass_privacy_check) {
                /* (check|get) post */
                $post = $this->_check_post($node_id, false);
                if(!$post) {
                    return false;
                }
            }
            /* get post comments */
            $get_comments = $db->query(sprintf("SELECT * FROM (SELECT posts_comments.*, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, users.user_verified, pages.* FROM posts_comments LEFT JOIN users ON posts_comments.user_id = users.user_id AND posts_comments.user_type = 'user' LEFT JOIN pages ON posts_comments.user_id = pages.page_id AND posts_comments.user_type = 'page' WHERE NOT (users.user_name <=> NULL AND pages.page_name <=> NULL) AND posts_comments.node_type = 'post' AND posts_comments.node_id = %s ORDER BY posts_comments.comment_id DESC LIMIT %s, %s) comments ORDER BY comments.comment_id ASC", secure($node_id, 'int'), secure($offset, 'int', false), secure($system['min_results'], 'int', false) )) or _error(SQL_ERROR_THROWEN);
        } else {
            /* get photo comments */
            /* check privacy */
            if(!$pass_privacy_check) {
                /* (check|get) photo */
                $photo = $this->get_photo($node_id);
                if(!$photo) {
                    _error(403);
                }
                $post = $photo['post'];
            }
            /* get photo comments */
            $get_comments = $db->query(sprintf("SELECT * FROM (SELECT posts_comments.*, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, users.user_verified, pages.* FROM posts_comments LEFT JOIN users ON posts_comments.user_id = users.user_id AND posts_comments.user_type = 'user' LEFT JOIN pages ON posts_comments.user_id = pages.page_id AND posts_comments.user_type = 'page' WHERE NOT (users.user_name <=> NULL AND pages.page_name <=> NULL) AND posts_comments.node_type = 'photo' AND posts_comments.node_id = %s ORDER BY posts_comments.comment_id DESC LIMIT %s, %s) comments ORDER BY comments.comment_id ASC", secure($node_id, 'int'), secure($offset, 'int', false), secure($system['min_results'], 'int', false) )) or _error(SQL_ERROR_THROWEN);
        }
        if($get_comments->num_rows == 0) {
            return $comments;
        }
        while($comment = $get_comments->fetch_assoc()) {
            /* check if there is any blocking between the viewer & the comment author */
            if($comment['user_type'] == "user" && $this->blocked($comment['user_id']) ) {
                continue;
            }
            /* get replies */
            if($comment['replies'] > 0) {
                $comment['comment_replies'] = $this->get_replies($comment['comment_id']);
            }
            /* parse text */
            $comment['text_plain'] = $comment['text'];
            $comment['text'] = $this->_parse($comment['text']);
            /* get the comment author */
            if($comment['user_type'] == "user") {
                /* user type */
                $comment['author_id'] = $comment['user_id'];
                $comment['author_picture'] = get_picture($comment['user_picture'], $comment['user_gender']);
                $comment['author_url'] = $system['system_url'].'/'.$comment['user_name'];
                $comment['author_name'] = $comment['user_firstname']." ".$comment['user_lastname'];
                $comment['author_verified'] = $comment['user_verified'];
            } else {
                /* page type */
                $comment['author_id'] = $comment['page_admin'];
                $comment['author_picture'] = get_picture($comment['page_picture'], "page");
                $comment['author_url'] = $system['system_url'].'/pages/'.$comment['page_name'];
                $comment['author_name'] = $comment['page_title'];
                $comment['author_verified'] = $comment['page_verified'];
            }
            /* check if viewer user likes this comment */
            if($this->_logged_in && $comment['likes'] > 0) {
                $check_like = $db->query(sprintf("SELECT * FROM posts_comments_likes WHERE user_id = %s AND comment_id = %s", secure($this->_data['user_id'], 'int'), secure($comment['comment_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                $comment['i_like'] = ($check_like->num_rows > 0)? true: false;
            }
            /* check if viewer can manage comment [Edit|Delete] */
            $comment['edit_comment'] = false;
            $comment['delete_comment'] = false;
            if($this->_logged_in) {
                /* viewer is (admins|moderators)] */
                if($this->_data['user_group'] < 3) {
                    $comment['edit_comment'] = true;
                    $comment['delete_comment'] = true;
                }
                /* viewer is the author of comment */
                if($this->_data['user_id'] == $comment['author_id']) {
                    $comment['edit_comment'] = true;
                    $comment['delete_comment'] = true;
                }
                /* viewer is the author of post || page admin */
                if($this->_data['user_id'] == $post['author_id']) {
                    $comment['delete_comment'] = true;
                }
                /* viewer is the admin of the group of the post */
                if($post['in_group'] && $post['is_group_admin']) {
                    $comment['delete_comment'] = true;
                }
                /* viewer is the admin of the event of the post */
                if($post['in_group'] && $post['is_event_admin']) {
                    $comment['delete_comment'] = true;
                }
            }
            $comments[] = $comment;
        }
        return $comments;
    }


    /**
     * get_replies
     * 
     * @param integer $comment_id
     * @param integer $offset
     * @return array
     */
    public function get_replies($comment_id, $offset = 0, $pass_check = true) {
        global $db, $system;
        $replies = array();
        $offset *= $system['min_results'];
        if(!$pass_check) {
            $comment = $this->get_comment($comment_id);
            if(!$comment) {
                _error(403);
            }
        }
        /* get replies */
        $get_replies = $db->query(sprintf("SELECT * FROM (SELECT posts_comments.*, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture, users.user_verified, pages.* FROM posts_comments LEFT JOIN users ON posts_comments.user_id = users.user_id AND posts_comments.user_type = 'user' LEFT JOIN pages ON posts_comments.user_id = pages.page_id AND posts_comments.user_type = 'page' WHERE NOT (users.user_name <=> NULL AND pages.page_name <=> NULL) AND posts_comments.node_type = 'comment' AND posts_comments.node_id = %s ORDER BY posts_comments.comment_id DESC LIMIT %s, %s) comments ORDER BY comments.comment_id ASC", secure($comment_id, 'int'), secure($offset, 'int', false), secure($system['min_results'], 'int', false) )) or _error(SQL_ERROR_THROWEN);
        if($get_replies->num_rows == 0) {
            return $replies;
        }
        while($reply = $get_replies->fetch_assoc()) {
            /* parse text */
            $reply['text_plain'] = $reply['text'];
            $reply['text'] = $this->_parse($reply['text']);
            /* get the reply author */
            if($reply['user_type'] == "user") {
                /* user type */
                $reply['author_id'] = $reply['user_id'];
                $reply['author_picture'] = get_picture($reply['user_picture'], $reply['user_gender']);
                $reply['author_url'] = $system['system_url'].'/'.$reply['user_name'];
                $reply['author_user_name'] = $reply['user_name'];
                $reply['author_name'] = $reply['user_firstname']." ".$reply['user_lastname'];
                $reply['author_verified'] = $reply['user_verified'];
            } else {
                /* page type */
                $reply['author_id'] = $reply['page_admin'];
                $reply['author_picture'] = get_picture($reply['page_picture'], "page");
                $reply['author_url'] = $system['system_url'].'/pages/'.$reply['page_name'];
                $reply['author_name'] = $reply['page_title'];
                $reply['author_verified'] = $reply['page_verified'];
            }
            /* check if viewer user likes this reply */
            if($this->_logged_in && $reply['likes'] > 0) {
                $check_like = $db->query(sprintf("SELECT * FROM posts_comments_likes WHERE user_id = %s AND comment_id = %s", secure($this->_data['user_id'], 'int'), secure($reply['comment_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                $reply['i_like'] = ($check_like->num_rows > 0)? true: false;
            }
            /* check if viewer can manage comment [Edit|Delete] */
            $reply['edit_comment'] = false;
            $reply['delete_comment'] = false;
            if($this->_logged_in) {
                /* viewer is (admins|moderators)] */
                if($this->_data['user_group'] < 3) {
                    $reply['edit_comment'] = true;
                    $reply['delete_comment'] = true;
                }
                /* viewer is the author of comment */
                if($this->_data['user_id'] == $reply['author_id']) {
                    $reply['edit_comment'] = true;
                    $reply['delete_comment'] = true;
                }
            }
            $replies[] = $reply;
        }
        return $replies;
    }


    /**
     * comment
     * 
     * @param string $handle
     * @param integer $node_id
     * @param string $message
     * @param string $photo
     * @return array
     */
    public function comment($handle, $node_id, $message, $photo) {
        global $db, $system, $date;
        $comment = array();

        /* default */
        $comment['node_id'] = $node_id;
        $comment['node_type'] = $handle;
        $comment['text'] = $message;
        $comment['image'] = $photo;
        $comment['time'] = $date;
        $comment['likes'] = 0;
        $comment['replies'] = 0;

        /* check the handle */
        switch ($handle) {
            case 'post':
                /* (check|get) post */
                $post = $this->_check_post($node_id, false, false);
                if(!$post) {
                    _error(403);
                }
                break;
            
            case 'photo':
                /* (check|get) photo */
                $photo = $this->get_photo($node_id);
                if(!$photo) {
                    _error(403);
                }
                $post = $photo['post'];
                break;

            case 'comment':
                /* (check|get) comment */
                $parent_comment = $this->get_comment($node_id, false);
                if(!$parent_comment) {
                    _error(403);
                }
                $post = $parent_comment['post'];
                break;
        }

        /* check if comments disabled */
        if($post['comments_disabled']) {
            throw new Exception(__("Comments disabled for this post"));
        }

        /* check if there is any blocking between the viewer & the target */
        if($this->blocked($post['author_id']) || ($handle == "comment" && $this->blocked($parent_comment['author_id'])) ) {
            _error(403);
        }

        /* check if the viewer is page admin of the target post */
        if(!$post['is_page_admin']) {
            $comment['user_id'] = $this->_data['user_id'];
            $comment['user_type'] = "user";
            $comment['author_picture'] = $this->_data['user_picture'];
            $comment['author_url'] = $system['system_url'].'/'.$this->_data['user_name'];
            $comment['author_user_name'] = $this->_data['user_name'];
            $comment['author_name'] = $this->_data['user_firstname']." ".$this->_data['user_lastname'];
            $comment['author_verified'] = $this->_data['user_verified'];
        } else {
            $comment['user_id'] = $post['page_id'];
            $comment['user_type'] = "page";
            $comment['author_picture'] = get_picture($post['page_picture'], "page");
            $comment['author_url'] = $system['system_url'].'/pages/'.$post['page_name'];
            $comment['author_name'] = $post['page_title'];
            $comment['author_verified'] = $post['page_verified'];
        }
        
        /* insert the comment */
        $db->query(sprintf("INSERT INTO posts_comments (node_id, node_type, user_id, user_type, text, image, time) VALUES (%s, %s, %s, %s, %s, %s, %s)", secure($comment['node_id'], 'int'), secure($comment['node_type']), secure($comment['user_id'], 'int'), secure($comment['user_type']), secure($comment['text']), secure($comment['image']), secure($comment['time']) )) or _error(SQL_ERROR_THROWEN);
        $comment['comment_id'] = $db->insert_id;
        /* update (post|photo|comment) (comments|replies) counter */
        switch ($handle) {
            case 'post':
                $db->query(sprintf("UPDATE posts SET comments = comments + 1 WHERE post_id = %s", secure($node_id, 'int') )) or _error(SQL_ERROR_THROWEN);
                break;
            
            case 'photo':
                $db->query(sprintf("UPDATE posts_photos SET comments = comments + 1 WHERE photo_id = %s", secure($node_id, 'int') )) or _error(SQL_ERROR_THROWEN);
                break;

            case 'comment':
                $db->query(sprintf("UPDATE posts_comments SET replies = replies + 1 WHERE comment_id = %s", secure($node_id, 'int') )) or _error(SQL_ERROR_THROWEN);
                $db->query(sprintf("UPDATE posts SET comments = comments + 1 WHERE post_id = %s", secure($post['post_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                break;
        }

        /* post notification */
        if($handle == "comment") {
            $this->post_notification( array('to_user_id'=>$parent_comment['author_id'], 'action'=>'reply', 'node_type'=>$parent_comment['node_type'], 'node_url'=>$parent_comment['node_id'], 'notify_id'=>'comment_'.$comment['comment_id']) );
            if($post['author_id'] != $parent_comment['author_id']) {
                $this->post_notification( array('to_user_id'=>$post['author_id'], 'action'=>'comment', 'node_type'=>$parent_comment['node_type'], 'node_url'=>$parent_comment['node_id'], 'notify_id'=>'comment_'.$comment['comment_id']) );
            }
        } else {
            $this->post_notification( array('to_user_id'=>$post['author_id'], 'action'=>'comment', 'node_type'=>$handle, 'node_url'=>$node_id, 'notify_id'=>'comment_'.$comment['comment_id']) );
        }

        /* post mention notifications if any */
        if($handle == "comment") {
            $this->post_mentions($comment['text'], $parent_comment['node_id'], "reply_".$parent_comment['node_type'], 'comment_'.$comment['comment_id'], array($post['author_id'], $parent_comment['author_id']));
        } else {
            $this->post_mentions($comment['text'], $node_id, "comment_".$handle, 'comment_'.$comment['comment_id'], array($post['author_id']));
        }
        
        /* parse text */
        $comment['text_plain'] = htmlentities($comment['text'], ENT_QUOTES, 'utf-8');
        $comment['text'] = $this->_parse($comment['text_plain']);

        /* check if viewer can manage comment [Edit|Delete] */
        $comment['edit_comment'] = true;
        $comment['delete_comment'] = true;

        /* points balance */
        $this->points_balance("add", "comment", $this->_data['user_id']);

        /* return */
        return $comment;
    }


    /**
     * get_comment
     * 
     * @param integer $comment_id
     * @return array|false
     */
    public function get_comment($comment_id, $recursive = true) {
        global $db;
        /* get comment */
        $get_comment = $db->query(sprintf("SELECT posts_comments.*, pages.page_admin FROM posts_comments LEFT JOIN pages ON posts_comments.user_type = 'page' AND posts_comments.user_id = pages.page_id WHERE posts_comments.comment_id = %s", secure($comment_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        if($get_comment->num_rows == 0) {
            return false;
        }
        $comment = $get_comment->fetch_assoc();
        /* check if the page has been deleted */
        if($comment['user_type'] == "page" && !$comment['page_admin']) {
            return false;
        }
        /* get the author */
        $comment['author_id'] = ($comment['user_type'] == "page")? $comment['page_admin'] : $comment['user_id'];
        /* get post */
        switch ($comment['node_type']) {
            case 'post':
                $post = $this->_check_post($comment['node_id'], false, false);
                /* check if the post has been deleted */
                if(!$post) {
                    return false;
                }
                $comment['post'] = $post;
                break;

            case 'photo':
                /* (check|get) photo */
                $photo = $this->get_photo($comment['node_id']);
                if(!$photo) {
                    return false;
                }
                $comment['post'] = $photo['post'];
                break;

            case 'comment':
                if(!$recursive) {
                    return false;
                }
                /* (check|get) comment */
                $parent_comment = $this->get_comment($comment['node_id'], false);
                if(!$parent_comment) {
                    return false;
                }
                $comment['parent_comment'] = $parent_comment;
                $comment['post'] = $parent_comment['post'];
                break;
        }
        /* check if viewer user likes this comment */
        if($this->_logged_in && $comment['likes'] > 0) {
            $check_like = $db->query(sprintf("SELECT * FROM posts_comments_likes WHERE user_id = %s AND comment_id = %s", secure($this->_data['user_id'], 'int'), secure($comment['comment_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
            $comment['i_like'] = ($check_like->num_rows > 0)? true: false;
        }
        return $comment;
    }


    /**
     * delete_comment
     * 
     * @param integer $comment_id
     * @return void
     */
    public function delete_comment($comment_id) {
        global $db;
        /* (check|get) comment */
        $comment = $this->get_comment($comment_id);
        if(!$comment) {
            _error(403);
        }
        /* check if viewer can manage comment [Delete] */
        $comment['delete_comment'] = false;
        if($this->_logged_in) {
            /* viewer is (admins|moderators)] */
            if($this->_data['user_group'] < 3) {
                $comment['delete_comment'] = true;
            }
            /* viewer is the author of comment */
            if($this->_data['user_id'] == $comment['author_id']) {
                $comment['delete_comment'] = true;
            }
            /* viewer is the author of post || page admin */
            if($this->_data['user_id'] == $comment['post']['author_id']) {
                $comment['delete_comment'] = true;
            }
            /* viewer is the admin of the group of the post */
            if($comment['post']['in_group'] && $comment['post']['is_group_admin']) {
                $comment['delete_comment'] = true;
            }
            /* viewer is the admin of the event of the post */
            if($comment['post']['in_event'] && $comment['post']['is_event_admin']) {
                $comment['delete_comment'] = true;
            }
        }
        /* delete the comment */
        if($comment['delete_comment']) {
            /* delete the comment */
            $db->query(sprintf("DELETE FROM posts_comments WHERE comment_id = %s", secure($comment_id, 'int') )) or _error(SQL_ERROR_THROWEN);
            /* update comments counter */
            switch ($comment['node_type']) {
                case 'post':
                    $db->query(sprintf("UPDATE posts SET comments = IF(comments=0,0,comments-%s) WHERE post_id = %s", secure($comment['replies']+1, 'int'), secure($comment['node_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                    break;

                case 'photo':
                    $db->query(sprintf("UPDATE posts_photos SET comments = IF(comments=0,0,comments-%s) WHERE photo_id = %s", secure($comment['replies']+1, 'int'), secure($comment['node_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                    break;

                case 'comment':
                    $db->query(sprintf("UPDATE posts_comments SET replies = IF(replies=0,0,replies-1) WHERE comment_id = %s", secure($comment['node_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                    break;
            }
            /* points balance */
            $this->points_balance("delete", "comment", $comment['author_id']);
        }
    }


    /**
     * edit_comment
     * 
     * @param integer $comment_id
     * @param string $message
     * @param string $photo
     * @return array
     */
    public function edit_comment($comment_id, $message, $photo) {
        global $db, $system;
        /* (check|get) comment */
        $comment = $this->get_comment($comment_id);
        if(!$comment) {
            _error(403);
        }
        /* check if viewer can manage comment [Edit] */
        $comment['edit_comment'] = false;
        if($this->_logged_in) {
            /* viewer is (admins|moderators)] */
            if($this->_data['user_group'] < 3) {
                $comment['edit_comment'] = true;
            }
            /* viewer is the author of comment */
            if($this->_data['user_id'] == $comment['author_id']) {
                $comment['edit_comment'] = true;
            }
        }
        if(!$comment['edit_comment']) {
            _error(400);
        }
        /* update comment */
        $comment['text'] = $message;
        $comment['image'] = (!is_empty($comment['image']))? $comment['image'] : $photo;
        $db->query(sprintf("UPDATE posts_comments SET text = %s, image = %s WHERE comment_id = %s", secure($comment['text']), secure($comment['image']), secure($comment_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        /* post mention notifications if any */
        if($comment['node_type'] == "comment") {
            $this->post_mentions($comment['text'], $comment['parent_comment']['node_id'], "reply_".$comment['parent_comment']['node_type'], 'comment_'.$comment['comment_id'], array($comment['post'], $comment['parent_comment']['author_id']));
        } else {
            $this->post_mentions($comment['text'], $comment['node_id'], "comment_".$comment['node_type'], 'comment_'.$comment['comment_id'], array($comment['post']['author_id']));
        }
        /* parse text */
        $comment['text_plain'] = htmlentities($comment['text'], ENT_QUOTES, 'utf-8');
        $comment['text'] = $this->_parse($comment['text_plain']);
        /* return */
        return $comment;
    }


    /**
     * like_comment
     * 
     * @param integer $comment_id
     * @return void
     */
    public function like_comment($comment_id) {
        global $db;
        /* (check|get) comment */
        $comment = $this->get_comment($comment_id);
        if(!$comment) {
            _error(403);
        }
        /* check blocking */
        if($this->blocked($comment['author_id'])) {
            _error(403);
        }
        /* like the comment */
        if(!$comment['i_like']) {
            $db->query(sprintf("INSERT INTO posts_comments_likes (user_id, comment_id) VALUES (%s, %s)", secure($this->_data['user_id'], 'int'), secure($comment_id, 'int') )) or _error(SQL_ERROR_THROWEN);
            /* update comment likes counter */
            $db->query(sprintf("UPDATE posts_comments SET likes = likes + 1 WHERE comment_id = %s", secure($comment_id, 'int') )) or _error(SQL_ERROR_THROWEN);
            /* post notification */
            switch ($comment['node_type']) {
                case 'post':
                    $this->post_notification( array('to_user_id'=>$comment['author_id'], 'action'=>'like', 'node_type'=>'post_comment', 'node_url'=>$comment['node_id'], 'notify_id'=>'comment_'.$comment_id) );
                    break;
                
                case 'photo':
                    $this->post_notification( array('to_user_id'=>$comment['author_id'], 'action'=>'like', 'node_type'=>'photo_comment', 'node_url'=>$comment['node_id'], 'notify_id'=>'comment_'.$comment_id) );
                    break;

                case 'comment':
                    $_node_type = ($comment['parent_comment']['node_type'] == "post")? "post_reply": "photo_reply";
                    $_node_url = $comment['parent_comment']['node_id'];
                    $this->post_notification( array('to_user_id'=>$comment['author_id'], 'action'=>'like', 'node_type'=>$_node_type, 'node_url'=>$_node_url, 'notify_id'=>'comment_'.$comment_id) );
                    break;
            }
        }
    }


    /**
     * unlike_comment
     * 
     * @param integer $comment_id
     * @return void
     */
    public function unlike_comment($comment_id) {
        global $db;
        /* (check|get) comment */
        $comment = $this->get_comment($comment_id);
        if(!$comment) {
            _error(403);
        }
        /* check blocking */
        if($this->blocked($comment['author_id'])) {
            _error(403);
        }
        /* unlike the comment */
        if($comment['i_like']) {
            $db->query(sprintf("DELETE FROM posts_comments_likes WHERE user_id = %s AND comment_id = %s", secure($this->_data['user_id'], 'int'), secure($comment_id, 'int') )) or _error(SQL_ERROR_THROWEN);
            /* update comment likes counter */
            $db->query(sprintf("UPDATE posts_comments SET likes = IF(likes=0,0,likes-1) WHERE comment_id = %s", secure($comment_id, 'int') )) or _error(SQL_ERROR_THROWEN);
            /* delete notification */
            switch ($comment['node_type']) {
                case 'post':
                    $this->delete_notification($comment['author_id'], 'like', 'post_comment', $comment['node_id']);
                    break;
                
                case 'photo':
                    $this->delete_notification($comment['author_id'], 'like', 'photo_comment', $comment['node_id']);
                    break;

                case 'comment':
                    $_node_type = ($comment['parent_comment']['node_type'] == "post")? "post_reply": "photo_reply";
                    $_node_url = $comment['parent_comment']['node_id'];
                    $this->delete_notification($comment['author_id'], 'like', $_node_type, $_node_url);
                    break;
            }
        }
    }


    /* ------------------------------- */
    /* Photos & Albums */
    /* ------------------------------- */

    /**
     * get_photos
     * 
     * @param integer $id
     * @param string $type
     * @param integer $offset
     * @param boolean $pass_check
     * @return array
     */
    public function get_photos($id, $type = 'user', $offset = 0, $pass_check = true) {
        global $db, $system;
        $photos = array();
        switch ($type) {
            case 'album':
                $offset *= $system['max_results_even'];
                if($pass_check) {
                    $get_photos = $db->query(sprintf("SELECT posts_photos.photo_id, posts_photos.source, posts.* FROM posts_photos INNER JOIN posts ON posts_photos.post_id = posts.post_id WHERE posts_photos.album_id = %s ORDER BY posts_photos.photo_id DESC LIMIT %s, %s", secure($id, 'int'), secure($offset, 'int', false), secure($system['max_results_even'], 'int', false) )) or _error(SQL_ERROR_THROWEN);
                    if($get_photos->num_rows > 0) {
                        while($photo = $get_photos->fetch_assoc()) {
                            if($photo['privacy'] != "public" && $photo['user_type'] == "user") {
                                /* check the photo privacy */
                                if($this->_check_privacy($photo['privacy'], $photo['user_id'])) {
                                    $photos[] = $photo;
                                }
                            } else {
                                $photos[] = $photo;
                            }
                        }
                    }
                } else {
                    $album = $this->get_album($id, false);
                    if(!$album) {
                        return $photos;
                    }
                    $get_photos = $db->query(sprintf("SELECT posts_photos.photo_id, posts_photos.source, posts.* FROM posts_photos INNER JOIN posts ON posts_photos.post_id = posts.post_id WHERE posts_photos.album_id = %s ORDER BY posts_photos.photo_id DESC LIMIT %s, %s", secure($id, 'int'), secure($offset, 'int', false), secure($system['max_results_even'], 'int', false) )) or _error(SQL_ERROR_THROWEN);
                    if($get_photos->num_rows > 0) {
                        while($photo = $get_photos->fetch_assoc()) {
                            /* check the photo privacy */
                            if($photo['privacy'] == "public" || $photo['privacy'] == "custom") {
                                $photos[] = $photo;
                            } else {
                                if($photo['user_type'] == "user") {
                                    /* check the photo privacy */
                                    if($this->_check_privacy($photo['privacy'], $photo['user_id'])) {
                                        $photos[] = $photo;
                                    }
                                }
                            }
                        }
                    }
                }
                break;
            case 'user':
                $offset *= $system['min_results_even'];
                /* get the target user's privacy */
                $get_privacy = $db->query(sprintf("SELECT user_privacy_photos FROM users WHERE user_id = %s", secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                $privacy = $get_privacy->fetch_assoc();
                /* check the target user's privacy  */
                if(!$this->_check_privacy($privacy['user_privacy_photos'], $id)) {
                    return $photos;
                }
                $get_photos = $db->query(sprintf("SELECT posts_photos.photo_id, posts_photos.source, posts.privacy FROM posts_photos INNER JOIN posts ON posts_photos.post_id = posts.post_id WHERE posts.user_id = %s AND user_type = 'user' ORDER BY posts_photos.photo_id DESC LIMIT %s, %s", secure($id, 'int'), secure($offset, 'int', false), secure($system['min_results_even'], 'int', false) )) or _error(SQL_ERROR_THROWEN);
                if($get_photos->num_rows > 0) {
                    while($photo = $get_photos->fetch_assoc()) {
                        /* check the photo privacy */
                        if($photo['privacy'] == "public" || $photo['privacy'] == "custom") {
                            $photos[] = $photo;
                        } else {
                            if($photo['user_type'] == "user") {
                                /* check the photo privacy */
                                if($this->_check_privacy($photo['privacy'], $photo['user_id'])) {
                                    $photos[] = $photo;
                                }
                            }
                        }
                    }
                }
                break;
            
            case 'page':
                $offset *= $system['min_results_even'];
                $get_photos = $db->query(sprintf("SELECT posts_photos.photo_id, posts_photos.source FROM posts_photos INNER JOIN posts ON posts_photos.post_id = posts.post_id WHERE posts.user_id = %s AND user_type = 'page' ORDER BY posts_photos.photo_id DESC LIMIT %s, %s", secure($id, 'int'), secure($offset, 'int', false), secure($system['min_results_even'], 'int', false) )) or _error(SQL_ERROR_THROWEN);
                if($get_photos->num_rows > 0) {
                    while($photo = $get_photos->fetch_assoc()) {
                        $photos[] = $photo;
                    }
                }
                break;

            case 'group':
                $offset *= $system['min_results_even'];
                if(!$pass_check) {
                    /* check if the viewer is group member (approved) */
                    $check_group = $db->query(sprintf("SELECT groups.* FROM groups INNER JOIN groups_members ON groups.group_id = groups_members.group_id WHERE groups_members.approved = '1' AND groups_members.user_id = %s AND groups_members.group_id = %s", secure($this->_data['user_id'], 'int'), secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                    /* if no -> return */
                    if($check_group->num_rows == 0) {
                        return $photos;
                    }
                }
                $get_photos = $db->query(sprintf("SELECT posts_photos.photo_id, posts_photos.source FROM posts_photos INNER JOIN posts ON posts_photos.post_id = posts.post_id WHERE posts.group_id = %s AND in_group = '1' ORDER BY posts_photos.photo_id DESC LIMIT %s, %s", secure($id, 'int'), secure($offset, 'int', false), secure($system['min_results_even'], 'int', false) )) or _error(SQL_ERROR_THROWEN);
                if($get_photos->num_rows > 0) {
                    while($photo = $get_photos->fetch_assoc()) {
                        $photos[] = $photo;
                    }
                }
                break;

            case 'event':
                $offset *= $system['min_results_even'];
                if(!$pass_check) {
                    /* check if the viewer is event member (approved) */
                    $check_event = $db->query(sprintf("SELECT events.* FROM events INNER JOIN events_members ON events.event_id = events_members.event_id WHERE events_members.user_id = %s AND events_members.event_id = %s", secure($this->_data['user_id'], 'int'), secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                    /* if no -> return */
                    if($check_event->num_rows == 0) {
                        _error(403);
                    }
                }
                $get_photos = $db->query(sprintf("SELECT posts_photos.photo_id, posts_photos.source FROM posts_photos INNER JOIN posts ON posts_photos.post_id = posts.post_id WHERE posts.event_id = %s AND in_event = '1' ORDER BY posts_photos.photo_id DESC LIMIT %s, %s", secure($id, 'int'), secure($offset, 'int', false), secure($system['min_results_even'], 'int', false) )) or _error(SQL_ERROR_THROWEN);
                if($get_photos->num_rows > 0) {
                    while($photo = $get_photos->fetch_assoc()) {
                        $photos[] = $photo;
                    }
                }
                break;
        }
        return $photos;
    }


    /**
     * get_photo
     * 
     * @param integer $photo_id
     * @param boolean $full_details
     * @param boolean $get_gallery
     * @param string $context
     * @return array
     */
    public function get_photo($photo_id, $full_details = false, $get_gallery = false, $context = 'photos') {
        global $db;

        /* get photo */
        $get_photo = $db->query(sprintf("SELECT * FROM posts_photos WHERE photo_id = %s", secure($photo_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        if($get_photo->num_rows == 0) {
            return false;
        }
        $photo = $get_photo->fetch_assoc();

        /* get post */
        $post = $this->_check_post($photo['post_id'], false, $full_details);
        if(!$post) {
            return false;
        }

        /* check if photo can be deleted */
        if($post['in_group']) {
            /* check if (cover|profile) photo */
            $photo['can_delete'] = ( ($photo_id == $post['group_picture_id']) OR ($photo_id == $post['group_cover_id']) )? false : true;
        } elseif ($post['in_event']) {
            /* check if (cover) photo */
            $photo['can_delete'] = ( ($photo_id == $post['event_cover_id']) )? false : true;
        } elseif ($post['user_type'] == "user") {
            /* check if (cover|profile) photo */
            $photo['can_delete'] = ( ($photo_id == $post['user_picture_id']) OR ($photo_id == $post['user_cover_id']) )? false : true;
        } elseif ($post['user_type'] == "page") {
            /* check if (cover|profile) photo */
            $photo['can_delete'] = ( ($photo_id == $post['page_picture_id']) OR ($photo_id == $post['page_cover_id']) )? false : true;
        }

        /* check photo type [single|mutiple] */
        $check_single = $db->query(sprintf("SELECT * FROM posts_photos WHERE post_id = %s", secure($photo['post_id'], 'int') ))  or _error(SQL_ERROR_THROWEN);
        $photo['is_single'] = ($check_single->num_rows > 1)? false : true;

        /* get full details */
        if($full_details) {
            if($photo['is_single']) {
                /* single photo => get (likes|comments) of post */
                
                /* check if viewer likes this post */
                if($this->_logged_in && $post['likes'] > 0) {
                    $check_like = $db->query(sprintf("SELECT * FROM posts_likes WHERE user_id = %s AND post_id = %s", secure($this->_data['user_id'], 'int'), secure($post['post_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                    $photo['i_like'] = ($check_like->num_rows > 0)? true: false;
                }
                
                /* get post comments */
                if($post['comments'] > 0) {
                    $post['post_comments'] = $this->get_comments($post['post_id'], 0, true, true, $post);
                }

            } else {
                /* mutiple photo => get (likes|comments) of photo */

                /* check if viewer user likes this photo */
                if($this->_logged_in && $photo['likes'] > 0) {
                    $check_like = $db->query(sprintf("SELECT * FROM posts_photos_likes WHERE user_id = %s AND photo_id = %s", secure($this->_data['user_id'], 'int'), secure($photo['photo_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                    $photo['i_like'] = ($check_like->num_rows > 0)? true: false;
                }
                
                /* get post comments */
                if($photo['comments'] > 0) {
                    $photo['photo_comments'] = $this->get_comments($photo['photo_id'], 0, false, true, $post);
                }

            }
        }

        /* get gallery */
        if($get_gallery) {
            switch ($context) {
                case 'post':
                    $get_post_photos = $db->query(sprintf("SELECT photo_id, source FROM posts_photos WHERE post_id = %s", secure($post['post_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                    while($post_photo = $get_post_photos->fetch_assoc()) {
                        $post_photos[$post_photo['photo_id']] = $post_photo;
                    }
                    $photo['next'] = $post_photos[get_array_key($post_photos, $photo['photo_id'], -1)];
                    $photo['prev'] =  $post_photos[get_array_key($post_photos, $photo['photo_id'], 1)];
                    break;
                
                case 'album':
                    $get_album_photos = $db->query(sprintf("SELECT photo_id, source FROM posts_photos WHERE album_id = %s", secure($photo['album_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                    while($album_photo = $get_album_photos->fetch_assoc()) {
                        $album_photos[$album_photo['photo_id']] = $album_photo;
                    }
                    $photo['next'] = $album_photos[get_array_key($album_photos, $photo['photo_id'], -1)];
                    $photo['prev'] =  $album_photos[get_array_key($album_photos, $photo['photo_id'], 1)];
                    break;

                case 'photos':
                    if($post['in_group']) {
                        $get_target_photos = $db->query(sprintf("SELECT posts_photos.photo_id, posts_photos.source FROM posts INNER JOIN posts_photos ON posts.post_id = posts_photos.post_id WHERE posts.in_group = '1' AND posts.group_id = %s", secure($post['group_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                    } elseif ($post['in_event']) {
                        $get_target_photos = $db->query(sprintf("SELECT posts_photos.photo_id, posts_photos.source FROM posts INNER JOIN posts_photos ON posts.post_id = posts_photos.post_id WHERE posts.in_event = '1' AND posts.event_id = %s", secure($post['event_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                    } elseif ($post['user_type'] == "page") {
                        $get_target_photos = $db->query(sprintf("SELECT posts_photos.photo_id, posts_photos.source FROM posts INNER JOIN posts_photos ON posts.post_id = posts_photos.post_id WHERE posts.user_type = 'page' AND posts.user_id = %s", secure($post['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                    } elseif ($post['user_type'] == "user") {
                        $get_target_photos = $db->query(sprintf("SELECT posts_photos.photo_id, posts_photos.source FROM posts INNER JOIN posts_photos ON posts.post_id = posts_photos.post_id WHERE posts.user_type = 'user' AND posts.user_id = %s", secure($post['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                    }
                    while($target_photo = $get_target_photos->fetch_assoc()) {
                        $target_photos[$target_photo['photo_id']] = $target_photo;
                    }
                    $photo['next'] = $target_photos[get_array_key($target_photos, $photo['photo_id'], -1)];
                    $photo['prev'] =  $target_photos[get_array_key($target_photos, $photo['photo_id'], 1)];
                    break;
            }       
        }

        /* return post array with photo */
        $photo['post'] = $post;
        return $photo;
    }


    /**
     * delete_photo
     * 
     * @param integer $photo_id
     * @return void
     */
    public function delete_photo($photo_id) {
        global $db, $system;
        /* (check|get) photo */
        $photo = $this->get_photo($photo_id);
        if(!$photo) {
            _error(403);
        }
        $post = $photo['post'];
        /* check if viewer can manage post */
        if(!$post['manage_post']) {
            _error(403);
        }
        /* check if photo can be deleted */
        if(!$photo['can_delete']) {
            throw new Exception(__("This photo can't be deleted"));
        }
        /* delete the photo */
        $db->query(sprintf("DELETE FROM posts_photos WHERE photo_id = %s", secure($photo_id, 'int') )) or _error(SQL_ERROR_THROWEN);
    }


    /**
     * like_photo
     * 
     * @param integer $photo_id
     * @return void
     */
    public function like_photo($photo_id) {
        global $db;
        /* (check|get) photo */
        $photo = $this->get_photo($photo_id);
        if(!$photo) {
            _error(403);
        }
        $post = $photo['post'];
        /* check blocking */
        if($this->blocked($post['author_id'])) {
            _error(403);
        }
        /* like the photo */
        $db->query(sprintf("INSERT INTO posts_photos_likes (user_id, photo_id) VALUES (%s, %s)", secure($this->_data['user_id'], 'int'), secure($photo_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        /* update photo likes counter */
        $db->query(sprintf("UPDATE posts_photos SET likes = likes + 1 WHERE photo_id = %s", secure($photo_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        /* post notification */
        $this->post_notification( array('to_user_id'=>$post['author_id'], 'action'=>'like', 'node_type'=>'photo', 'node_url'=>$photo_id) );
    }


    /**
     * unlike_photo
     * 
     * @param integer $photo_id
     * @return void
     */
    public function unlike_photo($photo_id) {
        global $db;
        /* (check|get) photo */
        $photo = $this->get_photo($photo_id);
        if(!$photo) {
            _error(403);
        }
        $post = $photo['post'];
        /* unlike the photo */
        $db->query(sprintf("DELETE FROM posts_photos_likes WHERE user_id = %s AND photo_id = %s", secure($this->_data['user_id'], 'int'), secure($photo_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        /* update photo likes counter */
        $db->query(sprintf("UPDATE posts_photos SET likes = IF(likes=0,0,likes-1) WHERE photo_id = %s", secure($photo_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        /* delete notification */
        $this->delete_notification($post['author_id'], 'like', 'photo', $photo_id);
    }


    /**
     * get_albums
     * 
     * @param integer $user_id
     * @param string $type
     * @param integer $offset
     * @return array
     */
    public function get_albums($id, $type = 'user', $offset = 0) {
        global $db, $system;
        /* initialize vars */
        $albums = array();
        $offset *= $system['max_results_even'];
        if(!in_array($type, array('user', 'page', 'group', 'event'))) {
            return $albums;
        }
        switch ($type) {
            case 'user':
                $get_albums = $db->query(sprintf("SELECT album_id FROM posts_photos_albums WHERE user_type = 'user' AND user_id = %s AND in_group = '0' AND in_event = '0' LIMIT %s, %s", secure($id, 'int'), secure($offset, 'int', false), secure($system['max_results_even'], 'int', false) )) or _error(SQL_ERROR_THROWEN);
                break;

            case 'page':
                $get_albums = $db->query(sprintf("SELECT album_id FROM posts_photos_albums WHERE user_type = 'page' AND user_id = %s AND in_group = '0' AND in_event = '0' LIMIT %s, %s", secure($id, 'int'), secure($offset, 'int', false), secure($system['max_results_even'], 'int', false) )) or _error(SQL_ERROR_THROWEN);
                break;
            
            case 'group':
                $get_albums = $db->query(sprintf("SELECT album_id FROM posts_photos_albums WHERE in_group = '1' AND group_id = %s LIMIT %s, %s", secure($id, 'int'), secure($offset, 'int', false), secure($system['max_results_even'], 'int', false) )) or _error(SQL_ERROR_THROWEN);
                break;

            case 'event':
                $get_albums = $db->query(sprintf("SELECT album_id FROM posts_photos_albums WHERE in_event = '1' AND event_id = %s LIMIT %s, %s", secure($id, 'int'), secure($offset, 'int', false), secure($system['max_results_even'], 'int', false) )) or _error(SQL_ERROR_THROWEN);
                break;
        }
        if($get_albums->num_rows > 0) {
            while($album = $get_albums->fetch_assoc()) {
                $album = $this->get_album($album['album_id'], false); /* $full_details = false */
                if($album) {
                    $albums[] = $album;
                }                    
            }
        }
        return $albums;
    }


    /**
     * get_album
     * 
     * @param integer $album_id
     * @param boolean $full_details
     * @return array
     */
    public function get_album($album_id, $full_details = true) {
        global $db, $system;
        $get_album = $db->query(sprintf("SELECT posts_photos_albums.*, users.user_name, users.user_album_pictures, users.user_album_covers, users.user_album_timeline, pages.page_id, pages.page_name, pages.page_admin, pages.page_album_pictures, pages.page_album_covers, pages.page_album_timeline, groups.group_name, groups.group_admin, groups.group_album_pictures, groups.group_album_covers, groups.group_album_timeline, events.event_admin, events.event_album_covers, events.event_album_timeline FROM posts_photos_albums LEFT JOIN users ON posts_photos_albums.user_id = users.user_id AND posts_photos_albums.user_type = 'user' LEFT JOIN pages ON posts_photos_albums.user_id = pages.page_id AND posts_photos_albums.user_type = 'page' LEFT JOIN groups ON posts_photos_albums.in_group = '1' AND posts_photos_albums.group_id = groups.group_id LEFT JOIN events ON posts_photos_albums.in_event = '1' AND posts_photos_albums.event_id = events.event_id WHERE NOT (users.user_name <=> NULL AND pages.page_name <=> NULL) AND posts_photos_albums.album_id = %s", secure($album_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        if($get_album->num_rows == 0) {
            return false;
        }
        $album = $get_album->fetch_assoc();
        /* get the author */
        $album['author_id'] = ($album['user_type'] == "page")? $album['page_admin'] : $album['user_id'];
        /* check the album privacy  */
        /* if post in group & (the group is public || the viewer approved member of this group) => pass privacy check */
        if( $album['in_group'] && ($album['group_privacy'] == 'public' || $this->check_group_membership($this->_data['user_id'], $album['group_id']) == 'approved') ) {
            $pass_privacy_check = true;
        }
        /* if post in event & (the event is public || the viewer member of this event) => pass privacy check */
        if( $album['in_event'] && ($album['event_privacy'] == 'public' || $this->check_event_membership($this->_data['user_id'], $album['event_id']))) {
            $pass_privacy_check = true;
        }
        if(!$pass_privacy_check) {
            if(!$this->_check_privacy($album['privacy'], $album['author_id'])) {
                return false;
            }
        }
        /* get album path */
        if($album['in_group']) {
            $album['path'] = 'groups/'.$album['group_name'];
            /* check if (cover|profile|timeline) album */
            $album['can_delete'] = ( ($album_id == $album['group_album_pictures']) OR ($album_id == $album['group_album_covers']) OR ($album_id == $album['group_album_timeline']) )? false : true;
        } elseif ($album['in_event']) {
            $album['path'] = 'events/'.$album['event_id'];
            /* check if (cover|profile|timeline) album */
            $album['can_delete'] = ( ($album_id == $album['event_album_pictures']) OR ($album_id == $album['event_album_covers']) OR ($album_id == $album['event_album_timeline']) )? false : true;
        } elseif ($album['user_type'] == "user") {
            $album['path'] = $album['user_name'];
            /* check if (cover|profile|timeline) album */
            $album['can_delete'] = ( ($album_id == $album['user_album_pictures']) OR ($album_id == $album['user_album_covers']) OR ($album_id == $album['user_album_timeline']) )? false : true;
        } elseif ($album['user_type'] == "page") {
            $album['path'] = 'pages/'.$album['page_name'];
            /* check if (cover|profile|timeline) album */
            $album['can_delete'] = ( ($album_id == $album['user_album_timeline']) OR ($album_id == $album['page_album_covers']) OR ($album_id == $album['page_album_timeline']) )? false : true;
        }
        /* get album cover photo */
        $get_cover = $db->query(sprintf("SELECT source FROM posts_photos INNER JOIN posts ON posts_photos.post_id = posts.post_id WHERE posts.privacy = 'public' AND posts_photos.album_id = %s ORDER BY photo_id DESC", secure($album_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        if($get_cover->num_rows == 0) {
            $album['cover'] = $system['system_url'].'/content/themes/'.$system['theme'].'/images/blank_album.jpg';
        } else {
            $cover = $get_cover->fetch_assoc();
            $album['cover'] = $system['system_uploads'].'/'.$cover['source'];
        }
        $album['photos_count'] = $get_cover->num_rows;
        /* check if viewer can manage album [Edit|Update|Delete] */
        $album['is_page_admin'] = ($this->_logged_in && $this->_data['user_id'] == $album['page_admin'])? true : false;
        $album['is_group_admin'] = ($this->_logged_in && $this->_data['user_id'] == $album['group_admin'])? true : false;
        $album['is_event_admin'] = ($this->_logged_in && $this->_data['user_id'] == $album['event_admin'])? true : false;
        /* check if viewer can manage album [Edit|Update|Delete] */
        $album['manage_album'] = false;
        if($this->_logged_in) {
            /* viewer is (admins|moderators)] */
            if($this->_data['user_group'] < 3) {
                $album['manage_album'] = true;
            }
            /* viewer is the author of post || page admin */
            if($this->_data['user_id'] == $album['author_id']) {
                $album['manage_album'] = true;
            }
            /* viewer is the admin of the group of the post */
            if($album['in_group'] && $album['is_group_admin']) {
                $album['manage_album'] = true;
            }
            /* viewer is the admin of the event of the post */
            if($album['in_event'] && $album['is_event_admin']) {
                $album['manage_album'] = true;
            }
        }
        /* get album photos */
        if($full_details) {
            $album['photos'] = $this->get_photos($album_id, 'album');

        }
        return $album;
    }


    /**
     * delete_album
     * 
     * @param integer $album_id
     * @return void
     */
    public function delete_album($album_id) {
        global $db, $system;
        /* (check|get) album */
        $album = $this->get_album($album_id, false);
        if(!$album) {
            _error(403);
        }
        /* check if viewer can manage album */
        if(!$album['manage_album']) {
            _error(403);
        }
        /* check if album can be deleted */
        if(!$album['can_delete']) {
            throw new Exception(__("This album can't be deleted"));
        }
        /* delete the album */
        $db->query(sprintf("DELETE FROM posts_photos_albums WHERE album_id = %s", secure($album_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        /* delete all album photos */
        $db->query(sprintf("DELETE FROM posts_photos WHERE album_id = %s", secure($album_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        /* retrun path */
        $path = $system['system_url']."/".$album['path']."/albums";
        return $path;
    }


    /**
     * edit_album
     * 
     * @param integer $album_id
     * @param string $title
     * @return void
     */
    public function edit_album($album_id, $title) {
        global $db;
        /* (check|get) album */
        $album = $this->get_album($album_id, false);
        if(!$album) {
            _error(400);
        }
        /* check if viewer can manage album */
        if(!$album['manage_album']) {
            _error(400);
        }
        /* validate all fields */
        if(is_empty($title)) {
            throw new Exception(__("You must fill in all of the fields"));
        }
        /* edit the album */
        $db->query(sprintf("UPDATE posts_photos_albums SET title = %s WHERE album_id = %s", secure($title), secure($album_id, 'int') )) or _error(SQL_ERROR_THROWEN);
    }


    /**
     * add_photos
     * 
     * @param array $args
     * @return array
     */
    public function add_album_photos($args = []) {
        global $db, $system, $date;
        /* (check|get) album */
        $album = $this->get_album($args['album_id'], false);
        if(!$album) {
            _error(400);
        }
        /* check if viewer can manage album */
        if(!$album['manage_album']) {
            _error(400);
        }
        /* check user_id */
        $user_id = ($album['user_type'] == "page")? $album['page_id'] : $album['user_id'];
        /* check post location */
        $args['location'] = (!is_empty($args['location']) && valid_location($args['location']))? $args['location']: '';
        /* check privacy */
        if($album['in_group'] || $album['in_event']) {
            $args['privacy'] = 'custom';
        } elseif ($album['user_type'] == "page") {
            $args['privacy'] = 'public';
        } else {
            if(!in_array($args['privacy'], array('me', 'friends', 'public'))) {
                $args['privacy'] = 'public';
            }
        }
        /* post feeling */
        $post['feeling_action'] = '';
        $post['feeling_value'] = '';
        $post['feeling_icon'] = '';
        if(!is_empty($args['feeling_action']) && !is_empty($args['feeling_value'])) {
            if($args['feeling_action'] != "Feeling") {
                $_feeling_icon = get_feeling_icon($args['feeling_action'], get_feelings());
            } else {
                $_feeling_icon = get_feeling_icon($args['feeling_value'], get_feelings_types());
            }
            if($_feeling_icon) {
                $post['feeling_action'] = $args['feeling_action'];
                $post['feeling_value'] = $args['feeling_value'];
                $post['feeling_icon'] = $_feeling_icon;
            }
        }
        /* insert the post */
        $db->query(sprintf("INSERT INTO posts (user_id, user_type, in_group, group_id, in_event, event_id, post_type, time, location, privacy, text, feeling_action, feeling_value) VALUES (%s, %s, %s, %s, %s, %s, 'album', %s, %s, %s, %s, %s, %s)", secure($user_id, 'int'), secure($album['user_type']), secure($album['in_group']), secure($album['group_id'], 'int'), secure($album['in_event']), secure($album['event_id'], 'int'), secure($date), secure($args['location']), secure($args['privacy']), secure($args['message']), secure($post['feeling_action']), secure($post['feeling_value']) )) or _error(SQL_ERROR_THROWEN);
        $post_id = $db->insert_id;
        /* insert new photos */
        foreach ($args['photos'] as $photo) {
            $db->query(sprintf("INSERT INTO posts_photos (post_id, album_id, source) VALUES (%s, %s, %s)", secure($post_id, 'int'), secure($args['album_id'], 'int'), secure($photo) )) or _error(SQL_ERROR_THROWEN);
        }
        /* post mention notifications */
        $this->post_mentions($args['message'], $post_id);
        return $post_id;
    }


    
    /* ------------------------------- */
    /* Post Reactions */
    /* ------------------------------- */

    /**
     * share
     * 
     * @param integer $post_id
     *@return void
     */
    public function share($post_id) {
        global $db, $date;
        /* check if the viewer can share the post */
        $post = $this->_check_post($post_id, true);
        if(!$post || $post['privacy'] != 'public') {
            _error(403);
        }
        /* check blocking */
        if($this->blocked($post['author_id'])) {
            _error(403);
        }
        // share post
        /* share the origin post */
        if($post['post_type'] == "shared") {
            $origin = $this->_check_post($post['origin_id'], true);
            if(!$origin || $origin['privacy'] != 'public') {
                _error(403);
            }
            $post_id = $origin['post_id'];
            $author_id = $origin['author_id'];
        } else {
            $post_id = $post['post_id'];
            $author_id = $post['author_id'];
        }
        /* insert the new shared post */
        $db->query(sprintf("INSERT INTO posts (user_id, user_type, post_type, origin_id, time, privacy) VALUES (%s, 'user', 'shared', %s, %s, 'public')", secure($this->_data['user_id'], 'int'), secure($post_id, 'int'), secure($date) )) or _error(SQL_ERROR_THROWEN);
        /* update the origin post shares counter */
        $db->query(sprintf("UPDATE posts SET shares = shares + 1 WHERE post_id = %s", secure($post_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        /* post notification */
        $this->post_notification( array('to_user_id'=>$author_id, 'action'=>'share', 'node_type'=>'post', 'node_url'=>$post_id) );
    }


    /**
     * delete_post
     * 
     * @param integer $post_id
     * @return boolean
     */
    public function delete_post($post_id) {
        global $db, $system;
        /* (check|get) post */
        $post = $this->get_post($post_id, false, true);
        if(!$post) {
            _error(403);
        }
        /* delete the post */
        if(!$post['manage_post']) {
            _error(403);
        }
        /* delete post */
        $refresh = false;
        $db->query(sprintf("DELETE FROM posts WHERE post_id = %s", secure($post_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        switch ($post['post_type']) {
            case 'photos':
            case 'album':
            case 'profile_cover':
            case 'profile_picture':
            case 'page_cover':
            case 'page_picture':
            case 'group_cover':
            case 'group_picture':
            case 'event_cover':
            case 'product':
                /* delete uploads from uploads folder */
                foreach ($post['photos'] as $photo) {
                    delete_uploads_file($photo['source']);
                }
                /* delete post photos from database */
                $db->query(sprintf("DELETE FROM posts_photos WHERE post_id = %s", secure($post_id, 'int') )) or _error(SQL_ERROR_THROWEN);
                switch ($post['post_type']) {
                    case 'profile_cover':
                        /* update user cover if it's current cover */
                        if($post['user_cover_id']  ==  $post['photos'][0]['photo_id']) {
                            $db->query(sprintf("UPDATE users SET user_cover = null, user_cover_id = null WHERE user_id = %s", secure($post['author_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                            /* return */
                            $refresh = true;
                        }
                        break;

                    case 'profile_picture':
                        /* update user picture if it's current picture */
                        if($post['user_picture_id']  ==  $post['photos'][0]['photo_id']) {
                            $db->query(sprintf("UPDATE users SET user_picture = null, user_picture_id = null WHERE user_id = %s", secure($post['author_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                            /* delete cropped picture from uploads folder */
                            delete_uploads_file($post['user_picture']);
                            /* return */
                            $refresh = true;
                        }
                        break;

                    case 'page_cover':
                        /* update page cover if it's current cover */
                        if($post['page_cover_id']  ==  $post['photos'][0]['photo_id']) {
                            $db->query(sprintf("UPDATE pages SET page_cover = null, page_cover_id = null WHERE page_id = %s", secure($post['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                            /* return */
                            $refresh = true;
                        }
                        break;

                    case 'page_picture':
                        /* update page picture if it's current picture */
                        if($post['page_picture_id']  ==  $post['photos'][0]['photo_id']) {
                            $db->query(sprintf("UPDATE pages SET page_picture = null, page_picture_id = null WHERE page_id = %s", secure($post['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                            /* delete cropped picture from uploads folder */
                            delete_uploads_file($post['page_picture']);
                            /* return */
                            $refresh = true;
                        }
                        break;

                    case 'group_cover':
                        /* update group cover if it's current cover */
                        if($post['group_cover_id']  ==  $post['photos'][0]['photo_id']) {
                            $db->query(sprintf("UPDATE groups SET group_cover = null, group_cover_id = null WHERE group_id = %s", secure($post['group_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                            /* return */
                            $refresh = true;
                        }
                        break;

                    case 'group_picture':
                        /* update group picture if it's current picture */
                        if($post['group_picture_id']  ==  $post['photos'][0]['photo_id']) {
                            $db->query(sprintf("UPDATE groups SET group_picture = null, group_picture_id = null WHERE group_id = %s", secure($post['group_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                            /* delete cropped from uploads folder */
                            delete_uploads_file($post['group_picture']);
                            /* return */
                            $refresh = true;
                        }
                        break;

                    case 'event_cover':
                        /* update event cover if it's current cover */
                        if($post['event_cover_id']  ==  $post['photos'][0]['photo_id']) {
                            $db->query(sprintf("UPDATE events SET event_cover = null, event_cover_id = null WHERE event_id = %s", secure($post['event_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                            /* return */
                            $refresh = true;
                        }
                        break;

                    case 'product':
                        /* delete nested table row */
                        $db->query(sprintf("DELETE FROM posts_products WHERE post_id = %s", secure($post_id, 'int') )) or _error(SQL_ERROR_THROWEN);
                        break;
                }
                break;

            case 'video':
                /* delete uploads from uploads folder */
                delete_uploads_file($post['video']['source']);
                /* delete nested table row */
                $db->query(sprintf("DELETE FROM posts_videos WHERE post_id = %s", secure($post_id, 'int') )) or _error(SQL_ERROR_THROWEN);
                break;

            case 'audio':
                /* delete uploads from uploads folder */
                delete_uploads_file($post['audio']['source']);
                /* delete nested table row */
                $db->query(sprintf("DELETE FROM posts_audios WHERE post_id = %s", secure($post_id, 'int') )) or _error(SQL_ERROR_THROWEN);
                break;

            case 'file':
                /* delete uploads from uploads folder */
                delete_uploads_file($post['file']['source']);
                /* delete nested table row */
                $db->query(sprintf("DELETE FROM posts_files WHERE post_id = %s", secure($post_id, 'int') )) or _error(SQL_ERROR_THROWEN);
                break;

            case 'media':
                /* delete nested table row */
                $db->query(sprintf("DELETE FROM posts_media WHERE post_id = %s", secure($post_id, 'int') )) or _error(SQL_ERROR_THROWEN);
                break;

            case 'link':
                /* delete nested table row */
                $db->query(sprintf("DELETE FROM posts_links WHERE post_id = %s", secure($post_id, 'int') )) or _error(SQL_ERROR_THROWEN);
                break;

            case 'poll':
                /* delete nested table row */
                $db->query(sprintf("DELETE FROM posts_polls WHERE post_id = %s", secure($post_id, 'int') )) or _error(SQL_ERROR_THROWEN);
                $db->query(sprintf("DELETE FROM posts_polls_options WHERE poll_id = %s", secure($post['poll']['poll_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                $db->query(sprintf("DELETE FROM posts_polls_options_users WHERE poll_id = %s", secure($post['poll']['poll_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                break;

            case 'article':
                /* delete nested table row */
                $db->query(sprintf("DELETE FROM posts_articles WHERE post_id = %s", secure($post_id, 'int') )) or _error(SQL_ERROR_THROWEN);
                break;
        }
        /* points balance */
        $this->points_balance("delete", "post", $post['author_id']);
        return $refresh;
    }


    /**
     * edit_post
     * 
     * @param integer $post_id
     * @param string $message
     * @return array
     */
    public function edit_post($post_id, $message) {
        global $db, $system;
        /* (check|get) post */
        $post = $this->_check_post($post_id, true);
        if(!$post) {
            _error(403);
        }
        /* check if viewer can edit post */
        if(!$post['manage_post']) {
            _error(403);
        }
        /* update post */
        $db->query(sprintf("UPDATE posts SET text = %s WHERE post_id = %s", secure($message), secure($post_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        /* post mention notifications */
        $this->post_mentions($message, $post_id);
        /* parse text */
        $post['text_plain'] = htmlentities($message, ENT_QUOTES, 'utf-8');
        $post['text'] = $this->_parse($post['text_plain']);
        /* return */
        return $post;
    }


    /**
     * edit_product
     * 
     * @param integer $post_id
     * @param string $message
     * @param string $name
     * @param string $price
     * @param integer $category_id
     * @param string $status
     * @param string $location
     * @return void
     */
    public function edit_product($post_id, $message, $name, $price, $category_id, $status, $location) {
        global $db, $system;
        /* (check|get) post */
        $post = $this->_check_post($post_id, true);
        if(!$post) {
            _error(403);
        }
        /* check if viewer can edit post */
        if(!$post['manage_post']) {
            _error(403);
        }
        /* update post */
        $db->query(sprintf("UPDATE posts SET text = %s WHERE post_id = %s", secure($message), secure($post_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        /* update product */
        $location = (!is_empty($location) && valid_location($location))? $location: '';
        $db->query(sprintf("UPDATE posts_products SET name = %s, price = %s, category_id = %s, status = %s, location = %s WHERE post_id = %s", secure($name), secure($price), secure($category_id, 'int'), secure($status), secure($location), secure($post_id, 'int') )) or _error(SQL_ERROR_THROWEN);
    }


    /**
     * edit_privacy
     * 
     * @param integer $post_id
     * @param string $privacy
     * @return void
     */
    public function edit_privacy($post_id, $privacy) {
        global $db, $system;
        /* (check|get) post */
        $post = $this->_check_post($post_id, true);
        if(!$post) {
            _error(403);
        }
        /* check if viewer can edit privacy */
        if($post['manage_post'] && $post['user_type'] == 'user' && !$post['in_group'] && !$post['in_event'] && $post['post_type'] != "product") {
            /* update privacy */
            $db->query(sprintf("UPDATE posts SET privacy = %s WHERE post_id = %s", secure($privacy), secure($post_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        } else {
            _error(403);
        }
    }

    /**
     * disable_post_comments
     * 
     * @param integer $post_id
     * @return void
     */
    public function disable_post_comments($post_id) {
        global $db;
        /* (check|get) post */
        $post = $this->_check_post($post_id);
        if(!$post) {
            _error(403);
        }
        /* check if viewer can edit post */
        if(!$post['manage_post']) {
            _error(403);
        }
        /* trun off post commenting */
        $db->query(sprintf("UPDATE posts SET comments_disabled = '1' WHERE post_id = %s", secure($post_id, 'int') )) or _error(SQL_ERROR_THROWEN);
    }


    /**
     * enable_post_comments
     * 
     * @param integer $post_id
     * @return void
     */
    public function enable_post_comments($post_id) {
        global $db;
        /* (check|get) post */
        $post = $this->_check_post($post_id);
        if(!$post) {
            _error(403);
        }
        /* check if viewer can edit post */
        if(!$post['manage_post']) {
            _error(403);
        }
        /* trun on post commenting */
        $db->query(sprintf("UPDATE posts SET comments_disabled = '0' WHERE post_id = %s", secure($post_id, 'int') )) or _error(SQL_ERROR_THROWEN);
    }


    /**
     * sold_post
     * 
     * @param integer $post_id
     * @return void
     */
    public function sold_post($post_id) {
        global $db;
        /* (check|get) post */
        $post = $this->_check_post($post_id);
        if(!$post) {
            _error(403);
        }
        /* check if viewer can edit post */
        if(!$post['manage_post']) {
            _error(403);
        }
        /* sold post */
        $db->query(sprintf("UPDATE posts_products SET available = '0' WHERE post_id = %s", secure($post_id, 'int') )) or _error(SQL_ERROR_THROWEN);
    }


    /**
     * unsold_post
     * 
     * @param integer $post_id
     * @return void
     */
    public function unsold_post($post_id) {
        global $db;
        /* (check|get) post */
        $post = $this->_check_post($post_id);
        if(!$post) {
            _error(403);
        }
        /* check if viewer can edit post */
        if(!$post['manage_post']) {
            _error(403);
        }
        /* unsold post */
        $db->query(sprintf("UPDATE posts_products SET available = '1' WHERE post_id = %s", secure($post_id, 'int') )) or _error(SQL_ERROR_THROWEN);
    }


    /**
     * save_post
     * 
     * @param integer $post_id
     * @return void
     */
    public function save_post($post_id) {
        global $db, $date;
        /* (check|get) post */
        $post = $this->_check_post($post_id);
        if(!$post) {
            _error(403);
        }
        /* save post */
        if(!$post['i_save']) {
            $db->query(sprintf("INSERT INTO posts_saved (post_id, user_id, time) VALUES (%s, %s, %s)", secure($post_id, 'int'), secure($this->_data['user_id'], 'int'), secure($date) )) or _error(SQL_ERROR_THROWEN);
        }
    }


    /**
     * unsave_post
     * 
     * @param integer $post_id
     * @return void
     */
    public function unsave_post($post_id) {
        global $db;
        /* (check|get) post */
        $post = $this->_check_post($post_id);
        if(!$post) {
            _error(403);
        }
        /* unsave post */
        if($post['i_save']) {
            $db->query(sprintf("DELETE FROM posts_saved WHERE post_id = %s AND user_id = %s", secure($post_id, 'int'), secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
        }
    }


    /**
     * boost_post
     * 
     * @param integer $post_id
     * @return void
     */
    public function boost_post($post_id) {
        global $db;
        /* (check|get) post */
        $post = $this->_check_post($post_id);
        if(!$post) {
            _error(403);
        }
        /* check if viewer can edit post */
        if(!$post['manage_post']) {
            _error(403);
        }
        /* check if viewer can boost post */
        if(!$this->_data['can_boost_posts']) {
            modal(MESSAGE, __("Sorry"), __("You reached the maximum number of boosted posts! Upgrade your package to get more"));
        }
        /* boost post */
        if(!$post['boosted']) {
            /* boost post */
            $db->query(sprintf("UPDATE posts SET boosted = '1', boosted_by = %s WHERE post_id = %s", secure($this->_data['user_id'], 'int'), secure($post_id, 'int'))) or _error(SQL_ERROR_THROWEN);
            /* update user */
            $db->query(sprintf("UPDATE users SET user_boosted_posts = user_boosted_posts + 1 WHERE user_id = %s", secure($this->_data['user_id'], 'int'))) or _error(SQL_ERROR_THROWEN);
        }
    }


    /**
     * unboost_post
     * 
     * @param integer $post_id
     * @return void
     */
    public function unboost_post($post_id) {
        global $db;
        /* (check|get) post */
        $post = $this->_check_post($post_id);
        if(!$post) {
            _error(403);
        }
        /* check if viewer can edit post */
        if(!$post['manage_post']) {
            _error(403);
        }
        /* unboost post */
        if($post['boosted']) {
            /* unboost post */
            $db->query(sprintf("UPDATE posts SET boosted = '0', boosted_by = NULL WHERE post_id = %s", secure($post_id, 'int'))) or _error(SQL_ERROR_THROWEN);
            /* update user */
            $db->query(sprintf("UPDATE users SET user_boosted_posts = IF(user_boosted_posts=0,0,user_boosted_posts-1) WHERE user_id = %s", secure($this->_data['user_id'], 'int'))) or _error(SQL_ERROR_THROWEN);
        }
    }


    /**
     * pin_post
     * 
     * @param integer $post_id
     * @return void
     */
    public function pin_post($post_id) {
        global $db;
        /* (check|get) post */
        $post = $this->_check_post($post_id);
        if(!$post) {
            _error(403);
        }
        /* check if viewer can edit post */
        if(!$post['manage_post']) {
            _error(403);
        }
        /* pin post */
        if(!$post['pinned']) {
            /* check the post author type */
            if($post['user_type'] == "user") {
                /* user */
                if($post['in_group']) {
                    /* update group */
                    $db->query(sprintf("UPDATE groups SET group_pinned_post = %s WHERE group_id = %s", secure($post_id, 'int'), secure($post['group_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                } elseif ($post['in_event']) {
                    /* update event */
                    $db->query(sprintf("UPDATE events SET event_pinned_post = %s WHERE event_id = %s", secure($post_id, 'int'), secure($post['event_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                } else {
                    /* update user */
                    $db->query(sprintf("UPDATE users SET user_pinned_post = %s WHERE user_id = %s", secure($post_id, 'int'), secure($post['author_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                }
            } else {
                /* update page */
                $db->query(sprintf("UPDATE pages SET page_pinned_post = %s WHERE page_id = %s", secure($post_id, 'int'), secure($post['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
            }
        }
    }


    /**
     * unpin_post
     * 
     * @param integer $post_id
     * @return void
     */
    public function unpin_post($post_id) {
        global $db;
        /* (check|get) post */
        $post = $this->_check_post($post_id);
        if(!$post) {
            _error(403);
        }
        /* check if viewer can edit post */
        if(!$post['manage_post']) {
            _error(403);
        }
        /* pin post */
        if($post['pinned']) {
            /* check the post author type */
            if($post['user_type'] == "user") {
                /* user */
                if($post['in_group']) {
                    /* update group */
                    $db->query(sprintf("UPDATE groups SET group_pinned_post = '0' WHERE group_id = %s", secure($post['group_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                } elseif($post['in_event']) {
                    /* update event */
                    $db->query(sprintf("UPDATE events SET event_pinned_post = '0' WHERE event_id = %s", secure($post['event_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                } else {
                    /* update user */
                    $db->query(sprintf("UPDATE users SET user_pinned_post = '0' WHERE user_id = %s", secure($post['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                }
            } else {
                /* update page */
                $db->query(sprintf("UPDATE pages SET page_pinned_post = '0' WHERE page_id = %s", secure($post['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
            }
        }
    }


    /**
     * like_post
     * 
     * @param integer $post_id
     * @return void
     */
    public function like_post($post_id) {
        global $db;
        /* (check|get) post */
        $post = $this->_check_post($post_id);
        if(!$post) {
            _error(403);
        }
        /* check blocking */
        if($this->blocked($post['author_id'])) {
            _error(403);
        }
        /* like the post */
        if(!$post['i_like']) {
            $db->query(sprintf("INSERT INTO posts_likes (user_id, post_id) VALUES (%s, %s)", secure($this->_data['user_id'], 'int'), secure($post_id, 'int') )) or _error(SQL_ERROR_THROWEN);
            /* update post likes counter */
            $db->query(sprintf("UPDATE posts SET likes = likes + 1 WHERE post_id = %s", secure($post_id, 'int') )) or _error(SQL_ERROR_THROWEN);
            /* post notification */
            $this->post_notification( array('to_user_id'=>$post['author_id'], 'action'=>'like', 'node_type'=>'post', 'node_url'=>$post_id) );
            /* points balance */
            $this->points_balance("add", "reaction", $this->_data['user_id']);
        }
    }


    /**
     * unlike_post
     * 
     * @param integer $post_id
     * @return void
     */
    public function unlike_post($post_id) {
        global $db;
        /* (check|get) post */
        $post = $this->_check_post($post_id);
        if(!$post) {
            _error(403);
        }
        /* check blocking */
        if($this->blocked($post['author_id'])) {
            _error(403);
        }
        /* unlike the post */
        if($post['i_like']) {
            $db->query(sprintf("DELETE FROM posts_likes WHERE user_id = %s AND post_id = %s", secure($this->_data['user_id'], 'int'), secure($post_id, 'int') )) or _error(SQL_ERROR_THROWEN);
            /* update post likes counter */
            $db->query(sprintf("UPDATE posts SET likes = IF(likes=0,0,likes-1) WHERE post_id = %s", secure($post_id, 'int') )) or _error(SQL_ERROR_THROWEN);
            /* delete notification */
            $this->delete_notification($post['author_id'], 'like', 'post', $post_id);
            /* points balance */
            $this->points_balance("delete", "reaction", $this->_data['user_id']);
        }
    }


    /**
     * hide_post
     * 
     * @param integer $post_id
     * @return void
     */
    public function hide_post($post_id) {
        global $db;
        /* (check|get) post */
        $post = $this->_check_post($post_id);
        if(!$post) {
            _error(403);
        }
        /* check blocking */
        if($this->blocked($post['author_id'])) {
            _error(403);
        }
        /* hide the post */
        $db->query(sprintf("INSERT INTO posts_hidden (user_id, post_id) VALUES (%s, %s)", secure($this->_data['user_id'], 'int'), secure($post_id, 'int') )) or _error(SQL_ERROR_THROWEN);
    }


    /**
     * unhide_post
     * 
     * @param integer $post_id
     * @return void
     */
    public function unhide_post($post_id) {
        global $db;
        /* (check|get) post */
        $post = $this->_check_post($post_id);
        if(!$post) {
            _error(403);
        }
        /* unhide the post */
        $db->query(sprintf("DELETE FROM posts_hidden WHERE user_id = %s AND post_id = %s", secure($this->_data['user_id'], 'int'), secure($post_id, 'int') )) or _error(SQL_ERROR_THROWEN);
    }


    /**
     * add_vote
     * 
     * @param integer $option_id
     * @return void
     */
    public function add_vote($option_id) {
        global $db;
        /* get poll */
        $get_poll = $db->query(sprintf("SELECT posts_polls.* FROM posts_polls_options INNER JOIN posts_polls ON posts_polls_options.poll_id = posts_polls.poll_id WHERE option_id = %s", secure($option_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        if($get_poll->num_rows == 0) {
             _error(403);
        }
        $poll = $get_poll->fetch_assoc();
        /* (check|get) post */
        $post = $this->_check_post($poll['post_id']);
        if(!$post) {
            _error(403);
        }
        /* check blocking */
        if($this->blocked($post['author_id'])) {
            _error(403);
        }
        /* insert user vote */
        $vote = $db->query(sprintf("INSERT INTO posts_polls_options_users (user_id, poll_id, option_id) VALUES (%s, %s, %s)", secure($this->_data['user_id'], 'int'), secure($poll['poll_id'], 'int'), secure($option_id, 'int')  ));
        if($vote) {
            /* update poll votes */
            $db->query(sprintf("UPDATE posts_polls SET votes = votes + 1 WHERE poll_id = %s", secure($poll['poll_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
            /* post notification */
            $this->post_notification( array('to_user_id'=>$post['author_id'], 'action'=>'vote', 'node_type'=>'post', 'node_url'=>$post['post_id']) );
        }
    }


    /**
     * delete_vote
     * 
     * @param integer $option_id
     * @return void
     */
    public function delete_vote($option_id) {
        global $db;
        /* get poll */
        $get_poll = $db->query(sprintf("SELECT posts_polls.* FROM posts_polls_options INNER JOIN posts_polls ON posts_polls_options.poll_id = posts_polls.poll_id WHERE option_id = %s", secure($option_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        if($get_poll->num_rows == 0) {
             _error(403);
        }
        $poll = $get_poll->fetch_assoc();
        /* (check|get) post */
        $post = $this->_check_post($poll['post_id']);
        if(!$post) {
            _error(403);
        }
        /* check blocking */
        if($this->blocked($post['author_id'])) {
            _error(403);
        }
        /* delete user vote */
        $db->query(sprintf("DELETE FROM posts_polls_options_users WHERE user_id = %s AND poll_id = %s AND option_id = %s", secure($this->_data['user_id'], 'int'), secure($poll['poll_id'], 'int'), secure($option_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        if($db->affected_rows > 0) {
            /* update poll votes */
            $db->query(sprintf("UPDATE posts_polls SET votes = IF(votes=0,0,votes-1) WHERE poll_id = %s", secure($poll['poll_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
            /* delete notification */
            $this->delete_notification($post['author_id'], 'vote', 'post', $post['post_id']);
        }
    }


    /**
     * change_vote
     * 
     * @param integer $option_id
     * @param integer $checked_id
     * @return void
     */
    public function change_vote($option_id, $checked_id) {
        global $db;
        /* get poll */
        $get_poll = $db->query(sprintf("SELECT posts_polls.* FROM posts_polls_options INNER JOIN posts_polls ON posts_polls_options.poll_id = posts_polls.poll_id WHERE option_id = %s", secure($option_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        if($get_poll->num_rows == 0) {
             _error(403);
        }
        $poll = $get_poll->fetch_assoc();
        /* (check|get) post */
        $post = $this->_check_post($poll['post_id']);
        if(!$post) {
            _error(403);
        }
        /* check blocking */
        if($this->blocked($post['author_id'])) {
            _error(403);
        }
        /* delete old vote */
        $db->query(sprintf("DELETE FROM posts_polls_options_users WHERE user_id = %s AND poll_id = %s AND option_id = %s", secure($this->_data['user_id'], 'int'), secure($poll['poll_id'], 'int'), secure($checked_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        if($db->affected_rows > 0) {
            /* insert new vote */
            $db->query(sprintf("INSERT INTO posts_polls_options_users (user_id, poll_id, option_id) VALUES (%s, %s, %s)", secure($this->_data['user_id'], 'int'), secure($poll['poll_id'], 'int'), secure($option_id, 'int')  )) or _error(SQL_ERROR_THROWEN);
        }
    }


    
    /* ------------------------------- */
    /* Articles */
    /* ------------------------------- */

    /**
     * get_articles
     * 
     * @param array $args
     * @return array
     */
    public function get_articles($args = []) {
        global $db, $system;
        /* initialize arguments */
        $category = !isset($args['category']) ? null : $args['category'];
        $offset = !isset($args['offset']) ? 0 : $args['offset'];
        $random = !isset($args['random']) ? false : true;
        $results = !isset($args['results']) ? $system['max_results'] : $args['results'];
        /* initialize vars */
        $posts = array();
        $offset *= $results;
        /* get posts */
        $where_query = ($category != null)? sprintf("AND posts_articles.category_id = %s", secure($args['category'], 'int')) : "";
        $order_query = ($random) ? "ORDER BY RAND()" : "ORDER BY posts.post_id DESC";
        $get_posts = $db->query(sprintf("SELECT posts.post_id FROM posts INNER JOIN posts_articles ON posts.post_id = posts_articles.post_id WHERE posts.post_type = 'article' ".$where_query." ".$order_query." LIMIT %s, %s", secure($offset, 'int', false), secure($results, 'int', false) )) or _error(SQL_ERROR_THROWEN);
        if($get_posts->num_rows > 0) {
            while($post = $get_posts->fetch_assoc()) {
                $post = $this->get_post($post['post_id']);
                if($post) {
                    $posts[] = $post;
                }
            }
        }
        return $posts;
    }


    /**
     * post_article
     * 
     * @param string $title
     * @param string $text
     * @param string $cover
     * @param integer $category_id
     * @param string $tags
     * @return integer
     */
    public function post_article($title, $text, $cover, $category_id, $tags) {
        global $db, $system, $date;
        /* check if blogs enabled */
        if(!$system['blogs_enabled'] || !$this->_data['can_write_articles']) {
            throw new Exception(__("This feature has been disabled by the admin"));
        }
        /* validate title */
        if(is_empty($title)) {
            throw new Exception(__("You must enter a title for your article"));
        }
        if(strlen($title) < 3) {
            throw new Exception(__("Article title must be at least 3 characters long. Please try another"));
        }
        /* validate text */
        if(is_empty($text)) {
            throw new Exception(__("You must enter some text for your article"));
        }
        /* validate category */
        if(is_empty($category_id)) {
            throw new Exception(__("You must select valid category for your article"));
        }
        $check = $db->query(sprintf("SELECT * FROM blogs_categories WHERE category_id = %s", secure($category_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        if($check->num_rows == 0) {
            throw new Exception(__("You must select valid category for your article"));
        }
        /* insert the post */
        $db->query(sprintf("INSERT INTO posts (user_id, user_type, post_type, time, privacy) VALUES (%s, 'user', 'article', %s, 'public')", secure($this->_data['user_id'], 'int'), secure($date) )) or _error(SQL_ERROR_THROWEN);
        $post_id = $db->insert_id;
        /* insert article */
        $db->query(sprintf("INSERT INTO posts_articles (post_id, cover, title, text, category_id, tags) VALUES (%s, %s, %s, %s, %s, %s)", secure($post_id, 'int'), secure($cover), secure($title), secure($text), secure($category_id, 'int'), secure($tags) )) or _error(SQL_ERROR_THROWEN);
        /* points balance */
        $this->points_balance("add", "post", $this->_data['user_id']);
        return $post_id;
    }


    /**
     * update_article
     * 
     * @param integer $post_id
     * @param string $title
     * @param string $text
     * @param string $cover
     * @param integer $category_id
     * @param string $tags
     * @return void
     */
    public function edit_article($post_id, $title, $text, $cover, $category_id, $tags) {
        global $db, $system, $date;
        /* check if blogs enabled */
        if(!$system['blogs_enabled']) {
            throw new Exception(__("This feature has been disabled by the admin"));
        }
        /* (check|get) post */
        $post = $this->_check_post($post_id, true);
        if(!$post) {
            _error(403);
        }
        /* check if viewer can edit post */
        if(!$post['manage_post']) {
            _error(403);
        }
        /* validate title */
        if(is_empty($title)) {
            throw new Exception(__("You must enter a title for your article"));
        }
        if(strlen($title) < 3) {
            throw new Exception(__("Article title must be at least 3 characters long. Please try another"));
        }
        /* validate text */
        if(is_empty($text)) {
            throw new Exception(__("You must enter some text for your article"));
        }
        /* validate category */
        if(is_empty($category_id)) {
            throw new Exception(__("You must select valid category for your article"));
        }
        $check = $db->query(sprintf("SELECT * FROM blogs_categories WHERE category_id = %s", secure($category_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        if($check->num_rows == 0) {
            throw new Exception(__("You must select valid category for your article"));
        }
        /* update the article */
        $db->query(sprintf("UPDATE posts_articles SET cover = %s, title = %s, text = %s, category_id = %s, tags = %s WHERE post_id = %s", secure($cover), secure($title), secure($text), secure($category_id, 'int'), secure($tags), secure($post_id, 'int') )) or _error(SQL_ERROR_THROWEN);
    }


    /**
     * update_article_views
     * 
     * @param integer $article_id
     * @return void
     */
    public function update_article_views($article_id) {
        global $db;
        /* update */
        $db->query(sprintf("UPDATE posts_articles SET views = views + 1 WHERE article_id = %s", secure($article_id, 'int') )) or _error(SQL_ERROR_THROWEN);
    }


    /**
     * get_blogs_categories_ids
     * 
     * @return array
     */
    public function get_blogs_categories_ids() {
        global $db;
        $categories = array();
        $get_categories = $db->query("SELECT category_id FROM blogs_categories") or _error(SQL_ERROR_THROWEN);
        if($get_categories->num_rows > 0) {
            while($category = $get_categories->fetch_assoc()) {
                $categories[] = $category['category_id'];
            }
        }
        return $categories;
    }


    /**
     * get_blogs_categories
     * 
     * @return array
     */
    public function get_blogs_categories() {
        global $db;
        $categories = array();
        $get_categories = $db->query("SELECT * FROM blogs_categories") or _error(SQL_ERROR_THROWEN);
        if($get_categories->num_rows > 0) {
            while($category = $get_categories->fetch_assoc()) {
                $category['category_url'] = get_url_text($category['category_name']);
                $categories[] = $category;
            }
        }
        return $categories;
    }



    /* ------------------------------- */
    /* Pages */
    /* ------------------------------- */

    /**
     * get_pages
     * 
     * @param array $args
     * @return array
     */
    public function get_pages($args = []) {
        global $db, $system;
        /* initialize arguments */
        $user_id = !isset($args['user_id']) ? null : $args['user_id'];
        $offset = !isset($args['offset']) ? 0 : $args['offset'];
        $promoted = !isset($args['promoted']) ? false : true;
        $suggested = !isset($args['suggested']) ? false : true;
        $random = !isset($args['random']) ? false : true;
        $boosted = !isset($args['boosted']) ? false : true;
        $managed = !isset($args['managed']) ? false : true;
        $results = !isset($args['results']) ? $system['max_results_even'] : $args['results'];
        /* initialize vars */
        $pages = array();
        $offset *= $results;
        /* get suggested pages */
        if($promoted) {
            $get_pages = $db->query("SELECT * FROM pages WHERE page_boosted = '1' ORDER BY RAND() LIMIT 3") or _error(SQL_ERROR_THROWEN);
        } elseif($suggested) {
            $pages_ids = $this->get_pages_ids();
            $random_statement = ($random) ? "ORDER BY RAND()" : "";
            if(count($pages_ids) > 0) {
                /* make a list from liked pages */
                $pages_list = implode(',',$pages_ids);
                $get_pages = $db->query(sprintf("SELECT * FROM pages WHERE page_id NOT IN (%s) ".$random_statement." LIMIT %s, %s", $pages_list, secure($offset, 'int', false), secure($results, 'int', false) )) or _error(SQL_ERROR_THROWEN);
            } else {
                $get_pages = $db->query(sprintf("SELECT * FROM pages ".$random_statement." LIMIT %s, %s", secure($offset, 'int', false), secure($results, 'int', false) )) or _error(SQL_ERROR_THROWEN);
            }
        /* get the "viewer" boosted pages */
        } elseif($boosted) {
            $get_pages = $db->query(sprintf("SELECT * FROM pages WHERE page_boosted = '1' AND page_boosted_by = %s LIMIT %s, %s", secure($this->_data['user_id'], 'int'), secure($offset, 'int', false), secure($results, 'int', false) )) or _error(SQL_ERROR_THROWEN);
        /* get the "taget" all pages who admin */
        } elseif($managed) {
            $get_pages = $db->query(sprintf("SELECT pages.* FROM pages_admins INNER JOIN pages ON pages_admins.page_id = pages.page_id WHERE pages_admins.user_id = %s ORDER BY page_id DESC", secure($user_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        /* get the "viewer" pages who admin */
        } elseif($user_id == null) {
            $get_pages = $db->query(sprintf("SELECT pages.* FROM pages_admins INNER JOIN pages ON pages_admins.page_id = pages.page_id WHERE pages_admins.user_id = %s ORDER BY page_id DESC LIMIT %s, %s", secure($this->_data['user_id'], 'int'), secure($offset, 'int', false), secure($results, 'int', false) )) or _error(SQL_ERROR_THROWEN);
        /* get the "target" liked pages*/
        } else {
            /* get the target user's privacy */
            $get_privacy = $db->query(sprintf("SELECT user_privacy_pages FROM users WHERE user_id = %s", secure($user_id, 'int') )) or _error(SQL_ERROR_THROWEN);
            $privacy = $get_privacy->fetch_assoc();
            /* check the target user's privacy  */
            if(!$this->_check_privacy($privacy['user_privacy_pages'], $user_id)) {
                return $pages;
            }
            $get_pages = $db->query(sprintf("SELECT pages.* FROM pages INNER JOIN pages_likes ON pages.page_id = pages_likes.page_id WHERE pages_likes.user_id = %s LIMIT %s, %s", secure($user_id, 'int'), secure($offset, 'int', false), secure($results, 'int', false) )) or _error(SQL_ERROR_THROWEN);
        }
        if($get_pages->num_rows > 0) {
            while($page = $get_pages->fetch_assoc()) {
                $page['page_picture'] = get_picture($page['page_picture'], 'page');
                /* check if the viewer liked the page */
                $page['i_like'] = false;
                if($this->_logged_in) {
                    $get_likes = $db->query(sprintf("SELECT * FROM pages_likes WHERE page_id = %s AND user_id = %s", secure($page['page_id'], 'int'), secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                    if($get_likes->num_rows > 0) {
                        $page['i_like'] = true;
                    }
                }
                $pages[] = $page;
            }
        }
        return $pages;
    }


    /**
     * get_pages_categories
     * 
     * @return array
     */
    public function get_pages_categories() {
        global $db;
        $categories = array();
        $get_categories = $db->query("SELECT * FROM pages_categories") or _error(SQL_ERROR_THROWEN);
        if($get_categories->num_rows > 0) {
            while($category = $get_categories->fetch_assoc()) {
                $categories[] = $category;
            }
        }
        return $categories;
    }


    /**
     * create_page
     * 
     * @param array $args
     * @return void
     */
    public function create_page($args = []) {
        global $db, $system, $date;
        /* check if pages enabled */
        if($this->_data['user_group'] >= 3 && !$system['pages_enabled']) {
            throw new Exception(__("This feature has been disabled by the admin"));
        }
        /* validate title */
        if(is_empty($args['title'])) {
            throw new Exception(__("You must enter a title for your page"));
        }
        if(strlen($args['title']) < 3) {
            throw new Exception(__("Page title must be at least 3 characters long. Please try another"));
        }
        /* validate username */
        if(is_empty($args['username'])) {
            throw new Exception(__("You must enter a username for your page"));
        }
        if(!valid_username($args['username'])) {
            throw new Exception(__("Please enter a valid username (a-z0-9_.) with minimum 3 characters long"));
        }
        if(reserved_username($args['username'])) {
            throw new Exception(__("You can't use")." <strong>".$args['username']."</strong> ".__("as username"));
        }
        if($this->check_username($args['username'], 'page')) {
            throw new Exception(__("Sorry, it looks like this username")." <strong>".$args['username']."</strong> ".__("belongs to an existing page"));
        }
        /* validate category */
        if(is_empty($args['category'])) {
            throw new Exception(__("You must select valid category for your page"));
        }
        $check = $db->query(sprintf("SELECT * FROM pages_categories WHERE category_id = %s", secure($args['category'], 'int') )) or _error(SQL_ERROR_THROWEN);
        if($check->num_rows == 0) {
            throw new Exception(__("You must select valid category for your page"));
        }
        /* set custom fields */
        $custom_fields = $this->set_custom_fields($args, "page");
        /* insert new page */
        $db->query(sprintf("INSERT INTO pages (page_admin, page_category, page_name, page_title, page_description, page_date) VALUES (%s, %s, %s, %s, %s, %s)", secure($this->_data['user_id'], 'int'), secure($args['category'], 'int'), secure($args['username']), secure($args['title']), secure($args['description']), secure($date) )) or _error(SQL_ERROR_THROWEN);
        /* get page_id */
        $page_id = $db->insert_id;
        /* insert custom fields values */
        if($custom_fields) {
            foreach($custom_fields as $field_id => $value) {
                $db->query(sprintf("INSERT INTO custom_fields_values (value, field_id, node_id, node_type) VALUES (%s, %s, %s, 'page')", secure($value), secure($field_id, 'int'), secure($page_id, 'int') ));
            }
        }
        /* like the page */
        $this->connect("page-like", $page_id);
        /* page admin addation */
        $this->connect("page-admin-addation", $page_id, $this->_data['user_id']);
    }


    /**
     * edit_page
     * 
     * @param integer $page_id
     * @param string $edit
     * @param array $args
     * @return string
     */
    public function edit_page($page_id, $edit, $args) {
        global $db, $system;
        /* check if pages enabled */
        if($this->_data['user_group'] >= 3 && !$system['pages_enabled']) {
            throw new Exception(__("This feature has been disabled by the admin"));
        }
        /* (check&get) page */
        $get_page = $db->query(sprintf("SELECT * FROM pages WHERE page_id = %s", secure($page_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        if($get_page->num_rows == 0) {
            _error(403);
        }
        $page = $get_page->fetch_assoc();
        /* check permission */
        $can_edit = false;
        /* viewer is (admin|moderator) */
        if($this->_data['user_group'] < 3) {
            $can_edit = true;
        /* viewer is the admin of page */
        } elseif($this->check_page_adminship($this->_data['user_id'], $page_id)) {
            $can_edit = true;
        }
        if(!$can_edit) {
            _error(403);
        }
        /* edit page */
        switch ($edit) {
            case 'settings':
                /* validate title */
                if(is_empty($args['title'])) {
                    throw new Exception(__("You must enter a title for your page"));
                }
                if(strlen($args['title']) < 3) {
                    throw new Exception(__("Page title must be at least 3 characters long. Please try another"));
                }
                /* validate username */
                if(strtolower($args['username']) != strtolower($page['page_name'])) {
                    if(is_empty($args['username'])) {
                        throw new Exception(__("You must enter a username for your page"));
                    }
                    if(!valid_username($args['username'])) {
                        throw new Exception(__("Please enter a valid username (a-z0-9_.) with minimum 3 characters long"));
                    }
                    if(reserved_username($args['username'])) {
                        throw new Exception(__("You can't use")." <strong>".$args['username']."</strong> ".__("as username"));
                    }
                    if($this->check_username($args['username'], 'page')) {
                        throw new Exception(__("Sorry, it looks like this username")." <strong>".$args['username']."</strong> ".__("belongs to an existing page"));
                    }
                    /* set new page name */
                    $page['page_name'] = $args['username'];
                }
                /* validate category */
                if(is_empty($args['category'])) {
                    throw new Exception(__("You must select valid category for your page"));
                }
                $check = $db->query(sprintf("SELECT * FROM pages_categories WHERE category_id = %s", secure($args['category'], 'int') )) or _error(SQL_ERROR_THROWEN);
                if($check->num_rows == 0) {
                    throw new Exception(__("You must select valid category for your page"));
                }
                /* edit from admin panel */
                if($this->_data['user_group'] >= 3 && !isset($args['page_verified'])) {
                    $args['page_verified'] = $page['page_verified'];
                }
                if($this->_data['user_group'] >= 3 && !isset($args['page_description'])) {
                    $args['page_description'] = $page['page_description'];
                }
                /* update page */
                $db->query(sprintf("UPDATE pages SET page_category = %s, page_name = %s, page_title = %s, page_description = %s, page_verified = %s WHERE page_id = %s", secure($args['category'], 'int'), secure($args['username']), secure($args['title']), secure($args['page_description']), secure($args['page_verified']), secure($page_id, 'int') )) or _error(SQL_ERROR_THROWEN);
                break;

            case 'info':
                /* validate website */
                if(!is_empty($args['website']) && !valid_url($args['website'])) {
                    throw new Exception(__("Please enter a valid website URL"));
                }
                /* set custom fields */
                $custom_fields = $this->set_custom_fields($args, "page" ,"settings", $page_id);
                /* update page */
                $db->query(sprintf("UPDATE pages SET page_company = %s, page_phone = %s, page_website = %s, page_location = %s, page_description = %s WHERE page_id = %s", secure($args['company']), secure($args['phone']), secure($args['website']), secure($args['location']), secure($args['description']), secure($page_id, 'int') )) or _error(SQL_ERROR_THROWEN);
                break;

            case 'action':
                /* validate action color */
                if(!in_array($args['action_color'], array('default', 'primary', 'success', 'info', 'warning', 'danger'))) {
                    throw new Exception(__("Please select a valid action button color"));
                }
                /* validate action URL */
                if(!is_empty($args['action_url']) && !valid_url($args['action_url'])) {
                    throw new Exception(__("Please enter a valid action button URL"));
                }
                /* update page */
                $db->query(sprintf("UPDATE pages SET page_action_text = %s, page_action_color = %s, page_action_url = %s WHERE page_id = %s", secure($args['action_text']), secure($args['action_color']), secure($args['action_url']), secure($page_id, 'int') )) or _error(SQL_ERROR_THROWEN);
                break;

            case 'social':
                /* validate facebook */
                if(!is_empty($args['facebook']) && !valid_url($args['facebook'])) {
                    throw new Exception(__("Please enter a valid Facebook Profile URL"));
                }
                /* validate twitter */
                if(!is_empty($args['twitter']) && !valid_url($args['twitter'])) {
                    throw new Exception(__("Please enter a valid Twitter Profile URL"));
                }
                /* validate google */
                if(!is_empty($args['google']) && !valid_url($args['google'])) {
                    throw new Exception(__("Please enter a valid Google+ Profile URL"));
                }
                /* validate youtube */
                if(!is_empty($args['youtube']) && !valid_url($args['youtube'])) {
                    throw new Exception(__("Please enter a valid YouTube Profile URL"));
                }
                /* validate instagram */
                if(!is_empty($args['instagram']) && !valid_url($args['instagram'])) {
                    throw new Exception(__("Please enter a valid Instagram Profile URL"));
                }
                /* validate linkedin */
                if(!is_empty($args['linkedin']) && !valid_url($args['linkedin'])) {
                    throw new Exception(__("Please enter a valid Linkedin Profile URL"));
                }
                /* validate vkontakte */
                if(!is_empty($args['vkontakte']) && !valid_url($args['vkontakte'])) {
                    throw new Exception(__("Please enter a valid Vkontakte Profile URL"));
                }
                /* update page */
                $db->query(sprintf("UPDATE pages SET page_social_facebook = %s, page_social_twitter = %s, page_social_google = %s, page_social_youtube = %s, page_social_instagram = %s, page_social_linkedin = %s, page_social_vkontakte = %s WHERE page_id = %s", secure($args['facebook']), secure($args['twitter']), secure($args['google']), secure($args['youtube']), secure($args['instagram']), secure($args['linkedin']), secure($args['vkontakte']), secure($page_id, 'int') )) or _error(SQL_ERROR_THROWEN);
                break;
        }
        return $page['page_name'];
    }


    /**
     * delete_page
     * 
     * @param integer $page_id
     * @return void
     */
    public function delete_page($page_id) {
        global $db, $system;
        /* check if pages enabled */
        if($this->_data['user_group'] >= 3 && !$system['pages_enabled']) {
            throw new Exception(__("This feature has been disabled by the admin"));
        }
        /* (check&get) page */
        $get_page = $db->query(sprintf("SELECT * FROM pages WHERE page_id = %s", secure($page_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        if($get_page->num_rows == 0) {
            _error(403);
        }
        $page = $get_page->fetch_assoc();
        // delete page
        $can_delete = false;
        /* viewer is (admin|moderator) */
        if($this->_data['user_group'] < 3) {
            $can_delete = true;
        }
        /* viewer is the super admin of page */
        if($this->_data['user_id'] == $page['page_admin']) {
            $can_delete = true;
        }
        /* check if viewer can delete the page */
        if(!$can_delete) {
            _error(403);
        }
        /* delete the page */
        $db->query(sprintf("DELETE FROM pages WHERE page_id = %s", secure($page_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        /* delete the page members */
        $db->query(sprintf("DELETE FROM pages_likes WHERE page_id = %s", secure($page_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        /* delete the page admins */
        $db->query(sprintf("DELETE FROM pages_admins WHERE page_id = %s", secure($page_id, 'int') )) or _error(SQL_ERROR_THROWEN);
    }


    /**
     * get_page_admins_ids
     * 
     * @param integer $page_id
     * @return array
     */
    public function get_page_admins_ids($page_id) {
        global $db;
        $admins = array();
        $get_admins = $db->query(sprintf("SELECT user_id FROM pages_admins WHERE page_id = %s", secure($page_id, 'int'))) or _error(SQL_ERROR_THROWEN);
        if($get_admins->num_rows > 0) {
            while($admin = $get_admins->fetch_assoc()) {
                $admins[] = $admin['user_id'];
            }
        }
        return $admins;
    }


    /**
     * get_page_admins
     * 
     * @param integer $page_id
     * @param integer $offset
     * @return array
     */
    public function get_page_admins($page_id, $offset = 0) {
        global $db, $system;
        $admins = array();
        $offset *= $system['max_results_even'];
        $get_admins = $db->query(sprintf("SELECT users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM pages_admins INNER JOIN users ON pages_admins.user_id = users.user_id WHERE pages_admins.page_id = %s LIMIT %s, %s", secure($page_id, 'int'), secure($offset, 'int', false), secure($system['max_results_even'], 'int', false) )) or _error(SQL_ERROR_THROWEN);
        if($get_admins->num_rows > 0) {
            while($admin = $get_admins->fetch_assoc()) {
                $admin['user_picture'] = get_picture($admin['user_picture'], $admin['user_gender']);
                /* get the connection */
                $admin['i_admin'] = true;
                $admin['connection'] = 'page_manage';
                $admin['node_id'] = $page_id;
                $admins[] = $admin;
            }
        }
        return $admins;
    }


    /**
     * get_page_members
     * 
     * @param integer $page_id
     * @param integer $offset
     * @return array
     */
    public function get_page_members($page_id, $offset = 0) {
        global $db, $system;
        $members = array();
        $offset *= $system['max_results_even'];
        $get_members = $db->query(sprintf("SELECT users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM pages_likes INNER JOIN users ON pages_likes.user_id = users.user_id WHERE pages_likes.page_id = %s LIMIT %s, %s", secure($page_id, 'int'), secure($offset, 'int', false), secure($system['max_results_even'], 'int', false) )) or _error(SQL_ERROR_THROWEN);
        if($get_members->num_rows > 0) {
            /* get page admins ids */
            $page_admins_ids = $this->get_page_admins_ids($page_id);
            while($member = $get_members->fetch_assoc()) {
                $member['user_picture'] = get_picture($member['user_picture'], $member['user_gender']);
                /* get the connection */
                $member['i_admin'] = in_array($member['user_id'], $page_admins_ids);
                $member['connection'] = 'page_manage';
                $member['node_id'] = $page_id;
                $members[] = $member;
            }
        }
        return $members;
    }


    /**
     * get_page_invites
     * 
     * @param integer $page_id
     * @param integer $offset
     * @return array
     */
    public function get_page_invites($page_id, $offset = 0) {
        global $db, $system;
        $friends = array();
        $offset *= $system['max_results_even'];
        if($this->_data['friends_ids']) {
            /* get page members */
            $members = array();
            $get_members = $db->query(sprintf("SELECT user_id FROM pages_likes WHERE page_id = %s", secure($page_id, 'int'))) or _error(SQL_ERROR_THROWEN);
            if($get_members->num_rows > 0) {
                while($member = $get_members->fetch_assoc()) {
                    $members[] = $member['user_id'];
                }
            }
            /*  */
            $potential_invites = array_diff($this->_data['friends_ids'], $members);
            if($potential_invites) {
                /* get already invited friends */
                $invited_friends = array();
                $get_invited_friends = $db->query(sprintf("SELECT user_id FROM pages_invites WHERE page_id = %s AND from_user_id = %s", secure($page_id, 'int'), secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                if($get_invited_friends->num_rows > 0) {
                    while($invited_friend = $get_invited_friends->fetch_assoc()) {
                        $invited_friends[] = $invited_friend['user_id'];
                    }
                }
                $invites_list = implode(',',array_diff($potential_invites, $invited_friends));
                if($invites_list) {
                    $get_friends = $db->query(sprintf("SELECT user_id, user_name, user_firstname, user_lastname, user_gender, user_picture FROM users WHERE user_id IN ($invites_list) LIMIT %s, %s", secure($offset, 'int', false), secure($system['max_results_even'], 'int', false) )) or _error(SQL_ERROR_THROWEN);
                    while($friend = $get_friends->fetch_assoc()) {
                        $friend['user_picture'] = get_picture($friend['user_picture'], $friend['user_gender']);
                        $friend['connection'] = 'page_invite';
                        $friend['node_id'] = $page_id;
                        $friends[] = $friend;
                    }
                }
            }
        }
        return $friends;
    }


    /**
     * check_page_adminship
     * 
     * @param integer $user_id
     * @param integer $page_id
     * @return boolean
     */
    public function check_page_adminship($user_id, $page_id) {
        if($this->_logged_in) {
            /* get page admins ids */
            $page_admins_ids = $this->get_page_admins_ids($page_id);
            if(in_array($user_id, $page_admins_ids)) {
                return true;
            }
        }
        return false;
    }


    /**
     * check_page_membership
     * 
     * @param integer $user_id
     * @param integer $page_id
     * @return boolean
     */
    public function check_page_membership($user_id, $page_id) {
        global $db;
        if($this->_logged_in) {
            $get_likes = $db->query(sprintf("SELECT * FROM pages_likes WHERE user_id = %s AND page_id = %s", secure($user_id, 'int'), secure($page_id, 'int') )) or _error(SQL_ERROR_THROWEN);
            if($get_likes->num_rows > 0) {
                return true;
            }
        }
        return false;
    }



    /* ------------------------------- */
    /* Groups */
    /* ------------------------------- */

    /**
     * get_groups
     * 
     * @param array $args
     * @return array
     */
    public function get_groups($args = []) {
        global $db, $system;
        /* initialize arguments */
        $user_id = !isset($args['user_id']) ? null : $args['user_id'];
        $offset = !isset($args['offset']) ? 0 : $args['offset'];
        $suggested = !isset($args['suggested']) ? false : true;
        $random = !isset($args['random']) ? false : true;
        $managed = !isset($args['managed']) ? false : true;
        $results = !isset($args['results']) ? $system['max_results_even'] : $args['results'];
        /* initialize vars */
        $groups = array();
        $offset *= $results;
        /* get suggested groups */
        if($suggested) {
            $where_statement = "";
            /* make a list from joined groups (approved|pending) */
            $groups_ids = $this->get_groups_ids();
            if($groups_ids) {
                $groups_list = implode(',',$groups_ids);
                $where_statement .= "AND group_id NOT IN (".$groups_list.") ";
            }
            $sort_statement = ($random) ? "ORDER BY RAND()" : "ORDER BY group_id DESC";
            $get_groups = $db->query(sprintf("SELECT * FROM groups WHERE group_privacy != 'secret' ".$where_statement.$sort_statement." LIMIT %s, %s", secure($offset, 'int', false), secure($results, 'int', false) )) or _error(SQL_ERROR_THROWEN);
        /* get the "taget" all groups who admin */
        } elseif($managed) {
            $get_groups = $db->query(sprintf("SELECT groups.* FROM groups_admins INNER JOIN groups ON groups_admins.group_id = groups.group_id WHERE groups_admins.user_id = %s ORDER BY group_id DESC", secure($user_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        /* get the "viewer" groups who admin */
        } elseif($user_id == null) {
            $get_groups = $db->query(sprintf("SELECT groups.* FROM groups_admins INNER JOIN groups ON groups_admins.group_id = groups.group_id WHERE groups_admins.user_id = %s ORDER BY group_id DESC LIMIT %s, %s", secure($this->_data['user_id'], 'int'), secure($offset, 'int', false), secure($results, 'int', false) )) or _error(SQL_ERROR_THROWEN);
        /* get the "target" groups*/
        } else {
            /* get the target user's privacy */
            $get_privacy = $db->query(sprintf("SELECT user_privacy_groups FROM users WHERE user_id = %s", secure($user_id, 'int') )) or _error(SQL_ERROR_THROWEN);
            $privacy = $get_privacy->fetch_assoc();
            /* check the target user's privacy  */
            if(!$this->_check_privacy($privacy['user_privacy_groups'], $user_id)) {
                return $groups;
            }
            /* if the viewer not the target exclude secret groups */
            $where_statement = ($this->_data['user_id'] == $user_id)? "": "AND groups.group_privacy != 'secret'";
            $get_groups = $db->query(sprintf("SELECT groups.* FROM groups INNER JOIN groups_members ON groups.group_id = groups_members.group_id WHERE groups_members.approved = '1' AND groups_members.user_id = %s ".$where_statement." ORDER BY group_id DESC LIMIT %s, %s", secure($user_id, 'int'), secure($offset, 'int', false), secure($results, 'int', false) )) or _error(SQL_ERROR_THROWEN);
        }
        if($get_groups->num_rows > 0) {
            while($group = $get_groups->fetch_assoc()) {
                $group['group_picture'] = get_picture($group['group_picture'], 'group');
                /* check if the viewer joined the group */
                $group['i_joined'] = $this->check_group_membership($this->_data['user_id'], $group['group_id']);;
                $groups[] = $group;
            }
        }
        return $groups;
    }


    /**
     * get_groups_categories
     * 
     * @return array
     */
    public function get_groups_categories() {
        global $db;
        $categories = array();
        $get_categories = $db->query("SELECT * FROM groups_categories") or _error(SQL_ERROR_THROWEN);
        if($get_categories->num_rows > 0) {
            while($category = $get_categories->fetch_assoc()) {
                $categories[] = $category;
            }
        }
        return $categories;
    }


    /**
     * create_group
     * 
     * @param array $args
     * @return void
     */
    public function create_group($args = []) {
        global $db, $system, $date;
        /* check if groups enabled */
        if($this->_data['user_group'] >= 3 && !$system['groups_enabled']) {
            throw new Exception(__("This feature has been disabled by the admin"));
        }
        /* validate title */
        if(is_empty($args['title'])) {
            throw new Exception(__("You must enter a name for your group"));
        }
        if(strlen($args['title']) < 3) {
            throw new Exception(__("Group name must be at least 3 characters long. Please try another"));
        }
        /* validate username */
        if(is_empty($args['username'])) {
            throw new Exception(__("You must enter a web address for your group"));
        }
        if(!valid_username($args['username'])) {
            throw new Exception(__("Please enter a valid web address (a-z0-9_.) with minimum 3 characters long"));
        }
        if(reserved_username($args['username'])) {
            throw new Exception(__("You can't use")." <strong>".$args['username']."</strong> ".__("as web address"));
        }
        if($this->check_username($args['username'], 'group')) {
            throw new Exception(__("Sorry, it looks like this web address")." <strong>".$args['username']."</strong> ".__("belongs to an existing group"));
        }
        /* validate category */
        if(is_empty($args['category'])) {
            throw new Exception(__("You must select valid category for your group"));
        }
        $check = $db->query(sprintf("SELECT * FROM groups_categories WHERE category_id = %s", secure($args['category'], 'int') )) or _error(SQL_ERROR_THROWEN);
        if($check->num_rows == 0) {
            throw new Exception(__("You must select valid category for your group"));
        }
        /* validate privacy */
        if(!in_array($args['privacy'], array('secret','closed','public'))) {
            throw new Exception(__("You must select a valid privacy for your group"));
        }
        /* set custom fields */
        $custom_fields = $this->set_custom_fields($args, "group");
        /* insert new group */
        $db->query(sprintf("INSERT INTO groups (group_privacy, group_admin, group_name, group_category, group_title, group_description, group_date) VALUES (%s, %s, %s, %s, %s, %s, %s)", secure($args['privacy']), secure($this->_data['user_id'], 'int'), secure($args['username']), secure($args['category']), secure($args['title']), secure($args['description']), secure($date) )) or _error(SQL_ERROR_THROWEN);
        /* get group_id */
        $group_id = $db->insert_id;
        /* insert custom fields values */
        if($custom_fields) {
            foreach($custom_fields as $field_id => $value) {
                $db->query(sprintf("INSERT INTO custom_fields_values (value, field_id, node_id, node_type) VALUES (%s, %s, %s, 'group')", secure($value), secure($field_id, 'int'), secure($group_id, 'int') ));
            }
        }
        /* join the group */
        $this->connect("group-join", $group_id);
        /* group admin addation */
        $this->connect("group-admin-addation", $group_id, $this->_data['user_id']);
    }


    /**
     * edit_group
     * 
     * @param integer $group_id
     * @param array $args
     * @return void
     */
    public function edit_group($group_id, $args) {
        global $db, $system;
        /* check if groups enabled */
        if($this->_data['user_group'] >= 3 && !$system['groups_enabled']) {
            throw new Exception(__("This feature has been disabled by the admin"));
        }
        /* (check&get) group */
        $get_group = $db->query(sprintf("SELECT * FROM groups WHERE group_id = %s", secure($group_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        if($get_group->num_rows == 0) {
            _error(403);
        }
        $group = $get_group->fetch_assoc();
        /* check permission */
        $can_edit = false;
        /* viewer is (admin|moderator) */
        if($this->_data['user_group'] < 3) {
            $can_edit = true;
        /* viewer is the admin of group */
        } elseif($this->check_group_adminship($this->_data['user_id'], $group_id)) {
            $can_edit = true;
        }
        if(!$can_edit) {
            _error(403);
        }
        /* validate title */
        if(is_empty($args['title'])) {
            throw new Exception(__("You must enter a name for your group"));
        }
        if(strlen($args['title']) < 3) {
            throw new Exception(__("Group name must be at least 3 characters long. Please try another"));
        }
        /* validate username */
        if(strtolower($args['username']) != strtolower($group['group_name'])) {
            if(is_empty($args['username'])) {
                throw new Exception(__("You must enter a web address for your group"));
            }
            if(!valid_username($args['username'])) {
                throw new Exception(__("Please enter a valid web address (a-z0-9_.) with minimum 3 characters long"));
            }
            if(reserved_username($args['username'])) {
                throw new Exception(__("You can't use")." <strong>".$args['username']."</strong> ".__("as web address"));
            }
            if($this->check_username($args['username'], 'group')) {
                throw new Exception(__("Sorry, it looks like this web address")." <strong>".$args['username']."</strong> ".__("belongs to an existing group"));
            }
        }
        /* validate privacy */
        if(!in_array($args['privacy'], array('secret','closed','public'))) {
            throw new Exception(__("You must select a valid privacy for your group"));
        }
        /* validate category */
        if(is_empty($args['category'])) {
            throw new Exception(__("You must select valid category for your group"));
        }
        $check = $db->query(sprintf("SELECT * FROM groups_categories WHERE category_id = %s", secure($args['category'], 'int') )) or _error(SQL_ERROR_THROWEN);
        if($check->num_rows == 0) {
            throw new Exception(__("You must select valid category for your group"));
        }
        /* set custom fields */
        $custom_fields = $this->set_custom_fields($args, "group" ,"settings", $group_id);
        /* update the group */
        $db->query(sprintf("UPDATE groups SET group_privacy = %s, group_category = %s, group_name = %s, group_title = %s, group_description = %s WHERE group_id = %s", secure($args['privacy']), secure($args['category']), secure($args['username']), secure($args['title']), secure($args['description']), secure($group_id, 'int') )) or _error(SQL_ERROR_THROWEN);
    }


    /**
     * delete_group
     * 
     * @param integer $group_id
     * @return void
     */
    public function delete_group($group_id) {
        global $db, $system;
        /* check if groups enabled */
        if($this->_data['user_group'] >= 3 && !$system['groups_enabled']) {
            throw new Exception(__("This feature has been disabled by the admin"));
        }
        /* (check&get) group */
        $get_group = $db->query(sprintf("SELECT * FROM groups WHERE group_id = %s", secure($group_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        if($get_group->num_rows == 0) {
            _error(403);
        }
        $group = $get_group->fetch_assoc();
        // delete group
        $can_delete = false;
        /* viewer is (admin|moderator) */
        if($this->_data['user_group'] < 3) {
            $can_delete = true;
        }
        /* viewer is the super admin of group */
        if($this->_data['user_id'] == $group['group_admin']) {
            $can_delete = true;
        }
        /* check if viewer can delete the group */
        if(!$can_delete) {
            _error(403);
        }
        /* delete the group */
        $db->query(sprintf("DELETE FROM groups WHERE group_id = %s", secure($group_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        /* delete the group members */
        $db->query(sprintf("DELETE FROM groups_members WHERE group_id = %s", secure($group_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        /* delete the group admins */
        $db->query(sprintf("DELETE FROM groups_admins WHERE group_id = %s", secure($group_id, 'int') )) or _error(SQL_ERROR_THROWEN);
    }


    /**
     * get_group_admins_ids
     * 
     * @param integer $group_id
     * @return array
     */
    public function get_group_admins_ids($group_id) {
        global $db;
        $admins = array();
        $get_admins = $db->query(sprintf("SELECT user_id FROM groups_admins WHERE group_id = %s", secure($group_id, 'int'))) or _error(SQL_ERROR_THROWEN);
        if($get_admins->num_rows > 0) {
            while($admin = $get_admins->fetch_assoc()) {
                $admins[] = $admin['user_id'];
            }
        }
        return $admins;
    }


    /**
     * get_group_admins
     * 
     * @param integer $group_id
     * @param integer $offset
     * @return array
     */
    public function get_group_admins($group_id, $offset = 0) {
        global $db, $system;
        $admins = array();
        $offset *= $system['max_results_even'];
        $get_admins = $db->query(sprintf("SELECT users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM groups_admins INNER JOIN users ON groups_admins.user_id = users.user_id WHERE groups_admins.group_id = %s LIMIT %s, %s", secure($group_id, 'int'), secure($offset, 'int', false), secure($system['max_results_even'], 'int', false) )) or _error(SQL_ERROR_THROWEN);
        if($get_admins->num_rows > 0) {
            while($admin = $get_admins->fetch_assoc()) {
                $admin['user_picture'] = get_picture($admin['user_picture'], $admin['user_gender']);
                /* get the connection */
                $admin['i_admin'] = true;
                $admin['connection'] = 'group_manage';
                $admin['node_id'] = $group_id;
                $admins[] = $admin;
            }
        }
        return $admins;
    }


    /**
     * get_group_members
     * 
     * @param integer $group_id
     * @param integer $offset
     * @param boolean $manage
     * @return array
     */
    public function get_group_members($group_id, $offset = 0, $manage = false) {
        global $db, $system;
        $members = array();
        $offset *= $system['max_results_even'];
        $get_members = $db->query(sprintf("SELECT users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM groups_members INNER JOIN users ON groups_members.user_id = users.user_id WHERE groups_members.approved = '1' AND groups_members.group_id = %s LIMIT %s, %s", secure($group_id, 'int'), secure($offset, 'int', false), secure($system['max_results_even'], 'int', false) )) or _error(SQL_ERROR_THROWEN);
        if($get_members->num_rows > 0) {
            /* get group admins ids */
            $group_admins_ids = $this->get_group_admins_ids($group_id);
            while($member = $get_members->fetch_assoc()) {
                $member['user_picture'] = get_picture($member['user_picture'], $member['user_gender']);
                if($manage) {
                    /* get the connection */
                    $member['i_admin'] = in_array($member['user_id'], $group_admins_ids);
                    $member['connection'] = 'group_manage';
                    $member['node_id'] = $group_id;
                } else {
                    /* get the connection between the viewer & the target */
                    $member['connection'] = $this->connection($member['user_id']);
                }
                $members[] = $member;
            }
        }
        return $members;
    }


    /**
     * get_group_invites
     * 
     * @param integer $group_id
     * @param integer $offset
     * @return array
     */
    public function get_group_invites($group_id, $offset = 0) {
        global $db, $system;
        $friends = array();
        $offset *= $system['max_results_even'];
        if($this->_data['friends_ids']) {
            $get_members = $db->query(sprintf("SELECT user_id FROM groups_members WHERE group_id = %s", secure($group_id, 'int'))) or _error(SQL_ERROR_THROWEN);
            if($get_members->num_rows > 0) {
                while($member = $get_members->fetch_assoc()) {
                    $members[] = $member['user_id'];
                }
                $invites_list = implode(',',array_diff($this->_data['friends_ids'], $members));
                if($invites_list) {
                    $get_friends = $db->query(sprintf("SELECT user_id, user_name, user_firstname, user_lastname, user_gender, user_picture FROM users WHERE user_id IN ($invites_list) LIMIT %s, %s", secure($offset, 'int', false), secure($system['max_results_even'], 'int', false) )) or _error(SQL_ERROR_THROWEN);
                    while($friend = $get_friends->fetch_assoc()) {
                        $friend['user_picture'] = get_picture($friend['user_picture'], $friend['user_gender']);
                        $friend['connection'] = 'group_invite';
                        $friend['node_id'] = $group_id;
                        $friends[] = $friend;
                    }
                }
            }
        }
        return $friends;
    }


    /**
     * get_group_requests
     * 
     * @param integer $group_id
     * @param integer $offset
     * @return array
     */
    public function get_group_requests($group_id, $offset = 0) {
        global $db, $system;
        $requests = array();
        $offset *= $system['max_results'];
        $get_requests = $db->query(sprintf("SELECT users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM users INNER JOIN groups_members ON users.user_id = groups_members.user_id WHERE groups_members.approved = '0' AND groups_members.group_id = %s LIMIT %s, %s", secure($group_id, 'int'), secure($offset, 'int', false), secure($system['max_results'], 'int', false) )) or _error(SQL_ERROR_THROWEN);
        if($get_requests->num_rows > 0) {
            while($request = $get_requests->fetch_assoc()) {
                $request['user_picture'] = get_picture($request['user_picture'], $request['user_gender']);
                $request['connection'] = 'group_request';
                $request['node_id'] = $group_id;
                $requests[] = $request;
            }
        }
        return $requests;
    }


    /**
     * get_group_requests_total
     * 
     * @param integer $group_id
     * @return integer
     */
    public function get_group_requests_total($group_id) {
        global $db, $system;
        $get_requests = $db->query(sprintf("SELECT  * FROM groups_members WHERE approved = '0' AND group_id = %s", secure($group_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        return $get_requests->num_rows;
    }


    /**
     * check_group_adminship
     * 
     * @param integer $user_id
     * @param integer $group_id
     * @return boolean
     */
    public function check_group_adminship($user_id, $group_id) {
        if($this->_logged_in) {
            /* get group admins ids */
            $group_admins_ids = $this->get_group_admins_ids($group_id);
            if(in_array($user_id, $group_admins_ids)) {
                return true;
            }
        }
        return false;
    }


    /**
     * check_group_membership
     * 
     * @param integer $user_id
     * @param integer $group_id
     * @return mixed
     */
    public function check_group_membership($user_id, $group_id) {
        global $db;
        if($this->_logged_in) {
            $get_membership = $db->query(sprintf("SELECT * FROM groups_members WHERE user_id = %s AND group_id = %s", secure($user_id, 'int'), secure($group_id, 'int') )) or _error(SQL_ERROR_THROWEN);
            if($get_membership->num_rows > 0) {
                $membership = $get_membership->fetch_assoc();
                return ($membership['approved'] == '1')? "approved": "pending";
            }
        }
        return false;
    }



    /* ------------------------------- */
    /* Events */
    /* ------------------------------- */

    /**
     * get_events
     * 
     * @param array $args
     * @return array
     */
    public function get_events($args = []) {
        global $db, $system;
        /* initialize arguments */
        $user_id = !isset($args['user_id']) ? null : $args['user_id'];
        $offset = !isset($args['offset']) ? 0 : $args['offset'];
        $suggested = !isset($args['suggested']) ? false : true;
        $random = !isset($args['random']) ? false : true;
        $managed = !isset($args['managed']) ? false : true;
        $filter = !isset($args['filter']) ? "admin" : $args['filter'];
        $results = !isset($args['results']) ? $system['max_results_even'] : $args['results'];
        /* initialize vars */
        $events = array();
        $offset *= $results;
        /* get suggested events */
        if($suggested) {
            $where_statement = "";
            /* make a list from joined events */
            $events_ids = $this->get_events_ids();
            if($events_ids) {
                $events_list = implode(',',$events_ids);
                $where_statement .= "AND event_id NOT IN (".$events_list.") ";
            }
            $sort_statement = ($random) ? "ORDER BY RAND()" : "ORDER BY event_id DESC";
            $get_events = $db->query(sprintf("SELECT * FROM events WHERE event_privacy != 'secret' ".$where_statement.$sort_statement." LIMIT %s, %s", secure($offset, 'int', false), secure($results, 'int', false) )) or _error(SQL_ERROR_THROWEN);
        /* get the "taget" all events who admin */
        } elseif($managed) {
            $get_events = $db->query(sprintf("SELECT * FROM events WHERE event_admin = %s ORDER BY event_id DESC", secure($user_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        /* get the "viewer" events who (going|interested|invited|admin) */
        } elseif($user_id == null) {
            switch ($filter) {
                case 'going':
                    $get_events = $db->query(sprintf("SELECT events.* FROM events INNER JOIN events_members ON events.event_id = events_members.event_id WHERE events_members.is_going = '1' AND events_members.user_id = %s ORDER BY event_id DESC LIMIT %s, %s", secure($this->_data['user_id'], 'int'), secure($offset, 'int', false), secure($results, 'int', false) )) or _error(SQL_ERROR_THROWEN);
                    break;

                case 'interested':
                    $get_events = $db->query(sprintf("SELECT events.* FROM events INNER JOIN events_members ON events.event_id = events_members.event_id WHERE events_members.is_interested = '1' AND events_members.user_id = %s ORDER BY event_id DESC LIMIT %s, %s", secure($this->_data['user_id'], 'int'), secure($offset, 'int', false), secure($results, 'int', false) )) or _error(SQL_ERROR_THROWEN);
                    break;

                case 'invited':
                    $get_events = $db->query(sprintf("SELECT events.* FROM events INNER JOIN events_members ON events.event_id = events_members.event_id WHERE events_members.is_invited = '1' AND events_members.user_id = %s ORDER BY event_id DESC LIMIT %s, %s", secure($this->_data['user_id'], 'int'), secure($offset, 'int', false), secure($results, 'int', false) )) or _error(SQL_ERROR_THROWEN);
                    break;
                
                default:
                    $get_events = $db->query(sprintf("SELECT * FROM events WHERE event_admin = %s ORDER BY event_id DESC LIMIT %s, %s", secure($this->_data['user_id'], 'int'), secure($offset, 'int', false), secure($results, 'int', false) )) or _error(SQL_ERROR_THROWEN);
                    break;
            }
        /* get the "target" events */
        } else {
            /* get the target user's privacy */
            $get_privacy = $db->query(sprintf("SELECT user_privacy_events FROM users WHERE user_id = %s", secure($user_id, 'int') )) or _error(SQL_ERROR_THROWEN);
            $privacy = $get_privacy->fetch_assoc();
            /* check the target user's privacy  */
            if(!$this->_check_privacy($privacy['user_privacy_events'], $user_id)) {
                return $events;
            }
            /* if the viewer not the target exclude secret groups */
            $where_statement = ($this->_data['user_id'] == $user_id)? "": "AND events.event_privacy != 'secret'";
            $get_events = $db->query(sprintf("SELECT events.* FROM events INNER JOIN events_members ON events.event_id = events_members.event_id WHERE (events_members.is_going = '1' OR events_members.is_interested = '1') AND events_members.user_id = %s ".$where_statement." ORDER BY event_id DESC LIMIT %s, %s", secure($user_id, 'int'), secure($offset, 'int', false), secure($results, 'int', false) )) or _error(SQL_ERROR_THROWEN);
        }
        if($get_events->num_rows > 0) {
            while($event = $get_events->fetch_assoc()) {
                $event['event_picture'] = get_picture($event['event_cover'], 'event');
                /* check if the viewer joined the event */
                $event['i_joined'] = $this->check_event_membership($this->_data['user_id'], $event['event_id']);;
                $events[] = $event;
            }
        }
        return $events;
    }


    /**
     * get_events_categories
     * 
     * @return array
     */
    public function get_events_categories() {
        global $db;
        $categories = array();
        $get_categories = $db->query("SELECT * FROM events_categories") or _error(SQL_ERROR_THROWEN);
        if($get_categories->num_rows > 0) {
            while($category = $get_categories->fetch_assoc()) {
                $categories[] = $category;
            }
        }
        return $categories;
    }


    /**
     * create_event
     * 
     * @param array $args
     * @return integer
     */
    public function create_event($args = []) {
        global $db, $system, $date;
        /* check if events enabled */
        if($this->_data['user_group'] >= 3 && !$system['events_enabled']) {
            throw new Exception(__("This feature has been disabled by the admin"));
        }
        /* validate title */
        if(is_empty($args['title'])) {
            throw new Exception(__("You must enter a name for your event"));
        }
        if(strlen($args['title']) < 3) {
            throw new Exception(__("Event name must be at least 3 characters long. Please try another"));
        }
        /* validate start & end dates */
        if(is_empty($args['start_date'])) {
            throw new Exception(__("You have to enter the event start date"));
        }
        if(is_empty($args['end_date'])) {
            throw new Exception(__("You have to enter the event end date"));
        }
        if(strtotime($args['start_date']) > strtotime($args['end_date'])) {
            throw new Exception(__("Event end date must be after the start date"));
        }
        /* validate privacy */
        if(!in_array($args['privacy'], array('secret','closed','public'))) {
            throw new Exception(__("You must select a valid privacy for your event"));
        }
        /* validate category */
        if(is_empty($args['category'])) {
            throw new Exception(__("You must select valid category for your event"));
        }
        $check = $db->query(sprintf("SELECT * FROM events_categories WHERE category_id = %s", secure($args['category'], 'int') )) or _error(SQL_ERROR_THROWEN);
        if($check->num_rows == 0) {
            throw new Exception(__("You must select valid category for your event"));
        }
        /* set custom fields */
        $custom_fields = $this->set_custom_fields($args, "event");
        /* insert new event */
        $db->query(sprintf("INSERT INTO events (event_privacy, event_admin, event_category, event_title, event_location, event_description, event_start_date, event_end_date, event_date) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)", secure($args['privacy']), secure($this->_data['user_id'], 'int'), secure($args['category'], 'int'), secure($args['title']), secure($args['location']), secure($args['description']), secure($args['start_date'], 'datetime'), secure($args['end_date'], 'datetime'), secure($date) )) or _error(SQL_ERROR_THROWEN);
        /* get event_id */
        $event_id = $db->insert_id;
        /* insert custom fields values */
        if($custom_fields) {
            foreach($custom_fields as $field_id => $value) {
                $db->query(sprintf("INSERT INTO custom_fields_values (value, field_id, node_id, node_type) VALUES (%s, %s, %s, 'event')", secure($value), secure($field_id, 'int'), secure($event_id, 'int') ));
            }
        }
        /* interest the event */
        $this->connect("event-interest", $event_id);
        /* return event id */
        return $event_id;
    }


    /**
     * edit_event
     * 
     * @param integer $event_id
     * @param string $title
     * @param string $location
     * @param string $start_date
     * @param string $end_date
     * @param string $privacy
     * @param integer $category
     * @param string $description
     * @return void
     */
    public function edit_event($event_id, $args) {
        global $db, $system;
        /* check if events enabled */
        if($this->_data['user_group'] >= 3 && !$system['events_enabled']) {
            throw new Exception(__("This feature has been disabled by the admin"));
        }
        /* (check&get) event */
        $get_event = $db->query(sprintf("SELECT * FROM events WHERE event_id = %s", secure($event_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        if($get_event->num_rows == 0) {
            _error(403);
        }
        $event = $get_event->fetch_assoc();
        /* check permission */
        $can_edit = false;
        /* viewer is (admin|moderator) */
        if($this->_data['user_group'] < 3) {
            $can_edit = true;
        /* viewer is the admin of event */
        } elseif($this->_data['user_id'] == $event['event_admin']) {
            $can_edit = true;
        }
        if(!$can_edit) {
            _error(403);
        }
        /* validate title */
        if(is_empty($args['title'])) {
            throw new Exception(__("You must enter a name for your event"));
        }
        if(strlen($args['title']) < 3) {
            throw new Exception(__("Event name must be at least 3 characters long. Please try another"));
        }
        /* validate start & end dates */
        if(is_empty($args['start_date'])) {
            throw new Exception(__("You have to enter the event start date"));
        }
        if(is_empty($args['end_date'])) {
            throw new Exception(__("You have to enter the event end date"));
        }
        if(strtotime($args['start_date']) > strtotime($args['end_date'])) {
            throw new Exception(__("Event end date must be after the start date"));
        }
        /* validate privacy */
        if(!in_array($args['privacy'], array('secret','closed','public'))) {
            throw new Exception(__("You must select a valid privacy for your event"));
        }
        /* validate category */
        if(is_empty($args['category'])) {
            throw new Exception(__("You must select valid category for your event"));
        }
        $check = $db->query(sprintf("SELECT * FROM events_categories WHERE category_id = %s", secure($args['category'], 'int') )) or _error(SQL_ERROR_THROWEN);
        if($check->num_rows == 0) {
            throw new Exception(__("You must select valid category for your event"));
        }
        /* set custom fields */
        $custom_fields = $this->set_custom_fields($args, "event" ,"settings", $event_id);
        /* update the event */
        $db->query(sprintf("UPDATE events SET event_privacy = %s, event_category = %s, event_title = %s, event_location = %s, event_description = %s, event_start_date = %s, event_end_date = %s WHERE event_id = %s", secure($args['privacy']), secure($args['category'], 'int'), secure($args['title']), secure($args['location']), secure($args['description']), secure($args['start_date'], 'datetime'), secure($args['end_date'], 'datetime'), secure($event_id, 'int') )) or _error(SQL_ERROR_THROWEN);
    }


    /**
     * delete_event
     * 
     * @param integer $event_id
     * @return void
     */
    public function delete_event($event_id) {
        global $db, $system;
        /* check if events enabled */
        if($this->_data['user_group'] >= 3 && !$system['events_enabled']) {
            throw new Exception(__("This feature has been disabled by the admin"));
        }
        /* (check&get) event */
        $get_event = $db->query(sprintf("SELECT * FROM events WHERE event_id = %s", secure($event_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        if($get_event->num_rows == 0) {
            _error(403);
        }
        $event = $get_event->fetch_assoc();
        // delete event
        $can_delete = false;
        /* viewer is (admin|moderator) */
        if($this->_data['user_group'] < 3) {
            $can_delete = true;
        /* viewer is the admin of event */
        } elseif($this->_data['user_id'] == $event['event_admin']) {
            $can_delete = true;
        }
        /* delete the event */
        if(!$can_delete) {
            _error(403);
        }
        $db->query(sprintf("DELETE FROM events WHERE event_id = %s", secure($event_id, 'int') )) or _error(SQL_ERROR_THROWEN);
    }


    /**
     * get_event_members
     * 
     * @param integer $event_id
     * @param string $handle
     * @param integer $offset
     * @return array
     */
    public function get_event_members($event_id, $handle, $offset = 0) {
        global $db, $system;
        $members = array();
        $offset *= $system['max_results_even'];
        switch ($handle) {
            case 'going':
                $get_members = $db->query(sprintf("SELECT users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM events_members INNER JOIN users ON events_members.user_id = users.user_id WHERE  events_members.is_going = '1' AND events_members.event_id = %s LIMIT %s, %s", secure($event_id, 'int'), secure($offset, 'int', false), secure($system['max_results_even'], 'int', false) )) or _error(SQL_ERROR_THROWEN);
                break;

            case 'interested':
                $get_members = $db->query(sprintf("SELECT users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM events_members INNER JOIN users ON events_members.user_id = users.user_id WHERE  events_members.is_interested = '1' AND events_members.event_id = %s LIMIT %s, %s", secure($event_id, 'int'), secure($offset, 'int', false), secure($system['max_results_even'], 'int', false) )) or _error(SQL_ERROR_THROWEN);
                break;

            case 'invited':
                $get_members = $db->query(sprintf("SELECT users.user_id, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM events_members INNER JOIN users ON events_members.user_id = users.user_id WHERE  events_members.is_invited = '1' AND events_members.event_id = %s LIMIT %s, %s", secure($event_id, 'int'), secure($offset, 'int', false), secure($system['max_results_even'], 'int', false) )) or _error(SQL_ERROR_THROWEN);
                break;
            
            default:
                _error(400);
                break;
        }
        if($get_members->num_rows > 0) {
            while($member = $get_members->fetch_assoc()) {
                $member['user_picture'] = get_picture($member['user_picture'], $member['user_gender']);
                /* get the connection between the viewer & the target */
                $member['connection'] = $this->connection($member['user_id']);
                $members[] = $member;
            }
        }
        return $members;
    }


    /**
     * get_event_invites
     * 
     * @param integer $event_id
     * @param integer $offset
     * @return array
     */
    public function get_event_invites($event_id, $offset = 0) {
        global $db, $system;
        $friends = array();
        $offset *= $system['max_results_even'];
        if($this->_data['friends_ids']) {
            $get_members = $db->query(sprintf("SELECT user_id FROM events_members WHERE event_id = %s", secure($event_id, 'int'))) or _error(SQL_ERROR_THROWEN);
            if($get_members->num_rows > 0) {
                while($member = $get_members->fetch_assoc()) {
                    $members[] = $member['user_id'];
                }
                $invites_list = implode(',',array_diff($this->_data['friends_ids'], $members));
                if($invites_list) {
                    $get_friends = $db->query(sprintf("SELECT user_id, user_name, user_firstname, user_lastname, user_gender, user_picture FROM users WHERE user_id IN ($invites_list) LIMIT %s, %s", secure($offset, 'int', false), secure($system['max_results_even'], 'int', false) )) or _error(SQL_ERROR_THROWEN);
                    while($friend = $get_friends->fetch_assoc()) {
                        $friend['user_picture'] = get_picture($friend['user_picture'], $friend['user_gender']);
                        $friend['connection'] = 'event_invite';
                        $friend['node_id'] = $event_id;
                        $friends[] = $friend;
                    }
                }
            }
        }
        return $friends;
    }


    /**
     * check_event_adminship
     * 
     * @param integer $user_id
     * @param integer $event_id
     * @return boolean
     */
    public function check_event_adminship($user_id, $event_id) {
        global $db;
        if($this->_logged_in) {
            $check = $db->query(sprintf("SELECT * FROM events WHERE event_admin = %s AND event_id = %s", secure($user_id, 'int'), secure($event_id, 'int') )) or _error(SQL_ERROR_THROWEN);
            if($check->num_rows > 0) {
                return true;
            }
        }
        return false;
    }


    /**
     * check_event_membership
     * 
     * @param integer $user_id
     * @param integer $event_id
     * @return mixed
     */
    public function check_event_membership($user_id, $event_id) {
        global $db;
        if($this->_logged_in) {
            $get_membership = $db->query(sprintf("SELECT is_invited, is_interested, is_going FROM events_members WHERE user_id = %s AND event_id = %s", secure($user_id, 'int'), secure($event_id, 'int') )) or _error(SQL_ERROR_THROWEN);
            if($get_membership->num_rows > 0) {
                return $get_membership->fetch_assoc();
            }
        }
        return false;
    }



    /* ------------------------------- */
    /* Forums */
    /* ------------------------------- */

    /**
     * get_forums
     * 
     * @param integer $node_id
     * @param boolean $reverse
     * @return array
     */
    public function get_forums($node_id = 0, $reverse = false) {
        global $db;
        $tree = array();
        if(!$reverse) {
            // top-down tree (default)
            $get_nodes = $db->query(sprintf("SELECT * FROM forums WHERE forum_section = %s ORDER BY forum_order ASC", secure($node_id, 'int') )) or _error(SQL_ERROR_THROWEN);
            if($get_nodes->num_rows > 0) {
                while($node = $get_nodes->fetch_assoc()) {
                    $node['title_url'] = get_url_text($node['forum_name']);
                    $node['total_threads'] = $node['forum_threads'];
                    $node['total_replies'] = $node['forum_replies'];
                    $childs = $this->get_child_forums($node['forum_id']);
                    if($childs) {
                        $node['total_threads'] += $childs['total_threads'];
                        $node['total_replies'] += $childs['total_replies'];
                        $node['childs'] = $childs['childs'];
                    }
                    $tree[] = $node;
                }
            }
        } else {
            // bottom-up tree
            while(true) {
                $get_parent = $db->query(sprintf("SELECT * FROM forums WHERE forum_id = %s", secure($node_id, 'int') )) or _error(SQL_ERROR_THROWEN);
                if($get_parent->num_rows == 0) {
                    break;
                }
                $parent = $get_parent->fetch_assoc();
                $parent['title_url'] = get_url_text($parent['forum_name']);
                $node_id = $parent['forum_section'];
                $tree[] = $parent;
                if($node_id == 0) {
                    break;
                }
            }
        }
        return $tree;
    }


    /**
     * get_child_forums
     * 
     * @param integer $node_id
     * @param integer $iteration
     * @return array
     */
    public function get_child_forums($node_id, $iteration = 1) {
        global $db;
        $tree = array();
        $get_nodes = $db->query(sprintf("SELECT * FROM forums WHERE forum_section = %s ORDER BY forum_order ASC", secure($node_id) )) or _error(SQL_ERROR_THROWEN);
        if($get_nodes->num_rows > 0) {
            while($node = $get_nodes->fetch_assoc()) {
                $node['iteration'] = $iteration;
                $node['title_url'] = get_url_text($node['forum_name']);
                $node['total_threads'] = $node['forum_threads'];
                $node['total_replies'] = $node['forum_replies'];
                $childs = $this->get_child_forums($node['forum_id'], $iteration+1);
                if($childs) {
                    $node['total_threads'] += $childs['total_threads'];
                    $node['total_replies'] += $childs['total_replies'];
                    $node['childs'] = $childs['childs'];
                }
                $tree['total_threads'] += $node['total_threads'];
                $tree['total_replies'] += $node['total_replies'];
                $tree['childs'][] = $node;
            }
        }
        return $tree;
    }


    /**
     * get_child_forums_ids
     * 
     * @param array $nodes
     * @return void
     */
    public function get_child_forums_ids($nodes, &$list = array()) {
        if(is_array($nodes)) {
            foreach($nodes as $node){
                $list[] = $node['forum_id'];
                if($node['childs']){
                   $this->get_child_forums_ids($node['childs'], $list);
                }
            }
        }
    }


    /**
     * delete_forum
     * 
     * @param integer $node_id
     * @return void
     */
    public function delete_forum($node_id) {
        global $db;
        /* delete forum */
        $db->query(sprintf("DELETE FROM forums WHERE forum_id = %s", secure($node_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        /* delete replies */
        $db->query(sprintf("DELETE FROM forums_replies WHERE thread_id IN (SELECT thread_id FROM forums_threads WHERE forum_id = %s)", secure($node_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        /* delete threads */
        $db->query(sprintf("DELETE FROM forums_threads WHERE forum_id = %s", secure($node_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        /* delete childs */
        $childs = $this->get_child_forums($node_id);
        if($childs) {
            $this->delete_child_forums($childs['childs']);
        }
    }


    /**
     * delete_child_forums
     * 
     * @param array $nodes
     * @return void
     */
    public function delete_child_forums($nodes) {
        global $db;
        if(is_array($nodes)) {
            foreach($nodes as $node){
                /* delete forum */
                $db->query(sprintf("DELETE FROM forums WHERE forum_id = %s", secure($node['forum_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                /* delete replies */
                $db->query(sprintf("DELETE FROM forums_replies WHERE thread_id IN (SELECT thread_id FROM forums_threads WHERE forum_id = %s)", secure($node['forum_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                /* delete threads */
                $db->query(sprintf("DELETE FROM forums_threads WHERE forum_id = %s", secure($node['forum_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                /* delete childs */
                if($node['childs']){
                    $this->delete_child_forums($node['childs']);
                }
            }
        }
    }


    /**
     * get_forum
     * 
     * @param integer $forum_id
     * @param boolean $get_childs
     * @return array
     */
    public function get_forum($forum_id, $get_childs = true) {
        global $db;
        $get_forum = $db->query(sprintf("SELECT * FROM forums WHERE forum_id = %s", secure($forum_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        if($get_forum->num_rows == 0) {
            return false;
        }
        $forum = $get_forum->fetch_assoc();
        $forum['title_url'] = get_url_text($forum['forum_name']);
        $forum['total_threads'] = $forum['forum_threads'];
        $forum['total_replies'] = $forum['forum_replies'];
        if($get_childs) {
            $childs = $this->get_child_forums($forum['forum_id']);
            if($childs) {
                $forum['total_threads'] += $childs['total_threads'];
                $forum['total_replies'] += $childs['total_replies'];
                $forum['childs'] = $childs['childs'];
            }
        }
        $forum['parents'] = $this->get_forums($forum['forum_section'], true);
        return $forum;
    }


    /**
     * get_forum_threads
     * 
     * @param array $args
     * @return array
     */
    public function get_forum_threads($args = []) {
        global $db, $system, $smarty;
        /* initialize vars */
        $threads = array();
        /* initialize arguments */
        $forum = !isset($args['forum']) ? null : $args['forum'];
        $user_id = !isset($args['user_id']) ? null : $args['user_id'];
        $query = !isset($args['query']) ? null : $args['query'];
        /* get threads */
        if($forum !== null) {
            $get_total = $db->query(sprintf("SELECT * FROM forums_threads WHERE forum_id = %s", secure($forum['forum_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
        } elseif ($user_id !== null) {
            $get_total = $db->query(sprintf("SELECT * FROM forums_threads WHERE user_id = %s", secure($user_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        } elseif ($query !== null) {
            /* prepare where statement */
            $where = "";
            /* query */
            $where .= (!is_empty($query))? sprintf(' WHERE title LIKE %1$s OR text LIKE %1$s ', secure($query, 'search') ) : "";
            /* forums list */
            if($args['forums_list']) {
                $forums_list = implode(',',$args['forums_list']);
                $where = ($where != '')? $where." AND forum_id IN ($forums_list) " : $where;
            }
            $get_total = $db->query("SELECT * FROM forums_threads".$where) or _error(SQL_ERROR_THROWEN);
        }
        $total_items = $get_total->num_rows;
        if($total_items > 0) {
            require('class-pager.php');
            $params['selected_page'] = ( (int) $_GET['page'] == 0) ? 1 : $_GET['page'];
            $params['total_items'] = $total_items;
            $params['items_per_page'] = $system['max_results']*2;
            /* prepare pager URL */
            if($forum !== null) {
                $params['url'] = $system['system_url'].'/forums/'.$forum['forum_id'].'/'.$forum['title_url'].'?page=%s';
            } elseif ($user_id !== null) {
                $params['url'] = $system['system_url'].'/forums/my-threads?page=%s';
            } elseif ($query !== null) {
                $params['url'] = remove_querystring_var($_SERVER['REQUEST_URI'], 'page');
                $params['url'] = $params['url'].'&page=%s';
            }
            $pager = new Pager($params);
            $limit_query = $pager->getLimitSql();
            if($forum !== null) {
                $get_threads = $db->query(sprintf("SELECT forums_threads.*, users.user_name, CONCAT(users.user_firstname,' ',users.user_lastname) as user_fullname FROM forums_threads INNER JOIN users ON forums_threads.user_id = users.user_id WHERE forums_threads.forum_id = %s ORDER BY forums_threads.last_reply DESC ".$limit_query, secure($forum['forum_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
            } elseif ($user_id !== null) {
                $get_threads = $db->query(sprintf("SELECT forums_threads.*, users.user_name, CONCAT(users.user_firstname,' ',users.user_lastname) as user_fullname FROM forums_threads INNER JOIN users ON forums_threads.user_id = users.user_id WHERE forums_threads.user_id = %s ORDER BY forums_threads.last_reply DESC ".$limit_query, secure($user_id, 'int') )) or _error(SQL_ERROR_THROWEN);
            } elseif ($query !== null) {
                $get_threads = $db->query("SELECT forums_threads.*, users.user_name, CONCAT(users.user_firstname,' ',users.user_lastname) as user_fullname FROM forums_threads INNER JOIN users ON forums_threads.user_id = users.user_id ".$where." ORDER BY forums_threads.last_reply DESC ".$limit_query) or _error(SQL_ERROR_THROWEN);
            }
            while($thread = $get_threads->fetch_assoc()) {
                $thread['title_url'] = get_url_text($thread['title']);
                /* parse text */
                $thread['parsed_text'] = htmlspecialchars_decode($thread['text'], ENT_QUOTES);
                $thread['text_snippet'] = get_snippet_text($thread['text']);
                /* get forum */
                if(!$forum) {
                    $thread['forum'] = $this->get_forum($thread['forum_id'], false);
                }
                $threads[] = $thread;
            }
            /* assign variables */
            $smarty->assign('total', $params['total_items']);
            $smarty->assign('pager', $pager->getPager());
        }
        return $threads;
    }


    /**
     * get_forum_thread
     * 
     * @param integer $thread_id
     * @param boolean $update_views
     * @return array
     */
    public function get_forum_thread($thread_id, $update_views = false) {
        global $db;
        $get_thread = $db->query(sprintf("SELECT forums_threads.*, users.user_group, users.user_name, users.user_firstname, users.user_lastname, CONCAT(users.user_firstname,' ',users.user_lastname) as user_fullname, users.user_gender, users.user_picture, users.user_registered FROM forums_threads INNER JOIN users ON forums_threads.user_id = users.user_id WHERE thread_id = %s", secure($thread_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        if($get_thread->num_rows == 0) {
            return false;
        }
        $thread = $get_thread->fetch_assoc();
        /* get forum */
        $thread['forum'] = $this->get_forum($thread['forum_id'], false);
        if(!$thread['forum']) {
            return false;
        }
        $thread['user_picture'] = get_picture($thread['user_picture'], $thread['user_gender']);
        $thread['title_url'] = get_url_text($thread['title']);
        /* parse text */
        $thread['parsed_text'] = htmlspecialchars_decode($thread['text'], ENT_QUOTES);
        $thread['text_snippet'] = get_snippet_text($thread['text']);
        /* check if viewer can manage thread [Edit|Delete] */
        $thread['manage_thread'] = false;
        if($this->_logged_in) {
            /* viewer is (admins|moderators)] */
            if($this->_data['user_group'] < 3) {
                $thread['manage_thread'] = true;
            }
            /* viewer is the author of thread */
            if($this->_data['user_id'] == $thread['user_id']) {
                $thread['manage_thread'] = true;
            }
        }
        /* update thread views */
        if($update_views) {
            $db->query(sprintf("UPDATE forums_threads SET views = views + 1 WHERE thread_id = %s", secure($thread['thread_id'], 'int'))) or _error(SQL_ERROR_THROWEN);
        }
        return $thread;
    }


    /**
     * post_forum_thread
     * 
     * @param string $forum_id
     * @param string $title
     * @param string $text
     * @return integer
     */
    public function post_forum_thread($forum_id, $title, $text) {
        global $db, $system, $date;
        /* check if forums enabled */
        if(!$system['forums_enabled']) {
            throw new Exception(__("This feature has been disabled by the admin"));
        }
        /* get forum */
        $forum = $this->get_forum($forum_id, false);
        /* check forum */
        if(!$forum)  {
            _error(403);
        }
        if($forum['forum_section'] == 0)  {
            throw new Exception(__("You can't add a thread to a main section"));
        }
        /* validate title */
        if(is_empty($title)) {
            throw new Exception(__("You must enter a title for your thread"));
        }
        if(strlen($title) < 3) {
            throw new Exception(__("Thread title must be at least 3 characters long. Please try another"));
        }
        /* validate text */
        if(is_empty($text)) {
            throw new Exception(__("You must enter some text for your thread"));
        }
        /* insert thread */
        $db->query(sprintf("INSERT INTO forums_threads (forum_id, user_id, title, text, time, last_reply) VALUES (%s, %s, %s, %s, %s, %s)", secure($forum_id, 'int'), secure($this->_data['user_id'], 'int'), secure($title), secure($text), secure($date), secure($date) )) or _error(SQL_ERROR_THROWEN);
        $thread_id = $db->insert_id;
        /* update forum */
        $db->query(sprintf("UPDATE forums SET forum_threads = forum_threads + 1 WHERE forum_id = %s", secure($forum_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        return $thread_id;
    }


    /**
     * edit_forum_thread
     * 
     * @param string $thread_id
     * @param string $title
     * @param string $text
     * @return void
     */
    public function edit_forum_thread($thread_id, $title, $text) {
        global $db, $system;
        /* check if forums enabled */
        if(!$system['forums_enabled']) {
            throw new Exception(__("This feature has been disabled by the admin"));
        }
        /* get thread */
        $thread = $this->get_forum_thread($thread_id);
        /* check thread */
        if(!$thread)  {
            _error(403);
        }
        /* check permission */
        if(!$thread['manage_thread']) {
            _error(403);
        }
        /* validate title */
        if(is_empty($title)) {
            throw new Exception(__("You must enter a title for your thread"));
        }
        if(strlen($title) < 3) {
            throw new Exception(__("Thread title must be at least 3 characters long. Please try another"));
        }
        /* validate text */
        if(is_empty($text)) {
            throw new Exception(__("You must enter some text for your thread"));
        }
        /* edit thread */
        $db->query(sprintf("UPDATE forums_threads SET title = %s, text = %s WHERE thread_id = %s", secure($title), secure($text), secure($thread_id, 'int') )) or _error(SQL_ERROR_THROWEN);
    }


    /**
     * delete_forum_thread
     * 
     * @param string $thread_id
     * @return array
     */
    public function delete_forum_thread($thread_id) {
        global $db, $system;
        /* check if forums enabled */
        if(!$system['forums_enabled']) {
            throw new Exception(__("This feature has been disabled by the admin"));
        }
        /* get thread */
        $thread = $this->get_forum_thread($thread_id);
        /* check thread */
        if(!$thread)  {
            _error(403);
        }
        /* check permission */
        if(!$thread['manage_thread']) {
            _error(403);
        }
        /* delete thread */
        $db->query(sprintf("DELETE FROM forums_threads WHERE thread_id = %s", secure($thread_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        /* delete replies */
        $db->query(sprintf("DELETE FROM forums_replies WHERE thread_id = %s", secure($thread_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        /* update forum */
        $db->query(sprintf("UPDATE forums SET forum_threads = IF(forum_threads=0,0,forum_threads-1), forum_replies = IF(forum_replies=0,0,forum_replies-%s) WHERE forum_id = %s", secure($thread['replies'], 'int'), secure($thread['forum']['forum_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
        return $thread['forum'];
    }


    /**
     * get_forum_replies
     * 
     * @param array $args
     * @return array
     */
    public function get_forum_replies($args = []) {
        global $db, $system, $smarty;
        /* initialize vars */
        $replies = array();
        /* initialize arguments */
        $thread = !isset($args['thread']) ? null : $args['thread'];
        $user_id = !isset($args['user_id']) ? null : $args['user_id'];
        $query = !isset($args['query']) ? null : $args['query'];
        /* get replies */
        if($thread !== null) {
            $get_total = $db->query(sprintf("SELECT * FROM forums_replies WHERE thread_id = %s", secure($thread['thread_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
        } elseif ($user_id !== null) {
            $get_total = $db->query(sprintf("SELECT * FROM forums_replies WHERE user_id = %s", secure($user_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        } elseif ($query !== null) {
            /* prepare where statement */
            $where = "";
            /* query */
            $where .= (!is_empty($query))? sprintf(' WHERE forums_replies.text LIKE %1$s ', secure($query, 'search') ) : "";
            /* forums list */
            if($args['forums_list']) {
                $forums_list = implode(',',$args['forums_list']);
                $where = ($where != '')? $where." AND forums_threads.forum_id IN ($forums_list) " : $where;
            }
            $get_total = $db->query("SELECT forums_replies.* FROM forums_replies INNER JOIN forums_threads ON forums_replies.thread_id = forums_threads.thread_id".$where) or _error(SQL_ERROR_THROWEN);
        }
        $total_items = $get_total->num_rows;
        if($total_items > 0) {
            require('class-pager.php');
            $params['selected_page'] = ( (int) $_GET['page'] == 0) ? 1 : $_GET['page'];
            $params['total_items'] = $total_items;
            $params['items_per_page'] = $system['max_results']*2;
            /* prepare pager URL */
            if($thread !== null) {
                $params['url'] = $system['system_url'].'/forums/thread/'.$thread['thread_id'].'/'.$thread['title_url'].'?page=%s';
            } elseif ($user_id !== null) {
                $params['url'] = $system['system_url'].'/forums/my-replies?page=%s';
            } elseif ($query !== null) {
                $params['url'] = remove_querystring_var($_SERVER['REQUEST_URI'], 'page');
                $params['url'] = $params['url'].'&page=%s';
            }
            $pager = new Pager($params);
            $limit_query = $pager->getLimitSql();
            if($thread !== null) {
                $get_replies = $db->query(sprintf("SELECT forums_replies.*, users.user_group, users.user_name, CONCAT(users.user_firstname,' ',users.user_lastname) as user_fullname, users.user_gender, users.user_picture, users.user_registered FROM forums_replies INNER JOIN users ON forums_replies.user_id = users.user_id WHERE forums_replies.thread_id = %s ORDER BY forums_replies.reply_id ASC ".$limit_query, secure($thread['thread_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
            } elseif ($user_id !== null) {
                $get_replies = $db->query(sprintf("SELECT forums_replies.*, users.user_group, users.user_name, CONCAT(users.user_firstname,' ',users.user_lastname) as user_fullname, users.user_gender, users.user_picture, users.user_registered FROM forums_replies INNER JOIN users ON forums_replies.user_id = users.user_id WHERE forums_replies.user_id = %s ORDER BY forums_replies.reply_id DESC ".$limit_query, secure($user_id, 'int') )) or _error(SQL_ERROR_THROWEN);
            } elseif ($query !== null) {
                $get_replies = $db->query("SELECT forums_replies.*, users.user_group, users.user_name, CONCAT(users.user_firstname,' ',users.user_lastname) as user_fullname, users.user_gender, users.user_picture, users.user_registered FROM forums_replies INNER JOIN forums_threads ON forums_replies.thread_id = forums_threads.thread_id INNER JOIN users ON forums_replies.user_id = users.user_id ".$where." ORDER BY forums_replies.reply_id DESC ".$limit_query) or _error(SQL_ERROR_THROWEN);
            }
            while($reply = $get_replies->fetch_assoc()) {
                $reply['user_picture'] = get_picture($reply['user_picture'], $reply['user_gender']);
                /* parse text */
                $reply['parsed_text'] = htmlspecialchars_decode($reply['text'], ENT_QUOTES);
                $reply['text_snippet'] = get_snippet_text($reply['text']);
                /* check if viewer can manage reply [Edit|Delete] */
                $reply['manage_reply'] = false;
                if($this->_logged_in) {
                    /* viewer is (admins|moderators)] */
                    if($this->_data['user_group'] < 3) {
                        $reply['manage_reply'] = true;
                    }
                    /* viewer is the author of reply */
                    if($this->_data['user_id'] == $reply['user_id']) {
                        $reply['manage_reply'] = true;
                    }
                }
                /* get thread */
                if(!$thread) {
                    $reply['thread'] = $this->get_forum_thread($reply['thread_id']);
                }
                $replies[] = $reply;
            }
            /* assign variables */
            $smarty->assign('selected_page', $params['selected_page']);
            $smarty->assign('total', $params['total_items']);
            $smarty->assign('pager', $pager->getPager());
        }
        return $replies;
    }


    /**
     * get_forum_reply
     * 
     * @param integer $reply_id
     * @return array
     */
    public function get_forum_reply($reply_id) {
        global $db;
        $get_reply = $db->query(sprintf("SELECT * FROM forums_replies WHERE reply_id = %s", secure($reply_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        if($get_reply->num_rows == 0) {
            return false;
        }
        $reply = $get_reply->fetch_assoc();
        /* get thread */
        $reply['thread'] = $this->get_forum_thread($reply['thread_id']);
        if(!$reply['thread']) {
            return false;
        }
        /* check if viewer can manage reply [Edit|Delete] */
        $reply['manage_reply'] = false;
        if($this->_logged_in) {
            /* viewer is (admins|moderators)] */
            if($this->_data['user_group'] < 3) {
                $reply['manage_reply'] = true;
            }
            /* viewer is the author of reply */
            if($this->_data['user_id'] == $reply['user_id']) {
                $reply['manage_reply'] = true;
            }
        }
        return $reply;
    }


    /**
     * post_forum_reply
     * 
     * @param string $thread_id
     * @param string $text
     * @return array
     */
    public function post_forum_reply($thread_id, $text) {
        global $db, $system, $date;
        /* check if forums enabled */
        if(!$system['forums_enabled']) {
            throw new Exception(__("This feature has been disabled by the admin"));
        }
        /* get thread */
        $thread = $this->get_forum_thread($thread_id);
        /* check forum */
        if(!$thread)  {
            _error(403);
        }
        /* validate text */
        if(is_empty($text)) {
            throw new Exception(__("You must enter some text for your reply"));
        }
        /* insert reply */
        $db->query(sprintf("INSERT INTO forums_replies (thread_id, user_id, text, time) VALUES (%s, %s, %s, %s)", secure($thread_id, 'int'), secure($this->_data['user_id'], 'int'), secure($text), secure($date) )) or _error(SQL_ERROR_THROWEN);
        $reply_id = $db->insert_id;
        /* update thread */
        $db->query(sprintf("UPDATE forums_threads SET last_reply = %s, replies = replies + 1 WHERE thread_id = %s", secure($date), secure($thread_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        /* update forum */
        $db->query(sprintf("UPDATE forums SET forum_replies = forum_replies + 1 WHERE forum_id = %s", secure($thread['forum']['forum_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
        /* post notification */
        $this->post_notification( array('to_user_id'=>$thread['user_id'], 'action'=>'forum_reply', 'node_url'=>$thread['thread_id'].'/'.$thread['title_url'].'/#reply-'.$reply_id) );
        return array('reply_id' => $reply_id, 'thread' => $thread);
    }


    /**
     * edit_forum_reply
     * 
     * @param string $reply_id
     * @param string $text
     * @return array
     */
    public function edit_forum_reply($reply_id, $text) {
        global $db, $system;
        /* check if forums enabled */
        if(!$system['forums_enabled']) {
            throw new Exception(__("This feature has been disabled by the admin"));
        }
        /* get reply */
        $reply = $this->get_forum_reply($reply_id);
        /* check reply */
        if(!$reply)  {
            _error(403);
        }
        /* check permission */
        if(!$reply['manage_reply']) {
            _error(403);
        }
        /* validate text */
        if(is_empty($text)) {
            throw new Exception(__("You must enter some text for your thread"));
        }
        /* edit reply */
        $db->query(sprintf("UPDATE forums_replies SET text = %s WHERE reply_id = %s", secure($text), secure($reply_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        return array('reply_id' => $reply_id, 'thread' => $reply['thread']);
    }


    /**
     * delete_forum_reply
     * 
     * @param string $reply_id
     * @return void
     */
    public function delete_forum_reply($reply_id) {
        global $db, $system;
        /* check if forums enabled */
        if(!$system['forums_enabled']) {
            throw new Exception(__("This feature has been disabled by the admin"));
        }
        /* get reply */
        $reply = $this->get_forum_reply($reply_id);
        /* check reply */
        if(!$reply)  {
            _error(403);
        }
        /* check permission */
        if(!$reply['manage_reply']) {
            _error(403);
        }
        /* delete reply */
        $db->query(sprintf("DELETE FROM  forums_replies WHERE reply_id = %s", secure($reply_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        /* update thread */
        $db->query(sprintf("UPDATE forums_threads SET replies = IF(replies=0,0,replies-1) WHERE thread_id = %s", secure($reply['thread_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
        /* update forum */
        $db->query(sprintf("UPDATE forums SET forum_replies = IF(forum_replies=0,0,forum_replies-1) WHERE forum_id = %s", secure($reply['thread']['forum']['forum_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
        /* delete notification */
        $this->delete_notification($reply['thread']['user_id'], 'forum_reply', '', $reply['thread']['thread_id'].'/'.$reply['thread']['title_url'].'/#reply-'.$reply_id);
    }


    /**
     * search_forums
     * 
     * @param string $query
     * @param string $type
     * @param mixed $forum
     * @param boolean $recursive
     * @return array
     */
    public function search_forums($query, $type, $forum, $recursive) {
        global $db, $system;
        /* init vars */
        $results = array();
        $params = array();
        /* check recursive */
        $recursive = (isset($recursive)) ? true : false;
        /* check forum */
        if($forum == "all") {
            $params['forums_list'] = false;
        } else {
            $forum = $this->get_forum($forum);
            if(!$forum) {
                return $results;
            }
            $params['forums_list'][] = $forum['forum_id'];
            if($recursive) {
                $this->get_child_forums_ids($forum['childs'], $params['forums_list']);
            }
        }
        /* include query */
        $params['query'] = $query;
        /* validate type */
        switch ($type) {
            case 'threads':
                $results = $this->get_forum_threads($params);
                break;

            case 'replies':
                $results = $this->get_forum_replies($params);
                break;
        }
        return $results;
    }


    /**
     * get_forum_online_users
     * 
     * @return array
     */
    public function get_forum_online_users() {
        global $db, $system;
        $users = array();
        $get_users = $db->query(sprintf("SELECT * FROM users WHERE user_last_seen >= SUBTIME(NOW(), SEC_TO_TIME(%s)) AND user_chat_enabled = '1'", secure($system['offline_time'], 'int', false) )) or _error(SQL_ERROR_THROWEN);
        if($get_users->num_rows > 0) {
            while($user = $get_users->fetch_assoc()) {
                $user['user_picture'] = get_picture($user['user_picture'], $user['user_gender']);
                $users[] = $user;
            }
        }
        return $users;
    }



    /* ------------------------------- */
    /* Reports */
    /* ------------------------------- */

    /**
     * report
     * 
     * @param integer $id
     * @param string $handle
     * @return void
     */
    public function report($id, $handle) {
        global $db, $date;
        switch ($handle) {
            case 'user':
                /* check the user */
                $check = $db->query(sprintf("SELECT * FROM users WHERE user_id = %s", secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                break;

            case 'page':
                /* check the page */
                $check = $db->query(sprintf("SELECT * FROM pages WHERE page_id = %s", secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                break;

            case 'group':
                /* check the group */
                $check = $db->query(sprintf("SELECT * FROM groups WHERE group_id = %s", secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                break;

            case 'event':
                /* check the event */
                $check = $db->query(sprintf("SELECT * FROM events WHERE event_id = %s", secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                break;
            
            case 'post':
                /* check the post */
                $check = $db->query(sprintf("SELECT * FROM posts WHERE post_id = %s", secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                break;

            case 'comment':
                /* check the comment */
                $check = $db->query(sprintf("SELECT * FROM posts_comments WHERE comment_id = %s", secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                break;

            case 'forum_thread':
                /* check the forum thread */
                $check = $db->query(sprintf("SELECT * FROM forums_threads WHERE thread_id = %s", secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                break;

            case 'forum_reply':
                /* check the forum thread */
                $check = $db->query(sprintf("SELECT * FROM forums_replies WHERE reply_id = %s", secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
                break;

            default:
                _error(403);
                break;
        }
        /* check node */
        if($check->num_rows == 0) {
            _error(403);
        }
        /* check old reports */
        $check = $db->query(sprintf("SELECT * FROM reports WHERE user_id = %s AND node_id = %s AND node_type = %s", secure($this->_data['user_id'], 'int'), secure($id, 'int'), secure($handle) )) or _error(SQL_ERROR_THROWEN);
        if($check->num_rows > 0) {
            throw new Exception(__("You have already reported this before!"));
        }
        /* report */
        $db->query(sprintf("INSERT INTO reports (user_id, node_id, node_type, time) VALUES (%s, %s, %s, %s)", secure($this->_data['user_id'], 'int'), secure($id, 'int'), secure($handle), secure($date) )) or _error(SQL_ERROR_THROWEN);
    }



    /* ------------------------------- */
    /* Movies */
    /* ------------------------------- */

    /**
     * get_movies_genres
     * 
     * @return array
     */
    public function get_movies_genres() {
        global $db;
        $genres = array();
        $get_genres = $db->query("SELECT * FROM movies_genres") or _error(SQL_ERROR_THROWEN);
        if($get_genres->num_rows > 0) {
            while($genre = $get_genres->fetch_assoc()) {
                $genre['genre_url'] = get_url_text($genre['genre_name']);
                $genres[] = $genre;
            }
        }
        return $genres;
    }

    /**
     * get_movies_genre
     * 
     * @param integer $genre_id
     * @return array
     */
    public function get_movies_genre($genre_id) {
        global $db;
        $get_genre = $db->query(sprintf('SELECT * FROM movies_genres WHERE genre_id = %s', secure($genre_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        if($get_genre->num_rows == 0) {
            return false;
        }
        $genre = $get_genre->fetch_assoc();
        $genre['genre_url'] = get_url_text($genre['genre_name']);
        return $genre;
    }


    /**
     * get_movie_genres
     * 
     * @param string $movie_genres
     * @return array
     */
    public function get_movie_genres($movie_genres) {
        global $db;
        $genres = array();
        if($movie_genres) {
            $get_genres = $db->query("SELECT * FROM movies_genres WHERE genre_id IN (".$movie_genres.")") or _error(SQL_ERROR_THROWEN);
            if($get_genres->num_rows > 0) {
                while($genre = $get_genres->fetch_assoc()) {
                    $genre['genre_url'] = get_url_text($genre['genre_name']);
                    $genres[] = $genre;
                }
            }
        }
        return $genres;
    }


    /**
     * get_movie
     * 
     * @param integer $movie_id
     * @return array
     */
    public function get_movie($movie_id) {
        global $db;
        $get_movie = $db->query(sprintf('SELECT * FROM movies WHERE movie_id = %s', secure($movie_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        if($get_movie->num_rows == 0) {
            return false;
        }
        $movie = $get_movie->fetch_assoc();
        $movie['poster'] = get_picture($movie['poster'], 'movie');
        $movie['movie_url'] = get_url_text($movie['title']);
        $movie['genres_list'] = $this->get_movie_genres($movie['genres']);
        /* update thread views */
        $db->query(sprintf("UPDATE movies SET views = views + 1 WHERE movie_id = %s", secure($movie_id, 'int'))) or _error(SQL_ERROR_THROWEN);
        return $movie;
    }



    /* ------------------------------- */
    /* Games */
    /* ------------------------------- */

    /**
     * get_games
     * 
     * @param integer $offset
     * @param boolean $played
     * @return array
     */
    public function get_games($offset = 0, $played = false) {
        global $db, $system;
        $games = array();
        $offset *= $system['max_results_even'];
        if($played) {
            $get_games = $db->query(sprintf('SELECT games.*, games_players.last_played_time FROM games INNER JOIN games_players ON games.game_id = games_players.game_id WHERE games_players.user_id = %s ORDER BY games_players.last_played_time DESC LIMIT %s, %s', secure($this->_data['user_id'], 'int'), secure($offset, 'int', false), secure($system['max_results_even'], 'int', false) )) or _error(SQL_ERROR_THROWEN);
        } else {
            $get_games = $db->query(sprintf('SELECT * FROM games LIMIT %s, %s', secure($offset, 'int', false), secure($system['max_results_even'], 'int', false) )) or _error(SQL_ERROR_THROWEN);
        }
        if($get_games->num_rows > 0) {
            while($game = $get_games->fetch_assoc()) {
                $game['thumbnail'] = get_picture($game['thumbnail'], 'game');
                $game['title_url'] = get_url_text($game['title']);
                $game['played'] = ($played)? $game['last_played_time']: false;
                
                $games[] = $game;
            }
        }
        return $games;
    }


    /**
     * get_game
     * 
     * @param integer $game_id
     * @return array
     */
    public function get_game($game_id) {
        global $db, $date;
        $get_game = $db->query(sprintf('SELECT * FROM games WHERE game_id = %s', secure($game_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        if($get_game->num_rows == 0) {
            return false;
        }
        $game = $get_game->fetch_assoc();
        $game['thumbnail'] = get_picture($game['thumbnail'], 'game');
        /* check if the viewer played this game before */
        if($this->_logged_in) {
            $db->query(sprintf("DELETE FROM games_players WHERE game_id = %s AND user_id = %s", secure($game['game_id'], 'int'), secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
            $db->query(sprintf("INSERT INTO games_players (game_id, user_id, last_played_time) VALUES (%s, %s, %s)", secure($game['game_id'], 'int'), secure($this->_data['user_id'], 'int'), secure($date) ));
        }
        return $game;
    }



    /* ------------------------------- */
    /* Market */
    /* ------------------------------- */

    /**
     * get_market_categories_ids
     * 
     * @return array
     */
    public function get_market_categories_ids() {
        global $db;
        $categories = array();
        $get_categories = $db->query("SELECT category_id FROM market_categories") or _error(SQL_ERROR_THROWEN);
        if($get_categories->num_rows > 0) {
            while($category = $get_categories->fetch_assoc()) {
                $categories[] = $category['category_id'];
            }
        }
        return $categories;
    }


    /**
     * get_market_categories
     * 
     * @return array
     */
    public function get_market_categories() {
        global $db;
        $categories = array();
        $get_categories = $db->query("SELECT * FROM market_categories") or _error(SQL_ERROR_THROWEN);
        if($get_categories->num_rows > 0) {
            while($category = $get_categories->fetch_assoc()) {
                $category['category_url'] = get_url_text($category['category_name']);
                $categories[] = $category;
            }
        }
        return $categories;
    }



    /* ------------------------------- */
    /* Pro Packages */
    /* ------------------------------- */

    /**
     * get_packages
     * 
     * @return array
     */
    public function get_packages() {
        global $db;
        $packages = array();
        $get_packages = $db->query("SELECT * FROM packages") or _error(SQL_ERROR_THROWEN);
        if($get_packages->num_rows > 0) {
            while($package = $get_packages->fetch_assoc()) {
                $package['icon'] = get_picture($package['icon'], 'package');
                $packages[] = $package;
            }
        }
        return $packages;
    }


    /**
     * get_package
     * 
     * @param integer $package_id
     * @return array|false
     */
    public function get_package($package_id) {
        global $db;
        $get_package = $db->query(sprintf('SELECT * FROM packages WHERE package_id = %s', secure($package_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        if($get_package->num_rows == 0) {
            return false;
        }
        $package = $get_package->fetch_assoc();
        return $package;
    }


    /**
     * check_user_package
     * 
     * @return void
     */
    public function check_user_package() {
        global $db;
        if($this->_data['user_subscribed']) {
            /* get package */
            $package = $this->get_package($this->_data['user_package']);
            if($package) {
                switch ($package['period']) {
                    case 'day':
                        $duration = 86400;
                        break;

                    case 'week':
                        $duration = 604800;
                        break;

                    case 'month':
                        $duration = 2629743;
                        break;

                    case 'year':
                        $duration = 31556926;
                        break;

                    case 'life':
                        return;
                        break;
                }
                $time_left = time() - ($package['period_num'] * $duration);
                if(strtotime($this->_data['user_subscription_date']) > $time_left) {
                    return;
                }
            }
            /* remove user package */
            $db->query(sprintf("UPDATE users SET user_subscribed = '0', user_package = null, user_subscription_date = null, user_boosted_posts = '0', user_boosted_pages = '0' WHERE user_id = %s", secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
            /* unboost posts */
            $db->query(sprintf("UPDATE posts SET boosted = '0' WHERE user_id = %s AND user_type = 'user'", secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
            /* unboost pages */
            $db->query(sprintf("UPDATE pages SET page_boosted = '0' WHERE page_admin = %s", secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
        }
    }


    /**
     * check_users_package
     * 
     * @return void
     */
    public function check_users_package() {
        global $db;
        $get_subscribed_users = $db->query("SELECT * FROM users WHERE user_subscribed = '1'") or _error(SQL_ERROR_THROWEN);
        if($get_subscribed_users->num_rows == 0) {
            return;
        }
        while($subscribed_user = $get_subscribed_users->fetch_assoc()) {
            /* get package */
            $package = $this->get_package($subscribed_user['user_package']);
            if($package) {
                switch ($package['period']) {
                    case 'day':
                        $duration = 86400;
                        break;

                    case 'week':
                        $duration = 604800;
                        break;

                    case 'month':
                        $duration = 2629743;
                        break;

                    case 'year':
                        $duration = 31556926;
                        break;

                    case 'life':
                        continue;
                        break;
                }
                $time_left = time() - ($package['period_num'] * $duration);
                if(strtotime($subscribed_user['user_subscription_date']) > $time_left) {
                    continue;
                }
            }
            /* remove user package */
            $db->query(sprintf("UPDATE users SET user_subscribed = '0', user_package = null, user_subscription_date = null, user_boosted_posts = '0', user_boosted_pages = '0' WHERE user_id = %s", secure($subscribed_user['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
            /* unboost posts */
            $db->query(sprintf("UPDATE posts SET boosted = '0' WHERE user_id = %s AND user_type = 'user'", secure($subscribed_user['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
            /* unboost pages */
            $db->query(sprintf("UPDATE pages SET page_boosted = '0' WHERE page_admin = %s", secure($subscribed_user['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
        }
    }


    /**
     * update_user_package
     * 
     * @param integer $package_id
     * @param string $package_name
     * @param string $package_price
     * @return void
     */
    public function update_user_package($package_id, $package_name, $package_price) {
        global $db, $date;
        /* update user package */
        $db->query(sprintf("UPDATE users SET user_verified = '1', user_subscribed = '1', user_package = %s, user_subscription_date = %s, user_boosted_posts = '0', user_boosted_pages = '0' WHERE user_id = %s", secure($package_id, 'int'), secure($date), secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
        /* insert the payment */
        $db->query(sprintf("INSERT INTO packages_payments (payment_date, package_name, package_price) VALUES (%s, %s, %s)", secure($date), secure($package_name), secure($package_price) )) or _error(SQL_ERROR_THROWEN);
        /* affiliates system */
        $this->process_affiliates("packages", $this->_data['user_id'], $this->_data['user_referrer_id']);
    }



    /* ------------------------------- */
    /* Affiliates */
    /* ------------------------------- */

    /**
     * init_affiliates
     * 
     * @return void
     */
    public function init_affiliates() {
        if(!$this->_logged_in && isset($_GET['ref'])) {
            $expire = time()+2592000;
            setcookie($this->_cookie_user_referrer, $_GET['ref'], $expire, '/');
        }
    }


    /**
     * affiliates_balance
     * 
     * @param string $type
     * @param integer $referee_id
     * @param integer $referrer_id
     * @return void
     */
    private function process_affiliates($type, $referee_id, $referrer_id = null) {
        global $db, $system;
        if(!$system['affiliates_enabled'] || $system['affiliate_type'] != $type || !isset($_COOKIE[$this->_cookie_user_referrer])) {
            return;
        }
        $get_referrer = $db->query(sprintf("SELECT user_id, user_name, user_affiliate_balance FROM users WHERE user_name = %s", secure($_COOKIE[$this->_cookie_user_referrer]) )) or _error(SQL_ERROR_THROWEN);
        if($get_referrer->num_rows == 0) {
            return;
        }
        $referrer = $get_referrer->fetch_assoc();
        if($referrer['user_id'] == $referee_id || $referrer['user_id'] == $referrer_id) {
            return;
        }
        /* update referrer */
        $balance = $referrer['user_affiliate_balance'] + $system['affiliates_per_user'];
        $db->query(sprintf("UPDATE users SET user_affiliate_balance = %s WHERE user_id = %s", secure($balance), secure($referrer['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
        /* update referee */
        $db->query(sprintf("UPDATE users SET user_referrer_id = %s WHERE user_id = %s", secure($referrer['user_id'], 'int'), secure($referee_id, 'int') )) or _error(SQL_ERROR_THROWEN);
    }


    /**
     * get_affiliates
     * 
     * @param integer $user_id
     * @param integer $offset
     * @return array
     */
    public function get_affiliates($user_id, $offset = 0) {
        global $db, $system;
        $affiliates = array();
        $offset *= $system['max_results'];
        $get_affiliates = $db->query(sprintf('SELECT user_id, user_name, user_firstname, user_lastname, user_gender, user_picture FROM users WHERE user_referrer_id = %s LIMIT %s, %s', secure($user_id, 'int'), secure($offset, 'int', false), secure($system['max_results'], 'int', false) )) or _error(SQL_ERROR_THROWEN);
        if($get_affiliates->num_rows > 0) {
            while($affiliate = $get_affiliates->fetch_assoc()) {
                $affiliate['user_picture'] = get_picture($affiliate['user_picture'], $affiliate['user_gender']);
                /* get the connection between the viewer & the target */
                $affiliate['connection'] = $this->connection($affiliate['user_id'], false);
                $affiliates[] = $affiliate;
            }
        }
        return $affiliates;
    }



    /* ------------------------------- */
    /* Custom Fields */
    /* ------------------------------- */

    /**
     * get_custom_fields
     * 
     * @param array $args
     * @return array
     */
    public function get_custom_fields($args = []) {
        global $db, $system;
        $fields = array();
        /* prepare "for" [user|page|group|event] - default -> user */
        $args['for'] = (isset($args['for']))? $args['for']: "user";
        if(!in_array($args['for'], array('user', 'page', 'group', 'event'))) {
            _error(400);
        }
        /* prepare "get" [registration|profile|settings] - default -> registration */
        $args['get'] = (isset($args['get']))? $args['get']: "registration";
        if(!in_array($args['get'], array('registration', 'profile', 'settings'))) {
            _error(400);
        }
        /* prepare where_query */
        $where_query = "WHERE field_for = '".$args['for']."'";
        if($args['get'] == "registration") {
            $where_query .= " AND in_registration = '1'";
        } elseif ($args['get'] == "profile") {
            $where_query .= " AND in_profile = '1'";
        }
        $get_fields = $db->query("SELECT * FROM custom_fields ".$where_query." ORDER BY field_order ASC") or _error(SQL_ERROR_THROWEN);
        if($get_fields->num_rows > 0) {
            while($field = $get_fields->fetch_assoc()) {
                if($field['type'] == "selectbox") {
                    $field['options'] = explode(PHP_EOL, $field['select_options']);
                }
                if($args['get'] == "registration") {
                    /* no value neeeded */
                    $fields[] = $field;
                } else {
                    /* valid node_id */
                    if(!isset($args['node_id'])) {
                        _error(400);
                    }
                    /* get the custom field value */
                    $get_field_value = $db->query(sprintf("SELECT value FROM custom_fields_values WHERE field_id = %s AND node_id = %s AND node_type = %s", secure($field['field_id'], 'int'), secure($args['node_id'], 'int'), secure($args['for']) )) or _error(SQL_ERROR_THROWEN);
                    $field_value = $get_field_value->fetch_assoc();
                    if($field['type'] == "selectbox") {
                        $field['value'] = $field['options'][$field_value['value']];
                    } else {
                        $field['value'] = $field_value['value'];
                    }
                    if($args['get'] == "profile" && is_empty($field['value'])) {
                        continue;
                    }
                    $fields[$field['place']][] = $field;
                }
            }
        }
        return $fields;
    }


    /**
     * set_custom_fields
     * 
     * @param array $input_fields
     * @param string $for
     * @param string $set
     * @param integer $node_id
     * @return array
     */
    public function set_custom_fields($input_fields, $for = "user", $set = "registration", $node_id = null) {
        global $db, $system;
        $custom_fields = array();
        /* prepare "for" [user|page|group|event] - default -> user */
        if(!in_array($for, array('user', 'page', 'group', 'event'))) {
            _error(400);
        }
        /* prepare "set" [registration|settings] - default -> registration */
        if(!in_array($set, array('registration', 'settings'))) {
            _error(400);
        }
        /* prepare where_query */
        $where_query = " AND field_for = '".$for."'";
        if($set == "registration") {
            $where_query .= " AND in_registration = '1'";
        }
        /* get & set input_fields */
        $prefix = "fld_";
        $prefix_len = strlen($prefix);
        foreach($input_fields as $key => $value) {
            if(strpos($key, $prefix) === false) {
                continue;
            }
            $field_id = substr($key, $prefix_len);
            $get_field = $db->query(sprintf("SELECT * FROM custom_fields WHERE field_id = %s".$where_query, secure($field_id, 'int') )) or _error(SQL_ERROR_THROWEN);
            if($get_field->num_rows == 0) {
                continue;
            }
            $field = $get_field->fetch_assoc();
            /* valid field */
            if($field['mandatory']) {
                if($field['type'] != "selectbox" && is_empty($value)) {
                    throw new Exception(__("You must enter")." ".$field['label']);
                }
                if($field['type'] == "selectbox" && $value == "none") {
                    throw new Exception(__("You must select")." ".$field['label']);
                }
            }
            if(strlen($value) > $field['length']) {
                throw new Exception(__("The maximum value for")." ".$field['label']." ".__("is")." ".$field['length']);
            }
            /* (insert|update) node custom fields */
            if($set == "registration") {
                /* insert query */
                $custom_fields[$field['field_id']] = $value;
            } else {
                /* valid node_id */
                if($node_id == null) {
                    _error(400);
                }
                $insert_field = $db->query(sprintf("INSERT INTO custom_fields_values (value, field_id, node_id, node_type) VALUES (%s, %s, %s, %s)", secure($value), secure($field['field_id'], 'int'), secure($node_id, 'int'), secure($for) ));
                if(!$insert_field) {
                    /* update if already exist */
                    $db->query(sprintf("UPDATE custom_fields_values SET value = %s WHERE field_id = %s AND node_id = %s AND node_type = %s", secure($value), secure($field['field_id'], 'int'), secure($node_id, 'int'), secure($for) )) or _error(SQL_ERROR_THROWEN);
                }
            }
        }
        if($set == "registration") {
            return $custom_fields;
        }
        return;
    }



    /* ------------------------------- */
    /* Announcements */
    /* ------------------------------- */

    /**
     * announcements
     * 
     * @param array $place
     * @return array
     */
    public function announcements() {
        global $db, $date;
        $announcements = array();
        $get_announcement = $db->query(sprintf('SELECT * FROM announcements WHERE start_date <= %1$s AND end_date >= %1$s', secure($date))) or _error(SQL_ERROR_THROWEN);
        if($get_announcement->num_rows > 0) {
            while($announcement = $get_announcement->fetch_assoc()) {
                $check = $db->query(sprintf("SELECT * FROM announcements_users WHERE announcement_id = %s AND user_id = %s", secure($announcement['announcement_id'], 'int'), secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                if($check->num_rows == 0) {
                    $announcement['code'] = html_entity_decode($announcement['code'], ENT_QUOTES);
                    $announcements[] = $announcement;
                }
            }
        }
        return $announcements;
    }


    /**
     * hide_announcement
     * 
     * @param integer $id
     * @return void
     */
    public function hide_announcement($id) {
        global $db, $system;
        /* check announcement */
        $check = $db->query(sprintf("SELECT * FROM announcements WHERE announcement_id = %s", secure($id, 'int') )) or _error(SQL_ERROR_THROWEN);
        if($check->num_rows == 0) {
            _error(403);
        }
        /* hide announcement */
        $db->query(sprintf("INSERT INTO announcements_users (announcement_id, user_id) VALUES (%s, %s)", secure($id, 'int'), secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
    }



    /* ------------------------------- */
    /* Ads */
    /* ------------------------------- */

    /**
     * ads
     * 
     * @param string $place
     * @return array
     */
    public function ads($place) {
        global $db;
        $ads = array();
        $get_ads = $db->query(sprintf("SELECT * FROM ads_system WHERE place = %s", secure($place) )) or _error(SQL_ERROR_THROWEN);
        if($get_ads->num_rows > 0) {
            while($ads_unit = $get_ads->fetch_assoc()) {
                $ads_unit['code'] = html_entity_decode($ads_unit['code'], ENT_QUOTES);
                $ads[] = $ads_unit;
            }
        }
        return $ads;
    }


    /**
     * ads_campaigns
     * 
     * @param string $place
     * @return array
     */
    public function ads_campaigns($place = 'sidebar') {
        global $db, $system, $date;
        $campaigns = array();
        /* check if ads enabled */
        if(!$system['ads_enabled']) {
            return $campaigns;
        }
        /* get active campaigns */
        $get_campaigns = $db->query(sprintf("SELECT ads_campaigns.*, pages.page_name, groups.group_name, users.user_wallet_balance FROM ads_campaigns INNER JOIN users ON ads_campaigns.campaign_user_id = users.user_id LEFT JOIN pages ON ads_campaigns.ads_type = 'page' AND ads_campaigns.ads_page = pages.page_id LEFT JOIN groups ON ads_campaigns.ads_type = 'group' AND ads_campaigns.ads_group = groups.group_id WHERE ads_campaigns.campaign_is_active = '1' AND ads_campaigns.ads_placement = %s ORDER BY RAND()", secure($place) )) or _error(SQL_ERROR_THROWEN);
        if($get_campaigns->num_rows > 0) {
            while($campaign = $get_campaigns->fetch_assoc()) {
                // check if viewer get 1 valid campaign
                if(count($campaigns) >= 1) {
                    break;
                }

                // update campaign
                /* [1] -> campaign expired */
                if(strtotime($campaign['campaign_end_date']) <= strtotime($date)) {
                    $db->query(sprintf("UPDATE ads_campaigns SET campaign_is_active = '0' WHERE campaign_id = %s", secure($campaign['campaign_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                    continue;
                }
                $remaining = $campaign['campaign_budget'] - $campaign['campaign_spend']; // campaign remaining (budget - spend)
                /* [2] -> campaign remaining = 0 (spend == budget) */
                if($remaining == 0) {
                    $db->query(sprintf("UPDATE ads_campaigns SET campaign_is_active = '0' WHERE campaign_id = %s", secure($campaign['campaign_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                    continue;
                }
                /* [3] -> campaign remaining > campaign's author wallet credit */
                if($remaining > $campaign['user_wallet_balance']) {
                    $db->query(sprintf("UPDATE ads_campaigns SET campaign_is_active = '0' WHERE campaign_id = %s", secure($campaign['campaign_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                    continue;
                }
                /* [4] -> campaign remaining < cost per click */
                if($remaining < $system['ads_cost_click'] && $campaign['campaign_bidding'] == "click") {
                    $db->query(sprintf("UPDATE ads_campaigns SET campaign_is_active = '0' WHERE campaign_id = %s", secure($campaign['campaign_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                    continue;
                }
                /* [5] -> campaign remaining < cost per view */
                if($remaining < $system['ads_cost_view'] && $campaign['campaign_bidding'] == "view") {
                    $db->query(sprintf("UPDATE ads_campaigns SET campaign_is_active = '0' WHERE campaign_id = %s", secure($campaign['campaign_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                    continue;
                }

                // check if "viewer" is campaign target audience
                /* if viewer is campaign author */
                if($this->_data['user_id'] == $campaign['campaign_user_id']) {
                    continue;
                }
                /* check viewer country */
                $campaign['audience_countries'] = ($campaign['audience_countries'])? explode(',', $campaign['audience_countries']) : array();
                if($campaign['audience_countries'] && !in_array($this->_data['user_country'], $campaign['audience_countries'])) {
                    continue;
                }
                /* check viewer gender */
                if($campaign['audience_gender'] != "all" && $this->_data['user_gender'] != $campaign['audience_gender']) {
                    continue;
                }
                /* check viewer relationship */
                if($campaign['audience_relationship'] != "all" && $this->_data['user_relationship'] != $campaign['audience_relationship']) {
                    continue;
                }

                // prepare ads URL
                switch ($campaign['ads_type']) {
                    case 'page':
                        $campaign['ads_url'] = $system['system_url'].'/pages/'.$campaign['page_name'];
                        break;

                    case 'group':
                        $campaign['ads_url'] = $system['system_url'].'/groups/'.$campaign['group_name'];
                        break;

                    case 'event':
                        $campaign['ads_url'] = $system['system_url'].'/events/'.$campaign['ads_event'];
                        break;
                }

                // update campaign if bidding = view
                if($campaign['campaign_bidding'] == "view") {
                    /* update campaign spend & views */
                    $db->query(sprintf("UPDATE ads_campaigns SET campaign_views = campaign_views + 1, campaign_spend = campaign_spend + %s WHERE campaign_id = %s", secure($system['ads_cost_view']), secure($campaign['campaign_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                    /* decrease campaign author wallet balance */
                    $db->query(sprintf('UPDATE users SET user_wallet_balance = IF(user_wallet_balance-%1$s<=0,0,user_wallet_balance-%1$s) WHERE user_id = %2$s', secure($system['ads_cost_view']), secure($campaign['campaign_user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                }

                // get campaigns
                $campaigns[] = $campaign;
            }
        }
        return $campaigns;
    }


    /**
     * get_campaigns
     * 
     * @return array
     */
    public function get_campaigns() {
        global $db;
        $campaigns = array();
        $get_campaigns = $db->query(sprintf("SELECT * FROM ads_campaigns WHERE campaign_user_id = %s ORDER BY campaign_id DESC", secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
        if($get_campaigns->num_rows > 0) {
            while($campaign = $get_campaigns->fetch_assoc()) {
                $campaigns[] = $campaign;
            }
        }
        return $campaigns;
    }


    /**
     * get_campaign
     * 
     * @param integer $campaign_id
     * @return array
     */
    public function get_campaign($campaign_id) {
        global $db;
        $get_campaign = $db->query(sprintf("SELECT * FROM ads_campaigns WHERE campaign_id = %s", secure($campaign_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        if($get_campaign->num_rows == 0) {
            return false;
        }
        $campaign = $get_campaign->fetch_assoc();
        /* get audience countries array */
        $campaign['audience_countries'] = ($campaign['audience_countries'])? explode(',', $campaign['audience_countries']) : array();
        /* get campaign potential reach */
        $campaign['campaign_potential_reach'] = $this->campaign_potential_reach($campaign['audience_countries'], $campaign['audience_gender'], $campaign['audience_relationship']);
        return $campaign;
    }


    /**
     * create_campaign
     * 
     * @param array $args
     * @return void
     */
    public function create_campaign($args = []) {
        global $db, $system, $date;
        /* check if ads enabled */
        if(!$system['ads_enabled']) {
            throw new Exception(__("This feature has been disabled by the admin"));
        }
        /* validate campaign title */
        if(is_empty($args['campaign_title'])) {
            throw new Exception(__("You have to enter the campaign title"));
        }
        /* validate campaign start & end dates (UTC) */
        if(is_empty($args['campaign_start_date'])) {
            throw new Exception(__("You have to enter the campaign start date"));
        }
        if(is_empty($args['campaign_end_date'])) {
            throw new Exception(__("You have to enter the campaign end date"));
        }
        if(strtotime($args['campaign_start_date']) >= strtotime($args['campaign_end_date'])) {
            throw new Exception(__("Campaign end date must be after the start date"));
        }
        if(strtotime($args['campaign_end_date']) <= strtotime($date)) {
            throw new Exception(__("Campaign end date must be after today datetime"));
        }
        /* validate campaign budget */
        if(is_empty($args['campaign_budget']) || !is_numeric($args['campaign_budget'])) {
            throw new Exception(__("You must enter valid budget"));
        }
        if($args['campaign_budget'] < max($system['ads_cost_click'], $system['ads_cost_view'])) {
            throw new Exception(__("The minimum budget must be")." <strong>".$system['system_currency_symbol'].max($system['ads_cost_click'], $system['ads_cost_view'])."</strong> ");
        }
        if($this->_data['user_wallet_balance'] < $args['campaign_budget']) {
            throw new Exception(__("Your current wallet credit is")." <strong>".$system['system_currency_symbol'].$this->_data['user_wallet_balance']."</strong> ".__("You need to")." <a href='".$system['system_url']."/wallet'>".__("Replenish wallet credit")."</a>");
        }
        /* validate campaign bidding */
        if(!in_array($args['campaign_bidding'], array('click','view'))) {
            throw new Exception(__("You have to select a valid bidding"));
        }
        /* validate audience countries */
        $args['audience_countries'] = (isset($args['audience_countries']) && is_array($args['audience_countries']))? implode(',',$args['audience_countries']) : "";
        /* validate audience gender */
        if(!in_array($args['audience_gender'], array('all', 'male', 'female', 'other'))) {
            throw new Exception(__("You have to select a valid gender"));
        }
        /* validate audience relationship */
        if(!in_array($args['audience_relationship'], array('all','single', 'relationship', 'married', "complicated", 'separated', 'divorced', 'widowed'))) {
            throw new Exception(__("You have to select a valid relationship"));
        }
        /* validate ads type */
        switch ($args['ads_type']) {
            case 'url':
                if(is_empty($args['ads_url']) || !valid_url($args['ads_url'])) {
                    throw new Exception(__("You have to enter a valid URL for your ads"));
                }
                $args['ads_page'] = 'null';
                $args['ads_group'] = 'null';
                $args['ads_event'] = 'null';
                break;

            case 'page':
                if($args['ads_page'] == "none") {
                    throw new Exception(__("You have to select one for your pages for your ads"));
                }
                $args['ads_url'] = 'null';
                $args['ads_group'] = 'null';
                $args['ads_event'] = 'null';
                break;

            case 'group':
                if($args['ads_group'] == "none") {
                    throw new Exception(__("You have to select one for your groups for your ads"));
                }
                $args['ads_url'] = 'null';
                $args['ads_page'] = 'null';
                $args['ads_event'] = 'null';
                break;

            case 'event':
                if($args['ads_event'] == "none") {
                    throw new Exception(__("You have to select one for your events for your ads"));
                }
                $args['ads_url'] = 'null';
                $args['ads_page'] = 'null';
                $args['ads_group'] = 'null';
                break;
            
            default:
                throw new Exception(__("You have to select a valid ads type"));
                break;
        }
        /* validate ads placement */
        if(!in_array($args['ads_placement'], array('newsfeed','sidebar'))) {
            throw new Exception(__("You have to select a valid ads placement"));
        }
        /* validate ads image */
        if(is_empty($args['ads_image'])) {
            throw new Exception(__("You have to upload an image for your ads"));
        }
        /* insert new campain */
        $db->query(sprintf("INSERT INTO ads_campaigns (
            campaign_user_id, 
            campaign_title, 
            campaign_start_date, 
            campaign_end_date, 
            campaign_budget, 
            campaign_bidding, 
            audience_countries, 
            audience_gender, 
            audience_relationship, 
            ads_title, 
            ads_description, 
            ads_type, 
            ads_url, 
            ads_page, 
            ads_group, 
            ads_event, 
            ads_placement, 
            ads_image, 
            campaign_created_date) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)", 
            secure($this->_data['user_id'], 'int'), 
            secure($args['campaign_title']), 
            secure($args['campaign_start_date'], 'datetime'), 
            secure($args['campaign_end_date'], 'datetime'), 
            secure($args['campaign_budget']), 
            secure($args['campaign_bidding']), 
            secure($args['audience_countries']), 
            secure($args['audience_gender']), 
            secure($args['audience_relationship']), 
            secure($args['ads_title']), 
            secure($args['ads_description']), 
            secure($args['ads_type']), 
            secure($args['ads_url']), 
            secure($args['ads_page']), 
            secure($args['ads_group']), 
            secure($args['ads_event']), 
            secure($args['ads_placement']), 
            secure($args['ads_image']), 
            secure($date) )) or _error(SQL_ERROR_THROWEN);
    }


    /**
     * edit_campaign
     * 
     * @param integer $campaign_id
     * @param array $args
     * @return void
     */
    public function edit_campaign($campaign_id, $args) {
        global $db, $system;
        /* check if ads enabled */
        if($this->_data['user_group'] >= 3 && !$system['ads_enabled']) {
            throw new Exception(__("This feature has been disabled by the admin"));
        }
        /* (check&get) campaign */
        $get_campaign = $db->query(sprintf("SELECT ads_campaigns.*, users.user_wallet_balance FROM ads_campaigns INNER JOIN users ON ads_campaigns.campaign_user_id = users.user_id WHERE ads_campaigns.campaign_id = %s", secure($campaign_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        if($get_campaign->num_rows == 0) {
            _error(403);
        }
        $campaign = $get_campaign->fetch_assoc();
        /* check permission */
        $can_edit = false;
        /* viewer is (admin|moderator) */
        if($this->_data['user_group'] < 3) {
            $can_edit = true;
        /* viewer is the creator of campaign */
        } elseif($this->_data['user_id'] == $campaign['campaign_user_id']) {
            $can_edit = true;
        }
        /* edit the campaign */
        if(!$can_edit) {
            _error(403);
        }
        /* validate campaign title */
        if(is_empty($args['campaign_title'])) {
            throw new Exception(__("You have to enter the campaign title"));
        }
        /* validate campaign start & end dates */
        if(is_empty($args['campaign_start_date'])) {
            throw new Exception(__("You have to enter the campaign start date"));
        }
        if(is_empty($args['campaign_end_date'])) {
            throw new Exception(__("You have to enter the campaign end date"));
        }
        if(strtotime($args['campaign_start_date']) > strtotime($args['campaign_end_date'])) {
            throw new Exception(__("Campaign end date must be after the start date"));
        }
        if(strtotime($args['campaign_end_date']) <= strtotime($date)) {
            throw new Exception(__("Campaign end date must be after today datetime"));
        }
        /* validate campaign budget */
        if(is_empty($args['campaign_budget']) || !is_numeric($args['campaign_budget'])) {
            throw new Exception(__("You must enter valid budget"));
        }
        $remaining = $args['campaign_budget'] - $campaign['campaign_spend']; // campaign remaining (budget(new) - spend)
        if($remaining == 0) {
            throw new Exception(__("The campaign total spend reached the campaign budget already, increase the campaign budget to resume the campaign"));
        }
        if($remaining > $campaign['user_wallet_balance']) {
            throw new Exception(__("The remaining spend is larger than current wallet credit")." <strong>".$system['system_currency_symbol'].$campaign['user_wallet_balance']."</strong> ".__("You need to")." ".__("Replenish wallet credit"));
        }
        /* validate campaign bidding */
        if(!in_array($args['campaign_bidding'], array('click','view'))) {
            throw new Exception(__("You have to select a valid bidding"));
        }
        if($args['campaign_bidding'] == "click") {
            if($remaining < $system['ads_cost_click']) {
                throw new Exception(__("The cost per click is larger than your campaign remaining spend")." <strong>".$system['system_currency_symbol'].$remaining."</strong> ".__("increase the campaign budget to resume the campaign"));
            }
        }
        if($args['campaign_bidding'] == "view") {
            if($remaining < $system['ads_cost_view']) {
                throw new Exception(__("The cost per view is larger than your campaign remaining spend")." <strong>".$system['system_currency_symbol'].$remaining."</strong> ".__("increase the campaign budget to resume the campaign"));
            }
        }
        /* validate audience countries */
        $args['audience_countries'] = (isset($args['audience_countries']) && is_array($args['audience_countries']))? implode(',',$args['audience_countries']) : "";
        /* validate audience gender */
        if(!in_array($args['audience_gender'], array('all', 'male', 'female', 'other'))) {
            throw new Exception(__("You have to select a valid gender"));
        }
        /* validate audience relationship */
        if(!in_array($args['audience_relationship'], array('all','single', 'relationship', 'married', "complicated", 'separated', 'divorced', 'widowed'))) {
            throw new Exception(__("You have to select a valid relationship"));
        }
        /* validate ads type */
        switch ($args['ads_type']) {
            case 'url':
                if(is_empty($args['ads_url']) || !valid_url($args['ads_url'])) {
                    throw new Exception(__("You have to enter a valid URL for your ads"));
                }
                $args['ads_page'] = 'null';
                $args['ads_group'] = 'null';
                $args['ads_event'] = 'null';
                break;

            case 'page':
                if($args['ads_page'] == "none") {
                    throw new Exception(__("You have to select one for your pages for your ads"));
                }
                $args['ads_url'] = 'null';
                $args['ads_group'] = 'null';
                $args['ads_event'] = 'null';
                break;

            case 'group':
                if($args['ads_group'] == "none") {
                    throw new Exception(__("You have to select one for your groups for your ads"));
                }
                $args['ads_url'] = 'null';
                $args['ads_page'] = 'null';
                $args['ads_event'] = 'null';
                break;

            case 'event':
                if($args['ads_event'] == "none") {
                    throw new Exception(__("You have to select one for your events for your ads"));
                }
                $args['ads_url'] = 'null';
                $args['ads_page'] = 'null';
                $args['ads_group'] = 'null';
                break;
            
            default:
                throw new Exception(__("You have to select a valid ads type"));
                break;
        }
        /* validate ads placement */
        if(!in_array($args['ads_placement'], array('newsfeed','sidebar'))) {
            throw new Exception(__("You have to select a valid ads placement"));
        }
        /* validate ads image */
        if(is_empty($args['ads_image'])) {
            throw new Exception(__("You have to upload an image for your ads"));
        }
        /* update the campain */
        $db->query(sprintf("UPDATE ads_campaigns SET 
            campaign_title = %s, 
            campaign_start_date = %s, 
            campaign_end_date = %s, 
            campaign_budget = %s, 
            campaign_bidding = %s, 
            audience_countries = %s, 
            audience_gender = %s, 
            audience_relationship = %s, 
            ads_title = %s, 
            ads_description = %s, 
            ads_type = %s, 
            ads_url = %s, 
            ads_page = %s, 
            ads_group = %s, 
            ads_event = %s, 
            ads_placement = %s, 
            ads_image = %s, 
            campaign_is_active = '1' WHERE campaign_id = %s", 
            secure($args['campaign_title']), 
            secure($args['campaign_start_date'], 'datetime'), 
            secure($args['campaign_end_date'], 'datetime'), 
            secure($args['campaign_budget']), 
            secure($args['campaign_bidding']), 
            secure($args['audience_countries']), 
            secure($args['audience_gender']), 
            secure($args['audience_relationship']), 
            secure($args['ads_title']), 
            secure($args['ads_description']), 
            secure($args['ads_type']), 
            secure($args['ads_url']), 
            secure($args['ads_page']), 
            secure($args['ads_group']), 
            secure($args['ads_event']), 
            secure($args['ads_placement']), 
            secure($args['ads_image']), 
            secure($campaign_id, 'int') )) or _error(SQL_ERROR_THROWEN);
    }


    /**
     * delete_campaign
     * 
     * @param integer $campaign_id
     * @return void
     */
    public function delete_campaign($campaign_id) {
        global $db, $system;
        /* check if ads enabled */
        if($this->_data['user_group'] >= 3 && !$system['ads_enabled']) {
            throw new Exception(__("This feature has been disabled by the admin"));
        }
        /* (check&get) campaign */
        $get_campaign = $db->query(sprintf("SELECT * FROM ads_campaigns WHERE campaign_id = %s", secure($campaign_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        if($get_campaign->num_rows == 0) {
            _error(403);
        }
        $campaign = $get_campaign->fetch_assoc();
        // delete campaign
        $can_delete = false;
        /* viewer is (admin|moderator) */
        if($this->_data['user_group'] < 3) {
            $can_delete = true;
        /* viewer is the creator of campaign */
        } elseif($this->_data['user_id'] == $campaign['campaign_user_id']) {
            $can_delete = true;
        }
        /* delete the campaign */
        if(!$can_delete) {
            _error(403);
        }
        $db->query(sprintf("DELETE FROM ads_campaigns WHERE campaign_id = %s", secure($campaign_id, 'int') )) or _error(SQL_ERROR_THROWEN);
    }


    /**
     * update_campaign_status
     * 
     * @param integer $campaign_id
     * @param boolean $is_active
     * @return void
     */
    public function update_campaign_status($campaign_id, $is_active) {
        global $db, $system, $date;
        /* check if ads enabled */
        if($this->_data['user_group'] >= 3 && !$system['ads_enabled']) {
            throw new Exception(__("This feature has been disabled by the admin"));
        }
        /* (check&get) campaign */
        $get_campaign = $db->query(sprintf("SELECT ads_campaigns.*, users.user_wallet_balance FROM ads_campaigns INNER JOIN users ON ads_campaigns.campaign_user_id = users.user_id WHERE ads_campaigns.campaign_id = %s", secure($campaign_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        if($get_campaign->num_rows == 0) {
            _error(403);
        }
        $campaign = $get_campaign->fetch_assoc();
        // change campaign status
        $can_edit = false;
        /* viewer is (admin|moderator) */
        if($this->_data['user_group'] < 3) {
            $can_edit = true;
        /* viewer is the creator of campaign */
        } elseif($this->_data['user_id'] == $campaign['campaign_user_id']) {
            $can_edit = true;
        }
        /* change campaign status */
        if(!$can_edit) {
            _error(403);
        }
        $is_active = ($is_active)? '1' : '0';
        if($is_active) {
            /* validate campaign */
            if(strtotime($campaign['campaign_end_date']) <= strtotime($date)) {
                throw new Exception(__("Campaign end date must be after today datetime"));
            }
            $remaining = $campaign['campaign_budget'] - $campaign['campaign_spend']; // campaign remaining (budget - spend)
            if($remaining == 0) {
                throw new Exception(__("The campaign total spend reached the campaign budget already, increase the campaign budget to resume the campaign"));
            }
            if($remaining > $campaign['user_wallet_balance']) {
                throw new Exception(__("The remaining spend is larger than current wallet credit")." ".$system['system_currency_symbol'].$campaign['user_wallet_balance']." ".__("You need to")." ".__("Replenish wallet credit"));
            }
            if($campaign['campaign_bidding'] == "click") {
                if($remaining < $system['ads_cost_click']) {
                    throw new Exception(__("The cost per click is larger than your campaign remaining spend")." ".$system['system_currency_symbol'].$remaining." ".__("increase the campaign budget to resume the campaign"));
                }
            }
            if($campaign['campaign_bidding'] == "view") {
                if($remaining < $system['ads_cost_view']) {
                    throw new Exception(__("The cost per view is larger than your campaign remaining spend")." ".$system['system_currency_symbol'].$remaining." ".__("increase the campaign budget to resume the campaign"));
                }
            }
        }
        $db->query(sprintf("UPDATE ads_campaigns SET campaign_is_active = %s WHERE campaign_id = %s", secure($is_active), secure($campaign_id, 'int') )) or _error(SQL_ERROR_THROWEN);
    }


    /**
     * update_campaign_bidding
     * 
     * @param integer $campaign_id
     * @return void
     */
    public function update_campaign_bidding($campaign_id) {
        global $db, $system, $date;
        /* check if ads enabled */
        if(!$system['ads_enabled']) {
            return;
        }
        /* (check&get) campaign */
        $get_campaign = $db->query(sprintf("SELECT ads_campaigns.*, users.user_wallet_balance FROM ads_campaigns INNER JOIN users ON ads_campaigns.campaign_user_id = users.user_id WHERE ads_campaigns.campaign_id = %s", secure($campaign_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        if($get_campaign->num_rows == 0) {
            _error(403);
        }
        $campaign = $get_campaign->fetch_assoc();
        // update campaign if bidding = click
        if($campaign['campaign_bidding'] == "click") {
            /* update campaign spend & clicks */
            $db->query(sprintf("UPDATE ads_campaigns SET campaign_clicks = campaign_clicks + 1, campaign_spend = campaign_spend + %s WHERE campaign_id = %s", secure($system['ads_cost_click']), secure($campaign['campaign_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
            /* decrease campaign author wallet balance */
            $db->query(sprintf('UPDATE users SET user_wallet_balance = IF(user_wallet_balance-%1$s<=0,0,user_wallet_balance-%1$s) WHERE user_id = %2$s', secure($system['ads_cost_click']), secure($campaign['campaign_user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
        }
    }


    /**
     * campaign_estimated_reach
     * 
     * @param array $counties
     * @param string $gender
     * @param string $relationship
     * @return integer
     */
    public function campaign_potential_reach($counties = [], $gender = 'all', $relationship = 'all') {
        global $db, $system;
        $results = 0;
        /* validate gender */
        if(!in_array($gender, array('all', 'male', 'female', 'other'))) {
            return $results;
        }
        /* validate relationship */
        if(!in_array($relationship, array('all','single', 'relationship', 'married', "complicated", 'separated', 'divorced', 'widowed'))) {
            return $results;
        }
        /* prepare where statement */
        $where = "";
        /* validate countries */
        if($counties) {
            $counties_list = implode(',',$counties);
            $where .= " WHERE user_country IN ($counties_list)";
        }
        /* gender */
        if($gender != "all") {
            if($where) {
                $where .= " AND user_gender = '$gender'";
            } else {
                $where .= " WHERE user_gender = '$gender'";
            }
        }
        /* relationship */
        if($relationship != "all") {
            if($where) {
                $where .= " AND user_relationship = '$relationship'";
            } else {
                $where .= " WHERE user_relationship = '$relationship'";
            }
        }
        /* get users */
        $get_users = $db->query("SELECT * FROM users".$where) or _error(SQL_ERROR_THROWEN);
        $results = $get_users->num_rows;
        return $results;
    }



    /* ------------------------------- */
    /* Wallet */
    /* ------------------------------- */

    /**
     * wallet_transfer
     * 
     * @param integer $user_id
     * @param integer $amount
     * @return void
     */
    public function wallet_transfer($user_id, $amount) {
        global $db, $system;
        /* check if ads enabled */
        if(!$system['ads_enabled']) {
            throw new Exception(__("This feature has been disabled by the admin"));
        }
        /* validate amount */
        if(is_empty($amount) || !is_numeric($amount) || $amount <= 0) {
            throw new Exception(__("You must enter valid amount of money"));
        }
        /* validate target user */
        if(is_empty($user_id) || !is_numeric($user_id)) {
            throw new Exception(__("You must search for a user to send money to"));
        }
        if($this->_data['user_id'] == $user_id) {
            throw new Exception(__("You can't send money to yourself!"));
        }
        $check_user = $db->query(sprintf("SELECT * FROM users WHERE user_id = %s", secure($user_id, 'int'))) or _error(SQL_ERROR_THROWEN);
        if($check_user->num_rows == 0) {
            throw new Exception(__("You can't send money to this user!"));
        }
        /* check viewer balance */
        if($this->_data['user_wallet_balance'] < $amount) {
            throw new Exception(__("Your current wallet balance is")." <strong>".$system['system_currency_symbol'].$this->_data['user_wallet_balance']."</strong>, ".__("Recharge your wallet to continue"));
        }
        /* decrease viewer user wallet balance */
        $db->query(sprintf('UPDATE users SET user_wallet_balance = IF(user_wallet_balance-%1$s<=0,0,user_wallet_balance-%1$s) WHERE user_id = %2$s', secure($amount), secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
        /* log this transaction */
        $this->wallet_set_transaction($this->_data['user_id'], 'user', $user_id, $amount, 'out');
        /* increase target user wallet balance */
        $db->query(sprintf("UPDATE users SET user_wallet_balance = user_wallet_balance + %s WHERE user_id = %s", secure($amount), secure($user_id, 'int') )) or _error(SQL_ERROR_THROWEN);
        /* send notification (money sent) to the target user */
        $this->post_notification( array('to_user_id'=>$user_id, 'action'=>'money_sent', 'node_type'=>$amount) );
        /* wallet transaction */
        $this->wallet_set_transaction($user_id, 'user', $this->_data['user_id'], $amount, 'in');
        $_SESSION['wallet_transfer_amount'] = $amount;
    }


    /**
     * wallet_withdraw_affiliates
     * 
     * @param integer $amount
     * @return void
     */
    public function wallet_withdraw_affiliates($amount) {
        global $db, $system;
        /* check if ads enabled */
        if(!$system['ads_enabled']) {
            throw new Exception(__("This feature has been disabled by the admin"));
        }
        /* check if affiliates enabled */
        if(!$system['affiliates_enabled']) {
            throw new Exception(__("This feature has been disabled by the admin"));
        }
        /* validate amount */
        if(is_empty($amount) || !is_numeric($amount) || $amount <= 0) {
            throw new Exception(__("You must enter valid amount of money"));
        }
        /* check viewer balance */
        if($this->_data['user_affiliate_balance'] < $amount) {
            throw new Exception(__("The amount is larger than your current affiliates balance")." <strong>".$system['system_currency_symbol'].$this->_data['user_affiliate_balance']."</strong>");
        }
        /* decrease viewer user affiliate balance */
        $db->query(sprintf('UPDATE users SET user_affiliate_balance = IF(user_affiliate_balance-%1$s=0,0,user_affiliate_balance-%1$s) WHERE user_id = %2$s', secure($amount), secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
        /* increase viewer user wallet balance */
        $db->query(sprintf("UPDATE users SET user_wallet_balance = user_wallet_balance + %s WHERE user_id = %s", secure($amount), secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
        /* wallet transaction */
        $this->wallet_set_transaction($this->_data['user_id'], 'withdraw_affiliates', 0, $amount, 'in');
        $_SESSION['wallet_withdraw_affiliates_amount'] = $amount;
    }


    /**
     * wallet_withdraw_points
     * 
     * @param integer $amount
     * @return void
     */
    public function wallet_withdraw_points($amount) {
        global $db, $system;
        /* check if ads enabled */
        if(!$system['ads_enabled']) {
            throw new Exception(__("This feature has been disabled by the admin"));
        }
        /* check if points enabled */
        if(!$system['points_enabled'] || !$system['points_money_transfer_enabled']) {
            throw new Exception(__("This feature has been disabled by the admin"));
        }
        /* validate amount */
        if(is_empty($amount) || !is_numeric($amount) || $amount <= 0) {
            throw new Exception(__("You must enter valid amount of money"));
        }
        /* check viewer balance */
        $points_balance = ((1/$system['points_per_currency'])*$this->_data['user_points']);
        if($points_balance < $amount) {
            throw new Exception(__("The amount is larger than your current points balance")." <strong>".$system['system_currency_symbol'].$points_balance."</strong>");
        }
        /* decrease viewer user points balance */
        $balance = $this->_data['user_points'] - ($system['points_per_currency']*$_POST['amount']);
        $db->query(sprintf("UPDATE users SET user_points = %s WHERE user_id = %s", secure($balance), secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
        /* increase viewer user wallet balance */
        $db->query(sprintf("UPDATE users SET user_wallet_balance = user_wallet_balance + %s WHERE user_id = %s", secure($amount), secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
        /* wallet transaction */
        $this->wallet_set_transaction($this->_data['user_id'], 'withdraw_points', 0, $amount, 'in');
        $_SESSION['wallet_withdraw_points_amount'] = $amount;
    }


    /**
     * wallet_set_transaction
     * 
     * @param integer $user_id
     * @param string $node_type
     * @param integer $node_id
     * @param integer $amount
     * @param string $type
     * @return void
     */
    public function wallet_set_transaction($user_id, $node_type, $node_id, $amount, $type) {
        global $db, $system, $date;
        $db->query(sprintf("INSERT INTO ads_users_wallet_transactions (user_id, node_type, node_id, amount, type, date) VALUES (%s, %s, %s, %s, %s, %s)", secure($user_id, 'int'), secure($node_type), secure($node_id, 'int'), secure($amount), secure($type), secure($date) )) or _error(SQL_ERROR_THROWEN);
    }


    /**
     * wallet_get_transactions
     * 
     * @return array
     */
    public function wallet_get_transactions() {
        global $db;
        $transactions = array();
        $get_transactions = $db->query(sprintf("SELECT ads_users_wallet_transactions.*, users.user_name, users.user_firstname, users.user_lastname, users.user_gender, users.user_picture FROM ads_users_wallet_transactions LEFT JOIN users ON ads_users_wallet_transactions.node_type='user' AND ads_users_wallet_transactions.node_id = users.user_id WHERE ads_users_wallet_transactions.user_id = %s ORDER BY ads_users_wallet_transactions.transaction_id DESC", secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
        if($get_transactions->num_rows > 0) {
            while($transaction = $get_transactions->fetch_assoc()) {
                if($transaction['node_type'] == "user") {
                    $transaction['user_picture'] = get_picture($transaction['user_picture'], $transaction['user_gender']);
                }
                $transactions[] = $transaction;
            }
        }
        return $transactions;
    }



    /* ------------------------------- */
    /* Points System */
    /* ------------------------------- */

    /**
     * points_balance
     * 
     * @param string $type
     * @param string $node_type
     * @param integer $user_id
     * @return void
     */
    public function points_balance($type, $node_type, $user_id) {
        global $db, $system;
        /* check if points enabled */
        if(!$system['points_enabled']) {
            return;
        }
        switch ($node_type) {
            case 'post':
                $points_per_node = $system['points_per_post'];
                break;

            case 'comment':
                $points_per_node = $system['points_per_comment'];
                break;

            case 'reaction':
                $points_per_node = $system['points_per_reaction'];
                break;
            
        }
        switch ($type) {
            case 'add':
                $db->query(sprintf("UPDATE users SET user_points = user_points + %s WHERE user_id = %s", secure($points_per_node, 'int'), secure($user_id, 'int') )) or _error(SQL_ERROR_THROWEN);
                break;

            case 'delete':
                $db->query(sprintf('UPDATE users SET user_points = IF(user_points-%1$s<=0,0,user_points-%1$s) WHERE user_id = %2$s', secure($points_per_node, 'int'), secure($user_id, 'int') )) or _error(SQL_ERROR_THROWEN);
                break;
        }
    }



    /* ------------------------------- */
    /* Widgets */
    /* ------------------------------- */

    /**
     * widget
     * 
     * @param array $place
     * @return array
     */
    public function widgets($place) {
        global $db;
        $widgets = array();
        $get_widgets = $db->query(sprintf("SELECT * FROM widgets WHERE place = %s", secure($place) )) or _error(SQL_ERROR_THROWEN);
        if($get_widgets->num_rows > 0) {
            while($widget = $get_widgets->fetch_assoc()) {
                $widget['code'] = html_entity_decode($widget['code'], ENT_QUOTES);
                $widgets[] = $widget;
            }
        }
        return $widgets;
    }



    /* ------------------------------- */
    /* User Settings */
    /* ------------------------------- */

    /**
     * settings
     * 
     * @param string $edit
     * @param array $args
     * @return void
     */
    public function settings($edit, $args) {
        global $db, $system;
        switch ($edit) {
            case 'username':
                /* validate username */
                if(strtolower($args['username']) != strtolower($this->_data['user_name'])) {
                    if(!valid_username($args['username'])) {
                        throw new Exception(__("Please enter a valid username (a-z0-9_.) with minimum 3 characters long"));
                    }
                    if(reserved_username($args['username'])) {
                        throw new Exception(__("You can't use")." <strong>".$args['username']."</strong> ".__("as username"));
                    }
                    if($this->check_username($args['username'])) {
                        throw new Exception(__("Sorry, it looks like")." <strong>".$args['username']."</strong> ".__("belongs to an existing account"));
                    }
                    /* update user */
                    $db->query(sprintf("UPDATE users SET user_name = %s WHERE user_id = %s", secure($args['username']), secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                }
                break;

            case 'email':
                /* validate email */
                if($args['email'] != $this->_data['user_email']) {
                    $this->activation_email_reset($args['email']);
                }
                break;

            case 'phone':
                /* validate phone */
                if($args['phone'] != $this->_data['user_phone']) {
                    $this->activation_phone_reset($args['phone']);
                }
                break;

            case 'password':
                /* validate all fields */
                if(is_empty($args['current']) || is_empty($args['new']) || is_empty($args['confirm'])) {
                    throw new Exception(__("You must fill in all of the fields"));
                }
                /* validate current password (MD5 check for versions < v2.5) */
                if(md5($args['current']) != $this->_data['user_password'] && !password_verify($args['current'], $this->_data['user_password'])) {
                    throw new Exception(__("Your current password is incorrect"));
                }
                /* validate new password */
                if($args['new'] != $args['confirm']) {
                    throw new Exception(__("Your passwords do not match"));
                }
                if(strlen($args['new']) < 6) {
                    throw new Exception(__("Password must be at least 6 characters long. Please try another"));
                }
                /* update user */
                $db->query(sprintf("UPDATE users SET user_password = %s WHERE user_id = %s", secure(_password_hash($args['new'])), secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                break;

            case 'basic':
                /* validate firstname */
                if(is_empty($args['firstname'])) {
                    throw new Exception(__("You must enter first name"));
                }
                if(!valid_name($args['firstname'])) {
                    throw new Exception(__("First name contains invalid characters"));
                }
                if(strlen($args['firstname']) < 3) {
                    throw new Exception(__("First name must be at least 3 characters long. Please try another"));
                }
                /* validate lastname */
                if(is_empty($args['lastname'])) {
                    throw new Exception(__("You must enter last name"));
                }
                if(!valid_name($args['lastname'])) {
                    throw new Exception(__("Last name contains invalid characters"));
                }
                if(strlen($args['lastname']) < 3) {
                    throw new Exception(__("Last name must be at least 3 characters long. Please try another"));
                }
                /* validate gender */
                if(!in_array($args['gender'], array('male', 'female', 'other'))) {
                    throw new Exception(__("Please select a valid gender"));
                }
                /* validate country */
                if($args['country'] == "none") {
                    throw new Exception(__("You must select valid country"));
                } else {
                    $check_country = $db->query(sprintf("SELECT * FROM system_countries WHERE country_id = %s", secure($args['country'], 'int') )) or _error(SQL_ERROR_THROWEN);
                    if($check_country->num_rows == 0) {
                        throw new Exception(__("You must select valid country"));
                    }
                }
                /* validate birthdate */
                if($args['birth_month'] == "none" && $args['birth_day'] == "none" && $args['birth_year'] == "none") {
                    $args['birth_date'] = 'null';
                } else {
                    if(!in_array($args['birth_month'], range(1, 12))) {
                        throw new Exception(__("Please select a valid birth month"));
                    }
                    if(!in_array($args['birth_day'], range(1, 31))) {
                        throw new Exception(__("Please select a valid birth day"));
                    }
                    if(!in_array($args['birth_year'], range(1905, 2015))) {
                        throw new Exception(__("Please select a valid birth year"));
                    }
                    $args['birth_date'] = $args['birth_year'].'-'.$args['birth_month'].'-'.$args['birth_day'];
                }
                /* validate relationship */
                if($args['relationship'] == "none") {
                    $args['relationship'] = 'null';
                } else {
                    $relationships = array('single', 'relationship', 'married', "complicated", 'separated', 'divorced', 'widowed');
                    if(!in_array($args['relationship'], $relationships)) {
                        throw new Exception(__("Please select a valid relationship"));
                    }
                }
                /* validate website */
                if(!is_empty($args['website'])) {
                    if(!valid_url($args['website'])) {
                        throw new Exception(__("Please enter a valid website"));
                    }
                } else {
                    $args['website'] = 'null';
                }
                /* set custom fields */
                $custom_fields = $this->set_custom_fields($args, "user" ,"settings", $this->_data['user_id']);
                /* update user */
                $db->query(sprintf("UPDATE users SET user_firstname = %s, user_lastname = %s, user_gender = %s, user_country = %s, user_birthdate = %s, user_relationship = %s, user_biography = %s, user_website = %s WHERE user_id = %s", secure($args['firstname']), secure($args['lastname']), secure($args['gender']), secure($args['country'], 'int'), secure($args['birth_date']), secure($args['relationship']), secure($args['biography']), secure($args['website']), secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                break;

            case 'work':
                /* validate work website */
                if(!is_empty($args['work_url'])) {
                    if(!valid_url($args['work_url'])) {
                        throw new Exception(__("Please enter a valid work website"));
                    }
                } else {
                    $args['work_url'] = 'null';
                }
                /* set custom fields */
                $custom_fields = $this->set_custom_fields($args, "user" ,"settings", $this->_data['user_id']);
                /* update user */
                $db->query(sprintf("UPDATE users SET user_work_title = %s, user_work_place = %s, user_work_url = %s WHERE user_id = %s", secure($args['work_title']), secure($args['work_place']), secure($args['work_url']), secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                break;

            case 'location':
                /* set custom fields */
                $custom_fields = $this->set_custom_fields($args, "user" ,"settings", $this->_data['user_id']);
                /* update user */
                $db->query(sprintf("UPDATE users SET user_current_city = %s, user_hometown = %s WHERE user_id = %s", secure($args['city']), secure($args['hometown']), secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                break;

            case 'education':
                /* set custom fields */
                $custom_fields = $this->set_custom_fields($args, "user" ,"settings", $this->_data['user_id']);
                /* update user */
                $db->query(sprintf("UPDATE users SET user_edu_major = %s, user_edu_school = %s, user_edu_class = %s WHERE user_id = %s", secure($args['edu_major']), secure($args['edu_school']), secure($args['edu_class']), secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                break;

            case 'social':
                /* validate facebook */
                if(!is_empty($args['facebook']) && !valid_url($args['facebook'])) {
                    throw new Exception(__("Please enter a valid Facebook Profile URL"));
                }
                /* validate twitter */
                if(!is_empty($args['twitter']) && !valid_url($args['twitter'])) {
                    throw new Exception(__("Please enter a valid Twitter Profile URL"));
                }
                /* validate google */
                if(!is_empty($args['google']) && !valid_url($args['google'])) {
                    throw new Exception(__("Please enter a valid Google+ Profile URL"));
                }
                /* validate youtube */
                if(!is_empty($args['youtube']) && !valid_url($args['youtube'])) {
                    throw new Exception(__("Please enter a valid YouTube Profile URL"));
                }
                /* validate instagram */
                if(!is_empty($args['instagram']) && !valid_url($args['instagram'])) {
                    throw new Exception(__("Please enter a valid Instagram Profile URL"));
                }
                /* validate linkedin */
                if(!is_empty($args['linkedin']) && !valid_url($args['linkedin'])) {
                    throw new Exception(__("Please enter a valid Linkedin Profile URL"));
                }
                /* validate vkontakte */
                if(!is_empty($args['vkontakte']) && !valid_url($args['vkontakte'])) {
                    throw new Exception(__("Please enter a valid Vkontakte Profile URL"));
                }
                /* set custom fields */
                $custom_fields = $this->set_custom_fields($args, "user" ,"settings", $this->_data['user_id']);
                /* update user */
                $db->query(sprintf("UPDATE users SET user_social_facebook = %s, user_social_twitter = %s, user_social_google = %s, user_social_youtube = %s, user_social_instagram = %s, user_social_linkedin = %s, user_social_vkontakte = %s WHERE user_id = %s", secure($args['facebook']), secure($args['twitter']), secure($args['google']), secure($args['youtube']), secure($args['instagram']), secure($args['linkedin']), secure($args['vkontakte']), secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                break;

            case 'other':
                /* set custom fields */
                $custom_fields = $this->set_custom_fields($args, "user" ,"settings", $this->_data['user_id']);
                break;

            case 'privacy':
                /* prepare */
                $args['privacy_chat'] = ($args['privacy_chat'] == 0)? 0 : 1;
                $args['privacy_newsletter'] = ($args['privacy_newsletter'] == 0)? 0 : 1;
                $privacy = array('me', 'friends', 'public');
                if(!in_array($args['privacy_wall'], $privacy) || !in_array($args['privacy_birthdate'], $privacy) || !in_array($args['privacy_relationship'], $privacy) || !in_array($args['privacy_basic'], $privacy) || !in_array($args['privacy_work'], $privacy) || !in_array($args['privacy_location'], $privacy) || !in_array($args['privacy_education'], $privacy) || !in_array($args['privacy_other'], $privacy) || !in_array($args['privacy_friends'], $privacy) || !in_array($args['privacy_photos'], $privacy) || !in_array($args['privacy_pages'], $privacy) || !in_array($args['privacy_groups'], $privacy) || !in_array($args['privacy_events'], $privacy)) {
                    _error(400);
                }
                /* update user */
                $db->query(sprintf("UPDATE users SET user_chat_enabled = %s, user_privacy_wall = %s, user_privacy_birthdate = %s, user_privacy_relationship = %s, user_privacy_basic = %s, user_privacy_work = %s, user_privacy_location = %s, user_privacy_education = %s, user_privacy_other = %s, user_privacy_friends = %s, user_privacy_photos = %s, user_privacy_pages = %s, user_privacy_groups = %s, user_privacy_events = %s, user_privacy_newsletter = %s WHERE user_id = %s", secure($args['privacy_chat']), secure($args['privacy_wall']), secure($args['privacy_birthdate']), secure($args['privacy_relationship']), secure($args['privacy_basic']), secure($args['privacy_work']), secure($args['privacy_location']), secure($args['privacy_education']), secure($args['privacy_other']), secure($args['privacy_friends']), secure($args['privacy_photos']), secure($args['privacy_pages']), secure($args['privacy_groups']), secure($args['privacy_events']), secure($args['privacy_newsletter']), secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                break;

            case 'two-factor':
                if($system['two_factor_type'] != $args['type']) {
                    _error(400);
                }
                /* prepare */
                $args['two_factor_enabled'] = (isset($args['two_factor_enabled']))? '1' : '0';
                switch ($system['two_factor_type']) {
                    case 'email':
                        if($args['two_factor_enabled'] && !$this->_data['user_email_verified']) {
                            throw new Exception(__("Two-Factor Authentication can't be enabled till you verify your email address"));
                        }
                        break;

                    case 'sms':
                        if($args['two_factor_enabled'] && !$this->_data['user_phone']) {
                            throw new Exception(__("Two-Factor Authentication can't be enabled till you enter your phone number"));
                        }
                        if($args['two_factor_enabled'] && !$this->_data['user_phone_verified']) {
                            throw new Exception(__("Two-Factor Authentication can't be enabled till you verify your phone number"));
                        }
                        break;

                    case 'google':
                        if(isset($args['gcode'])) {
                            /* Google Authenticator */
                            require_once(ABSPATH.'includes/libs/GoogleAuthenticator/GoogleAuthenticator.php');
                            $ga = new PHPGangsta_GoogleAuthenticator();
                            /* verify code */
                            if(!$ga->verifyCode($this->_data['user_two_factor_gsecret'], $args['gcode'])) {
                                throw new Exception(__("Invalid code, Try again or try to scan your QR code again"));
                            }
                            $args['two_factor_enabled'] = '1';
                        }
                        break;
                }
                /* update user */
                $db->query(sprintf("UPDATE users SET user_two_factor_enabled = %s, user_two_factor_type = %s WHERE user_id = %s", secure($args['two_factor_enabled']), secure($system['two_factor_type']), secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                break;

            case 'notifications':
                /* prepare */
                $args['email_post_likes'] = (isset($args['email_post_likes']))? '1' : '0';
                $args['email_post_comments'] = (isset($args['email_post_comments']))? '1' : '0';
                $args['email_post_shares'] = (isset($args['email_post_shares']))? '1' : '0';
                $args['email_wall_posts'] = (isset($args['email_wall_posts']))? '1' : '0';
                $args['email_mentions'] = (isset($args['email_mentions']))? '1' : '0';
                $args['email_profile_visits'] = (isset($args['email_profile_visits']))? '1' : '0';
                $args['email_friend_requests'] = (isset($args['email_friend_requests']))? '1' : '0';
                /* update user */
                $db->query(sprintf("UPDATE users SET email_post_likes = %s, email_post_comments = %s, email_post_shares = %s, email_wall_posts = %s, email_mentions = %s, email_profile_visits = %s, email_friend_requests = %s WHERE user_id = %s", secure($args['email_post_likes']), secure($args['email_post_comments']), secure($args['email_post_shares']), secure($args['email_wall_posts']), secure($args['email_mentions']), secure($args['email_profile_visits']), secure($args['email_friend_requests']), secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                break;

            case 'notifications_sound':
                /* prepare */
                $args['notifications_sound'] = ($args['notifications_sound'] == 0)? 0 : 1;
                /* update user */
                $db->query(sprintf("UPDATE users SET notifications_sound = %s WHERE user_id = %s", secure($args['notifications_sound']), secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                break;

            case 'chat':
                /* prepare */
                $args['privacy_chat'] = ($args['privacy_chat'] == 0)? 0 : 1;
                /* update user */
                $db->query(sprintf("UPDATE users SET user_chat_enabled = %s WHERE user_id = %s", secure($args['privacy_chat']), secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                break;

            case 'started':
                /* validate country */
                if($args['country'] == "none") {
                    throw new Exception(__("You must select valid country"));
                } else {
                    $check_country = $db->query(sprintf("SELECT * FROM system_countries WHERE country_id = %s", secure($args['country'], 'int') )) or _error(SQL_ERROR_THROWEN);
                    if($check_country->num_rows == 0) {
                        throw new Exception(__("You must select valid country"));
                    }
                }
                /* validate work website */
                if(!is_empty($args['work_url'])) {
                    if(!valid_url($args['work_url'])) {
                        throw new Exception(__("Please enter a valid work website"));
                    }
                } else {
                    $args['work_url'] = 'null';
                }
                /* update user */
                $db->query(sprintf("UPDATE users SET user_country = %s, user_work_title = %s, user_work_place = %s, user_work_url = %s, user_current_city = %s, user_hometown = %s, user_edu_major = %s, user_edu_school = %s, user_edu_class = %s WHERE user_id = %s", secure($args['country'], 'int'), secure($args['work_title']), secure($args['work_place']), secure($args['work_url']), secure($args['city']), secure($args['hometown']), secure($args['edu_major']), secure($args['edu_school']), secure($args['edu_class']), secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                break;
        }
    }



    /* ------------------------------- */
    /* User Sign (in|up|out) */
    /* ------------------------------- */

    /**
     * sign_up
     * 
     * @param array $args
     * @return void
     */
    public function sign_up($args = []) {
        global $db, $system, $date;
        /* check invitation code */
        if(!$system['registration_enabled'] && $system['invitation_enabled']) {
            if(!$this->check_invitation_code($args['invitation_code'])) {
                throw new Exception(__("The invitation code you entered is invalid or expired"));
            }
        }
        /* check IP */
        $this->_check_ip();
        if(is_empty($args['first_name']) || is_empty($args['last_name']) || is_empty($args['username']) || is_empty($args['password'])) {
            throw new Exception(__("You must fill in all of the fields"));
        }
        if(!valid_username($args['username'])) {
            throw new Exception(__("Please enter a valid username (a-z0-9_.) with minimum 3 characters long"));
        }
        if(reserved_username($args['username'])) {
            throw new Exception(__("You can't use")." <strong>".$args['username']."</strong> ".__("as username"));
        }
        if($this->check_username($args['username'])) {
            throw new Exception(__("Sorry, it looks like")." <strong>".$args['username']."</strong> ".__("belongs to an existing account"));
        }
        if(!valid_email($args['email'])) {
            throw new Exception(__("Please enter a valid email address"));
        }
        if($this->check_email($args['email'])) {
            throw new Exception(__("Sorry, it looks like")." <strong>".$args['email']."</strong> ".__("belongs to an existing account"));
        }
        if($system['activation_enabled'] && $system['activation_type'] == "sms") {
            if(is_empty($args['phone'])) {
                throw new Exception(__("Please enter a valid phone number"));
            }
            if($this->check_phone($args['phone'])) {
                throw new Exception(__("Sorry, it looks like")." <strong>".$args['phone']."</strong> ".__("belongs to an existing account"));
            }
        } else {
            $args['phone'] = 'null';
        }
        if(strlen($args['password']) < 6) {
            throw new Exception(__("Your password must be at least 6 characters long. Please try another"));
        }
        if(!valid_name($args['first_name'])) {
            throw new Exception(__("Your first name contains invalid characters"));
        }
        if(strlen($args['first_name']) < 3) {
            throw new Exception(__("Your first name must be at least 3 characters long. Please try another"));
        }
        if(!valid_name($args['last_name'])) {
            throw new Exception(__("Your last name contains invalid characters"));
        }
        if(strlen($args['last_name']) < 3) {
            throw new Exception(__("Your last name must be at least 3 characters long. Please try another"));
        }
        if(!in_array($args['gender'], array('male', 'female', 'other'))) {
            throw new Exception(__("Please select a valid gender"));
        }
        /* check age restriction */
        if($system['age_restriction']) {
            if(!in_array($args['birth_month'], range(1, 12))) {
                throw new Exception(__("Please select a valid birth month"));
            }
            if(!in_array($args['birth_day'], range(1, 31))) {
                throw new Exception(__("Please select a valid birth day"));
            }
            if(!in_array($args['birth_year'], range(1905, 2017))) {
                throw new Exception(__("Please select a valid birth year"));
            }
            if(date("Y") - $args['birth_year'] < $system['minimum_age']) {
                throw new Exception(__("Sorry, You must be")." <strong>".$system['minimum_age']."</strong> ".__("years old to register"));
            }
            $args['birth_date'] = $args['birth_year'].'-'.$args['birth_month'].'-'.$args['birth_day'];
        } else {
            $args['birth_date'] = 'null';
        }
        /* set custom fields */
        $custom_fields = $this->set_custom_fields($args);
        /* check reCAPTCHA */
        if($system['reCAPTCHA_enabled']) {
            require_once(ABSPATH.'includes/libs/ReCaptcha/autoload.php');
            $recaptcha = new \ReCaptcha\ReCaptcha($system['reCAPTCHA_secret_key']);
            $resp = $recaptcha->verify($args['g-recaptcha-response'], get_user_ip());
            if (!$resp->isSuccess()) {
                throw new Exception(__("The secuirty check is incorrect. Please try again"));
            }
        }
        /* check privacy agreement */
        if(!isset($args['privacy_agree'])) {
            throw new Exception(__("You must read and agree to our terms and privacy policy"));
        }
        /* generate verification code */
        $email_verification_code = ($system['activation_enabled'] && $system['activation_type'] == "email")? get_hash_token() : 'null';
        $phone_verification_code = ($system['activation_enabled'] && $system['activation_type'] == "sms")? get_hash_key() : 'null';
        /* register user */
        $db->query(sprintf("INSERT INTO users (user_name, user_email, user_phone, user_password, user_firstname, user_lastname, user_gender, user_birthdate, user_registered, user_email_verification_code, user_phone_verification_code) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)", secure($args['username']), secure($args['email']), secure($args['phone']), secure(_password_hash($args['password'])), secure(ucwords($args['first_name'])), secure(ucwords($args['last_name'])), secure($args['gender']), secure($args['birth_date']), secure($date), secure($email_verification_code), secure($phone_verification_code) )) or _error(SQL_ERROR_THROWEN);
        /* get user_id */
        $user_id = $db->insert_id;
        /* insert custom fields values */
        if($custom_fields) {
            foreach($custom_fields as $field_id => $value) {
                $db->query(sprintf("INSERT INTO custom_fields_values (value, field_id, node_id, node_type) VALUES (%s, %s, %s, 'user')", secure($value), secure($field_id, 'int'), secure($user_id, 'int') ));
            }
        }
        /* send activation */
        if($system['activation_enabled']) {
            if($system['activation_type'] == "email") {
                /* prepare activation email */
                $subject = __("Just one more step to get started on")." ".$system['system_title'];
                $body  = __("Hi")." ".ucwords($args['first_name']." ".$args['last_name']).",";
                $body .= "\r\n\r\n".__("To complete the activation process, please follow this link:");
                $body .= "\r\n\r\n".$system['system_url']."/activation/".$user_id."/".$email_verification_code;
                $body .= "\r\n\r\n".__("Welcome to")." ".$system['system_title'];
                $body .= "\r\n\r".$system['system_title']." ".__("Team");
                /* send email */
                if(!_email($args['email'], $subject, $body)) {
                    throw new Exception(__("Activation email could not be sent").", ".__("But you can login now"));
                }
            } else {
                /* prepare activation SMS */
                $message  = $system['system_title']." ".__("Activation Code").": ".$phone_verification_code;
                /* send SMS */
                if(!sms_send($args['phone'], $message)) {
                    throw new Exception(__("Activation SMS could not be sent").", ".__("But you can login now"));
                }
            }
        } else {
            /* affiliates system (as activation disabled) */
            $this->process_affiliates("registration", $user_id);
        }
        /* update invitation code */
        if(!$system['registration_enabled'] && $system['invitation_enabled']) {
            $this->update_invitation_code($args['invitation_code']);
        }
        /* set cookies */
        $this->_set_cookies($user_id);
    }
    

    /**
     * sign_in
     * 
     * @param string $username_email
     * @param string $password
     * @param boolean $remember
     * 
     * @return void
     */
    public function sign_in($username_email, $password, $remember = false) {
        global $db, $system;
        /* valid inputs */
        if(is_empty($username_email) || is_empty($password)) {
            throw new Exception(__("You must fill in all of the fields"));
        }
        /* check if username or email */
        if(valid_email($username_email)) {
            $user = $this->check_email($username_email, true);
            if($user === false) {
                throw new Exception(__("The email you entered does not belong to any account"));
            }
            $field = "user_email";
        } else {
            if(!valid_username($username_email)) {
                throw new Exception(__("Please enter a valid email address or username"));
            }
            $user = $this->check_username($username_email, 'user', true);
            if($user === false) {
                throw new Exception(__("The username you entered does not belong to any account"));
            }
            $field = "user_name";
        }
        /* check password */
        if(!password_verify($password, $user['user_password'])) {
            throw new Exception("<p><strong>".__("Please re-enter your password")."</strong></p><p>".__("The password you entered is incorrect").". ".__("If you forgot your password?")." <a href='".$system['system_url']."/reset'>".__("Request a new one")."</a></p>");
        }
        /* two-factor authentication */
        if($user['user_two_factor_enabled']) {
            /* system two-factor disabled */
            if(!$system['two_factor_enabled']) {
                $this->disable_two_factor_authentication($user['user_id']);
                goto set_cookies;
            }
            /* system two-factor method != user two-factor method */
            if($system['two_factor_type'] != $user['user_two_factor_type']) {
                $this->disable_two_factor_authentication($user['user_id']);
                goto set_cookies;
            }
            switch ($system['two_factor_type']) {
                case 'email':
                    /* system two-factor method = email but user email not verified */
                    if(!$user['user_email_verified']) {
                        $this->disable_two_factor_authentication($user['user_id']);
                        goto set_cookies;
                    }
                    /* generate two-factor key */
                    $two_factor_key = get_hash_key(6);
                    /* update user two factor key */
                    $db->query(sprintf("UPDATE users SET user_two_factor_key = %s WHERE user_id = %s", secure($two_factor_key), secure($user['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                    /* prepare method name */
                    $method = __("Email");
                    /* prepare activation email */
                    $subject = $system['system_title']." ".__("Two-Factor Authentication Token");
                    $body  = __("Hi")." ".ucwords($user['first_name']." ".$user['last_name']).",";
                    $body .= "\r\n\r\n".__("To complete the sign-in process, please use the following 6-digit key:");
                    $body .= "\r\n\r\n".__("Two-factor authentication key").": ".$two_factor_key;
                    $body .= "\r\n\r".$system['system_title']." ".__("Team");
                    /* send email */
                    if(!_email($user['user_email'], $subject, $body)) {
                        throw new Exception(__("Two-factor authentication email could not be sent"));
                    }
                    break;
                
                case 'sms':
                    /* system two-factor method = sms but not user phone not verified */
                    if(!$user['user_phone_verified']) {
                        $this->disable_two_factor_authentication($user['user_id']);
                        goto set_cookies;
                    }
                    /* generate two-factor key */
                    $two_factor_key = get_hash_key(6);
                    /* update user two factor key */
                    $db->query(sprintf("UPDATE users SET user_two_factor_key = %s WHERE user_id = %s", secure($two_factor_key), secure($user['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                    /* prepare method name */
                    $method = __("Phone");
                    /* prepare activation SMS */
                    $message  = $system['system_title']." ".__("Two-factor authentication key").": ".$two_factor_key;
                    /* send SMS */
                    if(!sms_send($user['user_phone'], $message)) {
                        throw new Exception(__("Two-factor authentication SMS could not be sent"));
                    }
                    break;

                case 'google':
                    /* prepare method name */
                    $method = __("Google Authenticator app");
                    break;
            }
            modal("#two-factor-authentication", "{user_id: '".$user['user_id']."', remember: '".$remember."', method: '".$method."'}");
        }
        /* set cookies */
        set_cookies:
        $this->_set_cookies($user['user_id'], $remember);
    }


    /**
     * sign_out
     * 
     * @return void
     */
    public function sign_out() {
        global $db, $date;
        /* delete the session */
        $db->query(sprintf("DELETE FROM users_sessions WHERE session_token = %s AND user_id = %s", secure($_COOKIE[$this->_cookie_user_token]), secure($_COOKIE[$this->_cookie_user_id], 'int') )) or _error(SQL_ERROR_THROWEN);
        /* destroy the session */
        session_destroy();
        /* unset the cookies */
        unset($_COOKIE[$this->_cookie_user_id]);
        unset($_COOKIE[$this->_cookie_user_token]);
        setcookie($this->_cookie_user_id, NULL, -1, '/');
        setcookie($this->_cookie_user_token, NULL, -1, '/');
    }


    /**
     * _set_cookies
     * 
     * @param integer $user_id
     * @param boolean $remember
     * @param string $path
     * @return void
     */
    private function _set_cookies($user_id, $remember = false, $path = '/') {
        global $db, $date;
        /* generate new token */
        $session_token = get_hash_token();
        /* secured cookies */
        $secured = (get_system_protocol() == "https")? true : false;
        /* set cookies */
        if($remember) {
            $expire = time()+2592000;
            setcookie($this->_cookie_user_id, $user_id, $expire, $path, "", $secured, true);
            setcookie($this->_cookie_user_token, $session_token, $expire, $path, "", $secured, true);
        }else {
            setcookie($this->_cookie_user_id, $user_id, 0, $path, "", $secured, true);
            setcookie($this->_cookie_user_token, $session_token, 0, $path, "", $secured, true);
        }
        /* insert user token */
        $db->query(sprintf("INSERT INTO users_sessions (session_token, session_date, user_id, user_browser, user_os, user_ip) VALUES (%s, %s, %s, %s, %s, %s)", secure($session_token), secure($date), secure($user_id, 'int'), secure(get_user_browser()), secure(get_user_os()), secure(get_user_ip()) )) or _error(SQL_ERROR_THROWEN);
    }


    /**
     * _check_ip
     * 
     * @return void
     */
    private function _check_ip() {
        global $db, $system;
        if($system['max_accounts'] > 0) {
            $check = $db->query(sprintf("SELECT user_ip, COUNT(*) FROM users_sessions WHERE user_ip = %s GROUP BY user_id", secure(get_user_ip()) )) or _error(SQL_ERROR_THROWEN);
            if($check->num_rows >= $system['max_accounts']) {
                throw new Exception(__("You have reached the maximum number of account for your IP"));
            }
        }
    }



    /* ------------------------------- */
    /* Socail Login */
    /* ------------------------------- */

    /**
     * socail_login
     * 
     * @param string $provider
     * @param object $user_profile
     * 
     * @return void
     */
    public function socail_login($provider, $user_profile) {
        global $db, $smarty;
        switch ($provider) {
            case 'facebook':
                $social_id = "facebook_id";
                $social_connected = "facebook_connected";
                break;
            
            case 'twitter':
                $social_id = "twitter_id";
                $social_connected = "twitter_connected";
                break;

            case 'google':
                $social_id = "google_id";
                $social_connected = "google_connected";
                break;

            case 'instagram':
                $social_id = "instagram_id";
                $social_connected = "instagram_connected";
                break;

            case 'linkedin':
                $social_id = "linkedin_id";
                $social_connected = "linkedin_connected";
                break;

            case 'vkontakte':
                $social_id = "vkontakte_id";
                $social_connected = "vkontakte_connected";
                break;
        }
        /* check if user connected or not */
        $check_user = $db->query(sprintf("SELECT user_id FROM users WHERE $social_id = %s", secure($user_profile->identifier) )) or _error(SQL_ERROR_THROWEN);
        if($check_user->num_rows > 0) {
            /* social account connected and just signing-in */
            $user = $check_user->fetch_assoc();
            /* signout if user logged-in */
            if($this->_logged_in) {
                $this->sign_out();
            }
            /* set cookies */
            $this->_set_cookies($user['user_id'], true);
            redirect();
        } else {
            /* user cloud be connecting his social account or signing-up */
            if($this->_logged_in) {
                /* [1] connecting social account */
                $db->query(sprintf("UPDATE users SET $social_connected = '1', $social_id = %s WHERE user_id = %s", secure($user_profile->identifier), secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
                redirect('/settings/linked');
            } else {
                /* [2] signup with social account */
                $_SESSION['social_id'] = $user_profile->identifier;
                $smarty->assign('provider', $provider);
                $smarty->assign('user_profile', $user_profile);
                $smarty->display("signup_social.tpl");
            }
        }
    }


    /**
     * socail_register
     * 
     * @param string $first_name
     * @param string $last_name
     * @param string $username
     * @param string $email
     * @param string $password
     * @param string $gender
     * @param boolean $privacy_agree
     * @param string $avatar
     * @param string $provider
     * @param string $invitation_code
     * @return void
     */
    public function socail_register($first_name, $last_name, $username, $email, $password, $gender, $privacy_agree, $avatar, $provider, $invitation_code = "") {
        global $db, $system, $date;
        switch ($provider) {
            case 'facebook':
                $social_id = "facebook_id";
                $social_connected = "facebook_connected";
                break;
            
            case 'twitter':
                $social_id = "twitter_id";
                $social_connected = "twitter_connected";
                break;

            case 'google':
                $social_id = "google_id";
                $social_connected = "google_connected";
                break;

            case 'instagram':
                $social_id = "instagram_id";
                $social_connected = "instagram_connected";
                break;

            case 'linkedin':
                $social_id = "linkedin_id";
                $social_connected = "linkedin_connected";
                break;

            case 'vkontakte':
                $social_id = "vkontakte_id";
                $social_connected = "vkontakte_connected";
                break;

            default:
                _error(400);
                break;
        }
        /* check invitation code */
        if(!$system['registration_enabled'] && $system['invitation_enabled']) {
            if(!$this->check_invitation_code($invitation_code)) {
                throw new Exception(__("The invitation code you entered is invalid or expired"));
            }
        }
        /* check IP */
        $this->_check_ip();
        if(is_empty($first_name) || is_empty($last_name) || is_empty($username) || is_empty($email) || is_empty($password)) {
            throw new Exception(__("You must fill in all of the fields"));
        }
        if(!valid_username($username)) {
            throw new Exception(__("Please enter a valid username (a-z0-9_.) with minimum 3 characters long"));
        }
        if(reserved_username($username)) {
            throw new Exception(__("You can't use")." <strong>".$username."</strong> ".__("as username"));
        }
        if($this->check_username($username)) {
            throw new Exception(__("Sorry, it looks like")." <strong>".$username."</strong> ".__("belongs to an existing account"));
        }
        if(!valid_email($email)) {
            throw new Exception(__("Please enter a valid email address"));
        }
        if($this->check_email($email)) {
            throw new Exception(__("Sorry, it looks like")." <strong>".$email."</strong> ".__("belongs to an existing account"));
        }
        if(strlen($password) < 6) {
            throw new Exception(__("Your password must be at least 6 characters long. Please try another"));
        }
        if(!valid_name($first_name)) {
            throw new Exception(__("Your first name contains invalid characters"));
        }
        if(strlen($first_name) < 3) {
            throw new Exception(__("Your first name must be at least 3 characters long. Please try another"));
        }
        if(!valid_name($last_name)) {
            throw new Exception(__("Your last name contains invalid characters"));
        }
        if(strlen($last_name) < 3) {
            throw new Exception(__("Your last name must be at least 3 characters long. Please try another"));
        }
        if(!in_array($gender, array('male', 'female', 'other'))) {
            throw new Exception(__("Please select a valid gender"));
        }
        /* check privacy agreement */
        if(!isset($privacy_agree)) {
            throw new Exception(__("You must read and agree to our terms and privacy policy"));
        }
        /* save avatar */
        $image_name = save_picture_from_file($avatar);
        /* register user */
        $db->query(sprintf("INSERT INTO users (user_name, user_email, user_password, user_firstname, user_lastname, user_gender, user_registered, user_activated, user_picture, $social_id, $social_connected) VALUES (%s, %s, %s, %s, %s, %s, %s, '1', %s, %s, '1')", secure($username), secure($email), secure(_password_hash($password)), secure(ucwords($first_name)), secure(ucwords($last_name)), secure($gender), secure($date), secure($image_name), secure($_SESSION['social_id']) )) or _error(SQL_ERROR_THROWEN);
        /* get user_id */
        $user_id = $db->insert_id;
        /* affiliates system */
        $this->process_affiliates("registration", $user_id);
        /* update invitation code */
        if(!$system['registration_enabled'] && $system['invitation_enabled']) {
            $this->update_invitation_code($invitation_code);
        }
        /* set cookies */
        $this->_set_cookies($user_id);
    }



    /* ------------------------------- */
    /* Two-Factor Authentication */
    /* ------------------------------- */

    /**
     * two_factor_authentication
     * 
     * @param string $two_factor_key
     * @param integer $user_id
     * @param boolean $remember
     * @return void
     */
    public function two_factor_authentication($two_factor_key, $user_id, $remember) {
        global $db, $system;
        if($system['two_factor_type'] == "google") {
            /* get user */
            $get_user = $db->query(sprintf("SELECT * FROM users WHERE user_id = %s", secure($user_id, 'int') )) or _error(SQL_ERROR_THROWEN);
            if($get_user->num_rows == 0) {
                _error(400);
            }
            $_user = $get_user->fetch_assoc();
            /* Google Authenticator */
            require_once(ABSPATH.'includes/libs/GoogleAuthenticator/GoogleAuthenticator.php');
            $ga = new PHPGangsta_GoogleAuthenticator();
            /* verify code */
            if(!$ga->verifyCode($_user['user_two_factor_gsecret'], $two_factor_key)) {
                throw new Exception(__("Invalid code, please try again"));
            }
        } else {
            /* check two-factor key */
            $check_key = $db->query(sprintf("SELECT * FROM users WHERE user_id = %s AND user_two_factor_key = %s", secure($user_id, 'int'), secure($two_factor_key) )) or _error(SQL_ERROR_THROWEN);
            if($check_key->num_rows == 0) {
                throw new Exception(__("Invalid code, please try again"));
            }
        }
        /* set cookies */
        $this->_set_cookies($user_id, $remember);
    }


    /**
     * disable_two_factor_authentication
     * 
     * @param integer $user_id
     * 
     * @return void
     */
    public function disable_two_factor_authentication($user_id) {
        global $db;
        $db->query(sprintf("UPDATE users SET user_two_factor_enabled = '0', user_two_factor_type = null, user_two_factor_key = null, user_two_factor_gsecret = null WHERE user_id = %s", secure($user_id, 'int') )) or _error(SQL_ERROR_THROWEN);
    }



    /* ------------------------------- */
    /* Fake Users Generator */
    /* ------------------------------- */

    /**
     * fake_users_generator
     * 
     * @param integer $users_num
     * @param string $default_password
     * @param boolean $random_Avatar
     * @param string $language
     * 
     * @return integer
     */
    public function fake_users_generator($users_num, $default_password, $random_Avatar, $language) {
        global $db, $system, $date;
        if(!is_numeric($users_num) || $users_num <= 0) {
            throw new Exception(__("You must enter valid number for how many users you want to generate"));
        }
        if($users_num > 1000) {
            throw new Exception(__("The maximum number of generated users is 1000 per request"));
        }
        /* default password */
        $default_password = ($default_password)? $default_password : "123456789";
        /* random Avatar */
        $random_Avatar = ($random_Avatar)? true : false;
        /* init Faker */
        require_once(ABSPATH.'includes/libs/Faker/autoload.php');
        $faker = Faker\Factory::create($language);
        /* random names & genders */
        //$names = array("ali", "amr", "mohamed", "ahmed", "mark");
        $genders = array('male', 'female');
        /* fake users generator */
        $generated = 0;
        while ($generated < $users_num) {
            $fake_username = strtolower(str_replace(".", "_", $faker->userName))."_".get_hash_key(4);
            $fake_email = $fake_username."@".$_SERVER['HTTP_HOST'];
            $fake_gender = $genders[array_rand($genders)];
            $fake_firstname = $faker->firstName($fake_gender);
            $fake_lastname = $faker->lastName;
            $fake_avatar = ($random_Avatar)? save_picture_from_file($faker->imageUrl()) : 'null';
            /* register user */
            $query = $db->query(sprintf("INSERT INTO users (user_name, user_email, user_password, user_firstname, user_lastname, user_gender, user_registered, user_activated, user_picture) VALUES (%s, %s, %s, %s, %s, %s, %s, '1', %s)", secure($fake_username), secure($fake_email), secure(_password_hash($default_password)), secure(ucwords($fake_firstname)), secure(ucwords($fake_lastname)), secure($fake_gender), secure($date), secure($fake_avatar) ));
            if(!$query) continue;
            $generated++;
        }
        return $generated;
    }



    /* ------------------------------- */
    /* Invitations */
    /* ------------------------------- */

    /**
     * get_invitation_code
     * 
     * @return string
     */
    public function get_invitation_code() {
        global $db, $system, $date;
        if(!$system['invitation_enabled']) {
            throw new Exception(__("Please enable the invitations system first to get new invitation code"));
        }
        $code = get_hash_key();
        $db->query(sprintf("INSERT INTO invitation_codes (code, date) VALUES (%s, %s)", secure($code), secure($date) )) or _error(SQL_ERROR_THROWEN);
        return $code;
    }


    /**
     * check_invitation_code
     * 
     * @param string $code
     * @return boolean
     * 
     */
    public function check_invitation_code($code) {
        global $db;
        $query = $db->query(sprintf("SELECT * FROM invitation_codes WHERE code = %s AND valid = '1'", secure($code) )) or _error(SQL_ERROR_THROWEN);
        if($query->num_rows > 0) {
            return true;
        }
        return false;
    }


    /**
     * update_invitation_code
     * 
     * @param string $code
     * @return void
     */
    public function update_invitation_code($code) {
        global $db;
        $db->query(sprintf("UPDATE invitation_codes SET valid = '0' WHERE code = %s", secure($code) )) or _error(SQL_ERROR_THROWEN);
    }


    /**
     * send_invitation_code
     * 
     * @param string $code
     * @param string $email
     * @return void
     */
    public function send_invitation_code($code, $email) {
        global $db, $system;
        /* check invitation code */
        if(!$this->check_invitation_code($code)) {
            throw new Exception(__("This invitation code is expired"));
        }
        /* check email */
        if(!valid_email($email)) {
            throw new Exception(__("Please enter a valid email address"));
        }
        if($this->check_email($email)) {
            throw new Exception(__("Sorry, it looks like")." <strong>".$email."</strong> ".__("belongs to an existing account"));
        }
        /* prepare invitation email */
        $subject = __("Invitation to join")." ".$system['system_title'];
        $body  = __("Hi").",";
        $body .= "\r\n\r\n".__("We happy to invite you to our website")." ".$system['system_title'];
        $body .= "\r\n\r\n".__("To complete the registration process, please follow this link:");
        $body .= "\r\n\r\n".$system['system_url']."/signup/";
        $body .= "\r\n\r\n".__("Your invitation code").": ".$code;
        $body .= "\r\n\r".$system['system_title']." ".__("Team");
        /* send email */
        if(!_email($email, $subject, $body)) {
            throw new Exception(__("Invitation email could not be sent"));
        }
    }



    /* ------------------------------- */
    /* Password */
    /* ------------------------------- */

    /**
     * forget_password
     * 
     * @param string $email
     * @param string $recaptcha_response
     * @return void
     */
    public function forget_password($email, $recaptcha_response) {
        global $db, $system;
        if(!valid_email($email)) {
            throw new Exception(__("Please enter a valid email address"));
        }
        if(!$this->check_email($email)) {
            throw new Exception(__("Sorry, it looks like")." ".$email." ".__("doesn't belong to any account"));
        }
        /* check reCAPTCHA */
        if($system['reCAPTCHA_enabled']) {
            require_once(ABSPATH.'includes/libs/ReCaptcha/autoload.php');
            $recaptcha = new \ReCaptcha\ReCaptcha($system['reCAPTCHA_secret_key']);
            $resp = $recaptcha->verify($recaptcha_response, get_user_ip());
            if (!$resp->isSuccess()) {
                throw new Exception(__("The secuirty check is incorrect. Please try again"));
            }
        }
        /* generate reset key */
        $reset_key = get_hash_key(6);
        /* update user */
        $db->query(sprintf("UPDATE users SET user_reset_key = %s, user_reseted = '1' WHERE user_email = %s", secure($reset_key), secure($email) )) or _error(SQL_ERROR_THROWEN);
        /* send reset email */
        /* prepare reset email */
        $subject = __("Forget password activation key!");
        $body  = __("Hi")." ".$email.",";
        $body .= "\r\n\r\n".__("To complete the reset password process, please copy this token:");
        $body .= "\r\n\r\n".__("Token:")." ".$reset_key;
        $body .= "\r\n\r".$system['system_title']." ".__("Team");
        /* send email */
        if(!_email($email, $subject, $body)) {
            throw new Exception(__("Activation key email could not be sent!"));
        }
    }


    /**
     * forget_password_confirm
     * 
     * @param string $email
     * @param string $reset_key
     * @return void
     */
    public function forget_password_confirm($email, $reset_key) {
        global $db;
        if(!valid_email($email)) {
            throw new Exception(__("Invalid email, please try again"));
        }
        /* check reset key */
        $check_key = $db->query(sprintf("SELECT user_reset_key FROM users WHERE user_email = %s AND user_reset_key = %s AND user_reseted = '1'", secure($email), secure($reset_key))) or _error(SQL_ERROR_THROWEN);
        if($check_key->num_rows == 0) {
            throw new Exception(__("Invalid code, please try again"));
        }
    }


    /**
     * forget_password_reset
     * 
     * @param string $email
     * @param string $reset_key
     * @param string $password
     * @param string $confirm
     * @return void
     */
    public function forget_password_reset($email, $reset_key, $password, $confirm) {
        global $db;
        if(!valid_email($email)) {
            throw new Exception(__("Invalid email, please try again"));
        }
        /* check reset key */
        $check_key = $db->query(sprintf("SELECT user_reset_key FROM users WHERE user_email = %s AND user_reset_key = %s AND user_reseted = '1'", secure($email), secure($reset_key))) or _error(SQL_ERROR_THROWEN);
        if($check_key->num_rows == 0) {
            throw new Exception(__("Invalid code, please try again"));
        }
        /* check password length */
        if(strlen($password) < 6) {
            throw new Exception(__("Your password must be at least 6 characters long. Please try another"));
        }
        /* check password confirm */
        if($password !== $confirm) {
            throw new Exception(__("Your passwords do not match. Please try another"));
        }
        /* update user password */
        $db->query(sprintf("UPDATE users SET user_password = %s, user_reseted = '0' WHERE user_email = %s", secure(_password_hash($password)), secure($email) )) or _error(SQL_ERROR_THROWEN);
    }



    /* ------------------------------- */
    /* Activation Email */
    /* ------------------------------- */

    /**
     * activation_email_resend
     * 
     * @return void
     */
    public function activation_email_resend() {
        global $db, $system;
        /* generate email verification code */
        $email_verification_code = get_hash_token();
        /* update user */
        $db->query(sprintf("UPDATE users SET user_email_verification_code = %s WHERE user_id = %s", secure($email_verification_code), secure($this->_data['user_id']) )) or _error(SQL_ERROR_THROWEN);
        /* prepare activation email */
        $subject = __("Just one more step to get started on")." ".$system['system_title'];
        $body  = __("Hi")." ".ucwords($this->_data['user_firstname']." ".$this->_data['user_lastname']).",";
        $body .= "\r\n\r\n".__("To complete the activation process, please follow this link:");
        $body .= "\r\n\r\n".$system['system_url']."/activation/".$this->_data['user_id']."/".$email_verification_code;
        $body .= "\r\n\r\n".__("Welcome to")." ".$system['system_title'];
        $body .= "\r\n\r".$system['system_title']." ".__("Team");
        /* send email */
        if(!_email($this->_data['user_email'], $subject, $body)) {
            throw new Exception(__("Activation email could not be sent"));
        }
    }


    /**
     * activation_email_reset
     * 
     * @param string $email
     * @return void
     */
    public function activation_email_reset($email) {
        global $db, $system;
        if(!valid_email($email)) {
            throw new Exception(__("Please enter a valid email address"));
        }
        if($this->check_email($email)) {
            throw new Exception(__("Sorry, it looks like")." <strong>".$email."</strong> ".__("belongs to an existing account"));
        }
        /* generate email verification code */
        $email_verification_code = get_hash_token();
        /* check if activation via email enabled */
        if($system['activation_enabled'] && $system['activation_type'] == "email") {
            /* update user (not activated) */
            $db->query(sprintf("UPDATE users SET user_email = %s, user_email_verified = '0', user_email_verification_code = %s, user_activated = '0' WHERE user_id = %s", secure($email), secure($email_verification_code), secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
        } else {
            /* update user */
            $db->query(sprintf("UPDATE users SET user_email = %s, user_email_verified = '0', user_email_verification_code = %s WHERE user_id = %s", secure($email), secure($email_verification_code), secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
        }
        /* prepare activation email */
        $subject = __("Just one more step to get started on")." ".$system['system_title'];
        $body  = __("Hi")." ".ucwords($this->_data['user_firstname']." ".$this->_data['user_lastname']).",";
        $body .= "\r\n\r\n".__("To complete the activation process, please follow this link:");
        $body .= "\r\n\r\n".$system['system_url']."/activation/".$this->_data['user_id']."/".$email_verification_code;
        $body .= "\r\n\r\n".__("Welcome to")." ".$system['system_title'];
        $body .= "\r\n\r".$system['system_title']." ".__("Team");
        /* send email */
        if(!_email($email, $subject, $body)) {
            throw new Exception(__("Activation email could not be sent"));
        }
    }


    /**
     * activation_email
     * 
     * @param integer $user_id
     * @param string $code
     * @return void
     */
    public function activation_email($user_id, $code) {
        global $db, $system;
        /* check & get the user */
        $check_user = $db->query(sprintf("SELECT * FROM users WHERE user_id = %s AND user_email_verification_code = %s", secure($user_id, 'int'), secure($code) )) or _error(SQL_ERROR_THROWEN);
        if($check_user->num_rows == 0) {
            _error(404);
        }
        $_user = $check_user->fetch_assoc();
        /* check if user [1] activate his account & verify his email or [2] just verify his email */
        if($system['activation_enabled'] && $system['activation_type'] == "email" && !$_user['user_activated']) {
            /* [1] activate his account & verify his email */
            $db->query(sprintf("UPDATE users SET user_activated = '1', user_email_verified = '1' WHERE user_id = %s", secure($_user['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
            /* affiliates system */
            $this->process_affiliates("registration", $_user['user_id'], $_user['user_referrer_id']);
        } else {
            /* [2] just verify his email */
            $db->query(sprintf("UPDATE users SET user_email_verified = '1' WHERE user_id = %s", secure($_user['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
        }
        if($this->_logged_in) {
            /* redirect */
            redirect();
        } else {
            /* set cookies */
            $this->_set_cookies($_user['user_id']);
        }
    }



    /* ------------------------------- */
    /* Activation Phone */
    /* ------------------------------- */

    /**
     * activation_phone_resend
     * 
     * @return void
     */
    public function activation_phone_resend() {
        global $db, $system;
        /* generate phone verification code */
        $phone_verification_code = get_hash_key();
        /* update user */
        $db->query(sprintf("UPDATE users SET user_phone_verification_code = %s WHERE user_id = %s", secure($phone_verification_code), secure($this->_data['user_id']) )) or _error(SQL_ERROR_THROWEN);
        /* prepare activation SMS */
        $message  = $system['system_title']." ".__("Activation Code").": ".$phone_verification_code;
        /* send SMS */
        if(!sms_send($this->_data['user_phone'], $message)) {
            throw new Exception(__("Activation SMS could not be sent"));
        }
    }


    /**
     * activation_phone_reset
     * 
     * @param string $phone
     * @return void
     */
    public function activation_phone_reset($phone) {
        global $db, $system;
        if(is_empty($phone)) {
            throw new Exception(__("Please enter a valid phone number"));
        }
        if($this->check_phone($phone)) {
            throw new Exception(__("Sorry, it looks like")." <strong>".$phone."</strong> ".__("belongs to an existing account"));
        }
        /* generate phone verification code */
        $phone_verification_code = get_hash_key();
        /* check if activation via sms enabled */
        if($system['activation_enabled'] && $system['activation_type'] == "sms") {
            /* update user (not activated) */
            $db->query(sprintf("UPDATE users SET user_phone = %s, user_phone_verified = '0', user_phone_verification_code = %s, user_activated = '0' WHERE user_id = %s", secure($phone), secure($phone_verification_code), secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
        } else {
            /* update user */
            $db->query(sprintf("UPDATE users SET user_phone = %s, user_phone_verified = '0', user_phone_verification_code = %s WHERE user_id = %s", secure($phone), secure($phone_verification_code), secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
        }
        /* prepare activation SMS */
        $message  = $system['system_title']." ".__("Activation Code").": ".$phone_verification_code;
        /* send SMS */
        if(!sms_send($phone, $message)) {
            throw new Exception(__("Activation SMS could not be sent"));
        }
    }


    /**
     * activation_phone
     * 
     * @param string $code
     * @return void
     */
    public function activation_phone($code) {
        global $db, $system;
        if(is_empty($code)) {
            throw new Exception(__("Invalid code, please try again"));
        }
        /* check the verification code */
        if($this->_data['user_phone_verification_code'] != $code) {
            throw new Exception(__("Invalid code, please try again"));
        }
        /* check if user [1] activate his account & his phone or [2] just verify his phone */
        if($system['activation_enabled'] && $system['activation_type'] == "sms" && !$this->_data['user_activated']) {
            /* [1] activate his account & his phone */
            $db->query(sprintf("UPDATE users SET user_activated = '1', user_phone_verified = '1' WHERE user_id = %s", secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
            /* affiliates system */
            $this->process_affiliates("registration", $this->_data['user_id'], $this->_data['user_referrer_id']);
        } else {
            /* [2] just verify his phone */
            /* check if phone already verified */
            if($this->_data['user_phone_verified']) {
                modal(SUCCESS, __("Verified"), __("Your phone already verified"));
            }
            $db->query(sprintf("UPDATE users SET user_phone_verified = '1' WHERE user_id = %s", secure($this->_data['user_id'], 'int') )) or _error(SQL_ERROR_THROWEN);
        }
    }



    /* ------------------------------- */
    /* Security Checks */
    /* ------------------------------- */
    
    /**
     * check_email
     * 
     * @param string $email
     * @param boolean $return_info
     * @return boolean|array
     * 
     */
    public function check_email($email, $return_info = false) {
        global $db;
        $query = $db->query(sprintf("SELECT * FROM users WHERE user_email = %s", secure($email) )) or _error(SQL_ERROR_THROWEN);
        if($query->num_rows > 0) {
            if($return_info) {
                $info = $query->fetch_assoc();
                return $info;
            }
            return true;
        }
        return false;
    }


    /**
     * check_phone
     * 
     * @param string $phone
     * @return boolean
     * 
     */
    public function check_phone($phone) {
        global $db;
        $query = $db->query(sprintf("SELECT * FROM users WHERE user_phone = %s", secure($phone) )) or _error(SQL_ERROR_THROWEN);
        if($query->num_rows > 0) {
            return true;
        }
        return false;
    }


    /**
     * check_username
     * 
     * @param string $username
     * @param string $type
     * @param boolean $return_info
     * @return boolean|array
     */
    public function check_username($username, $type = 'user', $return_info = false) {
        global $db;
        /* check type (user|page|group) */
        switch ($type) {
            case 'page':
                $query = $db->query(sprintf("SELECT * FROM pages WHERE page_name = %s", secure($username) )) or _error(SQL_ERROR_THROWEN);
                break;

            case 'group':
                $query = $db->query(sprintf("SELECT * FROM groups WHERE group_name = %s", secure($username) )) or _error(SQL_ERROR_THROWEN);
                break;
            
            default:
                $query = $db->query(sprintf("SELECT * FROM users WHERE user_name = %s", secure($username) )) or _error(SQL_ERROR_THROWEN);
                break;
        }
        if($query->num_rows > 0) {
            if($return_info) {
                $info = $query->fetch_assoc();
                return $info;
            }
            return true;
        }
        return false;
    }
    
}

?>