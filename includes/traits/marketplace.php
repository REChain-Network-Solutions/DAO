<?php

/**
 * trait -> marketplace
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich
 */

trait MarketplaceTrait
{

  /* ------------------------------- */
  /* Marketplace */
  /* ------------------------------- */

  /**
   * get_cart
   * 
   * @return array
   */
  public function get_cart()
  {
    global $db;
    $cart = [];
    $cart['items'] = [];
    $cart['total'] = 0;
    $get_cart = $db->query(sprintf("SELECT * FROM shopping_cart WHERE user_id = %s", secure($this->_data['user_id'], 'int'))) or _error("SQL_ERROR_THROWEN");
    if ($get_cart->num_rows > 0) {
      while ($cart_item = $get_cart->fetch_assoc()) {
        $cart_item['post'] = $this->get_post($cart_item['product_post_id']);
        if (!$cart_item['post']) continue;
        $cart['total'] += $cart_item['post']['product']['price'] * $cart_item['quantity'];
        $cart['items'][] = $cart_item;
      }
    }
    return $cart;
  }


  /**
   * checkout_cart
   * 
   * @param int $shipping_address
   * @return array
   */
  public function checkout_cart($shipping_address)
  {
    global $db, $system, $date;
    /* check if market enabled */
    if (!$system['market_enabled']) {
      throw new AuthorizationException(__("The market module has been disabled by the admin"));
    }
    /* check if this shipping address belongs to the user */
    $check_address = $db->query(sprintf("SELECT COUNT(*) AS count FROM users_addresses WHERE address_id = %s AND user_id = %s", secure($shipping_address, 'int'), secure($this->_data['user_id'], 'int'))) or _error("SQL_ERROR_THROWEN");
    if ($check_address->fetch_assoc()['count'] == 0) {
      throw new AuthorizationException(__("You are not authorized to do this action"));
    }
    /* get cart */
    $cart = $this->get_cart();
    /* check if cart is empty */
    if (count($cart['items']) == 0) {
      throw new ValidationException(__("Your cart is empty"));
    }
    /* checkout */
    $orders = [];
    foreach ($cart['items'] as $cart_item) {
      /* check if the product is still available */
      if ($cart_item['post']['product']['quantity'] < $cart_item['quantity']) {
        throw new ValidationException(__("The product %s is not available anymore", $cart_item['post']['product']['name']));
      }
      /* notify the seller if the product quantity is 0 */
      if ($cart_item['post']['product']['quantity'] - $cart_item['quantity'] <= 0) {
        $this->post_notification(['to_user_id' => $cart_item['post']['author_id'], 'action' => 'market_outofstock', 'node_url' => $cart_item['post']['post_id']]);
      }
      /* check if the item is digital product */
      $is_digital = $cart_item['post']['product']['is_digital'];
      $order_hash = get_hash_number();
      $order_index = ($is_digital) ? $order_hash : $cart_item['post']['author_id'];
      /* check if there is already an order for this seller */
      if (isset($orders[$order_index])) {
        /* get order id */
        $order_id = $orders[$order_index]['order_id'];
      } else {
        /* check if the post author is [user || page] */
        if ($cart_item['post']['user_type'] == "user") {
          $seller_id = $cart_item['post']['author_id'];
          $seller_page_id = 0;
        } else {
          $seller_id = $cart_item['post']['page_admin'];
          $seller_page_id = $cart_item['post']['page_id'];
        }
        /* create new order */
        $db->query(sprintf("INSERT INTO orders (order_hash, is_digital, seller_id, seller_page_id, buyer_id, buyer_address_id, commission, insert_time, update_time) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)", secure($order_hash), secure($is_digital), secure($seller_id, 'int'), secure($seller_page_id, 'int'), secure($this->_data['user_id'], 'int'), secure($shipping_address, 'int'), secure($system['market_commission'], 'float'), secure($date), secure($date))) or _error("SQL_ERROR_THROWEN");
        /* get order id */
        $order_id = $db->insert_id;
        /* add order to the orders array */
        $orders[$order_index]['order_id'] = $order_id;
        $orders[$order_index]['order_hash'] = $order_hash;
        $orders[$order_index]['is_digital'] = $is_digital;
        $orders[$order_index]['seller_id'] = $cart_item['post']['author_id'];
      }
      /* add order items */
      $db->query(sprintf("INSERT INTO orders_items (order_id, product_post_id, quantity, price) VALUES (%s, %s, %s, %s)", secure($order_id, 'int'), secure($cart_item['product_post_id'], 'int'), secure($cart_item['quantity'], 'int'), secure($cart_item['post']['product']['price'], 'float'))) or _error("SQL_ERROR_THROWEN");
      /* update order sub total */
      $item_total_price = $cart_item['post']['product']['price'] * $cart_item['quantity'];
      $orders[$order_index]['sub_total'] += $item_total_price;
    }
    /* create new orders collection unique id */
    $orders_collection_id = uniqid();
    /* loop through orders */
    foreach ($orders as $order) {
      /* update order sub total */
      $db->query(sprintf("UPDATE orders SET order_collection_id = %s, sub_total = %s WHERE order_id = %s", secure($orders_collection_id), secure($order['sub_total'], 'float'), secure($order['order_id'], 'int'))) or _error("SQL_ERROR_THROWEN");
    }
    /* empty the cart */
    $db->query(sprintf("DELETE FROM shopping_cart WHERE user_id = %s", secure($this->_data['user_id'], 'int'))) or _error("SQL_ERROR_THROWEN");
    /* return order_collection_id & total_price */
    return ['orders_collection_id' => $orders_collection_id, 'total' => $cart['total']];
  }


