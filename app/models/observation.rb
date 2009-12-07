class Observation < ActiveRecord::Base
  validates_presence_of :observed_at
  cattr_accessor :displayed_attributes, :other_attributes
  @@displayed_attributes = %w( wind_speed hi_speed temp barometer humidity )
  @@other_attributes = { :wind_speed => :wind_dir, :hi_speed => :hi_dir, :temp => :wind_chill }


  def self.need_fetch?
    return true unless Observation.first
    Observation.last.observed_at < 55.minutes.ago
  end

  def observed_at_for_flot
    observed_at.to_i * 1000
  end

  def attribute_pair_for_plot(attribute)
    [ self.observed_at_for_flot, self[attribute] ]
  end
end
