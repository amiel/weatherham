# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include Spreadhead::Render
  include AuthenticationHandling
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password, :password_confirmation
  
  
  
  private
  # just to dry up all my public caches
  def cache_for(time)
    expires_in time, :public => true
  end
  
  def fresh_options(object)
    { :etag => object, :public => true, :last_modified => object.created_at.utc }
  end
end
