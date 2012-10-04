class Observation < ActiveRecord::Base
  attr_accessible :barometer, :created_at, :dew_point, :hi_dir, :hi_speed, :hi_temp, :humidity, :low_temp, :observed_at, :rain, :temp, :updated_at, :wind_chill, :wind_dir, :wind_run, :wind_speed

  def self.prune!
    max = 9000
    if count > max
      # Trust regular order
      Observation.limit(count - max).destroy_all
    end
  end

  cattr_accessor :displayed_attributes, :other_attributes
  @@displayed_attributes = %w( wind_speed hi_speed temp barometer humidity wind_chill dew_point rain )
  @@other_attributes = { wind_speed: :wind_dir, hi_speed: :hi_dir }

  def self.current_barometer_direction
    recent_barometer_average = where(observed_at: (last.observed_at - 6.hours)..last.observed_at).average :barometer
    last.barometer < recent_barometer_average ? :down : :up
  end

  def self.need_fetch?
    return true unless Observation.any?
    Observation.select('id, observed_at').last.observed_at < 7.minutes.ago
  end

  def rain
    r = read_attribute(:rain)
    r * 25.4 if r # To MM
  end

  # Theoretically shared


  scope :only_id, select('id')
  scope :only_time, select('id, observed_at')
  validates_presence_of :observed_at

  # if base != Observation then
  #   def base.displayed_attributes
  #     Observation.displayed_attributes
  #   end

  #   def base.other_attributes
  #     Observation.other_attributes
  #   end
  # end

  def self.observed_at(where, options = {})
    only_time.send(where, options).try(:observed_at)
  end

  # class setter getters

  def self.period(p = nil)
    p.nil? ? @period : @period = p
  end

  def self.zoom(t = nil)
    t.nil? ? @zoom : @zoom = t
  end


  def observed_at_for_flot
    observed_at.to_i * 1000
  end

  def attribute_pair_for_plot(attribute)
    [ self.observed_at_for_flot, self.send(attribute) ]
  end



  period 5.minutes
  zoom 1.day

end
