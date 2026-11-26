<?php

/**
 * class -> pager
 * 
 * @package Sngine
 * @author Zamblek
 */

class Pager
{

  private $_page;
  private $_size;
  private $_total;
  private $_link;

  /**
   * __construct
   * 
   * @param array $params
   */
  public function __construct($params)
  {
    if (is_array($params)) {
      if (isset($params['selected_page'])) {
        $params['selected_page'] = (int)$params['selected_page'];
        $params['selected_page'] = ($params['selected_page'] == 0) ? 1 : $params['selected_page'];

        $this->_page = $params['selected_page'];
      } else {
        $this->_page = NULL;
      }
      $this->_total = isset($params['total_items']) ? $params['total_items'] : NULL;
      $this->_size = isset($params['items_per_page']) ? $params['items_per_page'] : NULL;
      $this->_link = isset($params['url']) ? $params['url'] : NULL;
      /* a page before the first or after the last shows the nearest one */
      if ($this->_page !== NULL) {
        $last_page = ($this->_total && $this->_size) ? (int) ceil($this->_total / $this->_size) : 0;
        if ($this->_page < 1) {
          $this->_page = 1;
        } elseif ($last_page > 0 && $this->_page > $last_page) {
          $this->_page = $last_page;
        }
      }
    }
  }

  /**
   * getOffset
   * 
   * @return integer
   */
  public function getOffset()
  {
    return (max(1, (int) $this->_page) - 1) * (int) $this->_size;
  }

  /**
   * getLimitSql
   * 
   * @return string
   */
  public function getLimitSql()
  {

    $sql = "LIMIT " . $this->getLimit();
    return $sql;
  }

  /**
   * getLimit
   * 
   * @return string
   */
  private function getLimit()
  {

    if ($this->_total == 0) {
      $lastpage = 0;
    } else {
      $lastpage = ceil($this->_total / $this->_size);
    }

    $page = $this->_page;

    if ($this->_page < 1) {
      $page = 1;
    } elseif ($this->_page > $lastpage && $lastpage > 0) {
      $page = $this->_page;
    } else {
      $page = $this->_page;
    }

    $sql = ($page - 1) * $this->_size . "," . $this->_size;

    return $sql;
  }

  /**
   * getPage
   * 
   * @param integer $page
   * @return string
   */
  private function getPage($page)
  {

    if ($page == $this->_page) {
      return '<span class="heroui button button--secondary button--sm button--icon-only size-7.5 rounded-full">' . $page . '</span>';
    }
    return sprintf('<a class="heroui button button--ghost button--sm button--icon-only size-7.5 rounded-full" href="' . $this->_link . '">', $page) . $page . '</a>';
  }

  /**
   * getArrow
   * 
   * @param integer $page
   * @param string $icon
   * @param string $label
   * @param boolean $disabled
   * @return string
   */
  private function getArrow($page, $icon, $label, $disabled)
  {

    $inner = '<span class="icon-[tabler--' . $icon . '] size-4.5 rtl:rotate-180"></span><span class="sr-only">' . $label . '</span>';

    if ($disabled) {
      return '<span class="heroui button button--ghost button--sm button--icon-only size-7.5 rounded-full" aria-disabled="true">' . $inner . '</span>';
    }
    return sprintf('<a class="heroui button button--ghost button--sm button--icon-only size-7.5 rounded-full" href="' . $this->_link . '">', $page) . $inner . '</a>';
  }

  /**
   * getPager
   * 
   * @return string
   */
  public function getPager()
  {

    $totalPages = floor($this->_total / $this->_size);
    $totalPages += ($this->_total % $this->_size != 0) ? 1 : 0;


    if ($this->_page == $totalPages) {
      $to = ($this->_total - $this->_size) + $this->_size;
      $from = ($this->_page * $this->_size) - $this->_size  + 1;
    } else {
      $to = ($this->_page * $this->_size);
      $from = $to - $this->_size  + 1;
    }

    if ($totalPages <= 1) {
      return null;
    }

    // displaying
    $info = '<div class="text-sm text-base-content/80">' . __("Displaying") . ' (' . $from . '-' . $to . ' ' . __("of") . ' ' . $this->_total . ')</div>';

    // prepare loop
    $loopStart = max(1, $this->_page - 1);
    $loopEnd = min($totalPages, $loopStart + 2);
    if ($loopEnd - $loopStart + 1 < 3) {
      $loopStart = max(1, $loopEnd - 2);
    }

    // pages
    $pages = '';
    if ($loopStart > 1) {
      $pages .= $this->getPage(1);
      if ($loopStart > 2) {
        $pages .= '<span class="ellipsis">...</span>';
      }
    }
    for ($i = $loopStart; $i <= $loopEnd; $i++) {
      $pages .= $this->getPage($i);
    }
    if ($loopEnd < $totalPages) {
      if ($loopEnd < $totalPages - 1) {
        $pages .= '<span class="ellipsis">...</span>';
      }
      $pages .= $this->getPage($totalPages);
    }

    // paging
    $paging = '<div class="flex items-center space-x-1">';
    $paging .= $this->getArrow($this->_page - 1, 'chevrons-left', __("Prev"), ($this->_page <= 1));
    $paging .= '<div class="flex items-center space-x-1 [&>.active]:text-bg-soft-primary">' . $pages . '</div>';
    $paging .= $this->getArrow($this->_page + 1, 'chevrons-right', __("Next"), ($this->_page >= $totalPages));
    $paging .= '</div>';

    return '<div class="pagination flex items-center justify-between gap-3 py-3 max-md:flex-wrap max-md:justify-center [--btn-color:var(--color-base-content)]">' . $info . $paging . '</div>';
  }

  /**
   * display
   * 
   * @return void
   */
  public function display()
  {

    print($this->getPager());
  }
}
