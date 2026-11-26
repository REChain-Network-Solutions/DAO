/**
 * media js
 * 
 * @package Sngine
 * @author Zamblek
 */

// movies hero slider
function media_hero_slider() {
  var roots = document.querySelectorAll('.js_hero-slider');
  if (!roots.length) {
    return;
  }

  var reduced = window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches;

  function build(root) {
    var track = root.querySelector('.js_hero-slider-track');
    var dots_box = root.querySelector('.js_hero-slider-dots');
    var slides = track ? Array.prototype.slice.call(track.children) : [];
    if (!track || slides.length === 0) {
      return;
    }

    var total = slides.length;
    var index = 0;
    var rtl = document.documentElement.getAttribute('dir') === 'rtl';
    var speed = parseInt(root.getAttribute('data-speed'), 10) || 7000;
    var timer = null;
    var dots = [];

    // build dots
    var dot_class = root.getAttribute('data-dot-class') || 'size-1.5 cursor-pointer rounded-full bg-base-content/30 transition-all duration-300 aria-[current=true]:size-2.5 aria-[current=true]:bg-base-content';
    if (dots_box && total > 1) {
      for (var i = 0; i < total; i++) {
        var dot = document.createElement('button');
        dot.type = 'button';
        dot.className = dot_class;
        dot.setAttribute('aria-label', (dots_box.getAttribute('data-label') || 'Slide') + ' ' + (i + 1));
        dot.addEventListener('click', (function (n) {
          return function () {
            go(n);
            restart();
          };
        })(i));
        dots_box.appendChild(dot);
        dots.push(dot);
      }
    }

    function render() {
      for (var i = 0; i < total; i++) {
        var pos = (i - index + total) % total;
        var name = 'off';
        if (pos === 0) {
          name = 'active';
        } else if (pos === 1) {
          name = 'stack1';
        } else if (pos === 2) {
          name = 'stack2';
        } else if (pos === total - 1) {
          /* outgoing slide */
          name = 'out';
        }
        slides[i].setAttribute('data-pos', name);
        slides[i].setAttribute('aria-hidden', pos === 0 ? 'false' : 'true');
      }
      for (var d = 0; d < dots.length; d++) {
        dots[d].setAttribute('aria-current', d === index ? 'true' : 'false');
      }
    }

    function go(n) {
      index = ((n % total) + total) % total;
      render();
    }

    function next() {
      go(index + 1);
    }

    function prev() {
      go(index - 1);
    }

    function start() {
      if (total > 1 && !timer && !reduced) {
        timer = setInterval(next, speed);
      }
    }

    function stop() {
      if (timer) {
        clearInterval(timer);
        timer = null;
      }
    }

    function restart() {
      stop();
      start();
    }

    // drag
    var dragging = false;
    var captured = false;
    var start_x = 0;
    var moved = 0;

    function drag_start(e) {
      if (total < 2 || (e.button !== undefined && e.button !== 0)) {
        return;
      }
      dragging = true;
      captured = false;
      moved = 0;
      start_x = e.clientX;
    }

    function drag_move(e) {
      if (!dragging) {
        return;
      }
      moved = e.clientX - start_x;
      if (rtl) {
        moved = -moved;
      }
      /* start drag */
      if (!captured && Math.abs(moved) > 5) {
        captured = true;
        if (track.setPointerCapture && e.pointerId !== undefined) {
          try {
            track.setPointerCapture(e.pointerId);
          } catch (err) { }
        }
        track.classList.add('cursor-grabbing');
        track.style.transition = 'none';
        stop();
      }
      if (!captured) {
        return;
      }
      var damped = Math.max(-60, Math.min(60, moved * 0.3));
      track.style.transform = 'translateX(' + (rtl ? -damped : damped) + 'px)';
    }

    function drag_end(e) {
      if (!dragging) {
        return;
      }
      dragging = false;
      if (captured) {
        if (track.releasePointerCapture && e && e.pointerId !== undefined) {
          try {
            track.releasePointerCapture(e.pointerId);
          } catch (err) { }
        }
        track.classList.remove('cursor-grabbing');
        track.style.transition = '';
        track.style.transform = '';
        if (Math.abs(moved) > 40) {
          if (moved < 0) {
            next();
          } else {
            prev();
          }
        }
        start();
      }
      captured = false;
    }

    /* skip click after drag */
    track.addEventListener('click', function (e) {
      if (Math.abs(moved) > 5) {
        e.preventDefault();
        e.stopPropagation();
        moved = 0;
      }
    }, true);

    if (window.PointerEvent) {
      track.addEventListener('pointerdown', drag_start);
      track.addEventListener('pointermove', drag_move);
      track.addEventListener('pointerup', drag_end);
      track.addEventListener('pointercancel', drag_end);
    } else {
      track.addEventListener('mousedown', drag_start);
      document.addEventListener('mousemove', drag_move);
      document.addEventListener('mouseup', drag_end);
    }

    track.addEventListener('dragstart', function (e) {
      e.preventDefault();
    });

    // keyboard
    root.addEventListener('keydown', function (e) {
      if (e.key === 'ArrowRight') {
        rtl ? prev() : next();
        restart();
      } else if (e.key === 'ArrowLeft') {
        rtl ? next() : prev();
        restart();
      }
    });

    // pause
    root.addEventListener('mouseenter', stop);
    root.addEventListener('mouseleave', start);
    document.addEventListener('visibilitychange', function () {
      if (document.hidden) {
        stop();
      } else {
        start();
      }
    });

    render();
    start();
  }

  for (var i = 0; i < roots.length; i++) {
    build(roots[i]);
  }
}


