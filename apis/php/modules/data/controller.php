<?php

/**
 * APIs -> modules -> data -> controller
 *
 * @package Delus
 * @author Dmitry Sorokin - @sorydima & @sorydev Handles. 
 */

// loadData
function loadData($req, $res)
{
  global $user;
  global $user;
  switch ($req->query['get']) {
    case 'new_people':
      /* get new people */
      $data = $user->get_new_people($req->query['offset'], $req->query['random']);
      break;
    default:
      throw new BadRequestException(__("Invalid request"));
      break;
  }
  if (!$data) {
    throw new NoDataException(__("No data found"));
  }
  apiResponse($res, ['data' => $data]);
}

// uploadFiles
function uploadFiles($req, $res)
{
  global $system, $user;
  /* check demo account */
  if ($user->_data['user_demo']) {
    throw new AuthorizationException(__("You can't do this with demo account"));
  }
  $response = upload_file();
  apiResponse($res, ['data' => $response]);
}

// deleteUploadedFile
function deleteUploadedFile($req, $res)
{
  global $user;
  /* check demo account */
  if ($user->_data['user_demo']) {
    throw new AuthorizationException(__("You can't do this with demo account"));
  }
  delete_uploads_file($req->body['src']);
  apiResponse($res);
}

// resetRealtimeCounters
function resetRealtimeCounters($req, $res)
{
  global $user;
  $user->reset_realtime_counters($req->body['reset']);
  apiResponse($res);
}
