<?php

/**
 * functions -> errors
 * 
 * @package Sngine
 * @author Zamblek
 */

/* ------------------------------- */
/* Error */
/* ------------------------------- */

/**
 * _error
 * 
 * @return void
 */
function _error()
{
  $args = func_get_args();
  if (count($args) > 1 && !in_array($args[0], ['BANNED_USER', 'PERMISSION'])) {
    $title = $args[0];
    $message = $args[1];
  } else {
    switch ($args[0]) {
      case 'DB_ERROR':
        $title = "Database Error";
        $message = "<div class='text-start'><h1>" . "Error establishing a database connection" . "</h1>
                            <p>" . "This either means that the username and password information in your config.php file is incorrect or we can't contact the database server at localhost. This could mean your host's database server is down." . "</p>
                            <ul>
                                <li>" . "Are you sure you have the correct username and password?" . "</li>
                                <li>" . "Are you sure that you have typed the correct hostname?" . "</li>
                                <li>" . "Are you sure that the database server is running?" . "</li>
                            </ul>
                            <p>" . "If you're unsure what these terms mean you should probably contact your host. If you still need help you can always visit the" . " <a href='https://zamblek.com/support'>" . "Sngine Support" . ".</a></p>
                            </div>";
        break;

      case 'SQL_ERROR':
        $title = __("Database Error");
        $message = __("An error occurred while writing to database. Please try again later");
        if (DEBUGGING) {
          $backtrace = debug_backtrace();
          $line = $backtrace[0]['line'];
          $file = $backtrace[0]['file'];
          $message .= "<br><br><small>This error function was called from line $line in file $file</small>";
        }
        break;

      case 'SQL_ERROR_THROWEN':
        $message = __("An error occurred while writing to database. Please try again later");
        if (DEBUGGING) {
          $backtrace = debug_backtrace();
          $line = $backtrace[0]['line'];
          $file = $backtrace[0]['file'];
          $message .= "<br><br><small>This error function was called from line $line in file $file</small>";
        }
        throw new SQLException($message);
        break;

      case 'PERMISSION':
        global $smarty;
        $title = __("Permission Needed");
        $message = ($args[1]) ? $args[1] : __("You do not have the permission to view this content");
        if (isset($smarty)) {
          $smarty->assign('message', $message);
          page_header($title);
          page_footer('permission');
          exit;
        }
        break;

      case 'CHAT_PERMISSION':
        global $smarty;
        $title = __("Permission Needed");
        $message = ($args[1]) ? $args[1] : __("Your privacy settings do not allow you to chat with this user, Go to your privacy settings to change this");
        if (isset($smarty)) {
          $smarty->assign('message', $message);
          page_header($title);
          page_footer('permission');
          exit;
        }
        break;

      case 'BANNED':
        global $smarty;
        $title = __("Banned");
        $message = __("You do not have the permission to view this content");
        if (isset($smarty)) {
          $smarty->assign('message', $message);
          page_header($title);
          page_footer('banned');
          exit;
        }
        break;

      case 'BANNED_USER':
        global $smarty;
        $title = __("Banned Account");
        $message = $args[1];
        if (isset($smarty)) {
          $smarty->assign('message', $message);
          page_header($title);
          page_footer('banned');
          exit;
        }
        break;

      case 'ACTIVATION':
        global $smarty;
        if (isset($smarty)) {
          page_header(__("Activation Required"));
          page_footer('activation');
          exit;
        }
        break;

      case 'APPROVAL':
        global $smarty;
        if (isset($smarty)) {
          page_header(__("Admin Approval Required"));
          page_footer('approval');
          exit;
        }
        break;

      case '400':
        header('HTTP/1.0 400 Bad Request');
        if (DEBUGGING) {
          $backtrace = debug_backtrace();
          $line = $backtrace[0]['line'];
          $file = $backtrace[0]['file'];
          exit("This error function was called from line $line in file $file");
        }
        exit;
        break;

      case '401':
        header('HTTP/1.0 401 Unauthorized');
        if (DEBUGGING) {
          $backtrace = debug_backtrace();
          $line = $backtrace[0]['line'];
          $file = $backtrace[0]['file'];
          exit("This error function was called from line $line in file $file");
        }
        exit;
        break;

      case '403':
        header('HTTP/1.0 403 Access Denied');
        if (DEBUGGING) {
          $backtrace = debug_backtrace();
          $line = $backtrace[0]['line'];
          $file = $backtrace[0]['file'];
          exit("This error function was called from line $line in file $file");
        }
        exit;
        break;

      case '404':
        global $smarty;
        header('HTTP/1.0 404 Not Found');
        $title = __("404 Not Found");
        $message = __("Sorry but the page you are looking for does not exist, have been removed. name changed or is temporarily unavailable");
        if (DEBUGGING) {
          $backtrace = debug_backtrace();
          $line = $backtrace[0]['line'];
          $file = $backtrace[0]['file'];
          $message .= "<br><br><small>This error function was called from line $line in file $file</small>";
        }
        if (isset($smarty)) {
          $smarty->assign('message', $message);
          page_header($title);
          page_footer('404');
          exit;
        }
        break;

      default:
        $title = __("Error");
        $message = __("There is some thing went wrong");
        if (DEBUGGING) {
          $backtrace = debug_backtrace();
          $line = $backtrace[0]['line'];
          $file = $backtrace[0]['file'];
          $message .= "<br><br>" . "<small>This error function was called from line $line in file $file</small>";
        }
        break;
    }
  }
  echo '<!DOCTYPE html>
            <html>
            <head>
                <meta charset="utf-8">
                <title>' . $title . '</title>
                <style type="text/css">
                    html {
                        background: #f1f1f1;
                    }
                    body {
                        color: #555;
                        font-family: "Open Sans", Arial,sans-serif;
                        margin: 0;
                        padding: 0;
                    }
                    .error-title {
                        background: #ce3426;
                        color: #fff;
                        text-align: center;
                        font-size: 34px;
                        font-weight: 100;
                        line-height: 50px;
                        padding: 60px 0;
                    }
                    .error-message {
                        margin: 1em auto;
                        padding: 1em 2em;
                        max-width: 600px;
                        font-size: 1em;
                        line-height: 1.8em;
                        text-align: center;
                    }
                    .error-message .code,
                    .error-message p {
                        margin-top: 0;
                        margin-bottom: 1.3em;
                    }
                    .error-message .code {
                        font-family: Consolas, Monaco, monospace;
                        background: rgba(0, 0, 0, 0.7);
                        padding: 10px;
                        color: rgba(255, 255, 255, 0.7);
                        word-break: break-all;
                        border-radius: 2px;
                    }
                    h1 {
                        font-size: 1.2em;
                    }

                    ul li {
                        margin-bottom: 1em;
                        font-size: 0.9em;
                    }
                    a {
                        color: #ce3426;
                        text-decoration: none;
                    }
                    a:hover {
                        text-decoration: underline;
                    }
                    .button {
                        background: #f7f7f7;
                        border: 1px solid #cccccc;
                        color: #555;
                        display: inline-block;
                        text-decoration: none;
                        margin: 0;
                        padding: 5px 10px;
                        cursor: pointer;
                        -webkit-border-radius: 3px;
                        -webkit-appearance: none;
                        border-radius: 3px;
                        white-space: nowrap;
                        -webkit-box-sizing: border-box;
                        -moz-box-sizing:    border-box;
                        box-sizing:         border-box;

                        -webkit-box-shadow: inset 0 1px 0 #fff, 0 1px 0 rgba(0,0,0,.08);
                        box-shadow: inset 0 1px 0 #fff, 0 1px 0 rgba(0,0,0,.08);
                        vertical-align: top;
                    }

                    .button.button-large {
                        height: 29px;
                        line-height: 28px;
                        padding: 0 12px;
                    }

                    .button:hover,
                    .button:focus {
                        background: #fafafa;
                        border-color: #999;
                        color: #222;
                        text-decoration: none;
                    }

                    .button:focus  {
                        -webkit-box-shadow: 1px 1px 1px rgba(0,0,0,.2);
                        box-shadow: 1px 1px 1px rgba(0,0,0,.2);
                    }

                    .button:active {
                        background: #eee;
                        border-color: #999;
                        color: #333;
                        -webkit-box-shadow: inset 0 2px 5px -3px rgba( 0, 0, 0, 0.5 );
                        box-shadow: inset 0 2px 5px -3px rgba( 0, 0, 0, 0.5 );
                    }
                    .text-start {
                        text-align: left;
                    }
                </style>
            </head>
            <body>
                <div class="error-title">' . $title . '</div>
                <div class="error-message">' . $message . '</div>
            </body>
            </html>';
  exit;
}