  /**
   * get_orders_collection
   * 
   * @param string $orders_collection_id
   * @return array|boolean
   */
  public function get_orders_collection($orders_collection_id)
  {
    global $db;
    $order_collection['paid'] = false;
    $order_collection['total'] = 0;
    $order_collection['orders'] = [];
    $get_orders = $db->query(sprintf("SELECT * FROM orders WHERE order_collection_id = %s", secure($orders_collection_id))) or _error("SQL_ERROR_THROWEN");
    if ($get_orders->num_rows > 0) {
      while ($order = $get_orders->fetch_assoc()) {
        if ($order['is_payment_done']) {
          $order_collection['paid'] = true;
          break;
        }
        $order_collection['total'] += $order['sub_total'];
        $order_collection['orders'][] = $order;
      }
      /* check if any of the orders contains is_digital -> can't use cod */
      $can_use_cod = true;
      foreach ($order_collection['orders'] as $order) {
        if ($order['is_digital']) {
          $can_use_cod = false;
          break;
        }
      }
      $order_collection['can_use_cod'] = $can_use_cod;
      return $order_collection;
    }
    return false;
  }


  /**
   * mark_orders_collection_as_paid
   * 
   * @param string $orders_collection_id
   * @param boolean $cash_on_delivery
   * @return void
   */
  public function mark_orders_collection_as_paid($orders_collection_id, $cash_on_delivery = false)
  {
    global $db;
    $get_orders = $db->query(sprintf("SELECT * FROM orders WHERE order_collection_id = %s", secure($orders_collection_id))) or _error("SQL_ERROR_THROWEN");
    if ($get_orders->num_rows > 0) {
      while ($order = $get_orders->fetch_assoc()) {
        /* update product quantity */
        $get_order_items = $db->query(sprintf("SELECT * FROM orders_items WHERE order_id = %s", secure($order['order_id'], 'int'))) or _error("SQL_ERROR_THROWEN");
        while ($order_item = $get_order_items->fetch_assoc()) {
          $db->query(sprintf("UPDATE posts_products SET quantity = quantity - %s WHERE post_id = %s", secure($order_item['quantity'], 'int'), secure($order_item['product_post_id'], 'int'))) or _error("SQL_ERROR_THROWEN");
        }
        /* send notification to the seller */
        $this->post_notification(['to_user_id' => $order['seller_id'], 'action' => 'market_order', 'node_url' => $order['order_hash']]);
        /* check if digital order -> update order as delivered */
        if ($order['is_digital']) {
          $this->update_order($order['order_id'], 'delivered', '', '', true);
        }
        /* update order as paid */
        $cash_on_delivery = ($cash_on_delivery) ? '1' : '0';
        $db->query(sprintf("UPDATE orders SET is_payment_done = '1', is_cash_on_delivery = %s WHERE order_id = %s", secure($cash_on_delivery), secure($order['order_id'], 'int'))) or _error("SQL_ERROR_THROWEN");
      }
    }
  }


