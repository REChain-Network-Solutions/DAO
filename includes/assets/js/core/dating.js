/**
 * dating js
 *
 * @package Sngine
 * @author Zamblek
 */

// initialize API URLs
api['dating/swipe'] = ajax_path + "dating/swipe.php";
api['dating/profile'] = ajax_path + "dating/profile.php";
api['dating/purchase'] = ajax_path + "dating/purchase.php";

// dating state
var dating_loading = false;
var dating_exhausted = false;
var dating_drag = null;
var dating_dragged = false;


// dating top card
function dating_top_card() {
  return $('.js_dating-deck .js_dating-card').first();
}


// dating refresh
function dating_refresh() {
  var deck = $('.js_dating-deck');
  if (!deck.length) return;
  var card = dating_top_card();
  /* details */
  $('.js_dating-detail').html(card.length ? card.find('.js_dating-card-detail').html() || '' : '').closest('section').toggleClass('hidden', !card.length || card.data('ad') === true);
  /* empty deck */
  deck.find('.js_dating-empty').toggleClass('hidden', card.length > 0 || !dating_exhausted);
  /* load more cards */
  if (deck.find('.js_dating-card').length < 4 && !dating_exhausted) {
    dating_load_deck();
  }
}


// dating load deck
function dating_load_deck() {
  if (dating_loading) return;
  dating_loading = true;
  var exclude = $('.js_dating-deck .js_dating-card[data-id]').map(function () {
    return $(this).data('id');
  }).get();
  $.post(api['dating/swipe'] + '?do=deck', { 'exclude': exclude }, function (response) {
    dating_loading = false;
    if (response.callback) {
      eval(response.callback);
      return;
    }
    dating_exhausted = !response.cards || response.exhausted;
    if (response.cards) {
      $('.js_dating-deck .js_dating-empty').before(response.cards);
    }
    dating_refresh();
  }, 'json')
    .fail(function () {
      dating_loading = false;
      dating_exhausted = true;
      dating_refresh();
    });
}


// dating balance
function dating_balance(balance) {
  if (!balance) return;
  $('.js_dating-super-likes').text(balance.super_likes);
  if (balance.swipes_left !== null) {
    $('.js_dating-swipes-left').text(balance.swipes_left);
  }
}


// dating move card
function dating_move_card(card, x, y, animate) {
  card.css('transition', animate ? '' : 'none');
  card.css('transform', (x || y) ? 'translate(' + x + 'px, ' + y + 'px) rotate(' + (x / 18) + 'deg)' : '');
  var up = y < -60 && Math.abs(x) < 80;
  card.find('.js_dating-stamp-like').css('opacity', up ? 0 : Math.max(0, Math.min(1, x / 100)));
  card.find('.js_dating-stamp-pass').css('opacity', up ? 0 : Math.max(0, Math.min(1, -x / 100)));
  card.find('.js_dating-stamp-super').css('opacity', up ? Math.max(0, Math.min(1, -y / 120)) : 0);
}


// dating request
function dating_request(id, action, message, on_error) {
  $.post(api['dating/swipe'] + '?do=swipe', { 'id': id, 'action': action, 'message': message || '' }, function (response) {
    if (response.callback) {
      if (on_error) on_error();
      eval(response.callback);
      return;
    }
    if (response.error) {
      if (on_error) on_error(response);
      return;
    }
    dating_balance(response.balance);
    if (response.matched && response.template) {
      modal('#modal-loading');
      modal_content(response.template, true);
    }
  }, 'json')
    .fail(function () {
      if (on_error) on_error();
      show_error_modal();
    });
}


// dating swipe
function dating_swipe(action, message) {
  var card = dating_top_card();
  if (!card.length || card.data('busy')) return;
  var x = (action == 'pass') ? -1 : (action == 'like') ? 1 : 0;
  var width = $(window).width();
  /* fly off */
  card.data('busy', true);
  dating_move_card(card, x * width, (action == 'super') ? -$(window).height() : 0, true);
  setTimeout(function () {
    card.detach();
    dating_refresh();
  }, 250);
  if (card.data('ad') === true) return;
  dating_request(card.data('id'), action, message, function (response) {
    /* put the card back */
    setTimeout(function () {
      card.data('busy', false);
      $('.js_dating-deck').prepend(card);
      dating_move_card(card, 0, 0, false);
      dating_refresh();
      if (!response) return;
      if (response.code == 429) {
        $('.js_dating-deck .js_dating-limit').removeClass('hidden');
      } else if (response.code == 402) {
        modal('#modal-loading');
        $.getJSON(api['dating/purchase'] + '?do=store', function (response) {
          if (response.callback) eval(response.callback);
        });
      } else {
        show_error_modal(response.message);
      }
    }, 300);
  });
}


