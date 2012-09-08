class ApplicationController < ActionController::Base
  protect_from_forgery

  layout :no_layout_for_xhr

  private
  def no_layout_for_xhr
    request.xhr? ? nil : 'application'
  end

  # just to dry up all my public caches
  def cache_for(time)
    expires_in time, :public => true
  end

  def fresh_options(object)
    { :etag => object, :public => true, :last_modified => object.observed_at.utc }
  end

  def mobile_domain?
    %w(m mobile).include? request.subdomains.first
  end
end