  /**
   * add_to_cart
   * 
   * @param int $post_id
   * @return void
   */
  public function add_to_cart($post_id)
  {
    global $db, $system;
    /* check if market enabled */
    if (!$system['market_enabled']) {
      throw new AuthorizationException(__("The market module has been disabled by the admin"));
    }
    /* check if the post is a product */
    $check_product = $db->query(sprintf("SELECT COUNT(*) AS count FROM posts WHERE post_id = %s AND post_type = 'product'", secure($post_id, 'int'))) or _error("SQL_ERROR_THROWEN");
    if ($check_product->fetch_assoc()['count'] == 0) {
      throw new ValidationException(__("This is not a product"));
    }
    /* check if the product is already in the cart */
    $check_cart = $db->query(sprintf("SELECT COUNT(*) AS count FROM shopping_cart WHERE user_id = %s AND product_post_id = %s", secure($this->_data['user_id'], 'int'), secure($post_id, 'int'))) or _error("SQL_ERROR_THROWEN");
    if ($check_cart->fetch_assoc()['count'] > 0) {
      return;
    }
    /* add to cart */
    $db->query(sprintf("INSERT INTO shopping_cart (user_id, product_post_id) VALUES (%s, %s)", secure($this->_data['user_id'], 'int'), secure($post_id, 'int'))) or _error("SQL_ERROR_THROWEN");
  }


  /**
   * update_cart
   * 
   * @param int $post_id
   * @param int $quantity
   * @return void
   */
  public function update_cart($post_id, $quantity)
  {
    global $db;
    /* check if the product is already in the cart */
    $check_cart = $db->query(sprintf("SELECT COUNT(*) AS count FROM shopping_cart WHERE user_id = %s AND product_post_id = %s", secure($this->_data['user_id'], 'int'), secure($post_id, 'int'))) or _error("SQL_ERROR_THROWEN");
    if ($check_cart->fetch_assoc()['count'] == 0) {
      throw new ValidationException(__("This product is not in the cart"));
    }
    /* check if the quantity is valid */
    if ($quantity <= 0) {
      throw new ValidationException(__("Invalid quantity"));
    }
    /* get the product */
    $product = $this->get_post($post_id);
    if (!$product) {
      throw new ValidationException(__("This product is not exists"));
    }
    /* check if the quantity is available */
    if ($quantity > $product['product']['quantity']) {
      throw new ValidationException(__("The quantity you entered is not available"));
    }
    /* update cart */
    $db->query(sprintf("UPDATE shopping_cart SET quantity = %s WHERE user_id = %s AND product_post_id = %s", secure($quantity, 'int'), secure($this->_data['user_id'], 'int'), secure($post_id, 'int'))) or _error("SQL_ERROR_THROWEN");
  }


  /**
   * remove_from_cart
   * 
   * @param int $post_id
   * @return void
   */
  public function remove_from_cart($post_id)
  {
    global $db;
    $db->query(sprintf("DELETE FROM shopping_cart WHERE user_id = %s AND product_post_id = %s", secure($this->_data['user_id'], 'int'), secure($post_id, 'int'))) or _error("SQL_ERROR_THROWEN");
  }