// dating confirm
function dating_confirm(title, message, callback) {
  $('body').off('click', '#modal-confirm-ok');
  modal("#modal-confirm", { 'title': title, 'message': message, 'danger': true });
  $('body').on('click', '#modal-confirm-ok', function handle() {
    $('body').off('click', '#modal-confirm-ok', handle);
    button_status($(this), "loading");
    callback();
  });
}


// dating post
function dating_post(url, data, button) {
  if (button) button_status(button, "loading");
  $.post(url, data, function (response) {
    if (button) button_status(button, "reset");
    if (response.error) {
      show_error_modal(response.message);
    } else if (response.callback) {
      eval(response.callback);
    }
  }, 'json')
    .fail(function () {
      if (button) button_status(button, "reset");
      show_error_modal();
    });
}


$(function () {

  // run deck
  dating_exhausted = $('.js_dating-deck .js_dating-card').length == 0;
  dating_refresh();


  // run card drag
  $('body').on('pointerdown', '.js_dating-deck .js_dating-card', function (e) {
    var card = $(this);
    if (!card.is(dating_top_card()) || card.data('busy') || (e.pointerType == 'mouse' && e.button !== 0)) return;
    dating_drag = { card: card, x: e.clientX, y: e.clientY, dx: 0, dy: 0 };
    dating_dragged = false;
  });
  $(document).on('pointermove', function (e) {
    if (!dating_drag) return;
    dating_drag.dx = e.clientX - dating_drag.x;
    dating_drag.dy = e.clientY - dating_drag.y;
    if (!dating_dragged && Math.abs(dating_drag.dx) < 8 && Math.abs(dating_drag.dy) < 8) return;
    /* a vertical move on touch screens scrolls the page */
    if (!dating_dragged && e.pointerType != 'mouse' && Math.abs(dating_drag.dy) > Math.abs(dating_drag.dx) && dating_drag.dy > 0) {
      dating_drag = null;
      return;
    }
    dating_dragged = true;
    dating_move_card(dating_drag.card, dating_drag.dx, dating_drag.dy, false);
  });
  $(document).on('pointerup pointercancel', function (e) {
    if (!dating_drag) return;
    var drag = dating_drag;
    dating_drag = null;
    if (!dating_dragged) return;
    if (e.type == 'pointerup' && drag.dx > 100) {
      dating_swipe('like');
    } else if (e.type == 'pointerup' && drag.dx < -100) {
      dating_swipe('pass');
    } else if (e.type == 'pointerup' && drag.dy < -120 && Math.abs(drag.dx) < 80 && drag.card.data('ad') !== true && $('.js_dating-swipe[data-action="super"]').length) {
      dating_swipe('super');
    } else {
      dating_move_card(drag.card, 0, 0, true);
    }
  });
  /* a drag is not a click */
  $('body').on('click', '.js_dating-deck .js_dating-card', function (e) {
    if (dating_dragged) {
      e.preventDefault();
      e.stopImmediatePropagation();
      dating_dragged = false;
    }
  });


  // run card photos
  $('body').on('click', '.js_dating-photo-prev, .js_dating-photo-next', function () {
    var card = $(this).closest('.js_dating-card');
    var photos = card.find('.js_dating-photo');
    var current = photos.index(photos.not('.hidden'));
    var next = current + ($(this).hasClass('js_dating-photo-next') ? 1 : -1);
    if (next < 0 || next >= photos.length) return;
    photos.addClass('hidden').eq(next).removeClass('hidden');
    card.find('.js_dating-photo-dot').removeAttr('data-active').eq(next).attr('data-active', 'true');
  });


  // run deck actions
  $('body').on('click', '.js_dating-swipe', function () {
    dating_swipe($(this).data('action'));
  });
  $('body').on('click', '.js_dating-rewind', function () {
    var _this = $(this);
    button_status(_this, "loading");
    $.post(api['dating/swipe'] + '?do=rewind', function (response) {
      button_status(_this, "reset");
      if (response.callback) {
        eval(response.callback);
      } else if (response.error) {
        if (response.code == 402) {
          modal('#modal-loading');
          $.getJSON(api['dating/purchase'] + '?do=store', function (response) {
            if (response.callback) eval(response.callback);
          });
        } else {
          show_error_modal(response.message);
        }
      } else if (response.cards) {
        $('.js_dating-deck').prepend(response.cards);
        $('.js_dating-deck .js_dating-limit').addClass('hidden');
        dating_balance(response.balance);
        dating_refresh();
      }
    }, 'json')
      .fail(function () {
        button_status(_this, "reset");
        show_error_modal();
      });
  });
  $('body').on('click', '.js_dating-message', function () {
    var card = dating_top_card();
    if (!card.length || card.data('ad') === true) return;
    modal('#modal-loading');
    $.getJSON(api['dating/swipe'] + '?do=message&id=' + card.data('id'), function (response) {
      if (response.callback) eval(response.callback);
    })
      .fail(function () {
        show_error_modal();
      });
  });
  $('body').on('submit', '.js_dating-message-form', function (e) {
    e.preventDefault();
    var message = $(this).find('textarea[name="message"]').val();
    var id = $(this).data('id');
    modal_close(function () {
      if (dating_top_card().data('id') == id) {
        dating_swipe('like', message);
      }
    });
  });
  $(document).on('keydown', function (e) {
    if (!$('.js_dating-deck').length || $(e.target).is('input, textarea, select, [contenteditable]') || !$('#modal').hasClass('hidden')) return;
    if (e.key == 'ArrowLeft') {
      dating_swipe('pass');
    } else if (e.key == 'ArrowRight') {
      dating_swipe('like');
    } else if (e.key == 'ArrowUp' && $('.js_dating-swipe[data-action="super"]').length) {
      e.preventDefault();
      dating_swipe('super');
    }
  });


  // run grid actions
  $('body').on('click', '.js_dating-grid-swipe', function () {
    var card = $(this).closest('.js_dating-grid-card');
    card.addClass('hidden');
    dating_request(card.data('id'), $(this).data('action'), '', function (response) {
      card.removeClass('hidden');
      if (response) show_error_modal(response.message);
    });
  });


  // run matches actions
  $('body').on('click', '.js_dating-unmatch', function () {
    var id = $(this).data('id');
    var block = $(this).data('block') === true;
    dating_confirm(__['Unmatch'], __['Are you sure you want to unmatch this member?'], function () {
      $.post(api['dating/swipe'] + '?do=unmatch', { 'id': id, 'block': block }, function (response) {
        modal_close();
        if (response.callback) {
          eval(response.callback);
        } else {
          $('.js_dating-match[data-id="' + id + '"]').remove();
        }
      }, 'json')
        .fail(function () {
          show_error_modal();
        });
    });
  });


  // run profile actions
  $('body').on('click', '.js_dating-status', function () {
    dating_post(api['dating/profile'] + '?do=status', { 'status': $(this).data('status') }, $(this));
  });
  $('body').on('click', '.js_dating-leave', function () {
    dating_confirm(__['Delete'], __['Are you sure you want to delete your dating profile?'], function () {
      dating_post(api['dating/profile'] + '?do=delete', {});
    });
  });
  $('body').on('click', '.js_dating-buy', function () {
    dating_post(api['dating/purchase'] + '?do=' + $(this).data('item'), {}, $(this));
  });


  // run profile photos
  $('body').on('change', '.js_dating-photo-uploader .js_x-uploader-input', function () {
    var source = $(this).val();
    var tile = $(this).closest('.x-image');
    if (!source) return;
    $.post(api['dating/profile'] + '?do=photo_add', { 'source': source }, function (response) {
      x_image_reset(tile);
      if (response.error) {
        show_error_modal(response.message);
        return;
      }
      if (response.photos !== undefined) $('.js_dating-photos').html(response.photos);
      if (response.callback) eval(response.callback);
    }, 'json')
      .fail(function () {
        x_image_reset(tile);
        show_error_modal();
      });
  });
  $('body').on('click', '.js_dating-photo-delete', function () {
    var id = $(this).data('id');
    confirm(__['Delete'], __['Are you sure you want to delete this?'], function () {
      $.post(api['dating/profile'] + '?do=photo_delete', { 'id': id }, function (response) {
        modal_close();
        if (response.error) {
          show_error_modal(response.message);
        } else if (response.callback) {
          eval(response.callback);
        } else if (response.photos !== undefined) {
          $('.js_dating-photos').html(response.photos);
        }
      }, 'json')
        .fail(function () {
          show_error_modal();
        });
    });
  });
  if ($('.js_dating-photos').length && typeof Sortable === 'function') {
    Sortable.create($('.js_dating-photos')[0], {
      animation: 150,
      onEnd: function () {
        var ids = $('.js_dating-photos .js_dating-photo-item').map(function () {
          return $(this).data('id');
        }).get();
        $.post(api['dating/profile'] + '?do=photos_sort', { 'ids': ids });
      }
    });
  }

});
