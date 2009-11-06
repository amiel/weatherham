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

// TODO: write Base.flash
// This is from Emmanuel Gomez, thanks
// JS response type on the server puts flash messages as JSON in X-JSON-FLASH
// Global AJAX config to display AJAX flash:
$(window).ajaxComplete(function(e, xhr) {
  var flash_messages = xhr.getResponseHeader("X-JSON-FLASH");
  if (flash_messages) {
    // FIXME: shouldn't be so naive about eval'ing server response header
    //  'correct' solution is probably to use json2.js from json.org
    flash_messages = window.eval("("+ flash_messages +")");
    $.each(flash_messages, function(status, msg) {
      Base.flash(msg, status);
    });
  }
});


// the following section provides an abstraction to the Firebug console
//
// you may want to do something like this: <% js_var :DEBUG, !Rails.env.production? %>


// apply is used way to much here //

// log to the firebug console if window.console is available
Base.console = function(method) {
	if (Base.DEBUG && window.console && window.console[method])
		window.console[method].apply(null, Array.prototype.slice.apply(arguments, [1]));
};

// methods for logging
// this gives us Base.log, Base.console.log, Base.debug, etc
(function(methods){
	for (i in methods)
		(function(method_name){
			Base[method_name] = function() {
				if (Base.DEBUG) Base.console.apply(null, [ method_name, 'Base', "[" + (new Date).toLocaleTimeString() + "]" ].concat(Array.prototype.slice.apply(arguments)));
			};
		})(methods[i]);
})(['log', 'debug', 'info', 'warn', 'error']);

// all other firebug helpful methods
// this gives us Base.console.assert, Base.console.dir, etc
(function(methods){
	for (i in methods)
		(function(method_name){
			Base.console[method_name] = function() {
				if (Base.DEBUG) Base.console.apply(null, [ method_name ].concat(Array.prototype.slice.apply(arguments)));
			};
		})(methods[i]);
})(['log', 'debug', 'info', 'warn', 'error', 'assert', 'dir', 'dirxml', 'trace', 'group', 'groupEnd', 'time', 'timeEnd', 'profile', 'profileEnd', 'count']);


// trace ajax operations when "App.DEBUG == true"
$(window).bind("ajaxStart ajaxSend ajaxComplete ajaxSuccess", Base.debug);
