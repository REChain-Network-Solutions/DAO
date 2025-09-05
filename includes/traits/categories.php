<?php

/**
 * trait -> categories
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich - Handles - @sorydima @sorydev @durovshater @DmitrySoro90935 @tanechfund - also check https://dmitry.rechain.network for more information!
 */

trait CategoriesTrait
{

  /* ------------------------------- */
  /* Categories */
  /* ------------------------------- */

  /**
   * get_categories
   * 
   * @param string $table_name
   * @param integer $category_id
   * @param boolean $reverse
   * @param boolean $only_parents
   * @return array
   */
  public function get_categories($table_name, $category_id = 0, $reverse = false, $only_parents = false)
  {
    global $db;
    $tree = [];
    if (!$reverse) {
      // top-down tree (default)
      $get_categories = $db->query(sprintf("SELECT * FROM %s WHERE category_parent_id = %s ORDER BY category_order ASC", $table_name, secure($category_id, 'int')));
      if ($get_categories->num_rows > 0) {
        while ($category = $get_categories->fetch_assoc()) {
          $category['iteration'] = 0;
          $category['category_url'] = get_url_text($category['category_name']);
          $category['category_name'] = html_entity_decode($category['category_name'], ENT_QUOTES);
          if (!$only_parents) {
            $sub_categories = $this->get_sub_categories($table_name, $category['category_id']);
            if ($sub_categories) {
              $category['sub_categories'] = $sub_categories['sub_categories'];
            }
          }
          $tree[] = $category;
        }
      }
    } else {
      // bottom-up tree
      while (true) {
        $get_parent = $db->query(sprintf("SELECT * FROM %s WHERE category_id = %s", $table_name, secure($category_id, 'int')));
        if ($get_parent->num_rows == 0) {
          break;
        }
        $parent = $get_parent->fetch_assoc();
        $category['iteration'] = 0;
        $parent['category_url'] = get_url_text($category['category_name']);
        $category_id = $parent['category_parent_id'];
        $tree[] = $parent;
        if ($category_id == 0) {
          break;
        }
      }
    }
    return $tree;
  }


  /**
   * get_sub_categories
   * 
   * @param string $table_name
   * @param integer $category_id
   * @param integer $iteration
   * @return array
   */
  public function get_sub_categories($table_name, $category_id, $iteration = 1)
  {
    global $db;
    $tree = [];
    $get_categories = $db->query(sprintf("SELECT * FROM %s WHERE category_parent_id = %s ORDER BY category_order ASC", $table_name, secure($category_id)));
    if ($get_categories->num_rows > 0) {
      while ($category = $get_categories->fetch_assoc()) {
        $category['iteration'] = $iteration;
        $category['category_url'] = get_url_text($category['category_name']);
        $category['category_name'] = html_entity_decode($category['category_name'], ENT_QUOTES);
        $sub_categories = $this->get_sub_categories($table_name, $category['category_id'], $iteration + 1);
        if ($sub_categories) {
          $category['sub_categories'] = $sub_categories['sub_categories'];
        }
        $tree['sub_categories'][] = $category;
      }
    }
    return $tree;
  }


  /**
   * get_category
   * 
   * @param string $table_name
   * @param integer $category_id
   * @param boolean $get_parent
   * @return array
   */
  public function get_category($table_name, $category_id, $get_parent = false)
  {
    global $db;
    $get_category = $db->query(sprintf("SELECT * FROM %s WHERE category_id = %s", $table_name, secure($category_id, 'int')));
    if ($get_category->num_rows == 0) {
      return false;
    }
    $category = $get_category->fetch_assoc();
    $category['category_url'] = get_url_text($category['category_name']);
    $category['category_name'] = html_entity_decode($category['category_name'], ENT_QUOTES);
    /* get parent category */
    if ($get_parent && $category['category_parent_id']) {
      $category['parent'] = $this->get_category($table_name, $category['category_parent_id']);
    }
    /* check sub_categories */
    $check_sub_categories = $db->query(sprintf("SELECT COUNT(*) as count FROM %s WHERE category_parent_id = %s", $table_name, secure($category_id, 'int')));
    $category['sub_categories'] = ($check_sub_categories->fetch_assoc()['count'] > 0) ? true : false;
    return $category;
  }


  /**
   * delete_category
   * 
   * @param string $table_name
   * @param integer $category_id
   * @return void
   */
  public function delete_category($table_name, $category_id)
  {
    global $db;
    $db->query(sprintf("DELETE FROM %s WHERE category_id = %s", $table_name, secure($category_id, 'int')));
    $get_sub_categories = $db->query(sprintf("SELECT category_id FROM %s WHERE category_parent_id = %s", $table_name, secure($category_id)));
    if ($get_sub_categories->num_rows > 0) {
      while ($sub_category = $get_sub_categories->fetch_assoc()) {
        $this->delete_category($table_name, $sub_category['category_id']);
      }
    }
  }


  /**
   * check_category
   * 
   * @param string $table_name
   * @param integer $category_id
   * @return boolean
   */
  public function check_category($table_name, $category_id)
  {
    global $db;
    $check = $db->query(sprintf("SELECT COUNT(*) as count FROM %s WHERE category_id = %s", $table_name, secure($category_id, 'int')));
    if ($check->fetch_assoc()['count'] > 0) {
      return true;
    }
    return false;
  }
}
