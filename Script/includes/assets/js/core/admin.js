/**
 * admin js
 * 
 * @package Delus
 * @author Dmitry Sorokin - @sorydima & @sorydev Handles. 
 */

// initialize API URLs
api['admin/delete'] = ajax_path + "admin/delete.php";
api['admin/test'] = ajax_path + "admin/test.php";
api['admin/users'] = ajax_path + "admin/users.php";
api['admin/posts'] = ajax_path + "admin/posts.php";
api['admin/ads'] = ajax_path + "admin/ads.php";
api['admin/verify'] = ajax_path + "admin/verify.php";
api['admin/bank'] = ajax_path + "admin/bank.php";
api['admin/withdraw'] = ajax_path + "admin/withdraw.php";
api['admin/tagify'] = ajax_path + "admin/tagify.php";
api['admin/reset'] = ajax_path + "admin/reset.php";


// tagify_ajax
function tagify_ajax(selector) {
  $(selector).each(function () {
    const element = this;
    const handle = $(element).data('handle');
    if (element.nodeName !== "TAGS") {
      const tagify = new Tagify(element, {
        id: guid(),
        duplicates: false,
        addTagOnBlur: false,
      }).on("input", function (e) {
        const tagName = e.detail.value;
        $.post(api['admin/tagify'], { query: tagName, handle: handle }, function (response) {
          /* check the response */
          if (response.callback) {
            eval(response.callback);
          } else {
            if (response.list !== undefined) {
              tagify.settings.whitelist = JSON.parse(response.list);
              tagify.dropdown.show.call(tagify, tagName);
            }
          }
        }, 'json')
          .fail(function () {
            modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
          });
      });
    }
  });
}


