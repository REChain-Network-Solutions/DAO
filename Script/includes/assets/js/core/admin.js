/**
 * admin js
 * 
 * @package Sngine
 * @author Zamblek
 */

// initialize API URLs
api['admin/delete'] = ajax_path + "admin/delete.php";
api['admin/test'] = ajax_path + "admin/test.php";
api['admin/users'] = ajax_path + "admin/users.php";
api['admin/posts'] = ajax_path + "admin/posts.php";
api['admin/ads_campaigns'] = ajax_path + "admin/ads_campaigns.php";
api['admin/verify'] = ajax_path + "admin/verify.php";
api['admin/bank'] = ajax_path + "admin/bank.php";
api['admin/withdraw'] = ajax_path + "admin/withdraw.php";
api['admin/tagify'] = ajax_path + "admin/tagify.php";
api['admin/reset'] = ajax_path + "admin/reset.php";
api['admin/license'] = ajax_path + "admin/license.php";
api['admin/themes'] = ajax_path + "admin/themes.php";


// tagify_ajax
function tagify_ajax(selector) {
  $(selector).each(function () {
    const element = this;
    const handle = $(element).data('handle');
    if (element.nodeName !== "TAGS" && !element.__tagify) {
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
            show_error_modal();
          });
      });
    }
  });
}