// movies genres scroller
function media_chips_scroller() {
  var rows = document.querySelectorAll('.js_chips');
  if (!rows.length) {
    return;
  }

  function build(row) {
    var strip = row.querySelector('.js_chips-strip');
    var nav = row.querySelector('.js_chips-nav');
    var prev = row.querySelector('.js_chips-prev');
    var next = row.querySelector('.js_chips-next');
    if (!strip) {
      return;
    }

    var rtl = document.documentElement.getAttribute('dir') === 'rtl';

    function max_scroll() {
      return strip.scrollWidth - strip.clientWidth;
    }

    function update() {
      var max = max_scroll();
      var pos = Math.abs(strip.scrollLeft);
      if (nav) {
        nav.setAttribute('data-scrollable', max > 1 ? 'true' : 'false');
        max = max_scroll();
      }
      if (prev) {
        prev.disabled = pos <= 1;
      }
      if (next) {
        next.disabled = pos >= max - 1;
      }
    }

    function scroll(direction) {
      var step = Math.max(160, Math.round(strip.clientWidth * 0.8));
      strip.scrollBy({ left: step * direction * (rtl ? -1 : 1), behavior: 'smooth' });
    }

    if (prev) {
      prev.addEventListener('click', function () {
        scroll(-1);
      });
    }
    if (next) {
      next.addEventListener('click', function () {
        scroll(1);
      });
    }
    strip.addEventListener('scroll', update);
    window.addEventListener('resize', update);

    update();

    /* scroll to current */
    var current = strip.querySelector('[aria-current="page"]');
    var target = 0;
    if (current && current !== strip.firstElementChild) {
      var current_rect = current.getBoundingClientRect();
      var strip_rect = strip.getBoundingClientRect();
      target = strip.scrollLeft + current_rect.left - strip_rect.left + (current_rect.width - strip.clientWidth) / 2;
      var max = max_scroll();
      target = rtl ? Math.max(-max, Math.min(0, target)) : Math.max(0, Math.min(max, target));
    }
    strip.scrollTo({ left: target, behavior: 'instant' });

    update();
  }

  for (var i = 0; i < rows.length; i++) {
    build(rows[i]);
  }
}


// init
media_hero_slider();
media_chips_scroller();
