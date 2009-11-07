class Observation < ActiveRecord::Base
	validates_presence_of :observed_at
	
	def to_h
		returning hash = attributes.reject {|k,v| k == 'created_at' || k == 'updated_at' } do
			hash['observed_at'] = hash['observed_at'].to_i * 1000
		end
	end
end