/**
 * wizard_db_error
 * 
 * @param mysqli $db
 * @param string $context
 * @param string $process
 * @return string
 */
function wizard_db_error($db, $context, $process = 'update')
{
  $errno  = $db->errno;
  $raw    = trim($db->error);
  $update = ($process !== 'install');
  switch ($errno) {
    case 1050: /* table already exists */
      return $update
        ? "It looks like this update has already been applied — one of the database tables it creates already exists, so there's nothing new to add. Your site is most likely already up to date. (Details: " . $raw . ")"
        : "The database you selected is not empty — it already contains a table this installation needs to create. Please use a fresh, empty database (or drop the existing tables) and try again. (Details: " . $raw . ")";
    case 1060: /* duplicate column */
      return $update
        ? "It looks like this update has already been applied — a column it tries to add already exists in your database. Your site is most likely already up to date. (Details: " . $raw . ")"
        : "The database you selected is not empty — it already contains data from a previous installation. Please use a fresh, empty database (or drop the existing tables) and try again. (Details: " . $raw . ")";
    case 1061: /* duplicate key/index */
      return $update
        ? "It looks like this update has already been applied — an index it tries to add already exists. Your site is most likely already up to date. (Details: " . $raw . ")"
        : "The database you selected is not empty — it already contains an index from a previous installation. Please use a fresh, empty database (or drop the existing tables) and try again. (Details: " . $raw . ")";
    case 1062: /* duplicate entry for a unique key */
    case 1022: /* can't write, duplicate key */
      return $update
        ? "It looks like this update has already been applied — the new settings it adds already exist in the system_options table. Your site is most likely already up to date. (Details: " . $raw . ")"
        : "The database you selected is not empty — it already contains records from a previous installation. Please use a fresh, empty database (or drop the existing tables) and try again. (Details: " . $raw . ")";
    case 1146: /* table doesn't exist */
      return $update
        ? "A database table this update expects is missing. Please make sure your database matches your current Sngine version before running the update. (Details: " . $raw . ")"
        : "A database table couldn't be found during installation. Please make sure your database user has full privileges on an empty database, then try again. (Details: " . $raw . ")";
    case 1054: /* unknown column */
      return $update
        ? "A database column this update expects is missing. Please make sure your database matches your current Sngine version before running the update. (Details: " . $raw . ")"
        : "A database column couldn't be found during installation. Please make sure your database user has full privileges on an empty database, then try again. (Details: " . $raw . ")";
    default:
      return $context . ". Database error" . ($errno ? " #" . $errno : "") . ": " . ($raw !== "" ? $raw : "an unknown database error occurred") . ".";
  }
}
