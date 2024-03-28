/*!
 * froala_editor v2.9.3 (https://www.froala.com/wysiwyg-editor)
 * License https://froala.com/wysiwyg-editor/terms/
 * Copyright 2014-2019 Froala Labs
 */

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

  

  $.FE.PLUGINS.quote = function (editor) {
    function _deepestParent(node) {
      while (node.parentNode && node.parentNode != editor.el) {
        node = node.parentNode;
      }

      return node;
    }

    function _increase () {

      // Get blocks.
      var blocks = editor.selection.blocks();
      var i;

      // Normalize blocks.
      for (i = 0; i < blocks.length; i++) {
        blocks[i] = _deepestParent(blocks[i]);
      }

      // Save selection to restore it later.
      editor.selection.save();

      var $quote = $('<blockquote>');
      $quote.insertBefore(blocks[0]);

      for (i = 0; i < blocks.length; i++) {
        $quote.append(blocks[i]);
      }

      // Unwrap temp divs.
      editor.html.unwrap();

      editor.selection.restore();
    }

    function _decrease () {

      // Get blocks.
      var blocks = editor.selection.blocks();
      var i;

      for (i = 0; i < blocks.length; i++) {
        if (blocks[i].tagName != 'BLOCKQUOTE') {
          blocks[i] = $(blocks[i]).parentsUntil(editor.$el, 'BLOCKQUOTE').get(0);
        }
      }

      editor.selection.save();

      for (i = 0; i < blocks.length; i++) {
        if (blocks[i]) {
          $(blocks[i]).replaceWith(blocks[i].innerHTML);
        }
      }

      // Unwrap temp divs.
      editor.html.unwrap();

      editor.selection.restore();
    }

    function apply (val) {

      // Wrap.
      editor.selection.save();
      editor.html.wrap(true, true, true, true);
      editor.selection.restore();

      if (val == 'increase') {
        _increase();
      }
      else if (val == 'decrease') {
        _decrease();
      }


    }

    return {
      apply: apply
    }
  }

  // Register the quote command.
  $.FE.RegisterShortcut($.FE.KEYCODE.SINGLE_QUOTE, 'quote', 'increase', '\'');
  $.FE.RegisterShortcut($.FE.KEYCODE.SINGLE_QUOTE, 'quote', 'decrease', '\'', true);
  $.FE.RegisterCommand('quote', {
    title: 'Quote',
    type: 'dropdown',
    html: function () {
      var c = '<ul class="fr-dropdown-list" role="presentation">';
      var options =  {
        increase: 'Increase',
        decrease: 'Decrease'
      };

      for (var val in options) {
        if (options.hasOwnProperty(val)) {
          var shortcut = this.shortcuts.get('quote.' + val);

          c += '<li role="presentation"><a class="fr-command fr-active ' + val + '" tabIndex="-1" role="option" data-cmd="quote" data-param1="' + val + '" title="' + options[val] + '">' + this.language.translate(options[val]) + (shortcut ? '<span class="fr-shortcut">' + shortcut + '</span>' : '') + '</a></li>';
        }
      }
      c += '</ul>';

      return c;
    },
    callback: function (cmd, val) {
      this.quote.apply(val);
    },
    plugin: 'quote'
  })

  // Add the quote icon.
  $.FE.DefineIcon('quote', {
    NAME: 'quote-left'
  });

}));
