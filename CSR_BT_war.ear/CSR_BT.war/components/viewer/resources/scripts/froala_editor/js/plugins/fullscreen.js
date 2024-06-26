

(function (factory) {
    if (typeof define === 'function' && define.amd) {
        // AMD. Register as an anonymous module.
        define(['jquery'], factory);
    } else if (typeof module === 'object' && module.exports) {
        // Node/CommonJS
        module.exports = function( root, jQuery ) {
            if ( jQuery === undefined ) {
                // require('jQuery') returns a factory that requires window to
                // build a jQuery instance, we normalize how we use modules
                // that require this pattern but the window provided is a noop
                // if it's defined (how jquery works)
                if ( typeof window !== 'undefined' ) {
                    jQuery = require('jquery');
                }
                else {
                    jQuery = require('jquery')(root);
                }
            }
            return factory(jQuery);
        };
    } else {
        // Browser globals
        factory(window.jQuery);
    }
}(function ($) {

  

  $.FE.PLUGINS.fullscreen = function (editor) {
    var old_scroll;

    /**
     * Check if fullscreen mode is active.
     */
    function isActive () {
      return editor.$box.hasClass('fr-fullscreen');
    }

    /**
     * Turn fullscreen on.
     */
    var height;
    var max_height;
    var z_index;

    function _on () {
      if (editor.helpers.isIOS() && editor.core.hasFocus()) {
        editor.$el.blur();

        setTimeout(toggle, 250);

        return false;
      }

      old_scroll = editor.helpers.scrollTop();
      editor.$box.toggleClass('fr-fullscreen');
      $('body:first').toggleClass('fr-fullscreen');

      if (editor.helpers.isMobile()) {
        editor.$tb.data('parent', editor.$tb.parent());
        editor.$tb.prependTo(editor.$box);

        if (editor.$tb.data('sticky-dummy')) {
          editor.$tb.after(editor.$tb.data('sticky-dummy'));
        }
      }

      height = editor.opts.height;
      max_height = editor.opts.heightMax;
      z_index = editor.opts.zIndex;

      editor.position.refresh()

      editor.opts.height = editor.o_win.innerHeight - (editor.opts.toolbarInline ? 0 : editor.$tb.outerHeight());
      editor.opts.zIndex = 2147483641;
      editor.opts.heightMax = null;
      editor.size.refresh();

      if (editor.opts.toolbarInline) editor.toolbar.showInline();

      var $parent_node = editor.$box.parent();

      while (!$parent_node.is('body:first')) {
        $parent_node
          .data('z-index', $parent_node.css('z-index'))
          .data('width', $parent_node.css('width'))
          .data('margin', $parent_node.css('margin'))
          .data('padding', $parent_node.css('padding'))
          .data('overflow', $parent_node.css('overflow'))
          .css('z-index', '2147483640')
          .css('width', '100%')
          .css('margin', '0px')
          .css('padding', '0px')
          .css('overflow', 'visible');
        $parent_node = $parent_node.parent();
      }

      if (editor.opts.toolbarContainer) {
        editor.$box.prepend(editor.$tb);
      }

      editor.events.trigger('charCounter.update');
      editor.events.trigger('codeView.update');
      editor.$win.trigger('scroll');
    }

    /**
     * Turn fullscreen off.
     */
    function _off () {
      if (editor.helpers.isIOS() && editor.core.hasFocus()) {
        editor.$el.blur();

        setTimeout(toggle, 250);

        return false;
      }

      editor.$box.toggleClass('fr-fullscreen');
      $('body:first').toggleClass('fr-fullscreen');

      editor.$tb.prependTo(editor.$tb.data('parent'));

      if (editor.$tb.data('sticky-dummy')) {
        editor.$tb.after(editor.$tb.data('sticky-dummy'));
      }

      editor.opts.height = height;
      editor.opts.heightMax = max_height;
      editor.opts.zIndex = z_index;
      editor.size.refresh();

      $(editor.o_win).scrollTop(old_scroll)

      if (editor.opts.toolbarInline) editor.toolbar.showInline();

      editor.events.trigger('charCounter.update');

      if (editor.opts.toolbarSticky) {
        if (editor.opts.toolbarStickyOffset) {
          if (editor.opts.toolbarBottom) {
            editor.$tb
              .css('bottom', editor.opts.toolbarStickyOffset)
              .data('bottom', editor.opts.toolbarStickyOffset);
          }
          else {
            editor.$tb
              .css('top', editor.opts.toolbarStickyOffset)
              .data('top', editor.opts.toolbarStickyOffset);
          }
        }
      }

      var $parent_node = editor.$box.parent();

      while (!$parent_node.is('body:first')) {
        if ($parent_node.data('z-index')) {
          $parent_node.css('z-index', '');

          if ($parent_node.css('z-index') != $parent_node.data('z-index')) {
            $parent_node.css('z-index', $parent_node.data('z-index'));
          }
          $parent_node.removeData('z-index');
        }

        if ($parent_node.data('width')) {
          $parent_node.css('width', '');

          if ($parent_node.css('width') != $parent_node.data('width')) {
            $parent_node.css('width', $parent_node.data('width'));
          }
          $parent_node.removeData('width');
        }

        if ($parent_node.data('margin')) {
          $parent_node.css('margin', '');

          if ($parent_node.css('margin') != $parent_node.data('margin')) {
            $parent_node.css('margin', $parent_node.data('margin'));
          }
          $parent_node.removeData('margin');
        }

        if ($parent_node.data('padding')) {
          $parent_node.css('padding', '');

          if ($parent_node.css('padding') != $parent_node.data('padding')) {
            $parent_node.css('padding', $parent_node.data('padding'));
          }
          $parent_node.removeData('padding');
        }

        if ($parent_node.data('overflow')) {
          $parent_node.css('overflow', '');

          if ($parent_node.css('overflow') != $parent_node.data('overflow')) {
            $parent_node.css('overflow', $parent_node.data('overflow'));
          }
          $parent_node.removeData('overflow');
        }
        else {
          $parent_node.css('overflow', '');
          $parent_node.removeData('overflow');
        }

        $parent_node = $parent_node.parent();
      }

      if (editor.opts.toolbarContainer) {
        $(editor.opts.toolbarContainer).append(editor.$tb);
      }

      $(editor.o_win).trigger('scroll');
      editor.events.trigger('codeView.update');
    }

    /**
     * Exec fullscreen.
     */
    function toggle () {
      if (!isActive()) {
        _on();
      }
      else {
        _off();
      }

      refresh(editor.$tb.find('.fr-command[data-cmd="fullscreen"]'));
    }

    function refresh ($btn) {
      var active = isActive();

      $btn.toggleClass('fr-active', active).attr('aria-pressed', active);
      $btn.find('> *:not(.fr-sr-only)').replaceWith(!active ? editor.icon.create('fullscreen') : editor.icon.create('fullscreenCompress'));
    }

    function _init () {
      if (!editor.$wp) return false;

      editor.events.$on($(editor.o_win), 'resize', function () {
        if (isActive()) {
          _off();
          _on();
        }
      });

      editor.events.on('toolbar.hide', function () {
        if (isActive() && editor.helpers.isMobile()) return false;
      })

      editor.events.on('position.refresh', function () {
        if (editor.helpers.isIOS()) {
          return !isActive();
        }
      })

      editor.events.on('destroy', function () {

        // Exit full screen.
        if (isActive()) {
          _off();
        }
      }, true);
    }

    return {
      _init: _init,
      toggle: toggle,
      refresh: refresh,
      isActive: isActive
    }
  }

  // Register the font size command.
  $.FE.RegisterCommand('fullscreen', {
    title: 'Fullscreen',
    undo: false,
    focus: false,
    accessibilityFocus: true,
    forcedRefresh: true,
    toggle: true,
    callback: function () {
      this.fullscreen.toggle();
    },
    refresh: function ($btn) {
      this.fullscreen.refresh($btn);
    },
    plugin: 'fullscreen'
  })

  // Add the font size icon.
  $.FE.DefineIcon('fullscreen', {
    NAME: 'expand'
  });
  $.FE.DefineIcon('fullscreenCompress', {
    NAME: 'compress'
  });

}));
