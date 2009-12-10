module IPhoneification
  
  # Class methods are added to ActionController::Base so you can do:
  #
  #   class ApplicationController < ActionController::Base
  #     responds_to_iphone
  #     ...
  #   end
  #
  # Use +responds_to_iphone!+ (with the bang) instead to make your app act
  # like an Apple fanboy, always serving iPhone views even if your visitors
  # are using some other browser.
  module ClassMethods

    # #responds_to_iphone sets up the before-filter which checks for iphone requests
    # and adjusts the request format accordingly.
    #
    # You can then use +respond_to+ in your controllers to serve
    # iPhone-optimised views:
    #
    #   def index
    #     @posts = Post.all
    #     
    #     respond_to do |format|
    #       format.html   # renders posts/index.html.erb
    #       format.iphone { some_special_code_for_iphone_requests } # renders posts/index.iphone.erb
    #     end
    #   end
    #
    # Use the extension '.iphone.erb' for your iPhone views and templates.    
    #
    # ==== Options
    # Pass in any options appropriate for +before_filter+.
    def responds_to_iphone(options = {})
      before_filter :adjust_format_for_iphone_requests, options
    end
    
    # Makes a controller act like _every_ request is from an iPhone. 
    #
    # ==== Options
    # Pass in any options appropriate for +before_filter+.
    def responds_to_iphone!(options = {})
      before_filter :ensure_format_is_iphone, options
    end
    
    # Skips the iphoneification before_filter set by #responds_to_iphone or #responds_to_iphone!.
    #
    # ==== Options
    # Pass in any options appropriate for +before_filter+.
    def skip_iphone_response(options = {})
      if self.filter_chain.any? { |f| f.method == :ensure_format_is_iphone }
        skip_before_filter :ensure_format_is_iphone, options
      else
        skip_before_filter :adjust_format_for_iphone_requests, options
      end
    end
    
  end
  
  # Just some utility methods.
  module InstanceMethods
    
    private
    # Sets request.format to :iphone if request is from an iPhone.
    def adjust_format_for_iphone_requests
      set_format_to_iphone if iphone_request?
    end
    
    # Just sets format to :iphone, whatever.
    def ensure_format_is_iphone
      set_format_to_iphone # always
    end
    
    # Rails uses request.format in +respond_to+ blocks, and other places: 
    # this is where the magic happens.
    def set_format_to_iphone
      request.format = :iphone
    end

    # This method looks at the browser's user-agent string to determine
    # whether or not the current request is from an iPhone (or iPod Touch).
    def iphone_request?
      (agent = request.env["HTTP_USER_AGENT"]) && agent[/(Mobile\/.+Safari)/]
    end
    
  end
end