$(function () {

  // tagify
  tagify_ajax('.js_tagify-ajax');


  // tree rows
  $('body').on('click', '.js_tree-toggle', function () {
    var row = $(this).closest('tr');
    var depth = parseInt(row.attr('data-tree-depth'), 10);
    var expanded = $(this).attr('aria-expanded') !== 'true';
    var collapsed_depth = null;
    $(this).attr('aria-expanded', expanded ? 'true' : 'false');
    row.nextAll('tr').each(function () {
      var child = $(this);
      var child_depth = parseInt(child.attr('data-tree-depth'), 10);
      if (!(child_depth > depth)) return false;
      /* keep rows under a collapsed child hidden */
      if (collapsed_depth !== null && child_depth > collapsed_depth) return;
      collapsed_depth = null;
      child.toggleClass('hidden', !expanded);
      if (expanded && child.find('.js_tree-toggle').attr('aria-expanded') === 'false') {
        collapsed_depth = child_depth;
      }
    });
  });


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
    var title = $(this).data('confirm-title') || __['Delete'];
    confirm(title, message, function () {
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
          show_error_modal();
        });
    });
  });


  // theme path check
  $('body').on('click', '.js_check-theme-path', function () {
    var _this = $(this);
    var _parent = _this.closest('.admin-settings-panel');
    if (!_parent.length) {
      _parent = _this.parents('form');
    }
    var error = _parent.find('.alert.alert-danger');
    var success = _parent.find('.alert.alert-success');
    var name = _parent.find('[name="name"]').val();
    /* button loading */
    button_status(_this, "loading");
    $.post(api['admin/themes'] + "?do=check", { 'name': name }, function (response) {
      /* button reset */
      button_status(_this, "reset");
      /* handle response */
      if (response.error) {
        if (success.is(":visible")) success.hide();
        error.html(response.message).slideDown();
      } else if (response.success) {
        if (error.is(":visible")) error.hide();
        success.html(response.message).slideDown();
      } else {
        eval(response.callback);
      }
    }, 'json')
      .fail(function () {
        /* button reset */
        button_status(_this, "reset");
        /* handle error */
        if (success.is(":visible")) success.hide();
        error.html(__['There is something that went wrong!']).slideDown();
      });
  });


  // theme bottom bar
  if (typeof Sortable === 'function') {
    $('.js_bottom-bar-list').each(function () {
      var shown = $(this).hasClass('js_bottom-bar-shown');
      Sortable.create(this, {
        group: {
          name: 'bottom-bar',
          put: function (to) {
            return !shown || to.el.children.length < 5;
          },
          pull: function (to, from, item) {
            return !(shown && $(item).data('key') == 'menu');
          }
        },
        animation: 150
      });
    });
  }


  // theme sidebar
  if (typeof Sortable === 'function') {
    $('.js_sidebar-list').each(function () {
      Sortable.create(this, {
        group: 'sidebar',
        animation: 150,
        onAdd: function (event) {
          $(event.item).find('input').attr('name', $(event.to).data('name'));
        }
      });
    });
  }


  // theme landing pages
  $('body').on('click', '.js_add-theme-landing', function () {
    var index = Date.now();
    var html = $('#theme-landing-row-template').html().replace(/__INDEX__/g, index);
    $('.js_theme-landings').append(html);
  });
  $('body').on('click', '.js_remove-theme-landing', function () {
    var row = $(this).closest('.js_theme-landing-row');
    var option = $('.js_theme-landing-option[data-landing-index="' + row.data('landing-index') + '"]');
    var was_active = option.find('input[name="landing"]').is(':checked');
    option.remove();
    row.remove();
    if (was_active) {
      $('.js_theme-landing-option input[name="landing"][value="default"]').prop('checked', true);
    }
  });
  $('body').on('change', '.js_theme-landing-option input[name="landing"]', function () {
    var index = $(this).closest('.js_theme-landing-option').data('landing-index');
    $('.js_theme-landing-badge').addClass('hidden');
    $('.js_theme-landing-row[data-landing-index="' + index + '"]').find('.js_theme-landing-badge').removeClass('hidden');
  });
  $('body').on('input', '.js_theme-landing-slug', function () {
    var row = $(this).closest('.js_theme-landing-row');
    var slug = $(this).val();
    var option = $('.js_theme-landing-option[data-landing-index="' + row.data('landing-index') + '"]');
    option.find('input[name="landing"]').val(slug);
  });
  var theme_landing_thumb_set = function (carousel, mode) {
    carousel.attr('data-thumb-mode', mode);
    carousel.find('.js_theme-landing-thumb-mode').attr('aria-label', mode === 'dark' ? __['Day Mode'] : __['Night Mode']);
  };
  $('body').on('click', '.js_theme-landing-thumb-mode', function (e) {
    e.preventDefault();
    e.stopPropagation();
    e.stopImmediatePropagation();
    var carousel = $(this).closest('.js_theme-landing-thumbs');
    var next = carousel.attr('data-thumb-mode') === 'dark' ? 'light' : 'dark';
    theme_landing_thumb_set(carousel, next);
  });
  $('body').on('click', '.js_theme-mode', function () {
    var is_night = (document.documentElement.getAttribute('data-theme') || '').endsWith('-dark');
    $('.js_theme-landing-thumbs').each(function () {
      theme_landing_thumb_set($(this), is_night ? 'dark' : 'light');
    });
  });


  // offset pad
  function offset_pad_set(pad, x, y) {
    x = Math.min(100, Math.max(0, Math.round(x))) || 0;
    y = Math.min(100, Math.max(0, Math.round(y))) || 0;
    pad.find('.js_offset-pad-x-input').val(x);
    pad.find('.js_offset-pad-y-input').val(y);
    pad.find('.js_offset-pad-x').text(x);
    pad.find('.js_offset-pad-y').text(y);
    pad.find('.js_offset-pad-thumb').css({
      left: x + '%',
      top: y + '%',
      transform: 'translate(-' + x + '%, -' + y + '%)'
    });
  }
  function offset_pad_pointer(pad, event) {
    var area = pad.find('.js_offset-pad-area')[0];
    var thumb = pad.find('.js_offset-pad-thumb')[0];
    var rect = area.getBoundingClientRect();
    var space_x = area.clientWidth - thumb.offsetWidth;
    var space_y = area.clientHeight - thumb.offsetHeight;
    var left = event.clientX - rect.left - area.clientLeft - thumb.offsetWidth / 2;
    var top = event.clientY - rect.top - area.clientTop - thumb.offsetHeight / 2;
    offset_pad_set(pad, left / space_x * 100, top / space_y * 100);
  }
  $('body').on('pointerdown', '.js_offset-pad-area', function (e) {
    this.setPointerCapture(e.originalEvent.pointerId);
    $(this).data('dragging', true).trigger('focus');
    offset_pad_pointer($(this).closest('.js_offset-pad'), e.originalEvent);
  });
  $('body').on('pointermove', '.js_offset-pad-area', function (e) {
    if (!$(this).data('dragging')) return;
    offset_pad_pointer($(this).closest('.js_offset-pad'), e.originalEvent);
  });
  $('body').on('pointerup pointercancel', '.js_offset-pad-area', function () {
    $(this).data('dragging', false);
  });
  $('body').on('keydown', '.js_offset-pad-area', function (e) {
    var pad = $(this).closest('.js_offset-pad');
    var x = parseInt(pad.find('.js_offset-pad-x-input').val(), 10) || 0;
    var y = parseInt(pad.find('.js_offset-pad-y-input').val(), 10) || 0;
    var moves = { ArrowLeft: [-1, 0], ArrowRight: [1, 0], ArrowUp: [0, -1], ArrowDown: [0, 1] };
    if (!moves[e.key]) return;
    e.preventDefault();
    var step = (e.shiftKey) ? 10 : 1;
    offset_pad_set(pad, x + moves[e.key][0] * step, y + moves[e.key][1] * step);
  });
  $('body').on('click', '.js_offset-pad-reset', function () {
    var pad = $(this).closest('.js_offset-pad');
    offset_pad_set(pad, parseInt(pad.data('default-x'), 10), parseInt(pad.data('default-y'), 10));
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


  // license: verify and enable monetization module
  $('body').on('click', '.js_admin-license-enable', function (e) {
    e.preventDefault();
    var _this = $(this);
    if (_this.prop('disabled') || _this.data('loading')) {
      return;
    }
    _this.data('loading', true);
    button_status(_this, "loading");
    $.post(api['admin/license'], { 'do': 'enable' }, function (response) {
      button_status(_this, "reset");
      _this.data('loading', false);
      if (response.error) {
        show_error_modal(response.message);
      } else if (response.callback) {
        eval(response.callback);
      } else {
        window.location.reload();
      }
    }, 'json')
      .fail(function () {
        button_status(_this, "reset");
        _this.data('loading', false);
        show_error_modal();
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
          show_error_modal();
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
          show_error_modal();
        });
    });
  });


  // admin verification
  $('body').on('click', '.js_admin-verification-documents', function () {
    var is_page = ($(this).data('handle') == 'page') ? true : false;
    modal('#verification-documents', { 'is_page': is_page, 'photo': $(this).data('photo'), 'passport': $(this).data('passport'), 'website': $(this).data('business-website'), 'address': $(this).data('business-address'), 'message': $(this).data('message'), 'handle': $(this).data('handle'), 'node-id': $(this).data('node-id'), 'request-id': $(this).data('request-id') }, 'large');
  });
  $('body').on('click', '.js_admin-verify', function () {
    var $this = $(this);
    var handle = $this.data('handle');
    var id = $this.data('id');
    confirm(__['Verify'], __['Are you sure you want to verify this request?'], function () {
      $.post(api['admin/verify'], { 'do': 'approve', 'handle': handle, 'id': id }, function (response) {
        /* check the response */
        if (response.callback) {
          eval(response.callback);
        } else {
          modal_close_all();
          remove_verification_request($this);
        }
      }, 'json')
        .fail(function () {
          show_error_modal();
        });
    });
  });
  $('body').on('click', '.js_admin-unverify', function () {
    var $this = $(this);
    var handle = $this.data('handle');
    var id = $this.data('id');
    confirm(__['Decline'], __['Are you sure you want to decline this request?'], function () {
      $.post(api['admin/verify'], { 'do': 'decline', 'handle': handle, 'id': id }, function (response) {
        /* check the response */
        if (response.callback) {
          eval(response.callback);
        } else {
          modal_close_all();
          remove_verification_request($this);
        }
      }, 'json')
        .fail(function () {
          show_error_modal();
        });
    });
  });
  function remove_verification_request($button) {
    var $row = $('.admin-verification-row[data-request-id="' + $button.closest('.admin-verification-row').data('request-id') + '"]');
    if ($row.length) {
      $row.fadeOut(250, function () {
        $row.remove();
        if (!$('.admin-verification-row').length) {
          window.location.reload();
        }
      });
    } else {
      window.location.reload();
    }
  }


  // admin ads
  $('body').on('click', '.js_ads-approve', function () {
    var id = $(this).data('id');
    confirm(__['Verify'], __['Are you sure you want to verify this request?'], function () {
      $.post(api['admin/ads_campaigns'], { 'do': "approve", 'id': id }, function (response) {
        /* check the response */
        if (response.callback) {
          eval(response.callback);
        } else {
          window.location.reload();
        }
      }, 'json')
        .fail(function () {
          show_error_modal();
        });
    });
  });
  $('body').on('click', '.js_ads-decline', function () {
    var id = $(this).data('id');
    confirm(__['Decline'], __['Are you sure you want to decline this request?'], function () {
      $.post(api['admin/ads_campaigns'], { 'do': 'decline', 'id': id }, function (response) {
        /* check the response */
        if (response.callback) {
          eval(response.callback);
        } else {
          window.location.reload();
        }
      }, 'json')
        .fail(function () {
          show_error_modal();
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
          show_error_modal();
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
          show_error_modal();
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
          show_error_modal();
        });
    });
  });


  // announcement preview
  if ($('.js_announcement-form').length > 0) {
    var announcementPreviewPlaceholder = $('.js_announcement-preview-body').text();
    var announcementPreviewTypes = {
      success: 'border-success/20 bg-success/10',
      warning: 'border-warning/25 bg-warning/10',
      danger: 'border-error/20 bg-error/10',
      info: 'border-info/20 bg-info/10'
    };
    var announcementPreviewTones = $.map(announcementPreviewTypes, function (value) { return value; }).join(' ');

    function sanitizeAnnouncementPreview(content) {
      var parsed = new DOMParser().parseFromString('<div>' + content + '</div>', 'text/html');
      var container = parsed.body.firstElementChild;
      if (!container) {
        return '';
      }
      container.querySelectorAll('script, style, iframe, object, embed, link, meta, base, form, dialog, template').forEach(function (element) {
        element.remove();
      });
      container.querySelectorAll('*').forEach(function (element) {
        Array.from(element.attributes).forEach(function (attribute) {
          var name = attribute.name.toLowerCase();
          var value = attribute.value.trim().toLowerCase();
          var compactValue = value.replace(/[\u0000-\u0020]/g, '');
          if (name === 'style' || name === 'class' || name === 'id' || name === 'srcdoc' || name === 'autofocus' || name === 'contenteditable' || name.indexOf('on') === 0 || ((name === 'href' || name === 'src' || name === 'formaction') && compactValue.indexOf('javascript:') === 0)) {
            element.removeAttribute(attribute.name);
          }
        });
      });
      return container.innerHTML;
    }

    function updateAnnouncementPreview() {
      var type = $('.js_announcement-type').val();
      if (!announcementPreviewTypes[type]) {
        type = 'info';
      }
      var title = $('.js_announcement-title').val().trim();
      var content = $('.js_announcement-content').val();
      if (typeof tinymce !== 'undefined') {
        var editor = tinymce.get('announcement-content');
        if (editor) {
          content = editor.getContent();
        }
      }

      $('.js_announcement-preview')
        .removeClass(announcementPreviewTones)
        .addClass(announcementPreviewTypes[type]);
      $('.js_announcement-preview-title').text(title).toggle(title !== '');
      $('.js_announcement-preview-body').html(sanitizeAnnouncementPreview(content) || announcementPreviewPlaceholder);
    }

    function bindAnnouncementEditor(editor) {
      if (!editor || editor.id !== 'announcement-content' || editor.announcementPreviewBound) {
        return;
      }
      editor.announcementPreviewBound = true;
      editor.on('init input change undo redo', updateAnnouncementPreview);
    }

    $('body').on('input change', '.js_announcement-title, .js_announcement-type, .js_announcement-content', updateAnnouncementPreview);
    if (typeof tinymce !== 'undefined') {
      tinymce.on('AddEditor', function (event) {
        bindAnnouncementEditor(event.editor);
      });
      bindAnnouncementEditor(tinymce.get('announcement-content'));
    }
    updateAnnouncementPreview();
  }


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
      $('.js_pattern-preview').css("backgroundImage", "url(" + uploads_path + "/" + $('#pattern-background-image').val() + ")");

    }
  });
  $('.js_pattern-background-color-1').on('change', function () {
    $('.js_pattern-preview').css("backgroundImage", "linear-gradient(45deg, " + $(this).val() + ", " + $('.js_pattern-background-color-2').val() + ")");
  });
  $('.js_pattern-background-color-2').on('change', function () {
    $('.js_pattern-preview').css("backgroundImage", "linear-gradient(45deg, " + $('.js_pattern-background-color-1').val() + ", " + $(this).val() + ")");
  });
  $('#pattern-background-image').on('change propertychange', function () {
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
    /* show hide divs with affiliates-levels-2 & affiliates-levels-3 ... etc to 10 */
    var level = $(this).val();
    $('#affiliates-levels-2').hide();
    $('#affiliates-levels-3').hide();
    $('#affiliates-levels-4').hide();
    $('#affiliates-levels-5').hide();
    $('#affiliates-levels-6').hide();
    $('#affiliates-levels-7').hide();
    $('#affiliates-levels-8').hide();
    $('#affiliates-levels-9').hide();
    $('#affiliates-levels-10').hide();
    if (level >= 2) $('#affiliates-levels-2').fadeIn();
    if (level >= 3) $('#affiliates-levels-3').fadeIn();
    if (level >= 4) $('#affiliates-levels-4').fadeIn();
    if (level >= 5) $('#affiliates-levels-5').fadeIn();
    if (level >= 6) $('#affiliates-levels-6').fadeIn();
    if (level >= 7) $('#affiliates-levels-7').fadeIn();
    if (level >= 8) $('#affiliates-levels-8').fadeIn();
    if (level >= 9) $('#affiliates-levels-9').fadeIn();
    if (level >= 10) $('#affiliates-levels-10').fadeIn();
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
          show_error_modal();
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
          show_error_modal();
        });
    }, true);
  });

});
