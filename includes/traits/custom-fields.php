<?php

/**
 * trait -> custom-fields
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich
 */

trait CustomFieldsTrait
{

  /* ------------------------------- */
  /* Custom Fields */
  /* ------------------------------- */

  /**
   * get_custom_fields
   * 
   * @param array $args
   * @return array
   */
  public function get_custom_fields($args = [])
  {
    global $db, $system;
    $fields = [];
    /* prepare "for" [user|page|group|event|product|job|offer|course] - default -> user */
    $args['for'] = (isset($args['for'])) ? $args['for'] : "user";
    if (!in_array($args['for'], ['user', 'page', 'group', 'event', 'product', 'job', 'offer', 'course'])) {
      throw new BadRequestException(__("Invalid field for"));
    }
    /* prepare "get" [registration|profile|settings|search] - default -> registration */
    $args['get'] = (isset($args['get'])) ? $args['get'] : "registration";
    if (!in_array($args['get'], ['registration', 'profile', 'settings', 'search'])) {
      throw new BadRequestException(__("Invalid field get"));
    }
    /* prepare where_query */
    $where_query = "WHERE field_for = '" . $args['for'] . "'";
    if ($args['get'] == "registration") {
      $where_query .= " AND in_registration = '1'";
    } elseif ($args['get'] == "profile") {
      $where_query .= " AND in_profile = '1'";
    } elseif ($args['get'] == "search") {
      $where_query .= " AND in_search = '1'";
    }
    $get_fields = $db->query("SELECT * FROM custom_fields " . $where_query . " ORDER BY field_order ASC");
    if ($get_fields->num_rows > 0) {
      while ($field = $get_fields->fetch_assoc()) {
        if ($field['type'] == "selectbox" || $field['type'] == "multipleselectbox") {
          $field['options'] = explode(PHP_EOL, $field['select_options']);
        }
        if ($args['get'] == "registration" || $args['get'] == "search") {
          /* no value neeeded */
          $fields[] = $field;
        } else {
          /* valid node_id */
          if (!isset($args['node_id'])) {
            throw new BadRequestException(__("Invalid node_id"));
          }
          /* get the custom field value */
          $get_field_value = $db->query(sprintf("SELECT value FROM custom_fields_values WHERE field_id = %s AND node_id = %s AND node_type = %s", secure($field['field_id'], 'int'), secure($args['node_id'], 'int'), secure($args['for'])));
          if ($get_field_value->num_rows > 0) {
            $field_value = $get_field_value->fetch_assoc()['value'];
            switch ($field['type']) {
              case 'selectbox':
                $field['value'] = $field['options'][$field_value];
                break;

              case 'multipleselectbox':
                $field['value'] = explode(",", $field_value);
                $field['value_string'] = [];
                foreach ($field['value'] as $value) {
                  if (isset($field['options'][$value])) {
                    $field['value_string'][] = $field['options'][$value];
                  }
                }
                $field['value_string'] = implode(", ", $field['value_string']);
                break;

              default:
                $field['value'] = nl2br($field_value);
                break;
            }
          }
          /* bypass profile fields if its value is empty */
          if ($args['get'] == "profile" && !$field['value']) {
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
   * @return void|array
   */
  public function set_custom_fields($input_fields, $for = "user", $set = "registration", $node_id = null)
  {
    global $db, $system;
    $custom_fields = [];
    /* prepare "for" [user|page|group|event|product|job|offer|course] - default -> user */
    if (!in_array($for, ['user', 'page', 'group', 'event', 'product', 'job', 'offer', 'course'])) {
      throw new BadRequestException(__("Invalid field for"));
    }
    /* prepare "set" [registration|settings] - default -> registration */
    if (!in_array($set, ['registration', 'settings'])) {
      throw new BadRequestException(__("Invalid field set"));
    }
    /* prepare where_query */
    $where_query = " AND field_for = '" . $for . "'";
    if ($set == "registration") {
      $where_query .= " AND in_registration = '1'";
    }
    /* get & set input_fields */
    $prefix = "fld_";
    $prefix_len = strlen($prefix);
    foreach ($input_fields as $key => $value) {
      if (strpos($key, $prefix) === false) {
        continue;
      }
      $field_id = substr($key, $prefix_len);
      $get_field = $db->query(sprintf("SELECT * FROM custom_fields WHERE field_id = %s" . $where_query, secure($field_id, 'int')));
      if ($get_field->num_rows == 0) {
        continue;
      }
      $field = $get_field->fetch_assoc();
      /* valid field */
      if ($field['mandatory']) {
        switch ($field['type']) {
          case 'selectbox':
            /* select box */
            if ($value == "none") {
              throw new ValidationException(__("You must select") . " " . __($field['label']));
            }
            break;

          case 'multipleselectbox':
            /* multiple select box */
            if (!is_array($value) || count($value) == 0) {
              throw new ValidationException(__("You must select at least one option from ") . " " . __($field['label']));
            }
            break;

          default:
            /* textbox || textarea */
            if (is_empty($value)) {
              throw new ValidationException(__("You must enter") . " " . __($field['label']));
            }
            break;
        }
      }
      if ($field['type'] == "textbox" || $field['type'] == "textarea") {
        if (strlen($value) > $field['length']) {
          throw new ValidationException(__("The maximum value for") . " " . __($field['label']) . " " . __("is") . " " . $field['length']);
        }
      }
      /* (insert|update) node custom fields */
      $value = ($field['type'] == "multipleselectbox") ? implode(",", $value) : $value;
      if ($set == "registration") {
        /* insert query */
        $custom_fields[$field['field_id']] = $value;
      } else {
        /* valid node_id */
        if ($node_id == null) {
          _error(400);
        }
        $check_value = $db->query(sprintf("SELECT * FROM custom_fields_values WHERE field_id = %s AND node_id = %s AND node_type = %s", secure($field['field_id'], 'int'), secure($node_id, 'int'), secure($for)));
        if ($check_value->num_rows > 0) {
          /* update if already exist */
          $db->query(sprintf("UPDATE custom_fields_values SET value = %s WHERE field_id = %s AND node_id = %s AND node_type = %s", secure($value), secure($field['field_id'], 'int'), secure($node_id, 'int'), secure($for)));
        } else {
          /* insert if not exist */
          $insert_field = $db->query(sprintf("INSERT INTO custom_fields_values (value, field_id, node_id, node_type) VALUES (%s, %s, %s, %s)", secure($value), secure($field['field_id'], 'int'), secure($node_id, 'int'), secure($for)));
        }
      }
    }
    if ($set == "registration") {
      return $custom_fields;
    }
    return;
  }


  /**
   * search_custom_fields
   * 
   * @param array $input_fields
   * @return string
   */
  public function search_custom_fields($input_fields)
  {
    global $db, $system;
    $query_statement = "";
    /* check input_fields */
    $prefix = "fld_";
    $prefix_len = strlen($prefix);
    foreach ($input_fields as $key => $value) {
      if (strpos($key, $prefix) === false) {
        continue;
      }
      $field_id = substr($key, $prefix_len);
      $get_field = $db->query(sprintf("SELECT * FROM custom_fields WHERE field_for = 'user' AND in_search = '1' AND field_id = %s", secure($field_id, 'int')));
      if ($get_field->num_rows == 0) {
        continue;
      }
      $field = $get_field->fetch_assoc();
      switch ($field['type']) {
        case 'textbox':
        case 'textarea':
          if ($value) {
            $query_statement .= ($query_statement) ? " OR " : "";
            $query_statement .= sprintf(" (cfv.field_id = %s AND cfv.value LIKE %s) ", secure($field['field_id'], 'int'), secure($value, 'search'));
          }
          break;

        case 'selectbox':
          if ($value != "any") {
            $query_statement .= ($query_statement) ? " OR " : "";
            $query_statement .= sprintf(" (cfv.field_id = %s AND cfv.value = %s) ", secure($field['field_id'], 'int'), secure($value));
          }
          break;

        case 'multipleselectbox':
          if ($value) {
            $value = implode(",", $value);
            $query_statement .= ($query_statement) ? " OR " : "";
            $query_statement .= sprintf(" (cfv.field_id = %s AND cfv.value LIKE %s) ", secure($field['field_id'], 'int'), secure($value, 'search'));
          }
          break;
      }
    }
    return $query_statement;
  }
}
