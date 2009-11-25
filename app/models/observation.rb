class Observation < ActiveRecord::Base
  validates_presence_of :observed_at
  cattr_accessor :displayed_attributes, :other_attributes
  @@displayed_attributes = %w( wind_speed hi_speed temp barometer humidity )
  @@other_attributes = %w( wind_dir hi_dir )


  def self.need_fetch?
    return true unless Observation.first
    Observation.last.observed_at < 55.minutes.ago
  end

  def observed_at_for_js
    observed_at.to_i * 1000
  end
  alias_method :observed_at_for_json, :observed_at_for_js


  def attribute_pair_for_plot(attribute)
    [ self.observed_at_for_js, self[attribute] ]
  end
end