  /**
   * get_orders
   * 
   * @param array $args
   * @return array
   */
  public function get_orders($args = [])
  {
    global $db, $system;
    $orders = [];
    $sales_orders = (isset($args['sales_orders']) && $args['sales_orders']) ? true : false;
    $offset = (isset($args['offset'])) ? $args['offset'] : 0;
    $query = (isset($args['query'])) ? $args['query'] : false;
    /* prepare query */
    $offset *= $system['max_results'];
    $where_query = ($sales_orders) ? sprintf("seller_id = %s", secure($this->_data['user_id'], 'int')) : sprintf("buyer_id = %s", secure($this->_data['user_id'], 'int'));
    if ($query) {
      $where_query .= sprintf(" AND order_hash LIKE %s", secure($query, 'search'));
    }
    $limit_statement = sprintf("LIMIT %s, %s", secure($offset, 'int', false), secure($system['max_results'], 'int', false));
    $get_orders = $db->query("SELECT orders.*, users_addresses.*, users.user_name, users.user_firstname, users.user_lastname FROM orders INNER JOIN users_addresses ON orders.buyer_address_id = users_addresses.address_id INNER JOIN users ON orders.buyer_id = users.user_id WHERE $where_query AND orders.is_payment_done = '1' ORDER BY orders.order_id DESC " . $limit_statement) or _error("SQL_ERROR_THROWEN");
    if ($get_orders->num_rows > 0) {
      $order['items'] = [];
      $order['total_commission'] = 0;
      $order['final_price'] = 0;
      while ($order = $get_orders->fetch_assoc()) {
        /* prepare buyer's name */
        $order['buyer_fullname'] = ($system['show_usernames_enabled']) ? $order['user_name'] : $order['user_firstname'] . ' ' . $order['user_lastname'];
        /* prepare total commission */
        $order['total_commission'] = $order['sub_total'] * ($order['commission'] / 100);
        /* prepare final price */
        $order['final_price'] = $order['sub_total'] - $order['total_commission'];
        /* get order items */
        $get_order_items = $db->query(sprintf("SELECT * FROM orders_items WHERE order_id = %s", secure($order['order_id'], 'int'))) or _error("SQL_ERROR_THROWEN");
        while ($order_item = $get_order_items->fetch_assoc()) {
          $order_item['post'] = $this->get_post($order_item['product_post_id']);
          if (!$order_item['post']) continue;
          $order['items'][] = $order_item;
        }
        /* prepare order automatic delivery days */
        $last_update = new DateTime($order['update_time']);
        $now = new DateTime();
        $days_since_update = $now->diff($last_update)->days;
        $order['automatic_delivery_days'] = max(0, $system['market_delivery_days'] - $days_since_update);
        $orders[] = $order;
      }
    }
    return $orders;
  }


  /**
   * get_order
   * 
   * @param int $order_id
   * @param bool $for_invoice
   * @param bool $for_admin
   * @return array
   */
  public function get_order($order_id, $for_invoice = false, $for_admin = false)
  {
    global $db, $system;
    /* get order */
    if (!$for_admin) {
      $where_query = (!$for_invoice) ? "AND orders.status != 'canceled' AND orders.status != 'delivered'" : "";
      $where_query .= " AND (orders.seller_id = " . secure($this->_data['user_id'], 'int') . " OR orders.buyer_id = " . secure($this->_data['user_id'], 'int') . ") ";
      $where_query .= " AND orders.is_payment_done = '1' ";
    }
    $get_order = $db->query(sprintf("SELECT orders.*, users_addresses.*, users.user_name, users.user_firstname, users.user_lastname FROM orders INNER JOIN users_addresses ON orders.buyer_address_id = users_addresses.address_id INNER JOIN users ON orders.buyer_id = users.user_id WHERE orders.order_id = %s $where_query ", secure($order_id, 'int'))) or _error("SQL_ERROR_THROWEN");
    if ($get_order->num_rows == 0) {
      _error(400);
    }
    $order = $get_order->fetch_assoc();
    /* prepare buyer's name */
    $order['buyer_fullname'] = ($system['show_usernames_enabled']) ? $order['user_name'] : $order['user_firstname'] . ' ' . $order['user_lastname'];
    /* get seller info */
    if ($order['seller_page_id'] == 0) {
      $order['seller'] = $this->get_user($order['seller_id']);
      /* prepare seller's name */
      $order['seller_fullname'] = ($system['show_usernames_enabled']) ? $order['seller']['user_name'] : $order['seller']['user_firstname'] . ' ' . $order['seller']['user_lastname'];
    } else {
      $order['seller'] = $this->get_page($order['seller_page_id']);
      $order['seller_fullname'] = $order['seller']['page_title'];
    }
    /* prepare total commission */
    $order['total_commission'] = $order['sub_total'] * ($order['commission'] / 100);
    /* prepare final price */
    $order['final_price'] = $order['sub_total'] - $order['total_commission'];
    /* get order items */
    $get_order_items = $db->query(sprintf("SELECT * FROM orders_items WHERE order_id = %s", secure($order['order_id'], 'int'))) or _error("SQL_ERROR_THROWEN");
    while ($order_item = $get_order_items->fetch_assoc()) {
      $order_item['post'] = $this->get_post($order_item['product_post_id']);
      if (!$order_item['post']) continue;
      $order['items'][] = $order_item;
    }
    /* prepare order automatic delivery days */
    $last_update = new DateTime($order['update_time']);
    $now = new DateTime();
    $days_since_update = $now->diff($last_update)->days;
    $order['automatic_delivery_days'] = max(0, $system['market_delivery_days'] - $days_since_update);
    return $order;
  }


