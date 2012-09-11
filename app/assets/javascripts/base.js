/*
 * base.js
 * Amiel Martin
 * 2009-10-14
 */

// base.js provides some useful functions for global use under the namespace Base,
// as well as a namespace for variables to be registered from the server


var Base = {};

// register a variable for use within the Base namespace
// there is an optional scope
// You may want to use the +js_var+ helper found in javascript_helper.rb
Base.register_variable = function(key, value, scope) {
    if (scope) {
        if (typeof Base[scope] === "undefined") Base[scope] = {};
        Base[scope][key] = value;
    } else {
        Base[key] = value;
    }
};
Base.reg = Base.register_variable;

Base.initializers = {};

Base.init = function() {
  if (arguments.length == 1) {
    var to_init = arguments[0],
      scope = $(to_init).not('.initialized').addClass('initialized');
    $.each(Base.initializers[to_init], function(i, f) { f.apply(scope); });
  } else {
    var collection = (arguments.length === 0) ? Base.initializers : arguments;
    $.each(collection, function(i, e) { if (typeof i === 'string') Base.init(i); else Base.init(e); });
  }
};

Base.register_initializer = function(scope, lambda) {
  if (!Base.initializers[scope]) Base.initializers[scope] = [];
  Base.initializers[scope].push(lambda);
};

$(function(){ Base.init(); });



// the following section provides an abstraction to the Firebug console
//
// you may want to do something like this: <% js_var :DEBUG, !Rails.env.production? %>


// apply is used way to much here //

// log to the firebug console if window.console is available
Base.console = function(method) {
  if (Base.DEBUG && window.console && window.console[method])
    if ($.browser.mozilla)
      window.console[method].apply(null, Array.prototype.slice.apply(arguments, [1]));
    else
      window.console[method](arguments);
};


// trace ajax operations when "App.DEBUG == true"
if (Base.DEBUG) $(window).bind("ajaxStart ajaxSend ajaxComplete ajaxSuccess", Base.console.debug);
