class Fetch < ActiveRecord::Base
	belongs_to :observation # the most recent observation at this fetch
	
	def self.start!; create!; end
	
	after_create :spawn_and_fetch
	def spawn_and_fetch
		spawn do
			self.update_attribute :start_at, Time.current
						
			Gather.bellingham_coldstorage_observations!

			self.finish_at = Time.current
			self.observation = Observation.last
			self.save
		end
	end
end
