class JavascriptsController < ApplicationController
  def i18n
    cache_for 2.hours
  end
  
  def five_min
    if stale?(fresh_options(Observation.last)) then
      n = 1.day / 5.minutes
      @observations = Observation.all :limit => n, :offset => (Observation.count - n)
    end
  end
  
  private
  # just to dry up all my public caches
  def cache_for(time)
    expires_in time, :public => true
  end
  
  def fresh_options(object)
    { :etag => object, :public => true, :last_modified => object.created_at.utc }
  end
end
