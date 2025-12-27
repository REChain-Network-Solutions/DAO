/**
 * login js
 * 
 * @package Delus
 * @author Sorokin Dmitry Olegovich
 */

$(function () {

  $('body').on('click', '.js_login, .js_chat-start, .js_friend-add, .js_follow, .js_like-page, .js_join-group, .js_go-event, .js_interest-event, .js_job-apply, .js_course-enroll, .js_shopping-add-to-cart, .js_sneak-peak, .js_translator', function () {
    modal('#modal-login');
  });

});