  /**
   * update_order
   * 
   * @param int $order_id
   * @param string $status
   * @param string $tracking_link
   * @param string $tracking_number
   * @param bool $for_admin
   * @return void
   */
  public function update_order($order_id, $status, $tracking_link = null, $tracking_number = null, $for_admin = false)
  {
    global $db, $system, $date;
    /* get order */
    $order = $this->get_order($order_id, false, $for_admin);
    $tracking_link = ($tracking_link) ? $tracking_link : $order['tracking_link'];
    $tracking_number = ($tracking_number) ? $tracking_number : $order['tracking_number'];
    /* update order */
    switch ($status) {
      case 'canceled':
        /* update product quantity */
        foreach ($order['items'] as $item) {
          $db->query(sprintf("UPDATE posts_products SET quantity = quantity + %s WHERE product_id = %s", secure($item['quantity'], 'int'), secure($item['post']['product']['product_id'], 'int'))) or _error("SQL_ERROR_THROWEN");
        }
        if (!$order['is_cash_on_delivery']) {
          /* update buyer's wallet balance */
          $db->query(sprintf("UPDATE users SET user_wallet_balance = user_wallet_balance + %s WHERE user_id = %s", secure($order['sub_total'], 'float'), secure($order['buyer_id'], 'int'))) or _error("SQL_ERROR_THROWEN");
          /* wallet transaction */
          $this->wallet_set_transaction($order['buyer_id'], 'market', 0, $order['sub_total'], 'in');
        }
        break;

      case 'delivered':
        /* check if the seller doing this action */
        if (!$for_admin && $order['seller_id'] == $this->_data['user_id']) {
          _error(400);
        }
        /* prepare commission */
        if (!$order['is_cash_on_delivery']) {
          $commission = ($system['market_commission']) ? $order['sub_total'] * ($system['market_commission'] / 100) : 0;
          $sub_total_after_commission = $order['sub_total'] - $commission;
          /* add to the seller's market balance */
          $db->query(sprintf("UPDATE users SET user_market_balance = user_market_balance + %s WHERE user_id = %s", secure($sub_total_after_commission, 'float'), secure($order['seller_id'], 'int'))) or _error("SQL_ERROR_THROWEN");
          /* log commission */
          $this->log_commission($order['seller_id'], $commission, 'market');
        }
        break;
    }
    $db->query(sprintf("UPDATE orders SET status = %s, tracking_link = %s, tracking_number = %s, update_time = %s WHERE order_id = %s", secure($status), secure($tracking_link), secure($tracking_number), secure($date), secure($order_id, 'int'))) or _error("SQL_ERROR_THROWEN");
    /* send notification to the buyer */
    if ($order['tracking_link'] != $tracking_link || $order['tracking_number'] != $tracking_number) {
      if ($order['seller_page_id'] == 0) {
        $this->post_notification(['to_user_id' => $order['buyer_id'], 'action' => 'market_order_tracking_updated', 'node_url' => $order['order_hash']]);
      } else {
        $this->post_notification(['from_user_id' => $order['seller_page_id'], 'from_user_type' => 'page', 'to_user_id' => $order['buyer_id'], 'action' => 'market_order_tracking_updated', 'node_url' => $order['order_hash']]);
      }
    }
    /* send notification to the buyer|seller */
    if ($order['status'] != $status) {
      if ($status == "delivered") {
        if ($for_admin) {
          /* to the seller */
          $this->post_notification(['to_user_id' => $order['seller_id'], 'system_notification' => true, 'action' => 'market_order_delivered_seller_system', 'node_url' => $order['order_hash']]);
          /* to the buyer */
          $this->post_notification(['to_user_id' => $order['buyer_id'], 'system_notification' => true, 'action' => 'market_order_delivered_buyer_system', 'node_url' => $order['order_hash']]);
        } else {
          /* to the seller */
          $this->post_notification(['to_user_id' => $order['seller_id'], 'action' => 'market_order_delivered', 'node_url' => $order['order_hash']]);
        }
      } else {
        /* to the buyer */
        if ($order['seller_page_id'] == 0) {
          $this->post_notification(['to_user_id' => $order['buyer_id'], 'action' => 'market_order_status_updated', 'node_url' => $order['order_hash']]);
        } else {
          $this->post_notification(['from_user_id' => $order['seller_page_id'], 'from_user_type' => 'page', 'to_user_id' => $order['buyer_id'], 'action' => 'market_order_status_updated', 'node_url' => $order['order_hash']]);
        }
      }
    }
  }


