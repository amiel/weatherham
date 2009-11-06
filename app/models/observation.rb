class Observation < ActiveRecord::Base
	validates_presence_of :observed_at
end
