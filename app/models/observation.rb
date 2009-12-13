class Observation < ActiveRecord::Base
  include ObservationMixin
  period 5.minutes
  
  cattr_accessor :displayed_attributes, :other_attributes
  @@displayed_attributes = %w( wind_speed hi_speed temp barometer humidity wind_chill dew_point )
  @@other_attributes = { :wind_speed => :wind_dir, :hi_speed => :hi_dir }

  def self.current_barometer_direction
    recent_barometer_average = average :barometer, :conditions => { :observed_at => (last.observed_at - 6.hours)..last.observed_at }
    last.barometer < recent_barometer_average ? :down : :up
  end

  def self.need_fetch?
    return true unless Observation.first :select => 'id'
    Observation.last(:select => 'id, observed_at').observed_at < 35.minutes.ago
  end
end