  /**
   * get_orders_count
   * 
   * @param bool $sales_orders
   * @return int
   */
  public function get_orders_count($sales_orders = false)
  {
    global $db;
    /* prepare query */
    $where_query = ($sales_orders) ? "seller_id = %s" : "buyer_id = %s";
    $get_orders = $db->query(sprintf("SELECT * FROM orders WHERE $where_query AND is_payment_done = '1'", secure($this->_data['user_id'], 'int'))) or _error("SQL_ERROR_THROWEN");
    return $get_orders->num_rows;
  }


  /**
   * get_seller_monthly_sales
   * 
   * @return int
   */
  public function get_seller_monthly_sales()
  {
    global $db;
    $get_sales = $db->query(sprintf("SELECT SUM(sub_total - sub_total * (commission/100)) AS total_sales FROM orders WHERE seller_id = %s AND insert_time >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH) AND status = 'delivered' AND is_payment_done = '1' AND is_cash_on_delivery = '0'", secure($this->_data['user_id'], 'int'))) or _error("SQL_ERROR_THROWEN");
    $sales = $get_sales->fetch_assoc();
    return $sales['total_sales'];
  }


  /**
   * get_user_products_count
   * 
   * @return int
   */
  public function get_user_products_count()
  {
    global $db;
    $get_products = $db->query(sprintf("SELECT COUNT(*) AS count FROM posts WHERE post_type = 'product' AND user_type = 'user' AND user_id = %s", secure($this->_data['user_id'], 'int'))) or _error("SQL_ERROR_THROWEN");
    return $get_products->fetch_assoc()['count'];
  }

  /**
   * deliver_undelivered_orders
   * 
   * @return void
   */
  public function deliver_undelivered_orders()
  {
    global $db, $system;
    /* get undelivered orders */
    $get_orders = $db->query(sprintf("SELECT order_id FROM orders WHERE `status` = 'shipped' AND update_time < NOW() - INTERVAL %s DAY", $system['market_delivery_days']));
    if ($get_orders->num_rows > 0) {
      while ($order = $get_orders->fetch_assoc()) {
        /* update order as delivered */
        $this->update_order($order['order_id'], 'delivered', null, null, true);
      }
    }
  }
}
