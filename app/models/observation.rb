class Observation < ActiveRecord::Base
  validates_presence_of :observed_at

  def self.need_fetch?
    return true unless Observation.first
    Observation.last.observed_at < 55.minutes.ago
  end

  def to_h
    returning hash = attributes.reject {|k,v| k == 'created_at' || k == 'updated_at' } do
      hash['observed_at'] = hash['observed_at'].to_i * 1000
    end
  end

  def observed_at_for_js
    observed_at.to_i * 1000
  end


  def attribute_for_plot(attribute)
    [ self.observed_at_for_js, self[attribute] ]
  end
end
