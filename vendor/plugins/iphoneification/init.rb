require 'iphoneification'

# iPhones really get plain old HTML, but we need a way to distinguish them from regular browsers.
Mime::Type.register_alias "text/html", :iphone

if defined?(ActionController::Base)
  ActionController::Base.send(:extend, IPhoneification::ClassMethods)
  ActionController::Base.send(:include, IPhoneification::InstanceMethods)
end