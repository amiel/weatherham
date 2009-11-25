class Observation < ActiveRecord::Base
  validates_presence_of :observed_at
  cattr_accessor :displayed_attributes
  @@displayed_attributes = %w(wind_speed hi_speed temp barometer humidity wind_dir hi_dir)

  def self.need_fetch?
    return true unless Observation.first
    Observation.last.observed_at < 55.minutes.ago
  end
  # 
  # def to_h
  #   returning hash = attributes.reject {|k,v| k == 'created_at' || k == 'updated_at' } do
  #     hash['observed_at'] = hash['observed_at'].to_i * 1000
  #   end
  # end

  def to_h
    self.class.displayed_attributes.each_with_object({}) do |attr, hash|
      hash[attr] = self[attr]
    end
  end

  def observed_at_for_js
    observed_at.to_i * 1000
  end
  alias_method :observed_at_for_json, :observed_at_for_js


  def attribute_pair_for_plot(attribute)
    [ self.observed_at_for_js, self[attribute] ]
  end
end