$(function () {

  // tagify
  tagify_ajax('.js_tagify-ajax');


  // treegrid
  $('.js_treegrid').treegrid();


  // colorpicker 
  $('body').on('change', '.js_colorpicker input[type="text"]', function () {
    $(this).next().val($(this).val());
  });
  $('body').on('change', '.js_colorpicker input[type="color"]', function () {
    $(this).prev().val($(this).val());
  });


  // admin deleter
  $('body').on('click', '.js_admin-deleter', function () {
    var handle = $(this).data('handle');
    var id = $(this).data('id');
    var node = $(this).data('node');
    var redirect_url = $(this).data("redirect");
    var message = $(this).data('delete-message') || __['Are you sure you want to delete this?'];
    confirm(__['Delete'], message, function () {
      $.post(api['admin/delete'], { 'handle': handle, 'id': id, 'node': node }, function (response) {
        /* check the response */
        if (response.callback) {
          eval(response.callback);
        } else {
          if (redirect_url !== undefined) {
            window.location = redirect_url;
          } else {
            window.location.reload();
          }
        }
      }, 'json')
        .fail(function () {
          modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
        });
    });
  });


  // admin tester
  $('body').on('click', '.js_admin-tester', function () {
    var _this = $(this);
    var _parent = _this.parents('form');
    var error = _parent.find('.alert.alert-danger');
    var success = _parent.find('.alert.alert-success');
    var handle = _this.data('handle');
    /* button loading */
    button_status(_this, "loading");
    $.post(api['admin/test'], { 'handle': handle }, function (response) {
      /* button reset */
      button_status(_this, "reset");
      /* handle response */
      if (response.error) {
        if (success.is(":visible")) success.hide(); /* hide previous alert */
        error.html(response.message).slideDown();
      } else if (response.success) {
        if (error.is(":visible")) error.hide(); /* hide previous alert */
        success.html(response.message).slideDown();
      } else {
        eval(response.callback);
      }
    }, 'json')
      .fail(function () {
        /* button reset */
        button_status(_this, "reset");
        /* handle error */
        if (success.is(":visible")) success.hide(); /* hide previous alert */
        error.html(__['There is something that went wrong!']).slideDown();
      });
  });


  // admin users
  $('body').on('click', '.js_user-approve', function () {
    var id = $(this).data('id');
    confirm(__['Verify'], __['Are you sure you want to do this?'], function () {
      $.post(api['admin/users'], { 'do': "approve", 'id': id }, function (response) {
        /* check the response */
        if (response.callback) {
          eval(response.callback);
        } else {
          window.location.reload();
        }
      }, 'json')
        .fail(function () {
          modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
        });
    });
  });


  // admin posts
  $('body').on('click', '.js_post-approve', function () {
    var id = $(this).data('id');
    confirm(__['Verify'], __['Are you sure you want to do this?'], function () {
      $.post(api['admin/posts'], { 'do': "approve", 'id': id }, function (response) {
        /* check the response */
        if (response.callback) {
          eval(response.callback);
        } else {
          window.location.reload();
        }
      }, 'json')
        .fail(function () {
          modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
        });
    });
  });


  // admin verification
  $('body').on('click', '.js_admin-verification-documents', function () {
    var is_page = ($(this).data('handle') == 'page') ? true : false;
    modal('#verification-documents', { 'is_page': is_page, 'photo': $(this).data('photo'), 'passport': $(this).data('passport'), 'website': $(this).data('business-website'), 'address': $(this).data('business-address'), 'message': $(this).data('message'), 'handle': $(this).data('handle'), 'node-id': $(this).data('node-id'), 'request-id': $(this).data('request-id') }, 'large');
  });
  $('body').on('click', '.js_admin-verify', function () {
    var handle = $(this).data('handle');
    var id = $(this).data('id');
    confirm(__['Verify'], __['Are you sure you want to verify this request?'], function () {
      $.post(api['admin/verify'], { 'do': 'approve', 'handle': handle, 'id': id }, function (response) {
        /* check the response */
        if (response.callback) {
          eval(response.callback);
        } else {
          window.location.reload();
        }
      }, 'json')
        .fail(function () {
          modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
        });
    });
  });
  $('body').on('click', '.js_admin-unverify', function () {
    var handle = $(this).data('handle');
    var id = $(this).data('id');
    confirm(__['Decline'], __['Are you sure you want to decline this request?'], function () {
      $.post(api['admin/verify'], { 'do': 'decline', 'handle': handle, 'id': id }, function (response) {
        /* check the response */
        if (response.callback) {
          eval(response.callback);
        } else {
          window.location.reload();
        }
      }, 'json')
        .fail(function () {
          modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
        });
    });
  });


  // admin ads
  $('body').on('click', '.js_ads-approve', function () {
    var id = $(this).data('id');
    confirm(__['Verify'], __['Are you sure you want to verify this request?'], function () {
      $.post(api['admin/ads'], { 'do': "approve", 'id': id }, function (response) {
        /* check the response */
        if (response.callback) {
          eval(response.callback);
        } else {
          window.location.reload();
        }
      }, 'json')
        .fail(function () {
          modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
        });
    });
  });
  $('body').on('click', '.js_ads-decline', function () {
    var id = $(this).data('id');
    confirm(__['Decline'], __['Are you sure you want to decline this request?'], function () {
      $.post(api['admin/ads'], { 'do': 'decline', 'id': id }, function (response) {
        /* check the response */
        if (response.callback) {
          eval(response.callback);
        } else {
          window.location.reload();
        }
      }, 'json')
        .fail(function () {
          modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
        });
    });
  });


  // admin bank transfer
  $('body').on('click', '.js_admin-bank-accept', function () {
    var id = $(this).data('id');
    confirm(__['Verify'], __['Are you sure you want to verify this request?'], function () {
      $.post(api['admin/bank'], { 'action': "accept", 'id': id }, function (response) {
        /* check the response */
        if (response.callback) {
          eval(response.callback);
        } else {
          window.location.reload();
        }
      }, 'json')
        .fail(function () {
          modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
        });
    });
  });
  $('body').on('click', '.js_admin-bank-decline', function () {
    var id = $(this).data('id');
    confirm(__['Decline'], __['Are you sure you want to decline this request?'], function () {
      $.post(api['admin/bank'], { 'action': 'decline', 'id': id }, function (response) {
        /* check the response */
        if (response.callback) {
          eval(response.callback);
        } else {
          window.location.reload();
        }
      }, 'json')
        .fail(function () {
          modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
        });
    });
  });


  // admin withdraw
  $('body').on('click', '.js_admin-withdraw', function () {
    var type = $(this).data('type');
    var handle = $(this).data('handle');
    var id = $(this).data('id');
    if (handle == "approve") {
      var _title = __['Mark as Paid'];
      var _message = __['Are you sure you want to approve this request?'];
    } else {
      var _title = __['Decline'];
      var _message = __['Are you sure you want to decline this request?'];
    }
    confirm(_title, _message, function () {
      $.post(api['admin/withdraw'], { 'type': type, 'handle': handle, 'id': id }, function (response) {
        /* check the response */
        if (response.callback) {
          eval(response.callback);
        } else {
          window.location.reload();
        }
      }, 'json')
        .fail(function () {
          modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
        });
    });
  });


  // input dependencies
  /* system ads */
  $('#js_ads-place').on('change', function () {
    if ($(this).val() == "pages") {
      $('#js_selected-pages').fadeIn();
      $('#js_selected-groups').hide();
    } else if ($(this).val() == "groups") {
      $('#js_selected-pages').hide();
      $('#js_selected-groups').fadeIn();
    } else {
      $('#js_selected-pages').hide();
      $('#js_selected-groups').hide();
    }
  });
  /* custom fields */
  $('#js_field-for').on('change', function () {
    if ($(this).val() == "user") {
      $('#js_field-place').fadeIn();
      $('#js_field-searchable').fadeIn();
    } else {
      $('#js_field-place').hide();
      $('#js_field-searchable').hide();
    }
    if (['product', 'job', 'offer', 'course'].includes($(this).val())) {
      $('#js_field-showin').hide();
    } else {
      $('#js_field-showin').fadeIn();
    }
  });
  $('#js_field-type').on('change', function () {
    /* selectbox */
    if ($(this).val() == "selectbox" || $(this).val() == "multipleselectbox") {
      $('#js_field-select-options').fadeIn();
    } else {
      $('#js_field-select-options').hide();
    }
    /* textbox */
    if ($(this).val() == "textbox") {
      $('#js_field-clickable').fadeIn();
    } else {
      $('#js_field-clickable').hide();
    }
  });
  /* custom pages */
  $('#js_page-is-redirect').on('change', function () {
    if ($(this).is(":checked")) {
      $('#js_page-redirect').fadeIn();
      $('#js_page-not-redirect').hide();
    } else {
      $('#js_page-redirect').hide();
      $('#js_page-not-redirect').fadeIn();
    }
  });
  /* colored posts */
  $('.js_pattern-type').on('change', function () {
    if ($(this).val() == "color") {
      $('#js_pattern-type-image').hide();
      $('#js_pattern-type-color').fadeIn();
      $('.js_pattern-preview').css("backgroundImage", "linear-gradient(45deg, " + $('.js_pattern-background-color-1').val() + ", " + $('.js_pattern-background-color-2').val() + ")");
    } else {
      $('#js_pattern-type-image').fadeIn();
      $('#js_pattern-type-color').hide();
      $('.js_pattern-preview').css("backgroundImage", "url(" + uploads_path + "/" + $('.js_pattern-background-image').val() + ")");

    }
  });
  $('.js_pattern-background-color-1').on('change', function () {
    $('.js_pattern-preview').css("backgroundImage", "linear-gradient(45deg, " + $(this).val() + ", " + $('.js_pattern-background-color-2').val() + ")");
  });
  $('.js_pattern-background-color-2').on('change', function () {
    $('.js_pattern-preview').css("backgroundImage", "linear-gradient(45deg, " + $('.js_pattern-background-color-1').val() + ", " + $(this).val() + ")");
  });
  $('.js_pattern-background-image').on('change propertychange', function () {
    $('.js_pattern-preview').css("backgroundImage", "url(" + uploads_path + "/" + $(this).val() + ")");
  });
  $('.js_pattern-text-color').on('change', function () {
    $('.js_pattern-preview').find('h2').css("color", $(this).val());
  });
  /* custom withdrawal method */
  $('#js_custome-withdrawal').on('click', function () {
    if ($(this).find("input").is(":checked")) {
      $('#js_custome-withdrawal-name').fadeIn();
    } else {
      $('#js_custome-withdrawal-name').hide();
    }
  });
  /* auto-connect */
  $('.js_add-auto-connect-node').on('click', function () {
    var _this = $(this);
    var handle = _this.data('handle');
    switch (handle) {
      case "like":
        var nodes = "pages";
        var nodes_name = __["Pages"];
        break;

      case "join":
        var nodes = "groups";
        var nodes_name = __["Groups"];
        break;

      default:
        var nodes = "users";
        var nodes_name = __["Users"];
        break;
    }
    var uuid = guid();
    var list_selector = `.js_auto-${handle}-nodes-list`;
    var country_field_name = `auto_${handle}_country_${uuid}`;
    var nodes_field_name = `auto_${handle}_nodes_ids_${uuid}`;
    $(list_selector).append(render_template('#auto-connect-node', { nodes, nodes_name, country_field_name, nodes_field_name })).fadeIn();
    tagify_ajax('.js_tagify-ajax-late');
  });
  /* affiliates levels */
  $('.js_affiliates-levels').on('change', function () {
    /* show hide divs with affiliates-levels-2 & affiliates-levels-3 ... etc to 5 */
    var level = $(this).val();
    $('#affiliates-levels-2').hide();
    $('#affiliates-levels-3').hide();
    $('#affiliates-levels-4').hide();
    $('#affiliates-levels-5').hide();
    if (level >= 2) $('#affiliates-levels-2').fadeIn();
    if (level >= 3) $('#affiliates-levels-3').fadeIn();
    if (level >= 4) $('#affiliates-levels-4').fadeIn();
    if (level >= 5) $('#affiliates-levels-5').fadeIn();
  });


  // system factory reset
  $('body').on('click', '.js_admin-reset', function (e) {
    e.preventDefault();
    confirm(__['Factory Reset'], __['Are you sure you want to reset your website?'], function () {
      $.post(api['admin/reset'], { "do": "factory_reset", "password_check": $("#modal-password-check").val() }, function (response) {
        /* check the response */
        if (response.callback) {
          eval(response.callback);
        } else {
          window.location = site_path;
        }
      }, 'json')
        .fail(function () {
          modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
        });
    }, true);
  });


  // admin api reset
  $('body').on('click', '.js_admin-api-reset', function (e) {
    e.preventDefault();
    confirm(__['Reset API Key'], __['Are you sure you want to reset your API key?'], function () {
      $.post(api['admin/reset'], { "do": "api_reset", "password_check": $("#modal-password-check").val() }, function (response) {
        /* check the response */
        if (response.callback) {
          eval(response.callback);
        } else {
          window.location.reload();
        }
      }, 'json')
        .fail(function () {
          modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
        });
    }, true);
  });


  // admin jwt reset
  $('body').on('click', '.js_admin-jwt-reset', function (e) {
    e.preventDefault();
    confirm(__['Reset JWT Key'], __['Are you sure you want to reset your JWT key?'], function () {
      $.post(api['admin/reset'], { "do": "jwt_reset", "password_check": $("#modal-password-check").val() }, function (response) {
        /* check the response */
        if (response.callback) {
          eval(response.callback);
        } else {
          window.location.reload();
        }
      }, 'json')
        .fail(function () {
          modal('#modal-message', { title: __['Error'], message: __['There is something that went wrong!'] });
        });
    }, true);
  });

});